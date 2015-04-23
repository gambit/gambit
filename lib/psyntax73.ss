;;; Portable implementation of syntax-case
;;; Extracted from Chez Scheme Version 7.3 (Feb 26, 2007)
;;; Authors: R. Kent Dybvig, Oscar Waddell, Bob Hieb, Carl Bruggeman

;;; ***************************************************************************
;;; *** Modified for Gambit 4.4.0 by Marc Feeley (February 4, 2009).        ***
;;; *** Look for "***" to see what was modified.                            ***
;;; ***************************************************************************

;;; Copyright (c) 1992-2002 Cadence Research Systems
;;; Permission to copy this software, in whole or in part, to use this
;;; software for any lawful purpose, and to redistribute this software
;;; is granted subject to the restriction that all copies made of this
;;; software must include this copyright notice in full.  This software
;;; is provided AS IS, with NO WARRANTY, EITHER EXPRESS OR IMPLIED,
;;; INCLUDING BUT NOT LIMITED TO IMPLIED WARRANTIES OF MERCHANTABILITY
;;; OR FITNESS FOR ANY PARTICULAR PURPOSE.  IN NO EVENT SHALL THE
;;; AUTHORS BE LIABLE FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES OF ANY
;;; NATURE WHATSOEVER.

;;; Before attempting to port this code to a new implementation of
;;; Scheme, please read the notes below carefully.

;;; This file defines the syntax-case expander, sc-expand, and a set
;;; of associated syntactic forms and procedures.  Of these, the
;;; following are documented in The Scheme Programming Language,
;;; Third Edition (R. Kent Dybvig, MIT Press, 2003), which can be
;;; found online at http://www.scheme.com/tspl3/.  Most are also documented
;;; in the R4RS and draft R5RS.
;;;
;;;   bound-identifier=?
;;;   datum->syntax-object
;;;   define-syntax
;;;   fluid-let-syntax
;;;   free-identifier=?
;;;   generate-temporaries
;;;   identifier?
;;;   identifier-syntax
;;;   let-syntax
;;;   letrec-syntax
;;;   syntax
;;;   syntax-case
;;;   syntax-object->datum
;;;   syntax-rules
;;;   with-syntax
;;;
;;; All standard Scheme syntactic forms are supported by the expander
;;; or syntactic abstractions defined in this file.  Only the R4RS
;;; delay is omitted, since its expansion is implementation-dependent.

;;; Also defined are three forms that support modules: module, import,
;;; and import-only.  These are documented in the Chez Scheme User's
;;; Guide (R. Kent Dybvig, Cadence Research Systems, 1998), which can
;;; also be found online at http://www.scheme.com/csug/.  They are
;;; described briefly here as well.
    
;;; All are definitions and may appear where and only where other
;;; definitions may appear.  modules may be named:
;;;
;;;   (module id (ex ...) defn ... init ...)
;;;
;;; or anonymous:
;;;
;;;   (module (ex ...) defn ... init ...)
;;;
;;; The latter form is semantically equivalent to:
;;;
;;;   (module T (ex ...) defn ... init ...)
;;;   (import T)
;;;
;;; where T is a fresh identifier.
;;;
;;; In either form, each of the exports in (ex ...) is either an
;;; identifier or of the form (id ex ...).  In the former case, the
;;; single identifier ex is exported.  In the latter, the identifier
;;; id is exported and the exports ex ... are "implicitly" exported.
;;; This listing of implicit exports is useful only when id is a
;;; keyword bound to a transformer that expands into references to
;;; the listed implicit exports.  In the present implementation,
;;; listing of implicit exports is necessary only for top-level
;;; modules and allows the implementation to avoid placing all
;;; identifiers into the top-level environment where subsequent passes
;;; of the compiler will be unable to deal effectively with them.
;;;
;;; Named modules may be referenced in import statements, which
;;; always take one of the forms:
;;;
;;;   (import id)
;;;   (import-only id)
;;;
;;; id must name a module.  Each exported identifier becomes visible
;;; within the scope of the import form.  In the case of import-only,
;;; all other identifiers become invisible in the scope of the
;;; import-only form, except for those established by definitions
;;; that appear textually after the import-only form.

