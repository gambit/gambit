;;;============================================================================

;;; File: "_debug-gsc.scm"

;;; Copyright (c) 1994-2015 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(set! ##wr
      (lambda (we obj)
        (##default-wr
         we
         (cond ((c#ptree? obj)
                (list 'PTREE: (c#parse-tree->expression obj)))
               ((c#var? obj)
                (list 'VAR: (c#var-name obj)))
               (else
                obj)))))

;;;============================================================================
