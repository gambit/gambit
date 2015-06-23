;;============================================================================

;;; File: "_t-univ.scm"

;;; Copyright (c) 2011-2015 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2012 by Eric Thivierge, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

(define deb #t)
(set! deb #f)
(define (tt tag . stuff) (if deb (list "/*{" tag "*/" stuff "/*}*/") stuff));;;;;;;;;;;;;;;;;;;;

(define univ-enable-jump-destination-inlining? #f)
(set! univ-enable-jump-destination-inlining? #t)

(define univ-dyn-load? #f)
(set! univ-dyn-load? #f)

(define (univ-get-representation-option ctx name)
  (let ((x (assq name (ctx-options ctx))))
    (and x (pair? (cdr x)) (cadr x))))

(define (univ-module-representation ctx)
  (or (univ-get-representation-option ctx 'repr-module)
      (case (target-name (ctx-target ctx))
        ((java)
         'class)
        (else
         'global))))

(define (univ-procedure-representation ctx)
  (or (univ-get-representation-option ctx 'repr-procedure)
      (case (target-name (ctx-target ctx))
        ((java)
         'class)
        ((php)
         (if (univ-php-pre53? ctx)
             'class
             'host))
        (else
         'host))))

(define (univ-frame-representation ctx)
  (or (univ-get-representation-option ctx 'repr-frame)
      (case (target-name (ctx-target ctx))
        ((java)
         'class)
        (else
         'host))))

(define (univ-null-representation ctx)
  (or (univ-get-representation-option ctx 'repr-null)
      (case (target-name (ctx-target ctx))
        ((js java)
         'host)
        (else
         'class))))

(define (univ-void-representation ctx)
  (or (univ-get-representation-option ctx 'repr-void)
      (case (target-name (ctx-target ctx))
        ((java)
         'class)
        (else
         'host))))

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
      (case (target-name (ctx-target ctx))
        ((java)
         'class)
        (else
         'host))))

(define (univ-char-representation ctx)
  'class)

(define (univ-fixnum-representation ctx)
  (or (univ-get-representation-option ctx 'repr-fixnum)
      (case (target-name (ctx-target ctx))
        ((java)
         'class)
        (else
         'host))))

(define (univ-flonum-representation ctx)
  (or (univ-get-representation-option ctx 'repr-flonum)
      'class))

(define (univ-vector-representation ctx)
  (or (univ-get-representation-option ctx 'repr-vector)
      (case (target-name (ctx-target ctx))
        ((php java)
         'class)
        (else
         'host))))

(define (univ-values-representation ctx)
  (or (univ-get-representation-option ctx 'repr-values)
      'class))

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

    ((js java)
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

(define (univ-proc-name-attrib ctx)
  (case (target-name (ctx-target ctx))

    ((js)
     '_name) ;; avoid clash with builtin "name" attribute of functions

    (else
     'name)))

(define univ-thread-cont-slot 5)
(define univ-thread-denv-slot 6)

(define (univ-php-pre53? ctx)
  (assq 'pre53 (ctx-options ctx)))

(define (univ-python-pre3? ctx)
  (assq 'pre3 (ctx-options ctx)))

(define (univ-always-return-jump? ctx)
  (assq 'always-return-jump (ctx-options ctx)))

(define (univ-never-return-jump? ctx)
  (assq 'never-return-jump (ctx-options ctx)))

(define (univ-stack-resizable? ctx)
  (case (target-name (ctx-target ctx))
    ((java) #f)
    (else   #t)))

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
    '((repr-module    symbol)
      (repr-procedure symbol)
      (repr-frame     symbol)
      (repr-null      symbol)
      (repr-void      symbol)
      (repr-boolean   symbol)
      (repr-fixnum    symbol)
      (repr-flonum    symbol)
      (repr-vector    symbol)
      (repr-values    symbol)
      (repr-string    symbol)
      (repr-symbol    symbol)
      (always-return-jump)
      (never-return-jump)))

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

(univ-setup 'js     '((".js"   . JavaScript))  '())
(univ-setup 'python '((".py"   . Python))      '((pre3)))
(univ-setup 'ruby   '((".rb"   . Ruby))        '())
(univ-setup 'php    '((".php"  . PHP))         '((pre53)))

(univ-setup 'java   '((".java" . Java))        '());; experimental...
;;(univ-setup 'c      '((".c"    . C))           '())
;;(univ-setup 'c++    '((".cc"   . C++))         '())
;;(univ-setup 'objc   '((".m"    . Objective-C)) '())

;;;----------------------------------------------------------------------------

;; Generation of textual target code.

(define (univ-indent . rest)
  (cons '$$indent$$ rest))

(define (univ-constant val)
  (univ-box val val))

(define (univ-box boxed unboxed)
  (list '$$box$$ boxed unboxed))

(define (univ-box? x)
  (and (pair? x)
       (eq? (car x) '$$box$$)))

(define (univ-unbox x)
  (and (univ-box? x)
       (cddr x)))

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
                       (if (or (> (- limit i) 1)
                               (not (char=? (string-ref x (- limit 1))
                                            #\newline)))
                           (indent))
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

(define-macro (^var-declaration type name #!optional (init #f))
  `(univ-emit-var-declaration ctx ,type ,name ,init))

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

(define-macro (^cast type-name expr)
  `(univ-emit-cast ctx ,type-name ,expr))

(define-macro (^cast* type-name expr)
  `(univ-emit-cast* ctx ,type-name ,expr))

(define-macro (^cast*-scmobj expr)
  `(univ-emit-cast*-scmobj ctx ,expr))

(define-macro (^seq expr1 expr2)
  `(univ-emit-seq ctx ,expr1 ,expr2))

(define-macro (^parens expr)
  `(univ-emit-parens ctx ,expr))

(define-macro (^parens-php expr)
  `(univ-emit-parens-php ctx ,expr))

(define-macro (^local-var name)
  `(univ-emit-local-var ctx ,name))

(define-macro (^global-var name)
  `(univ-emit-global-var ctx ,name))

(define-macro (^global-function name)
  `(univ-emit-global-function ctx ,name))

(define-macro (^this-mod-field name)
  `(univ-emit-this-mod-field ctx ,name))

(define-macro (^this-mod-method name)
  `(univ-emit-this-mod-method ctx ,name))

(define-macro (^this-mod-jumpable name)
  `(univ-emit-this-mod-jumpable ctx ,name))

(define-macro (^mod-field mod-name name)
  `(univ-emit-mod-field ctx ,mod-name ,name))

(define-macro (^mod-method mod-name name)
  `(univ-emit-mod-method ctx ,mod-name ,name))

(define-macro (^mod-jumpable mod-name name)
  `(univ-emit-mod-jumpable ctx ,mod-name ,name))

(define-macro (^mod-class mod-name name)
  `(univ-emit-mod-class ctx ,mod-name ,name))
    
(define-macro (^rts-field name)      `(univ-emit-rts-field ctx ,name))
(define-macro (^rts-field-ref name)  `(univ-emit-rts-field-ref ctx ,name))
(define-macro (^rts-field-use name)  `(univ-emit-rts-field-use ctx ,name))

(define-macro (^rts-method name)     `(univ-emit-rts-method ctx ,name))
(define-macro (^rts-method-ref name) `(univ-emit-rts-method-ref ctx ,name))
(define-macro (^rts-method-use name) `(univ-emit-rts-method-use ctx ,name))

(define-macro (^rts-class name)      `(univ-emit-rts-class ctx ,name))
(define-macro (^rts-class-ref name)  `(univ-emit-rts-class-ref ctx ,name))
(define-macro (^rts-class-use name)  `(univ-emit-rts-class-use ctx ,name))

(define-macro (^rts-jumpable-use name) `(univ-emit-rts-jumpable-use ctx ,name))
  
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

(define-macro (^array? expr)
  `(univ-emit-array? ctx ,expr))

(define-macro (^array-length expr)
  `(univ-emit-array-length ctx ,expr))

(define-macro (^array-shrink! expr1 expr2)
  `(univ-emit-array-shrink! ctx ,expr1 ,expr2))

(define-macro (^array-shrink-possibly-copy! expr1 expr2)
  `(univ-emit-array-shrink-possibly-copy! ctx ,expr1 ,expr2))

(define-macro (^move-array-to-array array1 srcpos array2 destpos len)
  `(univ-emit-move-array-to-array ctx ,array1 ,srcpos ,array2 ,destpos ,len))

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

(define-macro (^array-literal type elems)
  `(univ-emit-array-literal ctx ,type ,elems))

(define-macro (^extensible-array-literal type elems)
  `(univ-emit-extensible-array-literal ctx ,type ,elems))

(define-macro (^new-array type len)
  `(univ-emit-new-array ctx ,type ,len))

(define-macro (^make-array type return len init)
  `(univ-emit-make-array ctx ,type ,return ,len ,init))

(define-macro (^empty-dict)
  `(univ-emit-empty-dict ctx))

(define-macro (^call-prim expr . params)
  `(univ-emit-call-prim ctx ,expr ,@params))

(define-macro (^jump expr . params)
  `(univ-emit-jump ctx ,expr ,@params))

(define-macro (^apply expr params)
  `(univ-emit-apply ctx ,expr ,params))

(define-macro (^this)
  `(univ-emit-this ctx))

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

(define-macro (^var-decl var-descr)
  `(univ-emit-var-decl ctx ,var-descr))

(define-macro (^decl type name)
  `(univ-emit-decl ctx ,type ,name))

(define-macro (^type type)
  `(univ-emit-type ctx ,type))

(define-macro (^procedure-declaration
               global?
               proc-type
               root-name
               params
               header
               attribs
               body)
  `(univ-emit-procedure-declaration
    ctx
    ,global?
    ,proc-type
    ,root-name
    ,params
    ,attribs
    (univ-emit-fn-body ctx ,header (lambda (ctx) ,body))))

;;TODO: remove
(define-macro (^prim-function-declaration
               root-name
               result-type
               params
               header
               attribs
               body)
  `(univ-emit-function-declaration
    ctx
    #t
    ,root-name
    ,result-type
    ,params
    ,attribs
    (univ-emit-fn-body ctx ,header (lambda (ctx) ,body))
    #t))

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

(define-macro (^return-jump expr)
  `(univ-emit-return-jump ctx ,expr))

(define-macro (^return expr)
  `(univ-emit-return ctx ,expr))



(define-macro (^map fn array)
  `(univ-emit-map ctx ,fn ,array))

(define-macro (^call-with-arg-array fn vals)
  `(univ-emit-call-with-arg-array ctx ,fn ,vals))

;;
;; Host vs Scheme type correspondance
;;
;; ==============================
;; | Host	| Scheme	|
;; ==============================
;; | void	| void-obj	|
;; | null	| null-obj	|
;; | bool	| boolean	|
;; | int	| fixnum	|
;; | float	| flonum	|
;; | str	| string	|
;; | array      |               |
;; | object     |               |
;; |            | list          |
;; | proc	| procedure	|
;; ==============================
;;

(define-macro (^null)
  `(univ-emit-null ctx))

(define-macro (^null? expr)
  `(univ-emit-null? ctx ,expr))

(define-macro (^null-obj)
  `(univ-emit-null-obj ctx))

(define-macro (^null-obj? expr)
  `(univ-emit-null-obj? ctx ,expr))

(define-macro (^void)
  `(univ-emit-void ctx))

(define-macro (^void? expr)
  `(univ-emit-void? ctx ,expr))

(define-macro (^void-obj)
  `(univ-emit-void-obj ctx))

(define-macro (^str->string expr)
  `(univ-emit-str->string ctx ,expr))

(define-macro (^string->str expr)
  `(univ-emit-string->str ctx ,expr))

(define-macro (^void-obj? expr)
  `(univ-emit-void-obj? ctx ,expr))

(define-macro (^str? expr)
  `(univ-emit-str? ctx ,expr))

(define-macro (^float? expr)
  `(univ-emit-float? ctx ,expr))

(define-macro (^int? expr)
  `(univ-emit-int? ctx ,expr))

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

(define-macro (^bool? val)
  `(univ-emit-bool? ctx ,val))

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

(define-macro (^dict-get expr1 expr2 #!optional (expr3 #f))
  `(univ-emit-dict-get ctx ,expr1 ,expr2 ,expr3))

(define-macro (^dict-set expr1 expr2 expr3)
  `(univ-emit-dict-set ctx ,expr1 ,expr2 ,expr3))

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

(define-macro (^bignum-digits val)
  `(univ-emit-bignum-digits ctx ,val))

(define-macro (^box? val)
  `(univ-emit-box? ctx ,val))

(define-macro (^box val)
  `(univ-emit-box ctx ,val))

(define-macro (^unbox val)
  `(univ-emit-unbox ctx ,val))

(define-macro (^setbox val1 val2)
  `(univ-emit-setbox ctx ,val1 ,val2))

(define-macro (^values-box val)
  `(univ-emit-values-box ctx ,val))

(define-macro (^values-unbox values)
  `(univ-emit-values-unbox ctx ,values))

(define-macro (^values? val)
  `(univ-emit-values? ctx ,val))

(define-macro (^values-length val)
  `(univ-emit-values-length ctx ,val))

(define-macro (^values-ref val1 val2)
  `(univ-emit-values-ref ctx ,val1 ,val2))

(define-macro (^values-set! val1 val2 val3)
  `(univ-emit-values-set! ctx ,val1 ,val2 ,val3))

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

(define-macro (^str-to-codes str)
  `(univ-emit-str-to-codes ctx ,str))

(define-macro (^str-length str)
  `(univ-emit-str-length ctx ,str))

(define-macro (^str-index-code str i)
  `(univ-emit-str-index-code ctx ,str ,i))

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

(define-macro (^symbol-box name)
  `(univ-emit-symbol-box ctx ,name))

(define-macro (^symbol-box-uninterned name hash)
  `(univ-emit-symbol-box-uninterned ctx ,name ,hash))

(define-macro (^symbol-unbox symbol)
  `(univ-emit-symbol-unbox ctx ,symbol))

(define-macro (^symbol? val)
  `(univ-emit-symbol? ctx ,val))

(define-macro (^keyword-obj obj force-var?)
  `(univ-emit-keyword-obj ctx ,obj ,force-var?))

(define-macro (^keyword-box name)
  `(univ-emit-keyword-box ctx ,name))

(define-macro (^keyword-box-uninterned name hash)
  `(univ-emit-keyword-box-uninterned ctx ,name ,hash))

(define-macro (^keyword-unbox keyword)
  `(univ-emit-keyword-unbox ctx ,keyword))

(define-macro (^keyword? val)
  `(univ-emit-keyword? ctx ,val))

(define-macro (^frame-box expr)
  `(univ-emit-frame-box ctx ,expr))

(define-macro (^frame-unbox expr)
  `(univ-emit-frame-unbox ctx ,expr))

(define-macro (^frame-slots expr)
  `(univ-emit-frame-slots ctx ,expr))

(define-macro (^frame? val)
  `(univ-emit-frame? ctx ,val))

(define-macro (^new-continuation expr1 expr2)
  `(univ-emit-new-continuation ctx ,expr1 ,expr2))

(define-macro (^continuation? val)
  `(univ-emit-continuation? ctx ,val))

(define-macro (^function? val)
  `(univ-emit-function? ctx ,val))

(define-macro (^procedure? val)
  `(univ-emit-procedure? ctx ,val))

(define-macro (^return? val)
  `(univ-emit-return? ctx ,val))

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

(define-macro (^new-promise expr)
  `(univ-emit-new-promise ctx ,expr))

(define-macro (^promise? val)
  `(univ-emit-promise? ctx ,val))

(define-macro (^new-will expr1 expr2)
  `(univ-emit-new-will ctx ,expr1 ,expr2))

(define-macro (^will? val)
  `(univ-emit-will? ctx ,val))

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

(define (univ-emit-map ctx fn array)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ array ".map( " fn " )"))

    ((php)
     (^ "array_map( '" fn "', " array ")"))

    ((python)
     (^ "map( "fn ", " array " )"))

    ((ruby)
     (^ array ".map { |x| " fn "(x) } " ))

    (else
     (compiler-internal-error
      "univ-emit-map, unknown target"))))
 
(define (univ-emit-call-with-arg-array ctx fn array)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ fn ".apply( null, " array " )"))

    ((php)
     (^ "call_user_func_array( " fn ", " array " )"))

    ((python)
     (^ fn "( *" array " )"))

    ((ruby)
     (^ fn ".( *" array " )"))

    (else
     (compiler-internal-error
      "univ-emit-call-with-arg-array, unknown target"))))

(define (univ-emit-var-declaration ctx type name #!optional (init #f))
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "var " name (if init (^ " = " init) (^)) ";\n"))

    ((python ruby)
     (^ name " = " (or init (^obj #f)) "\n"))

    ((php)
     (^ name " = " (or init (^obj #f)) ";\n"))

    ((java)
     (^ (^decl type name) (if init (^ " = " init) (^)) ";\n"))

    (else
     (compiler-internal-error
      "univ-emit-var-declaration, unknown target"))))

(define (univ-emit-expr-statement ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php java)
     (^ expr ";\n"))

    ((python ruby)
     (^ expr "\n"))

    (else
     (compiler-internal-error
      "univ-emit-expr-statement, unknown target"))))

(define (univ-emit-if ctx test true #!optional (false #f))
  (case (target-name (ctx-target ctx))

    ((js php java)
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

    ((js ruby java)
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

    ((js php java)
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

    ((java)
     (^ (^cast*-scmobj expr1) " == " (^cast*-scmobj expr2)))

    (else
     (compiler-internal-error
      "univ-emit-eq?, unknown target"))))

(define (univ-emit-+ ctx expr1 #!optional (expr2 #f))
  (case (target-name (ctx-target ctx))

    ((js php python ruby java)
     (if expr2
         (^ expr1 " + " expr2)
         (^ "+ " expr1)))

    (else
     (compiler-internal-error
      "univ-emit-+, unknown target"))))

(define (univ-emit-- ctx expr1 #!optional (expr2 #f))
  (case (target-name (ctx-target ctx))

    ((js php python ruby java)
     (if expr2
         (^ expr1 " - " expr2)
         (^ "- " expr1)))

    (else
     (compiler-internal-error
      "univ-emit--, unknown target"))))

(define (univ-emit-* ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java)
     (^ expr1 " * " expr2))

    (else
     (compiler-internal-error
      "univ-emit-*, unknown target"))))

(define (univ-emit-/ ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java)
     (^ expr1 " / " expr2))

    (else
     (compiler-internal-error
      "univ-emit-/, unknown target"))))

(define (univ-wrap+ ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js java)
     (^>> (^<< (^parens (^+ expr1 expr2))
               univ-tag-bits)
          univ-tag-bits))

    ((python)
     (^>> (^member (^call-prim
                    "ctypes.c_int32"
                    (^<< (^parens (^+ expr1 expr2))
                         univ-tag-bits))
                   'value)
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

    ((js java)
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
                   'value)
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
                   'value)
          univ-tag-bits))

    ((ruby php)
     (^- (^parens (^bitand (^parens (^+ (^* expr1 expr2)
                                        univ-fixnum-max+1))
                           univ-fixnum-max*2+1))
         univ-fixnum-max+1))

    ((java)
     (^>> (^parens
           (^<< (^parens (^* expr1 expr2))
                univ-tag-bits))
          univ-tag-bits))

    (else
     (compiler-internal-error
      "univ-wrap*, unknown target"))))

(define (univ-emit-<< ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java)
     (^ expr1 " << " expr2))

    (else
     (compiler-internal-error
      "univ-emit-<<, unknown target"))))

(define (univ-emit->> ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java)
     (^ expr1 " >> " expr2))

    (else
     (compiler-internal-error
      "univ-emit->>, unknown target"))))

(define (univ-emit->>> ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js java)
     (^ expr1 " >>> " expr2))

    (else
     (compiler-internal-error
      "univ-emit->>>, unknown target"))))

(define (univ-emit-bitnot ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java)
     (^ "~ " expr))

    (else
     (compiler-internal-error
      "univ-emit-bitnot, unknown target"))))

(define (univ-emit-bitand ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java)
     (^ expr1 " & " expr2))

    (else
     (compiler-internal-error
      "univ-emit-bitand, unknown target"))))

(define (univ-emit-bitior ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java)
     (^ expr1 " | " expr2))

    (else
     (compiler-internal-error
      "univ-emit-bitior, unknown target"))))

(define (univ-emit-bitxor ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java)
     (^ expr1 " ^ " expr2))

    (else
     (compiler-internal-error
      "univ-emit-bitxor, unknown target"))))

(define (univ-emit-= ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 " === " expr2))

    ((python ruby php java)
     (^ expr1 " == " expr2))

    (else
     (compiler-internal-error
      "univ-emit-=, unknown target"))))

(define (univ-emit-!= ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 " !== " expr2))

    ((python ruby php java)
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

    ((js python ruby php java)
     (^ expr1 comp expr2))

    (else
     (compiler-internal-error
      "univ-emit-comparison, unknown target"))))

(define (univ-emit-not ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php ruby java)
     (^ "!" expr))

    ((python)
     (^ "not " expr))

    (else
     (compiler-internal-error
      "univ-emit-not, unknown target"))))

(define (univ-emit-&& ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js ruby php java)
     (^ expr1 " && " expr2))

    ((python)
     (^ expr1 " and " expr2))

    (else
     (compiler-internal-error
      "univ-emit-&&, unknown target"))))

(define (univ-emit-and ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js ruby java)
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

    ((js ruby php java)
     (^ expr1 " || " expr2)) ;; TODO: PHP || operator always yields a boolean

    ((python)
     (^ expr1 " or " expr2))

    (else
     (compiler-internal-error
      "univ-emit-or, unknown target"))))

(define (univ-emit-concat ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js python ruby java)
     (^ expr1 " + " expr2))

    ((php)
     (^ expr1 " . " expr2))

    (else
     (compiler-internal-error
      "univ-emit-concat, unknown target"))))

(define (univ-emit-tostr ctx expr)
  (case (target-name (ctx-target ctx))

    ((js java)
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

(define (univ-emit-cast ctx type expr)
  (^parens (^ (^parens type) (^parens expr))))

(define (univ-emit-cast* ctx type-name expr)
  (case (target-name (ctx-target ctx))
    ((java)
     (^cast (^type type-name) expr))
    (else
     expr)))

(define (univ-emit-cast*-scmobj ctx expr)
  (^cast* 'scmobj expr))

(define (univ-emit-seq ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js java)
     (^parens (^ expr1 " , " expr2)))

    ((ruby)
     (^parens (^ expr1 " ; " expr2)))

    (else
     (compiler-internal-error
      "univ-emit-seq, unknown target"))))

(define (univ-emit-parens ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby php python java)
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

    ((js python ruby java)
     name)

    ((php)
     (^ "$" name))

    (else
     (compiler-internal-error
      "univ-emit-local-var, unknown target"))))

(define (univ-emit-global-var ctx name)
  (case (target-name (ctx-target ctx))

    ((js python java)
     name)

    ((php ruby)
     (^ "$" name))

    (else
     (compiler-internal-error
      "univ-emit-global-var, unknown target"))))

(define (univ-emit-global-function ctx name)
  (case (target-name (ctx-target ctx))

    ((js python java)
     name)

    ((php ruby) name);;TODO: added
#;
    ((php ruby)
     (^ "$" name))

    (else
     (compiler-internal-error
      "univ-emit-global-function, unknown target"))))

(define (univ-emit-this-mod-field ctx name)
  (^mod-field (ctx-module-name ctx) name))

(define (univ-emit-this-mod-method ctx name)
  (^mod-method (ctx-module-name ctx) name))

(define (univ-emit-this-mod-jumpable ctx name)
  (^mod-jumpable (ctx-module-name ctx) name))

(define (univ-emit-mod-member ctx mod-name name)
  (if (and (case (target-name (ctx-target ctx))
             ((js)
              #f)
             ((python)
              (not (eq? (univ-module-representation ctx) 'class)))
             (else
              #t))
           (eq? (ctx-module-name ctx) mod-name)) ;; optimize access to self
      name
      (case (target-name (ctx-target ctx))

        ((js python ruby java)
         (^member (^prefix-class mod-name) name))

        ((php)
         (^ (^prefix-class mod-name) "::" name))

        (else
         (compiler-internal-error
          "univ-emit-mod-member, unknown target")))))

(define (univ-emit-mod-field ctx mod-name name)
  (case (univ-module-representation ctx)

    ((class)
     (tt"000"(univ-emit-mod-member ctx mod-name name)))

    (else
     (tt"111"(^global-var (^prefix name))))))

(define (univ-emit-mod-method ctx mod-name name)
  (case (univ-module-representation ctx)

    ((class)
     (tt"222"(univ-emit-mod-member ctx mod-name name)))

    (else
     (tt"333"(^global-function (^prefix name))))))

(define (univ-emit-mod-jumpable ctx mod-name name)
  (if (eq? (univ-procedure-representation ctx) 'class)
      (let ((x (^mod-field mod-name name)))
        (use-global ctx x)
        x)
      (univ-method-reference
       ctx
       (^mod-method mod-name name))))

(define (univ-emit-mod-class ctx mod-name name)
  (case (univ-module-representation ctx)

    ((class)
     (tt"444"(univ-emit-mod-member ctx mod-name name)))

    (else
     (tt"555"(^prefix-class name)))))

(define (univ-emit-rts-method ctx name)
  (case (univ-module-representation ctx)

    ((class)
     (tt"666"name))

    (else
     (tt"777"(^global-function (^prefix name))))))

(define (univ-emit-rts-method-ref ctx name)
  (case (univ-module-representation ctx)

    ((class)
     (tt"66"(univ-emit-mod-member ctx (univ-rts-module-name ctx) name)))

    (else
     (tt"77"(^global-function (^prefix name))))))

(define (univ-emit-rts-method-use ctx name)
  (univ-use-rtlib ctx name)
  (univ-emit-rts-method-ref ctx name))

(define (univ-emit-rts-field ctx name)
  (case (univ-module-representation ctx)

    ((class)
     (tt"888"name))

    (else
     (tt"999"(^global-var (^prefix name))))))

(define (univ-emit-rts-field-ref ctx name)
  (case (univ-module-representation ctx)

    ((class)
     (tt"88"(univ-emit-mod-member ctx (univ-rts-module-name ctx) name)))

    (else
     (tt"99"(^global-var (^prefix name))))))

(define (univ-emit-rts-field-use ctx name)
  (univ-use-rtlib ctx name)
  (let ((x (univ-emit-rts-field-ref ctx name)))
    (use-global ctx x)
    x))

(define (univ-emit-rts-jumpable-use ctx name)
  (univ-use-rtlib ctx name)
  (^mod-jumpable (univ-rts-module-name ctx) name))

(define (univ-emit-rts-class ctx name)
  (let ((real-name (univ-rts-type-alias ctx name)))
    (case (univ-module-representation ctx)

      ((class)
       (tt"0"(univ-emit-mod-member ctx (univ-rts-module-name ctx) real-name)))

      (else
       (tt"1"(^prefix-class real-name))))))

(define (univ-emit-rts-class-ref ctx name)
  (let ((real-name (univ-rts-type-alias ctx name)))
    (case (univ-module-representation ctx)

      ((class)
       (tt"00"(univ-emit-mod-member ctx (univ-rts-module-name ctx) real-name)))

      (else
       (tt"11"(^prefix-class real-name))))))

(define (univ-emit-rts-class-use ctx name)
  (univ-use-rtlib ctx name)
  (univ-emit-rts-class-ref ctx name))

(define (univ-rts-module-name ctx)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java)
     'RTS)

    (else
     (compiler-internal-error
      "univ-rts-module-name, unknown target"))))

(define (univ-emit-prefix ctx name)
  (case (univ-module-representation ctx)

    ((class)
     name)

    (else
     (^ "gambit_" name))))

(define (univ-emit-prefix-class ctx name)
  (case (univ-module-representation ctx)

;    ((class)
;     name)

    (else
     (^ "Gambit_" name))))

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

  (define (embed-expr x parens?)
    (if embed
        (embed (if parens? (^parens x) x))
        (^expr-statement x)))

  (define (inc-general loc expr)
    (if (and (number? expr) (< expr 0))
        (^ loc " -= " (- expr))
        (^ loc " += " expr)))

  (if (equal? expr 0)

      (embed-read loc)

      (case (target-name (ctx-target ctx))

        ((js php java)
         (cond ((equal? expr 1)
                (embed-expr (^ "++" loc) #f))
               ((equal? expr -1)
                (embed-expr (^ "--" loc) #f))
               (else
                (embed-expr (inc-general loc expr)
                            (eq? (target-name (ctx-target ctx)) 'php)))))

        ((python)
         (^ (^expr-statement (inc-general loc expr))
            (embed-read loc)))

        ((ruby)
         (embed-expr (inc-general loc expr) #t))

        (else
         (compiler-internal-error
          "univ-emit-inc-by, unknown target")))))

(define (univ-emit-alias ctx expr)
  (case (target-name (ctx-target ctx))

    ((js python ruby java)
     expr)

    ((php)
     (^ "&" expr))

    (else
     (compiler-internal-error
      "univ-emit-alias, unknown target"))))

(define (univ-emit-unalias ctx expr)
  (case (target-name (ctx-target ctx))

    ((js python ruby java)
     (^))

    ((php)
     (^expr-statement
      (^ "unset(" expr ")")))

    (else
     (compiler-internal-error
      "univ-emit-unalias, unknown target"))))

(define (univ-emit-array? ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^instanceof "Array" expr))

    ((php)
     (^call-prim "is_array" expr))

    ((python)
     (^instanceof "list" expr))

    ((java)
     (^ expr ".getClass().isArray()"))

    (else
     (compiler-internal-error
      "univ-emit-array?, unknown target"))))

(define (univ-emit-array-length ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby java)
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
      (^call-prim 'array_splice expr1 expr2)))

    ((python)
     (^expr-statement
      (^ expr1 "[" expr2 ":] = []")))

    ((ruby)
     (^expr-statement
      (^ expr1 ".slice!(" expr2 "," expr1 ".length)")))

    ((java)
     ;; assumes expr1 is an lvalue, and creates a copy of the array
     (^assign expr1 (^subarray expr1 0 expr2)))

    (else
     (compiler-internal-error
      "univ-emit-array-shrink!, unknown target"))))

(define (univ-emit-array-shrink-possibly-copy! ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^seq
      (^assign-expr (^member expr1 'length) expr2)
      expr1))

    ((php)
     (^call-prim 'array_splice expr1 (^int 0) expr2))

    ((python java)
     (^subarray expr1 (^int 0) expr2))

    ((ruby)
     (^seq
      (^call-prim (^member expr1 'slice!) expr2 (^member expr1 'length))
      expr1))

    (else
     (compiler-internal-error
      "univ-emit-array-shrink-possibly-copy!, unknown target"))))

(define (univ-emit-move-array-to-array ctx array1 srcpos array2 destpos len)
  (case (target-name (ctx-target ctx))

    ((java)
     (^expr-statement
      (^call-prim
       (^member 'System 'arraycopy)
       array1
       srcpos
       array2
       destpos
       len)))

    (else
     (compiler-internal-error
      "univ-emit-move-array-to-array, unknown target"))))

(define (univ-emit-copy-array-to-extensible-array ctx expr len)
  (case (target-name (ctx-target ctx))

    ((js php ruby java)
     (^subarray expr 0 len))

    ((python)
     (^ "dict(zip(range(" len ")," expr "))"))

    (else
     (compiler-internal-error
      "univ-emit-array-to-extensible-array, unknown target"))))

(define (univ-emit-extensible-array-to-array! ctx var len)
  (case (target-name (ctx-target ctx))

    ((js php ruby java)
     (^))

    ((python)
     (^assign var (^ "[" var "[i] for i in range(" len ")]")))

    (else
     (compiler-internal-error
      "univ-emit-extensible-array-to-array!, unknown target"))))

(define (univ-emit-subarray ctx expr1 expr2 expr3)
  (case (target-name (ctx-target ctx))

    ((js)
     (^call-prim (^member expr1 'slice)
                 expr2
                 (if (equal? expr2 0) expr3 (^+ expr2 expr3))))

    ((php)
     (^call-prim 'array_slice expr1 expr2 expr3))

    ((python)
     (^ expr1 "[" expr2 ":" (if (equal? expr2 0) expr3 (^+ expr2 expr3)) "]"))

    ((ruby)
     (^call-prim (^member expr1 'slice)
                 expr2
                 (if (equal? expr2 0) expr3 (^+ expr2 expr3))))

    ((java)
     (^call-prim (^member 'Arrays 'copyOfRange)
                 expr1
                 expr2
                 (if (equal? expr2 0) expr3 (^+ expr2 expr3))))

    (else
     (compiler-internal-error
      "univ-emit-subarray, unknown target"))))

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

    ((java)
     (^call-prim
      (^member expr1 'containsKey)
      expr2))

    (else
     (compiler-internal-error
      "univ-emit-prop-index-exists?, unknown target"))))

(define (univ-emit-get ctx obj name)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^prop-index obj (^str name)))

    ((php)
     (^call-prim
      (^rts-method-use 'get)
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
      (^rts-method-use 'set)
      obj
      (^str name)
      val))

    (else
     (compiler-internal-error
      "univ-emit-set, unknown target"))))


;; ***** DUMPING OF A COMPILATION MODULE

(define (univ-dump-code targ procs output c-intf module-descr unique-name options)

  (define (defs->code ctx mod-name defs)
    (univ-emit-defs
     ctx
     (case (univ-module-representation ctx)

       ((class)
        (let ((class-fields
               (reverse (univ-defs-fields defs)))
              (instance-fields
               '())
              (class-methods
               (reverse (univ-defs-methods defs)))
              (instance-methods
               '())
              (class-classes
               (reverse (univ-defs-classes defs)))
              (inits
               (reverse (univ-defs-inits defs))))
          (univ-add-class
           (univ-make-empty-defs)
           (univ-class
            (^prefix-class mod-name) ;; root-name
            '() ;; properties
            #f ;; extends
            class-fields
            '() ;; instance-fields
            class-methods
            '() ;; instance-methods
            class-classes
            #f ;; constructor
            inits))))

       (else
         defs))))

  (let* ((module-name
          (scheme-id->c-id (symbol->string (vector-ref module-descr 0))))

         (ctx1
          (make-ctx
           targ
           options
           module-name
           "zzz" ;;;;;;;;;;;;;;;;;
           (make-objs-used)
           (make-resource-set)
           (queue-empty)))

         (defs-procs
           (univ-dump-procs ctx1 procs))

         (defs-entry
           (univ-entry-point ctx1 (list-ref procs 0)))

         (defs-procs-entry
           (univ-defs-combine
            (univ-defs-combine defs-procs (univ-objs-defs ctx1))
            defs-entry))

         (code-prog
          (defs->code ctx1 module-name defs-procs-entry))

         (ctx2
          (make-ctx
           (ctx-target ctx1)
           (ctx-options ctx1)
           (univ-rts-module-name ctx1)
           "yyy" ;;;;;;;;;;;;
           (ctx-objs-used ctx1)
           (ctx-rtlib-features-used ctx1)
           (ctx-decls ctx1)))

         (defs-rtlib
           (if univ-dyn-load?
               (univ-make-empty-defs)
               (univ-rtlib ctx2)))

         (code-rtlib
          (defs->code ctx2 (univ-rts-module-name ctx2) defs-rtlib))

         (code-decls
          (queue->list (ctx-decls ctx2))))

    (^ (univ-rtlib-header ctx2)
       code-rtlib
       code-decls
       code-prog)))

(define (univ-dump targ procs output c-intf module-descr unique-name options)
  (let ((code (univ-dump-code targ procs output c-intf module-descr unique-name options)))
    (call-with-output-file output (lambda (port) (univ-display code port)))
    #f))

;;TODO: add constants
#;
(define (univ-module-header ctx)
  (^ (^var-declaration 'scmobj (gvm-state-cst ctx) (^extensible-array-literal 'scmobj '()))
     "\n"))

(define (univ-objs-defs ctx)
  (let* ((objs-used (ctx-objs-used ctx))
         (stack (reverse (objs-used-stack objs-used)))
         (table (objs-used-table objs-used)))
    (let loop ((lst stack) (defs (univ-make-empty-defs)))
      (if (pair? lst)
          (loop (cdr lst)
                (let ((obj (car lst)))
                  (if (proc-obj? obj)
                      defs
                      (let ((state (table-ref table obj)))
                        (if (or (> (vector-ref state 0) 1) ;; use a variable?
                                (eq? (target-name (ctx-target ctx)) 'python)) ;; Python can't handle deep nestings
                            (let ((cst
                                   (vector-ref state 2))
                                  (val
                                   (car (vector-ref state 1))))
                              ;;(pp (list cst obj));;;;;;;;;;;;;;;
                              (set-car! (vector-ref state 1)
                                        (^this-mod-field cst))
                              (univ-add-field
                               defs
                               (univ-field cst 'scmobj val '(public))))
                            defs)))))
          defs))))

(define (univ-obj-use ctx obj force-var? gen-expr)

  (define (use-cst cst)
    (if (not (eq? (univ-module-representation ctx) 'class))
        (use-global ctx (^this-mod-field cst))))

  (let* ((objs-used (ctx-objs-used ctx))
         (table (objs-used-table objs-used))
         (state (table-ref table obj #f)))
    (if state ;; don't add to table if obj was added before

        (begin
          (use-cst (vector-ref state 2))
          (vector-set! state 0 (+ (vector-ref state 0) 1)) ;; increment reference count
          (vector-ref state 1))

        (let* ((code
                (list #f))
               (cst
                (string->symbol
                 (string-append
                  "cst"
                  (number->string (table-length table))
                  (if (eq? (univ-module-representation ctx) 'class)
                      ""
                      (string-append "_" (ctx-module-name ctx))))))
               (state
                (vector (if force-var? 2 1) code cst)))
          (use-cst cst)
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

      (define ctrlpts
        (make-stretchable-vector #f))

      (define ctrlpts-init
        (list #f))

      (define (scan-bbs ctx bbs)
        (let* ((bb-done (make-stretchable-vector #f))
               (bb-todo (queue-empty)))

          (define (todo-lbl-num! n)
            (queue-put! bb-todo (lbl-num->bb n bbs)))

          (define (scan-bb ctx bb)
            (if (stretchable-vector-ref bb-done (bb-lbl-num bb))
                (univ-make-empty-defs)
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
                                                 (^mod-jumpable
                                                  (ctx-module-name ctx)
                                                  id)))

                              (else
                               (^)))

                            (proc ctx))))
                      (entry
                       (bbs-entry-lbl-num bbs))
                      (lbl-num
                       (label-lbl-num gvm-instr)))

                 (univ-jumpable-declaration-defs

                  ctx

                  ;; global?
                  #t

                  ;; name
                  id

                  ;; jumpable-type
                  (case (label-type gvm-instr)
                    ((entry)  (if (= lbl-num entry)
                                  'parententrypt
                                  'entrypt))
                    ((return) 'returnpt)
                    (else     'ctrlpt))

                  ;; params
                  '()

                  ;; attribs
                  (if (memq (label-type gvm-instr) '(entry return))

                      (append

                       (let ((ctrlpt-id
                              (stretchable-vector-length ctrlpts)))
                         (stretchable-vector-set!
                          ctrlpts
                          ctrlpt-id
                          lbl-num)
                         (list (univ-field 'id
                                           'int
                                           (^int ctrlpt-id)
                                           '(inherited))
                               (univ-field 'parent
                                           'parententrypt
                                           (let ((entry? (= lbl-num entry)))
                                             (cond ((and entry?
                                                         (univ-parent-entry-point-has-null-parent? ctx))
                                                    (^null))
                                                   ((and entry?
                                                         (eq? (univ-procedure-representation ctx) 'class))
                                                    (^this))
                                                   (else
                                                    (let ((the-ns (ctx-ns ctx)))
                                                      (lambda (ctx2)
                                                        (let ((ns (ctx-ns ctx2)))
                                                          (ctx-ns-set! ctx2 the-ns)
                                                          (let ((x (univ-ctrlpt-reference
                                                                    ctx2
                                                                    entry)))
                                                            (ctx-ns-set! ctx2 ns)
                                                            x)))))))
                                           '(inherited))))

                       (if (eq? (label-type gvm-instr) 'return)

                           (let ((info (frame-info gvm-instr)))
                             (list (univ-field 'fs
                                               'int
                                               (^int (vector-ref info 0))
                                               '(inherited))
                                   (univ-field 'link
                                               'int
                                               (^int (+ (vector-ref info 1) 1))
                                               '(inherited))))

                           (append
                            (list (univ-field
                                   'nb_closed
                                   'int
                                   (if (label-entry-closed? gvm-instr)
                                       (let* ((frame (gvm-instr-frame gvm-instr))
                                              (nb-closed (length (frame-closed frame))))
                                         (^int nb-closed))
                                       (^int -1))
                                   '(inherited)))
                            (if (= lbl-num entry)
                                (list (univ-field (univ-proc-name-attrib ctx)
                                                  'symbol
                                                  (lambda (ctx)
                                                    (univ-prm-name ctx (proc-obj-name p)))
                                                  '(inherited))
                                      (univ-field 'ctrlpts
                                                  '(array ctrlpt)
                                                  ctrlpts-init
                                                  '(inherited))
                                      (univ-field 'info
                                                  'scmobj
                                                  (^obj #f) ;; TODO
                                                  '(inherited)))
                                '()))))

                      '())

                  ;; body
                  (univ-emit-fn-body ctx header gen-body))))))

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
                                 (^setloc loc (or result (^void-obj))))
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
                                        (^null))
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
                                         (^rts-method-use 'check_procedure_glo)
                                         (scan-gvm-opnd ctx opnd)
                                         (^obj (glo-name opnd)))
                                        (^call-prim
                                         (^rts-method-use 'check_procedure)
                                         (scan-gvm-opnd ctx opnd)))
                                    (let ((o (scan-gvm-opnd ctx opnd)))
                                      (if (or (lbl? opnd) (obj? opnd))
                                          o
                                          (^cast* 'jumpable o))))
                                poll?
                                (and

                                 ;; avoid call optimization on globals
                                 ;; because some VMs, such as V8 and PyPy,
                                 ;; use a counterproductive speculative
                                 ;; optimization (which slows
                                 ;; down fib by an order of magnitude!)
                                 (not (reg? opnd))

                                 (case (target-name (ctx-target ctx))
                                   ((php)
                                    ;; avoid call optimization on PHP
                                    ;; because it generates syntactically
                                    ;; incorrect code (PHP grammar issue)
                                    #f)
                                   (else
                                    #t)))))))))))

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
                      (^return-jump
                       (scan-gvm-opnd ctx (make-lbl n))))))))

          (define (scan-gvm-opnd ctx gvm-opnd)
            (if (lbl? gvm-opnd)
                (todo-lbl-num! (lbl-num gvm-opnd)))
            (^getopnd gvm-opnd));;;;;;;;;;;;;;;;;;;;;;;scan-gvm-loc ?

          (todo-lbl-num! (bbs-entry-lbl-num bbs))

          (let* ((bbs-defs
                  (let loop ((defs (univ-make-empty-defs)))
                    (if (queue-empty? bb-todo)
                        defs
                        (loop (univ-defs-combine
                               defs
                               (scan-bb ctx (queue-get! bb-todo)))))))
                 (init1
                  (let* ((lbl
                          (make-lbl (bbs-entry-lbl-num bbs)))
                         (entry-id
                          (gvm-lbl-use ctx lbl))
                         (ctrlpts-array
                          (^array-literal
                           (univ-ctrlpt-reference-type ctx)
                           (map (lambda (n)
                                  (univ-ctrlpt-reference ctx n))
                                (stretchable-vector->list ctrlpts)))))
                    (if (eq? (univ-ctrlpt-reference-type ctx) 'str)

                        (begin
                          (set-car! ctrlpts-init ctrlpts-array)
                          (lambda (ctx) (^)))

                        (begin
                          (set-car! ctrlpts-init (^null))
                          (lambda (ctx)
                            (^ "\n"
                               (univ-with-ctrlpt-attribs
                                ctx
                                #f
                                entry-id
                                (lambda ()
                                  (univ-set-ctrlpt-attrib
                                   ctx
                                   entry-id
                                   'ctrlpts
                                   ctrlpts-array)))))))))
                 (init2
                  (lambda (ctx)
                    (let ((name (string->symbol (proc-obj-name p))))
                      (^ "\n"
                         (^setprm name (^obj p))
                         (if (proc-obj-primitive? p)
                             (^setglo name (^obj p))
                             (^)))))))
            (univ-add-init (univ-add-init bbs-defs init1) init2))))

      (let ((ctx (make-ctx
                  (ctx-target global-ctx)
                  (ctx-options global-ctx)
                  (ctx-module-name global-ctx)
                  (scheme-id->c-id (proc-obj-name p))
                  (ctx-objs-used global-ctx)
                  (ctx-rtlib-features-used global-ctx)
                  (ctx-decls global-ctx))))
        (let ((x (proc-obj-code p)))
          (if (bbs? x)
              (scan-bbs ctx x)
              (univ-make-empty-defs)))))

    (for-each scan-obj procs)

    (let loop ((defs (univ-make-empty-defs)))
      (if (queue-empty? proc-left)
          defs
          (loop (univ-defs-combine defs (dump-proc (queue-get! proc-left))))))))

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
                              (^rts-method-use 'build_rest)
                              nb-parms-except-rest))
                       (^!= (^getnargs)
                            nb-parms-except-rest))
                   (^return-call-prim
                    (^rts-method-use 'wrong_nargs)
                    (if closed?
                        (^cast* 'jumpable
                                (^getreg (+ univ-nb-arg-regs 1)))
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

(define (univ-gensym ctx name)
  (let ((count (ctx-serial-num ctx)))
    (ctx-serial-num-set! ctx (+ count 1))
    (string->symbol
     (string-append
      (symbol->string name)
      (number->string count)))))

(define (univ-closure-alloc ctx lbl exprs cont)
  (let ((closure-var (^local-var (univ-gensym ctx 'closure))))
    (^ (^var-declaration
        'closure
        closure-var
        (^call-prim
         (^rts-method-use 'closure_alloc)
         (^array-literal
          'scmobj
          (cons (gvm-lbl-use ctx (make-lbl lbl))
                exprs))))
       (cont closure-var))))

(define (make-ctx
         target
         options
         module-name
         ns
         objs-used
         rtlib-features-used
         decls)
  (vector target
          options
          module-name
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

(define (ctx-module-name ctx)              (vector-ref ctx 2))
(define (ctx-module-name-set! ctx x)       (vector-set! ctx 2 x))

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
  (cons (make-table) '()))

(define (resource-set-add! set element)
  (let ((t (car set)))
    (if (not (table-ref t element #f))
        (begin
          (table-set! t element #t)
          (set-cdr! set (cons element (cdr set)))))))

(define (resource-set-member? set element)
  (table-ref (car set) element #f))

(define (resource-set-stack set)
  (cdr set))

(define (resource-set-pop set)
  (let ((s (cdr set)))
    (if (pair? s)
        (begin
          (set-cdr! set (cdr s))
          (car s))
        #f)))

(define (use-resource-rd ctx resource)
  (resource-set-add! (ctx-resources-used-rd ctx) resource))

(define (use-resource-wr ctx resource)
  (resource-set-add! (ctx-resources-used-wr ctx) resource))

(define (use-global ctx global)
  (resource-set-add! (ctx-globals-used ctx) global))

(define (univ-use-rtlib ctx feature)
  ;;(pp (list 'use-rtlib feature));;;;;;;;;;;;
  (resource-set-add! (ctx-rtlib-features-used ctx) feature)
  (symbol->string feature))

(define (use-resource ctx dir resource)
  (if (or (eq? dir 'rd) (eq? dir 'rdwr))
      (use-resource-rd ctx resource))
  (if (or (eq? dir 'wr) (eq? dir 'rdwr))
      (use-resource-wr ctx resource)))

(define (gvm-state-pollcount ctx)
  (^rts-field-use 'pollcount))

(define (gvm-state-nargs ctx)
  (^rts-field-use 'nargs))

(define (gvm-state-reg ctx num)
  (^rts-field-use (string->symbol (string-append "r" (number->string num)))))

(define (gvm-state-stack ctx)
  (^rts-field-use 'stack))

(define (gvm-state-sp ctx)
  (^rts-field-use 'sp))

(define (gvm-state-prm ctx)
  (^rts-field-use 'prm))

(define (gvm-state-glo ctx)
  (^rts-field-use 'glo))

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
     (^member (^cast* 'closure closure) 'slots))

    (else
     (case (target-name (ctx-target ctx))
       ((php)
        ;;(^member (^cast* 'closure closure) 'slots)
        (^member closure 'slots))
       (else
        (^jump closure (^bool #t)))))))

(define (univ-emit-getclo ctx closure index)
  (^closure-ref closure index))

(define (univ-emit-setclo ctx closure index val)
  (^closure-set! closure index val))

(define (univ-glo-dependency ctx name)
  (gvm-state-glo-use ctx 'rd)
  (if (member name
              '(println
                real-time-milliseconds))
      (univ-use-rtlib
       ctx
       (string->symbol (string-append "glo-" (symbol->string name))))))

(define (univ-emit-getprm ctx name)
  (^dict-get (gvm-state-prm-use ctx 'rd)
             (^str (symbol->string name))))

(define (univ-emit-setprm ctx name val)
  (^dict-set (gvm-state-prm-use ctx 'rd)
             (^str (symbol->string name))
             val))

(define (univ-emit-getglo ctx name)
  (univ-glo-dependency ctx name)
  (^dict-get (gvm-state-glo-use ctx 'rd)
             (^str (symbol->string name))))

(define (univ-emit-setglo ctx name val)
  (univ-glo-dependency ctx name)
  (^dict-set (gvm-state-glo-use ctx 'rd)
             (^str (symbol->string name))
             val))

(define (univ-emit-glo-var-ref ctx sym)
  (^dict-get (gvm-state-glo-use ctx 'rd)
             (^symbol-unbox sym)))

(define (univ-emit-glo-var-primitive-ref ctx sym)
  (^dict-get (gvm-state-prm-use ctx 'rd)
             (^symbol-unbox sym)))

(define (univ-emit-glo-var-set! ctx sym val)
  (^dict-set (gvm-state-glo-use ctx 'rd)
             (^symbol-unbox sym)
             val))

(define (univ-emit-glo-var-primitive-set! ctx sym val)
  (^dict-set (gvm-state-prm-use ctx 'rd)
             (^symbol-unbox sym)
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
                  (^flonum-box (^float obj)))

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
                         (^new (^type 'bignum)
                               (^array-literal
                                'bigdigit
                                (univ-bignum->digits obj)))))))))

          ((char? obj)
           (^char-obj obj force-var?))

          ((string? obj)
           (^string-obj obj force-var?))

          ((symbol-object? obj)
           (^symbol-obj obj force-var?))

          ((keyword-object? obj)
           (^keyword-obj obj force-var?))

          ((null? obj)
           (^null-obj))

          ((void-object? obj)
           (^void-obj))

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
           (^this-mod-jumpable
            (gvm-proc-use ctx (proc-obj-name obj))))

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
                'scmobj
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
                'u8
                (map (lambda (x) (^int x))
                     (u8vect->list obj)))))))

          ((u16vect? obj)
           (univ-obj-use
            ctx
            obj
            force-var?
            (lambda ()
              (^u16vector-box
               (^array-literal
                'u16
                (map (lambda (x) (^int x))
                     (u16vect->list obj)))))))

          ((f64vect? obj)
           (univ-obj-use
            ctx
            obj
            force-var?
            (lambda ()
              (^f64vector-box
               (^array-literal
                'f64
                (map (lambda (x) (^float x))
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
                (^structure-box
                 (^array-literal
                  'scmobj
                  (cons (if cyclic? ;; the root type descriptor is cyclic
                            (^null) ;; handle this specially
                            (emit-obj (vector-ref slots 0) #f))
                        (map (lambda (x) (emit-obj x #f))
                             (cdr (vector->list slots))))))))))

          (else
           (compiler-user-warning #f "UNIMPLEMENTED OBJECT:" obj)
           (^str
            (string-append
             "UNIMPLEMENTED OBJECT: "
             (object->string obj))))))

  (emit-obj obj #t))

(define univ-adigit-width 14)

(define (univ-bignum->digits obj)

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

(define (univ-emit-array-literal ctx type elems)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^ "[" (univ-separated-list "," elems) "]"))

    ((php)
     (^apply "array" elems))

    ((java)
     (^ "new " (^type (list 'array type)) "{" (univ-separated-list "," elems) "}"))

    (else
     (compiler-internal-error
      "univ-emit-array-literal, unknown target"))))

(define (univ-emit-extensible-array-literal ctx type elems)
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

    ((java)
     (^ "new " (^type (list 'array type)) "{" (univ-separated-list "," elems) "}"))

    (else
     (compiler-internal-error
      "univ-emit-extensible-array-literal, unknown target"))))

(define (univ-emit-make-stack ctx)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (^extensible-array-literal 'scmobj '()))

    ((java)
     (^new-array 'scmobj 10000));;TODO: fix size

    (else
     (compiler-internal-error
      "univ-emit-make-stack, unknown target"))))

(define (univ-emit-new-array ctx type len)
  (case (target-name (ctx-target ctx))

    ((js)
     (^new "Array" len))

    ((php)
     (^if-expr (^= len (^int 0)) ;; array_fill does not like len=0
               (^array-literal type '())
               (^call-prim
                "array_fill"
                (^int 0)
                len
                (^int 0))))

    ((python)
     (^* (^ "[" (^int 0) "]") len))

    ((ruby)
     (^call-prim (^member "Array" 'new) len))

    ((java)
     (^ "new " (^type type) "[" len "]"))

    (else
     (compiler-internal-error
      "univ-emit-new-array, unknown target"))))

(define (univ-emit-make-array ctx type return len init)
  (case (target-name (ctx-target ctx))

    ((js)
     ;; TODO: add for loop constructor
     (let ((elems (^local-var 'elems)))
       (^ (^var-declaration
           (list 'array type)
           elems
           (^new-array type len))
          "
          for (var i=0; i<" len "; i++) {
            " elems "[i] = " init ";
          }
          "
          (return elems))))

    ((php)
     (return
      (^if-expr (^= len (^int 0)) ;; array_fill does not like len=0
                (^array-literal type '())
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
      (^call-prim (^member "Array" 'new) len init)))

    ((java)
     ;; TODO: add for loop constructor
     (let ((elems (^local-var 'elems)))
       (^ (^var-declaration
           (list 'array type)
           elems
           (^new-array type len))
          "
          for (int i=0; i<" len "; i++) {
            " elems "[i] = " init ";
          }
          "
          (return elems))))

    (else
     (compiler-internal-error
      "univ-emit-make-array, unknown target"))))

(define (univ-emit-empty-dict ctx)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^ "{}"))

    ((php)
     (^ "array()"))

    ((java)
     (^new "HashMap<>"))

    (else
     (compiler-internal-error
      "univ-emit-empty-dict, unknown target"))))

;; =============================================================================

(define (gvm-lbl-use ctx lbl)
  (^this-mod-jumpable (gvm-lbl-use-aux ctx lbl)))

(define (gvm-lbl-use-aux ctx lbl)
  (gvm-bb-use ctx (lbl-num lbl) (ctx-ns ctx)))

(define (gvm-proc-use ctx name)
  (gvm-bb-use ctx 1 (scheme-id->c-id name)))

(define (gvm-bb-use ctx num ns)
  (let ((id (lbl->id ctx num ns)))
    ;;TODO: remove?
    ;;(use-global ctx (^mod-field "AAA" id))
    id))

(define (lbl->id ctx num ns)
  (^ univ-bb-prefix num "_" ns))

(define univ-bb-prefix "bb")
(define univ-capitalized-bb-prefix "Bb")

(define (univ-foldr-range lo hi rest fn)
  (if (<= lo hi)
      (univ-foldr-range
       lo
       (- hi 1)
       (fn hi rest)
       fn)
      rest))

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
                (^var-declaration
                 'scmobj
                 (^local-var (^ 'arg i))
                 (^getreg x))
                (^pop (lambda (expr)
                        (^var-declaration
                         'scmobj
                         (^local-var (^ 'arg i))
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

(define (univ-min-fixnum ctx) 0)
(define (univ-max-fixnum ctx) 256)

(define (univ-rtlib-feature ctx feature)

  (define (rts-method
           name
           properties
           result-type
           params
           header
           attribs
           gen-body)
    (univ-add-method
     (univ-make-empty-defs)
     (univ-method
      (^rts-method name)
      properties
      result-type
      params
      attribs
      (univ-emit-fn-body ctx header gen-body))))

  (define (rts-class
           root-name
           #!optional
           (properties '())
           (extends #f)
           (class-fields '())
           (instance-fields '())
           (class-methods '())
           (instance-methods '())
           (class-classes '())
           (constructor #f)
           (inits '()))
    (univ-add-class
     (univ-make-empty-defs)
     (univ-class
      (^rts-class root-name)
      properties
      (and extends
           (or (eq? (target-name (ctx-target ctx)) 'java)
               (not (eq? extends 'scmobj)))
           (^rts-class-use extends))
      class-fields
      instance-fields
      class-methods
      instance-methods
      class-classes
      constructor
      inits)))

  (define (rts-field name type #!optional (init #f) (properties '()))
    (univ-add-field
     (univ-make-empty-defs)
     (univ-field name type init properties)))

  (define (rts-init init)
    (univ-add-init
     (univ-make-empty-defs)
     init))

  (define (continuation-capture-procedure nb-args thread-save?)
    (let ((nb-stacked (max 0 (- nb-args univ-nb-arg-regs))))
      (univ-jumpable-declaration-defs
       ctx
       #t
       (string->symbol
        (string-append
         (if thread-save?
             "thread_save"
             "continuation_capture")
         (number->string nb-args)))
       'entrypt
       '()
       '()
       (univ-emit-fn-body
        ctx
        "\n"
        (lambda (ctx)
          (^ (if (= nb-stacked 0)
                 (^var-declaration
                  'scmobj
                  (^local-var (^ 'arg 1))
                  (^getreg 1))
                 (univ-foldr-range
                  1
                  nb-stacked
                  (^)
                  (lambda (i rest)
                    (^ rest
                       (^pop (lambda (expr)
                               (^var-declaration
                                'scmobj
                                (^local-var (^ 'arg i))
                                expr)))))))

             (^setreg 0
                      (^call-prim
                       (^rts-method-use 'heapify_cont)
                       (^cast* 'returnpt
                               (^getreg 0))))

             (let* ((cont
                     (^new-continuation
                      (^cast* 'frame
                              (^array-index
                               (gvm-state-stack-use ctx 'rd)
                               (^int 0)))
                      (^structure-ref (^rts-field-use 'current_thread)
                                      univ-thread-denv-slot)))
                    (result
                     (if thread-save?
                         (^rts-field-use 'current_thread)
                         cont)))

               (^ (if thread-save?
                      (^structure-set! (^rts-field-use 'current_thread)
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

             (^return-jump
              (^cast* 'jumpable
                      (^local-var (^ 'arg 1))))))))))

  (define (continuation-graft-no-winding-procedure nb-args thread-restore?)
    (univ-jumpable-declaration-defs
     ctx
     #t
     (string->symbol
      (string-append
       (if thread-restore?
           "thread_restore"
           "continuation_graft_no_winding")
       (number->string nb-args)))
     'entrypt
     '()
     '()
     (univ-emit-fn-body
      ctx
      "\n"
      (lambda (ctx)
        (let* ((nb-stacked
                (max 0 (- nb-args univ-nb-arg-regs)))
               (new-nb-args
                (- nb-args 2))
               (new-nb-stacked
                (max 0 (- new-nb-args univ-nb-arg-regs)))
               (underflow
                (^rts-jumpable-use 'underflow)))
          (^ (univ-foldr-range
              1
              (max 2 (- nb-args univ-nb-arg-regs))
              (^)
              (lambda (i rest)
                (^ rest
                   (^var-declaration
                    'scmobj
                    (^local-var (^ 'arg i))
                    (let ((x (- i nb-stacked)))
                      (if (>= x 1)
                          (^getreg x)
                          (^getstk x)))))))

             (if thread-restore?
                 (^ (^assign (^rts-field-use 'current_thread)
                             (^local-var (^ 'arg 1)))
                    (^assign (^local-var (^ 'arg 1))
                             (^structure-ref (^local-var (^ 'arg 1))
                                             univ-thread-cont-slot)))
                 (^))

             (^assign
              (^array-index
               (gvm-state-stack-use ctx 'rd)
               (^int 0))
              (^member (^cast* 'continuation
                               (^local-var (^ 'arg 1)))
                       'frame))

             (^structure-set! (^rts-field-use 'current_thread)
                              univ-thread-denv-slot
                              (^member (^cast* 'continuation
                                               (^local-var (^ 'arg 1)))
                                       'denv))

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

             (^return
              (^cast* 'jumpable
                      (^local-var (^ 'arg 2))))))))))

  (define (continuation-return-no-winding-procedure nb-args)
    (univ-jumpable-declaration-defs
     ctx
     #t
     (string->symbol
      (string-append
       "continuation_return_no_winding"
       (number->string nb-args)))
     'entrypt
     '()
     '()
     (univ-emit-fn-body
      ctx
      "\n"
      (lambda (ctx)
        (let* ((nb-stacked
                (max 0 (- nb-args univ-nb-arg-regs)))
               (underflow
                (^rts-jumpable-use 'underflow))
               (arg1
                (^local-var 'arg1)))
          (^ (^var-declaration
              'continuation
              arg1
              (^cast* 'continuation
                      (let ((x (- 1 nb-stacked)))
                        (if (>= x 1)
                            (^getreg x)
                            (^getstk x)))))

             (^assign
              (^array-index
               (gvm-state-stack-use ctx 'rd)
               (^int 0))
              (^member arg1 'frame))

             (^structure-set! (^rts-field-use 'current_thread)
                              univ-thread-denv-slot
                              (^member arg1 'denv))

             (^assign
              (gvm-state-sp-use ctx 'wr)
              0)

             (^setreg 0 underflow)

             (let ((x (- 2 nb-stacked)))
               (if (= x 1)
                   (^)
                   (^setreg 1 (^getreg x))))

             (^return underflow)))))))

  (define (apply-procedure nb-args)
    (univ-jumpable-declaration-defs
     ctx
     #t
     (string->symbol
      (string-append
       "apply"
       (number->string nb-args)))
     'entrypt
     '()
     '()
     (univ-emit-fn-body
      ctx
      "\n"
      (lambda (ctx)
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

           (^return
            (^cast* 'jumpable
                    (^local-var (^ 'arg 1)))))))))

  (case feature

    ((r0 r1 r2 r3 r4)
     (rts-field feature 'scmobj (^null) '(public)))

    ((prm)
     (rts-field 'prm '(dict str scmobj) (^empty-dict) '(public)))

    ((glo)
     (rts-field 'glo '(dict str scmobj) (^empty-dict) '(public)))

    ((stack)
     (rts-field 'stack '(array scmobj) (univ-emit-make-stack ctx) '(public)))

    ((sp)
     (rts-field 'sp 'int (^int -1) '(public)))

    ((nargs)
     (rts-field 'nargs 'int (^int 0) '(public)))

    ((pollcount)
     (rts-field 'pollcount 'int (^int 100) '(public)))

    ((temp1)
     (rts-field 'temp1 'scmobj (^null) '(public)))

    ((temp2)
     (rts-field 'temp2 'scmobj (^null) '(public)))

    ((inttemp1)
     (rts-field 'inttemp1 'int (^int 0) '(public)))

    ((inttemp2)
     (rts-field 'inttemp2 'int (^int 0) '(public)))

    ((current_thread)
     (rts-field 'current_thread
                'scmobj
                (^structure-box
                 (^array-literal
                  'scmobj
                  (list (^null)   ;; type descriptor (filled in later)
                        (^null)   ;; btq-next
                        (^null)   ;; btq-prev
                        (^null)   ;; toq-next
                        (^null)   ;; toq-prev
                        (^null)   ;; continuation
                        (^obj '()) ;; dynamic environment
                        (^null)    ;; state
                        (^null)    ;; thunk
                        (^null)    ;; result
                        (^null)    ;; mutex
                        (^null)    ;; condvar
                        (^obj 0)   ;; id
                        )))
                '(public)))

    ((trampoline)
     (rts-method
      'trampoline
      '(public)
      'noresult
      (list (univ-field 'pc 'jumpable))
      "\n"
      '()
      (lambda (ctx)
        (let ((pc (^local-var 'pc)))
          (^while (^!= pc (^null))
                  (^assign pc
                           (^jump pc)))))))

    ((heapify_cont)
     (rts-method
      'heapify_cont
      '(public)
      'returnpt
      (list (univ-field 'ra 'returnpt))
      "\n"
      '()
      (lambda (ctx)
        (let ((ra (^local-var 'ra))
              (fs (^local-var 'fs))
              (link (^local-var 'link))
              (base (^local-var 'base))
              (frame (^local-var 'frame))
              (prev_link (^local-var 'prev_link))
              (prev_frame (^local-var 'prev_frame))
              (chain (^local-var 'chain)))
          (^ (^if (^> (gvm-state-sp-use ctx 'rd) 0)
                  (univ-with-ctrlpt-attribs
                   ctx
                   #f
                   ra
                   (lambda ()

                     (^ (^var-declaration
                         'int
                         fs
                         (univ-get-ctrlpt-attrib ctx ra 'fs))

                        (^var-declaration
                         'int
                         link
                         (univ-get-ctrlpt-attrib ctx ra 'link))

                        (^var-declaration
                         'int
                         base
                         (^- (gvm-state-sp-use ctx 'rd) fs))

                        (^extensible-array-to-array!
                         (gvm-state-stack-use ctx 'rdwr)
                         (^+ (gvm-state-sp-use ctx 'rd) 1))

                        (^var-declaration
                         'frame
                         chain)

                        (^if (^> base 0)

                             (^ (^assign chain
                                         (^frame-box
                                          (^subarray
                                           (gvm-state-stack-use ctx 'rd)
                                           base
                                           (^+ fs 1))))

                                (^assign (^array-index
                                          (^frame-slots chain)
                                          (^int 0))
                                         ra)

                                (^assign (gvm-state-sp-use ctx 'wr)
                                         base)

                                (^var-declaration
                                 'frame
                                 prev_frame
                                 (^alias chain))

                                (^var-declaration
                                 'int
                                 prev_link
                                 link)

                                (^assign ra
                                         (^cast* 'returnpt
                                                 (^array-index
                                                  (^frame-slots prev_frame)
                                                  prev_link)))

                                (univ-with-ctrlpt-attribs
                                 ctx
                                 #t
                                 ra
                                 (lambda ()

                                   (^ (^assign
                                       fs
                                       (univ-get-ctrlpt-attrib ctx ra 'fs))

                                      (^assign
                                       link
                                       (univ-get-ctrlpt-attrib ctx ra 'link))

                                      (^assign
                                       base
                                       (^- (gvm-state-sp-use ctx 'rd)
                                           fs))

                                      (^while (^> base 0)
                                              (^ (^var-declaration
                                                  'frame
                                                  frame
                                                  (^frame-box
                                                   (^subarray
                                                    (gvm-state-stack-use ctx 'rd)
                                                    base
                                                    (^+ fs 1))))

                                                 (^assign
                                                  (^array-index
                                                   (^frame-unbox frame)
                                                   (^int 0))
                                                  ra)

                                                 (^assign
                                                  (gvm-state-sp-use ctx 'wr)
                                                  base)

                                                 (^assign
                                                  (^array-index
                                                   (^frame-slots prev_frame)
                                                   prev_link)
                                                  (^alias frame))

                                                 (^assign
                                                  prev_frame
                                                  (^alias frame))

                                                 (^unalias frame)

                                                 (^assign
                                                  prev_link
                                                  link)

                                                 (^assign
                                                  ra
                                                  (^cast* 'returnpt
                                                          (^array-index
                                                           (^frame-slots prev_frame)
                                                           prev_link)))

                                                 (univ-with-ctrlpt-attribs
                                                  ctx
                                                  #t
                                                  ra
                                                  (lambda ()

                                                    (^ (^assign
                                                        fs
                                                        (univ-get-ctrlpt-attrib ctx ra 'fs))

                                                       (^assign
                                                        link
                                                        (univ-get-ctrlpt-attrib ctx ra 'link))

                                                       (^assign
                                                        base
                                                        (^- (gvm-state-sp-use ctx 'rd)
                                                            fs)))))))

                                      (^assign
                                       (^array-index
                                        (gvm-state-stack-use ctx 'rd)
                                        link)
                                       (^array-index
                                        (gvm-state-stack-use ctx 'rd)
                                        (^int 0)))

                                      (^assign
                                       (^array-index
                                        (gvm-state-stack-use ctx 'rd)
                                        (^int 0))
                                       ra)

                                      (^assign
                                       (^array-index
                                        (^frame-slots prev_frame)
                                        prev_link)
                                       (^frame-box
                                        (^array-shrink-possibly-copy!
                                         (gvm-state-stack-use ctx 'rd)
                                         (^+ fs 1))))))))

                             (^ (^assign
                                 (^array-index
                                  (gvm-state-stack-use ctx 'rd)
                                  link)
                                 (^array-index
                                  (gvm-state-stack-use ctx 'rd)
                                  (^int 0)))

                                (^assign
                                 (^array-index
                                  (gvm-state-stack-use ctx 'rd)
                                  (^int 0))
                                 ra)

                                (^assign
                                 chain
                                 (^frame-box
                                  (^array-shrink-possibly-copy!
                                   (gvm-state-stack-use ctx 'rd)
                                   (^+ fs 1))))))

                        (if (univ-stack-resizable? ctx)

                            (^assign
                             (gvm-state-stack-use ctx 'rd)
                             (^extensible-array-literal
                              'scmobj
                              (list chain)))

                            (^assign
                             (^array-index
                              (gvm-state-stack-use ctx 'rd)
                              (^int 0))
                             chain))

                        (^assign
                         (gvm-state-sp-use ctx 'wr)
                         0)))))

             (^return
              (^rts-jumpable-use 'underflow)))))))

    ((underflow)
     (univ-jumpable-declaration-defs
      ctx
      #t
      'underflow
      'returnpt
      '()
      (list (univ-field 'id 'int (^int 0) '(inherited))
            (univ-field 'parent 'parententrypt (^null) '(inherited))
            (univ-field 'fs 'int (^int 0) '(inherited))
            (univ-field 'link 'int (^int 0) '(inherited)))
      (univ-emit-fn-body
       ctx
       "\n"
       (lambda (ctx)
         (let ((next (^local-var 'next))
               (frame (^local-var 'frame))
               (ra (^local-var 'ra))
               (fs (^local-var 'fs))
               (link (^local-var 'link)))

           (^ (^var-declaration
               'scmobj
               next
               (^array-index
                (gvm-state-stack-use ctx 'rd)
                (^int 0)))

              (^if (^eq? next (^obj '())) ;; end of continuation?
                   (^return (^null)))

              (^var-declaration
               'frm
               frame
               (^frame-unbox next))

              (^var-declaration
               'returnpt
               ra
               (^cast* 'returnpt
                       (^array-index frame (^int 0))))

              (univ-with-ctrlpt-attribs
               ctx
               #f
               ra
               (lambda ()

                 (^ (^var-declaration
                     'int
                     fs
                     (univ-get-ctrlpt-attrib ctx ra 'fs))

                    (^var-declaration
                     'int
                     link
                     (univ-get-ctrlpt-attrib ctx ra 'link))

                    (if (univ-stack-resizable? ctx)

                        (^assign (gvm-state-stack-use ctx 'wr)
                                 (^copy-array-to-extensible-array
                                  frame
                                  (^+ fs 1)))

                        (^move-array-to-array
                         frame
                         (^int 0)
                         (gvm-state-stack-use ctx 'rd)
                         (^int 0)
                         (^+ fs 1)))

                    (^assign (gvm-state-sp-use ctx 'wr)
                             fs)

                    (^assign (^array-index
                              (gvm-state-stack-use ctx 'rd)
                              (^int 0))
                             (^alias
                              (^array-index frame link)))

                    (^assign (^array-index
                              (gvm-state-stack-use ctx 'rd)
                              link)
                             (^rts-jumpable-use 'underflow)))))

              (^return ra)))))))

    ((continuation_capture1)
     (continuation-capture-procedure 1 #f))

    ((continuation_capture2)
     (continuation-capture-procedure 2 #f))

    ((continuation_capture3)
     (continuation-capture-procedure 3 #f))

    ((continuation_capture4)
     (continuation-capture-procedure 4 #f))

    ((thread_save1)
     (continuation-capture-procedure 1 #t))

    ((thread_save2)
     (continuation-capture-procedure 2 #t))

    ((thread_save3)
     (continuation-capture-procedure 3 #t))

    ((thread_save4)
     (continuation-capture-procedure 4 #t))

    ((continuation_graft_no_winding2)
     (continuation-graft-no-winding-procedure 2 #f))

    ((continuation_graft_no_winding3)
     (continuation-graft-no-winding-procedure 3 #f))

    ((continuation_graft_no_winding4)
     (continuation-graft-no-winding-procedure 4 #f))

    ((continuation_graft_no_winding5)
     (continuation-graft-no-winding-procedure 5 #f))

    ((thread_restore2)
     (continuation-graft-no-winding-procedure 2 #t))

    ((thread_restore3)
     (continuation-graft-no-winding-procedure 3 #t))

    ((thread_restore4)
     (continuation-graft-no-winding-procedure 4 #t))

    ((thread_restore5)
     (continuation-graft-no-winding-procedure 5 #t))

    ((continuation_return_no_winding2)
     (continuation-return-no-winding-procedure 2))

    ((poll)
     (rts-method
      'poll
      '(public)
      'jumpable
      (list (univ-field 'dest 'jumpable))
      "\n"
      '()
      (lambda (ctx)
        (let ((dest (^local-var 'dest)))
          (^ (^assign (gvm-state-pollcount-use ctx 'wr)
                      100)
             (^return dest))))))

    ((build_rest)
     (rts-method
      'build_rest
      '(public)
      'bool
      (list (univ-field 'nrp 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((rest (^local-var 'rest))
              (nrp (^local-var 'nrp)))
          (^ (^var-declaration 'scmobj rest (^null-obj))
             (^if (^< (^getnargs)
                      nrp)
                  (^return (^bool #f)))
             (univ-push-args ctx)
             (^while (^> (^getnargs)
                         nrp)
                     (^ (^pop (lambda (expr)
                                (^assign rest
                                         (^cons expr
                                                rest))))
                        (^inc-by (gvm-state-nargs-use ctx 'rdwr)
                                 -1)))
             (^push rest)
             (univ-pop-args-to-regs ctx 1)
             (^return (^bool #t)))))))

    ((wrong_nargs)
     (rts-method
      'wrong_nargs
      '(public)
      'jumpable
      (list (univ-field 'proc 'jumpable))
      "\n"
      '()
      (lambda (ctx)
        (let ((proc (^local-var 'proc)))
          (^ (^expr-statement
              (^call-prim
               (^rts-method-use 'build_rest)
               0))
             (^setreg 2 (^getreg 1))
             (^setreg 1 proc)
             (^setnargs 2)
             (^return
              (^cast* 'jumpable
                      (^getglo '##raise-wrong-number-of-arguments-exception))))))))

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
     (rts-method
      'prepend_arg1
      '(public)
      #f
      (list (univ-field 'arg1 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((arg1 (^local-var 'arg1))
              (i (^local-var 'i)))
          (^ (^var-declaration 'int i (^int 0))
             (univ-push-args ctx)
             (^push (^null))
             (^while (^< i (^getnargs))
                     (^ (^assign (univ-stk-slot-from-tos ctx i)
                                 (univ-stk-slot-from-tos ctx (^parens (^+ i (^int 1)))))
                        (^inc-by i
                                 1)))
             (^assign (univ-stk-slot-from-tos ctx i)
                      arg1)
             (^inc-by (gvm-state-nargs-use ctx 'rdwr)
                      1)
             (univ-pop-args-to-regs ctx 0))))))

    ((check_procedure_glo)
     (rts-method
      'check_procedure_glo
      '(public)
      'jumpable
      (list (univ-field 'dest 'scmobj)
            (univ-field 'gv 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((dest (^local-var 'dest))
              (gv (^local-var 'gv)))
          (^ (^if (^not (^parens (^procedure? dest)))
                  (^ (^expr-statement
                      (^call-prim
                       (^rts-method-use 'prepend_arg1)
                       gv))
                     (^assign dest
                              (^getglo '##apply-global-with-procedure-check-nary))))
             (^return dest))))))

    ((check_procedure)
     (rts-method
      'check_procedure
      '(public)
      'jumpable
      (list (univ-field 'dest 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((dest (^local-var 'dest)))
          (^ (^if (^not (^parens (^procedure? dest)))
                  (^ (^expr-statement
                      (^call-prim
                       (^rts-method-use 'prepend_arg1)
                       dest))
                     (^assign dest
                              (^getglo '##apply-with-procedure-check-nary))))
             (^return dest))))))

    ((make_subprocedure)
     (rts-method
      'make_subprocedure
      '(public)
      'ctrlpt
      (list (univ-field 'parent 'parententrypt)
            (univ-field 'id 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((parent (^local-var 'parent))
              (id (^local-var 'id)))
          (univ-with-ctrlpt-attribs
           ctx
           #f
           parent
           (lambda ()
             (^return
              (univ-ctrlpt-reference-to-ctrlpt
               ctx
               (^array-index (univ-get-ctrlpt-attrib ctx parent 'ctrlpts)
                             id)))))))))

    ((scmobj)
     (rts-class
      'scmobj
      '(abstract)))

    ((jumpable)
     (rts-class
      'jumpable
      '(abstract) ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      '() ;; instance-fields
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        'jump
        '(public)
        'jumpable
        '()))))

    ((ctrlpt)
     (rts-class
      'ctrlpt
      '(abstract) ;; properties
      'jumpable ;; extends
      '() ;; class-fields
      (list (univ-field 'id 'int #f '(public)) ;; instance-fields
            (univ-field 'parent 'parententrypt #f '(public)))))

    ((returnpt)
     (rts-class
      'returnpt
      '(abstract) ;; properties
      'ctrlpt ;; extends
      '() ;; class-fields
      (list (univ-field 'id 'int #f '(public inherited)) ;; instance-fields
            (univ-field 'parent 'parententrypt #f '(public inherited))
            (univ-field 'fs 'int #f '(public))
            (univ-field 'link 'int #f '(public)))))

    ((entrypt)
     (rts-class
      'entrypt
      '(abstract) ;; properties
      'ctrlpt ;; extends
      '() ;; class-fields
      (list (univ-field 'id 'int #f '(public inherited)) ;; instance-fields
            (univ-field 'parent 'parententrypt #f '(public inherited))
            (univ-field 'nb_closed 'int #f '(public)))))

    ((parententrypt)
     (rts-class
      'parententrypt
      '(abstract) ;; properties
      'entrypt ;; extends
      '() ;; class-fields
      (list (univ-field 'id 'int #f '(public inherited)) ;; instance-fields
            (univ-field 'parent 'parententrypt #f '(public inherited))
            (univ-field 'nb_closed 'int #f '(public inherited))
            (univ-field (univ-proc-name-attrib ctx) 'symbol #f '(public))
            (univ-field 'ctrlpts '(array ctrlpt) #f '(public))
            (univ-field 'info 'scmobj #f '(public)))))

    ((closure)
     (rts-class
      'closure
      '() ;; properties
      (if (eq? (univ-procedure-representation ctx) 'class) ;; extends
          'jumpable
          'scmobj) ;; for PHP when using repr-procedure = host
      '() ;; class-fields
      (list (univ-field 'slots '(array scmobj) #f '(public))) ;; instance-fields
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (if (eq? (univ-procedure-representation ctx) 'class)
            'jump
            '__invoke) ;; for PHP when using repr-procedure = host
        '(public)
        'jumpable
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (lambda (ctx)
           (^ (^setreg (+ univ-nb-arg-regs 1) (^this))
              (^return
               (^cast* 'jumpable
                       (^array-index (^member (^this) 'slots) (^int 0)))))))))))

    ((closure_alloc)
     (let ()

       (define (class-based-closure-alloc-method)
         (rts-method
          'closure_alloc
          '(public)
          'closure
          (list (univ-field 'slots '(array scmobj)))
          "\n"
          '()
          (lambda (ctx)
            (let ((slots (^local-var 'slots)))
              (^return (^new (^type 'closure)
                             slots))))))

       (case (univ-procedure-representation ctx)

         ((class)
          (class-based-closure-alloc-method))

         (else
          (case (target-name (ctx-target ctx))

            ((php)
             (class-based-closure-alloc-method))

            (else
             (rts-method
              'closure_alloc
              '(public)
              'scmobj
              (list (univ-field 'slots 'scmobj))
              "\n"
              '()
              (lambda (ctx)
                (let ((msg (^local-var 'msg))
                      (slots (^local-var 'slots))
                      (closure 'closure))
                  (^ (^procedure-declaration
                      #f
                      'closure
                      closure
                      (list (univ-field 'msg 'bool (^bool #t)))
                      "\n"
                      '()
                      (^ (^if (^= msg (^bool #t))
                              (^return slots))
                         (^setreg (+ univ-nb-arg-regs 1) (^prefix closure))
                         (^return (^array-index slots (^int 0)))))
                     (^return (^prefix closure))))))))))))

    ((make_closure)
     (rts-method
      'make_closure
      '(public)
      'scmobj
      (list (univ-field 'code 'ctrlpt)
            (univ-field 'leng 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((code (^local-var 'code))
              (leng (^local-var 'leng))
              (slots (^local-var 'slots)))
          (^ (^var-declaration
              '(array scmobj)
              slots
              (^new-array 'scmobj (^+ leng (^int 1))))
             (^assign (^array-index slots (^int 0)) code)
             (^return
              (^call-prim
               (^rts-method-use 'closure_alloc)
               slots)))))))

    ((promise)
     (rts-class
      'promise
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'thunk 'scmobj #f '(public)) ;; instance-fields
            (univ-field 'result 'scmobj (^this) '(public)))))

    ((will)
     (rts-class
      'will
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'testator 'scmobj #f '(public)) ;; instance-fields
            (univ-field 'action 'scmobj #f '(public)))))

    ((fixnum)
     (rts-class
      'fixnum
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'val 'int #f '(public))) ;; instance-fields
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (univ-tostr-method-name ctx)
        '(public)
        'str
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (let ((val (^member (^this) 'val)))
           (case (target-name (ctx-target ctx))

             ((js php python ruby)
              (lambda (ctx)
                (^return (^tostr val))))

             ((java)
              (lambda (ctx)
                (^return (^call-prim (^member 'String 'valueOf) val))))

             (else
              (compiler-internal-error
               "univ-rtlib-feature fixnum, unknown target")))))))))

    ((make_fixnum)
     (rts-method
      'make_fixnum
      '(public)
      'fixnum
      (list (univ-field 'n 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n)))
          (^if (^&& (^>= n (^int 0))
                    (^< n (^int 257)))
               (^return (^array-index (^rts-field-use 'fixnum_table) n))
               (^return (^new (^type 'fixnum) n)))))))

    ((fixnum_table)
     (rts-field
      'fixnum_table
      '(array fixnum)
      (^call-prim (^rts-method-use 'make_fixnum_table))))

    ((make_fixnum_table)
     (rts-method
      'make_fixnum_table
      '()
      '(array fixnum)
      '()
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n))
              (tab (^local-var 'tab)))
          (^ (^var-declaration
              '(array fixnum)
              tab
              (^new-array 'fixnum
                          (^int (+ (- (univ-max-fixnum ctx)
                                      (univ-min-fixnum ctx))
                                   1))))
             (^var-declaration
              'int
              n
              (^int (univ-min-fixnum ctx)))
             (^while (^<= n (^int (univ-max-fixnum ctx)))
                     (^ (^assign (^array-index tab n)
                                 (^new (^type 'fixnum)
                                       (^+ (^int (univ-min-fixnum ctx)) n)))
                        (^inc-by n 1)))
             (^return tab))))))

    ((flonum)
     (rts-class
      'flonum
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'val 'f64 #f '(public))) ;; instance-fields
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (univ-tostr-method-name ctx)
        '(public)
        'str
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (let ((val (^member (^this) 'val)))
           (case (target-name (ctx-target ctx))

             ((js php python ruby)
              (lambda (ctx)
                (^return (^tostr val))))

             ((java)
              (lambda (ctx)
                (^return (^call-prim (^member 'String 'valueOf) val))))

             (else
              (compiler-internal-error
               "univ-rtlib-feature flonum, unknown target")))))))))

    ((bignum)
     (rts-class
      'bignum
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'digits '(array bigdigit) #f '(public))))) ;; instance-fields

    ((bitcount)
     (rts-method
      'bitcount
      '(public)
      'int
      (list (univ-field 'n 'int))
      "\n"
      '()
      (lambda (ctx)
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
             (^return (^bitand n (^int #xff))))))))

    ((intlength)
     (rts-method
      'intlength
      '(public)
      'int
      (list (univ-field 'n 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n)))
          (^ (^if (^< n (^int 0)) (^assign n (^bitnot n)))
             (^assign n (^bitior n (^parens (^>> n 1))))
             (^assign n (^bitior n (^parens (^>> n 2))))
             (^assign n (^bitior n (^parens (^>> n 4))))
             (^assign n (^bitior n (^parens (^>> n 8))))
             (^assign n (^bitior n (^parens (^>> n 16))))
             (^return (^call-prim
                       (^rts-method-use 'bitcount)
                       n)))))))

    ((bignum_make)
     (rts-method
      'bignum_make
      '(public)
      'scmobj
      (list (univ-field 'n 'int)
            (univ-field 'x 'scmobj)
            (univ-field 'complement 'bool))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n))
              (x (^local-var 'x))
              (complement (^local-var 'complement))
              (flip (^local-var 'flip))
              (nbdig (^local-var 'nbdig))
              (digits (^local-var 'digits))
              (i (^local-var 'i)))
          (^ (^var-declaration
              'int
              i
              (^int 0))
             (^var-declaration
              '(array bigdigit)
              digits
              (^new-array 'bigdigit n))
             (^var-declaration
              'int
              nbdig
              (^if-expr
               (^eq? x (^obj #f))
               (^int 0)
               (^array-length (^bignum-digits x))))
             (^var-declaration
              'bigdigit
              flip
              (^cast* 'bigdigit
                      (^if-expr complement (^int 16383) (^int 0))))
             (^if (^< n nbdig)
                  (^assign nbdig n))
             (^while (^< i nbdig)
                     (^ (^assign (^array-index digits i)
                                 (^cast* 'bigdigit
                                         (^bitxor (^array-index (^bignum-digits x) i)
                                                  flip)))
                        (^inc-by i 1)))
             (^if (^and (^not (^parens (^eq? x (^obj #f))))
                        (^> (^array-index (^bignum-digits x) (^- i (^int 1)))
                            (^int 8191)))
                  (^assign flip
                           (^cast* 'bigdigit
                                   (^bitxor flip (^int 16383)))))
             (^while (^< i n)
                     (^ (^assign (^array-index digits i)
                                 flip)
                        (^inc-by i 1)))
             (^return
              (^new (^type 'bignum)
                    digits)))))))

    ((int2bignum)
     (rts-method
      'int2bignum
      '(public)
      'scmobj
      (list (univ-field 'n 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n))
              (nbdig (^local-var 'nbdig))
              (digits (^local-var 'digits))
              (i (^local-var 'i)))
          (^ (^var-declaration
              'int
              nbdig
              (^+ (^parens
                   (univ-fxquotient
                    ctx
                    (^call-prim
                     (^rts-method-use 'intlength)
                     n)
                    (^int 14)))
                  (^int 1)))
             (^var-declaration
              '(array bigdigit)
              digits
              (^new-array 'bigdigit nbdig))
             (^var-declaration
              'int
              i
              (^int 0))
             (^while (^< i nbdig)
                     (^ (^assign (^array-index digits i)
                                 (^cast* 'bigdigit
                                         (^bitand n (^int 16383))))
                        (^assign n
                                 (^>> n (^int 14)))
                        (^inc-by i 1)))
             (^return
              (^new (^type 'bignum)
                    digits)))))))

    ((ratnum)
     (rts-class
      'ratnum
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'num 'scmobj #f '(public)) ;; instance-fields
            (univ-field 'den 'scmobj #f '(public)))))

    ((cpxnum)
     (rts-class
      'cpxnum
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'real 'scmobj #f '(public)) ;; instance-fields
            (univ-field 'imag 'scmobj #f '(public)))))

    ((pair)
     (rts-class
      'pair
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'car 'scmobj #f '(public)) ;; instance-fields
            (univ-field 'cdr 'scmobj #f '(public)))))

    ((vector)
     (rts-class
      'vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array scmobj) #f '(public))))) ;; instance-fields

    ((u8vector)
     (rts-class
      'u8vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array u8) #f '(public))))) ;; instance-fields

    ((u16vector)
     (rts-class
      'u16vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array u16) #f '(public))))) ;; instance-fields

    ((f64vector)
     (rts-class
      'f64vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array f64) #f '(public))))) ;; instance-fields

    ((structure)
     (rts-class
      'structure
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'slots '(array scmobj) #f '(public))) ;; instance-fields
      '() ;; class-methods
      '() ;; instance-methods
      '() ;; class-classes
      (lambda (ctx) ;; constructor
        ;; correctly construct type descriptor of type descriptors
        (let ((slots (^local-var (univ-field-param ctx 'slots))))
          (^if (^eq? (^array-index slots (^int 0)) (^null))
               (^assign (^array-index slots (^int 0))
                        (^this)))))))

    ((frame)
     (rts-class
      'frame
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'slots '(array scmobj) #f '(public))))) ;; instance-fields

    ((make_frame)
     (rts-method
      'make_frame
      '(public)
      'frame
      (list (univ-field 'ra 'returnpt))
      "\n"
      '()
      (lambda (ctx)
        (let ((ra (^local-var 'ra))
              (fs (^local-var 'fs))
              (slots (^local-var 'slots)))
          (^ (univ-with-ctrlpt-attribs
              ctx
              #f
              ra
              (lambda ()
                (^var-declaration
                 'int
                 fs
                 (univ-get-ctrlpt-attrib ctx ra 'fs))))
             (^var-declaration
              '(array scmobj)
              slots
              (^new-array 'scmobj (^+ fs (^int 1))))
             (^assign (^array-index slots (^int 0)) ra)
             (^return
              (^frame-box slots)))))))

    ((continuation)
     (rts-class
      'continuation
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'frame 'frame #f '(public)) ;; instance-fields
            (univ-field 'denv 'scmobj #f '(public)))))

    ((continuation_next)
     (rts-method
      'continuation_next
      '(public)
      'scmobj
      (list (univ-field 'cont 'continuation))
      "\n"
      '()
      (lambda (ctx)
        (let ((cont (^local-var 'cont))
              (frame (^local-var 'frame))
              (denv (^local-var 'denv))
              (ra (^local-var 'ra))
              (link (^local-var 'link))
              (next_frame (^local-var 'next_frame)))
          (^ (^var-declaration
              'frm
              frame
              (^member cont 'frame))
             (^var-declaration
              'scmobj
              denv
              (^member cont 'denv))
             (^var-declaration
              'returnpt
              ra
              (^array-index (^frame-unbox frame) (^int 0)))
             (univ-with-ctrlpt-attribs
              ctx
              #f
              ra
              (lambda ()
                (^var-declaration
                 'int
                 link
                 (univ-get-ctrlpt-attrib ctx ra 'link))))
             (^var-declaration
              'frm
              next_frame
              (^array-index (^frame-unbox frame)
                            link))
             (^if (^eq? next_frame (^obj '())) ;; end of continuation marker
                  (^return (^obj #f))
                  (^return
                   (^new-continuation next_frame denv))))))))

    ((str_hash)
     (rts-method
      'str_hash
      '(public)
      'int
      (list (univ-field 'strng 'str))
      "\n"
      '()
      (lambda (ctx)
        (let ((strng (^local-var 'strng))
              (h (^local-var 'h))
              (i (^local-var 'i))
              (leng (^local-var 'leng)))
          (^ (^var-declaration 'int h (^int 0))
             (^var-declaration 'int i (^int 0))
             (^var-declaration 'int leng (^str-length strng))
             (^while (^< i leng)
                     (^ (^assign h
                                 (^bitand
                                  (^parens
                                   (^* (^parens (^+ (^parens (^>> h 8))
                                                    (^str-index-code strng i)))
                                       (^int 331804471)))
                                  (^int univ-fixnum-max)))
                        (^inc-by i 1)))
             (^return h))))))

    ((symbol)
     (rts-class
      'symbol
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'name 'str #f '(public)) ;; instance-fields
            (univ-field 'hash 'scmobj #f '(public))
            (univ-field 'interned 'scmobj (^obj #f) '(public)))
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (univ-tostr-method-name ctx)
        '(public)
        'str
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (lambda (ctx)
           (^return (^member (^this) 'name))))))))

    ((make_interned_symbol)
     (rts-method
      'make_interned_symbol
      '(public)
      'symbol
      (list (univ-field 'name 'str))
      "\n"
      '()
      (lambda (ctx)
        (let ((name (^local-var 'name))
              (obj (^local-var 'obj)))
          (^ (^var-declaration
              'symbol
              obj
              (^dict-get (^rts-field-use 'symbol_table)
                         name
                         (^null)))
             (^if (^eq? obj (^null))
                  (^ (^assign obj
                              (^symbol-box-uninterned
                               name
                               (^fixnum-box
                                (^call-prim
                                 (^rts-method-use 'str_hash)
                                 name))))
                     (^dict-set (^rts-field-use 'symbol_table)
                                name
                                obj)))
             (^return obj))))))

    ((symbol_table)
     (rts-field
      'symbol_table
      '(dict str symbol)
      (^empty-dict)))

    ((keyword)
     (rts-class
      'keyword
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'name 'str #f '(public)) ;; instance-fields
            (univ-field 'hash 'scmobj #f '(public))
            (univ-field 'interned 'scmobj (^obj #f) '(public)))
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (univ-tostr-method-name ctx)
        '(public)
        'str
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (lambda (ctx)
           (^return (^member (^this) 'name))))))))

    ((make_interned_keyword)
     (rts-method
      'make_interned_keyword
      '(public)
      'keyword
      (list (univ-field 'name 'str))
      "\n"
      '()
      (lambda (ctx)
        (let ((name (^local-var 'name))
              (obj (^local-var 'obj)))
          (^ (^var-declaration
              'keyword
              obj
              (^dict-get (^rts-field-use 'keyword_table)
                         name
                         (^null)))
             (^if (^eq? obj (^null))
                  (^ (^assign obj
                              (^keyword-box-uninterned
                               name
                               (^fixnum-box
                                (^call-prim
                                 (^rts-method-use 'str_hash)
                                 name))))
                     (^dict-set (^rts-field-use 'keyword_table)
                                name
                                obj)))
             (^return obj))))))

    ((keyword_table)
     (rts-field
      'keyword_table
      '(dict str keyword)
      (^empty-dict)))

    ((box)
     (rts-class
      'box
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'val 'scmobj #f '(public))))) ;; instance-fields

    ((values)
     (rts-class
      'values
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'vals '(array scmobj) #f '(public))))) ;; instance-fields

    ((null)
     (rts-class
      'null
      '() ;; properties
      'scmobj)) ;; extends

    ((null_obj)
     (rts-field
      'null_obj
      'null
      (^new (^type 'null))
      '(public)))

    ((void)
     (rts-class
      'void
      '() ;; properties
      'scmobj)) ;; extends

    ((void_obj)
     (rts-field
      'void_obj
      'void
      (^new (^type 'void))
      '(public)))

    ((eof)
     (rts-class
      'eof
      '() ;; properties
      'scmobj)) ;; extends

    ((eof_obj)
     (rts-field
      'eof_obj
      'eof
      (^new (^type 'eof))
      '(public)))

    ((absent)
     (rts-class
      'absent
      '() ;; properties
      'scmobj)) ;; extends

    ((absent_obj)
     (rts-field
      'absent_obj
      'absent
      (^new (^type 'absent))
      '(public)))

    ((unbound)
     (rts-class
      'unbound
      '() ;; properties
      'scmobj)) ;; extends

    ((unbound1_obj)
     (rts-field
      'unbound1_obj
      'unbound
      (^new (^type 'unbound))
      '(public)))

    ((unbound2_obj)
     (rts-field
      'unbound2_obj
      'unbound
      (^new (^type 'unbound))
      '(public)))

    ((optional)
     (rts-class
      'optional
      '() ;; properties
      'scmobj)) ;; extends

    ((optional_obj)
     (rts-field
      'optional_obj
      'optional
      (^new (^type 'optional))
      '(public)))

    ((key)
     (rts-class
      'key
      '() ;; properties
      'scmobj)) ;; extends

    ((key_obj)
     (rts-field
      'key_obj
      'key
      (^new (^type 'key))
      '(public)))

    ((rest)
     (rts-class
      'rest
      '() ;; properties
      'scmobj)) ;; extends

    ((rest_obj)
     (rts-field
      'rest_obj
      'rest
      (^new (^type 'rest))
      '(public)))

    ((boolean)
     (rts-class
      'boolean
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'val 'bool #f '(public))))) ;; instance-fields

    ((false_obj)
     (rts-field
      'false_obj
      'boolean
      (^new (^type 'boolean) (^bool #f))
      '(public)))

    ((true_obj)
     (rts-field
      'true_obj
      'boolean
      (^new (^type 'boolean) (^bool #t))
      '(public)))

    ((char)
     (rts-class
      'char
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'code 'unicode #f '(public))) ;; instance-fields
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (univ-tostr-method-name ctx)
        '(public)
        'str
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (case (target-name (ctx-target ctx))

           ((js)
            (lambda (ctx)
              (^return
               (^call-prim
                (^member 'String 'fromCharCode)
                (^member (^this) 'code)))))

           ((php python)
            (lambda (ctx)
              (^return
               (^call-prim
                "chr"
                (^member (^this) 'code)))))

           ((ruby)
            (lambda (ctx)
              (^return
               (^call-prim
                (^member
                 (^member (^this) 'code)
                 'chr)))))

           ((java)
            (lambda (ctx)
              (^return
               (^call-prim
                (^member 'String 'valueOf)
                (^cast* 'chr
                        (^member (^this) 'code))))))

           (else
            (compiler-internal-error
             "univ-rtlib-feature char, unknown target"))))))))

    ((make_interned_char)
     (rts-method
      'make_interned_char
      '(public)
      'char
      (list (univ-field 'code 'unicode))
      "\n"
      '()
      (lambda (ctx)
        (let ((code (^local-var 'code))
              (obj (^local-var 'obj)))
          (^ (^var-declaration
              'char
              obj
              (^dict-get (^rts-field-use 'char_table)
                         code
                         (^null)))
             (^if (^eq? obj (^null))
                  (^ (^assign obj
                              (^char-box-uninterned code))
                     (^dict-set (^rts-field-use 'char_table)
                                code
                                obj)))
             (^return obj))))))

    ((char_table)
     (rts-field
      'char_table
      '(dict int char)
      (^empty-dict)))

    ((string)
     (rts-class
      'string
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'codes '(array unicode) #f '(public))) ;; instance-fields
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (univ-tostr-method-name ctx)
        '(public)
        'str
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (case (target-name (ctx-target ctx))

           ((js)
            (lambda (ctx)
              (let ((codes (^member (^this) 'codes))
                    (limit (^local-var 'limit))
                    (chunks (^local-var 'chunks))
                    (i (^local-var 'i)))
                (^ (^var-declaration 'int limit (^int 32768))
                   (^if (^< (^array-length codes) limit)
                        (^return
                         (^call-prim
                          (^member (^member "String" 'fromCharCode) 'apply)
                          "null"
                          codes))
                        (^ (^var-declaration 'object chunks (^array-literal 'object '()))
                           (^var-declaration 'int i (^int 0))
                           (^while (^< i (^array-length codes))
                                   (^ (^expr-statement
                                       (^call-prim
                                        (^member chunks 'push)
                                        (^call-prim
                                         (^member (^member "String" 'fromCharCode) 'apply)
                                         "null"
                                         (^call-prim
                                          (^member codes 'slice)
                                          i
                                          (^+ i limit)))))
                                      (^inc-by i limit)))
                           (^return
                            (^call-prim
                             (^member chunks 'join)
                             (^str "")))))))))

           ((php)
            (lambda (ctx)
              (^return
               (^call-prim
                "join"
                (^call-prim
                 "array_map"
                 (^str "chr")
                 (^member (^this) 'codes))))))

           ((python)
            (lambda (ctx)
              (^return
               (^call-prim
                (^member (^str "") 'join)
                (^call-prim
                 "map"
                 "chr"
                 (^member (^this) 'codes))))))

           ((ruby)
            ;;TODO: add anonymous function
            (lambda (ctx)
              (^return
               (^call-prim
                (^member
                 (^ (^member (^member (^this) 'codes) 'map)
                    " {|x| x.chr}")
                 'join)))))

           ((java)
            (lambda (ctx)
;;TODO: clean up
"
    char c[] = new char[codes.length];
    for (int i=0; i<codes.length; i++) c[i] = (char)codes[i];
    return String.valueOf(c);
"))

           (else
            (compiler-internal-error
             "univ-rtlib-feature string, unknown target"))))))))

    ((tostr)
     (rts-method
      'tostr
      '(public)
      'str
      (list (univ-field 'obj 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((obj (^local-var 'obj)))
          (^if (^eq? obj (^obj #f))
               (^return (^str "#f"))
               (^if (^eq? obj (^obj #t))
                    (^return (^str "#t"))
                    (^if (^eq? obj (^obj '()))
                         (^return (^str ""))
                         (^if (^eq? obj (^void-obj))
                              (^return (^str "#!void"))
                              (^if (^eq? obj (^eof))
                                   (^return (^str "#!eof"))
                                   (^if (^pair? obj)
                                        (^return (^concat
                                                  (^call-prim
                                                   (^rts-method-use 'tostr)
                                                   (^getcar obj))
                                                  (^call-prim
                                                   (^rts-method-use 'tostr)
                                                   (^getcdr obj))))
                                        (^return (^tostr obj))))))))))))

    ((println)
     (rts-method
      'println
      '(public)
      'noresult
      (list (univ-field 'obj 'str))
      "\n"
      '()
      (lambda (ctx)
        (let ((obj (^local-var 'obj)))
          (case (target-name (ctx-target ctx))
            ((js)
             (^if (^prop-index-exists?
                   "function () {return this;}()"
                   (^str "console"))
                  (^expr-statement
                   (^call-prim (^member (^global-var 'console) 'log)
                               obj))
                  (^expr-statement
                   (^call-prim "print"
                               obj))))
            ((python)
             (^expr-statement (^call-prim "print" obj)))
            ((ruby php)
             (^ (^expr-statement (^call-prim "print" obj))
                (^expr-statement (^call-prim "print" "\"\\n\""))))
            ((java)
             (^expr-statement (^call-prim (^member (^member 'System 'out) 'println) obj)))
            (else
             (compiler-internal-error
              "univ-rtlib-feature println, unknown target")))))))

    ((glo-println)
     (univ-defs-combine
      (univ-jumpable-declaration-defs
       ctx
       #t
       (gvm-proc-use ctx "println")
       'entrypt
       '()
       '()
       (univ-emit-fn-body
        ctx
        "\n"
        (lambda (ctx)
          (^ (^expr-statement
              (^call-prim
               (^rts-method-use 'println)
               (^call-prim
                (^rts-method-use 'tostr)
                (^getreg 1))))
             (^setreg 1 (^void-obj))
             (^return
              (^cast* 'jumpable
                      (^getreg 0)))))))
      (rts-init
       (lambda (ctx)
         (^setglo 'println
                  (^this-mod-jumpable
                   (gvm-proc-use ctx "println")))))))

    ((glo-real-time-milliseconds)
     (univ-defs-combine
      (univ-jumpable-declaration-defs
       ctx
       #t
       (gvm-proc-use ctx "real-time-milliseconds")
       'entrypt
       '()
       '()
       (univ-emit-fn-body
        ctx
        "\n"
        (lambda (ctx)
          (^ (case (target-name (ctx-target ctx))

               ((js java)
                (^setreg 1
                         (^fixnum-box
                          (^cast* 'int
                                  (^parens
                                   (^- (univ-get-time ctx)
                                       (^rts-field-use 'start_time)))))))

               ((python php ruby)
                (^setreg 1
                         (^fixnum-box
                          (^float-toint
                           (^* 1000
                               (^parens
                                (^- (univ-get-time ctx)
                                    (^rts-field-use 'start_time))))))))

               (else
                (compiler-internal-error
                 "univ-rtlib-feature glo-real-time-milliseconds, unknown target")))
             (^return
              (^cast* 'jumpable
                      (^getreg 0)))))))
      (rts-init
       (lambda (ctx)
         (^setglo 'real-time-milliseconds
                  (^this-mod-jumpable
                   (gvm-proc-use ctx "real-time-milliseconds")))))))

    ((start_time)
     (rts-field
      'start_time
      'long
      (univ-get-time ctx)))

    ((str2codes)
     (rts-method
      'str2codes
      '(public)
      '(array unicode)
      (list (univ-field 'strng 'str))
      "\n"
      '()
      (lambda (ctx)
        (let ((strng (^local-var 'strng)))
          (case (target-name (ctx-target ctx))

            ((js)
             (^
;;TODO: clean up
"
    var codes = [];
    for (var i=0; i < " strng ".length; i++) {
        codes.push(" strng ".charCodeAt(i));
    }
    return codes;
"))

            ((php)
             (^return (^ "array_slice(unpack('c*'," strng "),0)")))

            ((python)
             (^return (^ "[ord(c) for c in " strng "]")))

            ((ruby)
             (^return (^ strng ".unpack('U*')")))

            ((java)
             (^
;;TODO: clean up
"
    int codes[] = new int[" strng ".length()];
    for (int i=0; i < " strng ".length(); i++) {
        codes[i] = " strng ".codePointAt(i);
    }
    return codes;
"))

            (else
             (compiler-internal-error
              "univ-rtlib-feature str2codes, unknown target")))))))

    ((make_values)
     (rts-method
      'make_values
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'scmobj
         (lambda (result) (^return (^values-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_vector)
     (rts-method
      'make_vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'scmobj
         (lambda (result) (^return (^vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_u8vector)
     (rts-method
      'make_u8vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'u8))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'u8
         (lambda (result) (^return (^u8vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_u16vector)
     (rts-method
      'make_u16vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'u16))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'u16
         (lambda (result) (^return (^u16vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_f64vector)
     (rts-method
      'make_f64vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'f64))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'f64
         (lambda (result) (^return (^f64vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_string)
     (rts-method
      'make_string
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'unicode))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'unicode
         (lambda (result) (^return (^string-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_structure)
     (rts-method
      'make_structure
      '(public)
      'scmobj
      (list (univ-field 'type 'scmobj)
            (univ-field 'leng 'int))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'scmobj
         (lambda (result) (^return (^structure-box result)))
         (^local-var 'leng)
         (^local-var 'type)))))

    ((make_glo_var)
     (rts-method
      'make_glo_var
      '(public)
      'symbol
      (list (univ-field 'sym 'symbol))
      "\n"
      '()
      (lambda (ctx)
        (let ((sym (^local-var 'sym)))
          (^ (^if (^not (^prop-index-exists? (gvm-state-glo-use ctx 'rd)
                                             (^symbol-unbox sym)))
                  (^ (^glo-var-set! sym (^unbound1))
                     (^glo-var-primitive-set! sym (^unbound1))))
             (^return sym))))))

    ((apply2)
     (apply-procedure 2))

    ((apply3)
     (apply-procedure 3))

    ((apply4)
     (apply-procedure 4))

    ((apply5)
     (apply-procedure 5))

    ((host_function2scm)
     (rts-method
      'host_function2scm
      '(public)
      'object
      (list (univ-field 'obj 'object))
      "\n"
      '()
      (lambda (ctx)
       (let ((obj (^local-var "obj"))
             (host_function_closure (^local-var "host_function_closure")))
        (^ 
            (^prim-function-declaration
            "host_function_closure"
            'object
            '() 
            "\n"
            '()
            (^return-call-prim 
              (^rts-method (univ-use-rtlib ctx 'scm2host_call))
              obj))
           (^return host_function_closure))))))

    ((host2scm)
     (rts-method
      'host2scm
      '(public)
      'scmobj
      (list (univ-field 'obj 'object))
      "\n"
      '()
      (lambda (ctx)
        (let ((obj (^local-var 'obj))
              (alist (^local-var 'alist))
              (key (^local-var 'key)))
          (^
           (if (eq? (target-name (ctx-target ctx)) 'js)
               (^if (^void? obj)
                    (^return (^void-obj)))
               (^))

           (^if (^null? obj)
                (if (and (eq? (univ-void-representation ctx) 'host)
                         ; Javascript has a native "void" in "undefined".
                         (not (eq? (target-name (ctx-target ctx)) 'js)))
                    (^return (^void-obj))
                    (^return (^null-obj))))

           (^if (^bool? obj)
                (^return (^boolean-box obj)))

           (case (target-name (ctx-target ctx))
            ((js)
             (^if (^typeof "number" obj)
                  (^if (^and (^eq? (^parens (^bitior obj 0)) obj)
                             (^and (^>= obj -536870912)
                                   (^<= obj 536870911)))
                       (^return (^fixnum-box obj))
                       (^return (^flonum-box obj)))))
            (else
             (^ (^if (^and (^int? obj)
                           (^and (^>= obj -536870912)
                                 (^<= obj 536870911)))
                     (^return (^fixnum-box obj)))
                (^if (^float? obj)
                     (^return (^flonum-box obj))))))

           (^if (^float? obj)
                (^return (^flonum-box obj)))

           (case (target-name (ctx-target ctx))
            ((php)
             (^ ))
            (else
             (^if (^function? obj)
                  (^return-call-prim 
                   (^rts-method (univ-use-rtlib ctx 'host_function2scm))
                   obj))))

           (^if (^str? obj)
                (^return (^string-box (^str-to-codes obj))))

           ; TODO: generalise for python, java, ruby and php
           (^if (^typeof "object" obj)
                (^if (^instanceof "Array" obj)
                     (^return (^map (^rts-method (univ-use-rtlib ctx 'js2scm)) obj))
                     (^
                       (^var-declaration '() alist (^null-obj))
                       "for (var " key " in " obj ") {\n"
                           (^assign alist (^cons (^cons (^call-prim
                                                        (^rts-method (univ-use-rtlib ctx 'js2scm))
                                                        key)
                                                       (^call-prim
                                                        (^rts-method (univ-use-rtlib ctx 'js2scm))
                                                        (^array-index obj key)))
                                                alist))
                       "}\n"                       
                       (^return alist))))
            ;; Handle scheme objects represented as classes.
#;
           (case (univ-void-representation ctx)
            ((host) (^))
            ((class)
             (^if (^void? obj)
                  (^return obj))))
#;
           (case (univ-null-representation ctx)
            ((host) (^))
            ((class)
             (^if (^null? obj)
               (^return obj))))
#;
           (case (univ-boolean-representation ctx)
            ((host) (^))
            ((class)
             (^if (^boolean? obj)
                  (^return obj))))
#;
           (case (univ-string-representation ctx)
            ((host) (^))
            ((class)
             (^if (^string? obj)
                  (^return obj))))
#;
           (case (univ-fixnum-representation ctx)
            ((host) (^))
            ((class)
             (^if (^fixnum? obj)
                  (^return obj))))
#;
           (case (univ-flonum-representation ctx)
            ((host) (^))
            ((class)
             (^if (^flonum? obj)
                  (^return obj))))
#;
           (case (univ-procedure-representation ctx)
            ((host) (^))
            ((class)
             (^if (^procedure? obj)
               (^return obj))))

           (univ-throw ctx "\"Gambit_host2scm error\""))))))

    ((host2scm_call)
     (rts-method
      'host2scm_call
      '(public)
      'object
      (list (univ-field 'proc 'scmobj)
            (univ-field 'args 'scmobj))
      "\n"
      '()
      (lambda (ctx)
       (let ((args (^local-var "args"))
             (i (^local-var "i"))
             (proc (^local-var "proc")))
         (^ 
            (^assign (gvm-state-sp-use ctx 'wr) -1)
            (^push (^null-obj))
            (^assign (^getnargs) (^array-length args))
            (^assign i 0)
            (^while (^< i (^getnargs))
              (^ (^push
                   (^call-prim (^rts-method (univ-use-rtlib ctx 'host2scm))
                               (^array-index args i)))
                 (^inc-by i 1)))
            (univ-pop-args-to-regs ctx 0)
            (^assign (^getreg 0) (^rts-method (univ-use-rtlib ctx 'underflow)))
            (^expr-statement
              (^call-prim (^rts-method (univ-use-rtlib ctx 'trampoline))
                          proc))
            (^return-call-prim (^rts-method(univ-use-rtlib ctx 'scm2host))
                               (^getreg 1)))))))

    ((scm_procedure2host)
     (rts-method
      'scm_procedure2host
      '(public)
      'object
      (list (univ-field 'obj 'scmobj))
      "\n"
      '()
      (lambda (ctx)
       (let ((obj (^local-var "obj"))
             (arguments  (^local-var "arguments"))
             (scm_procedure (^local-var "scm_procedure")))
         (^
          (^prim-function-declaration
           "scm_procedure"                              ;name
           'object
           (case (target-name (ctx-target ctx))         ;argument
            ((js php) '())
            ((python ruby) `(("*arguments" . #f))))
           "\n"                                         ;header
           (^)                                          ;attribs
           (^ (case (target-name (ctx-target ctx))      ;body
               ((php)
                (^var-declaration '() arguments (^call-prim "func_get_args")))
               (else ""))
              (^return 
               (^call-prim (^rts-method (univ-use-rtlib ctx 'host2scm_call))
                           obj
                           arguments))))
            (^return scm_procedure))))))

    ((scm2host)
     (rts-method
      'scm2host
      '(public)
      'object
      (list (univ-field 'obj 'scmobj))
      "\n"
      '()
      (lambda (ctx)
       (let ((obj (^local-var "obj")))
         (^
          (^if (^void? obj)
            (case (univ-void-representation ctx)
             ((host) (^return obj))
             ((class)
              (^return (case (target-name (ctx-target ctx))
                        ((js) (^void))
                        (else (^null)))))))

          (^if (^null? obj)
               (case (univ-null-representation ctx)
                ((host) (^return obj))
                ((class)
                 (^return (case (target-name (ctx-target ctx))
                           ((js) (^null))
                           (else obj)))))) 
 
          (^if (^boolean? obj)
               (^return (^boolean-unbox obj)))

          (^if (^fixnum? obj)
               (^return (^fixnum-unbox obj)))

          (^if (^flonum? obj)
               (^return (^flonum-unbox obj)))

          (^if (^string? obj)
               (case (univ-string-representation ctx)
                ((class)
                 (^return (^tostr obj)))
                ((host)
                 (^return obj))))

          ; TODO: generalise for python, ruby, php and java
          (^if (^instanceof "Array" obj)
               (^return (^map (^rts-method (univ-use-rtlib ctx 'scm2host)) obj)))
          
          ; TODO: generalise for python, ruby, php and java
          (^if (^pair? obj)
               (let ((jsobj (^local-var "jsobj"))
                     (i (^local-var "i"))
                     (elem (^local-var "elem")))

                 (^
                   (^var-declaration '() jsobj "{}")
                   (^var-declaration 'int i (^int 0))
                   (^while (^pair? obj)
                     (^ (^var-declaration '() elem (^getcar obj))
                        (^if (^pair? elem)
                             (^assign
                               (^array-index
                                obj
                                (^call-prim
                                 (^rts-method (univ-use-rtlib ctx 'scm2host))
                                 (^getcar elem)))
                               (^call-prim
                                (^rts-method (univ-use-rtlib ctx 'scm2host))
                                (^getcdr elem)))
                             (^assign
                               (^array-index obj i)
                               (^call-prim
                                (^rts-method (univ-use-rtlib ctx 'scm2host))
                                elem)))
                        (^inc-by i 1)
                        (^assign obj (^getcdr obj))))
                   (^return jsobj))))

           (^if (^structure? obj)
                (univ-throw ctx "\"Gambit.scm2js error (cannot convert Structure)\""))

          (case (target-name (ctx-target ctx))
           ((php) (^))
           (else
            (^if (^procedure? obj)
                 (^return-call-prim
                   (^rts-method (univ-use-rtlib ctx 'scm_procedure2host))
                   obj))))

          (univ-throw ctx "\"Gambit_scm2host error\""))))))

    ((scm2host_call)
     (rts-method
      'scm2host_call
      '(public)
      'jumpable
      (list (univ-field 'fn 'object))
      "\n"
      '()
      (lambda (ctx)
       (let ((args (^local-var "args"))
             (ra (^local-var "ra"))
             (frame (^local-var "frame"))
             (tmp (^local-var "tmp"))
             (fn (^local-var "fn")))
         (^
          (univ-push-args ctx)
          (^var-declaration '()
                            args
                            (^subarray
                               (gvm-state-stack-use ctx 'rd)
                               (^- (^+ (gvm-state-sp-use ctx 'rd) 1)
                                       (^getnargs))
                               (^getnargs)))
          (^inc-by (gvm-state-sp-use ctx 'rdwr) (^- (^getnargs)))
          (^var-declaration '()
                            ra
                            (^call-prim
                             (^rts-method (univ-use-rtlib ctx 'heapify_cont))
                             (^getreg 0)))
          (^var-declaration '()
                            frame
                            (^array-index (gvm-state-stack-use ctx 'rd) 0))
          (^var-declaration '()
                            tmp
                            (^map (^rts-method (univ-use-rtlib ctx  
                                                               'scm2host))
                                  args))
          (^assign tmp (^call-with-arg-array fn tmp))
          (^assign (^getreg 1)
                   (^call-prim (^rts-method (univ-use-rtlib ctx 'host2scm))
                               tmp))
          (^assign (gvm-state-sp-use ctx 'wr) -1)
          (^inc-by (gvm-state-sp-use ctx 'rdwr)
                   1
                   (lambda (x)
                     (^assign (^array-index (gvm-state-stack-use ctx 'wr) x)
                              frame)))
          (^return ra))))))

    ((js2scm)
     (rts-method
      'js2scm
      '(public)
      'scmobj
      (list (univ-field 'obj 'object))
      "\n"
      '()
      (lambda (ctx)
        (let ((obj (^local-var 'obj))
              (alist (^local-var 'alist))
              (key (^local-var 'key)))
          (^
           "  if (" obj " === void 0) {
    return " (^void-obj) ";
  } else if (typeof " obj " === 'boolean') {
    return " (^boolean-box obj) ";
  } else if (" obj " === null) {
    return " (^null-obj) ";
  } else if (typeof " obj " === 'number') {
    if ((" obj "|0) === " obj " && " obj ">=-536870912 && " obj "<=536870911)
      return " (^fixnum-box obj) ";
    else
      return " (^flonum-box obj) ";
  } else if (typeof " obj " === 'function') {
    return function () { return " (^call-prim
                                   (^rts-method-use 'scm2js_call)
                                   obj) "; };
  } else if (typeof " obj " === 'string') {
    return " (^string-box (^str-to-codes obj)) ";
  } else if (typeof " obj " === 'object') {
    if (" obj " instanceof Array) {
      return " obj ".map(" (^rts-method-use 'js2scm) ");
    } else {
      var " alist " = " (^null-obj) ";
      for (var " key " in " obj ") {
        " alist " = " (^cons (^cons (^call-prim
                                     (^rts-method-use 'js2scm)
                                     key)
                                    (^call-prim
                                     (^rts-method-use 'js2scm)
                                     (^array-index obj key)))
                                   alist) ";
      }
      return " alist ";
    }
  } else {
    throw 'js2scm error ' + " obj ";
  }
")))))

    ((scm2js)
     (rts-method
      'scm2js
      '(public)
      'object
      (list (univ-field 'obj 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        #<<EOF
  if (obj === void 0) {
    return obj;
  } else if (typeof obj === 'boolean') {
    return obj;
  } else if (obj === null) {
    return obj;
  } else if (typeof obj === 'number') {
    return obj
  } else if (typeof obj === 'function') {
    return function () { return Gambit.js2scm_call(obj, arguments); };
  } else if (typeof obj === 'object') {
    if (obj instanceof Array) {
      return obj.map(Gambit.scm2js);
    } else if (obj instanceof Gambit.String) {
      return obj.toString();
    } else if (obj instanceof Gambit.Flonum) {
      return obj.val;
    } else if (obj instanceof Gambit.Pair) {
      var jsobj = {};
      var i = 0;
      while (obj instanceof Gambit.Pair) {
        var elem = obj.car;
        if (elem instanceof Gambit.Pair) {
          jsobj[Gambit.scm2js(elem.car)] = Gambit.scm2js(elem.cdr);
        } else {
          jsobj[i] = Gambit.scm2js(elem);
        }
        ++i;
        obj = obj.cdr;
      }
      return jsobj;
    } else if (obj instanceof Gambit.Structure) {
      throw 'Gambit.scm2js error (cannot convert Structure)';
    } else {
      throw 'Gambit.scm2js error ' + obj;
    }
  } else {
    throw 'Gambit.scm2js error ' + obj;
  }
EOF
)))

    ((scm2js_call)
     (rts-method
      'scm2js_call
      '(public)
      'jumpable
      (list (univ-field 'fn 'object))
      "\n"
      '()
      (lambda (ctx)
        #<<EOF

  if (Gambit.nargs > 0) {
    Gambit.stack[++Gambit.sp] = Gambit.r1;
    if (Gambit.nargs > 1) {
      Gambit.stack[++Gambit.sp] = Gambit.r2;
      if (Gambit.nargs > 2) {
        Gambit.stack[++Gambit.sp] = Gambit.r3;
      }
    }
  }

  var args = Gambit.stack.slice(Gambit.sp+1-Gambit.nargs, Gambit.sp+1);

  Gambit.sp -= Gambit.nargs;

  var ra = Gambit.heapify_cont(Gambit.r0);
  var frame = Gambit.stack[0];

  Gambit.r1 = Gambit.js2scm(fn.apply(null, args.map(Gambit.scm2js)));

  Gambit.sp = -1;
  Gambit.stack[++Gambit.sp] = frame;

  return ra;

EOF
)))

    ((js2scm_call)
     (rts-method
      'js2scm_call
      '(public)
      'object
      (list (univ-field 'proc 'scmobj)
            (univ-field 'args 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        #<<EOF

  Gambit.sp = -1;
  Gambit.stack[++Gambit.sp] = Gambit.null_obj; // end of continuation marker

  Gambit.nargs = args.length;

  for (var i=0; i<Gambit.nargs; i++) {
    Gambit.stack[++Gambit.sp] = Gambit.js2scm(args[i]);
  }

  if (Gambit.nargs > 0) {
    if (Gambit.nargs > 1) {
      if (Gambit.nargs > 2) {
        Gambit.r3 = Gambit.stack[Gambit.sp];
        --Gambit.sp;
      }
      Gambit.r2 = Gambit.stack[Gambit.sp];
      --Gambit.sp;
    }
    Gambit.r1 = Gambit.stack[Gambit.sp];
    --Gambit.sp;
  }

  Gambit.r0 = Gambit.underflow;

  Gambit.trampoline(proc);

  return Gambit.scm2js(Gambit.r1);

EOF
)))

     ((ffi)
      (case (target-name (ctx-target ctx))
       ((js)
        (univ-use-rtlib ctx 'host_function2scm)
        (univ-use-rtlib ctx 'host2scm)
        (univ-use-rtlib ctx 'host2scm_call)
        (univ-use-rtlib ctx 'scm2host)
        (univ-use-rtlib ctx 'scm_procedure2host)
        (univ-use-rtlib ctx 'scm2host_call)
        (univ-use-rtlib ctx 'js2scm)
        (univ-use-rtlib ctx 'scm2js)
        (univ-use-rtlib ctx 'js2scm_call)
        (univ-use-rtlib ctx 'scm2js_call)))
      (univ-make-empty-defs))

    ((globals)
     (case (target-name (ctx-target ctx))

       ((js)
        (rts-field
         'globals
         'object
         (^this)))

       ((php)
        (rts-field
         'globals
         'object
         (^local-var 'GLOBALS)))

       ((python)
        (rts-field
         'globals
         'object
         (^call-prim "locals")))

       ((ruby)
        (rts-field
         'globals
         'object
         "binding"))

       (else
        (compiler-internal-error
         "univ-rtlib-feature globals, unknown target"))))

    ((get_host_global_var)
     (rts-method
      'get_host_global_var
      '(public)
      'object
      (list (univ-field 'name 'object))
      "\n"
      '()
      (lambda (ctx)
        (case (target-name (ctx-target ctx))

          ((js php python)
           (^return (^prop-index (^rts-field-use 'globals)
                                 (^local-var 'name))))

          ((ruby)
           #; ;; this code only works on newer versions of ruby
           (^return (^call-prim (^member (^rts-field-use 'globals)
           'local_variable_get)
           (^ (^local-var 'name) ".to_sym")))

           ;; this code uses eval but works on all versions of ruby
           (^return (^call-prim "eval"
                                (^+ (^str "$") (^local-var 'name))
                                (^rts-field-use 'globals))))

           (else
            (compiler-internal-error
             "univ-rtlib-feature get_host_global_var, unknown target"))))))

    (else
     (compiler-internal-error
      "univ-rtlib-feature, unknown runtime system feature" feature))))

(define (univ-get-time ctx)
  (case (target-name (ctx-target ctx))
    ((js)     (^call-prim (^member (^new 'Date) 'getTime)))
    ((php)    (^call-prim 'microtime (^bool #t)))
    ((python) (^call-prim (^member 'time 'time)))
    ((ruby)   (^new 'Time))
    ((java)   (^call-prim (^member 'System 'currentTimeMillis)))))

(define (univ-rtlib ctx)

  (define (topological-sort graph)
    (if (null? graph)
        '()
        (let* ((nodes-to-remove (independent-nodes graph))
               (to-remove (map car nodes-to-remove)))
          (append nodes-to-remove
                  (topological-sort
                   (map (lambda (x)
                          (list (car x)
                                (diff (cadr x) to-remove)
                                (caddr x)))
                        (keep (lambda (x)
                                (not (memq (car x) to-remove)))
                              graph)))))))

  (define (independent-nodes graph)
    (keep (lambda (x) (null? (cadr x))) graph))

  (define (diff lst1 lst2)
    (keep (lambda (x) (not (memq x lst2))) lst1))

  (let ((used (ctx-rtlib-features-used ctx)))
    (let loop ((feature-defs '()))
      (let ((feature (resource-set-pop used)))
        (if feature

            (let ((new-used (make-resource-set)))
              (ctx-rtlib-features-used-set! ctx new-used)
              (let* ((defs
                       (univ-rtlib-feature ctx feature))
                     (used-by-feature
                      (diff
                       (resource-set-stack (ctx-rtlib-features-used ctx))
                       (list feature))))
                (for-each (lambda (f) (resource-set-add! used f))
                          used-by-feature)
                (loop (cons (list feature used-by-feature defs)
                            feature-defs))))

            (univ-defs-combine-list
             (map caddr (topological-sort feature-defs))))))))

(define (univ-rtlib-header ctx)
  (case (target-name (ctx-target ctx))

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

    ((java)
     (^ "import java.util.Arrays;\n"
        "import java.util.HashMap;\n"
        "import java.lang.System;\n"
        "\n"))

    (else
     (compiler-internal-error
      "univ-rtlib-header, unknown target"))))

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

(define (univ-main-defs ctx gen-body)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (univ-add-init
      (univ-make-empty-defs)
      gen-body))

    ((java)
     (univ-add-method
      (univ-make-empty-defs)
      (univ-method
       'main
       '(public)
       'noresult
       (list (univ-field 'args '(array str)))
       '()
       (univ-emit-fn-body
        ctx
        "\n"
        gen-body))))

    (else
     (compiler-internal-error
      "univ-main-defs, unknown target"))))

(define (univ-entry-point ctx main-proc)
  (univ-main-defs
   ctx
   (lambda (ctx)
     (let ((entry (^obj main-proc)))
       (^ "\n"
          (univ-comment ctx "--------------------------------\n")
          "\n"

          (if univ-dyn-load?
              (^)
              (^push (^obj '()))) ;; end of continuation marker

          (^assign (^rts-field-use 'r0)
                   (^rts-jumpable-use 'underflow))

          (^assign (^rts-field-use 'nargs)
                   (^int 0))

          (^expr-statement
           (^call-prim
            (^rts-method-use 'trampoline)
            entry)))))))

;;;----------------------------------------------------------------------------

(define (univ-defs fields methods classes inits all)
  (vector fields methods classes inits all))

(define (univ-defs-fields defs)  (vector-ref defs 0))
(define (univ-defs-methods defs) (vector-ref defs 1))
(define (univ-defs-classes defs) (vector-ref defs 2))
(define (univ-defs-inits defs)   (vector-ref defs 3))
(define (univ-defs-all defs)     (vector-ref defs 4))

(define (univ-make-empty-defs)
  (univ-defs '() '() '() '() '()))

(define (univ-add-field defs field)
  (univ-defs (cons field (univ-defs-fields defs))
             (univ-defs-methods defs)
             (univ-defs-classes defs)
             (univ-defs-inits defs)
             (cons field (univ-defs-all defs))))

(define (univ-add-method defs method)
  (univ-defs (univ-defs-fields defs)
             (cons method (univ-defs-methods defs))
             (univ-defs-classes defs)
             (univ-defs-inits defs)
             (cons method (univ-defs-all defs))))

(define (univ-add-class defs class)
  (univ-defs (univ-defs-fields defs)
             (univ-defs-methods defs)
             (cons class (univ-defs-classes defs))
             (univ-defs-inits defs)
             (cons class (univ-defs-all defs))))

(define (univ-add-init defs init)
  (univ-defs (univ-defs-fields defs)
             (univ-defs-methods defs)
             (univ-defs-classes defs)
             (cons init (univ-defs-inits defs))
             (cons init (univ-defs-all defs))))

(define (univ-defs-combine defs1 defs2)
  (univ-defs (append (univ-defs-fields defs2)
                     (univ-defs-fields defs1))
             (append (univ-defs-methods defs2)
                     (univ-defs-methods defs1))
             (append (univ-defs-classes defs2)
                     (univ-defs-classes defs1))
             (append (univ-defs-inits defs2)
                     (univ-defs-inits defs1))
             (append (univ-defs-all defs2)
                     (univ-defs-all defs1))))

(define (univ-defs-combine-list lst)
  (let loop ((lst lst) (defs (univ-make-empty-defs)))
    (if (pair? lst)
        (loop (cdr lst) (univ-defs-combine defs (car lst)))
        defs)))

(define (univ-def-kind x) (if (vector? x) (vector-ref x 0) 'init))

(define (univ-class
         root-name
         properties
         extends
         class-fields
         instance-fields
         class-methods
         instance-methods
         class-classes
         constructor
         inits)
  (vector 'class
          root-name
          properties
          extends
          class-fields
          instance-fields
          class-methods
          instance-methods
          class-classes
          constructor
          inits))

(define (univ-class-root-name class-descr)        (vector-ref class-descr 1))
(define (univ-class-properties class-descr)       (vector-ref class-descr 2))
(define (univ-class-extends class-descr)          (vector-ref class-descr 3))
(define (univ-class-class-fields class-descr)     (vector-ref class-descr 4))
(define (univ-class-instance-fields class-descr)  (vector-ref class-descr 5))
(define (univ-class-class-methods class-descr)    (vector-ref class-descr 6))
(define (univ-class-instance-methods class-descr) (vector-ref class-descr 7))
(define (univ-class-class-classes class-descr)    (vector-ref class-descr 8))
(define (univ-class-constructor class-descr)      (vector-ref class-descr 9))
(define (univ-class-inits class-descr)            (vector-ref class-descr 10))

(define (univ-method
         name
         properties
         result-type
         params
         #!optional
         (attribs '())
         (body #f))
  (vector 'method
          name
          properties
          result-type
          params
          attribs
          body))

(define (univ-method-name method-descr)        (vector-ref method-descr 1))
(define (univ-method-properties method-descr)  (vector-ref method-descr 2))
(define (univ-method-result-type method-descr) (vector-ref method-descr 3))
(define (univ-method-params method-descr)      (vector-ref method-descr 4))
(define (univ-method-attribs method-descr)     (vector-ref method-descr 5))
(define (univ-method-body method-descr)        (vector-ref method-descr 6))

(define (univ-method? x) (eq? (vector-ref x 0) 'method))

(define (univ-field name type #!optional (init #f) (properties '()))
  (vector 'field name properties type init))

(define (univ-field-name field-descr)       (vector-ref field-descr 1))
(define (univ-field-properties field-descr) (vector-ref field-descr 2))
(define (univ-field-type field-descr)       (vector-ref field-descr 3))
(define (univ-field-init field-descr)       (vector-ref field-descr 4))

(define (univ-field-inherited? field-descr)
  (memq 'inherited (univ-field-properties field-descr)))

(define (univ-decl-properties decl) (vector-ref decl 2))

(define (univ-emit-var-decl ctx var-descr)
  (case (target-name (ctx-target ctx))

    ((java)
     (^decl
      (univ-field-type var-descr)
      (univ-field-name var-descr)))

    (else
     (univ-field-name var-descr))))

(define (univ-rts-type-alias ctx type-name)
  (case type-name
    ((absent)        'Absent)
    ((bignum)        'Bignum)
    ((boolean)       'Boolean)
    ((box)           'Box)
    ((char)          'Char)
    ((chr)           'Chr)
    ((closure)       'Closure)
    ((continuation)  'Continuation)
    ((cpxnum)        'Cpxnum)
    ((ctrlpt)        'ControlPoint)
    ((entrypt)       'EntryPoint)
    ((eof)           'Eof)
    ((f64vector)     'F64Vector)
    ((fixnum)        'Fixnum)
    ((flonum)        'Flonum)
    ((frame)         'Frame)
    ((jumpable)      'Jumpable)
    ((key)           'Key)
    ((keyword)       'Keyword)
    ((null)          'Null)
    ((optional)      'Optional)
    ((pair)          'Pair)
    ((parententrypt) 'ParentEntryPoint)
    ((promise)       'Promise)
    ((ratnum)        'Ratnum)
    ((rest)          'Rest)
    ((returnpt)      'ReturnPoint)
    ((scmobj)        'ScmObj)
    ((string)        'ScmString) ;; to avoid clashes with host's String class
    ((structure)     'Structure)
    ((symbol)        'Symbol)
    ((u16vector)     'U16Vector)
    ((u8vector)      'U8Vector)
    ((unbound)       'Unbound)
    ((values)        'Values)
    ((vector)        'Vector)
    ((void)          'Void)
    ((will)          'Will)
    (else            #f)))

(define (univ-emit-decl ctx type name)

  (define (decl type)

    (define (base type-name)
      (if name
          (^ type-name " " name)
          type-name))

    (define (map-type type-name)
      (let ((x (univ-rts-type-alias ctx type-name)))
        ;;(pp (list 'xxxxxxxxxxxxxx x))
        (if x
            (begin
              (univ-use-rtlib ctx type-name)
              (if name
                  (tt"QQQ"(^rts-class-ref type-name))
                  (tt"RRR"(^rts-class-ref type-name))))
            type-name)))

    (case (target-name (ctx-target ctx))

      ((js php python ruby)
       (if name
           name
           (map-type type)))

      ((java)
       (cond ((and (pair? type) (eq? (car type) 'array))
              (^ (decl (cadr type)) "[]"))
             ((and (pair? type) (eq? (car type) 'dict))
              (base (^ "HashMap<"
                       (if (eq? (cadr type) 'int)
                           "Integer"
                           (^type (cadr type)))
                       ","
                       (^type (caddr type)) ">")))
             (else
              (case type
                ((frm)      (decl '(array scmobj)))
                ((noresult) (base 'void))
                ((int)      (base 'int))
                ((Int)      (base 'Integer))
                ((long)     (base 'long))
                ((chr)      (base 'char))
                ((u8)       (base 'byte))  ;;TODO byte is signed (-128..127)
                ((u16)      (base 'short)) ;;TODO short is signed
                ((f64)      (base 'double))
                ((bool)     (base 'boolean))
                ((unicode)  (base 'int)) ;; Unicode needs 21 bit wide integers
                ((bigdigit) (base 'short))
                ((str)      (base 'String))
                ((object)   (base 'Object))
                (else       (base (map-type type)))))))

      (else
       (compiler-internal-error
        "univ-emit-decl, unknown target"))))

  (decl type))

(define (univ-emit-type ctx type)
  (univ-emit-decl ctx type #f))

(define (univ-emit-procedure-declaration
         ctx
         global?
         proc-type
         root-name
         params
         attribs
         body)
  (univ-emit-defs
   ctx
   (univ-jumpable-declaration-defs
    ctx
    global?
    proc-type
    root-name
    params
    attribs
    body)))

(define (univ-emit-defs ctx defs)

  (define (emit-method m)
    (univ-emit-function-declaration
     ctx
     #t
     (univ-method-name m)
     (univ-method-result-type m)
     (univ-method-params m)
     (univ-method-attribs m)
     (univ-method-body m)
     #t))

  (define (emit-class c)
    (univ-emit-class-declaration
     ctx
     (univ-class-root-name c)
     (univ-class-properties c)
     (univ-class-extends c)
     (univ-class-class-fields c)
     (univ-class-instance-fields c)
     (univ-class-class-methods c)
     (univ-class-instance-methods c)
     (univ-class-class-classes c)
     (univ-class-constructor c)
     (univ-class-inits c)))

  (define (emit-field f)
    (univ-emit-var-declaration
     ctx
     (univ-field-type f)
     (^global-var (^prefix (univ-field-name f)))
     (univ-field-init f)))

  (define (emit-init i)
    (i ctx))

  (let loop ((lst
              (if (eq? (target-name (ctx-target ctx)) 'java)
                  (append (reverse (univ-defs-classes defs))
                          (reverse (univ-defs-methods defs))
                          (reverse (univ-defs-fields defs))
                          (reverse (univ-defs-inits defs)))
                  (reverse (univ-defs-all defs))))
             (code
              (^)))
    (if (pair? lst)
        (let ((x (car lst)))
          (loop (cdr lst)
                (^ code
                   (case (univ-def-kind x)
                     ((class)  (emit-class x))
                     ((method) (emit-method x))
                     ((field)  (emit-field x))
                     ((init)   (emit-init x)))
                   "\n")))
        code)))

(define (univ-capitalize code)

  (define (cap-string str)
    (string-append (string (char-upcase (string-ref str 0)))
                   (substring str 1 (string-length str))))

  (cond ((string? code)
         (cap-string code))
        ((symbol? code)
         (cap-string (symbol->string code)))
        ((and (pair? code) (eq? (car code) univ-bb-prefix))
         (cons univ-capitalized-bb-prefix (cdr code)))
        (else
         (error "cannot capitalize" code))))

(define (univ-jumpable-declaration-defs
         ctx
         global?
         root-name
         jumpable-type
         params
         attribs
         body)
  (if (eq? (univ-procedure-representation ctx) 'class)

      (let ((capitalized-root-name
             (tt"BBB"(^prefix-class (univ-capitalize root-name)))))
        (univ-add-field

         (univ-add-class
          (univ-make-empty-defs)
          (univ-class
           capitalized-root-name ;; root-name
           '() ;; properties
           (and jumpable-type (^rts-class-use jumpable-type)) ;; extends
           '()   ;; class-fields
           attribs ;; instance-fields
           '()     ;; class-methods
           (list   ;; instance-methods
            (univ-method
             'jump
             '(public)
             'jumpable
             '()
             '()
             body))
           '() ;; class-classes
           #f ;; constructor
           '())) ;; inits

         (univ-field
          root-name
          capitalized-root-name
          (^new capitalized-root-name)
          '())))

      (univ-add-method
       (univ-make-empty-defs)
       (univ-method
        (^prefix root-name);;;;;;;;;;;;;;;;;;;;(^mod-method (ctx-module-name ctx) root-name)
        '()
        'jumpable
        params
        attribs
        body))))

(define (univ-emit-function-attribs ctx name attribs)
  (case (target-name (ctx-target ctx))

    ((js python)
     (if (null? attribs)
         (^)
         (^ "\n"
            (map (lambda (attrib)
                   (let* ((val* (univ-field-init attrib))
                          (val (if (procedure? val*)
                                   (val* ctx)
                                   val*)))
                     (^assign
                      (^member name (univ-field-name attrib))
                      val)))
                 attribs))))

    ((php)
     (if (null? attribs)
         (^)
         (^ "static "
            (univ-separated-list
             ", "
             (map (lambda (attrib)
                    (let* ((val* (univ-field-init attrib))
                           (val (if (procedure? val*)
                                    (val* ctx)
                                    val*)))
                      (^assign-expr
                       (^local-var (univ-field-name attrib))
                       val)))
                  attribs))
            "; ")))

    ((ruby)
     (if (null? attribs)
         (^)
         (^ "class << " name "; attr_accessor :" (univ-field-name (car attribs))
            (map (lambda (attrib)
                   (^ ", :" (univ-field-name attrib)))
                 (cdr attribs))
            "; end\n"
            (map (lambda (attrib)
                   (let* ((val* (univ-field-init attrib))
                          (val (if (procedure? val*)
                                   (val* ctx)
                                   val*)))
                     (^assign (^member name (univ-field-name attrib))
                              val)))
                 attribs))))

    ((java)
     (^))

    (else
     (compiler-internal-error
      "univ-emit-function-attribs, unknown target"))))

(define (univ-emit-function-declaration
         ctx
         global?
         root-name
         result-type
         params
         attribs
         body
         #!optional
         (prim? #f))
  (let* ((prn
          root-name)
         (name
          (if prim?
              prn
              (if global?
                  (^global-var prn)
                  (^local-var root-name)))))
    ;;(pp (list root-name prn));;;;;;;;;;;;;
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (univ-emit-fn-decl ctx name result-type params body)
          (if (null? attribs)
              (^)
              (^ "\n"
                 (univ-emit-function-attribs ctx name attribs)))))

      ((php)
       (let ((decl
              (^ (univ-emit-fn-decl
                  ctx
                  (and (or prim? (univ-php-pre53? ctx))
                       prn)
                  result-type
                  params
                  (and body
                       (^ (if (and (not prim?)
                                   (univ-php-pre53? ctx))
                              (^)
                              (univ-emit-function-attribs ctx name attribs))
                          body)))
                 "\n")))
         (cond (prim?
                decl)
               ((univ-php-pre53? ctx)
                (^ decl
                   "\n"
                   (^assign name
                            (^ "create_function('"
                               (univ-separated-list
                                ","
                                (map (lambda (x)
                                       (^ (^local-var (univ-field-name x))
                                          (if (univ-field-init x) (^ "=" (^bool #f)) (^))))
                                     params))
                               "','"
                               (univ-emit-function-attribs ctx name attribs)
                               "return "
                               prn
                               "("
                               (univ-separated-list "," (map univ-field-name params))
                               ");')"))))
               (else
                (^assign name decl)))))

      ((python)
       (^ (univ-emit-fn-decl ctx name result-type params body)
          (if (null? attribs)
              (^)
              (^ "\n"
                 (univ-emit-function-attribs ctx name attribs)))))

      ((ruby)
       (^ (if prim?

              (^ (univ-emit-fn-decl ctx name result-type params body)
                 "\n")

              (let ((parameters
                     (univ-separated-list
                      ","
                      (map (lambda (x)
                             (^ (^local-var (univ-field-name x))
                                (if (univ-field-init x) (^ "=" (^bool #f)) (^))))
                           params))))
                (^assign
                 name
                 (univ-emit-fn-decl ctx #f result-type params body))))

          (univ-emit-function-attribs ctx name attribs)))

      ((java);;TODO adapt to Java
       (^ (univ-emit-fn-decl ctx name result-type params body)
          "\n"
          (univ-emit-function-attribs ctx name attribs)))

      (else
       (compiler-internal-error
        "univ-emit-function-declaration, unknown target")))))

(define (univ-emit-fn-decl ctx name result-type params body)
  (case (target-name (ctx-target ctx))

    ((js)
     (let ((formals
            (univ-separated-list
             ","
             (map univ-field-name params))))
       (^ "function " (or name "") "(" formals ") {"
          (if body
              (univ-indent body)
              "")
          "}")))

    ((php)
     (let ((formals
            (univ-separated-list
             ","
             (map (lambda (x)
                    (^ (^local-var (univ-field-name x))
                       (if (univ-field-init x) (^ "=" (^bool #f)) (^))))
                  params))))
       (^ "function " (or name "") "(" formals ")"
          (if body
              (^ " {"
                 (univ-indent body)
                 "}")
              ";"))))

    ((python)
     (let ((formals
            (univ-separated-list
             ","
             (map (lambda (x)
                    (^ (^local-var (univ-field-name x))
                       (if (univ-field-init x) (^ "=" (^bool #f)) (^))))
                  params))))
       (^ "def " name "(" formals "):"
          (univ-indent
           (or body
               "\npass\n")))))

    ((ruby)
     (let ((formals
            (univ-separated-list
             ","
             (map (lambda (x)
                    (^ (^local-var (univ-field-name x))
                       (if (univ-field-init x) (^ "=" (^bool #f)) (^))))
                  params))))
       (if name

           (^ "def " name (if (null? params) (^) (^ "(" formals ")"))
              (if body
                  (univ-indent body)
                  "\n")
              "end")

           (^ "lambda {" (if (null? params) (^) (^ "|" formals "|"))
              (if body
                  (univ-indent body)
                  "")
              "}"))))

    ((java)
     (let ((formals
            (univ-separated-list
             ","
             (map (lambda (var-descr)
                    (univ-emit-var-decl ctx var-descr))
                  params))))
       (^ (if result-type (^ (^type result-type) " ") (^))
          (or name "") "(" formals ")"
          (if body
              (^ " {"
                 (univ-indent body)
                 "}")
              ";"))))

    (else
     (compiler-internal-error
      "univ-emit-fn-decl, unknown target"))))

(define (univ-emit-fn-body ctx header gen-body)
  (and gen-body
       (univ-call-with-globals
        ctx
        gen-body
        (lambda (ctx body globals)
          (^ header globals body)))))

(define (univ-call-with-globals ctx gen cont)
  (with-new-resources-used
   ctx
   (lambda (ctx)

     (define (global-decl globals)
       (^ "global "
          (univ-separated-list
           ", "
           globals)))

     (let* ((result
             (gen ctx))
            (globals
             (if (eq? (univ-module-representation ctx) 'class)
                 '()
                 (let ((globals
                        (reverse (resource-set-stack (ctx-globals-used ctx)))))
#|
                   ;;TODO: remove
                   (define (used? x)
                     (or (resource-set-member? (ctx-resources-used-rd ctx) x)
                         (resource-set-member? (ctx-resources-used-wr ctx) x)))

                   (define (add! x)
                     (set! globals (cons x globals)))

                   (let loop ((num (- univ-nb-gvm-regs 1)))
                     (if (>= num 0)
                         (begin
                           (if (used? num) (add! (gvm-state-reg ctx num)))
                           (loop (- num 1)))))

                   (if (used? 'sp)        (add! (gvm-state-sp ctx)))
                   (if (used? 'stack)     (add! (gvm-state-stack ctx)))
                   (if (used? 'prm)       (add! (gvm-state-prm ctx)))
                   (if (used? 'glo)       (add! (gvm-state-glo ctx)))
                   (if (used? 'nargs)     (add! (gvm-state-nargs ctx)))
                   (if (used? 'pollcount) (add! (gvm-state-pollcount ctx)))
|#
                   globals))))
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

(define (univ-field-param ctx name)
  (if (eq? (target-name (ctx-target ctx)) 'java)
      (^ "_" name)
      name))

(define (univ-emit-class-declaration
         ctx
         root-name
         #!optional
         (properties #f)
         (extends #f)
         (class-fields '())
         (instance-fields '())
         (class-methods '())
         (instance-methods '())
         (class-classes '())
         (constructor #f)
         (inits '()))
  (let* ((name (tt"CCC"root-name)) ;; (^prefix-class root-name);;TODO: fix ^prefix
         (abstract? (memq 'abstract properties)))

    (define (qualifiers additional-properties decl)
      (let ((all (append additional-properties (univ-decl-properties decl))))
        (^ (case (target-name (ctx-target ctx))
             ((python)
              "")
             (else
              (if (memq 'public all) "public " "")))
           (case (target-name (ctx-target ctx))
             ((python)
              "")
             (else
              (if (memq 'static all) "static " "")))
           (case (target-name (ctx-target ctx))
             ((python)
              "")
             (else
              (if (and (univ-method? decl) (not (univ-method-body decl)))
                  "abstract "
                  "")))
           (if (memq 'classmethod all) "@classmethod\n" ""))))

    (define (field-decl type name init)
      (univ-emit-var-declaration ctx type name init))

    (define (qualified-field-decls additional-properties fields)
      (let ((fields
             (keep (lambda (x) (not (univ-field-inherited? x)))
                   fields)))
        (if (pair? fields)
            (^ "\n"
               (map (lambda (field)
                      (^ (qualifiers additional-properties field)
                         (field-decl (univ-field-type field)
                                     (^local-var (univ-field-name field))
                                     (univ-field-init field))))
                    fields))
            (^))))

    (define (qualified-method-decls additional-properties methods)
      (map (lambda (method)
             (^ "\n"
                (qualifiers additional-properties method)
                (univ-emit-function-declaration
                 ctx
                 #t
                 (univ-method-name method)
                 (univ-method-result-type method)
                 (if (eq? (target-name (ctx-target ctx)) 'python)
                     (cons (univ-field (^this) 'object)
                           (univ-method-params method))
                     (univ-method-params method))
                 (univ-method-attribs method)
                 (univ-method-body method)
                 #t)
                (if (eq? (target-name (ctx-target ctx)) 'python)
                    "" ;; avoid repeated empty lines
                    "\n")))
           methods))

    (define (qualified-class-decls additional-properties classes)
      (map (lambda (class)
             (^ "\n"
                (qualifiers additional-properties class)
                (univ-emit-class-declaration
                 ctx
                 (univ-class-root-name class)
                 (univ-class-properties class)
                 (univ-class-extends class)
                 (univ-class-class-fields class)
                 (univ-class-instance-fields class)
                 (univ-class-class-methods class)
                 (univ-class-instance-methods class)
                 (univ-class-class-classes class)
                 (univ-class-constructor class)
                 (univ-class-inits class))))
           classes))

    (define (ruby-attr-accessors fields)
      (^ "\n"
         "attr_accessor " ;; allow read/write on all fields
         (univ-separated-list
          ","
          (map (lambda (field) (^ ":" (univ-field-name field)))
               fields))
         "\n"))

    (define (initless fields)
      (keep (lambda (field) (not (univ-field-init field)))
            fields))

    (define (gen-inits ctx inits)
      (if (null? inits)
          '()
          (^ "\n"
             (map (lambda (i) (i ctx)) inits))))

    (define (assign-field-decls obj fields)
      (map (lambda (field)
             (let* ((field-name (univ-field-name field))
                    (field-init (univ-field-init field))
                    (init (if (procedure? field-init)
                              (field-init ctx)
                              field-init)))
               (^assign (^member obj field-name)
                        (or init (^local-var (univ-field-param ctx field-name))))))
           fields))

    (define (js-class-declaration
             ctx
             obj
             name
             properties
             extends
             class-fields
             instance-fields
             class-methods
             instance-methods
             class-classes
             constructor
             inits)

      (define (assign-method-decls obj methods)
        (map (lambda (method)
               (^ "\n"
                  (^assign (^member obj (univ-method-name method))
                           (univ-emit-fn-decl
                            ctx
                            #f
                            (univ-method-result-type method)
                            (univ-method-params method)
                            (univ-method-body method)))
                  (univ-emit-function-attribs
                   ctx
                   (^member obj (univ-method-name method))
                   (univ-method-attribs method))))
             methods))

      (define (assign-class-decls obj classes)
        (map (lambda (class)
               (^ "\n"
                  (js-class-declaration
                   ctx
                   obj
                   (univ-class-root-name class)
                   (univ-class-properties class)
                   (univ-class-extends class)
                   (univ-class-class-fields class)
                   (univ-class-instance-fields class)
                   (univ-class-class-methods class)
                   (univ-class-instance-methods class)
                   (univ-class-class-classes class)
                   (univ-class-constructor class)
                   (univ-class-inits class))))
             classes))

      (define (fn-decl name)
        (univ-emit-fn-decl
         ctx
         name
         #f
         (initless instance-fields)
         (univ-emit-fn-body
          ctx
          "\n"
          (lambda (ctx)
            (if (or constructor
                    (not (null? instance-fields)))
                (^ (assign-field-decls (^this) instance-fields)
                   (if constructor (constructor ctx) (^)))
                (^))))))

      (let ((objname name)) ;;(if obj (^member obj name) name)))
        ;;(pp (list obj name objname))
        (^ (if obj
               (^assign objname (fn-decl #f))
               (^ (fn-decl name)
                  "\n"))

           (if extends
               (begin ;;(pp (list 'extends extends (^type extends)))
               (^ "\n"
                  (^assign (^member objname 'prototype)
                           (^call-prim (^member "Object" 'create)
                                       (^member (^type extends) 'prototype))))
               )
               (^))

           (assign-method-decls (^member objname 'prototype) instance-methods)

           (assign-class-decls objname class-classes)

           (assign-method-decls objname class-methods)

           (if (pair? class-fields)
               (^ "\n" (assign-field-decls objname class-fields))
               (^))

           (gen-inits ctx inits))))

    (case (target-name (ctx-target ctx))

      ((js)
       (js-class-declaration
        ctx
        #f
        root-name
        properties
        extends
        class-fields
        instance-fields
        class-methods
        instance-methods
        class-classes
        constructor
        inits))

      ((php)
       (let* ((c-classes
               (qualified-class-decls '() class-classes))
              (c-fields
               (qualified-field-decls '(static) class-fields))
              (i-fields
               (qualified-field-decls '() instance-fields))
              (all-fields
               (append c-fields i-fields))
              (constr
               (if (and (not abstract?)
                        (or constructor (not (null? instance-fields))))
                   (^ (univ-emit-fn-decl
                       ctx
                       name
                       #f
                       (map (lambda (field)
                              (univ-field
                               (univ-field-param ctx (univ-field-name field))
                               (univ-field-type field)
                               (univ-field-init field)
                               (univ-field-properties field)))
                            (initless instance-fields))
                       (univ-emit-fn-body
                        ctx
                        "\n"
                        (lambda (ctx)
                          (^ (assign-field-decls (^this) instance-fields)
                             (if constructor (constructor ctx) (^))))))
                      "\n")
                   '()))
              (c-methods
               (qualified-method-decls
                (if abstract? '(abstract static) '(static))
                class-methods))
              (i-methods
               (qualified-method-decls
                (if abstract? '(abstract) '())
                instance-methods))
              (all-methods
               (append constr
                       c-methods
                       i-methods))
              (c-inits
               (gen-inits ctx inits)))
         (^ c-classes
            (if abstract? "abstract " "") "class " name
            (if extends (^ " extends " (^type extends)) "")
            " {"
            (univ-indent
             (^ (if (and (null? all-fields)
                         (null? all-methods)
                         (null? c-inits))
                    ""
                    "\n")
                all-fields
                (if (null? all-methods)
                    ""
                    "\n")
                all-methods
                (if (null? c-inits)
                    (^)
                    (^ "static {"
                       (univ-indent c-inits)
                       "}\n"))))
            "}\n")))

      ((python)
       (let* ((c-classes
               (qualified-class-decls '(static) class-classes))
              (c-fields
               (qualified-field-decls '(static) class-fields))
              (c-methods
               (qualified-method-decls '(classmethod) class-methods))
              (i-methods
               (qualified-method-decls '() instance-methods))
              (c-inits
               (gen-inits ctx inits)))
         (^ "class " name
            (if extends (^ "(" (^type extends) ")") "")
            ":\n"
            (univ-indent
             (if (and (not abstract?)
                      (or constructor
                          (not (null? c-classes))
                          (not (null? c-fields))
                          (not (null? c-methods))
                          (not (null? instance-fields))
                          (not (null? i-methods))
                          (not (null? c-inits))))
                 (^ c-classes
                    c-fields
                    c-methods
                    (if (or constructor
                            (not (null? instance-fields)))
                        (^ "\n"
                           (univ-emit-fn-decl
                            ctx
                            "__init__"
                            #f
                            (cons (univ-field (^this) 'object)
                                  (initless instance-fields))
                            (univ-emit-fn-body
                             ctx
                             "\n"
                             (lambda (ctx)
                               (if (and (null? instance-fields) (not constructor))
                                   "pass\n"
                                   (^ (assign-field-decls (^this) instance-fields)
                                      (if constructor (constructor ctx) (^))))))))
                        (^))
                    i-methods)
                 "pass\n"))
            c-inits))) ;; class inits are outside of class definition in case there are self dependencies

      ((ruby)
       (^ "class " name
          (if extends (^ " < " (^type extends)) "")
          (univ-indent
           (if (or constructor
                   (not (null? class-fields))
                   (not (null? instance-fields))
                   (not (null? class-methods))
                   (not (null? instance-methods)))
               (^ "\n"
                  (if (or (not (null? class-fields))
                          (not (null? class-methods)))
                      (^ "\n"
                         "class << " (^this)
                         (univ-indent
                          (^ (ruby-attr-accessors class-fields)
                             (qualified-method-decls '() class-methods)))
                         "end\n"
                         "\n"
                         (assign-field-decls 'self-class class-fields))
                      (^))
                  (if (pair? instance-fields)
                      (ruby-attr-accessors instance-fields)
                      (^))
                  (if (or constructor
                          (not (null? instance-fields)))
                      (^ "\n"
                         "def initialize("
                         (univ-separated-list
                          ","
                          (map univ-field-name
                               (initless instance-fields)))
                         ")\n"
                         (univ-indent
                          (^ (assign-field-decls (^this) instance-fields)
                             (if constructor (constructor ctx) (^))))
                         "end\n")
                      (^))
                  (qualified-method-decls '() instance-methods))
               (^)))
          "\nend\n"))

      ((java)
       (let* ((c-classes
               (qualified-class-decls '(static) class-classes))
              (c-fields
               (qualified-field-decls '(static) class-fields))
              (i-fields
               (qualified-field-decls '() instance-fields))
              (all-fields
               (append c-fields i-fields))
              (constr
               (if (and (not abstract?)
                        (or constructor (not (null? instance-fields))))
                   (list "\n"
                         (univ-emit-fn-decl
                          ctx
                          name
                          #f
                          (map (lambda (field)
                                 (univ-field
                                  (univ-field-param ctx (univ-field-name field))
                                  (univ-field-type field)
                                  (univ-field-init field)
                                  (univ-field-properties field)))
                               (initless instance-fields))
                          (univ-emit-fn-body
                           ctx
                           "\n"
                           (lambda (ctx)
                             (^ (assign-field-decls (^this) instance-fields)
                                (if constructor (constructor ctx) (^))))))
                         "\n")
                   '()))
              (c-methods
               (qualified-method-decls
                (if abstract? '(abstract static) '(static))
                class-methods))
              (i-methods
               (qualified-method-decls
                (if abstract? '(abstract) '())
                instance-methods))
              (all-methods
               (append constr c-methods i-methods))
              (c-inits
               (gen-inits ctx inits)))
         (^ (if abstract? "abstract " "") "class " name
            (if extends (^ " extends " (^type extends)) "")
            " {"
            (univ-indent
             (^ (if (and (null? c-classes)
                         (or abstract?
                             (null? all-methods)))
                    ""
                    "\n")
                c-classes
                all-fields
                all-methods
                (if (null? c-inits)
                    (^)
                    (^ "static {"
                       (univ-indent c-inits)
                       "}\n"))))
            "}\n")))

      (else
       (compiler-internal-error
        "univ-emit-class-declaration, unknown target")))))

(define (univ-comment ctx comment)
  (case (target-name (ctx-target ctx))

    ((js php java)
     (^ "// " comment))

    ((python ruby)
     (^ "# " comment))

    (else
     (compiler-internal-error
      "univ-comment, unknown target"))))

(define (univ-emit-return-poll ctx expr poll? call?)

  (define (ret)
    (if (or call? (univ-always-return-jump? ctx))
        (^return-jump expr)
        (^return expr)))

  (if poll?

      (^inc-by (gvm-state-pollcount-use ctx 'rdwr)
               -1
               (lambda (inc)
                 (^if (^= inc (^int 0))
                      (^return-call-prim
                       (^rts-method-use 'poll)
                       expr)
                      (ret))))

      (ret)))

(define (univ-emit-return-call-prim ctx expr . params)
  (^return
   (apply univ-emit-call-prim (cons ctx (cons expr params)))))

(define (univ-emit-return-jump ctx expr)
  (^return
   (if (not (univ-never-return-jump? ctx))
       (^jump (univ-unstringify-method expr))
       expr)))

(define (univ-emit-return ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php java)
     (^ "return " expr ";\n"))

    ((python ruby)
     (^ "return " expr "\n"))

    (else
     (compiler-internal-error
      "univ-emit-return, unknown target"))))

(define (univ-emit-null ctx)
  (case (target-name (ctx-target ctx))

    ((js java)
     (univ-constant "null"))

    ((python)
     (univ-constant "None"))

    ((ruby)
     (univ-constant "nil"))

    ((php)
     (univ-constant "NULL"))

    (else
     (compiler-internal-error
      "univ-emit-null-ref, unknown target"))))

(define (univ-emit-null? ctx expr)
  (^eq? expr (^null)))

(define (univ-emit-null-obj ctx)
  (case (univ-null-representation ctx)

    ((class)
     (^rts-field-use 'null_obj))

    (else
     (^null))))

(define (univ-emit-null-obj? ctx expr)
  (case (univ-null-representation ctx)

    ((class)
     (case (target-name (ctx-target ctx))

      ((js)
       (^instanceof (^null) expr))

      ((python ruby php)
       (^eq? expr (^null)))

      (else
       (compiler-internal-error
        "univ-emit-null-obj?, unknown target"))))

    (else
     (^null? expr))))

(define (univ-emit-void ctx)
  (case (target-name (ctx-target ctx))

    ((js)
     (univ-constant "void 0"))

    ((python)
     (univ-constant "None"))

    ((ruby)
     (univ-constant "nil"))

    ((php)
     (univ-constant "NULL"))

    (else
     (compiler-internal-error
      "univ-emit-void, unknown target"))))

(define (univ-emit-void? ctx expr)
  (^eq? expr (^void)))

(define (univ-emit-void-obj ctx)
  (case (univ-void-representation ctx)

    ((class)
     (^rts-field-use 'void_obj))

    (else
     (^void))))

(define (univ-emit-str->string ctx expr)
  (^string-box (^str-to-codes expr)))


(define (univ-emit-string->str ctx expr)
  (case (univ-string-representation ctx)

    ((class)
     (^tostr  expr))

    ((host)
     expr)))

(define (univ-emit-void-obj? ctx expr)
  (case (univ-void-representation ctx)

    ((class)
     (case (target-name (ctx-target ctx))

      ((js)
       (^instanceof (^void) expr))

      ((python ruby php)
       (^eq? expr (^void)))

      (else
       (compiler-internal-error
        "univ-emit-void?, unknown target"))))

    (else
     (^null? expr))))

(define (univ-emit-str? ctx expr)
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
       "univ-emit-str?, unknown target"))))

(define (univ-emit-float? ctx expr)
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
       "univ-emit-float?, unknown target"))))

(define (univ-emit-int? ctx expr)
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
     "univ-emit-int?, unknown target"))))

(define (univ-emit-eof ctx)
  (case (univ-eof-representation ctx)

    ((class)
     (^rts-field-use 'eof_obj))

    (else
     (compiler-internal-error
      "univ-emit-eof, host representation not implemented"))))

(define (univ-emit-absent ctx)
  (case (univ-absent-representation ctx)

    ((class)
     (^rts-field-use 'absent_obj))

    (else
     (compiler-internal-error
      "univ-emit-absent, host representation not implemented"))))

(define (univ-emit-unbound1 ctx)
  (case (univ-unbound-representation ctx)

    ((class)
     (^rts-field-use 'unbound1_obj))

    (else
     (compiler-internal-error
      "univ-emit-unbound1, host representation not implemented"))))

(define (univ-emit-unbound2 ctx)
  (case (univ-unbound-representation ctx)

    ((class)
     (^rts-field-use 'unbound2_obj))

    (else
     (compiler-internal-error
      "univ-emit-unbound2, host representation not implemented"))))

(define (univ-emit-unbound? ctx expr)
  (case (univ-unbound-representation ctx)

    ((class)
     (^instanceof (^type 'unbound) (^cast*-scmobj expr)))

    (else
     (compiler-internal-error
      "univ-emit-unbound?, host representation not implemented"))))

(define (univ-emit-optional ctx)
  (case (univ-optional-representation ctx)

    ((class)
     (^rts-field-use 'optional_obj))

    (else
     (compiler-internal-error
      "univ-emit-optional, host representation not implemented"))))

(define (univ-emit-key ctx)
  (case (univ-key-representation ctx)

    ((class)
     (^rts-field-use 'key_obj))

    (else
     (compiler-internal-error
      "univ-emit-key, host representation not implemented"))))

(define (univ-emit-rest ctx)
  (case (univ-rest-representation ctx)

    ((class)
     (^rts-field-use 'rest_obj))

    (else
     (compiler-internal-error
      "univ-emit-rest, host representation not implemented"))))

(define (univ-emit-bool ctx val)
  (case (target-name (ctx-target ctx))

    ((js ruby php java)
     (univ-constant (if val "true" "false")))

    ((python)
     (univ-constant (if val "True" "False")))

    (else
     (compiler-internal-error
      "univ-emit-bool, unknown target"))))

(define (univ-emit-bool? ctx expr)
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
     "univ-emit-bool?, unknown target"))))

(define (univ-emit-boolean-obj ctx obj)
  (case (univ-boolean-representation ctx)

    ((class)
     (univ-box
      (^rts-field-use (if obj 'true_obj 'false_obj))
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
         (^member expr 'val)))

    (else
     expr)))

(define (univ-emit-boolean? ctx expr)
  (case (univ-boolean-representation ctx)

    ((class)
     (^instanceof (^type 'boolean) (^cast*-scmobj expr)))

    (else
     (^bool? expr))))

(define (univ-emit-chr ctx val)
  (univ-constant (char->integer val)))

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
       (^rts-method-use 'make_interned_char)
       expr)
      expr))

    (else
     (^char-box-uninterned expr))))

(define (univ-emit-char-box-uninterned ctx expr)
  (case (univ-char-representation ctx)

    ((class)
     (^new (^type 'char) expr))

    (else
     (compiler-internal-error
      "univ-emit-char-box-uninterned, host representation not implemented"))))

(define (univ-emit-char-unbox ctx expr)
  (case (univ-char-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member (^cast* 'char expr) 'code)))

    (else
     (compiler-internal-error
      "univ-emit-char-unbox, host representation not implemented"))))

(define (univ-emit-chr-fromint ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     expr)

    ((java)
     (^cast* 'unicode expr))

    (else
     (compiler-internal-error
      "univ-emit-chr-fromint, unknown target"))))

(define (univ-emit-chr-toint ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     expr)

    ((java)
     (^cast* 'int expr))

    (else
     (compiler-internal-error
      "univ-emit-chr-toint, unknown target"))))

(define (univ-emit-chr-tostr ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^call-prim (^member "String" 'fromCharCode) expr))

    ((php)
     (^call-prim "chr" expr))

    ((python)
     (^call-prim "unichr" expr))

    ((ruby)
     (^ expr ".chr"))

    ((java)
     (^call-prim (^member 'String 'valueOf) expr))

    (else
     (compiler-internal-error
      "univ-emit-chr-tostr, unknown target"))))

(define (univ-emit-char? ctx expr)
  (case (univ-char-representation ctx)

    ((class)
     (^instanceof (^type 'char) (^cast*-scmobj expr)))

    (else
     (compiler-internal-error
      "univ-emit-char?, host representation not implemented"))))

(define (univ-emit-int ctx val)
  (univ-constant val))

(define (univ-emit-fixnum-box ctx expr)
  (case (univ-fixnum-representation ctx)

    ((class)
     (univ-box
      (^call-prim
       (^rts-method-use 'make_fixnum)
       expr)
      expr))

    (else
     expr)))

(define (univ-emit-fixnum-unbox ctx expr)
  (case (univ-fixnum-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member (^cast* 'fixnum expr) 'val)))

    (else
     expr)))

(define (univ-emit-fixnum? ctx expr)
  (case (univ-fixnum-representation ctx)

    ((class)
     (^instanceof (^type 'fixnum) (^cast*-scmobj expr)))

    (else
     (^int? expr))))

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

(define (univ-emit-dict-get ctx expr1 expr2 expr3)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (^prop-index expr1 expr2 expr3))

    ((java)
     (if expr3
         (^call-prim (^member expr1 'getOrDefault) expr2 expr3)
         (^call-prim (^member expr1 'get) expr2)))

    (else
     (compiler-internal-error
      "univ-emit-dict-get, unknown target"))))

(define (univ-emit-dict-set ctx expr1 expr2 expr3)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (^assign (^prop-index expr1 expr2) expr3))

    ((java)
     (^expr-statement (^call-prim (^member expr1 'put) expr2 expr3)))

    (else
     (compiler-internal-error
      "univ-emit-dict-set, unknown target"))))

(define (univ-emit-member ctx expr name)
  (case (target-name (ctx-target ctx))

    ((js python)
     (^ expr "." name))

    ((php)
     (^ expr "->" name))

    ((ruby)
     (cond ((eq? expr (^this)) ;; optimize access to "self"
            (^ "@" name))
           ((eq? expr 'self-class) ;; for univ-emit-class-declaration
            (^ "@@" name))
           (else
            (^ expr "." name))))

    ((java)
     (cond ((eq? expr (^this)) ;; optimize access to "this"
            name)
           (else
            (^ expr "." name))))

    (else
     (compiler-internal-error
      "univ-emit-member, unknown target"))))

(define (univ-with-ctrlpt-attribs ctx assign? ctrlpt thunk)
  (case (univ-procedure-representation ctx)

    ((class)
     (thunk))

    (else
     (case (target-name (ctx-target ctx))

       ((js python ruby)
        (thunk))

       ((php)
        (let ((attribs-var
               (^ ctrlpt "_attribs"))
              (attribs-array
               (^ "new ReflectionFunction(" ctrlpt ")")))
          (^ (if assign?
                 (^assign attribs-var attribs-array)
                 (^var-declaration 'object attribs-var attribs-array))
             (^assign attribs-var (^ attribs-var "->getStaticVariables()"))
             (thunk))))

       (else
        (compiler-internal-error
         "univ-with-ctrlpt-attribs, unknown target"))))))

(define (univ-get-ctrlpt-attrib ctx ctrlpt attrib)
  (case (univ-procedure-representation ctx)

    ((class)
     (^member ctrlpt attrib))

    (else
     (case (target-name (ctx-target ctx))

       ((js python ruby)
        (^member ctrlpt attrib))

       ((php)
        (let ((attribs-var (^ ctrlpt "_attribs")))
          (^prop-index attribs-var (^str attrib))))

       (else
        (compiler-internal-error
         "univ-get-ctrlpt-attrib, unknown target"))))))

(define (univ-set-ctrlpt-attrib ctx ctrlpt attrib val)
  (case (univ-procedure-representation ctx)

    ((class)
     (^assign (^member ctrlpt attrib) val))

    (else
     (case (target-name (ctx-target ctx))

       ((js python ruby)
        (^assign (^member ctrlpt attrib) val))

       ((php)
        (let ((attribs-var (^ ctrlpt "_attribs")))
          (^assign (^prop-index attribs-var (^str attrib)) val)))

       (else
        (compiler-internal-error
         "univ-set-ctrlpt-attrib, unknown target"))))))

(define (univ-call-with-ctrlpt-attrib ctx expr type-name attrib return)
  (let ((ctrlpt (^local-var (univ-gensym ctx 'ctrlpt))))
    (^ (^var-declaration
        type-name
        ctrlpt
        (^cast* type-name expr))
       (univ-with-ctrlpt-attribs
        ctx
        #f
        ctrlpt
        (lambda ()
          (return
           (univ-get-ctrlpt-attrib ctx ctrlpt attrib)))))))

(define (univ-emit-pair? ctx expr)
  (^instanceof (^type 'pair) (^cast*-scmobj expr)))

(define (univ-emit-cons ctx expr1 expr2)
  (^new (^type 'pair) expr1 expr2))

(define (univ-emit-getcar ctx expr)
  (^member (^cast* 'pair expr) 'car))

(define (univ-emit-getcdr ctx expr)
  (^member (^cast* 'pair expr) 'cdr))

(define (univ-emit-setcar ctx expr1 expr2)
  (^assign (^member (^cast* 'pair expr1) 'car) expr2))

(define (univ-emit-setcdr ctx expr1 expr2)
  (^assign (^member (^cast* 'pair expr1) 'cdr) expr2))

(define (univ-emit-float ctx val)
  ;; TODO: generate correct syntax
  (univ-constant
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
            "(0.0*-1)")

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

    ((java)
     (^cast* 'f64 expr))

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

    ((java)
     (^cast* 'int expr))

    (else
     (compiler-internal-error
      "univ-emit-float-toint, unknown target"))))

(define (univ-emit-float-abs ctx expr)
  (case (target-name (ctx-target ctx))

    ((js java)
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

    ((js java)
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

    ((js java)
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

    ((js php java)
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

    ((js java)
     (^ "Math.round(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-float-round-half-up, unknown target"))))

(define (univ-emit-float-round-half-towards-0 ctx expr)
  (case (target-name (ctx-target ctx))

    ((php)
     (^ "round(" expr ")"))

    ((python)
     ;; python v2 rounds towards 0
     (^ "round(" expr ")"))

    ((ruby)
     (^ expr ".round"))

    (else
     (compiler-internal-error
      "univ-emit-float-round-half-towards-0, unknown target"))))

(define (univ-emit-float-round-half-to-even ctx expr)

  (define (use-round-half-up)
    (^- (^float-round-half-up expr)
        (^parens
         (^if-expr (^&& (^!= (^float-mod expr (^float targ-inexact-+2))
                             (^float targ-inexact-+1/2))
                        (^!= (^float-mod expr (^float targ-inexact-+2))
                             (^float -1.5))) ;;;;;;;;;;;;;;;;
                   (^float targ-inexact-+0)
                   (^float targ-inexact-+1)))))

  (define (use-round-half-towards-0)
    (^+ (^float-round-half-towards-0 expr)
        (^- (^parens
             (^if-expr (^= (^float-mod expr (^float targ-inexact-+2))
                           (^float (- targ-inexact-+1/2))) ;;;;;;;;;;;;;;;;;
                       (^float targ-inexact-+1)
                       (^float targ-inexact-+0)))
            (^parens
             (^if-expr (^= (^float-mod expr (^float targ-inexact-+2))
                           (^float targ-inexact-+1/2))
                       (^float targ-inexact-+1)
                       (^float targ-inexact-+0))))))

  (case (target-name (ctx-target ctx))

    ((js java)
     (use-round-half-up))

    ((php ruby)
     (use-round-half-towards-0))

    ((python)
     (if (univ-python-pre3? ctx)
         (use-round-half-towards-0)
         (^ "round(" expr ")")))
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

    ((js java)
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

    ((js ruby java)
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

    ((js ruby java)
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

    ((js ruby java)
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

    ((js ruby java)
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

    ((js ruby java)
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

    ((js ruby java)
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

    ((js ruby java)
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

    ((js ruby java)
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

    ((js ruby java)
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

    ((js java)
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

    ((js ruby java)
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
      (^new (^type 'flonum) expr)
      expr))

    (else
     expr)))

(define (univ-emit-flonum-unbox ctx expr)
  (case (univ-flonum-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member (^cast* 'flonum expr) 'val)))

    (else
     expr)))

(define (univ-emit-flonum? ctx expr)
  (case (univ-flonum-representation ctx)

    ((class)
     (^instanceof (^type 'flonum) (^cast*-scmobj expr)))

    (else
     (^float? expr))))

(define (univ-emit-cpxnum-make ctx expr1 expr2)
  (^new (^type 'cpxnum) expr1 expr2))

(define (univ-emit-cpxnum? ctx expr)
  (^instanceof (^type 'cpxnum) (^cast*-scmobj expr)))

(define (univ-emit-ratnum-make ctx expr1 expr2)
  (^new (^type 'ratnum) expr1 expr2))

(define (univ-emit-ratnum? ctx expr)
  (^instanceof (^type 'ratnum) (^cast*-scmobj expr)))

(define (univ-emit-bignum ctx expr1)
  (^new (^type 'bignum) expr1))

(define (univ-emit-bignum? ctx expr)
  (^instanceof (^type 'bignum) (^cast*-scmobj expr)))

(define (univ-emit-bignum-digits ctx val)
  (^member (^cast* 'bignum val) 'digits))

(define (univ-emit-box? ctx expr)
  (^instanceof (^type 'box) (^cast*-scmobj expr)))

(define (univ-emit-box ctx expr)
  (^new (^type 'box) expr))

(define (univ-emit-unbox ctx expr)
  (^member (^cast* 'box expr) 'val))

(define (univ-emit-setbox ctx expr1 expr2)
  (^assign (^member expr1 'val) expr2))

(define (univ-emit-values-box ctx expr)
  (case (univ-values-representation ctx)

    ((class)
     (^new (^type 'values) expr))

    (else
     expr)))

(define (univ-emit-values-unbox ctx expr)
  (case (univ-values-representation ctx)

    ((class)
     (^member (^cast* 'values expr) 'vals))

    (else
     expr)))

(define (univ-emit-values? ctx expr)
  (case (univ-values-representation ctx)

    ((class)
     (^instanceof (^type 'values) (^cast*-scmobj expr)))

    (else
     (^array? expr))))

(define (univ-emit-values-length ctx expr)
  (^array-length (^values-unbox expr)))

(define (univ-emit-values-ref ctx expr1 expr2)
  (^array-index (^values-unbox expr1) expr2))

(define (univ-emit-values-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^values-unbox expr1) expr2) expr3))

(define (univ-emit-vector-box ctx expr)
  (case (univ-vector-representation ctx)

    ((class)
     (^new (^type 'vector) expr))

    (else
     expr)))

(define (univ-emit-vector-unbox ctx expr)
  (case (univ-vector-representation ctx)

    ((class)
     (^member (^cast* 'vector expr) 'elems))

    (else
     expr)))

(define (univ-emit-vector? ctx expr)
  (case (univ-vector-representation ctx)

    ((class)
     (^instanceof (^type 'vector) (^cast*-scmobj expr)))

    (else
     (^array? expr))))

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
     (^new (^type 'u8vector) expr))

    (else
     (compiler-internal-error
      "univ-emit-u8vector-box, host representation not implemented"))))

(define (univ-emit-u8vector-unbox ctx expr)
  (case (univ-u8vector-representation ctx)

    ((class)
     (^member (^cast* 'u8vector expr) 'elems))

    (else
     (compiler-internal-error
      "univ-emit-u8vector-unbox, host representation not implemented"))))

(define (univ-emit-u8vector? ctx expr)
  (case (univ-u8vector-representation ctx)

    ((class)
     (^instanceof (^type 'u8vector) (^cast*-scmobj expr)))

    (else
     (compiler-internal-error
      "univ-emit-u8vector?, host representation not implemented"))))

(define (univ-emit-u8vector-length ctx expr)
  (^array-length (^u8vector-unbox expr)))

(define (univ-emit-u8vector-shrink! ctx expr1 expr2)
  (^array-shrink! (^u8vector-unbox expr1) expr2))

(define (univ-emit-u8vector-ref ctx expr1 expr2)
  (let ((code (^array-index (^u8vector-unbox expr1) expr2)))
    (case (target-name (ctx-target ctx))
      ((java) (^parens (^bitand (^int #xff) code)))
      (else   code))))

(define (univ-emit-u8vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^u8vector-unbox expr1) expr2) expr3))

(define (univ-emit-u16vector-box ctx expr)
  (case (univ-u16vector-representation ctx)

    ((class)
     (^new (^type 'u16vector) expr))

    (else
     (compiler-internal-error
      "univ-emit-u16vector-box, host representation not implemented"))))

(define (univ-emit-u16vector-unbox ctx expr)
  (case (univ-u16vector-representation ctx)

    ((class)
     (^member (^cast* 'u16vector expr) 'elems))

    (else
     (compiler-internal-error
      "univ-emit-u16vector-unbox, host representation not implemented"))))

(define (univ-emit-u16vector? ctx expr)
  (case (univ-u16vector-representation ctx)

    ((class)
     (^instanceof (^type 'u16vector) (^cast*-scmobj expr)))

    (else
     (compiler-internal-error
      "univ-emit-u16vector?, host representation not implemented"))))

(define (univ-emit-u16vector-length ctx expr)
  (^array-length (^u16vector-unbox expr)))

(define (univ-emit-u16vector-shrink! ctx expr1 expr2)
  (^array-shrink! (^u16vector-unbox expr1) expr2))

(define (univ-emit-u16vector-ref ctx expr1 expr2)
  (let ((code (^array-index (^u16vector-unbox expr1) expr2)))
    (case (target-name (ctx-target ctx))
      ((java) (^parens (^bitand (^int #xffff) code)))
      (else   code))))

(define (univ-emit-u16vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^u16vector-unbox expr1) expr2) expr3))

(define (univ-emit-f64vector-box ctx expr)
  (case (univ-f64vector-representation ctx)

    ((class)
     (^new (^type 'f64vector) expr))

    (else
     (compiler-internal-error
      "univ-emit-f64vector-box, host representation not implemented"))))

(define (univ-emit-f64vector-unbox ctx expr)
  (case (univ-f64vector-representation ctx)

    ((class)
     (^member (^cast* 'f64vector expr) 'elems))

    (else
     (compiler-internal-error
      "univ-emit-f64vector-unbox, host representation not implemented"))))

(define (univ-emit-f64vector? ctx expr)
  (case (univ-f64vector-representation ctx)

    ((class)
     (^instanceof (^type 'f64vector) (^cast*-scmobj expr)))

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
     (^new (^type 'structure) expr))

    (else
     (compiler-internal-error
      "univ-emit-structure-box, host representation not implemented"))))

(define (univ-emit-structure-unbox ctx expr)
  (case (univ-structure-representation ctx)

    ((class)
     (^member (^cast* 'structure expr) 'slots))

    (else
     (compiler-internal-error
      "univ-emit-structure-unbox, host representation not implemented"))))

(define (univ-emit-structure? ctx expr)
  (case (univ-structure-representation ctx)

    ((class)
     (^instanceof (^type 'structure) (^cast*-scmobj expr)))

    (else
     (compiler-internal-error
      "univ-emit-structure?, host representation not implemented"))))

(define (univ-emit-structure-ref ctx expr1 expr2)
  (^array-index (^structure-unbox expr1) expr2))

(define (univ-emit-structure-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^structure-unbox expr1) expr2) expr3))

(define (univ-emit-str ctx val)
  (univ-constant
   (case (target-name (ctx-target ctx))

     ((js java)
      (cdr (univ-convert-string val #\" #\")))

     ((php)
      (let ((val-utf8
             (list->string
              (map integer->char
                   (u8vector->list
                    (call-with-output-u8vector
                     (list init: '#u8() char-encoding: 'UTF-8)
                     (lambda (port) (univ-display val port))))))))
        (cdr (univ-convert-string val-utf8 #\" #\$))))

     ((python)
      (let ((x (univ-convert-string val #\" #\")))
        (if (car x) (cons "u" (cdr x)) (cdr x))))

     ((ruby)
      (cdr (univ-convert-string val #\" #\#)))

     (else
      (compiler-internal-error
       "univ-emit-str, unknown target")))))

(define (univ-convert-string str delim special)
  (let ((unicode? #f))
    (let loop ((i 0) (j 0) (rev-chunks (list (string delim))))

      (define (done rev-chunks)
        (cons unicode? (reverse (cons (string delim) rev-chunks))))

      (define (add i j)
        (if (= i j)
            rev-chunks
            (cons (substring str i j) rev-chunks)))

      (if (= j (string-length str))
          (done (add i j))
          (let ((next-j (+ j 1))
                (c (string-ref str j)))
            (if (or (char=? c #\\)
                    (char=? c delim)
                    (char=? c special))
                (loop next-j
                      next-j
                      (cons (string #\\ c)
                            (add i j)))
                (let ((n (char->integer c)))
                  (cond ((< n #x100)
                         (if (or (< n 32) (>= n 127))
                             (let ((x (number->string (+ #x100 n) 16)))
                               (loop next-j
                                     next-j
                                     (cons (string-append "\\x"
                                                          (substring x 1 3))
                                           (add i j))))
                             (loop i
                                   (+ j 1)
                                   rev-chunks)))
                        ((< n #x10000)
                         (let ((x (number->string (+ #x10000 n) 16)))
                           (set! unicode? #t)
                           (loop next-j
                                 next-j
                                 (cons (string-append "\\u"
                                                      (substring x 1 5))
                                       (add i j)))))
                        (else
                         (let* ((hi (quotient (- n #x10000) #x400))
                                (lo (modulo n #x400))
                                (hi-x (number->string (+ #xd800 hi) 16))
                                (lo-x (number->string (+ #xdc00 lo) 16)))
                           (set! unicode? #t)
                           (loop next-j
                                 next-j
                                 (cons (string-append "\\u" hi-x "\\u" lo-x)
                                       (add i j)))))))))))))

(define (univ-emit-str-to-codes ctx str)
  (case (univ-string-representation ctx)

    ((class)
     (^call-prim
      (^rts-method-use 'str2codes)
      str))

    (else
     str)))

(define (univ-emit-str-length ctx str)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ str ".length"))

    ((php)
     (^ "strlen(" str ")"))

    ((python)
     (^ "len(" str ")"))

    ((java)
     (^ str ".length()"))

    (else
     (compiler-internal-error
      "univ-emit-str-length, unknown target"))))

(define (univ-emit-str-index-code ctx str i)
  (case (target-name (ctx-target ctx))

    ((js)
     (^call-prim (^member str 'charCodeAt) i))

    ((php)
     (^call-prim "ord" (^call-prim "substr" str i (^int 1))));;TODO fix for unicode characters

    ((python)
     (^call-prim "ord" (^ str "[" i "]")))

    ((ruby)
     (^ str "[" i "]" ".ord"))

    ((java)
     (^call-prim (^member str 'codePointAt) i))

    (else
     (compiler-internal-error
      "univ-emit-str-index-code, unknown target"))))

(define (univ-emit-string-obj ctx obj force-var?)
  (case (univ-string-representation ctx)

    ((class)
     (let ((x
            (^array-literal
             'unicode
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
     (^new (^type 'string) expr))

    (else
     expr)))

(define (univ-emit-string-unbox ctx expr)
  (case (univ-string-representation ctx)

    ((class)
     (^member (^cast* 'string expr) 'codes))

    (else
     expr)))

(define (univ-emit-string? ctx expr)
  (case (univ-string-representation ctx)

    ((class)
     (^instanceof (^type 'string) (^cast*-scmobj expr)))

    (else
     (^str? expr))))


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
     (^str-index-code expr1 expr2))))

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
        (univ-constant (^ ":" (^str (symbol->string obj)))))

       (else
        (compiler-internal-error
         "univ-emit-symbol-obj, unknown target"))))))

(define (univ-emit-symbol-box ctx name)
  (case (univ-symbol-representation ctx)

    ((class)
     (univ-box
      (^call-prim
       (^rts-method-use 'make_interned_symbol)
       name)
      name))

    (else
     (^symbol-box-uninterned name #f))))

(define (univ-emit-symbol-box-uninterned ctx name hash)
  (case (univ-symbol-representation ctx)

    ((class)
     (univ-box
      (^new (^type 'symbol) name hash)
      name))

    (else
     (case (target-name (ctx-target ctx))

       ((js php python)
        name)

       ((ruby)
        (^ name ".to_sym"))

       (else
        (compiler-internal-error
         "univ-emit-symbol-box-uninterned, unknown target"))))))

(define (univ-emit-symbol-unbox ctx expr)
  (case (univ-symbol-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member (^cast* 'symbol expr) 'name)))

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
     (^instanceof (^type 'symbol) (^cast*-scmobj expr)))

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

(define (univ-emit-keyword-box ctx name)
  (case (univ-keyword-representation ctx)

    ((class)
     (univ-box
      (^call-prim
       (^rts-method-use 'make_interned_keyword)
       name)
      name))

    (else
     (^keyword-box-uninterned name #f))))

(define (univ-emit-keyword-box-uninterned ctx name hash)
  (case (univ-keyword-representation ctx)

    ((class)
     (univ-box
      (^new (^type 'keyword) name hash)
      name))

    (else
     (case (target-name (ctx-target ctx))

       ((js php python)
        name)

       ((ruby)
        (^ name ".to_sym"))

       (else
        (compiler-internal-error
         "univ-emit-keyword-box-uninterned, unknown target"))))))

(define (univ-emit-keyword-unbox ctx expr)
  (case (univ-keyword-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member (^cast* 'keyword expr) 'name)))

    (else
     (compiler-internal-error
      "univ-emit-keyword-unbox, host representation not implemented"))))

(define (univ-emit-keyword? ctx expr)
  (case (univ-keyword-representation ctx)

    ((class)
     (^instanceof (^type 'keyword) (^cast*-scmobj expr)))

    (else
     (compiler-internal-error
      "univ-emit-keyword?, host representation not implemented"))))

(define (univ-emit-frame-box ctx expr)
  (case (univ-frame-representation ctx)

    ((class)
     (univ-box
      (^new (^type 'frame) expr)
      expr))

    (else
     expr)))

(define (univ-emit-frame-unbox ctx expr)
  (case (univ-frame-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member (^cast* 'frame expr)
                  'slots)))

    (else
     expr)))

(define (univ-emit-frame-slots ctx expr)
  (case (univ-frame-representation ctx)

    ((class)
     (or (univ-unbox expr)
         (^member expr
                  'slots)))

    (else
     expr)))

(define (univ-emit-frame? ctx expr)
  (case (univ-frame-representation ctx)

    ((class)
     (^instanceof (^type 'frame) (^cast*-scmobj expr)))

    (else
     (^array? expr))))

(define (univ-emit-new-continuation ctx expr1 expr2)
  (^new (^type 'continuation) expr1 expr2))

(define (univ-emit-continuation? ctx expr)
  (^instanceof (^type 'continuation) (^cast*-scmobj expr)))

(define (univ-emit-function? ctx expr)
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
       "univ-emit-function?, unknown target"))))

(define (univ-emit-procedure? ctx expr)
  (case (univ-procedure-representation ctx)

    ((class)
     ;; this accounts for procedure control-points and closures
     (^instanceof (^type 'jumpable) (^cast*-scmobj expr)))

    (else
     (^function? expr))))

(define (univ-emit-return? ctx expr)
  (case (univ-procedure-representation ctx)

    ((class)
     (^instanceof (^type 'returnpt) (^cast*-scmobj expr)))

    (else
     (^bool #t)))) ;;TODO: implement

(define (univ-emit-closure? ctx expr)
  (case (univ-procedure-representation ctx)

    ((class)
     (^instanceof (^type 'closure) (^cast*-scmobj expr)))

    (else
     (case (target-name (ctx-target ctx))

       ((js)
        (^not (^prop-index-exists? expr (^str "id"))))

       ((php)
        (^instanceof (^type 'closure) expr))

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

(define (univ-emit-new-promise ctx expr)
  (^new (^type 'promise) expr))

(define (univ-emit-promise? ctx expr)
  (^instanceof (^type 'promise) (^cast*-scmobj expr)))

(define (univ-emit-new-will ctx expr1 expr2)
  (^new (^type 'will) expr1 expr2))

(define (univ-emit-will? ctx expr)
  (^instanceof (^type 'will) (^cast*-scmobj expr)))

(define (univ-emit-call-prim ctx expr . params)
  (univ-emit-call-prim-aux ctx expr params))

(define (univ-emit-call-prim-aux ctx expr params)
  (if (and (null? params)
           (eq? (target-name (ctx-target ctx)) 'ruby))
      expr
      (univ-emit-apply-aux ctx expr params "(" ")")))

(define (univ-emit-jump ctx proc . params)
  (case (univ-procedure-representation ctx)

    ((class)
     (univ-emit-call-prim-aux ctx (^member proc 'jump) params))

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

    ((js java)
     "this")

    ((php)
     "$this")

    ((python ruby)
     "self")

    (else
     (compiler-internal-error
      "univ-emit-this, unknown target"))))

(define (univ-emit-new ctx class . params)
  (case (target-name (ctx-target ctx))

    ((js php java)
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
     (^= (^ "typeof " expr) (^str type)))

    (else
     (compiler-internal-error
      "unit-emit-typeof, unknown target"))))

(define (univ-emit-instanceof ctx class expr)
  (case (target-name (ctx-target ctx))

    ((js java)
     (^ expr " instanceof " class))

    ((php)
     ;; PHP raises a syntax error when expr is a constant, so this case
     ;; is handled specially by generating (0?0:expr) which fools the compiler
     (^ (if (univ-box? expr)
            (^if-expr (^int 0) (^int 0) expr)
            expr)
        " instanceof "
        class))

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
     (^ (^parens (^/ expr1 expr2)) " | 0"))

    ((php)
     (^float-toint (^/ expr1 expr2)))

    ((python ruby)
     (^float-toint (^/ (^float-fromint expr1) (^float-fromint expr2))))

    ((java)
     (^/ expr1 expr2))

    (else
     (compiler-internal-error
      "univ-fxquotient, unknown target"))))

(define (univ-fxmodulo ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php java)
     (^ (^parens (^ (^parens (^ expr1 " % " expr2)) " + " expr2)) " % " expr2))

    ((python ruby)
     (^ expr1 " % " expr2))

    (else
     (compiler-internal-error
      "univ-fxmodulo, unknown target"))))

(define (univ-fxremainder ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php java)
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

(univ-define-prim-bool "##structure?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^structure? arg1)))))

;; TODO: test box? primitive

(univ-define-prim-bool "##box?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^box? arg1)))))

(univ-define-prim-bool "##values?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^values? arg1)))))

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

(univ-define-prim-bool "##promise?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^promise? arg1)))))

(univ-define-prim-bool "##will?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^will? arg1)))))

;;TODO: ("##gc-hash-table?"           (1)   #f ()    0    boolean extended)
;;TODO: ("##mem-allocated?"           (1)   #f ()    0    boolean extended)

;; TODO: test ##procedure?

(univ-define-prim-bool "##procedure?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^procedure? arg1)))))

(univ-define-prim-bool "##return?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^return? arg1)))))

;;TODO: ("##foreign?"                 (1)   #f ()    0    boolean extended)

(univ-define-prim-bool "##string?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^string? arg1)))))

;;TODO: ("##s8vector?"                (1)   #f ()    0    boolean extended)
;;TODO: ("##s16vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##s32vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##u32vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##s64vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##u64vector?"               (1)   #f ()    0    boolean extended)
;;TODO: ("##f32vector?"               (1)   #f ()    0    boolean extended)

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
     (return (^member (^cast* 'cpxnum arg1) 'real)))))

(univ-define-prim "##cpxnum-imag" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^member (^cast* 'cpxnum arg1) 'imag)))))

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
     (return (^member (^cast* 'ratnum arg1) 'num)))))

(univ-define-prim "##ratnum-denominator" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^member (^cast* 'ratnum arg1) 'den)))))

(univ-define-prim-bool "##ratnum?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^ratnum? arg1)))))

(univ-define-prim-bool "##bignum?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^bignum? arg1)))))

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
         (^ "(" (^rts-field-use 'inttemp2) " = (" (^rts-field-use 'inttemp1) " = "
            (^fixnum-unbox arg1)
            " + "
            (^fixnum-unbox arg2)
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits
            ") === " (^rts-field-use 'inttemp1) " && " (^fixnum-box (^rts-field-use 'inttemp2))))

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
                      (^rts-field-use 'inttemp2)
                      (^-
                       (^parens
                        (^bitand
                         (^parens
                          (^+
                           (^parens
                            (^assign-expr
                             (^rts-field-use 'inttemp1)
                             (^+ (^fixnum-unbox arg1)
                                 (^fixnum-unbox arg2))))
                           univ-fixnum-max+1))
                         univ-fixnum-max*2+1))
                       univ-fixnum-max+1)))
                    (^rts-field-use 'inttemp1)))
               (^fixnum-box (^rts-field-use 'inttemp2))))

        ((java)
         (^if-expr
          (^ "(" (^rts-field-use 'inttemp2) " = (" (^rts-field-use 'inttemp1) " = "
             (^fixnum-unbox arg1)
             " + "
             (^fixnum-unbox arg2)
             ")<<"
             univ-tag-bits
             ">>"
             univ-tag-bits
             ") == " (^rts-field-use 'inttemp1))
          (^fixnum-box (^rts-field-use 'inttemp2))
          (^obj #f)))

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
         (^ "(" (^rts-field-use 'inttemp2) " = (" (^rts-field-use 'inttemp1) " = "
            (^fixnum-unbox arg1)
            " * "
            (^fixnum-unbox arg2)
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits
            ") === " (^rts-field-use 'inttemp1) " && " (^fixnum-box (^rts-field-use 'inttemp2))))

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
                      (^rts-field-use 'inttemp2)
                      (^-
                       (^parens
                        (^bitand
                         (^parens
                          (^+
                           (^parens
                            (^assign-expr
                             (^rts-field-use 'inttemp1)
                             (^* (^fixnum-unbox arg1)
                                 (^fixnum-unbox arg2))))
                           univ-fixnum-max+1))
                         univ-fixnum-max*2+1))
                       univ-fixnum-max+1)))
                    (^rts-field-use 'inttemp1)))
               (^fixnum-box (^rts-field-use 'inttemp2))))

        ((java)
         (^if-expr
          (^ "(" (^rts-field-use 'inttemp2) " = (" (^rts-field-use 'inttemp1) " = "
             (^fixnum-unbox arg1)
             " * "
             (^fixnum-unbox arg2)
             ")<<"
             univ-tag-bits
             ">>"
             univ-tag-bits
             ") == " (^rts-field-use 'inttemp1))
          (^fixnum-box (^rts-field-use 'inttemp2))
          (^obj #f)))

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
         (^ "(" (^rts-field-use 'inttemp2) " = (" (^rts-field-use 'inttemp1) " = "
            (if arg2
                (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                (^ "- " (^fixnum-unbox arg1)))
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits
            ") === " (^rts-field-use 'inttemp1) " && " (^fixnum-box (^rts-field-use 'inttemp2))))

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
         (^ "(" (^rts-field-use 'inttemp2) " = (((" (^rts-field-use 'inttemp1) " = "
            (if arg2
                (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                (^ "- " (^fixnum-unbox arg1)))
            ") + "
            univ-fixnum-max+1
            ") & "
            univ-fixnum-max*2+1
            ") - "
            univ-fixnum-max+1
            ") == " (^rts-field-use 'inttemp1) " && " (^fixnum-box (^rts-field-use 'inttemp2))))

        ((php)
         (^ "((" (^rts-field-use 'inttemp2) " = (((" (^rts-field-use 'inttemp1) " = "
            (if arg2
                (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                (^ "- " (^fixnum-unbox arg1)))
            ") + "
            univ-fixnum-max+1
            ") & "
            univ-fixnum-max*2+1
            ") - "
            univ-fixnum-max+1
            ") === " (^rts-field-use 'inttemp1) ") ? " (^fixnum-box (^rts-field-use 'inttemp2)) " : false"))

        ((java)
         (^if-expr
          (^ "(" (^rts-field-use 'inttemp2) " = (" (^rts-field-use 'inttemp1) " = "
             (if arg2
                 (^ (^fixnum-unbox arg1) " - " (^fixnum-unbox arg2))
                 (^ "- " (^fixnum-unbox arg1)))
             ")<<"
             univ-tag-bits
             ">>"
             univ-tag-bits
             ") == " (^rts-field-use 'inttemp1))
          (^fixnum-box (^rts-field-use 'inttemp2))
          (^obj #f)))

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
     (let ((tmp (^local-var (univ-gensym ctx 'tmp))))
       (^ (^var-declaration 'int tmp (^fixnum-unbox arg))
          (^assign tmp (^if-expr (^< tmp (^int 0)) (^bitnot tmp) tmp))
          (^popcount! tmp)
          (return (^fixnum-box tmp)))))))

(univ-define-prim "##fxlength" #f
  (make-translated-operand-generator
    (lambda (ctx return arg)
      (let ((tmp (^local-var (univ-gensym ctx 'tmp))))
        (^ (^var-declaration 'int tmp (^fixnum-unbox arg))
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
      (let ((tmp (^local-var (univ-gensym ctx 'tmp))))
        (^ (^var-declaration 'int tmp (^fixnum-unbox arg))
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
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^<< (^fixnum-unbox arg1)
                      (^fixnum-unbox arg2)))
        (return
         (^if-expr (case (target-name (ctx-target ctx))
                    ((js)
                     (^= (^>> (^>> (^<< (^rts-field-use 'inttemp1) univ-tag-bits)
                                   univ-tag-bits)
                              (^fixnum-unbox arg2))
                         (^fixnum-unbox arg1)))
                    ((php python ruby)
                     (let ((sign-bit (- (- univ-word-bits univ-tag-bits)
                                        1)))
                        (^= (^rts-field-use 'inttemp1)
                            (^-
                             (^parens
                               (^bitand (^parens (^+ (^rts-field-use 'inttemp1)
                                                     (expt 2 sign-bit)))
                                        (- (expt 2 (+ 1 sign-bit)) 1)))
                             (expt 2 sign-bit))))))
                   (^fixnum-box (^rts-field-use 'inttemp1))
                   (^obj #f)))))))

(univ-define-prim "##fxwraparithmetic-shift-left" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
       (case (target-name (ctx-target ctx))
        ((js java)
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
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^<< (^fixnum-unbox arg1)
                      (^fixnum-unbox arg2)))
        (return
         (^if-expr (case (target-name (ctx-target ctx))
                    ((js java)
                     (^= (^>> (^>> (^<< (^rts-field-use 'inttemp1) univ-tag-bits)
                                   univ-tag-bits)
                              (^fixnum-unbox arg2))
                         (^fixnum-unbox arg1)))
                    ((php python ruby)
                     (let ((sign-bit (- (- univ-word-bits univ-tag-bits)
                                        1)))
                        (^= (^rts-field-use 'inttemp1)
                            (^-
                             (^parens
                               (^bitand (^parens (^+ (^rts-field-use 'inttemp1)
                                                     (expt 2 sign-bit)))
                                        (- (expt 2 (+ 1 sign-bit)) 1)))
                             (expt 2 sign-bit))))))
                   (^fixnum-box (^rts-field-use 'inttemp1))
                   (^obj #f)))))))

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

(univ-define-prim "##flonum->fixnum" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^float-toint (^flonum-unbox arg)))))))

(univ-define-prim "##fixnum->flonum" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^flonum-box (^float-fromint (^fixnum-unbox arg)))))))

(univ-define-prim-bool "##fixnum->flonum-exact?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^bool #t)))))

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
      (^if-expr (^= (^parens
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

;;TODO: ("##make-will"                    (2)   #t ()    0    #f      extended)
;;TODO: ("##will-testator"                (1)   #f ()    0    (#f)    extended)

;;TODO: ("##gc-hash-table-ref"            (2)   #f ()    0    (#f)    extended)
;;TODO: ("##gc-hash-table-set!"           (3)   #t ()    0    (#f)    extended)
;;TODO: ("##gc-hash-table-rehash!"        (2)   #t ()    0    (#f)    extended)

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
     (^ (^setbox (^cast* 'box arg1) arg2)
        (return arg1)))))

(univ-define-prim "##values" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return (^values-box (^array-literal 'scmobj args))))))

(univ-define-prim "##make-values" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_values)
       (^fixnum-unbox arg1)
       (if arg2
           arg2
           (^fixnum-box (^int 0))))))))

(univ-define-prim "##values-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return (^fixnum-box (^values-length arg))))))

(univ-define-prim "##values-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return (^values-ref arg1
                          (^fixnum-unbox arg2))))))

(univ-define-prim "##values-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^values-set! arg1
                      (^fixnum-unbox arg2)
                      arg3)
        (return arg1)))))

(univ-define-prim "##vector" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (^vector-box
       (^array-literal 'scmobj args))))))

(univ-define-prim "##make-vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_vector)
       (^fixnum-unbox arg1)
       (if arg2
           arg2
           (^fixnum-box (^int 0))))))))

(univ-define-prim "##vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^vector-length arg))))))

(univ-define-prim "##vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^vector-ref arg1
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
     (return
      (^u8vector-box
       (^array-literal
        'u8
        (map (lambda (arg)
               (^cast* 'u8
                       (^fixnum-unbox arg)))
             args)))))))

(univ-define-prim "##make-u8vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_u8vector)
       (^fixnum-unbox arg1)
       (^cast* 'u8
               (if arg2
                   (^fixnum-unbox arg2)
                   (^int 0))))))))

(univ-define-prim "##u8vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^u8vector-length arg))))))

(univ-define-prim "##u8vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box
       (^u8vector-ref arg1
                      (^fixnum-unbox arg2)))))))

(univ-define-prim "##u8vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^u8vector-set! arg1
                        (^fixnum-unbox arg2)
                        (^fixnum-unbox arg3))
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
     (return
      (^u16vector-box
       (^array-literal
        'u16
        (map (lambda (arg)
               (^cast* 'u16
                       (^fixnum-unbox arg)))
             args)))))))

(univ-define-prim "##make-u16vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_u16vector)
       (^fixnum-unbox arg1)
       (^cast* 'u16
               (if arg2
                   (^fixnum-unbox arg2)
                   (^int 0))))))))

(univ-define-prim "##u16vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^u16vector-length arg))))))

(univ-define-prim "##u16vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box
       (^u16vector-ref arg1
                       (^fixnum-unbox arg2)))))))

(univ-define-prim "##u16vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^u16vector-set! arg1
                         (^fixnum-unbox arg2)
                         (^fixnum-unbox arg3))
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
     (return
      (^f64vector-box
       (^array-literal
        'f64
        (map (lambda (arg)
               (^cast* 'f64
                       (^flonum-unbox arg)))
             args)))))))

(univ-define-prim "##make-f64vector" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_f64vector)
       (^fixnum-unbox arg1)
       (if arg2
           (^flonum-unbox arg2)
           (^float targ-inexact-+0)))))))

(univ-define-prim "##f64vector-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^f64vector-length arg))))))

(univ-define-prim "##f64vector-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^flonum-box
       (^f64vector-ref arg1
                       (^fixnum-unbox arg2)))))))

(univ-define-prim "##f64vector-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^f64vector-set! arg1
                         (^fixnum-unbox arg2)
                         (^flonum-unbox arg3))
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
      (^string-box
       (^array-literal 'unicode (map (lambda (x) (^char-unbox x)) args)))))))

(univ-define-prim "##make-string" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 #!optional (arg2 #f))
     (return
      (^call-prim
       (^rts-method-use 'make_string)
       (^fixnum-unbox arg1)
       (if arg2
           (^char-unbox arg2)
           (^chr-fromint 0)))))))

(univ-define-prim "##string-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg)
     (return
      (^fixnum-box
       (^string-length arg))))))

(univ-define-prim "##string-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^char-box
       (^string-ref (^string-unbox arg1)
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

(univ-define-prim "##make-structure" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^call-prim
       (^rts-method-use 'make_structure)
       arg1
       (^fixnum-unbox arg2))))))

(univ-define-prim "##structure-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^fixnum-box (^array-length (^structure-unbox arg1)))))))

(univ-define-prim "##structure" #t
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return (^structure-box (^array-literal 'scmobj args))))))

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

(univ-define-prim "##symbol->string" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^str->string (^symbol-unbox arg1))))))

(univ-define-prim "##string->symbol" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^symbol-box (^string->str arg1))))))

(univ-define-prim "##make-uninterned-symbol" #f
  (make-translated-operand-generator
   (lambda (ctx return name hash)
     (return (^symbol-box-uninterned (^string->str name) hash)))))

(univ-define-prim "##symbol-name" #f
  (make-translated-operand-generator
   (lambda (ctx return sym)
     ;;;;FIXME for host representation
     (return
       (^str->string (^member (^cast* 'symbol sym) 'name))))))

(univ-define-prim "##symbol-name-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return sym name)
     (^ (^assign (^member (^cast* 'symbol sym) 'name)
                 (^string->str name))
        (return sym)))))

(univ-define-prim "##symbol-hash" #f
  (make-translated-operand-generator
   (lambda (ctx return sym)
     ;;;;FIXME for host representation
     (return (^member (^cast* 'symbol sym) 'hash)))))

(univ-define-prim "##symbol-hash-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return sym hash)
     (^ (^assign (^member (^cast* 'symbol sym) 'hash) hash)
        (return sym)))))

(univ-define-prim "##symbol-interned?" #f
  (make-translated-operand-generator
   (lambda (ctx return sym)
     (return (^member (^cast* 'symbol sym) 'interned)))));;;;FIXME for host representation

(univ-define-prim "##keyword->string" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^str->string (^keyword-unbox arg1))))))

(univ-define-prim "##string->keyword" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^keyword-box (^string->str arg1))))))

(univ-define-prim "##make-uninterned-keyword" #f
  (make-translated-operand-generator
   (lambda (ctx return name hash)
     (return (^keyword-box-uninterned (^string->str name) hash)))))

(univ-define-prim "##keyword-name" #f
  (make-translated-operand-generator
   (lambda (ctx return key)
     ;;;;FIXME for host representation
     (return
       (^str->string (^member (^cast* 'keyword key) 'name))))))

(univ-define-prim "##keyword-name-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return key name)
     (^ (^assign (^member (^cast* 'keyword key) 'name)
                 (^string->str name))
        (return key)))))

(univ-define-prim "##keyword-hash" #f
  (make-translated-operand-generator
   (lambda (ctx return key)
     ;;;;FIXME for host representation
     (return (^member (^cast* 'keyword key) 'hash)))))

(univ-define-prim "##keyword-hash-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return key hash)
     (^ (^assign (^member (^cast* 'keyword key) 'hash) hash)
        (return key)))))

(univ-define-prim "##keyword-interned?" #f
  (make-translated-operand-generator
   (lambda (ctx return key)
     (return (^member (^cast* 'keyword key) 'interned)))));;;;FIXME for host representation


;;TODO: ("##closure-length"               (1)   #f ()    0    fixnum  extended)
;;TODO: ("##closure-code"                 (1)   #f ()    0    #f      extended)
;;TODO: ("##closure-ref"                  (2)   #f ()    0    (#f)    extended)
;;TODO: ("##closure-set!"                 (3)   #t ()    0    #f      extended)

(univ-define-prim "##make-closure" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^call-prim
       (^rts-method-use 'make_closure)
       arg1
       (^fixnum-unbox arg2))))))

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
     (return
      (^call-prim
       (^rts-method-use 'make_subprocedure)
       (^cast* 'parententrypt arg1)
       (^fixnum-unbox arg2))))))

(univ-define-prim "##subprocedure-id" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-call-with-ctrlpt-attrib
      ctx
      arg1
      'ctrlpt
      'id
      (lambda (result)
        (return (^fixnum-box result)))))))

(define (univ-ctrlpt-reference-type ctx)
  (if (and (eq? (target-name (ctx-target ctx)) 'php)
           (eq? (univ-procedure-representation ctx) 'host))
      'str
      'ctrlpt))

(define (univ-ctrlpt-reference ctx lbl-num)
  (let ((lbl (make-lbl lbl-num)))
    (if (eq? (univ-ctrlpt-reference-type ctx) 'str)
        (^str (^prefix (gvm-lbl-use-aux ctx lbl)))
        (gvm-lbl-use ctx lbl))))

(define (univ-prm-name ctx name)
  (if (eq? (univ-ctrlpt-reference-type ctx) 'str)
      (^str name)
      (^obj (string->symbol name))))

(define (univ-ctrlpt-reference-to-ctrlpt ctx ref)
  ref
  ;; in PHP a function is a string!
  #;
  (if (eq? (univ-ctrlpt-reference-type ctx) 'str)
      (^call-prim
       (^rts-method-use 'get_host_global_var)
       ref)
      ref))

(define (univ-parent-entry-point-has-null-parent? ctx)
  (and (eq? (univ-procedure-representation ctx) 'host)
       (case (target-name (ctx-target ctx))
         ((js) #f)
         ((php) (not (univ-php-pre53? ctx)))
         (else #t))))

(define (univ-method-reference ctx meth)
  (if (and (eq? (target-name (ctx-target ctx)) 'php)
           (univ-php-pre53? ctx))
      (univ-stringify-method meth)
      meth))

(define univ-stringify-delimiter (string #\"))
  
(define (univ-stringify-method meth)
  (list univ-stringify-delimiter meth univ-stringify-delimiter))

(define (univ-unstringify-method meth)
  (if (and (pair? meth) (eq? (car meth) univ-stringify-delimiter))
      (cadr meth)
      meth))

(univ-define-prim "##subprocedure-parent" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-subprocedure-parent ctx return arg1))))

(define (univ-subprocedure-parent ctx return arg1)
  (univ-call-with-ctrlpt-attrib
   ctx
   (^cast* 'ctrlpt arg1)
   'ctrlpt
   'parent
   (lambda (result)
     (return
      (if (univ-parent-entry-point-has-null-parent? ctx)
          (^if-expr (^eq? result (^null))
                    (^cast* 'ctrlpt arg1)
                    (univ-ctrlpt-reference-to-ctrlpt ctx result))
          result)))))

(univ-define-prim "##subprocedure-nb-parameters" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-call-with-ctrlpt-attrib
      ctx
      arg1
      'entrypt
      'nb_parameters
      (lambda (result)
        (return (^fixnum-box result)))))))

(univ-define-prim "##subprocedure-nb-closed" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-call-with-ctrlpt-attrib
      ctx
      arg1
      'entrypt
      'nb_closed
      (lambda (result)
        (return (^fixnum-box result)))))))

(univ-define-prim "##subprocedure-parent-name" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-subprocedure-parent
      ctx
      (lambda (result)
        (univ-call-with-ctrlpt-attrib
         ctx
         result
         'parententrypt
         (univ-proc-name-attrib ctx)
         (lambda (result)
           (return
            (if (eq? (univ-ctrlpt-reference-type ctx) 'str)
                (^symbol-box result)
                result)))))
      arg1))))

(univ-define-prim "##subprocedure-parent-info" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (univ-subprocedure-parent
      ctx
      (lambda (result)
        (univ-call-with-ctrlpt-attrib
         ctx
         result
         'parententrypt
         'info
         return))
      arg1))))

(univ-define-prim "##make-promise" #t
  (make-translated-operand-generator
   (lambda (ctx return thunk)
     (return (^new-promise thunk)))))

(univ-define-prim "##promise-thunk" #f
  (make-translated-operand-generator
   (lambda (ctx return sym)
     (return (^member (^cast* 'promise sym) 'thunk)))))

(univ-define-prim "##promise-thunk-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return sym thunk)
     (^ (^assign (^member (^cast* 'promise sym) 'thunk) thunk)
        (return sym)))))

(univ-define-prim "##promise-result" #f
  (make-translated-operand-generator
   (lambda (ctx return sym)
     (return (^member (^cast* 'promise sym) 'result)))))

(univ-define-prim "##promise-result-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return sym result)
     (^ (^assign (^member (^cast* 'promise sym) 'result) result)
        (return sym)))))


;;TODO: ("##force"                        (1)   #t 0     0    #f      extended)

(univ-define-prim "##void" #t
  (make-translated-operand-generator
   (lambda (ctx return)
     (return (^void-obj)))))

(univ-define-prim "##current-thread" #t
  (make-translated-operand-generator
   (lambda (ctx return)
     (return (^rts-field-use 'current_thread)))))

;;TODO: ("##run-queue"                    (0)   #f ()    0    #f      extended)

;;TODO: ("##thread-save!"                 1     #t ()    1113 (#f)    extended)
;;TODO: ("##thread-restore!"              2     #t ()    2203 #f      extended)

;;TODO: ("##continuation-capture"         1     #t ()    1113 (#f)    extended)
;;TODO: ("##continuation-graft"           2     #t ()    2203 #f      extended)
;;TODO: ("##continuation-graft-no-winding" 2     #t ()    2203 #f      extended)
;;TODO: ("##continuation-return"           (2)   #t ()    0    #f      extended)
;;TODO: ("##continuation-return-no-winding"(2)   #t ()    0    #f      extended)

(univ-define-prim-bool "##continuation?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^continuation? arg1)))))

(univ-define-prim "##make-continuation" #t
  (make-translated-operand-generator
   (lambda (ctx return frame denv)
     (return (^new-continuation
              (^cast* 'frame frame)
              denv)))))

(univ-define-prim "##continuation-frame" #t
  (make-translated-operand-generator
   (lambda (ctx return cont)
     (return (^member (^cast* 'continuation cont) 'frame)))))

(univ-define-prim "##continuation-frame-set!" #t
  (make-translated-operand-generator
   (lambda (ctx return cont frame)
     (^ (^assign (^member (^cast* 'continuation cont) 'frame) frame)
        (return cont)))))

(univ-define-prim "##continuation-denv" #t
  (make-translated-operand-generator
   (lambda (ctx return cont)
     (return (^member (^cast* 'continuation cont) 'denv)))))

(univ-define-prim "##continuation-denv-set!" #t
  (make-translated-operand-generator
   (lambda (ctx return cont denv)
     (^ (^assign (^member (^cast* 'continuation cont) 'denv) denv)
        (return cont)))))

(univ-define-prim "##continuation-next" #t
  (make-translated-operand-generator
   (lambda (ctx return cont)
     (return
      (^call-prim
       (^rts-method-use 'continuation_next)
       (^cast* 'continuation cont))))))

(univ-define-prim "##continuation-ret" #t
  (make-translated-operand-generator
   (lambda (ctx return cont)
     (return (univ-frame-ra ctx (^member (^cast* 'continuation cont) 'frame))))))

(define (univ-get-cont-ra-field attrib)
  (make-translated-operand-generator
   (lambda (ctx return cont)
     (univ-get-ra-field
      ctx
      return
      (univ-frame-ra ctx (^member (^cast* 'continuation cont) 'frame))
      attrib))))

(univ-define-prim "##continuation-fs"   #f (univ-get-cont-ra-field 'fs))
(univ-define-prim "##continuation-link" #f (univ-get-cont-ra-field 'link))

(univ-define-prim "##continuation-ref" #t
  (make-translated-operand-generator
   (lambda (ctx return cont index)
     (return
      (univ-frame-ref
       ctx
       (^frame-unbox (^member (^cast* 'continuation cont) 'frame))
       (^fixnum-unbox index))))))

(univ-define-prim "##continuation-set!" #t
  (make-translated-operand-generator
   (lambda (ctx return cont index val)
     (^ (univ-frame-set!
         ctx
         (^frame-unbox (^member (^cast* 'continuation cont) 'frame))
         (^fixnum-unbox index)
         val)
        (return cont)))))

(univ-define-prim "##continuation-slot-live?" #t
  (make-translated-operand-generator
   (lambda (ctx return cont index)
     (return
      (^boolean-box
       (univ-frame-slot-live? ctx (^member (^cast* 'continuation cont) 'frame) index))))))

(univ-define-prim-bool "##frame?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^frame? arg1)))))

(univ-define-prim "##make-frame" #t
  (make-translated-operand-generator
   (lambda (ctx return ra)
     (return
       (^call-prim
         (^rts-method-use 'make_frame)
         (^cast* 'returnpt ra))))))

(univ-define-prim "##frame-ret" #t
  (make-translated-operand-generator
   (lambda (ctx return frame)
     (return (univ-frame-ra ctx frame)))))

(define (univ-frame-ra ctx frame)
  (^cast* 'returnpt (^array-index (^frame-unbox frame) 0)))

(define (univ-get-frame-ra-field attrib)
  (make-translated-operand-generator
   (lambda (ctx return frame)
     (univ-get-ra-field
      ctx
      return
      (univ-frame-ra ctx frame)
      attrib))))

(univ-define-prim "##frame-fs"   #f (univ-get-frame-ra-field 'fs))
(univ-define-prim "##frame-link" #f (univ-get-frame-ra-field 'link))

(univ-define-prim "##frame-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return frame index)
     (return
      (univ-frame-ref
       ctx
       (^frame-unbox frame)
       (^fixnum-unbox index))))))

(univ-define-prim "##frame-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return frame index val)
     (^ (univ-frame-set!
         ctx
         (^frame-unbox frame)
         (^fixnum-unbox index)
         val)
        (return frame)))))

(univ-define-prim "##frame-slot-live?" #t
  (make-translated-operand-generator
   (lambda (ctx return frame index)
     (return
      (^boolean-box
       (univ-frame-slot-live? ctx frame index))))))

(define (univ-frame-ref ctx frame index)
  (^array-index frame index))

(define (univ-frame-set! ctx frame index val)
  (^assign (^array-index frame index) val))

(define (univ-frame-slot-live? ctx frame index)
  (^bool #t));;TODO implement

(define (univ-get-return-ra-field attrib)
  (make-translated-operand-generator
   (lambda (ctx return ret)
     (univ-get-ra-field
      ctx
      return
      ret
      attrib))))

(define (univ-get-ra-field ctx return ra attrib)
  (let ((ra-var (^local-var (univ-gensym ctx 'ra))))
    (^ (^var-declaration
        'returnpt
        ra-var
        ra)
       (univ-with-ctrlpt-attribs
        ctx
        #f
        ra-var
        (lambda ()
          (return
           (^fixnum-box
            (univ-get-ctrlpt-attrib ctx ra-var attrib))))))))

(univ-define-prim "##return-fs" #f (univ-get-return-ra-field 'fs))

(univ-define-prim-bool "##will?" #t
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return (^will? arg1)))))

(univ-define-prim "##make-will" #t
  (make-translated-operand-generator
   (lambda (ctx return testator action)
     (return (^new-will testator action)))))

(univ-define-prim "##will-testator" #t
  (make-translated-operand-generator
   (lambda (ctx return will)
     (return (^member (^cast* 'will will) 'testator)))))

(univ-define-prim "##will-testator-set!" #t
  (make-translated-operand-generator
   (lambda (ctx return will testator)
     (^ (^assign (^member (^cast* 'will will) 'testator) testator)
        (return will)))))

(univ-define-prim "##will-action" #t
  (make-translated-operand-generator
   (lambda (ctx return will)
     (return (^member (^cast* 'will will) 'action)))))

(univ-define-prim "##will-action-set!" #t
  (make-translated-operand-generator
   (lambda (ctx return will action)
     (^ (^assign (^member (^cast* 'will will) 'action) action)
        (return will)))))

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
       (^rts-method-use 'make_glo_var)
       (^cast* 'symbol
               arg1))))))

(univ-define-prim "##global-var-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^glo-var-ref arg1)))))

(univ-define-prim "##global-var-primitive-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^glo-var-primitive-ref arg1)))))

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
     (return (^void-obj)))))

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
      (^> (^array-index (^bignum-digits arg1)
                        (^- (^array-length (^bignum-digits arg1))
                            (^int 1)))
          (^int 8191)))))) ;;TODO: adjust for digit size

(univ-define-prim "##bignum.adigit-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^fixnum-box
       (^array-length
        (^bignum-digits arg1)))))))

(univ-define-prim "##bignum.adigit-inc!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2)))
        (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitand (^parens (^+ (^rts-field-use 'inttemp1) (^int 1)))
                                  (^int 16383))))
        (return
         (^if-expr (^= (^rts-field-use 'inttemp1)
                       (^int 16383))
                   (^obj 1)
                   (^obj 0)))))))

(univ-define-prim "##bignum.adigit-dec!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2)))
        (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitand (^parens (^- (^rts-field-use 'inttemp1) (^int 1)))
                                  (^int 16383))))
        (return
         (^if-expr (^= (^rts-field-use 'inttemp1)
                       (^int 0))
                   (^obj 1)
                   (^obj 0)))))))

(univ-define-prim "##bignum.adigit-add!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5)
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2)))
        (^assign (^rts-field-use 'inttemp2)
                 (^bitand (^parens (^+ (^+ (^rts-field-use 'inttemp1)
                                           (^array-index (^bignum-digits arg3)
                                                         (^fixnum-unbox arg4)))
                                       (^fixnum-unbox arg5)))
                          (^int 16383)))
        (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^rts-field-use 'inttemp2)))
        (return
         (^if-expr (^< (^rts-field-use 'inttemp2)
                       (^+ (^rts-field-use 'inttemp1) (^fixnum-unbox arg5)))
                   (^obj 1)
                   (^obj 0)))))))

(univ-define-prim "##bignum.adigit-sub!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5)
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2)))
        (^assign (^rts-field-use 'inttemp2)
                 (^bitand (^parens (^- (^- (^rts-field-use 'inttemp1)
                                           (^array-index (^bignum-digits arg3)
                                                         (^fixnum-unbox arg4)))
                                       (^fixnum-unbox arg5)))
                          (^int 16383)))
        (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^rts-field-use 'inttemp2)))
        (return
         (^if-expr (^> (^rts-field-use 'inttemp2)
                       (^- (^rts-field-use 'inttemp1) (^fixnum-unbox arg5)))
                   (^obj 1)
                   (^obj 0)))))))

(univ-define-prim "##bignum.mdigit-length" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^fixnum-box (^array-length (^bignum-digits arg1)))))))

(univ-define-prim "##bignum.mdigit-ref" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^fixnum-box (^array-index (^bignum-digits arg1)
                                 (^fixnum-unbox arg2)))))))

(univ-define-prim "##bignum.mdigit-set!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^fixnum-unbox arg3)))
        (return arg1)))))

(univ-define-prim "##bignum.mdigit-mul!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5 arg6)
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^+ (^+ (^array-index (^bignum-digits arg1)
                                       (^fixnum-unbox arg2))
                         (^* (^array-index (^bignum-digits arg3)
                                           (^fixnum-unbox arg4))
                             (^fixnum-unbox arg5)))
                     (^fixnum-unbox arg6)))
        (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitand (^rts-field-use 'inttemp1)
                                  (^int 16383))))
        (return
         (^fixnum-box (^>> (^rts-field-use 'inttemp1) (^int 14))))))))

(univ-define-prim "##bignum.mdigit-div!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5 arg6)
     (^ (^assign (^rts-field-use 'inttemp1)
                 (^+ (^- (^array-index (^bignum-digits arg1)
                                       (^fixnum-unbox arg2))
                         (^* (^array-index (^bignum-digits arg3)
                                           (^fixnum-unbox arg4))
                             (^fixnum-unbox arg5)))
                     (^fixnum-unbox arg6)))
        (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitand (^rts-field-use 'inttemp1)
                                  (^int 16383))))
        (^assign (^rts-field-use 'inttemp1)
                 (^>> (^rts-field-use 'inttemp1) (^int 14)))
        (return
         (^fixnum-box
          (^if-expr (^> (^rts-field-use 'inttemp1) (^int 0))
                    (^- (^rts-field-use 'inttemp1) (^int 16384))
                    (^rts-field-use 'inttemp1))))))))

(univ-define-prim "##bignum.mdigit-quotient" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (return
      (^fixnum-box (univ-fxquotient
                    ctx
                    (^parens
                     (^+ (^parens
                          (^<< (^array-index (^bignum-digits arg1)
                                             (^fixnum-unbox arg2))
                               (^int 14)))
                         (^array-index (^bignum-digits arg1)
                                       (^- (^fixnum-unbox arg2)
                                           (^int 1)))))
                    (^fixnum-unbox arg3)))))))

(univ-define-prim "##bignum.mdigit-remainder" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (return
      (^fixnum-box (^- (^parens
                        (^+ (^parens
                             (^<< (^array-index (^bignum-digits arg1)
                                                (^fixnum-unbox arg2))
                                  (^int 14)))
                            (^array-index (^bignum-digits arg1)
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
      (^= (^array-index (^bignum-digits arg1)
                        (^fixnum-unbox arg2))
          (^int 16383))))))

(univ-define-prim-bool "##bignum.adigit-zero?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^= (^array-index (^bignum-digits arg1)
                        (^fixnum-unbox arg2))
          (^int 0))))))

(univ-define-prim-bool "##bignum.adigit-negative?" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (return
      (^> (^array-index (^bignum-digits arg1)
                        (^fixnum-unbox arg2))
          (^int 8191))))))

(univ-define-prim-bool "##bignum.adigit-=" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (return
      (^= (^array-index (^bignum-digits arg1)
                        (^fixnum-unbox arg3))
          (^array-index (^bignum-digits arg2)
                        (^fixnum-unbox arg3)))))))

(univ-define-prim-bool "##bignum.adigit-<" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (return
      (^< (^array-index (^bignum-digits arg1)
                        (^fixnum-unbox arg3))
          (^array-index (^bignum-digits arg2)
                        (^fixnum-unbox arg3)))))))

(univ-define-prim "##bignum.make" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3)
     (return
      (^call-prim
       (^rts-method-use 'bignum_make)
       (^fixnum-unbox arg1)
       arg2
       (^boolean-unbox arg3))))))

(univ-define-prim "##fixnum->bignum" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1)
     (return
      (^call-prim
       (^rts-method-use 'int2bignum)
       (^fixnum-unbox arg1))))))

(univ-define-prim "##bignum.adigit-shrink!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^array-shrink! (^bignum-digits arg1)
                        (^fixnum-unbox arg2))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-copy!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^array-index (^bignum-digits arg3)
                               (^fixnum-unbox arg4)))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-cat!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4 arg5 arg6 arg7)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^cast* 'bigdigit
                         (^bitand
                          (^parens
                           (^+ (^parens
                                (^<< (^array-index (^bignum-digits arg3)
                                                   (^fixnum-unbox arg4))
                                     (^fixnum-unbox arg7)))
                               (^parens
                                (^>> (^array-index (^bignum-digits arg5)
                                                   (^fixnum-unbox arg6))
                                     (^- (^int 14)
                                         (^fixnum-unbox arg7))))))
                          16383)))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-bitwise-and!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^bitand (^array-index (^bignum-digits arg1)
                                        (^fixnum-unbox arg2))
                          (^array-index (^bignum-digits arg3)
                                        (^fixnum-unbox arg4))))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-bitwise-ior!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^bitior (^array-index (^bignum-digits arg1)
                                        (^fixnum-unbox arg2))
                          (^array-index (^bignum-digits arg3)
                                        (^fixnum-unbox arg4))))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-bitwise-xor!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2 arg3 arg4)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^bitxor (^array-index (^bignum-digits arg1)
                                        (^fixnum-unbox arg2))
                          (^array-index (^bignum-digits arg3)
                                        (^fixnum-unbox arg4))))
        (return arg1)))))

(univ-define-prim "##bignum.adigit-bitwise-not!" #f
  (make-translated-operand-generator
   (lambda (ctx return arg1 arg2)
     (^ (^assign (^array-index (^bignum-digits arg1)
                               (^fixnum-unbox arg2))
                 (^bitnot (^array-index (^bignum-digits arg1)
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
             (^rts-jumpable-use rtlib-name)
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
