;;============================================================================

;;; File: "_t-univ-3.scm"

;;; Copyright (c) 2011-2021 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2012 by Eric Thivierge, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")
(include-adt "_univadt.scm")

;;----------------------------------------------------------------------------

(define (univ-defs fields methods classes inits all)
  (vector fields methods classes inits all))

(define (univ-defs-fields defs)  (vector-ref defs 0))
(define (univ-defs-methods defs) (vector-ref defs 1))
(define (univ-defs-classes defs) (vector-ref defs 2))
(define (univ-defs-inits defs)   (vector-ref defs 3))
(define (univ-defs-all defs)     (vector-ref defs 4))

(define (univ-make-empty-defs)
  (univ-defs '() '() '() '() '()))

(define (univ-add-field defs field)
  (univ-defs (cons field (univ-defs-fields defs))
             (univ-defs-methods defs)
             (univ-defs-classes defs)
             (univ-defs-inits defs)
             (cons field (univ-defs-all defs))))

(define (univ-add-method defs method)
  (univ-defs (univ-defs-fields defs)
             (cons method (univ-defs-methods defs))
             (univ-defs-classes defs)
             (univ-defs-inits defs)
             (cons method (univ-defs-all defs))))

(define (univ-add-class defs class)
  (univ-defs (univ-defs-fields defs)
             (univ-defs-methods defs)
             (cons class (univ-defs-classes defs))
             (univ-defs-inits defs)
             (cons class (univ-defs-all defs))))

(define (univ-add-init defs init)
  (univ-defs (univ-defs-fields defs)
             (univ-defs-methods defs)
             (univ-defs-classes defs)
             (cons init (univ-defs-inits defs))
             (cons init (univ-defs-all defs))))

(define (univ-defs-combine defs1 defs2)
  (univ-defs (append (univ-defs-fields defs2)
                     (univ-defs-fields defs1))
             (append (univ-defs-methods defs2)
                     (univ-defs-methods defs1))
             (append (univ-defs-classes defs2)
                     (univ-defs-classes defs1))
             (append (univ-defs-inits defs2)
                     (univ-defs-inits defs1))
             (append (univ-defs-all defs2)
                     (univ-defs-all defs1))))

(define (univ-defs-combine-list lst)
  (let loop ((lst lst) (defs (univ-make-empty-defs)))
    (if (pair? lst)
        (loop (cdr lst) (univ-defs-combine defs (car lst)))
        defs)))

(define (univ-emit-var-decl ctx var-descr)
  (case (target-name (ctx-target ctx))

    ((java go)
     (^decl
      (univ-field-type var-descr)
      (univ-field-name var-descr)))

    (else
     (univ-field-name var-descr))))

(define (univ-rts-type-alias ctx type-name)
  (case type-name
    ((absent)        'Absent)
    ((bignum)        'Bignum)
    ((boolean)       'Boolean)
    ((box)           'Box)
    ((char)          'Char)
    ((chr)           'Chr)
    ((closure)       'Closure)
    ((continuation)  'Continuation)
    ((cpxnum)        'Cpxnum)
    ((ctrlpt)        'ControlPoint)
    ((deleted)       'Deleted)
    ((entrypt)       'EntryPoint)
    ((eof)           'Eof)
    ((fixnum)        'Fixnum)
    ((flonum)        'Flonum)
    ((foreign)       'Foreign)
    ((frame)         'Frame)
    ((hashtable)     'HashTable)
    ((hashtable_base) 'HashTableBase)
    ((hashtable_weak_keys)        'HashTableWeakKeys)
    ((hashtable_weak_values)      'HashTableWeakValues)
    ((hashtable_weak_keys_values) 'HashTableWeakKeysValues)
    ((jumpable)      'Jumpable)
    ((key)           'Key)
    ((keyword)       'ScmKeyword) ;; add "Scm" to avoid possible clashes
    ((modlinkinfo)   'ModLinkInfo)
    ((null)          'Null)
    ((optional)      'Optional)
    ((pair)          'Pair)
    ((parententrypt) 'ParentEntryPoint)
    ((promise)       'ScmPromise) ;; add "Scm" to avoid possible clashes
    ((ratnum)        'Ratnum)
    ((rest)          'Rest)
    ((returnpt)      'ReturnPoint)
    ((scheme)        'Scheme)
    ((scmobj)        'ScmObj)
    ((string)        'ScmString) ;; add "Scm" to avoid possible clashes
    ((structure)     'Structure)
    ((symbol)        'ScmSymbol) ;; add "Scm" to avoid possible clashes
    ((u8vector)      'U8Vector)
    ((u16vector)     'U16Vector)
    ((u32vector)     'U32Vector)
    ((u64vector)     'U64Vector)
    ((s8vector)      'S8Vector)
    ((s16vector)     'S16Vector)
    ((s32vector)     'S32Vector)
    ((s64vector)     'S64Vector)
    ((f32vector)     'F32Vector)
    ((f64vector)     'F64Vector)
    ((unbound)       'Unbound)
    ((unused)        'Unused)
    ((values)        'Values)
    ((vector)        'Vector)
    ((void)          'Void)
    ((will)          'Will)
    (else            #f)))

(define (univ-emit-decl ctx type name)

  (define (decl type)
    (decl* type #t))

  (define (decl* type ptr?)

    (define (ptr type-name)
      (base (^ "*" type-name)))

    (define (base type-name)
      (if name
          (case (target-name (ctx-target ctx))
            ((java) (^ type-name " " name))
            ((go)   (^ name " " type-name))
            (else   (error "univ-emit-decl unhandled case")))
          type-name))

    (define (map-type type)
      (if (and (pair? type) (eq? (car type) 'array))
          (univ-array-constructor ctx (cadr type))
          (let ((x (univ-rts-type-alias ctx type)))
            ;;(pp (list 'xxxxxxxxxxxxxx x))
            (if x
                (begin
                  (univ-use-rtlib ctx type)
                  (let* ((type-name
                          (^rts-class-ref type))
                         (mapped-type
                          (case (target-name (ctx-target ctx))
                            ((go)
                             (let ((interface-types
                                    '(scmobj)))
                               (if (and ptr?
                                        (not (memq type interface-types)))
                                   (^ "*" type-name)
                                   type-name)))
                            (else
                             type-name))))
                    (if name
                        (tt"111"mapped-type)
                        (tt"222"mapped-type))))
                type))))

    (case (target-name (ctx-target ctx))

      ((js php python ruby)
       (if (and (pair? type) (eq? (car type) 'nonptr))
           (decl* (cadr type) #f)
           (if name
               name
               (case type
                 ((bigint) (base 'BigInt))
                 ((number) (base 'Number))
                 (else     (base (map-type type)))))))

      ((java)
       (cond ((and (pair? type) (eq? (car type) 'array))
              (^ (decl (cadr type)) "[]"))
             ((and (pair? type) (eq? (car type) 'dict))
              (base (^ "HashMap<"
                       (if (eq? (cadr type) 'int)
                           "Integer"
                           (^type (cadr type)))
                       ","
                       (^type (caddr type)) ">")))
             ((and (pair? type) (eq? (car type) 'generic))
              (base (^ (cadr type) "<" (univ-separated-list "," (map (lambda (x) (^type x)) (cddr type))) ">")))
             (else
              (case type
                ((frm)      (decl '(array scmobj)))
                ((noresult) (base 'void))
                ((int)      (base 'int))
                ((long)     (base 'long))
                ((chr)      (base 'char))
                ((u8)       (base 'byte))  ;;TODO: byte is signed (-128..127)
                ((u16)      (base 'short)) ;;TODO: short is signed
                ((u32)      (decl 'int))   ;;TODO: int is signed
                ((u64)      (decl 'scmobj));;TODO: long is signed
                ((s8)       (base 'byte))
                ((s16)      (base 'short))
                ((s32)      (decl 'int))
                ((s64)      (decl 'scmobj))
                ((f32)      (base 'float))
                ((f64)      (base 'double))
                ((bool)     (base 'boolean))
                ((unicode)  (base 'int)) ;; Unicode needs 21 bit wide integers
                ((bigdigit) (base 'short))
                ((str)      (base 'String))
                ((object)   (base 'Object))
                (else       (base (map-type type)))))))

      ((go)
       (cond ((and (pair? type) (eq? (car type) 'nonptr))
              (decl* (cadr type) #f))
             ((and (pair? type) (eq? (car type) 'array))
              (base (^ "[" (if (pair? (cddr type)) (caddr type) "") "]"
                       (^type (cadr type)))))
             ((and (pair? type) (eq? (car type) 'dict))
              (base (^ "map[" (^type (cadr type)) "]" (^type (caddr type)))))
             ((and (pair? type) (eq? (car type) 'fn))
              (univ-emit-fn-decl ctx #f (caddr type) (cadr type) #f))
             (else
              (case type
                ((frm)      (decl* '(array scmobj) #f))
                ((noresult) (^))
                ((int)      (base 'int))
                ((long)     (base 'int64))
                ((u8)       (base 'uint8))
                ((u16)      (base 'uint16))
                ((u32)      (base 'uint32))
                ((u64)      (base 'uint64))
                ((s8)       (base 'int8))
                ((s16)      (base 'int16))
                ((s32)      (base 'int32))
                ((s64)      (base 'int64))
                ((f32)      (base 'float32))
                ((f64)      (base 'float64))
                ((bool)     (base 'bool))
                ((unicode)  (base 'rune))
                ((bigdigit) (base 'uint16))
                ((str)      (base 'string))
                (else       (base (map-type type)))))))

      (else
       (compiler-internal-error
        "univ-emit-decl, unknown target"))))

  (if type
      (decl type)
      (or name "")))

(define (univ-emit-type ctx type)
  (univ-emit-decl ctx type #f))

(define (univ-emit-procedure-declaration
         ctx
         global?
         proc-type
         root-name
         params
         attribs
         body)
  (univ-emit-defs
   ctx
   global?
   (univ-jumpable-declaration-defs
    ctx
    global?
    root-name
    proc-type
    params
    attribs
    body)))

(define (univ-emit-defs ctx global? defs)

  (define (emit-method m)
    (univ-emit-function-declaration
     ctx
     global?
     (univ-method-name m)
     (univ-method-result-type m)
     (univ-method-params m)
     (univ-method-attribs m)
     (univ-method-body m)
     (univ-method-modifier m)
     #t))

  (define (emit-class c)
    (univ-emit-class-declaration
     ctx
     (univ-class-root-name c)
     (univ-class-properties c)
     (univ-class-extends c)
     (univ-class-class-fields c)
     (univ-class-instance-fields c)
     (univ-class-class-methods c)
     (univ-class-instance-methods c)
     (univ-class-class-classes c)
     (univ-class-constructor c)
     (univ-class-inits c)))

  (define (emit-field f)
    (let* ((public? (memq 'public (univ-field-properties f)))
           (name1 (univ-field-name f))
           (name2 (^prefix name1 public?))
           (name (if global? (^global-var name2) (^local-var name2))))
      (^
       (^var-declaration
        (univ-field-type f)
        name
        (univ-field-init f)
        global?)
       (if (eq? (univ-field-type f) 'jumpable)
           (univ-emit-function-attribs
            ctx
            name
            (univ-field-properties f))
           (^)))))

  (define (emit-init i)
    (let ((code (i ctx)))
      (if (eq? (target-name (ctx-target ctx)) 'go)
          (begin
            (univ-add-module-init ctx code)
            "")
          code)))

  (let loop ((lst
              (if (eq? (target-name (ctx-target ctx)) 'java)
                  (append (reverse (univ-defs-classes defs))
                          (reverse (univ-defs-methods defs))
                          (reverse (univ-defs-fields defs))
                          (reverse (univ-defs-inits defs)))
                  (reverse (univ-defs-all defs))))
             (code
              (^)))
    (if (pair? lst)
        (let ((x (car lst)))
          (loop (cdr lst)
                (^ code
                   (case (univ-def-kind x)
                     ((class)  (emit-class x))
                     ((method) (emit-method x))
                     ((field)  (emit-field x))
                     ((init)   (emit-init x)))
                   "\n")))
        code)))

(define (univ-capitalize code)

  (define (cap-string str)
    (string-append (string (char-upcase (string-ref str 0)))
                   (substring str 1 (string-length str))))

  (cond ((string? code)
         (cap-string code))
        ((symbol? code)
         (cap-string (symbol->string code)))
        ((and (pair? code) (eq? (car code) univ-bb-prefix))
         (cons univ-capitalized-bb-prefix (cdr code)))
        (else
         (error "cannot capitalize" code))))

(define (univ-jumpable-declaration-defs
         ctx
         global?
         root-name
         jumpable-type
         params
         attribs
         body)
  (case (univ-procedure-representation ctx)

    ((class)
     (let ((capitalized-root-name
            (tt"333"(^prefix-class (univ-capitalize root-name)))))
       (univ-add-field

        (univ-add-class
         (univ-make-empty-defs)
         (univ-class
          capitalized-root-name ;; root-name
          '()                   ;; properties
          (and jumpable-type (^rts-class-use jumpable-type)) ;; extends
          '()      ;; class-fields
          attribs  ;; instance-fields
          '()      ;; class-methods
          (list    ;; instance-methods
           (univ-method
            'jump
            '(public)
            'jumpable
            '()
            '()
            body))
          '()    ;; class-classes
          #f     ;; constructor
          '()))  ;; inits

        (univ-field
         root-name
         capitalized-root-name
         (^new* capitalized-root-name '())
         '()))))

    ((struct)
     (let* ((prefixed-root-name
             (^prefix root-name))
            (jump-meth
             (^ prefixed-root-name "_jump_")))
       (univ-add-init
        (univ-add-method
         (univ-add-field
          (univ-make-empty-defs)
          (univ-field
           root-name
           #f
           (univ-construct-nested
            ctx
            (univ-jumpable-inheritance ctx jumpable-type)
            (cons (univ-field 'jump '(fn () jumpable) (^null))
                  attribs))))
         (univ-method
          jump-meth
          '()
          'jumpable
          params
          '()
          body))
        (lambda (ctx)
          (^ (^assign
              (^field 'jump prefixed-root-name)
              jump-meth)
             (^assign
              (^field 'parent prefixed-root-name)
              (univ-force-init ctx (univ-field-init (list-ref attribs 1)))))))))

    (else
     (if (univ-mod-jumpable-is-field? ctx)

         (univ-add-field
          (univ-make-empty-defs)
          (univ-field
           root-name
           'jumpable
           (univ-emit-fn-decl ctx #f 'jumpable params body)
           attribs))

         (univ-add-method
          (univ-make-empty-defs)
          (univ-method
           (^prefix root-name) ;;;;;;;;;;;;;;;;;;;;(^mod-method (ctx-module-name ctx) root-name)
           '()
           'jumpable
           params
           attribs
           body))))))

(define (univ-force-init ctx init)
  (if (procedure? init)
      (init ctx)
      init))

(define (univ-jumpable-inheritance ctx jumpable-type)

  (define jumpable-structure      '(jumpable      jump))
  (define ctrlpt-structure        '(ctrlpt        id    parent))
  (define returnpt-structure      '(returnpt      fs    link))
  (define entrypt-structure       '(entrypt       nfree))
  (define parententrypt-structure '(parententrypt name  ctrlpts info prim))

  (case jumpable-type
    ((jumpable)
     (list jumpable-structure))
    ((ctrlpt)
     (list ctrlpt-structure
           jumpable-structure))
    ((returnpt)
     (list returnpt-structure
           ctrlpt-structure
           jumpable-structure))
    ((entrypt)
     (list entrypt-structure
           ctrlpt-structure
           jumpable-structure))
    ((parententrypt)
     (list parententrypt-structure
           entrypt-structure
           ctrlpt-structure
           jumpable-structure))
    (else
     (compiler-internal-error
      "univ-jumpable-inheritance, unknown jumpable type" jumpable-type))))

(define (univ-construct-nested ctx inheritance attribs)

  (define (construct jumpable-type super args)
    (let ((inits
           (map (lambda (f)
                  (if (memq (univ-field-name f) '(parent))
                      (^null)
                      (univ-force-init ctx (univ-field-init f))))
                args)))
      (^construct* (^rts-class-use jumpable-type)
                   (if super
                       (cons super inits)
                       inits))))

  (define (nest inh lst cont)
    (if (pair? inh)
        (nest (cdr inh)
              lst
              (lambda (super lst)
                (let ((structure (car inh)))
                  (let loop ((lst lst)
                             (fields (cdr structure))
                             (rev-args '()))
                    (if (pair? fields)
                        (if (pair? lst)
                            (loop (cdr lst)
                                  (cdr fields)
                                  (cons (car lst) rev-args))
                            (begin
                              (pp (list inheritance attribs))
                              (compiler-internal-error
                               "univ-construct-nested, missing attributes for"
                               inheritance)))
                        (let ((args (reverse rev-args)))
                          (cont (construct (car structure) super args)
                                lst)))))))
        (cont #f
              lst)))

  (nest inheritance
        attribs
        (lambda (super lst) super)))

(define (univ-jump-method-name ctx)
  (if (eq? (univ-procedure-representation ctx) 'host)
      '__invoke ;; for PHP when using repr-procedure = host
      'jump))

(define (univ-emit-function-attribs ctx name attribs)
  (case (target-name (ctx-target ctx))

    ((js python)
     (if (null? attribs)
         (^)
         (^ "\n"
            (map (lambda (attrib)
                   (let ((val (univ-force-init ctx (univ-field-init attrib))))
                     (^assign
                      (^field (univ-field-name attrib) name)
                      val)))
                 attribs))))

    ((php)
     (if (null? attribs)
         (^)
         (^ "static "
            (univ-separated-list
             ", "
             (map (lambda (attrib)
                    (let ((val (univ-force-init ctx (univ-field-init attrib))))
                      (^assign-expr
                       (^local-var (univ-field-rename ctx (univ-field-name attrib)))
                       val)))
                  attribs))
            "; ")))

    ((ruby)
     (if (null? attribs)
         (^)
         (^ "class << " name "; attr_accessor :" (univ-field-rename ctx (univ-field-name (car attribs)))
            (map (lambda (attrib)
                   (^ ", :" (univ-field-rename ctx (univ-field-name attrib))))
                 (cdr attribs))
            "; end\n"
            (map (lambda (attrib)
                   (let ((val (univ-force-init ctx (univ-field-init attrib))))
                     (^assign (^field (univ-field-name attrib) name)
                              val)))
                 attribs))))

    ((java)
     (^))

    ((go)
     (^ "~~~TODO3:univ-emit-function-attribs~~~"))

    (else
     (compiler-internal-error
      "univ-emit-function-attribs, unknown target"))))

(define (univ-use-ctrlpt-init? ctx)
  (and (eq? 'js (target-name (ctx-target ctx)))
       univ-js-define-globals-using-assignment
       (univ-compactness>=? ctx 6)))

(define (univ-emit-function-declaration
         ctx
         global?
         root-name
         result-type
         params
         attribs
         body
         modifier
         #!optional
         (prim? #f))
  (let* ((prn
          root-name)
         (name
          (if prim?
              prn
              (if global?
                  (^global-var prn)
                  (^local-var root-name)))))
    (case (target-name (ctx-target ctx))

      ((js go)
       (cond ((and (univ-use-ctrlpt-init? ctx)
                   (assoc (map univ-field-name attribs)
                          '(((id parent)
                             ctrlpt_init)
                            ((id parent fs link)
                             returnpt_init)
                            ((id parent nfree)
                             entrypt_init)
                            ((id parent nfree name ctrlpts info prim)
                             parententrypt_init))))
              =>
              (lambda (x)
                (let ((decl
                       (univ-emit-fn-decl ctx name result-type params body modifier 'expr))
                      (attrib-params
                       (map (lambda (f)
                              (univ-force-init ctx (univ-field-init f)))
                            (keep (lambda (f)
                                    (not (memq (univ-field-name f)
                                               '(id parent ctrlpts))))
                                  attribs))))
                  (^expr-statement
                   (apply univ-emit-call-prim
                          (cons ctx
                                (cons (^rts-method-use (cadr x))
                                      (cons decl attrib-params))))))))
             (else
              (let ((decl
                     (univ-emit-fn-decl ctx name result-type params body modifier global?)))
                (^ decl
                   (if (null? attribs)
                       (^ "\n")
                       (^ "\n"
                          (univ-emit-function-attribs ctx name attribs))))))))

      ((php)
       (let ((decl
              (^ (univ-emit-fn-decl
                  ctx
                  (and (or prim? (univ-php-pre53? ctx))
                       prn)
                  result-type
                  params
                  (and body
                       (^ (if (and (not prim?)
                                   (univ-php-pre53? ctx))
                              (^)
                              (univ-emit-function-attribs ctx name attribs))
                          body))
                  modifier
                  global?)
                 "\n")))
         (cond (prim?
                decl)
               ((univ-php-pre53? ctx)
                (^ decl
                   "\n"
                   (^assign name
                            (^ "create_function('"
                               (univ-separated-list
                                ","
                                (map (lambda (x)
                                       (^ (^local-var (univ-field-name x))
                                          (if (univ-field-init x) (^ "=" (^bool #f)) (^))))
                                     params))
                               "','"
                               (univ-emit-function-attribs ctx name attribs)
                               "return "
                               prn
                               "("
                               (univ-separated-list "," (map univ-field-name params))
                               ");')"))))
               (else
                (^assign name decl)))))

      ((python)
       (^ (univ-emit-fn-decl ctx name result-type params body modifier global?)
          (if (null? attribs)
              (^)
              (^ "\n"
                 (univ-emit-function-attribs ctx name attribs)))))

      ((ruby)
       (^ (if prim?

              (^ (univ-emit-fn-decl ctx name result-type params body modifier global?)
                 "\n")

              (let ((parameters
                     (univ-separated-list
                      ","
                      (map (lambda (x)
                             (^ (^local-var (univ-field-name x))
                                (if (univ-field-init x) (^ "=" (^bool #f)) (^))))
                           params))))
                (^assign
                 name
                 (univ-emit-fn-decl ctx #f result-type params body modifier))))

          (univ-emit-function-attribs ctx name attribs)))

      ((java);;TODO adapt to Java
       (^ (univ-emit-fn-decl ctx name result-type params body modifier global?)
          "\n"
          (univ-emit-function-attribs ctx name attribs)))

      (else
       (compiler-internal-error
        "univ-emit-function-declaration, unknown target")))))

(define (univ-emit-fn-decl
         ctx
         name
         result-type
         params
         body
         #!optional
         (modifier #f)
         (global? #f)
         (constructor-or-method? #f))
  (case (target-name (ctx-target ctx))

    ((js)
     (let* ((formals
             (univ-separated-list
              ","
              (map univ-field-name params)))
            (fn-name
             (and (or (not global?)
                      (not univ-js-define-globals-using-assignment))
                  name))
            (fn
             (^ (if (or fn-name
                        constructor-or-method?
                        (not (univ-compactness>=? ctx 1)))
                    (^ "function " (or fn-name "") "(" formals ") ")
                    (^ "(" formals ") => "))
                "{"
                (if body
                    (^indent body)
                    "")
                "}")))
       (if (or (not name) fn-name)
           fn
           (if (eq? global? 'expr)
               (^assign-expr name fn)
               (^var-declaration 'ctrlpt name fn global?)))))

    ((php)
     (let ((formals
            (univ-separated-list
             ","
             (map (lambda (x)
                    (^ (^local-var (univ-field-name x))
                       (if (univ-field-init x) (^ "=" (^bool #f)) (^))))
                  params))))
       (^ "function " (or name "") "(" formals ")"
          (if body
              (^ " {"
                 (^indent body)
                 "}")
              ";"))))

    ((python)
     (let ((formals
            (univ-separated-list
             ","
             (map (lambda (x)
                    (^ (^local-var (univ-field-name x))
                       (if (univ-field-init x) (^ "=" (^bool #f)) (^))))
                  params))))
       (^ "def " name "(" formals "):"
          (^indent
           (or body
               "\npass\n")))))

    ((ruby)
     (let ((formals
            (univ-separated-list
             ","
             (map (lambda (x)
                    (^ (^local-var (univ-field-name x))
                       (if (univ-field-init x) (^ "=" (^bool #f)) (^))))
                  params))))
       (if name

           (^ "def " name (if (null? params) (^) (^ "(" formals ")"))
              (if body
                  (^indent body)
                  "\n")
              "end")

           (^ "lambda {" (if (null? params) (^) (^ "|" formals "|"))
              (if body
                  (^indent body)
                  "")
              "}"))))

    ((java)
     (let ((formals
            (univ-separated-list
             ","
             (map (lambda (var-descr)
                    (univ-emit-var-decl ctx var-descr))
                  params))))
       (^ (if result-type (^ (^type result-type) " ") (^))
          (or name "") "(" formals ")"
          (if body
              (^ " {"
                 (^indent body)
                 "}")
              ";"))))

    ((go)
     (let ((formals
            (univ-separated-list
             ","
             (map (lambda (var-descr)
                    (univ-emit-var-decl ctx var-descr))
                  params))))
       (^ (if (eq? modifier 'virtual)
              ""
              (^ "func "
                 (if modifier
                     (^ (^parens (^ (^this) " " modifier)) " ")
                     "")))
          (or name "") "(" formals ")"
          (if (and result-type (not (eq? result-type 'noresult)))
              (^ " " (^type result-type))
              (^))
          (if body
              (^ " {"
                 (^indent body)
                 "}")
              (^)))))

    (else
     (compiler-internal-error
      "univ-emit-fn-decl, unknown target"))))

(define (univ-emit-fn-body ctx header gen-body)
  (and gen-body
       (univ-call-with-globals
        ctx
        gen-body
        (lambda (ctx body globals)
          (^ header globals body)))))

(define (univ-call-with-globals ctx gen cont)
  (with-new-resources-used
   ctx
   (lambda (ctx)

     (define (global-decl globals)
       (^ "global "
          (univ-separated-list
           ", "
           globals)))

     (let* ((result
             (gen ctx))
            (globals
             (if (eq? (univ-module-representation ctx) 'class)
                 '()
                 (let ((globals
                        (reverse (resource-set-stack (ctx-globals-used ctx)))))

                   #;
                   (begin
                     ;;TODO: remove
                     (define (used? x)
                       (or (resource-set-member? (ctx-resources-used-rd ctx) x)
                           (resource-set-member? (ctx-resources-used-wr ctx) x)))

                     (define (add! x)
                       (set! globals (cons x globals)))

                     (let loop ((num (- (univ-nb-gvm-regs ctx) 1)))
                       (if (>= num 0)
                           (begin
                             (if (used? num) (add! (gvm-state-reg ctx num)))
                             (loop (- num 1)))))

                     (if (used? 'sp)        (add! (gvm-state-sp ctx)))
                     (if (used? 'stack)     (add! (gvm-state-stack ctx)))
                     (if (used? 'peps)      (add! (gvm-state-peps ctx)))
                     (if (used? 'glo)       (add! (gvm-state-glo ctx)))
                     (if (used? 'nargs)     (add! (gvm-state-nargs ctx)))
                     (if (used? 'pollcount) (add! (gvm-state-pollcount ctx))))

                   globals))))
       (cont ctx
             result
             (if (null? globals)
                 (^)
                 (case (target-name (ctx-target ctx))
                   ((php)
                    (^ (global-decl globals) ";\n"))
                   ((python)
                    (^ (global-decl globals) "\n"))
                   (else
                    (^)))))))))

(define (univ-field-param ctx name)
  (if (eq? (target-name (ctx-target ctx)) 'java)
      (^ "_" name)
      name))

(define (univ-emit-class-declaration
         ctx
         root-name
         #!optional
         (properties #f)
         (extends #f)
         (class-fields '())
         (instance-fields '())
         (class-methods '())
         (instance-methods '())
         (class-classes '())
         (constructor #f)
         (inits '()))
  (let ((name (tt"444"root-name)) ;; (^prefix-class root-name);;TODO: fix ^prefix
        (abstract? (memq 'abstract properties)))

    (define (qualifiers additional-properties decl)
      (let ((all (append additional-properties (univ-decl-properties decl))))
        (^ (case (target-name (ctx-target ctx))
             ((python go)
              "")
             (else
              (if (memq 'public all) "public " "")))
           (case (target-name (ctx-target ctx))
             ((python go)
              "")
             (else
              (if (memq 'static all) "static " "")))
           (case (target-name (ctx-target ctx))
             ((python go)
              "")
             (else
              (if (and (univ-method? decl) (not (univ-method-body decl)))
                  "abstract "
                  "")))
           (if (memq 'classmethod all) "@classmethod\n" ""))))

    (define (field-decl additional-properties field)
      (let* ((type (univ-field-type field))
             (public? (memq 'public (univ-field-properties field)))
             (name1 (univ-field-name field))
             (name (if public? (^public name1) name1))
             (init (univ-field-init field)))
        (^ (qualifiers additional-properties field)
           (case (target-name (ctx-target ctx))
             ((go)
              (^ (^local-var name) (if type (^ " " (^type type)) "") "\n"))
             (else
              (^var-declaration type (^local-var name) (except-this init)))))))

    (define (except-this v)
      (case (target-name (ctx-target ctx))
        ((php) (if (eq? v (^this))
                   (^null)
                   v))
        (else v)))

    (define (qualified-field-decls additional-properties fields)
      (let ((fields
             (keep (lambda (x) (not (univ-field-inherited? x)))
                   fields)))
        (if (pair? fields)
            (^ "\n"
               (map (lambda (field)
                      (field-decl additional-properties field))
                    fields))
            (^))))

    (define (qualified-method-decls additional-properties methods)
      (map (lambda (method)
             (^ "\n"
                (qualifiers additional-properties method)
                (univ-emit-function-declaration
                 ctx
                 #t
                 (univ-method-name method)
                 (univ-method-result-type method)
                 (if (eq? (target-name (ctx-target ctx)) 'python)
                     (cons (univ-field (^this) 'object)
                           (univ-method-params method))
                     (univ-method-params method))
                 (univ-method-attribs method)
                 (univ-method-body method)
                 (univ-method-modifier method)
                 #t)
                (if (eq? (target-name (ctx-target ctx)) 'python)
                    "" ;; avoid repeated empty lines
                    "\n")))
           methods))

    (define (qualified-class-decls additional-properties classes)
      (map (lambda (class)
             (^ "\n"
                (qualifiers additional-properties class)
                (univ-emit-class-declaration
                 ctx
                 (univ-class-root-name class)
                 (univ-class-properties class)
                 (univ-class-extends class)
                 (univ-class-class-fields class)
                 (univ-class-instance-fields class)
                 (univ-class-class-methods class)
                 (univ-class-instance-methods class)
                 (univ-class-class-classes class)
                 (univ-class-constructor class)
                 (univ-class-inits class))))
           classes))

    (define (ruby-attr-accessors fields)
      (^ "\n"
         "attr_accessor " ;; allow read/write on all fields
         (univ-separated-list
          ","
          (map (lambda (field) (^ ":" (univ-field-name field)))
               fields))
         "\n"))

    (define (initless fields)
      (keep (lambda (field) (not (univ-field-init field)))
            fields))

    (define (gen-inits ctx inits)
      (let ((code
             (if (null? inits)
                 '()
                 (^ "\n"
                    (map (lambda (i) (i ctx)) inits)))))
        (if (eq? (target-name (ctx-target ctx)) 'go)
            (begin
              (univ-add-module-init ctx code)
              "")
            code)))

    (define (assign-field-decls obj fields)
      (map (lambda (field)
             (let* ((public? (memq 'public (univ-field-properties field)))
                    (name1 (univ-field-name field))
                    (name (if public? (^public name1) name1))
                    (val (univ-force-init ctx (univ-field-init field))))
               (^assign (^member obj name)
                        (or val (^local-var (univ-field-param ctx name1))))))
           fields))

    (define (js-class-declaration
             ctx
             obj
             name
             properties
             extends
             class-fields
             instance-fields
             class-methods
             instance-methods
             class-classes
             constructor
             inits)

      (define (assign-method-decls obj methods)
        (map (lambda (method)
               (^ "\n"
                  (^assign (^member obj (univ-method-name method))
                           (univ-emit-fn-decl
                            ctx
                            #f
                            (univ-method-result-type method)
                            (univ-method-params method)
                            (univ-method-body method)
                            #f
                            #f
                            #t))
                  (univ-emit-function-attribs
                   ctx
                   (^member obj (univ-method-name method))
                   (univ-method-attribs method))))
             methods))

      (define (assign-class-decls obj classes)
        (map (lambda (class)
               (^ "\n"
                  (js-class-declaration
                   ctx
                   obj
                   (univ-class-root-name class)
                   (univ-class-properties class)
                   (univ-class-extends class)
                   (univ-class-class-fields class)
                   (univ-class-instance-fields class)
                   (univ-class-class-methods class)
                   (univ-class-instance-methods class)
                   (univ-class-class-classes class)
                   (univ-class-constructor class)
                   (univ-class-inits class))))
             classes))

      (define (fn-decl name)
        (univ-emit-fn-decl
         ctx
         name
         #f
         (initless instance-fields)
         (univ-emit-fn-body
          ctx
          "\n"
          (lambda (ctx)
            (if (or constructor
                    (not (null? instance-fields)))
                (^ (assign-field-decls (^this) instance-fields)
                   (if constructor (constructor ctx) (^)))
                (^))))
         #f
         (not obj)
         #t))

      (let ((objname name)) ;;(if obj (^member obj name) name)))
        ;;(pp (list obj name objname))
        (^ (if obj
               (^assign objname (fn-decl #f))
               (^ (fn-decl name)
                  "\n"))

           (if extends
               (^ "\n"
                  (^assign (^member objname 'prototype)
                           (^call-prim (^member "Object" 'create)
                                       (^member (^type extends) 'prototype))))
               (^))

           (assign-method-decls (^member objname 'prototype) instance-methods)

           (assign-class-decls objname class-classes)

           (assign-method-decls objname class-methods)

           (if (pair? class-fields)
               (^ "\n" (assign-field-decls objname class-fields))
               (^))

           (gen-inits ctx inits))))

    (case (target-name (ctx-target ctx))

      ((js)
       (js-class-declaration
        ctx
        #f
        root-name
        properties
        extends
        class-fields
        instance-fields
        class-methods
        instance-methods
        class-classes
        constructor
        inits))

      ((php)
       (let* ((c-classes
               (qualified-class-decls '() class-classes))
              (c-fields
               (qualified-field-decls '(static) class-fields))
              (i-fields
               (qualified-field-decls '() instance-fields))
              (all-fields
               (append c-fields i-fields))
              (constr
               (if (and (not abstract?)
                        (or constructor (not (null? instance-fields))))
                   (^ (univ-emit-fn-decl
                       ctx
                       (if (univ-php-pre53? ctx) name "__construct")
                       #f
                       (map (lambda (field)
                              (univ-field
                               (univ-field-param ctx (univ-field-name field))
                               (univ-field-type field)
                               (univ-field-init field)
                               (univ-field-properties field)))
                            (initless instance-fields))
                       (univ-emit-fn-body
                        ctx
                        "\n"
                        (lambda (ctx)
                          (^ (assign-field-decls (^this) instance-fields)
                             (if constructor (constructor ctx) (^))))))
                      "\n")
                   '()))
              (c-methods
               (qualified-method-decls
                (if abstract? '(abstract static) '(static))
                class-methods))
              (i-methods
               (qualified-method-decls
                (if abstract? '(abstract) '())
                instance-methods))
              (all-methods
               (append constr
                       c-methods
                       i-methods))
              (c-inits
               (gen-inits ctx inits)))
         (^ c-classes
            (if abstract? "abstract " "") "class " name
            (if extends (^ " extends " (^type extends)) "")
            " {"
            (^indent
             (^ (if (and (null? all-fields)
                         (null? all-methods)
                         (null? c-inits))
                    ""
                    "\n")
                all-fields
                (if (null? all-methods)
                    ""
                    "\n")
                all-methods
                (if (null? c-inits)
                    (^)
                    (^ "static {"
                       (^indent c-inits)
                       "}\n"))))
            "}\n")))

      ((python)
       (let* ((c-classes
               (qualified-class-decls '(static) class-classes))
              (c-fields
               (qualified-field-decls '(static) class-fields))
              (c-methods
               (qualified-method-decls '(classmethod) class-methods))
              (i-methods
               (qualified-method-decls '() instance-methods))
              (c-inits
               (gen-inits ctx inits)))
         (^ "class " name
            (if extends (^ "(" (^type extends) ")") "")
            ":\n"
            (^indent
             (if (and (not abstract?)
                      (or constructor
                          (not (null? c-classes))
                          (not (null? c-fields))
                          (not (null? c-methods))
                          (not (null? instance-fields))
                          (not (null? i-methods))
                          (not (null? c-inits))))
                 (^ c-classes
                    c-fields
                    c-methods
                    (if (or constructor
                            (not (null? instance-fields)))
                        (^ "\n"
                           (univ-emit-fn-decl
                            ctx
                            "__init__"
                            #f
                            (cons (univ-field (^this) 'object)
                                  (initless instance-fields))
                            (univ-emit-fn-body
                             ctx
                             "\n"
                             (lambda (ctx)
                               (if (and (null? instance-fields) (not constructor))
                                   "pass\n"
                                   (^ (assign-field-decls (^this) instance-fields)
                                      (if constructor (constructor ctx) (^))))))))
                        (^))
                    i-methods)
                 "pass\n"))
            c-inits))) ;; class inits are outside of class definition in case there are self dependencies

      ((ruby)
       (^ "class " name
          (if extends (^ " < " (^type extends)) "")
          (^indent
           (if (or constructor
                   (not (null? class-fields))
                   (not (null? instance-fields))
                   (not (null? class-methods))
                   (not (null? instance-methods)))
               (^ "\n"
                  (let ((meta-attributes (keep (lambda (x)
                                                 (and (pair? x)
                                                      (eq? (car x) 'alias_method)))
                                               properties)))
                    (if (not (null? meta-attributes))
                        (^ "\n"
                           (map (lambda (attr)
                                  (^ (car attr) " " (univ-separated-list "," (cdr attr)) "\n"))
                                meta-attributes)
                           "\n")
                        (^)))
                  (if (or (not (null? class-fields))
                          (not (null? class-methods)))
                      (^ "\n"
                         "class << " (^this)
                         (^indent
                          (^ (ruby-attr-accessors class-fields)
                             (qualified-method-decls '() class-methods)))
                         "end\n"
                         "\n"
                         (assign-field-decls 'self-class class-fields))
                      (^))
                  (if (pair? instance-fields)
                      (ruby-attr-accessors instance-fields)
                      (^))
                  (if (or constructor
                          (not (null? instance-fields)))
                      (^ "\n"
                         "def initialize("
                         (univ-separated-list
                          ","
                          (map univ-field-name
                               (initless instance-fields)))
                         ")\n"
                         (^indent
                          (^ (assign-field-decls (^this) instance-fields)
                             (if constructor (constructor ctx) (^))))
                         "end\n")
                      (^))
                  (qualified-method-decls '() instance-methods))
               (^)))
          "\nend\n"))

      ((java)
       (let* ((c-classes
               (qualified-class-decls '(static) class-classes))
              (c-fields
               (qualified-field-decls '(static) class-fields))
              (i-fields
               (qualified-field-decls '() instance-fields))
              (all-fields
               (append c-fields i-fields))
              (constr
               (if (and (not abstract?)
                        (or constructor (not (null? instance-fields))))
                   (list "\n"
                         (univ-emit-fn-decl
                          ctx
                          name
                          #f
                          (map (lambda (field)
                                 (univ-field
                                  (univ-field-param ctx (univ-field-name field))
                                  (univ-field-type field)
                                  (univ-field-init field)
                                  (univ-field-properties field)))
                               (initless instance-fields))
                          (univ-emit-fn-body
                           ctx
                           "\n"
                           (lambda (ctx)
                             (^ (assign-field-decls (^this) instance-fields)
                                (if constructor (constructor ctx) (^))))))
                         "\n")
                   '()))
              (c-methods
               (qualified-method-decls
                (if abstract? '(abstract static) '(static))
                class-methods))
              (i-methods
               (qualified-method-decls
                (if abstract? '(abstract) '())
                instance-methods))
              (all-methods
               (append constr c-methods i-methods))
              (c-inits
               (gen-inits ctx inits))
              (generic
               (assq 'generic properties)))
         (^ (if abstract? "abstract " "") "class "
            name (if generic (^ "<" (univ-separated-list ", " (map (lambda (x) (^type x)) (cdr generic))) "> ") "")
            (if extends (^ " extends " (^type extends)) "")
            " {"
            (^indent
             (^ (if (and (null? c-classes)
                         (or abstract?
                             (null? all-methods)))
                    ""
                    "\n")
                c-classes
                all-fields
                all-methods
                (if (null? c-inits)
                    (^)
                    (^ "static {"
                       (^indent c-inits)
                       "}\n"))))
            "}\n")))

      ((go)
       (let* ((c-classes
               '()) ;;(qualified-class-decls '(static) class-classes))
              (c-fields
               '()) ;;(qualified-field-decls '(static) class-fields))
              (i-fields
               (qualified-field-decls '() instance-fields))
              (all-fields
               (append c-fields i-fields))
              (virtual-i-methods
               (qualified-method-decls
                '()
                (keep (lambda (m) (not (univ-method-body m)))
                      instance-methods)))
              (concrete-i-methods
               (qualified-method-decls
                '()
                (keep (lambda (m) (univ-method-body m))
                      instance-methods)))
              (interface?
               (memq 'interface properties))
              (defs-in-type
               (append all-fields
                       virtual-i-methods))
              (all-defs-in-type
               (append (if extends
                           (list (^ "\n"
                                    (^type extends)
                                    (if (null? defs-in-type) "\n" "")))
                           '())
                       defs-in-type)))
         (^ "type " name " "
            (if interface? "interface" "struct")
            (if (null? all-defs-in-type)
                "{}\n"
                (^ " {"
                   (^indent all-defs-in-type)
                   "}\n"))
            concrete-i-methods)))

      (else
       (compiler-internal-error
        "univ-emit-class-declaration, unknown target")))))

(define (univ-emit-return-poll ctx expr poll? call?)

  (define (ret)
    (if (or call? (univ-always-return-jump? ctx))
        (^return-jump expr)
        (^return expr)))

  (univ-emit-poll-or-continue ctx expr poll? ret))

(define (univ-emit-poll-or-continue ctx expr poll? cont)
  (if poll?
      (if (univ-compactness>=? ctx 9)
          (^return-call-prim
           (^rts-method-use 'poll)
           expr)
          (^inc-by (gvm-state-pollcount-use ctx 'rdwr)
                   -1
                   (lambda (inc)
                     (^if (^= inc (^int 0))
                          (^return-call-prim
                           (^rts-method-use 'poll)
                           expr) ;;(^upcast* '??? 'ctrlpt expr)
                          (cont)))))
      (cont)))

(define (univ-emit-return-call-prim ctx expr . params)
  (^return
   (apply univ-emit-call-prim (cons ctx (cons expr params)))))

(define (univ-emit-return-jump ctx expr)
  (^return
   (if (not (univ-never-return-jump? ctx))
       (^jump (univ-unstringify-method expr))
       expr)))

(define (univ-emit-return ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php java)
     (^ "return " expr ";\n"))

    ((python ruby go)
     (^ "return " expr "\n"))

    (else
     (compiler-internal-error
      "univ-emit-return, unknown target"))))

(define (univ-emit-null ctx)
  ;; generates a null reference
  (case (target-name (ctx-target ctx))

    ((js java)
     (univ-constant "null"))

    ((python)
     (univ-constant "None"))

    ((ruby go)
     (univ-constant "nil"))

    ((php)
     (univ-constant "NULL"))

    (else
     (compiler-internal-error
      "univ-emit-null, unknown target"))))

(define (univ-emit-null? ctx expr)
  (^eq? expr (^null)))

(define (univ-emit-null-obj ctx)
  (case (univ-null-representation ctx)

    ((class)
     (^rts-field-use 'null_obj))

    (else
     (^null))))

(define (univ-emit-null-obj? ctx expr)
  (case (univ-null-representation ctx)

    ((class)
     (^instanceof (^type 'null) expr))

    (else
     (^null? expr))))

(define (univ-emit-void ctx)
  (case (target-name (ctx-target ctx))

    ((js)
     (univ-constant "void 0")) ;; JavaScript's "undefined" value

    (else
     (^null))))

(define (univ-emit-void? ctx expr)
  (^eq? expr (^void)))

(define (univ-emit-void-obj ctx)
  (case (univ-void-representation ctx)

    ((class)
     (^rts-field-use 'void_obj))

    (else
     (^void))))

(define (univ-emit-str->string ctx expr)
  (^string-box (^str-to-codes expr)))

(define (univ-emit-string->str ctx expr)
  (case (univ-string-representation ctx)

    ((class)
     (^tostr  expr))

    ((host)
     expr)))

(define (univ-emit-void-obj? ctx expr)
  (case (univ-void-representation ctx)

    ((class)
     (^instanceof (^type 'void) expr))

    (else
     (case (target-name (ctx-target ctx))
      ((js) (^void? expr))
      (else (^null? expr))))))

(define (univ-emit-str? ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^typeof "string" expr))

    ((php)
     (^call-prim "is_string" expr))

    ((python)
     (^instanceof "str" expr))

    ((ruby)
     (^instanceof "String" expr))

    (else
     (compiler-internal-error
       "univ-emit-str?, unknown target"))))

(define (univ-emit-js-number? ctx expr)
  (if (univ-compactness>=? ctx 9)
      (^call-prim (^rts-method-use 'jsnumberp) expr)
      (univ-emit-js-number?-inline ctx expr)))

(define (univ-emit-js-number?-inline ctx expr)
  (^typeof "number" expr))

(define (univ-emit-js-bigint? ctx expr)
  (^typeof "bigint" expr))

(define (univ-emit-float? ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (univ-emit-js-number? ctx expr))

    ((php)
     (^ "is_float(" expr ")"))

    ((python)
     (^ "isinstance(" expr ", float)"))

    ((ruby)
     (^ expr ".instance_of?(Float)"))

    (else
     (compiler-internal-error
       "univ-emit-float?, unknown target"))))

(define (univ-emit-int? ctx expr)
  (case (target-name (ctx-target ctx))

   ((js)
    (univ-emit-js-number? ctx expr))

   ((php)
    (^call-prim "is_int" expr))

   ((python)
    (^and (^instanceof "int" expr)
          (^not (^instanceof "bool" expr))))

   ((ruby)
    (^instanceof "Fixnum" expr))

   (else
    (compiler-internal-error
     "univ-emit-int?, unknown target"))))

(define (univ-emit-eof ctx)
  (case (univ-eof-representation ctx)

    ((class)
     (^rts-field-use 'eof_obj))

    (else
     (compiler-internal-error
      "univ-emit-eof, host representation not implemented"))))

(define (univ-emit-absent ctx)
  (case (univ-absent-representation ctx)

    ((class)
     (^rts-field-use 'absent_obj))

    (else
     (compiler-internal-error
      "univ-emit-absent, host representation not implemented"))))

(define (univ-emit-deleted ctx)
  (case (univ-deleted-representation ctx)

    ((class)
     (^rts-field-use 'deleted_obj))

    (else
     (compiler-internal-error
      "univ-emit-deleted, host representation not implemented"))))

(define (univ-emit-unused ctx)
  (case (univ-unused-representation ctx)

    ((class)
     (^rts-field-use 'unused_obj))

    (else
     (compiler-internal-error
      "univ-emit-unused, host representation not implemented"))))

(define (univ-emit-unbound1 ctx)
  (case (univ-unbound-representation ctx)

    ((class)
     (^rts-field-use 'unbound1_obj))

    (else
     (compiler-internal-error
      "univ-emit-unbound1, host representation not implemented"))))

(define (univ-emit-unbound2 ctx)
  (case (univ-unbound-representation ctx)

    ((class)
     (^rts-field-use 'unbound2_obj))

    (else
     (compiler-internal-error
      "univ-emit-unbound2, host representation not implemented"))))

(define (univ-emit-unbound? ctx expr)
  (case (univ-unbound-representation ctx)

    ((class)
     (^instanceof (^type 'unbound) (^cast*-scmobj expr)))

    (else
     (compiler-internal-error
      "univ-emit-unbound?, host representation not implemented"))))

(define (univ-emit-optional ctx)
  (case (univ-optional-representation ctx)

    ((class)
     (^rts-field-use 'optional_obj))

    (else
     (compiler-internal-error
      "univ-emit-optional, host representation not implemented"))))

(define (univ-emit-key ctx)
  (case (univ-key-representation ctx)

    ((class)
     (^rts-field-use 'key_obj))

    (else
     (compiler-internal-error
      "univ-emit-key, host representation not implemented"))))

(define (univ-emit-rest ctx)
  (case (univ-rest-representation ctx)

    ((class)
     (^rts-field-use 'rest_obj))

    (else
     (compiler-internal-error
      "univ-emit-rest, host representation not implemented"))))

(define (univ-emit-bool ctx val)
  (case (target-name (ctx-target ctx))

    ((js)
     (if (univ-compactness>=? ctx 5)
         (univ-constant (if val "!0" "!1"))
         (univ-constant (if val "true" "false"))))

    ((ruby php java go)
     (univ-constant (if val "true" "false")))

    ((python)
     (univ-constant (if val "True" "False")))

    (else
     (compiler-internal-error
      "univ-emit-bool, unknown target"))))

(define (univ-emit-bool? ctx expr)
  (case (target-name (ctx-target ctx))

   ((js)
    (^typeof "boolean" expr))

   ((php)
    (^call-prim "is_bool" expr))

   ((python)
    (^instanceof "bool" expr))

   ((ruby)
    (^or (^instanceof "FalseClass" expr)
         (^instanceof "TrueClass" expr)))

   (else
    (compiler-internal-error
     "univ-emit-bool?, unknown target"))))

(define (univ-emit-boolean-obj ctx obj)
  (case (univ-boolean-representation ctx)

    ((class)
     (univ-box
      (^rts-field-use (if obj 'true_obj 'false_obj))
      (^bool obj)))

    (else
     (^bool obj))))

(define (univ-emit-boolean-box ctx expr)
  (case (univ-boolean-representation ctx)

    ((class)
     (univ-box
      (^if-expr 'scmobj
                expr
                (^boolean-obj #t)
                (^boolean-obj #f))
      expr))

    (else
     expr)))

(define (univ-emit-boolean-unbox ctx expr)
  (or (univ-unbox expr)
      (case (univ-boolean-representation ctx)

        ((class)
         (^field 'val (^cast* 'boolean expr)))

        (else
         (^downcast* 'bool expr)))))

(define (univ-emit-boolean? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'booleanp) expr))

    (else
     (case (univ-boolean-representation ctx)

       ((class)
        (^instanceof (^type 'boolean) (^cast*-scmobj expr)))

       (else
        (^bool? expr))))))

(define (univ-emit-chr ctx val)
  (univ-constant (char->integer val)))

(define (univ-emit-char-obj ctx obj force-var?)
  (case (univ-char-representation ctx)

    ((class)
     (let ((x (^chr obj)))
       (univ-box
        (univ-obj-use
         ctx
         obj
         force-var?
         (lambda ()
           (^char-box x)))
        x)))

    (else
     (compiler-internal-error
      "univ-emit-char-obj, host representation not implemented"))))

(define (univ-emit-char-box ctx expr)
  (case (univ-char-representation ctx)

    ((class)
     (univ-box
      (^call-prim
       (^rts-method-use 'make_interned_char)
       expr)
      expr))

    (else
     (^char-box-uninterned expr))))

(define (univ-emit-char-box-uninterned ctx expr)
  (case (univ-char-representation ctx)

    ((class)
     (^new 'char expr))

    (else
     expr)))

(define (univ-emit-char-unbox ctx expr)
  (or (univ-unbox expr)
      (case (univ-char-representation ctx)

        ((class)
         (^field 'code (^cast* 'char expr)))

        (else
         (^downcast* 'chr expr)))))

(define (univ-emit-chr-fromint ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     expr)

    ((java)
     (^cast* 'unicode expr))

    ((go)
     (^conv* 'rune expr))

    (else
     (compiler-internal-error
      "univ-emit-chr-fromint, unknown target"))))

(define (univ-emit-chr-toint ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     expr)

    ((java)
     (^cast* 'int expr))

    ((go)
     (^conv* 'int expr))

    (else
     (compiler-internal-error
      "univ-emit-chr-toint, unknown target"))))

(define (univ-emit-chr-tostr ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^call-prim (^member "String" 'fromCharCode) expr))

    ((php)
     (^call-prim "chr" expr))

    ((python)
     (^call-prim "unichr" expr))

    ((ruby)
     (^ expr ".chr"))

    ((java)
     (^call-prim (^member 'String 'valueOf) expr))

    ((go)
     (^conv* 'str expr))

    (else
     (compiler-internal-error
      "univ-emit-chr-tostr, unknown target"))))

(define (univ-emit-char? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'charp) expr))

    (else
     (case (univ-char-representation ctx)

       ((class)
        (^instanceof (^type 'char) (^cast*-scmobj expr)))

       (else
        (compiler-internal-error
         "univ-emit-char?, host representation not implemented"))))))

(define (univ-emit-int ctx val)
  (univ-constant val))

(define (univ-emit-num-of-type ctx type val)
  (declare (generic))
  (case (target-name (ctx-target ctx))

    ((java)
     (case type
       ((f32)
        (^cast* 'f32 (^float val)))
       ((f64)
        (^float val))
       ((s8 s16 s32)
        (^int val))
       ((u8)
        (^int
         (if (>= val 128)
             (- val 256)
             val)))
       ((u16)
        (^int
         (if (>= val 32768)
             (- val 65536)
             val)))
       ((u32)
        (^int
         (if (>= val 32768)
             (- val 4294967296)
             val)))
;;       ((u64)
;;        (^int
;;         (if (>= val 9223372036854775808)
;;             (- val 18446744073709551616)
;;             val)))
       (else
        (univ-emit-obj* ctx val #f))))

    (else
     (case type
       ((f32)
        (^cast* 'f32 (^float val)))
       ((f64)
        (^float val))
       ((s8 s16 s32 u8 u16 u32)
        (^int val))
       (else
        (univ-emit-obj* ctx val #f))))))

(define (univ-emit-fixnum-box ctx expr)
  (case (univ-fixnum-representation ctx)

    ((class)
     (univ-box
      (^call-prim
       (^rts-method-use 'make_fixnum)
       expr)
      expr))

    (else
     expr)))

(define (univ-emit-fixnum-unbox ctx expr)
  (or (univ-unbox expr)
      (case (univ-fixnum-representation ctx)

        ((class)
         (^field 'val (^cast* 'fixnum expr)))

        (else
         (^downcast* 'int expr)))))

(define (univ-emit-fixnum? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'fixnump) expr))

    (else
     (case (univ-fixnum-representation ctx)

       ((class)
        (^instanceof (^type 'fixnum) (^cast*-scmobj expr)))

       (else
        (^int? expr))))))

(define (univ-emit-empty-dict ctx type)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^ "{}"))

    ((php)
     (^ "array()"))

    ((java)
     (^new type))

    ((go)
     (^ (^type type) "{}"))

    (else
     (compiler-internal-error
      "univ-emit-empty-dict, unknown target"))))

;;TODO:remove
#;
(define (univ-emit-dict ctx alist)

  (define (dict alist sep open close)
    (^ open
       (univ-separated-list
        ","
        (map (lambda (x) (^ (^str (car x)) sep (cdr x))) alist))
       close))

  (case (target-name (ctx-target ctx))

    ((js python)
     (dict alist ":" "{" "}"))

    ((php)
     (dict alist "=>" "array(" ")"))

    ((ruby)
     (dict alist "=>" "{" "}"))

    ((go)
     (^ (^type type) (dict alist ":" "{" "}")))

    (else
     (compiler-internal-error
      "univ-emit-dict, unknown target"))))

(define (univ-emit-dict-key-exists? ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (^prop-index-exists? expr1 expr2))

    ((java)
     (^call-prim
      (^member expr1 'containsKey)
      expr2))

    ((go)
     (^ "~~~TODO3:univ-emit-dict-key-exists?~~~"))

    (else
     (compiler-internal-error
      "univ-emit-dict-key-exists?, unknown target"))))

(define (univ-emit-dict-get ctx type expr1 expr2 expr3)
  (case (target-name (ctx-target ctx))

    ((js php python ruby go)
     (^prop-index type expr1 expr2 expr3))

    ((java)
     (if (and expr3
              (not (equal? expr3 (^null))))
         (if (univ-java-pre7? ctx)
             (^if-expr type
                       (^dict-key-exists? expr1 expr2)
                       (^dict-get type expr1 expr2)
                       expr3)
             (^call-prim (^member expr1 'getOrDefault) expr2 expr3))
         (^call-prim (^member expr1 'get) expr2)))

    (else
     (compiler-internal-error
      "univ-emit-dict-get, unknown target"))))

(define (univ-emit-dict-get-or-null ctx type expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((go)
     (^prop-index-or-null type expr1 expr2))

    (else
     (^prop-index type expr1 expr2 (^null)))))

(define (univ-emit-dict-set ctx type expr1 expr2 expr3)
  (case (target-name (ctx-target ctx))

    ((js php python ruby go)
     (^assign (^prop-index type expr1 expr2) expr3))

    ((java)
     (^expr-statement (^call-prim (^member expr1 'put) expr2 expr3)))

    (else
     (compiler-internal-error
      "univ-emit-dict-set, unknown target"))))

(define (univ-emit-dict-delete ctx expr1 expr2)
  (^expr-statement
   (case (target-name (ctx-target ctx))
     ((js)
      (^ "delete " (^prop-index 'scmobj expr1 expr2)))

     ((python)
      (^ "del " (^prop-index 'scmobj expr1 expr2)))

     ((ruby)
      (^call-member expr1 'delete expr2))

     ((php)
      (^call-prim 'unset (^prop-index 'scmobj expr1 expr2)))

     ((java)
      (^call-member expr1 'remove expr2))

     ((go)
      (^ "~~~TODO3:univ-emit-dict-delete~~~"))

     (else
      (compiler-internal-error
       "univ-emit-dict-delete, unknown target")))))

(define (univ-emit-dict-length ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^array-length (^call-prim (^member 'Object 'keys) expr)))

    ((python ruby php)
     (^array-length expr))

    ((java)
     (^call-member expr 'size))

    ((go)
     (^ "~~~TODO3:univ-emit-dict-length~~~"))

    (else
     (compiler-internal-error
      "univ-emit-dict-length, unknown target"))))

(define (univ-emit-member ctx expr name)
  (case (target-name (ctx-target ctx))

    ((js python)
     (^ expr "." name))

    ((php)
     (^ expr "->" name))

    ((ruby)
     (cond ((eq? expr (^this)) ;; optimize access to "self"
            (^ "@" name))
           ((eq? expr 'self-class) ;; for univ-emit-class-declaration
            (^ "@@" name))
           (else
            (^ expr "." name))))

    ((java)
     (cond ((eq? expr (^this)) ;; optimize access to "this"
            name)
           (else
            (^ expr "." name))))

    ((go)
     (^ expr "." name))

    (else
     (compiler-internal-error
      "univ-emit-member, unknown target"))))

(define (univ-emit-field ctx name expr)
  (^member expr (^public (univ-field-rename ctx name))))

(define (univ-emit-public ctx name)
  (case (target-name (ctx-target ctx))
    ((go)
     (^ "G_" name)) ;; exported names must start with a capital letter
    (else
     name)))

(define (univ-with-ctrlpt-attribs ctx assign? ctrlpt thunk)
  (case (univ-procedure-representation ctx)

    ((class)
     (thunk))

    ((struct)
     (thunk))

    (else
     (case (target-name (ctx-target ctx))

       ((js python ruby)
        (thunk))

       ((php)
        (let ((attribs-var
               (^ ctrlpt "_attribs"))
              (attribs-array
               (^ "new ReflectionFunction(" ctrlpt ")")))
          (^ (if assign?
                 (^assign attribs-var attribs-array)
                 (^var-declaration 'object attribs-var attribs-array))
             (^assign attribs-var (^ attribs-var "->getStaticVariables()"))
             (thunk))))

       (else
        (compiler-internal-error
         "univ-with-ctrlpt-attribs, unknown target"))))))

(define (univ-get-ctrlpt-attrib ctx ctrlpt attrib)
  (case (univ-procedure-representation ctx)

    ((class struct)
     (^field attrib ctrlpt))

    (else
     (case (target-name (ctx-target ctx))

       ((js python ruby)
        (^field attrib ctrlpt))

       ((php)
        (let ((attribs-var (^ ctrlpt "_attribs")))
          (^prop-index 'scmobj attribs-var (^str attrib))))

       (else
        (compiler-internal-error
         "univ-get-ctrlpt-attrib, unknown target"))))))

(define (univ-set-ctrlpt-attrib ctx ctrlpt attrib val)
  (case (univ-procedure-representation ctx)

    ((class)
     (^assign (^field attrib ctrlpt) val))

    ((struct)
     (^assign (^field attrib (cdr ctrlpt)) val))

    (else
     (case (target-name (ctx-target ctx))

       ((js python ruby)
        (^assign (^field attrib ctrlpt) val))

       ((php)
        (let ((attribs-var (^ ctrlpt "_attribs")))
          (^assign (^prop-index 'scmobj attribs-var (^str attrib)) val)))

       (else
        (compiler-internal-error
         "univ-set-ctrlpt-attrib, unknown target"))))))

(define (univ-call-with-ctrlpt-attrib ctx expr type-name attrib return)
  (let ((ctrlpt (^local-var (univ-gensym ctx 'ctrlpt))))
    (^ (^var-declaration
        type-name
        ctrlpt
        (^cast* type-name expr))
       (univ-with-ctrlpt-attribs
        ctx
        #f
        ctrlpt
        (lambda ()
          (return
           (univ-get-ctrlpt-attrib ctx ctrlpt attrib)))))))

(define (univ-emit-pair? ctx expr)
  (if (univ-compactness>=? ctx 9)
      (^call-prim (^rts-method-use 'pairp) expr)
      (univ-emit-pair?-inline ctx expr)))

(define (univ-emit-pair?-inline ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'pairp) expr))

    (else
     (^instanceof (^type 'pair) (^cast*-scmobj expr)))))

(define (univ-emit-cons ctx expr1 expr2)
  (if (univ-compactness>=? ctx 9)
      (^call-prim (^rts-method-use 'cons) expr1 expr2)
      (univ-emit-cons-inline ctx expr1 expr2)))

(define (univ-emit-cons-inline ctx expr1 expr2)
  (^new 'pair expr1 expr2))

(define (univ-emit-getcar ctx expr)
  (^field 'car (^cast* 'pair expr)))

(define (univ-emit-getcdr ctx expr)
  (^field 'cdr (^cast* 'pair expr)))

(define (univ-emit-setcar ctx expr1 expr2)
  (^assign (^field 'car (^cast* 'pair expr1)) expr2))

(define (univ-emit-setcdr ctx expr1 expr2)
  (^assign (^field 'cdr (^cast* 'pair expr1)) expr2))

(define (univ-emit-float ctx val)
  ;; TODO: generate correct syntax
  (univ-constant
   (cond
    ((not (finite? val))

     (cond ((nan? val)
            (case (target-name (ctx-target ctx))
              ((js)     "Number.NaN")
              ((java)   "Double.NaN")
              ((php)    "NAN")
              ((python) "float('nan')")
              ((ruby)   "Float::NAN")
              ((go)     "math.NaN")
              (else
               (compiler-internal-error
                "univ-emit-float, unknown target"))))

           ((positive? val)
            (case (target-name (ctx-target ctx))
              ((js)     "Number.POSITIVE_INFINITY")
              ((java)   "Double.POSITIVE_INFINITY")
              ((php)    "INF")
              ((python) "float('inf')")
              ((ruby)   "Float::INFINITY")
              ((go)     "math.Inf(+1)")
              (else
               (compiler-internal-error
                "univ-emit-float, unknown target"))))

           (else
            (case (target-name (ctx-target ctx))
              ((js)     "Number.NEGATIVE_INFINITY")
              ((java)   "Double.NEGATIVE_INFINITY")
              ((php)    "(-INF)")
              ((python) "(-float('inf'))")
              ((ruby)   "(-Float::INFINITY)")
              ((go)     "math.Inf(-1)")
              (else
               (compiler-internal-error
                "univ-emit-float, unknown target"))))))

    ((eqv? val -0.0)
     (case (target-name (ctx-target ctx))
       ((php) "(0.0*-1)") ;; in PHP -0.0 doesn't give negative zero
       ((go)  "math.Copysign(0,-1)")
       (else  "-0.0")))

    (else
     (let ((str (number->string (abs val))))
       (string-append
        (if (negative? val) "-" "")
        (if (char=? (string-ref str 0) #\.) "0" "") ;; .17 => 0.17
        str
        (if (char=? (string-ref str (- (string-length str) 1)) #\.) "0" ""))))))) ;; 22. => 22.0

(define (univ-emit-float-fromint ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     expr)

    ((php)
     (^ "(float)(" expr ")"))

    ((python)
     (^ "float(" expr ")"))

    ((ruby)
     (^ expr ".to_f"))

    ((java)
     (^cast* 'f64 expr))

    ((go)
     (^ "~~~TODO3:univ-emit-float-fromint~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-fromint, unknown target"))))

(define (univ-emit-float-toint ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^float-truncate expr))

    ((php)
     (^ "(int)(" expr ")"))

    ((python)
     (^ "int(" expr ")"))

    ((ruby)
     (^ expr ".to_i"))

    ((java)
     (^cast* 'int expr))

    ((go)
     (^ "~~~TODO3:univ-emit-float-toint~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-toint, unknown target"))))

(define (univ-emit-float-math ctx fn . params)
  (univ-emit-call-prim-aux
   ctx
   (case (target-name (ctx-target ctx))

     ((js ruby java)
      (^member 'Math fn))

     ((python)
      (^member 'math fn))

     ((php)
      fn)

     ((go)
      (^ "~~~TODO3:univ-emit-float-math~~~"))

     (else
      (compiler-internal-error
       "univ-emit-float-math, unknown target")))
   params))

(define (univ-emit-float-abs ctx expr)
  (case (target-name (ctx-target ctx))

    ((js java php)
     (^float-math 'abs expr))

    ((python)
     (^float-math 'fabs expr))

    ((ruby)
     (^call-prim (^member expr 'abs)))

    ((go)
     (^ "~~~TODO3:univ-emit-float-abs~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-abs, unknown target"))))

(define (univ-emit-float-floor ctx expr)
  (case (target-name (ctx-target ctx))

    ((js java php)
     (^float-math 'floor expr))

    ((python)
     (^parens
      (univ-ident-when-special-float
       ctx
       expr
       (^float-math 'floor expr))))

    ((ruby)
     (^parens
      (univ-ident-when-special-float
       ctx
       expr
       (^float-fromint (^call-prim (^member expr 'floor))))))

    ((go)
     (^ "~~~TODO3:univ-emit-float-floor~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-floor, unknown target"))))

(define (univ-emit-float-ceiling ctx expr)
  (case (target-name (ctx-target ctx))

    ((js java php)
     (^float-math 'ceil expr))

    ((python)
     (^if-expr 'f64
               (^and (^float-finite? expr)
                     (^!= expr (^float targ-inexact-+0)))
               (^float-math 'ceil expr)
               expr))

    ((ruby)
     (^if-expr 'f64
               (^and (^float-finite? expr)
                     (^!= expr (^float targ-inexact-+0)))
               (^float-fromint (^call-prim (^member expr 'ceil)))
               expr))

    ((go)
     (^ "~~~TODO3:univ-emit-float-ceiling~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-ceiling, unknown target"))))

(define (univ-ident-when-special-float ctx expr1 expr2)
  (^if-expr 'f64
            (^and (^float-finite? expr1)
                  (^!= expr1 (^float targ-inexact-+0)))
            expr2
            expr1))

(define (univ-emit-float-truncate ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (univ-ident-when-special-float
      ctx
      expr
      (^parens
       (^+ (^float-math 'trunc expr)
           (^float targ-inexact-+0))))) ;; avoid negative zero

    ((php java python)
     (univ-ident-when-special-float
      ctx
      expr
      (^parens
       (^if-expr 'f64
                 (^< expr (^float targ-inexact-+0))
                 (^float-math 'ceil expr)
                 (^float-math 'floor expr)))))

    ((ruby)
     (univ-ident-when-special-float
      ctx
      expr
      (^float-fromint (^call-prim (^member expr 'truncate)))))

    ((go)
     (^ "~~~TODO3:univ-emit-float-truncate~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-truncate, unknown target"))))

(define (univ-emit-float-round-half-up ctx expr)
  (case (target-name (ctx-target ctx))

    ((js java)
     (^float-math 'round expr))

    ((go)
     (^ "~~~TODO3:univ-emit-float-round-half-up~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-round-half-up, unknown target"))))

(define (univ-emit-float-round-half-towards-0 ctx expr)
  (case (target-name (ctx-target ctx))

    ((php python)
     ;; python v2 rounds towards 0
     (^call-prim 'round expr))

    ((ruby)
     (^call-prim (^member expr 'round)))

    ((go)
     (^ "~~~TODO3:univ-emit-float-round-half-towards-0~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-round-half-towards-0, unknown target"))))

(define (univ-emit-float-round-half-to-even ctx expr)

  (define (use-round-half-up)
    (^- (^float-round-half-up expr)
        (^parens
         (^if-expr 'f64
                   (^&& (^!= (^float-mod expr (^float targ-inexact-+2))
                             (^float targ-inexact-+1/2))
                        (^!= (^float-mod expr (^float targ-inexact-+2))
                             (^float -1.5))) ;;;;;;;;;;;;;;;;
                   (^float targ-inexact-+0)
                   (^float targ-inexact-+1)))))

  (define (use-round-half-towards-0)
    (^+ (^float-round-half-towards-0 expr)
        (^- (^parens
             (^if-expr 'f64
                       (^= (^float-mod expr (^float targ-inexact-+2))
                           (^float (- targ-inexact-+1/2))) ;;;;;;;;;;;;;;;;;
                       (^float targ-inexact-+1)
                       (^float targ-inexact-+0)))
            (^parens
             (^if-expr 'f64
                       (^= (^float-mod expr (^float targ-inexact-+2))
                           (^float targ-inexact-+1/2))
                       (^float targ-inexact-+1)
                       (^float targ-inexact-+0))))))

  (case (target-name (ctx-target ctx))

    ((js)
     (use-round-half-up))

    ((java)
     (univ-ident-when-special-float
      ctx
      expr
      (use-round-half-up)))

    ((php ruby)
     (univ-ident-when-special-float
      ctx
      expr
      (use-round-half-towards-0)))

    ((python)
     (univ-ident-when-special-float
      ctx
      expr
      (if (univ-python-pre3? ctx)
          (use-round-half-towards-0)
          (^call-prim 'round expr))))

    ((go)
     (^ "~~~TODO3:use-round-half-towards-0~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-round-half-to-even, unknown target"))))

#|
JS:
for (var i=-8; i<=8; i++) print(i*0.5," ",(i*0.5)%2," ",Math.round(i*0.5));
-4    0   -4
-3.5 -1.5 -3 -1
-3   -1   -3
-2.5 -0.5 -2
-2    0   -2
-1.5 -1.5 -1 -1
-1   -1   -1
-0.5 -0.5  0
0     0    0
0.5   0.5  1 -1
1     1    1
1.5   1.5  2
2     0    2
2.5   0.5  3 -1
3     1    3
3.5   1.5  4
4     0    4

PHP:
i*0.5, fmod(i*0.5,2), round(i*0.5)
-4    0   -4
-3.5 -1.5 -4
-3   -1   -3
-2.5 -0.5 -3 +1
-2    0   -2
-1.5 -1.5 -2
-1   -1   -1
-0.5 -0.5 -1 +1
0     0    0
0.5   0.5  1 -1
1     1    1
1.5   1.5  2
2     0    2
2.5   0.5  3 -1
3     1    3
3.5   1.5  4
4     0    4

Python:
for i in range(-8,8):
  print '%f %f %f' % ((i*0.5),math.fmod(i*0.5,2),round(i*0.5))
-4    0   -4
-3.5 -1.5 -4
-3   -1   -3
-2.5 -0.5 -3 +1
-2    0   -2
-1.5 -1.5 -2
-1   -1   -1
-0.5 -0.5 -1 +1
0     0    0
0.5   0.5  1 -1
1     1    1
1.5   1.5  2
2     0    2
2.5   0.5  3 -1
3     1    3
3.5   1.5  4
4     0    4

Ruby:
(-8..8).each {|i| puts (i*0.5),(i*0.5).remainder(2),(i*0.5).round}
-4.0 -0.0 -4
-3.5 -1.5 -4
-3.0 -1.0 -3
-2.5 -0.5 -3 +1
-2.0 -0.0 -2
-1.5 -1.5 -2
-1.0 -1.0 -1
-0.5 -0.5 -1 +1
 0.0  0.0  0
 0.5  0.5  1 -1
 1.0  1.0  1
 1.5  1.5  2
 2.0  0.0  2
 2.5  0.5  3 -1
 3.0  1.0  3
 3.5  1.5  4
 4.0  0.0  4
|#

(define (univ-emit-float-mod ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js java)
     (^ expr1 " % " expr2))

    ((php)
     (^ "fmod(" expr1 "," expr2 ")"))

    ((python)
     (^ "math.fmod(" expr1 "," expr2 ")"))

    ((ruby)
     (^ expr1 ".remainder(" expr2 ")"))

    ((go)
     (^ "~~~TODO3:univ-emit-float-mod~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-fmod, unknown target"))))

(define (univ-emit-float-exp ctx expr)
  (^float-math 'exp expr))

(define (univ-emit-float-expm1 ctx expr)
  (case (target-name (ctx-target ctx))

    ((js python php java)
     (^float-math 'expm1 expr))

    ((go)
     (^ "~~~TODO3:univ-emit-float-expm1~~~"))

    (else
     (^call-prim (^rts-method-use 'expm1) expr))))

(define (univ-emit-float-log ctx expr)
  (^float-math 'log expr))

(define (univ-emit-float-log1p ctx expr)
  (case (target-name (ctx-target ctx))

    ((js python php java)
     (^float-math 'log1p expr))

    ((go)
     (^ "~~~TODO3:univ-emit-float-log1p~~~"))

    (else
     (^call-prim (^rts-method-use 'log1p) expr))))

(define (univ-emit-float-sin ctx expr)
  (^float-math 'sin expr))

(define (univ-emit-float-cos ctx expr)
  (^float-math 'cos expr))

(define (univ-emit-float-tan ctx expr)
  (^float-math 'tan expr))

(define (univ-emit-float-asin ctx expr)
  (^float-math 'asin expr))

(define (univ-emit-float-acos ctx expr)
  (^float-math 'acos expr))

(define (univ-emit-float-atan ctx expr)
  (^float-math 'atan expr))

(define (univ-emit-float-atan2 ctx expr1 expr2)
  (^float-math 'atan2 expr1 expr2))

(define (univ-emit-float-sinh ctx expr)
  (^float-math 'sinh expr))

(define (univ-emit-float-cosh ctx expr)
  (^float-math 'cosh expr))

(define (univ-emit-float-tanh ctx expr)
  (^float-math 'tanh expr))

(define (univ-emit-float-asinh ctx expr)
  (case (target-name (ctx-target ctx))

    ((js python php ruby)
     (^float-math 'asinh expr))

    ((go)
     (^ "~~~TODO3:univ-emit-float-asinh~~~"))

    (else
     (^call-prim (^rts-method-use 'asinh) expr))))

(define (univ-emit-float-acosh ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^float-math 'acosh expr))

    ((go)
     (^ "~~~TODO3:univ-emit-float-acosh~~~"))

    (else
     (^call-prim (^rts-method-use 'acosh) expr))))

(define (univ-emit-float-atanh ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^float-math 'atanh expr))

    ((go)
     (^ "~~~TODO3:univ-emit-float-atanh~~~"))

    (else
     (^call-prim (^rts-method-use 'atanh) expr))))

(define (univ-emit-float-hypot ctx expr1 expr2)
  (^float-math 'hypot expr1 expr2))

(define (univ-emit-float-expt ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js python php java)
     (^float-math 'pow expr1 expr2))

    ((ruby)
     (^ expr1 " ** " expr2))

    ((go)
     (^ "~~~TODO3:univ-emit-float-expt~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-expt, unknown target"))))

(define (univ-emit-float-sqrt ctx expr)
  (^float-math 'sqrt expr))

(define (univ-emit-float-scalbn ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ;; scalbn(x,n) = x * FLT_RADIX^n
    ;; If FLT_RADIX is 2, scalbn is equivalent to ldexp
    ((js)
     (^call-prim (^rts-method-use 'ldexp) expr1 expr2))

    ((python)
     (^call-prim (^member 'math 'ldexp) expr1 expr2))

    ;; TODO : possible loss of precision here
    ((ruby)
     (^parens (^ expr1 " * 2 **" expr2)))

    ((java)
     (^parens (^ expr1 " * Math.pow(2, " expr2 ")")))

    ((php)
     (^parens (^ expr1 " * pow(2, " expr2 ")")))

    ((go)
     (^ "~~~TODO3:univ-emit-float-scalbn~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-scalbn, unknown target"))))

;; Integer exponent of a floating-point value
(define (univ-emit-float-ilogb ctx expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^call-prim (^rts-method-use 'ilogb) expr))

    ;; Since FLT_RADIX = 2, ilogb is one less than the exponent returned by frexp
    ((python)
     (^parens (^ "math.frexp(" (^float-abs expr) ")[1] - 1")))

    ;; Most of the time, ilogb(expr) is equivalent to (int) floor(log2(abs(expr)))
    ;; FIXME : doesn't work with maximum double
    ((php)
     (^call-prim 'floor (^call-prim 'log (^float-abs expr) 2)))

    ((ruby)
     (^float-toint (^call-prim (^member 'Math 'log2) (^float-abs expr))))

    ((java)
     (^cast 'int
            (^/ (^call-prim (^member 'Math 'log) (^float-abs expr))
                (^call-prim (^member 'Math 'log) (^float 2.0)))))

    ((go)
     (^ "~~~TODO3:univ-emit-float-ilogb~~~"))

    (else
     (compiler-internal-error
      "univ-emit-float-ilogb, unknown target"))))
#;
(
;; PHP Math functions
abs
acos
acosh
asin
asinh
atan2
atan
atanh
base_ convert
bindec
ceil
cos
cosh
decbin
dechex
decoct
deg2rad
exp
expm1
floor
fmod
getrandmax
hexdec
hypot
is_finite
is_infinite
is_nan
lcg_value
log10
log1p
log
max
min
mt_ getrandmax
mt_ rand
mt_ srand
octdec
pi
pow
rad2deg
rand
round
sin
sinh
sqrt
srand
tan
tanh
)

(define (univ-emit-float-integer? ctx expr)
  (^&& (^not (^parens (^float-infinite? expr)))
       (^= expr (^float-floor expr))))

(define (univ-emit-float-finite? ctx expr)
  (case (target-name (ctx-target ctx))

    ((php)
     (^call-prim "is_finite" expr))

    ((ruby)
     (^call-prim (^member expr 'finite?)))

    (else
     ;;TODO: move constants elsewhere
     (^&& (^>= expr (^float -1.7976931348623151e308))
          (^<= expr (^float 1.7976931348623151e308))))))

(define (univ-emit-float-infinite? ctx expr)
  (case (target-name (ctx-target ctx))

    ((php)
     (^call-prim "is_infinite" expr))

    (else
     ;;TODO: move constants elsewhere
     (^or (^< expr (^float -1.7976931348623151e308))
          (^> expr (^float 1.7976931348623151e308))))))

(define (univ-emit-float-nan? ctx expr)
  (case (target-name (ctx-target ctx))

    ((php)
     (^call-prim "is_nan" expr))

    ((ruby)
     (^call-prim (^member expr 'nan?)))

    (else
     (^!= expr expr))))

(define (univ-emit-float-copysign ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((java)
     (^float-math 'copySign expr1 expr2))

    (else
     (^float-math 'copysign expr1 expr2))))

(define (univ-float-has-negative-sign? ctx expr)
  (^parens
   (^or (^parens (^< expr
                     (^float targ-inexact-+0)))
        (^parens (^< (^/ (^float targ-inexact-+1)
                         expr)
                     (^float targ-inexact-+0))))))

(define (univ-floats-have-same-sign? ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((python java)
     (^= (^float-copysign
          (^float targ-inexact-+1)
          expr1)
         (^float-copysign
          (^float targ-inexact-+1)
          expr2)))

     ((ruby)
      ;; 0.0.angle => 0.0, -0.0.angle => 3.1415...
      (^= (^call-prim (^member expr1 'angle))
          (^call-prim (^member expr2 'angle))))

     (else
      (^= (univ-float-has-negative-sign? ctx expr1)
          (univ-float-has-negative-sign? ctx expr2)))))

(define (univ-emit-float-eqv? ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^call-prim (^member "Object" 'is) expr1 expr2))

    ((php)
     (^eq? (^call-prim "strval" expr1)
           (^call-prim "strval" expr2)))

    (else
     (^parens
      (^if-expr 'f64
                (^= expr1 expr2)
                (univ-floats-have-same-sign? ctx expr1 expr2)
                (^and (^float-nan? expr1)
                      (^float-nan? expr2)))))))

(define (univ-emit-flonum-box ctx expr)
  (if (univ-compactness>=? ctx 9)

      (univ-box
       (^call-prim (^rts-method-use 'flonumbox) expr)
       expr)

      (univ-emit-flonum-box-inline ctx expr)))

(define (univ-emit-flonum-box-inline ctx expr)
  (case (univ-flonum-representation ctx)

    ((class)
     (univ-box
      (^new 'flonum expr)
      expr))

    (else
     expr)))

(define (univ-emit-flonum-unbox ctx expr)
  (or (univ-unbox expr)
      (case (univ-flonum-representation ctx)

        ((class)
         (^field 'val (^cast* 'flonum expr)))

        (else
         (^downcast* 'float expr)))))

(define (univ-emit-flonum? ctx expr)
  (if (univ-compactness>=? ctx 9)
      (^call-prim (^rts-method-use 'flonump) expr)
      (univ-emit-flonum?-inline ctx expr)))

(define (univ-emit-flonum?-inline ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'flonump) expr))

    (else
     (case (univ-flonum-representation ctx)

       ((class)
        (^instanceof (^type 'flonum) (^cast*-scmobj expr)))

       (else
        (^float? expr))))))

(define (univ-emit-cpxnum-make ctx expr1 expr2)
  (^new 'cpxnum expr1 expr2))

(define (univ-emit-cpxnum? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'cpxnump) expr))

    (else
     (^instanceof (^type 'cpxnum) (^cast*-scmobj expr)))))

(define (univ-emit-ratnum-make ctx expr1 expr2)
  (^new 'ratnum expr1 expr2))

(define (univ-emit-ratnum? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'ratnump) expr))

    (else
     (^instanceof (^type 'ratnum) (^cast*-scmobj expr)))))

(define (univ-emit-bignum ctx expr1)
  (^new 'bignum expr1))

(define (univ-emit-bignum? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'bignump) expr))

    (else
     (^instanceof (^type 'bignum) (^cast*-scmobj expr)))))

(define (univ-emit-bignum-digits ctx val)
  (^field 'digits (^cast* 'bignum val)))

(define (univ-emit-u32-box ctx n)
  (^call-prim (^rts-method-use 'u32_box) n))

(define (univ-emit-u32-unbox ctx n)
  (^call-prim (^rts-method-use 'u32_unbox) n))

(define (univ-emit-s32-box ctx n)
  (^call-prim (^rts-method-use 's32_box) n))

(define (univ-emit-s32-unbox ctx n)
  (^call-prim (^rts-method-use 's32_unbox) n))

(define (univ-emit-u64-box ctx n)
  n)

(define (univ-emit-u64-unbox ctx n)
  n)

(define (univ-emit-s64-box ctx n)
  n)

(define (univ-emit-s64-unbox ctx n)
  n)

(define (univ-emit-box? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'boxp) expr))

    (else
     (^instanceof (^type 'box) (^cast*-scmobj expr)))))

(define (univ-emit-box ctx expr)
  (^new 'box expr))

(define (univ-emit-unbox ctx expr)
  (^field 'val (^cast* 'box expr)))

(define (univ-emit-setbox ctx expr1 expr2)
  (^assign (^field 'val expr1) expr2))

(define (univ-emit-values-box ctx expr)
  (case (univ-values-representation ctx)

    ((class)
     (^new 'values expr))

    (else
     expr)))

(define (univ-emit-values-unbox ctx expr)
  (case (univ-values-representation ctx)

    ((class)
     (^field 'vals (^cast* 'values expr)))

    (else
     expr)))

(define (univ-emit-values? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'valuesp) expr))

    (else
     (case (univ-values-representation ctx)

       ((class)
        (^instanceof (^type 'values) (^cast*-scmobj expr)))

       (else
        (^array? expr))))))

(define (univ-emit-values-length ctx expr)
  (^array-length (^values-unbox expr)))

(define (univ-emit-values-ref ctx expr1 expr2)
  (^array-index (^values-unbox expr1) expr2))

(define (univ-emit-values-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^values-unbox expr1) expr2) expr3))

(define (univ-emit-vect-box ctx type expr)
  (case type
    ((scmobj) (univ-emit-vector-box ctx expr))
    ((u8)     (univ-emit-u8vector-box ctx expr))
    ((u16)    (univ-emit-u16vector-box ctx expr))
    ((u32)    (univ-emit-u32vector-box ctx expr))
    ((u64)    (univ-emit-u64vector-box ctx expr))
    ((s8)     (univ-emit-s8vector-box ctx expr))
    ((s16)    (univ-emit-s16vector-box ctx expr))
    ((s32)    (univ-emit-s32vector-box ctx expr))
    ((s64)    (univ-emit-s64vector-box ctx expr))
    ((f32)    (univ-emit-f32vector-box ctx expr))
    ((f64)    (univ-emit-f64vector-box ctx expr))
    (else
     (compiler-internal-error
      "univ-emit-vect-box, type not implemented"))))

(define (univ-emit-vect-unbox ctx type expr)
  (case type
    ((scmobj) (univ-emit-vector-unbox ctx expr))
    ((u8)     (univ-emit-u8vector-unbox ctx expr))
    ((u16)    (univ-emit-u16vector-unbox ctx expr))
    ((u32)    (univ-emit-u32vector-unbox ctx expr))
    ((u64)    (univ-emit-u64vector-unbox ctx expr))
    ((s8)     (univ-emit-s8vector-unbox ctx expr))
    ((s16)    (univ-emit-s16vector-unbox ctx expr))
    ((s32)    (univ-emit-s32vector-unbox ctx expr))
    ((s64)    (univ-emit-s64vector-unbox ctx expr))
    ((f32)    (univ-emit-f32vector-unbox ctx expr))
    ((f64)    (univ-emit-f64vector-unbox ctx expr))
    (else
     (compiler-internal-error
      "univ-emit-vect-unbox, type not implemented"))))

(define (univ-emit-vect? ctx type expr)
  (case type
    ((scmobj) (univ-emit-vector? ctx expr))
    ((u8)     (univ-emit-u8vector? ctx expr))
    ((u16)    (univ-emit-u16vector? ctx expr))
    ((u32)    (univ-emit-u32vector? ctx expr))
    ((u64)    (univ-emit-u64vector? ctx expr))
    ((s8)     (univ-emit-s8vector? ctx expr))
    ((s16)    (univ-emit-s16vector? ctx expr))
    ((s32)    (univ-emit-s32vector? ctx expr))
    ((s64)    (univ-emit-s64vector? ctx expr))
    ((f32)    (univ-emit-f32vector? ctx expr))
    ((f64)    (univ-emit-f64vector? ctx expr))
    (else
     (compiler-internal-error
      "univ-emit-vect?, type not implemented"))))

(define (univ-emit-vector-box ctx expr)
  (case (univ-vector-representation ctx 'scmobj)

    ((class)
     (^new 'vector expr))

    (else
     expr)))

(define (univ-emit-vector-unbox ctx expr)
  (case (univ-vector-representation ctx 'scmobj)

    ((class)
     (^field 'elems (^cast* 'vector expr)))

    (else
     (^downcast* '(array scmobj) expr))))

(define (univ-emit-vector? ctx expr)
  (if (univ-compactness>=? ctx 9)
      (^call-prim (^rts-method-use 'vectorp) expr)
      (univ-emit-vector?-inline ctx expr)))

(define (univ-emit-vector?-inline ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'vectorp) expr))

    (else
     (case (univ-vector-representation ctx 'scmobj)

       ((class)
        (^instanceof (^type 'vector) (^cast*-scmobj expr)))

       (else
        (^array? expr))))))

(define (univ-emit-vector-length ctx expr)
  (^array-length (^vector-unbox expr)))

(define (univ-emit-vector-shrink! ctx expr1 expr2)
  (^array-shrink! (^vector-unbox expr1) expr2))

(define (univ-emit-vector-ref ctx expr1 expr2)
  (^array-index (^vector-unbox expr1) expr2))

(define (univ-emit-vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^vector-unbox expr1) expr2) expr3))

(define (univ-emit-u8vector-box ctx expr)
  (case (univ-vector-representation ctx 'u8)

    ((class)
     (^new 'u8vector expr))

    (else
     expr)))

(define (univ-emit-u8vector-unbox ctx expr)
  (case (univ-vector-representation ctx 'u8)

    ((class)
     (^field 'elems (^cast* 'u8vector expr)))

    (else
     (^downcast* '(array u8) expr))))

(define (univ-emit-u8vector? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'u8vectorp) expr))

    (else
     (case (univ-vector-representation ctx 'u8)

       ((class)
        (^instanceof (^type 'u8vector) (^cast*-scmobj expr)))

       (else
        (^instanceof (^type '(array u8)) expr))))))

(define (univ-emit-u8vector-length ctx expr)
  (^array-length (^u8vector-unbox expr)))

(define (univ-shrink-by-copying-elems! ctx type expr1 expr2)
  (^assign (^field 'elems (^cast* type expr1))
           (case (target-name (ctx-target ctx))

             ((js)
              (^call-prim (^member (^field 'elems (^cast* type expr1))
                                   'subarray)
                          (^int 0)
                          expr2))

             (else
              (^subarray (^field 'elems (^cast* type expr1))
                         0
                         expr2)))))

(define (univ-emit-u8vector-shrink! ctx expr1 expr2)
  (case (univ-vector-representation ctx 'u8)

    ((class)
     (univ-shrink-by-copying-elems! ctx 'u8vector expr1 expr2))

    (else
     (^array-shrink! (^u8vector-unbox expr1) expr2))))

(define (univ-emit-u8vector-ref ctx expr1 expr2)
  (let ((code (^array-index (^u8vector-unbox expr1) expr2)))
    (case (target-name (ctx-target ctx))
      ((java) (^parens (^bitand (^int #xff) code)))
      (else   code))))

(define (univ-emit-u8vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^u8vector-unbox expr1) expr2) expr3))

(define (univ-emit-u16vector-box ctx expr)
  (case (univ-vector-representation ctx 'u16)

    ((class)
     (^new 'u16vector expr))

    (else
     (^downcast* '(array u16) expr))))

(define (univ-emit-u16vector-unbox ctx expr)
  (case (univ-vector-representation ctx 'u16)

    ((class)
     (^field 'elems (^cast* 'u16vector expr)))

    (else
     expr)))

(define (univ-emit-u16vector? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'u16vectorp) expr))

    (else
     (case (univ-vector-representation ctx 'u16)

       ((class)
        (^instanceof (^type 'u16vector) (^cast*-scmobj expr)))

       (else
        (^instanceof (^type '(array u16)) expr))))))

(define (univ-emit-u16vector-length ctx expr)
  (^array-length (^u16vector-unbox expr)))

(define (univ-emit-u16vector-shrink! ctx expr1 expr2)
  (case (univ-vector-representation ctx 'u16)

    ((class)
     (univ-shrink-by-copying-elems! ctx 'u16vector expr1 expr2))

    (else
     (^array-shrink! (^u16vector-unbox expr1) expr2))))

(define (univ-emit-u16vector-ref ctx expr1 expr2)
  (let ((code (^array-index (^u16vector-unbox expr1) expr2)))
    (case (target-name (ctx-target ctx))
      ((java) (^parens (^bitand (^int #xffff) code)))
      (else   code))))

(define (univ-emit-u16vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^u16vector-unbox expr1) expr2) expr3))

(define (univ-emit-u32vector-box ctx expr)
  (case (univ-vector-representation ctx 'u32)

    ((class)
     (^new 'u32vector expr))

    (else
     expr)))

(define (univ-emit-u32vector-unbox ctx expr)
  (case (univ-vector-representation ctx 'u32)

    ((class)
     (^field 'elems (^cast* 'u32vector expr)))

    (else
     (^downcast* '(array u32) expr))))

(define (univ-emit-u32vector? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'u32vectorp) expr))

    (else
     (case (univ-vector-representation ctx 'u32)

       ((class)
        (^instanceof (^type 'u32vector) (^cast*-scmobj expr)))

       (else
        (^instanceof (^type '(array u32)) expr))))))

(define (univ-emit-u32vector-length ctx expr)
  (^array-length (^u32vector-unbox expr)))

(define (univ-emit-u32vector-shrink! ctx expr1 expr2)
  (case (univ-vector-representation ctx 'u32)

    ((class)
     (univ-shrink-by-copying-elems! ctx 'u32vector expr1 expr2))

    (else
     (^array-shrink! (^u32vector-unbox expr1) expr2))))

(define (univ-emit-u32vector-ref ctx expr1 expr2)
  (^array-index (^u32vector-unbox expr1) expr2))

(define (univ-emit-u32vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^u32vector-unbox expr1) expr2) expr3))

(define (univ-emit-u64vector-box ctx expr)
  (case (univ-vector-representation ctx 'u64)

    ((class)
     (^new 'u64vector expr))

    (else
     expr)))

(define (univ-emit-u64vector-unbox ctx expr)
  (case (univ-vector-representation ctx 'u64)

    ((class)
     (^field 'elems (^cast* 'u64vector expr)))

    (else
     (^downcast* '(array u64) expr))))

(define (univ-emit-u64vector? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'u64vectorp) expr))

    (else
     (case (univ-vector-representation ctx 'u64)

       ((class)
        (^instanceof (^type 'u64vector) (^cast*-scmobj expr)))

       (else
        (^instanceof (^type '(array u64)) expr))))))

(define (univ-emit-u64vector-length ctx expr)
  (^array-length (^u64vector-unbox expr)))

(define (univ-emit-u64vector-shrink! ctx expr1 expr2)
  (case (univ-vector-representation ctx 'u64)

;;    ((class)
;;     (univ-shrink-by-copying-elems! ctx 'u64vector expr1 expr2))

    (else
     (^array-shrink! (^u64vector-unbox expr1) expr2))))

(define (univ-emit-u64vector-ref ctx expr1 expr2)
  (^array-index (^u64vector-unbox expr1) expr2))

(define (univ-emit-u64vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^u64vector-unbox expr1) expr2) expr3))

(define (univ-emit-s8vector-box ctx expr)
  (case (univ-vector-representation ctx 's8)

    ((class)
     (^new 's8vector expr))

    (else
     expr)))

(define (univ-emit-s8vector-unbox ctx expr)
  (case (univ-vector-representation ctx 's8)

    ((class)
     (^field 'elems (^cast* 's8vector expr)))

    (else
     (^downcast* '(array s8) expr))))

(define (univ-emit-s8vector? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 's8vectorp) expr))

    (else
     (case (univ-vector-representation ctx 's8)

       ((class)
        (^instanceof (^type 's8vector) (^cast*-scmobj expr)))

       (else
        (^instanceof (^type '(array s8)) expr))))))

(define (univ-emit-s8vector-length ctx expr)
  (^array-length (^s8vector-unbox expr)))

(define (univ-emit-s8vector-shrink! ctx expr1 expr2)
  (case (univ-vector-representation ctx 's8)

    ((class)
     (univ-shrink-by-copying-elems! ctx 's8vector expr1 expr2))

    (else
     (^array-shrink! (^s8vector-unbox expr1) expr2))))

(define (univ-emit-s8vector-ref ctx expr1 expr2)
  (^array-index (^s8vector-unbox expr1) expr2))

(define (univ-emit-s8vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^s8vector-unbox expr1) expr2) expr3))

(define (univ-emit-s16vector-box ctx expr)
  (case (univ-vector-representation ctx 's16)

    ((class)
     (^new 's16vector expr))

    (else
     expr)))

(define (univ-emit-s16vector-unbox ctx expr)
  (case (univ-vector-representation ctx 's16)

    ((class)
     (^field 'elems (^cast* 's16vector expr)))

    (else
     (^downcast* '(array s16) expr))))

(define (univ-emit-s16vector? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 's16vectorp) expr))

    (else
     (case (univ-vector-representation ctx 's16)

       ((class)
        (^instanceof (^type 's16vector) (^cast*-scmobj expr)))

       (else
        (^instanceof (^type '(array s16)) expr))))))

(define (univ-emit-s16vector-length ctx expr)
  (^array-length (^s16vector-unbox expr)))

(define (univ-emit-s16vector-shrink! ctx expr1 expr2)
  (case (univ-vector-representation ctx 's16)

    ((class)
     (univ-shrink-by-copying-elems! ctx 's16vector expr1 expr2))

    (else
     (^array-shrink! (^s16vector-unbox expr1) expr2))))

(define (univ-emit-s16vector-ref ctx expr1 expr2)
  (^array-index (^s16vector-unbox expr1) expr2))

(define (univ-emit-s16vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^s16vector-unbox expr1) expr2) expr3))

(define (univ-emit-s32vector-box ctx expr)
  (case (univ-vector-representation ctx 's32)

    ((class)
     (^new 's32vector expr))

    (else
     expr)))

(define (univ-emit-s32vector-unbox ctx expr)
  (case (univ-vector-representation ctx 's32)

    ((class)
     (^field 'elems (^cast* 's32vector expr)))

    (else
     (^downcast* '(array s32) expr))))

(define (univ-emit-s32vector? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 's32vectorp) expr))

    (else
     (case (univ-vector-representation ctx 's32)

       ((class)
        (^instanceof (^type 's32vector) (^cast*-scmobj expr)))

       (else
        (^instanceof (^type '(array s32)) expr))))))

(define (univ-emit-s32vector-length ctx expr)
  (^array-length (^s32vector-unbox expr)))

(define (univ-emit-s32vector-shrink! ctx expr1 expr2)
  (case (univ-vector-representation ctx 's32)

    ((class)
     (univ-shrink-by-copying-elems! ctx 's32vector expr1 expr2))

    (else
     (^array-shrink! (^s32vector-unbox expr1) expr2))))

(define (univ-emit-s32vector-ref ctx expr1 expr2)
  (^array-index (^s32vector-unbox expr1) expr2))

(define (univ-emit-s32vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^s32vector-unbox expr1) expr2) expr3))

(define (univ-emit-s64vector-box ctx expr)
  (case (univ-vector-representation ctx 's64)

    ((class)
     (^new 's64vector expr))

    (else
     expr)))

(define (univ-emit-s64vector-unbox ctx expr)
  (case (univ-vector-representation ctx 's64)

    ((class)
     (^field 'elems (^cast* 's64vector expr)))

    (else
     (^downcast* '(array s64) expr))))

(define (univ-emit-s64vector? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 's64vectorp) expr))

    (else
     (case (univ-vector-representation ctx 's64)

       ((class)
        (^instanceof (^type 's64vector) (^cast*-scmobj expr)))

       (else
        (^instanceof (^type '(array s64)) expr))))))

(define (univ-emit-s64vector-length ctx expr)
  (^array-length (^s64vector-unbox expr)))

(define (univ-emit-s64vector-shrink! ctx expr1 expr2)
  (case (univ-vector-representation ctx 's64)

;;    ((class)
;;     (univ-shrink-by-copying-elems! ctx 's64vector expr1 expr2))

    (else
     (^array-shrink! (^s64vector-unbox expr1) expr2))))

(define (univ-emit-s64vector-ref ctx expr1 expr2)
  (^array-index (^s64vector-unbox expr1) expr2))

(define (univ-emit-s64vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^s64vector-unbox expr1) expr2) expr3))

(define (univ-emit-f32vector-box ctx expr)
  (case (univ-vector-representation ctx 'f32)

    ((class)
     (^new 'f32vector expr))

    (else
     expr)))

(define (univ-emit-f32vector-unbox ctx expr)
  (case (univ-vector-representation ctx 'f32)

    ((class)
     (^field 'elems (^cast* 'f32vector expr)))

    (else
     (^downcast* '(array f32) expr))))

(define (univ-emit-f32vector? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'f32vectorp) expr))

    (else
     (case (univ-vector-representation ctx 'f32)

       ((class)
        (^instanceof (^type 'f32vector) (^cast*-scmobj expr)))

       (else
        (^instanceof (^type '(array f32)) expr))))))

(define (univ-emit-f32vector-length ctx expr)
  (^array-length (^f32vector-unbox expr)))

(define (univ-emit-f32vector-shrink! ctx expr1 expr2)
  (case (univ-vector-representation ctx 'f32)

    ((class)
     (univ-shrink-by-copying-elems! ctx 'f32vector expr1 expr2))

    (else
     (^array-shrink! (^f32vector-unbox expr1) expr2))))

(define (univ-emit-f32vector-ref ctx expr1 expr2)
  (^array-index (^f32vector-unbox expr1) expr2))

(define (univ-emit-f32vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^f32vector-unbox expr1) expr2) expr3))


(define (univ-emit-f64vector-box ctx expr)
  (case (univ-vector-representation ctx 'f64)

    ((class)
     (^new 'f64vector expr))

    (else
     expr)))

(define (univ-emit-f64vector-unbox ctx expr)
  (case (univ-vector-representation ctx 'f64)

    ((class)
     (^field 'elems (^cast* 'f64vector expr)))

    (else
     (^downcast* '(array f64) expr))))

(define (univ-emit-f64vector? ctx expr)
  (case (univ-vector-representation ctx 'f64)

    ((class)
     (^instanceof (^type 'f64vector) (^cast*-scmobj expr)))

    (else
     (case (target-name (ctx-target ctx))

       ((go)
        (^call-prim (^rts-method-use 'f64vectorp) expr))

       (else
        (^instanceof (^type '(array f64)) expr))))))

(define (univ-emit-f64vector-length ctx expr)
  (^array-length (^f64vector-unbox expr)))

(define (univ-emit-f64vector-shrink! ctx expr1 expr2)
  (case (univ-vector-representation ctx 'f64)

    ((class)
     (univ-shrink-by-copying-elems! ctx 'f64vector expr1 expr2))

    (else
     (^array-shrink! (^f64vector-unbox expr1) expr2))))

(define (univ-emit-f64vector-ref ctx expr1 expr2)
  (^array-index (^f64vector-unbox expr1) expr2))

(define (univ-emit-f64vector-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^f64vector-unbox expr1) expr2) expr3))

(define (univ-emit-structure-box ctx expr)
  (case (univ-structure-representation ctx)

    ((class)
     (^new 'structure expr))

    (else
     (compiler-internal-error
      "univ-emit-structure-box, host representation not implemented"))))

(define (univ-emit-structure-unbox ctx expr)
  (case (univ-structure-representation ctx)

    ((class)
     (^field 'slots (^cast* 'structure expr)))

    (else
     (compiler-internal-error
      "univ-emit-structure-unbox, host representation not implemented"))))

(define (univ-emit-structure? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'structurep) expr))

    (else
     (case (univ-structure-representation ctx)

       ((class)
        (^instanceof (^type 'structure) (^cast*-scmobj expr)))

       (else
        (compiler-internal-error
         "univ-emit-structure?, host representation not implemented"))))))

(define (univ-emit-structure-ref ctx expr1 expr2)
  (^array-index (^structure-unbox expr1) expr2))

(define (univ-emit-structure-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (^structure-unbox expr1) expr2) expr3))

(define (univ-emit-str ctx val)
  (univ-constant
   (case (target-name (ctx-target ctx))

     ((js java go)
      (cdr (univ-convert-string val #\" #\")))

     ((php)
      (let ((val-utf8
             (list->string
              (map integer->char
                   (u8vector->list
                    (call-with-output-u8vector
                     (list init: '#u8() char-encoding: 'UTF-8)
                     (lambda (port) (univ-display val port))))))))
        (cdr (univ-convert-string val-utf8 #\" #\$))))

     ((python)
      (let ((x (univ-convert-string val #\" #\")))
        (if (car x) (cons "u" (cdr x)) (cdr x))))

     ((ruby)
      (cdr (univ-convert-string val #\" #\#)))

     (else
      (compiler-internal-error
       "univ-emit-str, unknown target")))))

(define (univ-convert-string str delim special)
  (let ((unicode? #f))
    (let loop ((i 0) (j 0) (rev-chunks (list (string delim))))

      (define (done rev-chunks)
        (cons unicode? (reverse (cons (string delim) rev-chunks))))

      (define (add i j)
        (if (= i j)
            rev-chunks
            (cons (substring str i j) rev-chunks)))

      (if (= j (string-length str))
          (done (add i j))
          (let ((next-j (+ j 1))
                (c (string-ref str j)))
            (if (or (char=? c #\\)
                    (char=? c delim)
                    (char=? c special))
                (loop next-j
                      next-j
                      (cons (string #\\ c)
                            (add i j)))
                (let ((n (char->integer c)))
                  (cond ((< n #x100)
                         (if (or (< n 32) (>= n 127))
                             (let ((x (number->string (+ #x100 n) 16)))
                               (loop next-j
                                     next-j
                                     (cons (string-append "\\x"
                                                          (substring x 1 3))
                                           (add i j))))
                             (loop i
                                   (+ j 1)
                                   rev-chunks)))
                        ((< n #x10000)
                         (let ((x (number->string (+ #x10000 n) 16)))
                           (set! unicode? #t)
                           (loop next-j
                                 next-j
                                 (cons (string-append "\\u"
                                                      (substring x 1 5))
                                       (add i j)))))
                        (else
                         (let* ((hi (quotient (- n #x10000) #x400))
                                (lo (modulo n #x400))
                                (hi-x (number->string (+ #xd800 hi) 16))
                                (lo-x (number->string (+ #xdc00 lo) 16)))
                           (set! unicode? #t)
                           (loop next-j
                                 next-j
                                 (cons (string-append "\\u" hi-x "\\u" lo-x)
                                       (add i j)))))))))))))

(define (univ-emit-str-to-codes ctx str)
  (case (univ-string-representation ctx)

    ((class)
     (^call-prim
      (^rts-method-use 'str2codes)
      str))

    (else
     str)))

(define (univ-str-to-num-array-constant ctx str)
  (univ-num-array-constant
   ctx
   'unicode
   (map char->integer (string->list str))))

(define (univ-emit-str-length ctx str)
  (case (target-name (ctx-target ctx))

    ((js ruby)
     (^ str ".length"))

    ((php)
     (^ "strlen(" str ")"))

    ((python go)
     (^ "len(" str ")"))

    ((java)
     (^ str ".length()"))

    (else
     (compiler-internal-error
      "univ-emit-str-length, unknown target"))))

(define (univ-emit-str-index-code ctx str i)
  (case (target-name (ctx-target ctx))

    ((js)
     (^call-prim (^member str 'charCodeAt) i))

    ((php)
     (^call-prim "ord" (^call-prim "substr" str i (^int 1))));;TODO fix for unicode characters

    ((python)
     (^call-prim "ord" (^ str "[" i "]")))

    ((ruby)
     (^ str "[" i "]" ".ord"))

    ((java)
     (^call-prim (^member str 'codePointAt) i))

    ((go)
     (^ str "[" i "]"))

    (else
     (compiler-internal-error
      "univ-emit-str-index-code, unknown target"))))

(define (univ-emit-string-obj ctx obj force-var?)
  (case (univ-string-representation ctx)

    ((class)
     (let ((x (univ-str-to-num-array-constant ctx obj)))
       (univ-obj-use
        ctx
        obj
        force-var?
        (lambda ()
          (^string-box x)))))

    (else
     (case (target-name (ctx-target ctx))

       ((go)
        (univ-str-to-num-array-constant ctx obj))

       (else
        (^str obj))))))

(define (univ-emit-string-box ctx expr)
  (case (univ-string-representation ctx)

    ((class)
     (^new 'string expr))

    (else
     expr)))

(define (univ-emit-string-unbox ctx expr)
  (case (univ-string-representation ctx)

    ((class)
     (^field 'codes (^cast* 'string expr)))

    (else
     (case (target-name (ctx-target ctx))

       ((go)
        (^downcast* '(array unicode) expr))

       (else
        expr)))))

(define (univ-emit-string? ctx expr)
  (if (univ-compactness>=? ctx 9)
      (^call-prim (^rts-method-use 'stringp) expr)
      (univ-emit-string?-inline ctx expr)))

(define (univ-emit-string?-inline ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'stringp) expr))

    (else
     (case (univ-string-representation ctx)

       ((class)
        (^instanceof (^type 'string) (^cast*-scmobj expr)))

       (else
        (^str? expr))))))

(define (univ-emit-string-length ctx expr)
  (case (univ-string-representation ctx)

    ((class)
     (^array-length (^string-unbox expr)))

    (else
     (compiler-internal-error
      "univ-emit-string-length, host representation not implemented"))))

(define (univ-emit-string-shrink! ctx expr1 expr2)
  (case (univ-string-representation ctx)

    ((class)
     (^array-shrink! (^string-unbox expr1) expr2))

    (else
     (compiler-internal-error
      "univ-emit-string-shrink!, host representation not implemented"))))

(define (univ-emit-string-ref ctx expr1 expr2)
  (case (univ-string-representation ctx)

    ((class)
     (^array-index expr1 expr2))

    (else
     (^str-index-code expr1 expr2))))

(define (univ-emit-string-set! ctx expr1 expr2 expr3)
  (case (univ-string-representation ctx)

    ((class)
     (^assign (^array-index expr1 expr2) expr3))

    (else
     ;; mutable strings do not exist in js, php, python and ruby
     (compiler-internal-error
      "univ-emit-string-set!, host representation not implemented"))))

(define (univ-emit-substring ctx expr1 expr2 expr3)
  (case (target-name (ctx-target ctx))

    ((js python ruby)
     (^subarray expr1 expr2 expr3))

    ((php)
     (^call-prim 'substr expr1 expr2 expr3))

    ;; TODO : Java

    ((go)
     (^ "~~~TODO3:univ-emit-substring~~~"))

    (else
     (compiler-internal-error
      "univ-emit-substring, unknown target"))))

(define (univ-emit-str-toint ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ "+" expr))

    ((python)
     (^call-prim 'int expr))

    ((ruby)
     (^call-member expr 'to_i))

    ((java)
     (^call-member 'Integer 'parseInt expr))

    ((go)
     (^ "~~~TODO3:univ-emit-str-toint~~~"))

    (else
     (compiler-internal-error
      "univ-emit-str-toint, unknown target"))))

(define (univ-emit-str-tofloat ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ "+" expr))

    ((python)
     (^call-prim 'float expr))

    ((ruby)
     (^call-member expr 'to_f))

    ((java)
     (^call-member 'Float 'parseFloat expr))

    ((go)
     (^ "~~~TODO3:univ-emit-str-tofloat~~~"))

    (else
     (compiler-internal-error
      "univ-emit-str-tofloat, unknown target"))))

(define (univ-emit-symbol-obj ctx obj force-var?)
  (case (univ-symbol-representation ctx)

    ((class)
     (let ((x (^str (symbol->string obj))))
       (univ-box
        (univ-obj-use
         ctx
         obj
         force-var?
         (lambda ()
           (^symbol-box x)))
        x)))

    (else
     (case (target-name (ctx-target ctx))

       ((js php python)
        (^str (symbol->string obj)))

       ((ruby)
        (univ-constant (^ ":" (^str (symbol->string obj)))))

       ((go)
        (^ "~~~TODO3:univ-emit-symbol-obj~~~"))

       (else
        (compiler-internal-error
         "univ-emit-symbol-obj, unknown target"))))))

(define (univ-emit-symbol-box ctx hname)
  (case (univ-symbol-representation ctx)

    ((class)
     (univ-box
      (^call-prim
       (^rts-method-use 'make_interned_symbol)
       hname)
      hname))

    (else
     (^symbol-box-uninterned hname (^str->string hname) #f))))

(define (univ-emit-symbol-box-uninterned ctx hname name hash)
  (case (univ-symbol-representation ctx)

    ((class)
     (univ-box
      (^new 'symbol hname name hash (^obj #f))
      hname))

    (else
     (case (target-name (ctx-target ctx))

       ((js php python)
        hname)

       ((ruby)
        (^ hname ".to_sym"))

       (else
        (compiler-internal-error
         "univ-emit-symbol-box-uninterned, unknown target"))))))

(define (univ-emit-symbol-unbox ctx expr)
  (or (univ-unbox expr)
      (case (univ-symbol-representation ctx)

        ((class)
         (^field 'hname (^cast* 'symbol expr)))

        (else
         (case (target-name (ctx-target ctx))

           ((js php python)
            expr)

           ((ruby)
            (^ expr ".to_s"))

           ((go)
            (^ "~~~TODO3:univ-emit-symbol-unbox~~~"))

           (else
            (compiler-internal-error
             "univ-emit-symbol-unbox, unknown target")))))))

(define (univ-emit-symbol? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'symbolp) expr))

    (else
     (case (univ-symbol-representation ctx)

       ((class)
        (^instanceof (^type 'symbol) (^cast*-scmobj expr)))

       (else
        (case (target-name (ctx-target ctx))

          ((js)
           (^typeof "string" expr))

          ((php)
           (^call-prim "is_string" expr))

          ((python)
           (^instanceof "str" expr))

          ((ruby)
           (^instanceof "Symbol" expr))

          (else
           (compiler-internal-error
            "univ-emit-symbol?, unknown target"))))))))

(define (univ-emit-keyword-obj ctx obj force-var?)
  (case (univ-keyword-representation ctx)

    ((class)
     (let ((x (^str (keyword->string obj))))
       (univ-box
        (univ-obj-use
         ctx
         obj
         force-var?
         (lambda ()
           (^keyword-box x)))
        x)))

    (else
     (compiler-internal-error
      "univ-emit-keyword-box, host representation not implemented"))))

(define (univ-emit-keyword-box ctx hname)
  (case (univ-keyword-representation ctx)

    ((class)
     (univ-box
      (^call-prim
       (^rts-method-use 'make_interned_keyword)
       hname)
      hname))

    (else
     (^keyword-box-uninterned hname (^str->string hname) #f))))

(define (univ-emit-keyword-box-uninterned ctx hname name hash)
  (case (univ-keyword-representation ctx)

    ((class)
     (univ-box
      (^new 'keyword hname name hash (^obj #f))
      hname))

    (else
     (case (target-name (ctx-target ctx))

       ((js php python)
        hname)

       ((ruby)
        (^ hname ".to_sym"))

       (else
        (compiler-internal-error
         "univ-emit-keyword-box-uninterned, unknown target"))))))

(define (univ-emit-keyword-unbox ctx expr)
  (or (univ-unbox expr)
      (case (univ-keyword-representation ctx)

        ((class)
         (^field 'hname (^cast* 'keyword expr)))

        (else
         (compiler-internal-error
          "univ-emit-keyword-unbox, host representation not implemented")))))

(define (univ-emit-keyword? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'keywordp) expr))

    (else
     (case (univ-keyword-representation ctx)

       ((class)
        (^instanceof (^type 'keyword) (^cast*-scmobj expr)))

       (else
        (compiler-internal-error
         "univ-emit-keyword?, host representation not implemented"))))))

(define (univ-emit-frame-box ctx expr)
  (case (univ-frame-representation ctx)

    ((class)
     (univ-box
      (^new 'frame expr)
      expr))

    (else
     expr)))

(define (univ-emit-frame-unbox ctx expr)
  (or (univ-unbox expr)
      (case (univ-frame-representation ctx)

        ((class)
         (^field 'slots (^cast* 'frame expr)))

        (else
         (^downcast* 'frm expr)))))

(define (univ-emit-frame-slots ctx expr)
  (or (univ-unbox expr)
      (case (univ-frame-representation ctx)

        ((class)
         (^field 'slots expr))

        (else
         expr))))

(define (univ-emit-frame? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'framep) expr))

    (else
     (case (univ-frame-representation ctx)

       ((class)
        (^instanceof (^type 'frame) (^cast*-scmobj expr)))

       (else
        (^array? expr))))))

(define (univ-emit-new-continuation ctx expr1 expr2)
  (^new 'continuation expr1 expr2))

(define (univ-emit-continuation? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'continuationp) expr))

    (else
     (^instanceof (^type 'continuation) (^cast*-scmobj expr)))))

(define (univ-emit-function? ctx expr)
  (case (target-name (ctx-target ctx))

   ((js)
    (^typeof "function" expr))

   ((php)
    (^call-prim "is_callable" expr))

   ((python)
    (^ "hasattr(" expr ", '__call__')"))

   ((ruby)
    (^instanceof "Proc" expr))

   ((go)
    (^ "~~~TODO3:univ-emit-function?~~~"))

   (else
    (compiler-internal-error
       "univ-emit-function?, unknown target"))))

(define (univ-emit-procedure? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'procedurep) expr))

    (else
     (case (univ-procedure-representation ctx)

       ((class)
        ;; this accounts for procedure control-points and closures
        (^instanceof (^type 'jumpable) (^cast*-scmobj expr)))

       (else
        (^and (^function? expr)
              (case (target-name (ctx-target ctx))

                ((js)
                 (^not (^prop-index-exists?
                        expr
                        (^str (symbol->string (univ-field-rename ctx 'fs))))))

                ((python)
                 (^not
                  (^call-prim
                   "hasattr"
                   expr
                   (^str (symbol->string (univ-field-rename ctx 'fs))))))

                (else
                 (^bool #f))))))))) ;;TODO: implement

(define (univ-emit-return? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'returnp) expr))

    (else
     (case (univ-procedure-representation ctx)

       ((class)
        (^instanceof (^type 'returnpt) (^cast*-scmobj expr)))

       (else
        (^and (^function? expr)
              (case (target-name (ctx-target ctx))

                ((js)
                 (^prop-index-exists?
                  expr
                  (^str (symbol->string (univ-field-rename ctx 'fs)))))

                ((python)
                 (^call-prim
                  "hasattr"
                  expr
                  (^str (symbol->string (univ-field-rename ctx 'fs)))))

                (else
                 (^bool #f))))))))) ;;TODO: implement

(define (univ-emit-closure? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'closurep) expr))

    (else
     (case (univ-procedure-representation ctx)

       ((class)
        (^instanceof (^type 'closure) (^cast*-scmobj expr)))

       (else
        (case (target-name (ctx-target ctx))

          ((js)
           (^not (^prop-index-exists?
                  expr
                  (^str (symbol->string (univ-field-rename ctx 'id))))))

          ((php)
           (^instanceof (^type 'closure) expr))

          ((python)
           (^not
            (^call-prim
             "hasattr"
             expr
             (^str (symbol->string (univ-field-rename ctx 'id))))))

          ((ruby)
           (^= (^ expr ".instance_variables.length") (^int 0)))

          (else
           (compiler-internal-error
            "univ-emit-closure?, unknown target"))))))))

(define (univ-emit-closure-length ctx expr)
  (^array-length (univ-clo-slots ctx expr)))

(define (univ-emit-closure-code ctx expr)
  (^array-index (univ-clo-slots ctx expr) 0))

(define (univ-emit-closure-ref ctx expr1 expr2)
  (^array-index (univ-clo-slots ctx expr1) expr2))

(define (univ-emit-closure-set! ctx expr1 expr2 expr3)
  (^assign (^array-index (univ-clo-slots ctx expr1) expr2) expr3))

(define (univ-emit-new-delay-promise ctx expr)
  (^call-prim
   (^rts-method-use 'make_delay_promise)
   (^cast* 'entrypt expr)))

(define (univ-emit-promise? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'promisep) expr))

    (else
     (^instanceof (^type 'promise) (^cast*-scmobj expr)))))

(define (univ-emit-new-will ctx expr1 expr2)
  (^new 'will expr1 expr2))

(define (univ-emit-will? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'willp) expr))

    (else
     (^instanceof (^type 'will) (^cast*-scmobj expr)))))

(define (univ-emit-new-foreign ctx expr1 expr2)
  (^new 'foreign expr1 expr2))

(define (univ-emit-foreign? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'foreignp) expr))

    (else
     (^instanceof (^type 'foreign) (^cast*-scmobj expr)))))

(define (univ-emit-new-scheme ctx expr1)
  (^new 'scheme expr1))

(define (univ-emit-scheme? ctx expr)
  (case (target-name (ctx-target ctx))

    ((go)
     (^call-prim (^rts-method-use 'schemep) expr))

    (else
     (^instanceof (^type 'scheme) (^cast*-scmobj expr)))))

(define (univ-emit-call-prim ctx expr . params)
  (univ-emit-call-prim-aux ctx expr params))

(define (univ-emit-call-member ctx expr fct . params)
  (let ((name
         (case (target-name (ctx-target ctx))
           ((ruby)
            ;; Avoid (^member (^this) fct) => @fct
            (^ expr "." fct))
           (else (^member expr fct)))))
    (univ-emit-call-prim-aux ctx name params)))

(define (univ-emit-call-prim-aux ctx expr params)
  (if (and (null? params)
           (eq? (target-name (ctx-target ctx)) 'ruby))
      expr
      (univ-emit-apply-aux ctx expr params "(" ")")))

(define (univ-emit-jump ctx proc . params)
  (case (univ-procedure-representation ctx)

    ((class struct)
     (univ-emit-call-prim-aux ctx (^field 'jump (^parens proc)) params))

    (else
     (univ-emit-call-aux ctx proc params))))

(define (univ-emit-call-aux ctx expr params)
  (if (eq? (target-name (ctx-target ctx)) 'ruby)
      (univ-emit-apply-aux ctx expr params "[" "]")
      (univ-emit-apply-aux ctx expr params "(" ")")))

(define (univ-emit-apply ctx expr params)
  (univ-emit-apply-aux ctx expr params "(" ")"))

(define (univ-emit-apply-aux ctx expr params open close)
  (^ expr
     open
     (univ-separated-list "," params)
     close))

(define (univ-emit-this ctx)
  (case (target-name (ctx-target ctx))

    ((js java go)
     "this") ;; this is a normal identifier in go

    ((php)
     "$this")

    ((python ruby)
     "self")

    (else
     (compiler-internal-error
      "univ-emit-this, unknown target"))))

(define (univ-emit-new ctx type . params)
  (univ-emit-new* ctx (^type (list 'nonptr type)) params))

(define (univ-emit-new* ctx class params)
  (case (target-name (ctx-target ctx))

    ((go)
     (^ "&" (^construct* class params)))

    (else
     (^construct* class params))))

(define (univ-emit-construct ctx type . params)
  (univ-emit-construct* ctx (^type (list 'nonptr type)) params))

(define (univ-emit-construct* ctx class params)
  (case (target-name (ctx-target ctx))

    ((js php java)
     (^parens-php (^ "new " (^apply class params))))

    ((python)
     (^apply class params))

    ((ruby)
     (^apply (^ class ".new") params))

    ((go)
     (^ class "{" (univ-separated-list "," params) "}"))

    (else
     (compiler-internal-error
      "univ-emit-consruct*, unknown target"))))

(define (univ-emit-typeof ctx type expr)
  (case (target-name (ctx-target ctx))

    ((js)
     (^= (^ "typeof " expr) (^str type)))

    (else
     (compiler-internal-error
      "univ-emit-typeof, unknown target"))))

(define (univ-emit-instanceof ctx class expr)
  (case (target-name (ctx-target ctx))

    ((js java)
     (^ expr " instanceof " class))

    ((php)
     ;; PHP raises a syntax error when expr is a constant, so this case
     ;; is handled specially by generating (0?0:expr) which fools the compiler
     (^ (if (univ-box? expr)
            (^if-expr 'int (^int 0) (^int 0) expr)
            expr)
        " instanceof "
        class))

    ((python)
     (^call-prim "isinstance" expr class))

    ((ruby)
     (^ expr ".kind_of?(" class ")"))

    ((go)
     (^ "~~~TODO3:univ-emit-instanceof~~~"))

    (else
     (compiler-internal-error
      "univ-emit-instanceof, unknown target"))))

(define (univ-emit-host-primitive? ctx expr)
  (case (target-name (ctx-target ctx))

    ((python)
     (^ "(type(" expr ") == int or type(" expr ") == float or type(" expr ") == bool or " expr " is None)"))

    ((php)
     (^not
      (^call-prim 'is_object expr)))

    (else
     (compiler-internal-error
      "univ-emit-host-primitive?, unknown target"))))

(define (univ-throw ctx expr)
  (case (target-name (ctx-target ctx))

    ((js php)
     (^ "throw " expr ";\n"))

    ((python)
     (^ "raise Exception(" expr ")\n"))

    ((ruby)
     (^ "raise " expr "\n"))

    ((go)
     (^ "~~~TODO3:univ-throw~~~"))

    (else
     (compiler-internal-error
      "univ-throw, unknown target"))))

(define (univ-fxquotient ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js)
     (^ (^parens (^/ expr1 expr2)) " | 0"))

    ((php)
     (^float-toint (^/ expr1 expr2)))

    ((python ruby)
     (^float-toint (^parens (^/ (^float-fromint expr1) (^float-fromint expr2)))))

    ((java)
     (^/ expr1 expr2))

    ((go)
     (^ "~~~TODO3:univ-fxquotient~~~"))

    (else
     (compiler-internal-error
      "univ-fxquotient, unknown target"))))

(define (univ-fxmodulo ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php java)
     (^ (^parens (^ (^parens (^ expr1 " % " expr2)) " + " expr2)) " % " expr2))

    ((python ruby)
     (^ expr1 " % " expr2))

    ((go)
     (^ "~~~TODO3:univ-fxmodulo~~~"))

    (else
     (compiler-internal-error
      "univ-fxmodulo, unknown target"))))

(define (univ-fxremainder ctx expr1 expr2)
  (case (target-name (ctx-target ctx))

    ((js php java)
     (^ expr1 " % " expr2))

    ((python)
     (^- expr1
         (^* (^call-prim "int" (^/ (^call-prim "float" expr1)
                                   (^call-prim "float" expr2)))
             expr2)))

    ((ruby)
     (^ expr1 ".remainder(" expr2 ")"))

    ((go)
     (^ "~~~TODO3:univ-fxremainder~~~"))

    (else
     (compiler-internal-error
      "univ-fxremainder, unknown target"))))

(define (univ-define-prim
         name
         proc-safe?
         apply-gen
         #!optional
         (ifjump-gen #f)
         (jump-gen #f))
  (let ((prim (univ-prim-info* (string->canonical-symbol name))))

    (if apply-gen
        (begin

          (proc-obj-inlinable?-set!
           prim
           (lambda (env)
             (or proc-safe?
                 (not (safe? env)))))

          (proc-obj-inline-set! prim apply-gen)))

    (if ifjump-gen
        (begin

          (proc-obj-testable?-set!
           prim
           (lambda (env)
             (or proc-safe?
                 (not (safe? env)))))

          (proc-obj-test-set! prim ifjump-gen)))

    (if jump-gen
        (begin

          (proc-obj-jump-inlinable?-set!
           prim
           (lambda (env)
             #t))

          (proc-obj-jump-inline-set!
           prim
           jump-gen)))))

(define (univ-define-prim-bool name proc-safe? ifjump-gen)
  (univ-define-prim
   name
   proc-safe?
   (lambda (ctx return . opnds)
     (apply ifjump-gen
            (cons ctx
                  (cons (lambda (result)
                          (return
                           (^boolean-box
                            (if (or (eq? result #f) (eq? result #t))
                                (^bool result)
                                result))))
                        opnds))))
   ifjump-gen))

;; =============================================================================

;;; Primitive procedures

;; TODO move elsewhere
(define (univ-fold-left
         op0
         op1
         op2
         #!optional
         (unbox (lambda (ctx x) x))
         (box (lambda (ctx x) x)))
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (cond ((null? args)
             (box ctx (op0 ctx)))
            ((null? (cdr args))
             (box ctx (op1 ctx (unbox ctx (car args)))))
            (else
             (let loop ((lst (cddr args))
                        (res (op2 ctx
                                  (unbox ctx (car args))
                                  (unbox ctx (cadr args)))))
               (if (null? lst)
                   (box ctx res)
                   (loop (cdr lst)
                         (op2 ctx
                              (^parens res)
                              (unbox ctx (car lst))))))))))))

(define (univ-fold-left-compare
         op0
         op1
         op2
         #!optional
         (unbox (lambda (ctx x) x))
         (box (lambda (ctx x) x)))
  (make-translated-operand-generator
   (lambda (ctx return . args)
     (return
      (cond ((null? args)
             (box ctx (op0 ctx)))
            ((null? (cdr args))
             (box ctx (op1 ctx (unbox ctx (car args)))))
            (else
             (let loop ((lst (cdr args))
                        (res (op2 ctx
                                  (unbox ctx (car args))
                                  (unbox ctx (cadr args)))))
               (let ((rest (cdr lst)))
                 (if (null? rest)
                     (box ctx res)
                     (loop rest
                           (^&& (^parens res)
                                (op2 ctx
                                     (unbox ctx (car lst))
                                     (unbox ctx (car rest))))))))))))))

(define (make-translated-operand-generator proc)
  (lambda (ctx return opnds)
    (apply proc (cons ctx (cons return (univ-emit-getopnds ctx opnds))))))

;;;============================================================================
