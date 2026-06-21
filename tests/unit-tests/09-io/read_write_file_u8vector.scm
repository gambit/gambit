(include "#.scm")

(test-equal
 (void)
 (write-file-u8vector "read_write_file_u8vector_temp" '#u8(11 22 33 44)))

(test-equal
 '#u8(11 22 33 44)
 (read-file-u8vector "read_write_file_u8vector_temp"))

(delete-file "read_write_file_u8vector_temp")

(test-equal
 (void)
 (write-file-u8vector "read_write_file_u8vector_temp" '#u8()))

(test-equal
 '#u8()
 (read-file-u8vector "read_write_file_u8vector_temp"))

(delete-file "read_write_file_u8vector_temp")

(test-error-tail wrong-number-of-arguments-exception?
                 (write-file-u8vector))
(test-error-tail wrong-number-of-arguments-exception?
                 (write-file-u8vector "read_write_file_u8vector_temp" '#u8() #f))

(test-error-tail type-exception? (write-file-u8vector #f ""))
(test-error-tail type-exception? (write-file-u8vector "read_write_file_u8vector_temp" #f))

(test-error-tail wrong-number-of-arguments-exception?
                 (read-file-u8vector))
(test-error-tail wrong-number-of-arguments-exception?
                 (read-file-u8vector "read_write_file_u8vector_temp" #f))

(test-error-tail type-exception? (read-file-u8vector #f))
