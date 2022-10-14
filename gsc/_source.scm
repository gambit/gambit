;;;============================================================================

;;; File: "_source.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include     "_sourceadt.scm")

'(##include "_hostadt.scm");*******************brad

;;;----------------------------------------------------------------------------
;;
;; Source code manipulation module:
;; -------------------------------

;; This module contains procedures to manipulate source code
;; representations read in from Scheme source files.

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; A readenv structure maintains the "read environment" throughout the
;; reading of a Scheme datum.  It includes the port from which to read,
;; the readtable, the wrap and unwrap procedures, and the position
;; where the currently being read datum started.

(define (**make-readenv port readtable error-proc wrapper unwrapper)
  (vector port readtable error-proc wrapper unwrapper 0 0 0 0))

(define (**readenv-port re)              (vector-ref re 0))
(define (**readenv-readtable re)         (vector-ref re 1))
(define (**readenv-error-proc re)        (vector-ref re 2))
(define (**readenv-wrap re x)            ((vector-ref re 3) re x))
(define (**readenv-unwrap re x)          ((vector-ref re 4) re x))
(define (**readenv-filepos re)           (vector-ref re 5))
(define (**readenv-filepos-set! re pos)  (vector-set! re 5 pos))
(define (**readenv-line-count re)        (vector-ref re 6))
(define (**readenv-line-count-set! re x) (vector-set! re 6 x))
(define (**readenv-char-count re)        (vector-ref re 7))
(define (**readenv-char-count-set! re x) (vector-set! re 7 x))
(define (**readenv-line-start re)        (vector-ref re 8))
(define (**readenv-line-start-set! re x) (vector-set! re 8 x))

(define (**readenv-current-filepos re)
  (let* ((line
          (**readenv-line-count re))
         (char-count
          (**readenv-char-count re))
         (char
          (- char-count
             (**readenv-line-start re))))
    (**make-filepos line char char-count)))

(define (**readenv-previous-filepos re offset)
  (let* ((line
          (**readenv-line-count re))
         (char-count
          (- (**readenv-char-count re) offset))
         (char
          (- char-count
             (**readenv-line-start re))))
    (**make-filepos line char char-count)))

(define (**peek-next-char-or-eof re) ; possibly returns end-of-file
  (peek-char (**readenv-port re)))

