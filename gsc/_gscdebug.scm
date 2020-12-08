;;;============================================================================

;;; File: "_gscdebug.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define write-abstractly (make-parameter #t))

(##wr-set!
 (lambda (we obj)
   (##default-wr
    we
    (cond ((not (write-abstractly))
           obj)
          ((c#ptree? obj)
           (list 'PTREE: (c#parse-tree->expression obj)))
          ((c#var? obj)
           (list 'VAR: (c#var-name obj)))
          (else
           obj)))))

;;;============================================================================
