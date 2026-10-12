;;; Regression for gambit/gambit#422: explicit internal operations inline in
;;; safe code, without changing the checking semantics of ordinary operations.

(define (check value message)
  (if (not value) (error message)))

(define (contains? text fragment)
  (let ((limit (- (string-length text) (string-length fragment))))
    (let loop ((i 0))
      (and (<= i limit)
           (or (string=? fragment (substring text i (+ i (string-length fragment))))
               (loop (+ i 1)))))))

(define operations
  '((define (read-slot obj) (##unchecked-structure-ref obj 1 #f #f))
    (define (write-slot obj value) (##unchecked-structure-set! obj value 1 #f #f))
    (define (read-pair obj) (##car obj))
    (define (read-vector obj i) (##vector-ref obj i))
    (define (write-vector obj i value) (##vector-set! obj i value))
    (define (sum-fixnums a b) (##fx+ a b))
    (define (less-fixnums a b) (##fx< a b))
    (define (minimum-fixnums a b) (if (##fx< a b) a b))
    (define (pair-test obj) (if (##car obj) 1 2))
    (define (small-vector n fill) (##make-u8vector-small n fill))
    (define (sum-flonums a b) (##fl+ a b))))

(define (fixture safety)
  `(begin
     (declare (block) (standard-bindings) (extended-bindings) ,safety)
     ,@operations))

(for-each
 (lambda (safety)
   (let* ((base (if (equal? safety '(safe))
                    "inline-primitives-safe"
                    "inline-primitives-unsafe"))
          (source (string-append base ".scm"))
          (target (string-append base ".c")))
     (check (compile-file-to-target source output: target expression: (fixture safety))
            "could not compile primitive fixture")
     (let ((code (call-with-input-file target (lambda (port) (read-line port #f)))))
       (for-each
        (lambda (instruction)
          (check (contains? code instruction)
                 (string-append base ": missing inline instruction " instruction)))
        '("___UNCHECKEDSTRUCTUREREF(" "___UNCHECKEDSTRUCTURESET("
          "___CAR(" "___VECTORREF(" "___VECTORSET("
          "___FIXADD(" "___FIXLT(" "___MAKEU8VECTORSMALL2(" "___F64ADD("))
       (check (not (contains? code "___JUMPPRM("))
              (string-append base ": out-of-line primitive call")))
     (delete-file target)))
 '((safe) (not safe)))

(display "Internal primitives inline in safe and unsafe contexts.\n")
