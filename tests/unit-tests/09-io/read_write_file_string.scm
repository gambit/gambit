(include "#.scm")

(test-equal
 (void)
 (write-file-string "read_write_file_string_temp" "a\nb\nc"))

(test-equal
 "a\nb\nc"
 (read-file-string "read_write_file_string_temp"))

(delete-file "read_write_file_string_temp")

(test-equal
 (void)
 (write-file-string "read_write_file_string_temp" ""))

(test-equal
 ""
 (read-file-string "read_write_file_string_temp"))

(delete-file "read_write_file_string_temp")

(test-error-tail wrong-number-of-arguments-exception?
                 (write-file-string))
(test-error-tail wrong-number-of-arguments-exception?
                 (write-file-string "read_write_file_string_temp" "" #f))

(test-error-tail type-exception? (write-file-string #f ""))
(test-error-tail type-exception? (write-file-string "read_write_file_string_temp" #f))

(test-error-tail wrong-number-of-arguments-exception?
                 (read-file-string))
(test-error-tail wrong-number-of-arguments-exception?
                 (read-file-string "read_write_file_string_temp" #f))

(test-error-tail type-exception? (read-file-string #f))
