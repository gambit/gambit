;;;============================================================================

;;; File: "syntax-case.scm", Time-stamp: <2015-09-02 18:43:30 feeley>

;;; Copyright (c) 1998-2008 by Marc Feeley, All Rights Reserved.

;;; This is version 3.2 .

;; This version includes a patch which avoids quoting self-evaluating
;; constants.  This makes it possible to use some Gambit specific forms
;; such as declare, namespace and define-macro.

;; This is an implementation of "syntax-case" for the Gambit-C 4.0
;; system based on the portable implementation "psyntax.ss".  At the
;; top of the file "psyntax.ss" can be found this information:
;;
;;      Portable implementation of syntax-case
;;      Extracted from Chez Scheme Version 7.3 (Feb 26, 2007)
;;      Authors: R. Kent Dybvig, Oscar Waddell, Bob Hieb, Carl Bruggeman

;; This file can be used to replace the builtin macro expander of the
;; interpreter and compiler.  Source code correlation information
;; (filename and position in file) is preserved by the expander.  The
;; expander mangles non-global variable names and this complicates
;; debugging somewhat.  Note that Gambit's normal parser processes the
;; input after expansion by the syntax-case expander.  Since the
;; syntax-case expander does not know about Gambit's syntactic
;; extensions (like DSSSL parameters) some of the syntactic
;; extensions cannot be used.  On the other hand, the syntax-case
;; expander defines some new special forms, such as "module",
;; "alias", and "eval-when".

;; You can simply load this file at the REPL with:
;;
;;   (load "syntax-case")
;;
;; For faster macro processing it is worthwhile to compile the file
;; with the compiler.  You can also rename this file to "gambext.scm"
;; and put it in the Gambit "lib" installation directory so that it is
;; loaded every time the interpreter and compiler are started.
;;
;; Alternatively, the expander can be loaded from the command line
;; like this:
;;
;;   % gsi ~~lib/syntax-case -
;;   > (pp (lambda (x y) (if (< x y) (let ((z (* x x))) z))))
;;   (lambda (%%x0 %%y1)
;;     (if (< %%x0 %%y1) ((lambda (%%z2) %%z2) (* %%x0 %%x0)) (void)))

;;;============================================================================

(##declare
(standard-bindings)
(extended-bindings)
(inlining-limit 100)
(block)
)

(##namespace ("sc#"))

(##include "~~lib/gambit#.scm")

(##namespace (""

$make-environment
$sc-put-cte
$syntax-dispatch
bound-identifier=?
datum->syntax-object
environment?
free-identifier=?
generate-temporaries
identifier?
interaction-environment
literal-identifier=?
sc-expand
sc-compile-expand
syntax-object->datum
syntax->list
syntax->vector

))

(##namespace ("sc#"

interaction-environment
eval
gensym
syntax-error

))

;;;============================================================================

;; The following procedures are needed by the syntax-case system.

(define andmap
(lambda (f first . rest)
(or (null? first)
(if (null? rest)
(let andmap ((first first))
(let ((x (car first)) (first (cdr first)))
(if (null? first)
(f x)
(and (f x) (andmap first)))))
(let andmap ((first first) (rest rest))
(let ((x (car first))
(xr (map car rest))
(first (cdr first))
(rest (map cdr rest)))
(if (null? first)
(apply f (cons x xr))
(and (apply f (cons x xr)) (andmap first rest)))))))))

(define ormap
(lambda (proc list1)
(and (not (null? list1))
(or (proc (car list1)) (ormap proc (cdr list1))))))

