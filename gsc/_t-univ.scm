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

(define (univ-prefix ctx name) (gen "Gambit_" name))

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

(define (univ-switch-testable? targ obj)
  (pretty-print (list 'univ-switch-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (univ-eq-testable? targ obj)
  (pretty-print (list 'univ-eq-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (univ-object-type targ obj)
  (pretty-print (list 'univ-object-type 'targ obj))
  'bignum);;;;;;;;;;;;;;;;;;;;;;;;;

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
                (gen "")
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

              (gen "\n"
                   (univ-function

                    ctx

                    id

                    ""

                    (univ-indent
                     (case (label-type gvm-instr)

                       ((simple)
                        (gen "\n"))

                       ((entry)
                        (if (label-entry-rest? gvm-instr)
                            (gen " "
                                 (univ-comment
                                  ctx
                                  (if (label-entry-closed? gvm-instr)
                                      "closure-entry-point (+rest)\n"
                                      "entry-point (+rest)\n"))
                                 (univ-ifnot-then
                                  ctx
                                  (univ-and ctx
                                            (univ-call ctx
                                                       (univ-prefix ctx "buildrest")
                                                       (label-entry-nb-parms gvm-instr))
                                            (univ-= ctx
                                                    (univ-global ctx (univ-prefix ctx "nargs"))
                                                    (label-entry-nb-parms gvm-instr)))
                                  (univ-return ctx
                                               (univ-call ctx
                                                          (univ-prefix ctx "wrong_nargs")
                                                          id))))
                            (gen " "
                                 (univ-comment
                                  ctx
                                  (if (label-entry-closed? gvm-instr)
                                      "closure-entry-point\n"
                                      "entry-point\n"))
                                 (univ-if-then
                                  ctx
                                  (univ-not= ctx
                                             (univ-global ctx (univ-prefix ctx "nargs"))
                                             (label-entry-nb-parms gvm-instr))
                                  (univ-return ctx
                                               (univ-call ctx
                                                          (univ-prefix ctx "wrong_nargs")
                                                          id))))))

                       ((return)
                        (gen " " (univ-comment ctx "return-point\n")))

                       ((task-entry)
                        (gen " " (univ-comment ctx "task-entry-point\n")
                             (univ-throw ctx "\"task-entry-point GVM label unimplemented\"")))

                       ((task-return)
                        (gen " " (univ-comment ctx "task-return-point\n")
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

                   (if (and (eq? (label-type gvm-instr) 'return)
                            (eq? (target-name (ctx-target ctx)) 'js))
                       (let ((info (frame-info gvm-instr)))
                         (gen id ".fs = " (vector-ref info 0) ";\n"
                              id ".link = " (+ (vector-ref info 1) 1) ";\n"))
                       ""))))

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
                     (gen ""))))

              ((close)
               (let ((parms (close-parms gvm-instr)))

                 (define (alloc lst rev-loc-names)
                   (if (pair? lst)

                       (let* ((parms (car lst))
                              (lbl (closure-parms-lbl parms))
                              (loc (closure-parms-loc parms))
                              (opnds (closure-parms-opnds parms)))
                         (univ-closure-alloc
                          ctx
                          lbl
                          (length opnds)
                          (lambda (name)
                            (alloc (cdr lst)
                                   (cons (cons loc name)
                                         rev-loc-names)))))

                       (init (reverse rev-loc-names))))

                 (define (init loc-names)
                   (gen (map
                         (lambda (parms loc-name)
                           (let* ((lbl (closure-parms-lbl parms))
                                  (loc (closure-parms-loc parms))
                                  (opnds (closure-parms-opnds parms)))
                             (let loop ((i 1) ;; 0
                                        (opnds opnds) ;; (cons (make-lbl lbl) opnds)
                                        (rev-code '()))
                               (if (pair? opnds)
                                   (let ((opnd (car opnds)))
                                     (loop (+ i 1)
                                           (cdr opnds)
                                           (cons (univ-assign
                                                  ctx
                                                  (univ-clo ctx (cdr loc-name) i)
                                                  (let ((x (assv opnd loc-names)))
                                                    (if x
                                                        (cdr x)
                                                        (translate-gvm-opnd ctx opnd))))
                                                 rev-code)))
                                   (reverse rev-code)))))
                         (close-parms gvm-instr)
                         loc-names)
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

                       (univ-if-then-else
                        ctx
                        (proc ctx opnds)
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

                     (gen (if nb-args
                              (univ-assign ctx (univ-global ctx (univ-prefix ctx "nargs")) nb-args)
                              "")
                          (with-stack-pointer-adjust
                           ctx
                           (+ fs
                              (ctx-stack-base-offset ctx))
                           (lambda (ctx)
                             (univ-return
                              ctx
                              (univ-poll
                               ctx
                               (scan-gvm-opnd ctx opnd)
                               poll?))))))))

              (else
               (compiler-internal-error
                "scan-gvm-instr, unknown 'gvm-instr':"
                gvm-instr))))

          (define (jump-to-label ctx n jump-fs)

            (cond ((and univ-enable-jump-destination-inlining?
                        (let* ((bb (lbl-num->bb n bbs))
                               (label-instr (bb-label-instr bb)))
                          (and (eq? (label-type label-instr) 'simple)
                               (or (= (length (bb-precedents bb)) 1) ;; sole jump to destination bb?
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
                           (scan-bb-all-except-label ctx bb)))))))

                  (else
                   (with-stack-pointer-adjust
                    ctx
                    (+ jump-fs
                       (ctx-stack-base-offset ctx))
                    (lambda (ctx)
                      (univ-return ctx (scan-gvm-opnd ctx (make-lbl n))))))))

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
        (gen "\n"
             (univ-comment
              ctx
              (gen "-------------------------------- #<"
                   (if (proc-obj-primitive? p)
                       "primitive"
                       "procedure")
                   " "
                   (object->string (string->canonical-symbol (proc-obj-name p)))
                   "> =\n"))
             (let ((x (proc-obj-code p)))
               (if (bbs? x)
                   (scan-bbs x)
                   (gen ""))))))

    (for-each scan-obj procs)

    (let loop ((rev-res '()))
      (if (queue-empty? proc-left)

          (univ-display
           (reverse rev-res)
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
       (gen (univ-function
             ctx
             name
             ""
             "\n"
             (univ-indent
              (gen (univ-assign ctx
                                (translate-gvm-opnd ctx (make-reg (+ univ-nb-arg-regs 1)))
                                name)
                   (univ-return ctx
                                (translate-lbl ctx (make-lbl lbl))))))
            (cont name))))

    (else
     (compiler-internal-error
      "univ-closure-alloc, unknown target"))))

(define (univ-closure-alloc ctx lbl nb-closed-vars cont)
  (case (target-name (ctx-target ctx))

    ((js)
     (set! closure-count (+ closure-count 1))
     (let ((name (string-append "closure" (number->string closure-count))))
       (gen "var " name " = closure_alloc(" (translate-lbl ctx (make-lbl lbl)) ");\n"
            (cont name))))

    (else
     (compiler-internal-error
      "univ-closure-alloc, unknown target"))))

(define gen vector)

(define (make-ctx target ns)
  (vector target ns 0))

(define (ctx-target ctx)                   (vector-ref ctx 0))
(define (ctx-target-set! ctx x)            (vector-set! ctx 0 x))

(define (ctx-ns ctx)                       (vector-ref ctx 1))
(define (ctx-ns-set! ctx x)                (vector-set! ctx 1 x))

(define (ctx-stack-base-offset ctx)        (vector-ref ctx 2))
(define (ctx-stack-base-offset-set! ctx x) (vector-set! ctx 2 x))

(define (with-stack-base-offset ctx n proc)
  (let ((save (ctx-stack-base-offset ctx)))
    (ctx-stack-base-offset-set! ctx n)
    (let ((result (proc ctx)))
      (ctx-stack-base-offset-set! ctx save)
      result)))

(define (with-stack-pointer-adjust ctx n proc)
  (gen (if (= n 0)
           (gen "")
           (univ-increment ctx (univ-global ctx (univ-prefix ctx "sp")) n))
       (with-stack-base-offset
        ctx
        (- (ctx-stack-base-offset ctx) n)
        proc)))

(define (translate-gvm-opnd ctx gvm-opnd)

  (cond ((not gvm-opnd)
         (gen "NO_OPERAND"))

        ((reg? gvm-opnd)
         #;
         (gen (univ-global ctx (univ-prefix ctx "reg"))
              "["
              (reg-num gvm-opnd)
              "]")
         (gen (univ-global ctx (univ-prefix ctx "reg"))
              (reg-num gvm-opnd)))

        ((stk? gvm-opnd)
         (let ((n (+ (stk-num gvm-opnd) (ctx-stack-base-offset ctx))))
           (gen (univ-global ctx (univ-prefix ctx "stack"))
                "["
                (univ-global ctx (univ-prefix ctx "sp"))
                (cond ((= n 0)
                       (gen ""))
                      ((< n 0)
                       (gen n))
                      (else
                       (gen "+" n)))
                "]")))

        ((glo? gvm-opnd)
         (gen (univ-global ctx (univ-prefix ctx "glo"))
              "["
              (object->string (symbol->string (glo-name gvm-opnd)))
              "]"))

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
  (gen closure
       ".v"
       index))

(define (translate-obj ctx obj)
  
  (cond ((boolean? obj)
         (univ-boolean ctx obj))
        
        ((number? obj)
         (univ-number ctx obj))

        ((char? obj)
         (univ-char ctx obj))
        
        ((string? obj)
         (univ-string ctx obj))

        ((null? obj)
         (univ-null ctx obj))

        ((void-object? obj)
         (gen "undefined"))
        
        ((proc-obj? obj)
         (lbl->id ctx 1 (proc-obj-name obj)))

        ((list? obj)
         (univ-list ctx obj))

        ((vector? obj)
         (univ-vector ctx obj))
        
        (else
         (gen "UNIMPLEMENTED_OBJECT("
              (object->string obj)
              ")"))))

(define (translate-lbl ctx lbl)
  (lbl->id ctx (lbl-num lbl) (ctx-ns ctx)))

(define (lbl->id ctx num ns)
  (univ-global ctx (univ-prefix ctx (gen "bb" num "_" (scheme-id->c-id ns)))))

(define (runtime-system ctx)
  (case (target-name (ctx-target ctx))

    ((js)                               ;rts js
     (let ((R0 (translate-gvm-opnd ctx (make-reg 0)))
           (R1 (translate-gvm-opnd ctx (make-reg 1)))
           (R2 (translate-gvm-opnd ctx (make-reg 2)))
           (R3 (translate-gvm-opnd ctx (make-reg 3)))
           (R4 (translate-gvm-opnd ctx (make-reg 4))))
       (list "
function Gambit_heapify_continuation(ra) {
  var chain = false;
  var prev_frame = false;
  var prev_link;

  while (Gambit_sp !== 0) { // stack not empty
    var fs = ra.fs;
    var link = ra.link;
    var frame = Gambit_stack.slice(Gambit_sp - fs, Gambit_sp + 1);
    if (prev_frame === false)
      chain = frame;
    else
      prev_frame[prev_link] = frame;
    prev_frame = frame;
    frame[0] = ra;
    Gambit_sp = Gambit_sp - fs;
    ra = Gambit_stack[Gambit_sp + link];
    prev_link = link;
  }

  if (prev_frame === false)
    chain = Gambit_stack[0];
  else
    prev_frame[prev_link] = Gambit_stack[0];
  
  Gambit_stack = [chain];
  Gambit_sp = 0;

  return Gambit_underflow_handler;
}

function Gambit_underflow_handler() {
  var frame = Gambit_stack[0];
  if (frame === false) // end of continuation?
    return false; // terminate trampoline

  var ra = frame[0];
  var fs = ra.fs;
  var link = ra.link;
  Gambit_stack = frame.slice(0, fs + 1);
  Gambit_sp = fs;
  Gambit_stack[0] = frame[link];
  Gambit_stack[link] = Gambit_underflow_handler;

  return ra;
}
Gambit_underflow_handler.fs = 0;

var Gambit_glo = {};
var " R0 " = Gambit_underflow_handler;
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

Gambit_stack[0] = false;

var Gambit_poll_count = 0;

if (this.hasOwnProperty('setTimeout')) {
  Gambit_poll = function (dest_pc) {
                  setTimeout(function () { Gambit_run(dest_pc); }, 1);
                  return false;
                };
} else {
  Gambit_poll = function (dest_pc) {
                  if (--Gambit_poll_count < 0) {
                    Gambit_poll_count = 100;
                    Gambit_stack.length = Gambit_sp+1;
                  }
                  return dest_pc;
                };
}

function Gambit_buildrest ( f ) {    // nb formal args
                                     // *** assume (= univ-nb-arg-regs 3) for now ***    
    var nb_static_args = f - 1;
    var nb_rest_args = Gambit_nargs - nb_static_args;    
    var rest = null;

    if (Gambit_nargs < nb_static_args)  // Wrong number of args
        return false;

    // simple case, all in reg
    if ((Gambit_nargs <= 3) && (nb_static_args < 3)) {
        for (var i = nb_static_args + 1; i < nb_static_args + nb_rest_args + 1; i++) {
            rest = Gambit_cons(Gambit_reg[i], rest);
        }

        Gambit_reg[nb_static_args + 1] = rest;
        Gambit_nargs -= (nb_rest_args - 1);
        
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

    return true;
}         

function Gambit_wrong_nargs(fn) {
    print(\"*** wrong number of arguments (\"+Gambit_nargs+\") when calling\");
    print(fn);
    return false;
}

function closure_alloc(entry_bb) {

  function self() {
    " R4 " = self;
    return self.v0;
  }

  self.v0 = entry_bb;

  return self;
}
  
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
    return Gambit_toString(this.car) + Gambit_toString(this.cdr);
}

function prettyPrintList ( o ) {
    if (!Gambit_nullp(o)) {
        bb1_println(Gambit_car(o));
        if (!Gambit_nullp(Gambit_cdr(o))) {
            print(\" \");
            prettyPrintList(Gambit_cdr(o));
        }
    }
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

// list
function Gambit_List ( ) {
    var listaux = function (a, n, lst) {
        if (n === 0) {
            return Gambit_cons(a[0], lst);
        } else {
            return listaux(a, n-1, Gambit_cons(a[n], lst));
        }
    }

    var res = listaux(arguments, arguments.length - 1, null);
    
    return res;
}

// Chars
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
    var s = \"\";
    for (i = 0; i < this.stringlength(); i++) {
        s = s.concat(this.stringref(i).toString());
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
Gambit_glo[\"string-append\"] = Gambit_stringappend;

// Vector
var Gambit_Vector = function ( ) {
    this.a = new Array(arguments.length);
    for (i = 0; i < arguments.length; i++) {
        this.a[i] = arguments[i];
    }
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
    var res = \"\";
    for (var i = 0; i<this.a.length; i++) {
        res += Gambit_toString(this.a[i]);
    }

    return res;
}

// make-vector
var Gambit_makevector = function ( n, val ) {
    var v = new Gambit_Vector();

    for (var i = 0; i < n; i++) {
        v.a[i] = val;
    }

    return v;
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

function Gambit_toString ( obj ) {
    if (obj === false)
        return \"#f\";
    else if (obj === true)
        return \"#t\";
    else if (obj === null)
        return \"\";
    else if (obj instanceof Gambit_Flonum)
        return obj.toString();
    else if (obj instanceof Gambit_String)
        return obj.toString();
    else if (obj instanceof Gambit_Char)
        return obj.toString();
    else if (obj instanceof Gambit_Pair)
        return obj.toString();
    else if (obj instanceof Gambit_Vector)
        return obj.toString();
    else
        return obj;
}

function Gambit_bb1_println ( ) { // println
    if (Gambit_nargs !== 1) {
        return Gambit_wrong_nargs(Gambit_bb1_println);
    }

    print(Gambit_toString(" R1 "));
    
    return " R0 ";
}

Gambit_glo[\"println\"] = Gambit_bb1_println;

function Gambit_bb1_print ( ) { // print
    if (Gambit_nargs !== 1) {
        return Gambit_wrong_nargs(Gambit_bb1_print);
    }

    write(Gambit_toString(Gambit_reg[1]));
    
    return Gambit_reg[0];
}

Gambit_glo[\"print\"] = Gambit_bb1_print;

function Gambit_bb1_newline ( ) { // newline
    if (Gambit_nargs !== 0) {
        return Gambit_wrong_nargs(Gambit_bb1_newline);
    }

    print();
    
    return Gambit_reg[0];
}

Gambit_glo[\"newline\"] = Gambit_bb1_newline;

function Gambit_bb1_display ( ) { // display
    if (Gambit_nargs !== 1) {
        return Gambit_wrong_nargs(Gambit_bb1_display);
    }

    write(Gambit_toString(Gambit_reg[1]));
    
    return Gambit_reg[0];
}

Gambit_glo[\"display\"] = Gambit_bb1_display;

function Gambit_bb1_real_2d_time_2d_milliseconds ( ) { // real-time-milliseconds
    if (Gambit_nargs !== 0) {
        return Gambit_wrong_nargs(Gambit_bb1_display);
    }

    Gambit_rer[1] = new Date();
    
    return Gambit_reg[0];
}

Gambit_glo[\"real-time-milliseconds\"] = Gambit_bb1_real_2d_time_2d_milliseconds;

function Gambit_Continuation(frame, denv) {
    this.frame = frame;
    this.denv = denv;
}


// Obsolete
function Gambit_dump_cont(sp, ra) {
    print(\"------------------------\");
    while (ra !== false) {
        print(\"sp=\"+Gambit_sp + \" fs=\"+ra.fs + \" link=\"+ra.link);
        Gambit_sp = Gambit_sp-ra.fs;
        ra = Gambit_stack[Gambit_sp+ra.link+1];
    }
    print(\"------------------------\");
}

function Gambit_continuation_capture1() {
  var receiver = " R1 ";
  " R0 " = Gambit_heapify_continuation(" R0 ");
  " R1 " = new Gambit_Continuation(Gambit_stack[0], false);
  Gambit_nargs = 1;
  return receiver;
}

function Gambit_continuation_capture2() {
  var receiver = " R1 ";
  " R0 " = Gambit_heapify_continuation(" R0 ");
  " R1 " = new Gambit_Continuation(Gambit_stack[0], false);
  Gambit_nargs = 2;
  return receiver;
}

function Gambit_continuation_capture3() {
  var receiver = " R1 ";
  " R0 " = Gambit_heapify_continuation(" R0 ");
  " R1 " = new Gambit_Continuation(Gambit_stack[0], false);
  Gambit_nargs = 3;
  return receiver;
}

function Gambit_continuation_capture4() {
  var receiver = Gambit_stack[Gambit_sp--];
  " R0 " = Gambit_heapify_continuation(" R0 ");
  Gambit_stack[++Gambit_sp] = new Gambit_Continuation(Gambit_stack[0], false);
  Gambit_nargs = 4;
  return receiver;
}

function Gambit_continuation_graft_no_winding2() {
  var proc = " R2 ";
  var cont = " R1 ";
  Gambit_sp = 0;
  Gambit_stack[0] = cont.frame;
  " R0 " = Gambit_underflow_handler;
  Gambit_nargs = 0;
  return proc;
}

function Gambit_continuation_graft_no_winding3() {
  var proc = " R2 ";
  var cont = " R1 ";
  Gambit_sp = 0;
  Gambit_stack[0] = cont.frame;
  " R0 " = Gambit_underflow_handler;
  " R1 " = " R3 ";
  Gambit_nargs = 1;
  return proc;
}

function Gambit_continuation_graft_no_winding4() {
  var proc = " R1 ";
  var cont = Gambit_stack[Gambit_sp];
  Gambit_sp = 0;
  Gambit_stack[0] = cont.frame;
  " R0 " = Gambit_underflow_handler;
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
  " R0 " = Gambit_underflow_handler;
  Gambit_nargs = 3;
  return proc;
}

function Gambit_continuation_return_no_winding2() {
  var cont = " R1 ";
  Gambit_sp = 0;
  Gambit_stack[0] = cont.frame;
  " R0 " = Gambit_underflow_handler;
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

Gambit_glo[\"##continuation?\"] = Gambit_bb1__23__23_continuation_3f_;


function Gambit_bb1__23__23_continuation_2d_frame() { // ##continuation-frame
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_frame);
  }
  " R1 " = " R1 ".frame;
  return " R0 ";
}

Gambit_glo[\"##continuation-frame\"] = Gambit_bb1__23__23_continuation_2d_frame;


function Gambit_bb1__23__23_continuation_2d_denv() { // ##continuation-denv
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_denv);
  }
  " R1 " = " R1 ".denv;
  return " R0 ";
}

Gambit_glo[\"##continuation-denv\"] = Gambit_bb1__23__23_continuation_2d_denv;


function Gambit_bb1__23__23_continuation_2d_fs() { // ##continuation-fs
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_fs);
  }
  " R1 " = " R1 ".frame[0].fs;
  return " R0 ";
}

Gambit_glo[\"##continuation-fs\"] = Gambit_bb1__23__23_continuation_2d_fs;


function Gambit_bb1__23__23_frame_2d_fs() { // ##frame-fs
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_frame_2d_fs);
  }
  " R1 " = " R1 "[0].fs;
  return " R0 ";
}

Gambit_glo[\"##frame-fs\"] = Gambit_bb1__23__23_frame_2d_fs;


function Gambit_bb1__23__23_return_2d_fs() { // ##return-fs
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_return_2d_fs);
  }
  " R1 " = " R1 ".fs;
  return " R0 ";
}

Gambit_glo[\"##return-fs\"] = Gambit_bb1__23__23_return_2d_fs;


function Gambit_bb1__23__23_continuation_2d_link() { // ##continuation-link
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_link);
  }
  " R1 " = " R1 ".frame[0].link-1;
  return " R0 ";
}

Gambit_glo[\"##continuation-link\"] = Gambit_bb1__23__23_continuation_2d_link;


function Gambit_bb1__23__23_frame_2d_link() { // ##frame-link
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_frame_2d_link);
  }
  " R1 " = " R1 "[0].link-1;
  return " R0 ";
}


function Gambit_bb1__23__23_continuation_2d_ret() { // ##continuation-ret
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_ret);
  }
  " R1 " = " R1 ".frame[0];
  return " R0 ";
}

Gambit_glo[\"##continuation-ret\"] = Gambit_bb1__23__23_continuation_2d_ret;


function Gambit_bb1__23__23_frame_2d_ret() { // ##frame-ret
  if (Gambit_nargs !== 1) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_frame_2d_ret);
  }
  " R1 " = " R1 "[0];
  return " R0 ";
}

Gambit_glo[\"##frame-ret\"] = Gambit_bb1__23__23_frame_2d_ret;


function Gambit_bb1__23__23_continuation_2d_ref() { // ##continuation-ref
  if (Gambit_nargs !== 2) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_ref);
  }
  " R1 " = " R1 ".frame[" R2 "];
  return " R0 ";
}

Gambit_glo[\"##continuation-ref\"] = Gambit_bb1__23__23_continuation_2d_ref;


function Gambit_bb1__23__23_frame_2d_ref() { // ##frame-ref
  if (Gambit_nargs !== 2) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_frame_2d_ref);
  }
  " R1 " = " R1 "[" R2 "];
  return " R0 ";
}

Gambit_glo[\"##frame-ref\"] = Gambit_bb1__23__23_frame_2d_ref;


function Gambit_bb1__23__23_continuation_2d_slot_2d_live_3f_() { // ##continuation-slot-live?
  if (Gambit_nargs !== 2) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_continuation_2d_slot_2d_live_3f_);
  }
  " R1 " = true;
  return " R0 ";
}

Gambit_glo[\"##continuation-slot-live?\"] = Gambit_bb1__23__23_continuation_2d_slot_2d_live_3f_;


function Gambit_bb1__23__23_frame_2d_slot_2d_live_3f_() { // ##frame-slot-live?
  if (Gambit_nargs !== 2) {
    return Gambit_wrong_nargs(Gambit_bb1__23__23_frame_2d_slot_2d_live_3f_);
  }
  " R1 " = true;
  return " R0 ";
}

Gambit_glo[\"##frame-slot-live?\"] = Gambit_bb1__23__23_frame_2d_slot_2d_live_3f_;


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

Gambit_glo[\"##continuation-next\"] = Gambit_bb1__23__23_continuation_2d_next;


function Gambit_run(pc)
{
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
  return Gambit_reg[0]

Gambit_glo["println"] = Gambit_bb1_println


def Gambit_poll(wakeup):
  return wakeup


def Gambit_run(pc):
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


def Gambit_run(pc)
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

    (else
     (compiler-internal-error
      "runtime-system, unknown target"))))

(define (entry-point ctx main-proc)
  (let ((entry (lbl->id ctx 1 (proc-obj-name main-proc))))
    (gen "\n"
         (univ-comment ctx "--------------------------------\n")
         "\n"

         (case (target-name (ctx-target ctx))

           ((js php)
            (gen (univ-prefix ctx "run") "(" entry ");\n"))

           ((python ruby)
            (gen (univ-prefix ctx "run") "(" entry ")\n"))

           (else
            (compiler-internal-error
             "entry-point, unknown target"))))))

;;;----------------------------------------------------------------------------

(define (univ-global ctx name)
  (case (target-name (ctx-target ctx))

    ((js python php) name)

    ((ruby) (gen "$" name))

    (else
     (compiler-internal-error
      "univ-global, unknown target"))))

(define (univ-function ctx name params header body)
  (case (target-name (ctx-target ctx))

    ((js php)
     (gen "function " name "(" params ") {" header body "}\n"))

    ((python)
     (gen "def " name "(" params "):\n"
          (univ-indent (gen "global "
                            (univ-prefix ctx "glo") ","
                            (univ-prefix ctx "reg") ","
                            (univ-prefix ctx "stack") ","
                            (univ-prefix ctx "sp") ","
                            (univ-prefix ctx "nargs") ","
                            (univ-prefix ctx "temp1") ","
                            (univ-prefix ctx "temp2")))
          header
          body))

    ((ruby)
     (univ-assign ctx
                  name
                  (gen "lambda {"
                       (if (equal? params "")
                           (gen "")
                           (gen "|" params "|"))
                       header
                       body
                       "}")))

    (else
     (compiler-internal-error
      "univ-function, unknown target"))))

(define (univ-rec-function ctx name params header body)
  (case (target-name (ctx-target ctx))

    ((js)
     (gen "(function () {\n"
          (univ-indent
           (gen (univ-function ctx name header body)
                (univ-return ctx name)))
          "})()"))

    ((python)
     (gen "(lambda:\n"
          (univ-indent
           (gen (univ-function ctx name header body)
                (univ-return ctx name)))
          ")()"))

    ((ruby)
     "???")

    (else
     (compiler-internal-error
      "univ-rec-function, unknown target"))))

(define (univ-comment ctx comment)
  (case (target-name (ctx-target ctx))

    ((js php)
     (gen "// " comment))

    ((python ruby)
     (gen "# " comment))

    (else
     (compiler-internal-error
      "univ-comment, unknown target"))))

(define (univ-return ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (gen "return " expr ";\n"))

    ((python ruby)
     (gen "return " expr "\n"))

    (else
     (compiler-internal-error
      "univ-return, unknown target"))))

(define (makecall ctx name args)
    (apply univ-call (cons ctx (cons name args))))

(define (univ-call ctx name . params)
  (case (target-name (ctx-target ctx))

    ((js)
     (letrec ((addcommas
               (lambda (lst res)
                 (if (null? lst)
                     (reverse res)
                     (if (= (length lst) 1)
                         (addcommas (cdr lst) (cons (car lst) res))
                         (addcommas (cdr lst) (append (list ", " (car lst)) res)))))))
       (gen name "("
            (apply gen (addcommas params '()))
            ")")))
    
    ((python ruby php)                ;TODO: complete
     (gen ""))

    (else
     (compiler-internal-error
      "univ-call, unknown target"))))

(define (univ-poll ctx expr poll?)
  (if poll?
      (univ-call ctx (univ-prefix ctx "poll") expr)
      expr))

(define (univ-throw ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (gen "throw " expr ";\n"))

    ((python ruby)
     (gen "raise " expr "\n"))

    (else
     (compiler-internal-error
      "univ-throw, unknown target"))))

(define (univ-eq ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (gen expr1 " === " expr2))

    ((python)
     (gen expr1 " is " expr2))

    ((ruby)
     (gen expr1 " .equal?(" expr2 ")"))

    ((php)
     (gen expr1 " == " expr2))

    (else
     (compiler-internal-error
      "univ-eq, unknown target"))))

(define (univ-and ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js ruby php)
     (gen "(" expr1 " && " expr2 ")"))

    ((python)
     (gen "(" expr1 " and " expr2 ")"))

    (else
     (compiler-internal-error
      "univ-and, unknown target"))))

(define (univ-or ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js ruby php)
     (gen "(" expr1 " || " expr2 ")"))

    ((python)
     (gen "(" expr1 " or " expr2 ")"))

    (else
     (compiler-internal-error
      "univ-or, unknown target"))))

(define (univ-< ctx expr1 expr2)
  (gen expr1 " < " expr2))

(define (univ-<= ctx expr1 expr2)
  (gen expr1 " <= " expr2))

(define (univ-> ctx expr1 expr2)
  (gen expr1 " > " expr2))

(define (univ->= ctx expr1 expr2)
  (gen expr1 " >= " expr2))

(define (univ-= ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (gen expr1 " === " expr2))

    ((python ruby php)
     (gen expr1 " == " expr2))

    (else
     (compiler-internal-error
      "univ-=, unknown target"))))

(define (univ-not= ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (gen expr1 " !== " expr2))

    ((python ruby php)
     (gen expr1 " != " expr2))

    (else
     (compiler-internal-error
      "univ-not=, unknown target"))))

(define (univ-boolean ctx val)
  (case (target-name (ctx-target ctx))

    ((js ruby php)
     (gen (if val "true" "false")))

    ((python)
     (gen (if val "True" "False")))

    (else
     (compiler-internal-error
      "univ-boolean, unknown target"))))

(define (univ-assign ctx loc expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (gen loc " = " expr ";\n"))

    ((python ruby)
     (gen loc " = " expr "\n"))

    (else
     (compiler-internal-error
      "univ-assign, unknown target"))))

(define (univ-increment ctx loc expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (gen loc " += " expr ";\n"))

    ((python ruby)
     (gen loc " += " expr "\n"))

    (else
     (compiler-internal-error
      "univ-increment, unknown target"))))

(define (univ-expr ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (gen expr ";\n"))

    ((python ruby)
     (gen expr "\n"))

    (else
     (compiler-internal-error
      "univ-expr, unknown target"))))

(define (univ-ifnot-then ctx test true)
  (case (target-name (ctx-target ctx))

    ((js php)
     (gen "if (!(" test ")) {\n"
          (univ-indent true)
          "}\n"))

    ((python)
     (gen "if not " test ":\n"
          (univ-indent true)))

    ((ruby)
     (gen "if not(" test ")\n"
          (univ-indent true)
          "end\n"))

    (else
     (compiler-internal-error
      "univ-ifnot-then, unknown target"))))

(define (univ-if-then ctx test true)
  (case (target-name (ctx-target ctx))

    ((js php)
     (gen "if (" test ") {\n"
          (univ-indent true)
          "}\n"))

    ((python)
     (gen "if " test ":\n"
          (univ-indent true)))

    ((ruby)
     (gen "if " test "\n"
          (univ-indent true)
          "end\n"))

    (else
     (compiler-internal-error
      "univ-if-then, unknown target"))))

(define (univ-if-then-else ctx test true false)
  (case (target-name (ctx-target ctx))

    ((js php)
     (gen "if (" test ") {\n"
          (univ-indent true)
          "} else {\n"
          (univ-indent false)
          "}\n"))

    ((python)
     (gen "if " test ":\n"
          (univ-indent true)
          "else:\n"
          (univ-indent false)))

    ((ruby)
     (gen "if " test "\n"
          (univ-indent true)
          "else\n"
          (univ-indent false)
          "end\n"))

    (else
     (compiler-internal-error
      "univ-if-then-else, unknown target"))))

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
                     (univ-expr ctx
                                (apply-gen ctx opnds))
                     (gen "")))))))

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
             (gen obj))
            (else
             (compiler-internal-error
              "translate-obj, unsupported exact number:" obj)))
      (cond ((real? obj)
             (let ((x
                    (if (integer? obj)
                        (gen obj 0)
                        (gen obj))))
               (case (target-name (ctx-target ctx))
                 ((js)
                  (gen "new " (univ-prefix ctx "Flonum") "(" x ")"))
                 (else
                  x))))
            (else
             (compiler-internal-error
              "translate-obj, unsupported inexact number:" obj)))))

