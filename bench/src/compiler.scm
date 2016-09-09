;(define integer->char ascii->char)
;(define char->integer char->ascii)

(define open-input-file* open-input-file)
(define (pp-expression expr port) (write expr port) (newline port))
(define (write-returning-len obj port) (write obj port) 1)
(define (display-returning-len obj port) (display obj port) 1)
(define (write-word w port)
  (write-char (integer->char (quotient w 256)) port)
  (write-char (integer->char (modulo w 256)) port))
(define char-nul (integer->char 0))
(define char-tab (integer->char 9))
(define char-newline (integer->char 10))
(define character-encoding char->integer)
(define max-character-encoding 255)
(define (fatal-err msg arg) (fatal-error msg arg))
(define (scheme-global-var name) name)
(define (scheme-global-var-ref var) (scheme-global-eval var fatal-err))
(define (scheme-global-var-set! var val)
  (scheme-global-eval (list 'set! var (list 'quote val)) fatal-err))
(define (scheme-global-eval expr err) `(eval ,expr)) ;; eval not needed for test
(define (pinpoint-error filename line char) #t)
(define file-path-sep #\:)
(define file-ext-sep #\.)
(define (path-absolute? x)
  (and (> (string-length x) 0)
       (let ((c (string-ref x 0))) (or (char=? c #\/) (char=? c #\~)))))
(define (file-path x)
  (let loop1 ((i (string-length x)))
    (if (and (> i 0) (not (char=? (string-ref x (- i 1)) file-path-sep)))
        (loop1 (- i 1))
        (let ((result (make-string i)))
          (let loop2 ((j (- i 1)))
            (if (< j 0)
                result
                (begin
                  (string-set! result j (string-ref x j))
                  (loop2 (- j 1)))))))))
(define (file-name x)
  (let loop1 ((i (string-length x)))
    (if (and (> i 0) (not (char=? (string-ref x (- i 1)) file-path-sep)))
        (loop1 (- i 1))
        (let ((result (make-string (- (string-length x) i))))
          (let loop2 ((j (- (string-length x) 1)))
            (if (< j i)
                result
                (begin
                  (string-set! result (- j i) (string-ref x j))
                  (loop2 (- j 1)))))))))
(define (file-ext x)
  (let loop1 ((i (string-length x)))
    (if (or (= i 0) (char=? (string-ref x (- i 1)) file-path-sep))
        #f
        (if (not (char=? (string-ref x (- i 1)) file-ext-sep))
            (loop1 (- i 1))
            (let ((result (make-string (- (string-length x) i))))
              (let loop2 ((j (- (string-length x) 1)))
                (if (< j i)
                    result
                    (begin
                      (string-set! result (- j i) (string-ref x j))
                      (loop2 (- j 1))))))))))
(define (file-root x)
  (let loop1 ((i (string-length x)))
    (if (or (= i 0) (char=? (string-ref x (- i 1)) file-path-sep))
        x
        (if (not (char=? (string-ref x (- i 1)) file-ext-sep))
            (loop1 (- i 1))
            (let ((result (make-string (- i 1))))
              (let loop2 ((j (- i 2)))
                (if (< j 0)
                    result
                    (begin
                      (string-set! result j (string-ref x j))
                      (loop2 (- j 1))))))))))
(define (make-counter next limit limit-error)
  (lambda ()
    (if (< next limit)
        (let ((result next)) (set! next (+ next 1)) result)
        (limit-error))))
(define (pos-in-list x l)
  (let loop ((l l) (i 0))
    (cond ((not (pair? l)) #f)
          ((eq? (car l) x) i)
          (else (loop (cdr l) (+ i 1))))))
(define (string-pos-in-list x l)
  (let loop ((l l) (i 0))
    (cond ((not (pair? l)) #f)
          ((string=? (car l) x) i)
          (else (loop (cdr l) (+ i 1))))))
(define (nth-after l n)
  (let loop ((l l) (n n)) (if (> n 0) (loop (cdr l) (- n 1)) l)))
(define (pair-up l1 l2)
  (define (pair l1 l2)
    (if (pair? l1)
        (cons (cons (car l1) (car l2)) (pair (cdr l1) (cdr l2)))
        '()))
  (pair l1 l2))
(define (my-last-pair l)
  (let loop ((l l)) (if (pair? (cdr l)) (loop (cdr l)) l)))
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
      (if (or (null? l) (null? (cdr l))) l (cons (car l) (split (cddr l)))))
    (if (or (null? l) (null? (cdr l)))
        l
        (let* ((l1 (mergesort (split l))) (l2 (mergesort (split (cdr l)))))
          (merge l1 l2))))
  (mergesort l))
(define (lst->vector l)
  (let* ((n (length l)) (v (make-vector n)))
    (let loop ((l l) (i 0))
      (if (pair? l)
          (begin (vector-set! v i (car l)) (loop (cdr l) (+ i 1)))
          v))))
(define (vector->lst v)
  (let loop ((l '()) (i (- (vector-length v) 1)))
    (if (< i 0) l (loop (cons (vector-ref v i) l) (- i 1)))))
(define (lst->string l)
  (let* ((n (length l)) (s (make-string n)))
    (let loop ((l l) (i 0))
      (if (pair? l)
          (begin (string-set! s i (car l)) (loop (cdr l) (+ i 1)))
          s))))
(define (string->lst s)
  (let loop ((l '()) (i (- (string-length s) 1)))
    (if (< i 0) l (loop (cons (string-ref s i) l) (- i 1)))))
(define (with-exception-handling proc)
  (let ((old-exception-handler throw-to-exception-handler))
    (let ((val (call-with-current-continuation
                (lambda (cont)
                  (set! throw-to-exception-handler cont)
                  (proc)))))
      (set! throw-to-exception-handler old-exception-handler)
      val)))
(define (throw-to-exception-handler val)
  (fatal-err "Internal error, no exception handler at this point" val))
(define (compiler-error msg . args)
  (newline)
  (display "*** ERROR -- ")
  (display msg)
  (for-each (lambda (x) (display " ") (write x)) args)
  (newline)
  (compiler-abort))
(define (compiler-user-error loc msg . args)
  (newline)
  (display "*** ERROR -- In ")
  (locat-show loc)
  (newline)
  (display "*** ")
  (display msg)
  (for-each (lambda (x) (display " ") (write x)) args)
  (newline)
  (compiler-abort))
(define (compiler-internal-error msg . args)
  (newline)
  (display "*** ERROR -- Compiler internal error detected")
  (newline)
  (display "*** in procedure ")
  (display msg)
  (for-each (lambda (x) (display " ") (write x)) args)
  (newline)
  (compiler-abort))
(define (compiler-limitation-error msg . args)
  (newline)
  (display "*** ERROR -- Compiler limit reached")
  (newline)
  (display "*** ")
  (display msg)
  (for-each (lambda (x) (display " ") (write x)) args)
  (newline)
  (compiler-abort))
(define (compiler-abort) (throw-to-exception-handler #f))
(define (make-gnode label edges) (vector label edges))
(define (gnode-label x) (vector-ref x 0))
(define (gnode-edges x) (vector-ref x 1))
(define (transitive-closure graph)
  (define changed? #f)
  (define (closure edges)
    (list->set
     (set-union
      edges
      (apply set-union
             (map (lambda (label) (gnode-edges (gnode-find label graph)))
                  (set->list edges))))))
  (let ((new-graph
         (set-map (lambda (x)
                    (let ((new-edges (closure (gnode-edges x))))
                      (if (not (set-equal? new-edges (gnode-edges x)))
                          (set! changed? #t))
                      (make-gnode (gnode-label x) new-edges)))
                  graph)))
    (if changed? (transitive-closure new-graph) new-graph)))
(define (gnode-find label graph)
  (define (find label l)
    (cond ((null? l) #f)
          ((eq? (gnode-label (car l)) label) (car l))
          (else (find label (cdr l)))))
  (find label (set->list graph)))
(define (topological-sort graph)
  (if (set-empty? graph)
      '()
      (let ((to-remove (or (remove-no-edges graph) (remove-cycle graph))))
        (let ((labels (set-map gnode-label to-remove)))
          (cons labels
                (topological-sort
                 (set-map (lambda (x)
                            (make-gnode
                             (gnode-label x)
                             (set-difference (gnode-edges x) labels)))
                          (set-difference graph to-remove))))))))
(define (remove-no-edges graph)
  (let ((nodes-with-no-edges
         (set-keep (lambda (x) (set-empty? (gnode-edges x))) graph)))
    (if (set-empty? nodes-with-no-edges) #f nodes-with-no-edges)))
(define (remove-cycle graph)
  (define (remove l)
    (let ((edges (gnode-edges (car l))))
      (define (equal-edges? x) (set-equal? (gnode-edges x) edges))
      (define (member-edges? x) (set-member? (gnode-label x) edges))
      (if (set-member? (gnode-label (car l)) edges)
          (let ((edge-graph (set-keep member-edges? graph)))
            (if (set-every? equal-edges? edge-graph)
                edge-graph
                (remove (cdr l))))
          (remove (cdr l)))))
  (remove (set->list graph)))
(define (list->set list) list)
(define (set->list set) set)
(define (set-empty) '())
(define (set-empty? set) (null? set))
(define (set-member? x set) (memq x set))
(define (set-singleton x) (list x))
(define (set-adjoin set x) (if (memq x set) set (cons x set)))
(define (set-remove set x)
  (cond ((null? set) '())
        ((eq? (car set) x) (cdr set))
        (else (cons (car set) (set-remove (cdr set) x)))))
(define (set-equal? s1 s2)
  (cond ((null? s1) (null? s2))
        ((memq (car s1) s2) (set-equal? (cdr s1) (set-remove s2 (car s1))))
        (else #f)))
(define (set-difference set . other-sets)
  (define (difference s1 s2)
    (cond ((null? s1) '())
          ((memq (car s1) s2) (difference (cdr s1) s2))
          (else (cons (car s1) (difference (cdr s1) s2)))))
  (n-ary difference set other-sets))
(define (set-union . sets)
  (define (union s1 s2)
    (cond ((null? s1) s2)
          ((memq (car s1) s2) (union (cdr s1) s2))
          (else (cons (car s1) (union (cdr s1) s2)))))
  (n-ary union '() sets))
(define (set-intersection set . other-sets)
  (define (intersection s1 s2)
    (cond ((null? s1) '())
          ((memq (car s1) s2) (cons (car s1) (intersection (cdr s1) s2)))
          (else (intersection (cdr s1) s2))))
  (n-ary intersection set other-sets))
(define (n-ary function first rest)
  (if (null? rest)
      first
      (n-ary function (function first (car rest)) (cdr rest))))
(define (set-keep keep? set)
  (cond ((null? set) '())
        ((keep? (car set)) (cons (car set) (set-keep keep? (cdr set))))
        (else (set-keep keep? (cdr set)))))
(define (set-every? pred? set)
  (or (null? set) (and (pred? (car set)) (set-every? pred? (cdr set)))))
(define (set-map proc set)
  (if (null? set) '() (cons (proc (car set)) (set-map proc (cdr set)))))
(define (list->queue list)
  (cons list (if (pair? list) (my-last-pair list) '())))
(define (queue->list queue) (car queue))
(define (queue-empty) (cons '() '()))
(define (queue-empty? queue) (null? (car queue)))
(define (queue-get! queue)
  (if (null? (car queue))
      (compiler-internal-error "queue-get!, queue is empty")
      (let ((x (caar queue)))
        (set-car! queue (cdar queue))
        (if (null? (car queue)) (set-cdr! queue '()))
        x)))
(define (queue-put! queue x)
  (let ((entry (cons x '())))
    (if (null? (car queue))
        (set-car! queue entry)
        (set-cdr! (cdr queue) entry))
    (set-cdr! queue entry)
    x))
(define (string->canonical-symbol str)
  (let ((len (string-length str)))
    (let loop ((str str) (s (make-string len)) (i (- len 1)))
      (if (>= i 0)
          (begin
            (string-set! s i (char-downcase (string-ref str i)))
            (loop str s (- i 1)))
          (string->symbol s)))))
(define quote-sym (string->canonical-symbol "QUOTE"))
(define quasiquote-sym (string->canonical-symbol "QUASIQUOTE"))
(define unquote-sym (string->canonical-symbol "UNQUOTE"))
(define unquote-splicing-sym (string->canonical-symbol "UNQUOTE-SPLICING"))
(define lambda-sym (string->canonical-symbol "LAMBDA"))
(define if-sym (string->canonical-symbol "IF"))
(define set!-sym (string->canonical-symbol "SET!"))
(define cond-sym (string->canonical-symbol "COND"))
(define =>-sym (string->canonical-symbol "=>"))
(define else-sym (string->canonical-symbol "ELSE"))
(define and-sym (string->canonical-symbol "AND"))
(define or-sym (string->canonical-symbol "OR"))
(define case-sym (string->canonical-symbol "CASE"))
(define let-sym (string->canonical-symbol "LET"))
(define let*-sym (string->canonical-symbol "LET*"))
(define letrec-sym (string->canonical-symbol "LETREC"))
(define begin-sym (string->canonical-symbol "BEGIN"))
(define do-sym (string->canonical-symbol "DO"))
(define define-sym (string->canonical-symbol "DEFINE"))
(define delay-sym (string->canonical-symbol "DELAY"))
(define future-sym (string->canonical-symbol "FUTURE"))
(define **define-macro-sym (string->canonical-symbol "DEFINE-MACRO"))
(define **declare-sym (string->canonical-symbol "DECLARE"))
(define **include-sym (string->canonical-symbol "INCLUDE"))
(define not-sym (string->canonical-symbol "NOT"))
(define **c-declaration-sym (string->canonical-symbol "C-DECLARATION"))
(define **c-init-sym (string->canonical-symbol "C-INIT"))
(define **c-procedure-sym (string->canonical-symbol "C-PROCEDURE"))
(define void-sym (string->canonical-symbol "VOID"))
(define char-sym (string->canonical-symbol "CHAR"))
(define signed-char-sym (string->canonical-symbol "SIGNED-CHAR"))
(define unsigned-char-sym (string->canonical-symbol "UNSIGNED-CHAR"))
(define short-sym (string->canonical-symbol "SHORT"))
(define unsigned-short-sym (string->canonical-symbol "UNSIGNED-SHORT"))
(define int-sym (string->canonical-symbol "INT"))
(define unsigned-int-sym (string->canonical-symbol "UNSIGNED-INT"))
(define long-sym (string->canonical-symbol "LONG"))
(define unsigned-long-sym (string->canonical-symbol "UNSIGNED-LONG"))
(define float-sym (string->canonical-symbol "FLOAT"))
(define double-sym (string->canonical-symbol "DOUBLE"))
(define pointer-sym (string->canonical-symbol "POINTER"))
(define boolean-sym (string->canonical-symbol "BOOLEAN"))
(define string-sym (string->canonical-symbol "STRING"))
(define scheme-object-sym (string->canonical-symbol "SCHEME-OBJECT"))
(define c-id-prefix "___")
(define false-object (if (eq? '() #f) (string->symbol "#f") #f))
(define (false-object? obj) (eq? obj false-object))
(define undef-object (string->symbol "#[undefined]"))
(define (undef-object? obj) (eq? obj undef-object))
(define (symbol-object? obj)
  (and (not (false-object? obj)) (not (undef-object? obj)) (symbol? obj)))
(define scm-file-exts '("scm" #f))
(define compiler-version "2.2.2")
(define (open-sf filename)
  (define (open-err) (compiler-error "Can't find file" filename))
  (if (not (file-ext filename))
      (let loop ((exts scm-file-exts))
        (if (pair? exts)
            (let* ((ext (car exts))
                   (full-name
                    (if ext (string-append filename "." ext) filename))
                   (port (open-input-file* full-name)))
              (if port (vector port full-name 0 1 0) (loop (cdr exts))))
            (open-err)))
      (let ((port (open-input-file* filename)))
        (if port (vector port filename 0 1 0) (open-err)))))
(define (close-sf sf) (close-input-port (vector-ref sf 0)))
(define (sf-read-char sf)
  (let ((c (read-char (vector-ref sf 0))))
    (cond ((eof-object? c))
          ((char=? c char-newline)
           (vector-set! sf 3 (+ (vector-ref sf 3) 1))
           (vector-set! sf 4 0))
          (else (vector-set! sf 4 (+ (vector-ref sf 4) 1))))
    c))
(define (sf-peek-char sf) (peek-char (vector-ref sf 0)))
(define (sf-read-error sf msg . args)
  (apply compiler-user-error
         (cons (sf->locat sf)
               (cons (string-append "Read error -- " msg) args))))
(define (sf->locat sf)
  (vector 'file
          (vector-ref sf 1)
          (vector-ref sf 2)
          (vector-ref sf 3)
          (vector-ref sf 4)))
(define (expr->locat expr source) (vector 'expr expr source))
(define (locat-show loc)
  (if loc
      (case (vector-ref loc 0)
        ((file)
         (if (pinpoint-error
              (vector-ref loc 1)
              (vector-ref loc 3)
              (vector-ref loc 4))
             (begin
               (display "file \"")
               (display (vector-ref loc 1))
               (display "\", line ")
               (display (vector-ref loc 3))
               (display ", character ")
               (display (vector-ref loc 4)))))
        ((expr)
         (display "expression ")
         (write (vector-ref loc 1))
         (if (vector-ref loc 2)
             (begin
               (display " ")
               (locat-show (source-locat (vector-ref loc 2))))))
        (else (compiler-internal-error "locat-show, unknown location tag")))
      (display "unknown location")))
(define (locat-filename loc)
  (if loc
      (case (vector-ref loc 0)
        ((file) (vector-ref loc 1))
        ((expr)
         (let ((source (vector-ref loc 2)))
           (if source (locat-filename (source-locat source)) "")))
        (else
         (compiler-internal-error "locat-filename, unknown location tag")))
      ""))
(define (make-source code locat) (vector code locat))
(define (source-code x) (vector-ref x 0))
(define (source-code-set! x y) (vector-set! x 0 y) x)
(define (source-locat x) (vector-ref x 1))
(define (expression->source expr source)
  (define (expr->source x)
    (make-source
     (cond ((pair? x) (list->source x))
           ((vector? x) (vector->source x))
           ((symbol-object? x) (string->canonical-symbol (symbol->string x)))
           (else x))
     (expr->locat x source)))
  (define (list->source l)
    (cond ((pair? l) (cons (expr->source (car l)) (list->source (cdr l))))
          ((null? l) '())
          (else (expr->source l))))
  (define (vector->source v)
    (let* ((len (vector-length v)) (x (make-vector len)))
      (let loop ((i (- len 1)))
        (if (>= i 0)
            (begin
              (vector-set! x i (expr->source (vector-ref v i)))
              (loop (- i 1)))))
      x))
  (expr->source expr))
(define (source->expression source)
  (define (list->expression l)
    (cond ((pair? l)
           (cons (source->expression (car l)) (list->expression (cdr l))))
          ((null? l) '())
          (else (source->expression l))))
  (define (vector->expression v)
    (let* ((len (vector-length v)) (x (make-vector len)))
      (let loop ((i (- len 1)))
        (if (>= i 0)
            (begin
              (vector-set! x i (source->expression (vector-ref v i)))
              (loop (- i 1)))))
      x))
  (let ((code (source-code source)))
    (cond ((pair? code) (list->expression code))
          ((vector? code) (vector->expression code))
          (else code))))
(define (file->sources filename info-port)
  (if info-port
      (begin
        (display "(reading \"" info-port)
        (display filename info-port)
        (display "\"" info-port)))
  (let ((sf (open-sf filename)))
    (define (read-sources)
      (let ((source (read-source sf)))
        (if (not (eof-object? source))
            (begin
              (if info-port (display "." info-port))
              (cons source (read-sources)))
            '())))
    (let ((sources (read-sources)))
      (if info-port (display ")" info-port))
      (close-sf sf)
      sources)))
(define (file->sources* filename info-port loc)
  (file->sources
   (if (path-absolute? filename)
       filename
       (string-append (file-path (locat-filename loc)) filename))
   info-port))
(define (read-source sf)
  (define (read-char*)
    (let ((c (sf-read-char sf)))
      (if (eof-object? c)
          (sf-read-error sf "Premature end of file encountered")
          c)))
  (define (read-non-whitespace-char)
    (let ((c (read-char*)))
      (cond ((< 0 (vector-ref read-table (char->integer c)))
             (read-non-whitespace-char))
            ((char=? c #\;)
             (let loop ()
               (if (not (char=? (read-char*) char-newline))
                   (loop)
                   (read-non-whitespace-char))))
            (else c))))
  (define (delimiter? c)
    (or (eof-object? c) (not (= (vector-ref read-table (char->integer c)) 0))))
  (define (read-list first)
    (let ((result (cons first '())))
      (let loop ((end result))
        (let ((c (read-non-whitespace-char)))
          (cond ((char=? c #\)))
                ((and (char=? c #\.) (delimiter? (sf-peek-char sf)))
                 (let ((x (read-source sf)))
                   (if (char=? (read-non-whitespace-char) #\))
                       (set-cdr! end x)
                       (sf-read-error sf "')' expected"))))
                (else
                 (let ((tail (cons (rd* c) '())))
                   (set-cdr! end tail)
                   (loop tail))))))
      result))
  (define (read-vector)
    (define (loop i)
      (let ((c (read-non-whitespace-char)))
        (if (char=? c #\))
            (make-vector i '())
            (let* ((x (rd* c)) (v (loop (+ i 1)))) (vector-set! v i x) v))))
    (loop 0))
  (define (read-string)
    (define (loop i)
      (let ((c (read-char*)))
        (cond ((char=? c #\") (make-string i #\space))
              ((char=? c #\\)
               (let* ((c (read-char*)) (s (loop (+ i 1))))
                 (string-set! s i c)
                 s))
              (else (let ((s (loop (+ i 1)))) (string-set! s i c) s)))))
    (loop 0))
  (define (read-symbol/number-string i)
    (if (delimiter? (sf-peek-char sf))
        (make-string i #\space)
        (let* ((c (sf-read-char sf)) (s (read-symbol/number-string (+ i 1))))
          (string-set! s i (char-downcase c))
          s)))
  (define (read-symbol/number c)
    (let ((s (read-symbol/number-string 1)))
      (string-set! s 0 (char-downcase c))
      (or (string->number s 10) (string->canonical-symbol s))))
  (define (read-prefixed-number c)
    (let ((s (read-symbol/number-string 2)))
      (string-set! s 0 #\#)
      (string-set! s 1 c)
      (string->number s 10)))
  (define (read-special-symbol)
    (let ((s (read-symbol/number-string 2)))
      (string-set! s 0 #\#)
      (string-set! s 1 #\#)
      (string->canonical-symbol s)))
  (define (rd c)
    (cond ((eof-object? c) c)
          ((< 0 (vector-ref read-table (char->integer c)))
           (rd (sf-read-char sf)))
          ((char=? c #\;)
           (let loop ()
             (let ((c (sf-read-char sf)))
               (cond ((eof-object? c) c)
                     ((char=? c char-newline) (rd (sf-read-char sf)))
                     (else (loop))))))
          (else (rd* c))))
  (define (rd* c)
    (let ((source (make-source #f (sf->locat sf))))
      (source-code-set!
       source
       (cond ((char=? c #\()
              (let ((x (read-non-whitespace-char)))
                (if (char=? x #\)) '() (read-list (rd* x)))))
             ((char=? c #\#)
              (let ((c (char-downcase (sf-read-char sf))))
                (cond ((char=? c #\() (read-vector))
                      ((char=? c #\f) false-object)
                      ((char=? c #\t) #t)
                      ((char=? c #\\)
                       (let ((c (read-char*)))
                         (if (or (not (char-alphabetic? c))
                                 (delimiter? (sf-peek-char sf)))
                             c
                             (let ((name (read-symbol/number c)))
                               (let ((x (assq name named-char-table)))
                                 (if x
                                     (cdr x)
                                     (sf-read-error
                                      sf
                                      "Unknown character name"
                                      name)))))))
                      ((char=? c #\#) (read-special-symbol))
                      (else
                       (let ((num (read-prefixed-number c)))
                         (or num
                             (sf-read-error
                              sf
                              "Unknown '#' read macro"
                              c)))))))
             ((char=? c #\") (read-string))
             ((char=? c #\')
              (list (make-source quote-sym (sf->locat sf)) (read-source sf)))
             ((char=? c #\`)
              (list (make-source quasiquote-sym (sf->locat sf))
                    (read-source sf)))
             ((char=? c #\,)
              (if (char=? (sf-peek-char sf) #\@)
                  (let ((x (make-source unquote-splicing-sym (sf->locat sf))))
                    (sf-read-char sf)
                    (list x (read-source sf)))
                  (list (make-source unquote-sym (sf->locat sf))
                        (read-source sf))))
             ((char=? c #\)) (sf-read-error sf "Misplaced ')'"))
             ((or (char=? c #\[) (char=? c #\]) (char=? c #\{) (char=? c #\}))
              (sf-read-error sf "Illegal character" c))
             (else
              (if (char=? c #\.)
                  (if (delimiter? (sf-peek-char sf))
                      (sf-read-error sf "Misplaced '.'")))
              (read-symbol/number c))))))
  (rd (sf-read-char sf)))
(define named-char-table
  (list (cons (string->canonical-symbol "NUL") char-nul)
        (cons (string->canonical-symbol "TAB") char-tab)
        (cons (string->canonical-symbol "NEWLINE") char-newline)
        (cons (string->canonical-symbol "SPACE") #\space)))
(define read-table
  (let ((rt (make-vector (+ max-character-encoding 1) 0)))
    (vector-set! rt (char->integer char-tab) 1)
    (vector-set! rt (char->integer char-newline) 1)
    (vector-set! rt (char->integer #\space) 1)
    (vector-set! rt (char->integer #\;) -1)
    (vector-set! rt (char->integer #\() -1)
    (vector-set! rt (char->integer #\)) -1)
    (vector-set! rt (char->integer #\") -1)
    (vector-set! rt (char->integer #\') -1)
    (vector-set! rt (char->integer #\`) -1)
    rt))
(define (make-var name bound refs sets source)
  (vector var-tag name bound refs sets source #f))
(define (var? x)
  (and (vector? x) (> (vector-length x) 0) (eq? (vector-ref x 0) var-tag)))
(define (var-name x) (vector-ref x 1))
(define (var-bound x) (vector-ref x 2))
(define (var-refs x) (vector-ref x 3))
(define (var-sets x) (vector-ref x 4))
(define (var-source x) (vector-ref x 5))
(define (var-info x) (vector-ref x 6))
(define (var-name-set! x y) (vector-set! x 1 y))
(define (var-bound-set! x y) (vector-set! x 2 y))
(define (var-refs-set! x y) (vector-set! x 3 y))
(define (var-sets-set! x y) (vector-set! x 4 y))
(define (var-source-set! x y) (vector-set! x 5 y))
(define (var-info-set! x y) (vector-set! x 6 y))
(define var-tag (list 'var-tag))
(define (var-copy var)
  (make-var (var-name var) #t (set-empty) (set-empty) (var-source var)))
(define (make-temp-var name) (make-var name #t (set-empty) (set-empty) #f))
(define (temp-var? var) (eq? (var-bound var) #t))
(define ret-var (make-temp-var 'ret))
(define ret-var-set (set-singleton ret-var))
(define closure-env-var (make-temp-var 'closure-env))
(define empty-var (make-temp-var #f))
(define make-global-environment #f)
(set! make-global-environment (lambda () (env-frame #f '())))
(define (env-frame env vars) (vector (cons vars #f) '() '() env))
(define (env-new-var! env name source)
  (let* ((glob (not (env-parent-ref env)))
         (var (make-var name (not glob) (set-empty) (set-empty) source)))
    (env-vars-set! env (cons var (env-vars-ref env)))
    var))
(define (env-macro env name def)
  (let ((name* (if (full-name? name)
                   name
                   (let ((prefix (env-namespace-prefix env name)))
                     (if prefix (make-full-name prefix name) name)))))
    (vector (vector-ref env 0)
            (cons (cons name* def) (env-macros-ref env))
            (env-decls-ref env)
            (env-parent-ref env))))
(define (env-declare env decl)
  (vector (vector-ref env 0)
          (env-macros-ref env)
          (cons decl (env-decls-ref env))
          (env-parent-ref env)))
(define (env-vars-ref env) (car (vector-ref env 0)))
(define (env-vars-set! env vars) (set-car! (vector-ref env 0) vars))
(define (env-macros-ref env) (vector-ref env 1))
(define (env-decls-ref env) (vector-ref env 2))
(define (env-parent-ref env) (vector-ref env 3))
(define (env-namespace-prefix env name)
  (let loop ((decls (env-decls-ref env)))
    (if (pair? decls)
        (let ((decl (car decls)))
          (if (eq? (car decl) namespace-sym)
              (let ((syms (cddr decl)))
                (if (or (null? syms) (memq name syms))
                    (cadr decl)
                    (loop (cdr decls))))
              (loop (cdr decls))))
        #f)))
(define (env-lookup env name stop-at-first-frame? proc)
  (define (search env name full?)
    (if full?
        (search* env name full?)
        (let ((prefix (env-namespace-prefix env name)))
          (if prefix
              (search* env (make-full-name prefix name) #t)
              (search* env name full?)))))
  (define (search* env name full?)
    (define (search-macros macros)
      (if (pair? macros)
          (let ((m (car macros)))
            (if (eq? (car m) name)
                (proc env name (cdr m))
                (search-macros (cdr macros))))
          (search-vars (env-vars-ref env))))
    (define (search-vars vars)
      (if (pair? vars)
          (let ((v (car vars)))
            (if (eq? (var-name v) name)
                (proc env name v)
                (search-vars (cdr vars))))
          (let ((env* (env-parent-ref env)))
            (if (or stop-at-first-frame? (not env*))
                (proc env name #f)
                (search env* name full?)))))
    (search-macros (env-macros-ref env)))
  (search env name (full-name? name)))
(define (valid-prefix? str)
  (let ((l (string-length str)))
    (or (= l 0) (and (>= l 2) (char=? (string-ref str (- l 1)) #\#)))))
(define (full-name? sym)
  (let ((str (symbol->string sym)))
    (let loop ((i (- (string-length str) 1)))
      (if (< i 0) #f (if (char=? (string-ref str i) #\#) #t (loop (- i 1)))))))
(define (make-full-name prefix sym)
  (if (= (string-length prefix) 0)
      sym
      (string->canonical-symbol (string-append prefix (symbol->string sym)))))
(define (env-lookup-var env name source)
  (env-lookup
   env
   name
   #f
   (lambda (env name x)
     (if x
         (if (var? x)
             x
             (compiler-internal-error
              "env-lookup-var, name is that of a macro"
              name))
         (env-new-var! env name source)))))
(define (env-define-var env name source)
  (env-lookup
   env
   name
   #t
   (lambda (env name x)
     (if x
         (if (var? x)
             (pt-syntax-error source "Duplicate definition of a variable")
             (compiler-internal-error
              "env-define-var, name is that of a macro"
              name))
         (env-new-var! env name source)))))
(define (env-lookup-global-var env name)
  (let ((env* (env-global-env env)))
    (define (search-vars vars)
      (if (pair? vars)
          (let ((v (car vars)))
            (if (eq? (var-name v) name) v (search-vars (cdr vars))))
          (env-new-var! env* name #f)))
    (search-vars (env-vars-ref env*))))
(define (env-global-variables env) (env-vars-ref (env-global-env env)))
(define (env-global-env env)
  (let loop ((env env))
    (let ((env* (env-parent-ref env))) (if env* (loop env*) env))))
(define (env-lookup-macro env name)
  (env-lookup
   env
   name
   #f
   (lambda (env name x) (if (or (not x) (var? x)) #f x))))
(define (env-declarations env) env)
(define flag-declarations '())
(define parameterized-declarations '())
(define boolean-declarations '())
(define namable-declarations '())
(define namable-boolean-declarations '())
(define namable-string-declarations '())
(define (define-flag-decl name type)
  (set! flag-declarations (cons (cons name type) flag-declarations))
  '())
(define (define-parameterized-decl name)
  (set! parameterized-declarations (cons name parameterized-declarations))
  '())
(define (define-boolean-decl name)
  (set! boolean-declarations (cons name boolean-declarations))
  '())
(define (define-namable-decl name type)
  (set! namable-declarations (cons (cons name type) namable-declarations))
  '())
(define (define-namable-boolean-decl name)
  (set! namable-boolean-declarations (cons name namable-boolean-declarations))
  '())
(define (define-namable-string-decl name)
  (set! namable-string-declarations (cons name namable-string-declarations))
  '())
(define (flag-decl source type val) (list type val))
(define (parameterized-decl source id parm) (list id parm))
(define (boolean-decl source id pos) (list id pos))
(define (namable-decl source type val names) (cons type (cons val names)))
(define (namable-boolean-decl source id pos names) (cons id (cons pos names)))
(define (namable-string-decl source id str names)
  (if (and (eq? id namespace-sym) (not (valid-prefix? str)))
      (pt-syntax-error source "Illegal namespace"))
  (cons id (cons str names)))
(define (declaration-value name element default decls)
  (if (not decls)
      default
      (let loop ((l (env-decls-ref decls)))
        (if (pair? l)
            (let ((d (car l)))
              (if (and (eq? (car d) name)
                       (or (null? (cddr d)) (memq element (cddr d))))
                  (cadr d)
                  (loop (cdr l))))
            (declaration-value name element default (env-parent-ref decls))))))
(define namespace-sym (string->canonical-symbol "NAMESPACE"))
(define-namable-string-decl namespace-sym)
(define (node-parent x) (vector-ref x 1))
(define (node-children x) (vector-ref x 2))
(define (node-fv x) (vector-ref x 3))
(define (node-decl x) (vector-ref x 4))
(define (node-source x) (vector-ref x 5))
(define (node-parent-set! x y) (vector-set! x 1 y))
(define (node-fv-set! x y) (vector-set! x 3 y))
(define (node-decl-set! x y) (vector-set! x 4 y))
(define (node-source-set! x y) (vector-set! x 5 y))
(define (node-children-set! x y)
  (vector-set! x 2 y)
  (for-each (lambda (child) (node-parent-set! child x)) y)
  (node-fv-invalidate! x))
(define (node-fv-invalidate! x)
  (let loop ((node x))
    (if node (begin (node-fv-set! node #t) (loop (node-parent node))))))
(define (make-cst parent children fv decl source val)
  (vector cst-tag parent children fv decl source val))
(define (cst? x)
  (and (vector? x) (> (vector-length x) 0) (eq? (vector-ref x 0) cst-tag)))
(define (cst-val x) (vector-ref x 6))
(define (cst-val-set! x y) (vector-set! x 6 y))
(define cst-tag (list 'cst-tag))
(define (make-ref parent children fv decl source var)
  (vector ref-tag parent children fv decl source var))
(define (ref? x)
  (and (vector? x) (> (vector-length x) 0) (eq? (vector-ref x 0) ref-tag)))
(define (ref-var x) (vector-ref x 6))
(define (ref-var-set! x y) (vector-set! x 6 y))
(define ref-tag (list 'ref-tag))
(define (make-set parent children fv decl source var)
  (vector set-tag parent children fv decl source var))
(define (set? x)
  (and (vector? x) (> (vector-length x) 0) (eq? (vector-ref x 0) set-tag)))
(define (set-var x) (vector-ref x 6))
(define (set-var-set! x y) (vector-set! x 6 y))
(define set-tag (list 'set-tag))
(define (make-def parent children fv decl source var)
  (vector def-tag parent children fv decl source var))
(define (def? x)
  (and (vector? x) (> (vector-length x) 0) (eq? (vector-ref x 0) def-tag)))
(define (def-var x) (vector-ref x 6))
(define (def-var-set! x y) (vector-set! x 6 y))
(define def-tag (list 'def-tag))
(define (make-tst parent children fv decl source)
  (vector tst-tag parent children fv decl source))
(define (tst? x)
  (and (vector? x) (> (vector-length x) 0) (eq? (vector-ref x 0) tst-tag)))
(define tst-tag (list 'tst-tag))
(define (make-conj parent children fv decl source)
  (vector conj-tag parent children fv decl source))
(define (conj? x)
  (and (vector? x) (> (vector-length x) 0) (eq? (vector-ref x 0) conj-tag)))
(define conj-tag (list 'conj-tag))
(define (make-disj parent children fv decl source)
  (vector disj-tag parent children fv decl source))
(define (disj? x)
  (and (vector? x) (> (vector-length x) 0) (eq? (vector-ref x 0) disj-tag)))
(define disj-tag (list 'disj-tag))
(define (make-prc parent children fv decl source name min rest parms)
  (vector prc-tag parent children fv decl source name min rest parms))
(define (prc? x)
  (and (vector? x) (> (vector-length x) 0) (eq? (vector-ref x 0) prc-tag)))
(define (prc-name x) (vector-ref x 6))
(define (prc-min x) (vector-ref x 7))
(define (prc-rest x) (vector-ref x 8))
(define (prc-parms x) (vector-ref x 9))
(define (prc-name-set! x y) (vector-set! x 6 y))
(define (prc-min-set! x y) (vector-set! x 7 y))
(define (prc-rest-set! x y) (vector-set! x 8 y))
(define (prc-parms-set! x y) (vector-set! x 9 y))
(define prc-tag (list 'prc-tag))
(define (make-app parent children fv decl source)
  (vector app-tag parent children fv decl source))
(define (app? x)
  (and (vector? x) (> (vector-length x) 0) (eq? (vector-ref x 0) app-tag)))
(define app-tag (list 'app-tag))
(define (make-fut parent children fv decl source)
  (vector fut-tag parent children fv decl source))
(define (fut? x)
  (and (vector? x) (> (vector-length x) 0) (eq? (vector-ref x 0) fut-tag)))
(define fut-tag (list 'fut-tag))
(define (new-cst source decl val) (make-cst #f '() #t decl source val))
(define (new-ref source decl var)
  (let ((node (make-ref #f '() #t decl source var)))
    (var-refs-set! var (set-adjoin (var-refs var) node))
    node))
(define (new-ref-extended-bindings source name env)
  (new-ref source
           (add-extended-bindings (env-declarations env))
           (env-lookup-global-var env name)))
(define (new-set source decl var val)
  (let ((node (make-set #f (list val) #t decl source var)))
    (var-sets-set! var (set-adjoin (var-sets var) node))
    (node-parent-set! val node)
    node))
(define (set-val x)
  (if (set? x)
      (car (node-children x))
      (compiler-internal-error "set-val, 'set' node expected" x)))
(define (new-def source decl var val)
  (let ((node (make-def #f (list val) #t decl source var)))
    (var-sets-set! var (set-adjoin (var-sets var) node))
    (node-parent-set! val node)
    node))
(define (def-val x)
  (if (def? x)
      (car (node-children x))
      (compiler-internal-error "def-val, 'def' node expected" x)))
(define (new-tst source decl pre con alt)
  (let ((node (make-tst #f (list pre con alt) #t decl source)))
    (node-parent-set! pre node)
    (node-parent-set! con node)
    (node-parent-set! alt node)
    node))
(define (tst-pre x)
  (if (tst? x)
      (car (node-children x))
      (compiler-internal-error "tst-pre, 'tst' node expected" x)))
(define (tst-con x)
  (if (tst? x)
      (cadr (node-children x))
      (compiler-internal-error "tst-con, 'tst' node expected" x)))
(define (tst-alt x)
  (if (tst? x)
      (caddr (node-children x))
      (compiler-internal-error "tst-alt, 'tst' node expected" x)))
(define (new-conj source decl pre alt)
  (let ((node (make-conj #f (list pre alt) #t decl source)))
    (node-parent-set! pre node)
    (node-parent-set! alt node)
    node))
(define (conj-pre x)
  (if (conj? x)
      (car (node-children x))
      (compiler-internal-error "conj-pre, 'conj' node expected" x)))
(define (conj-alt x)
  (if (conj? x)
      (cadr (node-children x))
      (compiler-internal-error "conj-alt, 'conj' node expected" x)))
(define (new-disj source decl pre alt)
  (let ((node (make-disj #f (list pre alt) #t decl source)))
    (node-parent-set! pre node)
    (node-parent-set! alt node)
    node))
(define (disj-pre x)
  (if (disj? x)
      (car (node-children x))
      (compiler-internal-error "disj-pre, 'disj' node expected" x)))
(define (disj-alt x)
  (if (disj? x)
      (cadr (node-children x))
      (compiler-internal-error "disj-alt, 'disj' node expected" x)))
(define (new-prc source decl name min rest parms body)
  (let ((node (make-prc #f (list body) #t decl source name min rest parms)))
    (for-each (lambda (x) (var-bound-set! x node)) parms)
    (node-parent-set! body node)
    node))
(define (prc-body x)
  (if (prc? x)
      (car (node-children x))
      (compiler-internal-error "prc-body, 'proc' node expected" x)))
(define (new-call source decl oper args)
  (let ((node (make-app #f (cons oper args) #t decl source)))
    (node-parent-set! oper node)
    (for-each (lambda (x) (node-parent-set! x node)) args)
    node))
(define (new-call* source decl oper args)
  (if *ptree-port*
      (if (ref? oper)
          (let ((var (ref-var oper)))
            (if (global? var)
                (let ((proc (standard-procedure
                             (var-name var)
                             (node-decl oper))))
                  (if (and proc
                           (not (nb-args-conforms?
                                 (length args)
                                 (standard-procedure-call-pattern proc))))
                      (begin
                        (display "*** WARNING -- \"" *ptree-port*)
                        (display (var-name var) *ptree-port*)
                        (display "\" is called with " *ptree-port*)
                        (display (length args) *ptree-port*)
                        (display " argument(s)." *ptree-port*)
                        (newline *ptree-port*))))))))
  (new-call source decl oper args))
(define (app-oper x)
  (if (app? x)
      (car (node-children x))
      (compiler-internal-error "app-oper, 'call' node expected" x)))
(define (app-args x)
  (if (app? x)
      (cdr (node-children x))
      (compiler-internal-error "app-args, 'call' node expected" x)))
(define (oper-pos? node)
  (let ((parent (node-parent node)))
    (if parent (and (app? parent) (eq? (app-oper parent) node)) #f)))
(define (new-fut source decl val)
  (let ((node (make-fut #f (list val) #t decl source)))
    (node-parent-set! val node)
    node))
(define (fut-val x)
  (if (fut? x)
      (car (node-children x))
      (compiler-internal-error "fut-val, 'fut' node expected" x)))
(define (new-disj-call source decl pre oper alt)
  (new-call*
   source
   decl
   (let* ((parms (new-temps source '(temp))) (temp (car parms)))
     (new-prc source
              decl
              #f
              1
              #f
              parms
              (new-tst source
                       decl
                       (new-ref source decl temp)
                       (new-call*
                        source
                        decl
                        oper
                        (list (new-ref source decl temp)))
                       alt)))
   (list pre)))
(define (new-seq source decl before after)
  (new-call*
   source
   decl
   (new-prc source decl #f 1 #f (new-temps source '(temp)) after)
   (list before)))
(define (new-let ptree proc vars vals body)
  (if (pair? vars)
      (new-call
       (node-source ptree)
       (node-decl ptree)
       (new-prc (node-source proc)
                (node-decl proc)
                (prc-name proc)
                (length vars)
                #f
                (reverse vars)
                body)
       (reverse vals))
      body))
(define (new-temps source names)
  (if (null? names)
      '()
      (cons (make-var (car names) #t (set-empty) (set-empty) source)
            (new-temps source (cdr names)))))
(define (new-variables vars)
  (if (null? vars)
      '()
      (cons (make-var
             (source-code (car vars))
             #t
             (set-empty)
             (set-empty)
             (car vars))
            (new-variables (cdr vars)))))
(define (set-prc-names! vars vals)
  (let loop ((vars vars) (vals vals))
    (if (not (null? vars))
        (let ((var (car vars)) (val (car vals)))
          (if (prc? val) (prc-name-set! val (symbol->string (var-name var))))
          (loop (cdr vars) (cdr vals))))))
(define (free-variables node)
  (if (eq? (node-fv node) #t)
      (let ((x (apply set-union (map free-variables (node-children node)))))
        (node-fv-set!
         node
         (cond ((ref? node)
                (if (global? (ref-var node)) x (set-adjoin x (ref-var node))))
               ((set? node)
                (if (global? (set-var node)) x (set-adjoin x (set-var node))))
               ((prc? node) (set-difference x (list->set (prc-parms node))))
               ((and (app? node) (prc? (app-oper node)))
                (set-difference x (list->set (prc-parms (app-oper node)))))
               (else x)))))
  (node-fv node))
(define (bound-variables node) (list->set (prc-parms node)))
(define (not-mutable? var) (set-empty? (var-sets var)))
(define (mutable? var) (not (not-mutable? var)))
(define (bound? var) (var-bound var))
(define (global? var) (not (bound? var)))
(define (global-val var)
  (and (global? var)
       (let ((sets (set->list (var-sets var))))
         (and (pair? sets)
              (null? (cdr sets))
              (def? (car sets))
              (eq? (compilation-strategy (node-decl (car sets))) block-sym)
              (def-val (car sets))))))
(define **not-sym (string->canonical-symbol "##NOT"))
(define **quasi-append-sym (string->canonical-symbol "##QUASI-APPEND"))
(define **quasi-list-sym (string->canonical-symbol "##QUASI-LIST"))
(define **quasi-cons-sym (string->canonical-symbol "##QUASI-CONS"))
(define **quasi-list->vector-sym
  (string->canonical-symbol "##QUASI-LIST->VECTOR"))
(define **case-memv-sym (string->canonical-symbol "##CASE-MEMV"))
(define **unassigned?-sym (string->canonical-symbol "##UNASSIGNED?"))
(define **make-cell-sym (string->canonical-symbol "##MAKE-CELL"))
(define **cell-ref-sym (string->canonical-symbol "##CELL-REF"))
(define **cell-set!-sym (string->canonical-symbol "##CELL-SET!"))
(define **make-placeholder-sym (string->canonical-symbol "##MAKE-PLACEHOLDER"))
(define ieee-scheme-sym (string->canonical-symbol "IEEE-SCHEME"))
(define r4rs-scheme-sym (string->canonical-symbol "R4RS-SCHEME"))
(define multilisp-sym (string->canonical-symbol "MULTILISP"))
(define lambda-lift-sym (string->canonical-symbol "LAMBDA-LIFT"))
(define block-sym (string->canonical-symbol "BLOCK"))
(define separate-sym (string->canonical-symbol "SEPARATE"))
(define standard-bindings-sym (string->canonical-symbol "STANDARD-BINDINGS"))
(define extended-bindings-sym (string->canonical-symbol "EXTENDED-BINDINGS"))
(define safe-sym (string->canonical-symbol "SAFE"))
(define interrupts-enabled-sym (string->canonical-symbol "INTERRUPTS-ENABLED"))
(define-flag-decl ieee-scheme-sym 'dialect)
(define-flag-decl r4rs-scheme-sym 'dialect)
(define-flag-decl multilisp-sym 'dialect)
(define-boolean-decl lambda-lift-sym)
(define-flag-decl block-sym 'compilation-strategy)
(define-flag-decl separate-sym 'compilation-strategy)
(define-namable-boolean-decl standard-bindings-sym)
(define-namable-boolean-decl extended-bindings-sym)
(define-boolean-decl safe-sym)
(define-boolean-decl interrupts-enabled-sym)
(define (scheme-dialect decl)
  (declaration-value 'dialect #f ieee-scheme-sym decl))
(define (lambda-lift? decl) (declaration-value lambda-lift-sym #f #t decl))
(define (compilation-strategy decl)
  (declaration-value 'compilation-strategy #f separate-sym decl))
(define (standard-binding? name decl)
  (declaration-value standard-bindings-sym name #f decl))
(define (extended-binding? name decl)
  (declaration-value extended-bindings-sym name #f decl))
(define (add-extended-bindings decl)
  (add-decl (list extended-bindings-sym #t) decl))
(define (intrs-enabled? decl)
  (declaration-value interrupts-enabled-sym #f #t decl))
(define (add-not-interrupts-enabled decl)
  (add-decl (list interrupts-enabled-sym #f) decl))
(define (safe? decl) (declaration-value safe-sym #f #f decl))
(define (add-not-safe decl) (add-decl (list safe-sym #f) decl))
(define (dialect-specific-keywords dialect)
  (cond ((eq? dialect ieee-scheme-sym) ieee-scheme-specific-keywords)
        ((eq? dialect r4rs-scheme-sym) r4rs-scheme-specific-keywords)
        ((eq? dialect multilisp-sym) multilisp-specific-keywords)
        (else
         (compiler-internal-error
          "dialect-specific-keywords, unknown dialect"
          dialect))))
(define (dialect-specific-procedures dialect)
  (cond ((eq? dialect ieee-scheme-sym) ieee-scheme-specific-procedures)
        ((eq? dialect r4rs-scheme-sym) r4rs-scheme-specific-procedures)
        ((eq? dialect multilisp-sym) multilisp-specific-procedures)
        (else
         (compiler-internal-error
          "dialect-specific-procedures, unknown dialect"
          dialect))))
(define (make-standard-procedure x)
  (cons (string->canonical-symbol (car x)) (cdr x)))
(define (standard-procedure name decl)
  (or (assq name (dialect-specific-procedures (scheme-dialect decl)))
      (assq name common-procedures)))
(define (standard-procedure-call-pattern proc) (cdr proc))
(define ieee-scheme-specific-keywords '())
(define ieee-scheme-specific-procedures (map make-standard-procedure '()))
(define r4rs-scheme-specific-keywords (list delay-sym))
(define r4rs-scheme-specific-procedures
  (map make-standard-procedure
       '(("LIST-TAIL" 2)
         ("-" . 1)
         ("/" . 1)
         ("STRING->LIST" 1)
         ("LIST->STRING" 1)
         ("STRING-COPY" 1)
         ("STRING-FILL!" 2)
         ("VECTOR->LIST" 1)
         ("LIST->VECTOR" 1)
         ("VECTOR-FILL!" 2)
         ("FORCE" 1)
         ("WITH-INPUT-FROM-FILE" 2)
         ("WITH-OUTPUT-TO-FILE" 2)
         ("CHAR-READY?" 0 1)
         ("LOAD" 1)
         ("TRANSCRIPT-ON" 1)
         ("TRANSCRIPT-OFF" 0))))
(define multilisp-specific-keywords (list delay-sym future-sym))
(define multilisp-specific-procedures
  (map make-standard-procedure '(("FORCE" 1) ("TOUCH" 1))))
(define common-keywords
  (list quote-sym
        quasiquote-sym
        unquote-sym
        unquote-splicing-sym
        lambda-sym
        if-sym
        set!-sym
        cond-sym
        =>-sym
        else-sym
        and-sym
        or-sym
        case-sym
        let-sym
        let*-sym
        letrec-sym
        begin-sym
        do-sym
        define-sym
        **define-macro-sym
        **declare-sym
        **include-sym))
(define common-procedures
  (map make-standard-procedure
       '(("NOT" 1)
         ("BOOLEAN?" 1)
         ("EQV?" 2)
         ("EQ?" 2)
         ("EQUAL?" 2)
         ("PAIR?" 1)
         ("CONS" 2)
         ("CAR" 1)
         ("CDR" 1)
         ("SET-CAR!" 2)
         ("SET-CDR!" 2)
         ("CAAR" 1)
         ("CADR" 1)
         ("CDAR" 1)
         ("CDDR" 1)
         ("CAAAR" 1)
         ("CAADR" 1)
         ("CADAR" 1)
         ("CADDR" 1)
         ("CDAAR" 1)
         ("CDADR" 1)
         ("CDDAR" 1)
         ("CDDDR" 1)
         ("CAAAAR" 1)
         ("CAAADR" 1)
         ("CAADAR" 1)
         ("CAADDR" 1)
         ("CADAAR" 1)
         ("CADADR" 1)
         ("CADDAR" 1)
         ("CADDDR" 1)
         ("CDAAAR" 1)
         ("CDAADR" 1)
         ("CDADAR" 1)
         ("CDADDR" 1)
         ("CDDAAR" 1)
         ("CDDADR" 1)
         ("CDDDAR" 1)
         ("CDDDDR" 1)
         ("NULL?" 1)
         ("LIST?" 1)
         ("LIST" . 0)
         ("LENGTH" 1)
         ("APPEND" . 0)
         ("REVERSE" 1)
         ("LIST-REF" 2)
         ("MEMQ" 2)
         ("MEMV" 2)
         ("MEMBER" 2)
         ("ASSQ" 2)
         ("ASSV" 2)
         ("ASSOC" 2)
         ("SYMBOL?" 1)
         ("SYMBOL->STRING" 1)
         ("STRING->SYMBOL" 1)
         ("NUMBER?" 1)
         ("COMPLEX?" 1)
         ("REAL?" 1)
         ("RATIONAL?" 1)
         ("INTEGER?" 1)
         ("EXACT?" 1)
         ("INEXACT?" 1)
         ("=" . 2)
         ("<" . 2)
         (">" . 2)
         ("<=" . 2)
         (">=" . 2)
         ("ZERO?" 1)
         ("POSITIVE?" 1)
         ("NEGATIVE?" 1)
         ("ODD?" 1)
         ("EVEN?" 1)
         ("MAX" . 1)
         ("MIN" . 1)
         ("+" . 0)
         ("*" . 0)
         ("-" 1 2)
         ("/" 1 2)
         ("ABS" 1)
         ("QUOTIENT" 2)
         ("REMAINDER" 2)
         ("MODULO" 2)
         ("GCD" . 0)
         ("LCM" . 0)
         ("NUMERATOR" 1)
         ("DENOMINATOR" 1)
         ("FLOOR" 1)
         ("CEILING" 1)
         ("TRUNCATE" 1)
         ("ROUND" 1)
         ("RATIONALIZE" 2)
         ("EXP" 1)
         ("LOG" 1)
         ("SIN" 1)
         ("COS" 1)
         ("TAN" 1)
         ("ASIN" 1)
         ("ACOS" 1)
         ("ATAN" 1 2)
         ("SQRT" 1)
         ("EXPT" 2)
         ("MAKE-RECTANGULAR" 2)
         ("MAKE-POLAR" 2)
         ("REAL-PART" 1)
         ("IMAG-PART" 1)
         ("MAGNITUDE" 1)
         ("ANGLE" 1)
         ("EXACT->INEXACT" 1)
         ("INEXACT->EXACT" 1)
         ("NUMBER->STRING" 1 2)
         ("STRING->NUMBER" 1 2)
         ("CHAR?" 1)
         ("CHAR=?" 2)
         ("CHAR<?" 2)
         ("CHAR>?" 2)
         ("CHAR<=?" 2)
         ("CHAR>=?" 2)
         ("CHAR-CI=?" 2)
         ("CHAR-CI<?" 2)
         ("CHAR-CI>?" 2)
         ("CHAR-CI<=?" 2)
         ("CHAR-CI>=?" 2)
         ("CHAR-ALPHABETIC?" 1)
         ("CHAR-NUMERIC?" 1)
         ("CHAR-WHITESPACE?" 1)
         ("CHAR-UPPER-CASE?" 1)
         ("CHAR-LOWER-CASE?" 1)
         ("CHAR->INTEGER" 1)
         ("INTEGER->CHAR" 1)
         ("CHAR-UPCASE" 1)
         ("CHAR-DOWNCASE" 1)
         ("STRING?" 1)
         ("MAKE-STRING" 1 2)
         ("STRING" . 0)
         ("STRING-LENGTH" 1)
         ("STRING-REF" 2)
         ("STRING-SET!" 3)
         ("STRING=?" 2)
         ("STRING<?" 2)
         ("STRING>?" 2)
         ("STRING<=?" 2)
         ("STRING>=?" 2)
         ("STRING-CI=?" 2)
         ("STRING-CI<?" 2)
         ("STRING-CI>?" 2)
         ("STRING-CI<=?" 2)
         ("STRING-CI>=?" 2)
         ("SUBSTRING" 3)
         ("STRING-APPEND" . 0)
         ("VECTOR?" 1)
         ("MAKE-VECTOR" 1 2)
         ("VECTOR" . 0)
         ("VECTOR-LENGTH" 1)
         ("VECTOR-REF" 2)
         ("VECTOR-SET!" 3)
         ("PROCEDURE?" 1)
         ("APPLY" . 2)
         ("MAP" . 2)
         ("FOR-EACH" . 2)
         ("CALL-WITH-CURRENT-CONTINUATION" 1)
         ("CALL-WITH-INPUT-FILE" 2)
         ("CALL-WITH-OUTPUT-FILE" 2)
         ("INPUT-PORT?" 1)
         ("OUTPUT-PORT?" 1)
         ("CURRENT-INPUT-PORT" 0)
         ("CURRENT-OUTPUT-PORT" 0)
         ("OPEN-INPUT-FILE" 1)
         ("OPEN-OUTPUT-FILE" 1)
         ("CLOSE-INPUT-PORT" 1)
         ("CLOSE-OUTPUT-PORT" 1)
         ("EOF-OBJECT?" 1)
         ("READ" 0 1)
         ("READ-CHAR" 0 1)
         ("PEEK-CHAR" 0 1)
         ("WRITE" 1 2)
         ("DISPLAY" 1 2)
         ("NEWLINE" 0 1)
         ("WRITE-CHAR" 1 2))))
(define (parse-program program env module-name proc)
  (define (parse-prog program env lst proc)
    (if (null? program)
        (proc (reverse lst) env)
        (let ((source (car program)))
          (cond ((macro-expr? source env)
                 (parse-prog
                  (cons (macro-expand source env) (cdr program))
                  env
                  lst
                  proc))
                ((begin-defs-expr? source)
                 (parse-prog
                  (append (begin-defs-body source) (cdr program))
                  env
                  lst
                  proc))
                ((include-expr? source)
                 (if *ptree-port* (display "  " *ptree-port*))
                 (let ((x (file->sources*
                           (include-filename source)
                           *ptree-port*
                           (source-locat source))))
                   (if *ptree-port* (newline *ptree-port*))
                   (parse-prog (append x (cdr program)) env lst proc)))
                ((define-macro-expr? source env)
                 (if *ptree-port*
                     (begin
                       (display "  \"macro\"" *ptree-port*)
                       (newline *ptree-port*)))
                 (parse-prog (cdr program) (add-macro source env) lst proc))
                ((declare-expr? source)
                 (if *ptree-port*
                     (begin
                       (display "  \"decl\"" *ptree-port*)
                       (newline *ptree-port*)))
                 (parse-prog
                  (cdr program)
                  (add-declarations source env)
                  lst
                  proc))
                ((define-expr? source env)
                 (let* ((var** (definition-variable source))
                        (var* (source-code var**))
                        (var (env-lookup-var env var* var**)))
                   (if *ptree-port*
                       (begin
                         (display "  " *ptree-port*)
                         (display (var-name var) *ptree-port*)
                         (newline *ptree-port*)))
                   (let ((node (pt (definition-value source) env 'true)))
                     (set-prc-names! (list var) (list node))
                     (parse-prog
                      (cdr program)
                      env
                      (cons (cons (new-def source
                                           (env-declarations env)
                                           var
                                           node)
                                  env)
                            lst)
                      proc))))
                ((c-declaration-expr? source)
                 (if *ptree-port*
                     (begin
                       (display "  \"c-decl\"" *ptree-port*)
                       (newline *ptree-port*)))
                 (add-c-declaration (source-code (cadr (source-code source))))
                 (parse-prog (cdr program) env lst proc))
                ((c-init-expr? source)
                 (if *ptree-port*
                     (begin
                       (display "  \"c-init\"" *ptree-port*)
                       (newline *ptree-port*)))
                 (add-c-init (source-code (cadr (source-code source))))
                 (parse-prog (cdr program) env lst proc))
                (else
                 (if *ptree-port*
                     (begin
                       (display "  \"expr\"" *ptree-port*)
                       (newline *ptree-port*)))
                 (parse-prog
                  (cdr program)
                  env
                  (cons (cons (pt source env 'true) env) lst)
                  proc))))))
  (if *ptree-port*
      (begin (display "Parsing:" *ptree-port*) (newline *ptree-port*)))
  (c-interface-begin module-name)
  (parse-prog
   program
   env
   '()
   (lambda (lst env)
     (if *ptree-port* (newline *ptree-port*))
     (proc lst env (c-interface-end)))))
(define (c-interface-begin module-name)
  (set! c-interface-module-name module-name)
  (set! c-interface-proc-count 0)
  (set! c-interface-decls '())
  (set! c-interface-procs '())
  (set! c-interface-inits '())
  #f)
(define (c-interface-end)
  (let ((i (make-c-intf
            (reverse c-interface-decls)
            (reverse c-interface-procs)
            (reverse c-interface-inits))))
    (set! c-interface-module-name #f)
    (set! c-interface-proc-count #f)
    (set! c-interface-decls #f)
    (set! c-interface-procs #f)
    (set! c-interface-inits #f)
    i))
(define c-interface-module-name #f)
(define c-interface-proc-count #f)
(define c-interface-decls #f)
(define c-interface-procs #f)
(define c-interface-inits #f)
(define (make-c-intf decls procs inits) (vector decls procs inits))
(define (c-intf-decls c-intf) (vector-ref c-intf 0))
(define (c-intf-decls-set! c-intf x) (vector-set! c-intf 0 x))
(define (c-intf-procs c-intf) (vector-ref c-intf 1))
(define (c-intf-procs-set! c-intf x) (vector-set! c-intf 1 x))
(define (c-intf-inits c-intf) (vector-ref c-intf 2))
(define (c-intf-inits-set! c-intf x) (vector-set! c-intf 2 x))
(define (c-declaration-expr? source)
  (and (mymatch **c-declaration-sym 1 source)
       (let ((code (source-code source)))
         (or (string? (source-code (cadr code)))
             (pt-syntax-error
              source
              "Argument to '##c-declaration' must be a string")))))
(define (c-init-expr? source)
  (and (mymatch **c-init-sym 1 source)
       (let ((code (source-code source)))
         (or (string? (source-code (cadr code)))
             (pt-syntax-error
              source
              "Argument to '##c-init' must be a string")))))
(define (c-procedure-expr? source)
  (and (mymatch **c-procedure-sym 3 source)
       (let ((code (source-code source)))
         (if (not (string? (source-code (cadddr code))))
             (pt-syntax-error
              source
              "Last argument to '##c-procedure' must be a string")
             (check-arg-and-result-types source (cadr code) (caddr code))))))
(define scheme-to-c-notation
  (list (list void-sym "VOID" "void")
        (list char-sym "CHAR" "char")
        (list signed-char-sym "SCHAR" "signed char")
        (list unsigned-char-sym "UCHAR" "unsigned char")
        (list short-sym "SHORT" "short")
        (list unsigned-short-sym "USHORT" "unsigned short")
        (list int-sym "INT" "int")
        (list unsigned-int-sym "UINT" "unsigned int")
        (list long-sym "LONG" "long")
        (list unsigned-long-sym "ULONG" "unsigned long")
        (list float-sym "FLOAT" "float")
        (list double-sym "DOUBLE" "double")
        (list pointer-sym "POINTER" "void*")
        (list boolean-sym "BOOLEAN" "int")
        (list string-sym "STRING" "char*")
        (list scheme-object-sym "SCMOBJ" "long")))
(define (convert-type typ) (if (assq typ scheme-to-c-notation) typ #f))
(define (check-arg-and-result-types source arg-typs-source res-typ-source)
  (let ((arg-typs (source-code arg-typs-source))
        (res-typ (source-code res-typ-source)))
    (let ((res-type (convert-type res-typ)))
      (if (not res-type)
          (pt-syntax-error res-typ-source "Invalid result type")
          (if (not (proper-length arg-typs))
              (pt-syntax-error
               arg-typs-source
               "Ill-terminated argument type list")
              (let loop ((lst arg-typs))
                (if (pair? lst)
                    (let* ((arg-typ (source-code (car lst)))
                           (arg-type (convert-type arg-typ)))
                      (if (or (not arg-type) (eq? arg-type void-sym))
                          (pt-syntax-error (car lst) "Invalid argument type")
                          (loop (cdr lst))))
                    #t)))))))
(define (add-c-declaration declaration-string)
  (set! c-interface-decls (cons declaration-string c-interface-decls))
  #f)
(define (add-c-init initialization-code-string)
  (set! c-interface-inits (cons initialization-code-string c-interface-inits))
  #f)
(define (add-c-proc scheme-name c-name arity def)
  (set! c-interface-procs
        (cons (vector scheme-name c-name arity def) c-interface-procs))
  #f)
(define (pt-c-procedure source env use)
  (let* ((code (source-code source))
         (name (build-c-procedure
                (map source-code (source-code (cadr code)))
                (source-code (caddr code))
                (source-code (cadddr code))))
         (decl (env-declarations env)))
    (new-ref source decl (env-lookup-global-var env (string->symbol name)))))
(define (build-c-procedure argument-types result-type proc-name-or-code)
  (define proc-name?
    (let loop ((i (- (string-length proc-name-or-code) 1)))
      (if (>= i 0)
          (let ((c (string-ref proc-name-or-code i)))
            (if (or (char-alphabetic? c) (char=? c #\_)) (loop (- i 1)) #f))
          #t)))
  (define nl (string #\newline))
  (define undefined-value "UND")
  (define scheme-arg-prefix "ARG")
  (define scheme-result-name "RESULT")
  (define c-arg-prefix "arg")
  (define c-result-name "result")
  (define scheme-to-c-prefix "SCMOBJ_TO_")
  (define c-to-scheme-suffix "_TO_SCMOBJ")
  (define (c-type-name typ) (cadr (assq typ scheme-to-c-notation)))
  (define (c-type-decl typ) (caddr (assq typ scheme-to-c-notation)))
  (define (listify strings)
    (if (null? strings)
        ""
        (string-append
         (car strings)
         (apply string-append
                (map (lambda (s) (string-append "," s)) (cdr strings))))))
  (define (scheme-arg-var t)
    (string-append c-id-prefix scheme-arg-prefix (number->string (cdr t))))
  (define (c-arg-var t)
    (string-append c-id-prefix c-arg-prefix (number->string (cdr t))))
  (define (make-c-procedure arg-types res-type)
    (define (make-arg-decl)
      (apply string-append
             (map (lambda (t)
                    (string-append
                     (c-type-decl (car t))
                     " "
                     (c-arg-var t)
                     ";"
                     nl))
                  arg-types)))
    (define (make-conversions)
      (if (not (null? arg-types))
          (let loop ((lst arg-types) (str (string-append "if (" nl)))
            (if (null? lst)
                (string-append str "   )" nl)
                (let ((t (car lst)) (rest (cdr lst)))
                  (loop rest
                        (string-append
                         str
                         "    "
                         c-id-prefix
                         scheme-to-c-prefix
                         (c-type-name (car t))
                         "("
                         (scheme-arg-var t)
                         ","
                         (c-arg-var t)
                         ")"
                         (if (null? rest) "" " &&")
                         nl)))))
          ""))
    (define (make-body)
      (if proc-name?
          (let* ((param-list (listify (map c-arg-var arg-types)))
                 (call (string-append proc-name-or-code "(" param-list ")")))
            (if (eq? res-type void-sym)
                (string-append
                 "{"
                 nl
                 call
                 ";"
                 nl
                 c-id-prefix
                 scheme-result-name
                 " = "
                 c-id-prefix
                 undefined-value
                 ";"
                 nl
                 "}"
                 nl)
                (string-append
                 c-id-prefix
                 (c-type-name res-type)
                 c-to-scheme-suffix
                 "("
                 call
                 ","
                 c-id-prefix
                 scheme-result-name
                 ");"
                 nl)))
          (if (eq? res-type void-sym)
              (string-append
               "{"
               nl
               proc-name-or-code
               nl
               c-id-prefix
               scheme-result-name
               " = "
               c-id-prefix
               undefined-value
               ";"
               nl
               "}"
               nl)
              (string-append
               "{"
               nl
               proc-name-or-code
               nl
               c-id-prefix
               (c-type-name res-type)
               c-to-scheme-suffix
               "("
               c-id-prefix
               c-result-name
               ","
               c-id-prefix
               scheme-result-name
               ");"
               nl
               "}"
               nl))))
    (let* ((index (number->string c-interface-proc-count))
           (scheme-name (string-append "#!" c-interface-module-name "#" index))
           (c-name (string-append c-id-prefix (scheme-id->c-id scheme-name)))
           (arity (length argument-types))
           (def (string-append
                 (if (or proc-name? (eq? res-type void-sym))
                     ""
                     (string-append
                      (c-type-decl res-type)
                      " "
                      c-id-prefix
                      c-result-name
                      ";"
                      nl))
                 (make-arg-decl)
                 (make-conversions)
                 (make-body))))
      (set! c-interface-proc-count (+ c-interface-proc-count 1))
      (add-c-proc scheme-name c-name arity def)
      scheme-name))
  (let loop ((i 1) (lst1 argument-types) (lst2 '()))
    (if (pair? lst1)
        (loop (+ i 1) (cdr lst1) (cons (cons (car lst1) i) lst2))
        (make-c-procedure (reverse lst2) result-type))))
(define (scheme-id->c-id s)
  (define (hex->char i) (string-ref "0123456789abcdef" i))
  (let loop ((i (- (string-length s) 1)) (l '()))
    (if (>= i 0)
        (let ((c (string-ref s i)))
          (cond ((or (char-alphabetic? c) (char-numeric? c))
                 (loop (- i 1) (cons c l)))
                ((char=? c #\_) (loop (- i 1) (cons c (cons c l))))
                (else
                 (let ((n (character-encoding c)))
                   (loop (- i 1)
                         (cons #\_
                               (cons (hex->char (quotient n 16))
                                     (cons (hex->char (modulo n 16)) l))))))))
        (lst->string l))))
(define (pt-syntax-error source msg . args)
  (apply compiler-user-error
         (cons (source-locat source)
               (cons (string-append "Syntax error -- " msg) args))))
(define (pt source env use)
  (cond ((macro-expr? source env) (pt (macro-expand source env) env use))
        ((self-eval-expr? source) (pt-self-eval source env use))
        ((quote-expr? source) (pt-quote source env use))
        ((quasiquote-expr? source) (pt-quasiquote source env use))
        ((unquote-expr? source)
         (pt-syntax-error source "Ill-placed 'unquote'"))
        ((unquote-splicing-expr? source)
         (pt-syntax-error source "Ill-placed 'unquote-splicing'"))
        ((var-expr? source env) (pt-var source env use))
        ((set!-expr? source env) (pt-set! source env use))
        ((lambda-expr? source env) (pt-lambda source env use))
        ((if-expr? source) (pt-if source env use))
        ((cond-expr? source) (pt-cond source env use))
        ((and-expr? source) (pt-and source env use))
        ((or-expr? source) (pt-or source env use))
        ((case-expr? source) (pt-case source env use))
        ((let-expr? source env) (pt-let source env use))
        ((let*-expr? source env) (pt-let* source env use))
        ((letrec-expr? source env) (pt-letrec source env use))
        ((begin-expr? source) (pt-begin source env use))
        ((do-expr? source env) (pt-do source env use))
        ((define-expr? source env)
         (pt-syntax-error source "Ill-placed 'define'"))
        ((delay-expr? source env) (pt-delay source env use))
        ((future-expr? source env) (pt-future source env use))
        ((define-macro-expr? source env)
         (pt-syntax-error source "Ill-placed '##define-macro'"))
        ((begin-defs-expr? source)
         (pt-syntax-error source "Ill-placed 'begin' style definitions"))
        ((declare-expr? source)
         (pt-syntax-error source "Ill-placed '##declare'"))
        ((c-declaration-expr? source)
         (pt-syntax-error source "Ill-placed '##c-declaration'"))
        ((c-init-expr? source)
         (pt-syntax-error source "Ill-placed '##c-init'"))
        ((c-procedure-expr? source) (pt-c-procedure source env use))
        ((combination-expr? source) (pt-combination source env use))
        (else (compiler-internal-error "pt, unknown expression type" source))))
(define (macro-expand source env)
  (let ((code (source-code source)))
    (expression->source
     (apply (cdr (env-lookup-macro env (source-code (car code))))
            (cdr (source->expression source)))
     source)))
(define (pt-self-eval source env use)
  (let ((val (source->expression source)))
    (if (eq? use 'none)
        (new-cst source (env-declarations env) undef-object)
        (new-cst source (env-declarations env) val))))
(define (pt-quote source env use)
  (let ((code (source-code source)))
    (if (eq? use 'none)
        (new-cst source (env-declarations env) undef-object)
        (new-cst source
                 (env-declarations env)
                 (source->expression (cadr code))))))
(define (pt-quasiquote source env use)
  (let ((code (source-code source))) (pt-quasiquotation (cadr code) 1 env)))
(define (pt-quasiquotation form level env)
  (cond ((= level 0) (pt form env 'true))
        ((quasiquote-expr? form)
         (pt-quasiquotation-list form (source-code form) (+ level 1) env))
        ((unquote-expr? form)
         (if (= level 1)
             (pt (cadr (source-code form)) env 'true)
             (pt-quasiquotation-list form (source-code form) (- level 1) env)))
        ((unquote-splicing-expr? form)
         (if (= level 1)
             (pt-syntax-error form "Ill-placed 'unquote-splicing'")
             (pt-quasiquotation-list form (source-code form) (- level 1) env)))
        ((pair? (source-code form))
         (pt-quasiquotation-list form (source-code form) level env))
        ((vector? (source-code form))
         (vector-form
          form
          (pt-quasiquotation-list
           form
           (vector->lst (source-code form))
           level
           env)
          env))
        (else
         (new-cst form (env-declarations env) (source->expression form)))))
(define (pt-quasiquotation-list form l level env)
  (cond ((pair? l)
         (if (and (unquote-splicing-expr? (car l)) (= level 1))
             (let ((x (pt (cadr (source-code (car l))) env 'true)))
               (if (null? (cdr l))
                   x
                   (append-form
                    (car l)
                    x
                    (pt-quasiquotation-list form (cdr l) 1 env)
                    env)))
             (cons-form
              form
              (pt-quasiquotation (car l) level env)
              (pt-quasiquotation-list form (cdr l) level env)
              env)))
        ((null? l) (new-cst form (env-declarations env) '()))
        (else (pt-quasiquotation l level env))))
(define (append-form source ptree1 ptree2 env)
  (cond ((and (cst? ptree1) (cst? ptree2))
         (new-cst source
                  (env-declarations env)
                  (append (cst-val ptree1) (cst-val ptree2))))
        ((and (cst? ptree2) (null? (cst-val ptree2))) ptree1)
        (else
         (new-call*
          source
          (add-not-safe (env-declarations env))
          (new-ref-extended-bindings source **quasi-append-sym env)
          (list ptree1 ptree2)))))
(define (cons-form source ptree1 ptree2 env)
  (cond ((and (cst? ptree1) (cst? ptree2))
         (new-cst source
                  (env-declarations env)
                  (cons (cst-val ptree1) (cst-val ptree2))))
        ((and (cst? ptree2) (null? (cst-val ptree2)))
         (new-call*
          source
          (add-not-safe (env-declarations env))
          (new-ref-extended-bindings source **quasi-list-sym env)
          (list ptree1)))
        (else
         (new-call*
          source
          (add-not-safe (env-declarations env))
          (new-ref-extended-bindings source **quasi-cons-sym env)
          (list ptree1 ptree2)))))
(define (vector-form source ptree env)
  (if (cst? ptree)
      (new-cst source (env-declarations env) (lst->vector (cst-val ptree)))
      (new-call*
       source
       (add-not-safe (env-declarations env))
       (new-ref-extended-bindings source **quasi-list->vector-sym env)
       (list ptree))))
(define (pt-var source env use)
  (if (eq? use 'none)
      (new-cst source (env-declarations env) undef-object)
      (new-ref source
               (env-declarations env)
               (env-lookup-var env (source-code source) source))))
(define (pt-set! source env use)
  (let ((code (source-code source)))
    (new-set source
             (env-declarations env)
             (env-lookup-var env (source-code (cadr code)) (cadr code))
             (pt (caddr code) env 'true))))
(define (pt-lambda source env use)
  (let ((code (source-code source)))
    (define (new-params parms)
      (cond ((pair? parms)
             (let* ((parm* (car parms))
                    (parm (source-code parm*))
                    (p* (if (pair? parm) (car parm) parm*)))
               (cons (make-var (source-code p*) #t (set-empty) (set-empty) p*)
                     (new-params (cdr parms)))))
            ((null? parms) '())
            (else
             (list (make-var
                    (source-code parms)
                    #t
                    (set-empty)
                    (set-empty)
                    parms)))))
    (define (min-params parms)
      (let loop ((l parms) (n 0))
        (if (pair? l)
            (if (pair? (source-code (car l))) n (loop (cdr l) (+ n 1)))
            n)))
    (define (rest-param? parms)
      (if (pair? parms) (rest-param? (cdr parms)) (not (null? parms))))
    (define (optionals parms source body env)
      (if (pair? parms)
          (let* ((parm* (car parms)) (parm (source-code parm*)))
            (if (and (pair? parm) (length? parm 2))
                (let* ((var (car parm))
                       (vars (new-variables (list var)))
                       (decl (env-declarations env)))
                  (new-call*
                   parm*
                   decl
                   (new-prc parm*
                            decl
                            #f
                            1
                            #f
                            vars
                            (optionals
                             (cdr parms)
                             source
                             body
                             (env-frame env vars)))
                   (list (new-tst parm*
                                  decl
                                  (new-call*
                                   parm*
                                   decl
                                   (new-ref-extended-bindings
                                    parm*
                                    **unassigned?-sym
                                    env)
                                   (list (new-ref parm*
                                                  decl
                                                  (env-lookup-var
                                                   env
                                                   (source-code var)
                                                   var))))
                                  (pt (cadr parm) env 'true)
                                  (new-ref parm*
                                           decl
                                           (env-lookup-var
                                            env
                                            (source-code var)
                                            var))))))
                (optionals (cdr parms) source body env)))
          (pt-body source body env 'true)))
    (if (eq? use 'none)
        (new-cst source (env-declarations env) undef-object)
        (let* ((parms (source->parms (cadr code))) (frame (new-params parms)))
          (new-prc source
                   (env-declarations env)
                   #f
                   (min-params parms)
                   (rest-param? parms)
                   frame
                   (optionals
                    parms
                    source
                    (cddr code)
                    (env-frame env frame)))))))
(define (source->parms source)
  (let ((x (source-code source))) (if (or (pair? x) (null? x)) x source)))
(define (pt-body source body env use)
  (define (letrec-defines vars vals envs body env)
    (cond ((null? body)
           (pt-syntax-error
            source
            "Body must contain at least one evaluable expression"))
          ((macro-expr? (car body) env)
           (letrec-defines
            vars
            vals
            envs
            (cons (macro-expand (car body) env) (cdr body))
            env))
          ((begin-defs-expr? (car body))
           (letrec-defines
            vars
            vals
            envs
            (append (begin-defs-body (car body)) (cdr body))
            env))
          ((include-expr? (car body))
           (if *ptree-port* (display "  " *ptree-port*))
           (let ((x (file->sources*
                     (include-filename (car body))
                     *ptree-port*
                     (source-locat (car body)))))
             (if *ptree-port* (newline *ptree-port*))
             (letrec-defines vars vals envs (append x (cdr body)) env)))
          ((define-expr? (car body) env)
           (let* ((var** (definition-variable (car body)))
                  (var* (source-code var**))
                  (var (env-define-var env var* var**)))
             (letrec-defines
              (cons var vars)
              (cons (definition-value (car body)) vals)
              (cons env envs)
              (cdr body)
              env)))
          ((declare-expr? (car body))
           (letrec-defines
            vars
            vals
            envs
            (cdr body)
            (add-declarations (car body) env)))
          ((define-macro-expr? (car body) env)
           (letrec-defines
            vars
            vals
            envs
            (cdr body)
            (add-macro (car body) env)))
          ((c-declaration-expr? (car body))
           (add-c-declaration (source-code (cadr (source-code (car body)))))
           (letrec-defines vars vals envs (cdr body) env))
          ((c-init-expr? (car body))
           (add-c-init (source-code (cadr (source-code (car body)))))
           (letrec-defines vars vals envs (cdr body) env))
          ((null? vars) (pt-sequence source body env use))
          (else
           (let ((vars* (reverse vars)))
             (let loop ((vals* '()) (l1 vals) (l2 envs))
               (if (not (null? l1))
                   (loop (cons (pt (car l1) (car l2) 'true) vals*)
                         (cdr l1)
                         (cdr l2))
                   (pt-recursive-let source vars* vals* body env use)))))))
  (letrec-defines '() '() '() body (env-frame env '())))
(define (pt-sequence source seq env use)
  (if (length? seq 1)
      (pt (car seq) env use)
      (new-seq source
               (env-declarations env)
               (pt (car seq) env 'none)
               (pt-sequence source (cdr seq) env use))))
(define (pt-if source env use)
  (let ((code (source-code source)))
    (new-tst source
             (env-declarations env)
             (pt (cadr code) env 'pred)
             (pt (caddr code) env use)
             (if (length? code 3)
                 (new-cst source (env-declarations env) undef-object)
                 (pt (cadddr code) env use)))))
(define (pt-cond source env use)
  (define (pt-clauses clauses)
    (if (length? clauses 0)
        (new-cst source (env-declarations env) undef-object)
        (let* ((clause* (car clauses)) (clause (source-code clause*)))
          (cond ((eq? (source-code (car clause)) else-sym)
                 (pt-sequence clause* (cdr clause) env use))
                ((length? clause 1)
                 (new-disj
                  clause*
                  (env-declarations env)
                  (pt (car clause) env (if (eq? use 'true) 'true 'pred))
                  (pt-clauses (cdr clauses))))
                ((eq? (source-code (cadr clause)) =>-sym)
                 (new-disj-call
                  clause*
                  (env-declarations env)
                  (pt (car clause) env 'true)
                  (pt (caddr clause) env 'true)
                  (pt-clauses (cdr clauses))))
                (else
                 (new-tst clause*
                          (env-declarations env)
                          (pt (car clause) env 'pred)
                          (pt-sequence clause* (cdr clause) env use)
                          (pt-clauses (cdr clauses))))))))
  (pt-clauses (cdr (source-code source))))
(define (pt-and source env use)
  (define (pt-exprs exprs)
    (cond ((length? exprs 0) (new-cst source (env-declarations env) #t))
          ((length? exprs 1) (pt (car exprs) env use))
          (else
           (new-conj
            (car exprs)
            (env-declarations env)
            (pt (car exprs) env (if (eq? use 'true) 'true 'pred))
            (pt-exprs (cdr exprs))))))
  (pt-exprs (cdr (source-code source))))
(define (pt-or source env use)
  (define (pt-exprs exprs)
    (cond ((length? exprs 0)
           (new-cst source (env-declarations env) false-object))
          ((length? exprs 1) (pt (car exprs) env use))
          (else
           (new-disj
            (car exprs)
            (env-declarations env)
            (pt (car exprs) env (if (eq? use 'true) 'true 'pred))
            (pt-exprs (cdr exprs))))))
  (pt-exprs (cdr (source-code source))))
(define (pt-case source env use)
  (let ((code (source-code source)) (temp (new-temps source '(temp))))
    (define (pt-clauses clauses)
      (if (length? clauses 0)
          (new-cst source (env-declarations env) undef-object)
          (let* ((clause* (car clauses)) (clause (source-code clause*)))
            (if (eq? (source-code (car clause)) else-sym)
                (pt-sequence clause* (cdr clause) env use)
                (new-tst clause*
                         (env-declarations env)
                         (new-call*
                          clause*
                          (add-not-safe (env-declarations env))
                          (new-ref-extended-bindings
                           clause*
                           **case-memv-sym
                           env)
                          (list (new-ref clause*
                                         (env-declarations env)
                                         (car temp))
                                (new-cst (car clause)
                                         (env-declarations env)
                                         (source->expression (car clause)))))
                         (pt-sequence clause* (cdr clause) env use)
                         (pt-clauses (cdr clauses)))))))
    (new-call*
     source
     (env-declarations env)
     (new-prc source
              (env-declarations env)
              #f
              1
              #f
              temp
              (pt-clauses (cddr code)))
     (list (pt (cadr code) env 'true)))))
(define (pt-let source env use)
  (let ((code (source-code source)))
    (if (bindable-var? (cadr code) env)
        (let* ((self (new-variables (list (cadr code))))
               (bindings (map source-code (source-code (caddr code))))
               (vars (new-variables (map car bindings)))
               (vals (map (lambda (x) (pt (cadr x) env 'true)) bindings))
               (env (env-frame (env-frame env vars) self))
               (self-proc
                (list (new-prc source
                               (env-declarations env)
                               #f
                               (length vars)
                               #f
                               vars
                               (pt-body source (cdddr code) env use)))))
          (set-prc-names! self self-proc)
          (set-prc-names! vars vals)
          (new-call*
           source
           (env-declarations env)
           (new-prc source
                    (env-declarations env)
                    #f
                    1
                    #f
                    self
                    (new-call*
                     source
                     (env-declarations env)
                     (new-ref source (env-declarations env) (car self))
                     vals))
           self-proc))
        (if (null? (source-code (cadr code)))
            (pt-body source (cddr code) env use)
            (let* ((bindings (map source-code (source-code (cadr code))))
                   (vars (new-variables (map car bindings)))
                   (vals (map (lambda (x) (pt (cadr x) env 'true)) bindings))
                   (env (env-frame env vars)))
              (set-prc-names! vars vals)
              (new-call*
               source
               (env-declarations env)
               (new-prc source
                        (env-declarations env)
                        #f
                        (length vars)
                        #f
                        vars
                        (pt-body source (cddr code) env use))
               vals))))))
(define (pt-let* source env use)
  (let ((code (source-code source)))
    (define (pt-bindings bindings env use)
      (if (null? bindings)
          (pt-body source (cddr code) env use)
          (let* ((binding* (car bindings))
                 (binding (source-code binding*))
                 (vars (new-variables (list (car binding))))
                 (vals (list (pt (cadr binding) env 'true)))
                 (env (env-frame env vars)))
            (set-prc-names! vars vals)
            (new-call*
             binding*
             (env-declarations env)
             (new-prc binding*
                      (env-declarations env)
                      #f
                      1
                      #f
                      vars
                      (pt-bindings (cdr bindings) env use))
             vals))))
    (pt-bindings (source-code (cadr code)) env use)))
(define (pt-letrec source env use)
  (let* ((code (source-code source))
         (bindings (map source-code (source-code (cadr code))))
         (vars* (new-variables (map car bindings)))
         (env* (env-frame env vars*)))
    (pt-recursive-let
     source
     vars*
     (map (lambda (x) (pt (cadr x) env* 'true)) bindings)
     (cddr code)
     env*
     use)))
(define (pt-recursive-let source vars vals body env use)
  (define (dependency-graph vars vals)
    (define (dgraph vars* vals*)
      (if (null? vars*)
          (set-empty)
          (let ((var (car vars*)) (val (car vals*)))
            (set-adjoin
             (dgraph (cdr vars*) (cdr vals*))
             (make-gnode
              var
              (set-intersection (list->set vars) (free-variables val)))))))
    (dgraph vars vals))
  (define (val-of var)
    (list-ref vals (- (length vars) (length (memq var vars)))))
  (define (bind-in-order order)
    (if (null? order)
        (pt-body source body env use)
        (let* ((vars-set (car order)) (vars (set->list vars-set)))
          (let loop1 ((l (reverse vars))
                      (vars-b '())
                      (vals-b '())
                      (vars-a '()))
            (if (not (null? l))
                (let* ((var (car l)) (val (val-of var)))
                  (if (or (prc? val)
                          (set-empty?
                           (set-intersection (free-variables val) vars-set)))
                      (loop1 (cdr l)
                             (cons var vars-b)
                             (cons val vals-b)
                             vars-a)
                      (loop1 (cdr l) vars-b vals-b (cons var vars-a))))
                (let* ((result1 (let loop2 ((l vars-a))
                                  (if (not (null? l))
                                      (let* ((var (car l)) (val (val-of var)))
                                        (new-seq source
                                                 (env-declarations env)
                                                 (new-set source
                                                          (env-declarations
                                                           env)
                                                          var
                                                          val)
                                                 (loop2 (cdr l))))
                                      (bind-in-order (cdr order)))))
                       (result2 (if (null? vars-b)
                                    result1
                                    (new-call*
                                     source
                                     (env-declarations env)
                                     (new-prc source
                                              (env-declarations env)
                                              #f
                                              (length vars-b)
                                              #f
                                              vars-b
                                              result1)
                                     vals-b)))
                       (result3 (if (null? vars-a)
                                    result2
                                    (new-call*
                                     source
                                     (env-declarations env)
                                     (new-prc source
                                              (env-declarations env)
                                              #f
                                              (length vars-a)
                                              #f
                                              vars-a
                                              result2)
                                     (map (lambda (var)
                                            (new-cst source
                                                     (env-declarations env)
                                                     undef-object))
                                          vars-a)))))
                  result3))))))
  (set-prc-names! vars vals)
  (bind-in-order
   (topological-sort (transitive-closure (dependency-graph vars vals)))))
(define (pt-begin source env use)
  (pt-sequence source (cdr (source-code source)) env use))
(define (pt-do source env use)
  (let* ((code (source-code source))
         (loop (new-temps source '(loop)))
         (bindings (map source-code (source-code (cadr code))))
         (vars (new-variables (map car bindings)))
         (init (map (lambda (x) (pt (cadr x) env 'true)) bindings))
         (env (env-frame env vars))
         (step (map (lambda (x)
                      (pt (if (length? x 2) (car x) (caddr x)) env 'true))
                    bindings))
         (exit (source-code (caddr code))))
    (set-prc-names! vars init)
    (new-call*
     source
     (env-declarations env)
     (new-prc source
              (env-declarations env)
              #f
              1
              #f
              loop
              (new-call*
               source
               (env-declarations env)
               (new-ref source (env-declarations env) (car loop))
               init))
     (list (new-prc source
                    (env-declarations env)
                    #f
                    (length vars)
                    #f
                    vars
                    (new-tst source
                             (env-declarations env)
                             (pt (car exit) env 'pred)
                             (if (length? exit 1)
                                 (new-cst (caddr code)
                                          (env-declarations env)
                                          undef-object)
                                 (pt-sequence (caddr code) (cdr exit) env use))
                             (if (length? code 3)
                                 (new-call*
                                  source
                                  (env-declarations env)
                                  (new-ref source
                                           (env-declarations env)
                                           (car loop))
                                  step)
                                 (new-seq source
                                          (env-declarations env)
                                          (pt-sequence
                                           source
                                           (cdddr code)
                                           env
                                           'none)
                                          (new-call*
                                           source
                                           (env-declarations env)
                                           (new-ref source
                                                    (env-declarations env)
                                                    (car loop))
                                           step)))))))))
(define (pt-combination source env use)
  (let* ((code (source-code source))
         (oper (pt (car code) env 'true))
         (decl (node-decl oper)))
    (new-call*
     source
     (env-declarations env)
     oper
     (map (lambda (x) (pt x env 'true)) (cdr code)))))
(define (pt-delay source env use)
  (let ((code (source-code source)))
    (new-call*
     source
     (add-not-safe (env-declarations env))
     (new-ref-extended-bindings source **make-placeholder-sym env)
     (list (new-prc source
                    (env-declarations env)
                    #f
                    0
                    #f
                    '()
                    (pt (cadr code) env 'true))))))
(define (pt-future source env use)
  (let ((decl (env-declarations env)) (code (source-code source)))
    (new-fut source decl (pt (cadr code) env 'true))))
(define (self-eval-expr? source)
  (let ((code (source-code source)))
    (and (not (pair? code)) (not (symbol-object? code)))))
(define (quote-expr? source) (mymatch quote-sym 1 source))
(define (quasiquote-expr? source) (mymatch quasiquote-sym 1 source))
(define (unquote-expr? source) (mymatch unquote-sym 1 source))
(define (unquote-splicing-expr? source)
  (mymatch unquote-splicing-sym 1 source))
(define (var-expr? source env)
  (let ((code (source-code source)))
    (and (symbol-object? code)
         (not-keyword source env code)
         (not-macro source env code))))
(define (not-macro source env name)
  (if (env-lookup-macro env name)
      (pt-syntax-error source "Macro name can't be used as a variable:" name)
      #t))
(define (bindable-var? source env)
  (let ((code (source-code source)))
    (and (symbol-object? code) (not-keyword source env code))))
(define (not-keyword source env name)
  (if (or (memq name common-keywords)
          (memq name
                (dialect-specific-keywords
                 (scheme-dialect (env-declarations env)))))
      (pt-syntax-error
       source
       "Predefined keyword can't be used as a variable:"
       name)
      #t))
(define (set!-expr? source env)
  (and (mymatch set!-sym 2 source)
       (var-expr? (cadr (source-code source)) env)))
(define (lambda-expr? source env)
  (and (mymatch lambda-sym -2 source)
       (proper-parms? (source->parms (cadr (source-code source))) env)))
(define (if-expr? source)
  (and (mymatch if-sym -2 source)
       (or (<= (length (source-code source)) 4)
           (pt-syntax-error source "Ill-formed special form" if-sym))))
(define (cond-expr? source)
  (and (mymatch cond-sym -1 source) (proper-clauses? source)))
(define (and-expr? source) (mymatch and-sym 0 source))
(define (or-expr? source) (mymatch or-sym 0 source))
(define (case-expr? source)
  (and (mymatch case-sym -2 source) (proper-case-clauses? source)))
(define (let-expr? source env)
  (and (mymatch let-sym -2 source)
       (let ((code (source-code source)))
         (if (bindable-var? (cadr code) env)
             (and (proper-bindings? (caddr code) #t env)
                  (or (> (length code) 3)
                      (pt-syntax-error source "Ill-formed named 'let'")))
             (proper-bindings? (cadr code) #t env)))))
(define (let*-expr? source env)
  (and (mymatch let*-sym -2 source)
       (proper-bindings? (cadr (source-code source)) #f env)))
(define (letrec-expr? source env)
  (and (mymatch letrec-sym -2 source)
       (proper-bindings? (cadr (source-code source)) #t env)))
(define (begin-expr? source) (mymatch begin-sym -1 source))
(define (do-expr? source env)
  (and (mymatch do-sym -2 source)
       (proper-do-bindings? source env)
       (proper-do-exit? source)))
(define (define-expr? source env)
  (and (mymatch define-sym -1 source)
       (proper-definition? source env)
       (let ((v (definition-variable source)))
         (not-macro v env (source-code v)))))
(define (combination-expr? source)
  (let ((length (proper-length (source-code source))))
    (if length
        (or (> length 0) (pt-syntax-error source "Ill-formed procedure call"))
        (pt-syntax-error source "Ill-terminated procedure call"))))
(define (delay-expr? source env)
  (and (not (eq? (scheme-dialect (env-declarations env)) ieee-scheme-sym))
       (mymatch delay-sym 1 source)))
(define (future-expr? source env)
  (and (eq? (scheme-dialect (env-declarations env)) multilisp-sym)
       (mymatch future-sym 1 source)))
(define (macro-expr? source env)
  (let ((code (source-code source)))
    (and (pair? code)
         (symbol-object? (source-code (car code)))
         (let ((macr (env-lookup-macro env (source-code (car code)))))
           (and macr
                (let ((len (proper-length (cdr code))))
                  (if len
                      (let ((len* (+ len 1)) (size (car macr)))
                        (or (if (> size 0) (= len* size) (>= len* (- size)))
                            (pt-syntax-error source "Ill-formed macro form")))
                      (pt-syntax-error
                       source
                       "Ill-terminated macro form"))))))))
(define (define-macro-expr? source env)
  (and (mymatch **define-macro-sym -1 source) (proper-definition? source env)))
(define (declare-expr? source) (mymatch **declare-sym -1 source))
(define (include-expr? source) (mymatch **include-sym 1 source))
(define (begin-defs-expr? source) (mymatch begin-sym 0 source))
(define (mymatch keyword size source)
  (let ((code (source-code source)))
    (and (pair? code)
         (eq? (source-code (car code)) keyword)
         (let ((length (proper-length (cdr code))))
           (if length
               (or (if (> size 0) (= length size) (>= length (- size)))
                   (pt-syntax-error source "Ill-formed special form" keyword))
               (pt-syntax-error
                source
                "Ill-terminated special form"
                keyword))))))
(define (proper-length l)
  (define (length l n)
    (cond ((pair? l) (length (cdr l) (+ n 1))) ((null? l) n) (else #f)))
  (length l 0))
(define (proper-definition? source env)
  (let* ((code (source-code source))
         (pattern* (cadr code))
         (pattern (source-code pattern*))
         (body (cddr code)))
    (cond ((bindable-var? pattern* env)
           (cond ((length? body 0) #t)
                 ((length? body 1) #t)
                 (else (pt-syntax-error source "Ill-formed definition body"))))
          ((pair? pattern)
           (if (length? body 0)
               (pt-syntax-error
                source
                "Body of a definition must have at least one expression"))
           (if (bindable-var? (car pattern) env)
               (proper-parms? (cdr pattern) env)
               (pt-syntax-error
                (car pattern)
                "Procedure name must be an identifier")))
          (else (pt-syntax-error pattern* "Ill-formed definition pattern")))))
(define (definition-variable def)
  (let* ((code (source-code def)) (pattern (cadr code)))
    (if (pair? (source-code pattern)) (car (source-code pattern)) pattern)))
(define (definition-value def)
  (let ((code (source-code def)) (loc (source-locat def)))
    (cond ((pair? (source-code (cadr code)))
           (make-source
            (cons (make-source lambda-sym loc)
                  (cons (parms->source (cdr (source-code (cadr code))) loc)
                        (cddr code)))
            loc))
          ((null? (cddr code))
           (make-source
            (list (make-source quote-sym loc) (make-source undef-object loc))
            loc))
          (else (caddr code)))))
(define (parms->source parms loc)
  (if (or (pair? parms) (null? parms)) (make-source parms loc) parms))
(define (proper-parms? parms env)
  (define (proper-parms parms seen optional-seen)
    (cond ((pair? parms)
           (let* ((parm* (car parms)) (parm (source-code parm*)))
             (cond ((pair? parm)
                    (if (eq? (scheme-dialect (env-declarations env))
                             multilisp-sym)
                        (let ((length (proper-length parm)))
                          (if (or (eqv? length 1) (eqv? length 2))
                              (let ((var (car parm)))
                                (if (bindable-var? var env)
                                    (if (memq (source-code var) seen)
                                        (pt-syntax-error
                                         var
                                         "Duplicate parameter in parameter list")
                                        (proper-parms
                                         (cdr parms)
                                         (cons (source-code var) seen)
                                         #t))
                                    (pt-syntax-error
                                     var
                                     "Parameter must be an identifier")))
                              (pt-syntax-error
                               parm*
                               "Ill-formed optional parameter")))
                        (pt-syntax-error
                         parm*
                         "optional parameters illegal in this dialect")))
                   (optional-seen
                    (pt-syntax-error parm* "Optional parameter expected"))
                   ((bindable-var? parm* env)
                    (if (memq parm seen)
                        (pt-syntax-error
                         parm*
                         "Duplicate parameter in parameter list"))
                    (proper-parms (cdr parms) (cons parm seen) #f))
                   (else
                    (pt-syntax-error
                     parm*
                     "Parameter must be an identifier")))))
          ((null? parms) #t)
          ((bindable-var? parms env)
           (if (memq (source-code parms) seen)
               (pt-syntax-error parms "Duplicate parameter in parameter list")
               #t))
          (else
           (pt-syntax-error parms "Rest parameter must be an identifier"))))
  (proper-parms parms '() #f))
(define (proper-clauses? source)
  (define (proper-clauses clauses)
    (or (null? clauses)
        (let* ((clause* (car clauses))
               (clause (source-code clause*))
               (length (proper-length clause)))
          (if length
              (if (>= length 1)
                  (if (eq? (source-code (car clause)) else-sym)
                      (cond ((= length 1)
                             (pt-syntax-error
                              clause*
                              "Else clause must have a body"))
                            ((not (null? (cdr clauses)))
                             (pt-syntax-error
                              clause*
                              "Else clause must be the last clause"))
                            (else (proper-clauses (cdr clauses))))
                      (if (and (>= length 2)
                               (eq? (source-code (cadr clause)) =>-sym)
                               (not (= length 3)))
                          (pt-syntax-error
                           (cadr clause)
                           "'=>' must be followed by a single expression")
                          (proper-clauses (cdr clauses))))
                  (pt-syntax-error clause* "Ill-formed 'cond' clause"))
              (pt-syntax-error clause* "Ill-terminated 'cond' clause")))))
  (proper-clauses (cdr (source-code source))))
(define (proper-case-clauses? source)
  (define (proper-case-clauses clauses)
    (or (null? clauses)
        (let* ((clause* (car clauses))
               (clause (source-code clause*))
               (length (proper-length clause)))
          (if length
              (if (>= length 2)
                  (if (eq? (source-code (car clause)) else-sym)
                      (if (not (null? (cdr clauses)))
                          (pt-syntax-error
                           clause*
                           "Else clause must be the last clause")
                          (proper-case-clauses (cdr clauses)))
                      (begin
                        (proper-selector-list? (car clause))
                        (proper-case-clauses (cdr clauses))))
                  (pt-syntax-error
                   clause*
                   "A 'case' clause must have a selector list and a body"))
              (pt-syntax-error clause* "Ill-terminated 'case' clause")))))
  (proper-case-clauses (cddr (source-code source))))
(define (proper-selector-list? source)
  (let* ((code (source-code source)) (length (proper-length code)))
    (if length
        (or (>= length 1)
            (pt-syntax-error
             source
             "Selector list must contain at least one element"))
        (pt-syntax-error source "Ill-terminated selector list"))))
(define (proper-bindings? bindings check-dupl? env)
  (define (proper-bindings l seen)
    (cond ((pair? l)
           (let* ((binding* (car l)) (binding (source-code binding*)))
             (if (eqv? (proper-length binding) 2)
                 (let ((var (car binding)))
                   (if (bindable-var? var env)
                       (if (and check-dupl? (memq (source-code var) seen))
                           (pt-syntax-error
                            var
                            "Duplicate variable in bindings")
                           (proper-bindings
                            (cdr l)
                            (cons (source-code var) seen)))
                       (pt-syntax-error
                        var
                        "Binding variable must be an identifier")))
                 (pt-syntax-error binding* "Ill-formed binding"))))
          ((null? l) #t)
          (else (pt-syntax-error bindings "Ill-terminated binding list"))))
  (proper-bindings (source-code bindings) '()))
(define (proper-do-bindings? source env)
  (let ((bindings (cadr (source-code source))))
    (define (proper-bindings l seen)
      (cond ((pair? l)
             (let* ((binding* (car l))
                    (binding (source-code binding*))
                    (length (proper-length binding)))
               (if (or (eqv? length 2) (eqv? length 3))
                   (let ((var (car binding)))
                     (if (bindable-var? var env)
                         (if (memq (source-code var) seen)
                             (pt-syntax-error
                              var
                              "Duplicate variable in bindings")
                             (proper-bindings
                              (cdr l)
                              (cons (source-code var) seen)))
                         (pt-syntax-error
                          var
                          "Binding variable must be an identifier")))
                   (pt-syntax-error binding* "Ill-formed binding"))))
            ((null? l) #t)
            (else (pt-syntax-error bindings "Ill-terminated binding list"))))
    (proper-bindings (source-code bindings) '())))
(define (proper-do-exit? source)
  (let* ((code (source-code (caddr (source-code source))))
         (length (proper-length code)))
    (if length
        (or (> length 0) (pt-syntax-error source "Ill-formed exit clause"))
        (pt-syntax-error source "Ill-terminated exit clause"))))
(define (include-filename source) (source-code (cadr (source-code source))))
(define (begin-defs-body source) (cdr (source-code source)))
(define (length? l n)
  (cond ((null? l) (= n 0)) ((> n 0) (length? (cdr l) (- n 1))) (else #f)))
(define (transform-declaration source)
  (let ((code (source-code source)))
    (if (not (pair? code))
        (pt-syntax-error source "Ill-formed declaration")
        (let* ((pos (not (eq? (source-code (car code)) not-sym)))
               (x (if pos code (cdr code))))
          (if (not (pair? x))
              (pt-syntax-error source "Ill-formed declaration")
              (let* ((id* (car x)) (id (source-code id*)))
                (cond ((not (symbol-object? id))
                       (pt-syntax-error
                        id*
                        "Declaration name must be an identifier"))
                      ((assq id flag-declarations)
                       (cond ((not pos)
                              (pt-syntax-error
                               id*
                               "Declaration can't be negated"))
                             ((null? (cdr x))
                              (flag-decl
                               source
                               (cdr (assq id flag-declarations))
                               id))
                             (else
                              (pt-syntax-error
                               source
                               "Ill-formed declaration"))))
                      ((memq id parameterized-declarations)
                       (cond ((not pos)
                              (pt-syntax-error
                               id*
                               "Declaration can't be negated"))
                             ((eqv? (proper-length x) 2)
                              (parameterized-decl
                               source
                               id
                               (source->expression (cadr x))))
                             (else
                              (pt-syntax-error
                               source
                               "Ill-formed declaration"))))
                      ((memq id boolean-declarations)
                       (if (null? (cdr x))
                           (boolean-decl source id pos)
                           (pt-syntax-error source "Ill-formed declaration")))
                      ((assq id namable-declarations)
                       (cond ((not pos)
                              (pt-syntax-error
                               id*
                               "Declaration can't be negated"))
                             (else
                              (namable-decl
                               source
                               (cdr (assq id namable-declarations))
                               id
                               (map source->expression (cdr x))))))
                      ((memq id namable-boolean-declarations)
                       (namable-boolean-decl
                        source
                        id
                        pos
                        (map source->expression (cdr x))))
                      ((memq id namable-string-declarations)
                       (if (not (pair? (cdr x)))
                           (pt-syntax-error source "Ill-formed declaration")
                           (let* ((str* (cadr x)) (str (source-code str*)))
                             (cond ((not pos)
                                    (pt-syntax-error
                                     id*
                                     "Declaration can't be negated"))
                                   ((not (string? str))
                                    (pt-syntax-error str* "String expected"))
                                   (else
                                    (namable-string-decl
                                     source
                                     id
                                     str
                                     (map source->expression (cddr x))))))))
                      (else (pt-syntax-error id* "Unknown declaration")))))))))
(define (add-declarations source env)
  (let loop ((l (cdr (source-code source))) (env env))
    (if (pair? l)
        (loop (cdr l) (env-declare env (transform-declaration (car l))))
        env)))
(define (add-decl d decl) (env-declare decl d))
(define (add-macro source env)
  (define (form-size parms)
    (let loop ((l parms) (n 1))
      (if (pair? l) (loop (cdr l) (+ n 1)) (if (null? l) n (- n)))))
  (define (error-proc . msgs)
    (apply compiler-user-error
           (cons (source-locat source) (cons "(in macro body)" msgs))))
  (let ((var (definition-variable source)) (proc (definition-value source)))
    (if (lambda-expr? proc env)
        (env-macro
         env
         (source-code var)
         (cons (form-size (source->parms (cadr (source-code proc))))
               (scheme-global-eval (source->expression proc) error-proc)))
        (pt-syntax-error source "Macro value must be a lambda expression"))))
(define (ptree.begin! info-port) (set! *ptree-port* info-port) '())
(define (ptree.end!) '())
(define *ptree-port* '())
(define (normalize-parse-tree ptree env)
  (define (normalize ptree)
    (let ((tree (assignment-convert (partial-evaluate ptree) env)))
      (lambda-lift! tree)
      tree))
  (if (def? ptree)
      (begin
        (node-children-set! ptree (list (normalize (def-val ptree))))
        ptree)
      (normalize ptree)))
(define (partial-evaluate ptree) (pe ptree '()))
(define (pe ptree consts)
  (cond ((cst? ptree)
         (new-cst (node-source ptree) (node-decl ptree) (cst-val ptree)))
        ((ref? ptree)
         (let ((var (ref-var ptree)))
           (var-refs-set! var (set-remove (var-refs var) ptree))
           (let ((x (assq var consts)))
             (if x
                 (new-cst (node-source ptree) (node-decl ptree) (cdr x))
                 (let ((y (global-val var)))
                   (if (and y (cst? y))
                       (new-cst (node-source ptree)
                                (node-decl ptree)
                                (cst-val y))
                       (new-ref (node-source ptree)
                                (node-decl ptree)
                                var)))))))
        ((set? ptree)
         (let ((var (set-var ptree)) (val (pe (set-val ptree) consts)))
           (var-sets-set! var (set-remove (var-sets var) ptree))
           (new-set (node-source ptree) (node-decl ptree) var val)))
        ((tst? ptree)
         (let ((pre (pe (tst-pre ptree) consts)))
           (if (cst? pre)
               (let ((val (cst-val pre)))
                 (if (false-object? val)
                     (pe (tst-alt ptree) consts)
                     (pe (tst-con ptree) consts)))
               (new-tst (node-source ptree)
                        (node-decl ptree)
                        pre
                        (pe (tst-con ptree) consts)
                        (pe (tst-alt ptree) consts)))))
        ((conj? ptree)
         (let ((pre (pe (conj-pre ptree) consts)))
           (if (cst? pre)
               (let ((val (cst-val pre)))
                 (if (false-object? val) pre (pe (conj-alt ptree) consts)))
               (new-conj
                (node-source ptree)
                (node-decl ptree)
                pre
                (pe (conj-alt ptree) consts)))))
        ((disj? ptree)
         (let ((pre (pe (disj-pre ptree) consts)))
           (if (cst? pre)
               (let ((val (cst-val pre)))
                 (if (false-object? val) (pe (disj-alt ptree) consts) pre))
               (new-disj
                (node-source ptree)
                (node-decl ptree)
                pre
                (pe (disj-alt ptree) consts)))))
        ((prc? ptree)
         (new-prc (node-source ptree)
                  (node-decl ptree)
                  (prc-name ptree)
                  (prc-min ptree)
                  (prc-rest ptree)
                  (prc-parms ptree)
                  (pe (prc-body ptree) consts)))
        ((app? ptree)
         (let ((oper (app-oper ptree)) (args (app-args ptree)))
           (if (and (prc? oper)
                    (not (prc-rest oper))
                    (= (length (prc-parms oper)) (length args)))
               (pe-let ptree consts)
               (new-call
                (node-source ptree)
                (node-decl ptree)
                (pe oper consts)
                (map (lambda (x) (pe x consts)) args)))))
        ((fut? ptree)
         (new-fut (node-source ptree)
                  (node-decl ptree)
                  (pe (fut-val ptree) consts)))
        (else (compiler-internal-error "pe, unknown parse tree node type"))))
(define (pe-let ptree consts)
  (let* ((proc (app-oper ptree))
         (vals (app-args ptree))
         (vars (prc-parms proc))
         (non-mut-vars (set-keep not-mutable? (list->set vars))))
    (for-each
     (lambda (var)
       (var-refs-set! var (set-empty))
       (var-sets-set! var (set-empty)))
     vars)
    (let loop ((l vars)
               (v vals)
               (new-vars '())
               (new-vals '())
               (new-consts consts))
      (if (null? l)
          (if (null? new-vars)
              (pe (prc-body proc) new-consts)
              (new-call
               (node-source ptree)
               (node-decl ptree)
               (new-prc (node-source proc)
                        (node-decl proc)
                        #f
                        (length new-vars)
                        #f
                        (reverse new-vars)
                        (pe (prc-body proc) new-consts))
               (reverse new-vals)))
          (let ((var (car l)) (val (pe (car v) consts)))
            (if (and (set-member? var non-mut-vars) (cst? val))
                (loop (cdr l)
                      (cdr v)
                      new-vars
                      new-vals
                      (cons (cons var (cst-val val)) new-consts))
                (loop (cdr l)
                      (cdr v)
                      (cons var new-vars)
                      (cons val new-vals)
                      new-consts)))))))
(define (assignment-convert ptree env)
  (ac ptree (env-declare env (list safe-sym #f)) '()))
(define (ac ptree env mut)
  (cond ((cst? ptree) ptree)
        ((ref? ptree)
         (let ((var (ref-var ptree)))
           (if (global? var)
               ptree
               (let ((x (assq var mut)))
                 (if x
                     (let ((source (node-source ptree)))
                       (var-refs-set! var (set-remove (var-refs var) ptree))
                       (new-call
                        source
                        (node-decl ptree)
                        (new-ref-extended-bindings source **cell-ref-sym env)
                        (list (new-ref source (node-decl ptree) (cdr x)))))
                     ptree)))))
        ((set? ptree)
         (let ((var (set-var ptree))
               (source (node-source ptree))
               (val (ac (set-val ptree) env mut)))
           (var-sets-set! var (set-remove (var-sets var) ptree))
           (if (global? var)
               (new-set source (node-decl ptree) var val)
               (new-call
                source
                (node-decl ptree)
                (new-ref-extended-bindings source **cell-set!-sym env)
                (list (new-ref source (node-decl ptree) (cdr (assq var mut)))
                      val)))))
        ((tst? ptree)
         (new-tst (node-source ptree)
                  (node-decl ptree)
                  (ac (tst-pre ptree) env mut)
                  (ac (tst-con ptree) env mut)
                  (ac (tst-alt ptree) env mut)))
        ((conj? ptree)
         (new-conj
          (node-source ptree)
          (node-decl ptree)
          (ac (conj-pre ptree) env mut)
          (ac (conj-alt ptree) env mut)))
        ((disj? ptree)
         (new-disj
          (node-source ptree)
          (node-decl ptree)
          (ac (disj-pre ptree) env mut)
          (ac (disj-alt ptree) env mut)))
        ((prc? ptree) (ac-proc ptree env mut))
        ((app? ptree)
         (let ((oper (app-oper ptree)) (args (app-args ptree)))
           (if (and (prc? oper)
                    (not (prc-rest oper))
                    (= (length (prc-parms oper)) (length args)))
               (ac-let ptree env mut)
               (new-call
                (node-source ptree)
                (node-decl ptree)
                (ac oper env mut)
                (map (lambda (x) (ac x env mut)) args)))))
        ((fut? ptree)
         (new-fut (node-source ptree)
                  (node-decl ptree)
                  (ac (fut-val ptree) env mut)))
        (else (compiler-internal-error "ac, unknown parse tree node type"))))
(define (ac-proc ptree env mut)
  (let* ((mut-parms (ac-mutables (prc-parms ptree)))
         (mut-parms-copies (map var-copy mut-parms))
         (mut (append (pair-up mut-parms mut-parms-copies) mut))
         (new-body (ac (prc-body ptree) env mut)))
    (new-prc (node-source ptree)
             (node-decl ptree)
             (prc-name ptree)
             (prc-min ptree)
             (prc-rest ptree)
             (prc-parms ptree)
             (if (null? mut-parms)
                 new-body
                 (new-call
                  (node-source ptree)
                  (node-decl ptree)
                  (new-prc (node-source ptree)
                           (node-decl ptree)
                           #f
                           (length mut-parms-copies)
                           #f
                           mut-parms-copies
                           new-body)
                  (map (lambda (var)
                         (new-call
                          (var-source var)
                          (node-decl ptree)
                          (new-ref-extended-bindings
                           (var-source var)
                           **make-cell-sym
                           env)
                          (list (new-ref (var-source var)
                                         (node-decl ptree)
                                         var))))
                       mut-parms))))))
(define (ac-let ptree env mut)
  (let* ((proc (app-oper ptree))
         (vals (app-args ptree))
         (vars (prc-parms proc))
         (vals-fv (apply set-union (map free-variables vals)))
         (mut-parms (ac-mutables vars))
         (mut-parms-copies (map var-copy mut-parms))
         (mut (append (pair-up mut-parms mut-parms-copies) mut)))
    (let loop ((l vars)
               (v vals)
               (new-vars '())
               (new-vals '())
               (new-body (ac (prc-body proc) env mut)))
      (if (null? l)
          (new-let ptree proc new-vars new-vals new-body)
          (let ((var (car l)) (val (car v)))
            (if (memq var mut-parms)
                (let ((src (node-source val))
                      (decl (node-decl val))
                      (var* (cdr (assq var mut))))
                  (if (set-member? var vals-fv)
                      (loop (cdr l)
                            (cdr v)
                            (cons var* new-vars)
                            (cons (new-call
                                   src
                                   decl
                                   (new-ref-extended-bindings
                                    src
                                    **make-cell-sym
                                    env)
                                   (list (new-cst src decl undef-object)))
                                  new-vals)
                            (new-seq src
                                     decl
                                     (new-call
                                      src
                                      decl
                                      (new-ref-extended-bindings
                                       src
                                       **cell-set!-sym
                                       env)
                                      (list (new-ref src decl var*)
                                            (ac val env mut)))
                                     new-body))
                      (loop (cdr l)
                            (cdr v)
                            (cons var* new-vars)
                            (cons (new-call
                                   src
                                   decl
                                   (new-ref-extended-bindings
                                    src
                                    **make-cell-sym
                                    env)
                                   (list (ac val env mut)))
                                  new-vals)
                            new-body)))
                (loop (cdr l)
                      (cdr v)
                      (cons var new-vars)
                      (cons (ac val env mut) new-vals)
                      new-body)))))))
(define (ac-mutables l)
  (if (pair? l)
      (let ((var (car l)) (rest (ac-mutables (cdr l))))
        (if (mutable? var) (cons var rest) rest))
      '()))
(define (lambda-lift! ptree) (ll! ptree (set-empty) '()))
(define (ll! ptree cst-procs env)
  (define (new-env env vars)
    (define (loop i l)
      (if (pair? l)
          (let ((var (car l)))
            (cons (cons var (cons (length (set->list (var-refs var))) i))
                  (loop (+ i 1) (cdr l))))
          env))
    (loop (length env) vars))
  (cond ((or (cst? ptree)
             (ref? ptree)
             (set? ptree)
             (tst? ptree)
             (conj? ptree)
             (disj? ptree)
             (fut? ptree))
         (for-each
          (lambda (child) (ll! child cst-procs env))
          (node-children ptree)))
        ((prc? ptree)
         (ll! (prc-body ptree) cst-procs (new-env env (prc-parms ptree))))
        ((app? ptree)
         (let ((oper (app-oper ptree)) (args (app-args ptree)))
           (if (and (prc? oper)
                    (not (prc-rest oper))
                    (= (length (prc-parms oper)) (length args)))
               (ll!-let ptree cst-procs (new-env env (prc-parms oper)))
               (for-each
                (lambda (child) (ll! child cst-procs env))
                (node-children ptree)))))
        (else (compiler-internal-error "ll!, unknown parse tree node type"))))
(define (ll!-let ptree cst-procs env)
  (let* ((proc (app-oper ptree))
         (vals (app-args ptree))
         (vars (prc-parms proc))
         (var-val-map (pair-up vars vals)))
    (define (var->val var) (cdr (assq var var-val-map)))
    (define (liftable-proc-vars vars)
      (let loop ((cst-proc-vars
                  (set-keep
                   (lambda (var)
                     (let ((val (var->val var)))
                       (and (prc? val)
                            (lambda-lift? (node-decl val))
                            (set-every? oper-pos? (var-refs var)))))
                   (list->set vars))))
        (let* ((non-cst-proc-vars
                (set-keep
                 (lambda (var)
                   (let ((val (var->val var)))
                     (and (prc? val) (not (set-member? var cst-proc-vars)))))
                 (list->set vars)))
               (cst-proc-vars*
                (set-keep
                 (lambda (var)
                   (let ((val (var->val var)))
                     (set-empty?
                      (set-intersection
                       (free-variables val)
                       non-cst-proc-vars))))
                 cst-proc-vars)))
          (if (set-equal? cst-proc-vars cst-proc-vars*)
              cst-proc-vars
              (loop cst-proc-vars*)))))
    (define (transitively-closed-free-variables vars)
      (let ((tcfv-map
             (map (lambda (var) (cons var (free-variables (var->val var))))
                  vars)))
        (let loop ((changed? #f))
          (for-each
           (lambda (var-tcfv)
             (let loop2 ((l (set->list (cdr var-tcfv))) (fv (cdr var-tcfv)))
               (if (null? l)
                   (if (not (set-equal? fv (cdr var-tcfv)))
                       (begin (set-cdr! var-tcfv fv) (set! changed? #t)))
                   (let ((x (assq (car l) tcfv-map)))
                     (loop2 (cdr l) (if x (set-union fv (cdr x)) fv))))))
           tcfv-map)
          (if changed? (loop #f) tcfv-map))))
    (let* ((tcfv-map
            (transitively-closed-free-variables (liftable-proc-vars vars)))
           (cst-proc-vars-list (map car tcfv-map))
           (cst-procs* (set-union (list->set cst-proc-vars-list) cst-procs)))
      (define (var->tcfv var) (cdr (assq var tcfv-map)))
      (define (order-vars vars)
        (map car
             (sort-list
              (map (lambda (var) (assq var env)) vars)
              (lambda (x y)
                (if (= (cadr x) (cadr y))
                    (< (cddr x) (cddr y))
                    (< (cadr x) (cadr y)))))))
      (define (lifted-vars var)
        (order-vars (set->list (set-difference (var->tcfv var) cst-procs*))))
      (define (lift-app! var)
        (let* ((val (var->val var)) (vars (lifted-vars var)))
          (define (new-ref* var)
            (new-ref (var-source var) (node-decl val) var))
          (if (not (null? vars))
              (for-each
               (lambda (oper)
                 (let ((node (node-parent oper)))
                   (node-children-set!
                    node
                    (cons (app-oper node)
                          (append (map new-ref* vars) (app-args node))))))
               (set->list (var-refs var))))))
      (define (lift-prc! var)
        (let* ((val (var->val var)) (vars (lifted-vars var)))
          (if (not (null? vars))
              (let ((var-copies (map var-copy vars)))
                (prc-parms-set! val (append var-copies (prc-parms val)))
                (for-each (lambda (x) (var-bound-set! x val)) var-copies)
                (node-fv-invalidate! val)
                (prc-min-set! val (+ (prc-min val) (length vars)))
                (ll-rename! val (pair-up vars var-copies))))))
      (for-each lift-app! cst-proc-vars-list)
      (for-each lift-prc! cst-proc-vars-list)
      (for-each (lambda (node) (ll! node cst-procs* env)) vals)
      (ll! (prc-body proc) cst-procs* env))))
(define (ll-rename! ptree var-map)
  (cond ((ref? ptree)
         (let* ((var (ref-var ptree)) (x (assq var var-map)))
           (if x
               (begin
                 (var-refs-set! var (set-remove (var-refs var) ptree))
                 (var-refs-set! (cdr x) (set-adjoin (var-refs (cdr x)) ptree))
                 (ref-var-set! ptree (cdr x))))))
        ((set? ptree)
         (let* ((var (set-var ptree)) (x (assq var var-map)))
           (if x
               (begin
                 (var-sets-set! var (set-remove (var-sets var) ptree))
                 (var-sets-set! (cdr x) (set-adjoin (var-sets (cdr x)) ptree))
                 (set-var-set! ptree (cdr x)))))))
  (node-fv-set! ptree #t)
  (for-each (lambda (child) (ll-rename! child var-map)) (node-children ptree)))
(define (parse-tree->expression ptree) (se ptree '() (list 0)))
(define (se ptree env num)
  (cond ((cst? ptree) (list quote-sym (cst-val ptree)))
        ((ref? ptree)
         (let ((x (assq (ref-var ptree) env)))
           (if x (cdr x) (var-name (ref-var ptree)))))
        ((set? ptree)
         (list set!-sym
               (let ((x (assq (set-var ptree) env)))
                 (if x (cdr x) (var-name (set-var ptree))))
               (se (set-val ptree) env num)))
        ((def? ptree)
         (list define-sym
               (let ((x (assq (def-var ptree) env)))
                 (if x (cdr x) (var-name (def-var ptree))))
               (se (def-val ptree) env num)))
        ((tst? ptree)
         (list if-sym
               (se (tst-pre ptree) env num)
               (se (tst-con ptree) env num)
               (se (tst-alt ptree) env num)))
        ((conj? ptree)
         (list and-sym
               (se (conj-pre ptree) env num)
               (se (conj-alt ptree) env num)))
        ((disj? ptree)
         (list or-sym
               (se (disj-pre ptree) env num)
               (se (disj-alt ptree) env num)))
        ((prc? ptree)
         (let ((new-env (se-rename (prc-parms ptree) env num)))
           (list lambda-sym
                 (se-parameters
                  (prc-parms ptree)
                  (prc-rest ptree)
                  (prc-min ptree)
                  new-env)
                 (se (prc-body ptree) new-env num))))
        ((app? ptree)
         (let ((oper (app-oper ptree)) (args (app-args ptree)))
           (if (and (prc? oper)
                    (not (prc-rest oper))
                    (= (length (prc-parms oper)) (length args)))
               (let ((new-env (se-rename (prc-parms oper) env num)))
                 (list (if (set-empty?
                            (set-intersection
                             (list->set (prc-parms oper))
                             (apply set-union (map free-variables args))))
                           let-sym
                           letrec-sym)
                       (se-bindings (prc-parms oper) args new-env num)
                       (se (prc-body oper) new-env num)))
               (map (lambda (x) (se x env num)) (cons oper args)))))
        ((fut? ptree) (list future-sym (se (fut-val ptree) env num)))
        (else (compiler-internal-error "se, unknown parse tree node type"))))
(define (se-parameters parms rest min env)
  (define (se-parms parms rest n env)
    (cond ((null? parms) '())
          ((and rest (null? (cdr parms))) (cdr (assq (car parms) env)))
          (else
           (let ((parm (cdr (assq (car parms) env))))
             (cons (if (> n 0) parm (list parm))
                   (se-parms (cdr parms) rest (- n 1) env))))))
  (se-parms parms rest min env))
(define (se-bindings vars vals env num)
  (if (null? vars)
      '()
      (cons (list (cdr (assq (car vars) env)) (se (car vals) env num))
            (se-bindings (cdr vars) (cdr vals) env num))))
(define (se-rename vars env num)
  (define (rename vars)
    (if (null? vars)
        env
        (cons (cons (car vars)
                    (string->canonical-symbol
                     (string-append
                      (symbol->string (var-name (car vars)))
                      "#"
                      (number->string (car num)))))
              (rename (cdr vars)))))
  (set-car! num (+ (car num) 1))
  (rename vars))
(define *opnd-table* '())
(define *opnd-table-alloc* '())
(define opnd-table-size 10000)
(define (enter-opnd arg1 arg2)
  (let loop ((i 0))
    (if (< i *opnd-table-alloc*)
        (let ((x (vector-ref *opnd-table* i)))
          (if (and (eqv? (car x) arg1) (eqv? (cdr x) arg2)) i (loop (+ i 1))))
        (if (< *opnd-table-alloc* opnd-table-size)
            (begin
              (set! *opnd-table-alloc* (+ *opnd-table-alloc* 1))
              (vector-set! *opnd-table* i (cons arg1 arg2))
              i)
            (compiler-limitation-error
             "program is too long [virtual machine operand table overflow]")))))
(define (contains-opnd? opnd1 opnd2)
  (cond ((eqv? opnd1 opnd2) #t)
        ((clo? opnd2) (contains-opnd? opnd1 (clo-base opnd2)))
        (else #f)))
(define (any-contains-opnd? opnd opnds)
  (if (null? opnds)
      #f
      (or (contains-opnd? opnd (car opnds))
          (any-contains-opnd? opnd (cdr opnds)))))
(define (make-reg num) num)
(define (reg? x) (< x 10000))
(define (reg-num x) (modulo x 10000))
(define (make-stk num) (+ num 10000))
(define (stk? x) (= (quotient x 10000) 1))
(define (stk-num x) (modulo x 10000))
(define (make-glo name) (+ (enter-opnd name #t) 30000))
(define (glo? x) (= (quotient x 10000) 3))
(define (glo-name x) (car (vector-ref *opnd-table* (modulo x 10000))))
(define (make-clo base index) (+ (enter-opnd base index) 40000))
(define (clo? x) (= (quotient x 10000) 4))
(define (clo-base x) (car (vector-ref *opnd-table* (modulo x 10000))))
(define (clo-index x) (cdr (vector-ref *opnd-table* (modulo x 10000))))
(define (make-lbl num) (+ num 20000))
(define (lbl? x) (= (quotient x 10000) 2))
(define (lbl-num x) (modulo x 10000))
(define label-limit 9999)
(define (make-obj val) (+ (enter-opnd val #f) 50000))
(define (obj? x) (= (quotient x 10000) 5))
(define (obj-val x) (car (vector-ref *opnd-table* (modulo x 10000))))
(define (make-pcontext fs map) (vector fs map))
(define (pcontext-fs x) (vector-ref x 0))
(define (pcontext-map x) (vector-ref x 1))
(define (make-frame size slots regs closed live)
  (vector size slots regs closed live))
(define (frame-size x) (vector-ref x 0))
(define (frame-slots x) (vector-ref x 1))
(define (frame-regs x) (vector-ref x 2))
(define (frame-closed x) (vector-ref x 3))
(define (frame-live x) (vector-ref x 4))
(define (frame-eq? x y) (= (frame-size x) (frame-size y)))
(define (frame-truncate frame nb-slots)
  (let ((fs (frame-size frame)))
    (make-frame
     nb-slots
     (nth-after (frame-slots frame) (- fs nb-slots))
     (frame-regs frame)
     (frame-closed frame)
     (frame-live frame))))
(define (frame-live? var frame)
  (let ((live (frame-live frame)))
    (if (eq? var closure-env-var)
        (let ((closed (frame-closed frame)))
          (if (or (set-member? var live)
                  (not (set-empty?
                        (set-intersection live (list->set closed)))))
              closed
              #f))
        (if (set-member? var live) var #f))))
(define (frame-first-empty-slot frame)
  (let loop ((i 1) (s (reverse (frame-slots frame))))
    (if (pair? s)
        (if (frame-live? (car s) frame) (loop (+ i 1) (cdr s)) i)
        i)))
(define (make-proc-obj
         name
         primitive?
         code
         call-pat
         side-effects?
         strict-pat
         type)
  (let ((proc-obj
         (vector proc-obj-tag
                 name
                 primitive?
                 code
                 call-pat
                 #f
                 #f
                 #f
                 side-effects?
                 strict-pat
                 type)))
    (proc-obj-specialize-set! proc-obj (lambda (decls) proc-obj))
    proc-obj))
(define proc-obj-tag (list 'proc-obj))
(define (proc-obj? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) proc-obj-tag)))
(define (proc-obj-name obj) (vector-ref obj 1))
(define (proc-obj-primitive? obj) (vector-ref obj 2))
(define (proc-obj-code obj) (vector-ref obj 3))
(define (proc-obj-call-pat obj) (vector-ref obj 4))
(define (proc-obj-test obj) (vector-ref obj 5))
(define (proc-obj-inlinable obj) (vector-ref obj 6))
(define (proc-obj-specialize obj) (vector-ref obj 7))
(define (proc-obj-side-effects? obj) (vector-ref obj 8))
(define (proc-obj-strict-pat obj) (vector-ref obj 9))
(define (proc-obj-type obj) (vector-ref obj 10))
(define (proc-obj-code-set! obj x) (vector-set! obj 3 x))
(define (proc-obj-test-set! obj x) (vector-set! obj 5 x))
(define (proc-obj-inlinable-set! obj x) (vector-set! obj 6 x))
(define (proc-obj-specialize-set! obj x) (vector-set! obj 7 x))
(define (make-pattern min-args nb-parms rest?)
  (let loop ((x (if rest? (- nb-parms 1) (list nb-parms)))
             (y (if rest? (- nb-parms 1) nb-parms)))
    (let ((z (- y 1))) (if (< z min-args) x (loop (cons z x) z)))))
(define (pattern-member? n pat)
  (cond ((pair? pat) (if (= (car pat) n) #t (pattern-member? n (cdr pat))))
        ((null? pat) #f)
        (else (<= pat n))))
(define (type-name type) (if (pair? type) (car type) type))
(define (type-pot-fut? type) (pair? type))
(define (make-bbs)
  (vector (make-counter 1 label-limit bbs-limit-err) (queue-empty) '()))
(define (bbs-limit-err)
  (compiler-limitation-error "procedure is too long [too many labels]"))
(define (bbs-lbl-counter bbs) (vector-ref bbs 0))
(define (bbs-lbl-counter-set! bbs cntr) (vector-set! bbs 0 cntr))
(define (bbs-bb-queue bbs) (vector-ref bbs 1))
(define (bbs-bb-queue-set! bbs bbq) (vector-set! bbs 1 bbq))
(define (bbs-entry-lbl-num bbs) (vector-ref bbs 2))
(define (bbs-entry-lbl-num-set! bbs lbl-num) (vector-set! bbs 2 lbl-num))
(define (bbs-new-lbl! bbs) ((bbs-lbl-counter bbs)))
(define (lbl-num->bb lbl-num bbs)
  (let loop ((bb-list (queue->list (bbs-bb-queue bbs))))
    (if (= (bb-lbl-num (car bb-list)) lbl-num)
        (car bb-list)
        (loop (cdr bb-list)))))
(define (make-bb label-instr bbs)
  (let ((bb (vector label-instr (queue-empty) '() '() '())))
    (queue-put! (vector-ref bbs 1) bb)
    bb))
(define (bb-lbl-num bb) (label-lbl-num (vector-ref bb 0)))
(define (bb-label-type bb) (label-type (vector-ref bb 0)))
(define (bb-label-instr bb) (vector-ref bb 0))
(define (bb-label-instr-set! bb l) (vector-set! bb 0 l))
(define (bb-non-branch-instrs bb) (queue->list (vector-ref bb 1)))
(define (bb-non-branch-instrs-set! bb l) (vector-set! bb 1 (list->queue l)))
(define (bb-branch-instr bb) (vector-ref bb 2))
(define (bb-branch-instr-set! bb b) (vector-set! bb 2 b))
(define (bb-references bb) (vector-ref bb 3))
(define (bb-references-set! bb l) (vector-set! bb 3 l))
(define (bb-precedents bb) (vector-ref bb 4))
(define (bb-precedents-set! bb l) (vector-set! bb 4 l))
(define (bb-entry-frame-size bb)
  (frame-size (gvm-instr-frame (bb-label-instr bb))))
(define (bb-exit-frame-size bb)
  (frame-size (gvm-instr-frame (bb-branch-instr bb))))
(define (bb-slots-gained bb)
  (- (bb-exit-frame-size bb) (bb-entry-frame-size bb)))
(define (bb-put-non-branch! bb gvm-instr)
  (queue-put! (vector-ref bb 1) gvm-instr))
(define (bb-put-branch! bb gvm-instr) (vector-set! bb 2 gvm-instr))
(define (bb-add-reference! bb ref)
  (if (not (memq ref (vector-ref bb 3)))
      (vector-set! bb 3 (cons ref (vector-ref bb 3)))))
(define (bb-add-precedent! bb prec)
  (if (not (memq prec (vector-ref bb 4)))
      (vector-set! bb 4 (cons prec (vector-ref bb 4)))))
(define (bb-last-non-branch-instr bb)
  (let ((non-branch-instrs (bb-non-branch-instrs bb)))
    (if (null? non-branch-instrs)
        (bb-label-instr bb)
        (let loop ((l non-branch-instrs))
          (if (pair? (cdr l)) (loop (cdr l)) (car l))))))
(define (gvm-instr-type gvm-instr) (vector-ref gvm-instr 0))
(define (gvm-instr-frame gvm-instr) (vector-ref gvm-instr 1))
(define (gvm-instr-comment gvm-instr) (vector-ref gvm-instr 2))
(define (make-label-simple lbl-num frame comment)
  (vector 'label frame comment lbl-num 'simple))
(define (make-label-entry lbl-num nb-parms min rest? closed? frame comment)
  (vector 'label frame comment lbl-num 'entry nb-parms min rest? closed?))
(define (make-label-return lbl-num frame comment)
  (vector 'label frame comment lbl-num 'return))
(define (make-label-task-entry lbl-num frame comment)
  (vector 'label frame comment lbl-num 'task-entry))
(define (make-label-task-return lbl-num frame comment)
  (vector 'label frame comment lbl-num 'task-return))
(define (label-lbl-num gvm-instr) (vector-ref gvm-instr 3))
(define (label-lbl-num-set! gvm-instr n) (vector-set! gvm-instr 3 n))
(define (label-type gvm-instr) (vector-ref gvm-instr 4))
(define (label-entry-nb-parms gvm-instr) (vector-ref gvm-instr 5))
(define (label-entry-min gvm-instr) (vector-ref gvm-instr 6))
(define (label-entry-rest? gvm-instr) (vector-ref gvm-instr 7))
(define (label-entry-closed? gvm-instr) (vector-ref gvm-instr 8))
(define (make-apply prim opnds loc frame comment)
  (vector 'apply frame comment prim opnds loc))
(define (apply-prim gvm-instr) (vector-ref gvm-instr 3))
(define (apply-opnds gvm-instr) (vector-ref gvm-instr 4))
(define (apply-loc gvm-instr) (vector-ref gvm-instr 5))
(define (make-copy opnd loc frame comment)
  (vector 'copy frame comment opnd loc))
(define (copy-opnd gvm-instr) (vector-ref gvm-instr 3))
(define (copy-loc gvm-instr) (vector-ref gvm-instr 4))
(define (make-close parms frame comment) (vector 'close frame comment parms))
(define (close-parms gvm-instr) (vector-ref gvm-instr 3))
(define (make-closure-parms loc lbl opnds) (vector loc lbl opnds))
(define (closure-parms-loc x) (vector-ref x 0))
(define (closure-parms-lbl x) (vector-ref x 1))
(define (closure-parms-opnds x) (vector-ref x 2))
(define (make-ifjump test opnds true false poll? frame comment)
  (vector 'ifjump frame comment test opnds true false poll?))
(define (ifjump-test gvm-instr) (vector-ref gvm-instr 3))
(define (ifjump-opnds gvm-instr) (vector-ref gvm-instr 4))
(define (ifjump-true gvm-instr) (vector-ref gvm-instr 5))
(define (ifjump-false gvm-instr) (vector-ref gvm-instr 6))
(define (ifjump-poll? gvm-instr) (vector-ref gvm-instr 7))
(define (make-jump opnd nb-args poll? frame comment)
  (vector 'jump frame comment opnd nb-args poll?))
(define (jump-opnd gvm-instr) (vector-ref gvm-instr 3))
(define (jump-nb-args gvm-instr) (vector-ref gvm-instr 4))
(define (jump-poll? gvm-instr) (vector-ref gvm-instr 5))
(define (first-class-jump? gvm-instr) (jump-nb-args gvm-instr))
(define (make-comment) (cons 'comment '()))
(define (comment-put! comment name val)
  (set-cdr! comment (cons (cons name val) (cdr comment))))
(define (comment-get comment name)
  (and comment (let ((x (assq name (cdr comment)))) (if x (cdr x) #f))))
(define (bbs-purify! bbs)
  (let loop ()
    (bbs-remove-jump-cascades! bbs)
    (bbs-remove-dead-code! bbs)
    (let* ((changed1? (bbs-remove-common-code! bbs))
           (changed2? (bbs-remove-useless-jumps! bbs)))
      (if (or changed1? changed2?) (loop) (bbs-order! bbs)))))
(define (bbs-remove-jump-cascades! bbs)
  (define (empty-bb? bb)
    (and (eq? (bb-label-type bb) 'simple) (null? (bb-non-branch-instrs bb))))
  (define (jump-to-non-entry-lbl? branch)
    (and (eq? (gvm-instr-type branch) 'jump)
         (not (first-class-jump? branch))
         (jump-lbl? branch)))
  (define (jump-cascade-to lbl-num fs poll? seen thunk)
    (if (memq lbl-num seen)
        (thunk lbl-num fs poll?)
        (let ((bb (lbl-num->bb lbl-num bbs)))
          (if (and (empty-bb? bb) (<= (bb-slots-gained bb) 0))
              (let ((jump-lbl-num
                     (jump-to-non-entry-lbl? (bb-branch-instr bb))))
                (if jump-lbl-num
                    (jump-cascade-to
                     jump-lbl-num
                     (+ fs (bb-slots-gained bb))
                     (or poll? (jump-poll? (bb-branch-instr bb)))
                     (cons lbl-num seen)
                     thunk)
                    (thunk lbl-num fs poll?)))
              (thunk lbl-num fs poll?)))))
  (define (equiv-lbl lbl-num seen)
    (if (memq lbl-num seen)
        lbl-num
        (let ((bb (lbl-num->bb lbl-num bbs)))
          (if (empty-bb? bb)
              (let ((jump-lbl-num
                     (jump-to-non-entry-lbl? (bb-branch-instr bb))))
                (if (and jump-lbl-num
                         (not (jump-poll? (bb-branch-instr bb)))
                         (= (bb-slots-gained bb) 0))
                    (equiv-lbl jump-lbl-num (cons lbl-num seen))
                    lbl-num))
              lbl-num))))
  (define (remove-cascade! bb)
    (let ((branch (bb-branch-instr bb)))
      (case (gvm-instr-type branch)
        ((ifjump)
         (bb-put-branch!
          bb
          (make-ifjump
           (ifjump-test branch)
           (ifjump-opnds branch)
           (equiv-lbl (ifjump-true branch) '())
           (equiv-lbl (ifjump-false branch) '())
           (ifjump-poll? branch)
           (gvm-instr-frame branch)
           (gvm-instr-comment branch))))
        ((jump)
         (if (not (first-class-jump? branch))
             (let ((dest-lbl-num (jump-lbl? branch)))
               (if dest-lbl-num
                   (jump-cascade-to
                    dest-lbl-num
                    (frame-size (gvm-instr-frame branch))
                    (jump-poll? branch)
                    '()
                    (lambda (lbl-num fs poll?)
                      (let* ((dest-bb (lbl-num->bb lbl-num bbs))
                             (last-branch (bb-branch-instr dest-bb)))
                        (if (and (empty-bb? dest-bb)
                                 (or (not poll?)
                                     put-poll-on-ifjump?
                                     (not (eq? (gvm-instr-type last-branch)
                                               'ifjump))))
                            (let* ((new-fs (+ fs (bb-slots-gained dest-bb)))
                                   (new-frame
                                    (frame-truncate
                                     (gvm-instr-frame branch)
                                     new-fs)))
                              (define (adjust-opnd opnd)
                                (cond ((stk? opnd)
                                       (make-stk
                                        (+ (- fs (bb-entry-frame-size dest-bb))
                                           (stk-num opnd))))
                                      ((clo? opnd)
                                       (make-clo
                                        (adjust-opnd (clo-base opnd))
                                        (clo-index opnd)))
                                      (else opnd)))
                              (case (gvm-instr-type last-branch)
                                ((ifjump)
                                 (bb-put-branch!
                                  bb
                                  (make-ifjump
                                   (ifjump-test last-branch)
                                   (map adjust-opnd (ifjump-opnds last-branch))
                                   (equiv-lbl (ifjump-true last-branch) '())
                                   (equiv-lbl (ifjump-false last-branch) '())
                                   (or poll? (ifjump-poll? last-branch))
                                   new-frame
                                   (gvm-instr-comment last-branch))))
                                ((jump)
                                 (bb-put-branch!
                                  bb
                                  (make-jump
                                   (adjust-opnd (jump-opnd last-branch))
                                   (jump-nb-args last-branch)
                                   (or poll? (jump-poll? last-branch))
                                   new-frame
                                   (gvm-instr-comment last-branch))))
                                (else
                                 (compiler-internal-error
                                  "bbs-remove-jump-cascades!, unknown branch type"))))
                            (bb-put-branch!
                             bb
                             (make-jump
                              (make-lbl lbl-num)
                              (jump-nb-args branch)
                              (or poll? (jump-poll? branch))
                              (frame-truncate (gvm-instr-frame branch) fs)
                              (gvm-instr-comment branch)))))))))))
        (else
         (compiler-internal-error
          "bbs-remove-jump-cascades!, unknown branch type")))))
  (for-each remove-cascade! (queue->list (bbs-bb-queue bbs))))
(define (jump-lbl? branch)
  (let ((opnd (jump-opnd branch))) (if (lbl? opnd) (lbl-num opnd) #f)))
(define put-poll-on-ifjump? #f)
(set! put-poll-on-ifjump? #t)
(define (bbs-remove-dead-code! bbs)
  (let ((new-bb-queue (queue-empty)) (scan-queue (queue-empty)))
    (define (reachable ref bb)
      (if bb (bb-add-reference! bb ref))
      (if (not (memq ref (queue->list new-bb-queue)))
          (begin
            (bb-references-set! ref '())
            (bb-precedents-set! ref '())
            (queue-put! new-bb-queue ref)
            (queue-put! scan-queue ref))))
    (define (direct-jump to-bb from-bb)
      (reachable to-bb from-bb)
      (bb-add-precedent! to-bb from-bb))
    (define (scan-instr gvm-instr bb)
      (define (scan-opnd gvm-opnd)
        (cond ((lbl? gvm-opnd)
               (reachable (lbl-num->bb (lbl-num gvm-opnd) bbs) bb))
              ((clo? gvm-opnd) (scan-opnd (clo-base gvm-opnd)))))
      (case (gvm-instr-type gvm-instr)
        ((label) '())
        ((apply)
         (for-each scan-opnd (apply-opnds gvm-instr))
         (if (apply-loc gvm-instr) (scan-opnd (apply-loc gvm-instr))))
        ((copy)
         (scan-opnd (copy-opnd gvm-instr))
         (scan-opnd (copy-loc gvm-instr)))
        ((close)
         (for-each
          (lambda (parm)
            (reachable (lbl-num->bb (closure-parms-lbl parm) bbs) bb)
            (scan-opnd (closure-parms-loc parm))
            (for-each scan-opnd (closure-parms-opnds parm)))
          (close-parms gvm-instr)))
        ((ifjump)
         (for-each scan-opnd (ifjump-opnds gvm-instr))
         (direct-jump (lbl-num->bb (ifjump-true gvm-instr) bbs) bb)
         (direct-jump (lbl-num->bb (ifjump-false gvm-instr) bbs) bb))
        ((jump)
         (let ((opnd (jump-opnd gvm-instr)))
           (if (lbl? opnd)
               (direct-jump (lbl-num->bb (lbl-num opnd) bbs) bb)
               (scan-opnd (jump-opnd gvm-instr)))))
        (else
         (compiler-internal-error
          "bbs-remove-dead-code!, unknown GVM instruction type"))))
    (reachable (lbl-num->bb (bbs-entry-lbl-num bbs) bbs) #f)
    (let loop ()
      (if (not (queue-empty? scan-queue))
          (let ((bb (queue-get! scan-queue)))
            (begin
              (scan-instr (bb-label-instr bb) bb)
              (for-each
               (lambda (gvm-instr) (scan-instr gvm-instr bb))
               (bb-non-branch-instrs bb))
              (scan-instr (bb-branch-instr bb) bb)
              (loop)))))
    (bbs-bb-queue-set! bbs new-bb-queue)))
(define (bbs-remove-useless-jumps! bbs)
  (let ((changed? #f))
    (define (remove-useless-jump bb)
      (let ((branch (bb-branch-instr bb)))
        (if (and (eq? (gvm-instr-type branch) 'jump)
                 (not (first-class-jump? branch))
                 (not (jump-poll? branch))
                 (jump-lbl? branch))
            (let* ((dest-bb (lbl-num->bb (jump-lbl? branch) bbs))
                   (frame1 (gvm-instr-frame (bb-last-non-branch-instr bb)))
                   (frame2 (gvm-instr-frame (bb-label-instr dest-bb))))
              (if (and (eq? (bb-label-type dest-bb) 'simple)
                       (frame-eq? frame1 frame2)
                       (= (length (bb-precedents dest-bb)) 1))
                  (begin
                    (set! changed? #t)
                    (bb-non-branch-instrs-set!
                     bb
                     (append (bb-non-branch-instrs bb)
                             (bb-non-branch-instrs dest-bb)
                             '()))
                    (bb-branch-instr-set! bb (bb-branch-instr dest-bb))
                    (remove-useless-jump bb)))))))
    (for-each remove-useless-jump (queue->list (bbs-bb-queue bbs)))
    changed?))
(define (bbs-remove-common-code! bbs)
  (let* ((bb-list (queue->list (bbs-bb-queue bbs)))
         (n (length bb-list))
         (hash-table-length (cond ((< n 50) 43) ((< n 500) 403) (else 4003)))
         (hash-table (make-vector hash-table-length '()))
         (prim-table '())
         (block-map '())
         (changed? #f))
    (define (hash-prim prim)
      (let ((n (length prim-table)) (i (pos-in-list prim prim-table)))
        (if i
            (- n i)
            (begin (set! prim-table (cons prim prim-table)) (+ n 1)))))
    (define (hash-opnds l)
      (let loop ((l l) (n 0))
        (if (pair? l)
            (loop (cdr l)
                  (let ((x (car l)))
                    (if (lbl? x)
                        n
                        (modulo (+ (* n 10000) x) hash-table-length))))
            n)))
    (define (hash-bb bb)
      (let ((branch (bb-branch-instr bb)))
        (modulo (case (gvm-instr-type branch)
                  ((ifjump)
                   (+ (hash-opnds (ifjump-opnds branch))
                      (* 10 (hash-prim (ifjump-test branch)))
                      (* 100 (frame-size (gvm-instr-frame branch)))))
                  ((jump)
                   (+ (hash-opnds (list (jump-opnd branch)))
                      (* 10 (or (jump-nb-args branch) -1))
                      (* 100 (frame-size (gvm-instr-frame branch)))))
                  (else 0))
                hash-table-length)))
    (define (replacement-lbl-num lbl)
      (let ((x (assv lbl block-map))) (if x (cdr x) lbl)))
    (define (fix-map! bb1 bb2)
      (let loop ((l block-map))
        (if (pair? l)
            (let ((x (car l)))
              (if (= bb1 (cdr x)) (set-cdr! x bb2))
              (loop (cdr l))))))
    (define (enter-bb! bb)
      (let ((h (hash-bb bb)))
        (vector-set! hash-table h (add-bb bb (vector-ref hash-table h)))))
    (define (add-bb bb l)
      (if (pair? l)
          (let ((bb* (car l)))
            (set! block-map
                  (cons (cons (bb-lbl-num bb) (bb-lbl-num bb*)) block-map))
            (if (eqv-bb? bb bb*)
                (begin
                  (fix-map! (bb-lbl-num bb) (bb-lbl-num bb*))
                  (set! changed? #t)
                  l)
                (begin
                  (set! block-map (cdr block-map))
                  (if (eqv-gvm-instr?
                       (bb-branch-instr bb)
                       (bb-branch-instr bb*))
                      (extract-common-tail
                       bb
                       bb*
                       (lambda (head head* tail)
                         (if (null? tail)
                             (cons bb* (add-bb bb (cdr l)))
                             (let* ((lbl (bbs-new-lbl! bbs))
                                    (branch (bb-branch-instr bb))
                                    (fs** (need-gvm-instrs tail branch))
                                    (frame (frame-truncate
                                            (gvm-instr-frame
                                             (if (null? head)
                                                 (bb-label-instr bb)
                                                 (car head)))
                                            fs**))
                                    (bb** (make-bb (make-label-simple
                                                    lbl
                                                    frame
                                                    #f)
                                                   bbs)))
                               (bb-non-branch-instrs-set! bb** tail)
                               (bb-branch-instr-set! bb** branch)
                               (bb-non-branch-instrs-set! bb* (reverse head*))
                               (bb-branch-instr-set!
                                bb*
                                (make-jump (make-lbl lbl) #f #f frame #f))
                               (bb-non-branch-instrs-set! bb (reverse head))
                               (bb-branch-instr-set!
                                bb
                                (make-jump (make-lbl lbl) #f #f frame #f))
                               (set! changed? #t)
                               (cons bb (cons bb* (add-bb bb** (cdr l))))))))
                      (cons bb* (add-bb bb (cdr l)))))))
          (list bb)))
    (define (extract-common-tail bb1 bb2 cont)
      (let loop ((l1 (reverse (bb-non-branch-instrs bb1)))
                 (l2 (reverse (bb-non-branch-instrs bb2)))
                 (tail '()))
        (if (and (pair? l1) (pair? l2))
            (let ((i1 (car l1)) (i2 (car l2)))
              (if (eqv-gvm-instr? i1 i2)
                  (loop (cdr l1) (cdr l2) (cons i1 tail))
                  (cont l1 l2 tail)))
            (cont l1 l2 tail))))
    (define (eqv-bb? bb1 bb2)
      (let ((bb1-non-branch (bb-non-branch-instrs bb1))
            (bb2-non-branch (bb-non-branch-instrs bb2)))
        (and (= (length bb1-non-branch) (length bb2-non-branch))
             (eqv-gvm-instr? (bb-label-instr bb1) (bb-label-instr bb2))
             (eqv-gvm-instr? (bb-branch-instr bb1) (bb-branch-instr bb2))
             (eqv-list? eqv-gvm-instr? bb1-non-branch bb2-non-branch))))
    (define (eqv-list? pred? l1 l2)
      (if (pair? l1)
          (and (pair? l2)
               (pred? (car l1) (car l2))
               (eqv-list? pred? (cdr l1) (cdr l2)))
          (not (pair? l2))))
    (define (eqv-lbl-num? lbl1 lbl2)
      (= (replacement-lbl-num lbl1) (replacement-lbl-num lbl2)))
    (define (eqv-gvm-opnd? opnd1 opnd2)
      (if (not opnd1)
          (not opnd2)
          (and opnd2
               (cond ((lbl? opnd1)
                      (and (lbl? opnd2)
                           (eqv-lbl-num? (lbl-num opnd1) (lbl-num opnd2))))
                     ((clo? opnd1)
                      (and (clo? opnd2)
                           (= (clo-index opnd1) (clo-index opnd2))
                           (eqv-gvm-opnd? (clo-base opnd1) (clo-base opnd2))))
                     (else (eqv? opnd1 opnd2))))))
    (define (eqv-gvm-instr? instr1 instr2)
      (define (eqv-closure-parms? p1 p2)
        (and (eqv-gvm-opnd? (closure-parms-loc p1) (closure-parms-loc p2))
             (eqv-lbl-num? (closure-parms-lbl p1) (closure-parms-lbl p2))
             (eqv-list?
              eqv-gvm-opnd?
              (closure-parms-opnds p1)
              (closure-parms-opnds p2))))
      (let ((type1 (gvm-instr-type instr1)) (type2 (gvm-instr-type instr2)))
        (and (eq? type1 type2)
             (frame-eq? (gvm-instr-frame instr1) (gvm-instr-frame instr2))
             (case type1
               ((label)
                (let ((ltype1 (label-type instr1))
                      (ltype2 (label-type instr2)))
                  (and (eq? ltype1 ltype2)
                       (case ltype1
                         ((simple return task-entry task-return) #t)
                         ((entry)
                          (and (= (label-entry-min instr1)
                                  (label-entry-min instr2))
                               (= (label-entry-nb-parms instr1)
                                  (label-entry-nb-parms instr2))
                               (eq? (label-entry-rest? instr1)
                                    (label-entry-rest? instr2))
                               (eq? (label-entry-closed? instr1)
                                    (label-entry-closed? instr2))))
                         (else
                          (compiler-internal-error
                           "eqv-gvm-instr?, unknown label type"))))))
               ((apply)
                (and (eq? (apply-prim instr1) (apply-prim instr2))
                     (eqv-list?
                      eqv-gvm-opnd?
                      (apply-opnds instr1)
                      (apply-opnds instr2))
                     (eqv-gvm-opnd? (apply-loc instr1) (apply-loc instr2))))
               ((copy)
                (and (eqv-gvm-opnd? (copy-opnd instr1) (copy-opnd instr2))
                     (eqv-gvm-opnd? (copy-loc instr1) (copy-loc instr2))))
               ((close)
                (eqv-list?
                 eqv-closure-parms?
                 (close-parms instr1)
                 (close-parms instr2)))
               ((ifjump)
                (and (eq? (ifjump-test instr1) (ifjump-test instr2))
                     (eqv-list?
                      eqv-gvm-opnd?
                      (ifjump-opnds instr1)
                      (ifjump-opnds instr2))
                     (eqv-lbl-num? (ifjump-true instr1) (ifjump-true instr2))
                     (eqv-lbl-num? (ifjump-false instr1) (ifjump-false instr2))
                     (eq? (ifjump-poll? instr1) (ifjump-poll? instr2))))
               ((jump)
                (and (eqv-gvm-opnd? (jump-opnd instr1) (jump-opnd instr2))
                     (eqv? (jump-nb-args instr1) (jump-nb-args instr2))
                     (eq? (jump-poll? instr1) (jump-poll? instr2))))
               (else
                (compiler-internal-error
                 "eqv-gvm-instr?, unknown 'gvm-instr':"
                 instr1))))))
    (define (update-bb! bb) (replace-label-references! bb replacement-lbl-num))
    (for-each enter-bb! bb-list)
    (bbs-entry-lbl-num-set! bbs (replacement-lbl-num (bbs-entry-lbl-num bbs)))
    (let loop ((i 0) (result '()))
      (if (< i hash-table-length)
          (let ((bb-kept (vector-ref hash-table i)))
            (for-each update-bb! bb-kept)
            (loop (+ i 1) (append bb-kept result)))
          (bbs-bb-queue-set! bbs (list->queue result))))
    changed?))
(define (replace-label-references! bb replacement-lbl-num)
  (define (update-gvm-opnd opnd)
    (if opnd
        (cond ((lbl? opnd) (make-lbl (replacement-lbl-num (lbl-num opnd))))
              ((clo? opnd)
               (make-clo (update-gvm-opnd (clo-base opnd)) (clo-index opnd)))
              (else opnd))
        opnd))
  (define (update-gvm-instr instr)
    (define (update-closure-parms p)
      (make-closure-parms
       (update-gvm-opnd (closure-parms-loc p))
       (replacement-lbl-num (closure-parms-lbl p))
       (map update-gvm-opnd (closure-parms-opnds p))))
    (case (gvm-instr-type instr)
      ((apply)
       (make-apply
        (apply-prim instr)
        (map update-gvm-opnd (apply-opnds instr))
        (update-gvm-opnd (apply-loc instr))
        (gvm-instr-frame instr)
        (gvm-instr-comment instr)))
      ((copy)
       (make-copy
        (update-gvm-opnd (copy-opnd instr))
        (update-gvm-opnd (copy-loc instr))
        (gvm-instr-frame instr)
        (gvm-instr-comment instr)))
      ((close)
       (make-close
        (map update-closure-parms (close-parms instr))
        (gvm-instr-frame instr)
        (gvm-instr-comment instr)))
      ((ifjump)
       (make-ifjump
        (ifjump-test instr)
        (map update-gvm-opnd (ifjump-opnds instr))
        (replacement-lbl-num (ifjump-true instr))
        (replacement-lbl-num (ifjump-false instr))
        (ifjump-poll? instr)
        (gvm-instr-frame instr)
        (gvm-instr-comment instr)))
      ((jump)
       (make-jump
        (update-gvm-opnd (jump-opnd instr))
        (jump-nb-args instr)
        (jump-poll? instr)
        (gvm-instr-frame instr)
        (gvm-instr-comment instr)))
      (else
       (compiler-internal-error "update-gvm-instr, unknown 'instr':" instr))))
  (bb-non-branch-instrs-set!
   bb
   (map update-gvm-instr (bb-non-branch-instrs bb)))
  (bb-branch-instr-set! bb (update-gvm-instr (bb-branch-instr bb))))
(define (bbs-order! bbs)
  (let ((new-bb-queue (queue-empty))
        (left-to-schedule (queue->list (bbs-bb-queue bbs))))
    (define (remove x l)
      (if (eq? (car l) x) (cdr l) (cons (car l) (remove x (cdr l)))))
    (define (remove-bb! bb)
      (set! left-to-schedule (remove bb left-to-schedule))
      bb)
    (define (prec-bb bb)
      (let loop ((l (bb-precedents bb)) (best #f) (best-fs #f))
        (if (null? l)
            best
            (let* ((x (car l)) (x-fs (bb-exit-frame-size x)))
              (if (and (memq x left-to-schedule)
                       (or (not best) (< x-fs best-fs)))
                  (loop (cdr l) x x-fs)
                  (loop (cdr l) best best-fs))))))
    (define (succ-bb bb)
      (define (branches-to-lbl? bb)
        (let ((branch (bb-branch-instr bb)))
          (case (gvm-instr-type branch)
            ((ifjump) #t)
            ((jump) (lbl? (jump-opnd branch)))
            (else
             (compiler-internal-error "bbs-order!, unknown branch type")))))
      (define (best-succ bb1 bb2)
        (if (branches-to-lbl? bb1)
            bb1
            (if (branches-to-lbl? bb2)
                bb2
                (if (< (bb-exit-frame-size bb1) (bb-exit-frame-size bb2))
                    bb2
                    bb1))))
      (let ((branch (bb-branch-instr bb)))
        (case (gvm-instr-type branch)
          ((ifjump)
           (let* ((true-bb (lbl-num->bb (ifjump-true branch) bbs))
                  (true-bb* (and (memq true-bb left-to-schedule) true-bb))
                  (false-bb (lbl-num->bb (ifjump-false branch) bbs))
                  (false-bb* (and (memq false-bb left-to-schedule) false-bb)))
             (if (and true-bb* false-bb*)
                 (best-succ true-bb* false-bb*)
                 (or true-bb* false-bb*))))
          ((jump)
           (let ((opnd (jump-opnd branch)))
             (and (lbl? opnd)
                  (let ((bb (lbl-num->bb (lbl-num opnd) bbs)))
                    (and (memq bb left-to-schedule) bb)))))
          (else (compiler-internal-error "bbs-order!, unknown branch type")))))
    (define (schedule-from bb)
      (queue-put! new-bb-queue bb)
      (let ((x (succ-bb bb)))
        (if x
            (begin
              (schedule-around (remove-bb! x))
              (let ((y (succ-bb bb)))
                (if y (schedule-around (remove-bb! y)))))))
      (schedule-refs bb))
    (define (schedule-around bb)
      (let ((x (prec-bb bb)))
        (if x
            (let ((bb-list (schedule-back (remove-bb! x) '())))
              (queue-put! new-bb-queue x)
              (schedule-forw bb)
              (for-each schedule-refs bb-list))
            (schedule-from bb))))
    (define (schedule-back bb bb-list)
      (let ((bb-list* (cons bb bb-list)) (x (prec-bb bb)))
        (if x
            (let ((bb-list (schedule-back (remove-bb! x) bb-list*)))
              (queue-put! new-bb-queue x)
              bb-list)
            bb-list*)))
    (define (schedule-forw bb)
      (queue-put! new-bb-queue bb)
      (let ((x (succ-bb bb)))
        (if x
            (begin
              (schedule-forw (remove-bb! x))
              (let ((y (succ-bb bb)))
                (if y (schedule-around (remove-bb! y)))))))
      (schedule-refs bb))
    (define (schedule-refs bb)
      (for-each
       (lambda (x)
         (if (memq x left-to-schedule) (schedule-around (remove-bb! x))))
       (bb-references bb)))
    (schedule-from (remove-bb! (lbl-num->bb (bbs-entry-lbl-num bbs) bbs)))
    (bbs-bb-queue-set! bbs new-bb-queue)
    (let ((bb-list (queue->list new-bb-queue)))
      (let loop ((l bb-list) (i 1) (lbl-map '()))
        (if (pair? l)
            (let* ((label-instr (bb-label-instr (car l)))
                   (old-lbl-num (label-lbl-num label-instr)))
              (label-lbl-num-set! label-instr i)
              (loop (cdr l) (+ i 1) (cons (cons old-lbl-num i) lbl-map)))
            (let ()
              (define (replacement-lbl-num x) (cdr (assv x lbl-map)))
              (define (update-bb! bb)
                (replace-label-references! bb replacement-lbl-num))
              (for-each update-bb! bb-list)
              (bbs-lbl-counter-set!
               bbs
               (make-counter
                (* (+ 1 (quotient (bbs-new-lbl! bbs) 1000)) 1000)
                label-limit
                bbs-limit-err))))))))
(define (make-code bb gvm-instr sn) (vector bb gvm-instr sn))
(define (code-bb code) (vector-ref code 0))
(define (code-gvm-instr code) (vector-ref code 1))
(define (code-slots-needed code) (vector-ref code 2))
(define (code-slots-needed-set! code n) (vector-set! code 2 n))
(define (bbs->code-list bbs)
  (let ((code-list (linearize bbs)))
    (setup-slots-needed! code-list)
    code-list))
(define (linearize bbs)
  (let ((code-queue (queue-empty)))
    (define (put-bb bb)
      (define (put-instr gvm-instr)
        (queue-put! code-queue (make-code bb gvm-instr #f)))
      (put-instr (bb-label-instr bb))
      (for-each put-instr (bb-non-branch-instrs bb))
      (put-instr (bb-branch-instr bb)))
    (for-each put-bb (queue->list (bbs-bb-queue bbs)))
    (queue->list code-queue)))
(define (setup-slots-needed! code-list)
  (if (null? code-list)
      #f
      (let* ((code (car code-list))
             (gvm-instr (code-gvm-instr code))
             (sn-rest (setup-slots-needed! (cdr code-list))))
        (case (gvm-instr-type gvm-instr)
          ((label)
           (if (> sn-rest (frame-size (gvm-instr-frame gvm-instr)))
               (compiler-internal-error
                "setup-slots-needed!, incoherent slots needed for LABEL"))
           (code-slots-needed-set! code sn-rest)
           #f)
          ((ifjump jump)
           (let ((sn (frame-size (gvm-instr-frame gvm-instr))))
             (code-slots-needed-set! code sn)
             (need-gvm-instr gvm-instr sn)))
          (else
           (code-slots-needed-set! code sn-rest)
           (need-gvm-instr gvm-instr sn-rest))))))
(define (need-gvm-instrs non-branch branch)
  (if (pair? non-branch)
      (need-gvm-instr
       (car non-branch)
       (need-gvm-instrs (cdr non-branch) branch))
      (need-gvm-instr branch (frame-size (gvm-instr-frame branch)))))
(define (need-gvm-instr gvm-instr sn-rest)
  (case (gvm-instr-type gvm-instr)
    ((label) sn-rest)
    ((apply)
     (let ((loc (apply-loc gvm-instr)))
       (need-gvm-opnds
        (apply-opnds gvm-instr)
        (need-gvm-loc-opnd loc (need-gvm-loc loc sn-rest)))))
    ((copy)
     (let ((loc (copy-loc gvm-instr)))
       (need-gvm-opnd
        (copy-opnd gvm-instr)
        (need-gvm-loc-opnd loc (need-gvm-loc loc sn-rest)))))
    ((close)
     (let ((parms (close-parms gvm-instr)))
       (define (need-parms-opnds p)
         (if (null? p)
             sn-rest
             (need-gvm-opnds
              (closure-parms-opnds (car p))
              (need-parms-opnds (cdr p)))))
       (define (need-parms-loc p)
         (if (null? p)
             (need-parms-opnds parms)
             (let ((loc (closure-parms-loc (car p))))
               (need-gvm-loc-opnd
                loc
                (need-gvm-loc loc (need-parms-loc (cdr p)))))))
       (need-parms-loc parms)))
    ((ifjump) (need-gvm-opnds (ifjump-opnds gvm-instr) sn-rest))
    ((jump) (need-gvm-opnd (jump-opnd gvm-instr) sn-rest))
    (else
     (compiler-internal-error
      "need-gvm-instr, unknown 'gvm-instr':"
      gvm-instr))))
(define (need-gvm-loc loc sn-rest)
  (if (and loc (stk? loc) (>= (stk-num loc) sn-rest))
      (- (stk-num loc) 1)
      sn-rest))
(define (need-gvm-loc-opnd gvm-loc slots-needed)
  (if (and gvm-loc (clo? gvm-loc))
      (need-gvm-opnd (clo-base gvm-loc) slots-needed)
      slots-needed))
(define (need-gvm-opnd gvm-opnd slots-needed)
  (cond ((stk? gvm-opnd) (max (stk-num gvm-opnd) slots-needed))
        ((clo? gvm-opnd) (need-gvm-opnd (clo-base gvm-opnd) slots-needed))
        (else slots-needed)))
(define (need-gvm-opnds gvm-opnds slots-needed)
  (if (null? gvm-opnds)
      slots-needed
      (need-gvm-opnd
       (car gvm-opnds)
       (need-gvm-opnds (cdr gvm-opnds) slots-needed))))
(define (write-bb bb port)
  (write-gvm-instr (bb-label-instr bb) port)
  (display " [precedents=" port)
  (write (map bb-lbl-num (bb-precedents bb)) port)
  (display "]" port)
  (newline port)
  (for-each
   (lambda (x) (write-gvm-instr x port) (newline port))
   (bb-non-branch-instrs bb))
  (write-gvm-instr (bb-branch-instr bb) port))
(define (write-bbs bbs port)
  (for-each
   (lambda (bb)
     (if (= (bb-lbl-num bb) (bbs-entry-lbl-num bbs))
         (begin (display "**** Entry block:" port) (newline port)))
     (write-bb bb port)
     (newline port))
   (queue->list (bbs-bb-queue bbs))))
(define (virtual.dump proc port)
  (let ((proc-seen (queue-empty)) (proc-left (queue-empty)))
    (define (scan-opnd gvm-opnd)
      (cond ((obj? gvm-opnd)
             (let ((val (obj-val gvm-opnd)))
               (if (and (proc-obj? val)
                        (proc-obj-code val)
                        (not (memq val (queue->list proc-seen))))
                   (begin
                     (queue-put! proc-seen val)
                     (queue-put! proc-left val)))))
            ((clo? gvm-opnd) (scan-opnd (clo-base gvm-opnd)))))
    (define (dump-proc p)
      (define (scan-code code)
        (let ((gvm-instr (code-gvm-instr code)))
          (write-gvm-instr gvm-instr port)
          (newline port)
          (case (gvm-instr-type gvm-instr)
            ((apply)
             (for-each scan-opnd (apply-opnds gvm-instr))
             (if (apply-loc gvm-instr) (scan-opnd (apply-loc gvm-instr))))
            ((copy)
             (scan-opnd (copy-opnd gvm-instr))
             (scan-opnd (copy-loc gvm-instr)))
            ((close)
             (for-each
              (lambda (parms)
                (scan-opnd (closure-parms-loc parms))
                (for-each scan-opnd (closure-parms-opnds parms)))
              (close-parms gvm-instr)))
            ((ifjump) (for-each scan-opnd (ifjump-opnds gvm-instr)))
            ((jump) (scan-opnd (jump-opnd gvm-instr)))
            (else '()))))
      (if (proc-obj-primitive? p)
          (display "**** #[primitive " port)
          (display "**** #[procedure " port))
      (display (proc-obj-name p) port)
      (display "] =" port)
      (newline port)
      (let loop ((l (bbs->code-list (proc-obj-code p)))
                 (prev-filename "")
                 (prev-line 0))
        (if (pair? l)
            (let* ((code (car l))
                   (instr (code-gvm-instr code))
                   (src (comment-get (gvm-instr-comment instr) 'source))
                   (loc (and src (source-locat src)))
                   (filename
                    (if (and loc (eq? (vector-ref loc 0) 'file))
                        (vector-ref loc 1)
                        prev-filename))
                   (line (if (and loc (eq? (vector-ref loc 0) 'file))
                             (vector-ref loc 3)
                             prev-line)))
              (if (or (not (string=? filename prev-filename))
                      (not (= line prev-line)))
                  (begin
                    (display "#line " port)
                    (display line port)
                    (if (not (string=? filename prev-filename))
                        (begin (display " " port) (write filename port)))
                    (newline port)))
              (scan-code code)
              (loop (cdr l) filename line))
            (newline port))))
    (scan-opnd (make-obj proc))
    (let loop ()
      (if (not (queue-empty? proc-left))
          (begin (dump-proc (queue-get! proc-left)) (loop))))))
(define (write-gvm-instr gvm-instr port)
  (define (write-closure-parms parms)
    (display " " port)
    (let ((len (+ 1 (write-gvm-opnd (closure-parms-loc parms) port))))
      (display " = (" port)
      (let ((len (+ len (+ 4 (write-gvm-lbl (closure-parms-lbl parms) port)))))
        (+ len
           (write-terminated-opnd-list (closure-parms-opnds parms) port)))))
  (define (write-terminated-opnd-list l port)
    (let loop ((l l) (len 0))
      (if (pair? l)
          (let ((opnd (car l)))
            (display " " port)
            (loop (cdr l) (+ len (+ 1 (write-gvm-opnd opnd port)))))
          (begin (display ")" port) (+ len 1)))))
  (define (write-param-pattern gvm-instr port)
    (let ((len (if (not (= (label-entry-min gvm-instr)
                           (label-entry-nb-parms gvm-instr)))
                   (let ((len (write-returning-len
                               (label-entry-min gvm-instr)
                               port)))
                     (display "-" port)
                     (+ len 1))
                   0)))
      (let ((len (+ len
                    (write-returning-len
                     (label-entry-nb-parms gvm-instr)
                     port))))
        (if (label-entry-rest? gvm-instr)
            (begin (display "+" port) (+ len 1))
            len))))
  (define (write-prim-applic prim opnds port)
    (display "(" port)
    (let ((len (+ 1 (display-returning-len (proc-obj-name prim) port))))
      (+ len (write-terminated-opnd-list opnds port))))
  (define (write-instr gvm-instr)
    (case (gvm-instr-type gvm-instr)
      ((label)
       (let ((len (write-gvm-lbl (label-lbl-num gvm-instr) port)))
         (display " " port)
         (let ((len (+ len
                       (+ 1
                          (write-returning-len
                           (frame-size (gvm-instr-frame gvm-instr))
                           port)))))
           (case (label-type gvm-instr)
             ((simple) len)
             ((entry)
              (if (label-entry-closed? gvm-instr)
                  (begin
                    (display " closure-entry-point " port)
                    (+ len (+ 21 (write-param-pattern gvm-instr port))))
                  (begin
                    (display " entry-point " port)
                    (+ len (+ 13 (write-param-pattern gvm-instr port))))))
             ((return) (display " return-point" port) (+ len 13))
             ((task-entry) (display " task-entry-point" port) (+ len 17))
             ((task-return) (display " task-return-point" port) (+ len 18))
             (else
              (compiler-internal-error
               "write-gvm-instr, unknown label type"))))))
      ((apply)
       (display "  " port)
       (let ((len (+ 2
                     (if (apply-loc gvm-instr)
                         (let ((len (write-gvm-opnd
                                     (apply-loc gvm-instr)
                                     port)))
                           (display " = " port)
                           (+ len 3))
                         0))))
         (+ len
            (write-prim-applic
             (apply-prim gvm-instr)
             (apply-opnds gvm-instr)
             port))))
      ((copy)
       (display "  " port)
       (let ((len (+ 2 (write-gvm-opnd (copy-loc gvm-instr) port))))
         (display " = " port)
         (+ len (+ 3 (write-gvm-opnd (copy-opnd gvm-instr) port)))))
      ((close)
       (display "  close" port)
       (let ((len (+ 7 (write-closure-parms (car (close-parms gvm-instr))))))
         (let loop ((l (cdr (close-parms gvm-instr))) (len len))
           (if (pair? l)
               (let ((x (car l)))
                 (display "," port)
                 (loop (cdr l) (+ len (+ 1 (write-closure-parms x)))))
               len))))
      ((ifjump)
       (display "  if " port)
       (let ((len (+ 5
                     (write-prim-applic
                      (ifjump-test gvm-instr)
                      (ifjump-opnds gvm-instr)
                      port))))
         (let ((len (+ len
                       (if (ifjump-poll? gvm-instr)
                           (begin (display " jump* " port) 7)
                           (begin (display " jump " port) 6)))))
           (let ((len (+ len
                         (write-returning-len
                          (frame-size (gvm-instr-frame gvm-instr))
                          port))))
             (display " " port)
             (let ((len (+ len
                           (+ 1
                              (write-gvm-lbl (ifjump-true gvm-instr) port)))))
               (display " else " port)
               (+ len (+ 6 (write-gvm-lbl (ifjump-false gvm-instr) port))))))))
      ((jump)
       (display "  " port)
       (let ((len (+ 2
                     (if (jump-poll? gvm-instr)
                         (begin (display "jump* " port) 6)
                         (begin (display "jump " port) 5)))))
         (let ((len (+ len
                       (write-returning-len
                        (frame-size (gvm-instr-frame gvm-instr))
                        port))))
           (display " " port)
           (let ((len (+ len
                         (+ 1 (write-gvm-opnd (jump-opnd gvm-instr) port)))))
             (+ len
                (if (jump-nb-args gvm-instr)
                    (begin
                      (display " " port)
                      (+ 1
                         (write-returning-len (jump-nb-args gvm-instr) port)))
                    0))))))
      (else
       (compiler-internal-error
        "write-gvm-instr, unknown 'gvm-instr':"
        gvm-instr))))
  (define (spaces n)
    (if (> n 0)
        (if (> n 7)
            (begin (display "        " port) (spaces (- n 8)))
            (begin (display " " port) (spaces (- n 1))))))
  (let ((len (write-instr gvm-instr)))
    (spaces (- 40 len))
    (display " " port)
    (write-frame (gvm-instr-frame gvm-instr) port))
  (let ((x (gvm-instr-comment gvm-instr)))
    (if x
        (let ((y (comment-get x 'text)))
          (if y (begin (display " ; " port) (display y port)))))))
(define (write-frame frame port)
  (define (write-var var opnd sep)
    (display sep port)
    (write-gvm-opnd opnd port)
    (if var
        (begin
          (display "=" port)
          (cond ((eq? var closure-env-var)
                 (write (map (lambda (var) (var-name var))
                             (frame-closed frame))
                        port))
                ((eq? var ret-var) (display "#" port))
                ((temp-var? var) (display "." port))
                (else (write (var-name var) port))))))
  (define (live? var)
    (let ((live (frame-live frame)))
      (or (set-member? var live)
          (and (eq? var closure-env-var)
               (not (set-empty?
                     (set-intersection
                      live
                      (list->set (frame-closed frame)))))))))
  (let loop1 ((i 1) (l (reverse (frame-slots frame))) (sep "; "))
    (if (pair? l)
        (let ((var (car l)))
          (write-var (if (live? var) var #f) (make-stk i) sep)
          (loop1 (+ i 1) (cdr l) " "))
        (let loop2 ((i 0) (l (frame-regs frame)) (sep sep))
          (if (pair? l)
              (let ((var (car l)))
                (if (live? var)
                    (begin
                      (write-var var (make-reg i) sep)
                      (loop2 (+ i 1) (cdr l) " "))
                    (loop2 (+ i 1) (cdr l) sep))))))))
(define (write-gvm-opnd gvm-opnd port)
  (define (write-opnd)
    (cond ((reg? gvm-opnd)
           (display "+" port)
           (+ 1 (write-returning-len (reg-num gvm-opnd) port)))
          ((stk? gvm-opnd)
           (display "-" port)
           (+ 1 (write-returning-len (stk-num gvm-opnd) port)))
          ((glo? gvm-opnd) (write-returning-len (glo-name gvm-opnd) port))
          ((clo? gvm-opnd)
           (let ((len (write-gvm-opnd (clo-base gvm-opnd) port)))
             (display "(" port)
             (let ((len (+ len
                           (+ 1
                              (write-returning-len
                               (clo-index gvm-opnd)
                               port)))))
               (display ")" port)
               (+ len 1))))
          ((lbl? gvm-opnd) (write-gvm-lbl (lbl-num gvm-opnd) port))
          ((obj? gvm-opnd)
           (display "'" port)
           (+ (write-gvm-obj (obj-val gvm-opnd) port) 1))
          (else
           (compiler-internal-error
            "write-gvm-opnd, unknown 'gvm-opnd':"
            gvm-opnd))))
  (write-opnd))
(define (write-gvm-lbl lbl port)
  (display "#" port)
  (+ (write-returning-len lbl port) 1))
(define (write-gvm-obj val port)
  (cond ((false-object? val) (display "#f" port) 2)
        ((undef-object? val) (display "#[undefined]" port) 12)
        ((proc-obj? val)
         (if (proc-obj-primitive? val)
             (display "#[primitive " port)
             (display "#[procedure " port))
         (let ((len (display-returning-len (proc-obj-name val) port)))
           (display "]" port)
           (+ len 13)))
        (else (write-returning-len val port))))
(define (virtual.begin!)
  (set! *opnd-table* (make-vector opnd-table-size))
  (set! *opnd-table-alloc* 0)
  '())
(define (virtual.end!) (set! *opnd-table* '()) '())
(define (make-target version name)
  (define current-target-version 4)
  (if (not (= version current-target-version))
      (compiler-internal-error
       "make-target, version of target package is not current"
       name))
  (let ((x (make-vector 11))) (vector-set! x 1 name) x))
(define (target-name x) (vector-ref x 1))
(define (target-begin! x) (vector-ref x 2))
(define (target-begin!-set! x y) (vector-set! x 2 y))
(define (target-end! x) (vector-ref x 3))
(define (target-end!-set! x y) (vector-set! x 3 y))
(define (target-dump x) (vector-ref x 4))
(define (target-dump-set! x y) (vector-set! x 4 y))
(define (target-nb-regs x) (vector-ref x 5))
(define (target-nb-regs-set! x y) (vector-set! x 5 y))
(define (target-prim-info x) (vector-ref x 6))
(define (target-prim-info-set! x y) (vector-set! x 6 y))
(define (target-label-info x) (vector-ref x 7))
(define (target-label-info-set! x y) (vector-set! x 7 y))
(define (target-jump-info x) (vector-ref x 8))
(define (target-jump-info-set! x y) (vector-set! x 8 y))
(define (target-proc-result x) (vector-ref x 9))
(define (target-proc-result-set! x y) (vector-set! x 9 y))
(define (target-task-return x) (vector-ref x 10))
(define (target-task-return-set! x y) (vector-set! x 10 y))
(define targets-loaded '())
(define (get-target name)
  (let ((x (assq name targets-loaded)))
    (if x (cdr x) (compiler-error "Target package is not available" name))))
(define (put-target targ)
  (let* ((name (target-name targ)) (x (assq name targets-loaded)))
    (if x
        (set-cdr! x targ)
        (set! targets-loaded (cons (cons name targ) targets-loaded)))
    '()))
(define (default-target)
  (if (null? targets-loaded)
      (compiler-error "No target package is available")
      (car (car targets-loaded))))
(define (select-target! name info-port)
  (set! target (get-target name))
  ((target-begin! target) info-port)
  (set! target.dump (target-dump target))
  (set! target.nb-regs (target-nb-regs target))
  (set! target.prim-info (target-prim-info target))
  (set! target.label-info (target-label-info target))
  (set! target.jump-info (target-jump-info target))
  (set! target.proc-result (target-proc-result target))
  (set! target.task-return (target-task-return target))
  (set! **not-proc-obj (target.prim-info **not-sym))
  '())
(define (unselect-target!) ((target-end! target)) '())
(define target '())
(define target.dump '())
(define target.nb-regs '())
(define target.prim-info '())
(define target.label-info '())
(define target.jump-info '())
(define target.proc-result '())
(define target.task-return '())
(define **not-proc-obj '())
(define (target.specialized-prim-info* name decl)
  (let ((x (target.prim-info* name decl)))
    (and x ((proc-obj-specialize x) decl))))
(define (target.prim-info* name decl)
  (and (if (standard-procedure name decl)
           (standard-binding? name decl)
           (extended-binding? name decl))
       (target.prim-info name)))
(define generic-sym (string->canonical-symbol "GENERIC"))
(define fixnum-sym (string->canonical-symbol "FIXNUM"))
(define flonum-sym (string->canonical-symbol "FLONUM"))
(define-namable-decl generic-sym 'arith)
(define-namable-decl fixnum-sym 'arith)
(define-namable-decl flonum-sym 'arith)
(define (arith-implementation name decls)
  (declaration-value 'arith name generic-sym decls))
(define (cf source target-name . opts)
  (let* ((dest (file-root source))
         (module-name (file-name dest))
         (info-port (if (memq 'verbose opts) (current-output-port) #f))
         (result (compile-program
                  (list **include-sym source)
                  (if target-name target-name (default-target))
                  opts
                  module-name
                  dest
                  info-port)))
    (if (and info-port (not (eq? info-port (current-output-port))))
        (close-output-port info-port))
    result))
(define (ce source target-name . opts)
  (let* ((dest "program")
         (module-name "program")
         (info-port (if (memq 'verbose opts) (current-output-port) #f))
         (result (compile-program
                  source
                  (if target-name target-name (default-target))
                  opts
                  module-name
                  dest
                  info-port)))
    (if (and info-port (not (eq? info-port (current-output-port))))
        (close-output-port info-port))
    result))
(define wrap-program #f)
(set! wrap-program (lambda (program) program))
(define (compile-program program target-name opts module-name dest info-port)
  (define (compiler-body)
    (if (not (valid-module-name? module-name))
        (compiler-error
         "Invalid characters in file name (must be a symbol with no \"#\")")
        (begin
          (ptree.begin! info-port)
          (virtual.begin!)
          (select-target! target-name info-port)
          (parse-program
           (list (expression->source (wrap-program program) #f))
           (make-global-environment)
           module-name
           (lambda (lst env c-intf)
             (let ((parsed-program
                    (map (lambda (x) (normalize-parse-tree (car x) (cdr x)))
                         lst)))
               (if (memq 'expansion opts)
                   (let ((port (current-output-port)))
                     (display "Expansion:" port)
                     (newline port)
                     (let loop ((l parsed-program))
                       (if (pair? l)
                           (let ((ptree (car l)))
                             (pp-expression
                              (parse-tree->expression ptree)
                              port)
                             (loop (cdr l)))))
                     (newline port)))
               (let ((module-init-proc
                      (compile-parsed-program
                       module-name
                       parsed-program
                       env
                       c-intf
                       info-port)))
                 (if (memq 'report opts) (generate-report env))
                 (if (memq 'gvm opts)
                     (let ((gvm-port
                            (open-output-file (string-append dest ".gvm"))))
                       (virtual.dump module-init-proc gvm-port)
                       (close-output-port gvm-port)))
                 (target.dump module-init-proc dest c-intf opts)
                 (dump-c-intf module-init-proc dest c-intf)))))
          (unselect-target!)
          (virtual.end!)
          (ptree.end!)
          #t)))
  (let ((successful (with-exception-handling compiler-body)))
    (if info-port
        (if successful
            (begin
              (display "Compilation finished." info-port)
              (newline info-port))
            (begin
              (display "Compilation terminated abnormally." info-port)
              (newline info-port))))
    successful))
(define (valid-module-name? module-name)
  (define (valid-char? c)
    (and (not (memv c
                    '(#\#
                      #\;
                      #\(
                      #\)
                      #\space
                      #\[
                      #\]
                      #\{
                      #\}
                      #\"
                      #\'
                      #\`
                      #\,)))
         (not (char-whitespace? c))))
  (let ((n (string-length module-name)))
    (and (> n 0)
         (not (string=? module-name "."))
         (not (string->number module-name 10))
         (let loop ((i 0))
           (if (< i n)
               (if (valid-char? (string-ref module-name i)) (loop (+ i 1)) #f)
               #t)))))
(define (dump-c-intf module-init-proc dest c-intf)
  (let ((decls (c-intf-decls c-intf))
        (procs (c-intf-procs c-intf))
        (inits (c-intf-inits c-intf)))
    (if (or (not (null? decls)) (not (null? procs)) (not (null? inits)))
        (let* ((module-name (proc-obj-name module-init-proc))
               (filename (string-append dest ".c"))
               (port (open-output-file filename)))
          (display "/* File: \"" port)
          (display filename port)
          (display "\", C-interface file produced by Gambit " port)
          (display compiler-version port)
          (display " */" port)
          (newline port)
          (display "#define " port)
          (display c-id-prefix port)
          (display "MODULE_NAME \"" port)
          (display module-name port)
          (display "\"" port)
          (newline port)
          (display "#define " port)
          (display c-id-prefix port)
          (display "MODULE_LINKER " port)
          (display c-id-prefix port)
          (display (scheme-id->c-id module-name) port)
          (newline port)
          (display "#define " port)
          (display c-id-prefix port)
          (display "VERSION \"" port)
          (display compiler-version port)
          (display "\"" port)
          (newline port)
          (if (not (null? procs))
              (begin
                (display "#define " port)
                (display c-id-prefix port)
                (display "C_PRC_COUNT " port)
                (display (length procs) port)
                (newline port)))
          (display "#include \"gambit.h\"" port)
          (newline port)
          (display c-id-prefix port)
          (display "BEGIN_MODULE" port)
          (newline port)
          (for-each
           (lambda (x)
             (let ((scheme-name (vector-ref x 0)))
               (display c-id-prefix port)
               (display "SUPPLY_PRM(" port)
               (display c-id-prefix port)
               (display "P_" port)
               (display (scheme-id->c-id scheme-name) port)
               (display ")" port)
               (newline port)))
           procs)
          (newline port)
          (for-each (lambda (x) (display x port) (newline port)) decls)
          (if (not (null? procs))
              (begin
                (for-each
                 (lambda (x)
                   (let ((scheme-name (vector-ref x 0))
                         (c-name (vector-ref x 1))
                         (arity (vector-ref x 2))
                         (def (vector-ref x 3)))
                     (display c-id-prefix port)
                     (display "BEGIN_C_COD(" port)
                     (display c-name port)
                     (display "," port)
                     (display c-id-prefix port)
                     (display "P_" port)
                     (display (scheme-id->c-id scheme-name) port)
                     (display "," port)
                     (display arity port)
                     (display ")" port)
                     (newline port)
                     (display "#undef ___ARG1" port)
                     (newline port)
                     (display "#define ___ARG1 ___R1" port)
                     (newline port)
                     (display "#undef ___ARG2" port)
                     (newline port)
                     (display "#define ___ARG2 ___R2" port)
                     (newline port)
                     (display "#undef ___ARG3" port)
                     (newline port)
                     (display "#define ___ARG3 ___R3" port)
                     (newline port)
                     (display "#undef ___RESULT" port)
                     (newline port)
                     (display "#define ___RESULT ___R1" port)
                     (newline port)
                     (display def port)
                     (display c-id-prefix port)
                     (display "END_C_COD" port)
                     (newline port)))
                 procs)
                (newline port)
                (display c-id-prefix port)
                (display "BEGIN_C_PRC" port)
                (newline port)
                (let loop ((i 0) (lst procs))
                  (if (not (null? lst))
                      (let* ((x (car lst))
                             (scheme-name (vector-ref x 0))
                             (c-name (vector-ref x 1))
                             (arity (vector-ref x 2)))
                        (if (= i 0) (display " " port) (display "," port))
                        (display c-id-prefix port)
                        (display "DEF_C_PRC(" port)
                        (display c-name port)
                        (display "," port)
                        (display c-id-prefix port)
                        (display "P_" port)
                        (display (scheme-id->c-id scheme-name) port)
                        (display "," port)
                        (display arity port)
                        (display ")" port)
                        (newline port)
                        (loop (+ i 1) (cdr lst)))))
                (display c-id-prefix port)
                (display "END_C_PRC" port)
                (newline port)))
          (newline port)
          (display c-id-prefix port)
          (display "BEGIN_PRM" port)
          (newline port)
          (for-each (lambda (x) (display x port) (newline port)) inits)
          (display c-id-prefix port)
          (display "END_PRM" port)
          (newline port)
          (close-output-port port)))))
(define (generate-report env)
  (let ((vars (sort-variables (env-global-variables env)))
        (decl (env-declarations env)))
    (define (report title pred? vars wrote-something?)
      (if (pair? vars)
          (let ((var (car vars)))
            (if (pred? var)
                (begin
                  (if (not wrote-something?)
                      (begin (display " ") (display title) (newline)))
                  (let loop1 ((l (var-refs var)) (r? #f) (c? #f))
                    (if (pair? l)
                        (let* ((x (car l)) (y (node-parent x)))
                          (if (and y (app? y) (eq? x (app-oper y)))
                              (loop1 (cdr l) r? #t)
                              (loop1 (cdr l) #t c?)))
                        (let loop2 ((l (var-sets var)) (d? #f) (a? #f))
                          (if (pair? l)
                              (if (set? (car l))
                                  (loop2 (cdr l) d? #t)
                                  (loop2 (cdr l) #t a?))
                              (begin
                                (display "  [")
                                (if d? (display "D") (display " "))
                                (if a? (display "A") (display " "))
                                (if r? (display "R") (display " "))
                                (if c? (display "C") (display " "))
                                (display "] ")
                                (display (var-name var))
                                (newline))))))
                  (report title pred? (cdr vars) #t))
                (cons (car vars)
                      (report title pred? (cdr vars) wrote-something?))))
          (begin (if wrote-something? (newline)) '())))
    (display "Global variable usage:")
    (newline)
    (newline)
    (report "OTHERS"
            (lambda (x) #t)
            (report "EXTENDED"
                    (lambda (x) (target.prim-info (var-name x)))
                    (report "STANDARD"
                            (lambda (x) (standard-procedure (var-name x) decl))
                            vars
                            #f)
                    #f)
            #f)))
(define (compile-parsed-program module-name program env c-intf info-port)
  (if info-port (display "Compiling:" info-port))
  (set! trace-indentation 0)
  (set! *bbs* (make-bbs))
  (set! *global-env* env)
  (set! proc-queue '())
  (set! constant-vars '())
  (set! known-procs '())
  (restore-context (make-context 0 '() (list ret-var) '() (entry-poll) #f))
  (let* ((entry-lbl (bbs-new-lbl! *bbs*))
         (body-lbl (bbs-new-lbl! *bbs*))
         (frame (current-frame ret-var-set))
         (comment (if (null? program) #f (source-comment (car program)))))
    (bbs-entry-lbl-num-set! *bbs* entry-lbl)
    (set! entry-bb
          (make-bb (make-label-entry entry-lbl 0 0 #f #f frame comment) *bbs*))
    (bb-put-branch! entry-bb (make-jump (make-lbl body-lbl) #f #f frame #f))
    (set! *bb* (make-bb (make-label-simple body-lbl frame comment) *bbs*))
    (let loop1 ((l (c-intf-procs c-intf)))
      (if (not (null? l))
          (let* ((x (car l))
                 (name (vector-ref x 0))
                 (sym (string->canonical-symbol name))
                 (var (env-lookup-global-var *global-env* sym)))
            (add-constant-var
             var
             (make-obj (make-proc-obj name #t #f 0 #t '() '(#f))))
            (loop1 (cdr l)))))
    (let loop2 ((l program))
      (if (not (null? l))
          (let ((node (car l)))
            (if (def? node)
                (let* ((var (def-var node)) (val (global-val var)))
                  (if (and val (prc? val))
                      (add-constant-var
                       var
                       (make-obj
                        (make-proc-obj
                         (symbol->string (var-name var))
                         #t
                         #f
                         (call-pattern val)
                         #t
                         '()
                         '(#f)))))))
            (loop2 (cdr l)))))
    (let loop3 ((l program))
      (if (null? l)
          (let ((ret-opnd (var->opnd ret-var)))
            (seal-bb #t 'return)
            (dealloc-slots nb-slots)
            (bb-put-branch!
             *bb*
             (make-jump ret-opnd #f #f (current-frame (set-empty)) #f)))
          (let ((node (car l)))
            (if (def? node)
                (begin
                  (gen-define (def-var node) (def-val node) info-port)
                  (loop3 (cdr l)))
                (if (null? (cdr l))
                    (gen-node node ret-var-set 'tail)
                    (begin
                      (gen-node node ret-var-set 'need)
                      (loop3 (cdr l))))))))
    (let loop4 ()
      (if (pair? proc-queue)
          (let ((x (car proc-queue)))
            (set! proc-queue (cdr proc-queue))
            (gen-proc (car x) (cadr x) (caddr x) info-port)
            (trace-unindent info-port)
            (loop4))))
    (if info-port (begin (newline info-port) (newline info-port)))
    (bbs-purify! *bbs*)
    (let ((proc (make-proc-obj
                 (string-append "#!" module-name)
                 #t
                 *bbs*
                 '(0)
                 #t
                 '()
                 '(#f))))
      (set! *bb* '())
      (set! *bbs* '())
      (set! *global-env* '())
      (set! proc-queue '())
      (set! constant-vars '())
      (set! known-procs '())
      (clear-context)
      proc)))
(define *bb* '())
(define *bbs* '())
(define *global-env* '())
(define proc-queue '())
(define constant-vars '())
(define known-procs '())
(define trace-indentation '())
(define (trace-indent info-port)
  (set! trace-indentation (+ trace-indentation 1))
  (if info-port
      (begin
        (newline info-port)
        (let loop ((i trace-indentation))
          (if (> i 0) (begin (display "  " info-port) (loop (- i 1))))))))
(define (trace-unindent info-port)
  (set! trace-indentation (- trace-indentation 1)))
(define (gen-define var node info-port)
  (if (prc? node)
      (let* ((p-bbs *bbs*)
             (p-bb *bb*)
             (p-proc-queue proc-queue)
             (p-known-procs known-procs)
             (p-context (current-context))
             (bbs (make-bbs))
             (lbl1 (bbs-new-lbl! bbs))
             (lbl2 (bbs-new-lbl! bbs))
             (context (entry-context node '()))
             (frame (context->frame
                     context
                     (set-union (free-variables (prc-body node)) ret-var-set)))
             (bb1 (make-bb (make-label-entry
                            lbl1
                            (length (prc-parms node))
                            (prc-min node)
                            (prc-rest node)
                            #f
                            frame
                            (source-comment node))
                           bbs))
             (bb2 (make-bb (make-label-simple lbl2 frame (source-comment node))
                           bbs)))
        (define (do-body)
          (gen-proc node bb2 context info-port)
          (let loop ()
            (if (pair? proc-queue)
                (let ((x (car proc-queue)))
                  (set! proc-queue (cdr proc-queue))
                  (gen-proc (car x) (cadr x) (caddr x) info-port)
                  (trace-unindent info-port)
                  (loop))))
          (trace-unindent info-port)
          (bbs-purify! *bbs*))
        (context-entry-bb-set! context bb1)
        (bbs-entry-lbl-num-set! bbs lbl1)
        (bb-put-branch! bb1 (make-jump (make-lbl lbl2) #f #f frame #f))
        (set! *bbs* bbs)
        (set! proc-queue '())
        (set! known-procs '())
        (if (constant-var? var)
            (let-constant-var
             var
             (make-lbl lbl1)
             (lambda () (add-known-proc lbl1 node) (do-body)))
            (do-body))
        (set! *bbs* p-bbs)
        (set! *bb* p-bb)
        (set! proc-queue p-proc-queue)
        (set! known-procs p-known-procs)
        (restore-context p-context)
        (let* ((x (assq var constant-vars))
               (proc (if x
                         (let ((p (cdr x)))
                           (proc-obj-code-set! (obj-val p) bbs)
                           p)
                         (make-obj
                          (make-proc-obj
                           (symbol->string (var-name var))
                           #f
                           bbs
                           (call-pattern node)
                           #t
                           '()
                           '(#f))))))
          (put-copy
           proc
           (make-glo (var-name var))
           #f
           ret-var-set
           (source-comment node))))
      (put-copy
       (gen-node node ret-var-set 'need)
       (make-glo (var-name var))
       #f
       ret-var-set
       (source-comment node))))
(define (call-pattern node)
  (make-pattern (prc-min node) (length (prc-parms node)) (prc-rest node)))
(define (make-context nb-slots slots regs closed poll entry-bb)
  (vector nb-slots slots regs closed poll entry-bb))
(define (context-nb-slots x) (vector-ref x 0))
(define (context-slots x) (vector-ref x 1))
(define (context-regs x) (vector-ref x 2))
(define (context-closed x) (vector-ref x 3))
(define (context-poll x) (vector-ref x 4))
(define (context-entry-bb x) (vector-ref x 5))
(define (context-entry-bb-set! x y) (vector-set! x 5 y))
(define nb-slots '())
(define slots '())
(define regs '())
(define closed '())
(define poll '())
(define entry-bb '())
(define (restore-context context)
  (set! nb-slots (context-nb-slots context))
  (set! slots (context-slots context))
  (set! regs (context-regs context))
  (set! closed (context-closed context))
  (set! poll (context-poll context))
  (set! entry-bb (context-entry-bb context)))
(define (clear-context)
  (restore-context (make-context '() '() '() '() '() '())))
(define (current-context)
  (make-context nb-slots slots regs closed poll entry-bb))
(define (current-frame live) (make-frame nb-slots slots regs closed live))
(define (context->frame context live)
  (make-frame
   (context-nb-slots context)
   (context-slots context)
   (context-regs context)
   (context-closed context)
   live))
(define (make-poll since-entry? delta) (cons since-entry? delta))
(define (poll-since-entry? x) (car x))
(define (poll-delta x) (cdr x))
(define (entry-poll) (make-poll #f (- poll-period poll-head)))
(define (return-poll poll)
  (let ((delta (poll-delta poll)))
    (make-poll (poll-since-entry? poll) (+ poll-head (max delta poll-tail)))))
(define (poll-merge poll other-poll)
  (make-poll
   (or (poll-since-entry? poll) (poll-since-entry? other-poll))
   (max (poll-delta poll) (poll-delta other-poll))))
(define poll-period #f)
(set! poll-period 90)
(define poll-head #f)
(set! poll-head 15)
(define poll-tail #f)
(set! poll-tail 15)
(define (entry-context proc closed)
  (define (empty-vars-list n)
    (if (> n 0) (cons empty-var (empty-vars-list (- n 1))) '()))
  (let* ((parms (prc-parms proc))
         (pc (target.label-info
              (prc-min proc)
              (length parms)
              (prc-rest proc)
              (not (null? closed))))
         (fs (pcontext-fs pc))
         (slots-list (empty-vars-list fs))
         (regs-list (empty-vars-list target.nb-regs)))
    (define (assign-var-to-loc var loc)
      (let ((x (cond ((reg? loc)
                      (let ((i (reg-num loc)))
                        (if (<= i target.nb-regs)
                            (nth-after regs-list i)
                            (compiler-internal-error
                             "entry-context, reg out of bound in back-end's pcontext"))))
                     ((stk? loc)
                      (let ((i (stk-num loc)))
                        (if (<= i fs)
                            (nth-after slots-list (- fs i))
                            (compiler-internal-error
                             "entry-context, stk out of bound in back-end's pcontext"))))
                     (else
                      (compiler-internal-error
                       "entry-context, loc other than reg or stk in back-end's pcontext")))))
        (if (eq? (car x) empty-var)
            (set-car! x var)
            (compiler-internal-error
             "entry-context, duplicate location in back-end's pcontext"))))
    (let loop ((l (pcontext-map pc)))
      (if (not (null? l))
          (let* ((couple (car l)) (name (car couple)) (loc (cdr couple)))
            (cond ((eq? name 'return) (assign-var-to-loc ret-var loc))
                  ((eq? name 'closure-env)
                   (assign-var-to-loc closure-env-var loc))
                  (else (assign-var-to-loc (list-ref parms (- name 1)) loc)))
            (loop (cdr l)))))
    (make-context fs slots-list regs-list closed (entry-poll) #f)))
(define (get-var opnd)
  (cond ((glo? opnd) (env-lookup-global-var *global-env* (glo-name opnd)))
        ((reg? opnd) (list-ref regs (reg-num opnd)))
        ((stk? opnd) (list-ref slots (- nb-slots (stk-num opnd))))
        (else
         (compiler-internal-error
          "get-var, location must be global, register or stack slot"))))
(define (put-var opnd new)
  (define (put-v opnd new)
    (cond ((reg? opnd) (set! regs (replace-nth regs (reg-num opnd) new)))
          ((stk? opnd)
           (set! slots (replace-nth slots (- nb-slots (stk-num opnd)) new)))
          (else
           (compiler-internal-error
            "put-var, location must be register or stack slot, for var:"
            (var-name new)))))
  (if (eq? new ret-var)
      (let ((x (var->opnd ret-var))) (and x (put-v x empty-var))))
  (put-v opnd new))
(define (flush-regs) (set! regs '()))
(define (push-slot)
  (set! nb-slots (+ nb-slots 1))
  (set! slots (cons empty-var slots)))
(define (dealloc-slots n)
  (set! nb-slots (- nb-slots n))
  (set! slots (nth-after slots n)))
(define (pop-slot) (dealloc-slots 1))
(define (replace-nth l i v)
  (if (null? l)
      (if (= i 0) (list v) (cons empty-var (replace-nth l (- i 1) v)))
      (if (= i 0)
          (cons v (cdr l))
          (cons (car l) (replace-nth (cdr l) (- i 1) v)))))
(define (live-vars live)
  (if (not (set-empty? (set-intersection live (list->set closed))))
      (set-adjoin live closure-env-var)
      live))
(define (dead-slots live)
  (let ((live-v (live-vars live)))
    (define (loop s l i)
      (cond ((null? l) (list->set (reverse s)))
            ((set-member? (car l) live-v) (loop s (cdr l) (- i 1)))
            (else (loop (cons i s) (cdr l) (- i 1)))))
    (loop '() slots nb-slots)))
(define (live-slots live)
  (let ((live-v (live-vars live)))
    (define (loop s l i)
      (cond ((null? l) (list->set (reverse s)))
            ((set-member? (car l) live-v) (loop (cons i s) (cdr l) (- i 1)))
            (else (loop s (cdr l) (- i 1)))))
    (loop '() slots nb-slots)))
(define (dead-regs live)
  (let ((live-v (live-vars live)))
    (define (loop s l i)
      (cond ((>= i target.nb-regs) (list->set (reverse s)))
            ((null? l) (loop (cons i s) l (+ i 1)))
            ((and (set-member? (car l) live-v) (not (memq (car l) slots)))
             (loop s (cdr l) (+ i 1)))
            (else (loop (cons i s) (cdr l) (+ i 1)))))
    (loop '() regs 0)))
(define (live-regs live)
  (let ((live-v (live-vars live)))
    (define (loop s l i)
      (cond ((null? l) (list->set (reverse s)))
            ((and (set-member? (car l) live-v) (not (memq (car l) slots)))
             (loop (cons i s) (cdr l) (+ i 1)))
            (else (loop s (cdr l) (+ i 1)))))
    (loop '() regs 0)))
(define (lowest-dead-slot live)
  (make-stk (or (lowest (dead-slots live)) (+ nb-slots 1))))
(define (highest-live-slot live) (make-stk (or (highest (live-slots live)) 0)))
(define (lowest-dead-reg live)
  (let ((x (lowest (set-remove (dead-regs live) 0)))) (if x (make-reg x) #f)))
(define (highest-dead-reg live)
  (let ((x (highest (dead-regs live)))) (if x (make-reg x) #f)))
(define (highest set) (if (set-empty? set) #f (apply max (set->list set))))
(define (lowest set) (if (set-empty? set) #f (apply min (set->list set))))
(define (above set n) (set-keep (lambda (x) (> x n)) set))
(define (below set n) (set-keep (lambda (x) (< x n)) set))
(define (var->opnd var)
  (let ((x (assq var constant-vars)))
    (if x
        (cdr x)
        (if (global? var)
            (make-glo (var-name var))
            (let ((n (pos-in-list var regs)))
              (if n
                  (make-reg n)
                  (let ((n (pos-in-list var slots)))
                    (if n
                        (make-stk (- nb-slots n))
                        (let ((n (pos-in-list var closed)))
                          (if n
                              (make-clo (var->opnd closure-env-var) (+ n 1))
                              (compiler-internal-error
                               "var->opnd, variable is not accessible:"
                               (var-name var))))))))))))
(define (source-comment node)
  (let ((x (make-comment))) (comment-put! x 'source (node-source node)) x))
(define (sort-variables lst)
  (sort-list
   lst
   (lambda (x y)
     (string<? (symbol->string (var-name x)) (symbol->string (var-name y))))))
(define (add-constant-var var opnd)
  (set! constant-vars (cons (cons var opnd) constant-vars)))
(define (let-constant-var var opnd thunk)
  (let* ((x (assq var constant-vars)) (temp (cdr x)))
    (set-cdr! x opnd)
    (thunk)
    (set-cdr! x temp)))
(define (constant-var? var) (assq var constant-vars))
(define (not-constant-var? var) (not (constant-var? var)))
(define (add-known-proc label proc)
  (set! known-procs (cons (cons label proc) known-procs)))
(define (gen-proc proc bb context info-port)
  (trace-indent info-port)
  (if info-port
      (if (prc-name proc)
          (display (prc-name proc) info-port)
          (display "\"unknown\"" info-port)))
  (let ((lbl (bb-lbl-num bb))
        (live (set-union (free-variables (prc-body proc)) ret-var-set)))
    (set! *bb* bb)
    (restore-context context)
    (gen-node (prc-body proc) ret-var-set 'tail)))
(define (schedule-gen-proc proc closed-list)
  (let* ((lbl1 (bbs-new-lbl! *bbs*))
         (lbl2 (bbs-new-lbl! *bbs*))
         (context (entry-context proc closed-list))
         (frame (context->frame
                 context
                 (set-union (free-variables (prc-body proc)) ret-var-set)))
         (bb1 (make-bb (make-label-entry
                        lbl1
                        (length (prc-parms proc))
                        (prc-min proc)
                        (prc-rest proc)
                        (not (null? closed-list))
                        frame
                        (source-comment proc))
                       *bbs*))
         (bb2 (make-bb (make-label-simple lbl2 frame (source-comment proc))
                       *bbs*)))
    (context-entry-bb-set! context bb1)
    (bb-put-branch! bb1 (make-jump (make-lbl lbl2) #f #f frame #f))
    (set! proc-queue (cons (list proc bb2 context) proc-queue))
    (make-lbl lbl1)))
(define (gen-node node live why)
  (cond ((cst? node) (gen-return (make-obj (cst-val node)) why node))
        ((ref? node)
         (let* ((var (ref-var node)) (name (var-name var)))
           (gen-return
            (cond ((eq? why 'side) (make-obj undef-object))
                  ((global? var)
                   (let ((prim (target.prim-info* name (node-decl node))))
                     (if prim (make-obj prim) (var->opnd var))))
                  (else (var->opnd var)))
            why
            node)))
        ((set? node)
         (let* ((src (gen-node
                      (set-val node)
                      (set-adjoin live (set-var node))
                      'keep))
                (dst (var->opnd (set-var node))))
           (put-copy src dst #f live (source-comment node))
           (gen-return (make-obj undef-object) why node)))
        ((def? node)
         (compiler-internal-error
          "gen-node, 'def' node not at root of parse tree"))
        ((tst? node) (gen-tst node live why))
        ((conj? node) (gen-conj/disj node live why))
        ((disj? node) (gen-conj/disj node live why))
        ((prc? node)
         (let* ((closed (not-constant-closed-vars node))
                (closed-list (sort-variables (set->list closed)))
                (proc-lbl (schedule-gen-proc node closed-list)))
           (let ((opnd (if (null? closed-list)
                           (begin
                             (add-known-proc (lbl-num proc-lbl) node)
                             proc-lbl)
                           (begin
                             (dealloc-slots
                              (- nb-slots
                                 (stk-num (highest-live-slot
                                           (set-union closed live)))))
                             (push-slot)
                             (let ((slot (make-stk nb-slots))
                                   (var (make-temp-var 'closure)))
                               (put-var slot var)
                               (bb-put-non-branch!
                                *bb*
                                (make-close
                                 (list (make-closure-parms
                                        slot
                                        (lbl-num proc-lbl)
                                        (map var->opnd closed-list)))
                                 (current-frame (set-adjoin live var))
                                 (source-comment node)))
                               slot)))))
             (gen-return opnd why node))))
        ((app? node) (gen-call node live why))
        ((fut? node) (gen-fut node live why))
        (else
         (compiler-internal-error
          "gen-node, unknown parse tree node type:"
          node))))
(define (gen-return opnd why node)
  (cond ((eq? why 'tail)
         (let ((var (make-temp-var 'result)))
           (put-copy
            opnd
            target.proc-result
            var
            ret-var-set
            (source-comment node))
           (let ((ret-opnd (var->opnd ret-var)))
             (seal-bb (intrs-enabled? (node-decl node)) 'return)
             (dealloc-slots nb-slots)
             (bb-put-branch!
              *bb*
              (make-jump
               ret-opnd
               #f
               #f
               (current-frame (set-singleton var))
               #f)))))
        (else opnd)))
(define (not-constant-closed-vars val)
  (set-keep not-constant-var? (free-variables val)))
(define (predicate node live cont)
  (define (cont* true-lbl false-lbl) (cont false-lbl true-lbl))
  (define (generic-true-test)
    (predicate-test node live **not-proc-obj '0 (list node) cont*))
  (cond ((or (conj? node) (disj? node)) (predicate-conj/disj node live cont))
        ((app? node)
         (let ((proc (node->proc (app-oper node))))
           (if proc
               (let ((spec (specialize-for-call proc (node-decl node))))
                 (if (and (proc-obj-test spec)
                          (nb-args-conforms?
                           (length (app-args node))
                           (proc-obj-call-pat spec)))
                     (if (eq? spec **not-proc-obj)
                         (predicate (car (app-args node)) live cont*)
                         (predicate-test
                          node
                          live
                          spec
                          (proc-obj-strict-pat proc)
                          (app-args node)
                          cont))
                     (generic-true-test)))
               (generic-true-test))))
        (else (generic-true-test))))
(define (predicate-conj/disj node live cont)
  (let* ((pre (if (conj? node) (conj-pre node) (disj-pre node)))
         (alt (if (conj? node) (conj-alt node) (disj-alt node)))
         (alt-live (set-union live (free-variables alt))))
    (predicate
     pre
     alt-live
     (lambda (true-lbl false-lbl)
       (let ((pre-context (current-context)))
         (set! *bb*
               (make-bb (make-label-simple
                         (if (conj? node) true-lbl false-lbl)
                         (current-frame alt-live)
                         (source-comment alt))
                        *bbs*))
         (predicate
          alt
          live
          (lambda (true-lbl2 false-lbl2)
            (let ((alt-context (current-context)))
              (restore-context pre-context)
              (set! *bb*
                    (make-bb (make-label-simple
                              (if (conj? node) false-lbl true-lbl)
                              (current-frame live)
                              (source-comment alt))
                             *bbs*))
              (merge-contexts-and-seal-bb
               alt-context
               live
               (intrs-enabled? (node-decl node))
               'internal
               (source-comment node))
              (bb-put-branch!
               *bb*
               (make-jump
                (make-lbl (if (conj? node) false-lbl2 true-lbl2))
                #f
                #f
                (current-frame live)
                #f))
              (cont true-lbl2 false-lbl2)))))))))
(define (predicate-test node live test strict-pat args cont)
  (let loop ((args* args) (liv live) (vars* '()))
    (if (not (null? args*))
        (let* ((needed (vals-live-vars liv (cdr args*)))
               (var (save-var
                     (gen-node (car args*) needed 'need)
                     (make-temp-var 'predicate)
                     needed
                     (source-comment (car args*)))))
          (loop (cdr args*) (set-adjoin liv var) (cons var vars*)))
        (let* ((true-lbl (bbs-new-lbl! *bbs*))
               (false-lbl (bbs-new-lbl! *bbs*)))
          (seal-bb (intrs-enabled? (node-decl node)) 'internal)
          (bb-put-branch!
           *bb*
           (make-ifjump
            test
            (map var->opnd (reverse vars*))
            true-lbl
            false-lbl
            #f
            (current-frame live)
            (source-comment node)))
          (cont true-lbl false-lbl)))))
(define (gen-tst node live why)
  (let ((pre (tst-pre node)) (con (tst-con node)) (alt (tst-alt node)))
    (predicate
     pre
     (set-union live (free-variables con) (free-variables alt))
     (lambda (true-lbl false-lbl)
       (let ((pre-context (current-context))
             (true-bb (make-bb (make-label-simple
                                true-lbl
                                (current-frame
                                 (set-union live (free-variables con)))
                                (source-comment con))
                               *bbs*))
             (false-bb
              (make-bb (make-label-simple
                        false-lbl
                        (current-frame (set-union live (free-variables alt)))
                        (source-comment alt))
                       *bbs*)))
         (set! *bb* true-bb)
         (let ((con-opnd (gen-node con live why)))
           (if (eq? why 'tail)
               (begin
                 (restore-context pre-context)
                 (set! *bb* false-bb)
                 (gen-node alt live why))
               (let* ((result-var (make-temp-var 'result))
                      (live-after (set-adjoin live result-var)))
                 (save-opnd-to-reg
                  con-opnd
                  target.proc-result
                  result-var
                  live
                  (source-comment con))
                 (let ((con-context (current-context)) (con-bb *bb*))
                   (restore-context pre-context)
                   (set! *bb* false-bb)
                   (save-opnd-to-reg
                    (gen-node alt live why)
                    target.proc-result
                    result-var
                    live
                    (source-comment alt))
                   (let ((next-lbl (bbs-new-lbl! *bbs*)) (alt-bb *bb*))
                     (if (> (context-nb-slots con-context) nb-slots)
                         (begin
                           (seal-bb (intrs-enabled? (node-decl node))
                                    'internal)
                           (let ((alt-context (current-context)))
                             (restore-context con-context)
                             (set! *bb* con-bb)
                             (merge-contexts-and-seal-bb
                              alt-context
                              live-after
                              (intrs-enabled? (node-decl node))
                              'internal
                              (source-comment node))))
                         (let ((alt-context (current-context)))
                           (restore-context con-context)
                           (set! *bb* con-bb)
                           (seal-bb (intrs-enabled? (node-decl node))
                                    'internal)
                           (let ((con-context* (current-context)))
                             (restore-context alt-context)
                             (set! *bb* alt-bb)
                             (merge-contexts-and-seal-bb
                              con-context*
                              live-after
                              (intrs-enabled? (node-decl node))
                              'internal
                              (source-comment node)))))
                     (let ((frame (current-frame live-after)))
                       (bb-put-branch!
                        con-bb
                        (make-jump (make-lbl next-lbl) #f #f frame #f))
                       (bb-put-branch!
                        alt-bb
                        (make-jump (make-lbl next-lbl) #f #f frame #f))
                       (set! *bb*
                             (make-bb (make-label-simple
                                       next-lbl
                                       frame
                                       (source-comment node))
                                      *bbs*))
                       target.proc-result)))))))))))
(define (nb-args-conforms? n call-pat) (pattern-member? n call-pat))
(define (merge-contexts-and-seal-bb other-context live poll? where comment)
  (let ((live-v (live-vars live))
        (other-nb-slots (context-nb-slots other-context))
        (other-regs (context-regs other-context))
        (other-slots (context-slots other-context))
        (other-poll (context-poll other-context))
        (other-entry-bb (context-entry-bb other-context)))
    (let loop1 ((i (- target.nb-regs 1)))
      (if (>= i 0)
          (let ((other-var (reg->var other-regs i)) (var (reg->var regs i)))
            (if (and (not (eq? var other-var)) (set-member? other-var live-v))
                (let ((r (make-reg i)))
                  (put-var r empty-var)
                  (if (not (or (not (set-member? var live-v))
                               (memq var regs)
                               (memq var slots)))
                      (let ((top (make-stk (+ nb-slots 1))))
                        (put-copy r top var live-v comment)))
                  (put-copy (var->opnd other-var) r other-var live-v comment)))
            (loop1 (- i 1)))))
    (let loop2 ((i 1))
      (if (<= i other-nb-slots)
          (let ((other-var (stk->var other-slots i)) (var (stk->var slots i)))
            (if (and (not (eq? var other-var)) (set-member? other-var live-v))
                (let ((s (make-stk i)))
                  (if (<= i nb-slots) (put-var s empty-var))
                  (if (not (or (not (set-member? var live-v))
                               (memq var regs)
                               (memq var slots)))
                      (let ((top (make-stk (+ nb-slots 1))))
                        (put-copy s top var live-v comment)))
                  (put-copy (var->opnd other-var) s other-var live-v comment))
                (if (> i nb-slots)
                    (let ((top (make-stk (+ nb-slots 1))))
                      (put-copy
                       (make-obj undef-object)
                       top
                       empty-var
                       live-v
                       comment))))
            (loop2 (+ i 1)))))
    (dealloc-slots (- nb-slots other-nb-slots))
    (let loop3 ((i (- target.nb-regs 1)))
      (if (>= i 0)
          (let ((other-var (reg->var other-regs i)) (var (reg->var regs i)))
            (if (not (eq? var other-var)) (put-var (make-reg i) empty-var))
            (loop3 (- i 1)))))
    (let loop4 ((i 1))
      (if (<= i other-nb-slots)
          (let ((other-var (stk->var other-slots i)) (var (stk->var slots i)))
            (if (not (eq? var other-var)) (put-var (make-stk i) empty-var))
            (loop4 (+ i 1)))))
    (seal-bb poll? where)
    (set! poll (poll-merge poll other-poll))
    (if (not (eq? entry-bb other-entry-bb))
        (compiler-internal-error
         "merge-contexts-and-seal-bb, entry-bb's do not agree"))))
(define (seal-bb poll? where)
  (define (my-last-pair l) (if (pair? (cdr l)) (my-last-pair (cdr l)) l))
  (define (poll-at split-point)
    (let loop ((i 0) (l1 (bb-non-branch-instrs *bb*)) (l2 '()))
      (if (< i split-point)
          (loop (+ i 1) (cdr l1) (cons (car l1) l2))
          (let* ((label-instr (bb-label-instr *bb*))
                 (non-branch-instrs1 (reverse l2))
                 (non-branch-instrs2 l1)
                 (frame (gvm-instr-frame
                         (car (my-last-pair
                               (cons label-instr non-branch-instrs1)))))
                 (prec-bb (make-bb label-instr *bbs*))
                 (new-lbl (bbs-new-lbl! *bbs*)))
            (bb-non-branch-instrs-set! prec-bb non-branch-instrs1)
            (bb-put-branch!
             prec-bb
             (make-jump (make-lbl new-lbl) #f #t frame #f))
            (bb-label-instr-set! *bb* (make-label-simple new-lbl frame #f))
            (bb-non-branch-instrs-set! *bb* non-branch-instrs2)
            (set! poll (make-poll #t 0))))))
  (define (poll-at-end) (poll-at (length (bb-non-branch-instrs *bb*))))
  (define (impose-polling-constraints)
    (let ((n (+ (length (bb-non-branch-instrs *bb*)) 1))
          (delta (poll-delta poll)))
      (if (> (+ delta n) poll-period)
          (begin
            (poll-at (max (- poll-period delta) 0))
            (impose-polling-constraints)))))
  (if poll? (impose-polling-constraints))
  (let* ((n (+ (length (bb-non-branch-instrs *bb*)) 1))
         (delta (+ (poll-delta poll) n))
         (since-entry? (poll-since-entry? poll)))
    (if (and poll?
             (case where
               ((call) (> delta (- poll-period poll-head)))
               ((tail-call) (> delta poll-tail))
               ((return) (and since-entry? (> delta (+ poll-head poll-tail))))
               ((internal) #f)
               (else
                (compiler-internal-error "seal-bb, unknown 'where':" where))))
        (poll-at-end)
        (set! poll (make-poll since-entry? delta)))))
(define (reg->var regs i)
  (cond ((null? regs) '())
        ((> i 0) (reg->var (cdr regs) (- i 1)))
        (else (car regs))))
(define (stk->var slots i)
  (let ((j (- (length slots) i))) (if (< j 0) '() (list-ref slots j))))
(define (gen-conj/disj node live why)
  (let ((pre (if (conj? node) (conj-pre node) (disj-pre node)))
        (alt (if (conj? node) (conj-alt node) (disj-alt node))))
    (let ((needed (set-union live (free-variables alt)))
          (bool? (boolean-value? pre))
          (predicate-var (make-temp-var 'predicate)))
      (define (general-predicate node live cont)
        (let* ((con-lbl (bbs-new-lbl! *bbs*)) (alt-lbl (bbs-new-lbl! *bbs*)))
          (save-opnd-to-reg
           (gen-node pre live 'need)
           target.proc-result
           predicate-var
           live
           (source-comment pre))
          (seal-bb (intrs-enabled? (node-decl node)) 'internal)
          (bb-put-branch!
           *bb*
           (make-ifjump
            **not-proc-obj
            (list target.proc-result)
            alt-lbl
            con-lbl
            #f
            (current-frame (set-adjoin live predicate-var))
            (source-comment node)))
          (cont con-lbl alt-lbl)))
      (define (alternative con-lbl alt-lbl)
        (let* ((pre-context (current-context))
               (result-var (make-temp-var 'result))
               (con-live (if bool? live (set-adjoin live predicate-var)))
               (alt-live (set-union live (free-variables alt)))
               (con-bb (make-bb (make-label-simple
                                 con-lbl
                                 (current-frame con-live)
                                 (source-comment alt))
                                *bbs*))
               (alt-bb (make-bb (make-label-simple
                                 alt-lbl
                                 (current-frame alt-live)
                                 (source-comment alt))
                                *bbs*)))
          (if bool?
              (begin
                (set! *bb* con-bb)
                (save-opnd-to-reg
                 (make-obj (if (conj? node) false-object #t))
                 target.proc-result
                 result-var
                 live
                 (source-comment node)))
              (put-var (var->opnd predicate-var) result-var))
          (let ((con-context (current-context)))
            (set! *bb* alt-bb)
            (restore-context pre-context)
            (let ((alt-opnd (gen-node alt live why)))
              (if (eq? why 'tail)
                  (begin
                    (restore-context con-context)
                    (set! *bb* con-bb)
                    (let ((ret-opnd (var->opnd ret-var))
                          (result-set (set-singleton result-var)))
                      (seal-bb (intrs-enabled? (node-decl node)) 'return)
                      (dealloc-slots nb-slots)
                      (bb-put-branch!
                       *bb*
                       (make-jump
                        ret-opnd
                        #f
                        #f
                        (current-frame result-set)
                        #f))))
                  (let ((alt-context* (current-context)) (alt-bb* *bb*))
                    (restore-context con-context)
                    (set! *bb* con-bb)
                    (seal-bb (intrs-enabled? (node-decl node)) 'internal)
                    (let ((con-context* (current-context))
                          (next-lbl (bbs-new-lbl! *bbs*)))
                      (restore-context alt-context*)
                      (set! *bb* alt-bb*)
                      (save-opnd-to-reg
                       alt-opnd
                       target.proc-result
                       result-var
                       live
                       (source-comment alt))
                      (merge-contexts-and-seal-bb
                       con-context*
                       (set-adjoin live result-var)
                       (intrs-enabled? (node-decl node))
                       'internal
                       (source-comment node))
                      (let ((frame (current-frame
                                    (set-adjoin live result-var))))
                        (bb-put-branch!
                         *bb*
                         (make-jump (make-lbl next-lbl) #f #f frame #f))
                        (bb-put-branch!
                         con-bb
                         (make-jump (make-lbl next-lbl) #f #f frame #f))
                        (set! *bb*
                              (make-bb (make-label-simple
                                        next-lbl
                                        frame
                                        (source-comment node))
                                       *bbs*))
                        target.proc-result))))))))
      ((if bool? predicate general-predicate)
       pre
       needed
       (lambda (true-lbl false-lbl)
         (if (conj? node)
             (alternative false-lbl true-lbl)
             (alternative true-lbl false-lbl)))))))
(define (gen-call node live why)
  (let* ((oper (app-oper node)) (args (app-args node)) (nb-args (length args)))
    (if (and (prc? oper)
             (not (prc-rest oper))
             (= (length (prc-parms oper)) nb-args))
        (gen-let (prc-parms oper) args (prc-body oper) live why)
        (if (inlinable-app? node)
            (let ((eval-order (arg-eval-order #f args))
                  (vars (map (lambda (x) (cons x #f)) args)))
              (let loop ((l eval-order) (liv live))
                (if (not (null? l))
                    (let* ((needed (vals-live-vars liv (map car (cdr l))))
                           (arg (car (car l)))
                           (pos (cdr (car l)))
                           (var (save-var
                                 (gen-node arg needed 'need)
                                 (make-temp-var pos)
                                 needed
                                 (source-comment arg))))
                      (set-cdr! (assq arg vars) var)
                      (loop (cdr l) (set-adjoin liv var)))
                    (let ((loc (if (eq? why 'side)
                                   (make-reg 0)
                                   (or (lowest-dead-reg live)
                                       (lowest-dead-slot live)))))
                      (if (and (stk? loc) (> (stk-num loc) nb-slots))
                          (push-slot))
                      (let* ((args (map var->opnd (map cdr vars)))
                             (var (make-temp-var 'result))
                             (proc (node->proc oper))
                             (strict-pat (proc-obj-strict-pat proc)))
                        (if (not (eq? why 'side)) (put-var loc var))
                        (bb-put-non-branch!
                         *bb*
                         (make-apply
                          (specialize-for-call proc (node-decl node))
                          args
                          (if (eq? why 'side) #f loc)
                          (current-frame
                           (if (eq? why 'side) live (set-adjoin live var)))
                          (source-comment node)))
                        (gen-return loc why node))))))
            (let* ((calling-local-proc?
                    (and (ref? oper)
                         (let ((opnd (var->opnd (ref-var oper))))
                           (and (lbl? opnd)
                                (let ((x (assq (lbl-num opnd) known-procs)))
                                  (and x
                                       (let ((proc (cdr x)))
                                         (and (not (prc-rest proc))
                                              (= (prc-min proc) nb-args)
                                              (= (length (prc-parms proc))
                                                 nb-args)
                                              (lbl-num opnd)))))))))
                   (jstate (get-jump-state
                            args
                            (if calling-local-proc?
                                (target.label-info nb-args nb-args #f #f)
                                (target.jump-info nb-args))))
                   (in-stk (jump-state-in-stk jstate))
                   (in-reg (jump-state-in-reg jstate))
                   (eval-order
                    (arg-eval-order (if calling-local-proc? #f oper) in-reg))
                   (live-after
                    (if (eq? why 'tail) (set-remove live ret-var) live))
                   (live-for-regs (args-live-vars live eval-order))
                   (return-lbl (if (eq? why 'tail) #f (bbs-new-lbl! *bbs*))))
              (save-regs
               (live-regs live-after)
               (stk-live-vars live-for-regs in-stk why)
               (source-comment node))
              (let ((frame-start (stk-num (highest-live-slot live-after))))
                (let loop1 ((l in-stk) (liv live-after) (i (+ frame-start 1)))
                  (if (not (null? l))
                      (let ((arg (car l))
                            (slot (make-stk i))
                            (needed (set-union
                                     (stk-live-vars liv (cdr l) why)
                                     live-for-regs)))
                        (if arg
                            (let ((var (if (and (eq? arg 'return)
                                                (eq? why 'tail))
                                           ret-var
                                           (make-temp-var (- frame-start i)))))
                              (save-opnd-to-stk
                               (if (eq? arg 'return)
                                   (if (eq? why 'tail)
                                       (var->opnd ret-var)
                                       (make-lbl return-lbl))
                                   (gen-node arg needed 'need))
                               slot
                               var
                               needed
                               (source-comment
                                (if (eq? arg 'return) node arg)))
                              (loop1 (cdr l) (set-adjoin liv var) (+ i 1)))
                            (begin
                              (if (> i nb-slots)
                                  (put-copy
                                   (make-obj undef-object)
                                   slot
                                   empty-var
                                   liv
                                   (source-comment node)))
                              (loop1 (cdr l) liv (+ i 1)))))
                      (let loop2 ((l eval-order)
                                  (liv liv)
                                  (reg-map '())
                                  (oper-var '()))
                        (if (not (null? l))
                            (let* ((arg (car (car l)))
                                   (pos (cdr (car l)))
                                   (needed (args-live-vars liv (cdr l)))
                                   (var (if (and (eq? arg 'return)
                                                 (eq? why 'tail))
                                            ret-var
                                            (make-temp-var pos)))
                                   (opnd (if (eq? arg 'return)
                                             (if (eq? why 'tail)
                                                 (var->opnd ret-var)
                                                 (make-lbl return-lbl))
                                             (gen-node arg needed 'need))))
                              (if (eq? pos 'operator)
                                  (if (and (ref? arg)
                                           (not (or (obj? opnd) (lbl? opnd))))
                                      (loop2 (cdr l)
                                             (set-adjoin liv (ref-var arg))
                                             reg-map
                                             (ref-var arg))
                                      (begin
                                        (save-arg
                                         opnd
                                         var
                                         needed
                                         (source-comment
                                          (if (eq? arg 'return) node arg)))
                                        (loop2 (cdr l)
                                               (set-adjoin liv var)
                                               reg-map
                                               var)))
                                  (let ((reg (make-reg pos)))
                                    (if (all-args-trivial? (cdr l))
                                        (save-opnd-to-reg
                                         opnd
                                         reg
                                         var
                                         needed
                                         (source-comment
                                          (if (eq? arg 'return) node arg)))
                                        (save-in-slot
                                         opnd
                                         var
                                         needed
                                         (source-comment
                                          (if (eq? arg 'return) node arg))))
                                    (loop2 (cdr l)
                                           (set-adjoin liv var)
                                           (cons (cons pos var) reg-map)
                                           oper-var))))
                            (let loop3 ((i (- target.nb-regs 1)))
                              (if (>= i 0)
                                  (let ((couple (assq i reg-map)))
                                    (if couple
                                        (let ((var (cdr couple)))
                                          (if (not (eq? (reg->var regs i) var))
                                              (save-opnd-to-reg
                                               (var->opnd var)
                                               (make-reg i)
                                               var
                                               liv
                                               (source-comment node)))))
                                    (loop3 (- i 1)))
                                  (let ((opnd (if calling-local-proc?
                                                  (make-lbl
                                                   (+ calling-local-proc? 1))
                                                  (var->opnd oper-var))))
                                    (seal-bb (intrs-enabled? (node-decl node))
                                             (if return-lbl 'call 'tail-call))
                                    (dealloc-slots
                                     (- nb-slots
                                        (+ frame-start (length in-stk))))
                                    (bb-put-branch!
                                     *bb*
                                     (make-jump
                                      opnd
                                      (if calling-local-proc? #f nb-args)
                                      #f
                                      (current-frame liv)
                                      (source-comment node)))
                                    (let ((result-var (make-temp-var 'result)))
                                      (dealloc-slots (- nb-slots frame-start))
                                      (flush-regs)
                                      (put-var target.proc-result result-var)
                                      (if return-lbl
                                          (begin
                                            (set! poll (return-poll poll))
                                            (set! *bb*
                                                  (make-bb (make-label-return
                                                            return-lbl
                                                            (current-frame
                                                             (set-adjoin
                                                              live
                                                              result-var))
                                                            (source-comment
                                                             node))
                                                           *bbs*))))
                                      target.proc-result))))))))))))))
(define (contained-reg/slot opnd)
  (cond ((reg? opnd) opnd)
        ((stk? opnd) opnd)
        ((clo? opnd) (contained-reg/slot (clo-base opnd)))
        (else #f)))
(define (opnd-needed opnd needed)
  (let ((x (contained-reg/slot opnd)))
    (if x (set-adjoin needed (get-var x)) needed)))
(define (save-opnd opnd live comment)
  (let ((slot (lowest-dead-slot live)))
    (put-copy opnd slot (get-var opnd) live comment)))
(define (save-regs regs live comment)
  (for-each
   (lambda (i) (save-opnd (make-reg i) live comment))
   (set->list regs)))
(define (save-opnd-to-reg opnd reg var live comment)
  (if (set-member? (reg-num reg) (live-regs live))
      (save-opnd reg (opnd-needed opnd live) comment))
  (put-copy opnd reg var live comment))
(define (save-opnd-to-stk opnd stk var live comment)
  (if (set-member? (stk-num stk) (live-slots live))
      (save-opnd stk (opnd-needed opnd live) comment))
  (put-copy opnd stk var live comment))
(define (all-args-trivial? l)
  (if (null? l)
      #t
      (let ((arg (car (car l))))
        (or (eq? arg 'return)
            (and (trivial? arg) (all-args-trivial? (cdr l)))))))
(define (every-trivial? l)
  (or (null? l) (and (trivial? (car l)) (every-trivial? (cdr l)))))
(define (trivial? node)
  (or (cst? node)
      (ref? node)
      (and (set? node) (trivial? (set-val node)))
      (and (inlinable-app? node) (every-trivial? (app-args node)))))
(define (inlinable-app? node)
  (if (app? node)
      (let ((proc (node->proc (app-oper node))))
        (and proc
             (let ((spec (specialize-for-call proc (node-decl node))))
               (and (proc-obj-inlinable spec)
                    (nb-args-conforms?
                     (length (app-args node))
                     (proc-obj-call-pat spec))))))
      #f))
(define (boolean-value? node)
  (or (and (conj? node)
           (boolean-value? (conj-pre node))
           (boolean-value? (conj-alt node)))
      (and (disj? node)
           (boolean-value? (disj-pre node))
           (boolean-value? (disj-alt node)))
      (boolean-app? node)))
(define (boolean-app? node)
  (if (app? node)
      (let ((proc (node->proc (app-oper node))))
        (if proc (eq? (type-name (proc-obj-type proc)) 'boolean) #f))
      #f))
(define (node->proc node)
  (cond ((cst? node) (if (proc-obj? (cst-val node)) (cst-val node) #f))
        ((ref? node)
         (if (global? (ref-var node))
             (target.prim-info* (var-name (ref-var node)) (node-decl node))
             #f))
        (else #f)))
(define (specialize-for-call proc decl) ((proc-obj-specialize proc) decl))
(define (get-jump-state args pc)
  (define (empty-node-list n)
    (if (> n 0) (cons #f (empty-node-list (- n 1))) '()))
  (let* ((fs (pcontext-fs pc))
         (slots-list (empty-node-list fs))
         (regs-list (empty-node-list target.nb-regs)))
    (define (assign-node-to-loc var loc)
      (let ((x (cond ((reg? loc)
                      (let ((i (reg-num loc)))
                        (if (<= i target.nb-regs)
                            (nth-after regs-list i)
                            (compiler-internal-error
                             "jump-state, reg out of bound in back-end's pcontext"))))
                     ((stk? loc)
                      (let ((i (stk-num loc)))
                        (if (<= i fs)
                            (nth-after slots-list (- i 1))
                            (compiler-internal-error
                             "jump-state, stk out of bound in back-end's pcontext"))))
                     (else
                      (compiler-internal-error
                       "jump-state, loc other than reg or stk in back-end's pcontext")))))
        (if (not (car x))
            (set-car! x var)
            (compiler-internal-error
             "jump-state, duplicate location in back-end's pcontext"))))
    (let loop ((l (pcontext-map pc)))
      (if (not (null? l))
          (let* ((couple (car l)) (name (car couple)) (loc (cdr couple)))
            (cond ((eq? name 'return) (assign-node-to-loc 'return loc))
                  (else (assign-node-to-loc (list-ref args (- name 1)) loc)))
            (loop (cdr l)))))
    (vector slots-list regs-list)))
(define (jump-state-in-stk x) (vector-ref x 0))
(define (jump-state-in-reg x) (vector-ref x 1))
(define (arg-eval-order oper nodes)
  (define (loop nodes pos part1 part2)
    (cond ((null? nodes)
           (let ((p1 (reverse part1)) (p2 (free-vars-order part2)))
             (cond ((not oper) (append p1 p2))
                   ((trivial? oper)
                    (append p1 p2 (list (cons oper 'operator))))
                   (else (append (cons (cons oper 'operator) p1) p2)))))
          ((not (car nodes)) (loop (cdr nodes) (+ pos 1) part1 part2))
          ((or (eq? (car nodes) 'return) (trivial? (car nodes)))
           (loop (cdr nodes)
                 (+ pos 1)
                 part1
                 (cons (cons (car nodes) pos) part2)))
          (else
           (loop (cdr nodes)
                 (+ pos 1)
                 (cons (cons (car nodes) pos) part1)
                 part2))))
  (loop nodes 0 '() '()))
(define (free-vars-order l)
  (let ((bins '()) (ordered-args '()))
    (define (free-v x) (if (eq? x 'return) (set-empty) (free-variables x)))
    (define (add-to-bin! x)
      (let ((y (assq x bins)))
        (if y (set-cdr! y (+ (cdr y) 1)) (set! bins (cons (cons x 1) bins)))))
    (define (payoff-if-removed node)
      (let ((x (free-v node)))
        (let loop ((l (set->list x)) (r 0))
          (if (null? l)
              r
              (let ((y (cdr (assq (car l) bins))))
                (loop (cdr l) (+ r (quotient 1000 (* y y)))))))))
    (define (remove-free-vars! x)
      (let loop ((l (set->list x)))
        (if (not (null? l))
            (let ((y (assq (car l) bins)))
              (set-cdr! y (- (cdr y) 1))
              (loop (cdr l))))))
    (define (find-max-payoff l thunk)
      (if (null? l)
          (thunk '() -1)
          (find-max-payoff
           (cdr l)
           (lambda (best-arg best-payoff)
             (let ((payoff (payoff-if-removed (car (car l)))))
               (if (>= payoff best-payoff)
                   (thunk (car l) payoff)
                   (thunk best-arg best-payoff)))))))
    (define (remove x l)
      (cond ((null? l) '())
            ((eq? x (car l)) (cdr l))
            (else (cons (car l) (remove x (cdr l))))))
    (for-each
     (lambda (x) (for-each add-to-bin! (set->list (free-v (car x)))))
     l)
    (let loop ((args l) (ordered-args '()))
      (if (null? args)
          (reverse ordered-args)
          (find-max-payoff
           args
           (lambda (best-arg best-payoff)
             (remove-free-vars! (free-v (car best-arg)))
             (loop (remove best-arg args) (cons best-arg ordered-args))))))))
(define (args-live-vars live order)
  (cond ((null? order) live)
        ((eq? (car (car order)) 'return)
         (args-live-vars (set-adjoin live ret-var) (cdr order)))
        (else
         (args-live-vars
          (set-union live (free-variables (car (car order))))
          (cdr order)))))
(define (stk-live-vars live slots why)
  (cond ((null? slots) live)
        ((not (car slots)) (stk-live-vars live (cdr slots) why))
        ((eq? (car slots) 'return)
         (stk-live-vars
          (if (eq? why 'tail) (set-adjoin live ret-var) live)
          (cdr slots)
          why))
        (else
         (stk-live-vars
          (set-union live (free-variables (car slots)))
          (cdr slots)
          why))))
(define (gen-let vars vals node live why)
  (let ((var-val-map (pair-up vars vals))
        (var-set (list->set vars))
        (all-live
         (set-union
          live
          (free-variables node)
          (apply set-union (map free-variables vals)))))
    (define (var->val var) (cdr (assq var var-val-map)))
    (define (proc-var? var) (prc? (var->val var)))
    (define (closed-vars var const-proc-vars)
      (set-difference
       (not-constant-closed-vars (var->val var))
       const-proc-vars))
    (define (no-closed-vars? var const-proc-vars)
      (set-empty? (closed-vars var const-proc-vars)))
    (define (closed-vars? var const-proc-vars)
      (not (no-closed-vars? var const-proc-vars)))
    (define (compute-const-proc-vars proc-vars)
      (let loop1 ((const-proc-vars proc-vars))
        (let ((new-const-proc-vars
               (set-keep
                (lambda (x) (no-closed-vars? x const-proc-vars))
                const-proc-vars)))
          (if (not (set-equal? new-const-proc-vars const-proc-vars))
              (loop1 new-const-proc-vars)
              const-proc-vars))))
    (let* ((proc-vars (set-keep proc-var? var-set))
           (const-proc-vars (compute-const-proc-vars proc-vars))
           (clo-vars
            (set-keep (lambda (x) (closed-vars? x const-proc-vars)) proc-vars))
           (clo-vars-list (set->list clo-vars)))
      (for-each
       (lambda (proc-var)
         (let ((label (schedule-gen-proc (var->val proc-var) '())))
           (add-known-proc (lbl-num label) (var->val proc-var))
           (add-constant-var proc-var label)))
       (set->list const-proc-vars))
      (let ((non-clo-vars-list
             (set->list
              (set-keep
               (lambda (var)
                 (and (not (set-member? var const-proc-vars))
                      (not (set-member? var clo-vars))))
               vars)))
            (liv (set-union
                  live
                  (apply set-union
                         (map (lambda (x) (closed-vars x const-proc-vars))
                              clo-vars-list))
                  (free-variables node))))
        (let loop2 ((vars* non-clo-vars-list))
          (if (not (null? vars*))
              (let* ((var (car vars*))
                     (val (var->val var))
                     (needed (vals-live-vars liv (map var->val (cdr vars*)))))
                (if (var-useless? var)
                    (gen-node val needed 'side)
                    (save-val
                     (gen-node val needed 'need)
                     var
                     needed
                     (source-comment val)))
                (loop2 (cdr vars*)))))
        (if (pair? clo-vars-list)
            (begin
              (dealloc-slots (- nb-slots (stk-num (highest-live-slot liv))))
              (let loop3 ((l clo-vars-list))
                (if (not (null? l))
                    (begin
                      (push-slot)
                      (let ((var (car l)) (slot (make-stk nb-slots)))
                        (put-var slot var)
                        (loop3 (cdr l))))))
              (bb-put-non-branch!
               *bb*
               (make-close
                (map (lambda (var)
                       (let ((closed-list
                              (sort-variables
                               (set->list (closed-vars var const-proc-vars)))))
                         (if (null? closed-list)
                             (compiler-internal-error
                              "gen-let, no closed variables:"
                              (var-name var))
                             (make-closure-parms
                              (var->opnd var)
                              (lbl-num (schedule-gen-proc
                                        (var->val var)
                                        closed-list))
                              (map var->opnd closed-list)))))
                     clo-vars-list)
                (current-frame liv)
                (source-comment node)))))
        (gen-node node live why)))))
(define (save-arg opnd var live comment)
  (if (glo? opnd)
      (add-constant-var var opnd)
      (save-val opnd var live comment)))
(define (save-val opnd var live comment)
  (cond ((or (obj? opnd) (lbl? opnd)) (add-constant-var var opnd))
        ((and (reg? opnd) (not (set-member? (reg-num opnd) (live-regs live))))
         (put-var opnd var))
        ((and (stk? opnd) (not (set-member? (stk-num opnd) (live-slots live))))
         (put-var opnd var))
        (else (save-in-slot opnd var live comment))))
(define (save-in-slot opnd var live comment)
  (let ((slot (lowest-dead-slot live))) (put-copy opnd slot var live comment)))
(define (save-var opnd var live comment)
  (cond ((or (obj? opnd) (lbl? opnd)) (add-constant-var var opnd) var)
        ((or (glo? opnd) (reg? opnd) (stk? opnd)) (get-var opnd))
        (else
         (let ((dest (or (highest-dead-reg live) (lowest-dead-slot live))))
           (put-copy opnd dest var live comment)
           var))))
(define (put-copy opnd loc var live comment)
  (if (and (stk? loc) (> (stk-num loc) nb-slots)) (push-slot))
  (if var (put-var loc var))
  (if (not (eq? opnd loc))
      (bb-put-non-branch!
       *bb*
       (make-copy
        opnd
        loc
        (current-frame (if var (set-adjoin live var) live))
        comment))))
(define (var-useless? var)
  (and (set-empty? (var-refs var)) (set-empty? (var-sets var))))
(define (vals-live-vars live vals)
  (if (null? vals)
      live
      (vals-live-vars
       (set-union live (free-variables (car vals)))
       (cdr vals))))
(define (gen-fut node live why)
  (let* ((val (fut-val node))
         (clo-vars (not-constant-closed-vars val))
         (clo-vars-list (set->list clo-vars))
         (ret-var* (make-temp-var 0))
         (live-after live)
         (live-starting-task
          (set-adjoin (set-union live-after clo-vars) ret-var*))
         (task-lbl (bbs-new-lbl! *bbs*))
         (return-lbl (bbs-new-lbl! *bbs*)))
    (save-regs (live-regs live-after) live-starting-task (source-comment node))
    (let ((frame-start (stk-num (highest-live-slot live-after))))
      (save-opnd-to-reg
       (make-lbl return-lbl)
       target.task-return
       ret-var*
       (set-remove live-starting-task ret-var*)
       (source-comment node))
      (let loop1 ((l clo-vars-list) (i 0))
        (if (null? l)
            (dealloc-slots (- nb-slots (+ frame-start i)))
            (let ((var (car l)) (rest (cdr l)))
              (if (memq var regs)
                  (loop1 rest i)
                  (let loop2 ((j (- target.nb-regs 1)))
                    (if (>= j 0)
                        (if (or (>= j (length regs))
                                (not (set-member?
                                      (list-ref regs j)
                                      live-starting-task)))
                            (let ((reg (make-reg j)))
                              (put-copy
                               (var->opnd var)
                               reg
                               var
                               live-starting-task
                               (source-comment node))
                              (loop1 rest i))
                            (loop2 (- j 1)))
                        (let ((slot (make-stk (+ frame-start (+ i 1))))
                              (needed (list->set rest)))
                          (if (and (or (> (stk-num slot) nb-slots)
                                       (not (memq (list-ref
                                                   slots
                                                   (- nb-slots (stk-num slot)))
                                                  regs)))
                                   (set-member?
                                    (stk-num slot)
                                    (live-slots needed)))
                              (save-opnd
                               slot
                               live-starting-task
                               (source-comment node)))
                          (put-copy
                           (var->opnd var)
                           slot
                           var
                           live-starting-task
                           (source-comment node))
                          (loop1 rest (+ i 1)))))))))
      (seal-bb (intrs-enabled? (node-decl node)) 'call)
      (bb-put-branch!
       *bb*
       (make-jump
        (make-lbl task-lbl)
        #f
        #f
        (current-frame live-starting-task)
        #f))
      (let ((task-context
             (make-context
              (- nb-slots frame-start)
              (reverse (nth-after (reverse slots) frame-start))
              (cons ret-var (cdr regs))
              '()
              poll
              entry-bb))
            (return-context
             (make-context
              frame-start
              (nth-after slots (- nb-slots frame-start))
              '()
              closed
              (return-poll poll)
              entry-bb)))
        (restore-context task-context)
        (set! *bb*
              (make-bb (make-label-task-entry
                        task-lbl
                        (current-frame live-starting-task)
                        (source-comment node))
                       *bbs*))
        (gen-node val ret-var-set 'tail)
        (let ((result-var (make-temp-var 'future)))
          (restore-context return-context)
          (put-var target.proc-result result-var)
          (set! *bb*
                (make-bb (make-label-task-return
                          return-lbl
                          (current-frame (set-adjoin live result-var))
                          (source-comment node))
                         *bbs*))
          (gen-return target.proc-result why node))))))
(define prim-procs
  '(("not" (1) #f 0 boolean)
    ("boolean?" (1) #f 0 boolean)
    ("eqv?" (2) #f 0 boolean)
    ("eq?" (2) #f 0 boolean)
    ("equal?" (2) #f 0 boolean)
    ("pair?" (1) #f 0 boolean)
    ("cons" (2) #f () pair)
    ("car" (1) #f 0 (#f))
    ("cdr" (1) #f 0 (#f))
    ("set-car!" (2) #t (1) pair)
    ("set-cdr!" (2) #t (1) pair)
    ("caar" (1) #f 0 (#f))
    ("cadr" (1) #f 0 (#f))
    ("cdar" (1) #f 0 (#f))
    ("cddr" (1) #f 0 (#f))
    ("caaar" (1) #f 0 (#f))
    ("caadr" (1) #f 0 (#f))
    ("cadar" (1) #f 0 (#f))
    ("caddr" (1) #f 0 (#f))
    ("cdaar" (1) #f 0 (#f))
    ("cdadr" (1) #f 0 (#f))
    ("cddar" (1) #f 0 (#f))
    ("cdddr" (1) #f 0 (#f))
    ("caaaar" (1) #f 0 (#f))
    ("caaadr" (1) #f 0 (#f))
    ("caadar" (1) #f 0 (#f))
    ("caaddr" (1) #f 0 (#f))
    ("cadaar" (1) #f 0 (#f))
    ("cadadr" (1) #f 0 (#f))
    ("caddar" (1) #f 0 (#f))
    ("cadddr" (1) #f 0 (#f))
    ("cdaaar" (1) #f 0 (#f))
    ("cdaadr" (1) #f 0 (#f))
    ("cdadar" (1) #f 0 (#f))
    ("cdaddr" (1) #f 0 (#f))
    ("cddaar" (1) #f 0 (#f))
    ("cddadr" (1) #f 0 (#f))
    ("cdddar" (1) #f 0 (#f))
    ("cddddr" (1) #f 0 (#f))
    ("null?" (1) #f 0 boolean)
    ("list?" (1) #f 0 boolean)
    ("list" 0 #f () list)
    ("length" (1) #f 0 integer)
    ("append" 0 #f 0 list)
    ("reverse" (1) #f 0 list)
    ("list-ref" (2) #f 0 (#f))
    ("memq" (2) #f 0 list)
    ("memv" (2) #f 0 list)
    ("member" (2) #f 0 list)
    ("assq" (2) #f 0 #f)
    ("assv" (2) #f 0 #f)
    ("assoc" (2) #f 0 #f)
    ("symbol?" (1) #f 0 boolean)
    ("symbol->string" (1) #f 0 string)
    ("string->symbol" (1) #f 0 symbol)
    ("number?" (1) #f 0 boolean)
    ("complex?" (1) #f 0 boolean)
    ("real?" (1) #f 0 boolean)
    ("rational?" (1) #f 0 boolean)
    ("integer?" (1) #f 0 boolean)
    ("exact?" (1) #f 0 boolean)
    ("inexact?" (1) #f 0 boolean)
    ("=" 0 #f 0 boolean)
    ("<" 0 #f 0 boolean)
    (">" 0 #f 0 boolean)
    ("<=" 0 #f 0 boolean)
    (">=" 0 #f 0 boolean)
    ("zero?" (1) #f 0 boolean)
    ("positive?" (1) #f 0 boolean)
    ("negative?" (1) #f 0 boolean)
    ("odd?" (1) #f 0 boolean)
    ("even?" (1) #f 0 boolean)
    ("max" 1 #f 0 number)
    ("min" 1 #f 0 number)
    ("+" 0 #f 0 number)
    ("*" 0 #f 0 number)
    ("-" 1 #f 0 number)
    ("/" 1 #f 0 number)
    ("abs" (1) #f 0 number)
    ("quotient" 1 #f 0 integer)
    ("remainder" (2) #f 0 integer)
    ("modulo" (2) #f 0 integer)
    ("gcd" 1 #f 0 integer)
    ("lcm" 1 #f 0 integer)
    ("numerator" (1) #f 0 integer)
    ("denominator" (1) #f 0 integer)
    ("floor" (1) #f 0 integer)
    ("ceiling" (1) #f 0 integer)
    ("truncate" (1) #f 0 integer)
    ("round" (1) #f 0 integer)
    ("rationalize" (2) #f 0 number)
    ("exp" (1) #f 0 number)
    ("log" (1) #f 0 number)
    ("sin" (1) #f 0 number)
    ("cos" (1) #f 0 number)
    ("tan" (1) #f 0 number)
    ("asin" (1) #f 0 number)
    ("acos" (1) #f 0 number)
    ("atan" (1 2) #f 0 number)
    ("sqrt" (1) #f 0 number)
    ("expt" (2) #f 0 number)
    ("make-rectangular" (2) #f 0 number)
    ("make-polar" (2) #f 0 number)
    ("real-part" (1) #f 0 real)
    ("imag-part" (1) #f 0 real)
    ("magnitude" (1) #f 0 real)
    ("angle" (1) #f 0 real)
    ("exact->inexact" (1) #f 0 number)
    ("inexact->exact" (1) #f 0 number)
    ("number->string" (1 2) #f 0 string)
    ("string->number" (1 2) #f 0 number)
    ("char?" (1) #f 0 boolean)
    ("char=?" 0 #f 0 boolean)
    ("char<?" 0 #f 0 boolean)
    ("char>?" 0 #f 0 boolean)
    ("char<=?" 0 #f 0 boolean)
    ("char>=?" 0 #f 0 boolean)
    ("char-ci=?" 0 #f 0 boolean)
    ("char-ci<?" 0 #f 0 boolean)
    ("char-ci>?" 0 #f 0 boolean)
    ("char-ci<=?" 0 #f 0 boolean)
    ("char-ci>=?" 0 #f 0 boolean)
    ("char-alphabetic?" (1) #f 0 boolean)
    ("char-numeric?" (1) #f 0 boolean)
    ("char-whitespace?" (1) #f 0 boolean)
    ("char-upper-case?" (1) #f 0 boolean)
    ("char-lower-case?" (1) #f 0 boolean)
    ("char->integer" (1) #f 0 integer)
    ("integer->char" (1) #f 0 char)
    ("char-upcase" (1) #f 0 char)
    ("char-downcase" (1) #f 0 char)
    ("string?" (1) #f 0 boolean)
    ("make-string" (1 2) #f 0 string)
    ("string" 0 #f 0 string)
    ("string-length" (1) #f 0 integer)
    ("string-ref" (2) #f 0 char)
    ("string-set!" (3) #t 0 string)
    ("string=?" 0 #f 0 boolean)
    ("string<?" 0 #f 0 boolean)
    ("string>?" 0 #f 0 boolean)
    ("string<=?" 0 #f 0 boolean)
    ("string>=?" 0 #f 0 boolean)
    ("string-ci=?" 0 #f 0 boolean)
    ("string-ci<?" 0 #f 0 boolean)
    ("string-ci>?" 0 #f 0 boolean)
    ("string-ci<=?" 0 #f 0 boolean)
    ("string-ci>=?" 0 #f 0 boolean)
    ("substring" (3) #f 0 string)
    ("string-append" 0 #f 0 string)
    ("vector?" (1) #f 0 boolean)
    ("make-vector" (1 2) #f (1) vector)
    ("vector" 0 #f () vector)
    ("vector-length" (1) #f 0 integer)
    ("vector-ref" (2) #f 0 (#f))
    ("vector-set!" (3) #t (1 2) vector)
    ("procedure?" (1) #f 0 boolean)
    ("apply" 2 #t 0 (#f))
    ("map" 2 #t 0 list)
    ("for-each" 2 #t 0 #f)
    ("call-with-current-continuation" (1) #t 0 (#f))
    ("call-with-input-file" (2) #t 0 (#f))
    ("call-with-output-file" (2) #t 0 (#f))
    ("input-port?" (1) #f 0 boolean)
    ("output-port?" (1) #f 0 boolean)
    ("current-input-port" (0) #f 0 port)
    ("current-output-port" (0) #f 0 port)
    ("open-input-file" (1) #t 0 port)
    ("open-output-file" (1) #t 0 port)
    ("close-input-port" (1) #t 0 #f)
    ("close-output-port" (1) #t 0 #f)
    ("eof-object?" (1) #f 0 boolean)
    ("read" (0 1) #t 0 #f)
    ("read-char" (0 1) #t 0 #f)
    ("peek-char" (0 1) #t 0 #f)
    ("write" (0 1) #t 0 #f)
    ("display" (0 1) #t 0 #f)
    ("newline" (0 1) #t 0 #f)
    ("write-char" (1 2) #t 0 #f)
    ("list-tail" (2) #f 0 (#f))
    ("string->list" (1) #f 0 list)
    ("list->string" (1) #f 0 string)
    ("string-copy" (1) #f 0 string)
    ("string-fill!" (2) #t 0 string)
    ("vector->list" (1) #f 0 list)
    ("list->vector" (1) #f 0 vector)
    ("vector-fill!" (2) #t 0 vector)
    ("force" (1) #t 0 #f)
    ("with-input-from-file" (2) #t 0 (#f))
    ("with-output-to-file" (2) #t 0 (#f))
    ("char-ready?" (0 1) #f 0 boolean)
    ("load" (1) #t 0 (#f))
    ("transcript-on" (1) #t 0 #f)
    ("transcript-off" (0) #t 0 #f)
    ("touch" (1) #t 0 #f)
    ("##type" (1) #f () integer)
    ("##type-cast" (2) #f () (#f))
    ("##subtype" (1) #f () integer)
    ("##subtype-set!" (2) #t () #f)
    ("##not" (1) #f () boolean)
    ("##null?" (1) #f () boolean)
    ("##unassigned?" (1) #f () boolean)
    ("##unbound?" (1) #f () boolean)
    ("##eq?" (2) #f () boolean)
    ("##fixnum?" (1) #f () boolean)
    ("##flonum?" (1) #f () boolean)
    ("##special?" (1) #f () boolean)
    ("##pair?" (1) #f () boolean)
    ("##subtyped?" (1) #f () boolean)
    ("##procedure?" (1) #f () boolean)
    ("##placeholder?" (1) #f () boolean)
    ("##vector?" (1) #f () boolean)
    ("##symbol?" (1) #f () boolean)
    ("##ratnum?" (1) #f () boolean)
    ("##cpxnum?" (1) #f () boolean)
    ("##string?" (1) #f () boolean)
    ("##bignum?" (1) #f () boolean)
    ("##char?" (1) #f () boolean)
    ("##closure?" (1) #f () boolean)
    ("##subprocedure?" (1) #f () boolean)
    ("##return-dynamic-env-bind?" (1) #f () boolean)
    ("##fixnum.+" 0 #f () integer)
    ("##fixnum.*" 0 #f () integer)
    ("##fixnum.-" 1 #f () integer)
    ("##fixnum.quotient" (2) #f () integer)
    ("##fixnum.remainder" (2) #f () integer)
    ("##fixnum.modulo" (2) #f () integer)
    ("##fixnum.logior" 0 #f () integer)
    ("##fixnum.logxor" 0 #f () integer)
    ("##fixnum.logand" 0 #f () integer)
    ("##fixnum.lognot" (1) #f () integer)
    ("##fixnum.ash" (2) #f () integer)
    ("##fixnum.lsh" (2) #f () integer)
    ("##fixnum.zero?" (1) #f () boolean)
    ("##fixnum.positive?" (1) #f () boolean)
    ("##fixnum.negative?" (1) #f () boolean)
    ("##fixnum.odd?" (1) #f () boolean)
    ("##fixnum.even?" (1) #f () boolean)
    ("##fixnum.=" 0 #f () boolean)
    ("##fixnum.<" 0 #f () boolean)
    ("##fixnum.>" 0 #f () boolean)
    ("##fixnum.<=" 0 #f () boolean)
    ("##fixnum.>=" 0 #f () boolean)
    ("##flonum.->fixnum" (1) #f () integer)
    ("##flonum.<-fixnum" (1) #f () real)
    ("##flonum.+" 0 #f () real)
    ("##flonum.*" 0 #f () real)
    ("##flonum.-" 1 #f () real)
    ("##flonum./" 1 #f () real)
    ("##flonum.abs" (1) #f () real)
    ("##flonum.truncate" (1) #f () real)
    ("##flonum.round" (1) #f () real)
    ("##flonum.exp" (1) #f () real)
    ("##flonum.log" (1) #f () real)
    ("##flonum.sin" (1) #f () real)
    ("##flonum.cos" (1) #f () real)
    ("##flonum.tan" (1) #f () real)
    ("##flonum.asin" (1) #f () real)
    ("##flonum.acos" (1) #f () real)
    ("##flonum.atan" (1) #f () real)
    ("##flonum.sqrt" (1) #f () real)
    ("##flonum.zero?" (1) #f () boolean)
    ("##flonum.positive?" (1) #f () boolean)
    ("##flonum.negative?" (1) #f () boolean)
    ("##flonum.=" 0 #f () boolean)
    ("##flonum.<" 0 #f () boolean)
    ("##flonum.>" 0 #f () boolean)
    ("##flonum.<=" 0 #f () boolean)
    ("##flonum.>=" 0 #f () boolean)
    ("##char=?" 0 #f () boolean)
    ("##char<?" 0 #f () boolean)
    ("##char>?" 0 #f () boolean)
    ("##char<=?" 0 #f () boolean)
    ("##char>=?" 0 #f () boolean)
    ("##cons" (2) #f () pair)
    ("##set-car!" (2) #t () pair)
    ("##set-cdr!" (2) #t () pair)
    ("##car" (1) #f () (#f))
    ("##cdr" (1) #f () (#f))
    ("##caar" (1) #f () (#f))
    ("##cadr" (1) #f () (#f))
    ("##cdar" (1) #f () (#f))
    ("##cddr" (1) #f () (#f))
    ("##caaar" (1) #f () (#f))
    ("##caadr" (1) #f () (#f))
    ("##cadar" (1) #f () (#f))
    ("##caddr" (1) #f () (#f))
    ("##cdaar" (1) #f () (#f))
    ("##cdadr" (1) #f () (#f))
    ("##cddar" (1) #f () (#f))
    ("##cdddr" (1) #f () (#f))
    ("##caaaar" (1) #f () (#f))
    ("##caaadr" (1) #f () (#f))
    ("##caadar" (1) #f () (#f))
    ("##caaddr" (1) #f () (#f))
    ("##cadaar" (1) #f () (#f))
    ("##cadadr" (1) #f () (#f))
    ("##caddar" (1) #f () (#f))
    ("##cadddr" (1) #f () (#f))
    ("##cdaaar" (1) #f () (#f))
    ("##cdaadr" (1) #f () (#f))
    ("##cdadar" (1) #f () (#f))
    ("##cdaddr" (1) #f () (#f))
    ("##cddaar" (1) #f () (#f))
    ("##cddadr" (1) #f () (#f))
    ("##cdddar" (1) #f () (#f))
    ("##cddddr" (1) #f () (#f))
    ("##make-cell" (1) #f () pair)
    ("##cell-ref" (1) #f () (#f))
    ("##cell-set!" (2) #t () pair)
    ("##vector" 0 #f () vector)
    ("##make-vector" (2) #f () vector)
    ("##vector-length" (1) #f () integer)
    ("##vector-ref" (2) #f () (#f))
    ("##vector-set!" (3) #t () vector)
    ("##vector-shrink!" (2) #t () vector)
    ("##string" 0 #f () string)
    ("##make-string" (2) #f () string)
    ("##string-length" (1) #f () integer)
    ("##string-ref" (2) #f () char)
    ("##string-set!" (3) #t () string)
    ("##string-shrink!" (2) #t () string)
    ("##vector8" 0 #f () string)
    ("##make-vector8" (2) #f () string)
    ("##vector8-length" (1) #f () integer)
    ("##vector8-ref" (2) #f () integer)
    ("##vector8-set!" (3) #t () string)
    ("##vector8-shrink!" (2) #t () string)
    ("##vector16" 0 #f () string)
    ("##make-vector16" (2) #f () string)
    ("##vector16-length" (1) #f () integer)
    ("##vector16-ref" (2) #f () integer)
    ("##vector16-set!" (3) #t () string)
    ("##vector16-shrink!" (2) #t () string)
    ("##closure-code" (1) #f () #f)
    ("##closure-ref" (2) #f () (#f))
    ("##closure-set!" (3) #t () #f)
    ("##subprocedure-id" (1) #f () #f)
    ("##subprocedure-parent" (1) #f () #f)
    ("##return-fs" (1) #f () #f)
    ("##return-link" (1) #f () #f)
    ("##procedure-info" (1) #f () #f)
    ("##pstate" (0) #f () #f)
    ("##make-placeholder" (1) #f 0 (#f))
    ("##touch" (1) #t 0 #f)
    ("##apply" (2) #t () (#f))
    ("##call-with-current-continuation" (1) #t () (#f))
    ("##global-var" (1) #t () #f)
    ("##global-var-ref" (1) #f () (#f))
    ("##global-var-set!" (2) #t () #f)
    ("##atomic-car" (1) #f () (#f))
    ("##atomic-cdr" (1) #f () (#f))
    ("##atomic-set-car!" (2) #t () pair)
    ("##atomic-set-cdr!" (2) #t () pair)
    ("##atomic-set-car-if-eq?!" (3) #t () boolean)
    ("##atomic-set-cdr-if-eq?!" (3) #t () boolean)
    ("##quasi-append" 0 #f 0 list)
    ("##quasi-list" 0 #f () list)
    ("##quasi-cons" (2) #f () pair)
    ("##quasi-list->vector" (1) #f 0 vector)
    ("##case-memv" (2) #f 0 list)))
(define ofile-version-major 5)
(define ofile-version-minor 0)
(define prim-proc-prefix 1)
(define user-proc-prefix 2)
(define pair-prefix 3)
(define flonum-prefix 4)
(define local-object-bits -524281)
(define symbol-object-bits -393209)
(define prim-proc-object-bits -262137)
(define padding-tag 0)
(define end-of-code-tag 32768)
(define m68020-proc-code-tag 32769)
(define m68881-proc-code-tag 32770)
(define stat-tag 32771)
(define global-var-ref-tag 34816)
(define global-var-set-tag 36864)
(define global-var-ref-jump-tag 38912)
(define prim-proc-ref-tag 40960)
(define local-proc-ref-tag 49152)
(define long-index-mask 16383)
(define word-index-mask 2047)
(define (ofile.begin! filename add-obj)
  (set! ofile-add-obj add-obj)
  (set! ofile-syms (queue-empty))
;  (set! *ofile-port1* (open-output-file (string-append filename ".O")))
  (if ofile-asm?
      (begin
        (set! *ofile-port2*
              (asm-open-output-file (string-append filename ".asm")))
        (set! *ofile-pos* 0)))
  (ofile-word ofile-version-major)
  (ofile-word ofile-version-minor)
  '())
(define (ofile.end!)
  (ofile-line "")
;  (close-output-port *ofile-port1*)
  (if ofile-asm? (asm-close-output-port *ofile-port2*))
  '())
(define asm-output '())
(define asm-line '())
(define (asm-open-output-file filename)
  (set! asm-output '())
  (set! asm-line '()))
(define (asm-close-output-port asm-port) #f)
(define (asm-newline asm-port) (asm-display char-newline asm-port))
(define (asm-display obj asm-port)
  (if (eqv? obj char-newline)
      (begin
        (set! asm-output
              (cons (apply string-append (reverse asm-line)) asm-output))
        (set! asm-line '()))
      (set! asm-line
            (cons (cond ((string? obj) obj)
                        ((char? obj) (if (eqv? obj char-tab) " " (string obj)))
                        ((number? obj) (number->string obj))
                        (else (compiler-internal-error "asm-display" obj)))
                  asm-line))))
(define (asm-output-get) (reverse asm-output))
(define *ofile-port1* '())
(define *ofile-port2* '())
(define *ofile-pos* '())
(define ofile-nl char-newline)
(define ofile-tab char-tab)
(define ofile-asm? '())
(set! ofile-asm? '())
(define ofile-asm-bits? '())
(set! ofile-asm-bits? #f)
(define ofile-asm-gvm? '())
(set! ofile-asm-gvm? #f)
(define ofile-stats? '())
(set! ofile-stats? '())
(define ofile-add-obj '())
(set! ofile-add-obj '())
(define ofile-syms '())
(set! ofile-syms '())
(define (ofile-word n)
  (let ((n (modulo n 65536)))
    (if (and ofile-asm? ofile-asm-bits?)
        (let ()
          (define (ofile-display x)
            (asm-display x *ofile-port2*)
            (cond ((eq? x ofile-nl) (set! *ofile-pos* 0))
                  ((eq? x ofile-tab)
                   (set! *ofile-pos* (* (quotient (+ *ofile-pos* 8) 8) 8)))
                  (else (set! *ofile-pos* (+ *ofile-pos* (string-length x))))))
          (if (> *ofile-pos* 64) (ofile-display ofile-nl))
          (if (= *ofile-pos* 0) (ofile-display " .word") (ofile-display ","))
          (ofile-display ofile-tab)
          (let ((s (make-string 6 #\0)))
            (string-set! s 1 #\x)
            (let loop ((i 5) (n n))
              (if (> n 0)
                  (begin
                    (string-set!
                     s
                     i
                     (string-ref "0123456789ABCDEF" (remainder n 16)))
                    (loop (- i 1) (quotient n 16)))))
            (ofile-display s))))
'    (write-word n *ofile-port1*)))
(define (ofile-long x) (ofile-word (upper-16bits x)) (ofile-word x))
(define (ofile-string s)
  (let ((len (string-length s)))
    (define (ref i) (if (>= i len) 0 (character-encoding (string-ref s i))))
    (let loop ((i 0))
      (if (< i len)
          (begin
            (ofile-word (+ (* (ref i) 256) (ref (+ i 1))))
            (loop (+ i 2)))))
    (if (= (remainder len 2) 0) (ofile-word 0))))
(define (ofile-wsym tag name)
  (let ((n (string-pos-in-list name (queue->list ofile-syms))))
    (if n
        (ofile-word (+ tag n))
        (let ((m (length (queue->list ofile-syms))))
          (queue-put! ofile-syms name)
          (ofile-word (+ tag word-index-mask))
          (ofile-string name)))))
(define (ofile-lsym tag name)
  (let ((n (string-pos-in-list name (queue->list ofile-syms))))
    (if n
        (ofile-long (+ tag (* n 8)))
        (let ((m (length (queue->list ofile-syms))))
          (queue-put! ofile-syms name)
          (ofile-long (+ tag (* long-index-mask 8)))
          (ofile-string name)))))
(define (ofile-ref obj)
  (let ((n (obj-encoding obj)))
    (if n
        (ofile-long n)
        (if (symbol-object? obj)
            (begin (ofile-lsym symbol-object-bits (symbol->string obj)))
            (let ((m (ofile-add-obj obj)))
              (if m
                  (ofile-long (+ local-object-bits (* m 8)))
                  (begin
                    (ofile-lsym
                     prim-proc-object-bits
                     (proc-obj-name obj)))))))))
(define (ofile-prim-proc s)
  (ofile-long prim-proc-prefix)
  (ofile-wsym 0 s)
  (ofile-comment (list "| #[primitive " s "] =")))
(define (ofile-user-proc) (ofile-long user-proc-prefix))
(define (ofile-line s)
  (if ofile-asm?
      (begin
        (if (> *ofile-pos* 0) (asm-newline *ofile-port2*))
        (asm-display s *ofile-port2*)
        (asm-newline *ofile-port2*)
        (set! *ofile-pos* 0))))
(define (ofile-tabs-to n)
  (let loop ()
    (if (< *ofile-pos* n)
        (begin
          (asm-display ofile-tab *ofile-port2*)
          (set! *ofile-pos* (* (quotient (+ *ofile-pos* 8) 8) 8))
          (loop)))))
(define (ofile-comment l)
  (if ofile-asm?
      (let ()
        (if ofile-asm-bits?
            (begin (ofile-tabs-to 32) (asm-display "|" *ofile-port2*)))
        (for-each (lambda (x) (asm-display x *ofile-port2*)) l)
        (asm-newline *ofile-port2*)
        (set! *ofile-pos* 0))))
(define (ofile-gvm-instr code)
  (if (and ofile-asm? ofile-asm-gvm?)
      (let ((gvm-instr (code-gvm-instr code)) (sn (code-slots-needed code)))
        (if (> *ofile-pos* 0)
            (begin (asm-newline *ofile-port2*) (set! *ofile-pos* 0)))
        (if ofile-asm-bits? (ofile-tabs-to 32))
        (asm-display "| GVM: [" *ofile-port2*)
        (asm-display sn *ofile-port2*)
        (asm-display "] " *ofile-port2*)
        (asm-newline *ofile-port2*)
        (set! *ofile-pos* 0))))
(define (ofile-stat stat)
  (define (obj->string x)
    (cond ((string? x) x)
          ((symbol-object? x) (symbol->string x))
          ((number? x) (number->string x))
          ((false-object? x) "#f")
          ((eq? x #t) "#t")
          ((null? x) "()")
          ((pair? x)
           (let loop ((l1 (cdr x)) (l2 (list (obj->string (car x)) "(")))
             (cond ((pair? l1)
                    (loop (cdr l1)
                          (cons (obj->string (car l1)) (cons " " l2))))
                   ((null? l1) (apply string-append (reverse (cons ")" l2))))
                   (else
                    (apply string-append
                           (reverse (cons ")"
                                          (cons (obj->string l1)
                                                (cons " . " l2)))))))))
          (else
           (compiler-internal-error
            "ofile-stat, can't convert to string 'x'"
            x))))
  (ofile-string (obj->string stat)))
(define (upper-16bits x)
  (cond ((>= x 0) (quotient x 65536))
        ((>= x (- 65536)) -1)
        (else (- (quotient (+ x 65537) 65536) 2))))
(define type-fixnum 0)
(define type-flonum 1)
(define type-special 7)
(define type-pair 4)
(define type-placeholder 5)
(define type-subtyped 3)
(define type-procedure 2)
(define subtype-vector 0)
(define subtype-symbol 1)
(define subtype-port 2)
(define subtype-ratnum 3)
(define subtype-cpxnum 4)
(define subtype-string 16)
(define subtype-bignum 17)
(define data-false (- 33686019))
(define data-null (- 67372037))
(define data-true -2)
(define data-undef -3)
(define data-unass -4)
(define data-unbound -5)
(define data-eof -6)
(define data-max-fixnum 268435455)
(define data-min-fixnum (- 268435456))
(define (make-encoding data type) (+ (* data 8) type))
(define (obj-type obj)
  (cond ((false-object? obj) 'special)
        ((undef-object? obj) 'special)
        ((symbol-object? obj) 'subtyped)
        ((proc-obj? obj) 'procedure)
        ((eq? obj #t) 'special)
        ((null? obj) 'special)
        ((pair? obj) 'pair)
        ((number? obj)
         (cond ((and (integer? obj)
                     (exact? obj)
                     (>= obj data-min-fixnum)
                     (<= obj data-max-fixnum))
                'fixnum)
               (
#t
;;                (and (inexact? (real-part obj))
;;                     (zero? (imag-part obj))
;;                     (exact? (imag-part obj)))
                'flonum)
               (else 'subtyped)))
        ((char? obj) 'special)
        (else 'subtyped)))
(define (obj-subtype obj)
  (cond ((symbol-object? obj) 'symbol)
        ((number? obj)
         (cond ((and (integer? obj) (exact? obj)) 'bignum)
               ((and (rational? obj) (exact? obj)) 'ratnum)
               (else 'cpxnum)))
        ((vector? obj) 'vector)
        ((string? obj) 'string)
        (else
         (compiler-internal-error "obj-subtype, unknown object 'obj'" obj))))
(define (obj-type-tag obj)
  (case (obj-type obj)
    ((fixnum) type-fixnum)
    ((flonum) type-flonum)
    ((special) type-special)
    ((pair) type-pair)
    ((subtyped) type-subtyped)
    ((procedure) type-procedure)
    (else (compiler-internal-error "obj-type-tag, unknown object 'obj'" obj))))
(define (obj-encoding obj)
  (case (obj-type obj)
    ((fixnum) (make-encoding obj type-fixnum))
    ((special)
     (make-encoding
      (cond ((false-object? obj) data-false)
            ((undef-object? obj) data-undef)
            ((eq? obj #t) data-true)
            ((null? obj) data-null)
            ((char? obj) (character-encoding obj))
            (else
             (compiler-internal-error
              "obj-encoding, unknown SPECIAL object 'obj'"
              obj)))
      type-special))
    (else #f)))
(define bits-false (make-encoding data-false type-special))
(define bits-null (make-encoding data-null type-special))
(define bits-true (make-encoding data-true type-special))
(define bits-unass (make-encoding data-unass type-special))
(define bits-unbound (make-encoding data-unbound type-special))
(define (asm.begin!)
  (set! asm-code-queue (queue-empty))
  (set! asm-const-queue (queue-empty))
  '())
(define (asm.end! debug-info)
  (asm-assemble! debug-info)
  (set! asm-code-queue '())
  (set! asm-const-queue '())
  '())
(define asm-code-queue '())
(define asm-const-queue '())
(define (asm-word x) (queue-put! asm-code-queue (modulo x 65536)))
(define (asm-long x) (asm-word (upper-16bits x)) (asm-word x))
(define (asm-label lbl label-descr)
  (queue-put! asm-code-queue (cons 'label (cons lbl label-descr))))
(define (asm-comment x) (queue-put! asm-code-queue (cons 'comment x)))
(define (asm-align n offset)
  (queue-put! asm-code-queue (cons 'align (cons n offset))))
(define (asm-ref-glob glob)
  (queue-put!
   asm-code-queue
   (cons 'ref-glob (symbol->string (glob-name glob)))))
(define (asm-set-glob glob)
  (queue-put!
   asm-code-queue
   (cons 'set-glob (symbol->string (glob-name glob)))))
(define (asm-ref-glob-jump glob)
  (queue-put!
   asm-code-queue
   (cons 'ref-glob-jump (symbol->string (glob-name glob)))))
(define (asm-proc-ref num offset)
  (queue-put! asm-code-queue (cons 'proc-ref (cons num offset))))
(define (asm-prim-ref proc offset)
  (queue-put!
   asm-code-queue
   (cons 'prim-ref (cons (proc-obj-name proc) offset))))
(define (asm-m68020-proc) (queue-put! asm-code-queue '(m68020-proc)))
(define (asm-m68881-proc) (queue-put! asm-code-queue '(m68881-proc)))
(define (asm-stat x) (queue-put! asm-code-queue (cons 'stat x)))
(define (asm-brel type lbl)
  (queue-put! asm-code-queue (cons 'brab (cons type lbl))))
(define (asm-wrel lbl offs)
  (queue-put! asm-code-queue (cons 'wrel (cons lbl offs))))
(define (asm-lrel lbl offs n)
  (queue-put! asm-code-queue (cons 'lrel (cons lbl (cons offs n)))))
(define (asm-assemble! debug-info)
  (define header-offset 2)
  (define ref-glob-len 2)
  (define set-glob-len 10)
  (define ref-glob-jump-len 2)
  (define proc-ref-len 4)
  (define prim-ref-len 4)
  (define stat-len 4)
  (define (padding loc n offset) (modulo (- offset loc) n))
  (queue-put! asm-const-queue debug-info)
  (asm-align 4 0)
  (emit-label const-lbl)
  (let ((code-list (queue->list asm-code-queue))
        (const-list (queue->list asm-const-queue)))
    (let* ((fix-list
            (let loop ((l code-list) (len header-offset) (x '()))
              (if (null? l)
                  (reverse x)
                  (let ((part (car l)) (rest (cdr l)))
                    (if (pair? part)
                        (case (car part)
                          ((label align brab)
                           (loop rest 0 (cons (cons len part) x)))
                          ((wrel) (loop rest (+ len 2) x))
                          ((lrel) (loop rest (+ len 4) x))
                          ((ref-glob) (loop rest (+ len ref-glob-len) x))
                          ((set-glob) (loop rest (+ len set-glob-len) x))
                          ((ref-glob-jump)
                           (loop rest (+ len ref-glob-jump-len) x))
                          ((proc-ref) (loop rest (+ len proc-ref-len) x))
                          ((prim-ref) (loop rest (+ len prim-ref-len) x))
                          ((stat) (loop rest (+ len stat-len) x))
                          ((comment m68020-proc m68881-proc) (loop rest len x))
                          (else
                           (compiler-internal-error
                            "asm-assemble!, unknown code list element"
                            part)))
                        (loop rest (+ len 2) x))))))
           (lbl-list
            (let loop ((l fix-list) (x '()))
              (if (null? l)
                  x
                  (let ((part (cdar l)) (rest (cdr l)))
                    (if (eq? (car part) 'label)
                        (loop rest (cons (cons (cadr part) part) x))
                        (loop rest x)))))))
      (define (replace-lbl-refs-by-pointer-to-label)
        (let loop ((l code-list))
          (if (not (null? l))
              (let ((part (car l)) (rest (cdr l)))
                (if (pair? part)
                    (case (car part)
                      ((brab)
                       (set-cdr! (cdr part) (cdr (assq (cddr part) lbl-list))))
                      ((wrel)
                       (set-car! (cdr part) (cdr (assq (cadr part) lbl-list))))
                      ((lrel)
                       (set-car!
                        (cdr part)
                        (cdr (assq (cadr part) lbl-list))))))
                (loop rest)))))
      (define (assign-loc-to-labels)
        (let loop ((l fix-list) (loc 0))
          (if (not (null? l))
              (let* ((first (car l))
                     (rest (cdr l))
                     (len (car first))
                     (cur-loc (+ loc len))
                     (part (cdr first)))
                (case (car part)
                  ((label)
                   (if (cddr part)
                       (vector-set!
                        (cddr part)
                        0
                        (quotient (- cur-loc header-offset) 8)))
                   (set-car! (cdr part) cur-loc)
                   (loop rest cur-loc))
                  ((align)
                   (loop rest
                         (+ cur-loc
                            (padding cur-loc (cadr part) (cddr part)))))
                  ((brab) (loop rest (+ cur-loc 2)))
                  ((braw) (loop rest (+ cur-loc 4)))
                  (else
                   (compiler-internal-error
                    "assign-loc-to-labels, unknown code list element"
                    part)))))))
      (define (branch-tensioning-pass)
        (assign-loc-to-labels)
        (let loop ((changed? #f) (l fix-list) (loc 0))
          (if (null? l)
              (if changed? (branch-tensioning-pass))
              (let* ((first (car l))
                     (rest (cdr l))
                     (len (car first))
                     (cur-loc (+ loc len))
                     (part (cdr first)))
                (case (car part)
                  ((label) (loop changed? rest cur-loc))
                  ((align)
                   (loop changed?
                         rest
                         (+ cur-loc
                            (padding cur-loc (cadr part) (cddr part)))))
                  ((brab)
                   (let ((dist (- (cadr (cddr part)) (+ cur-loc 2))))
                     (if (or (< dist -128) (> dist 127) (= dist 0))
                         (begin
                           (set-car! part 'braw)
                           (loop #t rest (+ cur-loc 2)))
                         (loop changed? rest (+ cur-loc 2)))))
                  ((braw) (loop changed? rest (+ cur-loc 4)))
                  (else
                   (compiler-internal-error
                    "branch-tensioning-pass, unknown code list element"
                    part)))))))
      (define (write-block start-loc end-loc start end)
        (if (> end-loc start-loc)
            (ofile-word (quotient (- end-loc start-loc) 2)))
        (let loop ((loc start-loc) (l start))
          (if (not (eq? l end))
              (let ((part (car l)) (rest (cdr l)))
                (if (pair? part)
                    (case (car part)
                      ((label) (loop loc rest))
                      ((align)
                       (let ((n (padding loc (cadr part) (cddr part))))
                         (let pad ((i 0))
                           (if (< i n)
                               (begin (ofile-word 0) (pad (+ i 2)))
                               (loop (+ loc n) rest)))))
                      ((brab)
                       (let ((dist (- (cadr (cddr part)) (+ loc 2))))
                         (ofile-word (+ (cadr part) (modulo dist 256)))
                         (loop (+ loc 2) rest)))
                      ((braw)
                       (let ((dist (- (cadr (cddr part)) (+ loc 2))))
                         (ofile-word (cadr part))
                         (ofile-word (modulo dist 65536))
                         (loop (+ loc 4) rest)))
                      ((wrel)
                       (let ((dist (+ (- (cadr (cadr part)) loc) (cddr part))))
                         (ofile-word (modulo dist 65536))
                         (loop (+ loc 2) rest)))
                      ((lrel)
                       (let ((dist (+ (- (cadr (cadr part)) loc)
                                      (caddr part))))
                         (ofile-long (+ (* dist 65536) (cdddr part)))
                         (loop (+ loc 4) rest)))
                      ((comment)
                       (let ((x (cdr part)))
                         (if (pair? x) (ofile-comment x) (ofile-gvm-instr x))
                         (loop loc rest))))
                    (begin (ofile-word part) (loop (+ loc 2) rest)))))))
      (define (write-code)
        (let ((proc-len
               (+ (cadr (cdr (assq const-lbl lbl-list)))
                  (* (length const-list) 4))))
          (if (>= proc-len 32768)
              (compiler-limitation-error
               "procedure is too big (32K bytes limit per procedure)"))
          (ofile-word (+ 32768 proc-len)))
        (let loop1 ((start code-list) (start-loc header-offset))
          (let loop2 ((end start) (loc start-loc))
            (if (null? end)
                (write-block start-loc loc start end)
                (let ((part (car end)) (rest (cdr end)))
                  (if (pair? part)
                      (case (car part)
                        ((label comment) (loop2 rest loc))
                        ((align)
                         (loop2 rest
                                (+ loc (padding loc (cadr part) (cddr part)))))
                        ((brab wrel) (loop2 rest (+ loc 2)))
                        ((braw) (loop2 rest (+ loc 4)))
                        ((lrel) (loop2 rest (+ loc 4)))
                        (else
                         (write-block start-loc loc start end)
                         (case (car part)
                           ((ref-glob)
                            (ofile-wsym global-var-ref-tag (cdr part))
                            (loop1 rest (+ loc ref-glob-len)))
                           ((set-glob)
                            (ofile-wsym global-var-set-tag (cdr part))
                            (loop1 rest (+ loc set-glob-len)))
                           ((ref-glob-jump)
                            (ofile-wsym global-var-ref-jump-tag (cdr part))
                            (loop1 rest (+ loc ref-glob-jump-len)))
                           ((proc-ref)
                            (ofile-word (+ local-proc-ref-tag (cadr part)))
                            (ofile-word (cddr part))
                            (loop1 rest (+ loc proc-ref-len)))
                           ((prim-ref)
                            (ofile-wsym prim-proc-ref-tag (cadr part))
                            (ofile-word (cddr part))
                            (loop1 rest (+ loc prim-ref-len)))
                           ((m68020-proc)
                            (ofile-word m68020-proc-code-tag)
                            (loop1 rest loc))
                           ((m68881-proc)
                            (ofile-word m68881-proc-code-tag)
                            (loop1 rest loc))
                           ((stat)
                            (ofile-word stat-tag)
                            (ofile-stat (cdr part))
                            (loop1 rest (+ loc stat-len))))))
                      (loop2 rest (+ loc 2)))))))
        (ofile-word end-of-code-tag)
        (for-each ofile-ref const-list)
        (ofile-long (obj-encoding (+ (length const-list) 1))))
      (replace-lbl-refs-by-pointer-to-label)
      (branch-tensioning-pass)
      (write-code))))
(define const-lbl 0)
(define (identical-opnd68? opnd1 opnd2) (eqv? opnd1 opnd2))
(define (reg68? x) (or (dreg? x) (areg? x)))
(define (make-dreg num) num)
(define (dreg? x) (and (integer? x) (>= x 0) (< x 8)))
(define (dreg-num x) x)
(define (make-areg num) (+ num 8))
(define (areg? x) (and (integer? x) (>= x 8) (< x 16)))
(define (areg-num x) (- x 8))
(define (make-ind areg) (+ areg 8))
(define (ind? x) (and (integer? x) (>= x 16) (< x 24)))
(define (ind-areg x) (- x 8))
(define (make-pinc areg) (+ areg 16))
(define (pinc? x) (and (integer? x) (>= x 24) (< x 32)))
(define (pinc-areg x) (- x 16))
(define (make-pdec areg) (+ areg 24))
(define (pdec? x) (and (integer? x) (>= x 32) (< x 40)))
(define (pdec-areg x) (- x 24))
(define (make-disp areg offset) (+ (+ areg 32) (* (modulo offset 65536) 8)))
(define (disp? x) (and (integer? x) (>= x 40) (< x 524328)))
(define (disp-areg x) (+ (remainder x 8) 8))
(define (disp-offset x)
  (- (modulo (+ (quotient (- x 40) 8) 32768) 65536) 32768))
(define (make-disp* areg offset)
  (if (= offset 0) (make-ind areg) (make-disp areg offset)))
(define (disp*? x) (or (ind? x) (disp? x)))
(define (disp*-areg x) (if (ind? x) (ind-areg x) (disp-areg x)))
(define (disp*-offset x) (if (ind? x) 0 (disp-offset x)))
(define (make-inx areg ireg offset)
  (+ (+ areg 524320) (* ireg 8) (* (modulo offset 256) 128)))
(define (inx? x) (and (integer? x) (>= x 524328) (< x 557096)))
(define (inx-areg x) (+ (remainder (- x 524328) 8) 8))
(define (inx-ireg x) (quotient (remainder (- x 524328) 128) 8))
(define (inx-offset x)
  (- (modulo (+ (quotient (- x 524328) 128) 128) 256) 128))
(define (make-freg num) (+ 557096 num))
(define (freg? x) (and (integer? x) (>= x 557096) (< x 557104)))
(define (freg-num x) (- x 557096))
(define (make-pcr lbl offset)
  (+ 557104 (+ (modulo offset 65536) (* lbl 65536))))
(define (pcr? x) (and (integer? x) (>= x 557104)))
(define (pcr-lbl x) (quotient (- x 557104) 65536))
(define (pcr-offset x) (- (modulo (- x 524336) 65536) 32768))
(define (make-imm val) (if (< val 0) (* val 2) (- -1 (* val 2))))
(define (imm? x) (and (integer? x) (< x 0)))
(define (imm-val x) (if (even? x) (quotient x 2) (- (quotient x 2))))
(define (make-glob name) name)
(define (glob? x) (symbol? x))
(define (glob-name x) x)
(define (make-frame-base-rel slot) (make-disp sp-reg slot))
(define (frame-base-rel? x)
  (and (disp? x) (identical-opnd68? sp-reg (disp-areg x))))
(define (frame-base-rel-slot x) (disp-offset x))
(define (make-reg-list regs) regs)
(define (reg-list? x) (or (pair? x) (null? x)))
(define (reg-list-regs x) x)
(define first-dtemp 0)
(define gvm-reg1 1)
(define poll-timer-reg (make-dreg 5))
(define null-reg (make-dreg 6))
(define placeholder-reg (make-dreg 6))
(define false-reg (make-dreg 7))
(define pair-reg (make-dreg 7))
(define gvm-reg0 0)
(define first-atemp 1)
(define heap-reg (make-areg 3))
(define ltq-tail-reg (make-areg 4))
(define pstate-reg (make-areg 5))
(define table-reg (make-areg 6))
(define sp-reg (make-areg 7))
(define pdec-sp (make-pdec sp-reg))
(define pinc-sp (make-pinc sp-reg))
(define dtemp1 (make-dreg first-dtemp))
(define atemp1 (make-areg first-atemp))
(define atemp2 (make-areg (+ first-atemp 1)))
(define ftemp1 (make-freg 0))
(define arg-count-reg dtemp1)
(define (trap-offset n) (+ 32768 (* (- n 32) 8)))
(define (emit-move.l opnd1 opnd2)
  (let ((src (opnd->mode/reg opnd1)) (dst (opnd->reg/mode opnd2)))
    (asm-word (+ 8192 (+ dst src)))
    (opnd-ext-rd-long opnd1)
    (opnd-ext-wr-long opnd2)
    (if ofile-asm?
        (emit-asm "movl" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2)))))
(define (emit-move.w opnd1 opnd2)
  (let ((src (opnd->mode/reg opnd1)) (dst (opnd->reg/mode opnd2)))
    (asm-word (+ 12288 (+ dst src)))
    (opnd-ext-rd-word opnd1)
    (opnd-ext-wr-word opnd2)
    (if ofile-asm?
        (emit-asm "movw" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2)))))
(define (emit-move.b opnd1 opnd2)
  (let ((src (opnd->mode/reg opnd1)) (dst (opnd->reg/mode opnd2)))
    (asm-word (+ 4096 (+ dst src)))
    (opnd-ext-rd-word opnd1)
    (opnd-ext-wr-word opnd2)
    (if ofile-asm?
        (emit-asm "movb" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2)))))
(define (emit-moveq n opnd)
  (asm-word (+ 28672 (+ (* (dreg-num opnd) 512) (modulo n 256))))
  (if ofile-asm? (emit-asm "moveq" ofile-tab "#" n "," (opnd-str opnd))))
(define (emit-movem.l opnd1 opnd2)
  (define (reg-mask reg-list flip-bits?)
    (let loop ((i 15) (bit 32768) (mask 0))
      (if (>= i 0)
          (loop (- i 1)
                (quotient bit 2)
                (if (memq i reg-list)
                    (+ mask (if flip-bits? (quotient 32768 bit) bit))
                    mask))
          mask)))
  (define (movem op reg-list opnd)
    (asm-word (+ op (opnd->mode/reg opnd)))
    (asm-word (reg-mask reg-list (pdec? opnd))))
  (if (reg-list? opnd1)
      (begin (movem 18624 opnd1 opnd2) (opnd-ext-wr-long opnd2))
      (begin (movem 19648 opnd2 opnd1) (opnd-ext-rd-long opnd1)))
  (if ofile-asm?
      (emit-asm "moveml" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-exg opnd1 opnd2)
  (define (exg r1 r2)
    (let ((mode (if (dreg? r2) 49472 (if (dreg? r1) 49544 49480)))
          (num1 (if (dreg? r1) (dreg-num r1) (areg-num r1)))
          (num2 (if (dreg? r2) (dreg-num r2) (areg-num r2))))
      (asm-word (+ mode (+ (* num1 512) num2)))))
  (if (dreg? opnd2) (exg opnd2 opnd1) (exg opnd1 opnd2))
  (if ofile-asm?
      (emit-asm "exg" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-eor.l opnd1 opnd2)
  (cond ((imm? opnd1)
         (asm-word (+ 2688 (opnd->mode/reg opnd2)))
         (opnd-ext-rd-long opnd1)
         (opnd-ext-wr-long opnd2))
        (else
         (asm-word
          (+ 45440 (+ (* (dreg-num opnd1) 512) (opnd->mode/reg opnd2))))
         (opnd-ext-wr-long opnd2)))
  (if ofile-asm?
      (emit-asm "eorl" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-and.l opnd1 opnd2)
  (cond ((imm? opnd1)
         (asm-word (+ 640 (opnd->mode/reg opnd2)))
         (opnd-ext-rd-long opnd1)
         (opnd-ext-wr-long opnd2))
        (else
         (let ((mode (if (dreg? opnd2) 49280 49536))
               (reg (if (dreg? opnd2) (dreg-num opnd2) (dreg-num opnd1)))
               (other (if (dreg? opnd2) opnd1 opnd2)))
           (asm-word (+ mode (+ (* reg 512) (opnd->mode/reg other))))
           (if (dreg? opnd2)
               (opnd-ext-rd-long other)
               (opnd-ext-wr-long other)))))
  (if ofile-asm?
      (emit-asm "andl" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-and.w opnd1 opnd2)
  (cond ((imm? opnd1)
         (asm-word (+ 576 (opnd->mode/reg opnd2)))
         (opnd-ext-rd-word opnd1)
         (opnd-ext-wr-word opnd2))
        (else
         (let ((mode (if (dreg? opnd2) 49216 49472))
               (reg (if (dreg? opnd2) (dreg-num opnd2) (dreg-num opnd1)))
               (other (if (dreg? opnd2) opnd1 opnd2)))
           (asm-word (+ mode (+ (* reg 512) (opnd->mode/reg other))))
           (if (dreg? opnd2)
               (opnd-ext-rd-word other)
               (opnd-ext-wr-word other)))))
  (if ofile-asm?
      (emit-asm "andw" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-or.l opnd1 opnd2)
  (cond ((imm? opnd1)
         (asm-word (+ 128 (opnd->mode/reg opnd2)))
         (opnd-ext-rd-long opnd1)
         (opnd-ext-wr-long opnd2))
        (else
         (let ((mode (if (dreg? opnd2) 32896 33152))
               (reg (if (dreg? opnd2) (dreg-num opnd2) (dreg-num opnd1)))
               (other (if (dreg? opnd2) opnd1 opnd2)))
           (asm-word (+ mode (+ (* reg 512) (opnd->mode/reg other))))
           (if (dreg? opnd2)
               (opnd-ext-rd-long other)
               (opnd-ext-wr-long other)))))
  (if ofile-asm?
      (emit-asm "orl" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-addq.l n opnd)
  (let ((m (if (= n 8) 0 n)))
    (asm-word (+ 20608 (* m 512) (opnd->mode/reg opnd)))
    (opnd-ext-wr-long opnd)
    (if ofile-asm? (emit-asm "addql" ofile-tab "#" n "," (opnd-str opnd)))))
(define (emit-addq.w n opnd)
  (let ((m (if (= n 8) 0 n)))
    (asm-word (+ 20544 (* m 512) (opnd->mode/reg opnd)))
    (opnd-ext-wr-word opnd)
    (if ofile-asm? (emit-asm "addqw" ofile-tab "#" n "," (opnd-str opnd)))))
(define (emit-add.l opnd1 opnd2)
  (cond ((areg? opnd2)
         (asm-word
          (+ 53696 (+ (* (areg-num opnd2) 512) (opnd->mode/reg opnd1))))
         (opnd-ext-rd-long opnd1))
        ((imm? opnd1)
         (asm-word (+ 1664 (opnd->mode/reg opnd2)))
         (opnd-ext-rd-long opnd1)
         (opnd-ext-wr-long opnd2))
        (else
         (let ((mode (if (dreg? opnd2) 53376 53632))
               (reg (if (dreg? opnd2) (dreg-num opnd2) (dreg-num opnd1)))
               (other (if (dreg? opnd2) opnd1 opnd2)))
           (asm-word (+ mode (+ (* reg 512) (opnd->mode/reg other))))
           (if (dreg? opnd2)
               (opnd-ext-rd-long other)
               (opnd-ext-wr-long other)))))
  (if ofile-asm?
      (emit-asm "addl" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-add.w opnd1 opnd2)
  (cond ((areg? opnd2)
         (asm-word
          (+ 53440 (+ (* (areg-num opnd2) 512) (opnd->mode/reg opnd1))))
         (opnd-ext-rd-word opnd1))
        ((imm? opnd1)
         (asm-word (+ 1600 (opnd->mode/reg opnd2)))
         (opnd-ext-rd-word opnd1)
         (opnd-ext-wr-word opnd2))
        (else
         (let ((mode (if (dreg? opnd2) 53312 53568))
               (reg (if (dreg? opnd2) (dreg-num opnd2) (dreg-num opnd1)))
               (other (if (dreg? opnd2) opnd1 opnd2)))
           (asm-word (+ mode (+ (* reg 512) (opnd->mode/reg other))))
           (if (dreg? opnd2)
               (opnd-ext-rd-word other)
               (opnd-ext-wr-word other)))))
  (if ofile-asm?
      (emit-asm "addw" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-addx.w opnd1 opnd2)
  (if (dreg? opnd1)
      (asm-word (+ 53568 (+ (* (dreg-num opnd2) 512) (dreg-num opnd1))))
      (asm-word
       (+ 53576
          (+ (* (areg-num (pdec-areg opnd2)) 512)
             (areg-num (pdec-areg opnd1))))))
  (if ofile-asm?
      (emit-asm "addxw" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-subq.l n opnd)
  (let ((m (if (= n 8) 0 n)))
    (asm-word (+ 20864 (* m 512) (opnd->mode/reg opnd)))
    (opnd-ext-wr-long opnd)
    (if ofile-asm? (emit-asm "subql" ofile-tab "#" n "," (opnd-str opnd)))))
(define (emit-subq.w n opnd)
  (let ((m (if (= n 8) 0 n)))
    (asm-word (+ 20800 (* m 512) (opnd->mode/reg opnd)))
    (opnd-ext-wr-word opnd)
    (if ofile-asm? (emit-asm "subqw" ofile-tab "#" n "," (opnd-str opnd)))))
(define (emit-sub.l opnd1 opnd2)
  (cond ((areg? opnd2)
         (asm-word
          (+ 37312 (+ (* (areg-num opnd2) 512) (opnd->mode/reg opnd1))))
         (opnd-ext-rd-long opnd1))
        ((imm? opnd1)
         (asm-word (+ 1152 (opnd->mode/reg opnd2)))
         (opnd-ext-rd-long opnd1)
         (opnd-ext-wr-long opnd2))
        (else
         (let ((mode (if (dreg? opnd2) 36992 37248))
               (reg (if (dreg? opnd2) (dreg-num opnd2) (dreg-num opnd1)))
               (other (if (dreg? opnd2) opnd1 opnd2)))
           (asm-word (+ mode (+ (* reg 512) (opnd->mode/reg other))))
           (if (dreg? opnd2)
               (opnd-ext-rd-long other)
               (opnd-ext-wr-long other)))))
  (if ofile-asm?
      (emit-asm "subl" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-sub.w opnd1 opnd2)
  (cond ((areg? opnd2)
         (asm-word
          (+ 37056 (+ (* (areg-num opnd2) 512) (opnd->mode/reg opnd1))))
         (opnd-ext-rd-word opnd1))
        ((imm? opnd1)
         (asm-word (+ 1088 (opnd->mode/reg opnd2)))
         (opnd-ext-rd-word opnd1)
         (opnd-ext-wr-word opnd2))
        (else
         (let ((mode (if (dreg? opnd2) 36928 37184))
               (reg (if (dreg? opnd2) (dreg-num opnd2) (dreg-num opnd1)))
               (other (if (dreg? opnd2) opnd1 opnd2)))
           (asm-word (+ mode (+ (* reg 512) (opnd->mode/reg other))))
           (if (dreg? opnd2)
               (opnd-ext-rd-word other)
               (opnd-ext-wr-word other)))))
  (if ofile-asm?
      (emit-asm "subw" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-asl.l opnd1 opnd2)
  (if (dreg? opnd1)
      (asm-word (+ 57760 (+ (* (dreg-num opnd1) 512) (dreg-num opnd2))))
      (let ((n (imm-val opnd1)))
        (asm-word (+ 57728 (+ (* (if (= n 8) 0 n) 512) (dreg-num opnd2))))))
  (if ofile-asm?
      (emit-asm "asll" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-asl.w opnd1 opnd2)
  (if (dreg? opnd1)
      (asm-word (+ 57696 (+ (* (dreg-num opnd1) 512) (dreg-num opnd2))))
      (let ((n (imm-val opnd1)))
        (asm-word (+ 57664 (+ (* (if (= n 8) 0 n) 512) (dreg-num opnd2))))))
  (if ofile-asm?
      (emit-asm "aslw" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-asr.l opnd1 opnd2)
  (if (dreg? opnd1)
      (asm-word (+ 57504 (+ (* (dreg-num opnd1) 512) (dreg-num opnd2))))
      (let ((n (imm-val opnd1)))
        (asm-word (+ 57472 (+ (* (if (= n 8) 0 n) 512) (dreg-num opnd2))))))
  (if ofile-asm?
      (emit-asm "asrl" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-asr.w opnd1 opnd2)
  (if (dreg? opnd1)
      (asm-word (+ 57440 (+ (* (dreg-num opnd1) 512) (dreg-num opnd2))))
      (let ((n (imm-val opnd1)))
        (asm-word (+ 57408 (+ (* (if (= n 8) 0 n) 512) (dreg-num opnd2))))))
  (if ofile-asm?
      (emit-asm "asrw" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-lsl.l opnd1 opnd2)
  (if (dreg? opnd1)
      (asm-word (+ 57768 (+ (* (dreg-num opnd1) 512) (dreg-num opnd2))))
      (let ((n (imm-val opnd1)))
        (asm-word (+ 57736 (+ (* (if (= n 8) 0 n) 512) (dreg-num opnd2))))))
  (if ofile-asm?
      (emit-asm "lsll" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-lsr.l opnd1 opnd2)
  (if (dreg? opnd1)
      (asm-word (+ 57512 (+ (* (dreg-num opnd1) 512) (dreg-num opnd2))))
      (let ((n (imm-val opnd1)))
        (asm-word (+ 57480 (+ (* (if (= n 8) 0 n) 512) (dreg-num opnd2))))))
  (if ofile-asm?
      (emit-asm "lsrl" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-lsr.w opnd1 opnd2)
  (if (dreg? opnd1)
      (asm-word (+ 57448 (+ (* (dreg-num opnd1) 512) (dreg-num opnd2))))
      (let ((n (imm-val opnd1)))
        (asm-word (+ 57416 (+ (* (if (= n 8) 0 n) 512) (dreg-num opnd2))))))
  (if ofile-asm?
      (emit-asm "lsrw" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-clr.l opnd)
  (asm-word (+ 17024 (opnd->mode/reg opnd)))
  (opnd-ext-wr-long opnd)
  (if ofile-asm? (emit-asm "clrl" ofile-tab (opnd-str opnd))))
(define (emit-neg.l opnd)
  (asm-word (+ 17536 (opnd->mode/reg opnd)))
  (opnd-ext-wr-long opnd)
  (if ofile-asm? (emit-asm "negl" ofile-tab (opnd-str opnd))))
(define (emit-not.l opnd)
  (asm-word (+ 18048 (opnd->mode/reg opnd)))
  (opnd-ext-wr-long opnd)
  (if ofile-asm? (emit-asm "notl" ofile-tab (opnd-str opnd))))
(define (emit-ext.l opnd)
  (asm-word (+ 18624 (dreg-num opnd)))
  (if ofile-asm? (emit-asm "extl" ofile-tab (opnd-str opnd))))
(define (emit-ext.w opnd)
  (asm-word (+ 18560 (dreg-num opnd)))
  (if ofile-asm? (emit-asm "extw" ofile-tab (opnd-str opnd))))
(define (emit-swap opnd)
  (asm-word (+ 18496 (dreg-num opnd)))
  (if ofile-asm? (emit-asm "swap" ofile-tab (opnd-str opnd))))
(define (emit-cmp.l opnd1 opnd2)
  (cond ((areg? opnd2)
         (asm-word
          (+ 45504 (+ (* (areg-num opnd2) 512) (opnd->mode/reg opnd1))))
         (opnd-ext-rd-long opnd1))
        ((imm? opnd1)
         (asm-word (+ 3200 (opnd->mode/reg opnd2)))
         (opnd-ext-rd-long opnd1)
         (opnd-ext-rd-long opnd2))
        (else
         (asm-word
          (+ 45184 (+ (* (dreg-num opnd2) 512) (opnd->mode/reg opnd1))))
         (opnd-ext-rd-long opnd1)))
  (if ofile-asm?
      (emit-asm "cmpl" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-cmp.w opnd1 opnd2)
  (cond ((areg? opnd2)
         (asm-word
          (+ 45248 (+ (* (areg-num opnd2) 512) (opnd->mode/reg opnd1))))
         (opnd-ext-rd-word opnd1))
        ((imm? opnd1)
         (asm-word (+ 3136 (opnd->mode/reg opnd2)))
         (opnd-ext-rd-word opnd1)
         (opnd-ext-rd-word opnd2))
        (else
         (asm-word
          (+ 45120 (+ (* (dreg-num opnd2) 512) (opnd->mode/reg opnd1))))
         (opnd-ext-rd-word opnd1)))
  (if ofile-asm?
      (emit-asm "cmpw" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-cmp.b opnd1 opnd2)
  (cond ((imm? opnd1)
         (asm-word (+ 3072 (opnd->mode/reg opnd2)))
         (opnd-ext-rd-word opnd1)
         (opnd-ext-rd-word opnd2))
        (else
         (asm-word
          (+ 45056 (+ (* (dreg-num opnd2) 512) (opnd->mode/reg opnd1))))
         (opnd-ext-rd-word opnd1)))
  (if ofile-asm?
      (emit-asm "cmpb" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-tst.l opnd)
  (asm-word (+ 19072 (opnd->mode/reg opnd)))
  (opnd-ext-rd-long opnd)
  (if ofile-asm? (emit-asm "tstl" ofile-tab (opnd-str opnd))))
(define (emit-tst.w opnd)
  (asm-word (+ 19008 (opnd->mode/reg opnd)))
  (opnd-ext-rd-word opnd)
  (if ofile-asm? (emit-asm "tstw" ofile-tab (opnd-str opnd))))
(define (emit-lea opnd areg)
  (asm-word (+ 16832 (+ (* (areg-num areg) 512) (opnd->mode/reg opnd))))
  (opnd-ext-rd-long opnd)
  (if ofile-asm?
      (emit-asm "lea" ofile-tab (opnd-str opnd) "," (opnd-str areg))))
(define (emit-unlk areg)
  (asm-word (+ 20056 (areg-num areg)))
  (if ofile-asm? (emit-asm "unlk" ofile-tab (opnd-str areg))))
(define (emit-move-proc num opnd)
  (let ((dst (opnd->reg/mode opnd)))
    (asm-word (+ 8192 (+ dst 60)))
    (asm-proc-ref num 0)
    (opnd-ext-wr-long opnd)
    (if ofile-asm? (emit-asm "MOVE_PROC(" num "," (opnd-str opnd) ")"))))
(define (emit-move-prim val opnd)
  (let ((dst (opnd->reg/mode opnd)))
    (asm-word (+ 8192 (+ dst 60)))
    (asm-prim-ref val 0)
    (opnd-ext-wr-long opnd)
    (if ofile-asm?
        (emit-asm "MOVE_PRIM(" (proc-obj-name val) "," (opnd-str opnd) ")"))))
(define (emit-pea opnd)
  (asm-word (+ 18496 (opnd->mode/reg opnd)))
  (opnd-ext-rd-long opnd)
  (if ofile-asm? (emit-asm "pea" ofile-tab (opnd-str opnd))))
(define (emit-pea* n)
  (asm-word 18552)
  (asm-word n)
  (if ofile-asm? (emit-asm "pea" ofile-tab n)))
(define (emit-btst opnd1 opnd2)
  (asm-word (+ 256 (+ (* (dreg-num opnd1) 512) (opnd->mode/reg opnd2))))
  (opnd-ext-rd-word opnd2)
  (if ofile-asm?
      (emit-asm "btst" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-bra lbl)
  (asm-brel 24576 lbl)
  (if ofile-asm? (emit-asm "bra" ofile-tab "L" lbl)))
(define (emit-bcc lbl)
  (asm-brel 25600 lbl)
  (if ofile-asm? (emit-asm "bcc" ofile-tab "L" lbl)))
(define (emit-bcs lbl)
  (asm-brel 25856 lbl)
  (if ofile-asm? (emit-asm "bcs" ofile-tab "L" lbl)))
(define (emit-bhi lbl)
  (asm-brel 25088 lbl)
  (if ofile-asm? (emit-asm "bhi" ofile-tab "L" lbl)))
(define (emit-bls lbl)
  (asm-brel 25344 lbl)
  (if ofile-asm? (emit-asm "bls" ofile-tab "L" lbl)))
(define (emit-bmi lbl)
  (asm-brel 27392 lbl)
  (if ofile-asm? (emit-asm "bmi" ofile-tab "L" lbl)))
(define (emit-bpl lbl)
  (asm-brel 27136 lbl)
  (if ofile-asm? (emit-asm "bpl" ofile-tab "L" lbl)))
(define (emit-beq lbl)
  (asm-brel 26368 lbl)
  (if ofile-asm? (emit-asm "beq" ofile-tab "L" lbl)))
(define (emit-bne lbl)
  (asm-brel 26112 lbl)
  (if ofile-asm? (emit-asm "bne" ofile-tab "L" lbl)))
(define (emit-blt lbl)
  (asm-brel 27904 lbl)
  (if ofile-asm? (emit-asm "blt" ofile-tab "L" lbl)))
(define (emit-bgt lbl)
  (asm-brel 28160 lbl)
  (if ofile-asm? (emit-asm "bgt" ofile-tab "L" lbl)))
(define (emit-ble lbl)
  (asm-brel 28416 lbl)
  (if ofile-asm? (emit-asm "ble" ofile-tab "L" lbl)))
(define (emit-bge lbl)
  (asm-brel 27648 lbl)
  (if ofile-asm? (emit-asm "bge" ofile-tab "L" lbl)))
(define (emit-dbra dreg lbl)
  (asm-word (+ 20936 dreg))
  (asm-wrel lbl 0)
  (if ofile-asm? (emit-asm "dbra" ofile-tab (opnd-str dreg) ",L" lbl)))
(define (emit-trap num)
  (asm-word (+ 20032 num))
  (if ofile-asm? (emit-asm "trap" ofile-tab "#" num)))
(define (emit-trap1 num args)
  (asm-word (+ 20136 (areg-num table-reg)))
  (asm-word (trap-offset num))
  (let loop ((args args))
    (if (not (null? args)) (begin (asm-word (car args)) (loop (cdr args)))))
  (if ofile-asm?
      (let ()
        (define (words l)
          (if (null? l) (list ")") (cons "," (cons (car l) (words (cdr l))))))
        (apply emit-asm (cons "TRAP1(" (cons num (words args)))))))
(define (emit-trap2 num args)
  (asm-word (+ 20136 (areg-num table-reg)))
  (asm-word (trap-offset num))
  (asm-align 8 (modulo (- 4 (* (length args) 2)) 8))
  (let loop ((args args))
    (if (not (null? args)) (begin (asm-word (car args)) (loop (cdr args)))))
  (if ofile-asm?
      (let ()
        (define (words l)
          (if (null? l) (list ")") (cons "," (cons (car l) (words (cdr l))))))
        (apply emit-asm (cons "TRAP2(" (cons num (words args)))))))
(define (emit-trap3 num)
  (asm-word (+ 20200 (areg-num table-reg)))
  (asm-word (trap-offset num))
  (if ofile-asm? (emit-asm "TRAP3(" num ")")))
(define (emit-rts) (asm-word 20085) (if ofile-asm? (emit-asm "rts")))
(define (emit-nop) (asm-word 20081) (if ofile-asm? (emit-asm "nop")))
(define (emit-jmp opnd)
  (asm-word (+ 20160 (opnd->mode/reg opnd)))
  (opnd-ext-rd-long opnd)
  (if ofile-asm? (emit-asm "jmp" ofile-tab (opnd-str opnd))))
(define (emit-jmp-glob glob)
  (asm-word 8814)
  (asm-ref-glob-jump glob)
  (asm-word 20177)
  (if ofile-asm? (emit-asm "JMP_GLOB(" (glob-name glob) ")")))
(define (emit-jmp-proc num offset)
  (asm-word 20217)
  (asm-proc-ref num offset)
  (if ofile-asm? (emit-asm "JMP_PROC(" num "," offset ")")))
(define (emit-jmp-prim val offset)
  (asm-word 20217)
  (asm-prim-ref val offset)
  (if ofile-asm? (emit-asm "JMP_PRIM(" (proc-obj-name val) "," offset ")")))
(define (emit-jsr opnd)
  (asm-word (+ 20096 (opnd->mode/reg opnd)))
  (opnd-ext-rd-long opnd)
  (if ofile-asm? (emit-asm "jsr" ofile-tab (opnd-str opnd))))
(define (emit-word n)
  (asm-word n)
  (if ofile-asm? (emit-asm ".word" ofile-tab n)))
(define (emit-label lbl)
  (asm-label lbl #f)
  (if ofile-asm? (emit-asm* "L" lbl ":")))
(define (emit-label-subproc lbl parent-lbl label-descr)
  (asm-align 8 0)
  (asm-wrel parent-lbl (- 32768 type-procedure))
  (asm-label lbl label-descr)
  (if ofile-asm?
      (begin (emit-asm "SUBPROC(L" parent-lbl ")") (emit-asm* "L" lbl ":"))))
(define (emit-label-return lbl parent-lbl fs link label-descr)
  (asm-align 8 4)
  (asm-word (* fs 4))
  (asm-word (* (- fs link) 4))
  (asm-wrel parent-lbl (- 32768 type-procedure))
  (asm-label lbl label-descr)
  (if ofile-asm?
      (begin
        (emit-asm "RETURN(L" parent-lbl "," fs "," link ")")
        (emit-asm* "L" lbl ":"))))
(define (emit-label-task-return lbl parent-lbl fs link label-descr)
  (asm-align 8 4)
  (asm-word (+ 32768 (* fs 4)))
  (asm-word (* (- fs link) 4))
  (asm-wrel parent-lbl (- 32768 type-procedure))
  (asm-label lbl label-descr)
  (if ofile-asm?
      (begin
        (emit-asm "TASK_RETURN(L" parent-lbl "," fs "," link ")")
        (emit-asm* "L" lbl ":"))))
(define (emit-lbl-ptr lbl)
  (asm-wrel lbl 0)
  (if ofile-asm? (emit-asm "LBL_PTR(L" lbl ")")))
(define (emit-set-glob glob)
  (asm-set-glob glob)
  (if ofile-asm? (emit-asm "SET_GLOB(" (glob-name glob) ")")))
(define (emit-const obj)
  (let ((n (pos-in-list obj (queue->list asm-const-queue))))
    (if n
        (make-pcr const-lbl (* n 4))
        (let ((m (length (queue->list asm-const-queue))))
          (queue-put! asm-const-queue obj)
          (make-pcr const-lbl (* m 4))))))
(define (emit-stat stat)
  (asm-word 21177)
  (asm-stat stat)
  (if ofile-asm? (emit-asm "STAT(" stat ")")))
(define (emit-asm . l) (asm-comment (cons ofile-tab l)))
(define (emit-asm* . l) (asm-comment l))
(define (emit-muls.l opnd1 opnd2)
  (asm-m68020-proc)
  (asm-word (+ 19456 (opnd->mode/reg opnd1)))
  (asm-word (+ 2048 (* (dreg-num opnd2) 4096)))
  (opnd-ext-rd-long opnd1)
  (if ofile-asm?
      (emit-asm "mulsl" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-divsl.l opnd1 opnd2 opnd3)
  (asm-m68020-proc)
  (asm-word (+ 19520 (opnd->mode/reg opnd1)))
  (asm-word (+ 2048 (* (dreg-num opnd3) 4096) (dreg-num opnd2)))
  (opnd-ext-rd-long opnd1)
  (if ofile-asm?
      (emit-asm
       "divsll"
       ofile-tab
       (opnd-str opnd1)
       ","
       (opnd-str opnd2)
       ":"
       (opnd-str opnd3))))
(define (emit-fint.dx opnd1 opnd2) (emit-fop.dx "int" 1 opnd1 opnd2))
(define (emit-fsinh.dx opnd1 opnd2) (emit-fop.dx "sinh" 2 opnd1 opnd2))
(define (emit-fintrz.dx opnd1 opnd2) (emit-fop.dx "intrz" 3 opnd1 opnd2))
(define (emit-fsqrt.dx opnd1 opnd2) (emit-fop.dx "sqrt" 4 opnd1 opnd2))
(define (emit-flognp1.dx opnd1 opnd2) (emit-fop.dx "lognp1" 6 opnd1 opnd2))
(define (emit-fetoxm1.dx opnd1 opnd2) (emit-fop.dx "etoxm1" 8 opnd1 opnd2))
(define (emit-ftanh.dx opnd1 opnd2) (emit-fop.dx "tanh" 9 opnd1 opnd2))
(define (emit-fatan.dx opnd1 opnd2) (emit-fop.dx "atan" 10 opnd1 opnd2))
(define (emit-fasin.dx opnd1 opnd2) (emit-fop.dx "asin" 12 opnd1 opnd2))
(define (emit-fatanh.dx opnd1 opnd2) (emit-fop.dx "atanh" 13 opnd1 opnd2))
(define (emit-fsin.dx opnd1 opnd2) (emit-fop.dx "sin" 14 opnd1 opnd2))
(define (emit-ftan.dx opnd1 opnd2) (emit-fop.dx "tan" 15 opnd1 opnd2))
(define (emit-fetox.dx opnd1 opnd2) (emit-fop.dx "etox" 16 opnd1 opnd2))
(define (emit-ftwotox.dx opnd1 opnd2) (emit-fop.dx "twotox" 17 opnd1 opnd2))
(define (emit-ftentox.dx opnd1 opnd2) (emit-fop.dx "tentox" 18 opnd1 opnd2))
(define (emit-flogn.dx opnd1 opnd2) (emit-fop.dx "logn" 20 opnd1 opnd2))
(define (emit-flog10.dx opnd1 opnd2) (emit-fop.dx "log10" 21 opnd1 opnd2))
(define (emit-flog2.dx opnd1 opnd2) (emit-fop.dx "log2" 22 opnd1 opnd2))
(define (emit-fabs.dx opnd1 opnd2) (emit-fop.dx "abs" 24 opnd1 opnd2))
(define (emit-fcosh.dx opnd1 opnd2) (emit-fop.dx "cosh" 25 opnd1 opnd2))
(define (emit-fneg.dx opnd1 opnd2) (emit-fop.dx "neg" 26 opnd1 opnd2))
(define (emit-facos.dx opnd1 opnd2) (emit-fop.dx "acos" 28 opnd1 opnd2))
(define (emit-fcos.dx opnd1 opnd2) (emit-fop.dx "cos" 29 opnd1 opnd2))
(define (emit-fgetexp.dx opnd1 opnd2) (emit-fop.dx "getexp" 30 opnd1 opnd2))
(define (emit-fgetman.dx opnd1 opnd2) (emit-fop.dx "getman" 31 opnd1 opnd2))
(define (emit-fdiv.dx opnd1 opnd2) (emit-fop.dx "div" 32 opnd1 opnd2))
(define (emit-fmod.dx opnd1 opnd2) (emit-fop.dx "mod" 33 opnd1 opnd2))
(define (emit-fadd.dx opnd1 opnd2) (emit-fop.dx "add" 34 opnd1 opnd2))
(define (emit-fmul.dx opnd1 opnd2) (emit-fop.dx "mul" 35 opnd1 opnd2))
(define (emit-fsgldiv.dx opnd1 opnd2) (emit-fop.dx "sgldiv" 36 opnd1 opnd2))
(define (emit-frem.dx opnd1 opnd2) (emit-fop.dx "rem" 37 opnd1 opnd2))
(define (emit-fscale.dx opnd1 opnd2) (emit-fop.dx "scale" 38 opnd1 opnd2))
(define (emit-fsglmul.dx opnd1 opnd2) (emit-fop.dx "sglmul" 39 opnd1 opnd2))
(define (emit-fsub.dx opnd1 opnd2) (emit-fop.dx "sub" 40 opnd1 opnd2))
(define (emit-fcmp.dx opnd1 opnd2) (emit-fop.dx "cmp" 56 opnd1 opnd2))
(define (emit-fop.dx name code opnd1 opnd2)
  (asm-m68881-proc)
  (asm-word (+ 61952 (opnd->mode/reg opnd1)))
  (asm-word
   (+ (if (freg? opnd1) (* (freg-num opnd1) 1024) 21504)
      (* (freg-num opnd2) 128)
      code))
  (opnd-ext-rd-long opnd1)
  (if ofile-asm?
      (emit-asm
       "f"
       name
       (if (freg? opnd1) "x" "d")
       ofile-tab
       (opnd-str opnd1)
       ","
       (opnd-str opnd2))))
(define (emit-fmov.dx opnd1 opnd2)
  (emit-fmov
   (if (and (freg? opnd1) (freg? opnd2)) (* (freg-num opnd1) 1024) 21504)
   opnd1
   opnd2)
  (if ofile-asm?
      (emit-asm
       (if (and (freg? opnd1) (freg? opnd2)) "fmovex" "fmoved")
       ofile-tab
       (opnd-str opnd1)
       ","
       (opnd-str opnd2))))
(define (emit-fmov.l opnd1 opnd2)
  (emit-fmov 16384 opnd1 opnd2)
  (if ofile-asm?
      (emit-asm "fmovel" ofile-tab (opnd-str opnd1) "," (opnd-str opnd2))))
(define (emit-fmov code opnd1 opnd2)
  (define (fmov code opnd1 opnd2)
    (asm-m68881-proc)
    (asm-word (+ 61952 (opnd->mode/reg opnd1)))
    (asm-word (+ (* (freg-num opnd2) 128) code))
    (opnd-ext-rd-long opnd1))
  (if (freg? opnd2) (fmov code opnd1 opnd2) (fmov (+ code 8192) opnd2 opnd1)))
(define (emit-fbeq lbl)
  (asm-m68881-proc)
  (asm-word 62081)
  (asm-wrel lbl 0)
  (if ofile-asm? (emit-asm "fbeq" ofile-tab "L" lbl)))
(define (emit-fbne lbl)
  (asm-m68881-proc)
  (asm-word 62094)
  (asm-wrel lbl 0)
  (if ofile-asm? (emit-asm "fbne" ofile-tab "L" lbl)))
(define (emit-fblt lbl)
  (asm-m68881-proc)
  (asm-word 62100)
  (asm-wrel lbl 0)
  (if ofile-asm? (emit-asm "fblt" ofile-tab "L" lbl)))
(define (emit-fbgt lbl)
  (asm-m68881-proc)
  (asm-word 62098)
  (asm-wrel lbl 0)
  (if ofile-asm? (emit-asm "fbgt" ofile-tab "L" lbl)))
(define (emit-fble lbl)
  (asm-m68881-proc)
  (asm-word 62101)
  (asm-wrel lbl 0)
  (if ofile-asm? (emit-asm "fble" ofile-tab "L" lbl)))
(define (emit-fbge lbl)
  (asm-m68881-proc)
  (asm-word 62099)
  (asm-wrel lbl 0)
  (if ofile-asm? (emit-asm "fbge" ofile-tab "L" lbl)))
(define (opnd->mode/reg opnd)
  (cond ((disp? opnd) (+ 32 (disp-areg opnd)))
        ((inx? opnd) (+ 40 (inx-areg opnd)))
        ((pcr? opnd) 58)
        ((imm? opnd) 60)
        ((glob? opnd) (+ 32 table-reg))
        ((freg? opnd) 0)
        (else opnd)))
(define (opnd->reg/mode opnd)
  (let ((x (opnd->mode/reg opnd)))
    (* (+ (* 8 (remainder x 8)) (quotient x 8)) 64)))
(define (opnd-ext-rd-long opnd) (opnd-extension opnd #f #f))
(define (opnd-ext-rd-word opnd) (opnd-extension opnd #f #t))
(define (opnd-ext-wr-long opnd) (opnd-extension opnd #t #f))
(define (opnd-ext-wr-word opnd) (opnd-extension opnd #t #t))
(define (opnd-extension opnd write? word?)
  (cond ((disp? opnd) (asm-word (disp-offset opnd)))
        ((inx? opnd)
         (asm-word
          (+ (+ (* (inx-ireg opnd) 4096) 2048)
             (modulo (inx-offset opnd) 256))))
        ((pcr? opnd) (asm-wrel (pcr-lbl opnd) (pcr-offset opnd)))
        ((imm? opnd)
         (if word? (asm-word (imm-val opnd)) (asm-long (imm-val opnd))))
        ((glob? opnd) (if write? (asm-set-glob opnd) (asm-ref-glob opnd)))))
(define (opnd-str opnd)
  (cond ((dreg? opnd)
         (vector-ref
          '#("d0" "d1" "d2" "d3" "d4" "d5" "d6" "d7")
          (dreg-num opnd)))
        ((areg? opnd)
         (vector-ref
          '#("a0" "a1" "a2" "a3" "a4" "a5" "a6" "sp")
          (areg-num opnd)))
        ((ind? opnd)
         (vector-ref
          '#("a0@" "a1@" "a2@" "a3@" "a4@" "a5@" "a6@" "sp@")
          (areg-num (ind-areg opnd))))
        ((pinc? opnd)
         (vector-ref
          '#("a0@+" "a1@+" "a2@+" "a3@+" "a4@+" "a5@+" "a6@+" "sp@+")
          (areg-num (pinc-areg opnd))))
        ((pdec? opnd)
         (vector-ref
          '#("a0@-" "a1@-" "a2@-" "a3@-" "a4@-" "a5@-" "a6@-" "sp@-")
          (areg-num (pdec-areg opnd))))
        ((disp? opnd)
         (string-append
          (opnd-str (disp-areg opnd))
          "@("
          (number->string (disp-offset opnd))
          ")"))
        ((inx? opnd)
         (string-append
          (opnd-str (inx-areg opnd))
          "@("
          (number->string (inx-offset opnd))
          ","
          (opnd-str (inx-ireg opnd))
          ":l)"))
        ((pcr? opnd)
         (let ((lbl (pcr-lbl opnd)) (offs (pcr-offset opnd)))
           (if (= offs 0)
               (string-append "L" (number->string lbl))
               (string-append
                "L"
                (number->string lbl)
                "+"
                (number->string offs)))))
        ((imm? opnd) (string-append "#" (number->string (imm-val opnd))))
        ((glob? opnd)
         (string-append "GLOB(" (symbol->string (glob-name opnd)) ")"))
        ((freg? opnd)
         (vector-ref
          '#("fp0" "fp1" "fp2" "fp3" "fp4" "fp5" "fp6" "fp7")
          (freg-num opnd)))
        ((reg-list? opnd)
         (let loop ((l (reg-list-regs opnd)) (result "[") (sep ""))
           (if (pair? l)
               (loop (cdr l) (string-append result sep (opnd-str (car l))) "/")
               (string-append result "]"))))
        (else (compiler-internal-error "opnd-str, unknown 'opnd'" opnd))))
(define (begin! info-port targ)
  (set! return-reg (make-reg 0))
  (target-end!-set! targ end!)
  (target-dump-set! targ dump)
  (target-nb-regs-set! targ nb-gvm-regs)
  (target-prim-info-set! targ prim-info)
  (target-label-info-set! targ label-info)
  (target-jump-info-set! targ jump-info)
  (target-proc-result-set! targ (make-reg 1))
  (target-task-return-set! targ return-reg)
  (set! *info-port* info-port)
  '())
(define (end!) '())
(define *info-port* '())
(define nb-gvm-regs 5)
(define nb-arg-regs 3)
(define pointer-size 4)
(define prim-proc-table
  (map (lambda (x)
         (cons (string->canonical-symbol (car x))
               (apply make-proc-obj (car x) #t #f (cdr x))))
       prim-procs))
(define (prim-info name)
  (let ((x (assq name prim-proc-table))) (if x (cdr x) #f)))
(define (get-prim-info name)
  (let ((proc (prim-info (string->canonical-symbol name))))
    (if proc
        proc
        (compiler-internal-error "get-prim-info, unknown primitive:" name))))
(define (label-info min-args nb-parms rest? closed?)
  (let ((nb-stacked (max 0 (- nb-parms nb-arg-regs))))
    (define (location-of-parms i)
      (if (> i nb-parms)
          '()
          (cons (cons i
                      (if (> i nb-stacked)
                          (make-reg (- i nb-stacked))
                          (make-stk i)))
                (location-of-parms (+ i 1)))))
    (let ((x (cons (cons 'return 0) (location-of-parms 1))))
      (make-pcontext
       nb-stacked
       (if closed?
           (cons (cons 'closure-env (make-reg (+ nb-arg-regs 1))) x)
           x)))))
(define (jump-info nb-args)
  (let ((nb-stacked (max 0 (- nb-args nb-arg-regs))))
    (define (location-of-args i)
      (if (> i nb-args)
          '()
          (cons (cons i
                      (if (> i nb-stacked)
                          (make-reg (- i nb-stacked))
                          (make-stk i)))
                (location-of-args (+ i 1)))))
    (make-pcontext
     nb-stacked
     (cons (cons 'return (make-reg 0)) (location-of-args 1)))))
(define (closed-var-offset i) (+ (* i pointer-size) 2))
(define (dump proc filename c-intf options)
  (if *info-port*
      (begin (display "Dumping:" *info-port*) (newline *info-port*)))
  (set! ofile-asm? (memq 'asm options))
  (set! ofile-stats? (memq 'stats options))
  (set! debug-info? (memq 'debug options))
  (set! object-queue (queue-empty))
  (set! objects-dumped (queue-empty))
  (ofile.begin! filename add-object)
  (queue-put! object-queue proc)
  (queue-put! objects-dumped proc)
  (let loop ((index 0))
    (if (not (queue-empty? object-queue))
        (let ((obj (queue-get! object-queue)))
          (dump-object obj index)
          (loop (+ index 1)))))
  (ofile.end!)
  (if *info-port* (newline *info-port*))
  (set! object-queue '())
  (set! objects-dumped '()))
(define debug-info? '())
(define object-queue '())
(define objects-dumped '())
(define (add-object obj)
  (if (and (proc-obj? obj) (not (proc-obj-code obj)))
      #f
      (let ((n (pos-in-list obj (queue->list objects-dumped))))
        (if n
            n
            (let ((m (length (queue->list objects-dumped))))
              (queue-put! objects-dumped obj)
              (queue-put! object-queue obj)
              m)))))
(define (dump-object obj index)
  (ofile-line "|------------------------------------------------------")
  (case (obj-type obj)
    ((pair) (dump-pair obj))
    ((flonum) (dump-flonum obj))
    ((subtyped)
     (case (obj-subtype obj)
       ((vector) (dump-vector obj))
       ((symbol) (dump-symbol obj))
;;       ((ratnum) (dump-ratnum obj))
;;       ((cpxnum) (dump-cpxnum obj))
       ((string) (dump-string obj))
       ((bignum) (dump-bignum obj))
       (else
        (compiler-internal-error
         "dump-object, can't dump object 'obj':"
         obj))))
    ((procedure) (dump-procedure obj))
    (else
     (compiler-internal-error "dump-object, can't dump object 'obj':" obj))))
(define (dump-pair pair)
  (ofile-long pair-prefix)
  (ofile-ref (cdr pair))
  (ofile-ref (car pair)))
(define (dump-vector v)
  (ofile-long (+ (* (vector-length v) 1024) (* subtype-vector 8)))
  (let ((len (vector-length v)))
    (let loop ((i 0))
      (if (< i len) (begin (ofile-ref (vector-ref v i)) (loop (+ i 1)))))))
(define (dump-symbol sym)
  (compiler-internal-error "dump-symbol, can't dump SYMBOL type"))
;;(define (dump-ratnum x)
;;  (ofile-long (+ (* 2 1024) (* subtype-ratnum 8)))
;;  (ofile-ref (numerator x))
;;  (ofile-ref (denominator x)))
;;(define (dump-cpxnum x)
;;  (ofile-long (+ (* 2 1024) (* subtype-cpxnum 8)))
;;  (ofile-ref (real-part x))
;;  (ofile-ref (imag-part x)))
(define (dump-string s)
  (ofile-long (+ (* (+ (string-length s) 1) 256) (* subtype-string 8)))
  (let ((len (string-length s)))
    (define (ref i) (if (>= i len) 0 (character-encoding (string-ref s i))))
    (let loop ((i 0))
      (if (<= i len)
          (begin
            (ofile-word (+ (* (ref i) 256) (ref (+ i 1))))
            (loop (+ i 2)))))))
(define (dump-flonum x)
  (let ((bits (flonum->bits x)))
    (ofile-long flonum-prefix)
    (ofile-long (quotient bits 4294967296))
    (ofile-long (modulo bits 4294967296))))
(define (flonum->inexact-exponential-format x)
  (define (exp-form-pos x y i)
    (let ((i*2 (+ i i)))
      (let ((z (if (and (not (< flonum-e-bias i*2)) (not (< x y)))
                   (exp-form-pos x (* y y) i*2)
                   (cons x 0))))
        (let ((a (car z)) (b (cdr z)))
          (let ((i+b (+ i b)))
            (if (and (not (< flonum-e-bias i+b)) (not (< a y)))
                (begin (set-car! z (/ a y)) (set-cdr! z i+b)))
            z)))))
  (define (exp-form-neg x y i)
    (let ((i*2 (+ i i)))
      (let ((z (if (and (< i*2 flonum-e-bias-minus-1) (< x y))
                   (exp-form-neg x (* y y) i*2)
                   (cons x 0))))
        (let ((a (car z)) (b (cdr z)))
          (let ((i+b (+ i b)))
            (if (and (< i+b flonum-e-bias-minus-1) (< a y))
                (begin (set-car! z (/ a y)) (set-cdr! z i+b)))
            z)))))
  (define (exp-form x)
    (if (< x inexact-+1)
        (let ((z (exp-form-neg x inexact-+1/2 1)))
          (set-car! z (* inexact-+2 (car z)))
          (set-cdr! z (- -1 (cdr z)))
          z)
        (exp-form-pos x inexact-+2 1)))
  (if (negative? x)
      (let ((z (exp-form (- inexact-0 x))))
        (set-car! z (- inexact-0 (car z)))
        z)
      (exp-form x)))
(define (flonum->exact-exponential-format x)
  (let ((z (flonum->inexact-exponential-format x)))
    (let ((y (car z)))
      (cond ((not (< y inexact-+2))
             (set-car! z flonum-+m-min)
             (set-cdr! z flonum-e-bias-plus-1))
            ((not (< inexact--2 y))
             (set-car! z flonum--m-min)
             (set-cdr! z flonum-e-bias-plus-1))
            (else
             (set-car!
              z
              (truncate (inexact->exact (* (car z) inexact-m-min))))))
      (set-cdr! z (- (cdr z) flonum-m-bits))
      z)))
(define (flonum->bits x)
  (define (bits a b)
    (if (< a flonum-+m-min)
        a
        (+ (- a flonum-+m-min)
           (* (+ (+ b flonum-m-bits) flonum-e-bias) flonum-+m-min))))
  (let ((z (flonum->exact-exponential-format x)))
    (let ((a (car z)) (b (cdr z)))
      (if (negative? a) (+ flonum-sign-bit (bits (- 0 a) b)) (bits a b)))))
(define flonum-m-bits 52)
(define flonum-e-bits 11)
(define flonum-sign-bit 9223372036854775808)
(define flonum-+m-min 4503599627370496)
(define flonum--m-min -4503599627370496)
(define flonum-e-bias 1023)
(define flonum-e-bias-plus-1 1024)
(define flonum-e-bias-minus-1 1022)
(define inexact-m-min (exact->inexact flonum-+m-min))
(define inexact-+2 (exact->inexact 2))
(define inexact--2 (exact->inexact -2))
(define inexact-+1 (exact->inexact 1))
(define inexact-+1/2 (/ (exact->inexact 1) (exact->inexact 2)))
(define inexact-0 (exact->inexact 0))
(define (dump-bignum x)
  (define radix 16384)
  (define (integer->digits n)
    (if (= n 0)
        '()
        (cons (remainder n radix) (integer->digits (quotient n radix)))))
  (let ((l (integer->digits (abs x))))
    (ofile-long (+ (* (+ (length l) 1) 512) (* subtype-bignum 8)))
    (if (< x 0) (ofile-word 0) (ofile-word 1))
    (for-each ofile-word l)))
(define (dump-procedure proc)
  (let ((bbs (proc-obj-code proc)))
    (set! entry-lbl-num (bbs-entry-lbl-num bbs))
    (set! label-counter (bbs-lbl-counter bbs))
    (set! var-descr-queue (queue-empty))
    (set! first-class-label-queue (queue-empty))
    (set! deferred-code-queue (queue-empty))
    (if *info-port*
        (begin
          (display "  #[" *info-port*)
          (if (proc-obj-primitive? proc)
              (display "primitive " *info-port*)
              (display "procedure " *info-port*))
          (display (proc-obj-name proc) *info-port*)
          (display "]" *info-port*)))
    (if (proc-obj-primitive? proc)
        (ofile-prim-proc (proc-obj-name proc))
        (ofile-user-proc))
    (asm.begin!)
    (let loop ((prev-bb #f) (prev-gvm-instr #f) (l (bbs->code-list bbs)))
      (if (not (null? l))
          (let ((pres-bb (code-bb (car l)))
                (pres-gvm-instr (code-gvm-instr (car l)))
                (pres-slots-needed (code-slots-needed (car l)))
                (next-gvm-instr
                 (if (null? (cdr l)) #f (code-gvm-instr (cadr l)))))
            (if ofile-asm? (asm-comment (car l)))
            (gen-gvm-instr
             prev-gvm-instr
             pres-gvm-instr
             next-gvm-instr
             pres-slots-needed)
            (loop pres-bb pres-gvm-instr (cdr l)))))
    (asm.end!
     (if debug-info?
         (vector (lst->vector (queue->list first-class-label-queue))
                 (lst->vector (queue->list var-descr-queue)))
         #f))
    (if *info-port* (newline *info-port*))
    (set! var-descr-queue '())
    (set! first-class-label-queue '())
    (set! deferred-code-queue '())
    (set! instr-source '())
    (set! entry-frame '())
    (set! exit-frame '())))
(define label-counter (lambda () 0))
(define entry-lbl-num '())
(define var-descr-queue '())
(define first-class-label-queue '())
(define deferred-code-queue '())
(define instr-source '())
(define entry-frame '())
(define exit-frame '())
(define (defer-code! thunk) (queue-put! deferred-code-queue thunk))
(define (gen-deferred-code!)
  (let loop ()
    (if (not (queue-empty? deferred-code-queue))
        (let ((thunk (queue-get! deferred-code-queue))) (thunk) (loop)))))
(define (add-var-descr! descr)
  (define (index x l)
    (let loop ((l l) (i 0))
      (cond ((not (pair? l)) #f)
            ((equal? (car l) x) i)
            (else (loop (cdr l) (+ i 1))))))
  (let ((n (index descr (queue->list var-descr-queue))))
    (if n
        n
        (let ((m (length (queue->list var-descr-queue))))
          (queue-put! var-descr-queue descr)
          m))))
(define (add-first-class-label! source slots frame)
  (let loop ((i 0) (l1 slots) (l2 '()))
    (if (pair? l1)
        (let ((var (car l1)))
          (let ((x (frame-live? var frame)))
            (if (and x (or (pair? x) (not (temp-var? x))))
                (let ((descr-index
                       (add-var-descr!
                        (if (pair? x)
                            (map (lambda (y) (add-var-descr! (var-name y))) x)
                            (var-name x)))))
                  (loop (+ i 1)
                        (cdr l1)
                        (cons (+ (* i 16384) descr-index) l2)))
                (loop (+ i 1) (cdr l1) l2))))
        (let ((label-descr (lst->vector (cons 0 (cons source l2)))))
          (queue-put! first-class-label-queue label-descr)
          label-descr))))
(define (gen-gvm-instr prev-gvm-instr gvm-instr next-gvm-instr sn)
  (set! instr-source (comment-get (gvm-instr-comment gvm-instr) 'source))
  (set! exit-frame (gvm-instr-frame gvm-instr))
  (set! entry-frame (and prev-gvm-instr (gvm-instr-frame prev-gvm-instr)))
  (case (gvm-instr-type gvm-instr)
    ((label)
     (set! entry-frame exit-frame)
     (set! current-fs (frame-size exit-frame))
     (case (label-type gvm-instr)
       ((simple) (gen-label-simple (label-lbl-num gvm-instr) sn))
       ((entry)
        (gen-label-entry
         (label-lbl-num gvm-instr)
         (label-entry-nb-parms gvm-instr)
         (label-entry-min gvm-instr)
         (label-entry-rest? gvm-instr)
         (label-entry-closed? gvm-instr)
         sn))
       ((return) (gen-label-return (label-lbl-num gvm-instr) sn))
       ((task-entry) (gen-label-task-entry (label-lbl-num gvm-instr) sn))
       ((task-return) (gen-label-task-return (label-lbl-num gvm-instr) sn))
       (else (compiler-internal-error "gen-gvm-instr, unknown label type"))))
    ((apply)
     (gen-apply
      (apply-prim gvm-instr)
      (apply-opnds gvm-instr)
      (apply-loc gvm-instr)
      sn))
    ((copy) (gen-copy (copy-opnd gvm-instr) (copy-loc gvm-instr) sn))
    ((close) (gen-close (close-parms gvm-instr) sn))
    ((ifjump)
     (gen-ifjump
      (ifjump-test gvm-instr)
      (ifjump-opnds gvm-instr)
      (ifjump-true gvm-instr)
      (ifjump-false gvm-instr)
      (ifjump-poll? gvm-instr)
      (if (and next-gvm-instr
               (memq (label-type next-gvm-instr) '(simple task-entry)))
          (label-lbl-num next-gvm-instr)
          #f)))
    ((jump)
     (gen-jump
      (jump-opnd gvm-instr)
      (jump-nb-args gvm-instr)
      (jump-poll? gvm-instr)
      (if (and next-gvm-instr
               (memq (label-type next-gvm-instr) '(simple task-entry)))
          (label-lbl-num next-gvm-instr)
          #f)))
    (else
     (compiler-internal-error
      "gen-gvm-instr, unknown 'gvm-instr':"
      gvm-instr))))
(define (reg-in-opnd68 opnd)
  (cond ((dreg? opnd) opnd)
        ((areg? opnd) opnd)
        ((ind? opnd) (ind-areg opnd))
        ((pinc? opnd) (pinc-areg opnd))
        ((pdec? opnd) (pdec-areg opnd))
        ((disp? opnd) (disp-areg opnd))
        ((inx? opnd) (inx-ireg opnd))
        (else #f)))
(define (temp-in-opnd68 opnd)
  (let ((reg (reg-in-opnd68 opnd)))
    (if reg
        (cond ((identical-opnd68? reg dtemp1) reg)
              ((identical-opnd68? reg atemp1) reg)
              ((identical-opnd68? reg atemp2) reg)
              (else #f))
        #f)))
(define (pick-atemp keep)
  (if (and keep (identical-opnd68? keep atemp1)) atemp2 atemp1))
(define return-reg '())
(define max-nb-args 1024)
(define heap-allocation-fudge (* pointer-size (+ (* 2 max-nb-args) 1024)))
(define intr-flag 0)
(define ltq-tail 1)
(define ltq-head 2)
(define heap-lim 12)
(define closure-lim 17)
(define closure-ptr 18)
(define intr-flag-slot (make-disp* pstate-reg (* pointer-size intr-flag)))
(define ltq-tail-slot (make-disp* pstate-reg (* pointer-size ltq-tail)))
(define ltq-head-slot (make-disp* pstate-reg (* pointer-size ltq-head)))
(define heap-lim-slot (make-disp* pstate-reg (* pointer-size heap-lim)))
(define closure-lim-slot (make-disp* pstate-reg (* pointer-size closure-lim)))
(define closure-ptr-slot (make-disp* pstate-reg (* pointer-size closure-ptr)))
(define touch-trap 1)
(define non-proc-jump-trap 6)
(define rest-params-trap 7)
(define rest-params-closed-trap 8)
(define wrong-nb-arg1-trap 9)
(define wrong-nb-arg1-closed-trap 10)
(define wrong-nb-arg2-trap 11)
(define wrong-nb-arg2-closed-trap 12)
(define heap-alloc1-trap 13)
(define heap-alloc2-trap 14)
(define closure-alloc-trap 15)
(define intr-trap 24)
(define cache-line-length 16)
(define polling-intermittency '())
(set! polling-intermittency 10)
(define (stat-clear!) (set! *stats* (cons 0 '())))
(define (stat-dump!) (emit-stat (cdr *stats*)))
(define (stat-add! bin count)
  (define (add! stats bin count)
    (set-car! stats (+ (car stats) count))
    (if (not (null? bin))
        (let ((x (assoc (car bin) (cdr stats))))
          (if x
              (add! (cdr x) (cdr bin) count)
              (begin
                (set-cdr! stats (cons (list (car bin) 0) (cdr stats)))
                (add! (cdadr stats) (cdr bin) count))))))
  (add! *stats* bin count))
(define (fetch-stat-add! gvm-opnd) (opnd-stat-add! 'fetch gvm-opnd))
(define (store-stat-add! gvm-opnd) (opnd-stat-add! 'store gvm-opnd))
(define (jump-stat-add! gvm-opnd) (opnd-stat-add! 'jump gvm-opnd))
(define (opnd-stat-add! type opnd)
  (cond ((reg? opnd) (stat-add! (list 'gvm-opnd 'reg type (reg-num opnd)) 1))
        ((stk? opnd) (stat-add! (list 'gvm-opnd 'stk type) 1))
        ((glo? opnd) (stat-add! (list 'gvm-opnd 'glo type (glo-name opnd)) 1))
        ((clo? opnd)
         (stat-add! (list 'gvm-opnd 'clo type) 1)
         (fetch-stat-add! (clo-base opnd)))
        ((lbl? opnd) (stat-add! (list 'gvm-opnd 'lbl type) 1))
        ((obj? opnd)
         (let ((val (obj-val opnd)))
           (if (number? val)
               (stat-add! (list 'gvm-opnd 'obj type val) 1)
               (stat-add! (list 'gvm-opnd 'obj type (obj-type val)) 1))))
        (else
         (compiler-internal-error "opnd-stat-add!, unknown 'opnd':" opnd))))
(define (opnd-stat opnd)
  (cond ((reg? opnd) 'reg)
        ((stk? opnd) 'stk)
        ((glo? opnd) 'glo)
        ((clo? opnd) 'clo)
        ((lbl? opnd) 'lbl)
        ((obj? opnd) 'obj)
        (else (compiler-internal-error "opnd-stat, unknown 'opnd':" opnd))))
(define *stats* '())
(define (move-opnd68-to-loc68 opnd loc)
  (if (not (identical-opnd68? opnd loc))
      (if (imm? opnd)
          (move-n-to-loc68 (imm-val opnd) loc)
          (emit-move.l opnd loc))))
(define (move-obj-to-loc68 obj loc)
  (let ((n (obj-encoding obj)))
    (if n (move-n-to-loc68 n loc) (emit-move.l (emit-const obj) loc))))
(define (move-n-to-loc68 n loc)
  (cond ((= n bits-null) (emit-move.l null-reg loc))
        ((= n bits-false) (emit-move.l false-reg loc))
        ((and (dreg? loc) (>= n -128) (<= n 127)) (emit-moveq n loc))
        ((and (areg? loc) (>= n -32768) (<= n 32767))
         (emit-move.w (make-imm n) loc))
        ((and (identical-opnd68? loc pdec-sp) (>= n -32768) (<= n 32767))
         (emit-pea* n))
        ((= n 0) (emit-clr.l loc))
        ((and (not (and (inx? loc) (= (inx-ireg loc) dtemp1)))
              (>= n -128)
              (<= n 127))
         (emit-moveq n dtemp1)
         (emit-move.l dtemp1 loc))
        (else (emit-move.l (make-imm n) loc))))
(define (add-n-to-loc68 n loc)
  (if (not (= n 0))
      (cond ((and (>= n -8) (<= n 8))
             (if (> n 0) (emit-addq.l n loc) (emit-subq.l (- n) loc)))
            ((and (areg? loc) (>= n -32768) (<= n 32767))
             (emit-lea (make-disp loc n) loc))
            ((and (not (identical-opnd68? loc dtemp1)) (>= n -128) (<= n 128))
             (emit-moveq (- (abs n)) dtemp1)
             (if (> n 0) (emit-sub.l dtemp1 loc) (emit-add.l dtemp1 loc)))
            (else (emit-add.l (make-imm n) loc)))))
(define (power-of-2 n)
  (let loop ((i 0) (k 1))
    (cond ((= k n) i) ((> k n) #f) (else (loop (+ i 1) (* k 2))))))
(define (mul-n-to-reg68 n reg)
  (if (= n 0)
      (emit-moveq 0 reg)
      (let ((abs-n (abs n)))
        (if (= abs-n 1)
            (if (< n 0) (emit-neg.l reg))
            (let ((shift (power-of-2 abs-n)))
              (if shift
                  (let ((m (min shift 32)))
                    (if (or (<= m 8) (identical-opnd68? reg dtemp1))
                        (let loop ((i m))
                          (if (> i 0)
                              (begin
                                (emit-asl.l (make-imm (min i 8)) reg)
                                (loop (- i 8)))))
                        (begin (emit-moveq m dtemp1) (emit-asl.l dtemp1 reg)))
                    (if (< n 0) (emit-neg.l reg)))
                  (emit-muls.l (make-imm n) reg)))))))
(define (div-n-to-reg68 n reg)
  (let ((abs-n (abs n)))
    (if (= abs-n 1)
        (if (< n 0) (emit-neg.l reg))
        (let ((shift (power-of-2 abs-n)))
          (if shift
              (let ((m (min shift 32)) (lbl (new-lbl!)))
                (emit-move.l reg reg)
                (emit-bpl lbl)
                (add-n-to-loc68 (* (- abs-n 1) 8) reg)
                (emit-label lbl)
                (if (or (<= m 8) (identical-opnd68? reg dtemp1))
                    (let loop ((i m))
                      (if (> i 0)
                          (begin
                            (emit-asr.l (make-imm (min i 8)) reg)
                            (loop (- i 8)))))
                    (begin (emit-moveq m dtemp1) (emit-asr.l dtemp1 reg)))
                (if (< n 0) (emit-neg.l reg)))
              (emit-divsl.l (make-imm n) reg reg))))))
(define (cmp-n-to-opnd68 n opnd)
  (cond ((= n bits-null) (emit-cmp.l opnd null-reg) #f)
        ((= n bits-false) (emit-cmp.l opnd false-reg) #f)
        ((or (pcr? opnd) (imm? opnd))
         (if (= n 0)
             (begin (emit-move.l opnd dtemp1) #t)
             (begin
               (move-opnd68-to-loc68 opnd atemp1)
               (if (and (>= n -32768) (<= n 32767))
                   (emit-cmp.w (make-imm n) atemp1)
                   (emit-cmp.l (make-imm n) atemp1))
               #t)))
        ((= n 0) (emit-move.l opnd dtemp1) #t)
        ((and (>= n -128) (<= n 127) (not (identical-opnd68? opnd dtemp1)))
         (emit-moveq n dtemp1)
         (emit-cmp.l opnd dtemp1)
         #f)
        (else (emit-cmp.l (make-imm n) opnd) #t)))
(define current-fs '())
(define (adjust-current-fs n) (set! current-fs (+ current-fs n)))
(define (new-lbl!) (label-counter))
(define (needed? loc sn) (and loc (if (stk? loc) (<= (stk-num loc) sn) #t)))
(define (sn-opnd opnd sn)
  (cond ((stk? opnd) (max (stk-num opnd) sn))
        ((clo? opnd) (sn-opnd (clo-base opnd) sn))
        (else sn)))
(define (sn-opnds opnds sn)
  (if (null? opnds) sn (sn-opnd (car opnds) (sn-opnds (cdr opnds) sn))))
(define (sn-opnd68 opnd sn)
  (cond ((and (disp*? opnd) (identical-opnd68? (disp*-areg opnd) sp-reg))
         (max (disp*-offset opnd) sn))
        ((identical-opnd68? opnd pdec-sp) (max (+ current-fs 1) sn))
        ((identical-opnd68? opnd pinc-sp) (max current-fs sn))
        (else sn)))
(define (resize-frame n)
  (let ((x (- n current-fs)))
    (adjust-current-fs x)
    (add-n-to-loc68 (* (- pointer-size) x) sp-reg)))
(define (shrink-frame n)
  (cond ((< n current-fs) (resize-frame n))
        ((> n current-fs)
         (compiler-internal-error "shrink-frame, can't increase frame size"))))
(define (make-top-of-frame n sn)
  (if (and (< n current-fs) (>= n sn)) (resize-frame n)))
(define (make-top-of-frame-if-stk-opnd68 opnd sn)
  (if (frame-base-rel? opnd)
      (make-top-of-frame (frame-base-rel-slot opnd) sn)))
(define (make-top-of-frame-if-stk-opnds68 opnd1 opnd2 sn)
  (if (frame-base-rel? opnd1)
      (let ((slot1 (frame-base-rel-slot opnd1)))
        (if (frame-base-rel? opnd2)
            (make-top-of-frame (max (frame-base-rel-slot opnd2) slot1) sn)
            (make-top-of-frame slot1 sn)))
      (if (frame-base-rel? opnd2)
          (make-top-of-frame (frame-base-rel-slot opnd2) sn))))
(define (opnd68->true-opnd68 opnd sn)
  (if (frame-base-rel? opnd)
      (let ((slot (frame-base-rel-slot opnd)))
        (cond ((> slot current-fs) (adjust-current-fs 1) pdec-sp)
              ((and (= slot current-fs) (< sn current-fs))
               (adjust-current-fs -1)
               pinc-sp)
              (else (make-disp* sp-reg (* pointer-size (- current-fs slot))))))
      opnd))
(define (move-opnd68-to-any-areg opnd keep sn)
  (if (areg? opnd)
      opnd
      (let ((areg (pick-atemp keep)))
        (make-top-of-frame-if-stk-opnd68 opnd sn)
        (move-opnd68-to-loc68 (opnd68->true-opnd68 opnd sn) areg)
        areg)))
(define (clo->opnd68 opnd keep sn)
  (let ((base (clo-base opnd)) (offs (closed-var-offset (clo-index opnd))))
    (if (lbl? base) (make-pcr (lbl-num base) offs) (clo->loc68 opnd keep sn))))
(define (clo->loc68 opnd keep sn)
  (let ((base (clo-base opnd)) (offs (closed-var-offset (clo-index opnd))))
    (cond ((eq? base return-reg) (make-disp* (reg->reg68 base) offs))
          ((obj? base)
           (let ((areg (pick-atemp keep)))
             (move-obj-to-loc68 (obj-val base) areg)
             (make-disp* areg offs)))
          (else
           (let ((areg (pick-atemp keep)))
             (move-opnd-to-loc68 base areg sn)
             (make-disp* areg offs))))))
(define (reg->reg68 reg) (reg-num->reg68 (reg-num reg)))
(define (reg-num->reg68 num)
  (if (= num 0) (make-areg gvm-reg0) (make-dreg (+ (- num 1) gvm-reg1))))
(define (opnd->opnd68 opnd keep sn)
  (cond ((lbl? opnd)
         (let ((areg (pick-atemp keep)))
           (emit-lea (make-pcr (lbl-num opnd) 0) areg)
           areg))
        ((obj? opnd)
         (let ((val (obj-val opnd)))
           (if (proc-obj? val)
               (let ((num (add-object val)) (areg (pick-atemp keep)))
                 (if num (emit-move-proc num areg) (emit-move-prim val areg))
                 areg)
               (let ((n (obj-encoding val)))
                 (if n (make-imm n) (emit-const val))))))
        ((clo? opnd) (clo->opnd68 opnd keep sn))
        (else (loc->loc68 opnd keep sn))))
(define (loc->loc68 loc keep sn)
  (cond ((reg? loc) (reg->reg68 loc))
        ((stk? loc) (make-frame-base-rel (stk-num loc)))
        ((glo? loc) (make-glob (glo-name loc)))
        ((clo? loc) (clo->loc68 loc keep sn))
        (else (compiler-internal-error "loc->loc68, unknown 'loc':" loc))))
(define (move-opnd68-to-loc opnd loc sn)
  (cond ((reg? loc)
         (make-top-of-frame-if-stk-opnd68 opnd sn)
         (move-opnd68-to-loc68 (opnd68->true-opnd68 opnd sn) (reg->reg68 loc)))
        ((stk? loc)
         (let* ((loc-slot (stk-num loc))
                (sn-after-opnd1 (if (< loc-slot sn) sn (- loc-slot 1))))
           (if (> current-fs loc-slot)
               (make-top-of-frame
                (if (frame-base-rel? opnd)
                    (let ((opnd-slot (frame-base-rel-slot opnd)))
                      (if (>= opnd-slot (- loc-slot 1)) opnd-slot loc-slot))
                    loc-slot)
                sn-after-opnd1))
           (let* ((opnd1 (opnd68->true-opnd68 opnd sn-after-opnd1))
                  (opnd2 (opnd68->true-opnd68
                          (make-frame-base-rel loc-slot)
                          sn)))
             (move-opnd68-to-loc68 opnd1 opnd2))))
        ((glo? loc)
         (make-top-of-frame-if-stk-opnd68 opnd sn)
         (move-opnd68-to-loc68
          (opnd68->true-opnd68 opnd sn)
          (make-glob (glo-name loc))))
        ((clo? loc)
         (let ((clo (clo->loc68
                     loc
                     (temp-in-opnd68 opnd)
                     (sn-opnd68 opnd sn))))
           (make-top-of-frame-if-stk-opnd68 opnd sn)
           (move-opnd68-to-loc68 (opnd68->true-opnd68 opnd sn) clo)))
        (else
         (compiler-internal-error "move-opnd68-to-loc, unknown 'loc':" loc))))
(define (move-opnd-to-loc68 opnd loc68 sn)
  (if (and (lbl? opnd) (areg? loc68))
      (emit-lea (make-pcr (lbl-num opnd) 0) loc68)
      (let* ((sn-after-opnd68 (sn-opnd68 loc68 sn))
             (opnd68 (opnd->opnd68
                      opnd
                      (temp-in-opnd68 loc68)
                      sn-after-opnd68)))
        (make-top-of-frame-if-stk-opnds68 opnd68 loc68 sn)
        (let* ((opnd68* (opnd68->true-opnd68 opnd68 sn-after-opnd68))
               (loc68* (opnd68->true-opnd68 loc68 sn)))
          (move-opnd68-to-loc68 opnd68* loc68*)))))
(define (copy-opnd-to-loc opnd loc sn)
  (if (and (lbl? opnd) (eq? loc return-reg))
      (emit-lea (make-pcr (lbl-num opnd) 0) (reg->reg68 loc))
      (move-opnd68-to-loc (opnd->opnd68 opnd #f (sn-opnd loc sn)) loc sn)))
(define (touch-reg68-to-reg68 src dst)
  (define (trap-to-touch-handler dreg lbl)
    (if ofile-stats?
        (emit-stat
         '((touch 0
                  (determined-placeholder -1)
                  (undetermined-placeholder 1)))))
    (gen-trap
     instr-source
     entry-frame
     #t
     dreg
     (+ touch-trap (dreg-num dreg))
     lbl))
  (define (touch-dreg-to-reg src dst)
    (let ((lbl1 (new-lbl!)))
      (emit-btst src placeholder-reg)
      (emit-bne lbl1)
      (if ofile-stats?
          (emit-stat
           '((touch 0 (non-placeholder -1) (determined-placeholder 1)))))
      (trap-to-touch-handler src lbl1)
      (move-opnd68-to-loc68 src dst)))
  (define (touch-areg-to-dreg src dst)
    (let ((lbl1 (new-lbl!)))
      (emit-move.l src dst)
      (emit-btst dst placeholder-reg)
      (emit-bne lbl1)
      (if ofile-stats?
          (emit-stat
           '((touch 0 (non-placeholder -1) (determined-placeholder 1)))))
      (trap-to-touch-handler dst lbl1)))
  (if ofile-stats? (emit-stat '((touch 1 (non-placeholder 1)))))
  (cond ((dreg? src) (touch-dreg-to-reg src dst))
        ((dreg? dst) (touch-areg-to-dreg src dst))
        (else (emit-move.l src dtemp1) (touch-dreg-to-reg dtemp1 dst))))
(define (touch-opnd-to-any-reg68 opnd sn)
  (if (reg? opnd)
      (let ((reg (reg->reg68 opnd))) (touch-reg68-to-reg68 reg reg) reg)
      (let ((opnd68 (opnd->opnd68 opnd #f sn)))
        (make-top-of-frame-if-stk-opnd68 opnd68 sn)
        (move-opnd68-to-loc68 (opnd68->true-opnd68 opnd68 sn) dtemp1)
        (touch-reg68-to-reg68 dtemp1 dtemp1)
        dtemp1)))
(define (touch-opnd-to-loc opnd loc sn)
  (if (reg? opnd)
      (let ((reg68 (reg->reg68 opnd)))
        (if (reg? loc)
            (touch-reg68-to-reg68 reg68 (reg->reg68 loc))
            (begin
              (touch-reg68-to-reg68 reg68 reg68)
              (move-opnd68-to-loc reg68 loc sn))))
      (if (reg? loc)
          (let ((reg68 (reg->reg68 loc)))
            (move-opnd-to-loc68 opnd reg68 sn)
            (touch-reg68-to-reg68 reg68 reg68))
          (let ((reg68 (touch-opnd-to-any-reg68 opnd sn)))
            (move-opnd68-to-loc reg68 loc sn)))))
(define (gen-trap source frame save-live? not-save-reg num lbl)
  (define (adjust-slots l n)
    (cond ((= n 0) (append l '()))
          ((< n 0) (adjust-slots (cdr l) (+ n 1)))
          (else (adjust-slots (cons empty-var l) (- n 1)))))
  (define (set-slot! slots i x)
    (let loop ((l slots) (n (- (length slots) i)))
      (if (> n 0) (loop (cdr l) (- n 1)) (set-car! l x))))
  (let ((ret-slot (frame-first-empty-slot frame)))
    (let loop1 ((save1 '()) (save2 #f) (regs (frame-regs frame)) (i 0))
      (if (pair? regs)
          (let ((var (car regs)))
            (if (eq? var ret-var)
                (let ((x (cons (reg->reg68 (make-reg i)) var)))
                  (if (> ret-slot current-fs)
                      (loop1 (cons x save1) save2 (cdr regs) (+ i 1))
                      (loop1 save1 x (cdr regs) (+ i 1))))
                (if (and save-live?
                         (frame-live? var frame)
                         (not (eqv? not-save-reg (reg->reg68 (make-reg i)))))
                    (loop1 (cons (cons (reg->reg68 (make-reg i)) var) save1)
                           save2
                           (cdr regs)
                           (+ i 1))
                    (loop1 save1 save2 (cdr regs) (+ i 1)))))
          (let ((order (sort-list save1 (lambda (x y) (< (car x) (car y))))))
            (let ((slots (append (map cdr order)
                                 (adjust-slots
                                  (frame-slots frame)
                                  (- current-fs (frame-size frame)))))
                  (reg-list (map car order))
                  (nb-regs (length order)))
              (define (trap)
                (emit-trap2 num '())
                (gen-label-return*
                 (new-lbl!)
                 (add-first-class-label! source slots frame)
                 slots
                 0))
              (if save2
                  (begin
                    (emit-move.l
                     (car save2)
                     (make-disp*
                      sp-reg
                      (* pointer-size (- current-fs ret-slot))))
                    (set-slot! slots ret-slot (cdr save2))))
              (if (> (length order) 2)
                  (begin
                    (emit-movem.l reg-list pdec-sp)
                    (trap)
                    (emit-movem.l pinc-sp reg-list))
                  (let loop2 ((l (reverse reg-list)))
                    (if (pair? l)
                        (let ((reg (car l)))
                          (emit-move.l reg pdec-sp)
                          (loop2 (cdr l))
                          (emit-move.l pinc-sp reg))
                        (trap))))
              (if save2
                  (emit-move.l
                   (make-disp* sp-reg (* pointer-size (- current-fs ret-slot)))
                   (car save2)))
              (emit-label lbl)))))))
(define (gen-label-simple lbl sn)
  (if ofile-stats?
      (begin (stat-clear!) (stat-add! '(gvm-instr label simple) 1)))
  (set! pointers-allocated 0)
  (emit-label lbl))
(define (gen-label-entry lbl nb-parms min rest? closed? sn)
  (if ofile-stats?
      (begin
        (stat-clear!)
        (stat-add!
         (list 'gvm-instr
               'label
               'entry
               nb-parms
               min
               (if rest? 'rest 'not-rest)
               (if closed? 'closed 'not-closed))
         1)))
  (set! pointers-allocated 0)
  (let ((label-descr (add-first-class-label! instr-source '() exit-frame)))
    (if (= lbl entry-lbl-num)
        (emit-label lbl)
        (emit-label-subproc lbl entry-lbl-num label-descr)))
  (let* ((nb-parms* (if rest? (- nb-parms 1) nb-parms))
         (dispatch-lbls (make-vector (+ (- nb-parms min) 1)))
         (optional-lbls (make-vector (+ (- nb-parms min) 1))))
    (let loop ((i min))
      (if (<= i nb-parms)
          (let ((lbl (new-lbl!)))
            (vector-set! optional-lbls (- nb-parms i) lbl)
            (vector-set!
             dispatch-lbls
             (- nb-parms i)
             (if (or (>= i nb-parms) (<= nb-parms nb-arg-regs))
                 lbl
                 (new-lbl!)))
            (loop (+ i 1)))))
    (if closed?
        (let ((closure-reg (reg-num->reg68 (+ nb-arg-regs 1))))
          (emit-move.l pinc-sp closure-reg)
          (emit-subq.l 6 closure-reg)
          (if (or (and (<= min 1) (<= 1 nb-parms*))
                  (and (<= min 2) (<= 2 nb-parms*)))
              (emit-move.w dtemp1 dtemp1))))
    (if (and (<= min 2) (<= 2 nb-parms*))
        (emit-beq (vector-ref dispatch-lbls (- nb-parms 2))))
    (if (and (<= min 1) (<= 1 nb-parms*))
        (emit-bmi (vector-ref dispatch-lbls (- nb-parms 1))))
    (let loop ((i min))
      (if (<= i nb-parms*)
          (begin
            (if (not (or (= i 1) (= i 2)))
                (begin
                  (emit-cmp.w (make-imm (encode-arg-count i)) arg-count-reg)
                  (emit-beq (vector-ref dispatch-lbls (- nb-parms i)))))
            (loop (+ i 1)))))
    (cond (rest?
           (emit-trap1
            (if closed? rest-params-closed-trap rest-params-trap)
            (list min nb-parms*))
           (if (not closed?) (emit-lbl-ptr lbl))
           (set! pointers-allocated 1)
           (gen-guarantee-fudge)
           (emit-bra (vector-ref optional-lbls 0)))
          ((= min nb-parms*)
           (emit-trap1
            (if closed? wrong-nb-arg1-closed-trap wrong-nb-arg1-trap)
            (list nb-parms*))
           (if (not closed?) (emit-lbl-ptr lbl)))
          (else
           (emit-trap1
            (if closed? wrong-nb-arg2-closed-trap wrong-nb-arg2-trap)
            (list min nb-parms*))
           (if (not closed?) (emit-lbl-ptr lbl))))
    (if (> nb-parms nb-arg-regs)
        (let loop1 ((i (- nb-parms 1)))
          (if (>= i min)
              (let ((nb-stacked (if (<= i nb-arg-regs) 0 (- i nb-arg-regs))))
                (emit-label (vector-ref dispatch-lbls (- nb-parms i)))
                (let loop2 ((j 1))
                  (if (and (<= j nb-arg-regs)
                           (<= j i)
                           (<= j (- (- nb-parms nb-arg-regs) nb-stacked)))
                      (begin
                        (emit-move.l (reg-num->reg68 j) pdec-sp)
                        (loop2 (+ j 1)))
                      (let loop3 ((k j))
                        (if (and (<= k nb-arg-regs) (<= k i))
                            (begin
                              (emit-move.l
                               (reg-num->reg68 k)
                               (reg-num->reg68 (+ (- k j) 1)))
                              (loop3 (+ k 1)))))))
                (if (> i min)
                    (emit-bra (vector-ref optional-lbls (- nb-parms i))))
                (loop1 (- i 1))))))
    (let loop ((i min))
      (if (<= i nb-parms)
          (let ((val (if (= i nb-parms*) bits-null bits-unass)))
            (emit-label (vector-ref optional-lbls (- nb-parms i)))
            (cond ((> (- nb-parms i) nb-arg-regs)
                   (move-n-to-loc68 val pdec-sp))
                  ((< i nb-parms)
                   (move-n-to-loc68
                    val
                    (reg-num->reg68 (parm->reg-num (+ i 1) nb-parms)))))
            (loop (+ i 1)))))))
(define (encode-arg-count n) (cond ((= n 1) -1) ((= n 2) 0) (else (+ n 1))))
(define (parm->reg-num i nb-parms)
  (if (<= nb-parms nb-arg-regs) i (+ i (- nb-arg-regs nb-parms))))
(define (no-arg-check-entry-offset proc nb-args)
  (let ((x (proc-obj-call-pat proc)))
    (if (and (pair? x) (null? (cdr x)))
        (let ((arg-count (car x)))
          (if (= arg-count nb-args)
              (if (or (= arg-count 1) (= arg-count 2)) 10 14)
              0))
        0)))
(define (gen-label-return lbl sn)
  (if ofile-stats?
      (begin (stat-clear!) (stat-add! '(gvm-instr label return) 1)))
  (set! pointers-allocated 0)
  (let ((slots (frame-slots exit-frame)))
    (gen-label-return*
     lbl
     (add-first-class-label! instr-source slots exit-frame)
     slots
     0)))
(define (gen-label-return* lbl label-descr slots extra)
  (let ((i (pos-in-list ret-var slots)))
    (if i
        (let* ((fs (length slots)) (link (- fs i)))
          (emit-label-return lbl entry-lbl-num (+ fs extra) link label-descr))
        (compiler-internal-error
         "gen-label-return*, no return address in frame"))))
(define (gen-label-task-entry lbl sn)
  (if ofile-stats?
      (begin (stat-clear!) (stat-add! '(gvm-instr label task-entry) 1)))
  (set! pointers-allocated 0)
  (emit-label lbl)
  (if (= current-fs 0)
      (begin
        (emit-move.l (reg->reg68 return-reg) pdec-sp)
        (emit-move.l sp-reg (make-pinc ltq-tail-reg)))
      (begin
        (emit-move.l sp-reg atemp1)
        (emit-move.l (make-pinc atemp1) pdec-sp)
        (let loop ((i (- current-fs 1)))
          (if (> i 0)
              (begin
                (emit-move.l (make-pinc atemp1) (make-disp atemp1 -8))
                (loop (- i 1)))))
        (emit-move.l (reg->reg68 return-reg) (make-pdec atemp1))
        (emit-move.l atemp1 (make-pinc ltq-tail-reg))))
  (emit-move.l ltq-tail-reg ltq-tail-slot))
(define (gen-label-task-return lbl sn)
  (if ofile-stats?
      (begin (stat-clear!) (stat-add! '(gvm-instr label task-return) 1)))
  (set! pointers-allocated 0)
  (let ((slots (frame-slots exit-frame)))
    (set! current-fs (+ current-fs 1))
    (let ((dummy-lbl (new-lbl!)) (skip-lbl (new-lbl!)))
      (gen-label-return*
       dummy-lbl
       (add-first-class-label! instr-source slots exit-frame)
       slots
       1)
      (emit-bra skip-lbl)
      (gen-label-task-return*
       lbl
       (add-first-class-label! instr-source slots exit-frame)
       slots
       1)
      (emit-subq.l pointer-size ltq-tail-reg)
      (emit-label skip-lbl))))
(define (gen-label-task-return* lbl label-descr slots extra)
  (let ((i (pos-in-list ret-var slots)))
    (if i
        (let* ((fs (length slots)) (link (- fs i)))
          (emit-label-task-return
           lbl
           entry-lbl-num
           (+ fs extra)
           link
           label-descr))
        (compiler-internal-error
         "gen-label-task-return*, no return address in frame"))))
(define (gen-apply prim opnds loc sn)
  (if ofile-stats?
      (begin
        (stat-add!
         (list 'gvm-instr
               'apply
               (string->canonical-symbol (proc-obj-name prim))
               (map opnd-stat opnds)
               (if loc (opnd-stat loc) #f))
         1)
        (for-each fetch-stat-add! opnds)
        (if loc (store-stat-add! loc))))
  (let ((x (proc-obj-inlinable prim)))
    (if (not x)
        (compiler-internal-error "gen-APPLY, unknown 'prim':" prim)
        (if (or (needed? loc sn) (car x)) ((cdr x) opnds loc sn)))))
(define (define-apply name side-effects? proc)
  (let ((prim (get-prim-info name)))
    (proc-obj-inlinable-set! prim (cons side-effects? proc))))
(define (gen-copy opnd loc sn)
  (if ofile-stats?
      (begin
        (stat-add! (list 'gvm-instr 'copy (opnd-stat opnd) (opnd-stat loc)) 1)
        (fetch-stat-add! opnd)
        (store-stat-add! loc)))
  (if (needed? loc sn) (copy-opnd-to-loc opnd loc sn)))
(define (gen-close parms sn)
  (define (size->bytes size)
    (* (quotient
        (+ (* (+ size 2) pointer-size) (- cache-line-length 1))
        cache-line-length)
       cache-line-length))
  (define (parms->bytes parms)
    (if (null? parms)
        0
        (+ (size->bytes (length (closure-parms-opnds (car parms))))
           (parms->bytes (cdr parms)))))
  (if ofile-stats?
      (begin
        (for-each
         (lambda (x)
           (stat-add!
            (list 'gvm-instr
                  'close
                  (opnd-stat (closure-parms-loc x))
                  (map opnd-stat (closure-parms-opnds x)))
            1)
           (store-stat-add! (closure-parms-loc x))
           (fetch-stat-add! (make-lbl (closure-parms-lbl x)))
           (for-each fetch-stat-add! (closure-parms-opnds x)))
         parms)))
  (let ((total-space-needed (parms->bytes parms)) (lbl1 (new-lbl!)))
    (emit-move.l closure-ptr-slot atemp2)
    (move-n-to-loc68 total-space-needed dtemp1)
    (emit-sub.l dtemp1 atemp2)
    (emit-cmp.l closure-lim-slot atemp2)
    (emit-bcc lbl1)
    (gen-trap instr-source entry-frame #f #f closure-alloc-trap lbl1)
    (emit-move.l atemp2 closure-ptr-slot)
    (let* ((opnds* (apply append (map closure-parms-opnds parms)))
           (sn* (sn-opnds opnds* sn)))
      (let loop1 ((parms parms))
        (let ((loc (closure-parms-loc (car parms)))
              (size (length (closure-parms-opnds (car parms))))
              (rest (cdr parms)))
          (if (= size 1)
              (emit-addq.l type-procedure atemp2)
              (emit-move.w
               (make-imm (+ 32768 (* (+ size 1) 4)))
               (make-pinc atemp2)))
          (move-opnd68-to-loc
           atemp2
           loc
           (sn-opnds (map closure-parms-loc rest) sn*))
          (if (null? rest)
              (add-n-to-loc68
               (+ (- (size->bytes size) total-space-needed) 2)
               atemp2)
              (begin
                (add-n-to-loc68 (- (size->bytes size) type-procedure) atemp2)
                (loop1 rest)))))
      (let loop2 ((parms parms))
        (let* ((opnds (closure-parms-opnds (car parms)))
               (lbl (closure-parms-lbl (car parms)))
               (size (length opnds))
               (rest (cdr parms)))
          (emit-lea (make-pcr lbl 0) atemp1)
          (emit-move.l atemp1 (make-pinc atemp2))
          (let loop3 ((opnds opnds))
            (if (not (null? opnds))
                (let ((sn** (sn-opnds
                             (apply append (map closure-parms-opnds rest))
                             sn)))
                  (move-opnd-to-loc68
                   (car opnds)
                   (make-pinc atemp2)
                   (sn-opnds (cdr opnds) sn**))
                  (loop3 (cdr opnds)))))
          (if (not (null? rest))
              (begin
                (add-n-to-loc68
                 (- (size->bytes size) (* (+ size 1) pointer-size))
                 atemp2)
                (loop2 rest))))))))
(define (gen-ifjump test opnds true-lbl false-lbl poll? next-lbl)
  (if ofile-stats?
      (begin
        (stat-add!
         (list 'gvm-instr
               'ifjump
               (string->canonical-symbol (proc-obj-name test))
               (map opnd-stat opnds)
               (if poll? 'poll 'not-poll))
         1)
        (for-each fetch-stat-add! opnds)
        (stat-dump!)))
  (let ((proc (proc-obj-test test)))
    (if proc
        (gen-ifjump* proc opnds true-lbl false-lbl poll? next-lbl)
        (compiler-internal-error "gen-IFJUMP, unknown 'test':" test))))
(define (gen-ifjump* proc opnds true-lbl false-lbl poll? next-lbl)
  (let ((fs (frame-size exit-frame)))
    (define (double-branch)
      (proc #t opnds false-lbl fs)
      (if ofile-stats?
          (emit-stat
           '((gvm-instr.ifjump.fall-through 1)
             (gvm-instr.ifjump.double-branch 1))))
      (emit-bra true-lbl)
      (gen-deferred-code!))
    (gen-guarantee-fudge)
    (if poll? (gen-poll))
    (if next-lbl
        (cond ((= true-lbl next-lbl)
               (proc #t opnds false-lbl fs)
               (if ofile-stats?
                   (emit-stat '((gvm-instr.ifjump.fall-through 1)))))
              ((= false-lbl next-lbl)
               (proc #f opnds true-lbl fs)
               (if ofile-stats?
                   (emit-stat '((gvm-instr.ifjump.fall-through 1)))))
              (else (double-branch)))
        (double-branch))))
(define (define-ifjump name proc)
  (define-apply
   name
   #f
   (lambda (opnds loc sn)
     (let ((true-lbl (new-lbl!))
           (cont-lbl (new-lbl!))
           (reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                      (reg->reg68 loc)
                      dtemp1)))
       (proc #f opnds true-lbl current-fs)
       (move-n-to-loc68 bits-false reg68)
       (emit-bra cont-lbl)
       (emit-label true-lbl)
       (move-n-to-loc68 bits-true reg68)
       (emit-label cont-lbl)
       (move-opnd68-to-loc reg68 loc sn))))
  (proc-obj-test-set! (get-prim-info name) proc))
(define (gen-jump opnd nb-args poll? next-lbl)
  (let ((fs (frame-size exit-frame)))
    (if ofile-stats?
        (begin
          (stat-add!
           (list 'gvm-instr
                 'jump
                 (opnd-stat opnd)
                 nb-args
                 (if poll? 'poll 'not-poll))
           1)
          (jump-stat-add! opnd)
          (if (and (lbl? opnd) next-lbl (= next-lbl (lbl-num opnd)))
              (stat-add! '(gvm-instr.jump.fall-through) 1))
          (stat-dump!)))
    (gen-guarantee-fudge)
    (cond ((glo? opnd)
           (if poll? (gen-poll))
           (setup-jump fs nb-args)
           (emit-jmp-glob (make-glob (glo-name opnd)))
           (gen-deferred-code!))
          ((and (stk? opnd) (= (stk-num opnd) (+ fs 1)) (not nb-args))
           (if poll? (gen-poll))
           (setup-jump (+ fs 1) nb-args)
           (emit-rts)
           (gen-deferred-code!))
          ((lbl? opnd)
           (if (and poll?
                    (= fs current-fs)
                    (not nb-args)
                    (not (and next-lbl (= next-lbl (lbl-num opnd)))))
               (gen-poll-branch (lbl-num opnd))
               (begin
                 (if poll? (gen-poll))
                 (setup-jump fs nb-args)
                 (if (not (and next-lbl (= next-lbl (lbl-num opnd))))
                     (emit-bra (lbl-num opnd))))))
          ((obj? opnd)
           (if poll? (gen-poll))
           (let ((val (obj-val opnd)))
             (if (proc-obj? val)
                 (let ((num (add-object val))
                       (offset (no-arg-check-entry-offset val nb-args)))
                   (setup-jump fs (if (<= offset 0) nb-args #f))
                   (if num
                       (emit-jmp-proc num offset)
                       (emit-jmp-prim val offset))
                   (gen-deferred-code!))
                 (gen-jump* (opnd->opnd68 opnd #f fs) fs nb-args))))
          (else
           (if poll? (gen-poll))
           (gen-jump* (opnd->opnd68 opnd #f fs) fs nb-args)))))
(define (gen-jump* opnd fs nb-args)
  (if nb-args
      (let ((lbl (new-lbl!)))
        (make-top-of-frame-if-stk-opnd68 opnd fs)
        (move-opnd68-to-loc68 (opnd68->true-opnd68 opnd fs) atemp1)
        (shrink-frame fs)
        (emit-move.l atemp1 dtemp1)
        (emit-addq.w (modulo (- type-pair type-procedure) 8) dtemp1)
        (emit-btst dtemp1 pair-reg)
        (emit-beq lbl)
        (move-n-to-loc68 (encode-arg-count nb-args) arg-count-reg)
        (emit-trap3 non-proc-jump-trap)
        (emit-label lbl)
        (move-n-to-loc68 (encode-arg-count nb-args) arg-count-reg)
        (emit-jmp (make-ind atemp1)))
      (let ((areg (move-opnd68-to-any-areg opnd #f fs)))
        (setup-jump fs nb-args)
        (emit-jmp (make-ind areg))))
  (gen-deferred-code!))
(define (setup-jump fs nb-args)
  (shrink-frame fs)
  (if nb-args (move-n-to-loc68 (encode-arg-count nb-args) arg-count-reg)))
(define (gen-poll)
  (let ((lbl (new-lbl!)))
    (emit-dbra poll-timer-reg lbl)
    (emit-moveq (- polling-intermittency 1) poll-timer-reg)
    (emit-cmp.l intr-flag-slot sp-reg)
    (emit-bcc lbl)
    (gen-trap instr-source entry-frame #f #f intr-trap lbl)))
(define (gen-poll-branch lbl)
  (emit-dbra poll-timer-reg lbl)
  (emit-moveq (- polling-intermittency 1) poll-timer-reg)
  (emit-cmp.l intr-flag-slot sp-reg)
  (emit-bcc lbl)
  (gen-trap instr-source entry-frame #f #f intr-trap (new-lbl!))
  (emit-bra lbl))
(define (make-gen-slot-ref slot type)
  (lambda (opnds loc sn)
    (let ((sn-loc (sn-opnd loc sn)) (opnd (car opnds)))
      (move-opnd-to-loc68 opnd atemp1 sn-loc)
      (move-opnd68-to-loc
       (make-disp* atemp1 (- (* slot pointer-size) type))
       loc
       sn))))
(define (make-gen-slot-set! slot type)
  (lambda (opnds loc sn)
    (let ((sn-loc (if loc (sn-opnd loc sn) sn)))
      (let* ((first-opnd (car opnds))
             (second-opnd (cadr opnds))
             (sn-second-opnd (sn-opnd second-opnd sn-loc)))
        (move-opnd-to-loc68 first-opnd atemp1 sn-second-opnd)
        (move-opnd-to-loc68
         second-opnd
         (make-disp* atemp1 (- (* slot pointer-size) type))
         sn-loc)
        (if loc
            (if (not (eq? first-opnd loc))
                (move-opnd68-to-loc atemp1 loc sn)))))))
(define (gen-cons opnds loc sn)
  (let ((sn-loc (sn-opnd loc sn)))
    (let ((first-opnd (car opnds)) (second-opnd (cadr opnds)))
      (gen-guarantee-space 2)
      (if (contains-opnd? loc second-opnd)
          (let ((sn-second-opnd (sn-opnd second-opnd sn-loc)))
            (move-opnd-to-loc68 first-opnd (make-pdec heap-reg) sn-second-opnd)
            (move-opnd68-to-loc68 heap-reg atemp2)
            (move-opnd-to-loc68 second-opnd (make-pdec heap-reg) sn-loc)
            (move-opnd68-to-loc atemp2 loc sn))
          (let* ((sn-second-opnd (sn-opnd second-opnd sn))
                 (sn-loc (sn-opnd loc sn-second-opnd)))
            (move-opnd-to-loc68 first-opnd (make-pdec heap-reg) sn-loc)
            (move-opnd68-to-loc heap-reg loc sn-second-opnd)
            (move-opnd-to-loc68 second-opnd (make-pdec heap-reg) sn))))))
(define (make-gen-apply-c...r pattern)
  (lambda (opnds loc sn)
    (let ((sn-loc (sn-opnd loc sn)) (opnd (car opnds)))
      (move-opnd-to-loc68 opnd atemp1 sn-loc)
      (let loop ((pattern pattern))
        (if (<= pattern 3)
            (if (= pattern 3)
                (move-opnd68-to-loc (make-pdec atemp1) loc sn)
                (move-opnd68-to-loc (make-ind atemp1) loc sn))
            (begin
              (if (odd? pattern)
                  (emit-move.l (make-pdec atemp1) atemp1)
                  (emit-move.l (make-ind atemp1) atemp1))
              (loop (quotient pattern 2))))))))
(define (gen-set-car! opnds loc sn)
  (let ((sn-loc (if loc (sn-opnd loc sn) sn)))
    (let* ((first-opnd (car opnds))
           (second-opnd (cadr opnds))
           (sn-second-opnd (sn-opnd second-opnd sn-loc)))
      (move-opnd-to-loc68 first-opnd atemp1 sn-second-opnd)
      (move-opnd-to-loc68 second-opnd (make-ind atemp1) sn-loc)
      (if (and loc (not (eq? first-opnd loc)))
          (move-opnd68-to-loc atemp1 loc sn)))))
(define (gen-set-cdr! opnds loc sn)
  (let ((sn-loc (if loc (sn-opnd loc sn) sn)))
    (let* ((first-opnd (car opnds))
           (second-opnd (cadr opnds))
           (sn-second-opnd (sn-opnd second-opnd sn-loc)))
      (move-opnd-to-loc68 first-opnd atemp1 sn-second-opnd)
      (if (and loc (not (eq? first-opnd loc)))
          (move-opnd-to-loc68
           second-opnd
           (make-disp atemp1 (- pointer-size))
           sn-loc)
          (move-opnd-to-loc68 second-opnd (make-pdec atemp1) sn-loc))
      (if (and loc (not (eq? first-opnd loc)))
          (move-opnd68-to-loc atemp1 loc sn)))))
(define (commut-oper gen opnds loc sn self? accum-self accum-other)
  (if (null? opnds)
      (gen (reverse accum-self) (reverse accum-other) loc sn self?)
      (let ((opnd (car opnds)) (rest (cdr opnds)))
        (cond ((and (not self?) (eq? opnd loc))
               (commut-oper gen rest loc sn #t accum-self accum-other))
              ((contains-opnd? loc opnd)
               (commut-oper
                gen
                rest
                loc
                sn
                self?
                (cons opnd accum-self)
                accum-other))
              (else
               (commut-oper
                gen
                rest
                loc
                sn
                self?
                accum-self
                (cons opnd accum-other)))))))
(define (gen-add-in-place opnds loc68 sn)
  (if (not (null? opnds))
      (let* ((first-opnd (car opnds))
             (other-opnds (cdr opnds))
             (sn-other-opnds (sn-opnds other-opnds sn))
             (sn-first-opnd (sn-opnd first-opnd sn-other-opnds))
             (opnd68 (opnd->opnd68
                      first-opnd
                      (temp-in-opnd68 loc68)
                      (sn-opnd68 loc68 sn))))
        (make-top-of-frame-if-stk-opnds68 opnd68 loc68 sn-other-opnds)
        (if (imm? opnd68)
            (add-n-to-loc68
             (imm-val opnd68)
             (opnd68->true-opnd68 loc68 sn-other-opnds))
            (let ((opnd68* (opnd68->true-opnd68 opnd68 sn-other-opnds)))
              (if (or (dreg? opnd68) (reg68? loc68))
                  (emit-add.l
                   opnd68*
                   (opnd68->true-opnd68 loc68 sn-other-opnds))
                  (begin
                    (move-opnd68-to-loc68 opnd68* dtemp1)
                    (emit-add.l
                     dtemp1
                     (opnd68->true-opnd68 loc68 sn-other-opnds))))))
        (gen-add-in-place other-opnds loc68 sn))))
(define (gen-add self-opnds other-opnds loc sn self?)
  (let* ((opnds (append self-opnds other-opnds))
         (first-opnd (car opnds))
         (other-opnds (cdr opnds))
         (sn-other-opnds (sn-opnds other-opnds sn))
         (sn-first-opnd (sn-opnd first-opnd sn-other-opnds)))
    (if (<= (length self-opnds) 1)
        (let ((loc68 (loc->loc68 loc #f sn-first-opnd)))
          (if self?
              (gen-add-in-place opnds loc68 sn)
              (begin
                (move-opnd-to-loc68 first-opnd loc68 sn-other-opnds)
                (gen-add-in-place other-opnds loc68 sn))))
        (begin
          (move-opnd-to-loc68 first-opnd dtemp1 (sn-opnd loc sn-other-opnds))
          (gen-add-in-place other-opnds dtemp1 (sn-opnd loc sn))
          (if self?
              (let ((loc68 (loc->loc68 loc dtemp1 sn)))
                (make-top-of-frame-if-stk-opnd68 loc68 sn)
                (emit-add.l dtemp1 (opnd68->true-opnd68 loc68 sn)))
              (move-opnd68-to-loc dtemp1 loc sn))))))
(define (gen-sub-in-place opnds loc68 sn)
  (if (not (null? opnds))
      (let* ((first-opnd (car opnds))
             (other-opnds (cdr opnds))
             (sn-other-opnds (sn-opnds other-opnds sn))
             (sn-first-opnd (sn-opnd first-opnd sn-other-opnds))
             (opnd68 (opnd->opnd68
                      first-opnd
                      (temp-in-opnd68 loc68)
                      (sn-opnd68 loc68 sn))))
        (make-top-of-frame-if-stk-opnds68 opnd68 loc68 sn-other-opnds)
        (if (imm? opnd68)
            (add-n-to-loc68
             (- (imm-val opnd68))
             (opnd68->true-opnd68 loc68 sn-other-opnds))
            (let ((opnd68* (opnd68->true-opnd68 opnd68 sn-other-opnds)))
              (if (or (dreg? opnd68) (reg68? loc68))
                  (emit-sub.l
                   opnd68*
                   (opnd68->true-opnd68 loc68 sn-other-opnds))
                  (begin
                    (move-opnd68-to-loc68 opnd68* dtemp1)
                    (emit-sub.l
                     dtemp1
                     (opnd68->true-opnd68 loc68 sn-other-opnds))))))
        (gen-sub-in-place other-opnds loc68 sn))))
(define (gen-sub first-opnd other-opnds loc sn self-opnds?)
  (if (null? other-opnds)
      (if (and (or (reg? loc) (stk? loc)) (not (eq? loc return-reg)))
          (begin
            (copy-opnd-to-loc first-opnd loc (sn-opnd loc sn))
            (let ((loc68 (loc->loc68 loc #f sn)))
              (make-top-of-frame-if-stk-opnd68 loc68 sn)
              (emit-neg.l (opnd68->true-opnd68 loc68 sn))))
          (begin
            (move-opnd-to-loc68 first-opnd dtemp1 (sn-opnd loc sn))
            (emit-neg.l dtemp1)
            (move-opnd68-to-loc dtemp1 loc sn)))
      (let* ((sn-other-opnds (sn-opnds other-opnds sn))
             (sn-first-opnd (sn-opnd first-opnd sn-other-opnds)))
        (if (and (not self-opnds?) (or (reg? loc) (stk? loc)))
            (let ((loc68 (loc->loc68 loc #f sn-first-opnd)))
              (if (not (eq? first-opnd loc))
                  (move-opnd-to-loc68 first-opnd loc68 sn-other-opnds))
              (gen-sub-in-place other-opnds loc68 sn))
            (begin
              (move-opnd-to-loc68
               first-opnd
               dtemp1
               (sn-opnd loc sn-other-opnds))
              (gen-sub-in-place other-opnds dtemp1 (sn-opnd loc sn))
              (move-opnd68-to-loc dtemp1 loc sn))))))
(define (gen-mul-in-place opnds reg68 sn)
  (if (not (null? opnds))
      (let* ((first-opnd (car opnds))
             (other-opnds (cdr opnds))
             (sn-other-opnds (sn-opnds other-opnds sn))
             (opnd68 (opnd->opnd68 first-opnd (temp-in-opnd68 reg68) sn)))
        (make-top-of-frame-if-stk-opnd68 opnd68 sn-other-opnds)
        (if (imm? opnd68)
            (mul-n-to-reg68 (quotient (imm-val opnd68) 8) reg68)
            (begin
              (emit-asr.l (make-imm 3) reg68)
              (emit-muls.l (opnd68->true-opnd68 opnd68 sn-other-opnds) reg68)))
        (gen-mul-in-place other-opnds reg68 sn))))
(define (gen-mul self-opnds other-opnds loc sn self?)
  (let* ((opnds (append self-opnds other-opnds))
         (first-opnd (car opnds))
         (other-opnds (cdr opnds))
         (sn-other-opnds (sn-opnds other-opnds sn))
         (sn-first-opnd (sn-opnd first-opnd sn-other-opnds)))
    (if (null? self-opnds)
        (let ((loc68 (loc->loc68 loc #f sn-first-opnd)))
          (if self?
              (gen-mul-in-place opnds loc68 sn)
              (begin
                (move-opnd-to-loc68 first-opnd loc68 sn-other-opnds)
                (gen-mul-in-place other-opnds loc68 sn))))
        (begin
          (move-opnd-to-loc68 first-opnd dtemp1 (sn-opnd loc sn-other-opnds))
          (gen-mul-in-place other-opnds dtemp1 (sn-opnd loc sn))
          (if self?
              (let ((loc68 (loc->loc68 loc dtemp1 sn)))
                (make-top-of-frame-if-stk-opnd68 loc68 sn)
                (emit-asr.l (make-imm 3) dtemp1)
                (emit-muls.l dtemp1 (opnd68->true-opnd68 loc68 sn)))
              (move-opnd68-to-loc dtemp1 loc sn))))))
(define (gen-div-in-place opnds reg68 sn)
  (if (not (null? opnds))
      (let* ((first-opnd (car opnds))
             (other-opnds (cdr opnds))
             (sn-other-opnds (sn-opnds other-opnds sn))
             (sn-first-opnd (sn-opnd first-opnd sn-other-opnds))
             (opnd68 (opnd->opnd68 first-opnd (temp-in-opnd68 reg68) sn)))
        (make-top-of-frame-if-stk-opnd68 opnd68 sn-other-opnds)
        (if (imm? opnd68)
            (let ((n (quotient (imm-val opnd68) 8)))
              (div-n-to-reg68 n reg68)
              (if (> (abs n) 1) (emit-and.w (make-imm -8) reg68)))
            (let ((opnd68* (opnd68->true-opnd68 opnd68 sn-other-opnds)))
              (emit-divsl.l opnd68* reg68 reg68)
              (emit-asl.l (make-imm 3) reg68)))
        (gen-div-in-place other-opnds reg68 sn))))
(define (gen-div first-opnd other-opnds loc sn self-opnds?)
  (if (null? other-opnds)
      (begin
        (move-opnd-to-loc68 first-opnd pdec-sp (sn-opnd loc sn))
        (emit-moveq 8 dtemp1)
        (emit-divsl.l pinc-sp dtemp1 dtemp1)
        (emit-asl.l (make-imm 3) dtemp1)
        (emit-and.w (make-imm -8) dtemp1)
        (move-opnd68-to-loc dtemp1 loc sn))
      (let* ((sn-other-opnds (sn-opnds other-opnds sn))
             (sn-first-opnd (sn-opnd first-opnd sn-other-opnds)))
        (if (and (reg? loc) (not self-opnds?) (not (eq? loc return-reg)))
            (let ((reg68 (reg->reg68 loc)))
              (if (not (eq? first-opnd loc))
                  (move-opnd-to-loc68 first-opnd reg68 sn-other-opnds))
              (gen-div-in-place other-opnds reg68 sn))
            (begin
              (move-opnd-to-loc68
               first-opnd
               dtemp1
               (sn-opnd loc sn-other-opnds))
              (gen-div-in-place other-opnds dtemp1 (sn-opnd loc sn))
              (move-opnd68-to-loc dtemp1 loc sn))))))
(define (gen-rem first-opnd second-opnd loc sn)
  (let* ((sn-loc (sn-opnd loc sn))
         (sn-second-opnd (sn-opnd second-opnd sn-loc)))
    (move-opnd-to-loc68 first-opnd dtemp1 sn-second-opnd)
    (let ((opnd68 (opnd->opnd68 second-opnd #f sn-loc))
          (reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                     (reg->reg68 loc)
                     false-reg)))
      (make-top-of-frame-if-stk-opnd68 opnd68 sn-loc)
      (let ((opnd68* (if (areg? opnd68)
                         (begin (emit-move.l opnd68 reg68) reg68)
                         (opnd68->true-opnd68 opnd68 sn-loc))))
        (emit-divsl.l opnd68* reg68 dtemp1))
      (move-opnd68-to-loc reg68 loc sn)
      (if (not (and (reg? loc) (not (eq? loc return-reg))))
          (emit-move.l (make-imm bits-false) false-reg)))))
(define (gen-mod first-opnd second-opnd loc sn)
  (let* ((sn-loc (sn-opnd loc sn))
         (sn-first-opnd (sn-opnd first-opnd sn-loc))
         (sn-second-opnd (sn-opnd second-opnd sn-first-opnd))
         (opnd68 (opnd->opnd68 second-opnd #f sn-second-opnd)))
    (define (general-case)
      (let ((lbl1 (new-lbl!))
            (lbl2 (new-lbl!))
            (lbl3 (new-lbl!))
            (opnd68** (opnd68->true-opnd68 opnd68 sn-second-opnd))
            (opnd68* (opnd68->true-opnd68
                      (opnd->opnd68 first-opnd #f sn-second-opnd)
                      sn-second-opnd)))
        (move-opnd68-to-loc68 opnd68* dtemp1)
        (move-opnd68-to-loc68 opnd68** false-reg)
        (emit-divsl.l false-reg false-reg dtemp1)
        (emit-move.l false-reg false-reg)
        (emit-beq lbl3)
        (move-opnd68-to-loc68 opnd68* dtemp1)
        (emit-bmi lbl1)
        (move-opnd68-to-loc68 opnd68** dtemp1)
        (emit-bpl lbl3)
        (emit-bra lbl2)
        (emit-label lbl1)
        (move-opnd68-to-loc68 opnd68** dtemp1)
        (emit-bmi lbl3)
        (emit-label lbl2)
        (emit-add.l dtemp1 false-reg)
        (emit-label lbl3)
        (move-opnd68-to-loc false-reg loc sn)
        (emit-move.l (make-imm bits-false) false-reg)))
    (make-top-of-frame-if-stk-opnd68 opnd68 sn-first-opnd)
    (if (imm? opnd68)
        (let ((n (quotient (imm-val opnd68) 8)))
          (if (> n 0)
              (let ((shift (power-of-2 n)))
                (if shift
                    (let ((reg68 (if (and (reg? loc)
                                          (not (eq? loc return-reg)))
                                     (reg->reg68 loc)
                                     dtemp1)))
                      (move-opnd-to-loc68 first-opnd reg68 sn-loc)
                      (emit-and.l (make-imm (* (- n 1) 8)) reg68)
                      (move-opnd68-to-loc reg68 loc sn))
                    (general-case)))
              (general-case)))
        (general-case))))
(define (gen-op emit-op dst-ok?)
  (define (gen-op-in-place opnds loc68 sn)
    (if (not (null? opnds))
        (let* ((first-opnd (car opnds))
               (other-opnds (cdr opnds))
               (sn-other-opnds (sn-opnds other-opnds sn))
               (sn-first-opnd (sn-opnd first-opnd sn-other-opnds))
               (opnd68 (opnd->opnd68
                        first-opnd
                        (temp-in-opnd68 loc68)
                        (sn-opnd68 loc68 sn))))
          (make-top-of-frame-if-stk-opnds68 opnd68 loc68 sn-other-opnds)
          (if (imm? opnd68)
              (emit-op opnd68 (opnd68->true-opnd68 loc68 sn-other-opnds))
              (let ((opnd68* (opnd68->true-opnd68 opnd68 sn-other-opnds)))
                (if (or (dreg? opnd68) (dst-ok? loc68))
                    (emit-op opnd68*
                             (opnd68->true-opnd68 loc68 sn-other-opnds))
                    (begin
                      (move-opnd68-to-loc68 opnd68* dtemp1)
                      (emit-op dtemp1
                               (opnd68->true-opnd68 loc68 sn-other-opnds))))))
          (gen-op-in-place other-opnds loc68 sn))))
  (lambda (self-opnds other-opnds loc sn self?)
    (let* ((opnds (append self-opnds other-opnds))
           (first-opnd (car opnds))
           (other-opnds (cdr opnds))
           (sn-other-opnds (sn-opnds other-opnds sn))
           (sn-first-opnd (sn-opnd first-opnd sn-other-opnds)))
      (if (<= (length self-opnds) 1)
          (let ((loc68 (loc->loc68 loc #f sn-first-opnd)))
            (if self?
                (gen-op-in-place opnds loc68 sn)
                (begin
                  (move-opnd-to-loc68 first-opnd loc68 sn-other-opnds)
                  (gen-op-in-place other-opnds loc68 sn))))
          (begin
            (move-opnd-to-loc68 first-opnd dtemp1 (sn-opnd loc sn-other-opnds))
            (gen-op-in-place other-opnds dtemp1 (sn-opnd loc sn))
            (if self?
                (let ((loc68 (loc->loc68 loc dtemp1 sn)))
                  (make-top-of-frame-if-stk-opnd68 loc68 sn)
                  (emit-op dtemp1 (opnd68->true-opnd68 loc68 sn)))
                (move-opnd68-to-loc dtemp1 loc sn)))))))
(define gen-logior (gen-op emit-or.l dreg?))
(define gen-logxor (gen-op emit-eor.l (lambda (x) #f)))
(define gen-logand (gen-op emit-and.l dreg?))
(define (gen-shift right-shift)
  (lambda (opnds loc sn)
    (let ((sn-loc (sn-opnd loc sn)))
      (let* ((opnd1 (car opnds))
             (opnd2 (cadr opnds))
             (sn-opnd1 (sn-opnd opnd1 sn-loc))
             (o2 (opnd->opnd68 opnd2 #f sn-opnd1)))
        (make-top-of-frame-if-stk-opnd68 o2 sn-opnd1)
        (if (imm? o2)
            (let* ((reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                              (reg->reg68 loc)
                              dtemp1))
                   (n (quotient (imm-val o2) 8))
                   (emit-shft (if (> n 0) emit-lsl.l right-shift)))
              (move-opnd-to-loc68 opnd1 reg68 sn-loc)
              (let loop ((i (min (abs n) 29)))
                (if (> i 0)
                    (begin
                      (emit-shft (make-imm (min i 8)) reg68)
                      (loop (- i 8)))))
              (if (< n 0) (emit-and.w (make-imm -8) reg68))
              (move-opnd68-to-loc reg68 loc sn))
            (let* ((reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                              (reg->reg68 loc)
                              dtemp1))
                   (reg68* (if (and (reg? loc) (not (eq? loc return-reg)))
                               dtemp1
                               false-reg))
                   (lbl1 (new-lbl!))
                   (lbl2 (new-lbl!)))
              (emit-move.l (opnd68->true-opnd68 o2 sn-opnd1) reg68*)
              (move-opnd-to-loc68 opnd1 reg68 sn-loc)
              (emit-asr.l (make-imm 3) reg68*)
              (emit-bmi lbl1)
              (emit-lsl.l reg68* reg68)
              (emit-bra lbl2)
              (emit-label lbl1)
              (emit-neg.l reg68*)
              (right-shift reg68* reg68)
              (emit-and.w (make-imm -8) reg68)
              (emit-label lbl2)
              (move-opnd68-to-loc reg68 loc sn)
              (if (not (and (reg? loc) (not (eq? loc return-reg))))
                  (emit-move.l (make-imm bits-false) false-reg))))))))
(define (flo-oper oper1 oper2 opnds loc sn)
  (gen-guarantee-space 2)
  (move-opnd-to-loc68
   (car opnds)
   atemp1
   (sn-opnds (cdr opnds) (sn-opnd loc sn)))
  (oper1 (make-disp* atemp1 (- type-flonum)) ftemp1)
  (let loop ((opnds (cdr opnds)))
    (if (not (null? opnds))
        (let* ((opnd (car opnds))
               (other-opnds (cdr opnds))
               (sn-other-opnds (sn-opnds other-opnds sn)))
          (move-opnd-to-loc68 opnd atemp1 sn-other-opnds)
          (oper2 (make-disp* atemp1 (- type-flonum)) ftemp1)
          (loop (cdr opnds)))))
  (add-n-to-loc68 (* -2 pointer-size) heap-reg)
  (emit-fmov.dx ftemp1 (make-ind heap-reg))
  (let ((reg68 (if (reg? loc) (reg->reg68 loc) atemp1)))
    (emit-move.l heap-reg reg68)
    (emit-addq.l type-flonum reg68))
  (if (not (reg? loc)) (move-opnd68-to-loc atemp1 loc sn)))
(define (gen-make-placeholder opnds loc sn)
  (let ((sn-loc (sn-opnd loc sn)))
    (let ((opnd (car opnds)))
      (gen-guarantee-space 4)
      (emit-clr.l (make-pdec heap-reg))
      (move-opnd-to-loc68 opnd (make-pdec heap-reg) sn-loc)
      (emit-move.l null-reg (make-pdec heap-reg))
      (move-opnd68-to-loc68 heap-reg atemp2)
      (emit-addq.l (modulo (- type-placeholder type-pair) 8) atemp2)
      (emit-move.l atemp2 (make-pdec heap-reg))
      (move-opnd68-to-loc atemp2 loc sn))))
(define (gen-subprocedure-id opnds loc sn)
  (let ((sn-loc (sn-opnd loc sn))
        (opnd (car opnds))
        (reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                   (reg->reg68 loc)
                   dtemp1)))
    (move-opnd-to-loc68 opnd atemp1 sn-loc)
    (move-n-to-loc68 32768 reg68)
    (emit-sub.w (make-disp* atemp1 -2) reg68)
    (move-opnd68-to-loc reg68 loc sn)))
(define (gen-subprocedure-parent opnds loc sn)
  (let ((sn-loc (sn-opnd loc sn)) (opnd (car opnds)))
    (move-opnd-to-loc68 opnd atemp1 sn-loc)
    (emit-add.w (make-disp* atemp1 -2) atemp1)
    (add-n-to-loc68 -32768 atemp1)
    (move-opnd68-to-loc atemp1 loc sn)))
(define (gen-return-fs opnds loc sn)
  (let ((sn-loc (sn-opnd loc sn))
        (opnd (car opnds))
        (reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                   (reg->reg68 loc)
                   dtemp1))
        (lbl (new-lbl!)))
    (move-opnd-to-loc68 opnd atemp1 sn-loc)
    (emit-moveq 0 reg68)
    (emit-move.w (make-disp* atemp1 -6) reg68)
    (emit-beq lbl)
    (emit-and.w (make-imm 32767) reg68)
    (emit-subq.l 8 reg68)
    (emit-label lbl)
    (emit-addq.l 8 reg68)
    (emit-asl.l (make-imm 1) reg68)
    (move-opnd68-to-loc reg68 loc sn)))
(define (gen-return-link opnds loc sn)
  (let ((sn-loc (sn-opnd loc sn))
        (opnd (car opnds))
        (reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                   (reg->reg68 loc)
                   dtemp1))
        (lbl (new-lbl!)))
    (move-opnd-to-loc68 opnd atemp1 sn-loc)
    (emit-moveq 0 reg68)
    (emit-move.w (make-disp* atemp1 -6) reg68)
    (emit-beq lbl)
    (emit-and.w (make-imm 32767) reg68)
    (emit-subq.l 8 reg68)
    (emit-label lbl)
    (emit-addq.l 8 reg68)
    (emit-sub.w (make-disp* atemp1 -4) reg68)
    (emit-asl.l (make-imm 1) reg68)
    (move-opnd68-to-loc reg68 loc sn)))
(define (gen-procedure-info opnds loc sn)
  (let ((sn-loc (sn-opnd loc sn)) (opnd (car opnds)))
    (move-opnd-to-loc68 opnd atemp1 sn-loc)
    (emit-add.w (make-disp* atemp1 -2) atemp1)
    (move-opnd68-to-loc (make-disp* atemp1 (- 32768 6)) loc sn)))
(define (gen-guarantee-space n)
  (set! pointers-allocated (+ pointers-allocated n))
  (if (> pointers-allocated heap-allocation-fudge)
      (begin (gen-guarantee-fudge) (set! pointers-allocated n))))
(define (gen-guarantee-fudge)
  (if (> pointers-allocated 0)
      (let ((lbl (new-lbl!)))
        (emit-cmp.l heap-lim-slot heap-reg)
        (emit-bcc lbl)
        (gen-trap instr-source entry-frame #f #f heap-alloc1-trap lbl)
        (set! pointers-allocated 0))))
(define pointers-allocated '())
(define (gen-type opnds loc sn)
  (let* ((sn-loc (sn-opnd loc sn))
         (opnd (car opnds))
         (reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                    (reg->reg68 loc)
                    dtemp1)))
    (move-opnd-to-loc68 opnd reg68 sn-loc)
    (emit-and.l (make-imm 7) reg68)
    (emit-asl.l (make-imm 3) reg68)
    (move-opnd68-to-loc reg68 loc sn)))
(define (gen-type-cast opnds loc sn)
  (let ((sn-loc (if loc (sn-opnd loc sn) sn)))
    (let ((first-opnd (car opnds)) (second-opnd (cadr opnds)))
      (let* ((sn-loc (if (and loc (not (eq? first-opnd loc))) sn-loc sn))
             (o1 (opnd->opnd68 first-opnd #f (sn-opnd second-opnd sn-loc)))
             (o2 (opnd->opnd68 second-opnd (temp-in-opnd68 o1) sn-loc))
             (reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                        (reg->reg68 loc)
                        dtemp1)))
        (make-top-of-frame-if-stk-opnds68 o1 o2 sn-loc)
        (move-opnd68-to-loc68
         (opnd68->true-opnd68 o1 (sn-opnd68 o2 sn-loc))
         reg68)
        (emit-and.w (make-imm -8) reg68)
        (if (imm? o2)
            (let ((n (quotient (imm-val o2) 8)))
              (if (> n 0) (emit-addq.w n reg68)))
            (begin
              (move-opnd68-to-loc68 (opnd68->true-opnd68 o2 sn-loc) atemp1)
              (emit-exg atemp1 reg68)
              (emit-asr.l (make-imm 3) reg68)
              (emit-add.l atemp1 reg68)))
        (move-opnd68-to-loc reg68 loc sn)))))
(define (gen-subtype opnds loc sn)
  (let ((sn-loc (sn-opnd loc sn))
        (opnd (car opnds))
        (reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                   (reg->reg68 loc)
                   dtemp1)))
    (move-opnd-to-loc68 opnd atemp1 sn-loc)
    (emit-moveq 0 reg68)
    (emit-move.b (make-ind atemp1) reg68)
    (move-opnd68-to-loc reg68 loc sn)))
(define (gen-subtype-set! opnds loc sn)
  (let ((sn-loc (if loc (sn-opnd loc sn) sn)))
    (let ((first-opnd (car opnds)) (second-opnd (cadr opnds)))
      (let* ((sn-loc (if (and loc (not (eq? first-opnd loc))) sn-loc sn))
             (o1 (opnd->opnd68 first-opnd #f (sn-opnd second-opnd sn-loc)))
             (o2 (opnd->opnd68 second-opnd (temp-in-opnd68 o1) sn-loc)))
        (make-top-of-frame-if-stk-opnds68 o1 o2 sn-loc)
        (move-opnd68-to-loc68
         (opnd68->true-opnd68 o1 (sn-opnd68 o2 sn-loc))
         atemp1)
        (if (imm? o2)
            (emit-move.b (make-imm (imm-val o2)) (make-ind atemp1))
            (begin
              (move-opnd68-to-loc68 (opnd68->true-opnd68 o2 sn-loc) dtemp1)
              (emit-move.b dtemp1 (make-ind atemp1))))
        (if (and loc (not (eq? first-opnd loc)))
            (move-opnd68-to-loc atemp1 loc sn))))))
(define (vector-select kind vector string vector8 vector16)
  (case kind
    ((string) string)
    ((vector8) vector8)
    ((vector16) vector16)
    (else vector)))
(define (obj-vector? kind) (vector-select kind #t #f #f #f))
(define (make-gen-vector kind)
  (lambda (opnds loc sn)
    (let ((sn-loc (if loc (sn-opnd loc sn) sn)))
      (let* ((n (length opnds))
             (bytes (+ pointer-size
                       (* (vector-select kind 4 1 1 2)
                          (+ n (if (eq? kind 'string) 1 0)))))
             (adjust (modulo (- bytes) 8)))
        (gen-guarantee-space
         (quotient (* (quotient (+ bytes (- 8 1)) 8) 8) pointer-size))
        (if (not (= adjust 0)) (emit-subq.l adjust heap-reg))
        (if (eq? kind 'string) (emit-move.b (make-imm 0) (make-pdec heap-reg)))
        (let loop ((opnds (reverse opnds)))
          (if (pair? opnds)
              (let* ((o (car opnds)) (sn-o (sn-opnds (cdr opnds) sn-loc)))
                (if (eq? kind 'vector)
                    (move-opnd-to-loc68 o (make-pdec heap-reg) sn-o)
                    (begin
                      (move-opnd-to-loc68 o dtemp1 sn-o)
                      (emit-asr.l (make-imm 3) dtemp1)
                      (if (eq? kind 'vector16)
                          (emit-move.w dtemp1 (make-pdec heap-reg))
                          (emit-move.b dtemp1 (make-pdec heap-reg)))))
                (loop (cdr opnds)))))
        (emit-move.l
         (make-imm
          (+ (* 256 (- bytes pointer-size))
             (* 8 (if (eq? kind 'vector) subtype-vector subtype-string))))
         (make-pdec heap-reg))
        (if loc
            (begin
              (emit-lea (make-disp* heap-reg type-subtyped) atemp2)
              (move-opnd68-to-loc atemp2 loc sn)))))))
(define (make-gen-vector-length kind)
  (lambda (opnds loc sn)
    (let ((sn-loc (sn-opnd loc sn))
          (opnd (car opnds))
          (reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                     (reg->reg68 loc)
                     dtemp1)))
      (move-opnd-to-loc68 opnd atemp1 sn-loc)
      (move-opnd68-to-loc68 (make-disp* atemp1 (- type-subtyped)) reg68)
      (emit-lsr.l (make-imm (vector-select kind 7 5 5 6)) reg68)
      (if (not (eq? kind 'vector))
          (begin
            (emit-and.w (make-imm -8) reg68)
            (if (eq? kind 'string) (emit-subq.l 8 reg68))))
      (move-opnd68-to-loc reg68 loc sn))))
(define (make-gen-vector-ref kind)
  (lambda (opnds loc sn)
    (let ((sn-loc (sn-opnd loc sn)))
      (let ((first-opnd (car opnds))
            (second-opnd (cadr opnds))
            (reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                       (reg->reg68 loc)
                       dtemp1)))
        (let* ((o2 (opnd->opnd68 second-opnd #f (sn-opnd first-opnd sn-loc)))
               (o1 (opnd->opnd68 first-opnd (temp-in-opnd68 o2) sn-loc)))
          (make-top-of-frame-if-stk-opnds68 o1 o2 sn-loc)
          (let* ((offset (if (eq? kind 'closure)
                             (- pointer-size type-procedure)
                             (- pointer-size type-subtyped)))
                 (loc68 (if (imm? o2)
                            (begin
                              (move-opnd68-to-loc68
                               (opnd68->true-opnd68 o1 sn-loc)
                               atemp1)
                              (make-disp*
                               atemp1
                               (+ (quotient
                                   (imm-val o2)
                                   (vector-select kind 2 8 8 4))
                                  offset)))
                            (begin
                              (move-opnd68-to-loc68
                               (opnd68->true-opnd68 o2 (sn-opnd68 o1 sn-loc))
                               dtemp1)
                              (emit-asr.l
                               (make-imm (vector-select kind 1 3 3 2))
                               dtemp1)
                              (move-opnd68-to-loc68
                               (opnd68->true-opnd68 o1 sn-loc)
                               atemp1)
                              (if (and (identical-opnd68? reg68 dtemp1)
                                       (not (obj-vector? kind)))
                                  (begin
                                    (emit-move.l dtemp1 atemp2)
                                    (make-inx atemp1 atemp2 offset))
                                  (make-inx atemp1 dtemp1 offset))))))
            (if (not (obj-vector? kind)) (emit-moveq 0 reg68))
            (case kind
              ((string vector8) (emit-move.b loc68 reg68))
              ((vector16) (emit-move.w loc68 reg68))
              (else (emit-move.l loc68 reg68)))
            (if (not (obj-vector? kind))
                (begin
                  (emit-asl.l (make-imm 3) reg68)
                  (if (eq? kind 'string) (emit-addq.w type-special reg68))))
            (move-opnd68-to-loc reg68 loc sn)))))))
(define (make-gen-vector-set! kind)
  (lambda (opnds loc sn)
    (let ((sn-loc (if loc (sn-opnd loc sn) sn)))
      (let ((first-opnd (car opnds))
            (second-opnd (cadr opnds))
            (third-opnd (caddr opnds)))
        (let* ((sn-loc (if (and loc (not (eq? first-opnd loc)))
                           (sn-opnd first-opnd sn-loc)
                           sn))
               (sn-third-opnd (sn-opnd third-opnd sn-loc))
               (o2 (opnd->opnd68
                    second-opnd
                    #f
                    (sn-opnd first-opnd sn-third-opnd)))
               (o1 (opnd->opnd68
                    first-opnd
                    (temp-in-opnd68 o2)
                    sn-third-opnd)))
          (make-top-of-frame-if-stk-opnds68 o1 o2 sn-third-opnd)
          (let* ((offset (if (eq? kind 'closure)
                             (- pointer-size type-procedure)
                             (- pointer-size type-subtyped)))
                 (loc68 (if (imm? o2)
                            (begin
                              (move-opnd68-to-loc68
                               (opnd68->true-opnd68 o1 sn-third-opnd)
                               atemp1)
                              (make-disp*
                               atemp1
                               (+ (quotient
                                   (imm-val o2)
                                   (vector-select kind 2 8 8 4))
                                  offset)))
                            (begin
                              (move-opnd68-to-loc68
                               (opnd68->true-opnd68 o2 (sn-opnd68 o1 sn-loc))
                               dtemp1)
                              (emit-asr.l
                               (make-imm (vector-select kind 1 3 3 2))
                               dtemp1)
                              (move-opnd68-to-loc68
                               (opnd68->true-opnd68 o1 sn-loc)
                               atemp1)
                              (if (obj-vector? kind)
                                  (make-inx atemp1 dtemp1 offset)
                                  (begin
                                    (emit-move.l dtemp1 atemp2)
                                    (make-inx atemp1 atemp2 offset)))))))
            (if (obj-vector? kind)
                (move-opnd-to-loc68 third-opnd loc68 sn-loc)
                (begin
                  (move-opnd-to-loc68 third-opnd dtemp1 sn-loc)
                  (emit-asr.l (make-imm 3) dtemp1)
                  (if (eq? kind 'vector16)
                      (emit-move.w dtemp1 loc68)
                      (emit-move.b dtemp1 loc68))))
            (if (and loc (not (eq? first-opnd loc)))
                (copy-opnd-to-loc first-opnd loc sn))))))))
(define (make-gen-vector-shrink! kind)
  (lambda (opnds loc sn)
    (let ((sn-loc (if loc (sn-opnd loc sn) sn)))
      (let ((first-opnd (car opnds)) (second-opnd (cadr opnds)))
        (let* ((sn-loc (if (and loc (not (eq? first-opnd loc)))
                           (sn-opnd first-opnd sn-loc)
                           sn))
               (o2 (opnd->opnd68 second-opnd #f (sn-opnd first-opnd sn-loc)))
               (o1 (opnd->opnd68 first-opnd (temp-in-opnd68 o2) sn-loc)))
          (make-top-of-frame-if-stk-opnds68 o1 o2 sn-loc)
          (move-opnd68-to-loc68
           (opnd68->true-opnd68 o2 (sn-opnd68 o1 sn-loc))
           dtemp1)
          (emit-move.l (opnd68->true-opnd68 o1 sn-loc) atemp1)
          (if (eq? kind 'string)
              (begin
                (emit-asr.l (make-imm 3) dtemp1)
                (emit-move.b
                 (make-imm 0)
                 (make-inx atemp1 dtemp1 (- pointer-size type-subtyped)))
                (emit-addq.l 1 dtemp1)
                (emit-asl.l (make-imm 8) dtemp1))
              (emit-asl.l (make-imm (vector-select kind 7 5 5 6)) dtemp1))
          (emit-move.b (make-ind atemp1) dtemp1)
          (emit-move.l dtemp1 (make-disp* atemp1 (- type-subtyped)))
          (if (and loc (not (eq? first-opnd loc)))
              (move-opnd68-to-loc atemp1 loc sn)))))))
(define (gen-eq-test bits not? opnds lbl fs)
  (gen-compare* (opnd->opnd68 (car opnds) #f fs) (make-imm bits) fs)
  (if not? (emit-bne lbl) (emit-beq lbl)))
(define (gen-compare opnd1 opnd2 fs)
  (let* ((o1 (opnd->opnd68 opnd1 #f (sn-opnd opnd2 fs)))
         (o2 (opnd->opnd68 opnd2 (temp-in-opnd68 o1) fs)))
    (gen-compare* o1 o2 fs)))
(define (gen-compare* o1 o2 fs)
  (make-top-of-frame-if-stk-opnds68 o1 o2 fs)
  (let ((order-1-2
         (cond ((imm? o1)
                (cmp-n-to-opnd68 (imm-val o1) (opnd68->true-opnd68 o2 fs)))
               ((imm? o2)
                (not (cmp-n-to-opnd68
                      (imm-val o2)
                      (opnd68->true-opnd68 o1 fs))))
               ((reg68? o1) (emit-cmp.l (opnd68->true-opnd68 o2 fs) o1) #f)
               ((reg68? o2) (emit-cmp.l (opnd68->true-opnd68 o1 fs) o2) #t)
               (else
                (emit-move.l (opnd68->true-opnd68 o1 (sn-opnd68 o2 fs)) dtemp1)
                (emit-cmp.l (opnd68->true-opnd68 o2 fs) dtemp1)
                #f))))
    (shrink-frame fs)
    order-1-2))
(define (gen-compares branch< branch>= branch> branch<= not? opnds lbl fs)
  (gen-compares*
   gen-compare
   branch<
   branch>=
   branch>
   branch<=
   not?
   opnds
   lbl
   fs))
(define (gen-compares*
         gen-comp
         branch<
         branch>=
         branch>
         branch<=
         not?
         opnds
         lbl
         fs)
  (define (gen-compare-sequence opnd1 opnd2 rest)
    (if (null? rest)
        (if (gen-comp opnd1 opnd2 fs)
            (if not? (branch<= lbl) (branch> lbl))
            (if not? (branch>= lbl) (branch< lbl)))
        (let ((order-1-2
               (gen-comp opnd1 opnd2 (sn-opnd opnd2 (sn-opnds rest fs)))))
          (if (= current-fs fs)
              (if not?
                  (begin
                    (if order-1-2 (branch<= lbl) (branch>= lbl))
                    (gen-compare-sequence opnd2 (car rest) (cdr rest)))
                  (let ((exit-lbl (new-lbl!)))
                    (if order-1-2 (branch<= exit-lbl) (branch>= exit-lbl))
                    (gen-compare-sequence opnd2 (car rest) (cdr rest))
                    (emit-label exit-lbl)))
              (if not?
                  (let ((next-lbl (new-lbl!)))
                    (if order-1-2 (branch> next-lbl) (branch< next-lbl))
                    (shrink-frame fs)
                    (emit-bra lbl)
                    (emit-label next-lbl)
                    (gen-compare-sequence opnd2 (car rest) (cdr rest)))
                  (let* ((next-lbl (new-lbl!)) (exit-lbl (new-lbl!)))
                    (if order-1-2 (branch> next-lbl) (branch< next-lbl))
                    (shrink-frame fs)
                    (emit-bra exit-lbl)
                    (emit-label next-lbl)
                    (gen-compare-sequence opnd2 (car rest) (cdr rest))
                    (emit-label exit-lbl)))))))
  (if (or (null? opnds) (null? (cdr opnds)))
      (begin (shrink-frame fs) (if (not not?) (emit-bra lbl)))
      (gen-compare-sequence (car opnds) (cadr opnds) (cddr opnds))))
(define (gen-compare-flo opnd1 opnd2 fs)
  (let* ((o1 (opnd->opnd68 opnd1 #f (sn-opnd opnd2 fs)))
         (o2 (opnd->opnd68 opnd2 (temp-in-opnd68 o1) fs)))
    (make-top-of-frame-if-stk-opnds68 o1 o2 fs)
    (emit-move.l (opnd68->true-opnd68 o1 (sn-opnd68 o2 fs)) atemp1)
    (emit-move.l (opnd68->true-opnd68 o2 fs) atemp2)
    (emit-fmov.dx (make-disp* atemp2 (- type-flonum)) ftemp1)
    (emit-fcmp.dx (make-disp* atemp1 (- type-flonum)) ftemp1)
    #t))
(define (gen-compares-flo branch< branch>= branch> branch<= not? opnds lbl fs)
  (gen-compares*
   gen-compare-flo
   branch<
   branch>=
   branch>
   branch<=
   not?
   opnds
   lbl
   fs))
(define (gen-type-test tag not? opnds lbl fs)
  (let ((opnd (car opnds)))
    (let ((o (opnd->opnd68 opnd #f fs)))
      (define (mask-test set-reg correction)
        (emit-btst
         (if (= correction 0)
             (if (dreg? o)
                 o
                 (begin
                   (emit-move.l (opnd68->true-opnd68 o fs) dtemp1)
                   dtemp1))
             (begin
               (if (not (eq? o dtemp1))
                   (emit-move.l (opnd68->true-opnd68 o fs) dtemp1))
               (emit-addq.w correction dtemp1)
               dtemp1))
         set-reg))
      (make-top-of-frame-if-stk-opnd68 o fs)
      (cond ((= tag 0)
             (if (eq? o dtemp1)
                 (emit-and.w (make-imm 7) dtemp1)
                 (begin
                   (emit-move.l (opnd68->true-opnd68 o fs) dtemp1)
                   (emit-and.w (make-imm 7) dtemp1))))
            ((= tag type-placeholder) (mask-test placeholder-reg 0))
            (else (mask-test pair-reg (modulo (- type-pair tag) 8))))
      (shrink-frame fs)
      (if not? (emit-bne lbl) (emit-beq lbl)))))
(define (gen-subtype-test type not? opnds lbl fs)
  (let ((opnd (car opnds)))
    (let ((o (opnd->opnd68 opnd #f fs)) (cont-lbl (new-lbl!)))
      (make-top-of-frame-if-stk-opnd68 o fs)
      (if (not (eq? o dtemp1)) (emit-move.l (opnd68->true-opnd68 o fs) dtemp1))
      (emit-move.l dtemp1 atemp1)
      (emit-addq.w (modulo (- type-pair type-subtyped) 8) dtemp1)
      (emit-btst dtemp1 pair-reg)
      (shrink-frame fs)
      (if not? (emit-bne lbl) (emit-bne cont-lbl))
      (emit-cmp.b (make-imm (* type 8)) (make-ind atemp1))
      (if not? (emit-bne lbl) (emit-beq lbl))
      (emit-label cont-lbl))))
(define (gen-even-test not? opnds lbl fs)
  (move-opnd-to-loc68 (car opnds) dtemp1 fs)
  (emit-and.w (make-imm 8) dtemp1)
  (shrink-frame fs)
  (if not? (emit-bne lbl) (emit-beq lbl)))
(define (def-spec name specializer-maker)
  (let ((proc-name (string->canonical-symbol name)))
    (let ((proc (prim-info proc-name)))
      (if proc
          (proc-obj-specialize-set! proc (specializer-maker proc proc-name))
          (compiler-internal-error "def-spec, unknown primitive:" name)))))
(define (safe name)
  (lambda (proc proc-name)
    (let ((spec (get-prim-info name))) (lambda (decls) spec))))
(define (unsafe name)
  (lambda (proc proc-name)
    (let ((spec (get-prim-info name)))
      (lambda (decls) (if (not (safe? decls)) spec proc)))))
(define (safe-arith fix-name flo-name) (arith #t fix-name flo-name))
(define (unsafe-arith fix-name flo-name) (arith #f fix-name flo-name))
(define (arith fix-safe? fix-name flo-name)
  (lambda (proc proc-name)
    (let ((fix-spec (if fix-name (get-prim-info fix-name) proc))
          (flo-spec (if flo-name (get-prim-info flo-name) proc)))
      (lambda (decls)
        (let ((arith (arith-implementation proc-name decls)))
          (cond ((eq? arith fixnum-sym)
                 (if (or fix-safe? (not (safe? decls))) fix-spec proc))
                ((eq? arith flonum-sym) (if (not (safe? decls)) flo-spec proc))
                (else proc)))))))
(define-apply "##TYPE" #f (lambda (opnds loc sn) (gen-type opnds loc sn)))
(define-apply
 "##TYPE-CAST"
 #f
 (lambda (opnds loc sn) (gen-type-cast opnds loc sn)))
(define-apply
 "##SUBTYPE"
 #f
 (lambda (opnds loc sn) (gen-subtype opnds loc sn)))
(define-apply
 "##SUBTYPE-SET!"
 #t
 (lambda (opnds loc sn) (gen-subtype-set! opnds loc sn)))
(define-ifjump
 "##NOT"
 (lambda (not? opnds lbl fs) (gen-eq-test bits-false not? opnds lbl fs)))
(define-ifjump
 "##NULL?"
 (lambda (not? opnds lbl fs) (gen-eq-test bits-null not? opnds lbl fs)))
(define-ifjump
 "##UNASSIGNED?"
 (lambda (not? opnds lbl fs) (gen-eq-test bits-unass not? opnds lbl fs)))
(define-ifjump
 "##UNBOUND?"
 (lambda (not? opnds lbl fs) (gen-eq-test bits-unbound not? opnds lbl fs)))
(define-ifjump
 "##EQ?"
 (lambda (not? opnds lbl fs)
   (gen-compares emit-beq emit-bne emit-beq emit-bne not? opnds lbl fs)))
(define-ifjump
 "##FIXNUM?"
 (lambda (not? opnds lbl fs) (gen-type-test type-fixnum not? opnds lbl fs)))
(define-ifjump
 "##FLONUM?"
 (lambda (not? opnds lbl fs) (gen-type-test type-flonum not? opnds lbl fs)))
(define-ifjump
 "##SPECIAL?"
 (lambda (not? opnds lbl fs) (gen-type-test type-special not? opnds lbl fs)))
(define-ifjump
 "##PAIR?"
 (lambda (not? opnds lbl fs) (gen-type-test type-pair not? opnds lbl fs)))
(define-ifjump
 "##SUBTYPED?"
 (lambda (not? opnds lbl fs) (gen-type-test type-subtyped not? opnds lbl fs)))
(define-ifjump
 "##PROCEDURE?"
 (lambda (not? opnds lbl fs) (gen-type-test type-procedure not? opnds lbl fs)))
(define-ifjump
 "##PLACEHOLDER?"
 (lambda (not? opnds lbl fs)
   (gen-type-test type-placeholder not? opnds lbl fs)))
(define-ifjump
 "##VECTOR?"
 (lambda (not? opnds lbl fs)
   (gen-subtype-test subtype-vector not? opnds lbl fs)))
(define-ifjump
 "##SYMBOL?"
 (lambda (not? opnds lbl fs)
   (gen-subtype-test subtype-symbol not? opnds lbl fs)))
(define-ifjump
 "##RATNUM?"
 (lambda (not? opnds lbl fs)
   (gen-subtype-test subtype-ratnum not? opnds lbl fs)))
(define-ifjump
 "##CPXNUM?"
 (lambda (not? opnds lbl fs)
   (gen-subtype-test subtype-cpxnum not? opnds lbl fs)))
(define-ifjump
 "##STRING?"
 (lambda (not? opnds lbl fs)
   (gen-subtype-test subtype-string not? opnds lbl fs)))
(define-ifjump
 "##BIGNUM?"
 (lambda (not? opnds lbl fs)
   (gen-subtype-test subtype-bignum not? opnds lbl fs)))
(define-ifjump
 "##CHAR?"
 (lambda (not? opnds lbl fs)
   (let ((opnd (car opnds)))
     (let ((o (opnd->opnd68 opnd #f fs)) (cont-lbl (new-lbl!)))
       (make-top-of-frame-if-stk-opnd68 o fs)
       (emit-move.l (opnd68->true-opnd68 o fs) dtemp1)
       (if not? (emit-bmi lbl) (emit-bmi cont-lbl))
       (emit-addq.w (modulo (- type-pair type-special) 8) dtemp1)
       (emit-btst dtemp1 pair-reg)
       (shrink-frame fs)
       (if not? (emit-bne lbl) (emit-beq lbl))
       (emit-label cont-lbl)))))
(define-ifjump
 "##CLOSURE?"
 (lambda (not? opnds lbl fs)
   (move-opnd-to-loc68 (car opnds) atemp1 fs)
   (shrink-frame fs)
   (emit-cmp.w (make-imm 20153) (make-ind atemp1))
   (if not? (emit-bne lbl) (emit-beq lbl))))
(define-ifjump
 "##SUBPROCEDURE?"
 (lambda (not? opnds lbl fs)
   (move-opnd-to-loc68 (car opnds) atemp1 fs)
   (shrink-frame fs)
   (emit-move.w (make-pdec atemp1) dtemp1)
   (if not? (emit-bmi lbl) (emit-bpl lbl))))
(define-ifjump
 "##RETURN-DYNAMIC-ENV-BIND?"
 (lambda (not? opnds lbl fs)
   (move-opnd-to-loc68 (car opnds) atemp1 fs)
   (shrink-frame fs)
   (emit-move.w (make-disp* atemp1 -6) dtemp1)
   (if not? (emit-bne lbl) (emit-beq lbl))))
(define-apply
 "##FIXNUM.+"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (cond ((null? opnds) (copy-opnd-to-loc (make-obj '0) loc sn))
           ((null? (cdr opnds)) (copy-opnd-to-loc (car opnds) loc sn))
           ((or (reg? loc) (stk? loc))
            (commut-oper gen-add opnds loc sn #f '() '()))
           (else (gen-add opnds '() loc sn #f))))))
(define-apply
 "##FIXNUM.-"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (gen-sub (car opnds)
              (cdr opnds)
              loc
              sn
              (any-contains-opnd? loc (cdr opnds))))))
(define-apply
 "##FIXNUM.*"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (cond ((null? opnds) (copy-opnd-to-loc (make-obj '1) loc sn))
           ((null? (cdr opnds)) (copy-opnd-to-loc (car opnds) loc sn))
           ((and (reg? loc) (not (eq? loc return-reg)))
            (commut-oper gen-mul opnds loc sn #f '() '()))
           (else (gen-mul opnds '() loc sn #f))))))
(define-apply
 "##FIXNUM.QUOTIENT"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (gen-div (car opnds)
              (cdr opnds)
              loc
              sn
              (any-contains-opnd? loc (cdr opnds))))))
(define-apply
 "##FIXNUM.REMAINDER"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (gen-rem (car opnds) (cadr opnds) loc sn))))
(define-apply
 "##FIXNUM.MODULO"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (gen-mod (car opnds) (cadr opnds) loc sn))))
(define-apply
 "##FIXNUM.LOGIOR"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (cond ((null? opnds) (copy-opnd-to-loc (make-obj '0) loc sn))
           ((null? (cdr opnds)) (copy-opnd-to-loc (car opnds) loc sn))
           ((or (reg? loc) (stk? loc))
            (commut-oper gen-logior opnds loc sn #f '() '()))
           (else (gen-logior opnds '() loc sn #f))))))
(define-apply
 "##FIXNUM.LOGXOR"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (cond ((null? opnds) (copy-opnd-to-loc (make-obj '0) loc sn))
           ((null? (cdr opnds)) (copy-opnd-to-loc (car opnds) loc sn))
           ((or (reg? loc) (stk? loc))
            (commut-oper gen-logxor opnds loc sn #f '() '()))
           (else (gen-logxor opnds '() loc sn #f))))))
(define-apply
 "##FIXNUM.LOGAND"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (cond ((null? opnds) (copy-opnd-to-loc (make-obj '-1) loc sn))
           ((null? (cdr opnds)) (copy-opnd-to-loc (car opnds) loc sn))
           ((or (reg? loc) (stk? loc))
            (commut-oper gen-logand opnds loc sn #f '() '()))
           (else (gen-logand opnds '() loc sn #f))))))
(define-apply
 "##FIXNUM.LOGNOT"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)) (opnd (car opnds)))
     (if (and (or (reg? loc) (stk? loc)) (not (eq? loc return-reg)))
         (begin
           (copy-opnd-to-loc opnd loc sn-loc)
           (let ((loc68 (loc->loc68 loc #f sn)))
             (make-top-of-frame-if-stk-opnd68 loc68 sn)
             (emit-not.l (opnd68->true-opnd68 loc68 sn))
             (emit-and.w (make-imm -8) (opnd68->true-opnd68 loc68 sn))))
         (begin
           (move-opnd-to-loc68 opnd dtemp1 (sn-opnd loc sn))
           (emit-not.l dtemp1)
           (emit-and.w (make-imm -8) dtemp1)
           (move-opnd68-to-loc dtemp1 loc sn))))))
(define-apply "##FIXNUM.ASH" #f (gen-shift emit-asr.l))
(define-apply "##FIXNUM.LSH" #f (gen-shift emit-lsr.l))
(define-ifjump
 "##FIXNUM.ZERO?"
 (lambda (not? opnds lbl fs) (gen-eq-test 0 not? opnds lbl fs)))
(define-ifjump
 "##FIXNUM.POSITIVE?"
 (lambda (not? opnds lbl fs)
   (gen-compares
    emit-bgt
    emit-ble
    emit-blt
    emit-bge
    not?
    (list (car opnds) (make-obj '0))
    lbl
    fs)))
(define-ifjump
 "##FIXNUM.NEGATIVE?"
 (lambda (not? opnds lbl fs)
   (gen-compares
    emit-blt
    emit-bge
    emit-bgt
    emit-ble
    not?
    (list (car opnds) (make-obj '0))
    lbl
    fs)))
(define-ifjump
 "##FIXNUM.ODD?"
 (lambda (not? opnds lbl fs) (gen-even-test (not not?) opnds lbl fs)))
(define-ifjump
 "##FIXNUM.EVEN?"
 (lambda (not? opnds lbl fs) (gen-even-test not? opnds lbl fs)))
(define-ifjump
 "##FIXNUM.="
 (lambda (not? opnds lbl fs)
   (gen-compares emit-beq emit-bne emit-beq emit-bne not? opnds lbl fs)))
(define-ifjump
 "##FIXNUM.<"
 (lambda (not? opnds lbl fs)
   (gen-compares emit-blt emit-bge emit-bgt emit-ble not? opnds lbl fs)))
(define-ifjump
 "##FIXNUM.>"
 (lambda (not? opnds lbl fs)
   (gen-compares emit-bgt emit-ble emit-blt emit-bge not? opnds lbl fs)))
(define-ifjump
 "##FIXNUM.<="
 (lambda (not? opnds lbl fs)
   (gen-compares emit-ble emit-bgt emit-bge emit-blt not? opnds lbl fs)))
(define-ifjump
 "##FIXNUM.>="
 (lambda (not? opnds lbl fs)
   (gen-compares emit-bge emit-blt emit-ble emit-bgt not? opnds lbl fs)))
(define-apply
 "##FLONUM.->FIXNUM"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (move-opnd-to-loc68 (car opnds) atemp1 sn-loc)
     (let ((reg68 (if (and (reg? loc) (not (eq? loc return-reg)))
                      (reg->reg68 loc)
                      dtemp1)))
       (emit-fmov.dx (make-disp* atemp1 (- type-flonum)) ftemp1)
       (emit-fmov.l ftemp1 reg68)
       (emit-asl.l (make-imm 3) reg68)
       (if (not (and (reg? loc) (not (eq? loc return-reg))))
           (move-opnd68-to-loc reg68 loc sn))))))
(define-apply
 "##FLONUM.<-FIXNUM"
 #f
 (lambda (opnds loc sn)
   (gen-guarantee-space 2)
   (move-opnd-to-loc68
    (car opnds)
    dtemp1
    (sn-opnds (cdr opnds) (sn-opnd loc sn)))
   (emit-asr.l (make-imm 3) dtemp1)
   (emit-fmov.l dtemp1 ftemp1)
   (add-n-to-loc68 (* -2 pointer-size) heap-reg)
   (emit-fmov.dx ftemp1 (make-ind heap-reg))
   (let ((reg68 (if (reg? loc) (reg->reg68 loc) atemp1)))
     (emit-move.l heap-reg reg68)
     (emit-addq.l type-flonum reg68))
   (if (not (reg? loc)) (move-opnd68-to-loc atemp1 loc sn))))
(define-apply
 "##FLONUM.+"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (cond ((null? opnds) (copy-opnd-to-loc (make-obj inexact-0) loc sn))
           ((null? (cdr opnds)) (copy-opnd-to-loc (car opnds) loc sn))
           (else (flo-oper emit-fmov.dx emit-fadd.dx opnds loc sn))))))
(define-apply
 "##FLONUM.*"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (cond ((null? opnds) (copy-opnd-to-loc (make-obj inexact-+1) loc sn))
           ((null? (cdr opnds)) (copy-opnd-to-loc (car opnds) loc sn))
           (else (flo-oper emit-fmov.dx emit-fmul.dx opnds loc sn))))))
(define-apply
 "##FLONUM.-"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (if (null? (cdr opnds))
         (flo-oper emit-fneg.dx #f opnds loc sn)
         (flo-oper emit-fmov.dx emit-fsub.dx opnds loc sn)))))
(define-apply
 "##FLONUM./"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (if (null? (cdr opnds))
         (flo-oper
          emit-fmov.dx
          emit-fdiv.dx
          (cons (make-obj inexact-+1) opnds)
          loc
          sn)
         (flo-oper emit-fmov.dx emit-fdiv.dx opnds loc sn)))))
(define-apply
 "##FLONUM.ABS"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn))) (flo-oper emit-fabs.dx #f opnds loc sn))))
(define-apply
 "##FLONUM.TRUNCATE"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn)))
     (flo-oper emit-fintrz.dx #f opnds loc sn))))
(define-apply
 "##FLONUM.ROUND"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn))) (flo-oper emit-fint.dx #f opnds loc sn))))
(define-apply
 "##FLONUM.EXP"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn))) (flo-oper emit-fetox.dx #f opnds loc sn))))
(define-apply
 "##FLONUM.LOG"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn))) (flo-oper emit-flogn.dx #f opnds loc sn))))
(define-apply
 "##FLONUM.SIN"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn))) (flo-oper emit-fsin.dx #f opnds loc sn))))
(define-apply
 "##FLONUM.COS"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn))) (flo-oper emit-fcos.dx #f opnds loc sn))))
(define-apply
 "##FLONUM.TAN"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn))) (flo-oper emit-ftan.dx #f opnds loc sn))))
(define-apply
 "##FLONUM.ASIN"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn))) (flo-oper emit-fasin.dx #f opnds loc sn))))
(define-apply
 "##FLONUM.ACOS"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn))) (flo-oper emit-facos.dx #f opnds loc sn))))
(define-apply
 "##FLONUM.ATAN"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn))) (flo-oper emit-fatan.dx #f opnds loc sn))))
(define-apply
 "##FLONUM.SQRT"
 #f
 (lambda (opnds loc sn)
   (let ((sn-loc (sn-opnd loc sn))) (flo-oper emit-fsqrt.dx #f opnds loc sn))))
(define-ifjump
 "##FLONUM.ZERO?"
 (lambda (not? opnds lbl fs)
   (gen-compares-flo
    emit-fbeq
    emit-fbne
    emit-fbeq
    emit-fbne
    not?
    (list (car opnds) (make-obj inexact-0))
    lbl
    fs)))
(define-ifjump
 "##FLONUM.NEGATIVE?"
 (lambda (not? opnds lbl fs)
   (gen-compares-flo
    emit-fblt
    emit-fbge
    emit-fbgt
    emit-fble
    not?
    (list (car opnds) (make-obj inexact-0))
    lbl
    fs)))
(define-ifjump
 "##FLONUM.POSITIVE?"
 (lambda (not? opnds lbl fs)
   (gen-compares-flo
    emit-fbgt
    emit-fble
    emit-fblt
    emit-fbge
    not?
    (list (car opnds) (make-obj inexact-0))
    lbl
    fs)))
(define-ifjump
 "##FLONUM.="
 (lambda (not? opnds lbl fs)
   (gen-compares-flo
    emit-fbeq
    emit-fbne
    emit-fbeq
    emit-fbne
    not?
    opnds
    lbl
    fs)))
(define-ifjump
 "##FLONUM.<"
 (lambda (not? opnds lbl fs)
   (gen-compares-flo
    emit-fblt
    emit-fbge
    emit-fbgt
    emit-fble
    not?
    opnds
    lbl
    fs)))
(define-ifjump
 "##FLONUM.>"
 (lambda (not? opnds lbl fs)
   (gen-compares-flo
    emit-fbgt
    emit-fble
    emit-fblt
    emit-fbge
    not?
    opnds
    lbl
    fs)))
(define-ifjump
 "##FLONUM.<="
 (lambda (not? opnds lbl fs)
   (gen-compares-flo
    emit-fble
    emit-fbgt
    emit-fbge
    emit-fblt
    not?
    opnds
    lbl
    fs)))
(define-ifjump
 "##FLONUM.>="
 (lambda (not? opnds lbl fs)
   (gen-compares-flo
    emit-fbge
    emit-fblt
    emit-fble
    emit-fbgt
    not?
    opnds
    lbl
    fs)))
(define-ifjump
 "##CHAR=?"
 (lambda (not? opnds lbl fs)
   (gen-compares emit-beq emit-bne emit-beq emit-bne not? opnds lbl fs)))
(define-ifjump
 "##CHAR<?"
 (lambda (not? opnds lbl fs)
   (gen-compares emit-blt emit-bge emit-bgt emit-ble not? opnds lbl fs)))
(define-ifjump
 "##CHAR>?"
 (lambda (not? opnds lbl fs)
   (gen-compares emit-bgt emit-ble emit-blt emit-bge not? opnds lbl fs)))
(define-ifjump
 "##CHAR<=?"
 (lambda (not? opnds lbl fs)
   (gen-compares emit-ble emit-bgt emit-bge emit-blt not? opnds lbl fs)))
(define-ifjump
 "##CHAR>=?"
 (lambda (not? opnds lbl fs)
   (gen-compares emit-bge emit-blt emit-ble emit-bgt not? opnds lbl fs)))
(define-apply "##CONS" #f (lambda (opnds loc sn) (gen-cons opnds loc sn)))
(define-apply
 "##SET-CAR!"
 #t
 (lambda (opnds loc sn) (gen-set-car! opnds loc sn)))
(define-apply
 "##SET-CDR!"
 #t
 (lambda (opnds loc sn) (gen-set-cdr! opnds loc sn)))
(define-apply "##CAR" #f (make-gen-apply-c...r 2))
(define-apply "##CDR" #f (make-gen-apply-c...r 3))
(define-apply "##CAAR" #f (make-gen-apply-c...r 4))
(define-apply "##CADR" #f (make-gen-apply-c...r 5))
(define-apply "##CDAR" #f (make-gen-apply-c...r 6))
(define-apply "##CDDR" #f (make-gen-apply-c...r 7))
(define-apply "##CAAAR" #f (make-gen-apply-c...r 8))
(define-apply "##CAADR" #f (make-gen-apply-c...r 9))
(define-apply "##CADAR" #f (make-gen-apply-c...r 10))
(define-apply "##CADDR" #f (make-gen-apply-c...r 11))
(define-apply "##CDAAR" #f (make-gen-apply-c...r 12))
(define-apply "##CDADR" #f (make-gen-apply-c...r 13))
(define-apply "##CDDAR" #f (make-gen-apply-c...r 14))
(define-apply "##CDDDR" #f (make-gen-apply-c...r 15))
(define-apply "##CAAAAR" #f (make-gen-apply-c...r 16))
(define-apply "##CAAADR" #f (make-gen-apply-c...r 17))
(define-apply "##CAADAR" #f (make-gen-apply-c...r 18))
(define-apply "##CAADDR" #f (make-gen-apply-c...r 19))
(define-apply "##CADAAR" #f (make-gen-apply-c...r 20))
(define-apply "##CADADR" #f (make-gen-apply-c...r 21))
(define-apply "##CADDAR" #f (make-gen-apply-c...r 22))
(define-apply "##CADDDR" #f (make-gen-apply-c...r 23))
(define-apply "##CDAAAR" #f (make-gen-apply-c...r 24))
(define-apply "##CDAADR" #f (make-gen-apply-c...r 25))
(define-apply "##CDADAR" #f (make-gen-apply-c...r 26))
(define-apply "##CDADDR" #f (make-gen-apply-c...r 27))
(define-apply "##CDDAAR" #f (make-gen-apply-c...r 28))
(define-apply "##CDDADR" #f (make-gen-apply-c...r 29))
(define-apply "##CDDDAR" #f (make-gen-apply-c...r 30))
(define-apply "##CDDDDR" #f (make-gen-apply-c...r 31))
(define-apply
 "##MAKE-CELL"
 #f
 (lambda (opnds loc sn) (gen-cons (list (car opnds) (make-obj '())) loc sn)))
(define-apply "##CELL-REF" #f (make-gen-apply-c...r 2))
(define-apply
 "##CELL-SET!"
 #t
 (lambda (opnds loc sn) (gen-set-car! opnds loc sn)))
(define-apply "##VECTOR" #f (make-gen-vector 'vector))
(define-apply "##VECTOR-LENGTH" #f (make-gen-vector-length 'vector))
(define-apply "##VECTOR-REF" #f (make-gen-vector-ref 'vector))
(define-apply "##VECTOR-SET!" #t (make-gen-vector-set! 'vector))
(define-apply "##VECTOR-SHRINK!" #t (make-gen-vector-shrink! 'vector))
(define-apply "##STRING" #f (make-gen-vector 'string))
(define-apply "##STRING-LENGTH" #f (make-gen-vector-length 'string))
(define-apply "##STRING-REF" #f (make-gen-vector-ref 'string))
(define-apply "##STRING-SET!" #t (make-gen-vector-set! 'string))
(define-apply "##STRING-SHRINK!" #t (make-gen-vector-shrink! 'string))
(define-apply "##VECTOR8" #f (make-gen-vector 'vector8))
(define-apply "##VECTOR8-LENGTH" #f (make-gen-vector-length 'vector8))
(define-apply "##VECTOR8-REF" #f (make-gen-vector-ref 'vector8))
(define-apply "##VECTOR8-SET!" #t (make-gen-vector-set! 'vector8))
(define-apply "##VECTOR8-SHRINK!" #t (make-gen-vector-shrink! 'vector8))
(define-apply "##VECTOR16" #f (make-gen-vector 'vector16))
(define-apply "##VECTOR16-LENGTH" #f (make-gen-vector-length 'vector16))
(define-apply "##VECTOR16-REF" #f (make-gen-vector-ref 'vector16))
(define-apply "##VECTOR16-SET!" #t (make-gen-vector-set! 'vector16))
(define-apply "##VECTOR16-SHRINK!" #t (make-gen-vector-shrink! 'vector16))
(define-apply "##CLOSURE-CODE" #f (make-gen-slot-ref 1 type-procedure))
(define-apply "##CLOSURE-REF" #f (make-gen-vector-ref 'closure))
(define-apply "##CLOSURE-SET!" #t (make-gen-vector-set! 'closure))
(define-apply
 "##SUBPROCEDURE-ID"
 #f
 (lambda (opnds loc sn) (gen-subprocedure-id opnds loc sn)))
(define-apply
 "##SUBPROCEDURE-PARENT"
 #f
 (lambda (opnds loc sn) (gen-subprocedure-parent opnds loc sn)))
(define-apply
 "##RETURN-FS"
 #f
 (lambda (opnds loc sn) (gen-return-fs opnds loc sn)))
(define-apply
 "##RETURN-LINK"
 #f
 (lambda (opnds loc sn) (gen-return-link opnds loc sn)))
(define-apply
 "##PROCEDURE-INFO"
 #f
 (lambda (opnds loc sn) (gen-procedure-info opnds loc sn)))
(define-apply
 "##PSTATE"
 #f
 (lambda (opnds loc sn) (move-opnd68-to-loc pstate-reg loc sn)))
(define-apply
 "##MAKE-PLACEHOLDER"
 #f
 (lambda (opnds loc sn) (gen-make-placeholder opnds loc sn)))
(define-apply
 "##TOUCH"
 #t
 (lambda (opnds loc sn)
   (let ((opnd (car opnds)))
     (if loc
         (touch-opnd-to-loc opnd loc sn)
         (touch-opnd-to-any-reg68 opnd sn)))))
(def-spec "NOT" (safe "##NOT"))
(def-spec "NULL?" (safe "##NULL?"))
(def-spec "EQ?" (safe "##EQ?"))
(def-spec "PAIR?" (safe "##PAIR?"))
(def-spec "PROCEDURE?" (safe "##PROCEDURE?"))
(def-spec "VECTOR?" (safe "##VECTOR?"))
(def-spec "SYMBOL?" (safe "##SYMBOL?"))
(def-spec "STRING?" (safe "##STRING?"))
(def-spec "CHAR?" (safe "##CHAR?"))
(def-spec "ZERO?" (safe-arith "##FIXNUM.ZERO?" "##FLONUM.ZERO?"))
(def-spec "POSITIVE?" (safe-arith "##FIXNUM.POSITIVE?" "##FLONUM.POSITIVE?"))
(def-spec "NEGATIVE?" (safe-arith "##FIXNUM.NEGATIVE?" "##FLONUM.NEGATIVE?"))
(def-spec "ODD?" (safe-arith "##FIXNUM.ODD?" #f))
(def-spec "EVEN?" (safe-arith "##FIXNUM.EVEN?" #f))
(def-spec "+" (unsafe-arith "##FIXNUM.+" "##FLONUM.+"))
(def-spec "*" (unsafe-arith "##FIXNUM.*" "##FLONUM.*"))
(def-spec "-" (unsafe-arith "##FIXNUM.-" "##FLONUM.-"))
(def-spec "/" (unsafe-arith #f "##FLONUM./"))
(def-spec "QUOTIENT" (unsafe-arith "##FIXNUM.QUOTIENT" #f))
(def-spec "REMAINDER" (unsafe-arith "##FIXNUM.REMAINDER" #f))
(def-spec "MODULO" (unsafe-arith "##FIXNUM.MODULO" #f))
(def-spec "=" (safe-arith "##FIXNUM.=" "##FLONUM.="))
(def-spec "<" (safe-arith "##FIXNUM.<" "##FLONUM.<"))
(def-spec ">" (safe-arith "##FIXNUM.>" "##FLONUM.>"))
(def-spec "<=" (safe-arith "##FIXNUM.<=" "##FLONUM.<="))
(def-spec ">=" (safe-arith "##FIXNUM.>=" "##FLONUM.>="))
(def-spec "ABS" (unsafe-arith #f "##FLONUM.ABS"))
(def-spec "TRUNCATE" (unsafe-arith #f "##FLONUM.TRUNCATE"))
(def-spec "EXP" (unsafe-arith #f "##FLONUM.EXP"))
(def-spec "LOG" (unsafe-arith #f "##FLONUM.LOG"))
(def-spec "SIN" (unsafe-arith #f "##FLONUM.SIN"))
(def-spec "COS" (unsafe-arith #f "##FLONUM.COS"))
(def-spec "TAN" (unsafe-arith #f "##FLONUM.TAN"))
(def-spec "ASIN" (unsafe-arith #f "##FLONUM.ASIN"))
(def-spec "ACOS" (unsafe-arith #f "##FLONUM.ACOS"))
(def-spec "ATAN" (unsafe-arith #f "##FLONUM.ATAN"))
(def-spec "SQRT" (unsafe-arith #f "##FLONUM.SQRT"))
(def-spec "CHAR=?" (safe "##CHAR=?"))
(def-spec "CHAR<?" (safe "##CHAR<?"))
(def-spec "CHAR>?" (safe "##CHAR>?"))
(def-spec "CHAR<=?" (safe "##CHAR<=?"))
(def-spec "CHAR>=?" (safe "##CHAR>=?"))
(def-spec "CONS" (safe "##CONS"))
(def-spec "SET-CAR!" (unsafe "##SET-CAR!"))
(def-spec "SET-CDR!" (unsafe "##SET-CDR!"))
(def-spec "CAR" (unsafe "##CAR"))
(def-spec "CDR" (unsafe "##CDR"))
(def-spec "CAAR" (unsafe "##CAAR"))
(def-spec "CADR" (unsafe "##CADR"))
(def-spec "CDAR" (unsafe "##CDAR"))
(def-spec "CDDR" (unsafe "##CDDR"))
(def-spec "CAAAR" (unsafe "##CAAAR"))
(def-spec "CAADR" (unsafe "##CAADR"))
(def-spec "CADAR" (unsafe "##CADAR"))
(def-spec "CADDR" (unsafe "##CADDR"))
(def-spec "CDAAR" (unsafe "##CDAAR"))
(def-spec "CDADR" (unsafe "##CDADR"))
(def-spec "CDDAR" (unsafe "##CDDAR"))
(def-spec "CDDDR" (unsafe "##CDDDR"))
(def-spec "CAAAAR" (unsafe "##CAAAAR"))
(def-spec "CAAADR" (unsafe "##CAAADR"))
(def-spec "CAADAR" (unsafe "##CAADAR"))
(def-spec "CAADDR" (unsafe "##CAADDR"))
(def-spec "CADAAR" (unsafe "##CADAAR"))
(def-spec "CADADR" (unsafe "##CADADR"))
(def-spec "CADDAR" (unsafe "##CADDAR"))
(def-spec "CADDDR" (unsafe "##CADDDR"))
(def-spec "CDAAAR" (unsafe "##CDAAAR"))
(def-spec "CDAADR" (unsafe "##CDAADR"))
(def-spec "CDADAR" (unsafe "##CDADAR"))
(def-spec "CDADDR" (unsafe "##CDADDR"))
(def-spec "CDDAAR" (unsafe "##CDDAAR"))
(def-spec "CDDADR" (unsafe "##CDDADR"))
(def-spec "CDDDAR" (unsafe "##CDDDAR"))
(def-spec "CDDDDR" (unsafe "##CDDDDR"))
(def-spec "VECTOR" (safe "##VECTOR"))
(def-spec "VECTOR-LENGTH" (unsafe "##VECTOR-LENGTH"))
(def-spec "VECTOR-REF" (unsafe "##VECTOR-REF"))
(def-spec "VECTOR-SET!" (unsafe "##VECTOR-SET!"))
(def-spec "STRING" (safe "##STRING"))
(def-spec "STRING-LENGTH" (unsafe "##STRING-LENGTH"))
(def-spec "STRING-REF" (unsafe "##STRING-REF"))
(def-spec "STRING-SET!" (unsafe "##STRING-SET!"))
(def-spec "TOUCH" (safe "##TOUCH"))
(let ((targ (make-target 4 'm68000)))
  (target-begin!-set! targ (lambda (info-port) (begin! info-port targ)))
  (put-target targ))

(define input-source-code '
(begin
(declare (standard-bindings) (fixnum) (not safe) (block))

(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1))
         (fib (- n 2)))))

(define (tak x y z)
  (if (not (< y x))
      z
      (tak (tak (- x 1) y z)
           (tak (- y 1) z x)
           (tak (- z 1) x y))))

(define (ack m n)
  (cond ((= m 0) (+ n 1))
        ((= n 0) (ack (- m 1) 1))
        (else (ack (- m 1) (ack m (- n 1))))))

(define (create-x n)
  (define result (make-vector n))
  (do ((i 0 (+ i 1)))
      ((>= i n) result)
    (vector-set! result i i)))

(define (create-y x)
  (let* ((n (vector-length x))
         (result (make-vector n)))
    (do ((i (- n 1) (- i 1)))
        ((< i 0) result)
      (vector-set! result i (vector-ref x i)))))

(define (my-try n)
  (vector-length (create-y (create-x n))))

(define (go n)
  (let loop ((repeat 100)
             (result 0))
    (if (> repeat 0)
        (loop (- repeat 1) (my-try n))
        result)))

(+ (fib 20)
   (tak 18 12 6)
   (ack 3 9)
   (go 200000))
))

(define output-expected '(
"|------------------------------------------------------"
"| #[primitive #!program] ="
"L1:"
" cmpw #1,d0"
" beq L1000"
" TRAP1(9,0)"
" LBL_PTR(L1)"
"L1000:"
" MOVE_PROC(1,a1)"
" movl a1,GLOB(fib)"
" MOVE_PROC(2,a1)"
" movl a1,GLOB(tak)"
" MOVE_PROC(3,a1)"
" movl a1,GLOB(ack)"
" MOVE_PROC(4,a1)"
" movl a1,GLOB(create-x)"
" MOVE_PROC(5,a1)"
" movl a1,GLOB(create-y)"
" MOVE_PROC(6,a1)"
" movl a1,GLOB(my-try)"
" MOVE_PROC(7,a1)"
" movl a1,GLOB(go)"
" movl a0,sp@-"
" movl #160,d1"
" lea L2,a0"
" dbra d5,L1001"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1001"
" TRAP2(24)"
" RETURN(L1,1,1)"
"L1002:"
"L1001:"
" JMP_PROC(1,10)"
" RETURN(L1,1,1)"
"L2:"
" movl d1,sp@-"
" moveq #48,d3"
" moveq #96,d2"
" movl #144,d1"
" lea L3,a0"
" JMP_PROC(2,14)"
" RETURN(L1,2,1)"
"L3:"
" movl d1,sp@-"
" moveq #72,d2"
" moveq #24,d1"
" lea L4,a0"
" JMP_PROC(3,10)"
" RETURN(L1,3,1)"
"L4:"
" movl d1,sp@-"
" movl #1600000,d1"
" lea L5,a0"
" JMP_PROC(7,10)"
" RETURN(L1,4,1)"
"L5:"
" dbra d5,L1003"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1003"
" TRAP2(24)"
" RETURN(L1,4,1)"
"L1004:"
"L1003:"
"L6:"
" addl sp@(8),d1"
" addl sp@(4),d1"
" addl sp@+,d1"
" addql #8,sp"
" rts"
"L0:"
"|------------------------------------------------------"
"| #[primitive fib] ="
"L1:"
" bmi L1000"
" TRAP1(9,1)"
" LBL_PTR(L1)"
"L1000:"
" moveq #16,d0"
" cmpl d1,d0"
" ble L3"
" bra L4"
" RETURN(L1,2,1)"
"L2:"
" movl d1,sp@-"
" movl sp@(4),d1"
" moveq #-16,d0"
" addl d0,d1"
" lea L5,a0"
" moveq #16,d0"
" cmpl d1,d0"
" bgt L4"
"L3:"
" movl a0,sp@-"
" movl d1,sp@-"
" subql #8,d1"
" lea L2,a0"
" dbra d5,L1001"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1001"
" TRAP2(24)"
" RETURN(L1,2,1)"
"L1002:"
"L1001:"
" moveq #16,d0"
" cmpl d1,d0"
" ble L3"
"L4:"
" jmp a0@"
" RETURN(L1,3,1)"
"L5:"
" addl sp@+,d1"
" dbra d5,L1003"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1003"
" TRAP2(24)"
" RETURN(L1,2,1)"
"L1004:"
"L1003:"
" addql #4,sp"
" rts"
"L0:"
"|------------------------------------------------------"
"| #[primitive tak] ="
"L1:"
" cmpw #4,d0"
" beq L1000"
" TRAP1(9,3)"
" LBL_PTR(L1)"
"L1000:"
" cmpl d1,d2"
" bge L4"
" bra L3"
" RETURN(L1,6,1)"
"L2:"
" movl d1,d3"
" movl sp@(20),a0"
" movl sp@+,d2"
" movl sp@+,d1"
" dbra d5,L1001"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1001"
" movl a0,sp@(12)"
" TRAP2(24)"
" RETURN(L1,4,1)"
"L1002:"
" movl sp@(12),a0"
"L1001:"
" cmpl d1,d2"
" lea sp@(16),sp"
" bge L4"
"L3:"
" movl a0,sp@-"
" movl d1,sp@-"
" movl d2,sp@-"
" movl d3,sp@-"
" subql #8,d1"
" lea L5,a0"
" dbra d5,L1003"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1003"
" TRAP2(24)"
" RETURN(L1,4,1)"
"L1004:"
"L1003:"
" cmpl d1,d2"
" blt L3"
"L4:"
" movl d3,d1"
" jmp a0@"
" RETURN(L1,4,1)"
"L5:"
" movl d1,sp@-"
" movl sp@(12),d3"
" movl sp@(4),d2"
" movl sp@(8),d1"
" subql #8,d1"
" lea L6,a0"
" cmpl d1,d2"
" bge L4"
" bra L3"
" RETURN(L1,5,1)"
"L6:"
" movl d1,sp@-"
" movl sp@(12),d3"
" movl sp@(16),d2"
" movl sp@(8),d1"
" subql #8,d1"
" lea L2,a0"
" cmpl d1,d2"
" bge L4"
" bra L3"
"L0:"
"|------------------------------------------------------"
"| #[primitive ack] ="
"L1:"
" beq L1000"
" TRAP1(9,2)"
" LBL_PTR(L1)"
"L1000:"
" movl d1,d0"
" bne L3"
" bra L5"
" RETURN(L1,2,1)"
"L2:"
" movl d1,d2"
" movl sp@+,d1"
" subql #8,d1"
" movl sp@+,a0"
" dbra d5,L1001"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1001"
" movl a0,sp@-"
" TRAP2(24)"
" RETURN(L1,1,1)"
"L1002:"
" movl sp@+,a0"
"L1001:"
" movl d1,d0"
" beq L5"
"L3:"
" movl d2,d0"
" bne L6"
"L4:"
" subql #8,d1"
" moveq #8,d2"
" dbra d5,L1003"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1003"
" movl a0,sp@-"
" TRAP2(24)"
" RETURN(L1,1,1)"
"L1004:"
" movl sp@+,a0"
"L1003:"
" movl d1,d0"
" bne L3"
"L5:"
" movl d2,d1"
" addql #8,d1"
" jmp a0@"
"L6:"
" movl a0,sp@-"
" movl d1,sp@-"
" movl d2,d1"
" subql #8,d1"
" movl d1,d2"
" movl sp@,d1"
" lea L2,a0"
" dbra d5,L1005"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1005"
" TRAP2(24)"
" RETURN(L1,2,1)"
"L1006:"
"L1005:"
" movl d1,d0"
" bne L3"
" bra L5"
"L0:"
"|------------------------------------------------------"
"| #[primitive create-x] ="
"L1:"
" bmi L1000"
" TRAP1(9,1)"
" LBL_PTR(L1)"
"L1000:"
" movl a0,sp@-"
" movl d1,sp@-"
" lea L2,a0"
" dbra d5,L1001"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1001"
" TRAP2(24)"
" RETURN(L1,2,1)"
"L1002:"
"L1001:"
" moveq #-1,d0"
" JMP_PRIM(make-vector,0)"
" RETURN(L1,2,1)"
"L2:"
" movl d1,d2"
" movl sp@+,d1"
" moveq #0,d3"
" movl sp@+,a0"
" dbra d5,L1003"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1003"
" movl a0,sp@-"
" TRAP2(24)"
" RETURN(L1,1,1)"
"L1004:"
" movl sp@+,a0"
"L1003:"
" cmpl d1,d3"
" bge L4"
"L3:"
" movl d3,d0"
" asrl #1,d0"
" movl d2,a1"
" movl d3,a1@(1,d0:l)"
" addql #8,d3"
" dbra d5,L1005"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1005"
" movl a0,sp@-"
" TRAP2(24)"
" RETURN(L1,1,1)"
"L1006:"
" movl sp@+,a0"
"L1005:"
" cmpl d1,d3"
" blt L3"
"L4:"
" movl d2,d1"
" jmp a0@"
"L0:"
"|------------------------------------------------------"
"| #[primitive create-y] ="
"L1:"
" bmi L1000"
" TRAP1(9,1)"
" LBL_PTR(L1)"
"L1000:"
" movl d1,a1"
" movl a1@(-3),d2"
" lsrl #7,d2"
" movl a0,sp@-"
" movl d1,sp@-"
" movl d2,sp@-"
" movl d2,d1"
" lea L2,a0"
" dbra d5,L1001"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1001"
" TRAP2(24)"
" RETURN(L1,3,1)"
"L1002:"
"L1001:"
" moveq #-1,d0"
" JMP_PRIM(make-vector,0)"
" RETURN(L1,3,1)"
"L2:"
" movl sp@+,d2"
" subql #8,d2"
" movl d2,d3"
" movl d1,d2"
" movl sp@+,d1"
" movl sp@+,a0"
" dbra d5,L1003"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1003"
" movl a0,sp@-"
" TRAP2(24)"
" RETURN(L1,1,1)"
"L1004:"
" movl sp@+,a0"
"L1003:"
" movl d3,d0"
" blt L4"
"L3:"
" movl d3,d0"
" asrl #1,d0"
" movl d1,a1"
" movl a1@(1,d0:l),d4"
" movl d3,d0"
" asrl #1,d0"
" movl d2,a1"
" movl d4,a1@(1,d0:l)"
" subql #8,d3"
" dbra d5,L1005"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1005"
" movl a0,sp@-"
" TRAP2(24)"
" RETURN(L1,1,1)"
"L1006:"
" movl sp@+,a0"
"L1005:"
" movl d3,d0"
" bge L3"
"L4:"
" movl d2,d1"
" jmp a0@"
"L0:"
"|------------------------------------------------------"
"| #[primitive my-try] ="
"L1:"
" bmi L1000"
" TRAP1(9,1)"
" LBL_PTR(L1)"
"L1000:"
" movl a0,sp@-"
" lea L2,a0"
" dbra d5,L1001"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1001"
" TRAP2(24)"
" RETURN(L1,1,1)"
"L1002:"
"L1001:"
" JMP_PROC(4,10)"
" RETURN(L1,1,1)"
"L2:"
" lea L3,a0"
" JMP_PROC(5,10)"
" RETURN(L1,1,1)"
"L3:"
" movl d1,a1"
" movl a1@(-3),d1"
" lsrl #7,d1"
" dbra d5,L1003"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1003"
" TRAP2(24)"
" RETURN(L1,1,1)"
"L1004:"
"L1003:"
" rts"
"L0:"
"|------------------------------------------------------"
"| #[primitive go] ="
"L1:"
" bmi L1000"
" TRAP1(9,1)"
" LBL_PTR(L1)"
"L1000:"
" moveq #0,d3"
" movl #800,d2"
" dbra d5,L1001"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1001"
" movl a0,sp@-"
" TRAP2(24)"
" RETURN(L1,1,1)"
"L1002:"
" movl sp@+,a0"
"L1001:"
" movl d2,d0"
" ble L4"
" bra L3"
" RETURN(L1,3,1)"
"L2:"
" movl d1,d3"
" movl sp@+,d1"
" subql #8,d1"
" movl d1,d2"
" movl sp@+,d1"
" movl sp@+,a0"
" dbra d5,L1003"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1003"
" movl a0,sp@-"
" TRAP2(24)"
" RETURN(L1,1,1)"
"L1004:"
" movl sp@+,a0"
"L1003:"
" movl d2,d0"
" ble L4"
"L3:"
" movl a0,sp@-"
" movl d1,sp@-"
" movl d2,sp@-"
" lea L2,a0"
" dbra d5,L1005"
" moveq #9,d5"
" cmpl a5@,sp"
" bcc L1005"
" TRAP2(24)"
" RETURN(L1,3,1)"
"L1006:"
"L1005:"
" JMP_PROC(6,10)"
"L4:"
" movl d3,d1"
" jmp a0@"
"L0:"
""))

(define (main . args)
  (run-benchmark
    "compiler"
    compiler-iters
    (lambda (result)
      (equal? result output-expected))
    (lambda (expr target opt) (lambda () (ce expr target opt) (asm-output-get)))
    input-source-code
    'm68000
    'asm))
