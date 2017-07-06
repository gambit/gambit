(define t (make-table))

;; Primitive keys
(define prim-keys-a (list 1 2 #t #f #!void '() 'symbol '|special symbol| '|123|))
(define prim-keys-b (list 1 2 #t #f #!void '() 'symbol '|special symbol| '|123|))

;; Object keys
(define str1 "key")
(define str2 "key")
(define bignum 12893187263876213876213876128736498328443298679821739812739832879)
(define flonum 77.77)
(define ratnum 1/3)
(define cpxnum +1.0-i)
(define table-key (make-table))
(define fct-key (lambda (x) x))
(define keyword keyword:)
(define uninterned-symbol (string->uninterned-symbol "unintered-symbol"))
(define uninterned-keyword (string->uninterned-keyword "unintered-keyword"))

(define obj-keys '(list str1 str2 bignum flonum ratnum cpxnum table-key fct-key prim-keys-a uninterned-symbol uninterned-keyword))

(let loop ((i 0) (lst prim-keys-a))
  (if (not (null? lst))
      (let ((key (car lst)))
        (table-set! t
                    key
                    (cons 'prim- i))
        (loop (+ i 1) (cdr lst)))))

(println (= (length prim-keys-a) (table-length t)))

(let loop ((i 0) (lst obj-keys))
  (if (not (null? lst))
      (let ((key (car lst)))
        (table-set! t
                    key
                    (cons 'obj- i))
        (loop (+ i 1) (cdr lst)))))

(println (= (+ (length prim-keys-a) (length obj-keys)) (table-length t)))

(for-each (lambda (key)
            (println (table-ref t key "default")))
          prim-keys-b)

(for-each (lambda (key)
            (println (table-ref t key "default")))
          obj-keys)

(println (table-ref t -123 "not-found"))
(println (table-ref t 'not-found "not-found"))
