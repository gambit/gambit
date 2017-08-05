(include "#.scm")

(for-each
 (lambda (t)
   (define obj-key '(1 2 3))

   (check-= (table-ref t 42) 2)
   (check-= (table-ref t 'test) 2)
   (check-= (table-ref t obj-key) 2)

   (table-set! t 42 777)
   (table-set! t 'test 888)
   (table-set! t obj-key 999)

   (check-= (table-ref t 42) 777)
   (check-= (table-ref t 'test) 888)
   (check-= (table-ref t obj-key) 999))

 (list (make-table init: 2)
       (make-table init: 2 weak-keys: #t)
       (make-table init: 2 weak-values: #t)
       (make-table init: 2 weak-keys: #t weak-values: #t)
       
       (make-table init: 2 test: eq?)
       (make-table init: 2 test: eq? weak-keys: #t)
       (make-table init: 2 test: eq? weak-values: #t)
       (make-table init: 2 test: eq? weak-keys: #t weak-values: #t)))
