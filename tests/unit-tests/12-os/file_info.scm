(include "#.scm")

(with-exception-catcher
 (lambda (e) e)
 (lambda () (delete-file "file_info_temp")))

(define creation-time (time->seconds (current-time)))

(write-file-string "file_info_temp" "")


(test-equal 'regular (##file-info-type (##file-info "file_info_temp")))
;;(test-equal 'regular (##file-type "file_info_temp"))

(test-equal 'regular (##file-info-type (##file-info "file_info_temp" #f)))
;;(test-equal 'regular (##file-info-type (##file-info "file_info_temp" #t)))

(test-assert (exact-integer? (##file-info-device (##file-info "file_info_temp"))))
;;(test-assert (exact-integer? (##file-device "file_info_temp")))

(test-assert (exact-integer? (##file-info-inode (##file-info "file_info_temp"))))
;;(test-assert (exact-integer? (##file-inode "file_info_temp")))

(test-assert (exact-integer? (##file-info-mode (##file-info "file_info_temp"))))
;;(test-assert (exact-integer? (##file-mode "file_info_temp")))

(test-assert (exact-integer? (##file-info-number-of-links (##file-info "file_info_temp"))))
;;(test-assert (exact-integer? (##file-number-of-links "file_info_temp")))

(test-assert (exact-integer? (##file-info-owner (##file-info "file_info_temp"))))
;;(test-assert (exact-integer? (##file-owner "file_info_temp")))

(test-assert (exact-integer? (##file-info-group (##file-info "file_info_temp"))))
;;(test-assert (exact-integer? (##file-group "file_info_temp")))

(test-equal 0 (##file-info-size (##file-info "file_info_temp")))
;;(test-equal 0 (##file-size "file_info_temp"))

(test-approximate creation-time (time->seconds (##file-info-last-access-time (##file-info "file_info_temp"))) 1)
;;(test-approximate creation-time (time->seconds (##file-last-access-time "file_info_temp")) 1)

(test-approximate creation-time (time->seconds (##file-info-last-modification-time (##file-info "file_info_temp"))) 1)
;;(test-approximate creation-time (time->seconds (##file-last-modification-time "file_info_temp")) 1)

(test-approximate creation-time (time->seconds (##file-info-last-change-time (##file-info "file_info_temp"))) 1)
;;(test-approximate creation-time (time->seconds (##file-last-change-time "file_info_temp")) 1)

(test-assert (exact-integer? (##file-info-attributes (##file-info "file_info_temp"))))
;;(test-assert (exact-integer? (##file-attributes "file_info_temp")))

(test-assert (time? (##file-info-creation-time (##file-info "file_info_temp"))))
;;(test-assert (time? (##file-creation-time "file_info_temp")))

(test-equal #f (##file-info "file_info_temp_nonexistent" #f #f))
(test-error-tail no-such-file-or-directory-exception? (##file-info "file_info_temp_nonexistent"))
(test-error-tail no-such-file-or-directory-exception? (##file-info "file_info_temp_nonexistent" #f))
(test-error-tail no-such-file-or-directory-exception? (##file-info "file_info_temp_nonexistent" #f #t))


(test-equal 'regular (file-info-type (file-info "file_info_temp")))
(test-equal 'regular (file-type "file_info_temp"))

(test-equal 'regular (file-info-type (file-info "file_info_temp" #f)))
(test-equal 'regular (file-info-type (file-info "file_info_temp" #t)))

(test-assert (exact-integer? (file-info-device (file-info "file_info_temp"))))
(test-assert (exact-integer? (file-device "file_info_temp")))

(test-assert (exact-integer? (file-info-inode (file-info "file_info_temp"))))
(test-assert (exact-integer? (file-inode "file_info_temp")))

(test-assert (exact-integer? (file-info-mode (file-info "file_info_temp"))))
(test-assert (exact-integer? (file-mode "file_info_temp")))

(test-assert (exact-integer? (file-info-number-of-links (file-info "file_info_temp"))))
(test-assert (exact-integer? (file-number-of-links "file_info_temp")))

(test-assert (exact-integer? (file-info-owner (file-info "file_info_temp"))))
(test-assert (exact-integer? (file-owner "file_info_temp")))

(test-assert (exact-integer? (file-info-group (file-info "file_info_temp"))))
(test-assert (exact-integer? (file-group "file_info_temp")))

(test-equal 0 (file-info-size (file-info "file_info_temp")))
(test-equal 0 (file-size "file_info_temp"))

(test-approximate creation-time (time->seconds (file-info-last-access-time (file-info "file_info_temp"))) 1)
(test-approximate creation-time (time->seconds (file-last-access-time "file_info_temp")) 1)

(test-approximate creation-time (time->seconds (file-info-last-modification-time (file-info "file_info_temp"))) 1)
(test-approximate creation-time (time->seconds (file-last-modification-time "file_info_temp")) 1)

(test-approximate creation-time (time->seconds (file-info-last-change-time (file-info "file_info_temp"))) 1)
(test-approximate creation-time (time->seconds (file-last-change-time "file_info_temp")) 1)

(test-assert (exact-integer? (file-info-attributes (file-info "file_info_temp"))))
(test-assert (exact-integer? (file-attributes "file_info_temp")))

(test-assert (time? (file-info-creation-time (file-info "file_info_temp"))))
(test-assert (time? (file-creation-time "file_info_temp")))

(test-equal #f (file-info "file_info_temp_nonexistent" #f #f))
(test-error-tail no-such-file-or-directory-exception? (file-info "file_info_temp_nonexistent"))
(test-error-tail no-such-file-or-directory-exception? (file-info "file_info_temp_nonexistent" #f))
(test-error-tail no-such-file-or-directory-exception? (file-info "file_info_temp_nonexistent" #f #t))


(test-error-tail wrong-number-of-arguments-exception? (file-info))
(test-error-tail wrong-number-of-arguments-exception? (file-info "file_info_temp" #f #f #f))

(test-error-tail wrong-number-of-arguments-exception? (file-info-type))
(test-error-tail wrong-number-of-arguments-exception? (file-info-type (file-info "file_info_temp") #f))
(test-error-tail wrong-number-of-arguments-exception? (file-type))
(test-error-tail wrong-number-of-arguments-exception? (file-type "file_info_temp" #f))

(test-error-tail wrong-number-of-arguments-exception? (file-info-device))
(test-error-tail wrong-number-of-arguments-exception? (file-info-device (file-info "file_info_temp") #f))
(test-error-tail wrong-number-of-arguments-exception? (file-device))
(test-error-tail wrong-number-of-arguments-exception? (file-device "file_info_temp" #f))

(test-error-tail wrong-number-of-arguments-exception? (file-info-inode))
(test-error-tail wrong-number-of-arguments-exception? (file-info-inode (file-info "file_info_temp") #f))
(test-error-tail wrong-number-of-arguments-exception? (file-inode))
(test-error-tail wrong-number-of-arguments-exception? (file-inode "file_info_temp" #f))

(test-error-tail wrong-number-of-arguments-exception? (file-info-mode))
(test-error-tail wrong-number-of-arguments-exception? (file-info-mode (file-info "file_info_temp") #f))
(test-error-tail wrong-number-of-arguments-exception? (file-mode))
(test-error-tail wrong-number-of-arguments-exception? (file-mode "file_info_temp" #f))

(test-error-tail wrong-number-of-arguments-exception? (file-info-number-of-links))
(test-error-tail wrong-number-of-arguments-exception? (file-info-number-of-links (file-info "file_info_temp") #f))
(test-error-tail wrong-number-of-arguments-exception? (file-number-of-links))
(test-error-tail wrong-number-of-arguments-exception? (file-number-of-links "file_info_temp" #f))

(test-error-tail wrong-number-of-arguments-exception? (file-info-owner))
(test-error-tail wrong-number-of-arguments-exception? (file-info-owner (file-info "file_info_temp") #f))
(test-error-tail wrong-number-of-arguments-exception? (file-owner))
(test-error-tail wrong-number-of-arguments-exception? (file-owner "file_info_temp" #f))

(test-error-tail wrong-number-of-arguments-exception? (file-info-group))
(test-error-tail wrong-number-of-arguments-exception? (file-info-group (file-info "file_info_temp") #f))
(test-error-tail wrong-number-of-arguments-exception? (file-group))
(test-error-tail wrong-number-of-arguments-exception? (file-group "file_info_temp" #f))

(test-error-tail wrong-number-of-arguments-exception? (file-info-size))
(test-error-tail wrong-number-of-arguments-exception? (file-info-size (file-info "file_info_temp") #f))
(test-error-tail wrong-number-of-arguments-exception? (file-size))
(test-error-tail wrong-number-of-arguments-exception? (file-size "file_info_temp" #f))

(test-error-tail wrong-number-of-arguments-exception? (file-info-last-access-time))
(test-error-tail wrong-number-of-arguments-exception? (file-info-last-access-time (file-info "file_info_temp") #f))
(test-error-tail wrong-number-of-arguments-exception? (file-last-access-time))
(test-error-tail wrong-number-of-arguments-exception? (file-last-access-time "file_info_temp" #f))

(test-error-tail wrong-number-of-arguments-exception? (file-info-last-modification-time))
(test-error-tail wrong-number-of-arguments-exception? (file-info-last-modification-time (file-info "file_info_temp") #f))
(test-error-tail wrong-number-of-arguments-exception? (file-last-modification-time))
(test-error-tail wrong-number-of-arguments-exception? (file-last-modification-time "file_info_temp" #f))

(test-error-tail wrong-number-of-arguments-exception? (file-info-attributes))
(test-error-tail wrong-number-of-arguments-exception? (file-info-attributes (file-info "file_info_temp") #f))
(test-error-tail wrong-number-of-arguments-exception? (file-attributes))
(test-error-tail wrong-number-of-arguments-exception? (file-attributes "file_info_temp" #f))

(test-error-tail wrong-number-of-arguments-exception? (file-info-last-change-time))
(test-error-tail wrong-number-of-arguments-exception? (file-info-last-change-time (file-info "file_info_temp") #f))
(test-error-tail wrong-number-of-arguments-exception? (file-last-change-time))
(test-error-tail wrong-number-of-arguments-exception? (file-last-change-time "file_info_temp" #f))

(test-error-tail type-exception? (file-info #f))
(test-error-tail type-exception? (file-info #f #f))
(test-error-tail type-exception? (file-info #f #f #f))

(test-error-tail type-exception? (file-info-type #f))
(test-error-tail type-exception? (file-type #f))

(test-error-tail type-exception? (file-info-device #f))
(test-error-tail type-exception? (file-device #f))

(test-error-tail type-exception? (file-info-inode #f))
(test-error-tail type-exception? (file-inode #f))

(test-error-tail type-exception? (file-info-mode #f))
(test-error-tail type-exception? (file-mode #f))

(test-error-tail type-exception? (file-info-number-of-links #f))
(test-error-tail type-exception? (file-number-of-links #f))

(test-error-tail type-exception? (file-info-owner #f))
(test-error-tail type-exception? (file-owner #f))

(test-error-tail type-exception? (file-info-group #f))
(test-error-tail type-exception? (file-group #f))

(test-error-tail type-exception? (file-info-size #f))
(test-error-tail type-exception? (file-size #f))

(test-error-tail type-exception? (file-info-last-access-time #f))
(test-error-tail type-exception? (file-last-access-time #f))

(test-error-tail type-exception? (file-info-last-modification-time #f))
(test-error-tail type-exception? (file-last-modification-time #f))

(test-error-tail type-exception? (file-info-attributes #f))
(test-error-tail type-exception? (file-attributes #f))

(test-error-tail type-exception? (file-info-last-change-time #f))
(test-error-tail type-exception? (file-last-change-time #f))

(delete-file "file_info_temp")
