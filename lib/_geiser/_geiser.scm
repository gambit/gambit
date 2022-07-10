;;;============================================================================

;;; File: "_geiser.scm"

;;; Copyright (c) 2019 by Mathieu Perron, All Rights Reserved.
;;; Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Geiser support.

(##supply-module _geiser)

(##namespace ("_geiser#"))                ;; in _geiser#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##namespace ("" load))                   ;; a non-primitive
(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,
                                          ;; macro-absent-obj, etc

;(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
;(declare (not safe))          ;; claim code has no type errors
;(declare (block))             ;; claim no global is assigned

(##include "_geiser#.scm")

;;;----------------------------------------------------------------------------

(define-macro (geiser:capture-output x . xs)
  (let ((out (gensym))
        (result (gensym)))
    `(let* ((,out (open-output-string))
            (,result (parameterize ((current-output-port ,out))
                       ,(cons 'begin (cons x xs)))))
       `((result ,(object->string ,result))
         (output . ,(get-output-string ,out))))))

(define (geiser:load-file filename)
  (geiser:capture-output (load filename)))

(define (geiser:eval module form . rest) ;; module is not yet supported in gambit
  (geiser:capture-output (eval form)))

(define (geiser:newline)
  (newline))

(define (geiser:no-values)
  (values))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Completions, Autodoc and Signature
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; search for a procedure in gambit-procedures
;; returns the procedure symbol if it finds it
(define (procedure-search elem)
  (or (assq elem gambit-procedures) '()))

(define (geiser:autodoc ids . rest)
  (cond ((null? ids) '())
        ((not (list? ids))
         (geiser:autodoc (list ids)))
        ((not (symbol? (car ids)))
         (geiser:autodoc (cdr ids)))
        (else
         (geiser:new-autodoc (car ids)))))
         ;;(list (##procedure-search (car ids))))))

;; (cadr (##decompile method)) format is
;;(#!optional (param1 (macro-absent-obj)) (param2 (macro-absent-obj)) #!rest others)
;;the autodoc verify if (##decompile method) gives a acceptable result and else use the scraped list gambit-procedures
(define (geiser:new-autodoc method-name)
  (define (get-required lst)
    (let loop ((lst lst)
               (result '()))
      (cond ((not (pair? lst))
             (cons (reverse result) '()))
            ((eq? (car lst) #!optional)
             (cons (reverse result) (cdr lst)))
            ((eq? (car lst) #!key)
             (cons (reverse result) lst))
            (else (loop (cdr lst) (cons (car lst) result))))))

  (define (get-optional lst)
    (let loop ((lst lst)
               (result '()))
      (cond ((or (not (pair? lst))
                 (eq? (car lst) #!key))
             (cons (reverse result)
                   (if (pair? lst)
                       (cdr lst)
                       '())))
            ((eq? (car lst) #!rest)
             (cons (reverse (cons '... result)) '()))
            (else
             (loop (cdr lst) (cons (if (pair? (car lst)) (caar lst) (car lst)) result))))))

  (define (get-key lst)
    (let loop ((lst lst)
               (result '()))
      (cond ((not (pair? lst))
             result)
            ((eq? (car lst) #!rest)
             (reverse (cons '... result)))
            (else (loop (cdr lst) (cons (car lst) result))))))


  (let ((proc (##global-var-ref (##make-global-var method-name))))
    (if (procedure? proc)
        (let ((method-tester (##decompile proc)))
          (if (pair? method-tester)
              (let* ((method (cadr method-tester))
                     (required (get-required method))
                     (optional (get-optional (cdr required)))
                     (key (get-key (cdr optional))))
                (list `(,method-name
                        ("args" (("required" ,@(car required))
                                 ("optional" ,@(car optional))
                                 ("key"      ,@key)))
                        ("module"))))
              (list (procedure-search method-name))))
        (list (procedure-search method-name)))))

(define (geiser:module-completions prefix . rest)

  (define (interesting? sym)
    (and (string-prefix? prefix (symbol->string sym))
         (procedure? (##global-var-ref (##make-global-var sym)))))

  (define (environment-symbols)
    (let ((symtab (##symbol-table)))
      (let loop1 ((i (- (vector-length symtab) 1))
                  (result '()))
        (if (> i 0)
            (let loop2 ((sym (vector-ref symtab i))
                        (result result))
              (if (symbol? sym)
                  (loop2 (##vector-ref sym 2)
                         (if (interesting? sym)
                             (cons (symbol->string sym) result)
                             result))
                  (loop1 (- i 1)
                         result)))
            result))))

  (sort-list (environment-symbols) string-ci<?))

(define (geiser:completions prefix . rest)
  rest)

;; string-prefix function
(define (string-prefix? pref str)
  (let* ((str (if (string? str) str (symbol->string str)))
         (str-len (string-length str))
         (pref (if (string? pref) pref (symbol->string pref)))
         (pref-len (string-length pref)))
    (and (string? pref)
         (string? str)
         (<= pref-len str-len)
         (string=? (substring str 0 pref-len) pref))))

;; filter
(define (filter f lst)
  (fold-right (lambda (e r) (if (f e) (cons e r) r)) '() lst))

;; sorting algorithms
(define (sort-list l <?)

   (define (mergesort l)

     (define (merge l1 l2)
       (cond ((null? l1) l2)
             ((null? l2) l1)
             (else
              (let ((e1 (car l1)) (e2 (car l2)))
                (if (<? e1 e2)
                  (cons e1 (merge (cdr l1) l2))
                  (cons e2 (merge l1 (cdr l2))))))))

     (define (split l)
       (if (or (null? l) (null? (cdr l)))
         l
         (cons (car l) (split (cddr l)))))

     (if (or (null? l) (null? (cdr l)))
       l
       (let* ((l1 (mergesort (split l)))
              (l2 (mergesort (split (cdr l)))))
         (merge l1 l2))))

   (mergesort l))

;; the majority of gambit and r5rs procedures correctly formatted
(define gambit-procedures
  '((* ("args" (("required") ("optional" [z1  ...]) ("key")))("module"))
    (+ ("args" (("required" z1  [...]) ("optional") ("key")))("module"))
    (- ("args" (("required" z1 z2) ("optional") ("key")))("module"))
    (- ("args" (("required") ("optional" [z ...]) ("key")))("module"))
    (/ ("args" (("required") ("optional" [z  ...]) ("key")))("module"))
    (< ("args" (("required") ("optional" [x1  ...]) ("key")))("module"))
    (<= ("args" (("required") ("optional" [x1  ...]) ("key")))("module"))
    (= ("args" (("required" z1 z2 z3  [...]) ("optional") ("key")))("module"))
    (= ("args" (("required" z1 [...]) ("optional") ("key")))("module"))
    (> ("args" (("required") ("optional" [x1  ...]) ("key")))("module"))
    (>= ("args" (("required") ("optional" [x1  ...]) ("key")))("module"))
    (abandoned-mutex-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (abort ("args" (("required" obj) ("optional") ("key")))("module"))
    (abs ("args" (("required" x) ("optional") ("key")))("module"))
    (acos ("args" (("required" z) ("optional") ("key")))("module"))
    (address-info-family
     ("args" (("required" address-info) ("optional") ("key")))("module"))
    (address-info-protocol
     ("args" (("required" address-info) ("optional") ("key")))("module"))
    (address-info-socket-info
     ("args" (("required" address-info) ("optional") ("key")))("module"))
    (address-info-socket-type
     ("args" (("required" address-info) ("optional") ("key")))("module"))
    (address-info? ("args" (("required" obj) ("optional") ("key")))("module"))
    (address-infos
     ("args"
      (("required")
       ("optional")
       ("key"
        [host: host] [service: service] [family: family] [socket-type: socket-type] [protocol: protocol]))))
    (all-bits-set? ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (and ("args" (("required" test1  [...]) ("optional") ("key")))("module"))
    (angle ("args" (("required" z) ("optional") ("key")))("module"))
    (any-bits-set? ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (append ("args" (("required" list  [...]) ("optional") ("key")))("module"))
    (string-concatenate ("args" (("required" lst) ("optional" separator) ("key")))("module"))
    (vector-concatenate ("args" (("required" lst) ("optional" separator) ("key")))("module"))
    (apply ("args"
            (("required" proc [arg1  ...] args) ("optional") ("key")))("module"))
    (arithmetic-shift ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (asin ("args" (("required" z) ("optional") ("key")))("module"))
    (assoc ("args" (("required" obj alist) ("optional") ("key")))("module"))
    (assq ("args" (("required" obj alist) ("optional") ("key")))("module"))
    (assv ("args" (("required" obj alist) ("optional") ("key")))("module"))
    (atan ("args" (("required" z) ("optional") ("key")))("module"))
    (atan ("args" (("required" y x) ("optional") ("key")))("module"))
    (begin
      ("args"
       (("required" expression1 expression2  [...]) ("optional") ("key")))("module"))
    (bit-count ("args" (("required" n) ("optional") ("key")))("module"))
    (bit-set? ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (bitwise-and ("args" (("required" n [...]) ("optional") ("key")))("module"))
    (bitwise-ior ("args" (("required" n [...]) ("optional") ("key")))("module"))
    (bitwise-merge ("args" (("required" n1 n2 n3) ("optional") ("key")))("module"))
    (bitwise-not ("args" (("required" n) ("optional") ("key")))("module"))
    (bitwise-xor ("args" (("required" n [...]) ("optional") ("key")))("module"))
    (boolean? ("args" (("required" obj) ("optional") ("key")))("module"))
    (box ("args" (("required" obj) ("optional") ("key")))("module"))
    (break ("args" (("required" proc [...]) ("optional") ("key")))("module"))
    (caar ("args" (("required" pair) ("optional") ("key")))("module"))
    (cadr ("args" (("required" pair) ("optional") ("key")))("module"))
    (call-with-current-continuation
     ("args" (("required" proc) ("optional") ("key")))("module"))
    (call-with-current-continuation
     ("args" (("required" proc) ("optional") ("key")))("module"))
    (call-with-input-file
        ("args" (("required" string proc) ("optional") ("key")))("module"))
    (call-with-output-file
        ("args" (("required" string proc) ("optional") ("key")))("module"))
    (call-with-values
        ("args" (("required" producer consumer) ("optional") ("key")))("module"))
    (car ("args" (("required" pair) ("optional") ("key")))("module"))
    (case ("args"
           (("required" key clause1 clause2  [...])
            ("optional")
            ("key")))("module"))
    (cdddar ("args" (("required" pair) ("optional") ("key")))("module"))
    (cddddr ("args" (("required" pair) ("optional") ("key")))("module"))
    (cdr ("args" (("required" pair) ("optional") ("key")))("module"))
    (ceiling ("args" (("required" x) ("optional") ("key")))("module"))
    (cfun-conversion-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (char->integer ("args" (("required" char) ("optional") ("key")))("module"))
    (char->integer ("args" (("required" char) ("optional") ("key")))("module"))
    (char-alphabetic? ("args" (("required" char) ("optional") ("key")))("module"))
    (char-ci<=? ("args" (("required") ("optional" [char]) ("key")))("module"))
    (char-ci<? ("args" (("required") ("optional" [char]) ("key")))("module"))
    (char-ci=? ("args" (("required") ("optional" [char]) ("key")))("module"))
    (char-ci>=? ("args" (("required") ("optional" [char]) ("key")))("module"))
    (char-ci>? ("args" (("required") ("optional" [char]) ("key")))("module"))
    (char-downcase ("args" (("required" char) ("optional") ("key")))("module"))
    (char-lower-case? ("args" (("required" letter) ("optional") ("key")))("module"))
    (char-numeric? ("args" (("required" char) ("optional") ("key")))("module"))
    (char-ready? ("args" (("required" port) ("optional") ("key")))("module"))
    (char-ready? ("args" (("required") ("optional") ("key")))("module"))
    (char-upcase ("args" (("required" char) ("optional") ("key")))("module"))
    (char-upper-case? ("args" (("required" letter) ("optional") ("key")))("module"))
    (char-whitespace? ("args" (("required" char) ("optional") ("key")))("module"))
    (char<=? ("args" (("required") ("optional" [char]) ("key")))("module"))
    (char<? ("args" (("required") ("optional" [char]) ("key")))("module"))
    (char=? ("args" (("required" char1 [...]) ("optional") ("key")))("module"))
    (char=? ("args" (("required") ("optional" [char]) ("key")))("module"))
    (char>=? ("args" (("required") ("optional" [char]) ("key")))("module"))
    (char>? ("args" (("required") ("optional" [char]) ("key")))("module"))
    (char? ("args" (("required" obj) ("optional") ("key")))("module"))
    (circular-list ("args" (("required" x y [...]) ("optional") ("key")))("module"))
    (close-input-port ("args" (("required" port) ("optional") ("key")))("module"))
    (close-input-port ("args" (("required" port) ("optional") ("key")))("module"))
    (close-output-port ("args" (("required" port) ("optional") ("key")))("module"))
    (command-line ("args" (("required") ("optional") ("key")))("module"))
    (compile-file
     ("args"
      (("required"
        file [options: options] [output: output] [expression: expression] [cc-options: cc-options] [ld-options-prelude: ld-options-prelude] [ld-options: ld-options])
       ("optional")
       ("key")))("module"))
    (compile-file-to-target
     ("args"
      (("required"
        file [options: options] [output: output] [expression: expression])
       ("optional")
       ("key")))("module"))
    (complex? ("args" (("required" obj) ("optional") ("key")))("module"))
    (cond ("args"
           (("required" clause1 clause2  [...]) ("optional") ("key")))("module"))
    (condition-variable-broadcast!
     ("args" (("required" condition-variable) ("optional") ("key")))("module"))
    (condition-variable-name
     ("args" (("required" condition-variable) ("optional") ("key")))("module"))
    (condition-variable-signal!
     ("args" (("required" condition-variable) ("optional") ("key")))("module"))
    (condition-variable-specific
     ("args" (("required" condition-variable) ("optional") ("key")))("module"))
    (condition-variable? ("args" (("required" obj) ("optional") ("key")))("module"))
    (cons ("args" (("required" obj1 obj2) ("optional") ("key")))("module"))
    (cons* ("args" (("required" x y [...]) ("optional") ("key")))("module"))
    (continuation? ("args" (("required" obj) ("optional") ("key")))("module"))
    (copy-file
     ("args"
      (("required" source-path destination-path) ("optional") ("key")))("module"))
    (cos ("args" (("required" z) ("optional") ("key")))("module"))
    (create-directory
     ("args" (("required" path-or-settings) ("optional") ("key")))("module"))
    (create-fifo
     ("args" (("required" path-or-settings) ("optional") ("key")))("module"))
    (create-link
     ("args"
      (("required" source-path destination-path) ("optional") ("key")))("module"))
    (create-symbolic-link
     ("args"
      (("required" source-path destination-path) ("optional") ("key")))("module"))
    (current-directory
     ("args" (("required") ("optional" [new-current-directory]) ("key")))("module"))
    (current-exception-handler
     ("args" (("required") ("optional" [new-exception-handler]) ("key")))("module"))
    (current-input-port
     ("args" (("required" a b c) ("optional" new-value) ("key")))("module"))

    (current-jiffy ("args" (("required") ("optional") ("key")))("module"))
    (current-output-port ("args" (("required") ("optional") ("key")))("module"))
    (current-second ("args" (("required") ("optional") ("key")))("module"))
    (current-thread ("args" (("required") ("optional") ("key")))("module"))
    (current-time ("args" (("required") ("optional") ("key")))("module"))
    (current-user-interrupt-handler
     ("args" (("required") ("optional" [handler]) ("key")))("module"))
    (datum-parsing-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (deadlock-exception? ("args" (("required" obj) ("optional") ("key")))("module"))
    (define ("args" (("required") ("optional" ...) ("key")))("module"))
    (delay ("args" (("required" expression) ("optional") ("key")))("module"))
    (delete-directory ("args" (("required" path) ("optional") ("key")))("module"))
    (delete-file ("args" (("required" path) ("optional") ("key")))("module"))
    (delete-file-or-directory
     ("args" (("required" path [recursive?]) ("optional") ("key")))("module"))
    (denominator ("args" (("required" q) ("optional") ("key")))("module"))
    (directory-files
     ("args" (("required") ("optional" [path-or-settings]) ("key")))("module"))
    (display ("args" (("required" obj port) ("optional") ("key")))("module"))
    (display ("args" (("required" obj) ("optional") ("key")))("module"))
    (display-continuation-backtrace
     ("args"
      (("required"
        cont [port [all-frames? [display-env? [max-head [max-tail [depth]]]]]])
       ("optional")
       ("key")))("module"))
    (display-dynamic-environment?
     ("args" (("required" display?) ("optional") ("key")))("module"))
    (display-environment-set!
     ("args" (("required" display?) ("optional") ("key")))("module"))
    (display-exception
     ("args" (("required" exc [port]) ("optional") ("key")))("module"))
    (divide-by-zero-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (do ("args"
         (("required"
           ((variable1 init1 step1)  [...]) (test expression  [...]) command  [...])
          ("optional")
          ("key")))("module"))
    (dynamic-wind
      ("args" (("required" before thunk after) ("optional") ("key")))("module"))
    (eof-object? ("args" (("required" obj) ("optional") ("key")))("module"))
    (eq? ("args" (("required" obj1 obj2) ("optional") ("key")))("module"))
    (eq?-hash ("args" (("required" obj) ("optional") ("key")))("module"))
    (equal? ("args" (("required" obj1 obj2) ("optional") ("key")))("module"))
    (equal?-hash ("args" (("required" obj) ("optional") ("key")))("module"))
    (eqv? ("args" (("required" obj1 obj2) ("optional") ("key")))("module"))
    (eqv?-hash ("args" (("required" obj) ("optional") ("key")))("module"))
    (err-code->string ("args" (("required" code) ("optional") ("key")))("module"))
    (error-exception? ("args" (("required" obj) ("optional") ("key")))("module"))
    (eval ("args"
           (("required" expression environment-specifier)
            ("optional")
            ("key")))("module"))
    (eval ("args" (("required" expr [env]) ("optional") ("key")))("module"))
    (even? ("args" (("required" n) ("optional") ("key")))("module"))
    (exact->inexact ("args" (("required" z) ("optional") ("key")))("module"))
    (exact? ("args" (("required" z) ("optional") ("key")))("module"))
    (executable-path ("args" (("required") ("optional") ("key")))("module"))
    (exit ("args" (("required") ("optional" [status]) ("key")))("module"))
    (exp ("args" (("required" z) ("optional") ("key")))("module"))
    (expression-parsing-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (expt ("args" (("required" z1 z2) ("optional") ("key")))("module"))
    (extract-bit-field
     ("args" (("required" n1 n2 n3) ("optional") ("key")))("module"))
    (f32vector? ("args" (("required" obj) ("optional") ("key")))("module"))
    (f64vector? ("args" (("required" obj) ("optional") ("key")))("module"))
    (file-exists-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (file-exists-exception-procedure
     ("args" (("required" exc) ("optional") ("key")))("module"))
    (file-exists-exception-arguments
     ("args" (("required" exc) ("optional") ("key")))("module"))
    (file-exists?
     ("args" (("required" path [chase?]) ("optional") ("key")))("module"))
    (file-info ("args" (("required" path [chase?]) ("optional") ("key")))("module"))
    (file-info-attributes
     ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info-creation-time
     ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info-device ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info-group ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info-inode ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info-last-access-time
     ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info-last-change-time
     ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info-last-modification-time
     ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info-mode ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info-number-of-links
     ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info-owner ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info-size ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info-type ("args" (("required" file-info) ("optional") ("key")))("module"))
    (file-info? ("args" (("required" obj) ("optional") ("key")))("module"))
    (file-last-access-and-modification-times-set!
     ("args" (("required" path [atime [mtime]]) ("optional") ("key")))("module"))
    (file-type ("args" (("required" path) ("optional") ("key")))("module"))
    (finite? ("args" (("required" x) ("optional") ("key")))("module"))
    (first-set-bit ("args" (("required" n) ("optional") ("key")))("module"))
    (fixnum->flonum ("args" (("required" n) ("optional") ("key")))("module"))
    (fixnum-overflow-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (fixnum? ("args" (("required" obj) ("optional") ("key")))("module"))
    (fl* ("args" (("required" x1 [...]) ("optional") ("key")))("module"))
    (fl+ ("args" (("required" x1 [...]) ("optional") ("key")))("module"))
    (fl- ("args" (("required" x1 x2 [...]) ("optional") ("key")))("module"))
    (fl/ ("args" (("required" x1 x2) ("optional") ("key")))("module"))
    (fl< ("args" (("required" x1 [...]) ("optional") ("key")))("module"))
    (fl<= ("args" (("required" x1 [...]) ("optional") ("key")))("module"))
    (fl= ("args" (("required" x1 [...]) ("optional") ("key")))("module"))
    (fl> ("args" (("required" x1 [...]) ("optional") ("key")))("module"))
    (fl>= ("args" (("required" x1 [...]) ("optional") ("key")))("module"))
    (flabs ("args" (("required" x) ("optional") ("key")))("module"))
    (flacos ("args" (("required" x) ("optional") ("key")))("module"))
    (flasin ("args" (("required" x) ("optional") ("key")))("module"))
    (flatan ("args" (("required" x) ("optional") ("key")))("module"))
    (flceiling ("args" (("required" x) ("optional") ("key")))("module"))
    (flcos ("args" (("required" x) ("optional") ("key")))("module"))
    (fldenominator ("args" (("required" x) ("optional") ("key")))("module"))
    (fleven? ("args" (("required" x) ("optional") ("key")))("module"))
    (flexp ("args" (("required" x) ("optional") ("key")))("module"))
    (flexpt ("args" (("required" x y) ("optional") ("key")))("module"))
    (flfinite? ("args" (("required" x) ("optional") ("key")))("module"))
    (flfloor ("args" (("required" x) ("optional") ("key")))("module"))
    (flhypot ("args" (("required" x y) ("optional") ("key")))("module"))
    (flinfinite? ("args" (("required" x) ("optional") ("key")))("module"))
    (flinteger? ("args" (("required" x) ("optional") ("key")))("module"))
    (fllog ("args" (("required" x) ("optional") ("key")))("module"))
    (flmax ("args" (("required" x1 x2 [...]) ("optional") ("key")))("module"))
    (flmin ("args" (("required" x1 x2 [...]) ("optional") ("key")))("module"))
    (flnan? ("args" (("required" x) ("optional") ("key")))("module"))
    (flnegative? ("args" (("required" x) ("optional") ("key")))("module"))
    (flnumerator ("args" (("required" x) ("optional") ("key")))("module"))
    (flodd? ("args" (("required" x) ("optional") ("key")))("module"))
    (flonum? ("args" (("required" obj) ("optional") ("key")))("module"))
    (floor ("args" (("required" x) ("optional") ("key")))("module"))
    (flpositive? ("args" (("required" x) ("optional") ("key")))("module"))
    (flround ("args" (("required" x) ("optional") ("key")))("module"))
    (flsin ("args" (("required" x) ("optional") ("key")))("module"))
    (flsqrt ("args" (("required" x) ("optional") ("key")))("module"))
    (fltan ("args" (("required" x) ("optional") ("key")))("module"))
    (fltruncate ("args" (("required" x) ("optional") ("key")))("module"))
    (flzero? ("args" (("required" x) ("optional") ("key")))("module"))
    (fold ("args"
           (("required" proc base list  [...]) ("optional") ("key")))("module"))
    (for-each
     ("args" (("required" proc [list1 list2  ...]) ("optional") ("key")))("module"))
    (force ("args" (("required" promise) ("optional") ("key")))("module"))
    (force-output
     ("args" (("required") ("optional" [port [level]]) ("key")))("module"))
    (foreign? ("args" (("required" obj) ("optional") ("key")))("module"))
    (fx* ("args" (("required" n1 [...]) ("optional") ("key")))("module"))
    (fx+ ("args" (("required" n1 [...]) ("optional") ("key")))("module"))
    (fx- ("args" (("required" n1 n2 [...]) ("optional") ("key")))("module"))
    (fx< ("args" (("required" n1 [...]) ("optional") ("key")))("module"))
    (fx<= ("args" (("required" n1 [...]) ("optional") ("key")))("module"))
    (fx= ("args" (("required" n1 [...]) ("optional") ("key")))("module"))
    (fx> ("args" (("required" n1 [...]) ("optional") ("key")))("module"))
    (fx>= ("args" (("required" n1 [...]) ("optional") ("key")))("module"))
    (fxabs ("args" (("required" n) ("optional") ("key")))("module"))
    (fxand ("args" (("required" n1 [...]) ("optional") ("key")))("module"))
    (fxarithmetic-shift ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (fxarithmetic-shift-left
     ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (fxarithmetic-shift-right
     ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (fxbit-count ("args" (("required" n) ("optional") ("key")))("module"))
    (fxbit-set? ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (fxeven? ("args" (("required" n) ("optional") ("key")))("module"))
    (fxfirst-set-bit ("args" (("required" n) ("optional") ("key")))("module"))
    (fxif ("args" (("required" n1 n2 n3) ("optional") ("key")))("module"))
    (fxior ("args" (("required" n1 [...]) ("optional") ("key")))("module"))
    (fxlength ("args" (("required" n) ("optional") ("key")))("module"))
    (fxmax ("args" (("required" n1 n2 [...]) ("optional") ("key")))("module"))
    (fxmin ("args" (("required" n1 n2 [...]) ("optional") ("key")))("module"))
    (fxmodulo ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (fxnegative? ("args" (("required" n) ("optional") ("key")))("module"))
    (fxnot ("args" (("required" n) ("optional") ("key")))("module"))
    (fxodd? ("args" (("required" n) ("optional") ("key")))("module"))
    (fxpositive? ("args" (("required" n) ("optional") ("key")))("module"))
    (fxquotient ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (fxremainder ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (fxwrap* ("args" (("required" n1 [...]) ("optional") ("key")))("module"))
    (fxwrap+ ("args" (("required" n1 [...]) ("optional") ("key")))("module"))
    (fxwrap- ("args" (("required" n1 n2 [...]) ("optional") ("key")))("module"))
    (fxwrapabs ("args" (("required" n) ("optional") ("key")))("module"))
    (fxwraparithmetic-shift
     ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (fxwraparithmetic-shift-left
     ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (fxwraplogical-shift-right
     ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (fxwrapquotient ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (fxxor ("args" (("required" n1 [...]) ("optional") ("key")))("module"))
    (fxzero? ("args" (("required" n) ("optional") ("key")))("module"))
    (gc-report-set! ("args" (("required" report?) ("optional") ("key")))("module"))
    (gcd ("args" (("required" n1  [...]) ("optional") ("key")))("module"))
    (generate-proper-tail-calls
     ("args" (("required") ("optional" [new-value]) ("key")))("module"))
    (gensym ("args" (("required") ("optional" [prefix]) ("key")))("module"))
    (get-environment-variable
     ("args" (("required" name) ("optional") ("key")))("module"))
    (get-environment-variables ("args" (("required") ("optional") ("key")))("module"))
    (get-output-vector
     ("args" (("required" vector-port) ("optional") ("key")))("module"))
    (getenv ("args" (("required" name [default]) ("optional") ("key")))("module"))
    (group-info ("args" (("required" group-name-or-id) ("optional") ("key")))("module"))
    (group-info-gid ("args" (("required" group-info) ("optional") ("key")))("module"))
    (group-info-members
     ("args" (("required" group-info) ("optional") ("key")))("module"))
    (group-info-name ("args" (("required" group-info) ("optional") ("key")))("module"))
    (group-info? ("args" (("required" obj) ("optional") ("key")))("module"))
    (heap-overflow-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (help ("args" (("required" subject) ("optional") ("key")))("module"))
    (host-info ("args" (("required" host-name) ("optional") ("key")))("module"))
    (host-info-addresses
     ("args" (("required" host-info) ("optional") ("key")))("module"))
    (host-info-aliases ("args" (("required" host-info) ("optional") ("key")))("module"))
    (host-info-name ("args" (("required" host-info) ("optional") ("key")))("module"))
    (host-info? ("args" (("required" obj) ("optional") ("key")))("module"))
    (host-name ("args" (("required") ("optional") ("key")))("module"))
    (identity ("args" (("required" obj) ("optional") ("key")))("module"))
    (if ("args"
         (("required" test consequent alternate) ("optional") ("key")))("module"))
    (if ("args" (("required" test consequent) ("optional") ("key")))("module"))
    (imag-part ("args" (("required" z) ("optional") ("key")))("module"))
    (inactive-thread-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (inexact->exact ("args" (("required" z) ("optional") ("key")))("module"))
    (inexact? ("args" (("required" z) ("optional") ("key")))("module"))
    (initialized-thread-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (input-port-byte-position
     ("args"
      (("required" port [position [whence]]) ("optional") ("key")))("module"))
    (input-port-bytes-buffered
     ("args" (("required" port) ("optional") ("key")))("module"))
    (input-port-char-position
     ("args" (("required" port) ("optional") ("key")))("module"))
    (input-port-characters-buffered
     ("args" (("required" port) ("optional") ("key")))("module"))
    (input-port-line ("args" (("required" port) ("optional") ("key")))("module"))
    (input-port-readtable ("args" (("required" port) ("optional") ("key")))("module"))
    (input-port-readtable-set!
     ("args" (("required" port readtable) ("optional") ("key")))("module"))
    (input-port-timeout-set!
     ("args" (("required" port timeout [thunk]) ("optional") ("key")))("module"))
    (input-port? ("args" (("required" obj) ("optional") ("key")))("module"))
    (input-port? ("args" (("required" obj) ("optional") ("key")))("module"))
    (integer->char ("args" (("required" n) ("optional") ("key")))("module"))
    (integer-length ("args" (("required" n) ("optional") ("key")))("module"))
    (integer-nth-root ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (integer-sqrt ("args" (("required" n) ("optional") ("key")))("module"))
    (integer? ("args" (("required" obj) ("optional") ("key")))("module"))
    (interaction-environment ("args" (("required") ("optional") ("key")))("module"))
    (invalid-hash-number-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (iota ("args"
           (("required" count [start [step]]) ("optional") ("key")))("module"))
    (jiffies-per-second ("args" (("required") ("optional") ("key")))("module"))
    (join-timeout-exception? ("args" (("required" obj) ("optional") ("key")))("module"))
    (keyword-expected-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (keyword-hash ("args" (("required" keyword) ("optional") ("key")))("module"))
    (keyword? ("args" (("required" obj) ("optional") ("key")))("module"))
    (lambda ("args" (("required" formals body) ("optional") ("key")))("module"))
    (last ("args" (("required" pair) ("optional") ("key")))("module"))
    (lcm ("args" (("required") ("optional" [n1  ...]) ("key")))("module"))
    (length ("args" (("required" list) ("optional") ("key")))("module"))
    (let ("args"
          (("required" variable bindings body) ("optional") ("key")))("module"))
    (let ("args" (("required" bindings body) ("optional") ("key")))("module"))
    (let* ("args" (("required" bindings body) ("optional") ("key")))("module"))
    (let-syntax ("args" (("required" bindings body) ("optional") ("key")))("module"))
    (letrec ("args" (("required" bindings body) ("optional") ("key")))("module"))
    (letrec-syntax
        ("args" (("required" bindings body) ("optional") ("key")))("module"))
    (link-flat
     ("args"
      (("required"
        module-list [output: output] [linker-name: linker-name] [warnings?: warnings?])
       ("optional")
       ("key")))("module"))
    (link-incremental
     ("args"
      (("required"
        module-list [output: output] [linker-name: linker-name] [base: base] [warnings?: warnings?])
       ("optional")
       ("key")))("module"))
    (list ("args" (("required" obj  [...]) ("optional") ("key")))("module"))
    (list->string ("args" (("required" list) ("optional") ("key")))("module"))
    (list->table
     ("args"
      (("required"
        list [size: size] [init: init] [weak-keys: weak-keys] [weak-values: weak-values] [test: test] [hash: hash] [min-load: min-load] [max-load: max-load])
       ("optional")
       ("key")))("module"))
    (list->vector ("args" (("required" list) ("optional") ("key")))("module"))
    (list-copy ("args" (("required" list) ("optional") ("key")))("module"))
    (list-ref ("args" (("required" list k) ("optional") ("key")))("module"))
    (list-set ("args" (("required" list k val) ("optional") ("key")))("module"))
    (list-tabulate ("args" (("required" n init-proc) ("optional") ("key")))("module"))
    (list-tail ("args" (("required" list k) ("optional") ("key")))("module"))
    (list? ("args" (("required" obj) ("optional") ("key")))("module"))
    (load ("args" (("required" filename) ("optional") ("key")))("module"))
    (log ("args" (("required" z) ("optional") ("key")))("module"))
    (magnitude ("args" (("required" z) ("optional") ("key")))("module"))
    (mailbox-receive-timeout-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (main ("args" (("required") ("optional" [...]) ("key")))("module"))
    (make-condition-variable
     ("args" (("required") ("optional" [name]) ("key")))("module"))
    (make-list ("args" (("required" n [fill]) ("optional") ("key")))("module"))
    (make-mutex ("args" (("required") ("optional" [name]) ("key")))("module"))
    (make-parameter
     ("args" (("required" obj [filter]) ("optional") ("key")))("module"))
    (make-polar ("args" (("required" x3 x4) ("optional") ("key")))("module"))
    (make-random-source ("args" (("required") ("optional") ("key")))("module"))
    (make-rectangular ("args" (("required" x1 x2) ("optional") ("key")))("module"))
    (make-string ("args" (("required" k) ("optional") ("key")))("module"))
    (make-string ("args" (("required" k char) ("optional") ("key")))("module"))
    (make-table
     ("args"
      (("required")
       ("optional")
       ("key"
        [size: size] [init: init] [weak-keys: weak-keys] [weak-values: weak-values] [test: test] [hash: hash] [min-load: min-load] [max-load: max-load]))))
    (make-thread
     ("args"
      (("required" thunk [name [thread-group]]) ("optional") ("key")))("module"))
    (make-thread-group
     ("args" (("required") ("optional" [name [thread-group]]) ("key")))("module"))
    (make-tls-context ("args" (("required") ("optional" [options]) ("key")))("module"))
    (make-vector ("args" (("required" k fill) ("optional") ("key")))("module"))
    (make-vector ("args" (("required" k fill) ("optional") ("key")))("module"))
    (make-vector ("args" (("required" k) ("optional") ("key")))("module"))
    (make-vector ("args" (("required" k) ("optional") ("key")))("module"))
    (make-will ("args" (("required" testator action) ("optional") ("key")))("module"))
    (map ("args" (("required" proc [list1 list2  ...]) ("optional") ("key")))("module"))
    (max ("args" (("required" x1 [...]) ("optional") ("key")))("module"))
    (member ("args" (("required" obj alist) ("optional") ("key")))("module"))
    (memq ("args" (("required" obj alist) ("optional") ("key")))("module"))
    (memv ("args" (("required" obj alist) ("optional") ("key")))("module"))
    (min ("args" (("required") ("optional" [x1  ...]) ("key")))("module"))
    (modulo ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (multiple-c-return-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (mutex-lock!
     ("args"
      (("required" mutex [timeout [thread]]) ("optional") ("key")))("module"))
    (mutex-name ("args" (("required" mutex) ("optional") ("key")))("module"))
    (mutex-specific ("args" (("required" mutex) ("optional") ("key")))("module"))
    (mutex-state ("args" (("required" mutex) ("optional") ("key")))("module"))
    (mutex-unlock!
     ("args"
      (("required" mutex [condition-variable [timeout]])
       ("optional")
       ("key")))("module"))
    (mutex? ("args" (("required" obj) ("optional") ("key")))("module"))
    (negative? ("args" (("required" x) ("optional") ("key")))("module"))
    (network-info
     ("args" (("required" network-name-or-id) ("optional") ("key")))("module"))
    (network-info-aliases
     ("args" (("required" network-info) ("optional") ("key")))("module"))
    (network-info-name
     ("args" (("required" network-info) ("optional") ("key")))("module"))
    (network-info-number
     ("args" (("required" network-info) ("optional") ("key")))("module"))
    (network-info? ("args" (("required" obj) ("optional") ("key")))("module"))
    (newline ("args" (("required") ("optional") ("key")))("module"))
    (newline ("args" (("required") ("optional" [port]) ("key")))("module"))
    (newline ("args" (("required" port) ("optional") ("key")))("module"))
    (no-such-file-or-directory-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (no-such-file-or-directory-exception-procedure
     ("args" (("required" exc) ("optional") ("key")))("module"))
    (no-such-file-or-directory-exception-arguments
     ("args" (("required" exc) ("optional") ("key")))("module"))
    (nonempty-input-port-character-buffer-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (nonprocedure-operator-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (not ("args" (("required" obj) ("optional") ("key")))("module"))
    (null-environment ("args" (("required" version) ("optional") ("key")))("module"))
    (null? ("args" (("required" obj) ("optional") ("key")))("module"))
    (number->string ("args" (("required" z radix) ("optional") ("key")))("module"))
    (number->string ("args" (("required" z) ("optional") ("key")))("module"))
    (number-of-arguments-limit-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (number? ("args" (("required" obj) ("optional") ("key")))("module"))
    (numerator ("args" (("required" q) ("optional") ("key")))("module"))
    (object->serial-number ("args" (("required" obj) ("optional") ("key")))("module"))
    (object->string ("args" (("required" obj [n]) ("optional") ("key")))("module"))
    (object->u8vector
     ("args" (("required" obj [encoder]) ("optional") ("key")))("module"))
    (odd? ("args" (("required" n) ("optional") ("key")))("module"))
    (open-directory
     ("args" (("required" path-or-settings) ("optional") ("key")))("module"))
    (open-dummy ("args" (("required") ("optional") ("key")))("module"))
    (open-event-queue ("args" (("required" n) ("optional") ("key")))("module"))
    (open-file ("args" (("required" path-or-settings) ("optional") ("key")))("module"))
    (open-input-file ("args" (("required" filename) ("optional") ("key")))("module"))
    (open-output-file ("args" (("required" filename) ("optional") ("key")))("module"))
    (open-process
     ("args" (("required" path-or-settings) ("optional") ("key")))("module"))
    (open-string
     ("args" (("required") ("optional" [string-or-settings]) ("key")))("module"))
    (open-tcp-client
     ("args"
      (("required" port-number-or-address-or-settings) ("optional") ("key")))("module"))
    (open-tcp-server
     ("args"
      (("required" port-number-or-address-or-settings) ("optional") ("key")))("module"))
    (open-u8vector
     ("args" (("required") ("optional" [u8vector-or-settings]) ("key")))("module"))
    (open-udp
     ("args"
      (("required" port-number-or-address-or-settings) ("optional") ("key")))("module"))
    (open-vector
     ("args" (("required") ("optional" [vector-or-settings]) ("key")))("module"))
    (open-vector-pipe
     ("args"
      (("required")
       ("optional" [vector-or-settings1 [vector-or-settings2]])
       ("key")))("module"))
    (or ("args" (("required" test1  [...]) ("optional") ("key")))("module"))
    (os-exception? ("args" (("required" obj) ("optional") ("key")))("module"))
    (output-port-width ("args" (("required" port) ("optional") ("key")))("module"))
    (output-port? ("args" (("required" obj) ("optional") ("key")))("module"))
    (pair? ("args" (("required" obj) ("optional") ("key")))("module"))
    (path-expand
     ("args" (("required" path [origin-directory]) ("optional") ("key")))("module"))
    (path-extension ("args" (("required" path) ("optional") ("key")))("module"))
    (path-normalize
     ("args"
      (("required" path [allow-relative? [origin-directory]])
       ("optional")
       ("key")))("module"))
    (peek-char ("args" (("required") ("optional" [port]) ("key")))("module"))
    (peek-char ("args" (("required") ("optional") ("key")))("module"))
    (peek-char ("args" (("required" port) ("optional") ("key")))("module"))
    (permission-denied-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (permission-denied-exception-procedure
     ("args" (("required" exc) ("optional") ("key")))("module"))
    (permission-denied-exception-arguments
     ("args" (("required" exc) ("optional") ("key")))("module"))
    (port-io-exception-handler-set!
     ("args" (("required" port handler) ("optional") ("key")))("module"))
    (port-settings-set!
     ("args" (("required" port settings) ("optional") ("key")))("module"))
    (positive? ("args" (("required" x) ("optional") ("key")))("module"))
    (pp ("args" (("required" obj [port]) ("optional") ("key")))("module"))
    (pretty-print ("args" (("required" obj [port]) ("optional") ("key")))("module"))
    (primordial-exception-handler
     ("args" (("required" exc) ("optional") ("key")))("module"))
    (print ("args"
            (("required") ("optional") ("key" [port: port] obj [...]))))
    (procedure? ("args" (("required" obj) ("optional") ("key")))("module"))
    (process-pid ("args" (("required" process-port) ("optional") ("key")))("module"))
    (process-status
     ("args"
      (("required" process-port [timeout [timeout-val]])
       ("optional")
       ("key")))("module"))
    (process-times ("args" (("required") ("optional") ("key")))("module"))
    (processor? ("args" (("required" obj) ("optional") ("key")))("module"))
    (protocol-info
     ("args" (("required" protocol-name-or-id) ("optional") ("key")))("module"))
    (protocol-info-aliases
     ("args" (("required" protocol-info) ("optional") ("key")))("module"))
    (protocol-info-name
     ("args" (("required" protocol-info) ("optional") ("key")))("module"))
    (protocol-info-number
     ("args" (("required" protocol-info) ("optional") ("key")))("module"))
    (protocol-info? ("args" (("required" obj) ("optional") ("key")))("module"))
    (quasiquote ("args" (("required" qq template) ("optional") ("key")))("module"))
    (quote ("args" (("required" datum) ("optional") ("key")))("module"))
    (quotient ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (raise ("args" (("required" obj) ("optional") ("key")))("module"))
    (random-f64vector ("args" (("required" n) ("optional") ("key")))("module"))
    (random-integer ("args" (("required" n) ("optional") ("key")))("module"))
    (random-real ("args" (("required") ("optional") ("key")))("module"))
    (random-source-make-f64vectors
     ("args" (("required" random-source [precision]) ("optional") ("key")))("module"))
    (random-source-make-integers
     ("args" (("required" random-source) ("optional") ("key")))("module"))
    (random-source-make-reals
     ("args" (("required" random-source [precision]) ("optional") ("key")))("module"))
    (random-source-make-u8vectors
     ("args" (("required" random-source) ("optional") ("key")))("module"))
    (random-source-randomize!
     ("args" (("required" random-source) ("optional") ("key")))("module"))
    (random-source-state-ref
     ("args" (("required" random-source) ("optional") ("key")))("module"))
    (random-source? ("args" (("required" obj) ("optional") ("key")))("module"))
    (random-u8vector ("args" (("required" n) ("optional") ("key")))("module"))
    (range-exception? ("args" (("required" obj) ("optional") ("key")))("module"))
    (rational? ("args" (("required" obj) ("optional") ("key")))("module"))
    (rationalize ("args" (("required" x y) ("optional") ("key")))("module"))
    (read ("args" (("required") ("optional" [port]) ("key")))("module"))
    (read ("args" (("required") ("optional") ("key")))("module"))
    (read ("args" (("required" port) ("optional") ("key")))("module"))
    (read-all ("args" (("required") ("optional" [port [reader]]) ("key")))("module"))
    (read-char ("args" (("required" port) ("optional") ("key")))("module"))
    (read-char ("args" (("required") ("optional") ("key")))("module"))
    (read-char ("args" (("required") ("optional" [port]) ("key")))("module"))
    (read-line
     ("args"
      (("required")
       ("optional" [port [separator [include-separator? [max-length]]]])
       ("key")))("module"))
    (read-substring
     ("args"
      (("required" string start end [port [need]])
       ("optional")
       ("key")))("module"))
    (read-subu8vector
     ("args"
      (("required" u8vector start end [port [need]])
       ("optional")
       ("key")))("module"))
    (read-u8 ("args" (("required") ("optional" [port]) ("key")))("module"))
    (readtable-case-conversion?
     ("args" (("required" readtable) ("optional") ("key")))("module"))
    (readtable-eval-allowed?
     ("args" (("required" readtable) ("optional") ("key")))("module"))
    (readtable-keywords-allowed?
     ("args" (("required" readtable) ("optional") ("key")))("module"))
    (readtable-max-unescaped-char
     ("args" (("required" readtable) ("optional") ("key")))("module"))
    (readtable-max-write-length
     ("args" (("required" readtable) ("optional") ("key")))("module"))
    (readtable-max-write-level
     ("args" (("required" readtable) ("optional") ("key")))("module"))
    (readtable-sharing-allowed?
     ("args" (("required" readtable) ("optional") ("key")))("module"))
    (readtable-start-syntax
     ("args" (("required" readtable) ("optional") ("key")))("module"))
    (readtable-write-cdr-read-macros?
     ("args" (("required" readtable) ("optional") ("key")))("module"))
    (readtable? ("args" (("required" obj) ("optional") ("key")))("module"))
    (real-part ("args" (("required" z) ("optional") ("key")))("module"))
    (real? ("args" (("required" obj) ("optional") ("key")))("module"))
    (remainder ("args" (("required" n1 n2) ("optional") ("key")))("module"))
    (rename-file
     ("args"
      (("required" source-path destination-path) ("optional") ("key")))("module"))
    (repl-display-environment?
     ("args" (("required" display?) ("optional") ("key")))("module"))
    (repl-input-port ("args" (("required") ("optional") ("key")))("module"))
    (repl-result-history-ref ("args" (("required" i) ("optional") ("key")))("module"))
    (reverse ("args" (("required" list) ("optional") ("key")))("module"))
    (reverse! ("args" (("required" list) ("optional") ("key")))("module"))
    (round ("args" (("required" x) ("optional") ("key")))("module"))
    (rpc-remote-error-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (s16vector? ("args" (("required" obj) ("optional") ("key")))("module"))
    (s32vector? ("args" (("required" obj) ("optional") ("key")))("module"))
    (s64vector? ("args" (("required" obj) ("optional") ("key")))("module"))
    (s8vector? ("args" (("required" obj) ("optional") ("key")))("module"))
    (scheduler-exception? ("args" (("required" obj) ("optional") ("key")))("module"))
    (scheme-report-environment
     ("args" (("required" version) ("optional") ("key")))("module"))
    (service-info
     ("args" (("required" service-name-or-id) ("optional") ("key")))("module"))
    (service-info-aliases
     ("args" (("required" service-info) ("optional") ("key")))("module"))
    (service-info-name
     ("args" (("required" service-info) ("optional") ("key")))("module"))
    (service-info-port-number
     ("args" (("required" service-info) ("optional") ("key")))("module"))
    (service-info-protocol
     ("args" (("required" service-info) ("optional") ("key")))("module"))
    (service-info? ("args" (("required" obj) ("optional") ("key")))("module"))
    (set! ("args" (("required" variable expression) ("optional") ("key")))("module"))
    (set-car! ("args" (("required" pair obj) ("optional") ("key")))("module"))
    (set-cdr! ("args" (("required" pair obj) ("optional") ("key")))("module"))
    (sfun-conversion-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (shell-command
     ("args" (("required" command [capture?]) ("optional") ("key")))("module"))
    (sin ("args" (("required" z) ("optional") ("key")))("module"))
    (socket-info? ("args" (("required" obj) ("optional") ("key")))("module"))
    (sqrt ("args" (("required" z) ("optional") ("key")))("module"))
    (stack-overflow-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (started-thread-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (step ("args" (("required") ("optional") ("key")))("module"))
    (string ("args" (("required" char  [...]) ("optional") ("key")))("module"))
    (string->list ("args" (("required" string) ("optional") ("key")))("module"))
    (string->number ("args" (("required" string) ("optional") ("key")))("module"))
    (string->number
     ("args" (("required" string radix) ("optional") ("key")))("module"))
    (string->symbol ("args" (("required" string) ("optional") ("key")))("module"))
    (string->uninterned-keyword
     ("args" (("required" name [hash]) ("optional") ("key")))("module"))
    (string->uninterned-symbol
     ("args" (("required" name [hash]) ("optional") ("key")))("module"))
    (string-append ("args" (("required" string  [...]) ("optional") ("key")))("module"))
    (string-ci<=? ("args" (("required") ("optional" [string]) ("key")))("module"))
    (string-ci<? ("args" (("required") ("optional" [string]) ("key")))("module"))
    (string-ci=? ("args" (("required") ("optional" [string]) ("key")))("module"))
    (string-ci=?-hash ("args" (("required" string) ("optional") ("key")))("module"))
    (string-ci>=? ("args" (("required") ("optional" [string]) ("key")))("module"))
    (string-ci>? ("args" (("required") ("optional" [string]) ("key")))("module"))
    (string-copy ("args" (("required" string) ("optional") ("key")))("module"))
    (string-fill! ("args" (("required" string char) ("optional") ("key")))("module"))
    (string-length ("args" (("required" string) ("optional") ("key")))("module"))
    (string-ref ("args" (("required" string k) ("optional") ("key")))("module"))
    (string-set!
     ("args" (("required" string k char) ("optional") ("key")))("module"))
    (string-shrink! ("args" (("required" string k) ("optional") ("key")))("module"))
    (string<=? ("args" (("required") ("optional" [string]) ("key")))("module"))
    (string<? ("args" (("required") ("optional" [string]) ("key")))("module"))
    (string=? ("args" (("required") ("optional" [string]) ("key")))("module"))
    (string=? ("args" (("required" string1 [...]) ("optional") ("key")))("module"))
    (string=?-hash ("args" (("required" string) ("optional") ("key")))("module"))
    (string>=? ("args" (("required") ("optional" [string]) ("key")))("module"))
    (string>? ("args" (("required") ("optional" [string]) ("key")))("module"))
    (string? ("args" (("required" obj) ("optional") ("key")))("module"))
    (substring
     ("args" (("required" string start end) ("optional") ("key")))("module"))
    (substring-fill!
     ("args" (("required" string start end fill) ("optional") ("key")))("module"))
    (substring-move!
     ("args"
      (("required" src-string src-start src-end dst-string dst-start)
       ("optional")
       ("key")))("module"))
    (subvector
     ("args" (("required" vector start end) ("optional") ("key")))("module"))
    (subvector-fill!
     ("args" (("required" vector start end fill) ("optional") ("key")))("module"))
    (subvector-move!
     ("args"
      (("required" src-vector src-start src-end dst-vector dst-start)
       ("optional")
       ("key")))("module"))
    (symbol->string ("args" (("required" symbol) ("optional") ("key")))("module"))
    (symbol-hash ("args" (("required" symbol) ("optional") ("key")))("module"))
    (symbol? ("args" (("required" obj) ("optional") ("key")))("module"))
    (system-stamp ("args" (("required") ("optional") ("key")))("module"))
    (system-type ("args" (("required") ("optional") ("key")))("module"))
    (system-version ("args" (("required") ("optional") ("key")))("module"))
    (table->list ("args" (("required" table) ("optional") ("key")))("module"))
    (table-copy ("args" (("required" table) ("optional") ("key")))("module"))
    (table-for-each ("args" (("required" proc table) ("optional") ("key")))("module"))
    (table-length ("args" (("required" table) ("optional") ("key")))("module"))
    (table-merge
     ("args"
      (("required" table1 table2 [table2-takes-precedence?])
       ("optional")
       ("key")))("module"))
    (table-merge!
     ("args"
      (("required" table1 table2 [table2-takes-precedence?])
       ("optional")
       ("key")))("module"))
    (table-ref
     ("args" (("required" table key [default]) ("optional") ("key")))("module"))
    (table-search ("args" (("required" proc table) ("optional") ("key")))("module"))
    (table-set!
     ("args" (("required" table key [value]) ("optional") ("key")))("module"))
    (table? ("args" (("required" obj) ("optional") ("key")))("module"))
    (take ("args" (("required" x i) ("optional") ("key")))("module"))
    (tan ("args" (("required" z) ("optional") ("key")))("module"))
    (tcp-client-local-socket-info
     ("args" (("required" tcp-client-port) ("optional") ("key")))("module"))
    (tcp-server-socket-info
     ("args" (("required" tcp-server-port) ("optional") ("key")))("module"))
    (tcp-service-register!
     ("args"
      (("required"
        port-number-or-address-or-settings thunk [thread-group])
       ("optional")
       ("key")))("module"))
    (terminated-thread-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (thread-base-priority ("args" (("required" thread) ("optional") ("key")))("module"))
    (thread-init!
     ("args"
      (("required" thread thunk [name [thread-group]])
       ("optional")
       ("key")))("module"))
    (thread-interrupt!
     ("args" (("required" thread [thunk]) ("optional") ("key")))("module"))
    (thread-join!
     ("args"
      (("required" thread [timeout [timeout-val]]) ("optional") ("key")))("module"))
    (thread-name ("args" (("required" thread) ("optional") ("key")))("module"))
    (thread-priority-boost
     ("args" (("required" thread) ("optional") ("key")))("module"))
    (thread-quantum ("args" (("required" thread) ("optional") ("key")))("module"))
    (thread-receive
     ("args" (("required") ("optional" [timeout [default]]) ("key")))("module"))
    (thread-send ("args" (("required" thread msg) ("optional") ("key")))("module"))
    (thread-sleep! ("args" (("required" timeout) ("optional") ("key")))("module"))
    (thread-specific ("args" (("required" thread) ("optional") ("key")))("module"))
    (thread-start! ("args" (("required" thread) ("optional") ("key")))("module"))
    (thread-state ("args" (("required" thread) ("optional") ("key")))("module"))
    (thread-suspend! ("args" (("required" thread) ("optional") ("key")))("module"))
    (thread-terminate! ("args" (("required" thread) ("optional") ("key")))("module"))
    (thread-thread-group ("args" (("required" thread) ("optional") ("key")))("module"))
    (thread-yield! ("args" (("required") ("optional") ("key")))("module"))
    (thread? ("args" (("required" obj) ("optional") ("key")))("module"))
    (timeout->time ("args" (("required" timeout) ("optional") ("key")))("module"))
    (trace ("args" (("required" proc [...]) ("optional") ("key")))("module"))
    (transcript-off ("args" (("required") ("optional") ("key")))("module"))
    (transcript-on ("args" (("required" filename) ("optional") ("key")))("module"))
    (transcript-on ("args" (("required" file) ("optional") ("key")))("module"))
    (truncate ("args" (("required" x) ("optional") ("key")))("module"))
    (tty? ("args" (("required" obj) ("optional") ("key")))("module"))
    (type-exception? ("args" (("required" obj) ("optional") ("key")))("module"))
    (u16vector? ("args" (("required" obj) ("optional") ("key")))("module"))
    (u32vector? ("args" (("required" obj) ("optional") ("key")))("module"))
    (u64vector? ("args" (("required" obj) ("optional") ("key")))("module"))
    (u8vector? ("args" (("required" obj) ("optional") ("key")))("module"))
    (udp-destination-set!
     ("args"
      (("required" address port-number [udp-port]) ("optional") ("key")))("module"))
    (udp-local-socket-info
     ("args" (("required" udp-port) ("optional") ("key")))("module"))
    (udp-read-u8vector
     ("args" (("required") ("optional" [udp-port]) ("key")))("module"))
    (unbound-global-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (unbound-key-exception? ("args" (("required" obj) ("optional") ("key")))("module"))
    (unbound-os-environment-variable-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (unbound-serial-number-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (uncaught-exception? ("args" (("required" obj) ("optional") ("key")))("module"))
    (uninitialized-thread-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (unknown-keyword-argument-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (unterminated-process-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (user-info ("args" (("required" user-name-or-id) ("optional") ("key")))("module"))
    (user-info-gid ("args" (("required" user-info) ("optional") ("key")))("module"))
    (user-info-home ("args" (("required" user-info) ("optional") ("key")))("module"))
    (user-info-name ("args" (("required" user-info) ("optional") ("key")))("module"))
    (user-info-shell ("args" (("required" user-info) ("optional") ("key")))("module"))
    (user-info-uid ("args" (("required" user-info) ("optional") ("key")))("module"))
    (user-info? ("args" (("required" obj) ("optional") ("key")))("module"))
    (user-name ("args" (("required") ("optional") ("key")))("module"))
    (values ("args" (("required") ("optional" [obj  ...]) ("key")))("module"))
    (vector ("args" (("required" obj  [...]) ("optional") ("key")))("module"))
    (vector->list ("args" (("required" vector) ("optional") ("key")))("module"))
    (vector-append ("args" (("required" vector [...]) ("optional") ("key")))("module"))
    (vector-copy ("args" (("required" vector) ("optional") ("key")))("module"))
    (vector-fill! ("args" (("required" vector fill) ("optional") ("key")))("module"))
    (vector-length ("args" (("required" vector) ("optional") ("key")))("module"))
    (vector-ref ("args" (("required" vector k) ("optional") ("key")))("module"))
    (vector-ref ("args" (("required" vector k) ("optional") ("key")))("module"))
    (vector-set!
     ("args" (("required" vector k obj) ("optional") ("key")))("module"))
    (vector-shrink! ("args" (("required" vector k) ("optional") ("key")))("module"))
    (vector? ("args" (("required" obj) ("optional") ("key")))("module"))
    (void ("args" (("required") ("optional") ("key")))("module"))
    (with-exception-catcher
     ("args" (("required" handler thunk) ("optional") ("key")))("module"))
    (with-exception-handler
        ("args" (("required" handler thunk) ("optional") ("key")))("module"))
    (with-input-from-file
        ("args" (("required" string thunk) ("optional") ("key")))("module"))
    (with-input-from-port
        ("args" (("required" port thunk) ("optional") ("key")))("module"))
    (with-output-to-file
        ("args" (("required" string thunk) ("optional") ("key")))("module"))
    (write ("args" (("required" obj [port]) ("optional") ("key")))("module"))
    (write-char ("args" (("required" char) ("optional") ("key")))("module"))
    (write-char ("args" (("required" char port) ("optional") ("key")))("module"))
    (write-char ("args" (("required" char [port]) ("optional") ("key")))("module"))
    (write-u8 ("args" (("required" n [port]) ("optional") ("key")))("module"))
    (wrong-number-of-arguments-exception?
     ("args" (("required" obj) ("optional") ("key")))("module"))
    (xcons ("args" (("required" d a) ("optional") ("key")))("module"))
    (zero? ("args" (("required" z) ("optional") ("key")))("module"))))

;; Esc-C-b to skip this particularly long sexpression.





;; Spawn a server for remote repl access TODO make it works with remote repl

;;(define (geiser-start-server . rest)
;;  (let* ((listener (tcp-listen 0))
;;         (port (tcp-listener-port listener)))
;;    (define (remote-repl)
;;        (receive (in out) (tcp-accept listener)
;;          (current-input-port in)
;;          (current-output-port out)
;;          (current-error-port out)
;;
;;          (repl)))
;;
;;    (thread-start! (make-thread remote-repl))
;;
;;    (write-to-log `(geiser-start-server . ,rest))
;;    (write-to-log `(port ,port))
;;
;;    (write `(port ,port))
;;    (newline)))

;;;============================================================================
