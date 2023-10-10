;;;============================================================================

;;; File: "141.sld"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 141, Integer division

(define-library (srfi 141)

  (namespace "")

  (export

balanced-quotient
balanced-remainder
balanced/

ceiling-quotient
ceiling-remainder
ceiling/

euclidean-quotient
euclidean-remainder
euclidean/

floor-quotient
floor-remainder
floor/

round-quotient
round-remainder
round/

truncate-quotient
truncate-remainder
truncate/

)

  (include "141.scm"))

;;;============================================================================
