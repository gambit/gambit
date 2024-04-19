(define-library (srfi 128)

  (export comparator? comparator-ordered? comparator-hashable?)
  (export make-comparator
          make-pair-comparator make-list-comparator make-vector-comparator
          make-eq-comparator make-eqv-comparator make-equal-comparator)
  (export boolean-hash char-hash char-ci-hash
          string-hash string-ci-hash symbol-hash number-hash)
  (export make-default-comparator default-hash comparator-register-default!)
  (export comparator-type-test-predicate comparator-equality-predicate
        comparator-ordering-predicate comparator-hash-function)
  (export comparator-test-type comparator-check-type comparator-hash)
  (export hash-bound hash-salt)
  (export =? <? >? <=? >=?)
  (export comparator-if<=>)
  (export comparator-max comparator-min
          comparator-max-in-list comparator-min-in-list)
  (export default-comparator boolean-comparator real-comparator
          char-comparator char-ci-comparator
          string-comparator string-ci-comparator
          list-comparator vector-comparator
          eq-comparator eqv-comparator equal-comparator)

  (cond-expand
    (gambit
     (import (gambit)))
    (else
     (import (scheme base))))

  (import (scheme case-lambda))
  (import (scheme char) (scheme complex) (scheme inexact))

  (include "128-impl.scm")
  (include "default.scm")
  (include "162-impl.scm") ; must be last
)

