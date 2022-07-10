;;;============================================================================

;;; File: "_gscdebug.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define write-abstractly (make-parameter #t))

(##wr-set!
 (lambda (we obj)

   (if (and (write-abstractly)
            (or (c#var? obj)
                (c#ptree? obj)))

       (let ((save-wr ##wr))
         (##wr-set! ##default-wr)
         (let ((result
                (##wr we
                      (if (c#var? obj)
                          (list 'VAR: (c#var-name obj))
                          (list 'PTREE: (c#parse-tree->expression obj))))))
           (##wr-set! save-wr)
           result))

       (##default-wr we
                     obj))))

;;;============================================================================
