(include "#.scm")

(for-each
 (lambda (args)

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

   (define alist (map (lambda (key)
                        (cons key key))
                      (append obj-keys prim-keys-a)))
   
   (define t (apply list->table (cons alist args)))

   (check-= (table-length t) (length alist))

   (for-each
    (lambda (key)
      (check-eq? (table-ref t key "default") key))
    (append prim-keys-b obj-keys))
   
   (check-equal? (table-ref t -123 "not found") "not found")
   (check-equal? (table-ref t 'not-found "not found") "not found"))

 (list '()
       (list weak-keys: #t)
       (list weak-values: #t)
       (list weak-keys: #t weak-values: #t)
       
       (list test: eq?)
       (list test: eq? weak-keys: #t)
       (list test: eq? weak-values: #t)
       (list test: eq? weak-keys: #t weak-values: #t)))
