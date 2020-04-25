(include "#.scm")

(check-same-behavior ("" "##" "~~lib/gambit/prim/table#.scm")

;; Gambit

(list->table '()) (list->table '((a . 1))) (list->table '((a . 1)) size: 100 init: 999 weak-keys: #f weak-values: #f test: ##equal? hash: ##equal?-hash min-load: 0.3 max-load: 0.8)
(make-table size: 100 init: 999 weak-keys: #f weak-values: #f test: ##equal? hash: ##equal?-hash min-load: 0.3 max-load: 0.8)
(table->list (list->table '((a . 1))))
(table-copy (list->table '((a . 1))))
(table-for-each ##list (list->table '((a . 1))))
(table-length (list->table '((a . 1))))
(table-merge (list->table '((a . 1))) (list->table '((a . 2))))
(table-merge (list->table '((a . 1))) (list->table '((a . 2))) #t)
(let ((x (list->table '((a . 1))))) (table-merge! x (list->table '((a . 2)))) x)
(let ((x (list->table '((a . 1))))) (table-merge! x (list->table '((a . 2))) #t) x)
(table-ref (list->table '((a . 1))) 'a)
(table-ref (list->table '((a . 1))) 'b #f)
;;table-search
(let ((x (list->table '((a . 1))))) (table-set! x 'b 2) x)
(let ((x (list->table '((a . 1))))) (table-set! x 'a) x)
(table? (list->table '((a . 1)))) (table? 123)

)
