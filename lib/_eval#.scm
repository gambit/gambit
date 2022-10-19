;;;============================================================================

;;; File: "_eval#.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Representation of exceptions.

(define-library-type-of-exception expression-parsing-exception
  id: 5279db3c-9e07-4e8c-913f-29a7d61ee626
  constructor: #f
  opaque:

  (kind       unprintable: read-only: no-functional-setter:)
  (source     unprintable: read-only: no-functional-setter:)
  (parameters unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception unbound-global-exception
  id: 2cea29df-7f3e-489d-bf83-5925c5081151
  constructor: #f
  opaque:

  (code     unprintable: read-only: no-functional-setter:)
  (rte      unprintable: read-only: no-functional-setter:)
  (variable unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception not-in-compilation-context-exception
  id: a8fb370d-4e13-447f-b5cf-091e5296a5a1
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

;;;----------------------------------------------------------------------------

;;; Miscellaneous macros.

(##define-macro (macro-true? x) x)
(##define-macro (macro-unbound? x) `(##unbound? ,x))

(##define-macro (macro-self-var)       ''##self##)
(##define-macro (macro-selector-var)   ''##selector##)
(##define-macro (macro-do-loop-var)    ''##do-loop##)
(##define-macro (macro-guard-exc-var)  ''##guard-exc##)
(##define-macro (macro-guard-cont-var) ''##guard-cont##)

;;;----------------------------------------------------------------------------

;;; Macros to manipulate nodes of executable code.

(##define-macro (macro-make-code code-prc cte src stepper subcodes . lst)
  `(let (($code (##vector #f ,code-prc ,cte ,src ,stepper ,@subcodes ,@lst)))
     ,@(let loop ((l subcodes) (i 5) (r '()))
         (if (pair? l)
           (loop (cdr l)
                 (+ i 1)
                 (cons `(macro-code-parent-set! (##vector-ref $code ,i) $code)
                       r))
           (reverse r)))
     $code))

(##define-macro (macro-code-parent c)
  `(##vector-ref ,c 0))

(##define-macro (macro-code-parent-set! c l)
  `(##vector-set! ,c 0 ,l))

(##define-macro (macro-code-cprc c)
  `(##vector-ref ,c 1))

(##define-macro (macro-code-cte c)
  `(##vector-ref ,c 2))

(##define-macro (macro-code-locat c)
  `(##vector-ref ,c 3))

(##define-macro (macro-code-locat-set! c l)
  `(##vector-set! ,c 3 ,l))

(##define-macro (macro-code-stepper c)
  `(##vector-ref ,c 4))

(##define-macro (macro-code-length c)
  `(##fx- (##vector-length ,c) 5))

(##define-macro (macro-code-ref c n)
  `(##vector-ref ,c (##fx+ ,n 5)))

(##define-macro (macro-code-set! c n x)
  `(##vector-set! ,c (##fx+ ,n 5) ,x))

(##define-macro (^ n)
  `(##vector-ref $code ,(+ n 5)))

(##define-macro (macro-is-child-code? child parent)
  `(let ((child ,child)
         (parent ,parent))
     (and (##vector? child)
          (##fx< 3 (##vector-length child))
          (##eq? (macro-code-parent child) parent))))

(##define-macro (macro-code-root-parent? parent)
  `(##not (##vector? ,parent)))

(##define-macro (macro-code-run c)
  `(let (($$code ,c))
     ((##vector-ref $$code 1) $$code rte)))

;;;----------------------------------------------------------------------------

;;; Macros to create the "code procedure" associated with a code node.

(##define-macro (macro-make-cprc . body)
  `(let ()
     (##declare (not inline) (not interrupts-enabled) (environment-map))
     (lambda ($code rte)
       (let (($$continue
              (lambda ($code rte)
                (##declare (inline))
                ,@body)))
         (##declare (interrupts-enabled))
         ($$continue $code rte)))))

(##define-macro (macro-make-gen params . def)
  `(let ()
     (##declare (not inline))
     (lambda (cte tail? src ,@params) ,@def)))

(##define-macro (macro-gen proc src . args)
  `(,proc cte tail? ,src ,@args))

;;;----------------------------------------------------------------------------

;;; Macros for single stepping.

(##define-macro (macro-call-step! vars . body)
  `(macro-step! #t 1 ,vars ,@body))

(##define-macro (macro-future-step! vars . body)
  `(macro-step! #f 2 ,vars ,@body))

(##define-macro (macro-delay-step! vars . body)
  `(macro-step! #f 2 ,vars ,@body))

(##define-macro (macro-lambda-step! vars . body)
  `(macro-step! #f 3 ,vars ,@body))

(##define-macro (macro-define-step! vars . body)
  `(macro-step! #f 4 ,vars ,@body))

(##define-macro (macro-set!-step! vars . body)
  `(macro-step! #f 5 ,vars ,@body))

(##define-macro (macro-reference-step! vars . body)
  `(macro-step! #f 6 ,vars ,@body))

(##define-macro (macro-constant-step! vars . body)
  `(macro-step! #f 7 ,vars ,@body))

(##define-macro (macro-make-no-stepper)
  ''#(#(#f #f #f #f #f #f #f) #f #f #f #f #f #f #f #(#f #f #f #f #f #f #f)))

(##define-macro (macro-make-step-handlers handler)
  `(##vector ,handler
             ,handler
             ,handler
             ,handler
             ,handler
             ,handler
             ,handler))

(##define-macro (macro-make-stepper step-handlers)
  `(let ((step-handlers ,step-handlers))
     (##vector (##vector-copy step-handlers)
               #f
               #f
               #f
               #f
               #f
               #f
               #f
               step-handlers)))

(##define-macro (macro-step! leapable? handler-index vars . body)
  `(let* (($$execute-body
           (lambda ($code rte ,@vars) ,@body))
          ($$handler
           (##vector-ref (macro-code-stepper $code) ,handler-index)))
     (if $$handler
       ($$handler ,leapable?
                  $code
                  rte
                  (lambda ($code rte ,@vars)
                    ($$execute-body $code rte ,@vars))
                  ,@vars)
       ($$execute-body $code rte ,@vars))))

;;;----------------------------------------------------------------------------

;;; Macros to attach attributes to the code.

(##define-macro (macro-make-code-attributes
                 supply-modules
                 demand-modules
                 meta-info
                 code)
  `(##values ,supply-modules
             ,demand-modules
             ,meta-info
             ,code))

(##define-macro (macro-code-attributes-supply-modules attr)
  `(##values-ref ,attr 0))

(##define-macro (macro-code-attributes-demand-modules attr)
  `(##values-ref ,attr 1))

(##define-macro (macro-code-attributes-meta-info attr)
  `(##values-ref ,attr 2))

(##define-macro (macro-code-attributes-code attr)
  `(##values-ref ,attr 3))

;;;----------------------------------------------------------------------------

;;; Macros to manipulate the compilation context.

(##define-macro (macro-make-compilation-ctx target)
  `(##vector '() ;; supply-modules
             '() ;; demand-modules
             (##make-meta-info) ;; meta-info
             #f ;; module-ref
             ##default-module-aliases ;; module-aliases
             target
             (##make-extra-info))) ;; extra-info

(##define-macro (macro-compilation-ctx-supply-modules ctx)
  `(##vector-ref ,ctx 0))

(##define-macro (macro-compilation-ctx-supply-modules-set! ctx supply-modules)
  `(##vector-set! ,ctx 0 ,supply-modules))

(##define-macro (macro-compilation-ctx-demand-modules ctx)
  `(##vector-ref ,ctx 1))

(##define-macro (macro-compilation-ctx-demand-modules-set! ctx demand-modules)
  `(##vector-set! ,ctx 1 ,demand-modules))

(##define-macro (macro-compilation-ctx-meta-info ctx)
  `(##vector-ref ,ctx 2))

(##define-macro (macro-compilation-ctx-meta-info-set! ctx meta-info)
  `(##vector-set! ,ctx 2 ,meta-info))

(##define-macro (macro-compilation-ctx-module-ref ctx)
  `(##vector-ref ,ctx 3))

(##define-macro (macro-compilation-ctx-module-ref-set! ctx module-ref)
  `(##vector-set! ,ctx 3 ,module-ref))

(##define-macro (macro-compilation-ctx-module-aliases ctx)
   `(##vector-ref ,ctx 4))

(##define-macro (macro-compilation-ctx-module-aliases-set! ctx module-aliases)
   `(##vector-set! ,ctx 4 ,module-aliases))

(##define-macro (macro-compilation-ctx-target ctx)
   `(##vector-ref ,ctx 5))

(##define-macro (macro-compilation-ctx-target-set! ctx target)
   `(##vector-set! ,ctx 5 ,target))

(##define-macro (macro-compilation-ctx-extra-info ctx)
   `(##vector-ref ,ctx 6))

(##define-macro (macro-compilation-ctx-extra-info-set! ctx extra-info)
   `(##vector-set! ,ctx 6 ,extra-info))

;;;----------------------------------------------------------------------------

;;; Macros to manipulate the runtime environment

(##define-macro (macro-make-rte rte . lst)
  `(##vector ,rte ,@lst))

(##define-macro (macro-make-rte-from-list rte lst)
  `(##list->vector (##cons ,rte ,lst)))

(##define-macro (macro-make-rte* rte ns)
  `(let (($rte
          (let ()
            (declare (not inline-primitives ##make-vector))
            (##make-vector (##fx+ ,ns 1) '#!unbound))))
     (##vector-set! $rte 0 ,rte)
     $rte))

(##define-macro (macro-rte-up rte)         `(##vector-ref ,rte 0))
(##define-macro (macro-rte-ref rte i)      `(##vector-ref ,rte ,i))
(##define-macro (macro-rte-set! rte i val) `(##vector-set! ,rte ,i ,val))

;;;----------------------------------------------------------------------------

(##define-macro (define-runtime-macro pattern . rest)

  (define (form-size parms) ;; this definition must match the one in "_eval.scm"
    (let loop ((lst parms) (n 1))
      (cond ((pair? lst)
             (let ((parm (car lst)))
               (if (memq parm '(#!optional #!key #!rest))
                 (- n)
                 (loop (cdr lst)
                       (+ n 1)))))
            ((null? lst)
             n)
            (else
             (- n)))))

  (let ((src `(##lambda ,(cdr pattern) ,@rest)))
    `(##top-cte-add-macro-no-dups!
      ##interaction-cte
      ',(car pattern)
      (##make-macro-descr
       #f
       ',(form-size (cdr pattern))
       ,src
       #f))))

(##define-macro (define-runtime-syntax name expander)
  `(##top-cte-add-macro-no-dups!
    ##interaction-cte
    ',name
    (##make-macro-descr
     #t
     -1
     ,expander
     #f)))

;;;============================================================================
