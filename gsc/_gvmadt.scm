;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Virtual machine operands:
;; ------------------------
;;
;; Operands are represented with small integers.  Operands can thus be tested
;; for equality using 'eqv?'.  The encoding is as follows:
;;
;; OPERAND      ENCODING
;;
;; reg(n)       n*8 + 0
;; stk(n)       n*8 + 1
;; lbl(n)       n*8 + 2
;; glo(name)    index_in_operand_table*8 + 3
;; clo(opnd,n)  index_in_operand_table*8 + 4
;; obj(x)       index_in_operand_table*8 + 5

;; Locations:
;; ---------

;; -- location is a register (first is number 0)
(define (make-reg num) (* num 8))
(define (reg? x) (= (modulo x 8) 0))
(define (reg-num x) (quotient x 8))

;; -- location is in the stack (first slot in procedure's frame is number 1)
(define (make-stk num) (+ (* num 8) 1))
(define (stk? x) (= (modulo x 8) 1))
(define (stk-num x) (quotient x 8))

;; -- location is a global variable
(define (make-glo name) (+ (* (enter-opnd name #t) 8) 3))
(define (glo? x) (= (modulo x 8) 3))
(define (glo-name x) (car (vector-ref *opnd-table* (quotient x 8))))

;; -- location is a closed variable (base is ptr to closure env, index >= 1)
(define (make-clo base index) (+ (* (enter-opnd base index) 8) 4))
(define (clo? x) (= (modulo x 8) 4))
(define (clo-base x) (car (vector-ref *opnd-table* (quotient x 8))))
(define (clo-index x) (cdr (vector-ref *opnd-table* (quotient x 8))))

;; Values:
;; ------

;; -- value is the address of a local label
(define (make-lbl num) (+ (* num 8) 2))
(define (lbl? x) (= (modulo x 8) 2))
(define (lbl-num x) (quotient x 8))

;; -- value is a scheme object
(define (make-obj val) (+ (* (enter-opnd val #f) 8) 5))
(define (obj? x) (= (modulo x 8) 5))
(define (obj-val x) (car (vector-ref *opnd-table* (quotient x 8))))

