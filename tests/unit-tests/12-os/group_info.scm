(include "#.scm")


(test-assert (group-info? (##group-info 0)))
(test-assert (group-info? (##group-info (group-info-name (##group-info 0)))))

;;(test-assert (string? (##group-info-name (##group-info 0))))
;;(test-assert (exact-integer? (##group-info-gid (##group-info 0))))
;;(test-assert (list? (##group-info-members (##group-info 0))))


(test-assert (group-info? (group-info 0)))
(test-assert (group-info? (group-info (group-info-name (group-info 0)))))

(test-assert (string? (group-info-name (group-info 0))))
(test-assert (exact-integer? (group-info-gid (group-info 0))))
(test-assert (list? (group-info-members (group-info 0))))


(test-error-tail wrong-number-of-arguments-exception? (group-info))
(test-error-tail wrong-number-of-arguments-exception? (group-info 0 #f))

(test-error-tail wrong-number-of-arguments-exception? (group-info-name))
(test-error-tail wrong-number-of-arguments-exception? (group-info-name (group-info 0) #f))
(test-error-tail wrong-number-of-arguments-exception? (group-info-gid))
(test-error-tail wrong-number-of-arguments-exception? (group-info-gid (group-info 0) #f))
(test-error-tail wrong-number-of-arguments-exception? (group-info-members))
(test-error-tail wrong-number-of-arguments-exception? (group-info-members (group-info 0) #f))

(test-error-tail type-exception? (group-info #f))

(test-error-tail type-exception? (group-info-name #f))
(test-error-tail type-exception? (group-info-gid #f))
(test-error-tail type-exception? (group-info-members #f))
