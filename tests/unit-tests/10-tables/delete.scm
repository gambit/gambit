(include "#.scm")

(define obj-key '(1 2 3))

(for-each
 (lambda (t)
   
   ;; Set some keys
   (table-set! t 42 777)
   (table-set! t 'test 888)
   (table-set! t obj-key 999)
   
   (test-approximate 777 (table-ref t 42 "not found") 1e-12)
   (test-approximate 888 (table-ref t 'test "not found") 1e-12)
   (test-approximate 999 (table-ref t obj-key "not found") 1e-12)
   
   ;; Unset them
   (table-set! t 42)
   (table-set! t 'test)
   (table-set! t obj-key)
   
   (test-equal "not found" (table-ref t 42 "not found"))
   (test-equal "not found" (table-ref t 'test "not found"))
   (test-equal "not found" (table-ref t obj-key "not found"))
   
   ;; Delete unknown keys
   (table-set! t -1)
   (table-set! t 'not-found)
   (table-set! t (cons "not" "found")))
 
 (list (make-table)
       (make-table weak-keys: #t)
       (make-table weak-values: #t)
       (make-table weak-keys: #t weak-values: #t)
       
       (make-table test: eq?)
       (make-table test: eq? weak-keys: #t)
       (make-table test: eq? weak-values: #t)
       (make-table test: eq? weak-keys: #t weak-values: #t)))

