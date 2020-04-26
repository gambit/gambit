;;;============================================================================

;;; File: "char#.scm"

;;; Copyright (c) 2018-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Character operations.

;;;----------------------------------------------------------------------------

;; The latest Unicode tables are available here:
;;
;; https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
;; https://www.unicode.org/Public/UCD/latest/ucd/PropList.txt
;; https://www.unicode.org/Public/UCD/latest/ucd/CaseFolding.txt
;;
;; This directory contains a copy, which can be updated when new versions
;; become available.
;;
;; The tables define various character properties (used in the
;; definition of char-alphabetic, char-lower-case?, etc), as follows:
;;
;; Alphabetic = Lowercase + Uppercase + Lt + Lm + Lo + Nl + Other_Alphabetic
;; Lowercase  = Ll + Other_Lowercase
;; Uppercase  = Lu + Other_Uppercase
;;
;; UnicodeData.txt defines Ll, Lu, Lt, Lm, Lo, Nl
;;
;; PropList.txt defines Other_Alphabetic, Other_Lowercase, Other_Uppercase,
;; and White_Space
;;
;; CaseFolding.txt defines the simple and full case folding mappings
;; (used in the definition of char-foldcase and string-foldcase)

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

(macro-define-syntax macro-define-unicode-tables
  (lambda (src)

    (define max-char (or (##deconstruct-call src 2 ##desourcify)
                         ##max-char))

    (define this-dir (path-directory (##source-path src)))

    (define UnicodeData-path (path-expand "UnicodeData.txt" this-dir))
    (define PropList-path    (path-expand "PropList.txt"    this-dir))
    (define CaseFolding-path (path-expand "CaseFolding.txt" this-dir))

    (define support-title-case?        #t)
    (define support-full-case-folding? #t)

    (define digit-class-end        10)
    (define no-class               digit-class-end)
    (define whitespace-class       (+ 1 no-class))
    (define alphabetic-class-start (+ 1 whitespace-class))

    (define other-class-start    #f)
    (define upper-class-start    #f)
    (define title-class-start    #f)
    (define lower-class-start    #f)
    (define alphabetic-class-end #f)

    (define other-dist-table (make-table))
    (define upper-dist-table (make-table))
    (define title-dist-table (make-table))
    (define lower-dist-table (make-table))

    (define unicode-upcase-dist    #f)
    (define unicode-titlecase-dist #f)
    (define unicode-downcase-dist  #f)
    (define unicode-foldcase-dist  #f)

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

    (define (specialize-vector vect)
      (cond ((vector-all? u8? vect)  (list->u8vector  (vector->list vect)))
            ((vector-all? s8? vect)  (list->s8vector  (vector->list vect)))
            ((vector-all? u16? vect) (list->u16vector (vector->list vect)))
            ((vector-all? s16? vect) (list->s16vector (vector->list vect)))
            ((vector-all? u32? vect) (list->u32vector (vector->list vect)))
            ((vector-all? s32? vect) (list->s32vector (vector->list vect)))
            (else                    vect)))

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
      (let ((simple-table (make-vector (+ max-char 1)))
            (full-table (make-vector (+ max-char 1) #f)))
        (let loop ((i 0))
          (if (<= i max-char)
              (begin
                (vector-set! simple-table i i)
                (loop (+ i 1)))))
        (for-each
         (lambda (entry)
           (let ((code   (hex (vector-ref entry 0) #f))
                 (status (vector-ref entry 1)))
             (cond ((> code max-char))
                   ((member status '("C" "S"))
                    (let ((mapping (hex (vector-ref entry 2) #f))
                          (s (vector-ref simple-table code)))
                      (vector-set! simple-table code mapping)))
                   ((and support-full-case-folding?
                         (equal? status "F"))
                    (let ((mapping (hex-list (vector-ref entry 2)))
                          (s (vector-ref simple-table code)))
                      (vector-set! full-table code mapping))))))
         (get-CaseFolding))
        (cons simple-table full-table)))

    (define props
      (let ((props-table (make-vector (+ max-char 1) '())))
        (for-each
         (lambda (x)
           (let* ((code-lo  (min (+ max-char 1) (hex (vector-ref x 0) #f)))
                  (code-hi  (min max-char (hex (vector-ref x 1) #f)))
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

        (define (setup code)
          (if (<= code max-char)
              (let* ((uppercase?
                      (or (eq? General_Category 'Lu)
                          (member "Other_Uppercase" (vector-ref props code))))
                     (lowercase?
                      (or (eq? General_Category 'Ll)
                          (member "Other_Lowercase" (vector-ref props code))))
                     (titlecase?
                      (eq? General_Category 'Lt))
                     (alphabetic?
                      (or uppercase?
                          lowercase?
                          titlecase?
                          (memq General_Category '(Lm Lo Nl))
                          (member "Other_Alphabetic" (vector-ref props code))))
                     (whitespace?
                      (member "White_Space" (vector-ref props code))))
                (cond (alphabetic?
                       (let* ((upper (hex Simple_Uppercase_Mapping code))
                              (lower (hex Simple_Lowercase_Mapping code))
                              (title (hex Simple_Titlecase_Mapping upper))
                              (upper-dist (- upper code))
                              (lower-dist (- lower code))
                              (title-dist (- title code))
                              (fold-dist  (+ (* 2 (- (vector-ref
                                                      (car case-folding)
                                                      code)
                                                     code))
                                             (if (vector-ref
                                                  (cdr case-folding)
                                                  code)
                                                 1
                                                 0)))
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
                       (enc code (modulo (string->number Numeric_Value_Decimal)
                                         digit-class-end)))
                      (whitespace?
                       (enc code whitespace-class))
                      (else
                       (enc code no-class))))))

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
      (set! upper-class-start    (+ other-class-start
                                    (table-length other-dist-table)))
      (set! title-class-start    (+ upper-class-start
                                    (table-length upper-dist-table)))
      (set! lower-class-start    (+ title-class-start
                                    (table-length title-dist-table)))
      (set! alphabetic-class-end (+ lower-class-start
                                    (table-length lower-dist-table)))

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

        (let ((table (make-vector (+ max-char 1) no-class)))

          (for-each (lambda (entry) (process-data entry table)) UnicodeData)

          (let ((hi-limit
                 (let loop ((i max-char))
                   (if (= (vector-ref table i) no-class)
                       (loop (- i 1))
                       i))))
            (subvector table 0 hi-limit)))))

    (define (create-unicode-full-foldcase-info)
      (let ((alist
             (let loop ((i (- (vector-length (cdr case-folding)) 1))
                        (alist '()))
               (if (>= i 0)
                   (loop (- i 1)
                         (let ((x (vector-ref (cdr case-folding) i)))
                           (if x
                               (cons (cons i x) alist)
                               alist)))
                   alist))))
        (if (null? alist)
            (vector (vector #f 0 0 0) '() #f)
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
              (vector dict
                      (sort-list mapping-lengths <)
                      (specialize-vector mapping))))))

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

    ;; generate macro definitions that depend on Unicode character database

    (let* ((unicode-class
            (specialize-vector (create-unicode-class)))
           (unicode-downcase-dist
            (specialize-vector unicode-downcase-dist))
           (unicode-upcase-dist
            (specialize-vector unicode-upcase-dist))
           (unicode-foldcase-dist
            (specialize-vector unicode-foldcase-dist))
           (unicode-titlecase-dist
            (specialize-vector unicode-titlecase-dist))
           (unicode-full-foldcase-info
            (create-unicode-full-foldcase-info))
           (unicode-full-foldcase-start
            (vector-ref (vector-ref unicode-full-foldcase-info 0) 0))
           (unicode-full-foldcase-mapping-lengths
            (vector-ref unicode-full-foldcase-info 1))
           (unicode-full-foldcase-mapping
            (vector-ref unicode-full-foldcase-info 2)))
      `(begin

         (define-macro (macro-implement-unicode-tables)
           `(begin

              (define ##unicode-class
                ',',unicode-class)

              (define ##unicode-downcase-dist
                ',',unicode-downcase-dist)

              (define ##unicode-upcase-dist
                ',',unicode-upcase-dist)

              (define ##unicode-foldcase-dist
                ',',unicode-foldcase-dist)

              (define ##unicode-titlecase-dist
                ',',unicode-titlecase-dist)

              ,@,(if (null? unicode-full-foldcase-mapping-lengths)
                     ``()
                     ``((define ##unicode-full-foldcase-start
                          ',',unicode-full-foldcase-start)
                        (define ##unicode-full-foldcase-mapping
                          ',',unicode-full-foldcase-mapping)))))

         (define-macro (macro-alphabetic-class-start)
           ,alphabetic-class-start)

         (define-macro (macro-digit-class-end)
           ,digit-class-end)

         (define-macro (macro-no-class)
           ,no-class)

         (define-macro (macro-whitespace-class)
           ,whitespace-class)

         (define-macro (macro-other-class-start)    ,other-class-start)
         (define-macro (macro-upper-class-start)    ,upper-class-start)
         (define-macro (macro-title-class-start)    ,title-class-start)
         (define-macro (macro-lower-class-start)    ,lower-class-start)
         (define-macro (macro-alphabetic-class-end) ,alphabetic-class-end)

         (define-macro (macro-full-foldcase-salt)
           ,(vector-ref (vector-ref unicode-full-foldcase-info 0) 1))

         (define-macro (macro-full-foldcase-offset)
           ,(vector-ref (vector-ref unicode-full-foldcase-info 0) 2))

         (define-macro (macro-full-foldcase-mod)
           ,(vector-ref (vector-ref unicode-full-foldcase-info 0) 3))

         ,(if (null? unicode-full-foldcase-mapping-lengths)
              `(define-macro (macro-full-foldcase-mapping-length var) 1)
              `(define-macro (macro-full-foldcase-mapping-length var)

                 (define (gen mapping-lengths)
                   (if (pair? mapping-lengths)
                       (let ((mlen (car mapping-lengths)))
                         (if (null? (cdr mapping-lengths))
                             mlen
                             `(if (##fx= 0
                                         (macro-full-foldcase-mapping
                                          (##fx- ,var ,mlen)))
                                  ,mlen
                                  ,(gen (cdr mapping-lengths)))))
                       1))

                 (gen ',unicode-full-foldcase-mapping-lengths)))

         (define-macro (macro-full-foldcase-start code)
           `(,',(specialized-vector-ref-op unicode-full-foldcase-start)
             ##unicode-full-foldcase-start
             (##fxmodulo
              (##fx+
               (##fxxor ,code (macro-full-foldcase-salt))
               (macro-full-foldcase-offset))
              (macro-full-foldcase-mod))))

         (define-macro (macro-full-foldcase-mapping i)
           `(,',(specialized-vector-ref-op unicode-full-foldcase-mapping)
             ##unicode-full-foldcase-mapping
             ,i))

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
             (##fx< class (macro-digit-class-end))))

         (define-macro (macro-char-whitespace? c)
           `(macro-let-char-class-with-default
             ,c c code class
             #f
             (##fx= class (macro-whitespace-class))))

         (define-macro (macro-char-alphabetic? c)
           ,(if (= alphabetic-class-start alphabetic-class-end)
                `#f
                ``(macro-let-char-class-with-default
                   ,c c code class
                   #f
                   (##fx>= class (macro-alphabetic-class-start)))))

         (define-macro (macro-char-lower-case? c)
           ,(if (= lower-class-start alphabetic-class-end)
                `#f
                ``(macro-let-char-class-with-default
                   ,c c code class
                   #f
                   (##fx>= class (macro-lower-class-start)))))

         (define-macro (macro-char-upper-case? c)
           ,(if (= upper-class-start title-class-start)
                `#f
                ``(macro-let-char-class-with-default
                   ,c c code class
                   #f
                   ,',(if (= upper-class-start (- title-class-start 1))
                          `(##fx= class (macro-upper-class-start))
                          `(and (##fx>= class (macro-upper-class-start))
                                (##fx< class (macro-title-class-start)))))))

         (define-macro (macro-char-title-case? c)
           ,(if (= title-class-start lower-class-start)
                `#f
                ``(macro-let-char-class-with-default
                   ,c c code class
                   #f
                   ,',(if (= title-class-start (- lower-class-start 1))
                          `(##fx= class (macro-title-class-start))
                          `(and (##fx>= class (macro-title-class-start))
                                (##fx< class (macro-lower-class-start)))))))

         (define-macro (macro-upcase-dist class)
           `(,',(specialized-vector-ref-op unicode-upcase-dist)
             ##unicode-upcase-dist
             ,class))

         (define-macro (macro-char-upcase c)
           `(macro-let-char-class-with-default
             ,c c code class
             c
             (##integer->char
              (##fx+ code (macro-upcase-dist class)))))

         (define-macro (macro-downcase-dist class)
           `(,',(specialized-vector-ref-op unicode-downcase-dist)
             ##unicode-downcase-dist
             ,class))

         (define-macro (macro-char-downcase c)
           `(macro-let-char-class-with-default
             ,c c code class
             c
             (##integer->char
              (##fx+ code (macro-downcase-dist class)))))

         (define-macro (macro-titlecase-dist class)
           `(,',(specialized-vector-ref-op unicode-titlecase-dist)
             ##unicode-titlecase-dist
             ,class))

         (define-macro (macro-char-titlecase c)
           `(macro-let-char-class-with-default
             ,c c code class
             c
             (##integer->char
              (##fx+ code (macro-titlecase-dist class)))))

         (define-macro (macro-foldcase-dist class)
           `(,',(specialized-vector-ref-op unicode-foldcase-dist)
             ##unicode-foldcase-dist
             ,class))

         (define-macro (macro-char-foldcase c)
           `(macro-let-char-class-with-default
             ,c c code class
             c
             (##integer->char
              (##fx+ code
                     (##fxarithmetic-shift-right
                      (macro-foldcase-dist class)
                      1)))))

         (define-macro (macro-digit-value c)
           `(macro-let-char-class-with-default
             ,c c code class
             #f
             (if (##fx< class (macro-digit-class-end))
                 class
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
                            (if (##fxeven? dist1)
                                (if (##fxeven? dist2)
                                    (compare-simp-simp
                                     (##fx+ i1 1)
                                     (##fx+ i2 1)
                                     (##fx+ code1
                                            (##fxarithmetic-shift-right dist1
                                                                        1))
                                     (##fx+ code2
                                            (##fxarithmetic-shift-right dist2
                                                                        1)))
                                    (let* ((m2
                                            (macro-full-foldcase-start code2))
                                           (code2*
                                            (macro-full-foldcase-mapping m2)))
                                      (compare-simp-spec
                                       (##fx+ i1 1)
                                       (##fx+ i2 1)
                                       (##fx- m2 1)
                                       (##fx+ code1
                                              (##fxarithmetic-shift-right dist1
                                                                          1))
                                       code2*)))
                                (let* ((m1
                                        (macro-full-foldcase-start code1))
                                       (code1*
                                        (macro-full-foldcase-mapping m1)))
                                  (if (##fxeven? dist2)
                                      (compare-spec-simp
                                       (##fx+ i1 1)
                                       (##fx+ i2 1)
                                       (##fx- m1 1)
                                       code1*
                                       (##fx+ code2
                                              (##fxarithmetic-shift-right dist2
                                                                          1)))
                                      (let* ((m2
                                              (macro-full-foldcase-start code2))
                                             (code2*
                                              (macro-full-foldcase-mapping m2)))
                                        (compare-spec-spec
                                         (##fx+ i1 1)
                                         (##fx+ i2 1)
                                         (##fx- m1 1)
                                         (##fx- m2 1)
                                         code1*
                                         code2*)))))))))))

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

              (loop-simp-simp start1 start2)))

         (define-macro (macro-string-foldcase str start end)
           `(let ((str ,str)
                  (start ,start)
                  (end ,end))

              (define (length-loop i len)
                (if (##fx>= i end)
                    len
                    (macro-let-char-class
                     (##string-ref str i) c code class
                     (let ((dist (macro-foldcase-dist class)))
                       (if (##fxeven? dist)
                           (length-loop
                            (##fx+ i 1)
                            (##fx+ len 1))
                           (length-loop
                            (##fx+ i 1)
                            (##fx+ len
                                   (let ((m (macro-full-foldcase-start code)))
                                     (macro-full-foldcase-mapping-length m)))))))))

              (define (foldcase-loop result i j)
                (if (##fx>= i end)
                    result
                    (macro-let-char-class
                     (##string-ref str i) c code class
                     (let ((dist (macro-foldcase-dist class)))
                       (if (##fxeven? dist)
                           (begin
                             (##string-set!
                              result
                              j
                              (##integer->char
                               (##fx+ code
                                      (##fxarithmetic-shift-right dist 1))))
                             (foldcase-loop
                              result
                              (##fx+ i 1)
                              (##fx+ j 1)))
                           (let loop ((m (macro-full-foldcase-start code))
                                      (j j))
                             (let ((code* (macro-full-foldcase-mapping m)))
                               (if (##fx= 0 code*)
                                   (foldcase-loop
                                    result
                                    (##fx+ i 1)
                                    j)
                                   (begin
                                     (##string-set!
                                      result
                                      j
                                      (##integer->char code*))
                                     (loop (##fx- m 1) (##fx+ j 1)))))))))))

              (foldcase-loop (##make-string (length-loop start 0))
                             start
                             0)))))))

(macro-define-unicode-tables #f)

;;;============================================================================
