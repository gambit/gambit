(load "all-results.scm")

(define systems
  (map car all-results))

(define benchmarks
  (map car (cdr (car all-results))))

(define non-schemes '(GCC))

(define (iota n)
  (let loop ((i 0))
    (if (< i n)
        (cons i (loop (+ i 1)))
        '())))

(define (keep keep? lst)
  (cond ((null? lst)       '())
        ((keep? (car lst)) (cons (car lst) (keep keep? (cdr lst))))
        (else              (keep keep? (cdr lst)))))

(define (every? pred? lst)
  (or (null? lst)
      (and (pred? (car lst))
           (every? pred? (cdr lst)))))

(define (p arg)
  (cond ((null? arg))
        ((pair? arg)
         (p (car arg))
         (p (cdr arg)))
        (else
         (display arg))))

(define (format-real x decimals)
  (let* ((divisor (expt 10 decimals))
         (n (inexact->exact (round (* 100. x)))))
    (string-append (number->string (quotient n divisor))
                   "."
                   (substring (number->string
                               (+ divisor (modulo n divisor)))
                              1
                              (+ decimals 1)))))

(define (wrap before after)
  (lambda (args)
    (list before args after)))

(define table (wrap "<table>\n" "</table>\n"))
(define tr-head (wrap "<tr>\n" "</tr>\n"))
(define tr-odd (wrap "<tr bgcolor=\"#eeeeee\">\n" "</tr>\n"))
(define tr-even (wrap "<tr bgcolor=\"#dddddd\">\n" "</tr>\n"))
(define td (wrap "<td>\n" "</td>\n"))
(define td-left (wrap "<td align=\"left\">\n" "</td>\n"))
(define td-center (wrap "<td align=\"center\">\n" "</td>\n"))
(define td-right (wrap "<td align=\"right\">\n" "</td>\n"))
(define td-best (wrap "<td align=\"center\" bgcolor=\"#80f080\">\n" "</td>\n"))
(define td-head (wrap "<td colspan=\"1\" align=\"center\">\n" "</td>\n"))
(define code (wrap "<code>\n" "</code>\n"))
(define b (wrap "<b>\n" "</b>\n"))
(define i (wrap "<i>\n" "</i>\n"))
(define line (wrap "" "\n"))

(define (extract-times bench cpu? results)
  (map (lambda (sys)
         (let ((r (assq bench (cdr sys))))
           (cond ((>= (length r) 3)
                  (if cpu? (cadr r) (caddr r)))
                 ((= (length r) 2)
                  (cadr r))
                 (else
                  '()))))
       results))

(define (gen cpu?)
  (table
   (map (lambda (j x)
          ((cond ((= j 0) tr-head)
                 ((odd? j) tr-odd)
                 (else tr-even))
           x))
        (iota (+ 1 (length benchmarks)))
        (cons (map td-head (cons "Program&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" systems))
              (map (lambda (bench)
                     (let* ((scheme-times
                             (extract-times
                              bench
                              cpu?
                              (keep (lambda (x) (not (memq (car x) non-schemes)))
                                    all-results)))
                            (times
                             (extract-times bench cpu? all-results))
                            (num-times
                             (keep number? scheme-times))
                            (best-time
                             (if (null? num-times) 0 (apply min num-times))))
                       (cons (td (line (code bench)))
                             (map (lambda (sys t)
                                    (cond ((number? t)
                                           (if (and (= t best-time)
                                                    (not (memq (car sys)
                                                               non-schemes)))
                                               (td-best (line (i t)))
                                               (td-right (line (if (= best-time 0)
                                                                   "inf"
                                                                   (format-real (/ t best-time) 2))))))
                                          ((null? t)
                                           (td-center (line "")))
                                          (else
                                           (td-center (line t)))))
                                  all-results
                                  times))))
                   benchmarks)))))

(define (generate-table)
  (p
   (list
    "The following tables contain the execution time of the Gambit benchmarks"
    " on various implementations of Scheme.  For a given benchmark, the"
    " entry in green indicates which Scheme system has the fastest execution"
    " and the number given is the time in milliseconds.  Other entries"
    " give the execution time relative to the green entry.  Blank entries"
    " indicate that this benchmark was not executed (possibly because the"
    " system did not accept to compile the program)."
    "<br>"
    "<br>"
    "The first table gives CPU time and the second gives real time."
    "<h1>CPU time</h1>"
    (gen #t)
    "<h1>Real time</h1>"
    (gen #f))))

(with-output-to-file
    "bench.html"
  generate-table)
