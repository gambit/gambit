(include "#.scm")

;; Functional updates must preserve the original readtable. Exercise the
;; reader/printer as well as field access, using the manual's field contracts.

(define original (current-readtable))

(define (read-with table text)
  (call-with-input-string
   text
   (lambda (port)
     (input-port-readtable-set! port table)
     (read port))))

(define (write-with table object)
  (call-with-output-string
   (lambda (port)
     (output-port-readtable-set! port table)
     (write object port))))

(test-eq #t (readtable? original))
(test-eq #f (readtable? #f))
(test-eq #f (readtable? '#()))

(test-eq 'upcase
 (readtable-case-conversion?
  (readtable-case-conversion?-set original 'upcase)))
(test-equal "ICE"
 (symbol->string
  (read-with (readtable-case-conversion?-set original 'upcase) "Ice")))
(test-equal "ice"
 (symbol->string
  (read-with (readtable-case-conversion?-set original #t) "Ice")))
(test-equal "Ice"
 (symbol->string
  (read-with (readtable-case-conversion?-set original #f) "Ice")))
(test-assert
 (let ((before (readtable-case-conversion? original)))
   (readtable-case-conversion?-set original (not before))
   (eq? before (readtable-case-conversion? original))))

(test-eq 'prefix
 (readtable-keywords-allowed?
  (readtable-keywords-allowed?-set original 'prefix)))
(test-eq 'sample:
 (read-with (readtable-keywords-allowed?-set original 'prefix) ":sample"))
(test-eq 'sample:
 (read-with (readtable-keywords-allowed?-set original #t) "sample:"))
(test-equal ":sample"
 (symbol->string
  (read-with (readtable-keywords-allowed?-set original #f) ":sample")))

(test-eq #t
 (readtable-sharing-allowed?
  (readtable-sharing-allowed?-set original #t)))
(test-assert
 (let ((value (read-with (readtable-sharing-allowed?-set original #t)
                         "(#1=(a b) #1#)")))
   (and (equal? value '((a b) (a b))) (eq? (car value) (cadr value)))))

(test-eq #t
 (readtable-eval-allowed?
  (readtable-eval-allowed?-set original #t)))
(test-eqv 42
 (read-with (readtable-eval-allowed?-set original #t) "#.(+ 40 2)"))
(test-error datum-parsing-exception?
 (read-with (readtable-eval-allowed?-set original #f) "#.(+ 40 2)"))

(test-eq #t
 (readtable-write-cdr-read-macros?
  (readtable-write-cdr-read-macros?-set original #t)))
(test-equal "(a . 'b)"
 (write-with (readtable-write-cdr-read-macros?-set original #t) '(a quote b)))
(test-equal "(a quote b)"
 (write-with (readtable-write-cdr-read-macros?-set original #f) '(a quote b)))

(test-eq #t
 (readtable-write-extended-read-macros?
  (readtable-write-extended-read-macros?-set original #t)))
(test-equal "#'a"
 (write-with (readtable-write-extended-read-macros?-set original #t) '(syntax a)))
(test-equal "(syntax a)"
 (write-with (readtable-write-extended-read-macros?-set original #f) '(syntax a)))

(test-eqv 1
 (readtable-max-write-level
  (readtable-max-write-level-set original 1)))
(test-equal "(a (...) c)"
 (write-with (readtable-max-write-level-set original 1) '(a (b) c)))
(test-equal "(...)"
 (write-with (readtable-max-write-level-set original 0) '(a b c)))
(test-eqv 2
 (readtable-max-write-length
  (readtable-max-write-length-set original 2)))
(test-equal "(a b ...)"
 (write-with (readtable-max-write-length-set original 2) '(a b c d)))
(test-equal "(...)"
 (write-with (readtable-max-write-length-set original 0) '(a b c)))

(test-eqv #\x7f
 (readtable-max-unescaped-char
  (readtable-max-unescaped-char-set original #\x7f)))
(test-eq #f
 (readtable-max-unescaped-char
  (readtable-max-unescaped-char-set original #f)))
(test-equal "\"\x3bb;\""
 (write-with (readtable-max-unescaped-char-set original #\x10ffff) "\x3bb;"))
(test-assert
 (let ((text (write-with (readtable-max-unescaped-char-set original #\x7f)
                         "\x3bb;")))
   (and (not (string=? text "\"\x3bb;\""))
        (equal? (read-with original text) "\x3bb;"))))

(test-eq 'six
 (readtable-start-syntax
  (readtable-start-syntax-set original 'six)))
(test-equal '(+ 2 3)
 (read-with (readtable-start-syntax-set original #f) "(+ 2 3)"))

(test-error type-exception? (readtable-case-conversion? #f))
(test-error type-exception? (readtable-case-conversion?-set #f #t))
(test-error type-exception? (readtable-keywords-allowed? #f))
(test-error type-exception? (readtable-keywords-allowed?-set #f #t))
(test-error type-exception? (readtable-sharing-allowed? #f))
(test-error type-exception? (readtable-sharing-allowed?-set #f #t))
(test-error type-exception? (readtable-eval-allowed? #f))
(test-error type-exception? (readtable-eval-allowed?-set #f #t))
(test-error type-exception? (readtable-write-cdr-read-macros? #f))
(test-error type-exception? (readtable-write-cdr-read-macros?-set #f #t))
(test-error type-exception? (readtable-write-extended-read-macros? #f))
(test-error type-exception? (readtable-write-extended-read-macros?-set #f #t))
(test-error type-exception? (readtable-max-write-level #f))
(test-error range-exception? (readtable-max-write-level-set original -1))
(test-error type-exception? (readtable-max-write-length #f))
(test-error range-exception? (readtable-max-write-length-set original -1))
(test-error type-exception? (readtable-max-unescaped-char #f))
(test-error type-exception? (readtable-max-unescaped-char-set original 127))
(test-error type-exception? (readtable-start-syntax #f))
(test-error type-exception? (readtable-start-syntax-set #f 'six))

(test-equal '(42 (";kept"))
 (let* ((comments '())
        (handler (lambda (comment) (set! comments (cons comment comments))))
        (base (current-readtable))
        (rt (readtable-comment-handler-set base handler)))
   (test-eq handler (readtable-comment-handler rt))
   (test-eq #f (readtable-comment-handler base))
   (let ((datum (read-with rt ";kept\n42")))
     (list datum (reverse comments)))))
