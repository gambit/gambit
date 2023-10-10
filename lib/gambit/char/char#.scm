;;;============================================================================

;;; File: "char#.scm"

;;; Copyright (c) 1994-2023 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Character operations.

(##namespace (""

char->integer
char-alphabetic?
char-ci<=?
char-ci<?
char-ci=?
char-ci>=?
char-ci>?
char-downcase
char-foldcase
char-lower-case?
char-numeric?
char-upcase
char-upper-case?
char-whitespace?
char<=?
char<?
char=?
char>=?
char>?
char?
digit-value
integer->char

->char-set
char-set
char-set->list
char-set->string
char-set-adjoin
char-set-adjoin!
char-set-any
char-set-complement
char-set-complement!
char-set-contains?
char-set-copy
char-set-count
char-set-cursor
char-set-cursor-next
char-set-delete
char-set-delete!
char-set-diff+intersection
char-set-diff+intersection!
char-set-difference
char-set-difference!
char-set-every
char-set-filter
char-set-filter!
char-set-fold
char-set-for-each
char-set-hash
char-set-intersection
char-set-intersection!
char-set-map
char-set-ref
char-set-size
char-set-unfold
char-set-unfold!
char-set-union
char-set-union!
char-set-xor
char-set-xor!
char-set<=
char-set=
char-set?
end-of-char-set?
list->char-set
list->char-set!
string->char-set
string->char-set!
ucs-range->char-set
ucs-range->char-set!

char-set:ascii
char-set:blank
char-set:digit
char-set:empty
char-set:full
char-set:graphic
char-set:hex-digit
char-set:iso-control
char-set:letter
char-set:letter+digit
char-set:lower-case
char-set:printing
char-set:punctuation
char-set:symbol
char-set:title-case
char-set:upper-case
char-set:whitespace

))

;;;----------------------------------------------------------------------------

;; This code has been tested with https://github.com/feeley/r7rs-unicode-check

;; The latest Unicode tables are available here:
;;
;; https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
;; https://www.unicode.org/Public/UCD/latest/ucd/PropList.txt
;; https://www.unicode.org/Public/UCD/latest/ucd/CaseFolding.txt
;; https://www.unicode.org/Public/UCD/latest/ucd/SpecialCasing.txt
;;
;; This directory contains a copy, which can be updated when new versions
;; become available by executing
;;
;;   make update-unicode
;;
;; The tables define various character properties (used in the
;; definition of char-alphabetic, char-lower-case?, etc), as follows:
;;
;; Alphabetic = Lowercase + Uppercase + Lt + Lm + Lo + Nl + Other_Alphabetic
;; Lowercase  = Ll + Other_Lowercase
;; Uppercase  = Lu + Other_Uppercase
;;
;; UnicodeData.txt defines Ll, Lu, Lt, Lm, Lo, Nl, etc
;;
;; PropList.txt defines Other_Alphabetic, Other_Lowercase, Other_Uppercase,
;; and White_Space
;;
;; CaseFolding.txt defines the simple and full case folding mappings
;; (used in the definition of char-foldcase and string-foldcase)
;;
;; SpecialCasing.txt defines the full case mappings
;; (used in the definition of string-downcase and string-upcase)

;; This is the meaning of the character properties in UnicodeData.txt:
;;
;; Lu = Letter, uppercase
;; Ll = Letter, lowercase
;; Lt = Letter, titlecase
;; Lm = Letter, modifier
;; Lo = Letter, other
;; Mn = Mark, nonspacing
;; Mc = Mark, spacing combining
;; Me = Mark, enclosing
;; Nd = Number, decimal digit
;; Nl = Number, letter
;; No = Number, other
;; Pc = Punctuation, connector
;; Pd = Punctuation, dash
;; Ps = Punctuation, open
;; Pe = Punctuation, close
;; Pi = Punctuation, initial quote (may behave like Ps or Pe depending on usage)
;; Pf = Punctuation, final quote (may behave like Ps or Pe depending on usage)
;; Po = Punctuation, other
;; Sm = Symbol, math
;; Sc = Symbol, currency
;; Sk = Symbol, modifier
;; So = Symbol, other
;; Zs = Separator, space
;; Zl = Separator, line
;; Zp = Separator, paragraph
;; Cc = Other, control
;; Cf = Other, format
;; Cs = Other, surrogate
;; Co = Other, privateuse
;; Cn = Other, not assigned (including noncharacters)

;; Encoding in unicode-class table:
;;
;;   |       UPPER        |       OTHER        |       LOWER        |
;;   |FLT:   :   : LF T=0 | LF U=0 :FLU:   :   | UT F=0 :FUT:   :   |
;;   | F : L : T : LF T=0 | LF U=0 : F : L : U | UT F=0 : F : U : T |
;;
;; F | F :   :   :    F   |    F   : F :   :   |   0    : F :   :   |
;; L |   : L :   :    L   |    L   :   : L :   |   0    : 0 :   :   |
;; T |   :   : T :    0   |    0   : 0 :   :   |   T    :   :   : T |
;; U | 0 :   :   :    0   |    0   :   :   : U |   U    :   : U :   |

