;;;============================================================================

;;; File: "_t-univ.scm"

(include "fixnum.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

;;;----------------------------------------------------------------------------
;;
;; "Universal" back-end.

;; Initialization/finalization of back-end.

(define (univ-setup target-language)
  (let ((targ (make-target 6 target-language)))

    (define (begin! info-port)

      (target-dump-set!
       targ
       (lambda (procs output output-root c-intf script-line options)
         (univ-dump targ procs output output-root c-intf script-line options)))

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

      #f)

    (define (end!)
      #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)
    (target-add targ)))

(univ-setup 'js)

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
  (table-ref univ-prim-proc-table name #f))

(define univ-prim-proc-table (make-table))

(define (univ-prim-proc-add! x)
  (let ((sym (string->canonical-symbol (car x))))
    (table-set! univ-prim-proc-table
                sym
                (apply make-proc-obj (car x) #f #t #f (cdr x)))))

(for-each univ-prim-proc-add! prim-procs)

(define (univ-switch-testable? targ obj)
  (pretty-print (list 'univ-switch-testable? 'targ obj))
  #f)

;; ***** DUMPING OF A COMPILATION MODULE

(define (univ-dump targ procs output output-root c-intf script-line options)

  (call-with-output-file
      output
    (lambda (port)

      (print
       port: port
       (runtime-system targ))

      (univ-dump-procs targ procs port)

      (print
       port: port
       (entry-point (make-ctx targ #f) (list-ref procs 0)))))

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

    (define (scan-opnd gvm-opnd)
      (cond ((not gvm-opnd))
            ((obj? gvm-opnd)
             (scan-obj (obj-val gvm-opnd)))
            ((clo? gvm-opnd)
             (scan-opnd (clo-base gvm-opnd)))))

    (define (dump-proc p)

      (define (scan-code ctx code)
        (let ((gvm-instr (code-gvm-instr code)))

          (print port: port (translate-gvm-instr ctx gvm-instr))

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
             (scan-opnd (jump-opnd gvm-instr))))))

      (print
       port: port
       (gen "\n// *** #<"
            (if (proc-obj-primitive? p)
                "primitive"
                "procedure")
            " "
            (object->string (string->canonical-symbol (proc-obj-name p)))
            "> =\n"))

      (let ((x (proc-obj-code p)))
        (if (bbs? x)

            (let ((ctx (make-ctx targ (proc-obj-name p))))
              (let loop ((lst (bbs->code-list x)))
                (if (pair? lst)
                    (let* ((code (car lst)))
                      (scan-code ctx code)
                      (loop (cdr lst)))))))))

    (for-each (lambda (proc) (scan-opnd (make-obj proc))) procs)

    (let loop ()
      (if (not (queue-empty? proc-left))
          (begin
            (dump-proc (queue-get! proc-left))
            (loop))))))

(define gen vector)

(define (make-ctx target ns)
  (vector target ns))

(define (ctx-target ctx)        (vector-ref ctx 0))
(define (ctx-target-set! ctx x) (vector-set! ctx 0 x))

(define (ctx-ns ctx)            (vector-ref ctx 1))
(define (ctx-ns-set! ctx x)     (vector-set! ctx 1 x))

(define (translate-gvm-instr ctx gvm-instr)

  (case (gvm-instr-type gvm-instr)

    ((label)
     (gen "\n"
          "function "
          (lbl->id ctx (label-lbl-num gvm-instr) (ctx-ns ctx))
          "() {\n"

          (case (label-type gvm-instr)

            ((simple)
             (gen ""))

            ((entry)
             (gen (if (label-entry-closed? gvm-instr)
                      "// closure-entry-point\n"
                      "// entry-point\n")
                  "if (nargs !== " (label-entry-nb-parms gvm-instr) ") "
                  "throw \"wrong number of arguments\";\n\n"))

            ((return)
             (gen "// return-point\n"))

            ((task-entry)
             (gen "// task-entry-point\n"
                  "throw \"task-entry-point GVM label unimplemented\";\n"))

            ((task-return)
             (gen "// task-return-point\n"
                  "throw \"task-return-point GVM label unimplemented\";\n"))

            (else
             (compiler-internal-error
              "translate-gvm-instr, unknown label type")))

          (sp-adjust ctx (- (frame-size (gvm-instr-frame gvm-instr))) "\n")))

    ((apply)
     (let ((loc (apply-loc gvm-instr))
           (prim (apply-prim gvm-instr))
           (opnds (apply-opnds gvm-instr)))
       (gen (translate-gvm-opnd ctx loc)
            " = "
            (prim-applic ctx prim opnds #f)
            ";\n")))

    ((copy)
     (let ((loc (copy-loc gvm-instr))
           (opnd (copy-opnd gvm-instr)))
       (if opnd
           (gen (translate-gvm-opnd ctx loc)
                " = "
                (translate-gvm-opnd ctx opnd)
                ";\n")
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
           (adj (sp-adjust ctx (frame-size (gvm-instr-frame gvm-instr)) " ")))
       (gen "if ("
            (prim-applic ctx test opnds #t)
            ") "
            "{ " adj "return " (translate-gvm-opnd ctx (make-lbl true)) "; }"
            " else "
            "{ " adj "return " (translate-gvm-opnd ctx (make-lbl false)) "; }"
            "\n}\n")))

    ((switch)
     ;; TODO
     ;; (switch-opnd gvm-instr)
     ;; (switch-cases gvm-instr)
     ;; (switch-poll? gvm-instr)
     ;; (switch-default gvm-instr)
     (gen "throw \"switch GVM instruction unimplemented\";\n"
          "}\n"))

    ((jump)
     ;; TODO
     ;; (jump-safe? gvm-instr)
     ;; test: (jump-poll? gvm-instr) 
     (gen (let ((nb-args (jump-nb-args gvm-instr)))
            (if nb-args
                (gen "nargs = " nb-args ";\n")
                ""))
          (sp-adjust ctx (frame-size (gvm-instr-frame gvm-instr)) "\n")
          (let ((opnd (jump-opnd gvm-instr)))
            (if (jump-poll? gvm-instr)
                (gen "nextpc = " (translate-gvm-opnd ctx opnd) ";\n"
                     "return null;\n")
                (gen "return " (translate-gvm-opnd ctx opnd) ";\n")))
          "}\n"))

    (else
     (compiler-internal-error
      "translate-gvm-instr, unknown 'gvm-instr':"
      gvm-instr))))

(define (translate-gvm-opnd ctx gvm-opnd)

  (cond ((not gvm-opnd)
         (gen "NO_OPERAND"))

        ((reg? gvm-opnd)
         (gen "reg["
              (reg-num gvm-opnd)
              "]"))

        ((stk? gvm-opnd)
         (gen "stack[sp"
              (if (< (stk-num gvm-opnd) 0) "" "+")
              (stk-num gvm-opnd)
              "]"))

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

(define (sp-adjust ctx n sep)
  (if (not (= n 0))
      (gen "sp += " n ";" sep)
      (gen "")))

(define (translate-lbl ctx lbl)
  (lbl->id ctx (lbl-num lbl) (ctx-ns ctx)))

(define (lbl->id ctx num ns)
  (gen "lbl" num "_" (scheme-id->c-id ns)))

(define (prim-applic ctx prim opnds test?)
  (case (string->symbol (proc-obj-name prim))

    ((##not)
     (gen (translate-gvm-opnd ctx (list-ref opnds 0)) " === false"))

    (else
     (compiler-internal-error
      "prim-applic, unimplemented primitive:"
      (proc-obj-name prim)))))

(define (runtime-system targ)
#<<EOF
var glo = {};
var reg = [null];
var stack = [];
var sp = -1;
var nargs = 0;
var nextpc = null;
var yield;

if (this.hasOwnProperty('setTimeout')) {
    yield = this.setTimeout;
} else {
    yield = function() {};
}


function lbl1_fx_3c_() { // fx<
    if (nargs !== 2) throw "wrong number of arguments";
    reg[1] = reg[1] < reg[2];
    return reg[0];
}

glo["fx<"] = lbl1_fx_3c_;

function lbl1_fx_2b_() { // fx+
    if (nargs !== 2) throw "wrong number of arguments";
    reg[1] = reg[1] + reg[2];
    return reg[0];
}

glo["fx+"] = lbl1_fx_2b_;

function lbl1_fx_2d_() { // fx-
    if (nargs !== 2) throw "wrong number of arguments";
    reg[1] = reg[1] - reg[2];
    return reg[0];
}

glo["fx-"] = lbl1_fx_2d_;

function lbl1_print() { // print
    if (nargs !== 1) throw "wrong number of arguments";
    print(reg[1]);
    return reg[0];
}

glo["print"] = lbl1_print;


function run(pc) {
    nextpc = pc;
    while (nextpc !== null) {
        yield("", 0);
        pc = nextpc;
        nextpc = null;
        while (pc !== null) {
            pc = pc();
        }
    }
}

EOF
)

(define (entry-point ctx main-proc)
  (gen "run(" (lbl->id ctx 1 (proc-obj-name main-proc)) ");\n"))

;;;============================================================================
