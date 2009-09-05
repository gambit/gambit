#!/usr/bin/env gsi-script

(let ()

(define shell-prompt "$ ")
(define scheme-prompt "> ")
(define scheme-prompt1 "1> ")
(define scheme-prompt2 "2> ")
(define scheme-prompt3 "3> ")

(define os-name
  (let ((p (open-process "uname")))
    (let ((name (read-line p)))
      (close-port p)
      name)))

(define r5rs-standard-procedures '(

; r4rs

*
+
-
/
<
<=
=
>
>=
abs
acos
angle
append
apply
asin
assoc
assq
assv
atan
boolean?
caaaar
caaadr
caaar
caadar
caaddr
caadr
caar
cadaar
cadadr
cadar
caddar
cadddr
caddr
cadr
call-with-current-continuation
call-with-input-file
call-with-output-file
car
cdaaar
cdaadr
cdaar
cdadar
cdaddr
cdadr
cdar
cddaar
cddadr
cddar
cdddar
cddddr
cdddr
cddr
cdr
ceiling
char->integer
char-alphabetic?
char-ci<=?
char-ci<?
char-ci=?
char-ci>=?
char-ci>?
char-downcase
char-lower-case?
char-numeric?
char-ready?
char-upcase
char-upper-case?
char-whitespace?
char<=?
char<?
char=?
char>=?
char>?
char?
close-input-port
close-output-port
complex?
cons
cos
current-input-port
current-output-port
denominator
display
eof-object?
eq?
equal?
eqv?
even?
exact->inexact
exact?
exp
expt
floor
for-each
force
gcd
imag-part
inexact->exact
inexact?
input-port?
integer->char
integer?
lcm
length
list
list->string
list->vector
list-ref
list-tail
list?
load
log
magnitude
make-polar
make-rectangular
make-string
make-vector
map
max
member
memq
memv
min
modulo
negative?
newline
not
null?
number->string
number?
numerator
odd?
open-input-file
open-output-file
output-port?
pair?
peek-char
positive?
procedure?
quotient
rational?
rationalize
read
read-char
real-part
real?
remainder
reverse
round
set-car!
set-cdr!
sin
sqrt
string
string->list
string->number
string->symbol
string-append
string-ci<=?
string-ci<?
string-ci=?
string-ci>=?
string-ci>?
string-copy
string-fill!
string-length
string-ref
string-set!
string<=?
string<?
string=?
string>=?
string>?
string?
substring
symbol->string
symbol?
tan
transcript-off
transcript-on
truncate
vector
vector->list
vector-fill!
vector-length
vector-ref
vector-set!
vector?
with-input-from-file
with-output-to-file
write
write-char
zero?

; r5rs

call-with-values
dynamic-wind
eval
interaction-environment
null-environment
scheme-report-environment
values
))

