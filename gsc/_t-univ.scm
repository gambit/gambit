;;============================================================================

;;; File: "_t-univ.scm"

;;; Copyright (c) 2011-2015 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2012 by Eric Thivierge, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

(define univ-enable-jump-destination-inlining? #f)
(set! univ-enable-jump-destination-inlining? #t)

(define univ-dyn-load? #f)
(set! univ-dyn-load? #f)

(define (univ-get-representation-option ctx name)
  (let ((x (assq name (ctx-options ctx))))
    (and x (pair? (cdr x)) (cadr x))))

(define (univ-procedure-representation ctx)
  (or (univ-get-representation-option ctx 'repr-procedure)
      (case (target-name (ctx-target ctx))
        ((php)
         'class)
        (else
         'host))))

(define (univ-null-representation ctx)
  (or (univ-get-representation-option ctx 'repr-null)
      (case (target-name (ctx-target ctx))
        ((js)
         'host)
        (else
         'class))))

(define (univ-void-representation ctx)
  (or (univ-get-representation-option ctx 'repr-void)
      'host))

(define (univ-eof-representation ctx)
  'class)

(define (univ-absent-representation ctx)
  'class)

(define (univ-unbound-representation ctx)
  'class)

(define (univ-optional-representation ctx)
  'class)

(define (univ-key-representation ctx)
  'class)

(define (univ-rest-representation ctx)
  'class)

(define (univ-boolean-representation ctx)
  (or (univ-get-representation-option ctx 'repr-boolean)
      'host))

(define (univ-char-representation ctx)
  'class)

(define (univ-fixnum-representation ctx)
  (or (univ-get-representation-option ctx 'repr-fixnum)
      'host))

(define (univ-flonum-representation ctx)
  (or (univ-get-representation-option ctx 'repr-flonum)
      'class))

(define (univ-vector-representation ctx)
  (or (univ-get-representation-option ctx 'repr-vector)
      (case (target-name (ctx-target ctx))
        ((php)
         'class)
        (else
         'host))))

(define (univ-u8vector-representation ctx)
  'class)

(define (univ-u16vector-representation ctx)
  'class)

(define (univ-f64vector-representation ctx)
  'class)

(define (univ-structure-representation ctx)
  'class)

(define (univ-string-representation ctx)
  (or (univ-get-representation-option ctx 'repr-string)

      'class))

(define (univ-symbol-representation ctx)
  (or (univ-get-representation-option ctx 'repr-symbol)
      (case (target-name (ctx-target ctx))
        ((js)
         'host) ;; TODO: must be 'class to support uninterned symbols
        (else
         'class))))

(define (univ-keyword-representation ctx)
  'class)

(define (univ-tostr-method-name ctx)
  (case (target-name (ctx-target ctx))

    ((js)
     'toString)

    ((php)
     '__toString)

    ((python)
     '__str__)

    ((ruby)
     'to_s)

    (else
     (compiler-internal-error
      "univ-tostr-method-name, unknown target"))))

(define univ-thread-cont-slot 5)
(define univ-thread-denv-slot 6)

(define (univ-php-version-53? ctx)
  (assq 'php53 (ctx-options ctx)))

(define univ-tag-bits 2)
(define univ-word-bits 32)

(define univ-fixnum-max+1
  (arithmetic-shift 1 (- univ-word-bits (+ 1 univ-tag-bits))))

(define univ-fixnum-max (- univ-fixnum-max+1 1))
(define univ-fixnum-min (- -1 univ-fixnum-max))
(define univ-fixnum-max*2+1 (+ (* univ-fixnum-max 2) 1))

;;;----------------------------------------------------------------------------
;;
;; "Universal" back-end.

;; Initialization/finalization of back-end.

(define (univ-setup target-language file-extensions options)

  (define common-options
    '((repr-procedure symbol)
      (repr-null      symbol)
      (repr-void      symbol)
      (repr-boolean   symbol)
      (repr-fixnum    symbol)
      (repr-flonum    symbol)
      (repr-vector    symbol)
      (repr-string    symbol)
      (repr-symbol    symbol)))

  (let ((targ
         (make-target 10
                      target-language
                      file-extensions
                      (append options common-options)
                      0)))

    (define (begin! info-port)

      (target-dump-set!
       targ
       (lambda (procs output c-intf module-descr unique-name options)
         (univ-dump targ procs output c-intf module-descr unique-name options)))

      (target-nb-regs-set! targ univ-nb-gvm-regs)

      (target-prim-info-set!
       targ
       (lambda (name)
         (univ-prim-info targ name)))

      (target-label-info-set!
       targ
       (lambda (nb-parms closed?)
         (univ-label-info targ nb-parms closed?)))

      (target-jump-info-set!
       targ
       (lambda (nb-args)
         (univ-jump-info targ nb-args)))

      (target-frame-constraints-set!
       targ
       (make-frame-constraints univ-frame-reserve univ-frame-alignment))

      (target-proc-result-set!
       targ
       (make-reg 1))

      (target-task-return-set!
       targ
       (make-reg 0))

      (target-switch-testable?-set!
       targ
       (lambda (obj)
         (univ-switch-testable? targ obj)))

      (target-eq-testable?-set!
       targ
       (lambda (obj)
         (univ-eq-testable? targ obj)))

      (target-object-type-set!
       targ
       (lambda (obj)
         (univ-object-type targ obj)))

      #f)

    (define (end!)
      #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)
    (target-add targ)))

(univ-setup 'js     '((".js"  . JavaScript)) '())
(univ-setup 'python '((".py"  . Python))     '())
(univ-setup 'ruby   '((".rb"  . Ruby))       '())
(univ-setup 'php    '((".php" . PHP))        '((php53)))

;;;----------------------------------------------------------------------------

;; Generation of textual target code.

(define (univ-indent . rest)
  (cons '$$indent$$ rest))

(define (univ-box boxed unboxed)
  (list '$$box$$ boxed unboxed))

(define (univ-unbox x)
  (and (pair? x)
       (eq? (car x) '$$box$$)
       (caddr x)))

(define (univ-display x port)

  (define indent-level 0)
  (define after-newline? #t)

  (define (indent)
    (if after-newline?
        (begin
          (display (make-string (* 2 indent-level) #\space) port)
          (set! after-newline? #f))))

  (define (disp x)

    (cond ((string? x)
           (let loop1 ((i 0))
             (let loop2 ((j i))

               (define (display-substring limit)
                 (if (< i limit)
                     (begin
                       (indent)
                       (if (and (= i 0) (= limit (string-length x)))
                           (display x port)
                           (display (substring x i limit) port)))))

               (if (< j (string-length x))

                   (let ((c (string-ref x j))
                         (j+1 (+ j 1)))
                       (if (char=? c #\newline)
                           (begin
                             (display-substring j+1)
                             (set! after-newline? #t)
                             (loop1 j+1))
                           (loop2 j+1)))

                   (display-substring j)))))

          ((symbol? x)
           (disp (symbol->string x)))

          ((char? x)
           (disp (string x)))

          ((null? x))

          ((pair? x)
           (case (car x)
             (($$indent$$)
              (set! indent-level (+ indent-level 1))
              (disp (cdr x))
              (set! indent-level (- indent-level 1)))
             (($$box$$)
              (disp (cadr x)))
             (else
              (disp (car x))
              (disp (cdr x)))))

          ((vector? x)
           (disp (vector->list x)))

          (else
           (indent)
           (display x port))))

   (disp x))

;;;----------------------------------------------------------------------------

;; ***** PROCEDURE CALLING CONVENTION

(define univ-nb-gvm-regs 5)
(define univ-nb-arg-regs 3)

(define (univ-label-info targ nb-parms closed?)

;; After a GVM "entry-point" or "closure-entry-point" label, the following
;; is true:
;;
;;  * return address is in GVM register 0
;;
;;  * if nb-parms <= nb-arg-regs
;;
;;      then parameter N is in GVM register N
;;
;;      else parameter N is in
;;               GVM register N-F, if N > F
;;               GVM stack slot N, if N <= F
;;           where F = nb-parms - nb-arg-regs
;;
;;  * for a "closure-entry-point" GVM register nb-arg-regs+1 contains
;;    a pointer to the closure object
;;
;;  * other GVM registers contain an unspecified value

  (let ((nb-stacked (max 0 (- nb-parms univ-nb-arg-regs))))

    (define (location-of-parms i)
      (if (> i nb-parms)
          '()
          (cons (cons i
                      (if (> i nb-stacked)
                          (make-reg (- i nb-stacked))
                          (make-stk i)))
                (location-of-parms (+ i 1)))))

    (let ((x (cons (cons 'return 0) (location-of-parms 1))))
      (make-pcontext nb-stacked
                     (if closed?
                         (cons (cons 'closure-env
                                     (make-reg (+ univ-nb-arg-regs 1)))
                               x)
                         x)))))

(define (univ-jump-info targ nb-args)

;; After a GVM "jump" instruction with argument count, the following
;; is true:
;;
;;  * the return address is in GVM register 0
;;
;;  * if nb-args <= nb-arg-regs
;;
;;      then argument N is in GVM register N
;;
;;      else argument N is in
;;               GVM register N-F, if N > F
;;               GVM stack slot N, if N <= F
;;           where F = nb-args - nb-arg-regs
;;
;;  * GVM register nb-arg-regs+1 contains a pointer to the closure object
;;    if a closure is being jumped to
;;
;;  * other GVM registers contain an unspecified value

  (let ((nb-stacked (max 0 (- nb-args univ-nb-arg-regs))))

    (define (location-of-args i)
      (if (> i nb-args)
          '()
          (cons (cons i
                      (if (> i nb-stacked)
                          (make-reg (- i nb-stacked))
                          (make-stk i)))
                (location-of-args (+ i 1)))))

    (make-pcontext nb-stacked
                   (cons (cons 'return (make-reg 0))
                         (location-of-args 1)))))

;; The frame constraints are defined by the parameters
;; univ-frame-reserve and univ-frame-alignment.

(define univ-frame-reserve 0) ;; no extra slots reserved
(define univ-frame-alignment 1) ;; no alignment constraint

;; ***** PRIMITIVE PROCEDURE DATABASE

(define (univ-prim-info targ name)
  (univ-prim-info* name))

(define (univ-prim-info* name)
  (table-ref univ-prim-proc-table name #f))

(define univ-prim-proc-table (make-table))

(define (univ-prim-proc-add! x)
  (let ((name (string->canonical-symbol (car x))))
    (table-set! univ-prim-proc-table
                name
                (apply make-proc-obj (car x) #f #t #f (cdr x)))))

(for-each univ-prim-proc-add! prim-procs)

(univ-prim-proc-add! '("##inline-host-statement" 1 #t 0 0 (#f) extended))
(univ-prim-proc-add! '("##inline-host-expression" 1 #t 0 0 (#f) extended))
(univ-prim-proc-add! '("##inline-host-declaration" (1) #t 0 0 (#f) extended))

(define (univ-switch-testable? targ obj)
  ;;(pretty-print (list 'univ-switch-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (univ-eq-testable? targ obj)
  ;;(pretty-print (list 'univ-eq-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (univ-object-type targ obj)
  ;;(pretty-print (list 'univ-object-type 'targ obj))
  'bignum);;;;;;;;;;;;;;;;;;;;;;;;;

;; ***** TARGET CODE EMITTERS

(define-macro (^ . forms)
  (if (null? forms)
      `'()
      `(list ,@forms)))

(define-macro (^var-declaration name #!optional (expr #f))
  `(univ-emit-var-declaration ctx ,name ,expr))

(define-macro (^expr-statement expr)
  `(univ-emit-expr-statement ctx ,expr))

(define-macro (^if test true #!optional (false #f))
  `(univ-emit-if ctx ,test ,true ,false))

(define-macro (^if-expr expr1 expr2 expr3)
  `(univ-emit-if-expr ctx ,expr1 ,expr2 ,expr3))

(define-macro (^while test body)
  `(univ-emit-while ctx ,test ,body))

(define-macro (^eq? expr1 expr2)
  `(univ-emit-eq? ctx ,expr1 ,expr2))

(define-macro (^+ expr1 #!optional (expr2 #f))
  `(univ-emit-+ ctx ,expr1 ,expr2))

(define-macro (^- expr1 #!optional (expr2 #f))
  `(univ-emit-- ctx ,expr1 ,expr2))

(define-macro (^* expr1 expr2)
  `(univ-emit-* ctx ,expr1 ,expr2))

(define-macro (^/ expr1 expr2)
  `(univ-emit-/ ctx ,expr1 ,expr2))

(define-macro (^<< expr1 expr2)
  `(univ-emit-<< ctx ,expr1 ,expr2))

(define-macro (^>> expr1 expr2)
  `(univ-emit->> ctx ,expr1 ,expr2))

(define-macro (^>>> expr1 expr2)
  `(univ-emit->>> ctx ,expr1 ,expr2))

(define-macro (^bitnot expr)
  `(univ-emit-bitnot ctx ,expr))

(define-macro (^bitand expr1 expr2)
  `(univ-emit-bitand ctx ,expr1 ,expr2))

(define-macro (^bitior expr1 expr2)
  `(univ-emit-bitior ctx ,expr1 ,expr2))

(define-macro (^bitxor expr1 expr2)
  `(univ-emit-bitxor ctx ,expr1 ,expr2))

(define-macro (^= expr1 expr2)
  `(univ-emit-= ctx ,expr1 ,expr2))

(define-macro (^!= expr1 expr2)
  `(univ-emit-!= ctx ,expr1 ,expr2))

(define-macro (^< expr1 expr2)
  `(univ-emit-< ctx ,expr1 ,expr2))

(define-macro (^<= expr1 expr2)
  `(univ-emit-<= ctx ,expr1 ,expr2))

(define-macro (^> expr1 expr2)
  `(univ-emit-> ctx ,expr1 ,expr2))

(define-macro (^>= expr1 expr2)
  `(univ-emit->= ctx ,expr1 ,expr2))

(define-macro (^not expr)
  `(univ-emit-not ctx ,expr))

(define-macro (^&& expr1 expr2)
  `(univ-emit-&& ctx ,expr1 ,expr2))

(define-macro (^and expr1 expr2)
  `(univ-emit-and ctx ,expr1 ,expr2))

(define-macro (^or expr1 expr2)
  `(univ-emit-or ctx ,expr1 ,expr2))

(define-macro (^concat expr1 expr2)
  `(univ-emit-concat ctx ,expr1 ,expr2))

(define-macro (^tostr expr)
  `(univ-emit-tostr ctx ,expr))

(define-macro (^parens expr)
  `(univ-emit-parens ctx ,expr))

(define-macro (^parens-php expr)
  `(univ-emit-parens-php ctx ,expr))

(define-macro (^local-var name)
  `(univ-emit-local-var ctx ,name))

(define-macro (^global-var name)
  `(univ-emit-global-var ctx ,name))

(define-macro (^gvar name)
  `(univ-emit-gvar ctx ,name))

(define-macro (^global-function name)
  `(univ-emit-global-function ctx ,name))

(define-macro (^prefix name)
  `(univ-emit-prefix ctx ,name))

(define-macro (^prefix-class name)
  `(univ-emit-prefix-class ctx ,name))

(define-macro (^assign-expr loc expr)
  `(univ-emit-assign-expr ctx ,loc ,expr))

(define-macro (^assign loc expr)
  `(univ-emit-assign ctx ,loc ,expr))

(define-macro (^inc-by loc expr #!optional (embed #f))
  `(univ-emit-inc-by ctx ,loc ,expr ,embed))

(define-macro (^alias expr)
  `(univ-emit-alias ctx ,expr))

(define-macro (^unalias expr)
  `(univ-emit-unalias ctx ,expr))

(define-macro (^array-length expr)
  `(univ-emit-array-length ctx ,expr))

(define-macro (^array-shrink! expr1 expr2)
  `(univ-emit-array-shrink! ctx ,expr1 ,expr2))

(define-macro (^copy-array-to-extensible-array expr len)
  `(univ-emit-copy-array-to-extensible-array ctx ,expr ,len))

(define-macro (^extensible-array-to-array! var len)
  `(univ-emit-extensible-array-to-array! ctx ,var ,len))

(define-macro (^subarray expr1 expr2 expr3)
  `(univ-emit-subarray ctx ,expr1 ,expr2 ,expr3))

(define-macro (^array-index expr1 expr2)
  `(univ-emit-array-index ctx ,expr1 ,expr2))

(define-macro (^prop-index expr1 expr2 #!optional (expr3 #f))
  `(univ-emit-prop-index ctx ,expr1 ,expr2 ,expr3))

(define-macro (^prop-index-exists? expr1 expr2)
  `(univ-emit-prop-index-exists? ctx ,expr1 ,expr2))

(define-macro (^get obj name)
  `(univ-emit-get ctx ,obj ,name))

(define-macro (^set obj name val)
  `(univ-emit-set ctx ,obj ,name ,val))

(define-macro (^obj obj)
  `(univ-emit-obj ctx ,obj))

(define-macro (^array-literal elems)
  `(univ-emit-array-literal ctx ,elems))

(define-macro (^extensible-array-literal elems)
  `(univ-emit-extensible-array-literal ctx ,elems))

(define-macro (^empty-dict)
  `(univ-emit-empty-dict ctx))

(define-macro (^call-prim expr . params)
  `(univ-emit-call-prim ctx ,expr ,@params))

(define-macro (^call expr . params)
  `(univ-emit-call ctx ,expr ,@params))

(define-macro (^apply expr params)
  `(univ-emit-apply ctx ,expr ,params))

(define-macro (^this)
  `(univ-emit-this ctx))

(define-macro (^this-member name)
  `(univ-emit-this-member ctx ,name))

(define-macro (^new class . params)
  `(univ-emit-new ctx ,class ,@params))

(define-macro (^typeof type expr)
  `(univ-emit-typeof ctx ,type ,expr))

(define-macro (^instanceof class expr)
  `(univ-emit-instanceof ctx ,class ,expr))

(define-macro (^getopnd opnd)
  `(univ-emit-getopnd ctx ,opnd))

(define-macro (^setloc loc val)
  `(univ-emit-setloc ctx ,loc ,val))

(define-macro (^procedure-declaration global? root-name params header attribs body)
  `(univ-emit-procedure-declaration
    ctx
    ,global?
    ,root-name
    ,params
    ,header
    ,attribs
    (lambda (ctx) ,body)))

(define-macro (^prim-function-declaration root-name params header attribs body)
  `(^function-declaration
    #t
    ,root-name
    ,params
    ,header
    ,attribs
    ,body
    #t))

(define-macro (^function-declaration global? root-name params header attribs body #!optional (prim? #f))
  `(univ-emit-function-declaration
    ctx
    ,global?
    ,root-name
    ,params
    ,header
    ,attribs
    (lambda (ctx) ,body)
    ,prim?))

(define-macro (^class-declaration root-name extends fields methods #!optional (constructor #f))
  `(univ-emit-class-declaration
    ctx
    ,root-name
    ,extends
    ,fields
    ,methods
    ,constructor))

(define-macro (^tos)
  `(univ-emit-tos ctx))

(define-macro (^pop receiver)
  `(univ-emit-pop ctx ,receiver))

(define-macro (^push val)
  `(univ-emit-push ctx ,val))

(define-macro (^getnargs)
  `(univ-emit-getnargs ctx))

(define-macro (^setnargs nb-args)
  `(univ-emit-setnargs ctx ,nb-args))

(define-macro (^getreg num)
  `(univ-emit-getreg ctx ,num))

(define-macro (^setreg num val)
  `(univ-emit-setreg ctx ,num ,val))

(define-macro (^getstk offset)
  `(univ-emit-getstk ctx ,offset))

(define-macro (^setstk offset val)
  `(univ-emit-setstk ctx ,offset ,val))

(define-macro (^getclo closure index)
  `(univ-emit-getclo ctx ,closure ,index))

(define-macro (^setclo closure index val)
  `(univ-emit-setclo ctx ,closure ,index ,val))

(define-macro (^getprm name)
  `(univ-emit-getprm ctx ,name))

(define-macro (^setprm name val)
  `(univ-emit-setprm ctx ,name ,val))

(define-macro (^getglo name)
  `(univ-emit-getglo ctx ,name))

(define-macro (^setglo name val)
  `(univ-emit-setglo ctx ,name ,val))

(define-macro (^glo-var-ref sym)
  `(univ-emit-glo-var-ref ctx ,sym))

(define-macro (^glo-var-primitive-ref sym)
  `(univ-emit-glo-var-primitive-ref ctx ,sym))

(define-macro (^glo-var-set! sym val)
  `(univ-emit-glo-var-set! ctx ,sym ,val))

(define-macro (^glo-var-primitive-set! sym val)
  `(univ-emit-glo-var-primitive-set! ctx ,sym ,val))

(define-macro (^return-poll expr poll? call?)
  `(univ-emit-return-poll ctx ,expr ,poll? ,call?))

(define-macro (^return-call-prim expr . params)
  `(univ-emit-return-call-prim ctx ,expr ,@params))

(define-macro (^return-call expr)
  `(univ-emit-return-call ctx ,expr))

(define-macro (^return expr)
  `(univ-emit-return ctx ,expr))

(define-macro (^null)
  `(univ-emit-null ctx))

(define-macro (^void)
  `(univ-emit-void ctx))

(define-macro (^eof)
  `(univ-emit-eof ctx))

(define-macro (^absent)
  `(univ-emit-absent ctx))

(define-macro (^unbound1)
  `(univ-emit-unbound1 ctx))

(define-macro (^unbound2)
  `(univ-emit-unbound2 ctx))

(define-macro (^unbound? val)
  `(univ-emit-unbound? ctx ,val))

(define-macro (^optional)
  `(univ-emit-optional ctx))

(define-macro (^key)
  `(univ-emit-key ctx))

(define-macro (^rest)
  `(univ-emit-rest ctx))

(define-macro (^bool val)
  `(univ-emit-bool ctx ,val))

(define-macro (^boolean-obj obj)
  `(univ-emit-boolean-obj ctx ,obj))

(define-macro (^boolean-box val)
  `(univ-emit-boolean-box ctx ,val))

(define-macro (^boolean-unbox boolean)
  `(univ-emit-boolean-unbox ctx ,boolean))

(define-macro (^boolean? val)
  `(univ-emit-boolean? ctx ,val))

(define-macro (^chr val)
  `(univ-emit-chr ctx ,val))

(define-macro (^char-obj obj force-var?)
  `(univ-emit-char-obj ctx ,obj ,force-var?))

(define-macro (^char-box val)
  `(univ-emit-char-box ctx ,val))

(define-macro (^char-box-uninterned val)
  `(univ-emit-char-box-uninterned ctx ,val))

(define-macro (^char-unbox char)
  `(univ-emit-char-unbox ctx ,char))

(define-macro (^chr-fromint val)
  `(univ-emit-chr-fromint ctx ,val))

(define-macro (^chr-toint val)
  `(univ-emit-chr-toint ctx ,val))

(define-macro (^chr-tostr val)
  `(univ-emit-chr-tostr ctx ,val))

(define-macro (^char? val)
  `(univ-emit-char? ctx ,val))

(define-macro (^int val)
  `(univ-emit-int ctx ,val))

(define-macro (^fixnum-box val)
  `(univ-emit-fixnum-box ctx ,val))

(define-macro (^fixnum-unbox fixnum)
  `(univ-emit-fixnum-unbox ctx ,fixnum))

(define-macro (^fixnum? val)
  `(univ-emit-fixnum? ctx ,val))

(define-macro (^dict alist)
  `(univ-emit-dict ctx ,alist))

(define-macro (^member expr name)
  `(univ-emit-member ctx ,expr ,name))

(define-macro (^pair? expr)
  `(univ-emit-pair? ctx ,expr))

(define-macro (^cons expr1 expr2)
  `(univ-emit-cons ctx ,expr1 ,expr2))

(define-macro (^getcar expr)
  `(univ-emit-getcar ctx ,expr))

(define-macro (^getcdr expr)
  `(univ-emit-getcdr ctx ,expr))

(define-macro (^setcar expr1 expr2)
  `(univ-emit-setcar ctx ,expr1 ,expr2))

(define-macro (^setcdr expr1 expr2)
  `(univ-emit-setcdr ctx ,expr1 ,expr2))

(define-macro (^float val)
  `(univ-emit-float ctx ,val))

(define-macro (^float-fromint val)
  `(univ-emit-float-fromint ctx ,val))

(define-macro (^float-toint val)
  `(univ-emit-float-toint ctx ,val))

(define-macro (^float-abs val)
  `(univ-emit-float-abs ctx ,val))

(define-macro (^float-floor val)
  `(univ-emit-float-floor ctx ,val))

(define-macro (^float-ceiling val)
  `(univ-emit-float-ceiling ctx ,val))

(define-macro (^float-truncate val)
  `(univ-emit-float-truncate ctx ,val))

(define-macro (^float-round-half-up val)
  `(univ-emit-float-round-half-up ctx ,val))

(define-macro (^float-round-half-towards-0 val)
  `(univ-emit-float-round-half-towards-0 ctx ,val))

(define-macro (^float-round-half-to-even val)
  `(univ-emit-float-round-half-to-even ctx ,val))

(define-macro (^float-mod val1 val2)
  `(univ-emit-float-mod ctx ,val1 ,val2))

(define-macro (^float-exp val)
  `(univ-emit-float-exp ctx ,val))

(define-macro (^float-log val)
  `(univ-emit-float-log ctx ,val))

(define-macro (^float-sin val)
  `(univ-emit-float-sin ctx ,val))

(define-macro (^float-cos val)
  `(univ-emit-float-cos ctx ,val))

(define-macro (^float-tan val)
  `(univ-emit-float-tan ctx ,val))

(define-macro (^float-asin val)
  `(univ-emit-float-asin ctx ,val))

(define-macro (^float-acos val)
  `(univ-emit-float-acos ctx ,val))

(define-macro (^float-atan val)
  `(univ-emit-float-atan ctx ,val))

(define-macro (^float-atan2 val1 val2)
  `(univ-emit-float-atan2 ctx ,val1 ,val2))

(define-macro (^float-expt val1 val2)
  `(univ-emit-float-expt ctx ,val1 ,val2))

(define-macro (^float-sqrt val)
  `(univ-emit-float-sqrt ctx ,val))

(define-macro (^float-integer? val)
  `(univ-emit-float-integer? ctx ,val))

(define-macro (^float-finite? val)
  `(univ-emit-float-finite? ctx ,val))

(define-macro (^float-infinite? val)
  `(univ-emit-float-infinite? ctx ,val))

(define-macro (^float-nan? val)
  `(univ-emit-float-nan? ctx ,val))

(define-macro (^flonum-box val)
  `(univ-emit-flonum-box ctx ,val))

(define-macro (^flonum-unbox flonum)
  `(univ-emit-flonum-unbox ctx ,flonum))

(define-macro (^flonum? val)
  `(univ-emit-flonum? ctx ,val))

(define-macro (^cpxnum-make expr1 expr2)
  `(univ-emit-cpxnum-make ctx ,expr1 ,expr2))

(define-macro (^cpxnum? val)
  `(univ-emit-cpxnum? ctx ,val))

(define-macro (^ratnum-make expr1 expr2)
  `(univ-emit-ratnum-make ctx ,expr1 ,expr2))

(define-macro (^ratnum? val)
  `(univ-emit-ratnum? ctx ,val))

(define-macro (^bignum expr1 expr2)
  `(univ-emit-bignum ctx ,expr1 ,expr2))

(define-macro (^bignum? val)
  `(univ-emit-bignum? ctx ,val))

(define-macro (^vector-box val)
  `(univ-emit-vector-box ctx ,val))

(define-macro (^vector-unbox vector)
  `(univ-emit-vector-unbox ctx ,vector))

(define-macro (^vector? val)
  `(univ-emit-vector? ctx ,val))

(define-macro (^vector-length val)
  `(univ-emit-vector-length ctx ,val))

(define-macro (^vector-shrink! val1 val2)
  `(univ-emit-vector-shrink! ctx ,val1 ,val2))

(define-macro (^vector-ref val1 val2)
  `(univ-emit-vector-ref ctx ,val1 ,val2))

(define-macro (^vector-set! val1 val2 val3)
  `(univ-emit-vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^u8vector-box val)
  `(univ-emit-u8vector-box ctx ,val))

(define-macro (^u8vector-unbox u8vector)
  `(univ-emit-u8vector-unbox ctx ,u8vector))

(define-macro (^u8vector? val)
  `(univ-emit-u8vector? ctx ,val))

(define-macro (^u8vector-length val)
  `(univ-emit-u8vector-length ctx ,val))

(define-macro (^u8vector-shrink! val1 val2)
  `(univ-emit-u8vector-shrink! ctx ,val1 ,val2))

(define-macro (^u8vector-ref val1 val2)
  `(univ-emit-u8vector-ref ctx ,val1 ,val2))

(define-macro (^u8vector-set! val1 val2 val3)
  `(univ-emit-u8vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^u16vector-box val)
  `(univ-emit-u16vector-box ctx ,val))

(define-macro (^u16vector-unbox u16vector)
  `(univ-emit-u16vector-unbox ctx ,u16vector))

(define-macro (^u16vector? val)
  `(univ-emit-u16vector? ctx ,val))

(define-macro (^u16vector-length val)
  `(univ-emit-u16vector-length ctx ,val))

(define-macro (^u16vector-shrink! val1 val2)
  `(univ-emit-u16vector-shrink! ctx ,val1 ,val2))

(define-macro (^u16vector-ref val1 val2)
  `(univ-emit-u16vector-ref ctx ,val1 ,val2))

(define-macro (^u16vector-set! val1 val2 val3)
  `(univ-emit-u16vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^f64vector-box val)
  `(univ-emit-f64vector-box ctx ,val))

(define-macro (^f64vector-unbox f64vector)
  `(univ-emit-f64vector-unbox ctx ,f64vector))

(define-macro (^f64vector? val)
  `(univ-emit-f64vector? ctx ,val))

(define-macro (^f64vector-length val)
  `(univ-emit-f64vector-length ctx ,val))

(define-macro (^f64vector-shrink! val1 val2)
  `(univ-emit-f64vector-shrink! ctx ,val1 ,val2))

(define-macro (^f64vector-ref val1 val2)
  `(univ-emit-f64vector-ref ctx ,val1 ,val2))

(define-macro (^f64vector-set! val1 val2 val3)
  `(univ-emit-f64vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^structure-box val)
  `(univ-emit-structure-box ctx ,val))

(define-macro (^structure-unbox structure)
  `(univ-emit-structure-unbox ctx ,structure))

(define-macro (^structure? val)
  `(univ-emit-structure? ctx ,val))

(define-macro (^structure-ref val1 val2)
  `(univ-emit-structure-ref ctx ,val1 ,val2))

(define-macro (^structure-set! val1 val2 val3)
  `(univ-emit-structure-set! ctx ,val1 ,val2 ,val3))

(define-macro (^str val)
  `(univ-emit-str ctx ,val))

(define-macro (^strtocodes val)
  `(univ-emit-strtocodes ctx ,val))

(define-macro (^string-obj obj force-var?)
  `(univ-emit-string-obj ctx ,obj ,force-var?))

(define-macro (^string-box val)
  `(univ-emit-string-box ctx ,val))

(define-macro (^string-unbox string)
  `(univ-emit-string-unbox ctx ,string))

(define-macro (^string? val)
  `(univ-emit-string? ctx ,val))

(define-macro (^string-length val)
  `(univ-emit-string-length ctx ,val))

(define-macro (^string-shrink! val1 val2)
  `(univ-emit-string-shrink! ctx ,val1 ,val2))

(define-macro (^string-ref val1 val2)
  `(univ-emit-string-ref ctx ,val1 ,val2))

(define-macro (^string-set! val1 val2 val3)
  `(univ-emit-string-set! ctx ,val1 ,val2 ,val3))

(define-macro (^symbol-obj obj force-var?)
  `(univ-emit-symbol-obj ctx ,obj ,force-var?))

(define-macro (^symbol-box val)
  `(univ-emit-symbol-box ctx ,val))

(define-macro (^symbol-box-uninterned val)
  `(univ-emit-symbol-box-uninterned ctx ,val))

(define-macro (^symbol-unbox symbol)
  `(univ-emit-symbol-unbox ctx ,symbol))

(define-macro (^symbol? val)
  `(univ-emit-symbol? ctx ,val))

(define-macro (^keyword-obj obj force-var?)
  `(univ-emit-keyword-obj ctx ,obj ,force-var?))

(define-macro (^keyword-box val)
  `(univ-emit-keyword-box ctx ,val))

(define-macro (^keyword-box-uninterned val)
  `(univ-emit-keyword-box-uninterned ctx ,val))

(define-macro (^keyword-unbox keyword)
  `(univ-emit-keyword-unbox ctx ,keyword))

(define-macro (^keyword? val)
  `(univ-emit-keyword? ctx ,val))

(define-macro (^box? val)
  `(univ-emit-box? ctx ,val))

(define-macro (^box val)
  `(univ-emit-box ctx ,val))

(define-macro (^unbox val)
  `(univ-emit-unbox ctx ,val))

(define-macro (^setbox val1 val2)
  `(univ-emit-setbox ctx ,val1 ,val2))

(define-macro (^frame? val)
  `(univ-emit-frame? ctx ,val))

(define-macro (^continuation? val)
  `(univ-emit-continuation? ctx ,val))

(define-macro (^procedure? val)
  `(univ-emit-procedure? ctx ,val))

(define-macro (^closure? val)
  `(univ-emit-closure? ctx ,val))

(define-macro (^closure-length val)
  `(univ-emit-closure-length ctx ,val))

(define-macro (^closure-code val)
  `(univ-emit-closure-code ctx ,val))

(define-macro (^closure-ref val1 val2)
  `(univ-emit-closure-ref ctx ,val1 ,val2))

(define-macro (^closure-set! val1 val2 val3)
  `(univ-emit-closure-set! ctx ,val1 ,val2 ,val3))

(define-macro (^popcount! arg)
  `(univ-emit-popcount! ctx ,arg))

(define (univ-emit-popcount! ctx arg)

  (define (popcount arg acc len)
    (if (>= len univ-word-bits)
        (^ acc
           (^assign arg (^bitand arg (^int #x0000003F))))
        (popcount
         arg
         (^ acc
            (case len
             ((1)
              (^assign arg (^- arg
                               (^parens (^bitand (^parens (^>> arg (^int 1)))
                                                 (^int #x55555555))))))
             ((2)
              (^assign arg (^+ (^parens (^bitand arg (^int #x33333333)))
                               (^parens (^bitand (^parens (^>> arg (^int 2)))
                                                 (^int #x33333333))))))
             ((4)
              (^assign arg (^bitand (^parens (^+ arg (^parens (^>> arg (^int 4)))))
                                    (^int #x0F0F0F0F))))
             (else
              (^assign arg (^+ arg (^parens (^>> arg len)))))))
         (* len 2))))

  (popcount arg
            (^assign arg (^bitand arg (^int univ-fixnum-max*2+1)))
            1))

(define (univ-emit-var-declaration ctx name #!optional (expr #f))
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "var " name (if expr (^ " = " expr) (^)) ";\n"))

    ((python ruby)
     (^ name " = " (or expr (^obj #f)) "\n"))

    ((php)
     (^ name " = " (or expr (^obj #f)) ";\n"))

    (else
     (compiler-internal-error
      "univ-emit-var-declaration, unknown target"))))

(define (univ-emit-expr-statement ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ expr ";\n"))

    ((python ruby)
     (^ expr "\n"))

    (else
     (compiler-internal-error
      "univ-emit-expr-statement, unknown target"))))

(define (univ-emit-if ctx test true #!optional (false #f))
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ "if (" test ") {\n"
        (univ-indent true)
        (if false
            (^ "} else {\n"
               (univ-indent false))
            (^))
        "}\n"))

    ((python)
     (^ "if " test ":\n"
        (univ-indent true)
        (if false
            (^ "else:\n"
                  (univ-indent false))
            (^))))

    ((ruby)
     (^ "if " test "\n"
        (univ-indent true)
        (if false
            (^ "else\n"
               (univ-indent false))
            (^))
        "end\n"))

    (else
     (compiler-internal-error
      "univ-emit-if, unknown target"))))

(define (univ-emit-if-expr ctx expr1 expr2 expr3)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ expr1 " ? " expr2 " : " expr3))

    ((php)
     (^parens (^ expr1 " ? " expr2 " : " expr3)))

    ((python)
     (^ expr2 " if " expr1 " else " expr3))

    (else
     (compiler-internal-error
      "univ-emit-if-expr, unknown target"))))

(define (univ-emit-while ctx test body)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ "while (" test ") {\n"
        (univ-indent body)
        "}\n"))

    ((python)
     (^ "while " test ":\n"
        (univ-indent body)))

    ((ruby)
     (^ "while " test "\n"
        (univ-indent body)
        "end\n"))

    (else
     (compiler-internal-error
      "univ-emit-while, unknown target"))))

(define (univ-emit-eq? ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ expr1 " === " expr2))

    ((python)
     (^ expr1 " is " expr2))

    ((ruby)
     (^ expr1 ".equal?(" expr2 ")"))

    (else
     (compiler-internal-error
      "univ-emit-eq?, unknown target"))))

(define (univ-emit-+ ctx expr1 #!optional (expr2 #f))
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (if expr2
         (^ expr1 " + " expr2)
         (^ "+ " expr1)))

    (else
     (compiler-internal-error
      "univ-emit-+, unknown target"))))

(define (univ-emit-- ctx expr1 #!optional (expr2 #f))
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (if expr2
         (^ expr1 " - " expr2)
         (^ "- " expr1)))

    (else
     (compiler-internal-error
      "univ-emit--, unknown target"))))

(define (univ-emit-* ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (^ expr1 " * " expr2))

    (else
     (compiler-internal-error
      "univ-emit-*, unknown target"))))

(define (univ-emit-/ ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (^ expr1 " / " expr2))

    (else
     (compiler-internal-error
      "univ-emit-/, unknown target"))))

(define (univ-wrap+ ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^>> (^<< (^parens (^+ expr1 expr2))
               univ-tag-bits)
          univ-tag-bits))

    ((python)
     (^>> (^member (^call-prim
                    "ctypes.c_int32"
                    (^<< (^parens (^+ expr1 expr2))
                         univ-tag-bits))
                   "value")
          univ-tag-bits))

    ((ruby php)
     (^- (^parens (^bitand (^parens (^+ (^+ expr1 expr2)
                                        univ-fixnum-max+1))
                           univ-fixnum-max*2+1))
         univ-fixnum-max+1))

    (else
     (compiler-internal-error
      "univ-wrap+, unknown target"))))

(define (univ-wrap- ctx expr1 #!optional (expr2 #f))
  (case (target-name (ctx-target ctx))

    ((js)
     (^>> (^<< (^parens (if expr2
                            (^- expr1 expr2)
                            (^- expr1)))
               univ-tag-bits)
          univ-tag-bits))

    ((python)
     (^>> (^member (^call-prim
                    "ctypes.c_int32"
                    (^<< (^parens (if expr2
                                      (^- expr1 expr2)
                                      (^- expr1)))
                         univ-tag-bits))
                   "value")
          univ-tag-bits))

    ((ruby php)
     (^- (^parens (^bitand (^parens (^+ (if expr2
                                            (^- expr1 expr2)
                                            (^- expr1))
                                        univ-fixnum-max+1))
                           univ-fixnum-max*2+1))
         univ-fixnum-max+1))

    (else
     (compiler-internal-error
      "univ-wrap-, unknown target"))))

(define (univ-wrap* ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^>> (^parens
           (^<< (^parens
                 (^+ (^* (^parens (^bitand expr1 #xffff))
                         expr2)
                     (^* (^parens (^bitand expr1 #xffff0000))
                         (^parens (^bitand expr2 #xffff)))))
                univ-tag-bits))
          univ-tag-bits))

    ((python)
     (^>> (^member (^call-prim
                    "ctypes.c_int32"
                    (^<< (^parens (^* expr1 expr2))
                         univ-tag-bits))
                   "value")
          univ-tag-bits))

    ((ruby php)
     (^- (^parens (^bitand (^parens (^+ (^* expr1 expr2)
                                        univ-fixnum-max+1))
                           univ-fixnum-max*2+1))
         univ-fixnum-max+1))

    (else
     (compiler-internal-error
      "univ-wrap*, unknown target"))))

(define (univ-emit-<< ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (^ expr1 " << " expr2))

    (else
     (compiler-internal-error
      "univ-emit-<<, unknown target"))))

(define (univ-emit->> ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (^ expr1 " >> " expr2))

    (else
     (compiler-internal-error
      "univ-emit->>, unknown target"))))

(define (univ-emit->>> ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 " >>> " expr2))

    (else
     (compiler-internal-error
      "univ-emit->>>, unknown target"))))

(define (univ-emit-bitnot ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (^ "~ " expr))

    (else
     (compiler-internal-error
      "univ-emit-bitnot, unknown target"))))

(define (univ-emit-bitand ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (^ expr1 " & " expr2))

    (else
     (compiler-internal-error
      "univ-emit-bitand, unknown target"))))

(define (univ-emit-bitior ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (^ expr1 " | " expr2))

    (else
     (compiler-internal-error
      "univ-emit-bitior, unknown target"))))

(define (univ-emit-bitxor ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (^ expr1 " ^ " expr2))

    (else
     (compiler-internal-error
      "univ-emit-bitxor, unknown target"))))

(define (univ-emit-= ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 " === " expr2))

    ((python ruby php)
     (^ expr1 " == " expr2))

    (else
     (compiler-internal-error
      "univ-emit-=, unknown target"))))

(define (univ-emit-!= ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 " !== " expr2))

    ((python ruby php)
     (^ expr1 " != " expr2))

    (else
     (compiler-internal-error
      "univ-emit-!=, unknown target"))))

(define (univ-emit-< ctx expr1 expr2)
  (univ-emit-comparison ctx " < " expr1 expr2))

(define (univ-emit-<= ctx expr1 expr2)
  (univ-emit-comparison ctx " <= " expr1 expr2))

(define (univ-emit-> ctx expr1 expr2)
  (univ-emit-comparison ctx " > " expr1 expr2))

(define (univ-emit->= ctx expr1 expr2)
  (univ-emit-comparison ctx " >= " expr1 expr2))

(define (univ-emit-comparison ctx comp expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js python ruby php)
     (^ expr1 comp expr2))

    (else
     (compiler-internal-error
      "univ-emit-comparison, unknown target"))))

(define (univ-emit-not ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php ruby)
     (^ "!" expr))

    ((python)
     (^ "not " expr))

    (else
     (compiler-internal-error
      "univ-emit-not, unknown target"))))

(define (univ-emit-&& ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js ruby php)
     (^ expr1 " && " expr2))

    ((python)
     (^ expr1 " and " expr2))

    (else
     (compiler-internal-error
      "univ-emit-&&, unknown target"))))

(define (univ-emit-and ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ expr1 " && " expr2))

    ((python)
     (^ expr1 " and " expr2))

    ((php)
     (^ expr1 " ? " expr2 " : false"))

    (else
     (compiler-internal-error
      "univ-emit-and, unknown target"))))

(define (univ-emit-or ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js ruby php)
     (^ expr1 " || " expr2)) ;; TODO: PHP || operator always yields a boolean

    ((python)
     (^ expr1 " or " expr2))

    (else
     (compiler-internal-error
      "univ-emit-or, unknown target"))))

(define (univ-emit-concat ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^ expr1 " + " expr2))

    ((php)
     (^ expr1 " . " expr2))

    (else
     (compiler-internal-error
      "univ-emit-concat, unknown target"))))

(define (univ-emit-tostr ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr ".toString()"))

    ((python)
     (^ "str(" expr ")"))

    ((php)
     (^ "(string)" expr))

    ((ruby)
     (^ expr ".to_s"))

    (else
     (compiler-internal-error
      "univ-emit-tostr, unknown target"))))

(define (univ-emit-parens ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby php python)
     (^ "(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-parens, unknown target"))))

(define (univ-emit-parens-php ctx expr)
  (if (eq? (target-name (ctx-target ctx)) 'php)
      (^parens expr)
      expr))

(define (univ-emit-local-var ctx name)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     name)

    ((php)
     (^ "$" name))

    (else
     (compiler-internal-error
      "univ-emit-local-var, unknown target"))))

(define (univ-emit-global-var ctx name)
  (case (target-name (ctx-target ctx))

    ((js python)
     name)

    ((php ruby)
     (^ "$" name))

    (else
     (compiler-internal-error
      "univ-emit-global-var, unknown target"))))

(define (univ-emit-gvar ctx name)
  (let ((var (^global-var (^prefix name))))
    (use-global ctx var)
    var))

(define (univ-emit-global-function ctx name)
  (case (target-name (ctx-target ctx))

    ((js python)
     name)

    ((php ruby)
     (^ "$" name))

    (else
     (compiler-internal-error
      "univ-emit-global-function, unknown target"))))

(define (univ-emit-prefix ctx name)
  (^ "gambit_" name))

(define (univ-emit-prefix-class ctx name)
  (^ "Gambit_" name))

(define (univ-emit-assign-expr ctx loc expr)
  (^ loc " = " expr))

(define (univ-emit-assign ctx loc expr)
  (^expr-statement
   (^assign-expr loc expr)))

(define (univ-emit-inc-by ctx loc expr #!optional (embed #f))

  (define (embed-read x)
    (if embed
        (embed x)
        (^)))

  (define (embed-expr x)
    (if embed
        (embed x)
        (^expr-statement x)))

  (define (inc-general loc expr)
    (if (and (number? expr) (< expr 0))
        (^ loc " -= " (- expr))
        (^ loc " += " expr)))

  (if (equal? expr 0)

      (embed-read loc)

      (case (target-name (ctx-target ctx))

        ((js php)
         (cond ((equal? expr 1)
                (embed-expr (^ "++" loc)))
               ((equal? expr -1)
                (embed-expr (^ "--" loc)))
               (else
                (embed-expr (^parens (inc-general loc expr))))))

        ((python)
         (^ (^expr-statement (inc-general loc expr))
            (embed-read loc)))

        ((ruby)
         (embed-expr (^parens (inc-general loc expr))))

        (else
         (compiler-internal-error
          "univ-emit-inc-by, unknown target")))))

(define (univ-emit-alias ctx expr)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     expr)

    ((php)
     (^ "&" expr))

    (else
     (compiler-internal-error
      "univ-emit-alias, unknown target"))))

(define (univ-emit-unalias ctx expr)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^))

    ((php)
     (^expr-statement
      (^ "unset(" expr ")")))

    (else
     (compiler-internal-error
      "univ-emit-unalias, unknown target"))))

(define (univ-emit-array-length ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ expr ".length"))

    ((php)
     (^ "count(" expr ")"))

    ((python)
     (^ "len(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-array-length, unknown target"))))

(define (univ-emit-array-shrink! ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^assign (^ expr1 ".length") expr2))

    ((php)
     (^expr-statement
      (^ "array_splice(" expr1 "," expr2 ")")))

    ((python)
     (^expr-statement
      (^ expr1 "[" expr2 ":] = []")))

    ((ruby)
     (^expr-statement
      (^ expr1 ".slice!(" expr2 "," expr1 ".length)")))

    (else
     (compiler-internal-error
      "univ-emit-array-shrink!, unknown target"))))

(define (univ-emit-copy-array-to-extensible-array ctx expr len)
  (case (target-name (ctx-target ctx))

    ((js php ruby)
     (^subarray expr 0 len))

    ((python)
     (^ "dict(zip(range(" len ")," expr "))"))

    (else
     (compiler-internal-error
      "univ-emit-array-to-extensible-array, unknown target"))))

(define (univ-emit-extensible-array-to-array! ctx var len)
  (case (target-name (ctx-target ctx))

    ((js php ruby)
     (^))

    ((python)
     (^assign var (^ "[" var "[i] for i in range(" len ")]")))

    (else
     (compiler-internal-error
      "univ-emit-extensible-array-to-array!, unknown target"))))

(define (univ-emit-subarray ctx expr1 expr2 expr3)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 ".slice(" expr2 "," (if (equal? expr2 0) expr3 (^+ expr2 expr3)) ")"))

    ((php)
     (^ "array_slice(" expr1 "," expr2 "," expr3 ")"))

    ((python)
     (^ expr1 "[" expr2 ":" (if (equal? expr2 0) expr3 (^+ expr2 expr3)) "]"))

    ((ruby)
     (^ expr1 ".slice(" expr2 "," (if (equal? expr2 0) expr3 (^+ expr2 expr3)) ")"))

    (else
     (compiler-internal-error
      "univ-emit-array-shrink!, unknown target"))))

(define (univ-emit-array-index ctx expr1 expr2)
  (^ expr1 "[" expr2 "]"))

(define (univ-emit-prop-index ctx expr1 expr2 expr3)
  (if expr3
      (^if-expr (^prop-index-exists? expr1 expr2)
                (^prop-index expr1 expr2)
                expr3)
      (^ expr1 "[" expr2 "]")))

(define (univ-emit-prop-index-exists? ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 ".hasOwnProperty(" expr2 ")"))

    ((php)
     (^ "array_key_exists(" expr2 "," expr1 ")"))

    ((python)
     (^ expr2 " in " expr1))

    ((ruby)
     (^ expr1 ".has_key?(" expr2 ")"))

    (else
     (compiler-internal-error
      "univ-emit-prop-index-exists?, unknown target"))))

(define (univ-emit-get ctx obj name)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^prop-index obj (^str name)))

    ((php)
     (^call-prim
      (^prefix (univ-use-rtlib ctx 'get))
      obj
      (^str name)))

    (else
     (compiler-internal-error
      "univ-emit-get, unknown target"))))

(define (univ-emit-set ctx obj name val)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^assign-expr (^prop-index obj (^str name)) val))

    ((php)
     (^call-prim
      (^prefix (univ-use-rtlib ctx 'set))
      obj
      (^str name)
      val))

    (else
     (compiler-internal-error
      "univ-emit-set, unknown target"))))


;; ***** DUMPING OF A COMPILATION MODULE

(define (univ-dump targ procs output c-intf module-descr unique-name options)

  (call-with-output-file
      output
    (lambda (port)
      (let* ((objs-used (make-objs-used))
             (rtlib-features-used (make-resource-set))
             (main-proc (list-ref procs 0))
             (ctx (make-ctx targ
                            options
                            (proc-obj-name main-proc)
                            #f
                            objs-used
                            rtlib-features-used
                            (queue-empty)))
             (code-procs (univ-dump-procs ctx procs))
             (code-entry (univ-entry-point ctx main-proc))
             (code-rtlib (if univ-dyn-load?
                             (^)
                             (univ-rtlib ctx)))
             (code-header (univ-module-header ctx))
             (code-objs (univ-dump-objs ctx))
             (code-decls (queue->list (ctx-decls ctx))))

        (univ-display (^ code-rtlib
                         code-header
                         code-decls
                         code-objs
                         code-procs
                         code-entry)
                      port))))

  #f)

(define (univ-dump-objs ctx)
  (let* ((objs-used (ctx-objs-used ctx))
         (stack (reverse (objs-used-stack objs-used)))
         (table (objs-used-table objs-used)))
    (let loop ((count 0) (lst stack) (code (^)))
      (if (pair? lst)
          (loop (+ count 1)
                (cdr lst)
                (let ((obj (car lst)))
                  (if (proc-obj? obj)
                      code
                      (let ((state (table-ref table obj)))
                        (if (or (> (vector-ref state 0) 1) ;; use a variable?
                                (eq? (target-name (ctx-target ctx)) 'python)) ;; Python can't handle deep nestings
                            (let ((cst
                                   (^array-index
                                    (gvm-state-cst ctx)
                                    count))
                                  (val
                                   (car (vector-ref state 1))))
                              (set-car! (vector-ref state 1) cst)
                              (^ code
                                 (^assign cst val)))
                            code)))))
          code))))

(define (univ-obj-use ctx obj force-var? gen-expr)
  (if force-var?
      (use-resource ctx 'rd 'cst))
  (let* ((objs-used (ctx-objs-used ctx))
         (table (objs-used-table objs-used))
         (state (table-ref table obj #f)))
    (if state ;; don't add to table if obj was added before

        (begin
          (vector-set! state 0 (+ (vector-ref state 0) 1)) ;; increment reference count
          (vector-ref state 1))

        (let* ((code (list #f))
               (state (vector (if force-var? 2 1) code)))
          (table-set! table obj state)
          (set-car! code (gen-expr))
          (let ((stack (objs-used-stack objs-used)))
            (objs-used-stack-set! objs-used (cons obj stack)))
          code))))

(define (make-objs-used)
  (vector '()
          (make-table test: eq?)))

(define (objs-used-stack ou)        (vector-ref ou 0))
(define (objs-used-stack-set! ou x) (vector-set! ou 0 x))

(define (objs-used-table ou)        (vector-ref ou 1))
(define (objs-used-table-set! ou x) (vector-set! ou 1 x))

(define (univ-dump-procs global-ctx procs)

  (let ((proc-seen (queue-empty))
        (proc-left (queue-empty)))

    (define (scan-obj obj)
      (if (and (proc-obj? obj)
               (proc-obj-code obj)
               (not (memq obj (queue->list proc-seen))))
          (begin
            (queue-put! proc-seen obj)
            (queue-put! proc-left obj))))

    (define (dump-proc p)

      (define (scan-bbs ctx bbs)
        (let* ((bb-done (make-stretchable-vector #f))
               (bb-todo (queue-empty)))

          (define (todo-lbl-num! n)
            (queue-put! bb-todo (lbl-num->bb n bbs)))

          (define (scan-bb ctx bb)
            (if (stretchable-vector-ref bb-done (bb-lbl-num bb))
                (^)
                (begin
                  (stretchable-vector-set! bb-done (bb-lbl-num bb) #t)
                  (scan-bb-all ctx bb))))

          (define (scan-bb-all ctx bb)
            (scan-gvm-label
             ctx
             (bb-label-instr bb)
             (lambda (ctx)
               (scan-bb-all-except-label ctx bb))))

          (define (scan-bb-all-except-label ctx bb)
            (let loop ((lst (bb-non-branch-instrs bb))
                       (rev-res '()))
              (if (pair? lst)
                  (loop (cdr lst)
                        (cons (scan-gvm-instr ctx (car lst))
                              rev-res))
                  (reverse
                   (cons (scan-gvm-instr ctx (bb-branch-instr bb))
                         rev-res)))))

          (define (scan-gvm-label ctx gvm-instr proc)

            (define (frame-info gvm-instr)
              (let* ((frame
                      (gvm-instr-frame gvm-instr))
                     (fs
                      (frame-size frame))
                     (vars
                      (reverse (frame-slots frame)))
                     (link
                      (pos-in-list ret-var vars)))
                (vector fs link)))

            (with-stack-base-offset
             ctx
             (- (frame-size (gvm-instr-frame gvm-instr)))
             (lambda (ctx)
               (let* ((id
                       (gvm-bb-use ctx (label-lbl-num gvm-instr) (ctx-ns ctx)))
                      (header
                       (case (label-type gvm-instr)

                         ((simple)
                          (^ "\n"))

                         ((entry)
                          (if (label-entry-rest? gvm-instr)
                              (^ " "
                                 (univ-comment
                                  ctx
                                  (if (label-entry-closed? gvm-instr)
                                      "closure-entry-point (+rest)\n"
                                      "entry-point (+rest)\n")))
                              (^ " "
                                 (univ-comment
                                  ctx
                                  (if (label-entry-closed? gvm-instr)
                                      "closure-entry-point\n"
                                      "entry-point\n")))))

                         ((return)
                          (^ " "
                             (univ-comment ctx "return-point\n")))

                         ((task-entry)
                          (^ " "
                             (univ-comment ctx "task-entry-point\n")))

                         ((task-return)
                          (^ " "
                             (univ-comment ctx "task-return-point\n")))

                         (else
                          (compiler-internal-error
                           "scan-gvm-label, unknown label type"))))
                      (gen-body
                       (lambda (ctx)
                         (^ (case (label-type gvm-instr)

                              ((entry)
                               (univ-label-entry ctx
                                                 gvm-instr
                                                 (^global-function (^prefix id))))

                              (else
                               (^)))

                            (proc ctx)))))

                 (^ "\n"
                    (^procedure-declaration ;;TODO: method declaration

                     ;; global?
                     #t

                     ;; name
                     id

                     ;; params
                     '()

                     ;; header
                     header

                     ;; attribs
                     (if (memq (label-type gvm-instr) '(entry return))

                         (append

                          (let ((entry (bbs-entry-lbl-num bbs)))
                            (list (cons "id" (^int (label-lbl-num gvm-instr)))
                                  (cons "parent" (gvm-lbl-use ctx (make-lbl entry)))))

                          (if (eq? (label-type gvm-instr) 'return)

                              (let ((info (frame-info gvm-instr)))
                                (list (cons "fs" (vector-ref info 0))
                                      (cons "link" (+ (vector-ref info 1) 1))))

                              (list (cons "proc_name"
                                          (^str (proc-obj-name p)))
                                    (cons "nb_closed"
                                          (if (label-entry-closed? gvm-instr)
                                              (let* ((frame (gvm-instr-frame gvm-instr))
                                                     (nb-closed (length (frame-closed frame))))
                                                (^int nb-closed))
                                              (^int -1)))
                                    (cons "info"
                                          (^obj #f))))) ;; TODO

                         '())

                     ;; gen-body
                     (gen-body ctx)))))))

          (define (scan-gvm-instr ctx gvm-instr)

            ;; TODO: combine with scan-gvm-opnd
            (define (scan-opnd gvm-opnd)
              (cond ((not gvm-opnd))
                    ((lbl? gvm-opnd)
                     (todo-lbl-num! (lbl-num gvm-opnd)))
                    ((obj? gvm-opnd)
                     (scan-obj (obj-val gvm-opnd)))
                    ((clo? gvm-opnd)
                     (scan-opnd (clo-base gvm-opnd)))))

            ;;(write-gvm-instr gvm-instr ##stderr-port)(newline ##stderr-port);;;;;;;;;;;;;;;;;;

            ;; TODO: combine with scan-gvm-opnd
            (case (gvm-instr-type gvm-instr)

              ((apply)
               (for-each scan-opnd (apply-opnds gvm-instr))
               (if (apply-loc gvm-instr)
                   (scan-opnd (apply-loc gvm-instr))))

              ((copy)
               (scan-opnd (copy-opnd gvm-instr))
               (scan-opnd (copy-loc gvm-instr)))

              ((close)
               (for-each (lambda (parms)
                           (scan-opnd (closure-parms-loc parms))
                           (scan-opnd (make-lbl (closure-parms-lbl parms)))
                           (for-each scan-opnd (closure-parms-opnds parms)))
                         (close-parms gvm-instr)))

              ((ifjump)
               (for-each scan-opnd (ifjump-opnds gvm-instr)))

              ((switch)
               (scan-opnd (switch-opnd gvm-instr))
               (for-each (lambda (c) (scan-obj (switch-case-obj c)))
                         (switch-cases gvm-instr)))

              ((jump)
               (scan-opnd (jump-opnd gvm-instr))))

            (case (gvm-instr-type gvm-instr)

              ((apply)
               (let ((loc (apply-loc gvm-instr))
                     (prim (apply-prim gvm-instr))
                     (opnds (apply-opnds gvm-instr)))
                 (let ((proc (proc-obj-inline prim)))
                   (if (not proc)

                       (compiler-internal-error
                        "scan-gvm-instr, unknown 'prim'" prim)

                       (proc
                        ctx
                        (lambda (result)
                          (cond (loc ;; result is needed?
                                 (^setloc loc (or result (^void))))
                                ;; if result is not needed, don't generate expression
                                ;;(result
                                ;; (^expr-statement result))
                                (else
                                 (^))))
                        opnds)))))

              ((copy)
               (let ((loc (copy-loc gvm-instr))
                     (opnd (copy-opnd gvm-instr)))
                 (if opnd
                     (begin
                       (scan-gvm-opnd ctx loc);;;;;;;;;;;;;;;; needed?
                       (scan-gvm-opnd ctx opnd)
                       (^setloc loc (^getopnd opnd)))
                     (^))))

              ((close)
               (let ()

                 (define (alloc lst rev-loc-names)
                   (if (pair? lst)

                       (let* ((parms (car lst))
                              (lbl (closure-parms-lbl parms))
                              (loc (closure-parms-loc parms))
                              (opnds (closure-parms-opnds parms)))
                         (univ-closure-alloc
                          ctx
                          lbl
                          (map (lambda (opnd)
                                 (cond ((assv opnd rev-loc-names) => cdr)
                                       ((memv opnd (map closure-parms-loc lst))
                                        (^bool #f))
                                       (else
                                        (^getopnd opnd))))
                               opnds)
                          (lambda (name)
                            (alloc (cdr lst)
                                   (cons (cons loc name)
                                         rev-loc-names)))))

                       (init (close-parms gvm-instr) (reverse rev-loc-names))))

                 (define (init lst loc-names)
                   (if (pair? lst)

                       (let* ((parms (car lst))
                              (loc (closure-parms-loc parms))
                              (opnds (closure-parms-opnds parms))
                              (loc-name (assv loc loc-names)))
                         (let loop ((i 1) ;; 0
                                    (opnds opnds) ;; (cons (make-lbl lbl) opnds)
                                    (rev-code '()))
                           (if (pair? opnds)
                               (let ((opnd (car opnds)))
                                 (loop (+ i 1)
                                       (cdr opnds)
                                       (cons (if (and (assv opnd loc-names)
                                                      (memv opnd (map closure-parms-loc lst)))
                                                 (^setclo
                                                  (cdr loc-name)
                                                  i
                                                  (cdr (assv opnd loc-names)))
                                                 (^))
                                             rev-code)))
                               (^ (reverse rev-code)
                                  (init (cdr lst) loc-names)))))

                       (map
                        (lambda (loc-name)
                          (let* ((loc (car loc-name))
                                 (name (cdr loc-name)))
                            (^setloc loc name)))
                        loc-names)))

                 (alloc (close-parms gvm-instr) '())))

              ((ifjump)
               ;; TODO
               ;; (ifjump-poll? gvm-instr)
               (let ((test (ifjump-test gvm-instr))
                     (opnds (ifjump-opnds gvm-instr))
                     (true (ifjump-true gvm-instr))
                     (false (ifjump-false gvm-instr))
                     (fs (frame-size (gvm-instr-frame gvm-instr))))

                 (let ((proc (proc-obj-test test)))
                   (if (not proc)

                       (compiler-internal-error
                        "scan-gvm-instr, unknown 'test'" test)


                       (proc
                        ctx
                        (lambda (result)
                          (^if result
                               (jump-to-label ctx true fs)
                               (jump-to-label ctx false fs)))
                        opnds)))))

              ((switch)
               ;; TODO
               ;; (switch-opnd gvm-instr)
               ;; (switch-cases gvm-instr)
               ;; (switch-poll? gvm-instr)
               ;; (switch-default gvm-instr)
               (univ-throw ctx "\"switch GVM instruction unimplemented\""))

              ((jump)
               ;; TODO
               ;; (jump-safe? gvm-instr)
               ;; test: (jump-poll? gvm-instr)

               (let ((nb-args (jump-nb-args gvm-instr))
                     (poll? (jump-poll? gvm-instr))
                     (safe? (jump-safe? gvm-instr))
                     (opnd (jump-opnd gvm-instr))
                     (fs (frame-size (gvm-instr-frame gvm-instr))))

                 (or (and (obj? opnd)
                          (proc-obj? (obj-val opnd))
                          nb-args
                          (let* ((proc (obj-val opnd))
                                 (jump-inliner (proc-obj-jump-inline proc)))
                            (and jump-inliner
                                 (jump-inliner ctx nb-args poll? safe? fs))))

                     (^ (if nb-args
                            (^setnargs nb-args)
                            (^))

                        (or (and (lbl? opnd)
                                 (not poll?)
                                 (jump-to-label ctx (lbl-num opnd) fs))

                            (with-stack-pointer-adjust
                             ctx
                             (+ fs
                                (ctx-stack-base-offset ctx))
                             (lambda (ctx)
                               (^return-poll
                                (if (jump-safe? gvm-instr)
                                    (if (glo? opnd)
                                        (^call-prim
                                         (^prefix (univ-use-rtlib ctx 'check_procedure_glo))
                                         (scan-gvm-opnd ctx opnd)
                                         (^obj (glo-name opnd)))
                                        (^call-prim
                                         (^prefix (univ-use-rtlib ctx 'check_procedure))
                                         (scan-gvm-opnd ctx opnd)))
                                    (scan-gvm-opnd ctx opnd))
                                poll?
                                (case (target-name (ctx-target ctx))
                                  ((js)
                                   ;; avoid call optimization on JavaScript
                                   ;; globals, because the underlying
                                   ;; JavaScript VM uses a counterproductive
                                   ;; speculative optimization (which slows
                                   ;; down fib by a factor of 10!)
                                   (not (reg? opnd)))
                                  ((php)
                                   ;; avoid call optimization on PHP
                                   ;; because it generates syntactically
                                   ;; incorrect code (PHP grammar issue)
                                   #f)
                                  (else
                                   #t))))))))))

              (else
               (compiler-internal-error
                "scan-gvm-instr, unknown 'gvm-instr':"
                gvm-instr))))

          (define (jump-to-label ctx n jump-fs)

            (cond ((and (ctx-allow-jump-destination-inlining? ctx)
                        (let* ((bb (lbl-num->bb n bbs))
                               (label-instr (bb-label-instr bb)))
                          (and (eq? (label-type label-instr) 'simple)
                               (or (= (length (bb-precedents bb)) 1)
                                   (= (length (bb-non-branch-instrs bb)) 0))))) ;; very short destination bb?
                   (let* ((bb (lbl-num->bb n bbs))
                          (label-instr (bb-label-instr bb))
                          (label-fs (frame-size (gvm-instr-frame label-instr))))
                     (with-stack-pointer-adjust
                      ctx
                      (+ jump-fs
                         (ctx-stack-base-offset ctx))
                      (lambda (ctx)
                        (with-stack-base-offset
                         ctx
                         (- label-fs)
                         (lambda (ctx)
                           (with-allow-jump-destination-inlining?
                            ctx
                            (= (length (bb-precedents bb)) 1) ;; #f
                            (lambda (ctx)
                              (scan-bb-all-except-label ctx bb)))))))))

                  (else
                   (with-stack-pointer-adjust
                    ctx
                    (+ jump-fs
                       (ctx-stack-base-offset ctx))
                    (lambda (ctx)
                      (^return-call
                       (scan-gvm-opnd ctx (make-lbl n))))))))

          (define (scan-gvm-opnd ctx gvm-opnd)
            (if (lbl? gvm-opnd)
                (todo-lbl-num! (lbl-num gvm-opnd)))
            (^getopnd gvm-opnd));;;;;;;;;;;;;;;;;;;;;;;scan-gvm-loc ?

          (todo-lbl-num! (bbs-entry-lbl-num bbs))

          (let ((bbs-code
                 (let loop ((rev-res '()))
                   (if (queue-empty? bb-todo)
                       (reverse rev-res)
                       (loop (cons (scan-bb ctx (queue-get! bb-todo))
                                   rev-res))))))
            (^ bbs-code
               (if (proc-obj-primitive? p)
                   (let ((name (string->symbol (proc-obj-name p))))
                     (^ "\n"
                        (^setprm name (^obj p))
                        (^setglo name (^obj p))))
                   (^))))))

      (let ((ctx (make-ctx
                  (ctx-target global-ctx)
                  (ctx-options global-ctx)
                  (ctx-module-ns global-ctx)
                  (proc-obj-name p)
                  (ctx-objs-used global-ctx)
                  (ctx-rtlib-features-used global-ctx)
                  (ctx-decls global-ctx))))
        (^ "\n"
           (univ-comment
            ctx
            (^ "-------------------------------- "
               (if (proc-obj-primitive? p)
                   "primitive"
                   "procedure")
               " "
               (object->string (string->canonical-symbol (proc-obj-name p)))
               " =\n"))
           (let ((x (proc-obj-code p)))
             (if (bbs? x)
                 (scan-bbs ctx x)
                 (^))))))

    (for-each scan-obj procs)

    (let loop ((rev-res '()))
      (if (queue-empty? proc-left)

          (reverse (append rev-res *constants*))

          (loop (cons (dump-proc (queue-get! proc-left))
                      rev-res))))))

(define (univ-label-entry ctx gvm-instr id)
  (let* ((nb-parms (label-entry-nb-parms gvm-instr))
         (opts (label-entry-opts gvm-instr))
         (keys (label-entry-keys gvm-instr))
         (rest? (label-entry-rest? gvm-instr))
         (closed? (label-entry-closed? gvm-instr))
         (nb-parms-except-rest
          (- nb-parms (if rest? 1 0)))
         (nb-keys
          (if keys (length keys) 0))
         (nb-req-and-opt
          (- nb-parms-except-rest nb-keys))
         (nb-opts
          (length opts))
         (nb-req
          (- nb-req-and-opt nb-opts))
         (defaults
           (append opts (map cdr (or keys '())))))

    (define (dispatch-on-nb-args nb-args)
      (if (> nb-args (- nb-req-and-opt (if rest? 0 1)))

          (if keys
              (compiler-internal-error
               "univ-label-entry, keyword parameters not supported")
              (^if (if rest?
                       (^not (^call-prim
                              (^prefix (univ-use-rtlib ctx 'build_rest))
                              nb-parms-except-rest))
                       (^!= (^getnargs)
                            nb-parms-except-rest))
                   (^return-call-prim
                    (^prefix (univ-use-rtlib ctx 'wrong_nargs))
                    (if closed?
                        (^getreg (+ univ-nb-arg-regs 1))
                        id))))

          (let ((nb-stacked (max 0 (- nb-args univ-nb-arg-regs)))
                (nb-stacked* (max 0 (- nb-parms univ-nb-arg-regs))))

            (define (setup-parameter i)
              (if (<= i nb-parms)
                  (let* ((rest (setup-parameter (+ i 1)))
                         (src-reg (- i nb-stacked))
                         (src (cond ((<= i nb-args)
                                     (^getreg src-reg))
                                    ((and rest? (= i nb-parms))
                                     (^obj '()))
                                    (else
                                     (^obj
                                      (obj-val (list-ref defaults (- i nb-req 1))))))))
                    (if (<= i nb-stacked*)
                        (^ (^push src)
                           rest)
                        (if (and (<= i nb-args) (= nb-stacked nb-stacked*))
                            rest
                            (let ((dst-reg (- i nb-stacked*)))
                              (^ (^setreg dst-reg src)
                                 rest)))))
                  (^)))

            (let ((x (setup-parameter (+ nb-stacked 1))))
              (^if (^= (^getnargs)
                       nb-args)
                   x
                   (dispatch-on-nb-args (+ nb-args 1)))))))

    (dispatch-on-nb-args nb-req)))

(define closure-count 0)

(define (univ-separated-list sep lst)
  (if (pair? lst)
      (if (pair? (cdr lst))
          (list (car lst) sep (univ-separated-list sep (cdr lst)))
          (car lst))
      '()))

(define (univ-map-index f lst)

  (define (mp f lst i)
    (if (pair? lst)
        (cons (f (car lst) i)
              (mp f (cdr lst) (+ i 1)))
        '()))

  (mp f lst 0))

(define (univ-closure-alloc ctx lbl exprs cont)
  (let ((count (ctx-serial-num ctx)))
    (ctx-serial-num-set! ctx (+ count 1))
    (let ((name
           (^local-var (string-append "closure" (number->string count)))))
      (^ (^var-declaration
          name
          (^call-prim
           (^prefix (univ-use-rtlib ctx 'closure_alloc))
           (^array-literal
            (cons (gvm-lbl-use ctx (make-lbl lbl))
                  exprs))))
         (cont name)))))

(define (make-ctx target options module-ns ns objs-used rtlib-features-used decls)
  (vector target
          options
          module-ns
          ns
          0
          0
          univ-enable-jump-destination-inlining?
          (make-resource-set)
          (make-resource-set)
          (make-resource-set)
          objs-used
          rtlib-features-used
          decls))

(define (ctx-target ctx)                   (vector-ref ctx 0))
(define (ctx-target-set! ctx x)            (vector-set! ctx 0 x))

(define (ctx-options ctx)                  (vector-ref ctx 1))
(define (ctx-options-set! ctx x)           (vector-set! ctx 1 x))

(define (ctx-module-ns ctx)                (vector-ref ctx 2))
(define (ctx-module-ns-set! ctx x)         (vector-set! ctx 2 x))

(define (ctx-ns ctx)                       (vector-ref ctx 3))
(define (ctx-ns-set! ctx x)                (vector-set! ctx 3 x))

(define (ctx-stack-base-offset ctx)        (vector-ref ctx 4))
(define (ctx-stack-base-offset-set! ctx x) (vector-set! ctx 4 x))

(define (ctx-serial-num ctx)               (vector-ref ctx 5))
(define (ctx-serial-num-set! ctx x)        (vector-set! ctx 5 x))

(define (ctx-allow-jump-destination-inlining? ctx)        (vector-ref ctx 6))
(define (ctx-allow-jump-destination-inlining?-set! ctx x) (vector-set! ctx 6 x))

(define (ctx-resources-used-rd ctx)        (vector-ref ctx 7))
(define (ctx-resources-used-rd-set! ctx x) (vector-set! ctx 7 x))

(define (ctx-resources-used-wr ctx)        (vector-ref ctx 8))
(define (ctx-resources-used-wr-set! ctx x) (vector-set! ctx 8 x))

(define (ctx-globals-used ctx)             (vector-ref ctx 9))
(define (ctx-globals-used-set! ctx x)      (vector-set! ctx 9 x))

(define (ctx-objs-used ctx)                (vector-ref ctx 10))
(define (ctx-objs-used-set! ctx x)         (vector-set! ctx 10 x))

(define (ctx-rtlib-features-used ctx)        (vector-ref ctx 11))
(define (ctx-rtlib-features-used-set! ctx x) (vector-set! ctx 11 x))

(define (ctx-decls ctx)                      (vector-ref ctx 12))
(define (ctx-decls-set! ctx x)               (vector-set! ctx 12 x))

(define (with-stack-base-offset ctx n proc)
  (let ((save (ctx-stack-base-offset ctx)))
    (ctx-stack-base-offset-set! ctx n)
    (let ((result (proc ctx)))
      (ctx-stack-base-offset-set! ctx save)
      result)))

(define (with-stack-pointer-adjust ctx n proc)
  (^ (if (equal? n 0)
         (^)
         (^inc-by (gvm-state-sp-use ctx 'rdwr)
                  n))
     (with-stack-base-offset
      ctx
      (- (ctx-stack-base-offset ctx) n)
      proc)))

(define (with-allow-jump-destination-inlining? ctx allow? proc)
  (let ((save (ctx-allow-jump-destination-inlining? ctx)))
    (ctx-allow-jump-destination-inlining?-set! ctx allow?)
    (let ((result (proc ctx)))
      (ctx-allow-jump-destination-inlining?-set! ctx save)
      result)))

(define (with-new-resources-used ctx proc)
  (let ((save-rsrc-rd (ctx-resources-used-rd ctx))
        (save-rsrc-wr (ctx-resources-used-wr ctx))
        (save-glob-rd (ctx-globals-used ctx)))
    (ctx-resources-used-rd-set! ctx (make-resource-set))
    (ctx-resources-used-wr-set! ctx (make-resource-set))
    (ctx-globals-used-set! ctx (make-resource-set))
    (let ((result (proc ctx)))
      (ctx-resources-used-rd-set! ctx save-rsrc-rd)
      (ctx-resources-used-wr-set! ctx save-rsrc-wr)
      (ctx-globals-used-set! ctx save-glob-rd)
      result)))

(define (make-resource-set)
  (make-table))

(define (resource-set-add! set element)
  (table-set! set element #t))

(define (resource-set-member? set element)
  (table-ref set element #f))

(define (resource-set->list set)
  (map car (table->list set)))

(define (use-resource-rd ctx resource)
  (resource-set-add! (ctx-resources-used-rd ctx) resource))

(define (use-resource-wr ctx resource)
  (resource-set-add! (ctx-resources-used-wr ctx) resource))

(define (use-global ctx global)
  (resource-set-add! (ctx-globals-used ctx) global))

(define (univ-use-rtlib ctx feature)
  (resource-set-add! (ctx-rtlib-features-used ctx) feature)
  (symbol->string feature))

(define (use-resource ctx dir resource)
  (if (or (eq? dir 'rd) (eq? dir 'rdwr))
      (use-resource-rd ctx resource))
  (if (or (eq? dir 'wr) (eq? dir 'rdwr))
      (use-resource-wr ctx resource)))

(define (gvm-state-pollcount ctx)
  (^global-var (^prefix "pollcount")))

(define (gvm-state-nargs ctx)
  (^global-var (^prefix "nargs")))

(define (gvm-state-reg ctx num)
  (^global-var (^prefix (^ "r" num))))

(define (gvm-state-stack ctx)
  (^global-var (^prefix "stack")))

(define (gvm-state-sp ctx)
  (^global-var (^prefix "sp")))

(define (gvm-state-cst ctx)
  (^global-var (^prefix (^ "cst_" (scheme-id->c-id (ctx-module-ns ctx))))))

(define (gvm-state-prm ctx)
  (^global-var (^prefix "prm")))

(define (gvm-state-glo ctx)
  (^global-var (^prefix "glo")))

(define (gvm-state-pollcount-use ctx dir)
  (use-resource ctx dir 'pollcount)
  (gvm-state-pollcount ctx))

(define (gvm-state-nargs-use ctx dir)
  (use-resource ctx dir 'nargs)
  (gvm-state-nargs ctx))

(define (gvm-state-reg-use ctx dir num)
  (use-resource ctx dir num)
  (gvm-state-reg ctx num))

(define (gvm-state-stack-use ctx dir)
  (use-resource ctx dir 'stack)
  (gvm-state-stack ctx))

(define (gvm-state-sp-use ctx dir)
  (use-resource ctx dir 'sp)
  (gvm-state-sp ctx))

(define (gvm-state-prm-use ctx dir)
  (use-resource ctx dir 'prm)
  (gvm-state-prm ctx))

(define (gvm-state-glo-use ctx dir)
  (use-resource ctx dir 'glo)
  (gvm-state-glo ctx))

(define (univ-emit-tos ctx)
  (^array-index
   (gvm-state-stack-use ctx 'rd)
   (gvm-state-sp-use ctx 'rd)))

(define (univ-emit-pop ctx receiver)
  (^ (receiver (^tos))
     (^inc-by (gvm-state-sp-use ctx 'rdwr)
              -1)))

(define (univ-emit-push ctx val)
  (^inc-by (gvm-state-sp-use ctx 'rdwr)
           1
           (lambda (x)
             (^assign
              (^array-index
               (gvm-state-stack-use ctx 'rd)
               x)
              val))))

(define (univ-emit-getnargs ctx)
  (gvm-state-nargs-use ctx 'rd))

(define (univ-emit-setnargs ctx nb-args)
  (^assign
   (gvm-state-nargs-use ctx 'wr)
   nb-args))

(define (univ-emit-getreg ctx num)
  (gvm-state-reg-use ctx 'rd num))

(define (univ-emit-setreg ctx num val)
  (^assign
   (gvm-state-reg-use ctx 'wr num)
   val))

(define (univ-stk-slot-from-tos ctx offset)
  (^array-index
   (gvm-state-stack-use ctx 'rd)
   (^- (gvm-state-sp-use ctx 'rd)
       offset)))

(define (univ-stk-location ctx offset)
  (^array-index
   (gvm-state-stack-use ctx 'rd)
   (^ (gvm-state-sp-use ctx 'rd)
      (cond ((= offset 0)
             (^))
            ((< offset 0)
             (^ offset))
            (else
             (^ "+" offset))))))

(define (univ-emit-getstk ctx offset)
  (univ-stk-location ctx offset))

(define (univ-emit-setstk ctx offset val)
  (^assign
   (univ-stk-location ctx offset)
   val))

(define (univ-clo-slots ctx closure)
  (case (univ-procedure-representation ctx)

    ((class)
     (^member closure "slots"))

    (else
     (case (target-name (ctx-target ctx))
       ((php)
        (^member closure "slots"))
       (else
        (^call closure (^bool #t)))))))

(define (univ-emit-getclo ctx closure index)
  (^closure-ref closure index))

(define (univ-emit-setclo ctx closure index val)
  (^closure-set! closure index val))

(define (univ-prm-location ctx name)
  (^prop-index
   (gvm-state-prm-use ctx 'rd)
   (^str (symbol->string name))))

(define (univ-glo-location ctx name)

  (if (member name
              '(println
                real-time-milliseconds))
      (univ-use-rtlib
       ctx
       (string->symbol (string-append "glo-" (symbol->string name)))))

  (^prop-index
   (gvm-state-glo-use ctx 'rd)
   (^str (symbol->string name))))

(define (univ-emit-getprm ctx name)
  (univ-prm-location ctx name))

(define (univ-emit-setprm ctx name val)
  (^assign
   (univ-prm-location ctx name)
   val))

(define (univ-emit-getglo ctx name)
  (univ-glo-location ctx name))

(define (univ-emit-setglo ctx name val)
  (^assign
   (univ-glo-location ctx name)
   val))

(define (univ-glo-location-dynamic ctx sym)
  (^prop-index
   (gvm-state-glo-use ctx 'rd)
   (^symbol-unbox sym)))

(define (univ-glo-primitive-location-dynamic ctx sym)
  (^prop-index
   (gvm-state-prm-use ctx 'rd)
   (^symbol-unbox sym)))

(define (univ-emit-glo-var-ref ctx sym)
  (univ-glo-location-dynamic ctx sym))

(define (univ-emit-glo-var-primitive-ref ctx sym)
  (univ-glo-primitive-location-dynamic ctx sym))

(define (univ-emit-glo-var-set! ctx sym val)
  (^assign
   (univ-glo-location-dynamic ctx sym)
   val))

(define (univ-emit-glo-var-primitive-set! ctx sym val)
  (^assign
   (univ-glo-primitive-location-dynamic ctx sym)
   val))

(define (univ-emit-getopnd ctx gvm-opnd)

  (cond ((reg? gvm-opnd)
         (^getreg (reg-num gvm-opnd)))

        ((stk? gvm-opnd)
         (^getstk (+ (stk-num gvm-opnd) (ctx-stack-base-offset ctx))))

        ((glo? gvm-opnd)
         (^getglo (glo-name gvm-opnd)))

        ((clo? gvm-opnd)
         (^getclo (^getopnd (clo-base gvm-opnd))
                  (clo-index gvm-opnd)))

        ((lbl? gvm-opnd)
         (gvm-lbl-use ctx gvm-opnd))

        ((obj? gvm-opnd)
         (^obj (obj-val gvm-opnd)))

        (else
         (compiler-internal-error
          "univ-emit-getopnd, unknown 'gvm-opnd':"
          gvm-opnd))))

(define (univ-emit-getopnds ctx gvm-opnds)
  (map (lambda (gvm-opnd) (univ-emit-getopnd ctx gvm-opnd))
       gvm-opnds))

(define (univ-emit-setloc ctx gvm-loc val)

  (cond ((reg? gvm-loc)
         (^setreg (reg-num gvm-loc)
                  val))

        ((stk? gvm-loc)
         (^setstk (+ (stk-num gvm-loc) (ctx-stack-base-offset ctx))
                  val))

        ((glo? gvm-loc)
         (^setglo (glo-name gvm-loc)
                  val))

        ((clo? gvm-loc)
         (^setclo (^getopnd (clo-base gvm-loc))
                  (clo-index gvm-loc)
                  val))

        (else
         (compiler-internal-error
          "univ-emit-setloc, unknown 'gvm-loc':"
          gvm-loc))))

(define (univ-emit-obj ctx obj)

  (define (emit-obj obj force-var?)

    (cond ((or (false-object? obj)
               (boolean? obj))
           (^boolean-obj obj))

          ((number? obj)
           (cond ((not (real? obj)) ;; non-real complex number
                  (univ-obj-use
                   ctx
                   obj
                   force-var?
                   (lambda ()
                     (^cpxnum-make (emit-obj (real-part obj) #f)
                                   (emit-obj (imag-part obj) #f)))))

                 ((not (exact? obj)) ;; floating-point number
                  (let ((x (^float obj)))
                    (univ-box
                     (univ-obj-use
                      ctx
                      obj
                      force-var?
                      (lambda ()
                        (^flonum-box x)))
                     x)))

                 ((not (integer? obj)) ;; non-integer rational number
                  (univ-obj-use
                   ctx
                   obj
                   force-var?
                   (lambda ()
                     (^ratnum-make (emit-obj (numerator obj) #f)
                                   (emit-obj (denominator obj) #f)))))

                 (else ;; exact integer
                  (if (and (>= obj univ-fixnum-min)
                           (<= obj univ-fixnum-max))

                      (^fixnum-box (^int obj))

                      (univ-obj-use
                       ctx
                       obj
                       force-var?
                       (lambda ()
                         (^new (^prefix-class (univ-use-rtlib ctx 'Bignum))
                               (^array-literal
                                (univ-bignum-digits obj)))))))))

          ((char? obj)
           (^char-obj obj force-var?))

          ((string? obj)
           (^string-obj obj force-var?))

          ((symbol-object? obj)
           (^symbol-obj obj force-var?))

          ((keyword-object? obj)
           (^keyword-obj obj force-var?))

          ((null? obj)
           (^null))

          ((void-object? obj)
           (^void))

          ((end-of-file-object? obj)
           (^eof))

          ((absent-object? obj)
           (^absent))

          ((unbound1-object? obj)
           (^unbound1))

          ((unbound2-object? obj)
           (^unbound2))

          ((optional-object? obj)
           (^optional))

          ((key-object? obj)
           (^key))

          ((rest-object? obj)
           (^rest))

          ((proc-obj? obj)
           (^global-function (^prefix (gvm-proc-use ctx (proc-obj-name obj)))))

          ((pair? obj)
           (univ-obj-use
            ctx
            obj
            force-var?
            (lambda ()
              (^cons (emit-obj (car obj) #f)
                     (emit-obj (cdr obj) #f)))))

          ((vector-object? obj)
           (univ-obj-use
            ctx
            obj
            force-var?
            (lambda ()
              (^vector-box
               (^array-literal
                (map (lambda (x) (emit-obj x #f))
                     (vector->list obj)))))))

          ((u8vect? obj)
           (univ-obj-use
            ctx
            obj
            force-var?
            (lambda ()
              (^u8vector-box
               (^array-literal
                (map (lambda (x) (emit-obj x #f))
                     (u8vect->list obj)))))))

          ((u16vect? obj)
           (univ-obj-use
            ctx
            obj
            force-var?
            (lambda ()
              (^u16vector-box
               (^array-literal
                (map (lambda (x) (emit-obj x #f))
                     (u16vect->list obj)))))))

          ((f64vect? obj)
           (univ-obj-use
            ctx
            obj
            force-var?
            (lambda ()
              (^f64vector-box
               (^array-literal
                (map (lambda (x) (emit-obj x #f))
                     (f64vect->list obj)))))))

          ((structure-object? obj)
           (univ-obj-use
            ctx
            obj
            force-var?
            (lambda ()
              (let* ((slots
                      (##vector-copy obj));;TODO: replace call of ##vector-copy
                     (cyclic?
                      (eq? (vector-ref slots 0) obj)))
                ;; the root type descriptor is cyclic, handle this specially
                (if cyclic?
                    (vector-set! slots 0 #f))
                (^structure-box
                 (^array-literal
                  (map (lambda (x) (emit-obj x #f))
                       (vector->list slots))))))))

          (else
           (compiler-user-warning #f "UNIMPLEMENTED OBJECT:" obj)
           (^str
            (string-append
             "UNIMPLEMENTED OBJECT: "
             (object->string obj))))))

  (emit-obj obj #t))

(define univ-adigit-width 14)

(define (univ-bignum-digits obj)

  (define (dig n len rest)
    (cond ((= len 1)
           (cons n rest))
          (else
           (let* ((hi-len (quotient len 2))
                  (lo-len (- len hi-len))
                  (lo-len-bits (* univ-adigit-width lo-len)))
             (let* ((hi (arithmetic-shift n (- lo-len-bits)))
                    (lo (- n (arithmetic-shift hi lo-len-bits))))
               (dig lo
                    lo-len
                    (dig hi
                         hi-len
                         rest)))))))

  (let* ((width (integer-length obj))
         (len (+ (quotient width univ-adigit-width) 1)))
    (dig (if (< obj 0)
           (+ (arithmetic-shift 1 (* univ-adigit-width len)) obj)
           obj)
         len
         '())))

(define (univ-emit-array-literal ctx elems)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^ "[" (univ-separated-list "," elems) "]"))

    ((php)
     (^apply "array" elems))

    (else
     (compiler-internal-error
      "univ-emit-array-literal, unknown target"))))

(define (univ-emit-extensible-array-literal ctx elems)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ "[" (univ-separated-list "," elems) "]"))

    ((php)
     (^apply "array" elems))

    ((python)
     (let ((key-vals
            (let loop ((i 0) (lst elems) (rev-kv '()))
              (if (pair? lst)
                  (loop (+ i 1)
                        (cdr lst)
                        (cons (^ i ":" (car lst)) rev-kv))
                  (reverse rev-kv)))))
       (^ "{" (univ-separated-list "," key-vals) "}")))

    (else
     (compiler-internal-error
      "univ-emit-extensible-array-literal, unknown target"))))

(define (univ-new-array ctx len)
  (case (target-name (ctx-target ctx))

    ((js)
     (^new "Array" len))

    ((php)
     (^if-expr (^= len (^int 0)) ;; array_fill does not like len=0
               (^array-literal '())
               (^call-prim
                "array_fill"
                (^int 0)
                len
                (^int 0))))

    ((python)
     (^* (^ "[" (^int 0) "]") len))

    ((ruby)
     (^call-prim (^member "Array" "new") len))

    (else
     (compiler-internal-error
      "univ-new-array, unknown target"))))

(define (univ-make-array ctx return len init)
  (case (target-name (ctx-target ctx))

    ((js)
     ;; TODO: add for loop constructor
     (let ((elems (^local-var 'elems)))
       (^ (^var-declaration elems (^new "Array" len))
          "
          for (var i=0; i<" len "; i++) {
            " elems "[i] = " init ";
          }
          "
          (return elems))))

    ((php)
     (return
      (^if-expr (^= len (^int 0)) ;; array_fill does not like len=0
                (^array-literal '())
                (^call-prim
                 "array_fill"
                 (^int 0)
                 len
                 init))))

    ((python)
     ;; TODO: add literal array constructor
     (return
      (^* (^ "[" init "]") len)))

    ((ruby)
     (return
      (^call-prim (^member "Array" "new") len init)))

    (else
     (compiler-internal-error
      "univ-make-array, unknown target"))))

(define (univ-emit-empty-dict ctx)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^ "{}"))

    ((php)
     (^ "array()"))

    (else
     (compiler-internal-error
      "univ-emit-empty-dict, unknown target"))))

;;==================================================================

(define *constants* '());;;TODO: remove

;; =============================================================================

(define (gvm-lbl-use ctx lbl)
  (^global-function (^prefix (gvm-bb-use ctx (lbl-num lbl) (ctx-ns ctx)))))

(define (gvm-proc-use ctx name)
  (gvm-bb-use ctx 1 name))

(define (gvm-bb-use ctx num ns)
  (let ((id (lbl->id ctx num ns)))
    (use-global ctx (^global-function (^prefix id)))
    id))

(define (lbl->id ctx num ns)
  (^ "bb" num "_" (scheme-id->c-id ns)))

(define (univ-foldr-range lo hi rest fn)
  (if (<= lo hi)
      (univ-foldr-range
       lo
       (- hi 1)
       (fn hi rest)
       fn)
      rest))

(define (univ-emit-continuation-capture-function ctx nb-args thread-save?)
  (let ((nb-stacked (max 0 (- nb-args univ-nb-arg-regs))))
    (^procedure-declaration
     #t
     (^ (if thread-save?
            "thread_save"
            "continuation_capture")
        nb-args)
     '()
     "\n"
     '()
     (^ (if (= nb-stacked 0)
            (^var-declaration (^local-var (^ 'arg 1)) (^getreg 1))
            (univ-foldr-range
             1
             nb-stacked
             (^)
             (lambda (i rest)
               (^ rest
                  (^pop (lambda (expr)
                          (^var-declaration (^local-var (^ 'arg i))
                                            expr)))))))

        (^setreg 0
                 (^call-prim
                  (^prefix (univ-use-rtlib ctx 'heapify))
                  (^getreg 0)))

        (let* ((cont
                (^new (^prefix-class (univ-use-rtlib ctx 'Continuation))
                      (^array-index
                       (gvm-state-stack-use ctx 'rd)
                       0)
                      (^structure-ref (^gvar "current_thread")
                                      univ-thread-denv-slot)))
               (result
                (if thread-save?
                    (^gvar "current_thread")
                    cont)))

          (^ (if thread-save?
                 (^structure-set! (^gvar "current_thread")
                                  univ-thread-cont-slot
                                  cont)
                 (^))

             (if (= nb-stacked 0)
                 (^setreg 1 result)
                 (univ-foldr-range
                  1
                  nb-stacked
                  (^)
                  (lambda (i rest)
                    (^ (^push (if (= i 1) result (^local-var (^ 'arg i))))
                       rest))))))

        (^setnargs nb-args)

        (^return-call (^local-var (^ 'arg 1)))))))

(define (univ-emit-continuation-graft-no-winding-function ctx nb-args thread-restore?)
  (^procedure-declaration
   #t
   (^ (if thread-restore?
          "thread_restore"
          "continuation_graft_no_winding")
      nb-args)
   '()
   "\n"
   '()
   (let* ((nb-stacked
           (max 0 (- nb-args univ-nb-arg-regs)))
          (new-nb-args
           (- nb-args 2))
          (new-nb-stacked
           (max 0 (- new-nb-args univ-nb-arg-regs)))
          (underflow
           (^gvar (univ-use-rtlib ctx 'underflow))))
     (^ (univ-foldr-range
         1
         (max 2 (- nb-args univ-nb-arg-regs))
         (^)
         (lambda (i rest)
           (^ rest
              (^var-declaration
               (^local-var (^ 'arg i))
               (let ((x (- i nb-stacked)))
                 (if (>= x 1)
                     (^getreg x)
                     (^getstk x)))))))

        (if thread-restore?
            (^ (^assign (^gvar "current_thread")
                        (^local-var (^ 'arg 1)))
               (^assign (^local-var (^ 'arg 1))
                        (^structure-ref (^local-var (^ 'arg 1))
                                        univ-thread-cont-slot)))
            (^))

        (^assign
         (^array-index
          (gvm-state-stack-use ctx 'rd)
          0)
         (^member (^local-var (^ 'arg 1)) "frame"))

        (^structure-set! (^gvar "current_thread")
                         univ-thread-denv-slot
                         (^member (^local-var (^ 'arg 1)) "denv"))

        (^assign
         (gvm-state-sp-use ctx 'wr)
         0)

        (^setreg 0 underflow)

        (univ-foldr-range
         1
         new-nb-stacked
         (^)
         (lambda (i rest)
           (^ (^push (^local-var (^ 'arg (+ i 2))))
              rest)))

        (if (= new-nb-stacked (- nb-stacked 2))
            (^)
            (univ-foldr-range
             (+ new-nb-stacked 1)
             new-nb-args
             (^)
             (lambda (i rest)
               (^ (^setreg (- i new-nb-stacked)
                           (^getreg (- i (- nb-stacked 2))))
                  rest))))

        (^setnargs new-nb-args)

        (^return (^local-var (^ 'arg 2)))))))

(define (univ-emit-continuation-return-no-winding-function ctx nb-args)
  (^procedure-declaration
   #t
   (^ "continuation_return_no_winding" nb-args)
   '()
   "\n"
   '()
   (let* ((nb-stacked
           (max 0 (- nb-args univ-nb-arg-regs)))
          (underflow
           (^gvar (univ-use-rtlib ctx 'underflow)))
          (arg1
           (let ((x (- 1 nb-stacked)))
             (if (>= x 1)
                 (^getreg x)
                 (^getstk x)))))
     (^ (^assign
         (^array-index
          (gvm-state-stack-use ctx 'rd)
          0)
         (^member arg1 "frame"))

        (^structure-set! (^gvar "current_thread")
                         univ-thread-denv-slot
                         (^member arg1 "denv"))

        (^assign
         (gvm-state-sp-use ctx 'wr)
         0)

        (^setreg 0 underflow)

        (let ((x (- 2 nb-stacked)))
          (if (= x 1)
              (^)
              (^setreg 1 (^getreg x))))

        (^return underflow)))))

(define (univ-emit-apply-function ctx nb-args)
  (^procedure-declaration
   #t
   (^ "apply" nb-args)
   '()
   "\n"
   '()
   (^ (univ-pop-args-to-vars ctx nb-args)

      (univ-foldr-range
       2
       (- nb-args 1)
       (^)
       (lambda (i rest)
         (^ (^push (^local-var (^ 'arg i)))
            rest)))

      (^setnargs (- nb-args 2))

      (let ((args (^local-var (^ 'arg nb-args))))
        (^while (^pair? args)
                (^ (^push (^getcar args))
                   (^assign args (^getcdr args))
                   (^inc-by (gvm-state-nargs-use ctx 'rdwr)
                            1))))

      (univ-pop-args-to-regs ctx 0)

      (^return (^local-var (^ 'arg 1))))))

(define (univ-pop-args-to-vars ctx nb-args)
  (let ((nb-stacked (max 0 (- nb-args univ-nb-arg-regs))))
    (univ-foldr-range
     1
     nb-args
     (^)
     (lambda (i rest)
       (^ rest
          (let ((x (- i nb-stacked)))
            (if (>= x 1)
                (^var-declaration (^local-var (^ 'arg i))
                                  (^getreg x))
                (^pop (lambda (expr)
                        (^var-declaration (^local-var (^ 'arg i))
                                          expr))))))))))

(define (univ-push-args ctx)
  (univ-foldr-range
   0
   (- univ-nb-arg-regs 1)
   (^)
   (lambda (i rest)
     (^if (^> (^getnargs) i)
          (^ (^push (^getreg (+ i 1)))
             rest)))))

(define (univ-pop-args-to-regs ctx lo)
  (univ-foldr-range
   0
   (- univ-nb-arg-regs 1)
   (^)
   (lambda (i rest)
     (let ((x
            (^ rest
               (^pop (lambda (expr)
                       (^setreg (+ i 1) expr))))))
       (if (< i lo)
           x
           (^if (^> (^getnargs) (- i lo))
                x))))))

(define (univ-rtlib-feature ctx feature)
  (case feature

    ((trampoline)
     (^prim-function-declaration
      "trampoline"
      (list (cons 'pc #f))
      "\n"
      '()
      (let ((pc (^local-var 'pc)))
        (^while (^!= pc (^obj #f))
                (^assign pc
                         (^call pc))))))

    ((heapify)
     (^prim-function-declaration
      "heapify"
      (list (cons 'ra #f))
      "\n"
      '()
      (^ (^if (^> (gvm-state-sp-use ctx 'rd) 0)
              (univ-with-function-attribs
               ctx
               #f
               'ra
               (lambda ()

                 (^ (^var-declaration
                     (^local-var 'fs)
                     (univ-get-function-attrib ctx 'ra 'fs))

                    (^var-declaration
                     (^local-var 'link)
                     (univ-get-function-attrib ctx 'ra 'link))

                    (^var-declaration
                     (^local-var 'base)
                     (^- (gvm-state-sp-use ctx 'rd)
                         (^local-var 'fs)))

                    (^extensible-array-to-array!
                     (gvm-state-stack-use ctx 'rdwr)
                     (^+ (gvm-state-sp-use ctx 'rd) 1))

                    (^var-declaration
                     (^local-var 'chain)
                     (gvm-state-stack-use ctx 'rd))

                    (^if (^> (^local-var 'base) 0)
                         (^ (^assign (^local-var 'chain)
                                     (^subarray
                                      (gvm-state-stack-use ctx 'rd)
                                      (^local-var 'base)
                                      (^+ (^local-var 'fs) 1)))

                            (^assign (^array-index
                                      (^local-var 'chain)
                                      0)
                                     (^local-var 'ra))

                            (^assign (gvm-state-sp-use ctx 'wr)
                                     (^local-var 'base))

                            (^var-declaration
                             (^local-var 'prev_frame)
                             (^alias (^local-var 'chain)))

                            (^var-declaration
                             (^local-var 'prev_link)
                             (^local-var 'link))

                            (^assign (^local-var 'ra)
                                     (^array-index
                                      (^local-var 'prev_frame)
                                      (^local-var 'prev_link)))

                            (univ-with-function-attribs
                             ctx
                             #t
                             'ra
                             (lambda ()

                               (^ (^assign
                                   (^local-var 'fs)
                                   (univ-get-function-attrib ctx 'ra 'fs))

                                  (^assign
                                   (^local-var 'link)
                                   (univ-get-function-attrib ctx 'ra 'link))

                                  (^assign
                                   (^local-var 'base)
                                   (^- (gvm-state-sp-use ctx 'rd)
                                       (^local-var 'fs)))

                                  (^while (^> (^local-var 'base) 0)
                                          (^ (^var-declaration
                                              (^local-var 'frame)
                                              (^subarray
                                               (gvm-state-stack-use ctx 'rd)
                                               (^local-var 'base)
                                               (^+ (^local-var 'fs) 1)))

                                             (^assign
                                              (^array-index
                                               (^local-var 'frame)
                                               0)
                                              (^local-var 'ra))

                                             (^assign
                                              (gvm-state-sp-use ctx 'wr)
                                              (^local-var 'base))

                                             (^assign
                                              (^array-index
                                               (^local-var 'prev_frame)
                                               (^local-var 'prev_link))
                                              (^alias (^local-var 'frame)))

                                             (^assign
                                              (^local-var 'prev_frame)
                                              (^alias (^local-var 'frame)))

                                             (^unalias (^local-var 'frame))

                                             (^assign
                                              (^local-var 'prev_link)
                                              (^local-var 'link))

                                             (^assign
                                              (^local-var 'ra)
                                              (^array-index
                                               (^local-var 'prev_frame)
                                               (^local-var 'prev_link)))

                                             (univ-with-function-attribs
                                              ctx
                                              #t
                                              'ra
                                              (lambda ()

                                                (^ (^assign
                                                    (^local-var 'fs)
                                                    (univ-get-function-attrib ctx 'ra 'fs))

                                                   (^assign
                                                    (^local-var 'link)
                                                    (univ-get-function-attrib ctx 'ra 'link))

                                                   (^assign
                                                    (^local-var 'base)
                                                    (^- (gvm-state-sp-use ctx 'rd)
                                                        (^local-var 'fs))))))))

                                  (^assign
                                   (^array-index
                                    (gvm-state-stack-use ctx 'rd)
                                    (^local-var 'link))
                                   (^array-index
                                    (gvm-state-stack-use ctx 'rd)
                                    0))

                                  (^assign
                                   (^array-index
                                    (gvm-state-stack-use ctx 'rd)
                                    0)
                                   (^local-var 'ra))

                                  (^array-shrink!
                                   (gvm-state-stack-use ctx 'rd)
                                   (^+ (^local-var 'fs) 1))

                                  (^assign
                                   (^array-index
                                    (^local-var 'prev_frame)
                                    (^local-var 'prev_link))
                                   (gvm-state-stack-use ctx 'rd))))))

                         (^ (^assign
                             (^array-index
                              (^local-var 'chain)
                              (^local-var 'link))
                             (^array-index
                              (^local-var 'chain)
                              0))

                            (^assign
                             (^array-index
                              (^local-var 'chain)
                              0)
                             (^local-var 'ra))))

                    (^assign
                     (gvm-state-stack-use ctx 'rd)
                     (^extensible-array-literal
                      (list (^local-var 'chain))))

                    (^assign
                     (gvm-state-sp-use ctx 'wr)
                     0)))))

         (^return
          (^gvar (univ-use-rtlib ctx 'underflow))))))

    ((underflow)
     (^procedure-declaration
      #t
      "underflow"
      '()
      "\n"
      (list (cons "fs" 0))
      (^ (^var-declaration (^local-var "frame")
                           (^array-index
                            (gvm-state-stack-use ctx 'rd)
                            0))

         (^if (^eq? (^local-var "frame") (^obj #f))
              (^return (^obj #f)))

         (^var-declaration (^local-var "ra")
                           (^array-index
                            (^local-var "frame")
                            0))

         (univ-with-function-attribs
          ctx
          #f
          "ra"
          (lambda ()

            (^ (^var-declaration (^local-var "fs")
                                 (univ-get-function-attrib ctx "ra" "fs"))

               (^var-declaration (^local-var "link")
                                 (univ-get-function-attrib ctx "ra" "link"))

               (^assign (gvm-state-stack-use ctx 'wr)
                        (^copy-array-to-extensible-array
                         (^local-var "frame")
                         (^+ (^local-var "fs") 1)))

               (^assign (gvm-state-sp-use ctx 'wr)
                        (^local-var "fs"))

               (^assign (^array-index
                         (gvm-state-stack-use ctx 'rd)
                         0)
                        (^alias
                         (^array-index
                          (^local-var "frame")
                          (^local-var "link"))))

               (^assign (^array-index
                         (gvm-state-stack-use ctx 'rd)
                         (^local-var "link"))
                        (^gvar (univ-use-rtlib ctx 'underflow))))))

         (^return (^local-var "ra")))))

    ((continuation_capture1)
     (univ-emit-continuation-capture-function ctx 1 #f))

    ((continuation_capture2)
     (univ-emit-continuation-capture-function ctx 2 #f))

    ((continuation_capture3)
     (univ-emit-continuation-capture-function ctx 3 #f))

    ((continuation_capture4)
     (univ-emit-continuation-capture-function ctx 4 #f))

    ((thread_save1)
     (univ-emit-continuation-capture-function ctx 1 #t))

    ((thread_save2)
     (univ-emit-continuation-capture-function ctx 2 #t))

    ((thread_save3)
     (univ-emit-continuation-capture-function ctx 3 #t))

    ((thread_save4)
     (univ-emit-continuation-capture-function ctx 4 #t))

    ((continuation_graft_no_winding2)
     (univ-emit-continuation-graft-no-winding-function ctx 2 #f))

    ((continuation_graft_no_winding3)
     (univ-emit-continuation-graft-no-winding-function ctx 3 #f))

    ((continuation_graft_no_winding4)
     (univ-emit-continuation-graft-no-winding-function ctx 4 #f))

    ((continuation_graft_no_winding5)
     (univ-emit-continuation-graft-no-winding-function ctx 5 #f))

    ((thread_restore2)
     (univ-emit-continuation-graft-no-winding-function ctx 2 #t))

    ((thread_restore3)
     (univ-emit-continuation-graft-no-winding-function ctx 3 #t))

    ((thread_restore4)
     (univ-emit-continuation-graft-no-winding-function ctx 4 #t))

    ((thread_restore5)
     (univ-emit-continuation-graft-no-winding-function ctx 5 #t))

    ((continuation_return_no_winding2)
     (univ-emit-continuation-return-no-winding-function ctx 2))

    ((poll)
     (^prim-function-declaration
      "poll"
      (list (cons 'dest #f))
      "\n"
      '()
      (^ (^assign (gvm-state-pollcount-use ctx 'wr)
                  100)
         (^return (^local-var "dest")))))

    ((build_rest)
     (^prim-function-declaration
      "build_rest"
      (list (cons 'nrp #f))
      "\n"
      '()
      (^ (^var-declaration (^local-var "rest") (^null))
         (^if (^< (^getnargs)
                  (^local-var "nrp"))
              (^return (^bool #f)))
         (univ-push-args ctx)
         (^while (^> (^getnargs)
                     (^local-var "nrp"))
                 (^ (^pop (lambda (expr)
                            (^assign (^local-var "rest")
                                     (^cons expr
                                            (^local-var "rest")))))
                    (^inc-by (gvm-state-nargs-use ctx 'rdwr)
                             -1)))
         (^push (^local-var "rest"))
         (univ-pop-args-to-regs ctx 1)
         (^return (^bool #t)))))

    ((wrong_nargs)
     (^prim-function-declaration
      "wrong_nargs"
      (list (cons 'proc #f))
      "\n"
      '()
      (^ (^expr-statement
          (^call-prim
           (^prefix (univ-use-rtlib ctx 'build_rest))
           0))
         (^setreg 2 (^getreg 1))
         (^setreg 1 (^local-var "proc"))
         (^setnargs 2)
         (^return (^getglo '##raise-wrong-number-of-arguments-exception)))))

    ((get)
#<<EOF
function gambit_get($obj,$name) {
  return $obj[$name];
}

EOF
)

    ((set)
#<<EOF
function gambit_set(&$obj,$name,$val) {
  $obj[$name] = $val;
}

EOF
)

    ((prepend_arg1)
     (^prim-function-declaration
      "prepend_arg1"
      (list (cons 'arg1 #f))
      "\n"
      '()
      (^ (^var-declaration (^local-var "i") (^int 0))
         (univ-push-args ctx)
         (^push (^void))
         (^while (^< (^local-var "i") (^getnargs))
                 (^ (^assign (univ-stk-slot-from-tos ctx (^local-var "i"))
                             (univ-stk-slot-from-tos ctx (^parens (^+ (^local-var "i") (^int 1)))))
                    (^inc-by (^local-var "i")
                             1)))
         (^assign (univ-stk-slot-from-tos ctx (^local-var "i"))
                  (^local-var "arg1"))
         (^inc-by (gvm-state-nargs-use ctx 'rdwr)
                  1)
         (univ-pop-args-to-regs ctx 0))))

    ((check_procedure_glo)
     (^prim-function-declaration
      "check_procedure_glo"
      (list (cons 'dest #f)
            (cons 'gv #f))
      "\n"
      '()
      (^ (^if (^not (^parens (^procedure? (^local-var "dest"))))
              (^ (^expr-statement
                  (^call-prim
                   (^prefix (univ-use-rtlib ctx 'prepend_arg1))
                   (^local-var "gv")))
                 (^assign (^local-var "dest")
                          (^getglo '##apply-global-with-procedure-check-nary))))
         (^return (^local-var "dest")))))

    ((check_procedure)
     (^prim-function-declaration
      "check_procedure"
      (list (cons 'dest #f))
      "\n"
      '()
      (^ (^if (^not (^parens (^procedure? (^local-var "dest"))))
              (^ (^expr-statement
                  (^call-prim
                   (^prefix (univ-use-rtlib ctx 'prepend_arg1))
                   (^local-var "dest")))
                 (^assign (^local-var "dest")
                          (^getglo '##apply-with-procedure-check-nary))))
         (^return (^local-var "dest")))))

    ((closure_alloc)
     (case (univ-procedure-representation ctx)

       ((class)
        (^prim-function-declaration
         "closure_alloc"
         (list (cons 'slots #f))
         "\n"
         '()
         (^return (^new (^prefix-class (univ-use-rtlib ctx 'Closure))
                        (^local-var "slots")))))

       (else
        (case (target-name (ctx-target ctx))

          ((php);;TODO: select call or __invoke
#<<EOF
class Gambit_Closure {

  public function __construct($slots) {
    $this->slots = $slots;
  }

  public function __invoke() {
    global $gambit_r4;
    $gambit_r4 = $this;
    return $this->slots[0];
  }
}

function gambit_closure_alloc($slots) {
  return new Gambit_Closure($slots);
}
EOF
)

          (else
           (^prim-function-declaration
            "closure_alloc"
            (list (cons 'slots #f))
            "\n"
            '()
            (let ((msg (^local-var 'msg))
                  (slots (^local-var 'slots))
                  (closure (^local-var 'closure)))
              (^ (^procedure-declaration
                  #f
                  closure
                  (list (cons 'msg #t))
                  "\n"
                  '()
                  (^ (^if (^= msg (^bool #t))
                          (^return slots))
                     (^setreg (+ univ-nb-arg-regs 1) closure)
                     (^return (^array-index slots 0))))
               (^return closure)))))))))

    ((Procedure)
     (^class-declaration
      "Procedure"
      #f
      '()
      '()))

    ((Closure)
     (^class-declaration
      "Closure"
      (^prefix-class (univ-use-rtlib ctx 'Procedure))
      '((slots . #f))
      (list
       (list 'call
             '()
             "\n"
             (lambda (ctx)
               (^ (^setreg (+ univ-nb-arg-regs 1) (^local-var (^this)))
                  (^return (^array-index (^this-member "slots") 0))))))))

    ((Fixnum)
     (^class-declaration
      "Fixnum"
      #f
      '((val . #f))
      '()))

    ((Flonum)
     (^class-declaration
      "Flonum"
      #f
      '((val . #f))
      '()))

    ((Bignum)
     (^class-declaration
      "Bignum"
      #f
      '((digits . #f))
      '()))

    ((bitcount)
     (^prim-function-declaration
      "bitcount"
      (list (cons 'n #f))
      "\n"
      '()
      (let ((n (^local-var 'n)))
        (^ (^assign n (^+ (^parens (^bitand n
                                            (^int #x55555555)))
                          (^parens (^bitand (^parens (^>> n (^int 1)))
                                            (^int #x55555555)))))
           (^assign n (^+ (^parens (^bitand n
                                            (^int #x33333333)))
                          (^parens (^bitand (^parens (^>> n (^int 2)))
                                            (^int #x33333333)))))
           (^assign n (^bitand (^parens (^+ n (^parens (^>> n (^int 4)))))
                               (^int #x0f0f0f0f)))
           (^assign n (^+ n (^parens (^>> n (^int 8)))))
           (^assign n (^+ n (^parens (^>> n (^int 16)))))
           (^return (^bitand n (^int #xff)))))))

    ((intlength)
     (^prim-function-declaration
      "intlength"
      (list (cons 'n #f))
      "\n"
      '()
      (let ((n (^local-var 'n)))
        (^ (^if (^< n (^int 0)) (^assign n (^bitnot n)))
           (^assign n (^bitior n (^parens (^>> n 1))))
           (^assign n (^bitior n (^parens (^>> n 2))))
           (^assign n (^bitior n (^parens (^>> n 4))))
           (^assign n (^bitior n (^parens (^>> n 8))))
           (^assign n (^bitior n (^parens (^>> n 16))))
           (^return (^call-prim
                     (^prefix (univ-use-rtlib ctx 'bitcount))
                     n))))))

    ((bignum_make)
     (^prim-function-declaration
      "bignum_make"
      (list (cons 'n #f) (cons 'x #f) (cons 'complement #f))
      "\n"
      '()
      (let ((n (^local-var 'n))
            (x (^local-var 'x))
            (complement (^local-var 'complement))
            (flip (^local-var 'flip))
            (nbdig (^local-var 'nbdig))
            (digits (^local-var 'digits))
            (i (^local-var 'i)))
        (^ (^var-declaration i
                             (^int 0))
           (^var-declaration digits
                             (univ-new-array ctx n))
           (^var-declaration nbdig
                             (^if-expr
                              (^eq? x (^obj #f))
                              (^int 0)
                              (^array-length (^member x "digits"))))
           (^var-declaration flip
                             (^if-expr complement (^int 16383) (^int 0)))
           (^if (^< n nbdig)
                (^assign nbdig n))
           (^while (^< i nbdig)
                   (^ (^assign (^array-index digits i)
                               (^bitxor (^array-index (^member x "digits") i)
                                        flip))
                      (^inc-by i 1)))
           (^if (^and (^not (^parens (^eq? x (^obj #f))))
                      (^> (^array-index (^member x "digits") (^- i (^int 1)))
                          (^int 8191)))
                (^assign flip (^bitxor flip (^int 16383))))
           (^while (^< i n)
                   (^ (^assign (^array-index digits i)
                               flip)
                      (^inc-by i 1)))
           (^return
            (^new (^prefix-class (univ-use-rtlib ctx 'Bignum))
                  digits))))))

    ((int2bignum)
     (^prim-function-declaration
      "int2bignum"
      (list (cons 'n #f))
      "\n"
      '()
      (let ((n (^local-var 'n))
            (nbdig (^local-var 'nbdig))
            (digits (^local-var 'digits))
            (i (^local-var 'i)))
        (^ (^var-declaration nbdig
                             (^+ (^parens
                                  (univ-fxquotient
                                   ctx
                                   (^call-prim
                                    (^prefix (univ-use-rtlib ctx 'intlength))
                                    n)
                                   (^int 14)))
                                 (^int 1)))
           (^var-declaration digits
                             (univ-new-array ctx nbdig))
           (^var-declaration i
                             (^int 0))
           (^while (^< i nbdig)
                   (^ (^assign (^array-index digits i)
                               (^bitand n (^int 16383)))
                      (^assign n
                               (^>> n (^int 14)))
                      (^inc-by i 1)))
           (^return
            (^new (^prefix-class (univ-use-rtlib ctx 'Bignum))
                  digits))))))

    ((Ratnum)
     (^class-declaration
      "Ratnum"
      #f
      '((num . #f) (den . #f))
      '()))

    ((Cpxnum)
     (^class-declaration
      "Cpxnum"
      #f
      '((real . #f) (imag . #f))
      '()))

    ((Pair)
     (^class-declaration
      "Pair"
      #f
      '((car . #f) (cdr . #f))
      '()))

    ((Vector)
     (^class-declaration
      "Vector"
      #f
      '((elems . #f))
      '()))

    ((U8Vector)
     (^class-declaration
      "U8Vector"
      #f
      '((elems . #f))
      '()))

    ((U16Vector)
     (^class-declaration
      "U16Vector"
      #f
      '((elems . #f))
      '()))

    ((F64Vector)
     (^class-declaration
      "F64Vector"
      #f
      '((elems . #f))
      '()))

    ((Structure)
     (^class-declaration
      "Structure"
      #f
      '((slots . #f))
      '()
      (lambda (ctx)
        (^if (^not (^array-index (^this-member "slots") 0))
             (^assign (^array-index (^this-member "slots") 0)
                      (^local-var (^this)))))))

    ((Frame)
     (^class-declaration
      "Frame"
      #f
      '((slots . #f))
      '()))

    ((Continuation)
     (^class-declaration
      "Continuation"
      #f
      '((frame . #f) (denv . #f))
      '()))

    ((continuation_next)
     (^prim-function-declaration
      "continuation_next"
      (list (cons 'cont #f))
      "\n"
      '()
      (^ (^var-declaration (^local-var "frame")
                           (^member (^local-var "cont") "frame"))
         (^var-declaration (^local-var "denv")
                           (^member (^local-var "cont") "denv"))
         (^var-declaration (^local-var "ra")
                           (^array-index (^local-var "frame") 0))
         (univ-with-function-attribs
          ctx
          #f
          "ra"
          (lambda ()
            (^var-declaration (^local-var "link")
                              (univ-get-function-attrib ctx "ra" "link"))))
         (^var-declaration (^local-var "next_frame")
                           (^array-index (^local-var "frame")
                                         (^local-var "link")))
         (^return
          (^new (^prefix-class (univ-use-rtlib ctx 'Continuation))
                (^local-var "next_frame")
                (^local-var "denv"))))))

    ((Symbol)
     (^class-declaration
      "Symbol"
      #f
      '((str . #f))
      (list
       (list (univ-tostr-method-name ctx)
             '()
             "\n"
             (lambda (ctx)
               (^return
                (^this-member "str")))))))

    ((make_interned_symbol)
     (^ (^var-declaration (^gvar "symbol_table") (^empty-dict))
        "\n"
        (^prim-function-declaration
         "make_interned_symbol"
         (list (cons 'str #f))
         "\n"
         '()
         (^ (^var-declaration (^local-var "sym")
                              (^prop-index (^gvar "symbol_table")
                                           (^local-var "str")
                                           (^bool #f)))
            (^if (^not (^local-var "sym"))
                 (^ (^assign (^local-var "sym")
                             (^symbol-box-uninterned (^local-var "str")))
                    (^assign (^prop-index (^gvar "symbol_table")
                                          (^local-var "str"))
                             (^local-var "sym"))))
            (^return (^local-var "sym"))))))

    ((Keyword)
     (^class-declaration
      "Keyword"
      #f
      '((str . #f))
      (list
       (list (univ-tostr-method-name ctx)
             '()
             "\n"
             (lambda (ctx)
               (^return
                (^this-member "str")))))))

    ((make_interned_keyword)
     (^ (^var-declaration (^gvar "keyword_table") (^empty-dict))
        "\n"
        (^prim-function-declaration
         "make_interned_keyword"
         (list (cons 'str #f))
         "\n"
         '()
         (^ (^var-declaration (^local-var "key")
                              (^prop-index (^gvar "keyword_table")
                                           (^local-var "str")
                                           (^bool #f)))
            (^if (^not (^local-var "key"))
                 (^ (^assign (^local-var "key")
                             (^keyword-box-uninterned (^local-var "str")))
                    (^assign (^prop-index (^gvar "keyword_table")
                                          (^local-var "str"))
                             (^local-var "key"))))
            (^return (^local-var "key"))))))

    ((Box)
     (^class-declaration
      "Box"
      #f
      '((val . #f))
      '()))

    ((Null)
     (^ (^class-declaration
         "Null"
         #f
         '()
         '())
        "\n"
        (^var-declaration
         (^gvar "null_val")
         (^new (^prefix-class (univ-use-rtlib ctx 'Null))))))

    ((Void)
     (^ (^class-declaration
         "Void"
         #f
         '()
         '())
        "\n"
        (^var-declaration
         (^gvar "void_val")
         (^new (^prefix-class (univ-use-rtlib ctx 'Void))))))

    ((Eof)
     (^ (^class-declaration
         "Eof"
         #f
         '()
         '())
        "\n"
        (^var-declaration
         (^gvar "eof_val")
         (^new (^prefix-class (univ-use-rtlib ctx 'Eof))))))

    ((Absent)
     (^ (^class-declaration
         "Absent"
         #f
         '()
         '())
        "\n"
        (^var-declaration
         (^gvar "absent_val")
         (^new (^prefix-class (univ-use-rtlib ctx 'Absent))))))

    ((Unbound)
     (^ (^class-declaration
         "Unbound"
         #f
         '()
         '())
        "\n"
        (^var-declaration
         (^gvar "unbound1_val")
         (^new (^prefix-class (univ-use-rtlib ctx 'Unbound))))
        (^var-declaration
         (^gvar "unbound2_val")
         (^new (^prefix-class (univ-use-rtlib ctx 'Unbound))))))

    ((Optional)
     (^ (^class-declaration
         "Optional"
         #f
         '()
         '())
        "\n"
        (^var-declaration
         (^gvar "optional_val")
         (^new (^prefix-class (univ-use-rtlib ctx 'Optional))))))

    ((Key)
     (^ (^class-declaration
         "Key"
         #f
         '()
         '())
        "\n"
        (^var-declaration
         (^gvar "key_val")
         (^new (^prefix-class (univ-use-rtlib ctx 'Key))))))

    ((Rest)
     (^ (^class-declaration
         "Rest"
         #f
         '()
         '())
        "\n"
        (^var-declaration
         (^gvar "rest_val")
         (^new (^prefix-class (univ-use-rtlib ctx 'Rest))))))

    ((Boolean)
     (^ (^class-declaration
         "Boolean"
         #f
         '((val . #f))
         '())
        "\n"
        (^var-declaration
         (^gvar "false_val")
         (^new (^prefix-class (univ-use-rtlib ctx 'Boolean)) (^bool #f)))
        (^var-declaration
         (^gvar "true_val")
         (^new (^prefix-class (univ-use-rtlib ctx 'Boolean)) (^bool #t)))))

    ((Char)
     (^class-declaration
      "Char"
      #f
      '((code . #f))
      (list
       (list (univ-tostr-method-name ctx)
             '()
             "\n"
             (case (target-name (ctx-target ctx))

               ((js)
                (lambda (ctx)
                  (^return
                   (^call-prim
                    (^member "String" "fromCharCode")
                    (^this-member "code")))))

               ((php python)
                (lambda (ctx)
                  (^return
                   (^call-prim
                    "chr"
                    (^this-member "code")))))

               ((ruby)
                (lambda (ctx)
                  (^return
                   (^call-prim
                    (^member
                     (^this-member "code")
                     "chr")))))

               (else
                (compiler-internal-error
                 "univ-rtlib-feature, unknown target")))))))

    ((make_interned_char)
     (^ (^var-declaration (^gvar "char_table") (^empty-dict))
        "\n"
        (^prim-function-declaration
         "make_interned_char"
         (list (cons 'code #f))
         "\n"
         '()
         (^ (^var-declaration (^local-var "chr")
                              (^prop-index (^gvar "char_table")
                                           (^local-var "code")
                                           (^bool #f)))
            (^if (^not (^local-var "chr"))
                 (^ (^assign (^local-var "chr")
                             (^char-box-uninterned (^local-var "code")))
                    (^assign (^prop-index (^gvar "char_table")
                                          (^local-var "code"))
                             (^local-var "chr"))))
            (^return (^local-var "chr"))))))

    ((String)
     (^class-declaration
      "String"
      #f
      '((codes . #f))
      (list
       (list (univ-tostr-method-name ctx)
             '()
             "\n"
             (case (target-name (ctx-target ctx))

               ((js)
                (lambda (ctx)
                  (let ((codes (^this-member "codes"))
                        (limit (^local-var "limit"))
                        (chunks (^local-var "chunks"))
                        (i (^local-var "i")))
                    (^ (^var-declaration limit (^int 32768))
                       (^if (^< (^array-length codes) limit)
                            (^return
                             (^call-prim
                              (^member (^member "String" "fromCharCode") "apply")
                              "null"
                              codes))
                            (^ (^var-declaration chunks (^array-literal '()))
                               (^var-declaration i (^int 0))
                               (^while (^< i (^array-length codes))
                                       (^ (^expr-statement
                                           (^call-prim
                                            (^member chunks "push")
                                            (^call-prim
                                             (^member (^member "String" "fromCharCode") "apply")
                                             "null"
                                             (^call-prim
                                              (^member codes "slice")
                                              i
                                              (^+ i limit)))))
                                          (^inc-by i limit)))
                               (^return
                                (^call-prim
                                 (^member chunks "join")
                                 (^str "")))))))))

               ((php)
                (lambda (ctx)
                  (^return
                   (^call-prim
                    "join"
                    (^call-prim
                     "array_map"
                     (^str "chr")
                     (^this-member "codes"))))))

               ((python)
                (lambda (ctx)
                  (^return
                   (^call-prim
                    (^member (^str "") "join")
                    (^call-prim
                     "map"
                     "chr"
                     (^this-member "codes"))))))

               ((ruby)
                ;;TODO: add anonymous function
                (lambda (ctx)
                  (^return
                   (^call-prim
                    (^member
                     (^ (^member (^this-member "codes") "map")
                        " {|x| x.chr}")
                     "join")))))

               (else
                (compiler-internal-error
                 "univ-rtlib-feature, unknown target")))))))

    ((tostr)
     (^prim-function-declaration
      "tostr"
      (list (cons 'obj #f))
      "\n"
      '()
      (^if (^eq? (^local-var "obj")
                 (^obj #f))
           (^return (^str "#f"))
           (^if (^eq? (^local-var "obj")
                      (^obj #t))
                (^return (^str "#t"))
                (^if (^eq? (^local-var "obj")
                           (^obj '()))
                     (^return (^str ""))
                     (^if (^eq? (^local-var "obj")
                                (^void))
                          (^return (^str "#!void"))
                          (^if (^eq? (^local-var "obj")
                                     (^eof))
                               (^return (^str "#!eof"))
                               (^if (^pair? (^local-var "obj"))
                                    (^return (^concat
                                              (^call-prim
                                               (^prefix (univ-use-rtlib ctx 'tostr))
                                               (^member (^local-var "obj") "car"))
                                              (^call-prim
                                               (^prefix (univ-use-rtlib ctx 'tostr))
                                               (^member (^local-var "obj") "cdr"))))
                                    (^if (^char? (^local-var "obj"))
                                         (^return (^chr-tostr (^char-unbox (^local-var "obj"))))
                                         (^if (^fixnum? (^local-var "obj"))
                                              (^return (^tostr (^fixnum-unbox (^local-var "obj"))))
                                              (^if (^flonum? (^local-var "obj"))
                                                   (^return (^tostr (^flonum-unbox (^local-var "obj"))))
                                        ;                                           (^if (^string? (^local-var "obj"))
                                        ;                                                (^return (^tostr (^string-unbox (^local-var "obj"))))
                                                   (^return (^tostr (^local-var "obj")))
                                        ;)
                                                   )))))))))))

    ((println)
     (^prim-function-declaration
      "println"
      (list (cons 'obj #f))
      "\n"
      '()
      (case (target-name (ctx-target ctx))
        ((js python)
         (^expr-statement (^call-prim "print" (^local-var "obj"))))
        ((ruby php)
         (^ (^expr-statement (^call-prim "print" (^local-var "obj")))
            (^expr-statement (^call-prim "print" "\"\\n\""))))
        (else
         (compiler-internal-error
          "univ-rtlib-feature, unknown target")))))

    ((glo-println)
     (^ (^procedure-declaration
         #t
         (gvm-proc-use ctx "println")
         '()
         "\n"
         '()
         (^ (^expr-statement
             (^call-prim
              (^prefix (univ-use-rtlib ctx 'println))
              (^call-prim
               (^prefix (univ-use-rtlib ctx 'tostr))
               (^getreg 1))))
            (^setreg 1 (^void))
            (^return (^getreg 0))))

        "\n"

        (^setglo 'println
                 (^global-function (^prefix (gvm-proc-use ctx "println"))))))

    ((glo-real-time-milliseconds)
     (^ (^var-declaration
         (^gvar "start_time")
         (case (target-name (ctx-target ctx))

           ((js)
            (^call-prim (^member (^new "Date") "getTime")))

           ((php)
            (^call-prim "microtime" (^bool #t)))

           ((python)
            (^call-prim (^member "time" "time")))

           ((ruby)
            (^new "Time"))

           (else
            (compiler-internal-error
             "univ-rtlib-feature, unknown target"))))

        "\n"

        (^procedure-declaration
         #t
         (gvm-proc-use ctx "real-time-milliseconds")
         '()
         "\n"
         '()
         (^ (case (target-name (ctx-target ctx))

              ((js)
               (^setreg 1 (^- (^call-prim (^member (^new "Date") "getTime"))
                              (^gvar "start_time"))))

              ((php)
               (^setreg 1 (^ "(int)"
                             (^parens
                              (^* 1000
                                  (^parens
                                   (^- (^call-prim "microtime" (^bool #t))
                                       (^gvar "start_time"))))))))

              ((python)
               (^setreg 1 (^call-prim
                           "int"
                           (^* 1000
                               (^parens
                                (^- (^call-prim (^member "time" "time"))
                                    (^gvar "start_time")))))))

              ((ruby)
               (^setreg 1 (^call-prim
                           (^member
                            (^parens
                             (^* 1000
                                 (^parens
                                  (^- (^new "Time")
                                      (^gvar "start_time")))))
                            "floor"))))

              (else
               (compiler-internal-error
                "univ-rtlib-feature, unknown target")))
            (^return (^getreg 0))))

        "\n"

        (^setglo 'real-time-milliseconds
                 (^global-function (^prefix (gvm-proc-use ctx "real-time-milliseconds"))))))

    ((strtocodes)
     (^prim-function-declaration
      "strtocodes"
      (list (cons 'str #f))
      "\n"
      '()
      (case (target-name (ctx-target ctx))

        ((js)
         (^
;;TODO: clean up
"
    var codes = [];
    for (var i=0; i < " (^local-var "str") ".length; i++) {
        codes.push(" (^local-var "str") ".charCodeAt(i));
    }
    return codes;
"))

        ((php)
         (^return (^ "array_slice(unpack('c*'," (^local-var "str") "),0)")))

        ((python)
         (^return (^ "[ord(c) for c in " (^local-var "str") "]")))

        ((ruby)
         (^return (^ (^local-var "str") ".unpack('U*')")))

        (else
         (compiler-internal-error
          "univ-rtlib-feature, unknown target")))))

    ((make_vector)
     (^prim-function-declaration
      "make_vector"
      (list (cons 'len #f)
            (cons 'init #f))
      "\n"
      '()
      (univ-make-array
       ctx
       (lambda (result) (^return (^vector-box result)))
       (^local-var 'len)
       (^local-var 'init))))

    ((make_u8vector)
     (^prim-function-declaration
      "make_u8vector"
      (list (cons 'len #f)
            (cons 'init #f))
      "\n"
      '()
      (univ-make-array
       ctx
       (lambda (result) (^return (^u8vector-box result)))
       (^local-var 'len)
       (^local-var 'init))))

    ((make_u16vector)
     (^prim-function-declaration
      "make_u16vector"
      (list (cons 'len #f)
            (cons 'init #f))
      "\n"
      '()
      (univ-make-array
       ctx
       (lambda (result) (^return (^u16vector-box result)))
       (^local-var 'len)
       (^local-var 'init))))

    ((make_f64vector)
     (^prim-function-declaration
      "make_f64vector"
      (list (cons 'len #f)
            (cons 'init #f))
      "\n"
      '()
      (univ-make-array
       ctx
       (lambda (result) (^return (^f64vector-box result)))
       (^local-var 'len)
       (^local-var 'init))))

    ((make_string)
     (^prim-function-declaration
      "make_string"
      (list (cons 'len #f)
            (cons 'init #f))
      "\n"
      '()
      (univ-make-array
       ctx
       (lambda (result) (^return (^string-box result)))
       (^local-var 'len)
       (^local-var 'init))))

    ((make_glo_var)
     (^prim-function-declaration
      "make_glo_var"
      (list (cons 'sym #f))
      "\n"
      '()
      (^ (^if (^not (^prop-index-exists? (gvm-state-glo-use ctx 'rd)
                                         (^symbol-unbox (^local-var "sym"))))
              (^ (^glo-var-set! (^local-var "sym") (^unbound1))
                 (^glo-var-primitive-set! (^local-var "sym") (^unbound1))))
         (^return (^local-var "sym")))))

    ((apply2)
     (univ-emit-apply-function ctx 2))

    ((apply3)
     (univ-emit-apply-function ctx 3))

    ((apply4)
     (univ-emit-apply-function ctx 4))

    ((apply5)
     (univ-emit-apply-function ctx 5))

    ((ffi)
     (case (target-name (ctx-target ctx))

       ((js)
        (^

#<<EOF
function gambit_js2scm(obj) {
  if (obj === void 0) {
    return obj;
  } else if (typeof obj === "boolean") {
    return obj;
  } else if (obj === null) {
    return obj;
  } else if (typeof obj === "number") {
    if ((obj|0) === obj && obj>=-536870912 && obj<=536870911)
      return obj
    else
      return new Gambit_Flonum(obj);
  } else if (typeof obj === "function") {
    return function () { return gambit_scm2js_call(obj); };
  } else if (typeof obj === "string") {
    return new Gambit_String(gambit_strtocodes(obj));
  } else if (typeof obj === "object") {
    if (obj instanceof Array) {
      return obj.map(gambit_js2scm);
    } else {
      var alist = null;
      for (var key in obj) {
        alist = new Gambit_Pair(new Gambit_Pair(gambit_js2scm(key),
                                                gambit_js2scm(obj[key])),
                                alist);
      }
      return alist;
    }
  } else {
    throw "gambit_js2scm error " + obj;
  }
}

function gambit_scm2js(obj) {
  if (obj === void 0) {
    return obj;
  } else if (typeof obj === "boolean") {
    return obj;
  } else if (obj === null) {
    return obj;
  } else if (typeof obj === "number") {
    return obj
  } else if (typeof obj === "function") {
    return function () { return gambit_js2scm_call(obj, arguments); };
  } else if (typeof obj === "object") {
    if (obj instanceof Array) {
      return obj.map(gambit_scm2js);
    } else if (obj instanceof Gambit_String) {
      return obj.toString();
    } else if (obj instanceof Gambit_Flonum) {
      return obj.val;
    } else if (obj instanceof Gambit_Pair) {
      var jsobj = {};
      var i = 0;
      while (obj instanceof Gambit_Pair) {
        var elem = obj.car;
        if (elem instanceof Gambit_Pair) {
          jsobj[gambit_scm2js(elem.car)] = gambit_scm2js(elem.cdr);
        } else {
          jsobj[i] = gambit_scm2js(elem);
        }
        ++i;
        obj = obj.cdr;
      }
      return jsobj;
    } else if (obj instanceof Gambit_Structure) {
      throw "gambit_scm2js error (can't convert Structure)";
    } else if (obj instanceof Gambit_Frame) {
      throw "gambit_scm2js error (can't convert Frame)";
    } else {
      throw "gambit_scm2js error " + obj;
    }
  } else {
    throw "gambit_scm2js error " + obj;
  }
}

function gambit_scm2js_call(fn) {

  if (gambit_nargs > 0) {
    gambit_stack[++gambit_sp] = gambit_r1;
    if (gambit_nargs > 1) {
      gambit_stack[++gambit_sp] = gambit_r2;
      if (gambit_nargs > 2) {
        gambit_stack[++gambit_sp] = gambit_r3;
      }
    }
  }

  var args = gambit_stack.slice(gambit_sp+1-gambit_nargs, gambit_sp+1);

  gambit_sp -= gambit_nargs;

  var ra = gambit_heapify(gambit_r0);
  var frame = gambit_stack[0];

  gambit_r1 = gambit_js2scm(fn.apply(null, args.map(gambit_scm2js)));

  gambit_sp = -1;
  gambit_stack[++gambit_sp] = frame;

  return ra;
}

function gambit_js2scm_call(proc, args) {

  var ra = function () { return false; };

  ra.id = 'gambit_js2scm_call';
  ra.fs = 1;
  ra.link = 1;

  gambit_sp = -1;
  gambit_stack[++gambit_sp] = [ra,false];

  gambit_nargs = args.length;

  for (var i=0; i<gambit_nargs; i++) {
    gambit_stack[++gambit_sp] = gambit_js2scm(args[i]);
  }

  if (gambit_nargs > 0) {
    if (gambit_nargs > 1) {
      if (gambit_nargs > 2) {
        gambit_r3 = gambit_stack[gambit_sp];
        --gambit_sp;
      }
      gambit_r2 = gambit_stack[gambit_sp];
      --gambit_sp;
    }
    gambit_r1 = gambit_stack[gambit_sp];
    --gambit_sp;
  }

  gambit_r0 = ra;

  gambit_trampoline(proc);

  return gambit_scm2js(gambit_r1);
}

EOF
))

       (else
        (^))))

    (else
     (compiler-internal-error
      "univ-rtlib-feature, unknown runtime library function" feature))))

(define (univ-rtlib ctx)

  (let ((code (^))
        (generated (make-resource-set)))

    (let loop ()
      (let ((changed? #f))

        (define (need-feature feature)
          (if (not (resource-set-member? generated feature))
              (begin
                (resource-set-add! generated feature)
                (set! changed? #t)
                (let ((c (univ-rtlib-feature ctx feature)))
                  (set! code (^ code c "\n"))))))

        ;;TODO: make inclusion of these features optional

        (if (equal? (univ-procedure-representation ctx) 'class)
            (need-feature 'Procedure))

        (need-feature 'heapify)
        (need-feature 'underflow)
        (need-feature 'strtocodes)
        (need-feature 'String)
        (need-feature 'Flonum)
        (need-feature 'Pair)
        (need-feature 'Cpxnum)
        (need-feature 'Ratnum)
        (need-feature 'Bignum)
        (need-feature 'Frame)
        (need-feature 'Continuation)
        (need-feature 'ffi)

        (need-feature 'intlength)
        (need-feature 'bignum_make)
        (need-feature 'int2bignum)

        (for-each need-feature
                  (resource-set->list (ctx-rtlib-features-used ctx)))

        (if changed?
            (loop))))

    (^ (univ-rtlib-header ctx)
       code)))

(define (univ-rtlib-header ctx)
  (let ((target (target-name (ctx-target ctx))))
    (^ (case target

         ((js)
          (^))

         ((php)
          (^ "<?php\n\n"))

         ((python)
          (^ "#! /usr/bin/python\n"
             "\n"
             "from array import array\n"
             "import ctypes\n"
             "import time\n"
             "import math\n"
             "\n"))

         ((ruby)
          (^ "# encoding: utf-8\n"
             "\n"))

         (else
          (compiler-internal-error
           "univ-rtlib-header, unknown target")))

       (univ-foldr-range
        0
        (- univ-nb-gvm-regs 1)
        (^)
        (lambda (i rest)
          (^ (^var-declaration (gvm-state-reg-use ctx 'wr i))
             rest)))

       (^var-declaration (^gvar "prm") (^empty-dict))
       (^var-declaration (^gvar "glo") (^empty-dict))
       (^var-declaration (^gvar "stack") (^extensible-array-literal '()))
       (^var-declaration (^gvar "sp") -1)
       (^var-declaration (^gvar "nargs"))
       (^var-declaration (^gvar "temp1"))
       (^var-declaration (^gvar "temp2"))
       (^var-declaration (^gvar "pollcount") 100)
       (^var-declaration (^gvar "current_thread"))

       "\n"

       )))

(define (univ-module-header ctx)
  (^ (^var-declaration (gvm-state-cst ctx) (^extensible-array-literal '()))
     "\n"))


#|
//JavaScript toString method:
gambit_Pair.prototype.toString = function () {
  return this.car.toString() + this.car.toString();
};

/* PHP toString method: */
  public function __toString() {
    return $this->car . $this->cdr;
  }

# Python toString method:
  def __str__(self):
    return self.car + self.cdr

# Ruby toString method:
  def to_s
    @car.to_s + @cdr.to_s
  end
|#

(define (univ-entry-point ctx main-proc)
  (let ((entry
         (^global-function
          (^prefix (gvm-proc-use ctx (proc-obj-name main-proc))))))
    (^ "\n"
       (univ-comment ctx "--------------------------------\n")
       "\n"

       (if univ-dyn-load?
           (^)
           (^ (^assign (^gvar "current_thread")
                       (^structure-box
                        (^array-literal
                         (list (^obj #f) ;; type descriptor (filled in later)
                               (^obj #f) ;; btq-next
                               (^obj #f) ;; btq-prev
                               (^obj #f) ;; toq-next
                               (^obj #f) ;; toq-prev
                               (^obj #f) ;; continuation
                               (^obj '()) ;; dynamic environment
                               (^obj #f)  ;; state
                               (^obj #f)  ;; thunk
                               (^obj #f)  ;; result
                               (^obj #f)  ;; mutex
                               (^obj #f)  ;; condvar
                               (^obj 0)   ;; id
                               ))))

              (^push (^obj #f))))

       (^assign (^gvar "r0")
                (^gvar (univ-use-rtlib ctx 'underflow)))

       (^assign (^gvar "nargs")
                0)

       (case (target-name (ctx-target ctx))

         ((js php python ruby)
          (^expr-statement
           (^call-prim
            (^prefix (univ-use-rtlib ctx 'trampoline))
            entry)))

         (else
          (compiler-internal-error
           "univ-entry-point, unknown target"))))))

;;;----------------------------------------------------------------------------

(define (univ-emit-procedure-declaration ctx global? root-name params header attribs gen-body)
  (if (equal? (univ-procedure-representation ctx) 'class)

      (^ (^class-declaration
          root-name
          (^prefix-class (univ-use-rtlib ctx 'Procedure))
          attribs
          (list
           (list 'call
                 '()
                 header
                 gen-body)))
         "\n"
         (^var-declaration
          (if global?
              (^global-function (^prefix root-name))
              (^local-var root-name))
          (^new (^prefix-class root-name))))

      (univ-emit-function-declaration
       ctx
       global?
       root-name
       params
       header
       attribs
       gen-body
       #f)))

(define (univ-emit-function-declaration ctx global? root-name params header attribs gen-body #!optional (prim? #f))
  (let* ((prn
          (^prefix root-name))
         (name
          (if prim?
              prn
              (if global?
                  (^global-var prn)
                  (^local-var root-name)))))
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (univ-emit-fn-decl ctx name params header gen-body)
          "\n"
          (if (null? attribs)
              (^)
              (^ "\n"
                 (map (lambda (attrib)
                        (^assign (^member name (car attrib))
                                 (cdr attrib)))
                      attribs)))))

      ((php)
       (let ((decl
              (^ (univ-emit-fn-decl
                  ctx
                  (and (or prim? (not (univ-php-version-53? ctx)))
                       prn)
                  params
                  (^ header
                     (if (null? attribs)
                         (^)
                         (^ "static "
                            (univ-separated-list
                             ", "
                             (map (lambda (attrib)
                                    (^assign-expr
                                     (^local-var (car attrib))
                                     (cdr attrib)))
                                  attribs))
                            ";\n")))
                  gen-body)
                 "\n")))
         (cond (prim?
                decl)
               ((not (univ-php-version-53? ctx))
                (^ decl
                   "\n"
                   (^assign name
                            (^ "create_function('"
                               (univ-separated-list
                                ","
                                (map (lambda (x)
                                       (^ (^local-var (car x))
                                          (if (cdr x) (^ "=" (^bool #f)) (^))))
                                     params))
                               "','"
                               (if (null? attribs)
                                   (^)
                                   (^ "static "
                                      (univ-separated-list
                                       ", "
                                       (map (lambda (attrib)
                                              (^assign-expr
                                               (^local-var (car attrib))
                                               (let ((a (cdr attrib)))
                                                 (if (and (list? a)
                                                          (= (length a) 3)
                                                          (equal? (car a) "'")
                                                          (equal? (caddr a) "'"))
                                                     (^ "\\'" (cadr a) "\\'")
                                                     a))))
                                            attribs))
                                      "; "))
                               "return "
                               prn
                               "("
                               (univ-separated-list "," (map car params))
                               ");')"))))
               (else
                (^assign name decl)))))

      ((python)
       (^ (univ-emit-fn-decl ctx name params header gen-body)
          "\n"
          (if (null? attribs)
              (^)
              (^ "\n"
                 (map (lambda (attrib)
                        (^assign (^member name (car attrib))
                                 (cdr attrib)))
                      attribs)))))

      ((ruby)
       (^ (if prim?

              (^ (univ-emit-fn-decl ctx name params header gen-body)
                 "\n")

              (let ((parameters
                     (univ-separated-list
                      ","
                      (map (lambda (x)
                             (^ (^local-var (car x))
                                (if (cdr x) (^ "=" (^bool #f)) (^))))
                           params))))
                (^assign
                 name
                 (univ-emit-fn-decl ctx #f params header gen-body))))

            (if (pair? attribs)
                (^ "class << " name "; attr_accessor :" (car (car attribs))
                   (map (lambda (attrib)
                          (^ ", :" (car attrib)))
                        (cdr attribs))
                   "; end\n"
                   (map (lambda (attrib)
                          (^assign (^member name (car attrib))
                                   (cdr attrib)))
                        attribs))
                (^))))

      (else
       (compiler-internal-error
        "univ-emit-function-declaration, unknown target")))))

(define (univ-emit-fn-decl ctx name params header gen-body)
  (univ-call-with-globals
   ctx
   gen-body
   (lambda (ctx body globals)
     (case (target-name (ctx-target ctx))

       ((js)
        (let ((formals
               (univ-separated-list
                ","
                (map car params))))
          (^ "function " (or name "") "(" formals ") {"
             (univ-indent (^ header globals body))
             "}")))

       ((php)
        (let ((formals
               (univ-separated-list
                ","
                (map (lambda (x)
                       (^ (^local-var (car x))
                          (if (cdr x) (^ "=" (^bool #f)) (^))))
                     params))))
          (^ "function " (or name "") "(" formals ") {"
             (univ-indent (^ header globals body))
             "}")))

       ((python)
        (let ((formals
               (univ-separated-list
                ","
                (map (lambda (x)
                       (^ (^local-var (car x))
                          (if (cdr x) (^ "=" (^bool #f)) (^))))
                     params))))
          (^ "def " name "(" formals "):"
             (univ-indent (^ header globals body)))))

       ((ruby)
        (let ((formals
               (univ-separated-list
                ","
                (map (lambda (x)
                       (^ (^local-var (car x))
                          (if (cdr x) (^ "=" (^bool #f)) (^))))
                     params))))
          (if name

              (^ "def " name (if (null? params) (^) (^ "(" formals ")"))
                 (univ-indent (^ header globals body))
                 "end")

              (^ "lambda {" (if (null? params) (^) (^ "|" formals "|"))
                 (univ-indent (^ header globals body))
                 "}"))))

       (else
        (compiler-internal-error
         "univ-emit-fn-decl, unknown target"))))))

(define (univ-call-with-globals ctx gen cont)
  (with-new-resources-used
   ctx
   (lambda (ctx)
     (let* ((result (gen ctx))
            (globals (resource-set->list (ctx-globals-used ctx))))

       (define (used? x)
         (or (resource-set-member? (ctx-resources-used-rd ctx) x)
             (resource-set-member? (ctx-resources-used-wr ctx) x)))

       (define (add! x)
         (set! globals (cons x globals)))

       (define (global-decl globals)
         (if (null? globals)
             (^)
             (^ "global "
                (univ-separated-list
                 ", "
                 globals))))

       (let loop ((num (- univ-nb-gvm-regs 1)))
         (if (>= num 0)
             (begin
               (if (used? num) (add! (gvm-state-reg ctx num)))
               (loop (- num 1)))))

       (if (used? 'sp)        (add! (gvm-state-sp ctx)))
       (if (used? 'stack)     (add! (gvm-state-stack ctx)))
       (if (used? 'prm)       (add! (gvm-state-prm ctx)))
       (if (used? 'glo)       (add! (gvm-state-glo ctx)))
       (if (used? 'cst)       (add! (gvm-state-cst ctx)))
       (if (used? 'nargs)     (add! (gvm-state-nargs ctx)))
       (if (used? 'pollcount) (add! (gvm-state-pollcount ctx)))

       (cont ctx
             result
             (if (null? globals)
                 (^)
                 (case (target-name (ctx-target ctx))
                   ((php)
                    (^ (global-decl globals) ";\n"))
                   ((python)
                    (^ (global-decl globals) "\n"))
                   (else
                    (^)))))))))

(define (univ-emit-class-declaration ctx root-name extends fields methods #!optional (constructor #f))
  (let ((name (^prefix-class root-name)))
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (univ-emit-fn-decl
           ctx
           name
           (keep (lambda (field) (not (cdr field))) fields)
           "\n"
           (lambda (ctx)
             (if (or constructor (not (null? fields)))
                 (^ (map (lambda (field)
                           (let ((field-name (car field))
                                 (field-init (cdr field)))
                             (^assign (^this-member field-name)
                                      (or field-init (^local-var field-name)))))
                         fields)
                    (if constructor (constructor ctx) (^)))
                 (^))))
          "\n"
          (if extends
              (^ "\n"
                 (^assign (^member name "prototype")
                          (^call-prim (^member "Object" "create")
                                      (^member extends "prototype"))))
              (^))
          (map (lambda (method)
                 (^ "\n"
                    (^assign (^member (^member name "prototype") (car method))
                             (univ-emit-fn-decl
                              ctx
                              #f
                              (cadr method)
                              (caddr method)
                              (cadddr method)))))
               methods)))

      ((php)
       (^ "class " name
          (if extends (^ " extends " extends) "")
          " {"
          (univ-indent
           (if (or constructor (not (null? fields)) (not (null? methods)))
               (^ "\n"
                  (if (pair? fields)
                      (^ "\n"
                         (map (lambda (field)
                                (^ "public " (^local-var (car field)) ";\n"))
                              fields))
                      (^))
                  (if (or constructor (not (null? fields)))
                      (^ "\n"
                         "public "
                         (univ-emit-fn-decl
                          ctx
                          "__construct"
                          (keep (lambda (field) (not (cdr field)))
                                fields)
                          "\n"
                          (lambda (ctx)
                            (^ (map (lambda (field)
                                      (let ((field-name (car field))
                                            (field-init (cdr field)))
                                        (^assign (^this-member field-name)
                                                 (or field-init (^local-var field-name)))))
                                    fields)
                               (if constructor (constructor ctx) (^)))))
                         "\n")
                      (^))
                  (map (lambda (method)
                         (^ "\n"
                            "public "
                            (univ-emit-fn-decl
                             ctx
                             (car method)
                             (cadr method)
                             (caddr method)
                             (cadddr method))
                            "\n"))
                       methods))
               (^)))
          "}\n"))

      ((python)
       (^ "class " name
          (if extends (^ "(" extends ")") "")
          ":\n"
          (univ-indent
           (if (or constructor (not (null? fields)) (not (null? methods)))
               (^ (if (or constructor (not (null? fields)))
                      (^ "\n"
                         (univ-emit-fn-decl
                          ctx
                          "__init__"
                          (cons (cons (^this) #f)
                                (keep (lambda (field) (not (cdr field)))
                                      fields))
                          "\n"
                          (lambda (ctx)
                            (if (and (null? fields) (not constructor))
                                "pass\n"
                                (^ (map (lambda (field)
                                          (let ((field-name (car field))
                                                (field-init (cdr field)))
                                            (^assign (^this-member field-name)
                                                     (or field-init (^local-var field-name)))))
                                        fields)
                                   (if constructor (constructor ctx) (^)))))))
                      (^))
                  (map (lambda (method)
                         (^ "\n"
                            (univ-emit-fn-decl
                             ctx
                             (car method)
                             (cons '(self . #f) (cadr method))
                             (caddr method)
                             (cadddr method))))
                       methods))
               "pass\n"))))

      ((ruby)
       (^ "class " name
          (if extends (^ " < " extends) "")
          (univ-indent
           (if (or constructor (not (null? fields)) (not (null? methods)))
               (^ "\n"
                  (if (pair? fields)
                      (^ "\n"
                         "attr_accessor "
                         (univ-separated-list
                          ","
                          (map (lambda (field) (^ ":" (car field))) fields))
                         "\n")
                      (^))
                  (if (or constructor (not (null? fields)))
                      (^ "\n"
                         "def initialize("
                         (univ-separated-list
                          ","
                          (map car (keep (lambda (field) (not (cdr field))) fields)))
                         ")\n"
                         (univ-indent
                          (^ (map (lambda (field)
                                    (let ((field-name (car field))
                                          (field-init (cdr field)))
                                      (^assign (^this-member field-name)
                                               (or field-init (^local-var field-name)))))
                                  fields)
                             (if constructor (constructor ctx) (^))))
                         "end\n")
                      (^))
                  (map (lambda (method)
                         (^ "\n"
                            (univ-emit-fn-decl
                             ctx
                             (car method)
                             (cadr method)
                             (caddr method)
                             (cadddr method))))
                       methods))
               (^)))
          "\nend\n"))

      (else
       (compiler-internal-error
        "univ-emit-class-declaration, unknown target")))))

(define (univ-comment ctx comment)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ "// " comment))

    ((python ruby)
     (^ "# " comment))

    (else
     (compiler-internal-error
      "univ-comment, unknown target"))))

(define (univ-emit-return-poll ctx expr poll? call?)

  (define (ret)
    (if call?
        (^return-call expr)
        (^return expr)))

  (if poll?

      (^inc-by (gvm-state-pollcount-use ctx 'rdwr)
               -1
               (lambda (inc)
                 (^if (^= inc (^int 0))
                      (^return-call-prim
                       (^prefix (univ-use-rtlib ctx 'poll))
                       expr)
                      (ret))))

      (ret)))

(define (univ-emit-return-call-prim ctx expr . params)
  (^return
   (apply univ-emit-call-prim (cons ctx (cons expr params)))))

(define univ-return-call-optimization? #f)

(define (univ-emit-return-call ctx expr)
  (^return
   (if univ-return-call-optimization?
       (^call expr)
       expr)))

(define (univ-emit-return ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ "return " expr ";\n"))

    ((python ruby)
     (^ "return " expr "\n"))

    (else
     (compiler-internal-error
      "univ-emit-return, unknown target"))))

(define (univ-emit-null ctx)
  (case (univ-null-representation ctx)

    ((class)
     (univ-use-rtlib ctx 'Null)
     (^gvar "null_val"))

    (else
     (case (target-name (ctx-target ctx))

       ((js)
        (^ "null"))

       ((python)
        (^ "None"))

       ((ruby)
        (^ "nil"))

       ((php)
        (^ "NULL"))

       (else
        (compiler-internal-error
         "univ-emit-null, unknown target"))))))

(define (univ-emit-void ctx)
  (case (univ-void-representation ctx)

    ((class)
     (univ-use-rtlib ctx 'Void)
     (^gvar "void_val"))

    (else
     (case (target-name (ctx-target ctx))

       ((js)
        (^ "undefined"))

       ((python)
        (^ "None"))

       ((ruby)
        (^ "nil"))

       ((php)
        (^ "NULL"))

       (else
        (compiler-internal-error
         "univ-emit-void, unknown target"))))))

(define (univ-emit-eof ctx)
  (case (univ-eof-representation ctx)

    ((class)
     (univ-use-rtlib ctx 'Eof)
     (^gvar "eof_val"))

    (else
     (compiler-internal-error
      "univ-emit-eof, host representation not implemented"))))

(define (univ-emit-absent ctx)
  (case (univ-absent-representation ctx)

    ((class)
     (univ-use-rtlib ctx 'Absent)
     (^gvar "absent_val"))

    (else
     (compiler-internal-error
      "univ-emit-absent, host representation not implemented"))))

(define (univ-emit-unbound1 ctx)
  (case (univ-unbound-representation ctx)

    ((class)
     (univ-use-rtlib ctx 'Unbound)
     (^gvar "unbound1_val"))

    (else
     (compiler-internal-error
      "univ-emit-unbound1, host representation not implemented"))))

(define (univ-emit-unbound2 ctx)
  (case (univ-unbound-representation ctx)

    ((class)
     (univ-use-rtlib ctx 'Unbound)
     (^gvar "unbound2_val"))

    (else
     (compiler-internal-error
      "univ-emit-unbound2, host representation not implemented"))))

(define (univ-emit-unbound? ctx expr)
  (case (univ-unbound-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'Unbound)) expr))

    (else
     (compiler-internal-error
      "univ-emit-unbound?, host representation not implemented"))))

(define (univ-emit-optional ctx)
  (case (univ-optional-representation ctx)

    ((class)
     (univ-use-rtlib ctx 'Optional)
     (^gvar "optional_val"))

    (else
     (compiler-internal-error
      "univ-emit-optional, host representation not implemented"))))

(define (univ-emit-key ctx)
  (case (univ-key-representation ctx)

    ((class)
     (univ-use-rtlib ctx 'Key)
     (^gvar "key_val"))

    (else
     (compiler-internal-error
      "univ-emit-key, host representation not implemented"))))

(define (univ-emit-rest ctx)
  (case (univ-rest-representation ctx)

    ((class)
     (univ-use-rtlib ctx 'Rest)
     (^gvar "rest_val"))

    (else
     (compiler-internal-error
      "univ-emit-rest, host representation not implemented"))))

(define (univ-emit-bool ctx val)
  (case (target-name (ctx-target ctx))

    ((js ruby php)
     (^ (if val "true" "false")))

    ((python)
     (^ (if val "True" "False")))

    (else
     (compiler-internal-error
      "univ-emit-bool, unknown target"))))

(define (univ-emit-boolean-obj ctx obj)
  (case (univ-boolean-representation ctx)

    ((class)
     (univ-use-rtlib ctx 'Boolean)
     (univ-box
      (^gvar (if obj "true_val" "false_val"))
      (^bool obj)))

    (else
     (^bool obj))))

(define (univ-emit-boolean-box ctx expr)
  (case (univ-boolean-representation ctx)

    ((class)
     (univ-box
      (^if-expr expr
                (^boolean-obj #t)
                (^boolean-obj #f))
      expr))

    (else
     expr)))

(define (univ-emit-boolean-unbox ctx expr)
  (case (univ-boolean-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member expr "val")))

    (else
     expr)))

(define (univ-emit-boolean? ctx expr)
  (case (univ-boolean-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'Boolean)) expr))

    (else
     (case (target-name (ctx-target ctx))

       ((js)
        (^typeof "boolean" expr))

       ((php)
        (^call-prim "is_bool" expr))

       ((python)
        (^instanceof "bool" expr))

       ((ruby)
        (^or (^instanceof "FalseClass" expr)
             (^instanceof "TrueClass" expr)))

       (else
        (compiler-internal-error
         "univ-emit-boolean?, unknown target"))))))

(define (univ-emit-chr ctx val)
  (^ (char->integer val)))

(define (univ-emit-char-obj ctx obj force-var?)
  (case (univ-char-representation ctx)

    ((class)
     (let ((x (^chr obj)))
       (univ-box
        (univ-obj-use
         ctx
         obj
         force-var?
         (lambda ()
           (^char-box x)))
        x)))

    (else
     (compiler-internal-error
      "univ-emit-char-obj, host representation not implemented"))))

(define (univ-emit-char-box ctx expr)
  (case (univ-char-representation ctx)

    ((class)
     (univ-box
      (^call-prim
       (^prefix (univ-use-rtlib ctx 'make_interned_char))
       expr)
      expr))

    (else
     (^char-box-uninterned expr))))

(define (univ-emit-char-box-uninterned ctx expr)
  (case (univ-char-representation ctx)

    ((class)
     (^new (^prefix-class (univ-use-rtlib ctx 'Char)) expr))

    (else
     (compiler-internal-error
      "univ-emit-char-box-uninterned, host representation not implemented"))))

(define (univ-emit-char-unbox ctx expr)
  (case (univ-char-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member expr "code")))

    (else
     (compiler-internal-error
      "univ-emit-char-unbox, host representation not implemented"))))

(define (univ-emit-chr-fromint ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     expr)

    (else
     (compiler-internal-error
      "univ-emit-chr-fromint, unknown target"))))

(define (univ-emit-chr-toint ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     expr)

    (else
     (compiler-internal-error
      "univ-emit-chr-toint, unknown target"))))

(define (univ-emit-chr-tostr ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^call-prim (^member "String" "fromCharCode") expr))

    ((php)
     (^call-prim "chr" expr))

    ((python)
     (^call-prim "unichr" expr))

    ((ruby)
     (^ expr ".chr"))

    (else
     (compiler-internal-error
      "univ-emit-chr-tostr, unknown target"))))

(define (univ-emit-char? ctx expr)
  (case (univ-char-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'Char)) expr))

    (else
     (compiler-internal-error
      "univ-emit-char?, host representation not implemented"))))

(define (univ-emit-int ctx val)
  (^ val))

(define (univ-emit-fixnum-box ctx expr)
  (case (univ-fixnum-representation ctx)

    ((class)
     (univ-box
      (^new (^prefix-class (univ-use-rtlib ctx 'Fixnum)) expr)
      expr))

    (else
     expr)))

(define (univ-emit-fixnum-unbox ctx expr)
  (case (univ-fixnum-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member expr "val")))

    (else
     expr)))

(define (univ-emit-fixnum? ctx expr)
  (case (univ-fixnum-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'Fixnum)) expr))

    (else
     (case (target-name (ctx-target ctx))

       ((js)
        (^typeof "number" expr))

       ((php)
        (^call-prim "is_int" expr))

       ((python)
        (^and (^instanceof "int" expr)
              (^not (^instanceof "bool" expr))))

       ((ruby)
        (^instanceof "Fixnum" expr))

       (else
        (compiler-internal-error
         "univ-emit-fixnum?, unknown target"))))))

(define (univ-emit-dict ctx alist)

  (define (dict alist sep open close)
    (^ open
       (univ-separated-list
        ","
        (map (lambda (x) (^ (^str (car x)) sep (cdr x))) alist))
       close))

  (case (target-name (ctx-target ctx))

    ((js python)
     (dict alist ":" "{" "}"))

    ((php)
     (dict alist "=>" "array(" ")"))

    ((ruby)
     (dict alist "=>" "{" "}"))

    (else
     (compiler-internal-error
      "univ-emit-dict, unknown target"))))

(define (univ-emit-member ctx expr name)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^ expr "." name))

    ((php)
     (^ expr "->" name))

    (else
     (compiler-internal-error
      "univ-emit-member, unknown target"))))

(define (univ-with-function-attribs ctx assign? fn thunk)
  (case (univ-procedure-representation ctx)

    ((class)
     (thunk))

    (else
     (case (target-name (ctx-target ctx))

       ((js python ruby)
        (thunk))

       ((php)
        (let ((attribs-var
               (^local-var (^ fn "_attribs")))
              (attribs-array
               (^ "new ReflectionFunction(" (^local-var fn) ")")))
          (^ (if assign?
                 (^assign attribs-var attribs-array)
                 (^var-declaration attribs-var attribs-array))
             (^assign attribs-var (^ attribs-var "->getStaticVariables()"))
             (thunk))))

       (else
        (compiler-internal-error
         "univ-with-function-attribs, unknown target"))))))

(define (univ-get-function-attrib ctx fn attrib)
  (case (univ-procedure-representation ctx)

    ((class)
     (^member (^local-var fn) attrib))

    (else
     (case (target-name (ctx-target ctx))

       ((js python ruby)
        (^member (^local-var fn) attrib))

       ((php)
        (let ((attribs-var
               (^local-var (^ fn "_attribs"))))
          (^prop-index attribs-var (^str attrib))))

       (else
        (compiler-internal-error
         "univ-get-function-attrib, unknown target"))))))

(define (univ-call-with-fn-attrib ctx fn attrib return)
  (^ (^var-declaration
      (^local-var "fn")
      fn)
     (univ-with-function-attribs
      ctx
      #f
      "func"
      (lambda ()
        (return
         (univ-get-function-attrib ctx "fn" attrib))))))

(define (univ-emit-pair? ctx expr)
  (^instanceof (^prefix-class (univ-use-rtlib ctx 'Pair)) expr))

(define (univ-emit-cons ctx expr1 expr2)
  (^new (^prefix-class (univ-use-rtlib ctx 'Pair)) expr1 expr2))

(define (univ-emit-getcar ctx expr)
  (^member expr "car"))

(define (univ-emit-getcdr ctx expr)
  (^member expr "cdr"))

(define (univ-emit-setcar ctx expr1 expr2)
  (^assign (^member expr1 "car") expr2))

(define (univ-emit-setcdr ctx expr1 expr2)
  (^assign (^member expr1 "cdr") expr2))

(define (univ-emit-float ctx val)
  ;; TODO: generate correct syntax
  (^
   (let ((str (number->string val)))

     (cond ((string=? str "+nan.0")
            (case (target-name (ctx-target ctx))
              ((js)     "Number.NaN")
              ((php)    "NAN")
              ((python) "float('nan')")
              ((ruby)   "Float::NAN")
              (else
               (compiler-internal-error
                "univ-emit-float, unknown target"))))

           ((string=? str "+inf.0")
            (case (target-name (ctx-target ctx))
              ((js)     "Number.POSITIVE_INFINITY")
              ((php)    "INF")
              ((python) "float('inf')")
              ((ruby)   "Float::INFINITY")
              (else
               (compiler-internal-error
                "univ-emit-float, unknown target"))))

           ((string=? str "-inf.0")
            (case (target-name (ctx-target ctx))
              ((js)     "Number.NEGATIVE_INFINITY")
              ((php)    "(-INF)")
              ((python) "(-float('inf'))")
              ((ruby)   "(-Float::INFINITY)")
              (else
               (compiler-internal-error
                "univ-emit-float, unknown target"))))

           ((and (string=? str "-0.")
                 (eq? (target-name (ctx-target ctx)) 'php))
            ;; it is strange that in PHP -0.0 is the same as 0.0
            "0.0*-1")

           ((char=? (string-ref str 0) #\.)
            (string-append "0" str))

           ((and (char=? (string-ref str 0) #\-)
                 (char=? (string-ref str 1) #\.))
            (string-append "-0" (substring str 1 (string-length str))))

           ((char=? (string-ref str (- (string-length str) 1)) #\.)
            (string-append str "0"))

           (else
            str)))))

(define (univ-emit-float-fromint ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     expr)

    ((php)
     (^ "(float)(" expr ")"))

    ((python)
     (^ "float(" expr ")"))

    ((ruby)
     (^ expr ".to_f"))

    (else
     (compiler-internal-error
      "univ-emit-float-fromint, unknown target"))))

(define (univ-emit-float-toint ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^float-truncate expr))

    ((php)
     (^ "(int)(" expr ")"))

    ((python)
     (^ "int(" expr ")"))

    ((ruby)
     (^ expr ".to_i"))

    (else
     (compiler-internal-error
      "univ-emit-float-toint, unknown target"))))

(define (univ-emit-float-abs ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "Math.abs(" expr ")"))

    ((php)
     (^ "abs(" expr ")"))

    ((python)
     (^ "math.fabs(" expr ")"))

    ((ruby)
     (^ expr ".abs"))

    (else
     (compiler-internal-error
      "univ-emit-float-abs, unknown target"))))

(define (univ-emit-float-floor ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "Math.floor(" expr ")"))

    ((php)
     (^ "floor(" expr ")"))

    ((python)
     (^ "math.floor(" expr ")"))

    ((ruby)
     (^ expr ".floor"))

    (else
     (compiler-internal-error
      "univ-emit-float-floor, unknown target"))))

(define (univ-emit-float-ceiling ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "Math.ceil(" expr ")"))

    ((php)
     (^ "ceil(" expr ")"))

    ((python)
     (^ "math.ceil(" expr ")"))

    ((ruby)
     (^ expr ".ceil"))

    (else
     (compiler-internal-error
      "univ-emit-float-ceiling, unknown target"))))

(define (univ-emit-float-truncate ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^if-expr (^< expr (^float targ-inexact-+0))
               (^float-ceiling expr)
               (^float-floor expr)))

    ((python)
     (^ "int(" expr ")"))

    ((ruby)
     (^ expr ".truncate"))

    (else
     (compiler-internal-error
      "univ-emit-float-truncate, unknown target"))))

(define (univ-emit-float-round-half-up ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "Math.round(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-round-half-up, unknown target"))))

(define (univ-emit-float-round-half-towards-0 ctx expr)
  (case (target-name (ctx-target ctx))

    ((php)
     (^ "round(" expr ")"))

    ((python)
     (^ "round(" expr ")"))

    ((ruby)
     (^ expr ".round"))

    (else
     (compiler-internal-error
      "univ-emit-float-round-half-towards-0, unknown target"))))

(define (univ-emit-float-round-half-to-even ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^- (^float-round-half-up expr)
         (^parens
          (^if-expr (^&& (^!= (^float-mod expr (^float targ-inexact-+2))
                              (^float targ-inexact-+1/2))
                         (^!= (^float-mod expr (^float targ-inexact-+2))
                              (^float -1.5)));;;;;;;;;;;;;;;;
                    (^float targ-inexact-+0)
                    (^float targ-inexact-+1)))))

    ((php python ruby)
     (^+ (^float-round-half-towards-0 expr)
         (^- (^parens
              (^if-expr (^= (^float-mod expr (^float targ-inexact-+2))
                            (^float (- targ-inexact-+1/2)));;;;;;;;;;;;;;;;;
                        (^float targ-inexact-+1)
                        (^float targ-inexact-+0)))
             (^parens
              (^if-expr (^= (^float-mod expr (^float targ-inexact-+2))
                            (^float targ-inexact-+1/2))
                        (^float targ-inexact-+1)
                        (^float targ-inexact-+0))))))

    (else
     (compiler-internal-error
      "univ-emit-float-round-half-to-even, unknown target"))))

#|
JS:
for (var i=-8; i<=8; i++) print(i*0.5," ",(i*0.5)%2," ",Math.round(i*0.5));
-4    0   -4
-3.5 -1.5 -3 -1
-3   -1   -3
-2.5 -0.5 -2
-2    0   -2
-1.5 -1.5 -1 -1
-1   -1   -1
-0.5 -0.5  0
0     0    0
0.5   0.5  1 -1
1     1    1
1.5   1.5  2
2     0    2
2.5   0.5  3 -1
3     1    3
3.5   1.5  4
4     0    4

PHP:
i*0.5, fmod(i*0.5,2), round(i*0.5)
-4    0   -4
-3.5 -1.5 -4
-3   -1   -3
-2.5 -0.5 -3 +1
-2    0   -2
-1.5 -1.5 -2
-1   -1   -1
-0.5 -0.5 -1 +1
0     0    0
0.5   0.5  1 -1
1     1    1
1.5   1.5  2
2     0    2
2.5   0.5  3 -1
3     1    3
3.5   1.5  4
4     0    4

Python:
for i in range(-8,8):
  print '%f %f %f' % ((i*0.5),math.fmod(i*0.5,2),round(i*0.5))
-4    0   -4
-3.5 -1.5 -4
-3   -1   -3
-2.5 -0.5 -3 +1
-2    0   -2
-1.5 -1.5 -2
-1   -1   -1
-0.5 -0.5 -1 +1
0     0    0
0.5   0.5  1 -1
1     1    1
1.5   1.5  2
2     0    2
2.5   0.5  3 -1
3     1    3
3.5   1.5  4
4     0    4

Ruby:
(-8..8).each {|i| puts (i*0.5),(i*0.5).remainder(2),(i*0.5).round}
-4.0 -0.0 -4
-3.5 -1.5 -4
-3.0 -1.0 -3
-2.5 -0.5 -3 +1
-2.0 -0.0 -2
-1.5 -1.5 -2
-1.0 -1.0 -1
-0.5 -0.5 -1 +1
 0.0  0.0  0
 0.5  0.5  1 -1
 1.0  1.0  1
 1.5  1.5  2
 2.0  0.0  2
 2.5  0.5  3 -1
 3.0  1.0  3
 3.5  1.5  4
 4.0  0.0  4
|#

(define (univ-emit-float-mod ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 " % " expr2))

    ((php)
     (^ "fmod(" expr1 "," expr2 ")"))

    ((python)
     (^ "math.fmod(" expr1 "," expr2 ")"))

    ((ruby)
     (^ expr1 ".remainder(" expr2 ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-fmod, unknown target"))))

(define (univ-emit-float-exp ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ "Math.exp(" expr ")"))

    ((php)
     (^ "exp(" expr ")"))

    ((python)
     (^ "math.exp(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-exp, unknown target"))))

(define (univ-emit-float-log ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ "Math.log(" expr ")"))

    ((php)
     (^ "log(" expr ")"))

    ((python)
     (^ "math.log(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-log, unknown target"))))

(define (univ-emit-float-sin ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ "Math.sin(" expr ")"))

    ((php)
     (^ "sin(" expr ")"))

    ((python)
     (^ "math.sin(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-sin, unknown target"))))

(define (univ-emit-float-cos ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ "Math.cos(" expr ")"))

    ((php)
     (^ "cos(" expr ")"))

    ((python)
     (^ "math.cos(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-cos, unknown target"))))

(define (univ-emit-float-tan ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ "Math.tan(" expr ")"))

    ((php)
     (^ "tan(" expr ")"))

    ((python)
     (^ "math.tan(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-tan, unknown target"))))

(define (univ-emit-float-asin ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ "Math.asin(" expr ")"))

    ((php)
     (^ "asin(" expr ")"))

    ((python)
     (^ "math.asin(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-asin, unknown target"))))

(define (univ-emit-float-acos ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ "Math.acos(" expr ")"))

    ((php)
     (^ "acos(" expr ")"))

    ((python)
     (^ "math.acos(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-acos, unknown target"))))

(define (univ-emit-float-atan ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ "Math.atan(" expr ")"))

    ((php)
     (^ "atan(" expr ")"))

    ((python)
     (^ "math.atan(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-atan, unknown target"))))

(define (univ-emit-float-atan2 ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ "Math.atan2(" expr1 "," expr2 ")"))

    ((php)
     (^ "atan2(" expr1 "," expr2 ")"))

    ((python)
     (^ "math.atan2(" expr1 "," expr2 ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-atan2, unknown target"))))

(define (univ-emit-float-expt ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "Math.pow(" expr1 "," expr2 ")"))

    ((php)
     (^ "pow(" expr1 "," expr2 ")"))

    ((python)
     (^ "math.pow(" expr1 "," expr2 ")"))

    ((ruby)
     (^ expr1 " ** " expr2))

    (else
     (compiler-internal-error
      "univ-emit-float-expt, unknown target"))))

(define (univ-emit-float-sqrt ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ "Math.sqrt(" expr ")"))

    ((php)
     (^ "sqrt(" expr ")"))

    ((python)
     (^ "math.sqrt(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-sqrt, unknown target"))))

#;
(
;; PHP Math functions
abs
acos
acosh
asin
asinh
atan2
atan
atanh
base_ convert
bindec
ceil
cos
cosh
decbin
dechex
decoct
deg2rad
exp
expm1
floor
fmod
getrandmax
hexdec
hypot
is_ finite
is_ infinite
is_ nan
lcg_ value
log10
log1p
log
max
min
mt_ getrandmax
mt_ rand
mt_ srand
octdec
pi
pow
rad2deg
rand
round
sin
sinh
sqrt
srand
tan
tanh
)

(define (univ-emit-float-integer? ctx expr)
  (^&& (^not (^parens (^float-infinite? expr)))
       (^= expr (^float-floor expr))))

(define (univ-emit-float-finite? ctx expr)
  (case (target-name (ctx-target ctx))

    ((php)
     (^call-prim "is_finite" expr))

    (else
     ;;TODO: move constants elsewhere
     (^&& (^>= expr (^float -1.7976931348623151e308))
          (^<= expr (^float 1.7976931348623151e308))))))

(define (univ-emit-float-infinite? ctx expr)
  (case (target-name (ctx-target ctx))

    ((php)
     (^call-prim "is_infinite" expr))

    (else
     ;;TODO: move constants elsewhere
     (^or (^< expr (^float -1.7976931348623151e308))
          (^> expr (^float 1.7976931348623151e308))))))

(define (univ-emit-float-nan? ctx expr)
  (case (target-name (ctx-target ctx))

    ((php)
     (^call-prim "is_nan" expr))

    (else
     (^!= expr expr))))

(define (univ-emit-flonum-box ctx expr)
  (case (univ-flonum-representation ctx)

    ((class)
     (univ-box
      (^new (^prefix-class (univ-use-rtlib ctx 'Flonum)) expr)
      expr))

    (else
     expr)))

(define (univ-emit-flonum-unbox ctx expr)
  (case (univ-flonum-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member expr "val")))

    (else
     expr)))

(define (univ-emit-flonum? ctx expr)
  (case (univ-flonum-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'Flonum)) expr))

    (else
     (case (target-name (ctx-target ctx))

       ((js)
        (^typeof "number" expr))

       ((php)
        (^ "is_float(" expr ")"))

       ((python)
        (^ "isinstance(" expr ", float)"))

       ((ruby)
        (^ expr ".instance_of?(Float)"))

       (else
        (compiler-internal-error
         "univ-emit-flonum?, unknown target"))))))

(define (univ-emit-cpxnum-make ctx expr1 expr2)
  (^new (^prefix-class (univ-use-rtlib ctx 'Cpxnum)) expr1 expr2))

(define (univ-emit-cpxnum? ctx expr)
  (^instanceof (^prefix-class (univ-use-rtlib ctx 'Cpxnum)) expr))

(define (univ-emit-ratnum-make ctx expr1 expr2)
  (^new (^prefix-class (univ-use-rtlib ctx 'Ratnum)) expr1 expr2))

(define (univ-emit-ratnum? ctx expr)
  (^instanceof (^prefix-class (univ-use-rtlib ctx 'Ratnum)) expr))

(define (univ-emit-bignum ctx expr1)
  (^new (^prefix-class (univ-use-rtlib ctx 'Bignum)) expr1))

(define (univ-emit-bignum? ctx expr)
  (^instanceof (^prefix-class (univ-use-rtlib ctx 'Bignum)) expr))

(define (univ-emit-vector-box ctx expr)
  (case (univ-vector-representation ctx)

    ((class)
     (^new (^prefix-class (univ-use-rtlib ctx 'Vector)) expr))

    (else
     expr)))

(define (univ-emit-vector-unbox ctx expr)
  (case (univ-vector-representation ctx)

    ((class)
     (^member expr "elems"))

    (else
     expr)))

(define (univ-emit-vector? ctx expr)
  (case (univ-vector-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'Vector)) expr))

    (else
     (case (target-name (ctx-target ctx))

       ((js ruby)
        (^instanceof "Array" expr))

       ((php)
        (^call-prim "is_array" expr))

       ((python)
        (^instanceof "list" expr))

       (else
        (compiler-internal-error
         "univ-emit-vector?, unknown target"))))))

(define (univ-emit-vector-length ctx expr)
  (^array-length (^vector-unbox expr)))

(define (univ-emit-vector-shrink! ctx expr1 expr2)
  (^array-shrink! (^vector-unbox expr1) expr2))

(define (univ-emit-vector-ref ctx expr1 expr2)
  (^array-index (^vector-unbox expr1) expr2))

(define (univ-emit-vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^vector-unbox expr1) expr2) expr3))

(define (univ-emit-u8vector-box ctx expr)
  (case (univ-u8vector-representation ctx)

    ((class)
     (^new (^prefix-class (univ-use-rtlib ctx 'U8Vector)) expr))

    (else
     (compiler-internal-error
      "univ-emit-u8vector-box, host representation not implemented"))))

(define (univ-emit-u8vector-unbox ctx expr)
  (case (univ-u8vector-representation ctx)

    ((class)
     (^member expr "elems"))

    (else
     (compiler-internal-error
      "univ-emit-u8vector-unbox, host representation not implemented"))))

(define (univ-emit-u8vector? ctx expr)
  (case (univ-u8vector-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'U8Vector)) expr))

    (else
     (compiler-internal-error
      "univ-emit-u8vector?, host representation not implemented"))))

(define (univ-emit-u8vector-length ctx expr)
  (^array-length (^u8vector-unbox expr)))

(define (univ-emit-u8vector-shrink! ctx expr1 expr2)
  (^array-shrink! (^u8vector-unbox expr1) expr2))

(define (univ-emit-u8vector-ref ctx expr1 expr2)
  (^array-index (^u8vector-unbox expr1) expr2))

(define (univ-emit-u8vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^u8vector-unbox expr1) expr2) expr3))

(define (univ-emit-u16vector-box ctx expr)
  (case (univ-u16vector-representation ctx)

    ((class)
     (^new (^prefix-class (univ-use-rtlib ctx 'U16Vector)) expr))

    (else
     (compiler-internal-error
      "univ-emit-u16vector-box, host representation not implemented"))))

(define (univ-emit-u16vector-unbox ctx expr)
  (case (univ-u16vector-representation ctx)

    ((class)
     (^member expr "elems"))

    (else
     (compiler-internal-error
      "univ-emit-u16vector-unbox, host representation not implemented"))))

(define (univ-emit-u16vector? ctx expr)
  (case (univ-u16vector-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'U16Vector)) expr))

    (else
     (compiler-internal-error
      "univ-emit-u16vector?, host representation not implemented"))))

(define (univ-emit-u16vector-length ctx expr)
  (^array-length (^u16vector-unbox expr)))

(define (univ-emit-u16vector-shrink! ctx expr1 expr2)
  (^array-shrink! (^u16vector-unbox expr1) expr2))

(define (univ-emit-u16vector-ref ctx expr1 expr2)
  (^array-index (^u16vector-unbox expr1) expr2))

(define (univ-emit-u16vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^u16vector-unbox expr1) expr2) expr3))

(define (univ-emit-f64vector-box ctx expr)
  (case (univ-f64vector-representation ctx)

    ((class)
     (^new (^prefix-class (univ-use-rtlib ctx 'F64Vector)) expr))

    (else
     (compiler-internal-error
      "univ-emit-f64vector-box, host representation not implemented"))))

(define (univ-emit-f64vector-unbox ctx expr)
  (case (univ-f64vector-representation ctx)

    ((class)
     (^member expr "elems"))

    (else
     (compiler-internal-error
      "univ-emit-f64vector-unbox, host representation not implemented"))))

(define (univ-emit-f64vector? ctx expr)
  (case (univ-f64vector-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'F64Vector)) expr))

    (else
     (compiler-internal-error
      "univ-emit-f64vector?, host representation not implemented"))))

(define (univ-emit-f64vector-length ctx expr)
  (^array-length (^f64vector-unbox expr)))

(define (univ-emit-f64vector-shrink! ctx expr1 expr2)
  (^array-shrink! (^f64vector-unbox expr1) expr2))

(define (univ-emit-f64vector-ref ctx expr1 expr2)
  (^array-index (^f64vector-unbox expr1) expr2))

(define (univ-emit-f64vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^f64vector-unbox expr1) expr2) expr3))

(define (univ-emit-structure-box ctx expr)
  (case (univ-structure-representation ctx)

    ((class)
     (^new (^prefix-class (univ-use-rtlib ctx 'Structure)) expr))

    (else
     (compiler-internal-error
      "univ-emit-structure-box, host representation not implemented"))))

(define (univ-emit-structure-unbox ctx expr)
  (case (univ-structure-representation ctx)

    ((class)
     (^member expr "slots"))

    (else
     (compiler-internal-error
      "univ-emit-structure-unbox, host representation not implemented"))))

(define (univ-emit-structure? ctx expr)
  (case (univ-structure-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'Structure)) expr))

    (else
     (compiler-internal-error
      "univ-emit-structure?, host representation not implemented"))))

(define (univ-emit-structure-ref ctx expr1 expr2)
  (^array-index (^structure-unbox expr1) expr2))

(define (univ-emit-structure-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^structure-unbox expr1) expr2) expr3))

(define (univ-emit-str ctx val)
  ;; TODO: generate correct escapes for the target language
  (^ "'" val "'"))

(define (univ-emit-strtocodes ctx expr)
  (case (univ-string-representation ctx)

    ((class)
     (^call-prim
      (^prefix (univ-use-rtlib ctx 'strtocodes))
      expr))

    (else
     expr)))

(define (univ-emit-string-obj ctx obj force-var?)
  (case (univ-string-representation ctx)

    ((class)
     (let ((x
            (^array-literal
             (map (lambda (c) (^int (char->integer c)))
                  (string->list obj)))))
       (univ-obj-use
        ctx
        obj
        force-var?
        (lambda ()
          (^string-box x)))))

    (else
     (^str obj))))

(define (univ-emit-string-box ctx expr)
  (case (univ-string-representation ctx)

    ((class)
     (^new (^prefix-class (univ-use-rtlib ctx 'String)) expr))

    (else
     expr)))

(define (univ-emit-string-unbox ctx expr)
  (case (univ-string-representation ctx)

    ((class)
     (^member expr "codes"))

    (else
     expr)))

(define (univ-emit-string? ctx expr)
  (case (univ-string-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'String)) expr))

    (else
     (case (target-name (ctx-target ctx))

       ((js)
        (^typeof "string" expr))

       ((php)
        (^call-prim "is_string" expr))

       ((python)
        (^instanceof "str" expr))

       ((ruby)
        (^instanceof "String" expr))

       (else
        (compiler-internal-error
         "univ-emit-string?, unknown target"))))))

(define (univ-emit-string-length ctx expr)
  (case (univ-string-representation ctx)

    ((class)
     (^array-length (^string-unbox expr)))

    (else
     (compiler-internal-error
      "univ-emit-string-length, unknown target"))))

(define (univ-emit-string-shrink! ctx expr1 expr2)
  (case (univ-string-representation ctx)

    ((class)
     (^array-shrink! (^string-unbox expr1) expr2))

    (else
     (compiler-internal-error
      "univ-emit-string-shrink!, host representation not implemented"))))

(define (univ-emit-string-ref ctx expr1 expr2)
  (case (univ-string-representation ctx)

    ((class)
     (^array-index expr1 expr2))

    (else
     (case (target-name (ctx-target ctx))

       ((js)
        (^call-prim (^member expr1 "charCodeAt") expr2))

       ((php)
        (^call-prim "uniord" (^call-prim "substr" expr1 expr2 (^int 1))))

       ((python)
        (^call-prim "ord" (^ expr1 "[" expr2 "]")))

       ((ruby)
        (^ expr1 "[" expr2 "]" ".ord"))

       (else
        (compiler-internal-error
         "univ-emit-string-ref, unknown target"))))))

(define (univ-emit-string-set! ctx expr1 expr2 expr3)
  (case (univ-string-representation ctx)

    ((class)
     (^assign (^array-index expr1 expr2) expr3))

    (else
     ;; mutable strings do not exist in js, php, python and ruby
     (compiler-internal-error
      "univ-emit-string-set!, host representation not implemented"))))

(define (univ-emit-symbol-obj ctx obj force-var?)
  (case (univ-symbol-representation ctx)

    ((class)
     (let ((x (^str (symbol->string obj))))
       (univ-box
        (univ-obj-use
         ctx
         obj
         force-var?
         (lambda ()
           (^symbol-box x)))
        x)))

    (else
     (case (target-name (ctx-target ctx))

       ((js php python)
        (^str (symbol->string obj)))

       ((ruby)
        (^ ":" (^str (symbol->string obj))))

       (else
        (compiler-internal-error
         "univ-emit-symbol-obj, unknown target"))))))

(define (univ-emit-symbol-box ctx expr)
  (case (univ-symbol-representation ctx)

    ((class)
     (univ-box
      (^call-prim
       (^prefix (univ-use-rtlib ctx 'make_interned_symbol))
       expr)
      expr))

    (else
     (^symbol-box-uninterned expr))))

(define (univ-emit-symbol-box-uninterned ctx expr)
  (case (univ-symbol-representation ctx)

    ((class)
     (univ-box
      (^new (^prefix-class (univ-use-rtlib ctx 'Symbol)) expr)
      expr))

    (else
     (case (target-name (ctx-target ctx))

       ((js php python)
        expr)

       ((ruby)
        (^ expr ".to_sym"))

       (else
        (compiler-internal-error
         "univ-emit-symbol-box-uninterned, unknown target"))))))

(define (univ-emit-symbol-unbox ctx expr)
  (case (univ-symbol-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member expr "str")))

    (else
     (case (target-name (ctx-target ctx))

       ((js php python)
        expr)

       ((ruby)
        (^ expr ".to_s"))

       (else
        (compiler-internal-error
         "univ-emit-symbol-unbox, unknown target"))))))

(define (univ-emit-symbol? ctx expr)
  (case (univ-symbol-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'Symbol)) expr))

    (else
     (case (target-name (ctx-target ctx))

       ((js)
        (^typeof "string" expr))

       ((php)
        (^call-prim "is_string" expr))

       ((python)
        (^instanceof "str" expr))

       ((ruby)
        (^instanceof "Symbol" expr))

       (else
        (compiler-internal-error
         "univ-emit-symbol?, unknown target"))))))

(define (univ-emit-keyword-obj ctx obj force-var?)
  (case (univ-keyword-representation ctx)

    ((class)
     (let ((x (^str (keyword->string obj))))
       (univ-box
        (univ-obj-use
         ctx
         obj
         force-var?
         (lambda ()
           (^keyword-box x)))
        x)))

    (else
     (compiler-internal-error
      "univ-emit-keyword-box, host representation not implemented"))))

(define (univ-emit-keyword-box ctx expr)
  (case (univ-keyword-representation ctx)

    ((class)
     (univ-box
      (^call-prim
       (^prefix (univ-use-rtlib ctx 'make_interned_keyword))
       expr)
      expr))

    (else
     (^keyword-box-uninterned expr))))

(define (univ-emit-keyword-box-uninterned ctx expr)
  (case (univ-keyword-representation ctx)

    ((class)
     (univ-box
      (^new (^prefix-class (univ-use-rtlib ctx 'Keyword)) expr)
      expr))

    (else
     (case (target-name (ctx-target ctx))

       ((js php python)
        expr)

       ((ruby)
        (^ expr ".to_sym"))

       (else
        (compiler-internal-error
         "univ-emit-keyword-box-uninterned, unknown target"))))))

(define (univ-emit-keyword-unbox ctx expr)
  (case (univ-keyword-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member expr "str")))

    (else
     (compiler-internal-error
      "univ-emit-keyword-unbox, host representation not implemented"))))

(define (univ-emit-keyword? ctx expr)
  (case (univ-keyword-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'Keyword)) expr))

    (else
     (compiler-internal-error
      "univ-emit-keyword?, host representation not implemented"))))

(define (univ-emit-box? ctx expr)
  (^instanceof (^prefix-class (univ-use-rtlib ctx 'Box)) expr))

(define (univ-emit-box ctx expr)
  (^new (^prefix-class (univ-use-rtlib ctx 'Box)) expr))

(define (univ-emit-unbox ctx expr)
  (^member expr "val"))

(define (univ-emit-setbox ctx expr1 expr2)
  (^assign (^member expr1 "val") expr2))

(define (univ-emit-frame? ctx expr)
  (^instanceof (^prefix-class (univ-use-rtlib ctx 'Frame)) expr))

(define (univ-emit-continuation? ctx expr)
  (^instanceof (^prefix-class (univ-use-rtlib ctx 'Continuation)) expr))

(define (univ-emit-procedure? ctx expr)
  (case (univ-procedure-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'Procedure)) expr))

    (else
     (case (target-name (ctx-target ctx))

       ((js)
        (^typeof "function" expr))

       ((php)
        (^call-prim "is_callable" expr))

       ((python)
        (^ "hasattr(" expr ", '__call__')"))

       ((ruby)
        (^instanceof "Proc" expr))

       (else
        (compiler-internal-error
         "univ-emit-procedure?, unknown target"))))))

(define (univ-emit-closure? ctx expr)
  (case (univ-procedure-representation ctx)

    ((class)
     (^instanceof (^prefix-class (univ-use-rtlib ctx 'Closure)) expr))

    (else
     (case (target-name (ctx-target ctx))

       ((js)
        (^not (^prop-index-exists? expr (^str "id"))))

       ((php)
        (^instanceof (^prefix-class "closure") expr))

       ((python)
        (^not
         (^call-prim
          "hasattr"
          expr
          (^str "id"))))

       ((ruby)
        (^= (^ expr ".instance_variables.length") (^int 0)))

       (else
        (compiler-internal-error
         "univ-emit-closure?, unknown target"))))))

(define (univ-emit-closure-length ctx expr)
  (^array-length (univ-clo-slots ctx expr)))

(define (univ-emit-closure-code ctx expr)
  (^array-index (univ-clo-slots ctx expr) 0))

(define (univ-emit-closure-ref ctx expr1 expr2)
  (^array-index (univ-clo-slots ctx expr1) expr2))

(define (univ-emit-closure-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (univ-clo-slots ctx expr1) expr2) expr3))

(define (univ-emit-call-prim ctx expr . params)
  (univ-emit-call-prim-aux ctx expr params))

(define (univ-emit-call-prim-aux ctx expr params)
  (if (and (null? params)
           (eq? (target-name (ctx-target ctx)) 'ruby))
      expr
      (univ-emit-apply-aux ctx expr params "(" ")")))

(define (univ-emit-call ctx proc . params)
  (case (univ-procedure-representation ctx)

    ((class)
     (univ-emit-call-prim-aux ctx (^member proc "call") params))

    (else
     (univ-emit-call-aux ctx proc params))))

(define (univ-emit-call-aux ctx expr params)
  (if (eq? (target-name (ctx-target ctx)) 'ruby)
      (univ-emit-apply-aux ctx expr params "[" "]")
      (univ-emit-apply-aux ctx expr params "(" ")")))

(define (univ-emit-apply ctx expr params)
  (univ-emit-apply-aux ctx expr params "(" ")"))

(define (univ-emit-apply-aux ctx expr params open close)
  (^ expr
     open
     (univ-separated-list "," params)
     close))

(define (univ-emit-this ctx)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ "this"))

    ((python ruby)
     (^ "self"))

    (else
     (compiler-internal-error
      "univ-emit-this, unknown target"))))

(define (univ-emit-this-member ctx name)
  (case (target-name (ctx-target ctx))

    ((js php python)
     (^member (^local-var (^this)) name))

    ((ruby)
     (^ "@" name))

    (else
     (compiler-internal-error
      "univ-emit-this-member, unknown target"))))

(define (univ-emit-new ctx class . params)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^parens-php (^ "new " (^apply class params))))

    ((python)
     (^apply class params))

    ((ruby)
     (^apply (^ class ".new") params))

    (else
     (compiler-internal-error
      "univ-emit-new, unknown target"))))

(define (univ-emit-typeof ctx type expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^eq? (^ "typeof " expr) (^str type)))

    (else
     (compiler-internal-error
      "unit-emit-typeof, unknown target"))))

(define (univ-emit-instanceof ctx class expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ expr " instanceof " class))

    ((python)
     (^call-prim "isinstance" expr class))

    ((ruby)
     (^ expr ".kind_of?(" class ")"))

    (else
     (compiler-internal-error
      "unit-emit-instanceof, unknown target"))))

(define (univ-throw ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ "throw " expr ";\n"))

    ((python ruby)
     (^ "raise " expr "\n"))

    (else
     (compiler-internal-error
      "univ-throw, unknown target"))))

(define (univ-fxquotient ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ (^parens (^ expr1 " / " expr2)) " | 0"))

    ((php)
     (^ "(int)(" expr1 " / " expr2 ")"))

    ((python)
     (^call-prim "int" (^/ (^call-prim "float" expr1)
                           (^call-prim "float" expr2))))

    ((ruby)
     (^ (^parens (^ (^ expr1 ".to_f") "/" (^ expr2 ".to_f"))) ".to_int"))

    (else
     (compiler-internal-error
      "univ-fxquotient, unknown target"))))

(define (univ-fxmodulo ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ (^parens (^ (^parens (^ expr1 " % " expr2)) " + " expr2)) " % " expr2))

    ((python ruby)
     (^ expr1 " % " expr2))

    (else
     (compiler-internal-error
      "univ-fxmodulo, unknown target"))))

(define (univ-fxremainder ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ expr1 " % " expr2))

    ((python)
     (^- expr1
         (^* (^call-prim "int" (^/ (^call-prim "float" expr1)
                                   (^call-prim "float" expr2)))
             expr2)))

    ((ruby)
     (^ expr1 ".remainder(" expr2 ")"))

    (else
     (compiler-internal-error
      "univ-fxremainder, unknown target"))))

(define (univ-define-prim
         name
         proc-safe?
         apply-gen
         #!optional
         (ifjump-gen #f)
         (jump-gen #f))
  (let ((prim (univ-prim-info* (string->canonical-symbol name))))

    (if apply-gen
        (begin

          (proc-obj-inlinable?-set!
           prim
           (lambda (env)
             (or proc-safe?
                 (not (safe? env)))))

          (proc-obj-inline-set! prim apply-gen)))

    (if ifjump-gen
        (begin

          (proc-obj-testable?-set!
           prim
           (lambda (env)
             (or proc-safe?
                 (not (safe? env)))))

          (proc-obj-test-set! prim ifjump-gen)))

    (if jump-gen
        (begin

          (proc-obj-jump-inlinable?-set!
           prim
           (lambda (env)
             #t))

          (proc-obj-jump-inline-set!
           prim
           jump-gen)))))

(define (univ-define-prim-bool name proc-safe? ifjump-gen)
  (univ-define-prim
   name
   proc-safe?
   (lambda (ctx return . opnds)
     (apply ifjump-gen
            (cons ctx
                  (cons (lambda (result) (return (^boolean-box result)))
                        opnds))))
   ifjump-gen))

;;TODO: remove
#;
(define (univ-string ctx obj)

  (case (target-name (ctx-target ctx))

    ((js)
     (^ (^prefix "String.jsstringToString")
        "("
        (object->string obj)
        ")"))

    ;; ((js)
    ;;  (^ "new "
    ;;     (univ-emit-apply ctx
    ;;                      (^prefix "String")
    ;;                      (map (lambda (ch) (univ-char ctx ch))
    ;;                           (string->list obj)))))

    ((python)
     (^ (^prefix "String")
        "(*list(unicode("
        (object->string obj)
        ")))"))

    ((ruby php)                         ;TODO: complete
     (^ (object->string obj)))

    (else
     (compiler-internal-error
      "univ-string, unknown target"))))

;;;TODO: remove
#;
(define (univ-symbol ctx obj)

  (case (target-name (ctx-target ctx))

    ((js)
     (^ (^prefix "Symbol.stringToSymbol")
        "("
        (univ-string ctx (symbol->string obj))
        ")"))

    ((python ruby php)                         ;TODO: complete
     (^ (object->string obj)))

    (else
     (compiler-internal-error
      "univ-symbol, unknown target"))))

(define (univ-undefined ctx)

  (case (target-name (ctx-target ctx))

    ((js)
     (^ "undefined"))

    ((python)
     (^ "None"))

    ((ruby)
     (^ "nil"))

    ((php)                                ;TODO: complete
     (^))

    (else
     (compiler-internal-error
      "univ-undefined, unknown target"))))


;; (define (univ-list ctx obj)             ;obj is a non-null list

;;   (define (make-list n elt)
;;     (vector->list (make-vector n elt)))

;;   (define (zip lst1 lst2)
;;     (define (zip-aux lst1 lst2 lst)
;;       (cond ((null? lst1)
;;              (append lst lst2))
;;             ((null? lst2)
;;              (append lst lst1))
;;             (else
;;              (cons (car lst1)
;;                    (cons (car lst2)
;;                          (zip-aux (cdr lst1) (cdr lst2) lst))))))

;;     (zip-aux lst1 lst2 '()))

;;   (case (target-name (ctx-target ctx))

;;     ((js python)
;;      (let ((tobj (map (lambda (o) (univ-emit-obj ctx o))
;;                       obj))
;;            (sep (make-list (- (length obj) 1) ", ")))
;;        (^ (^prefix "List(")
;;           (zip tobj sep)
;;           ")")))

;;     ((python ruby php)                         ;TODO: complete
;;      (^ (object->string obj)))

;;     (else
;;      (compiler-internal-error
;;       "univ-list, unknown target"))))



;; =============================================================================

;;; Primitive procedures

;; TODO move elsewhere
(define (univ-fold-left
         op0
         op1
         op2
         #!optional
         (unbox (lambda (ctx x) x))
         (box (lambda (ctx x) x)))
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (cond ((null? args)
             (box ctx (op0 ctx)))
            ((null? (cdr args))
             (box ctx (op1 ctx (unbox ctx (car args)))))
            (else
             (let loop ((lst (cddr args))
                        (res (op2 ctx
                                  (unbox ctx (car args))
                                  (unbox ctx (cadr args)))))
               (if (null? lst)
                   (box ctx res)
                   (loop (cdr lst)
                         (op2 ctx
                              (^parens res)
                              (unbox ctx (car lst))))))))))))

(define (univ-fold-left-compare
         op0
         op1
         op2
         #!optional
         (unbox (lambda (ctx x) x))
         (box (lambda (ctx x) x)))
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (cond ((null? args)
             (box ctx (op0 ctx)))
            ((null? (cdr args))
             (box ctx (op1 ctx (unbox ctx (car args)))))
            (else
             (let loop ((lst (cdr args))
                        (res (op2 ctx
                                  (unbox ctx (car args))
                                  (unbox ctx (cadr args)))))
               (let ((rest (cdr lst)))
                 (if (null? rest)
                     (box ctx res)
                     (loop rest
                           (^&& (^parens res)
                                (op2 ctx
                                     (unbox ctx (car lst))
                                     (unbox ctx (car rest))))))))))))))

(define (make-translated-operand-generator proc)
  (lambda (ctx return opnds)
    (apply proc (cons ctx (cons return (univ-emit-getopnds ctx opnds))))))

;;----------------------------------------------------------------------------

(univ-define-prim "##type" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^obj 0)))));;TODO: implement

(univ-define-prim "##type-cast" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return arg1))));;TODO: implement

(univ-define-prim "##subtype" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^obj 0)))));;TODO: implement

(univ-define-prim "##subtype-set!" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return #f))));;TODO: implement

(univ-define-prim-bool "##not" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^eq? arg1 (^obj #f))))))

(univ-define-prim-bool "##boolean?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^boolean? arg1)))))

(univ-define-prim-bool "##null?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^eq? arg1 (^obj '()))))))

(univ-define-prim-bool "##unbound?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^unbound? arg1)))))

(univ-define-prim-bool "##eq?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^eq? arg1 arg2)))))

;;TODO: ("##eqv?"               (2)   #f ()    0    boolean extended)
;;TODO: ("##equal?"             (2)   #f ()    0    boolean extended)

(univ-define-prim-bool "##eof-object?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^eq? arg1 (^eof))))))

(univ-define-prim-bool "##fixnum?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^fixnum? arg1)))))

;;TODO: ("##special?"                 (1)   #f ()    0    boolean extended)

(univ-define-prim-bool "##pair?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^pair? arg1)))))

;; TODO: test ##pair-mutable?

(univ-define-prim-bool "##pair-mutable?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^obj #t))))) ;; there are no immutable data (currently)

;;TODO: ("##subtyped?"                (1)   #f ()    0    boolean extended)

;; TODO: test ##subtyped-mutable?

(univ-define-prim-bool "##subtyped-mutable?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^obj #t))))) ;; there are no immutable data (currently)

;;TODO: ("##subtyped.vector?"         (1)   #f ()    0    boolean extended)
;;TODO: ("##subtyped.symbol?"         (1)   #f ()    0    boolean extended)
;;TODO: ("##subtyped.flonum?"         (1)   #f ()    0    boolean extended)
;;TODO: ("##subtyped.bignum?"         (1)   #f ()    0    boolean extended)

(univ-define-prim-bool "##vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^vector? arg1)))))

(univ-define-prim-bool "##u8vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^u8vector? arg1)))))

(univ-define-prim-bool "##u16vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^u16vector? arg1)))))

(univ-define-prim-bool "##f64vector?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^f64vector? arg1)))))

;;TODO: ("##ratnum?"                  (1)   #f ()    0    boolean extended)
;;TODO: ("##cpxnum?"                  (1)   #f ()    0    boolean extended)

(univ-define-prim-bool "##structure?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^structure? arg1)))))

;; TODO: test box? primitive

(univ-define-prim-bool "##box?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^box? arg1)))))

;;TODO: ("##values?"                  (1)   #f ()    0    boolean extended)
;;TODO: ("##meroon?"                  (1)   #f ()    0    boolean extended)
;;TODO: ("##jazz?"                    (1)   #f ()    0    boolean extended)

(univ-define-prim-bool "##symbol?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^symbol? arg1)))))

(univ-define-prim-bool "##keyword?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^keyword? arg1)))))

(univ-define-prim-bool "##frame?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^frame? arg1)))))

(univ-define-prim-bool "##continuation?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^continuation? arg1)))))

;;TODO: ("##promise?"                 (1)   #f ()    0    boolean extended)
;;TODO: ("##will?"                    (1)   #f ()    0    boolean extended)
;;TODO: ("##gc-hash-table?"           (1)   #f ()    0    boolean extended)
;;TODO: ("##mem-allocated?"           (1)   #f ()    0    boolean extended)

;; TODO: test ##procedure?

(univ-define-prim-bool "##procedure?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^procedure? arg1)))))

;;TODO: ("##return?"                  (1)   #f ()    0    boolean extended)
;;TODO: ("##foreign?"                 (1)   #f ()    0    boolean extended)

(univ-define-prim-bool "##string?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^string? arg1)))))

;;TODO: ("##s8vector?"                (1)   #f ()    0    boolean extended)
;;TODO: ("##u8vector?"                (1)   #f ()    0    boolean extended)
;;TODO: ("##s16vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##u16vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##s32vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##u32vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##s64vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##u64vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##f32vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##f64vector?"               (1)   #f ()    0    boolean extended)

(univ-define-prim-bool "##flonum?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^flonum? arg1)))))

(univ-define-prim "##cpxnum-make" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^cpxnum-make arg1 arg2)))))

(univ-define-prim "##cpxnum-real" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^member arg1 "real")))))

(univ-define-prim "##cpxnum-imag" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^member arg1 "imag")))))

(univ-define-prim-bool "##cpxnum?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^cpxnum? arg1)))))

(univ-define-prim "##ratnum-make" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^ratnum-make arg1 arg2)))))

(univ-define-prim "##ratnum-numerator" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^member arg1 "num")))))

(univ-define-prim "##ratnum-denominator" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^member arg1 "den")))))

(univ-define-prim-bool "##ratnum?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^ratnum? arg1)))))

(univ-define-prim-bool "##bignum?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^bignum? arg1)))))

;;TODO: ("##bignum?"                  (1)   #f ()    0    boolean extended)

(univ-define-prim-bool "##char?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^char? arg1)))))

(univ-define-prim-bool "##closure?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^closure? arg1)))))

;;TODO: ("##subprocedure?"            (1)   #f ()    0    boolean extended)
;;TODO: ("##return-dynamic-env-bind?" (1)   #f ()    0    boolean extended)
;;TODO: ("##number?"                  (1)   #f ()    0    boolean extended)
;;TODO: ("##complex?"                 (1)   #f ()    0    boolean extended)
;;TODO: ("##real?"                    (1)   #f ()    0    boolean extended)
;;TODO: ("##rational?"                (1)   #f ()    0    boolean extended)
;;TODO: ("##integer?"                 (1)   #f ()    0    boolean extended)
;;TODO: ("##exact?"                   (1)   #f ()    0    boolean extended)
;;TODO: ("##inexact?"                 (1)   #f ()    0    boolean extended)

;;TODO: make variadic, complete, clean up and test
(univ-define-prim "##fxmax" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^if-expr (^> (^fixnum-unbox arg1) (^fixnum-unbox arg2))
                       arg1
                       arg2)))))

;;TODO: make variadic, complete, clean up and test
(univ-define-prim "##fxmin" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^if-expr (^< (^fixnum-unbox arg1) (^fixnum-unbox arg2))
                       arg1
                       arg2)))))

(univ-define-prim "##fxwrap+" #f
  (univ-fold-left
   (lambda (ctx)           (^int 0))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (univ-wrap+ ctx arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

(univ-define-prim "##fx+" #f
  (univ-fold-left
   (lambda (ctx)           (^int 0))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^+ arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

;;TODO: complete, clean up and test, and add boxing/unboxing of fixnums
(univ-define-prim "##fx+?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (case (target-name (ctx-target ctx))

        ((js)
         (^ "(" (^gvar "temp2") " = (" (^gvar "temp1") " = "
            (^fixnum-unbox arg1)
            " + "
            (^fixnum-unbox arg2)
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits
            ") === " (^gvar "temp1") " && " (^fixnum-box (^gvar "temp2"))))

        ((python)
         (^ "(lambda temp1: (lambda temp2: temp1 == temp2 and " (^fixnum-box "temp2") ")(ctypes.c_int32(temp1<<"
            univ-tag-bits
            ").value>>"
            univ-tag-bits
            "))("
            (^fixnum-unbox arg1)
            " + "
            (^fixnum-unbox arg2)
            ")"))

        ((php ruby)
         (^and (^parens
                (^= (^parens
                     (^assign-expr
                      (^gvar "temp2")
                      (^-
                       (^parens
                        (^bitand
                         (^parens
                          (^+
                           (^parens
                            (^assign-expr
                             (^gvar "temp1")
                             (^+ (^fixnum-unbox arg1)
                                 (^fixnum-unbox arg2))))
                           univ-fixnum-max+1))
                         univ-fixnum-max*2+1))
                       univ-fixnum-max+1)))
                    (^gvar "temp1")))
               (^fixnum-box (^gvar "temp2"))))

        (else
         (compiler-internal-error
          "##fx+?, unknown target")))))))

(univ-define-prim "##fxwrap*" #f
  (univ-fold-left
   (lambda (ctx)           (^int 1))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (univ-wrap* ctx arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

(univ-define-prim "##fx*" #f
  (univ-fold-left
   (lambda (ctx)           (^int 1))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^* arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

;;TODO: complete, clean up and test, and add boxing/unboxing of fixnums
(univ-define-prim "##fx*?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (case (target-name (ctx-target ctx))

        ((js)
         (^ "(" (^gvar "temp2") " = (" (^gvar "temp1") " = "
            (^fixnum-unbox arg1)
            " * "
            (^fixnum-unbox arg2)
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits
            ") === " (^gvar "temp1") " && " (^fixnum-box (^gvar "temp2"))))

        ((python)
         (^ "(lambda temp1: (lambda temp2: temp1 == temp2 and " (^fixnum-box "temp2") ")(ctypes.c_int32(temp1<<"
            univ-tag-bits
            ").value>>"
            univ-tag-bits
            "))("
            (^fixnum-unbox arg1)
            " * "
            (^fixnum-unbox arg2)
            ")"))

        ((php ruby)
         (^and (^parens
                (^= (^parens
                     (^assign-expr
                      (^gvar "temp2")
                      (^-
                       (^parens
                        (^bitand
                         (^parens
                          (^+
                           (^parens
                            (^assign-expr
                             (^gvar "temp1")
                             (^* (^fixnum-unbox arg1)
                                 (^fixnum-unbox arg2))))
                           univ-fixnum-max+1))
                         univ-fixnum-max*2+1))
                       univ-fixnum-max+1)))
                    (^gvar "temp1")))
               (^fixnum-box (^gvar "temp2"))))

        (else
         (compiler-internal-error
          "##fx*?, unknown target")))))))

(univ-define-prim "##fxwrap-" #f
  (univ-fold-left
   #f ;; 0 arguments impossible
   (lambda (ctx arg1)      (univ-wrap- ctx arg1))
   (lambda (ctx arg1 arg2) (univ-wrap- ctx arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

(univ-define-prim "##fx-" #f
  (univ-fold-left
   #f ;; 0 arguments impossible
   (lambda (ctx arg1)      (^- arg1))
   (lambda (ctx arg1 arg2) (^- arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

;;TODO: complete, clean up and test, and add boxing/unboxing of fixnums
(univ-define-prim "##fx-?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (case (target-name (ctx-target ctx))

        ((js)
         (^ "(" (^gvar "temp2") " = (" (^gvar "temp1") " = "
            (if arg2
                (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                (^ "- " (^fixnum-unbox arg1)))
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits
            ") === " (^gvar "temp1") " && " (^fixnum-box (^gvar "temp2"))))

        ((python)
         (^ "(lambda temp1: (lambda temp2: temp1 == temp2 and " (^fixnum-box "temp2") ")(ctypes.c_int32(temp1<<"
            univ-tag-bits
            ").value>>"
            univ-tag-bits
            "))("
            (if arg2
                (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                (^ "- " (^fixnum-unbox arg1)))
            ")"))

        ((ruby)
         (^ "(" (^gvar "temp2") " = (((" (^gvar "temp1") " = "
            (if arg2
                (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                (^ "- " (^fixnum-unbox arg1)))
            ") + "
            univ-fixnum-max+1
            ") & "
            univ-fixnum-max*2+1
            ") - "
            univ-fixnum-max+1
            ") == " (^gvar "temp1") " && " (^fixnum-box (^gvar "temp2"))))

        ((php)
         (^ "((" (^gvar "temp2") " = (((" (^gvar "temp1") " = "
            (if arg2
                (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                (^ "- " (^fixnum-unbox arg1)))
            ") + "
            univ-fixnum-max+1
            ") & "
            univ-fixnum-max*2+1
            ") - "
            univ-fixnum-max+1
            ") === " (^gvar "temp1") ") ? " (^fixnum-box (^gvar "temp2")) " : false"))

        (else
         (compiler-internal-error
          "##fx-?, unknown target")))))))

;;TODO: ("##fxwrapquotient"              (2)   #f ()    0    fixnum  extended)

(univ-define-prim "##fxquotient" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (univ-fxquotient
                    ctx
                    (^fixnum-unbox arg1)
                    (^fixnum-unbox arg2)))))))

(univ-define-prim "##fxremainder" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (univ-fxremainder
                    ctx
                    (^fixnum-unbox arg1)
                    (^fixnum-unbox arg2)))))))

(univ-define-prim "##fxmodulo" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (univ-fxmodulo
                    ctx
                    (^fixnum-unbox arg1)
                    (^fixnum-unbox arg2)))))))

(univ-define-prim "##fxnot" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box (^bitnot (^fixnum-unbox arg)))))))

(univ-define-prim "##fxand" #f
  (univ-fold-left
   (lambda (ctx)           (^int -1))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^bitand arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

(univ-define-prim "##fxior" #f
  (univ-fold-left
   (lambda (ctx)           (^int 0))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^bitior arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

(univ-define-prim "##fxxor" #f
  (univ-fold-left
   (lambda (ctx)           (^int 0))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^bitxor arg1 arg2))
   univ-emit-fixnum-unbox
   univ-emit-fixnum-box))

(univ-define-prim "##fxif" #f
  (make-translated-operand-generator
    (lambda (ctx return arg1 arg2 arg3)
      (return
        (^fixnum-box 
          (^bitior (^parens (^bitand (^fixnum-unbox arg1)
                                     (^fixnum-unbox arg2)))
                   (^parens (^bitand (^bitnot (^fixnum-unbox arg1))
                                     (^fixnum-unbox arg3)))))))))

(univ-define-prim "##fxbit-count" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (let ((tmp (^local-var "tmp")))
       (^ (^var-declaration tmp (^fixnum-unbox arg))
          (^assign tmp (^if-expr (^< tmp (^int 0)) (^bitnot tmp) tmp))
          (^popcount! tmp)
          (return (^fixnum-box tmp)))))))

(univ-define-prim "##fxlength" #f
  (make-translated-operand-generator
    (lambda (ctx return arg)
      (let ((tmp (^local-var "tmp")))
        (^ (^var-declaration tmp (^fixnum-unbox arg))
           (^assign tmp (^if-expr (^< tmp (^int 0)) (^bitnot tmp) tmp))
           (let gen-shift ((s 1) (acc (^)))
             (if (>= s univ-word-bits)
                 acc
                 (gen-shift
                   (* s 2)
                   (^ acc
                      (^assign tmp (^bitior tmp (^parens (^>> tmp s))))))))
           (^popcount! tmp)
           (return (^fixnum-box tmp)))))))

(univ-define-prim "##fxfirst-bit-set" #f
  (make-translated-operand-generator
    (lambda (ctx return arg)
      (let ((tmp (^local-var "tmp")))
        (^ (^var-declaration tmp (^fixnum-unbox arg))
           (^assign tmp (^bitxor tmp (^- tmp (^int 1))))
           (^assign tmp (^if-expr (^< tmp (^int 0)) (^bitnot tmp) tmp))
           (^popcount! tmp)
           (return (^fixnum-box (^- tmp (^int 1)))))))))

(univ-define-prim-bool "##fxbit-set?" #f
  (make-translated-operand-generator
    (lambda (ctx return arg1 arg2)
      (return
        (^!=
          (^parens
           (^bitand
            (^parens (^>> (^fixnum-unbox arg2)
                          (^fixnum-unbox arg1)))
            (^int 1)))
          (^int 0))))))

;;TODO: ("##fxwraparithmetic-shift"      (2)   #f ()    0    fixnum  extended)
;;TODO: ("##fxarithmetic-shift"          (2)   #f ()    0    fixnum  extended)
;;TODO: ("##fxarithmetic-shift?"         (2)   #f ()    0    #f      extended)
;;TODO: ("##fxwraplogical-shift-right"   (2)   #f ()    0    fixnum  extended)
;;TODO: ("##fxwraplogical-shift-right?"  (2)   #f ()    0    #f      extended)
;;TODO: ("##fxwrapabs"                   (1)   #f ()    0    fixnum  extended)
;;TODO: ("##fxabs"                       (1)   #f ()    0    fixnum  extended)
;;TODO: ("##fxabs?"                      (1)   #f ()    0    #f      extended)

#;
(univ-define-prim "##fxwraparithmetic-shift" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
       (case (target-name (ctx-target ctx))
        ((js) 
         (^fixnum-box
          (^>> (^<< (^<< (^fixnum-unbox arg1)
                         (^fixnum-unbox arg2))
                    univ-tag-bits)
               univ-tag-bits)))
        ((php python ruby)
         (let ((sign-bit (- (- univ-word-bits univ-tag-bits) 1)))
           (^fixnum-box 
             (^- (^parens (^bitand
                           (^parens (^+ 
                                     (^parens (^<< (^fixnum-unbox arg1)
                                                   (^fixnum-unbox arg2)))
                                     (expt 2 sign-bit)))
                           (- (expt 2 (+ 1 sign-bit)) 1)))
                 (expt 2 sign-bit))))))))))

#;
(univ-define-prim "##fxarithmetic-shift" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (^<< (^fixnum-unbox arg1)
                        (^fixnum-unbox arg2)))))))

#;
(univ-define-prim "##fxarithmetic-shift?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^assign (^gvar "temp1") (^<< (^fixnum-unbox arg1)
                                      (^fixnum-unbox arg2)))
        (return
         (^if-expr (case (target-name (ctx-target ctx))
                    ((js)
                     (^= (^>> (^>> (^<< (^gvar "temp1") univ-tag-bits)
                                   univ-tag-bits)
                              (^fixnum-unbox arg2))
                         (^fixnum-unbox arg1)))
                    ((php python ruby)
                     (let ((sign-bit (- (- univ-word-bits univ-tag-bits)
                                        1)))
                        (^= (^gvar "temp1")
                            (^-
                             (^parens
                               (^bitand (^parens (^+ (^gvar "temp1")
                                                     (expt 2 sign-bit)))
                                        (- (expt 2 (+ 1 sign-bit)) 1)))
                             (expt 2 sign-bit))))))
                   (^fixnum-box (^gvar "temp1"))
                   (^boolean-box (^bool #f))))))))

(univ-define-prim "##fxwraparithmetic-shift-left" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
       (case (target-name (ctx-target ctx))
        ((js) 
         (^fixnum-box
          (^>> (^<< (^<< (^fixnum-unbox arg1)
                         (^fixnum-unbox arg2))
                    univ-tag-bits)
               univ-tag-bits)))
        ((php python ruby)
         (let ((sign-bit (- (- univ-word-bits univ-tag-bits) 1)))
           (^fixnum-box 
             (^- (^parens (^bitand
                           (^parens (^+ 
                                     (^parens (^<< (^fixnum-unbox arg1)
                                                   (^fixnum-unbox arg2)))
                                     (expt 2 sign-bit)))
                           (- (expt 2 (+ 1 sign-bit)) 1)))
                 (expt 2 sign-bit))))))))))

(univ-define-prim "##fxarithmetic-shift-left" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (^<< (^fixnum-unbox arg1)
                        (^fixnum-unbox arg2)))))))

(univ-define-prim "##fxarithmetic-shift-left?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^assign (^gvar "temp1") (^<< (^fixnum-unbox arg1)
                                      (^fixnum-unbox arg2)))
        (return
         (^if-expr (case (target-name (ctx-target ctx))
                    ((js)
                     (^= (^>> (^>> (^<< (^gvar "temp1") univ-tag-bits)
                                   univ-tag-bits)
                              (^fixnum-unbox arg2))
                         (^fixnum-unbox arg1)))
                    ((php python ruby)
                     (let ((sign-bit (- (- univ-word-bits univ-tag-bits)
                                        1)))
                        (^= (^gvar "temp1")
                            (^-
                             (^parens
                               (^bitand (^parens (^+ (^gvar "temp1")
                                                     (expt 2 sign-bit)))
                                        (- (expt 2 (+ 1 sign-bit)) 1)))
                             (expt 2 sign-bit))))))
                   (^fixnum-box (^gvar "temp1"))
                   (^boolean-box (^bool #f))))))))

(univ-define-prim "##fxarithmetic-shift-right" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (^>> (^fixnum-unbox arg1) (^fixnum-unbox arg2)))))))

(univ-define-prim "##fxarithmetic-shift-right?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (^>> (^fixnum-unbox arg1) (^fixnum-unbox arg2)))))))

#;
(univ-define-prim "##fxwraplogical-shift-right" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
       (case (target-name (ctx-target ctx))
        ((js)
         (^fixnum-box (^>>> (^parens (^<< (^fixnum-unbox arg1)
                                          univ-word-bits))
                            (^parens (^+ (^fixnum-unbox arg2)
                                         univ-word-bits)))))
        (else
         (let ((sign-bit (- (- univ-word-bits univ-tag-bits)
                            1)))
              (^-
               (^parens
                (^bitand (^parens (^+ (^>> (^fixnum-unbox arg1)
                                           (^fixnum-unbox arg2))
                                      (expt 2 sign-bit)))
                         (- (expt 2 (+ 1 sign-bit)) 1)))
               (expt 2 sign-bit)))))))))

#;
(univ-define-prim "##fxwraplogical-shift-right?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
       (case (target-name (ctx-target ctx))
        ((js)
         (^fixnum-box (^>>> (^<< (^fixnum-unbox arg1) univ-word-bits)
                            (^parens (^fixnum-unbox arg2)))))
        (else
         (^fixnum-box (^>> (^fixnum-unbox arg1)
                           (^fixnum-unbox arg2)))))))))

(univ-define-prim "##fxwrapabs" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
    (return 
      (^if-expr (^>= (^fixnum-unbox arg) (^int 0))
                arg
                (^if-expr (^= (^fixnum-unbox arg) (^int univ-fixnum-min))
                          arg
                          (^fixnum-box (^- (^fixnum-unbox arg)))))))))

(univ-define-prim "##fxabs" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
    (return 
      (^if-expr (^>= (^fixnum-unbox arg) (^int 0))
                arg
                (^fixnum-box (^- (^fixnum-unbox arg))))))))

(univ-define-prim "##fxabs?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
    (return 
      (^if-expr (^>= (^fixnum-unbox arg) (^int 0))
                arg
                (^if-expr (^= (^fixnum-unbox arg) (^int univ-fixnum-min))
                          (^obj #f)
                          (^fixnum-box (^- (^fixnum-unbox arg)))))))))

(univ-define-prim-bool "##fxzero?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^= (^fixnum-unbox arg1) (^int 0))))))

(univ-define-prim-bool "##fxpositive?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^> (^fixnum-unbox arg1) (^int 0))))))

(univ-define-prim-bool "##fxnegative?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^< (^fixnum-unbox arg1) (^int 0))))))

(univ-define-prim-bool "##fxodd?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^= (^parens (^bitand (^fixnum-unbox arg1) (^int 1)))
                 (^int 1))))))

(univ-define-prim-bool "##fxeven?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^= (^parens (^bitand (^fixnum-unbox arg1) (^int 1)))
                 (^int 0))))))

(univ-define-prim-bool "##fx=" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^= arg1 arg2))
   univ-emit-fixnum-unbox))

(univ-define-prim-bool "##fx<" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^< arg1 arg2))
   univ-emit-fixnum-unbox))

(univ-define-prim-bool "##fx>" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^> arg1 arg2))
   univ-emit-fixnum-unbox))

(univ-define-prim-bool "##fx<=" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^<= arg1 arg2))
   univ-emit-fixnum-unbox))

(univ-define-prim-bool "##fx>=" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^>= arg1 arg2))
   univ-emit-fixnum-unbox))

(univ-define-prim "##integer->char" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^char-box (^chr-fromint (^fixnum-unbox arg)))))))

(univ-define-prim "##char->integer" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^chr-toint (^char-unbox arg)))))))

;;TODO: ("##flonum->fixnum"              (1)   #f ()    0    fixnum  extended)
;;TODO: ("##fixnum->flonum"              (1)   #f ()    0    real    extended)
;;TODO: ("##fixnum->flonum-exact?"       (1)   #f ()    0    boolean extended)

(univ-define-prim "##flonum->fixnum" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^float-toint (^flonum-unbox arg)))))))

(univ-define-prim "##fixnum->flonum" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-fromint (^fixnum-unbox arg)))))))

;;TODO: make variadic, complete, clean up and test
(univ-define-prim "##flmax" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^if-expr (^> (^flonum-unbox arg1) (^flonum-unbox arg2))
                       arg1
                       arg2)))))

;;TODO: make variadic, complete, clean up and test
(univ-define-prim "##flmin" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^if-expr (^< (^flonum-unbox arg1) (^flonum-unbox arg2))
                       arg1
                       arg2)))))

(univ-define-prim "##fl+" #f
  (univ-fold-left
   (lambda (ctx)           (^float targ-inexact-+0))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^+ arg1 arg2))
   univ-emit-flonum-unbox
   univ-emit-flonum-box))

(univ-define-prim "##fl*" #f
  (univ-fold-left
   (lambda (ctx)           (^float targ-inexact-+1))
   (lambda (ctx arg1)      arg1)
   (lambda (ctx arg1 arg2) (^* arg1 arg2))
   univ-emit-flonum-unbox
   univ-emit-flonum-box))

(univ-define-prim "##fl-" #f
  (univ-fold-left
   #f ;; 0 arguments impossible
   (lambda (ctx arg1)      (^- arg1))
   (lambda (ctx arg1 arg2) (^- arg1 arg2))
   univ-emit-flonum-unbox
   univ-emit-flonum-box))

(univ-define-prim "##fl/" #f
  (univ-fold-left
   #f ;; 0 arguments impossible
   (lambda (ctx arg1)      (univ-ieee/ ctx (^float targ-inexact-+1) arg1))
   (lambda (ctx arg1 arg2) (univ-ieee/ ctx arg1 arg2))
   univ-emit-flonum-unbox
   univ-emit-flonum-box))

(define (univ-ieee/ ctx arg1 arg2)
  (case (target-name (ctx-target ctx))

    ((python)
     ;;TODO: cleanup the Python code
     (^if-expr (^= arg2 (^float targ-inexact-+0))
               (^if-expr (^= arg1 (^float targ-inexact-+0))
                         "float('nan')"
                         (^ "math.copysign(float('inf')," (^* arg1 arg2) ")"))
               (^/ arg1 arg2)))

    ((php)
     ;;TODO: cleanup the PHP code
     (^if-expr (^= arg2 (^float targ-inexact-+0))
               (^if-expr (^= arg1 (^float targ-inexact-+0))
                         "NAN"
                         (^if-expr (^eq? (^call-prim "strval" (^* arg1 (^float targ-inexact-+0)))
                                         (^call-prim "strval" arg2))
                                   "INF"
                                   "-INF"))
               (^/ arg1 arg2)))

    (else
     (^/ arg1 arg2))))

(univ-define-prim "##flabs" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-abs (^flonum-unbox arg)))))))

(univ-define-prim "##flfloor" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-floor (^flonum-unbox arg)))))))

(univ-define-prim "##flceiling" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-ceiling (^flonum-unbox arg)))))))

(univ-define-prim "##fltruncate" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-truncate (^flonum-unbox arg)))))))

(univ-define-prim "##flround" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-round-half-to-even (^flonum-unbox arg)))))))

(univ-define-prim "##flexp" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-exp (^flonum-unbox arg)))))))

(univ-define-prim "##fllog" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-log (^flonum-unbox arg)))))))

(univ-define-prim "##flsin" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-sin (^flonum-unbox arg)))))))

(univ-define-prim "##flcos" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-cos (^flonum-unbox arg)))))))

(univ-define-prim "##fltan" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-tan (^flonum-unbox arg)))))))

(univ-define-prim "##flasin" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-asin (^flonum-unbox arg)))))))

(univ-define-prim "##flacos" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-acos (^flonum-unbox arg)))))))

(univ-define-prim "##flatan" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^flonum-box
       (if arg2
           (^float-atan2 (^flonum-unbox arg1) (^flonum-unbox arg2))
           (^float-atan (^flonum-unbox arg1))))))))

(univ-define-prim "##flexpt" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^flonum-box (^float-expt (^flonum-unbox arg1) (^flonum-unbox arg2)))))))

(univ-define-prim "##flsqrt" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-sqrt (^flonum-unbox arg)))))))

(univ-define-prim "##flcopysign" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     ;;TODO: implement for other languages
     (return
      (^if-expr (^eq? (^parens
                       (^or (^parens (^< (^flonum-unbox arg1)
                                         (^float 0.0)))
                            (^parens (^< (^/ (^float 1.0) (^flonum-unbox arg1))
                                         (^float 0.0)))))
                      (^parens
                       (^or (^parens (^< (^flonum-unbox arg2)
                                         (^float 0.0)))
                            (^parens (^< (^/ (^float 1.0) (^flonum-unbox arg2))
                                         (^float 0.0))))))
                arg1
                (^flonum-box (^- (^flonum-unbox arg1))))))))

(univ-define-prim-bool "##flinteger?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^float-integer? (^flonum-unbox arg))))))

(univ-define-prim-bool "##flzero?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^= (^flonum-unbox arg) (^float targ-inexact-+0))))))

(univ-define-prim-bool "##flpositive?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^> (^flonum-unbox arg) (^float targ-inexact-+0))))))

(univ-define-prim-bool "##flnegative?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^< (^flonum-unbox arg) (^float targ-inexact-+0))))))

(univ-define-prim-bool "##flodd?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^&& (^float-integer? (^flonum-unbox arg))
                  (^!= (^flonum-unbox arg)
                       (^* (^float targ-inexact-+2)
                           (^float-floor
                            (^parens (^* (^float targ-inexact-+1/2)
                                         (^flonum-unbox arg)))))))))))

(univ-define-prim-bool "##fleven?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^&& (^float-integer? (^flonum-unbox arg))
                  (^= (^flonum-unbox arg)
                      (^* (^float targ-inexact-+2)
                          (^float-floor
                           (^parens (^* (^float targ-inexact-+1/2)
                                        (^flonum-unbox arg)))))))))))

(univ-define-prim-bool "##flfinite?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^float-finite? (^flonum-unbox arg))))))

(univ-define-prim-bool "##flinfinite?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^float-infinite? (^flonum-unbox arg))))))

(univ-define-prim-bool "##flnan?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^float-nan? (^flonum-unbox arg))))))

(univ-define-prim-bool "##fl<-fx-exact?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^bool #t)))))

(univ-define-prim-bool "##fl=" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^= arg1 arg2))
   univ-emit-flonum-unbox))

(univ-define-prim-bool "##fl<" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^< arg1 arg2))
   univ-emit-flonum-unbox))

(univ-define-prim-bool "##fl>" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^> arg1 arg2))
   univ-emit-flonum-unbox))

(univ-define-prim-bool "##fl<=" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^<= arg1 arg2))
   univ-emit-flonum-unbox))

(univ-define-prim-bool "##fl>=" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^>= arg1 arg2))
   univ-emit-flonum-unbox))

(univ-define-prim-bool "##char=?" #f
  ;;TODO: implement as eq? if chars are interned
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^= arg1 arg2))
   univ-emit-char-unbox))

(univ-define-prim-bool "##char<?" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^< arg1 arg2))
   univ-emit-char-unbox))

(univ-define-prim-bool "##char>?" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^> arg1 arg2))
   univ-emit-char-unbox))

(univ-define-prim-bool "##char<=?" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^<= arg1 arg2))
   univ-emit-char-unbox))

(univ-define-prim-bool "##char>=?" #f
  (univ-fold-left-compare
   (lambda (ctx)           (^bool #t))
   (lambda (ctx arg1)      (^bool #t))
   (lambda (ctx arg1 arg2) (^>= arg1 arg2))
   univ-emit-char-unbox))

;;TODO: ("##char-alphabetic?"             (1)   #f ()    0    boolean extended)
;;TODO: ("##char-numeric?"                (1)   #f ()    0    boolean extended)
;;TODO: ("##char-whitespace?"             (1)   #f ()    0    boolean extended)
;;TODO: ("##char-upper-case?"             (1)   #f ()    0    boolean extended)
;;TODO: ("##char-lower-case?"             (1)   #f ()    0    boolean extended)
;;TODO: ("##char-upcase"                  (1)   #f ()    0    char    extended)
;;TODO: ("##char-downcase"                (1)   #f ()    0    char    extended)

(univ-define-prim "##cons" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^cons arg1 arg2)))))

(univ-define-prim "##set-car!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^setcar arg1 arg2)
        (return arg1)))))

(univ-define-prim "##set-cdr!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^setcdr arg1 arg2)
        (return arg1)))))

(define (univ-cxxxxr-init)
  (let cxxxxr-loop ((n #b10))
    (if (<= n #b11111)
        (let ()

          (define (ad-name prefix x)
            (if (>= x #b10)
                (string-append (ad-name prefix (quotient x 2))
                               (string (string-ref "ad" (modulo x 2))))
                prefix))

          (univ-define-prim (string-append (ad-name "##c" n) "r") #f
            (make-translated-operand-generator
             (lambda (ctx return arg)

               (define (ad-expr expr x)
                 (if (>= x #b10)
                     (ad-expr (if (= (modulo x 2) 0)
                                  (^getcar expr)
                                  (^getcdr expr))
                              (quotient x 2))
                     expr))

               (return (ad-expr arg n)))))

          (cxxxxr-loop (+ n 1))))))

(univ-cxxxxr-init)

(univ-define-prim "##list" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (let loop ((lst (reverse args))
                (result (^obj '())))
       (if (pair? lst)
           (loop (cdr lst)
                 (^cons (car lst)
                        result))
           (return result))))))

;; TODO: test box primitives

(univ-define-prim "##box" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^box arg1)))))

(univ-define-prim "##unbox" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^unbox arg1)))))

(univ-define-prim "##set-box!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^setbox arg1 arg2)
        (return arg1)))))

;;TODO: ("##make-will"                    (2)   #t ()    0    #f      extended)
;;TODO: ("##will-testator"                (1)   #f ()    0    (#f)    extended)

;;TODO: ("##gc-hash-table-ref"            (2)   #f ()    0    (#f)    extended)
;;TODO: ("##gc-hash-table-set!"           (3)   #t ()    0    (#f)    extended)
;;TODO: ("##gc-hash-table-rehash!"        (2)   #t ()    0    (#f)    extended)

;;TODO: ("##values"                       0     #f ()    0    (#f)    extended)

(univ-define-prim "##vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return (^vector-box (^array-literal args))))))

(univ-define-prim "##make-vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^prefix (univ-use-rtlib ctx 'make_vector))
       (^fixnum-unbox arg1)
       (if arg2
           arg2
           (^fixnum-box (^int 0))))))))

(univ-define-prim "##vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^vector-length arg))))))

(univ-define-prim "##vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^vector-ref arg1
                          (^fixnum-unbox arg2))))))

(univ-define-prim "##vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^vector-set! arg1
                      (^fixnum-unbox arg2)
                      arg3)
        (return arg1)))))

(univ-define-prim "##vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^vector-shrink! arg1
                         (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim "##u8vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return (^u8vector-box (^array-literal args))))))

(univ-define-prim "##make-u8vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^prefix (univ-use-rtlib ctx 'make_u8vector))
       (^fixnum-unbox arg1)
       (if arg2
           arg2
           (^fixnum-box (^int 0))))))))

(univ-define-prim "##u8vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^u8vector-length arg))))))

(univ-define-prim "##u8vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^u8vector-ref arg1
                            (^fixnum-unbox arg2))))))

(univ-define-prim "##u8vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^u8vector-set! arg1
                        (^fixnum-unbox arg2)
                        arg3)
        (return arg1)))))

(univ-define-prim "##u8vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^u8vector-shrink! arg1
                           (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim "##u16vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return (^u16vector-box (^array-literal args))))))

(univ-define-prim "##make-u16vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^prefix (univ-use-rtlib ctx 'make_u16vector))
       (^fixnum-unbox arg1)
       (if arg2
           arg2
           (^fixnum-box (^int 0))))))))

(univ-define-prim "##u16vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^u16vector-length arg))))))

(univ-define-prim "##u16vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^u16vector-ref arg1
                             (^fixnum-unbox arg2))))))

(univ-define-prim "##u16vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^u16vector-set! arg1
                         (^fixnum-unbox arg2)
                         arg3)
        (return arg1)))))

(univ-define-prim "##u16vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^u16vector-shrink! arg1
                            (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim "##f64vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return (^f64vector-box (^array-literal args))))))

(univ-define-prim "##make-f64vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^prefix (univ-use-rtlib ctx 'make_f64vector))
       (^fixnum-unbox arg1)
       (if arg2
           arg2
           (^fixnum-box (^int 0))))))))

(univ-define-prim "##f64vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^f64vector-length arg))))))

(univ-define-prim "##f64vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^f64vector-ref arg1
                             (^fixnum-unbox arg2))))))

(univ-define-prim "##f64vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^f64vector-set! arg1
                         (^fixnum-unbox arg2)
                         arg3)
        (return arg1)))))

(univ-define-prim "##f64vector-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^f64vector-shrink! arg1
                            (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim "##string" #f
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^string-box (^array-literal (map (lambda (x) (^char-unbox x)) args)))))))

(univ-define-prim "##make-string" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^prefix (univ-use-rtlib ctx 'make_string))
       (^fixnum-unbox arg1)
       (if arg2
           (^char-unbox arg2)
           (^chr-fromint 0)))))))

(univ-define-prim "##string-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^string-length arg))))))

(univ-define-prim "##string-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^char-box (^string-ref (^string-unbox arg1)
                                     (^fixnum-unbox arg2)))))))

(univ-define-prim "##string-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^string-set! (^string-unbox arg1)
                      (^fixnum-unbox arg2)
                      (^char-unbox arg3))
        (return arg1)))))

(univ-define-prim "##string-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^string-shrink! arg1
                         (^fixnum-unbox arg2))
        (return arg1)))))

;;TODO: ("##s8vector"                     0     #f ()    0    #f      extended)
;;TODO: ("##make-s8vector"                (2)   #f ()    0    #f      extended)
;;TODO: ("##s8vector-length"              (1)   #f ()    0    fixnum  extended)
;;TODO: ("##s8vector-ref"                 (2)   #f ()    0    fixnum  extended)
;;TODO: ("##s8vector-set!"                (3)   #t ()    0    #f      extended)
;;TODO: ("##s8vector-shrink!"             (2)   #t ()    0    #f      extended)

;;TODO: ("##u8vector"                     0     #f ()    0    #f      extended)
;;TODO: ("##make-u8vector"                (2)   #f ()    0    #f      extended)
;;TODO: ("##u8vector-length"              (1)   #f ()    0    fixnum  extended)
;;TODO: ("##u8vector-ref"                 (2)   #f ()    0    fixnum  extended)
;;TODO: ("##u8vector-set!"                (3)   #t ()    0    #f      extended)
;;TODO: ("##u8vector-shrink!"             (2)   #t ()    0    #f      extended)

;;TODO: ("##s16vector"                    0     #f ()    0    #f      extended)
;;TODO: ("##make-s16vector"               (2)   #f ()    0    #f      extended)
;;TODO: ("##s16vector-length"             (1)   #f ()    0    fixnum  extended)
;;TODO: ("##s16vector-ref"                (2)   #f ()    0    fixnum  extended)
;;TODO: ("##s16vector-set!"               (3)   #t ()    0    #f      extended)
;;TODO: ("##s16vector-shrink!"            (2)   #t ()    0    #f      extended)

;;TODO: ("##u16vector"                    0     #f ()    0    #f      extended)
;;TODO: ("##make-u16vector"               (2)   #f ()    0    #f      extended)
;;TODO: ("##u16vector-length"             (1)   #f ()    0    fixnum  extended)
;;TODO: ("##u16vector-ref"                (2)   #f ()    0    fixnum  extended)
;;TODO: ("##u16vector-set!"               (3)   #t ()    0    #f      extended)
;;TODO: ("##u16vector-shrink!"            (2)   #t ()    0    #f      extended)

;;TODO: ("##s32vector"                    0     #f ()    0    #f      extended)
;;TODO: ("##make-s32vector"               (2)   #f ()    0    #f      extended)
;;TODO: ("##s32vector-length"             (1)   #f ()    0    fixnum  extended)
;;TODO: ("##s32vector-ref"                (2)   #f ()    0    fixnum  extended)
;;TODO: ("##s32vector-set!"               (3)   #t ()    0    #f      extended)
;;TODO: ("##s32vector-shrink!"            (2)   #t ()    0    #f      extended)

;;TODO: ("##u32vector"                    0     #f ()    0    #f      extended)
;;TODO: ("##make-u32vector"               (2)   #f ()    0    #f      extended)
;;TODO: ("##u32vector-length"             (1)   #f ()    0    fixnum  extended)
;;TODO: ("##u32vector-ref"                (2)   #f ()    0    fixnum  extended)
;;TODO: ("##u32vector-set!"               (3)   #t ()    0    #f      extended)
;;TODO: ("##u32vector-shrink!"            (2)   #t ()    0    #f      extended)

;;TODO: ("##s64vector"                    0     #f ()    0    #f      extended)
;;TODO: ("##make-s64vector"               (2)   #f ()    0    #f      extended)
;;TODO: ("##s64vector-length"             (1)   #f ()    0    fixnum  extended)
;;TODO: ("##s64vector-ref"                (2)   #f ()    0    fixnum  extended)
;;TODO: ("##s64vector-set!"               (3)   #t ()    0    #f      extended)
;;TODO: ("##s64vector-shrink!"            (2)   #t ()    0    #f      extended)

;;TODO: ("##u64vector"                    0     #f ()    0    #f      extended)
;;TODO: ("##make-u64vector"               (2)   #f ()    0    #f      extended)
;;TODO: ("##u64vector-length"             (1)   #f ()    0    fixnum  extended)
;;TODO: ("##u64vector-ref"                (2)   #f ()    0    fixnum  extended)
;;TODO: ("##u64vector-set!"               (3)   #t ()    0    #f      extended)
;;TODO: ("##u64vector-shrink!"            (2)   #t ()    0    #f      extended)

;;TODO: ("##f32vector"                    0     #f ()    0    #f      extended)
;;TODO: ("##make-f32vector"               (2)   #f ()    0    #f      extended)
;;TODO: ("##f32vector-length"             (1)   #f ()    0    fixnum  extended)
;;TODO: ("##f32vector-ref"                (2)   #f ()    0    real    extended)
;;TODO: ("##f32vector-set!"               (3)   #t ()    0    #f      extended)
;;TODO: ("##f32vector-shrink!"            (2)   #t ()    0    #f      extended)

;;TODO: ("##f64vector"                    0     #f ()    0    #f      extended)
;;TODO: ("##make-f64vector"               (2)   #f ()    0    #f      extended)
;;TODO: ("##f64vector-length"             (1)   #f ()    0    fixnum  extended)
;;TODO: ("##f64vector-ref"                (2)   #f ()    0    real    extended)
;;TODO: ("##f64vector-set!"               (3)   #t ()    0    #f      extended)
;;TODO: ("##f64vector-shrink!"            (2)   #t ()    0    #f      extended)

;;TODO: ("##structure-direct-instance-of?"(2)   #f ()    0    boolean extended)

(univ-define-prim-bool "##structure-direct-instance-of?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^&& (^structure? arg1)
                  (^eq? (^structure-ref (^structure-ref arg1 0) 1) arg2))))))

;;TODO: ("##structure-instance-of?"       (2)   #f ()    0    boolean extended)
;;TODO: ("##structure-type"               (1)   #f ()    0    (#f)    extended)
;;TODO: ("##structure-type-set!"          (2)   #t ()    0    (#f)    extended)

(univ-define-prim "##structure-type" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^structure-ref arg1 0)))))

(univ-define-prim "##structure-type-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^structure-set! arg1 0 arg2)
        (return arg1)))))

(univ-define-prim "##structure" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return (^structure-box (^array-literal args))))))

;;TODO: ("##structure-ref"                (4)   #f ()    0    (#f)    extended)
;;TODO: ("##structure-set!"               (5)   #t ()    0    (#f)    extended)
;;TODO: ("##direct-structure-ref"         (4)   #f ()    0    (#f)    extended)
;;TODO: ("##direct-structure-set!"        (5)   #t ()    0    (#f)    extended)

(univ-define-prim "##unchecked-structure-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (return (^structure-ref arg1
                             (^fixnum-unbox arg2))))))

(univ-define-prim "##unchecked-structure-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5)
     (^ (^structure-set! arg1
                         (^fixnum-unbox arg3)
                         arg2)
        (return arg1)))))

;;TODO: ("##type-id"                      (1)   #f ()    0    #f      extended)
;;TODO: ("##type-name"                    (1)   #f ()    0    #f      extended)
;;TODO: ("##type-flags"                   (1)   #f ()    0    #f      extended)
;;TODO: ("##type-super"                   (1)   #f ()    0    #f      extended)
;;TODO: ("##type-fields"                  (1)   #f ()    0    #f      extended)

;; TODO: test ##symbol->string primitive and ##string->symbol primitive

(univ-define-prim "##symbol->string" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^string-box (^strtocodes (^symbol-unbox arg1)))))))

(univ-define-prim "##string->symbol" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^symbol-box (^tostr arg1))))))

;; TODO: test ##keyword->string primitive and ##string->keyword primitive

(univ-define-prim "##keyword->string" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^string-box (^strtocodes (^keyword-unbox arg1)))))))

(univ-define-prim "##string->keyword" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^keyword-box (^tostr arg1))))))

;;TODO: ("##closure-length"               (1)   #f ()    0    fixnum  extended)
;;TODO: ("##closure-code"                 (1)   #f ()    0    #f      extended)
;;TODO: ("##closure-ref"                  (2)   #f ()    0    (#f)    extended)
;;TODO: ("##closure-set!"                 (3)   #t ()    0    #f      extended)

(univ-define-prim "##closure-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^closure-length arg))))))

(univ-define-prim "##closure-code" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^closure-code arg)))))

(univ-define-prim "##closure-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^closure-ref arg1
                           (^fixnum-unbox arg2))))))

(univ-define-prim "##closure-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^closure-set! arg1
                       (^fixnum-unbox arg2)
                       arg3)
        (return arg1)))))

(univ-define-prim "##make-subprocedure" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (univ-call-with-fn-attrib
      ctx
      arg1
      "subprocedures"
      (lambda (subprocs)
        (return (^array-index subprocs (^fixnum-unbox arg2))))))))

(univ-define-prim "##subprocedure-id" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-call-with-fn-attrib
      ctx
      arg1
      "id"
      (lambda (result)
        (return (^fixnum-box result)))))))

(univ-define-prim "##subprocedure-parent" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-call-with-fn-attrib
      ctx
      arg1
      "parent"
      return))))

(univ-define-prim "##subprocedure-nb-parameters" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-call-with-fn-attrib
      ctx
      arg1
      "nb_parameters"
      (lambda (result)
        (return (^fixnum-box result)))))))

(univ-define-prim "##subprocedure-nb-closed" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-call-with-fn-attrib
      ctx
      arg1
      "nb_closed"
      (lambda (result)
        (return (^fixnum-box result)))))))

(univ-define-prim "##subprocedure-parent-name" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-call-with-fn-attrib
      ctx
      arg1
      "proc_name"
      return))))

(univ-define-prim "##subprocedure-parent-info" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-call-with-fn-attrib
      ctx
      arg1
      "info"
      return))))

;;TODO: ("##make-promise"                 (1)   #f 0     0    (#f)    extended)
;;TODO: ("##force"                        (1)   #t 0     0    #f      extended)

(univ-define-prim "##void" #t
  (make-translated-operand-generator
   (lambda (ctx return)
     (return (^void)))))

(univ-define-prim "##current-thread" #t
  (make-translated-operand-generator
   (lambda (ctx return)
     (return (^gvar "current_thread")))))

;;TODO: ("##run-queue"                    (0)   #f ()    0    #f      extended)

;;TODO: ("##thread-save!"                 1     #t ()    1113 (#f)    extended)
;;TODO: ("##thread-restore!"              2     #t ()    2203 #f      extended)

;;TODO: ("##continuation-capture"         1     #t ()    1113 (#f)    extended)
;;TODO: ("##continuation-graft"           2     #t ()    2203 #f      extended)
;;TODO: ("##continuation-graft-no-winding" 2     #t ()    2203 #f      extended)
;;TODO: ("##continuation-return"           (2)   #t ()    0    #f      extended)
;;TODO: ("##continuation-return-no-winding"(2)   #t ()    0    #f      extended)

(univ-define-prim "##continuation-frame" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^member arg1 "frame")))))

(univ-define-prim "##continuation-denv" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^member arg1 "denv")))))

(univ-define-prim "##continuation-next" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^call-prim
       (^prefix (univ-use-rtlib ctx 'continuation_next))
       arg1)))))

(univ-define-prim "##frame-ret" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^array-index arg1 0)))))

(define (univ-get-frame-field name)
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (^ (^var-declaration
         (^local-var "frame")
         (^array-index arg1 0))
        (univ-with-function-attribs
         ctx
         #f
         "frame"
         (lambda ()
           (return
            (^fixnum-box (univ-get-function-attrib ctx "frame" name)))))))))

(univ-define-prim "##frame-fs"   #f (univ-get-frame-field "fs"))
(univ-define-prim "##frame-link" #f (univ-get-frame-field "link"))

(univ-define-prim "##frame-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^array-index arg1
                           (^fixnum-unbox arg2))))))

(univ-define-prim "##frame-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^assign
         (^array-index arg1 (^fixnum-unbox arg2))
         arg3)
        (return arg1)))))

(univ-define-prim "##apply" #f

  #f
  #f

  (lambda (ctx nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      nb-args
                      2
                      5
                      poll?
                      safe?
                      fs
                      "apply")))

;;TODO: ("##call-with-current-continuation"1     #t ()    1113 (#f)    extended)

(univ-define-prim "##make-global-var" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^call-prim
       (^prefix (univ-use-rtlib ctx 'make_glo_var))
       arg1)))))

(univ-define-prim "##global-var-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^glo-var-ref arg1)))))

(univ-define-prim "##global-var-primitive-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^glo-var-primitive-ref arg1)))))

(univ-define-prim "##global-var-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^glo-var-set! arg1 arg2)
        (return arg1)))))

(univ-define-prim "##global-var-primitive-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^glo-var-primitive-set! arg1 arg2)
        (return arg1)))))

(univ-define-prim "##first-argument" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1 . rest)
     (return arg1))))

(univ-define-prim "##check-heap-limit" #t
  (make-translated-operand-generator
   (lambda (ctx return)
     (return (^void)))))

;;TODO: ("##quasi-append"                  0     #f 0     0    list    extended)
;;TODO: ("##quasi-list"                    0     #f ()    0    list    extended)
;;TODO: ("##quasi-cons"                    (2)   #f ()    0    pair    extended)
;;TODO: ("##quasi-list->vector"            (1)   #f 0     0    vector  extended)
;;TODO: ("##quasi-vector"                  0     #f ()    0    vector  extended)
;;TODO: ("##case-memv"                     (2)   #f 0     0    list    extended)

(univ-define-prim-bool "##bignum.negative?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^> (^array-index (^member arg1 "digits")
                        (^- (^array-length (^member arg1 "digits")) (^int 1)))
          (^int 8191)))))) ;;TODO: adjust for digit size

(univ-define-prim "##bignum.adigit-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^fixnum-box (^array-length (^member arg1 "digits")))))))

(univ-define-prim "##bignum.adigit-inc!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^assign (^gvar "temp1")
                 (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2)))
        (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^bitand (^parens (^+ (^gvar "temp1") (^int 1)))
                          (^int 16383)))
        (return
         (^if-expr (^= (^gvar "temp1")
                       (^int 16383))
                   (^obj 1)
                   (^obj 0)))))))

(univ-define-prim "##bignum.adigit-dec!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^assign (^gvar "temp1")
                 (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2)))
        (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^bitand (^parens (^- (^gvar "temp1") (^int 1)))
                          (^int 16383)))
        (return
         (^if-expr (^= (^gvar "temp1")
                       (^int 0))
                   (^obj 1)
                   (^obj 0)))))))

(univ-define-prim "##bignum.adigit-add!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5)
     (^ (^assign (^gvar "temp1")
                 (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2)))
        (^assign (^gvar "temp2")
                 (^bitand (^parens (^+ (^+ (^gvar "temp1")
                                           (^array-index (^member arg3 "digits")
                                                         (^fixnum-unbox arg4)))
                                       (^fixnum-unbox arg5)))
                          (^int 16383)))
        (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^gvar "temp2"))
        (return
         (^if-expr (^< (^gvar "temp2")
                       (^+ (^gvar "temp1") (^fixnum-unbox arg5)))
                   (^obj 1)
                   (^obj 0)))))))

(univ-define-prim "##bignum.adigit-sub!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5)
     (^ (^assign (^gvar "temp1")
                 (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2)))
        (^assign (^gvar "temp2")
                 (^bitand (^parens (^- (^- (^gvar "temp1")
                                           (^array-index (^member arg3 "digits")
                                                         (^fixnum-unbox arg4)))
                                       (^fixnum-unbox arg5)))
                          (^int 16383)))
        (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^gvar "temp2"))
        (return
         (^if-expr (^> (^gvar "temp2")
                       (^- (^gvar "temp1") (^fixnum-unbox arg5)))
                   (^obj 1)
                   (^obj 0)))))))

(univ-define-prim "##bignum.mdigit-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^fixnum-box (^array-length (^member arg1 "digits")))))))

(univ-define-prim "##bignum.mdigit-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (^array-index (^member arg1 "digits")
                                 (^fixnum-unbox arg2)))))))

(univ-define-prim "##bignum.mdigit-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^fixnum-unbox arg3))
        (return arg1)))))

(univ-define-prim "##bignum.mdigit-mul!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5 arg6)
     (^ (^assign (^gvar "temp1")
                 (^+ (^+ (^array-index (^member arg1 "digits")
                                       (^fixnum-unbox arg2))
                         (^* (^array-index (^member arg3 "digits")
                                           (^fixnum-unbox arg4))
                             (^fixnum-unbox arg5)))
                     (^fixnum-unbox arg6)))
        (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^bitand (^gvar "temp1")
                          (^int 16383)))
        (return
         (^fixnum-box (^>> (^gvar "temp1") (^int 14))))))))

(univ-define-prim "##bignum.mdigit-div!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5 arg6)
     (^ (^assign (^gvar "temp1")
                 (^+ (^- (^array-index (^member arg1 "digits")
                                       (^fixnum-unbox arg2))
                         (^* (^array-index (^member arg3 "digits")
                                           (^fixnum-unbox arg4))
                             (^fixnum-unbox arg5)))
                     (^fixnum-unbox arg6)))
        (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^bitand (^gvar "temp1")
                          (^int 16383)))
        (^assign (^gvar "temp1")
                 (^>> (^gvar "temp1") (^int 14)))
        (return
         (^fixnum-box
          (^if-expr (^> (^gvar "temp1") (^int 0))
                    (^- (^gvar "temp1") (^int 16384))
                    (^gvar "temp1"))))))))

(univ-define-prim "##bignum.mdigit-quotient" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (return
      (^fixnum-box (univ-fxquotient
                    ctx
                    (^parens
                     (^+ (^parens
                          (^<< (^array-index (^member arg1 "digits")
                                             (^fixnum-unbox arg2))
                               (^int 14)))
                         (^array-index (^member arg1 "digits")
                                       (^- (^fixnum-unbox arg2)
                                           (^int 1)))))
                    (^fixnum-unbox arg3)))))))

(univ-define-prim "##bignum.mdigit-remainder" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (return
      (^fixnum-box (^- (^parens
                        (^+ (^parens
                             (^<< (^array-index (^member arg1 "digits")
                                                (^fixnum-unbox arg2))
                                  (^int 14)))
                            (^array-index (^member arg1 "digits")
                                          (^- (^fixnum-unbox arg2)
                                              (^int 1)))))
                       (^* (^fixnum-unbox arg3)
                           (^fixnum-unbox arg4))))))))

(univ-define-prim-bool "##bignum.mdigit-test?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (return
      (^> (^* (^fixnum-unbox arg1)
              (^fixnum-unbox arg2))
          (^+ (^parens
               (^<< (^fixnum-unbox arg3)
                    (^int 14)))
              (^fixnum-unbox arg4)))))))

(univ-define-prim-bool "##bignum.adigit-ones?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^= (^array-index (^member arg1 "digits")
                        (^fixnum-unbox arg2))
          (^int 16383))))))

(univ-define-prim-bool "##bignum.adigit-zero?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^= (^array-index (^member arg1 "digits")
                        (^fixnum-unbox arg2))
          (^int 0))))))

(univ-define-prim-bool "##bignum.adigit-negative?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^> (^array-index (^member arg1 "digits")
                        (^fixnum-unbox arg2))
          (^int 8191))))))

(univ-define-prim-bool "##bignum.adigit-=" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (return
      (^= (^array-index (^member arg1 "digits")
                        (^fixnum-unbox arg3))
          (^array-index (^member arg2 "digits")
                        (^fixnum-unbox arg3)))))))

(univ-define-prim-bool "##bignum.adigit-<" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (return
      (^< (^array-index (^member arg1 "digits")
                        (^fixnum-unbox arg3))
          (^array-index (^member arg2 "digits")
                        (^fixnum-unbox arg3)))))))

(univ-define-prim "##bignum.make" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (return
      (^call-prim
       (^prefix (univ-use-rtlib ctx 'bignum_make))
       arg1
       arg2
       arg3)))))

(univ-define-prim "##fixnum->bignum" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^call-prim
       (^prefix (univ-use-rtlib ctx 'int2bignum))
       (^fixnum-unbox arg1))))))

(univ-define-prim "##bignum.adigit-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^array-shrink! (^member arg1 "digits")
                        (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-copy!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (^ (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^array-index (^member arg3 "digits")
                               (^fixnum-unbox arg4)))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-cat!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5 arg6 arg7)
     (^ (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^bitand
                  (^parens
                   (^+ (^parens
                        (^<< (^array-index (^member arg3 "digits")
                                           (^fixnum-unbox arg4))
                             (^fixnum-unbox arg7)))
                       (^parens
                        (^>> (^array-index (^member arg5 "digits")
                                           (^fixnum-unbox arg6))
                             (^- (^int 14)
                                 (^fixnum-unbox arg7))))))
                  16383))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-bitwise-and!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (^ (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^bitand (^array-index (^member arg1 "digits")
                                        (^fixnum-unbox arg2))
                          (^array-index (^member arg3 "digits")
                                        (^fixnum-unbox arg4))))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-bitwise-ior!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (^ (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^bitior (^array-index (^member arg1 "digits")
                                        (^fixnum-unbox arg2))
                          (^array-index (^member arg3 "digits")
                                        (^fixnum-unbox arg4))))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-bitwise-xor!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (^ (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^bitxor (^array-index (^member arg1 "digits")
                                        (^fixnum-unbox arg2))
                          (^array-index (^member arg3 "digits")
                                        (^fixnum-unbox arg4))))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-bitwise-not!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^assign (^array-index (^member arg1 "digits")
                               (^fixnum-unbox arg2))
                 (^bitnot (^array-index (^member arg1 "digits")
                                        (^fixnum-unbox arg2))))
        (return arg1)))))

;;----------------------------------------------------------------------------

;;TODO: clean up and integrate to above

(define (univ-expand-inline-host-code ctx str args)
  (let ((nb-args (length args))
        (len (string-length str)))
    (let loop1 ((start 0) (i 0))

      (define (done)
        (^ (substring str start len)))

      (if (< i len)
          (let ((c (string-ref str i)))
            (if (not (char=? c #\@))
                (loop1 start (+ i 1))
                (let loop2 ((j (+ i 1)))
                  (if (< j len)
                      (let ((c (string-ref str j)))
                        (cond ((char-numeric? c)
                               (loop2 (+ j 1)))
                              ((and (char=? c #\@)
                                    (> j (+ i 1)))
                               (let ((n
                                      (string->number
                                       (substring str (+ i 1) j))))
                                 (if (and (>= n 1) (<= n nb-args))
                                     (^ (substring str start i)
                                        (^getopnd (list-ref args (- n 1)))
                                        (loop1 (+ j 1) (+ j 1)))
                                     (loop1 start (+ j 1)))))
                              (else
                               (loop1 start (+ j 1)))))
                      (done)))))
          (done)))))

(univ-define-prim "##inline-host-statement" #t

  (lambda (ctx return opnds)
    (if (and (> (length opnds) 0)
             (obj? (car opnds))
             (string? (obj-val (car opnds))))
        (^ (univ-expand-inline-host-code ctx (obj-val (car opnds)) (cdr opnds))
           (return #f))
        (compiler-internal-error "##inline-host-statement requires a constant string argument"))))

(univ-define-prim "##inline-host-expression" #t

  (lambda (ctx return opnds)
    (if (and (> (length opnds) 0)
             (obj? (car opnds))
             (string? (obj-val (car opnds))))
        (return
         (univ-expand-inline-host-code ctx (obj-val (car opnds)) (cdr opnds)))
        (compiler-internal-error "##inline-host-expression requires a constant string argument"))))

(univ-define-prim "##inline-host-declaration" #t

  (lambda (ctx return opnds)
    (if (and (= (length opnds) 1)
             (obj? (car opnds))
             (string? (obj-val (car opnds))))
        (let ((decl (obj-val (car opnds))))
          (queue-put! (ctx-decls ctx) (^ decl "\n"))
          (return #f))
        (compiler-internal-error "##inline-host-declaration requires a constant string argument"))))

(univ-define-prim "##continuation-capture" #f

  #f
  #f

  (lambda (ctx nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      nb-args
                      1
                      4
                      poll?
                      safe?
                      fs
                      "continuation_capture")))

(univ-define-prim "##continuation-graft-no-winding" #f

  #f
  #f

  (lambda (ctx nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      nb-args
                      2
                      5
                      poll?
                      safe?
                      fs
                      "continuation_graft_no_winding")))

(univ-define-prim "##continuation-return-no-winding" #f

  #f
  #f

  (lambda (ctx nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      nb-args
                      2
                      2
                      poll?
                      safe?
                      fs
                      "continuation_return_no_winding")))

(define (univ-jump-inline ctx nb-args min-args max-args poll? safe? fs name)
  (and (>= nb-args min-args)
       (<= nb-args max-args)
       (with-stack-pointer-adjust
        ctx
        (+ fs
           (ctx-stack-base-offset ctx))
        (lambda (ctx)
          (let ((rtlib-name
                 (string->symbol
                  (string-append name (number->string nb-args)))))
            (^return-poll
             (^gvar (univ-use-rtlib ctx rtlib-name))
             poll?
             #t))))))

(univ-define-prim "##thread-save!" #f

  #f
  #f

  (lambda (ctx nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      nb-args
                      1
                      4
                      poll?
                      safe?
                      fs
                      "thread_save")))

(univ-define-prim "##thread-restore!" #f

  #f
  #f

  (lambda (ctx nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      nb-args
                      2
                      5
                      poll?
                      safe?
                      fs
                      "thread_restore")))

;;;============================================================================
