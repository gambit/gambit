;;;============================================================================

;;; File: "48.scm"

;;; Copyright (c) 2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 48, Intermediate Format Strings

(##supply-module srfi/48)

(##namespace ("srfi/48#"))                ;; in srfi/48#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,
                                          ;; macro-absent-obj, etc

(##include "48#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;============================================================================

(define-procedure (format . args)

;; Below is the reference implementation in SRFI 48 spec by Ken Dickey
;; modified to avoid using apply.

(define-macro (write-with-shared-structure obj port)
  `(write-shared ,obj ,port))

;; IMPLEMENTATION DEPENDENT options

(define ascii-tab   #\tab)
(define dont-print  #!void)

;; Following three procedures are used by format ~F .
;; 'inexact-number->string' determines whether output is fixed-point
;; notation or exponential notation. In the current definition,
;; the notation depends on the implementation of 'number->string'.
;; 'exact-number->string' is expected to output only numeric characters
;; (not including such as '#', 'e', '.', '/') if the input is an positive
;; integer or zero.
;; 'real-number->string' is used when the digits of ~F is not specified.
(define (inexact-number->string x) (number->string (exact->inexact x)))
(define (exact-number->string x)   (number->string (inexact->exact x)))
(define (real-number->string x)    (number->string x))

;; FORMAT
(define (format* args)
  (cond
   ((null? args)
    (error "FORMAT: required format-string argument is missing")
    )
   ((string? (car args))
    (format* (cons #f args)))
   ((< (length args) 2)
    (error (format* (list "FORMAT: too few arguments ~s" (cons 'format args))))
    )
   (else
    (let ( (output-port   (car  args))
           (format-string (cadr args))
           (args          (cddr args))
         )
      (letrec ( (port
                 (cond ((output-port? output-port) output-port)
                       ((eq? output-port #t) (current-output-port))
                       ((eq? output-port #f) (open-output-string))
                       (else (error
                              (format* (list "FORMAT: bad output-port argument: ~s"
                                             output-port))))
                ) )
                (return-value
                 (if (eq? output-port #f)    ;; if format into a string
                     (lambda () (get-output-string port)) ;; then return the string
                     (lambda () dont-print)) ;; else do something harmless
                 )
             )

         (define (string-index str c)
           (let ( (len (string-length str)) )
             (let loop ( (i 0) )
               (cond ((= i len) #f)
                     ((eqv? c (string-ref str i)) i)
                     (else (loop (+ i 1)))))))

         (define (string-grow str len char)
           (let ( (off (- len (string-length str))) )
             (if (positive? off)
               (string-append (make-string off char) str)
               str)))

         (define (compose-with-digits digits pre-str frac-str exp-str)
           (let ( (frac-len (string-length frac-str)) )
             (cond
              ((< frac-len digits) ;; grow frac part, pad with zeros
               (string-append pre-str "."
                              frac-str (make-string (- digits frac-len) #\0)
                              exp-str)
               )
              ((= frac-len digits) ;; frac-part is exactly the right size
               (string-append pre-str "."
                              frac-str
                              exp-str)
               )
              (else ;; must round to shrink it
               (let* ( (minus-flag (and (> (string-length pre-str) 0)
                                        (char=? (string-ref pre-str 0) #\-)))
                       (pre-str*   (if minus-flag
                                       (substring pre-str 1 (string-length pre-str))
                                       pre-str))
                       (first-part (substring frac-str 0 digits))
                       (last-part  (substring frac-str digits frac-len))
                       (temp-str
                        (string-grow
                         (exact-number->string
                          (round (string->number
                                  (string-append pre-str* first-part "." last-part))))
                         digits
                         #\0))
                       (temp-len   (string-length temp-str))
                       (new-pre    (substring temp-str 0 (- temp-len digits)))
                       (new-frac   (substring temp-str (- temp-len digits) temp-len))
                     )
                 (string-append
                  (if minus-flag "-" "")
                  (if (string=? new-pre "")
                      ;; check if the system displays integer part of numbers
                      ;; whose absolute value is 0 < x < 1.
                      (if (and (string=? pre-str* "")
                               (> digits 0)
                               (not (= (string->number new-frac) 0)))
                          "" "0")
                      new-pre)
                  "."
                  new-frac
                  exp-str)))
         ) ) )

         (define (format-fixed number-or-string width digits) ; returns a string
           (cond
            ((string? number-or-string)
             (string-grow number-or-string width #\space)
             )
            ((number? number-or-string)
             (let ( (real (real-part number-or-string))
                    (imag (imag-part number-or-string))
                  )
               (cond
                ((not (zero? imag))
                 (string-grow
                  (string-append (format-fixed real 0 digits)
                                 (if (negative? imag) "" "+")
                                 (format-fixed imag 0 digits)
                                 "i")
                  width
                  #\space)
                 )
                (digits
                 (let* ( (num-str   (inexact-number->string real))
                         (dot-index (string-index  num-str #\.))
                         (exp-index (string-index  num-str #\e))
                         (length    (string-length num-str))
                         (pre-string
                          (if dot-index
                              (substring num-str 0 dot-index)
                              (if exp-index
                                  (substring num-str 0 exp-index)
                                  num-str))
                          )
                         (exp-string
                          (if exp-index
                              (substring num-str exp-index length)
                              "")
                          )
                         (frac-string
                          (if dot-index
                              (if exp-index
                                  (substring num-str (+ dot-index 1) exp-index)
                                  (substring num-str (+ dot-index 1) length))
                              "")
                          )
                       )
                   ;; check +inf.0, -inf.0, +nan.0, -nan.0
                   (if (string-index num-str #\n)
                       (string-grow num-str width #\space)
                       (string-grow
                        (compose-with-digits digits
                                             pre-string
                                             frac-string
                                             exp-string)
                        width
                        #\space))
                 ))
                (else ;; no digits
                 (string-grow (real-number->string real) width #\space)))
             ))
            (else
             (error
              (format* (list "FORMAT: ~F requires a number or a string, got ~s" number-or-string))))
            ))

         (define documentation-string
"(format [<port>] <format-string> [<arg>...]) -- <port> is #t, #f or an output-port
OPTION  [MNEMONIC]      DESCRIPTION     -- Implementation Assumes ASCII Text Encoding
~H      [Help]          output this text
~A      [Any]           (display arg) for humans
~S      [Slashified]    (write arg) for parsers
~W      [WriteCircular] like ~s but outputs circular and recursive data structures
~~      [tilde]         output a tilde
~T      [Tab]           output a tab character
~%      [Newline]       output a newline character
~&      [Freshline]     output a newline character if the previous output was not a newline
~D      [Decimal]       the arg is a number which is output in decimal radix
~X      [heXadecimal]   the arg is a number which is output in hexdecimal radix
~O      [Octal]         the arg is a number which is output in octal radix
~B      [Binary]        the arg is a number which is output in binary radix
~w,dF   [Fixed]         the arg is a string or number which has width w and d digits after the decimal
~C      [Character]     charater arg is output by write-char
~_      [Space]         a single space character is output
~Y      [Yuppify]       the list arg is pretty-printed to the output
~?      [Indirection]   recursive format: next 2 args are format-string and list of arguments
~K      [Indirection]   same as ~?
"
          )

         (define (require-an-arg args)
           (if (null? args)
               (error "FORMAT: too few arguments" ))
         )

         (define (format-help format-strg arglist)

          (letrec (
             (length-of-format-string (string-length format-strg))

             (anychar-dispatch
              (lambda (pos arglist last-was-newline)
                (if (>= pos length-of-format-string)
                  arglist ; return unused args
                  (let ( (char (string-ref format-strg pos)) )
                    (cond
                     ((eqv? char #\~)
                      (tilde-dispatch (+ pos 1) arglist last-was-newline))
                     (else
                      (write-char char port)
                      (anychar-dispatch (+ pos 1) arglist #f)
                      ))
                    ))
             )) ; end anychar-dispatch

             (has-newline?
              (lambda (whatever last-was-newline)
                (or (eqv? whatever #\newline)
                    (and (string? whatever)
                         (let ( (len (string-length whatever)) )
                           (if (zero? len)
                               last-was-newline
                               (eqv? #\newline (string-ref whatever (- len 1)))))))
              )) ; end has-newline?

             (tilde-dispatch
              (lambda (pos arglist last-was-newline)
                (cond
                 ((>= pos length-of-format-string)
                  (write-char #\~ port) ; tilde at end of string is just output
                  arglist ; return unused args
                  )
                 (else
                  (case (char-upcase (string-ref format-strg pos))
                    ((#\A)       ; Any -- for humans
                     (require-an-arg arglist)
                     (let ( (whatever (car arglist)) )
                       (display whatever port)
                       (anychar-dispatch (+ pos 1)
                                         (cdr arglist)
                                         (has-newline? whatever last-was-newline))
                     ))
                    ((#\S)       ; Slashified -- for parsers
                     (require-an-arg arglist)
                     (let ( (whatever (car arglist)) )
                        (write whatever port)
                        (anychar-dispatch (+ pos 1)
                                          (cdr arglist)
                                          (has-newline? whatever last-was-newline))
                     ))
                    ((#\W)
                     (require-an-arg arglist)
                     (let ( (whatever (car arglist)) )
                        (write-with-shared-structure whatever port)  ;; srfi-38
                        (anychar-dispatch (+ pos 1)
                                          (cdr arglist)
                                          (has-newline? whatever last-was-newline))
                     ))
                    ((#\D)       ; Decimal
                     (require-an-arg arglist)
                     (display (number->string (car arglist) 10) port)
                     (anychar-dispatch (+ pos 1) (cdr arglist) #f)
                     )
                    ((#\X)       ; HeXadecimal
                     (require-an-arg arglist)
                     (display (number->string (car arglist) 16) port)
                     (anychar-dispatch (+ pos 1) (cdr arglist) #f)
                     )
                    ((#\O)       ; Octal
                     (require-an-arg arglist)
                     (display (number->string (car arglist)  8) port)
                     (anychar-dispatch (+ pos 1) (cdr arglist) #f)
                     )
                    ((#\B)       ; Binary
                     (require-an-arg arglist)
                     (display (number->string (car arglist)  2) port)
                     (anychar-dispatch (+ pos 1) (cdr arglist) #f)
                     )
                    ((#\C)       ; Character
                     (require-an-arg arglist)
                     (write-char (car arglist) port)
                     (anychar-dispatch (+ pos 1) (cdr arglist) (eqv? (car arglist) #\newline))
                     )
                    ((#\~)       ; Tilde
                     (write-char #\~ port)
                     (anychar-dispatch (+ pos 1) arglist #f)
                     )
                    ((#\%)       ; Newline
                     (newline port)
                     (anychar-dispatch (+ pos 1) arglist #t)
                     )
                    ((#\&)      ; Freshline
                     (if (not last-was-newline) ;; (unless last-was-newline ..
                         (newline port))
                     (anychar-dispatch (+ pos 1) arglist #t)
                     )
                    ((#\_)       ; Space
                     (write-char #\space port)
                     (anychar-dispatch (+ pos 1) arglist #f)
                     )
                    ((#\T)       ; Tab -- IMPLEMENTATION DEPENDENT ENCODING
                     (write-char ascii-tab port)
                     (anychar-dispatch (+ pos 1) arglist #f)
                     )
                    ((#\Y)       ; Pretty-print
                     (pretty-print (car arglist) port)  ;; IMPLEMENTATION DEPENDENT
                     (anychar-dispatch (+ pos 1) (cdr arglist) #f)
                     )
                    ((#\F)
                     (require-an-arg arglist)
                     (display (format-fixed (car arglist) 0 #f) port)
                     (anychar-dispatch (+ pos 1) (cdr arglist) #f)
                     )
                    ((#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9) ;; gather "~w[,d]F" w and d digits
                     (let loop ( (index (+ pos 1))
                                 (w-digits (list (string-ref format-strg pos)))
                                 (d-digits '())
                                 (in-width? #t)
                               )
                       (if (>= index length-of-format-string)
                           (error
                            (format* (list "FORMAT: improper numeric format directive in ~s" format-strg)))
                           (let ( (next-char (string-ref format-strg index)) )
                             (cond
                              ((char-numeric? next-char)
                               (if in-width?
                                   (loop (+ index 1)
                                         (cons next-char w-digits)
                                         d-digits
                                         in-width?)
                                   (loop (+ index 1)
                                         w-digits
                                         (cons next-char d-digits)
                                         in-width?))
                               )
                              ((char=? (char-upcase next-char) #\F)
                               (let ( (width  (string->number (list->string (reverse w-digits))))
                                      (digits (if (zero? (length d-digits))
                                                  #f
                                                  (string->number (list->string (reverse d-digits)))))
                                    )
                                 (display (format-fixed (car arglist) width digits) port)
                                 (anychar-dispatch (+ index 1) (cdr arglist) #f))
                               )
                              ((char=? next-char #\,)
                               (if in-width?
                                   (loop (+ index 1)
                                         w-digits
                                         d-digits
                                         #f)
                                   (error
                                    (format* (list "FORMAT: too many commas in directive ~s" format-strg))))
                               )
                              (else
                               (error (format* (list "FORMAT: ~~w.dF directive ill-formed in ~s" format-strg)))))))
                     ))
                    ((#\? #\K)       ; indirection -- take next arg as format string
                     (cond           ;  and following arg as list of format args
                      ((< (length arglist) 2)
                       (error
                        (format* (list "FORMAT: less arguments than specified for ~~?: ~s" arglist)))
                       )
                      ((not (string? (car arglist)))
                       (error
                        (format* (list "FORMAT: ~~? requires a string: ~s" (car arglist))))
                       )
                      (else
                       (format-help (car arglist) (cadr arglist))
                       (anychar-dispatch (+ pos 1) (cddr arglist) #f)
                     )))
                    ((#\H)      ; Help
                     (display documentation-string port)
                     (anychar-dispatch (+ pos 1) arglist #t)
                     )
                    (else
                     (error (format* (list "FORMAT: unknown tilde escape: ~s"
                                           (string-ref format-strg pos)))))
                    )))
                )) ; end tilde-dispatch
             ) ; end letrec

             ; format-help main
             (anychar-dispatch 0 arglist #f)
            )) ; end format-help

        ; format main
        (let ( (unused-args (format-help format-string args)) )
          (if (not (null? unused-args))
              (error
               (format* (list "FORMAT: unused arguments ~s" unused-args))))
          (return-value))

      )) ; end letrec, if
)))  ; end format

(format* args))

;;;============================================================================