(define (**read-next-char-or-eof re) ; possibly returns end-of-file
  (let ((c (read-char (**readenv-port re))))
    (if (char? c)
      (let ((char-count (+ (**readenv-char-count re) 1)))
        (**readenv-char-count-set! re char-count)
        (if (char=? c #\newline)
          (begin
            (**readenv-line-start-set! re char-count)
            (**readenv-line-count-set! re
              (+ (**readenv-line-count re) 1))))))
    c))

(define (**make-filepos line char char-count)
  (if (and (< line (max-lines))
           (not (< (max-fixnum32-div-max-lines) char)))
    (+ line (* char (max-lines)))
    (- char-count)))

(define (**filepos-line filepos)
  (if (< filepos 0)
    0
    (modulo filepos (max-lines))))

(define (**filepos-col filepos)
  (if (< filepos 0)
    (- filepos)
    (quotient filepos (max-lines))))

(define (**readenv-open filename)

  (define (error-proc re msg . args)
    (apply compiler-user-error
           (cons (re->locat re filename)
                 (cons msg
                       args))))

  (define (wrapper re x)
    (make-source x (re->locat re filename)))

  (define (unwrapper re x)
    (source-code x))

  (let ((port (open-input-file filename)))
    (**make-readenv port
                    **main-readtable
                    error-proc
                    wrapper
                    unwrapper)))

(define (**readenv-close re)
  (close-input-port (**readenv-port re)))

(define (false-obj)
  false-object)

(define (**string-concatenate lst)
  (let loop1 ((n 0) (x lst) (y '()))
    (if (pair? x)
      (let ((s (car x)))
        (loop1 (+ n (string-length s)) (cdr x) (cons s y)))
      (let ((result (make-string n #\space)))
        (let loop2 ((k (- n 1)) (y y))
          (if (pair? y)
            (let ((s (car y)))
              (let loop3 ((i k) (j (- (string-length s) 1)))
                (if (not (< j 0))
                  (begin
                    (string-set! result i (string-ref s j))
                    (loop3 (- i 1) (- j 1)))
                  (loop2 i (cdr y)))))
            result))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Symbol "canonicalization".

(define (string->canonical-symbol str)
  (let ((new-str (string-append str "")))
    (if **main-readtable
      (**readtable-string-convert-case! **main-readtable new-str))
    (string->symbol new-str)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; 'location' manipulation

(define (re->locat re filename)
  (vector filename (**readenv-filepos re)))

(define (expr->locat expr source)
  (vector source expr))

(define (locat-show prefix loc)
  (if loc

      (let ((filename (##container->path (##locat-container loc)))
            (filepos (##locat-position loc)))
        (if (string? filename) ; file?
            (let ((str (format-filepos filename filepos #t)))
              (if str
                  (begin
                    (display prefix)
                    (display str))
                  (let ((line (+ (**filepos-line filepos) 1))
                        (col (+ (**filepos-col filepos) 1))
                        (filename*
                         (if (string? filename)
                             (path-expand filename)
                             filename)))
                    (display prefix)
                    (write filename*)
                    (display "@")
                    (display line)
                    (display ".")
                    (display col))))
            (let ((source (vector-ref loc 0))
                  (expr (vector-ref loc 1)))
              (display prefix)
              (display "EXPRESSION ")
              (write expr)
              (if source
                  (locat-show " " (source-locat source))))))))

(define (locat-filename-and-line loc)
  (if loc
      (let* ((container (##locat-container loc))
             (path (##container->path container)))
        (if path
            (let* ((position (##locat-position loc))
                   (filepos (##position->filepos position))
                   (line (+ (**filepos-line filepos) 1)))
              (cons path line))
            (cons "" 1)))
      (cons "" 1)))

(define (locat-filename loc)
  (car (locat-filename-and-line loc)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; 'source' manipulation

;; (expression->source expr source) returns the source that represent
;; the Scheme expression 'expr' and is related to the source 'source'
;; (#f if no relation).

(define (expression->source expr source)

  (define (expr->source x)
    (make-source (cond ((pair? x)
                        (list-convert x))
                       ((box-object? x)
                        (box-object (expr->source (unbox-object x))))
                       ((vector-object? x)
                        (vector-convert x))
                       (else
                        x))
                 (expr->locat x source)))

  (define (list-convert l)
    (cons (expr->source (car l))
          (list-tail-convert (cdr l))))

  (define (list-tail-convert l)
    (cond ((pair? l)
           (if (quoting-form? l) ; so that macros which generate quoting-forms
             (expr->source l)    ; at the tail of a list work properly
             (cons (expr->source (car l))
                   (list-tail-convert (cdr l)))))
          ((null? l)
           '())
          (else
           (expr->source l))))

  (define (quoting-form? x)
    (let ((first (car x))
          (rest (cdr x)))
      (and (pair? rest)
           (null? (cdr rest))
           (or (eq? first quote-sym)
               (eq? first quasiquote-sym)
               (eq? first unquote-sym)
               (eq? first unquote-splicing-sym)))))

  (define (vector-convert v)
    (let* ((len (vector-length v))
           (x (make-vector len)))
      (let loop ((i (- len 1)))
        (if (>= i 0)
          (begin
            (vector-set! x i (expr->source (vector-ref v i)))
            (loop (- i 1)))))
      x))

  (expr->source expr))

;; (source->expression source) returns the Scheme expression represented by the
;; source 'source'.  Note that every call with the same argument returns a
;; different (i.e. non eq?) expression.  The implementation can handle cycles
;; and shared structure.

(define (source->expression source)
  (let ((visited (make-table 'test: eq?)))

    (define (share x)
      (table-ref visited x #f))

    (define (convert-pair p)
      (or (share p)
          (let ((new-p (cons #f #f)))
            (table-set! visited p new-p)
            (set-car! new-p (convert (car p)))
            (set-cdr! new-p (convert-list (cdr p)))
            new-p)))

    (define (convert-list lst)
      (cond ((pair? lst)
             (convert-pair lst))
            ((null? lst)
             '())
            (else
             (convert lst))))

    (define (convert-vector v)
      (or (share v)
          (let* ((len (vector-length v))
                 (new-v (make-vector len)))
            (table-set! visited v new-v)
            (let loop ((i (- len 1)))
              (if (< i 0)
                  new-v
                  (begin
                    (vector-set! new-v i (convert (vector-ref v i)))
                    (loop (- i 1))))))))

    (define (convert-box b)
      (or (share b)
          (let ((new-b (box-object #f)))
            (table-set! visited b new-b)
            (set-box-object! new-b (convert (unbox-object b)))
            new-b)))

    (define (convert source)
      (let ((code (source-code source)))
        (cond ((pair? code)
               (convert-list code))
              ((vector-object? code)
               (convert-vector code))
              ((box-object? code)
               (convert-box code))
              (else
               code))))

    (convert source)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; (include-expr->source source info-port) returns a list of the
;; source representation for each of the expressions contained in the
;; specified file.

(define (include-expr->sourcezzzzz source info-port)

  (define (find-source-file filename)

    (define (open-error filename)
      (pt-syntax-error
       source
       "Can't find file"
       (or (path-expand filename)
           filename)))

    (let ((expanded-filename (path-expand filename)))
      (if expanded-filename
        (if (equal? (path-extension expanded-filename) "")

          (let loop ((exts (append (map car scheme-file-extensions) '(""))))
            (if (pair? exts)
              (let* ((ext (car exts))
                     (full-name (string-append expanded-filename ext))
                     (port (open-input-file* full-name)))
                (if port
                  (begin
                    (close-input-port port)
                    full-name)
                  (loop (cdr exts))))
              (open-error filename)))

          (let ((port (open-input-file* expanded-filename)))
            (if port
              (begin
                (close-input-port port)
                expanded-filename)
              (open-error filename))))

        (open-error filename))))

  (let* ((filename-src
          (cadr (source-code source)))
         (filename
          (source-code filename-src))
         (rerooted-filename
          (path-expand
           filename
           (path-directory (path-expand (locat-filename (source-locat filename-src))))))
         (final-filename
          (find-source-file rerooted-filename))
         (re
          (**readenv-open final-filename)))

    (define (read-sources) ; return list of all sources in file
';;;;;;;;;;;;;;;;;;;;;;;;;;;
      (let ((source ((or read-datum-or-eof **read-datum-or-eof) re)))
        (if (vector-object? source)
          (begin
            (if info-port (display "." info-port))
            (cons source (read-sources)))
          '()))
      (##vector-ref
       (##read-all-as-a-begin-expr-from-port
        (**readenv-port re)
        (##current-readtable)
        (lambda (re x)
          (make-source x
                       (##make-locat (##port-name (macro-readenv-port re))
                                     (macro-readenv-filepos re))))
        (lambda (re x)
          (source-code x))
        #f
        #f)
       1));;;;;;;;;;;;;;;;;;;;;;;

    (if info-port
      (begin
        (display "(reading " info-port)
        (write (path-expand final-filename) info-port)))

    (let ((sources (read-sources)))

      (if info-port (display ")" info-port))

      (**readenv-close re)

      sources)))

(define (read-source path relative-to-path try-scheme-file-extensions?)

  (define (read-source-from-path path)
    (let ((container (##path->container path)))
      (##read-all-as-a-begin-expr-from-path
       path
       (##current-readtable);;;;;;;;;;;;;;;;;;;;
       (lambda (re x)
         (if (source? x)
             x
             (let ((locat
                    (##make-locat container
                                  (##filepos->position
                                   (macro-readenv-filepos re)))))
               (make-source x locat))))
       (lambda (re x)
         (source-code x)))))

  (define (read-source-no-extension)
    (let loop ((lst ##scheme-file-extensions))
      (if (pair? lst)
        (let ((x (read-source-from-path (string-append path (caar lst)))))
          (if (##fixnum? x)
            (loop (cdr lst))
            x))
        #f)))

  (or (and try-scheme-file-extensions?
           (string=? (path-extension path) "")
           (read-source-no-extension))
      (let* ((abs-path (##path-reference path relative-to-path))
             (x (read-source-from-path abs-path)))
        (if (##fixnum? x)
          (compiler-error "Can't find file" abs-path)
          x))))

(define (include-expr->source source info-port)
  (let* ((filename-src
          (cadr (source-code source)))
         (filename
          (source-code filename-src))
         (x
          (read-source filename
                       (locat-filename (source-locat filename-src))
                       #f)))
    (##vector-ref x 1)));;;;;;;;;;;;;;;;;;;;;;;;

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Tables for reader.

(define **standard-escaped-char-table
  (list
    (cons #\\ #\\)
    (cons #\a (unicode->character 7))
    (cons #\b (unicode->character 8))
    (cons #\t (unicode->character 9))
    (cons #\n #\newline)
    (cons #\v (unicode->character 11))
    (cons #\f (unicode->character 12))
    (cons #\r (unicode->character 13))))

(define **standard-named-char-table
  (list
    (cons "newline"   #\newline)
    (cons "space"     #\ )
    (cons "nul"       (unicode->character 0))
    (cons "bel"       (unicode->character 7))
    (cons "backspace" (unicode->character 8))
    (cons "tab"       (unicode->character 9))
    (cons "linefeed"  (unicode->character 10))
    (cons "vt"        (unicode->character 11))
    (cons "page"      (unicode->character 12))
    (cons "return"    (unicode->character 13))
    (cons "rubout"    (unicode->character 127))))

(define **standard-sharp-bang-table
  (list
    (cons "optional" optional-object)
    (cons "rest"     rest-object)
    (cons "key"      key-object)
    (cons "eof"      end-of-file-object)))

(set! **standard-sharp-bang-table;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      (append (list (cons "void"     (##type-cast -5 (##type #f)))
                    (cons "unbound1" (##type-cast -7 (##type #f)))
                    (cons "unbound2" (##type-cast -8 (##type #f))))
                **standard-sharp-bang-table))

;;;============================================================================

;; The reader.

;; For compatibility between the interpreter and compiler, this section
;; must be the same as the corresponding section in the file
;; "lib/_io.scm" (except that ## and ** are exchanged).

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; A chartable structure is a vector-like data structure which is
;; indexed using a character.

(define (**make-chartable default)
  (vector (make-vector 128 default) default '()))

(define (**chartable-ref ct c)
  (let ((i (character->unicode c)))
    (if (< i 128)
      (vector-ref (vector-ref ct 0) i)
      (let ((x (assq i (vector-ref ct 2))))
        (if x
          (cdr x)
          (vector-ref ct 1))))))

(define (**chartable-set! ct c val)
  (let ((i (character->unicode c)))
    (if (< i 128)
      (vector-set! (vector-ref ct 0) i val)
      (let ((x (assq i (vector-ref ct 2))))
        (if x
          (set-cdr! x val)
          (vector-set! ct 2 (cons (cons i val) (vector-ref ct 2))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; A readtable structure contains parsing information for the reader.
;; It indicates what action must be taken when a given character is
;; encountered.

(define **readtable-tag '#(readtable 0))

(define (**make-readtable
         case-conversion?
         keywords-allowed?
         escaped-char-table
         named-char-table
         sharp-bang-table
         char-delimiter?-table
         char-handler-table)
;;  (**subtype-set!
    (vector
     **readtable-tag
     case-conversion?
     keywords-allowed?
     escaped-char-table
     named-char-table
     sharp-bang-table
     char-delimiter?-table
     char-handler-table)
;;    (subtype-structure))
)

(define (**readtable-case-conversion? rt)
  (vector-ref rt 1))

(define (**readtable-case-conversion?-set! rt x)
  (vector-set! rt 1 x))

(define (**readtable-keywords-allowed? rt)
  (vector-ref rt 2))

(define (**readtable-keywords-allowed?-set! rt x)
  (vector-set! rt 2 x))

(define (**readtable-escaped-char-table rt)
  (vector-ref rt 3))

(define (**readtable-escaped-char-table-set! rt x)
  (vector-set! rt 3 x))

(define (**readtable-named-char-table rt)
  (vector-ref rt 4))

(define (**readtable-named-char-table-set! rt x)
  (vector-set! rt 4 x))

(define (**readtable-sharp-bang-table rt)
  (vector-ref rt 5))

(define (**readtable-sharp-bang-table-set! rt x)
  (vector-set! rt 5 x))

(define (**readtable-char-delimiter?-table rt)
  (vector-ref rt 6))

(define (**readtable-char-delimiter?-table-set! rt x)
  (vector-set! rt 6 x))

(define (**readtable-char-handler-table rt)
  (vector-ref rt 7))

(define (**readtable-char-handler-table-set! rt x)
  (vector-set! rt 7 x))

(define (**readtable-char-delimiter? rt c)
  (**chartable-ref (**readtable-char-delimiter?-table rt) c))

(define (**readtable-char-delimiter?-set! rt c delimiter?)
  (**chartable-set! (**readtable-char-delimiter?-table rt) c delimiter?))

(define (**readtable-char-handler rt c)
  (**chartable-ref (**readtable-char-handler-table rt) c))

(define (**readtable-char-handler-set! rt c handler)
  (**chartable-set! (**readtable-char-handler-table rt) c handler))

(define (**readtable-char-class-set! rt c delimiter? handler)
  (begin
    (**readtable-char-delimiter?-set! rt c delimiter?)
    (**readtable-char-handler-set! rt c handler)))

(define (**readtable-convert-case rt c)
  (let ((case-conversion? (**readtable-case-conversion? rt)))
    (if case-conversion?
      (if (eq? case-conversion? 'upcase)
        (char-upcase c)
        (char-downcase c))
      c)))

(define (**readtable-string-convert-case! rt s)
  (let ((case-conversion? (**readtable-case-conversion? rt)))
    (if case-conversion?
      (if (eq? case-conversion? 'upcase)
        (let loop ((i (- (string-length s) 1)))
          (if (not (< i 0))
            (begin
              (string-set! s i (char-upcase (string-ref s i)))
              (loop (- i 1)))))
        (let loop ((i (- (string-length s) 1)))
          (if (not (< i 0))
            (begin
              (string-set! s i (char-downcase (string-ref s i)))
              (loop (- i 1)))))))))

(define (**readtable-parse-keyword rt s)
  (let ((keywords-allowed? (**readtable-keywords-allowed? rt)))
    (and keywords-allowed?
         (let ((len (string-length s)))
           (and (< 1 len)
                (if (eq? keywords-allowed? 'prefix)
                    (and (char=? (string-ref s 0) #\:)
                         (string->keyword-object
                          (substring s 1 len)))
                    (and (char=? (string-ref s (- len 1)) #\:)
                         (string->keyword-object
                          (substring s 0 (- len 1))))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Error handling.

(define (**read-error-datum-or-eof-expected re)
  ((**readenv-error-proc re) re "Datum or EOF expected"))

(define (**read-error-datum-expected re)
  ((**readenv-error-proc re) re "Datum expected"))

(define (**read-error-improperly-placed-dot re)
  ((**readenv-error-proc re) re "Improperly placed dot"))

(define (**read-error-incomplete-form-eof-reached re)
  ((**readenv-error-proc re) re "Incomplete form, EOF reached"))

(define (**read-error-incomplete re)
  ((**readenv-error-proc re) re "Incomplete form"))

(define (**read-error-char-name re str)
  ((**readenv-error-proc re) re "Invalid '#\\' name:" str))

(define (**read-error-illegal-char re c)
  ((**readenv-error-proc re) re "Illegal character:" c))

(define (**read-error-u8 re)
  ((**readenv-error-proc re) re "8 bit exact integer expected"))

(define (**read-error-u16 re)
  ((**readenv-error-proc re) re "16 bit exact integer expected"))

(define (**read-error-u32 re)
  ((**readenv-error-proc re) re "32 bit exact integer expected"))

(define (**read-error-u64 re)
  ((**readenv-error-proc re) re "64 bit exact integer expected"))

(define (**read-error-f32/f64 re)
  ((**readenv-error-proc re) re "Inexact real expected"))

(define (**read-error-hex re)
  ((**readenv-error-proc re) re "Invalid hexadecimal escape"))

(define (**read-error-escaped-char re c)
  ((**readenv-error-proc re) re "Invalid escaped character:" c))

(define (**read-error-vector re)
  ((**readenv-error-proc re) re "'(' expected"))

(define (**read-error-sharp-token re str)
  ((**readenv-error-proc re) re "Invalid token:" str))

(define (**read-error-sharp-bang-name re str)
  ((**readenv-error-proc re) re "Invalid '#!' name:" str))

(define (**read-error-char-range re)
  ((**readenv-error-proc re) re "Character out of range"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Procedures to read single characters.

(define (**peek-next-char re) ; never returns end-of-file
  (let ((next (**peek-next-char-or-eof re)))
    (if (char? next)
      next
      (**read-error-incomplete-form-eof-reached re))))

(define (**read-next-char re) ; never returns end-of-file
  (let ((c (**read-next-char-or-eof re)))
    (if (char? c)
      c
      (**read-error-incomplete-form-eof-reached re))))

(define (**read-next-char-expecting re c) ; only accepts c as the next char
  (let ((x (**read-next-char-or-eof re)))
    (if (char? x)
      (if (not (char=? x c))
        (**read-error-incomplete re))
      (**read-error-incomplete-form-eof-reached re))
    x))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Procedures to read datums.

;; (**read-datum-or-eof re) attempts to read a datum in the read
;; environment "re", skipping all whitespace and comments in the
;; process.  The "pos" field of the read environment indicates the
;; position where the enclosing datum starts (e.g. list or vector).  If
;; a datum is read it is returned (wrapped if the read environment asks
;; for it); if the end-of-file is reached the end-of-file object is
;; returned (never wrapped); otherwise an error is signaled.  The read
;; environment's "pos" field is only modified if a datum was read, in
;; which case it is the position where the datum starts.

(define (**read-datum-or-eof re)
  (let ((obj (**read-datum-or-none re)))
    (if (eq? obj (**none-marker))
      (let ((c (**peek-next-char-or-eof re)))
        (if (char? c)
          (begin
            (**readenv-filepos-set! re (**readenv-current-filepos re))
            (**read-next-char-or-eof re) ; to make sure reader makes progress
            (**read-error-datum-or-eof-expected re))
          (begin
            (**read-next-char-or-eof re) ; to make sure reader makes progress
            c))) ; end-of-file was reached so return end-of-file object
      obj)))

;; (**read-datum re) attempts to read a datum in the read environment
;; "re", skipping all whitespace and comments in the process.  The
;; "pos" field of the read environment indicates the position where the
;; enclosing datum starts (e.g. list or vector).  If a datum is read it
;; is returned (wrapped if the read environment asks for it); if the
;; end-of-file is reached or no datum can be read an error is signaled.
;; The read environment's "pos" field is only modified if a datum was
;; read, in which case it is the position where the datum starts.

(define (**read-datum re)
  (let ((obj (**read-datum-or-none re)))
    (if (eq? obj (**none-marker))
      (begin
        (**readenv-filepos-set! re (**readenv-current-filepos re))
        (**read-next-char-or-eof re) ; to make sure reader makes progress
        (**read-error-datum-expected re))
      obj)))

;; (**read-datum-or-none re) attempts to read a datum in the read
;; environment "re", skipping all whitespace and comments in the
;; process.  The "pos" field of the read environment indicates the
;; position where the enclosing datum starts (e.g. list or vector).  If
;; a datum is read it is returned (wrapped if the read environment asks
;; for it); if the end-of-file is reached or no datum can be read the
;; "none-marker" is returned.  The read environment's "pos" field is
;; only modified if a datum was read, in which case it is the position
;; where the datum starts.

(define (**read-datum-or-none re)
  (let ((obj (**read-datum-or-none-or-dot re)))
    (if (eq? obj (**dot-marker))
      (begin
        (**readenv-filepos-set! re (**readenv-previous-filepos re 1))
        (**read-error-improperly-placed-dot re))
      obj)))

;; (**read-datum-or-none-or-dot re) attempts to read a datum in the
;; read environment "re", skipping all whitespace and comments in the
;; process.  The "pos" field of the read environment indicates the
;; position where the enclosing datum starts (e.g. list or vector).  If
;; a datum is read it is returned (wrapped if the read environment asks
;; for it); if a lone dot is read the "dot-marker" is returned; if the
;; end-of-file is reached or no datum can be read the "none-marker" is
;; returned.  The read environment's "pos" field is only modified if a
;; datum was read, in which case it is the position where the datum
;; starts.

(define (**read-datum-or-none-or-dot re)
  (let ((next (**peek-next-char-or-eof re)))
    (if (char? next)
      ((**readtable-char-handler (**readenv-readtable re) next) re next)
      (**none-marker))))

;; Special objects returned by **read-datum-or-none-or-dot.

(define (**none-marker) '#(none)) ; indicates no following datum
(define (**dot-marker) '#(dot))   ; indicates an isolated dot

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Procedure to read a list of datums (possibly an improper list).

(define (**build-list re allow-improper? start-pos close)
  (let ((obj (**read-datum-or-none re)))
    (if (eq? obj (**none-marker))
      (begin
        (**read-next-char-expecting re close)
        '())
      (let ((lst (cons obj '())))
        (**readenv-filepos-set! re start-pos) ; restore pos
        (let loop ((end lst))
          (let ((obj
                 (if allow-improper?
                   (**read-datum-or-none-or-dot re)
                   (**read-datum-or-none re))))
            (cond ((eq? obj (**none-marker))
                   (**read-next-char-expecting re close)
                   lst)
                  ((eq? obj (**dot-marker))
                   (let ((obj (**read-datum re)))
                     (set-cdr! end obj)
                     (**readenv-filepos-set! re start-pos) ; restore pos
                     (let ((x (**read-datum-or-none re))) ; skip whitespace!
                       (if (eq? x (**none-marker))
                         (begin
                           (**read-next-char-expecting re close)
                           lst)
                         (begin
                           (**readenv-filepos-set! re start-pos) ; restore pos
                           (**read-error-incomplete re))))))
                  (else
                   (**readenv-filepos-set! re start-pos) ; restore pos
                   (let ((tail (cons obj '())))
                     (set-cdr! end tail)
                     (loop tail))))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Procedure to read a vector or byte vector.

(define (**build-vector re kind start-pos close)

  (define (exact-integer-check n lo hi)
    (and (integer? n)
         (exact? n)
         (in-integer-range? n lo hi)))

  (define (inexact-real-check n)
    (and (real? n)
         (not (exact? n))))

  (let loop ((i 0))
    (let* ((x (**read-datum-or-none re))
           (x-pos (**readenv-filepos re)))
      (**readenv-filepos-set! re start-pos) ; restore pos
      (if (eq? x (**none-marker))
        (begin
          (**read-next-char-expecting re close)
          (case kind
            ((vector)    (make-vector i #f))
            ((u8vector)  (make-u8vect i))
            ((u16vector) (make-u16vect i))
            ((u32vector) (make-u32vect i))
            ((u64vector) (make-u64vect i))
            ((f32vector) (make-f32vect i))
            ((f64vector) (make-f64vect i))))
        (let ((vect (loop (+ i 1))))
          (case kind
            ((vector)
             (vector-set! vect i x))
            ((u8vector)
             (let ((ux (**readenv-unwrap re x)))
               (if (not (exact-integer-check ux 0 255))
                 (begin
                   (**readenv-filepos-set! re x-pos) ; restore pos of element
                   (**read-error-u8 re)))
               (u8vect-set! vect i ux)))
            ((u16vector)
             (let ((ux (**readenv-unwrap re x)))
               (if (not (exact-integer-check ux 0 65535))
                 (begin
                   (**readenv-filepos-set! re x-pos) ; restore pos of element
                   (**read-error-u16 re)))
               (u16vect-set! vect i ux)))
            ((u32vector)
             (let ((ux (**readenv-unwrap re x)))
               (if (not (exact-integer-check ux 0 4294967295))
                 (begin
                   (**readenv-filepos-set! re x-pos) ; restore pos of element
                   (**read-error-u32 re)))
               (u32vect-set! vect i ux)))
            ((u64vector)
             (let ((ux (**readenv-unwrap re x)))
               (if (not (exact-integer-check ux 0 18446744073709551615))
                 (begin
                   (**readenv-filepos-set! re x-pos) ; restore pos of element
                   (**read-error-u64 re)))
               (u64vect-set! vect i ux)))
            ((f32vector)
             (let ((ux (**readenv-unwrap re x)))
               (if (not (inexact-real-check ux))
                 (begin
                   (**readenv-filepos-set! re x-pos) ; restore pos of element
                   (**read-error-f32/f64 re)))
               (f32vect-set! vect i ux)))
            ((f64vector)
             (let ((ux (**readenv-unwrap re x)))
               (if (not (inexact-real-check ux))
                 (begin
                   (**readenv-filepos-set! re x-pos) ; restore pos of element
                   (**read-error-f32/f64 re)))
               (f64vect-set! vect i ux))))
          vect)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Procedures to read delimited tokens.

(define (**build-delimited-string re c i)
  (let loop ((i i))
    (let ((next (**peek-next-char-or-eof re)))
      (if (or (not (char? next))
              (**readtable-char-delimiter? (**readenv-readtable re) next))
        (make-string i c)
        (begin
          (**read-next-char-or-eof re) ; skip "next"
          (let ((s (loop (+ i 1))))
            (string-set! s i next)
            s))))))

(define (**build-delimited-number/keyword/symbol re c)
  (let ((s (**build-delimited-string re c 1)))
    (or (string->number s 10)
        (begin
          (**readtable-string-convert-case! (**readenv-readtable re) s)
          (or (**readtable-parse-keyword (**readenv-readtable re) s)
              (string->symbol s))))))

(define (**build-delimited-symbol re c i)
  (let ((s (**build-delimited-string re c i)))
    (**readtable-string-convert-case! (**readenv-readtable re) s)
    (string->symbol s)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (**build-escaped-string-up-to re close)

  (define (char-octal? c)
    (and (not (char<? c #\0)) (not (char<? #\7 c))))

  (define (char-hexadecimal? c)
    (or (and (not (char<? c #\0)) (not (char<? #\9 c)))
        (and (not (char<? c #\a)) (not (char<? #\f c)))
        (and (not (char<? c #\A)) (not (char<? #\F c)))))

  (define (unicode n)
    (if (in-char-range? n)
      (unicode->character n)
      (**read-error-char-range re)))

  (define (read-escape-octal c)
    (let ((str (let loop ((i 1))
                 (let ((next (**peek-next-char-or-eof re)))
                   (if (and (< i 3)
                            (char? next)
                            (char-octal? next))
                     (begin
                       (**read-next-char-or-eof re) ; skip "next"
                       (let ((s (loop (+ i 1))))
                         (string-set! s i next)
                         s))
                     (make-string i #\space))))))
      (string-set! str 0 c)
      (unicode (string->number str 8))))

  (define (read-escape-hexadecimal)
    (let ((next (**peek-next-char-or-eof re)))
      (if (and (char? next)
               (char-hexadecimal? next))
        (begin
          (**read-next-char-or-eof re) ; skip "next"
          (let ((str (let loop ((i 1))
                       (let ((next2 (**peek-next-char-or-eof re)))
                         (if (and (char? next2)
                                  (char-hexadecimal? next2))
                           (begin
                             (**read-next-char-or-eof re) ; skip "next2"
                             (let ((s (loop (+ i 1))))
                               (string-set! s i next2)
                               s))
                           (make-string i #\space))))))
            (string-set! str 0 next)
            (unicode (string->number str 16))))
        (**read-error-hex re))))

  (define (read-escape)
    (let ((next (**read-next-char re)))
      (cond ((char-octal? next)
             (read-escape-octal next))
            ((char=? next #\x)
             (read-escape-hexadecimal))
            ((char=? next close)
             close)
            (else
             (let ((x (assq next
                            (**readtable-escaped-char-table
                             (**readenv-readtable re)))))
               (if x
                 (cdr x)
                 (**read-error-escaped-char re next)))))))

  (define max-chunk-length 512)

  (define (read-chunk)
    (let loop ((i 0))
      (if (< i max-chunk-length)
        (let ((c (**read-next-char re)))
          (cond ((char=? c close)
                 (make-string i #\space))
                ((char=? c #\\)
                 (let* ((c (read-escape))
                        (s (loop (+ i 1))))
                   (string-set! s i c)
                   s))
                (else
                 (let ((s (loop (+ i 1))))
                   (string-set! s i c)
                   s))))
        (make-string i #\space))))

  (let ((chunk1 (read-chunk)))
    (if (< (string-length chunk1) max-chunk-length)
      chunk1
      (let loop ((chunks (list chunk1)))
        (let* ((new-chunk (read-chunk))
               (new-chunks (cons new-chunk chunks)))
          (if (< (string-length new-chunk) max-chunk-length)
            (**string-concatenate (reverse new-chunks))
            (loop new-chunks)))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Procedures to handle comments.

(define (**skip-extended-comment re open1 open2 close1 close2)
  (let loop ((level 0) (c (**read-next-char re)))
    (cond ((char=? c open1)
           (let ((c (**read-next-char re)))
             (if (char=? c open2)
               (loop (+ level 1) (**read-next-char re))
               (loop level c))))
          ((char=? c close1)
           (let ((c (**read-next-char re)))
             (if (char=? c close2)
               (if (< 0 level)
                 (loop (- level 1) (**read-next-char re))
                 #f) ; comment has ended
               (loop level c))))
          (else
           (loop level (**read-next-char re))))))

(define (**skip-single-line-comment re)
  (let loop ()
    (let ((next (**peek-next-char-or-eof re)))
      (if (char? next)
        (begin
          (**read-next-char-or-eof re) ; skip "next"
          (if (not (char=? next #\newline))
            (loop)))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Procedure to read datums starting with '#'.

(define (**read-sharp re c)
  (let ((start-pos (**readenv-current-filepos re)))
    (**read-next-char-or-eof re) ; skip #\#
    (let ((next (**peek-next-char re)))
      (cond ((char=? next #\()
             (**read-next-char-or-eof re) ; skip #\(
             (**readenv-filepos-set! re start-pos) ; set pos to start of datum
             (let ((vect (**build-vector re 'vector start-pos #\))))
               (**readenv-wrap re vect)))
            ((char=? next #\\)
             (**read-next-char-or-eof re) ; skip #\\
             (**readenv-filepos-set! re start-pos) ; set pos to start of datum
             (let ((c (**read-next-char re)))
               (if (**readtable-char-delimiter?
                    (**readenv-readtable re)
                    (**peek-next-char-or-eof re))
                 (**readenv-wrap re c)
                 (let ((name (**build-delimited-string re c 1)))
                   (let ((x (**read-assoc-string-ci=?
                             name
                             (**readtable-named-char-table
                              (**readenv-readtable re)))))
                     (if x
                       (**readenv-wrap re (cdr x))
                       (let ((n (string->number name 10)))
                         (if (and n
                                  (integer? n)
                                  (exact? n))
                           (if (in-char-range? n)
                             (**readenv-wrap re (unicode->character n))
                             (**read-error-char-range re))
                           (**read-error-char-name re name)))))))))
            ((char=? next #\|)
             (let ((old-pos (**readenv-filepos re)))
               (**readenv-filepos-set! re start-pos) ; in case error in comment
               (**read-next-char-or-eof re) ; skip #\|
               (**skip-extended-comment re #\# #\| #\| #\#)
               (**readenv-filepos-set! re old-pos) ; restore pos
               (**read-datum-or-none-or-dot re))) ; read what follows comment
            ((char=? next #\!)
             (**read-next-char-or-eof re) ; skip #\!
             (**readenv-filepos-set! re start-pos) ; set pos to start of datum
             (let ((name (**build-delimited-string re #\space 0)))
               (let ((x (**read-assoc-string-ci=?
                         name
                         (**readtable-sharp-bang-table
                          (**readenv-readtable re)))))
                 (if x
                   (**readenv-wrap re (cdr x))
                   (**read-error-sharp-bang-name re name)))))
            ((char=? next #\#)
             (**read-next-char-or-eof re) ; skip #\#
             (**readenv-filepos-set! re start-pos) ; set pos to start of datum
             (let ((sym (**build-delimited-symbol re #\# 2)))
               (**readenv-wrap re sym)))
            (else
             (**readenv-filepos-set! re start-pos) ; set pos to start of datum
             (let* ((s
                     (**build-delimited-string re c 1))
                    (obj
                     (or (string->number s 10)
                         (let ()

                           (define (build-vect re kind)
                             (let ((c (**read-next-char re)))
                               (if (char=? c #\()
                                 (**build-vector re kind start-pos #\))
                                 (**read-error-vector re))))

                           (cond ((string-ci=? s "#f")
                                  (false-obj))
                                 ((string-ci=? s "#t")
                                  #t)
                                 ((string-ci=? s "#u8")
                                  (build-vect re 'u8vector))
                                 ((string-ci=? s "#u16")
                                  (build-vect re 'u16vector))
                                 ((string-ci=? s "#u32")
                                  (build-vect re 'u32vector))
                                 ((string-ci=? s "#u64")
                                  (build-vect re 'u64vector))
                                 ((string-ci=? s "#f32")
                                  (build-vect re 'f32vector))
                                 ((string-ci=? s "#f64")
                                  (build-vect re 'f64vector))
                                 (else
                                  (**read-error-sharp-token re s)))))))
               (**readenv-wrap re obj)))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (**read-whitespace re c)
  (**read-next-char-or-eof re) ; skip whitespace character
  (**read-datum-or-none-or-dot re)) ; read what follows whitespace

(define (**read-single-line-comment re c)
  (**skip-single-line-comment re) ; skip comment
  (**read-datum-or-none-or-dot re)) ; read what follows comment

(define (**read-escaped-string re c)
  (let ((start-pos (**readenv-current-filepos re)))
    (**read-next-char-or-eof re) ; skip #\"
    (**readenv-filepos-set! re start-pos) ; set pos to start of datum
    (let ((str (**build-escaped-string-up-to re c)))
      (**readenv-wrap re str))))

(define (**read-escaped-symbol re c)
  (let ((start-pos (**readenv-current-filepos re)))
    (**read-next-char-or-eof re) ; skip #\|
    (**readenv-filepos-set! re start-pos) ; set pos to start of datum
    (let ((sym (string->symbol (**build-escaped-string-up-to re c))))
      (**readenv-wrap re sym))))

(define (**read-quotation re c)
  (let ((start-pos (**readenv-current-filepos re)))
    (**read-next-char-or-eof re) ; skip #\'
    (**readenv-filepos-set! re start-pos) ; set pos to start of datum
    (let ((obj (**read-datum re)))
      (**readenv-filepos-set! re start-pos) ; set pos to start of datum
      (**readenv-wrap
       re
       (list (**readenv-wrap re 'quote) obj)))))

(define (**read-quasiquotation re c)
  (let ((start-pos (**readenv-current-filepos re)))
    (**read-next-char-or-eof re) ; skip #\`
    (**readenv-filepos-set! re start-pos) ; set pos to start of datum
    (let ((obj (**read-datum re)))
      (**readenv-filepos-set! re start-pos) ; set pos to start of datum
      (**readenv-wrap
       re
       (list (**readenv-wrap re 'quasiquote) obj)))))

(define (**read-unquotation re c)
  (let ((start-pos (**readenv-current-filepos re)))
    (**read-next-char-or-eof re) ; skip #\,
    (**readenv-filepos-set! re start-pos) ; set pos to start of datum
    (let ((next (**peek-next-char re)))
      (if (char=? next #\@)
        (begin
          (**read-next-char-or-eof re) ; skip #\@
          (let ((obj (**read-datum re)))
            (**readenv-filepos-set! re start-pos) ; set pos to start of datum
            (**readenv-wrap
             re
             (list (**readenv-wrap re 'unquote-splicing) obj))))
        (let ((obj (**read-datum re)))
          (**readenv-filepos-set! re start-pos) ; set pos to start of datum
          (**readenv-wrap
           re
           (list (**readenv-wrap re 'unquote) obj)))))))

(define (**read-list re c)
  (let ((start-pos (**readenv-current-filepos re)))
    (**read-next-char-or-eof re) ; skip #\( or #\[ or #\{
    (**readenv-filepos-set! re start-pos) ; set pos to start of datum
    (let ((close
           (cond ((char=? c #\[) #\])
                 ((char=? c #\{) #\})
                 (else           #\)))))
      (let ((lst (**build-list re #t start-pos close)))
        (**readenv-wrap re lst)))))

(define (**read-none re c)
  (**none-marker))

(define (**read-illegal re c)
  (let ((start-pos (**readenv-current-filepos re)))
    (**read-next-char-or-eof re) ; skip illegal character
    (**readenv-filepos-set! re start-pos) ; set pos to illegal char
    (**read-error-illegal-char re c)))

(define (**read-dot re c)
  (let ((start-pos (**readenv-current-filepos re)))
    (**read-next-char-or-eof re) ; skip #\.
    (let ((next (**peek-next-char-or-eof re)))
      (if (or (not (char? next))
              (**readtable-char-delimiter? (**readenv-readtable re) next))
        (**dot-marker)
        (begin
          (**readenv-filepos-set! re start-pos) ; set pos to start of datum
          (let ((obj (**build-delimited-number/keyword/symbol re c)))
            (**readenv-wrap re obj)))))))

(define (**read-number/keyword/symbol re c)
  (let ((start-pos (**readenv-current-filepos re)))
    (**read-next-char-or-eof re) ; skip "c"
    (**readenv-filepos-set! re start-pos) ; set pos to start of datum
    (let ((obj (**build-delimited-number/keyword/symbol re c)))
      (**readenv-wrap re obj))))

(define (**read-assoc-string-ci=? x lst)
  (let loop ((lst lst))
    (if (pair? lst)
      (let ((couple (car lst)))
        (let ((y (car couple)))
          (if (string-ci=? x y)
            couple
            (loop (cdr lst)))))
      #f)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Setup the standard readtable.

(define (**make-standard-readtable)
  (let ((rt
         (**make-readtable
          #f ; preserve case in symbols, character names, etc
          #t ; keywords ending with ":" are allowed
          **standard-escaped-char-table
          **standard-named-char-table
          **standard-sharp-bang-table
          (**make-chartable #f) ; all chars are non-delimiters
          (**make-chartable **read-number/keyword/symbol))))

    (if (**comply-to-standard-scheme?) ; force compliance to standard Scheme?
      (begin
        (**readtable-case-conversion?-set! rt #t)
        (**readtable-keywords-allowed?-set! rt #f)))

    ; setup control characters

    (let loop ((i 31))
      (if (not (< i 0))
        (begin
          (**readtable-char-class-set!
           rt
           (unicode->character i)
           #t
           **read-illegal)
          (loop (- i 1)))))

    ; setup whitespace characters

    (**readtable-char-class-set! rt #\space    #t **read-whitespace)
    (**readtable-char-class-set! rt #\linefeed #t **read-whitespace)
    (**readtable-char-class-set! rt #\return   #t **read-whitespace)
    (**readtable-char-class-set! rt #\tab      #t **read-whitespace)
    (**readtable-char-class-set! rt #\page     #t **read-whitespace)

    ; setup handlers for non-whitespace delimiters

    (**readtable-char-class-set! rt #\; #t **read-single-line-comment)

    (**readtable-char-class-set! rt #\" #t **read-escaped-string)
    (**readtable-char-class-set! rt #\| #t **read-escaped-symbol)

    (**readtable-char-class-set! rt #\' #t **read-quotation)
    (**readtable-char-class-set! rt #\` #t **read-quasiquotation)
    (**readtable-char-class-set! rt #\, #t **read-unquotation)

    (**readtable-char-class-set! rt #\( #t **read-list)
    (**readtable-char-class-set! rt #\) #t **read-none)

    (**readtable-char-class-set! rt #\[ #t **read-list)
    (**readtable-char-class-set! rt #\] #t **read-none)

    (**readtable-char-class-set! rt #\{ #t **read-illegal)
    (**readtable-char-class-set! rt #\} #t **read-illegal)

    ; setup handlers for "#" and "." (these are NOT delimiters)

    (**readtable-char-class-set! rt #\# #f **read-sharp)
    (**readtable-char-class-set! rt #\. #f **read-dot)

    rt))

(if (not **main-readtable)
  (set! **main-readtable
    (**make-standard-readtable)))

;;;============================================================================

'(;;;;;;;;;;;

(include "fixnum.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include     "_sourceadt.scm")

(define (**filepos-line filepos)
  (##filepos-line filepos))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Symbol "canonicalization".

(define (string->canonical-symbol str)
  (let ((new-str (string-append str "")))
    (##readtable-string-convert-case! (current-readtable) new-str)
    new-str))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; 'location' manipulation

(define (expr->locat expr source)
  (vector source expr));;;;;;;;;;;;;;;;;;;;;;

(define (locat-show prefix loc)
  (if loc

    (if (string? (vector-ref loc 0)) ; file?
      (let* ((filename (vector-ref loc 0))
             (filepos (vector-ref loc 1))
             (str (format-filepos filename filepos #t)))
        (if str
          (begin
            (display prefix)
            (display str))
          (let ((line (+ (**filepos-line filepos) 1))
                (col (+ (**filepos-col filepos) 1))
                (filename*
                 (if (string? filename)
                   (path-expand filename)
                   filename)))
            (display prefix)
            (write filename*)
            (display "@")
            (display line)
            (display ".")
            (display col))))
      (let ((source (vector-ref loc 0))
            (expr (vector-ref loc 1)))
       (display prefix)
       (display "EXPRESSION ")
       (write expr)
       (if source
         (locat-show " " (source-locat source)))))

    (display "UNKNOWN LOCATION")))

(define (locat-filename-and-line loc)
  (if loc
    (if (string? (vector-ref loc 0)) ; file?
      (let* ((filename (vector-ref loc 0))
             (filepos (vector-ref loc 1))
             (line (+ (**filepos-line filepos) 1)))
        (cons filename line))
      (let ((source (vector-ref loc 0))
            (expr (vector-ref loc 1)))
       (if source
         (locat-filename-and-line (source-locat source))
         (cons "" 1))))
    (cons "" 1)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; 'source' manipulation

;; (expression->source expr source) returns the source that represent
;; the Scheme expression 'expr' and is related to the source 'source'
;; (#f if no relation).

(define (expression->source expr source)

  (define (expr->source x)
    (make-source (cond ((pair? x)
                        (list-convert x))
                       ((box-object? x)
                        (box-object (expr->source (unbox-object x))))
                       ((vector-object? x)
                        (vector-convert x))
                       (else
                        x))
                 (expr->locat x source)))

  (define (list-convert l)
    (cons (expr->source (car l))
          (list-tail-convert (cdr l))))

  (define (list-tail-convert l)
    (cond ((pair? l)
           (if (quoting-form? l) ; so that macros which generate quoting-forms
             (expr->source l)    ; at the tail of a list work properly
             (cons (expr->source (car l))
                   (list-tail-convert (cdr l)))))
          ((null? l)
           '())
          (else
           (expr->source l))))

  (define (quoting-form? x)
    (let ((first (car x))
          (rest (cdr x)))
      (and (pair? rest)
           (null? (cdr rest))
           (or (eq? first quote-sym)
               (eq? first quasiquote-sym)
               (eq? first unquote-sym)
               (eq? first unquote-splicing-sym)))))

  (define (vector-convert v)
    (let* ((len (vector-length v))
           (x (make-vector len)))
      (let loop ((i (- len 1)))
        (if (>= i 0)
          (begin
            (vector-set! x i (expr->source (vector-ref v i)))
            (loop (- i 1)))))
      x))

  (expr->source expr))

;; (source->expression source) returns the Scheme expression
;; represented by the source 'source'.  Note that every call with the
;; same argument returns a different (i.e. non eq?) expression.

(define (source->expression source)

  (define (list->expression l)
    (cond ((pair? l)
           (cons (source->expression (car l)) (list->expression (cdr l))))
          ((null? l)
           '())
          (else
           (source->expression l))))

  (define (vector->expression v)
    (let* ((len (vector-length v))
           (x (make-vector len)))
      (let loop ((i (- len 1)))
        (if (>= i 0)
          (begin
            (vector-set! x i (source->expression (vector-ref v i)))
            (loop (- i 1)))))
      x))

  (let ((code (source-code source)))
    (cond ((pair? code)
           (list->expression code))
          ((box-object? code)
           (box-object (source->expression (unbox-object code))))
          ((vector-object? code)
           (vector->expression code))
          (else
           code))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; (include-expr->source source info-port) returns the source
;; representation of a "begin" form containing the expressions
;; contained in the specified file.

(define (include-expr->source source info-port)

  (define (find-source-file filename)

    (define (open-error filename)
      (pt-syntax-error
       source
       "Can't find file"
       (or (path-expand filename)
           filename)))

    (let ((expanded-filename (path-expand filename)))
      (if expanded-filename
        (if (equal? (path-extension expanded-filename) "")

          (let loop ((exts (append (map car scheme-file-extensions) '(""))))
            (if (pair? exts)
              (let* ((ext (car exts))
                     (full-name (string-append expanded-filename ext))
                     (port (open-input-file* full-name)))
                (if port
                  (begin
                    (close-input-port port)
                    full-name)
                  (loop (cdr exts))))
              (open-error filename)))

          (let ((port (open-input-file* expanded-filename)))
            (if port
              (begin
                (close-input-port port)
                expanded-filename)
              (open-error filename))))

        (open-error filename))))

  (let* ((filename-src
          (cadr (source-code source)))
         (filename
          (source-code filename-src))
         (rerooted-filename
          (path-expand
           filename
           (path-directory (path-expand (locat-filename (source-locat filename-src))))))
         (final-filename
          (find-source-file rerooted-filename))
         (re
          (**readenv-open final-filename)))

    (define (read-sources) ; return list of all sources in file
';;;;;;;;;;;;;;;;;;;;;;;;;;;
      (let ((source ((or read-datum-or-eof **read-datum-or-eof) re)))
        (if (vector-object? source)
          (begin
            (if info-port (display "." info-port))
            (cons source (read-sources)))
          '()))
      (##vector-ref
       (##read-all-as-a-begin-expr-from-port
        (**readenv-port re)
        (##current-readtable)
        (lambda (re x)
          (make-source x (##readenv->locat re)))
        (lambda (re x)
          (source-code x))
        #f
        #f)
       1));;;;;;;;;;;;;;;;;;;;;;;

    (if info-port
      (begin
        (display "(reading " info-port)
        (write (path-expand final-filename) info-port)))

    (let ((sources (read-sources)))

      (if info-port (display ")" info-port))

      (**readenv-close re)

      sources)))
)
