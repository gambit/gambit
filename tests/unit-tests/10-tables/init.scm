(include "#.scm")

(for-each
 (lambda (t)
   (define obj-key '(1 2 3))
   
   (test-approximate 2 (table-ref t 42) 1e-12)
   (test-approximate 2 (table-ref t 'test) 1e-12)
   (test-approximate 2 (table-ref t obj-key) 1e-12)
   
   (table-set! t 42 777)
   (table-set! t 'test 888)
   (table-set! t obj-key 999)
   
   (test-approximate 777 (table-ref t 42) 1e-12)
   (test-approximate 888 (table-ref t 'test) 1e-12)
   (test-approximate 999 (table-ref t obj-key) 1e-12))
 
 (list (make-table init: 2)
       (make-table init: 2 weak-keys: #t)
       (make-table init: 2 weak-values: #t)
       (make-table init: 2 weak-keys: #t weak-values: #t)
       (make-table init: 2 test: eq?)
       (make-table init: 2 test: eq? weak-keys: #t)
       (make-table init: 2 test: eq? weak-values: #t)
       (make-table init: 2 test: eq? weak-keys: #t weak-values: #t)))
