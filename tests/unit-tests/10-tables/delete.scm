(include "#.scm")
;; (define (check-= a b)
;;   (println "--------")
;;   (println a)
;;   (println "=?=")
;;   (println b))

;; (define (check-equal? a b)
;;   (println "--------")
;;   (println a)
;;   (println "eq?")
;;   (println b))

(define obj-key '(1 2 3))

(for-each
 (lambda (t)

   ;; Set some keys
   (table-set! t 42 777)
   (table-set! t 'test 888)
   (table-set! t obj-key 999)

   (check-= (table-ref t 42 "not found") 777)
   (check-= (table-ref t 'test "not found") 888)
   (check-= (table-ref t obj-key "not found") 999)

   ;; Unset them
   (table-set! t 42)
   (table-set! t 'test)
   (table-set! t obj-key)

   (check-equal? (table-ref t 42 "not found") "not found")
   (check-equal? (table-ref t 'test "not found") "not found")
   (check-equal? (table-ref t obj-key "not found") "not found")

   ;; Delete unknown keys
   (table-set! t -1)
   (table-set! t 'not-found)
   (table-set! t (cons "not" "found")))

 (list (make-table)
       ;(make-table weak-keys: #t)
       ;(make-table weak-values: #t)
       ;(make-table weak-keys: #t weak-values: #t)

       ;(make-table test: eq?)
       ;(make-table test: eq? weak-keys: #t)
       ;(make-table test: eq? weak-values: #t)
       #;(make-table test: eq? weak-keys: #t weak-values: #t)))

