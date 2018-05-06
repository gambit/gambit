;;==============================================================================

;;; File: "_t-cpu-function-sub.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

;;------------------------------------------------------------------------------

;; ***** Instruction substitution
;; ***** Instruction substitution - Base

;; Create an rule.
;; Pred :: [Arg] -> Bool
;; Replacment :: Function
;; map-args :: [Arg] -> [Arg]
(define (rule pred replacement #!optional (map-args id-args))
  (vector 'rule pred replacement map-args))

(define (rule? vect)
  (and (= 4 (length vect)) (eqv? 'rule (vector-ref vect 0))))
(define (rule-pred vect) (vector-ref vect 1))
(define (rule-replacement vect) (vector-ref vect 2))
(define (rule-map-args vect) (vector-ref vect 3))

;; Wrap func in lambda that does
;; 1. Check if any rule-pred is true with its argument.
;;    The first one that's true is used to override func
;; 2. If no rule match, execute func with its argument
(define (wrap-function func rules)
  (define (iter . args)
    (let loop ((rules rules))
      (if (null? rules)
        (apply func args)
        (let* ((rule (car rules))
               (pred (rule-pred rule))
               (repl (rule-replacement rule))
               (map-args (rule-map-args rule)))
          (if (pred args)
            (apply repl (map-args args))
            (loop (cdr rules)))))))
  iter)

;; ***** Instruction substitution - Predicate helper functions

(define (NOP . args) #f)
(define (id-args . args) args)

;; Builds a substitution rule from an Expression
;; The goal of the function is to make it easier to express complex substitution
;; conditions while keeping expressions short and easy to understand.
;; Using an Haskell-like syntax, an expression is defined as:
;; data Expr = And [Expr]
;;           | Or [Expr]
;;             ;; Apply arguments to pred.
;;           | Relative { pred :: [Opnd] -> Bool }
;;
;; type OpndType = Int | Reg | Mem
;; Currently no use for OpndType Obj and Label.

(define (make-rule rule-id expr sub #!optional (args-map id-args))
  (define (match? args expr)
    (case (car expr)
      ('or
        (any (map (lambda (subconds) (match? args subconds)) (cdr expr))))

      ('and
        (all (map (lambda (subconds) (match? args subconds)) (cdr expr))))

      ('rel
        ((cadr expr) args))

      (else
        (compiler-internal-error "make-rule: Unknown tag: " (car expr)))))

  (rule
    (lambda (args)
      (let ((does-match? (match? args expr))
            (enabled (rule-enabled? rule-id)))
        (cond
          ((and does-match? (not enabled))
            (begin
              (debug "Not applying rule with id: " rule-id "\n")
              #f))
          ((and does-match? enabled)
            (begin
              (debug "Applying rule with id: " rule-id "\n")
              #t))
          (else
            #f))))
    sub
    args-map))

(define (all-rules . rules)
  (cons 'and rules))

(define (any-rules . rules)
  (cons 'or rules))

(define (rel-rule pred)
  (list 'rel pred))

(define (rel-rule-index index pred)
  (rel-rule
    (lambda (args) (pred (list-ref args index)))))

(define (match-opnd arg-index val opnd? mk-opnd)
  (rel-rule-index
    arg-index
    (lambda (arg)
      (and (opnd? arg)
        (or (not val) (equal? arg (mk-opnd val)))))))

(define (match-int arg-index val)
  (match-opnd arg-index val int-opnd? int-opnd))

(define (match-reg arg-index val)
  (match-opnd arg-index val reg-opnd? get-register))

(define (match-mem arg-index val)
  (match-opnd arg-index val mem-opnd?
    (lambda (mem-params) (apply mem-opnd mem-params))))

;; ***** Instruction substitution - Arguments helper functions

(define (map-argument arg-index fun)
  (lambda (args)
    (map-nth args arg-index fun)))

(define (reorganize-args list)
  (lambda (args)
    (reorder-list args list)))

(define (all bools)
  (if (null? bools)
    #t
    (and (car bools) (all (cdr bools)))))

(define (any bools)
  (if (null? bools)
    #f
    (or (car bools) (all (cdr bools)))))

;; ***** Instruction substitution - Enabling/Disabling rules

(define (rule-enabled? id)
  (let loop ((ids enabled-rules))
    (if (null? ids)
      #f
      (if (equal? id (car ids))
        #t
        (loop (cdr ids))))))

;; Todo: Replace with hash table
;; Naming convention: original_operation opnd1_type opnd2_type -> substituted_operation new_opnd1_type new_opnd2_type
;; Operand types are: (R)egister, (M)emory, (L)abel, _ for Any, Int or other constants
(define enabled-rules (list
  "mov R 0 -> xor R R"
  "add _ 0 -> nop"
  "add _ 1 -> inc _"))

