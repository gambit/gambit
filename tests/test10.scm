;;;============================================================================

;;; File: "test10.scm"

;;; Copyright (c) 2008-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Check that the names defined by the runtime library (specifically
;; the compiler's public procedures and special forms) and the library
;; exports are consistent.

(define (main)

  (define check-unit-test-coverage? #f) ;; disable this check for now

  (define root-from-here
    "..")

  (define rtlib-filename
    (car ##processed-command-line))

  (define doc-filename
    (path-expand "gambit.txi" "doc"))

  (define lib-hash-filenames
    (list (path-expand "gambit#.scm" "lib")
          (path-expand "r7rs#.scm" "lib")
          (path-expand "r5rs#.scm" "lib")
          (path-expand "r4rs#.scm" "lib")))

  (define lib-gambit-directory
    (path-expand "gambit" "lib"))

  (define lib-gambit-filename
    "gambit.sld")

  (define lib-prim-directory
    (path-expand "prim" (path-expand "gambit" "lib")))

  (define main-prim-filename
    "prim.sld")

  (define unit-tests-directory
    (path-expand "unit-tests" "tests"))

  (define prim-tests-dirname
    "13-modules")

  (define pretend-defined-by-rtlib '(
six.!
six.**x
six.asyncx
six.awaitx
six.break
six.case
six.clause
six.continue
six.from-import
six.from-import-*
six.goto
six.import
six.label
six.return
six.switch
six.typeofx
six.x:-y
six.xinstanceofy
six.yieldx
default-random-source
))

  (define (has-prefix? prefix str)
    (let ((len-prefix (string-length prefix))
          (len-str (string-length str)))
      (and (>= len-str len-prefix)
           (string=? (substring str 0 len-prefix) prefix))))

  (define (has-suffix? suffix str)
    (let ((len-suffix (string-length suffix))
          (len-str (string-length str)))
      (and (>= len-str len-suffix)
           (string=? (substring str (- len-str len-suffix) len-str) suffix))))

  (define (string-replace str pattern replacement)
    (let ((len (string-length str))
          (patlen (string-length pattern)))
      (let loop ((i (- len 1)) (j len) (parts '()))
        (if (< i 0)
            (apply string-append (cons (substring str 0 j) parts))
            (if (and (>= (- j i) patlen)
                     (string=? (substring str i (+ i patlen)) pattern))
                (loop (- i 1)
                      i
                      (cons replacement
                            (cons (substring str (+ i patlen) j)
                                  parts)))
                (loop (- i 1)
                      j
                      parts))))))

  (define (keep keep? lst)
    (cond ((null? lst)       '())
          ((keep? (car lst)) (cons (car lst) (keep keep? (cdr lst))))
          (else              (keep keep? (cdr lst)))))

  (define (list-sort lst <?)

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

  (define (extract-macros cte)
    (cond ((##cte-top? cte)
           '())
          ((##cte-macro? cte)
           (cons (##cte-macro-name cte)
                 (extract-macros (##cte-parent-cte cte))))
          (else
           (extract-macros (##cte-parent-cte cte)))))

  (define rtlib-macros
    (extract-macros (##cte-top-cte ##interaction-cte)))

  (define (get-rtlib-mapping filename)

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
            (and (>= (string-length str) 1)
                 (equal? (substring str 0 1) " ")))))

    (define (public-id? id)
      (not (hidden-id? id)))

    (define (public-procedure? s)
      (and (public-id? s)
           (let ((val (##global-var-ref (##make-global-var s))))
             (procedure? val))))

    (define (sort-symbols lst)
      (list-sort
       lst
       (lambda (x y) (string<? (symbol->string x) (symbol->string y)))))

    (let* ((public-procedures
            (keep public-procedure?
                  (symbol-table->list (##symbol-table))))
           (public-macros
            (keep public-id? rtlib-macros))
           (sorted-public-names
            (map (lambda (sym)
                   (list sym sym filename))
                 (sort-symbols
                  (append public-macros
                          public-procedures
                          pretend-defined-by-rtlib)))))
      sorted-public-names))

  (define (in-ns ns sym)
    (string->symbol (string-append ns (symbol->string sym))))

  (define (read-namespace-mapping filename handle-include?)

    (define (read-ns-mapping filename orig-filename)
      (let loop ((exprs (with-input-from-file filename read-all))
                 (mapping '()))
        (if (pair? exprs)
            (let ((expr (car exprs)))
              (cond ((and orig-filename
                          (pair? expr)
                          (memq (car expr) '(##include include)))
                     (loop (cdr exprs)
                           (append
                            mapping
                            (read-ns-mapping
                             (path-expand (cadr expr)
                                          (path-directory filename))
                             orig-filename))))
                    ((and (pair? expr)
                          (memq (car expr) '(##namespace namespace)))
                     (loop (cdr exprs)
                           (append
                            mapping
                            (apply
                             append
                             (map (lambda (clause)
                                    (let ((ns (car clause)))

                                      (define (add-ns p)
                                        (append
                                         (if (equal? ns "")
                                             p
                                             (list (car p)
                                                   (in-ns ns (cadr p))))
                                         (list filename
                                               (or orig-filename
                                                   filename))))

                                      (map (lambda (x)
                                             (add-ns
                                              (if (symbol? x)
                                                  (list x x)
                                                  x)))
                                           (cdr clause))))
                                  (cdr expr))))))
                    (else
                     (loop (cdr exprs)
                           mapping))))
            mapping)))

    (read-ns-mapping filename (and handle-include? filename)))

  (define (read-deflib-mapping filename)
    (let ((deflib (with-input-from-file filename read)))
      (if (and (pair? deflib)
               (eq? (car deflib) 'define-library))
          (let* ((ns (assq 'namespace (cddr deflib)))
                 (ex (assq 'export (cddr deflib))))
            (if ex
                (map (lambda (x)
                       (let ((y
                              (cond ((symbol? x)
                                     (list x x))
                                    ((and (list? x)
                                          (= 3 (length x))
                                          (eq? (car x) 'rename)
                                          (symbol? (cadr x))
                                          (symbol? (caddr x)))
                                     (list (caddr x) (cadr x)))
                                    (else
                                     (error "invalid export spec" x)))))
                         (list (car y)
                               (if ns
                                   (in-ns (cadr ns) (cadr y))
                                   (cadr y))
                               filename
                               filename)))
                     (cdr ex))
                '()))
          '())))

  (define (primitive? sym)
    (has-prefix? "##" (symbol->string sym)))

  (define (unimplemented? sym)
    (has-prefix? "##unimplemented#" (symbol->string sym)))

  (define (scm? filename)
    (has-suffix? ".scm" filename))

  (define (sld? filename)
    (has-suffix? ".sld" filename))

  (define inconsistent? #f)

  (define (found-inconsistency)
    (if inconsistent?
        (newline)
        (begin
          (display "************ some files are inconsistent and need to be edited\n\n")
          (set! inconsistent? #t))))

  (define (union-mappings mappings)
    (if (pair? mappings)
        (let loop1 ((mapping (reverse (car mappings)))
                    (mappings (cdr mappings)))
          (if (pair? mappings)
              (let loop2 ((lst (reverse (car mappings)))
                          (mapping mapping))
                (if (pair? lst)
                    (loop2 (cdr lst)
                           (let ((x (car lst)))
                             (if (assq (car x) mapping)
                                 mapping
                                 (cons x mapping))))
                    (loop1 mapping
                           (cdr mappings))))
              (reverse mapping)))
        '()))

  (define (verify-no-duplicates mappings allow-from-same-file?)
    (for-each
     (lambda (mapping1)
       (let ((f1 (and (pair? mapping1) (cadddr (car mapping1)))))
         (if f1
             (for-each
              (lambda (mapping2)
                (let ((f2 (and (pair? mapping2) (cadddr (car mapping2)))))
                  (if (and f2
                           (string<? f1 f2))
                      (for-each
                       (lambda (m1)
                         (let ((name1 (car m1))
                               (filename1 (caddr m1)))
                           (let ((m2 (assq name1 mapping2)))
                             (if m2
                                 (let ((filename2 (caddr m2)))
                                   (if (or (not allow-from-same-file?)
                                           (not (equal?
                                                 (path-normalize filename1)
                                                 (path-normalize filename2))))
                                       (let ()
                                         (define (refer f filename)
                                           (if (string=? f filename)
                                               f
                                               (string-append
                                                f
                                                " (specifically "
                                                filename
                                                ")")))
                                         (found-inconsistency)
                                         (display
                                          (string-append
                                           (object->string name1)
                                           " is defined in "
                                           (refer f1 filename1)
                                           " and "
                                           (refer f2 filename2)
                                           "\n")))))))))
                       mapping1))))
              mappings))))
     mappings))

  (define (verify-same-mapping mapping mapping-filename expected check-mapping?)
    (let* ((missing
            (keep (lambda (m)
                    (not (assq (car m) mapping)))
                  expected))
           (extras
            (keep (lambda (m)
                    (not (assq (car m) expected)))
                  mapping))
           (common
            (keep (lambda (m)
                    (assq (car m) expected))
                  mapping))
           (different
            (keep (lambda (m-e)
                    (not (eq? (cadr (car m-e)) (cadr (cadr m-e)))))
                  (map (lambda (c)
                         (list (assq (car c) mapping)
                               (assq (car c) expected)))
                       common))))

      (if (pair? missing)
          (begin
            (found-inconsistency)
            (display
             (string-append
              "These names should be ADDED to "
              mapping-filename
              ":\n"))
            (for-each
             (lambda (m)
               (pp (car m)))
             missing)))

      (if (pair? extras)
          (begin
            (found-inconsistency)
            (display
             (string-append
              "These names should be REMOVED from "
              mapping-filename
              ":\n"))
            (for-each
             (lambda (m)
               (pp (car m)))
             extras)))

      (if (and check-mapping? (pair? different))
          (begin
            (found-inconsistency)
            (for-each
             (lambda (d)
               (display
                (string-append
                 (object->string (car (car d)))
                 " has different mappings in "
                 (caddr (car d))
                 " ("
                 (object->string (cadr (car d)))
                 ") and "
                 (caddr (cadr d))
                 " ("
                 (object->string (cadr (cadr d)))
                 ")\n\n")))
             different)))))

  (define (get-unit-tests-directories dir)
    (keep (lambda (filename)
            (and (not (equal? filename prim-tests-dirname))
                 (equal? (path-extension filename) "")))
          (directory-files dir)))

  (define (get-unit-tests-filenames dir)
    (keep (lambda (filename)
            (and (not (equal? filename "#.scm"))
                 (equal? (path-extension filename) ".scm")))
          (directory-files dir)))

  (define (get-test-mapping filename)
    (let ((called (make-table)))

      (define (walk expr)
        (if (pair? expr)
            (let ((head (car expr)))
              (if (and (symbol? head) (list? expr))
                  (table-set! called head head))
              (if (list? expr)
                  (for-each walk expr)))))

      (for-each walk
                (call-with-input-file filename read-all))

      (map (lambda (x)
             (list (car x) (car x) filename filename))
           (table->list called))))

  (define (get-doc-mapping filename)
    (let ((lines
           (call-with-input-file
               (list path: filename char-encoding: 'ISO-8859-1)
             (lambda (port)
               (read-all port read-line))))
          (mapping
           '()))

      (define (add str)
        (let ((sym
               (with-input-from-string
                   (string-replace
                    str
                    "@@"
                    "@")
                 read)))
          (set! mapping
            (cons (list sym sym filename filename) mapping))))

      (define (split str sep)
        (call-with-input-string
            str
          (lambda (port)
            (read-all port (lambda (p) (read-line p sep))))))

      (for-each
       (lambda (line)
         (let ((parts (split line #\space)))
           (if (pair? parts)
               (cond ((member (car parts) '("@deffn" "@deffnx"))
                      (cond ((and (>= (length parts) 3)
                                  (member (cadr parts) '("procedure")))
                             (add (caddr parts)))
                            ((and (>= (length parts) 3)
                                  (member (cadr parts) '("undefined")))
                             (add (caddr parts)))
                            ((and (>= (length parts) 4)
                                  (member (cadr parts) '("{special"))
                                  (member (caddr parts) '("form}")))
                             (add (cadddr parts)))
                            (else
                             (found-inconsistency)
                             (display
                              (string-append
                               "unhandled "
                               (car parts)
                               " form in "
                               filename
                               ": "
                               line
                               "\n")))))
                     ((member (car parts) '("@defvr"))
                      (cond ((and (>= (length parts) 3)
                                  (member (cadr parts) '("variable")))
                             (add (caddr parts)))
                            (else
                             (found-inconsistency)
                             (display
                              (string-append
                               "unhandled "
                               (car parts)
                               " form in "
                               filename
                               ": "
                               line
                               "\n")))))))))
       lines)

      (reverse mapping)))

  (define (get-hash-mappings hash-filenames)
    (let ((mappings
           (map (lambda (filename) (read-namespace-mapping filename #t))
                hash-filenames)))

      ;; Check that lib/gambit#.scm, lib/r7rs#.scm, etc don't contain
      ;; duplicate definitions.

      (verify-no-duplicates mappings #t)

      (let ((main-mapping (car mappings))
            (all (union-mappings mappings)))

        ;; Check that lib/gambit#.scm contains the identical name
        ;; mappings as all of lib/r7rs#.scm, etc.

        (verify-same-mapping main-mapping (car hash-filenames) all #t)

        mappings)))

  (parameterize ((current-directory root-from-here))
    (let ((rtlib-mapping (get-rtlib-mapping rtlib-filename)))

      (let ((lib-hash-mappings (get-hash-mappings lib-hash-filenames)))

        ;; Check that lib/gambit#.scm and the runtime library contains
        ;; the same set of names, mapped the same way.

        (verify-same-mapping (car lib-hash-mappings)
                             (car lib-hash-filenames)
                             rtlib-mapping
                             #t)

        ;; Check that the Gambit manual documents all the procedures and
        ;; special forms defined by the Gambit runtime library.

        (let ((doc-mapping
               (keep (lambda (x)
                       (not (primitive? (car x))))
                     (get-doc-mapping doc-filename))))
          (verify-same-mapping (union-mappings
                                (list doc-mapping
                                      ;; The next line is to avoid
                                      ;; requiring the documentation to
                                      ;; document the procedures and forms
                                      ;; that are defined by R7RS (in the
                                      ;; future it would be good to
                                      ;; include them in the Gambit
                                      ;; manual for completeness).
                                      (cadr lib-hash-mappings)))
                               doc-filename
                               rtlib-mapping
                               #t)))

      (let* ((sld-path
              (path-expand lib-gambit-filename lib-gambit-directory))
             (hash-filename
              (string-append (path-strip-extension lib-gambit-filename)
                             "#.scm"))
             (hash-path
              (path-expand hash-filename lib-gambit-directory))
             (sld-mapping
              (read-deflib-mapping sld-path))
             (hash-mapping
              (read-namespace-mapping hash-path #t)))
        (verify-same-mapping sld-mapping
                             sld-path
                             rtlib-mapping
                             #t)
        (verify-same-mapping hash-mapping
                             hash-path
                             rtlib-mapping
                             #t))

      ;; Check that for each primitive library in lib/gambit/prim
      ;; the <library>.sld and <library>#.scm files are consistent.

      (let ((sld-lib-filenames
             (keep (lambda (filename)
                     (and (sld? filename)
                          (not (equal? filename main-prim-filename))))
                   (directory-files lib-prim-directory)))
            (sld-mappings
             '())
            (hash-mappings
             '())
            (hash-mappings-with-only-implemented
             '()))

        (for-each
         (lambda (sld-lib-filename)
           (let* ((sld-path
                   (path-expand sld-lib-filename lib-prim-directory))
                  (hash-filename
                   (string-append (path-strip-extension sld-lib-filename)
                                  "#.scm"))
                  (hash-path
                   (path-expand hash-filename lib-prim-directory))
                  (sld-mapping
                   (read-deflib-mapping sld-path))
                  (hash-mapping
                   (read-namespace-mapping hash-path #t))
                  (hash-mapping-with-only-implemented
                   (keep (lambda (x)
                           (not (unimplemented? (cadr x))))
                         hash-mapping)))
             (set! sld-mappings
               (cons sld-mapping
                     sld-mappings))
             (set! hash-mappings
               (cons hash-mapping
                     hash-mappings))
             (set! hash-mappings-with-only-implemented
               (cons hash-mapping-with-only-implemented
                     hash-mappings-with-only-implemented))
             ;; Check that <library>.sld and <library>#.scm define the
             ;; same names with the same mappings.
             (verify-same-mapping sld-mapping
                                  sld-path
                                  hash-mapping-with-only-implemented
                                  #t)
             ))
         sld-lib-filenames)

        (let ((sld-mappings
               (reverse sld-mappings))
              (hash-mappings
               (reverse hash-mappings))
              (hash-mappings-with-only-implemented
               (reverse hash-mappings-with-only-implemented)))
          ;; Check that none of the libraries define names defined in
          ;; other libraries.
          (verify-no-duplicates sld-mappings #t)
          (verify-no-duplicates hash-mappings #t)
          (verify-no-duplicates hash-mappings-with-only-implemented #t))

        (let* ((complete-sld-mapping
                (union-mappings sld-mappings))
               (complete-hash-mapping
                (union-mappings hash-mappings))
               (complete-hash-mapping-with-only-implemented
                (union-mappings hash-mappings-with-only-implemented))
               (sld-path
                (path-expand main-prim-filename lib-prim-directory))
               (hash-filename
                (string-append (path-strip-extension main-prim-filename)
                               "#.scm"))
               (hash-path
                (path-expand hash-filename lib-prim-directory))
               (sld-mapping
                (read-deflib-mapping sld-path))
               (hash-mapping
                (read-namespace-mapping hash-path #t))
               (hash-mapping-with-only-implemented
                (keep (lambda (x)
                        (not (unimplemented? (cadr x))))
                      hash-mapping)))
          (verify-same-mapping sld-mapping
                               sld-path
                               hash-mapping-with-only-implemented
                               #t)
          (verify-same-mapping sld-mapping
                               sld-path
                               complete-sld-mapping
                               #t)
          (verify-same-mapping hash-mapping
                               hash-path
                               complete-hash-mapping
                               #t)
          (verify-same-mapping hash-mapping-with-only-implemented
                               hash-path
                               complete-hash-mapping-with-only-implemented
                               #t)

          (let* ((prim-unit-tests-directory
                  (path-expand prim-tests-dirname unit-tests-directory))
                 (prim-unit-tests-filenames
                  (get-unit-tests-filenames prim-unit-tests-directory))
                 (all-tested
                  (union-mappings
                   (map
                    (lambda (filename)
                      (get-test-mapping
                       (path-expand filename prim-unit-tests-directory)))
                    prim-unit-tests-filenames)))
                 (not-tested
                  (keep
                   (lambda (x)
                     (let ((sym (car x)))
                       (and (not (memq sym rtlib-macros))
                            (not (assq sym all-tested)))))
                   hash-mapping-with-only-implemented)))
            (if (pair? not-tested)
                (begin
                  (found-inconsistency)
                  (display
                   (string-append
                    "These primitives have no unit test in "
                    prim-unit-tests-directory
                    ":\n"))
                  (for-each
                   (lambda (m)
                     (pp (car m)))
                   not-tested))))


          ))

      ;; Check that every procedure defined by the runtime library
      ;; has a unit test.

      (if check-unit-test-coverage?
          (let* ((unit-tests-directories
                  (get-unit-tests-directories unit-tests-directory))
                 (all-tested
                  (union-mappings
                   (map
                    (lambda (dir)
                      (let ((unit-tests-filenames
                             (get-unit-tests-filenames
                              (path-expand dir unit-tests-directory))))
                        (union-mappings
                         (map
                          (lambda (filename)
                            (get-test-mapping
                             (path-expand filename
                                          (path-expand dir
                                                       unit-tests-directory))))
                          unit-tests-filenames))))
                    unit-tests-directories)))
                 (not-tested
                  (keep
                   (lambda (x)
                     (let ((sym (car x)))
                       (and (not (memq sym rtlib-macros))
                            (not (assq sym all-tested)))))
                   rtlib-mapping)))
            (if (pair? not-tested)
                (begin
                  (found-inconsistency)
                  (display
                   (string-append
                    "These procedures have no unit test in "
                    unit-tests-directory
                    ":\n"))
                  (for-each
                   (lambda (m)
                     (pp (car m)))
                   not-tested)))))))

  (exit (if inconsistent? 1 0)))

(main)

;;;============================================================================
