;;; WC -- One of the Kernighan and Van Wyk benchmarks.

(define inport #f)

(define nl #f)
(define nw #f)
(define nc #f)
(define inword #f)

(define (wcport port)
  (let ((x (read-char port)))
    (if (eof-object? x)
        (begin
          (list nl nw nc))
        (begin
          (set! nc (+ nc 1))
          (if (char=? x #\newline)
              (set! nl (+ nl 1)))
          (if (or (char=? x #\space)
                  (char=? x #\newline))
              (set! inword #f)
              (if (not inword)
                  (begin
                    (set! nw (+ nw 1))
                    (set! inword #t))))
          (wcport port)))))

(define (go)
  (set! inport (open-input-file "../../src/bib"))
  (set! nl 0)
  (set! nw 0)
  (set! nc 0)
  (set! inword #f)
  (let ((result (wcport inport)))
    (close-input-port inport)
    result))
 
(define (main . args)
  (run-benchmark
   "wc"
   wc-iters
   (lambda (result) (equal? result '(31102 851820 4460056)))
   (lambda () (lambda () (go)))))
