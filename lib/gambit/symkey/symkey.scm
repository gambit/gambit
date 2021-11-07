;;;============================================================================

;;; File: "symkey.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Symbol and keyword operations.

(##include "symkey#.scm")

;;;----------------------------------------------------------------------------

(define-fail-check-type symbol 'symbol)

(define-prim (##make-uninterned-symbol name hash))
(define-prim (##symbol-name sym))
(define-prim (##symbol-name-set! sym name))
(define-prim (##symbol-hash sym))
(define-prim (##symbol-hash-set! sym hash))
(define-prim (##symbol-interned? sym))
(define-prim (##symbol? obj))

(define-prim (symbol? obj)
  (macro-force-vars (obj)
    (##symbol? obj)))

(define-prim (##symbol->string? sym)
  (let ((name (##symbol-name sym)))
    (if (##fixnum? name)
        #f
        name)))

(define-prim (##symbol->string sym)
  (let ((name (##symbol-name sym)))
    (if (##fixnum? name)
        (let ((str (##string-append "g" (##number->string name 10))))
          (##declare (not interrupts-enabled))
          (let ((name (##symbol-name sym)))
            ;; Double-check in case a different thread has also called
            ;; and completed the call to ##symbol->string on this symbol.
            (if (##fixnum? name)
                (begin
                  (##symbol-name-set! sym str)
                  str)
                name)))
        name)))

(define-prim (symbol->string sym)
  (macro-force-vars (sym)
    (macro-check-symbol sym 1 (symbol->string sym)
      (##symbol->string sym))))

(define-prim (##string->symbol str)
  (##make-interned-symbol str))

(define-prim (string->symbol str)
  (macro-force-vars (str)
    (macro-check-string str 1 (string->symbol str)
      (##string->symbol str))))

(define-prim (##uninterned-symbol? obj)
  (and (##symbol? obj)
       (##not (##symbol-interned? obj))))

(define-prim (uninterned-symbol? obj)
  (macro-force-vars (obj)
    (##uninterned-symbol? obj)))

(define ##symbol-counter 0)

(define-prim (##string->uninterned-symbol
              str
              #!optional
              (hash (macro-absent-obj)))

  ;; str must be a nonmutable string

  (if (##eq? hash (macro-absent-obj))
      (let ((n (##fxwrap+ ##symbol-counter 1)))
        ;; Note: it is unimportant if the increment of ##symbol-counter
        ;; is not atomic; it simply means a possible close repetition
        ;; of the same hash code.  The counter will wrap around eventually.
        (set! ##symbol-counter n)
        (##make-uninterned-symbol str (##fxand 536870911 (##fxxor n (##partial-bit-reverse n)))))
      (##make-uninterned-symbol str hash)))

(define-prim (string->uninterned-symbol
              str
              #!optional
              (hash (macro-absent-obj)))
  (macro-force-vars (str hash)
    (macro-check-string str 1 (string->uninterned-symbol str hash)
      (if (##eq? hash (macro-absent-obj))
          (##string->uninterned-symbol str)
          (macro-check-fixnum-range-incl hash 2 0 536870911 (string->uninterned-symbol str hash)
            (##string->uninterned-symbol str hash))))))

;;;----------------------------------------------------------------------------

(define-fail-check-type keyword 'keyword)

(define-prim (##make-uninterned-keyword name hash))
(define-prim (##keyword-name key))
(define-prim (##keyword-name-set! key name))
(define-prim (##keyword-hash key))
(define-prim (##keyword-hash-set! key hash))
(define-prim (##keyword-interned? key))
(define-prim (##keyword? obj))

(define-prim (keyword? obj)
  (##keyword? obj))

(define-prim (##keyword->string? key)
  (let ((name (##keyword-name key)))
    (if (##fixnum? name)
        #f
        name)))

(define-prim (##keyword->string key)
  (let ((name (##keyword-name key)))
    (if (##fixnum? name)
        (let ((str (##string-append "g" (##number->string name 10))))
          (##declare (not interrupts-enabled))
          (let ((name (##keyword-name key)))
            ;; Double-check in case a different thread has also called
            ;; and completed the call to ##keyword->string on this keyword.
            (if (##fixnum? name)
                (begin
                  (##keyword-name-set! key str)
                  str)
                name)))
        name)))

(define-prim (keyword->string key)
  (macro-force-vars (key)
    (macro-check-keyword key 1 (keyword->string key)
      (##keyword->string key))))

(define-prim (##string->keyword str)
  (##make-interned-keyword str))

(define-prim (string->keyword str)
  (macro-force-vars (str)
    (macro-check-string str 1 (string->keyword str)
      (##string->keyword str))))

(define-prim (##uninterned-keyword? obj)
  (and (##keyword? obj)
       (##not (##keyword-interned? obj))))

(define-prim (uninterned-keyword? obj)
  (macro-force-vars (obj)
    (##uninterned-keyword? obj)))

(define ##keyword-counter 0)

(define-prim (##string->uninterned-keyword
              str
              #!optional
              (hash (macro-absent-obj)))

  ;; str must be a nonmutable string

  (if (##eq? hash (macro-absent-obj))
      (let ((n (##fxwrap+ ##keyword-counter 1)))
        ;; Note: it is unimportant if the increment of ##keyword-counter
        ;; is not atomic; it simply means a possible close repetition
        ;; of the same hash code.  The counter will wrap around eventually.
        (set! ##keyword-counter n)
        (##make-uninterned-keyword str (##fxand 536870911 (##fxxor n (##partial-bit-reverse n)))))
      (##make-uninterned-keyword str hash)))

(define-prim (string->uninterned-keyword
              str
              #!optional
              (hash (macro-absent-obj)))
  (macro-force-vars (str hash)
    (macro-check-string str 1 (string->uninterned-keyword str hash)
      (if (##eq? hash (macro-absent-obj))
          (##string->uninterned-keyword str)
          (macro-check-fixnum-range-incl hash 2 0 536870911 (string->uninterned-keyword str hash)
            (##string->uninterned-keyword str hash))))))

;;;----------------------------------------------------------------------------

(define-prim (##partial-bit-reverse i)

  (##define-macro (bit n)
    `(##fxarithmetic-shift-left
      (##fxand i ,(expt 2 n)) ,(- 28 (* 2 n))))

  (##fx+
   (bit 0)
   (##fx+
    (bit 1)
    (##fx+
     (bit 2)
     (##fx+
      (bit 3)
      (##fx+
       (bit 4)
       (##fx+
        (bit 5)
        (##fx+
         (bit 6)
         (##fx+
          (bit 7)
          (##fx+
           (bit 8)
           (##fx+
            (bit 9)
            (##fx+
             (bit 10)
             (##fx+
              (bit 11)
              (##fx+
               (bit 12)
               (##fx+
                (bit 13)
                (bit 14))))))))))))))))

;;;============================================================================
