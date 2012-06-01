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
            (univ-function

             ctx

             (lbl->id ctx (label-lbl-num gvm-instr) (ctx-ns ctx))

             (univ-indent
              (case (label-type gvm-instr)

                ((simple)
                 (gen "\n"))

                ((entry)
                 (gen " "
                      (univ-comment
                       ctx
                       (if (label-entry-closed? gvm-instr)
                           "closure-entry-point\n"
                           "entry-point\n"))
                      (univ-if-then
                       ctx
                       (univ-ne ctx
                                (univ-global ctx "nargs")
                                (label-entry-nb-parms gvm-instr))
                       (univ-throw ctx "\"wrong number of arguments\""))))

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
                 (proc ctx))))))

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
               (univ-throw ctx "\"close GVM instruction unimplemented\""))

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
               (gen (let ((nb-args (jump-nb-args gvm-instr)))
                      (if nb-args
                          (univ-assign ctx (univ-global ctx "nargs") nb-args)
                          ""))
                    (with-stack-pointer-adjust
                     ctx
                     (+ (frame-size (gvm-instr-frame gvm-instr))
                        (ctx-stack-base-offset ctx))
                     (lambda (ctx)
                       (let ((opnd (jump-opnd gvm-instr)))
                         (univ-return
                          ctx
                          (if (jump-poll? gvm-instr)
                              (gen "poll(" (scan-gvm-opnd ctx opnd) ")")
                              (scan-gvm-opnd ctx opnd))))))))

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
           (univ-increment ctx (univ-global ctx "sp") n))
       (with-stack-base-offset
        ctx
        (- (ctx-stack-base-offset ctx) n)
        proc)))

(define (translate-gvm-opnd ctx gvm-opnd)

  (cond ((not gvm-opnd)
         (gen "NO_OPERAND"))

        ((reg? gvm-opnd)
         (gen (univ-global ctx "reg")
              "["
              (reg-num gvm-opnd)
              "]"))

        ((stk? gvm-opnd)
         (let ((n (+ (stk-num gvm-opnd) (ctx-stack-base-offset ctx))))
           (gen (univ-global ctx "stack")
                "["
                (univ-global ctx "sp")
                (cond ((= n 0)
                       (gen ""))
                      ((< n 0)
                       (gen n))
                      (else
                       (gen "+" n)))
                "]")))

        ((glo? gvm-opnd)
         (gen (univ-global ctx "glo")
              "["
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
  (univ-global ctx (gen "lbl" num "_" (scheme-id->c-id ns))))

(define (runtime-system targ)
  (case (target-name targ)

    ((js)
#<<EOF
var glo = {};
var reg = [false];
var stack = [];
var sp = -1;
var nargs = 0;
var temp1 = false;
var temp2 = false;
var poll;

if (this.hasOwnProperty('setTimeout')) {
  poll = function (wakeup) { setTimeout(function () { run(wakeup); }, 1); return false; };
} else {
  poll = function (wakeup) { return wakeup; };
}


function Flonum(val) {
  this.val = val;
}


function lbl1_println() { // println
  if (nargs !== 1)
    throw "wrong number of arguments";
  print(reg[1]);
  return reg[0];
}

glo["println"] = lbl1_println;


function run(pc)
{
  while (pc !== false)
    pc = pc();
}

EOF
)

    ((python)
#<<EOF
#! /usr/bin/python

import ctypes

glo = {}
reg = {0:False}
stack = {}
sp = -1
nargs = 0
temp1 = False
temp2 = False


def lbl1_println(): # println
  global glo, reg, stack, sp, nargs, temp1, temp2
  if nargs != 1:
    raise "wrong number of arguments"
  print(reg[1])
  return reg[0]

glo["println"] = lbl1_println


def poll(wakeup):
  return wakeup


def run(pc):
  while pc != False:
    pc = pc()

EOF
)

    ((ruby)
#<<EOF
$glo = {}
$reg = {0=>false}
$stack = {}
$sp = -1
$nargs = 0
$temp1 = false
$temp2 = false


$lbl1_println = lambda { # println
  if $nargs != 1
    raise "wrong number of arguments"
  end
  print($reg[1])
  print("\n")
  return $reg[0]
}

$glo["println"] = $lbl1_println


def poll(wakeup)
  return wakeup
end


def run(pc)
  while pc != false
    pc = pc.call
  end
end

EOF
)

    ((php)
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
            (gen "run(" entry ");\n"))

           ((python ruby)
            (gen "run(" entry ")\n"))

           (else
            (compiler-internal-error
             "entry-point, unknown target"))))))

;;;----------------------------------------------------------------------------

(define (univ-global ctx name)
  (case (target-name (ctx-target ctx))

    ((js python php)
     name)

    ((python ruby)
     (gen "$" name))

    (else
     (compiler-internal-error
      "univ-global, unknown target"))))

(define (univ-function ctx name header body)
  (gen "\n"
       (case (target-name (ctx-target ctx))

         ((js php)
          (gen "function " name "() {" header body "}\n"))

         ((python)
          (gen "def " name "():\n"
               (univ-indent "global glo, reg, stack, sp, nargs, temp1, temp2")
               header
               body))

         ((ruby)
          (univ-assign ctx name (gen "lambda {" header body "}")))

         (else
          (compiler-internal-error
           "univ-function, unknown target")))))

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

    ((python ruby php)
     (gen expr1 " == " expr2))

    (else
     (compiler-internal-error
      "univ-eq, unknown target"))))

