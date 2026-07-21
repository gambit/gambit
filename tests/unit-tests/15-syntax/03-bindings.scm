(include "#.scm")

(include "./_source-match.scm")

(define (gbt-count gbt)
  (apply +
    (map (lambda (e)
           (apply +
             (map (lambda (se) (length (cdr se)))
                  (##table->list (cdr e)))))
         (##table->list gbt))))

;;;----------------------------------------------------------------------------
;;; bindings insertion

; hcte-add-new-local-binding!
; ##binding-local?
; ##binding-local-key

(let ((cte (##make-top-cte))
      (id  (##make-syntax-source 'x #f)))
  (let ((key (hcte-add-new-local-binding! cte id)))
    (let ((lst (table->list (##cte-top-global-binding-table cte))))
      (and (= (length lst) 1)
           (let* ((entry   (car lst))
                  (binding (car (cdr (car (##table->list (cdr entry))))))
                  (name    (car binding))
                  (val     (cdr binding)))
             (check-true
               (and (equal? name id)
                    (and (vector? val)
                         (= (vector-length val) 2)
                         (equal? key (vector-ref val 0)))
                    (and (##binding-local? val)
                         (not (##binding-top-level? val))
                         (equal? key (##binding-local-key val))))))))))

; hcte-add-new-top-level-binding!
; ##binding-top-level?
; ##binding-top-level-symbol

(let ((cte (##make-top-cte))
      (id  (##make-syntax-source 'x #f)))
  (let ((key (hcte-add-new-top-level-binding! cte id)))
    (let ((lst (table->list (##cte-top-global-binding-table cte))))
      (and (= (length lst) 1)
           (let* ((entry   (car lst))
                  (binding (car (cdr (car (##table->list (cdr entry))))))
                  (name    (car binding))
                  (val     (cdr binding)))
             (check-true
               (and (equal? name id)
                    (and (vector? val)
                         (= (vector-length val))
                         (equal? key (vector-ref val 0)))
                    (and (##binding-top-level? val)
                         (not (##binding-local? val))
                         (equal? key (##binding-top-level-symbol val))))))))))

;;;----------------------------------------------------------------------------
;;; ctx-binding insertion 

; hcte-add-variable-cte
; ctx-binding-variable?

(let ((cte (##make-top-cte))
      (id  (##make-syntax-source 'x #f)))
  (let ((key (hcte-add-new-top-level-binding! cte id)))
    (let ((new-cte (hcte-add-variable-cte cte key id)))
      (let ((lst (##hash-set-hamt->list (##cte-ctx new-cte))))
        (check-true
          (and (list? lst)
               (= (length lst) 1)
               (let* ((cte-binding (car lst))
                      (binding-key (car cte-binding))
                      (binding-val (cdr cte-binding)))
                 (and (equal? binding-key key)
                      (and (##ctx-binding-variable? binding-val)
                           (not (##ctx-binding-macro? binding-val))
                           (not (##ctx-binding-core-macro? binding-val)))))))))))
      

; hcte-add-macro-cte
; ##ctx-binding-macro?

(let ((cte (##make-top-cte))
      (id  (##make-syntax-source 'x #f)))
  (let ((key (hcte-add-new-top-level-binding! cte id)))
    (let ((new-cte (hcte-add-macro-cte cte key id (##make-syntax-source '+ #f))))
      (let ((lst (##hash-set-hamt->list (##cte-ctx new-cte))))
        (check-true
          (and (list? lst)
               (= (length lst) 1)
               (let* ((cte-binding (car lst))
                      (binding-key (car cte-binding))
                      (binding-val (cdr cte-binding)))
                 (and (equal? binding-key key)
                      (and (##ctx-binding-macro? binding-val)
                           (not (##ctx-binding-variable? binding-val))
                           (not (##ctx-binding-core-macro? binding-val)))
                      (and #t ; TODO check for descrs
                           #t)))))))))

; hcte-add-core-macro-cte
; ##ctx-binding-core-macro?

(let ((cte (##make-top-cte))
      (id  (##make-syntax-source 'x #f)))
  (let ((key (hcte-add-new-top-level-binding! cte id)))
    (let ((new-cte (hcte-add-core-macro-cte cte key id (##make-syntax-source '+ #f))))
      (let ((lst (##hash-set-hamt->list (##cte-ctx new-cte))))
        (check-true
          (and (list? lst)
               (= (length lst) 1)
               (let* ((cte-binding (car lst))
                      (binding-key (car cte-binding))
                      (binding-val (cdr cte-binding)))
                 (and (equal? binding-key key)
                      (and (##ctx-binding-core-macro? binding-val)
                           (not (##ctx-binding-variable? binding-val))
                           (not (##ctx-binding-macro? binding-val)))
                      (and #t ; TODO check for descrs
                           #t)))))))))

;;;----------------------------------------------------------------------------
;;; resolve-id

;;; top-level

(let* ((top-cte (##make-top-cte))
       (id  (##make-syntax-source 'x #f))
       (key (hcte-add-new-top-level-binding! top-cte id))
       (binding (resolve-id id top-cte)))
  ; simple insert
  (check-true
    (and (##binding-top-level? binding)
         (not (##binding-local? binding))
         (equal? (##binding-top-level-symbol binding) key)))
  (let* ((id2 (##make-syntax-source 'y #f))
         (key2 (hcte-add-new-top-level-binding! top-cte id2))
         (binding   (resolve-id id top-cte))
         (binding2  (resolve-id id2 top-cte)))
    ; second simple insert
    (check-true
      (and (##binding-top-level? binding)
           (not (##binding-local? binding))
           (equal? (##binding-top-level-symbol binding) key)))

    (check-true
      (and (##binding-top-level? binding2)
           (not (##binding-local? binding2))
           (equal? (##binding-top-level-symbol binding2) key2)))

    (let* ((id3 id)
           (key3 (hcte-add-new-top-level-binding! top-cte id3))
           (binding3 (resolve-id id top-cte)))

      ; re-definition
      (check-true
        (and (##binding-top-level? binding3)
             (not (##binding-local? binding3))
             (equal? (##binding-top-level-symbol binding) key3)))

      ; no top-level duplicate
      (check-true 
        (= (gbt-count (##cte-top-global-binding-table top-cte))
           2))

      (let* ((id4 (add-scope (##make-syntax-source 'x #f) core-scope))
             (key4 (hcte-add-new-top-level-binding! top-cte id4))
             (binding4 (resolve-id id4 top-cte)))

        ; simple insert same name differents scopes
        (check-true
          (and (##binding-top-level? binding4)
               (not (##binding-local? binding4))
               (equal? (##binding-top-level-symbol binding) key4)))
        (check-true 
          (= (gbt-count (##cte-top-global-binding-table top-cte))
             3))))))

;; local

(let* ((top-cte (##make-top-cte))
       (id  (##make-syntax-source 'x #f))
       (key (hcte-add-new-local-binding! top-cte id))
       (binding (resolve-id id top-cte)))
  ; simple insert
  (check-true
    (and (##binding-local? binding)
         (not (##binding-top-level? binding))
         (equal? (##binding-local-key binding) key)))
  (let* ((id2 (##make-syntax-source 'y #f))
         (key2 (hcte-add-new-local-binding! top-cte id2))
         (binding   (resolve-id id top-cte))
         (binding2  (resolve-id id2 top-cte)))
    ; second simple insert
    (check-true
      (and (##binding-local? binding)
           (not (##binding-top-level? binding))
           (equal? (##binding-local-key binding) key)))

    (let* ((id3 id)
           (key3 (hcte-add-new-local-binding! top-cte id3))
           (binding3 (resolve-id id top-cte)))

      ; re-definition
      (check-true
        (and (##binding-local? binding3)
             (not (##binding-top-level? binding3))
             (not (equal? (##binding-local-key binding) key3))))

      ; no local duplicate
      (check-true 
        (= (gbt-count (##cte-top-global-binding-table top-cte))
           2))

      (let* ((id4 (add-scope (##make-syntax-source 'x #f) core-scope))
             (key4 (hcte-add-new-local-binding! top-cte id4))
             (binding4 (resolve-id id4 top-cte)))

        ; simple insert same name differents scopes
        (check-true
          (and (##binding-local? binding4)
               (not (##binding-top-level? binding4))
               (not (equal? (##binding-local-key binding) key4))))
        (check-true 
          (= (gbt-count (##cte-top-global-binding-table top-cte))
             3))))))

;; resolve-binding

;; top-level
(let* ((cte (##make-top-cte))
       (id  (##make-syntax-source 'x #f))
       (descr (datum->syntax '0))
       (key (hcte-add-new-top-level-binding! cte id))
       (cte-var        (hcte-add-variable-cte cte key id))
       (cte-macro      (hcte-add-macro-cte cte key id descr))
       (cte-core-macro (hcte-add-core-macro-cte cte key id descr)))
  (let* ((default-var (resolve-binding id cte))
         (nt-fnd      (resolve-binding id (##make-top-cte)))
         (ctx-b-var        (resolve-binding id cte-var))
         (ctx-b-macro      (resolve-binding id cte-macro))
         (ctx-b-core-macro (resolve-binding id cte-core-macro)))
    ; default to variable for top-level binding
    #;(check-true 
      (##ctx-binding-variable? default-var))
    ;not found
    (check-true
      (##not-found-object? nt-fnd))

    (check-true
      (##ctx-binding-variable? ctx-b-var))
    (check-true
      (##ctx-binding-macro? ctx-b-macro))
    (check-true
      (##ctx-binding-core-macro? ctx-b-core-macro))))


;; local

;; base
(let* ((cte (##make-top-cte))
       (id  (##make-syntax-source 'x #f))
       (descr (datum->syntax '0))
       (key (hcte-add-new-local-binding! cte id))
       (cte-var        (hcte-add-variable-cte cte key id))
       (cte-macro      (hcte-add-macro-cte cte key id descr))
       (cte-core-macro (hcte-add-core-macro-cte cte key id descr)))
  (let* ((default-var (resolve-binding id cte))
         (nt-fnd      (resolve-binding id (##make-top-cte)))
         (ctx-b-var        (resolve-binding id cte-var))
         (ctx-b-macro      (resolve-binding id cte-macro))
         (ctx-b-core-macro (resolve-binding id cte-core-macro)))
    ; default to variable for top-level binding
    (check-true 
      (##not-found-object? default-var))
    ;not found
    (check-true
      (##not-found-object? nt-fnd))
    (check-true
      (##ctx-binding-variable? ctx-b-var))
    (check-true
      (##ctx-binding-macro? ctx-b-macro))
    (check-true
      (##ctx-binding-core-macro? ctx-b-core-macro))))

;; variables
(let* ((cte  (##make-top-cte))
       (scp1 (make-scope))
       (scp2 (make-scope))
       (id1  (##make-syntax-source 'x #f))
       (id2  (add-scope (##make-syntax-source 'y #f) scp1))
       (id3  (add-scope (##make-syntax-source 'x #f) scp1)))
  (let* ((key1 (hcte-add-new-local-binding! cte id1))
         (cte1 (hcte-add-variable-cte cte key1 id1)))

    (check-equal?
      id1
      (let ((b (resolve-binding id1 cte1)))
        (and (##ctx-binding-variable? b)
             (##ctx-binding-variable-hint b))))

    (check-equal?
      id1
      (let ((b (resolve-binding id3 cte1)))
        (and (##ctx-binding-variable? b)
             (##ctx-binding-variable-hint b))))

    (let* ((key2 (hcte-add-new-local-binding! cte1 id2))
           (cte2 (hcte-add-variable-cte cte1 key2 id2)))

      (check-equal?
        id1
        (let ((b (resolve-binding id1 cte2)))
          (and (##ctx-binding-variable? b)
               (##ctx-binding-variable-hint b))))
      (check-equal?
        id2
        (let ((b (resolve-binding id2 cte2)))
          (and (##ctx-binding-variable? b)
               (##ctx-binding-variable-hint b))))

      (let* ((key3 (hcte-add-new-local-binding! cte2 id3))
             (cte3 (hcte-add-variable-cte cte2 key3 id3)))

        (check-equal?
          id3
          (let ((b (resolve-binding id3 cte3)))
            (and (##ctx-binding-variable? b)
                 (##ctx-binding-variable-hint b))))

        (check-equal?
          id2
          (let ((b (resolve-binding id2 cte3)))
            (and (##ctx-binding-variable? b)
                 (##ctx-binding-variable-hint b))))))))

;; macro
(let* ((cte  (##make-top-cte))
       (scp1 (make-scope))
       (scp2 (make-scope))
       (id1  (##make-syntax-source 'x #f))
       (id2  (add-scope (##make-syntax-source 'y #f) scp1))
       (id3  (add-scope (##make-syntax-source 'x #f) scp1))
       (val1 (##make-syntax-source 'ex1 #f))
       (val2 (add-scope (##make-syntax-source 'ex2 #f) scp1))
       (val3 (add-scope (##make-syntax-source 'ex3 #f) scp1)))
  (let* ((key1 (hcte-add-new-local-binding! cte id1))
         (cte1 (hcte-add-macro-cte cte key1 id1 val1)))

    (check-equal?
      val1
      (let ((b (resolve-binding id1 cte1)))
        (and (##ctx-binding-macro? b)
             (##ctx-binding-macro-expander b))))

    (check-equal?
      val1
      (let ((b (resolve-binding id3 cte1)))
        (and (##ctx-binding-macro? b)
             (##ctx-binding-macro-expander b))))

    (let* ((key2 (hcte-add-new-local-binding! cte1 id2))
           (cte2 (hcte-add-macro-cte cte1 key2 id2 val2)))

      (check-equal?
        val1
        (let ((b (resolve-binding id1 cte2)))
          (and (##ctx-binding-macro? b)
               (##ctx-binding-macro-expander b))))
      (check-equal?
        val2
        (let ((b (resolve-binding id2 cte2)))
          (and (##ctx-binding-macro? b)
               (##ctx-binding-macro-expander b))))

      (let* ((key3 (hcte-add-new-local-binding! cte2 id3))
             (cte3 (hcte-add-macro-cte cte2 key3 id3 val3)))

        (check-equal?
          val3
          (let ((b (resolve-binding id3 cte3)))
            (and (##ctx-binding-macro? b)
                 (##ctx-binding-macro-expander b))))

        (check-equal?
          val2
          (let ((b (resolve-binding id2 cte3)))
            (and (##ctx-binding-macro? b)
                 (##ctx-binding-macro-expander b))))))))

;; core-macro
(let* ((cte  (##make-top-cte))
       (scp1 (make-scope))
       (scp2 (make-scope))
       (id1  (##make-syntax-source 'x #f))
       (id2  (add-scope (##make-syntax-source 'y #f) scp1))
       (id3  (add-scope (##make-syntax-source 'x #f) scp1))
       (val1 (##make-syntax-source 'ex1 #f))
       (val2 (add-scope (##make-syntax-source 'ex2 #f) scp1))
       (val3 (add-scope (##make-syntax-source 'ex3 #f) scp1)))
  (let* ((key1 (hcte-add-new-local-binding! cte id1))
         (cte1 (hcte-add-core-macro-cte cte key1 id1 val1)))

    (check-equal?
      val1
      (let ((b (resolve-binding id1 cte1)))
        (and (##ctx-binding-core-macro? b)
             (##ctx-binding-core-macro-expander b))))

    (check-equal?
      val1
      (let ((b (resolve-binding id3 cte1)))
        (and (##ctx-binding-core-macro? b)
             (##ctx-binding-core-macro-expander b))))

    (let* ((key2 (hcte-add-new-local-binding! cte1 id2))
           (cte2 (hcte-add-core-macro-cte cte1 key2 id2 val2)))

      (check-equal?
        val1
        (let ((b (resolve-binding id1 cte2)))
          (and (##ctx-binding-core-macro? b)
               (##ctx-binding-core-macro-expander b))))
      (check-equal?
        val2
        (let ((b (resolve-binding id2 cte2)))
          (and (##ctx-binding-core-macro? b)
               (##ctx-binding-core-macro-expander b))))

      (let* ((key3 (hcte-add-new-local-binding! cte2 id3))
             (cte3 (hcte-add-core-macro-cte cte2 key3 id3 val3)))

        (check-equal?
          val3
          (let ((b (resolve-binding id3 cte3)))
            (and (##ctx-binding-core-macro? b)
                 (##ctx-binding-core-macro-expander b))))

        (check-equal?
          val2
          (let ((b (resolve-binding id2 cte3)))
            (and (##ctx-binding-core-macro? b)
                 (##ctx-binding-core-macro-expander b))))))))

;;;----------------------------------------------------------------------------
;;; identifier predicates (bound-identifier=? & free-identifier=?)

(let* ((scp1 (make-scope))
       (ix   (##make-syntax-source 'x #f))
       (ix2  (##make-syntax-source 'x #f))
       (iy   (##make-syntax-source 'y #f))
       (inum (##make-syntax-source 0 #f))
       (ixs  (add-scope ix scp1)))

  ; same symbol, both scope-free
  (check-true (and (bound-identifier=? ix ix2) #t))
  ; same symbol, different scope sets
  (check-true (not (bound-identifier=? ix ixs)))
  ; different symbol
  (check-true (not (bound-identifier=? ix iy)))
  ; same symbol, same scope
  (check-true (and (bound-identifier=? (add-scope ix2 scp1) ixs) #t))
  ; non-identifier argument
  (check-true (not (bound-identifier=? inum ix)))

  (check-true (and (free-identifier=? ix ixs) #t))
  (check-true (not (free-identifier=? ix iy))))

(let* ((scp1 (make-scope))
       (car1 (add-scope (##make-syntax-source 'car #f) core-scope))
       (car2 (add-scope car1 scp1)))
  (check-true (and (free-identifier=? car1 car2) #t))
  (check-true (not (bound-identifier=? car1 car2))))

;;;----------------------------------------------------------------------------
