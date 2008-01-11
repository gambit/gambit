;;;============================================================================

;;; File: "_kernel#.scm", Time-stamp: <2008-01-10 16:41:04 feeley>

;;; Copyright (c) 1994-2008 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Representation of exceptions.

(define-library-type exception
  id: 0bf9b656-b071-404a-a514-0fb9d05cf518
  constructor: #f
  extender: define-library-type-of-exception
  opaque:
)

(define-library-type-of-exception heap-overflow-exception
  id: d69cd396-01e0-4dcb-87dc-31acea8e0e5f
  constructor: #f
  opaque:
)

(define-library-type-of-exception stack-overflow-exception
  id: f512c9f6-3b24-4c5c-8c8b-cabd75b2f951
  constructor: #f
  opaque:
)

(define-library-type-of-exception nonprocedure-operator-exception
  id: f39d07ce-436d-40ca-b81f-cdc65d16b7f2
  constructor: #f
  opaque:

  (operator  unprintable: read-only:)
  (arguments unprintable: read-only:)
  (code      unprintable: read-only:)
  (rte       unprintable: read-only:)
)

(define-library-type-of-exception wrong-number-of-arguments-exception
  id: 2138cd7f-8c42-4164-b56a-a8c7badf3323
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
)

(define-library-type-of-exception keyword-expected-exception
  id: 3fd6c57f-3c80-4436-a430-57ea4457c11e
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
)

(define-library-type-of-exception unknown-keyword-argument-exception
  id: 3f9f8aaa-ea21-4f2b-bc06-f65950e6c408
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
)

(define-library-type-of-exception cfun-conversion-exception
  id: 9f09b552-0fb7-42c5-b0d4-212155841d53
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
  (code      unprintable: read-only:)
  (message   unprintable: read-only:)
)

(define-library-type-of-exception sfun-conversion-exception
  id: 54dfbc02-718d-4a34-91ab-d1861da7500a
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
  (code      unprintable: read-only:)
  (message   unprintable: read-only:)
)

(define-library-type-of-exception multiple-c-return-exception
  id: 73c66686-a08f-4c7c-a0f1-5ad7771f242a
  constructor: #f
  opaque:
)

(define-library-type-of-exception number-of-arguments-limit-exception
  id: f9519b37-d6d4-4748-8eb1-a0c8dc18c5e7
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
)

(define-library-type-of-exception type-exception
  id: cf06eccd-bf2c-4b30-a6ce-394b345a0dee
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
  (arg-num   unprintable: read-only:)
  (type-id   unprintable: read-only:)
)

(define-library-type-of-exception os-exception
  id: c1fc166b-d951-4871-853c-2b6c8c12d28d
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
  (message   unprintable: read-only:)
  (code      unprintable: read-only:)
)

(define-library-type-of-exception no-such-file-or-directory-exception
  id: 299ccee1-77d2-4a6d-ab24-2ebf14297315
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
)

;;;----------------------------------------------------------------------------

;;; Define type checking macros.

