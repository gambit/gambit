(include "#.scm")

;; Exercise public exception accessors on errors raised by real operations.
;; Procedure identity, original arguments and argument positions are part
;; of the documented diagnostic contract.

(define (caught thunk) (with-exception-catcher (lambda (e) e) thunk))

(define table (make-table))
(define (bad-hash key) #f)
(define bad-hash-table (make-table hash: bad-hash))

(let ((e (caught (lambda () (vector-ref #(a b) 'bad)))))
  (test-eq #t (type-exception? e))
  (test-eq #f (type-exception? 'ordinary))
  (test-eq vector-ref (type-exception-procedure e))
  (test-equal '(#(a b) bad) (type-exception-arguments e))
  (test-equal '(2 . k) (type-exception-arg-id e))
  (test-eq 'exact-integer (type-exception-type-id e)))

(let ((e (caught (lambda () (string-ref "abc" 10)))))
  (test-eq #t (range-exception? e))
  (test-eq #f (range-exception? 'ordinary))
  (test-eq string-ref (range-exception-procedure e))
  (test-equal '("abc" 10) (range-exception-arguments e))
  (test-equal '(2 . k) (range-exception-arg-id e)))

(let ((e (caught (lambda () (quotient 1 0)))))
  (test-eq #t (divide-by-zero-exception? e))
  (test-eq #f (divide-by-zero-exception? 'ordinary))
  (test-eq quotient (divide-by-zero-exception-procedure e))
  (test-equal '(1 0) (divide-by-zero-exception-arguments e)))

(let ((e (caught (lambda () (fx+ (##greatest-fixnum) 1)))))
  (test-eq #t (fixnum-overflow-exception? e))
  (test-eq #f (fixnum-overflow-exception? 'ordinary))
  (test-eq fx+ (fixnum-overflow-exception-procedure e))
  (test-equal (list (##greatest-fixnum) 1) (fixnum-overflow-exception-arguments e)))

(let ((e (caught (lambda () (apply car '())))))
  (test-eq #t (wrong-number-of-arguments-exception? e))
  (test-eq #f (wrong-number-of-arguments-exception? 'ordinary))
  (test-eq car (wrong-number-of-arguments-exception-procedure e))
  (test-equal '() (wrong-number-of-arguments-exception-arguments e)))

(let ((e (caught (lambda () (make-table 'bad 1)))))
  (test-eq #t (keyword-expected-exception? e))
  (test-eq #f (keyword-expected-exception? 'ordinary))
  (test-eq make-table (keyword-expected-exception-procedure e))
  (test-equal '(bad 1) (keyword-expected-exception-arguments e)))

(let ((e (caught (lambda () (make-table not-a-table-option: 1)))))
  (test-eq #t (unknown-keyword-argument-exception? e))
  (test-eq #f (unknown-keyword-argument-exception? 'ordinary))
  (test-eq make-table (unknown-keyword-argument-exception-procedure e))
  (test-equal '(not-a-table-option: 1) (unknown-keyword-argument-exception-arguments e)))

(let ((e (caught (lambda () (utf8->string #u8(192 175))))))
  (test-eq #t (invalid-utf8-encoding-exception? e))
  (test-eq #f (invalid-utf8-encoding-exception? 'ordinary))
  (test-assert (procedure? (invalid-utf8-encoding-exception-procedure e)))
  (test-equal '(#u8(192 175) 0 2) (invalid-utf8-encoding-exception-arguments e)))

(let ((e (caught (lambda () (table-ref table 'missing)))))
  (test-eq #t (unbound-key-exception? e))
  (test-eq #f (unbound-key-exception? 'ordinary))
  (test-eq table-ref (unbound-key-exception-procedure e))
  (test-equal (list table 'missing) (unbound-key-exception-arguments e)))

(let ((e (caught (lambda () (table-set! bad-hash-table 'key 42)))))
  (test-eq #t (invalid-hash-number-exception? e))
  (test-eq #f (invalid-hash-number-exception? 'ordinary))
  (test-eq bad-hash (invalid-hash-number-exception-procedure e))
  (test-equal '(key) (invalid-hash-number-exception-arguments e)))

(let ((e (caught (lambda () (getenv "GAMBIT_UNIT_TEST_ABSENT_ENVIRONMENT_VARIABLE_5D217F")))))
  (test-eq #t (unbound-os-environment-variable-exception? e))
  (test-eq #f (unbound-os-environment-variable-exception? 'ordinary))
  (test-eq getenv (unbound-os-environment-variable-exception-procedure e))
  (test-equal '("GAMBIT_UNIT_TEST_ABSENT_ENVIRONMENT_VARIABLE_5D217F") (unbound-os-environment-variable-exception-arguments e)))

(let ((e (caught (lambda () (serial-number->object 1000000)))))
  (test-eq #t (unbound-serial-number-exception? e))
  (test-eq #f (unbound-serial-number-exception? 'ordinary))
  (test-eq serial-number->object (unbound-serial-number-exception-procedure e))
  (test-equal '(1000000) (unbound-serial-number-exception-arguments e)))

(let ((e (caught (lambda () (compilation-target)))))
  (test-eq #t (not-in-compilation-context-exception? e))
  (test-eq #f (not-in-compilation-context-exception? 'ordinary))
  (test-eq compilation-target (not-in-compilation-context-exception-procedure e))
  (test-equal '() (not-in-compilation-context-exception-arguments e)))

(let ((e (caught (lambda () (error "message" 'a 42)))))
  (test-eq #t (error-exception? e))
  (test-eq #f (error-exception? 'message))
  (test-equal "message" (error-exception-message e))
  (test-equal '(a 42) (error-exception-parameters e))
  (test-eq #t (error-object? e))
  (test-eq #f (error-object? #f))
  (test-equal "message" (error-object-message e))
  (test-equal '(a 42) (error-object-irritants e))
  (test-assert
   (string-contains (call-with-output-string (lambda (p) (display-exception e p)))
                    "message")))

(let ((e (caught (lambda () (with-input-from-string "#\\pace" read)))))
  (test-eq #t (datum-parsing-exception? e))
  (test-eq #f (datum-parsing-exception? 'ordinary))
  (test-eq 'invalid-character-name (datum-parsing-exception-kind e))
  (test-equal '("pace") (datum-parsing-exception-parameters e))
  (test-assert (datum-parsing-exception-readenv e)))

(let ((e (caught (lambda () (eval '(if))))))
  (test-eq #t (expression-parsing-exception? e))
  (test-eq #f (expression-parsing-exception? #f))
  (test-assert (symbol? (expression-parsing-exception-kind e)))
  (test-assert (list? (expression-parsing-exception-parameters e)))
  (test-assert (expression-parsing-exception-source e)))

;; eval keeps these invalid forms out of the enclosing file's compilation.
(let ((e (caught (lambda () (eval '(42 1 2))))))
  (test-eq #t (nonprocedure-operator-exception? e))
  (test-eq #f (nonprocedure-operator-exception? #f))
  (test-eqv 42 (nonprocedure-operator-exception-operator e))
  (test-equal '(1 2) (nonprocedure-operator-exception-arguments e))
  (test-assert (nonprocedure-operator-exception-code e))
  (test-eq #f (nonprocedure-operator-exception-rte e)))

(let ((e (caught (lambda ()
                   (eval '(let-values (((a b) (values 11 22 33))) (+ a b)))))))
  (test-eq #t (wrong-number-of-values-exception? e))
  (test-eq #f (wrong-number-of-values-exception? #f))
  (test-equal '(11 22 33)
   (call-with-values (lambda () (wrong-number-of-values-exception-vals e)) list))
  (test-assert (wrong-number-of-values-exception-code e))
  (test-eq #f (wrong-number-of-values-exception-rte e)))

(let ((e (caught (lambda () (eval 'gambit-unit-test-unbound-global-5d217f)))))
  (test-eq #t (unbound-global-exception? e))
  (test-eq #f (unbound-global-exception? #f))
  (test-eq 'gambit-unit-test-unbound-global-5d217f (unbound-global-exception-variable e))
  (test-assert (unbound-global-exception-code e))
  (test-eq #f (unbound-global-exception-rte e)))

(test-eq 'reason
 (call/cc
  (lambda (escape)
    (with-exception-handler
     (lambda (e)
       (if (noncontinuable-exception? e)
           (escape (noncontinuable-exception-reason e))
           'returned))
     (lambda () (abort 'reason))))))
(test-eq #f (noncontinuable-exception? #f))

;; Strict length checking is the same mode used by vector_every.scm.
(let ((previous ##allow-length-mismatch?))
  (dynamic-wind
   (lambda () (set! ##allow-length-mismatch? #f))
   (lambda ()
     (let ((e (caught (lambda () (vector-every + '#(1) '#(1 2) '#(1))))))
       (test-eq #t (length-mismatch-exception? e))
       (test-eq #f (length-mismatch-exception? #f))
       (test-eq vector-every (length-mismatch-exception-procedure e))
       (test-equal (list + '#(1) '#(1 2) '#(1))
                    (length-mismatch-exception-arguments e))
       (test-eqv 3 (length-mismatch-exception-arg-id e))))
   (lambda () (set! ##allow-length-mismatch? previous))))
