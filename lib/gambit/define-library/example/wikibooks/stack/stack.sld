

;; Source: https://en.wikibooks.org/wiki/Scheme_Programming/Libraries
(define-library (wikibooks stack)
  (import (scheme base))
  (export stack stack? stack-emty? stack-length stack-top
          stack-push! stack-pop!)

  (begin
    (define-record-type <stack>
      (list->stack values)
      stack?
      (values stack->list set-stack-values!))

    (define (stack . values)
      (list->stack values))

    (define (stack-length s)
      (length (stack->list s)))

    (define (stack-empty? s)
      (null? (stack->list s)))

    (define (stack-top s)
      (car (stack->list s)))

    (define (stack-push! s item)
      (set-stack-values! s (cons item (stack->list s))))

    (define (stack-pop! s)
      (if (stack-emty? s)
        (error "stack-pop!" "Popping from an empty stack")
        (let ((result (stack-top s)))
          (set-stack-values! s (cdr (stack->list s)))
          (result))))))

