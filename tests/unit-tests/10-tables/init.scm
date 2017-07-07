(for-each
 (lambda (t)
   (define obj-key '(1 2 3))

   (println (table-ref t 42))
   (println (table-ref t 'test))
   (println (table-ref t obj-key))

   (table-set! t 42 777)
   (table-set! t 'test 888)
   (table-set! t obj-key 999)

   (println (table-ref t 42))
   (println (table-ref t 'test))
   (println (table-ref t obj-key)))

 (list (make-table init: 2)
       (make-table init: 2 weak-keys: #t)
       (make-table init: 2 weak-values: #t)
       (make-table init: 2 weak-keys: #t weak-values: #t)
       
       (make-table init: 2 test: eq?)
       (make-table init: 2 test: eq? weak-keys: #t)
       (make-table init: 2 test: eq? weak-values: #t)
       (make-table init: 2 test: eq? weak-keys: #t weak-values: #t)))

