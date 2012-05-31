;;;============================================================================

;;; File: "_t-univ.scm"

;;; Copyright (c) 2011-2012 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")

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
  (let ((targ (make-target 7 target-language 0)))

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

(define univ-frame-reserve 3) ;; when the stack frame is transformed to a
                              ;; heap frame, 3 extra slots are needed to
                              ;; store the subtype object header, the link
                              ;; to the next frame and the return address.

(define univ-frame-alignment 4) ;; align frame to multiple of 4 slots

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
  #f)

;; ***** DUMPING OF A COMPILATION MODULE

(define (univ-dump targ procs output c-intf script-line options)

  (call-with-output-file
      output
    (lambda (port)

      (univ-display
       (runtime-system targ)
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
            (gen "\n"
                 "function "
                 (lbl->id ctx (label-lbl-num gvm-instr) (ctx-ns ctx))
                 "() {"

                 (univ-indent

                  (case (label-type gvm-instr)

                    ((simple)
                     (gen "\n"))

                    ((entry)
                     (gen (if (label-entry-closed? gvm-instr)
                              " // closure-entry-point\n"
                              " // entry-point\n")
                          "if (nargs !== " (label-entry-nb-parms gvm-instr) ") "
                          "throw \"wrong number of arguments\";\n\n"))

                    ((return)
                     (gen " // return-point\n"))

                    ((task-entry)
                     (gen " // task-entry-point\n"
                          "throw \"task-entry-point GVM label unimplemented\";\n"))

                    ((task-return)
                     (gen " // task-return-point\n"
                          "throw \"task-return-point GVM label unimplemented\";\n"))

                    (else
                     (compiler-internal-error
                      "scan-gvm-label, unknown label type")))

                  (with-stack-base-offset
                   ctx
                   (- (frame-size (gvm-instr-frame gvm-instr)))
                   (lambda (ctx)
                     (proc ctx))));;;;;;;;;;;;;;;;;;;;;;

                 "}\n"))

          (define (scan-gvm-instr ctx gvm-instr)

            ;; TODO: combine with scan-gvm-opnd
            (define (scan-opnd gvm-opnd)
              (cond ((not gvm-opnd))
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
               ;; TODO
               ;; (close-parms gvm-instr)
               (gen "throw \"close GVM instruction unimplemented\";\n"))

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

                       (univ-if
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
               (gen "throw \"switch GVM instruction unimplemented\";\n"))

              ((jump)
               ;; TODO
               ;; (jump-safe? gvm-instr)
               ;; test: (jump-poll? gvm-instr)
               (gen (let ((nb-args (jump-nb-args gvm-instr)))
                      (if nb-args
                          (univ-assign ctx "nargs" nb-args)
                          ""))
                    (with-stack-pointer-adjust
                     ctx
                     (+ (frame-size (gvm-instr-frame gvm-instr))
                        (ctx-stack-base-offset ctx))
                     (lambda (ctx)
                       (let ((opnd (jump-opnd gvm-instr)))
                         (if (jump-poll? gvm-instr)
                             (gen (univ-assign ctx "save_pc" (scan-gvm-opnd ctx opnd))
                                  "return null;\n")
                             (gen "return " (scan-gvm-opnd ctx opnd) ";\n")))))))

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
                      (gen "return " (scan-gvm-opnd ctx (make-lbl n)) ";\n"))))))

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

      (gen "\n// -------------------------------- #<"
           (if (proc-obj-primitive? p)
               "primitive"
               "procedure")
           " "
           (object->string (string->canonical-symbol (proc-obj-name p)))
           "> =\n"
           (let ((x (proc-obj-code p)))
             (if (bbs? x)
                 (scan-bbs x)
                 (gen "")))))

    (for-each scan-obj procs)

    (let loop ((rev-res '()))
      (if (queue-empty? proc-left)

          (univ-display
           (reverse rev-res)
           port)

          (loop (cons (dump-proc (queue-get! proc-left))
                      rev-res))))))

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
           (univ-increment ctx "sp" n))
       (with-stack-base-offset
        ctx
        (- (ctx-stack-base-offset ctx) n)
        proc)))