(define (all-symbols)

  (define (symbol-next x)
    (##vector-ref x 2))

  (define (f x)
    (if (symbol? x)
        (cons x
              (f (symbol-next x)))
        '()))

  (apply append (map f (cdr (vector->list (##symbol-table))))))

(define (global? x)
  (not (##unbound? (##global-var-ref (##make-global-var x)))))

(define (exported-procedure? sym)
  (and (> (string-length (symbol->string sym)) 2)
       (and (not (string=? "##" (substring (symbol->string sym) 0 2)))
            (not (string=? " " (substring (symbol->string sym) 0 1))))
       (procedure? (##global-var-ref (##make-global-var sym)))))

(define (keep keep? lst)
  (cond ((null? lst)       '())
        ((keep? (car lst)) (cons (car lst) (keep keep? (cdr lst))))
        (else              (keep keep? (cdr lst)))))

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

(define (sort-syms lst)
  (sort-list lst
             (lambda (x y) (string<? (symbol->string x) (symbol->string y)))))

'
(begin
(for-each
 (lambda (sym)
   (if (and (exported-procedure? sym)
            (not (memq sym r5rs-standard-procedures)))
       (pp sym)))
 (sort-syms (all-symbols)))
(exit))

(let ()

(define exported-procedures
  (sort-syms (keep exported-procedure? (all-symbols))))

(define (extract-deffn lines)
  (map
   extract-deffn-head
   (extract-groups
    lines
    (lambda (line) (prefix? "@deffn " line))
    (lambda (line) (prefix? "@end deffn" line)))))

(define (extract-groups lines begin? end?)
  (let loop1 ((lines lines)
              (rev-groups '()))
    (cond ((null? lines)
           (reverse rev-groups))
          ((begin? (car lines))
           (let loop2 ((lines (cdr lines))
                       (rev-gr (list (car lines))))
             (cond ((null? lines)
                    (display "*** WARNING: unterminated group\n")
                    (reverse rev-groups))
                   ((end? (car lines))
                    (loop1 (cdr lines)
                           (cons (reverse (cons (car lines) rev-gr))
                                 rev-groups)))
                   (else
                    (loop2 (cdr lines)
                           (cons (car lines) rev-gr))))))
          (else
           (loop1 (cdr lines) rev-groups)))))

(define (extract-deffn-head deffn-lines)
  (let loop1 ((lines deffn-lines) (rev-head '()))
    (cond ((and (not (null? lines))
                (prefix? "@deffn" (car lines)))
           (let ((words (split-at-spaces (car lines))))
             (if (< (length words) 3)
                 (error "ill-formed deffn")
                 (let ((deffn-key (car words))
                       (a (cadr words))
                       (b (caddr words)))
                   (loop1 (cdr lines)
                          (cons (if (and (string=? a "{special")
                                         (string=? b "form}"))
                                    (list (string->symbol (cadddr words))
                                          (string-append a " " b)
                                          (car lines))
                                    (list (string->symbol b)
                                          a
                                          (car lines)))
                                rev-head))))))
          (else
           (cons (reverse rev-head)
                 lines)))))

(define (prefix? str1 str2)
  (here? str1 str2 0))

(define (suffix? str1 str2)
  (here? str1 str2 (- (string-length str2) (string-length str1))))

(define (here? str1 str2 pos)
  (let ((len1 (string-length str1))
        (len2 (string-length str2)))
    (and (<= (+ pos len1) len2)
         (string=? str1 (substring str2 pos (+ pos len1))))))

(define (every? pred? lst)
  (or (null? lst)
      (and (pred? (car lst))
           (every? pred? (cdr lst)))))

(define (any? pred? lst)
  (and (not (null? lst))
       (or (pred? (car lst))
           (any? pred? (cdr lst)))))

(define (find pred? lst)
  (cond ((null? lst)
         #f)
        ((pred? (car lst)))
        (else
         (find pred? (cdr lst)))))

(define (split-at-spaces str)
  (with-input-from-string str
    (lambda ()
      (read-all (current-input-port)
                (lambda (p) (read-line p #\space))))))

(define (check-missing-procedures doc-lines out)
  (let ((deffns
          (extract-deffn doc-lines)))

    (define (procedure-documented? sym)
      (let ((d
             (find
              (lambda (deffn)
                (find
                 (lambda (head)
                   (if (eq? (car head) sym)
                       (cons head deffn)
                       #f))
                 (car deffn)))
              deffns)))
        (cond ((not d)
               #f)
              (else
               (let ((head
                      (car d))
                     (deffn
                       (cdr d)))
                 (if (not (string=? (cadr head) "procedure"))
                     (print "*** WARNING: " sym " is not defined as a procedure\n"))
                 #t)))))

    (define (check-documented sym)
      (if (not (memq sym r5rs-standard-procedures))
          (if (not (procedure-documented? sym))
              (let ((name (symbol->string sym)))
                (print
                 port: out
                 "\n"
                 "@deffn procedure " name "\n"
                 "@end deffn\n")))))

    (define (check-that-exported-procedures-are-documented)
      (for-each check-documented exported-procedures))

    (check-that-exported-procedures-are-documented)))

(define os-name-prefix
  (string-append "\n" os-name " "))

(define (exec inputs)
  (let ((p
         (open-process
          (list path: "bash"
                arguments: '()
                pseudo-terminal: #t
                eol-encoding: 'cr-lf
                buffering: #t)))
        (rev-output
         '()))

    (define (recv)
      (recv-timeout 10))

    (define (recv-timeout max-wait-after-newline)

      (define max-wait-before-newline .1)
      (define max-idle-time .1)

      (input-port-timeout-set! p max-wait-before-newline)
      (let loop1 ((rev-output '()))
        (let ((c (read-char p)))
          (if (and (char? c) (not (char=? c #\newline)))
              (begin
;                (write-char c)
                (input-port-timeout-set! p max-idle-time)
                (loop1 (cons c rev-output)))
              (begin
                (input-port-timeout-set! p max-wait-after-newline)
                (let loop2 ((rev-output
                             (if (char? c)
                                 (cons c rev-output)
                                 rev-output)))
                  (let ((c (read-char p)))
                    (if (char? c)
                        (begin
;                          (write-char c)
                          (input-port-timeout-set! p max-idle-time)
                          (loop2 (cons c rev-output)))
                        rev-output))))))))

    (define (send input)
      (let ((input-text
             (plain-text input)))
        (display (string-append input-text "\n") p)
        (force-output p)
        (let* ((rev-last-output
                (recv))
               (last-output
                (clean-up (list->string (reverse rev-last-output))))
               (expect
                (string-append input-text "\n")))
          (set! rev-output
                (cons (string-append
                       "\n"
                       (if (prefix? expect last-output)
                           (substring last-output
                                      (string-length expect)
                                      (string-length last-output))
                           last-output))
                      (cons input
                            rev-output))))))

    (display (string-append "PS1=\"" shell-prompt "\"\n") p)
    (display "export C_INCLUDE_PATH=../include\n" p)
    (display "export LIBRARY_PATH=../lib\n" p)
    (force-output p)

    (recv-timeout .1)

    (set! rev-output (list shell-prompt))

    (for-each send inputs)

    (let ((output (reverse rev-output)))
      (close-port p)
      output)))

(define (parse-info body)

  (define (parse rev-accum start i cont)

    (define (add)
      (if (< start i)
          (cons (substring body start i)
                rev-accum)
          rev-accum))

    (if (< i (string-length body))
        (let ((c (string-ref body i)))
          (cond ((char=? c #\})
                 (cont (reverse (add))
                       i))
                ((and (< (+ i 1) (string-length body))
                      (char=? c #\@))
                 (let ((first (string-ref body (+ i 1))))
                   (if (memv first '(#\@ #\{ #\}))
                       (parse (add)
                              (+ i 1)
                              (+ i 2)
                              cont)
                       (let loop ((j (+ i 2)))
                         (if (and (< j (string-length body))
                                  (char-alphabetic?
                                   (string-ref body j)))
                             (loop (+ j 1))
                             (let ((key (substring body (+ i 1) j)))
                               (if (and (< j (string-length body))
                                        (char=? (string-ref body j)
                                                #\{))
                                   (parse (list (string->symbol key))
                                          (+ j 1)
                                          (+ j 1)
                                          (lambda (tree i)
                                            (if (and (< i (string-length body))
                                                     (char=?
                                                      (string-ref body i)
                                                      #\}))
                                                (parse (cons tree
                                                             (add))
                                                       (+ i 1)
                                                       (+ i 1)
                                                       cont)
                                                (error "} expected"))))
                                   (error "{ expected"))))))))
                (else
                 (parse rev-accum start (+ i 1) cont))))
        (cont (reverse (add))
              i)))

  (parse '()
         0
         0
         (lambda (tree i)
           (if (= i (string-length body))
               tree
               (error "syntax error")))))

(define (replace expr replacement)
  (lambda (str pos cont)
    (let loop ((i 0) (j pos))
      (if (< i (string-length expr))
          (if (and (< j (string-length str))
                   (let ((x (string-ref expr i))
                         (c (string-ref str j)))
                     (cond ((or (char=? x #\*) (char=? x #\?))
                            (error "misplaced * or ?"))
                           ((char=? x #\#)
                            (char-numeric? c))
                           (else
                            (char=? x c)))))
              (loop (cond ((and (< (+ i 1) (string-length expr))
                                (char=? (string-ref expr (+ i 1)) #\*))
                           i)
                          ((and (< (+ i 1) (string-length expr))
                                (char=? (string-ref expr (+ i 1)) #\?))
                           (+ i 2))
                          (else
                           (+ i 1)))
                    (+ j 1))
              (cond ((and (< (+ i 1) (string-length expr))
                          (char=? (string-ref expr (+ i 1)) #\*))
                     (loop (+ i 2)
                           j))
                    ((and (< (+ i 1) (string-length expr))
                          (char=? (string-ref expr (+ i 1)) #\?))
                     (loop (+ i 2)
                           j))
                    (else
                     (cont str pos #f))))
          (cont str j replacement)))))

(define (either2 t1 t2)
  (lambda (str pos cont)
    (t1 str
        pos
        (lambda (str new-pos replacement)
          (if replacement
              (cont str new-pos replacement)
              (t2 str
                  pos
                  cont))))))

(define (either transformers)
  (if (null? transformers)
      (lambda (str pos cont)
        (cont str pos #f))
      (either2 (car transformers)
               (either (cdr transformers)))))

(define (transform str transformer)
  (let loop ((i 0) (j 0) (rev-result '()))
    (if (< j (string-length str))
        (transformer
         str
         j
         (lambda (str new-pos replacement)
           (if replacement
               (loop new-pos
                     new-pos
                     (if (< i j)
                         (cons replacement
                               (cons (substring str i j)
                                     rev-result))
                         (cons replacement
                               rev-result)))
               (loop i
                     (+ j 1)
                     rev-result))))
        (apply string-append
               (reverse
                (if (< i j)
                    (cons (substring str i j) rev-result)
                    rev-result))))))

(define (clean-up str)
  (transform
   str
   (either
    (list (replace "gsi(##*) malloc:" "gsi(29744) malloc:")
          (replace "\33[#*A" "")
          (replace "\33[#*A" "")
          (replace "\33[#*B" "")
          (replace "\33[#*C" "")
          (replace "\33[#*D" "")
          (replace "\33[46m" "")
          (replace "\33[1m" "")
          (replace "\33[m" "")))))

(define (plain-text tree)
  (cond ((string? tree)
         tree)
        ((pair? tree)
         (apply string-append
                (map plain-text (cdr tree))))
        (else
         (error "unknown info tree node"))))

(define (display-info tree)
  (cond ((string? tree)
         (let loop ((i 0))
           (if (< i (string-length tree))
               (let ((c (string-ref tree i)))
                 (cond ((char=? c #\@)
                        (display "@@"))
                       ((char=? c #\{)
                        (display "@{"))
                       ((char=? c #\})
                        (display "@}"))
                       (else
                        (display c)))
                 (loop (+ i 1))))))
        ((pair? tree)
         (display "@")
         (display (car tree))
         (display "{")
         (for-each display-info (cdr tree))
         (display "}"))
        (else
         (error "unknown info tree node"))))

(define (remove-trailing-prompt str)

  (define (remove prompt)
    (if (suffix? prompt str)
        (substring str
                   0
                   (- (string-length str) (string-length prompt)))
        #f))

  (or (remove scheme-prompt1)
      (remove scheme-prompt2)
      (remove scheme-prompt3)
      (remove scheme-prompt)
      (remove shell-prompt)
      str))

(define (check-example info)
  (let* ((tree
          (parse-info info))
         (type
'no-execute #;
          (cond ((equal? (car tree) shell-prompt)
                 'shell)
                ((equal? (car tree) scheme-prompt)
                 'scheme)
                ((and (pair? (car tree))
                      (equal? (car (car tree)) 'b))
                 'no-execute)
                (else
                 'unknown)))
         (same-os?
          (or (not (eq? type 'shell))
              (not (pair? (cdr tree)))
              (not (equal? (cadr tree) '(b "uname -srmp")))
              (not (pair? (cddr tree)))
              (not (string? (caddr tree)))
              (prefix? os-name-prefix (caddr tree)))))
    (cond ((and same-os?
                (memq type '(shell scheme)))
           (let* ((raw-inputs
                   (keep (lambda (x) (and (pair? x) (eq? (car x) 'b))) tree))
                  (inputs
                   (if (eq? type 'scheme)
                       (append '("gsi -:h4000") raw-inputs)
                       raw-inputs))
                  (raw-output
                   (exec inputs))
                  (output
                   (if (eq? type 'scheme)
                       (cons scheme-prompt (cdddr raw-output))
                       raw-output))
                  (output-str
                   (remove-trailing-prompt
                    (with-output-to-string
                      ""
                      (lambda ()
                        (for-each display-info output))))))
             output-str))
          ((eq? type 'no-execute)
           info)
          (else
           (display "---------------------------------- WARNING, example skipped:\n")
           (display info)
           info))))

(define (check-doc filename)
  (let ((doc-lines
         (with-input-from-file
             filename
           (lambda ()
             (read-all (current-input-port) read-line)))))

    (define (addnl s)
      (string-append s "\n"))

    (let* ((out (open-output-file (string-append filename "-correct"))))
      (let loop1 ((lines doc-lines))
        (if (null? lines)
            (close-output-port out)
            (let ((x (car lines)))
              (cond ((member x
                             '("@example"
                               "@smallexample"))
                     (let ((end
                            (string-append "@end "
                                           (substring x 1 (string-length x)))))
                       (let loop2 ((lines (cdr lines)) (lst '()))
                         (let ((y (car lines)))
                           (if (equal? y end)
                               (let* ((info
                                       (apply string-append
                                              (map addnl (reverse lst))))
                                      (correct-example
                                       (check-example info)))
                                 (display x out)
                                 (display "\n" out)
                                 (display correct-example out)
                                 (display end out)
                                 (display "\n" out)
                                 (loop1 (cdr lines)))
                               (loop2 (cdr lines) (cons y lst)))))))
                    (else
                     (display x out)
                     (display "\n" out)
                     (if (equal? x "The procedures in this section are not yet documented.")
                         (check-missing-procedures doc-lines out))
                     (loop1 (cdr lines))))))))))

(check-doc "gambit-c.txi")

))