(define (univ-char ctx obj)
  (let ((code (char->integer obj)))
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "Char.fxToChar")
            "("
            code
            ")"))

      ((python ruby)
       (gen (univ-prefix ctx "fxToChar")
            "("
            code
            ")"))

      ((php) (gen code))                ;TODO: complete

      (else
       (compiler-internal-error
        "univ-char, unknown target")))))

(define (univ-string ctx obj)

  (case (target-name (ctx-target ctx))

    ((js)
     (gen "new "
          (makecall ctx
                    (univ-prefix ctx "String")
                    (map (lambda (ch) (univ-char ctx ch))
                         (string->list obj)))))

    ((python)
     (gen (univ-prefix ctx "String")
          "(*list(unicode("
          (object->string obj)
          ")))"))

    ((ruby php)                         ;TODO: complete
     (gen (object->string obj)))

    (else
     (compiler-internal-error
      "univ-string, unknown target"))))

(define (univ-null ctx obj)
  (case (target-name (ctx-target ctx))

    ((js)
     (gen "null"))
    
    ((python)
     (gen "None"))

    ((ruby)
     (gen "nil"))

    ((php)                                ;TODO: complete
     (gen ""))

    (else
     (compiler-internal-error
      "univ-null, unknown target"))))

(define (univ-list ctx obj)             ;obj is a non-null list
  
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

    ((js python)
     (let ((tobj (map (lambda (o) (translate-obj ctx o))
                      obj))
           (sep (make-list (- (length obj) 1) ", ")))
       (gen (univ-prefix ctx "List(")
            (apply gen (zip tobj sep))
            ")")))
    
    ((python ruby php)                         ;TODO: complete
     (gen (object->string obj)))

    (else
     (compiler-internal-error
      "univ-list, unknown target"))))

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

             (gen "new " (univ-prefix ctx "Vector(")
                  (apply gen (zip tobj sep))
                  ")"))
           (gen "new " (univ-prefix ctx "Vector()")))))
    
    ((python ruby php)                         ;TODO: complete
     (gen (object->string obj)))

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
    (gen (translate-gvm-opnd ctx (list-ref opnds 0))
         " + "
         (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim "##fx-" #f #f

  (lambda (ctx opnds)
    (gen (translate-gvm-opnd ctx (list-ref opnds 0))
         " - "
         (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim "##fx*" #f #f

  (lambda (ctx opnds)
    (gen (translate-gvm-opnd ctx (list-ref opnds 0))
         " * "
         (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim-bool "##fx<" #f #f

  (lambda (ctx opnds)
    (univ-< ctx
            (translate-gvm-opnd ctx (list-ref opnds 0))
            (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim-bool "##fx<=" #f #f

  (lambda (ctx opnds)
    (univ-<= ctx
             (translate-gvm-opnd ctx (list-ref opnds 0))
             (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim-bool "##fx>" #f #f

  (lambda (ctx opnds)
    (univ-> ctx
            (translate-gvm-opnd ctx (list-ref opnds 0))
            (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim-bool "##fx>=" #f #f

  (lambda (ctx opnds)
    (univ->= ctx
             (translate-gvm-opnd ctx (list-ref opnds 0))
             (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim-bool "##fx=" #f #f

  (lambda (ctx opnds)
    (univ-= ctx
            (translate-gvm-opnd ctx (list-ref opnds 0))
            (translate-gvm-opnd ctx (list-ref opnds 1)))))

(univ-define-prim "##fx+?" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen "(temp2 = (temp1 = "
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " + "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits
            ") === temp1 && temp2"))

      ((python)
       (gen "(lambda temp1: (lambda temp2: temp1 == temp2 and temp2)(ctypes.c_int32(temp1<<"
            univ-tag-bits
            ").value>>"
            univ-tag-bits
            "))("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " + "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")"))

      ((ruby php)
       (gen "(temp2 = (((temp1 = "
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
       (gen "(temp2 = (temp1 = "
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " - "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits
            ") === temp1 && temp2"))

      ((python)
       (gen "(lambda temp1: (lambda temp2: temp1 == temp2 and temp2)(ctypes.c_int32(temp1<<"
            univ-tag-bits
            ").value>>"
            univ-tag-bits
            "))("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " - "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")"))

      ((ruby php)
       (gen "(temp2 = (((temp1 = "
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
       (gen "("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " + "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits))

      ((python)
       (gen "ctypes.c_int32(("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " + "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")<<"
            univ-tag-bits
            ").value>>"
            univ-tag-bits))

      ((ruby php)
       (gen "((("
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
       (gen "("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " - "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits))

      ((python)
       (gen "ctypes.c_int32(("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " - "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")<<"
            univ-tag-bits
            ").value>>"
            univ-tag-bits))

      ((ruby php)
       (gen "((("
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
       ;; TODO: fix this JS code, which does not work when the result of the multiplication is more than 52 bits (due to JS's use of 64 IEEE floats)
       ;; idea: detect the special case of a constant in either operands that is less than 22 bits (because a multiplication of a 30 bit fixnum integer and 22 bit integer will fit in 52 bits)
       (gen "("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " * "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")<<"
            univ-tag-bits
            ">>"
            univ-tag-bits))

      ((python)
       (gen "ctypes.c_int32(("
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
       (gen "((("
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



(univ-define-prim-bool "##null?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen "("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " === null)"))
      
      ((python)
       (gen "("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " is None)"))
      
      ((ruby)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            ".equal?(nil)"))

      ((php)                       ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##null?, unknown target")))))

(univ-define-prim "##cons" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen "new "
            (univ-prefix ctx "Pair")
            "("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ", "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cons, unknown target")))))

(define (univ-car ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     #;
     (gen (univ-prefix ctx "car(")
          expr
          ")")
     (gen expr
          ".car"))

    ((python ruby php)                ;TODO: complete
     (gen ""))

    (else
     (compiler-internal-error
      "univ-car, unknown target"))))

(define (univ-cdr ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     #;
     (gen (univ-prefix ctx "cdr(")
          expr
          ")")
     (gen expr
          ".cdr"))

    ((python ruby php)                ;TODO: complete
     (gen ""))

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

// ##caar
(univ-define-prim "##caar" #f #f

  (lambda (ctx opnds)
    (univ-car ctx
              (univ-car ctx
                        (translate-gvm-opnd ctx (list-ref opnds 0))))))

// ##cadr
(univ-define-prim "##cadr" #f #f

  (lambda (ctx opnds)
    (univ-car ctx
              (univ-cdr ctx
                        (translate-gvm-opnd ctx (list-ref opnds 0))))))

// ##cdar
(univ-define-prim "##cdar" #f #f

  (lambda (ctx opnds)
    (univ-cdr ctx
              (univ-car ctx
                        (translate-gvm-opnd ctx (list-ref opnds 0))))))

// ##cddr
(univ-define-prim "##cddr" #f #f

  (lambda (ctx opnds)
    (univ-cdr ctx
              (univ-cdr ctx
                        (translate-gvm-opnd ctx (list-ref opnds 0))))))

// ##caaar
(univ-define-prim "##caaar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "caaar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##caaar, unknown target")))))

// ##caadr
(univ-define-prim "##caadr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "caadr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##caadr, unknown target")))))

// ##cadar
(univ-define-prim "##cadar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cadar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cadar, unknown target")))))

// ##caddr
(univ-define-prim "##caddr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "caddr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##caddr, unknown target")))))

// ##cdaar
(univ-define-prim "##cdaar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cdaar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cdaar, unknown target")))))

// ##cdadr
(univ-define-prim "##cdadr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cdadr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cdadr, unknown target")))))

// ##cddar
(univ-define-prim "##cddar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cddar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cddar, unknown target")))))

// ##cdddr
(univ-define-prim "##cdddr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cdddr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cdddr, unknown target")))))

// ##caaaar
(univ-define-prim "##caaaar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "caaaar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##caaaar, unknown target")))))

// ##caaadr
(univ-define-prim "##caaadr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "caaadr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##caaadr, unknown target")))))

// ##caadar
(univ-define-prim "##caadar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "caadar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##caadar, unknown target")))))

// ##caaddr
(univ-define-prim "##caaddr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "caaddr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##caaddr, unknown target")))))

// ##cadaar
(univ-define-prim "##cadaar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cadaar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cadaar, unknown target")))))

// ##cadadr
(univ-define-prim "##cadadr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cadadr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cadadr, unknown target")))))

// ##caddar
(univ-define-prim "##caddar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "caddar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##caddar, unknown target")))))

// ##cadddr
(univ-define-prim "##cadddr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cadddr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cadddr, unknown target")))))

// ##cdaaar
(univ-define-prim "##cdaaar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cdaaar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cdaaar, unknown target")))))

