(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

(define gen vector)

(define (js-gen-nl) "\n")

(define (js-open-comment) "//")
(define (js-end-comment) "")

(define (js-gen-string s) s)

(define (js-gen-label ctx gvm-instr)
  (gen "\n"
       "function "
       (js-lbl->id ctx (label-lbl-num gvm-instr) (ctx-ns ctx))
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

       (js-sp-adjust ctx (- (frame-size (gvm-instr-frame gvm-instr))) "\n")))

(define (js-gen-apply ctx gvm-instr)
  (let ((loc (apply-loc gvm-instr))
             (prim (apply-prim gvm-instr))
             (opnds (apply-opnds gvm-instr)))
         (gen (translate-gvm-opnd ctx loc)
              " = "
              (js-prim-applic ctx prim opnds #f)
              ";\n")))

(define (js-gen-copy ctx gvm-instr)
  (let ((loc (copy-loc gvm-instr))
             (opnd (copy-opnd gvm-instr)))
         (if opnd
             (gen (translate-gvm-opnd ctx loc)
                  " = "
                  (translate-gvm-opnd ctx opnd)
                  ";\n")
             (gen ""))))

(define (js-gen-close ctx gvm-instr)
  ;; TODO
  ;; (close-parms gvm-instr)
  (gen "throw \"close GVM instruction unimplemented\";\n"))

(define (js-gen-ifjump ctx gvm-instr)
  ;; TODO
  ;; (ifjump-poll? gvm-instr)
  (let ((test (ifjump-test gvm-instr))
        (opnds (ifjump-opnds gvm-instr))
        (true (ifjump-true gvm-instr))
        (false (ifjump-false gvm-instr))
        (adj (js-sp-adjust ctx (frame-size (gvm-instr-frame gvm-instr)) " ")))
    (gen "if ("
         (js-prim-applic ctx test opnds #t)
         ") "
         "{ " adj "return " (translate-gvm-opnd ctx (make-lbl true)) "; }"
         " else "
         "{ " adj "return " (translate-gvm-opnd ctx (make-lbl false)) "; }"
         "\n}\n")))

(define (js-gen-switch ctx gvm-instr)
  ;; TODO
  ;; (switch-opnd gvm-instr)
  ;; (switch-cases gvm-instr)
  ;; (switch-poll? gvm-instr)
  ;; (switch-default gvm-instr)
  (gen "throw \"switch GVM instruction unimplemented\";\n"
       "}\n"))

(define (js-gen-jump ctx gvm-instr)
  ;; TODO
  ;; (jump-safe? gvm-instr)
  ;; test: (jump-poll? gvm-instr) 
  (gen (let ((nb-args (jump-nb-args gvm-instr)))
         (if nb-args
             (gen "nargs = " nb-args ";\n")
             ""))
       (js-sp-adjust ctx (frame-size (gvm-instr-frame gvm-instr)) "\n")
       (let ((opnd (jump-opnd gvm-instr)))
         (if (jump-poll? gvm-instr)
             (gen "save_pc = " (translate-gvm-opnd ctx opnd) ";\n"
                  "return null;\n")
             (gen "return " (translate-gvm-opnd ctx opnd) ";\n")))
       "}\n"))

(define (js-gen-reg ctx gvm-opnd)
  (gen "reg["
       (reg-num gvm-opnd)
       "]"))

(define (js-gen-stk ctx gvm-opnd)
  (gen "stack[sp"
       (if (< (stk-num gvm-opnd) 0) "" "+")
       (stk-num gvm-opnd)
       "]"))

(define (js-gen-glo ctx gvm-opnd)
  (gen "glo["
       (object->string (symbol->string (glo-name gvm-opnd)))
       "]"))

(define (js-gen-clo ctx gvm-opnd)
  (gen (translate-gvm-opnd ctx (clo-base gvm-opnd))
       "["
       (clo-index gvm-opnd)
       "]"))

(define (js-gen-obj ctx gvm-opnd)
  (let ((val (obj-val gvm-opnd)))
    (cond ((number? val)
           (gen val))
          ((void-object? val)
           (gen "undefined"))
          ((proc-obj? val)
           (js-lbl->id ctx 1 (proc-obj-name val)))
          (else
           (gen "UNIMPLEMENTED_OBJECT("
                (object->string val)
                ")")))))

(define (js-sp-adjust ctx n sep)
  (if (not (= n 0))
      (gen "sp += " n ";" sep)
      (gen "")))

(define (js-translate-lbl ctx lbl)
  (js-lbl->id ctx (lbl-num lbl) (ctx-ns ctx)))

(define (js-lbl->id ctx num ns)
  (gen "lbl" num "_" (scheme-id->c-id ns)))

(define (js-entry-point ctx main-proc)
  (gen "\n" "save_pc = " (js-lbl->id ctx 1 (proc-obj-name main-proc)) "; run();\n"))


(define (js-runtime-system)
#<<EOF
var glo = {};
var reg = [null];
var stack = [];
var sp = -1;
var nargs = 0;
var save_pc = null;
var poll;

if (this.hasOwnProperty('setTimeout'))
{
    poll = function (wakeup) { setTimeout(wakeup,1); return true; };
}
else
{
    poll = function (wakeup) { return false; };
}

function lbl1_fx_2a_() { // fx*
    if (nargs !== 2) throw "wrong number of arguments";
    reg[1] = reg[1] * reg[2];
    return reg[0];
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


function run()
{
    while (save_pc !== null)
    {
        pc = save_pc;
        save_pc = null;
        while (pc !== null)
            pc = pc();
        if (poll(run)) break;
    }
}

EOF
)

(define (js-prim-applic ctx prim opnds test?)
  (case (string->symbol (proc-obj-name prim))

    ((##not)
     (gen (translate-gvm-opnd ctx (list-ref opnds 0)) " === false"))

    (else
     (compiler-internal-error
      "prim-applic, unimplemented primitive:"
      (proc-obj-name prim)))))
