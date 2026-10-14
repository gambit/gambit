(include "#.scm")

(define (text-roundtrip obj)
  (let ((text
         (with-output-to-string ""
           (lambda ()
             (output-port-readtable-set!
              (current-output-port)
              (readtable-sharing-allowed?-set
               (output-port-readtable (current-output-port)) 'serialize))
             (write obj)))))
    (with-input-from-string text read)))

(define (binary-roundtrip obj)
  (u8vector->object (object->u8vector obj)))

;; Keep the keys in the serialized graph so identity-based tables can be
;; queried with the corresponding deserialized objects, including heap keys.
(define (check-roundtrip roundtrip test)
  (let ((keys (vector 'alpha 123 #f #\a "string-key" '(1 2) '#(3 4)
                      (if (eq? test eq?) 'omega 1.25)))
        (table (make-table test: test init: 'missing)))
    (let add ((i 0))
      (if (< i (vector-length keys))
          (begin
            (table-set! table (vector-ref keys i) (+ i 100))
            (add (+ i 1)))))
    (let* ((copy (roundtrip (vector keys table)))
           (copy-keys (vector-ref copy 0))
           (copy-table (vector-ref copy 1)))
      (test-equal (vector-length keys) (table-length copy-table))
      (let check ((i 0))
        (if (< i (vector-length keys))
            (begin
              (test-equal (+ i 100)
                          (table-ref copy-table (vector-ref copy-keys i)))
              (check (+ i 1)))))
      (test-equal 'missing (table-ref copy-table 'absent-key))
      (table-set! copy-table 'alpha 'updated)
      (test-equal 'updated (table-ref copy-table 'alpha))
      (table-set! copy-table 123)
      (test-equal 'missing (table-ref copy-table 123))
      ;; Exercise insertion and resizing after the decoded entries exist.
      (let add ((i 0))
        (if (< i 100)
            (begin
              (table-set! copy-table (+ i 1000) (* i 7))
              (add (+ i 1)))))
      (let check ((i 0))
        (if (< i 100)
            (begin
              (test-equal (* i 7) (table-ref copy-table (+ i 1000)))
              (check (+ i 1)))))
      (test-equal 107 (table-length copy-table)))))

(for-each
 (lambda (roundtrip)
   (for-each (lambda (test) (check-roundtrip roundtrip test))
             (list eq? eqv? equal?))
   (let ((empty (roundtrip (make-table test: eq? init: 'missing))))
     (test-equal 0 (table-length empty))
     (test-equal 'missing (table-ref empty 'absent-key))))
 (list text-roundtrip binary-roundtrip))

;; Binary serialization supports references back to the containing table.
(let ((table (make-table test: eq?)))
  (table-set! table table 'self-key)
  (table-set! table 'self-value table)
  (let ((copy (binary-roundtrip table)))
    (test-equal 'self-key (table-ref copy copy))
    (test-eq copy (table-ref copy 'self-value))))