// ##cdaadr
(univ-define-prim "##cdaadr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cdaadr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cdaadr, unknown target")))))

// ##cdadar
(univ-define-prim "##cdadar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cdadar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cdadar, unknown target")))))

// ##cdaddr
(univ-define-prim "##cdaddr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cdaddr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cdaddr, unknown target")))))

// ##cddaar
(univ-define-prim "##cddaar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cddaar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cddaar, unknown target")))))

// ##cddadr
(univ-define-prim "##cddadr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cddadr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cddadr, unknown target")))))

// ##cdddar
(univ-define-prim "##cdddar" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cdddar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cdddar, unknown target")))))

// ##cddddr
(univ-define-prim "##cddddr" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "cddddr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##cddddr, unknown target")))))

(univ-define-prim "##set-car!" #f #t

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "setcar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ", "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##set-car!, unknown target")))))

(univ-define-prim "##set-cdr!" #f #t

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "setcdr(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ", "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")"))
      
      ;; ((python)
      ;;  (gen ""))

      ;; ((ruby)
      ;;  (gen ""))

      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##set-cdr!, unknown target")))))

(univ-define-prim "##list" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (let ((nbopnd (length opnds)))
         (if (= nbopnd 0)
             (gen "null")
             (let ((args (list (univ-prefix ctx "List(")
                               (translate-gvm-opnd ctx (list-ref opnds 0)))))
               (let loop ((opnd 1)
                          (args args))
                 (if (= opnd nbopnd)
                     (apply gen (append args '(")")))
                     (loop (+ opnd 1)
                           (append args
                                   (list ", "
                                         (translate-gvm-opnd ctx (list-ref opnds opnd)))))))))))
      
      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##list, unknown target")))))

(univ-define-prim "##vector" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (let ((nbopnd (length opnds)))
         (if (= nbopnd 0)
             (gen "new " (univ-prefix ctx "Vector()"))
             (let ((args (list "new "
                               (univ-prefix ctx "Vector(")
                               (translate-gvm-opnd ctx (list-ref opnds 0)))))
               (let loop ((opnd 1)
                          (args args))
                 (if (= opnd nbopnd)
                     (apply gen (append args '(")")))
                     (loop (+ opnd 1)
                           (append args
                                   (list ", "
                                         (translate-gvm-opnd ctx (list-ref opnds opnd)))))))))))
      
      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##vector, unknown target")))))

(univ-define-prim "##vector-ref" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            ".vectorref("
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")"))
       
      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##vector-ref, unknown target")))))

(univ-define-prim "##vector-set!" #f #t

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            ".vectorset("
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ", "
            (translate-gvm-opnd ctx (list-ref opnds 2))
            ")"))
      
      ((python)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            "["
            (translate-gvm-opnd ctx (list-ref opnds 1))
            "] = "
            (translate-gvm-opnd ctx (list-ref opnds 2))))
      
      ((ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##vector-set!, unknown target")))))

(univ-define-prim "##string" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen "new "
            (makecall ctx
                      (univ-prefix ctx "String")
                      ;; (list (translate-gvm-opnd ctx (list-ref opnds 0)))
                      (map (lambda (opnd) (translate-gvm-opnd ctx opnd))
                           opnds)
                      )))
      
      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##string, unknown target")))))

;;(univ-define-prim "string-append" #f #f (lambda (ctx opnds) (gen "")))

(univ-define-prim "string-append" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (makecall ctx
                      (univ-prefix ctx "stringappend")                      
                      (map (lambda (opnd) (translate-gvm-opnd ctx opnd))
                           opnds)
                      )))
      
      ((python ruby php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##string-append, unknown target")))))

(univ-define-prim "##make-string" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "String.makestring")
            "("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ", "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")"))
      
      ((python)
       (gen (univ-prefix ctx "makestring")
            "("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ", "
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ")"))

      ((ruby)
       (gen (translate-gvm-opnd ctx (list-ref opnds 1))
            ".code.chr*"
            (translate-gvm-opnd ctx (list-ref opnds 0))))

      ((php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##make-string, unknown target")))))

(univ-define-prim "##string-set!" #f #t

  (lambda (ctx opnds)
    (display "##string-set!")(newline)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            ".stringset("
            (translate-gvm-opnd ctx (list-ref opnds 1))
            ", "
            (translate-gvm-opnd ctx (list-ref opnds 2))
            ")"))
      
      ((python)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            "["
            (translate-gvm-opnd ctx (list-ref opnds 1))
            "] = "
            (translate-gvm-opnd ctx (list-ref opnds 2))))
      
      ((ruby)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            "["
            (translate-gvm-opnd ctx (list-ref opnds 1))
            "] = "
            (translate-gvm-opnd ctx (list-ref opnds 2))
            ".code.chr"))

      ((php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##string-set!, unknown target")))))

(univ-define-prim "##string-ref" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

       ((js)
        (gen (translate-gvm-opnd ctx (list-ref opnds 0))
             ".stringref(" (translate-gvm-opnd ctx (list-ref opnds 1)) ")"))
        
      ((python)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            "[" (translate-gvm-opnd ctx (list-ref opnds 1)) "]"))

      ((ruby)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            "[" (translate-gvm-opnd ctx (list-ref opnds 1)) "].chr"))

      ((php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##string-ref, unknown target")))))

(univ-define-prim "##fx->char" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "Char.fxToChar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
       
      ((python ruby)
       (gen (univ-prefix ctx "fxToChar(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))

      ((php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##fx->char, unknown target")))))

(univ-define-prim "##fx<-char" #f #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (univ-prefix ctx "Char.charToFx(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))
       
      ((python ruby)
       (gen (univ-prefix ctx "charToFx(")
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))

      ((php)                ;TODO: complete
       (gen ""))

      (else
       (compiler-internal-error
        "##fx<-char, unknown target")))))

(univ-define-prim-bool "##fixnum?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen "typeof "
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " == \"number\""))

      ((python)
       (gen "isinstance("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ", int) and not "
            "isinstance("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ", bool)"))

      ((ruby)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            ".class == Fixnum"))

      ((php)
       (gen "is_int("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))

      (else
       (compiler-internal-error
        "##fixnum?, unknown target")))))

(univ-define-prim-bool "##flonum?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            " instanceof "
            (univ-prefix ctx "Flonum")))

      ((python)
       (gen "isinstance("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ", float)"))

      ((ruby)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            ".class == Float"))

      ((php)
       (gen "is_float("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ")"))

      (else
       (compiler-internal-error
        "##flonum?, unknown target")))))

