;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Definition of the structures found in the parse tree.

;; These structures define the nodes associated to expressions.

;; information common to all nodes

;;  parent   ; the node of which this node is a child
;;  children ; list of parse-trees of the sub-expressions
;;  fv       ; set of free variables contained in this expr
;;  bfv      ; set of bound free variables contained in this expr
;;  env      ; environment at this node
;;  source   ; source corresponding to this node
;;  stamp    ; integer to identify node

(define (node-parent x)          (vector-ref x 1))
(define (node-children x)        (vector-ref x 2))
(define (node-fv x)              (vector-ref x 3))
(define (node-bfv x)             (vector-ref x 4))
(define (node-env x)             (vector-ref x 5))
(define (node-source x)          (vector-ref x 6))
(define (node-stamp x)           (vector-ref x 7))
(define (node-parent-set! x y)   (vector-set! x 1 y))
(define (node-fv-set! x y)       (vector-set! x 3 y))
(define (node-bfv-set! x y)      (vector-set! x 4 y))
(define (node-env-set! x y)      (vector-set! x 5 y))
(define (node-source-set! x y)   (vector-set! x 6 y))
(define (node-stamp-set! x y)    (vector-set! x 7 y))

(define (make-cst ; node that represents constants
         parent children fv bfv env source ; common to all nodes

    val) ; value of the constant

  (vector cst-tag parent children fv bfv env source (next-node-stamp) val))

(define cst-tag (list 'cst-tag))

(define (cst? x)           (eq? (vector-ref x 0) cst-tag))
(define (cst-val x)        (vector-ref x 8))
(define (cst-val-set! x y) (vector-set! x 8 y))

(define (make-ref ; node that represents variable references
         parent children fv bfv env source ; common to all nodes

    var) ; the variable which is referenced

  (vector ref-tag parent children fv bfv env source (next-node-stamp) var))

(define ref-tag (list 'ref-tag))

(define (ref? x)           (eq? (vector-ref x 0) ref-tag))
(define (ref-var x)        (vector-ref x 8))
(define (ref-var-set! x y) (vector-set! x 8 y))

(define (make-set ; node that represents assignments (i.e. set! special forms)
         parent children fv bfv env source ; common to all nodes

    var) ; the variable which is assigned a value

  (vector set-tag parent children fv bfv env source (next-node-stamp) var))

(define set-tag (list 'set-tag))

(define (set? x)           (eq? (vector-ref x 0) set-tag))
(define (set-var x)        (vector-ref x 8))
(define (set-var-set! x y) (vector-set! x 8 y))

(define (make-def ; node that represents toplevel definitions
         parent children fv bfv env source ; common to all nodes

    var) ; the global variable which is assigned a value

  (vector def-tag parent children fv bfv env source (next-node-stamp) var))

(define (def? x)           (eq? (vector-ref x 0) def-tag))
(define (def-var x)        (vector-ref x 8))
(define (def-var-set! x y) (vector-set! x 8 y))

(define def-tag (list 'def-tag))

(define (make-tst ; node that represents conditionals (i.e. if special forms)
         parent children fv bfv env source ; common to all nodes

    )

  (vector tst-tag parent children fv bfv env source (next-node-stamp)))

(define tst-tag (list 'tst-tag))

(define (tst? x) (eq? (vector-ref x 0) tst-tag))

(define (make-conj ; node that represents conjunctions (i.e. and special forms)
         parent children fv bfv env source ; common to all nodes

    )

  (vector conj-tag parent children fv bfv env source (next-node-stamp)))

(define conj-tag (list 'conj-tag))

(define (conj? x) (eq? (vector-ref x 0) conj-tag))

(define (make-disj ; node that represents disjunctions (i.e. or special forms)
         parent children fv bfv env source ; common to all nodes

    )

  (vector disj-tag parent children fv bfv env source (next-node-stamp)))

(define disj-tag (list 'disj-tag))

(define (disj? x) (eq? (vector-ref x 0) disj-tag))

(define (make-prc ; node that represents procedures (i.e. lambda-expressions)
         parent children fv bfv env source ; common to all nodes

    name     ; name of this procedure (string) or #f if none
    c-name   ; name of associated C function (string) or #f if none
    parms    ; the list of parameter variables in order
    opts     ; the list of objects that the optional parameters default to
    keys     ; the list of keyword/default pairs
    rest?)   ; #t if the last parameter is a rest parameter and
             ; the symbol "body" if the last parameter is a body parameter

  (vector prc-tag parent children fv bfv env source (next-node-stamp)
          name
          c-name
          parms
          opts
          keys
          rest?))

(define prc-tag (list 'prc-tag))

(define (prc? x)              (eq? (vector-ref x 0) prc-tag))
(define (prc-name x)          (vector-ref x 8))
(define (prc-c-name x)        (vector-ref x 9))
(define (prc-parms x)         (vector-ref x 10))
(define (prc-opts x)          (vector-ref x 11))
(define (prc-keys x)          (vector-ref x 12))
(define (prc-rest? x)         (vector-ref x 13))
(define (prc-name-set! x y)   (vector-set! x 8 y))
(define (prc-c-name-set! x y) (vector-set! x 9 y))
(define (prc-parms-set! x y)  (vector-set! x 10 y))
(define (prc-opts-set! x y)   (vector-set! x 11 y))
(define (prc-keys-set! x y)   (vector-set! x 12 y))
(define (prc-rest?-set! x y)  (vector-set! x 13 y))

(define (make-app ; node that represents procedure calls
         parent children fv bfv env source ; common to all nodes

    )

  (vector app-tag parent children fv bfv env source (next-node-stamp)))

(define app-tag (list 'app-tag))

(define (app? x) (eq? (vector-ref x 0) app-tag))

(define (make-fut ; node that represents future constructs
         parent children fv bfv env source ; common to all nodes

    )

  (vector fut-tag parent children fv bfv env source (next-node-stamp)))

(define fut-tag (list 'fut-tag))

(define (fut? x) (eq? (vector-ref x 0) fut-tag))
