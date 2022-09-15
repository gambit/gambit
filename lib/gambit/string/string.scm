;;;============================================================================

;;; File: "string.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; String operations.

(##include "string#.scm")

;;;----------------------------------------------------------------------------

(define-prim-vector-procedures
  string
  char
  char
  #\nul
  macro-force-vars
  macro-check-char
  macro-check-char-list-char
  macro-test-char
  ##fail-check-char
  define-map-and-for-each
  ##char=?)

;;;----------------------------------------------------------------------------

(define-prim-nary-bool (##string=? str1 str2)
  #t
  #t
  (##string-equal? str1 str2)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string=? str1 str2)
  #t
  #t
  (##string-equal? str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim (##string<?2 str1 str2)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (and (not (eq? str1 str2))
       (let ((len1 (string-length str1))
             (len2 (string-length str2)))
         (let ((n (fxmin len1 len2)))
           (let loop ((i 0))
             (if (fx< i n)
                 (let ((c1 (string-ref str1 i))
                       (c2 (string-ref str2 i)))
                   (if (char=? c1 c2)
                       (loop (fx+ i 1))
                       (char<? c1 c2)))
                 (fx< n len2)))))))

(define-prim-nary-bool (##string<? str1 str2)
  #t
  #t
  (##string<?2 str1 str2)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string<? str1 str2)
  #t
  #t
  (##string<?2 str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (##string>? str1 str2)
  #t
  #t
  (##string<?2 str2 str1)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string>? str1 str2)
  #t
  #t
  (##string<?2 str2 str1)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (##string<=? str1 str2)
  #t
  #t
  (##not (##string<?2 str2 str1))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string<=? str1 str2)
  #t
  #t
  (##not (##string<?2 str2 str1))
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (##string>=? str1 str2)
  #t
  #t
  (##not (##string<?2 str1 str2))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string>=? str1 str2)
  #t
  #t
  (##not (##string<?2 str1 str2))
  macro-force-vars
  macro-check-string)

(define-prim (##string-cmp-ci str1 str2)
  (macro-string-cmp-ci str1
                       str2
                       0
                       (##string-length str1)
                       0
                       (##string-length str2)))

(define-prim (##string-ci=?2 str1 str2)
  (or (##eq? str1 str2)
      (##fx= (##string-cmp-ci str1 str2) 0)))

(define-prim-nary-bool (##string-ci=? str1 str2)
  #t
  #t
  (##string-ci=?2 str1 str2)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string-ci=? str1 str2)
  #t
  #t
  (##string-ci=?2 str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim (##string-ci<?2 str1 str2)
  (and (##not (##eq? str1 str2))
       (##fx< (##string-cmp-ci str1 str2) 0)))

(define-prim-nary-bool (##string-ci<? str1 str2)
  #t
  #t
  (##string-ci<?2 str1 str2)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string-ci<? str1 str2)
  #t
  #t
  (##string-ci<?2 str1 str2)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (##string-ci>? str1 str2)
  #t
  #t
  (##string-ci<?2 str2 str1)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string-ci>? str1 str2)
  #t
  #t
  (##string-ci<?2 str2 str1)
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (##string-ci<=? str1 str2)
  #t
  #t
  (##not (##string-ci<?2 str2 str1))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string-ci<=? str1 str2)
  #t
  #t
  (##not (##string-ci<?2 str2 str1))
  macro-force-vars
  macro-check-string)

(define-prim-nary-bool (##string-ci>=? str1 str2)
  #t
  #t
  (##not (##string-ci<?2 str1 str2))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (string-ci>=? str1 str2)
  #t
  #t
  (##not (##string-ci<?2 str1 str2))
  macro-force-vars
  macro-check-string)

(define (##string-upcase str)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (macro-string-upcase str 0 (string-length str)))

(define-prim (string-upcase str)
  (macro-force-vars (str)
    (macro-check-string
      str
      1
      (string-upcase str)
      (##string-upcase str))))

(define (##string-downcase str)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (macro-string-downcase str 0 (string-length str)))

(define-prim (string-downcase str)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" string-downcase)) ;; but not string-downcase to ##string-downcase

  (macro-force-vars (str)
    (macro-check-string
      str
      1
      (string-downcase str)
      (##string-downcase str))))

(define-prim (##string-foldcase str)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (macro-string-foldcase str 0 (string-length str)))

(define-prim (string-foldcase str)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" string-foldcase)) ;; but not string-foldcase to ##string-foldcase

  (macro-force-vars (str)
    (macro-check-string
      str
      1
      (string-foldcase str)
      (##string-foldcase str))))

(define-prim (##copy-string-list lst)

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (define (copy lst i)
    (macro-force-vars (lst)
      (cond ((pair? lst)
             (let ((str (car lst)))
               (macro-force-vars (str)
                 (if (string? str)
                     (let ((x (copy (cdr lst) (fx+ i 1))))
                       (if (fixnum? x)
                           x
                           (cons str x)))
                     i))))
            ((null? lst)
             '())
            (else
             0))))

  (copy lst 1))

(define-prim&proc
  (string-prefix-length
   (s1     string)
   (s2     string)
   (start1 (index-range-incl 0 (string-length s1)) 0)
   (end1   (index-range-incl start1 (string-length s1)) (string-length s1))
   (start2 (index-range-incl 0 (string-length s2)) 0)
   (end2   (index-range-incl start2 (string-length s2)) (string-length s2)))

  (let* ((delta (fxmin (fx- end1 start1) (fx- end2 start2)))
         (end1 (fx+ start1 delta)))

    (if (and (eq? s1 s2) (fx= start1 start2))
        delta
        (let loop ((i start1) (j start2))
          (if (or (fx>= i end1)
                  (not (char=? (string-ref s1 i)
                               (string-ref s2 j))))
              (fx- i start1)
              (loop (fx+ i 1) (fx+ j 1)))))))

(define-prim&proc
  (string-suffix-length
   (s1     string)
   (s2     string)
   (start1 (index-range-incl 0 (string-length s1)) 0)
   (end1   (index-range-incl start1 (string-length s1)) (string-length s1))
   (start2 (index-range-incl 0 (string-length s2)) 0)
   (end2   (index-range-incl start2 (string-length s2)) (string-length s2)))

  (let* ((delta (fxmin (fx- end1 start1) (fx- end2 start2)))
         (start1 (fx- end1 delta)))

    (if (and (eq? s1 s2) (fx= end1 end2))
        delta
        (let loop ((i (fx- end1 1)) (j (fx- end2 1)))
          (if (or (fx< i start1)
                  (not (char=? (string-ref s1 i)
                               (string-ref s2 j))))
              (fx- (fx- end1 i) 1)
              (loop (fx- i 1) (fx- j 1)))))))

(define-prim&proc
  (string-prefix-length-ci
   (s1     string)
   (s2     string)
   (start1 (index-range-incl 0 (string-length s1)) 0)
   (end1   (index-range-incl start1 (string-length s1)) (string-length s1))
   (start2 (index-range-incl 0 (string-length s2)) 0)
   (end2   (index-range-incl start2 (string-length s2)) (string-length s2)))

  (let* ((delta (fxmin (fx- end1 start1) (fx- end2 start2)))
         (end1 (fx+ start1 delta)))

    (if (and (eq? s1 s2) (fx= start1 start2))
        delta
        (let loop ((i start1) (j start2))
          (if (or (fx>= i end1)
                  (not (char-ci=? (string-ref s1 i)
                                  (string-ref s2 j))))
              (fx- i start1)
              (loop (fx+ i 1) (fx+ j 1)))))))

(define-prim&proc
  (string-suffix-length-ci
   (s1     string)
   (s2     string)
   (start1 (index-range-incl 0 (string-length s1)) 0)
   (end1   (index-range-incl start1 (string-length s1)) (string-length s1))
   (start2 (index-range-incl 0 (string-length s2)) 0)
   (end2   (index-range-incl start2 (string-length s2)) (string-length s2)))

  (let* ((delta (fxmin (fx- end1 start1) (fx- end2 start2)))
         (start1 (fx- end1 delta)))

    (if (and (eq? s1 s2) (fx= end1 end2))
        delta
        (let loop ((i (fx- end1 1)) (j (fx- end2 1)))
          (if (or (fx< i start1)
                  (not (char-ci=? (string-ref s1 i)
                                  (string-ref s2 j))))
              (fx- (fx- end1 i) 1)
              (loop (fx- i 1) (fx- j 1)))))))

(define-prim&proc
  (string-prefix?
   (s1     string)
   (s2     string)
   (start1 (index-range-incl 0 (string-length s1)) 0)
   (end1   (index-range-incl start1 (string-length s1)) (string-length s1))
   (start2 (index-range-incl 0 (string-length s2)) 0)
   (end2   (index-range-incl start2 (string-length s2)) (string-length s2)))

  (let ((len1 (fx- end1 start1)))
    (and (fx<= len1 (fx- end2 start2))
         (fx= len1
              (string-prefix-length s1 s2 start1 end1 start2 end2)))))

(define-prim&proc
  (string-suffix?
   (s1     string)
   (s2     string)
   (start1 (index-range-incl 0 (string-length s1)) 0)
   (end1   (index-range-incl start1 (string-length s1)) (string-length s1))
   (start2 (index-range-incl 0 (string-length s2)) 0)
   (end2   (index-range-incl start2 (string-length s2)) (string-length s2)))

  (let ((len1 (fx- end1 start1)))
    (and (fx<= len1 (fx- end2 start2))
         (fx= len1
              (string-suffix-length s1 s2 start1 end1 start2 end2)))))

(define-prim&proc
  (string-prefix-ci?
   (s1     string)
   (s2     string)
   (start1 (index-range-incl 0 (string-length s1)) 0)
   (end1   (index-range-incl start1 (string-length s1)) (string-length s1))
   (start2 (index-range-incl 0 (string-length s2)) 0)
   (end2   (index-range-incl start2 (string-length s2)) (string-length s2)))

  (let ((len1 (fx- end1 start1)))
    (and (fx<= len1 (fx- end2 start2))
         (fx= len1
              (string-prefix-length-ci s1 s2 start1 end1 start2 end2)))))

(define-prim&proc
  (string-suffix-ci?
   (s1     string)
   (s2     string)
   (start1 (index-range-incl 0 (string-length s1)) 0)
   (end1   (index-range-incl start1 (string-length s1)) (string-length s1))
   (start2 (index-range-incl 0 (string-length s2)) 0)
   (end2   (index-range-incl start2 (string-length s2)) (string-length s2)))

  (let ((len1 (fx- end1 start1)))
    (and (fx<= len1 (fx- end2 start2))
         (fx= len1
              (string-suffix-length-ci s1 s2 start1 end1 start2 end2)))))

(define-prim&proc
  (string-contains
   (s1     string)
   (s2     string)
   (start1 (index-range-incl 0 (string-length s1)) 0)
   (end1   (index-range-incl start1 (string-length s1)) (string-length s1))
   (start2 (index-range-incl 0 (string-length s2)) 0)
   (end2   (index-range-incl start2 (string-length s2)) (string-length s2)))

  (let* ((len (fx- end2 start2))
	 (limit (fx- end1 len)))
    (let loop1 ((i start1))
      (and (fx<= i limit)
           (let loop2 ((j (fx- len 1)))
             (if (fx>= j 0)
                 (if (char=? (string-ref s1 (fx+ i j))
                             (string-ref s2 j))
                     (loop2 (fx- j 1))
                     (loop1 (fx+ i 1)))
                 i))))))

(define-prim&proc
  (string-contains-ci
   (s1     string)
   (s2     string)
   (start1 (index-range-incl 0 (string-length s1)) 0)
   (end1   (index-range-incl start1 (string-length s1)) (string-length s1))
   (start2 (index-range-incl 0 (string-length s2)) 0)
   (end2   (index-range-incl start2 (string-length s2)) (string-length s2)))

  (let* ((len (fx- end2 start2))
	 (limit (fx- end1 len)))
    (let loop1 ((i start1))
      (and (fx<= i limit)
           (let loop2 ((j (fx- len 1)))
             (if (fx>= j 0)
                 (if (char-ci=? (string-ref s1 (fx+ i j))
                                (string-ref s2 j))
                     (loop2 (fx- j 1))
                     (loop1 (fx+ i 1)))
                 i))))))

#;
(define-primitive
  (string-starts-with
   (string string)
   (prefix string)
   (start  (index-range-incl 0 (string-length string)) 0)
   (end    (index-range-incl start (string-length string)) (string-length string)))

  (let ((prefix-len (string-length prefix)))
    (and (fx>= (fx- end start) prefix-len)
         (let ((origin start))
           (let loop ((i (fx- prefix-len 1)))
             (or (fx< i 0)
                 (and (char=? (string-ref string (fx+ origin i))
                              (string-ref prefix i))
                      (loop (fx- i 1)))))))))

#;
(define-primitive
  (string-ends-with
   (string string)
   (suffix string)
   (start  (index-range-incl 0 (string-length string)) 0)
   (end    (index-range-incl start (string-length string)) (string-length string)))

  (let ((suffix-len (string-length suffix)))
    (and (fx>= (fx- end start) suffix-len)
         (let ((origin (fx- (string-length string) suffix-len)))
           (let loop ((i (fx- suffix-len 1)))
             (or (fx< i 0)
                 (and (char=? (string-ref string (fx+ origin i))
                              (string-ref suffix i))
                      (loop (fx- i 1)))))))))

(define-primitive (string-prefix-strip prefix string)
  (and (string-prefix? prefix string)
       (substring string (string-length prefix) (string-length string))))

(define-primitive (string-suffix-strip suffix string)
  (and (string-suffix? suffix string)
       (substring string 0 (fx- (string-length string) (string-length suffix)))))

(define-primitive
  (string-split-at-char
   (string    string)
   (delimiter char)
   (tail      object '())
   (start     (index-range-incl 0 (string-length string)) 0)
   (end       (index-range-incl start (string-length string)) (string-length string)))

  (let loop ((lo end) (hi end) (lst tail))
    (if (fx< start lo)
        (let* ((lo-1 (fx- lo 1))
               (c (string-ref string lo-1)))
          (if (char=? c delimiter)
              (loop lo-1
                    lo-1
                    (cons (substring string lo hi) lst))
              (loop lo-1
                    hi
                    lst)))
        (cons (substring string lo hi) lst))))

(define-primitive
  (string-split-at-char-reversed
   (string    string)
   (delimiter char)
   (tail      object '())
   (start     (index-range-incl 0 (string-length string)) 0)
   (end       (index-range-incl start (string-length string)) (string-length string)))

  (let loop ((lo start) (hi start) (lst tail))
    (if (fx< hi end)
        (let* ((c (string-ref string hi))
               (hi+1 (fx+ hi 1)))
          (if (char=? c delimiter)
              (loop hi+1
                    hi+1
                    (cons (substring string lo hi) lst))
              (loop lo
                    hi+1
                    lst)))
        (cons (substring string lo hi) lst))))

;;;----------------------------------------------------------------------------

;; UTF-8 encoding and decoding

(implement-library-type-invalid-utf8-encoding-exception)

(define-prim (##raise-invalid-utf8-encoding-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-invalid-utf8-encoding-exception
       procedure
       arguments)))))

(define-prim (##string->utf8-length
              str
              #!optional
              (start 0)
              (end (##string-length str)))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((i start)
             (len 0))
    (if (fx< i end)
        (let ((c (char->integer (string-ref str i))))
          (cond ((fx<= c #x7f)
                 ;; 1 byte encoding (ASCII)
                 (loop (fx+ i 1)
                       (fx+ len 1)))
                ((fx<= c #x7ff)
                 ;; 2 byte encoding
                 (loop (fx+ i 1)
                       (fx+ len 2)))
                ((fx<= c #xffff)
                 ;; 3 byte encoding
                 (loop (fx+ i 1)
                       (fx+ len 3)))
                (else
                 ;; 4 byte encoding
                 (loop (fx+ i 1)
                       (fx+ len 4)))))
        len)))

(define-prim (##string->utf8
              str
              #!optional
              (start 0)
              (end (##string-length str)))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let* ((len (##string->utf8-length str start end))
         (result (make-u8vector len)))
    (if (fx= len (fx- end start))
        (let loop1 ((i 0))
          (if (fx< i len)
              (begin
                (u8vector-set!
                 result
                 i
                 (char->integer
                  (string-ref str (fx+ start i))))
                (loop1 (fx+ i 1)))
              result))
        (let loop2 ((i start)
                    (j 0))
          (if (and (fx< i end)
                   (fx< j len)) ;; account for str mutation by other thread
              (let ((c (char->integer (string-ref str i))))
                (cond ((fx<= c #x7f)
                       ;; 1 byte encoding (ASCII)
                       (u8vector-set! result j c)
                       (loop2 (fx+ i 1)
                              (fx+ j 1)))
                      ((fx<= c #x7ff)
                       ;; 2 byte encoding
                       (u8vector-set!
                        result
                        j
                        (fx+ #xc0 (fxarithmetic-shift-right c 6)))
                       (u8vector-set!
                        result
                        (fx+ j 1)
                        (fx+ #x80 (fxand #x3f c)))
                       (loop2 (fx+ i 1)
                              (fx+ j 2)))
                      ((fx<= c #xffff)
                       ;; 3 byte encoding
                       (u8vector-set!
                        result
                        j
                        (fx+ #xe0 (fxarithmetic-shift-right c 12)))
                       (u8vector-set!
                        result
                        (fx+ j 1)
                        (fx+ #x80 (fxand #x3f (fxarithmetic-shift-right c 6))))
                       (u8vector-set!
                        result
                        (fx+ j 2)
                        (fx+ #x80 (fxand #x3f c)))
                       (loop2 (fx+ i 1)
                              (fx+ j 3)))
                      (else
                       ;; 4 byte encoding
                       (u8vector-set!
                        result
                        j
                        (fx+ #xf0 (fxarithmetic-shift-right c 18)))
                       (u8vector-set!
                        result
                        (fx+ j 1)
                        (fx+ #x80 (fxand #x3f (fxarithmetic-shift-right c 12))))
                       (u8vector-set!
                        result
                        (fx+ j 2)
                        (fx+ #x80 (fxand #x3f (fxarithmetic-shift-right c 6))))
                       (u8vector-set!
                        result
                        (fx+ j 3)
                        (fx+ #x80 (fxand #x3f c)))
                       (loop2 (fx+ i 1)
                              (fx+ j 4)))))
              result)))))

(define-prim (string->utf8
              str
              #!optional
              (start (macro-absent-obj))
              (end (macro-absent-obj)))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" string->utf8)) ;; but not string->utf8 to ##string->utf8

  (macro-force-vars (str start end)
    (macro-check-string
      str
      1
      (string->utf8 str start end)
      (if (eq? start (macro-absent-obj))
          (##string->utf8 str)
          (macro-check-index-range-incl
            start
            2
            0
            (string-length str)
            (string->utf8 str start end)
            (if (eq? end (macro-absent-obj))
                (##string->utf8 str start)
                (macro-check-index-range-incl
                  end
                  3
                  start
                  (string-length str)
                  (string->utf8 str start end)
                  (##string->utf8 str start end))))))))

(define-prim (##utf8->string-length
              u8vect
              #!optional
              (start 0)
              (end (##u8vector-length u8vect)))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (let loop ((i start)
             (len 0))
    (if (fx< i end)
        (let ((b0 (u8vector-ref u8vect i)))
          (cond ((fx< b0 #x80)
                 ;; 1 byte encoding (ASCII)
                 (loop (fx+ i 1)
                       (fx+ len 1)))
                ((fx< b0 #xe0)
                 ;; 2 byte encoding or invalid encoding
                 (loop (fx+ i 2)
                       (fx+ len 1)))
                ((fx< b0 #xf0)
                 ;; 3 byte encoding or invalid encoding
                 (loop (fx+ i 3)
                       (fx+ len 1)))
                (else
                 ;; 4 byte encoding or invalid encoding
                 (loop (fx+ i 4)
                       (fx+ len 1)))))
        (if (fx> i end)
            0 ;; invalid or truncated encoding
            len))))

(define-prim (##utf8->string
              u8vect
              #!optional
              (start 0)
              (end (##u8vector-length u8vect)))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc

  (define (invalid-utf8)
    (##raise-invalid-utf8-encoding-exception utf8->string u8vect start end))

  (let* ((len (##utf8->string-length u8vect start end))
         (result (make-string len)))
    (if (fx= len (fx- end start))
        (let loop1 ((i 0))
          (if (fx< i len)
              (begin
                (string-set!
                 result
                 i
                 (integer->char
                  (u8vector-ref u8vect (fx+ start i))))
                (loop1 (fx+ i 1)))
              result))
        (let loop2 ((i start)
                    (j 0))
          (if (fx< i end)
              (if (fx< j len) ;; account for u8vect mutation by other thread
                  (let ((b0 (u8vector-ref u8vect i)))
                    (cond ((fx< b0 #x80)
                           ;; 1 byte encoding (ASCII)
                           (string-set!
                            result
                            j
                            (integer->char b0))
                           (loop2 (fx+ i 1)
                                  (fx+ j 1)))
                          ((fx< b0 #xc2)
                           (invalid-utf8))
                          ((fx< b0 #xe0)
                           ;; 2 byte encoding
                           (let* ((b1 (u8vector-ref
                                       u8vect
                                       (fx+ i 1)))
                                  (n (fx+
                                      (fxarithmetic-shift-left
                                       (fxand b0 #x1f)
                                       6)
                                      (fxand b1 #x3f))))
                             (if (and (fx= (fxand b1 #xc0)
                                           #x80)
                                      (fx>= n #x80))
                                 (begin
                                   (string-set!
                                    result
                                    j
                                    (integer->char n))
                                   (loop2 (fx+ i 2)
                                          (fx+ j 1)))
                                 (invalid-utf8))))
                          ((fx< b0 #xf0)
                           ;; 3 byte encoding
                           (let* ((b1 (u8vector-ref
                                       u8vect
                                       (fx+ i 1)))
                                  (b2 (u8vector-ref
                                       u8vect
                                       (fx+ i 2)))
                                  (n (fx+
                                      (fxarithmetic-shift-left
                                       (fxand b0 #x0f)
                                       12)
                                      (fxarithmetic-shift-left
                                       (fxand b1 #x3f)
                                       6)
                                      (fxand b2 #x3f))))
                             (if (and (fx= (fxand (fxior b1
                                                         b2)
                                                  #xc0)
                                           #x80)
                                      (fx>= n #x800)
                                      (not
                                       (and (fx>= n #xd800)
                                            (fx<= n #xdfff))))
                                 (begin
                                   (string-set!
                                    result
                                    j
                                    (integer->char n))
                                   (loop2 (fx+ i 3)
                                          (fx+ j 1)))
                                 (invalid-utf8))))
                          ((fx< b0 #xf5)
                           ;; 4 byte encoding
                           (let* ((b1 (u8vector-ref
                                       u8vect
                                       (fx+ i 1)))
                                  (b2 (u8vector-ref
                                       u8vect
                                       (fx+ i 2)))
                                  (b3 (u8vector-ref
                                       u8vect
                                       (fx+ i 3)))
                                  (n (fx+
                                      (fxarithmetic-shift-left
                                       (fxand b0 #x07)
                                       18)
                                      (fxarithmetic-shift-left
                                       (fxand b1 #x3f)
                                       12)
                                      (fxarithmetic-shift-left
                                       (fxand b2 #x3f)
                                       6)
                                      (fxand b3 #x3f))))
                             (if (and (fx= (fxand (fxior b1
                                                         b2
                                                         b3)
                                                  #xc0)
                                           #x80)
                                      (fx>= n #x10000)
                                      (fx<= n #x10ffff))
                                 (begin
                                   (string-set!
                                    result
                                    j
                                    (integer->char n))
                                   (loop2 (fx+ i 4)
                                          (fx+ j 1)))
                                 (invalid-utf8))))
                          (else
                           (invalid-utf8))))
                  (invalid-utf8))
              (if (or (fx> i end)
                      (fx< j len))
                  (invalid-utf8)
                  result))))))

(define-prim (utf8->string
              u8vect
              #!optional
              (start (macro-absent-obj))
              (end (macro-absent-obj)))

  (include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
  (namespace ("" utf8->string)) ;; but not utf8->string to ##utf8->string

  (macro-force-vars (u8vect start end)
    (macro-check-u8vector
      u8vect
      1
      (utf8->string u8vect start end)
      (if (eq? start (macro-absent-obj))
          (##utf8->string u8vect)
          (macro-check-index-range-incl
            start
            2
            0
            (u8vector-length u8vect)
            (utf8->string u8vect start end)
            (if (eq? end (macro-absent-obj))
                (##utf8->string u8vect start)
                (macro-check-index-range-incl
                  end
                  3
                  start
                  (u8vector-length u8vect)
                  (utf8->string u8vect start end)
                  (##utf8->string u8vect start end))))))))

;;;============================================================================
