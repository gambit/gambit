;;; Various mutable data structures implemented behind processes

;; (it would be "better" if those were implemented functionally)

(define (data-make-process-name type)
  (string->symbol
    (string-append
      (symbol->string
        ((let () (##namespace ("")) thread-name)
          ((let () (##namespace ("")) current-thread))))
      "-"
      (symbol->string type))))

;; ----------------------------------------------------------------------------
;; Cells

(define (make-cell #!key (name (data-make-process-name 'cell))
                   #!rest content)
  (spawn
    (lambda ()
      (let loop ((content (if (pair? content)
                              (car content)
                              (void))))
        (recv
          ((from tag 'empty?)
           (! from (list tag (eq? (void) content)))
           (loop content))

          ((from tag 'ref)
           (! from (list tag content))
           (loop content))

          (('set! content)
           (loop content)))))
    name: name))


(define (cell-ref cell)
  (!? cell 'ref))

(define (cell-set! cell value)
  (! cell (list 'set! value)))

(define (cell-empty! cell)
  (! cell (list 'set! (void))))

(define (cell-empty? cell)
  (!? cell 'empty?))

;; or: (define-termite-type cell content)


;; ----------------------------------------------------------------------------
;; Dictionary

(define (make-dict #!key (name (data-make-process-name 'dictionary)))
  (spawn
    (lambda ()
      (let ((table (make-table test: equal?
                               init: #f)))
        (let loop ()
          (recv
            ((from tag ('dict?))
             (! from (list tag #t)))

            ((from tag ('dict-length))
             (! from (list tag (table-length table))))

            ((from tag ('dict-ref key))
             (! from (list tag (table-ref table key))))

            (('dict-set! key)
             (table-set! table key))

            (('dict-set! key value)
             (table-set! table key value))

            ((from tag ('dict-search proc))
             (! from (list tag (table-search proc table))))

            (('dict-for-each proc)
             (table-for-each proc table))

            ((from tag ('dict->list))
             (! from (list tag (table->list table))))

            ((msg
               (warning (list ignored: msg)))))

          (loop))))

    name: name))

(define (dict? dict)
  (!? dict (list 'dict?) 1 #f)) ;; we only give a second to reply to this

(define (dict-length dict)
  (!? dict (list 'dict-length)))

(define (dict-ref dict key)
  (!? dict (list 'dict-ref key)))

(define (dict-set! dict . args)
  (match args
    ((key)
     (! dict (list 'dict-set! key)))

    ((key value)
     (! dict (list 'dict-set! key value)))))

(define (dict-search proc dict)
  (!? dict (list 'dict-search proc)))

(define (dict-for-each proc dict)
  (! dict (list 'dict-for-each proc)))

(define (dict->list dict)
  (!? dict (list 'dict->list)))

;; test...

;; (init)
;;
;; (define dict (make-dict))
;;
;; (print (dict->list dict))
;; (dict-set! dict 'foo 123)
;; (dict-set! dict 'bar 42)
;; (print (dict->list dict))
;; (print (dict-search (lambda (k v) (eq? k 'bar) v) dict))
;; (dict-for-each (lambda (k v) (print k)) dict)
;; (dict-set! dict 'foo)
;; (print (dict->list dict))
;; (? 1 #t)


;; ----------------------------------------------------------------------------
;; Bag

(define (make-bag #!key (name (data-make-process-name 'bag)))
  (spawn
    (lambda ()
      (let ((table (make-table test: equal?
                               init: #f)))
        (let loop ()
          (recv
            ((from tag ('bag?))
             (! from (list tag #t)))

            ((from tag ('bag-length))
             (! from (list tag (table-length table))))

            (('bag-add! elt)
             (table-set! table elt #t))

            (('bag-remove! elt)
             (table-set! table elt))

            ((from tag ('bag-member? elt))
             (table-ref table elt))

            ((from tag ('bag-search proc))
             (! from (list tag (table-search (lambda (k v) (proc k)) table))))

            (('bag-for-each proc)
             (table-for-each (lambda (k v) (proc k)) table))

            ((from tag ('bag->list))
             (! from (list tag (map car (table->list table))))))

          (loop))))
    name: name))


(define (bag? bag)
  (!? bag (list 'bag?) 1 #f)) ;; we only give a second to reply to this

(define (bag-length bag)
  (!? bag (list 'bag-length)))

(define (bag-add! bag elt)
  (! bag (list 'bag-add! elt)))

(define (bag-remove! bag elt)
  (! bag (list 'bag-remove! elt)))

(define (bag-member? bag elt)
  (!? bag (list 'bag-member? elt)))

(define (bag-search proc bag)
  (!? bag (list 'bag-search proc)))

(define (bag-for-each proc bag)
  (! bag (list 'bag-for-each proc)))

(define (bag->list bag)
  (!? bag (list 'bag->list)))

;; test...

;; (init)
;;
;; (define bag (make-bag))
;;
;; (print (bag->list bag))
;; (bag-add! bag 'foo)
;; (bag-add! bag 'bar)
;; (print (bag->list bag))
;; (print (bag-search (lambda (elt) (eq? elt 'bar) elt) bag))
;; (bag-for-each (lambda (elt) (print elt)) bag)
;; (bag-remove! bag 'foo)
;; (print (bag->list bag))
;; (? 1 #t)
