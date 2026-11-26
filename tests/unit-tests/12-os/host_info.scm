(include "#.scm")

(define ##windows? ;; detect Windows
  (let* ((cd
          (##current-directory))
         (directory-separator
          (##string-ref cd (##fx- (##string-length cd) 1))))
    (##char=? #\\ directory-separator)))


(if (not ##windows?)
    (begin
      (test-assert (host-info? (##host-info "localhost")))
      (test-assert (host-info? (##host-info '#u8(127 0 0 1))))))

(define localhost-info
  (and (not ##windows?)
       (host-info "localhost")))

(if (not ##windows?)
    (begin
      (test-assert (host-info? localhost-info))
      (test-assert (host-info? (host-info '#u8(127 0 0 1))))

      ;;(test-assert (string? (##host-info-name (##host-info "localhost"))))
      ;;(test-assert (list? (##host-info-aliases (##host-info "localhost"))))
      ;;(test-assert (list? (##host-info-addresses (##host-info "localhost"))))

      (test-assert (string? (host-info-name localhost-info)))
      (test-assert (list? (host-info-aliases localhost-info)))
      (test-assert (list? (host-info-addresses localhost-info)))))

(test-error-tail wrong-number-of-arguments-exception? (host-info))
(test-error-tail wrong-number-of-arguments-exception? (host-info #f #f))

(test-error-tail wrong-number-of-arguments-exception? (host-info-name))
(test-error-tail wrong-number-of-arguments-exception? (host-info-name #f #f))
(test-error-tail wrong-number-of-arguments-exception? (host-info-aliases))
(test-error-tail wrong-number-of-arguments-exception? (host-info-aliases #f #f))
(test-error-tail wrong-number-of-arguments-exception? (host-info-addresses))
(test-error-tail wrong-number-of-arguments-exception? (host-info-addresses #f #f))

(test-error-tail type-exception? (host-info #f))

(test-error-tail type-exception? (host-info-name #f))
(test-error-tail type-exception? (host-info-aliases #f))
(test-error-tail type-exception? (host-info-addresses #f))