(macro-define-syntax macro-define-macros-from-unicode-files
  (lambda (src)

    (define support-title-case?        #t)
    (define support-full-case-folding? #t)

    (define max-char-code (or (##deconstruct-call src 2 ##desourcify)
                              #x10ffff #;(##max-char-code))) ;; TODO: after bootstrap replace with (##max-char-code)

    (define this-dir (path-directory (##source-path src)))

    (define UnicodeData-path   (path-expand "UnicodeData.txt"   this-dir))
    (define PropList-path      (path-expand "PropList.txt"      this-dir))
    (define CaseFolding-path   (path-expand "CaseFolding.txt"   this-dir))
    (define SpecialCasing-path (path-expand "SpecialCasing.txt" this-dir))

    (define whitespace-class-start 0)
    (define whitespace-class-end   (+ 1 whitespace-class-start))

    (define no-class whitespace-class-end)

    (define punctuation-categories
      '(
        Pc ;; Punctuation, connector
        Pd ;; Punctuation, dash
        Ps ;; Punctuation, open
        Pe ;; Punctuation, close
        Pi ;; Punctuation, initial quote (may behave like Ps or Pe depending on usage)
        Pf ;; Punctuation, final quote (may behave like Ps or Pe depending on usage)
        Po ;; Punctuation, other
       ))

    (define symbol-categories
      '(
        Sm ;; Symbol, math
        Sc ;; Symbol, currency
        Sk ;; Symbol, modifier
        So ;; Symbol, other
       ))

    ;; Symbols are not a notable category because they are not
    ;; disjoint from other classes, for example some are letters.

    (define notable-categories
      punctuation-categories)

    (define separator-categories
      '(
        Zs ;; Separator, space
        Zl ;; Separator, line
        Zp ;; Separator, paragraph
       ))

    (define control-categories
      '(
        Cc ;; Other, control
        Cf ;; Other, format
        Cs ;; Other, surrogate
        Co ;; Other, privateuse
        Cn ;; Other, not assigned (including noncharacters)
       ))

    (define not-notable-categories
      '(
        ;; Lu ;; Letter, uppercase
        ;; Ll ;; Letter, lowercase
        ;; Lt ;; Letter, titlecase
        ;; Lm ;; Letter, modifier
        ;; Lo ;; Letter, other
        ;; Mn ;; Mark, nonspacing
        ;; Mc ;; Mark, spacing combining
        ;; Me ;; Mark, enclosing
        ;; Nd ;; Number, decimal digit
        ;; Nl ;; Number, letter
        ;; No ;; Number, other
       ))

    (define notable-categories-table
      (let ((i (+ 1 no-class))
            (notable-categories-table (make-table)))
        (for-each (lambda (cls)
                    (table-set! notable-categories-table cls i)
                    (set! i (+ i 1)))
                  notable-categories)
        notable-categories-table))

    (define punctuation-class-start (table-ref notable-categories-table 'Pc))
    (define punctuation-class-end   (+ 1 (table-ref notable-categories-table 'Po)))

    (define digit-class-start punctuation-class-end)
    (define digit-class-end   (+ 10 digit-class-start))

    (define alphabetic-class-start digit-class-end)

    (define other-class-start    #f)
    (define other-class-end      #f)
    (define upper-class-start    #f)
    (define upper-class-end      #f)
    (define title-class-start    #f)
    (define title-class-end      #f)
    (define lower-class-start    #f)
    (define lower-class-end      #f)
    (define alphabetic-class-end #f)

    (define other-dist-table (make-table))
    (define upper-dist-table (make-table))
    (define title-dist-table (make-table))
    (define lower-dist-table (make-table))

    (define unicode-upcase-dist    #f)
    (define unicode-titlecase-dist #f)
    (define unicode-downcase-dist  #f)
    (define unicode-foldcase-dist  #f)

    ;; char-set representation as an ordered vector of the in-out boundaries

    (define (char-set-begin)
      (vector (list -1)))

    (define (char-set-add! cs code)
      ;; assumes that char-set-add! will be called with monotonically
      ;; increasing values of code and never a code in the range #xd800..#xdfff
      (let* ((boundaries (vector-ref cs 0))
             (last (car boundaries))
             (next (+ 1 code))
             (next (if (and (>= next #xd800) (< next #xe000)) #xe000 next)))
        (if (= code last)
            (set-car! boundaries next)
            (vector-set! cs 0 (cons next (cons code boundaries))))))

    (define (char-set-end cs)
      (cdr (reverse (vector-ref cs 0))))

    (define char-set:lower-case   (char-set-begin))
    (define char-set:upper-case   (char-set-begin))
    (define char-set:title-case   (char-set-begin))
    (define char-set:letter       (char-set-begin))
    (define char-set:digit        (char-set-begin))
    (define char-set:letter+digit (char-set-begin))
    (define char-set:graphic      (char-set-begin))
    (define char-set:printing     (char-set-begin))
    (define char-set:whitespace   (char-set-begin))
    (define char-set:iso-control  (char-set-begin))
    (define char-set:punctuation  (char-set-begin))
    (define char-set:symbol       (char-set-begin))
    (define char-set:hex-digit    (char-set-begin))
    (define char-set:blank        (char-set-begin))
    (define char-set:ascii        (char-set-begin))

    ;; add any deviations from the Unicode spec here

    (define substitutions
      '(
        ;;(#x00df . #("00DF" "LATIN SMALL LETTER SHARP S" "Ll" "0" "L" "" "" "" "" "N" "" "" "1E9E" ""))
        ))

    (define (substitute entry code)
      (let ((x (assoc code substitutions)))
        (if x
            (cdr x)
            entry)))

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

    ;; vector specialization

    (define (vector-all? pred vect)
      (let loop ((i (- (vector-length vect) 1)))
        (if (>= i 0)
            (and (pred (vector-ref vect i))
                 (loop (- i 1)))
            #t)))

    (define (int-in-range? x lo hi)
      (and (integer? x) (exact? x) (>= x lo) (<= x hi)))

    (define (u8? x)  (int-in-range? x           0        255))
    (define (s8? x)  (int-in-range? x        -128        127))
    (define (u16? x) (int-in-range? x           0      65535))
    (define (s16? x) (int-in-range? x      -32768      32767))
    (define (u32? x) (int-in-range? x           0 4294967296))
    (define (s32? x) (int-in-range? x -2147483648 2147483647))

    (define (have-feature x) (memq x (##cond-expand-features)))

    (define (specialize-vector vect)
      (cond ((vector-all? u8? vect)
             (list->u8vector (vector->list vect)))
            ((and (or (have-feature 'enable-s8vector)
                      (not (have-feature 'disable-s8vector)))
                  (vector-all? s8? vect))
             (list->s8vector (vector->list vect)))
            ((and (or (have-feature 'enable-u16vector)
                      (not (have-feature 'disable-u16vector)))
                  (vector-all? u16? vect))
             (list->u16vector (vector->list vect)))
            ((and (or (have-feature 'enable-s16vector)
                      (not (have-feature 'disable-s16vector)))
                  (vector-all? s16? vect))
             (list->s16vector (vector->list vect)))
            ((and (or (have-feature 'enable-u32vector)
                      (not (have-feature 'disable-u32vector)))
                  (vector-all? u32? vect))
             (list->u32vector (vector->list vect)))
            ((and (or (have-feature 'enable-s32vector)
                      (not (have-feature 'disable-s32vector)))
                  (vector-all? s32? vect))
             (list->s32vector (vector->list vect)))
            (else
             vect)))

    (define (specialized-vector-length-op vect)
      (cond ((u8vector? vect)  '##u8vector-length)
            ((s8vector? vect)  '##s8vector-length)
            ((u16vector? vect) '##u16vector-length)
            ((s16vector? vect) '##s16vector-length)
            ((u32vector? vect) '##u32vector-length)
            ((s32vector? vect) '##s32vector-length)
            (else              '##vector-length)))

    (define (specialized-vector-ref-op vect)
      (cond ((u8vector? vect)  '##u8vector-ref)
            ((s8vector? vect)  '##s8vector-ref)
            ((u16vector? vect) '##u16vector-ref)
            ((s16vector? vect) '##s16vector-ref)
            ((u32vector? vect) '##u32vector-ref)
            ((s32vector? vect) '##s32vector-ref)
            (else              '##vector-ref)))

    ;; parsing of Unicode character database files

    (define (hex str default)
      (or (string->number str 16)
          default))

    (define (hex-list str)
      (let ((result
             (map (lambda (s) (hex s #f))
                  (call-with-input-string
                      str
                    (lambda (p)
                      (read-all p
                                (lambda (p)
                                  (read-line p #\space))))))))
        (if (member #f result)
            #f
            result)))

    (define (get-UnicodeData)
      (map (lambda (line)
             (call-with-input-string
                 line
               (lambda (port)
                 (list->vector
                  (read-all port
                            (lambda (p)
                              (read-line p #\;)))))))
           (call-with-input-file
               UnicodeData-path
             (lambda (port)
               (read-all port read-line)))))

    (define (get-PropList)
      (apply
       append
       (map (lambda (line)
              (if (or (= (string-length line) 0)
                      (char-whitespace? (string-ref line 0))
                      (char=? #\# (string-ref line 0)))
                  '()
                  (call-with-input-string
                      line
                    (lambda (port)
                      (let* ((codes
                              (call-with-input-string
                                  (read-line port #\;)
                                (lambda (port2)
                                  (call-with-input-string
                                      (read-line port2 #\space)
                                    (lambda (port3)
                                      (read-all port3
                                                (lambda (p)
                                                  (read-line p #\.))))))))
                             (space (read-line port #\space))
                             (class (read-line port #\space)))
                        (list
                         (vector (list-ref codes 0)
                                 (if (= 3 (length codes))
                                     (list-ref codes 2)
                                     (list-ref codes 0))
                                 class)))))))
            (call-with-input-file
                PropList-path
              (lambda (port)
                (read-all port read-line))))))

    (define (make-simple-full)
      (let ((simple-table (make-vector (+ 1 max-char-code)))
            (full-table (make-vector (+ 1 max-char-code) #f)))
        (let loop ((i 0))
          (if (<= i max-char-code)
              (begin
                (vector-set! simple-table i i)
                (loop (+ i 1)))))
        (cons simple-table full-table)))

    (define (get-CaseFolding)
      (apply
       append
       (map (lambda (line)
              (if (or (= (string-length line) 0)
                      (char-whitespace? (string-ref line 0))
                      (char=? #\# (string-ref line 0)))
                  '()
                  (call-with-input-string
                      line
                    (lambda (port)
                      (let* ((code    (read-line port #\;))
                             (space   (read-line port #\space))
                             (status  (read-line port #\;))
                             (space   (read-line port #\space))
                             (mapping (read-line port #\;)))
                        (list (vector code status mapping)))))))
            (call-with-input-file
                CaseFolding-path
              (lambda (port)
                (read-all port read-line))))))

    (define case-folding
      (let ((case-folding (make-simple-full)))
        (for-each
         (lambda (entry)
           (let ((code   (hex (vector-ref entry 0) #f))
                 (status (vector-ref entry 1)))
             (cond ((> code max-char-code))
                   ((member status '("C" "S"))
                    (let ((mapping (hex (vector-ref entry 2) #f)))
                      (vector-set! (car case-folding) code mapping)))
                   ((and support-full-case-folding?
                         (equal? status "F"))
                    (let ((mapping (hex-list (vector-ref entry 2))))
                      (vector-set! (cdr case-folding) code mapping))))))
         (get-CaseFolding))
        case-folding))

    (define props
      (let ((props-table (make-vector (+ 1 max-char-code) '())))
        (for-each
         (lambda (x)
           (let* ((code-lo  (min (+ 1 max-char-code) (hex (vector-ref x 0) #f)))
                  (code-hi  (min max-char-code (hex (vector-ref x 1) #f)))
                  (property (vector-ref x 2)))
             (if (<= code-lo code-hi)
                 (let loop ((code code-lo))
                   (if (<= code code-hi)
                       (begin
                         (vector-set! props-table
                                      code
                                      (cons property
                                            (vector-ref props-table code)))
                         (loop (+ code 1))))))))
         (get-PropList))
        props-table))

    ;; processing of Unicode character database

    (define (freq-to-index tbl start)

      (define (sort-by-decreasing-freq lst)
        (sort-list lst
                   (lambda (x y)
                     (> (cdr x) (cdr y)))))

      (let ((sorted (sort-by-decreasing-freq (table->list tbl))))
        (let loop1 ((i 0)
                    (lst sorted))
          (if (pair? lst)
              (let ((dists (car (car lst)))
                    (j (+ i start)))
                (table-set! tbl dists j)
                (vector-set! unicode-upcase-dist    j (vector-ref dists 0))
                (vector-set! unicode-downcase-dist  j (vector-ref dists 1))
                (vector-set! unicode-foldcase-dist  j (vector-ref dists 2))
                (vector-set! unicode-titlecase-dist j (vector-ref dists 3))
                (loop1 (+ i 1) (cdr lst)))))))

    (define (create-unicode-full-casing-info alist)
      (let ((has-full
             (make-vector (+ 1 max-char-code) #f))
            (alist
             (apply
              append
              (map (lambda (x)
                     (if (member #f (map (lambda (c) (<= c max-char-code)) x))
                         '()
                         (list x)))
                   alist))))
        (if (null? alist)
            (vector (vector #f 0 0 0) '() #f has-full)
            (let* ((dict
                    (create-int-dict alist))
                   (v
                    (vector-ref dict 0))
                   (n
                    (length (apply append (vector->list v))))
                   (mapping
                    (make-vector (max 1 n) 0))
                   (alloc
                    0)
                   (mapping-lengths
                    (let loop1 ((i 0) (lengths '()))
                      (if (< i (vector-length v))
                          (loop1 (+ i 1)
                                 (let ((x (vector-ref v i)))
                                   (if (pair? x)
                                       (let* ((m (cdr x))
                                              (mlen (length m)))
                                         (let loop2 ((lst (reverse m)))
                                           (if (pair? lst)
                                               (begin
                                                 (set! alloc (+ alloc 1))
                                                 (vector-set!
                                                  mapping
                                                  alloc
                                                  (car lst))
                                                 (loop2 (cdr lst)))))
                                         (vector-set! v i alloc)
                                         (set! alloc (+ alloc 1))
                                         (if (member mlen lengths)
                                             lengths
                                             (cons mlen lengths)))
                                       (begin
                                         (vector-set! v i 0)
                                         lengths))))
                          lengths))))
              (vector-set! dict 0 (specialize-vector v))
              (let loop ((lst alist))
                (if (pair? lst)
                    (let ((x (car lst)))
                      (vector-set! has-full (car x) #t)
                      (loop (cdr lst)))))
              (vector dict
                      (sort-list mapping-lengths <)
                      (specialize-vector mapping)
                      has-full)))))

    (define (create-int-dict alist)

      (define (create-simple-dict alist m salt)
        (let ((sd (make-vector m '())))
          (let loop ((lst alist))
            (if (pair? lst)
                (let* ((x (car lst))
                       (i (modulo (bitwise-xor (car x) salt) m)))
                  (and (null? (vector-ref sd i))
                       (begin
                         (vector-set! sd i x)
                         (loop (cdr lst)))))
                sd))))

      (define (empty-span-length vect start)
        (let loop ((i start))
          (if (and (< i (vector-length vect))
                   (null? (vector-ref vect i)))
              (loop (+ i 1))
              (- i start))))

      (define (compact-dict sd salt)
        (let* ((shift (empty-span-length sd 0))
               (m (vector-length sd))
               (shifted-sd
                (vector-append (subvector sd shift m)
                               (subvector sd 0 shift))))
          (let loop ((i 0) (best-i 0) (best-len 0))
            (if (< i m)
                (let ((len (empty-span-length shifted-sd i)))
                  (if (> len best-len)
                      (loop (+ (+ i 1) len) i len)
                      (loop (+ (+ i 1) len) best-i best-len)))
                (vector (vector-append
                         (subvector shifted-sd (+ best-i best-len) m)
                         (subvector shifted-sd 0 best-i))
                        salt
                        (modulo (- (+ shift (+ best-i best-len))) m)
                        m)))))

      (define (smallest-compact-dict alist)
        (let loop1 ((m (length alist)) (best-cd #f))
          (if (or (not best-cd)
                  (< m (* 2 (vector-ref best-cd 3))))
              (let loop2 ((m m) (salt 0) (best-cd best-cd))
                (if (< salt 32)
                    (loop2 m
                           (+ salt 1)
                           (let ((sd (create-simple-dict alist m salt)))
                             (if (not sd)
                                 best-cd
                                 (let ((cd (compact-dict sd salt)))
                                   (if (or (not best-cd)
                                           (< (vector-length
                                               (vector-ref cd 0))
                                              (vector-length
                                               (vector-ref best-cd 0))))
                                       cd
                                       best-cd)))))
                    (loop1 (+ m 1) best-cd)))
              best-cd)))

      (smallest-compact-dict alist))

    (define unicode-full-foldcase-info
      (create-unicode-full-casing-info
       (let loop ((i (- (vector-length (cdr case-folding)) 1))
                  (alist '()))
         (if (>= i 0)
             (loop (- i 1)
                   (let ((x (vector-ref (cdr case-folding) i)))
                     (if x
                         (cons (cons i x) alist)
                         alist)))
             alist))))

    (define (get-SpecialCasing)
      (apply
       append
       (map (lambda (line)
              (if (or (= (string-length line) 0)
                      (char-whitespace? (string-ref line 0))
                      (char=? #\# (string-ref line 0)))
                  '()
                  (call-with-input-string
                      line
                    (lambda (port)
                      (let* ((code       (read-line port #\;))
                             (space      (read-line port #\space))
                             (lc-mapping (read-line port #\;))
                             (space      (read-line port #\space))
                             (tc-mapping (read-line port #\;))
                             (space      (read-line port #\space))
                             (uc-mapping (read-line port #\;))
                             (space      (read-line port #\space))
                             (condition
                              (if (char=? #\# (peek-char port))
                                  #f
                                  (read-line port #\;))))
                        (list (vector code
                                      lc-mapping
                                      tc-mapping
                                      uc-mapping
                                      condition)))))))
            (call-with-input-file
                SpecialCasing-path
              (lambda (port)
                (read-all port read-line))))))

    (define special-casing
      (let ((special-casing
             (vector '()     ;; upcase
                     '()     ;; downcase
                     '())))  ;; titlecase
        (for-each
         (lambda (entry)

           (define (add code mapping casing)
             (if (not (and (pair? mapping)
                           (null? (cdr mapping))))
                 (vector-set! special-casing
                              casing
                              (cons (cons code mapping)
                                    (vector-ref special-casing
                                                casing)))))

           (let ((code       (hex (vector-ref entry 0) #f))
                 (lc-mapping (hex-list (vector-ref entry 1)))
                 (tc-mapping (hex-list (vector-ref entry 2)))
                 (uc-mapping (hex-list (vector-ref entry 3)))
                 (condition  (vector-ref entry 4)))
             (if (not condition) ;; ignore language specific mappings
                 (begin
                   (add code uc-mapping 0)
                   (add code lc-mapping 1)
                   (if support-title-case?
                       (add code tc-mapping 2))))))
         (get-SpecialCasing))
        special-casing))

    (define unicode-full-downcase-info
      (create-unicode-full-casing-info (vector-ref special-casing 1)))

    (define unicode-full-upcase-info
      (create-unicode-full-casing-info (vector-ref special-casing 0)))

    (define unicode-full-titlecase-info
      (create-unicode-full-casing-info (vector-ref special-casing 2)))

    (define range-start #f)

    (define (process-data entry encode)

      (let* ((code                       (hex (vector-ref entry 0) #f))
             (entry                      (substitute entry code))
             (Name                       (vector-ref entry 1))
             (General_Category           (string->symbol (vector-ref entry 2)))
             (Canonical_Combining_Class  (vector-ref entry 3))
             (Bidi_Class                 (vector-ref entry 4))
             (Decomposition_Type_Mapping (vector-ref entry 5))
             (Numeric_Value_Decimal      (vector-ref entry 6))
             (Numeric_Value_Digit        (vector-ref entry 7))
             (Numeric_Value_Numeric      (vector-ref entry 8))
             (Bidi_Mirrored              (vector-ref entry 9))
             (Unicode_1_Name             (vector-ref entry 10))
             (ISO_Comment                (vector-ref entry 11))
             (Simple_Uppercase_Mapping   (vector-ref entry 12))
             (Simple_Lowercase_Mapping   (vector-ref entry 13))
             (Simple_Titlecase_Mapping   (if (< (vector-length entry) 15)
                                             ""
                                             (vector-ref entry 14))))

        (define (letter code table dists)
          (if encode
              (enc code (table-ref table dists))
              (table-set! table dists (+ 1 (table-ref table dists 0)))))

        (define (enc code x)
          (vector-set! encode code x))

        (define (compute-dist code simple info)
          (let ((dist (- simple code)))
            (if (null? (vector-ref info 1)) ;; 1-to-1 mapping?
                dist
                (+ (* 2 dist)
                   (if (vector-ref (vector-ref info 3) code)
                       1
                       0)))))

        (define (setup code)
          (if (<= code max-char-code)
              (let* ((prop
                      (vector-ref props code))
                     (uppercase?
                      (or (eq? General_Category 'Lu)
                          (member "Other_Uppercase" prop)))
                     (lowercase?
                      (or (eq? General_Category 'Ll)
                          (member "Other_Lowercase" prop)))
                     (titlecase?
                      (and support-title-case?
                           (eq? General_Category 'Lt)))
                     (alphabetic?
                      (or uppercase?
                          lowercase?
                          titlecase?
                          (memq General_Category '(Lm Lo Nl))
                          (member "Other_Alphabetic" prop)))
                     (whitespace?
                      (member "White_Space" prop)))

                ;; This is the definition of each Scheme character set:

                (if (not encode)
                    (begin

                      (cond (whitespace?
                             (char-set-add! char-set:whitespace code))

                            (alphabetic?
                             (cond (lowercase?
                                    (char-set-add! char-set:lower-case code))
                                   (uppercase?
                                    (char-set-add! char-set:upper-case code))
                                   (titlecase?
                                    (char-set-add! char-set:title-case code)))
                             (char-set-add! char-set:letter code)
                             (char-set-add! char-set:letter+digit code))

                            ((eq? General_Category 'Nd)
                             (char-set-add! char-set:digit code)
                             (char-set-add! char-set:letter+digit code)))

                      (if (memq General_Category punctuation-categories)
                          (char-set-add! char-set:punctuation code))

                      (if (memq General_Category symbol-categories)
                          (char-set-add! char-set:symbol code))

                      (if (or (eq? General_Category 'Zs)
                              (= code 9)) ;; tab
                          (char-set-add! char-set:blank code))

                      (if (not (memq General_Category control-categories))
                          (begin
                            (char-set-add! char-set:printing code)
                            (if (not whitespace?)
                                (char-set-add! char-set:graphic code)))
                          (if whitespace?
                              (char-set-add! char-set:printing code)))

                      (if (or (<= code #x1f)
                              (and (>= code #x7f) (<= code #x9f)))
                          (char-set-add! char-set:iso-control code))

                      (if (or (and (>= code #x30) (<= code #x39))
                              (and (>= code #x41) (<= code #x46))
                              (and (>= code #x61) (<= code #x66)))
                          (char-set-add! char-set:hex-digit code))

                      (if (<= code #x7f)
                          (char-set-add! char-set:ascii code))))

                (cond (alphabetic?
                       (let* ((upper (hex Simple_Uppercase_Mapping code))
                              (lower (hex Simple_Lowercase_Mapping code))
                              (title (if support-title-case?
                                         (hex Simple_Titlecase_Mapping upper)
                                         code))
                              (upper-dist (compute-dist
                                           code
                                           upper
                                           unicode-full-upcase-info))
                              (lower-dist (compute-dist
                                           code
                                           lower
                                           unicode-full-downcase-info))
                              (title-dist (compute-dist
                                           code
                                           title
                                           unicode-full-titlecase-info))
                              (fold-dist (compute-dist
                                          code
                                          (vector-ref (car case-folding) code)
                                          unicode-full-foldcase-info))
                              (dists
                               (vector upper-dist
                                       lower-dist
                                       fold-dist
                                       title-dist)))
                         (cond (uppercase?
                                (letter code upper-dist-table dists))
                               (lowercase?
                                (letter code lower-dist-table dists))
                               (titlecase?
                                (letter code title-dist-table dists))
                               (else
                                (letter code other-dist-table dists)))))
                      ((not encode))
                      ((not (equal? Numeric_Value_Decimal ""))
                       ;; (eq? General_Category 'Nd)
                       (enc code
                            (+ digit-class-start
                               (modulo (string->number Numeric_Value_Decimal)
                                       10))))
                      (whitespace?
                       (enc code whitespace-class-start))
                      (else
                       (enc code
                            (table-ref notable-categories-table
                                       General_Category
                                       no-class)))))))

        (cond ((suffix=? Name ", First>")
               (set! range-start code))
              ((not (suffix=? Name ", Last>"))
               (setup code))
              (else
               (if (eq? General_Category 'Lo)
                   (let loop ((i range-start))
                     (if (<= i code)
                         (begin
                           (setup i)
                           (loop (+ i 1))))))
               (set! range-start #f)))))

    (define (suffix=? str suffix)
      (let ((len (string-length str)))
        (and (>= len (string-length suffix))
             (string=? (substring str (- len (string-length suffix)) len)
                       suffix))))

    (define (determine-casing-distances UnicodeData)

      (for-each (lambda (entry) (process-data entry #f)) UnicodeData)

      (set! other-class-start    alphabetic-class-start)
      (set! other-class-end      (+ other-class-start
                                    (table-length other-dist-table)))
      (set! upper-class-start    other-class-end)
      (set! upper-class-end      (+ upper-class-start
                                    (table-length upper-dist-table)))
      (set! title-class-start    upper-class-end)
      (set! title-class-end      (+ title-class-start
                                    (table-length title-dist-table)))
      (set! lower-class-start    title-class-end)
      (set! lower-class-end      (+ lower-class-start
                                    (table-length lower-dist-table)))
      (set! alphabetic-class-end lower-class-end)

      (set! char-set:lower-case   (char-set-end char-set:lower-case))
      (set! char-set:upper-case   (char-set-end char-set:upper-case))
      (set! char-set:title-case   (char-set-end char-set:title-case))
      (set! char-set:letter       (char-set-end char-set:letter))
      (set! char-set:digit        (char-set-end char-set:digit))
      (set! char-set:letter+digit (char-set-end char-set:letter+digit))
      (set! char-set:graphic      (char-set-end char-set:graphic))
      (set! char-set:printing     (char-set-end char-set:printing))
      (set! char-set:whitespace   (char-set-end char-set:whitespace))
      (set! char-set:iso-control  (char-set-end char-set:iso-control))
      (set! char-set:punctuation  (char-set-end char-set:punctuation))
      (set! char-set:symbol       (char-set-end char-set:symbol))
      (set! char-set:hex-digit    (char-set-end char-set:hex-digit))
      (set! char-set:blank        (char-set-end char-set:blank))
      (set! char-set:ascii        (char-set-end char-set:ascii))


      '
      (pp (list (list 'other-class-start other-class-start)
                (list 'upper-class-start upper-class-start)
                (list 'title-class-start title-class-start)
                (list 'lower-class-start lower-class-start)
                (list 'alphabetic-class-end alphabetic-class-end)))

      (set! unicode-upcase-dist    (make-vector alphabetic-class-end 0))
      (set! unicode-titlecase-dist (make-vector alphabetic-class-end 0))
      (set! unicode-downcase-dist  (make-vector alphabetic-class-end 0))
      (set! unicode-foldcase-dist  (make-vector alphabetic-class-end 0))

      (freq-to-index other-dist-table other-class-start)
      (freq-to-index upper-dist-table upper-class-start)
      (freq-to-index title-dist-table title-class-start)
      (freq-to-index lower-dist-table lower-class-start))

    (define (create-unicode-class)
      (let ((UnicodeData (get-UnicodeData)))

        (determine-casing-distances UnicodeData)

        (let ((table (make-vector (+ 1 max-char-code) no-class)))

          (for-each (lambda (entry) (process-data entry table)) UnicodeData)

          (let ((hi-limit
                 (let loop ((i max-char-code))
                   (if (= (vector-ref table i) no-class)
                       (loop (- i 1))
                       i))))
            (subvector table 0 (+ hi-limit 1))))))

    ;; generate macro definitions that depend on Unicode character database

    (let* ((unicode-class
            (specialize-vector (create-unicode-class)))

           (unicode-upcase-dist
            (specialize-vector unicode-upcase-dist))

           (unicode-downcase-dist
            (specialize-vector unicode-downcase-dist))

           (unicode-foldcase-dist
            (specialize-vector unicode-foldcase-dist))

           (unicode-titlecase-dist
            (specialize-vector unicode-titlecase-dist))

           (unicode-full-foldcase-start
            (vector-ref (vector-ref unicode-full-foldcase-info 0) 0))
           (unicode-full-foldcase-mapping
            (vector-ref unicode-full-foldcase-info 2)))

      (define (sym . lst)
        (string->symbol (apply string-append (map symbol->string lst))))

      (define extra-unicode-tables-definitions
        `())

      (define (gen-mapping-definitions name dist info)

        (set! extra-unicode-tables-definitions
          (append
           (if (null? (vector-ref info 1)) ;; 1 to 1 mapping?
               '()
               `((define ,(sym '##unicode-full- name '-mapping)
                   ',(vector-ref info 2))
                 (define ,(sym '##unicode-full- name '-start)
                   ,(vector-ref (vector-ref info 0) 0))))
           `((define ,(sym '##unicode- name '-dist) ',dist))
           extra-unicode-tables-definitions))

        (let ((start
               (vector-ref (vector-ref info 0) 0))
              (mapping-lengths
               (vector-ref info 1))
              (mapping
               (vector-ref info 2)))
          `((define-macro (,(sym 'macro-full- name '-salt))
              ,(vector-ref (vector-ref info 0) 1))

            (define-macro (,(sym 'macro-full- name '-offset))
              ,(vector-ref (vector-ref info 0) 2))

            (define-macro (,(sym 'macro-full- name '-mod))
              ,(vector-ref (vector-ref info 0) 3))

            (define-macro (,(sym 'macro-full- name '-mapping-length) var)
              ,(if (null? mapping-lengths)
                   1  ;; when mapping is always 1 to 1, length is always 1
                   (list 'quasiquote
                         (let ()

                           (define (gen mapping-lengths)
                             (if (pair? mapping-lengths)
                                 (let ((mlen (car mapping-lengths)))
                                   (if (null? (cdr mapping-lengths))
                                       mlen
                                       `(if (##fx=
                                             0
                                             (,(sym 'macro-full- name '-mapping)
                                              (##fx- ,',var ,mlen)))
                                            ,mlen
                                            ,(gen (cdr mapping-lengths)))))
                                 1))

                           (gen mapping-lengths)))))

            (define-macro (,(sym 'macro-full- name '-start) code)
              `(,',(specialized-vector-ref-op start)
                ,',(sym '##unicode-full- name '-start)
                (##fxmodulo
                 (##fx+
                  (##fxxor ,code (,',(sym 'macro-full- name '-salt)))
                  (,',(sym 'macro-full- name '-offset)))
                 (,',(sym 'macro-full- name '-mod)))))

            (define-macro (,(sym 'macro-full- name '-mapping) i)
              `(,',(specialized-vector-ref-op mapping)
                ,',(sym '##unicode-full- name '-mapping)
                ,i))

            (define-macro (,(sym 'macro- name '-dist) class)
              `(,',(specialized-vector-ref-op dist)
                ,',(sym '##unicode- name '-dist)
                ,class))

            (define-macro (,(sym 'macro- name '-dist-simple) class)
              ,(if (null? mapping-lengths)
                   ``(,',(sym 'macro- name '-dist) ,class)
                   (if (eq? name 'foldcase)
                       ``(let ((dist (,',(sym 'macro- name '-dist) ,class)))
                           (if (##fxeven? dist)
                               (##fxarithmetic-shift-right dist 1)
                               0))
                       ``(##fxarithmetic-shift-right
                          (,',(sym 'macro- name '-dist) ,class)
                          1))))

            (define-macro (,(sym 'macro-char- name) c)
              `(macro-let-char-class-with-default
                ,c c code class
                c
                (##integer->char
                 (##fx+ code
                        (,',(sym 'macro- name '-dist-simple) class)))))

            (define-macro (,(sym 'macro-string- name) str start end)
              ,(if (null? mapping-lengths)

                   ;; when mapping is always 1 to 1, use simple loop
                   ``(let ((str ,str)
                           (start ,start)
                           (end ,end))

                       (let* ((len (##fx- end start))
                              (result (##make-string len)))
                         (let loop ((i (##fx- len 1)))
                           (if (##fx< i 0)
                               result
                               (begin
                                 (##string-set!
                                  result
                                  i
                                  (,',(sym 'macro-char- name)
                                   (##string-ref str i)))
                                 (loop (##fx- i 1)))))))

                   ;; when mapping is not always 1 to 1, compute result length
                   ``(let ((str ,str)
                           (start ,start)
                           (end ,end))

                       (define (length-loop i len)
                         (if (##fx>= i end)
                             len
                             (macro-let-char-class
                              (##string-ref str i) c code class
                              (let ((dist (,',(sym 'macro- name '-dist) class)))
                                (if (##fxeven? dist)
                                    (length-loop
                                     (##fx+ i 1)
                                     (##fx+ len 1))
                                    (length-loop
                                     (##fx+ i 1)
                                     (##fx+ len
                                            (let ((m (,',(sym 'macro-full- name '-start) code)))
                                              (,',(sym 'macro-full- name '-mapping-length) m)))))))))

                       (define (transform-loop result i j)
                         (if (##fx>= i end)
                             result
                             (macro-let-char-class
                              (##string-ref str i) c code class
                              (let ((dist (,',(sym 'macro- name '-dist) class)))
                                (if (##fxeven? dist)
                                    (begin
                                      (##string-set!
                                       result
                                       j
                                       (##integer->char
                                        (##fx+ code
                                               (##fxarithmetic-shift-right dist 1))))
                                      (transform-loop
                                       result
                                       (##fx+ i 1)
                                       (##fx+ j 1)))
                                    (let loop ((m (,',(sym 'macro-full- name '-start) code))
                                               (j j))
                                      (let ((code* (,',(sym 'macro-full- name '-mapping) m)))
                                        (if (##fx= 0 code*)
                                            (transform-loop
                                             result
                                             (##fx+ i 1)
                                             j)
                                            (begin
                                              (##string-set!
                                               result
                                               j
                                               (##integer->char code*))
                                              (loop (##fx- m 1) (##fx+ j 1)))))))))))

                       (transform-loop (##make-string (length-loop start 0))
                                       start
                                       0)))))))

      (define upcase-definitions
        (gen-mapping-definitions 'upcase
                                 unicode-upcase-dist
                                 unicode-full-upcase-info))

      (define downcase-definitions
        (gen-mapping-definitions 'downcase
                                 unicode-downcase-dist
                                 unicode-full-downcase-info))

      (define foldcase-definitions
        (gen-mapping-definitions 'foldcase
                                 unicode-foldcase-dist
                                 unicode-full-foldcase-info))

      (define titlecase-definitions
        (if support-title-case?
            (gen-mapping-definitions 'titlecase
                                     unicode-titlecase-dist
                                     unicode-full-titlecase-info)
            '()))

      (define (gen-class-range-test lo hi)
        (cond ((<= hi lo)
               #f)
              ((= lo 0)
               `(##fx< class ,hi))
              ((= hi alphabetic-class-end)
               `(##fx>= class ,lo))
              ((= lo (- hi 1))
               `(##fx= class ,lo))
              (else
               `(and (##fx>= class ,lo)
                     (##fx< class ,hi)))))

      (define (gen-char-set-definition name boundaries complement? lo hi)

        ;; prevent char-set boundaries that start with 0
        (if (and (pair? boundaries)
                 (eqv? 0 (car boundaries)))
            (begin
              (set! boundaries (cdr boundaries))
              (set! complement? (not complement?))
              (set! lo 0)
              (set! hi 0)))

        `(define ,(sym '|##| name)
           (macro-make-constant-char-set
            ,(list->u32vector boundaries)
            ,(+ (* (+ (* hi 256) lo) 2) (if complement? 1 0)))))

      (define (char-set-definitions)
        (list
         (gen-char-set-definition 'char-set:lower-case
                                  char-set:lower-case
                                  #f
                                  lower-class-start
                                  lower-class-end)
         (gen-char-set-definition 'char-set:upper-case
                                  char-set:upper-case
                                  #f
                                  upper-class-start
                                  upper-class-end)
         (gen-char-set-definition 'char-set:title-case
                                  char-set:title-case
                                  #f
                                  title-class-start
                                  title-class-end)
         (gen-char-set-definition 'char-set:letter
                                  char-set:letter
                                  #f
                                  alphabetic-class-start
                                  alphabetic-class-end)
         (gen-char-set-definition 'char-set:digit
                                  char-set:digit
                                  #f
                                  digit-class-start
                                  digit-class-end)
         (gen-char-set-definition 'char-set:letter+digit
                                  char-set:letter+digit
                                  #f
                                  digit-class-start
                                  alphabetic-class-end)
         (gen-char-set-definition 'char-set:graphic
                                  char-set:graphic
                                  #f
                                  0
                                  0)
         (gen-char-set-definition 'char-set:printing
                                  char-set:printing
                                  #f
                                  0
                                  0)
         (gen-char-set-definition 'char-set:whitespace
                                  char-set:whitespace
                                  #f
                                  whitespace-class-start
                                  whitespace-class-end)
         (gen-char-set-definition 'char-set:iso-control
                                  char-set:iso-control
                                  #f
                                  0
                                  0)
         (gen-char-set-definition 'char-set:punctuation
                                  char-set:punctuation
                                  #f
                                  punctuation-class-start
                                  punctuation-class-end)
         (gen-char-set-definition 'char-set:symbol
                                  char-set:symbol
                                  #f
                                  0
                                  0)
         (gen-char-set-definition 'char-set:hex-digit
                                  char-set:hex-digit
                                  #f
                                  0
                                  0)
         (gen-char-set-definition 'char-set:blank
                                  char-set:blank
                                  #f
                                  0
                                  0)
         (gen-char-set-definition 'char-set:ascii
                                  char-set:ascii
                                  #f
                                  0
                                  0)
         (gen-char-set-definition 'char-set:empty
                                  '()
                                  #f
                                  1
                                  1)
         (gen-char-set-definition 'char-set:full
                                  '()
                                  #t
                                  1
                                  1)))

      `(begin

         (define-macro (macro-define-unicode-tables)
           `(begin

              (define ##unicode-class
                ',',unicode-class)

              ,@',(reverse extra-unicode-tables-definitions)))

         (define-macro (macro-define-standard-char-sets)
           `(begin
              ,@',(char-set-definitions)))

         (define-macro (macro-whitespace-class-start)
           ,whitespace-class-start)

         (define-macro (macro-whitespace-class-end)
           ,whitespace-class-end)

         (define-macro (macro-no-class)
           ,no-class)

         (define-macro (macro-punctuation-class-start)
           ,(table-ref notable-categories-table (car punctuation-categories)))

         ,@(map (lambda (c)
                  `(define-macro (,(sym 'macro- c '-class))
                     ,(table-ref notable-categories-table c)))
                punctuation-categories)

         (define-macro (macro-punctuation-class-end)
           ,(+ 1 (table-ref notable-categories-table (last punctuation-categories))))

         (define-macro (macro-digit-class-start) ,digit-class-start)
         (define-macro (macro-digit-class-end)   ,digit-class-end)

         (define-macro (macro-alphabetic-class-start)
           ,alphabetic-class-start)

         (define-macro (macro-other-class-start) ,other-class-start)
         (define-macro (macro-other-class-end)   ,other-class-end)
         (define-macro (macro-upper-class-start) ,upper-class-start)
         (define-macro (macro-upper-class-end)   ,upper-class-end)
         (define-macro (macro-title-class-start) ,title-class-start)
         (define-macro (macro-title-class-end)   ,title-class-end)
         (define-macro (macro-lower-class-start) ,lower-class-start)
         (define-macro (macro-lower-class-end)   ,lower-class-end)

         (define-macro (macro-alphabetic-class-end)
           ,alphabetic-class-end)

         ,@upcase-definitions
         ,@downcase-definitions
         ,@foldcase-definitions
         ,@titlecase-definitions

         (define-macro (macro-let-char-class
                        char
                        char-var
                        code-var
                        class-var
                        .
                        body)
           `(let ((,char-var ,char))
              (let ((,code-var (##char->integer ,char-var)))
                (let ((,class-var
                       (if (##fx< ,code-var
                                  (,',(specialized-vector-length-op unicode-class)
                                   ##unicode-class))
                           (,',(specialized-vector-ref-op unicode-class)
                            ##unicode-class
                            ,code-var)
                           (macro-no-class))))
                  ,@body))))

         (define-macro (macro-let-char-class-with-default
                        char
                        char-var
                        code-var
                        class-var
                        default
                        .
                        body)
           `(let ((,char-var ,char))
              (let ((,code-var (##char->integer ,char-var)))
                (if (##fx< ,code-var
                           (,',(specialized-vector-length-op unicode-class)
                            ##unicode-class))
                    (let ((,class-var
                           (,',(specialized-vector-ref-op unicode-class)
                            ##unicode-class
                            ,code-var)))
                      ,@body)
                    ,default))))

         (define-macro (macro-char-numeric? c)
           `(macro-let-char-class-with-default
             ,c c code class
             #f
             ,',(gen-class-range-test digit-class-start
                                      digit-class-end)))

         (define-macro (macro-char-whitespace? c)
           `(macro-let-char-class-with-default
             ,c c code class
             #f
             ,',(gen-class-range-test whitespace-class-start
                                      whitespace-class-end)))

         (define-macro (macro-char-alphabetic? c)
           `(macro-let-char-class-with-default
             ,c c code class
             #f
             ,',(gen-class-range-test alphabetic-class-start
                                      alphabetic-class-end)))

         (define-macro (macro-char-lower-case? c)
           `(macro-let-char-class-with-default
             ,c c code class
             #f
             ,',(gen-class-range-test lower-class-start
                                      lower-class-end)))

         (define-macro (macro-char-upper-case? c)
           `(macro-let-char-class-with-default
             ,c c code class
             #f
             ,',(gen-class-range-test upper-class-start
                                      upper-class-end)))

         (define-macro (macro-char-title-case? c)
           `(macro-let-char-class-with-default
             ,c c code class
             #f
             ,',(gen-class-range-test title-class-start
                                      title-class-end)))

         (define-macro (macro-digit-value c)
           `(macro-let-char-class-with-default
             ,c c code class
             #f
             (if ,',(gen-class-range-test digit-class-start
                                          digit-class-end)
                 (##fx- class (macro-digit-class-start))
                 #f)))

         (define-macro (macro-string-cmp str1 str2 start1 end1 start2 end2)
           `(let ((str1 ,str1)
                  (str2 ,str2)
                  (start1 ,start1)
                  (end1 ,end1)
                  (start2 ,start2)
                  (end2 ,end2))

              (define (loop i1 i2)
                (if (##fx>= i1 end1) ;; str1 end?
                    (if (##fx>= i2 end2) ;; str2 end?
                        0   ;; str1 = str2
                        -1) ;; str1 < str2
                    (if (##fx>= i2 end2) ;; str2 end?
                        +1  ;; str1 > str2
                        (let ((c1 (##string-ref str1 i1))
                              (c2 (##string-ref str2 i2)))
                          (if (##char=? c1 c2)
                              (loop (##fx+ i1 1) (##fx+ i2 1))
                              (if (##char<? c1 c2)
                                  -1       ;; str1 < str2
                                  +1)))))) ;; str1 > str2

              (loop start1 start2)))

         (define-macro (macro-string-cmp-ci str1 str2 start1 end1 start2 end2)
           `(let ((str1 ,str1)
                  (str2 ,str2)
                  (start1 ,start1)
                  (end1 ,end1)
                  (start2 ,start2)
                  (end2 ,end2))

              (define (compare-simp-simp i1 i2 code1 code2)
                (if (##fx= code1 code2)
                    (loop-simp-simp i1 i2)
                    (if (##fx< code1 code2)
                        -1    ;; str1 < str2
                        +1))) ;; str1 > str2

              (define (loop-simp-simp i1 i2)
                (if (##fx>= i1 end1) ;; str1 end?
                    (if (##fx>= i2 end2) ;; str2 end?
                        0   ;; str1 = str2
                        -1) ;; str1 < str2
                    (if (##fx>= i2 end2) ;; str2 end?
                        +1  ;; str1 > str2
                        (macro-let-char-class
                         (##string-ref str1 i1) c1 code1 class1
                         (macro-let-char-class
                          (##string-ref str2 i2) c2 code2 class2
                          (let ((dist1 (macro-foldcase-dist class1))
                                (dist2 (macro-foldcase-dist class2)))
                            ,',(if (null? (vector-ref ;; 1 to 1 mapping
                                           unicode-full-foldcase-info
                                           1))
                                   `(compare-simp-simp
                                     (##fx+ i1 1)
                                     (##fx+ i2 1)
                                     (##fx+ code1 dist1)
                                     (##fx+ code2 dist2))
                                   `(if (##fxeven? dist1)
                                        (if (##fxeven? dist2)
                                            (compare-simp-simp
                                             (##fx+ i1 1)
                                             (##fx+ i2 1)
                                             (##fx+ code1
                                                    (##fxarithmetic-shift-right
                                                     dist1
                                                     1))
                                             (##fx+ code2
                                                    (##fxarithmetic-shift-right
                                                     dist2
                                                     1)))
                                            (let* ((m2
                                                    (macro-full-foldcase-start
                                                     code2))
                                                   (code2*
                                                    (macro-full-foldcase-mapping
                                                     m2)))
                                              (compare-simp-spec
                                               (##fx+ i1 1)
                                               (##fx+ i2 1)
                                               (##fx- m2 1)
                                               (##fx+ code1
                                                      (##fxarithmetic-shift-right
                                                       dist1
                                                       1))
                                               code2*)))
                                        (let* ((m1
                                                (macro-full-foldcase-start
                                                 code1))
                                               (code1*
                                                (macro-full-foldcase-mapping
                                                 m1)))
                                          (if (##fxeven? dist2)
                                              (compare-spec-simp
                                               (##fx+ i1 1)
                                               (##fx+ i2 1)
                                               (##fx- m1 1)
                                               code1*
                                               (##fx+ code2
                                                      (##fxarithmetic-shift-right
                                                       dist2
                                                       1)))
                                              (let* ((m2
                                                      (macro-full-foldcase-start
                                                       code2))
                                                     (code2*
                                                      (macro-full-foldcase-mapping
                                                       m2)))
                                                (compare-spec-spec
                                                 (##fx+ i1 1)
                                                 (##fx+ i2 1)
                                                 (##fx- m1 1)
                                                 (##fx- m2 1)
                                                 code1*
                                                 code2*))))))))))))

              (define (compare-spec-simp i1 i2 m1 code1 code2)
                (if (##fx= code1 code2)
                    (loop-spec-simp i1 i2 m1)
                    (if (##fx< code1 code2)
                        -1    ;; str1 < str2
                        +1))) ;; str1 > str2

              (define (loop-spec-simp i1 i2 m1)
                (let ((code1 (macro-full-foldcase-mapping m1)))
                  (if (##fx= code1 0) ;; end of str1 special casing mapping?
                      (loop-simp-simp i1 i2)
                      (if (##fx>= i2 end2) ;; str2 end?
                          +1 ;; str1 > str2
                          (macro-let-char-class
                           (##string-ref str2 i2) c2 code2 class2
                           (let ((dist2 (macro-foldcase-dist class2)))
                             (if (##fxeven? dist2)
                                 (compare-spec-simp
                                  i1
                                  (##fx+ i2 1)
                                  (##fx- m1 1)
                                  code1
                                  (##fx+ code2
                                         (##fxarithmetic-shift-right dist2 1)))
                                 (let* ((m2
                                         (macro-full-foldcase-start code2))
                                        (code2*
                                         (macro-full-foldcase-mapping m2)))
                                   (compare-spec-spec
                                    i1
                                    (##fx+ i2 1)
                                    (##fx- m1 1)
                                    (##fx- m2 1)
                                    code1
                                    code2*)))))))))

              (define (compare-simp-spec i1 i2 m2 code1 code2)
                (if (##fx= code1 code2)
                    (loop-simp-spec i1 i2 m2)
                    (if (##fx< code1 code2)
                        -1    ;; str1 < str2
                        +1))) ;; str1 > str2

              (define (loop-simp-spec i1 i2 m2)
                (let ((code2 (macro-full-foldcase-mapping m2)))
                  (if (##fx= code2 0) ;; end of str2 special casing mapping?
                      (loop-simp-simp i1 i2)
                      (if (##fx>= i1 end1) ;; str1 end?
                          -1 ;; str1 < str2
                          (macro-let-char-class
                           (##string-ref str1 i1) c1 code1 class1
                           (let ((dist1 (macro-foldcase-dist class1)))
                             (if (##fxeven? dist1)
                                 (compare-simp-spec
                                  (##fx+ i1 1)
                                  i2
                                  (##fx- m2 1)
                                  (##fx+ code1
                                         (##fxarithmetic-shift-right dist1 1))
                                  code2)
                                 (let* ((m1
                                         (macro-full-foldcase-start code1))
                                        (code1*
                                         (macro-full-foldcase-mapping m1)))
                                   (compare-spec-spec
                                    (##fx+ i1 1)
                                    i2
                                    (##fx- m1 1)
                                    (##fx- m2 1)
                                    code1*
                                    code2)))))))))

              (define (compare-spec-spec i1 i2 m1 m2 code1 code2)
                (if (##fx= code1 code2)
                    (loop-spec-spec i1 i2 m1 m2)
                    (if (##fx< code1 code2)
                        -1    ;; str1 < str2
                        +1))) ;; str1 > str2

              (define (loop-spec-spec i1 i2 m1 m2)
                (let* ((code1 (macro-full-foldcase-mapping m1))
                       (code2 (macro-full-foldcase-mapping m2)))
                  (if (##fx= code1 0) ;; end of str1 special casing mapping?
                      (if (##fx= code2 0) ;; end of str2 special casing mapping?
                          (loop-simp-simp i1 i2)
                          (loop-simp-spec i1 i2 m2))
                      (if (##fx= code2 0) ;; end of str2 special casing mapping?
                          (loop-spec-simp i1 i2 m1)
                          (compare-spec-spec
                           i1
                           i2
                           (##fx- m1 1)
                           (##fx- m2 1)
                           code1
                           code2)))))

              (loop-simp-simp start1 start2)))))))

(macro-define-macros-from-unicode-files #f)

;;; Representation of character sets.

;; A char-set has two fields:
;;
;; - boundaries        A u32vector containing the in-out boundaries of the set,
;;                     which is an ordered sequence of all the character codes
;;                     for which the inclusion in the set is different from the
;;                     valid code point immediately preceding it. The sequence
;;                     is constrained to never start with the character
;;                     code 0 and to never contain the code #xd800 (this
;;                     is to guarantee uniqueness of the representation).
;;
;; - hi-lo-complement  Fixnum that combines an 8 bit hi field (bits 9 to 16)
;;                     an 8 bit lo field (bits 1 to 8),
;;                     and a 1 bit complement field (bit 0, the lowest bit).
;;                     The complement field indicates whether the set is
;;                     complemented (1) or not (0).
;;                     When lo=hi=0, only the boundaries field is relevant.
;;                     Otherwise, the hi and lo fields are an alternate
;;                     representation of the char-set that is redundant with
;;                     the boundaries field but quicker to access for
;;                     membership testing. The range lo..hi-1 are the
;;                     values of (u8vector-ref ##unicode-class code)
;;                     indicating membership in the (non-complemented)
;;                     char-set.

(define-type char-set
  id: E15F8CD7-7FF3-4C21-82B9-4355062C112F
  type-exhibitor: macro-type-char-set
  constructor: macro-make-char-set
  constant-constructor: macro-make-constant-char-set
  implementer: implement-type-char-set
  macros:
  prefix: macro-
  opaque:

  (boundaries       unprintable: read-write:)
  (hi-lo-complement unprintable: read-write:)
)

(define-check-type char-set (macro-type-char-set)
  macro-char-set?)

;;;============================================================================