(define-check-type foreign 'foreign
  ##foreign?)

;;;----------------------------------------------------------------------------

;;; Debug settings.

(##define-macro (macro-debug-settings-level-mask)          15)
(##define-macro (macro-debug-settings-level-shift)         0)

(##define-macro (macro-debug-settings-uncaught-mask)       16)
(##define-macro (macro-debug-settings-uncaught-primordial) 0)
(##define-macro (macro-debug-settings-uncaught-all)        1)
(##define-macro (macro-debug-settings-uncaught-shift)      4)

(##define-macro (macro-debug-settings-error-mask)          96)
(##define-macro (macro-debug-settings-error-repl)          0)
(##define-macro (macro-debug-settings-error-single-step)   1)
(##define-macro (macro-debug-settings-error-quit)          2)
(##define-macro (macro-debug-settings-error-shift)         5)

(##define-macro (macro-debug-settings-repl-mask)           384)
(##define-macro (macro-debug-settings-repl-ide)            0)
(##define-macro (macro-debug-settings-repl-console)        1)
(##define-macro (macro-debug-settings-repl-stdio)          2)
(##define-macro (macro-debug-settings-repl-shift)          7)

(##define-macro (macro-debug-settings-level settings)
  `(##fixnum.arithmetic-shift-right
    (##fixnum.bitwise-and ,settings
                          (macro-debug-settings-level-mask))
    (macro-debug-settings-level-shift)))

(##define-macro (macro-debug-settings-uncaught settings)
  `(##fixnum.arithmetic-shift-right
    (##fixnum.bitwise-and ,settings
                          (macro-debug-settings-uncaught-mask))
    (macro-debug-settings-uncaught-shift)))

(##define-macro (macro-debug-settings-error settings)
  `(##fixnum.arithmetic-shift-right
    (##fixnum.bitwise-and ,settings
                          (macro-debug-settings-error-mask))
    (macro-debug-settings-error-shift)))

(##define-macro (macro-debug-settings-repl settings)
  `(##fixnum.arithmetic-shift-right
    (##fixnum.bitwise-and ,settings
                          (macro-debug-settings-repl-mask))
    (macro-debug-settings-repl-shift)))

;;;----------------------------------------------------------------------------

;;; Terminal settings.

(##define-macro (macro-terminal-settings-encoding-mask)    15)
(##define-macro (macro-terminal-settings-encoding-shift)   0)
(##define-macro (macro-terminal-settings-enable-line-edit) 16)

(##define-macro (macro-terminal-settings-encoding settings)
  `(##fixnum.arithmetic-shift-right
    (##fixnum.bitwise-and ,settings
                          (macro-terminal-settings-encoding-mask))
    (macro-terminal-settings-encoding-shift)))

(##define-macro (macro-terminal-settings-enable-line-edit? settings)
  `(##not (##fixnum.=
           (##fixnum.bitwise-and ,settings
                                 (macro-terminal-settings-enable-line-edit))
           0)))

;;;----------------------------------------------------------------------------

;;; Exit codes.

(##define-macro (macro-EXIT-CODE-OK)          0)
(##define-macro (macro-EXIT-CODE-USAGE)       64)
(##define-macro (macro-EXIT-CODE-DATAERR)     65)
(##define-macro (macro-EXIT-CODE-NOINPUT)     66)
(##define-macro (macro-EXIT-CODE-NOUSER)      67)
(##define-macro (macro-EXIT-CODE-NOHOST)      68)
(##define-macro (macro-EXIT-CODE-UNAVAILABLE) 69)
(##define-macro (macro-EXIT-CODE-SOFTWARE)    70)
(##define-macro (macro-EXIT-CODE-OSERR)       71)
(##define-macro (macro-EXIT-CODE-OSFILE)      72)
(##define-macro (macro-EXIT-CODE-CANTCREAT)   73)
(##define-macro (macro-EXIT-CODE-IOERR)       74)
(##define-macro (macro-EXIT-CODE-TEMPFAIL)    75)
(##define-macro (macro-EXIT-CODE-PROTOCOL)    76)
(##define-macro (macro-EXIT-CODE-NOPERM)      77)
(##define-macro (macro-EXIT-CODE-CONFIG)      78)

;;;----------------------------------------------------------------------------

;;; Representation of fifos.

(##define-macro (macro-make-fifo)
  `(let ((fifo (##cons '() '())))
     (macro-fifo-tail-set! fifo fifo)
     fifo))

(##define-macro (macro-fifo-next fifo)        `(##cdr ,fifo))
(##define-macro (macro-fifo-next-set! fifo x) `(##set-cdr! ,fifo ,x))
(##define-macro (macro-fifo-tail fifo)        `(##car ,fifo))
(##define-macro (macro-fifo-tail-set! fifo x) `(##set-car! ,fifo ,x))
(##define-macro (macro-fifo-elem fifo)        `(##car ,fifo))
(##define-macro (macro-fifo-elem-set! fifo x) `(##set-car! ,fifo ,x))

(##define-macro (macro-fifo->list fifo)
  `(macro-fifo-next ,fifo))

(##define-macro (macro-fifo-remove-all! fifo)
  `(let ((fifo ,fifo))

     (##declare (not interrupts-enabled))

     (let ((head (macro-fifo-next fifo)))
       (macro-fifo-tail-set! fifo fifo)
       (macro-fifo-next-set! fifo '())
       head)))

(##define-macro (macro-fifo-remove-head! fifo)
  `(let ((fifo ,fifo))

     (##declare (not interrupts-enabled))

     (let ((head (macro-fifo-next fifo)))
       (if (##pair? head)
         (let ((next (macro-fifo-next head)))
           (if (##null? next)
             (macro-fifo-tail-set! fifo fifo))
           (macro-fifo-next-set! fifo next)
           (macro-fifo-next-set! head '())))
       head)))

(##define-macro (macro-fifo-insert-at-tail! fifo elem)
  `(let ((fifo ,fifo) (elem ,elem))
     (let ((x (##cons elem '())))

       (##declare (not interrupts-enabled))

       (let ((tail (macro-fifo-tail fifo)))
         (macro-fifo-next-set! tail x)
         (macro-fifo-tail-set! fifo x)
         (##void)))))

(##define-macro (macro-fifo-insert-at-head! fifo elem)
  `(let ((fifo ,fifo) (elem ,elem))
     (let ((x (##cons elem '())))

       (##declare (not interrupts-enabled))

       ;; To obtain an atomic update of the fifo, we must force a
       ;; garbage-collection to occur right away if needed by the
       ;; ##cons, so that any finalization that might mutate this fifo
       ;; will be done before updating the fifo.

       (##check-heap-limit)

       (let ((head (macro-fifo-next fifo)))
         (if (##null? head)
           (macro-fifo-tail-set! fifo x))
         (macro-fifo-next-set! fifo x)
         (macro-fifo-next-set! x head)
         (##void)))))

(##define-macro (macro-fifo-advance-to-tail! fifo)
  `(let ((fifo ,fifo))
     ;; It is assumed that the fifo contains at least one element
     ;; (i.e. the fifo's tail does not change).
     (let ((new-head (macro-fifo-tail fifo)))
       (macro-fifo-next-set! fifo new-head)
       (macro-fifo-elem new-head))))

(##define-macro (macro-fifo-advance! fifo)
  `(let ((fifo ,fifo))
     ;; It is assumed that the fifo contains at least two elements
     ;; (i.e. the fifo's tail does not change).
     (let* ((head (macro-fifo-next fifo))
            (new-head (macro-fifo-next head)))
       (macro-fifo-next-set! fifo new-head)
       (macro-fifo-elem new-head))))

;;;============================================================================
