(include "#.scm")

;; Every filesystem mutation is confined to a fresh temporary directory.
(define scratch #f)
(define gambit-unit-test-loaded-value #f)
(test-assert
 (begin (set! scratch (create-temporary-directory))
        (and (string? scratch) (file-exists? scratch))))
(define (local-path name) (path-expand name scratch))

(dynamic-wind
 (lambda () #f)
 (lambda ()
   (test-eqv 42
    (begin
      (write-file-string (local-path "load-test.scm")
                          "(set! gambit-unit-test-loaded-value 42)")
      (load (local-path "load-test.scm"))
      gambit-unit-test-loaded-value))
   (test-assert (file-info? (file-info scratch)))
   (test-eq #f (file-info? #f))
   (test-equal ".txt" (path-extension "a/b.txt"))
   (test-equal "" (path-extension "a/b"))
   (test-equal "a/b" (path-strip-extension "a/b.txt"))
   (test-equal "a/" (path-directory "a/b.txt"))
   (test-equal "b.txt" (path-strip-directory "a/b.txt"))
   (test-equal "a/b" (path-strip-trailing-directory-separator "a/b/"))
   (test-equal "" (path-volume "relative.txt"))
   (test-equal "relative.txt" (path-strip-volume "relative.txt"))
   (test-equal (local-path "test.txt") (path-expand "test.txt" scratch))
   (test-equal (path-normalize scratch)
               (path-normalize (path-expand "." scratch)))
   (test-equal (current-directory)
    (let ((before (current-directory)))
      (parameterize ((current-directory scratch))
        (test-equal (path-normalize scratch) (current-directory)))
      before))
   (test-assert (string? (initial-current-directory)))
   (test-assert
    (begin (create-directory (local-path "nested"))
           (file-exists? (local-path "nested"))))
   (test-error file-exists-exception? (create-directory scratch))
   (test-eq 'written
    (call-with-output-file (local-path "source")
     (lambda (p) (display "abc\n" p) 'written)))
   (test-equal "abc" (call-with-input-file (local-path "source") read-line))
   (test-eq 'written
    (with-output-to-file (local-path "dynamic")
     (lambda () (write '(a 1)) 'written)))
   (test-equal '(a 1) (with-input-from-file (local-path "dynamic") read))
   (test-equal "abc\n"
    (begin (copy-file (local-path "source") (local-path "copy"))
           (read-file-string (local-path "copy"))))
   (test-assert
    (begin (rename-file (local-path "copy") (local-path "renamed"))
           (and (not (file-exists? (local-path "copy")))
                (string=? "abc\n" (read-file-string (local-path "renamed"))))))
   (test-equal '(0 4 1 98 3)
    (let ((p (open-file (local-path "source"))))
      (dynamic-wind
       (lambda () #f)
       (lambda ()
         (let* ((initial (input-port-byte-position p))
                (end (output-port-byte-position p 0 2))
                (seek (input-port-byte-position p 1))
                (byte (read-u8 p))
                (seek-end (input-port-byte-position p -1 2)))
           (list initial end seek byte seek-end)))
       (lambda () (close-port p)))))
   (test-eqv 1000000000.0
    (begin
      (file-last-access-and-modification-times-set!
       (local-path "source") (seconds->time 1000000000) (seconds->time 1000000000))
      (time->seconds (file-last-modification-time (local-path "source")))))
   (cond-expand
    (windows (begin))
    (else
     (test-assert
      (begin (create-link (local-path "source") (local-path "hardlink"))
             (= (file-inode (local-path "source"))
                (file-inode (local-path "hardlink")))))
     (test-equal "abc\n"
      (begin (create-symbolic-link (local-path "source") (local-path "symlink"))
             (read-file-string (local-path "symlink"))))
     (test-eq 'fifo
      (begin (create-fifo (local-path "fifo")) (file-type (local-path "fifo"))))))
   (test-assert (member "source" (directory-files scratch)))
   (test-assert
    (let ((p (open-directory scratch)))
      (dynamic-wind (lambda () #f)
       (lambda () (member "source" (read-all p)))
       (lambda () (close-port p)))))
   (test-eq #f
    (begin (delete-file (local-path "dynamic"))
           (file-exists? (local-path "dynamic"))))
   (test-eq #f
    (begin (delete-directory (local-path "nested"))
           (file-exists? (local-path "nested"))))
   (test-error no-such-file-or-directory-exception?
    (copy-file (local-path "absent") (local-path "never-created"))))
 (lambda ()
   (test-eq #f
    (begin (delete-file-or-directory scratch #t) (file-exists? scratch)))))