(univ-define-prim-bool "##char?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js php)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            " instanceof "
            (univ-prefix ctx "Char")))

      ((python)
       (gen "isinstance("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ", "
            (univ-prefix ctx "Char)")))

      ((ruby)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            ".class == "
            (univ-prefix ctx "Char")))
      
      (else
       (compiler-internal-error
        "##char?, unknown target")))))

(univ-define-prim-bool "##pair?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js php)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            " instanceof "
            (univ-prefix ctx "Pair")))

      ((python)
       (gen "isinstance("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ", "
            (univ-prefix ctx "Pair)")))
      
      ((ruby)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            ".class == "
            (univ-prefix ctx "Pair")))

      (else
       (compiler-internal-error
        "##pair?, unknown target")))))

(univ-define-prim-bool "##string?" #t #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js php)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            " instanceof "
            (univ-prefix ctx "String")))

      ((python)
       (gen "isinstance("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ", "
            (univ-prefix ctx "String)")))

      ((ruby)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            ".class == "
            (univ-prefix ctx "String")))

      (else
       (compiler-internal-error
        "##string?, unknown target")))))

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
          (gen (univ-return
                ctx
                (univ-poll
                 ctx
                 (gen (univ-prefix ctx
                                   (string-append name
                                                  (number->string nb-args)))
                      "()")
                 poll?)))))))

;;;============================================================================
