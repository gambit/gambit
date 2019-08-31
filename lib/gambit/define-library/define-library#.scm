;;;============================================================================

;;; File: "define-library#.scm"

;;; Copyright (c) 2014-2019 by Marc Feeley and Frédéric Hamel, All Rights Reserved.

;;;============================================================================

(##namespace ("" define-library define-syntax syntax-rules import))

(##define-syntax import
 (lambda (src)
   (##import gambit/define-library/define-library-expand)
   (import-expand src)))

(##define-syntax define-library
 (lambda (src)
   (##import gambit/define-library/define-library-expand)
   (define-library-expand src)))

(##define-syntax define-syntax
  (lambda (src)
    (let ((locat (##source-locat src)))
      (##make-source
       (##cons (##make-source '##define-syntax locat)
               (##cdr (##source-code src)))
       locat))))

(##define-syntax syntax-rules
  (lambda (src)
    (##import gambit/define-library/define-library-expand)
    (syn#syntax-rules-form-transformer src)))
