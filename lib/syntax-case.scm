;;;============================================================================

;;; File: "syntax-case.scm", Time-stamp: <2013-09-17 09:08:23 feeley>

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
;; with the compiler.  You can also rename this file to "gambcext.scm"
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
syntax-error
syntax-object->datum
syntax->list
syntax->vector

))

(##namespace ("sc#"

interaction-environment
eval
gensym

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
(lambda (%%expression470 %%wrap471)
(vector 'syntax-object %%expression470 %%wrap471)))
(%%syntax-object?64
(lambda (%%x472)
(if (vector? %%x472)
(if (= (vector-length %%x472) 3)
(eq? (vector-ref %%x472 0) 'syntax-object)
#f)
#f)))
(%%syntax-object-expression65
(lambda (%%x473) (vector-ref %%x473 1)))
(%%syntax-object-wrap66 (lambda (%%x474) (vector-ref %%x474 2)))
(%%set-syntax-object-expression!67
(lambda (%%x475 %%update476)
(vector-set! %%x475 1 %%update476)))
(%%set-syntax-object-wrap!68
(lambda (%%x477 %%update478)
(vector-set! %%x477 2 %%update478)))
(%%top-level-eval-hook69
(lambda (%%x479) (eval (list %%noexpand62 %%x479))))
(%%local-eval-hook70
(lambda (%%x480) (eval (list %%noexpand62 %%x480))))
(%%define-top-level-value-hook71
(lambda (%%sym481 %%val482)
(%%top-level-eval-hook69
(build-source
#f
(list (build-source #f 'define)
(build-source #f %%sym481)
((lambda (%%x483)
(if (self-eval? %%val482)
%%x483
(build-source
#f
(list (build-source #f 'quote) %%x483))))
(attach-source #f %%val482)))))))
(%%put-cte-hook72
(lambda (%%symbol484 %%val485)
($sc-put-cte %%symbol484 %%val485 '*top*)))
(%%get-global-definition-hook73
(lambda (%%symbol486) (getprop %%symbol486 '*sc-expander*)))
(%%put-global-definition-hook74
(lambda (%%symbol487 %%x488)
(if (not %%x488)
(remprop %%symbol487 '*sc-expander*)
(putprop %%symbol487 '*sc-expander* %%x488))))
(%%read-only-binding?75 (lambda (%%symbol489) #f))
(%%get-import-binding76
(lambda (%%symbol490 %%token491)
(getprop %%symbol490 %%token491)))
(%%update-import-binding!77
(lambda (%%symbol492 %%token493 %%p494)
((lambda (%%x495)
(if (not %%x495)
(remprop %%symbol492 %%token493)
(putprop %%symbol492 %%token493 %%x495)))
(%%p494 (%%get-import-binding76 %%symbol492 %%token493)))))
(%%generate-id78
((lambda (%%digits496)
((lambda (%%base497 %%session-key498)
(letrec ((%%make-digit499
(lambda (%%x501)
(string-ref %%digits496 %%x501)))
(%%fmt500
(lambda (%%n502)
((letrec ((%%fmt503
(lambda (%%n504 %%a505)
(if (< %%n504 %%base497)
(list->string
(cons (%%make-digit499
%%n504)
%%a505))
((lambda (%%r506 %%rest507)
(%%fmt503
%%rest507
(cons (%%make-digit499
%%r506)
%%a505)))
(modulo %%n504 %%base497)
(quotient
%%n504
%%base497))))))
%%fmt503)
%%n502
'()))))
((lambda (%%n508)
(lambda (%%name509)
(begin
(set! %%n508 (+ %%n508 1))
(string->symbol
(string-append
%%session-key498
(%%fmt500 %%n508)
(if %%name509
(string-append
"."
(symbol->string %%name509))
""))))))
-1)))
(string-length %%digits496)
"_"))
"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!$%&*/:<=>?~_^.+-"))
(%%built-lambda?162
(lambda (%%x510)
((lambda (%%t511)
(if %%t511
%%t511
(if (##source? %%x510)
(if (pair? (##source-code %%x510))
(if (##source? (car (##source-code %%x510)))
(eq? (##source-code
(car (##source-code %%x510)))
'lambda)
#f)
#f)
#f)))
(if (pair? %%x510) (eq? (car %%x510) 'lambda) #f))))
(%%build-sequence180
(lambda (%%ae512 %%exps513)
((letrec ((%%loop514
(lambda (%%exps515)
(if (null? (cdr %%exps515))
(car %%exps515)
(if ((lambda (%%x516)
((lambda (%%t517)
(if %%t517
%%t517
(if (##source? %%x516)
(if (pair? (##source-code
%%x516))
(if (##source?
(car (##source-code
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%x516)))
(if (eq? (##source-code (car (##source-code %%x516)))
'void)
(null? (cdr (##source-code %%x516)))
#f)
#f)
#f)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#f)))
(equal? %%x516 '(void))))
(car %%exps515))
(%%loop514 (cdr %%exps515))
(build-source
%%ae512
(cons (build-source %%ae512 'begin)
%%exps515)))))))
%%loop514)
%%exps513)))
(%%build-letrec181
(lambda (%%ae518 %%vars519 %%val-exps520 %%body-exp521)
(if (null? %%vars519)
%%body-exp521
(build-source
%%ae518
(list (build-source %%ae518 'letrec)
(build-source
%%ae518
(map (lambda (%%var522 %%val523)
(build-source
%%ae518
(list (build-source %%ae518 %%var522)
%%val523)))
%%vars519
%%val-exps520))
%%body-exp521)))))
(%%build-body182
(lambda (%%ae524 %%vars525 %%val-exps526 %%body-exp527)
(%%build-letrec181
%%ae524
%%vars525
%%val-exps526
%%body-exp527)))
(%%build-top-module183
(lambda (%%ae528
%%types529
%%vars530
%%val-exps531
%%body-exp532)
(call-with-values
(lambda ()
((letrec ((%%f533 (lambda (%%types534 %%vars535)
(if (null? %%types534)
(values '() '() '())
((lambda (%%var536)
(call-with-values
(lambda ()
(%%f533 (cdr %%types534)
(cdr %%vars535)))
(lambda (%%vars537
%%defns538
%%sets539)
(if (eq? (car %%types534)
'global)
((lambda (%%x540)
(values (cons %%x540
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%vars537)
(cons (build-source
#f
(list (build-source #f 'define)
(build-source #f %%var536)
(%%chi-void463)))
%%defns538)
(cons (build-source
#f
(list (build-source #f 'set!)
(build-source #f %%var536)
(build-source #f %%x540)))
%%sets539)))
(gensym %%var536))
(values (cons %%var536 %%vars537) %%defns538 %%sets539)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(car %%vars535))))))
%%f533)
%%types529
%%vars530))
(lambda (%%vars541 %%defns542 %%sets543)
(if (null? %%defns542)
(%%build-letrec181
%%ae528
%%vars541
%%val-exps531
%%body-exp532)
(%%build-sequence180
#f
(append %%defns542
(list (%%build-letrec181
%%ae528
%%vars541
%%val-exps531
(%%build-sequence180
#f
(append %%sets543
(list %%body-exp532))))))))))))
(%%sanitize-binding216
(lambda (%%b544)
(if (procedure? %%b544)
(cons 'macro %%b544)
(if (%%binding?230 %%b544)
(if ((lambda (%%t545)
(if (memv %%t545 '(core macro macro! deferred))
(procedure? (%%binding-value227 %%b544))
(if (memv %%t545 '($module))
(%%interface?397
(%%binding-value227 %%b544))
(if (memv %%t545 '(lexical))
#f
(if (memv %%t545
'(global meta-variable))
(symbol? (%%binding-value227
%%b544))
(if (memv %%t545 '(syntax))
((lambda (%%x546)
(if (pair? %%x546)
(if #f
((lambda (%%n547)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (integer? %%n547)
(if (exact? %%n547) (>= %%n547 0) #f)
#f))
(cdr %%x546))
#f)
#f))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%binding-value227
%%b544))
(if (memv %%t545
'(begin
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
define
define-syntax
set!
$module-key
$import
eval-when
meta))
(null? (%%binding-value227 %%b544))
(if (memv %%t545 '(local-syntax))
(boolean? (%%binding-value227 %%b544))
(if (memv %%t545 '(displaced-lexical))
(eq? (%%binding-value227 %%b544) #f)
#t)))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%binding-type226 %%b544))
%%b544
#f)
#f))))
(%%binding-type226 car)
(%%binding-value227 cdr)
(%%set-binding-type!228 set-car!)
(%%set-binding-value!229 set-cdr!)
(%%binding?230
(lambda (%%x548) (if (pair? %%x548) (symbol? (car %%x548)) #f)))
(%%extend-env240
(lambda (%%label549 %%binding550 %%r551)
(cons (cons %%label549 %%binding550) %%r551)))
(%%extend-env*241
(lambda (%%labels552 %%bindings553 %%r554)
(if (null? %%labels552)
%%r554
(%%extend-env*241
(cdr %%labels552)
(cdr %%bindings553)
(%%extend-env240
(car %%labels552)
(car %%bindings553)
%%r554)))))
(%%extend-var-env*242
(lambda (%%labels555 %%vars556 %%r557)
(if (null? %%labels555)
%%r557
(%%extend-var-env*242
(cdr %%labels555)
(cdr %%vars556)
(%%extend-env240
(car %%labels555)
(cons 'lexical (car %%vars556))
%%r557)))))
(%%displaced-lexical?243
(lambda (%%id558 %%r559)
((lambda (%%n560)
(if %%n560
((lambda (%%b561)
(eq? (%%binding-type226 %%b561) 'displaced-lexical))
(%%lookup246 %%n560 %%r559))
#f))
(%%id-var-name379 %%id558 '(())))))
(%%displaced-lexical-error244
(lambda (%%id562)
(syntax-error
%%id562
(if (%%id-var-name379 %%id562 '(()))
"identifier out of context"
"identifier not visible"))))
(%%lookup*245
(lambda (%%x563 %%r564)
((lambda (%%t565)
(if %%t565
(cdr %%t565)
(if (symbol? %%x563)
((lambda (%%t566)
(if %%t566 %%t566 (cons 'global %%x563)))
(%%get-global-definition-hook73 %%x563))
'(displaced-lexical . #f))))
(assq %%x563 %%r564))))
(%%lookup246
(lambda (%%x567 %%r568)
(letrec ((%%whack-binding!569
(lambda (%%b570 %%*b571)
(begin
(%%set-binding-type!228
%%b570
(%%binding-type226 %%*b571))
(%%set-binding-value!229
%%b570
(%%binding-value227 %%*b571))))))
((lambda (%%b572)
(begin
(if (eq? (%%binding-type226 %%b572) 'deferred)
(%%whack-binding!569
%%b572
(%%make-transformer-binding247
((%%binding-value227 %%b572))))
(void))
%%b572))
(%%lookup*245 %%x567 %%r568)))))
(%%make-transformer-binding247
(lambda (%%b573)
((lambda (%%t574)
(if %%t574
%%t574
(syntax-error %%b573 "invalid transformer")))
(%%sanitize-binding216 %%b573))))
(%%defer-or-eval-transformer248
(lambda (%%eval575 %%x576)
(if (%%built-lambda?162 %%x576)
(cons 'deferred (lambda () (%%eval575 %%x576)))
(%%make-transformer-binding247 (%%eval575 %%x576)))))
(%%global-extend249
(lambda (%%type577 %%sym578 %%val579)
(%%put-cte-hook72 %%sym578 (cons %%type577 %%val579))))
(%%nonsymbol-id?250
(lambda (%%x580)
(if (%%syntax-object?64 %%x580)
(symbol? ((lambda (%%e581)
(if (annotation? %%e581)
(annotation-expression %%e581)
%%e581))
(%%syntax-object-expression65 %%x580)))
#f)))
(%%id?251
(lambda (%%x582)
(if (symbol? %%x582)
#t
(if (%%syntax-object?64 %%x582)
(symbol? ((lambda (%%e583)
(if (annotation? %%e583)
(annotation-expression %%e583)
%%e583))
(%%syntax-object-expression65 %%x582)))
(if (annotation? %%x582)
(symbol? (annotation-expression %%x582))
#f)))))
(%%id-marks257
(lambda (%%id584)
(if (%%syntax-object?64 %%id584)
(%%wrap-marks261 (%%syntax-object-wrap66 %%id584))
(%%wrap-marks261 '((top))))))
(%%id-subst258
(lambda (%%id585)
(if (%%syntax-object?64 %%id585)
(%%wrap-subst262 (%%syntax-object-wrap66 %%id585))
(%%wrap-marks261 '((top))))))
(%%id-sym-name&marks259
(lambda (%%x586 %%w587)
(if (%%syntax-object?64 %%x586)
(values ((lambda (%%e588)
(if (annotation? %%e588)
(annotation-expression %%e588)
%%e588))
(%%syntax-object-expression65 %%x586))
(%%join-marks368
(%%wrap-marks261 %%w587)
(%%wrap-marks261
(%%syntax-object-wrap66 %%x586))))
(values ((lambda (%%e589)
(if (annotation? %%e589)
(annotation-expression %%e589)
%%e589))
%%x586)
(%%wrap-marks261 %%w587)))))
(%%make-wrap260 cons)
(%%wrap-marks261 car)
(%%wrap-subst262 cdr)
(%%make-indirect-label300
(lambda (%%label590) (vector 'indirect-label %%label590)))
(%%indirect-label?301
(lambda (%%x591)
(if (vector? %%x591)
(if (= (vector-length %%x591) 2)
(eq? (vector-ref %%x591 0) 'indirect-label)
#f)
#f)))
(%%indirect-label-label302
(lambda (%%x592) (vector-ref %%x592 1)))
(%%set-indirect-label-label!303
(lambda (%%x593 %%update594)
(vector-set! %%x593 1 %%update594)))
(%%gen-indirect-label304
(lambda () (%%make-indirect-label300 (%%gen-label307))))
(%%get-indirect-label305
(lambda (%%x595) (%%indirect-label-label302 %%x595)))
(%%set-indirect-label!306
(lambda (%%x596 %%v597)
(%%set-indirect-label-label!303 %%x596 %%v597)))
(%%gen-label307 (lambda () (string #\i)))
(%%label?308
(lambda (%%x598)
((lambda (%%t599)
(if %%t599
%%t599
((lambda (%%t600)
(if %%t600 %%t600 (%%indirect-label?301 %%x598)))
(symbol? %%x598))))
(string? %%x598))))
(%%gen-labels309
(lambda (%%ls601)
(if (null? %%ls601)
'()
(cons (%%gen-label307) (%%gen-labels309 (cdr %%ls601))))))
(%%make-ribcage310
(lambda (%%symnames602 %%marks603 %%labels604)
(vector 'ribcage %%symnames602 %%marks603 %%labels604)))
(%%ribcage?311
(lambda (%%x605)
(if (vector? %%x605)
(if (= (vector-length %%x605) 4)
(eq? (vector-ref %%x605 0) 'ribcage)
#f)
#f)))
(%%ribcage-symnames312 (lambda (%%x606) (vector-ref %%x606 1)))
(%%ribcage-marks313 (lambda (%%x607) (vector-ref %%x607 2)))
(%%ribcage-labels314 (lambda (%%x608) (vector-ref %%x608 3)))
(%%set-ribcage-symnames!315
(lambda (%%x609 %%update610)
(vector-set! %%x609 1 %%update610)))
(%%set-ribcage-marks!316
(lambda (%%x611 %%update612)
(vector-set! %%x611 2 %%update612)))
(%%set-ribcage-labels!317
(lambda (%%x613 %%update614)
(vector-set! %%x613 3 %%update614)))
(%%make-top-ribcage318
(lambda (%%key615 %%mutable?616)
(vector 'top-ribcage %%key615 %%mutable?616)))
(%%top-ribcage?319
(lambda (%%x617)
(if (vector? %%x617)
(if (= (vector-length %%x617) 3)
(eq? (vector-ref %%x617 0) 'top-ribcage)
#f)
#f)))
(%%top-ribcage-key320 (lambda (%%x618) (vector-ref %%x618 1)))
(%%top-ribcage-mutable?321
(lambda (%%x619) (vector-ref %%x619 2)))
(%%set-top-ribcage-key!322
(lambda (%%x620 %%update621)
(vector-set! %%x620 1 %%update621)))
(%%set-top-ribcage-mutable?!323
(lambda (%%x622 %%update623)
(vector-set! %%x622 2 %%update623)))
(%%make-import-interface324
(lambda (%%interface624 %%new-marks625)
(vector 'import-interface %%interface624 %%new-marks625)))
(%%import-interface?325
(lambda (%%x626)
(if (vector? %%x626)
(if (= (vector-length %%x626) 3)
(eq? (vector-ref %%x626 0) 'import-interface)
#f)
#f)))
(%%import-interface-interface326
(lambda (%%x627) (vector-ref %%x627 1)))
(%%import-interface-new-marks327
(lambda (%%x628) (vector-ref %%x628 2)))
(%%set-import-interface-interface!328
(lambda (%%x629 %%update630)
(vector-set! %%x629 1 %%update630)))
(%%set-import-interface-new-marks!329
(lambda (%%x631 %%update632)
(vector-set! %%x631 2 %%update632)))
(%%make-env330
(lambda (%%top-ribcage633 %%wrap634)
(vector 'env %%top-ribcage633 %%wrap634)))
(%%env?331
(lambda (%%x635)
(if (vector? %%x635)
(if (= (vector-length %%x635) 3)
(eq? (vector-ref %%x635 0) 'env)
#f)
#f)))
(%%env-top-ribcage332 (lambda (%%x636) (vector-ref %%x636 1)))
(%%env-wrap333 (lambda (%%x637) (vector-ref %%x637 2)))
(%%set-env-top-ribcage!334
(lambda (%%x638 %%update639)
(vector-set! %%x638 1 %%update639)))
(%%set-env-wrap!335
(lambda (%%x640 %%update641)
(vector-set! %%x640 2 %%update641)))
(%%anti-mark345
(lambda (%%w642)
(%%make-wrap260
(cons #f (%%wrap-marks261 %%w642))
(cons 'shift (%%wrap-subst262 %%w642)))))
(%%barrier-marker350 #f)
(%%extend-ribcage!355
(lambda (%%ribcage643 %%id644 %%label645)
(begin
(%%set-ribcage-symnames!315
%%ribcage643
(cons ((lambda (%%e646)
(if (annotation? %%e646)
(annotation-expression %%e646)
%%e646))
(%%syntax-object-expression65 %%id644))
(%%ribcage-symnames312 %%ribcage643)))
(%%set-ribcage-marks!316
%%ribcage643
(cons (%%wrap-marks261 (%%syntax-object-wrap66 %%id644))
(%%ribcage-marks313 %%ribcage643)))
(%%set-ribcage-labels!317
%%ribcage643
(cons %%label645 (%%ribcage-labels314 %%ribcage643))))))
(%%import-extend-ribcage!356
(lambda (%%ribcage647 %%new-marks648 %%id649 %%label650)
(begin
(%%set-ribcage-symnames!315
%%ribcage647
(cons ((lambda (%%e651)
(if (annotation? %%e651)
(annotation-expression %%e651)
%%e651))
(%%syntax-object-expression65 %%id649))
(%%ribcage-symnames312 %%ribcage647)))
(%%set-ribcage-marks!316
%%ribcage647
(cons (%%join-marks368
%%new-marks648
(%%wrap-marks261 (%%syntax-object-wrap66 %%id649)))
(%%ribcage-marks313 %%ribcage647)))
(%%set-ribcage-labels!317
%%ribcage647
(cons %%label650 (%%ribcage-labels314 %%ribcage647))))))
(%%extend-ribcage-barrier!357
(lambda (%%ribcage652 %%killer-id653)
(%%extend-ribcage-barrier-help!358
%%ribcage652
(%%syntax-object-wrap66 %%killer-id653))))
(%%extend-ribcage-barrier-help!358
(lambda (%%ribcage654 %%wrap655)
(begin
(%%set-ribcage-symnames!315
%%ribcage654
(cons %%barrier-marker350
(%%ribcage-symnames312 %%ribcage654)))
(%%set-ribcage-marks!316
%%ribcage654
(cons (%%wrap-marks261 %%wrap655)
(%%ribcage-marks313 %%ribcage654))))))
(%%extend-ribcage-subst!359
(lambda (%%ribcage656 %%import-iface657)
(%%set-ribcage-symnames!315
%%ribcage656
(cons %%import-iface657
(%%ribcage-symnames312 %%ribcage656)))))
(%%lookup-import-binding-name360
(lambda (%%sym658 %%marks659 %%token660 %%new-marks661)
((lambda (%%new662)
(if %%new662
((letrec ((%%f663 (lambda (%%new664)
(if (pair? %%new664)
((lambda (%%t665)
(if %%t665
%%t665
(%%f663 (cdr %%new664))))
(%%f663 (car %%new664)))
(if (symbol? %%new664)
(if (%%same-marks?370
%%marks659
(%%join-marks368
%%new-marks661
(%%wrap-marks261
'((top)))))
%%new664
#f)
(if (%%same-marks?370
%%marks659
(%%join-marks368
%%new-marks661
(%%wrap-marks261
(%%syntax-object-wrap66
%%new664))))
%%new664
#f))))))
%%f663)
%%new662)
#f))
(%%get-import-binding76 %%sym658 %%token660))))
(%%store-import-binding361
(lambda (%%id666 %%token667 %%new-marks668)
(letrec ((%%cons-id669
(lambda (%%id671 %%x672)
(if (not %%x672) %%id671 (cons %%id671 %%x672))))
(%%weed670
(lambda (%%marks673 %%x674)
(if (pair? %%x674)
(if (%%same-marks?370
(%%id-marks257 (car %%x674))
%%marks673)
(%%weed670 %%marks673 (cdr %%x674))
(%%cons-id669
(car %%x674)
(%%weed670 %%marks673 (cdr %%x674))))
(if %%x674
(if (not (%%same-marks?370
(%%id-marks257 %%x674)
%%marks673))
%%x674
#f)
#f)))))
((lambda (%%id675)
((lambda (%%sym676)
(if (not (eq? %%id675 %%sym676))
((lambda (%%marks677)
(%%update-import-binding!77
%%sym676
%%token667
(lambda (%%old-binding678)
((lambda (%%x679)
(%%cons-id669
(if (%%same-marks?370
%%marks677
(%%wrap-marks261 '((top))))
(%%resolved-id-var-name365 %%id675)
%%id675)
%%x679))
(%%weed670 %%marks677 %%old-binding678)))))
(%%id-marks257 %%id675))
(void)))
((lambda (%%x680)
((lambda (%%e681)
(if (annotation? %%e681)
(annotation-expression %%e681)
%%e681))
(if (%%syntax-object?64 %%x680)
(%%syntax-object-expression65 %%x680)
%%x680)))
%%id675)))
(if (null? %%new-marks668)
%%id666
(%%make-syntax-object63
((lambda (%%x682)
((lambda (%%e683)
(if (annotation? %%e683)
(annotation-expression %%e683)
%%e683))
(if (%%syntax-object?64 %%x682)
(%%syntax-object-expression65 %%x682)
%%x682)))
%%id666)
(%%make-wrap260
(%%join-marks368
%%new-marks668
(%%id-marks257 %%id666))
(%%id-subst258 %%id666))))))))
(%%make-binding-wrap362
(lambda (%%ids684 %%labels685 %%w686)
(if (null? %%ids684)
%%w686
(%%make-wrap260
(%%wrap-marks261 %%w686)
(cons ((lambda (%%labelvec687)
((lambda (%%n688)
((lambda (%%symnamevec689 %%marksvec690)
(begin
((letrec ((%%f691 (lambda (%%ids692
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%i693)
(if (not (null? %%ids692))
(call-with-values
(lambda ()
(%%id-sym-name&marks259 (car %%ids692) %%w686))
(lambda (%%symname694 %%marks695)
(begin
(vector-set! %%symnamevec689 %%i693 %%symname694)
(vector-set! %%marksvec690 %%i693 %%marks695)
(%%f691 (cdr %%ids692) (fx+ %%i693 1)))))
(void)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f691)
%%ids684
0)
(%%make-ribcage310
%%symnamevec689
%%marksvec690
%%labelvec687)))
(make-vector %%n688)
(make-vector %%n688)))
(vector-length %%labelvec687)))
(list->vector %%labels685))
(%%wrap-subst262 %%w686))))))
(%%make-resolved-id363
(lambda (%%fromsym696 %%marks697 %%tosym698)
(%%make-syntax-object63
%%fromsym696
(%%make-wrap260
%%marks697
(list (%%make-ribcage310
(vector %%fromsym696)
(vector %%marks697)
(vector %%tosym698)))))))
(%%id->resolved-id364
(lambda (%%id699)
(call-with-values
(lambda () (%%id-var-name&marks377 %%id699 '(())))
(lambda (%%tosym700 %%marks701)
(begin
(if (not %%tosym700)
(syntax-error
%%id699
"identifier not visible for export")
(void))
(%%make-resolved-id363
((lambda (%%x702)
((lambda (%%e703)
(if (annotation? %%e703)
(annotation-expression %%e703)
%%e703))
(if (%%syntax-object?64 %%x702)
(%%syntax-object-expression65 %%x702)
%%x702)))
%%id699)
%%marks701
%%tosym700))))))
(%%resolved-id-var-name365
(lambda (%%id704)
(vector-ref
(%%ribcage-labels314
(car (%%wrap-subst262 (%%syntax-object-wrap66 %%id704))))
0)))
(%%smart-append366
(lambda (%%m1705 %%m2706)
(if (null? %%m2706) %%m1705 (append %%m1705 %%m2706))))
(%%join-wraps367
(lambda (%%w1707 %%w2708)
((lambda (%%m1709 %%s1710)
(if (null? %%m1709)
(if (null? %%s1710)
%%w2708
(%%make-wrap260
(%%wrap-marks261 %%w2708)
(%%join-subst369
%%s1710
(%%wrap-subst262 %%w2708))))
(%%make-wrap260
(%%join-marks368 %%m1709 (%%wrap-marks261 %%w2708))
(%%join-subst369 %%s1710 (%%wrap-subst262 %%w2708)))))
(%%wrap-marks261 %%w1707)
(%%wrap-subst262 %%w1707))))
(%%join-marks368
(lambda (%%m1711 %%m2712) (%%smart-append366 %%m1711 %%m2712)))
(%%join-subst369
(lambda (%%s1713 %%s2714) (%%smart-append366 %%s1713 %%s2714)))
(%%same-marks?370
(lambda (%%x715 %%y716)
((lambda (%%t717)
(if %%t717
%%t717
(if (not (null? %%x715))
(if (not (null? %%y716))
(if (eq? (car %%x715) (car %%y716))
(%%same-marks?370
(cdr %%x715)
(cdr %%y716))
#f)
#f)
#f)))
(eq? %%x715 %%y716))))
(%%diff-marks371
(lambda (%%m1718 %%m2719)
((lambda (%%n1720 %%n2721)
((letrec ((%%f722 (lambda (%%n1723 %%m1724)
(if (> %%n1723 %%n2721)
(cons (car %%m1724)
(%%f722 (- %%n1723 1)
(cdr %%m1724)))
(if (equal? %%m1724 %%m2719)
'()
(error "internal error in diff-marks"
%%m1724
%%m2719))))))
%%f722)
%%n1720
%%m1718))
(length %%m1718)
(length %%m2719))))
(%%leave-implicit?372
(lambda (%%token725) (eq? %%token725 '*top*)))
(%%new-binding373
(lambda (%%sym726 %%marks727 %%token728)
((lambda (%%loc729)
((lambda (%%id730)
(begin
(%%store-import-binding361 %%id730 %%token728 '())
(values %%loc729 %%id730)))
(%%make-resolved-id363 %%sym726 %%marks727 %%loc729)))
(if (if (%%leave-implicit?372 %%token728)
(%%same-marks?370
%%marks727
(%%wrap-marks261 '((top))))
#f)
%%sym726
(%%generate-id78 %%sym726)))))
(%%top-id-bound-var-name374
(lambda (%%sym731 %%marks732 %%top-ribcage733)
((lambda (%%token734)
((lambda (%%t735)
(if %%t735
((lambda (%%id736)
(if (symbol? %%id736)
(if (%%read-only-binding?75 %%id736)
(%%new-binding373
%%sym731
%%marks732
%%token734)
(values %%id736
(%%make-resolved-id363
%%sym731
%%marks732
%%id736)))
(values (%%resolved-id-var-name365 %%id736)
%%id736)))
%%t735)
(%%new-binding373 %%sym731 %%marks732 %%token734)))
(%%lookup-import-binding-name360
%%sym731
%%marks732
%%token734
'())))
(%%top-ribcage-key320 %%top-ribcage733))))
(%%top-id-free-var-name375
(lambda (%%sym737 %%marks738 %%top-ribcage739)
((lambda (%%token740)
((lambda (%%t741)
(if %%t741
((lambda (%%id742)
(if (symbol? %%id742)
%%id742
(%%resolved-id-var-name365 %%id742)))
%%t741)
(if (if (%%top-ribcage-mutable?321 %%top-ribcage739)
(%%same-marks?370
%%marks738
(%%wrap-marks261 '((top))))
#f)
(call-with-values
(lambda ()
(%%new-binding373
%%sym737
(%%wrap-marks261 '((top)))
%%token740))
(lambda (%%sym743 %%id744) %%sym743))
#f)))
(%%lookup-import-binding-name360
%%sym737
%%marks738
%%token740
'())))
(%%top-ribcage-key320 %%top-ribcage739))))
(%%id-var-name-loc&marks376
(lambda (%%id745 %%w746)
(letrec ((%%search747
(lambda (%%sym750 %%subst751 %%marks752)
(if (null? %%subst751)
(values #f %%marks752)
((lambda (%%fst753)
(if (eq? %%fst753 'shift)
(%%search747
%%sym750
(cdr %%subst751)
(cdr %%marks752))
(if (%%ribcage?311 %%fst753)
((lambda (%%symnames754)
(if (vector? %%symnames754)
(%%search-vector-rib749
%%sym750
%%subst751
%%marks752
%%symnames754
%%fst753)
(%%search-list-rib748
%%sym750
%%subst751
%%marks752
%%symnames754
%%fst753)))
(%%ribcage-symnames312 %%fst753))
(if (%%top-ribcage?319 %%fst753)
((lambda (%%t755)
(if %%t755
((lambda (%%var-name756)
(values %%var-name756
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%marks752))
%%t755)
(%%search747 %%sym750 (cdr %%subst751) %%marks752)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%top-id-free-var-name375
%%sym750
%%marks752
%%fst753))
(error "internal error in id-var-name-loc&marks: improper subst"
%%subst751)))))
(car %%subst751)))))
(%%search-list-rib748
(lambda (%%sym757
%%subst758
%%marks759
%%symnames760
%%ribcage761)
((letrec ((%%f762 (lambda (%%symnames763 %%i764)
(if (null? %%symnames763)
(%%search747
%%sym757
(cdr %%subst758)
%%marks759)
((lambda (%%x765)
(if (if (eq? %%x765
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%sym757)
(%%same-marks?370
%%marks759
(list-ref (%%ribcage-marks313 %%ribcage761) %%i764))
#f)
(values (list-ref
(%%ribcage-labels314 %%ribcage761)
%%i764)
%%marks759)
(if (%%import-interface?325 %%x765)
((lambda (%%iface766 %%new-marks767)
((lambda (%%t768)
(if %%t768
((lambda (%%token769)
((lambda (%%t770)
(if %%t770
((lambda (%%id771)
(values (if (symbol? %%id771)
%%id771
(%%resolved-id-var-name365
%%id771))
%%marks759))
%%t770)
(%%f762 (cdr %%symnames763)
%%i764)))
(%%lookup-import-binding-name360
%%sym757
%%marks759
%%token769
%%new-marks767)))
%%t768)
((lambda (%%ie772)
((lambda (%%n773)
((lambda ()
((letrec ((%%g774 (lambda (%%j775)
(if (fx= %%j775
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%n773)
(%%f762 (cdr %%symnames763) %%i764)
((lambda (%%id776)
((lambda (%%id.sym777 %%id.marks778)
(if (%%help-bound-id=?382
%%id.sym777
%%id.marks778
%%sym757
%%marks759)
(values (%%lookup-import-label451 %%id776)
%%marks759)
(%%g774 (fx+ %%j775 1))))
((lambda (%%x779)
((lambda (%%e780)
(if (annotation? %%e780)
(annotation-expression %%e780)
%%e780))
(if (%%syntax-object?64 %%x779)
(%%syntax-object-expression65 %%x779)
%%x779)))
%%id776)
(%%join-marks368
%%new-marks767
(%%id-marks257 %%id776))))
(vector-ref %%ie772 %%j775))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%g774)
0))))
(vector-length %%ie772)))
(%%interface-exports399 %%iface766))))
(%%interface-token400 %%iface766)))
(%%import-interface-interface326 %%x765)
(%%import-interface-new-marks327 %%x765))
(if (if (eq? %%x765 %%barrier-marker350)
(%%same-marks?370
%%marks759
(list-ref
(%%ribcage-marks313 %%ribcage761)
%%i764))
#f)
(values #f %%marks759)
(%%f762 (cdr %%symnames763) (fx+ %%i764 1))))))
(car %%symnames763))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f762)
%%symnames760
0)))
(%%search-vector-rib749
(lambda (%%sym781
%%subst782
%%marks783
%%symnames784
%%ribcage785)
((lambda (%%n786)
((letrec ((%%f787 (lambda (%%i788)
(if (fx= %%i788 %%n786)
(%%search747
%%sym781
(cdr %%subst782)
%%marks783)
(if (if (eq? (vector-ref
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%symnames784
%%i788)
%%sym781)
(%%same-marks?370
%%marks783
(vector-ref (%%ribcage-marks313 %%ribcage785) %%i788))
#f)
(values (vector-ref
(%%ribcage-labels314 %%ribcage785)
%%i788)
%%marks783)
(%%f787 (fx+ %%i788 1)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f787)
0))
(vector-length %%symnames784)))))
(if (symbol? %%id745)
(%%search747
%%id745
(%%wrap-subst262 %%w746)
(%%wrap-marks261 %%w746))
(if (%%syntax-object?64 %%id745)
((lambda (%%sym789 %%w1790)
(call-with-values
(lambda ()
(%%search747
%%sym789
(%%wrap-subst262 %%w746)
(%%join-marks368
(%%wrap-marks261 %%w746)
(%%wrap-marks261 %%w1790))))
(lambda (%%name791 %%marks792)
(if %%name791
(values %%name791 %%marks792)
(%%search747
%%sym789
(%%wrap-subst262 %%w1790)
%%marks792)))))
((lambda (%%e793)
(if (annotation? %%e793)
(annotation-expression %%e793)
%%e793))
(%%syntax-object-expression65 %%id745))
(%%syntax-object-wrap66 %%id745))
(if (annotation? %%id745)
(%%search747
((lambda (%%e794)
(if (annotation? %%e794)
(annotation-expression %%e794)
%%e794))
%%id745)
(%%wrap-subst262 %%w746)
(%%wrap-marks261 %%w746))
(error "(in id-var-name) invalid id"
%%id745)))))))
(%%id-var-name&marks377
(lambda (%%id795 %%w796)
(call-with-values
(lambda () (%%id-var-name-loc&marks376 %%id795 %%w796))
(lambda (%%label797 %%marks798)
(values (if (%%indirect-label?301 %%label797)
(%%get-indirect-label305 %%label797)
%%label797)
%%marks798)))))
(%%id-var-name-loc378
(lambda (%%id799 %%w800)
(call-with-values
(lambda () (%%id-var-name-loc&marks376 %%id799 %%w800))
(lambda (%%label801 %%marks802) %%label801))))
(%%id-var-name379
(lambda (%%id803 %%w804)
(call-with-values
(lambda () (%%id-var-name-loc&marks376 %%id803 %%w804))
(lambda (%%label805 %%marks806)
(if (%%indirect-label?301 %%label805)
(%%get-indirect-label305 %%label805)
%%label805)))))
(%%free-id=?380
(lambda (%%i807 %%j808)
(if (eq? ((lambda (%%x809)
((lambda (%%e810)
(if (annotation? %%e810)
(annotation-expression %%e810)
%%e810))
(if (%%syntax-object?64 %%x809)
(%%syntax-object-expression65 %%x809)
%%x809)))
%%i807)
((lambda (%%x811)
((lambda (%%e812)
(if (annotation? %%e812)
(annotation-expression %%e812)
%%e812))
(if (%%syntax-object?64 %%x811)
(%%syntax-object-expression65 %%x811)
%%x811)))
%%j808))
(eq? (%%id-var-name379 %%i807 '(()))
(%%id-var-name379 %%j808 '(())))
#f)))
(%%literal-id=?381
(lambda (%%id813 %%literal814)
(if (eq? ((lambda (%%x815)
((lambda (%%e816)
(if (annotation? %%e816)
(annotation-expression %%e816)
%%e816))
(if (%%syntax-object?64 %%x815)
(%%syntax-object-expression65 %%x815)
%%x815)))
%%id813)
((lambda (%%x817)
((lambda (%%e818)
(if (annotation? %%e818)
(annotation-expression %%e818)
%%e818))
(if (%%syntax-object?64 %%x817)
(%%syntax-object-expression65 %%x817)
%%x817)))
%%literal814))
((lambda (%%n-id819 %%n-literal820)
((lambda (%%t821)
(if %%t821
%%t821
(if ((lambda (%%t822)
(if %%t822 %%t822 (symbol? %%n-id819)))
(not %%n-id819))
((lambda (%%t823)
(if %%t823
%%t823
(symbol? %%n-literal820)))
(not %%n-literal820))
#f)))
(eq? %%n-id819 %%n-literal820)))
(%%id-var-name379 %%id813 '(()))
(%%id-var-name379 %%literal814 '(())))
#f)))
(%%help-bound-id=?382
(lambda (%%i.sym824 %%i.marks825 %%j.sym826 %%j.marks827)
(if (eq? %%i.sym824 %%j.sym826)
(%%same-marks?370 %%i.marks825 %%j.marks827)
#f)))
(%%bound-id=?383
(lambda (%%i828 %%j829)
(%%help-bound-id=?382
((lambda (%%x830)
((lambda (%%e831)
(if (annotation? %%e831)
(annotation-expression %%e831)
%%e831))
(if (%%syntax-object?64 %%x830)
(%%syntax-object-expression65 %%x830)
%%x830)))
%%i828)
(%%id-marks257 %%i828)
((lambda (%%x832)
((lambda (%%e833)
(if (annotation? %%e833)
(annotation-expression %%e833)
%%e833))
(if (%%syntax-object?64 %%x832)
(%%syntax-object-expression65 %%x832)
%%x832)))
%%j829)
(%%id-marks257 %%j829))))
(%%valid-bound-ids?384
(lambda (%%ids834)
(if ((letrec ((%%all-ids?835
(lambda (%%ids836)
((lambda (%%t837)
(if %%t837
%%t837
(if (%%id?251 (car %%ids836))
(%%all-ids?835 (cdr %%ids836))
#f)))
(null? %%ids836)))))
%%all-ids?835)
%%ids834)
(%%distinct-bound-ids?385 %%ids834)
#f)))
(%%distinct-bound-ids?385
(lambda (%%ids838)
((letrec ((%%distinct?839
(lambda (%%ids840)
((lambda (%%t841)
(if %%t841
%%t841
(if (not (%%bound-id-member?387
(car %%ids840)
(cdr %%ids840)))
(%%distinct?839 (cdr %%ids840))
#f)))
(null? %%ids840)))))
%%distinct?839)
%%ids838)))
(%%invalid-ids-error386
(lambda (%%ids842 %%exp843 %%class844)
((letrec ((%%find845
(lambda (%%ids846 %%gooduns847)
(if (null? %%ids846)
(syntax-error %%exp843)
(if (%%id?251 (car %%ids846))
(if (%%bound-id-member?387
(car %%ids846)
%%gooduns847)
(syntax-error
(car %%ids846)
"duplicate "
%%class844)
(%%find845
(cdr %%ids846)
(cons (car %%ids846) %%gooduns847)))
(syntax-error
(car %%ids846)
"invalid "
%%class844))))))
%%find845)
%%ids842
'())))
(%%bound-id-member?387
(lambda (%%x848 %%list849)
(if (not (null? %%list849))
((lambda (%%t850)
(if %%t850
%%t850
(%%bound-id-member?387 %%x848 (cdr %%list849))))
(%%bound-id=?383 %%x848 (car %%list849)))
#f)))
(%%wrap388
(lambda (%%x851 %%w852)
(if (if (null? (%%wrap-marks261 %%w852))
(null? (%%wrap-subst262 %%w852))
#f)
%%x851
(if (%%syntax-object?64 %%x851)
(%%make-syntax-object63
(%%syntax-object-expression65 %%x851)
(%%join-wraps367
%%w852
(%%syntax-object-wrap66 %%x851)))
(if (null? %%x851)
%%x851
(%%make-syntax-object63 %%x851 %%w852))))))
(%%source-wrap389
(lambda (%%x853 %%w854 %%ae855)
(%%wrap388
(if (annotation? %%ae855)
(begin
(if (not (eq? (annotation-expression %%ae855) %%x853))
(error "internal error in source-wrap: ae/x mismatch")
(void))
%%ae855)
%%x853)
%%w854)))
(%%chi-when-list390
(lambda (%%when-list856 %%w857)
(map (lambda (%%x858)
(if (%%literal-id=?381
%%x858
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t))))
'compile
(if (%%literal-id=?381
%%x858
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t))))
'load
(if (%%literal-id=?381
%%x858
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t))))
'visit
(if (%%literal-id=?381
%%x858
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t))))
'revisit
(if (%%literal-id=?381
%%x858
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t))))
'eval
(syntax-error
(%%wrap388 %%x858 %%w857)
"invalid eval-when situation")))))))
%%when-list856)))
(%%syntax-type391
(lambda (%%e859 %%r860 %%w861 %%ae862 %%rib863)
(if (symbol? %%e859)
((lambda (%%n864)
((lambda (%%b865)
((lambda (%%type866)
((lambda ()
((lambda (%%t867)
(if (memv %%t867 '(macro macro!))
(%%syntax-type391
(%%chi-macro447
(%%binding-value227 %%b865)
%%e859
%%r860
%%w861
%%ae862
%%rib863)
%%r860
'(())
#f
%%rib863)
(values %%type866
(%%binding-value227 %%b865)
%%e859
%%w861
%%ae862)))
%%type866))))
(%%binding-type226 %%b865)))
(%%lookup246 %%n864 %%r860)))
(%%id-var-name379 %%e859 %%w861))
(if (pair? %%e859)
((lambda (%%first868)
(if (%%id?251 %%first868)
((lambda (%%n869)
((lambda (%%b870)
((lambda (%%type871)
((lambda ()
((lambda (%%t872)
(if (memv %%t872 '(lexical))
(values 'lexical-call
(%%binding-value227
%%b870)
%%e859
%%w861
%%ae862)
(if (memv %%t872
'(macro macro!))
(%%syntax-type391
(%%chi-macro447
(%%binding-value227
%%b870)
%%e859
%%r860
%%w861
%%ae862
%%rib863)
%%r860
'(())
#f
%%rib863)
(if (memv %%t872
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'(core))
(values %%type871
(%%binding-value227 %%b870)
%%e859
%%w861
%%ae862)
(if (memv %%t872 '(begin))
(values 'begin-form #f %%e859 %%w861 %%ae862)
(if (memv %%t872 '(alias))
(values 'alias-form #f %%e859 %%w861 %%ae862)
(if (memv %%t872 '(define))
(values 'define-form #f %%e859 %%w861 %%ae862)
(if (memv %%t872 '(define-syntax))
(values 'define-syntax-form
#f
%%e859
%%w861
%%ae862)
(if (memv %%t872 '(set!))
(%%chi-set!446
%%e859
%%r860
%%w861
%%ae862
%%rib863)
(if (memv %%t872 '($module-key))
(values '$module-form
#f
%%e859
%%w861
%%ae862)
(if (memv %%t872 '($import))
(values '$import-form
#f
%%e859
%%w861
%%ae862)
(if (memv %%t872 '(eval-when))
(values 'eval-when-form
#f
%%e859
%%w861
%%ae862)
(if (memv %%t872 '(meta))
(values 'meta-form
#f
%%e859
%%w861
%%ae862)
(if (memv %%t872
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'(local-syntax))
(values 'local-syntax-form
(%%binding-value227 %%b870)
%%e859
%%w861
%%ae862)
(values 'call #f %%e859 %%w861 %%ae862)))))))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%type871))))
(%%binding-type226 %%b870)))
(%%lookup246 %%n869 %%r860)))
(%%id-var-name379 %%first868 %%w861))
(values 'call #f %%e859 %%w861 %%ae862)))
(car %%e859))
(if (%%syntax-object?64 %%e859)
(%%syntax-type391
(%%syntax-object-expression65 %%e859)
%%r860
(%%join-wraps367
%%w861
(%%syntax-object-wrap66 %%e859))
#f
%%rib863)
(if (annotation? %%e859)
(%%syntax-type391
(annotation-expression %%e859)
%%r860
%%w861
%%e859
%%rib863)
(if ((lambda (%%x873) (self-eval? %%x873))
%%e859)
(values 'constant
#f
%%e859
%%w861
%%ae862)
(values 'other
#f
%%e859
%%w861
%%ae862))))))))
(%%chi-top*392
(lambda (%%e874
%%r875
%%w876
%%ctem877
%%rtem878
%%meta?879
%%top-ribcage880)
((lambda (%%meta-residuals881)
(letrec ((%%meta-residualize!882
(lambda (%%x883)
(set! %%meta-residuals881
(cons %%x883 %%meta-residuals881)))))
((lambda (%%e884)
(%%build-sequence180
#f
(reverse (cons %%e884 %%meta-residuals881))))
(%%chi-top394
%%e874
%%r875
%%w876
%%ctem877
%%rtem878
%%meta?879
%%top-ribcage880
%%meta-residualize!882
#f))))
'())))
(%%chi-top-sequence393
(lambda (%%body885
%%r886
%%w887
%%ae888
%%ctem889
%%rtem890
%%meta?891
%%ribcage892
%%meta-residualize!893)
(%%build-sequence180
%%ae888
((letrec ((%%dobody894
(lambda (%%body895)
(if (null? %%body895)
'()
((lambda (%%first896)
(cons %%first896
(%%dobody894 (cdr %%body895))))
(%%chi-top394
(car %%body895)
%%r886
%%w887
%%ctem889
%%rtem890
%%meta?891
%%ribcage892
%%meta-residualize!893
#f))))))
%%dobody894)
%%body885))))
(%%chi-top394
(lambda (%%e897
%%r898
%%w899
%%ctem900
%%rtem901
%%meta?902
%%top-ribcage903
%%meta-residualize!904
%%meta-seen?905)
(call-with-values
(lambda ()
(%%syntax-type391
%%e897
%%r898
%%w899
#f
%%top-ribcage903))
(lambda (%%type906 %%value907 %%e908 %%w909 %%ae910)
((lambda (%%t911)
(if (memv %%t911 '(begin-form))
((lambda (%%forms912)
(if (null? %%forms912)
(%%chi-void463)
(%%chi-top-sequence393
%%forms912
%%r898
%%w909
%%ae910
%%ctem900
%%rtem901
%%meta?902
%%top-ribcage903
%%meta-residualize!904)))
(%%parse-begin460 %%e908 %%w909 %%ae910 #t))
(if (memv %%t911 '(local-syntax-form))
(call-with-values
(lambda ()
(%%chi-local-syntax462
%%value907
%%e908
%%r898
%%r898
%%w909
%%ae910))
(lambda (%%forms913
%%r914
%%mr915
%%w916
%%ae917)
(%%chi-top-sequence393
%%forms913
%%r914
%%w916
%%ae917
%%ctem900
%%rtem901
%%meta?902
%%top-ribcage903
%%meta-residualize!904)))
(if (memv %%t911 '(eval-when-form))
(call-with-values
(lambda ()
(%%parse-eval-when458
%%e908
%%w909
%%ae910))
(lambda (%%when-list918 %%forms919)
((lambda (%%ctem920 %%rtem921)
(if (if (null? %%ctem920)
(null? %%rtem921)
#f)
(%%chi-void463)
(%%chi-top-sequence393
%%forms919
%%r898
%%w909
%%ae910
%%ctem920
%%rtem921
%%meta?902
%%top-ribcage903
%%meta-residualize!904)))
(%%update-mode-set435
%%when-list918
%%ctem900)
(%%update-mode-set435
%%when-list918
%%rtem901))))
(if (memv %%t911 '(meta-form))
(%%chi-top394
(%%parse-meta457 %%e908 %%w909 %%ae910)
%%r898
%%w909
%%ctem900
%%rtem901
#t
%%top-ribcage903
%%meta-residualize!904
#t)
(if (memv %%t911 '(define-syntax-form))
(call-with-values
(lambda ()
(%%parse-define-syntax456
%%e908
%%w909
%%ae910))
(lambda (%%id922 %%rhs923 %%w924)
((lambda (%%id925)
(begin
(if (%%displaced-lexical?243
%%id925
%%r898)
(%%displaced-lexical-error244
%%id925)
(void))
(if (not (%%top-ribcage-mutable?321
%%top-ribcage903))
(syntax-error
(%%source-wrap389
%%e908
%%w924
%%ae910)
"invalid definition in read-only environment")
(void))
((lambda (%%sym926)
(call-with-values
(lambda ()
(%%top-id-bound-var-name374
%%sym926
(%%wrap-marks261
(%%syntax-object-wrap66
%%id925))
%%top-ribcage903))
(lambda (%%valsym927
%%bound-id928)
(begin
(if (not (eq? (%%id-var-name379
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%id925
'(()))
%%valsym927))
(syntax-error
(%%source-wrap389 %%e908 %%w924 %%ae910)
"definition not permitted")
(void))
(if (%%read-only-binding?75 %%valsym927)
(syntax-error
(%%source-wrap389 %%e908 %%w924 %%ae910)
"invalid definition of read-only identifier")
(void))
(%%ct-eval/residualize2438
%%ctem900
(lambda ()
(build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source #f %%bound-id928)))
(%%chi443 %%rhs923 %%r898 %%r898 %%w924 #t)
(build-source
#f
(list (build-source #f 'quote)
(%%top-ribcage-key320
%%top-ribcage903)))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%x929)
((lambda (%%e930)
(if (annotation?
%%e930)
(annotation-expression
%%e930)
%%e930))
(if (%%syntax-object?64
%%x929)
(%%syntax-object-expression65
%%x929)
%%x929)))
%%id925))))
(%%wrap388 %%id922 %%w924))))
(if (memv %%t911 '(define-form))
(call-with-values
(lambda ()
(%%parse-define455
%%e908
%%w909
%%ae910))
(lambda (%%id931
%%rhs932
%%w933)
((lambda (%%id934)
(begin
(if (%%displaced-lexical?243
%%id934
%%r898)
(%%displaced-lexical-error244
%%id934)
(void))
(if (not (%%top-ribcage-mutable?321
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%top-ribcage903))
(syntax-error
(%%source-wrap389 %%e908 %%w933 %%ae910)
"invalid definition in read-only environment")
(void))
((lambda (%%sym935)
(call-with-values
(lambda ()
(%%top-id-bound-var-name374
%%sym935
(%%wrap-marks261 (%%syntax-object-wrap66 %%id934))
%%top-ribcage903))
(lambda (%%valsym936 %%bound-id937)
(begin
(if (not (eq? (%%id-var-name379 %%id934 '(()))
%%valsym936))
(syntax-error
(%%source-wrap389 %%e908 %%w933 %%ae910)
"definition not permitted")
(void))
(if (%%read-only-binding?75 %%valsym936)
(syntax-error
(%%source-wrap389 %%e908 %%w933 %%ae910)
"invalid definition of read-only identifier")
(void))
(if %%meta?902
(%%ct-eval/residualize2438
%%ctem900
(lambda ()
(%%build-sequence180
#f
(list (build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source
#f
%%bound-id937)))
((lambda (%%x938)
(if (self-eval?
(cons 'meta-variable
%%valsym936))
%%x938
(build-source
#f
(list (build-source
#f
'quote)
%%x938))))
(attach-source
#f
(cons 'meta-variable
%%valsym936)))
(build-source
#f
(list (build-source #f 'quote)
(%%top-ribcage-key320
%%top-ribcage903)))))
(build-source
%%ae910
(list (build-source %%ae910 'define)
(build-source %%ae910 %%valsym936)
(%%chi443
%%rhs932
%%r898
%%r898
%%w933
#t)))))))
((lambda (%%x939)
(%%build-sequence180
#f
(list %%x939
(%%rt-eval/residualize437
%%rtem901
(lambda ()
(build-source
%%ae910
(list (build-source %%ae910 'define)
(build-source
%%ae910
%%valsym936)
(%%chi443
%%rhs932
%%r898
%%r898
%%w933
#f))))))))
(%%ct-eval/residualize2438
%%ctem900
(lambda ()
(build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source #f %%bound-id937)))
((lambda (%%x940)
(if (self-eval?
(cons 'global %%valsym936))
%%x940
(build-source
#f
(list (build-source #f 'quote)
%%x940))))
(attach-source
#f
(cons 'global %%valsym936)))
(build-source
#f
(list (build-source #f 'quote)
(%%top-ribcage-key320
%%top-ribcage903)))))))))))))
((lambda (%%x941)
((lambda (%%e942)
(if (annotation? %%e942)
(annotation-expression %%e942)
%%e942))
(if (%%syntax-object?64 %%x941)
(%%syntax-object-expression65 %%x941)
%%x941)))
%%id934))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%wrap388
%%id931
%%w933))))
(if (memv %%t911
'($module-form))
((lambda (%%ribcage943)
(call-with-values
(lambda ()
(%%parse-module453
%%e908
%%w909
%%ae910
(%%make-wrap260
(%%wrap-marks261
%%w909)
(cons %%ribcage943
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(%%wrap-subst262 %%w909)))))
(lambda (%%orig944 %%id945 %%exports946 %%forms947)
(begin
(if (%%displaced-lexical?243 %%id945 %%r898)
(%%displaced-lexical-error244
(%%wrap388 %%id945 %%w909))
(void))
(if (not (%%top-ribcage-mutable?321 %%top-ribcage903))
(syntax-error
%%orig944
"invalid definition in read-only environment")
(void))
(%%chi-top-module427
%%orig944
%%r898
%%r898
%%top-ribcage903
%%ribcage943
%%ctem900
%%rtem901
%%meta?902
%%id945
%%exports946
%%forms947
%%meta-residualize!904)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%make-ribcage310
'()
'()
'()))
(if (memv %%t911
'($import-form))
(call-with-values
(lambda ()
(%%parse-import454
%%e908
%%w909
%%ae910))
(lambda (%%orig948
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%only?949
%%mid950)
(begin
(if (not (%%top-ribcage-mutable?321 %%top-ribcage903))
(syntax-error
%%orig948
"invalid definition in read-only environment")
(void))
(%%ct-eval/residualize2438
%%ctem900
(lambda ()
((lambda (%%binding951)
((lambda (%%t952)
(if (memv %%t952 '($module))
(%%do-top-import434
%%only?949
%%top-ribcage903
%%mid950
(%%interface-token400
(%%binding-value227 %%binding951)))
(if (memv %%t952 '(displaced-lexical))
(%%displaced-lexical-error244 %%mid950)
(syntax-error
%%mid950
"unknown module"))))
(%%binding-type226 %%binding951)))
(%%lookup246
(%%id-var-name379 %%mid950 '(()))
'())))))))
(if (memv %%t911 '(alias-form))
(call-with-values
(lambda () (%%parse-alias459 %%e908 %%w909 %%ae910))
(lambda (%%new-id953 %%old-id954)
((lambda (%%new-id955)
(begin
(if (%%displaced-lexical?243 %%new-id955 %%r898)
(%%displaced-lexical-error244 %%new-id955)
(void))
(if (not (%%top-ribcage-mutable?321
%%top-ribcage903))
(syntax-error
(%%source-wrap389 %%e908 %%w909 %%ae910)
"invalid definition in read-only environment")
(void))
((lambda (%%sym956)
(call-with-values
(lambda ()
(%%top-id-bound-var-name374
%%sym956
(%%wrap-marks261
(%%syntax-object-wrap66 %%new-id955))
%%top-ribcage903))
(lambda (%%valsym957 %%bound-id958)
(begin
(if (not (eq? (%%id-var-name379
%%new-id955
'(()))
%%valsym957))
(syntax-error
(%%source-wrap389
%%e908
%%w909
%%ae910)
"definition not permitted")
(void))
(if (%%read-only-binding?75 %%valsym957)
(syntax-error
(%%source-wrap389
%%e908
%%w909
%%ae910)
"invalid definition of read-only identifier")
(void))
(%%ct-eval/residualize2438
%%ctem900
(lambda ()
(build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source
#f
(%%make-resolved-id363
%%sym956
(%%wrap-marks261
(%%syntax-object-wrap66
%%new-id955))
(%%id-var-name379
%%old-id954
%%w909)))))
((lambda (%%x959)
(if (self-eval?
'(do-alias . #f))
%%x959
(build-source
#f
(list (build-source
#f
'quote)
%%x959))))
(attach-source
#f
'(do-alias . #f)))
(build-source
#f
(list (build-source #f 'quote)
(%%top-ribcage-key320
%%top-ribcage903)))))))))))
((lambda (%%x960)
((lambda (%%e961)
(if (annotation? %%e961)
(annotation-expression %%e961)
%%e961))
(if (%%syntax-object?64 %%x960)
(%%syntax-object-expression65 %%x960)
%%x960)))
%%new-id955))))
(%%wrap388 %%new-id953 %%w909))))
(begin
(if %%meta-seen?905
(syntax-error
(%%source-wrap389 %%e908 %%w909 %%ae910)
"invalid meta definition")
(void))
(if %%meta?902
((lambda (%%x962)
(begin
(%%top-level-eval-hook69 %%x962)
(%%ct-eval/residualize3439
%%ctem900
void
(lambda () %%x962))))
(%%chi-expr444
%%type906
%%value907
%%e908
%%r898
%%r898
%%w909
%%ae910
#t))
(%%rt-eval/residualize437
%%rtem901
(lambda ()
(%%chi-expr444
%%type906
%%value907
%%e908
%%r898
%%r898
%%w909
%%ae910
#f)))))))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%type906)))))
(%%flatten-exports395
(lambda (%%exports963)
((letrec ((%%loop964
(lambda (%%exports965 %%ls966)
(if (null? %%exports965)
%%ls966
(%%loop964
(cdr %%exports965)
(if (pair? (car %%exports965))
(%%loop964 (car %%exports965) %%ls966)
(cons (car %%exports965) %%ls966)))))))
%%loop964)
%%exports963
'())))
(%%make-interface396
(lambda (%%marks967 %%exports968 %%token969)
(vector 'interface %%marks967 %%exports968 %%token969)))
(%%interface?397
(lambda (%%x970)
(if (vector? %%x970)
(if (= (vector-length %%x970) 4)
(eq? (vector-ref %%x970 0) 'interface)
#f)
#f)))
(%%interface-marks398 (lambda (%%x971) (vector-ref %%x971 1)))
(%%interface-exports399 (lambda (%%x972) (vector-ref %%x972 2)))
(%%interface-token400 (lambda (%%x973) (vector-ref %%x973 3)))
(%%set-interface-marks!401
(lambda (%%x974 %%update975)
(vector-set! %%x974 1 %%update975)))
(%%set-interface-exports!402
(lambda (%%x976 %%update977)
(vector-set! %%x976 2 %%update977)))
(%%set-interface-token!403
(lambda (%%x978 %%update979)
(vector-set! %%x978 3 %%update979)))
(%%make-unresolved-interface404
(lambda (%%mid980 %%exports981)
(%%make-interface396
(%%wrap-marks261 (%%syntax-object-wrap66 %%mid980))
(list->vector
(map (lambda (%%x982)
(if (pair? %%x982) (car %%x982) %%x982))
%%exports981))
#f)))
(%%make-resolved-interface405
(lambda (%%mid983 %%exports984 %%token985)
(%%make-interface396
(%%wrap-marks261 (%%syntax-object-wrap66 %%mid983))
(list->vector
(map (lambda (%%x986)
(%%id->resolved-id364
(if (pair? %%x986) (car %%x986) %%x986)))
%%exports984))
%%token985)))
(%%make-module-binding406
(lambda (%%type987
%%id988
%%label989
%%imps990
%%val991
%%exported992)
(vector 'module-binding
%%type987
%%id988
%%label989
%%imps990
%%val991
%%exported992)))
(%%module-binding?407
(lambda (%%x993)
(if (vector? %%x993)
(if (= (vector-length %%x993) 7)
(eq? (vector-ref %%x993 0) 'module-binding)
#f)
#f)))
(%%module-binding-type408
(lambda (%%x994) (vector-ref %%x994 1)))
(%%module-binding-id409 (lambda (%%x995) (vector-ref %%x995 2)))
(%%module-binding-label410
(lambda (%%x996) (vector-ref %%x996 3)))
(%%module-binding-imps411
(lambda (%%x997) (vector-ref %%x997 4)))
(%%module-binding-val412 (lambda (%%x998) (vector-ref %%x998 5)))
(%%module-binding-exported413
(lambda (%%x999) (vector-ref %%x999 6)))
(%%set-module-binding-type!414
(lambda (%%x1000 %%update1001)
(vector-set! %%x1000 1 %%update1001)))
(%%set-module-binding-id!415
(lambda (%%x1002 %%update1003)
(vector-set! %%x1002 2 %%update1003)))
(%%set-module-binding-label!416
(lambda (%%x1004 %%update1005)
(vector-set! %%x1004 3 %%update1005)))
(%%set-module-binding-imps!417
(lambda (%%x1006 %%update1007)
(vector-set! %%x1006 4 %%update1007)))
(%%set-module-binding-val!418
(lambda (%%x1008 %%update1009)
(vector-set! %%x1008 5 %%update1009)))
(%%set-module-binding-exported!419
(lambda (%%x1010 %%update1011)
(vector-set! %%x1010 6 %%update1011)))
(%%create-module-binding420
(lambda (%%type1012 %%id1013 %%label1014 %%imps1015 %%val1016)
(%%make-module-binding406
%%type1012
%%id1013
%%label1014
%%imps1015
%%val1016
#f)))
(%%make-frob421
(lambda (%%e1017 %%meta?1018)
(vector 'frob %%e1017 %%meta?1018)))
(%%frob?422
(lambda (%%x1019)
(if (vector? %%x1019)
(if (= (vector-length %%x1019) 3)
(eq? (vector-ref %%x1019 0) 'frob)
#f)
#f)))
(%%frob-e423 (lambda (%%x1020) (vector-ref %%x1020 1)))
(%%frob-meta?424 (lambda (%%x1021) (vector-ref %%x1021 2)))
(%%set-frob-e!425
(lambda (%%x1022 %%update1023)
(vector-set! %%x1022 1 %%update1023)))
(%%set-frob-meta?!426
(lambda (%%x1024 %%update1025)
(vector-set! %%x1024 2 %%update1025)))
(%%chi-top-module427
(lambda (%%orig1026
%%r1027
%%mr1028
%%top-ribcage1029
%%ribcage1030
%%ctem1031
%%rtem1032
%%meta?1033
%%id1034
%%exports1035
%%forms1036
%%meta-residualize!1037)
((lambda (%%fexports1038)
(call-with-values
(lambda ()
(%%chi-external431
%%ribcage1030
%%orig1026
(map (lambda (%%d1039)
(%%make-frob421 %%d1039 %%meta?1033))
%%forms1036)
%%r1027
%%mr1028
%%ctem1031
%%exports1035
%%fexports1038
%%meta-residualize!1037))
(lambda (%%r1040 %%mr1041 %%bindings1042 %%inits1043)
((letrec ((%%process-exports1044
(lambda (%%fexports1045 %%ctdefs1046)
(if (null? %%fexports1045)
((letrec ((%%process-locals1047
(lambda (%%bs1048
%%r1049
%%dts1050
%%dvs1051
%%des1052)
(if (null? %%bs1048)
((lambda (%%des1053
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%inits1054)
(%%build-sequence180
#f
(append (%%ctdefs1046)
(list (%%ct-eval/residualize2438
%%ctem1031
(lambda ()
((lambda (%%sym1055)
((lambda (%%token1056)
((lambda (%%b1057)
((lambda ()
(call-with-values
(lambda ()
(%%top-id-bound-var-name374
%%sym1055
(%%wrap-marks261
(%%syntax-object-wrap66
%%id1034))
%%top-ribcage1029))
(lambda (%%valsym1058
%%bound-id1059)
(begin
(if (not (eq? (%%id-var-name379
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%id1034
'(()))
%%valsym1058))
(syntax-error %%orig1026 "definition not permitted")
(void))
(if (%%read-only-binding?75 %%valsym1058)
(syntax-error
%%orig1026
"invalid definition of read-only identifier")
(void))
(build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source #f %%bound-id1059)))
%%b1057
(build-source
#f
(list (build-source #f 'quote)
(%%top-ribcage-key320 %%top-ribcage1029)))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%x1060)
(if (self-eval?
(cons '$module
(%%make-resolved-interface405
%%id1034
%%exports1035
%%token1056)))
%%x1060
(build-source
#f
(list (build-source
#f
'quote)
%%x1060))))
(attach-source
#f
(cons '$module
(%%make-resolved-interface405
%%id1034
%%exports1035
%%token1056))))))
(%%generate-id78 %%sym1055)))
((lambda (%%x1061)
((lambda (%%e1062)
(if (annotation? %%e1062)
(annotation-expression
%%e1062)
%%e1062))
(if (%%syntax-object?64 %%x1061)
(%%syntax-object-expression65
%%x1061)
%%x1061)))
%%id1034))))
(%%rt-eval/residualize437
%%rtem1032
(lambda ()
(%%build-top-module183
#f
%%dts1050
%%dvs1051
%%des1053
(if (null? %%inits1054)
(%%chi-void463)
(%%build-sequence180
#f
(append %%inits1054
(list (%%chi-void463))))))))))))
(%%chi-frobs440 %%des1052 %%r1049 %%mr1041 #f)
(%%chi-frobs440 %%inits1043 %%r1049 %%mr1041 #f))
((lambda (%%b1063 %%bs1064)
((lambda (%%t1065)
((lambda (%%t1066)
(if (memv %%t1066 '(define-form))
((lambda (%%label1067)
(if (%%module-binding-exported413 %%b1063)
((lambda (%%var1068)
(%%process-locals1047
%%bs1064
%%r1049
(cons 'global %%dts1050)
(cons %%label1067 %%dvs1051)
(cons (%%module-binding-val412
%%b1063)
%%des1052)))
(%%module-binding-id409 %%b1063))
((lambda (%%var1069)
(%%process-locals1047
%%bs1064
(%%extend-env240
%%label1067
(cons 'lexical %%var1069)
%%r1049)
(cons 'local %%dts1050)
(cons %%var1069 %%dvs1051)
(cons (%%module-binding-val412
%%b1063)
%%des1052)))
(%%gen-var468
(%%module-binding-id409 %%b1063)))))
(%%get-indirect-label305
(%%module-binding-label410 %%b1063)))
(if (memv %%t1066
'(ctdefine-form
define-syntax-form
$module-form
alias-form))
(%%process-locals1047
%%bs1064
%%r1049
%%dts1050
%%dvs1051
%%des1052)
(error "unexpected module binding type"
%%t1065))))
(%%module-binding-type408 %%b1063)))
(%%module-binding-type408 %%b1063)))
(car %%bs1048)
(cdr %%bs1048))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%process-locals1047)
%%bindings1042
%%r1040
'()
'()
'())
((lambda (%%id1070 %%fexports1071)
((letrec ((%%loop1072
(lambda (%%bs1073)
(if (null? %%bs1073)
(%%process-exports1044
%%fexports1071
%%ctdefs1046)
((lambda (%%b1074
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%bs1075)
(if (%%free-id=?380
(%%module-binding-id409 %%b1074)
%%id1070)
(if (%%module-binding-exported413 %%b1074)
(%%process-exports1044
%%fexports1071
%%ctdefs1046)
((lambda (%%t1076)
((lambda (%%label1077)
((lambda (%%imps1078)
((lambda (%%fexports1079)
((lambda ()
(begin
(%%set-module-binding-exported!419
%%b1074
#t)
((lambda (%%t1080)
(if (memv %%t1080
'(define-form))
((lambda (%%sym1081)
(begin
(%%set-indirect-label!306
%%label1077
%%sym1081)
(%%process-exports1044
%%fexports1079
%%ctdefs1046)))
(%%generate-id78
((lambda (%%x1082)
((lambda (%%e1083)
(if (annotation?
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e1083)
(annotation-expression %%e1083)
%%e1083))
(if (%%syntax-object?64 %%x1082)
(%%syntax-object-expression65 %%x1082)
%%x1082)))
%%id1070)))
(if (memv %%t1080 '(ctdefine-form))
((lambda (%%b1084)
(%%process-exports1044
%%fexports1079
(lambda ()
((lambda (%%sym1085)
(begin
(%%set-indirect-label!306 %%label1077 %%sym1085)
(cons (%%ct-eval/residualize3439
%%ctem1031
(lambda ()
(%%put-cte-hook72 %%sym1085 %%b1084))
(lambda ()
(build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source
#f
%%sym1085)))
((lambda (%%x1086)
(if (self-eval? %%b1084)
%%x1086
(build-source
#f
(list (build-source
#f
'quote)
%%x1086))))
(attach-source #f %%b1084))
(build-source
#f
(list (build-source #f 'quote)
#f))))))
(%%ctdefs1046))))
(%%binding-value227 %%b1084)))))
(%%module-binding-val412 %%b1074))
(if (memv %%t1080 '(define-syntax-form))
((lambda (%%sym1087)
(%%process-exports1044
%%fexports1079
(lambda ()
((lambda (%%local-label1088)
(begin
(%%set-indirect-label!306
%%label1077
%%sym1087)
(cons (%%ct-eval/residualize3439
%%ctem1031
(lambda ()
(%%put-cte-hook72
%%sym1087
(car (%%module-binding-val412
%%b1074))))
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
%%sym1087)))
(cdr (%%module-binding-val412
%%b1074))
(build-source
#f
(list (build-source
#f
'quote)
#f))))))
(%%ctdefs1046))))
(%%get-indirect-label305 %%label1077)))))
(%%generate-id78
((lambda (%%x1089)
((lambda (%%e1090)
(if (annotation? %%e1090)
(annotation-expression %%e1090)
%%e1090))
(if (%%syntax-object?64 %%x1089)
(%%syntax-object-expression65 %%x1089)
%%x1089)))
%%id1070)))
(if (memv %%t1080 '($module-form))
((lambda (%%sym1091 %%exports1092)
(%%process-exports1044
(append (%%flatten-exports395 %%exports1092)
%%fexports1079)
(lambda ()
(begin
(%%set-indirect-label!306
%%label1077
%%sym1091)
((lambda (%%rest1093)
((lambda (%%x1094)
(cons (%%ct-eval/residualize3439
%%ctem1031
(lambda ()
(%%put-cte-hook72
%%sym1091
%%x1094))
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
(attach-source #f %%sym1091)))
((lambda (%%x1095)
(if (self-eval? %%x1094)
%%x1095
(build-source
#f
(list (build-source #f 'quote) %%x1095))))
(attach-source #f %%x1094))
(build-source #f (list (build-source #f 'quote) #f))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%rest1093))
(cons '$module
(%%make-resolved-interface405
%%id1070
%%exports1092
%%sym1091))))
(%%ctdefs1046))))))
(%%generate-id78
((lambda (%%x1096)
((lambda (%%e1097)
(if (annotation? %%e1097)
(annotation-expression %%e1097)
%%e1097))
(if (%%syntax-object?64 %%x1096)
(%%syntax-object-expression65 %%x1096)
%%x1096)))
%%id1070))
(%%module-binding-val412 %%b1074))
(if (memv %%t1080 '(alias-form))
(%%process-exports1044
%%fexports1079
(lambda ()
((lambda (%%rest1098)
(begin
(if (%%indirect-label?301 %%label1077)
(if (not (symbol? (%%get-indirect-label305
%%label1077)))
(syntax-error
(%%module-binding-id409
%%b1074)
"unexported target of alias")
(void))
(void))
%%rest1098))
(%%ctdefs1046))))
(error "unexpected module binding type"
%%t1076)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%t1076)))))
(append %%imps1078 %%fexports1071)))
(%%module-binding-imps411 %%b1074)))
(%%module-binding-label410 %%b1074)))
(%%module-binding-type408 %%b1074)))
(%%loop1072 %%bs1075)))
(car %%bs1073)
(cdr %%bs1073))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%loop1072)
%%bindings1042))
(car %%fexports1045)
(cdr %%fexports1045))))))
%%process-exports1044)
%%fexports1038
(lambda () '())))))
(%%flatten-exports395 %%exports1035))))
(%%id-set-diff428
(lambda (%%exports1099 %%defs1100)
(if (null? %%exports1099)
'()
(if (%%bound-id-member?387 (car %%exports1099) %%defs1100)
(%%id-set-diff428 (cdr %%exports1099) %%defs1100)
(cons (car %%exports1099)
(%%id-set-diff428
(cdr %%exports1099)
%%defs1100))))))
(%%check-module-exports429
(lambda (%%source-exp1101 %%fexports1102 %%ids1103)
(letrec ((%%defined?1104
(lambda (%%e1105 %%ids1106)
(ormap (lambda (%%x1107)
(if (%%import-interface?325 %%x1107)
((lambda (%%x.iface1108
%%x.new-marks1109)
((lambda (%%t1110)
(if %%t1110
((lambda (%%token1111)
(%%lookup-import-binding-name360
((lambda (%%x1112)
((lambda (%%e1113)
(if (annotation?
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e1113)
(annotation-expression %%e1113)
%%e1113))
(if (%%syntax-object?64 %%x1112)
(%%syntax-object-expression65 %%x1112)
%%x1112)))
%%e1105)
(%%id-marks257 %%e1105)
%%token1111
%%x.new-marks1109))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%t1110)
((lambda (%%v1114)
((letrec ((%%lp1115
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(lambda (%%i1116)
(if (fx>= %%i1116 0)
((lambda (%%t1117)
(if %%t1117
%%t1117
(%%lp1115 (fx- %%i1116 1))))
((lambda (%%id1118)
(%%help-bound-id=?382
((lambda (%%x1119)
((lambda (%%e1120)
(if (annotation? %%e1120)
(annotation-expression %%e1120)
%%e1120))
(if (%%syntax-object?64 %%x1119)
(%%syntax-object-expression65
%%x1119)
%%x1119)))
%%id1118)
(%%join-marks368
%%x.new-marks1109
(%%id-marks257 %%id1118))
((lambda (%%x1121)
((lambda (%%e1122)
(if (annotation? %%e1122)
(annotation-expression %%e1122)
%%e1122))
(if (%%syntax-object?64 %%x1121)
(%%syntax-object-expression65
%%x1121)
%%x1121)))
%%e1105)
(%%id-marks257 %%e1105)))
(vector-ref %%v1114 %%i1116)))
#f))))
%%lp1115)
(fx- (vector-length %%v1114) 1)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%interface-exports399
%%x.iface1108))))
(%%interface-token400
%%x.iface1108)))
(%%import-interface-interface326
%%x1107)
(%%import-interface-new-marks327
%%x1107))
(%%bound-id=?383 %%e1105 %%x1107)))
%%ids1106))))
((letrec ((%%loop1123
(lambda (%%fexports1124 %%missing1125)
(if (null? %%fexports1124)
(if (not (null? %%missing1125))
(syntax-error
(car %%missing1125)
(if (= (length %%missing1125) 1)
"missing definition for export"
"missing definition for multiple exports, including"))
(void))
((lambda (%%e1126 %%fexports1127)
(if (%%defined?1104 %%e1126 %%ids1103)
(%%loop1123
%%fexports1127
%%missing1125)
(%%loop1123
%%fexports1127
(cons %%e1126 %%missing1125))))
(car %%fexports1124)
(cdr %%fexports1124))))))
%%loop1123)
%%fexports1102
'()))))
(%%check-defined-ids430
(lambda (%%source-exp1128 %%ls1129)
(letrec ((%%vfold1130
(lambda (%%v1133 %%p1134 %%cls1135)
((lambda (%%len1136)
((letrec ((%%lp1137
(lambda (%%i1138 %%cls1139)
(if (fx= %%i1138 %%len1136)
%%cls1139
(%%lp1137
(fx+ %%i1138 1)
(%%p1134 (vector-ref
%%v1133
%%i1138)
%%cls1139))))))
%%lp1137)
0
%%cls1135))
(vector-length %%v1133))))
(%%conflicts1131
(lambda (%%x1140 %%y1141 %%cls1142)
(if (%%import-interface?325 %%x1140)
((lambda (%%x.iface1143 %%x.new-marks1144)
(if (%%import-interface?325 %%y1141)
((lambda (%%y.iface1145
%%y.new-marks1146)
((lambda (%%xe1147 %%ye1148)
(if (fx> (vector-length %%xe1147)
(vector-length
%%ye1148))
(%%vfold1130
%%ye1148
(lambda (%%id1149 %%cls1150)
(%%id-iface-conflicts1132
%%id1149
%%y.new-marks1146
%%x.iface1143
%%x.new-marks1144
%%cls1150))
%%cls1142)
(%%vfold1130
%%xe1147
(lambda (%%id1151 %%cls1152)
(%%id-iface-conflicts1132
%%id1151
%%x.new-marks1144
%%y.iface1145
%%y.new-marks1146
%%cls1152))
%%cls1142)))
(%%interface-exports399
%%x.iface1143)
(%%interface-exports399
%%y.iface1145)))
(%%import-interface-interface326
%%y1141)
(%%import-interface-new-marks327
%%y1141))
(%%id-iface-conflicts1132
%%y1141
'()
%%x.iface1143
%%x.new-marks1144
%%cls1142)))
(%%import-interface-interface326 %%x1140)
(%%import-interface-new-marks327 %%x1140))
(if (%%import-interface?325 %%y1141)
((lambda (%%y.iface1153 %%y.new-marks1154)
(%%id-iface-conflicts1132
%%x1140
'()
%%y.iface1153
%%y.new-marks1154
%%cls1142))
(%%import-interface-interface326 %%y1141)
(%%import-interface-new-marks327
%%y1141))
(if (%%bound-id=?383 %%x1140 %%y1141)
(cons %%x1140 %%cls1142)
%%cls1142)))))
(%%id-iface-conflicts1132
(lambda (%%id1155
%%id.new-marks1156
%%iface1157
%%iface.new-marks1158
%%cls1159)
((lambda (%%id.sym1160 %%id.marks1161)
((lambda (%%t1162)
(if %%t1162
((lambda (%%token1163)
(if (%%lookup-import-binding-name360
%%id.sym1160
%%id.marks1161
%%token1163
%%iface.new-marks1158)
(cons %%id1155 %%cls1159)
%%cls1159))
%%t1162)
(%%vfold1130
(%%interface-exports399 %%iface1157)
(lambda (%%*id1164 %%cls1165)
((lambda (%%*id.sym1166
%%*id.marks1167)
(if (%%help-bound-id=?382
%%*id.sym1166
%%*id.marks1167
%%id.sym1160
%%id.marks1161)
(cons %%*id1164 %%cls1165)
%%cls1165))
((lambda (%%x1168)
((lambda (%%e1169)
(if (annotation? %%e1169)
(annotation-expression
%%e1169)
%%e1169))
(if (%%syntax-object?64 %%x1168)
(%%syntax-object-expression65
%%x1168)
%%x1168)))
%%*id1164)
(%%join-marks368
%%iface.new-marks1158
(%%id-marks257 %%*id1164))))
%%cls1159)))
(%%interface-token400 %%iface1157)))
((lambda (%%x1170)
((lambda (%%e1171)
(if (annotation? %%e1171)
(annotation-expression %%e1171)
%%e1171))
(if (%%syntax-object?64 %%x1170)
(%%syntax-object-expression65 %%x1170)
%%x1170)))
%%id1155)
(%%join-marks368
%%id.new-marks1156
(%%id-marks257 %%id1155))))))
(if (not (null? %%ls1129))
((letrec ((%%lp1172
(lambda (%%x1173 %%ls1174 %%cls1175)
(if (null? %%ls1174)
(if (not (null? %%cls1175))
((lambda (%%cls1176)
(syntax-error
%%source-exp1128
"duplicate definition for "
(symbol->string
(car %%cls1176))
" in"))
(syntax-object->datum %%cls1175))
(void))
((letrec ((%%lp21177
(lambda (%%ls21178
%%cls1179)
(if (null? %%ls21178)
(%%lp1172
(car %%ls1174)
(cdr %%ls1174)
%%cls1179)
(%%lp21177
(cdr %%ls21178)
(%%conflicts1131
%%x1173
(car %%ls21178)
%%cls1179))))))
%%lp21177)
%%ls1174
%%cls1175)))))
%%lp1172)
(car %%ls1129)
(cdr %%ls1129)
'())
(void)))))
(%%chi-external431
(lambda (%%ribcage1180
%%source-exp1181
%%body1182
%%r1183
%%mr1184
%%ctem1185
%%exports1186
%%fexports1187
%%meta-residualize!1188)
(letrec ((%%return1189
(lambda (%%r1192
%%mr1193
%%bindings1194
%%ids1195
%%inits1196)
(begin
(%%check-defined-ids430
%%source-exp1181
%%ids1195)
(%%check-module-exports429
%%source-exp1181
%%fexports1187
%%ids1195)
(values %%r1192
%%mr1193
%%bindings1194
%%inits1196))))
(%%get-implicit-exports1190
(lambda (%%id1197)
((letrec ((%%f1198 (lambda (%%exports1199)
(if (null? %%exports1199)
'()
(if (if (pair? (car %%exports1199))
(%%bound-id=?383
%%id1197
(caar %%exports1199))
#f)
(%%flatten-exports395
(cdar %%exports1199))
(%%f1198 (cdr %%exports1199)))))))
%%f1198)
%%exports1186)))
(%%update-imp-exports1191
(lambda (%%bindings1200 %%exports1201)
((lambda (%%exports1202)
(map (lambda (%%b1203)
((lambda (%%id1204)
(if (not (%%bound-id-member?387
%%id1204
%%exports1202))
%%b1203
(%%create-module-binding420
(%%module-binding-type408
%%b1203)
%%id1204
(%%module-binding-label410
%%b1203)
(append (%%get-implicit-exports1190
%%id1204)
(%%module-binding-imps411
%%b1203))
(%%module-binding-val412
%%b1203))))
(%%module-binding-id409 %%b1203)))
%%bindings1200))
(map (lambda (%%x1205)
(if (pair? %%x1205)
(car %%x1205)
%%x1205))
%%exports1201)))))
((letrec ((%%parse1206
(lambda (%%body1207
%%r1208
%%mr1209
%%ids1210
%%bindings1211
%%inits1212
%%meta-seen?1213)
(if (null? %%body1207)
(%%return1189
%%r1208
%%mr1209
%%bindings1211
%%ids1210
%%inits1212)
((lambda (%%fr1214)
((lambda (%%e1215)
((lambda (%%meta?1216)
((lambda ()
(call-with-values
(lambda ()
(%%syntax-type391
%%e1215
%%r1208
'(())
#f
%%ribcage1180))
(lambda (%%type1217
%%value1218
%%e1219
%%w1220
%%ae1221)
((lambda (%%t1222)
(if (memv %%t1222
'(define-form))
(call-with-values
(lambda ()
(%%parse-define455
%%e1219
%%w1220
%%ae1221))
(lambda (%%id1223
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%rhs1224
%%w1225)
((lambda (%%id1226)
((lambda (%%label1227)
((lambda (%%imps1228)
((lambda ()
(begin
(%%extend-ribcage!355
%%ribcage1180
%%id1226
%%label1227)
(if %%meta?1216
((lambda (%%sym1229)
((lambda (%%b1230)
((lambda ()
((lambda (%%mr1231)
((lambda (%%exp1232)
(begin
(%%define-top-level-value-hook71
%%sym1229
(%%top-level-eval-hook69
%%exp1232))
(%%meta-residualize!1188
(%%ct-eval/residualize3439
%%ctem1185
void
(lambda ()
(build-source
#f
(list (build-source
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#f
'define)
(build-source #f %%sym1229)
%%exp1232)))))
(%%parse1206
(cdr %%body1207)
%%r1208
%%mr1231
(cons %%id1226 %%ids1210)
(cons (%%create-module-binding420
'ctdefine-form
%%id1226
%%label1227
%%imps1228
%%b1230)
%%bindings1211)
%%inits1212
#f)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%chi443
%%rhs1224
%%mr1231
%%mr1231
%%w1225
#t)))
(%%extend-env240
(%%get-indirect-label305
%%label1227)
%%b1230
%%mr1209)))))
(cons 'meta-variable %%sym1229)))
(%%generate-id78
((lambda (%%x1233)
((lambda (%%e1234)
(if (annotation? %%e1234)
(annotation-expression
%%e1234)
%%e1234))
(if (%%syntax-object?64 %%x1233)
(%%syntax-object-expression65
%%x1233)
%%x1233)))
%%id1226)))
(%%parse1206
(cdr %%body1207)
%%r1208
%%mr1209
(cons %%id1226 %%ids1210)
(cons (%%create-module-binding420
%%type1217
%%id1226
%%label1227
%%imps1228
(%%make-frob421
(%%wrap388 %%rhs1224 %%w1225)
%%meta?1216))
%%bindings1211)
%%inits1212
#f))))))
(%%get-implicit-exports1190 %%id1226)))
(%%gen-indirect-label304)))
(%%wrap388 %%id1223 %%w1225))))
(if (memv %%t1222 '(define-syntax-form))
(call-with-values
(lambda ()
(%%parse-define-syntax456 %%e1219 %%w1220 %%ae1221))
(lambda (%%id1235 %%rhs1236 %%w1237)
((lambda (%%id1238)
((lambda (%%label1239)
((lambda (%%imps1240)
((lambda (%%exp1241)
((lambda ()
(begin
(%%extend-ribcage!355
%%ribcage1180
%%id1238
%%label1239)
((lambda (%%l1242 %%b1243)
(%%parse1206
(cdr %%body1207)
(%%extend-env240
%%l1242
%%b1243
%%r1208)
(%%extend-env240
%%l1242
%%b1243
%%mr1209)
(cons %%id1238 %%ids1210)
(cons (%%create-module-binding420
%%type1217
%%id1238
%%label1239
%%imps1240
(cons %%b1243 %%exp1241))
%%bindings1211)
%%inits1212
#f))
(%%get-indirect-label305
%%label1239)
(%%defer-or-eval-transformer248
%%top-level-eval-hook69
%%exp1241))))))
(%%chi443
%%rhs1236
%%mr1209
%%mr1209
%%w1237
#t)))
(%%get-implicit-exports1190 %%id1238)))
(%%gen-indirect-label304)))
(%%wrap388 %%id1235 %%w1237))))
(if (memv %%t1222 '($module-form))
((lambda (%%*ribcage1244)
((lambda (%%*w1245)
((lambda ()
(call-with-values
(lambda ()
(%%parse-module453
%%e1219
%%w1220
%%ae1221
%%*w1245))
(lambda (%%orig1246
%%id1247
%%*exports1248
%%forms1249)
(call-with-values
(lambda ()
(%%chi-external431
%%*ribcage1244
%%orig1246
(map (lambda (%%d1250)
(%%make-frob421
%%d1250
%%meta?1216))
%%forms1249)
%%r1208
%%mr1209
%%ctem1185
%%*exports1248
(%%flatten-exports395 %%*exports1248)
%%meta-residualize!1188))
(lambda (%%r1251
%%mr1252
%%*bindings1253
%%*inits1254)
((lambda (%%iface1255
%%bindings1256
%%inits1257
%%label1258
%%imps1259)
(begin
(%%extend-ribcage!355
%%ribcage1180
%%id1247
%%label1258)
((lambda (%%l1260 %%b1261)
(%%parse1206
(cdr %%body1207)
(%%extend-env240
%%l1260
%%b1261
%%r1251)
(%%extend-env240
%%l1260
%%b1261
%%mr1252)
(cons %%id1247 %%ids1210)
(cons (%%create-module-binding420
%%type1217
%%id1247
%%label1258
%%imps1259
%%*exports1248)
%%bindings1256)
%%inits1257
#f))
(%%get-indirect-label305
%%label1258)
(cons '$module %%iface1255))))
(%%make-unresolved-interface404
%%id1247
%%*exports1248)
(append %%*bindings1253
%%bindings1211)
(append %%inits1212 %%*inits1254)
(%%gen-indirect-label304)
(%%get-implicit-exports1190
%%id1247)))))))))
(%%make-wrap260
(%%wrap-marks261 %%w1220)
(cons %%*ribcage1244
(%%wrap-subst262 %%w1220)))))
(%%make-ribcage310 '() '() '()))
(if (memv %%t1222 '($import-form))
(call-with-values
(lambda ()
(%%parse-import454 %%e1219 %%w1220 %%ae1221))
(lambda (%%orig1262 %%only?1263 %%mid1264)
((lambda (%%mlabel1265)
((lambda (%%binding1266)
((lambda (%%t1267)
(if (memv %%t1267 '($module))
((lambda (%%iface1268)
((lambda (%%import-iface1269)
((lambda ()
(begin
(if %%only?1263
(%%extend-ribcage-barrier!357
%%ribcage1180
%%mid1264)
(void))
(%%do-import!452
%%import-iface1269
%%ribcage1180)
(%%parse1206
(cdr %%body1207)
%%r1208
%%mr1209
(cons %%import-iface1269
%%ids1210)
(%%update-imp-exports1191
%%bindings1211
(vector->list
(%%interface-exports399
%%iface1268)))
%%inits1212
#f)))))
(%%make-import-interface324
%%iface1268
(%%import-mark-delta450
%%mid1264
%%iface1268))))
(%%binding-value227
%%binding1266))
(if (memv %%t1267
'(displaced-lexical))
(%%displaced-lexical-error244
%%mid1264)
(syntax-error
%%mid1264
"unknown module"))))
(%%binding-type226 %%binding1266)))
(%%lookup246 %%mlabel1265 %%r1208)))
(%%id-var-name379 %%mid1264 '(())))))
(if (memv %%t1222 '(alias-form))
(call-with-values
(lambda ()
(%%parse-alias459
%%e1219
%%w1220
%%ae1221))
(lambda (%%new-id1270 %%old-id1271)
((lambda (%%new-id1272)
((lambda (%%label1273)
((lambda (%%imps1274)
((lambda ()
(begin
(%%extend-ribcage!355
%%ribcage1180
%%new-id1272
%%label1273)
(%%parse1206
(cdr %%body1207)
%%r1208
%%mr1209
(cons %%new-id1272
%%ids1210)
(cons (%%create-module-binding420
%%type1217
%%new-id1272
%%label1273
%%imps1274
#f)
%%bindings1211)
%%inits1212
#f)))))
(%%get-implicit-exports1190
%%new-id1272)))
(%%id-var-name-loc378
%%old-id1271
%%w1220)))
(%%wrap388 %%new-id1270 %%w1220))))
(if (memv %%t1222 '(begin-form))
(%%parse1206
((letrec ((%%f1275 (lambda (%%forms1276)
(if (null? %%forms1276)
(cdr %%body1207)
(cons (%%make-frob421
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(%%wrap388 (car %%forms1276) %%w1220)
%%meta?1216)
(%%f1275 (cdr %%forms1276)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f1275)
(%%parse-begin460
%%e1219
%%w1220
%%ae1221
#t))
%%r1208
%%mr1209
%%ids1210
%%bindings1211
%%inits1212
#f)
(if (memv %%t1222 '(eval-when-form))
(call-with-values
(lambda ()
(%%parse-eval-when458
%%e1219
%%w1220
%%ae1221))
(lambda (%%when-list1277
%%forms1278)
(%%parse1206
(if (memq 'eval %%when-list1277)
((letrec ((%%f1279 (lambda (%%forms1280)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (null? %%forms1280)
(cdr %%body1207)
(cons (%%make-frob421
(%%wrap388 (car %%forms1280) %%w1220)
%%meta?1216)
(%%f1279 (cdr %%forms1280)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f1279)
%%forms1278)
(cdr %%body1207))
%%r1208
%%mr1209
%%ids1210
%%bindings1211
%%inits1212
#f)))
(if (memv %%t1222 '(meta-form))
(%%parse1206
(cons (%%make-frob421
(%%wrap388
(%%parse-meta457
%%e1219
%%w1220
%%ae1221)
%%w1220)
#t)
(cdr %%body1207))
%%r1208
%%mr1209
%%ids1210
%%bindings1211
%%inits1212
#t)
(if (memv %%t1222
'(local-syntax-form))
(call-with-values
(lambda ()
(%%chi-local-syntax462
%%value1218
%%e1219
%%r1208
%%mr1209
%%w1220
%%ae1221))
(lambda (%%forms1281
%%r1282
%%mr1283
%%w1284
%%ae1285)
(%%parse1206
((letrec ((%%f1286 (lambda (%%forms1287)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (null? %%forms1287)
(cdr %%body1207)
(cons (%%make-frob421
(%%wrap388
(car %%forms1287)
%%w1284)
%%meta?1216)
(%%f1286 (cdr %%forms1287)))))))
%%f1286)
%%forms1281)
%%r1282
%%mr1283
%%ids1210
%%bindings1211
%%inits1212
#f)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(begin
(if %%meta-seen?1213
(syntax-error
(%%source-wrap389
%%e1219
%%w1220
%%ae1221)
"invalid meta definition")
(void))
((letrec ((%%f1288 (lambda (%%body1289)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if ((lambda (%%t1290)
(if %%t1290
%%t1290
(not (%%frob-meta?424
(car %%body1289)))))
(null? %%body1289))
(%%return1189
%%r1208
%%mr1209
%%bindings1211
%%ids1210
(append %%inits1212 %%body1289))
(begin
((lambda (%%x1291)
(begin
(%%top-level-eval-hook69 %%x1291)
(%%meta-residualize!1188
(%%ct-eval/residualize3439
%%ctem1185
void
(lambda () %%x1291)))))
(%%chi-meta-frob441
(car %%body1289)
%%mr1209))
(%%f1288 (cdr %%body1289)))))))
%%f1288)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cons (%%make-frob421
(%%source-wrap389
%%e1219
%%w1220
%%ae1221)
%%meta?1216)
(cdr %%body1207))))))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%type1217))))))
(%%frob-meta?424 %%fr1214)))
(%%frob-e423 %%fr1214)))
(car %%body1207))))))
%%parse1206)
%%body1182
%%r1183
%%mr1184
'()
'()
'()
#f))))
(%%vmap432
(lambda (%%fn1292 %%v1293)
((letrec ((%%do1294
(lambda (%%i1295 %%ls1296)
(if (fx< %%i1295 0)
%%ls1296
(%%do1294
(fx- %%i1295 1)
(cons (%%fn1292
(vector-ref %%v1293 %%i1295))
%%ls1296))))))
%%do1294)
(fx- (vector-length %%v1293) 1)
'())))
(%%vfor-each433
(lambda (%%fn1297 %%v1298)
((lambda (%%len1299)
((letrec ((%%do1300
(lambda (%%i1301)
(if (not (fx= %%i1301 %%len1299))
(begin
(%%fn1297 (vector-ref %%v1298 %%i1301))
(%%do1300 (fx+ %%i1301 1)))
(void)))))
%%do1300)
0))
(vector-length %%v1298))))
(%%do-top-import434
(lambda (%%import-only?1302
%%top-ribcage1303
%%mid1304
%%token1305)
(build-source
#f
(list (build-source #f '$sc-put-cte)
(build-source
#f
(list (build-source #f 'quote)
(attach-source #f %%mid1304)))
((lambda (%%x1306)
(if (self-eval? (cons 'do-import %%token1305))
%%x1306
(build-source
#f
(list (build-source #f 'quote) %%x1306))))
(attach-source #f (cons 'do-import %%token1305)))
(build-source
#f
(list (build-source #f 'quote)
(%%top-ribcage-key320 %%top-ribcage1303)))))))
(%%update-mode-set435
((lambda (%%table1307)
(lambda (%%when-list1308 %%mode-set1309)
(letrec ((%%remq1310
(lambda (%%x1311 %%ls1312)
(if (null? %%ls1312)
'()
(if (eq? (car %%ls1312) %%x1311)
(%%remq1310 %%x1311 (cdr %%ls1312))
(cons (car %%ls1312)
(%%remq1310
%%x1311
(cdr %%ls1312))))))))
(%%remq1310
'-
(apply append
(map (lambda (%%m1313)
((lambda (%%row1314)
(map (lambda (%%s1315)
(cdr (assq %%s1315 %%row1314)))
%%when-list1308))
(cdr (assq %%m1313 %%table1307))))
%%mode-set1309))))))
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
(%%initial-mode-set436
(lambda (%%when-list1316 %%compiling-a-file1317)
(apply append
(map (lambda (%%s1318)
(if %%compiling-a-file1317
((lambda (%%t1319)
(if (memv %%t1319 '(compile))
'(C)
(if (memv %%t1319 '(load))
'(L)
(if (memv %%t1319 '(visit))
'(V)
(if (memv %%t1319 '(revisit))
'(R)
'())))))
%%s1318)
((lambda (%%t1320)
(if (memv %%t1320 '(eval)) '(E) '()))
%%s1318)))
%%when-list1316))))
(%%rt-eval/residualize437
(lambda (%%rtem1321 %%thunk1322)
(if (memq 'E %%rtem1321)
(%%thunk1322)
((lambda (%%thunk1323)
(if (memq 'V %%rtem1321)
(if ((lambda (%%t1324)
(if %%t1324 %%t1324 (memq 'R %%rtem1321)))
(memq 'L %%rtem1321))
(%%thunk1323)
(%%thunk1323))
(if ((lambda (%%t1325)
(if %%t1325 %%t1325 (memq 'R %%rtem1321)))
(memq 'L %%rtem1321))
(%%thunk1323)
(%%chi-void463))))
(if (memq 'C %%rtem1321)
((lambda (%%x1326)
(begin
(%%top-level-eval-hook69 %%x1326)
(lambda () %%x1326)))
(%%thunk1322))
%%thunk1322)))))
(%%ct-eval/residualize2438
(lambda (%%ctem1327 %%thunk1328)
((lambda (%%t1329)
(%%ct-eval/residualize3439
%%ctem1327
(lambda ()
(begin
(if (not %%t1329) (set! %%t1329 (%%thunk1328)) (void))
(%%top-level-eval-hook69 %%t1329)))
(lambda ()
((lambda (%%t1330) (if %%t1330 %%t1330 (%%thunk1328)))
%%t1329))))
#f)))
(%%ct-eval/residualize3439
(lambda (%%ctem1331 %%eval-thunk1332 %%residualize-thunk1333)
(if (memq 'E %%ctem1331)
(begin (%%eval-thunk1332) (%%chi-void463))
(begin
(if (memq 'C %%ctem1331) (%%eval-thunk1332) (void))
(if (memq 'R %%ctem1331)
(if ((lambda (%%t1334)
(if %%t1334 %%t1334 (memq 'V %%ctem1331)))
(memq 'L %%ctem1331))
(%%residualize-thunk1333)
(%%residualize-thunk1333))
(if ((lambda (%%t1335)
(if %%t1335 %%t1335 (memq 'V %%ctem1331)))
(memq 'L %%ctem1331))
(%%residualize-thunk1333)
(%%chi-void463)))))))
(%%chi-frobs440
(lambda (%%frob*1336 %%r1337 %%mr1338 %%m?1339)
(map (lambda (%%x1340)
(%%chi443
(%%frob-e423 %%x1340)
%%r1337
%%mr1338
'(())
%%m?1339))
%%frob*1336)))
(%%chi-meta-frob441
(lambda (%%x1341 %%mr1342)
(%%chi443 (%%frob-e423 %%x1341) %%mr1342 %%mr1342 '(()) #t)))
(%%chi-sequence442
(lambda (%%body1343 %%r1344 %%mr1345 %%w1346 %%ae1347 %%m?1348)
(%%build-sequence180
%%ae1347
((letrec ((%%dobody1349
(lambda (%%body1350)
(if (null? %%body1350)
'()
((lambda (%%first1351)
(cons %%first1351
(%%dobody1349 (cdr %%body1350))))
(%%chi443
(car %%body1350)
%%r1344
%%mr1345
%%w1346
%%m?1348))))))
%%dobody1349)
%%body1343))))
(%%chi443
(lambda (%%e1352 %%r1353 %%mr1354 %%w1355 %%m?1356)
(call-with-values
(lambda () (%%syntax-type391 %%e1352 %%r1353 %%w1355 #f #f))
(lambda (%%type1357 %%value1358 %%e1359 %%w1360 %%ae1361)
(%%chi-expr444
%%type1357
%%value1358
%%e1359
%%r1353
%%mr1354
%%w1360
%%ae1361
%%m?1356)))))
(%%chi-expr444
(lambda (%%type1362
%%value1363
%%e1364
%%r1365
%%mr1366
%%w1367
%%ae1368
%%m?1369)
((lambda (%%t1370)
(if (memv %%t1370 '(lexical))
(build-source %%ae1368 %%value1363)
(if (memv %%t1370 '(core))
(%%value1363
%%e1364
%%r1365
%%mr1366
%%w1367
%%ae1368
%%m?1369)
(if (memv %%t1370 '(lexical-call))
(%%chi-application445
(build-source
((lambda (%%x1371)
(if (%%syntax-object?64 %%x1371)
(%%syntax-object-expression65 %%x1371)
%%x1371))
(car %%e1364))
%%value1363)
%%e1364
%%r1365
%%mr1366
%%w1367
%%ae1368
%%m?1369)
(if (memv %%t1370 '(constant))
((lambda (%%x1372)
(if (self-eval?
(%%strip467
(%%source-wrap389
%%e1364
%%w1367
%%ae1368)
'(())))
%%x1372
(build-source
%%ae1368
(list (build-source
%%ae1368
'quote)
%%x1372))))
(attach-source
%%ae1368
(%%strip467
(%%source-wrap389
%%e1364
%%w1367
%%ae1368)
'(()))))
(if (memv %%t1370 '(global))
(build-source %%ae1368 %%value1363)
(if (memv %%t1370 '(meta-variable))
(if %%m?1369
(build-source
%%ae1368
%%value1363)
(%%displaced-lexical-error244
(%%source-wrap389
%%e1364
%%w1367
%%ae1368)))
(if (memv %%t1370 '(call))
(%%chi-application445
(%%chi443
(car %%e1364)
%%r1365
%%mr1366
%%w1367
%%m?1369)
%%e1364
%%r1365
%%mr1366
%%w1367
%%ae1368
%%m?1369)
(if (memv %%t1370
'(begin-form))
(%%chi-sequence442
(%%parse-begin460
%%e1364
%%w1367
%%ae1368
#f)
%%r1365
%%mr1366
%%w1367
%%ae1368
%%m?1369)
(if (memv %%t1370
'(local-syntax-form))
(call-with-values
(lambda ()
(%%chi-local-syntax462
%%value1363
%%e1364
%%r1365
%%mr1366
%%w1367
%%ae1368))
(lambda (%%forms1373
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%r1374
%%mr1375
%%w1376
%%ae1377)
(%%chi-sequence442
%%forms1373
%%r1374
%%mr1375
%%w1376
%%ae1377
%%m?1369)))
(if (memv %%t1370 '(eval-when-form))
(call-with-values
(lambda ()
(%%parse-eval-when458 %%e1364 %%w1367 %%ae1368))
(lambda (%%when-list1378 %%forms1379)
(if (memq 'eval %%when-list1378)
(%%chi-sequence442
%%forms1379
%%r1365
%%mr1366
%%w1367
%%ae1368
%%m?1369)
(%%chi-void463))))
(if (memv %%t1370 '(meta-form))
(syntax-error
(%%source-wrap389 %%e1364 %%w1367 %%ae1368)
"invalid context for meta definition")
(if (memv %%t1370 '(define-form))
(begin
(%%parse-define455 %%e1364 %%w1367 %%ae1368)
(syntax-error
(%%source-wrap389 %%e1364 %%w1367 %%ae1368)
"invalid context for definition"))
(if (memv %%t1370 '(define-syntax-form))
(begin
(%%parse-define-syntax456
%%e1364
%%w1367
%%ae1368)
(syntax-error
(%%source-wrap389 %%e1364 %%w1367 %%ae1368)
"invalid context for definition"))
(if (memv %%t1370 '($module-form))
(call-with-values
(lambda ()
(%%parse-module453
%%e1364
%%w1367
%%ae1368
%%w1367))
(lambda (%%orig1380
%%id1381
%%exports1382
%%forms1383)
(syntax-error
%%orig1380
"invalid context for definition")))
(if (memv %%t1370 '($import-form))
(call-with-values
(lambda ()
(%%parse-import454
%%e1364
%%w1367
%%ae1368))
(lambda (%%orig1384
%%only?1385
%%mid1386)
(syntax-error
%%orig1384
"invalid context for definition")))
(if (memv %%t1370 '(alias-form))
(begin
(%%parse-alias459
%%e1364
%%w1367
%%ae1368)
(syntax-error
(%%source-wrap389
%%e1364
%%w1367
%%ae1368)
"invalid context for definition"))
(if (memv %%t1370 '(syntax))
(syntax-error
(%%source-wrap389
%%e1364
%%w1367
%%ae1368)
"reference to pattern variable outside syntax form")
(if (memv %%t1370
'(displaced-lexical))
(%%displaced-lexical-error244
(%%source-wrap389
%%e1364
%%w1367
%%ae1368))
(syntax-error
(%%source-wrap389
%%e1364
%%w1367
%%ae1368)))))))))))))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%type1362)))
(%%chi-application445
(lambda (%%x1387
%%e1388
%%r1389
%%mr1390
%%w1391
%%ae1392
%%m?1393)
((lambda (%%tmp1394)
((lambda (%%tmp1395)
(if %%tmp1395
(apply (lambda (%%e01396 %%e11397)
(build-source
%%ae1392
(cons %%x1387
(map (lambda (%%e1398)
(%%chi443
%%e1398
%%r1389
%%mr1390
%%w1391
%%m?1393))
%%e11397))))
%%tmp1395)
((lambda (%%_1400)
(syntax-error
(%%source-wrap389 %%e1388 %%w1391 %%ae1392)))
%%tmp1394)))
($syntax-dispatch %%tmp1394 '(any . each-any))))
%%e1388)))
(%%chi-set!446
(lambda (%%e1401 %%r1402 %%w1403 %%ae1404 %%rib1405)
((lambda (%%tmp1406)
((lambda (%%tmp1407)
(if (if %%tmp1407
(apply (lambda (%%_1408 %%id1409 %%val1410)
(%%id?251 %%id1409))
%%tmp1407)
#f)
(apply (lambda (%%_1411 %%id1412 %%val1413)
((lambda (%%n1414)
((lambda (%%b1415)
((lambda (%%t1416)
(if (memv %%t1416 '(macro!))
((lambda (%%id1417 %%val1418)
(%%syntax-type391
(%%chi-macro447
(%%binding-value227
%%b1415)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%id1417
%%val1418)
%%r1402
'(())
#f
%%rib1405)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%r1402
'(())
#f
%%rib1405))
(%%wrap388 %%id1412 %%w1403)
(%%wrap388
%%val1413
%%w1403))
(values 'core
(lambda (%%e1419
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%r1420
%%mr1421
%%w1422
%%ae1423
%%m?1424)
((lambda (%%val1425 %%n1426)
((lambda (%%b1427)
((lambda (%%t1428)
(if (memv %%t1428 '(lexical))
(build-source
%%ae1423
(list (build-source %%ae1423 'set!)
(build-source
%%ae1423
(%%binding-value227 %%b1427))
%%val1425))
(if (memv %%t1428 '(global))
((lambda (%%sym1429)
(begin
(if (%%read-only-binding?75 %%n1426)
(syntax-error
(%%source-wrap389
%%e1419
%%w1422
%%ae1423)
"invalid assignment to read-only variable")
(void))
(build-source
%%ae1423
(list (build-source %%ae1423 'set!)
(build-source
%%ae1423
%%sym1429)
%%val1425))))
(%%binding-value227 %%b1427))
(if (memv %%t1428 '(meta-variable))
(if %%m?1424
(build-source
%%ae1423
(list (build-source
%%ae1423
'set!)
(build-source
%%ae1423
(%%binding-value227
%%b1427))
%%val1425))
(%%displaced-lexical-error244
(%%wrap388 %%id1412 %%w1422)))
(if (memv %%t1428 '(displaced-lexical))
(%%displaced-lexical-error244
(%%wrap388 %%id1412 %%w1422))
(syntax-error
(%%source-wrap389
%%e1419
%%w1422
%%ae1423)))))))
(%%binding-type226 %%b1427)))
(%%lookup246 %%n1426 %%r1420)))
(%%chi443 %%val1413 %%r1420 %%mr1421 %%w1422 %%m?1424)
(%%id-var-name379 %%id1412 %%w1422)))
%%e1401
%%w1403
%%ae1404)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%binding-type226 %%b1415)))
(%%lookup246 %%n1414 %%r1402)))
(%%id-var-name379 %%id1412 %%w1403)))
%%tmp1407)
((lambda (%%_1430)
(syntax-error
(%%source-wrap389 %%e1401 %%w1403 %%ae1404)))
%%tmp1406)))
($syntax-dispatch %%tmp1406 '(any any any))))
%%e1401)))
(%%chi-macro447
(lambda (%%p1431 %%e1432 %%r1433 %%w1434 %%ae1435 %%rib1436)
(letrec ((%%rebuild-macro-output1437
(lambda (%%x1438 %%m1439)
(if (pair? %%x1438)
(cons (%%rebuild-macro-output1437
(car %%x1438)
%%m1439)
(%%rebuild-macro-output1437
(cdr %%x1438)
%%m1439))
(if (%%syntax-object?64 %%x1438)
((lambda (%%w1440)
((lambda (%%ms1441 %%s1442)
(%%make-syntax-object63
(%%syntax-object-expression65
%%x1438)
(if (if (pair? %%ms1441)
(eq? (car %%ms1441) #f)
#f)
(%%make-wrap260
(cdr %%ms1441)
(cdr %%s1442))
(%%make-wrap260
(cons %%m1439 %%ms1441)
(if %%rib1436
(cons %%rib1436
(cons 'shift
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%s1442))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cons 'shift %%s1442))))))
(%%wrap-marks261 %%w1440)
(%%wrap-subst262 %%w1440)))
(%%syntax-object-wrap66 %%x1438))
(if (vector? %%x1438)
((lambda (%%n1443)
((lambda (%%v1444)
((lambda ()
((letrec ((%%do1445
(lambda (%%i1446)
(if (fx= %%i1446
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%n1443)
%%v1444
(begin
(vector-set!
%%v1444
%%i1446
(%%rebuild-macro-output1437
(vector-ref %%x1438 %%i1446)
%%m1439))
(%%do1445 (fx+ %%i1446 1)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%do1445)
0))))
(make-vector %%n1443)))
(vector-length %%x1438))
(if (symbol? %%x1438)
(syntax-error
(%%source-wrap389
%%e1432
%%w1434
%%ae1435)
"encountered raw symbol "
(symbol->string %%x1438)
" in output of macro")
%%x1438)))))))
(%%rebuild-macro-output1437
((lambda (%%out1447)
(if (procedure? %%out1447)
(%%out1447
(lambda (%%id1448)
(begin
(if (not (identifier? %%id1448))
(syntax-error
%%id1448
"environment argument is not an identifier")
(void))
(%%lookup246
(%%id-var-name379 %%id1448 '(()))
%%r1433))))
%%out1447))
(%%p1431 (%%source-wrap389
%%e1432
(%%anti-mark345 %%w1434)
%%ae1435)))
(string #\m)))))
(%%chi-body448
(lambda (%%body1449
%%outer-form1450
%%r1451
%%mr1452
%%w1453
%%m?1454)
((lambda (%%ribcage1455)
((lambda (%%w1456)
((lambda (%%body1457)
((lambda ()
(call-with-values
(lambda ()
(%%chi-internal449
%%ribcage1455
%%outer-form1450
%%body1457
%%r1451
%%mr1452
%%m?1454))
(lambda (%%r1458
%%mr1459
%%exprs1460
%%ids1461
%%vars1462
%%vals1463
%%inits1464)
(begin
(if (null? %%exprs1460)
(syntax-error
%%outer-form1450
"no expressions in body")
(void))
(%%build-body182
#f
(reverse %%vars1462)
(%%chi-frobs440
(reverse %%vals1463)
%%r1458
%%mr1459
%%m?1454)
(%%build-sequence180
#f
(%%chi-frobs440
(append %%inits1464 %%exprs1460)
%%r1458
%%mr1459
%%m?1454)))))))))
(map (lambda (%%x1465)
(%%make-frob421 (%%wrap388 %%x1465 %%w1456) #f))
%%body1449)))
(%%make-wrap260
(%%wrap-marks261 %%w1453)
(cons %%ribcage1455 (%%wrap-subst262 %%w1453)))))
(%%make-ribcage310 '() '() '()))))
(%%chi-internal449
(lambda (%%ribcage1466
%%source-exp1467
%%body1468
%%r1469
%%mr1470
%%m?1471)
(letrec ((%%return1472
(lambda (%%r1473
%%mr1474
%%exprs1475
%%ids1476
%%vars1477
%%vals1478
%%inits1479)
(begin
(%%check-defined-ids430
%%source-exp1467
%%ids1476)
(values %%r1473
%%mr1474
%%exprs1475
%%ids1476
%%vars1477
%%vals1478
%%inits1479)))))
((letrec ((%%parse1480
(lambda (%%body1481
%%r1482
%%mr1483
%%ids1484
%%vars1485
%%vals1486
%%inits1487
%%meta-seen?1488)
(if (null? %%body1481)
(%%return1472
%%r1482
%%mr1483
%%body1481
%%ids1484
%%vars1485
%%vals1486
%%inits1487)
((lambda (%%fr1489)
((lambda (%%e1490)
((lambda (%%meta?1491)
((lambda ()
(call-with-values
(lambda ()
(%%syntax-type391
%%e1490
%%r1482
'(())
#f
%%ribcage1466))
(lambda (%%type1492
%%value1493
%%e1494
%%w1495
%%ae1496)
((lambda (%%t1497)
(if (memv %%t1497
'(define-form))
(call-with-values
(lambda ()
(%%parse-define455
%%e1494
%%w1495
%%ae1496))
(lambda (%%id1498
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%rhs1499
%%w1500)
((lambda (%%id1501 %%label1502)
(if %%meta?1491
((lambda (%%sym1503)
(begin
(%%extend-ribcage!355
%%ribcage1466
%%id1501
%%label1502)
((lambda (%%mr1504)
(begin
(%%define-top-level-value-hook71
%%sym1503
(%%top-level-eval-hook69
(%%chi443
%%rhs1499
%%mr1504
%%mr1504
%%w1500
#t)))
(%%parse1480
(cdr %%body1481)
%%r1482
%%mr1504
(cons %%id1501 %%ids1484)
%%vars1485
%%vals1486
%%inits1487
#f)))
(%%extend-env240
%%label1502
(cons 'meta-variable %%sym1503)
%%mr1483))))
(%%generate-id78
((lambda (%%x1505)
((lambda (%%e1506)
(if (annotation? %%e1506)
(annotation-expression %%e1506)
%%e1506))
(if (%%syntax-object?64 %%x1505)
(%%syntax-object-expression65 %%x1505)
%%x1505)))
%%id1501)))
((lambda (%%var1507)
(begin
(%%extend-ribcage!355
%%ribcage1466
%%id1501
%%label1502)
(%%parse1480
(cdr %%body1481)
(%%extend-env240
%%label1502
(cons 'lexical %%var1507)
%%r1482)
%%mr1483
(cons %%id1501 %%ids1484)
(cons %%var1507 %%vars1485)
(cons (%%make-frob421
(%%wrap388 %%rhs1499 %%w1500)
%%meta?1491)
%%vals1486)
%%inits1487
#f)))
(%%gen-var468 %%id1501))))
(%%wrap388 %%id1498 %%w1500)
(%%gen-label307))))
(if (memv %%t1497 '(define-syntax-form))
(call-with-values
(lambda ()
(%%parse-define-syntax456 %%e1494 %%w1495 %%ae1496))
(lambda (%%id1508 %%rhs1509 %%w1510)
((lambda (%%id1511 %%label1512 %%exp1513)
(begin
(%%extend-ribcage!355
%%ribcage1466
%%id1511
%%label1512)
((lambda (%%b1514)
(%%parse1480
(cdr %%body1481)
(%%extend-env240 %%label1512 %%b1514 %%r1482)
(%%extend-env240
%%label1512
%%b1514
%%mr1483)
(cons %%id1511 %%ids1484)
%%vars1485
%%vals1486
%%inits1487
#f))
(%%defer-or-eval-transformer248
%%local-eval-hook70
%%exp1513))))
(%%wrap388 %%id1508 %%w1510)
(%%gen-label307)
(%%chi443 %%rhs1509 %%mr1483 %%mr1483 %%w1510 #t))))
(if (memv %%t1497 '($module-form))
((lambda (%%*ribcage1515)
((lambda (%%*w1516)
((lambda ()
(call-with-values
(lambda ()
(%%parse-module453
%%e1494
%%w1495
%%ae1496
%%*w1516))
(lambda (%%orig1517
%%id1518
%%exports1519
%%forms1520)
(call-with-values
(lambda ()
(%%chi-internal449
%%*ribcage1515
%%orig1517
(map (lambda (%%d1521)
(%%make-frob421
%%d1521
%%meta?1491))
%%forms1520)
%%r1482
%%mr1483
%%m?1471))
(lambda (%%r1522
%%mr1523
%%*body1524
%%*ids1525
%%*vars1526
%%*vals1527
%%*inits1528)
(begin
(%%check-module-exports429
%%source-exp1467
(%%flatten-exports395
%%exports1519)
%%*ids1525)
((lambda (%%iface1529
%%vars1530
%%vals1531
%%inits1532
%%label1533)
(begin
(%%extend-ribcage!355
%%ribcage1466
%%id1518
%%label1533)
((lambda (%%b1534)
(%%parse1480
(cdr %%body1481)
(%%extend-env240
%%label1533
%%b1534
%%r1522)
(%%extend-env240
%%label1533
%%b1534
%%mr1523)
(cons %%id1518 %%ids1484)
%%vars1530
%%vals1531
%%inits1532
#f))
(cons '$module %%iface1529))))
(%%make-resolved-interface405
%%id1518
%%exports1519
#f)
(append %%*vars1526 %%vars1485)
(append %%*vals1527 %%vals1486)
(append %%inits1487
%%*inits1528
%%*body1524)
(%%gen-label307))))))))))
(%%make-wrap260
(%%wrap-marks261 %%w1495)
(cons %%*ribcage1515
(%%wrap-subst262 %%w1495)))))
(%%make-ribcage310 '() '() '()))
(if (memv %%t1497 '($import-form))
(call-with-values
(lambda ()
(%%parse-import454 %%e1494 %%w1495 %%ae1496))
(lambda (%%orig1535 %%only?1536 %%mid1537)
((lambda (%%mlabel1538)
((lambda (%%binding1539)
((lambda (%%t1540)
(if (memv %%t1540 '($module))
((lambda (%%iface1541)
((lambda (%%import-iface1542)
((lambda ()
(begin
(if %%only?1536
(%%extend-ribcage-barrier!357
%%ribcage1466
%%mid1537)
(void))
(%%do-import!452
%%import-iface1542
%%ribcage1466)
(%%parse1480
(cdr %%body1481)
%%r1482
%%mr1483
(cons %%import-iface1542
%%ids1484)
%%vars1485
%%vals1486
%%inits1487
#f)))))
(%%make-import-interface324
%%iface1541
(%%import-mark-delta450
%%mid1537
%%iface1541))))
(%%binding-value227
%%binding1539))
(if (memv %%t1540
'(displaced-lexical))
(%%displaced-lexical-error244
%%mid1537)
(syntax-error
%%mid1537
"unknown module"))))
(%%binding-type226 %%binding1539)))
(%%lookup246 %%mlabel1538 %%r1482)))
(%%id-var-name379 %%mid1537 '(())))))
(if (memv %%t1497 '(alias-form))
(call-with-values
(lambda ()
(%%parse-alias459
%%e1494
%%w1495
%%ae1496))
(lambda (%%new-id1543 %%old-id1544)
((lambda (%%new-id1545)
(begin
(%%extend-ribcage!355
%%ribcage1466
%%new-id1545
(%%id-var-name-loc378
%%old-id1544
%%w1495))
(%%parse1480
(cdr %%body1481)
%%r1482
%%mr1483
(cons %%new-id1545 %%ids1484)
%%vars1485
%%vals1486
%%inits1487
#f)))
(%%wrap388 %%new-id1543 %%w1495))))
(if (memv %%t1497 '(begin-form))
(%%parse1480
((letrec ((%%f1546 (lambda (%%forms1547)
(if (null? %%forms1547)
(cdr %%body1481)
(cons (%%make-frob421
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(%%wrap388 (car %%forms1547) %%w1495)
%%meta?1491)
(%%f1546 (cdr %%forms1547)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f1546)
(%%parse-begin460
%%e1494
%%w1495
%%ae1496
#t))
%%r1482
%%mr1483
%%ids1484
%%vars1485
%%vals1486
%%inits1487
#f)
(if (memv %%t1497 '(eval-when-form))
(call-with-values
(lambda ()
(%%parse-eval-when458
%%e1494
%%w1495
%%ae1496))
(lambda (%%when-list1548
%%forms1549)
(%%parse1480
(if (memq 'eval %%when-list1548)
((letrec ((%%f1550 (lambda (%%forms1551)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (null? %%forms1551)
(cdr %%body1481)
(cons (%%make-frob421
(%%wrap388 (car %%forms1551) %%w1495)
%%meta?1491)
(%%f1550 (cdr %%forms1551)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f1550)
%%forms1549)
(cdr %%body1481))
%%r1482
%%mr1483
%%ids1484
%%vars1485
%%vals1486
%%inits1487
#f)))
(if (memv %%t1497 '(meta-form))
(%%parse1480
(cons (%%make-frob421
(%%wrap388
(%%parse-meta457
%%e1494
%%w1495
%%ae1496)
%%w1495)
#t)
(cdr %%body1481))
%%r1482
%%mr1483
%%ids1484
%%vars1485
%%vals1486
%%inits1487
#t)
(if (memv %%t1497
'(local-syntax-form))
(call-with-values
(lambda ()
(%%chi-local-syntax462
%%value1493
%%e1494
%%r1482
%%mr1483
%%w1495
%%ae1496))
(lambda (%%forms1552
%%r1553
%%mr1554
%%w1555
%%ae1556)
(%%parse1480
((letrec ((%%f1557 (lambda (%%forms1558)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (null? %%forms1558)
(cdr %%body1481)
(cons (%%make-frob421
(%%wrap388
(car %%forms1558)
%%w1555)
%%meta?1491)
(%%f1557 (cdr %%forms1558)))))))
%%f1557)
%%forms1552)
%%r1553
%%mr1554
%%ids1484
%%vars1485
%%vals1486
%%inits1487
#f)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(begin
(if %%meta-seen?1488
(syntax-error
(%%source-wrap389
%%e1494
%%w1495
%%ae1496)
"invalid meta definition")
(void))
((letrec ((%%f1559 (lambda (%%body1560)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if ((lambda (%%t1561)
(if %%t1561
%%t1561
(not (%%frob-meta?424
(car %%body1560)))))
(null? %%body1560))
(%%return1472
%%r1482
%%mr1483
%%body1560
%%ids1484
%%vars1485
%%vals1486
%%inits1487)
(begin
(%%top-level-eval-hook69
(%%chi-meta-frob441
(car %%body1560)
%%mr1483))
(%%f1559 (cdr %%body1560)))))))
%%f1559)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cons (%%make-frob421
(%%source-wrap389
%%e1494
%%w1495
%%ae1496)
%%meta?1491)
(cdr %%body1481))))))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%type1492))))))
(%%frob-meta?424 %%fr1489)))
(%%frob-e423 %%fr1489)))
(car %%body1481))))))
%%parse1480)
%%body1468
%%r1469
%%mr1470
'()
'()
'()
'()
#f))))
(%%import-mark-delta450
(lambda (%%mid1562 %%iface1563)
(%%diff-marks371
(%%id-marks257 %%mid1562)
(%%interface-marks398 %%iface1563))))
(%%lookup-import-label451
(lambda (%%id1564)
((lambda (%%label1565)
(begin
(if (not %%label1565)
(syntax-error
%%id1564
"exported identifier not visible")
(void))
%%label1565))
(%%id-var-name-loc378 %%id1564 '(())))))
(%%do-import!452
(lambda (%%import-iface1566 %%ribcage1567)
((lambda (%%ie1568)
(if (<= (vector-length %%ie1568) 20)
((lambda (%%new-marks1569)
(%%vfor-each433
(lambda (%%id1570)
(%%import-extend-ribcage!356
%%ribcage1567
%%new-marks1569
%%id1570
(%%lookup-import-label451 %%id1570)))
%%ie1568))
(%%import-interface-new-marks327 %%import-iface1566))
(%%extend-ribcage-subst!359
%%ribcage1567
%%import-iface1566)))
(%%interface-exports399
(%%import-interface-interface326 %%import-iface1566)))))
(%%parse-module453
(lambda (%%e1571 %%w1572 %%ae1573 %%*w1574)
(letrec ((%%listify1575
(lambda (%%exports1576)
(if (null? %%exports1576)
'()
(cons ((lambda (%%tmp1577)
((lambda (%%tmp1578)
(if %%tmp1578
(apply (lambda (%%ex1579)
(%%listify1575
%%ex1579))
%%tmp1578)
((lambda (%%x1581)
(if (%%id?251 %%x1581)
(%%wrap388
%%x1581
%%*w1574)
(syntax-error
(%%source-wrap389
%%e1571
%%w1572
%%ae1573)
"invalid exports list in")))
%%tmp1577)))
($syntax-dispatch
%%tmp1577
'each-any)))
(car %%exports1576))
(%%listify1575 (cdr %%exports1576)))))))
((lambda (%%tmp1582)
((lambda (%%tmp1583)
(if (if %%tmp1583
(apply (lambda (%%_1584
%%orig1585
%%mid1586
%%ex1587
%%form1588)
(%%id?251 %%mid1586))
%%tmp1583)
#f)
(apply (lambda (%%_1589
%%orig1590
%%mid1591
%%ex1592
%%form1593)
(values %%orig1590
(%%wrap388 %%mid1591 %%w1572)
(%%listify1575 %%ex1592)
(map (lambda (%%x1595)
(%%wrap388
%%x1595
%%*w1574))
%%form1593)))
%%tmp1583)
((lambda (%%_1597)
(syntax-error
(%%source-wrap389 %%e1571 %%w1572 %%ae1573)))
%%tmp1582)))
($syntax-dispatch
%%tmp1582
'(any any any each-any . each-any))))
%%e1571))))
(%%parse-import454
(lambda (%%e1598 %%w1599 %%ae1600)
((lambda (%%tmp1601)
((lambda (%%tmp1602)
(if (if %%tmp1602
(apply (lambda (%%_1603 %%orig1604 %%mid1605)
(%%id?251 %%mid1605))
%%tmp1602)
#f)
(apply (lambda (%%_1606 %%orig1607 %%mid1608)
(values %%orig1607
#t
(%%wrap388 %%mid1608 %%w1599)))
%%tmp1602)
((lambda (%%tmp1609)
(if (if %%tmp1609
(apply (lambda (%%_1610
%%orig1611
%%mid1612)
(%%id?251 %%mid1612))
%%tmp1609)
#f)
(apply (lambda (%%_1613 %%orig1614 %%mid1615)
(values %%orig1614
#f
(%%wrap388
%%mid1615
%%w1599)))
%%tmp1609)
((lambda (%%_1616)
(syntax-error
(%%source-wrap389
%%e1598
%%w1599
%%ae1600)))
%%tmp1601)))
($syntax-dispatch
%%tmp1601
'(any any #(atom #f) any)))))
($syntax-dispatch %%tmp1601 '(any any #(atom #t) any))))
%%e1598)))
(%%parse-define455
(lambda (%%e1617 %%w1618 %%ae1619)
((lambda (%%tmp1620)
((lambda (%%tmp1621)
(if (if %%tmp1621
(apply (lambda (%%_1622 %%name1623 %%val1624)
(%%id?251 %%name1623))
%%tmp1621)
#f)
(apply (lambda (%%_1625 %%name1626 %%val1627)
(values %%name1626 %%val1627 %%w1618))
%%tmp1621)
((lambda (%%tmp1628)
(if (if %%tmp1628
(apply (lambda (%%_1629
%%name1630
%%args1631
%%e11632
%%e21633)
(if (%%id?251 %%name1630)
(%%valid-bound-ids?384
(%%lambda-var-list469
%%args1631))
#f))
%%tmp1628)
#f)
(apply (lambda (%%_1634
%%name1635
%%args1636
%%e11637
%%e21638)
(values (%%wrap388
%%name1635
%%w1618)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
(%%wrap388
(cons %%args1636 (cons %%e11637 %%e21638))
%%w1618))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
'(())))
%%tmp1628)
((lambda (%%tmp1640)
(if (if %%tmp1640
(apply (lambda (%%_1641
%%name1642)
(%%id?251 %%name1642))
%%tmp1640)
#f)
(apply (lambda (%%_1643 %%name1644)
(values (%%wrap388
%%name1644
%%w1618)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
'(())))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp1640)
((lambda (%%_1645)
(syntax-error
(%%source-wrap389
%%e1617
%%w1618
%%ae1619)))
%%tmp1620)))
($syntax-dispatch %%tmp1620 '(any any)))))
($syntax-dispatch
%%tmp1620
'(any (any . any) any . each-any)))))
($syntax-dispatch %%tmp1620 '(any any any))))
%%e1617)))
(%%parse-define-syntax456
(lambda (%%e1646 %%w1647 %%ae1648)
((lambda (%%tmp1649)
((lambda (%%tmp1650)
(if (if %%tmp1650
(apply (lambda (%%_1651
%%name1652
%%id1653
%%e11654
%%e21655)
(if (%%id?251 %%name1652)
(%%id?251 %%id1653)
#f))
%%tmp1650)
#f)
(apply (lambda (%%_1656
%%name1657
%%id1658
%%e11659
%%e21660)
(values (%%wrap388 %%name1657 %%w1647)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
(cons (%%wrap388
(list %%id1658)
%%w1647)
(%%wrap388
(cons %%e11659
%%e21660)
%%w1647)))
'(())))
%%tmp1650)
((lambda (%%tmp1662)
(if (if %%tmp1662
(apply (lambda (%%_1663
%%name1664
%%val1665)
(%%id?251 %%name1664))
%%tmp1662)
#f)
(apply (lambda (%%_1666 %%name1667 %%val1668)
(values %%name1667
%%val1668
%%w1647))
%%tmp1662)
((lambda (%%_1669)
(syntax-error
(%%source-wrap389
%%e1646
%%w1647
%%ae1648)))
%%tmp1649)))
($syntax-dispatch %%tmp1649 '(any any any)))))
($syntax-dispatch
%%tmp1649
'(any (any any) any . each-any))))
%%e1646)))
(%%parse-meta457
(lambda (%%e1670 %%w1671 %%ae1672)
((lambda (%%tmp1673)
((lambda (%%tmp1674)
(if %%tmp1674
(apply (lambda (%%_1675 %%form1676) %%form1676)
%%tmp1674)
((lambda (%%_1677)
(syntax-error
(%%source-wrap389 %%e1670 %%w1671 %%ae1672)))
%%tmp1673)))
($syntax-dispatch %%tmp1673 '(any . any))))
%%e1670)))
(%%parse-eval-when458
(lambda (%%e1678 %%w1679 %%ae1680)
((lambda (%%tmp1681)
((lambda (%%tmp1682)
(if %%tmp1682
(apply (lambda (%%_1683 %%x1684 %%e11685 %%e21686)
(values (%%chi-when-list390
%%x1684
%%w1679)
(cons %%e11685 %%e21686)))
%%tmp1682)
((lambda (%%_1689)
(syntax-error
(%%source-wrap389 %%e1678 %%w1679 %%ae1680)))
%%tmp1681)))
($syntax-dispatch
%%tmp1681
'(any each-any any . each-any))))
%%e1678)))
(%%parse-alias459
(lambda (%%e1690 %%w1691 %%ae1692)
((lambda (%%tmp1693)
((lambda (%%tmp1694)
(if (if %%tmp1694
(apply (lambda (%%_1695
%%new-id1696
%%old-id1697)
(if (%%id?251 %%new-id1696)
(%%id?251 %%old-id1697)
#f))
%%tmp1694)
#f)
(apply (lambda (%%_1698 %%new-id1699 %%old-id1700)
(values %%new-id1699 %%old-id1700))
%%tmp1694)
((lambda (%%_1701)
(syntax-error
(%%source-wrap389 %%e1690 %%w1691 %%ae1692)))
%%tmp1693)))
($syntax-dispatch %%tmp1693 '(any any any))))
%%e1690)))
(%%parse-begin460
(lambda (%%e1702 %%w1703 %%ae1704 %%empty-okay?1705)
((lambda (%%tmp1706)
((lambda (%%tmp1707)
(if (if %%tmp1707
(apply (lambda (%%_1708) %%empty-okay?1705)
%%tmp1707)
#f)
(apply (lambda (%%_1709) '()) %%tmp1707)
((lambda (%%tmp1710)
(if %%tmp1710
(apply (lambda (%%_1711 %%e11712 %%e21713)
(cons %%e11712 %%e21713))
%%tmp1710)
((lambda (%%_1715)
(syntax-error
(%%source-wrap389
%%e1702
%%w1703
%%ae1704)))
%%tmp1706)))
($syntax-dispatch
%%tmp1706
'(any any . each-any)))))
($syntax-dispatch %%tmp1706 '(any))))
%%e1702)))
(%%chi-lambda-clause461
(lambda (%%e1716 %%c1717 %%r1718 %%mr1719 %%w1720 %%m?1721)
(letrec ((%%reverse*1722
(lambda (%%l1725)
((letrec ((%%f1726 (lambda (%%ls11727 %%ls21728)
(if (null? %%ls11727)
%%ls21728
(%%f1726 (cdr %%ls11727)
(cons (car %%ls11727)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%ls21728))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f1726)
(cdr %%l1725)
(car %%l1725))))
(%%ids/emitter1723
(lambda (%%formals1729 %%ids1730 %%emitter1731)
(if (null? %%ids1730)
(values (reverse %%formals1729) %%emitter1731)
(if (eq? (car %%ids1730) #!key)
(%%ids/emitter1723
%%formals1729
(cdr %%ids1730)
'keyword)
(if (memq (car %%ids1730)
'(#!optional #!rest))
(%%ids/emitter1723
%%formals1729
(cdr %%ids1730)
((lambda (%%t1732)
(if %%t1732
%%t1732
%%emitter1731))
(if (eq? %%emitter1731 'rnrs)
'optional/rest
#f)))
((lambda (%%id1733)
(%%ids/emitter1723
(cons %%id1733 %%formals1729)
(cdr %%ids1730)
%%emitter1731))
(if (pair? (car %%ids1730))
(car (car %%ids1730))
(car %%ids1730))))))))
(%%emit-formals1724
(lambda (%%formals*1734
%%formals1735
%%vars1736
%%emitter1737)
(letrec ((%%formal1738
(lambda ()
((lambda (%%t1739)
(if (memv %%t1739 '(optional/rest))
%%vars1736
(if (memv %%t1739
'(rnrs keyword))
%%formals1735
(void))))
%%emitter1737))))
(if (null? %%formals1735)
(reverse %%formals*1734)
(if (%%id?251 %%formals1735)
(%%reverse*1722
(cons (%%formal1738) %%formals*1734))
(if (memq (car %%formals1735)
'(#!optional #!rest #!key))
(%%emit-formals1724
(cons (car %%formals1735)
%%formals*1734)
(cdr %%formals1735)
%%vars1736
%%emitter1737)
(if (pair? (car %%formals1735))
(%%emit-formals1724
(cons (cons (car ((lambda (%%t1740)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (memv %%t1740 '(keyword))
(car (%%formal1738))
(if (memv %%t1740 '(optional/rest))
(%%formal1738)
(void))))
%%emitter1737))
(%%strip-annotation465
(%%chi443
(cdr (car %%formals1735))
%%r1718
%%mr1719
%%w1720
%%m?1721)))
%%formals*1734)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cdr %%formals1735)
(cdr %%vars1736)
%%emitter1737)
(if (%%id?251
(car %%formals1735))
(%%emit-formals1724
(cons (car (%%formal1738))
%%formals*1734)
(cdr %%formals1735)
(cdr %%vars1736)
%%emitter1737)
(error (list 'unexpected-formal
(car %%formals1735))))))))))))
((lambda (%%tmp1741)
((lambda (%%tmp1742)
(if %%tmp1742
(apply (lambda (%%id1743 %%e11744 %%e21745)
((lambda (%%formals1746)
(call-with-values
(lambda ()
(%%ids/emitter1723
'()
%%formals1746
'rnrs))
(lambda (%%ids1747 %%emitter1748)
(if (not (%%valid-bound-ids?384
%%ids1747))
(syntax-error
%%e1716
"invalid parameter list in")
((lambda (%%labels1749
%%new-vars1750)
(values %%emitter1748
(if (eq? %%emitter1748
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'keyword)
(%%gen-var468 'dssl-args)
#f)
%%new-vars1750
(%%emit-formals1724
'()
%%formals1746
%%new-vars1750
%%emitter1748)
%%ids1747
(%%chi-body448
(cons %%e11744 %%e21745)
%%e1716
(%%extend-var-env*242 %%labels1749 %%new-vars1750 %%r1718)
%%mr1719
(%%make-binding-wrap362 %%ids1747 %%labels1749 %%w1720)
%%m?1721)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%gen-labels309 %%ids1747)
(map %%gen-var468
%%ids1747))))))
(%%strip-annotation465 %%id1743)))
%%tmp1742)
((lambda (%%tmp1753)
(if %%tmp1753
(apply (lambda (%%ids1754
%%e11755
%%e21756)
((lambda (%%formals1757)
(call-with-values
(lambda ()
(%%ids/emitter1723
'()
(%%lambda-var-list469
%%formals1757)
'rnrs))
(lambda (%%old-ids1758
%%emitter1759)
(if (not (%%valid-bound-ids?384
%%old-ids1758))
(syntax-error
%%e1716
"invalid parameter list in")
((lambda (%%labels1760
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%new-vars1761)
(values %%emitter1759
(if (eq? %%emitter1759 'keyword)
(%%gen-var468 'dssl-args)
#f)
(if (eq? %%emitter1759 'rnrs)
(%%reverse*1722 %%new-vars1761)
(reverse %%new-vars1761))
(%%emit-formals1724
'()
(%%strip-annotation465 %%formals1757)
%%new-vars1761
%%emitter1759)
(reverse (map (lambda (%%id1762)
((lambda (%%e1763)
(if (annotation? %%e1763)
(annotation-expression
%%e1763)
%%e1763))
%%id1762))
%%old-ids1758))
(%%chi-body448
(cons %%e11755 %%e21756)
%%e1716
(%%extend-var-env*242
%%labels1760
%%new-vars1761
%%r1718)
%%mr1719
(%%make-binding-wrap362
%%old-ids1758
%%labels1760
%%w1720)
%%m?1721)))
(%%gen-labels309 %%old-ids1758)
(map %%gen-var468 %%old-ids1758))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%strip-annotation465
%%ids1754)))
%%tmp1753)
((lambda (%%_1765) (syntax-error %%e1716))
%%tmp1741)))
($syntax-dispatch
%%tmp1741
'(any any . each-any)))))
($syntax-dispatch
%%tmp1741
'(each-any any . each-any))))
%%c1717))))
(%%chi-local-syntax462
(lambda (%%rec?1766 %%e1767 %%r1768 %%mr1769 %%w1770 %%ae1771)
((lambda (%%tmp1772)
((lambda (%%tmp1773)
(if %%tmp1773
(apply (lambda (%%_1774
%%id1775
%%val1776
%%e11777
%%e21778)
((lambda (%%ids1779)
(if (not (%%valid-bound-ids?384
%%ids1779))
(%%invalid-ids-error386
(map (lambda (%%x1780)
(%%wrap388 %%x1780 %%w1770))
%%ids1779)
(%%source-wrap389
%%e1767
%%w1770
%%ae1771)
"keyword")
((lambda (%%labels1781)
((lambda (%%new-w1782)
((lambda (%%b*1783)
(values (cons %%e11777
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e21778)
(%%extend-env*241 %%labels1781 %%b*1783 %%r1768)
(%%extend-env*241 %%labels1781 %%b*1783 %%mr1769)
%%new-w1782
%%ae1771))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%w1785)
(map (lambda (%%x1786)
(%%defer-or-eval-transformer248
%%local-eval-hook70
(%%chi443
%%x1786
%%mr1769
%%mr1769
%%w1785
#t)))
%%val1776))
(if %%rec?1766
%%new-w1782
%%w1770))))
(%%make-binding-wrap362
%%ids1779
%%labels1781
%%w1770)))
(%%gen-labels309 %%ids1779))))
%%id1775))
%%tmp1773)
((lambda (%%_1789)
(syntax-error
(%%source-wrap389 %%e1767 %%w1770 %%ae1771)))
%%tmp1772)))
($syntax-dispatch
%%tmp1772
'(any #(each (any any)) any . each-any))))
%%e1767)))
(%%chi-void463
(lambda ()
(build-source #f (cons (build-source #f 'void) '()))))
(%%ellipsis?464
(lambda (%%x1790)
(if (%%nonsymbol-id?250 %%x1790)
(%%literal-id=?381
%%x1790
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t))))
#f)))
(%%strip-annotation465
(lambda (%%x1791)
(if (pair? %%x1791)
(cons (%%strip-annotation465 (car %%x1791))
(%%strip-annotation465 (cdr %%x1791)))
(if (annotation? %%x1791)
(annotation-stripped %%x1791)
%%x1791))))
(%%strip*466
(lambda (%%x1792 %%w1793 %%fn1794)
(if (memq 'top (%%wrap-marks261 %%w1793))
(%%fn1794 %%x1792)
((letrec ((%%f1795 (lambda (%%x1796)
(if (%%syntax-object?64 %%x1796)
(%%strip*466
(%%syntax-object-expression65
%%x1796)
(%%syntax-object-wrap66 %%x1796)
%%fn1794)
(if (pair? %%x1796)
((lambda (%%a1797 %%d1798)
(if (if (eq? %%a1797
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(car %%x1796))
(eq? %%d1798 (cdr %%x1796))
#f)
%%x1796
(cons %%a1797 %%d1798)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%f1795 (car %%x1796))
(%%f1795 (cdr %%x1796)))
(if (vector? %%x1796)
((lambda (%%old1799)
((lambda (%%new1800)
(if (andmap eq?
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%old1799
%%new1800)
%%x1796
(list->vector %%new1800)))
(map %%f1795 %%old1799)))
(vector->list %%x1796))
%%x1796))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f1795)
%%x1792))))
(%%strip467
(lambda (%%x1801 %%w1802)
(%%strip*466
%%x1801
%%w1802
(lambda (%%x1803)
(if ((lambda (%%t1804)
(if %%t1804
%%t1804
(if (pair? %%x1803)
(annotation? (car %%x1803))
#f)))
(annotation? %%x1803))
(%%strip-annotation465 %%x1803)
%%x1803)))))
(%%gen-var468
(lambda (%%id1805)
((lambda (%%id1806)
(if (annotation? %%id1806)
(gensym (annotation-expression %%id1806))
(gensym %%id1806)))
(if (%%syntax-object?64 %%id1805)
(%%syntax-object-expression65 %%id1805)
%%id1805))))
(%%lambda-var-list469
(lambda (%%vars1807)
((letrec ((%%lvl1808
(lambda (%%vars1809 %%ls1810 %%w1811)
(if (pair? %%vars1809)
(%%lvl1808
(cdr %%vars1809)
(cons (%%wrap388 (car %%vars1809) %%w1811)
%%ls1810)
%%w1811)
(if (%%id?251 %%vars1809)
(cons (%%wrap388 %%vars1809 %%w1811)
%%ls1810)
(if (null? %%vars1809)
%%ls1810
(if (%%syntax-object?64 %%vars1809)
(%%lvl1808
(%%syntax-object-expression65
%%vars1809)
%%ls1810
(%%join-wraps367
%%w1811
(%%syntax-object-wrap66
%%vars1809)))
(if (annotation? %%vars1809)
(%%lvl1808
(annotation-expression
%%vars1809)
%%ls1810
%%w1811)
(cons %%vars1809
%%ls1810)))))))))
%%lvl1808)
%%vars1807
'()
'(())))))
(begin
(set! $sc-put-cte
(lambda (%%id1812 %%b1813 %%top-token1814)
(letrec ((%%sc-put-module1815
(lambda (%%exports1817 %%token1818 %%new-marks1819)
(%%vfor-each433
(lambda (%%id1820)
(%%store-import-binding361
%%id1820
%%token1818
%%new-marks1819))
%%exports1817)))
(%%put-cte1816
(lambda (%%id1821 %%binding1822 %%token1823)
((lambda (%%sym1824)
(begin
(%%store-import-binding361
%%id1821
%%token1823
'())
(%%put-global-definition-hook74
%%sym1824
(if (if (eq? (%%binding-type226
%%binding1822)
'global)
(eq? (%%binding-value227
%%binding1822)
%%sym1824)
#f)
#f
%%binding1822))))
(if (symbol? %%id1821)
%%id1821
(%%id-var-name379 %%id1821 '(())))))))
((lambda (%%binding1825)
((lambda (%%t1826)
(if (memv %%t1826 '($module))
(begin
((lambda (%%iface1827)
(%%sc-put-module1815
(%%interface-exports399 %%iface1827)
(%%interface-token400 %%iface1827)
'()))
(%%binding-value227 %%binding1825))
(%%put-cte1816
%%id1812
%%binding1825
%%top-token1814))
(if (memv %%t1826 '(do-alias))
(%%store-import-binding361
%%id1812
%%top-token1814
'())
(if (memv %%t1826 '(do-import))
((lambda (%%token1828)
((lambda (%%b1829)
((lambda (%%t1830)
(if (memv %%t1830 '($module))
((lambda (%%iface1831)
((lambda (%%exports1832)
((lambda ()
(begin
(if (not (eq? (%%interface-token400
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%iface1831)
%%token1828))
(syntax-error %%id1812 "import mismatch for module")
(void))
(%%sc-put-module1815
(%%interface-exports399 %%iface1831)
%%top-token1814
(%%import-mark-delta450 %%id1812 %%iface1831))))))
(%%interface-exports399 %%iface1831)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%binding-value227
%%b1829))
(syntax-error
%%id1812
"unknown module")))
(%%binding-type226 %%b1829)))
(%%lookup246
(%%id-var-name379 %%id1812 '(()))
'())))
(%%binding-value227 %%b1813))
(%%put-cte1816
%%id1812
%%binding1825
%%top-token1814)))))
(%%binding-type226 %%binding1825)))
(%%make-transformer-binding247 %%b1813)))))
(%%global-extend249
'core
'##c-define-type
(lambda (%%e1833 %%r1834 %%mr1835 %%w1836 %%ae1837 %%m?1838)
(attach-source %%ae1837 (%%strip467 %%e1833 %%w1836))))
(%%global-extend249
'core
'##c-declare
(lambda (%%e1839 %%r1840 %%mr1841 %%w1842 %%ae1843 %%m?1844)
(attach-source %%ae1843 (%%strip467 %%e1839 %%w1842))))
(%%global-extend249
'core
'##c-initialize
(lambda (%%e1845 %%r1846 %%mr1847 %%w1848 %%ae1849 %%m?1850)
(attach-source %%ae1849 (%%strip467 %%e1845 %%w1848))))
(%%global-extend249
'core
'##c-lambda
(lambda (%%e1851 %%r1852 %%mr1853 %%w1854 %%ae1855 %%m?1856)
(attach-source %%ae1855 (%%strip467 %%e1851 %%w1854))))
(%%global-extend249
'core
'##c-define
(lambda (%%e1857 %%r1858 %%mr1859 %%w1860 %%ae1861 %%m?1862)
(attach-source %%ae1861 (%%strip467 %%e1857 %%w1860))))
(%%global-extend249
'core
'##define
(lambda (%%e1863 %%r1864 %%mr1865 %%w1866 %%ae1867 %%m?1868)
(attach-source %%ae1867 (%%strip467 %%e1863 %%w1866))))
(%%global-extend249
'core
'##define-macro
(lambda (%%e1869 %%r1870 %%mr1871 %%w1872 %%ae1873 %%m?1874)
(attach-source %%ae1873 (%%strip467 %%e1869 %%w1872))))
(%%global-extend249
'core
'##define-syntax
(lambda (%%e1875 %%r1876 %%mr1877 %%w1878 %%ae1879 %%m?1880)
(attach-source %%ae1879 (%%strip467 %%e1875 %%w1878))))
(%%global-extend249
'core
'##include
(lambda (%%e1881 %%r1882 %%mr1883 %%w1884 %%ae1885 %%m?1886)
(attach-source %%ae1885 (%%strip467 %%e1881 %%w1884))))
(%%global-extend249
'core
'##declare
(lambda (%%e1887 %%r1888 %%mr1889 %%w1890 %%ae1891 %%m?1892)
(attach-source %%ae1891 (%%strip467 %%e1887 %%w1890))))
(%%global-extend249
'core
'##namespace
(lambda (%%e1893 %%r1894 %%mr1895 %%w1896 %%ae1897 %%m?1898)
(attach-source %%ae1897 (%%strip467 %%e1893 %%w1896))))
(%%global-extend249 'local-syntax 'letrec-syntax #t)
(%%global-extend249 'local-syntax 'let-syntax #f)
(%%global-extend249
'core
'fluid-let-syntax
(lambda (%%e1899 %%r1900 %%mr1901 %%w1902 %%ae1903 %%m?1904)
((lambda (%%tmp1905)
((lambda (%%tmp1906)
(if (if %%tmp1906
(apply (lambda (%%_1907
%%var1908
%%val1909
%%e11910
%%e21911)
(%%valid-bound-ids?384 %%var1908))
%%tmp1906)
#f)
(apply (lambda (%%_1913
%%var1914
%%val1915
%%e11916
%%e21917)
((lambda (%%names1918)
(begin
(for-each
(lambda (%%id1919 %%n1920)
((lambda (%%t1921)
(if (memv %%t1921
'(displaced-lexical))
(%%displaced-lexical-error244
(%%wrap388 %%id1919 %%w1902))
(void)))
(%%binding-type226
(%%lookup246 %%n1920 %%r1900))))
%%var1914
%%names1918)
((lambda (%%b*1923)
(%%chi-body448
(cons %%e11916 %%e21917)
(%%source-wrap389
%%e1899
%%w1902
%%ae1903)
(%%extend-env*241
%%names1918
%%b*1923
%%r1900)
(%%extend-env*241
%%names1918
%%b*1923
%%mr1901)
%%w1902
%%m?1904))
(map (lambda (%%x1925)
(%%defer-or-eval-transformer248
%%local-eval-hook70
(%%chi443
%%x1925
%%mr1901
%%mr1901
%%w1902
#t)))
%%val1915))))
(map (lambda (%%x1927)
(%%id-var-name379 %%x1927 %%w1902))
%%var1914)))
%%tmp1906)
((lambda (%%_1929)
(syntax-error
(%%source-wrap389 %%e1899 %%w1902 %%ae1903)))
%%tmp1905)))
($syntax-dispatch
%%tmp1905
'(any #(each (any any)) any . each-any))))
%%e1899)))
(%%global-extend249
'core
'quote
(lambda (%%e1930 %%r1931 %%mr1932 %%w1933 %%ae1934 %%m?1935)
((lambda (%%tmp1936)
((lambda (%%tmp1937)
(if %%tmp1937
(apply (lambda (%%_1938 %%e1939)
((lambda (%%x1940)
(if (self-eval? (%%strip467 %%e1939 %%w1933))
%%x1940
(build-source
%%ae1934
(list (build-source %%ae1934 'quote)
%%x1940))))
(attach-source
%%ae1934
(%%strip467 %%e1939 %%w1933))))
%%tmp1937)
((lambda (%%_1941)
(syntax-error
(%%source-wrap389 %%e1930 %%w1933 %%ae1934)))
%%tmp1936)))
($syntax-dispatch %%tmp1936 '(any any))))
%%e1930)))
(%%global-extend249
'core
'syntax
((lambda ()
(letrec ((%%gen-syntax1942
(lambda (%%src1950
%%e1951
%%r1952
%%maps1953
%%ellipsis?1954
%%vec?1955)
(if (%%id?251 %%e1951)
((lambda (%%label1956)
((lambda (%%b1957)
(if (eq? (%%binding-type226 %%b1957)
'syntax)
(call-with-values
(lambda ()
((lambda (%%var.lev1958)
(%%gen-ref1943
%%src1950
(car %%var.lev1958)
(cdr %%var.lev1958)
%%maps1953))
(%%binding-value227 %%b1957)))
(lambda (%%var1959 %%maps1960)
(values (list 'ref %%var1959)
%%maps1960)))
(if (%%ellipsis?1954 %%e1951)
(syntax-error
%%src1950
"misplaced ellipsis in syntax form")
(values (list 'quote %%e1951)
%%maps1953))))
(%%lookup246 %%label1956 %%r1952)))
(%%id-var-name379 %%e1951 '(())))
((lambda (%%tmp1961)
((lambda (%%tmp1962)
(if (if %%tmp1962
(apply (lambda (%%dots1963 %%e1964)
(%%ellipsis?1954
%%dots1963))
%%tmp1962)
#f)
(apply (lambda (%%dots1965 %%e1966)
(if %%vec?1955
(syntax-error
%%src1950
"misplaced ellipsis in syntax template")
(%%gen-syntax1942
%%src1950
%%e1966
%%r1952
%%maps1953
(lambda (%%x1967) #f)
#f)))
%%tmp1962)
((lambda (%%tmp1968)
(if (if %%tmp1968
(apply (lambda (%%x1969
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%dots1970
%%y1971)
(%%ellipsis?1954 %%dots1970))
%%tmp1968)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#f)
(apply (lambda (%%x1972
%%dots1973
%%y1974)
((letrec ((%%f1975 (lambda (%%y1976
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%k1977)
((lambda (%%tmp1978)
((lambda (%%tmp1979)
(if (if %%tmp1979
(apply (lambda (%%dots1980
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%y1981)
(%%ellipsis?1954 %%dots1980))
%%tmp1979)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#f)
(apply (lambda (%%dots1982
%%y1983)
(%%f1975 %%y1983
(lambda (%%maps1984)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(call-with-values
(lambda () (%%k1977 (cons '() %%maps1984)))
(lambda (%%x1985 %%maps1986)
(if (null? (car %%maps1986))
(syntax-error
%%src1950
"extra ellipsis in syntax form")
(values (%%gen-mappend1945
%%x1985
(car %%maps1986))
(cdr %%maps1986))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp1979)
((lambda (%%_1987)
(call-with-values
(lambda ()
(%%gen-syntax1942
%%src1950
%%y1976
%%r1952
%%maps1953
%%ellipsis?1954
%%vec?1955))
(lambda (%%y1988 %%maps1989)
(call-with-values
(lambda ()
(%%k1977 %%maps1989))
(lambda (%%x1990
%%maps1991)
(values (%%gen-append1944
%%x1990
%%y1988)
%%maps1991))))))
%%tmp1978)))
($syntax-dispatch
%%tmp1978
'(any . any))))
%%y1976))))
%%f1975)
%%y1974
(lambda (%%maps1992)
(call-with-values
(lambda ()
(%%gen-syntax1942
%%src1950
%%x1972
%%r1952
(cons '() %%maps1992)
%%ellipsis?1954
#f))
(lambda (%%x1993 %%maps1994)
(if (null? (car %%maps1994))
(syntax-error
%%src1950
"extra ellipsis in syntax form")
(values (%%gen-map1946 %%x1993 (car %%maps1994))
(cdr %%maps1994))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp1968)
((lambda (%%tmp1995)
(if %%tmp1995
(apply (lambda (%%x1996
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%y1997)
(call-with-values
(lambda ()
(%%gen-syntax1942
%%src1950
%%x1996
%%r1952
%%maps1953
%%ellipsis?1954
#f))
(lambda (%%xnew1998 %%maps1999)
(call-with-values
(lambda ()
(%%gen-syntax1942
%%src1950
%%y1997
%%r1952
%%maps1999
%%ellipsis?1954
%%vec?1955))
(lambda (%%ynew2000 %%maps2001)
(values (%%gen-cons1947
%%e1951
%%x1996
%%y1997
%%xnew1998
%%ynew2000)
%%maps2001))))))
%%tmp1995)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2002)
(if %%tmp2002
(apply (lambda (%%x12003
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%x22004)
((lambda (%%ls2005)
(call-with-values
(lambda ()
(%%gen-syntax1942
%%src1950
%%ls2005
%%r1952
%%maps1953
%%ellipsis?1954
#t))
(lambda (%%lsnew2006 %%maps2007)
(values (%%gen-vector1948
%%e1951
%%ls2005
%%lsnew2006)
%%maps2007))))
(cons %%x12003 %%x22004)))
%%tmp2002)
((lambda (%%_2009)
(values (list 'quote %%e1951) %%maps1953))
%%tmp1961)))
($syntax-dispatch %%tmp1961 '#(vector (any . each-any))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp1961
'(any . any)))))
($syntax-dispatch
%%tmp1961
'(any any . any)))))
($syntax-dispatch %%tmp1961 '(any any))))
%%e1951))))
(%%gen-ref1943
(lambda (%%src2010 %%var2011 %%level2012 %%maps2013)
(if (fx= %%level2012 0)
(values %%var2011 %%maps2013)
(if (null? %%maps2013)
(syntax-error
%%src2010
"missing ellipsis in syntax form")
(call-with-values
(lambda ()
(%%gen-ref1943
%%src2010
%%var2011
(fx- %%level2012 1)
(cdr %%maps2013)))
(lambda (%%outer-var2014 %%outer-maps2015)
((lambda (%%b2016)
(if %%b2016
(values (cdr %%b2016) %%maps2013)
((lambda (%%inner-var2017)
(values %%inner-var2017
(cons (cons (cons %%outer-var2014
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%inner-var2017)
(car %%maps2013))
%%outer-maps2015)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%gen-var468 'tmp))))
(assq %%outer-var2014
(car %%maps2013)))))))))
(%%gen-append1944
(lambda (%%x2018 %%y2019)
(if (equal? %%y2019 ''())
%%x2018
(list 'append %%x2018 %%y2019))))
(%%gen-mappend1945
(lambda (%%e2020 %%map-env2021)
(list 'apply
'(primitive append)
(%%gen-map1946 %%e2020 %%map-env2021))))
(%%gen-map1946
(lambda (%%e2022 %%map-env2023)
((lambda (%%formals2024 %%actuals2025)
(if (eq? (car %%e2022) 'ref)
(car %%actuals2025)
(if (andmap (lambda (%%x2026)
(if (eq? (car %%x2026) 'ref)
(memq (cadr %%x2026)
%%formals2024)
#f))
(cdr %%e2022))
(cons 'map
(cons (list 'primitive (car %%e2022))
(map ((lambda (%%r2027)
(lambda (%%x2028)
(cdr (assq (cadr %%x2028)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%r2027))))
(map cons %%formals2024 %%actuals2025))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(cdr %%e2022))))
(cons 'map
(cons (list 'lambda
%%formals2024
%%e2022)
%%actuals2025)))))
(map cdr %%map-env2023)
(map (lambda (%%x2029) (list 'ref (car %%x2029)))
%%map-env2023))))
(%%gen-cons1947
(lambda (%%e2030 %%x2031 %%y2032 %%xnew2033 %%ynew2034)
((lambda (%%t2035)
(if (memv %%t2035 '(quote))
(if (eq? (car %%xnew2033) 'quote)
((lambda (%%xnew2036 %%ynew2037)
(if (if (eq? %%xnew2036 %%x2031)
(eq? %%ynew2037 %%y2032)
#f)
(list 'quote %%e2030)
(list 'quote
(cons %%xnew2036
%%ynew2037))))
(cadr %%xnew2033)
(cadr %%ynew2034))
(if (eq? (cadr %%ynew2034) '())
(list 'list %%xnew2033)
(list 'cons %%xnew2033 %%ynew2034)))
(if (memv %%t2035 '(list))
(cons 'list
(cons %%xnew2033 (cdr %%ynew2034)))
(list 'cons %%xnew2033 %%ynew2034))))
(car %%ynew2034))))
(%%gen-vector1948
(lambda (%%e2038 %%ls2039 %%lsnew2040)
(if (eq? (car %%lsnew2040) 'quote)
(if (eq? (cadr %%lsnew2040) %%ls2039)
(list 'quote %%e2038)
(list 'quote
(list->vector (cadr %%lsnew2040))))
(if (eq? (car %%lsnew2040) 'list)
(cons 'vector (cdr %%lsnew2040))
(list 'list->vector %%lsnew2040)))))
(%%regen1949
(lambda (%%x2041)
((lambda (%%t2042)
(if (memv %%t2042 '(ref))
(build-source #f (cadr %%x2041))
(if (memv %%t2042 '(primitive))
(build-source #f (cadr %%x2041))
(if (memv %%t2042 '(quote))
((lambda (%%x2043)
(if (self-eval? (cadr %%x2041))
%%x2043
(build-source
#f
(list (build-source #f 'quote)
%%x2043))))
(attach-source #f (cadr %%x2041)))
(if (memv %%t2042 '(lambda))
(build-source
#f
(list (build-source #f 'lambda)
(build-params
#f
(cadr %%x2041))
(%%regen1949
(caddr %%x2041))))
(if (memv %%t2042 '(map))
((lambda (%%ls2044)
(build-source
#f
(cons (if (fx= (length %%ls2044)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
2)
(build-source #f 'map)
(build-source #f 'map))
%%ls2044)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(map %%regen1949
(cdr %%x2041)))
(build-source
#f
(cons (build-source
#f
(car %%x2041))
(map %%regen1949
(cdr %%x2041))))))))))
(car %%x2041)))))
(lambda (%%e2045 %%r2046 %%mr2047 %%w2048 %%ae2049 %%m?2050)
((lambda (%%e2051)
((lambda (%%tmp2052)
((lambda (%%tmp2053)
(if %%tmp2053
(apply (lambda (%%_2054 %%x2055)
(call-with-values
(lambda ()
(%%gen-syntax1942
%%e2051
%%x2055
%%r2046
'()
%%ellipsis?464
#f))
(lambda (%%e2056 %%maps2057)
(%%regen1949 %%e2056))))
%%tmp2053)
((lambda (%%_2058) (syntax-error %%e2051))
%%tmp2052)))
($syntax-dispatch %%tmp2052 '(any any))))
%%e2051))
(%%source-wrap389 %%e2045 %%w2048 %%ae2049)))))))
(%%global-extend249
'core
'lambda
(lambda (%%e2059 %%r2060 %%mr2061 %%w2062 %%ae2063 %%m?2064)
((lambda (%%tmp2065)
((lambda (%%tmp2066)
(if %%tmp2066
(apply (lambda (%%_2067 %%c2068)
(call-with-values
(lambda ()
(%%chi-lambda-clause461
(%%source-wrap389 %%e2059 %%w2062 %%ae2063)
%%c2068
%%r2060
%%mr2061
%%w2062
%%m?2064))
(lambda (%%emitter2069
%%dsssl-args2070
%%vars2071
%%dsssl-formals2072
%%orig-vars2073
%%body2074)
((lambda (%%t2075)
(if (memv %%t2075 '(keyword))
(build-source
%%ae2063
(list (build-source %%ae2063 'lambda)
(build-source
%%ae2063
%%dsssl-args2070)
(build-source
%%ae2063
(list (build-source
%%ae2063
'receive)
(build-params
%%ae2063
%%vars2071)
(build-source
%%ae2063
(list (build-source
%%ae2063
'apply)
(build-source
%%ae2063
(list (build-source
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%ae2063
'lambda)
(build-params %%ae2063 %%dsssl-formals2072)
(build-source
%%ae2063
(cons (build-source %%ae2063 'values)
(annotation-expression
(build-params
%%ae2063
%%orig-vars2073))))))
(build-source %%ae2063 %%dsssl-args2070)))
%%body2074))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(if (memv %%t2075 '(optional/rest))
(build-source
%%ae2063
(list (build-source
%%ae2063
'lambda)
(build-params
%%ae2063
%%dsssl-formals2072)
%%body2074))
(if (memv %%t2075 '(rnrs))
(build-source
%%ae2063
(list (build-source
%%ae2063
'lambda)
(build-params
%%ae2063
%%vars2071)
%%body2074))
(void)))))
%%emitter2069))))
%%tmp2066)
(syntax-error %%tmp2065)))
($syntax-dispatch %%tmp2065 '(any . any))))
%%e2059)))
(%%global-extend249
'core
'letrec
(lambda (%%e2076 %%r2077 %%mr2078 %%w2079 %%ae2080 %%m?2081)
((lambda (%%tmp2082)
((lambda (%%tmp2083)
(if %%tmp2083
(apply (lambda (%%_2084
%%id2085
%%val2086
%%e12087
%%e22088)
((lambda (%%ids2089)
(if (not (%%valid-bound-ids?384 %%ids2089))
(%%invalid-ids-error386
(map (lambda (%%x2090)
(%%wrap388 %%x2090 %%w2079))
%%ids2089)
(%%source-wrap389
%%e2076
%%w2079
%%ae2080)
"bound variable")
((lambda (%%labels2091 %%new-vars2092)
((lambda (%%w2093 %%r2094)
(%%build-letrec181
%%ae2080
%%new-vars2092
(map (lambda (%%x2095)
(%%chi443
%%x2095
%%r2094
%%mr2078
%%w2093
%%m?2081))
%%val2086)
(%%chi-body448
(cons %%e12087 %%e22088)
(%%source-wrap389
%%e2076
%%w2093
%%ae2080)
%%r2094
%%mr2078
%%w2093
%%m?2081)))
(%%make-binding-wrap362
%%ids2089
%%labels2091
%%w2079)
(%%extend-var-env*242
%%labels2091
%%new-vars2092
%%r2077)))
(%%gen-labels309 %%ids2089)
(map %%gen-var468 %%ids2089))))
%%id2085))
%%tmp2083)
((lambda (%%_2099)
(syntax-error
(%%source-wrap389 %%e2076 %%w2079 %%ae2080)))
%%tmp2082)))
($syntax-dispatch
%%tmp2082
'(any #(each (any any)) any . each-any))))
%%e2076)))
(%%global-extend249
'core
'if
(lambda (%%e2100 %%r2101 %%mr2102 %%w2103 %%ae2104 %%m?2105)
((lambda (%%tmp2106)
((lambda (%%tmp2107)
(if %%tmp2107
(apply (lambda (%%_2108 %%test2109 %%then2110)
(build-source
%%ae2104
(list (build-source %%ae2104 'if)
(%%chi443
%%test2109
%%r2101
%%mr2102
%%w2103
%%m?2105)
(%%chi443
%%then2110
%%r2101
%%mr2102
%%w2103
%%m?2105)
(%%chi-void463))))
%%tmp2107)
((lambda (%%tmp2111)
(if %%tmp2111
(apply (lambda (%%_2112
%%test2113
%%then2114
%%else2115)
(build-source
%%ae2104
(list (build-source %%ae2104 'if)
(%%chi443
%%test2113
%%r2101
%%mr2102
%%w2103
%%m?2105)
(%%chi443
%%then2114
%%r2101
%%mr2102
%%w2103
%%m?2105)
(%%chi443
%%else2115
%%r2101
%%mr2102
%%w2103
%%m?2105))))
%%tmp2111)
((lambda (%%_2116)
(syntax-error
(%%source-wrap389 %%e2100 %%w2103 %%ae2104)))
%%tmp2106)))
($syntax-dispatch %%tmp2106 '(any any any any)))))
($syntax-dispatch %%tmp2106 '(any any any))))
%%e2100)))
(%%global-extend249 'set! 'set! '())
(%%global-extend249 'alias 'alias '())
(%%global-extend249 'begin 'begin '())
(%%global-extend249 '$module-key '$module '())
(%%global-extend249 '$import '$import '())
(%%global-extend249 'define 'define '())
(%%global-extend249 'define-syntax 'define-syntax '())
(%%global-extend249 'eval-when 'eval-when '())
(%%global-extend249 'meta 'meta '())
(%%global-extend249
'core
'syntax-case
((lambda ()
(letrec ((%%convert-pattern2117
(lambda (%%pattern2121 %%keys2122)
(letrec ((%%cvt*2123
(lambda (%%p*2125 %%n2126 %%ids2127)
(if (null? %%p*2125)
(values '() %%ids2127)
(call-with-values
(lambda ()
(%%cvt*2123
(cdr %%p*2125)
%%n2126
%%ids2127))
(lambda (%%y2128 %%ids2129)
(call-with-values
(lambda ()
(%%cvt2124
(car %%p*2125)
%%n2126
%%ids2129))
(lambda (%%x2130 %%ids2131)
(values (cons %%x2130 %%y2128)
%%ids2131))))))))
(%%cvt2124
(lambda (%%p2132 %%n2133 %%ids2134)
(if (%%id?251 %%p2132)
(if (%%bound-id-member?387
%%p2132
%%keys2122)
(values (vector 'free-id %%p2132)
%%ids2134)
(values 'any
(cons (cons %%p2132
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%n2133)
%%ids2134)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2135)
((lambda (%%tmp2136)
(if (if %%tmp2136
(apply (lambda (%%x2137
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%dots2138)
(%%ellipsis?464 %%dots2138))
%%tmp2136)
#f)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(apply (lambda (%%x2139
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%dots2140)
(call-with-values
(lambda () (%%cvt2124 %%x2139 (fx+ %%n2133 1) %%ids2134))
(lambda (%%p2141 %%ids2142)
(values (if (eq? %%p2141 'any)
'each-any
(vector 'each %%p2141))
%%ids2142))))
%%tmp2136)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2143)
(if (if %%tmp2143
(apply (lambda (%%x2144
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%dots2145
%%y2146
%%z2147)
(%%ellipsis?464 %%dots2145))
%%tmp2143)
#f)
(apply (lambda (%%x2148 %%dots2149 %%y2150 %%z2151)
(call-with-values
(lambda () (%%cvt2124 %%z2151 %%n2133 %%ids2134))
(lambda (%%z2152 %%ids2153)
(call-with-values
(lambda ()
(%%cvt*2123 %%y2150 %%n2133 %%ids2153))
(lambda (%%y2155 %%ids2156)
(call-with-values
(lambda ()
(%%cvt2124
%%x2148
(fx+ %%n2133 1)
%%ids2156))
(lambda (%%x2157 %%ids2158)
(values (vector 'each+
%%x2157
(reverse %%y2155)
%%z2152)
%%ids2158))))))))
%%tmp2143)
((lambda (%%tmp2159)
(if %%tmp2159
(apply (lambda (%%x2160 %%y2161)
(call-with-values
(lambda ()
(%%cvt2124 %%y2161 %%n2133 %%ids2134))
(lambda (%%y2162 %%ids2163)
(call-with-values
(lambda ()
(%%cvt2124 %%x2160 %%n2133 %%ids2163))
(lambda (%%x2164 %%ids2165)
(values (cons %%x2164 %%y2162)
%%ids2165))))))
%%tmp2159)
((lambda (%%tmp2166)
(if %%tmp2166
(apply (lambda () (values '() %%ids2134))
%%tmp2166)
((lambda (%%tmp2167)
(if %%tmp2167
(apply (lambda (%%x2168)
(call-with-values
(lambda ()
(%%cvt2124
%%x2168
%%n2133
%%ids2134))
(lambda (%%p2170 %%ids2171)
(values (vector 'vector
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%p2170)
%%ids2171))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2167)
((lambda (%%x2172)
(values (vector 'atom
(%%strip467
%%p2132
'(())))
%%ids2134))
%%tmp2135)))
($syntax-dispatch
%%tmp2135
'#(vector each-any)))))
($syntax-dispatch %%tmp2135 '()))))
($syntax-dispatch %%tmp2135 '(any . any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2135
'(any any
.
#(each+
any
()
any))))))
($syntax-dispatch
%%tmp2135
'(any any))))
%%p2132)))))
(%%cvt2124 %%pattern2121 0 '()))))
(%%build-dispatch-call2118
(lambda (%%pvars2173
%%exp2174
%%y2175
%%r2176
%%mr2177
%%m?2178)
((lambda (%%ids2179 %%levels2180)
((lambda (%%labels2181 %%new-vars2182)
(build-source
#f
(cons (build-source #f 'apply)
(list (build-source
#f
(list (build-source #f 'lambda)
(build-params
#f
%%new-vars2182)
(%%chi443
%%exp2174
(%%extend-env*241
%%labels2181
(map (lambda (%%var2183
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%level2184)
(cons 'syntax (cons %%var2183 %%level2184)))
%%new-vars2182
(map cdr %%pvars2173))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%r2176)
%%mr2177
(%%make-binding-wrap362
%%ids2179
%%labels2181
'(()))
%%m?2178)))
%%y2175))))
(%%gen-labels309 %%ids2179)
(map %%gen-var468 %%ids2179)))
(map car %%pvars2173)
(map cdr %%pvars2173))))
(%%gen-clause2119
(lambda (%%x2185
%%keys2186
%%clauses2187
%%r2188
%%mr2189
%%m?2190
%%pat2191
%%fender2192
%%exp2193)
(call-with-values
(lambda ()
(%%convert-pattern2117 %%pat2191 %%keys2186))
(lambda (%%p2194 %%pvars2195)
(if (not (%%distinct-bound-ids?385
(map car %%pvars2195)))
(%%invalid-ids-error386
(map car %%pvars2195)
%%pat2191
"pattern variable")
(if (not (andmap (lambda (%%x2196)
(not (%%ellipsis?464
(car %%x2196))))
%%pvars2195))
(syntax-error
%%pat2191
"misplaced ellipsis in syntax-case pattern")
((lambda (%%y2197)
(build-source
#f
(cons (build-source
#f
(list (build-source #f 'lambda)
(build-params
#f
(list %%y2197))
(build-source
#f
(list (build-source
#f
'if)
((lambda (%%tmp2207)
((lambda (%%tmp2208)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if %%tmp2208
(apply (lambda () (build-source #f %%y2197))
%%tmp2208)
((lambda (%%_2209)
(build-source
#f
(list (build-source #f 'if)
(build-source #f %%y2197)
(%%build-dispatch-call2118
%%pvars2195
%%fender2192
(build-source #f %%y2197)
%%r2188
%%mr2189
%%m?2190)
((lambda (%%x2210)
(if (self-eval? #f)
%%x2210
(build-source
#f
(list (build-source #f 'quote)
%%x2210))))
(attach-source #f #f)))))
%%tmp2207)))
($syntax-dispatch %%tmp2207 '#(atom #t))))
%%fender2192)
(%%build-dispatch-call2118
%%pvars2195
%%exp2193
(build-source #f %%y2197)
%%r2188
%%mr2189
%%m?2190)
(%%gen-syntax-case2120
%%x2185
%%keys2186
%%clauses2187
%%r2188
%%mr2189
%%m?2190)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(list (if (eq? %%p2194 'any)
(build-source
#f
(cons (build-source
#f
'list)
(list (build-source
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'value
%%x2185))))
(build-source
#f
(cons (build-source #f '$syntax-dispatch)
(list (build-source 'value %%x2185)
((lambda (%%x2211)
(if (self-eval? %%p2194)
%%x2211
(build-source
#f
(list (build-source #f 'quote) %%x2211))))
(attach-source #f %%p2194))))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%gen-var468 'tmp))))))))
(%%gen-syntax-case2120
(lambda (%%x2212
%%keys2213
%%clauses2214
%%r2215
%%mr2216
%%m?2217)
(if (null? %%clauses2214)
(build-source
#f
(cons (build-source #f 'syntax-error)
(list (build-source #f %%x2212))))
((lambda (%%tmp2218)
((lambda (%%tmp2219)
(if %%tmp2219
(apply (lambda (%%pat2220 %%exp2221)
(if (if (%%id?251 %%pat2220)
(if (not (%%bound-id-member?387
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%pat2220
%%keys2213))
(not (%%ellipsis?464 %%pat2220))
#f)
#f)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%label2222
%%var2223)
(build-source
#f
(cons (build-source
#f
(list (build-source
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#f
'lambda)
(build-params #f (list %%var2223))
(%%chi443
%%exp2221
(%%extend-env240
%%label2222
(cons 'syntax (cons %%var2223 0))
%%r2215)
%%mr2216
(%%make-binding-wrap362
(list %%pat2220)
(list %%label2222)
'(()))
%%m?2217)))
(list (build-source #f %%x2212)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%gen-label307)
(%%gen-var468 %%pat2220))
(%%gen-clause2119
%%x2212
%%keys2213
(cdr %%clauses2214)
%%r2215
%%mr2216
%%m?2217
%%pat2220
#t
%%exp2221)))
%%tmp2219)
((lambda (%%tmp2224)
(if %%tmp2224
(apply (lambda (%%pat2225
%%fender2226
%%exp2227)
(%%gen-clause2119
%%x2212
%%keys2213
(cdr %%clauses2214)
%%r2215
%%mr2216
%%m?2217
%%pat2225
%%fender2226
%%exp2227))
%%tmp2224)
((lambda (%%_2228)
(syntax-error
(car %%clauses2214)
"invalid syntax-case clause"))
%%tmp2218)))
($syntax-dispatch
%%tmp2218
'(any any any)))))
($syntax-dispatch %%tmp2218 '(any any))))
(car %%clauses2214))))))
(lambda (%%e2229 %%r2230 %%mr2231 %%w2232 %%ae2233 %%m?2234)
((lambda (%%e2235)
((lambda (%%tmp2236)
((lambda (%%tmp2237)
(if %%tmp2237
(apply (lambda (%%_2238
%%val2239
%%key2240
%%m2241)
(if (andmap (lambda (%%x2242)
(if (%%id?251 %%x2242)
(not (%%ellipsis?464
%%x2242))
#f))
%%key2240)
((lambda (%%x2244)
(build-source
%%ae2233
(cons (build-source
#f
(list (build-source
#f
'lambda)
(build-params
#f
(list %%x2244))
(%%gen-syntax-case2120
%%x2244
%%key2240
%%m2241
%%r2230
%%mr2231
%%m?2234)))
(list (%%chi443
%%val2239
%%r2230
%%mr2231
'(())
%%m?2234)))))
(%%gen-var468 'tmp))
(syntax-error
%%e2235
"invalid literals list in")))
%%tmp2237)
(syntax-error %%tmp2236)))
($syntax-dispatch
%%tmp2236
'(any any each-any . each-any))))
%%e2235))
(%%source-wrap389 %%e2229 %%w2232 %%ae2233)))))))
(%%put-cte-hook72
'module
(lambda (%%x2247)
(letrec ((%%proper-export?2248
(lambda (%%e2249)
((lambda (%%tmp2250)
((lambda (%%tmp2251)
(if %%tmp2251
(apply (lambda (%%id2252 %%e2253)
(if (identifier? %%id2252)
(andmap %%proper-export?2248
%%e2253)
#f))
%%tmp2251)
((lambda (%%id2255) (identifier? %%id2255))
%%tmp2250)))
($syntax-dispatch %%tmp2250 '(any . each-any))))
%%e2249))))
((lambda (%%tmp2256)
((lambda (%%orig2257)
((lambda (%%tmp2258)
((lambda (%%tmp2259)
(if %%tmp2259
(apply (lambda (%%_2260 %%e2261 %%d2262)
(if (andmap %%proper-export?2248
%%e2261)
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
build-dsssl-lambda
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage
*top*
#t)))
(cons %%orig2257
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
(cons %%e2261 %%d2262))))
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage
*top*
#t)))
(cons %%orig2257
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(syntax-error
%%x2247
"invalid exports list in")))
%%tmp2259)
((lambda (%%tmp2266)
(if (if %%tmp2266
(apply (lambda (%%_2267
%%m2268
%%e2269
%%d2270)
(identifier? %%m2268))
%%tmp2266)
#f)
(apply (lambda (%%_2271
%%m2272
%%e2273
%%d2274)
(if (andmap %%proper-export?2248
%%e2273)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage
*top*
#t)))
(cons %%orig2257
(cons %%m2272
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(cons %%e2273 %%d2274))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(syntax-error
%%x2247
"invalid exports list in")))
%%tmp2266)
(syntax-error %%tmp2258)))
($syntax-dispatch
%%tmp2258
'(any any each-any . each-any)))))
($syntax-dispatch
%%tmp2258
'(any each-any . each-any))))
%%x2247))
%%tmp2256))
%%x2247))))
((lambda ()
(letrec ((%%$module-exports2278
(lambda (%%m2280 %%r2281)
((lambda (%%b2282)
((lambda (%%t2283)
(if (memv %%t2283 '($module))
((lambda (%%interface2284)
((lambda (%%new-marks2285)
((lambda ()
(%%vmap432
(lambda (%%x2286)
((lambda (%%id2287)
(%%make-syntax-object63
(syntax-object->datum
%%id2287)
((lambda (%%marks2288)
(%%make-wrap260
%%marks2288
(if (eq? (car %%marks2288)
#f)
(cons 'shift
(%%wrap-subst262
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'((top))))
(%%wrap-subst262 '((top))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%join-marks368
%%new-marks2285
(%%wrap-marks261
(%%syntax-object-wrap66
%%id2287))))))
(if (pair? %%x2286)
(car %%x2286)
%%x2286)))
(%%interface-exports399
%%interface2284)))))
(%%import-mark-delta450
%%m2280
%%interface2284)))
(%%binding-value227 %%b2282))
(if (memv %%t2283 '(displaced-lexical))
(%%displaced-lexical-error244 %%m2280)
(syntax-error
%%m2280
"unknown module"))))
(%%binding-type226 %%b2282)))
(%%r2281 %%m2280))))
(%%$import-help2279
(lambda (%%orig2289 %%import-only?2290)
(lambda (%%r2291)
(letrec ((%%difference2292
(lambda (%%ls12298 %%ls22299)
(if (null? %%ls12298)
%%ls12298
(if (%%bound-id-member?387
(car %%ls12298)
%%ls22299)
(%%difference2292
(cdr %%ls12298)
%%ls22299)
(cons (car %%ls12298)
(%%difference2292
(cdr %%ls12298)
%%ls22299))))))
(%%prefix-add2293
(lambda (%%prefix-id2300)
((lambda (%%prefix2301)
(lambda (%%id2302)
(datum->syntax-object
%%id2302
(string->symbol
(string-append
%%prefix2301
(symbol->string
(syntax-object->datum
%%id2302)))))))
(symbol->string
(syntax-object->datum
%%prefix-id2300)))))
(%%prefix-drop2294
(lambda (%%prefix-id2303)
((lambda (%%prefix2304)
(lambda (%%id2305)
((lambda (%%s2306)
((lambda (%%np2307 %%ns2308)
(begin
(if (not (if (>= %%ns2308
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%np2307)
(string=? (substring %%s2306 0 %%np2307) %%prefix2304)
#f))
(syntax-error
%%id2305
(string-append "missing expected prefix " %%prefix2304))
(void))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(datum->syntax-object
%%id2305
(string->symbol
(substring
%%s2306
%%np2307
%%ns2308)))))
(string-length %%prefix2304)
(string-length %%s2306)))
(symbol->string
(syntax-object->datum
%%id2305)))))
(symbol->string
(syntax-object->datum
%%prefix-id2303)))))
(%%gen-mid2295
(lambda (%%mid2309)
(datum->syntax-object
%%mid2309
(%%generate-id78
((lambda (%%x2310)
((lambda (%%e2311)
(if (annotation? %%e2311)
(annotation-expression
%%e2311)
%%e2311))
(if (%%syntax-object?64 %%x2310)
(%%syntax-object-expression65
%%x2310)
%%x2310)))
%%mid2309)))))
(%%modspec2296
(lambda (%%m2312 %%exports?2313)
((lambda (%%tmp2314)
((lambda (%%tmp2315)
(if %%tmp2315
(apply (lambda (%%orig2316
%%import-only?2317)
((lambda (%%tmp2318)
((lambda (%%tmp2319)
(if (if %%tmp2319
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(apply (lambda (%%m2320 %%id2321)
(andmap identifier? %%id2321))
%%tmp2319)
#f)
(apply (lambda (%%m2323 %%id2324)
(call-with-values
(lambda () (%%modspec2296 %%m2323 #f))
(lambda (%%mid2325 %%d2326 %%exports2327)
((lambda (%%tmp2328)
((lambda (%%tmp2329)
(if %%tmp2329
(apply (lambda (%%d2330
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmid2331)
(values %%mid2325
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
build-dsssl-lambda
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2316
%%tmid2331
%%id2324
%%d2330)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2316
%%import-only?2317
%%tmid2331))
(if %%exports?2313 %%id2324 #f)))
%%tmp2329)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(syntax-error %%tmp2328)))
($syntax-dispatch
%%tmp2328
'(any any))))
(list %%d2326
(%%gen-mid2295 %%mid2325))))))
%%tmp2319)
((lambda (%%tmp2334)
(if (if %%tmp2334
(apply (lambda (%%m2335 %%id2336)
(andmap identifier? %%id2336))
%%tmp2334)
#f)
(apply (lambda (%%m2338 %%id2339)
(call-with-values
(lambda ()
(%%modspec2296 %%m2338 #t))
(lambda (%%mid2340
%%d2341
%%exports2342)
((lambda (%%tmp2343)
((lambda (%%tmp2344)
(if %%tmp2344
(apply (lambda (%%d2345
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmid2346
%%id2347)
(values %%mid2340
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
build-dsssl-lambda
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2316
%%tmid2346
%%id2347
%%d2345)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2316
%%import-only?2317
%%tmid2346))
(if %%exports?2313 %%id2347 #f)))
%%tmp2344)
(syntax-error %%tmp2343)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2343
'(any any each-any))))
(list %%d2341
(%%gen-mid2295 %%mid2340)
(%%difference2292
%%exports2342
%%id2339))))))
%%tmp2334)
((lambda (%%tmp2351)
(if (if %%tmp2351
(apply (lambda (%%m2352
%%prefix-id2353)
(identifier?
%%prefix-id2353))
%%tmp2351)
#f)
(apply (lambda (%%m2354
%%prefix-id2355)
(call-with-values
(lambda ()
(%%modspec2296
%%m2354
#t))
(lambda (%%mid2356
%%d2357
%%exports2358)
((lambda (%%tmp2359)
((lambda (%%tmp2360)
(if %%tmp2360
(apply (lambda (%%d2361
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmid2362
%%old-id2363
%%tmp2364
%%id2365)
(values %%mid2356
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
build-dsssl-lambda
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage
*top*
#t)))
(cons %%orig2316
(cons %%tmid2362
(cons (map list
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%id2365
%%tmp2364)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
(cons %%orig2316
(cons %%tmid2362
(cons (map list
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmp2364
%%old-id2363)
(cons %%d2361
(map (lambda (%%tmp2371 %%tmp2370)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%tmp2370
%%tmp2371))
%%old-id2363
%%tmp2364))))))
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2316
%%import-only?2317
%%tmid2362)
(map (lambda (%%tmp2373 %%tmp2372)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage
*top*
#t)))
%%tmp2372
%%tmp2373))
%%tmp2364
%%id2365)))))))
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage
*top*
#t)))
%%orig2316
%%import-only?2317
%%tmid2362))
(if %%exports?2313 %%id2365 #f)))
%%tmp2360)
(syntax-error %%tmp2359)))
($syntax-dispatch
%%tmp2359
'(any any each-any each-any each-any))))
(list %%d2357
(%%gen-mid2295 %%mid2356)
%%exports2358
(generate-temporaries %%exports2358)
(map (%%prefix-add2293 %%prefix-id2355) %%exports2358))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2351)
((lambda (%%tmp2375)
(if (if %%tmp2375
(apply (lambda (%%m2376
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%prefix-id2377)
(identifier? %%prefix-id2377))
%%tmp2375)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#f)
(apply (lambda (%%m2378
%%prefix-id2379)
(call-with-values
(lambda ()
(%%modspec2296
%%m2378
#t))
(lambda (%%mid2380
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%d2381
%%exports2382)
((lambda (%%tmp2383)
((lambda (%%tmp2384)
(if %%tmp2384
(apply (lambda (%%d2385
%%tmid2386
%%old-id2387
%%tmp2388
%%id2389)
(values %%mid2380
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
build-dsssl-lambda
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
(cons %%orig2316
(cons %%tmid2386
(cons (map list %%id2389 %%tmp2388)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
(cons %%orig2316
(cons %%tmid2386
(cons (map list
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmp2388
%%old-id2387)
(cons %%d2385
(map (lambda (%%tmp2395 %%tmp2394)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%tmp2394
%%tmp2395))
%%old-id2387
%%tmp2388))))))
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage
*top*
#t)))
%%orig2316
%%import-only?2317
%%tmid2386)
(map (lambda (%%tmp2397
%%tmp2396)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%tmp2396
%%tmp2397))
%%tmp2388
%%id2389)))))))
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2316
%%import-only?2317
%%tmid2386))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(if %%exports?2313
%%id2389
#f)))
%%tmp2384)
(syntax-error %%tmp2383)))
($syntax-dispatch
%%tmp2383
'(any any each-any each-any each-any))))
(list %%d2381
(%%gen-mid2295 %%mid2380)
%%exports2382
(generate-temporaries %%exports2382)
(map (%%prefix-drop2294 %%prefix-id2379)
%%exports2382))))))
%%tmp2375)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2399)
(if (if %%tmp2399
(apply (lambda (%%m2400
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%new-id2401
%%old-id2402)
(if (andmap identifier? %%new-id2401)
(andmap identifier? %%old-id2402)
#f))
%%tmp2399)
#f)
(apply (lambda (%%m2405 %%new-id2406 %%old-id2407)
(call-with-values
(lambda () (%%modspec2296 %%m2405 #t))
(lambda (%%mid2408 %%d2409 %%exports2410)
((lambda (%%tmp2411)
((lambda (%%tmp2412)
(if %%tmp2412
(apply (lambda (%%d2413
%%tmid2414
%%tmp2415
%%other-id2416)
(values %%mid2408
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
build-dsssl-lambda
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
(cons %%orig2316
(cons %%tmid2414
(cons (append (map list
%%new-id2406
%%tmp2415)
%%other-id2416)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage
*top*
#t)))
(cons %%orig2316
(cons %%tmid2414
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(cons (append %%other-id2416
(map list %%tmp2415 %%old-id2407))
(cons %%d2413
(map (lambda (%%tmp2424 %%tmp2423)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage
*top*
#t)))
%%tmp2423
%%tmp2424))
%%old-id2407
%%tmp2415))))))
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2316
%%import-only?2317
%%tmid2414)
(map (lambda (%%tmp2426 %%tmp2425)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%tmp2425
%%tmp2426))
%%tmp2415
%%new-id2406)))))))
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2316
%%import-only?2317
%%tmid2414))
(if %%exports?2313 (append %%new-id2406 %%other-id2416) #f)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2412)
(syntax-error %%tmp2411)))
($syntax-dispatch
%%tmp2411
'(any any each-any each-any))))
(list %%d2409
(%%gen-mid2295 %%mid2408)
(generate-temporaries %%old-id2407)
(%%difference2292
%%exports2410
%%old-id2407))))))
%%tmp2399)
((lambda (%%tmp2431)
(if (if %%tmp2431
(apply (lambda (%%m2432 %%new-id2433 %%old-id2434)
(if (andmap identifier? %%new-id2433)
(andmap identifier? %%old-id2434)
#f))
%%tmp2431)
#f)
(apply (lambda (%%m2437 %%new-id2438 %%old-id2439)
(call-with-values
(lambda () (%%modspec2296 %%m2437 #t))
(lambda (%%mid2440 %%d2441 %%exports2442)
((lambda (%%tmp2443)
((lambda (%%tmp2444)
(if %%tmp2444
(apply (lambda (%%d2445
%%tmid2446
%%other-id2447)
(values %%mid2440
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
build-dsssl-lambda
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
(cons %%orig2316
(cons %%tmid2446
(cons (append (map list
%%new-id2438
%%old-id2439)
%%other-id2447)
(cons %%d2445
(map (lambda (%%tmp2452
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmp2451)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%tmp2451
%%tmp2452))
%%old-id2439
%%new-id2438))))))
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2316
%%import-only?2317
%%tmid2446))
(if %%exports?2313
(append %%new-id2438 %%other-id2447)
#f)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2444)
(syntax-error %%tmp2443)))
($syntax-dispatch
%%tmp2443
'(any any each-any))))
(list %%d2441
(%%gen-mid2295 %%mid2440)
%%exports2442)))))
%%tmp2431)
((lambda (%%tmp2455)
(if (if %%tmp2455
(apply (lambda (%%mid2456)
(identifier? %%mid2456))
%%tmp2455)
#f)
(apply (lambda (%%mid2457)
(values %%mid2457
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage
*top*
#t)))
%%orig2316
%%import-only?2317
%%mid2457)
(if %%exports?2313
(%%$module-exports2278
%%mid2457
%%r2291)
#f)))
%%tmp2455)
((lambda (%%tmp2458)
(if (if %%tmp2458
(apply (lambda (%%mid2459)
(identifier? %%mid2459))
%%tmp2458)
#f)
(apply (lambda (%%mid2460)
(values %%mid2460
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%orig2316
%%import-only?2317
%%mid2460)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(if %%exports?2313
(%%$module-exports2278
%%mid2460
%%r2291)
#f)))
%%tmp2458)
((lambda (%%_2461)
(syntax-error
%%m2312
"invalid module specifier"))
%%tmp2318)))
($syntax-dispatch %%tmp2318 '(any)))))
(list %%tmp2318))))
($syntax-dispatch
%%tmp2318
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t))))
any
.
#(each (any any)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2318
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage
*top*
#t))))
any
.
#(each (any any)))))))
($syntax-dispatch
%%tmp2318
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t))))
any
any)))))
($syntax-dispatch
%%tmp2318
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t))))
any
any)))))
($syntax-dispatch
%%tmp2318
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t))))
any
.
each-any)))))
($syntax-dispatch
%%tmp2318
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t))))
any
.
each-any))))
%%m2312))
%%tmp2315)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(syntax-error %%tmp2314)))
($syntax-dispatch
%%tmp2314
'(any any))))
(list %%orig2289 %%import-only?2290))))
(%%modspec*2297
(lambda (%%m2462)
(call-with-values
(lambda () (%%modspec2296 %%m2462 #f))
(lambda (%%mid2463
%%d2464
%%exports2465)
%%d2464)))))
((lambda (%%tmp2466)
((lambda (%%tmp2467)
(if %%tmp2467
(apply (lambda (%%_2468 %%m2469)
((lambda (%%tmp2470)
((lambda (%%tmp2471)
(if %%tmp2471
(apply (lambda (%%d2472)
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
build-dsssl-lambda
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
"i"
"i"))
#(top-ribcage *top* #t)))
%%d2472))
%%tmp2471)
(syntax-error %%tmp2470)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2470
'each-any)))
(map %%modspec*2297 %%m2469)))
%%tmp2467)
(syntax-error %%tmp2466)))
($syntax-dispatch
%%tmp2466
'(any . each-any))))
%%orig2289))))))
(begin
(%%put-cte-hook72
'import
(lambda (%%orig2475) (%%$import-help2279 %%orig2475 #f)))
(%%put-cte-hook72
'import-only
(lambda (%%orig2476) (%%$import-help2279 %%orig2476 #t)))))))
((lambda ()
(letrec ((%%make-sc-expander2477
(lambda (%%ctem2478 %%rtem2479)
(lambda (%%x2480)
((lambda (%%env2481)
(if (if (pair? %%x2480)
(equal? (car %%x2480) %%noexpand62)
#f)
(cadr %%x2480)
(%%chi-top*392
%%x2480
'()
(%%env-wrap333 %%env2481)
%%ctem2478
%%rtem2479
#f
(%%env-top-ribcage332 %%env2481))))
(interaction-environment))))))
(begin
(set! sc-expand
((lambda (%%ctem2482 %%rtem2483)
(%%make-sc-expander2477 %%ctem2482 %%rtem2483))
'(E)
'(E)))
(set! sc-compile-expand
((lambda (%%ctem2484 %%rtem2485)
(%%make-sc-expander2477 %%ctem2484 %%rtem2485))
'(L C)
'(L)))))))
(set! $make-environment
(lambda (%%token2486 %%mutable?2487)
((lambda (%%top-ribcage2488)
(%%make-env330
%%top-ribcage2488
(%%make-wrap260
(%%wrap-marks261 '((top)))
(cons %%top-ribcage2488 (%%wrap-subst262 '((top)))))))
(%%make-top-ribcage318 %%token2486 %%mutable?2487))))
(set! environment? (lambda (%%x2489) (%%env?331 %%x2489)))
(set! interaction-environment
((lambda (%%e2490) (lambda () %%e2490))
($make-environment '*top* #t)))
(set! identifier? (lambda (%%x2491) (%%nonsymbol-id?250 %%x2491)))
(set! datum->syntax-object
(lambda (%%id2492 %%datum2493)
(begin
((lambda (%%x2494)
(if (not (%%nonsymbol-id?250 %%x2494))
(error (string-append
"(in "
(symbol->string 'datum->syntax-object)
") invalid argument")
%%x2494)
(void)))
%%id2492)
(%%make-syntax-object63
%%datum2493
(%%syntax-object-wrap66 %%id2492)))))
(set! syntax->list
(lambda (%%orig-ls2495)
((letrec ((%%f2496 (lambda (%%ls2497)
((lambda (%%tmp2498)
((lambda (%%tmp2499)
(if %%tmp2499
(apply (lambda () '())
%%tmp2499)
((lambda (%%tmp2500)
(if %%tmp2500
(apply (lambda (%%x2501
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%r2502)
(cons %%x2501 (%%f2496 %%r2502)))
%%tmp2500)
((lambda (%%_2503)
(error "(in syntax->list) invalid argument" %%orig-ls2495))
%%tmp2498)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2498
'(any . any)))))
($syntax-dispatch %%tmp2498 '())))
%%ls2497))))
%%f2496)
%%orig-ls2495)))
(set! syntax->vector
(lambda (%%v2504)
((lambda (%%tmp2505)
((lambda (%%tmp2506)
(if %%tmp2506
(apply (lambda (%%x2507)
(list->vector (syntax->list %%x2507)))
%%tmp2506)
((lambda (%%_2509)
(error "(in syntax->vector) invalid argument"
%%v2504))
%%tmp2505)))
($syntax-dispatch %%tmp2505 '#(vector each-any))))
%%v2504)))
(set! syntax-object->datum
(lambda (%%x2510) (%%strip467 %%x2510 '(()))))
(set! generate-temporaries
((lambda (%%n2511)
(lambda (%%ls2512)
(begin
((lambda (%%x2513)
(if (not (list? %%x2513))
(error (string-append
"(in "
(symbol->string 'generate-temporaries)
") invalid argument")
%%x2513)
(void)))
%%ls2512)
(map (lambda (%%x2514)
(begin
(set! %%n2511 (+ %%n2511 1))
(%%wrap388
(string->symbol
(string-append "t" (number->string %%n2511)))
'((tmp)))))
%%ls2512))))
0))
(set! free-identifier=?
(lambda (%%x2515 %%y2516)
(begin
((lambda (%%x2517)
(if (not (%%nonsymbol-id?250 %%x2517))
(error (string-append
"(in "
(symbol->string 'free-identifier=?)
") invalid argument")
%%x2517)
(void)))
%%x2515)
((lambda (%%x2518)
(if (not (%%nonsymbol-id?250 %%x2518))
(error (string-append
"(in "
(symbol->string 'free-identifier=?)
") invalid argument")
%%x2518)
(void)))
%%y2516)
(%%free-id=?380 %%x2515 %%y2516))))
(set! bound-identifier=?
(lambda (%%x2519 %%y2520)
(begin
((lambda (%%x2521)
(if (not (%%nonsymbol-id?250 %%x2521))
(error (string-append
"(in "
(symbol->string 'bound-identifier=?)
") invalid argument")
%%x2521)
(void)))
%%x2519)
((lambda (%%x2522)
(if (not (%%nonsymbol-id?250 %%x2522))
(error (string-append
"(in "
(symbol->string 'bound-identifier=?)
") invalid argument")
%%x2522)
(void)))
%%y2520)
(%%bound-id=?383 %%x2519 %%y2520))))
(set! literal-identifier=?
(lambda (%%x2523 %%y2524)
(begin
((lambda (%%x2525)
(if (not (%%nonsymbol-id?250 %%x2525))
(error (string-append
"(in "
(symbol->string 'literal-identifier=?)
") invalid argument")
%%x2525)
(void)))
%%x2523)
((lambda (%%x2526)
(if (not (%%nonsymbol-id?250 %%x2526))
(error (string-append
"(in "
(symbol->string 'literal-identifier=?)
") invalid argument")
%%x2526)
(void)))
%%y2524)
(%%literal-id=?381 %%x2523 %%y2524))))
(set! syntax-error
(lambda (%%object2528 . %%messages2527)
(begin
(for-each
(lambda (%%x2529)
((lambda (%%x2530)
(if (not (string? %%x2530))
(error (string-append
"(in "
(symbol->string 'syntax-error)
") invalid argument")
%%x2530)
(void)))
%%x2529))
%%messages2527)
((lambda (%%message2531)
(error %%message2531 (%%strip467 %%object2528 '(()))))
(if (null? %%messages2527)
"invalid syntax"
(apply string-append %%messages2527))))))
((lambda ()
(letrec ((%%match-each2532
(lambda (%%e2539 %%p2540 %%w2541)
(if (annotation? %%e2539)
(%%match-each2532
(annotation-expression %%e2539)
%%p2540
%%w2541)
(if (pair? %%e2539)
((lambda (%%first2542)
(if %%first2542
((lambda (%%rest2543)
(if %%rest2543
(cons %%first2542 %%rest2543)
#f))
(%%match-each2532
(cdr %%e2539)
%%p2540
%%w2541))
#f))
(%%match2538
(car %%e2539)
%%p2540
%%w2541
'()))
(if (null? %%e2539)
'()
(if (%%syntax-object?64 %%e2539)
(%%match-each2532
(%%syntax-object-expression65 %%e2539)
%%p2540
(%%join-wraps367
%%w2541
(%%syntax-object-wrap66 %%e2539)))
#f))))))
(%%match-each+2533
(lambda (%%e2544
%%x-pat2545
%%y-pat2546
%%z-pat2547
%%w2548
%%r2549)
((letrec ((%%f2550 (lambda (%%e2551 %%w2552)
(if (pair? %%e2551)
(call-with-values
(lambda ()
(%%f2550 (cdr %%e2551)
%%w2552))
(lambda (%%xr*2553
%%y-pat2554
%%r2555)
(if %%r2555
(if (null? %%y-pat2554)
((lambda (%%xr2556)
(if %%xr2556
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(values (cons %%xr2556 %%xr*2553)
%%y-pat2554
%%r2555)
(values #f #f #f)))
(%%match2538 (car %%e2551) %%x-pat2545 %%w2552 '()))
(values '()
(cdr %%y-pat2554)
(%%match2538
(car %%e2551)
(car %%y-pat2554)
%%w2552
%%r2555)))
(values #f #f #f))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(if (annotation? %%e2551)
(%%f2550 (annotation-expression
%%e2551)
%%w2552)
(if (%%syntax-object?64
%%e2551)
(%%f2550 (%%syntax-object-expression65
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e2551)
(%%join-wraps367
%%w2552
(%%syntax-object-wrap66 %%e2551)))
(values '()
%%y-pat2546
(%%match2538
%%e2551
%%z-pat2547
%%w2552
%%r2549))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f2550)
%%e2544
%%w2548)))
(%%match-each-any2534
(lambda (%%e2557 %%w2558)
(if (annotation? %%e2557)
(%%match-each-any2534
(annotation-expression %%e2557)
%%w2558)
(if (pair? %%e2557)
((lambda (%%l2559)
(if %%l2559
(cons (%%wrap388 (car %%e2557) %%w2558)
%%l2559)
#f))
(%%match-each-any2534 (cdr %%e2557) %%w2558))
(if (null? %%e2557)
'()
(if (%%syntax-object?64 %%e2557)
(%%match-each-any2534
(%%syntax-object-expression65 %%e2557)
(%%join-wraps367
%%w2558
(%%syntax-object-wrap66 %%e2557)))
#f))))))
(%%match-empty2535
(lambda (%%p2560 %%r2561)
(if (null? %%p2560)
%%r2561
(if (eq? %%p2560 'any)
(cons '() %%r2561)
(if (pair? %%p2560)
(%%match-empty2535
(car %%p2560)
(%%match-empty2535 (cdr %%p2560) %%r2561))
(if (eq? %%p2560 'each-any)
(cons '() %%r2561)
((lambda (%%t2562)
(if (memv %%t2562 '(each))
(%%match-empty2535
(vector-ref %%p2560 1)
%%r2561)
(if (memv %%t2562 '(each+))
(%%match-empty2535
(vector-ref %%p2560 1)
(%%match-empty2535
(reverse (vector-ref
%%p2560
2))
(%%match-empty2535
(vector-ref %%p2560 3)
%%r2561)))
(if (memv %%t2562
'(free-id atom))
%%r2561
(if (memv %%t2562
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
'(vector))
(%%match-empty2535 (vector-ref %%p2560 1) %%r2561)
(void))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(vector-ref %%p2560 0))))))))
(%%combine2536
(lambda (%%r*2563 %%r2564)
(if (null? (car %%r*2563))
%%r2564
(cons (map car %%r*2563)
(%%combine2536
(map cdr %%r*2563)
%%r2564)))))
(%%match*2537
(lambda (%%e2565 %%p2566 %%w2567 %%r2568)
(if (null? %%p2566)
(if (null? %%e2565) %%r2568 #f)
(if (pair? %%p2566)
(if (pair? %%e2565)
(%%match2538
(car %%e2565)
(car %%p2566)
%%w2567
(%%match2538
(cdr %%e2565)
(cdr %%p2566)
%%w2567
%%r2568))
#f)
(if (eq? %%p2566 'each-any)
((lambda (%%l2569)
(if %%l2569 (cons %%l2569 %%r2568) #f))
(%%match-each-any2534 %%e2565 %%w2567))
((lambda (%%t2570)
(if (memv %%t2570 '(each))
(if (null? %%e2565)
(%%match-empty2535
(vector-ref %%p2566 1)
%%r2568)
((lambda (%%r*2571)
(if %%r*2571
(%%combine2536
%%r*2571
%%r2568)
#f))
(%%match-each2532
%%e2565
(vector-ref %%p2566 1)
%%w2567)))
(if (memv %%t2570 '(free-id))
(if (%%id?251 %%e2565)
(if (%%literal-id=?381
(%%wrap388
%%e2565
%%w2567)
(vector-ref %%p2566 1))
%%r2568
#f)
#f)
(if (memv %%t2570 '(each+))
(call-with-values
(lambda ()
(%%match-each+2533
%%e2565
(vector-ref %%p2566 1)
(vector-ref %%p2566 2)
(vector-ref %%p2566 3)
%%w2567
%%r2568))
(lambda (%%xr*2572
%%y-pat2573
%%r2574)
(if %%r2574
(if (null? %%y-pat2573)
(if (null? %%xr*2572)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(%%match-empty2535 (vector-ref %%p2566 1) %%r2574)
(%%combine2536 %%xr*2572 %%r2574))
#f)
#f)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(if (memv %%t2570 '(atom))
(if (equal? (vector-ref
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%p2566
1)
(%%strip467 %%e2565 %%w2567))
%%r2568
#f)
(if (memv %%t2570 '(vector))
(if (vector? %%e2565)
(%%match2538
(vector->list %%e2565)
(vector-ref %%p2566 1)
%%w2567
%%r2568)
#f)
(void)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(vector-ref %%p2566 0)))))))
(%%match2538
(lambda (%%e2575 %%p2576 %%w2577 %%r2578)
(if (not %%r2578)
#f
(if (eq? %%p2576 'any)
(cons (%%wrap388 %%e2575 %%w2577) %%r2578)
(if (%%syntax-object?64 %%e2575)
(%%match*2537
((lambda (%%e2579)
(if (annotation? %%e2579)
(annotation-expression %%e2579)
%%e2579))
(%%syntax-object-expression65 %%e2575))
%%p2576
(%%join-wraps367
%%w2577
(%%syntax-object-wrap66 %%e2575))
%%r2578)
(%%match*2537
((lambda (%%e2580)
(if (annotation? %%e2580)
(annotation-expression %%e2580)
%%e2580))
%%e2575)
%%p2576
%%w2577
%%r2578)))))))
(set! $syntax-dispatch
(lambda (%%e2581 %%p2582)
(if (eq? %%p2582 'any)
(list %%e2581)
(if (%%syntax-object?64 %%e2581)
(%%match*2537
((lambda (%%e2583)
(if (annotation? %%e2583)
(annotation-expression %%e2583)
%%e2583))
(%%syntax-object-expression65 %%e2581))
%%p2582
(%%syntax-object-wrap66 %%e2581)
'())
(%%match*2537
((lambda (%%e2584)
(if (annotation? %%e2584)
(annotation-expression %%e2584)
%%e2584))
%%e2581)
%%p2582
'(())
'()))))))))))))
($sc-put-cte
'#(syntax-object
with-syntax
((top) #(ribcage #(with-syntax) #((top)) #(with-syntax))))
(lambda (%%x2585)
((lambda (%%tmp2586)
((lambda (%%tmp2587)
(if %%tmp2587
(apply (lambda (%%_2588 %%e12589 %%e22590)
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
(cons %%e12589 %%e22590)))
%%tmp2587)
((lambda (%%tmp2592)
(if %%tmp2592
(apply (lambda (%%_2593
%%out2594
%%in2595
%%e12596
%%e22597)
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
%%in2595
'()
(list %%out2594
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
(cons %%e12596 %%e22597)))))
%%tmp2592)
((lambda (%%tmp2599)
(if %%tmp2599
(apply (lambda (%%_2600
%%out2601
%%in2602
%%e12603
%%e22604)
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
%%in2602)
'()
(list %%out2601
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
(cons %%e12603
%%e22604)))))
%%tmp2599)
(syntax-error %%tmp2586)))
($syntax-dispatch
%%tmp2586
'(any #(each (any any)) any . each-any)))))
($syntax-dispatch
%%tmp2586
'(any ((any any)) any . each-any)))))
($syntax-dispatch %%tmp2586 '(any () any . each-any))))
%%x2585))
'*top*)
($sc-put-cte
'#(syntax-object
with-implicit
((top) #(ribcage #(with-implicit) #((top)) #(with-implicit))))
(lambda (%%x2608)
((lambda (%%tmp2609)
((lambda (%%tmp2610)
(if (if %%tmp2610
(apply (lambda (%%dummy2611
%%tid2612
%%id2613
%%e12614
%%e22615)
(andmap identifier? (cons %%tid2612 %%id2613)))
%%tmp2610)
#f)
(apply (lambda (%%dummy2617
%%tid2618
%%id2619
%%e12620
%%e22621)
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
%%tid2618))
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
%%tid2618)
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
(cons (map (lambda (%%tmp2622)
(list %%tmp2622
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
%%tid2618)
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
%%tmp2622))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%id2619)
(cons %%e12620 %%e22621)))))
%%tmp2610)
(syntax-error %%tmp2609)))
($syntax-dispatch %%tmp2609 '(any (any . each-any) any . each-any))))
%%x2608))
'*top*)
($sc-put-cte
'#(syntax-object datum ((top) #(ribcage #(datum) #((top)) #(datum))))
(lambda (%%x2624)
((lambda (%%tmp2625)
((lambda (%%tmp2626)
(if %%tmp2626
(apply (lambda (%%dummy2627 %%x2628)
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
%%x2628)))
%%tmp2626)
(syntax-error %%tmp2625)))
($syntax-dispatch %%tmp2625 '(any any))))
%%x2624))
'*top*)
($sc-put-cte
'#(syntax-object
syntax-rules
((top) #(ribcage #(syntax-rules) #((top)) #(syntax-rules))))
(lambda (%%x2629)
(letrec ((%%clause2630
(lambda (%%y2631)
((lambda (%%tmp2632)
((lambda (%%tmp2633)
(if %%tmp2633
(apply (lambda (%%keyword2634
%%pattern2635
%%template2636)
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
%%pattern2635)
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
%%template2636)))
%%tmp2633)
((lambda (%%tmp2637)
(if %%tmp2637
(apply (lambda (%%keyword2638
%%pattern2639
%%fender2640
%%template2641)
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
%%pattern2639)
%%fender2640
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
%%template2641)))
%%tmp2637)
((lambda (%%_2642) (syntax-error %%x2629))
%%tmp2632)))
($syntax-dispatch
%%tmp2632
'((any . any) any any)))))
($syntax-dispatch %%tmp2632 '((any . any) any))))
%%y2631))))
((lambda (%%tmp2643)
((lambda (%%tmp2644)
(if (if %%tmp2644
(apply (lambda (%%_2645 %%k2646 %%cl2647)
(andmap identifier? %%k2646))
%%tmp2644)
#f)
(apply (lambda (%%_2649 %%k2650 %%cl2651)
((lambda (%%tmp2652)
((lambda (%%tmp2653)
(if %%tmp2653
(apply (lambda (%%cl2654)
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
(cons %%k2650 %%cl2654)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2653)
(syntax-error %%tmp2652)))
($syntax-dispatch %%tmp2652 'each-any)))
(map %%clause2630 %%cl2651)))
%%tmp2644)
(syntax-error %%tmp2643)))
($syntax-dispatch %%tmp2643 '(any each-any . each-any))))
%%x2629)))
'*top*)
($sc-put-cte
'#(syntax-object or ((top) #(ribcage #(or) #((top)) #(or))))
(lambda (%%x2658)
((lambda (%%tmp2659)
((lambda (%%tmp2660)
(if %%tmp2660
(apply (lambda (%%_2661)
'#(syntax-object
#f
((top)
#(ribcage #(_) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
%%tmp2660)
((lambda (%%tmp2662)
(if %%tmp2662
(apply (lambda (%%_2663 %%e2664) %%e2664) %%tmp2662)
((lambda (%%tmp2665)
(if %%tmp2665
(apply (lambda (%%_2666
%%e12667
%%e22668
%%e32669)
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
%%e12667))
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
(cons %%e22668
%%e32669)))))
%%tmp2665)
(syntax-error %%tmp2659)))
($syntax-dispatch
%%tmp2659
'(any any any . each-any)))))
($syntax-dispatch %%tmp2659 '(any any)))))
($syntax-dispatch %%tmp2659 '(any))))
%%x2658))
'*top*)
($sc-put-cte
'#(syntax-object and ((top) #(ribcage #(and) #((top)) #(and))))
(lambda (%%x2671)
((lambda (%%tmp2672)
((lambda (%%tmp2673)
(if %%tmp2673
(apply (lambda (%%_2674 %%e12675 %%e22676 %%e32677)
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
(cons %%e12675
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
(cons %%e22676 %%e32677))
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
%%tmp2673)
((lambda (%%tmp2679)
(if %%tmp2679
(apply (lambda (%%_2680 %%e2681) %%e2681) %%tmp2679)
((lambda (%%tmp2682)
(if %%tmp2682
(apply (lambda (%%_2683)
'#(syntax-object
#t
((top)
#(ribcage #(_) #((top)) #("i"))
#(ribcage () () ())
#(ribcage #(x) #((top)) #("i"))
#(top-ribcage *top* #t))))
%%tmp2682)
(syntax-error %%tmp2672)))
($syntax-dispatch %%tmp2672 '(any)))))
($syntax-dispatch %%tmp2672 '(any any)))))
($syntax-dispatch %%tmp2672 '(any any any . each-any))))
%%x2671))
'*top*)
($sc-put-cte
'#(syntax-object let ((top) #(ribcage #(let) #((top)) #(let))))
(lambda (%%x2684)
((lambda (%%tmp2685)
((lambda (%%tmp2686)
(if (if %%tmp2686
(apply (lambda (%%_2687 %%x2688 %%v2689 %%e12690 %%e22691)
(andmap identifier? %%x2688))
%%tmp2686)
#f)
(apply (lambda (%%_2693 %%x2694 %%v2695 %%e12696 %%e22697)
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
(cons %%x2694 (cons %%e12696 %%e22697)))
%%v2695))
%%tmp2686)
((lambda (%%tmp2701)
(if (if %%tmp2701
(apply (lambda (%%_2702
%%f2703
%%x2704
%%v2705
%%e12706
%%e22707)
(andmap identifier? (cons %%f2703 %%x2704)))
%%tmp2701)
#f)
(apply (lambda (%%_2709
%%f2710
%%x2711
%%v2712
%%e12713
%%e22714)
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
(list (list %%f2710
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
(cons %%x2711 (cons %%e12713 %%e22714)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%f2710)
%%v2712))
%%tmp2701)
(syntax-error %%tmp2685)))
($syntax-dispatch
%%tmp2685
'(any any #(each (any any)) any . each-any)))))
($syntax-dispatch %%tmp2685 '(any #(each (any any)) any . each-any))))
%%x2684))
'*top*)
($sc-put-cte
'#(syntax-object let* ((top) #(ribcage #(let*) #((top)) #(let*))))
(lambda (%%x2718)
((lambda (%%tmp2719)
((lambda (%%tmp2720)
(if (if %%tmp2720
(apply (lambda (%%let*2721
%%x2722
%%v2723
%%e12724
%%e22725)
(andmap identifier? %%x2722))
%%tmp2720)
#f)
(apply (lambda (%%let*2727 %%x2728 %%v2729 %%e12730 %%e22731)
((letrec ((%%f2732 (lambda (%%bindings2733)
(if (null? %%bindings2733)
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
(cons %%e12730
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e22731)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2735)
((lambda (%%tmp2736)
(if %%tmp2736
(apply (lambda (%%body2737
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%binding2738)
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
(list %%binding2738)
%%body2737))
%%tmp2736)
(syntax-error %%tmp2735)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2735
'(any any))))
(list (%%f2732 (cdr %%bindings2733))
(car %%bindings2733)))))))
%%f2732)
(map list %%x2728 %%v2729)))
%%tmp2720)
(syntax-error %%tmp2719)))
($syntax-dispatch %%tmp2719 '(any #(each (any any)) any . each-any))))
%%x2718))
'*top*)
($sc-put-cte
'#(syntax-object cond ((top) #(ribcage #(cond) #((top)) #(cond))))
(lambda (%%x2741)
((lambda (%%tmp2742)
((lambda (%%tmp2743)
(if %%tmp2743
(apply (lambda (%%_2744 %%m12745 %%m22746)
((letrec ((%%f2747 (lambda (%%clause2748 %%clauses2749)
(if (null? %%clauses2749)
((lambda (%%tmp2750)
((lambda (%%tmp2751)
(if %%tmp2751
(apply (lambda (%%e12752
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e22753)
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
(cons %%e12752 %%e22753)))
%%tmp2751)
((lambda (%%tmp2755)
(if %%tmp2755
(apply (lambda (%%e02756)
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
%%e02756))
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
%%tmp2755)
((lambda (%%tmp2757)
(if %%tmp2757
(apply (lambda (%%e02758 %%e12759)
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
%%e02758))
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
(cons %%e12759
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
%%tmp2757)
((lambda (%%tmp2760)
(if %%tmp2760
(apply (lambda (%%e02761
%%e12762
%%e22763)
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
%%e02761
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
(cons %%e12762 %%e22763))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2760)
((lambda (%%_2765)
(syntax-error %%x2741))
%%tmp2750)))
($syntax-dispatch
%%tmp2750
'(any any . each-any)))))
($syntax-dispatch
%%tmp2750
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
($syntax-dispatch %%tmp2750 '(any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2750
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
%%clause2748)
((lambda (%%tmp2766)
((lambda (%%rest2767)
((lambda (%%tmp2768)
((lambda (%%tmp2769)
(if %%tmp2769
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(apply (lambda (%%e02770)
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
%%e02770))
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
%%rest2767)))
%%tmp2769)
((lambda (%%tmp2771)
(if %%tmp2771
(apply (lambda (%%e02772 %%e12773)
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
%%e02772))
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
(cons %%e12773
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
%%rest2767)))
%%tmp2771)
((lambda (%%tmp2774)
(if %%tmp2774
(apply (lambda (%%e02775
%%e12776
%%e22777)
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
%%e02775
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
(cons %%e12776 %%e22777))
%%rest2767))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2774)
((lambda (%%_2779)
(syntax-error %%x2741))
%%tmp2768)))
($syntax-dispatch
%%tmp2768
'(any any . each-any)))))
($syntax-dispatch
%%tmp2768
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
($syntax-dispatch %%tmp2768 '(any))))
%%clause2748))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2766))
(%%f2747 (car %%clauses2749)
(cdr %%clauses2749)))))))
%%f2747)
%%m12745
%%m22746))
%%tmp2743)
(syntax-error %%tmp2742)))
($syntax-dispatch %%tmp2742 '(any any . each-any))))
%%x2741))
'*top*)
($sc-put-cte
'#(syntax-object do ((top) #(ribcage #(do) #((top)) #(do))))
(lambda (%%orig-x2781)
((lambda (%%tmp2782)
((lambda (%%tmp2783)
(if %%tmp2783
(apply (lambda (%%_2784
%%var2785
%%init2786
%%step2787
%%e02788
%%e12789
%%c2790)
((lambda (%%tmp2791)
((lambda (%%tmp2792)
(if %%tmp2792
(apply (lambda (%%step2793)
((lambda (%%tmp2794)
((lambda (%%tmp2795)
(if %%tmp2795
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
(map list %%var2785 %%init2786)
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
%%e02788)
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
(append %%c2790
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
%%step2793)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2795)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2800)
(if %%tmp2800
(apply (lambda (%%e12801
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e22802)
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
(map list %%var2785 %%init2786)
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
%%e02788
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
(cons %%e12801 %%e22802))
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
(append %%c2790
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
%%step2793)))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2800)
(syntax-error %%tmp2794)))
($syntax-dispatch %%tmp2794 '(any . each-any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2794
'())))
%%e12789))
%%tmp2792)
(syntax-error %%tmp2791)))
($syntax-dispatch %%tmp2791 'each-any)))
(map (lambda (%%v2809 %%s2810)
((lambda (%%tmp2811)
((lambda (%%tmp2812)
(if %%tmp2812
(apply (lambda () %%v2809) %%tmp2812)
((lambda (%%tmp2813)
(if %%tmp2813
(apply (lambda (%%e2814)
%%e2814)
%%tmp2813)
((lambda (%%_2815)
(syntax-error
%%orig-x2781))
%%tmp2811)))
($syntax-dispatch
%%tmp2811
'(any)))))
($syntax-dispatch %%tmp2811 '())))
%%s2810))
%%var2785
%%step2787)))
%%tmp2783)
(syntax-error %%tmp2782)))
($syntax-dispatch
%%tmp2782
'(any #(each (any any . any)) (any . each-any) . each-any))))
%%orig-x2781))
'*top*)
($sc-put-cte
'#(syntax-object
quasiquote
((top) #(ribcage #(quasiquote) #((top)) #(quasiquote))))
((lambda ()
(letrec ((%%quasi2818
(lambda (%%p2825 %%lev2826)
((lambda (%%tmp2827)
((lambda (%%tmp2828)
(if %%tmp2828
(apply (lambda (%%p2829)
(if (= %%lev2826 0)
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
%%p2829)
(%%quasicons2820
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
(%%quasi2818
(list %%p2829)
(- %%lev2826 1)))))
%%tmp2828)
((lambda (%%tmp2830)
(if %%tmp2830
(apply (lambda (%%p2831)
(%%quasicons2820
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
(%%quasi2818
(list %%p2831)
(+ %%lev2826 1))))
%%tmp2830)
((lambda (%%tmp2832)
(if %%tmp2832
(apply (lambda (%%p2833 %%q2834)
((lambda (%%tmp2835)
((lambda (%%tmp2836)
(if %%tmp2836
(apply (lambda (%%p2837)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (= %%lev2826 0)
(%%quasilist*2822
(map (lambda (%%tmp2838)
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
%%tmp2838))
%%p2837)
(%%quasi2818 %%q2834 %%lev2826))
(%%quasicons2820
(%%quasicons2820
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
(%%quasi2818 %%p2837 (- %%lev2826 1)))
(%%quasi2818 %%q2834 %%lev2826))))
%%tmp2836)
((lambda (%%tmp2840)
(if %%tmp2840
(apply (lambda (%%p2841)
(if (= %%lev2826 0)
(%%quasiappend2821
(map (lambda (%%tmp2842)
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
%%tmp2842))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%p2841)
(%%quasi2818 %%q2834 %%lev2826))
(%%quasicons2820
(%%quasicons2820
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
(%%quasi2818
%%p2841
(- %%lev2826 1)))
(%%quasi2818 %%q2834 %%lev2826))))
%%tmp2840)
((lambda (%%_2844)
(%%quasicons2820
(%%quasi2818 %%p2833 %%lev2826)
(%%quasi2818 %%q2834 %%lev2826)))
%%tmp2835)))
($syntax-dispatch
%%tmp2835
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
%%tmp2835
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
%%p2833))
%%tmp2832)
((lambda (%%tmp2845)
(if %%tmp2845
(apply (lambda (%%x2846)
(%%quasivector2823
(%%vquasi2819
%%x2846
%%lev2826)))
%%tmp2845)
((lambda (%%p2848)
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
%%p2848))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2827)))
($syntax-dispatch
%%tmp2827
'#(vector each-any)))))
($syntax-dispatch
%%tmp2827
'(any . any)))))
($syntax-dispatch
%%tmp2827
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
%%tmp2827
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
%%p2825)))
(%%vquasi2819
(lambda (%%p2849 %%lev2850)
((lambda (%%tmp2851)
((lambda (%%tmp2852)
(if %%tmp2852
(apply (lambda (%%p2853 %%q2854)
((lambda (%%tmp2855)
((lambda (%%tmp2856)
(if %%tmp2856
(apply (lambda (%%p2857)
(if (= %%lev2850 0)
(%%quasilist*2822
(map (lambda (%%tmp2858)
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
%%tmp2858))
%%p2857)
(%%vquasi2819 %%q2854 %%lev2850))
(%%quasicons2820
(%%quasicons2820
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
(%%quasi2818 %%p2857 (- %%lev2850 1)))
(%%vquasi2819 %%q2854 %%lev2850))))
%%tmp2856)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2860)
(if %%tmp2860
(apply (lambda (%%p2861)
(if (= %%lev2850
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
0)
(%%quasiappend2821
(map (lambda (%%tmp2862)
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
%%tmp2862))
%%p2861)
(%%vquasi2819 %%q2854 %%lev2850))
(%%quasicons2820
(%%quasicons2820
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
(%%quasi2818 %%p2861 (- %%lev2850 1)))
(%%vquasi2819 %%q2854 %%lev2850))))
%%tmp2860)
((lambda (%%_2864)
(%%quasicons2820
(%%quasi2818 %%p2853 %%lev2850)
(%%vquasi2819 %%q2854 %%lev2850)))
%%tmp2855)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2855
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
%%tmp2855
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
%%p2853))
%%tmp2852)
((lambda (%%tmp2865)
(if %%tmp2865
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
%%tmp2865)
(syntax-error %%tmp2851)))
($syntax-dispatch %%tmp2851 '()))))
($syntax-dispatch %%tmp2851 '(any . any))))
%%p2849)))
(%%quasicons2820
(lambda (%%x2866 %%y2867)
((lambda (%%tmp2868)
((lambda (%%tmp2869)
(if %%tmp2869
(apply (lambda (%%x2870 %%y2871)
((lambda (%%tmp2872)
((lambda (%%tmp2873)
(if %%tmp2873
(apply (lambda (%%dy2874)
((lambda (%%tmp2875)
((lambda (%%tmp2876)
(if %%tmp2876
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(apply (lambda (%%dx2877)
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
(cons %%dx2877 %%dy2874)))
%%tmp2876)
((lambda (%%_2878)
(if (null? %%dy2874)
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
%%x2870)
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
%%x2870
%%y2871)))
%%tmp2875)))
($syntax-dispatch %%tmp2875 '(#(atom "quote") any))))
%%x2870))
%%tmp2873)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2879)
(if %%tmp2879
(apply (lambda (%%stuff2880)
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
(cons %%x2870 %%stuff2880)))
%%tmp2879)
((lambda (%%tmp2881)
(if %%tmp2881
(apply (lambda (%%stuff2882)
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
(cons %%x2870 %%stuff2882)))
%%tmp2881)
((lambda (%%_2883)
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
%%x2870
%%y2871))
%%tmp2872)))
($syntax-dispatch %%tmp2872 '(#(atom "list*") . any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2872
'(#(atom "list") . any)))))
($syntax-dispatch
%%tmp2872
'(#(atom "quote") any))))
%%y2871))
%%tmp2869)
(syntax-error %%tmp2868)))
($syntax-dispatch %%tmp2868 '(any any))))
(list %%x2866 %%y2867))))
(%%quasiappend2821
(lambda (%%x2884 %%y2885)
((lambda (%%tmp2886)
((lambda (%%tmp2887)
(if %%tmp2887
(apply (lambda ()
(if (null? %%x2884)
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
(if (null? (cdr %%x2884))
(car %%x2884)
((lambda (%%tmp2888)
((lambda (%%tmp2889)
(if %%tmp2889
(apply (lambda (%%p2890)
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
%%p2890))
%%tmp2889)
(syntax-error %%tmp2888)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2888
'each-any)))
%%x2884))))
%%tmp2887)
((lambda (%%_2892)
(if (null? %%x2884)
%%y2885
((lambda (%%tmp2893)
((lambda (%%tmp2894)
(if %%tmp2894
(apply (lambda (%%p2895 %%y2896)
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
(append %%p2895 (list %%y2896))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2894)
(syntax-error %%tmp2893)))
($syntax-dispatch
%%tmp2893
'(each-any any))))
(list %%x2884 %%y2885))))
%%tmp2886)))
($syntax-dispatch %%tmp2886 '(#(atom "quote") ()))))
%%y2885)))
(%%quasilist*2822
(lambda (%%x2898 %%y2899)
((letrec ((%%f2900 (lambda (%%x2901)
(if (null? %%x2901)
%%y2899
(%%quasicons2820
(car %%x2901)
(%%f2900 (cdr %%x2901)))))))
%%f2900)
%%x2898)))
(%%quasivector2823
(lambda (%%x2902)
((lambda (%%tmp2903)
((lambda (%%tmp2904)
(if %%tmp2904
(apply (lambda (%%x2905)
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
(list->vector %%x2905)))
%%tmp2904)
((lambda (%%_2907)
((letrec ((%%f2908 (lambda (%%y2909 %%k2910)
((lambda (%%tmp2911)
((lambda (%%tmp2912)
(if %%tmp2912
(apply (lambda (%%y2913)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(%%k2910 (map (lambda (%%tmp2914)
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
%%tmp2914))
%%y2913)))
%%tmp2912)
((lambda (%%tmp2915)
(if %%tmp2915
(apply (lambda (%%y2916) (%%k2910 %%y2916))
%%tmp2915)
((lambda (%%tmp2918)
(if %%tmp2918
(apply (lambda (%%y2919 %%z2920)
(%%f2908 %%z2920
(lambda (%%ls2921)
(%%k2910 (append %%y2919
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%ls2921)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2918)
((lambda (%%else2923)
((lambda (%%tmp2924)
((lambda (%%t12925)
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
%%t12925))
%%tmp2924))
%%x2902))
%%tmp2911)))
($syntax-dispatch
%%tmp2911
'(#(atom "list*") . #(each+ any (any) ()))))))
($syntax-dispatch
%%tmp2911
'(#(atom "list") . each-any)))))
($syntax-dispatch %%tmp2911 '(#(atom "quote") each-any))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%y2909))))
%%f2908)
%%x2902
(lambda (%%ls2926)
((lambda (%%tmp2927)
((lambda (%%tmp2928)
(if %%tmp2928
(apply (lambda (%%t22929)
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
%%t22929))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2928)
(syntax-error %%tmp2927)))
($syntax-dispatch %%tmp2927 'each-any)))
%%ls2926))))
%%tmp2903)))
($syntax-dispatch
%%tmp2903
'(#(atom "quote") each-any))))
%%x2902)))
(%%emit2824
(lambda (%%x2931)
((lambda (%%tmp2932)
((lambda (%%tmp2933)
(if %%tmp2933
(apply (lambda (%%x2934)
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
%%x2934))
%%tmp2933)
((lambda (%%tmp2935)
(if %%tmp2935
(apply (lambda (%%x2936)
((lambda (%%tmp2937)
((lambda (%%tmp2938)
(if %%tmp2938
(apply (lambda (%%t32939)
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
%%t32939))
%%tmp2938)
(syntax-error %%tmp2937)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2937
'each-any)))
(map %%emit2824 %%x2936)))
%%tmp2935)
((lambda (%%tmp2942)
(if %%tmp2942
(apply (lambda (%%x2943 %%y2944)
((letrec ((%%f2945 (lambda (%%x*2946)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(if (null? %%x*2946)
(%%emit2824 %%y2944)
((lambda (%%tmp2947)
((lambda (%%tmp2948)
(if %%tmp2948
(apply (lambda (%%t52949
%%t42950)
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
%%t52949
%%t42950))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2948)
(syntax-error %%tmp2947)))
($syntax-dispatch
%%tmp2947
'(any any))))
(list (%%emit2824 (car %%x*2946))
(%%f2945 (cdr %%x*2946))))))))
%%f2945)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%x2943))
%%tmp2942)
((lambda (%%tmp2952)
(if %%tmp2952
(apply (lambda (%%x2953)
((lambda (%%tmp2954)
((lambda (%%tmp2955)
(if %%tmp2955
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(apply (lambda (%%t62956)
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
%%t62956))
%%tmp2955)
(syntax-error %%tmp2954)))
($syntax-dispatch %%tmp2954 'each-any)))
(map %%emit2824 %%x2953)))
%%tmp2952)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp2959)
(if %%tmp2959
(apply (lambda (%%x2960)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
((lambda (%%tmp2961)
((lambda (%%tmp2962)
(if %%tmp2962
(apply (lambda (%%t72963)
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
%%t72963))
%%tmp2962)
(syntax-error %%tmp2961)))
($syntax-dispatch %%tmp2961 'each-any)))
(map %%emit2824 %%x2960)))
%%tmp2959)
((lambda (%%tmp2966)
(if %%tmp2966
(apply (lambda (%%x2967)
((lambda (%%tmp2968)
((lambda (%%t82969)
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
%%t82969))
%%tmp2968))
(%%emit2824 %%x2967)))
%%tmp2966)
((lambda (%%tmp2970)
(if %%tmp2970
(apply (lambda (%%x2971) %%x2971) %%tmp2970)
(syntax-error %%tmp2932)))
($syntax-dispatch %%tmp2932 '(#(atom "value") any)))))
($syntax-dispatch %%tmp2932 '(#(atom "list->vector") any)))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
($syntax-dispatch
%%tmp2932
'(#(atom "vector")
.
each-any)))))
($syntax-dispatch
%%tmp2932
'(#(atom "append") . each-any)))))
($syntax-dispatch
%%tmp2932
'(#(atom "list*")
.
#(each+ any (any) ()))))))
($syntax-dispatch
%%tmp2932
'(#(atom "list") . each-any)))))
($syntax-dispatch %%tmp2932 '(#(atom "quote") any))))
%%x2931))))
(lambda (%%x2972)
((lambda (%%tmp2973)
((lambda (%%tmp2974)
(if %%tmp2974
(apply (lambda (%%_2975 %%e2976)
(%%emit2824 (%%quasi2818 %%e2976 0)))
%%tmp2974)
(syntax-error %%tmp2973)))
($syntax-dispatch %%tmp2973 '(any any))))
%%x2972)))))
'*top*)
($sc-put-cte
'#(syntax-object
quasisyntax
((top) #(ribcage #(quasisyntax) #((top)) #(quasisyntax))))
(lambda (%%x2977)
(letrec ((%%qs2978
(lambda (%%q2980 %%n2981 %%b*2982 %%k2983)
((lambda (%%tmp2984)
((lambda (%%tmp2985)
(if %%tmp2985
(apply (lambda (%%d2986)
(%%qs2978
%%d2986
(+ %%n2981 1)
%%b*2982
(lambda (%%b*2987 %%dnew2988)
(%%k2983 %%b*2987
(if (eq? %%dnew2988 %%d2986)
%%q2980
((lambda (%%tmp2989)
((lambda (%%d2990)
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
%%d2990))
%%tmp2989))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%dnew2988))))))
%%tmp2985)
((lambda (%%tmp2991)
(if (if %%tmp2991
(apply (lambda (%%d2992)
(not (= %%n2981 0)))
%%tmp2991)
#f)
(apply (lambda (%%d2993)
(%%qs2978
%%d2993
(- %%n2981 1)
%%b*2982
(lambda (%%b*2994 %%dnew2995)
(%%k2983 %%b*2994
(if (eq? %%dnew2995
%%d2993)
%%q2980
((lambda (%%tmp2996)
((lambda (%%d2997)
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
%%d2997))
%%tmp2996))
%%dnew2995))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2991)
((lambda (%%tmp2998)
(if (if %%tmp2998
(apply (lambda (%%d2999)
(not (= %%n2981 0)))
%%tmp2998)
#f)
(apply (lambda (%%d3000)
(%%qs2978
%%d3000
(- %%n2981 1)
%%b*2982
(lambda (%%b*3001
%%dnew3002)
(%%k2983 %%b*3001
(if (eq? %%dnew3002
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%d3000)
%%q2980
((lambda (%%tmp3003)
((lambda (%%d3004)
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
%%d3004))
%%tmp3003))
%%dnew3002))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp2998)
((lambda (%%tmp3005)
(if (if %%tmp3005
(apply (lambda (%%q3006)
(= %%n2981 0))
%%tmp3005)
#f)
(apply (lambda (%%q3007)
((lambda (%%tmp3008)
((lambda (%%tmp3009)
(if %%tmp3009
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(apply (lambda (%%t3010)
(%%k2983 (cons (list %%t3010 %%q3007)
%%b*2982)
%%t3010))
%%tmp3009)
(syntax-error %%tmp3008)))
($syntax-dispatch %%tmp3008 '(any))))
(generate-temporaries (list %%q3007))))
%%tmp3005)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp3011)
(if (if %%tmp3011
(apply (lambda (%%q3012
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%d3013)
(= %%n2981 0))
%%tmp3011)
#f)
(apply (lambda (%%q3014 %%d3015)
(%%qs2978
%%d3015
%%n2981
%%b*2982
(lambda (%%b*3016 %%dnew3017)
((lambda (%%tmp3018)
((lambda (%%tmp3019)
(if %%tmp3019
(apply (lambda (%%t3020)
(%%k2983 (append (map list
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%t3020
%%q3014)
%%b*3016)
((lambda (%%tmp3023)
((lambda (%%d3024) (append %%t3020 %%d3024)) %%tmp3023))
%%dnew3017)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3019)
(syntax-error %%tmp3018)))
($syntax-dispatch %%tmp3018 'each-any)))
(generate-temporaries %%q3014)))))
%%tmp3011)
((lambda (%%tmp3027)
(if (if %%tmp3027
(apply (lambda (%%q3028 %%d3029) (= %%n2981 0))
%%tmp3027)
#f)
(apply (lambda (%%q3030 %%d3031)
(%%qs2978
%%d3031
%%n2981
%%b*2982
(lambda (%%b*3032 %%dnew3033)
((lambda (%%tmp3034)
((lambda (%%tmp3035)
(if %%tmp3035
(apply (lambda (%%t3036)
(%%k2983 (append (map (lambda (%%tmp3038
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%tmp3037)
(list (cons %%tmp3037
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
%%tmp3038))
%%q3030
%%t3036)
%%b*3032)
((lambda (%%tmp3039)
((lambda (%%tmp3040)
(if %%tmp3040
(apply (lambda (%%m3041)
((lambda (%%tmp3042)
((lambda (%%d3043)
(append (apply append %%m3041)
%%d3043))
%%tmp3042))
%%dnew3033))
%%tmp3040)
(syntax-error %%tmp3039)))
($syntax-dispatch %%tmp3039 '#(each each-any))))
(map (lambda (%%tmp3046)
(cons %%tmp3046
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
%%t3036))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3035)
(syntax-error %%tmp3034)))
($syntax-dispatch %%tmp3034 'each-any)))
(generate-temporaries %%q3030)))))
%%tmp3027)
((lambda (%%tmp3048)
(if %%tmp3048
(apply (lambda (%%a3049 %%d3050)
(%%qs2978
%%a3049
%%n2981
%%b*2982
(lambda (%%b*3051 %%anew3052)
(%%qs2978
%%d3050
%%n2981
%%b*3051
(lambda (%%b*3053 %%dnew3054)
(%%k2983 %%b*3053
(if (if (eq? %%anew3052
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%a3049)
(eq? %%dnew3054 %%d3050)
#f)
%%q2980
((lambda (%%tmp3055)
((lambda (%%tmp3056)
(if %%tmp3056
(apply (lambda (%%a3057 %%d3058)
(cons %%a3057 %%d3058))
%%tmp3056)
(syntax-error %%tmp3055)))
($syntax-dispatch %%tmp3055 '(any any))))
(list %%anew3052 %%dnew3054)))))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3048)
((lambda (%%tmp3059)
(if %%tmp3059
(apply (lambda (%%x3060)
(%%vqs2979
%%x3060
%%n2981
%%b*2982
(lambda (%%b*3062 %%xnew*3063)
(%%k2983 %%b*3062
(if ((letrec ((%%same?3064
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(lambda (%%x*3065 %%xnew*3066)
(if (null? %%x*3065)
(null? %%xnew*3066)
(if (not (null? %%xnew*3066))
(if (eq? (car %%x*3065)
(car %%xnew*3066))
(%%same?3064
(cdr %%x*3065)
(cdr %%xnew*3066))
#f)
#f)))))
%%same?3064)
%%x3060
%%xnew*3063)
%%q2980
((lambda (%%tmp3068)
((lambda (%%tmp3069)
(if %%tmp3069
(apply (lambda (%%x3070) (list->vector %%x3070))
%%tmp3069)
(syntax-error %%tmp3068)))
($syntax-dispatch %%tmp3068 'each-any)))
%%xnew*3063))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3059)
((lambda (%%_3072)
(%%k2983 %%b*2982 %%q2980))
%%tmp2984)))
($syntax-dispatch
%%tmp2984
'#(vector each-any)))))
($syntax-dispatch %%tmp2984 '(any . any)))))
($syntax-dispatch
%%tmp2984
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
%%tmp2984
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
%%tmp2984
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
%%tmp2984
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
%%tmp2984
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
%%tmp2984
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
%%q2980)))
(%%vqs2979
(lambda (%%x*3073 %%n3074 %%b*3075 %%k3076)
(if (null? %%x*3073)
(%%k3076 %%b*3075 '())
(%%vqs2979
(cdr %%x*3073)
%%n3074
%%b*3075
(lambda (%%b*3077 %%xnew*3078)
((lambda (%%tmp3079)
((lambda (%%tmp3080)
(if (if %%tmp3080
(apply (lambda (%%q3081) (= %%n3074 0))
%%tmp3080)
#f)
(apply (lambda (%%q3082)
((lambda (%%tmp3083)
((lambda (%%tmp3084)
(if %%tmp3084
(apply (lambda (%%t3085)
(%%k3076 (append (map list
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%t3085
%%q3082)
%%b*3077)
(append %%t3085 %%xnew*3078)))
%%tmp3084)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(syntax-error %%tmp3083)))
($syntax-dispatch
%%tmp3083
'each-any)))
(generate-temporaries %%q3082)))
%%tmp3080)
((lambda (%%tmp3090)
(if (if %%tmp3090
(apply (lambda (%%q3091)
(= %%n3074 0))
%%tmp3090)
#f)
(apply (lambda (%%q3092)
((lambda (%%tmp3093)
((lambda (%%tmp3094)
(if %%tmp3094
(apply (lambda (%%t3095)
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(%%k3076 (append (map (lambda (%%tmp3097
%%tmp3096)
(list (cons %%tmp3096
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
%%tmp3097))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%q3092
%%t3095)
%%b*3077)
((lambda (%%tmp3098)
((lambda (%%tmp3099)
(if %%tmp3099
(apply (lambda (%%m3100)
(append (apply append
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%m3100)
%%xnew*3078))
%%tmp3099)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(syntax-error %%tmp3098)))
($syntax-dispatch
%%tmp3098
'#(each each-any))))
(map (lambda (%%tmp3103)
(cons %%tmp3103
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
%%t3095))))
%%tmp3094)
(syntax-error %%tmp3093)))
($syntax-dispatch %%tmp3093 'each-any)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(generate-temporaries
%%q3092)))
%%tmp3090)
((lambda (%%_3105)
(%%qs2978
(car %%x*3073)
%%n3074
%%b*3077
(lambda (%%b*3106 %%xnew3107)
(%%k3076 %%b*3106
(cons %%xnew3107
%%xnew*3078)))))
%%tmp3079)))
($syntax-dispatch
%%tmp3079
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
%%tmp3079
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
(car %%x*3073))))))))
((lambda (%%tmp3108)
((lambda (%%tmp3109)
(if %%tmp3109
(apply (lambda (%%_3110 %%x3111)
(%%qs2978
%%x3111
0
'()
(lambda (%%b*3112 %%xnew3113)
(if (eq? %%xnew3113 %%x3111)
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
%%x3111)
((lambda (%%tmp3114)
((lambda (%%tmp3115)
(if %%tmp3115
(apply (lambda (%%b3116 %%x3117)
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
%%b3116
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
%%x3117)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3115)
(syntax-error %%tmp3114)))
($syntax-dispatch
%%tmp3114
'(each-any any))))
(list %%b*3112 %%xnew3113))))))
%%tmp3109)
(syntax-error %%tmp3108)))
($syntax-dispatch %%tmp3108 '(any any))))
%%x2977)))
'*top*)
($sc-put-cte
'#(syntax-object include ((top) #(ribcage #(include) #((top)) #(include))))
(lambda (%%x3119)
(letrec ((%%read-file3120
(lambda (%%fn3121 %%k3122)
((lambda (%%p3123)
((letrec ((%%f3124 (lambda ()
((lambda (%%x3125)
(if (eof-object? %%x3125)
(begin
(close-input-port %%p3123)
'())
(cons (datum->syntax-object
%%k3122
%%x3125)
(%%f3124))))
(read %%p3123)))))
%%f3124)))
(open-input-file %%fn3121)))))
((lambda (%%tmp3126)
((lambda (%%tmp3127)
(if %%tmp3127
(apply (lambda (%%k3128 %%filename3129)
((lambda (%%fn3130)
(datum->syntax-object
%%k3128
((lambda (%%src3131)
((lambda (%%locat3132)
((lambda () %%src3131)))
(##source-locat %%src3131)))
(##include-file-as-a-begin-expr
((lambda (%%y3133)
(if (##source? %%y3133)
%%y3133
(##make-source %%y3133 #f)))
(vector-ref %%x3119 1))))))
(syntax-object->datum %%filename3129)))
%%tmp3127)
(syntax-error %%tmp3126)))
($syntax-dispatch %%tmp3126 '(any any))))
%%x3119)))
'*top*)
($sc-put-cte
'#(syntax-object case ((top) #(ribcage #(case) #((top)) #(case))))
(lambda (%%x3134)
((lambda (%%tmp3135)
((lambda (%%tmp3136)
(if %%tmp3136
(apply (lambda (%%_3137 %%e3138 %%m13139 %%m23140)
((lambda (%%tmp3141)
((lambda (%%body3142)
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
%%e3138))
%%body3142))
%%tmp3141))
((letrec ((%%f3143 (lambda (%%clause3144
%%clauses3145)
(if (null? %%clauses3145)
((lambda (%%tmp3146)
((lambda (%%tmp3147)
(if %%tmp3147
(apply (lambda (%%e13148
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%e23149)
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
(cons %%e13148 %%e23149)))
%%tmp3147)
((lambda (%%tmp3151)
(if %%tmp3151
(apply (lambda (%%k3152 %%e13153 %%e23154)
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
%%k3152))
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
(cons %%e13153 %%e23154))))
%%tmp3151)
((lambda (%%_3157) (syntax-error %%x3134))
%%tmp3146)))
($syntax-dispatch %%tmp3146 '(each-any any . each-any)))))
($syntax-dispatch
%%tmp3146
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
%%clause3144)
((lambda (%%tmp3158)
((lambda (%%rest3159)
((lambda (%%tmp3160)
((lambda (%%tmp3161)
(if %%tmp3161
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
(apply (lambda (%%k3162 %%e13163 %%e23164)
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
%%k3162))
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
(cons %%e13163 %%e23164))
%%rest3159))
%%tmp3161)
((lambda (%%_3167) (syntax-error %%x3134))
%%tmp3160)))
($syntax-dispatch %%tmp3160 '(each-any any . each-any))))
%%clause3144))
%%tmp3158))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(%%f3143 (car %%clauses3145)
(cdr %%clauses3145)))))))
%%f3143)
%%m13139
%%m23140)))
%%tmp3136)
(syntax-error %%tmp3135)))
($syntax-dispatch %%tmp3135 '(any any any . each-any))))
%%x3134))
'*top*)
($sc-put-cte
'#(syntax-object
identifier-syntax
((top) #(ribcage #(identifier-syntax) #((top)) #(identifier-syntax))))
(lambda (%%x3169)
((lambda (%%tmp3170)
((lambda (%%tmp3171)
(if %%tmp3171
(apply (lambda (%%dummy3172 %%e3173)
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
%%e3173))
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
(cons %%e3173
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
%%tmp3171)
((lambda (%%tmp3174)
(if (if %%tmp3174
(apply (lambda (%%dummy3175
%%id3176
%%exp13177
%%var3178
%%val3179
%%exp23180)
(if (identifier? %%id3176)
(identifier? %%var3178)
#f))
%%tmp3174)
#f)
(apply (lambda (%%dummy3181
%%id3182
%%exp13183
%%var3184
%%val3185
%%exp23186)
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
%%var3184
%%val3185)
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
%%exp23186))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(list (cons %%id3182
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
(cons %%exp13183
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
(list %%id3182
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
%%id3182))
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
%%exp13183))))))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3174)
(syntax-error %%tmp3170)))
($syntax-dispatch
%%tmp3170
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
($syntax-dispatch %%tmp3170 '(any any))))
%%x3169))
'*top*)
($sc-put-cte
'#(syntax-object
cond-expand
((top) #(ribcage #(cond-expand) #((top)) #(cond-expand))))
(lambda (%%x3187)
((lambda (%%tmp3188)
((lambda (%%tmp3189)
(if %%tmp3189
(apply (lambda (%%dummy3190)
'#(syntax-object
(syntax-error "Unfulfilled cond-expand")
((top)
#(ribcage #(dummy) #(("m" top)) #("i"))
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t))))
%%tmp3189)
((lambda (%%tmp3191)
(if %%tmp3191
(apply (lambda (%%dummy3192 %%body3193)
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
%%body3193))
%%tmp3191)
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
#(ribcage
#(x)
#(("m" top))
#("i"))
#(top-ribcage *top* #t)))
%%body3197))
%%tmp3195)
((lambda (%%tmp3200)
(if %%tmp3200
(apply (lambda (%%dummy3201
%%req13202
%%req23203
%%body3204
%%more-clauses3205)
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
(cons (list %%req13202
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
%%req23203)
%%body3204)
%%more-clauses3205)))
%%more-clauses3205)))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3200)
((lambda (%%tmp3210)
(if %%tmp3210
(apply (lambda (%%dummy3211
%%body3212
%%more-clauses3213)
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
%%more-clauses3213))
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%%tmp3210)
((lambda (%%tmp3215)
(if %%tmp3215
(apply (lambda (%%dummy3216
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%req13217
%%req23218
%%body3219
%%more-clauses3220)
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
(list %%req13217
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
%%body3219))
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
%%req23218)
%%body3219)
%%more-clauses3220)))))
%%tmp3215)
;;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
((lambda (%%tmp3225)
(if %%tmp3225
(apply (lambda (%%dummy3226
;;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%%req3227
%%body3228
%%more-clauses3229)
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
(list %%req3227
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
%%more-clauses3229))
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
%%body3228)))
%%tmp3225)
((lambda (%%tmp3232)
(if %%tmp3232
(apply (lambda (%%dummy3233
%%body3234
%%more-clauses3235)
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
%%body3234))
%%tmp3232)
((lambda (%%tmp3237)
(if %%tmp3237
(apply (lambda (%%dummy3238
%%body3239
%%more-clauses3240)
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
%%body3239))
%%tmp3237)
((lambda (%%tmp3242)
(if %%tmp3242
(apply (lambda (%%dummy3243
%%feature-id3244
%%body3245
%%more-clauses3246)
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
%%more-clauses3246))
%%tmp3242)
(syntax-error %%tmp3188)))
($syntax-dispatch
%%tmp3188
'(any (any . each-any) . each-any)))))
($syntax-dispatch
%%tmp3188
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
%%tmp3188
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
%%tmp3188
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
%%tmp3188
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
%%tmp3188
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
%%tmp3188
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
%%tmp3188
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
%%tmp3188
'(any (#(free-id
#(syntax-object
else
((top)
#(ribcage () () ())
#(ribcage #(x) #(("m" top)) #("i"))
#(top-ribcage *top* #t))))
.
each-any))))))
($syntax-dispatch %%tmp3188 '(any))))
%%x3187))
'*top*)
($sc-put-cte
'#(syntax-object
define-macro
((top) #(ribcage #(define-macro) #((top)) #(define-macro))))
(lambda (%%x3248)
((lambda (%%tmp3249)
((lambda (%%tmp3250)
(if %%tmp3250
(apply (lambda (%%_3251
%%name3252
%%params3253
%%body13254
%%body23255)
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
%%name3252
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
(cons %%params3253
(cons %%body13254 %%body23255)))))
%%tmp3250)
((lambda (%%tmp3257)
(if %%tmp3257
(apply (lambda (%%_3258 %%name3259 %%expander3260)
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
%%name3259
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
(cons %%expander3260
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
%%tmp3257)
(syntax-error %%tmp3249)))
($syntax-dispatch %%tmp3249 '(any any any)))))
($syntax-dispatch %%tmp3249 '(any (any . any) any . each-any))))
%%x3248))
'*top*)
($sc-put-cte
'#(syntax-object ##begin ((top) #(ribcage #(##begin) #((top)) #(##begin))))
(lambda (%%x3261)
((lambda (%%tmp3262)
((lambda (%%tmp3263)
(if %%tmp3263
(apply (lambda (%%_3264 %%body13265)
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
%%body13265))
%%tmp3263)
(syntax-error %%tmp3262)))
($syntax-dispatch %%tmp3262 '(any . each-any))))
%%x3261))
'*top*)
($sc-put-cte
'#(syntax-object future ((top) #(ribcage #(future) #((top)) #(future))))
(lambda (%%x3267)
((lambda (%%tmp3268)
((lambda (%%tmp3269)
(if %%tmp3269
(apply (lambda (%%dummy3270 %%rest3271)
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
%%rest3271))
%%tmp3269)
(syntax-error %%tmp3268)))
($syntax-dispatch %%tmp3268 '(any . each-any))))
%%x3267))
'*top*)
($sc-put-cte
'#(syntax-object
c-define-type
((top) #(ribcage #(c-define-type) #((top)) #(c-define-type))))
(lambda (%%x3273)
((lambda (%%tmp3274)
((lambda (%%tmp3275)
(if %%tmp3275
(apply (lambda (%%dummy3276 %%rest3277)
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
%%rest3277))
%%tmp3275)
(syntax-error %%tmp3274)))
($syntax-dispatch %%tmp3274 '(any . each-any))))
%%x3273))
'*top*)
($sc-put-cte
'#(syntax-object
c-declare
((top) #(ribcage #(c-declare) #((top)) #(c-declare))))
(lambda (%%x3279)
((lambda (%%tmp3280)
((lambda (%%tmp3281)
(if %%tmp3281
(apply (lambda (%%dummy3282 %%rest3283)
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
%%rest3283))
%%tmp3281)
(syntax-error %%tmp3280)))
($syntax-dispatch %%tmp3280 '(any . each-any))))
%%x3279))
'*top*)
($sc-put-cte
'#(syntax-object
c-initialize
((top) #(ribcage #(c-initialize) #((top)) #(c-initialize))))
(lambda (%%x3285)
((lambda (%%tmp3286)
((lambda (%%tmp3287)
(if %%tmp3287
(apply (lambda (%%dummy3288 %%rest3289)
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
%%rest3289))
%%tmp3287)
(syntax-error %%tmp3286)))
($syntax-dispatch %%tmp3286 '(any . each-any))))
%%x3285))
'*top*)
($sc-put-cte
'#(syntax-object
c-lambda
((top) #(ribcage #(c-lambda) #((top)) #(c-lambda))))
(lambda (%%x3291)
((lambda (%%tmp3292)
((lambda (%%tmp3293)
(if %%tmp3293
(apply (lambda (%%dummy3294 %%rest3295)
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
%%rest3295))
%%tmp3293)
(syntax-error %%tmp3292)))
($syntax-dispatch %%tmp3292 '(any . each-any))))
%%x3291))
'*top*)
($sc-put-cte
'#(syntax-object
c-define
((top) #(ribcage #(c-define) #((top)) #(c-define))))
(lambda (%%x3297)
((lambda (%%tmp3298)
((lambda (%%tmp3299)
(if %%tmp3299
(apply (lambda (%%dummy3300 %%rest3301)
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
%%rest3301))
%%tmp3299)
(syntax-error %%tmp3298)))
($syntax-dispatch %%tmp3298 '(any . each-any))))
%%x3297))
'*top*)
($sc-put-cte
'#(syntax-object declare ((top) #(ribcage #(declare) #((top)) #(declare))))
(lambda (%%x3303)
((lambda (%%tmp3304)
((lambda (%%tmp3305)
(if %%tmp3305
(apply (lambda (%%dummy3306 %%rest3307)
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
%%rest3307))
%%tmp3305)
(syntax-error %%tmp3304)))
($syntax-dispatch %%tmp3304 '(any . each-any))))
%%x3303))
'*top*)
($sc-put-cte
'#(syntax-object
namespace
((top) #(ribcage #(namespace) #((top)) #(namespace))))
(lambda (%%x3309)
((lambda (%%tmp3310)
((lambda (%%tmp3311)
(if %%tmp3311
(apply (lambda (%%dummy3312 %%rest3313)
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
%%rest3313))
%%tmp3311)
(syntax-error %%tmp3310)))
($syntax-dispatch %%tmp3310 '(any . each-any))))
%%x3309))
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
