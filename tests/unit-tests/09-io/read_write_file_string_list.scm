(include "#.scm")

(test-equal
 (void)
 (write-file-string-list "read_write_file_string_list_temp" '("a" "b" "c")))

(test-equal
 '("a" "b" "c")
 (read-file-string-list "read_write_file_string_list_temp"))

(delete-file "read_write_file_string_list_temp")

(test-equal
 (void)
 (write-file-string-list "read_write_file_string_list_temp" '()))

(test-equal
 '()
 (read-file-string-list "read_write_file_string_list_temp"))

(delete-file "read_write_file_string_list_temp")

(test-error-tail wrong-number-of-arguments-exception?
                 (write-file-string-list))
(test-error-tail wrong-number-of-arguments-exception?
                 (write-file-string-list "read_write_file_string_list_temp" '() #f))

(test-error-tail type-exception? (write-file-string-list #f '()))
(test-error-tail type-exception? (write-file-string-list "read_write_file_string_list_temp" #f))

(test-error-tail wrong-number-of-arguments-exception?
                 (read-file-string-list))
(test-error-tail wrong-number-of-arguments-exception?
                 (read-file-string-list "read_write_file_string_list_temp" #f))

(test-error-tail type-exception? (read-file-string-list #f))
