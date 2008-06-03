;;;============================================================================

;;; File: "_ptree2.scm", Time-stamp: <2008-06-02 22:11:46 feeley>

;;; Copyright (c) 1994-2008 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

'(begin;**********brad
(##include "../gsc/_utilsadt.scm")
(##include "../gsc/_envadt.scm")
(##include "../gsc/_ptree1adt.scm")
(##include "../gsc/_hostadt.scm")
)

;;;----------------------------------------------------------------------------
;;
;; Parse tree manipulation module: (part 2)
;; ------------------------------

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (normalize-program ptrees)
  (let* ((lst1 (expand-primitive-calls ptrees))
         (lst2 (assignment-convert lst1))
         (lst3 (beta-reduce lst2))
         (lst4 (lambda-lift lst3)))
    lst4))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; (delete-ptree ptree) removes parse tree 'ptree' from program and updates
;; references and assignments to variables.

(define (delete-ptree ptree)

  (cond ((ref? ptree)
         (let ((var (ref-var ptree)))
           (var-refs-set! var (ptset-remove (var-refs var) ptree))))

        ((set? ptree)
         (let ((var (set-var ptree)))
           (var-sets-set! var (ptset-remove (var-sets var) ptree))))

        ((def? ptree)
         (let ((var (def-var ptree)))
           (var-sets-set! var (ptset-remove (var-sets var) ptree)))))

  (for-each delete-ptree (node-children ptree)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; (clone-ptree ptree) returns a fresh copy of 'ptree'.  All the
;; bound variables (i.e. not free variables) in ptree are also copied.
;; It is assumed that 'ptree' has already been assignment-converted.

(define (clone-ptree ptree)
  (cp ptree '()))

(define (cp ptree substs)

  (define (rename-var var)
    (let ((x (assq var substs)))
      (if x (cdr x) var)))

  (cond ((cst? ptree)
         (new-cst (node-source ptree) (node-env ptree)
           (cst-val ptree)))

        ((ref? ptree)
         (let ((var (rename-var (ref-var ptree))))
           (new-ref (node-source ptree) (node-env ptree)
             var)))

        ((set? ptree)
         (let ((var (rename-var (set-var ptree))))
           (new-set (node-source ptree) (node-env ptree)
             var
             (cp (set-val ptree) substs))))

        ((def? ptree) ; guaranteed to be a toplevel definition
         (new-def (node-source ptree) (node-env ptree)
           (def-var ptree)
           (cp (def-val ptree) substs)))

        ((tst? ptree)
         (new-tst (node-source ptree) (node-env ptree)
           (cp (tst-pre ptree) substs)
           (cp (tst-con ptree) substs)
           (cp (tst-alt ptree) substs)))

        ((conj? ptree)
         (new-conj (node-source ptree) (node-env ptree)
           (cp (conj-pre ptree) substs)
           (cp (conj-alt ptree) substs)))

        ((disj? ptree)
         (new-disj (node-source ptree) (node-env ptree)
           (cp (disj-pre ptree) substs)
           (cp (disj-alt ptree) substs)))

        ((prc? ptree)
         (let* ((parms (prc-parms ptree))
                (vars (clone-vars parms)))
           (new-prc (node-source ptree) (node-env ptree)
             (prc-name ptree)
             (prc-c-name ptree)
             vars
             (prc-opts ptree)
             (prc-keys ptree)
             (prc-rest? ptree)
             (cp (prc-body ptree)
                 (append (pair-up parms vars) substs)))))

        ((app? ptree)
         (let ((oper (app-oper ptree))
               (args (app-args ptree)))
           (if (and (prc? oper) ; applying a lambda-expr is like a 'let'
                    (prc-req-and-opt-parms-only? oper)
                    (= (length (prc-parms oper)) (length args)))
             (let* ((parms (prc-parms oper))
                    (vars (clone-vars parms))
                    (new-substs (append (pair-up parms vars) substs)))
               (new-let ptree
                        oper
                        vars
                        (map (lambda (x) (cp x new-substs)) args)
                        (cp (prc-body oper) new-substs)))
             (new-call (node-source ptree) (node-env ptree)
               (cp (app-oper ptree) substs)
               (map (lambda (x) (cp x substs)) (app-args ptree))))))

        ((fut? ptree)
         (new-fut (node-source ptree) (node-env ptree)
           (cp (fut-val ptree) substs)))

        (else
         (compiler-internal-error "cp, unknown parse tree node type"))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Expansion of primitive calls
;; ----------------------------

;; (expand-primitive-calls lst) takes a list of parse-trees and returns
;; a list where each parse-tree has been replaced with an equivalent
;; parse-tree where some calls to primitive procedures have been
;; expanded into an equivalent, but probably faster, Scheme expression.

(define (expand-primitive-calls lst)
  (map epc lst))

(define (epc ptree)

  (cond ((or (cst? ptree)
             (set? ptree)
             (def? ptree) ; guaranteed to be a toplevel definition
             (tst? ptree)
             (conj? ptree)
             (disj? ptree)
             (prc? ptree)
             (fut? ptree))
         (node-children-set! ptree
           (map epc
                (node-children ptree)))
         ptree)

        ((ref? ptree)
         (let ((proc (global-proc-obj ptree)))
           (if proc
             (let ((proc-node
                    (new-cst (node-source ptree) (node-env ptree)
                      proc)))
               (delete-ptree ptree)
               proc-node)
             ptree)))

        ((app? ptree)
         (let* ((oper
                 (app-oper ptree))
                (args
                 (map epc (app-args ptree)))
                (new-oper
                 (if (ref? oper)
                   (let ((var (ref-var oper)))
                     (if (global? var)
                       (let* ((name
                               (var-name var))
                              (proc
                               (target.prim-info name))
                              (spec
                               (specialize-proc proc args (node-env oper)))
                              (source
                               (node-source ptree))
                              (env
                               (node-env ptree)))
                         (if (and spec
                                  (inline-primitive? name env)
                                  (or ((proc-obj-inlinable? spec) env)
                                      ((proc-obj-expandable? spec) env)))
                           (let* ((std?
                                   (standard-proc-obj proc
                                                      name
                                                      (node-env oper)))
                                  (rtb?
                                   (run-time-binding? name
                                                      (node-env oper)))
                                  (generate-original-call
                                   (lambda (vars)
                                     (new-call source env
                                       (new-ref (node-source oper)
                                                (node-env oper)
                                         var)
                                       (gen-var-refs source env vars))))
                                  (generate-run-time-binding-test
                                   (lambda (gen-body)
                                     (let ((vars (gen-temp-vars source args)))
                                       (gen-prc source env
                                         vars
                                         (new-tst source env
                                           (gen-eq-proc source env
                                             (new-ref
                                               (node-source oper)
                                               (node-env oper)
                                               var)
                                             proc)
                                           (gen-body vars)
                                           (generate-original-call vars))))))
                                  (new-oper
                                   (if ((proc-obj-inlinable? spec) env)
                                     (cond (std?
                                            (new-cst source env
                                              spec))
                                           (rtb?
                                            (generate-run-time-binding-test
                                             (lambda (vars)
                                               (new-call source env
                                                 (new-cst source env
                                                   spec)
                                                 (gen-var-refs source env vars)))))
                                           (else
                                            #f))
                                     (and (or std?
                                              rtb?)
                                          (let ((x
                                                 ((proc-obj-expand spec)
                                                  ptree
                                                  oper
                                                  args
                                                  (if (eq? proc spec)
                                                    generate-original-call
                                                    (lambda (vars)
                                                      (new-call source env
                                                        (new-cst source env
                                                          spec)
                                                        (gen-var-refs source env vars))))
                                                  (and (not std?)
                                                       (eq? proc spec)
                                                       (lambda ()
                                                         (gen-eq-proc source env
                                                           (new-ref
                                                             (node-source oper)
                                                             (node-env oper)
                                                             var)
                                                           proc))))))
                                            (if x
                                              (if (and (not std?)
                                                       (not (eq? proc spec)))
                                                (generate-run-time-binding-test
                                                 (lambda (vars)
                                                   (new-call source env
                                                     x
                                                     (gen-var-refs source env vars))))
                                                x)
                                              (and std?
                                                   (new-cst source env
                                                     spec))))))))
                             (if new-oper
                               (begin
                                 (delete-ptree oper)
                                 new-oper)
                               (epc oper)))
                           (epc oper)))
                       (epc oper)))
                   (epc oper))))
           (node-children-set! ptree
             (cons new-oper
                   args))
           ptree))

        (else
         (compiler-internal-error "epc, unknown parse tree node type"))))

(define (gen-prc source env params body)
  (new-prc source env #f #f params '() #f #f body))

(define (gen-disj-multi source env nodes)
  (if (pair? (cdr nodes))
    (new-disj source env
      (car nodes)
      (gen-disj-multi source env (cdr nodes)))
    (car nodes)))

(define (gen-uniform-type-checks source env vars type-check tail)

  (define (loop result lst)
    (if (pair? lst)
      (loop (new-conj source env
              (type-check (car lst))
              result)
            (cdr lst))
      result))

  (cond (tail
         (loop tail vars))
        ((pair? vars)
         (loop (type-check (car vars)) (cdr vars)))
        (else
         #f)))

(define (gen-temp-vars source args)
  (let loop ((args args) (rev-vars '()))
    (if (null? args)
      (reverse rev-vars)
      (loop (cdr args)
            (cons (new-temp-variable source 'temp)
                  rev-vars)))))

(define (gen-var-refs source env vars)
  (map (lambda (var)
         (new-ref source env
           var))
       vars))

(define (gen-call-prim-vars source env prim vars)
  (gen-call-prim source env
    prim
    (gen-var-refs source env vars)))

(define (gen-call-prim source env prim args)
  (new-call source (add-not-safe env)
    (new-cst source env
      (target.prim-info prim))
    args))

(define (gen-eq-proc source env arg proc)
  (gen-call-prim source env
    '##eq?;;;;;;;;;;
    (list
     arg
     (new-cst source env
       proc))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Assignment conversion:
;; ---------------------

;; (assignment-convert lst) takes a list of parse-trees and returns a
;; list where each parse-tree has been replaced with an equivalent
;; parse-tree containing no assignments to non-global variables.  In
;; the converted parse-tree, 'box' objects are used to implement mutable
;; variables and calls to the procedures:
;;
;;   ##box
;;   ##unbox
;;   ##set-box!
;;
;; are added to create and access the boxes.

(define (assignment-convert lst)
  (map (lambda (ptree) (ac ptree '()))
       lst))

(define (ac ptree mut)

  (cond ((cst? ptree)
         ptree)

        ((ref? ptree)
         (let ((var (ref-var ptree)))
           (if (global? var)
             ptree
             (let ((x (assq var mut)))
               (if x
                 (let ((source (node-source ptree)))
                   (var-refs-set! var (ptset-remove (var-refs var) ptree))
                   (gen-call-prim source (node-env ptree)
                     **unbox-sym
                     (list (new-ref source (node-env ptree) (cdr x)))))
                 ptree)))))

        ((set? ptree)
         (let ((var (set-var ptree))
               (source (node-source ptree))
               (val (ac (set-val ptree) mut)))
           (if (global? var)
             (begin
               (var-sets-set! var (ptset-remove (var-sets var) ptree))
               (new-set source (node-env ptree)
                 var
                 val))
             (gen-call-prim source (node-env ptree)
               **set-box!-sym
               (list (new-ref source (node-env ptree) (cdr (assq var mut)))
                     val)))))

        ((def? ptree) ; guaranteed to be a toplevel definition
         (let ((var (def-var ptree))
               (val (ac (def-val ptree) mut)))
           (var-sets-set! var (ptset-remove (var-sets var) ptree))
           (new-def (node-source ptree) (node-env ptree)
             var
             val)))

        ((tst? ptree)
         (new-tst (node-source ptree) (node-env ptree)
           (ac (tst-pre ptree) mut)
           (ac (tst-con ptree) mut)
           (ac (tst-alt ptree) mut)))

        ((conj? ptree)
         (new-conj (node-source ptree) (node-env ptree)
           (ac (conj-pre ptree) mut)
           (ac (conj-alt ptree) mut)))

        ((disj? ptree)
         (new-disj (node-source ptree) (node-env ptree)
           (ac (disj-pre ptree) mut)
           (ac (disj-alt ptree) mut)))

        ((prc? ptree)
         (ac-proc ptree mut))

        ((app? ptree)
         (let ((oper (app-oper ptree))
               (args (app-args ptree)))
           (if (and (prc? oper) ; applying a lambda-expr is like a 'let'
                    (prc-req-and-opt-parms-only? oper)
                    (= (length (prc-parms oper)) (length args)))
             (ac-let ptree mut)
             (new-call (node-source ptree) (node-env ptree)
               (ac oper mut)
               (map (lambda (x) (ac x mut)) args)))))

        ((fut? ptree)
         (new-fut (node-source ptree) (node-env ptree)
           (ac (fut-val ptree) mut)))

        (else
         (compiler-internal-error "ac, unknown parse tree node type"))))

(define (ac-proc ptree mut)
  (let* ((mut-parms (ac-mutables (prc-parms ptree)))
         (cloned-mut-parms (clone-vars mut-parms)))

    (for-each (lambda (var) (var-sets-set! var (ptset-empty)))
              mut-parms)

    (for-each (lambda (var) (var-boxed?-set! var #t))
              cloned-mut-parms)

    (new-prc (node-source ptree) (node-env ptree)
      (prc-name ptree)
      (prc-c-name ptree)
      (prc-parms ptree)
      (prc-opts ptree)
      (prc-keys ptree)
      (prc-rest? ptree)
      (new-let ptree
               ptree
               cloned-mut-parms
               (map (lambda (var)
                      (gen-call-prim (var-source var) (node-env ptree)
                        **box-sym
                        (list (new-ref (var-source var)
                                       (node-env ptree)
                                       var))))
                    mut-parms)
               (ac (prc-body ptree)
                   (append (pair-up mut-parms cloned-mut-parms) mut))))))

(define (ac-let ptree mut)
  (let* ((proc (app-oper ptree))
         (vals (app-args ptree))
         (vars (prc-parms proc))
         (vals-fv (varset-union-multi (map bound-free-variables vals)))
         (mut-parms (ac-mutables vars))
         (cloned-mut-parms (clone-vars mut-parms))
         (mut (append (pair-up mut-parms cloned-mut-parms) mut)))

    (for-each (lambda (var) (var-sets-set! var (ptset-empty)))
              mut-parms)

    (for-each (lambda (var) (var-boxed?-set! var #t))
              cloned-mut-parms)

    (let loop ((l1 vars)
               (l2 vals)
               (new-vars '())
               (new-vals '())
               (new-body (ac (prc-body proc) mut)))
      (if (null? l1)

        (new-let ptree proc new-vars new-vals new-body)

        (let ((var (car l1))
              (val (car l2)))

          (if (memq var mut-parms)

            (let ((src (node-source val))
                  (env (node-env val))
                  (var* (cdr (assq var mut))))

              (if (varset-member? var vals-fv)

                (loop (cdr l1)
                      (cdr l2)
                      (cons var* new-vars)
                      (cons (gen-call-prim src env
                              **box-sym
                              (list (new-cst src env void-object)))
                            new-vals)
                      (new-seq src env
                        (gen-call-prim src env
                          **set-box!-sym
                          (list (new-ref src env var*)
                                (ac val mut)))
                        new-body))

                (loop (cdr l1)
                      (cdr l2)
                      (cons var* new-vars)
                      (cons (gen-call-prim src env
                              **box-sym
                              (list (ac val mut)))
                            new-vals)
                      new-body)))

            (loop (cdr l1)
                  (cdr l2)
                  (cons var new-vars)
                  (cons (ac val mut) new-vals)
                  new-body)))))))

(define (ac-mutables lst)
  (keep mutable? lst))

(define (clone-vars vars)
  (map (lambda (var)
         (let ((cloned-var
                (make-var (var-name var)
                          #t
                          (ptset-empty)
                          (ptset-empty)
                          (var-source var))))
           (var-boxed?-set! cloned-var (var-boxed? var))
           cloned-var))
       vars))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Beta-reduction:
;; --------------

;; (beta-reduce ptrees) takes a list of parse-trees and transforms
;; each parse-tree with the following transformations:
;;
;;  - constant propagation
;;  - copy propagation
;;  - useless variable elimination
;;
;; It is assumed that the parse-trees have already been assignment-converted.

(define beta-reduce #f);***************

(set! beta-reduce (lambda (ptrees)

  (define (vars-with-duplicates->varset vars);********brad avoids this because list->set removes duplicates
    (let loop ((set (varset-empty)) (lst vars))
      (if (pair? lst)
        (loop (varset-adjoin set (car lst)) (cdr lst))
        set)))

  (define (pass1) ; transform definitions in dependency order
    (let* ((defs
            (keep def? ptrees))
           (defined-vars
            (vars-with-duplicates->varset (map def-var (reverse defs))))
           (depgraph
            (map (lambda (var)
                   (make-gnode var
                               (varset-union-multi
                                (map (lambda (def)
                                       (varset-intersection
                                        defined-vars
                                        (free-variables (def-val def))))
                                     (keep def?
                                           (ptset->list (var-sets var)))))))
                 (varset->list defined-vars)))
           (order
            (topological-sort
             (transitive-closure depgraph))))
      (for-each
       (lambda (vars)
         (for-each
          (lambda (var)
            (for-each
             (lambda (def)
               (node-children-set! 
                def
                (list (br (def-val def) '() 'need #f))))
             (keep def? (ptset->list (var-sets var)))))
          (varset->list vars)))
       order)))

  (define (pass2) ; transform non-definitions from top to bottom
    (let loop ((lst1 ptrees) (lst2 '()))
      (if (pair? lst1)
        (let ((ptree (car lst1)))
          (cond ((not (core? (node-env ptree)))
                 (delete-ptree ptree)
                 (loop (cdr lst1) lst2))
                ((def? ptree)
                 (loop (cdr lst1) (cons ptree lst2)))
                (else
                 (loop (cdr lst1) (cons (br ptree
                                            '()
                                            'need
                                            #f)
                                        lst2)))))
        (reverse lst2))))

  (pass1)
  (pass2))
)

(define (br ptree substs reason expansion-limit)

  (cond ((cst? ptree)
         (new-cst (node-source ptree) (node-env ptree)
           (cst-val ptree)))

        ((ref? ptree)
         (let ((var (ref-var ptree)))
           (var-refs-set! var (ptset-remove (var-refs var) ptree))
           (let ((new-var (var-subst var substs)))
             (let ((x (var-to-val new-var substs)))
               (if (and x (or (cst? x) (ref? x)))
                 (clone-ptree x)
                 (new-ref (node-source ptree) (node-env ptree)
                   new-var))))))

        ((set? ptree) ; variable guaranteed to be a global variable
         (let ((var (set-var ptree))
               (val (br (set-val ptree) substs 'need expansion-limit)))
           (var-sets-set! var (ptset-remove (var-sets var) ptree))
           (new-set (node-source ptree) (node-env ptree)
             var
             val)))

        ((tst? ptree)
         (let ((pre (br (tst-pre ptree) substs 'pred expansion-limit)))
           (if (cst? pre)
             (if (false-object? (cst-val pre))
               (begin
                 (delete-ptree pre)
                 (delete-ptree (tst-con ptree))
                 (br (tst-alt ptree) substs reason expansion-limit))
               (begin
                 (delete-ptree pre)
                 (delete-ptree (tst-alt ptree))
                 (br (tst-con ptree) substs reason expansion-limit)))
             (new-tst (node-source ptree) (node-env ptree)
               pre
               (br (tst-con ptree) substs reason expansion-limit)
               (br (tst-alt ptree) substs reason expansion-limit)))))

        ((conj? ptree)
         (let ((pre (br (conj-pre ptree) substs reason expansion-limit)))
           (if (cst? pre)
             (if (false-object? (cst-val pre))
               (begin
                 (delete-ptree (conj-alt ptree))
                 pre)
               (begin
                 (delete-ptree pre)
                 (br (conj-alt ptree) substs reason expansion-limit)))
             (let ((alt (br (conj-alt ptree) substs reason expansion-limit)))
               (cond ((and (cst? alt)
                           (false-object? (cst-val alt)))
                      (if (side-effects-impossible? pre)
                        (begin
                          ; (and X #f) => #f
                          (delete-ptree pre)
                          alt)
                        (begin
                          ; (and X #f) => (begin X #f)
                          ; this transform should be generalized
                          (new-seq (node-source ptree) (node-env ptree)
                            pre
                            alt))))
                     ((and (cst? alt)
                           (not (false-object? (cst-val alt)))
                           (eq? reason 'pred))
                      ; (if (and X non-#f) ...) => (if X ...)
                      (delete-ptree alt)
                      pre)
                     (else
                      (new-conj (node-source ptree) (node-env ptree)
                        pre
                        alt)))))))

        ((disj? ptree)
         (let ((pre (br (disj-pre ptree) substs reason expansion-limit)))
           (if (cst? pre)
             (if (false-object? (cst-val pre))
               (begin
                 (delete-ptree pre)
                 (br (disj-alt ptree) substs reason expansion-limit))
               (begin
                 (delete-ptree (disj-alt ptree))
                 pre))
             (let ((alt (br (disj-alt ptree) substs reason expansion-limit)))
               (if (and (cst? alt)
                        (false-object? (cst-val alt)))
                 (begin
                   ; (or X #f) => X
                   (delete-ptree alt)
                   pre)
                 (new-disj (node-source ptree) (node-env ptree)
                   pre
                   alt))))))

        ((prc? ptree)
         (new-prc (node-source ptree) (node-env ptree)
           (prc-name ptree)
           (prc-c-name ptree)
           (prc-parms ptree)
           (prc-opts ptree)
           (prc-keys ptree)
           (prc-rest? ptree)
           (br (prc-body ptree) substs 'need expansion-limit)))

        ((app? ptree)
         (let ((oper (app-oper ptree))
               (args (app-args ptree)))
           (if (or (cst? oper) (ref? oper))
             (let ((br-oper (br oper substs 'need expansion-limit)))
               ; at this point (or (cst? br-oper) (ref? br-oper))
               (or (br-app-inline ptree br-oper args substs reason expansion-limit)
                   (br-app-simplify ptree br-oper args substs reason expansion-limit)))
             (br-app ptree oper args substs reason expansion-limit))))

        ((fut? ptree)
         (new-fut (node-source ptree) (node-env ptree)
           (br (fut-val ptree) substs 'need expansion-limit)))

        (else
         (compiler-internal-error "br, unknown parse tree node type"))))

(define (var-subst var substs)
  (if (null? substs)
    var
    (let ((couple (car substs)))
      (if (eq? (car couple) var)
        (if (ref? (cdr couple))
          (var-subst (ref-var (cdr couple)) (cdr substs))
          var)
        (var-subst var (cdr substs))))))

(define (var-to-val var substs)
  (if (global? var)
    (global-single-def var)
    (let ((x (assq var substs)))
      (if x (cdr x) #f))))

(define (br-app ptree oper args substs reason expansion-limit)
  (if (and (prc? oper) ; applying a lambda-expr is like a 'let'
           (prc-req-and-opt-parms-only? oper)
           (= (length (prc-parms oper)) (length args)))
    (br-let ptree oper args substs reason expansion-limit)
    (new-call (node-source ptree) (node-env ptree)
      (br oper substs 'need expansion-limit)
      (map (lambda (arg) (br arg substs 'need expansion-limit)) args))))

(define (br-let ptree proc vals substs reason expansion-limit)
  (let* ((vars
          (prc-parms proc))
         (vars-varset
          (list->varset vars))
         (var-val-map
          (pair-up vars vals))
         (new-substs
          (br-extend-substs vars vals substs))
         (br-vals
          (map (lambda (x) (br x new-substs 'need expansion-limit)) vals))
         (new-substs2
          (br-extend-substs vars br-vals substs))
         (new-body
          (br (prc-body proc) new-substs2 reason expansion-limit)))

    (define (var->val var) (cdr (assq var var-val-map)))

    (define (reachable-vars-from starting-point)
      (let loop ((old-reachable-vars
                  (varset-empty))
                 (reachable-vars
                  (varset-intersection
                   vars-varset
                   starting-point)))
        (if (varset-equal? reachable-vars old-reachable-vars)
          reachable-vars
          (loop reachable-vars
                (varset-union-multi
                 (cons reachable-vars
                       (map (lambda (var)
                              (varset-intersection
                               vars-varset
                               (bound-free-variables (var->val var))))
                            (varset->list
                             (varset-difference reachable-vars
                                                old-reachable-vars)))))))))

    ; remove useless bindings

    (let ((reachable-vars
           (reachable-vars-from
            (varset-union-multi
             (cons (bound-free-variables new-body)
                   (map (lambda (br-val)
                          (if (prc? br-val)
                            (varset-empty) ; reachable only if called
                            (bound-free-variables br-val)))
                        br-vals))))))
      (let loop ((l1 vars)
                 (l2 br-vals)
                 (new-vars '())
                 (new-vals '()))
        (if (null? l1)
          (new-let ptree
                   proc
                   (reverse new-vars)
                   (reverse new-vals)
                   new-body)
          (let ((var (car l1))
                (br-val (car l2)))
            (if (and (not (varset-member? var reachable-vars))
                     (or (cst? br-val)
                         (ref? br-val)
                         (prc? br-val)))
              (begin
                (delete-ptree br-val)
                (loop (cdr l1)
                      (cdr l2)
                      new-vars
                      new-vals))
              (loop (cdr l1)
                    (cdr l2)
                    (cons var new-vars)
                    (cons br-val new-vals)))))))))

(define (br-extend-substs vars vals substs)
  (let loop ((l1 vars)
             (l2 vals)
             (new-substs substs))
    (if (null? l1)
      new-substs
      (let ((var (car l1))
            (val (car l2)))
        (cond ((or (cst? val)
                   (and (ref? val)
                        (or (bound? (ref-var val))
                            (global-singly-bound? val)))
                   (and (prc? val)
                        (ptset-every? oper-pos? (var-refs var))))
               (loop (cdr l1)
                     (cdr l2)
                     (cons (cons var val) new-substs)))
              (else
               (loop (cdr l1)
                     (cdr l2)
                     new-substs)))))))

(define (br-app-inline ptree br-oper args substs reason expansion-limit)

  ; invariant: (or (cst? br-oper) (ref? br-oper))

  (and (ref? br-oper)
       (let* ((var (ref-var br-oper))
              (val (var-to-val var substs)))

         (define (inline-procedure new-expansion-limit)
           (let ((cloned-oper (clone-ptree val)))
             (delete-ptree br-oper)
             (br-app ptree cloned-oper args substs reason
                     new-expansion-limit)))

         (and val
              (prc? val)
              (inline? (node-env val))
              (if (and (bound? var)
                       (= (ptset-size (var-refs var)) 1)
                       (not (varset-member? var (bound-free-variables val))))

                ; Procedure is referenced once and it is not direcly
                ; recursive so inline it without changing the
                ; expansion limit (the original code will be removed
                ; by br-let).

                (inline-procedure expansion-limit)

                ; Procedure is referenced more than once or it is
                ; directly recursive so we inline it only if we
                ; don't exceed the expansion limit.

                (let* ((size-val
                        (ptree-size val))
                       (size-ptree
                        (ptree-size ptree))
                       (new-limit
                        (- (if expansion-limit
                             (car expansion-limit)
                             (quotient (* (inlining-limit (node-env ptree))
                                          size-ptree)
                                       100))
                           (- size-val 1))))
                  (and (>= new-limit 0)
                       (if expansion-limit
                         (begin
                           (set-car! expansion-limit new-limit)
                           (inline-procedure expansion-limit))
                         (inline-procedure (list new-limit))))))))))

(define (br-app-simplify ptree br-oper args substs reason expansion-limit)

  ; invariant: (or (cst? br-oper) (ref? br-oper))

  (let* ((br-args
          (map (lambda (arg) (br arg substs 'need expansion-limit)) args))
         (proc
          (and (constant-fold? (node-env ptree))
               (specialize-app br-oper br-args (node-env ptree))))
         (simp
          (and proc
               (nb-args-conforms? (length args) (proc-obj-call-pat proc))
               (proc-obj-simplify proc)))
         (simplified-ptree
          (and simp
               (simp ptree br-args))))
    (if simplified-ptree
      (begin
        (delete-ptree br-oper)
        (for-each delete-ptree br-args)
        simplified-ptree)
      (new-call (node-source ptree) (node-env ptree)
        br-oper
        br-args))))

(define (ptree-size ptree)
  (let loop ((lst (node-children ptree)) (n 1))
    (if (null? lst)
      n
      (loop (cdr lst) (+ n (ptree-size (car lst)))))))

(define (side-effects-impossible? ptree)

  (cond ((cst? ptree)
         #t)

        ((ref? ptree)
         #t)

        ((set? ptree) ; variable guaranteed to be a global variable
         #f)

        ((tst? ptree)
         (and (side-effects-impossible? (tst-pre ptree))
              (side-effects-impossible? (tst-con ptree))
              (side-effects-impossible? (tst-alt ptree))))

        ((conj? ptree)
         (and (side-effects-impossible? (conj-pre ptree))
              (side-effects-impossible? (conj-alt ptree))))

        ((disj? ptree)
         (and (side-effects-impossible? (disj-pre ptree))
              (side-effects-impossible? (disj-alt ptree))))

        ((prc? ptree)
         #t)

        ((app? ptree)
         (let ((oper (app-oper ptree))
               (args (app-args ptree)))
           (and (every? side-effects-impossible? args)
                (if (and (prc? oper) ; applying a lambda-expr is like a 'let'
                         (prc-req-and-opt-parms-only? oper)
                         (= (length (prc-parms oper)) (length args)))
                  (side-effects-impossible? (prc-body oper))
                  (let ((proc (app->specialized-proc ptree)))
                    (and proc
                         (not (proc-obj-side-effects? proc))))))))

        ((fut? ptree)
         (side-effects-impossible? (fut-val ptree)))

        (else
         (compiler-internal-error "side-effects-impossible?, unknown parse tree node type"))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; Lambda-lifting procedure:
;; ------------------------

;; (lambda-lift lst) takes a list of parse-trees and returns a list
;; where each parse-tree has been modified so that some of its
;; procedures (i.e. lambda-expressions) are replaced with weaker ones
;; (i.e. lambda-expressions having fewer or no closed variables).  It
;; is assumed that 'ptree' has already been assignment-converted.  The
;; only procedures that are lambda-lifted are named procedures and
;; procedures which are passed to some primitive higher-order functions
;; (such as call-with-current-continuation).

(define (lambda-lift lst)
  (for-each (lambda (ptree)
              (ll! ptree (varset-empty) '()))
            lst)
  lst)

(define (ll! ptree cst-procs env)

  (define (new-env env vars)
    (define (loop i l)
      (if (pair? l)
        (let ((var (car l)))
          (cons (cons var (cons (ptset-size (var-refs var)) i))
                (loop (+ i 1) (cdr l))))
        env))
    (loop (length env) vars))

  (cond ((or (cst? ptree)
             (ref? ptree)
             (set? ptree)
             (def? ptree) ; guaranteed to be a toplevel definition
             (tst? ptree)
             (conj? ptree)
             (disj? ptree)
             (fut? ptree))
         (for-each (lambda (child) (ll! child cst-procs env))
                   (node-children ptree)))

        ((prc? ptree)
         (ll! (prc-body ptree) cst-procs (new-env env (prc-parms ptree))))

        ((app? ptree)
         (let ((oper (app-oper ptree))
               (args (app-args ptree)))
           (if (and (prc? oper) ; applying a lambda-expr is like a 'let'
                    (prc-req-and-opt-parms-only? oper)
                    (= (length (prc-parms oper)) (length args)))
             (ll!-let ptree cst-procs (new-env env (prc-parms oper)))
             (ll!-call ptree cst-procs env))))

        (else
         (compiler-internal-error "ll!, unknown parse tree node type"))))

(define (ll!-call ptree cst-procs env)

  (for-each (lambda (child) (ll! child cst-procs env))
            (node-children ptree))

  (let* ((oper (app-oper ptree))
         (proc (cond ((cst? oper) (cst-val oper))
                     ((ref? oper) (global-proc-obj oper))
                     (else        #f))))
    (if (proc-obj? proc)
        (let* ((lift-pat
                (proc-obj-lift-pat proc))
               (receiver-arg-pos
                (modulo (quotient lift-pat 1000) 10))
               (min-nb-args
                (modulo (quotient lift-pat 100) 10))
               (nb-req-and-opt-parms
                (modulo (quotient lift-pat 10) 10))
               (max-lifted-vars
                (modulo lift-pat 10))
               (args
                (app-args ptree))
               (nb-args
                (length args)))
          (if (and (< 0 receiver-arg-pos)
                   (<= min-nb-args nb-args))
              (let ((receiver
                     (list-ref args (- receiver-arg-pos 1))))
                (if (and (prc? receiver)
                         (lambda-lift? (node-env receiver))
                         (prc-req-and-opt-parms-only? receiver)
                         (<= nb-req-and-opt-parms
                             (length (prc-parms receiver)))
                         (= (- (length (prc-parms receiver))
                               nb-req-and-opt-parms)
                            (- nb-args min-nb-args)))
                    (let ((vars
                           (ll-lifted-vars (bound-free-variables receiver)
                                           cst-procs
                                           env)))
                      (if (and (not (null? vars))
                               (<= (+ (length vars) (- nb-args min-nb-args))
                                   max-lifted-vars))
                          (let ((cloned-vars (clone-vars vars)))

                            ;; modify call site

                            (define (new-ref* var)
                              (new-ref (var-source var) (node-env ptree) var))

                            (node-children-set!
                             ptree
                             (cons oper
                                   (append (take args min-nb-args)
                                           (map new-ref* vars)
                                           (drop args min-nb-args))))

                            ;; modify receiver procedure

                            (prc-parms-set!
                             receiver
                             (append (take (prc-parms receiver)
                                           nb-req-and-opt-parms)
                                     cloned-vars
                                     (drop (prc-parms receiver)
                                           nb-req-and-opt-parms)))
                            (for-each (lambda (x) (var-bound-set! x receiver))
                                      cloned-vars)
                            (node-fv-invalidate! receiver)
                            (for-each (lambda (x y) (var-clone-set! x y))
                                      vars
                                      cloned-vars)
                            (ll-rename! receiver)
                            (for-each (lambda (x) (var-clone-set! x #f))
                                      vars)))))))))))

(define (ll!-let ptree cst-procs env)
  (let* ((proc (app-oper ptree))
         (vals (app-args ptree))
         (vars (prc-parms proc))
         (var-val-map (pair-up vars vals)))

    (define (var->val var) (cdr (assq var var-val-map)))

    (define (liftable-proc-vars vars)
      (let loop ((cst-proc-vars-list
                   (keep (lambda (var)
                           (let ((val (var->val var)))
                             (and (prc? val)
                                  (lambda-lift? (node-env val))
                                  (ptset-every? oper-pos? (var-refs var)))))
                         vars)))
        (let* ((cst-proc-vars
                 (list->varset cst-proc-vars-list))
               (non-cst-proc-vars-list
                 (keep (lambda (var)
                         (let ((val (var->val var)))
                           (and (prc? val)
                                (not (varset-member? var cst-proc-vars)))))
                       vars))
               (non-cst-proc-vars
                 (list->varset non-cst-proc-vars-list))
               (cst-proc-vars-list*
                 (keep (lambda (var)
                         (not (varset-intersects?
                                (bound-free-variables (var->val var))
                                non-cst-proc-vars)))
                       cst-proc-vars-list)))
          (if (= (length cst-proc-vars-list)
                 (length cst-proc-vars-list*))
            cst-proc-vars-list
            (loop cst-proc-vars-list*)))))

    (define (transitively-closed-bound-free-variables vars)
      (let ((tcbfv-map
              (map (lambda (var)
                     (cons var (bound-free-variables (var->val var))))
                   vars)))
        (let loop ()
          (let ((changed? #f))
            (for-each (lambda (var-tcbfv)
                        (let ((tcbfv (cdr var-tcbfv)))
                          (let loop2 ((l (varset->list tcbfv))
                                      (fv tcbfv))
                            (if (null? l)
                              (if (not (= (varset-size fv)
                                          (varset-size tcbfv)))
                                (begin
                                  (set-cdr! var-tcbfv fv)
                                  (set! changed? #t)))
                              (let ((x (assq (car l) tcbfv-map)))
                                (loop2 (cdr l)
                                       (if x
                                         (varset-union fv (cdr x))
                                         fv)))))))
                      tcbfv-map)
            (if changed?
              (loop)
              tcbfv-map)))))

    (let* ((tcbfv-map
             (transitively-closed-bound-free-variables
              (liftable-proc-vars vars)))
           (cst-proc-vars-list
             (map car tcbfv-map))
           (cst-procs*
             (varset-union (list->varset cst-proc-vars-list) cst-procs)))

      (define (var->tcbfv var) (cdr (assq var tcbfv-map)))

      (define (lifted-vars var)
        (ll-lifted-vars (var->tcbfv var) cst-procs* env))

      (define (lift-app! var)
        (let* ((val (var->val var))
               (vars (lifted-vars var)))
          (if (not (null? vars))
            (for-each (lambda (oper)
                        (let ((node (node-parent oper)))

                          (define (new-ref* var)
                            (new-ref (var-source var) (node-env node) var))

                          (node-children-set! node
                            (cons (app-oper node)
                                  (append (map new-ref* vars)
                                          (app-args node))))))
                      (ptset->list (var-refs var))))))

      (define (lift-prc! var)
        (let* ((val (var->val var))
               (vars (lifted-vars var)))
          (if (not (null? vars))
            (let ((cloned-vars (clone-vars vars)))
              (prc-parms-set! val (append cloned-vars (prc-parms val)))
              (for-each (lambda (x) (var-bound-set! x val)) cloned-vars)
              (node-fv-invalidate! val)
              (for-each (lambda (x y) (var-clone-set! x y)) vars cloned-vars)
              (ll-rename! val)
              (for-each (lambda (x) (var-clone-set! x #f)) vars)))))

      (for-each lift-app! cst-proc-vars-list)
      (for-each lift-prc! cst-proc-vars-list)
      (for-each (lambda (node) (ll! node cst-procs* env)) vals)
      (ll! (prc-body proc) cst-procs* env))))

(define (ll-lifted-vars bfv cst-procs env)

  (define (order-vars vars)
    (map car
         (sort-list (map (lambda (var) (assq var env)) vars)
                    (lambda (x y)
;;;;                      (if (= (cadr x) (cadr y))
;;;;                        (< (cddr x) (cddr y))
;;;;                        (< (cadr x) (cadr y)))
                      (< (cddr x) (cddr y))))))

  (order-vars
   (varset->list (varset-difference bfv cst-procs))))

(define (ll-rename! ptree)

  (if (ref? ptree)
    (let* ((var (ref-var ptree))
           (x (var-clone var)))
      (if x
        (begin
          (var-refs-set! var (ptset-remove (var-refs var) ptree))
          (var-refs-set! x (ptset-adjoin (var-refs x) ptree))
          (ref-var-set! ptree x)))))

  (node-fv-set! ptree #t)
  (node-bfv-set! ptree #t)

  (for-each (lambda (child) (ll-rename! child))
            (node-children ptree)))

;;;----------------------------------------------------------------------------
;;
;; Debugging stuff:

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
;;
;; (parse-tree->expression ptree) returns the Scheme expression corresponding to
;; the parse tree 'ptree'.

(define (parse-tree->expression ptree)
  (se ptree '() (list 0)))

(define (se ptree env num)

  (cond ((cst? ptree)
         (let ((val (cst-val ptree)))
           (se-constant val)))

        ((ref? ptree)
         (se-var->id (ref-var ptree) env))

        ((set? ptree)
         (list set!-sym
               (se-var->id (set-var ptree) env)
               (se (set-val ptree) env num)))

        ((def? ptree)
         (list define-sym
               (se-var->id (def-var ptree) env)
               (se (def-val ptree) env num)))

        ((tst? ptree)
         (list if-sym (se (tst-pre ptree) env num)
                      (se (tst-con ptree) env num)
                      (se (tst-alt ptree) env num)))

        ((conj? ptree)
         (list and-sym (se (conj-pre ptree) env num)
                       (se (conj-alt ptree) env num)))

        ((disj? ptree)
         (list or-sym (se (disj-pre ptree) env num)
                      (se (disj-alt ptree) env num)))

        ((prc? ptree)
         (let ((new-env (se-rename ptree env num)))
           (list lambda-sym
                 (se-parameters (prc-parms ptree)
                                (prc-opts ptree)
                                (prc-keys ptree)
                                (prc-rest? ptree)
                                new-env
                                num)
                 (se (prc-body ptree) new-env num))))

        ((app? ptree)
         (let ((oper (app-oper ptree))
               (args (app-args ptree)))
           (if (and (prc? oper) ; applying a lambda-expr is like a 'let'
                    (prc-req-and-opt-parms-only? oper)
                    (= (length (prc-parms oper)) (length args)))
             (let ((new-env (se-rename oper env num)))
               (list
                 (if (varset-intersects?
                       (list->varset (prc-parms oper))
                       (varset-union-multi (map bound-free-variables args)))
                   letrec-sym
                   let-sym)
                 (se-bindings (prc-parms oper) args new-env num)
                 (se (prc-body oper) new-env num)))
             (map (lambda (x) (se x env num)) (cons oper args)))))

        ((fut? ptree)
         (list future-sym (se (fut-val ptree) env num)))

        (else
         (compiler-internal-error "se, unknown parse tree node type"))))

(define use-actual-primitives-in-expression? #t)

(define (se-constant val)
  (if (self-evaluating? val)
    val
    (list quote-sym
          (if (proc-obj? val)
            (if use-actual-primitives-in-expression?
              (eval (string->symbol (proc-obj-name val)))
              (list '*primitive* (proc-obj-name val)))
            val))))

(define (se-var->id var env)
  (let ((id (let ((x (assq var env)))
              (if x (cdr x) (var-name var)))))
;; for debugging:
;;    (string->symbol
;;     (string-append (symbol->string id)
;;                    ":"
;;                    (number->string (##object->serial-number var))))
    id))

(define use-dotted-rest-parameter-when-possible? #t)

(define (se-parameters parms opts keys rest? env num)

  (define (se-required parms n)
    (if (= n 0)
      (se-opts parms)
      (let ((parm (se-var->id (car parms) env)))
        (cons parm (se-required (cdr parms) (- n 1))))))

  (define (se-opts parms)
    (if (null? opts)
      (se-rest-and-keys parms)
      (cons optional-object
            (let loop ((parms parms) (opts opts))
              (if (null? opts)
                (se-rest-and-keys parms)
                (let ((parm (se-var->id (car parms) env)))
                  (cons (list parm (se-constant (car opts)))
                        (loop (cdr parms) (cdr opts)))))))))

  (define (se-rest-and-keys parms)

    (define (se-rest-at-end parm)
      (if use-dotted-rest-parameter-when-possible?
        parm
        (cons rest-object (cons parm '()))))

    (if rest?
      (let ((parm (se-var->id (car (last-pair parms)) env)))
        (if (not keys)
          (se-rest-at-end parm)
          (if (eq? rest? 'dsssl)
            (cons rest-object (cons parm (se-keys parms '())))
            (se-keys parms (se-rest-at-end parm)))))
      (se-keys parms '())))

  (define (se-keys parms tail)
    (if (not keys)
      tail
      (cons key-object
            (let loop ((parms parms) (keys keys))
              (if (null? keys)
                tail
                (let ((parm (se-var->id (car parms) env)))
                  (cons (list parm (se-constant (cdr (car keys))))
                        (loop (cdr parms) (cdr keys)))))))))

  (se-required parms
               (- (length parms)
                  (length opts)
                  (if keys (length keys) 0)
                  (if rest? 1 0))))

(define (se-bindings vars vals env num)
  (if (null? vars)
    '()
    (cons (list (se-var->id (car vars) env) (se (car vals) env num))
          (se-bindings (cdr vars) (cdr vals) env num))))

(define (se-rename proc env num)
  (let* ((parms
          (prc-parms proc))
         (free-vars
          (varset->list (free-variables (prc-body proc))))
         (p-names
          (map var-name parms))
         (fv-names
          (map var-name free-vars))
         (names
          (append p-names fv-names))
         (n
          (length p-names)))

    (define (conflict? var i)
      (let* ((p (pos-in-list var free-vars))
             (k (if p (+ p n) i)))
        (let loop ((lst names) (j 0))
          (if (null? lst)
            #f
            (let ((x (car lst)))
              (if (and (not (= i j))
                       (not (= k j))
                       (eq? x (var-name var)))
                #t
                (loop (cdr lst) (+ j 1))))))))

    (define (rename vars i)
      (if (null? vars)
        env
        (let* ((var (car vars))
               (id (var-name var)))
          (cons (cons var
                      (if (conflict? var i)
                        (begin
                          (set-car! num (+ (car num) 1))
                          (string->symbol
                           (string-append (symbol->string id)
                                          "#"
                                          (number->string (car num)))))
                        id))
                (rename (cdr vars) (+ i 1))))))


    (rename parms 0)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; C-interface stuff:

(define (c-interface-begin module-name)
  (set! c-interface-module-name module-name)
  (set! c-interface-proc-count 0)
  (set! c-interface-obj-count 0)
  (set! c-interface-types scheme-to-c-notation)
  (set! c-interface-release-fns '())
  (set! c-interface-release-fn-count 0)
  (set! c-interface-converters '())
  (set! c-interface-converter-count 0)
  (set! c-interface-decls '())
  (set! c-interface-procs '())
  (set! c-interface-inits '())
  (set! c-interface-objs '())
  #f)

(define (c-interface-end)
  (let ((i (make-c-intf (reverse c-interface-decls)
                        (reverse c-interface-procs)
                        (reverse c-interface-inits)
                        (reverse c-interface-objs))))
    (set! c-interface-module-name #f)
    (set! c-interface-proc-count #f)
    (set! c-interface-obj-count #f)
    (set! c-interface-types #f)
    (set! c-interface-release-fns #f)
    (set! c-interface-release-fn-count #f)
    (set! c-interface-converters #f)
    (set! c-interface-converter-count #f)
    (set! c-interface-decls #f)
    (set! c-interface-procs #f)
    (set! c-interface-inits #f)
    (set! c-interface-objs #f)
    i))

(define c-interface-module-name #f)
(define c-interface-proc-count #f)
(define c-interface-obj-count #f)
(define c-interface-types #f)
(define c-interface-release-fns #f)
(define c-interface-release-fn-count #f)
(define c-interface-converters #f)
(define c-interface-converter-count #f)
(define c-interface-decls #f)
(define c-interface-procs #f)
(define c-interface-inits #f)
(define c-interface-objs #f)

(define (add-c-type name type)
  (set! c-interface-types
    (cons (cons name type) c-interface-types))
  #f)

(define (add-c-decl declaration-string)
  (set! c-interface-decls
    (cons declaration-string c-interface-decls))
  #f)

(define (add-c-proc c-proc)
  (set! c-interface-proc-count (+ c-interface-proc-count 1))
  (set! c-interface-procs
    (cons c-proc c-interface-procs))
  #f)

(define (add-c-init initialization-code-string)
  (set! c-interface-inits
    (cons initialization-code-string c-interface-inits))
  #f)

(define (add-c-obj obj)
  (set! c-interface-obj-count (+ c-interface-obj-count 1))
  (set! c-interface-objs
    (cons obj c-interface-objs))
  #f)

(define (make-c-intf decls procs inits objs) (vector decls procs inits objs))
(define (c-intf-decls c-intf)        (vector-ref c-intf 0))
(define (c-intf-decls-set! c-intf x) (vector-set! c-intf 0 x))
(define (c-intf-procs c-intf)        (vector-ref c-intf 1))
(define (c-intf-procs-set! c-intf x) (vector-set! c-intf 1 x))
(define (c-intf-inits c-intf)        (vector-ref c-intf 2))
(define (c-intf-inits-set! c-intf x) (vector-set! c-intf 2 x))
(define (c-intf-objs c-intf)         (vector-ref c-intf 3))
(define (c-intf-objs-set! c-intf x)  (vector-set! c-intf 3 x))

(define (make-c-proc scheme-name c-name arity body)
  (vector c-proc-tag scheme-name c-name arity body))

(define c-proc-tag (list 'c-proc))

(define (c-proc? x)
  (and (vector? x)
       (> (vector-length x) 0)
       (eq? (vector-ref x 0) c-proc-tag)))

(define (c-proc-scheme-name x) (vector-ref x 1))
(define (c-proc-c-name x)      (vector-ref x 2))
(define (c-proc-arity x)       (vector-ref x 3))
(define (c-proc-body x)        (vector-ref x 4))

(define (**c-define-type-expr? source)
  (and (match **c-define-type-sym -3 source)
       (or (let ((len (length (source-code source))))
             (and (or (= len 3) (= len 6))
                  (proper-c-type-definition? source)))
           (ill-formed-special-form source))))

(define (proper-c-type-definition? source)
  (let* ((code (source-code source))
         (name-source (cadr code))
         (name (source-code name-source)))
    (cond ((not (symbol-object? name))
           (pt-syntax-error
             name-source
             "C type's name must be an identifier"))
          ((assq name c-interface-types)
           (pt-syntax-error
             name-source
             "C type's name is already defined"))
          ((= (length code) 3)
           (let ((type-source (caddr code)))
             (check-c-type type-source #f #t))) ; allow all types
          (else
           (let* ((ctype-source (caddr code))
                  (ctype (source-code ctype-source))
                  (ctos-source (cadddr code))
                  (ctos (source-code ctos-source))
                  (stoc-source (cadddr (cdr code)))
                  (stoc (source-code stoc-source))
                  (cleanup-source (cadddr (cddr code)))
                  (cleanup (source-code cleanup-source)))
             (cond ((not (string? ctype))
                    (pt-syntax-error
                      ctype-source
                      "Second argument to 'c-define-type' must be a string"))
                   ((not (string? ctos))
                    (pt-syntax-error
                      ctos-source
                      "Third argument to 'c-define-type' must be a string"))
                   ((not (valid-c-id? ctos))
                    (pt-syntax-error
                      ctos-source
                      "Ill-formed C function identifier"))
                   ((not (string? stoc))
                    (pt-syntax-error
                      stoc-source
                      "Fourth argument to 'c-define-type' must be a string"))
                   ((not (valid-c-id? stoc))
                    (pt-syntax-error
                      stoc-source
                      "Ill-formed C function identifier"))
                   ((not (or (false-object? cleanup)
                             (eq? cleanup #t)))
                    (pt-syntax-error
                      stoc-source
                      "Fifth argument to 'c-define-type' must be a boolean"))
                   (else
                    #t)))))))

(define (c-type-definition-name source)
  (let ((code (source-code source)))
    (cadr code)))

(define (c-type-definition-type source)
  (let ((code (source-code source)))
    (if (= (length code) 3)
      (vector 'alias
              (caddr code))
      (vector 'c-type
              (source-code (caddr code))
              (source-code (cadddr code))
              (source-code (cadddr (cdr code)))
              (source-code (cadddr (cddr code)))))))

(define (**c-declare-expr? source)
  (and (match **c-declare-sym 2 source)
       (let ((code (source-code source)))
         (or (string? (source-code (cadr code)))
             (pt-syntax-error
               source
               "Argument to 'c-declare' must be a string")))))

(define (c-declaration-body source)
  (cadr (source-code source)))

(define (**c-initialize-expr? source)
  (and (match **c-initialize-sym 2 source)
       (let ((code (source-code source)))
         (or (string? (source-code (cadr code)))
             (pt-syntax-error
               source
               "Argument to 'c-initialize' must be a string")))))

(define (c-initialization-body source)
  (cadr (source-code source)))

(define (**c-lambda-expr? source)
  (and (match **c-lambda-sym 4 source)
       (let ((code (source-code source)))
         (if (not (string? (source-code (cadddr code))))
           (pt-syntax-error
             source
             "Third argument to 'c-lambda' must be a string")
           (check-c-function-type (cadr code) (caddr code) #f)))))

(define (**c-define-expr? source env)
  (and (match **c-define-sym -7 source)
       (proper-c-definition? source env)))

(define (proper-c-definition? source env)
  (let* ((code (source-code source))
         (pattern-source (cadr code))
         (pattern (source-code pattern-source))
         (arg-typs-source (caddr code))
         (res-typ-source (cadddr code))
         (name-source (car (cddddr code)))
         (name (source-code name-source))
         (scope-source (cadr (cddddr code)))
         (scope (source-code scope-source)))
    (cond ((not (pair? pattern))
           (pt-syntax-error
             pattern-source
             "Ill-formed definition pattern"))
          ((not (bindable-var? (car pattern) env))
           (pt-syntax-error
             (car pattern)
             "Procedure name must be an identifier"))
          (else
           (and (check-c-function-type arg-typs-source res-typ-source #f)
                (cond ((not (string? name))
                       (pt-syntax-error
                         name-source
                         "Fourth argument to 'c-define' must be a string"))
                      ((not (valid-c-id? name))
                       (pt-syntax-error
                         name-source
                         "Ill-formed C function identifier"))
                      ((not (string? scope))
                       (pt-syntax-error
                         scope-source
                         "Fifth argument to 'c-define' must be a string"))
                      (else
                       #t)))))))

(define (c-definition-name source)
  (let ((code (source-code source)))
    (car (source-code (cadr code)))))

(define (c-definition-value source)
  (let ((code (source-code source))
        (loc (source-locat source)))
    (make-source
      (cons (make-source **lambda-sym loc)
            (cons (parms->source (cdr (source-code (cadr code))) loc)
                  (cdr (cddddr code))))
      loc)))

(define (c-definition-param-types source)
  (source-code (caddr (source-code source))))

(define (c-definition-result-type source)
  (cadddr (source-code source)))

(define (c-definition-proc-name source)
  (car (cddddr (source-code source))))

(define (c-definition-scope source)
  (cadr (cddddr (source-code source))))

(define (c-type-pt-syntax-error source err-source msg)
  (pt-syntax-error (or err-source source) msg))

(define (check-c-function-type arg-typs-source res-typ-source err-source)
  (and (check-c-arg-types arg-typs-source err-source)
       (check-c-result-type res-typ-source err-source)))

(define (check-c-arg-types arg-typs-source err-source)
  (let ((arg-typs (source-code arg-typs-source)))
    (if (not (proper-length arg-typs))
      (c-type-pt-syntax-error
        arg-typs-source
        err-source
        "Ill-terminated C function argument type list")
      (let loop ((lst arg-typs))
        (if (pair? lst)
          (and (check-c-type (car lst) err-source #f) ; void not allowed
               (loop (cdr lst)))
          #t)))))

(define (check-c-result-type res-typ-source err-source)
  (check-c-type res-typ-source err-source #t)) ; allow all types

(define (check-c-type typ-source err-source void-allowed?)

  (define (ill-formed-c-type)
    (c-type-pt-syntax-error typ-source err-source "Ill-formed C type"))

  (let ((typ (source-code typ-source)))
    (cond ((pair? typ)
           (let ((len (proper-length (cdr typ))))
             (if len
               (let ((head (source-code (car typ))))

                 (define (check pointer? err-msg)
                   (or (and (>= len 1)
                            (<= len 3)
                            (let* ((x-source (cadr typ))
                                   (x (source-code x-source)))
                              (if pointer?
                                (check-c-type
                                 x-source
                                 err-source
                                 #t) ; allow all types
                                (and (string? x)
                                     (valid-c-id? x))))
                            (or (< len 2)
                                (let ((tag (source-code (caddr typ))))
                                  (or (false-object? tag)
                                      (symbol-object? tag)
                                      (and (pair? tag)
                                           (proper-length tag)
                                           (every?
                                            (lambda (x)
                                              (symbol-object?
                                               (source-code x)))
                                            tag)))))
                            (or (< len 3)
                                (let ((id (source-code (cadddr typ))))
                                  (or (false-object? id)
                                      (and (string? id)
                                           (valid-c-id? id))))))
                       (c-type-pt-syntax-error
                        typ-source
                        err-source
                        err-msg)))

                 (define (check-function err-msg)
                   (if (= len 2)
                     (check-c-function-type
                      (cadr typ)
                      (caddr typ)
                      err-source)
                     (c-type-pt-syntax-error
                      typ-source
                      err-source
                      err-msg)))

                 (cond ((eq? head struct-sym)
                        (check #f "Ill-formed C STRUCT type"))
                       ((eq? head union-sym)
                        (check #f "Ill-formed C UNION type"))
                       ((eq? head type-sym)
                        (check #f "Ill-formed C TYPE type"))
                       ((eq? head pointer-sym)
                        (check #t "Ill-formed C POINTER type"))
                       ((eq? head nonnull-pointer-sym)
                        (check #t "Ill-formed C NONNULL POINTER type"))
                       ((eq? head function-sym)
                        (check-function "Ill-formed C FUNCTION type"))
                       ((eq? head nonnull-function-sym)
                        (check-function "Ill-formed C NONNULL FUNCTION type"))
                       (else
                        (ill-formed-c-type))))

               (c-type-pt-syntax-error
                 typ-source
                 err-source
                 "Ill-terminated C type"))))
          ((string? typ)
           (or (valid-c-id? typ)
               (c-type-pt-syntax-error
                typ-source
                err-source
                "Ill-formed C type identifier")))
          ((symbol-object? typ)
           (if (eq? typ void-sym)
             (or void-allowed?
                 (c-type-pt-syntax-error
                   typ-source
                   err-source
                   "Ill-placed C VOID type"))
             (let ((x (assq typ c-interface-types)))
               (if x
                 (let ((def (cdr x)))
                   (case (vector-ref def 0)
                     ((c-type)
                      #t)
                     (else
                      (check-c-type
                        (vector-ref def 1)
                        typ-source
                        void-allowed?))))
                 (c-type-pt-syntax-error
                   typ-source
                   err-source
                   "Undefined C type identifier")))))
          (else
           (ill-formed-c-type)))))

(define (resolve-type typ-source)
  (let ((typ (source-code typ-source)))
    (if (symbol-object? typ)
      (let ((x (assq typ c-interface-types)))
        (if x
          (let ((def (cdr x)))
            (if (eq? (vector-ref def 0) 'alias)
              (resolve-type (vector-ref def 1))
              typ-source))
          typ-source))
      typ-source)))

(define (void-type? typ-source)
  (eq? (source-code (resolve-type typ-source)) void-sym))

(define (scmobj-type? typ-source)
  (eq? (source-code (resolve-type typ-source)) scheme-object-sym))

(define (type-needs-cleanup? typ-source)
  (let ((typ (source-code typ-source)))
    (cond ((pair? typ)
           (let ((head (source-code (car typ))))
             (or (eq? head struct-sym)
                 (eq? head union-sym)
                 (eq? head type-sym)
                 (eq? head function-sym)
                 (eq? head nonnull-function-sym))))
          ((string? typ)
           #t)
          ((symbol-object? typ)
           (let ((x (assq typ c-interface-types)))
             (if x
               (let ((def (cdr x)))
                 (case (vector-ref def 0)
                   ((c-type)
                    (vector-ref def 4))
                   (else
                    (type-needs-cleanup? (vector-ref def 1)))))
               #f)))
          (else
           #f))))

(define (type-accessed-indirectly? typ-source)
  (let ((typ (source-code typ-source)))
    (cond ((pair? typ)
           (let ((head (source-code (car typ))))
             (cond ((eq? head struct-sym)
                    (vector "STRUCT" (source-code (cadr typ))))
                   ((eq? head union-sym)
                    (vector "UNION" (source-code (cadr typ))))
                   ((eq? head type-sym)
                    (vector "TYPE" (source-code (cadr typ))))
                   ((eq? head pointer-sym)
                    '#("POINTER" #f))
                   ((eq? head nonnull-pointer-sym)
                    '#("NONNULLPOINTER" #f))
                   ((eq? head function-sym)
                    '#("FUNCTION" #f))
                   ((eq? head nonnull-function-sym)
                    '#("NONNULLFUNCTION" #f))
                   (else
                    #f))))
          ((string? typ)
           (vector "TYPE" typ))
          ((symbol-object? typ)
           (let ((x (assq typ c-interface-types)))
             (if x
               (let ((def (cdr x)))
                 (case (vector-ref def 0)
                   ((c-type)
                    #f)
                   (else
                    (type-accessed-indirectly? (vector-ref def 1)))))
               #f)))
          (else
           #f))))

(define (pt-c-lambda source env use)
  (let ((name
         (build-c-lambda
           (c-lambda-param-types source)
           (c-lambda-result-type source)
           (source-code (c-lambda-proc-name source)))))
    (new-ref source
             env
             (env-lookup-global-var env (string->symbol name)))))

(define (c-lambda-param-types source)
  (source-code (cadr (source-code source))))

(define (c-lambda-result-type source)
  (caddr (source-code source)))

(define (c-lambda-proc-name source)
  (cadddr (source-code source)))

(define (number-from-1 lst)
  (let loop ((i 1) (lst1 lst) (lst2 '()))
    (if (pair? lst1)
      (loop (+ i 1) (cdr lst1) (cons (cons (car lst1) i) lst2))
      (reverse lst2))))

(define (c-type-converter to-scmobj? typ from to)

  (define (err)
    (compiler-internal-error "c-type-converter, unknown C type"))

  (define (convert kind name tag id)
    (let ((tag-str
           (if (false-object? tag)
             (string-append c-id-prefix "FAL")
             (let* ((tag-list (if (symbol-object? tag) (list tag) tag))
                    (x (object-pos-in-list tag-list c-interface-objs)))
               (string-append
                c-id-prefix
                "C_OBJ_"
                (number->string
                 (if x
                   (- (- c-interface-obj-count x) 1)
                   (let ((n c-interface-obj-count))
                     (add-c-obj tag-list)
                     n))))))))
      (if to-scmobj?

        (string-append
         (cond ((eq? kind pointer-sym)
                "POINTER_TO_SCMOBJ(")
               ((eq? kind nonnull-pointer-sym)
                "NONNULLPOINTER_TO_SCMOBJ(")
               (else
                (string-append
                 (cond ((eq? kind struct-sym)
                        "STRUCT_TO_SCMOBJ(")
                       ((eq? kind union-sym)
                        "UNION_TO_SCMOBJ(")
                       (else
                        "TYPE_TO_SCMOBJ("))
                 name
                 ",")))
         from "_voidstar," tag-str ","
         (if (false-object? id)
           (if (or (eq? kind pointer-sym)
                   (eq? kind nonnull-pointer-sym))
             (string-append
              c-id-prefix
              "RELEASE_POINTER")
             (let* ((descr
                     (cons kind name))
                    (x
                     (assoc descr c-interface-release-fns)))
               (if x
                 (cdr x)
                 (let* ((i
                         c-interface-release-fn-count)
                        (release-fn
                         (string-append
                          c-id-prefix
                          "release_fn"
                          (number->string i))))
                   (set! c-interface-release-fn-count
                     (+ i 1))
                   (set! c-interface-release-fns
                     (cons (cons descr release-fn)
                           c-interface-release-fns))
                   (add-c-decl
                    (string-append
                     c-id-prefix
                     (cond ((eq? kind struct-sym)
                            "DEF_RELEASE_FN_STRUCT(")
                           ((eq? kind union-sym)
                            "DEF_RELEASE_FN_UNION(")
                           (else
                            "DEF_RELEASE_FN_TYPE("))
                     name
                     ","
                     release-fn
                     ")"))
                   release-fn))))
           id)
         "," to)

        (string-append
         (cond ((eq? kind pointer-sym)
                "SCMOBJ_TO_POINTER(")
               ((eq? kind nonnull-pointer-sym)
                "SCMOBJ_TO_NONNULLPOINTER(")
               (else
                (string-append
                 (cond ((eq? kind struct-sym)
                        "SCMOBJ_TO_STRUCT(")
                       ((eq? kind union-sym)
                        "SCMOBJ_TO_UNION(")
                       (else
                        "SCMOBJ_TO_TYPE("))
                 name
                 ",")))
         from "," to "_voidstar," tag-str))))

  (let ((t (source-code typ)))
    (cond ((pair? t)
           (let ((head (source-code (car t)))
                 (len (length (cdr t))))
             (cond ((or (eq? head struct-sym)
                        (eq? head union-sym)
                        (eq? head type-sym)
                        (eq? head pointer-sym)
                        (eq? head nonnull-pointer-sym))
                    (convert
                     head
                     (source-code (cadr t))
                     (if (>= len 2)
                       (source->expression (caddr t))
                       (string->symbol (c-type-decl typ "")))
                     (if (>= len 3)
                       (source-code (cadddr t))
                       false-object)))
                   ((or (eq? head function-sym)
                        (eq? head nonnull-function-sym))
                    (if to-scmobj?
                      (string-append
                       (if (eq? head function-sym)
                         "FUNCTION_TO_SCMOBJ("
                         "NONNULLFUNCTION_TO_SCMOBJ(")
                       from "_voidstar," to)
                      (let ((converter
                             (fn-param-converter typ)))
                        (string-append
                         (if (eq? head function-sym)
                           "SCMOBJ_TO_FUNCTION("
                           "SCMOBJ_TO_NONNULLFUNCTION(")
                         from "," converter "," to "_voidstar"))))
                   (else
                    (err)))))
          ((string? t)
           (convert
            type-sym
            t
            false-object
            false-object))
          ((symbol-object? t)
           (let ((x (assq t c-interface-types)))
             (if x
               (let ((def (cdr x)))
                 (case (vector-ref def 0)
                   ((c-type)
                    (if to-scmobj?
                      (string-append
                       (vector-ref def 2)
                       "(" from "," to)
                      (string-append
                       (vector-ref def 3)
                       "(" from "," to)))
                   (else
                    (c-type-converter
                      to-scmobj?
                      (vector-ref def 1)
                      from
                      to))))
               (err))))
          (else
           (err)))))

(define nl-str (string #\newline))

(define (c-preproc-define id val body)
  (string-append
    "#define " id " " val nl-str
    body
    "#undef " id nl-str))

(define (c-preproc-define-default-empty id body)
  (string-append
    "#undef " id nl-str
    body
    "#ifndef " id nl-str
    "#define " id nl-str
    "#endif" nl-str))

(define (c-result sfun? scheme-side?)
  (string-append
    c-id-prefix
    (if scheme-side?
      (if sfun? "SFUN_RESULT" "CFUN_RESULT")
      "result")))

(define (c-argument scheme-side? numbered-typ)
  (let ((i (number->string (cdr numbered-typ))))
    (string-append
      c-id-prefix
      (if scheme-side? "ARG" "arg")
      i)))

(define (c-declare-argument sfun? numbered-typ body)
  (let* ((c-id (c-argument #f numbered-typ))
         (scm-id (c-argument #t numbered-typ))
         (typ (car numbered-typ))
         (i (number->string (cdr numbered-typ)))
         (scmobj? (scmobj-type? typ))
         (indirect-access (type-accessed-indirectly? typ)))
    (string-append
      c-id-prefix
      (if scmobj?
        (if sfun? "BEGIN_SFUN_ARG_SCMOBJ(" "BEGIN_CFUN_ARG_SCMOBJ(")
        (if sfun? "BEGIN_SFUN_ARG(" "BEGIN_CFUN_ARG("))
      i
      (if scmobj?
        ""
        (string-append
         ","
         (if sfun?
           scm-id
           (if indirect-access
             (string-append "void* " c-id "_voidstar")
             (c-type-decl typ c-id)))))
      ")" nl-str
      (if indirect-access
        (if sfun?
          (if (vector-ref indirect-access 1)
            (let ((tail
                   (string-append
                    (vector-ref indirect-access 0)
                    "("
                    (vector-ref indirect-access 1)
                    ","
                    c-id "_voidstar,"
                    c-id
                    ")" nl-str)))
              (string-append
               c-id-prefix "BEGIN_SFUN_COPY_" tail
               body
               c-id-prefix "END_SFUN_COPY_" tail))
            (c-preproc-define
             (string-append c-id "_voidstar")
             (string-append c-id-prefix "SFUN_CAST(void*," c-id ")")
             body))
          (c-preproc-define
           c-id
           (string-append
            c-id-prefix
            (if (vector-ref indirect-access 1)
              (string-append
               "CFUN_CAST_AND_DEREF("
               (c-type-decl typ "*"))
              (string-append
               "CFUN_CAST("
               (c-type-decl typ "")))
            ","
            c-id "_voidstar)")
           body))
        body)
      c-id-prefix
      (if scmobj?
        (if sfun? "END_SFUN_ARG_SCMOBJ(" "END_CFUN_ARG_SCMOBJ(")
        (if sfun? "END_SFUN_ARG(" "END_CFUN_ARG("))
      i ")" nl-str)))

(define (c-convert-representation sfun? to-scmobj? typ from to i body)
  (let ((tail
         (string-append
          (c-type-converter to-scmobj? typ from to)
          (if i (string-append "," i) "")
          ")" nl-str)))
    (string-append
     c-id-prefix (if sfun? "BEGIN_SFUN_" "BEGIN_CFUN_") tail
     body
     c-id-prefix (if sfun? "END_SFUN_" "END_CFUN_") tail)))

(define (c-convert-argument sfun? numbered-typ body)
  (let* ((typ
          (car numbered-typ))
         (from
          (c-argument (not sfun?) numbered-typ))
         (to
          (c-argument sfun? numbered-typ))
         (i
          (number->string (cdr numbered-typ)))
         (decl
          (c-declare-argument
            sfun?
            numbered-typ
            (if (scmobj-type? typ)
              (c-preproc-define to from body)
              (c-convert-representation sfun? sfun? typ from to i body)))))
    (if sfun?
      decl
      (c-preproc-define
        from
        (string-append
          c-id-prefix
          "CFUN_ARG("
          i
          ")")
        decl))))

(define (c-set-result sfun? result-typ)
  (cond ((void-type? result-typ)
         (string-append
           c-id-prefix
           (if sfun? "SFUN_SET_RESULT_VOID" "CFUN_SET_RESULT_VOID")
           nl-str))
        ((scmobj-type? result-typ)
         (string-append
           c-id-prefix
           (if sfun? "SFUN_SET_RESULT_SCMOBJ" "CFUN_SET_RESULT_SCMOBJ")
           nl-str))
        (else
         (c-convert-representation
           sfun?
           (not sfun?)
           result-typ
           (c-result sfun? sfun?)
           (c-result sfun? (not sfun?))
           #f
           (string-append
             c-id-prefix
             (if sfun? "SFUN_SET_RESULT" "CFUN_SET_RESULT")
             nl-str)))))

(define (c-make-function sfun? param-typs result-typ make-body)
  (let ((cleanup?
         (not (every? (lambda (t) (not (type-needs-cleanup? t)))
                      param-typs))))

    (define (convert-param-list)

      (define (scmobj-typ? numbered-typ)
        (scmobj-type? (car numbered-typ)))

      (define (not-scmobj-typ? numbered-typ)
        (not (scmobj-typ? numbered-typ)))

      (let ((numbered-param-typs (number-from-1 param-typs)))
        (let convert ((numbered-typs
                        (append (keep scmobj-typ? numbered-param-typs)
                                (keep not-scmobj-typ? numbered-param-typs))))
          (if (null? numbered-typs)
            (make-body (c-set-result sfun? result-typ) cleanup?)
            (c-convert-argument
              sfun?
              (car numbered-typs)
              (convert (cdr numbered-typs)))))))

    (c-preproc-define

      (string-append c-id-prefix "NARGS")

      (number->string (length param-typs))

      (if (void-type? result-typ)

        (string-append
          c-id-prefix
          (if sfun?
            (string-append
             "BEGIN_SFUN_VOID("
             sfun?
             ")")
            "BEGIN_CFUN_VOID")
          nl-str
          (convert-param-list)
          c-id-prefix
          (if sfun?
            "SFUN_ERROR_VOID"
            (if cleanup? "CFUN_ERROR_CLEANUP_VOID" "CFUN_ERROR_VOID"))
          nl-str
          (if sfun?
            (c-set-result sfun? result-typ)
            "")
          c-id-prefix
          (if sfun? "END_SFUN_VOID" "END_CFUN_VOID") nl-str)

        (let* ((c-id
                (c-result sfun? #f))
               (scmobj-result?
                (scmobj-type? result-typ))
               (indirect-access-result
                (type-accessed-indirectly? result-typ))
               (body
                (string-append
                  c-id-prefix
                  (if scmobj-result?
                    (if sfun?
                      (string-append
                       "BEGIN_SFUN_SCMOBJ("
                       sfun?
                       ")")
                      "BEGIN_CFUN_SCMOBJ")
                    (string-append
                      (if sfun?
                        (string-append
                          "BEGIN_SFUN("
                          sfun?
                          ",")
                        "BEGIN_CFUN(")
                      (if indirect-access-result
                        (string-append "void* " c-id "_voidstar"
                                       (if sfun? " = 0" ""))
                        (c-type-decl result-typ c-id))
                      ")"))
                  nl-str
                  (convert-param-list)
                  c-id-prefix
                  (if scmobj-result?
                    (if sfun?
                      "SFUN_ERROR_SCMOBJ"
                      (if cleanup? "CFUN_ERROR_CLEANUP_SCMOBJ" "CFUN_ERROR_SCMOBJ"))
                    (if sfun?
                      "SFUN_ERROR"
                      (if cleanup? "CFUN_ERROR_CLEANUP" "CFUN_ERROR")))
                  nl-str
                  (if sfun?
                    (c-set-result sfun? result-typ)
                    "")
                  c-id-prefix
                  (if scmobj-result?
                    (if sfun? "END_SFUN_SCMOBJ" "END_CFUN_SCMOBJ")
                    (if sfun? "END_SFUN" "END_CFUN"))
                  nl-str
                  (if sfun?
                    (string-append "return " c-id ";" nl-str)
                    ""))))
           (if indirect-access-result
             (c-preproc-define
              c-id
              (string-append
               c-id-prefix
               (if (vector-ref indirect-access-result 1)
                 (string-append
                  (if sfun? "SFUN_CAST_AND_DEREF(" "CFUN_CAST_AND_DEREF(")
                  (c-type-decl result-typ "*"))
                 (string-append
                  (if sfun? "SFUN_CAST(" "CFUN_CAST(")
                  (c-type-decl result-typ "")))
               ","
               c-id "_voidstar)")
              body)
             body))))))

(define (comma-separated strs)
  (if (null? strs)
    ""
    (string-append
      (car strs)
      (apply string-append
             (map (lambda (s) (string-append "," s)) (cdr strs))))))

(define (c-type-decl typ inner)

  (define (err)
    (compiler-internal-error "c-type-decl, unknown C type"))

  (define (prefix-inner str)
    (if (and (> (string-length inner) 0)
             (c-id-subsequent? (string-ref inner 0)))
      (string-append str " " inner)
      (string-append str inner)))

  (let ((t (source-code typ)))
    (cond ((pair? t)
           (let ((head (source-code (car t))))
             (cond ((eq? head struct-sym)
                    (prefix-inner
                      (string-append "struct " (source-code (cadr t)))))
                   ((eq? head union-sym)
                    (prefix-inner
                      (string-append "union " (source-code (cadr t)))))
                   ((eq? head type-sym)
                    (prefix-inner
                      (source-code (cadr t))))
                   ((or (eq? head pointer-sym)
                        (eq? head nonnull-pointer-sym))
                    (c-type-decl (cadr t)
                                 (string-append "*" inner)))
                   ((or (eq? head function-sym)
                        (eq? head nonnull-function-sym))
                    (c-type-decl (caddr t)
                                 (string-append
                                   "(*" inner ") "
                                   (c-param-list-with-types
                                     (source-code (cadr t))))))
                   (else
                    (err)))))
          ((string? t)
           (prefix-inner t))
          ((symbol-object? t)
           (let ((x (assq t c-interface-types)))
             (if x
               (let ((def (cdr x)))
                 (case (vector-ref def 0)
                   ((c-type)
                    (prefix-inner (vector-ref def 1)))
                   (else
                    (c-type-decl (vector-ref def 1) inner))))
               (err))))
          (else
           (err)))))

(define (c-param-list-with-types typs)
  (if (null? typs)
    (string-append c-id-prefix "PVOID")
    (string-append
      c-id-prefix
      "P(("
      (comma-separated (map (lambda (typ) (c-type-decl typ "")) typs))
      "),())")))

(define (c-param-id numbered-typ)
  (c-argument #f numbered-typ))

(define (c-param-list-with-ids numbered-typs)
  (if (null? numbered-typs)
    (string-append c-id-prefix "PVOID")
    (string-append
      c-id-prefix
      "P(("
      (comma-separated
        (map (lambda (t) (c-type-decl (car t) (c-param-id t)))
             numbered-typs))
      "),("
      (comma-separated (map c-param-id numbered-typs))
      ")"
      (apply string-append
             (map (lambda (t)
                    (string-append
                     nl-str
                     (c-type-decl (car t) (c-param-id t))
                     ";"))
                  numbered-typs))
      ")")))

(define (c-function-decl param-typs result-typ id scope body)
  (let ((numbered-typs (number-from-1 param-typs)))
    (let ((function-decl
           (c-type-decl result-typ
                        (string-append
                          id
                          " "
                          (if body
                            (c-param-list-with-ids numbered-typs)
                            (c-param-list-with-types param-typs))))))
      (if body
        (string-append
          scope " "
          function-decl nl-str
          "{" nl-str body "}" nl-str)
        (string-append
          function-decl ";" nl-str)))))

(define (c-function param-typs result-typ proc-name c-defined? scope)
  (let ((proc-val
         (if c-defined?
           (string-append
            c-id-prefix "MLBL(" c-id-prefix "C_LBL_" proc-name ")")
           (string-append
            c-id-prefix "FAL"))))

    (define (make-body set-result-code cleanup?)
      (string-append
        c-id-prefix "BEGIN_SFUN_BODY" nl-str
        (let convert ((numbered-typs (number-from-1 param-typs)))
          (if (null? numbered-typs)
            (string-append
              c-id-prefix
              (cond ((void-type? result-typ)
                     "SFUN_CALL_VOID")
                    ((scmobj-type? result-typ)
                     "SFUN_CALL_SCMOBJ")
                    (else
                     "SFUN_CALL"))
              nl-str)
            (let ((numbered-typ (car numbered-typs)))
              (string-append
                c-id-prefix
                "SFUN_ARG("
                (number->string (cdr numbered-typ))
                ","
                (c-argument #t numbered-typ)
                ")" nl-str
                (convert (cdr numbered-typs))))))
        set-result-code
        c-id-prefix "END_SFUN_BODY" nl-str))

    (add-c-decl
     (c-function-decl param-typs
                      result-typ
                      proc-name
                      scope
                      (c-make-function proc-val
                                       param-typs
                                       result-typ
                                       make-body)))))

(define (fn-param-converter typ)
  (let ((function-c-type (c-type-decl typ "")))
    (cond ((assoc function-c-type c-interface-converters)
           =>
           cdr)
          (else
           (let* ((t
                   (source-code typ))
                  (param-typs
                   (source-code (cadr t)))
                  (result-typ
                   (caddr t))
                  (i
                   c-interface-converter-count)
                  (converter
                   (string-append
                    c-id-prefix
                    "converter"
                    (number->string i))))
             (set! c-interface-converter-count
               (+ i 1))
             (set! c-interface-converters
               (cons (cons function-c-type converter)
                     c-interface-converters))
             (c-function
              param-typs
              result-typ
              converter
              #f
              (string-append c-id-prefix "LOCAL"))
             converter)))))

(define (build-c-define param-typs result-typ proc-name scope)
  (c-function param-typs result-typ proc-name #t scope))

(define (strip-param-typs param-typs)
  param-typs);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (build-c-lambda param-typs result-typ proc-name)
  (let* ((index
           (number->string c-interface-proc-count))
         (scheme-name
           (string-append module-prefix c-interface-module-name "#" index))
         (c-name
           (string-append c-id-prefix (scheme-id->c-id scheme-name)))
         (arity
           (length param-typs))
         (stripped-param-typs
           (strip-param-typs param-typs)))

    (define (make-body set-result-code cleanup?)
      (string-append
        c-id-prefix
        (if cleanup? "BEGIN_CFUN_BODY_CLEANUP" "BEGIN_CFUN_BODY")
        nl-str
        (c-preproc-define-default-empty
          (string-append c-id-prefix "AT_END")
          (string-append
           (if (valid-c-id? proc-name)
             (let ((c-id
                    (c-result #f #f))
                   (indirect-access-result
                    (type-accessed-indirectly? result-typ))
                   (call
                    (string-append
                     proc-name "("
                     (comma-separated
                      (map c-param-id (number-from-1 stripped-param-typs)))
                     ")")))
               (cond ((void-type? result-typ)
                      (string-append
                       c-id-prefix
                       "CFUN_CALL_VOID("
                       call
                       ")"))
                     (indirect-access-result
                      (if (vector-ref indirect-access-result 1)
                        (string-append
                         c-id-prefix
                         "CFUN_CALL_"
                         (vector-ref indirect-access-result 0)
                         "("
                         (vector-ref indirect-access-result 1)
                         ","
                         c-id "_voidstar,"
                         call
                         ")")
                        (string-append
                         c-id-prefix
                         "CFUN_CALL_"
                         (vector-ref indirect-access-result 0)
                         "("
                         c-id "_voidstar,"
                         call
                         ")")))
                     (else
                      (string-append
                       c-id-prefix
                       "CFUN_CALL("
                       c-id ","
                       call
                       ")"))))
             proc-name)
           nl-str))
        set-result-code
        c-id-prefix
        (if cleanup? "END_CFUN_BODY_CLEANUP" "END_CFUN_BODY")
        nl-str))

    (add-c-proc
      (make-c-proc scheme-name
                   c-name
                   arity
                   (c-make-function #f
                                    stripped-param-typs
                                    result-typ
                                    make-body)))
    scheme-name))

(define (scheme-id->c-id s)
  (let loop1 ((i (- (string-length s) 1)) (lst '()))
    (if (>= i 0)
      (let ((c (string-ref s i)))
        (cond ((char=? c #\_)
               (loop1 (- i 1) (cons c (cons c lst))))
              ((c-id-subsequent? c)
               (loop1 (- i 1) (cons c lst)))
              (else
               (let ((n (character->unicode c)))
                 (if (= n 0)
                   (loop1 (- i 1) (cons #\_ (cons #\0 (cons #\_ lst))))
                   (let loop2 ((n n) (lst (cons #\_ lst)))
                     (if (> n 0)
                       (loop2 (quotient n 16)
                              (cons (string-ref "0123456789abcdef"
                                                (modulo n 16))
                                    lst))
                       (loop1 (- i 1) (cons #\_ lst)))))))))
      (list->str lst))))

(define (c-id-initial? c) ; c is one of #\A..#\Z, #\a..#\z, #\_
  (let ((n (character->unicode c)))
    (or (and (>= n 65) (<= n 90))
        (and (>= n 97) (<= n 122))
        (= n 95))))

(define (c-id-subsequent? c) ; c is one of #\A..#\Z, #\a..#\z, #\_, #\0..#\9
  (let ((n (character->unicode c)))
    (or (and (>= n 65) (<= n 90))
        (and (>= n 97) (<= n 122))
        (= n 95)
        (and (>= n 48) (<= n 57)))))

(define (valid-c-id? id)
  (let ((n (string-length id)))
    (and (> n 0)
         (c-id-initial? (string-ref id 0))
         (let loop ((i (- n 1)))
           (if (> i 0)
             (if (c-id-subsequent? (string-ref id i))
               (loop (- i 1))
               #f)
             #t)))))

;;;============================================================================
