(define-library (srfi 128)

  (export comparator? comparator-ordered? comparator-hashable?)
  (export make-comparator
          make-pair-comparator make-list-comparator make-vector-comparator
          make-eq-comparator make-eqv-comparator make-equal-comparator)
  (export boolean-hash keyword-hash char-hash char-ci-hash number-hash)
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
          symbol-comparator keyword-comparator
          char-comparator char-ci-comparator
          string-comparator string-ci-comparator
          list-comparator vector-comparator
          eq-comparator eqv-comparator equal-comparator)

  (export s8vector-comparator u8vector-comparator 
          s16vector-comparator u16vector-comparator
          s32vector-comparator u32vector-comparator
          s64vector-comparator u64vector-comparator
          f32vector-comparator f64vector-comparator)

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

