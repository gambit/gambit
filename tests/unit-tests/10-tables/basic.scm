(include "#.scm")

(for-each
 (lambda (t)
   ;; Primitive keys
   (define prim-keys-a (list 1 2 #t #f #!void '() 'symbol '|special symbol| '|123|))
   (define prim-keys-b (list 1 2 #t #f #!void '() 'symbol '|special symbol| '|123|))

   ;; Object keys
   (define str "key")
   (define bignum 12893187263876213876213876128736498328443298679821739812739832879)
   (define flonum 77.77)
   (define ratnum 1/3)
   (define cpxnum +1.0-i)
   (define table-key (make-table))
   (define fct-key (lambda (x) x))
   (define keyword keyword:)
   (define uninterned-symbol (string->uninterned-symbol "unintered-symbol"))
   (define uninterned-keyword (string->uninterned-keyword "unintered-keyword"))

   (define obj-keys (list str bignum flonum ratnum cpxnum table-key fct-key prim-keys-a uninterned-symbol uninterned-keyword))

   (for-each
    (lambda (key)
      (table-set! t key key))
    prim-keys-a)

   (check-= (length prim-keys-a) (table-length t))

   (for-each
    (lambda (key)
      (table-set! t key key))
    obj-keys)

   (check-= (+ (length prim-keys-a) (length obj-keys)) (table-length t))

   (for-each
    (lambda (key)
      (check-eq? (table-ref t key "default") key))
    (append prim-keys-b obj-keys))

   (check-equal? (table-ref t -123 "not-found") "not-found")
   (check-equal? (table-ref t 'not-found "not-found") "not-found"))

 (list (make-table)
       (make-table weak-keys: #t)
       (make-table weak-values: #t)
       (make-table weak-keys: #t weak-values: #t)
       
       (make-table test: eq?)
       (make-table test: eq? weak-keys: #t)
       (make-table test: eq? weak-values: #t)
       (make-table test: eq? weak-keys: #t weak-values: #t)))
