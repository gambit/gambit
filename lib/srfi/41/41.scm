;;;============================================================================

;;; File: "41.scm"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 41, Streams.

(##supply-module srfi/41)

(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,

;=========================================================================
; PRIMITIVES
;=========================================================================
; Streams
;
; t stream      :: (promise stream-null)
;               |  (promise (t stream-pair))
;
; t stream-pair :: (promise t) * (promise (t stream))
;

(define-type stream
  id: F9EEE924-9507-4554-8c09-d9bb9411479B
  type-exhibitor: type-stream
  constructor: make-stream
  implementer: implement-type-stream
  opaque:

  (promise  unprintable:)
)

(implement-type-stream)

(define (##fail-check-stream arg-id proc . args)
  (##raise-type-exception
   arg-id
   (type-stream)
   proc
   args))

(define-check-type stream (type-stream)
  stream?)

(define-macro (error-stream proc)
  `(error ,proc "non-stream argument"))

(define-macro (error-stream-null proc)
  `(error ,proc "null-stream argument"))

;;============================================================================

(define-syntax stream-lazy
  (syntax-rules ()
    ((stream-lazy expr)
     (make-stream
       (cons 'lazy (lambda () expr))))))

(define (stream-eager expr)
  (make-stream
    (cons 'eager expr)))

(define-syntax stream-delay
  (syntax-rules ()
    ((stream-delay expr)
     (stream-lazy (stream-eager expr)))))


(define (stream-force promise)
  (let ((content (stream-promise promise)))
    (case (car content)
      ((eager) (cdr content)) 
      ((lazy)  (let* ((promise* ((cdr content)))
                      (content (stream-promise promise)))
                 (if (not (eqv? (car content) 'eager))
                     (begin
                       (set-car! content (car (stream-promise promise*)))
                       (set-cdr! content (cdr (stream-promise promise*)))
                       (stream-promise-set! promise* content)))
                 (stream-force promise))))))

(define stream-null 
  (stream-delay (cons 'stream 'null)))


(define-record-type stream-pair*
                    (make-stream-pair* car* cdr*)
                    stream-pair*?
                    (car* stream-car*)
                    (cdr* stream-cdr*))

(define (stream-null? obj)
  (and (stream? obj)
       (eqv? (stream-force obj)
             (stream-force stream-null))))


(define (stream-pair? obj)
  (and (stream? obj)
       (stream-pair*? (stream-force obj))))

(define-syntax stream-cons
  (syntax-rules ()
    ((stream-cons obj strm)
     (stream-eager (make-stream-pair* (stream-delay obj)
                                      (stream-lazy strm))))))

(define-procedure
  (stream-car (strm stream))
    (if (stream-null? strm)
        (error-stream-null 'stream-car))
        (stream-force (stream-car* (stream-force strm))))

(define-procedure 
  (stream-cdr (strm stream))
    (if (stream-null? strm)
        (error-stream-null 'stream-cdr))
        (stream-cdr* (stream-force strm)))

(define-syntax stream-lambda
  (syntax-rules ()
    ((stream-lambda formals body0 body1 ...)
     (lambda formals (stream-lazy (let () body0 body1 ...))))))

;;=========================================================================
;;=========================================================================
;; Streams derived library
;;=========================================================================

(define (exists proc lst)
  (if (null? lst)
      #f
     (if (proc (car lst))
         #t
         (exists proc (cdr lst)))))

(define (check-streams arg-id name args)
  (fold
    (lambda (strm id)
      (if (stream? strm)
          (+ id 1)
          (apply ##fail-check-stream
                (cons id (cons name args)))))
    1 args))

(define-macro (exists-non-stream? strm)
  `(exists (lambda (x) (not (stream? x))) ,strm))

(define-macro (exists-null-stream? strm)
  `(exists (lambda (x) (stream-null? x)) ,strm))

;;============================================================================
;; define-stream
;;   Create a stream-returning procedure.

(define-syntax define-stream
  (syntax-rules ()
    ((define-stream (name . formal) body0 body1 ...)
     (define name (stream-lambda formal body0 body1 ...)))))

;;=========================================================================
;; stream-let

(define-syntax stream-let
  (syntax-rules ()
    ((stream-let tag ((name val) ...) body0 body1 ...)
     ((letrec ((tag (stream-lambda (name ...) body0 body1 ...))) tag) val ...))))

;;=========================================================================
;; stream
;;   Create a newly-allocated stream from elements.

(define-syntax stream
  (syntax-rules ()
    ((stream) stream-null)
    ((stream e0 e1 ...)
     (stream-cons e0 (stream e1 ...)))))

;;=========================================================================
;; list->stream

(define (list->stream lst)
  (define-stream 
    (list->stream objs)
      (if (null? objs)
          stream-null
          (stream-cons (car objs) (list->stream (cdr objs)))))
  (if (null? lst)
      stream-null
      (macro-check-pair
        lst
        0
        (list->stream lst)
        (list->stream lst))))

;;=========================================================================
;; stream->list

(define (stream->list arg0 #!optional (arg1 (macro-absent-obj)))
  (define-procedure 
    (stream->list (strm stream)
                  (n number -1))
      (let loop ((strm strm) (n n))
          (if (or (stream-null? strm)
                  (zero? n))
              '()
              (cons (stream-car strm)
                    (loop (stream-cdr strm) (- n 1))))))

  (if (equal? arg1 (macro-absent-obj))
      (stream->list arg0)
      (let ((n arg0)
            (strm arg1))
        (if (negative? n)
            (error 'stream->list "negative argument")
            (stream->list strm n)))))

;;=========================================================================
;; port->stream

(define-procedure 
  (port->stream (port input-port (current-input-port)))
    (let loop ((c (read-char port)))
      (if (eof-object? c)
          stream-null
          (stream-cons c (loop (read-char port))))))

;;=========================================================================
;; stream-append

(define (stream-append . strms)
  (define (stream-append n strms)
    (macro-check-stream
      (car strms)
      n
      (stream-append . strms)
      (let loop ((strm strms))
        (cond ((null? (cdr strm))
               (stream-lazy (car strm)))
              ((stream-null? (car strm))
               (let ((res (stream-append (+ n 1) (cdr strm))))
                 (stream-lazy res)))
              (else
                (let ((res (loop (cons 
                                   (stream-cdr (car strm))
                                   (cdr strm)))))

                  (stream-cons (stream-car (car strm))
                               (stream-lazy res))))))))
  (if (null? strms)
       stream-null
    (let ((res (stream-append 1 strms)))
      (stream-lazy res))))

;;=========================================================================
;; stream-concat
;;   Act like stream-append for the elements of the input stream of streams.

(define-procedure 
  (stream-concat (strms stream))
    (if (stream-null? strms)
        stream-null
        (macro-check-stream
          (stream-car strms)
          0
          (stream-concat strms)
          (let loop ((strms strms))
            (if (stream-null? (stream-car strms))
                (let ((res (stream-concat (stream-cdr strms))))
                   (stream-lazy res))
                (let ((res 
                        (loop
                          (stream-cons (stream-cdr (stream-car strms))
                                       (stream-cdr strms)))))
                  (stream-cons (stream-car (stream-car strms))
                               (stream-lazy res))))))))

;;=========================================================================
;; stream-constant
;;   Create a newly-allocated stream containing the
;;   input object sequence, repeating forever.
;;
;;   Ex.: (stream-constant 0 1 2)
;;       => (stream 0 1 2 0 1 2 0 1 2 ...)
;;

(define-stream
  (stream-constant . objs)
    (cond ((null? objs) stream-null)
          ((null? (cdr objs))
           (stream-cons (car objs)
                        (stream-constant (car objs))))
          (else 
           (stream-cons (car objs)
                        (apply stream-constant 
                               (append (cdr objs)
                                       (list (car objs))))))))

;;=========================================================================
;; stream-drop
;;   Return the stream's segment that start
;;   with the (n+1)th elements.

(define-procedure 
  (stream-drop (n    (index-range-incl 0 (macro-max-fixnum32)))
               (strm stream))
    (stream-let loop ((n n)
                      (strm strm))
      (if (or (zero? n) 
              (stream-null? strm))
           strm
           (loop (- n 1) (stream-cdr strm)))))

;;=========================================================================
;; stream-drop-while
;;   Return the stream's segment that start
;;   with the first element for which pred?
;;   return false.

(define-procedure 
  (stream-drop-while (pred? procedure)
                     (strm  stream))
    (stream-let loop ((strm strm))
      (if (and (stream-pair? strm)
               (pred? (stream-car strm)))
          (loop (stream-cdr strm))
          strm)))

;;=========================================================================
;; stream-filter
;;   Return a newly-allocated stream containing every
;;   element of the input stream for which pred? is not #f.

(define-procedure 
  (stream-filter (pred? procedure) 
                 (strm  stream))
    (stream-let loop ((strm strm))
      (cond ((stream-null? strm) 
             stream-null)
            ((pred? (stream-car strm))
             (stream-cons (stream-car strm)
                          (loop (stream-cdr strm))))
            (else (loop (stream-cdr strm))))))

;;=========================================================================
;; stream-fold
;;   Left fold for streams.

(define-procedure
  (stream-fold (proc procedure)
               base
               (strm stream))
    (let loop ((base base) (strm strm))
      (if (stream-null? strm)
          base
          (loop (proc base (stream-car strm))
                (stream-cdr strm)))))

;;=========================================================================
;; stream-for-each

(define (stream-for-each proc strm . strms)
  (define (stream-for-each strms)
    (if (not (exists stream-null? strms))
        (begin (apply proc (map stream-car strms))
               (stream-for-each (map stream-cdr strms)))))
  (macro-force-vars (proc)
    (macro-force-vars (proc)
      (macro-check-procedure
        proc
        0
        (stream-for-each proc strm . strms)
        (let ((strms (cons strm strms)))
          (check-streams 2 'stream-for-each strms)
          (stream-for-each strms))))))

;;=========================================================================
;; stream-from
;;   Generate an infinite stream
;;   with the ith element of the form 
;;   first + i * step.

(define-procedure 
  (stream-from (first number)
               (step  number 1))
  (stream-let loop ((first first))
      (stream-cons first (loop (+ first step)))))

;;=========================================================================
;; stream-iterate
;;   Generate an infinite stream of the form
;;   (stream base (proc base) (proc (proc base)) ...).

(define-procedure 
  (stream-iterate (proc procedure) 
                  base)
    (stream-let loop ((base base))
        (stream-cons base (loop (proc base)))))

;;=========================================================================
;; stream-length

(define-procedure 
  (stream-length (strm stream))
    (let loop ((len 0) (strm strm))
      (if (stream-null? strm)
          len
          (loop (+ len 1)
                (stream-cdr strm)))))

;;=========================================================================
;; stream-map

(define (stream-map proc strm . strms)
  (define-stream
    (stream-map strms)
      (if (exists stream-null? strms)
          stream-null
          (stream-cons (apply proc (map stream-car strms))
                       (stream-map (map stream-cdr strms)))))
  (macro-force-vars (proc)
    (macro-check-procedure
      proc
      1
      (stream-map proc strm . strms)
      (let ((strms (cons strm strms)))
        (check-streams 2 'stream-map strms)
        (stream-map strms)))))

;;=========================================================================
;; stream-match
;;   Pattern matching for streams.
;;
;; Clauses are of the form
;;   (pattern [fender] expr)
;;
;; Each pattern can be of one of the following forms:
;; 
;; - ()                      -> Matches null-stream
;; - (patt0 patt1 ...)       -> Match finite stream 
;;                                of exact length
;; - (patt0 patt1 ... . rst) -> Match infinite stream 
;;                                or finite with 
;;                                length >= 2
;; - patt                    -> Match the entire stream
;;
;; Pattern's elements can be 
;; - identifier  (to which the value become bound)
;; - wildcard '_'
;;
;; Fenders can be use and can use the value bound by the
;; pattern's identifiers. If the fender evaluate to #f the match
;; fail.
;;
;; Ex.:
;;      (stream-match strm
;;        ((x y . _) (equal? x y) 'match!)
;;        (else 'error))
;;
;;((where else is an identifier and not a keyword))
;;

(define-syntax stream-match
  (syntax-rules ()
    ((stream-match strm-expr clause ...)
     (let ((strm strm-expr))
       (cond ((not (stream? strm))
              (error-stream 'stream-match))
             ((stream-match-test strm clause) => car)
                 ...
              (error 'stream-match "pattern failure"))))))

(define-syntax stream-match-test
  (syntax-rules ()
    ((stream-match-test strm (pattern fender expr))
     (stream-match-pattern strm pattern () (and fender (list expr))))
    ((stream-match-test strm (pattern expr))
     (stream-match-pattern strm pattern () (list expr)))))


(define-syntax stream-match-pattern
  (syntax-rules (_)
    ((stream-match-pattern strm () (binding ...) body)
     (and (stream-null? strm)
          (let (binding ...)
            body)))

    ((stream-match-pattern strm (_ . rest) (binding ...) body)
     (and (stream-pair? strm)
          (let ((strm (stream-cdr strm)))
            (stream-match-pattern strm rest (binding ...) body))))

    ((stream-match-pattern strm (var . rest) (binding ...) body)
     (and (stream-pair? strm)
          (stream-match-pattern (stream-cdr strm) rest ((var (stream-car strm)) binding ...) body)))

    ((stream-match-pattern strm _ (binding ...) body)
     (let (binding ...)
       body))

    ((stream-match-pattern strm var (binding ...) body)
     (let ((var strm) binding ...)
       body))))

;;=========================================================================
;; stream-of
;;   Syntax for stream comprehension.
;;   Generate a stream element by element.
;;
;; (stream-of expr
;;  clause0
;;  clause1
;;  ... )
;;
;; Clauses are of the form
;; - (var in stream-expr) -> Loop over the element of
;;                           stream-expr, binding them
;;                           to var, sequentially.
;; - (var is expr)        -> bind var to the value obtained
;;                           by evaluation of expr.
;; - (pred? expr)         -> discard element expr, for which
;;                           the predicate evaluate to #f,
;;                           from the output stream.
;;
;; The output stream is generated by
;; applying expr over the values bound by "var"
;; and evaluation of the predicate clauses.
;; 
;; Ex.:
;;
;;      (stream-of (* x x)
;;        (x in (stream-range 0 10))
;;        (even? x))
;;      => (stream 0 4 16 36 64)
;;      
;;      (stream-of (list a b)
;;        (a in (stream-range 1 4))
;;        (b in (stream-range 1 3)))
;;      => (stream (1 1) (1 2) (2 1) (2 2) (3 1) (3 2))
;;

(define-syntax stream-of-aux
  (syntax-rules (in is)
    ((stream-of-aux expr base)
     (stream-cons expr base))
    ((stream-of-aux expr base (var in stream) rest ...)
     (stream-let loop ((strm stream))
       (if (stream-null? strm)
           base
           (let ((var (stream-car strm)))
             (stream-of-aux expr
                            (loop (stream-cdr strm)) 
                            rest 
                            ...)))))
    ((stream-of-aux expr base (var is exp) rest ...)
     (let ((var exp)) 
       (stream-of-aux expr base rest ...)))
    ((stream-of-aux expr base pred? rest ...)
     (if pred? 
         (stream-of-aux expr base rest ...) 
         base))))

(define-syntax stream-of
  (syntax-rules ()
    ((_ expr rest ...)
     (stream-of-aux expr stream-null rest ...))))

;;=========================================================================
;; stream-range
;;   Generate a stream of finite length.

(define (stream-range first past #!optional (step (macro-absent-obj)))
    (define-stream
      (stream-range first past delta lt?)
        (if (lt? first past)
            (stream-cons first
                         (stream-range (+ first delta)
                                       past 
                                       delta 
                                       lt?))
            stream-null))

    (macro-force-vars (first past)
      (macro-check-number
        first 0
        (stream-range first past step)
      (macro-check-number
        past 1
        (stream-range first past step)
      (let ((delta (if (eq? step (macro-absent-obj))
                       (if (< first past) 1 -1)
                       (macro-force-vars (step)
                         (macro-check-number
                           step 2
                           (stream-range first past step)
                           (if (or (and (> past first)
                                        (negative? step))
                                   (and (< past first)
                                        (positive? step)))
                               (##raise-range-exception 
                                 2 
                                 'stream-range first past step)
                               step))))))
        (stream-range first 
                      past 
                      delta
                      (if (< 0 delta) < >)))))))

;;=========================================================================
;; stream-ref

(define-procedure
  (stream-ref (strm stream)
              (n    (index-range-incl 0 (macro-max-fixnum32))))
    (let loop ((strm strm) (n n))
      (cond ((stream-null? strm)
             (##raise-range-exception 2 'stream-ref strm n))
            ((zero? n) 
             (stream-car strm))
            (else (loop (stream-cdr strm) (- n 1))))))

;;=========================================================================
;; stream-reverse

(define-procedure 
  (stream-reverse (strm stream))
    (stream-let loop ((strm strm)
                      (acc  stream-null))
        (if (stream-null? strm)
            acc
            (loop (stream-cdr strm)
                  (stream-cons (stream-car strm)
                               acc)))))

;;=========================================================================
;; stream-scan
;;   accumulate the partial folds over an input stream into
;;   a newly-allocated output stream
;;
;; The output stream is `base` folowed by
;; (stream-fold proc base (stream-take i stream)))
;; for each element i > 0.
;; 

(define-procedure
  (stream-scan (proc procedure)
               base
               (strm stream))
    (stream-let loop ((base base)
                      (strm strm))
        (if (stream-null? strm)
            (stream base)
            (stream-cons base
                         (loop (proc base 
                                     (stream-car strm))
                               (stream-cdr strm))))))

;;=========================================================================
;; stream-take
;;   Return a newly-allocated stream containings the n first 
;;   elements of the input stream.

(define-procedure
  (stream-take (n  (index-range-incl 
                     0 (macro-max-fixnum32)))
               (strm stream))

    (stream-let loop ((n n)
                      (strm strm))
        (if (or (stream-null? strm)
                (zero? n))
            stream-null
            (stream-cons (stream-car strm)
                         (loop (- n 1)
                               (stream-cdr strm))))))

;;=========================================================================
;; stream-take-while
;;   Return a newly-allocated stream containing
;;   every element occuring before the first element
;;   for which pred? is #f.

(define-procedure
  (stream-take-while (pred? procedure)
                     (strm  stream))
  (stream-let loop ((strm strm))
      (cond ((stream-null? strm)
             stream-null)
            ((pred? (stream-car strm))
             (stream-cons (stream-car strm)
                          (loop (stream-cdr strm))))
            (else stream-null))))

;;=========================================================================
;; stream-unfold
;;   Generate a stream recursively.
;;   
;; For every element of (stream-iterate base generator)
;; (mapper element) appear in the output stream if 
;; the predicate applied to the mapped element
;; evaluate to a non-#f value.
;;
;; Ex.:
;;      (stream-unfold
;;        (lambda (x) (* 2 x)) ; map
;;        (lambda (x) (< x 5)) ; pred?
;;        (lambda (x) (+ 2 x)) ; gen
;;        0)                   ; base
;;      => (stream-filter 
;;           (stream-map `map` 
;;             (stream-iterate `gen` `base`))
;;           `pred?`)
;;      => (0 4)
;;

(define-procedure
  (stream-unfold (mapper    procedure)
                 (pred?     procedure)
                 (generator procedure)
                 base)
  (stream-let loop ((base base))
      (if (pred? base)
          (stream-cons (mapper base)
                       (loop (generator base)))
          stream-null)))

;;=========================================================================
;; stream-unfolds
;;   Return n newly allocated streams
;;   containing the elements produced by successive calls
;;   to the generator `proc`.
;;   The procedure returns n value + 1 seed value to be used
;;   as seed for the next call to the generator.
;;
;;   The ith (non-seed) value returned by the generator is
;;   - (value) -> the next value in the output stream
;;   - #f      -> indicate that no output value was produced by
;;                this iteration.
;;   - ()      -> indicate the end of the result stream.
;;

(define-procedure
  (stream-unfolds (gen procedure)
                  seed)

  (define (len-values gen seed)
    (call-with-values (lambda () (gen seed))
                      (lambda vs (- (length vs) 1))))
  (define-stream 
    (unfold-result-stream gen seed)
      (call-with-values (lambda () (gen seed))
                        (lambda (next . results)
                          (stream-cons results 
                                       (unfold-result-stream gen 
                                                             next)))))
  (define-stream
    (result-stream->output-stream result-stream i)
      (let ((result (list-ref (stream-car result-stream)
                              (- i 1))))
        (cond ((pair? result)
               (stream-cons (car result)
                            (result-stream->output-stream (stream-cdr result-stream)
                                                          i)))
              ((not result)
               (result-stream->output-stream (stream-cdr result-stream)
                                             i))
              ((null? result)
               stream-null)
              (else (error 'stream-unfolds "failed")))))

  (define (result-stream->output-streams result-stream)
    (let loop ((i (len-values gen seed)) (outputs '()))
      (if (zero? i)
          (apply values outputs)
          (loop (- i 1) (cons (result-stream->output-stream result-stream
                                                            i)
                              outputs)))))
  (result-stream->output-streams (unfold-result-stream gen seed)))

;;=========================================================================
;; stream-zip

(define (stream-zip strm . strms)
  (define-stream 
    (stream-zip strms)
      (if (exists stream-null? strms)
          stream-null
          (stream-cons (map stream-car strms)
                       (stream-zip (map stream-cdr strms)))))

  (let ((strms (cons strm strms)))
    (check-streams 1 'stream-zip strms)
    (stream-zip strms)))

;;============================================================================
