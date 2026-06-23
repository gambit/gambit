(include "#.scm")

(test-assert (string? (##user-name)))
(test-assert (string? (user-name)))


(test-assert (user-info? (##user-info 0)))
(test-assert (user-info? (##user-info (##user-name))))

;;(test-assert (string? (##user-info-name (##user-info (##user-name)))))
;;(test-assert (exact-integer? (##user-info-uid (##user-info (##user-name)))))
;;(test-assert (exact-integer? (##user-info-gid (##user-info (##user-name)))))
;;(test-assert (string? (##user-info-home (##user-info (##user-name)))))
;;(test-assert (string? (##user-info-shell (##user-info (##user-name)))))


(test-assert (user-info? (user-info 0)))
(test-assert (user-info? (user-info (user-name))))

(test-assert (string? (user-info-name (user-info (user-name)))))
(test-assert (exact-integer? (user-info-uid (user-info (user-name)))))
(test-assert (exact-integer? (user-info-gid (user-info (user-name)))))
(test-assert (string? (user-info-home (user-info (user-name)))))
(test-assert (string? (user-info-shell (user-info (user-name)))))


(test-error-tail wrong-number-of-arguments-exception? (user-name #f))

(test-error-tail wrong-number-of-arguments-exception? (user-info))
(test-error-tail wrong-number-of-arguments-exception? (user-info 0 #f))

(test-error-tail wrong-number-of-arguments-exception? (user-info-name))
(test-error-tail wrong-number-of-arguments-exception? (user-info-name (user-info (user-name)) #f))
(test-error-tail wrong-number-of-arguments-exception? (user-info-uid))
(test-error-tail wrong-number-of-arguments-exception? (user-info-uid (user-info (user-name)) #f))
(test-error-tail wrong-number-of-arguments-exception? (user-info-gid))
(test-error-tail wrong-number-of-arguments-exception? (user-info-gid (user-info (user-name)) #f))
(test-error-tail wrong-number-of-arguments-exception? (user-info-home))
(test-error-tail wrong-number-of-arguments-exception? (user-info-home (user-info (user-name)) #f))
(test-error-tail wrong-number-of-arguments-exception? (user-info-shell))
(test-error-tail wrong-number-of-arguments-exception? (user-info-shell (user-info (user-name)) #f))

(test-error-tail type-exception? (user-info #f))

(test-error-tail type-exception? (user-info-name #f))
(test-error-tail type-exception? (user-info-uid #f))
(test-error-tail type-exception? (user-info-gid #f))
(test-error-tail type-exception? (user-info-home #f))
(test-error-tail type-exception? (user-info-shell #f))
