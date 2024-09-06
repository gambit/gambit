(include "#.scm")

(define ##windows? ;; detect Windows
  (let* ((cd
          (##current-directory))
         (directory-separator
          (##string-ref cd (##fx- (##string-length cd) 1))))
    (##char=? #\\ directory-separator)))

(check-same-behavior ("" "##" "~~lib/gambit/prim/filesystem#.scm")

;; R7RS

(file-exists? ".")
(let ((x "test_file.txt")) (##with-output-to-file x ##list) (delete-file x))

;; Gambit

(let ((x "test_file.txt") (y "test_file2.txt")) (##with-output-to-file x ##list) (copy-file x y) (delete-file x) (delete-file y))
(let ((x "test_dir")) (create-directory x) (delete-directory x))
(##procedure? create-fifo) ;; minimal test
;;Creating fifos on Windows raises an exception
(and (not ##windows?)
     (let ((x "test_fifo")) (create-fifo x) (delete-file x)))
(##procedure? create-link) ;; minimal test
;;Creating links on Windows raises an exception
(and (not ##windows?)
     (let ((x "test_file.txt") (y "test_link")) (##with-output-to-file x ##list) (create-link x y) (delete-file x) (delete-file y)))
(##procedure? create-symbolic-link) ;; minimal test
;;Creating symbolic-links on Windows raises an exception
(and (not ##windows?)
     (let ((x "test_file.txt") (y "test_link")) (##with-output-to-file x ##list) (create-symbolic-link x y) (delete-file x) (delete-file y)))
(let ((x (create-temporary-directory "test_dir"))) (delete-directory x))
(current-directory) (current-directory ".")
(let ((x "test_dir")) (create-directory x) (delete-directory x))
(let ((x "test_dir")) (create-directory x) (delete-file-or-directory x))
(directory-files) (directory-files ".")
(executable-path)
;;unimplemented;;(file-attributes ".")
;;unimplemented;;(file-creation-time ".")
;;unimplemented;;(file-device ".")
;;unimplemented;;(file-error? ".")
;;unimplemented;;(file-group ".")
(file-info? (file-info ".")) (file-info? (file-info "." #t)) (file-info? (file-info "." #t #f))
(file-info-attributes (file-info "."))
(##time->seconds (file-info-creation-time (file-info ".")))
(file-info-device (file-info "."))
(file-info-group (file-info "."))
(file-info-inode (file-info "."))
(##procedure? file-info-last-access-time) ;; minimal test
(##procedure? file-info-last-change-time) ;; minimal test
(##procedure? file-info-last-modification-time) ;; minimal test
;;The following can't be tested reliably because it depends on the filesystem
(and #f ;; (not ##windows?)
     (begin
       (##time->seconds (file-info-last-access-time (file-info ".")))
       (##time->seconds (file-info-last-change-time (file-info ".")))
       (##time->seconds (file-info-last-modification-time (file-info ".")))))
(file-info-mode (file-info "."))
(file-info-number-of-links (file-info "."))
(file-info-owner (file-info "."))
(file-info-size (file-info "."))
(file-info-type (file-info "."))
(file-info? (file-info "."))
;;unimplemented;;(file-inode ".")
(let ((x "test_file.txt")) (##with-output-to-file x ##list) (file-last-access-and-modification-times-set! x) (delete-file x))
(let ((x "test_file.txt")) (##with-output-to-file x ##list) (file-last-access-and-modification-times-set! x -1) (delete-file x))
(let ((x "test_file.txt")) (##with-output-to-file x ##list) (file-last-access-and-modification-times-set! x -1 -2) (delete-file x))
;;unimplemented;;(file-last-access-time ".")
;;unimplemented;;(file-last-change-time ".")
;;unimplemented;;(file-last-modification-time ".")
;;unimplemented;;(file-mode ".")
;;unimplemented;;(file-number-of-links ".")
;;unimplemented;;(file-owner ".")
;;unimplemented;;(file-size ".")
;;unimplemented;;(file-type ".")
(initial-current-directory) (initial-current-directory ".")
(path-directory (current-directory))
(path-expand "foo.bar") (path-expand "foo.bar" "..")
(path-extension "foo.bar")
(path-normalize "foo.bar")
(path-strip-directory (path-expand "foo.bar"))
(path-strip-extension (path-expand "foo.bar"))
(path-strip-trailing-directory-separator (current-directory))
(path-strip-volume (path-expand "foo.bar"))
(path-volume (path-expand "foo.bar"))
(read-file-string (##this-source-file))
(read-file-string-list (##this-source-file))
(read-file-u8vector (##this-source-file))
(let ((x "test_file.txt") (y "test_file2.txt")) (##with-output-to-file x ##list) (##with-output-to-file y ##list) (rename-file x y) (delete-file y))
(let ((x "test_file.txt") (y "test_file2.txt")) (##with-output-to-file x ##list) (##with-output-to-file y ##list) (rename-file x y #t) (delete-file y))
;;(let ((x "test_file.txt") (y "test_file2.txt")) (##with-output-to-file x ##list) (rename-file x y #f) (delete-file y))
(let ((x "test_file.txt")) (write-file-string x "a\nb\n") (read-file-string x) (delete-file x))
(let ((x "test_file.txt")) (write-file-string-list x '("a" "b")) (read-file-string x) (delete-file x))
(let ((x "test_file.txt")) (write-file-u8vector x (u8vector 33 34 35)) (read-file-string x) (delete-file x))

)