(define (univ-ne ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (gen expr1 " !== " expr2))

    ((python ruby php)
     (gen expr1 " != " expr2))

    (else
     (compiler-internal-error
      "univ-ne, unknown target"))))

(define (univ-false ctx)
  (case (target-name (ctx-target ctx))

    ((js ruby php)
     (gen "false"))

    ((python)
     (gen "False"))

    (else
     (compiler-internal-error
      "univ-false, unknown target"))))

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

(let ((fn
       (lambda (ctx opnds)
         (case (target-name (ctx-target ctx))

           ((js ruby php)
            (univ-eq ctx
                     (translate-gvm-opnd ctx (list-ref opnds 0))
                     (univ-false ctx)))

           ((python)
            ;; needed because in Python False == 0 is True
            (gen (univ-eq ctx
                          (translate-gvm-opnd ctx (list-ref opnds 0))
                          (univ-false ctx))
                 " and isinstance("
                 (translate-gvm-opnd ctx (list-ref opnds 0))
                 ", bool)"))

           (else
            (compiler-internal-error
             "##not, unknown target"))))))

  (univ-define-prim "##not" #f #f fn fn))

(univ-define-prim "##fx+" #f #f

  (lambda (ctx opnds)
    (gen (translate-gvm-opnd ctx (list-ref opnds 0))
         " + "
         (translate-gvm-opnd ctx (list-ref opnds 1))))

  #f)

(univ-define-prim "##fx-" #f #f

  (lambda (ctx opnds)
    (gen (translate-gvm-opnd ctx (list-ref opnds 0))
         " - "
         (translate-gvm-opnd ctx (list-ref opnds 1))))

  #f)

(univ-define-prim "##fx*" #f #f

  (lambda (ctx opnds)
    (gen (translate-gvm-opnd ctx (list-ref opnds 0))
         " * "
         (translate-gvm-opnd ctx (list-ref opnds 1))))

  #f)

(univ-define-prim "##fx<" #f #f

  #f

  (lambda (ctx opnds)
    (gen (translate-gvm-opnd ctx (list-ref opnds 0))
         " < "
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
        "##fx+?, unknown target"))))

  #f)

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
        "##fx-?, unknown target"))))

  #f)

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
        "##fxwrap+, unknown target"))))

  #f)

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
        "##fxwrap-, unknown target"))))

  #f)

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
        "##fxwrap*, unknown target"))))

  #f)

(univ-define-prim "##fixnum?" #f #f

  #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen "typeof "
            (translate-gvm-opnd ctx (list-ref opnds 0))
            " == \"number\""))

      ((python)
       (gen "isinstance("
            (translate-gvm-opnd ctx (list-ref opnds 0))
            ", int)"))

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

(univ-define-prim "##flonum?" #f #f

  #f

  (lambda (ctx opnds)
    (case (target-name (ctx-target ctx))

      ((js)
       (gen (translate-gvm-opnd ctx (list-ref opnds 0))
            " instanceof Flonum"))

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

(define univ-tag-bits 2)
(define univ-word-bits 32)

;;;============================================================================