(define eval
(lambda (expr)
(cond ((and (##pair? expr)
(##equal? (##car expr) "noexpand")
(##pair? (##cdr expr))
(##null? (##cddr expr)))
(##eval (##cadr expr)))
((and (##source? expr)
(##pair? (##source-code expr))
(##source? (##car (##source-code expr)))
(##equal? (##source-code (##car (##source-code expr))) "noexpand")
(##pair? (##cdr (##source-code expr)))
(##null? (##cddr (##source-code expr))))
(##eval (##cadr (##source-code expr))))
(else
(##raise-error-exception
"eval expects an expression of the form (\"noexpand\" <expr>)"
(##list expr))))))

(define gensym-count 0)

(define gensym
(lambda id
(let ((n gensym-count))
(set! gensym-count (+ n 1))
(string->symbol
(string-append "%%"
(if (null? id) "" (symbol->string (car id)))
(number->string n))))))

(define gensym?
(lambda (obj)
(and (symbol? obj)
(let ((str (symbol->string obj)))
(and (> (string-length str) 2)
(string=? (substring str 0 2) "%%"))))))

(define prop-table (##make-table))

(define remprop
(lambda (sym key)
(let ((sym-key (cons sym key)))
(##table-set! prop-table sym-key))))

(define putprop
(lambda (sym key val)
(let ((sym-key (cons sym key)))
(##table-set! prop-table sym-key val))))

(define getprop
(lambda (sym key)
(let ((sym-key (cons sym key)))
(##table-ref prop-table sym-key #f))))

(define list*
(lambda (arg1 . other-args)

(define (fix lst)
(if (null? (cdr lst))
(car lst)
(cons (car lst) (fix (cdr lst)))))

(fix (cons arg1 other-args))))

(define remq
(lambda (obj lst)
(cond ((null? lst)
'())
((eq? (car lst) obj)
(remq obj (cdr lst)))
(else
(cons (car lst) (remq obj (cdr lst)))))))

;;;----------------------------------------------------------------------------

;; These initial definitions are needed because these variables are
;; mutated with a "set!" without a prior definition.

(define $sc-put-cte #f)
(define sc-expand (lambda (src) src)) ; temporary definition
(define sc-compile-expand (lambda (src) src)) ; temporary definition
(define $make-environment #f)
(define environment? #f)
(define interaction-environment #f)
(define identifier? #f)
(define syntax->list #f)
(define syntax->vector #f)
(define syntax-object->datum #f)
(define datum->syntax-object #f)
(define generate-temporaries #f)
(define free-identifier=? #f)
(define bound-identifier=? #f)
(define literal-identifier=? #f)
(define syntax-error #f)
(define $syntax-dispatch #f)

;;;----------------------------------------------------------------------------

;;; Interface to Gambit's source code annotations.

(define annotation?
(lambda (x)
;;    (pp `(annotation? ,x))
(##source? x)))

(define annotation-expression
(lambda (x)
;;    (pp `(annotation-expression ,x))
(##source-code x)))

(define annotation-stripped
(lambda (x)
;;    (pp `(annotation-stripped ,x))
(##desourcify x)))

(define build-source
(lambda (ae x)
;;    (pp `(build-source ,ae ,x))
(if (##source? ae)
(##make-source x (##source-locat ae))
(##make-source x #f))))

(define build-params
(lambda (ae vars)

(define fix
(lambda (vars)
(cond ((null? vars)
'())
((pair? vars)
(cons (build-source ae (car vars))
(fix (cdr vars))))
(else
(build-source ae vars)))))

(if (or (null? vars) (pair? vars))
(build-source ae (fix vars))
(fix vars))))

(define attach-source
(lambda (ae datum)
;;    (pp `(attach-source ,ae ,datum))
(let ((src
(if (##source? ae)
ae
(##make-source ae #f))))

(define (datum->source x)
(##make-source (cond ((pair? x)
(list-convert x))
((box? x)
(box (datum->source (unbox x))))
((vector? x)
(vector-convert x))
(else
x))
(##source-locat src)))

(define (list-convert lst)
(cons (datum->source (car lst))
(list-tail-convert (cdr lst))))

(define (list-tail-convert lst)
(cond ((pair? lst)
(if (quoting-form? lst)
(datum->source lst)
(cons (datum->source (car lst))
(list-tail-convert (cdr lst)))))
((null? lst)
'())
(else
(datum->source lst))))

(define (quoting-form? x)
(let ((first (car x))
(rest (cdr x)))
(and (pair? rest)
(null? (cdr rest))
(or (eq? first 'quote)
(eq? first 'quasiquote)
(eq? first 'unquote)
(eq? first 'unquote-splicing)))))

(define (vector-convert vect)
(let* ((len (vector-length vect))
(v (make-vector len)))
(let loop ((i (- len 1)))
(if (>= i 0)
(begin
(vector-set! v i (datum->source (vector-ref vect i)))
(loop (- i 1)))))
v))

(datum->source datum))))

;;;----------------------------------------------------------------------------

(define self-eval?
(lambda (x)
(or (number? x)
(string? x)
(char? x)
(keyword? x)
(memq x
'(#f
#t
#!eof
#!void
#!unbound
#!unbound2
#!optional
#!rest
#!key)))))

;;;============================================================================
(begin
((lambda ()
(letrec ((%%noexpand62 "noexpand")
(%%make-syntax-object63
(lambda (%%expression460 %%wrap461)
(vector 'syntax-object %%expression460 %%wrap461)))
(%%syntax-object?64
(lambda (%%x462)
(if (vector? %%x462)
(if (= (vector-length %%x462) 3)
(eq? (vector-ref %%x462 0) 'syntax-object)
#f)
#f)))
(%%syntax-object-expression65
(lambda (%%x463) (vector-ref %%x463 1)))
(%%syntax-object-wrap66 (lambda (%%x464) (vector-ref %%x464 2)))
(%%set-syntax-object-expression!67
(lambda (%%x465 %%update466)
(vector-set! %%x465 1 %%update466)))
(%%set-syntax-object-wrap!68
(lambda (%%x467 %%update468)
(vector-set! %%x467 2 %%update468)))
(%%top-level-eval-hook69
(lambda (%%x469) (eval (list %%noexpand62 %%x469))))
(%%local-eval-hook70
(lambda (%%x470) (eval (list %%noexpand62 %%x470))))
(%%define-top-level-value-hook71
(lambda (%%sym471 %%val472)
(%%top-level-eval-hook69
(build-source
#f
(list (build-source #f 'define)
(build-source #f %%sym471)
((lambda (%%x473)
(if (self-eval? %%val472)
%%x473
(build-source
#f
(list (build-source #f 'quote) %%x473))))
(attach-source #f %%val472)))))))
(%%put-cte-hook72
(lambda (%%symbol474 %%val475)
($sc-put-cte %%symbol474 %%val475 '*top*)))
(%%get-global-definition-hook73
(lambda (%%symbol476) (getprop %%symbol476 '*sc-expander*)))
(%%put-global-definition-hook74
(lambda (%%symbol477 %%x478)
(if (not %%x478)
(remprop %%symbol477 '*sc-expander*)
(putprop %%symbol477 '*sc-expander* %%x478))))
(%%read-only-binding?75 (lambda (%%symbol479) #f))
(%%get-import-binding76
(lambda (%%symbol480 %%token481)
(getprop %%symbol480 %%token481)))
(%%update-import-binding!77
(lambda (%%symbol482 %%token483 %%p484)
((lambda (%%x485)
(if (not %%x485)
(remprop %%symbol482 %%token483)
(putprop %%symbol482 %%token483 %%x485)))
(%%p484 (%%get-import-binding76 %%symbol482 %%token483)))))
(%%generate-id78
((lambda (%%digits486)
((lambda (%%base487 %%session-key488)
(letrec ((%%make-digit489
(lambda (%%x491)
(string-ref %%digits486 %%x491)))
(%%fmt490
(lambda (%%n492)
((letrec ((%%fmt493
(lambda (%%n494 %%a495)
(if (< %%n494 %%base487)
(list->string
(cons (%%make-digit489
%%n494)
%%a495))
((lambda (%%r496 %%rest497)
(%%fmt493
%%rest497
(cons (%%make-digit489
%%r496)
%%a495)))
(modulo %%n494 %%base487)
(quotient
%%n494
%%base487))))))
%%fmt493)
%%n492
'()))))
((lambda (%%n498)
(lambda (%%name499)
(begin
(set! %%n498 (+ %%n498 1))
(string->symbol
(string-append
%%session-key488
(%%fmt490 %%n498)
(if %%name499
(string-append
"."
(symbol->string %%name499))
""))))))
-1)))
(string-length %%digits486)
"_"))
"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!$%&*/:<=>?~_^.+-"))
(%%built-lambda?152
(lambda (%%x500)
((lambda (%%t501)
(if %%t501
%%t501
(if (##source? %%x500)
(if (pair? (##source-code %%x500))
(if (##source? (car (##source-code %%x500)))
(eq? (##source-code
(car (##source-code %%x500)))
'lambda)
#f)
#f)
#f)))
(if (pair? %%x500) (eq? (car %%x500) 'lambda) #f))))
(%%build-sequence170
(lambda (%%ae502 %%exps503)
((letrec ((%%loop504
(lambda (%%exps505)
(if (null? (cdr %%exps505))
(car %%exps505)
(if ((lambda (%%x506)
((lambda (%%t507)
(if %%t507
%%t507
(if (##source? %%x506)
(if (pair? (##source-code
%%x506))
(if (##source?
(car (##source-code
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%x506)))
(if (eq? (##source-code (car (##source-code %%x506)))
'void)
(null? (cdr (##source-code %%x506)))
#f)
#f)
#f)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#f)))
(equal? %%x506 '(void))))
(car %%exps505))
(%%loop504 (cdr %%exps505))
(build-source
%%ae502
(cons (build-source %%ae502 'begin)
%%exps505)))))))
%%loop504)
%%exps503)))
(%%build-letrec171
(lambda (%%ae508 %%vars509 %%val-exps510 %%body-exp511)
(if (null? %%vars509)
%%body-exp511
(build-source
%%ae508
(list (build-source %%ae508 'letrec)
(build-source
%%ae508
(map (lambda (%%var512 %%val513)
(build-source
%%ae508
(list (build-source %%ae508 %%var512)
%%val513)))
%%vars509
%%val-exps510))
%%body-exp511)))))
(%%build-body172
(lambda (%%ae514 %%vars515 %%val-exps516 %%body-exp517)
(%%build-letrec171
%%ae514
%%vars515
%%val-exps516
%%body-exp517)))
(%%build-top-module173
(lambda (%%ae518
%%types519
%%vars520
%%val-exps521
%%body-exp522)
(call-with-values
(lambda ()
((letrec ((%%f523 (lambda (%%types524 %%vars525)
(if (null? %%types524)
(values '() '() '())
((lambda (%%var526)
(call-with-values
(lambda ()
(%%f523 (cdr %%types524)
(cdr %%vars525)))
(lambda (%%vars527
%%defns528
%%sets529)
(if (eq? (car %%types524)
'global)
((lambda (%%x530)
(values (cons %%x530
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%vars527)
(cons (build-source
#f
(list (build-source #f 'define)
(build-source #f %%var526)
(%%chi-void453)))
%%defns528)
(cons (build-source
#f
(list (build-source #f 'set!)
(build-source #f %%var526)
(build-source #f %%x530)))
%%sets529)))
(gensym %%var526))
(values (cons %%var526 %%vars527) %%defns528 %%sets529)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(car %%vars525))))))
%%f523)
%%types519
%%vars520))
(lambda (%%vars531 %%defns532 %%sets533)
(if (null? %%defns532)
(%%build-letrec171
%%ae518
%%vars531
%%val-exps521
%%body-exp522)
(%%build-sequence170
#f
(append %%defns532
(list (%%build-letrec171
%%ae518
%%vars531
%%val-exps521
(%%build-sequence170
#f
(append %%sets533
(list %%body-exp522))))))))))))
(%%sanitize-binding206
(lambda (%%b534)
(if (procedure? %%b534)
(cons 'macro %%b534)
(if (%%binding?220 %%b534)
(if ((lambda (%%t535)
(if (memv %%t535 '(core macro macro! deferred))
(procedure? (%%binding-value217 %%b534))
(if (memv %%t535 '($module))
(%%interface?387
(%%binding-value217 %%b534))
(if (memv %%t535 '(lexical))
#f
(if (memv %%t535
'(global meta-variable))
(symbol? (%%binding-value217
%%b534))
(if (memv %%t535 '(syntax))
((lambda (%%x536)
(if (pair? %%x536)
(if #f
((lambda (%%n537)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (integer? %%n537)
(if (exact? %%n537) (>= %%n537 0) #f)
#f))
(cdr %%x536))
#f)
#f))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%binding-value217
%%b534))
(if (memv %%t535
'(begin
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
define
define-syntax
set!
$module-key
$import
eval-when
meta))
(null? (%%binding-value217 %%b534))
(if (memv %%t535 '(local-syntax))
(boolean? (%%binding-value217 %%b534))
(if (memv %%t535 '(displaced-lexical))
(eq? (%%binding-value217 %%b534) #f)
#t)))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%binding-type216 %%b534))
%%b534
#f)
#f))))
(%%binding-type216 car)
(%%binding-value217 cdr)
(%%set-binding-type!218 set-car!)
(%%set-binding-value!219 set-cdr!)
(%%binding?220
(lambda (%%x538) (if (pair? %%x538) (symbol? (car %%x538)) #f)))
(%%extend-env230
(lambda (%%label539 %%binding540 %%r541)
(cons (cons %%label539 %%binding540) %%r541)))
(%%extend-env*231
(lambda (%%labels542 %%bindings543 %%r544)
(if (null? %%labels542)
%%r544
(%%extend-env*231
(cdr %%labels542)
(cdr %%bindings543)
(%%extend-env230
(car %%labels542)
(car %%bindings543)
%%r544)))))
(%%extend-var-env*232
(lambda (%%labels545 %%vars546 %%r547)
(if (null? %%labels545)
%%r547
(%%extend-var-env*232
(cdr %%labels545)
(cdr %%vars546)
(%%extend-env230
(car %%labels545)
(cons 'lexical (car %%vars546))
%%r547)))))
(%%displaced-lexical?233
(lambda (%%id548 %%r549)
((lambda (%%n550)
(if %%n550
((lambda (%%b551)
(eq? (%%binding-type216 %%b551) 'displaced-lexical))
(%%lookup236 %%n550 %%r549))
#f))
(%%id-var-name369 %%id548 '(())))))
(%%displaced-lexical-error234
(lambda (%%id552)
(syntax-error
%%id552
(if (%%id-var-name369 %%id552 '(()))
"identifier out of context"
"identifier not visible"))))
(%%lookup*235
(lambda (%%x553 %%r554)
((lambda (%%t555)
(if %%t555
(cdr %%t555)
(if (symbol? %%x553)
((lambda (%%t556)
(if %%t556 %%t556 (cons 'global %%x553)))
(%%get-global-definition-hook73 %%x553))
'(displaced-lexical . #f))))
(assq %%x553 %%r554))))
(%%lookup236
(lambda (%%x557 %%r558)
(letrec ((%%whack-binding!559
(lambda (%%b560 %%*b561)
(begin
(%%set-binding-type!218
%%b560
(%%binding-type216 %%*b561))
(%%set-binding-value!219
%%b560
(%%binding-value217 %%*b561))))))
((lambda (%%b562)
(begin
(if (eq? (%%binding-type216 %%b562) 'deferred)
(%%whack-binding!559
%%b562
(%%make-transformer-binding237
((%%binding-value217 %%b562))))
(void))
%%b562))
(%%lookup*235 %%x557 %%r558)))))
(%%make-transformer-binding237
(lambda (%%b563)
((lambda (%%t564)
(if %%t564
%%t564
(syntax-error %%b563 "invalid transformer")))
(%%sanitize-binding206 %%b563))))
(%%defer-or-eval-transformer238
(lambda (%%eval565 %%x566)
(if (%%built-lambda?152 %%x566)
(cons 'deferred (lambda () (%%eval565 %%x566)))
(%%make-transformer-binding237 (%%eval565 %%x566)))))
(%%global-extend239
(lambda (%%type567 %%sym568 %%val569)
(%%put-cte-hook72 %%sym568 (cons %%type567 %%val569))))
(%%nonsymbol-id?240
(lambda (%%x570)
(if (%%syntax-object?64 %%x570)
(symbol? ((lambda (%%e571)
(if (annotation? %%e571)
(annotation-expression %%e571)
%%e571))
(%%syntax-object-expression65 %%x570)))
#f)))
(%%id?241
(lambda (%%x572)
(if (symbol? %%x572)
#t
(if (%%syntax-object?64 %%x572)
(symbol? ((lambda (%%e573)
(if (annotation? %%e573)
(annotation-expression %%e573)
%%e573))
(%%syntax-object-expression65 %%x572)))
(if (annotation? %%x572)
(symbol? (annotation-expression %%x572))
#f)))))
(%%id-marks247
(lambda (%%id574)
(if (%%syntax-object?64 %%id574)
(%%wrap-marks251 (%%syntax-object-wrap66 %%id574))
(%%wrap-marks251 '((top))))))
(%%id-subst248
(lambda (%%id575)
(if (%%syntax-object?64 %%id575)
(%%wrap-subst252 (%%syntax-object-wrap66 %%id575))
(%%wrap-marks251 '((top))))))
(%%id-sym-name&marks249
(lambda (%%x576 %%w577)
(if (%%syntax-object?64 %%x576)
(values ((lambda (%%e578)
(if (annotation? %%e578)
(annotation-expression %%e578)
%%e578))
(%%syntax-object-expression65 %%x576))
(%%join-marks358
(%%wrap-marks251 %%w577)
(%%wrap-marks251
(%%syntax-object-wrap66 %%x576))))
(values ((lambda (%%e579)
(if (annotation? %%e579)
(annotation-expression %%e579)
%%e579))
%%x576)
(%%wrap-marks251 %%w577)))))
(%%make-wrap250 cons)
(%%wrap-marks251 car)
(%%wrap-subst252 cdr)
(%%make-indirect-label290
(lambda (%%label580) (vector 'indirect-label %%label580)))
(%%indirect-label?291
(lambda (%%x581)
(if (vector? %%x581)
(if (= (vector-length %%x581) 2)
(eq? (vector-ref %%x581 0) 'indirect-label)
#f)
#f)))
(%%indirect-label-label292
(lambda (%%x582) (vector-ref %%x582 1)))
(%%set-indirect-label-label!293
(lambda (%%x583 %%update584)
(vector-set! %%x583 1 %%update584)))
(%%gen-indirect-label294
(lambda () (%%make-indirect-label290 (%%gen-label297))))
(%%get-indirect-label295
(lambda (%%x585) (%%indirect-label-label292 %%x585)))
(%%set-indirect-label!296
(lambda (%%x586 %%v587)
(%%set-indirect-label-label!293 %%x586 %%v587)))
(%%gen-label297 (lambda () (string #\i)))
(%%label?298
(lambda (%%x588)
((lambda (%%t589)
(if %%t589
%%t589
((lambda (%%t590)
(if %%t590 %%t590 (%%indirect-label?291 %%x588)))
(symbol? %%x588))))
(string? %%x588))))
(%%gen-labels299
(lambda (%%ls591)
(if (null? %%ls591)
'()
(cons (%%gen-label297) (%%gen-labels299 (cdr %%ls591))))))
(%%make-ribcage300
(lambda (%%symnames592 %%marks593 %%labels594)
(vector 'ribcage %%symnames592 %%marks593 %%labels594)))
(%%ribcage?301
(lambda (%%x595)
(if (vector? %%x595)
(if (= (vector-length %%x595) 4)
(eq? (vector-ref %%x595 0) 'ribcage)
#f)
#f)))
(%%ribcage-symnames302 (lambda (%%x596) (vector-ref %%x596 1)))
(%%ribcage-marks303 (lambda (%%x597) (vector-ref %%x597 2)))
(%%ribcage-labels304 (lambda (%%x598) (vector-ref %%x598 3)))
(%%set-ribcage-symnames!305
(lambda (%%x599 %%update600)
(vector-set! %%x599 1 %%update600)))
(%%set-ribcage-marks!306
(lambda (%%x601 %%update602)
(vector-set! %%x601 2 %%update602)))
(%%set-ribcage-labels!307
(lambda (%%x603 %%update604)
(vector-set! %%x603 3 %%update604)))
(%%make-top-ribcage308
(lambda (%%key605 %%mutable?606)
(vector 'top-ribcage %%key605 %%mutable?606)))
(%%top-ribcage?309
(lambda (%%x607)
(if (vector? %%x607)
(if (= (vector-length %%x607) 3)
(eq? (vector-ref %%x607 0) 'top-ribcage)
#f)
#f)))
(%%top-ribcage-key310 (lambda (%%x608) (vector-ref %%x608 1)))
(%%top-ribcage-mutable?311
(lambda (%%x609) (vector-ref %%x609 2)))
(%%set-top-ribcage-key!312
(lambda (%%x610 %%update611)
(vector-set! %%x610 1 %%update611)))
(%%set-top-ribcage-mutable?!313
(lambda (%%x612 %%update613)
(vector-set! %%x612 2 %%update613)))
(%%make-import-interface314
(lambda (%%interface614 %%new-marks615)
(vector 'import-interface %%interface614 %%new-marks615)))
(%%import-interface?315
(lambda (%%x616)
(if (vector? %%x616)
(if (= (vector-length %%x616) 3)
(eq? (vector-ref %%x616 0) 'import-interface)
#f)
#f)))
(%%import-interface-interface316
(lambda (%%x617) (vector-ref %%x617 1)))
(%%import-interface-new-marks317
(lambda (%%x618) (vector-ref %%x618 2)))
(%%set-import-interface-interface!318
(lambda (%%x619 %%update620)
(vector-set! %%x619 1 %%update620)))
(%%set-import-interface-new-marks!319
(lambda (%%x621 %%update622)
(vector-set! %%x621 2 %%update622)))
(%%make-env320
(lambda (%%top-ribcage623 %%wrap624)
(vector 'env %%top-ribcage623 %%wrap624)))
(%%env?321
(lambda (%%x625)
(if (vector? %%x625)
(if (= (vector-length %%x625) 3)
(eq? (vector-ref %%x625 0) 'env)
#f)
#f)))
(%%env-top-ribcage322 (lambda (%%x626) (vector-ref %%x626 1)))
(%%env-wrap323 (lambda (%%x627) (vector-ref %%x627 2)))
(%%set-env-top-ribcage!324
(lambda (%%x628 %%update629)
(vector-set! %%x628 1 %%update629)))
(%%set-env-wrap!325
(lambda (%%x630 %%update631)
(vector-set! %%x630 2 %%update631)))
(%%anti-mark335
(lambda (%%w632)
(%%make-wrap250
(cons #f (%%wrap-marks251 %%w632))
(cons 'shift (%%wrap-subst252 %%w632)))))
(%%barrier-marker340 #f)
(%%extend-ribcage!345
(lambda (%%ribcage633 %%id634 %%label635)
(begin
(%%set-ribcage-symnames!305
%%ribcage633
(cons ((lambda (%%e636)
(if (annotation? %%e636)
(annotation-expression %%e636)
%%e636))
(%%syntax-object-expression65 %%id634))
(%%ribcage-symnames302 %%ribcage633)))
(%%set-ribcage-marks!306
%%ribcage633
(cons (%%wrap-marks251 (%%syntax-object-wrap66 %%id634))
(%%ribcage-marks303 %%ribcage633)))
(%%set-ribcage-labels!307
%%ribcage633
(cons %%label635 (%%ribcage-labels304 %%ribcage633))))))
(%%import-extend-ribcage!346
(lambda (%%ribcage637 %%new-marks638 %%id639 %%label640)
(begin
(%%set-ribcage-symnames!305
%%ribcage637
(cons ((lambda (%%e641)
(if (annotation? %%e641)
(annotation-expression %%e641)
%%e641))
(%%syntax-object-expression65 %%id639))
(%%ribcage-symnames302 %%ribcage637)))
(%%set-ribcage-marks!306
%%ribcage637
(cons (%%join-marks358
%%new-marks638
(%%wrap-marks251 (%%syntax-object-wrap66 %%id639)))
(%%ribcage-marks303 %%ribcage637)))
(%%set-ribcage-labels!307
%%ribcage637
(cons %%label640 (%%ribcage-labels304 %%ribcage637))))))
(%%extend-ribcage-barrier!347
(lambda (%%ribcage642 %%killer-id643)
(%%extend-ribcage-barrier-help!348
%%ribcage642
(%%syntax-object-wrap66 %%killer-id643))))
(%%extend-ribcage-barrier-help!348
(lambda (%%ribcage644 %%wrap645)
(begin
(%%set-ribcage-symnames!305
%%ribcage644
(cons %%barrier-marker340
(%%ribcage-symnames302 %%ribcage644)))
(%%set-ribcage-marks!306
%%ribcage644
(cons (%%wrap-marks251 %%wrap645)
(%%ribcage-marks303 %%ribcage644))))))
(%%extend-ribcage-subst!349
(lambda (%%ribcage646 %%import-iface647)
(%%set-ribcage-symnames!305
%%ribcage646
(cons %%import-iface647
(%%ribcage-symnames302 %%ribcage646)))))
(%%lookup-import-binding-name350
(lambda (%%sym648 %%marks649 %%token650 %%new-marks651)
((lambda (%%new652)
(if %%new652
((letrec ((%%f653 (lambda (%%new654)
(if (pair? %%new654)
((lambda (%%t655)
(if %%t655
%%t655
(%%f653 (cdr %%new654))))
(%%f653 (car %%new654)))
(if (symbol? %%new654)
(if (%%same-marks?360
%%marks649
(%%join-marks358
%%new-marks651
(%%wrap-marks251
'((top)))))
%%new654
#f)
(if (%%same-marks?360
%%marks649
(%%join-marks358
%%new-marks651
(%%wrap-marks251
(%%syntax-object-wrap66
%%new654))))
%%new654
#f))))))
%%f653)
%%new652)
#f))
(%%get-import-binding76 %%sym648 %%token650))))
(%%store-import-binding351
(lambda (%%id656 %%token657 %%new-marks658)
(letrec ((%%cons-id659
(lambda (%%id661 %%x662)
(if (not %%x662) %%id661 (cons %%id661 %%x662))))
(%%weed660
(lambda (%%marks663 %%x664)
(if (pair? %%x664)
(if (%%same-marks?360
(%%id-marks247 (car %%x664))
%%marks663)
(%%weed660 %%marks663 (cdr %%x664))
(%%cons-id659
(car %%x664)
(%%weed660 %%marks663 (cdr %%x664))))
(if %%x664
(if (not (%%same-marks?360
(%%id-marks247 %%x664)
%%marks663))
%%x664
#f)
#f)))))
((lambda (%%id665)
((lambda (%%sym666)
(if (not (eq? %%id665 %%sym666))
((lambda (%%marks667)
(%%update-import-binding!77
%%sym666
%%token657
(lambda (%%old-binding668)
((lambda (%%x669)
(%%cons-id659
(if (%%same-marks?360
%%marks667
(%%wrap-marks251 '((top))))
(%%resolved-id-var-name355 %%id665)
%%id665)
%%x669))
(%%weed660 %%marks667 %%old-binding668)))))
(%%id-marks247 %%id665))
(void)))
((lambda (%%x670)
((lambda (%%e671)
(if (annotation? %%e671)
(annotation-expression %%e671)
%%e671))
(if (%%syntax-object?64 %%x670)
(%%syntax-object-expression65 %%x670)
%%x670)))
%%id665)))
(if (null? %%new-marks658)
%%id656
(%%make-syntax-object63
((lambda (%%x672)
((lambda (%%e673)
(if (annotation? %%e673)
(annotation-expression %%e673)
%%e673))
(if (%%syntax-object?64 %%x672)
(%%syntax-object-expression65 %%x672)
%%x672)))
%%id656)
(%%make-wrap250
(%%join-marks358
%%new-marks658
(%%id-marks247 %%id656))
(%%id-subst248 %%id656))))))))
(%%make-binding-wrap352
(lambda (%%ids674 %%labels675 %%w676)
(if (null? %%ids674)
%%w676
(%%make-wrap250
(%%wrap-marks251 %%w676)
(cons ((lambda (%%labelvec677)
((lambda (%%n678)
((lambda (%%symnamevec679 %%marksvec680)
(begin
((letrec ((%%f681 (lambda (%%ids682
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%i683)
(if (not (null? %%ids682))
(call-with-values
(lambda ()
(%%id-sym-name&marks249 (car %%ids682) %%w676))
(lambda (%%symname684 %%marks685)
(begin
(vector-set! %%symnamevec679 %%i683 %%symname684)
(vector-set! %%marksvec680 %%i683 %%marks685)
(%%f681 (cdr %%ids682) (fx+ %%i683 1)))))
(void)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f681)
%%ids674
0)
(%%make-ribcage300
%%symnamevec679
%%marksvec680
%%labelvec677)))
(make-vector %%n678)
(make-vector %%n678)))
(vector-length %%labelvec677)))
(list->vector %%labels675))
(%%wrap-subst252 %%w676))))))
(%%make-resolved-id353
(lambda (%%fromsym686 %%marks687 %%tosym688)
(%%make-syntax-object63
%%fromsym686
(%%make-wrap250
%%marks687
(list (%%make-ribcage300
(vector %%fromsym686)
(vector %%marks687)
(vector %%tosym688)))))))
(%%id->resolved-id354
(lambda (%%id689)
(call-with-values
(lambda () (%%id-var-name&marks367 %%id689 '(())))
(lambda (%%tosym690 %%marks691)
(begin
(if (not %%tosym690)
(syntax-error
%%id689
"identifier not visible for export")
(void))
(%%make-resolved-id353
((lambda (%%x692)
((lambda (%%e693)
(if (annotation? %%e693)
(annotation-expression %%e693)
%%e693))
(if (%%syntax-object?64 %%x692)
(%%syntax-object-expression65 %%x692)
%%x692)))
%%id689)
%%marks691
%%tosym690))))))
(%%resolved-id-var-name355
(lambda (%%id694)
(vector-ref
(%%ribcage-labels304
(car (%%wrap-subst252 (%%syntax-object-wrap66 %%id694))))
0)))
(%%smart-append356
(lambda (%%m1695 %%m2696)
(if (null? %%m2696) %%m1695 (append %%m1695 %%m2696))))
(%%join-wraps357
(lambda (%%w1697 %%w2698)
((lambda (%%m1699 %%s1700)
(if (null? %%m1699)
(if (null? %%s1700)
%%w2698
(%%make-wrap250
(%%wrap-marks251 %%w2698)
(%%join-subst359
%%s1700
(%%wrap-subst252 %%w2698))))
(%%make-wrap250
(%%join-marks358 %%m1699 (%%wrap-marks251 %%w2698))
(%%join-subst359 %%s1700 (%%wrap-subst252 %%w2698)))))
(%%wrap-marks251 %%w1697)
(%%wrap-subst252 %%w1697))))
(%%join-marks358
(lambda (%%m1701 %%m2702) (%%smart-append356 %%m1701 %%m2702)))
(%%join-subst359
(lambda (%%s1703 %%s2704) (%%smart-append356 %%s1703 %%s2704)))
(%%same-marks?360
(lambda (%%x705 %%y706)
((lambda (%%t707)
(if %%t707
%%t707
(if (not (null? %%x705))
(if (not (null? %%y706))
(if (eq? (car %%x705) (car %%y706))
(%%same-marks?360
(cdr %%x705)
(cdr %%y706))
#f)
#f)
#f)))
(eq? %%x705 %%y706))))
(%%diff-marks361
(lambda (%%m1708 %%m2709)
((lambda (%%n1710 %%n2711)
((letrec ((%%f712 (lambda (%%n1713 %%m1714)
(if (> %%n1713 %%n2711)
(cons (car %%m1714)
(%%f712 (- %%n1713 1)
(cdr %%m1714)))
(if (equal? %%m1714 %%m2709)
'()
(error "internal error in diff-marks"
%%m1714
%%m2709))))))
%%f712)
%%n1710
%%m1708))
(length %%m1708)
(length %%m2709))))
(%%leave-implicit?362
(lambda (%%token715) (eq? %%token715 '*top*)))
(%%new-binding363
(lambda (%%sym716 %%marks717 %%token718)
((lambda (%%loc719)
((lambda (%%id720)
(begin
(%%store-import-binding351 %%id720 %%token718 '())
(values %%loc719 %%id720)))
(%%make-resolved-id353 %%sym716 %%marks717 %%loc719)))
(if (if (%%leave-implicit?362 %%token718)
(%%same-marks?360
%%marks717
(%%wrap-marks251 '((top))))
#f)
%%sym716
(%%generate-id78 %%sym716)))))
(%%top-id-bound-var-name364
(lambda (%%sym721 %%marks722 %%top-ribcage723)
((lambda (%%token724)
((lambda (%%t725)
(if %%t725
((lambda (%%id726)
(if (symbol? %%id726)
(if (%%read-only-binding?75 %%id726)
(%%new-binding363
%%sym721
%%marks722
%%token724)
(values %%id726
(%%make-resolved-id353
%%sym721
%%marks722
%%id726)))
(values (%%resolved-id-var-name355 %%id726)
%%id726)))
%%t725)
(%%new-binding363 %%sym721 %%marks722 %%token724)))
(%%lookup-import-binding-name350
%%sym721
%%marks722
%%token724
'())))
(%%top-ribcage-key310 %%top-ribcage723))))
(%%top-id-free-var-name365
(lambda (%%sym727 %%marks728 %%top-ribcage729)
((lambda (%%token730)
((lambda (%%t731)
(if %%t731
((lambda (%%id732)
(if (symbol? %%id732)
%%id732
(%%resolved-id-var-name355 %%id732)))
%%t731)
(if (if (%%top-ribcage-mutable?311 %%top-ribcage729)
(%%same-marks?360
%%marks728
(%%wrap-marks251 '((top))))
#f)
(call-with-values
(lambda ()
(%%new-binding363
%%sym727
(%%wrap-marks251 '((top)))
%%token730))
(lambda (%%sym733 %%id734) %%sym733))
#f)))
(%%lookup-import-binding-name350
%%sym727
%%marks728
%%token730
'())))
(%%top-ribcage-key310 %%top-ribcage729))))
(%%id-var-name-loc&marks366
(lambda (%%id735 %%w736)
(letrec ((%%search737
(lambda (%%sym740 %%subst741 %%marks742)
(if (null? %%subst741)
(values #f %%marks742)
((lambda (%%fst743)
(if (eq? %%fst743 'shift)
(%%search737
%%sym740
(cdr %%subst741)
(cdr %%marks742))
(if (%%ribcage?301 %%fst743)
((lambda (%%symnames744)
(if (vector? %%symnames744)
(%%search-vector-rib739
%%sym740
%%subst741
%%marks742
%%symnames744
%%fst743)
(%%search-list-rib738
%%sym740
%%subst741
%%marks742
%%symnames744
%%fst743)))
(%%ribcage-symnames302 %%fst743))
(if (%%top-ribcage?309 %%fst743)
((lambda (%%t745)
(if %%t745
((lambda (%%var-name746)
(values %%var-name746
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%marks742))
%%t745)
(%%search737 %%sym740 (cdr %%subst741) %%marks742)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%top-id-free-var-name365
%%sym740
%%marks742
%%fst743))
(error "internal error in id-var-name-loc&marks: improper subst"
%%subst741)))))
(car %%subst741)))))
(%%search-list-rib738
(lambda (%%sym747
%%subst748
%%marks749
%%symnames750
%%ribcage751)
((letrec ((%%f752 (lambda (%%symnames753 %%i754)
(if (null? %%symnames753)
(%%search737
%%sym747
(cdr %%subst748)
%%marks749)
((lambda (%%x755)
(if (if (eq? %%x755
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%sym747)
(%%same-marks?360
%%marks749
(list-ref (%%ribcage-marks303 %%ribcage751) %%i754))
#f)
(values (list-ref
(%%ribcage-labels304 %%ribcage751)
%%i754)
%%marks749)
(if (%%import-interface?315 %%x755)
((lambda (%%iface756 %%new-marks757)
((lambda (%%t758)
(if %%t758
((lambda (%%token759)
((lambda (%%t760)
(if %%t760
((lambda (%%id761)
(values (if (symbol? %%id761)
%%id761
(%%resolved-id-var-name355
%%id761))
%%marks749))
%%t760)
(%%f752 (cdr %%symnames753)
%%i754)))
(%%lookup-import-binding-name350
%%sym747
%%marks749
%%token759
%%new-marks757)))
%%t758)
((lambda (%%ie762)
((lambda (%%n763)
((lambda ()
((letrec ((%%g764 (lambda (%%j765)
(if (fx= %%j765
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%n763)
(%%f752 (cdr %%symnames753) %%i754)
((lambda (%%id766)
((lambda (%%id.sym767 %%id.marks768)
(if (%%help-bound-id=?372
%%id.sym767
%%id.marks768
%%sym747
%%marks749)
(values (%%lookup-import-label441 %%id766)
%%marks749)
(%%g764 (fx+ %%j765 1))))
((lambda (%%x769)
((lambda (%%e770)
(if (annotation? %%e770)
(annotation-expression %%e770)
%%e770))
(if (%%syntax-object?64 %%x769)
(%%syntax-object-expression65 %%x769)
%%x769)))
%%id766)
(%%join-marks358
%%new-marks757
(%%id-marks247 %%id766))))
(vector-ref %%ie762 %%j765))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%g764)
0))))
(vector-length %%ie762)))
(%%interface-exports389 %%iface756))))
(%%interface-token390 %%iface756)))
(%%import-interface-interface316 %%x755)
(%%import-interface-new-marks317 %%x755))
(if (if (eq? %%x755 %%barrier-marker340)
(%%same-marks?360
%%marks749
(list-ref
(%%ribcage-marks303 %%ribcage751)
%%i754))
#f)
(values #f %%marks749)
(%%f752 (cdr %%symnames753) (fx+ %%i754 1))))))
(car %%symnames753))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f752)
%%symnames750
0)))
(%%search-vector-rib739
(lambda (%%sym771
%%subst772
%%marks773
%%symnames774
%%ribcage775)
((lambda (%%n776)
((letrec ((%%f777 (lambda (%%i778)
(if (fx= %%i778 %%n776)
(%%search737
%%sym771
(cdr %%subst772)
%%marks773)
(if (if (eq? (vector-ref
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%symnames774
%%i778)
%%sym771)
(%%same-marks?360
%%marks773
(vector-ref (%%ribcage-marks303 %%ribcage775) %%i778))
#f)
(values (vector-ref
(%%ribcage-labels304 %%ribcage775)
%%i778)
%%marks773)
(%%f777 (fx+ %%i778 1)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f777)
0))
(vector-length %%symnames774)))))
(if (symbol? %%id735)
(%%search737
%%id735
(%%wrap-subst252 %%w736)
(%%wrap-marks251 %%w736))
(if (%%syntax-object?64 %%id735)
((lambda (%%sym779 %%w1780)
(call-with-values
(lambda ()
(%%search737
%%sym779
(%%wrap-subst252 %%w736)
(%%join-marks358
(%%wrap-marks251 %%w736)
(%%wrap-marks251 %%w1780))))
(lambda (%%name781 %%marks782)
(if %%name781
(values %%name781 %%marks782)
(%%search737
%%sym779
(%%wrap-subst252 %%w1780)
%%marks782)))))
((lambda (%%e783)
(if (annotation? %%e783)
(annotation-expression %%e783)
%%e783))
(%%syntax-object-expression65 %%id735))
(%%syntax-object-wrap66 %%id735))
(if (annotation? %%id735)
(%%search737
((lambda (%%e784)
(if (annotation? %%e784)
(annotation-expression %%e784)
%%e784))
%%id735)
(%%wrap-subst252 %%w736)
(%%wrap-marks251 %%w736))
(error "(in id-var-name) invalid id"
%%id735)))))))
(%%id-var-name&marks367
(lambda (%%id785 %%w786)
(call-with-values
(lambda () (%%id-var-name-loc&marks366 %%id785 %%w786))
(lambda (%%label787 %%marks788)
(values (if (%%indirect-label?291 %%label787)
(%%get-indirect-label295 %%label787)
%%label787)
%%marks788)))))
(%%id-var-name-loc368
(lambda (%%id789 %%w790)
(call-with-values
(lambda () (%%id-var-name-loc&marks366 %%id789 %%w790))
(lambda (%%label791 %%marks792) %%label791))))
(%%id-var-name369
(lambda (%%id793 %%w794)
(call-with-values
(lambda () (%%id-var-name-loc&marks366 %%id793 %%w794))
(lambda (%%label795 %%marks796)
(if (%%indirect-label?291 %%label795)
(%%get-indirect-label295 %%label795)
%%label795)))))
(%%free-id=?370
(lambda (%%i797 %%j798)
(if (eq? ((lambda (%%x799)
((lambda (%%e800)
(if (annotation? %%e800)
(annotation-expression %%e800)
%%e800))
(if (%%syntax-object?64 %%x799)
(%%syntax-object-expression65 %%x799)
%%x799)))
%%i797)
((lambda (%%x801)
((lambda (%%e802)
(if (annotation? %%e802)
(annotation-expression %%e802)
%%e802))
(if (%%syntax-object?64 %%x801)
(%%syntax-object-expression65 %%x801)
%%x801)))
%%j798))
(eq? (%%id-var-name369 %%i797 '(()))
(%%id-var-name369 %%j798 '(())))
#f)))
(%%literal-id=?371
(lambda (%%id803 %%literal804)
(if (eq? ((lambda (%%x805)
((lambda (%%e806)
(if (annotation? %%e806)
(annotation-expression %%e806)
%%e806))
(if (%%syntax-object?64 %%x805)
(%%syntax-object-expression65 %%x805)
%%x805)))
%%id803)
((lambda (%%x807)
((lambda (%%e808)
(if (annotation? %%e808)
(annotation-expression %%e808)
%%e808))
(if (%%syntax-object?64 %%x807)
(%%syntax-object-expression65 %%x807)
%%x807)))
%%literal804))
((lambda (%%n-id809 %%n-literal810)
((lambda (%%t811)
(if %%t811
%%t811
(if ((lambda (%%t812)
(if %%t812 %%t812 (symbol? %%n-id809)))
(not %%n-id809))
((lambda (%%t813)
(if %%t813
%%t813
(symbol? %%n-literal810)))
(not %%n-literal810))
#f)))
(eq? %%n-id809 %%n-literal810)))
(%%id-var-name369 %%id803 '(()))
(%%id-var-name369 %%literal804 '(())))
#f)))
(%%help-bound-id=?372
(lambda (%%i.sym814 %%i.marks815 %%j.sym816 %%j.marks817)
(if (eq? %%i.sym814 %%j.sym816)
(%%same-marks?360 %%i.marks815 %%j.marks817)
#f)))
(%%bound-id=?373
(lambda (%%i818 %%j819)
(%%help-bound-id=?372
((lambda (%%x820)
((lambda (%%e821)
(if (annotation? %%e821)
(annotation-expression %%e821)
%%e821))
(if (%%syntax-object?64 %%x820)
(%%syntax-object-expression65 %%x820)
%%x820)))
%%i818)
(%%id-marks247 %%i818)
((lambda (%%x822)
((lambda (%%e823)
(if (annotation? %%e823)
(annotation-expression %%e823)
%%e823))
(if (%%syntax-object?64 %%x822)
(%%syntax-object-expression65 %%x822)
%%x822)))
%%j819)
(%%id-marks247 %%j819))))
(%%valid-bound-ids?374
(lambda (%%ids824)
(if ((letrec ((%%all-ids?825
(lambda (%%ids826)
((lambda (%%t827)
(if %%t827
%%t827
(if (%%id?241 (car %%ids826))
(%%all-ids?825 (cdr %%ids826))
#f)))
(null? %%ids826)))))
%%all-ids?825)
%%ids824)
(%%distinct-bound-ids?375 %%ids824)
#f)))
(%%distinct-bound-ids?375
(lambda (%%ids828)
((letrec ((%%distinct?829
(lambda (%%ids830)
((lambda (%%t831)
(if %%t831
%%t831
(if (not (%%bound-id-member?377
(car %%ids830)
(cdr %%ids830)))
(%%distinct?829 (cdr %%ids830))
#f)))
(null? %%ids830)))))
%%distinct?829)
%%ids828)))
(%%invalid-ids-error376
(lambda (%%ids832 %%exp833 %%class834)
((letrec ((%%find835
(lambda (%%ids836 %%gooduns837)
(if (null? %%ids836)
(syntax-error %%exp833)
(if (%%id?241 (car %%ids836))
(if (%%bound-id-member?377
(car %%ids836)
%%gooduns837)
(syntax-error
(car %%ids836)
"duplicate "
%%class834)
(%%find835
(cdr %%ids836)
(cons (car %%ids836) %%gooduns837)))
(syntax-error
(car %%ids836)
"invalid "
%%class834))))))
%%find835)
%%ids832
'())))
(%%bound-id-member?377
(lambda (%%x838 %%list839)
(if (not (null? %%list839))
((lambda (%%t840)
(if %%t840
%%t840
(%%bound-id-member?377 %%x838 (cdr %%list839))))
(%%bound-id=?373 %%x838 (car %%list839)))
#f)))
(%%wrap378
(lambda (%%x841 %%w842)
(if (if (null? (%%wrap-marks251 %%w842))
(null? (%%wrap-subst252 %%w842))
#f)
%%x841
(if (%%syntax-object?64 %%x841)
(%%make-syntax-object63
(%%syntax-object-expression65 %%x841)
(%%join-wraps357
%%w842
(%%syntax-object-wrap66 %%x841)))
(if (null? %%x841)
%%x841
(%%make-syntax-object63 %%x841 %%w842))))))
(%%source-wrap379
(lambda (%%x843 %%w844 %%ae845)
(%%wrap378
(if (annotation? %%ae845)
(begin
(if (not (eq? (annotation-expression %%ae845) %%x843))
(error "internal error in source-wrap: ae/x mismatch")
(void))
%%ae845)
%%x843)
%%w844)))
(%%chi-when-list380
(lambda (%%when-list846 %%w847)
(map (lambda (%%x848)
(if (%%literal-id=?371
%%x848
'#(syntax-object
compile
((top)
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(when-list w)
#((top) (top))
#("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
'compile
(if (%%literal-id=?371
%%x848
'#(syntax-object
load
((top)
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(when-list w)
#((top) (top))
#("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
'load
(if (%%literal-id=?371
%%x848
'#(syntax-object
visit
((top)
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(when-list w)
#((top) (top))
#("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
'visit
(if (%%literal-id=?371
%%x848
'#(syntax-object
revisit
((top)
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(when-list w)
#((top) (top))
#("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
'revisit
(if (%%literal-id=?371
%%x848
'#(syntax-object
eval
((top)
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(when-list w)
#((top) (top))
#("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
'eval
(syntax-error
(%%wrap378 %%x848 %%w847)
"invalid eval-when situation")))))))
%%when-list846)))
(%%syntax-type381
(lambda (%%e849 %%r850 %%w851 %%ae852 %%rib853)
(if (symbol? %%e849)
((lambda (%%n854)
((lambda (%%b855)
((lambda (%%type856)
((lambda ()
((lambda (%%t857)
(if (memv %%t857 '(macro macro!))
(%%syntax-type381
(%%chi-macro437
(%%binding-value217 %%b855)
%%e849
%%r850
%%w851
%%ae852
%%rib853)
%%r850
'(())
#f
%%rib853)
(values %%type856
(%%binding-value217 %%b855)
%%e849
%%w851
%%ae852)))
%%type856))))
(%%binding-type216 %%b855)))
(%%lookup236 %%n854 %%r850)))
(%%id-var-name369 %%e849 %%w851))
(if (pair? %%e849)
((lambda (%%first858)
(if (%%id?241 %%first858)
((lambda (%%n859)
((lambda (%%b860)
((lambda (%%type861)
((lambda ()
((lambda (%%t862)
(if (memv %%t862 '(lexical))
(values 'lexical-call
(%%binding-value217
%%b860)
%%e849
%%w851
%%ae852)
(if (memv %%t862
'(macro macro!))
(%%syntax-type381
(%%chi-macro437
(%%binding-value217
%%b860)
%%e849
%%r850
%%w851
%%ae852
%%rib853)
%%r850
'(())
#f
%%rib853)
(if (memv %%t862
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'(core))
(values %%type861
(%%binding-value217 %%b860)
%%e849
%%w851
%%ae852)
(if (memv %%t862 '(begin))
(values 'begin-form #f %%e849 %%w851 %%ae852)
(if (memv %%t862 '(alias))
(values 'alias-form #f %%e849 %%w851 %%ae852)
(if (memv %%t862 '(define))
(values 'define-form #f %%e849 %%w851 %%ae852)
(if (memv %%t862 '(define-syntax))
(values 'define-syntax-form
#f
%%e849
%%w851
%%ae852)
(if (memv %%t862 '(set!))
(%%chi-set!436
%%e849
%%r850
%%w851
%%ae852
%%rib853)
(if (memv %%t862 '($module-key))
(values '$module-form
#f
%%e849
%%w851
%%ae852)
(if (memv %%t862 '($import))
(values '$import-form
#f
%%e849
%%w851
%%ae852)
(if (memv %%t862 '(eval-when))
(values 'eval-when-form
#f
%%e849
%%w851
%%ae852)
(if (memv %%t862 '(meta))
(values 'meta-form
#f
%%e849
%%w851
%%ae852)
(if (memv %%t862
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'(local-syntax))
(values 'local-syntax-form
(%%binding-value217 %%b860)
%%e849
%%w851
%%ae852)
(values 'call #f %%e849 %%w851 %%ae852)))))))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%type861))))
(%%binding-type216 %%b860)))
(%%lookup236 %%n859 %%r850)))
(%%id-var-name369 %%first858 %%w851))
(values 'call #f %%e849 %%w851 %%ae852)))
(car %%e849))
(if (%%syntax-object?64 %%e849)
(%%syntax-type381
(%%syntax-object-expression65 %%e849)
%%r850
(%%join-wraps357
%%w851
(%%syntax-object-wrap66 %%e849))
#f
%%rib853)
(if (annotation? %%e849)
(%%syntax-type381
(annotation-expression %%e849)
%%r850
%%w851
%%e849
%%rib853)
(if ((lambda (%%x863) (self-eval? %%x863))
%%e849)
(values 'constant
#f
%%e849
%%w851
%%ae852)
(values 'other
#f
%%e849
%%w851
%%ae852))))))))
(%%chi-top*382
(lambda (%%e864
%%r865
%%w866
%%ctem867
%%rtem868
%%meta?869
%%top-ribcage870)
((lambda (%%meta-residuals871)
(letrec ((%%meta-residualize!872
(lambda (%%x873)
(set! %%meta-residuals871
(cons %%x873 %%meta-residuals871)))))
((lambda (%%e874)
(%%build-sequence170
#f
(reverse (cons %%e874 %%meta-residuals871))))
(%%chi-top384
%%e864
%%r865
%%w866
%%ctem867
%%rtem868
%%meta?869
%%top-ribcage870
%%meta-residualize!872
#f))))
'())))
(%%chi-top-sequence383
(lambda (%%body875
%%r876
%%w877
%%ae878
%%ctem879
%%rtem880
%%meta?881
%%ribcage882
%%meta-residualize!883)
(%%build-sequence170
%%ae878
((letrec ((%%dobody884
(lambda (%%body885)
(if (null? %%body885)
'()
((lambda (%%first886)
(cons %%first886
(%%dobody884 (cdr %%body885))))
(%%chi-top384
(car %%body885)
%%r876
%%w877
%%ctem879
%%rtem880
%%meta?881
%%ribcage882
%%meta-residualize!883
#f))))))
%%dobody884)
%%body875))))
(%%chi-top384
(lambda (%%e887
%%r888
%%w889
%%ctem890
%%rtem891
%%meta?892
%%top-ribcage893
%%meta-residualize!894
%%meta-seen?895)
(call-with-values
(lambda ()
(%%syntax-type381
%%e887
%%r888
%%w889
#f
%%top-ribcage893))
(lambda (%%type896 %%value897 %%e898 %%w899 %%ae900)
((lambda (%%t901)
(if (memv %%t901 '(begin-form))
((lambda (%%forms902)
(if (null? %%forms902)
(%%chi-void453)
(%%chi-top-sequence383
%%forms902
%%r888
%%w899
%%ae900
%%ctem890
%%rtem891
%%meta?892
%%top-ribcage893
%%meta-residualize!894)))
(%%parse-begin450 %%e898 %%w899 %%ae900 #t))
(if (memv %%t901 '(local-syntax-form))
(call-with-values
(lambda ()
(%%chi-local-syntax452
%%value897
%%e898
%%r888
%%r888
%%w899
%%ae900))
(lambda (%%forms903
%%r904
%%mr905
%%w906
%%ae907)
(%%chi-top-sequence383
%%forms903
%%r904
%%w906
%%ae907
%%ctem890
%%rtem891
%%meta?892
%%top-ribcage893
%%meta-residualize!894)))
(if (memv %%t901 '(eval-when-form))
(call-with-values
(lambda ()
(%%parse-eval-when448
%%e898
%%w899
%%ae900))
(lambda (%%when-list908 %%forms909)
((lambda (%%ctem910 %%rtem911)
(if (if (null? %%ctem910)
(null? %%rtem911)
#f)
(%%chi-void453)
(%%chi-top-sequence383
%%forms909
%%r888
%%w899
%%ae900
%%ctem910
%%rtem911
%%meta?892
%%top-ribcage893
%%meta-residualize!894)))
(%%update-mode-set425
%%when-list908
%%ctem890)
(%%update-mode-set425
%%when-list908
%%rtem891))))
(if (memv %%t901 '(meta-form))
(%%chi-top384
(%%parse-meta447 %%e898 %%w899 %%ae900)
%%r888
%%w899
%%ctem890
%%rtem891
#t
%%top-ribcage893
%%meta-residualize!894
#t)
(if (memv %%t901 '(define-syntax-form))
(call-with-values
(lambda ()
(%%parse-define-syntax446
%%e898
%%w899
%%ae900))
(lambda (%%id912 %%rhs913 %%w914)
((lambda (%%id915)
(begin
(if (%%displaced-lexical?233
%%id915
%%r888)
(%%displaced-lexical-error234
%%id915)
(void))
(if (not (%%top-ribcage-mutable?311
%%top-ribcage893))
(syntax-error
(%%source-wrap379
%%e898
%%w914
%%ae900)
"invalid definition in read-only environment")
(void))
((lambda (%%sym916)
(call-with-values
(lambda ()
(%%top-id-bound-var-name364
%%sym916
(%%wrap-marks251
(%%syntax-object-wrap66
%%id915))
%%top-ribcage893))
(lambda (%%valsym917
%%bound-id918)
(begin
(if (not (eq? (%%id-var-name369
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%id915
'(()))
%%valsym917))
(syntax-error
(%%source-wrap379 %%e898 %%w914 %%ae900)
"definition not permitted")
(void))
(if (%%read-only-binding?75 %%valsym917)
(syntax-error
(%%source-wrap379 %%e898 %%w914 %%ae900)
"invalid definition of read-only identifier")
(void))
(%%ct-eval/residualize2428
%%ctem890
(lambda ()
(build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source #f %%bound-id918)))
(%%chi433 %%rhs913 %%r888 %%r888 %%w914 #t)
(build-source
#f
(list (build-source #f 'quote)
(%%top-ribcage-key310
%%top-ribcage893)))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%x919)
((lambda (%%e920)
(if (annotation?
%%e920)
(annotation-expression
%%e920)
%%e920))
(if (%%syntax-object?64
%%x919)
(%%syntax-object-expression65
%%x919)
%%x919)))
%%id915))))
(%%wrap378 %%id912 %%w914))))
(if (memv %%t901 '(define-form))
(call-with-values
(lambda ()
(%%parse-define445
%%e898
%%w899
%%ae900))
(lambda (%%id921
%%rhs922
%%w923)
((lambda (%%id924)
(begin
(if (%%displaced-lexical?233
%%id924
%%r888)
(%%displaced-lexical-error234
%%id924)
(void))
(if (not (%%top-ribcage-mutable?311
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%top-ribcage893))
(syntax-error
(%%source-wrap379 %%e898 %%w923 %%ae900)
"invalid definition in read-only environment")
(void))
((lambda (%%sym925)
(call-with-values
(lambda ()
(%%top-id-bound-var-name364
%%sym925
(%%wrap-marks251 (%%syntax-object-wrap66 %%id924))
%%top-ribcage893))
(lambda (%%valsym926 %%bound-id927)
(begin
(if (not (eq? (%%id-var-name369 %%id924 '(()))
%%valsym926))
(syntax-error
(%%source-wrap379 %%e898 %%w923 %%ae900)
"definition not permitted")
(void))
(if (%%read-only-binding?75 %%valsym926)
(syntax-error
(%%source-wrap379 %%e898 %%w923 %%ae900)
"invalid definition of read-only identifier")
(void))
(if %%meta?892
(%%ct-eval/residualize2428
%%ctem890
(lambda ()
(%%build-sequence170
#f
(list (build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source
#f
%%bound-id927)))
((lambda (%%x928)
(if (self-eval?
(cons 'meta-variable
%%valsym926))
%%x928
(build-source
#f
(list (build-source
#f
'quote)
%%x928))))
(attach-source
#f
(cons 'meta-variable
%%valsym926)))
(build-source
#f
(list (build-source #f 'quote)
(%%top-ribcage-key310
%%top-ribcage893)))))
(build-source
%%ae900
(list (build-source %%ae900 'define)
(build-source %%ae900 %%valsym926)
(%%chi433
%%rhs922
%%r888
%%r888
%%w923
#t)))))))
((lambda (%%x929)
(%%build-sequence170
#f
(list %%x929
(%%rt-eval/residualize427
%%rtem891
(lambda ()
(build-source
%%ae900
(list (build-source %%ae900 'define)
(build-source
%%ae900
%%valsym926)
(%%chi433
%%rhs922
%%r888
%%r888
%%w923
#f))))))))
(%%ct-eval/residualize2428
%%ctem890
(lambda ()
(build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source #f %%bound-id927)))
((lambda (%%x930)
(if (self-eval?
(cons 'global %%valsym926))
%%x930
(build-source
#f
(list (build-source #f 'quote)
%%x930))))
(attach-source
#f
(cons 'global %%valsym926)))
(build-source
#f
(list (build-source #f 'quote)
(%%top-ribcage-key310
%%top-ribcage893)))))))))))))
((lambda (%%x931)
((lambda (%%e932)
(if (annotation? %%e932)
(annotation-expression %%e932)
%%e932))
(if (%%syntax-object?64 %%x931)
(%%syntax-object-expression65 %%x931)
%%x931)))
%%id924))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%wrap378
%%id921
%%w923))))
(if (memv %%t901
'($module-form))
((lambda (%%ribcage933)
(call-with-values
(lambda ()
(%%parse-module443
%%e898
%%w899
%%ae900
(%%make-wrap250
(%%wrap-marks251
%%w899)
(cons %%ribcage933
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(%%wrap-subst252 %%w899)))))
(lambda (%%orig934 %%id935 %%exports936 %%forms937)
(begin
(if (%%displaced-lexical?233 %%id935 %%r888)
(%%displaced-lexical-error234
(%%wrap378 %%id935 %%w899))
(void))
(if (not (%%top-ribcage-mutable?311 %%top-ribcage893))
(syntax-error
%%orig934
"invalid definition in read-only environment")
(void))
(%%chi-top-module417
%%orig934
%%r888
%%r888
%%top-ribcage893
%%ribcage933
%%ctem890
%%rtem891
%%meta?892
%%id935
%%exports936
%%forms937
%%meta-residualize!894)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%make-ribcage300
'()
'()
'()))
(if (memv %%t901
'($import-form))
(call-with-values
(lambda ()
(%%parse-import444
%%e898
%%w899
%%ae900))
(lambda (%%orig938
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%only?939
%%mid940)
(begin
(if (not (%%top-ribcage-mutable?311 %%top-ribcage893))
(syntax-error
%%orig938
"invalid definition in read-only environment")
(void))
(%%ct-eval/residualize2428
%%ctem890
(lambda ()
((lambda (%%binding941)
((lambda (%%t942)
(if (memv %%t942 '($module))
(%%do-top-import424
%%only?939
%%top-ribcage893
%%mid940
(%%interface-token390
(%%binding-value217 %%binding941)))
(if (memv %%t942 '(displaced-lexical))
(%%displaced-lexical-error234 %%mid940)
(syntax-error
%%mid940
"unknown module"))))
(%%binding-type216 %%binding941)))
(%%lookup236
(%%id-var-name369 %%mid940 '(()))
'())))))))
(if (memv %%t901 '(alias-form))
(call-with-values
(lambda () (%%parse-alias449 %%e898 %%w899 %%ae900))
(lambda (%%new-id943 %%old-id944)
((lambda (%%new-id945)
(begin
(if (%%displaced-lexical?233 %%new-id945 %%r888)
(%%displaced-lexical-error234 %%new-id945)
(void))
(if (not (%%top-ribcage-mutable?311
%%top-ribcage893))
(syntax-error
(%%source-wrap379 %%e898 %%w899 %%ae900)
"invalid definition in read-only environment")
(void))
((lambda (%%sym946)
(call-with-values
(lambda ()
(%%top-id-bound-var-name364
%%sym946
(%%wrap-marks251
(%%syntax-object-wrap66 %%new-id945))
%%top-ribcage893))
(lambda (%%valsym947 %%bound-id948)
(begin
(if (not (eq? (%%id-var-name369
%%new-id945
'(()))
%%valsym947))
(syntax-error
(%%source-wrap379
%%e898
%%w899
%%ae900)
"definition not permitted")
(void))
(if (%%read-only-binding?75 %%valsym947)
(syntax-error
(%%source-wrap379
%%e898
%%w899
%%ae900)
"invalid definition of read-only identifier")
(void))
(%%ct-eval/residualize2428
%%ctem890
(lambda ()
(build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source
#f
(%%make-resolved-id353
%%sym946
(%%wrap-marks251
(%%syntax-object-wrap66
%%new-id945))
(%%id-var-name369
%%old-id944
%%w899)))))
((lambda (%%x949)
(if (self-eval?
'(do-alias . #f))
%%x949
(build-source
#f
(list (build-source
#f
'quote)
%%x949))))
(attach-source
#f
'(do-alias . #f)))
(build-source
#f
(list (build-source #f 'quote)
(%%top-ribcage-key310
%%top-ribcage893)))))))))))
((lambda (%%x950)
((lambda (%%e951)
(if (annotation? %%e951)
(annotation-expression %%e951)
%%e951))
(if (%%syntax-object?64 %%x950)
(%%syntax-object-expression65 %%x950)
%%x950)))
%%new-id945))))
(%%wrap378 %%new-id943 %%w899))))
(begin
(if %%meta-seen?895
(syntax-error
(%%source-wrap379 %%e898 %%w899 %%ae900)
"invalid meta definition")
(void))
(if %%meta?892
((lambda (%%x952)
(begin
(%%top-level-eval-hook69 %%x952)
(%%ct-eval/residualize3429
%%ctem890
void
(lambda () %%x952))))
(%%chi-expr434
%%type896
%%value897
%%e898
%%r888
%%r888
%%w899
%%ae900
#t))
(%%rt-eval/residualize427
%%rtem891
(lambda ()
(%%chi-expr434
%%type896
%%value897
%%e898
%%r888
%%r888
%%w899
%%ae900
#f)))))))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%type896)))))
(%%flatten-exports385
(lambda (%%exports953)
((letrec ((%%loop954
(lambda (%%exports955 %%ls956)
(if (null? %%exports955)
%%ls956
(%%loop954
(cdr %%exports955)
(if (pair? (car %%exports955))
(%%loop954 (car %%exports955) %%ls956)
(cons (car %%exports955) %%ls956)))))))
%%loop954)
%%exports953
'())))
(%%make-interface386
(lambda (%%marks957 %%exports958 %%token959)
(vector 'interface %%marks957 %%exports958 %%token959)))
(%%interface?387
(lambda (%%x960)
(if (vector? %%x960)
(if (= (vector-length %%x960) 4)
(eq? (vector-ref %%x960 0) 'interface)
#f)
#f)))
(%%interface-marks388 (lambda (%%x961) (vector-ref %%x961 1)))
(%%interface-exports389 (lambda (%%x962) (vector-ref %%x962 2)))
(%%interface-token390 (lambda (%%x963) (vector-ref %%x963 3)))
(%%set-interface-marks!391
(lambda (%%x964 %%update965)
(vector-set! %%x964 1 %%update965)))
(%%set-interface-exports!392
(lambda (%%x966 %%update967)
(vector-set! %%x966 2 %%update967)))
(%%set-interface-token!393
(lambda (%%x968 %%update969)
(vector-set! %%x968 3 %%update969)))
(%%make-unresolved-interface394
(lambda (%%mid970 %%exports971)
(%%make-interface386
(%%wrap-marks251 (%%syntax-object-wrap66 %%mid970))
(list->vector
(map (lambda (%%x972)
(if (pair? %%x972) (car %%x972) %%x972))
%%exports971))
#f)))
(%%make-resolved-interface395
(lambda (%%mid973 %%exports974 %%token975)
(%%make-interface386
(%%wrap-marks251 (%%syntax-object-wrap66 %%mid973))
(list->vector
(map (lambda (%%x976)
(%%id->resolved-id354
(if (pair? %%x976) (car %%x976) %%x976)))
%%exports974))
%%token975)))
(%%make-module-binding396
(lambda (%%type977
%%id978
%%label979
%%imps980
%%val981
%%exported982)
(vector 'module-binding
%%type977
%%id978
%%label979
%%imps980
%%val981
%%exported982)))
(%%module-binding?397
(lambda (%%x983)
(if (vector? %%x983)
(if (= (vector-length %%x983) 7)
(eq? (vector-ref %%x983 0) 'module-binding)
#f)
#f)))
(%%module-binding-type398
(lambda (%%x984) (vector-ref %%x984 1)))
(%%module-binding-id399 (lambda (%%x985) (vector-ref %%x985 2)))
(%%module-binding-label400
(lambda (%%x986) (vector-ref %%x986 3)))
(%%module-binding-imps401
(lambda (%%x987) (vector-ref %%x987 4)))
(%%module-binding-val402 (lambda (%%x988) (vector-ref %%x988 5)))
(%%module-binding-exported403
(lambda (%%x989) (vector-ref %%x989 6)))
(%%set-module-binding-type!404
(lambda (%%x990 %%update991)
(vector-set! %%x990 1 %%update991)))
(%%set-module-binding-id!405
(lambda (%%x992 %%update993)
(vector-set! %%x992 2 %%update993)))
(%%set-module-binding-label!406
(lambda (%%x994 %%update995)
(vector-set! %%x994 3 %%update995)))
(%%set-module-binding-imps!407
(lambda (%%x996 %%update997)
(vector-set! %%x996 4 %%update997)))
(%%set-module-binding-val!408
(lambda (%%x998 %%update999)
(vector-set! %%x998 5 %%update999)))
(%%set-module-binding-exported!409
(lambda (%%x1000 %%update1001)
(vector-set! %%x1000 6 %%update1001)))
(%%create-module-binding410
(lambda (%%type1002 %%id1003 %%label1004 %%imps1005 %%val1006)
(%%make-module-binding396
%%type1002
%%id1003
%%label1004
%%imps1005
%%val1006
#f)))
(%%make-frob411
(lambda (%%e1007 %%meta?1008)
(vector 'frob %%e1007 %%meta?1008)))
(%%frob?412
(lambda (%%x1009)
(if (vector? %%x1009)
(if (= (vector-length %%x1009) 3)
(eq? (vector-ref %%x1009 0) 'frob)
#f)
#f)))
(%%frob-e413 (lambda (%%x1010) (vector-ref %%x1010 1)))
(%%frob-meta?414 (lambda (%%x1011) (vector-ref %%x1011 2)))
(%%set-frob-e!415
(lambda (%%x1012 %%update1013)
(vector-set! %%x1012 1 %%update1013)))
(%%set-frob-meta?!416
(lambda (%%x1014 %%update1015)
(vector-set! %%x1014 2 %%update1015)))
(%%chi-top-module417
(lambda (%%orig1016
%%r1017
%%mr1018
%%top-ribcage1019
%%ribcage1020
%%ctem1021
%%rtem1022
%%meta?1023
%%id1024
%%exports1025
%%forms1026
%%meta-residualize!1027)
((lambda (%%fexports1028)
(call-with-values
(lambda ()
(%%chi-external421
%%ribcage1020
%%orig1016
(map (lambda (%%d1029)
(%%make-frob411 %%d1029 %%meta?1023))
%%forms1026)
%%r1017
%%mr1018
%%ctem1021
%%exports1025
%%fexports1028
%%meta-residualize!1027))
(lambda (%%r1030 %%mr1031 %%bindings1032 %%inits1033)
((letrec ((%%process-exports1034
(lambda (%%fexports1035 %%ctdefs1036)
(if (null? %%fexports1035)
((letrec ((%%process-locals1037
(lambda (%%bs1038
%%r1039
%%dts1040
%%dvs1041
%%des1042)
(if (null? %%bs1038)
((lambda (%%des1043
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%inits1044)
(%%build-sequence170
#f
(append (%%ctdefs1036)
(list (%%ct-eval/residualize2428
%%ctem1021
(lambda ()
((lambda (%%sym1045)
((lambda (%%token1046)
((lambda (%%b1047)
((lambda ()
(call-with-values
(lambda ()
(%%top-id-bound-var-name364
%%sym1045
(%%wrap-marks251
(%%syntax-object-wrap66
%%id1024))
%%top-ribcage1019))
(lambda (%%valsym1048
%%bound-id1049)
(begin
(if (not (eq? (%%id-var-name369
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%id1024
'(()))
%%valsym1048))
(syntax-error %%orig1016 "definition not permitted")
(void))
(if (%%read-only-binding?75 %%valsym1048)
(syntax-error
%%orig1016
"invalid definition of read-only identifier")
(void))
(build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source #f %%bound-id1049)))
%%b1047
(build-source
#f
(list (build-source #f 'quote)
(%%top-ribcage-key310 %%top-ribcage1019)))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%x1050)
(if (self-eval?
(cons '$module
(%%make-resolved-interface395
%%id1024
%%exports1025
%%token1046)))
%%x1050
(build-source
#f
(list (build-source
#f
'quote)
%%x1050))))
(attach-source
#f
(cons '$module
(%%make-resolved-interface395
%%id1024
%%exports1025
%%token1046))))))
(%%generate-id78 %%sym1045)))
((lambda (%%x1051)
((lambda (%%e1052)
(if (annotation? %%e1052)
(annotation-expression
%%e1052)
%%e1052))
(if (%%syntax-object?64 %%x1051)
(%%syntax-object-expression65
%%x1051)
%%x1051)))
%%id1024))))
(%%rt-eval/residualize427
%%rtem1022
(lambda ()
(%%build-top-module173
#f
%%dts1040
%%dvs1041
%%des1043
(if (null? %%inits1044)
(%%chi-void453)
(%%build-sequence170
#f
(append %%inits1044
(list (%%chi-void453))))))))))))
(%%chi-frobs430 %%des1042 %%r1039 %%mr1031 #f)
(%%chi-frobs430 %%inits1033 %%r1039 %%mr1031 #f))
((lambda (%%b1053 %%bs1054)
((lambda (%%t1055)
((lambda (%%t1056)
(if (memv %%t1056 '(define-form))
((lambda (%%label1057)
(if (%%module-binding-exported403 %%b1053)
((lambda (%%var1058)
(%%process-locals1037
%%bs1054
%%r1039
(cons 'global %%dts1040)
(cons %%label1057 %%dvs1041)
(cons (%%module-binding-val402
%%b1053)
%%des1042)))
(%%module-binding-id399 %%b1053))
((lambda (%%var1059)
(%%process-locals1037
%%bs1054
(%%extend-env230
%%label1057
(cons 'lexical %%var1059)
%%r1039)
(cons 'local %%dts1040)
(cons %%var1059 %%dvs1041)
(cons (%%module-binding-val402
%%b1053)
%%des1042)))
(%%gen-var458
(%%module-binding-id399 %%b1053)))))
(%%get-indirect-label295
(%%module-binding-label400 %%b1053)))
(if (memv %%t1056
'(ctdefine-form
define-syntax-form
$module-form
alias-form))
(%%process-locals1037
%%bs1054
%%r1039
%%dts1040
%%dvs1041
%%des1042)
(error "unexpected module binding type"
%%t1055))))
(%%module-binding-type398 %%b1053)))
(%%module-binding-type398 %%b1053)))
(car %%bs1038)
(cdr %%bs1038))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%process-locals1037)
%%bindings1032
%%r1030
'()
'()
'())
((lambda (%%id1060 %%fexports1061)
((letrec ((%%loop1062
(lambda (%%bs1063)
(if (null? %%bs1063)
(%%process-exports1034
%%fexports1061
%%ctdefs1036)
((lambda (%%b1064
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%bs1065)
(if (%%free-id=?370
(%%module-binding-id399 %%b1064)
%%id1060)
(if (%%module-binding-exported403 %%b1064)
(%%process-exports1034
%%fexports1061
%%ctdefs1036)
((lambda (%%t1066)
((lambda (%%label1067)
((lambda (%%imps1068)
((lambda (%%fexports1069)
((lambda ()
(begin
(%%set-module-binding-exported!409
%%b1064
#t)
((lambda (%%t1070)
(if (memv %%t1070
'(define-form))
((lambda (%%sym1071)
(begin
(%%set-indirect-label!296
%%label1067
%%sym1071)
(%%process-exports1034
%%fexports1069
%%ctdefs1036)))
(%%generate-id78
((lambda (%%x1072)
((lambda (%%e1073)
(if (annotation?
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e1073)
(annotation-expression %%e1073)
%%e1073))
(if (%%syntax-object?64 %%x1072)
(%%syntax-object-expression65 %%x1072)
%%x1072)))
%%id1060)))
(if (memv %%t1070 '(ctdefine-form))
((lambda (%%b1074)
(%%process-exports1034
%%fexports1069
(lambda ()
((lambda (%%sym1075)
(begin
(%%set-indirect-label!296 %%label1067 %%sym1075)
(cons (%%ct-eval/residualize3429
%%ctem1021
(lambda ()
(%%put-cte-hook72 %%sym1075 %%b1074))
(lambda ()
(build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source
#f
%%sym1075)))
((lambda (%%x1076)
(if (self-eval? %%b1074)
%%x1076
(build-source
#f
(list (build-source
#f
'quote)
%%x1076))))
(attach-source #f %%b1074))
(build-source
#f
(list (build-source #f 'quote)
#f))))))
(%%ctdefs1036))))
(%%binding-value217 %%b1074)))))
(%%module-binding-val402 %%b1064))
(if (memv %%t1070 '(define-syntax-form))
((lambda (%%sym1077)
(%%process-exports1034
%%fexports1069
(lambda ()
((lambda (%%local-label1078)
(begin
(%%set-indirect-label!296
%%label1067
%%sym1077)
(cons (%%ct-eval/residualize3429
%%ctem1021
(lambda ()
(%%put-cte-hook72
%%sym1077
(car (%%module-binding-val402
%%b1064))))
(lambda ()
(build-source
#f
(list (build-source
#f
'$sc-put-cte)
(build-source
#f
(list (build-source
#f
'quote)
(attach-source
#f
%%sym1077)))
(cdr (%%module-binding-val402
%%b1064))
(build-source
#f
(list (build-source
#f
'quote)
#f))))))
(%%ctdefs1036))))
(%%get-indirect-label295 %%label1067)))))
(%%generate-id78
((lambda (%%x1079)
((lambda (%%e1080)
(if (annotation? %%e1080)
(annotation-expression %%e1080)
%%e1080))
(if (%%syntax-object?64 %%x1079)
(%%syntax-object-expression65 %%x1079)
%%x1079)))
%%id1060)))
(if (memv %%t1070 '($module-form))
((lambda (%%sym1081 %%exports1082)
(%%process-exports1034
(append (%%flatten-exports385 %%exports1082)
%%fexports1069)
(lambda ()
(begin
(%%set-indirect-label!296
%%label1067
%%sym1081)
((lambda (%%rest1083)
((lambda (%%x1084)
(cons (%%ct-eval/residualize3429
%%ctem1021
(lambda ()
(%%put-cte-hook72
%%sym1081
%%x1084))
(lambda ()
(build-source
#f
(list (build-source
#f
'$sc-put-cte)
(build-source
#f
(list (build-source
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#f
'quote)
(attach-source #f %%sym1081)))
((lambda (%%x1085)
(if (self-eval? %%x1084)
%%x1085
(build-source
#f
(list (build-source #f 'quote) %%x1085))))
(attach-source #f %%x1084))
(build-source #f (list (build-source #f 'quote) #f))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%rest1083))
(cons '$module
(%%make-resolved-interface395
%%id1060
%%exports1082
%%sym1081))))
(%%ctdefs1036))))))
(%%generate-id78
((lambda (%%x1086)
((lambda (%%e1087)
(if (annotation? %%e1087)
(annotation-expression %%e1087)
%%e1087))
(if (%%syntax-object?64 %%x1086)
(%%syntax-object-expression65 %%x1086)
%%x1086)))
%%id1060))
(%%module-binding-val402 %%b1064))
(if (memv %%t1070 '(alias-form))
(%%process-exports1034
%%fexports1069
(lambda ()
((lambda (%%rest1088)
(begin
(if (%%indirect-label?291 %%label1067)
(if (not (symbol? (%%get-indirect-label295
%%label1067)))
(syntax-error
(%%module-binding-id399
%%b1064)
"unexported target of alias")
(void))
(void))
%%rest1088))
(%%ctdefs1036))))
(error "unexpected module binding type"
%%t1066)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%t1066)))))
(append %%imps1068 %%fexports1061)))
(%%module-binding-imps401 %%b1064)))
(%%module-binding-label400 %%b1064)))
(%%module-binding-type398 %%b1064)))
(%%loop1062 %%bs1065)))
(car %%bs1063)
(cdr %%bs1063))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%loop1062)
%%bindings1032))
(car %%fexports1035)
(cdr %%fexports1035))))))
%%process-exports1034)
%%fexports1028
(lambda () '())))))
(%%flatten-exports385 %%exports1025))))
(%%id-set-diff418
(lambda (%%exports1089 %%defs1090)
(if (null? %%exports1089)
'()
(if (%%bound-id-member?377 (car %%exports1089) %%defs1090)
(%%id-set-diff418 (cdr %%exports1089) %%defs1090)
(cons (car %%exports1089)
(%%id-set-diff418
(cdr %%exports1089)
%%defs1090))))))
(%%check-module-exports419
(lambda (%%source-exp1091 %%fexports1092 %%ids1093)
(letrec ((%%defined?1094
(lambda (%%e1095 %%ids1096)
(ormap (lambda (%%x1097)
(if (%%import-interface?315 %%x1097)
((lambda (%%x.iface1098
%%x.new-marks1099)
((lambda (%%t1100)
(if %%t1100
((lambda (%%token1101)
(%%lookup-import-binding-name350
((lambda (%%x1102)
((lambda (%%e1103)
(if (annotation?
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e1103)
(annotation-expression %%e1103)
%%e1103))
(if (%%syntax-object?64 %%x1102)
(%%syntax-object-expression65 %%x1102)
%%x1102)))
%%e1095)
(%%id-marks247 %%e1095)
%%token1101
%%x.new-marks1099))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%t1100)
((lambda (%%v1104)
((letrec ((%%lp1105
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(lambda (%%i1106)
(if (fx>= %%i1106 0)
((lambda (%%t1107)
(if %%t1107
%%t1107
(%%lp1105 (fx- %%i1106 1))))
((lambda (%%id1108)
(%%help-bound-id=?372
((lambda (%%x1109)
((lambda (%%e1110)
(if (annotation? %%e1110)
(annotation-expression %%e1110)
%%e1110))
(if (%%syntax-object?64 %%x1109)
(%%syntax-object-expression65
%%x1109)
%%x1109)))
%%id1108)
(%%join-marks358
%%x.new-marks1099
(%%id-marks247 %%id1108))
((lambda (%%x1111)
((lambda (%%e1112)
(if (annotation? %%e1112)
(annotation-expression %%e1112)
%%e1112))
(if (%%syntax-object?64 %%x1111)
(%%syntax-object-expression65
%%x1111)
%%x1111)))
%%e1095)
(%%id-marks247 %%e1095)))
(vector-ref %%v1104 %%i1106)))
#f))))
%%lp1105)
(fx- (vector-length %%v1104) 1)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%interface-exports389
%%x.iface1098))))
(%%interface-token390
%%x.iface1098)))
(%%import-interface-interface316
%%x1097)
(%%import-interface-new-marks317
%%x1097))
(%%bound-id=?373 %%e1095 %%x1097)))
%%ids1096))))
((letrec ((%%loop1113
(lambda (%%fexports1114 %%missing1115)
(if (null? %%fexports1114)
(if (not (null? %%missing1115))
(syntax-error
(car %%missing1115)
(if (= (length %%missing1115) 1)
"missing definition for export"
"missing definition for multiple exports, including"))
(void))
((lambda (%%e1116 %%fexports1117)
(if (%%defined?1094 %%e1116 %%ids1093)
(%%loop1113
%%fexports1117
%%missing1115)
(%%loop1113
%%fexports1117
(cons %%e1116 %%missing1115))))
(car %%fexports1114)
(cdr %%fexports1114))))))
%%loop1113)
%%fexports1092
'()))))
(%%check-defined-ids420
(lambda (%%source-exp1118 %%ls1119)
(letrec ((%%vfold1120
(lambda (%%v1123 %%p1124 %%cls1125)
((lambda (%%len1126)
((letrec ((%%lp1127
(lambda (%%i1128 %%cls1129)
(if (fx= %%i1128 %%len1126)
%%cls1129
(%%lp1127
(fx+ %%i1128 1)
(%%p1124 (vector-ref
%%v1123
%%i1128)
%%cls1129))))))
%%lp1127)
0
%%cls1125))
(vector-length %%v1123))))
(%%conflicts1121
(lambda (%%x1130 %%y1131 %%cls1132)
(if (%%import-interface?315 %%x1130)
((lambda (%%x.iface1133 %%x.new-marks1134)
(if (%%import-interface?315 %%y1131)
((lambda (%%y.iface1135
%%y.new-marks1136)
((lambda (%%xe1137 %%ye1138)
(if (fx> (vector-length %%xe1137)
(vector-length
%%ye1138))
(%%vfold1120
%%ye1138
(lambda (%%id1139 %%cls1140)
(%%id-iface-conflicts1122
%%id1139
%%y.new-marks1136
%%x.iface1133
%%x.new-marks1134
%%cls1140))
%%cls1132)
(%%vfold1120
%%xe1137
(lambda (%%id1141 %%cls1142)
(%%id-iface-conflicts1122
%%id1141
%%x.new-marks1134
%%y.iface1135
%%y.new-marks1136
%%cls1142))
%%cls1132)))
(%%interface-exports389
%%x.iface1133)
(%%interface-exports389
%%y.iface1135)))
(%%import-interface-interface316
%%y1131)
(%%import-interface-new-marks317
%%y1131))
(%%id-iface-conflicts1122
%%y1131
'()
%%x.iface1133
%%x.new-marks1134
%%cls1132)))
(%%import-interface-interface316 %%x1130)
(%%import-interface-new-marks317 %%x1130))
(if (%%import-interface?315 %%y1131)
((lambda (%%y.iface1143 %%y.new-marks1144)
(%%id-iface-conflicts1122
%%x1130
'()
%%y.iface1143
%%y.new-marks1144
%%cls1132))
(%%import-interface-interface316 %%y1131)
(%%import-interface-new-marks317
%%y1131))
(if (%%bound-id=?373 %%x1130 %%y1131)
(cons %%x1130 %%cls1132)
%%cls1132)))))
(%%id-iface-conflicts1122
(lambda (%%id1145
%%id.new-marks1146
%%iface1147
%%iface.new-marks1148
%%cls1149)
((lambda (%%id.sym1150 %%id.marks1151)
((lambda (%%t1152)
(if %%t1152
((lambda (%%token1153)
(if (%%lookup-import-binding-name350
%%id.sym1150
%%id.marks1151
%%token1153
%%iface.new-marks1148)
(cons %%id1145 %%cls1149)
%%cls1149))
%%t1152)
(%%vfold1120
(%%interface-exports389 %%iface1147)
(lambda (%%*id1154 %%cls1155)
((lambda (%%*id.sym1156
%%*id.marks1157)
(if (%%help-bound-id=?372
%%*id.sym1156
%%*id.marks1157
%%id.sym1150
%%id.marks1151)
(cons %%*id1154 %%cls1155)
%%cls1155))
((lambda (%%x1158)
((lambda (%%e1159)
(if (annotation? %%e1159)
(annotation-expression
%%e1159)
%%e1159))
(if (%%syntax-object?64 %%x1158)
(%%syntax-object-expression65
%%x1158)
%%x1158)))
%%*id1154)
(%%join-marks358
%%iface.new-marks1148
(%%id-marks247 %%*id1154))))
%%cls1149)))
(%%interface-token390 %%iface1147)))
((lambda (%%x1160)
((lambda (%%e1161)
(if (annotation? %%e1161)
(annotation-expression %%e1161)
%%e1161))
(if (%%syntax-object?64 %%x1160)
(%%syntax-object-expression65 %%x1160)
%%x1160)))
%%id1145)
(%%join-marks358
%%id.new-marks1146
(%%id-marks247 %%id1145))))))
(if (not (null? %%ls1119))
((letrec ((%%lp1162
(lambda (%%x1163 %%ls1164 %%cls1165)
(if (null? %%ls1164)
(if (not (null? %%cls1165))
((lambda (%%cls1166)
(syntax-error
%%source-exp1118
"duplicate definition for "
(symbol->string
(car %%cls1166))
" in"))
(syntax-object->datum %%cls1165))
(void))
((letrec ((%%lp21167
(lambda (%%ls21168
%%cls1169)
(if (null? %%ls21168)
(%%lp1162
(car %%ls1164)
(cdr %%ls1164)
%%cls1169)
(%%lp21167
(cdr %%ls21168)
(%%conflicts1121
%%x1163
(car %%ls21168)
%%cls1169))))))
%%lp21167)
%%ls1164
%%cls1165)))))
%%lp1162)
(car %%ls1119)
(cdr %%ls1119)
'())
(void)))))
(%%chi-external421
(lambda (%%ribcage1170
%%source-exp1171
%%body1172
%%r1173
%%mr1174
%%ctem1175
%%exports1176
%%fexports1177
%%meta-residualize!1178)
(letrec ((%%return1179
(lambda (%%r1182
%%mr1183
%%bindings1184
%%ids1185
%%inits1186)
(begin
(%%check-defined-ids420
%%source-exp1171
%%ids1185)
(%%check-module-exports419
%%source-exp1171
%%fexports1177
%%ids1185)
(values %%r1182
%%mr1183
%%bindings1184
%%inits1186))))
(%%get-implicit-exports1180
(lambda (%%id1187)
((letrec ((%%f1188 (lambda (%%exports1189)
(if (null? %%exports1189)
'()
(if (if (pair? (car %%exports1189))
(%%bound-id=?373
%%id1187
(caar %%exports1189))
#f)
(%%flatten-exports385
(cdar %%exports1189))
(%%f1188 (cdr %%exports1189)))))))
%%f1188)
%%exports1176)))
(%%update-imp-exports1181
(lambda (%%bindings1190 %%exports1191)
((lambda (%%exports1192)
(map (lambda (%%b1193)
((lambda (%%id1194)
(if (not (%%bound-id-member?377
%%id1194
%%exports1192))
%%b1193
(%%create-module-binding410
(%%module-binding-type398
%%b1193)
%%id1194
(%%module-binding-label400
%%b1193)
(append (%%get-implicit-exports1180
%%id1194)
(%%module-binding-imps401
%%b1193))
(%%module-binding-val402
%%b1193))))
(%%module-binding-id399 %%b1193)))
%%bindings1190))
(map (lambda (%%x1195)
(if (pair? %%x1195)
(car %%x1195)
%%x1195))
%%exports1191)))))
((letrec ((%%parse1196
(lambda (%%body1197
%%r1198
%%mr1199
%%ids1200
%%bindings1201
%%inits1202
%%meta-seen?1203)
(if (null? %%body1197)
(%%return1179
%%r1198
%%mr1199
%%bindings1201
%%ids1200
%%inits1202)
((lambda (%%fr1204)
((lambda (%%e1205)
((lambda (%%meta?1206)
((lambda ()
(call-with-values
(lambda ()
(%%syntax-type381
%%e1205
%%r1198
'(())
#f
%%ribcage1170))
(lambda (%%type1207
%%value1208
%%e1209
%%w1210
%%ae1211)
((lambda (%%t1212)
(if (memv %%t1212
'(define-form))
(call-with-values
(lambda ()
(%%parse-define445
%%e1209
%%w1210
%%ae1211))
(lambda (%%id1213
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%rhs1214
%%w1215)
((lambda (%%id1216)
((lambda (%%label1217)
((lambda (%%imps1218)
((lambda ()
(begin
(%%extend-ribcage!345
%%ribcage1170
%%id1216
%%label1217)
(if %%meta?1206
((lambda (%%sym1219)
((lambda (%%b1220)
((lambda ()
((lambda (%%mr1221)
((lambda (%%exp1222)
(begin
(%%define-top-level-value-hook71
%%sym1219
(%%top-level-eval-hook69
%%exp1222))
(%%meta-residualize!1178
(%%ct-eval/residualize3429
%%ctem1175
void
(lambda ()
(build-source
#f
(list (build-source
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#f
'define)
(build-source #f %%sym1219)
%%exp1222)))))
(%%parse1196
(cdr %%body1197)
%%r1198
%%mr1221
(cons %%id1216 %%ids1200)
(cons (%%create-module-binding410
'ctdefine-form
%%id1216
%%label1217
%%imps1218
%%b1220)
%%bindings1201)
%%inits1202
#f)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%chi433
%%rhs1214
%%mr1221
%%mr1221
%%w1215
#t)))
(%%extend-env230
(%%get-indirect-label295
%%label1217)
%%b1220
%%mr1199)))))
(cons 'meta-variable %%sym1219)))
(%%generate-id78
((lambda (%%x1223)
((lambda (%%e1224)
(if (annotation? %%e1224)
(annotation-expression
%%e1224)
%%e1224))
(if (%%syntax-object?64 %%x1223)
(%%syntax-object-expression65
%%x1223)
%%x1223)))
%%id1216)))
(%%parse1196
(cdr %%body1197)
%%r1198
%%mr1199
(cons %%id1216 %%ids1200)
(cons (%%create-module-binding410
%%type1207
%%id1216
%%label1217
%%imps1218
(%%make-frob411
(%%wrap378 %%rhs1214 %%w1215)
%%meta?1206))
%%bindings1201)
%%inits1202
#f))))))
(%%get-implicit-exports1180 %%id1216)))
(%%gen-indirect-label294)))
(%%wrap378 %%id1213 %%w1215))))
(if (memv %%t1212 '(define-syntax-form))
(call-with-values
(lambda ()
(%%parse-define-syntax446 %%e1209 %%w1210 %%ae1211))
(lambda (%%id1225 %%rhs1226 %%w1227)
((lambda (%%id1228)
((lambda (%%label1229)
((lambda (%%imps1230)
((lambda (%%exp1231)
((lambda ()
(begin
(%%extend-ribcage!345
%%ribcage1170
%%id1228
%%label1229)
((lambda (%%l1232 %%b1233)
(%%parse1196
(cdr %%body1197)
(%%extend-env230
%%l1232
%%b1233
%%r1198)
(%%extend-env230
%%l1232
%%b1233
%%mr1199)
(cons %%id1228 %%ids1200)
(cons (%%create-module-binding410
%%type1207
%%id1228
%%label1229
%%imps1230
(cons %%b1233 %%exp1231))
%%bindings1201)
%%inits1202
#f))
(%%get-indirect-label295
%%label1229)
(%%defer-or-eval-transformer238
%%top-level-eval-hook69
%%exp1231))))))
(%%chi433
%%rhs1226
%%mr1199
%%mr1199
%%w1227
#t)))
(%%get-implicit-exports1180 %%id1228)))
(%%gen-indirect-label294)))
(%%wrap378 %%id1225 %%w1227))))
(if (memv %%t1212 '($module-form))
((lambda (%%*ribcage1234)
((lambda (%%*w1235)
((lambda ()
(call-with-values
(lambda ()
(%%parse-module443
%%e1209
%%w1210
%%ae1211
%%*w1235))
(lambda (%%orig1236
%%id1237
%%*exports1238
%%forms1239)
(call-with-values
(lambda ()
(%%chi-external421
%%*ribcage1234
%%orig1236
(map (lambda (%%d1240)
(%%make-frob411
%%d1240
%%meta?1206))
%%forms1239)
%%r1198
%%mr1199
%%ctem1175
%%*exports1238
(%%flatten-exports385 %%*exports1238)
%%meta-residualize!1178))
(lambda (%%r1241
%%mr1242
%%*bindings1243
%%*inits1244)
((lambda (%%iface1245
%%bindings1246
%%inits1247
%%label1248
%%imps1249)
(begin
(%%extend-ribcage!345
%%ribcage1170
%%id1237
%%label1248)
((lambda (%%l1250 %%b1251)
(%%parse1196
(cdr %%body1197)
(%%extend-env230
%%l1250
%%b1251
%%r1241)
(%%extend-env230
%%l1250
%%b1251
%%mr1242)
(cons %%id1237 %%ids1200)
(cons (%%create-module-binding410
%%type1207
%%id1237
%%label1248
%%imps1249
%%*exports1238)
%%bindings1246)
%%inits1247
#f))
(%%get-indirect-label295
%%label1248)
(cons '$module %%iface1245))))
(%%make-unresolved-interface394
%%id1237
%%*exports1238)
(append %%*bindings1243
%%bindings1201)
(append %%inits1202 %%*inits1244)
(%%gen-indirect-label294)
(%%get-implicit-exports1180
%%id1237)))))))))
(%%make-wrap250
(%%wrap-marks251 %%w1210)
(cons %%*ribcage1234
(%%wrap-subst252 %%w1210)))))
(%%make-ribcage300 '() '() '()))
(if (memv %%t1212 '($import-form))
(call-with-values
(lambda ()
(%%parse-import444 %%e1209 %%w1210 %%ae1211))
(lambda (%%orig1252 %%only?1253 %%mid1254)
((lambda (%%mlabel1255)
((lambda (%%binding1256)
((lambda (%%t1257)
(if (memv %%t1257 '($module))
((lambda (%%iface1258)
((lambda (%%import-iface1259)
((lambda ()
(begin
(if %%only?1253
(%%extend-ribcage-barrier!347
%%ribcage1170
%%mid1254)
(void))
(%%do-import!442
%%import-iface1259
%%ribcage1170)
(%%parse1196
(cdr %%body1197)
%%r1198
%%mr1199
(cons %%import-iface1259
%%ids1200)
(%%update-imp-exports1181
%%bindings1201
(vector->list
(%%interface-exports389
%%iface1258)))
%%inits1202
#f)))))
(%%make-import-interface314
%%iface1258
(%%import-mark-delta440
%%mid1254
%%iface1258))))
(%%binding-value217
%%binding1256))
(if (memv %%t1257
'(displaced-lexical))
(%%displaced-lexical-error234
%%mid1254)
(syntax-error
%%mid1254
"unknown module"))))
(%%binding-type216 %%binding1256)))
(%%lookup236 %%mlabel1255 %%r1198)))
(%%id-var-name369 %%mid1254 '(())))))
(if (memv %%t1212 '(alias-form))
(call-with-values
(lambda ()
(%%parse-alias449
%%e1209
%%w1210
%%ae1211))
(lambda (%%new-id1260 %%old-id1261)
((lambda (%%new-id1262)
((lambda (%%label1263)
((lambda (%%imps1264)
((lambda ()
(begin
(%%extend-ribcage!345
%%ribcage1170
%%new-id1262
%%label1263)
(%%parse1196
(cdr %%body1197)
%%r1198
%%mr1199
(cons %%new-id1262
%%ids1200)
(cons (%%create-module-binding410
%%type1207
%%new-id1262
%%label1263
%%imps1264
#f)
%%bindings1201)
%%inits1202
#f)))))
(%%get-implicit-exports1180
%%new-id1262)))
(%%id-var-name-loc368
%%old-id1261
%%w1210)))
(%%wrap378 %%new-id1260 %%w1210))))
(if (memv %%t1212 '(begin-form))
(%%parse1196
((letrec ((%%f1265 (lambda (%%forms1266)
(if (null? %%forms1266)
(cdr %%body1197)
(cons (%%make-frob411
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(%%wrap378 (car %%forms1266) %%w1210)
%%meta?1206)
(%%f1265 (cdr %%forms1266)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f1265)
(%%parse-begin450
%%e1209
%%w1210
%%ae1211
#t))
%%r1198
%%mr1199
%%ids1200
%%bindings1201
%%inits1202
#f)
(if (memv %%t1212 '(eval-when-form))
(call-with-values
(lambda ()
(%%parse-eval-when448
%%e1209
%%w1210
%%ae1211))
(lambda (%%when-list1267
%%forms1268)
(%%parse1196
(if (memq 'eval %%when-list1267)
((letrec ((%%f1269 (lambda (%%forms1270)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (null? %%forms1270)
(cdr %%body1197)
(cons (%%make-frob411
(%%wrap378 (car %%forms1270) %%w1210)
%%meta?1206)
(%%f1269 (cdr %%forms1270)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f1269)
%%forms1268)
(cdr %%body1197))
%%r1198
%%mr1199
%%ids1200
%%bindings1201
%%inits1202
#f)))
(if (memv %%t1212 '(meta-form))
(%%parse1196
(cons (%%make-frob411
(%%wrap378
(%%parse-meta447
%%e1209
%%w1210
%%ae1211)
%%w1210)
#t)
(cdr %%body1197))
%%r1198
%%mr1199
%%ids1200
%%bindings1201
%%inits1202
#t)
(if (memv %%t1212
'(local-syntax-form))
(call-with-values
(lambda ()
(%%chi-local-syntax452
%%value1208
%%e1209
%%r1198
%%mr1199
%%w1210
%%ae1211))
(lambda (%%forms1271
%%r1272
%%mr1273
%%w1274
%%ae1275)
(%%parse1196
((letrec ((%%f1276 (lambda (%%forms1277)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (null? %%forms1277)
(cdr %%body1197)
(cons (%%make-frob411
(%%wrap378
(car %%forms1277)
%%w1274)
%%meta?1206)
(%%f1276 (cdr %%forms1277)))))))
%%f1276)
%%forms1271)
%%r1272
%%mr1273
%%ids1200
%%bindings1201
%%inits1202
#f)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(begin
(if %%meta-seen?1203
(syntax-error
(%%source-wrap379
%%e1209
%%w1210
%%ae1211)
"invalid meta definition")
(void))
((letrec ((%%f1278 (lambda (%%body1279)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if ((lambda (%%t1280)
(if %%t1280
%%t1280
(not (%%frob-meta?414
(car %%body1279)))))
(null? %%body1279))
(%%return1179
%%r1198
%%mr1199
%%bindings1201
%%ids1200
(append %%inits1202 %%body1279))
(begin
((lambda (%%x1281)
(begin
(%%top-level-eval-hook69 %%x1281)
(%%meta-residualize!1178
(%%ct-eval/residualize3429
%%ctem1175
void
(lambda () %%x1281)))))
(%%chi-meta-frob431
(car %%body1279)
%%mr1199))
(%%f1278 (cdr %%body1279)))))))
%%f1278)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cons (%%make-frob411
(%%source-wrap379
%%e1209
%%w1210
%%ae1211)
%%meta?1206)
(cdr %%body1197))))))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%type1207))))))
(%%frob-meta?414 %%fr1204)))
(%%frob-e413 %%fr1204)))
(car %%body1197))))))
%%parse1196)
%%body1172
%%r1173
%%mr1174
'()
'()
'()
#f))))
(%%vmap422
(lambda (%%fn1282 %%v1283)
((letrec ((%%do1284
(lambda (%%i1285 %%ls1286)
(if (fx< %%i1285 0)
%%ls1286
(%%do1284
(fx- %%i1285 1)
(cons (%%fn1282
(vector-ref %%v1283 %%i1285))
%%ls1286))))))
%%do1284)
(fx- (vector-length %%v1283) 1)
'())))
(%%vfor-each423
(lambda (%%fn1287 %%v1288)
((lambda (%%len1289)
((letrec ((%%do1290
(lambda (%%i1291)
(if (not (fx= %%i1291 %%len1289))
(begin
(%%fn1287 (vector-ref %%v1288 %%i1291))
(%%do1290 (fx+ %%i1291 1)))
(void)))))
%%do1290)
0))
(vector-length %%v1288))))
(%%do-top-import424
(lambda (%%import-only?1292
%%top-ribcage1293
%%mid1294
%%token1295)
(build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source #f %%mid1294)))
((lambda (%%x1296)
(if (self-eval? (cons 'do-import %%token1295))
%%x1296
(build-source
#f
(list (build-source #f 'quote) %%x1296))))
(attach-source #f (cons 'do-import %%token1295)))
(build-source
#f
(list (build-source #f 'quote)
(%%top-ribcage-key310 %%top-ribcage1293)))))))
(%%update-mode-set425
((lambda (%%table1297)
(lambda (%%when-list1298 %%mode-set1299)
(letrec ((%%remq1300
(lambda (%%x1301 %%ls1302)
(if (null? %%ls1302)
'()
(if (eq? (car %%ls1302) %%x1301)
(%%remq1300 %%x1301 (cdr %%ls1302))
(cons (car %%ls1302)
(%%remq1300
%%x1301
(cdr %%ls1302))))))))
(%%remq1300
'-
(apply append
(map (lambda (%%m1303)
((lambda (%%row1304)
(map (lambda (%%s1305)
(cdr (assq %%s1305 %%row1304)))
%%when-list1298))
(cdr (assq %%m1303 %%table1297))))
%%mode-set1299))))))
'((L (load . L)
(compile . C)
(visit . V)
(revisit . R)
(eval . -))
(C (load . -)
(compile . -)
(visit . -)
(revisit . -)
(eval . C))
(V (load . V)
(compile . C)
(visit . V)
(revisit . -)
(eval . -))
(R (load . R)
(compile . C)
(visit . -)
(revisit . R)
(eval . -))
(E (load . -)
(compile . -)
(visit . -)
(revisit . -)
(eval . E)))))
(%%initial-mode-set426
(lambda (%%when-list1306 %%compiling-a-file1307)
(apply append
(map (lambda (%%s1308)
(if %%compiling-a-file1307
((lambda (%%t1309)
(if (memv %%t1309 '(compile))
'(C)
(if (memv %%t1309 '(load))
'(L)
(if (memv %%t1309 '(visit))
'(V)
(if (memv %%t1309 '(revisit))
'(R)
'())))))
%%s1308)
((lambda (%%t1310)
(if (memv %%t1310 '(eval)) '(E) '()))
%%s1308)))
%%when-list1306))))
(%%rt-eval/residualize427
(lambda (%%rtem1311 %%thunk1312)
(if (memq 'E %%rtem1311)
(%%thunk1312)
((lambda (%%thunk1313)
(if (memq 'V %%rtem1311)
(if ((lambda (%%t1314)
(if %%t1314 %%t1314 (memq 'R %%rtem1311)))
(memq 'L %%rtem1311))
(%%thunk1313)
(%%thunk1313))
(if ((lambda (%%t1315)
(if %%t1315 %%t1315 (memq 'R %%rtem1311)))
(memq 'L %%rtem1311))
(%%thunk1313)
(%%chi-void453))))
(if (memq 'C %%rtem1311)
((lambda (%%x1316)
(begin
(%%top-level-eval-hook69 %%x1316)
(lambda () %%x1316)))
(%%thunk1312))
%%thunk1312)))))
(%%ct-eval/residualize2428
(lambda (%%ctem1317 %%thunk1318)
((lambda (%%t1319)
(%%ct-eval/residualize3429
%%ctem1317
(lambda ()
(begin
(if (not %%t1319) (set! %%t1319 (%%thunk1318)) (void))
(%%top-level-eval-hook69 %%t1319)))
(lambda ()
((lambda (%%t1320) (if %%t1320 %%t1320 (%%thunk1318)))
%%t1319))))
#f)))
(%%ct-eval/residualize3429
(lambda (%%ctem1321 %%eval-thunk1322 %%residualize-thunk1323)
(if (memq 'E %%ctem1321)
(begin (%%eval-thunk1322) (%%chi-void453))
(begin
(if (memq 'C %%ctem1321) (%%eval-thunk1322) (void))
(if (memq 'R %%ctem1321)
(if ((lambda (%%t1324)
(if %%t1324 %%t1324 (memq 'V %%ctem1321)))
(memq 'L %%ctem1321))
(%%residualize-thunk1323)
(%%residualize-thunk1323))
(if ((lambda (%%t1325)
(if %%t1325 %%t1325 (memq 'V %%ctem1321)))
(memq 'L %%ctem1321))
(%%residualize-thunk1323)
(%%chi-void453)))))))
(%%chi-frobs430
(lambda (%%frob*1326 %%r1327 %%mr1328 %%m?1329)
(map (lambda (%%x1330)
(%%chi433
(%%frob-e413 %%x1330)
%%r1327
%%mr1328
'(())
%%m?1329))
%%frob*1326)))
(%%chi-meta-frob431
(lambda (%%x1331 %%mr1332)
(%%chi433 (%%frob-e413 %%x1331) %%mr1332 %%mr1332 '(()) #t)))
(%%chi-sequence432
(lambda (%%body1333 %%r1334 %%mr1335 %%w1336 %%ae1337 %%m?1338)
(%%build-sequence170
%%ae1337
((letrec ((%%dobody1339
(lambda (%%body1340)
(if (null? %%body1340)
'()
((lambda (%%first1341)
(cons %%first1341
(%%dobody1339 (cdr %%body1340))))
(%%chi433
(car %%body1340)
%%r1334
%%mr1335
%%w1336
%%m?1338))))))
%%dobody1339)
%%body1333))))
(%%chi433
(lambda (%%e1342 %%r1343 %%mr1344 %%w1345 %%m?1346)
(call-with-values
(lambda () (%%syntax-type381 %%e1342 %%r1343 %%w1345 #f #f))
(lambda (%%type1347 %%value1348 %%e1349 %%w1350 %%ae1351)
(%%chi-expr434
%%type1347
%%value1348
%%e1349
%%r1343
%%mr1344
%%w1350
%%ae1351
%%m?1346)))))
(%%chi-expr434
(lambda (%%type1352
%%value1353
%%e1354
%%r1355
%%mr1356
%%w1357
%%ae1358
%%m?1359)
((lambda (%%t1360)
(if (memv %%t1360 '(lexical))
(build-source %%ae1358 %%value1353)
(if (memv %%t1360 '(core))
(%%value1353
%%e1354
%%r1355
%%mr1356
%%w1357
%%ae1358
%%m?1359)
(if (memv %%t1360 '(lexical-call))
(%%chi-application435
(build-source
((lambda (%%x1361)
(if (%%syntax-object?64 %%x1361)
(%%syntax-object-expression65 %%x1361)
%%x1361))
(car %%e1354))
%%value1353)
%%e1354
%%r1355
%%mr1356
%%w1357
%%ae1358
%%m?1359)
(if (memv %%t1360 '(constant))
((lambda (%%x1362)
(if (self-eval?
(%%strip457
(%%source-wrap379
%%e1354
%%w1357
%%ae1358)
'(())))
%%x1362
(build-source
%%ae1358
(list (build-source
%%ae1358
'quote)
%%x1362))))
(attach-source
%%ae1358
(%%strip457
(%%source-wrap379
%%e1354
%%w1357
%%ae1358)
'(()))))
(if (memv %%t1360 '(global))
(build-source %%ae1358 %%value1353)
(if (memv %%t1360 '(meta-variable))
(if %%m?1359
(build-source
%%ae1358
%%value1353)
(%%displaced-lexical-error234
(%%source-wrap379
%%e1354
%%w1357
%%ae1358)))
(if (memv %%t1360 '(call))
(%%chi-application435
(%%chi433
(car %%e1354)
%%r1355
%%mr1356
%%w1357
%%m?1359)
%%e1354
%%r1355
%%mr1356
%%w1357
%%ae1358
%%m?1359)
(if (memv %%t1360
'(begin-form))
(%%chi-sequence432
(%%parse-begin450
%%e1354
%%w1357
%%ae1358
#f)
%%r1355
%%mr1356
%%w1357
%%ae1358
%%m?1359)
(if (memv %%t1360
'(local-syntax-form))
(call-with-values
(lambda ()
(%%chi-local-syntax452
%%value1353
%%e1354
%%r1355
%%mr1356
%%w1357
%%ae1358))
(lambda (%%forms1363
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%r1364
%%mr1365
%%w1366
%%ae1367)
(%%chi-sequence432
%%forms1363
%%r1364
%%mr1365
%%w1366
%%ae1367
%%m?1359)))
(if (memv %%t1360 '(eval-when-form))
(call-with-values
(lambda ()
(%%parse-eval-when448 %%e1354 %%w1357 %%ae1358))
(lambda (%%when-list1368 %%forms1369)
(if (memq 'eval %%when-list1368)
(%%chi-sequence432
%%forms1369
%%r1355
%%mr1356
%%w1357
%%ae1358
%%m?1359)
(%%chi-void453))))
(if (memv %%t1360 '(meta-form))
(syntax-error
(%%source-wrap379 %%e1354 %%w1357 %%ae1358)
"invalid context for meta definition")
(if (memv %%t1360 '(define-form))
(begin
(%%parse-define445 %%e1354 %%w1357 %%ae1358)
(syntax-error
(%%source-wrap379 %%e1354 %%w1357 %%ae1358)
"invalid context for definition"))
(if (memv %%t1360 '(define-syntax-form))
(begin
(%%parse-define-syntax446
%%e1354
%%w1357
%%ae1358)
(syntax-error
(%%source-wrap379 %%e1354 %%w1357 %%ae1358)
"invalid context for definition"))
(if (memv %%t1360 '($module-form))
(call-with-values
(lambda ()
(%%parse-module443
%%e1354
%%w1357
%%ae1358
%%w1357))
(lambda (%%orig1370
%%id1371
%%exports1372
%%forms1373)
(syntax-error
%%orig1370
"invalid context for definition")))
(if (memv %%t1360 '($import-form))
(call-with-values
(lambda ()
(%%parse-import444
%%e1354
%%w1357
%%ae1358))
(lambda (%%orig1374
%%only?1375
%%mid1376)
(syntax-error
%%orig1374
"invalid context for definition")))
(if (memv %%t1360 '(alias-form))
(begin
(%%parse-alias449
%%e1354
%%w1357
%%ae1358)
(syntax-error
(%%source-wrap379
%%e1354
%%w1357
%%ae1358)
"invalid context for definition"))
(if (memv %%t1360 '(syntax))
(syntax-error
(%%source-wrap379
%%e1354
%%w1357
%%ae1358)
"reference to pattern variable outside syntax form")
(if (memv %%t1360
'(displaced-lexical))
(%%displaced-lexical-error234
(%%source-wrap379
%%e1354
%%w1357
%%ae1358))
(syntax-error
(%%source-wrap379
%%e1354
%%w1357
%%ae1358)))))))))))))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%type1352)))
(%%chi-application435
(lambda (%%x1377
%%e1378
%%r1379
%%mr1380
%%w1381
%%ae1382
%%m?1383)
((lambda (%%tmp1384)
((lambda (%%tmp1385)
(if %%tmp1385
(apply (lambda (%%e01386 %%e11387)
(build-source
%%ae1382
(cons %%x1377
(map (lambda (%%e1388)
(%%chi433
%%e1388
%%r1379
%%mr1380
%%w1381
%%m?1383))
%%e11387))))
%%tmp1385)
((lambda (%%_1390)
(syntax-error
(%%source-wrap379 %%e1378 %%w1381 %%ae1382)))
%%tmp1384)))
($syntax-dispatch %%tmp1384 '(any . each-any))))
%%e1378)))
(%%chi-set!436
(lambda (%%e1391 %%r1392 %%w1393 %%ae1394 %%rib1395)
((lambda (%%tmp1396)
((lambda (%%tmp1397)
(if (if %%tmp1397
(apply (lambda (%%_1398 %%id1399 %%val1400)
(%%id?241 %%id1399))
%%tmp1397)
#f)
(apply (lambda (%%_1401 %%id1402 %%val1403)
((lambda (%%n1404)
((lambda (%%b1405)
((lambda (%%t1406)
(if (memv %%t1406 '(macro!))
((lambda (%%id1407 %%val1408)
(%%syntax-type381
(%%chi-macro437
(%%binding-value217
%%b1405)
(list '#(syntax-object
set!
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
()
()
())
#(ribcage #(id val) #((top) (top)) #("i" "i"))
#(ribcage () () ())
#(ribcage #(t) #(("m" top)) #("i"))
#(ribcage () () ())
#(ribcage #(b) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(n) #((top)) #("i"))
#(ribcage
#(_ id val)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(e r w ae rib)
#((top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%id1407
%%val1408)
%%r1392
'(())
#f
%%rib1395)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%r1392
'(())
#f
%%rib1395))
(%%wrap378 %%id1402 %%w1393)
(%%wrap378
%%val1403
%%w1393))
(values 'core
(lambda (%%e1409
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%r1410
%%mr1411
%%w1412
%%ae1413
%%m?1414)
((lambda (%%val1415 %%n1416)
((lambda (%%b1417)
((lambda (%%t1418)
(if (memv %%t1418 '(lexical))
(build-source
%%ae1413
(list (build-source %%ae1413 'set!)
(build-source
%%ae1413
(%%binding-value217 %%b1417))
%%val1415))
(if (memv %%t1418 '(global))
((lambda (%%sym1419)
(begin
(if (%%read-only-binding?75 %%n1416)
(syntax-error
(%%source-wrap379
%%e1409
%%w1412
%%ae1413)
"invalid assignment to read-only variable")
(void))
(build-source
%%ae1413
(list (build-source %%ae1413 'set!)
(build-source
%%ae1413
%%sym1419)
%%val1415))))
(%%binding-value217 %%b1417))
(if (memv %%t1418 '(meta-variable))
(if %%m?1414
(build-source
%%ae1413
(list (build-source
%%ae1413
'set!)
(build-source
%%ae1413
(%%binding-value217
%%b1417))
%%val1415))
(%%displaced-lexical-error234
(%%wrap378 %%id1402 %%w1412)))
(if (memv %%t1418 '(displaced-lexical))
(%%displaced-lexical-error234
(%%wrap378 %%id1402 %%w1412))
(syntax-error
(%%source-wrap379
%%e1409
%%w1412
%%ae1413)))))))
(%%binding-type216 %%b1417)))
(%%lookup236 %%n1416 %%r1410)))
(%%chi433 %%val1403 %%r1410 %%mr1411 %%w1412 %%m?1414)
(%%id-var-name369 %%id1402 %%w1412)))
%%e1391
%%w1393
%%ae1394)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%binding-type216 %%b1405)))
(%%lookup236 %%n1404 %%r1392)))
(%%id-var-name369 %%id1402 %%w1393)))
%%tmp1397)
((lambda (%%_1420)
(syntax-error
(%%source-wrap379 %%e1391 %%w1393 %%ae1394)))
%%tmp1396)))
($syntax-dispatch %%tmp1396 '(any any any))))
%%e1391)))
(%%chi-macro437
(lambda (%%p1421 %%e1422 %%r1423 %%w1424 %%ae1425 %%rib1426)
(letrec ((%%rebuild-macro-output1427
(lambda (%%x1428 %%m1429)
(if (pair? %%x1428)
(cons (%%rebuild-macro-output1427
(car %%x1428)
%%m1429)
(%%rebuild-macro-output1427
(cdr %%x1428)
%%m1429))
(if (%%syntax-object?64 %%x1428)
((lambda (%%w1430)
((lambda (%%ms1431 %%s1432)
(%%make-syntax-object63
(%%syntax-object-expression65
%%x1428)
(if (if (pair? %%ms1431)
(eq? (car %%ms1431) #f)
#f)
(%%make-wrap250
(cdr %%ms1431)
(cdr %%s1432))
(%%make-wrap250
(cons %%m1429 %%ms1431)
(if %%rib1426
(cons %%rib1426
(cons 'shift
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%s1432))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cons 'shift %%s1432))))))
(%%wrap-marks251 %%w1430)
(%%wrap-subst252 %%w1430)))
(%%syntax-object-wrap66 %%x1428))
(if (vector? %%x1428)
((lambda (%%n1433)
((lambda (%%v1434)
((lambda ()
((letrec ((%%do1435
(lambda (%%i1436)
(if (fx= %%i1436
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%n1433)
%%v1434
(begin
(vector-set!
%%v1434
%%i1436
(%%rebuild-macro-output1427
(vector-ref %%x1428 %%i1436)
%%m1429))
(%%do1435 (fx+ %%i1436 1)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%do1435)
0))))
(make-vector %%n1433)))
(vector-length %%x1428))
(if (symbol? %%x1428)
(syntax-error
(%%source-wrap379
%%e1422
%%w1424
%%ae1425)
"encountered raw symbol "
(symbol->string %%x1428)
" in output of macro")
%%x1428)))))))
(%%rebuild-macro-output1427
((lambda (%%out1437)
(if (procedure? %%out1437)
(%%out1437
(lambda (%%id1438)
(begin
(if (not (identifier? %%id1438))
(syntax-error
%%id1438
"environment argument is not an identifier")
(void))
(%%lookup236
(%%id-var-name369 %%id1438 '(()))
%%r1423))))
%%out1437))
(%%p1421 (%%source-wrap379
%%e1422
(%%anti-mark335 %%w1424)
%%ae1425)))
(string #\m)))))
(%%chi-body438
(lambda (%%body1439
%%outer-form1440
%%r1441
%%mr1442
%%w1443
%%m?1444)
((lambda (%%ribcage1445)
((lambda (%%w1446)
((lambda (%%body1447)
((lambda ()
(call-with-values
(lambda ()
(%%chi-internal439
%%ribcage1445
%%outer-form1440
%%body1447
%%r1441
%%mr1442
%%m?1444))
(lambda (%%r1448
%%mr1449
%%exprs1450
%%ids1451
%%vars1452
%%vals1453
%%inits1454)
(begin
(if (null? %%exprs1450)
(syntax-error
%%outer-form1440
"no expressions in body")
(void))
(%%build-body172
#f
(reverse %%vars1452)
(%%chi-frobs430
(reverse %%vals1453)
%%r1448
%%mr1449
%%m?1444)
(%%build-sequence170
#f
(%%chi-frobs430
(append %%inits1454 %%exprs1450)
%%r1448
%%mr1449
%%m?1444)))))))))
(map (lambda (%%x1455)
(%%make-frob411 (%%wrap378 %%x1455 %%w1446) #f))
%%body1439)))
(%%make-wrap250
(%%wrap-marks251 %%w1443)
(cons %%ribcage1445 (%%wrap-subst252 %%w1443)))))
(%%make-ribcage300 '() '() '()))))
(%%chi-internal439
(lambda (%%ribcage1456
%%source-exp1457
%%body1458
%%r1459
%%mr1460
%%m?1461)
(letrec ((%%return1462
(lambda (%%r1463
%%mr1464
%%exprs1465
%%ids1466
%%vars1467
%%vals1468
%%inits1469)
(begin
(%%check-defined-ids420
%%source-exp1457
%%ids1466)
(values %%r1463
%%mr1464
%%exprs1465
%%ids1466
%%vars1467
%%vals1468
%%inits1469)))))
((letrec ((%%parse1470
(lambda (%%body1471
%%r1472
%%mr1473
%%ids1474
%%vars1475
%%vals1476
%%inits1477
%%meta-seen?1478)
(if (null? %%body1471)
(%%return1462
%%r1472
%%mr1473
%%body1471
%%ids1474
%%vars1475
%%vals1476
%%inits1477)
((lambda (%%fr1479)
((lambda (%%e1480)
((lambda (%%meta?1481)
((lambda ()
(call-with-values
(lambda ()
(%%syntax-type381
%%e1480
%%r1472
'(())
#f
%%ribcage1456))
(lambda (%%type1482
%%value1483
%%e1484
%%w1485
%%ae1486)
((lambda (%%t1487)
(if (memv %%t1487
'(define-form))
(call-with-values
(lambda ()
(%%parse-define445
%%e1484
%%w1485
%%ae1486))
(lambda (%%id1488
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%rhs1489
%%w1490)
((lambda (%%id1491 %%label1492)
(if %%meta?1481
((lambda (%%sym1493)
(begin
(%%extend-ribcage!345
%%ribcage1456
%%id1491
%%label1492)
((lambda (%%mr1494)
(begin
(%%define-top-level-value-hook71
%%sym1493
(%%top-level-eval-hook69
(%%chi433
%%rhs1489
%%mr1494
%%mr1494
%%w1490
#t)))
(%%parse1470
(cdr %%body1471)
%%r1472
%%mr1494
(cons %%id1491 %%ids1474)
%%vars1475
%%vals1476
%%inits1477
#f)))
(%%extend-env230
%%label1492
(cons 'meta-variable %%sym1493)
%%mr1473))))
(%%generate-id78
((lambda (%%x1495)
((lambda (%%e1496)
(if (annotation? %%e1496)
(annotation-expression %%e1496)
%%e1496))
(if (%%syntax-object?64 %%x1495)
(%%syntax-object-expression65 %%x1495)
%%x1495)))
%%id1491)))
((lambda (%%var1497)
(begin
(%%extend-ribcage!345
%%ribcage1456
%%id1491
%%label1492)
(%%parse1470
(cdr %%body1471)
(%%extend-env230
%%label1492
(cons 'lexical %%var1497)
%%r1472)
%%mr1473
(cons %%id1491 %%ids1474)
(cons %%var1497 %%vars1475)
(cons (%%make-frob411
(%%wrap378 %%rhs1489 %%w1490)
%%meta?1481)
%%vals1476)
%%inits1477
#f)))
(%%gen-var458 %%id1491))))
(%%wrap378 %%id1488 %%w1490)
(%%gen-label297))))
(if (memv %%t1487 '(define-syntax-form))
(call-with-values
(lambda ()
(%%parse-define-syntax446 %%e1484 %%w1485 %%ae1486))
(lambda (%%id1498 %%rhs1499 %%w1500)
((lambda (%%id1501 %%label1502 %%exp1503)
(begin
(%%extend-ribcage!345
%%ribcage1456
%%id1501
%%label1502)
((lambda (%%b1504)
(%%parse1470
(cdr %%body1471)
(%%extend-env230 %%label1502 %%b1504 %%r1472)
(%%extend-env230
%%label1502
%%b1504
%%mr1473)
(cons %%id1501 %%ids1474)
%%vars1475
%%vals1476
%%inits1477
#f))
(%%defer-or-eval-transformer238
%%local-eval-hook70
%%exp1503))))
(%%wrap378 %%id1498 %%w1500)
(%%gen-label297)
(%%chi433 %%rhs1499 %%mr1473 %%mr1473 %%w1500 #t))))
(if (memv %%t1487 '($module-form))
((lambda (%%*ribcage1505)
((lambda (%%*w1506)
((lambda ()
(call-with-values
(lambda ()
(%%parse-module443
%%e1484
%%w1485
%%ae1486
%%*w1506))
(lambda (%%orig1507
%%id1508
%%exports1509
%%forms1510)
(call-with-values
(lambda ()
(%%chi-internal439
%%*ribcage1505
%%orig1507
(map (lambda (%%d1511)
(%%make-frob411
%%d1511
%%meta?1481))
%%forms1510)
%%r1472
%%mr1473
%%m?1461))
(lambda (%%r1512
%%mr1513
%%*body1514
%%*ids1515
%%*vars1516
%%*vals1517
%%*inits1518)
(begin
(%%check-module-exports419
%%source-exp1457
(%%flatten-exports385
%%exports1509)
%%*ids1515)
((lambda (%%iface1519
%%vars1520
%%vals1521
%%inits1522
%%label1523)
(begin
(%%extend-ribcage!345
%%ribcage1456
%%id1508
%%label1523)
((lambda (%%b1524)
(%%parse1470
(cdr %%body1471)
(%%extend-env230
%%label1523
%%b1524
%%r1512)
(%%extend-env230
%%label1523
%%b1524
%%mr1513)
(cons %%id1508 %%ids1474)
%%vars1520
%%vals1521
%%inits1522
#f))
(cons '$module %%iface1519))))
(%%make-resolved-interface395
%%id1508
%%exports1509
#f)
(append %%*vars1516 %%vars1475)
(append %%*vals1517 %%vals1476)
(append %%inits1477
%%*inits1518
%%*body1514)
(%%gen-label297))))))))))
(%%make-wrap250
(%%wrap-marks251 %%w1485)
(cons %%*ribcage1505
(%%wrap-subst252 %%w1485)))))
(%%make-ribcage300 '() '() '()))
(if (memv %%t1487 '($import-form))
(call-with-values
(lambda ()
(%%parse-import444 %%e1484 %%w1485 %%ae1486))
(lambda (%%orig1525 %%only?1526 %%mid1527)
((lambda (%%mlabel1528)
((lambda (%%binding1529)
((lambda (%%t1530)
(if (memv %%t1530 '($module))
((lambda (%%iface1531)
((lambda (%%import-iface1532)
((lambda ()
(begin
(if %%only?1526
(%%extend-ribcage-barrier!347
%%ribcage1456
%%mid1527)
(void))
(%%do-import!442
%%import-iface1532
%%ribcage1456)
(%%parse1470
(cdr %%body1471)
%%r1472
%%mr1473
(cons %%import-iface1532
%%ids1474)
%%vars1475
%%vals1476
%%inits1477
#f)))))
(%%make-import-interface314
%%iface1531
(%%import-mark-delta440
%%mid1527
%%iface1531))))
(%%binding-value217
%%binding1529))
(if (memv %%t1530
'(displaced-lexical))
(%%displaced-lexical-error234
%%mid1527)
(syntax-error
%%mid1527
"unknown module"))))
(%%binding-type216 %%binding1529)))
(%%lookup236 %%mlabel1528 %%r1472)))
(%%id-var-name369 %%mid1527 '(())))))
(if (memv %%t1487 '(alias-form))
(call-with-values
(lambda ()
(%%parse-alias449
%%e1484
%%w1485
%%ae1486))
(lambda (%%new-id1533 %%old-id1534)
((lambda (%%new-id1535)
(begin
(%%extend-ribcage!345
%%ribcage1456
%%new-id1535
(%%id-var-name-loc368
%%old-id1534
%%w1485))
(%%parse1470
(cdr %%body1471)
%%r1472
%%mr1473
(cons %%new-id1535 %%ids1474)
%%vars1475
%%vals1476
%%inits1477
#f)))
(%%wrap378 %%new-id1533 %%w1485))))
(if (memv %%t1487 '(begin-form))
(%%parse1470
((letrec ((%%f1536 (lambda (%%forms1537)
(if (null? %%forms1537)
(cdr %%body1471)
(cons (%%make-frob411
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(%%wrap378 (car %%forms1537) %%w1485)
%%meta?1481)
(%%f1536 (cdr %%forms1537)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f1536)
(%%parse-begin450
%%e1484
%%w1485
%%ae1486
#t))
%%r1472
%%mr1473
%%ids1474
%%vars1475
%%vals1476
%%inits1477
#f)
(if (memv %%t1487 '(eval-when-form))
(call-with-values
(lambda ()
(%%parse-eval-when448
%%e1484
%%w1485
%%ae1486))
(lambda (%%when-list1538
%%forms1539)
(%%parse1470
(if (memq 'eval %%when-list1538)
((letrec ((%%f1540 (lambda (%%forms1541)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (null? %%forms1541)
(cdr %%body1471)
(cons (%%make-frob411
(%%wrap378 (car %%forms1541) %%w1485)
%%meta?1481)
(%%f1540 (cdr %%forms1541)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f1540)
%%forms1539)
(cdr %%body1471))
%%r1472
%%mr1473
%%ids1474
%%vars1475
%%vals1476
%%inits1477
#f)))
(if (memv %%t1487 '(meta-form))
(%%parse1470
(cons (%%make-frob411
(%%wrap378
(%%parse-meta447
%%e1484
%%w1485
%%ae1486)
%%w1485)
#t)
(cdr %%body1471))
%%r1472
%%mr1473
%%ids1474
%%vars1475
%%vals1476
%%inits1477
#t)
(if (memv %%t1487
'(local-syntax-form))
(call-with-values
(lambda ()
(%%chi-local-syntax452
%%value1483
%%e1484
%%r1472
%%mr1473
%%w1485
%%ae1486))
(lambda (%%forms1542
%%r1543
%%mr1544
%%w1545
%%ae1546)
(%%parse1470
((letrec ((%%f1547 (lambda (%%forms1548)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (null? %%forms1548)
(cdr %%body1471)
(cons (%%make-frob411
(%%wrap378
(car %%forms1548)
%%w1545)
%%meta?1481)
(%%f1547 (cdr %%forms1548)))))))
%%f1547)
%%forms1542)
%%r1543
%%mr1544
%%ids1474
%%vars1475
%%vals1476
%%inits1477
#f)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(begin
(if %%meta-seen?1478
(syntax-error
(%%source-wrap379
%%e1484
%%w1485
%%ae1486)
"invalid meta definition")
(void))
((letrec ((%%f1549 (lambda (%%body1550)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if ((lambda (%%t1551)
(if %%t1551
%%t1551
(not (%%frob-meta?414
(car %%body1550)))))
(null? %%body1550))
(%%return1462
%%r1472
%%mr1473
%%body1550
%%ids1474
%%vars1475
%%vals1476
%%inits1477)
(begin
(%%top-level-eval-hook69
(%%chi-meta-frob431
(car %%body1550)
%%mr1473))
(%%f1549 (cdr %%body1550)))))))
%%f1549)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cons (%%make-frob411
(%%source-wrap379
%%e1484
%%w1485
%%ae1486)
%%meta?1481)
(cdr %%body1471))))))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%type1482))))))
(%%frob-meta?414 %%fr1479)))
(%%frob-e413 %%fr1479)))
(car %%body1471))))))
%%parse1470)
%%body1458
%%r1459
%%mr1460
'()
'()
'()
'()
#f))))
(%%import-mark-delta440
(lambda (%%mid1552 %%iface1553)
(%%diff-marks361
(%%id-marks247 %%mid1552)
(%%interface-marks388 %%iface1553))))
(%%lookup-import-label441
(lambda (%%id1554)
((lambda (%%label1555)
(begin
(if (not %%label1555)
(syntax-error
%%id1554
"exported identifier not visible")
(void))
%%label1555))
(%%id-var-name-loc368 %%id1554 '(())))))
(%%do-import!442
(lambda (%%import-iface1556 %%ribcage1557)
((lambda (%%ie1558)
(if (<= (vector-length %%ie1558) 20)
((lambda (%%new-marks1559)
(%%vfor-each423
(lambda (%%id1560)
(%%import-extend-ribcage!346
%%ribcage1557
%%new-marks1559
%%id1560
(%%lookup-import-label441 %%id1560)))
%%ie1558))
(%%import-interface-new-marks317 %%import-iface1556))
(%%extend-ribcage-subst!349
%%ribcage1557
%%import-iface1556)))
(%%interface-exports389
(%%import-interface-interface316 %%import-iface1556)))))
(%%parse-module443
(lambda (%%e1561 %%w1562 %%ae1563 %%*w1564)
(letrec ((%%listify1565
(lambda (%%exports1566)
(if (null? %%exports1566)
'()
(cons ((lambda (%%tmp1567)
((lambda (%%tmp1568)
(if %%tmp1568
(apply (lambda (%%ex1569)
(%%listify1565
%%ex1569))
%%tmp1568)
((lambda (%%x1571)
(if (%%id?241 %%x1571)
(%%wrap378
%%x1571
%%*w1564)
(syntax-error
(%%source-wrap379
%%e1561
%%w1562
%%ae1563)
"invalid exports list in")))
%%tmp1567)))
($syntax-dispatch
%%tmp1567
'each-any)))
(car %%exports1566))
(%%listify1565 (cdr %%exports1566)))))))
((lambda (%%tmp1572)
((lambda (%%tmp1573)
(if (if %%tmp1573
(apply (lambda (%%_1574
%%orig1575
%%mid1576
%%ex1577
%%form1578)
(%%id?241 %%mid1576))
%%tmp1573)
#f)
(apply (lambda (%%_1579
%%orig1580
%%mid1581
%%ex1582
%%form1583)
(values %%orig1580
(%%wrap378 %%mid1581 %%w1562)
(%%listify1565 %%ex1582)
(map (lambda (%%x1585)
(%%wrap378
%%x1585
%%*w1564))
%%form1583)))
%%tmp1573)
((lambda (%%_1587)
(syntax-error
(%%source-wrap379 %%e1561 %%w1562 %%ae1563)))
%%tmp1572)))
($syntax-dispatch
%%tmp1572
'(any any any each-any . each-any))))
%%e1561))))
(%%parse-import444
(lambda (%%e1588 %%w1589 %%ae1590)
((lambda (%%tmp1591)
((lambda (%%tmp1592)
(if (if %%tmp1592
(apply (lambda (%%_1593 %%orig1594 %%mid1595)
(%%id?241 %%mid1595))
%%tmp1592)
#f)
(apply (lambda (%%_1596 %%orig1597 %%mid1598)
(values %%orig1597
#t
(%%wrap378 %%mid1598 %%w1589)))
%%tmp1592)
((lambda (%%tmp1599)
(if (if %%tmp1599
(apply (lambda (%%_1600
%%orig1601
%%mid1602)
(%%id?241 %%mid1602))
%%tmp1599)
#f)
(apply (lambda (%%_1603 %%orig1604 %%mid1605)
(values %%orig1604
#f
(%%wrap378
%%mid1605
%%w1589)))
%%tmp1599)
((lambda (%%_1606)
(syntax-error
(%%source-wrap379
%%e1588
%%w1589
%%ae1590)))
%%tmp1591)))
($syntax-dispatch
%%tmp1591
'(any any #(atom #f) any)))))
($syntax-dispatch %%tmp1591 '(any any #(atom #t) any))))
%%e1588)))
(%%parse-define445
(lambda (%%e1607 %%w1608 %%ae1609)
((lambda (%%tmp1610)
((lambda (%%tmp1611)
(if (if %%tmp1611
(apply (lambda (%%_1612 %%name1613 %%val1614)
(%%id?241 %%name1613))
%%tmp1611)
#f)
(apply (lambda (%%_1615 %%name1616 %%val1617)
(values %%name1616 %%val1617 %%w1608))
%%tmp1611)
((lambda (%%tmp1618)
(if (if %%tmp1618
(apply (lambda (%%_1619
%%name1620
%%args1621
%%e11622
%%e21623)
(if (%%id?241 %%name1620)
(%%valid-bound-ids?374
(%%lambda-var-list459
%%args1621))
#f))
%%tmp1618)
#f)
(apply (lambda (%%_1624
%%name1625
%%args1626
%%e11627
%%e21628)
(values (%%wrap378
%%name1625
%%w1608)
(cons '#(syntax-object
lambda
((top)
#(ribcage
#(_
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
name
args
e1
e2)
#((top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(e w ae) #((top) (top) (top)) #("i" "i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(%%wrap378
(cons %%args1626 (cons %%e11627 %%e21628))
%%w1608))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'(())))
%%tmp1618)
((lambda (%%tmp1630)
(if (if %%tmp1630
(apply (lambda (%%_1631
%%name1632)
(%%id?241 %%name1632))
%%tmp1630)
#f)
(apply (lambda (%%_1633 %%name1634)
(values (%%wrap378
%%name1634
%%w1608)
'#(syntax-object
(void)
((top)
#(ribcage
#(_ name)
#((top) (top))
#("i" "i"))
#(ribcage
()
()
())
#(ribcage
#(e w ae)
#((top)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(top)
(top))
#("i" "i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
'(())))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp1630)
((lambda (%%_1635)
(syntax-error
(%%source-wrap379
%%e1607
%%w1608
%%ae1609)))
%%tmp1610)))
($syntax-dispatch %%tmp1610 '(any any)))))
($syntax-dispatch
%%tmp1610
'(any (any . any) any . each-any)))))
($syntax-dispatch %%tmp1610 '(any any any))))
%%e1607)))
(%%parse-define-syntax446
(lambda (%%e1636 %%w1637 %%ae1638)
((lambda (%%tmp1639)
((lambda (%%tmp1640)
(if (if %%tmp1640
(apply (lambda (%%_1641
%%name1642
%%id1643
%%e11644
%%e21645)
(if (%%id?241 %%name1642)
(%%id?241 %%id1643)
#f))
%%tmp1640)
#f)
(apply (lambda (%%_1646
%%name1647
%%id1648
%%e11649
%%e21650)
(values (%%wrap378 %%name1647 %%w1637)
(cons '#(syntax-object
lambda
((top)
#(ribcage
#(_ name id e1 e2)
#((top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(e w ae)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(cons (%%wrap378
(list %%id1648)
%%w1637)
(%%wrap378
(cons %%e11649
%%e21650)
%%w1637)))
'(())))
%%tmp1640)
((lambda (%%tmp1652)
(if (if %%tmp1652
(apply (lambda (%%_1653
%%name1654
%%val1655)
(%%id?241 %%name1654))
%%tmp1652)
#f)
(apply (lambda (%%_1656 %%name1657 %%val1658)
(values %%name1657
%%val1658
%%w1637))
%%tmp1652)
((lambda (%%_1659)
(syntax-error
(%%source-wrap379
%%e1636
%%w1637
%%ae1638)))
%%tmp1639)))
($syntax-dispatch %%tmp1639 '(any any any)))))
($syntax-dispatch
%%tmp1639
'(any (any any) any . each-any))))
%%e1636)))
(%%parse-meta447
(lambda (%%e1660 %%w1661 %%ae1662)
((lambda (%%tmp1663)
((lambda (%%tmp1664)
(if %%tmp1664
(apply (lambda (%%_1665 %%form1666) %%form1666)
%%tmp1664)
((lambda (%%_1667)
(syntax-error
(%%source-wrap379 %%e1660 %%w1661 %%ae1662)))
%%tmp1663)))
($syntax-dispatch %%tmp1663 '(any . any))))
%%e1660)))
(%%parse-eval-when448
(lambda (%%e1668 %%w1669 %%ae1670)
((lambda (%%tmp1671)
((lambda (%%tmp1672)
(if %%tmp1672
(apply (lambda (%%_1673 %%x1674 %%e11675 %%e21676)
(values (%%chi-when-list380
%%x1674
%%w1669)
(cons %%e11675 %%e21676)))
%%tmp1672)
((lambda (%%_1679)
(syntax-error
(%%source-wrap379 %%e1668 %%w1669 %%ae1670)))
%%tmp1671)))
($syntax-dispatch
%%tmp1671
'(any each-any any . each-any))))
%%e1668)))
(%%parse-alias449
(lambda (%%e1680 %%w1681 %%ae1682)
((lambda (%%tmp1683)
((lambda (%%tmp1684)
(if (if %%tmp1684
(apply (lambda (%%_1685
%%new-id1686
%%old-id1687)
(if (%%id?241 %%new-id1686)
(%%id?241 %%old-id1687)
#f))
%%tmp1684)
#f)
(apply (lambda (%%_1688 %%new-id1689 %%old-id1690)
(values %%new-id1689 %%old-id1690))
%%tmp1684)
((lambda (%%_1691)
(syntax-error
(%%source-wrap379 %%e1680 %%w1681 %%ae1682)))
%%tmp1683)))
($syntax-dispatch %%tmp1683 '(any any any))))
%%e1680)))
(%%parse-begin450
(lambda (%%e1692 %%w1693 %%ae1694 %%empty-okay?1695)
((lambda (%%tmp1696)
((lambda (%%tmp1697)
(if (if %%tmp1697
(apply (lambda (%%_1698) %%empty-okay?1695)
%%tmp1697)
#f)
(apply (lambda (%%_1699) '()) %%tmp1697)
((lambda (%%tmp1700)
(if %%tmp1700
(apply (lambda (%%_1701 %%e11702 %%e21703)
(cons %%e11702 %%e21703))
%%tmp1700)
((lambda (%%_1705)
(syntax-error
(%%source-wrap379
%%e1692
%%w1693
%%ae1694)))
%%tmp1696)))
($syntax-dispatch
%%tmp1696
'(any any . each-any)))))
($syntax-dispatch %%tmp1696 '(any))))
%%e1692)))
(%%chi-lambda-clause451
(lambda (%%e1706 %%c1707 %%r1708 %%mr1709 %%w1710 %%m?1711)
((lambda (%%tmp1712)
((lambda (%%tmp1713)
(if %%tmp1713
(apply (lambda (%%id1714 %%e11715 %%e21716)
((lambda (%%ids1717)
(if (not (%%valid-bound-ids?374
%%ids1717))
(syntax-error
%%e1706
"invalid parameter list in")
((lambda (%%labels1718
%%new-vars1719)
(values %%new-vars1719
(%%chi-body438
(cons %%e11715 %%e21716)
%%e1706
(%%extend-var-env*232
%%labels1718
%%new-vars1719
%%r1708)
%%mr1709
(%%make-binding-wrap352
%%ids1717
%%labels1718
%%w1710)
%%m?1711)))
(%%gen-labels299 %%ids1717)
(map %%gen-var458 %%ids1717))))
%%id1714))
%%tmp1713)
((lambda (%%tmp1722)
(if %%tmp1722
(apply (lambda (%%ids1723 %%e11724 %%e21725)
((lambda (%%old-ids1726)
(if (not (%%valid-bound-ids?374
%%old-ids1726))
(syntax-error
%%e1706
"invalid parameter list in")
((lambda (%%labels1727
%%new-vars1728)
(values ((letrec ((%%f1729 (lambda (%%ls11730
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%ls21731)
(if (null? %%ls11730)
%%ls21731
(%%f1729 (cdr %%ls11730)
(cons (car %%ls11730)
%%ls21731))))))
%%f1729)
(cdr %%new-vars1728)
(car %%new-vars1728))
(%%chi-body438
(cons %%e11724 %%e21725)
%%e1706
(%%extend-var-env*232
%%labels1727
%%new-vars1728
%%r1708)
%%mr1709
(%%make-binding-wrap352
%%old-ids1726
%%labels1727
%%w1710)
%%m?1711)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%gen-labels299
%%old-ids1726)
(map %%gen-var458
%%old-ids1726))))
(%%lambda-var-list459 %%ids1723)))
%%tmp1722)
((lambda (%%_1733) (syntax-error %%e1706))
%%tmp1712)))
($syntax-dispatch
%%tmp1712
'(any any . each-any)))))
($syntax-dispatch %%tmp1712 '(each-any any . each-any))))
%%c1707)))
(%%chi-local-syntax452
(lambda (%%rec?1734 %%e1735 %%r1736 %%mr1737 %%w1738 %%ae1739)
((lambda (%%tmp1740)
((lambda (%%tmp1741)
(if %%tmp1741
(apply (lambda (%%_1742
%%id1743
%%val1744
%%e11745
%%e21746)
((lambda (%%ids1747)
(if (not (%%valid-bound-ids?374
%%ids1747))
(%%invalid-ids-error376
(map (lambda (%%x1748)
(%%wrap378 %%x1748 %%w1738))
%%ids1747)
(%%source-wrap379
%%e1735
%%w1738
%%ae1739)
"keyword")
((lambda (%%labels1749)
((lambda (%%new-w1750)
((lambda (%%b*1751)
(values (cons %%e11745
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e21746)
(%%extend-env*231 %%labels1749 %%b*1751 %%r1736)
(%%extend-env*231 %%labels1749 %%b*1751 %%mr1737)
%%new-w1750
%%ae1739))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%w1753)
(map (lambda (%%x1754)
(%%defer-or-eval-transformer238
%%local-eval-hook70
(%%chi433
%%x1754
%%mr1737
%%mr1737
%%w1753
#t)))
%%val1744))
(if %%rec?1734
%%new-w1750
%%w1738))))
(%%make-binding-wrap352
%%ids1747
%%labels1749
%%w1738)))
(%%gen-labels299 %%ids1747))))
%%id1743))
%%tmp1741)
((lambda (%%_1757)
(syntax-error
(%%source-wrap379 %%e1735 %%w1738 %%ae1739)))
%%tmp1740)))
($syntax-dispatch
%%tmp1740
'(any #(each (any any)) any . each-any))))
%%e1735)))
(%%chi-void453
(lambda ()
(build-source #f (cons (build-source #f 'void) '()))))
(%%ellipsis?454
(lambda (%%x1758)
(if (%%nonsymbol-id?240 %%x1758)
(%%literal-id=?371
%%x1758
'#(syntax-object
...
((top)
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
#f)))
(%%strip-annotation455
(lambda (%%x1759)
(if (pair? %%x1759)
(cons (%%strip-annotation455 (car %%x1759))
(%%strip-annotation455 (cdr %%x1759)))
(if (annotation? %%x1759)
(annotation-stripped %%x1759)
%%x1759))))
(%%strip*456
(lambda (%%x1760 %%w1761 %%fn1762)
(if (memq 'top (%%wrap-marks251 %%w1761))
(%%fn1762 %%x1760)
((letrec ((%%f1763 (lambda (%%x1764)
(if (%%syntax-object?64 %%x1764)
(%%strip*456
(%%syntax-object-expression65
%%x1764)
(%%syntax-object-wrap66 %%x1764)
%%fn1762)
(if (pair? %%x1764)
((lambda (%%a1765 %%d1766)
(if (if (eq? %%a1765
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(car %%x1764))
(eq? %%d1766 (cdr %%x1764))
#f)
%%x1764
(cons %%a1765 %%d1766)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%f1763 (car %%x1764))
(%%f1763 (cdr %%x1764)))
(if (vector? %%x1764)
((lambda (%%old1767)
((lambda (%%new1768)
(if (andmap eq?
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%old1767
%%new1768)
%%x1764
(list->vector %%new1768)))
(map %%f1763 %%old1767)))
(vector->list %%x1764))
%%x1764))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f1763)
%%x1760))))
(%%strip457
(lambda (%%x1769 %%w1770)
(%%strip*456
%%x1769
%%w1770
(lambda (%%x1771)
(if ((lambda (%%t1772)
(if %%t1772
%%t1772
(if (pair? %%x1771)
(annotation? (car %%x1771))
#f)))
(annotation? %%x1771))
(%%strip-annotation455 %%x1771)
%%x1771)))))
(%%gen-var458
(lambda (%%id1773)
((lambda (%%id1774)
(if (annotation? %%id1774)
(gensym (annotation-expression %%id1774))
(gensym %%id1774)))
(if (%%syntax-object?64 %%id1773)
(%%syntax-object-expression65 %%id1773)
%%id1773))))
(%%lambda-var-list459
(lambda (%%vars1775)
((letrec ((%%lvl1776
(lambda (%%vars1777 %%ls1778 %%w1779)
(if (pair? %%vars1777)
(%%lvl1776
(cdr %%vars1777)
(cons (%%wrap378 (car %%vars1777) %%w1779)
%%ls1778)
%%w1779)
(if (%%id?241 %%vars1777)
(cons (%%wrap378 %%vars1777 %%w1779)
%%ls1778)
(if (null? %%vars1777)
%%ls1778
(if (%%syntax-object?64 %%vars1777)
(%%lvl1776
(%%syntax-object-expression65
%%vars1777)
%%ls1778
(%%join-wraps357
%%w1779
(%%syntax-object-wrap66
%%vars1777)))
(if (annotation? %%vars1777)
(%%lvl1776
(annotation-expression
%%vars1777)
%%ls1778
%%w1779)
(cons %%vars1777
%%ls1778)))))))))
%%lvl1776)
%%vars1775
'()
'(())))))
(begin
(set! $sc-put-cte
(lambda (%%id1780 %%b1781 %%top-token1782)
(letrec ((%%sc-put-module1783
(lambda (%%exports1785 %%token1786 %%new-marks1787)
(%%vfor-each423
(lambda (%%id1788)
(%%store-import-binding351
%%id1788
%%token1786
%%new-marks1787))
%%exports1785)))
(%%put-cte1784
(lambda (%%id1789 %%binding1790 %%token1791)
((lambda (%%sym1792)
(begin
(%%store-import-binding351
%%id1789
%%token1791
'())
(%%put-global-definition-hook74
%%sym1792
(if (if (eq? (%%binding-type216
%%binding1790)
'global)
(eq? (%%binding-value217
%%binding1790)
%%sym1792)
#f)
#f
%%binding1790))))
(if (symbol? %%id1789)
%%id1789
(%%id-var-name369 %%id1789 '(())))))))
((lambda (%%binding1793)
((lambda (%%t1794)
(if (memv %%t1794 '($module))
(begin
((lambda (%%iface1795)
(%%sc-put-module1783
(%%interface-exports389 %%iface1795)
(%%interface-token390 %%iface1795)
'()))
(%%binding-value217 %%binding1793))
(%%put-cte1784
%%id1780
%%binding1793
%%top-token1782))
(if (memv %%t1794 '(do-alias))
(%%store-import-binding351
%%id1780
%%top-token1782
'())
(if (memv %%t1794 '(do-import))
((lambda (%%token1796)
((lambda (%%b1797)
((lambda (%%t1798)
(if (memv %%t1798 '($module))
((lambda (%%iface1799)
((lambda (%%exports1800)
((lambda ()
(begin
(if (not (eq? (%%interface-token390
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%iface1799)
%%token1796))
(syntax-error %%id1780 "import mismatch for module")
(void))
(%%sc-put-module1783
(%%interface-exports389 %%iface1799)
%%top-token1782
(%%import-mark-delta440 %%id1780 %%iface1799))))))
(%%interface-exports389 %%iface1799)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%binding-value217
%%b1797))
(syntax-error
%%id1780
"unknown module")))
(%%binding-type216 %%b1797)))
(%%lookup236
(%%id-var-name369 %%id1780 '(()))
'())))
(%%binding-value217 %%b1781))
(%%put-cte1784
%%id1780
%%binding1793
%%top-token1782)))))
(%%binding-type216 %%binding1793)))
(%%make-transformer-binding237 %%b1781)))))
(%%global-extend239
'core
'##c-define-type
(lambda (%%e1801 %%r1802 %%mr1803 %%w1804 %%ae1805 %%m?1806)
(attach-source %%ae1805 (%%strip457 %%e1801 %%w1804))))
(%%global-extend239
'core
'##c-declare
(lambda (%%e1807 %%r1808 %%mr1809 %%w1810 %%ae1811 %%m?1812)
(attach-source %%ae1811 (%%strip457 %%e1807 %%w1810))))
(%%global-extend239
'core
'##c-initialize
(lambda (%%e1813 %%r1814 %%mr1815 %%w1816 %%ae1817 %%m?1818)
(attach-source %%ae1817 (%%strip457 %%e1813 %%w1816))))
(%%global-extend239
'core
'##c-lambda
(lambda (%%e1819 %%r1820 %%mr1821 %%w1822 %%ae1823 %%m?1824)
(attach-source %%ae1823 (%%strip457 %%e1819 %%w1822))))
(%%global-extend239
'core
'##c-define
(lambda (%%e1825 %%r1826 %%mr1827 %%w1828 %%ae1829 %%m?1830)
(attach-source %%ae1829 (%%strip457 %%e1825 %%w1828))))
(%%global-extend239
'core
'##define
(lambda (%%e1831 %%r1832 %%mr1833 %%w1834 %%ae1835 %%m?1836)
(attach-source %%ae1835 (%%strip457 %%e1831 %%w1834))))
(%%global-extend239
'core
'##define-macro
(lambda (%%e1837 %%r1838 %%mr1839 %%w1840 %%ae1841 %%m?1842)
(attach-source %%ae1841 (%%strip457 %%e1837 %%w1840))))
(%%global-extend239
'core
'##define-syntax
(lambda (%%e1843 %%r1844 %%mr1845 %%w1846 %%ae1847 %%m?1848)
(attach-source %%ae1847 (%%strip457 %%e1843 %%w1846))))
(%%global-extend239
'core
'##include
(lambda (%%e1849 %%r1850 %%mr1851 %%w1852 %%ae1853 %%m?1854)
(attach-source %%ae1853 (%%strip457 %%e1849 %%w1852))))
(%%global-extend239
'core
'##declare
(lambda (%%e1855 %%r1856 %%mr1857 %%w1858 %%ae1859 %%m?1860)
(attach-source %%ae1859 (%%strip457 %%e1855 %%w1858))))
(%%global-extend239
'core
'##namespace
(lambda (%%e1861 %%r1862 %%mr1863 %%w1864 %%ae1865 %%m?1866)
(attach-source %%ae1865 (%%strip457 %%e1861 %%w1864))))
(%%global-extend239 'local-syntax 'letrec-syntax #t)
(%%global-extend239 'local-syntax 'let-syntax #f)
(%%global-extend239
'core
'fluid-let-syntax
(lambda (%%e1867 %%r1868 %%mr1869 %%w1870 %%ae1871 %%m?1872)
((lambda (%%tmp1873)
((lambda (%%tmp1874)
(if (if %%tmp1874
(apply (lambda (%%_1875
%%var1876
%%val1877
%%e11878
%%e21879)
(%%valid-bound-ids?374 %%var1876))
%%tmp1874)
#f)
(apply (lambda (%%_1881
%%var1882
%%val1883
%%e11884
%%e21885)
((lambda (%%names1886)
(begin
(for-each
(lambda (%%id1887 %%n1888)
((lambda (%%t1889)
(if (memv %%t1889
'(displaced-lexical))
(%%displaced-lexical-error234
(%%wrap378 %%id1887 %%w1870))
(void)))
(%%binding-type216
(%%lookup236 %%n1888 %%r1868))))
%%var1882
%%names1886)
((lambda (%%b*1891)
(%%chi-body438
(cons %%e11884 %%e21885)
(%%source-wrap379
%%e1867
%%w1870
%%ae1871)
(%%extend-env*231
%%names1886
%%b*1891
%%r1868)
(%%extend-env*231
%%names1886
%%b*1891
%%mr1869)
%%w1870
%%m?1872))
(map (lambda (%%x1893)
(%%defer-or-eval-transformer238
%%local-eval-hook70
(%%chi433
%%x1893
%%mr1869
%%mr1869
%%w1870
#t)))
%%val1883))))
(map (lambda (%%x1895)
(%%id-var-name369 %%x1895 %%w1870))
%%var1882)))
%%tmp1874)
((lambda (%%_1897)
(syntax-error
(%%source-wrap379 %%e1867 %%w1870 %%ae1871)))
%%tmp1873)))
($syntax-dispatch
%%tmp1873
'(any #(each (any any)) any . each-any))))
%%e1867)))
(%%global-extend239
'core
'quote
(lambda (%%e1898 %%r1899 %%mr1900 %%w1901 %%ae1902 %%m?1903)
((lambda (%%tmp1904)
((lambda (%%tmp1905)
(if %%tmp1905
(apply (lambda (%%_1906 %%e1907)
((lambda (%%x1908)
(if (self-eval? (%%strip457 %%e1907 %%w1901))
%%x1908
(build-source
%%ae1902
(list (build-source %%ae1902 'quote)
%%x1908))))
(attach-source
%%ae1902
(%%strip457 %%e1907 %%w1901))))
%%tmp1905)
((lambda (%%_1909)
(syntax-error
(%%source-wrap379 %%e1898 %%w1901 %%ae1902)))
%%tmp1904)))
($syntax-dispatch %%tmp1904 '(any any))))
%%e1898)))
(%%global-extend239
'core
'syntax
((lambda ()
(letrec ((%%gen-syntax1910
(lambda (%%src1918
%%e1919
%%r1920
%%maps1921
%%ellipsis?1922
%%vec?1923)
(if (%%id?241 %%e1919)
((lambda (%%label1924)
((lambda (%%b1925)
(if (eq? (%%binding-type216 %%b1925)
'syntax)
(call-with-values
(lambda ()
((lambda (%%var.lev1926)
(%%gen-ref1911
%%src1918
(car %%var.lev1926)
(cdr %%var.lev1926)
%%maps1921))
(%%binding-value217 %%b1925)))
(lambda (%%var1927 %%maps1928)
(values (list 'ref %%var1927)
%%maps1928)))
(if (%%ellipsis?1922 %%e1919)
(syntax-error
%%src1918
"misplaced ellipsis in syntax form")
(values (list 'quote %%e1919)
%%maps1921))))
(%%lookup236 %%label1924 %%r1920)))
(%%id-var-name369 %%e1919 '(())))
((lambda (%%tmp1929)
((lambda (%%tmp1930)
(if (if %%tmp1930
(apply (lambda (%%dots1931 %%e1932)
(%%ellipsis?1922
%%dots1931))
%%tmp1930)
#f)
(apply (lambda (%%dots1933 %%e1934)
(if %%vec?1923
(syntax-error
%%src1918
"misplaced ellipsis in syntax template")
(%%gen-syntax1910
%%src1918
%%e1934
%%r1920
%%maps1921
(lambda (%%x1935) #f)
#f)))
%%tmp1930)
((lambda (%%tmp1936)
(if (if %%tmp1936
(apply (lambda (%%x1937
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%dots1938
%%y1939)
(%%ellipsis?1922 %%dots1938))
%%tmp1936)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#f)
(apply (lambda (%%x1940
%%dots1941
%%y1942)
((letrec ((%%f1943 (lambda (%%y1944
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%k1945)
((lambda (%%tmp1946)
((lambda (%%tmp1947)
(if (if %%tmp1947
(apply (lambda (%%dots1948
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%y1949)
(%%ellipsis?1922 %%dots1948))
%%tmp1947)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#f)
(apply (lambda (%%dots1950
%%y1951)
(%%f1943 %%y1951
(lambda (%%maps1952)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(call-with-values
(lambda () (%%k1945 (cons '() %%maps1952)))
(lambda (%%x1953 %%maps1954)
(if (null? (car %%maps1954))
(syntax-error
%%src1918
"extra ellipsis in syntax form")
(values (%%gen-mappend1913
%%x1953
(car %%maps1954))
(cdr %%maps1954))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp1947)
((lambda (%%_1955)
(call-with-values
(lambda ()
(%%gen-syntax1910
%%src1918
%%y1944
%%r1920
%%maps1921
%%ellipsis?1922
%%vec?1923))
(lambda (%%y1956 %%maps1957)
(call-with-values
(lambda ()
(%%k1945 %%maps1957))
(lambda (%%x1958
%%maps1959)
(values (%%gen-append1912
%%x1958
%%y1956)
%%maps1959))))))
%%tmp1946)))
($syntax-dispatch
%%tmp1946
'(any . any))))
%%y1944))))
%%f1943)
%%y1942
(lambda (%%maps1960)
(call-with-values
(lambda ()
(%%gen-syntax1910
%%src1918
%%x1940
%%r1920
(cons '() %%maps1960)
%%ellipsis?1922
#f))
(lambda (%%x1961 %%maps1962)
(if (null? (car %%maps1962))
(syntax-error
%%src1918
"extra ellipsis in syntax form")
(values (%%gen-map1914 %%x1961 (car %%maps1962))
(cdr %%maps1962))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp1936)
((lambda (%%tmp1963)
(if %%tmp1963
(apply (lambda (%%x1964
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%y1965)
(call-with-values
(lambda ()
(%%gen-syntax1910
%%src1918
%%x1964
%%r1920
%%maps1921
%%ellipsis?1922
#f))
(lambda (%%xnew1966 %%maps1967)
(call-with-values
(lambda ()
(%%gen-syntax1910
%%src1918
%%y1965
%%r1920
%%maps1967
%%ellipsis?1922
%%vec?1923))
(lambda (%%ynew1968 %%maps1969)
(values (%%gen-cons1915
%%e1919
%%x1964
%%y1965
%%xnew1966
%%ynew1968)
%%maps1969))))))
%%tmp1963)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp1970)
(if %%tmp1970
(apply (lambda (%%x11971
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%x21972)
((lambda (%%ls1973)
(call-with-values
(lambda ()
(%%gen-syntax1910
%%src1918
%%ls1973
%%r1920
%%maps1921
%%ellipsis?1922
#t))
(lambda (%%lsnew1974 %%maps1975)
(values (%%gen-vector1916
%%e1919
%%ls1973
%%lsnew1974)
%%maps1975))))
(cons %%x11971 %%x21972)))
%%tmp1970)
((lambda (%%_1977)
(values (list 'quote %%e1919) %%maps1921))
%%tmp1929)))
($syntax-dispatch %%tmp1929 '#(vector (any . each-any))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp1929
'(any . any)))))
($syntax-dispatch
%%tmp1929
'(any any . any)))))
($syntax-dispatch %%tmp1929 '(any any))))
%%e1919))))
(%%gen-ref1911
(lambda (%%src1978 %%var1979 %%level1980 %%maps1981)
(if (fx= %%level1980 0)
(values %%var1979 %%maps1981)
(if (null? %%maps1981)
(syntax-error
%%src1978
"missing ellipsis in syntax form")
(call-with-values
(lambda ()
(%%gen-ref1911
%%src1978
%%var1979
(fx- %%level1980 1)
(cdr %%maps1981)))
(lambda (%%outer-var1982 %%outer-maps1983)
((lambda (%%b1984)
(if %%b1984
(values (cdr %%b1984) %%maps1981)
((lambda (%%inner-var1985)
(values %%inner-var1985
(cons (cons (cons %%outer-var1982
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%inner-var1985)
(car %%maps1981))
%%outer-maps1983)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%gen-var458 'tmp))))
(assq %%outer-var1982
(car %%maps1981)))))))))
(%%gen-append1912
(lambda (%%x1986 %%y1987)
(if (equal? %%y1987 ''())
%%x1986
(list 'append %%x1986 %%y1987))))
(%%gen-mappend1913
(lambda (%%e1988 %%map-env1989)
(list 'apply
'(primitive append)
(%%gen-map1914 %%e1988 %%map-env1989))))
(%%gen-map1914
(lambda (%%e1990 %%map-env1991)
((lambda (%%formals1992 %%actuals1993)
(if (eq? (car %%e1990) 'ref)
(car %%actuals1993)
(if (andmap (lambda (%%x1994)
(if (eq? (car %%x1994) 'ref)
(memq (cadr %%x1994)
%%formals1992)
#f))
(cdr %%e1990))
(cons 'map
(cons (list 'primitive (car %%e1990))
(map ((lambda (%%r1995)
(lambda (%%x1996)
(cdr (assq (cadr %%x1996)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%r1995))))
(map cons %%formals1992 %%actuals1993))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cdr %%e1990))))
(cons 'map
(cons (list 'lambda
%%formals1992
%%e1990)
%%actuals1993)))))
(map cdr %%map-env1991)
(map (lambda (%%x1997) (list 'ref (car %%x1997)))
%%map-env1991))))
(%%gen-cons1915
(lambda (%%e1998 %%x1999 %%y2000 %%xnew2001 %%ynew2002)
((lambda (%%t2003)
(if (memv %%t2003 '(quote))
(if (eq? (car %%xnew2001) 'quote)
((lambda (%%xnew2004 %%ynew2005)
(if (if (eq? %%xnew2004 %%x1999)
(eq? %%ynew2005 %%y2000)
#f)
(list 'quote %%e1998)
(list 'quote
(cons %%xnew2004
%%ynew2005))))
(cadr %%xnew2001)
(cadr %%ynew2002))
(if (eq? (cadr %%ynew2002) '())
(list 'list %%xnew2001)
(list 'cons %%xnew2001 %%ynew2002)))
(if (memv %%t2003 '(list))
(cons 'list
(cons %%xnew2001 (cdr %%ynew2002)))
(list 'cons %%xnew2001 %%ynew2002))))
(car %%ynew2002))))
(%%gen-vector1916
(lambda (%%e2006 %%ls2007 %%lsnew2008)
(if (eq? (car %%lsnew2008) 'quote)
(if (eq? (cadr %%lsnew2008) %%ls2007)
(list 'quote %%e2006)
(list 'quote
(list->vector (cadr %%lsnew2008))))
(if (eq? (car %%lsnew2008) 'list)
(cons 'vector (cdr %%lsnew2008))
(list 'list->vector %%lsnew2008)))))
(%%regen1917
(lambda (%%x2009)
((lambda (%%t2010)
(if (memv %%t2010 '(ref))
(build-source #f (cadr %%x2009))
(if (memv %%t2010 '(primitive))
(build-source #f (cadr %%x2009))
(if (memv %%t2010 '(quote))
((lambda (%%x2011)
(if (self-eval? (cadr %%x2009))
%%x2011
(build-source
#f
(list (build-source #f 'quote)
%%x2011))))
(attach-source #f (cadr %%x2009)))
(if (memv %%t2010 '(lambda))
(build-source
#f
(list (build-source #f 'lambda)
(build-params
#f
(cadr %%x2009))
(%%regen1917
(caddr %%x2009))))
(if (memv %%t2010 '(map))
((lambda (%%ls2012)
(build-source
#f
(cons (if (fx= (length %%ls2012)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
2)
(build-source #f 'map)
(build-source #f 'map))
%%ls2012)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(map %%regen1917
(cdr %%x2009)))
(build-source
#f
(cons (build-source
#f
(car %%x2009))
(map %%regen1917
(cdr %%x2009))))))))))
(car %%x2009)))))
(lambda (%%e2013 %%r2014 %%mr2015 %%w2016 %%ae2017 %%m?2018)
((lambda (%%e2019)
((lambda (%%tmp2020)
((lambda (%%tmp2021)
(if %%tmp2021
(apply (lambda (%%_2022 %%x2023)
(call-with-values
(lambda ()
(%%gen-syntax1910
%%e2019
%%x2023
%%r2014
'()
%%ellipsis?454
#f))
(lambda (%%e2024 %%maps2025)
(%%regen1917 %%e2024))))
%%tmp2021)
((lambda (%%_2026) (syntax-error %%e2019))
%%tmp2020)))
($syntax-dispatch %%tmp2020 '(any any))))
%%e2019))
(%%source-wrap379 %%e2013 %%w2016 %%ae2017)))))))
(%%global-extend239
'core
'lambda
(lambda (%%e2027 %%r2028 %%mr2029 %%w2030 %%ae2031 %%m?2032)
((lambda (%%tmp2033)
((lambda (%%tmp2034)
(if %%tmp2034
(apply (lambda (%%_2035 %%c2036)
(call-with-values
(lambda ()
(%%chi-lambda-clause451
(%%source-wrap379 %%e2027 %%w2030 %%ae2031)
%%c2036
%%r2028
%%mr2029
%%w2030
%%m?2032))
(lambda (%%vars2037 %%body2038)
(build-source
%%ae2031
(list (build-source %%ae2031 'lambda)
(build-params %%ae2031 %%vars2037)
%%body2038)))))
%%tmp2034)
(syntax-error %%tmp2033)))
($syntax-dispatch %%tmp2033 '(any . any))))
%%e2027)))
(%%global-extend239
'core
'letrec
(lambda (%%e2039 %%r2040 %%mr2041 %%w2042 %%ae2043 %%m?2044)
((lambda (%%tmp2045)
((lambda (%%tmp2046)
(if %%tmp2046
(apply (lambda (%%_2047
%%id2048
%%val2049
%%e12050
%%e22051)
((lambda (%%ids2052)
(if (not (%%valid-bound-ids?374 %%ids2052))
(%%invalid-ids-error376
(map (lambda (%%x2053)
(%%wrap378 %%x2053 %%w2042))
%%ids2052)
(%%source-wrap379
%%e2039
%%w2042
%%ae2043)
"bound variable")
((lambda (%%labels2054 %%new-vars2055)
((lambda (%%w2056 %%r2057)
(%%build-letrec171
%%ae2043
%%new-vars2055
(map (lambda (%%x2058)
(%%chi433
%%x2058
%%r2057
%%mr2041
%%w2056
%%m?2044))
%%val2049)
(%%chi-body438
(cons %%e12050 %%e22051)
(%%source-wrap379
%%e2039
%%w2056
%%ae2043)
%%r2057
%%mr2041
%%w2056
%%m?2044)))
(%%make-binding-wrap352
%%ids2052
%%labels2054
%%w2042)
(%%extend-var-env*232
%%labels2054
%%new-vars2055
%%r2040)))
(%%gen-labels299 %%ids2052)
(map %%gen-var458 %%ids2052))))
%%id2048))
%%tmp2046)
((lambda (%%_2062)
(syntax-error
(%%source-wrap379 %%e2039 %%w2042 %%ae2043)))
%%tmp2045)))
($syntax-dispatch
%%tmp2045
'(any #(each (any any)) any . each-any))))
%%e2039)))
(%%global-extend239
'core
'if
(lambda (%%e2063 %%r2064 %%mr2065 %%w2066 %%ae2067 %%m?2068)
((lambda (%%tmp2069)
((lambda (%%tmp2070)
(if %%tmp2070
(apply (lambda (%%_2071 %%test2072 %%then2073)
(build-source
%%ae2067
(list (build-source %%ae2067 'if)
(%%chi433
%%test2072
%%r2064
%%mr2065
%%w2066
%%m?2068)
(%%chi433
%%then2073
%%r2064
%%mr2065
%%w2066
%%m?2068)
(%%chi-void453))))
%%tmp2070)
((lambda (%%tmp2074)
(if %%tmp2074
(apply (lambda (%%_2075
%%test2076
%%then2077
%%else2078)
(build-source
%%ae2067
(list (build-source %%ae2067 'if)
(%%chi433
%%test2076
%%r2064
%%mr2065
%%w2066
%%m?2068)
(%%chi433
%%then2077
%%r2064
%%mr2065
%%w2066
%%m?2068)
(%%chi433
%%else2078
%%r2064
%%mr2065
%%w2066
%%m?2068))))
%%tmp2074)
((lambda (%%_2079)
(syntax-error
(%%source-wrap379 %%e2063 %%w2066 %%ae2067)))
%%tmp2069)))
($syntax-dispatch %%tmp2069 '(any any any any)))))
($syntax-dispatch %%tmp2069 '(any any any))))
%%e2063)))
(%%global-extend239 'set! 'set! '())
(%%global-extend239 'alias 'alias '())
(%%global-extend239 'begin 'begin '())
(%%global-extend239 '$module-key '$module '())
(%%global-extend239 '$import '$import '())
(%%global-extend239 'define 'define '())
(%%global-extend239 'define-syntax 'define-syntax '())
(%%global-extend239 'eval-when 'eval-when '())
(%%global-extend239 'meta 'meta '())
(%%global-extend239
'core
'syntax-case
((lambda ()
(letrec ((%%convert-pattern2080
(lambda (%%pattern2084 %%keys2085)
(letrec ((%%cvt*2086
(lambda (%%p*2088 %%n2089 %%ids2090)
(if (null? %%p*2088)
(values '() %%ids2090)
(call-with-values
(lambda ()
(%%cvt*2086
(cdr %%p*2088)
%%n2089
%%ids2090))
(lambda (%%y2091 %%ids2092)
(call-with-values
(lambda ()
(%%cvt2087
(car %%p*2088)
%%n2089
%%ids2092))
(lambda (%%x2093 %%ids2094)
(values (cons %%x2093 %%y2091)
%%ids2094))))))))
(%%cvt2087
(lambda (%%p2095 %%n2096 %%ids2097)
(if (%%id?241 %%p2095)
(if (%%bound-id-member?377
%%p2095
%%keys2085)
(values (vector 'free-id %%p2095)
%%ids2097)
(values 'any
(cons (cons %%p2095
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%n2096)
%%ids2097)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2098)
((lambda (%%tmp2099)
(if (if %%tmp2099
(apply (lambda (%%x2100
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%dots2101)
(%%ellipsis?454 %%dots2101))
%%tmp2099)
#f)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(apply (lambda (%%x2102
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%dots2103)
(call-with-values
(lambda () (%%cvt2087 %%x2102 (fx+ %%n2096 1) %%ids2097))
(lambda (%%p2104 %%ids2105)
(values (if (eq? %%p2104 'any)
'each-any
(vector 'each %%p2104))
%%ids2105))))
%%tmp2099)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2106)
(if (if %%tmp2106
(apply (lambda (%%x2107
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%dots2108
%%y2109
%%z2110)
(%%ellipsis?454 %%dots2108))
%%tmp2106)
#f)
(apply (lambda (%%x2111 %%dots2112 %%y2113 %%z2114)
(call-with-values
(lambda () (%%cvt2087 %%z2114 %%n2096 %%ids2097))
(lambda (%%z2115 %%ids2116)
(call-with-values
(lambda ()
(%%cvt*2086 %%y2113 %%n2096 %%ids2116))
(lambda (%%y2118 %%ids2119)
(call-with-values
(lambda ()
(%%cvt2087
%%x2111
(fx+ %%n2096 1)
%%ids2119))
(lambda (%%x2120 %%ids2121)
(values (vector 'each+
%%x2120
(reverse %%y2118)
%%z2115)
%%ids2121))))))))
%%tmp2106)
((lambda (%%tmp2122)
(if %%tmp2122
(apply (lambda (%%x2123 %%y2124)
(call-with-values
(lambda ()
(%%cvt2087 %%y2124 %%n2096 %%ids2097))
(lambda (%%y2125 %%ids2126)
(call-with-values
(lambda ()
(%%cvt2087 %%x2123 %%n2096 %%ids2126))
(lambda (%%x2127 %%ids2128)
(values (cons %%x2127 %%y2125)
%%ids2128))))))
%%tmp2122)
((lambda (%%tmp2129)
(if %%tmp2129
(apply (lambda () (values '() %%ids2097))
%%tmp2129)
((lambda (%%tmp2130)
(if %%tmp2130
(apply (lambda (%%x2131)
(call-with-values
(lambda ()
(%%cvt2087
%%x2131
%%n2096
%%ids2097))
(lambda (%%p2133 %%ids2134)
(values (vector 'vector
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%p2133)
%%ids2134))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2130)
((lambda (%%x2135)
(values (vector 'atom
(%%strip457
%%p2095
'(())))
%%ids2097))
%%tmp2098)))
($syntax-dispatch
%%tmp2098
'#(vector each-any)))))
($syntax-dispatch %%tmp2098 '()))))
($syntax-dispatch %%tmp2098 '(any . any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2098
'(any any
.
#(each+
any
()
any))))))
($syntax-dispatch
%%tmp2098
'(any any))))
%%p2095)))))
(%%cvt2087 %%pattern2084 0 '()))))
(%%build-dispatch-call2081
(lambda (%%pvars2136
%%exp2137
%%y2138
%%r2139
%%mr2140
%%m?2141)
((lambda (%%ids2142 %%levels2143)
((lambda (%%labels2144 %%new-vars2145)
(build-source
#f
(cons (build-source #f 'apply)
(list (build-source
#f
(list (build-source #f 'lambda)
(build-params
#f
%%new-vars2145)
(%%chi433
%%exp2137
(%%extend-env*231
%%labels2144
(map (lambda (%%var2146
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%level2147)
(cons 'syntax (cons %%var2146 %%level2147)))
%%new-vars2145
(map cdr %%pvars2136))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%r2139)
%%mr2140
(%%make-binding-wrap352
%%ids2142
%%labels2144
'(()))
%%m?2141)))
%%y2138))))
(%%gen-labels299 %%ids2142)
(map %%gen-var458 %%ids2142)))
(map car %%pvars2136)
(map cdr %%pvars2136))))
(%%gen-clause2082
(lambda (%%x2148
%%keys2149
%%clauses2150
%%r2151
%%mr2152
%%m?2153
%%pat2154
%%fender2155
%%exp2156)
(call-with-values
(lambda ()
(%%convert-pattern2080 %%pat2154 %%keys2149))
(lambda (%%p2157 %%pvars2158)
(if (not (%%distinct-bound-ids?375
(map car %%pvars2158)))
(%%invalid-ids-error376
(map car %%pvars2158)
%%pat2154
"pattern variable")
(if (not (andmap (lambda (%%x2159)
(not (%%ellipsis?454
(car %%x2159))))
%%pvars2158))
(syntax-error
%%pat2154
"misplaced ellipsis in syntax-case pattern")
((lambda (%%y2160)
(build-source
#f
(cons (build-source
#f
(list (build-source #f 'lambda)
(build-params
#f
(list %%y2160))
(build-source
#f
(list (build-source
#f
'if)
((lambda (%%tmp2170)
((lambda (%%tmp2171)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if %%tmp2171
(apply (lambda () (build-source #f %%y2160))
%%tmp2171)
((lambda (%%_2172)
(build-source
#f
(list (build-source #f 'if)
(build-source #f %%y2160)
(%%build-dispatch-call2081
%%pvars2158
%%fender2155
(build-source #f %%y2160)
%%r2151
%%mr2152
%%m?2153)
((lambda (%%x2173)
(if (self-eval? #f)
%%x2173
(build-source
#f
(list (build-source #f 'quote)
%%x2173))))
(attach-source #f #f)))))
%%tmp2170)))
($syntax-dispatch %%tmp2170 '#(atom #t))))
%%fender2155)
(%%build-dispatch-call2081
%%pvars2158
%%exp2156
(build-source #f %%y2160)
%%r2151
%%mr2152
%%m?2153)
(%%gen-syntax-case2083
%%x2148
%%keys2149
%%clauses2150
%%r2151
%%mr2152
%%m?2153)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(list (if (eq? %%p2157 'any)
(build-source
#f
(cons (build-source
#f
'list)
(list (build-source
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'value
%%x2148))))
(build-source
#f
(cons (build-source #f '$syntax-dispatch)
(list (build-source 'value %%x2148)
((lambda (%%x2174)
(if (self-eval? %%p2157)
%%x2174
(build-source
#f
(list (build-source #f 'quote) %%x2174))))
(attach-source #f %%p2157))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%gen-var458 'tmp))))))))
(%%gen-syntax-case2083
(lambda (%%x2175
%%keys2176
%%clauses2177
%%r2178
%%mr2179
%%m?2180)
(if (null? %%clauses2177)
(build-source
#f
(cons (build-source #f 'syntax-error)
(list (build-source #f %%x2175))))
((lambda (%%tmp2181)
((lambda (%%tmp2182)
(if %%tmp2182
(apply (lambda (%%pat2183 %%exp2184)
(if (if (%%id?241 %%pat2183)
(if (not (%%bound-id-member?377
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%pat2183
%%keys2176))
(not (%%ellipsis?454 %%pat2183))
#f)
#f)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%label2185
%%var2186)
(build-source
#f
(cons (build-source
#f
(list (build-source
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#f
'lambda)
(build-params #f (list %%var2186))
(%%chi433
%%exp2184
(%%extend-env230
%%label2185
(cons 'syntax (cons %%var2186 0))
%%r2178)
%%mr2179
(%%make-binding-wrap352
(list %%pat2183)
(list %%label2185)
'(()))
%%m?2180)))
(list (build-source #f %%x2175)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%gen-label297)
(%%gen-var458 %%pat2183))
(%%gen-clause2082
%%x2175
%%keys2176
(cdr %%clauses2177)
%%r2178
%%mr2179
%%m?2180
%%pat2183
#t
%%exp2184)))
%%tmp2182)
((lambda (%%tmp2187)
(if %%tmp2187
(apply (lambda (%%pat2188
%%fender2189
%%exp2190)
(%%gen-clause2082
%%x2175
%%keys2176
(cdr %%clauses2177)
%%r2178
%%mr2179
%%m?2180
%%pat2188
%%fender2189
%%exp2190))
%%tmp2187)
((lambda (%%_2191)
(syntax-error
(car %%clauses2177)
"invalid syntax-case clause"))
%%tmp2181)))
($syntax-dispatch
%%tmp2181
'(any any any)))))
($syntax-dispatch %%tmp2181 '(any any))))
(car %%clauses2177))))))
(lambda (%%e2192 %%r2193 %%mr2194 %%w2195 %%ae2196 %%m?2197)
((lambda (%%e2198)
((lambda (%%tmp2199)
((lambda (%%tmp2200)
(if %%tmp2200
(apply (lambda (%%_2201
%%val2202
%%key2203
%%m2204)
(if (andmap (lambda (%%x2205)
(if (%%id?241 %%x2205)
(not (%%ellipsis?454
%%x2205))
#f))
%%key2203)
((lambda (%%x2207)
(build-source
%%ae2196
(cons (build-source
#f
(list (build-source
#f
'lambda)
(build-params
#f
(list %%x2207))
(%%gen-syntax-case2083
%%x2207
%%key2203
%%m2204
%%r2193
%%mr2194
%%m?2197)))
(list (%%chi433
%%val2202
%%r2193
%%mr2194
'(())
%%m?2197)))))
(%%gen-var458 'tmp))
(syntax-error
%%e2198
"invalid literals list in")))
%%tmp2200)
(syntax-error %%tmp2199)))
($syntax-dispatch
%%tmp2199
'(any any each-any . each-any))))
%%e2198))
(%%source-wrap379 %%e2192 %%w2195 %%ae2196)))))))
(%%put-cte-hook72
'module
(lambda (%%x2210)
(letrec ((%%proper-export?2211
(lambda (%%e2212)
((lambda (%%tmp2213)
((lambda (%%tmp2214)
(if %%tmp2214
(apply (lambda (%%id2215 %%e2216)
(if (identifier? %%id2215)
(andmap %%proper-export?2211
%%e2216)
#f))
%%tmp2214)
((lambda (%%id2218) (identifier? %%id2218))
%%tmp2213)))
($syntax-dispatch %%tmp2213 '(any . each-any))))
%%e2212))))
((lambda (%%tmp2219)
((lambda (%%orig2220)
((lambda (%%tmp2221)
((lambda (%%tmp2222)
(if %%tmp2222
(apply (lambda (%%_2223 %%e2224 %%d2225)
(if (andmap %%proper-export?2211
%%e2224)
(list '#(syntax-object
begin
((top)
#(ribcage
#(_ e d)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(orig)
#((top))
#("i"))
#(ribcage
(proper-export?)
((top))
("i"))
#(ribcage
#(x)
#((top))
#("i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(cons '#(syntax-object
$module
((top)
#(ribcage
#(_ e d)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage
#(orig)
#((top))
#("i"))
#(ribcage
(proper-export?)
((top))
("i"))
#(ribcage
#(x)
#((top))
#("i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t)))
(cons %%orig2220
(cons '#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
anon
((top)
#(ribcage
#(_ e d)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage #(orig) #((top)) #("i"))
#(ribcage (proper-export?) ((top)) ("i"))
#(ribcage #(x) #((top)) #("i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(cons %%e2224 %%d2225))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cons '#(syntax-object
$import
((top)
#(ribcage
#(_ e d)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage
#(orig)
#((top))
#("i"))
#(ribcage
(proper-export?)
((top))
("i"))
#(ribcage
#(x)
#((top))
#("i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t)))
(cons %%orig2220
'#(syntax-object
(#f anon)
((top)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(ribcage
#(_ e d)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage #(orig) #((top)) #("i"))
#(ribcage (proper-export?) ((top)) ("i"))
#(ribcage #(x) #((top)) #("i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(syntax-error
%%x2210
"invalid exports list in")))
%%tmp2222)
((lambda (%%tmp2229)
(if (if %%tmp2229
(apply (lambda (%%_2230
%%m2231
%%e2232
%%d2233)
(identifier? %%m2231))
%%tmp2229)
#f)
(apply (lambda (%%_2234
%%m2235
%%e2236
%%d2237)
(if (andmap %%proper-export?2211
%%e2236)
(cons '#(syntax-object
$module
((top)
#(ribcage
#(_ m e d)
#((top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"))
#(ribcage
#(orig)
#((top))
#("i"))
#(ribcage
(proper-export?)
((top))
("i"))
#(ribcage
#(x)
#((top))
#("i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t)))
(cons %%orig2220
(cons %%m2235
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(cons %%e2236 %%d2237))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(syntax-error
%%x2210
"invalid exports list in")))
%%tmp2229)
(syntax-error %%tmp2221)))
($syntax-dispatch
%%tmp2221
'(any any each-any . each-any)))))
($syntax-dispatch
%%tmp2221
'(any each-any . each-any))))
%%x2210))
%%tmp2219))
%%x2210))))
((lambda ()
(letrec ((%%$module-exports2241
(lambda (%%m2243 %%r2244)
((lambda (%%b2245)
((lambda (%%t2246)
(if (memv %%t2246 '($module))
((lambda (%%interface2247)
((lambda (%%new-marks2248)
((lambda ()
(%%vmap422
(lambda (%%x2249)
((lambda (%%id2250)
(%%make-syntax-object63
(syntax-object->datum
%%id2250)
((lambda (%%marks2251)
(%%make-wrap250
%%marks2251
(if (eq? (car %%marks2251)
#f)
(cons 'shift
(%%wrap-subst252
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'((top))))
(%%wrap-subst252 '((top))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%join-marks358
%%new-marks2248
(%%wrap-marks251
(%%syntax-object-wrap66
%%id2250))))))
(if (pair? %%x2249)
(car %%x2249)
%%x2249)))
(%%interface-exports389
%%interface2247)))))
(%%import-mark-delta440
%%m2243
%%interface2247)))
(%%binding-value217 %%b2245))
(if (memv %%t2246 '(displaced-lexical))
(%%displaced-lexical-error234 %%m2243)
(syntax-error
%%m2243
"unknown module"))))
(%%binding-type216 %%b2245)))
(%%r2244 %%m2243))))
(%%$import-help2242
(lambda (%%orig2252 %%import-only?2253)
(lambda (%%r2254)
(letrec ((%%difference2255
(lambda (%%ls12261 %%ls22262)
(if (null? %%ls12261)
%%ls12261
(if (%%bound-id-member?377
(car %%ls12261)
%%ls22262)
(%%difference2255
(cdr %%ls12261)
%%ls22262)
(cons (car %%ls12261)
(%%difference2255
(cdr %%ls12261)
%%ls22262))))))
(%%prefix-add2256
(lambda (%%prefix-id2263)
((lambda (%%prefix2264)
(lambda (%%id2265)
(datum->syntax-object
%%id2265
(string->symbol
(string-append
%%prefix2264
(symbol->string
(syntax-object->datum
%%id2265)))))))
(symbol->string
(syntax-object->datum
%%prefix-id2263)))))
(%%prefix-drop2257
(lambda (%%prefix-id2266)
((lambda (%%prefix2267)
(lambda (%%id2268)
((lambda (%%s2269)
((lambda (%%np2270 %%ns2271)
(begin
(if (not (if (>= %%ns2271
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%np2270)
(string=? (substring %%s2269 0 %%np2270) %%prefix2267)
#f))
(syntax-error
%%id2268
(string-append "missing expected prefix " %%prefix2267))
(void))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(datum->syntax-object
%%id2268
(string->symbol
(substring
%%s2269
%%np2270
%%ns2271)))))
(string-length %%prefix2267)
(string-length %%s2269)))
(symbol->string
(syntax-object->datum
%%id2268)))))
(symbol->string
(syntax-object->datum
%%prefix-id2266)))))
(%%gen-mid2258
(lambda (%%mid2272)
(datum->syntax-object
%%mid2272
(%%generate-id78
((lambda (%%x2273)
((lambda (%%e2274)
(if (annotation? %%e2274)
(annotation-expression
%%e2274)
%%e2274))
(if (%%syntax-object?64 %%x2273)
(%%syntax-object-expression65
%%x2273)
%%x2273)))
%%mid2272)))))
(%%modspec2259
(lambda (%%m2275 %%exports?2276)
((lambda (%%tmp2277)
((lambda (%%tmp2278)
(if %%tmp2278
(apply (lambda (%%orig2279
%%import-only?2280)
((lambda (%%tmp2281)
((lambda (%%tmp2282)
(if (if %%tmp2282
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(apply (lambda (%%m2283 %%id2284)
(andmap identifier? %%id2284))
%%tmp2282)
#f)
(apply (lambda (%%m2286 %%id2287)
(call-with-values
(lambda () (%%modspec2259 %%m2286 #f))
(lambda (%%mid2288 %%d2289 %%exports2290)
((lambda (%%tmp2291)
((lambda (%%tmp2292)
(if %%tmp2292
(apply (lambda (%%d2293
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmid2294)
(values %%mid2288
(list '#(syntax-object
begin
((top)
#(ribcage
#(d tmid)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
$module
((top)
#(ribcage
#(d tmid)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2279
%%tmid2294
%%id2287
%%d2293)
(list '#(syntax-object
$import
((top)
#(ribcage
#(d tmid)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2279
%%import-only?2280
%%tmid2294))
(if %%exports?2276 %%id2287 #f)))
%%tmp2292)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(syntax-error %%tmp2291)))
($syntax-dispatch
%%tmp2291
'(any any))))
(list %%d2289
(%%gen-mid2258 %%mid2288))))))
%%tmp2282)
((lambda (%%tmp2297)
(if (if %%tmp2297
(apply (lambda (%%m2298 %%id2299)
(andmap identifier? %%id2299))
%%tmp2297)
#f)
(apply (lambda (%%m2301 %%id2302)
(call-with-values
(lambda ()
(%%modspec2259 %%m2301 #t))
(lambda (%%mid2303
%%d2304
%%exports2305)
((lambda (%%tmp2306)
((lambda (%%tmp2307)
(if %%tmp2307
(apply (lambda (%%d2308
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmid2309
%%id2310)
(values %%mid2303
(list '#(syntax-object
begin
((top)
#(ribcage
#(d tmid id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
$module
((top)
#(ribcage
#(d tmid id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2279
%%tmid2309
%%id2310
%%d2308)
(list '#(syntax-object
$import
((top)
#(ribcage
#(d tmid id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2279
%%import-only?2280
%%tmid2309))
(if %%exports?2276 %%id2310 #f)))
%%tmp2307)
(syntax-error %%tmp2306)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2306
'(any any each-any))))
(list %%d2304
(%%gen-mid2258 %%mid2303)
(%%difference2255
%%exports2305
%%id2302))))))
%%tmp2297)
((lambda (%%tmp2314)
(if (if %%tmp2314
(apply (lambda (%%m2315
%%prefix-id2316)
(identifier?
%%prefix-id2316))
%%tmp2314)
#f)
(apply (lambda (%%m2317
%%prefix-id2318)
(call-with-values
(lambda ()
(%%modspec2259
%%m2317
#t))
(lambda (%%mid2319
%%d2320
%%exports2321)
((lambda (%%tmp2322)
((lambda (%%tmp2323)
(if %%tmp2323
(apply (lambda (%%d2324
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmid2325
%%old-id2326
%%tmp2327
%%id2328)
(values %%mid2319
(list '#(syntax-object
begin
((top)
#(ribcage
#(d tmid old-id tmp id)
#((top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m prefix-id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(cons '#(syntax-object
$module
((top)
#(ribcage
#(d
tmid
old-id
tmp
id)
#((top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m prefix-id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t)))
(cons %%orig2279
(cons %%tmid2325
(cons (map list
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%id2328
%%tmp2327)
(cons (cons '#(syntax-object
$module
((top)
#(ribcage
#(d tmid old-id tmp id)
#((top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m prefix-id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(cons %%orig2279
(cons %%tmid2325
(cons (map list
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmp2327
%%old-id2326)
(cons %%d2324
(map (lambda (%%tmp2334 %%tmp2333)
(list '#(syntax-object
alias
((top)
#(ribcage
#(d tmid old-id tmp id)
#((top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m prefix-id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%tmp2333
%%tmp2334))
%%old-id2326
%%tmp2327))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cons (list '#(syntax-object
$import
((top)
#(ribcage
#(d tmid old-id tmp id)
#((top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m prefix-id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2279
%%import-only?2280
%%tmid2325)
(map (lambda (%%tmp2336 %%tmp2335)
(list '#(syntax-object
alias
((top)
#(ribcage
#(d
tmid
old-id
tmp
id)
#((top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage
#(m prefix-id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig
import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig
import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t)))
%%tmp2335
%%tmp2336))
%%tmp2327
%%id2328)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(list '#(syntax-object
$import
((top)
#(ribcage
#(d
tmid
old-id
tmp
id)
#((top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m prefix-id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t)))
%%orig2279
%%import-only?2280
%%tmid2325))
(if %%exports?2276 %%id2328 #f)))
%%tmp2323)
(syntax-error %%tmp2322)))
($syntax-dispatch
%%tmp2322
'(any any each-any each-any each-any))))
(list %%d2320
(%%gen-mid2258 %%mid2319)
%%exports2321
(generate-temporaries %%exports2321)
(map (%%prefix-add2256 %%prefix-id2318) %%exports2321))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2314)
((lambda (%%tmp2338)
(if (if %%tmp2338
(apply (lambda (%%m2339
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%prefix-id2340)
(identifier? %%prefix-id2340))
%%tmp2338)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#f)
(apply (lambda (%%m2341
%%prefix-id2342)
(call-with-values
(lambda ()
(%%modspec2259
%%m2341
#t))
(lambda (%%mid2343
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%d2344
%%exports2345)
((lambda (%%tmp2346)
((lambda (%%tmp2347)
(if %%tmp2347
(apply (lambda (%%d2348
%%tmid2349
%%old-id2350
%%tmp2351
%%id2352)
(values %%mid2343
(list '#(syntax-object
begin
((top)
#(ribcage
#(d
tmid
old-id
tmp
id)
#((top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m prefix-id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t)))
(cons '#(syntax-object
$module
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(d tmid old-id tmp id)
#((top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage #(m prefix-id) #((top) (top)) #("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(m exports?) #((top) (top)) #("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(cons %%orig2279
(cons %%tmid2349
(cons (map list %%id2352 %%tmp2351)
(cons (cons '#(syntax-object
$module
((top)
#(ribcage
#(d tmid old-id tmp id)
#((top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m prefix-id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(cons %%orig2279
(cons %%tmid2349
(cons (map list
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmp2351
%%old-id2350)
(cons %%d2348
(map (lambda (%%tmp2358 %%tmp2357)
(list '#(syntax-object
alias
((top)
#(ribcage
#(d tmid old-id tmp id)
#((top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m prefix-id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%tmp2357
%%tmp2358))
%%old-id2350
%%tmp2351))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cons (list '#(syntax-object
$import
((top)
#(ribcage
#(d
tmid
old-id
tmp
id)
#((top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage
#(m prefix-id)
#((top) (top))
#("i" "i"))
#(ribcage
#(orig
import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig
import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t)))
%%orig2279
%%import-only?2280
%%tmid2349)
(map (lambda (%%tmp2360
%%tmp2359)
(list '#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
alias
((top)
#(ribcage
#(d tmid old-id tmp id)
#((top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage #(m prefix-id) #((top) (top)) #("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(m exports?) #((top) (top)) #("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%tmp2359
%%tmp2360))
%%tmp2351
%%id2352)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(list '#(syntax-object
$import
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(d tmid old-id tmp id)
#((top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage #(m prefix-id) #((top) (top)) #("i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(m exports?) #((top) (top)) #("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2279
%%import-only?2280
%%tmid2349))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(if %%exports?2276
%%id2352
#f)))
%%tmp2347)
(syntax-error %%tmp2346)))
($syntax-dispatch
%%tmp2346
'(any any each-any each-any each-any))))
(list %%d2344
(%%gen-mid2258 %%mid2343)
%%exports2345
(generate-temporaries %%exports2345)
(map (%%prefix-drop2257 %%prefix-id2342)
%%exports2345))))))
%%tmp2338)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2362)
(if (if %%tmp2362
(apply (lambda (%%m2363
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%new-id2364
%%old-id2365)
(if (andmap identifier? %%new-id2364)
(andmap identifier? %%old-id2365)
#f))
%%tmp2362)
#f)
(apply (lambda (%%m2368 %%new-id2369 %%old-id2370)
(call-with-values
(lambda () (%%modspec2259 %%m2368 #t))
(lambda (%%mid2371 %%d2372 %%exports2373)
((lambda (%%tmp2374)
((lambda (%%tmp2375)
(if %%tmp2375
(apply (lambda (%%d2376
%%tmid2377
%%tmp2378
%%other-id2379)
(values %%mid2371
(list '#(syntax-object
begin
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(d tmid tmp other-id)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m new-id old-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(m exports?) #((top) (top)) #("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(cons '#(syntax-object
$module
((top)
#(ribcage
#(d tmid tmp other-id)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m new-id old-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(cons %%orig2279
(cons %%tmid2377
(cons (append (map list
%%new-id2369
%%tmp2378)
%%other-id2379)
(cons (cons '#(syntax-object
$module
((top)
#(ribcage
#(d
tmid
tmp
other-id)
#((top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage
#(m
new-id
old-id)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage
#(orig
import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig
import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t)))
(cons %%orig2279
(cons %%tmid2377
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(cons (append %%other-id2379
(map list %%tmp2378 %%old-id2370))
(cons %%d2376
(map (lambda (%%tmp2387 %%tmp2386)
(list '#(syntax-object
alias
((top)
#(ribcage
#(d
tmid
tmp
other-id)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m new-id old-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t)))
%%tmp2386
%%tmp2387))
%%old-id2370
%%tmp2378))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cons (list '#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$import
((top)
#(ribcage
#(d tmid tmp other-id)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m new-id old-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(m exports?) #((top) (top)) #("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2279
%%import-only?2280
%%tmid2377)
(map (lambda (%%tmp2389 %%tmp2388)
(list '#(syntax-object
alias
((top)
#(ribcage
#(d tmid tmp other-id)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m new-id old-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%tmp2388
%%tmp2389))
%%tmp2378
%%new-id2369)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(list '#(syntax-object
$import
((top)
#(ribcage
#(d tmid tmp other-id)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m new-id old-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2279
%%import-only?2280
%%tmid2377))
(if %%exports?2276 (append %%new-id2369 %%other-id2379) #f)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2375)
(syntax-error %%tmp2374)))
($syntax-dispatch
%%tmp2374
'(any any each-any each-any))))
(list %%d2372
(%%gen-mid2258 %%mid2371)
(generate-temporaries %%old-id2370)
(%%difference2255
%%exports2373
%%old-id2370))))))
%%tmp2362)
((lambda (%%tmp2394)
(if (if %%tmp2394
(apply (lambda (%%m2395 %%new-id2396 %%old-id2397)
(if (andmap identifier? %%new-id2396)
(andmap identifier? %%old-id2397)
#f))
%%tmp2394)
#f)
(apply (lambda (%%m2400 %%new-id2401 %%old-id2402)
(call-with-values
(lambda () (%%modspec2259 %%m2400 #t))
(lambda (%%mid2403 %%d2404 %%exports2405)
((lambda (%%tmp2406)
((lambda (%%tmp2407)
(if %%tmp2407
(apply (lambda (%%d2408
%%tmid2409
%%other-id2410)
(values %%mid2403
(list '#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
begin
((top)
#(ribcage
#(d tmid other-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m new-id old-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(cons '#(syntax-object
$module
((top)
#(ribcage
#(d tmid other-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m new-id old-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(cons %%orig2279
(cons %%tmid2409
(cons (append (map list
%%new-id2401
%%old-id2402)
%%other-id2410)
(cons %%d2408
(map (lambda (%%tmp2415
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmp2414)
(list '#(syntax-object
alias
((top)
#(ribcage
#(d tmid other-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m new-id old-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%tmp2414
%%tmp2415))
%%old-id2402
%%new-id2401))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(list '#(syntax-object
$import
((top)
#(ribcage
#(d tmid other-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(mid d exports)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(m new-id old-id)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2279
%%import-only?2280
%%tmid2409))
(if %%exports?2276
(append %%new-id2401 %%other-id2410)
#f)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2407)
(syntax-error %%tmp2406)))
($syntax-dispatch
%%tmp2406
'(any any each-any))))
(list %%d2404
(%%gen-mid2258 %%mid2403)
%%exports2405)))))
%%tmp2394)
((lambda (%%tmp2418)
(if (if %%tmp2418
(apply (lambda (%%mid2419)
(identifier? %%mid2419))
%%tmp2418)
#f)
(apply (lambda (%%mid2420)
(values %%mid2420
(list '#(syntax-object
$import
((top)
#(ribcage
#(mid)
#((top))
#("i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t)))
%%orig2279
%%import-only?2280
%%mid2420)
(if %%exports?2276
(%%$module-exports2241
%%mid2420
%%r2254)
#f)))
%%tmp2418)
((lambda (%%tmp2421)
(if (if %%tmp2421
(apply (lambda (%%mid2422)
(identifier? %%mid2422))
%%tmp2421)
#f)
(apply (lambda (%%mid2423)
(values %%mid2423
(list '#(syntax-object
$import
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(mid)
#((top))
#("i"))
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(m exports?) #((top) (top)) #("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2279
%%import-only?2280
%%mid2423)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(if %%exports?2276
(%%$module-exports2241
%%mid2423
%%r2254)
#f)))
%%tmp2421)
((lambda (%%_2424)
(syntax-error
%%m2275
"invalid module specifier"))
%%tmp2281)))
($syntax-dispatch %%tmp2281 '(any)))))
(list %%tmp2281))))
($syntax-dispatch
%%tmp2281
'(#(free-id
#(syntax-object
alias
((top)
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(m exports?) #((top) (top)) #("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
any
.
#(each (any any)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2281
'(#(free-id
#(syntax-object
rename
((top)
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t))))
any
.
#(each (any any)))))))
($syntax-dispatch
%%tmp2281
'(#(free-id
#(syntax-object
drop-prefix
((top)
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i"))
#(ribcage
#(r)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help
$module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
any
any)))))
($syntax-dispatch
%%tmp2281
'(#(free-id
#(syntax-object
add-prefix
((top)
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
any
any)))))
($syntax-dispatch
%%tmp2281
'(#(free-id
#(syntax-object
except
((top)
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(m exports?)
#((top) (top))
#("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
any
.
each-any)))))
($syntax-dispatch
%%tmp2281
'(#(free-id
#(syntax-object
only
((top)
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(m exports?) #((top) (top)) #("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
any
.
each-any))))
%%m2275))
%%tmp2278)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(syntax-error %%tmp2277)))
($syntax-dispatch
%%tmp2277
'(any any))))
(list %%orig2252 %%import-only?2253))))
(%%modspec*2260
(lambda (%%m2425)
(call-with-values
(lambda () (%%modspec2259 %%m2425 #f))
(lambda (%%mid2426
%%d2427
%%exports2428)
%%d2427)))))
((lambda (%%tmp2429)
((lambda (%%tmp2430)
(if %%tmp2430
(apply (lambda (%%_2431 %%m2432)
((lambda (%%tmp2433)
((lambda (%%tmp2434)
(if %%tmp2434
(apply (lambda (%%d2435)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(cons '#(syntax-object
begin
((top)
#(ribcage #(d) #((top)) #("i"))
#(ribcage #(_ m) #((top) (top)) #("i" "i"))
#(ribcage
(modspec*
modspec
gen-mid
prefix-drop
prefix-add
difference)
((top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i"))
#(ribcage #(r) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(orig import-only?)
#((top) (top))
#("i" "i"))
#(ribcage
($import-help $module-exports)
((top) (top))
("i" "i"))
#(ribcage
(lambda-var-list
gen-var
strip
strip*
strip-annotation
ellipsis?
chi-void
chi-local-syntax
chi-lambda-clause
parse-begin
parse-alias
parse-eval-when
parse-meta
parse-define-syntax
parse-define
parse-import
parse-module
do-import!
lookup-import-label
import-mark-delta
chi-internal
chi-body
chi-macro
chi-set!
chi-application
chi-expr
chi
chi-sequence
chi-meta-frob
chi-frobs
ct-eval/residualize3
ct-eval/residualize2
rt-eval/residualize
initial-mode-set
update-mode-set
do-top-import
vfor-each
vmap
chi-external
check-defined-ids
check-module-exports
id-set-diff
chi-top-module
set-frob-meta?!
set-frob-e!
frob-meta?
frob-e
frob?
make-frob
create-module-binding
set-module-binding-exported!
set-module-binding-val!
set-module-binding-imps!
set-module-binding-label!
set-module-binding-id!
set-module-binding-type!
module-binding-exported
module-binding-val
module-binding-imps
module-binding-label
module-binding-id
module-binding-type
module-binding?
make-module-binding
make-resolved-interface
make-unresolved-interface
set-interface-token!
set-interface-exports!
set-interface-marks!
interface-token
interface-exports
interface-marks
interface?
make-interface
flatten-exports
chi-top
chi-top-sequence
chi-top*
syntax-type
chi-when-list
source-wrap
wrap
bound-id-member?
invalid-ids-error
distinct-bound-ids?
valid-bound-ids?
bound-id=?
help-bound-id=?
literal-id=?
free-id=?
id-var-name
id-var-name-loc
id-var-name&marks
id-var-name-loc&marks
top-id-free-var-name
top-id-bound-var-name
anon
diff-marks
same-marks?
join-subst
join-marks
join-wraps
smart-append
resolved-id-var-name
id->resolved-id
make-resolved-id
make-binding-wrap
store-import-binding
lookup-import-binding-name
extend-ribcage-subst!
extend-ribcage-barrier-help!
extend-ribcage-barrier!
import-extend-ribcage!
extend-ribcage!
make-empty-ribcage
barrier-marker
new-mark
anti-mark
the-anti-mark
set-env-wrap!
set-env-top-ribcage!
env-wrap
env-top-ribcage
env?
make-env
set-import-interface-new-marks!
set-import-interface-interface!
import-interface-new-marks
import-interface-interface
import-interface?
make-import-interface
set-top-ribcage-mutable?!
set-top-ribcage-key!
top-ribcage-mutable?
top-ribcage-key
top-ribcage?
make-top-ribcage
set-ribcage-labels!
set-ribcage-marks!
set-ribcage-symnames!
ribcage-labels
ribcage-marks
ribcage-symnames
ribcage?
make-ribcage
gen-labels
label?
gen-label
set-indirect-label!
get-indirect-label
indirect-label?
gen-indirect-label
anon
only-top-marked?
top-marked?
tmp-wrap
top-wrap
empty-wrap
wrap-subst
wrap-marks
make-wrap
id-sym-name&marks
id-subst
id-marks
id-sym-name
id?
nonsymbol-id?
global-extend
defer-or-eval-transformer
make-transformer-binding
lookup
lookup*
displaced-lexical-error
displaced-lexical?
extend-var-env*
extend-env*
extend-env
null-env
binding?
set-binding-value!
set-binding-type!
binding-value
binding-type
make-binding
sanitize-binding
arg-check
no-source
unannotate
self-evaluating?
lexical-var?
build-lexical-var
build-top-module
build-body
build-letrec
build-sequence
build-data
build-primref
built-lambda?
build-lambda
build-revisit-only
build-visit-only
build-cte-install
build-global-definition
build-global-assignment
build-global-reference
build-lexical-assignment
build-lexical-reference
build-conditional
build-application
generate-id
update-import-binding!
get-import-binding
read-only-binding?
put-global-definition-hook
get-global-definition-hook
put-cte-hook
define-top-level-value-hook
local-eval-hook
top-level-eval-hook
set-syntax-object-wrap!
set-syntax-object-expression!
syntax-object-wrap
syntax-object-expression
syntax-object?
make-syntax-object
noexpand
let-values
define-structure
unless
when)
((top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
("m" top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%d2435))
%%tmp2434)
(syntax-error %%tmp2433)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2433
'each-any)))
(map %%modspec*2260 %%m2432)))
%%tmp2430)
(syntax-error %%tmp2429)))
($syntax-dispatch
%%tmp2429
'(any . each-any))))
%%orig2252))))))
(begin
(%%put-cte-hook72
'import
(lambda (%%orig2438) (%%$import-help2242 %%orig2438 #f)))
(%%put-cte-hook72
'import-only
(lambda (%%orig2439) (%%$import-help2242 %%orig2439 #t)))))))
((lambda ()
(letrec ((%%make-sc-expander2440
(lambda (%%ctem2441 %%rtem2442)
(lambda (%%x2443)
((lambda (%%env2444)
(if (if (pair? %%x2443)
(equal? (car %%x2443) %%noexpand62)
#f)
(cadr %%x2443)
(%%chi-top*382
%%x2443
'()
(%%env-wrap323 %%env2444)
%%ctem2441
%%rtem2442
#f
(%%env-top-ribcage322 %%env2444))))
(interaction-environment))))))
(begin
(set! sc-expand
((lambda (%%ctem2445 %%rtem2446)
(%%make-sc-expander2440 %%ctem2445 %%rtem2446))
'(E)
'(E)))
(set! sc-compile-expand
((lambda (%%ctem2447 %%rtem2448)
(%%make-sc-expander2440 %%ctem2447 %%rtem2448))
'(L C)
'(L)))))))
(set! $make-environment
(lambda (%%token2449 %%mutable?2450)
((lambda (%%top-ribcage2451)
(%%make-env320
%%top-ribcage2451
(%%make-wrap250
(%%wrap-marks251 '((top)))
(cons %%top-ribcage2451 (%%wrap-subst252 '((top)))))))
(%%make-top-ribcage308 %%token2449 %%mutable?2450))))
(set! environment? (lambda (%%x2452) (%%env?321 %%x2452)))
(set! interaction-environment
((lambda (%%e2453) (lambda () %%e2453))
($make-environment '*top* #t)))
(set! identifier? (lambda (%%x2454) (%%nonsymbol-id?240 %%x2454)))
(set! datum->syntax-object
(lambda (%%id2455 %%datum2456)
(begin
((lambda (%%x2457)
(if (not (%%nonsymbol-id?240 %%x2457))
(error (string-append
"(in "
(symbol->string 'datum->syntax-object)
") invalid argument")
%%x2457)
(void)))
%%id2455)
(%%make-syntax-object63
%%datum2456
(%%syntax-object-wrap66 %%id2455)))))
(set! syntax->list
(lambda (%%orig-ls2458)
((letrec ((%%f2459 (lambda (%%ls2460)
((lambda (%%tmp2461)
((lambda (%%tmp2462)
(if %%tmp2462
(apply (lambda () '())
%%tmp2462)
((lambda (%%tmp2463)
(if %%tmp2463
(apply (lambda (%%x2464
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%r2465)
(cons %%x2464 (%%f2459 %%r2465)))
%%tmp2463)
((lambda (%%_2466)
(error "(in syntax->list) invalid argument" %%orig-ls2458))
%%tmp2461)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2461
'(any . any)))))
($syntax-dispatch %%tmp2461 '())))
%%ls2460))))
%%f2459)
%%orig-ls2458)))
(set! syntax->vector
(lambda (%%v2467)
((lambda (%%tmp2468)
((lambda (%%tmp2469)
(if %%tmp2469
(apply (lambda (%%x2470)
(list->vector (syntax->list %%x2470)))
%%tmp2469)
((lambda (%%_2472)
(error "(in syntax->vector) invalid argument"
%%v2467))
%%tmp2468)))
($syntax-dispatch %%tmp2468 '#(vector each-any))))
%%v2467)))
(set! syntax-object->datum
(lambda (%%x2473) (%%strip457 %%x2473 '(()))))
(set! generate-temporaries
((lambda (%%n2474)
(lambda (%%ls2475)
(begin
((lambda (%%x2476)
(if (not (list? %%x2476))
(error (string-append
"(in "
(symbol->string 'generate-temporaries)
") invalid argument")
%%x2476)
(void)))
%%ls2475)
(map (lambda (%%x2477)
(begin
(set! %%n2474 (+ %%n2474 1))
(%%wrap378
(string->symbol
(string-append "t" (number->string %%n2474)))
'((tmp)))))
%%ls2475))))
0))
(set! free-identifier=?
(lambda (%%x2478 %%y2479)
(begin
((lambda (%%x2480)
(if (not (%%nonsymbol-id?240 %%x2480))
(error (string-append
"(in "
(symbol->string 'free-identifier=?)
") invalid argument")
%%x2480)
(void)))
%%x2478)
((lambda (%%x2481)
(if (not (%%nonsymbol-id?240 %%x2481))
(error (string-append
"(in "
(symbol->string 'free-identifier=?)
") invalid argument")
%%x2481)
(void)))
%%y2479)
(%%free-id=?370 %%x2478 %%y2479))))
(set! bound-identifier=?
(lambda (%%x2482 %%y2483)
(begin
((lambda (%%x2484)
(if (not (%%nonsymbol-id?240 %%x2484))
(error (string-append
"(in "
(symbol->string 'bound-identifier=?)
") invalid argument")
%%x2484)
(void)))
%%x2482)
((lambda (%%x2485)
(if (not (%%nonsymbol-id?240 %%x2485))
(error (string-append
"(in "
(symbol->string 'bound-identifier=?)
") invalid argument")
%%x2485)
(void)))
%%y2483)
(%%bound-id=?373 %%x2482 %%y2483))))
(set! literal-identifier=?
(lambda (%%x2486 %%y2487)
(begin
((lambda (%%x2488)
(if (not (%%nonsymbol-id?240 %%x2488))
(error (string-append
"(in "
(symbol->string 'literal-identifier=?)
") invalid argument")
%%x2488)
(void)))
%%x2486)
((lambda (%%x2489)
(if (not (%%nonsymbol-id?240 %%x2489))
(error (string-append
"(in "
(symbol->string 'literal-identifier=?)
") invalid argument")
%%x2489)
(void)))
%%y2487)
(%%literal-id=?371 %%x2486 %%y2487))))
(set! syntax-error
(lambda (%%object2491 . %%messages2490)
(begin
(for-each
(lambda (%%x2492)
((lambda (%%x2493)
(if (not (string? %%x2493))
(error (string-append
"(in "
(symbol->string 'syntax-error)
") invalid argument")
%%x2493)
(void)))
%%x2492))
%%messages2490)
((lambda (%%message2494)
(error %%message2494 (%%strip457 %%object2491 '(()))))
(if (null? %%messages2490)
"invalid syntax"
(apply string-append %%messages2490))))))
((lambda ()
(letrec ((%%match-each2495
(lambda (%%e2502 %%p2503 %%w2504)
(if (annotation? %%e2502)
(%%match-each2495
(annotation-expression %%e2502)
%%p2503
%%w2504)
(if (pair? %%e2502)
((lambda (%%first2505)
(if %%first2505
((lambda (%%rest2506)
(if %%rest2506
(cons %%first2505 %%rest2506)
#f))
(%%match-each2495
(cdr %%e2502)
%%p2503
%%w2504))
#f))
(%%match2501
(car %%e2502)
%%p2503
%%w2504
'()))
(if (null? %%e2502)
'()
(if (%%syntax-object?64 %%e2502)
(%%match-each2495
(%%syntax-object-expression65 %%e2502)
%%p2503
(%%join-wraps357
%%w2504
(%%syntax-object-wrap66 %%e2502)))
#f))))))
(%%match-each+2496
(lambda (%%e2507
%%x-pat2508
%%y-pat2509
%%z-pat2510
%%w2511
%%r2512)
((letrec ((%%f2513 (lambda (%%e2514 %%w2515)
(if (pair? %%e2514)
(call-with-values
(lambda ()
(%%f2513 (cdr %%e2514)
%%w2515))
(lambda (%%xr*2516
%%y-pat2517
%%r2518)
(if %%r2518
(if (null? %%y-pat2517)
((lambda (%%xr2519)
(if %%xr2519
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(values (cons %%xr2519 %%xr*2516)
%%y-pat2517
%%r2518)
(values #f #f #f)))
(%%match2501 (car %%e2514) %%x-pat2508 %%w2515 '()))
(values '()
(cdr %%y-pat2517)
(%%match2501
(car %%e2514)
(car %%y-pat2517)
%%w2515
%%r2518)))
(values #f #f #f))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(if (annotation? %%e2514)
(%%f2513 (annotation-expression
%%e2514)
%%w2515)
(if (%%syntax-object?64
%%e2514)
(%%f2513 (%%syntax-object-expression65
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e2514)
(%%join-wraps357
%%w2515
(%%syntax-object-wrap66 %%e2514)))
(values '()
%%y-pat2509
(%%match2501
%%e2514
%%z-pat2510
%%w2515
%%r2512))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f2513)
%%e2507
%%w2511)))
(%%match-each-any2497
(lambda (%%e2520 %%w2521)
(if (annotation? %%e2520)
(%%match-each-any2497
(annotation-expression %%e2520)
%%w2521)
(if (pair? %%e2520)
((lambda (%%l2522)
(if %%l2522
(cons (%%wrap378 (car %%e2520) %%w2521)
%%l2522)
#f))
(%%match-each-any2497 (cdr %%e2520) %%w2521))
(if (null? %%e2520)
'()
(if (%%syntax-object?64 %%e2520)
(%%match-each-any2497
(%%syntax-object-expression65 %%e2520)
(%%join-wraps357
%%w2521
(%%syntax-object-wrap66 %%e2520)))
#f))))))
(%%match-empty2498
(lambda (%%p2523 %%r2524)
(if (null? %%p2523)
%%r2524
(if (eq? %%p2523 'any)
(cons '() %%r2524)
(if (pair? %%p2523)
(%%match-empty2498
(car %%p2523)
(%%match-empty2498 (cdr %%p2523) %%r2524))
(if (eq? %%p2523 'each-any)
(cons '() %%r2524)
((lambda (%%t2525)
(if (memv %%t2525 '(each))
(%%match-empty2498
(vector-ref %%p2523 1)
%%r2524)
(if (memv %%t2525 '(each+))
(%%match-empty2498
(vector-ref %%p2523 1)
(%%match-empty2498
(reverse (vector-ref
%%p2523
2))
(%%match-empty2498
(vector-ref %%p2523 3)
%%r2524)))
(if (memv %%t2525
'(free-id atom))
%%r2524
(if (memv %%t2525
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'(vector))
(%%match-empty2498 (vector-ref %%p2523 1) %%r2524)
(void))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(vector-ref %%p2523 0))))))))
(%%combine2499
(lambda (%%r*2526 %%r2527)
(if (null? (car %%r*2526))
%%r2527
(cons (map car %%r*2526)
(%%combine2499
(map cdr %%r*2526)
%%r2527)))))
(%%match*2500
(lambda (%%e2528 %%p2529 %%w2530 %%r2531)
(if (null? %%p2529)
(if (null? %%e2528) %%r2531 #f)
(if (pair? %%p2529)
(if (pair? %%e2528)
(%%match2501
(car %%e2528)
(car %%p2529)
%%w2530
(%%match2501
(cdr %%e2528)
(cdr %%p2529)
%%w2530
%%r2531))
#f)
(if (eq? %%p2529 'each-any)
((lambda (%%l2532)
(if %%l2532 (cons %%l2532 %%r2531) #f))
(%%match-each-any2497 %%e2528 %%w2530))
((lambda (%%t2533)
(if (memv %%t2533 '(each))
(if (null? %%e2528)
(%%match-empty2498
(vector-ref %%p2529 1)
%%r2531)
((lambda (%%r*2534)
(if %%r*2534
(%%combine2499
%%r*2534
%%r2531)
#f))
(%%match-each2495
%%e2528
(vector-ref %%p2529 1)
%%w2530)))
(if (memv %%t2533 '(free-id))
(if (%%id?241 %%e2528)
(if (%%literal-id=?371
(%%wrap378
%%e2528
%%w2530)
(vector-ref %%p2529 1))
%%r2531
#f)
#f)
(if (memv %%t2533 '(each+))
(call-with-values
(lambda ()
(%%match-each+2496
%%e2528
(vector-ref %%p2529 1)
(vector-ref %%p2529 2)
(vector-ref %%p2529 3)
%%w2530
%%r2531))
(lambda (%%xr*2535
%%y-pat2536
%%r2537)
(if %%r2537
(if (null? %%y-pat2536)
(if (null? %%xr*2535)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(%%match-empty2498 (vector-ref %%p2529 1) %%r2537)
(%%combine2499 %%xr*2535 %%r2537))
#f)
#f)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(if (memv %%t2533 '(atom))
(if (equal? (vector-ref
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%p2529
1)
(%%strip457 %%e2528 %%w2530))
%%r2531
#f)
(if (memv %%t2533 '(vector))
(if (vector? %%e2528)
(%%match2501
(vector->list %%e2528)
(vector-ref %%p2529 1)
%%w2530
%%r2531)
#f)
(void)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(vector-ref %%p2529 0)))))))
(%%match2501
(lambda (%%e2538 %%p2539 %%w2540 %%r2541)
(if (not %%r2541)
#f
(if (eq? %%p2539 'any)
(cons (%%wrap378 %%e2538 %%w2540) %%r2541)
(if (%%syntax-object?64 %%e2538)
(%%match*2500
((lambda (%%e2542)
(if (annotation? %%e2542)
(annotation-expression %%e2542)
%%e2542))
(%%syntax-object-expression65 %%e2538))
%%p2539
(%%join-wraps357
%%w2540
(%%syntax-object-wrap66 %%e2538))
%%r2541)
(%%match*2500
((lambda (%%e2543)
(if (annotation? %%e2543)
(annotation-expression %%e2543)
%%e2543))
%%e2538)
%%p2539
%%w2540
%%r2541)))))))
(set! $syntax-dispatch
(lambda (%%e2544 %%p2545)
(if (eq? %%p2545 'any)
(list %%e2544)
(if (%%syntax-object?64 %%e2544)
(%%match*2500
((lambda (%%e2546)
(if (annotation? %%e2546)
(annotation-expression %%e2546)
%%e2546))
(%%syntax-object-expression65 %%e2544))
%%p2545
(%%syntax-object-wrap66 %%e2544)
'())
(%%match*2500
((lambda (%%e2547)
(if (annotation? %%e2547)
(annotation-expression %%e2547)
%%e2547))
%%e2544)
%%p2545
'(())
'()))))))))))))
($sc-put-cte
'#(syntax-object
with-syntax
((top) #(ribcage #(with-syntax) #((top)) #(with-syntax))))
(lambda (%%x2548)
((lambda (%%tmp2549)
((lambda (%%tmp2550)
(if %%tmp2550
(apply (lambda (%%_2551 %%e12552 %%e22553)
(cons '#(syntax-object
begin
((top)
#(ribcage
#(_ e1 e2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons %%e12552 %%e22553)))
%%tmp2550)
((lambda (%%tmp2555)
(if %%tmp2555
(apply (lambda (%%_2556
%%out2557
%%in2558
%%e12559
%%e22560)
(list '#(syntax-object
syntax-case
((top)
#(ribcage
#(_ out in e1 e2)
#((top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%in2558
'()
(list %%out2557
(cons '#(syntax-object
begin
((top)
#(ribcage
#(_ out in e1 e2)
#((top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
(cons %%e12559 %%e22560)))))
%%tmp2555)
((lambda (%%tmp2562)
(if %%tmp2562
(apply (lambda (%%_2563
%%out2564
%%in2565
%%e12566
%%e22567)
(list '#(syntax-object
syntax-case
((top)
#(ribcage
#(_ out in e1 e2)
#((top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons '#(syntax-object
list
((top)
#(ribcage
#(_ out in e1 e2)
#((top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
%%in2565)
'()
(list %%out2564
(cons '#(syntax-object
begin
((top)
#(ribcage
#(_ out in e1 e2)
#((top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
(cons %%e12566
%%e22567)))))
%%tmp2562)
(syntax-error %%tmp2549)))
($syntax-dispatch
%%tmp2549
'(any #(each (any any)) any . each-any)))))
($syntax-dispatch
%%tmp2549
'(any ((any any)) any . each-any)))))
($syntax-dispatch %%tmp2549 '(any () any . each-any))))
%%x2548))
'*top*)
($sc-put-cte
'#(syntax-object
with-implicit
((top) #(ribcage #(with-implicit) #((top)) #(with-implicit))))
(lambda (%%x2571)
((lambda (%%tmp2572)
((lambda (%%tmp2573)
(if (if %%tmp2573
(apply (lambda (%%dummy2574
%%tid2575
%%id2576
%%e12577
%%e22578)
(andmap identifier? (cons %%tid2575 %%id2576)))
%%tmp2573)
#f)
(apply (lambda (%%dummy2580
%%tid2581
%%id2582
%%e12583
%%e22584)
(list '#(syntax-object
begin
((top)
#(ribcage
#(dummy tid id e1 e2)
#(("m" top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
unless
((top)
#(ribcage
#(dummy tid id e1 e2)
#(("m" top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
identifier?
((top)
#(ribcage
#(dummy tid id e1 e2)
#(("m" top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
syntax
((top)
#(ribcage
#(dummy tid id e1 e2)
#(("m" top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
%%tid2581))
(cons '#(syntax-object
syntax-error
((top)
#(ribcage
#(dummy tid id e1 e2)
#(("m" top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
(cons (list '#(syntax-object
syntax
((top)
#(ribcage
#(dummy
tid
id
e1
e2)
#(("m" top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage
*top*
#t)))
%%tid2581)
'#(syntax-object
("non-identifier with-implicit template")
((top)
#(ribcage
#(dummy tid id e1 e2)
#(("m" top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage
*top*
#t))))))
(cons '#(syntax-object
with-syntax
((top)
#(ribcage
#(dummy tid id e1 e2)
#(("m" top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(cons (map (lambda (%%tmp2585)
(list %%tmp2585
(list '#(syntax-object
datum->syntax-object
((top)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(ribcage
#(dummy tid id e1 e2)
#(("m" top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
syntax
((top)
#(ribcage
#(dummy tid id e1 e2)
#(("m" top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%tid2581)
(list '#(syntax-object
quote
((top)
#(ribcage
#(dummy tid id e1 e2)
#(("m" top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%tmp2585))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%id2582)
(cons %%e12583 %%e22584)))))
%%tmp2573)
(syntax-error %%tmp2572)))
($syntax-dispatch %%tmp2572 '(any (any . each-any) any . each-any))))
%%x2571))
'*top*)
($sc-put-cte
'#(syntax-object datum ((top) #(ribcage #(datum) #((top)) #(datum))))
(lambda (%%x2587)
((lambda (%%tmp2588)
((lambda (%%tmp2589)
(if %%tmp2589
(apply (lambda (%%dummy2590 %%x2591)
(list '#(syntax-object
syntax-object->datum
((top)
#(ribcage
#(dummy x)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
syntax
((top)
#(ribcage
#(dummy x)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%x2591)))
%%tmp2589)
(syntax-error %%tmp2588)))
($syntax-dispatch %%tmp2588 '(any any))))
%%x2587))
'*top*)
($sc-put-cte
'#(syntax-object
syntax-rules
((top) #(ribcage #(syntax-rules) #((top)) #(syntax-rules))))
(lambda (%%x2592)
(letrec ((%%clause2593
(lambda (%%y2594)
((lambda (%%tmp2595)
((lambda (%%tmp2596)
(if %%tmp2596
(apply (lambda (%%keyword2597
%%pattern2598
%%template2599)
(list (cons '#(syntax-object
dummy
((top)
#(ribcage
#(keyword
pattern
template)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(y)
#((top))
#("i"))
#(ribcage
(clause)
((top))
("i"))
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
%%pattern2598)
(list '#(syntax-object
syntax
((top)
#(ribcage
#(keyword
pattern
template)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(y)
#((top))
#("i"))
#(ribcage
(clause)
((top))
("i"))
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
%%template2599)))
%%tmp2596)
((lambda (%%tmp2600)
(if %%tmp2600
(apply (lambda (%%keyword2601
%%pattern2602
%%fender2603
%%template2604)
(list (cons '#(syntax-object
dummy
((top)
#(ribcage
#(keyword
pattern
fender
template)
#((top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(y)
#((top))
#("i"))
#(ribcage
(clause)
((top))
("i"))
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
%%pattern2602)
%%fender2603
(list '#(syntax-object
syntax
((top)
#(ribcage
#(keyword
pattern
fender
template)
#((top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(y)
#((top))
#("i"))
#(ribcage
(clause)
((top))
("i"))
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
%%template2604)))
%%tmp2600)
((lambda (%%_2605) (syntax-error %%x2592))
%%tmp2595)))
($syntax-dispatch
%%tmp2595
'((any . any) any any)))))
($syntax-dispatch %%tmp2595 '((any . any) any))))
%%y2594))))
((lambda (%%tmp2606)
((lambda (%%tmp2607)
(if (if %%tmp2607
(apply (lambda (%%_2608 %%k2609 %%cl2610)
(andmap identifier? %%k2609))
%%tmp2607)
#f)
(apply (lambda (%%_2612 %%k2613 %%cl2614)
((lambda (%%tmp2615)
((lambda (%%tmp2616)
(if %%tmp2616
(apply (lambda (%%cl2617)
(list '#(syntax-object
lambda
((top)
#(ribcage
#(cl)
#((top))
#("i"))
#(ribcage
#(_ k cl)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
(clause)
((top))
("i"))
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
'#(syntax-object
(x)
((top)
#(ribcage
#(cl)
#((top))
#("i"))
#(ribcage
#(_ k cl)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
(clause)
((top))
("i"))
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
(cons '#(syntax-object
syntax-case
((top)
#(ribcage
#(cl)
#((top))
#("i"))
#(ribcage
#(_ k cl)
#((top)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(top)
(top))
#("i" "i" "i"))
#(ribcage (clause) ((top)) ("i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons '#(syntax-object
x
((top)
#(ribcage #(cl) #((top)) #("i"))
#(ribcage
#(_ k cl)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage (clause) ((top)) ("i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons %%k2613 %%cl2617)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2616)
(syntax-error %%tmp2615)))
($syntax-dispatch %%tmp2615 'each-any)))
(map %%clause2593 %%cl2614)))
%%tmp2607)
(syntax-error %%tmp2606)))
($syntax-dispatch %%tmp2606 '(any each-any . each-any))))
%%x2592)))
'*top*)
($sc-put-cte
'#(syntax-object or ((top) #(ribcage #(or) #((top)) #(or))))
(lambda (%%x2621)
((lambda (%%tmp2622)
((lambda (%%tmp2623)
(if %%tmp2623
(apply (lambda (%%_2624)
'#(syntax-object
#f
((top)
#(ribcage #(_) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
%%tmp2623)
((lambda (%%tmp2625)
(if %%tmp2625
(apply (lambda (%%_2626 %%e2627) %%e2627) %%tmp2625)
((lambda (%%tmp2628)
(if %%tmp2628
(apply (lambda (%%_2629
%%e12630
%%e22631
%%e32632)
(list '#(syntax-object
let
((top)
#(ribcage
#(_ e1 e2 e3)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(list (list '#(syntax-object
t
((top)
#(ribcage
#(_ e1 e2 e3)
#((top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
%%e12630))
(list '#(syntax-object
if
((top)
#(ribcage
#(_ e1 e2 e3)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
t
((top)
#(ribcage
#(_ e1 e2 e3)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
t
((top)
#(ribcage
#(_ e1 e2 e3)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
(cons '#(syntax-object
or
((top)
#(ribcage
#(_ e1 e2 e3)
#((top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
(cons %%e22631
%%e32632)))))
%%tmp2628)
(syntax-error %%tmp2622)))
($syntax-dispatch
%%tmp2622
'(any any any . each-any)))))
($syntax-dispatch %%tmp2622 '(any any)))))
($syntax-dispatch %%tmp2622 '(any))))
%%x2621))
'*top*)
($sc-put-cte
'#(syntax-object and ((top) #(ribcage #(and) #((top)) #(and))))
(lambda (%%x2634)
((lambda (%%tmp2635)
((lambda (%%tmp2636)
(if %%tmp2636
(apply (lambda (%%_2637 %%e12638 %%e22639 %%e32640)
(cons '#(syntax-object
if
((top)
#(ribcage
#(_ e1 e2 e3)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons %%e12638
(cons (cons '#(syntax-object
and
((top)
#(ribcage
#(_ e1 e2 e3)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
(cons %%e22639 %%e32640))
'#(syntax-object
(#f)
((top)
#(ribcage
#(_ e1 e2 e3)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))))))
%%tmp2636)
((lambda (%%tmp2642)
(if %%tmp2642
(apply (lambda (%%_2643 %%e2644) %%e2644) %%tmp2642)
((lambda (%%tmp2645)
(if %%tmp2645
(apply (lambda (%%_2646)
'#(syntax-object
#t
((top)
#(ribcage #(_) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
%%tmp2645)
(syntax-error %%tmp2635)))
($syntax-dispatch %%tmp2635 '(any)))))
($syntax-dispatch %%tmp2635 '(any any)))))
($syntax-dispatch %%tmp2635 '(any any any . each-any))))
%%x2634))
'*top*)
($sc-put-cte
'#(syntax-object let ((top) #(ribcage #(let) #((top)) #(let))))
(lambda (%%x2647)
((lambda (%%tmp2648)
((lambda (%%tmp2649)
(if (if %%tmp2649
(apply (lambda (%%_2650 %%x2651 %%v2652 %%e12653 %%e22654)
(andmap identifier? %%x2651))
%%tmp2649)
#f)
(apply (lambda (%%_2656 %%x2657 %%v2658 %%e12659 %%e22660)
(cons (cons '#(syntax-object
lambda
((top)
#(ribcage
#(_ x v e1 e2)
#((top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons %%x2657 (cons %%e12659 %%e22660)))
%%v2658))
%%tmp2649)
((lambda (%%tmp2664)
(if (if %%tmp2664
(apply (lambda (%%_2665
%%f2666
%%x2667
%%v2668
%%e12669
%%e22670)
(andmap identifier? (cons %%f2666 %%x2667)))
%%tmp2664)
#f)
(apply (lambda (%%_2672
%%f2673
%%x2674
%%v2675
%%e12676
%%e22677)
(cons (list '#(syntax-object
letrec
((top)
#(ribcage
#(_ f x v e1 e2)
#((top)
(top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(list (list %%f2673
(cons '#(syntax-object
lambda
((top)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(ribcage
#(_ f x v e1 e2)
#((top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons %%x2674 (cons %%e12676 %%e22677)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f2673)
%%v2675))
%%tmp2664)
(syntax-error %%tmp2648)))
($syntax-dispatch
%%tmp2648
'(any any #(each (any any)) any . each-any)))))
($syntax-dispatch %%tmp2648 '(any #(each (any any)) any . each-any))))
%%x2647))
'*top*)
($sc-put-cte
'#(syntax-object let* ((top) #(ribcage #(let*) #((top)) #(let*))))
(lambda (%%x2681)
((lambda (%%tmp2682)
((lambda (%%tmp2683)
(if (if %%tmp2683
(apply (lambda (%%let*2684
%%x2685
%%v2686
%%e12687
%%e22688)
(andmap identifier? %%x2685))
%%tmp2683)
#f)
(apply (lambda (%%let*2690 %%x2691 %%v2692 %%e12693 %%e22694)
((letrec ((%%f2695 (lambda (%%bindings2696)
(if (null? %%bindings2696)
(cons '#(syntax-object
let
((top)
#(ribcage () () ())
#(ribcage
#(bindings)
#((top))
#("i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(let* x v e1 e2)
#((top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
(cons '()
(cons %%e12693
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e22694)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2698)
((lambda (%%tmp2699)
(if %%tmp2699
(apply (lambda (%%body2700
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%binding2701)
(list '#(syntax-object
let
((top)
#(ribcage
#(body binding)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(bindings) #((top)) #("i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(let* x v e1 e2)
#((top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(list %%binding2701)
%%body2700))
%%tmp2699)
(syntax-error %%tmp2698)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2698
'(any any))))
(list (%%f2695 (cdr %%bindings2696))
(car %%bindings2696)))))))
%%f2695)
(map list %%x2691 %%v2692)))
%%tmp2683)
(syntax-error %%tmp2682)))
($syntax-dispatch %%tmp2682 '(any #(each (any any)) any . each-any))))
%%x2681))
'*top*)
($sc-put-cte
'#(syntax-object cond ((top) #(ribcage #(cond) #((top)) #(cond))))
(lambda (%%x2704)
((lambda (%%tmp2705)
((lambda (%%tmp2706)
(if %%tmp2706
(apply (lambda (%%_2707 %%m12708 %%m22709)
((letrec ((%%f2710 (lambda (%%clause2711 %%clauses2712)
(if (null? %%clauses2712)
((lambda (%%tmp2713)
((lambda (%%tmp2714)
(if %%tmp2714
(apply (lambda (%%e12715
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e22716)
(cons '#(syntax-object
begin
((top)
#(ribcage
#(e1 e2)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons %%e12715 %%e22716)))
%%tmp2714)
((lambda (%%tmp2718)
(if %%tmp2718
(apply (lambda (%%e02719)
(cons '#(syntax-object
let
((top)
#(ribcage #(e0) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons (list (list '#(syntax-object
t
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(e0)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage #(clause clauses) #((top) (top)) #("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%e02719))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'#(syntax-object
((if t t))
((top)
#(ribcage
#(e0)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t))))))
%%tmp2718)
((lambda (%%tmp2720)
(if %%tmp2720
(apply (lambda (%%e02721 %%e12722)
(list '#(syntax-object
let
((top)
#(ribcage
#(e0 e1)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
(list (list '#(syntax-object
t
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(e0 e1)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(clause clauses) #((top) (top)) #("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%e02721))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(list '#(syntax-object
if
((top)
#(ribcage
#(e0 e1)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
'#(syntax-object
t
((top)
#(ribcage
#(e0 e1)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
(cons %%e12722
'#(syntax-object
(t)
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(e0 e1)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(clause clauses) #((top) (top)) #("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2720)
((lambda (%%tmp2723)
(if %%tmp2723
(apply (lambda (%%e02724
%%e12725
%%e22726)
(list '#(syntax-object
if
((top)
#(ribcage
#(e0 e1 e2)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
%%e02724
(cons '#(syntax-object
begin
((top)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(ribcage
#(e0 e1 e2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(clause clauses) #((top) (top)) #("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons %%e12725 %%e22726))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2723)
((lambda (%%_2728)
(syntax-error %%x2704))
%%tmp2713)))
($syntax-dispatch
%%tmp2713
'(any any . each-any)))))
($syntax-dispatch
%%tmp2713
'(any #(free-id
#(syntax-object
=>
((top)
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
any)))))
($syntax-dispatch %%tmp2713 '(any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2713
'(#(free-id
#(syntax-object
else
((top)
#(ribcage
()
()
())
#(ribcage
#(clause
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
clauses)
#((top) (top))
#("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage #(_ m1 m2) #((top) (top) (top)) #("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
any
.
each-any))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%clause2711)
((lambda (%%tmp2729)
((lambda (%%rest2730)
((lambda (%%tmp2731)
((lambda (%%tmp2732)
(if %%tmp2732
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(apply (lambda (%%e02733)
(list '#(syntax-object
let
((top)
#(ribcage #(e0) #((top)) #("i"))
#(ribcage #(rest) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(list (list '#(syntax-object
t
((top)
#(ribcage
#(e0)
#((top))
#("i"))
#(ribcage
#(rest)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
%%e02733))
(list '#(syntax-object
if
((top)
#(ribcage
#(e0)
#((top))
#("i"))
#(ribcage
#(rest)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
t
((top)
#(ribcage
#(e0)
#((top))
#("i"))
#(ribcage
#(rest)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
t
((top)
#(ribcage
#(e0)
#((top))
#("i"))
#(ribcage
#(rest)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
%%rest2730)))
%%tmp2732)
((lambda (%%tmp2734)
(if %%tmp2734
(apply (lambda (%%e02735 %%e12736)
(list '#(syntax-object
let
((top)
#(ribcage
#(e0 e1)
#((top) (top))
#("i" "i"))
#(ribcage
#(rest)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
(list (list '#(syntax-object
t
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(e0 e1)
#((top) (top))
#("i" "i"))
#(ribcage #(rest) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(clause clauses) #((top) (top)) #("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%e02735))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(list '#(syntax-object
if
((top)
#(ribcage
#(e0 e1)
#((top) (top))
#("i" "i"))
#(ribcage
#(rest)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
'#(syntax-object
t
((top)
#(ribcage
#(e0 e1)
#((top) (top))
#("i" "i"))
#(ribcage
#(rest)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
(cons %%e12736
'#(syntax-object
(t)
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(e0 e1)
#((top) (top))
#("i" "i"))
#(ribcage #(rest) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(clause clauses) #((top) (top)) #("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%rest2730)))
%%tmp2734)
((lambda (%%tmp2737)
(if %%tmp2737
(apply (lambda (%%e02738
%%e12739
%%e22740)
(list '#(syntax-object
if
((top)
#(ribcage
#(e0 e1 e2)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage
#(rest)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ m1 m2)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
%%e02738
(cons '#(syntax-object
begin
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(e0 e1 e2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage #(rest) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(clause clauses) #((top) (top)) #("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons %%e12739 %%e22740))
%%rest2730))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2737)
((lambda (%%_2742)
(syntax-error %%x2704))
%%tmp2731)))
($syntax-dispatch
%%tmp2731
'(any any . each-any)))))
($syntax-dispatch
%%tmp2731
'(any #(free-id
#(syntax-object
=>
((top)
#(ribcage #(rest) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ m1 m2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
any)))))
($syntax-dispatch %%tmp2731 '(any))))
%%clause2711))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2729))
(%%f2710 (car %%clauses2712)
(cdr %%clauses2712)))))))
%%f2710)
%%m12708
%%m22709))
%%tmp2706)
(syntax-error %%tmp2705)))
($syntax-dispatch %%tmp2705 '(any any . each-any))))
%%x2704))
'*top*)
($sc-put-cte
'#(syntax-object do ((top) #(ribcage #(do) #((top)) #(do))))
(lambda (%%orig-x2744)
((lambda (%%tmp2745)
((lambda (%%tmp2746)
(if %%tmp2746
(apply (lambda (%%_2747
%%var2748
%%init2749
%%step2750
%%e02751
%%e12752
%%c2753)
((lambda (%%tmp2754)
((lambda (%%tmp2755)
(if %%tmp2755
(apply (lambda (%%step2756)
((lambda (%%tmp2757)
((lambda (%%tmp2758)
(if %%tmp2758
(apply (lambda ()
(list '#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
let
((top)
#(ribcage #(step) #((top)) #("i"))
#(ribcage
#(_ var init step e0 e1 c)
#((top) (top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(orig-x) #((top)) #("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
do
((top)
#(ribcage #(step) #((top)) #("i"))
#(ribcage
#(_ var init step e0 e1 c)
#((top) (top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(orig-x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(map list %%var2748 %%init2749)
(list '#(syntax-object
if
((top)
#(ribcage #(step) #((top)) #("i"))
#(ribcage
#(_ var init step e0 e1 c)
#((top)
(top)
(top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(orig-x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
not
((top)
#(ribcage #(step) #((top)) #("i"))
#(ribcage
#(_ var init step e0 e1 c)
#((top)
(top)
(top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(orig-x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
%%e02751)
(cons '#(syntax-object
begin
((top)
#(ribcage #(step) #((top)) #("i"))
#(ribcage
#(_ var init step e0 e1 c)
#((top)
(top)
(top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(orig-x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
(append %%c2753
(list (cons '#(syntax-object
do
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(step)
#((top))
#("i"))
#(ribcage
#(_ var init step e0 e1 c)
#((top) (top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(orig-x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%step2756)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2758)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2763)
(if %%tmp2763
(apply (lambda (%%e12764
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e22765)
(list '#(syntax-object
let
((top)
#(ribcage
#(e1 e2)
#((top) (top))
#("i" "i"))
#(ribcage #(step) #((top)) #("i"))
#(ribcage
#(_ var init step e0 e1 c)
#((top)
(top)
(top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(orig-x) #((top)) #("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
do
((top)
#(ribcage
#(e1 e2)
#((top) (top))
#("i" "i"))
#(ribcage #(step) #((top)) #("i"))
#(ribcage
#(_ var init step e0 e1 c)
#((top)
(top)
(top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(orig-x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(map list %%var2748 %%init2749)
(list '#(syntax-object
if
((top)
#(ribcage
#(e1 e2)
#((top) (top))
#("i" "i"))
#(ribcage #(step) #((top)) #("i"))
#(ribcage
#(_ var init step e0 e1 c)
#((top)
(top)
(top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(orig-x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
%%e02751
(cons '#(syntax-object
begin
((top)
#(ribcage
#(e1 e2)
#((top) (top))
#("i" "i"))
#(ribcage
#(step)
#((top))
#("i"))
#(ribcage
#(_ var init step e0 e1 c)
#((top)
(top)
(top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(orig-x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
(cons %%e12764 %%e22765))
(cons '#(syntax-object
begin
((top)
#(ribcage
#(e1 e2)
#((top) (top))
#("i" "i"))
#(ribcage
#(step)
#((top))
#("i"))
#(ribcage
#(_ var init step e0 e1 c)
#((top)
(top)
(top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(orig-x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
(append %%c2753
(list (cons '#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
do
((top)
#(ribcage #(e1 e2) #((top) (top)) #("i" "i"))
#(ribcage #(step) #((top)) #("i"))
#(ribcage
#(_ var init step e0 e1 c)
#((top) (top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(orig-x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%step2756)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2763)
(syntax-error %%tmp2757)))
($syntax-dispatch %%tmp2757 '(any . each-any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2757
'())))
%%e12752))
%%tmp2755)
(syntax-error %%tmp2754)))
($syntax-dispatch %%tmp2754 'each-any)))
(map (lambda (%%v2772 %%s2773)
((lambda (%%tmp2774)
((lambda (%%tmp2775)
(if %%tmp2775
(apply (lambda () %%v2772) %%tmp2775)
((lambda (%%tmp2776)
(if %%tmp2776
(apply (lambda (%%e2777)
%%e2777)
%%tmp2776)
((lambda (%%_2778)
(syntax-error
%%orig-x2744))
%%tmp2774)))
($syntax-dispatch
%%tmp2774
'(any)))))
($syntax-dispatch %%tmp2774 '())))
%%s2773))
%%var2748
%%step2750)))
%%tmp2746)
(syntax-error %%tmp2745)))
($syntax-dispatch
%%tmp2745
'(any #(each (any any . any)) (any . each-any) . each-any))))
%%orig-x2744))
'*top*)
($sc-put-cte
'#(syntax-object
quasiquote
((top) #(ribcage #(quasiquote) #((top)) #(quasiquote))))
((lambda ()
(letrec ((%%quasi2781
(lambda (%%p2788 %%lev2789)
((lambda (%%tmp2790)
((lambda (%%tmp2791)
(if %%tmp2791
(apply (lambda (%%p2792)
(if (= %%lev2789 0)
(list '#(syntax-object
"value"
((top)
#(ribcage
#(p)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%p2792)
(%%quasicons2783
'#(syntax-object
("quote" unquote)
((top)
#(ribcage #(p) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
(%%quasi2781
(list %%p2792)
(- %%lev2789 1)))))
%%tmp2791)
((lambda (%%tmp2793)
(if %%tmp2793
(apply (lambda (%%p2794)
(%%quasicons2783
'#(syntax-object
("quote" quasiquote)
((top)
#(ribcage
#(p)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
(%%quasi2781
(list %%p2794)
(+ %%lev2789 1))))
%%tmp2793)
((lambda (%%tmp2795)
(if %%tmp2795
(apply (lambda (%%p2796 %%q2797)
((lambda (%%tmp2798)
((lambda (%%tmp2799)
(if %%tmp2799
(apply (lambda (%%p2800)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (= %%lev2789 0)
(%%quasilist*2785
(map (lambda (%%tmp2801)
(list '#(syntax-object
"value"
((top)
#(ribcage
#(p)
#((top))
#("i"))
#(ribcage
#(p q)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%tmp2801))
%%p2800)
(%%quasi2781 %%q2797 %%lev2789))
(%%quasicons2783
(%%quasicons2783
'#(syntax-object
("quote" unquote)
((top)
#(ribcage #(p) #((top)) #("i"))
#(ribcage
#(p q)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
(%%quasi2781 %%p2800 (- %%lev2789 1)))
(%%quasi2781 %%q2797 %%lev2789))))
%%tmp2799)
((lambda (%%tmp2803)
(if %%tmp2803
(apply (lambda (%%p2804)
(if (= %%lev2789 0)
(%%quasiappend2784
(map (lambda (%%tmp2805)
(list '#(syntax-object
"value"
((top)
#(ribcage
#(p)
#((top))
#("i"))
#(ribcage
#(p q)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%tmp2805))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%p2804)
(%%quasi2781 %%q2797 %%lev2789))
(%%quasicons2783
(%%quasicons2783
'#(syntax-object
("quote" unquote-splicing)
((top)
#(ribcage #(p) #((top)) #("i"))
#(ribcage
#(p q)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
(%%quasi2781
%%p2804
(- %%lev2789 1)))
(%%quasi2781 %%q2797 %%lev2789))))
%%tmp2803)
((lambda (%%_2807)
(%%quasicons2783
(%%quasi2781 %%p2796 %%lev2789)
(%%quasi2781 %%q2797 %%lev2789)))
%%tmp2798)))
($syntax-dispatch
%%tmp2798
'(#(free-id
#(syntax-object
unquote-splicing
((top)
#(ribcage #(p q) #((top) (top)) #("i" "i"))
#(ribcage () () ())
#(ribcage #(p lev) #((top) (top)) #("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t))))
.
each-any)))))
($syntax-dispatch
%%tmp2798
'(#(free-id
#(syntax-object
unquote
((top)
#(ribcage #(p q) #((top) (top)) #("i" "i"))
#(ribcage () () ())
#(ribcage #(p lev) #((top) (top)) #("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t))))
.
each-any))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%p2796))
%%tmp2795)
((lambda (%%tmp2808)
(if %%tmp2808
(apply (lambda (%%x2809)
(%%quasivector2786
(%%vquasi2782
%%x2809
%%lev2789)))
%%tmp2808)
((lambda (%%p2811)
(list '#(syntax-object
"quote"
((top)
#(ribcage
#(p)
#((top))
#("i"))
#(ribcage
()
()
())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%p2811))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2790)))
($syntax-dispatch
%%tmp2790
'#(vector each-any)))))
($syntax-dispatch
%%tmp2790
'(any . any)))))
($syntax-dispatch
%%tmp2790
'(#(free-id
#(syntax-object
quasiquote
((top)
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t))))
any)))))
($syntax-dispatch
%%tmp2790
'(#(free-id
#(syntax-object
unquote
((top)
#(ribcage () () ())
#(ribcage #(p lev) #((top) (top)) #("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t))))
any))))
%%p2788)))
(%%vquasi2782
(lambda (%%p2812 %%lev2813)
((lambda (%%tmp2814)
((lambda (%%tmp2815)
(if %%tmp2815
(apply (lambda (%%p2816 %%q2817)
((lambda (%%tmp2818)
((lambda (%%tmp2819)
(if %%tmp2819
(apply (lambda (%%p2820)
(if (= %%lev2813 0)
(%%quasilist*2785
(map (lambda (%%tmp2821)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(list '#(syntax-object
"value"
((top)
#(ribcage #(p) #((top)) #("i"))
#(ribcage
#(p q)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%tmp2821))
%%p2820)
(%%vquasi2782 %%q2817 %%lev2813))
(%%quasicons2783
(%%quasicons2783
'#(syntax-object
("quote" unquote)
((top)
#(ribcage #(p) #((top)) #("i"))
#(ribcage #(p q) #((top) (top)) #("i" "i"))
#(ribcage () () ())
#(ribcage #(p lev) #((top) (top)) #("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
(%%quasi2781 %%p2820 (- %%lev2813 1)))
(%%vquasi2782 %%q2817 %%lev2813))))
%%tmp2819)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2823)
(if %%tmp2823
(apply (lambda (%%p2824)
(if (= %%lev2813
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
0)
(%%quasiappend2784
(map (lambda (%%tmp2825)
(list '#(syntax-object
"value"
((top)
#(ribcage #(p) #((top)) #("i"))
#(ribcage
#(p q)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%tmp2825))
%%p2824)
(%%vquasi2782 %%q2817 %%lev2813))
(%%quasicons2783
(%%quasicons2783
'#(syntax-object
("quote" unquote-splicing)
((top)
#(ribcage #(p) #((top)) #("i"))
#(ribcage #(p q) #((top) (top)) #("i" "i"))
#(ribcage () () ())
#(ribcage #(p lev) #((top) (top)) #("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
(%%quasi2781 %%p2824 (- %%lev2813 1)))
(%%vquasi2782 %%q2817 %%lev2813))))
%%tmp2823)
((lambda (%%_2827)
(%%quasicons2783
(%%quasi2781 %%p2816 %%lev2813)
(%%vquasi2782 %%q2817 %%lev2813)))
%%tmp2818)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2818
'(#(free-id
#(syntax-object
unquote-splicing
((top)
#(ribcage
#(p q)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t))))
.
each-any)))))
($syntax-dispatch
%%tmp2818
'(#(free-id
#(syntax-object
unquote
((top)
#(ribcage
#(p q)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
.
each-any))))
%%p2816))
%%tmp2815)
((lambda (%%tmp2828)
(if %%tmp2828
(apply (lambda ()
'#(syntax-object
("quote" ())
((top)
#(ribcage () () ())
#(ribcage
#(p lev)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t))))
%%tmp2828)
(syntax-error %%tmp2814)))
($syntax-dispatch %%tmp2814 '()))))
($syntax-dispatch %%tmp2814 '(any . any))))
%%p2812)))
(%%quasicons2783
(lambda (%%x2829 %%y2830)
((lambda (%%tmp2831)
((lambda (%%tmp2832)
(if %%tmp2832
(apply (lambda (%%x2833 %%y2834)
((lambda (%%tmp2835)
((lambda (%%tmp2836)
(if %%tmp2836
(apply (lambda (%%dy2837)
((lambda (%%tmp2838)
((lambda (%%tmp2839)
(if %%tmp2839
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(apply (lambda (%%dx2840)
(list '#(syntax-object
"quote"
((top)
#(ribcage #(dx) #((top)) #("i"))
#(ribcage #(dy) #((top)) #("i"))
#(ribcage
#(x y)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x y)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
(cons %%dx2840 %%dy2837)))
%%tmp2839)
((lambda (%%_2841)
(if (null? %%dy2837)
(list '#(syntax-object
"list"
((top)
#(ribcage #(_) #((top)) #("i"))
#(ribcage #(dy) #((top)) #("i"))
#(ribcage
#(x y)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x y)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%x2833)
(list '#(syntax-object
"list*"
((top)
#(ribcage #(_) #((top)) #("i"))
#(ribcage #(dy) #((top)) #("i"))
#(ribcage
#(x y)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x y)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%x2833
%%y2834)))
%%tmp2838)))
($syntax-dispatch %%tmp2838 '(#(atom "quote") any))))
%%x2833))
%%tmp2836)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2842)
(if %%tmp2842
(apply (lambda (%%stuff2843)
(cons '#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
"list"
((top)
#(ribcage #(stuff) #((top)) #("i"))
#(ribcage #(x y) #((top) (top)) #("i" "i"))
#(ribcage () () ())
#(ribcage #(x y) #((top) (top)) #("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
(cons %%x2833 %%stuff2843)))
%%tmp2842)
((lambda (%%tmp2844)
(if %%tmp2844
(apply (lambda (%%stuff2845)
(cons '#(syntax-object
"list*"
((top)
#(ribcage #(stuff) #((top)) #("i"))
#(ribcage
#(x y)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x y)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
(cons %%x2833 %%stuff2845)))
%%tmp2844)
((lambda (%%_2846)
(list '#(syntax-object
"list*"
((top)
#(ribcage #(_) #((top)) #("i"))
#(ribcage #(x y) #((top) (top)) #("i" "i"))
#(ribcage () () ())
#(ribcage #(x y) #((top) (top)) #("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%x2833
%%y2834))
%%tmp2835)))
($syntax-dispatch %%tmp2835 '(#(atom "list*") . any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2835
'(#(atom "list") . any)))))
($syntax-dispatch
%%tmp2835
'(#(atom "quote") any))))
%%y2834))
%%tmp2832)
(syntax-error %%tmp2831)))
($syntax-dispatch %%tmp2831 '(any any))))
(list %%x2829 %%y2830))))
(%%quasiappend2784
(lambda (%%x2847 %%y2848)
((lambda (%%tmp2849)
((lambda (%%tmp2850)
(if %%tmp2850
(apply (lambda ()
(if (null? %%x2847)
'#(syntax-object
("quote" ())
((top)
#(ribcage () () ())
#(ribcage
#(x y)
#((top) (top))
#("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
(if (null? (cdr %%x2847))
(car %%x2847)
((lambda (%%tmp2851)
((lambda (%%tmp2852)
(if %%tmp2852
(apply (lambda (%%p2853)
(cons '#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
"append"
((top)
#(ribcage #(p) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(x y) #((top) (top)) #("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%p2853))
%%tmp2852)
(syntax-error %%tmp2851)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2851
'each-any)))
%%x2847))))
%%tmp2850)
((lambda (%%_2855)
(if (null? %%x2847)
%%y2848
((lambda (%%tmp2856)
((lambda (%%tmp2857)
(if %%tmp2857
(apply (lambda (%%p2858 %%y2859)
(cons '#(syntax-object
"append"
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(p y)
#((top) (top))
#("i" "i"))
#(ribcage #(_) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(x y) #((top) (top)) #("i" "i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
(append %%p2858 (list %%y2859))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2857)
(syntax-error %%tmp2856)))
($syntax-dispatch
%%tmp2856
'(each-any any))))
(list %%x2847 %%y2848))))
%%tmp2849)))
($syntax-dispatch %%tmp2849 '(#(atom "quote") ()))))
%%y2848)))
(%%quasilist*2785
(lambda (%%x2861 %%y2862)
((letrec ((%%f2863 (lambda (%%x2864)
(if (null? %%x2864)
%%y2862
(%%quasicons2783
(car %%x2864)
(%%f2863 (cdr %%x2864)))))))
%%f2863)
%%x2861)))
(%%quasivector2786
(lambda (%%x2865)
((lambda (%%tmp2866)
((lambda (%%tmp2867)
(if %%tmp2867
(apply (lambda (%%x2868)
(list '#(syntax-object
"quote"
((top)
#(ribcage #(x) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
(list->vector %%x2868)))
%%tmp2867)
((lambda (%%_2870)
((letrec ((%%f2871 (lambda (%%y2872 %%k2873)
((lambda (%%tmp2874)
((lambda (%%tmp2875)
(if %%tmp2875
(apply (lambda (%%y2876)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(%%k2873 (map (lambda (%%tmp2877)
(list '#(syntax-object
"quote"
((top)
#(ribcage
#(y)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(y k)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(ribcage
(emit quasivector
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2877))
%%y2876)))
%%tmp2875)
((lambda (%%tmp2878)
(if %%tmp2878
(apply (lambda (%%y2879) (%%k2873 %%y2879))
%%tmp2878)
((lambda (%%tmp2881)
(if %%tmp2881
(apply (lambda (%%y2882 %%z2883)
(%%f2871 %%z2883
(lambda (%%ls2884)
(%%k2873 (append %%y2882
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%ls2884)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2881)
((lambda (%%else2886)
((lambda (%%tmp2887)
((lambda (%%t12888)
(list '#(syntax-object
"list->vector"
((top)
#(ribcage
#(t1)
#(("m" tmp))
#("i"))
#(ribcage
#(else)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(y k)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage
*top*
#t)))
%%t12888))
%%tmp2887))
%%x2865))
%%tmp2874)))
($syntax-dispatch
%%tmp2874
'(#(atom "list*") . #(each+ any (any) ()))))))
($syntax-dispatch
%%tmp2874
'(#(atom "list") . each-any)))))
($syntax-dispatch %%tmp2874 '(#(atom "quote") each-any))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%y2872))))
%%f2871)
%%x2865
(lambda (%%ls2889)
((lambda (%%tmp2890)
((lambda (%%tmp2891)
(if %%tmp2891
(apply (lambda (%%t22892)
(cons '#(syntax-object
"vector"
((top)
#(ribcage
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(t2)
#(("m" tmp))
#("i"))
#(ribcage () () ())
#(ribcage #(ls) #((top)) #("i"))
#(ribcage #(_) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%t22892))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2891)
(syntax-error %%tmp2890)))
($syntax-dispatch %%tmp2890 'each-any)))
%%ls2889))))
%%tmp2866)))
($syntax-dispatch
%%tmp2866
'(#(atom "quote") each-any))))
%%x2865)))
(%%emit2787
(lambda (%%x2894)
((lambda (%%tmp2895)
((lambda (%%tmp2896)
(if %%tmp2896
(apply (lambda (%%x2897)
(list '#(syntax-object
quote
((top)
#(ribcage #(x) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%x2897))
%%tmp2896)
((lambda (%%tmp2898)
(if %%tmp2898
(apply (lambda (%%x2899)
((lambda (%%tmp2900)
((lambda (%%tmp2901)
(if %%tmp2901
(apply (lambda (%%t32902)
(cons '#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
list
((top)
#(ribcage #(t3) #(("m" tmp)) #("i"))
#(ribcage #(x) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%t32902))
%%tmp2901)
(syntax-error %%tmp2900)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2900
'each-any)))
(map %%emit2787 %%x2899)))
%%tmp2898)
((lambda (%%tmp2905)
(if %%tmp2905
(apply (lambda (%%x2906 %%y2907)
((letrec ((%%f2908 (lambda (%%x*2909)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (null? %%x*2909)
(%%emit2787 %%y2907)
((lambda (%%tmp2910)
((lambda (%%tmp2911)
(if %%tmp2911
(apply (lambda (%%t52912
%%t42913)
(list '#(syntax-object
cons
((top)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(ribcage #(t5 t4) #(("m" tmp) ("m" tmp)) #("i" "i"))
#(ribcage () () ())
#(ribcage #(x*) #((top)) #("i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage #(x y) #((top) (top)) #("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top) (top) (top) (top) (top) (top) (top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%t52912
%%t42913))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2911)
(syntax-error %%tmp2910)))
($syntax-dispatch
%%tmp2910
'(any any))))
(list (%%emit2787 (car %%x*2909))
(%%f2908 (cdr %%x*2909))))))))
%%f2908)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%x2906))
%%tmp2905)
((lambda (%%tmp2915)
(if %%tmp2915
(apply (lambda (%%x2916)
((lambda (%%tmp2917)
((lambda (%%tmp2918)
(if %%tmp2918
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(apply (lambda (%%t62919)
(cons '#(syntax-object
append
((top)
#(ribcage
#(t6)
#(("m" tmp))
#("i"))
#(ribcage #(x) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i" "i" "i" "i" "i" "i" "i"))
#(top-ribcage *top* #t)))
%%t62919))
%%tmp2918)
(syntax-error %%tmp2917)))
($syntax-dispatch %%tmp2917 'each-any)))
(map %%emit2787 %%x2916)))
%%tmp2915)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2922)
(if %%tmp2922
(apply (lambda (%%x2923)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
((lambda (%%tmp2924)
((lambda (%%tmp2925)
(if %%tmp2925
(apply (lambda (%%t72926)
(cons '#(syntax-object
vector
((top)
#(ribcage
#(t7)
#(("m" tmp))
#("i"))
#(ribcage
#(x)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%t72926))
%%tmp2925)
(syntax-error %%tmp2924)))
($syntax-dispatch %%tmp2924 'each-any)))
(map %%emit2787 %%x2923)))
%%tmp2922)
((lambda (%%tmp2929)
(if %%tmp2929
(apply (lambda (%%x2930)
((lambda (%%tmp2931)
((lambda (%%t82932)
(list '#(syntax-object
list->vector
((top)
#(ribcage
#(t8)
#(("m" tmp))
#("i"))
#(ribcage #(x) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(ribcage
(emit quasivector
quasilist*
quasiappend
quasicons
vquasi
quasi)
((top)
(top)
(top)
(top)
(top)
(top)
(top))
("i"
"i"
"i"
"i"
"i"
"i"
"i"))
#(top-ribcage *top* #t)))
%%t82932))
%%tmp2931))
(%%emit2787 %%x2930)))
%%tmp2929)
((lambda (%%tmp2933)
(if %%tmp2933
(apply (lambda (%%x2934) %%x2934) %%tmp2933)
(syntax-error %%tmp2895)))
($syntax-dispatch %%tmp2895 '(#(atom "value") any)))))
($syntax-dispatch %%tmp2895 '(#(atom "list->vector") any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2895
'(#(atom "vector")
.
each-any)))))
($syntax-dispatch
%%tmp2895
'(#(atom "append") . each-any)))))
($syntax-dispatch
%%tmp2895
'(#(atom "list*")
.
#(each+ any (any) ()))))))
($syntax-dispatch
%%tmp2895
'(#(atom "list") . each-any)))))
($syntax-dispatch %%tmp2895 '(#(atom "quote") any))))
%%x2894))))
(lambda (%%x2935)
((lambda (%%tmp2936)
((lambda (%%tmp2937)
(if %%tmp2937
(apply (lambda (%%_2938 %%e2939)
(%%emit2787 (%%quasi2781 %%e2939 0)))
%%tmp2937)
(syntax-error %%tmp2936)))
($syntax-dispatch %%tmp2936 '(any any))))
%%x2935)))))
'*top*)
($sc-put-cte
'#(syntax-object
quasisyntax
((top) #(ribcage #(quasisyntax) #((top)) #(quasisyntax))))
(lambda (%%x2940)
(letrec ((%%qs2941
(lambda (%%q2943 %%n2944 %%b*2945 %%k2946)
((lambda (%%tmp2947)
((lambda (%%tmp2948)
(if %%tmp2948
(apply (lambda (%%d2949)
(%%qs2941
%%d2949
(+ %%n2944 1)
%%b*2945
(lambda (%%b*2950 %%dnew2951)
(%%k2946 %%b*2950
(if (eq? %%dnew2951 %%d2949)
%%q2943
((lambda (%%tmp2952)
((lambda (%%d2953)
(cons '#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
quasisyntax
((top)
#(ribcage #(d) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(b* dnew) #((top) (top)) #("i" "i"))
#(ribcage #(d) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(q n b* k)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage (vqs qs) ((top) (top)) ("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%d2953))
%%tmp2952))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%dnew2951))))))
%%tmp2948)
((lambda (%%tmp2954)
(if (if %%tmp2954
(apply (lambda (%%d2955)
(not (= %%n2944 0)))
%%tmp2954)
#f)
(apply (lambda (%%d2956)
(%%qs2941
%%d2956
(- %%n2944 1)
%%b*2945
(lambda (%%b*2957 %%dnew2958)
(%%k2946 %%b*2957
(if (eq? %%dnew2958
%%d2956)
%%q2943
((lambda (%%tmp2959)
((lambda (%%d2960)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(cons '#(syntax-object
unsyntax
((top)
#(ribcage #(d) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(b* dnew)
#((top) (top))
#("i" "i"))
#(ribcage #(d) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(q n b* k)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage (vqs qs) ((top) (top)) ("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%d2960))
%%tmp2959))
%%dnew2958))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2954)
((lambda (%%tmp2961)
(if (if %%tmp2961
(apply (lambda (%%d2962)
(not (= %%n2944 0)))
%%tmp2961)
#f)
(apply (lambda (%%d2963)
(%%qs2941
%%d2963
(- %%n2944 1)
%%b*2945
(lambda (%%b*2964
%%dnew2965)
(%%k2946 %%b*2964
(if (eq? %%dnew2965
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%d2963)
%%q2943
((lambda (%%tmp2966)
((lambda (%%d2967)
(cons '#(syntax-object
unsyntax-splicing
((top)
#(ribcage #(d) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(b* dnew)
#((top) (top))
#("i" "i"))
#(ribcage #(d) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(q n b* k)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage
(vqs qs)
((top) (top))
("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%d2967))
%%tmp2966))
%%dnew2965))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2961)
((lambda (%%tmp2968)
(if (if %%tmp2968
(apply (lambda (%%q2969)
(= %%n2944 0))
%%tmp2968)
#f)
(apply (lambda (%%q2970)
((lambda (%%tmp2971)
((lambda (%%tmp2972)
(if %%tmp2972
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(apply (lambda (%%t2973)
(%%k2946 (cons (list %%t2973 %%q2970)
%%b*2945)
%%t2973))
%%tmp2972)
(syntax-error %%tmp2971)))
($syntax-dispatch %%tmp2971 '(any))))
(generate-temporaries (list %%q2970))))
%%tmp2968)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2974)
(if (if %%tmp2974
(apply (lambda (%%q2975
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%d2976)
(= %%n2944 0))
%%tmp2974)
#f)
(apply (lambda (%%q2977 %%d2978)
(%%qs2941
%%d2978
%%n2944
%%b*2945
(lambda (%%b*2979 %%dnew2980)
((lambda (%%tmp2981)
((lambda (%%tmp2982)
(if %%tmp2982
(apply (lambda (%%t2983)
(%%k2946 (append (map list
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%t2983
%%q2977)
%%b*2979)
((lambda (%%tmp2986)
((lambda (%%d2987) (append %%t2983 %%d2987)) %%tmp2986))
%%dnew2980)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2982)
(syntax-error %%tmp2981)))
($syntax-dispatch %%tmp2981 'each-any)))
(generate-temporaries %%q2977)))))
%%tmp2974)
((lambda (%%tmp2990)
(if (if %%tmp2990
(apply (lambda (%%q2991 %%d2992) (= %%n2944 0))
%%tmp2990)
#f)
(apply (lambda (%%q2993 %%d2994)
(%%qs2941
%%d2994
%%n2944
%%b*2945
(lambda (%%b*2995 %%dnew2996)
((lambda (%%tmp2997)
((lambda (%%tmp2998)
(if %%tmp2998
(apply (lambda (%%t2999)
(%%k2946 (append (map (lambda (%%tmp3001
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmp3000)
(list (cons %%tmp3000
'(#(syntax-object
...
((top)
#(ribcage
#(t)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(b* dnew)
#((top) (top))
#("i" "i"))
#(ribcage
#(q d)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(q n b* k)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage
(vqs qs)
((top) (top))
("i" "i"))
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))))
%%tmp3001))
%%q2993
%%t2999)
%%b*2995)
((lambda (%%tmp3002)
((lambda (%%tmp3003)
(if %%tmp3003
(apply (lambda (%%m3004)
((lambda (%%tmp3005)
((lambda (%%d3006)
(append (apply append %%m3004)
%%d3006))
%%tmp3005))
%%dnew2996))
%%tmp3003)
(syntax-error %%tmp3002)))
($syntax-dispatch %%tmp3002 '#(each each-any))))
(map (lambda (%%tmp3009)
(cons %%tmp3009
'(#(syntax-object
...
((top)
#(ribcage #(t) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(b* dnew)
#((top) (top))
#("i" "i"))
#(ribcage
#(q d)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(q n b* k)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage
(vqs qs)
((top) (top))
("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))))
%%t2999))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2998)
(syntax-error %%tmp2997)))
($syntax-dispatch %%tmp2997 'each-any)))
(generate-temporaries %%q2993)))))
%%tmp2990)
((lambda (%%tmp3011)
(if %%tmp3011
(apply (lambda (%%a3012 %%d3013)
(%%qs2941
%%a3012
%%n2944
%%b*2945
(lambda (%%b*3014 %%anew3015)
(%%qs2941
%%d3013
%%n2944
%%b*3014
(lambda (%%b*3016 %%dnew3017)
(%%k2946 %%b*3016
(if (if (eq? %%anew3015
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%a3012)
(eq? %%dnew3017 %%d3013)
#f)
%%q2943
((lambda (%%tmp3018)
((lambda (%%tmp3019)
(if %%tmp3019
(apply (lambda (%%a3020 %%d3021)
(cons %%a3020 %%d3021))
%%tmp3019)
(syntax-error %%tmp3018)))
($syntax-dispatch %%tmp3018 '(any any))))
(list %%anew3015 %%dnew3017)))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3011)
((lambda (%%tmp3022)
(if %%tmp3022
(apply (lambda (%%x3023)
(%%vqs2942
%%x3023
%%n2944
%%b*2945
(lambda (%%b*3025 %%xnew*3026)
(%%k2946 %%b*3025
(if ((letrec ((%%same?3027
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(lambda (%%x*3028 %%xnew*3029)
(if (null? %%x*3028)
(null? %%xnew*3029)
(if (not (null? %%xnew*3029))
(if (eq? (car %%x*3028)
(car %%xnew*3029))
(%%same?3027
(cdr %%x*3028)
(cdr %%xnew*3029))
#f)
#f)))))
%%same?3027)
%%x3023
%%xnew*3026)
%%q2943
((lambda (%%tmp3031)
((lambda (%%tmp3032)
(if %%tmp3032
(apply (lambda (%%x3033) (list->vector %%x3033))
%%tmp3032)
(syntax-error %%tmp3031)))
($syntax-dispatch %%tmp3031 'each-any)))
%%xnew*3026))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3022)
((lambda (%%_3035)
(%%k2946 %%b*2945 %%q2943))
%%tmp2947)))
($syntax-dispatch
%%tmp2947
'#(vector each-any)))))
($syntax-dispatch %%tmp2947 '(any . any)))))
($syntax-dispatch
%%tmp2947
'((#(free-id
#(syntax-object
unsyntax-splicing
((top)
#(ribcage () () ())
#(ribcage
#(q n b* k)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage (vqs qs) ((top) (top)) ("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
.
each-any)
.
any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2947
'((#(free-id
#(syntax-object
unsyntax
((top)
#(ribcage () () ())
#(ribcage
#(q n b* k)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage
(vqs qs)
((top) (top))
("i" "i"))
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t))))
.
each-any)
.
any)))))
($syntax-dispatch
%%tmp2947
'(#(free-id
#(syntax-object
unsyntax
((top)
#(ribcage () () ())
#(ribcage
#(q n b* k)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage
(vqs qs)
((top) (top))
("i" "i"))
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t))))
any)))))
($syntax-dispatch
%%tmp2947
'(#(free-id
#(syntax-object
unsyntax-splicing
((top)
#(ribcage () () ())
#(ribcage
#(q n b* k)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage
(vqs qs)
((top) (top))
("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
.
any)))))
($syntax-dispatch
%%tmp2947
'(#(free-id
#(syntax-object
unsyntax
((top)
#(ribcage () () ())
#(ribcage
#(q n b* k)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage (vqs qs) ((top) (top)) ("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
.
any)))))
($syntax-dispatch
%%tmp2947
'(#(free-id
#(syntax-object
quasisyntax
((top)
#(ribcage () () ())
#(ribcage
#(q n b* k)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage (vqs qs) ((top) (top)) ("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
.
any))))
%%q2943)))
(%%vqs2942
(lambda (%%x*3036 %%n3037 %%b*3038 %%k3039)
(if (null? %%x*3036)
(%%k3039 %%b*3038 '())
(%%vqs2942
(cdr %%x*3036)
%%n3037
%%b*3038
(lambda (%%b*3040 %%xnew*3041)
((lambda (%%tmp3042)
((lambda (%%tmp3043)
(if (if %%tmp3043
(apply (lambda (%%q3044) (= %%n3037 0))
%%tmp3043)
#f)
(apply (lambda (%%q3045)
((lambda (%%tmp3046)
((lambda (%%tmp3047)
(if %%tmp3047
(apply (lambda (%%t3048)
(%%k3039 (append (map list
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%t3048
%%q3045)
%%b*3040)
(append %%t3048 %%xnew*3041)))
%%tmp3047)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(syntax-error %%tmp3046)))
($syntax-dispatch
%%tmp3046
'each-any)))
(generate-temporaries %%q3045)))
%%tmp3043)
((lambda (%%tmp3053)
(if (if %%tmp3053
(apply (lambda (%%q3054)
(= %%n3037 0))
%%tmp3053)
#f)
(apply (lambda (%%q3055)
((lambda (%%tmp3056)
((lambda (%%tmp3057)
(if %%tmp3057
(apply (lambda (%%t3058)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(%%k3039 (append (map (lambda (%%tmp3060
%%tmp3059)
(list (cons %%tmp3059
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'(#(syntax-object
...
((top)
#(ribcage #(t) #((top)) #("i"))
#(ribcage #(q) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(b* xnew*) #((top) (top)) #("i" "i"))
#(ribcage () () ())
#(ribcage
#(x* n b* k)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage (vqs qs) ((top) (top)) ("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))))
%%tmp3060))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%q3055
%%t3058)
%%b*3040)
((lambda (%%tmp3061)
((lambda (%%tmp3062)
(if %%tmp3062
(apply (lambda (%%m3063)
(append (apply append
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%m3063)
%%xnew*3041))
%%tmp3062)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(syntax-error %%tmp3061)))
($syntax-dispatch
%%tmp3061
'#(each each-any))))
(map (lambda (%%tmp3066)
(cons %%tmp3066
'(#(syntax-object
...
((top)
#(ribcage
#(t)
#((top))
#("i"))
#(ribcage
#(q)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(b* xnew*)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x* n b* k)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage
(vqs qs)
((top) (top))
("i" "i"))
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t))))))
%%t3058))))
%%tmp3057)
(syntax-error %%tmp3056)))
($syntax-dispatch %%tmp3056 'each-any)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(generate-temporaries
%%q3055)))
%%tmp3053)
((lambda (%%_3068)
(%%qs2941
(car %%x*3036)
%%n3037
%%b*3040
(lambda (%%b*3069 %%xnew3070)
(%%k3039 %%b*3069
(cons %%xnew3070
%%xnew*3041)))))
%%tmp3042)))
($syntax-dispatch
%%tmp3042
'(#(free-id
#(syntax-object
unsyntax-splicing
((top)
#(ribcage () () ())
#(ribcage
#(b* xnew*)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x* n b* k)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage
(vqs qs)
((top) (top))
("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
.
each-any)))))
($syntax-dispatch
%%tmp3042
'(#(free-id
#(syntax-object
unsyntax
((top)
#(ribcage () () ())
#(ribcage
#(b* xnew*)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x* n b* k)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage (vqs qs) ((top) (top)) ("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
.
each-any))))
(car %%x*3036))))))))
((lambda (%%tmp3071)
((lambda (%%tmp3072)
(if %%tmp3072
(apply (lambda (%%_3073 %%x3074)
(%%qs2941
%%x3074
0
'()
(lambda (%%b*3075 %%xnew3076)
(if (eq? %%xnew3076 %%x3074)
(list '#(syntax-object
syntax
((top)
#(ribcage () () ())
#(ribcage
#(b* xnew)
#((top) (top))
#("i" "i"))
#(ribcage
#(_ x)
#((top) (top))
#("i" "i"))
#(ribcage
(vqs qs)
((top) (top))
("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%x3074)
((lambda (%%tmp3077)
((lambda (%%tmp3078)
(if %%tmp3078
(apply (lambda (%%b3079 %%x3080)
(list '#(syntax-object
with-syntax
((top)
#(ribcage
#(b x)
#((top) (top))
#("i" "i"))
#(ribcage
()
()
())
#(ribcage
#(b* xnew)
#((top) (top))
#("i" "i"))
#(ribcage
#(_ x)
#((top) (top))
#("i" "i"))
#(ribcage
(vqs qs)
((top) (top))
("i" "i"))
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
%%b3079
(list '#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
syntax
((top)
#(ribcage #(b x) #((top) (top)) #("i" "i"))
#(ribcage () () ())
#(ribcage #(b* xnew) #((top) (top)) #("i" "i"))
#(ribcage #(_ x) #((top) (top)) #("i" "i"))
#(ribcage (vqs qs) ((top) (top)) ("i" "i"))
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%x3080)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3078)
(syntax-error %%tmp3077)))
($syntax-dispatch
%%tmp3077
'(each-any any))))
(list %%b*3075 %%xnew3076))))))
%%tmp3072)
(syntax-error %%tmp3071)))
($syntax-dispatch %%tmp3071 '(any any))))
%%x2940)))
'*top*)
($sc-put-cte
'#(syntax-object include ((top) #(ribcage #(include) #((top)) #(include))))
(lambda (%%x3082)
(letrec ((%%read-file3083
(lambda (%%fn3084 %%k3085)
((lambda (%%p3086)
((letrec ((%%f3087 (lambda ()
((lambda (%%x3088)
(if (eof-object? %%x3088)
(begin
(close-input-port %%p3086)
'())
(cons (datum->syntax-object
%%k3085
%%x3088)
(%%f3087))))
(read %%p3086)))))
%%f3087)))
(open-input-file %%fn3084)))))
((lambda (%%tmp3089)
((lambda (%%tmp3090)
(if %%tmp3090
(apply (lambda (%%k3091 %%filename3092)
((lambda (%%fn3093)
(datum->syntax-object
%%k3091
((lambda (%%src3094)
((lambda (%%locat3095)
((lambda () %%src3094)))
(##source-locat %%src3094)))
(##include-file-as-a-begin-expr
((lambda (%%y3096)
(if (##source? %%y3096)
%%y3096
(##make-source %%y3096 #f)))
(vector-ref %%x3082 1))))))
(syntax-object->datum %%filename3092)))
%%tmp3090)
(syntax-error %%tmp3089)))
($syntax-dispatch %%tmp3089 '(any any))))
%%x3082)))
'*top*)
($sc-put-cte
'#(syntax-object case ((top) #(ribcage #(case) #((top)) #(case))))
(lambda (%%x3097)
((lambda (%%tmp3098)
((lambda (%%tmp3099)
(if %%tmp3099
(apply (lambda (%%_3100 %%e3101 %%m13102 %%m23103)
((lambda (%%tmp3104)
((lambda (%%body3105)
(list '#(syntax-object
let
((top)
#(ribcage #(body) #((top)) #("i"))
#(ribcage
#(_ e m1 m2)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(list (list '#(syntax-object
t
((top)
#(ribcage
#(body)
#((top))
#("i"))
#(ribcage
#(_ e m1 m2)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
%%e3101))
%%body3105))
%%tmp3104))
((letrec ((%%f3106 (lambda (%%clause3107
%%clauses3108)
(if (null? %%clauses3108)
((lambda (%%tmp3109)
((lambda (%%tmp3110)
(if %%tmp3110
(apply (lambda (%%e13111
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e23112)
(cons '#(syntax-object
begin
((top)
#(ribcage
#(e1 e2)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ e m1 m2)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons %%e13111 %%e23112)))
%%tmp3110)
((lambda (%%tmp3114)
(if %%tmp3114
(apply (lambda (%%k3115 %%e13116 %%e23117)
(list '#(syntax-object
if
((top)
#(ribcage
#(k e1 e2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ e m1 m2)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
memv
((top)
#(ribcage
#(k e1 e2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ e m1 m2)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
t
((top)
#(ribcage
#(k e1 e2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ e m1 m2)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
quote
((top)
#(ribcage
#(k e1 e2)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ e m1 m2)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
%%k3115))
(cons '#(syntax-object
begin
((top)
#(ribcage
#(k e1 e2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ e m1 m2)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
(cons %%e13116 %%e23117))))
%%tmp3114)
((lambda (%%_3120) (syntax-error %%x3097))
%%tmp3109)))
($syntax-dispatch %%tmp3109 '(each-any any . each-any)))))
($syntax-dispatch
%%tmp3109
'(#(free-id
#(syntax-object
else
((top)
#(ribcage () () ())
#(ribcage #(clause clauses) #((top) (top)) #("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ e m1 m2)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
any
.
each-any))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%clause3107)
((lambda (%%tmp3121)
((lambda (%%rest3122)
((lambda (%%tmp3123)
((lambda (%%tmp3124)
(if %%tmp3124
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(apply (lambda (%%k3125 %%e13126 %%e23127)
(list '#(syntax-object
if
((top)
#(ribcage
#(k e1 e2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage #(rest) #((top)) #("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage #(f) #((top)) #("i"))
#(ribcage
#(_ e m1 m2)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
memv
((top)
#(ribcage
#(k e1 e2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(rest)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ e m1 m2)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
t
((top)
#(ribcage
#(k e1 e2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(rest)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ e m1 m2)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
quote
((top)
#(ribcage
#(k e1 e2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(rest)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ e m1 m2)
#((top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
%%k3125))
(cons '#(syntax-object
begin
((top)
#(ribcage
#(k e1 e2)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage
#(rest)
#((top))
#("i"))
#(ribcage () () ())
#(ribcage
#(clause clauses)
#((top) (top))
#("i" "i"))
#(ribcage
#(f)
#((top))
#("i"))
#(ribcage
#(_ e m1 m2)
#((top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
(cons %%e13126 %%e23127))
%%rest3122))
%%tmp3124)
((lambda (%%_3130) (syntax-error %%x3097))
%%tmp3123)))
($syntax-dispatch %%tmp3123 '(each-any any . each-any))))
%%clause3107))
%%tmp3121))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%f3106 (car %%clauses3108)
(cdr %%clauses3108)))))))
%%f3106)
%%m13102
%%m23103)))
%%tmp3099)
(syntax-error %%tmp3098)))
($syntax-dispatch %%tmp3098 '(any any any . each-any))))
%%x3097))
'*top*)
($sc-put-cte
'#(syntax-object
identifier-syntax
((top) #(ribcage #(identifier-syntax) #((top)) #(identifier-syntax))))
(lambda (%%x3132)
((lambda (%%tmp3133)
((lambda (%%tmp3134)
(if %%tmp3134
(apply (lambda (%%dummy3135 %%e3136)
(list '#(syntax-object
lambda
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
(x)
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
syntax-case
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
x
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
'()
(list '#(syntax-object
id
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
(identifier? (syntax id))
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
syntax
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
%%e3136))
(list '(#(syntax-object
_
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
#(syntax-object
x
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
#(syntax-object
...
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t))))
(list '#(syntax-object
syntax
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
(cons %%e3136
'(#(syntax-object
x
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage
*top*
#t)))
#(syntax-object
...
((top)
#(ribcage
#(dummy e)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage
*top*
#t))))))))))
%%tmp3134)
((lambda (%%tmp3137)
(if (if %%tmp3137
(apply (lambda (%%dummy3138
%%id3139
%%exp13140
%%var3141
%%val3142
%%exp23143)
(if (identifier? %%id3139)
(identifier? %%var3141)
#f))
%%tmp3137)
#f)
(apply (lambda (%%dummy3144
%%id3145
%%exp13146
%%var3147
%%val3148
%%exp23149)
(list '#(syntax-object
cons
((top)
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top)
(top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
'macro!
((top)
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top)
(top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
lambda
((top)
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top)
(top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
(x)
((top)
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top)
(top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
syntax-case
((top)
#(ribcage
#(dummy
id
exp1
var
val
exp2)
#(("m" top)
(top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
x
((top)
#(ribcage
#(dummy
id
exp1
var
val
exp2)
#(("m" top)
(top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
(set!)
((top)
#(ribcage
#(dummy
id
exp1
var
val
exp2)
#(("m" top)
(top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
(list (list '#(syntax-object
set!
((top)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%var3147
%%val3148)
(list '#(syntax-object
syntax
((top)
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%exp23149))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(list (cons %%id3145
'(#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
x
((top)
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
#(syntax-object
...
((top)
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))))
(list '#(syntax-object
syntax
((top)
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(cons %%exp13146
'(#(syntax-object
x
((top)
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
#(syntax-object
...
((top)
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(list %%id3145
(list '#(syntax-object
identifier?
((top)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
syntax
((top)
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%id3145))
(list '#(syntax-object
syntax
((top)
#(ribcage
#(dummy id exp1 var val exp2)
#(("m" top) (top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%exp13146))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3137)
(syntax-error %%tmp3133)))
($syntax-dispatch
%%tmp3133
'(any (any any)
((#(free-id
#(syntax-object
set!
((top)
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t))))
any
any)
any))))))
($syntax-dispatch %%tmp3133 '(any any))))
%%x3132))
'*top*)
($sc-put-cte
'#(syntax-object
cond-expand
((top) #(ribcage #(cond-expand) #((top)) #(cond-expand))))
(lambda (%%x3150)
((lambda (%%tmp3151)
((lambda (%%tmp3152)
(if %%tmp3152
(apply (lambda (%%dummy3153)
'#(syntax-object
(syntax-error "Unfulfilled cond-expand")
((top)
#(ribcage #(dummy) #(("m" top)) #("i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t))))
%%tmp3152)
((lambda (%%tmp3154)
(if %%tmp3154
(apply (lambda (%%dummy3155 %%body3156)
(cons '#(syntax-object
begin
((top)
#(ribcage
#(dummy body)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%body3156))
%%tmp3154)
((lambda (%%tmp3158)
(if %%tmp3158
(apply (lambda (%%dummy3159
%%body3160
%%more-clauses3161)
(cons '#(syntax-object
begin
((top)
#(ribcage
#(dummy body more-clauses)
#(("m" top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
%%body3160))
%%tmp3158)
((lambda (%%tmp3163)
(if %%tmp3163
(apply (lambda (%%dummy3164
%%req13165
%%req23166
%%body3167
%%more-clauses3168)
(cons '#(syntax-object
cond-expand
((top)
#(ribcage
#(dummy
req1
req2
body
more-clauses)
#(("m" top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage
*top*
#t)))
(cons (list %%req13165
(cons '#(syntax-object
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
cond-expand
((top)
#(ribcage
#(dummy req1 req2 body more-clauses)
#(("m" top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(cons (cons (cons '#(syntax-object
and
((top)
#(ribcage
#(dummy
req1
req2
body
more-clauses)
#(("m" top)
(top)
(top)
(top)
(top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
%%req23166)
%%body3167)
%%more-clauses3168)))
%%more-clauses3168)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3163)
((lambda (%%tmp3173)
(if %%tmp3173
(apply (lambda (%%dummy3174
%%body3175
%%more-clauses3176)
(cons '#(syntax-object
cond-expand
((top)
#(ribcage
#(dummy
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
body
more-clauses)
#(("m" top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%more-clauses3176))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3173)
((lambda (%%tmp3178)
(if %%tmp3178
(apply (lambda (%%dummy3179
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%req13180
%%req23181
%%body3182
%%more-clauses3183)
(list '#(syntax-object
cond-expand
((top)
#(ribcage
#(dummy req1 req2 body more-clauses)
#(("m" top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(list %%req13180
(cons '#(syntax-object
begin
((top)
#(ribcage
#(dummy req1 req2 body more-clauses)
#(("m" top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%body3182))
(list '#(syntax-object
else
((top)
#(ribcage
#(dummy req1 req2 body more-clauses)
#(("m" top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(cons '#(syntax-object
cond-expand
((top)
#(ribcage
#(dummy req1 req2 body more-clauses)
#(("m" top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(cons (cons (cons '#(syntax-object
or
((top)
#(ribcage
#(dummy
req1
req2
body
more-clauses)
#(("m" top)
(top)
(top)
(top)
(top))
#("i"
"i"
"i"
"i"
"i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage
*top*
#t)))
%%req23181)
%%body3182)
%%more-clauses3183)))))
%%tmp3178)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp3188)
(if %%tmp3188
(apply (lambda (%%dummy3189
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%req3190
%%body3191
%%more-clauses3192)
(list '#(syntax-object
cond-expand
((top)
#(ribcage
#(dummy req body more-clauses)
#(("m" top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
(list %%req3190
(cons '#(syntax-object
cond-expand
((top)
#(ribcage
#(dummy
req
body
more-clauses)
#(("m" top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
%%more-clauses3192))
(cons '#(syntax-object
else
((top)
#(ribcage
#(dummy req body more-clauses)
#(("m" top) (top) (top) (top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%body3191)))
%%tmp3188)
((lambda (%%tmp3195)
(if %%tmp3195
(apply (lambda (%%dummy3196
%%body3197
%%more-clauses3198)
(cons '#(syntax-object
begin
((top)
#(ribcage
#(dummy body more-clauses)
#(("m" top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%body3197))
%%tmp3195)
((lambda (%%tmp3200)
(if %%tmp3200
(apply (lambda (%%dummy3201
%%body3202
%%more-clauses3203)
(cons '#(syntax-object
begin
((top)
#(ribcage
#(dummy body more-clauses)
#(("m" top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
%%body3202))
%%tmp3200)
((lambda (%%tmp3205)
(if %%tmp3205
(apply (lambda (%%dummy3206
%%feature-id3207
%%body3208
%%more-clauses3209)
(cons '#(syntax-object
cond-expand
((top)
#(ribcage
#(dummy
feature-id
body
more-clauses)
#(("m" top)
(top)
(top)
(top))
#("i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage
*top*
#t)))
%%more-clauses3209))
%%tmp3205)
(syntax-error %%tmp3151)))
($syntax-dispatch
%%tmp3151
'(any (any . each-any) . each-any)))))
($syntax-dispatch
%%tmp3151
'(any (#(free-id
#(syntax-object
gambit
((top)
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t))))
.
each-any)
.
each-any)))))
($syntax-dispatch
%%tmp3151
'(any (#(free-id
#(syntax-object
srfi-0
((top)
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t))))
.
each-any)
.
each-any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp3151
'(any ((#(free-id
#(syntax-object
not
((top)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t))))
any)
.
each-any)
.
each-any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp3151
'(any ((#(free-id
#(syntax-object
or
((top)
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage
*top*
#t))))
any
.
each-any)
.
each-any)
.
each-any)))))
($syntax-dispatch
%%tmp3151
'(any ((#(free-id
#(syntax-object
or
((top)
#(ribcage () () ())
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))))
.
each-any)
.
each-any)))))
($syntax-dispatch
%%tmp3151
'(any ((#(free-id
#(syntax-object
and
((top)
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t))))
any
.
each-any)
.
each-any)
.
each-any)))))
($syntax-dispatch
%%tmp3151
'(any ((#(free-id
#(syntax-object
and
((top)
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))))
.
each-any)
.
each-any)))))
($syntax-dispatch
%%tmp3151
'(any (#(free-id
#(syntax-object
else
((top)
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t))))
.
each-any))))))
($syntax-dispatch %%tmp3151 '(any))))
%%x3150))
'*top*)
($sc-put-cte
'#(syntax-object
define-macro
((top) #(ribcage #(define-macro) #((top)) #(define-macro))))
(lambda (%%x3211)
((lambda (%%tmp3212)
((lambda (%%tmp3213)
(if %%tmp3213
(apply (lambda (%%_3214
%%name3215
%%params3216
%%body13217
%%body23218)
(list '#(syntax-object
define-macro
((top)
#(ribcage
#(_ name params body1 body2)
#((top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%name3215
(cons '#(syntax-object
lambda
((top)
#(ribcage
#(_ name params body1 body2)
#((top) (top) (top) (top) (top))
#("i" "i" "i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons %%params3216
(cons %%body13217 %%body23218)))))
%%tmp3213)
((lambda (%%tmp3220)
(if %%tmp3220
(apply (lambda (%%_3221 %%name3222 %%expander3223)
(list '#(syntax-object
define-syntax
((top)
#(ribcage
#(_ name expander)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%name3222
(list '#(syntax-object
lambda
((top)
#(ribcage
#(_ name expander)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
(y)
((top)
#(ribcage
#(_ name expander)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
syntax-case
((top)
#(ribcage
#(_ name expander)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
y
((top)
#(ribcage
#(_ name expander)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage *top* #t)))
'()
(list '#(syntax-object
(k . args)
((top)
#(ribcage
#(_ name expander)
#((top)
(top)
(top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage
#(x)
#((top))
#("i"))
#(top-ribcage
*top*
#t)))
(list '#(syntax-object
let
((top)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#(ribcage
#(_ name expander)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
((lst (syntax-object->datum (syntax args))))
((top)
#(ribcage
#(_ name expander)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(list '#(syntax-object
datum->syntax-object
((top)
#(ribcage
#(_ name expander)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
'#(syntax-object
(syntax k)
((top)
#(ribcage
#(_ name expander)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons '#(syntax-object
apply
((top)
#(ribcage
#(_ name expander)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
(cons %%expander3223
'#(syntax-object
(lst)
((top)
#(ribcage
#(_ name expander)
#((top) (top) (top))
#("i" "i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3220)
(syntax-error %%tmp3212)))
($syntax-dispatch %%tmp3212 '(any any any)))))
($syntax-dispatch %%tmp3212 '(any (any . any) any . each-any))))
%%x3211))
'*top*)
($sc-put-cte
'#(syntax-object ##begin ((top) #(ribcage #(##begin) #((top)) #(##begin))))
(lambda (%%x3224)
((lambda (%%tmp3225)
((lambda (%%tmp3226)
(if %%tmp3226
(apply (lambda (%%_3227 %%body13228)
(cons '#(syntax-object
begin
((top)
#(ribcage
#(_ body1)
#((top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t)))
%%body13228))
%%tmp3226)
(syntax-error %%tmp3225)))
($syntax-dispatch %%tmp3225 '(any . each-any))))
%%x3224))
'*top*)
($sc-put-cte
'#(syntax-object future ((top) #(ribcage #(future) #((top)) #(future))))
(lambda (%%x3230)
((lambda (%%tmp3231)
((lambda (%%tmp3232)
(if %%tmp3232
(apply (lambda (%%dummy3233 %%rest3234)
(cons '#(syntax-object
##future
((top)
#(ribcage
#(dummy rest)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%rest3234))
%%tmp3232)
(syntax-error %%tmp3231)))
($syntax-dispatch %%tmp3231 '(any . each-any))))
%%x3230))
'*top*)
($sc-put-cte
'#(syntax-object
c-define-type
((top) #(ribcage #(c-define-type) #((top)) #(c-define-type))))
(lambda (%%x3236)
((lambda (%%tmp3237)
((lambda (%%tmp3238)
(if %%tmp3238
(apply (lambda (%%dummy3239 %%rest3240)
(cons '#(syntax-object
##c-define-type
((top)
#(ribcage
#(dummy rest)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%rest3240))
%%tmp3238)
(syntax-error %%tmp3237)))
($syntax-dispatch %%tmp3237 '(any . each-any))))
%%x3236))
'*top*)
($sc-put-cte
'#(syntax-object
c-declare
((top) #(ribcage #(c-declare) #((top)) #(c-declare))))
(lambda (%%x3242)
((lambda (%%tmp3243)
((lambda (%%tmp3244)
(if %%tmp3244
(apply (lambda (%%dummy3245 %%rest3246)
(cons '#(syntax-object
##c-declare
((top)
#(ribcage
#(dummy rest)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%rest3246))
%%tmp3244)
(syntax-error %%tmp3243)))
($syntax-dispatch %%tmp3243 '(any . each-any))))
%%x3242))
'*top*)
($sc-put-cte
'#(syntax-object
c-initialize
((top) #(ribcage #(c-initialize) #((top)) #(c-initialize))))
(lambda (%%x3248)
((lambda (%%tmp3249)
((lambda (%%tmp3250)
(if %%tmp3250
(apply (lambda (%%dummy3251 %%rest3252)
(cons '#(syntax-object
##c-initialize
((top)
#(ribcage
#(dummy rest)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%rest3252))
%%tmp3250)
(syntax-error %%tmp3249)))
($syntax-dispatch %%tmp3249 '(any . each-any))))
%%x3248))
'*top*)
($sc-put-cte
'#(syntax-object
c-lambda
((top) #(ribcage #(c-lambda) #((top)) #(c-lambda))))
(lambda (%%x3254)
((lambda (%%tmp3255)
((lambda (%%tmp3256)
(if %%tmp3256
(apply (lambda (%%dummy3257 %%rest3258)
(cons '#(syntax-object
##c-lambda
((top)
#(ribcage
#(dummy rest)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%rest3258))
%%tmp3256)
(syntax-error %%tmp3255)))
($syntax-dispatch %%tmp3255 '(any . each-any))))
%%x3254))
'*top*)
($sc-put-cte
'#(syntax-object
c-define
((top) #(ribcage #(c-define) #((top)) #(c-define))))
(lambda (%%x3260)
((lambda (%%tmp3261)
((lambda (%%tmp3262)
(if %%tmp3262
(apply (lambda (%%dummy3263 %%rest3264)
(cons '#(syntax-object
##c-define
((top)
#(ribcage
#(dummy rest)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%rest3264))
%%tmp3262)
(syntax-error %%tmp3261)))
($syntax-dispatch %%tmp3261 '(any . each-any))))
%%x3260))
'*top*)
($sc-put-cte
'#(syntax-object declare ((top) #(ribcage #(declare) #((top)) #(declare))))
(lambda (%%x3266)
((lambda (%%tmp3267)
((lambda (%%tmp3268)
(if %%tmp3268
(apply (lambda (%%dummy3269 %%rest3270)
(cons '#(syntax-object
##declare
((top)
#(ribcage
#(dummy rest)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%rest3270))
%%tmp3268)
(syntax-error %%tmp3267)))
($syntax-dispatch %%tmp3267 '(any . each-any))))
%%x3266))
'*top*)
($sc-put-cte
'#(syntax-object
namespace
((top) #(ribcage #(namespace) #((top)) #(namespace))))
(lambda (%%x3272)
((lambda (%%tmp3273)
((lambda (%%tmp3274)
(if %%tmp3274
(apply (lambda (%%dummy3275 %%rest3276)
(cons '#(syntax-object
##namespace
((top)
#(ribcage
#(dummy rest)
#(("m" top) (top))
#("i" "i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t)))
%%rest3276))
%%tmp3274)
(syntax-error %%tmp3273)))
($syntax-dispatch %%tmp3273 '(any . each-any))))
%%x3272))
'*top*))
;;;============================================================================

;;; Install the syntax-case expander.

(define c#expand-source
(lambda (src)
src))

(set! c#expand-source ;; setup compiler's expander
(lambda (src)
(sc-compile-expand src)))

(set! ##expand-source ;; setup interpreter's expander
(lambda (src)
(sc-expand src)))

;;;============================================================================
