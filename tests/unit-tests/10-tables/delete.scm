(define obj-key '(1 2 3))

(for-each
 (lambda (t)


   (table-set! t 42 777)
   (table-set! t 'test 888)
   (table-set! t obj-key 999)

   (println (table-ref t 42 "not found"))
   (println (table-ref t 'test "not found"))
   (println (table-ref t obj-key "not found"))

   (table-set! t 42)
   (table-set! t 'test)
   (table-set! t obj-key)

   (println (table-ref t 42 "not found"))
   (println (table-ref t 'test "not found"))
   (println (table-ref t obj-key "not found")))

 (list (make-table)
       (make-table weak-keys: #t)
       (make-table weak-values: #t)
       (make-table weak-keys: #t weak-values: #t)

       (make-table test: eq?)
       (make-table test: eq? weak-keys: #t)
       (make-table test: eq? weak-values: #t)
       (make-table test: eq? weak-keys: #t weak-values: #t)))

