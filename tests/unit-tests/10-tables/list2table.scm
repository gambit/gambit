(include "#.scm")

(for-each
 (lambda (args)
   
   ;; Primitive keys
   (define prim-keys-a
     (list 1 2 #t #f #!void '() 'symbol '|special symbol| '|123|))
   (define prim-keys-b
     (list 1 2 #t #f #!void '() 'symbol '|special symbol| '|123|))
   
   ;; Object keys
   (define str "key")
   (define bignum
     12893187263876213876213876128736498328443298679821739812739832879)
   (define flonum 77.77)
   (define ratnum 1/3)
   (define cpxnum 1.-i)
   (define table-key (make-table))
   (define fct-key (lambda (x) x))
   (define keyword keyword:)
   (define uninterned-symbol (string->uninterned-symbol "unintered-symbol"))
   (define uninterned-keyword (string->uninterned-keyword "unintered-keyword"))
   
   (define obj-keys
     (list str
           bignum
           flonum
           ratnum
           cpxnum
           table-key
           fct-key
           prim-keys-a
           uninterned-symbol
           uninterned-keyword))
   
   (define alist
     (map (lambda (key) (cons key key)) (append obj-keys prim-keys-a)))
   (define t (apply list->table (cons alist args)))
   
   (test-approximate (length alist) (table-length t) 1e-12)
   
   (for-each
    (lambda (key) (test-eq key (table-ref t key "default")))
    (append prim-keys-b obj-keys))
   (test-equal "not found" (table-ref t -123 "not found"))
   (test-equal "not found" (table-ref t 'not-found "not found")))
 
 (list '()
       (list weak-keys: #t)
       (list weak-values: #t)
       (list weak-keys: #t weak-values: #t)
       (list test: eq?)
       (list test: eq? weak-keys: #t)
       (list test: eq? weak-values: #t)
       (list test: eq? weak-keys: #t weak-values: #t)))
