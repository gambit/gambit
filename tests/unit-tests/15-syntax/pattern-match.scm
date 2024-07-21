
;;;============================================================================

;;;; match.scm -- portable hygienic pattern matcher -*- coding: utf-8 -*-
;;
;; This code is written by Alex Shinn and placed in the
;; Public Domain.  All warranties are disclaimed.

;;> \example-import[(srfi 9)]

;;> A portable hygienic pattern matcher.

;;> This is a full superset of the popular \hyperlink[
;;> "http://www.cs.indiana.edu/scheme-repository/code.match.html"]{match}
;;> package by Andrew Wright, written in fully portable \scheme{##syntax-rules}
;;> and thus preserving hygiene.

;;> The most notable extensions are the ability to use \emph{non-linear}
;;> patterns - patterns in which the same identifier occurs multiple
;;> times, tail patterns after ellipsis, and the experimental tree patterns.

;;> \section{Patterns}

;;> Patterns are written to look like the printed representation of
;;> the objects they match.  The basic usage is

;;> \scheme{(match expr (pat body ...) ...)}

;;> where the result of \var{expr} is matched against each pattern in
;;> turn, and the corresponding body is evaluated for the first to
;;> succeed.  Thus, a list of three elements matches a list of three
;;> elements.

;;> \example{(let ((ls (list 1 2 3))) (match ls ((1 2 3) #t)))}

;;> If no patterns match an error is signalled.

;;> Identifiers will match anything, and make the corresponding
;;> binding available in the body.

;;> \example{(match (list 1 2 3) ((a b c) b))}

;;> If the same identifier occurs multiple times, the first instance
;;> will match anything, but subsequent instances must match a value
;;> which is \scheme{equal?} to the first.

;;> \example{(match (list 1 2 1) ((a a b) 1) ((a b a) 2))}

;;> The special identifier \scheme{_} matches anything, no matter how
;;> many times it is used, and does not bind the result in the body.

;;> \example{(match (list 1 2 1) ((_ _ b) 1) ((a b a) 2))}

;;> To match a literal identifier (or list or any other literal), use
;;> \scheme{quote}.

;;> \example{(match 'a ('b 1) ('a 2))}

;;> Analogous to its normal usage in scheme, \scheme{quasiquote} can
;;> be used to quote a mostly literally matching object with selected
;;> parts unquoted.

;;> \example|{(match (list 1 2 3) (`(1 ,b ,c) (list b c)))}|

;;> Often you want to match any number of a repeated pattern.  Inside
;;> a list pattern you can append \scheme{...} after an element to
;;> match zero or more of that pattern (like a regexp Kleene star).

;;> \example{(match (list 1 2) ((1 2 3 ...) #t))}
;;> \example{(match (list 1 2 3) ((1 2 3 ...) #t))}
;;> \example{(match (list 1 2 3 3 3) ((1 2 3 ...) #t))}

;;> Pattern variables matched inside the repeated pattern are bound to
;;> a list of each matching instance in the body.

;;> \example{(match (list 1 2) ((a b c ...) c))}
;;> \example{(match (list 1 2 3) ((a b c ...) c))}
;;> \example{(match (list 1 2 3 4 5) ((a b c ...) c))}

;;> More than one \scheme{...} may not be used in the same list, since
;;> this would require exponential backtracking in the general case.
;;> However, \scheme{...} need not be the final element in the list,
;;> and may be succeeded by a fixed number of patterns.

;;> \example{(match (list 1 2 3 4) ((a b c ... d e) c))}
;;> \example{(match (list 1 2 3 4 5) ((a b c ... d e) c))}
;;> \example{(match (list 1 2 3 4 5 6 7) ((a b c ... d e) c))}

;;> \scheme{___} is provided as an alias for \scheme{...} when it is
;;> inconvenient to use the ellipsis (as in a ##syntax-rules template).

;;> The \scheme{**1} syntax is exactly like the \scheme{...} except
;;> that it matches one or more repetitions (like a regexp "+").

;;> \example{(match (list 1 2) ((a b c **1) c))}
;;> \example{(match (list 1 2 3) ((a b c **1) c))}

;;> The \scheme{*..} syntax is like \scheme{...} except that it takes
;;> two trailing integers \scheme{<n>} and \scheme{<m>}, and requires
;;> the pattern to match from \scheme{<n>} times.

;;> \example{(match (list 1 2 3) ((a b *.. 2 4) b))}
;;> \example{(match (list 1 2 3 4 5 6) ((a b *.. 2 4) b))}
;;> \example{(match (list 1 2 3 4) ((a b *.. 2 4 c) c))}

;;> The \scheme{(<expr> =.. <n>)} syntax is a shorthand for
;;> \scheme{(<expr> *.. <n> <n>)}.

;;> \example{(match (list 1 2) ((a b =.. 2) b))}
;;> \example{(match (list 1 2 3) ((a b =.. 2) b))}
;;> \example{(match (list 1 2 3 4) ((a b =.. 2) b))}

;;> The boolean operators \scheme{and}, \scheme{or} and \scheme{not}
;;> can be used to group and negate patterns analogously to their
;;> Scheme counterparts.

;;> The \scheme{and} operator ensures that all subpatterns match.
;;> This operator is often used with the idiom \scheme{(and x pat)} to
;;> bind \var{x} to the entire value that matches \var{pat}
;;> (c.f. "as-patterns" in ML or Haskell).  Another common use is in
;;> conjunction with \scheme{not} patterns to match a general case
;;> with certain exceptions.

;;> \example{(match 1 ((and) #t))}
;;> \example{(match 1 ((and x) x))}
;;> \example{(match 1 ((and x 1) x))}

;;> The \scheme{or} operator ensures that at least one subpattern
;;> matches.  If the same identifier occurs in different subpatterns,
;;> it is matched independently.  All identifiers from all subpatterns
;;> are bound if the \scheme{or} operator matches, but the binding is
;;> only defined for identifiers from the subpattern which matched.

;;> \example{(match 1 ((or) #t) (else #f))}
;;> \example{(match 1 ((or x) x))}
;;> \example{(match 1 ((or x 2) x))}

;;> The \scheme{not} operator succeeds if the given pattern doesn't
;;> match.  None of the identifiers used are available in the body.

;;> \example{(match 1 ((not 2) #t))}

;;> The more general operator \scheme{?} can be used to provide a
;;> predicate.  The usage is \scheme{(? predicate pat ...)} where
;;> \var{predicate} is a Scheme expression evaluating to a predicate
;;> called on the value to match, and any optional patterns after the
;;> predicate are then matched as in an \scheme{and} pattern.

;;> \example{(match 1 ((? odd? x) x))}

;;> The field operator \scheme{=} is used to extract an arbitrary
;;> field and match against it.  It is useful for more complex or
;;> conditional destructuring that can't be more directly expressed in
;;> the pattern syntax.  The usage is \scheme{(= field pat)}, where
;;> \var{field} can be any expression, and should result in a
;;> procedure of one argument, which is applied to the value to match
;;> to generate a new value to match against \var{pat}.

;;> Thus the pattern \scheme{(and (= car x) (= cdr y))} is equivalent
;;> to \scheme{(x . y)}, except it will result in an immediate error
;;> if the value isn't a pair.

;;> \example{(match '(1 . 2) ((= car x) x))}
;;> \example{(match 4 ((= square x) x))}

;;> The record operator \scheme{$} is used as a concise way to match
;;> records defined by SRFI-9 (or SRFI-99).  The usage is
;;> \scheme{($ rtd field ...)}, where \var{rtd} should be the record
;;> type descriptor specified as the first argument to
;;> \scheme{define-record-type}, and each \var{field} is a subpattern
;;> matched against the fields of the record in order.  Not all fields
;;> must be present.

;;> \example{
;;> (let ()
;;>   (define-record-type employee
;;>     (make-employee name title)
;;>     employee?
;;>     (name get-name)
;;>     (title get-title))
;;>   (match (make-employee "Bob" "Doctor")
;;>     (($ employee n t) (list t n))))
;;> }

;;> For records with more fields it can be helpful to match them by
;;> name rather than position.  For this you can use the \scheme{@}
;;> operator, originally a Gauche extension:

;;> \example{
;;> (let ()
;;>   (define-record-type employee
;;>     (make-employee name title)
;;>     employee?
;;>     (name get-name)
;;>     (title get-title))
;;>   (match (make-employee "Bob" "Doctor")
;;>     ((@ employee (title t) (name n)) (list t n))))
;;> }

;;> The \scheme{set!} and \scheme{get!} operators are used to bind an
;;> identifier to the setter and getter of a field, respectively.  The
;;> setter is a procedure of one argument, which mutates the field to
;;> that argument.  The getter is a procedure of no arguments which
;;> returns the current value of the field.

;;> \example{(let ((x (cons 1 2))) (match x ((1 . (set! s)) (s 3) x)))}
;;> \example{(match '(1 . 2) ((1 . (get! g)) (g)))}

;;> The new operator \scheme{***} can be used to search a tree for
;;> subpatterns.  A pattern of the form \scheme{(x *** y)} represents
;;> the subpattern \var{y} located somewhere in a tree where the path
;;> from the current object to \var{y} can be seen as a list of the
;;> form \scheme{(x ...)}.  \var{y} can immediately match the current
;;> object in which case the path is the empty list.  In a sense it's
;;> a 2-dimensional version of the \scheme{...} pattern.

;;> As a common case the pattern \scheme{(_ *** y)} can be used to
;;> search for \var{y} anywhere in a tree, regardless of the path
;;> used.

;;> \example{(match '(a (a (a b))) ((x *** 'b) x))}
;;> \example{(match '(a (b) (c (d e) (f g))) ((x *** 'g) x))}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Notes

;; The implementation is a simple generative pattern matcher - each
;; pattern is expanded into the required tests, calling a failure
;; continuation if the tests fail.  This makes the logic easy to
;; follow and extend, but produces sub-optimal code in cases where you
;; have many similar clauses due to repeating the same tests.
;; Nonetheless a smart compiler should be able to remove the redundant
;; tests.  For MATCH-LET and DESTRUCTURING-BIND type uses there is no
;; performance hit.

;; The original version was written on 2006/11/29 and described in the
;; following Usenet post:
;;   http://groups.google.com/group/comp.lang.scheme/msg/0941234de7112ffd
;; and is still available at
;;   http://synthcode.com/scheme/match-simple.scm
;; It's just 80 lines for the core MATCH, and an extra 40 lines for
;; MATCH-LET, MATCH-LAMBDA and other syntactic sugar.
;;
;; A variant of this file which uses COND-EXPAND in a few places for
;; performance can be found at
;;   http://synthcode.com/scheme/match-cond-expand.scm
;;
;; 2021/06/21 - fix for `(a ...)' patterns where `a' is already bound
;;              (thanks to Andy Wingo)
;; 2020/09/04 - perf fix for `not`; rename `..=', `..=', `..1' per SRFI 204
;; 2020/08/21 - fixing match-letrec with unhygienic insertion
;; 2020/07/06 - adding `..=' and `..=' patterns; fixing ,@ patterns
;; 2016/10/05 - treat keywords as literals, not identifiers, in Chicken
;; 2016/03/06 - fixing named match-let (thanks to Stefan Israelsson Tampe)
;; 2015/05/09 - fixing bug in var extraction of quasiquote patterns
;; 2014/11/24 - adding Gauche's `@' pattern for named record field matching
;; 2012/12/26 - wrapping match-let&co body in lexical closure
;; 2012/11/28 - fixing typo s/vetor/vector in largely unused set! code
;; 2012/05/23 - fixing combinatorial explosion of code in certain or patterns
;; 2011/09/25 - fixing bug when directly matching an identifier repeated in
;;              the pattern (thanks to Stefan Israelsson Tampe)
;; 2011/01/27 - fixing bug when matching tail patterns against improper lists
;; 2010/09/26 - adding `..1' patterns (thanks to Ludovic Courtès)
;; 2010/09/07 - fixing identifier extraction in some `...' and `***' patterns
;; 2009/11/25 - adding `***' tree search patterns
;; 2008/03/20 - fixing bug where (a ...) matched non-lists
;; 2008/03/15 - removing redundant check in vector patterns
;; 2008/03/06 - you can use `...' portably now (thanks to Taylor Campbell)
;; 2007/09/04 - fixing quasiquote patterns
;; 2007/07/21 - allowing ellipsis patterns in non-final list positions
;; 2007/04/10 - fixing potential hygiene issue in match-check-ellipsis
;;              (thanks to Taylor Campbell)
;; 2007/04/08 - clean up, commenting
;; 2006/12/24 - bugfixes
;; 2006/12/01 - non-linear patterns, shared variables in OR, get!/set!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; force compile-time syntax errors with useful messages

(define-syntax match-syntax-error
  (##syntax-rules ()
    ((_) (syntax-error "invalid match-syntax-error usage"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;> \section{Syntax}

;;> \macro{(match expr (pattern . body) ...)\br{}
;;> (match expr (pattern (=> failure) . body) ...)}

;;> The result of \var{expr} is matched against each \var{pattern} in
;;> turn, according to the pattern rules described in the previous
;;> section, until the the first \var{pattern} matches.  When a match is
;;> found, the corresponding \var{body}s are evaluated in order,
;;> and the result of the last expression is returned as the result
;;> of the entire \scheme{match}.  If a \var{failure} is provided,
;;> then it is bound to a procedure of no arguments which continues,
;;> processing at the next \var{pattern}.  If no \var{pattern} matches,
;;> an error is signalled.

;; The basic interface.  MATCH just performs some basic syntax
;; validation, binds the match expression to a temporary variable `v',
;; and passes it on to MATCH-NEXT.  It's a constant throughout the
;; code below that the binding `v' is a direct variable reference, not
;; an expression.

(define-syntax match
  (##syntax-rules ()
    ((match)
     (match-syntax-error "missing match expression"))
    ((match atom)
     (match-syntax-error "no match clauses"))
    ((match (app ...) (pat . body) ...)
     (let ((v (app ...)))
       (match-next v ((app ...) (set! (app ...))) (pat . body) ...)))
    ((match #(vec ...) (pat . body) ...)
     (let ((v #(vec ...)))
       (match-next v (v (set! v)) (pat . body) ...)))
    ((match atom (pat . body) ...)
     (let ((v atom))
       (match-next v (atom (set! atom)) (pat . body) ...)))
    ))

;; MATCH-NEXT passes each clause to MATCH-ONE in turn with its failure
;; thunk, which is expanded by recursing MATCH-NEXT on the remaining
;; clauses.  `g+s' is a list of two elements, the get! and set!
;; expressions respectively.

(define-syntax match-next
  (##syntax-rules (=>)
    ;; no more clauses, the match failed
    ((match-next v g+s)
     (error 'match "no matching pattern"))
    ;; named failure continuation
    ((match-next v g+s (pat (=> failure) . body) . rest)
     (let ((failure (lambda () (match-next v g+s . rest))))
       ;; match-one analyzes the pattern for us
       (match-one v pat g+s (match-drop-ids (begin . body)) (failure) ())))
    ;; anonymous failure continuation, give it a dummy name
    ((match-next v g+s (pat . body) . rest)
     (match-next v g+s (pat (=> failure) . body) . rest))))

;; MATCH-ONE first checks for ellipsis patterns, otherwise passes on to
;; MATCH-TWO.

(define-syntax match-one
  (##syntax-rules ()
    ;; If it's a list of two or more values, check to see if the
    ;; second one is an ellipsis and handle accordingly, otherwise go
    ;; to MATCH-TWO.
    ((match-one v (p q . r) g+s sk fk i)
     (match-check-ellipsis
      q
      (match-extract-vars p (match-gen-ellipsis v p r  g+s sk fk i) i ())
      (match-two v (p q . r) g+s sk fk i)))
    ;; Go directly to MATCH-TWO.
    ((match-one . x)
     (match-two . x))))

;; This is the guts of the pattern matcher.  We are passed a lot of
;; information in the form:
;;
;;   (match-two var pattern getter setter success-k fail-k (ids ...))
;;
;; usually abbreviated
;;
;;   (match-two v p g+s sk fk i)
;;
;; where VAR is the symbol name of the current variable we are
;; matching, PATTERN is the current pattern, getter and setter are the
;; corresponding accessors (e.g. CAR and SET-CAR! of the pair holding
;; VAR), SUCCESS-K is the success continuation, FAIL-K is the failure
;; continuation (which is just a thunk call and is thus safe to expand
;; multiple times) and IDS are the list of identifiers bound in the
;; pattern so far.

(define-syntax match-two
  (##syntax-rules (_ ___ **1 =.. *.. *** quote quasiquote ? $ struct @ object = and or not set! get!)
    ((match-two v () g+s (sk ...) fk i)
     (if (null? v) (sk ... i) fk))
    ((match-two v (quote p) g+s (sk ...) fk i)
     (if (equal? v 'p) (sk ... i) fk))
    ((match-two v (quasiquote p) . x)
     (match-quasiquote v p . x))
    ((match-two v (and) g+s (sk ...) fk i) (sk ... i))
    ((match-two v (and p q ...) g+s sk fk i)
     (match-one v p g+s (match-one v (and q ...) g+s sk fk) fk i))
    ((match-two v (or) g+s sk fk i) fk)
    ((match-two v (or p) . x)
     (match-one v p . x))
    ((match-two v (or p ...) g+s sk fk i)
     (match-extract-vars (or p ...) (match-gen-or v (p ...) g+s sk fk i) i ()))
    ((match-two v (not p) g+s (sk ...) fk i)
     (let ((fk2 (lambda () (sk ... i))))
       (match-one v p g+s (match-drop-ids fk) (fk2) i)))
    ((match-two v (get! getter) (g s) (sk ...) fk i)
     (let ((getter (lambda () g))) (sk ... i)))
    ((match-two v (set! setter) (g (s ...)) (sk ...) fk i)
     (let ((setter (lambda (x) (s ... x)))) (sk ... i)))
    ((match-two v (? pred . p) g+s sk fk i)
     (if (pred v) (match-one v (and . p) g+s sk fk i) fk))
    ((match-two v (= proc p) . x)
     (let ((w (proc v))) (match-one w p . x)))
    ((match-two v (p ___ . r) g+s sk fk i)
     (match-extract-vars p (match-gen-ellipsis v p r g+s sk fk i) i ()))
    ((match-two v (p) g+s sk fk i)
     (if (and (pair? v) (null? (cdr v)))
         (let ((w (car v)))
           (match-one w p ((car v) (set-car! v)) sk fk i))
         fk))
    ((match-two v (p *** q) g+s sk fk i)
     (match-extract-vars p (match-gen-search v p q g+s sk fk i) i ()))
    ((match-two v (p *** . q) g+s sk fk i)
     (match-syntax-error "invalid use of ***" (p *** . q)))
    ((match-two v (p **1) g+s sk fk i)
     (if (pair? v)
         (match-one v (p ___) g+s sk fk i)
         fk))
    ((match-two v (p =.. n . r) g+s sk fk i)
     (match-extract-vars
      p
      (match-gen-ellipsis/range n n v p r g+s sk fk i) i ()))
    ((match-two v (p *.. n m . r) g+s sk fk i)
     (match-extract-vars
      p
      (match-gen-ellipsis/range n m v p r g+s sk fk i) i ()))
    ((match-two v ($ rec p ...) g+s sk fk i)
     (if (is-a? v rec)
         (match-record-refs v rec 0 (p ...) g+s sk fk i)
         fk))
    ((match-two v (struct rec p ...) g+s sk fk i)
     (if (is-a? v rec)
         (match-record-refs v rec 0 (p ...) g+s sk fk i)
         fk))
    ((match-two v (@ rec p ...) g+s sk fk i)
     (if (is-a? v rec)
         (match-record-named-refs v rec (p ...) g+s sk fk i)
         fk))
    ((match-two v (object rec p ...) g+s sk fk i)
     (if (is-a? v rec)
         (match-record-named-refs v rec (p ...) g+s sk fk i)
         fk))
    ((match-two v (p . q) g+s sk fk i)
     (if (pair? v)
         (let ((w (car v)) (x (cdr v)))
           (match-one w p ((car v) (set-car! v))
                      (match-one x q ((cdr v) (set-cdr! v)) sk fk)
                      fk
                      i))
         fk))
    ((match-two v #(p ...) g+s . x)
     (match-vector v 0 () (p ...) . x))
    ((match-two v _ g+s (sk ...) fk i) (sk ... i))
    ;; Not a pair or vector or special literal, test to see if it's a
    ;; new symbol, in which case we just bind it, or if it's an
    ;; already bound symbol or some other literal, in which case we
    ;; compare it with EQUAL?.
    ((match-two v x g+s (sk ...) fk (id ...))
     ;; This extra match-check-identifier is optional in general, but
     ;; can serve as a fast path, and is needed to distinguish
     ;; keywords in Chicken.
     (match-check-identifier
      x
      (let-syntax
          ((new-sym?
            (##syntax-rules (id ...)
              ((new-sym? x sk2 fk2) sk2)
              ((new-sym? y sk2 fk2) fk2))))
        (new-sym? random-sym-to-match
                  (let ((x v)) (sk ... (id ... x)))
                  (if (equal? v x) (sk ... (id ...)) fk)))
      (if (equal? v x) (sk ... (id ...)) fk)))
    ))

;; QUASIQUOTE patterns
;;
(define-syntax match-quasiquote
  (##syntax-rules (unquote unquote-splicing quasiquote or)
    ((_ v (unquote p) g+s sk fk i)
     (match-one v p g+s sk fk i))
    ((_ v ((unquote-splicing p) . rest) g+s sk fk i)
     ;; TODO: it is an error to have another unquote-splicing in rest,
     ;; check this and signal explicitly
     (match-extract-vars
      p
      (match-gen-ellipsis/qq v p rest g+s sk fk i) i ()))
    ((_ v (quasiquote p) g+s sk fk i . depth)
     (match-quasiquote v p g+s sk fk i #f . depth))
    ((_ v (unquote p) g+s sk fk i x . depth)
     (match-quasiquote v p g+s sk fk i . depth))
    ((_ v (unquote-splicing p) g+s sk fk i x . depth)
     (match-quasiquote v p g+s sk fk i . depth))
    ((_ v (p . q) g+s sk fk i . depth)
     (if (pair? v)
       (let ((w (car v)) (x (cdr v)))
         (match-quasiquote
          w p g+s
          (match-quasiquote-step x q g+s sk fk depth)
          fk i . depth))
       fk))
    ((_ v #(elt ...) g+s sk fk i . depth)
     (if (vector? v)
       (let ((ls (vector->list v)))
         (match-quasiquote ls (elt ...) g+s sk fk i . depth))
       fk))
    ((_ v x g+s sk fk i . depth)
     (match-one v 'x g+s sk fk i))))

(define-syntax match-quasiquote-step
  (##syntax-rules ()
    ((match-quasiquote-step x q g+s sk fk depth i)
     (match-quasiquote x q g+s sk fk i . depth))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utilities

;; Takes two values and just expands into the first.
(define-syntax match-drop-ids
  (##syntax-rules ()
    ((_ expr ids ...) expr)))

(define-syntax match-tuck-ids
  (##syntax-rules ()
    ((_ (letish args (expr ...)) ids ...)
     (letish args (expr ... ids ...)))))

(define-syntax match-drop-first-arg
  (##syntax-rules ()
    ((_ arg expr) expr)))

;; To expand an OR group we try each clause in succession, passing the
;; first that succeeds to the success continuation.  On failure for
;; any clause, we just try the next clause, finally resorting to the
;; failure continuation fk if all clauses fail.  The only trick is
;; that we want to unify the identifiers, so that the success
;; continuation can refer to a variable from any of the OR clauses.

(define-syntax match-gen-or
  (##syntax-rules ()
    ((_ v p g+s (sk ...) fk (i ...) ((id id-ls) ...))
     (let ((sk2 (lambda (id ...) (sk ... (i ... id ...))))
           (id (if #f #f)) ...)
       (match-gen-or-step v p g+s (match-drop-ids (sk2 id ...)) fk (i ...))))))

(define-syntax match-gen-or-step
  (##syntax-rules ()
    ((_ v () g+s sk fk . x)
     ;; no OR clauses, call the failure continuation
     fk)
    ((_ v (p) . x)
     ;; last (or only) OR clause, just expand normally
     (match-one v p . x))
    ((_ v (p . q) g+s sk fk i)
     ;; match one and try the remaining on failure
     (let ((fk2 (lambda () (match-gen-or-step v q g+s sk fk i))))
       (match-one v p g+s sk (fk2) i)))
    ))

;; We match a pattern (p ...) by matching the pattern p in a loop on
;; each element of the variable, accumulating the bound ids into lists.

;; Look at the body of the simple case - it's just a named let loop,
;; matching each element in turn to the same pattern.  The only trick
;; is that we want to keep track of the lists of each extracted id, so
;; when the loop recurses we cons the ids onto their respective list
;; variables, and on success we bind the ids (what the user input and
;; expects to see in the success body) to the reversed accumulated
;; list IDs.

(define-syntax match-gen-ellipsis
  (##syntax-rules ()
    ;; TODO: restore fast path when p is not already bound
    ((_ v p () g+s (sk ...) fk i ((id id-ls) ...))
     (match-check-identifier p
       ;; simplest case equivalent to (p ...), just match the list
       (let ((w v))
         (if (list? w)
             (match-one w p g+s (sk ...) fk i)
             fk))
       ;; simple case, match all elements of the list
       (let loop ((ls v) (id-ls '()) ...)
         (cond
           ((null? ls)
            (let ((id (reverse id-ls)) ...) (sk ... i)))
           ((pair? ls)
            (let ((w (car ls)))
              (match-one w p ((car ls) (set-car! ls))
                         (match-drop-ids (loop (cdr ls) (cons id id-ls) ...))
                         fk i)))
           (else
            fk)))))
    ((_ v p r g+s sk fk (i ...) ((id id-ls) ...))
     (match-verify-no-ellipsis
      r
      (match-bound-identifier-memv
       p
       (i ...)
       ;; p is bound, match the list up to the known length, then
       ;; match the trailing patterns
       (let loop ((ls v) (expect p))
         (cond
          ((null? expect)
           (match-one ls r (#f #f) sk fk (i ...)))
          ((pair? ls)
           (let ((w (car ls))
                 (e (car expect)))
             (if (equal? (car ls) (car expect))
                 (match-drop-ids (loop (cdr ls) (cdr expect)))
                 fk)))
          (else
           fk)))
       ;; general case, trailing patterns to match, keep track of
       ;; the remaining list length so we don't need any backtracking
       (let* ((tail-len (length 'r))
              (ls v)
              (len (and (list? ls) (length ls))))
         (if (or (not len) (< len tail-len))
             fk
             (let loop ((ls ls) (n len) (id-ls '()) ...)
               (cond
                ((= n tail-len)
                 (let ((id (reverse id-ls)) ...)
                   (match-one ls r (#f #f) sk fk (i ... id ...))))
                ((pair? ls)
                 (let ((w (car ls)))
                   (match-one w p ((car ls) (set-car! ls))
                              (match-drop-ids
                               (loop (cdr ls) (- n 1) (cons id id-ls) ...))
                              fk
                              (i ...))))
                (else
                 fk)))
           )))))))

;; Variant of the above where the rest pattern is in a quasiquote.

(define-syntax match-gen-ellipsis/qq
  (##syntax-rules ()
    ((_ v p r g+s (sk ...) fk (i ...) ((id id-ls) ...))
     (match-verify-no-ellipsis
      r
      (let* ((tail-len (length 'r))
             (ls v)
             (len (and (list? ls) (length ls))))
        (if (or (not len) (< len tail-len))
            fk
            (let loop ((ls ls) (n len) (id-ls '()) ...)
              (cond
               ((= n tail-len)
                (let ((id (reverse id-ls)) ...)
                  (match-quasiquote ls r g+s (sk ...) fk (i ... id ...))))
               ((pair? ls)
                (let ((w (car ls)))
                  (match-one w p ((car ls) (set-car! ls))
                             (match-drop-ids
                              (loop (cdr ls) (- n 1) (cons id id-ls) ...))
                             fk
                             (i ...))))
               (else
                fk)))))))))

;; Variant of above which takes an n/m range for the number of
;; repetitions.  At least n elements much match, and up to m elements
;; are greedily consumed.

(define-syntax match-gen-ellipsis/range
  (##syntax-rules ()
    ((_ %lo %hi v p r g+s (sk ...) fk (i ...) ((id id-ls) ...))
     ;; general case, trailing patterns to match, keep track of the
     ;; remaining list length so we don't need any backtracking
     (match-verify-no-ellipsis
      r
      (let* ((lo %lo)
             (hi %hi)
             (tail-len (length 'r))
             (ls v)
             (len (and (list? ls) (- (length ls) tail-len))))
        (if (and len (<= lo len hi))
            (let loop ((ls ls) (j 0) (id-ls '()) ...)
              (cond
                ((= j len)
                 (let ((id (reverse id-ls)) ...)
                   (match-one ls r (#f #f) (sk ...) fk (i ... id ...))))
                ((pair? ls)
                 (let ((w (car ls)))
                   (match-one w p ((car ls) (set-car! ls))
                              (match-drop-ids
                               (loop (cdr ls) (+ j 1) (cons id id-ls) ...))
                              fk
                              (i ...))))
                (else
                 fk)))
            fk))))))

;; This is just a safety check.  Although unlike ##syntax-rules we allow
;; trailing patterns after an ellipsis, we explicitly disable multiple
;; ellipsis at the same level.  This is because in the general case
;; such patterns are exponential in the number of ellipsis, and we
;; don't want to make it easy to construct very expensive operations
;; with simple looking patterns.  For example, it would be O(n^2) for
;; patterns like (a ... b ...) because we must consider every trailing
;; element for every possible break for the leading "a ...".

(define-syntax match-verify-no-ellipsis
  (##syntax-rules ()
    ((_ (x . y) sk)
     (match-check-ellipsis
      x
      (match-syntax-error
       "multiple ellipsis patterns not allowed at same level")
      (match-verify-no-ellipsis y sk)))
    ((_ () sk)
     sk)
    ((_ x sk)
     (match-syntax-error "dotted tail not allowed after ellipsis" x))))

;; To implement the tree search, we use two recursive procedures.  TRY
;; attempts to match Y once, and on success it calls the normal SK on
;; the accumulated list ids as in MATCH-GEN-ELLIPSIS.  On failure, we
;; call NEXT which first checks if the current value is a list
;; beginning with X, then calls TRY on each remaining element of the
;; list.  Since TRY will recursively call NEXT again on failure, this
;; effects a full depth-first search.
;;
;; The failure continuation throughout is a jump to the next step in
;; the tree search, initialized with the original failure continuation
;; FK.

(define-syntax match-gen-search
  (##syntax-rules ()
    ((match-gen-search v p q g+s sk fk i ((id id-ls) ...))
     (letrec ((try (lambda (w fail id-ls ...)
                     (match-one w q g+s
                                (match-tuck-ids
                                 (let ((id (reverse id-ls)) ...)
                                   sk))
                                (next w fail id-ls ...) i)))
              (next (lambda (w fail id-ls ...)
                      (if (not (pair? w))
                          (fail)
                          (let ((u (car w)))
                            (match-one
                             u p ((car w) (set-car! w))
                             (match-drop-ids
                              ;; accumulate the head variables from
                              ;; the p pattern, and loop over the tail
                              (let ((id-ls (cons id id-ls)) ...)
                                (let lp ((ls (cdr w)))
                                  (if (pair? ls)
                                      (try (car ls)
                                           (lambda () (lp (cdr ls)))
                                           id-ls ...)
                                      (fail)))))
                             (fail) i))))))
       ;; the initial id-ls binding here is a dummy to get the right
       ;; number of '()s
       (let ((id-ls '()) ...)
         (try v (lambda () fk) id-ls ...))))))

;; Vector patterns are just more of the same, with the slight
;; exception that we pass around the current vector index being
;; matched.

(define-syntax match-vector
  (##syntax-rules (___)
    ((_ v n pats (p q) . x)
     (match-check-ellipsis q
                          (match-gen-vector-ellipsis v n pats p . x)
                          (match-vector-two v n pats (p q) . x)))
    ((_ v n pats (p ___) sk fk i)
     (match-gen-vector-ellipsis v n pats p sk fk i))
    ((_ . x)
     (match-vector-two . x))))

;; Check the exact vector length, then check each element in turn.

(define-syntax match-vector-two
  (##syntax-rules ()
    ((_ v n ((pat index) ...) () sk fk i)
     (if (vector? v)
         (let ((len (vector-length v)))
           (if (= len n)
               (match-vector-step v ((pat index) ...) sk fk i)
               fk))
         fk))
    ((_ v n (pats ...) (p . q) . x)
     (match-vector v (+ n 1) (pats ... (p n)) q . x))))

(define-syntax match-vector-step
  (##syntax-rules ()
    ((_ v () (sk ...) fk i) (sk ... i))
    ((_ v ((pat index) . rest) sk fk i)
     (let ((w (vector-ref v index)))
       (match-one w pat ((vector-ref v index) (vector-set! v index))
                  (match-vector-step v rest sk fk)
                  fk i)))))

;; With a vector ellipsis pattern we first check to see if the vector
;; length is at least the required length.

(define-syntax match-gen-vector-ellipsis
  (##syntax-rules ()
    ((_ v n ((pat index) ...) p sk fk i)
     (if (vector? v)
       (let ((len (vector-length v)))
         (if (>= len n)
           (match-vector-step v ((pat index) ...)
                              (match-vector-tail v p n len sk fk)
                              fk i)
           fk))
       fk))))

(define-syntax match-vector-tail
  (##syntax-rules ()
    ((_ v p n len sk fk i)
     (match-extract-vars p (match-vector-tail-two v p n len sk fk i) i ()))))

(define-syntax match-vector-tail-two
  (##syntax-rules ()
    ((_ v p n len (sk ...) fk i ((id id-ls) ...))
     (let loop ((j n) (id-ls '()) ...)
       (if (>= j len)
         (let ((id (reverse id-ls)) ...) (sk ... i))
         (let ((w (vector-ref v j)))
           (match-one w p ((vector-ref v j) (vector-set! v j))
                      (match-drop-ids (loop (+ j 1) (cons id id-ls) ...))
                      fk i)))))))

(define-syntax match-record-refs
  (##syntax-rules ()
    ((_ v rec n (p . q) g+s sk fk i)
     (let ((w (slot-ref rec v n)))
       (match-one w p ((slot-ref rec v n) (slot-set! rec v n))
                  (match-record-refs v rec (+ n 1) q g+s sk fk) fk i)))
    ((_ v rec n () g+s (sk ...) fk i)
     (sk ... i))))

(define-syntax match-record-named-refs
  (##syntax-rules ()
    ((_ v rec ((f p) . q) g+s sk fk i)
     (let ((w (slot-ref rec v 'f)))
       (match-one w p ((slot-ref rec v 'f) (slot-set! rec v 'f))
                  (match-record-named-refs v rec q g+s sk fk) fk i)))
    ((_ v rec () g+s (sk ...) fk i)
     (sk ... i))))

;; Extract all identifiers in a pattern.  A little more complicated
;; than just looking for symbols, we need to ignore special keywords
;; and non-pattern forms (such as the predicate expression in ?
;; patterns), and also ignore previously bound identifiers.
;;
;; Calls the continuation with all new vars as a list of the form
;; ((orig-var tmp-name) ...), where tmp-name can be used to uniquely
;; pair with the original variable (e.g. it's used in the ellipsis
;; generation for list variables).
;;
;; (match-extract-vars pattern continuation (ids ...) (new-vars ...))

(define-syntax match-extract-vars
  (##syntax-rules (_ ___ **1 =.. *.. *** ? $ struct @ object = quote quasiquote and or not get! set!)
    ((match-extract-vars (? pred . p) . x)
     (match-extract-vars p . x))
    ((match-extract-vars ($ rec . p) . x)
     (match-extract-vars p . x))
    ((match-extract-vars (struct rec . p) . x)
     (match-extract-vars p . x))
    ((match-extract-vars (@ rec (f p) ...) . x)
     (match-extract-vars (p ...) . x))
    ((match-extract-vars (object rec (f p) ...) . x)
     (match-extract-vars (p ...) . x))
    ((match-extract-vars (= proc p) . x)
     (match-extract-vars p . x))
    ((match-extract-vars (quote x) (k ...) i v)
     (k ... v))
    ((match-extract-vars (quasiquote x) k i v)
     (match-extract-quasiquote-vars x k i v (#t)))
    ((match-extract-vars (and . p) . x)
     (match-extract-vars p . x))
    ((match-extract-vars (or . p) . x)
     (match-extract-vars p . x))
    ((match-extract-vars (not . p) . x)
     (match-extract-vars p . x))
    ;; A non-keyword pair, expand the CAR with a continuation to
    ;; expand the CDR.
    ((match-extract-vars (p q . r) k i v)
     (match-check-ellipsis
      q
      (match-extract-vars (p . r) k i v)
      (match-extract-vars p (match-extract-vars-step (q . r) k i v) i ())))
    ((match-extract-vars (p . q) k i v)
     (match-extract-vars p (match-extract-vars-step q k i v) i ()))
    ((match-extract-vars #(p ...) . x)
     (match-extract-vars (p ...) . x))
    ((match-extract-vars _ (k ...) i v)    (k ... v))
    ((match-extract-vars ___ (k ...) i v)  (k ... v))
    ((match-extract-vars *** (k ...) i v)  (k ... v))
    ((match-extract-vars **1 (k ...) i v)  (k ... v))
    ((match-extract-vars =.. (k ...) i v)  (k ... v))
    ((match-extract-vars *.. (k ...) i v)  (k ... v))
    ;; This is the main part, the only place where we might add a new
    ;; var if it's an unbound symbol.
    ((match-extract-vars p (k ...) (i ...) v)
     (let-syntax
         ((new-sym?
           (##syntax-rules (i ...)
             ((new-sym? p sk fk) sk)
             ((new-sym? any sk fk) fk))))
       (new-sym? random-sym-to-match
                 (k ... ((p p-ls) . v))
                 (k ... v))))
    ))

;; Stepper used in the above so it can expand the CAR and CDR
;; separately.

(define-syntax match-extract-vars-step
  (##syntax-rules ()
    ((_ p k i v ((v2 v2-ls) ...))
     (match-extract-vars p k (v2 ... . i) ((v2 v2-ls) ... . v)))
    ))

(define-syntax match-extract-quasiquote-vars
  (##syntax-rules (quasiquote unquote unquote-splicing)
    ((match-extract-quasiquote-vars (quasiquote x) k i v d)
     (match-extract-quasiquote-vars x k i v (#t . d)))
    ((match-extract-quasiquote-vars (unquote-splicing x) k i v d)
     (match-extract-quasiquote-vars (unquote x) k i v d))
    ((match-extract-quasiquote-vars (unquote x) k i v (#t))
     (match-extract-vars x k i v))
    ((match-extract-quasiquote-vars (unquote x) k i v (#t . d))
     (match-extract-quasiquote-vars x k i v d))
    ((match-extract-quasiquote-vars (x . y) k i v d)
     (match-extract-quasiquote-vars
      x
      (match-extract-quasiquote-vars-step y k i v d) i () d))
    ((match-extract-quasiquote-vars #(x ...) k i v d)
     (match-extract-quasiquote-vars (x ...) k i v d))
    ((match-extract-quasiquote-vars x (k ...) i v d)
     (k ... v))
    ))

(define-syntax match-extract-quasiquote-vars-step
  (##syntax-rules ()
    ((_ x k i v d ((v2 v2-ls) ...))
     (match-extract-quasiquote-vars x k (v2 ... . i) ((v2 v2-ls) ... . v) d))
    ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gimme some sugar baby.

;;> Shortcut for \scheme{lambda} + \scheme{match}.  Creates a
;;> procedure of one argument, and matches that argument against each
;;> clause.

(define-syntax match-lambda
  (##syntax-rules ()
    ((_ (pattern . body) ...) (lambda (expr) (match expr (pattern . body) ...)))))

;;> Similar to \scheme{match-lambda}.  Creates a procedure of any
;;> number of arguments, and matches the argument list against each
;;> clause.

(define-syntax match-lambda*
  (##syntax-rules ()
    ((_ (pattern . body) ...) (lambda expr (match expr (pattern . body) ...)))))

;;> Matches each var to the corresponding expression, and evaluates
;;> the body with all match variables in scope.  Raises an error if
;;> any of the expressions fail to match.  Syntax analogous to named
;;> let can also be used for recursive functions which match on their
;;> arguments as in \scheme{match-lambda*}.

(define-syntax match-let
  (##syntax-rules ()
    ((_ ((var value) ...) . body)
     (match-let/aux () () ((var value) ...) . body))
    ((_ loop ((var init) ...) . body)
     (match-named-let loop () ((var init) ...) . body))))

(define-syntax match-let/aux
  (##syntax-rules ()
    ((_ ((var expr) ...) () () . body)
     (let ((var expr) ...) . body))
    ((_ ((var expr) ...) ((pat tmp) ...) () . body)
     (let ((var expr) ...)
       (match-let* ((pat tmp) ...)
         . body)))
    ((_ (v ...) (p ...) (((a . b) expr) . rest) . body)
     (match-let/aux (v ... (tmp expr)) (p ... ((a . b) tmp)) rest . body))
    ((_ (v ...) (p ...) ((#(a ...) expr) . rest) . body)
     (match-let/aux (v ... (tmp expr)) (p ... (#(a ...) tmp)) rest . body))
    ((_ (v ...) (p ...) ((a expr) . rest) . body)
     (match-let/aux (v ... (a expr)) (p ...) rest . body))))

(define-syntax match-named-let
  (##syntax-rules ()
    ((_ loop ((pat expr var) ...) () . body)
     (let loop ((var expr) ...)
       (match-let ((pat var) ...)
         . body)))
    ((_ loop (v ...) ((pat expr) . rest) . body)
     (match-named-let loop (v ... (pat expr tmp)) rest . body))))

;;> \macro{(match-let* ((var value) ...) body ...)}

;;> Similar to \scheme{match-let}, but analogously to \scheme{let*}
;;> matches and binds the variables in sequence, with preceding match
;;> variables in scope.

(define-syntax match-let*
  (##syntax-rules ()
    ((_ () . body)
     (let () . body))
    ((_ ((pat expr) . rest) . body)
     (match expr (pat (match-let* rest . body))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Challenge stage - unhygienic insertion.
;;
;; It's possible to implement match-letrec without unhygienic
;; insertion by building the let+set! logic directly into the match
;; code above (passing a parameter to distinguish let vs letrec).
;; However, it makes the code much more complicated, so we religate
;; the complexity here.

;;> Similar to \scheme{match-let}, but analogously to \scheme{letrec}
;;> matches and binds the variables with all match variables in scope.

(define-syntax match-letrec
  (##syntax-rules ()
    ((_ ((pat val) ...) . body)
     (match-letrec-one (pat ...) (((pat val) ...) . body) ()))))

;; 1: extract all ids in all patterns
(define-syntax match-letrec-one
  (##syntax-rules ()
    ((_ (pat . rest) expr ((id tmp) ...))
     (match-extract-vars
      pat (match-letrec-one rest expr) (id ...) ((id tmp) ...)))
    ((_ () expr ((id tmp) ...))
     (match-letrec-two expr () ((id tmp) ...)))))

;; 2: rewrite ids
(define-syntax match-letrec-two
  (##syntax-rules ()
    ((_ (() . body) ((var2 val2) ...) ((id tmp) ...))
     ;; We know the ids, their tmp names, and the renamed patterns
     ;; with the tmp names - expand to the classic letrec pattern of
     ;; let+set!.  That is, we bind the original identifiers written
     ;; in the source with let, run match on their renamed versions,
     ;; then set! the originals to the matched values.
     (let ((id (if #f #f)) ...)
       (match-let ((var2 val2) ...)
          (set! id tmp) ...
          . body)))
    ((_ (((var val) . rest) . body) ((var2 val2) ...) ids)
     (match-rewrite
      var
      ids
      (match-letrec-two-step (rest . body) ((var2 val2) ...) ids val)))))

(define-syntax match-letrec-two-step
  (##syntax-rules ()
    ((_ next (rewrites ...) ids val var)
     (match-letrec-two next (rewrites ... (var val)) ids))))

;; This is where the work is done.  To rewrite all occurrences of any
;; id with its tmp, we need to walk the expression, using CPS to
;; restore the original structure.  We also need to be careful to pass
;; the tmp directly to the macro doing the insertion so that it
;; doesn't get renamed.  This trick was originally found by Al*
;; Petrofsky in a message titled "How to write seemingly unhygienic
;; macros using ##syntax-rules" sent to comp.lang.scheme in Nov 2001.

(define-syntax match-rewrite
  (##syntax-rules (quote)
    ((match-rewrite (quote x) ids (k ...))
     (k ... (quote x)))
    ((match-rewrite (p . q) ids k)
     (match-rewrite p ids (match-rewrite2 q ids (match-cons k))))
    ((match-rewrite () ids (k ...))
     (k ... ()))
    ((match-rewrite p () (k ...))
     (k ... p))
    ((match-rewrite p ((id tmp) . rest) (k ...))
     (match-bound-identifier=? p id (k ... tmp) (match-rewrite p rest (k ...))))
    ))

(define-syntax match-rewrite2
  (##syntax-rules ()
    ((match-rewrite2 q ids (k ...) p)
     (match-rewrite q ids (k ... p)))))

(define-syntax match-cons
  (##syntax-rules ()
    ((match-cons (k ...) p q)
     (k ... (p . q)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Otherwise COND-EXPANDed bits.

#;(cond-expand
 (chibi
  (define-syntax match-check-ellipsis
    (er-macro-transformer
     (lambda (expr rename compare)
       (if (compare '... (cadr expr))
           (car (cddr expr))
           (cadr (cddr expr))))))
  (define-syntax match-check-identifier
    (er-macro-transformer
     (lambda (expr rename compare)
       (if (identifier? (cadr expr))
           (car (cddr expr))
           (cadr (cddr expr))))))
  (define-syntax match-bound-identifier=?
    (er-macro-transformer
     (lambda (expr rename compare)
       (if (eq? (cadr expr) (car (cddr expr)))
           (cadr (cddr expr))
           (car (cddr (cddr expr)))))))
  (define-syntax match-bound-identifier-memv
    (er-macro-transformer
     (lambda (expr rename compare)
       (if (memv (cadr expr) (car (cddr expr)))
           (cadr (cddr expr))
           (car (cddr (cddr expr))))))))

 (chicken
  (define-syntax match-check-ellipsis
    (er-macro-transformer
     (lambda (expr rename compare)
       (if (compare '... (cadr expr))
           (car (cddr expr))
           (cadr (cddr expr))))))
  (define-syntax match-check-identifier
    (er-macro-transformer
     (lambda (expr rename compare)
       (if (and (symbol? (cadr expr)) (not (keyword? (cadr expr))))
           (car (cddr expr))
           (cadr (cddr expr))))))
  (define-syntax match-bound-identifier=?
    (er-macro-transformer
     (lambda (expr rename compare)
       (if (eq? (cadr expr) (car (cddr expr)))
           (cadr (cddr expr))
           (car (cddr (cddr expr)))))))
  (define-syntax match-bound-identifier-memv
    (er-macro-transformer
     (lambda (expr rename compare)
       (if (memv (cadr expr) (car (cddr expr)))
           (cadr (cddr expr))
           (car (cddr (cddr expr))))))))

 (else
  ;; Portable versions
  ;;
  ;; This is the R7RS version.  For other standards, and
  ;; implementations not yet up-to-spec we have to use some tricks.
  ;;
  ;;   (define-syntax match-check-ellipsis
  ;;     (##syntax-rules (...)
  ;;       ((_ ... sk fk) sk)
  ;;       ((_ x sk fk) fk)))
  ;;
  ;; This is a little more complicated, and introduces a new let-syntax,
  ;; but should work portably in any R[56]RS Scheme.  Taylor Campbell
  ;; originally came up with the idea.
  (define-syntax match-check-ellipsis
    (##syntax-rules ()
      ;; these two aren't necessary but provide fast-case failures
      ((match-check-ellipsis (a . b) success-k failure-k) failure-k)
      ((match-check-ellipsis #(a ...) success-k failure-k) failure-k)
      ;; matching an atom
      ((match-check-ellipsis id success-k failure-k)
       (let-syntax ((ellipsis? (##syntax-rules ()
                                 ;; iff `id' is `...' here then this will
                                 ;; match a list of any length
                                 ((ellipsis? (foo id) sk fk) sk)
                                 ((ellipsis? other sk fk) fk))))
         ;; this list of three elements will only match the (foo id) list
         ;; above if `id' is `...'
         (ellipsis? (a b c) success-k failure-k)))))

  ;; This is portable but can be more efficient with non-portable
  ;; extensions.  This trick was originally discovered by Oleg Kiselyov.
  (define-syntax match-check-identifier
    (##syntax-rules ()
      ;; fast-case failures, lists and vectors are not identifiers
      ((_ (x . y) success-k failure-k) failure-k)
      ((_ #(x ...) success-k failure-k) failure-k)
      ;; x is an atom
      ((_ x success-k failure-k)
       (let-syntax
           ((sym?
             (##syntax-rules ()
               ;; if the symbol `abracadabra' matches x, then x is a
               ;; symbol
               ((sym? x sk fk) sk)
               ;; otherwise x is a non-symbol datum
               ((sym? y sk fk) fk))))
         (sym? abracadabra success-k failure-k)))))

  ;; This check is inlined in some cases above, but included here for
  ;; the convenience of match-rewrite.
  (define-syntax match-bound-identifier=?
    (##syntax-rules ()
      ((match-bound-identifier=? a b sk fk)
       (let-syntax ((b (##syntax-rules ())))
         (let-syntax ((eq (##syntax-rules (b)
                            ((eq b) sk)
                            ((eq _) fk))))
           (eq a))))))

  ;; Variant of above for a list of ids.
  (define-syntax match-bound-identifier-memv
    (##syntax-rules ()
      ((match-bound-identifier-memv a (id ...) sk fk)
       (match-check-identifier
        a
        (let-syntax
            ((memv?
              (##syntax-rules (id ...)
                ((memv? a sk2 fk2) fk2)
                ((memv? anything-else sk2 fk2) sk2))))
          (memv? random-sym-to-match sk fk))
        fk))))
  ))

  ;; Portable versions
  ;;
  ;; This is the R7RS version.  For other standards, and
  ;; implementations not yet up-to-spec we have to use some tricks.
  ;;
  ;;   (define-syntax match-check-ellipsis
  ;;     (##syntax-rules (...)
  ;;       ((_ ... sk fk) sk)
  ;;       ((_ x sk fk) fk)))
  ;;
  ;; This is a little more complicated, and introduces a new let-syntax,
  ;; but should work portably in any R[56]RS Scheme.  Taylor Campbell
  ;; originally came up with the idea.
  (define-syntax match-check-ellipsis
    (##syntax-rules ()
      ;; these two aren't necessary but provide fast-case failures
      ((match-check-ellipsis (a . b) success-k failure-k) failure-k)
      ((match-check-ellipsis #(a ...) success-k failure-k) failure-k)
      ;; matching an atom
      ((match-check-ellipsis id success-k failure-k)
       (let-syntax ((ellipsis? (##syntax-rules ()
                                 ;; iff `id' is `...' here then this will
                                 ;; match a list of any length
                                 ((ellipsis? (foo id) sk fk) sk)
                                 ((ellipsis? other sk fk) fk))))
         ;; this list of three elements will only match the (foo id) list
         ;; above if `id' is `...'
         (ellipsis? (a b c) success-k failure-k)))))

  ;; This is portable but can be more efficient with non-portable
  ;; extensions.  This trick was originally discovered by Oleg Kiselyov.
  (define-syntax match-check-identifier
    (##syntax-rules ()
      ;; fast-case failures, lists and vectors are not identifiers
      ((_ (x . y) success-k failure-k) failure-k)
      ((_ #(x ...) success-k failure-k) failure-k)
      ;; x is an atom
      ((_ x success-k failure-k)
       (let-syntax
           ((sym?
             (##syntax-rules ()
               ;; if the symbol `abracadabra' matches x, then x is a
               ;; symbol
               ((sym? x sk fk) sk)
               ;; otherwise x is a non-symbol datum
               ((sym? y sk fk) fk))))
         (sym? abracadabra success-k failure-k)))))

  ;; This check is inlined in some cases above, but included here for
  ;; the convenience of match-rewrite.
  (define-syntax match-bound-identifier=?
    (##syntax-rules ()
      ((match-bound-identifier=? a b sk fk)
       (let-syntax ((b (##syntax-rules ())))
         (let-syntax ((eq (##syntax-rules (b)
                            ((eq b) sk)
                            ((eq _) fk))))
           (eq a))))))

  ;; Variant of above for a list of ids.
  (define-syntax match-bound-identifier-memv
    (##syntax-rules ()
      ((match-bound-identifier-memv a (id ...) sk fk)
       (match-check-identifier
        a
        (let-syntax
            ((memv?
              (##syntax-rules (id ...)
                ((memv? a sk2 fk2) fk2)
                ((memv? anything-else sk2 fk2) sk2))))
          (memv? random-sym-to-match sk fk))
        fk))))

;;;; match.scm -- portable hygienic pattern matcher

;;;============================================================================

(define pattern-match-is-included #t)

;;;============================================================================
