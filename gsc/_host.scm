;;;============================================================================

;;; File: "_host.scm"

;;; Copyright (c) 1994-2011 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(include "fixnum.scm")

;;;============================================================================

;; Host system interface:
;; ---------------------

;; This module contains definitions to interface to the host system in
;; which the compiler is loaded.  This is the only module that contains
;; non-portable scheme code.  So one should be able to port the
;; compiler to another system by adjusting this file.

;;;----------------------------------------------------------------------------

;; The host dependent variables:
;; ----------------------------

'(begin ; *** remove the quote at the start of this line if not using Gambit-C

;; These procedures are the interface to 'keyword objects'.  On a
;; system which lacks native support for them, keywords are implemented
;; with symbols.

(define (string->keyword-object str)
  (string->symbol (string-append str ":")))

(define (keyword-object->string key)
  (let ((str (symbol->string key)))
    (substring str 0 (- (string-length str) 1))))

(define (keyword-object? obj)
  (and (symbol? obj)
       (let* ((str (symbol->string obj))
              (len (string-length str)))
         (and (< 1 len)
              (char=? (string-ref str (- len 1)) #\:)))))

;; These definitions are needed to support objects which are not
;; standard in all implementations of Scheme.  On implementations which
;; do not support these objects, they are represented with symbols.
;; Note that this implies that false-object? and symbol-object?
;; must be used to test for #f and symbols.

(define false-object
  (if (eq? '() #f) (string->symbol "#f") #f))

(define (false-object? obj)
  (eq? obj false-object))

(define absent-object
  (string->symbol "#<absent>"))

(define (absent-object? obj)
  (eq? obj absent-object))

(define unused-object
  (string->symbol "#<unused>"))

(define (unused-object? obj)
  (eq? obj unused-object))

(define deleted-object
  (string->symbol "#<deleted>"))

(define (deleted-object? obj)
  (eq? obj deleted-object))

(define void-object
  (string->symbol "#!void"))

(define (void-object? obj)
  (eq? obj void-object))

(define unbound1-object
  (string->symbol "#!unbound"))

(define (unbound1-object? obj)
  (eq? obj unbound1-object))

(define (unbound2-object? obj)
  (eq? obj unbound2-object))

(define unbound2-object
  (string->symbol "#!unbound2"))

(define end-of-file-object
  (string->symbol "#!eof"))

(define (end-of-file-object? obj)
  (eq? obj end-of-file-object))

(define optional-object
  (string->symbol "#!optional"))

(define (optional-object? obj)
  (eq? obj optional-object))

(define key-object
  (string->symbol "#!key"))

(define (key-object? obj)
  (eq? obj key-object))

(define rest-object
  (string->symbol "#!rest"))

(define (rest-object? obj)
  (eq? obj rest-object))

;(define body-object
;;  (string->symbol "#!body"))
;;
;(define (body-object? obj)
;;  (eq? obj body-object))

(define (symbol-object? obj)
  (and (symbol? obj)
       (not (keyword-object? obj)) ; keywords might be implemented with symbols
       (not (false-object? obj))
       (not (absent-object? obj))
       (not (unused-object? obj))
       (not (deleted-object? obj))
       (not (void-object? obj))
       (not (unbound1-object? obj))
       (not (unbound2-object? obj))
       (not (end-of-file-object? obj))
       (not (optional-object? obj))
       (not (key-object? obj))
       (not (rest-object? obj))
;;       (not (body-object? obj))
       ))

(define box-tag (list 'box))

(define (box-object? obj)
  (and (vector? obj)
       (> (vector-length obj) 0)
       (eq? (vector-ref obj 0) box-tag)))

(define (box-object obj)
  (vector box-tag obj))

(define (unbox-object box)
  (vector-ref box 1))

(define (set-box-object! box val)
  (vector-set! box 1 val))

(define (structure-object? obj)
  #f)

(define (structure->list obj)
  '())

;; 'open-input-file*' is like open-input-file but returns #f when the
;; named file does not exist.

(define (open-input-file* path)
  (open-input-file path))

;; 'pp-expression' is used to pretty print an expression on a given
;; port.

(define (pp-expression expr port)
  (newline port)
  (write expr port)
  (newline port))

;; 'write-returning-len' is like 'write' but it returns the number of
;; characters that were written out.

(define (write-returning-len obj port)
  (write obj port)
  1)

;; 'display-returning-len' is like 'display' but it returns the number
;; of characters that were written out.

(define (display-returning-len obj port)
  (display obj port)
  1)

;; 'write-word' is used to write out files containing binary data.

(define (write-word w port)
  (write-char (integer->char (quotient w 256)) port)
  (write-char (integer->char (modulo w 256)) port))

;; 'character->unicode' is used to convert Scheme characters into their
;; corresponding encoding in Unicode.  'unicode->character' performs
;; the inverse operation.  'in-char-range?' tests to see if its
;; non-negative integer argument is in the range expected by
;; 'unicode->character'.

(define (character->unicode c)
  (char->integer c))

(define (unicode->character n)
  (integer->char n))

(define (in-char-range? n)
  (<= n 255))

;; 'in-integer-range?' is used to test if an integer is in a certain range.

(define (in-integer-range? n lo hi)
  (and (not (< n lo)) (not (< hi n))))

;; 'fatal-err' is used to signal non-recoverable errors.

(define (fatal-err msg arg)
  (error msg arg))

;; 'scheme-global-var', 'scheme-global-var-ref',
;; 'scheme-global-var-define!' and 'scheme-global-eval' define an
;; interface to the built-in evaluator (if there is one).  The
;; evaluator is only needed for the processing of macros.

(define (scheme-global-var name)
  name)

(define (scheme-global-var-ref var)
  (scheme-global-eval var))

(define (scheme-global-var-define! var val)
  (scheme-global-eval (list 'define var (list 'quote val)) fatal-err))

(define (scheme-global-eval expr err)
  (eval expr))

;; 'format-filepos' is called when the compiler detects a user error in
;; a source file.  In a windowed environment this can be used to show
;; the location of an error.  If #f is returned, the default format will
;; be used to display the location information in the error message.

(define (format-filepos path filepos pinpoint?)
  #f)

;; The following functions define an interface to the file system's
;; naming conventions.  The current implementation is suitable for UNIX.
;;
;; For example, under UNIX:
;;     (path-expand "../baz.scm" "/home/feeley/foo") => "/home/feeley/baz.scm"
;;     (path-extension "foo/bar/baz.scm")       => ".scm"
;;     (path-extension "foo/bar/baz")           => ""
;;     (path-strip-extension "foo/bar/baz.scm") => "foo/bar/baz"
;;     (path-directory "foo/bar/baz.scm")       => "foo/bar/"
;;     (path-strip-directory "foo/bar/baz.scm") => "baz.scm"

(define file-path-sep #\/)
(define file-ext-sep #\.)

(define (path-expand path . dir)
  path)

(define (path-extension path)
  (let loop1 ((i (string-length path)))
    (if (or (= i 0) (char=? (string-ref path (- i 1)) file-path-sep))
      ""
      (if (not (char=? (string-ref path (- i 1)) file-ext-sep))
        (loop1 (- i 1))
        (let* ((i (- i 1))
               (result (make-string (- (string-length path) i))))
          (let loop2 ((j (- (string-length path) 1)))
            (if (< j i)
              result
              (begin
                (string-set! result (- j i) (string-ref path j))
                (loop2 (- j 1))))))))))

(define (path-strip-extension path)
  (let loop1 ((i (string-length path)))
    (if (or (= i 0) (char=? (string-ref path (- i 1)) file-path-sep))
      path
      (if (not (char=? (string-ref path (- i 1)) file-ext-sep))
        (loop1 (- i 1))
        (let ((result (make-string (- i 1))))
          (let loop2 ((j (- i 2)))
            (if (< j 0)
              result
              (begin
                (string-set! result j (string-ref path j))
                (loop2 (- j 1))))))))))

(define (path-directory path)
  (let loop1 ((i (string-length path)))
    (if (and (> i 0) (not (char=? (string-ref path (- i 1)) file-path-sep)))
      (loop1 (- i 1))
      (let ((result (make-string i)))
        (let loop2 ((j (- i 1)))
          (if (< j 0)
            result
            (begin
              (string-set! result j (string-ref path j))
              (loop2 (- j 1)))))))))

(define (path-strip-directory path)
  (let loop1 ((i (string-length path)))
    (if (and (> i 0) (not (char=? (string-ref path (- i 1)) file-path-sep)))
      (loop1 (- i 1))
      (let ((result (make-string (- (string-length path) i))))
        (let loop2 ((j (- (string-length path) 1)))
          (if (< j i)
            result
            (begin
              (string-set! result (- j i) (string-ref path j))
              (loop2 (- j 1)))))))))

(define scheme-file-extensions
  '((".scm" . #f)
    (".six" . six)))

;; Bytevector data types.

(define s8vect-tag (list 's8vect))

(define (make-s8vect n)
  (vector s8vect-tag (make-vector n 0)))

(define (s8vect? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) s8vect-tag)))

(define (s8vect->list v)
  (vect->list (vector-ref v 1)))

(define (s8vect-length v)
  (vector-length (vector-ref v 1)))

(define (s8vect-ref v i)
  (vector-ref (vector-ref v 1) i))

(define (s8vect-set! v i n)
  (vector-set! (vector-ref v 1) i n))

(define u8vect-tag (list 'u8vect))

(define (make-u8vect n)
  (vector u8vect-tag (make-vector n 0)))

(define (u8vect? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) u8vect-tag)))

(define (u8vect->list v)
  (vect->list (vector-ref v 1)))

(define (u8vect-length v)
  (vector-length (vector-ref v 1)))

(define (u8vect-ref v i)
  (vector-ref (vector-ref v 1) i))

(define (u8vect-set! v i n)
  (vector-set! (vector-ref v 1) i n))

(define s16vect-tag (list 's16vect))

(define (make-s16vect n)
  (vector s16vect-tag (make-vector n 0)))

(define (s16vect? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) s16vect-tag)))

(define (s16vect->list v)
  (vect->list (vector-ref v 1)))

(define (s16vect-length v)
  (vector-length (vector-ref v 1)))

(define (s16vect-ref v i)
  (vector-ref (vector-ref v 1) i))

(define (s16vect-set! v i n)
  (vector-set! (vector-ref v 1) i n))

(define u16vect-tag (list 'u16vect))

(define (make-u16vect n)
  (vector u16vect-tag (make-vector n 0)))

(define (u16vect? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) u16vect-tag)))

(define (u16vect->list v)
  (vect->list (vector-ref v 1)))

(define (u16vect-length v)
  (vector-length (vector-ref v 1)))

(define (u16vect-ref v i)
  (vector-ref (vector-ref v 1) i))

(define (u16vect-set! v i n)
  (vector-set! (vector-ref v 1) i n))

(define s32vect-tag (list 's32vect))

(define (make-s32vect n)
  (vector s32vect-tag (make-vector n 0)))

(define (s32vect? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) s32vect-tag)))

(define (s32vect->list v)
  (vect->list (vector-ref v 1)))

(define (s32vect-length v)
  (vector-length (vector-ref v 1)))

(define (s32vect-ref v i)
  (vector-ref (vector-ref v 1) i))

(define (s32vect-set! v i n)
  (vector-set! (vector-ref v 1) i n))

(define u32vect-tag (list 'u32vect))

(define (make-u32vect n)
  (vector u32vect-tag (make-vector n 0)))

(define (u32vect? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) u32vect-tag)))

(define (u32vect->list v)
  (vect->list (vector-ref v 1)))

(define (u32vect-length v)
  (vector-length (vector-ref v 1)))

(define (u32vect-ref v i)
  (vector-ref (vector-ref v 1) i))

(define (u32vect-set! v i n)
  (vector-set! (vector-ref v 1) i n))

(define s64vect-tag (list 's64vect))

(define (make-s64vect n)
  (vector s64vect-tag (make-vector n 0)))

(define (s64vect? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) s64vect-tag)))

(define (s64vect->list v)
  (vect->list (vector-ref v 1)))

(define (s64vect-length v)
  (vector-length (vector-ref v 1)))

(define (s64vect-ref v i)
  (vector-ref (vector-ref v 1) i))

(define (s64vect-set! v i n)
  (vector-set! (vector-ref v 1) i n))

(define u64vect-tag (list 'u64vect))

(define (make-u64vect n)
  (vector u64vect-tag (make-vector n 0)))

(define (u64vect? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) u64vect-tag)))

(define (u64vect->list v)
  (vect->list (vector-ref v 1)))

(define (u64vect-length v)
  (vector-length (vector-ref v 1)))

(define (u64vect-ref v i)
  (vector-ref (vector-ref v 1) i))

(define (u64vect-set! v i n)
  (vector-set! (vector-ref v 1) i n))

(define f32vect-tag (list 'f32vect))

(define (make-f32vect n)
  (vector f32vect-tag (make-vector n 0.)))

(define (f32vect? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) f32vect-tag)))

(define (f32vect->list v)
  (vect->list (vector-ref v 1)))

(define (f32vect-length v)
  (vector-length (vector-ref v 1)))

(define (f32vect-ref v i)
  (vector-ref (vector-ref v 1) i))

(define (f32vect-set! v i n)
  (vector-set! (vector-ref v 1) i n))

(define f64vect-tag (list 'f64vect))

(define (make-f64vect n)
  (vector f64vect-tag (make-vector n 0.)))

(define (f64vect? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) f64vect-tag)))

(define (f64vect->list v)
  (vect->list (vector-ref v 1)))

(define (f64vect-length v)
  (vector-length (vector-ref v 1)))

(define (f64vect-ref v i)
  (vector-ref (vector-ref v 1) i))

(define (f64vect-set! v i n)
  (vector-set! (vector-ref v 1) i n))

(define (vector-object? obj)
  (and (vector? obj)
       (not (box-object? obj))
       (not (s8vect? obj))
       (not (u8vect? obj))
       (not (s16vect? obj))
       (not (u16vect? obj))
       (not (s32vect? obj))
       (not (u32vect? obj))
       (not (s64vect? obj))
       (not (u64vect? obj))
       (not (f32vect? obj))
       (not (f64vect? obj))
       (not (table? obj))))

(define (float-copysign x y)
  (if (< y 0.)
    (- (abs x))
    (abs x)))

;; Stuff for the reader.

(define (**comply-to-standard-scheme?) #f);;;;;;;;;;;;;;;;
(define **main-readtable #f)
(define read-datum-or-eof #f)

(define (**subtype-set! obj subtype) obj)

(define (max-lines)                  65536)
(define (max-fixnum32-div-max-lines)  8191)
(define (subtype-structure) #f)

(define (symbol-hash sym) 0)

;; Tables.

(define table-tag (list 'table))

(define (make-table . args)
  (let* ((t (memq 'test: args))
         (test (if t (cadr t) equal?)))
    (vector table-tag
            test
            '())))

(define (table? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) table-tag)))

(define (table-lookup table key)
  (let ((test (vector-ref table 1)))
    (let loop ((lst (vector-ref table 2)))
      (if (null? lst)
        #f
        (let ((couple (car lst)))
          (if (test (car couple) key)
            couple
            (loop (cdr lst))))))))

(define (table-ref table key . default)
  (let ((couple (table-lookup table key)))
    (if couple
      (cdr couple)
      (if (null? default)
        (error "unbound table key" key)
        (car default)))))

(define (table-set! table key val)
  (let ((couple (table-lookup table key)))
    (if couple
      (set-cdr! couple val)
      (vector-set! table 2 (cons (cons key val) (vector-ref table 2))))))

(define (table->list table)
  (vector-ref table 2))

)

;;;============================================================================

;; Definitions when host system is Gambit-C:

;" *** remove the semicolon at the start of this line if not using Gambit-C

(define (string->keyword-object str)
  (##string->keyword str))

(define (keyword-object->string key)
  (##keyword->string key))

(define (keyword-object? obj)
  (##keyword? obj))

(define false-object #f)

(define (false-object? obj)
  (eq? obj false-object))

(define absent-object (macro-absent-obj))

(define (absent-object? obj)
  (eq? obj absent-object))

(##define-macro (macro-unused-obj)
  `(##type-cast -14 (macro-type-special)))

(##define-macro (macro-deleted-obj)
  `(##type-cast -15 (macro-type-special)))

(define unused-object (macro-unused-obj))

(define (unused-object? obj)
  (eq? obj unused-object))

(define deleted-object (macro-deleted-obj))

(define (deleted-object? obj)
  (eq? obj deleted-object))

(define void-object (##void))

(define (void-object? obj)
  (eq? obj void-object))

(define (unbound1-object? obj)
  (eq? obj (##type-cast -7 2)));;;;;;;;;;;;;

(define (unbound2-object? obj)
  (eq? obj (##type-cast -8 2)));;;;;;;;;;;;

(define end-of-file-object #!eof)

(define (end-of-file-object? obj)
  (eq? obj end-of-file-object))

(define optional-object #!optional)

(define (optional-object? obj)
  (eq? obj optional-object))

(define key-object #!key)

(define (key-object? obj)
  (eq? obj key-object))

(define rest-object #!rest)

(define (rest-object? obj)
  (eq? obj rest-object))

;(define body-object #!body)
;;
;(define (body-object? obj)
;;  (eq? obj body-object))

(define (symbol-object? obj)
  (symbol? obj))

(define (box-object? obj)
  (##box? obj))

(define (box-object obj)
  (##box obj))

(define (unbox-object box)
  (##unbox box))

(define (set-box-object! box val)
  (##set-box! box val))

(define (structure-object? obj)
  (##structure? obj))

(define (structure->list obj)
  (##vector->list obj))

(define (open-input-file* path)
  (##open-file-generic
   (macro-direction-in)
   #f
   (lambda (port) (if (input-port? port) port #f))
   open-input-file
   path))

(define open-output-file ##open-output-file)

(define (pp-expression expr port)
  (pp expr port))

(define (write-returning-len obj port)
  (##namespace ("" with-output-to-string))
  (let ((str (with-output-to-string '() (lambda () (write obj)))))
    (display str port)
    (string-length str)))

(define (display-returning-len obj port)
  (##namespace ("" with-output-to-string))
  (let ((str (with-output-to-string '() (lambda () (display obj)))))
    (display str port)
    (string-length str)))

(define (write-word w port)
  (write-char (integer->char (quotient w 256)) port)
  (write-char (integer->char (modulo w 256)) port))

(define (character->unicode c)
  (char->integer c))

(define (unicode->character n)
  (integer->char n))

(define (in-char-range? n)
  (##declare (generic)) ; in case n is a bignum
  (<= n ##max-char))

(define (in-integer-range? n lo hi)
  (##declare (generic)) ; in case n is a bignum
  (and (not (< n lo)) (not (< hi n))))

(define (fatal-err msg arg)
  (error msg arg))

(define (scheme-global-var name)
  name)

(define (scheme-global-var-ref var)
  (scheme-global-eval var))

(define (scheme-global-var-define! var val)
  (scheme-global-eval (list 'define var (list 'quote val)) fatal-err))

(define (scheme-global-eval expr err)
  (eval expr))

(define (format-filepos path filepos pinpoint?)
  (##format-filepos path filepos pinpoint?))

(define (path-expand path . dir)
  (if (##null? dir)
    (##path-expand path)
    (##path-expand path (##car dir))))

(define (path-extension path)
  (##path-extension path))

(define (path-strip-extension path)
  (##path-strip-extension path))

(define (path-directory path)
  (##path-directory path))

(define (path-strip-directory path)
  (##path-strip-directory path))

(define scheme-file-extensions ##scheme-file-extensions)

(define (make-s8vect n)      (##make-s8vector n 0))
(define s8vect?              ##s8vector?)
(define s8vect->list         ##s8vector->list)
(define s8vect-length        ##s8vector-length)
(define s8vect-ref           ##s8vector-ref)
(define s8vect-set!          ##s8vector-set!)

(define (make-u8vect n)      (##make-u8vector n 0))
(define u8vect?              ##u8vector?)
(define u8vect->list         ##u8vector->list)
(define u8vect-length        ##u8vector-length)
(define u8vect-ref           ##u8vector-ref)
(define u8vect-set!          ##u8vector-set!)

(define (make-s16vect n)     (##make-s16vector n 0))
(define s16vect?             ##s16vector?)
(define s16vect->list        ##s16vector->list)
(define s16vect-length       ##s16vector-length)
(define s16vect-ref          ##s16vector-ref)
(define s16vect-set!         ##s16vector-set!)

(define (make-u16vect n)     (##make-u16vector n 0))
(define u16vect?             ##u16vector?)
(define u16vect->list        ##u16vector->list)
(define u16vect-length       ##u16vector-length)
(define u16vect-ref          ##u16vector-ref)
(define u16vect-set!         ##u16vector-set!)

(define (make-s32vect n)     (##make-s32vector n 0))
(define s32vect?             ##s32vector?)
(define s32vect->list        ##s32vector->list)
(define s32vect-length       ##s32vector-length)
(define s32vect-ref          ##s32vector-ref)
(define s32vect-set!         ##s32vector-set!)

(define (make-u32vect n)     (##make-u32vector n 0))
(define u32vect?             ##u32vector?)
(define u32vect->list        ##u32vector->list)
(define u32vect-length       ##u32vector-length)
(define u32vect-ref          ##u32vector-ref)
(define u32vect-set!         ##u32vector-set!)

(define (make-s64vect n)     (##make-s64vector n 0))
(define s64vect?             ##s64vector?)
(define s64vect->list        ##s64vector->list)
(define s64vect-length       ##s64vector-length)
(define s64vect-ref          ##s64vector-ref)
(define s64vect-set!         ##s64vector-set!)

(define (make-u64vect n)     (##make-u64vector n 0))
(define u64vect?             ##u64vector?)
(define u64vect->list        ##u64vector->list)
(define u64vect-length       ##u64vector-length)
(define u64vect-ref          ##u64vector-ref)
(define u64vect-set!         ##u64vector-set!)

(define (make-f32vect n)     (##make-f32vector n (macro-inexact-+0)))
(define f32vect?             ##f32vector?)
(define f32vect->list        ##f32vector->list)
(define f32vect-length       ##f32vector-length)
(define f32vect-ref          ##f32vector-ref)
(define f32vect-set!         ##f32vector-set!)

(define (make-f64vect n)     (##make-f64vector n (macro-inexact-+0)))
(define f64vect?             ##f64vector?)
(define f64vect->list        ##f64vector->list)
(define f64vect-length       ##f64vector-length)
(define f64vect-ref          ##f64vector-ref)
(define f64vect-set!         ##f64vector-set!)

(define (vector-object? obj)
  (vector? obj))

(define float-copysign ##flcopysign)

(define (**comply-to-standard-scheme?) #f);;;;;;;;;;;;;;;;;;;;;;
(define **main-readtable #f);;;;;;;
(define read-datum-or-eof #f);;;;;;;;;

(define (**subtype-set! obj subtype)
  (##subtype-set! obj subtype))

(define (max-lines)
  (macro-max-lines))

(define (max-fixnum32-div-max-lines)
  (macro-max-fixnum32-div-max-lines))

(define (subtype-structure)
  (macro-subtype-structure))

(define (symbol-hash sym)
  (macro-symbol-hash sym))

;"
