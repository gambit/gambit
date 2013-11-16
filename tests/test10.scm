;;;============================================================================

;;; File: "test10.scm"

;;; Copyright (c) 2008-2013 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Check that the lib/gambit#.scm file is consistent with the
;; compiler's public procedures and special forms.

(define (main)

  (define pretend-defined-by-gambit '(
define-syntax
let-syntax
letrec-syntax
syntax-rules
six.!
six.break
six.case
six.clause
six.continue
six.goto
six.label
six.return
six.switch
six.x:-y
default-random-source
  ))

  (define (keep keep? lst)
    (cond ((null? lst)       '())
          ((keep? (car lst)) (cons (car lst) (keep keep? (cdr lst))))
          (else              (keep keep? (cdr lst)))))

  (define (sort-list lst <?)

    (define (mergesort lst)

      (define (merge lst1 lst2)
        (cond ((null? lst1) lst2)
              ((null? lst2) lst1)
              (else
               (let ((e1 (car lst1)) (e2 (car lst2)))
                 (if (<? e1 e2)
                     (cons e1 (merge (cdr lst1) lst2))
                     (cons e2 (merge lst1 (cdr lst2))))))))

      (define (split lst)
        (if (or (null? lst) (null? (cdr lst)))
            lst
            (cons (car lst) (split (cddr lst)))))

      (if (or (null? lst) (null? (cdr lst)))
          lst
          (let* ((lst1 (mergesort (split lst)))
                 (lst2 (mergesort (split (cdr lst)))))
            (merge lst1 lst2))))

    (mergesort lst))

  (define (symbol-table->list st)
    (apply append
           (map (lambda (s)
                  (let loop ((s s) (lst '()))
                    (if (symbol? s)
                        (loop (##vector-ref s 2) (cons s lst))
                        (reverse lst))))
                (vector->list st))))

  (define (hidden-id? id)
    (let ((str (symbol->string id)))
      (or (memv #\# (string->list str))
          #;
          (and (>= (string-length str) 2)
               (equal? (substring str 0 2) "##"))
          (and (>= (string-length str) 1)
               (equal? (substring str 0 1) " ")))))

  (define (public-id? id)
    (not (hidden-id? id)))

  (define (public-procedure? s)
    (and (public-id? s)
         (let ((val (##global-var-ref (##make-global-var s))))
           (procedure? val))))

  (define (extract-macros cte)
    (cond ((##cte-top? cte)
           '())
          ((##cte-macro? cte)
           (cons (##cte-macro-name cte)
                 (extract-macros (##cte-parent-cte cte))))
          (else
           (extract-macros (##cte-parent-cte cte)))))

  (define (read-namespace-names filename)
    (let ((ns (assq '##namespace (with-input-from-file filename read-all))))
      (if ns
          (cdr (cadr ns))
          '())))

  (define (gambit-macros)
    (extract-macros (##cte-top-cte ##interaction-cte)))

  (define (sort-symbols lst)
    (sort-list
     lst
     (lambda (x y) (string<? (symbol->string x) (symbol->string y)))))

  (let* ((public-procedures
          (keep public-procedure?
                (symbol-table->list (##symbol-table))))
         (public-macros
          (keep public-id? (gambit-macros)))
         (sorted-public-names
          (sort-symbols
           (append public-macros
                   public-procedures
                   pretend-defined-by-gambit)))
         (r4rs-public-names
          (read-namespace-names "../lib/r4rs#.scm"))
         (r5rs-public-names
          (append
           r4rs-public-names
           (read-namespace-names "../lib/r5rs#.scm")))
         (gambit-public-names
          (append
           r5rs-public-names
           (read-namespace-names "../lib/gambit#.scm")))
         (missing-from-gambit-public-names
          (keep (lambda (name)
                  (not (memq name gambit-public-names)))
                sorted-public-names))
         (extras-in-gambit-public-names
          (keep (lambda (name)
                  (not (memq name sorted-public-names)))
                gambit-public-names)))

    (if (or (not (null? extras-in-gambit-public-names))
            (not (null? missing-from-gambit-public-names)))
        (begin
          (display "************ file lib/gambit#.scm needs to be edited ************\n")
          (newline)
          (if (not (null? extras-in-gambit-public-names))
              (begin
                (display "==== these names should be REMOVED ====\n")
                (for-each pp extras-in-gambit-public-names)
                (newline)))
          (if (not (null? missing-from-gambit-public-names))
              (begin
                (display "==== these names should be ADDED ====\n")
                (for-each pp missing-from-gambit-public-names)))
          (exit 1))
        (exit))))

(main)

;;;============================================================================
