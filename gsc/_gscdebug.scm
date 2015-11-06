;;;============================================================================

;;; File: "_debug-gsc.scm"

;;; Copyright (c) 1994-2015 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define (ptree? obj)
  (and (vector? obj)
       (or (c#cst? obj)
           (c#ref? obj)
           (c#set? obj)
           (c#def? obj)
           (c#tst? obj)
           (c#conj? obj)
           (c#disj? obj)
           (c#prc? obj)
           (c#app? obj)
           (c#fut? obj))))

(set! ##wr
      (lambda (we obj)
        (##default-wr
         we
         (if (ptree? obj)
             (list 'PTREE: (c#parse-tree->expression obj))
             obj))))

;;;============================================================================