;;; import and import-only also support a variety of identifier
;;; selection and renaming forms: only, except, add-prefix,
;;; drop-prefix, rename, and alias.
;;;
;;;   (import (only m x y))
;;; 
;;; imports x and y (and nothing else) from m.
;;;
;;;   (import (except m x y))
;;; 
;;; imports all of m's imports except for x and y.
;;;
;;;   (import (add-prefix (only m x y) m:))
;;; 
;;; imports x and y as m:x and m:y.
;;;
;;;   (import (drop-prefix m foo:))
;;; 
;;; imports all of m's imports, dropping the common foo: prefix
;;; (which must appear on all of m's exports).
;;; 
;;;   (import (rename (except m a b) (m-c c) (m-d d)))
;;; 
;;; imports all of m's imports except for x and y, renaming c
;;; m-c and d m-d.
;;; 
;;;   (import (alias (except m a b) (m-c c) (m-d d)))
;;; 
;;; imports all of m's imports except for x and y, with additional
;;; aliases m-c for c and m-d for d.
;;; 
;;; multiple imports may be specified with one import form:
;;; 
;;;   (import (except m1 x) (only m2 x))
;;; 
;;; imports all of m1's exports except for x plus x from m2.

;;; Another form, meta, may be used as a prefix for any definition and
;;; causes any resulting variable bindings to be created at expansion
;;; time.  Meta variables (variables defined using meta) are available
;;; only at expansion time.  Meta definitions are often used to create
;;; data and helpers that can be shared by multiple macros, for example:

;;; (module (alpha beta)
;;;   (meta define key-error
;;;     (lambda (key)
;;;       (syntax-error key "invalid key")))
;;;   (meta define parse-keys
;;;     (lambda (keys)
;;;       (let f ((keys keys) (c #'white) (s 10))
;;;         (syntax-case keys (color size)
;;;           (() (list c s))
;;;           (((color c) . keys) (f #'keys #'c s))
;;;           (((size s) . keys) (f #'keys c #'s))
;;;           ((k . keys) (key-error #'k))))))
;;;   (define-syntax alpha
;;;     (lambda (x)
;;;       (syntax-case x ()
;;;         ((_ (k ...) <other stuff>)
;;;          (with-syntax (((c s) (parse-keys (syntax (k ...)))))
;;;            ---)))))
;;;   (define-syntax beta
;;;     (lambda (x)
;;;       (syntax-case x ()
;;;         ((_ (k ...) <other stuff>)
;;;          (with-syntax (((c s) (parse-keys (syntax (k ...)))))
;;;            ---))))))

;;; As with define-syntax rhs expressions, meta expressions can evaluate
;;; references only to identifiers whose values are (already) available
;;; in the compile-time environment, e.g., macros and meta variables.
;;; They can, however, like define-syntax rhs expressions, build syntax
;;; objects containing occurrences of any identifiers in their scope.

;;; meta definitions propagate through macro expansion, so one can write,
;;; for example:
;;; 
;;;   (module (a)
;;;     (meta define-structure (foo x))
;;;     (define-syntax a
;;;       (let ((q (make-foo (syntax 'q))))
;;;         (lambda (x)
;;;           (foo-x q)))))
;;;   a -> q
;;; 
;;; where define-record is a macro that expands into a set of defines.
;;; 
;;; It is also sometimes convenient to write
;;; 
;;;   (meta begin defn ...)
;;; 
;;; or
;;; 
;;;   (meta module {exports} defn ...)
;;; 
;;; to create groups of meta bindings.

;;; Another form, alias, is used to create aliases from one identifier
;;; to another.  This is used primarily to support the extended import
;;; syntaxes (add-prefix, drop-prefix, rename, and alias).

;;; (let ((x 3)) (alias y x) y) -> 3

;;; The remaining exports are listed below.  sc-expand, eval-when, and
;;; syntax-error are described in the Chez Scheme User's Guide.
;;;
;;;   (sc-expand datum)
;;;      if datum represents a valid expression, sc-expand returns an
;;;      expanded version of datum in a core language that includes no
;;;      syntactic abstractions.  The core language includes begin,
;;;      define, if, lambda, letrec, quote, and set!.
;;;   (eval-when situations expr ...)
;;;      conditionally evaluates expr ... at compile-time or run-time
;;;      depending upon situations
;;;   (syntax-error object message)
;;;      used to report errors found during expansion
;;;   ($syntax-dispatch e p)
;;;      used by expanded code to handle syntax-case matching
;;;   ($sc-put-cte symbol val top-token)
;;;      used to establish top-level compile-time (expand-time) bindings.

;;; The following nonstandard procedures must be provided by the
;;; implementation for this code to run.
;;;
;;; (void)
;;; returns the implementation's cannonical "unspecified value".  The
;;; following usually works:
;;;
;;; (define void (lambda () (if #f #f))).
;;;
;;; (andmap proc list1 list2 ...)
;;; returns true if proc returns true when applied to each element of list1
;;; along with the corresponding elements of list2 ....  The following
;;; definition works but does no error checking:
;;;
;;; (define andmap
;;;   (lambda (f first . rest)
;;;     (or (null? first)
;;;         (if (null? rest)
;;;             (let andmap ((first first))
;;;               (let ((x (car first)) (first (cdr first)))
;;;                 (if (null? first)
;;;                     (f x)
;;;                     (and (f x) (andmap first)))))
;;;             (let andmap ((first first) (rest rest))
;;;               (let ((x (car first))
;;;                     (xr (map car rest))
;;;                     (first (cdr first))
;;;                     (rest (map cdr rest)))
;;;                 (if (null? first)
;;;                     (apply f (cons x xr))
;;;                     (and (apply f (cons x xr)) (andmap first rest)))))))))
;;;
;;; (ormap proc list1)
;;; returns the first non-false return result of proc applied to
;;; the elements of list1 or false if none.  The following definition
;;; works but does no error checking:
;;;
;;; (define ormap
;;;   (lambda (proc list1)
;;;     (and (not (null? list1))
;;;          (or (proc (car list1)) (ormap proc (cdr list1))))))
;;;
;;; The following nonstandard procedures must also be provided by the
;;; implementation for this code to run using the standard portable
;;; hooks and output constructors.  They are not used by expanded code,
;;; and so need be present only at expansion time.
;;;
;;; (eval x)
;;; where x is always in the form ("noexpand" expr).
;;; returns the value of expr.  the "noexpand" flag is used to tell the
;;; evaluator/expander that no expansion is necessary, since expr has
;;; already been fully expanded to core forms.
;;;
;;; eval will not be invoked during the loading of psyntax.pp.  After
;;; psyntax.pp has been loaded, the expansion of any macro definition,
;;; whether local or global, results in a call to eval.  If, however,
;;; sc-expand has already been registered as the expander to be used
;;; by eval, and eval accepts one argument, nothing special must be done
;;; to support the "noexpand" flag, since it is handled by sc-expand.
;;;
;;; (error who format-string why what)
;;; where who is either a symbol or #f, format-string is always "~a ~s",
;;; why is always a string, and what may be any object.  error should
;;; signal an error with a message something like
;;;
;;;    "error in <who>: <why> <what>"
;;;
;;; (gensym)
;;; returns a unique symbol each time it's called.  In Chez Scheme, gensym
;;; returns a symbol with a "globally" unique name so that gensyms that
;;; end up in the object code of separately compiled files cannot conflict.
;;; This is necessary only if you intend to support compiled files.
;;;
;;; (gensym? x)
;;; returns #t if x is a gensym, otherwise false.
;;;
;;; (putprop symbol key value)
;;; (getprop symbol key)
;;; (remprop symbol key)
;;; key is always a symbol; value may be any object.  putprop should
;;; associate the given value with the given symbol and key in some way
;;; that it can be retrieved later with getprop.  getprop should return
;;; #f if no value is associated with the given symbol and key.  remprop
;;; should remove the association between the given symbol and key.

;;; When porting to a new Scheme implementation, you should define the
;;; procedures listed above, load the expanded version of psyntax.ss
;;; (psyntax.pp, which should be available whereever you found
;;; psyntax.ss), and register sc-expand as the current expander (how
;;; you do this depends upon your implementation of Scheme).  You may
;;; change the hooks and constructors defined toward the beginning of
;;; the code below, but to avoid bootstrapping problems, do so only
;;; after you have a working version of the expander.

;;; Chez Scheme allows the syntactic form (syntax <template>) to be
;;; abbreviated to #'<template>, just as (quote <datum>) may be
;;; abbreviated to '<datum>.  The #' syntax makes programs written
;;; using syntax-case shorter and more readable and draws out the
;;; intuitive connection between syntax and quote.  If you have access
;;; to the source code of your Scheme system's reader, you might want
;;; to implement this extension.

;;; If you find that this code loads or runs slowly, consider
;;; switching to faster hardware or a faster implementation of
;;; Scheme.  In Chez Scheme on a 200Mhz Pentium Pro, expanding,
;;; compiling (with full optimization), and loading this file takes
;;; between one and two seconds.

;;; In the expander implementation, we sometimes use syntactic abstractions
;;; when procedural abstractions would suffice.  For example, we define
;;; top-wrap and top-marked? as
;;;   (define-syntax top-wrap (identifier-syntax '((top))))
;;;   (define-syntax top-marked?
;;;     (syntax-rules ()
;;;       ((_ w) (memq 'top (wrap-marks w)))))
;;; rather than
;;;   (define top-wrap '((top)))
;;;   (define top-marked?
;;;     (lambda (w) (memq 'top (wrap-marks w))))
;;; On ther other hand, we don't do this consistently; we define make-wrap,
;;; wrap-marks, and wrap-subst simply as
;;;   (define make-wrap cons)
;;;   (define wrap-marks car)
;;;   (define wrap-subst cdr)
;;; In Chez Scheme, the syntactic and procedural forms of these
;;; abstractions are equivalent, since the optimizer consistently
;;; integrates constants and small procedures.  Some Scheme
;;; implementations, however, may benefit from more consistent use
;;; of one form or the other.


;;; Implementation notes:

;;; "begin" is treated as a splicing construct at top level and at
;;; the beginning of bodies.  Any sequence of expressions that would
;;; be allowed where the "begin" occurs is allowed.

;;; "let-syntax" and "letrec-syntax" are also treated as splicing
;;; constructs, in violation of the R5RS.  A consequence is that let-syntax
;;; and letrec-syntax do not create local contours, as do let and letrec.
;;; Although the functionality is greater as it is presently implemented,
;;; we will probably change it to conform to the R5RS.  modules provide
;;; similar functionality to nonsplicing letrec-syntax when the latter is
;;; used as a definition.

;;; Objects with no standard print syntax, including objects containing
;;; cycles and syntax objects, are allowed in quoted data as long as they
;;; are contained within a syntax form or produced by datum->syntax-object.
;;; Such objects are never copied.

;;; When the expander encounters a reference to an identifier that has
;;; no global or lexical binding, it treats it as a global-variable
;;; reference.  This allows one to write mutually recursive top-level
;;; definitions, e.g.:
;;;
;;;   (define f (lambda (x) (g x)))
;;;   (define g (lambda (x) (f x)))
;;;
;;; but may not always yield the intended when the variable in question
;;; is later defined as a keyword.

;;; Top-level variable definitions of syntax keywords are permitted.
;;; In order to make this work, top-level define not only produces a
;;; top-level definition in the core language, but also modifies the
;;; compile-time environment (using $sc-put-cte) to record the fact
;;; that the identifier is a variable.

;;; Top-level definitions of macro-introduced identifiers are visible
;;; only in code produced by the macro.  That is, a binding for a
;;; hidden (generated) identifier is created instead, and subsequent
;;; references within the macro output are renamed accordingly.  For
;;; example:
;;;
;;; (define-syntax a
;;;   (syntax-rules ()
;;;     ((_ var exp)
;;;      (begin
;;;        (define secret exp)
;;;        (define var
;;;          (lambda ()
;;;            (set! secret (+ secret 17))
;;;            secret))))))
;;; (a x 0)
;;; (x) => 17
;;; (x) => 34
;;; secret => Error: variable secret is not bound
;;;
;;; The definition above would fail if the definition for secret
;;; were placed after the definition for var, since the expander would
;;; encounter the references to secret before the definition that
;;; establishes the compile-time map from the identifier secret to
;;; the generated identifier.

;;; Identifiers and syntax objects are implemented as vectors for
;;; portability.  As a result, it is possible to "forge" syntax
;;; objects.

;;; The input to sc-expand may contain "annotations" describing, e.g., the
;;; source file and character position from where each object was read if
;;; it was read from a file.  These annotations are handled properly by
;;; sc-expand only if the annotation? hook (see hooks below) is implemented
;;; properly and the operators annotation-expression and annotation-stripped
;;; are supplied.  If annotations are supplied, the proper annotated
;;; expression is passed to the various output constructors, allowing
;;; implementations to accurately correlate source and expanded code.
;;; Contact one of the authors for details if you wish to make use of
;;; this feature.

;;; Implementation of modules:
;;;
;;; The implementation of modules requires that implicit top-level exports
;;; be listed with the exported macro at some level where both are visible,
;;; e.g.,
;;;
;;;   (module M (alpha (beta b))
;;;     (module ((alpha a) b)
;;;       (define-syntax alpha (identifier-syntax a))
;;;       (define a 'a)
;;;       (define b 'b))
;;;     (define-syntax beta (identifier-syntax b)))
;;;
;;; Listing of implicit imports is not needed for macros that do not make
;;; it out to top level, including all macros that are local to a "body".
;;; (They may be listed in this case, however.)  We need this information
;;; for top-level modules since a top-level module expands into a letrec
;;; for non-top-level variables and top-level definitions (assignments) for
;;; top-level variables.  Because of the general nature of macro
;;; transformers, we cannot determine the set of implicit exports from the
;;; transformer code, so without the user's help, we'd have to put all
;;; variables at top level.
;;;
;;; Each such top-level identifier is given a generated name (gensym).
;;; When a top-level module is imported at top level, a compile-time
;;; alias is established from the top-level name to the generated name.
;;; The expander follows these aliases transparently.  When any module is
;;; imported anywhere other than at top level, the id-var-name of the
;;; import identifier is set to the id-var-name of the export identifier.
;;; Since we can't determine the actual labels for identifiers defined in
;;; top-level modules until we determine which are placed in the letrec
;;; and which make it to top level, we give each an "indirect" label---a
;;; pair whose car will eventually contain the actual label.  Import does
;;; not follow the indirect, but id-var-name does.
;;;
;;; All identifiers defined within a local module are folded into the
;;; letrec created for the enclosing body.  Visibility is controlled in
;;; this case and for nested top-level modules by introducing a new wrap
;;; for each module.


;;; Bootstrapping:

;;; When changing syntax-object representations, it is necessary to support
;;; both old and new syntax-object representations in id-var-name.  It
;;; should be sufficient to redefine syntax-object-expression to work for
;;; both old and new representations and syntax-object-wrap to return the
;;; empty-wrap for old representations.


;;; The following set of definitions establishes bindings for the
;;; top-level variables assigned values in the let expression below.
;;; Uncomment them here and copy them to the front of psyntax.pp if
;;; required by your system.

; (define $sc-put-cte #f)
; (define sc-expand #f)
; (define $make-environment #f)
; (define environment? #f)
; (define interaction-environment #f)
; (define identifier? #f)
; (define syntax->list #f)
; (define syntax-object->datum #f)
; (define datum->syntax-object #f)
; (define generate-temporaries #f)
; (define free-identifier=? #f)
; (define bound-identifier=? #f)
; (define literal-identifier=? #f)
; (define syntax-error #f)
; (define $syntax-dispatch #f)

(let ()

(define-syntax when
  (syntax-rules ()
    ((_ test e1 e2 ...) (if test (begin e1 e2 ...)))))
(define-syntax unless
  (syntax-rules ()
    ((_ test e1 e2 ...) (when (not test) (begin e1 e2 ...)))))
(define-syntax define-structure
  (lambda (x)
    (syntax-case x ()
      ((_ (name id1 ...))
       (with-syntax
        ((expansion (map (lambda (datum)
                           (datum->syntax-object (syntax name) datum))
                         (##define-type-expand
                           'define-structure #f #f (map syntax-object->datum
                                                        (syntax (name id1 ...)))))))
        (syntax expansion))))))
(define-syntax let-values ; impoverished one-clause version
  (syntax-rules ()
    ((_ ((formals expr)) form1 form2 ...)
     (call-with-values (lambda () expr) (lambda formals form1 form2 ...)))))

(define noexpand "noexpand")

(define-structure (syntax-object
                   id: 2D9C624D-3630-42AF-884C-FD82C537B2D7
                   predicate: bs-syntax?
                   constant-constructor: #f
                   (expression bs-syntax-expression)
                   (wrap bs-syntax-wrap)))

(begin
  (define (syntax-object? obj)
    (or (bs-syntax? obj)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (and (vector? obj)
               (eq? (vector-ref obj 0) 'syntax-object)))))
  (define (syntax-object-expression obj)
    (if (bs-syntax? obj)
        (bs-syntax-expression obj)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (vector-ref obj 1))))
  (define (syntax-object-wrap obj)
    (if (bs-syntax? obj)
        (bs-syntax-wrap obj)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (vector-ref obj 2)))))

;;; hooks to nonportable run-time helpers
(begin
;*** Gambit supports fx+, etc.
;*** (define-syntax fx+ (identifier-syntax +))
;*** (define-syntax fx- (identifier-syntax -))
;*** (define-syntax fx= (identifier-syntax =))
;*** (define-syntax fx< (identifier-syntax <))
;*** (define-syntax fx> (identifier-syntax >))
;*** (define-syntax fx<= (identifier-syntax <=))
;*** (define-syntax fx>= (identifier-syntax >=))

;*** (define annotation? (lambda (x) #f))

; top-level-eval-hook is used to create "permanent" code (e.g., top-level
; transformers), so it might be a good idea to compile it
(define top-level-eval-hook
  (lambda (x)
    (eval `(,noexpand ,x))))

; local-eval-hook is used to create "temporary" code (e.g., local
; transformers), so it might be a good idea to interpret it
(define local-eval-hook
  (lambda (x)
    (eval `(,noexpand ,x))))

(define define-top-level-value-hook
  (lambda (sym val)
    (top-level-eval-hook
      (build-global-definition no-source sym
        (build-data no-source val)))))

;*** (define error-hook
;***   (lambda (who why what)
;***     (error who "~a ~s" why what)))

(define put-cte-hook
  (lambda (symbol val)
    ($sc-put-cte symbol val '*top*)))

(define get-global-definition-hook
  (lambda (symbol)
    (getprop symbol '*sc-expander*)))

(define put-global-definition-hook
  (lambda (symbol x)
    (if (not x)
        (remprop symbol '*sc-expander*)
        (putprop symbol '*sc-expander* x))))

; if you treat certain bindings (say from environments like ieee or r5rs)
; read-only, this should return #t for those bindings
(define read-only-binding?
  (lambda (symbol)
    #f))

; should return #f if symbol has no binding for token
(define get-import-binding
  (lambda (symbol token)
    (getprop symbol token)))

; remove binding if x is false
(define update-import-binding!
  (lambda (symbol token p)
    (let ((x (p (get-import-binding symbol token))))
      (if (not x)
          (remprop symbol token)
          (putprop symbol token x)))))

;;; generate-id ideally produces globally unique symbols, i.e., symbols
;;; unique across system runs, to support separate compilation/expansion.
;;; Use gensyms if you do not need to support separate compilation/
;;; expansion or if your system's gensym creates globally unique
;;; symbols (as in Chez Scheme).  Otherwise, use the following code
;;; as a starting point.  session-key should be a unique string for each
;;; system run to support separate compilation; the default value given
;;; is satisfactory during initial development only.
(define generate-id
  (let ((digits "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!$%&*/:<=>?~_^.+-"))
    (let ((base (string-length digits)) (session-key "_"))
      (define make-digit (lambda (x) (string-ref digits x)))
      (define fmt
        (lambda (n)
          (let fmt ((n n) (a '()))
            (if (< n base)
                (list->string (cons (make-digit n) a))
                (let ((r (modulo n base)) (rest (quotient n base)))
                  (fmt rest (cons (make-digit r) a)))))))
      (let ((n -1))
        (lambda (name) ; name is #f or a symbol
          (set! n (+ n 1))
;***          (string->symbol (string-append session-key (fmt n))))))))
          (string->symbol (string-append session-key
                                         (fmt n)
                                         (if name
                                             (string-append "." (symbol->string name))
                                             ""))))))))
)



;;; output constructors
(begin
(define-syntax build-application
  (syntax-rules ()
    ((_ ae fun-exp arg-exps)
;***      `(,fun-exp . ,arg-exps))))
     (build-source ae `(,fun-exp . ,arg-exps)))))

(define-syntax build-conditional
  (syntax-rules ()
    ((_ ae test-exp then-exp else-exp)
;***      `(if ,test-exp ,then-exp ,else-exp))))
     (build-source ae `(,(build-source ae 'if) ,test-exp ,then-exp ,else-exp)))))

(define-syntax build-lexical-reference
  (syntax-rules ()
    ((_ type ae var)
     var)))

(define-syntax build-lexical-assignment
  (syntax-rules ()
    ((_ ae var exp)
;***      `(set! ,var ,exp))))
     (build-source ae `(,(build-source ae 'set!) ,var ,exp)))))

(define-syntax build-global-reference
  (syntax-rules ()
    ((_ ae var)
     (build-source ae var))))

(define-syntax build-global-assignment
  (syntax-rules ()
    ((_ ae var exp)
;***      `(set! ,var ,exp))))
     (build-source ae `(,(build-source ae 'set!) ,var ,exp)))))

(define-syntax build-global-definition
  (syntax-rules ()
    ((_ ae var exp)
;***      `(define ,var ,exp))))
     (build-source ae `(,(build-source ae 'define) ,var ,exp)))))

(define-syntax build-cte-install
 ; should build a call that has the same effect as calling put-cte-hook
  (syntax-rules ()
;***     ((_ sym exp token) `($sc-put-cte ',sym ,exp ',token))))
    ((_ sym exp token)
     (build-source #f `(,(build-source #f '$sc-put-cte)
                        ,(build-source #f `(,(build-source #f 'quote) ,sym))
                        ,exp
                        ,(build-source #f `(,(build-source #f 'quote) ,token)))))))

(define-syntax build-visit-only
 ; should mark the result as "visit only" for compile-file
 ; in implementations that support visit/revisit
  (syntax-rules ()
    ((_ exp) exp)))

(define-syntax build-revisit-only
 ; should mark the result as "revisit only" for compile-file,
 ; in implementations that support visit/revisit
  (syntax-rules ()
    ((_ exp) exp)))

(define-syntax build-lambda
  (syntax-rules ()
    ((_ ae vars exp)
;***      `(lambda ,vars ,exp))))
     (build-source ae `(,(build-source ae 'lambda) ,vars ,exp)))))

;; mdh: to provide alpha-conversion of all symbols, but also support
;; non-alpha converted keyword arguments, the following pattern is
;; used to convert dsssl style formals:

;; (lambda (#!key a b) expr)
   
;; ultimately maps to something like this:

;; (lambda %%args32
;;   (receive (%%a12 %%b13) (apply (lambda (#!key a b) (values a b)) %%args32)
;;            <body>))
  
;; the dsssl parameter assignment occurs within a closure, where
;; %%args32 is a generated gensym, and %%a12 and %%b13 are the
;; alpha-converted a and b.

(define-syntax build-dsssl-lambda
  (syntax-rules ()
    ;; vars is either symbol or (keyword . alpha-converted-keyword)
    ((_ ae dsssl-args-var alpha-vars dsssl-formals orig-vars exp)
     (build-source ae `(,(build-source ae 'lambda) ,dsssl-args-var
                        ,(build-source ae `(,(build-source ae 'receive) ,alpha-vars
                                            ,(build-source ae `(,(build-source ae 'apply)
                                                                ,(build-source ae `(,(build-source ae 'lambda)
                                                                                    ,dsssl-formals
                                                                                    ,(build-source ae `(,(build-source ae 'values) . ,orig-vars))))
                                                                ,dsssl-args-var))
                                            ,exp)))))))

(define built-lambda?
  (lambda (x)
;***     (and (pair? x) (eq? (car x) 'lambda))))
    (or (and (pair? x) (eq? (car x) 'lambda))
        (and (##source? x)
             (pair? (##source-code x))
             (##source? (car (##source-code x)))
             (eq? (##source-code (car (##source-code x))) 'lambda)))))

(define-syntax build-primref
  (syntax-rules ()
    ((_ ae name) name)
    ((_ ae level name) name)))

(define-syntax build-data
  (syntax-rules ()
    ((_ ae exp)
     (let ((x (attach-source ae exp)))
       (if (self-eval? exp)
           x
           (build-source ae `(,(build-source ae 'quote) ,x)))))))

(define build-sequence
  (lambda (ae exps)
    (let loop ((exps exps))
      (if (null? (cdr exps))
          (car exps)
         ; weed out leading void calls, assuming ordinary list representation
;***           (if (equal? (car exps) '(void))
;***               (loop (cdr exps))
;***               `(begin ,@exps))))))
          (if (let ((x (car exps)))
                (or (equal? x '(void))
                    (and (##source? x)
                         (pair? (##source-code x))
                         (##source? (car (##source-code x)))
                         (eq? (##source-code (car (##source-code x))) 'void)
                         (null? (cdr (##source-code x))))))
              (loop (cdr exps))
              (build-source ae (cons (build-source ae 'begin) exps)))))))

(define build-letrec
  (lambda (ae vars val-exps body-exp)
    (if (null? vars)
        body-exp
        (build-source ae `(,(build-source ae 'letrec)
                           ,(build-source ae (map (lambda (v e) (build-source ae `(,v ,e))) vars val-exps))
                           ,body-exp)))))

(define build-body
  (lambda (ae vars val-exps body-exp)
    (build-letrec ae vars val-exps body-exp)))

(define build-top-module
 ; each type is either global (exported) or local (not exported)
 ; we produce global definitions and assignments for globals and
 ; letrec bindings for locals.  if you don't need the definitions,
 ; (just assignments) you can eliminate them.  if you wish to
 ; have your module definitions ordered from left-to-right (ala
 ; letrec*), you can replace the global var-exps with dummy vars
 ; and global val-exps with global assignments, and produce a letrec*
 ; in place of a letrec.
  (lambda (ae types vars val-exps body-exp)
    (let-values (((vars defns sets)
                  (let f ((types types) (vars vars))
                    (if (null? types)
                        (values '() '() '())
                        (let ((var (car vars)))
                          (let-values (((vars defns sets) (f (cdr types) (cdr vars))))
                            (if (eq? (car types) 'global)
                                (let ((x (build-lexical-var no-source var)))
                                  (values
                                    (cons x vars)
                                    (cons (build-global-definition no-source var (chi-void)) defns)
                                    (cons (build-global-assignment no-source var (build-lexical-reference 'value no-source x)) sets)))
                                (values (cons var vars) defns sets))))))))
      (if (null? defns)
          (build-letrec ae vars val-exps body-exp)
          (build-sequence no-source
            (append defns
              (list
                (build-letrec ae vars val-exps
                  (build-sequence no-source (append sets (list body-exp)))))))))))

(define-syntax build-lexical-var
  (syntax-rules ()
    ((_ ae id) (gensym id))))

(define-syntax lexical-var? gensym?)

(define-syntax self-evaluating?
  (syntax-rules ()
    ((_ e)
     (let ((x e))
;***       (or (boolean? x) (number? x) (string? x) (char? x) (null? x))))))
       (self-eval? x)))))
)

(define-syntax unannotate
  (syntax-rules ()
    ((_ x)
     (let ((e x))
       (if (annotation? e)
           (annotation-expression e)
           e)))))

(define-syntax no-source (identifier-syntax #f))

(define-syntax arg-check
  (syntax-rules ()
    ((_ pred? e who)
     (let ((x e))
;***        (if (not (pred? x)) (error-hook who "invalid argument" x))))))
       (if (not (pred? x))
           (error (string-append "(in "
                                 (symbol->string who)
                                 ") invalid argument")
                  x))))))

;;; compile-time environments

;;; wrap and environment comprise two level mapping.
;;;   wrap : id --> label
;;;   env : label --> <element>

;;; environments are represented in two parts: a lexical part and a global
;;; part.  The lexical part is a simple list of associations from labels
;;; to bindings.  The global part is implemented by
;;; {put,get}-global-definition-hook and associates symbols with
;;; bindings.

;;; global (assumed global variable) and displaced-lexical (see below)
;;; do not show up in any environment; instead, they are fabricated by
;;; lookup when it finds no other bindings.

;;; <environment>              ::= ((<label> . <binding>)*)

;;; identifier bindings include a type and a value

;;; <binding> ::= <procedure>                     macro keyword
;;;               (macro . <procedure>)           macro keyword
;;;               (deferred . <thunk>)            macro keyword w/lazily evaluated transformer
;;;               (macro! . <procedure>)          extended identifier macro keyword
;;;               (core . <procedure>)            core keyword
;;;               (begin)                         begin keyword
;;;               (define)                        define keyword
;;;               (define-syntax)                 define-syntax keyword
;;;               (local-syntax . <boolean>)      let-syntax (#f)/letrec-syntax (#t) keyword
;;;               (eval-when)                     eval-when keyword
;;;               (set!)                          set! keyword
;;;               (meta)                          meta keyword
;;;               ($module-key)                   $module keyword
;;;               ($import)                       $import keyword
;;;               ($module . <interface>)         modules
;;;               (syntax . (<var> . <level>))    pattern variables
;;;               (global . <symbol>)             assumed global variable
;;;               (meta-variable . <symbol>)      meta variable
;;;               (lexical . <var>)               lexical variables
;;;               (displaced-lexical . #f)        id-var-name not found in store
;;; <level>   ::= <nonnegative integer>
;;; <var>     ::= variable returned by build-lexical-var

;;; a macro is a user-defined syntactic-form.  a core is a system-defined
;;; syntactic form.  begin, define, define-syntax, let-syntax, letrec-syntax,
;;; eval-when, and meta are treated specially since they are sensitive to
;;; whether the form is at top-level and can denote valid internal
;;; definitions.

;;; a pattern variable is a variable introduced by syntax-case and can
;;; be referenced only within a syntax form.

;;; any identifier for which no top-level syntax definition or local
;;; binding of any kind has been seen is assumed to be a global
;;; variable.

;;; a lexical variable is a lambda- or letrec-bound variable.

;;; a displaced-lexical identifier is a lexical identifier removed from
;;; it's scope by the return of a syntax object containing the identifier.
;;; a displaced lexical can also appear when a letrec-syntax-bound
;;; keyword is referenced on the rhs of one of the letrec-syntax clauses.
;;; a displaced lexical should never occur with properly written macros.

(define sanitize-binding
  (lambda (b)
    (cond
      ((procedure? b) (make-binding 'macro b))
      ((binding? b)
       (and (case (binding-type b)
              ((core macro macro! deferred) (and (procedure? (binding-value b))))
              (($module) (interface? (binding-value b)))
              ((lexical) (lexical-var? (binding-value b)))
             ((global meta-variable) (symbol? (binding-value b)))
              ((syntax) (let ((x (binding-value b)))
                          (and (pair? x)
                               (lexical-var? (car x))
                               (let ((n (cdr x)))
                                 (and (integer? n) (exact? n) (>= n 0))))))
              ((begin define define-syntax set! $module-key $import eval-when meta) (null? (binding-value b)))
              ((local-syntax) (boolean? (binding-value b)))
              ((displaced-lexical) (eq? (binding-value b) #f))
              (else #t))
            b))
      (else #f))))

(define-syntax make-binding
  (syntax-rules (quote)
    ((_ 'type #f) '(type . #f))
    ((_ type value) (cons type value))))
(define binding-type car)
(define binding-value cdr)
(define set-binding-type! set-car!)
(define set-binding-value! set-cdr!)
(define binding? (lambda (x) (and (pair? x) (symbol? (car x)))))

(define-syntax null-env (identifier-syntax '()))

(define extend-env
  (lambda (label binding r)
    (cons (cons label binding) r)))

(define extend-env*
  (lambda (labels bindings r)
    (if (null? labels)
        r
        (extend-env* (cdr labels) (cdr bindings)
          (extend-env (car labels) (car bindings) r)))))

(define extend-var-env*
  ; variant of extend-env* that forms "lexical" binding
  (lambda (labels vars r)
    (if (null? labels)
        r
        (extend-var-env* (cdr labels) (cdr vars)
          (extend-env (car labels) (make-binding 'lexical (car vars)) r)))))

(define (displaced-lexical? id r)
  (let ((n (id-var-name id empty-wrap)))
    (and n
         (let ((b (lookup n r)))
           (eq? (binding-type b) 'displaced-lexical)))))

(define displaced-lexical-error
  (lambda (id)
    (syntax-error id
      (if (id-var-name id empty-wrap)
          "identifier out of context"
          "identifier not visible"))))

(define lookup*
  ; x may be a label or a symbol
  ; although symbols are usually global, we check the environment first
  ; anyway because a temporary binding may have been established by
  ; fluid-let-syntax
  (lambda (x r)
    (cond
      ((assq x r) => cdr)
      ((symbol? x)
       (or (get-global-definition-hook x) (make-binding 'global x)))
      (else (make-binding 'displaced-lexical #f)))))

(define lookup
  (lambda (x r)
    (define whack-binding!
      (lambda (b *b)
        (set-binding-type! b (binding-type *b))
        (set-binding-value! b (binding-value *b))))
    (let ((b (lookup* x r)))
      (when (eq? (binding-type b) 'deferred)
        (whack-binding! b (make-transformer-binding ((binding-value b)))))
      b)))

(define make-transformer-binding
  (lambda (b)
    (or (sanitize-binding b)
        (syntax-error b "invalid transformer"))))

(define defer-or-eval-transformer
  (lambda (eval x)
    (if (built-lambda? x)
        (make-binding 'deferred (lambda () (eval x)))
        (make-transformer-binding (eval x)))))

(define global-extend
  (lambda (type sym val)
    (put-cte-hook sym (make-binding type val))))


;;; Conceptually, identifiers are always syntax objects.  Internally,
;;; however, the wrap is sometimes maintained separately (a source of
;;; efficiency and confusion), so that symbols are also considered
;;; identifiers by id?.  Externally, they are always wrapped.

(define nonsymbol-id?
  (lambda (x)
    (and (syntax-object? x)
         (symbol? (unannotate (syntax-object-expression x))))))

(define id?
  (lambda (x)
    (cond
      ((symbol? x) #t)
      ((syntax-object? x) (symbol? (unannotate (syntax-object-expression x))))
      ((annotation? x) (symbol? (annotation-expression x)))
      (else #f))))

(define-syntax id-sym-name
  (syntax-rules ()
    ((_ e)
     (let ((x e))
       (unannotate (if (syntax-object? x) (syntax-object-expression x) x))))))

(define id-marks
  (lambda (id)
    (if (syntax-object? id)
        (wrap-marks (syntax-object-wrap id))
        (wrap-marks top-wrap))))

(define id-subst
  (lambda (id)
    (if (syntax-object? id)
        (wrap-subst (syntax-object-wrap id))
        (wrap-marks top-wrap))))

(define id-sym-name&marks
  (lambda (x w)
    (if (syntax-object? x)
        (values
          (unannotate (syntax-object-expression x))
          (join-marks (wrap-marks w) (wrap-marks (syntax-object-wrap x))))
        (values (unannotate x) (wrap-marks w)))))

;;; syntax object wraps

;;;         <wrap>     ::= ((<mark> ...) . (<subst> ...))
;;;        <subst>     ::= <ribcage> | <shift>
;;;      <ribcage>     ::= #((<ex-symname> ...) (<mark> ...) (<label> ...)) ; extensible, for chi-internal/external
;;;                      | #(#(<symname> ...) #(<mark> ...) #(<label> ...)) ; nonextensible
;;;   <ex-symname>     ::= <symname> | <import token> | <barrier>
;;;        <shift>     ::= shift
;;;      <barrier>     ::= #f                                               ; inserted by import-only
;;; <import interface> ::= #<import-interface interface new-marks>
;;;        <token>     ::= <generated id>

(define make-wrap cons)
(define wrap-marks car)
(define wrap-subst cdr)


(define-syntax empty-wrap (identifier-syntax '(())))

(define-syntax top-wrap (identifier-syntax '((top))))

(define-syntax tmp-wrap (identifier-syntax '((tmp)))) ; for generate-temporaries

(define-syntax top-marked?
  (syntax-rules ()
    ((_ w) (memq 'top (wrap-marks w)))))

(define-syntax only-top-marked?
  (syntax-rules ()
    ((_ id) (same-marks? (wrap-marks (syntax-object-wrap id)) (wrap-marks top-wrap)))))

;;; labels

;;; simple labels must be comparable with "eq?" and distinct from symbols
;;; and pairs.

;;; indirect labels, which are implemented as pairs, are used to support
;;; import aliasing for identifiers exported (explictly or implicitly) from
;;; top-level modules.  chi-external creates an indirect label for each
;;; defined identifier, import causes the pair to be shared with aliases it
;;; establishes, and chi-top-module whacks the pair to hold the top-level
;;; identifier name (symbol) if the id is to be placed at top level, before
;;; expanding the right-hand sides of the definitions in the module.

(module (gen-indirect-label indirect-label? get-indirect-label set-indirect-label!)
  (define-structure (indirect-label label))
  (define gen-indirect-label
    (lambda ()
      (make-indirect-label (gen-label))))
  (define get-indirect-label (lambda (x) (indirect-label-label x)))
  (define set-indirect-label! (lambda (x v) (set-indirect-label-label! x v))))

(define gen-label
  (lambda () (string #\i)))
(define label?
  (lambda (x)
    (or (string? x) ; normal lexical labels
        (symbol? x) ; global labels (symbolic names)
        (indirect-label? x))))

(define gen-labels
  (lambda (ls)
    (if (null? ls)
        '()
        (cons (gen-label) (gen-labels (cdr ls))))))

(define-structure (ribcage 
                   id: 0E54356E-1759-409D-AB3F-0E5AD9E68939
                   predicate: bs-ribcage?
                   constant-constructor: #f
                   (symnames bs-ribcage-symnames set-bs-ribcage-symnames!)
                   (marks bs-ribcage-marks set-bs-ribcage-marks!)
                   (labels bs-ribcage-labels set-bs-ribcage-labels!)))
(begin
  (define (ribcage? obj)
    (or (bs-ribcage? obj)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (and (vector? obj)
               (eq? (vector-ref obj 0) 'ribcage)))))

  (define (ribcage-symnames obj)
    (if (bs-ribcage? obj)
        (bs-ribcage-symnames obj)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (vector-ref obj 1))))
  
  (define (set-ribcage-symnames! obj val)
    (if (bs-ribcage? obj)
        (set-bs-ribcage-symnames! obj val)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (vector-set! obj 1 val))))

  (define (ribcage-marks obj)
    (if (bs-ribcage? obj)
        (bs-ribcage-marks obj)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (vector-ref obj 2))))

  (define (set-ribcage-marks! obj val)
    (if (bs-ribcage? obj)
        (set-bs-ribcage-marks! obj val)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (vector-set! obj 2 val))))

  (define (ribcage-labels obj)
    (if (bs-ribcage? obj)
        (bs-ribcage-labels obj)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (vector-ref obj 3))))

  (define (set-ribcage-labels! obj val)
    (if (bs-ribcage? obj)
        (set-bs-ribcage-labels! obj val)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (vector-set! obj 3 val)))))

(define-structure (top-ribcage
                   id: E14B1CA5-AADF-4FF2-9EAA-70CCC11E5A91
                   predicate: bs-top-ribcage?
                   constant-constructor: #f
                   (key bs-top-ribcage-key set-bs-top-ribcage-key!)
                   (mutable? bs-top-ribcage-mutable? set-bs-top-ribcage-mutable?!)))

(begin
  (define (top-ribcage? obj)
    (or (bs-top-ribcage? obj)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (and (vector? obj)
               (eq? (vector-ref obj 0) 'top-ribcage)))))
  
  (define (top-ribcage-key obj)
    (if (bs-top-ribcage? obj)
        (bs-top-ribcage-key obj)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (vector-ref obj 1))))

  (define (set-top-ribcage-key! obj val)
    (if (bs-top-ribcage? obj)
        (set-bs-top-ribcage-key! obj val)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (vector-set! obj 1 val))))

  (define (top-ribcage-mutable? obj)
    (if (bs-top-ribcage? obj)
        (bs-top-ribcage-mutable? obj)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (vector-ref obj 2))))
  
  (define (set-top-ribcage-mutable?! obj val)
    (if (bs-top-ribcage? obj)
        (set-bs-top-ribcage-mutable?! obj val)
        (let ((obj (if (annotation? obj)
                       (annotation-stripped obj)
                       obj)))
          (vector-set! obj 2 val)))))

(define-structure (import-interface interface new-marks))
(define-structure (env top-ribcage wrap))

;;; Marks must be comparable with "eq?" and distinct from pairs and
;;; the symbol top.  We do not use integers so that marks will remain
;;; unique even across file compiles.

(define-syntax the-anti-mark (identifier-syntax #f))

(define anti-mark
  (lambda (w)
    (make-wrap (cons the-anti-mark (wrap-marks w))
               (cons 'shift (wrap-subst w)))))

(define-syntax new-mark
  (syntax-rules ()
    ((_) (string #\m))))

(define barrier-marker #f)

;;; make-empty-ribcage and extend-ribcage maintain list-based ribcages for
;;; internal definitions, in which the ribcages are built incrementally
(define-syntax make-empty-ribcage
  (syntax-rules ()
    ((_) (make-ribcage '() '() '()))))

(define extend-ribcage!
 ; must receive ids with complete wraps
 ; ribcage guaranteed to be list-based
  (lambda (ribcage id label)
    (set-ribcage-symnames! ribcage
      (cons (unannotate (syntax-object-expression id))
            (ribcage-symnames ribcage)))
    (set-ribcage-marks! ribcage
      (cons (wrap-marks (syntax-object-wrap id))
            (ribcage-marks ribcage)))
    (set-ribcage-labels! ribcage
      (cons label (ribcage-labels ribcage)))))

(define import-extend-ribcage!
 ; must receive ids with complete wraps
 ; ribcage guaranteed to be list-based
  (lambda (ribcage new-marks id label)
    (set-ribcage-symnames! ribcage
      (cons (unannotate (syntax-object-expression id))
            (ribcage-symnames ribcage)))
    (set-ribcage-marks! ribcage
      (cons (join-marks new-marks (wrap-marks (syntax-object-wrap id)))
            (ribcage-marks ribcage)))
    (set-ribcage-labels! ribcage
      (cons label (ribcage-labels ribcage)))))

(define extend-ribcage-barrier!
 ; must receive ids with complete wraps
 ; ribcage guaranteed to be list-based
  (lambda (ribcage killer-id)
    (extend-ribcage-barrier-help! ribcage (syntax-object-wrap killer-id))))

(define extend-ribcage-barrier-help!
  (lambda (ribcage wrap)
    (set-ribcage-symnames! ribcage
      (cons barrier-marker (ribcage-symnames ribcage)))
    (set-ribcage-marks! ribcage
      (cons (wrap-marks wrap) (ribcage-marks ribcage)))))

(define extend-ribcage-subst!
 ; ribcage guaranteed to be list-based
  (lambda (ribcage import-iface)
    (set-ribcage-symnames! ribcage
      (cons import-iface (ribcage-symnames ribcage)))))

(define lookup-import-binding-name
  (lambda (sym marks token new-marks)
    (let ((new (get-import-binding sym token)))
      (and new
           (let f ((new new))
             (cond
               ((pair? new) (or (f (car new)) (f (cdr new))))
               ((symbol? new)
                (and (same-marks? marks (join-marks new-marks (wrap-marks top-wrap))) new))
               ((same-marks? marks (join-marks new-marks (wrap-marks (syntax-object-wrap new)))) new)
               (else #f)))))))
  
(define store-import-binding
  (lambda (id token new-marks)
    (define cons-id
      (lambda (id x)
        (if (not x) id (cons id x))))
    (define weed ; remove existing binding for id, if any
      (lambda (marks x)
        (if (pair? x)
            (if (same-marks? (id-marks (car x)) marks)
                (weed marks (cdr x))
                (cons-id (car x) (weed marks (cdr x))))
            (and x (not (same-marks? (id-marks x) marks)) x))))
    (let ((id (if (null? new-marks)
                  id
                  (make-syntax-object (id-sym-name id)
                    (make-wrap
                      (join-marks new-marks (id-marks id))
                      (id-subst id))))))
      (let ((sym (id-sym-name id)))
       ; no need to record bindings mapping symbol to self, since this   
       ; assumed by default.
        (unless (eq? id sym)
          (let ((marks (id-marks id)))
            (update-import-binding! sym token
              (lambda (old-binding)
                (let ((x (weed marks old-binding)))
                  (cons-id
                    (if (same-marks? marks (wrap-marks top-wrap))
                       ; need full id only if more than top-marked.
                        (resolved-id-var-name id)
                        id)
                    x))))))))))

;;; make-binding-wrap creates vector-based ribcages
(define make-binding-wrap
  (lambda (ids labels w)
    (if (null? ids)
        w
        (make-wrap
          (wrap-marks w)
          (cons
            (let ((labelvec (list->vector labels)))
              (let ((n (vector-length labelvec)))
                (let ((symnamevec (make-vector n)) (marksvec (make-vector n)))
                  (let f ((ids ids) (i 0))
                    (unless (null? ids)
                      (let-values (((symname marks) (id-sym-name&marks (car ids) w)))
                        (vector-set! symnamevec i symname)
                        (vector-set! marksvec i marks)
                        (f (cdr ids) (fx+ i 1)))))
                  (make-ribcage symnamevec marksvec labelvec))))
            (wrap-subst w))))))

;;; resolved ids contain no unnecessary substitutions or marks.  they are
;;; used essentially as indirects or aliases in modules interfaces.
(define make-resolved-id
  (lambda (fromsym marks tosym)
    (make-syntax-object fromsym
      (make-wrap marks
        (list (make-ribcage (vector fromsym) (vector marks) (vector tosym)))))))

(define id->resolved-id
  (lambda (id)
    (let-values (((tosym marks) (id-var-name&marks id empty-wrap)))
      (unless tosym
        (syntax-error id "identifier not visible for export"))
      (make-resolved-id (id-sym-name id) marks tosym))))

(define resolved-id-var-name
  (lambda (id)
    (vector-ref
      (ribcage-labels (car (wrap-subst (syntax-object-wrap id))))
      0)))

;;; Scheme's append should not copy the first argument if the second is
;;; nil, but it does, so we define a smart version here.
(define smart-append
  (lambda (m1 m2)
    (if (null? m2)
        m1
        (append m1 m2))))

(define join-wraps
  (lambda (w1 w2)
    (let ((m1 (wrap-marks w1)) (s1 (wrap-subst w1)))
      (if (null? m1)
          (if (null? s1)
              w2
              (make-wrap
                (wrap-marks w2)
                (join-subst s1 (wrap-subst w2))))
          (make-wrap
            (join-marks m1 (wrap-marks w2))
            (join-subst s1 (wrap-subst w2)))))))

(define join-marks
  (lambda (m1 m2)
    (smart-append m1 m2)))

(define join-subst
  (lambda (s1 s2)
    (smart-append s1 s2)))

(define same-marks?
  (lambda (x y)
    (or (eq? x y)
        (and (not (null? x))
             (not (null? y))
             (eq? (car x) (car y))
             (same-marks? (cdr x) (cdr y))))))

(define diff-marks
  (lambda (m1 m2)
    (let ((n1 (length m1)) (n2 (length m2)))
      (let f ((n1 n1) (m1 m1))
        (cond
          ((> n1 n2) (cons (car m1) (f (- n1 1) (cdr m1))))
          ((equal? m1 m2) '())
;***           (else (error 'sc-expand
;***                   "internal error in diff-marks: ~s is not a tail of ~s"
;***                   m1 m2)))))))
          (else (error
                  "internal error in diff-marks"
                  m1 m2)))))))

(module (top-id-bound-var-name top-id-free-var-name)
  ;; top-id-bound-var-name is used to look up or establish new top-level
  ;; substitutions, while top-id-free-var-name is used to look up existing
  ;; (possibly implicit) substitutions.  Implicit substitutions exist
  ;; for top-marked names in all environments, but we represent them
  ;; explicitly only on demand.
  ;;
  ;; In both cases, we first look for an existing substitution for sym
  ;; and the given marks.  If we find one, we return it.  Otherwise, we
  ;; extend the appropriate top-level environment
  ;;
  ;; For top-id-bound-var-name, we extend the environment with a substition
  ;; keyed by the given marks, so that top-level definitions introduced by
  ;; a macro are distinct from other top-level definitions for the same
  ;; name.  For example, if macros a and b both introduce definitions and
  ;; bound references to identifier x, the two x's should be different,
  ;; i.e., keyed by their own marks.
  ;;
  ;; For top-id-free-var-name, we extend the environment with a substition
  ;; keyed by the top marks, since top-level free identifier references
  ;; should refer to the existing implicit (top-marked) substitution.  For
  ;; example, if macros a and b both introduce free references to identifier
  ;; x, they should both refer to the same (global, unmarked) x.
  ;;
 ;; If the environment is *top*, we map a symbol to itself

 (define leave-implicit? (lambda (token) (eq? token '*top*)))

  (define new-binding
    (lambda (sym marks token)
      (let ((loc (if (and (leave-implicit? token)
                          (same-marks? marks (wrap-marks top-wrap)))
                     sym
                     (generate-id sym))))
        (let ((id (make-resolved-id sym marks loc)))
          (store-import-binding id token '())
          (values loc id)))))

  (define top-id-bound-var-name
   ; should be called only when top-ribcage is mutable
    (lambda (sym marks top-ribcage)
      (let ((token (top-ribcage-key top-ribcage)))
        (cond
          ((lookup-import-binding-name sym marks token '()) =>
           (lambda (id)
             (if (symbol? id) ; symbol iff marks == (wrap-marks top-wrap)
                 (if (read-only-binding? id)
                     (new-binding sym marks token)
                     (values id (make-resolved-id sym marks id)))
                 (values (resolved-id-var-name id) id))))
          (else (new-binding sym marks token))))))

  (define top-id-free-var-name
    (lambda (sym marks top-ribcage)
      (let ((token (top-ribcage-key top-ribcage)))
        (cond
          ((lookup-import-binding-name sym marks token '()) =>
           (lambda (id) (if (symbol? id) id (resolved-id-var-name id))))
          ((and (top-ribcage-mutable? top-ribcage)
                (same-marks? marks (wrap-marks top-wrap)))
           (let-values (((sym id) (new-binding sym (wrap-marks top-wrap) token)))
             sym))
          (else #f))))))

(define id-var-name-loc&marks
  (lambda (id w)
    (define search
      (lambda (sym subst marks)
        (if (null? subst)
            (values #f marks)
            (let ((fst (car subst)))
               (cond
                 ((eq? fst 'shift) (search sym (cdr subst) (cdr marks)))
                 ((ribcage? fst)
                  (let ((symnames (ribcage-symnames fst)))
                    (if (vector? symnames)
                        (search-vector-rib sym subst marks symnames fst)
                        (search-list-rib sym subst marks symnames fst))))
                 ((top-ribcage? fst)
                  (cond
                    ((top-id-free-var-name sym marks fst) =>
                     (lambda (var-name) (values var-name marks)))
                    (else (search sym (cdr subst) marks))))
                 (else
                  (error
                    "internal error in id-var-name-loc&marks: improper subst"
                    subst)))))))
    (define search-list-rib
      (lambda (sym subst marks symnames ribcage)
        (let f ((symnames symnames) (i 0))
          (if (null? symnames)
              (search sym (cdr subst) marks)
              (let ((x (car symnames)))
                (cond
                  ((and (eq? x sym)
                        (same-marks? marks (list-ref (ribcage-marks ribcage) i)))
                   (values (list-ref (ribcage-labels ribcage) i) marks))
                  ((import-interface? x)
                   (let ((iface (import-interface-interface x))
                         (new-marks (import-interface-new-marks x)))
                     (cond
                       ((interface-token iface) =>
                        (lambda (token)
                          (cond
                            ((lookup-import-binding-name sym marks token new-marks) =>
                             (lambda (id)
                               (values
                                 (if (symbol? id) id (resolved-id-var-name id))
                                 marks)))
                            (else (f (cdr symnames) i)))))
                       (else
                        (let* ((ie (interface-exports iface))
                               (n (vector-length ie)))
                          (let g ((j 0))
                            (if (fx= j n)
                                (f (cdr symnames) i)
                                (let ((id (vector-ref ie j)))
                                  (let ((id.sym (id-sym-name id))
                                        (id.marks (join-marks new-marks (id-marks id))))
                                    (if (help-bound-id=? id.sym id.marks sym marks)
                                        (values (lookup-import-label id) marks)
                                        (g (fx+ j 1))))))))))))
                  ((and (eq? x barrier-marker)
                        (same-marks? marks (list-ref (ribcage-marks ribcage) i)))
                   (values #f marks))
                  (else (f (cdr symnames) (fx+ i 1)))))))))
    (define search-vector-rib
      (lambda (sym subst marks symnames ribcage)
        (let ((n (vector-length symnames)))
          (let f ((i 0))
            (cond
              ((fx= i n) (search sym (cdr subst) marks))
              ((and (eq? (vector-ref symnames i) sym)
                    (same-marks? marks (vector-ref (ribcage-marks ribcage) i)))
               (values (vector-ref (ribcage-labels ribcage) i) marks))
              (else (f (fx+ i 1))))))))
    (cond
      ((symbol? id) (search id (wrap-subst w) (wrap-marks w)))
      ((syntax-object? id)
       (let ((sym (unannotate (syntax-object-expression id)))
             (w1 (syntax-object-wrap id)))
         (let-values (((name marks) (search sym (wrap-subst w)
                                      (join-marks
                                        (wrap-marks w)
                                        (wrap-marks w1)))))
           (if name
               (values name marks)
               (search sym (wrap-subst w1) marks)))))
      ((annotation? id) (search (unannotate id) (wrap-subst w) (wrap-marks w)))
;***       (else (error-hook 'id-var-name "invalid id" id)))))
      (else (error "(in id-var-name) invalid id" id)))))

(define id-var-name&marks
 ; this version follows indirect labels
  (lambda (id w)
    (let-values (((label marks) (id-var-name-loc&marks id w)))
      (values (if (indirect-label? label) (get-indirect-label label) label) marks))))

(define id-var-name-loc
 ; this version doesn't follow indirect labels
  (lambda (id w)
    (let-values (((label marks) (id-var-name-loc&marks id w)))
      label)))

(define id-var-name
 ; this version follows indirect labels
  (lambda (id w)
    (let-values (((label marks) (id-var-name-loc&marks id w)))
      (if (indirect-label? label) (get-indirect-label label) label))))

;;; free-id=? must be passed fully wrapped ids since (free-id=? x y)
;;; may be true even if (free-id=? (wrap x w) (wrap y w)) is not.

(define free-id=?
  (lambda (i j)
    (and (eq? (id-sym-name i) (id-sym-name j)) ; accelerator
         (eq? (id-var-name i empty-wrap) (id-var-name j empty-wrap)))))

(define literal-id=?
  (lambda (id literal)
    (and (eq? (id-sym-name id) (id-sym-name literal))
         (let ((n-id (id-var-name id empty-wrap))
               (n-literal (id-var-name literal empty-wrap)))
           (or (eq? n-id n-literal)
               (and (or (not n-id) (symbol? n-id))
                    (or (not n-literal) (symbol? n-literal))))))))

;;; bound-id=? may be passed unwrapped (or partially wrapped) ids as
;;; long as the missing portion of the wrap is common to both of the ids
;;; since (bound-id=? x y) iff (bound-id=? (wrap x w) (wrap y w))

(define help-bound-id=?
  (lambda (i.sym i.marks j.sym j.marks)
    (and (eq? i.sym j.sym)
         (same-marks? i.marks j.marks))))
   
(define bound-id=?
  (lambda (i j)
    (help-bound-id=? (id-sym-name i) (id-marks i) (id-sym-name j) (id-marks j))))

;;; "valid-bound-ids?" returns #t if it receives a list of distinct ids.
;;; valid-bound-ids? may be passed unwrapped (or partially wrapped) ids
;;; as long as the missing portion of the wrap is common to all of the
;;; ids.

(define valid-bound-ids?
  (lambda (ids)
     (and (let all-ids? ((ids ids))
            (or (null? ids)
                (and (id? (car ids))
                     (all-ids? (cdr ids)))))
          (distinct-bound-ids? ids))))

;;; distinct-bound-ids? expects a list of ids and returns #t if there are
;;; no duplicates.  It is quadratic on the length of the id list; long
;;; lists could be sorted to make it more efficient.  distinct-bound-ids?
;;; may be passed unwrapped (or partially wrapped) ids as long as the
;;; missing portion of the wrap is common to all of the ids.

(define distinct-bound-ids?
  (lambda (ids)
    (let distinct? ((ids ids))
      (or (null? ids)
          (and (not (bound-id-member? (car ids) (cdr ids)))
               (distinct? (cdr ids)))))))

(define invalid-ids-error
 ; find first bad one and complain about it
  (lambda (ids exp class)
    (let find ((ids ids) (gooduns '()))
      (if (null? ids)
          (syntax-error exp) ; shouldn't happen
          (if (id? (car ids))
              (if (bound-id-member? (car ids) gooduns)
                  (syntax-error (car ids) "duplicate " class)
                  (find (cdr ids) (cons (car ids) gooduns)))
              (syntax-error (car ids) "invalid " class))))))

(define bound-id-member?
   (lambda (x list)
      (and (not (null? list))
           (or (bound-id=? x (car list))
               (bound-id-member? x (cdr list))))))

;;; wrapping expressions and identifiers

(define wrap
  (lambda (x w)
    (cond
      ((and (null? (wrap-marks w)) (null? (wrap-subst w))) x)
      ((syntax-object? x)
       (make-syntax-object
         (syntax-object-expression x)
         (join-wraps w (syntax-object-wrap x))))
      ((null? x) x)
      (else (make-syntax-object x w)))))

(define source-wrap
  (lambda (x w ae)
    (wrap (if (annotation? ae)
              (begin
                (unless (eq? (annotation-expression ae) x)
;***                  (error 'sc-expand "internal error in source-wrap: ae/x mismatch"))
                  (error "internal error in source-wrap: ae/x mismatch"))
                ae)
              x)
          w)))

;;; expanding

(define chi-when-list
  (lambda (when-list w)
    ; when-list is syntax'd version of list of situations
    (map (lambda (x)
           (cond
             ((literal-id=? x (syntax compile)) 'compile)
             ((literal-id=? x (syntax load)) 'load)
             ((literal-id=? x (syntax visit)) 'visit)
             ((literal-id=? x (syntax revisit)) 'revisit)
             ((literal-id=? x (syntax eval)) 'eval)
             (else (syntax-error (wrap x w) "invalid eval-when situation"))))
         when-list)))

;;; syntax-type returns five values: type, value, e, w, and ae.  The first
;;; two are described in the table below.
;;;
;;;    type                   value         explanation
;;;    -------------------------------------------------------------------
;;;    alias                  none          alias keyword
;;;    alias-form             none          alias expression
;;;    begin                  none          begin keyword
;;;    begin-form             none          begin expression
;;;    call                   none          any other call
;;;    constant               none          self-evaluating datum
;;;    core                   procedure     core form (including singleton)
;;;    define                 none          define keyword
;;;    define-form            none          variable definition
;;;    define-syntax          none          define-syntax keyword
;;;    define-syntax-form     none          syntax definition
;;;    displaced-lexical      none          displaced lexical identifier
;;;    eval-when              none          eval-when keyword
;;;    eval-when-form         none          eval-when form
;;;    global                 name          global variable reference
;;;    $import                none          $import keyword
;;;    $import-form           none          $import form
;;;    lexical                name          lexical variable reference
;;;    lexical-call           name          call to lexical variable
;;;    local-syntax           rec?          letrec-syntax/let-syntax keyword
;;;    local-syntax-form      rec?          syntax definition
;;;    meta                   none          meta keyword
;;;    meta-form              none          meta form
;;;    meta-variable          name          meta variable
;;;    $module                none          $module keyword
;;;    $module-form           none          $module definition
;;;    syntax                 level         pattern variable
;;;    other                  none          anything else
;;;
;;; For all forms, e is the form, w is the wrap for e. and ae is the
;;; (possibly) source-annotated form.
;;;
;;; syntax-type expands macros and unwraps as necessary to get to
;;; one of the forms above.

(define syntax-type
  (lambda (e r w ae rib)
    (cond
      ((symbol? e)
       (let* ((n (id-var-name e w))
              (b (lookup n r))
              (type (binding-type b)))
         (case type
           ((macro macro!) (syntax-type (chi-macro (binding-value b) e r w ae rib) r empty-wrap #f rib))
           (else (values type (binding-value b) e w ae)))))
      ((pair? e)
       (let ((first (car e)))
         (if (id? first)
             (let* ((n (id-var-name first w))
                    (b (lookup n r))
                    (type (binding-type b)))
               (case type
                 ((lexical) (values 'lexical-call (binding-value b) e w ae))
                 ((macro macro!)
                  (syntax-type (chi-macro (binding-value b) e r w ae rib)
                    r empty-wrap #f rib))
                 ((core) (values type (binding-value b) e w ae))
                 ((begin ##begin) (values 'begin-form #f e w ae))
                 ((alias) (values 'alias-form #f e w ae))
                 ((define) (values 'define-form #f e w ae))
                 ((define-syntax) (values 'define-syntax-form #f e w ae))
                 ((set!) (chi-set! e r w ae rib))
                 (($module-key) (values '$module-form #f e w ae))
                 (($import) (values '$import-form #f e w ae))
                 ((eval-when) (values 'eval-when-form #f e w ae))
                 ((meta) (values 'meta-form #f e w ae))
                 ((local-syntax)
                  (values 'local-syntax-form (binding-value b) e w ae))
                 (else (values 'call #f e w ae))))
             (values 'call #f e w ae))))
      ((syntax-object? e)
       (syntax-type (syntax-object-expression e)
                    r
                    (join-wraps w (syntax-object-wrap e))
                    #f rib))
      ((annotation? e)
       (syntax-type (annotation-expression e) r w e rib))
      ((self-evaluating? e) (values 'constant #f e w ae))
      (else (values 'other #f e w ae)))))

(define chi-top*
  (lambda (e r w ctem rtem meta? top-ribcage)
    (let ((meta-residuals '()))
      (define meta-residualize!
        (lambda (x)
          (set! meta-residuals
            (cons x meta-residuals))))
      (let ((e (chi-top e r w ctem rtem meta? top-ribcage meta-residualize! #f)))
        (build-sequence no-source
          (reverse (cons e meta-residuals)))))))

(define chi-top-sequence
  (lambda (body r w ae ctem rtem meta? ribcage meta-residualize!)
    (build-sequence ae
      (let dobody ((body body))
        (if (null? body)
            '()
            (let ((first (chi-top (car body) r w ctem rtem meta? ribcage meta-residualize! #f)))
              (cons first (dobody (cdr body)))))))))

(define chi-top
  (lambda (e r w ctem rtem meta? top-ribcage meta-residualize! meta-seen?)
    (let-values (((type value e w ae) (syntax-type e r w no-source top-ribcage)))
      (case type
        ((begin-form)
         (let ((forms (parse-begin e w ae #t)))
           (if (null? forms)
               (chi-void)
               (chi-top-sequence forms r w ae ctem rtem meta? top-ribcage meta-residualize!))))
        ((local-syntax-form)
         (let-values (((forms r mr w ae) (chi-local-syntax value e r r w ae)))
          ; mr should be same as r here
           (chi-top-sequence forms r w ae ctem rtem meta? top-ribcage meta-residualize!)))
        ((eval-when-form)
         (let-values (((when-list forms) (parse-eval-when e w ae)))
           (let ((ctem (update-mode-set when-list ctem))
                 (rtem (update-mode-set when-list rtem)))
             (if (and (null? ctem) (null? rtem))
                 (chi-void)
                 (chi-top-sequence forms r w ae ctem rtem meta? top-ribcage meta-residualize!)))))
        ((meta-form) (chi-top (parse-meta e w ae) r w ctem rtem #t top-ribcage meta-residualize! #t))
        ((define-syntax-form)
         (let-values (((id rhs w) (parse-define-syntax e w ae)))
           (let ((id (wrap id w)))
             (when (displaced-lexical? id r) (displaced-lexical-error id))
             (unless (top-ribcage-mutable? top-ribcage)
               (syntax-error (source-wrap e w ae)
                 "invalid definition in read-only environment"))
             (let ((sym (id-sym-name id)))
               (let-values (((valsym bound-id) (top-id-bound-var-name sym (wrap-marks (syntax-object-wrap id)) top-ribcage)))
                 (unless (eq? (id-var-name id empty-wrap) valsym)
                   (syntax-error (source-wrap e w ae)
                     "definition not permitted"))
                 (when (read-only-binding? valsym)
                   (syntax-error (source-wrap e w ae)
                     "invalid definition of read-only identifier"))
                 (ct-eval/residualize2 ctem
                   (lambda ()
                     (build-cte-install
                       bound-id
                       (chi rhs r r w #t)
                       (top-ribcage-key top-ribcage)))))))))
        ((define-form)
         (let-values (((id rhs w) (parse-define e w ae)))
           (let ((id (wrap id w)))
             (when (displaced-lexical? id r) (displaced-lexical-error id))
             (unless (top-ribcage-mutable? top-ribcage)
               (syntax-error (source-wrap e w ae)
                 "invalid definition in read-only environment"))
             (let ((sym (id-sym-name id)))
               (let-values (((valsym bound-id) (top-id-bound-var-name sym (wrap-marks (syntax-object-wrap id)) top-ribcage)))
                 (unless (eq? (id-var-name id empty-wrap) valsym)
                   (syntax-error (source-wrap e w ae)
                     "definition not permitted"))
                 (when (read-only-binding? valsym)
                   (syntax-error (source-wrap e w ae)
                     "invalid definition of read-only identifier"))
                 (if meta?
                     (ct-eval/residualize2 ctem
                       (lambda ()
                         (build-sequence no-source
                           (list
                             (build-cte-install bound-id
                               (build-data no-source (make-binding 'meta-variable valsym))
                               (top-ribcage-key top-ribcage))
                             (build-global-definition ae valsym (chi rhs r r w #t))))))
                    ; make sure compile-time definitions occur before we
                    ; expand the run-time code
                     (let ((x (ct-eval/residualize2 ctem
                                (lambda ()
                                  (build-cte-install
                                    bound-id
                                    (build-data no-source (make-binding 'global valsym))
                                    (top-ribcage-key top-ribcage))))))
                       (build-sequence no-source
                         (list
                           x
                           (rt-eval/residualize rtem
                             (lambda ()
                               (build-global-definition ae valsym (chi rhs r r w #f)))))))))
             ))))
        (($module-form)
         (let ((ribcage (make-empty-ribcage)))
           (let-values (((orig id exports forms)
                         (parse-module e w ae
                           (make-wrap (wrap-marks w) (cons ribcage (wrap-subst w))))))
             (when (displaced-lexical? id r) (displaced-lexical-error (wrap id w)))
             (unless (top-ribcage-mutable? top-ribcage)
               (syntax-error orig
                 "invalid definition in read-only environment"))
             (chi-top-module orig r r top-ribcage ribcage ctem rtem meta? id exports forms meta-residualize!))))
        (($import-form)
         (let-values (((orig only? mid) (parse-import e w ae)))
           (unless (top-ribcage-mutable? top-ribcage)
             (syntax-error orig
               "invalid definition in read-only environment"))
           (ct-eval/residualize2 ctem
             (lambda ()
               (let ((binding (lookup (id-var-name mid empty-wrap) null-env)))
                 (case (binding-type binding)
                   (($module) (do-top-import only? top-ribcage mid (interface-token (binding-value binding))))
                   ((displaced-lexical) (displaced-lexical-error mid))
                   (else (syntax-error mid "unknown module"))))))))
        ((alias-form)
         (let-values (((new-id old-id) (parse-alias e w ae)))
           (let ((new-id (wrap new-id w)))
             (when (displaced-lexical? new-id r) (displaced-lexical-error new-id))
             (unless (top-ribcage-mutable? top-ribcage)
               (syntax-error (source-wrap e w ae)
                 "invalid definition in read-only environment"))
             (let ((sym (id-sym-name new-id)))
               (let-values (((valsym bound-id) (top-id-bound-var-name sym (wrap-marks (syntax-object-wrap new-id)) top-ribcage)))
                 (unless (eq? (id-var-name new-id empty-wrap) valsym)
                   (syntax-error (source-wrap e w ae)
                     "definition not permitted"))
                 (when (read-only-binding? valsym)
                   (syntax-error (source-wrap e w ae)
                     "invalid definition of read-only identifier"))
                 (ct-eval/residualize2 ctem
                   (lambda ()
                     (build-cte-install
                       (make-resolved-id sym (wrap-marks (syntax-object-wrap new-id)) (id-var-name old-id w))
                       (build-data no-source (make-binding 'do-alias #f))
                       (top-ribcage-key top-ribcage)))))))))
        (else
         (when meta-seen? (syntax-error (source-wrap e w ae) "invalid meta definition"))
         (if meta?
             (let ((x (chi-expr type value e r r w ae #t)))
               (top-level-eval-hook x)
               (ct-eval/residualize3 ctem void (lambda () x)))
             (rt-eval/residualize rtem
               (lambda ()
                 (chi-expr type value e r r w ae #f)))))))))

(define flatten-exports
  (lambda (exports)
    (let loop ((exports exports) (ls '()))
      (if (null? exports)
          ls
          (loop (cdr exports)
                (if (pair? (car exports))
                    (loop (car exports) ls)
                    (cons (car exports) ls)))))))


(define-structure (interface marks exports token))

;; leaves interfaces unresolved so that indirect labels can be followed.
;; (can't resolve until indirect labels have their final value)
(define make-unresolved-interface
 ; trim out implicit exports
  (lambda (mid exports)
    (make-interface
      (wrap-marks (syntax-object-wrap mid))
      (list->vector (map (lambda (x) (if (pair? x) (car x) x)) exports))
      #f)))

(define make-resolved-interface
 ; trim out implicit exports & resolve others to actual top-level symbol
  (lambda (mid exports token)
    (make-interface
      (wrap-marks (syntax-object-wrap mid))
      (list->vector (map (lambda (x) (id->resolved-id (if (pair? x) (car x) x))) exports))
      token)))

(define-structure (module-binding type id label imps val exported))
(define create-module-binding
  (lambda (type id label imps val)
    (make-module-binding type id label imps val #f)))

;;; frobs represent body forms
(define-structure (frob e meta?))

(define chi-top-module
  (lambda (orig r mr top-ribcage ribcage ctem rtem meta? id exports forms meta-residualize!)
    (let ((fexports (flatten-exports exports)))
      (let-values (((r mr bindings inits)
                    (chi-external ribcage orig
                      (map (lambda (d) (make-frob d meta?)) forms) r mr ctem exports fexports
                      meta-residualize!)))
       ; identify exported identifiers, create ctdefs
        (let process-exports ((fexports fexports) (ctdefs (lambda () '())))
          (if (null? fexports)
             ; remaining bindings are either identified global vars,
             ; local vars, or local compile-time entities
             ; dts: type (local/global)
             ; dvs & des: define lhs & rhs
              (let process-locals ((bs bindings) (r r) (dts '()) (dvs '()) (des '()))
                (if (null? bs)
                    (let ((des (chi-frobs des r mr #f))
                          (inits (chi-frobs inits r mr #f)))
                      (build-sequence no-source
                        (append
                         ; we wait to establish global compile-time definitions so that
                         ; expansion of des use local versions of modules and macros
                         ; in case ctem tells us not to eval ctdefs now.  this means that
                         ; local code can use exported compile-time values (modules, macros,
                         ; meta variables) just as it can unexported ones.
                          (ctdefs)
                          (list
                            (ct-eval/residualize2 ctem
                              (lambda ()
                                (let ((sym (id-sym-name id)))
                                  (let* ((token (generate-id sym))
                                         (b (build-data no-source
                                              (make-binding '$module
                                                (make-resolved-interface id exports token)))))
                                    (let-values (((valsym bound-id)
                                                  (top-id-bound-var-name sym
                                                    (wrap-marks (syntax-object-wrap id))
                                                    top-ribcage)))
                                      (unless (eq? (id-var-name id empty-wrap) valsym)
                                        (syntax-error orig
                                          "definition not permitted"))
                                      (when (read-only-binding? valsym)
                                        (syntax-error orig
                                          "invalid definition of read-only identifier"))
                                      (build-cte-install bound-id b
                                        (top-ribcage-key top-ribcage)))))))
                            (rt-eval/residualize rtem
                              (lambda ()
                                (build-top-module no-source dts dvs des
                                  (if (null? inits)
                                      (chi-void)
                                      (build-sequence no-source
                                        (append inits (list (chi-void))))))))))))
                    (let ((b (car bs)) (bs (cdr bs)))
                      (let ((t (module-binding-type b)))
                        (case (module-binding-type b)
                          ((define-form)
                           (let ((label (get-indirect-label (module-binding-label b))))
                             (if (module-binding-exported b)
                                 (let ((var (module-binding-id b)))
                                   (process-locals bs r (cons 'global dts) (cons label dvs)
                                     (cons (module-binding-val b) des)))
                                 (let ((var (gen-var (module-binding-id b))))
                                   (process-locals bs
                                    ; add lexical bindings only to run-time environment
                                     (extend-env label (make-binding 'lexical var) r)
                                     (cons 'local dts) (cons var dvs)
                                     (cons (module-binding-val b) des))))))
                          ((ctdefine-form define-syntax-form $module-form alias-form) (process-locals bs r dts dvs des))
;***                           (else (error 'sc-expand-internal "unexpected module binding type ~s" t)))))))
                          (else (error "unexpected module binding type" t)))))))
              (let ((id (car fexports)) (fexports (cdr fexports)))
                (let loop ((bs bindings))
                  (if (null? bs)
                     ; must be rexport from an imported module
                      (process-exports fexports ctdefs)
                      (let ((b (car bs)) (bs (cdr bs)))
                       ; following formerly used bound-id=?, but free-id=? can prevent false positives
                       ; and is okay since the substitutions have already been applied
                        (if (free-id=? (module-binding-id b) id)
                            (if (module-binding-exported b)
                                (process-exports fexports ctdefs)
                                (let* ((t (module-binding-type b))
                                       (label (module-binding-label b))
                                       (imps (module-binding-imps b))
                                       (fexports (append imps fexports)))
                                  (set-module-binding-exported! b #t)
                                  (case t
                                    ((define-form)
                                     (let ((sym (generate-id (id-sym-name id))))
                                       (set-indirect-label! label sym)
                                       (process-exports fexports ctdefs)))
                                    ((ctdefine-form)
                                     (let ((b (module-binding-val b)))
                                       (process-exports fexports
                                         (lambda ()
                                           (let ((sym (binding-value b)))
                                             (set-indirect-label! label sym)
                                             (cons (ct-eval/residualize3 ctem
                                                     (lambda () (put-cte-hook sym b))
                                                     (lambda () (build-cte-install sym (build-data no-source b) #f)))
                                                   (ctdefs)))))))
                                    ((define-syntax-form)
                                     (let ((sym (generate-id (id-sym-name id))))
                                       (process-exports fexports
                                         (lambda () 
                                           (let ((local-label (get-indirect-label label)))
                                             (set-indirect-label! label sym)
                                             (cons
                                               (ct-eval/residualize3 ctem
                                                 (lambda () (put-cte-hook sym (car (module-binding-val b))))
                                                 (lambda () (build-cte-install sym (cdr (module-binding-val b)) #f)))
                                               (ctdefs)))))))
                                    (($module-form)
                                     (let ((sym (generate-id (id-sym-name id)))
                                           (exports (module-binding-val b)))
                                       (process-exports (append (flatten-exports exports) fexports)
                                         (lambda ()
                                           (set-indirect-label! label sym)
                                           (let ((rest (ctdefs))) ; set indirect labels before resolving
                                             (let ((x (make-binding '$module (make-resolved-interface id exports sym))))
                                               (cons (ct-eval/residualize3 ctem
                                                       (lambda () (put-cte-hook sym x))
                                                       (lambda () (build-cte-install sym (build-data no-source x) #f)))
                                                     rest)))))))
                                    ((alias-form)
                                     (process-exports
                                       fexports
                                       (lambda ()
                                         (let ((rest (ctdefs))) ; set indirect labels before resolving
                                           (when (indirect-label? label)
                                             (unless (symbol? (get-indirect-label label))
                                               (syntax-error (module-binding-id b) "unexported target of alias")))
                                           rest))))
;***                                     (else (error 'sc-expand-internal "unexpected module binding type ~s" t)))))
                                    (else (error "unexpected module binding type" t)))))
                            (loop bs))))))))))))

(define id-set-diff
  (lambda (exports defs)
    (cond
      ((null? exports) '())
      ((bound-id-member? (car exports) defs) (id-set-diff (cdr exports) defs))
      (else (cons (car exports) (id-set-diff (cdr exports) defs))))))

(define check-module-exports
  ; After processing the definitions of a module this is called to verify that the
  ; module has defined or imported each exported identifier.  Because ids in fexports are
  ; wrapped with the given ribcage, they will contain substitutions for anything defined
  ; or imported here.  These subsitutions can be used by do-import! and do-import-top! to
  ; provide access to reexported bindings, for example.
  (lambda (source-exp fexports ids)
    (define defined?
      (lambda (e ids)
        (ormap (lambda (x)
                 (if (import-interface? x)
                     (let ((x.iface (import-interface-interface x))
                           (x.new-marks (import-interface-new-marks x)))
                       (cond
                         ((interface-token x.iface) =>
                          (lambda (token)
                            (lookup-import-binding-name (id-sym-name e) (id-marks e) token x.new-marks)))
                         (else
                          (let ((v (interface-exports x.iface)))
                            (let lp ((i (fx- (vector-length v) 1)))
                              (and (fx>= i 0)
                                   (or (let ((id (vector-ref v i)))
                                         (help-bound-id=?
                                           (id-sym-name id)
                                           (join-marks x.new-marks (id-marks id))
                                           (id-sym-name e) (id-marks e)))
                                       (lp (fx- i 1)))))))))
                     (bound-id=? e x)))
               ids)))
    (let loop ((fexports fexports) (missing '()))
      (if (null? fexports)
          (unless (null? missing)
            (syntax-error (car missing)
              (if (= (length missing) 1)
                  "missing definition for export"
                  "missing definition for multiple exports, including")))
          (let ((e (car fexports)) (fexports (cdr fexports)))
            (if (defined? e ids)
                (loop fexports missing)
                (loop fexports (cons e missing))))))))

(define check-defined-ids
  (lambda (source-exp ls)
    (define vfold
      (lambda (v p cls)
        (let ((len (vector-length v)))
          (let lp ((i 0) (cls cls))
            (if (fx= i len)
                cls
                (lp (fx+ i 1) (p (vector-ref v i) cls)))))))
    (define conflicts
      (lambda (x y cls)
        (if (import-interface? x)
            (let ((x.iface (import-interface-interface x))
                  (x.new-marks (import-interface-new-marks x)))
              (if (import-interface? y)
                  (let ((y.iface (import-interface-interface y))
                        (y.new-marks (import-interface-new-marks y)))
                    (let ((xe (interface-exports x.iface)) (ye (interface-exports y.iface)))
                      (if (fx> (vector-length xe) (vector-length ye))
                          (vfold ye
                            (lambda (id cls)
                              (id-iface-conflicts id y.new-marks x.iface x.new-marks cls)) cls)
                          (vfold xe
                            (lambda (id cls)
                              (id-iface-conflicts id x.new-marks y.iface y.new-marks cls)) cls))))
                  (id-iface-conflicts y '() x.iface x.new-marks cls)))
            (if (import-interface? y)
                (let ((y.iface (import-interface-interface y))
                      (y.new-marks (import-interface-new-marks y)))
                  (id-iface-conflicts x '() y.iface y.new-marks cls))
                (if (bound-id=? x y) (cons x cls) cls)))))
     (define id-iface-conflicts
       (lambda (id id.new-marks iface iface.new-marks cls)
         (let ((id.sym (id-sym-name id))
               (id.marks (join-marks id.new-marks (id-marks id))))
           (cond
             ((interface-token iface) =>
              (lambda (token)
                (if (lookup-import-binding-name id.sym id.marks token iface.new-marks)
                    (cons id cls)
                    cls)))
             (else
              (vfold (interface-exports iface)
                     (lambda (*id cls)
                       (let ((*id.sym (id-sym-name *id))
                             (*id.marks (join-marks iface.new-marks (id-marks *id))))
                         (if (help-bound-id=? *id.sym *id.marks id.sym id.marks)
                             (cons *id cls)
                             cls)))
                     cls))))))
     (unless (null? ls)
       (let lp ((x (car ls)) (ls (cdr ls)) (cls '()))
         (if (null? ls)
             (unless (null? cls)
               (let ((cls (syntax-object->datum cls)))
                 (syntax-error source-exp "duplicate definition for "
                  (symbol->string (car cls))
                   " in")))
             (let lp2 ((ls2 ls) (cls cls))
               (if (null? ls2)
                   (lp (car ls) (cdr ls) cls)
                   (lp2 (cdr ls2) (conflicts x (car ls2) cls)))))))))

(define chi-external
  (lambda (ribcage source-exp body r mr ctem exports fexports meta-residualize!)
    (define return
      (lambda (r mr bindings ids inits)
        (check-defined-ids source-exp ids)
        (check-module-exports source-exp fexports ids)
        (values r mr bindings inits)))
    (define get-implicit-exports
      (lambda (id)
        (let f ((exports exports))
          (if (null? exports)
              '()
              (if (and (pair? (car exports)) (bound-id=? id (caar exports)))
                  (flatten-exports (cdar exports))
                  (f (cdr exports)))))))
    (define update-imp-exports
      (lambda (bindings exports)
        (let ((exports (map (lambda (x) (if (pair? x) (car x) x)) exports)))
          (map (lambda (b)
                 (let ((id (module-binding-id b)))
                   (if (not (bound-id-member? id exports))
                       b
                       (create-module-binding
                         (module-binding-type b)
                         id
                         (module-binding-label b)
                         (append (get-implicit-exports id) (module-binding-imps b))
                         (module-binding-val b)))))
               bindings))))
    (let parse ((body body) (r r) (mr mr) (ids '()) (bindings '()) (inits '()) (meta-seen? #f))
      (if (null? body)
          (return r mr bindings ids inits)
          (let* ((fr (car body)) (e (frob-e fr)) (meta? (frob-meta? fr)))
            (let-values (((type value e w ae) (syntax-type e r empty-wrap no-source ribcage)))
              (case type
                ((define-form)
                 (let-values (((id rhs w) (parse-define e w ae)))
                   (let* ((id (wrap id w))
                          (label (gen-indirect-label))
                          (imps (get-implicit-exports id)))
                     (extend-ribcage! ribcage id label)
                     (cond
                       (meta?
                        (let* ((sym (generate-id (id-sym-name id)))
                               (b (make-binding 'meta-variable sym)))
                         ; add meta bindings only to meta environment
                          (let ((mr (extend-env (get-indirect-label label) b mr)))
                            (let ((exp (chi rhs mr mr w #t)))
                              (define-top-level-value-hook sym (top-level-eval-hook exp))
                              (meta-residualize!
                                (ct-eval/residualize3 ctem
                                  void
                                  (lambda () (build-global-definition no-source sym exp))))
                              (parse (cdr body) r mr
                                (cons id ids)
                                (cons (create-module-binding 'ctdefine-form id label imps b) bindings)
                                inits
                                #f)))))
                       (else
                        (parse (cdr body) r mr
                          (cons id ids)
                          (cons (create-module-binding type id label
                                  imps (make-frob (wrap rhs w) meta?))
                                bindings)
                          inits
                          #f))))))
                ((define-syntax-form)
                 (let-values (((id rhs w) (parse-define-syntax e w ae)))
                   (let* ((id (wrap id w))
                          (label (gen-indirect-label))
                          (imps (get-implicit-exports id))
                          (exp (chi rhs mr mr w #t)))
                     (extend-ribcage! ribcage id label)
                     (let ((l (get-indirect-label label)) (b (defer-or-eval-transformer top-level-eval-hook exp)))
                       (parse (cdr body)
                         (extend-env l b r)
                         (extend-env l b mr)
                         (cons id ids)
                         (cons (create-module-binding type id label imps (cons b exp))
                               bindings)
                         inits
                         #f)))))
                (($module-form)
                 (let* ((*ribcage (make-empty-ribcage))
                        (*w (make-wrap (wrap-marks w) (cons *ribcage (wrap-subst w)))))
                   (let-values (((orig id *exports forms) (parse-module e w ae *w)))
                     (let-values (((r mr *bindings *inits)
                                   (chi-external *ribcage orig
                                     (map (lambda (d) (make-frob d meta?)) forms)
                                     r mr ctem *exports (flatten-exports *exports) meta-residualize!)))
                       (let ((iface (make-unresolved-interface id *exports))
                             (bindings (append *bindings bindings))
                             (inits (append inits *inits))
                             (label (gen-indirect-label))
                             (imps (get-implicit-exports id)))
                         (extend-ribcage! ribcage id label)
                         (let ((l (get-indirect-label label)) (b (make-binding '$module iface)))
                           (parse (cdr body)
                             (extend-env l b r)
                             (extend-env l b mr)
                             (cons id ids)
                             (cons (create-module-binding type id label imps *exports) bindings)
                             inits
                             #f)))))))
               (($import-form)
                (let-values (((orig only? mid) (parse-import e w ae)))
                  (let ((mlabel (id-var-name mid empty-wrap)))
                    (let ((binding (lookup mlabel r)))
                      (case (binding-type binding)
                        (($module)
                         (let* ((iface (binding-value binding))
                                (import-iface (make-import-interface iface (import-mark-delta mid iface))))
                           (when only? (extend-ribcage-barrier! ribcage mid))
                           (do-import! import-iface ribcage)
                           (parse (cdr body) r mr
                             (cons import-iface ids)
                             (update-imp-exports bindings (vector->list (interface-exports iface)))
                             inits
                             #f)))
                        ((displaced-lexical) (displaced-lexical-error mid))
                        (else (syntax-error mid "unknown module")))))))
               ((alias-form)
                (let-values (((new-id old-id) (parse-alias e w ae)))
                  (let* ((new-id (wrap new-id w))
                         (label (id-var-name-loc old-id w))
                         (imps (get-implicit-exports new-id)))
                    (extend-ribcage! ribcage new-id label)
                    (parse (cdr body) r mr
                      (cons new-id ids)
                      (cons (create-module-binding type new-id label imps #f)
                            bindings)
                      inits
                      #f))))
                ((begin-form)
                 (parse (let f ((forms (parse-begin e w ae #t)))
                          (if (null? forms)
                              (cdr body)
                              (cons (make-frob (wrap (car forms) w) meta?)
                                    (f (cdr forms)))))
                   r mr ids bindings inits #f))
                ((eval-when-form)
                 (let-values (((when-list forms) (parse-eval-when e w ae)))
                    (parse (if (memq 'eval when-list) ; mode set is implicitly (E)
                               (let f ((forms forms))
                                 (if (null? forms)
                                     (cdr body)
                                     (cons (make-frob (wrap (car forms) w) meta?)
                                           (f (cdr forms)))))
                               (cdr body))
                      r mr ids bindings inits #f)))
                ((meta-form)
                 (parse (cons (make-frob (wrap (parse-meta e w ae) w) #t)
                              (cdr body))
                   r mr ids bindings inits #t))
                ((local-syntax-form)
                 (let-values (((forms r mr w ae) (chi-local-syntax value e r mr w ae)))
                   (parse (let f ((forms forms))
                            (if (null? forms)
                                (cdr body)
                                (cons (make-frob (wrap (car forms) w) meta?)
                                      (f (cdr forms)))))
                     r mr ids bindings inits #f)))
                (else ; found an init expression
                 (when meta-seen? (syntax-error (source-wrap e w ae) "invalid meta definition"))
                 (let f ((body (cons (make-frob (source-wrap e w ae) meta?) (cdr body))))
                   (if (or (null? body) (not (frob-meta? (car body))))
                       (return r mr bindings ids (append inits body))
                       (begin
                        ; expand and eval meta inits for effect only
                         (let ((x (chi-meta-frob (car body) mr)))
                           (top-level-eval-hook x)
                           (meta-residualize! (ct-eval/residualize3 ctem void (lambda () x))))
                         (f (cdr body)))))))))))))

(define vmap
  (lambda (fn v)
    (do ((i (fx- (vector-length v) 1) (fx- i 1))
         (ls '() (cons (fn (vector-ref v i)) ls)))
        ((fx< i 0) ls))))

(define vfor-each
  (lambda (fn v)
    (let ((len (vector-length v)))
      (do ((i 0 (fx+ i 1)))
          ((fx= i len))
        (fn (vector-ref v i))))))

(define do-top-import
  (lambda (import-only? top-ribcage mid token)
   ; silently treat import-only like regular import at top level
    (build-cte-install mid
      (build-data no-source
        (make-binding 'do-import token))
      (top-ribcage-key top-ribcage))))

(define update-mode-set
  (let ((table
         '((L (load . L) (compile . C) (visit . V) (revisit . R) (eval . -))
           (C (load . -) (compile . -) (visit . -) (revisit . -) (eval . C))
           (V (load . V) (compile . C) (visit . V) (revisit . -) (eval . -))
           (R (load . R) (compile . C) (visit . -) (revisit . R) (eval . -))
           (E (load . -) (compile . -) (visit . -) (revisit . -) (eval . E)))))
    (lambda (when-list mode-set)
      (define remq
        (lambda (x ls)
          (if (null? ls)
              '()
              (if (eq? (car ls) x)
                  (remq x (cdr ls))
                  (cons (car ls) (remq x (cdr ls)))))))
      (remq '-
        (apply append
          (map (lambda (m)
                 (let ((row (cdr (assq m table))))
                   (map (lambda (s) (cdr (assq s row)))
                        when-list)))
               mode-set))))))

(define initial-mode-set
  (lambda (when-list compiling-a-file)
    (apply append
      (map (lambda (s)
             (if compiling-a-file
                 (case s
                   ((compile) '(C))
                   ((load) '(L))
                   ((visit) '(V))
                   ((revisit) '(R))
                   (else '()))
                 (case s
                   ((eval) '(E))
                   (else '()))))
           when-list))))

(define rt-eval/residualize
  (lambda (rtem thunk)
    (if (memq 'E rtem)
        (thunk)
        (let ((thunk (if (memq 'C rtem)
                         (let ((x (thunk)))
                           (top-level-eval-hook x)
                           (lambda () x))
                         thunk)))
          (if (memq 'V rtem)
              (if (or (memq 'L rtem) (memq 'R rtem))
                  (thunk) ; visit-revisit
                  (build-visit-only (thunk)))
              (if (or (memq 'L rtem) (memq 'R rtem))
                  (build-revisit-only (thunk))
                  (chi-void)))))))

(define ct-eval/residualize2
  (lambda (ctem thunk)
    (let ((t #f))
      (ct-eval/residualize3 ctem
        (lambda ()
          (unless t (set! t (thunk)))
          (top-level-eval-hook t))
        (lambda () (or t (thunk)))))))
(define ct-eval/residualize3
  (lambda (ctem eval-thunk residualize-thunk)
    (if (memq 'E ctem)
        (begin (eval-thunk) (chi-void))
        (begin
          (when (memq 'C ctem) (eval-thunk))
          (if (memq 'R ctem)
              (if (or (memq 'L ctem) (memq 'V ctem))
                  (residualize-thunk) ; visit-revisit
                  (build-revisit-only (residualize-thunk)))
              (if (or (memq 'L ctem) (memq 'V ctem))
                  (build-visit-only (residualize-thunk))
                  (chi-void)))))))

(define chi-frobs
  (lambda (frob* r mr m?)
    (map (lambda (x) (chi (frob-e x) r mr empty-wrap m?)) frob*)))

(define chi-meta-frob
  (lambda (x mr)
    (chi (frob-e x) mr mr empty-wrap #t)))

(define chi-sequence
  (lambda (body r mr w ae m?)
    (build-sequence ae
      (let dobody ((body body))
        (if (null? body)
            '()
            (let ((first (chi (car body) r mr w m?)))
              (cons first (dobody (cdr body)))))))))

(define chi
  (lambda (e r mr w m?)
    (let-values (((type value e w ae) (syntax-type e r w no-source #f)))
      (chi-expr type value e r mr w ae m?))))

(define chi-expr
  (lambda (type value e r mr w ae m?)
    (case type
      ((lexical)
       (build-lexical-reference 'value ae value))
      ((core) (value e r mr w ae m?))
      ((lexical-call)
       (chi-application
         (build-lexical-reference 'fun
           (let ((x (car e)))
             (if (syntax-object? x) (syntax-object-expression x) x))
           value)
         e r mr w ae m?))
      ((constant) (build-data ae (strip (source-wrap e w ae) empty-wrap)))
      ((global) (build-global-reference ae value))
      ((meta-variable)
       (if m?
           (build-global-reference ae value)
           (displaced-lexical-error (source-wrap e w ae))))
      ((call) (chi-application (chi (car e) r mr w m?) e r mr w ae m?))
      ((begin-form) (chi-sequence (parse-begin e w ae #f) r mr w ae m?))
      ((local-syntax-form)
       (let-values (((forms r mr w ae) (chi-local-syntax value e r mr w ae)))
         (chi-sequence forms r mr w ae m?)))
      ((eval-when-form)
       (let-values (((when-list forms) (parse-eval-when e w ae)))
         (if (memq 'eval when-list) ; mode set is implicitly (E)
             (chi-sequence forms r mr w ae m?)
             (chi-void))))
      ((meta-form)
       (syntax-error (source-wrap e w ae) "invalid context for meta definition"))
      ((define-form)
       (parse-define e w ae)
       (syntax-error (source-wrap e w ae) "invalid context for definition"))
      ((define-syntax-form)
       (parse-define-syntax e w ae)
       (syntax-error (source-wrap e w ae) "invalid context for definition"))
      (($module-form)
       (let-values (((orig id exports forms) (parse-module e w ae w)))
         (syntax-error orig "invalid context for definition")))
      (($import-form)
       (let-values (((orig only? mid) (parse-import e w ae)))
         (syntax-error orig "invalid context for definition")))
      ((alias-form)
       (parse-alias e w ae)
       (syntax-error (source-wrap e w ae) "invalid context for definition"))
      ((syntax)
       (syntax-error (source-wrap e w ae)
         "reference to pattern variable outside syntax form"))
      ((displaced-lexical) (displaced-lexical-error (source-wrap e w ae)))
      (else (syntax-error (source-wrap e w ae))))))

(define chi-application
  (lambda (x e r mr w ae m?)
    (syntax-case e ()
      ((e0 e1 ...)
       (build-application ae x
         (map (lambda (e) (chi e r mr w m?)) (syntax (e1 ...)))))
      (_ (syntax-error (source-wrap e w ae))))))

(define chi-set!
  (lambda (e r w ae rib)
    (syntax-case e ()
      ((_ id val)
       (id? (syntax id))
       (let ((n (id-var-name (syntax id) w)))
         (let ((b (lookup n r)))
           (case (binding-type b)
             ((macro!)
              (let ((id (wrap (syntax id) w)) (val (wrap (syntax val) w)))
                (syntax-type (chi-macro (binding-value b)
                               `(,(syntax set!) ,id ,val)
                               r empty-wrap #f rib) r empty-wrap #f rib)))
             (else
              (values 'core
                (lambda (e r mr w ae m?)
                 ; repeat lookup in case we were first expression (init) in
                 ; module or lambda body.  we repeat id-var-name as well,
                 ; although this is only necessary if we allow inits to
                 ; preced definitions
                  (let ((val (chi (syntax val) r mr w m?))
                        (n (id-var-name (syntax id) w)))
                    (let ((b (lookup n r)))
                      (case (binding-type b)
                        ((lexical) (build-lexical-assignment ae (binding-value b) val))
                        ((global)
                         (let ((sym (binding-value b)))
                           (when (read-only-binding? n)
                             (syntax-error (source-wrap e w ae)
                               "invalid assignment to read-only variable"))
                           (build-global-assignment ae sym val)))
                        ((meta-variable)
                         (if m?
                             (build-global-assignment ae (binding-value b) val)
                             (displaced-lexical-error (wrap (syntax id) w))))
                        ((displaced-lexical)
                         (displaced-lexical-error (wrap (syntax id) w)))
                        (else (syntax-error (source-wrap e w ae)))))))
                e w ae))))))
      (_ (syntax-error (source-wrap e w ae))))))

(define chi-macro
  (lambda (p e r w ae rib)
    (define rebuild-macro-output
      (lambda (x m)
        (cond ((pair? x)
               (cons (rebuild-macro-output (car x) m)
                     (rebuild-macro-output (cdr x) m)))
              ((syntax-object? x)
               (let ((w (syntax-object-wrap x)))
                 (let ((ms (wrap-marks w)) (s (wrap-subst w)))
                   (make-syntax-object (syntax-object-expression x)
                     (if (and (pair? ms) (eq? (car ms) the-anti-mark))
                         (make-wrap (cdr ms) (cdr s))
                         (make-wrap (cons m ms)
                           (if rib
                               (cons rib (cons 'shift s))
                               (cons 'shift s))))))))
              ((vector? x)
               (let* ((n (vector-length x)) (v (make-vector n)))
                 (do ((i 0 (fx+ i 1)))
                     ((fx= i n) v)
                     (vector-set! v i
                       (rebuild-macro-output (vector-ref x i) m)))))
              ((symbol? x)
               (syntax-error (source-wrap e w ae)
                 "encountered raw symbol "
                (symbol->string x)
                 " in output of macro"))
              (else x))))
    (rebuild-macro-output
      (let ((out (p (source-wrap e (anti-mark w) ae))))
        (if (procedure? out)
            (out (lambda (id)
                   (unless (identifier? id)
                     (syntax-error id
                       "environment argument is not an identifier"))
                   (lookup (id-var-name id empty-wrap) r)))
            out))
      (new-mark))))

(define chi-body
  (lambda (body outer-form r mr w m?)
    (let* ((ribcage (make-empty-ribcage))
           (w (make-wrap (wrap-marks w) (cons ribcage (wrap-subst w))))
           (body (map (lambda (x) (make-frob (wrap x w) #f)) body)))
      (let-values (((r mr exprs ids vars vals inits)
                    (chi-internal ribcage outer-form body r mr m?)))
        (when (null? exprs) (syntax-error outer-form "no expressions in body"))
        (build-body no-source
          (reverse vars) (chi-frobs (reverse vals) r mr m?)
          (build-sequence no-source
            (chi-frobs (append inits exprs) r mr m?)))))))

(define chi-internal
  ;; In processing the forms of the body, we create a new, empty wrap.
  ;; This wrap is augmented (destructively) each time we discover that
  ;; the next form is a definition.  This is done:
  ;;
  ;;   (1) to allow the first nondefinition form to be a call to
  ;;       one of the defined ids even if the id previously denoted a
  ;;       definition keyword or keyword for a macro expanding into a
  ;;       definition;
  ;;   (2) to prevent subsequent definition forms (but unfortunately
  ;;       not earlier ones) and the first nondefinition form from
  ;;       confusing one of the bound identifiers for an auxiliary
  ;;       keyword; and
  ;;   (3) so that we do not need to restart the expansion of the
  ;;       first nondefinition form, which is problematic anyway
  ;;       since it might be the first element of a begin that we
  ;;       have just spliced into the body (meaning if we restarted,
  ;;       we'd really need to restart with the begin or the macro
  ;;       call that expanded into the begin, and we'd have to give
  ;;       up allowing (begin <defn>+ <expr>+), which is itself
  ;;       problematic since we don't know if a begin contains only
  ;;       definitions until we've expanded it).
  ;;
  ;; Subforms of a begin, let-syntax, or letrec-syntax are spliced
  ;; into the body.
  ;;
  ;; outer-form is fully wrapped w/source
  (lambda (ribcage source-exp body r mr m?)
    (define return
      (lambda (r mr exprs ids vars vals inits)
        (check-defined-ids source-exp ids)
        (values r mr exprs ids vars vals inits)))
    (let parse ((body body) (r r) (mr mr) (ids '()) (vars '()) (vals '()) (inits '()) (meta-seen? #f))
      (if (null? body)
          (return r mr body ids vars vals inits)
          (let* ((fr (car body)) (e (frob-e fr)) (meta? (frob-meta? fr)))
            (let-values (((type value e w ae) (syntax-type e r empty-wrap no-source ribcage)))
              (case type
                ((define-form)
                 (let-values (((id rhs w) (parse-define e w ae)))
                   (let ((id (wrap id w)) (label (gen-label)))
                     (cond
                       (meta?
                        (let ((sym (generate-id (id-sym-name id))))
                          (extend-ribcage! ribcage id label)
                         ; add meta bindings only to meta environment
                         ; so visible only to next higher level and beyond
                          (let ((mr (extend-env label (make-binding 'meta-variable sym) mr)))
                            (define-top-level-value-hook sym
                              (top-level-eval-hook (chi rhs mr mr w #t)))
                            (parse (cdr body) r mr (cons id ids) vars vals inits #f))))
                       (else
                        (let ((var (gen-var id)))
                          (extend-ribcage! ribcage id label)
                         ; add lexical bindings only to run-time environment
                          (parse (cdr body)
                            (extend-env label (make-binding 'lexical var) r)
                            mr
                            (cons id ids)
                            (cons var vars)
                            (cons (make-frob (wrap rhs w) meta?) vals)
                            inits
                            #f)))))))
                ((define-syntax-form)
                 (let-values (((id rhs w) (parse-define-syntax e w ae)))
                   (let ((id (wrap id w))
                         (label (gen-label))
                         (exp (chi rhs mr mr w #t)))
                     (extend-ribcage! ribcage id label)
                     (let ((b (defer-or-eval-transformer local-eval-hook exp)))
                       (parse (cdr body)
                         (extend-env label b r) (extend-env label b mr)
                         (cons id ids) vars vals inits #f)))))
                (($module-form)
                 (let* ((*ribcage (make-empty-ribcage))
                        (*w (make-wrap (wrap-marks w) (cons *ribcage (wrap-subst w)))))
                   (let-values (((orig id exports forms) (parse-module e w ae *w)))
                     (let-values (((r mr *body *ids *vars *vals *inits)
                                   (chi-internal *ribcage orig
                                     (map (lambda (d) (make-frob d meta?)) forms)
                                     r mr m?)))
                      ; valid bound ids checked already by chi-internal
                       (check-module-exports source-exp (flatten-exports exports) *ids)
                       (let ((iface (make-resolved-interface id exports #f))
                             (vars (append *vars vars))
                             (vals (append *vals vals))
                             (inits (append inits *inits *body))
                             (label (gen-label)))
                         (extend-ribcage! ribcage id label)
                         (let ((b (make-binding '$module iface)))
                           (parse (cdr body)
                             (extend-env label b r) (extend-env label b mr)
                             (cons id ids) vars vals inits #f)))))))
               (($import-form)
                (let-values (((orig only? mid) (parse-import e w ae)))
                  (let ((mlabel (id-var-name mid empty-wrap)))
                    (let ((binding (lookup mlabel r)))
                      (case (binding-type binding)
                        (($module)
                         (let* ((iface (binding-value binding))
                                (import-iface (make-import-interface iface (import-mark-delta mid iface))))
                           (when only? (extend-ribcage-barrier! ribcage mid))
                           (do-import! import-iface ribcage)
                           (parse (cdr body) r mr (cons import-iface ids) vars vals inits #f)))
                        ((displaced-lexical) (displaced-lexical-error mid))
                        (else (syntax-error mid "unknown module")))))))
                ((alias-form)
                 (let-values (((new-id old-id) (parse-alias e w ae)))
                   (let ((new-id (wrap new-id w)))
                     (extend-ribcage! ribcage new-id (id-var-name-loc old-id w))
                     (parse (cdr body) r mr
                       (cons new-id ids)
                       vars
                       vals
                       inits
                       #f))))
                ((begin-form)
                 (parse (let f ((forms (parse-begin e w ae #t)))
                          (if (null? forms)
                              (cdr body)
                              (cons (make-frob (wrap (car forms) w) meta?)
                                    (f (cdr forms)))))
                   r mr ids vars vals inits #f))
                ((eval-when-form)
                 (let-values (((when-list forms) (parse-eval-when e w ae)))
                   (parse (if (memq 'eval when-list) ; mode set is implicitly (E)
                              (let f ((forms forms))
                                (if (null? forms)
                                    (cdr body)
                                    (cons (make-frob (wrap (car forms) w) meta?)
                                          (f (cdr forms)))))
                              (cdr body))
                     r mr ids vars vals inits #f)))
                ((meta-form)
                 (parse (cons (make-frob (wrap (parse-meta e w ae) w) #t)
                              (cdr body))
                   r mr ids vars vals inits #t))
                ((local-syntax-form)
                 (let-values (((forms r mr w ae) (chi-local-syntax value e r mr w ae)))
                   (parse (let f ((forms forms))
                            (if (null? forms)
                                (cdr body)
                                (cons (make-frob (wrap (car forms) w) meta?)
                                      (f (cdr forms)))))
                     r mr ids vars vals inits #f)))
                (else ; found a non-definition
                 (when meta-seen? (syntax-error (source-wrap e w ae) "invalid meta definition"))
                 (let f ((body (cons (make-frob (source-wrap e w ae) meta?) (cdr body))))
                   (if (or (null? body) (not (frob-meta? (car body))))
                       (return r mr body ids vars vals inits)
                       (begin
                        ; expand meta inits for effect only
                         (top-level-eval-hook (chi-meta-frob (car body) mr))
                         (f (cdr body)))))))))))))

(define import-mark-delta
 ; returns list of marks layered on top of module id beyond those
 ; cached in the interface
  (lambda (mid iface)
    (diff-marks (id-marks mid) (interface-marks iface))))

(define lookup-import-label
  (lambda (id)
    (let ((label (id-var-name-loc id empty-wrap)))
      (unless label
        (syntax-error id "exported identifier not visible"))
      label)))
  
(define do-import!
  (lambda (import-iface ribcage)
    (let ((ie (interface-exports (import-interface-interface import-iface))))
      (if (<= (vector-length ie) 20)
          (let ((new-marks (import-interface-new-marks import-iface)))
            (vfor-each
              (lambda (id)
                (import-extend-ribcage! ribcage new-marks id
                  (lookup-import-label id)))
              ie))
          (extend-ribcage-subst! ribcage import-iface)))))

(define parse-module
  (lambda (e w ae *w)
    (define listify
      (lambda (exports)
        (if (null? exports)
            '()
            (cons (syntax-case (car exports) ()
                    ((ex ...) (listify (syntax (ex ...))))
                    (x (if (id? (syntax x))
                           (wrap (syntax x) *w)
                           (syntax-error (source-wrap e w ae)
                             "invalid exports list in"))))
                  (listify (cdr exports))))))
    (syntax-case e ()
      ((_ orig mid (ex ...) form ...)
       (id? (syntax mid))
      ; id receives old wrap so it won't be confused with id of same name
      ; defined within the module
       (values (syntax orig) (wrap (syntax mid) w) (listify (syntax (ex ...))) (map (lambda (x) (wrap x *w)) (syntax (form ...)))))
      (_ (syntax-error (source-wrap e w ae))))))

(define parse-import
  (lambda (e w ae)
    (syntax-case e ()
      ((_ orig #t mid)
       (id? (syntax mid))
       (values (syntax orig) #t (wrap (syntax mid) w)))
      ((_ orig #f mid)
       (id? (syntax mid))
       (values (syntax orig) #f (wrap (syntax mid) w)))
      (_ (syntax-error (source-wrap e w ae))))))

(define parse-define
  (lambda (e w ae)
    (syntax-case e ()
      ((_ name val)
       (id? (syntax name))
       (values (syntax name) (syntax val) w))
      ((_ (name . args) e1 e2 ...)
       (id? (syntax name))
       (values (wrap (syntax name) w)
               (cons (syntax lambda) (wrap (syntax (args e1 e2 ...)) w))
               empty-wrap))
      ((_ name)
       (id? (syntax name))
       (values (wrap (syntax name) w) (syntax (void)) empty-wrap))
      (_ (syntax-error (source-wrap e w ae))))))

(define parse-define-syntax
  (lambda (e w ae)
    (syntax-case e ()
      ((_ (name id) e1 e2 ...)
       (and (id? (syntax name)) (id? (syntax id)))
       (values (wrap (syntax name) w)
               `(,(syntax lambda) ,(wrap (syntax (id)) w)
                   ,@(wrap (syntax (e1 e2 ...)) w))
               empty-wrap))
      ((_ name val)
       (id? (syntax name))
       (values (syntax name) (syntax val) w))
      (_ (syntax-error (source-wrap e w ae))))))

(define parse-meta
  (lambda (e w ae)
    (syntax-case e ()
      ((_ . form) (syntax form))
      (_ (syntax-error (source-wrap e w ae))))))

(define parse-eval-when
  (lambda (e w ae)
    (syntax-case e ()
      ((_ (x ...) e1 e2 ...)
       (values (chi-when-list (syntax (x ...)) w) (syntax (e1 e2 ...))))
      (_ (syntax-error (source-wrap e w ae))))))

(define parse-alias
  (lambda (e w ae)
    (syntax-case e ()
      ((_ new-id old-id)
       (and (id? (syntax new-id)) (id? (syntax old-id)))
       (values (syntax new-id) (syntax old-id)))
      (_ (syntax-error (source-wrap e w ae))))))

(define parse-begin
  (lambda (e w ae empty-okay?)
    (syntax-case e ()
      ((_) empty-okay? '())
      ((_ e1 e2 ...) (syntax (e1 e2 ...)))
      (_ (syntax-error (source-wrap e w ae))))))

(define chi-lambda-clause
  (lambda (e c r mr w m?)

    (define reverse*
      (lambda (l)
        (let f ((ls1 (cdr l)) (ls2 (car l)))
          (if (null? ls1)
              ls2
              (f (cdr ls1) (cons (car ls1) ls2))))))

    (define ids/emitter
      (lambda (formals ids emitter ae template)
        (cond ((null? ids)
               (values (reverse formals) emitter))
              ((syntax-object? (car ids))
               (ids/emitter formals (cons (syntax-object->datum (car ids)) (cdr ids)) emitter ae (car ids)))
              ((annotation? (car ids))
               (ids/emitter formals (cons (unannotate (car ids)) (cdr ids)) emitter (car ids) template))
              ((eq? (car ids) '#!key)
               (ids/emitter formals (cdr ids) 'keyword ae #f))
              ((memq (car ids) '(#!optional #!rest))
               (ids/emitter formals (cdr ids) (or (and (eq? emitter 'rnrs) 'optional/rest) emitter) ae #f))
              ((pair? (car ids))
               (ids/emitter formals (cons (car (car ids)) (cdr ids)) emitter ae
                            (if template 
                                (make-syntax-object (car (unannotate (syntax-object-expression template)))
                                                    (syntax-object-wrap template))
                                #f)))
              (else
               (ids/emitter (cons (cond (template (datum->syntax-object template (car ids)))
                                        (ae (build-source ae (car ids)))
                                        (else (build-source no-source (car ids)))) formals)
                            (cdr ids) emitter ae #f)))))

    (define emit-formals
      (lambda (formals* formals vars emitter ae template)
        (define formal
          (lambda ()
            (case emitter
              ((optional/rest) vars)
              ((rnrs keyword) formals))))
        (cond ((null? formals) (reverse formals*))

               ((syntax-object? formals)
                (emit-formals formals* (syntax-object->datum formals) vars emitter ae formals))
              
               ((id? formals)
                (reverse* (cons (formal) formals*)))
              
               ((annotation? formals)
                (emit-formals formals* (unannotate formals) vars emitter ae template))
              
               ((annotation? (car formals))
                (emit-formals formals* (cons (unannotate (car formals)) (cdr formals)) vars emitter (car formals) template))

               ((syntax-object? (car formals))
                (emit-formals formals* (cons (syntax-object->datum (car formals)) (cdr formals)) vars emitter ae (car formals)))

               ((memq (car formals) '(#!optional #!rest #!key))
                (emit-formals (cons (build-source ae (car formals)) formals*) (cdr formals) vars emitter ae template))
              
               ((pair? (car formals))
                (emit-formals (cons (cons (car (case emitter
                                                 ((keyword) (car (formal)))
                                                 ((optional/rest) (formal))))
                                          (unannotate (chi (cdr (car formals)) r mr w m?)))
                                    formals*) (cdr formals) (cdr vars) emitter ae template))

               ((id? (car formals))
                (emit-formals (cons (car (formal)) formals*) (cdr (syntax-object->datum formals)) (cdr vars) emitter ae template))

               (else (error `(unexpected-formal ,(car formals)))))))

      (syntax-case c ()
        (((id ...) e1 e2 ...)
         (let ((formals (syntax (id ...))))
           (let-values (((ids emitter) (ids/emitter '() formals 'rnrs #f #f)))
             (if (not (valid-bound-ids? ids))
                 (syntax-error e "invalid parameter list in")
                 (let ((labels (gen-labels ids))
                       (new-vars (map (lambda (id) (build-source id (gen-var id))) ids)))
                   (values
                    emitter
                    (and (eq? emitter 'keyword)
                         (gen-var 'dsssl-args))
                    (build-source formals new-vars)
                    (emit-formals '() formals new-vars emitter #f #f)
                    (map syntax-object->datum ids)
                    (chi-body (syntax (e1 e2 ...))
                              e
                              (extend-var-env* labels new-vars r)
                              mr
                              (make-binding-wrap ids labels w)
                              m?)))))))
        ((ids e1 e2 ...)
         (let ((formals (syntax ids)))
           (let-values (((old-ids emitter) (ids/emitter '() (lambda-var-list formals) 'rnrs #f #f)))
             (if (not (valid-bound-ids? old-ids))
                 (syntax-error e "invalid parameter list in")
                 (let ((labels (gen-labels old-ids))
                       (new-vars (map (lambda (id) (build-source id (gen-var id))) old-ids)))
                   (values
                    emitter
                    (and (eq? emitter 'keyword)
                         (gen-var 'dsssl-args))
                    (let ((vars (if (eq? emitter 'rnrs)
                                    (reverse* new-vars)
                                    (reverse new-vars))))
                      (if (or (pair? vars)
                              (null? vars))
                          (build-source old-ids vars)
                          vars))
                    (emit-formals '() formals (reverse* new-vars) emitter #f #f)
                    (reverse (map syntax-object->datum old-ids))
                    (chi-body (syntax (e1 e2 ...))
                              e
                              (extend-var-env* labels new-vars r)
                              mr
                              (make-binding-wrap old-ids labels w)
                              m?)))))))
        (_ (syntax-error e)))))

(define chi-local-syntax
  (lambda (rec? e r mr w ae)
    (syntax-case e ()
      ((_ ((id val) ...) e1 e2 ...)
       (let ((ids (syntax (id ...))))
         (if (not (valid-bound-ids? ids))
             (invalid-ids-error (map (lambda (x) (wrap x w)) ids)
                                (source-wrap e w ae)
                                "keyword")
             (let ((labels (gen-labels ids)))
               (let ((new-w (make-binding-wrap ids labels w)))
                 (let ((b* (let ((w (if rec? new-w w)))
                             (map (lambda (x)
                                    (defer-or-eval-transformer
                                      local-eval-hook
                                      (chi x mr mr w #t)))
                                  (syntax (val ...))))))
                   (values
                    (syntax (e1 e2 ...))
                    (extend-env* labels b* r)
                    (extend-env* labels b* mr)
                    new-w
                    ae)))))))
      (_ (syntax-error (source-wrap e w ae))))))

(define chi-void
  (lambda ()
    (build-application no-source (build-primref no-source 'void) '())))

(define ellipsis?
  (lambda (x)
    (and (nonsymbol-id? x)
         (literal-id=? x (syntax (... ...))))))

;;; data

;;; strips all annotations from potentially circular reader output.

(define strip-annotation
  (lambda (x)
    (cond
      ((pair? x)
       (cons (strip-annotation (car x))
             (strip-annotation (cdr x))))
      ((annotation? x) (annotation-stripped x))
      (else x))))

;;; strips syntax-objects down to top-wrap; if top-wrap is layered directly
;;; on an annotation, strips the annotation as well.
;;; since only the head of a list is annotated by the reader, not each pair
;;; in the spine, we also check for pairs whose cars are annotated in case
;;; we've been passed the cdr of an annotated list

(define strip*
  (lambda (x w fn)
    (if (top-marked? w)
        (fn x)
        (let f ((x x))
          (cond
            ((syntax-object? x)
             (strip* (syntax-object-expression x) (syntax-object-wrap x) fn))
            ((pair? x)
             (let ((a (f (car x))) (d (f (cdr x))))
               (if (and (eq? a (car x)) (eq? d (cdr x)))
                   x
                   (cons a d))))
            ((vector? x)
             (let ((old (vector->list x)))
                (let ((new (map f old)))
                   (if (andmap eq? old new) x (list->vector new)))))
            (else x))))))

(define strip
  (lambda (x w)
    (strip* x w
      (lambda (x)
        (if (or (annotation? x) (and (pair? x) (annotation? (car x))))
            (strip-annotation x)
            x)))))

;;; lexical variables

(define gen-var
  (lambda (id)
    (let ((id (if (syntax-object? id) (syntax-object-expression id) id)))
      (if (annotation? id)
          (build-lexical-var id (annotation-expression id))
          (build-lexical-var id id)))))

(define lambda-var-list
  (lambda (vars)
    (let lvl ((vars vars) (ls '()) (w empty-wrap))
       (cond
         ((pair? vars) (lvl (cdr vars) (cons (wrap (car vars) w) ls) w))
         ((id? vars) (cons (wrap vars w) ls))
         ((null? vars) ls)
         ((syntax-object? vars)
          (lvl (syntax-object-expression vars)
               ls
               (join-wraps w (syntax-object-wrap vars))))
         ((annotation? vars)
          (lvl (annotation-expression vars) ls w))
       ; include anything else to be caught by subsequent error
       ; checking
         (else (cons vars ls))))))


; must precede global-extends

(set! $sc-put-cte
  (lambda (id b top-token)
     (define sc-put-module
       (lambda (exports token new-marks)
         (vfor-each
           (lambda (id) (store-import-binding id token new-marks))
           exports)))
     (define (put-cte id binding token)
       (let ((sym (if (symbol? id) id (id-var-name id empty-wrap))))
        (store-import-binding id token '())
         (put-global-definition-hook sym
          ; global binding is assumed; if global pass #f to remove existing binding, if any
           (if (and (eq? (binding-type binding) 'global)
                    (eq? (binding-value binding) sym))
               #f
               binding))))
     (let ((binding (make-transformer-binding b)))
       (case (binding-type binding)
         (($module)
          (let ((iface (binding-value binding)))
            (sc-put-module (interface-exports iface) (interface-token iface) '()))
          (put-cte id binding top-token))
         ((do-alias) (store-import-binding id top-token '()))
         ((do-import)
          ; fake binding: id is module id binding-value is token
          (let ((token (binding-value b)))
             (let ((b (lookup (id-var-name id empty-wrap) null-env)))
               (case (binding-type b)
                 (($module)
                  (let* ((iface (binding-value b))
                         (exports (interface-exports iface)))
                    (unless (eq? (interface-token iface) token)
                      (syntax-error id "import mismatch for module"))
                    (sc-put-module (interface-exports iface) top-token
                      (import-mark-delta id iface))))
                 (else (syntax-error id "unknown module"))))))
         (else (put-cte id binding top-token))))
     ))


;;; core transformers

;*** These special forms are handled by Gambit, so pass them through

(global-extend 'core '##c-define-type
   (lambda (e r mr w ae m?)
     (attach-source ae (strip e w))))

(global-extend 'core '##c-declare
   (lambda (e r mr w ae m?)
     (attach-source ae (strip e w))))

(global-extend 'core '##c-initialize
   (lambda (e r mr w ae m?)
     (attach-source ae (strip e w))))

(global-extend 'core '##c-lambda
   (lambda (e r mr w ae m?)
     (attach-source ae (strip e w))))

(global-extend 'core '##c-define
   (lambda (e r mr w ae m?)
     (attach-source ae (strip e w))))

(global-extend 'core '##define
   (lambda (e r mr w ae m?)
     (attach-source ae (strip e w))))

(global-extend 'core '##define-macro
   (lambda (e r mr w ae m?)
     (attach-source ae (strip e w))))

(global-extend 'core '##define-syntax
   (lambda (e r mr w ae m?)
     (attach-source ae (strip e w))))

(global-extend 'core '##include
   (lambda (e r mr w ae m?)
     (attach-source ae (strip e w))))

(global-extend 'core '##declare
   (lambda (e r mr w ae m?)
     (attach-source ae (strip e w))))

(global-extend 'core '##namespace
   (lambda (e r mr w ae m?)
     (attach-source ae (strip e w))))


(global-extend 'local-syntax 'letrec-syntax #t)
(global-extend 'local-syntax 'let-syntax #f)


(global-extend 'core 'fluid-let-syntax
  (lambda (e r mr w ae m?)
    (syntax-case e ()
      ((_ ((var val) ...) e1 e2 ...)
       (valid-bound-ids? (syntax (var ...)))
       (let ((names (map (lambda (x) (id-var-name x w)) (syntax (var ...)))))
         (for-each
           (lambda (id n)
             (case (binding-type (lookup n r))
               ((displaced-lexical) (displaced-lexical-error (wrap id w)))))
           (syntax (var ...))
           names)
         (let ((b* (map (lambda (x)
                          (defer-or-eval-transformer
                            local-eval-hook
                            (chi x mr mr w #t)))
                        (syntax (val ...)))))
           (chi-body
             (syntax (e1 e2 ...))
             (source-wrap e w ae)
             (extend-env* names b* r)
             (extend-env* names b* mr)
             w
             m?))))
      (_ (syntax-error (source-wrap e w ae))))))

(global-extend 'core 'quote
   (lambda (e r mr w ae m?)
      (syntax-case e ()
         ((_ e) (build-data ae (strip (syntax e) w)))
         (_ (syntax-error (source-wrap e w ae))))))

(global-extend 'core 'syntax
  (let ()
    (define gen-syntax
      (lambda (src e r maps ellipsis? vec?)
        (if (id? e)
            (let ((label (id-var-name e empty-wrap)))
              (let ((b (lookup label r)))
                (if (eq? (binding-type b) 'syntax)
                    (let-values (((var maps)
                                  (let ((var.lev (binding-value b)))
                                    (gen-ref src (car var.lev) (cdr var.lev) maps))))
                      (values `(ref ,var) maps))
                    (if (ellipsis? e)
                        (syntax-error src "misplaced ellipsis in syntax form")
                        (values `(quote ,e) maps)))))
            (syntax-case e ()
              ((dots e)
               (ellipsis? (syntax dots))
               (if vec?
                   (syntax-error src "misplaced ellipsis in syntax template")
                   (gen-syntax src (syntax e) r maps (lambda (x) #f) #f)))
              ((x dots . y)
               ; this could be about a dozen lines of code, except that we
               ; choose to handle (syntax (x ... ...)) forms
               (ellipsis? (syntax dots))
               (let f ((y (syntax y))
                       (k (lambda (maps)
                            (let-values (((x maps)
                                          (gen-syntax src (syntax x) r
                                            (cons '() maps) ellipsis? #f)))
                              (if (null? (car maps))
                                  (syntax-error src
                                    "extra ellipsis in syntax form")
                                  (values (gen-map x (car maps))
                                          (cdr maps)))))))
                 (syntax-case y ()
                   ((dots . y)
                    (ellipsis? (syntax dots))
                    (f (syntax y)
                       (lambda (maps)
                         (let-values (((x maps) (k (cons '() maps))))
                           (if (null? (car maps))
                               (syntax-error src
                                 "extra ellipsis in syntax form")
                               (values (gen-mappend x (car maps))
                                       (cdr maps)))))))
                   (_ (let-values (((y maps) (gen-syntax src y r maps ellipsis? vec?)))
                        (let-values (((x maps) (k maps)))
                          (values (gen-append x y) maps)))))))
              ((x . y)
               (let-values (((xnew maps) (gen-syntax src (syntax x) r maps ellipsis? #f)))
                 (let-values (((ynew maps) (gen-syntax src (syntax y) r maps ellipsis? vec?)))
                   (values (gen-cons e (syntax x) (syntax y) xnew ynew)
                           maps))))
              (#(x1 x2 ...)
               (let ((ls (syntax (x1 x2 ...))))
                 (let-values (((lsnew maps) (gen-syntax src ls r maps ellipsis? #t)))
                   (values (gen-vector e ls lsnew) maps))))
              (_ (values `(quote ,e) maps))))))

    (define gen-ref
      (lambda (src var level maps)
        (if (fx= level 0)
            (values var maps)
            (if (null? maps)
                (syntax-error src "missing ellipsis in syntax form")
                (let-values (((outer-var outer-maps) (gen-ref src var (fx- level 1) (cdr maps))))
                  (let ((b (assq outer-var (car maps))))
                    (if b
                        (values (cdr b) maps)
                        (let ((inner-var (gen-var 'tmp)))
                          (values inner-var
                                  (cons (cons (cons outer-var inner-var)
                                              (car maps))
                                        outer-maps))))))))))

    (define gen-append
      (lambda (x y)
        (if (equal? y '(quote ()))
            x
            `(append ,x ,y))))

    (define gen-mappend
      (lambda (e map-env)
        `(apply (primitive append) ,(gen-map e map-env))))

    (define gen-map
      (lambda (e map-env)
        (let ((formals (map cdr map-env))
              (actuals (map (lambda (x) `(ref ,(car x))) map-env)))
          (cond
            ((eq? (car e) 'ref)
             ; identity map equivalence:
             ; (map (lambda (x) x) y) == y
             (car actuals))
            ((andmap
                (lambda (x) (and (eq? (car x) 'ref) (memq (cadr x) formals)))
                (cdr e))
             ; eta map equivalence:
             ; (map (lambda (x ...) (f x ...)) y ...) == (map f y ...)
             `(map (primitive ,(car e))
                   ,@(map (let ((r (map cons formals actuals)))
                            (lambda (x) (cdr (assq (cadr x) r))))
                          (cdr e))))
            (else `(map (lambda ,formals ,e) ,@actuals))))))

   ; 12/12/00: semantic change: we now return original syntax object (e)
   ; if no pattern variables were found within, to avoid dropping
   ; source annotations prematurely.  the "syntax returns lists" for
   ; lists in its input guarantee counts only for substructure that
   ; contains pattern variables
    (define gen-cons
      (lambda (e x y xnew ynew)
        (case (car ynew)
          ((quote)
           (if (eq? (car xnew) 'quote)
               (let ((xnew (cadr xnew)) (ynew (cadr ynew)))
                 (if (and (eq? xnew x) (eq? ynew y))
                     `',e
                     `'(,xnew . ,ynew)))
               (if (eq? (cadr ynew) '()) `(list ,xnew) `(cons ,xnew ,ynew))))
          ((list) `(list ,xnew ,@(cdr ynew)))
          (else `(cons ,xnew ,ynew)))))

    (define gen-vector
      (lambda (e ls lsnew)
        (cond
          ((eq? (car lsnew) 'quote)
           (if (eq? (cadr lsnew) ls)
               `',e
               `(quote #(,@(cadr lsnew)))))
          ((eq? (car lsnew) 'list) `(vector ,@(cdr lsnew)))
          (else `(list->vector ,lsnew)))))


    (define regen
      (lambda (x)
        (case (car x)
          ((ref) (build-lexical-reference 'value no-source (cadr x)))
          ((primitive) (build-primref no-source (cadr x)))
          ((quote) (build-data no-source (cadr x)))
          ((lambda) (build-lambda no-source (cadr x) (regen (caddr x))))
          ((map) (let ((ls (map regen (cdr x))))
                   (build-application no-source
                     (if (fx= (length ls) 2)
                         (build-primref no-source 'map)
                        ; really need to do our own checking here
                         (build-primref no-source 2 'map)) ; require error check
                     ls)))
          (else (build-application no-source
                  (build-primref no-source (car x))
                  (map regen (cdr x)))))))

    (lambda (e r mr w ae m?)
      (let ((e (source-wrap e w ae)))
        (syntax-case e ()
          ((_ x)
           (let-values (((e maps) (gen-syntax e (syntax x) r '() ellipsis? #f)))
             (regen e)))
          (_ (syntax-error e)))))))


(global-extend 'core 'lambda
  (lambda (e r mr w ae m?)
    (syntax-case e ()
      ((_ . c)
       (let-values (((emitter dsssl-args vars dsssl-formals orig-vars body)
                     (chi-lambda-clause (source-wrap e w ae) (syntax c) r mr w m?)))
         (case emitter
           ((keyword) (build-dsssl-lambda ae dsssl-args vars dsssl-formals orig-vars body))
           ((optional/rest) (build-lambda ae dsssl-formals body))
           ((rnrs) (build-lambda ae vars body))))))))


(global-extend 'core 'letrec
  (lambda (e r mr w ae m?)
    (syntax-case e ()
      ((_ ((id val) ...) e1 e2 ...)
       (let ((ids (syntax (id ...))))
         (if (not (valid-bound-ids? ids))
             (invalid-ids-error (map (lambda (x) (wrap x w)) ids)
               (source-wrap e w ae) "bound variable")
             (let ((labels (gen-labels ids))
                   (new-vars (map gen-var ids)))
               (let ((w (make-binding-wrap ids labels w))
                    (r (extend-var-env* labels new-vars r)))
                 (build-letrec ae
                   new-vars
                   (map (lambda (x) (chi x r mr w m?)) (syntax (val ...)))
                   (chi-body (syntax (e1 e2 ...)) (source-wrap e w ae) r mr w m?)))))))
      (_ (syntax-error (source-wrap e w ae))))))


(global-extend 'core 'if
   (lambda (e r mr w ae m?)
      (syntax-case e ()
         ((_ test then)
          (build-conditional ae
             (chi (syntax test) r mr w m?)
             (chi (syntax then) r mr w m?)
             (chi-void)))
         ((_ test then else)
          (build-conditional ae
             (chi (syntax test) r mr w m?)
             (chi (syntax then) r mr w m?)
             (chi (syntax else) r mr w m?)))
         (_ (syntax-error (source-wrap e w ae))))))



(global-extend 'set! 'set! '())

(global-extend 'alias 'alias '())
(global-extend 'begin 'begin '())

(global-extend '$module-key '$module '())
(global-extend '$import '$import '())

(global-extend 'define 'define '())

(global-extend 'define-syntax 'define-syntax '())

(global-extend 'eval-when 'eval-when '())

(global-extend 'meta 'meta '())

(global-extend 'core 'syntax-case
  (let ()
    (define convert-pattern
      ; accepts pattern & keys
      ; returns syntax-dispatch pattern & ids
      (lambda (pattern keys)
        (define cvt*
          (lambda (p* n ids)
            (if (null? p*)
                (values '() ids)
                (let-values (((y ids) (cvt* (cdr p*) n ids)))
                  (let-values (((x ids) (cvt (car p*) n ids)))
                    (values (cons x y) ids))))))
        (define cvt
          (lambda (p n ids)
            (if (id? p)
                (if (bound-id-member? p keys)
                    (values (vector 'free-id p) ids)
                    (values 'any (cons (cons p n) ids)))
                (syntax-case p ()
                  ((x dots)
                   (ellipsis? (syntax dots))
                   (let-values (((p ids) (cvt (syntax x) (fx+ n 1) ids)))
                     (values (if (eq? p 'any) 'each-any (vector 'each p))
                             ids)))
                  ((x dots y ... . z)
                   (ellipsis? (syntax dots))
                   (let-values (((z ids) (cvt (syntax z) n ids)))
                     (let-values (((y ids) (cvt* (syntax (y ...)) n ids)))
                       (let-values (((x ids) (cvt (syntax x) (fx+ n 1) ids)))
                         (values `#(each+ ,x ,(reverse y) ,z) ids)))))
                  ((x . y)
                   (let-values (((y ids) (cvt (syntax y) n ids)))
                     (let-values (((x ids) (cvt (syntax x) n ids)))
                       (values (cons x y) ids))))
                  (() (values '() ids))
                  (#(x ...)
                   (let-values (((p ids) (cvt (syntax (x ...)) n ids)))
                     (values (vector 'vector p) ids)))
                  (x (values (vector 'atom (strip p empty-wrap)) ids))))))
        (cvt pattern 0 '())))

    (define build-dispatch-call
      (lambda (pvars exp y r mr m?)
        (let ((ids (map car pvars)) (levels (map cdr pvars)))
          (let ((labels (gen-labels ids)) (new-vars (map gen-var ids)))
            (build-application no-source
              (build-primref no-source 'apply)
              (list (build-lambda no-source new-vars
                      (chi exp
                         (extend-env*
                             labels
                             (map (lambda (var level)
                                    (make-binding 'syntax `(,var . ,level)))
                                  new-vars
                                  (map cdr pvars))
                             r)
                         mr
                         (make-binding-wrap ids labels empty-wrap)
                         m?))
                    y))))))

    (define gen-clause
      (lambda (x keys clauses r mr m? pat fender exp)
        (let-values (((p pvars) (convert-pattern pat keys)))
          (cond
            ((not (distinct-bound-ids? (map car pvars)))
             (invalid-ids-error (map car pvars) pat "pattern variable"))
            ((not (andmap (lambda (x) (not (ellipsis? (car x)))) pvars))
             (syntax-error pat
               "misplaced ellipsis in syntax-case pattern"))
            (else
             (let ((y (gen-var 'tmp)))
               ; fat finger binding and references to temp variable y
               (build-application no-source
                 (build-lambda no-source (list y)
                   (let-syntax ((y (identifier-syntax
                                     (build-lexical-reference 'value no-source y))))
                     (build-conditional no-source
                       (syntax-case fender ()
                         (#t y)
                         (_ (build-conditional no-source
                              y
                              (build-dispatch-call pvars fender y r mr m?)
                              (build-data no-source #f))))
                       (build-dispatch-call pvars exp y r mr m?)
                       (gen-syntax-case x keys clauses r mr m?))))
                 (list (if (eq? p 'any)
                           (build-application no-source
                             (build-primref no-source 'list)
                             (list (build-lexical-reference no-source 'value x)))
                           (build-application no-source
                             (build-primref no-source '$syntax-dispatch)
                             (list (build-lexical-reference no-source 'value x)
                                   (build-data no-source p))))))))))))

    (define gen-syntax-case
      (lambda (x keys clauses r mr m?)
        (if (null? clauses)
            (build-application no-source
              (build-primref no-source 'syntax-error)
              (list (build-lexical-reference 'value no-source x)))
            (syntax-case (car clauses) ()
              ((pat exp)
               (if (and (id? (syntax pat))
                        (not (bound-id-member? (syntax pat) keys))
                        (not (ellipsis? (syntax pat))))
                   (let ((label (gen-label))
                         (var (gen-var (syntax pat))))
                     (build-application no-source
                       (build-lambda no-source (list var)
                         (chi (syntax exp)
                              (extend-env label (make-binding 'syntax `(,var . 0)) r)
                              mr
                              (make-binding-wrap (syntax (pat))
                                (list label) empty-wrap)
                              m?))
                       (list (build-lexical-reference 'value no-source x))))
                   (gen-clause x keys (cdr clauses) r mr m?
                     (syntax pat) #t (syntax exp))))
              ((pat fender exp)
               (gen-clause x keys (cdr clauses) r mr m?
                 (syntax pat) (syntax fender) (syntax exp)))
              (_ (syntax-error (car clauses) "invalid syntax-case clause"))))))

    (lambda (e r mr w ae m?)
      (let ((e (source-wrap e w ae)))
        (syntax-case e ()
          ((_ val (key ...) m ...)
           (if (andmap (lambda (x) (and (id? x) (not (ellipsis? x))))
                       (syntax (key ...)))
               (let ((x (gen-var 'tmp)))
                 ; fat finger binding and references to temp variable x
                 (build-application ae
                   (build-lambda no-source (list x)
                     (gen-syntax-case x
                       (syntax (key ...)) (syntax (m ...))
                       r mr m?))
                   (list (chi (syntax val) r mr empty-wrap m?))))
               (syntax-error e "invalid literals list in"))))))))

(global-extend 'macro 'include
  (lambda (x)
    (syntax-case x ()
      ((include filename)
       (datum->syntax-object (syntax include) (##include-file-as-a-begin-expr (syntax-object-expression x)))))))

(put-cte-hook 'module
  (lambda (x)
    (define proper-export?
      (lambda (e)
        (syntax-case e ()
          ((id e ...)
           (and (identifier? (syntax id))
                (andmap proper-export? (syntax (e ...)))))
          (id (identifier? (syntax id))))))
    (with-syntax ((orig x))
      (syntax-case x ()
        ((_ (e ...) d ...)
         (if (andmap proper-export? (syntax (e ...)))
             (syntax (begin ($module orig anon (e ...) d ...) ($import orig #f anon)))
             (syntax-error x "invalid exports list in")))
        ((_ m (e ...) d ...)
         (identifier? (syntax m))
         (if (andmap proper-export? (syntax (e ...)))
             (syntax ($module orig m (e ...) d ...))
             (syntax-error x "invalid exports list in")))))))

(let ()
  (define $module-exports
    (lambda (m r)
      (let ((b (r m)))
        (case (binding-type b)
          (($module)
           (let* ((interface (binding-value b))
                  (new-marks (import-mark-delta m interface)))
             (vmap (lambda (x)
                     (let ((id (if (pair? x) (car x) x)))
                       (make-syntax-object
                         (syntax-object->datum id)
                         (let ((marks (join-marks new-marks (wrap-marks (syntax-object-wrap id))))) 
                           (make-wrap marks
                                     ; the anti mark should always be present at the head
                                     ; of new-marks, but we paranoically check anyway
                                      (if (eq? (car marks) the-anti-mark)
                                          (cons 'shift (wrap-subst top-wrap))
                                          (wrap-subst top-wrap)))))))
                   (interface-exports interface))))
          ((displaced-lexical) (displaced-lexical-error m))
          (else (syntax-error m "unknown module"))))))
  (define $import-help
    (lambda (orig import-only?)
      (lambda (r)
        (define difference
          (lambda (ls1 ls2)
            (if (null? ls1)
                ls1
                (if (bound-id-member? (car ls1) ls2)
                    (difference (cdr ls1) ls2)
                    (cons (car ls1) (difference (cdr ls1) ls2))))))
        (define prefix-add
          (lambda (prefix-id)
            (let ((prefix (symbol->string (syntax-object->datum prefix-id))))
              (lambda (id)
                (datum->syntax-object id
                  (string->symbol
                    (string-append prefix
                      (symbol->string (syntax-object->datum id)))))))))
        (define prefix-drop
          (lambda (prefix-id)
            (let ((prefix (symbol->string (syntax-object->datum prefix-id))))
              (lambda (id)
                (let ((s (symbol->string (syntax-object->datum id))))
                  (let ((np (string-length prefix)) (ns (string-length s)))
                    (unless (and (>= ns np) (string=? (substring s 0 np) prefix))
                      (syntax-error id (string-append "missing expected prefix " prefix)))
                    (datum->syntax-object id
                      (string->symbol (substring s np ns)))))))))
        (define gen-mid
          (lambda (mid)
           ; introduced module ids must have same marks as original
           ; for import-only, since the barrier carries the marks of
           ; the module id
            (datum->syntax-object mid (generate-id (id-sym-name mid)))))
        (define (modspec m exports?)
          (with-syntax ((orig orig) (import-only? import-only?))
            (syntax-case m (only-for-syntax also-for-syntax
                            only except
                            add-prefix drop-prefix rename alias)
              ((only m id ...)
               (andmap identifier? (syntax (id ...)))
               (let-values (((mid d exports) (modspec (syntax m) #f)))
                 (with-syntax ((d d) (tmid (gen-mid mid)))
                   (values mid
                           (syntax (begin ($module orig tmid (id ...) d) ($import orig import-only? tmid)))
                           (and exports? (syntax (id ...)))))))
              ((except m id ...)
               (andmap identifier? (syntax (id ...)))
               (let-values (((mid d exports) (modspec (syntax m) #t)))
                 (with-syntax ((d d)
                               (tmid (gen-mid mid))
                               ((id ...) (difference exports (syntax (id ...)))))
                   (values mid
                           (syntax (begin ($module orig tmid (id ...) d) ($import orig import-only? tmid)))
                           (and exports? (syntax (id ...)))))))
              ((add-prefix m prefix-id)
               (identifier? (syntax prefix-id))
               (let-values (((mid d exports) (modspec (syntax m) #t)))
                 (with-syntax ((d d)
                               (tmid (gen-mid mid))
                               ((old-id ...) exports)
                               ((tmp ...) (generate-temporaries exports))
                               ((id ...) (map (prefix-add (syntax prefix-id)) exports)))
                   (values mid
                           (syntax (begin ($module orig tmid ((id tmp) ...)
                                            ($module orig tmid ((tmp old-id) ...) d (alias tmp old-id) ...)
                                            ($import orig import-only? tmid)
                                            (alias id tmp) ...)
                                          ($import orig import-only? tmid)))
                           (and exports? (syntax (id ...)))))))
              ((drop-prefix m prefix-id)
               (identifier? (syntax prefix-id))
               (let-values (((mid d exports) (modspec (syntax m) #t)))
                 (with-syntax ((d d)
                               (tmid (gen-mid mid))
                               ((old-id ...) exports)
                               ((tmp ...) (generate-temporaries exports))
                               ((id ...) (map (prefix-drop (syntax prefix-id)) exports)))
                   (values mid
                           (syntax (begin ($module orig tmid ((id tmp) ...)
                                            ($module orig tmid ((tmp old-id) ...) d (alias tmp old-id) ...)
                                            ($import orig import-only? tmid)
                                            (alias id tmp) ...)
                                          ($import orig import-only? tmid)))
                           (and exports? (syntax (id ...)))))))
              ((rename m (new-id old-id) ...)
               (and (andmap identifier? (syntax (new-id ...)))
                    (andmap identifier? (syntax (old-id ...))))
               (let-values (((mid d exports) (modspec (syntax m) #t)))
                 (with-syntax ((d d)
                               (tmid (gen-mid mid))
                               ((tmp ...) (generate-temporaries (syntax (old-id ...))))
                               ((other-id ...) (difference exports (syntax (old-id ...)))))
                   (values mid
                           (syntax (begin ($module orig tmid ((new-id tmp) ... other-id ...)
                                            ($module orig tmid (other-id ... (tmp old-id) ...) d (alias tmp old-id) ...)
                                            ($import orig import-only? tmid)
                                            (alias new-id tmp) ...)
                                          ($import orig import-only? tmid)))
                           (and exports? (syntax (new-id ... other-id ...)))))))
              ((alias m (new-id old-id) ...)
               (and (andmap identifier? (syntax (new-id ...)))
                    (andmap identifier? (syntax (old-id ...))))
               (let-values (((mid d exports) (modspec (syntax m) #t)))
                 (with-syntax ((d d)
                               (tmid (gen-mid mid))
                               ((other-id ...) exports))
                   (values mid
                           (syntax (begin ($module orig tmid ((new-id old-id) ... other-id ...) d (alias new-id old-id) ...)
                                          ($import orig import-only? tmid)))
                           (and exports? (syntax (new-id ... other-id ...)))))))
             ; base cases
              (mid
               (identifier? (syntax mid))
               (values (syntax mid)
                       (syntax ($import orig import-only? mid))
                       (and exports? ($module-exports (syntax mid) r))))
              ((mid)
               (identifier? (syntax mid))
               (values (syntax mid)
                       (syntax ($import orig import-only? mid))
                       (and exports? ($module-exports (syntax mid) r))))
            (_ (syntax-error m "invalid module specifier")))))
        (define modspec*
          (lambda (m)
            (let-values (((mid d exports) (modspec m #f))) d)))
        (syntax-case orig ()
          ((_ m ...)
           (with-syntax (((d ...) (map modspec* (syntax (m ...)))))
             (syntax (begin d ...))))))))

  (put-cte-hook 'import
    (lambda (orig)
      ($import-help orig #f)))
  
  (put-cte-hook 'import-only
    (lambda (orig)
      ($import-help orig #t)))
)

;;; To support eval-when, we maintain two mode sets:
;;;
;;; ctem (compile-time-expression mode)
;;;   determines whether/when to evaluate compile-time expressions such
;;;   as macro definitions, module definitions, and compile-time
;;;   registration of variable definitions
;;;
;;; rtem (run-time-expression mode)
;;;   determines whether/when to evaluate run-time expressions such
;;;   as the actual assignment performed by a variable definition or
;;;   arbitrary top-level expressions

;;; Possible modes in the mode set are:
;;;
;;; L (load): evaluate at load time.  implies V for compile-time
;;;     expressions and R for run-time expressions.
;;;
;;; C (compile): evaluate at compile (file) time
;;;
;;; E (eval): evaluate at evaluation (compile or interpret) time
;;;
;;; V (visit): evaluate at visit time
;;;
;;; R (revisit): evaluate at revisit time

;;; The mode set for the body of an eval-when is determined by
;;; translating each mode in the old mode set based on the situations
;;; present in the eval-when form and combining these into a set,
;;; using the following table.  See also update-mode-set.

;;;      load  compile  visit  revisit  eval
;;;
;;; L     L      C        V       R      -
;;;
;;; C     -      -        -       -      C
;;;
;;; V     V      C        V       -      -
;;;
;;; R     R      C        -       R      -
;;;
;;; E     -      -        -       -      E

;;; When we complete the expansion of a compile or run-time expression,
;;; the current ctem or rtem determines how the expression will be
;;; treated.  See ct-eval/residualize and rt-eval/residualize.

;;; Initial mode sets
;;;
;;; when compiling a file:
;;;
;;;     initial ctem: (L C)
;;;
;;;     initial rtem: (L)
;;;
;;; when not compiling a file:
;;;
;;;     initial ctem: (E)
;;;
;;;     initial rtem: (E)
;;;
;;;
;;; This means that top-level syntactic definitions are evaluated
;;; immediately after they are expanded, and the expanded definitions
;;; are also residualized into the object file if we are compiling
;;; a file.

(let ()

(define (make-sc-expander ctem rtem)
  (lambda (x)
    (let ((env (interaction-environment)))
      (if (and (pair? x) (equal? (car x) noexpand))
          (cadr x)
          (chi-top* x null-env
            (env-wrap env)
            ctem rtem #f
            (env-top-ribcage env))))))

(set! sc-expand
  (let ((ctem '(E)) (rtem '(E)))
    (make-sc-expander ctem rtem))) ;***

(set! sc-compile-expand ;*** added for macro expansion by compiler
  (let ((ctem '(L C)) (rtem '(L)))
    (make-sc-expander ctem rtem)))
)



(set! $make-environment
  (lambda (token mutable?)
    (let ((top-ribcage (make-top-ribcage token mutable?)))
      (make-env
        top-ribcage
        (make-wrap
          (wrap-marks top-wrap)
          (cons top-ribcage (wrap-subst top-wrap)))))))

(set! environment?
  (lambda (x)
    (env? x)))



(set! interaction-environment
  (let ((e ($make-environment '*top* #t)))
    (lambda () e)))

(set! identifier?
  (lambda (x)
    (nonsymbol-id? x)))

(set! datum->syntax-object
  (lambda (id datum)
    (arg-check nonsymbol-id? id 'datum->syntax-object)
    (make-syntax-object
      datum
      (syntax-object-wrap id))))

(set! syntax->list
  (lambda (orig-ls)
    (let f ((ls orig-ls))
      (syntax-case ls ()
        (() '())
        ((x . r) (cons #'x (f #'r)))
;***         (_ (error 'syntax->list "invalid argument ~s" orig-ls))))))
        (_ (error "(in syntax->list) invalid argument" orig-ls))))))

(set! syntax->vector
  (lambda (v)
    (syntax-case v ()
;***       (#(x ...) (apply vector (syntax->list #'(x ...))))
;***       (_ (error 'syntax->vector "invalid argument ~s" v)))))
      (#(x ...) (list->vector (syntax->list #'(x ...))))
      (_ (error "(in syntax->vector) invalid argument" v)))))

(set! syntax-object->datum
  ; accepts any object, since syntax objects may consist partially
  ; or entirely of unwrapped, nonsymbolic data
  (lambda (x)
    (strip x empty-wrap)))

(set! generate-temporaries
  (let ((n 0))
    (lambda (ls)
      (arg-check list? ls 'generate-temporaries)
      (map (lambda (x)
             (set! n (+ n 1))
             (wrap
              ; unique name to distinguish from other temporaries
               (string->symbol (string-append "t" (number->string n)))
              ; unique mark (in tmp-wrap) to distinguish from non-temporaries
               tmp-wrap))
           ls))))
  
(set! free-identifier=?
   (lambda (x y)
      (arg-check nonsymbol-id? x 'free-identifier=?)
      (arg-check nonsymbol-id? y 'free-identifier=?)
      (free-id=? x y)))

(set! bound-identifier=?
   (lambda (x y)
      (arg-check nonsymbol-id? x 'bound-identifier=?)
      (arg-check nonsymbol-id? y 'bound-identifier=?)
      (bound-id=? x y)))

(set! literal-identifier=?
  (lambda (x y)
    (arg-check nonsymbol-id? x 'literal-identifier=?)
    (arg-check nonsymbol-id? y 'literal-identifier=?)
    (literal-id=? x y)))

(set! syntax-error
  (lambda (object . messages)
    (for-each (lambda (x) (arg-check string? x 'syntax-error)) messages)
    (let ((message (if (null? messages)
                       "invalid syntax"
                       (apply string-append messages))))
;***       (error-hook #f message (strip object empty-wrap)))))
      (error message (strip object empty-wrap)))))

;;; syntax-dispatch expects an expression and a pattern.  If the expression
;;; matches the pattern a list of the matching expressions for each
;;; "any" is returned.  Otherwise, #f is returned.  (This use of #f will
;;; not work on r4rs implementations that violate the ieee requirement
;;; that #f and () be distinct.)

;;; The expression is matched with the pattern as follows:

;;; p in pattern:                        matches:
;;;   ()                                 empty list
;;;   any                                anything
;;;   (p1 . p2)                          pair (list)
;;;   #(free-id <key>)                   <key> with literal-identifier=?
;;;   each-any                           any proper list
;;;   #(each p)                          (p*)
;;;   #(each+ p1 (p2_1 ...p2_n) p3)      (p1* (p2_n ... p2_1) . p3)
;;;   #(vector p)                        (list->vector p)
;;;   #(atom <object>)                   <object> with "equal?"

;;; Vector cops out to pair under assumption that vectors are rare.  If
;;; not, should convert to:
;;;   #(vector p)                        #(p*)

(let ()

(define match-each
  (lambda (e p w)
    (cond
      ((annotation? e)
       (match-each (annotation-expression e) p w))
      ((pair? e)
       (let ((first (match (car e) p w '())))
         (and first
              (let ((rest (match-each (cdr e) p w)))
                 (and rest (cons first rest))))))
      ((null? e) '())
      ((syntax-object? e)
       (match-each (syntax-object-expression e)
                   p
                   (join-wraps w (syntax-object-wrap e))))
      (else #f))))

(define match-each+
  (lambda (e x-pat y-pat z-pat w r)
    (let f ((e e) (w w))
      (cond
        ((pair? e)
         (let-values (((xr* y-pat r) (f (cdr e) w)))
           (if r
               (if (null? y-pat)
                   (let ((xr (match (car e) x-pat w '())))
                     (if xr
                         (values (cons xr xr*) y-pat r)
                         (values #f #f #f)))
                   (values '() (cdr y-pat) (match (car e) (car y-pat) w r)))
               (values #f #f #f))))
        ((annotation? e) (f (annotation-expression e) w))
        ((syntax-object? e) (f (syntax-object-expression e)
                               (join-wraps w (syntax-object-wrap e))))
        (else (values '() y-pat (match e z-pat w r)))))))

(define match-each-any
  (lambda (e w)
    (cond
      ((annotation? e)
       (match-each-any (annotation-expression e) w))
      ((pair? e)
       (let ((l (match-each-any (cdr e) w)))
         (and l (cons (wrap (car e) w) l))))
      ((null? e) '())
      ((syntax-object? e)
       (match-each-any (syntax-object-expression e)
                       (join-wraps w (syntax-object-wrap e))))
      (else #f))))

(define match-empty
  (lambda (p r)
    (cond
      ((null? p) r)
      ((eq? p 'any) (cons '() r))
      ((pair? p) (match-empty (car p) (match-empty (cdr p) r)))
      ((eq? p 'each-any) (cons '() r))
      (else
       (case (vector-ref p 0)
         ((each) (match-empty (vector-ref p 1) r))
         ((each+) (match-empty (vector-ref p 1)
                    (match-empty (reverse (vector-ref p 2))
                      (match-empty (vector-ref p 3) r))))
         ((free-id atom) r)
         ((vector) (match-empty (vector-ref p 1) r)))))))

(define combine
  (lambda (r* r)
    (if (null? (car r*))
        r
        (cons (map car r*) (combine (map cdr r*) r)))))

(define match*
  (lambda (e p w r)
    (cond
      ((null? p) (and (null? e) r))
      ((pair? p)
       (and (pair? e) (match (car e) (car p) w
                        (match (cdr e) (cdr p) w r))))
      ((eq? p 'each-any)
       (let ((l (match-each-any e w))) (and l (cons l r))))
      (else
       (case (vector-ref p 0)
         ((each)
          (if (null? e)
              (match-empty (vector-ref p 1) r)
              (let ((r* (match-each e (vector-ref p 1) w)))
                (and r* (combine r* r)))))
         ((free-id) (and (id? e) (literal-id=? (wrap e w) (vector-ref p 1)) r))
         ((each+)
          (let-values (((xr* y-pat r)
                        (match-each+ e (vector-ref p 1) (vector-ref p 2)
                          (vector-ref p 3) w r)))
            (and r (null? y-pat)
              (if (null? xr*)
                  (match-empty (vector-ref p 1) r)
                  (combine xr* r)))))
         ((atom) (and (equal? (vector-ref p 1) (strip e w)) r))
         ((vector)
          (and (vector? e)
               (match (vector->list e) (vector-ref p 1) w r))))))))

(define match
  (lambda (e p w r)
    (cond
      ((not r) #f)
      ((eq? p 'any) (cons (wrap e w) r))
      ((syntax-object? e)
       (match*
         (unannotate (syntax-object-expression e))
         p
         (join-wraps w (syntax-object-wrap e))
         r))
      (else (match* (unannotate e) p w r)))))

(set! $syntax-dispatch
  (lambda (e p)
    (cond
      ((eq? p 'any) (list e))
      ((syntax-object? e)
       (match* (unannotate (syntax-object-expression e))
         p (syntax-object-wrap e) '()))
      (else (match* (unannotate e) p empty-wrap '())))))
))


(define-syntax with-syntax
   (lambda (x)
      (syntax-case x ()
         ((_ () e1 e2 ...)
          (syntax (begin e1 e2 ...)))
         ((_ ((out in)) e1 e2 ...)
          (syntax (syntax-case in () (out (begin e1 e2 ...)))))
         ((_ ((out in) ...) e1 e2 ...)
          (syntax (syntax-case (list in ...) ()
                     ((out ...) (begin e1 e2 ...))))))))

(define-syntax with-implicit
  (syntax-rules ()
    ((_ (tid id ...) e1 e2 ...)
     (andmap identifier? (syntax (tid id ...)))
     (begin
       (unless (identifier? (syntax tid))
         (syntax-error (syntax tid) "non-identifier with-implicit template"))
       (with-syntax ((id (datum->syntax-object (syntax tid) 'id)) ...)
         e1 e2 ...)))))

(define-syntax datum
  (syntax-rules ()
    ((_ x) (syntax-object->datum (syntax x)))))

(define-syntax syntax-rules
  (lambda (x)
    (define clause
      (lambda (y)
        (syntax-case y ()
          (((keyword . pattern) template)
           (syntax ((dummy . pattern) (syntax template))))
          (((keyword . pattern) fender template)
           (syntax ((dummy . pattern) fender (syntax template))))
          (_ (syntax-error x)))))
    (syntax-case x ()
      ((_ (k ...) cl ...)
       (andmap identifier? (syntax (k ...)))
       (with-syntax (((cl ...) (map clause (syntax (cl ...)))))
         (syntax (lambda (x) (syntax-case x (k ...) cl ...))))))))

(define-syntax or
   (lambda (x)
      (syntax-case x ()
         ((_) (syntax #f))
         ((_ e) (syntax e))
         ((_ e1 e2 e3 ...)
          (syntax (let ((t e1)) (if t t (or e2 e3 ...))))))))

(define-syntax and
   (lambda (x)
      (syntax-case x ()
         ((_ e1 e2 e3 ...) (syntax (if e1 (and e2 e3 ...) #f)))
         ((_ e) (syntax e))
         ((_) (syntax #t)))))

(define-syntax let
   (lambda (x)
      (syntax-case x ()
         ((_ ((x v) ...) e1 e2 ...)
          (andmap identifier? (syntax (x ...)))
          (syntax ((lambda (x ...) e1 e2 ...) v ...)))
         ((_ f ((x v) ...) e1 e2 ...)
          (andmap identifier? (syntax (f x ...)))
          (syntax ((letrec ((f (lambda (x ...) e1 e2 ...))) f)
                    v ...))))))

(define-syntax let*
  (lambda (x)
    (syntax-case x ()
      ((let* ((x v) ...) e1 e2 ...)
       (andmap identifier? (syntax (x ...)))
       (let f ((bindings (syntax ((x v)  ...))))
         (if (null? bindings)
             (syntax (let () e1 e2 ...))
             (with-syntax ((body (f (cdr bindings)))
                           (binding (car bindings)))
               (syntax (let (binding) body)))))))))

(define-syntax cond
  (lambda (x)
    (syntax-case x ()
      ((_ m1 m2 ...)
       (let f ((clause (syntax m1)) (clauses (syntax (m2 ...))))
         (if (null? clauses)
             (syntax-case clause (else =>)
               ((else e1 e2 ...) (syntax (begin e1 e2 ...)))
               ((e0) (syntax (let ((t e0)) (if t t))))
               ((e0 => e1) (syntax (let ((t e0)) (if t (e1 t)))))
               ((e0 e1 e2 ...) (syntax (if e0 (begin e1 e2 ...))))
               (_ (syntax-error x)))
             (with-syntax ((rest (f (car clauses) (cdr clauses))))
               (syntax-case clause (else =>)
                 ((e0) (syntax (let ((t e0)) (if t t rest))))
                 ((e0 => e1) (syntax (let ((t e0)) (if t (e1 t) rest))))
                 ((e0 e1 e2 ...) (syntax (if e0 (begin e1 e2 ...) rest)))
                 (_ (syntax-error x))))))))))

(define-syntax do
   (lambda (orig-x)
      (syntax-case orig-x ()
         ((_ ((var init . step) ...) (e0 e1 ...) c ...)
          (with-syntax (((step ...)
                         (map (lambda (v s)
                                 (syntax-case s ()
                                    (() v)
                                    ((e) (syntax e))
                                    (_ (syntax-error orig-x))))
                              (syntax (var ...))
                              (syntax (step ...)))))
             (syntax-case (syntax (e1 ...)) ()
                (() (syntax (let do ((var init) ...)
                               (if (not e0)
                                   (begin c ... (do step ...))))))
                ((e1 e2 ...)
                 (syntax (let do ((var init) ...)
                            (if e0
                                (begin e1 e2 ...)
                                (begin c ... (do step ...))))))))))))

(define-syntax quasiquote
  (let ()
    (define (quasi p lev)
      (syntax-case p (unquote quasiquote)
        ((unquote p)
         (if (= lev 0)
             #'("value" p)
             (quasicons #'("quote" unquote) (quasi #'(p) (- lev 1)))))
        ((quasiquote p) (quasicons #'("quote" quasiquote) (quasi #'(p) (+ lev 1))))
        ((p . q)
         (syntax-case #'p (unquote unquote-splicing)
           ((unquote p ...)
            (if (= lev 0)
                (quasilist* #'(("value" p) ...) (quasi #'q lev))
                (quasicons
                  (quasicons #'("quote" unquote) (quasi #'(p ...) (- lev 1)))
                  (quasi #'q lev))))
           ((unquote-splicing p ...)
            (if (= lev 0)
                (quasiappend #'(("value" p) ...) (quasi #'q lev))
                (quasicons
                  (quasicons #'("quote" unquote-splicing) (quasi #'(p ...) (- lev 1)))
                  (quasi #'q lev))))
           (_ (quasicons (quasi #'p lev) (quasi #'q lev)))))
        (#(x ...) (quasivector (vquasi #'(x ...) lev)))
        (p #'("quote" p))))
    (define (vquasi p lev)
      (syntax-case p ()
        ((p . q)
         (syntax-case #'p (unquote unquote-splicing)
           ((unquote p ...)
            (if (= lev 0)
                (quasilist* #'(("value" p) ...) (vquasi #'q lev))
                (quasicons
                  (quasicons #'("quote" unquote) (quasi #'(p ...) (- lev 1)))
                  (vquasi #'q lev))))
           ((unquote-splicing p ...)
            (if (= lev 0)
                (quasiappend #'(("value" p) ...) (vquasi #'q lev))
                (quasicons
                  (quasicons
                    #'("quote" unquote-splicing)
                    (quasi #'(p ...) (- lev 1)))
                  (vquasi #'q lev))))
           (_ (quasicons (quasi #'p lev) (vquasi #'q lev)))))
        (() #'("quote" ()))))
    (define (quasicons x y)
      (with-syntax ((x x) (y y))
        (syntax-case #'y ()
          (("quote" dy)
           (syntax-case #'x ()
             (("quote" dx) #'("quote" (dx . dy)))
             (_ (if (null? #'dy) #'("list" x) #'("list*" x y)))))
          (("list" . stuff) #'("list" x . stuff))
          (("list*" . stuff) #'("list*" x . stuff))
          (_ #'("list*" x y)))))
    (define (quasiappend x y)
      (syntax-case y ()
        (("quote" ())
         (cond
           ((null? x) #'("quote" ()))
           ((null? (cdr x)) (car x))
           (else (with-syntax (((p ...) x)) #'("append" p ...)))))
        (_
         (cond
           ((null? x) y)
           (else (with-syntax (((p ...) x) (y y)) #'("append" p ... y)))))))
    (define (quasilist* x y)
      (let f ((x x))
        (if (null? x)
            y
            (quasicons (car x) (f (cdr x))))))
    (define (quasivector x)
      (syntax-case x ()
        (("quote" (x ...)) #'("quote" #(x ...)))
        (_
         (let f ((y x) (k (lambda (ls) #`("vector" #,@ls))))
           (syntax-case y ()
             (("quote" (y ...)) (k #'(("quote" y) ...)))
             (("list" y ...) (k #'(y ...)))
             (("list*" y ... z) (f #'z (lambda (ls) (k (append #'(y ...) ls)))))
             (else #`("list->vector" #,x)))))))
    (define (emit x)
      (syntax-case x ()
        (("quote" x) #''x)
        (("list" x ...) #`(list #,@(map emit #'(x ...))))
      ; could emit list* for 3+ arguments if implementation supports list*
       (("list*" x ... y)
        (let f ((x* #'(x ...)))
          (if (null? x*)
              (emit #'y)
              #`(cons #,(emit (car x*)) #,(f (cdr x*))))))
        (("append" x ...) #`(append #,@(map emit #'(x ...))))
        (("vector" x ...) #`(vector #,@(map emit #'(x ...))))
        (("list->vector" x) #`(list->vector #,(emit #'x)))
        (("value" x) #'x)))
    (lambda (x)
      (syntax-case x ()
       ; convert to intermediate language, combining introduced (but not
       ; unquoted source) quote expressions where possible and choosing
       ; optimal construction code otherwise, then emit Scheme code
       ; corresponding to the intermediate language forms.
        ((_ e) (emit (quasi #'e 0)))))))

;*** "unquote" and "unquote-splicing" might be variables and defining
;*** them as macros would interfere.
;***
;*** (define-syntax unquote
;***   (lambda (x)
;***     (syntax-error x "misplaced")))
;***
;*** (define-syntax unquote-splicing
;***   (lambda (x)
;***     (syntax-error x "misplaced")))

(define-syntax quasisyntax
  (lambda (x)
    (define (qs q n b* k)
      (syntax-case q (quasisyntax unsyntax unsyntax-splicing)
        ((quasisyntax . d)
         (qs #'d (+ n 1) b*
           (lambda (b* dnew)
             (k b*
                (if (eq? dnew #'d)
                    q
                    (with-syntax ((d dnew)) #'(quasisyntax . d)))))))
        ((unsyntax . d)
         (not (= n 0))
         (qs #'d (- n 1) b*
           (lambda (b* dnew)
             (k b*
                (if (eq? dnew #'d)
                    q
                    (with-syntax ((d dnew)) #'(unsyntax . d)))))))
        ((unsyntax-splicing . d)
         (not (= n 0))
         (qs #'d (- n 1) b*
           (lambda (b* dnew)
             (k b*
                (if (eq? dnew #'d)
                    q
                    (with-syntax ((d dnew)) #'(unsyntax-splicing . d)))))))
        ((unsyntax q)
         (= n 0)
         (with-syntax (((t) (generate-temporaries #'(q))))
           (k (cons #'(t q) b*) #'t)))
        (((unsyntax q ...) . d)
         (= n 0)
         (qs #'d n b*
           (lambda (b* dnew)
             (with-syntax (((t ...) (generate-temporaries #'(q ...))))
               (k (append #'((t q) ...) b*)
                  (with-syntax ((d dnew)) #'(t ... . d)))))))
        (((unsyntax-splicing q ...) . d)
         (= n 0)
         (qs #'d n b*
           (lambda (b* dnew)
             (with-syntax (((t ...) (generate-temporaries #'(q ...))))
               (k (append #'(((t (... ...)) q) ...) b*)
                  (with-syntax ((((m ...) ...) #'((t (... ...)) ...)))
                    (with-syntax ((d dnew)) #'(m ... ... . d))))))))
        ((a . d)
         (qs #'a n b*
           (lambda (b* anew)
             (qs #'d n b*
               (lambda (b* dnew)
                 (k b*
                    (if (and (eq? anew #'a) (eq? dnew #'d))
                        q
                        (with-syntax ((a anew) (d dnew)) #'(a . d)))))))))
        (#(x ...)
         (vqs #'(x ...) n b*
           (lambda (b* xnew*)
             (k b*
                (if (let same? ((x* #'(x ...)) (xnew* xnew*))
                      (if (null? x*)
                          (null? xnew*)
                          (and (not (null? xnew*))
                               (eq? (car x*) (car xnew*))
                               (same? (cdr x*) (cdr xnew*)))))
                    q
                    (with-syntax (((x ...) xnew*)) #'#(x ...)))))))
        (_ (k b* q))))
    (define (vqs x* n b* k)
      (if (null? x*)
          (k b* '())
          (vqs (cdr x*) n b*
            (lambda (b* xnew*)
              (syntax-case (car x*) (unsyntax unsyntax-splicing)
                ((unsyntax q ...)
                 (= n 0)
                 (with-syntax (((t ...) (generate-temporaries #'(q ...))))
                   (k (append #'((t q) ...) b*)
                      (append #'(t ...) xnew*))))
                ((unsyntax-splicing q ...)
                 (= n 0)
                 (with-syntax (((t ...) (generate-temporaries #'(q ...))))
                   (k (append #'(((t (... ...)) q) ...) b*)
                      (with-syntax ((((m ...) ...) #'((t (... ...)) ...)))
                        (append #'(m ... ...) xnew*)))))
                (_ (qs (car x*) n b*
                     (lambda (b* xnew)
                       (k b* (cons xnew xnew*))))))))))
    (syntax-case x ()
      ((_ x)
       (qs #'x 0 '()
         (lambda (b* xnew)
           (if (eq? xnew #'x)
               #'(syntax x)
               (with-syntax (((b ...) b*) (x xnew))
                 #'(with-syntax (b ...) (syntax x))))))))))

;*** "unsyntax" and "unsyntax-splicing" might be variables and defining
;*** them as macros would interfere.
;***
;*** (define-syntax unsyntax
;***   (lambda (x)
;***     (syntax-error x "misplaced")))
;***
;*** (define-syntax unsyntax-splicing
;***   (lambda (x)
;***     (syntax-error x "misplaced")))

(define-syntax case
  (lambda (x)
    (syntax-case x ()
      ((_ e m1 m2 ...)
       (with-syntax
         ((body (let f ((clause (syntax m1)) (clauses (syntax (m2 ...))))
                  (if (null? clauses)
                      (syntax-case clause (else)
                        ((else e1 e2 ...) (syntax (begin e1 e2 ...)))
                        (((k ...) e1 e2 ...)
                         (syntax (if (memv t '(k ...)) (begin e1 e2 ...))))
                        (_ (syntax-error x)))
                      (with-syntax ((rest (f (car clauses) (cdr clauses))))
                        (syntax-case clause (else)
                          (((k ...) e1 e2 ...)
                           (syntax (if (memv t '(k ...))
                                       (begin e1 e2 ...)
                                       rest)))
                          (_ (syntax-error x))))))))
         (syntax (let ((t e)) body)))))))

(define-syntax identifier-syntax
  (syntax-rules (set!)
    ((_ e)
     (lambda (x)
       (syntax-case x ()
         (id (identifier? (syntax id)) (syntax e))
         ((_ x (... ...)) (syntax (e x (... ...)))))))
    ((_ (id exp1) ((set! var val) exp2))
     (and (identifier? (syntax id)) (identifier? (syntax var)))
     (cons 'macro!
       (lambda (x)
         (syntax-case x (set!)
           ((set! var val) (syntax exp2))
           ((id x (... ...)) (syntax (exp1 x (... ...))))
           (id (identifier? (syntax id)) (syntax exp1))))))))

;*** Gambit extensions:

(define-syntax cond-expand
  (syntax-rules (and or not else srfi-0 gambit)
    ((cond-expand) (syntax-error "Unfulfilled cond-expand"))
    ((cond-expand (else body ...))
     (begin body ...))
    ((cond-expand ((and) body ...) more-clauses ...)
     (begin body ...))
    ((cond-expand ((and req1 req2 ...) body ...) more-clauses ...)
     (cond-expand
       (req1
         (cond-expand
           ((and req2 ...) body ...)
           more-clauses ...))
       more-clauses ...))
    ((cond-expand ((or) body ...) more-clauses ...)
     (cond-expand more-clauses ...))
    ((cond-expand ((or req1 req2 ...) body ...) more-clauses ...)
     (cond-expand
       (req1
        (begin body ...))
       (else
        (cond-expand
           ((or req2 ...) body ...)
           more-clauses ...))))
    ((cond-expand ((not req) body ...) more-clauses ...)
     (cond-expand
       (req
         (cond-expand more-clauses ...))
       (else body ...)))
    ((cond-expand (srfi-0 body ...) more-clauses ...)
       (begin body ...))
    ((cond-expand (gambit body ...) more-clauses ...)
       (begin body ...))
    ((cond-expand (feature-id body ...) more-clauses ...)
       (cond-expand more-clauses ...))))

(define-syntax define-macro
  (lambda (x)
    (syntax-case x ()
      ((_ (name . params) body1 body2 ...)
       (syntax (define-macro name (lambda params body1 body2 ...))))
      ((_ name expander)
       (syntax (define-syntax name
                 (lambda (y)
                   (syntax-case y ()
                     ((k . args)
                      (let ((lst (syntax-object->datum (syntax args))))
                        (datum->syntax-object
                         (syntax k)
                         (apply expander lst))))))))))))

(define-syntax ##begin
  (lambda (x)
    (syntax-case x ()
      ((_ body1 ...)
       (syntax (begin body1 ...))))))

(define-syntax future
  (syntax-rules ()
    ((_ rest ...) (##future rest ...))))

(define-syntax c-define-type
  (syntax-rules ()
    ((_ rest ...) (##c-define-type rest ...))))

(define-syntax c-declare
  (syntax-rules ()
    ((_ rest ...) (##c-declare rest ...))))

(define-syntax c-initialize
  (syntax-rules ()
    ((_ rest ...) (##c-initialize rest ...))))

(define-syntax c-lambda
  (syntax-rules ()
    ((_ rest ...) (##c-lambda rest ...))))

(define-syntax c-define
  (syntax-rules ()
    ((_ rest ...) (##c-define rest ...))))

(define-syntax declare
  (syntax-rules ()
    ((_ rest ...) (##declare rest ...))))

(define-syntax namespace
  (syntax-rules ()
    ((_ rest ...) (##namespace rest ...))))