(define (translate-gvm-opnd ctx gvm-opnd)

  (cond ((not gvm-opnd)
         (gen "NO_OPERAND"))

        ((reg? gvm-opnd)
         (gen "reg["
              (reg-num gvm-opnd)
              "]"))

        ((stk? gvm-opnd)
         (let ((n (+ (stk-num gvm-opnd) (ctx-stack-base-offset ctx))))
           (gen "stack[sp"
                (cond ((= n 0)
                       (gen ""))
                      ((< n 0)
                       (gen n))
                      (else
                       (gen "+" n)))
                "]")))

        ((glo? gvm-opnd)
         (gen "glo["
              (object->string (symbol->string (glo-name gvm-opnd)))
              "]"))

        ((clo? gvm-opnd)
         (gen (translate-gvm-opnd ctx (clo-base gvm-opnd))
              "["
              (clo-index gvm-opnd)
              "]"))

        ((lbl? gvm-opnd)
         (translate-lbl ctx gvm-opnd))

        ((obj? gvm-opnd)
         (let ((val (obj-val gvm-opnd)))
           (cond ((number? val)
                  (gen val))
                 ((void-object? val)
                  (gen "undefined"))
                 ((proc-obj? val)
                  (lbl->id ctx 1 (proc-obj-name val)))
                 (else
                  (gen "UNIMPLEMENTED_OBJECT("
                       (object->string val)
                       ")")))))

        (else
         (compiler-internal-error
          "translate-gvm-opnd, unknown 'gvm-opnd':"
          gvm-opnd))))

(define (translate-lbl ctx lbl)
  (lbl->id ctx (lbl-num lbl) (ctx-ns ctx)))

(define (lbl->id ctx num ns)
  (gen "lbl" num "_" (scheme-id->c-id ns)))

(define (runtime-system targ)
#<<EOF
var glo = {};
var reg = [null];
var stack = [];
var sp = -1;
var nargs = 0;
var save_pc = null;
var poll;

if (this.hasOwnProperty('setTimeout')) {
  poll = function (wakeup) { setTimeout(wakeup,1); return true; };
} else {
  poll = function (wakeup) { return false; };
}


function lbl1_print() { // print
  if (nargs !== 1) throw "wrong number of arguments";
  print(reg[1]);
  return reg[0];
}

glo["print"] = lbl1_print;


function run()
{
  while (save_pc !== null) {
    pc = save_pc;
    save_pc = null;
    while (pc !== null)
      pc = pc();
    if (poll(run)) break;
  }
}

EOF
)

(define (entry-point ctx main-proc)
  (gen "\n// --------------------------------\n\n"
       (univ-assign ctx "save_pc" (lbl->id ctx 1 (proc-obj-name main-proc)))
       "run();\n"))

;;;----------------------------------------------------------------------------

(define (univ-assign ctx loc expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (gen loc " = " expr ";\n"))

    ((python)
     (gen loc " = " expr "\n"))

    (else
     (compiler-internal-error
      "univ-assign, unknown target"))))

(define (univ-increment ctx loc expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (gen loc " += " expr ";\n"))

    ((python)
     (gen loc " += " expr "\n"))

    (else
     (compiler-internal-error
      "univ-increment, unknown target"))))

(define (univ-expr ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (gen expr ";\n"))

    ((python)
     (gen expr "\n"))

    (else
     (compiler-internal-error
      "univ-expr, unknown target"))))

(define (univ-if ctx test true false)
  (case (target-name (ctx-target ctx))

    ((js)
     (gen "if ("
          test
          ") {\n"
          (univ-indent true)
          "} else {\n"
          (univ-indent false)
          "}\n"))

    ((python)
     (gen "if ("
          test
          "):\n"
          (univ-indent true)
          "else:\n"
          (univ-indent false)))

    (else
     (compiler-internal-error
      "univ-if, unknown target"))))

(define (univ-define-prim name proc-safe? side-effects? apply-gen ifjump-gen)
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
             (ifjump-gen ctx opnds)))))))

;;; Primitive procedures

(univ-define-prim "##not" #f #f

  (lambda (ctx opnds)
    (gen (translate-gvm-opnd ctx (list-ref opnds 0))
         " === false"))

  (lambda (ctx opnds)
    (gen (translate-gvm-opnd ctx (list-ref opnds 0))
         " === false")))

(univ-define-prim "fx+" #f #f

  (lambda (ctx opnds)
    (gen (translate-gvm-opnd ctx (list-ref opnds 0))
         " + "
         (translate-gvm-opnd ctx (list-ref opnds 1))))

  #f)

(univ-define-prim "fx-" #f #f

  (lambda (ctx opnds)
    (gen (translate-gvm-opnd ctx (list-ref opnds 0))
         " - "
         (translate-gvm-opnd ctx (list-ref opnds 1))))

  #f)

(univ-define-prim "fx<" #f #f

  #f

  (lambda (ctx opnds)
    (gen (translate-gvm-opnd ctx (list-ref opnds 0))
         " < "
         (translate-gvm-opnd ctx (list-ref opnds 1)))))

;;;============================================================================
