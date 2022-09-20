;;============================================================================

;;; File: "_t-univ-1.scm"

;;; Copyright (c) 2011-2022 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2012 by Eric Thivierge, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")
(include-adt "_univadt.scm")

;;----------------------------------------------------------------------------

(define deb #t)
(set! deb #f)
(define (tt tag . stuff) (if deb (list "/*{" tag "*/" stuff "/*}*/") stuff));;;;;;;;;;;;;;;;;;;;

(define univ-enable-jump-destination-inlining? #f)
(set! univ-enable-jump-destination-inlining? #t)

(define univ-dyn-load? #f)
(set! univ-dyn-load? #f)

(define (univ-get-semantics-changing-option ctx name)
  (let ((x (assq name (ctx-semantics-changing-options ctx))))
    (and x (pair? (cdr x)) (cadr x))))

(define (univ-module-representation ctx)
  (or (univ-get-semantics-changing-option ctx 'repr-module)
      (case (target-name (ctx-target ctx))
        ((java)
         'class)
        ((go)
         'package)
        (else
         'global))))

(define (univ-procedure-representation ctx)
  (or (univ-get-semantics-changing-option ctx 'repr-procedure)
      (case (target-name (ctx-target ctx))
        ((java)
         'class)
        ((php)
         (if (univ-php-pre53? ctx)
             'class
             'host))
        ((go)
         'struct)
        (else
         'host))))

(define (univ-frame-representation ctx)
  (or (univ-get-semantics-changing-option ctx 'repr-frame)
      (case (target-name (ctx-target ctx))
        ((java)
         'class)
        (else
         'host))))

(define (univ-null-representation ctx)
  (or (univ-get-semantics-changing-option ctx 'repr-null)
      (case (target-name (ctx-target ctx))
        ((js)
         'host)
        (else
         'class))))

(define (univ-void-representation ctx)
  (or (univ-get-semantics-changing-option ctx 'repr-void)
      (case (target-name (ctx-target ctx))
        ((go)
         'class)
        (else
         'host))))

(define (univ-eof-representation ctx)
  'class)

(define (univ-absent-representation ctx)
  'class)

(define (univ-deleted-representation ctx)
  'class)

(define (univ-unused-representation ctx)
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
  (or (univ-get-semantics-changing-option ctx 'repr-boolean)
      (case (target-name (ctx-target ctx))
        ((java)
         'class)
        (else
         'host))))

(define (univ-char-representation ctx)
  (case (target-name (ctx-target ctx))
;;    ((go)
;;     'host)
    (else
     'class)))

(define (univ-fixnum-representation ctx)
  (or (univ-get-semantics-changing-option ctx 'repr-fixnum)
      (case (target-name (ctx-target ctx))
        ((java)
         'class)
        (else
         'host))))

(define (univ-flonum-representation ctx)
  (or (univ-get-semantics-changing-option ctx 'repr-flonum)
      'class))

(define (univ-values-representation ctx)
  (or (univ-get-semantics-changing-option ctx 'repr-values)
      'class))

(define (univ-vector-representation ctx type)
  (let ((repr
         (univ-get-semantics-changing-option
          ctx
          (case type
            ((u8)  'repr-u8vector)
            ((u16) 'repr-u16vector)
            ((u32) 'repr-u32vector)
            ((u64) 'repr-u64vector)
            ((s8)  'repr-s8vector)
            ((s16) 'repr-s16vector)
            ((s32) 'repr-s32vector)
            ((s64) 'repr-s64vector)
            ((f32) 'repr-f32vector)
            ((f64) 'repr-f64vector)
            (else  'repr-vector)))))
    (or repr
        (if (eq? type 'scmobj)
            (case (target-name (ctx-target ctx))
              ((php java)
               'class)
              (else
               'host))
            'class))))

(define (univ-structure-representation ctx)
  'class)

(define (univ-string-representation ctx)
  (or (univ-get-semantics-changing-option ctx 'repr-string)
      (case (target-name (ctx-target ctx))
;;        ((go)
;;         'host)
        (else
         'class))))

(define (univ-symbol-representation ctx)
  (or (univ-get-semantics-changing-option ctx 'repr-symbol)
      'class))

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

    ((go)
     'String)

    (else
     (compiler-internal-error
      "univ-tostr-method-name, unknown target"))))

(define (univ-ns-prefix sem-changing-options)
  (let ((x (assq 'namespace sem-changing-options)))
    (or (and x (pair? (cdr x)) (cadr x))
        "_")))

(define (univ-ns-prefix-class sem-changing-options)
  (let ((ns (univ-ns-prefix sem-changing-options)))
    (if (= (string-length ns) 0)
        ns
        (let ((lst (string->list ns)))
          (list->string (cons (char-upcase (car lst)) (cdr lst)))))))

(define (univ-label-ns sem-preserving-options)
  (let ((x (assq 'label-namespace sem-preserving-options)))
    (and x
         (pair? (cdr x))
         (let* ((lns (string->c-id (cadr x)))
                (y (assq 'sequence-number sem-preserving-options))
                (sn
                 (or (and y (pair? (cdr y)) (nonneg-integer->c-id (cadr y)))
                     "")))
           (cond ((equal? "" lns)
                  sn)
                 ((equal? "" sn)
                  lns)
                 (else
                  (string-append lns "_" sn)))))))

(define univ-processor-current-thread-slot 14)
(define univ-thread-cont-slot 23)
(define univ-thread-denv-slot 24)
(define univ-thread-denv-cache1-slot 25)
(define univ-thread-denv-cache2-slot 26)
(define univ-thread-denv-cache3-slot 27)
(define univ-denv-local 0)
(define univ-denv-dynwind 1)
(define univ-denv-interrupt-mask 2)
(define univ-denv-debugging-settings 3)
(define univ-denv-exception-handler 4)
(define univ-denv-input-port 5)
(define univ-denv-output-port 6)
(define univ-env-name-val 0)

(define (univ-php-pre53? ctx)
  (assq 'pre53 (ctx-semantics-changing-options ctx)))

(define (univ-python-pre3? ctx)
  (assq 'pre3 (ctx-semantics-changing-options ctx)))

(define (univ-java-pre7? ctx)
  (assq 'pre7 (ctx-semantics-changing-options ctx)))

(define (univ-always-return-jump? ctx)
  (assq 'always-return-jump (ctx-semantics-preserving-options ctx)))

(define (univ-never-return-jump? ctx)
  (assq 'never-return-jump (ctx-semantics-preserving-options ctx)))

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

(define (univ-setup
         target-language
         file-extensions
         semantics-changing-options
         semantics-preserving-options)

  (define common-semantics-changing-options
    '((repr-module    symbol)
      (repr-procedure symbol)
      (repr-frame     symbol)
      (repr-null      symbol)
      (repr-void      symbol)
      (repr-boolean   symbol)
      (repr-fixnum    symbol)
      (repr-flonum    symbol)
      (repr-vector    symbol)
      (repr-u8vector  symbol)
      (repr-u16vector symbol)
      (repr-u32vector symbol)
      (repr-u64vector symbol)
      (repr-s8vector  symbol)
      (repr-s16vector symbol)
      (repr-s32vector symbol)
      (repr-s64vector symbol)
      (repr-f32vector symbol)
      (repr-f64vector symbol)
      (repr-values    symbol)
      (repr-string    symbol)
      (repr-symbol    symbol)
      (namespace      string)))

  (define common-semantics-preserving-options
    '((always-return-jump)
      (never-return-jump)
      (label-namespace string)
      (sequence-number fixnum)))

  (let ((targ
         (make-target 15
                      target-language
                      file-extensions
                      (append semantics-changing-options
                              common-semantics-changing-options)
                      (append semantics-preserving-options
                              common-semantics-preserving-options)
                      0)))

    (define (begin! sem-changing-opts
                    sem-preserving-opts
                    info-port)

      (target-dump-set!
       targ
       (lambda (procs output c-intf module-descr linker-name)
         (univ-dump targ
                    procs
                    output
                    c-intf
                    module-descr
                    linker-name
                    sem-changing-opts
                    sem-preserving-opts)))

      (target-link-info-set!
       targ
       (lambda (file)
         (univ-link-info targ file)))

      (target-link-set!
       targ
       (lambda (extension? inputs output linker-name warnings?)
         (univ-link targ extension? inputs output linker-name warnings?)))

      (target-prim-info-set!
       targ
       (lambda (name)
         (univ-prim-info targ name)))

      (target-frame-constraints-set!
       targ
       (make-frame-constraints univ-frame-reserve univ-frame-alignment))

      (target-proc-result-set!
       targ
       (make-reg 1))

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

      (univ-set-nb-regs targ sem-changing-opts)

      #f)

    (define (end!)
      #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)
    (target-add targ)))

(univ-setup 'js     '((".js"   . JavaScript))  '()        '())
(univ-setup 'python '((".py"   . Python))      '((pre3))  '())
(univ-setup 'ruby   '((".rb"   . Ruby))        '()        '())
(univ-setup 'php    '((".php"  . PHP))         '((pre53)) '())

(univ-setup 'java   '((".java" . Java))        '((pre7))  '())
(univ-setup 'go     '((".go"   . Go))          '()        '())
;;(univ-setup 'c      '((".c"    . C))           '()       '())
;;(univ-setup 'c++    '((".cc"   . C++))         '()       '())
;;(univ-setup 'objc   '((".m"    . Objective-C)) '()       '())

;;;----------------------------------------------------------------------------

;; ***** REGISTERS AVAILABLE

;; The registers available in the virtual machine default to
;; univ-default-nb-gvm-regs and univ-default-nb-arg-regs but can be
;; changed with the gsc options -nb-gvm-regs and -nb-arg-regs.
;;
;; nb-gvm-regs = total number of registers available
;; nb-arg-regs = maximum number of arguments passed in registers
;; compactness = compactness of the generated code (0..9)

(define univ-default-nb-gvm-regs 5)
(define univ-default-nb-arg-regs 3)
(define univ-default-compactness 5)

(define (univ-nb-gvm-regs ctx) (target-nb-regs (ctx-target ctx)))
(define (univ-nb-arg-regs ctx) (target-nb-arg-regs (ctx-target ctx)))
(define (univ-compactness ctx) (target-compactness (ctx-target ctx)))

(define (univ-set-nb-regs targ sem-changing-opts)
  (let ((nb-gvm-regs
         (get-option sem-changing-opts
                     'nb-gvm-regs
                     univ-default-nb-gvm-regs))
        (nb-arg-regs
         (get-option sem-changing-opts
                     'nb-arg-regs
                     univ-default-nb-arg-regs))
        (compactness
         (get-option sem-changing-opts
                     'compactness
                     univ-default-compactness)))

    (if (not (and (<= 3 nb-gvm-regs)
                  (<= nb-gvm-regs 25)))
        (compiler-error "-nb-gvm-regs option must be between 3 and 25"))

    (if (not (and (<= 1 nb-arg-regs)
                  (<= nb-arg-regs (- nb-gvm-regs 2))))
        (compiler-error
         (string-append "-nb-arg-regs option must be between 1 and "
                        (number->string (- nb-gvm-regs 2)))))

    (target-nb-regs-set! targ nb-gvm-regs)
    (target-nb-arg-regs-set! targ nb-arg-regs)
    (target-compactness-set! targ compactness)))

;;;----------------------------------------------------------------------------

;; Generation of textual target code.

(define (univ-emit-comment ctx comment)
  (if (univ-compactness>=? ctx 5)
      (^)
      (^ (univ-single-line-comment-prefix (target-name (ctx-target ctx)))
         " "
         comment)))

(define (univ-single-line-comment-prefix targ-name)
  (case targ-name

    ((js php java go)
     "//")

    ((python ruby)
     "#")

    (else
     (compiler-internal-error
      "univ-single-line-comment-prefix, unknown target"))))

(define (univ-emit-indent ctx . rest)
  (if (case (target-name (ctx-target ctx))
        ((js)
         (univ-compactness>=? ctx 5))
        (else
         #f))
      rest
      (cons '$$indent$$ rest)))

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

(define (univ-display-to-file x path)
  (let ((port (open-output-file-preserving-case path)))
    (univ-display x port)
    (close-output-port port)))

(define (univ-display-to-string x)
  (let ((port (open-output-string)))
    (univ-display x port)
    (close-output-port port)
    (get-output-string port)))

;;;----------------------------------------------------------------------------

;; The frame constraints are defined by the parameters
;; univ-frame-reserve and univ-frame-alignment.

(define univ-frame-reserve 0) ;; no extra slots reserved
(define univ-frame-alignment 1) ;; no alignment constraint

;;;----------------------------------------------------------------------------

;; ***** PRIMITIVE PROCEDURE DATABASE

(define univ-prim-proc-table
  (let ((t (make-prim-proc-table)))
    (for-each
     (lambda (x) (prim-proc-add! t x))
     '(("##inline-host-statement" 1 #t 0 0 (#f) extended)
       ("##inline-host-expression" 1 #t 0 0 (#f) extended)
       ("##inline-host-declaration" (1) #t 0 0 (#f) extended)
       ("##univ-table-make-hashtable" (2) #t 0 0 (#f) extended)
       ("##univ-table-key-exists?" (2) #f 0 0 boolean extended)
       ("##univ-table-keys" (1) #f 0 0 (#f) extended)
       ("##univ-table-ref" (2) #f 0 0 (#f) extended)
       ("##univ-table-set!" (3) #t 0 0 (#f) extended)
       ("##univ-table-delete" (2) #f 0 0 (#f) extended)
       ("##univ-table-length" (1) #f 0 0 number extended)))
    t))

(define (univ-prim-info targ name)
  (univ-prim-info* name))

(define (univ-prim-info* name)
  (prim-proc-info univ-prim-proc-table name))

;;;----------------------------------------------------------------------------

;; ***** OBJECT PROPERTIES

(define (univ-switch-testable? targ obj)
  ;;(pretty-print (list 'univ-switch-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (univ-eq-testable? targ obj)
  ;;(pretty-print (list 'univ-eq-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (univ-object-type targ obj)
  (cond ((number? obj)
         (if (and (integer? obj)
                  (exact? obj))
             (let ()
               (declare (generic))
               (if (and (>= obj -536870912)
                        (<= obj 536870911))
                   'fixnum
                   'bignum))
             'other))
        (else
         'other)))

;;;----------------------------------------------------------------------------

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
     (^ "list(map( "fn ", " array " ))"))

    ((ruby)
     (^ array ".map { |x| " fn "(x) } " ))

    ((go)
     (^ "~~~TODO1:univ-emit-map~~~"))

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

    ((go)
     (^ "~~~TODO1:univ-emit-call-with-arg-array~~~"))

    (else
     (compiler-internal-error
      "univ-emit-call-with-arg-array, unknown target"))))

(define univ-js-define-globals-using-assignment #t) ;; for nodejs scoping rules

(define (univ-emit-var-declaration ctx type name #!optional (init #f) (global? #f))
  (case (target-name (ctx-target ctx))

    ((js)
     (^ (if (and global? univ-js-define-globals-using-assignment) "" "var ")
        name (if init (^ " = " init) (^)) ";\n"))

    ((python ruby)
     (^ name " = " (or init (^obj #f)) "\n"))

    ((php)
     (^ name " = " (or init (^obj #f)) ";\n"))

    ((java)
     (^ (^decl type name) (if init (^ " = " init) (^)) ";\n"))

    ((go)
     (^ "var " name (if type (^ " " (^type type)) "") (if init (^ " = " init) (^)) "\n"))

    (else
     (compiler-internal-error
      "univ-emit-var-declaration, unknown target"))))

(define (univ-emit-expr-statement ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php java)
     (^ expr ";\n"))

    ((python ruby go)
     (^ expr "\n"))

    (else
     (compiler-internal-error
      "univ-emit-expr-statement, unknown target"))))

(define (univ-emit-if ctx test true #!optional (false #f))
  (case (target-name (ctx-target ctx))

    ((js php java)
     (^ "if (" test ") {\n"
        (^indent true)
        (if false
            (^ "} else {\n"
               (^indent false))
            (^))
        "}\n"))

    ((python)
     (^ "if " test ":\n"
        (^indent true)
        (if false
            (^ "else:\n"
                  (^indent false))
            (^))))

    ((ruby)
     (^ "if " test "\n"
        (^indent true)
        (if false
            (^ "else\n"
               (^indent false))
            (^))
        "end\n"))

    ((go)
     (^ "if " test " {\n"
        (^indent true)
        (if false
            (^ "} else {\n"
               (^indent false))
            (^))
        "}\n"))

    (else
     (compiler-internal-error
      "univ-emit-if, unknown target"))))

(define (univ-emit-if-expr ctx type expr1 expr2 expr3)
  (case (target-name (ctx-target ctx))

    ((js ruby java)
     (^ expr1 " ? " expr2 " : " expr3))

    ((php)
     (^parens (^ expr1 " ? " expr2 " : " expr3)))

    ((python)
     (^ expr2 " if " expr1 " else " expr3))

    ((go)
     (^apply (univ-emit-fn-decl
              ctx
              #f
              type
              '()
              (^if expr1
                   (^return expr2)
                   (^return expr3)))
             '()))

    (else
     (compiler-internal-error
      "univ-emit-if-expr, unknown target"))))

(define (univ-emit-if-instanceof ctx class expr true false)
  (case (target-name (ctx-target ctx))

    ((go)
     (^ "switch " expr ".(type) {\n"
        "case " class ":\n"
        (^indent true)
        (if false
            (^ "default:\n"
               (^indent false)
               "}\n")
            "}\n")))

    (else
     (^if (^instanceof class expr) true false))))

(define (univ-emit-while ctx test body)
  (case (target-name (ctx-target ctx))

    ((js php java)
     (^ "while (" test ") {\n"
        (^indent body)
        "}\n"))

    ((python)
     (^ "while " test ":\n"
        (^indent body)))

    ((ruby)
     (^ "while " test "\n"
        (^indent body)
        "end\n"))

    ((go)
     (^ "for " test " {\n"
        (^indent body)
        "}\n"))

    (else
     (compiler-internal-error
      "univ-emit-while, unknown target"))))

(define (univ-emit-try-catch ctx body var catch-body)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "try {\n"
        (^indent body)
        "} catch (" var ") {\n"
        (^indent catch-body)
        "}\n"))

    ((python)
     (^ "try:\n"
        (^indent body)
        "except Exception as " var ":\n"
        (^indent catch-body)))

    ;; TODO: implement for other languages... for now just assume no
    ;; exception is raised so just execute the body
    (else
     body)))

(define (univ-emit-eq? ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ expr1 " === " expr2))

    ((python)
     (^ expr1 " is " expr2))

    ((ruby)
     (^ expr1 ".equal?(" expr2 ")"))

    ((java go)
     (^ expr1 " == " expr2))

    (else
     (compiler-internal-error
      "univ-emit-eq?, unknown target"))))

(define (univ-emit-+ ctx expr1 #!optional (expr2 #f))
  (case (target-name (ctx-target ctx))

    ((js php python ruby java go)
     (if expr2
         (^ expr1 " + " expr2)
         (^ "+ " expr1)))

    (else
     (compiler-internal-error
      "univ-emit-+, unknown target"))))

(define (univ-emit-- ctx expr1 #!optional (expr2 #f))
  (case (target-name (ctx-target ctx))

    ((js php python ruby java go)
     (if expr2
         (^ expr1 " - " expr2)
         (^ "- " expr1)))

    (else
     (compiler-internal-error
      "univ-emit--, unknown target"))))

(define (univ-emit-* ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java go)
     (^ expr1 " * " expr2))

    (else
     (compiler-internal-error
      "univ-emit-*, unknown target"))))

(define (univ-emit-/ ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java go)
     (^ expr1 " / " expr2))

    (else
     (compiler-internal-error
      "univ-emit-/, unknown target"))))

(define (univ-wrap ctx expr)
  (case (target-name (ctx-target ctx))

    ((js java)
     (^>> (^<< (^parens expr)
               (^int univ-tag-bits))
          (^int univ-tag-bits)))

    ((python)
     (^>> (^member (^call-prim
                    "ctypes.c_int32"
                    (^<< (^parens expr)
                         (^int univ-tag-bits)))
                   'value)
          (^int univ-tag-bits)))

    ((ruby php)
     (^- (^parens (^bitand (^parens (^+ (^parens expr)
                                        (^int univ-fixnum-max+1)))
                           (^int univ-fixnum-max*2+1)))
         (^int univ-fixnum-max+1)))

    ((go)
     (^ "~~~TODO1:univ-wrap~~~"))

    (else
     (compiler-internal-error
      "univ-wrap, unknown target"))))

(define (univ-wrap+ ctx expr1 expr2)
  (univ-wrap ctx (^+ expr1 expr2)))

(define (univ-wrap- ctx expr1 #!optional (expr2 #f))
  (univ-wrap ctx (if expr2
                     (^- expr1 expr2)
                     (^- expr1))))

(define (univ-wrap* ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (univ-wrap ctx
                (^+ (^* (^parens (^bitand expr1 #xffff))
                        expr2)
                    (^* (^parens (^bitand expr1 #xffff0000))
                        (^parens (^bitand expr2 #xffff))))))

    ((php python ruby java)
     (univ-wrap ctx (^* expr1 expr2)))

    ((go)
     (^ "~~~TODO1:univ-wrap*~~~"))

    (else
     (compiler-internal-error
      "univ-wrap*, unknown target"))))

(define (univ-wrap/ ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

   ((python php ruby)
    ;; The default behavior is to round down, but it should round toward 0
    (univ-wrap ctx (^float-toint (^parens (^/ expr1 (^float-fromint expr2))))))

   ((go)
    (^ "~~~TODO1:univ-wrap/~~~"))

   (else (univ-wrap ctx (^/ expr1 expr2)))))

(define (univ-emit-<< ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java go)
     (^ expr1 " << " expr2))

    (else
     (compiler-internal-error
      "univ-emit-<<, unknown target"))))

(define (univ-emit->> ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java go)
     (^ expr1 " >> " expr2))

    (else
     (compiler-internal-error
      "univ-emit->>, unknown target"))))

(define (univ-emit->>> ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js java)
     (^ expr1 " >>> " expr2))

    ((python ruby php)
     ;; These targets don't need >>>, but just in case...
     (^bitand
      (^>> expr1
           expr2)
      (^- (^parens
           (^<< (^int 1)
                (^- (^int univ-word-bits) expr2)))
          (^int 1))))

    ((go)
     (^ "~~~TODO1:univ-emit->>>~~~"))

    (else
     (compiler-internal-error
      "univ-emit->>>, unknown target"))))

(define (univ-emit-bitnot ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java)
     (^ "~ " expr))

    ((go)
     (^ "^ " expr))

    (else
     (compiler-internal-error
      "univ-emit-bitnot, unknown target"))))

(define (univ-emit-bitand ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java go)
     (^ expr1 " & " expr2))

    (else
     (compiler-internal-error
      "univ-emit-bitand, unknown target"))))

(define (univ-emit-bitior ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java go)
     (^ expr1 " | " expr2))

    (else
     (compiler-internal-error
      "univ-emit-bitior, unknown target"))))

(define (univ-emit-bitxor ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java go)
     (^ expr1 " ^ " expr2))

    (else
     (compiler-internal-error
      "univ-emit-bitxor, unknown target"))))

(define (univ-emit-= ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 " === " expr2))

    ((python ruby php java go)
     (^ expr1 " == " expr2))

    (else
     (compiler-internal-error
      "univ-emit-=, unknown target"))))

(define (univ-emit-!= ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 " !== " expr2))

    ((python ruby php java go)
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

    ((js python ruby php java go)
     (^ expr1 comp expr2))

    (else
     (compiler-internal-error
      "univ-emit-comparison, unknown target"))))

(define (univ-emit-not ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php ruby java go)
     (^ "!" expr))

    ((python)
     (^ "not " expr))

    (else
     (compiler-internal-error
      "univ-emit-not, unknown target"))))

(define (univ-emit-&& ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js ruby php java go)
     (^ expr1 " && " expr2))

    ((python)
     (^ expr1 " and " expr2))

    (else
     (compiler-internal-error
      "univ-emit-&&, unknown target"))))

(define (univ-emit-and ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js ruby java go)
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

    ((js ruby php java go)
     (^ expr1 " || " expr2)) ;; TODO: PHP || operator always yields a boolean

    ((python)
     (^ expr1 " or " expr2))

    (else
     (compiler-internal-error
      "univ-emit-or, unknown target"))))

(define (univ-emit-concat ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js python ruby java go)
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

    ((go)
     (univ-add-module-import ctx "fmt")
     (^call-prim (^member 'fmt 'Sprintf) (^str "%v") expr))

    (else
     (compiler-internal-error
      "univ-emit-tostr, unknown target"))))

(define (univ-emit-conv* ctx type-name expr)
  (case (target-name (ctx-target ctx))
    ((go)
     (^ (^type type-name) (^parens expr)))
    (else
     (^cast* type-name expr))))

(define (univ-emit-cast ctx type expr)
  (case (target-name (ctx-target ctx))
    ((java)
     (^parens (^ (^parens type) (^parens expr))))
    ((go)
     (^member expr (^parens type)))
    (else
     expr)))

(define (univ-emit-cast* ctx type-name expr)
  (case (target-name (ctx-target ctx))
    ((java go)
     (^cast (^type type-name) expr))
    (else
     expr)))

(define (univ-emit-cast*-scmobj ctx expr)
  (^cast* 'scmobj expr))

(define (univ-emit-cast*-jumpable ctx expr)
  (^cast* 'jumpable expr))

(define (univ-emit-upcast* ctx from-type-name to-type-name expr)
  (case (target-name (ctx-target ctx))
    ((go)
     ;; expr must be a pointer to a struct inheriting the type
     (if (eq? from-type-name to-type-name)
         expr
         (^ "&" (^member (if (and (pair? expr) (equal? (car expr) "&"))
                             (cdr expr)
                             (^parens expr))
                         (univ-rts-type-alias ctx to-type-name)))))
    (else
     (^cast* to-type-name expr))))

(define (univ-emit-downcast* ctx type-name expr)
  (case (target-name (ctx-target ctx))
    ((go)
     ;; expr must be an interface type
     (^member expr (^parens (^type type-name))))
    (else
     (^cast* type-name expr))))

(define (univ-emit-downupcast* ctx down-type-name up-type-name expr)
  (^upcast* down-type-name up-type-name (^downcast* down-type-name  expr)))

(define (univ-emit-seq ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js java)
     (^parens (^ expr1 " , " expr2)))

    ((ruby)
     (^parens (^ expr1 " ; " expr2)))

    ((go)
     (^ "~~~TODO1:univ-emit-seq~~~"))

    (else
     (compiler-internal-error
      "univ-emit-seq, unknown target"))))

(define (univ-emit-parens ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby php python java go)
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

    ((js python ruby java go)
     name)

    ((php)
     (^ "$" name))

    (else
     (compiler-internal-error
      "univ-emit-local-var, unknown target"))))

(define (univ-emit-global-var ctx name)
  (case (target-name (ctx-target ctx))

    ((js python java go)
     name)

    ((php ruby)
     (^ "$" name))

    (else
     (compiler-internal-error
      "univ-emit-global-var, unknown target"))))

(define (univ-emit-global-function ctx name)
  (case (target-name (ctx-target ctx))

    ((js python java go)
     name)

    ((php ruby) name);;TODO: added
#;
    ((php ruby)
     (^ "$" name))

    (else
     (compiler-internal-error
      "univ-emit-global-function, unknown target"))))

(define (univ-emit-this-mod-field ctx name public?)
  (univ-emit-mod-field ctx (ctx-module-name ctx) name public?))

(define (univ-emit-this-mod-method ctx name public?)
  (univ-emit-mod-method ctx (ctx-module-name ctx) name public?))

(define (univ-emit-this-mod-jumpable ctx name public?)
  (univ-emit-mod-jumpable ctx (ctx-module-name ctx) name public?))

(define (univ-emit-mod-member ctx mod-name name)
  (if (and (case (target-name (ctx-target ctx))
             ((js)
              #f)
             ((python)
              (not (eq? (univ-module-representation ctx) 'class)))
             (else
              #t))
           (eq? (ctx-module-name ctx) mod-name)) ;; optimize access to self
      (tt"AAA"name)
      (case (target-name (ctx-target ctx))

        ((js python ruby java go)
         (tt"BBB"(^member mod-name name)))

        ((php)
         (tt"BBB"(^ mod-name "::" name)))

        (else
         (compiler-internal-error
          "univ-emit-mod-member, unknown target")))))

(define (univ-emit-mod-field ctx mod-name name public?)
  (case (univ-module-representation ctx)

    ((class package)
     (tt"CCC"(univ-emit-mod-member ctx mod-name (^prefix name public?))))

    (else
     (tt"CCC"(^global-var (^prefix name public?))))))

(define (univ-emit-mod-method ctx mod-name name public?)
  (case (univ-module-representation ctx)

    ((class package)
     (tt"DDD"(univ-emit-mod-member ctx mod-name (^prefix name public?))))

    (else
     (tt"DDD"(^global-function (^prefix name public?))))))

(define (univ-mod-jumpable-is-field? ctx)
  (eq? (target-name (ctx-target ctx)) 'ruby))

(define (univ-emit-mod-jumpable ctx mod-name name public?)
  (^id-to-jumpable
   (case (univ-procedure-representation ctx)
     ((class)
      (let ((x (univ-emit-mod-field ctx mod-name name public?)))
        (use-global ctx x)
        x))
     ((struct)
      (univ-emit-mod-field ctx mod-name name public?))
     (else
      (if (univ-mod-jumpable-is-field? ctx)
          (univ-emit-mod-field ctx mod-name name public?)
          (univ-method-reference
           ctx
           (univ-emit-mod-method ctx mod-name name public?)))))))

;;obsolete
#;
(define (univ-emit-mod-class ctx mod-name name)
  (case (univ-module-representation ctx)

    ((class package)
     (tt"EEE"(univ-emit-mod-member ctx mod-name name)))

    (else
     (tt"EEE"(^prefix-class name)))))

(define (univ-emit-id-to-jumpable ctx name)
  (case (target-name (ctx-target ctx))
    ((go) (^ "&" name))
    (else name)))

(define (univ-emit-rts-method ctx name public?)
  (case (univ-module-representation ctx)

    ((class)
     (tt"FFF"name))

    ((package)
     (tt"FFF"(^prefix name public?)))

    (else
     (tt"FFF"(^global-function (^prefix name))))))

(define (univ-emit-rts-method-ref ctx name public?)
  (case (univ-module-representation ctx)

    ((class)
     (tt"GGG"(univ-emit-mod-member ctx (ctx-rts-module-name ctx) name)))

    ((package)
     (tt"GGG"(univ-emit-mod-member ctx (ctx-rts-module-name ctx) (^prefix name public?))))

    (else
     (tt"GGG"(^global-function (^prefix name))))))

(define (univ-emit-rts-method-use ctx name public?)
  (univ-use-rtlib ctx name)
  (univ-emit-rts-method-ref
   ctx
   (univ-rts-method-low-level-name ctx name)
   public?))

(define (univ-emit-rts-field ctx name public?)
  (case (univ-module-representation ctx)

    ((class)
     (tt"HHH"name))

    ((package)
     (tt"HHH"(^prefix name #t)))

    (else
     (tt"HHH"(^global-var (^prefix name))))))

(define (univ-emit-rts-field-ref ctx name public?)
  (case (univ-module-representation ctx)

    ((class)
     (tt"III"(univ-emit-mod-member ctx (ctx-rts-module-name ctx) name)))

    ((package)
     (tt"III"(univ-emit-mod-member ctx (ctx-rts-module-name ctx) (^prefix name public?))))

    (else
     (tt"III"(^global-var (^prefix name))))))

(define (univ-emit-rts-field-use ctx name public?)
  (univ-use-rtlib ctx name)
  (let ((x (univ-emit-rts-field-ref
            ctx
            (univ-rts-field-low-level-name ctx name)
            public?)))
    (use-global ctx x)
    x))

(define (univ-emit-rts-jumpable-use ctx name)
  (univ-use-rtlib ctx name)
  (univ-emit-mod-jumpable ctx (ctx-rts-module-name ctx) name #f))

(define (univ-emit-rts-class ctx name public?)
  (let ((real-name (univ-rts-type-alias ctx name)))
    (case (univ-module-representation ctx)

      ((class package)
       (tt"JJJ"(univ-emit-mod-member ctx (ctx-rts-module-name ctx) real-name)))

      (else
       (tt"JJJ"(^prefix-class real-name))))))

(define (univ-emit-rts-class-ref ctx name public?)
  (let ((real-name (univ-rts-type-alias ctx name)))
    (case (univ-module-representation ctx)

      ((class package)
       (tt"KKK"(univ-emit-mod-member ctx (ctx-rts-module-name ctx) real-name)))

      (else
       (tt"KKK"(^prefix-class real-name))))))

(define (univ-emit-rts-class-use ctx name public?)
  (univ-use-rtlib ctx name)
  (univ-emit-rts-class-ref ctx name public?))

(define (univ-rts-module-name ctx)
  (case (target-name (ctx-target ctx))

    ((js php python ruby java go)
     "RTS")

    (else
     (compiler-internal-error
      "univ-rts-module-name, unknown target"))))

(define (univ-emit-prefix ctx name public?)
  (case (univ-module-representation ctx)

    ((class)
     (tt"LLL"name))

    ((package)
     (tt"LLL"(^ (if public? "G_" "") name)))

    (else
     (tt"LLL"(^ (ctx-ns-prefix ctx) name)))))

(define (univ-emit-prefix-class ctx name public?)
  (case (univ-module-representation ctx)

;    ((class package)
;     (tt"MMM"name))

    (else
     (tt"MMM"(^ (ctx-ns-prefix-class ctx) name)))))

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

        ((python go)
         (^ (^expr-statement (inc-general loc expr))
            (embed-read loc)))

        ((ruby)
         (embed-expr (inc-general loc expr) #t))

        (else
         (compiler-internal-error
          "univ-emit-inc-by, unknown target")))))

(define (univ-emit-alias ctx expr)
  (case (target-name (ctx-target ctx))

    ((js python ruby java go)
     expr)

    ((php)
     (^ "&" expr))

    (else
     (compiler-internal-error
      "univ-emit-alias, unknown target"))))

(define (univ-emit-unalias ctx expr)
  (case (target-name (ctx-target ctx))

    ((js python ruby java go)
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

    ((go)
     (^ "~~~TODO1:univ-emit-array?~~~"))

    (else
     (compiler-internal-error
      "univ-emit-array?, unknown target"))))

(define (univ-emit-array-length ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby java)
     (^ expr ".length"))

    ((php)
     (^ "count" (^parens expr)))

    ((python go)
     (^ "len" (^parens expr)))

    (else
     (compiler-internal-error
      "univ-emit-array-length, unknown target"))))

(define (univ-emit-array-push! ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^expr-statement
      (^call-prim (^member expr1 'push) expr2)))

    ((python)
     (^expr-statement
      (^call-prim (^member expr1 'append) expr2)))

    (else
     (compiler-internal-error
      "univ-emit-array-push!, unknown target"))))

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

    ((java go)
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

    ((go)
     (^ "~~~TODO1:univ-emit-array-shrink-possibly-copy!~~~"))

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

    ((go)
     (^ "~~~TODO1:univ-emit-move-array-to-array~~~"))

    (else
     (compiler-internal-error
      "univ-emit-move-array-to-array, unknown target"))))

(define (univ-emit-copy-array-to-extensible-array ctx expr len)
  (case (target-name (ctx-target ctx))

    ((js php ruby java go)
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

    ((go)
     (^ "~~~TODO1:univ-emit-extensible-array-to-array!~~~"))

    (else
     (compiler-internal-error
      "univ-emit-extensible-array-to-array!, unknown target"))))

(define (univ-emit-extensible-subarray ctx expr start len)
   (case (target-name (ctx-target ctx))

    ((js ruby php java) (^subarray expr start len))

    ((python)
     (^ "[" expr "[i] for i in range("
                  (if (eq? start 0)
                      len
                      (^ start ", " (^+ start len)))
                ")]"))

    ((go)
     (^ "~~~TODO1:univ-emit-extensible-subarray~~~"))

    (else
     (compiler-internal-error
      "univ-emit-extensible-subarray, unknown target"))))

(define (univ-emit-subarray ctx expr1 expr2 expr3)
  (case (target-name (ctx-target ctx))

    ((js)
     (^call-prim (^member expr1 'slice)
                 expr2
                 (if (equal? expr2 0) expr3 (^+ expr2 expr3))))

    ((php)
     (^call-prim 'array_slice expr1 expr2 expr3))

    ((python go)
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

(define (univ-emit-prop-index ctx type expr1 expr2 expr3)
  (if expr3
      (^if-expr type
                (^prop-index-exists? expr1 expr2)
                (^prop-index type expr1 expr2)
                expr3)
      (^ expr1 "[" expr2 "]")))

(define (univ-emit-prop-index-or-null ctx type expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((go)
     (^prop-index type expr1 expr2))

    (else
     (^prop-index type expr1 expr2 (^null)))))

(define (univ-emit-prop-index-exists? ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "Object.prototype.hasOwnProperty.call(" expr1 "," expr2 ")"))

    ((php)
     (^ "array_key_exists(" expr2 "," expr1 ")"))

    ((python)
     (^ expr2 " in " expr1))

    ((ruby)
     (^ expr1 ".has_key?(" expr2 ")"))

    ((go)
     (^ "~~~TODO1:univ-emit-prop-index-exists?~~~"))

    (else
     (compiler-internal-error
      "univ-emit-prop-index-exists?, unknown target"))))

(define (univ-emit-get ctx obj name)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^prop-index 'scmobj obj (^str name)))

    ((php)
     (^call-prim
      (^rts-method-use 'get)
      obj
      (^str name)))

    ((go)
     (^ "~~~TODO1:univ-emit-get~~~"))

    (else
     (compiler-internal-error
      "univ-emit-get, unknown target"))))

(define (univ-emit-set ctx obj name val)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^assign-expr (^prop-index 'scmobj obj (^str name)) val))

    ((php)
     (^call-prim
      (^rts-method-use 'set)
      obj
      (^str name)
      val))

    ((go)
     (^ "~~~TODO1:univ-emit-set~~~"))

    (else
     (compiler-internal-error
      "univ-emit-set, unknown target"))))

(define (univ-emit-attribute-exists? ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "Object.prototype.hasOwnProperty.call(" expr1 "," expr2 ")"))

    ((php)
     (^call-prim 'property_exists expr1 expr2))

    ((python)
     (^call-prim 'hasattr expr1 expr2))

    ((ruby)
     (^call-prim
      (^member expr1 'instance_variable_defined?) (^ ":@" expr2)))

    ((go)
     (^ "~~~TODO1:univ-emit-attribute-exists?~~~"))

    (else
     (compiler-internal-error
      "univ-emit-attribute-exists?, unknown target"))))

;; ***** DUMPING OF A COMPILATION MODULE

(define (univ-dump targ procs output c-intf module-descr linker-name sem-changing-options sem-preserving-options)
  (let ((code
         (univ-dump-code targ procs output c-intf module-descr linker-name sem-changing-options sem-preserving-options)))
    (univ-display-to-file code output)
    (lambda () output)))

(define (univ-dump-code targ procs output c-intf module-descr linker-name sem-changing-options sem-preserving-options)
  (let* ((module-name-str
          (symbol->string
           (let ((v (vector-ref module-descr 0)))
             (vector-ref v (- (vector-length v) 1)))))

         (module-proc
          (list-ref procs 0))

         (ctx
          (make-ctx
           targ
           sem-changing-options
           sem-preserving-options
           "" ;; module-name filled in later
           "" ;; rt-module-name filled in later
           (univ-ns-prefix sem-changing-options)
           (univ-ns-prefix-class sem-changing-options)
           "zzz" ;;;;;;;;;;;;;;;;;
           (make-objs-used)
           (make-resource-set)
           (make-table)
           (queue-empty)
           (queue-empty)
           (queue-empty)
           (make-table)
           (univ-label-ns sem-preserving-options)))

         (module-name
          (univ-display-to-string
           (^prefix-class (scheme-id->c-id module-name-str) #t)))

         (_
          (begin
            (ctx-rts-module-name-set! ctx (univ-rts-module-name ctx))
            (ctx-module-name-set! ctx module-name)
            (univ-add-module-import ctx (ctx-rts-module-name ctx))))

         (defs-procs
           (univ-dump-procs ctx procs))

         (code-module
          (univ-defs->code
           ctx
           module-name
           (univ-defs-combine
            (univ-objs-defs ctx)
            (univ-defs-combine
             defs-procs
             (univ-module-register ctx module-descr)))))

         (code-decls
          (queue->list (ctx-decls ctx)))

         (rtlib-features
          (resource-set-stack (ctx-rtlib-features-used ctx))))

    (^ (univ-link-info-header
        ctx
        module-name-str
        (list (list module-name-str))
        rtlib-features
        (ctx-glo-used ctx)
        #f)
       (univ-module-header ctx module-name)
       code-decls
       code-module
       (univ-module-footer ctx)
       (univ-link-info-footer ctx))))

(define (univ-module-register ctx module-descr)
  (univ-add-init
   (univ-make-empty-defs)
   (lambda (ctx)
     (^expr-statement
      (^call-prim (^rts-method-use 'module_register)
                  (^obj module-descr))))))

(define (univ-defs->code ctx root-name defs)
  (univ-emit-defs
   ctx
   #t
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
          root-name ;; root-name
          '()       ;; properties
          #f        ;; extends
          class-fields
          '() ;; instance-fields
          class-methods
          '() ;; instance-methods
          class-classes
          #f ;; constructor
          inits))))

     (else
      defs))))

(define (univ-link-info-header ctx name mods-and-flags rtlib-features-used glo-used module-meta-info)
  (let ((glos (table->list glo-used)))
    (^ (univ-link-info-prefix (target-name (ctx-target ctx)))
       (object->string
        (list (compiler-version)
              (list (target-name (ctx-target ctx))
                    (ctx-semantics-changing-options ctx))
              name
              mods-and-flags
              rtlib-features-used
              (map car (keep (lambda (x) (not (eq? (cdr x) 'wr))) glos))
              (map car (keep (lambda (x) (not (eq? (cdr x) 'rd))) glos))
              (map car (keep (lambda (x) (eq? (cdr x) 'rdwr)) glos))
              module-meta-info))
       "\n\n")))

(define (univ-link-info-footer ctx)
  (univ-source-file-footer (target-name (ctx-target ctx))))

(define (univ-link-info targ file)
  (let ((in (open-input-file*-preserving-case file)))
    (and in
         (let* ((pref
                 (univ-link-info-prefix (target-name targ)))
                (info
                 (let loop ((i 0))
                   (if (< i (string-length pref))
                       (let ((c (read-char in)))
                         (if (or (eof-object? c)
                                 (not (char=? c (string-ref pref i))))
                             #f
                             (loop (+ i 1))))
                       (read in)))))
           (close-input-port in)
           (and (pair? info)
                (pair? (cdr info))
                (pair? (cadr info))
                (equal? (car info) (compiler-version))
                (equal? (car (cadr info)) (target-name targ))
                info)))))

(define (univ-link-semantics-changing-options inputs warnings?)

  (define (sem-changing-opts x)
    (let ((info (caddr x)))
      (cadr (list-ref info 1))))

  (let* ((rev-inputs (reverse inputs))
         (first (car rev-inputs))
         (opts-first (sem-changing-opts first)))

    (let loop ((lst (cdr rev-inputs)))
      (if (pair? lst)
          (let* ((input (car inputs))
                 (opts-input (sem-changing-opts input)))
            (if (not (equal? opts-first opts-input))
                (compiler-user-error #f "inconsistent semantics changing options for files" (car first) opts-first (car input) opts-input))
            (loop (cdr lst)))))

    opts-first))

(define (univ-link-mods-and-flags inputs)

  (define (m-and-f x)
    (let ((info (caddr x)))
      (list-ref info 3)))

  (let ((rev-inputs (reverse inputs)))
    (let loop ((lst rev-inputs) (mods-and-flags '()))
      (if (pair? lst)
          (let ((info (caddr (car lst))))
            (loop (cdr lst)
                  (append (list-ref info 3) mods-and-flags)))
          mods-and-flags))))

(define (univ-link-features-used ctx inputs warnings?)

  (for-each (lambda (x)
              (let ((info (caddr x)))
                (for-each (lambda (feature)
                            (univ-use-rtlib ctx feature))
                          (list-ref info 4))
                (for-each (lambda (name)
                            (univ-glo-use ctx name 'rd))
                          (list-ref info 5))
                (for-each (lambda (name)
                            (univ-glo-use ctx name 'wr))
                          (list-ref info 6))
                (for-each (lambda (name)
                            (univ-glo-use ctx name 'rd)
                            (univ-glo-use ctx name 'wr))
                          (list-ref info 7))))
            (reverse inputs))

  (if warnings?

      (let ((undefs (make-table)))

        (for-each (lambda (x)
                    (let ((info (caddr x))
                          (t (ctx-glo-used ctx)))
                      (for-each (lambda (name)
                                  (let ((dir (table-ref t name 'rd)))
                                    (if (eq? dir 'rd)
                                        (let ((files (table-ref undefs name '())))
                                          (table-set! undefs name (cons (car x) files))))))
                                (list-ref info 5))))
                  (reverse inputs))

        (for-each (lambda (x)
                    (let ((name (car x))
                          (files (cdr x)))
                      (display "*** WARNING -- \"")
                      (display (symbol->string name))
                      (display "\" is not defined,")
                      (newline)
                      (display "***            referenced in: ")
                      (write files)
                      (newline)))
                  (table->list undefs))))

  (if (and warnings? univ-all-warnings)

      (let ((unrefs (make-table)))

        (for-each (lambda (x)
                    (let ((info (caddr x))
                          (t (ctx-glo-used ctx)))
                      (for-each (lambda (name)
                                  (let ((dir (table-ref t name 'wr)))
                                    (if (eq? dir 'wr)
                                        (let ((files (table-ref unrefs name '())))
                                          (table-set! unrefs name (cons (car x) files))))))
                                (list-ref info 6))))
                  (reverse inputs))

        (for-each (lambda (x)
                    (let ((name (car x))
                          (files (cdr x)))
                      (display "*** WARNING -- \"")
                      (display (symbol->string name))
                      (display "\" is defined but not referenced,")
                      (newline)
                      (display "***            defined in: ")
                      (write files)
                      (newline)))
                  (table->list unrefs)))))

(define univ-all-warnings #t)
(set! univ-all-warnings #f)

(define (univ-link targ extension? inputs output linker-name warnings?)
  (let* ((root
          (path-strip-extension output))

         (name
          (path-strip-directory root))

         (sem-changing-options
          (univ-link-semantics-changing-options inputs warnings?))

         (mods-and-flags
          (univ-link-mods-and-flags inputs))

         (ctx
          (make-ctx
           targ
           sem-changing-options
           '() ;; semantics-preserving-options
           ""  ;; module-name filled in later
           ""  ;; rts-module-name filled in later
           (univ-ns-prefix sem-changing-options)
           (univ-ns-prefix-class sem-changing-options)
           "zzz" ;;;;;;;;;;;;
           (make-objs-used)
           (make-resource-set)
           (make-table)
           (queue-empty)
           (queue-empty)
           (queue-empty)
           (make-table)
           #f))

         (_
          (begin
           (ctx-rts-module-name-set! ctx (univ-rts-module-name ctx))
           (ctx-module-name-set! ctx (ctx-rts-module-name ctx))))

         (rtlib-init
          (univ-rtlib-init ctx mods-and-flags))

         (_
          (univ-link-features-used ctx inputs warnings?))

         (features-used
          (resource-set-stack (ctx-rtlib-features-used ctx)))

         (code-entry
          (case (target-name targ)
            ((java)
             (univ-defs->code
              ctx
              name
              (univ-entry-defs ctx mods-and-flags)))
            (else
             (^))))

         (code-rtlib
          (univ-defs->code
           ctx
           (ctx-module-name ctx)
           (univ-rtlib-defs ctx rtlib-init)))

         (code-decls
          (queue->list (ctx-decls ctx)))

         (code
          (^ (univ-link-info-header
              ctx
              name
              mods-and-flags
              features-used
              (ctx-glo-used ctx)
              #f)
             (univ-module-header ctx (ctx-module-name ctx))
             code-entry
             code-rtlib
             code-decls
             (univ-module-footer ctx)
             (univ-link-info-footer ctx))))

    (univ-display-to-file code output)

    output))

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
                                        (univ-emit-this-mod-field ctx cst #f))
                              (univ-add-field
                               defs
                               (univ-field
                                cst
                                (univ-obj-type obj)
                                val)))
                            defs)))))
          defs))))

(define (univ-obj-use ctx obj force-var? gen-expr)

  (define (use-cst cst)
    (if (eq? (univ-module-representation ctx) 'global)
        (use-global ctx (univ-emit-this-mod-field ctx cst #f))))

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
                (label->id ctx
                           univ-cst-prefix
                           (table-length table)
                           (if (not (eq? (univ-module-representation ctx) 'global))
                               ""
                               (ctx-module-name ctx))))
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
          (make-table 'test: eq?)))

(define (objs-used-stack ou)        (vector-ref ou 0))
(define (objs-used-stack-set! ou x) (vector-set! ou 0 x))

(define (objs-used-table ou)        (vector-ref ou 1))
(define (objs-used-table-set! ou x) (vector-set! ou 1 x))

(define (univ-dump-procs global-ctx procs)

  (let ((proc-seen (queue-empty))
        (proc-left (queue-empty))
        (sharing-table (make-table)))

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
               (bb-todo (queue-empty))
               (ctrlpts (make-stretchable-vector #f))
               (ctrlpts-init (list #f))
               (debug-info-state (make-debug-info-state))
               (debug-info-init (list #f))
               (debug-info-ctrlpt-ids-rev '()))

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
                              (^ (univ-emit-comment
                                  ctx
                                  (if (label-entry-closed? gvm-instr)
                                      "closure-entry-point (+rest)"
                                      "entry-point (+rest)"))
                                 "\n")
                              (^ (univ-emit-comment
                                  ctx
                                  (if (label-entry-closed? gvm-instr)
                                      "closure-entry-point"
                                      "entry-point"))
                                 "\n")))

                         ((return)
                          (^ (univ-emit-comment ctx "return-point")
                             "\n"))

                         ((task-entry)
                          (^ (univ-emit-comment ctx "task-entry-point")
                             "\n"))

                         ((task-return)
                          (^ (univ-emit-comment ctx "task-return-point")
                             "\n"))

                         (else
                          (compiler-internal-error
                           "scan-gvm-label, unknown label type"))))
                      (entry
                       (bbs-entry-lbl-num bbs))
                      (lbl-num
                       (label-lbl-num gvm-instr))
                      (parent?
                       (= lbl-num entry))
                      (jumpable-type
                       (case (label-type gvm-instr)
                         ((entry)  (if parent?
                                       'parententrypt
                                       'entrypt))
                         ((return) 'returnpt)
                         (else     'ctrlpt)))
                      (gen-body
                       (lambda (ctx)
                         (^ (if (let ((node
                                       (comment-get
                                        (gvm-instr-comment gvm-instr)
                                        'node)))
                                  (and node
                                       (node-env node)
                                       (debug? (node-env node))))
                                (^expr-statement
                                 (^call-prim
                                  (^rts-method-use 'println)
                                  (^ "\"*** entering " id "\"")))
                                "")

                            (case (label-type gvm-instr)

                              ((entry)
                               (univ-label-entry ctx
                                                 gvm-instr
                                                 jumpable-type
                                                 (univ-emit-mod-jumpable
                                                  ctx
                                                  (ctx-module-name ctx)
                                                  id
                                                  #f)))

                              (else
                               (^)))
                            (proc ctx))))
                      (ctrlpt-id
                       (stretchable-vector-length ctrlpts)))

                 (stretchable-vector-set!
                  ctrlpts
                  ctrlpt-id
                  (cons jumpable-type lbl-num))

                 (case (label-type gvm-instr)
                   ((entry return)
                    (let ((node
                           (comment-get
                            (gvm-instr-comment gvm-instr)
                            'node))
                          (frame
                           (gvm-instr-frame gvm-instr)))

                      (set! debug-info-ctrlpt-ids-rev
                        (cons ctrlpt-id
                              debug-info-ctrlpt-ids-rev))

                      (debug-info-add!
                       debug-info-state
                       node
                       (if (eq? (label-type gvm-instr) 'entry)
                           '()
                           (reverse (frame-slots frame)))
                       frame))))

                 (univ-jumpable-declaration-defs
                  ctx
                  #t ;; global?
                  id ;; name
                  jumpable-type ;; jumpable-type
                  '() ;; params
                  (append ;; attribs

                   (list
                    (univ-field 'id
                                'int
                                (^int ctrlpt-id)
                                '(inherited))
                    (univ-field 'parent
                                'parententrypt
                                (cond ((and parent?
                                            (univ-parent-entry-point-has-null-parent? ctx))
                                       (^null))
                                      ((and parent?
                                            (eq? (univ-procedure-representation ctx)
                                                 'class))
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
                                               x))))))
                                '(inherited)))

                   (if (eq? jumpable-type 'ctrlpt)

                       '()

                       (if (eq? jumpable-type 'returnpt)

                           (let ((info (frame-info gvm-instr)))
                             (list
                              (univ-field 'fs
                                          'int
                                          (^int (vector-ref info 0))
                                          '(inherited))
                              (univ-field 'link
                                          'int
                                          (^int (+ (vector-ref info 1) 1))
                                          '(inherited))))

                           (append
                            (list
                             (univ-field
                              'nfree
                              'int
                              (if (label-entry-closed? gvm-instr)
                                  (let* ((frame (gvm-instr-frame gvm-instr))
                                         (nfree (length (frame-closed frame))))
                                    (^int nfree))
                                  (^int -1))
                              '(inherited)))
                            (if parent?
                                (list
                                 (univ-field 'name
                                             'symbol
                                             (lambda (ctx)
                                               (univ-prm-name
                                                ctx
                                                (proc-obj-name p)))
                                             '(inherited))
                                 (univ-field 'ctrlpts
                                             '(array ctrlpt)
                                             ctrlpts-init
                                             '(inherited))
                                 (univ-field 'info
                                             'scmobj
                                             debug-info-init
                                             '(inherited))
                                 (univ-field 'prim
                                             'bool
                                             (lambda (ctx)
                                               (^bool (proc-obj-primitive? p)))
                                             '(inherited)))
                                '())))))

                  (univ-emit-fn-body ctx header gen-body)))))) ;; body

          (define (unwind-stack? gvm-instr)
            (let ((node (comment-get (gvm-instr-comment gvm-instr) 'node)))
              (and node (not (intrs-enabled? (node-env node))) 'unwind)))

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
               (scan-opnd (jump-opnd gvm-instr))
               (if (jump-ret gvm-instr)
                   (todo-lbl-num! (jump-ret gvm-instr)))))

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
               (let ((test (ifjump-test gvm-instr))
                     (opnds (ifjump-opnds gvm-instr))
                     (true (ifjump-true gvm-instr))
                     (false (ifjump-false gvm-instr))
                     (fs (frame-size (gvm-instr-frame gvm-instr)))
                     (poll? (or (ifjump-poll? gvm-instr)
                                (unwind-stack? gvm-instr))))

                 (let ((proc (proc-obj-test test)))
                   (if (not proc)

                       (compiler-internal-error
                        "scan-gvm-instr, unknown 'test'" test)

                       (proc
                        ctx
                        (lambda (result)
                          (cond ((eq? result #f)
                                 (jump-to-label ctx false fs poll?))
                                ((eq? result #t)
                                 (jump-to-label ctx true fs poll?))
                                (else
                                 (^if result
                                      (jump-to-label ctx true fs poll?)
                                      (jump-to-label ctx false fs poll?)))))
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
                     (safe? (jump-safe? gvm-instr))
                     (opnd (jump-opnd gvm-instr))
                     (ret (jump-ret gvm-instr))
                     (fs (frame-size (gvm-instr-frame gvm-instr)))
                     (poll? (or (jump-poll? gvm-instr)
                                (unwind-stack? gvm-instr))))

                 (or (and (obj? opnd)
                          (proc-obj? (obj-val opnd))
                          nb-args
                          (let* ((proc (obj-val opnd))
                                 (jump-inliner (proc-obj-jump-inline proc)))
                            (and jump-inliner
                                 (jump-inliner ctx ret nb-args poll? safe? fs))))

                     (let ((setup-return-addr
                            (if ret
                                (^ (if (eqv? opnd return-addr-reg) ;; destination in location of ret addr?
                                       (let* ((spare-reg
                                               (make-reg (+ (targ-nb-arg-regs) 1)))
                                              (move-to-spare-reg
                                               (^setloc spare-reg
                                                        (^getopnd opnd))))
                                         (set! opnd spare-reg)
                                         move-to-spare-reg)
                                       (^))
                                   (^setloc return-addr-reg
                                            (^getopnd (make-lbl ret))))
                                (^))))

                       (^ setup-return-addr

                          (if nb-args
                              (^setnargs nb-args)
                              (^))

                          (or (and (lbl? opnd)
                                   (jump-to-label ctx (lbl-num opnd) fs poll?))

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
                                      (cond ((lbl? opnd)
                                             (todo-lbl-num! (lbl-num opnd))
                                             (gvm-lbl-use ctx opnd))
                                            ((and (obj? opnd)
                                                  (proc-obj? (obj-val opnd)))
                                             (^obj-proc-as 'jumpable
                                                           (obj-val opnd)))
                                            (else
                                             (^downupcast*
                                              (if nb-args 'entrypt 'returnpt)
                                              'jumpable
                                              (^getopnd opnd)))))
                                  poll?
                                  (and

                                   (univ-compactness>=? ctx 7)

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
                                     ((go)
                                      ;; avoid call optimization on go
                                      ;; because there is no speed advantage
                                      ;; to do it
                                      #f)
                                     (else
                                      #t))))))))))))

              (else
               (compiler-internal-error
                "scan-gvm-instr, unknown 'gvm-instr':"
                gvm-instr))))

          (define (jump-to-label ctx n jump-fs poll?)
            (with-stack-pointer-adjust
             ctx
             (+ jump-fs
                (ctx-stack-base-offset ctx))
             (lambda (ctx)

               (define (cont)
                 (cond ((and (not (univ-compactness>=? ctx 6))
                             (ctx-allow-jump-destination-inlining? ctx)
                             (let* ((bb (lbl-num->bb n bbs))
                                    (label-instr (bb-label-instr bb)))
                               (and (eq? (label-type label-instr) 'simple)
                                    (or (= (length (bb-precedents bb)) 1)
                                        (= (length (bb-non-branch-instrs bb)) 0))))) ;; very short destination bb?
                        (let* ((bb (lbl-num->bb n bbs))
                               (label-instr (bb-label-instr bb))
                               (label-fs (frame-size (gvm-instr-frame label-instr))))
                          (with-stack-base-offset
                           ctx
                           (- label-fs)
                           (lambda (ctx)
                             (with-allow-jump-destination-inlining?
                              ctx
                              (= (length (bb-precedents bb)) 1) ;; #f
                              (lambda (ctx)
                                (scan-bb-all-except-label ctx bb)))))))

                       (else
                        (^return-jump
                         (scan-gvm-opnd ctx (make-lbl n))))))

               (univ-emit-poll-or-continue ctx (scan-gvm-opnd ctx (make-lbl n)) poll? cont))))

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
                           (map (lambda (jt-n)
                                  (let* ((jumpable-type (car jt-n))
                                         (n (cdr jt-n)))
                                    (^upcast* jumpable-type
                                              'ctrlpt
                                              (univ-ctrlpt-reference ctx n))))
                                (stretchable-vector->list ctrlpts)))))
                    (if (eq? (univ-ctrlpt-reference-type ctx) 'str)

                        (begin
                          (set-car! ctrlpts-init ctrlpts-array)
                          (lambda (ctx) (^)))

                        (begin
                          (set-car! ctrlpts-init (^null))
                          (lambda (ctx)
                            (if (univ-use-ctrlpt-init? ctx)
                                (^)
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
                                       ctrlpts-array))))))))))
                 (init2
                  (lambda (ctx)
                    (let ((name (string->symbol (proc-obj-name p))))
                      (if (univ-use-ctrlpt-init? ctx)
                          (begin
                            (if (proc-obj-primitive? p)
                                ;; global variable will be implicitly defined
                                ;; by parententrypt_init
                                (univ-glo-dependency ctx name 'wr))
                            (^))
                          (^ "\n"
                             ;; p is a parententrypt
                             (^setpeps name (^obj-proc-as 'parententrypt p))
                             (if (proc-obj-primitive? p)
                                 (^setglo name (^obj-proc-as 'scmobj p))
                                 (^))))))))

            (let* ((ctrlpt-ids
                    (list->vector (reverse debug-info-ctrlpt-ids-rev)))
                   (debug-info
                    (debug-info-generate
                     debug-info-state
                     (lambda (i) (vector-ref ctrlpt-ids i))
                     sharing-table)))
              (set-car! debug-info-init (^obj debug-info)))

            (univ-add-init (univ-add-init bbs-defs init1) init2))))

      (let ((ctx (make-ctx
                  (ctx-target global-ctx)
                  (ctx-semantics-changing-options global-ctx)
                  (ctx-semantics-preserving-options global-ctx)
                  (ctx-module-name global-ctx)
                  (ctx-rts-module-name global-ctx)
                  (ctx-ns-prefix global-ctx)
                  (ctx-ns-prefix-class global-ctx)
                  (scheme-id->c-id (proc-obj-name p))
                  (ctx-objs-used global-ctx)
                  (ctx-rtlib-features-used global-ctx)
                  (ctx-glo-used global-ctx)
                  (ctx-decls global-ctx)
                  (ctx-inits global-ctx)
                  (ctx-imports global-ctx)
                  (ctx-label-table global-ctx)
                  (ctx-label-ns global-ctx))))
        (let ((x (proc-obj-code p)))
          (if (bbs? x)
              (scan-bbs ctx x)
              (univ-make-empty-defs)))))

    (for-each scan-obj procs)

    (let loop ((defs (univ-make-empty-defs)))
      (if (queue-empty? proc-left)
          defs
          (loop (univ-defs-combine defs (dump-proc (queue-get! proc-left))))))))

(define (univ-label-entry ctx gvm-instr jumpable-type id)
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

          (cond
           ((and keys rest?)
            (let ((error (^local-var 'error)))
              (^
               (^var-declaration 'jumpable error
                                 (^call-prim (^rts-method-use 'build_key_rest)
                                             (^int nb-req-and-opt)
                                             (^int nb-parms)
                                             (^array-literal
                                              'scmobj
                                              (apply append
                                                     (map (lambda (x)
                                                            (list (^obj (car x)) (^obj (obj-val (cdr x)))))
                                                          keys)))))
               (^if (^not (^parens (^eq? error (^null))))
                    (^return-call-prim
                     (^rts-method-use 'wrong_key_args)
                     (if closed?
                         (^cast*-jumpable (^getreg (+ (univ-nb-arg-regs ctx) 1)))
                         (^upcast* jumpable-type 'entrypt id))
                     error)))))
           (keys
            (let ((error (^local-var 'error)))
              (^
               (^var-declaration 'jumpable error
                                 (^call-prim (^rts-method-use 'build_key)
                                             (^int nb-req-and-opt)
                                             (^int nb-parms)
                                             (^array-literal
                                              'scmobj
                                              (apply append
                                                     (map (lambda (x)
                                                            (list (^obj (car x)) (^obj (obj-val (cdr x)))))
                                                          keys)))))
               (^if (^not (^parens (^eq? error (^null))))
                    (^return-call-prim
                     (^rts-method-use 'wrong_key_args)
                     (if closed?
                         (^downcast* 'jumpable (^getreg (+ (univ-nb-arg-regs ctx) 1)))
                         (^upcast* jumpable-type 'entrypt id))
                     error)))))
           (else
            (^if (if rest?
                     (^not (^call-prim
                            (^rts-method-use 'build_rest)
                            (^int nb-parms-except-rest)))
                     (^!= (^getnargs)
                          (^int nb-parms-except-rest)))
                 (^return-call-prim
                  (^rts-method-use 'wrong_nargs)
                  (if closed?
                      (^downcast* 'jumpable (^getreg (+ (univ-nb-arg-regs ctx) 1)))
                      (^upcast* jumpable-type 'entrypt id))))))

          (let ((nb-stacked (max 0 (- nb-args (univ-nb-arg-regs ctx))))
                (nb-stacked* (max 0 (- nb-parms (univ-nb-arg-regs ctx)))))

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
                       (^int nb-args))
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
         semantics-changing-options
         semantics-preserving-options
         module-name
         rts-module-name
         ns-prefix
         ns-prefix-class
         ns
         objs-used
         rtlib-features-used
         glo-used
         decls
         inits
         imports
         label-table
         label-ns)
  (vector target
          semantics-changing-options
          semantics-preserving-options
          module-name
          rts-module-name
          ns-prefix
          ns-prefix-class
          ns
          0
          0
          univ-enable-jump-destination-inlining?
          (make-resource-set)
          (make-resource-set)
          (make-resource-set)
          objs-used
          rtlib-features-used
          glo-used
          decls
          inits
          imports
          label-table
          label-ns))

(define (ctx-target ctx)                   (vector-ref ctx 0))
(define (ctx-target-set! ctx x)            (vector-set! ctx 0 x))

(define (ctx-semantics-changing-options ctx)        (vector-ref ctx 1))
(define (ctx-semantics-changing-options-set! ctx x) (vector-set! ctx 1 x))

(define (ctx-semantics-preserving-options ctx)        (vector-ref ctx 2))
(define (ctx-semantics-preserving-options-set! ctx x) (vector-set! ctx 2 x))

(define (ctx-module-name ctx)              (vector-ref ctx 3))
(define (ctx-module-name-set! ctx x)       (vector-set! ctx 3 x))

(define (ctx-rts-module-name ctx)          (vector-ref ctx 4))
(define (ctx-rts-module-name-set! ctx x)   (vector-set! ctx 4 x))

(define (ctx-ns-prefix ctx)                (vector-ref ctx 5))
(define (ctx-ns-prefix-set! ctx x)         (vector-set! ctx 5 x))

(define (ctx-ns-prefix-class ctx)          (vector-ref ctx 6))
(define (ctx-ns-prefix-class-set! ctx x)   (vector-set! ctx 6 x))

(define (ctx-ns ctx)                       (vector-ref ctx 7))
(define (ctx-ns-set! ctx x)                (vector-set! ctx 7 x))

(define (ctx-stack-base-offset ctx)        (vector-ref ctx 8))
(define (ctx-stack-base-offset-set! ctx x) (vector-set! ctx 8 x))

(define (ctx-serial-num ctx)               (vector-ref ctx 9))
(define (ctx-serial-num-set! ctx x)        (vector-set! ctx 9 x))

(define (ctx-allow-jump-destination-inlining? ctx)        (vector-ref ctx 10))
(define (ctx-allow-jump-destination-inlining?-set! ctx x) (vector-set! ctx 10 x))

(define (ctx-resources-used-rd ctx)        (vector-ref ctx 11))
(define (ctx-resources-used-rd-set! ctx x) (vector-set! ctx 11 x))

(define (ctx-resources-used-wr ctx)        (vector-ref ctx 12))
(define (ctx-resources-used-wr-set! ctx x) (vector-set! ctx 12 x))

(define (ctx-globals-used ctx)             (vector-ref ctx 13))
(define (ctx-globals-used-set! ctx x)      (vector-set! ctx 13 x))

(define (ctx-objs-used ctx)                (vector-ref ctx 14))
(define (ctx-objs-used-set! ctx x)         (vector-set! ctx 14 x))

(define (ctx-rtlib-features-used ctx)        (vector-ref ctx 15))
(define (ctx-rtlib-features-used-set! ctx x) (vector-set! ctx 15 x))

(define (ctx-glo-used ctx)                 (vector-ref ctx 16))
(define (ctx-glo-used-set! ctx x)          (vector-set! ctx 16 x))

(define (ctx-decls ctx)                    (vector-ref ctx 17))
(define (ctx-decls-set! ctx x)             (vector-set! ctx 17 x))

(define (ctx-inits ctx)                    (vector-ref ctx 18))
(define (ctx-inits-set! ctx x)             (vector-set! ctx 18 x))

(define (ctx-imports ctx)                  (vector-ref ctx 19))
(define (ctx-imports-set! ctx x)           (vector-set! ctx 19 x))

(define (ctx-label-table ctx)              (vector-ref ctx 20))
(define (ctx-label-table-set! ctx x)       (vector-set! ctx 20 x))

(define (ctx-label-ns ctx)                 (vector-ref ctx 21))
(define (ctx-label-ns-set! ctx x)          (vector-set! ctx 21 x))

(define (univ-add-module-init ctx init)
  (queue-put! (ctx-inits ctx) init))

(define (univ-add-module-import ctx imp)
  (let ((imps (ctx-imports ctx)))
    (if (not (member imp (queue->list imps)))
        (queue-put! imps imp))))

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

(define (gvm-state-peps ctx)
  (^rts-field-use 'peps))

(define (gvm-state-glo ctx)
  (^rts-field-use 'glo))

(define (gvm-state-current-vm ctx)
  (^rts-field-use 'current_vm))

(define (gvm-state-current-processor ctx)
  (^rts-field-use 'current_processor))

(define (gvm-state-current-thread ctx)
  (^structure-ref (gvm-state-current-processor ctx)
                  univ-processor-current-thread-slot))

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

(define (gvm-state-peps-use ctx dir)
  (use-resource ctx dir 'peps)
  (gvm-state-peps ctx))

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
     (^field 'slots (^cast* 'closure closure)))

    ((struct)
     (^ "~~~TODO1:univ-clo-slots~~~"))

    (else
     (case (target-name (ctx-target ctx))
       ((php)
        ;;(^field 'slots (^cast* 'closure closure))
        (^field 'slots closure))
       (else
        (^jump closure (^bool #t)))))))

(define (univ-emit-getclo ctx closure index)
  (^closure-ref closure index))

(define (univ-emit-setclo ctx closure index val)
  (^closure-set! closure index val))

(define (univ-glo-dependency ctx name dir)
  (univ-glo-use ctx name dir)
  (gvm-state-glo-use ctx 'rd)
  (if (member name
              '(println
                real-time-milliseconds
                ##exit-process))
      (begin
        (univ-glo-use ctx name 'wr) ;; automatically defined primitives
        (univ-use-rtlib
         ctx
         (string->symbol (string-append "glo-" (symbol->string name)))))))

(define (univ-glo-use ctx name dir)
  (let* ((t (ctx-glo-used ctx))
         (x (table-ref t name #f)))
    (table-set! t name (if (or (not x) (eq? dir x)) dir 'rdwr))))

(define (univ-get-symbol-name ctx sym)
  (if (and (univ-compactness>=? ctx 9)
           (>= (string-length (symbol->string sym)) 6))
      (^symbol-unbox (^obj sym))
      (^str (symbol->string sym))))

(define (univ-emit-getpeps ctx name)
  (^dict-get 'entrypt
             (gvm-state-peps-use ctx 'rd)
             (univ-get-symbol-name ctx name)))

(define (univ-emit-setpeps ctx name val)
  (^dict-set 'entrypt
             (gvm-state-peps-use ctx 'rd)
             (univ-get-symbol-name ctx name)
             val))

(define (univ-emit-getglo ctx name)
  (univ-glo-dependency ctx name 'rd)
  (^dict-get 'scmobj
             (gvm-state-glo-use ctx 'rd)
             (univ-get-symbol-name ctx name)))

(define (univ-emit-setglo ctx name val)
  (univ-glo-dependency ctx name 'wr)
  (^dict-set 'scmobj
             (gvm-state-glo-use ctx 'rd)
             (univ-get-symbol-name ctx name)
             val))

(define (univ-emit-glo-var? ctx sym)
  (^prop-index-exists? (gvm-state-glo-use ctx 'rd)
                       (^symbol-unbox sym)))

(define (univ-emit-glo-var-ref ctx sym)
  (^dict-get 'scmobj
             (gvm-state-glo-use ctx 'rd)
             (^symbol-unbox sym)))

(define (univ-emit-glo-var-primitive-ref ctx sym)
  (^dict-get 'entrypt
             (gvm-state-peps-use ctx 'rd)
             (^symbol-unbox sym)))

(define (univ-emit-glo-var-set! ctx sym val)
  (^dict-set 'scmobj
             (gvm-state-glo-use ctx 'rd)
             (^symbol-unbox sym)
             val))

(define (univ-emit-glo-var-primitive-set! ctx sym val)
  (^dict-set 'scmobj
             (gvm-state-peps-use ctx 'rd)
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

(define (univ-emit-obj* ctx obj force-var?)

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
                   (^cpxnum-make (univ-emit-obj* ctx (real-part obj) #f)
                                 (univ-emit-obj* ctx (imag-part obj) #f)))))

               ((not (exact? obj)) ;; floating-point number
                (^flonum-box (^float obj)))

               ((not (integer? obj)) ;; non-integer rational number
                (univ-obj-use
                 ctx
                 obj
                 force-var?
                 (lambda ()
                   (^ratnum-make (univ-emit-obj* ctx (numerator obj) #f)
                                 (univ-emit-obj* ctx (denominator obj) #f)))))

               (else ;; exact integer
                (if (and (>= obj univ-fixnum-min)
                         (<= obj univ-fixnum-max))

                    (^fixnum-box (^int obj))

                    (univ-obj-use
                     ctx
                     obj
                     force-var?
                     (lambda ()
                       (^new 'bignum
                             (univ-num-array-constant
                              ctx
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

        ((deleted-object? obj)
         (^deleted))

        ((unused-object? obj)
         (^unused))

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
         (univ-emit-obj-proc-as ctx 'scmobj obj))

        ((pair? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^cons (univ-emit-obj* ctx (car obj) #f)
                   (univ-emit-obj* ctx (cdr obj) #f)))))

        ((vector-object? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^vector-box
             (^array-literal
              'scmobj
              (map (lambda (x) (univ-emit-obj* ctx x #f))
                   (vector->list obj)))))))

        ((u8vect? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^u8vector-box
             (univ-num-array-constant ctx 'u8 (u8vect->list obj))))))

        ((u16vect? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^u16vector-box
             (univ-num-array-constant ctx 'u16 (u16vect->list obj))))))

        ((u32vect? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^u32vector-box
             (univ-num-array-constant ctx 'u32 (u32vect->list obj))))))

        ((u64vect? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^u64vector-box
             (univ-num-array-constant ctx 'u64 (u64vect->list obj))))))

        ((s8vect? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^s8vector-box
             (univ-num-array-constant ctx 's8 (s8vect->list obj))))))

        ((s16vect? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^s16vector-box
             (univ-num-array-constant ctx 's16 (s16vect->list obj))))))

        ((s32vect? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^s32vector-box
             (univ-num-array-constant ctx 's32 (s32vect->list obj))))))

        ((s64vect? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^s64vector-box
             (univ-num-array-constant ctx 's64 (s64vect->list obj))))))

        ((f32vect? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^f32vector-box
             (univ-num-array-constant ctx 'f32 (f32vect->list obj))))))

        ((f64vect? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^f64vector-box
             (univ-num-array-constant ctx 'f64 (f64vect->list obj))))))

        ((structure-object? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (let* ((slots
                    (##vector-copy obj)) ;;TODO: replace call of ##vector-copy
                   (cyclic?
                    (eq? (vector-ref slots 0) obj)))
              (^structure-box
               (^array-literal
                'scmobj
                (cons (if cyclic? ;; the root type descriptor is cyclic
                          (^null) ;; handle this specially
                          (univ-emit-obj* ctx (vector-ref slots 0) #f))
                      (map (lambda (x) (univ-emit-obj* ctx x #f))
                           (cdr (vector->list slots))))))))))

        ((box-object? obj)
         (univ-obj-use
          ctx
          obj
          force-var?
          (lambda ()
            (^box (^obj (unbox-object obj))))))

        (else
         (compiler-user-warning #f "UNIMPLEMENTED OBJECT:" obj)
         (^str
          (string-append
           "UNIMPLEMENTED OBJECT: "
           (object->string obj))))))

(define (univ-emit-obj-proc-as ctx type obj)
  (let* ((name
          (proc-obj-name obj))
         (parent-entry-point
          (if (proc-obj-code obj) ;; procedure defined in this module?
              (univ-emit-this-mod-jumpable ctx (gvm-proc-use ctx name) #f)
              (^getpeps (string->symbol name)))))
    (if (eq? type 'scmobj)
        (^conv* 'scmobj (^upcast* 'parententrypt 'entrypt parent-entry-point))
        (^upcast* 'parententrypt type parent-entry-point))))

(define (univ-emit-obj ctx obj)
  (univ-emit-obj* ctx obj #t))

(define (univ-obj-type obj)

  (cond ((or (false-object? obj)
             (boolean? obj))
         'boolean)

        ((number? obj)
         (cond ((not (real? obj)) ;; non-real complex number
                'cpxnum)

               ((not (exact? obj)) ;; floating-point number
                'flonum)

               ((not (integer? obj)) ;; non-integer rational number
                'ratnum)

               (else ;; exact integer
                (if (and (>= obj univ-fixnum-min)
                         (<= obj univ-fixnum-max))
                    'fixnum
                    'bignum))))

        ((char? obj)
         'char)

        ((string? obj)
         'string)

        ((symbol-object? obj)
         'symbol)

        ((keyword-object? obj)
         'keyword)

        ((null? obj)
         'null)

        ((void-object? obj)
         'void)

        ((end-of-file-object? obj)
         'eof)

        ((absent-object? obj)
         'absent)

        ((deleted-object? obj)
         'deleted)

        ((unused-object? obj)
         'unused)

        ((or (unbound1-object? obj)
             (unbound2-object? obj))
         'unbound)

        ((optional-object? obj)
         'optional)

        ((key-object? obj)
         'key)

        ((rest-object? obj)
         'rest)

        ((proc-obj? obj)
         (if (proc-obj-code obj) ;; procedure defined in this module?
             'jumpable
             'parententrypoint))

        ((pair? obj)
         'pair)

        ((vector-object? obj)
         'vector)

        ((u8vect? obj)
         'u8vector)

        ((u16vect? obj)
         'u16vector)

        ((u32vect? obj)
         'u32vector)

        ((u64vect? obj)
         'u64vector)

        ((s8vect? obj)
         's8vector)

        ((s16vect? obj)
         's16vector)

        ((s32vect? obj)
         's32vector)

        ((s64vect? obj)
         's64vector)

        ((f32vect? obj)
         'f32vector)

        ((f64vect? obj)
         'f64vector)

        ((structure-object? obj)
         'structure)

        (else
         ;;TODO: handle these types better
         ;;  box
         ;;  closure
         ;;  continuation
         ;;  foreign
         ;;  promise
         ;;  values
         ;;  will
         'scmobj)))

(define univ-mdigit-width 14)
(define univ-mdigit-base (expt 2 univ-mdigit-width))
(define univ-mdigit-base-minus-1 (- univ-mdigit-base 1))

(define (univ-bignum->digits obj)

  (define (dig n len rest)
    (cond ((= len 1)
           (cons n rest))
          (else
           (let* ((hi-len (quotient len 2))
                  (lo-len (- len hi-len))
                  (lo-len-bits (* univ-mdigit-width lo-len)))
             (let* ((hi (arithmetic-shift n (- lo-len-bits)))
                    (lo (- n (arithmetic-shift hi lo-len-bits))))
               (dig lo
                    lo-len
                    (dig hi
                         hi-len
                         rest)))))))

  (let* ((width (integer-length obj))
         (len (+ (quotient width univ-mdigit-width) 1)))
    (dig (if (< obj 0)
           (+ (arithmetic-shift 1 (* univ-mdigit-width len)) obj)
           obj)
         len
         '())))

(define (univ-typed-array-constructor ctx type)
  (case (target-name (ctx-target ctx))

    ((js)
     (case type
       ((s8)  "Int8Array")
       ((u8)  "Uint8Array")
       ((s16) "Int16Array")
       ((u16) "Uint16Array")
       ((s32) "Int32Array")
       ((u32) "Uint32Array")
       ((f32) "Float32Array")
       ((f64) "Float64Array")
       (else  #f)))

    ((python)
     (case type
       ((u8) "bytearray")
       (else #f)))

    (else
     #f)))

(define (univ-array-constructor ctx type)
  (or (univ-typed-array-constructor ctx type)
      (case (target-name (ctx-target ctx))
        ((js)
         "Array")
        ((python)
         "list")
        (else
         #f))))

(define (univ-emit-array-literal ctx type elems)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (let ((array (^ "[" (univ-separated-list "," elems) "]"))
           (typed-array-constructor (univ-typed-array-constructor ctx type)))
       (if typed-array-constructor
           (^new* typed-array-constructor (list array))
           array)))

    ((php)
     (^apply "array" elems))

    ((java)
     (^ "new " (^type (list 'array type)) "{" (univ-separated-list "," elems) "}"))

    ((go)
     (^ "[]" (^type type) "{" (univ-separated-list "," elems) "}"))

    (else
     (compiler-internal-error
      "univ-emit-array-literal, unknown target"))))

(define (univ-emit-extensible-array-literal ctx type elems)
  (case (target-name (ctx-target ctx))

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
     (univ-emit-array-literal ctx type elems))))

(define (univ-emit-new-array ctx type len)
  (case (target-name (ctx-target ctx))

    ((js)
     (^new (list 'array type) len))

    ((php)
     (^if-expr 'scmobj
               (^= len (^int 0)) ;; array_fill does not like len=0
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

    ((go)
     (^ "make(" (^type (list 'array type)) "," len ")"))

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
      (^if-expr 'scmobj
                (^= len (^int 0)) ;; array_fill does not like len=0
                (^array-literal type '())
                (^call-prim
                 "array_fill"
                 (^int 0)
                 len
                 init))))

    ((python)
     (return
      (^* (^array-literal type (list init)) len)))

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

    ((go)
     (^ "~~~TODO1:univ-emit-make-array~~~"))

    (else
     (compiler-internal-error
      "univ-emit-make-array, unknown target"))))

(define (univ-num-array-constant ctx type elems)
  (if (and (memq (target-name (ctx-target ctx)) '(js python))
           (memq type '(u8 u16 u32 bigdigit unicode))
           (univ-compactness>=? ctx 6))

      (let ((s (base92-encode (list->vector elems))))
        (^call-prim
         (^rts-method-use 'base92_decode)
         (^str s)))

      (^array-literal type (map (lambda (n) (^num-of-type type n)) elems))))

(define univ-renamed-fields
  '(
    ;; classes ctrlpt and part of entrypt, parententrypoint, and returnpt
    (id        . a)
    (parent    . b)

    ;; classes entrypt and part of parententrypoint
    ;;(id        . a)
    ;;(parent    . b)
    (nfree     . c)

    ;; class parententrypoint
    ;;(id        . a)
    ;;(parent    . b)
    ;;(nfree     . c)
    (name      . d)
    (ctrlpts   . e)
    (info      . f)
    (prim      . g)

    ;; class returnpt
    ;;(id        . a)
    ;;(parent    . b)
    (fs        . h) ;; must not clash with nfree field to implement procedure?
    (link      . d)

    ;; class closure
    (slots     . a)

    ;; class promise
    (state     . a)

    ;; class will
    (testator  . a)
    (action    . b)

    ;; class values
    (vals      . a)

    ;; class fixnum, flonum, boolean, box and part of foreign
    (val       . a)

    ;; class foreign
    ;;(val       . a)
    (tags      . b)

    ;; class scheme
    (scmobj    . a)

    ;; class bignum
    (digits    . a)

    ;; class ratnum
    (num       . a)
    (den       . b)

    ;; class cpxnum
    (real      . a)
    (imag      . b)

    ;; class pair
    (car       . a)
    (cdr       . b)

    ;; class vector, u8vector, etc
    (elems     . a)

    ;; class structure and frame
    (slots     . a)

    ;; class continuation
    (frame     . a)
    (denv      . b)

    ;; class char
    (code      . a)

    ;; class string
    (codes     . a)

    ;; class modlinkinfo
    ;;(name      . d)
    (index     . a)

    ;; class symbol and keyword
    (hname     . a)
    ;;(name      . d)
    (hash      . b)
    (interned  . c)))

(define (univ-field-rename ctx name)
  (if (univ-compactness>=? ctx 5)
      (let ((x (assq name univ-renamed-fields)))
        (or (and x (cdr x)) name))
      (if (and (eq? name 'name)
               (eq? 'js (target-name (ctx-target ctx))))
          '_name ;; avoid clash with builtin "name" attribute of functions
          name)))

(define (univ-rts-field-low-level-name ctx name)
  (if (univ-compactness>=? ctx 5)
      (case name
        ((r0)        'r)
        ((r1)        'a)
        ((r2)        'b)
        ((r3)        'c)
        ((r4)        'd)
        ((glo)       'g)
        ((stack)     's)
        ((sp)        't)
        ((nargs)     'n)
        ((peps)      'e)
        ((pollcount) 'q)
        ((inttemp1)  'o)
        ((inttemp2)  'h)
        (else        name))
      name))

(define (univ-rts-method-low-level-name ctx name)
  (if (univ-compactness>=? ctx 5)
      (case name
        ((poll)                 'p)
        ((wrong_nargs)          'w)
        ((make_interned_symbol) 'i)
        ((check_procedure_glo)  'u)
        ((ctrlpt_init)          'j)
        ((returnpt_init)        'k)
        ((entrypt_init)         'l)
        ((parententrypt_init)   'm)
        ((flonumbox)            'F)
        ((flonump)              'f)
        ((vectorbox)            'V)
        ((vectorp)              'v)
        ((stringbox)            'Z)
;;        ((stringp)              'z)
        ((cons)                 'X)
        ((pairp)                'x)
        ((jsnumberp)            'y)
        ((base92_decode)        'z)
        (else                   name))
      name))

(define univ-c-id-reserved 260)

(define univ-cst-prefix "cst")
(define univ-bb-prefix "bb")
(define univ-capitalized-bb-prefix "Bb")

(define (univ-compactness>=? ctx level)
  (>= (or (univ-get-semantics-changing-option ctx 'compactness)
          (target-compactness (ctx-target ctx)))
      level))

;; =============================================================================

(define (gvm-lbl-use ctx lbl)
  (univ-emit-this-mod-jumpable ctx (gvm-lbl-use-aux ctx lbl) #f))

(define (gvm-lbl-use-aux ctx lbl)
  (gvm-bb-use ctx (lbl-num lbl) (ctx-ns ctx)))

(define (gvm-proc-use ctx name)
  (gvm-bb-use ctx 1 (scheme-id->c-id name)))

(define (gvm-bb-use ctx num ns)
  (let ((id (lbl->id ctx num ns)))
    ;;TODO: remove?
    ;;(use-global ctx (univ-emit-mod-field ctx "ZZZ" id))
    id))

(define (lbl->id ctx num ns)
  (label->id ctx univ-bb-prefix num ns))

(define (label->id ctx prefix num ns)
  (let* ((key (vector prefix num ns))
         (label-table (ctx-label-table ctx)))
    (or (table-ref label-table key #f)
        (let* ((label-ns
                (ctx-label-ns ctx))
               (id
                (if label-ns
                    (string-append
                     (nonneg-integer->c-id
                      (+ univ-c-id-reserved (table-length label-table)))
                     label-ns)
                    (^ prefix num "_" ns))))
          (table-set! label-table key id)
          id))))

(define (univ-foldr-range lo hi rest fn)
  (if (<= lo hi)
      (univ-foldr-range
       lo
       (- hi 1)
       (fn hi rest)
       fn)
      rest))

(define (univ-pop-args-to-vars ctx nb-args)
  (let ((nb-stacked (max 0 (- nb-args (univ-nb-arg-regs ctx)))))
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
   (- (univ-nb-arg-regs ctx) 1)
   (^)
   (lambda (i rest)
     (^if (^> (^getnargs) i)
          (^ (^push (^getreg (+ i 1)))
             rest)))))

(define (univ-pop-args-to-regs ctx lo)
  (univ-foldr-range
   0
   (- (univ-nb-arg-regs ctx) 1)
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

(define (univ-min-memoized-fixnum ctx) 0)
(define (univ-max-memoized-fixnum ctx) 256)

;;;============================================================================
