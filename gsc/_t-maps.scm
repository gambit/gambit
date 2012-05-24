(include "_t-js.scm")

(define univ-to-target '())

(define (add-target-fun name targ fun)
  (set! univ-to-target
        (cons (cons (list name targ) fun)
              univ-to-target)))

(define (get-target-fun name targ)
  (cdr (assoc (list name targ) univ-to-target)))

;; General
(add-target-fun 'gen-nl         'js js-gen-nl)
(add-target-fun 'open-comment   'js js-open-comment)
(add-target-fun 'end-comment    'js js-end-comment)
(add-target-fun 'gen-string     'js js-gen-string)
(add-target-fun 'sp-adjust      'js js-sp-adjust)
(add-target-fun 'translate-lbl  'js js-translate-lbl)
(add-target-fun 'entry-point    'js js-entry-point)
(add-target-fun 'runtime-system 'js js-runtime-system)
(add-target-fun 'prim-applic    'js js-prim-applic)

(define (univ-gen-nl targ)
  ((get-target-fun 'gen-nl targ)))

(define (univ-open-comment targ)
  ((get-target-fun 'open-comment targ)))

(define (univ-end-comment targ)
  ((get-target-fun 'end-comment targ)))

(define (univ-gen-string targ s)
  ((get-target-fun 'gen-string targ) s))

(define (univ-sp-adjust targ ctx n sep)
  ((get-target-fun 'sp-adjust targ) ctx n sep))

(define (univ-translate-lbl targ ctx lbl)
  ((get-target-fun 'translate-lbl targ) ctx lbl))

(define (univ-entry-point targ ctx main-proc)
  ((get-target-fun 'entry-point targ) ctx main-proc))

(define (univ-runtime-system targ)
  ((get-target-fun 'runtime-system targ)))

(define (univ-prim-applic targ)
  ((get-target-fun 'prim-applic targ)))

;; GVM instructions
(add-target-fun 'gen-label    'js js-gen-label)
(add-target-fun 'gen-apply    'js js-gen-apply)
(add-target-fun 'gen-copy     'js js-gen-copy)
(add-target-fun 'gen-close    'js js-gen-close)
(add-target-fun 'gen-ifjump   'js js-gen-ifjump)
(add-target-fun 'gen-switch   'js js-gen-switch)
(add-target-fun 'gen-jump     'js js-gen-jump)

(define (univ-gen-label-instr targ ctx gvm-instr)
  ((get-target-fun 'gen-label targ) ctx gvm-instr))

(define (univ-gen-apply-instr targ ctx gvm-instr)
  ((get-target-fun 'gen-apply targ) ctx gvm-instr))

(define (univ-gen-copy-instr targ ctx gvm-instr)
  ((get-target-fun 'gen-copy targ) ctx gvm-instr))

(define (univ-gen-close-instr targ ctx gvm-instr)
  ((get-target-fun 'gen-close targ) ctx gvm-instr))

(define (univ-gen-ifjump-instr targ ctx gvm-instr)
  ((get-target-fun 'gen-ifjump targ) ctx gvm-instr))

(define (univ-gen-switch-instr targ ctx gvm-instr)
  ((get-target-fun 'gen-switch targ) ctx gvm-instr))

(define (univ-gen-jump-instr targ ctx gvm-instr)
  ((get-target-fun 'gen-jump targ) ctx gvm-instr))

;; GVM operands
(add-target-fun 'gen-reg      'js js-gen-reg)
(add-target-fun 'gen-stk      'js js-gen-stk)
(add-target-fun 'gen-glo      'js js-gen-glo)
(add-target-fun 'gen-clo      'js js-gen-clo)
(add-target-fun 'gen-obj      'js js-gen-obj)

(define (univ-gen-reg-opnd targ ctx gvm-opnd)
  ((get-target-fun 'gen-reg targ) ctx gvm-opnd))

(define (univ-gen-stk-opnd targ ctx gvm-opnd)
  ((get-target-fun 'gen-stk targ) ctx gvm-opnd))

(define (univ-gen-glo-opnd targ ctx gvm-opnd)
  ((get-target-fun 'gen-glo targ) ctx gvm-opnd))

(define (univ-gen-clo-opnd targ ctx gvm-opnd)
  ((get-target-fun 'gen-clo targ) ctx gvm-opnd))

(define (univ-gen-obj-opnd targ ctx gvm-opnd)
  ((get-target-fun 'gen-obj targ) ctx gvm-opnd))
