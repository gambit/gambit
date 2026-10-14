(include "#.scm")

(define (caught thunk) (with-exception-catcher (lambda (e) e) thunk))
(define scratch (create-temporary-directory))
(define absent (path-expand "absent" scratch))

(dynamic-wind
 (lambda () #f)
 (lambda ()
   (let ((e (caught (lambda () (delete-file absent)))))
     (test-eq #t (no-such-file-or-directory-exception? e))
     (test-eq #f (no-such-file-or-directory-exception? #f))
     (test-eq delete-file (no-such-file-or-directory-exception-procedure e))
     (test-equal (list absent) (no-such-file-or-directory-exception-arguments e))
     (test-eq #t (file-error? e))
     (test-eq #f (file-error? #f)))
   (let ((e (caught (lambda () (create-directory scratch)))))
     (test-eq #t (file-exists-exception? e))
     (test-eq #f (file-exists-exception? #f))
     (test-eq create-directory (file-exists-exception-procedure e))
     (test-equal (list scratch) (file-exists-exception-arguments e)))
   ;; A nonempty directory cannot be removed with delete-directory.
   ;; This error does not require permission changes or a non-root account.
   (write-file-string (path-expand "child" scratch) "content")
   (cond-expand
    (windows (begin))
    (else
     (let ((e (caught (lambda () (delete-directory scratch)))))
     (test-eq #t (os-exception? e))
     (test-eq #f (os-exception? #f))
     (test-eq delete-directory (os-exception-procedure e))
     (test-equal (list scratch) (os-exception-arguments e))
     (test-assert (exact-integer? (os-exception-code e)))
     (test-assert (or (not (os-exception-message e))
                      (string? (os-exception-message e))))))))
 (lambda () (delete-file-or-directory scratch #t)))
