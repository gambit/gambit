;;;============================================================================

;;; File: "_t-univ.scm"

;;; Copyright (c) 2011-2012 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2012 by Eric Thivierge, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

(define univ-enable-jump-destination-inlining? #f)
(set! univ-enable-jump-destination-inlining? #t)

;;;----------------------------------------------------------------------------
;;
;; "Universal" back-end.

;; Initialization/finalization of back-end.

(define (univ-setup target-language file-extension)
  (let ((targ (make-target 9 target-language 0)))

    (define (begin! info-port)

      (target-dump-set!
       targ
       (lambda (procs output c-intf script-line options)
         (univ-dump targ procs output c-intf script-line options)))

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

      (target-file-extension-set!
       targ
       file-extension)

      #f)

    (define (end!)
      #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)
    (target-add targ)))

(univ-setup 'js     ".js")
(univ-setup 'python ".py")
(univ-setup 'ruby   ".rb")
(univ-setup 'php    ".php")
(univ-setup 'dart   ".dart")

;;;----------------------------------------------------------------------------

;; Generation of textual target code.

(define (univ-indent . rest)
  (cons '$$indent$$ rest))

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
           (if (eq? (car x) '$$indent$$)
               (begin
                 (set! indent-level (+ indent-level 1))
                 (disp (cdr x))
                 (set! indent-level (- indent-level 1)))
               (begin
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

(univ-prim-proc-add! '("js-code" (1) #t 0 0 (#f) extended))

(define (univ-switch-testable? targ obj)
  (pretty-print (list 'univ-switch-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (univ-eq-testable? targ obj)
  (pretty-print (list 'univ-eq-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (univ-object-type targ obj)
  ;;(pretty-print (list 'univ-object-type 'targ obj))
  'bignum);;;;;;;;;;;;;;;;;;;;;;;;;

;; ***** TARGET CODE EMITTERS

(define-macro (^ . forms)
  (if (null? forms)
      `'()
      `(list ,@forms)))

(define-macro (^expr-statement expr)
  `(univ-emit-expr-statement ctx ,expr))

(define (univ-emit-expr-statement ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php dart)
     (^ expr ";\n"))

    ((python ruby)
     (^ expr "\n"))

    (else
     (compiler-internal-error
      "univ-emit-expr-statement, unknown target"))))

(define-macro (^if test true #!optional (false #f))
  `(univ-emit-if ctx ,test ,true ,false))

(define (univ-emit-if ctx test true #!optional (false #f))
  (case (target-name (ctx-target ctx))

    ((js php dart)
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

(define-macro (^= expr1 expr2)
  `(univ-emit-= ctx ,expr1 ,expr2))

(define (univ-emit-= ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 " === " expr2))

    ((python ruby php dart)
     (^ expr1 " == " expr2))

    (else
     (compiler-internal-error
      "univ-emit-=, unknown target"))))

(define-macro (^!= expr1 expr2)
  `(univ-emit-!= ctx ,expr1 ,expr2))

(define (univ-emit-!= ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 " !== " expr2))

    ((python ruby php dart)
     (^ expr1 " != " expr2))

    (else
     (compiler-internal-error
      "univ-emit-!=, unknown target"))))

(define-macro (^< expr1 expr2)
  `(univ-emit-< ctx ,expr1 ,expr2))

(define (univ-emit-< ctx expr1 expr2)
  (univ-emit-comparison ctx " < " expr1 expr2))

(define-macro (^<= expr1 expr2)
  `(univ-emit-<= ctx ,expr1 ,expr2))

(define (univ-emit-<= ctx expr1 expr2)
  (univ-emit-comparison ctx " <= " expr1 expr2))

(define-macro (^> expr1 expr2)
  `(univ-emit-> ctx ,expr1 ,expr2))

(define (univ-emit-> ctx expr1 expr2)
  (univ-emit-comparison ctx " > " expr1 expr2))

(define-macro (^>= expr1 expr2)
  `(univ-emit->= ctx ,expr1 ,expr2))

(define (univ-emit->= ctx expr1 expr2)
  (univ-emit-comparison ctx " >= " expr1 expr2))

(define (univ-emit-comparison ctx comp expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js python ruby php dart)
     (^ expr1 comp expr2))

    (else
     (compiler-internal-error
      "univ-emit-comparison, unknown target"))))

(define-macro (^not expr)
  `(univ-emit-not ctx ,expr))

(define (univ-emit-not ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php dart)
     (^ "!" expr))

    ((python ruby)
     (^ "not " expr))

    (else
     (compiler-internal-error
      "univ-emit-not, unknown target"))))

(define-macro (^and expr1 expr2)
  `(univ-emit-and ctx ,expr1 ,expr2))

(define (univ-emit-and ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js ruby php dart)
     (^ expr1 " && " expr2))

    ((python)
     (^ expr1 " and " expr2))

    (else
     (compiler-internal-error
      "univ-emit-and, unknown target"))))

(define-macro (^or expr1 expr2)
  `(univ-emit-or ctx ,expr1 ,expr2))

(define (univ-emit-or ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js ruby php dart)
     (^ expr1 " || " expr2))

    ((python)
     (^ expr1 " or " expr2))

    (else
     (compiler-internal-error
      "univ-emit-or, unknown target"))))

(define-macro (^parens expr)
  `(univ-emit-parens ctx ,expr))

(define (univ-emit-parens ctx expr)
  (case (target-name (ctx-target ctx))

    ((js ruby php python dart)
     (^ "(" expr ")"))

    (else
     (compiler-internal-error
      "univ-emit-parens, unknown target"))))

(define-macro (^operand opnd)
  `(univ-emit-operand ctx ,opnd))

(define (univ-emit-operand ctx opnd)
  (translate-gvm-opnd ctx opnd)) ;; TODO: deprecate translate-gvm-opnd

(define-macro (^global-var name)
  `(univ-emit-global-var ctx ,name))

(define (univ-emit-global-var ctx name)
  (case (target-name (ctx-target ctx))

    ((js python php dart)
     name)

    ((ruby)
     (^ "$" name))

    (else
     (compiler-internal-error
      "univ-emit-global-var, unknown target"))))

(define-macro (^prefix name)
  `(univ-emit-prefix ctx ,name))

(define (univ-emit-prefix ctx name)
  (^ "Gambit_" name))

;; ***** DUMPING OF A COMPILATION MODULE

(define (univ-dump targ procs output c-intf script-line options)

  (call-with-output-file
      output
    (lambda (port)

      (univ-display
       (runtime-system (make-ctx targ #f))
       port)

      (univ-dump-procs targ procs port)

      (univ-display
       (entry-point (make-ctx targ #f) (list-ref procs 0))
       port)))

  #f)

(define (univ-dump-procs targ procs port)

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

      (define (scan-bbs bbs)
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

            (let ((id (lbl->id ctx (label-lbl-num gvm-instr) (ctx-ns ctx))))

              (^ "\n"
                 (univ-function

                  ctx

                  id

                  ""

                  (univ-indent
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
                                  "entry-point (+rest)\n"))
                                 
                             (^if (^not (^and
                                         (univ-call ctx
                                                    (^prefix "buildrest")
                                                    (label-entry-nb-parms gvm-instr))
                                         (^= (^global-var (^prefix "nargs"))
                                             (label-entry-nb-parms gvm-instr))))
                                  (univ-return-call ctx
                                                    (^prefix "wrong_nargs")
                                                    id))))
                      (^ " "
                         (univ-comment
                          ctx
                          (if (label-entry-closed? gvm-instr)
                              "closure-entry-point\n"
                              "entry-point\n"))
                         (^if (^!= (^global-var (^prefix "nargs"))
                                   (label-entry-nb-parms gvm-instr))
                              (univ-return-call ctx
                                                (^prefix "wrong_nargs")
                                                id))))

                     ((return)
                      (^ " " (univ-comment ctx "return-point\n")))

                     ((task-entry)
                      (^ " " (univ-comment ctx "task-entry-point\n")
                         (univ-throw ctx "\"task-entry-point GVM label unimplemented\"")))

                     ((task-return)
                      (^ " " (univ-comment ctx "task-return-point\n")
                         (univ-throw ctx "\"task-return-point GVM label unimplemented\"")))

                     (else
                      (compiler-internal-error
                       "scan-gvm-label, unknown label type"))))

                  (univ-indent
                   (with-stack-base-offset
                    ctx
                    (- (frame-size (gvm-instr-frame gvm-instr)))
                    (lambda (ctx)
                      (proc ctx)))))

                 (if (and (memq (label-type gvm-instr) '(entry return))
                          (eq? (target-name (ctx-target ctx)) 'js))
                     (^ id ".id = \"" id "\";\n")
                     (^))

                 (if (and (eq? (label-type gvm-instr) 'return)
                          (eq? (target-name (ctx-target ctx)) 'js))
                     (let ((info (frame-info gvm-instr)))
                       (^ id ".fs = " (vector-ref info 0) ";\n"
                          id ".link = " (+ (vector-ref info 1) 1) ";\n"))
                     (^)))))

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

                       (proc ctx opnds loc)))))

              ((copy)
               (let ((loc (copy-loc gvm-instr))
                     (opnd (copy-opnd gvm-instr)))
                 (if opnd
                     (univ-assign ctx
                                  (scan-gvm-opnd ctx loc)
                                  (scan-gvm-opnd ctx opnd))
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
                                        (univ-boolean ctx #f))
                                       (else
                                        (translate-gvm-opnd ctx opnd))))
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
                                                 (univ-assign
                                                  ctx
                                                  (univ-clo ctx (cdr loc-name) i)
                                                  (cdr (assv opnd loc-names)))
                                                 (^))
                                             rev-code)))
                               (^ (reverse rev-code)
                                  (init (cdr lst) loc-names)))))

                       (map
                        (lambda (loc-name)
                          (let* ((loc (car loc-name))
                                 (name (cdr loc-name)))
                            (univ-assign ctx
                                         (translate-gvm-opnd ctx loc)
                                         name)))
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

                       (^if (proc ctx opnds)
                            (jump-to-label ctx true fs)
                            (jump-to-label ctx false fs))))))

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
                            (univ-assign ctx (^global-var (^prefix "nargs")) nb-args)
                            (^))

                        (or (and (lbl? opnd)
                                 (not poll?)
                                 (jump-to-label ctx (lbl-num opnd) fs))

                            (with-stack-pointer-adjust
                             ctx
                             (+ fs
                                (ctx-stack-base-offset ctx))
                             (lambda (ctx)
                               (univ-return-poll
                                ctx
                                (scan-gvm-opnd ctx opnd)
                                poll?
                                (not (reg? opnd)))))))))) ;; avoid call optimization on JavaScript globals, because the underlying JavaScript VM uses a counterproductive speculative optimization (which slows down fib by a factor of 10!)

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
                      (univ-return-call ctx
                                        (scan-gvm-opnd ctx (make-lbl n))))))))

          (define (scan-gvm-opnd ctx gvm-opnd)
            (if (lbl? gvm-opnd)
                (todo-lbl-num! (lbl-num gvm-opnd)))
            (translate-gvm-opnd ctx gvm-opnd))

          (let ((ctx (make-ctx targ (proc-obj-name p))))
               
            (todo-lbl-num! (bbs-entry-lbl-num bbs))

            (let loop ((rev-res '()))
              (if (queue-empty? bb-todo)
                  (reverse rev-res)
                  (loop (cons (scan-bb ctx (queue-get! bb-todo))
                              rev-res)))))))

      (let ((ctx (make-ctx targ (proc-obj-name p))))
        (^ "\n"
           (univ-comment
            ctx
            (^ "-------------------------------- #<"
               (if (proc-obj-primitive? p)
                   "primitive"
                   "procedure")
               " "
               (object->string (string->canonical-symbol (proc-obj-name p)))
               "> =\n"))
           (let ((x (proc-obj-code p)))
             (if (bbs? x)
                 (scan-bbs x)
                 (^))))))

    (for-each scan-obj procs)

    (let loop ((rev-res '()))
      (if (queue-empty? proc-left)

          (univ-display
           (reverse (append rev-res *literals*))
           port)

          (loop (cons (dump-proc (queue-get! proc-left))
                      rev-res))))))

(define closure-count 0)

#;
(define (univ-closure-alloc ctx lbl nb-closed-vars cont)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (set! closure-count (+ closure-count 1))
     (let ((name (string-append "closure" (number->string closure-count))))
       (^ (univ-function
           ctx
           name
           ""
           "\n"
           (univ-indent
            (^ (univ-assign ctx
                            (translate-gvm-opnd ctx (make-reg (+ univ-nb-arg-regs 1)))
                            name)
               (univ-return-call ctx (translate-lbl ctx (make-lbl lbl))))))
          (cont name))))

    (else
     (compiler-internal-error
      "univ-closure-alloc, unknown target"))))

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
  (case (target-name (ctx-target ctx))

    ((js)
     (set! closure-count (+ closure-count 1))
     (let ((name (string-append "closure" (number->string closure-count))))
       (^ "var " name " = closure_alloc({"
          (univ-separated-list
           ","
           (univ-map-index (lambda (x i) (^ "v" i ":" x))
                           (cons (translate-lbl ctx (make-lbl lbl))
                                 exprs)))
          "});\n"
          (cont name))))

    (else
     (compiler-internal-error
      "univ-closure-alloc, unknown target"))))

(define (make-ctx target ns)
  (vector target ns 0 univ-enable-jump-destination-inlining?))

(define (ctx-target ctx)                   (vector-ref ctx 0))
(define (ctx-target-set! ctx x)            (vector-set! ctx 0 x))

(define (ctx-ns ctx)                       (vector-ref ctx 1))
(define (ctx-ns-set! ctx x)                (vector-set! ctx 1 x))

(define (ctx-stack-base-offset ctx)        (vector-ref ctx 2))
(define (ctx-stack-base-offset-set! ctx x) (vector-set! ctx 2 x))

(define (ctx-allow-jump-destination-inlining? ctx)        (vector-ref ctx 3))
(define (ctx-allow-jump-destination-inlining?-set! ctx x) (vector-set! ctx 3 x))

(define (with-stack-base-offset ctx n proc)
  (let ((save (ctx-stack-base-offset ctx)))
    (ctx-stack-base-offset-set! ctx n)
    (let ((result (proc ctx)))
      (ctx-stack-base-offset-set! ctx save)
      result)))

(define (with-stack-pointer-adjust ctx n proc)
  (^ (if (= n 0)
         (^)
         (univ-increment ctx (^global-var (^prefix "sp")) n))
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

(define (translate-gvm-opnd ctx gvm-opnd)

  (cond ((not gvm-opnd)
         (^ "NO_OPERAND"))

        ((reg? gvm-opnd)
         #;
         (^ (^global-var (^prefix "r"))
            "["
            (reg-num gvm-opnd)
            "]")
         (^ (^global-var (^prefix "r"))
            (reg-num gvm-opnd)))

        ((stk? gvm-opnd)
         (let ((n (+ (stk-num gvm-opnd) (ctx-stack-base-offset ctx))))
           (^ (^global-var (^prefix "stack"))
              "["
              (^global-var (^prefix "sp"))
              (cond ((= n 0)
                     (^))
                    ((< n 0)
                     (^ n))
                    (else
                     (^ "+" n)))
              "]")))

        ((glo? gvm-opnd)
         (univ-glo ctx
                   (glo-name gvm-opnd)))

        ((clo? gvm-opnd)
         (univ-clo ctx
                   (translate-gvm-opnd ctx (clo-base gvm-opnd))
                   (clo-index gvm-opnd)))

        ((lbl? gvm-opnd)
         (translate-lbl ctx gvm-opnd))

        ((obj? gvm-opnd)
         (translate-obj ctx (obj-val gvm-opnd)))

        (else
         (compiler-internal-error
          "translate-gvm-opnd, unknown 'gvm-opnd':"
          gvm-opnd))))

(define (univ-clo ctx closure index)
  (^ closure
     "(false).v"
     index))

(define (univ-glo ctx name)
  (^ (^global-var (^prefix "glo"))
     "["
     (object->string (symbol->string name))
     "]"))

(define (translate-obj ctx obj)
  
  (cond ((boolean? obj)
         (univ-boolean ctx obj))
        
        ((number? obj)
         (univ-number ctx obj))

        ((char? obj)
         (univ-literal ctx char-literal-type obj))
        
        ((string? obj)
         (univ-literal ctx string-literal-type obj))

        ((null? obj)
         (univ-null ctx))

        ((void-object? obj)
         (^ "undefined"))

        ((undefined? obj)
         (univ-undefined ctx))
        
        ((proc-obj? obj)
         (lbl->id ctx 1 (proc-obj-name obj)))

        ;; ((list? obj)
        ;;  (univ-literal ctx list-literal-type obj))

        ((pair? obj)
         (univ-literal ctx pair-literal-type obj))

        ((vector? obj)
         (univ-literal ctx vector-literal-type obj))

        ((symbol? obj)
         (univ-symbol ctx obj))
        
        (else
         (^ "UNIMPLEMENTED_OBJECT("
            (object->string obj)
            ")"))))

;;==================================================================
;; ((loc_0 literal_0) (loc_0 literal_1))
(define *literals* '())
(define literal-tag (gensym))
(define literal-len 4)

(define tag-index  0)
(define type-index 1)
(define obj-index  2)
(define ctx-index  3)

(define (literal-get-tag    lit)      (vector-ref lit tag-index))
(define (literal-get-type   lit)      (vector-ref lit type-index))
(define (literal-get-obj    lit)      (vector-ref lit obj-index))
(define (literal-get-ctx    lit)      (vector-ref lit ctx-index))
(define (literal-set-tag!   lit tag)  (vector-set! lit tag-index  tag))
(define (literal-set-type!  lit type) (vector-set! lit type-index type))
(define (literal-set-obj!   lit obj)  (vector-set! lit obj-index  obj))
(define (literal-set-ctx!   lit ctx)  (vector-set! lit ctx-index  ctx))

(define vector-literal-type 0)
(define pair-literal-type   1)
(define string-literal-type 2)
(define char-literal-type   3)

(define make-loc-literal list)
(define get-loc car)
(define get-literal cadr)

(define (make-literal ctx type obj)
  (let ((v (make-vector literal-len)))
    (literal-set-tag!  v literal-tag)
    (literal-set-type! v type)
    (literal-set-obj!  v obj)
    (literal-set-ctx!  v ctx)
    v))

(define (univ-literal ctx type obj)
  (let* ((sym (gensym))
         (loc (^ (^global-var (^prefix "glo"))
                 "[" (object->string (symbol->string sym)) "]"))
         (expr (if (= type vector-literal-type)
                     (univ-vector ctx obj)
                     (if (= type pair-literal-type)
                         (univ-pair ctx obj)
                         (if (= type string-literal-type)
                             (univ-string ctx obj)
                             (if (= type char-literal-type)
                                 (univ-char ctx obj)
                                 (^ "UNIMPLEMENTED_LITERAL_OBJECT("
                                    (object->string obj)
                                    ")")))))))

    (set! *literals* (cons (^ (univ-assign ctx loc expr))
                          *literals*))
    
    ;; (add-literal! )    
    ;; (add-literal! loc type obj ctx)
    
    ;; (if (= type pair-literal-type)
    ;;     (for-each (lambda (obj) (translate-obj ctx obj)) obj))

    ;; (if (= type vector-literal-type)
    ;;     (do ((i 0 (+ i 1))) (< i (vector-length obj))
    ;;       (translate-obj ctx (vector-ref obj i))
    ;;       #f))
    
    (case (target-name (ctx-target ctx))

      ((js)
       (^ loc))

      ((python ruby php)
       (^));;FIXME

      (else
       (compiler-internal-error
        "univ-literal, unknown target")))))

;; (define (gen-literals literals done)
;; (define (gen-literals done)  

;;   (define (gen-literal loc-literal)
;;     (let* ((literal (get-literal loc-literal))
;;            (loc (get-loc loc-literal))
;;            (ctx (literal-get-ctx literal))
;;            (obj (literal-get-obj literal))
;;            (type (literal-get-type literal))
;;            )

;;            ;; (expr (univ-string ctx obj)))
;;            ;; (expr (case (literal-get-type literal)
;;            ;;         ((vector-literal-type)
;;            ;;          (univ-vector ctx obj))

;;            ;;         ((list-literal-type)
;;            ;;          (univ-list ctx obj))

;;            ;;         ((string-literal-type)
;;            ;;          (univ-string ctx obj))

;;            ;;         ((char-literal-type)
;;            ;;          (univ-char ctx obj))

;;            ;;         (else
;;            ;;          (^ "UNIMPLEMENTED_LITERAL_OBJECT("
;;            ;;             (object->string obj)
;;            ;;             ")"))))
;;       (univ-assign ctx loc expr)))

;;   (if (null? *literals*)
;;       done
;;       (let ((loc-lit (car *literals*)))
;;         (set! *literals* (cdr *literals*))
;;         (gen-literals (cons (gen-literal loc-lit)
;;                             done)))))
      ;; (gen-literals (cdr literals)
      ;;               (cons (gen-literal (car literals))
      ;;                     done))))

(define (literal? obj)
  (and (vector? obj)
       (= (vector-length obj) literal-len)
       (eq? (literal-get-tag obj) literal-tag)))

(define (vector-literal? ctx obj)
  (and (literal? obj)
       (= (literal-get-type obj) vector-literal-type)))

(define (pair-literal? ctx obj)
  (and (literal? obj)
       (= (literal-get-type obj) pair-literal-type)))

(define (string-literal? ctx obj)
  (and (literal? obj)
       (= (literal-get-type obj) string-literal-type)))

(define (char-literal? ctx obj)
  (and (literal? obj)
       (= (literal-get-type obj) char-literal-type)))

;; =============================================================================

(define (translate-lbl ctx lbl)
  (lbl->id ctx (lbl-num lbl) (ctx-ns ctx)))

(define (lbl->id ctx num ns)
  (^global-var (^prefix (^ "bb" num "_" (scheme-id->c-id ns)))))

(define (runtime-system ctx)
  (case (target-name (ctx-target ctx))

    ((js)                               ;rts js
     (let ((R0 (translate-gvm-opnd ctx (make-reg 0)))
           (R1 (translate-gvm-opnd ctx (make-reg 1)))
           (R2 (translate-gvm-opnd ctx (make-reg 2)))
           (R3 (translate-gvm-opnd ctx (make-reg 3)))
           (R4 (translate-gvm-opnd ctx (make-reg 4))))
       (^ "
function Gambit_heapify(ra) {

  if (Gambit_sp > 0) { // stack contains at least one frame

    var fs = ra.fs, link = ra.link;
    var chain = Gambit_stack;

    if (Gambit_sp > fs) { // stack contains at least two frames
      chain = Gambit_stack.slice(Gambit_sp - fs, Gambit_sp + 1);
      chain[0] = ra;
      Gambit_sp = Gambit_sp - fs;
      var prev_frame = chain, prev_link = link;
      ra = prev_frame[prev_link]; fs = ra.fs; link = ra.link;

      while (Gambit_sp > fs) {
        var frame = Gambit_stack.slice(Gambit_sp - fs, Gambit_sp + 1);
        frame[0] = ra;
        Gambit_sp = Gambit_sp - fs;
        prev_frame[prev_link] = frame;
        prev_frame = frame; prev_link = link;
        ra = prev_frame[prev_link]; fs = ra.fs; link = ra.link;
      }

      prev_frame[prev_link] = Gambit_stack;
    }

    Gambit_stack.length = fs + 1;
    Gambit_stack[link] = Gambit_stack[0];
    Gambit_stack[0] = ra;
  
    Gambit_stack = [chain];
    Gambit_sp = 0;
  }

  return Gambit_underflow;
}

function Gambit_underflow() {

  var frame = Gambit_stack[0];

  if (frame === false) // end of continuation?
    return false; // terminate trampoline

  var ra = frame[0], fs = ra.fs, link = ra.link;
  Gambit_stack = frame.slice(0, fs + 1);
  Gambit_sp = fs;
  Gambit_stack[0] = frame[link];
  Gambit_stack[link] = Gambit_underflow;

  return ra;
}
Gambit_underflow.fs = 0;

var Gambit_glo = {};
var " R0 " = Gambit_underflow;
var " R1 " = false;
var " R2 " = false;
var " R3 " = false;
var " R4 " = false;
var Gambit_stack = [];
var Gambit_sp = 0;
var Gambit_nargs = 0;
var Gambit_temp1 = false;
var Gambit_temp2 = false;
var Gambit_poll;
var Gambit_printout;

Gambit_stack[0] = false;

var Gambit_poll_count = 1;

//if (this.hasOwnProperty('setTimeout')) {
//  Gambit_poll = function (dest) {
//                  Gambit_poll_count = 100;
//                  Gambit_stack.length = Gambit_sp + 1;
//                  setTimeout(function () { Gambit_trampoline(dest); }, 1);
//                  return false;
//                };
//} else {
  Gambit_poll = function (dest) {
                  Gambit_poll_count = 100;
                  Gambit_stack.length = Gambit_sp + 1;
                  return dest;
                };
//}

var iobuffer = \"\";

function Gambit_printout(text) {
  if (text === \"\\n\") {
    print(iobuffer);
    iobuffer = \"\";
  } else {
    iobuffer += text;
  }
//  if (text === \"\\n\")
//    document.write(\"<br/>\");
//  else
//    document.write(text);
}

function Gambit_buildrest ( f ) {    // nb formal args
                                     // *** assume (= univ-nb-arg-regs 3) for now ***    
    var nb_static_args = f - 1;
    var nb_rest_args = Gambit_nargs - nb_static_args;    
    var rest = null;
    var Gambit_reg = [];
    Gambit_reg[1] = " R1 ";
    Gambit_reg[2] = " R2 ";
    Gambit_reg[3] = " R3 ";


    if (Gambit_nargs < nb_static_args)  // Wrong number of args
        return false;

    // simple case, all in reg
    if ((Gambit_nargs <= 3) && (nb_static_args < 3)) {
        for (var i = nb_static_args + 1; i < nb_static_args + nb_rest_args + 1; i++) {
            rest = Gambit_cons(Gambit_reg[i], rest);
        }

        Gambit_reg[nb_static_args + 1] = rest;
        Gambit_nargs -= (nb_rest_args - 1);
        
        " R1 " = Gambit_reg[1];
        " R2 " = Gambit_reg[2];
        " R3 " = Gambit_reg[3];
        
        return true;
    }

    // rest is empty
    if ((Gambit_nargs >= 3) && (nb_rest_args === 0)) { // only append '()
        var spill_loc = nb_static_args - 2;        // univ-nb-arg-regs - 1
        Gambit_sp += 1;
        Gambit_stack[Gambit_sp] = Gambit_reg[1];
        Gambit_reg[1] = Gambit_reg[2];
        Gambit_reg[2] = Gambit_reg[3];
        Gambit_reg[3] = null;
        Gambit_nargs += 1;
        
        " R1 " = Gambit_reg[1];
        " R2 " = Gambit_reg[2];
        " R3 " = Gambit_reg[3];
        
        return true;
    }

    // general case
    for (var i = 1; i <= 3; i++) {
        Gambit_stack[Gambit_sp + i] = Gambit_reg[i];
    }
    Gambit_sp += 3;
    for (var i = 0; i < nb_rest_args; i++) {
        rest = Gambit_cons(Gambit_stack[Gambit_sp - i], rest);
    }
    Gambit_sp -= nb_rest_args;
    Gambit_stack[Gambit_sp + 1] = rest;
    Gambit_sp += 1;

    switch (nb_static_args) {
    case 0:
        Gambit_reg[1] = Gambit_stack[Gambit_sp];
        Gambit_sp -= 1;
        break;
    case 1:
        Gambit_reg[2] = Gambit_stack[Gambit_sp];
        Gambit_reg[1] = Gambit_stack[Gambit_sp - 1];
        Gambit_sp -= 2;
        break;
    default:
        for (var i = 3; i > 0; i--) {
            Gambit_reg[i] = Gambit_stack[Gambit_sp - 3 + i];
        }
        Gambit_sp -= 3;
        break;
    }
    Gambit_nargs = f;

    " R1 " = Gambit_reg[1];
    " R2 " = Gambit_reg[2];
    " R3 " = Gambit_reg[3];
        
    return true;
}         

function Gambit_wrong_nargs(fn) {
    Gambit_printout(\"*** wrong number of arguments (\"+Gambit_nargs+\") when calling\");
    Gambit_printout(fn);
    return false;
}

function closure_alloc(slots) {

  function self(msg) {
    if (msg === false) return slots;
    " R4 " = self;
    return slots.v0;
  }

  return self;
}

// Flonum
function Gambit_Flonum(val) {
    this.val = val;
}

Gambit_Flonum.prototype.toString = function ( ) {
    if (parseFloat(this.val) == parseInt(this.val)) {
        return this.val + \".\";
    } else {
        return this.val;
    }
}

// Pair, List
function Gambit_Pair ( car, cdr ) {
    this.car = car;
    this.cdr = cdr;
}

function Gambit_pairp ( p ) {
    return (p instanceof Gambit_Pair);
}

Gambit_Pair.prototype.toString = function ( ) {
    return Gambit_write(this);
//    return (\"(\" + Gambit_println(this.car) + \" . \" +  Gambit_println(this.cdr) + \")\");
}

Gambit_Pair.prototype.println = function ( ) {
    return Gambit_println(this.car) + Gambit_println(this.cdr);
}

function Gambit_nullp ( o ) {
    return o === null;
}

// cons
function Gambit_cons ( a, b ) {
    return new Gambit_Pair(a, b);
}

// car
function Gambit_car ( p ) {
    return p.car;
}

// cdr
function Gambit_cdr ( p ) {
    return p.cdr;
}

// caar
function Gambit_caar ( p ) {
    return p.car.car;
}

// cadr
function Gambit_cadr ( p ) {
    return p.cdr.car;
}

// cdar
function Gambit_cdar ( p ) {
    return p.car.cdr;
}

// cddr
function Gambit_cddr ( p ) {
    return p.cdr.cdr;
}

// caaar
function Gambit_caaar ( p ) {
    return p.car.car.car;
}

// caadr
function Gambit_caadr ( p ) {
    return p.cdr.car.car;
}

// cadar
function Gambit_cadar ( p ) {
    return p.car.cdr.car;
}

// caddr
function Gambit_caddr ( p ) {
    return p.cdr.cdr.car;
}

// cdaar
function Gambit_cdaar ( p ) {
    return p.car.car.cdr;
}

// cdadr
function Gambit_cdadr ( p ) {
    return p.cdr.car.cdr;
}

// cddar
function Gambit_cddar ( p ) {
    return p.car.cdr.cdr;
}

// cdddr
function Gambit_cdddr ( p ) {
    return p.cdr.cdr.cdr;
}

// caaaar
function Gambit_caaaar ( p ) {
    return p.car.car.car.car;
}

// caaadr
function Gambit_caaadr ( p ) {
    return p.cdr.car.car.car;
}

// caadar
function Gambit_caadar ( p ) {
    return p.car.cdr.car.car;
}

// caaddr
function Gambit_caaddr ( p ) {
    return p.cdr.cdr.car.car;
}

// cadaar
function Gambit_cadaar ( p ) {
    return p.car.car.cdr.car;
}

// cadadr
function Gambit_cadadr ( p ) {
    return p.cdr.car.cdr.car;
}

// caddar
function Gambit_caddar ( p ) {
    return p.car.cdr.cdr.car;
}

// cadddr
function Gambit_cadddr ( p ) {
    return p.cdr.cdr.cdr.car;
}

// cdaaar
function Gambit_cdaaar ( p ) {
    return p.car.car.car.cdr;
}

// cdaadr
function Gambit_cdaadr ( p ) {
    return p.cdr.car.car.cdr;
}

// cdadar
function Gambit_cdadar ( p ) {
    return p.car.cdr.car.cdr;
}

// cdaddr
function Gambit_cdaddr ( p ) {
    return p.cdr.cdr.car.cdr;
}

// cddaar
function Gambit_cddaar ( p ) {
    return p.car.car.cdr.cdr;
}

// cddadr
function Gambit_cddadr ( p ) {
    return p.cdr.car.cdr.cdr;
}

// cdddar
function Gambit_cdddar ( p ) {
    return p.car.cdr.cdr.cdr;
}

// cddddr
function Gambit_cddddr ( p ) {
    return p.cdr.cdr.cdr.cdr;
}

// set-car!
function Gambit_setcar ( p, a ) {
    p.car = a;
}

// set-cdr!
function Gambit_setcdr ( p, b ) {
    p.cdr = b;
}


Gambit_list = function ( ) {
    var listaux = function (a, n, lst) {
        if (n === 0) {
            return Gambit_cons(a[0], lst);
        } else {
            return listaux(a, n-1, Gambit_cons(a[n], lst));
        }
    }

//    var res = listaux(arguments, arguments.length - 1, null);
    
    return listaux(arguments, arguments.length - 1, null);
}

Gambit_length = function ( h ) {
    var len = 0;
//    var h = this;

    while (h !== null) {
        len += 1;
        h = h.cdr;
    }

    return len;
}


// Char
var Gambit_chars = {}
function Gambit_Char(charcode) {
    this.charcode = charcode;
}

Gambit_Char.fxToChar = function ( charcode ) {
    var ch = Gambit_chars[charcode];

    if (!ch) {
        Gambit_chars[charcode] = new Gambit_Char(charcode);
        ch = Gambit_chars[charcode];
    }
    
    return ch;
}

Gambit_Char.charToFx = function ( c ) {
    return c.charcode;
}

Gambit_Char.prototype.toString = function ( ) {
    return \"#\\\\\"  + String.fromCharCode(this.charcode);
}

Gambit_Char.prototype.print = function ( ) {
    return String.fromCharCode(this.charcode);
}

// String
var Gambit_String = function ( ) {
    this.chars = new Array(arguments.length);
    for (i = 0; i < arguments.length; i++) {
        this.chars[i] = arguments[i];
    }
}

Gambit_String.makestring = function ( n, ch ) {
    var s = new Gambit_String();
    for (i = 0; i < n; i++) {
        s.chars[i] = ch;
    }

    return s;
}

Gambit_String.listToString = function ( lst ) {
    var len = Gambit_length(lst);
    var s = Gambit_String.makestring(len);
    var h = lst;
    for (i = 0; i < len; i++) {
        s.chars[i] = h.car;
        h = h.cdr;
    }

    return s;
}

Gambit_String.stringToList = function ( s ) {
    var len = s.stringlength();

    var listaux = function (a, n, lst) {
        if (n === 0) {
            return Gambit_cons(a[0], lst);
        } else {
            return listaux(a, n-1, Gambit_cons(a[n], lst));
        }
    }
    
    return listaux(s.chars, len - 1, null);    
}

Gambit_String.jsstringToString = function ( s ) {
    var len = s.length;
    var s2 = Gambit_String.makestring(len, Gambit_Char.fxToChar(0));
    for (i = 0; i < len; i++) {
        s2.chars[i] = Gambit_Char.fxToChar(s.charCodeAt(i));
    }

    return s2;
}

Gambit_String.prototype.stringlength = function ( ) {
    return this.chars.length;
}

// string-ref
Gambit_String.prototype.stringref = function ( n ) {
    return this.chars[n];
}

// string-set!
Gambit_String.prototype.stringset = function ( n, ch ) {  // ch: Char
    this.chars[n] = ch;
}

Gambit_String.prototype.toString = function ( ) {
    var s = \"\\\"\";
    for (i = 0; i < this.stringlength(); i++) {
        s = s.concat(this.stringref(i).print());
    }
    s += \"\\\"\"

    return s;
}

Gambit_String.prototype.print = function ( ) {
    var s = \"\";
    for (i = 0; i < this.stringlength(); i++) {
        s = s.concat(this.stringref(i).print());
    }

    return s;
}

var Gambit_stringappend = function ( ) {
    var totallen = 0;
    var lens = [];

    for (i = 0; i < arguments.length; i++) {
        lens[i] = arguments[i].stringlength();
        totallen += lens[i];
    }

    var s = Gambit_String.makestring(totallen);
    var partlen = 0;
    for (i = 0; i < lens.length; i++) {
        var len = lens[i];
        for (j = 0; j < len; j++) {
            s.stringset(partlen + j, arguments[i].stringref(j));
        }
        partlen += len;
    }

    return s;
}
" (univ-glo ctx 'string-append) " = Gambit_stringappend;

// Vector
var Gambit_Vector = function ( ) {
    this.a = new Array(arguments.length);
    for (i = 0; i < arguments.length; i++) {
        this.a[i] = arguments[i];
    }
}

// make-vector
Gambit_Vector.makevector = function ( n, val ) {
    var v = new Gambit_Vector();

    for (var i = 0; i < n; i++) {
        v.a[i] = val;
    }

    return v;
}

// vector-length
Gambit_Vector.prototype.vectorlength = function ( ) {
    return this.a.length;
}

// vector-ref
Gambit_Vector.prototype.vectorref = function ( n ) {
    return this.a[n];
}

// vector-set!
Gambit_Vector.prototype.vectorset = function ( n, v ) {
    this.a[n] = v;
}

Gambit_Vector.prototype.toString = function ( ) {
    var res = \"#(\";

    if (this.vectorlength() > 0) {
        res += Gambit_toString(this.a[0]);
    }

    for (var i = 1; i<this.a.length; i++) {
        res += \", \";
        res += Gambit_toString(this.a[i]);
    }
    res += \")\"
    return res;
}

Gambit_Vector.prototype.println = function ( ) {
    var res = \"\";
    for (var i = 0; i<this.a.length; i++) {
        res += Gambit_println(this.a[i]);
    }

    return res;
}

// Symbol
var Gambit_syms = {};
function Gambit_Symbol(s) {
    this.symbolToString = function ( ) { return s; }
    this.toString = function ( ) { return s; }
}

Gambit_Symbol.stringToSymbol = function ( s ) {
    var sym = Gambit_syms[s];
    
    if (!sym) {
        Gambit_syms[s] = new Gambit_Symbol(s);
        sym = Gambit_syms[s];
    }
    
    return sym;
}

var Gambit_kwds = {};
function Gambit_Keyword(s) {
    s = s + \":\";

    this.keywordToString = function( ) { return s.substring(0, s.length-1); }
    this.toString = function( ) { return s; }
}

Gambit_Keyword.stringToKeyword = function(s) {
    var kwd = Gambit_kwds[s];
    
    if (!kwd) {
        Gambit_kwds[s] = new Gambit_Keyword(s);
        kwd = Gambit_kwds[s];
    }
    
    return kwd;
}

// Primitives

function Gambit_write ( obj ) {
    if (obj === false)
        Gambit_printout(\"#f\");
    else if (obj === true)
        Gambit_printout(\"#t\");
    else if (obj === null)
        Gambit_printout(\"()\");
    else if (obj instanceof Gambit_Flonum)
        Gambit_printout(obj.toString());
    else if (obj instanceof Gambit_String)
        Gambit_printout(\"\\\"\" + obj.toString() + \"\\\"\");
    else if (obj instanceof Gambit_Char)
        Gambit_printout(obj.toString());
    else if (obj instanceof Gambit_Pair) {
        Gambit_printout(\"(\");
        Gambit_write(obj.car);
        Gambit_writelist(obj.cdr);
    }
    else if (obj instanceof Array)
        Gambit_printout(obj.toString());
    else if (obj instanceof Gambit_Symbol)
        Gambit_printout(obj.symbolToString());
    else if (obj instanceof Gambit_Keyword)
        Gambit_printout(obj.keywordToString());
    else
        Gambit_printout(obj);
}

function Gambit_bb1_write ( ) { // write
    if (Gambit_nargs !== 1) {
        return Gambit_wrong_nargs(Gambit_bb1_write);
    }

    Gambit_write(Gambit_reg1);
    
    return Gambit_reg0;
}

" (univ-glo ctx 'write) " = Gambit_bb1_write;

function Gambit_writelist ( obj ) {
    if (obj === null) {
        Gambit_printout(\")\");
    } else {
        if (obj instanceof Gambit_Pair) {
            Gambit_printout(\" \");
            Gambit_write(obj.car);
            Gambit_writelist(obj.cdr);
        } else {
            Gambit_printout(\" . \");
            Gambit_write(obj);
            Gambit_printout(\")\");
        }
    }
}

function Gambit_bb1_writelist ( ) { // write-list
    if (Gambit_nargs !== 1) {
        return Gambit_wrong_nargs(Gambit_bb1_writelist);
    }

    Gambit_writelist(Gambit_reg1);
    
    return Gambit_reg0;
}

" (univ-glo ctx 'write-list) " = Gambit_bb1_writelist;

function Gambit_print ( obj ) {
    if (obj === false)
        Gambit_printout(\"#f\");
    else if (obj === true)
        Gambit_printout(\"#t\");
    else if (obj === null)
        Gambit_printout(\"\");
    else if (obj instanceof Gambit_Flonum)
        Gambit_printout(obj.toString());
    else if (obj instanceof Gambit_String)
        Gambit_printout(obj.print());
    else if (obj instanceof Gambit_Char)
        Gambit_printout(obj.print());
    else if (obj instanceof Gambit_Pair) {
        Gambit_print(obj.car);
        Gambit_print(obj.cdr);
    }
    else if (obj instanceof Array) {
        for (i = 0; i < obj.length; i++) {
            Gambit_print(obj[i]);
        }
    }
    else if (obj instanceof Gambit_Symbol)
        Gambit_printout(obj.symbolToString());
    else if (obj instanceof Gambit_Keyword)
        Gambit_printout(obj.keywordToString());
    else
        Gambit_printout(obj);
}

function Gambit_bb1_print ( ) { // print
    if (Gambit_nargs !== 1) {
        return Gambit_wrong_nargs(Gambit_bb1_print);
    }

    Gambit_print(" R1 ");
    
    return " R0 ";
}

" (univ-glo ctx 'print) " = Gambit_bb1_print;

function Gambit_println ( obj ) {
    Gambit_print(obj);
    Gambit_printout(\"\\n\");
}

function Gambit_bb1_println ( ) { // println
    if (Gambit_nargs !== 1) {
        return Gambit_wrong_nargs(Gambit_bb1_println);
    }

    Gambit_println(" R1 ");
    
    return " R0 ";
}

" (univ-glo ctx 'println) " = Gambit_bb1_println;

function Gambit_bb1_newline ( ) { // newline
    if (Gambit_nargs !== 0) {
        return Gambit_wrong_nargs(Gambit_bb1_newline);
    }

    Gambit_printout(\"\\n\");
    
    return " R0 ";
}

" (univ-glo ctx 'newline) " = Gambit_bb1_newline;

function Gambit_bb1_display ( ) { // display
    if (Gambit_nargs !== 1) {
        return Gambit_wrong_nargs(Gambit_bb1_display);
    }

    Gambit_write(" R1 ");
    
    return " R0 ";
}

" (univ-glo ctx 'display) " = Gambit_bb1_display;

function Gambit_bb1_prettyprint ( ) { // prettyprint
    if (Gambit_nargs !== 1) {
        return Gambit_wrong_nargs(Gambit_bb1_prettyprint);
    }

    Gambit_write(" R1 ");
    Gambit_printout(\"\\n\");
    
    return " R0 ";
}

" (univ-glo ctx 'prettyprint) " = Gambit_bb1_prettyprint;

function Gambit_bb1_pp ( ) { // pp
    if (Gambit_nargs !== 1) {
        return Gambit_wrong_nargs(Gambit_bb1_pp);
    }

    Gambit_write(" R1 ");
    Gambit_printout(\"\\n\");
    
    return " R0 ";
}

" (univ-glo ctx 'pp) " = Gambit_bb1_pp;

function Gambit_bb1_real_2d_time_2d_milliseconds ( ) { // real-time-milliseconds
    if (Gambit_nargs !== 0) {
        return Gambit_wrong_nargs(Gambit_bb1_display);
    }

    " R1 " = new Date();
    
    return " R0 ";
}

" (univ-glo ctx 'real-time-milliseconds) " = Gambit_bb1_real_2d_time_2d_milliseconds;


// Continuations
function Gambit_Continuation(frame, denv) {
    this.frame = frame;
    this.denv = denv;
}


// Obsolete
function Gambit_dump_cont(sp, ra) {
    Gambit_printout(\"------------------------\");
    while (ra !== false) {
        Gambit_printout(\"sp=\"+Gambit_sp + \" fs=\"+ra.fs + \" link=\"+ra.link);
        Gambit_sp = Gambit_sp-ra.fs;
        ra = Gambit_stack[Gambit_sp+ra.link+1];
    }
    Gambit_printout(\"------------------------\");
}

function Gambit_continuation_capture1() {
  var receiver = " R1 ";
  " R0 " = Gambit_heapify(" R0 ");
  " R1 " = new Gambit_Continuation(Gambit_stack[0], false);
  Gambit_nargs = 1;
  return receiver;
}

function Gambit_continuation_capture2() {
  var receiver = " R1 ";
  " R0 " = Gambit_heapify(" R0 ");
  " R1 " = new Gambit_Continuation(Gambit_stack[0], false);
  Gambit_nargs = 2;
  return receiver;
}

function Gambit_continuation_capture3() {
  var receiver = " R1 ";
  " R0 " = Gambit_heapify(" R0 ");
  " R1 " = new Gambit_Continuation(Gambit_stack[0], false);
  Gambit_nargs = 3;
  return receiver;
}

function Gambit_continuation_capture4() {
  var receiver = Gambit_stack[Gambit_sp--];
  " R0 " = Gambit_heapify(" R0 ");
  Gambit_stack[++Gambit_sp] = new Gambit_Continuation(Gambit_stack[0], false);
  Gambit_nargs = 4;
  return receiver;
}

function Gambit_continuation_graft_no_winding2() {
  var proc = " R2 ";
  var cont = " R1 ";
  Gambit_sp = 0;
  Gambit_stack[0] = cont.frame;
  " R0 " = Gambit_underflow;
  Gambit_nargs = 0;
  return proc;
}

function Gambit_continuation_graft_no_winding3() {
  var proc = " R2 ";
  var cont = " R1 ";
  Gambit_sp = 0;
  Gambit_stack[0] = cont.frame;
  " R0 " = Gambit_underflow;
  " R1 " = " R3 ";
  Gambit_nargs = 1;
  return proc;
}

function Gambit_continuation_graft_no_winding4() {
  var proc = " R1 ";
  var cont = Gambit_stack[Gambit_sp];
  Gambit_sp = 0;
  Gambit_stack[0] = cont.frame;
  " R0 " = Gambit_underflow;
  " R1 " = " R2 ";
  " R2 " = " R3 ";
  Gambit_nargs = 2;
  return proc;
}

function Gambit_continuation_graft_no_winding5() {
  var proc = Gambit_stack[Gambit_sp];
  var cont = Gambit_stack[Gambit_sp-1];
  Gambit_sp = 0;
  Gambit_stack[0] = cont.frame;
  " R0 " = Gambit_underflow;
  Gambit_nargs = 3;
  return proc;
}

function Gambit_continuation_return_no_winding2() {
  var cont = " R1 ";
  Gambit_sp = 0;
  Gambit_stack[0] = cont.frame;
  " R0 " = Gambit_underflow;
  " R1 " = " R2 ";
  return " R0 ";
}

function Gambit_bb1__23__23_continuation_3f_() { // ##continuation?
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_3f_);
  }
  " R1 " = " R1 " instanceof Gambit_Continuation;
  return " R0 ";
}

" (univ-glo ctx '##continuation?) " = Gambit_bb1__23__23_continuation_3f_;


function Gambit_bb1__23__23_continuation_2d_frame() { // ##continuation-frame
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_frame);
  }
  " R1 " = " R1 ".frame;
  return " R0 ";
}

" (univ-glo ctx '##continuation-frame) " = Gambit_bb1__23__23_continuation_2d_frame;


function Gambit_bb1__23__23_continuation_2d_denv() { // ##continuation-denv
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_denv);
  }
  " R1 " = " R1 ".denv;
  return " R0 ";
}

" (univ-glo ctx '##continuation-denv) " = Gambit_bb1__23__23_continuation_2d_denv;


function Gambit_bb1__23__23_continuation_2d_fs() { // ##continuation-fs
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_fs);
  }
  " R1 " = " R1 ".frame[0].fs;
  return " R0 ";
}

" (univ-glo ctx '##continuation-fs) " = Gambit_bb1__23__23_continuation_2d_fs;


function Gambit_bb1__23__23_frame_2d_fs() { // ##frame-fs
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_frame_2d_fs);
  }
  " R1 " = " R1 "[0].fs;
  return " R0 ";
}

" (univ-glo ctx '##frame-fs) " = Gambit_bb1__23__23_frame_2d_fs;


function Gambit_bb1__23__23_return_2d_fs() { // ##return-fs
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_return_2d_fs);
  }
  " R1 " = " R1 ".fs;
  return " R0 ";
}

" (univ-glo ctx '##return-fs) " = Gambit_bb1__23__23_return_2d_fs;


function Gambit_bb1__23__23_return_2d_link() { // ##return-link
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_return_2d_link);
  }
  " R1 " = " R1 ".link-1;
  return " R0 ";
}

" (univ-glo ctx '##return-link) " = Gambit_bb1__23__23_return_2d_link;


function Gambit_bb1__23__23_return_2d_id() { // ##return-id
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_return_2d_id);
  }
  " R1 " = " R1 ".id;
  return " R0 ";
}

" (univ-glo ctx '##return-id) " = Gambit_bb1__23__23_return_2d_id;


function Gambit_bb1__23__23_continuation_2d_link() { // ##continuation-link
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_link);
  }
  " R1 " = " R1 ".frame[0].link-1;
  return " R0 ";
}

" (univ-glo ctx '##continuation-link) " = Gambit_bb1__23__23_continuation_2d_link;


function Gambit_bb1__23__23_frame_2d_link() { // ##frame-link
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_frame_2d_link);
  }
  " R1 " = " R1 "[0].link-1;
  return " R0 ";
}
" (univ-glo ctx '##frame-link) " = Gambit_bb1__23__23_frame_2d_link;

function Gambit_bb1__23__23_continuation_2d_ret() { // ##continuation-ret
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_ret);
  }
  " R1 " = " R1 ".frame[0];
  return " R0 ";
}

" (univ-glo ctx '##continuation-ret) " = Gambit_bb1__23__23_continuation_2d_ret;


function Gambit_bb1__23__23_frame_2d_ret() { // ##frame-ret
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_frame_2d_ret);
  }
  " R1 " = " R1 "[0];
  return " R0 ";
}

" (univ-glo ctx '##frame-ret) " = Gambit_bb1__23__23_frame_2d_ret;


function Gambit_bb1__23__23_continuation_2d_ref() { // ##continuation-ref
  if (Gambit_nargs !== 2) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_ref);
  }
  " R1 " = " R1 ".frame[" R2 "];
  return " R0 ";
}

" (univ-glo ctx '##continuation-ref) " = Gambit_bb1__23__23_continuation_2d_ref;


function Gambit_bb1__23__23_frame_2d_ref() { // ##frame-ref
  if (Gambit_nargs !== 2) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_frame_2d_ref);
  }
  " R1 " = " R1 "[" R2 "];
  return " R0 ";
}

" (univ-glo ctx '##frame-ref) " = Gambit_bb1__23__23_frame_2d_ref;


function Gambit_bb1__23__23_continuation_2d_slot_2d_live_3f_() { // ##continuation-slot-live?
  if (Gambit_nargs !== 2) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_slot_2d_live_3f_);
  }
  " R1 " = true;
  return " R0 ";
}

" (univ-glo ctx '##continuation-slot-live?) " = Gambit_bb1__23__23_continuation_2d_slot_2d_live_3f_;


function Gambit_bb1__23__23_frame_2d_slot_2d_live_3f_() { // ##frame-slot-live?
  if (Gambit_nargs !== 2) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_frame_2d_slot_2d_live_3f_);
  }
  " R1 " = true;
  return " R0 ";
}

" (univ-glo ctx '##frame-slot-live?) " = Gambit_bb1__23__23_frame_2d_slot_2d_live_3f_;


function Gambit_bb1__23__23_continuation_2d_next() { // ##continuation-next
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_next);
  }
  var frame = " R1 ".frame;
  var denv = " R1 ".denv;
  var next_frame = frame[frame[0].link];
  if (next_frame === false)
    " R1 " = false;
  else
    " R1 " = new Gambit_Continuation(next_frame, denv);
  return " R0 ";
}

" (univ-glo ctx '##continuation-next) " = Gambit_bb1__23__23_continuation_2d_next;


function Gambit_trampoline(pc) {
  while (pc !== false) {
    pc = pc();
  }
}

"

)))

    ((python)                           ;rts py     
#<<EOF
#! /usr/bin/python

from array import array
import ctypes

Gambit_glo = {}
Gambit_reg = {0:False}
Gambit_stack = {}
Gambit_sp = -1
Gambit_nargs = 0
Gambit_temp1 = False
Gambit_temp2 = False

#
# char
#
class Gambit_Char:
  chars = {}
  def __init__ ( self,  c ):
    self.c = c

  def __str__ ( self ):
    return self.c
        
# ##fx->char
def Gambit_fxToChar ( i ):
  if Gambit_Char.chars.has_key(i):
    return Gambit_Char.chars[i]
  else:
    Gambit_Char.chars[i] = Gambit_Char(unichr(i))
    return Gambit_Char.chars[i]

# ##fx<-char
def Gambit_charToFx ( c ):
  return ord(c.c)

# char?
def Gambit_charp ( c ):
  return (isinstance(c, Char))

#
# Pair
#
class Gambit_Pair:
  def __init__ ( self, car, cdr ):
    self.car = car
    self.cdr = cdr

  def __str__ ( self ):
    res = "(" + self.car
    if (self.cdr is not None):
      res += " . " + self.cdr
    res += ")"

    return res

  def __eq__ ( self, p ):
    return self is p

  def car ( self ):
    return self.car

  def cdr ( self ):
    return self.cdr

  def setcar ( self, newcar ):
    self.car = newcar

  def setcdr ( self, newcdr ):
    self.cdr = newcdr

def Gambit_cons ( a, b ):
  return Gambit_Pair(a, b)

def Gambit_list ( *args ):
  n = len(args)
  lst = None

  while n > 0:
    lst = Gambit_cons(args[n-1], lst)
    n -= 1

  return lst

#
# String
#
class Gambit_String:
  def __init__ ( self, *args ):
    self.chars = array('u', list(args))

  def __getitem__ ( self, n ):
    return self.chars[n]

  def __setitem__ ( self, n, c ):
    self.chars[n] = c.c

  def __len__ ( self ):
    return len(self.chars)

  def __eq__ ( self, s ):
    self.chars == s.chars

  def __str__ ( self ):
    return "".join(self.chars)

def Gambit_makestring ( n, c ):
  args = [c.c]*n
  return Gambit_String(*args)
    
def Gambit_stringp ( s ):
  return isinstance(s, String)


def Gambit_bb1_println(): # println
  global Gambit_glo, Gambit_reg, Gambit_stack, Gambit_sp, Gambit_nargs, Gambit_temp1, Gambit_temp2
  if Gambit_nargs != 1:
    raise "wrong number of arguments"
  if Gambit_reg[1] is False:
    print("#f")
  elif Gambit_reg[1] is True:
    print("#t")
  elif isinstance(Gambit_reg[1], float) and (int(Gambit_reg[1]) == round(Gambit_reg[1])):
    print(str(int(Gambit_reg[1])) + '.')
  else:
    print(Gambit_reg[1])
  return " R0 ";

Gambit_glo["println"] = Gambit_bb1_println


def Gambit_poll(wakeup):
  return wakeup


def Gambit_trampoline(pc):
  while pc != False:
    pc = pc()

EOF
)

    ((ruby)                             ;rts rb
#<<EOF
# encoding: utf-8

$Gambit_glo = {}
$Gambit_reg = {0=>false}
$Gambit_stack = {}
$Gambit_sp = -1
$Gambit_nargs = 0
$Gambit_temp1 = false
$Gambit_temp2 = false

$Gambit_chars = {}
class Gambit_Char
  def initialize ( code )
    @code = code
  end
  def code
    @code
  end
  def to_s
    @code.chr
  end
end

def Gambit_fxToChar ( i )
  if $Gambit_chars.has_key?(i)
    return $Gambit_chars[i]
  else
    c = Gambit_Char.new(i)
    $Gambit_chars[i] = c
    return c
  end
end

def Gambit_charToFx ( c )
  return c.code
end

$Gambit_bb1_println = lambda { # println
  if $Gambit_nargs != 1
    raise "wrong number of arguments"
  end
  
  if $Gambit_reg[1] == false
    print("#f")
  elsif $Gambit_reg[1] == true
    print("#t")
  elsif $Gambit_reg[1].equal?(nil)
    print("")
  elsif $Gambit_reg[1].class == Float && $Gambit_reg[1] == $Gambit_reg[1].round
    print($Gambit_reg[1].round.to_s() + ".")
  else
    print($Gambit_reg[1])
  end
  
  print("\n")
  return $Gambit_reg[0]
}

$Gambit_glo["println"] = $Gambit_bb1_println


def Gambit_poll(wakeup)
  return wakeup
end


def Gambit_trampoline(pc)
  while pc != false
    pc = pc.call
  end
end

EOF
)

    ((php)                              ;rts php
#<<EOF
??????????????????????????????????
EOF
)

    ((dart)                               ;rts dart
     (let ((R0 (translate-gvm-opnd ctx (make-reg 0)))
           (R1 (translate-gvm-opnd ctx (make-reg 1)))
           (R2 (translate-gvm-opnd ctx (make-reg 2)))
           (R3 (translate-gvm-opnd ctx (make-reg 3)))
           (R4 (translate-gvm-opnd ctx (make-reg 4))))
       (^ "
function Gambit_heapify(ra) {

  if (Gambit_sp > 0) { // stack contains at least one frame

    var fs = ra.fs, link = ra.link;
    var chain = Gambit_stack;

    if (Gambit_sp > fs) { // stack contains at least two frames
      chain = Gambit_stack.slice(Gambit_sp - fs, Gambit_sp + 1);
      chain[0] = ra;
      Gambit_sp = Gambit_sp - fs;
      var prev_frame = chain, prev_link = link;
      ra = prev_frame[prev_link]; fs = ra.fs; link = ra.link;

      while (Gambit_sp > fs) {
        var frame = Gambit_stack.slice(Gambit_sp - fs, Gambit_sp + 1);
        frame[0] = ra;
        Gambit_sp = Gambit_sp - fs;
        prev_frame[prev_link] = frame;
        prev_frame = frame; prev_link = link;
        ra = prev_frame[prev_link]; fs = ra.fs; link = ra.link;
      }

      prev_frame[prev_link] = Gambit_stack;
    }

    Gambit_stack.length = fs + 1;
    Gambit_stack[link] = Gambit_stack[0];
    Gambit_stack[0] = ra;
  
    Gambit_stack = [chain];
    Gambit_sp = 0;
  }

  return Gambit_underflow;
}

function Gambit_underflow() {

  var frame = Gambit_stack[0];

  if (frame == false) // end of continuation?
    return false; // terminate trampoline

  var ra = frame[0], fs = ra.fs, link = ra.link;
  Gambit_stack = frame.slice(0, fs + 1);
  Gambit_sp = fs;
  Gambit_stack[0] = frame[link];
  Gambit_stack[link] = Gambit_underflow;

  return ra;
}

var Gambit_glo;
var Gambit_stack;
var Gambit_sp = 0;
var " R0 " = Gambit_underflow;
var " R1 " = false;
var " R2 " = false;
var " R3 " = false;
var " R4 " = false;
var Gambit_nargs = 0;
var Gambit_temp1 = false;
var Gambit_temp2 = false;
var Gambit_poll_count = 1;

function Gambit_poll(dest) {
  Gambit_poll_count = 100;
//  Gambit_stack.length = Gambit_sp + 1;
  return dest;
}

function Gambit_printout(text) {
  if (text != \"\\n\")
    print(text);
}

function Gambit_wrong_nargs(fn) {
    Gambit_printout(\"*** wrong number of arguments (\"+Gambit_nargs+\") when calling\");
    Gambit_printout(fn);
    return false;
}

function closure_alloc(slots) {

  function self(msg) {
    if (msg == false) return slots;
    " R4 " = self;
    return slots.v0;
  }

  return self;
}

function Gambit_trampoline(pc) {
  while (pc != false) {
    pc = pc();
  }
}

"

)))

    (else
     (compiler-internal-error
      "runtime-system, unknown target"))))

(define (entry-point ctx main-proc)
  (let ((entry (lbl->id ctx 1 (proc-obj-name main-proc))))
    (^ "\n"
       (univ-comment ctx "--------------------------------\n")
       "\n"

       (case (target-name (ctx-target ctx))

         ((js php)
          (^ (^prefix "trampoline") "(" entry ");\n"))

         ((python ruby)
          (^ (^prefix "trampoline") "(" entry ")\n"))

         ((dart)
          (univ-function
           ctx
           "main"
           ""
           "\n"
           (univ-indent
            (^ (univ-assign ctx (^global-var (^prefix "glo")) "{}")
               (univ-assign ctx (^global-var (^prefix "stack")) "new List(1000)")
               (univ-assign ctx (^ (^global-var (^prefix "stack")) "[0]") "false")
               (^ (^prefix "trampoline") "(" entry ");\n")))))

         (else
          (compiler-internal-error
           "entry-point, unknown target"))))))

;;;----------------------------------------------------------------------------

(define (univ-function ctx name params header body)
  (case (target-name (ctx-target ctx))

    ((js php dart)
     (^ "function " name "(" params ") {" header body "}\n"))

    ((python)
     (^ "def " name "(" params "):\n"
        (univ-indent (^ "global "
                        (^prefix "glo") ","
                        (^prefix "r") ","
                        (^prefix "stack") ","
                        (^prefix "sp") ","
                        (^prefix "nargs") ","
                        (^prefix "temp1") ","
                        (^prefix "temp2")))
        header
        body))

    ((ruby)
     (univ-assign ctx
                  name
                  (^ "lambda {"
                     (if (equal? params "")
                         (^)
                         (^ "|" params "|"))
                     header
                     body
                     "}")))

    (else
     (compiler-internal-error
      "univ-function, unknown target"))))

(define (univ-rec-function ctx name params header body)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "(function () {\n"
        (univ-indent
         (^ (univ-function ctx name header body)
            (univ-return ctx name)))
        "})()"))

    ((python)
     (^ "(lambda:\n"
        (univ-indent
         (^ (univ-function ctx name header body)
            (univ-return ctx name)))
        ")()"))

    ((ruby)
     "???")

    (else
     (compiler-internal-error
      "univ-rec-function, unknown target"))))

(define (univ-comment ctx comment)
  (case (target-name (ctx-target ctx))

    ((js php dart)
     (^ "// " comment))

    ((python ruby)
     (^ "# " comment))

    (else
     (compiler-internal-error
      "univ-comment, unknown target"))))

(define (univ-return-call ctx expr . params)
  (univ-return ctx (apply univ-call (cons ctx (cons expr params)))))

(define (univ-return ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php dart)
     (^ "return " expr ";\n"))

    ((python ruby)
     (^ "return " expr "\n"))

    (else
     (compiler-internal-error
      "univ-return, unknown target"))))

(define (makecall ctx name args)
  (apply univ-call (cons ctx (cons name args))))

(define (univ-call ctx name . params)
  (case (target-name (ctx-target ctx))

    ((js dart)
     (^ name
        "("
        (univ-separated-list "," params)
        ")"))
    
    ((python ruby php)                ;TODO: complete
     (^))

    (else
     (compiler-internal-error
      "univ-call, unknown target"))))

(define (univ-return-poll ctx expr poll? call?)
  (if poll?

      #;
       (univ-return
        ctx
        (univ-call ctx (^prefix "poll") expr))
      (^if (^ "--" (^global-var (^prefix "poll_count")) " === 0")
           (univ-return-call ctx (^prefix "poll") expr)
           (if call?
               (univ-return-call ctx expr)
               (univ-return ctx expr)))

      (if call?
          (univ-return-call ctx expr)
          (univ-return ctx expr))))

(define (univ-throw ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ "throw " expr ";\n"))

    ((python ruby)
     (^ "raise " expr "\n"))

    (else
     (compiler-internal-error
      "univ-throw, unknown target"))))

(define (univ-eq ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ expr1 " === " expr2))

    ((python)
     (^ expr1 " is " expr2))

    ((ruby)
     (^ expr1 " .equal?(" expr2 ")"))

    ((php dart)
     (^ expr1 " == " expr2))

    (else
     (compiler-internal-error
      "univ-eq, unknown target"))))

(define (univ-fxquotient ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "parseInt(" expr1 " / " expr2 ")"))

    ((python ruby php)
     (^))

    (else
     (compiler-internal-error
      "univ-fxquotient, unknown target"))))

(define (univ-fxmodulo ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "(" expr1 " % " expr2 ")"))

    ((python ruby php)
     (^))

    (else
     (compiler-internal-error
      "univ-fxmodulo, unknown target"))))

(define (univ-boolean ctx val)
  (case (target-name (ctx-target ctx))

    ((js ruby php dart)
     (^ (if val "true" "false")))

    ((python)
     (^ (if val "True" "False")))

    (else
     (compiler-internal-error
      "univ-boolean, unknown target"))))

(define (univ-assign ctx loc expr)
  (case (target-name (ctx-target ctx))

    ((js php dart)
     (^ loc " = " expr ";\n"))

    ((python ruby)
     (^ loc " = " expr "\n"))

    (else
     (compiler-internal-error
      "univ-assign, unknown target"))))

(define (univ-increment ctx loc expr)
  (case (target-name (ctx-target ctx))

    ((js php dart)
     (^ loc " += " expr ";\n"))

    ((python ruby)
     (^ loc " += " expr "\n"))

    (else
     (compiler-internal-error
      "univ-increment, unknown target"))))

(define (univ-decrement ctx loc expr)
  (case (target-name (ctx-target ctx))

    ((js php dart)
     (^ loc " -= " expr ";\n"))

    ((python ruby)
     (^ loc " -= " expr "\n"))

    (else
     (compiler-internal-error
      "univ-decrement, unknown target"))))

(define (univ-define-prim
         name
         proc-safe?
         side-effects?
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

          (proc-obj-inline-set!
           prim
           (lambda (ctx opnds loc)
             (if loc ;; result is needed?

                 (univ-assign ctx
                              (translate-gvm-opnd ctx loc)
                              (apply-gen ctx opnds))

                 (if side-effects? ;; only generate code for side-effect
                     (^expr-statement (apply-gen ctx opnds))
                     (^)))))))

    (if ifjump-gen
        (begin

          (proc-obj-testable?-set!
           prim
           (lambda (env)
             (or proc-safe?
                 (not (safe? env)))))

          (proc-obj-test-set!
           prim
           (lambda (ctx opnds)
             (ifjump-gen ctx opnds)))))

    (if jump-gen
        (begin

          (proc-obj-jump-inlinable?-set!
           prim
           (lambda (env)
             #t))

          (proc-obj-jump-inline-set!
           prim
           jump-gen)))))

(define (univ-define-prim-bool name proc-safe? side-effects? prim-gen)
  (univ-define-prim name proc-safe? side-effects? prim-gen prim-gen))

(define (univ-number ctx obj)
  (if (exact? obj)
      (cond ((integer? obj)
             (^ obj))
            (else
             (compiler-internal-error
              "translate-obj, unsupported exact number:" obj)))
      (cond ((real? obj)
             (let ((x
                    (if (integer? obj)
                        (^ obj 0)
                        (^ obj))))
               (case (target-name (ctx-target ctx))
                 ((js)
                  (^ "new " (^prefix "Flonum") "(" x ")"))
                 (else
                  x))))
            (else
             (compiler-internal-error
              "translate-obj, unsupported inexact number:" obj)))))

(define (univ-char ctx obj)
  (let ((code (char->integer obj)))
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "Char.fxToChar")
          "("
          code
          ")"))

      ((python ruby)
       (^ (^prefix "fxToChar")
          "("
          code
          ")"))

      ((php)
       (^ code))                ;TODO: complete

      (else
       (compiler-internal-error
        "univ-char, unknown target")))))

(define (univ-string ctx obj)

  (case (target-name (ctx-target ctx))

    ((js)
     (^ (^prefix "String.jsstringToString")
        "("
        (object->string obj)
        ")"))

    ;; ((js)
    ;;  (^ "new "
    ;;     (makecall ctx
    ;;               (^prefix "String")
    ;;               (map (lambda (ch) (univ-char ctx ch))
    ;;                    (string->list obj)))))

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

(define (univ-null ctx)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "null"))
    
    ((python)
     (^ "None"))

    ((ruby)
     (^ "nil"))

    ((php)                                ;TODO: complete
     (^))

    (else
     (compiler-internal-error
      "univ-null, unknown target"))))

(define (undefined? obj)
  (eq? obj 'undefined))

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

(define (univ-pair ctx obj)
  (univ-cons ctx
             (translate-obj ctx (car obj))
             (translate-obj ctx (cdr obj))))

(define (univ-cons ctx expr1 expr2)
  
  (case (target-name (ctx-target ctx))

    ((js)
     (^ "new " (makecall ctx
                         (^prefix "Pair")
                         (list expr1 expr2))))
    
    ((python ruby php)                         ;TODO: complete
     (^))

    (else
     (compiler-internal-error
      "univ-cons, unknown target"))))


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
;;      (let ((tobj (map (lambda (o) (translate-obj ctx o))
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

(define (univ-vector ctx obj)

  (define (make-list n elt)
    (vector->list (make-vector n elt)))
  
  (define (zip lst1 lst2)
    (define (zip-aux lst1 lst2 lst)
      (cond ((null? lst1)
             (append lst lst2))
            ((null? lst2)
             (append lst lst1))
            (else
             (cons (car lst1)
                   (cons (car lst2)
                         (zip-aux (cdr lst1) (cdr lst2) lst))))))

    (zip-aux lst1 lst2 '()))  

  (case (target-name (ctx-target ctx))

    ((js)
     (let ((vlen (vector-length obj)))
       (if (> vlen 0)
           (let ((tobj (map (lambda (o) (translate-obj ctx o))
                            (vector->list obj)))
                 (sep (make-list (- vlen 1) ", ")))

             (^ "["
                (zip tobj sep)
                "]"))
           (^ "[]"))))
    
    ((python ruby php)                         ;TODO: complete
     (^ (object->string obj)))

    (else
     (compiler-internal-error
      "univ-vector, unknown target"))))

;;; Primitive procedures

(univ-define-prim-bool "##not" #t #f

  (lambda (ctx opnds)
    (univ-eq ctx
             (translate-gvm-opnd ctx (list-ref opnds 0))
             (univ-boolean ctx #f))))

(univ-define-prim-bool "##eq?" #t #f

  (lambda (ctx opnds)
    (univ-eq ctx
             (translate-gvm-opnd ctx (list-ref opnds 0))
             (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim "##fx+" #f #f

  (lambda (ctx opnds)
    (^ (translate-gvm-opnd ctx (list-ref opnds 0))
       " + "
       (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim "##fx-" #f #f

  (lambda (ctx opnds)
    (^ (translate-gvm-opnd ctx (list-ref opnds 0))
       " - "
       (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim "##fx*" #f #f

  (lambda (ctx opnds)
    (^ (translate-gvm-opnd ctx (list-ref opnds 0))
       " * "
       (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim "##fxquotient" #f #f

  (lambda (ctx opnds)
    (univ-fxquotient ctx
                   (translate-gvm-opnd ctx (list-ref opnds 0))
                   (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim "##fxmodulo" #f #f

  (lambda (ctx opnds)
    (univ-fxmodulo ctx
                   (translate-gvm-opnd ctx (list-ref opnds 0))
                   (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim-bool "##fx<" #f #f

  (lambda (ctx opnds)
    (let ((opnd1 (list-ref opnds 0))
          (opnd2 (list-ref opnds 1)))
      (^< (^operand opnd1) (^operand opnd2)))))

(univ-define-prim-bool "##fx<=" #f #f

  (lambda (ctx opnds)
    (let ((opnd1 (list-ref opnds 0))
          (opnd2 (list-ref opnds 1)))
      (^<= (^operand opnd1) (^operand opnd2)))))

(univ-define-prim-bool "##fx>" #f #f

  (lambda (ctx opnds)
    (let ((opnd1 (list-ref opnds 0))
          (opnd2 (list-ref opnds 1)))
      (^> (^operand opnd1) (^operand opnd2)))))

(univ-define-prim-bool "##fx>=" #f #f

  (lambda (ctx opnds)
    (let ((opnd1 (list-ref opnds 0))
          (opnd2 (list-ref opnds 1)))
      (^>= (^operand opnd1) (^operand opnd2)))))

(univ-define-prim-bool "##fx=" #f #f

  (lambda (ctx opnds)
    (let ((opnd1 (list-ref opnds 0))
          (opnd2 (list-ref opnds 1)))
      (^= (^operand opnd1) (^operand opnd2)))))

(univ-define-prim "##fx+?" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "(temp2 = (temp1 = "
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " + "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")<<"
          univ-tag-bits
          ">>"
          univ-tag-bits
          ") === temp1 && temp2"))

      ((python)
       (^ "(lambda temp1: (lambda temp2: temp1 == temp2 and temp2)(ctypes.c_int32(temp1<<"
          univ-tag-bits
          ").value>>"
          univ-tag-bits
          "))("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " + "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")"))

      ((ruby php)
       (^ "(temp2 = (((temp1 = "
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " + "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ") + "
          (expt 2 (- univ-word-bits (+ 1 univ-tag-bits)))
          ") & "
          (- (expt 2 (- univ-word-bits univ-tag-bits)) 1)
          ") - "
          (expt 2 (- univ-word-bits (+ 1 univ-tag-bits)))
          ") == temp1 && temp2"))

      (else
       (compiler-internal-error
        "##fx+?, unknown target")))))

(univ-define-prim "##fx-?" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "(temp2 = (temp1 = "
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " - "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")<<"
          univ-tag-bits
          ">>"
          univ-tag-bits
          ") === temp1 && temp2"))

      ((python)
       (^ "(lambda temp1: (lambda temp2: temp1 == temp2 and temp2)(ctypes.c_int32(temp1<<"
          univ-tag-bits
          ").value>>"
          univ-tag-bits
          "))("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " - "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")"))

      ((ruby php)
       (^ "(temp2 = (((temp1 = "
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " - "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ") + "
          (expt 2 (- univ-word-bits (+ 1 univ-tag-bits)))
          ") & "
          (- (expt 2 (- univ-word-bits univ-tag-bits)) 1)
          ") - "
          (expt 2 (- univ-word-bits (+ 1 univ-tag-bits)))
          ") == temp1 && temp2"))

      (else
       (compiler-internal-error
        "##fx-?, unknown target")))))

(univ-define-prim "##fxwrap+" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " + "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")<<"
          univ-tag-bits
          ">>"
          univ-tag-bits))

      ((python)
       (^ "ctypes.c_int32(("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " + "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")<<"
          univ-tag-bits
          ").value>>"
          univ-tag-bits))

      ((ruby php)
       (^ "((("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " + "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ") + "
          (expt 2 (- univ-word-bits (+ 1 univ-tag-bits)))
          ") & "
          (- (expt 2 (- univ-word-bits univ-tag-bits)) 1)
          ") - "
          (expt 2 (- univ-word-bits (+ 1 univ-tag-bits)))))

      (else
       (compiler-internal-error
        "##fxwrap+, unknown target")))))

(univ-define-prim "##fxwrap-" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " - "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")<<"
          univ-tag-bits
          ">>"
          univ-tag-bits))

      ((python)
       (^ "ctypes.c_int32(("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " - "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")<<"
          univ-tag-bits
          ").value>>"
          univ-tag-bits))

      ((ruby php)
       (^ "((("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " - "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ") + "
          (expt 2 (- univ-word-bits (+ 1 univ-tag-bits)))
          ") & "
          (- (expt 2 (- univ-word-bits univ-tag-bits)) 1)
          ") - "
          (expt 2 (- univ-word-bits (+ 1 univ-tag-bits)))))

      (else
       (compiler-internal-error
        "##fxwrap-, unknown target")))))

(univ-define-prim "##fxwrap*" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       ;; TODO: fix this JS code, which does not work when the result of the multiplication is more than 52 bits (due to JS's use of 64 bit IEEE floats)
       ;; idea: detect the special case of a constant in either operands that is less than 22 bits (because a multiplication of a 30 bit fixnum integer and 22 bit integer will fit in 52 bits)
       (^ "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " * "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")<<"
          univ-tag-bits
          ">>"
          univ-tag-bits))

      ((python)
       (^ "ctypes.c_int32(("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " * "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")<<"
          univ-tag-bits
          ").value>>"
          univ-tag-bits))

      ((ruby php)
       ;; TODO: fix this for PHP which may have 32 or 64 bit ints
       ;; For ruby it is OK because ruby will use bignums
       (^ "((("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " * "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ") + "
          (expt 2 (- univ-word-bits (+ 1 univ-tag-bits)))
          ") & "
          (- (expt 2 (- univ-word-bits univ-tag-bits)) 1)
          ") - "
          (expt 2 (- univ-word-bits (+ 1 univ-tag-bits)))))

      (else
       (compiler-internal-error
        "##fxwrap*, unknown target")))))

(univ-define-prim-bool "##fxzero?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " === 0)"))
      
      ((python ruby)
       (^ "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " == 0)"))
      
      ((php)                       ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##null?, unknown target")))))

(univ-define-prim-bool "##fxodd?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " % 2 == 1)"))
      
      ((python ruby php)                       ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##odd?, unknown target")))))

(univ-define-prim-bool "##fxeven?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " % 2 == 0)"))
      
      ((python ruby php)                       ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##even?, unknown target")))))

(univ-define-prim-bool "##fxmax" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "Math.max("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ","
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")"))
      
      ((python ruby php)                       ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##fxmax, unknown target")))))

(univ-define-prim-bool "##fxmin" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "Math.min("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ","
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")"))
      
      ((python ruby php)                       ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##fxmin, unknown target")))))

(univ-define-prim-bool "##null?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " === null)"))
      
      ((python)
       (^ "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " is None)"))
      
      ((ruby)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".equal?(nil)"))

      ((php)                       ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##null?, unknown target")))))

(univ-define-prim "##cons" #t #f

  (lambda (ctx opnds)
    (univ-cons ctx
               (translate-gvm-opnd ctx (list-ref opnds 0))
               (translate-gvm-opnd ctx (list-ref opnds 1)))))


(univ-define-prim "js-code" #f #f
                  (lambda (ctx opnds)
                    (if (and (eq? 'js (target-name (ctx-target ctx)))
                             (obj? (car opnds)))
                        (^ (obj-val (car opnds)))
                        (compiler-internal-error "js-code, target incompatible"))))



(define (univ-car ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     #;
     (^ (^prefix "car(")
        expr
        ")")
     (^ expr
        ".car"))

    ((python ruby php)                ;TODO: complete
     (^))

    (else
     (compiler-internal-error
      "univ-car, unknown target"))))

(define (univ-cdr ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     #;
     (^ (^prefix "cdr(")
        expr
        ")")
     (^ expr
        ".cdr"))

    ((python ruby php)                ;TODO: complete
     (^))

    (else
     (compiler-internal-error
      "univ-cdr, unknown target"))))

(univ-define-prim "##car" #f #f

  (lambda (ctx opnds)
    (univ-car ctx
              (translate-gvm-opnd ctx (list-ref opnds 0)))))

(univ-define-prim "##cdr" #f #f

  (lambda (ctx opnds)
    (univ-cdr ctx
              (translate-gvm-opnd ctx (list-ref opnds 0)))))

;; ##caar
(univ-define-prim "##caar" #f #f

  (lambda (ctx opnds)
    (univ-car ctx
              (univ-car ctx
                        (translate-gvm-opnd ctx (list-ref opnds 0))))))

;; ##cadr
(univ-define-prim "##cadr" #f #f

  (lambda (ctx opnds)
    (univ-car ctx
              (univ-cdr ctx
                        (translate-gvm-opnd ctx (list-ref opnds 0))))))

;; ##cdar
(univ-define-prim "##cdar" #f #f

  (lambda (ctx opnds)
    (univ-cdr ctx
              (univ-car ctx
                        (translate-gvm-opnd ctx (list-ref opnds 0))))))

;; ##cddr
(univ-define-prim "##cddr" #f #f

  (lambda (ctx opnds)
    (univ-cdr ctx
              (univ-cdr ctx
                        (translate-gvm-opnd ctx (list-ref opnds 0))))))

;; ##caaar
(univ-define-prim "##caaar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "caaar(")
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##caaar, unknown target")))))

;; ##caadr
(univ-define-prim "##caadr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "caadr(")
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##caadr, unknown target")))))

;; ##cadar
(univ-define-prim "##cadar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cadar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cadar, unknown target")))))

;; ##caddr
(univ-define-prim "##caddr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "caddr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##caddr, unknown target")))))

;; ##cdaar
(univ-define-prim "##cdaar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cdaar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cdaar, unknown target")))))

;; ##cdadr
(univ-define-prim "##cdadr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cdadr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cdadr, unknown target")))))

;; ##cddar
(univ-define-prim "##cddar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cddar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cddar, unknown target")))))

;; ##cdddr
(univ-define-prim "##cdddr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cdddr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cdddr, unknown target")))))

;; ##caaaar
(univ-define-prim "##caaaar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "caaaar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##caaaar, unknown target")))))

;; ##caaadr
(univ-define-prim "##caaadr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "caaadr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##caaadr, unknown target")))))

;; ##caadar
(univ-define-prim "##caadar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "caadar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##caadar, unknown target")))))

;; ##caaddr
(univ-define-prim "##caaddr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "caaddr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##caaddr, unknown target")))))

;; ##cadaar
(univ-define-prim "##cadaar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cadaar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cadaar, unknown target")))))

;; ##cadadr
(univ-define-prim "##cadadr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cadadr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cadadr, unknown target")))))

;; ##caddar
(univ-define-prim "##caddar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "caddar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##caddar, unknown target")))))

;; ##cadddr
(univ-define-prim "##cadddr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cadddr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cadddr, unknown target")))))

;; ##cdaaar
(univ-define-prim "##cdaaar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cdaaar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cdaaar, unknown target")))))

;; ##cdaadr
(univ-define-prim "##cdaadr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cdaadr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cdaadr, unknown target")))))

;; ##cdadar
(univ-define-prim "##cdadar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cdadar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cdadar, unknown target")))))

;; ##cdaddr
(univ-define-prim "##cdaddr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cdaddr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cdaddr, unknown target")))))

;; ##cddaar
(univ-define-prim "##cddaar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cddaar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cddaar, unknown target")))))

;; ##cddadr
(univ-define-prim "##cddadr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cddadr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cddadr, unknown target")))))

;; ##cdddar
(univ-define-prim "##cdddar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cdddar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cdddar, unknown target")))))

;; ##cddddr
(univ-define-prim "##cddddr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "cddddr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##cddddr, unknown target")))))

(univ-define-prim "##set-car!" #f #t

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "setcar(")
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##set-car!, unknown target")))))

(univ-define-prim "##set-cdr!" #f #t

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "setcdr(")
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")"))
      
      ;; ((python)
      ;;  (^))

      ;; ((ruby)
      ;;  (^))

      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##set-cdr!, unknown target")))))

(univ-define-prim "list" #f #f
 (lambda (ctx opnds)
   (case (target-name (ctx-target ctx))
     
     ((js)
      (^ (makecall ctx
                   (^prefix "list")
                   ;; (list (translate-gvm-opnd ctx (list-ref opnds 0)))
                   (map (lambda (opnd) (translate-gvm-opnd ctx opnd))
                        opnds)
                   )))
     
     ((python ruby php)                ;TODO: complete
      (^))
     
     (else
      (compiler-internal-error
       "list, unknown target")))))

(univ-define-prim "##list" #t #f
 (lambda (ctx opnds)
   (let loop ((lst (reverse opnds))
              (result (univ-null ctx)))
     (if (pair? lst)
         (loop (cdr lst)
               (univ-cons ctx
                          (translate-gvm-opnd ctx (car lst))
                          result))
         result))))

;; (univ-define-prim "##length" #f #f
;;   (lambda (ctx opnds)
;;     (case (target-name (ctx-target ctx))
      
;;       ((js)
;;        (^ (makecall ctx
;;                     (^prefix "length")
;;                     (list (translate-gvm-opnd ctx (list-ref opnds 0))))))
;;                     ;; (list (translate-gvm-opnd ctx (list-ref opnds 0)))
;;                     ;; (map (lambda (opnd) )
;;                     ;;      opnds)
;;                     ;; )))
      
;;       ((python ruby php)                ;TODO: complete
;;        (^))

;;       (else
;;        (compiler-internal-error
;;         "##length, unknown target")))))

(univ-define-prim "length" #f #f
  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))
      
      ((js)
       (^ (makecall ctx
                    (^prefix "length")
                    (list (translate-gvm-opnd ctx (list-ref opnds 0))))))
                    ;; (list (translate-gvm-opnd ctx (list-ref opnds 0)))
                    ;; (map (lambda (opnd) )
                    ;;      opnds)
                    ;; )))
      
      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "length, unknown target")))))

(univ-define-prim "##make-vector" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "Vector.makevector")
          "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")"))
      
      ((php python ruby)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##make-vector, unknown target")))))

(univ-define-prim "##vector" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (let ((nbopnd (length opnds)))
         (if (= nbopnd 0)
             (^ "[]")
             (let ((args (^ "["
                            (^operand (list-ref opnds 0)))))
               (let loop ((i 1)
                          (args args))
                 (if (= i nbopnd)
                     (^ args "]")
                     (loop (+ i 1)
                           (^ args
                              ","
                              (^operand (list-ref opnds i))))))))))
      
      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##vector, unknown target")))))

(univ-define-prim "##vector-ref" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          "["
          (translate-gvm-opnd ctx (list-ref opnds 1))
          "]"))
       
      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##vector-ref, unknown target")))))

(univ-define-prim "##vector-set!" #f #t

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          "["
          (translate-gvm-opnd ctx (list-ref opnds 1))
          "] = "
          (translate-gvm-opnd ctx (list-ref opnds 2))))
      
      ((python)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          "["
          (translate-gvm-opnd ctx (list-ref opnds 1))
          "] = "
          (translate-gvm-opnd ctx (list-ref opnds 2))))
      
      ((ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##vector-set!, unknown target")))))

(univ-define-prim "##string" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "new "
          (makecall ctx
                    (^prefix "String")
                    ;; (list (translate-gvm-opnd ctx (list-ref opnds 0)))
                    (map (lambda (opnd) (translate-gvm-opnd ctx opnd))
                         opnds)
                    )))
      
      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##string, unknown target")))))

(univ-define-prim "##string-length" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".stringlength()"))
      
      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##string-length, unknown target")))))

(univ-define-prim "##vector-length" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".length"))
      
      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##vector-length, unknown target")))))

;;(univ-define-prim "string-append" #f #f (lambda (ctx opnds) (^)))

(univ-define-prim "list->string" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "new "
          (makecall ctx
                    (^prefix "String.listToString")
                    (list (translate-gvm-opnd ctx (list-ref opnds 0))))))
      
      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "list->string, unknown target")))))

(univ-define-prim "symbol->string" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".symbolToString()"))
      
      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "symbol->string, unknown target")))))

(univ-define-prim "string->symbol" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "Symbol.stringToSymbol")
          "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ")"))
      
      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "string->symbol, unknown target")))))

(univ-define-prim "string->list" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "String.stringToList")
          "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ")"))
      
      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "string->list, unknown target")))))

(univ-define-prim "string-append" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (makecall ctx
                    (^prefix "stringappend")                      
                    (map (lambda (opnd) (translate-gvm-opnd ctx opnd))
                         opnds)
                    )))
      
      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##string-append, unknown target")))))

(univ-define-prim "##make-string" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "String.makestring")
          "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")"))
      
      ((python)
       (^ (^prefix "makestring")
          "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", "
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ")"))

      ((ruby)
       (^ (translate-gvm-opnd ctx (list-ref opnds 1))
          ".code.chr*"
          (translate-gvm-opnd ctx (list-ref opnds 0))))

      ((php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##make-string, unknown target")))))

(univ-define-prim "number->string" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "String.jsstringToString")
          "(("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ").toString())"))
      
      ((python ruby php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "number->string, unknown target")))))

(univ-define-prim "##string-set!" #f #t

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".stringset("
          (translate-gvm-opnd ctx (list-ref opnds 1))
          ", "
          (translate-gvm-opnd ctx (list-ref opnds 2))
          ")"))
      
      ((python)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          "["
          (translate-gvm-opnd ctx (list-ref opnds 1))
          "] = "
          (translate-gvm-opnd ctx (list-ref opnds 2))))
      
      ((ruby)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          "["
          (translate-gvm-opnd ctx (list-ref opnds 1))
          "] = "
          (translate-gvm-opnd ctx (list-ref opnds 2))
          ".code.chr"))

      ((php)                ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##string-set!, unknown target")))))

(univ-define-prim "##string-ref" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".stringref(" (translate-gvm-opnd ctx (list-ref opnds 1)) ")"))
        
      ((python)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          "[" (translate-gvm-opnd ctx (list-ref opnds 1)) "]"))

      ((ruby)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          "[" (translate-gvm-opnd ctx (list-ref opnds 1)) "].chr"))

      ((php)                            ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##string-ref, unknown target")))))

(univ-define-prim "##fx->char" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "Char.fxToChar")
          "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ")"))
       
      ((python ruby)
       (^ (^prefix "fxToChar")
          "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ")"))

      ((php)                            ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##fx->char, unknown target")))))

(univ-define-prim "##fx<-char" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (^prefix "Char.charToFx")
          "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ")"))
       
      ((python ruby)
       (^ (^prefix "charToFx")
          "("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ")"))

      ((php)                            ;TODO: complete
       (^))

      (else
       (compiler-internal-error
        "##fx<-char, unknown target")))))

(univ-define-prim-bool "##fixnum?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "typeof "
          (translate-gvm-opnd ctx (list-ref opnds 0))
          " == \"number\""))

      ((python)
       (^ "isinstance("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", int) and not "
          "isinstance("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", bool)"))

      ((ruby)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".class == Fixnum"))

      ((php)
       (^ "is_int("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ")"))

      (else
       (compiler-internal-error
        "##fixnum?, unknown target")))))

(univ-define-prim-bool "##flonum?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          " instanceof "
          (^prefix "Flonum")))

      ((python)
       (^ "isinstance("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", float)"))

      ((ruby)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".class == Float"))

      ((php)
       (^ "is_float("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ")"))

      (else
       (compiler-internal-error
        "##flonum?, unknown target")))))

(univ-define-prim-bool "##char?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js php)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          " instanceof "
          (^prefix "Char")))

      ((python)
       (^ "isinstance("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", "
          (^prefix "Char")
          ")"))

      ((ruby)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".class == "
          (^prefix "Char")))
      
      (else
       (compiler-internal-error
        "##char?, unknown target")))))

(univ-define-prim-bool "##pair?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js php)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          " instanceof "
          (^prefix "Pair")))

      ((python)
       (^ "isinstance("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", "
          (^prefix "Pair")
          ")"))
      
      ((ruby)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".class == "
          (^prefix "Pair")))

      (else
       (compiler-internal-error
        "##pair?, unknown target")))))

(univ-define-prim-bool "##vector?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js php)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          " instanceof "
          (^prefix "Vector")))

      ((python)
       (^ "isinstance("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", "
          (^prefix "Vector")
          ")"))

      ((ruby)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".class == "
          (^prefix "Vector")))

      (else
       (compiler-internal-error
        "##vector?, unknown target")))))

(univ-define-prim-bool "##string?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js php)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          " instanceof "
          (^prefix "String")))

      ((python)
       (^ "isinstance("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", "
          (^prefix "String")
          ")"))

      ((ruby)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".class == "
          (^prefix "String")))

      (else
       (compiler-internal-error
        "##string?, unknown target")))))

(univ-define-prim-bool "##number?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js php)
       (^ "typeof("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ") == \"number\""))

      ((python ruby php)
       (^))

      (else
       (compiler-internal-error
        "##number?, unknown target")))))

(univ-define-prim-bool "##symbol?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js php)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          " instanceof "
          (^prefix "Symbol")))

      ((python)
       (^ "isinstance("
          (translate-gvm-opnd ctx (list-ref opnds 0))
          ", "
          (^prefix "Symbol")
          ")"))

      ((ruby)
       (^ (translate-gvm-opnd ctx (list-ref opnds 0))
          ".class == "
          (^prefix "Symbol")))
      ((php)
       (^))      

      (else
       (compiler-internal-error
        "##symbol?, unknown target")))))

(univ-define-prim-bool "##mem-allocated?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (^ "true"))

      ((python ruby php)
       (^))      

      (else
       (compiler-internal-error
        "##mem-allocated?, unknown target")))))

(univ-define-prim "##subtype" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js python ruby js)
       (^ "1"))

      (else
       (compiler-internal-error
        "##subtype, unknown target")))))

(define univ-tag-bits 2)
(define univ-word-bits 32)

(univ-define-prim "##continuation-capture" #f #t

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

(univ-define-prim "##continuation-graft-no-winding" #f #t

  #f
  #f

  (lambda (ctx nb-args poll? safe? fs)
    (univ-jump-inline ctx
                      nb-args
                      2
                      6
                      poll?
                      safe?
                      fs
                      "continuation_graft_no_winding")))

(univ-define-prim "##continuation-return-no-winding" #f #t

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
          (univ-return-poll
           ctx
           (^ (^prefix
               (string-append name
                              (number->string nb-args)))
              "()")
           poll?
           #t)))))

;;;============================================================================
