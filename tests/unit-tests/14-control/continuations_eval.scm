(include "#.scm")

(test-eqv 10 (apply + 1 2 '(3 4)))
(test-equal '(a b c) (apply list '(a b c)))
(test-eqv 42 (call-with-current-continuation (lambda (escape) (escape 42) 0)))
(test-eqv 42
 (+ 2 (continuation-capture
        (lambda (k)
          (test-eq #t (continuation? k))
          (continuation-graft k + 10 30)
          0))))
(test-eq #f (continuation? (lambda () #f)))
(test-equal '(before body after)
 (let ((events '()))
   (call/cc
    (lambda (escape)
      (dynamic-wind
       (lambda () (set! events (cons 'before events)))
       (lambda () (set! events (cons 'body events)) (escape 'done))
       (lambda () (set! events (cons 'after events))))))
   (reverse events)))
(test-eqv 42 (eval '(+ 40 2) (scheme-report-environment 5)))
(test-eqv 42 (eval '((lambda (x) x) 42) (null-environment)))
(test-eqv 42 (eval '(+ 40 2) (interaction-environment)))
;; The source-aware reader supplies location context for syntax objects.
(define source-context (##read-expr-from-port (open-input-string "(context)")))
(test-equal '(a #(1 2)) (syntax->datum (datum->syntax source-context '(a #(1 2)))))
(test-equal '(a b) (map syntax->datum (syntax->list (datum->syntax source-context '(a b)))))
(test-equal '#(a b)
 (vector-map syntax->datum (syntax->vector (datum->syntax source-context '#(a b)))))
(test-eqv 42
 (r7rs-with-exception-handler (lambda (e) (+ e 2))
  (lambda () (r7rs-raise-continuable 40))))
(test-eq 'reason
 (with-exception-catcher (lambda (e) e) (lambda () (r7rs-raise 'reason))))
(test-error error-exception? (error "test error" 'irritant))
(test-error not-in-compilation-context-exception? (compilation-target))
