;;============================================================================

;;; File: "_t-univ-2.scm"

;;; Copyright (c) 2011-2017 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2012 by Eric Thivierge, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")
(include-adt "_univadt.scm")

;;----------------------------------------------------------------------------

(define (univ-rtlib-feature ctx feature)

  (define (rts-method
           name
           properties
           result-type
           params
           header
           attribs
           gen-body)
    (univ-add-method
     (univ-make-empty-defs)
     (univ-method
      (^rts-method name)
      properties
      result-type
      params
      attribs
      (univ-emit-fn-body ctx header gen-body))))

  (define (rts-class
           root-name
           #!optional
           (properties '())
           (extends #f)
           (class-fields '())
           (instance-fields '())
           (class-methods '())
           (instance-methods '())
           (class-classes '())
           (constructor #f)
           (inits '()))
    (univ-add-class
     (univ-make-empty-defs)
     (univ-class
      (^rts-class root-name)
      properties
      (and extends
           (or (eq? (target-name (ctx-target ctx)) 'java)
               (not (eq? extends 'scmobj)))
           (^rts-class-use extends))
      class-fields
      instance-fields
      class-methods
      instance-methods
      class-classes
      constructor
      inits)))

  (define (rts-field name type #!optional (init #f) (properties '()))
    (univ-add-field
     (univ-make-empty-defs)
     (univ-field name type init properties)))

  (define (rts-init init)
    (univ-add-init
     (univ-make-empty-defs)
     init))

  (define (continuation-capture-procedure nb-args thread-save?)
    (let ((nb-stacked (max 0 (- nb-args univ-nb-arg-regs))))
      (univ-jumpable-declaration-defs
       ctx
       #t
       (string->symbol
        (string-append
         (if thread-save?
             "thread_save"
             "continuation_capture")
         (number->string nb-args)))
       'entrypt
       '()
       '()
       (univ-emit-fn-body
        ctx
        "\n"
        (lambda (ctx)
          (^ (if (= nb-stacked 0)
                 (^var-declaration
                  'scmobj
                  (^local-var (^ 'arg 1))
                  (^getreg 1))
                 (univ-foldr-range
                  1
                  nb-stacked
                  (^)
                  (lambda (i rest)
                    (^ rest
                       (^pop (lambda (expr)
                               (^var-declaration
                                'scmobj
                                (^local-var (^ 'arg i))
                                expr)))))))

             (^setreg 0
                      (^call-prim
                       (^rts-method-use 'heapify_cont)
                       (^cast* 'returnpt
                               (^getreg 0))))

             (let* ((cont
                     (^new-continuation
                      (^cast* 'frame
                              (^array-index
                               (gvm-state-stack-use ctx 'rd)
                               (^int 0)))
                      (^structure-ref (^rts-field-use 'current_thread)
                                      univ-thread-denv-slot)))
                    (result
                     (if thread-save?
                         (^rts-field-use 'current_thread)
                         cont)))

               (^ (if thread-save?
                      (^structure-set! (^rts-field-use 'current_thread)
                                       univ-thread-cont-slot
                                       cont)
                      (^))

                  (if (= nb-stacked 0)
                      (^setreg 1 result)
                      (univ-foldr-range
                       1
                       nb-stacked
                       (^)
                       (lambda (i rest)
                         (^ (^push (if (= i 1) result (^local-var (^ 'arg i))))
                            rest))))))

             (^setnargs nb-args)

             (^return-jump
              (^cast*-jumpable (^local-var (^ 'arg 1))))))))))

  (define (continuation-graft-no-winding-procedure nb-args thread-restore?)
    (univ-jumpable-declaration-defs
     ctx
     #t
     (string->symbol
      (string-append
       (if thread-restore?
           "thread_restore"
           "continuation_graft_no_winding")
       (number->string nb-args)))
     'entrypt
     '()
     '()
     (univ-emit-fn-body
      ctx
      "\n"
      (lambda (ctx)
        (let* ((nb-stacked
                (max 0 (- nb-args univ-nb-arg-regs)))
               (new-nb-args
                (- nb-args 2))
               (new-nb-stacked
                (max 0 (- new-nb-args univ-nb-arg-regs)))
               (underflow
                (^rts-jumpable-use 'underflow)))
          (^ (univ-foldr-range
              1
              (max 2 (- nb-args univ-nb-arg-regs))
              (^)
              (lambda (i rest)
                (^ rest
                   (^var-declaration
                    'scmobj
                    (^local-var (^ 'arg i))
                    (let ((x (- i nb-stacked)))
                      (if (>= x 1)
                          (^getreg x)
                          (^getstk x)))))))

             (if thread-restore?
                 (^ (^assign (^rts-field-use 'current_thread)
                             (^local-var (^ 'arg 1)))
                    (^assign (^local-var (^ 'arg 1))
                             (^structure-ref (^local-var (^ 'arg 1))
                                             univ-thread-cont-slot)))
                 (^))

             (^assign
              (^array-index
               (gvm-state-stack-use ctx 'rd)
               (^int 0))
              (^member (^cast* 'continuation
                               (^local-var (^ 'arg 1)))
                       'frame))

             (^structure-set! (^rts-field-use 'current_thread)
                              univ-thread-denv-slot
                              (^member (^cast* 'continuation
                                               (^local-var (^ 'arg 1)))
                                       'denv))

             (^assign
              (gvm-state-sp-use ctx 'wr)
              0)

             (^setreg 0 underflow)

             (univ-foldr-range
              1
              new-nb-stacked
              (^)
              (lambda (i rest)
                (^ (^push (^local-var (^ 'arg (+ i 2))))
                   rest)))

             (if (= new-nb-stacked (- nb-stacked 2))
                 (^)
                 (univ-foldr-range
                  (+ new-nb-stacked 1)
                  new-nb-args
                  (^)
                  (lambda (i rest)
                    (^ (^setreg (- i new-nb-stacked)
                                (^getreg (- i (- nb-stacked 2))))
                       rest))))

             (^setnargs new-nb-args)

             (^return
              (^cast*-jumpable (^local-var (^ 'arg 2))))))))))

  (define (continuation-return-no-winding-procedure nb-args)
    (univ-jumpable-declaration-defs
     ctx
     #t
     (string->symbol
      (string-append
       "continuation_return_no_winding"
       (number->string nb-args)))
     'entrypt
     '()
     '()
     (univ-emit-fn-body
      ctx
      "\n"
      (lambda (ctx)
        (let* ((nb-stacked
                (max 0 (- nb-args univ-nb-arg-regs)))
               (underflow
                (^rts-jumpable-use 'underflow))
               (arg1
                (^local-var 'arg1)))
          (^ (^var-declaration
              'continuation
              arg1
              (^cast* 'continuation
                      (let ((x (- 1 nb-stacked)))
                        (if (>= x 1)
                            (^getreg x)
                            (^getstk x)))))

             (^assign
              (^array-index
               (gvm-state-stack-use ctx 'rd)
               (^int 0))
              (^member arg1 'frame))

             (^structure-set! (^rts-field-use 'current_thread)
                              univ-thread-denv-slot
                              (^member arg1 'denv))

             (^assign
              (gvm-state-sp-use ctx 'wr)
              0)

             (^setreg 0 underflow)

             (let ((x (- 2 nb-stacked)))
               (if (= x 1)
                   (^)
                   (^setreg 1 (^getreg x))))

             (^return underflow)))))))

  (define (apply-procedure nb-args)
    (univ-jumpable-declaration-defs
     ctx
     #t
     (string->symbol
      (string-append
       "apply"
       (number->string nb-args)))
     'entrypt
     '()
     '()
     (univ-emit-fn-body
      ctx
      "\n"
      (lambda (ctx)
        (^ (univ-pop-args-to-vars ctx nb-args)

           (univ-foldr-range
            2
            (- nb-args 1)
            (^)
            (lambda (i rest)
              (^ (^push (^local-var (^ 'arg i)))
                 rest)))

           (^setnargs (- nb-args 2))

           (let ((args (^local-var (^ 'arg nb-args))))
             (^while (^pair? args)
                     (^ (^push (^getcar args))
                        (^assign args (^getcdr args))
                        (^inc-by (gvm-state-nargs-use ctx 'rdwr)
                                 1))))

           (univ-pop-args-to-regs ctx 0)

           (^return
            (^cast*-jumpable (^local-var (^ 'arg 1)))))))))

  (case feature

    ((r0 r1 r2 r3 r4)
     (rts-field feature 'scmobj (^null) '(public)))

    ((peps)
     (rts-field
      'peps
      '(dict str parententrypt)
      (^empty-dict '(dict str parententrypt))
      '(public)))

    ((glo)
     (rts-field
      'glo
      '(dict str scmobj)
      (^empty-dict '(dict str scmobj))
      '(public)))

    ((stack)
     (rts-field 'stack '(array scmobj) (univ-emit-make-stack ctx) '(public)))

    ((sp)
     (rts-field 'sp 'int (^int -1) '(public)))

    ((nargs)
     (rts-field 'nargs 'int (^int 0) '(public)))

    ((pollcount)
     (rts-field 'pollcount 'int (^int 100) '(public)))

    ((temp1)
     (rts-field 'temp1 'scmobj (^null) '(public)))

    ((temp2)
     (rts-field 'temp2 'scmobj (^null) '(public)))

    ((inttemp1)
     (rts-field 'inttemp1 'int (^int 0) '(public)))

    ((inttemp2)
     (rts-field 'inttemp2 'int (^int 0) '(public)))

    ((current_thread)
     (rts-field 'current_thread
                'scmobj
                (^structure-box
                 (^array-literal
                  'scmobj
                  (list (^null)   ;; type descriptor (filled in later)
                        (^null)   ;; lock1
                        (^null)   ;; btq-deq-next
                        (^null)   ;; btq-deq-prev
                        (^null)   ;; btq-color
                        (^null)   ;; btq-parent
                        (^null)   ;; btq-left
                        (^null)   ;; btq-leftmost
                        (^null)   ;; tgroup
                        (^null)   ;; lock2
                        (^null)   ;; toq-color
                        (^null)   ;; toq-parent
                        (^null)   ;; toq-left
                        (^null)   ;; toq-leftmost
                        (^null)   ;; threads-deq-next
                        (^null)   ;; threads-deq-prev
                        (^null)   ;; floats
                        (^null)   ;; name
                        (^null)   ;; end-condvar
                        (^null)   ;; exception?
                        (^null)   ;; result
                        (^null)   ;; cont
                        (^obj '()) ;; denv
                        (^null)   ;; denv-cache1
                        (^null)   ;; denv-cache2
                        (^null)   ;; denv-cache3
                        (^null)   ;; repl-channel
                        (^null)   ;; mailbox
                        (^null)   ;; specific
                        (^null)   ;; resume-thunk
                        (^null)   ;; interrupts
                        )))
                '(public)))

    ((trampoline)
     (rts-method
      'trampoline
      '(public)
      'noresult
      (list (univ-field 'pc 'jumpable))
      "\n"
      '()
      (lambda (ctx)
        (let ((pc (^local-var 'pc)))
          (^while (^!= pc (^null)) ;; exit trampoline?
                  (^assign pc
                           (^jump pc)))))))

    ((module_registry_init)
     (rts-method
      'module_registry_init
      '(public)
      'noresult
      (list (univ-field 'link_info '(array modlinkinfo)))
      "\n"
      '()
      (lambda (ctx)
        (let ((link_info (^local-var 'link_info))
              (n (^local-var 'n))
              (i (^local-var 'i))
              (info (^local-var 'info)))

          (^ (^var-declaration
              'int
              n
              (^array-length link_info))

             (^var-declaration
              'int
              i
              (^int 0))

             (^assign (^rts-field-use 'module_table)
                      (^new-array 'scmobj n))

             (^while (^< i n)

                     (^ (^var-declaration
                         'modlinkinfo
                         info
                         (^array-index link_info i))

                        (^dict-set (^rts-field-use 'module_map)
                                   (^member info 'name)
                                   info)

                        (^assign (^array-index (^rts-field-use 'module_table) i)
                                 (^null))

                        (^inc-by i 1))))))))

    ((module_register)
     (rts-method
      'module_register
      '(public)
      'noresult
      (list (univ-field 'module_descr 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((module_descr (^local-var 'module_descr))
              (name (^local-var 'name))
              (info (^local-var 'info))
              (index (^local-var 'index))
              (old (^local-var 'old)))

          (define (run mod-descr)
            (^ (^assign (gvm-state-sp-use ctx 'wr)
                        (^int -1))

               (^push (univ-end-of-cont-marker ctx))

               (^assign (^rts-field-use 'r0)
                        (^rts-jumpable-use 'underflow))

               (^assign (^rts-field-use 'nargs)
                        (^int 0))

               (^expr-statement
                (^call-prim
                 (^rts-method-use 'trampoline)
                 (^cast*-jumpable
                  (^vector-ref mod-descr (^int 1)))))))

          (^ (^var-declaration
              'str
              name
              (^symbol-unbox (^vector-ref module_descr (^int 0))))

             (^var-declaration
              'modlinkinfo
              info
              (^dict-get (^rts-field-use 'module_map)
                         name
                         (^null)))

             (^if (^null? info)

                  (run module_descr)

                  (^ (^var-declaration
                      'int
                      index
                      (^member info 'index))

                     (^var-declaration
                      'scmobj
                      old
                      (^array-index (^rts-field-use 'module_table) index))

                     (^assign (^array-index (^rts-field-use 'module_table)
                                            index)
                              module_descr)

                     (^if (^null? old)

                          (^ (^inc-by (^rts-field-use 'module_count)
                                      1)

                             (^if (^= (^rts-field-use 'module_count)
                                      (^array-length (^rts-field-use 'module_table)))
                                  (^ (^setglo '##program-descr
                                              (^vector-box
                                               (^array-literal
                                                'scmobj
                                                (list (^vector-box
                                                       (^rts-field-use 'module_table))
                                                      (^obj '())
                                                      (^obj #f)))))

                                     (^setglo '##vm-main-module-id
                                              (^vector-ref
                                               (^array-index
                                                (^rts-field-use 'module_table)
                                                (^- (^array-length (^rts-field-use 'module_table))
                                                    (^int 1)))
                                               (^int 0)))

                                     (run (^array-index
                                           (^rts-field-use 'module_table)
                                           (^int 0))))))))))))))

    ((modlinkinfo)
     (rts-class
      'modlinkinfo
      '() ;; properties
      #f ;; extends
      '() ;; class-fields
      (list (univ-field 'name 'str #f '(public)) ;; instance-fields
            (univ-field 'index 'int #f '(public)))))

    ((module_map)
     (rts-field
      'module_map
      '(dict str modlinkinfo)
      (^empty-dict '(dict str modlinkinfo))))

    ((module_count)
     (rts-field
      'module_count
      'int
      (^int 0)))

    ((module_table)
     (rts-field
      'module_table
      '(array scmobj)
      (^null)))

    ((heapify_cont)
     (rts-method
      'heapify_cont
      '(public)
      'returnpt
      (list (univ-field 'ra 'returnpt))
      "\n"
      '()
      (lambda (ctx)
        (let ((ra (^local-var 'ra))
              (fs (^local-var 'fs))
              (link (^local-var 'link))
              (base (^local-var 'base))
              (frame (^local-var 'frame))
              (prev_link (^local-var 'prev_link))
              (prev_frame (^local-var 'prev_frame))
              (chain (^local-var 'chain)))
          (^ (^if (^> (gvm-state-sp-use ctx 'rd) 0)
                  (univ-with-ctrlpt-attribs
                   ctx
                   #f
                   ra
                   (lambda ()

                     (^ (^var-declaration
                         'int
                         fs
                         (univ-get-ctrlpt-attrib ctx ra 'fs))

                        (^var-declaration
                         'int
                         link
                         (univ-get-ctrlpt-attrib ctx ra 'link))

                        (^var-declaration
                         'int
                         base
                         (^- (gvm-state-sp-use ctx 'rd) fs))

                        (^extensible-array-to-array!
                         (gvm-state-stack-use ctx 'rdwr)
                         (^+ (gvm-state-sp-use ctx 'rd) 1))

                        (^var-declaration
                         'frame
                         chain)

                        (^if (^> base 0)

                             (^ (^assign chain
                                         (^frame-box
                                          (^subarray
                                           (gvm-state-stack-use ctx 'rd)
                                           base
                                           (^+ fs 1))))

                                (^assign (^array-index
                                          (^frame-slots chain)
                                          (^int 0))
                                         ra)

                                (^assign (gvm-state-sp-use ctx 'wr)
                                         base)

                                (^var-declaration
                                 'frame
                                 prev_frame
                                 (^alias chain))

                                (^var-declaration
                                 'int
                                 prev_link
                                 link)

                                (^assign ra
                                         (^cast* 'returnpt
                                                 (^array-index
                                                  (^frame-slots prev_frame)
                                                  prev_link)))

                                (univ-with-ctrlpt-attribs
                                 ctx
                                 #t
                                 ra
                                 (lambda ()

                                   (^ (^assign
                                       fs
                                       (univ-get-ctrlpt-attrib ctx ra 'fs))

                                      (^assign
                                       link
                                       (univ-get-ctrlpt-attrib ctx ra 'link))

                                      (^assign
                                       base
                                       (^- (gvm-state-sp-use ctx 'rd)
                                           fs))

                                      (^while (^> base 0)
                                              (^ (^var-declaration
                                                  'frame
                                                  frame
                                                  (^frame-box
                                                   (^subarray
                                                    (gvm-state-stack-use ctx 'rd)
                                                    base
                                                    (^+ fs 1))))

                                                 (^assign
                                                  (^array-index
                                                   (^frame-unbox frame)
                                                   (^int 0))
                                                  ra)

                                                 (^assign
                                                  (gvm-state-sp-use ctx 'wr)
                                                  base)

                                                 (^assign
                                                  (^array-index
                                                   (^frame-slots prev_frame)
                                                   prev_link)
                                                  (^alias frame))

                                                 (^assign
                                                  prev_frame
                                                  (^alias frame))

                                                 (^unalias frame)

                                                 (^assign
                                                  prev_link
                                                  link)

                                                 (^assign
                                                  ra
                                                  (^cast* 'returnpt
                                                          (^array-index
                                                           (^frame-slots prev_frame)
                                                           prev_link)))

                                                 (univ-with-ctrlpt-attribs
                                                  ctx
                                                  #t
                                                  ra
                                                  (lambda ()

                                                    (^ (^assign
                                                        fs
                                                        (univ-get-ctrlpt-attrib ctx ra 'fs))

                                                       (^assign
                                                        link
                                                        (univ-get-ctrlpt-attrib ctx ra 'link))

                                                       (^assign
                                                        base
                                                        (^- (gvm-state-sp-use ctx 'rd)
                                                            fs)))))))

                                      (^assign
                                       (^array-index
                                        (gvm-state-stack-use ctx 'rd)
                                        link)
                                       (^array-index
                                        (gvm-state-stack-use ctx 'rd)
                                        (^int 0)))

                                      (^assign
                                       (^array-index
                                        (gvm-state-stack-use ctx 'rd)
                                        (^int 0))
                                       ra)

                                      (^assign
                                       (^array-index
                                        (^frame-slots prev_frame)
                                        prev_link)
                                       (^frame-box
                                        (^array-shrink-possibly-copy!
                                         (gvm-state-stack-use ctx 'rd)
                                         (^+ fs 1))))))))

                             (^ (^assign
                                 (^array-index
                                  (gvm-state-stack-use ctx 'rd)
                                  link)
                                 (^array-index
                                  (gvm-state-stack-use ctx 'rd)
                                  (^int 0)))

                                (^assign
                                 (^array-index
                                  (gvm-state-stack-use ctx 'rd)
                                  (^int 0))
                                 ra)

                                (^assign
                                 chain
                                 (^frame-box
                                  (^array-shrink-possibly-copy!
                                   (gvm-state-stack-use ctx 'rd)
                                   (^+ fs 1))))))

                        (if (univ-stack-resizable? ctx)

                            (^assign
                             (gvm-state-stack-use ctx 'rd)
                             (^extensible-array-literal
                              'scmobj
                              (list chain)))

                            (^assign
                             (^array-index
                              (gvm-state-stack-use ctx 'rd)
                              (^int 0))
                             chain))

                        (^assign
                         (gvm-state-sp-use ctx 'wr)
                         0)))))

             (^return
              (^rts-jumpable-use 'underflow)))))))

    ((underflow)
     (univ-jumpable-declaration-defs
      ctx
      #t
      'underflow
      'returnpt
      '()
      (list (univ-field 'id 'int (^int 0) '(inherited))
            (univ-field 'parent 'parententrypt (^null) '(inherited))
            (univ-field 'fs 'int (^int 0) '(inherited))
            (univ-field 'link 'int (^int 0) '(inherited)))
      (univ-emit-fn-body
       ctx
       "\n"
       (lambda (ctx)
         (let ((nextf (^local-var 'nextf))
               (frame (^local-var 'frame))
               (ra (^local-var 'ra))
               (fs (^local-var 'fs))
               (link (^local-var 'link)))

           (^ (^var-declaration
               'scmobj
               nextf
               (^array-index
                (gvm-state-stack-use ctx 'rd)
                (^int 0)))

              (^if (^eq? nextf (univ-end-of-cont-marker ctx))
                   (^return (^null))) ;; exit trampoline

              (^var-declaration
               'frm
               frame
               (^frame-unbox nextf))

              (^var-declaration
               'returnpt
               ra
               (^cast* 'returnpt
                       (^array-index frame (^int 0))))

              (univ-with-ctrlpt-attribs
               ctx
               #f
               ra
               (lambda ()

                 (^ (^var-declaration
                     'int
                     fs
                     (univ-get-ctrlpt-attrib ctx ra 'fs))

                    (^var-declaration
                     'int
                     link
                     (univ-get-ctrlpt-attrib ctx ra 'link))

                    (if (univ-stack-resizable? ctx)

                        (^assign (gvm-state-stack-use ctx 'wr)
                                 (^copy-array-to-extensible-array
                                  frame
                                  (^+ fs 1)))

                        (^move-array-to-array
                         frame
                         (^int 0)
                         (gvm-state-stack-use ctx 'rd)
                         (^int 0)
                         (^+ fs 1)))

                    (^assign (gvm-state-sp-use ctx 'wr)
                             fs)

                    (^assign (^array-index
                              (gvm-state-stack-use ctx 'rd)
                              (^int 0))
                             (^alias
                              (^array-index frame link)))

                    (^assign (^array-index
                              (gvm-state-stack-use ctx 'rd)
                              link)
                             (^rts-jumpable-use 'underflow)))))

              (^return ra)))))))

    ((continuation_capture1)
     (continuation-capture-procedure 1 #f))

    ((continuation_capture2)
     (continuation-capture-procedure 2 #f))

    ((continuation_capture3)
     (continuation-capture-procedure 3 #f))

    ((continuation_capture4)
     (continuation-capture-procedure 4 #f))

    ((thread_save1)
     (continuation-capture-procedure 1 #t))

    ((thread_save2)
     (continuation-capture-procedure 2 #t))

    ((thread_save3)
     (continuation-capture-procedure 3 #t))

    ((thread_save4)
     (continuation-capture-procedure 4 #t))

    ((continuation_graft_no_winding2)
     (continuation-graft-no-winding-procedure 2 #f))

    ((continuation_graft_no_winding3)
     (continuation-graft-no-winding-procedure 3 #f))

    ((continuation_graft_no_winding4)
     (continuation-graft-no-winding-procedure 4 #f))

    ((continuation_graft_no_winding5)
     (continuation-graft-no-winding-procedure 5 #f))

    ((thread_restore2)
     (continuation-graft-no-winding-procedure 2 #t))

    ((thread_restore3)
     (continuation-graft-no-winding-procedure 3 #t))

    ((thread_restore4)
     (continuation-graft-no-winding-procedure 4 #t))

    ((thread_restore5)
     (continuation-graft-no-winding-procedure 5 #t))

    ((continuation_return_no_winding2)
     (continuation-return-no-winding-procedure 2))

    ((poll)
     (rts-method
      'poll
      '(public)
      'jumpable
      (list (univ-field 'dest 'jumpable))
      "\n"
      '()
      (lambda (ctx)
        (let ((dest (^local-var 'dest)))
          (^ (^assign (gvm-state-pollcount-use ctx 'wr)
                      100)
             (if (and (univ-stack-resizable? ctx)
                      (not (eq? (target-name (ctx-target ctx)) 'python))) ;; TODO : find an efficient way to shrink the stack in python
                 (^array-shrink! (^rts-field-use 'stack) (^+ (^rts-field-use 'sp) (^int 1)))
                 (^))
             (^return dest))))))

    ((build_rest)
     (rts-method
      'build_rest
      '(public)
      'bool
      (list (univ-field 'nrp 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((rest (^local-var 'rest))
              (nrp (^local-var 'nrp)))
          (^ (^var-declaration 'scmobj rest (^null-obj))
             (^if (^< (^getnargs)
                      nrp)
                  (^return (^bool #f)))
             (univ-push-args ctx)
             (^while (^> (^getnargs)
                         nrp)
                     (^ (^pop (lambda (expr)
                                (^assign rest
                                         (^cons expr
                                                rest))))
                        (^inc-by (gvm-state-nargs-use ctx 'rdwr)
                                 -1)))
             (^push rest)
             (univ-pop-args-to-regs ctx 1)
             (^return (^bool #t)))))))

    ((wrong_nargs)
     (rts-method
      'wrong_nargs
      '(public)
      'jumpable
      (list (univ-field 'proc 'jumpable))
      "\n"
      '()
      (lambda (ctx)
        (let ((proc (^local-var 'proc)))
          (^ (^expr-statement
              (^call-prim
               (^rts-method-use 'build_rest)
               0))
             (^setreg 2 (^getreg 1))
             (^setreg 1 proc)
             (^setnargs 2)
             (^return
              (^cast*-jumpable
               (^getglo '##raise-wrong-number-of-arguments-exception))))))))

    ((get)
#<<EOF
function gambit_get($obj,$name) {
  return $obj[$name];
}

EOF
)

    ((set)
#<<EOF
function gambit_set(&$obj,$name,$val) {
  $obj[$name] = $val;
}

EOF
)

    ((prepend_arg1)
     (rts-method
      'prepend_arg1
      '(public)
      'noresult
      (list (univ-field 'arg1 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((arg1 (^local-var 'arg1))
              (i (^local-var 'i)))
          (^ (^var-declaration 'int i (^int 0))
             (univ-push-args ctx)
             (^push (^null))
             (^while (^< i (^getnargs))
                     (^ (^assign (univ-stk-slot-from-tos ctx i)
                                 (univ-stk-slot-from-tos ctx (^parens (^+ i (^int 1)))))
                        (^inc-by i
                                 1)))
             (^assign (univ-stk-slot-from-tos ctx i)
                      arg1)
             (^inc-by (gvm-state-nargs-use ctx 'rdwr)
                      1)
             (univ-pop-args-to-regs ctx 0))))))

    ((check_procedure_glo)
     (rts-method
      'check_procedure_glo
      '(public)
      'jumpable
      (list (univ-field 'dest 'scmobj)
            (univ-field 'gv 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((dest (^local-var 'dest))
              (gv (^local-var 'gv)))
          (^ (^if (^not (^parens (^procedure? dest)))
                  (^ (^expr-statement
                      (^call-prim
                       (^rts-method-use 'prepend_arg1)
                       gv))
                     (^assign dest
                              (^getglo '##apply-global-with-procedure-check-nary))))
             (^return (^cast*-jumpable dest)))))))

    ((check_procedure)
     (rts-method
      'check_procedure
      '(public)
      'jumpable
      (list (univ-field 'dest 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((dest (^local-var 'dest)))
          (^ (^if (^not (^parens (^procedure? dest)))
                  (^ (^expr-statement
                      (^call-prim
                       (^rts-method-use 'prepend_arg1)
                       dest))
                     (^assign dest
                              (^getglo '##apply-with-procedure-check-nary))))
             (^return dest))))))

    ((make_subprocedure)
     (rts-method
      'make_subprocedure
      '(public)
      'ctrlpt
      (list (univ-field 'parent 'parententrypt)
            (univ-field 'id 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((parent (^local-var 'parent))
              (id (^local-var 'id)))
          (univ-with-ctrlpt-attribs
           ctx
           #f
           parent
           (lambda ()
             (^return
              (univ-ctrlpt-reference-to-ctrlpt
               ctx
               (^array-index (univ-get-ctrlpt-attrib ctx parent 'ctrlpts)
                             id)))))))))

    ((scmobj)
     (rts-class
      'scmobj
      '(abstract))) ;; properties

    ((jumpable)
     (rts-class
      'jumpable
      '(abstract) ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      '() ;; instance-fields
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        'jump
        '(public)
        'jumpable
        '()))))

    ((ctrlpt)
     (rts-class
      'ctrlpt
      '(abstract) ;; properties
      'jumpable ;; extends
      '() ;; class-fields
      (list (univ-field 'id 'int #f '(public)) ;; instance-fields
            (univ-field 'parent 'parententrypt #f '(public)))))

    ((returnpt)
     (rts-class
      'returnpt
      '(abstract) ;; properties
      'ctrlpt ;; extends
      '() ;; class-fields
      (list (univ-field 'id 'int #f '(public inherited)) ;; instance-fields
            (univ-field 'parent 'parententrypt #f '(public inherited))
            (univ-field 'fs 'int #f '(public))
            (univ-field 'link 'int #f '(public)))))

    ((entrypt)
     (rts-class
      'entrypt
      '(abstract) ;; properties
      'ctrlpt ;; extends
      '() ;; class-fields
      (list (univ-field 'id 'int #f '(public inherited)) ;; instance-fields
            (univ-field 'parent 'parententrypt #f '(public inherited))
            (univ-field 'nfree 'int #f '(public)))))

    ((parententrypt)
     (rts-class
      'parententrypt
      '(abstract) ;; properties
      'entrypt ;; extends
      '() ;; class-fields
      (list (univ-field 'id 'int #f '(public inherited)) ;; instance-fields
            (univ-field 'parent 'parententrypt #f '(public inherited))
            (univ-field 'nfree 'int #f '(public inherited))
            (univ-field (univ-proc-name-attrib ctx) 'symbol #f '(public))
            (univ-field 'ctrlpts '(array ctrlpt) #f '(public))
            (univ-field 'info 'scmobj #f '(public)))))

    ((closure)
     (rts-class
      'closure
      '() ;; properties
      (if (eq? (univ-procedure-representation ctx) 'class) ;; extends
          'jumpable
          'scmobj) ;; for PHP when using repr-procedure = host
      '() ;; class-fields
      (list (univ-field 'slots '(array scmobj) #f '(public))) ;; instance-fields
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (if (eq? (univ-procedure-representation ctx) 'class)
            'jump
            '__invoke) ;; for PHP when using repr-procedure = host
        '(public)
        'jumpable
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (lambda (ctx)
           (^ (^setreg (+ univ-nb-arg-regs 1) (^this))
              (^return
               (^cast*-jumpable
                (^array-index (^member (^this) 'slots) (^int 0)))))))))))

    ((closure_alloc)
     (let ()

       (define (class-based-closure-alloc-method)
         (rts-method
          'closure_alloc
          '(public)
          'closure
          (list (univ-field 'slots '(array scmobj)))
          "\n"
          '()
          (lambda (ctx)
            (let ((slots (^local-var 'slots)))
              (^return (^new (^type 'closure)
                             slots))))))

       (case (univ-procedure-representation ctx)

         ((class)
          (class-based-closure-alloc-method))

         (else
          (case (target-name (ctx-target ctx))

            ((php)
             (class-based-closure-alloc-method))

            (else
             (rts-method
              'closure_alloc
              '(public)
              'scmobj
              (list (univ-field 'slots 'scmobj))
              "\n"
              '()
              (lambda (ctx)
                (let ((msg (^local-var 'msg))
                      (slots (^local-var 'slots))
                      (closure 'closure))
                  (^ (^procedure-declaration
                      #f
                      'closure
                      closure
                      (list (univ-field 'msg 'bool (^bool #t)))
                      "\n"
                      '()
                      (^ (^if (^= msg (^bool #t))
                              (^return slots))
                         (^setreg (+ univ-nb-arg-regs 1) (^prefix closure))
                         (^return (^array-index slots (^int 0)))))
                     (^return (^prefix closure))))))))))))

    ((make_closure)
     (rts-method
      'make_closure
      '(public)
      'scmobj
      (list (univ-field 'code 'ctrlpt)
            (univ-field 'leng 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((code (^local-var 'code))
              (leng (^local-var 'leng))
              (slots (^local-var 'slots)))
          (^ (^var-declaration
              '(array scmobj)
              slots
              (^new-array 'scmobj (^+ leng (^int 1))))
             (^assign (^array-index slots (^int 0)) code)
             (^return
              (^call-prim
               (^rts-method-use 'closure_alloc)
               slots)))))))

    ((promise)
     (rts-class
      'promise
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'thunk 'scmobj #f '(public)) ;; instance-fields
            (univ-field 'result 'scmobj (^this) '(public)))))

    ((will)
     (rts-class
      'will
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'testator 'scmobj #f '(public)) ;; instance-fields
            (univ-field 'action 'scmobj #f '(public)))))

    ((foreign)
     (rts-class
      'foreign
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'val 'object #f '(public)) ;; instance-fields
            (univ-field 'tags 'scmobj #f '(public)))))

    ((fixnum)
     (rts-class
      'fixnum
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'val 'int #f '(public))) ;; instance-fields
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (univ-tostr-method-name ctx)
        '(public)
        'str
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (let ((val (^member (^this) 'val)))
           (case (target-name (ctx-target ctx))

             ((js php python ruby)
              (lambda (ctx)
                (^return (^tostr val))))

             ((java)
              (lambda (ctx)
                (^return (^call-prim (^member 'String 'valueOf) val))))

             (else
              (compiler-internal-error
               "univ-rtlib-feature fixnum, unknown target")))))))))

    ((make_fixnum)
     (rts-method
      'make_fixnum
      '(public)
      'fixnum
      (list (univ-field 'n 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n)))
          (^if (^&& (^>= n (^int 0))
                    (^< n (^int 257)))
               (^return (^array-index (^rts-field-use 'fixnum_table) n))
               (^return (^new (^type 'fixnum) n)))))))

    ((fixnum_table)
     (rts-field
      'fixnum_table
      '(array fixnum)
      (^call-prim (^rts-method-use 'make_fixnum_table))))

    ((make_fixnum_table)
     (rts-method
      'make_fixnum_table
      '()
      '(array fixnum)
      '()
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n))
              (tab (^local-var 'tab)))
          (^ (^var-declaration
              '(array fixnum)
              tab
              (^new-array 'fixnum
                          (^int (+ (- (univ-max-memoized-fixnum ctx)
                                      (univ-min-memoized-fixnum ctx))
                                   1))))
             (^var-declaration
              'int
              n
              (^int (univ-min-memoized-fixnum ctx)))
             (^while (^<= n (^int (univ-max-memoized-fixnum ctx)))
                     (^ (^assign (^array-index tab n)
                                 (^new (^type 'fixnum)
                                       (^+ (^int (univ-min-memoized-fixnum ctx)) n)))
                        (^inc-by n 1)))
             (^return tab))))))

    ((flonum)
     (rts-class
      'flonum
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'val 'f64 #f '(public))) ;; instance-fields
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (univ-tostr-method-name ctx)
        '(public)
        'str
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (let ((val (^member (^this) 'val)))
           (case (target-name (ctx-target ctx))

             ((js php python ruby)
              (lambda (ctx)
                (^return (^tostr val))))

             ((java)
              (lambda (ctx)
                (^return (^call-prim (^member 'String 'valueOf) val))))

             (else
              (compiler-internal-error
               "univ-rtlib-feature flonum, unknown target")))))))))

    ((bignum)
     (rts-class
      'bignum
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'digits '(array bigdigit) #f '(public))))) ;; instance-fields

    ((bitcount)
     (rts-method
      'bitcount
      '(public)
      'int
      (list (univ-field 'n 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n)))
          (^ (^assign n (^+ (^parens (^bitand n
                                              (^int #x55555555)))
                            (^parens (^bitand (^parens (^>> n (^int 1)))
                                              (^int #x55555555)))))
             (^assign n (^+ (^parens (^bitand n
                                              (^int #x33333333)))
                            (^parens (^bitand (^parens (^>> n (^int 2)))
                                              (^int #x33333333)))))
             (^assign n (^bitand (^parens (^+ n (^parens (^>> n (^int 4)))))
                                 (^int #x0f0f0f0f)))
             (^assign n (^+ n (^parens (^>> n (^int 8)))))
             (^assign n (^+ n (^parens (^>> n (^int 16)))))
             (^return (^bitand n (^int #xff))))))))

    ((intlength)
     (rts-method
      'intlength
      '(public)
      'int
      (list (univ-field 'n 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n)))
          (^ (^if (^< n (^int 0)) (^assign n (^bitnot n)))
             (^assign n (^bitior n (^parens (^>> n 1))))
             (^assign n (^bitior n (^parens (^>> n 2))))
             (^assign n (^bitior n (^parens (^>> n 4))))
             (^assign n (^bitior n (^parens (^>> n 8))))
             (^assign n (^bitior n (^parens (^>> n 16))))
             (^return (^call-prim
                       (^rts-method-use 'bitcount)
                       n)))))))

    ((bignum_make)
     (rts-method
      'bignum_make
      '(public)
      'scmobj
      (list (univ-field 'n 'int)
            (univ-field 'x 'scmobj)
            (univ-field 'complement 'bool))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n))
              (x (^local-var 'x))
              (complement (^local-var 'complement))
              (flip (^local-var 'flip))
              (nbdig (^local-var 'nbdig))
              (digits (^local-var 'digits))
              (i (^local-var 'i)))
          (^ (^var-declaration
              'int
              i
              (^int 0))
             (^var-declaration
              '(array bigdigit)
              digits
              (^new-array 'bigdigit n))
             (^var-declaration
              'int
              nbdig
              (^if-expr
               (^eq? x (^obj #f))
               (^int 0)
               (^array-length (^bignum-digits x))))
             (^var-declaration
              'bigdigit
              flip
              (^cast* 'bigdigit
                      (^if-expr complement (^int 16383) (^int 0))))
             (^if (^< n nbdig)
                  (^assign nbdig n))
             (^while (^< i nbdig)
                     (^ (^assign (^array-index digits i)
                                 (^cast* 'bigdigit
                                         (^bitxor (^array-index (^bignum-digits x) i)
                                                  flip)))
                        (^inc-by i 1)))
             (^if (^and (^not (^parens (^eq? x (^obj #f))))
                        (^> (^array-index (^bignum-digits x) (^- i (^int 1)))
                            (^int 8191)))
                  (^assign flip
                           (^cast* 'bigdigit
                                   (^bitxor flip (^int 16383)))))
             (^while (^< i n)
                     (^ (^assign (^array-index digits i)
                                 flip)
                        (^inc-by i 1)))
             (^return
              (^new (^type 'bignum)
                    digits)))))))

    ((bignum_from_s32)
     (rts-method
      'bignum_from_s32
      '(public)
      'scmobj
      (list (univ-field 'n 's32))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n))
              (m (^local-var 'm))
              (nbdig (^local-var 'nbdig))
              (digits (^local-var 'digits))
              (i (^local-var 'i)))
          (^ (^var-declaration
              's32
              m
              n)
             (^var-declaration
              'int
              nbdig
              (^int 0))
             (^while (^or (^< m (^int -4096))
                          (^> m (^int 4095)))
                     (^ (^assign m (^>> m (^int 14)))
                        (^inc-by nbdig 1)))
             (^inc-by nbdig 1)
             (^var-declaration
              '(array bigdigit)
              digits
              (^new-array 'bigdigit nbdig))
             (^var-declaration
              'int
              i
              (^int 0))
             (^while (^< i nbdig)
                     (^ (^assign (^array-index digits i)
                                 (^cast* 'bigdigit
                                         (^bitand n (^int 16383))))
                        (^assign n
                                 (^>> n (^int 14)))
                        (^inc-by i 1)))
             (^return
              (^new (^type 'bignum)
                    digits)))))))

    ((bignum_from_u32)
     (rts-method
      'bignum_from_u32
      '(public)
      'scmobj
      (list (univ-field 'n 'u32))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n))
              (m (^local-var 'm))
              (nbdig (^local-var 'nbdig))
              (digits (^local-var 'digits))
              (i (^local-var 'i)))
          (^ (^var-declaration
              'u32
              m
              n)
             (^var-declaration
              'int
              nbdig
              (^int 0))
             (^while (^!= m (^int 0))
                     (^ (^assign m (^>>> m (^int 14)))
                        (^inc-by nbdig 1)))
             (^if (^= nbdig (^int 0))
                  (^assign nbdig (^int 1)))
             (^var-declaration
              '(array bigdigit)
              digits
              (^new-array 'bigdigit nbdig))
             (^var-declaration
              'int
              i
              (^int 0))
             (^while (^< i nbdig)
                     (^ (^assign (^array-index digits i)
                                 (^cast* 'bigdigit
                                         (^bitand n (^int 16383))))
                        (^assign n
                                 (^>>> n (^int 14)))
                        (^inc-by i 1)))
             (^return
              (^new (^type 'bignum)
                    digits)))))))

    ((bignum_to_s32)
     (rts-method
      'bignum_to_s32
      '(public)
      's32
      (list (univ-field 'n 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n))
              (nbdig (^local-var 'nbdig))
              (digits (^local-var 'digits))
              (i (^local-var 'i))
              (result (^local-var 'result)))
          (^ (^var-declaration
              '(array bigdigit)
              digits
              (^bignum-digits n))
             (^var-declaration
              'int
              nbdig
              (^array-length digits))
             (^var-declaration
              'int
              i
              (^- nbdig (^int 1)))
             (^var-declaration
              's32
              result
              (^array-index digits i))
             (^if (^> result 8191)
                  (^assign result
                           (^inc-by i -16384)))
             (^while (^> i 0)
                     (^ (^inc-by i -1)
                        (^assign result
                                 (^+ (^* result (^int 16384))
                                     (^array-index digits i)))))
             (^return
              result))))))

    ((bignum_to_u32)
     (rts-method
      'bignum_to_u32
      '(public)
      'u32
      (list (univ-field 'n 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n))
              (nbdig (^local-var 'nbdig))
              (digits (^local-var 'digits))
              (i (^local-var 'i))
              (result (^local-var 'result)))
          (^ (^var-declaration
              '(array bigdigit)
              digits
              (^bignum-digits n))
             (^var-declaration
              'int
              nbdig
              (^array-length digits))
             (^var-declaration
              'int
              i
              (^- nbdig (^int 1)))
             (^var-declaration
              'u32
              result
              (^int 0))
             (^while (^>= i 0)
                     (^ (^assign result
                                 (^+ (^* result (^int 16384))
                                     (^array-index digits i)))
                        (^inc-by i -1)))
             (^return
              result))))))

    ((u32_box)
     (rts-method
      'u32_box
      '(public)
      'scmobj
      (list (univ-field 'n 'u32))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n)))
          (^if (^and (^<= (^int 0) n)
                     (^<= n (^int univ-fixnum-max)))
               (^return
                (^fixnum-box n))
               (^return
                (^call-prim
                 (^rts-method-use 'bignum_from_u32)
                 n)))))))

    ((u32_unbox)
     (rts-method
      'u32_unbox
      '(public)
      'u32
      (list (univ-field 'n 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n)))
          (^if (^fixnum? n)
               (^return
                (^fixnum-unbox n))
               (^return
                (^call-prim
                 (^rts-method-use 'bignum_to_u32)
                 n)))))))

    ((s32_box)
     (rts-method
      's32_box
      '(public)
      'scmobj
      (list (univ-field 'n 's32))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n)))
          (^if (^and (^<= (^int univ-fixnum-min) n)
                     (^<= n (^int univ-fixnum-max)))
               (^return
                (^fixnum-box n))
               (^return
                (^call-prim
                 (^rts-method-use 'bignum_from_s32)
                 n)))))))

    ((s32_unbox)
     (rts-method
      's32_unbox
      '(public)
      's32
      (list (univ-field 'n 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((n (^local-var 'n)))
          (^if (^fixnum? n)
               (^return
                (^fixnum-unbox n))
               (^return
                (^call-prim
                 (^rts-method-use 'bignum_to_s32)
                 n)))))))

    ((ratnum)
     (rts-class
      'ratnum
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'num 'scmobj #f '(public)) ;; instance-fields
            (univ-field 'den 'scmobj #f '(public)))))

    ((cpxnum)
     (rts-class
      'cpxnum
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'real 'scmobj #f '(public)) ;; instance-fields
            (univ-field 'imag 'scmobj #f '(public)))))

    ((pair)
     (rts-class
      'pair
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'car 'scmobj #f '(public)) ;; instance-fields
            (univ-field 'cdr 'scmobj #f '(public)))))

    ((vector)
     (rts-class
      'vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array scmobj) #f '(public))))) ;; instance-fields

    ((u8vector)
     (rts-class
      'u8vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array u8) #f '(public))))) ;; instance-fields

    ((u16vector)
     (rts-class
      'u16vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array u16) #f '(public))))) ;; instance-fields

    ((u32vector)
     (rts-class
      'u32vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array u32) #f '(public))))) ;; instance-fields

    ((u64vector)
     (rts-class
      'u64vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array u64) #f '(public))))) ;; instance-fields

    ((s8vector)
     (rts-class
      's8vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array s8) #f '(public))))) ;; instance-fields

    ((s16vector)
     (rts-class
      's16vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array s16) #f '(public))))) ;; instance-fields

    ((s32vector)
     (rts-class
      's32vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array s32) #f '(public))))) ;; instance-fields

    ((s64vector)
     (rts-class
      's64vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array s64) #f '(public))))) ;; instance-fields

    ((f32vector)
     (rts-class
      'f32vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array f32) #f '(public))))) ;; instance-fields

    ((f64vector)
     (rts-class
      'f64vector
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'elems '(array f64) #f '(public))))) ;; instance-fields

    ((structure)
     (rts-class
      'structure
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'slots '(array scmobj) #f '(public))) ;; instance-fields
      '() ;; class-methods
      '() ;; instance-methods
      '() ;; class-classes
      (lambda (ctx) ;; constructor
        ;; correctly construct type descriptor of type descriptors
        (let ((slots (^local-var (univ-field-param ctx 'slots))))
          (^if (^null? (^array-index slots (^int 0)))
               (^assign (^array-index (^member (^this) 'slots) (^int 0))
                        (^this)))))))

    ((frame)
     (rts-class
      'frame
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'slots '(array scmobj) #f '(public))))) ;; instance-fields

    ((make_frame)
     (rts-method
      'make_frame
      '(public)
      'frame
      (list (univ-field 'ra 'returnpt))
      "\n"
      '()
      (lambda (ctx)
        (let ((ra (^local-var 'ra))
              (fs (^local-var 'fs))
              (slots (^local-var 'slots)))
          (^ (univ-with-ctrlpt-attribs
              ctx
              #f
              ra
              (lambda ()
                (^var-declaration
                 'int
                 fs
                 (univ-get-ctrlpt-attrib ctx ra 'fs))))
             (^var-declaration
              '(array scmobj)
              slots
              (^new-array 'scmobj (^parens (^+ fs (^int 1)))))
             (^assign (^array-index slots (^int 0)) ra)
             (^return
              (^frame-box slots)))))))

    ((continuation)
     (rts-class
      'continuation
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'frame 'frame #f '(public)) ;; instance-fields
            (univ-field 'denv 'scmobj #f '(public)))))

    ((continuation_next)
     (rts-method
      'continuation_next
      '(public)
      'scmobj
      (list (univ-field 'cont 'continuation))
      "\n"
      '()
      (lambda (ctx)
        (let ((cont (^local-var 'cont))
              (frame (^local-var 'frame))
              (denv (^local-var 'denv))
              (ra (^local-var 'ra))
              (link (^local-var 'link))
              (next_frame (^local-var 'next_frame)))
          (^ (^var-declaration
              'frame
              frame
              (^member cont 'frame))
             (^var-declaration
              'scmobj
              denv
              (^member cont 'denv))
             (^var-declaration
              'returnpt
              ra
              (^cast* 'returnpt
                      (^array-index (^frame-unbox frame) (^int 0))))
             (univ-with-ctrlpt-attribs
              ctx
              #f
              ra
              (lambda ()
                (^var-declaration
                 'int
                 link
                 (univ-get-ctrlpt-attrib ctx ra 'link))))
             (^var-declaration
              'frame
              next_frame
              (^cast* 'frame
                      (^array-index (^frame-unbox frame)
                                    link)))
             (^if (^eq? next_frame (univ-end-of-cont-marker ctx))
                  (^return (^obj #f))
                  (^return
                   (^new-continuation next_frame denv))))))))

    ((str_hash)
     (rts-method
      'str_hash
      '(public)
      'int
      (list (univ-field 'strng 'str))
      "\n"
      '()
      (lambda (ctx)
        (let ((strng (^local-var 'strng))
              (h (^local-var 'h))
              (i (^local-var 'i))
              (leng (^local-var 'leng)))
          (^ (^var-declaration 'int h (^int 0))
             (^var-declaration 'int i (^int 0))
             (^var-declaration 'int leng (^str-length strng))
             (^while (^< i leng)
                     (^ (^assign h
                                 (^bitand
                                  (^parens
                                   (^* (^parens (^+ (^parens (^>> h 8))
                                                    (^str-index-code strng i)))
                                       (^int 331804471)))
                                  (^int univ-fixnum-max)))
                        (^inc-by i 1)))
             (^return h))))))

    ((symbol)
     (rts-class
      'symbol
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'name 'str #f '(public)) ;; instance-fields
            (univ-field 'hash 'scmobj #f '(public))
            (univ-field 'interned 'scmobj (^obj #f) '(public)))
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (univ-tostr-method-name ctx)
        '(public)
        'str
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (lambda (ctx)
           (^return (^member (^this) 'name))))))))

    ((make_interned_symbol)
     (rts-method
      'make_interned_symbol
      '(public)
      'symbol
      (list (univ-field 'name 'str))
      "\n"
      '()
      (lambda (ctx)
        (let ((name (^local-var 'name))
              (obj (^local-var 'obj)))
          (^ (^var-declaration
              'symbol
              obj
              (^dict-get (^rts-field-use 'symbol_table)
                         name
                         (^null)))
             (^if (^null? obj)
                  (^ (^assign obj
                              (^symbol-box-uninterned
                               name
                               (^fixnum-box
                                (^call-prim
                                 (^rts-method-use 'str_hash)
                                 name))))
                     (^assign (^member obj 'interned)
                              (^obj #t))
                     (^dict-set (^rts-field-use 'symbol_table)
                                name
                                obj)))
             (^return obj))))))

    ((symbol_table)
     (rts-field
      'symbol_table
      '(dict str symbol)
      (^empty-dict '(dict str symbol))))

    ((keyword)
     (rts-class
      'keyword
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'name 'str #f '(public)) ;; instance-fields
            (univ-field 'hash 'scmobj #f '(public))
            (univ-field 'interned 'scmobj (^obj #f) '(public)))
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (univ-tostr-method-name ctx)
        '(public)
        'str
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (lambda (ctx)
           (^return (^member (^this) 'name))))))))

    ((make_interned_keyword)
     (rts-method
      'make_interned_keyword
      '(public)
      'keyword
      (list (univ-field 'name 'str))
      "\n"
      '()
      (lambda (ctx)
        (let ((name (^local-var 'name))
              (obj (^local-var 'obj)))
          (^ (^var-declaration
              'keyword
              obj
              (^dict-get (^rts-field-use 'keyword_table)
                         name
                         (^null)))
             (^if (^null? obj)
                  (^ (^assign obj
                              (^keyword-box-uninterned
                               name
                               (^fixnum-box
                                (^call-prim
                                 (^rts-method-use 'str_hash)
                                 name))))
                     (^assign (^member obj 'interned)
                              (^obj #t))
                     (^dict-set (^rts-field-use 'keyword_table)
                                name
                                obj)))
             (^return obj))))))

    ((keyword_table)
     (rts-field
      'keyword_table
      '(dict str keyword)
      (^empty-dict '(dict str keyword))))

    ((box)
     (rts-class
      'box
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'val 'scmobj #f '(public))))) ;; instance-fields

    ((values)
     (rts-class
      'values
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'vals '(array scmobj) #f '(public))))) ;; instance-fields

    ((null)
     (rts-class
      'null
      '() ;; properties
      'scmobj)) ;; extends

    ((null_obj)
     (rts-field
      'null_obj
      'scmobj
      (^new (^type 'null))
      '(public)))

    ((void)
     (rts-class
      'void
      '() ;; properties
      'scmobj)) ;; extends

    ((void_obj)
     (rts-field
      'void_obj
      'scmobj
      (^new (^type 'void))
      '(public)))

    ((eof)
     (rts-class
      'eof
      '() ;; properties
      'scmobj)) ;; extends

    ((eof_obj)
     (rts-field
      'eof_obj
      'scmobj
      (^new (^type 'eof))
      '(public)))

    ((absent)
     (rts-class
      'absent
      '() ;; properties
      'scmobj)) ;; extends

    ((absent_obj)
     (rts-field
      'absent_obj
      'scmobj
      (^new (^type 'absent))
      '(public)))

    ((deleted)
     (rts-class
      'deleted
      '() ;; properties
      'scmobj)) ;; extends

    ((deleted_obj)
     (rts-field
      'deleted_obj
      'scmobj
      (^new (^type 'deleted))
      '(public)))

    ((unused)
     (rts-class
      'unused
      '() ;; properties
      'scmobj)) ;; extends

    ((unused_obj)
     (rts-field
      'unused_obj
      'scmobj
      (^new (^type 'unused))
      '(public)))

    ((unbound)
     (rts-class
      'unbound
      '() ;; properties
      'scmobj)) ;; extends

    ((unbound1_obj)
     (rts-field
      'unbound1_obj
      'scmobj
      (^new (^type 'unbound))
      '(public)))

    ((unbound2_obj)
     (rts-field
      'unbound2_obj
      'scmobj
      (^new (^type 'unbound))
      '(public)))

    ((optional)
     (rts-class
      'optional
      '() ;; properties
      'scmobj)) ;; extends

    ((optional_obj)
     (rts-field
      'optional_obj
      'scmobj
      (^new (^type 'optional))
      '(public)))

    ((key)
     (rts-class
      'key
      '() ;; properties
      'scmobj)) ;; extends

    ((key_obj)
     (rts-field
      'key_obj
      'scmobj
      (^new (^type 'key))
      '(public)))

    ((rest)
     (rts-class
      'rest
      '() ;; properties
      'scmobj)) ;; extends

    ((rest_obj)
     (rts-field
      'rest_obj
      'scmobj
      (^new (^type 'rest))
      '(public)))

    ((boolean)
     (rts-class
      'boolean
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'val 'bool #f '(public))))) ;; instance-fields

    ((false_obj)
     (rts-field
      'false_obj
      'scmobj
      (^new (^type 'boolean) (^bool #f))
      '(public)))

    ((true_obj)
     (rts-field
      'true_obj
      'scmobj
      (^new (^type 'boolean) (^bool #t))
      '(public)))

    ((char)
     (rts-class
      'char
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'code 'unicode #f '(public))) ;; instance-fields
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (univ-tostr-method-name ctx)
        '(public)
        'str
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (case (target-name (ctx-target ctx))

           ((js)
            (lambda (ctx)
              (^return
               (^call-prim
                (^member 'String 'fromCharCode)
                (^member (^this) 'code)))))

           ((php python)
            (lambda (ctx)
              (^return
               (^call-prim
                "chr"
                (^member (^this) 'code)))))

           ((ruby)
            (lambda (ctx)
              (^return
               (^call-prim
                (^member
                 (^member (^this) 'code)
                 'chr)))))

           ((java)
            (lambda (ctx)
              (^return
               (^call-prim
                (^member 'String 'valueOf)
                (^cast* 'chr
                        (^member (^this) 'code))))))

           (else
            (compiler-internal-error
             "univ-rtlib-feature char, unknown target"))))))))

    ((make_interned_char)
     (rts-method
      'make_interned_char
      '(public)
      'char
      (list (univ-field 'code 'unicode))
      "\n"
      '()
      (lambda (ctx)
        (let ((code (^local-var 'code))
              (obj (^local-var 'obj)))
          (^ (^var-declaration
              'char
              obj
              (^dict-get (^rts-field-use 'char_table)
                         code
                         (^null)))
             (^if (^null? obj)
                  (^ (^assign obj
                              (^char-box-uninterned code))
                     (^dict-set (^rts-field-use 'char_table)
                                code
                                obj)))
             (^return obj))))))

    ((char_table)
     (rts-field
      'char_table
      '(dict int char)
      (^empty-dict '(dict int char))))

    ((string)
     (rts-class
      'string
      '() ;; properties
      'scmobj ;; extends
      '() ;; class-fields
      (list (univ-field 'codes '(array unicode) #f '(public))) ;; instance-fields
      '() ;; class-methods
      (list ;; instance-methods
       (univ-method
        (univ-tostr-method-name ctx)
        '(public)
        'str
        '()
        '()
        (univ-emit-fn-body
         ctx
         "\n"
         (case (target-name (ctx-target ctx))

           ((js)
            (lambda (ctx)
              (let ((codes (^member (^this) 'codes))
                    (limit (^local-var 'limit))
                    (chunks (^local-var 'chunks))
                    (i (^local-var 'i)))
                (^ (^var-declaration 'int limit (^int 32768))
                   (^if (^< (^array-length codes) limit)
                        (^return
                         (^call-prim
                          (^member (^member "String" 'fromCharCode) 'apply)
                          "null"
                          codes))
                        (^ (^var-declaration 'object chunks (^array-literal 'object '()))
                           (^var-declaration 'int i (^int 0))
                           (^while (^< i (^array-length codes))
                                   (^ (^expr-statement
                                       (^call-prim
                                        (^member chunks 'push)
                                        (^call-prim
                                         (^member (^member "String" 'fromCharCode) 'apply)
                                         "null"
                                         (^call-prim
                                          (^member codes 'slice)
                                          i
                                          (^+ i limit)))))
                                      (^inc-by i limit)))
                           (^return
                            (^call-prim
                             (^member chunks 'join)
                             (^str "")))))))))

           ((php)
            (lambda (ctx)
              (^return
               (^call-prim
                "join"
                (^call-prim
                 "array_map"
                 (^str "chr")
                 (^member (^this) 'codes))))))

           ((python)
            (lambda (ctx)
              (^return
               (^call-prim
                (^member (^str "") 'join)
                (^call-prim
                 "map"
                 "chr"
                 (^member (^this) 'codes))))))

           ((ruby)
            ;;TODO: add anonymous function
            (lambda (ctx)
              (^return
               (^call-prim
                (^member
                 (^ (^member (^member (^this) 'codes) 'map)
                    " {|x| x.chr}")
                 'join)))))

           ((java)
            (lambda (ctx)
;;TODO: clean up
"
    char c[] = new char[codes.length];
    for (int i=0; i<codes.length; i++) c[i] = (char)codes[i];
    return String.valueOf(c);
"))

           (else
            (compiler-internal-error
             "univ-rtlib-feature string, unknown target"))))))))

    ((tostr)
     (rts-method
      'tostr
      '(public)
      'str
      (list (univ-field 'obj 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (let ((obj (^local-var 'obj)))
          (^if (^eq? obj (^obj #f))
               (^return (^str "#f"))
               (^if (^eq? obj (^obj #t))
                    (^return (^str "#t"))
                    (^if (^eq? obj (^obj '()))
                         (^return (^str ""))
                         (^if (^eq? obj (^void-obj))
                              (^return (^str "#!void"))
                              (^if (^eq? obj (^eof))
                                   (^return (^str "#!eof"))
                                   (^if (^pair? obj)
                                        (^return (^concat
                                                  (^call-prim
                                                   (^rts-method-use 'tostr)
                                                   (^getcar obj))
                                                  (^call-prim
                                                   (^rts-method-use 'tostr)
                                                   (^getcdr obj))))
                                        (^return (^tostr obj))))))))))))

    ((println)
     (rts-method
      'println
      '(public)
      'noresult
      (list (univ-field 'obj 'str))
      "\n"
      '()
      (lambda (ctx)
        (let ((obj (^local-var 'obj)))
          (case (target-name (ctx-target ctx))
            ((js)
             (^if (^prop-index-exists?
                   "function () {return this;}()"
                   (^str "console"))
                  (^expr-statement
                   (^call-prim (^member (^global-var 'console) 'log)
                               obj))
                  (^expr-statement
                   (^call-prim "print"
                               obj))))
            ((python)
             (^expr-statement (^call-prim "print" obj)))
            ((ruby php)
             (^ (^expr-statement (^call-prim "print" obj))
                (^expr-statement (^call-prim "print" "\"\\n\""))))
            ((java)
             (^expr-statement (^call-prim (^member (^member 'System 'out) 'println) obj)))
            (else
             (compiler-internal-error
              "univ-rtlib-feature println, unknown target")))))))

    ((glo-println)
     (univ-defs-combine
      (univ-jumpable-declaration-defs
       ctx
       #t
       (gvm-proc-use ctx "println")
       'entrypt
       '()
       '()
       (univ-emit-fn-body
        ctx
        "\n"
        (lambda (ctx)
          (^ (^expr-statement
              (^call-prim
               (^rts-method-use 'println)
               (^call-prim
                (^rts-method-use 'tostr)
                (^getreg 1))))
             (^setreg 1 (^void-obj))
             (^return
              (^cast*-jumpable (^getreg 0)))))))
      (rts-init
       (lambda (ctx)
         (^setglo 'println
                  (^this-mod-jumpable
                   (gvm-proc-use ctx "println")))))))

    ((exit_process)
     (rts-method
      'exit_process
      '(public)
      'noresult
      (list (univ-field 'code 'int))
      "\n"
      '()
      (lambda (ctx)
        (let ((code (^local-var 'code)))
          (case (target-name (ctx-target ctx))
            ((js)
             (^expr-statement
              (^call-prim (^member (^global-var 'process) 'exit) code)))
            ((python ruby php)
             (^expr-statement (^call-prim "exit" code)))
            ((java)
             (^expr-statement (^call-prim (^member 'System 'exit) code)))
            (else
             (compiler-internal-error
              "univ-rtlib-feature ##exit-process, unknown target")))))))

    ((glo-##exit-process)
     (univ-defs-combine
      (univ-jumpable-declaration-defs
       ctx
       #t
       (gvm-proc-use ctx "##exit-process")
       'entrypt
       '()
       '()
       (univ-emit-fn-body
        ctx
        "\n"
        (lambda (ctx)
          (^ (^expr-statement
              (^call-prim
               (^rts-method-use 'exit_process)
               (^fixnum-unbox (^getreg 1))))
             (^setreg 1 (^void-obj))
             (^return
              (^cast*-jumpable (^getreg 0)))))))
      (rts-init
       (lambda (ctx)
         (^setglo '##exit-process
                  (^this-mod-jumpable
                   (gvm-proc-use ctx "##exit-process")))))))

    ((glo-real-time-milliseconds)
     (univ-defs-combine
      (univ-jumpable-declaration-defs
       ctx
       #t
       (gvm-proc-use ctx "real-time-milliseconds")
       'entrypt
       '()
       '()
       (univ-emit-fn-body
        ctx
        "\n"
        (lambda (ctx)
          (^ (case (target-name (ctx-target ctx))

               ((js java)
                (^setreg 1
                         (^fixnum-box
                          (^cast* 'int
                                  (^parens
                                   (^- (univ-get-time ctx)
                                       (^rts-field-use 'start_time)))))))

               ((python php ruby)
                (^setreg 1
                         (^fixnum-box
                          (^float-toint
                           (^* 1000
                               (^parens
                                (^- (univ-get-time ctx)
                                    (^rts-field-use 'start_time))))))))

               (else
                (compiler-internal-error
                 "univ-rtlib-feature glo-real-time-milliseconds, unknown target")))
             (^return
              (^cast*-jumpable (^getreg 0)))))))
      (rts-init
       (lambda (ctx)
         (^setglo 'real-time-milliseconds
                  (^this-mod-jumpable
                   (gvm-proc-use ctx "real-time-milliseconds")))))))

    ((start_time)
     (rts-field
      'start_time
      'long
      (univ-get-time ctx)))

    ((str2codes)
     (rts-method
      'str2codes
      '(public)
      '(array unicode)
      (list (univ-field 'strng 'str))
      "\n"
      '()
      (lambda (ctx)
        (let ((strng (^local-var 'strng)))
          (case (target-name (ctx-target ctx))

            ((js)
             (^
;;TODO: clean up
"
    var codes = [];
    for (var i=0; i < " strng ".length; i++) {
        codes.push(" strng ".charCodeAt(i));
    }
    return codes;
"))

            ((php)
             (^return (^ "array_slice(unpack('c*'," strng "),0)")))

            ((python)
             (^return (^ "[ord(c) for c in " strng "]")))

            ((ruby)
             (^return (^ strng ".unpack('U*')")))

            ((java)
             (^
;;TODO: clean up
"
    int codes[] = new int[" strng ".length()];
    for (int i=0; i < " strng ".length(); i++) {
        codes[i] = " strng ".codePointAt(i);
    }
    return codes;
"))

            (else
             (compiler-internal-error
              "univ-rtlib-feature str2codes, unknown target")))))))

    ((make_values)
     (rts-method
      'make_values
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'scmobj
         (lambda (result) (^return (^values-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_vector)
     (rts-method
      'make_vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'scmobj
         (lambda (result) (^return (^vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_u8vector)
     (rts-method
      'make_u8vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'u8))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'u8
         (lambda (result) (^return (^u8vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_u16vector)
     (rts-method
      'make_u16vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'u16))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'u16
         (lambda (result) (^return (^u16vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_u32vector)
     (rts-method
      'make_u32vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'u32))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'u32
         (lambda (result) (^return (^u32vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_u64vector)
     (rts-method
      'make_u64vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'u64))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'u64
         (lambda (result) (^return (^u64vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_s8vector)
     (rts-method
      'make_s8vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 's8))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         's8
         (lambda (result) (^return (^s8vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_s16vector)
     (rts-method
      'make_s16vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 's16))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         's16
         (lambda (result) (^return (^s16vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_s32vector)
     (rts-method
      'make_s32vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 's32))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         's32
         (lambda (result) (^return (^s32vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_s64vector)
     (rts-method
      'make_s64vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 's64))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         's64
         (lambda (result) (^return (^s64vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_f32vector)
     (rts-method
      'make_f32vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'f32))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'f32
         (lambda (result) (^return (^f32vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_f64vector)
     (rts-method
      'make_f64vector
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'f64))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'f64
         (lambda (result) (^return (^f64vector-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_string)
     (rts-method
      'make_string
      '(public)
      'scmobj
      (list (univ-field 'leng 'int)
            (univ-field 'init 'unicode))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'unicode
         (lambda (result) (^return (^string-box result)))
         (^local-var 'leng)
         (^local-var 'init)))))

    ((make_structure)
     (rts-method
      'make_structure
      '(public)
      'scmobj
      (list (univ-field 'type 'scmobj)
            (univ-field 'leng 'int))
      "\n"
      '()
      (lambda (ctx)
        (^make-array
         'scmobj
         (lambda (result) (^return (^structure-box result)))
         (^local-var 'leng)
         (^local-var 'type)))))

    ((make_glo_var)
     (rts-method
      'make_glo_var
      '(public)
      'symbol
      (list (univ-field 'sym 'symbol))
      "\n"
      '()
      (lambda (ctx)
        (let ((sym (^local-var 'sym)))
          (^ (^if (^not (^dict-key-exists? (gvm-state-glo-use ctx 'rd)
                                           (^symbol-unbox sym)))
                  (^ (^glo-var-set! sym (^unbound1))
                     (^glo-var-primitive-set! sym (^null))))
             (^return sym))))))

    ((apply2)
     (apply-procedure 2))

    ((apply3)
     (apply-procedure 3))

    ((apply4)
     (apply-procedure 4))

    ((apply5)
     (apply-procedure 5))

    ((host_function2scm)
     (rts-method
      'host_function2scm
      '(public)
      'object
      (list (univ-field 'obj 'object))
      "\n"
      '()
      (lambda (ctx)
       (let ((obj (^local-var 'obj))
             (h2s_procedure (^prefix 'h2s_procedure)))
        (^ (^procedure-declaration
            #t
            'entrypt ;; TODO: ensure it is the correct type
            'h2s_procedure
            '()
            "\n"
            '()
            (^return-call-prim
              (^rts-method-ref 'scm2host_call)
              obj))
           (^return h2s_procedure))))))

    ((host2scm)
     (rts-method
      'host2scm
      '(public)
      'scmobj
      (list (univ-field 'obj 'object))
      "\n"
      '()
      (lambda (ctx)
        (let ((obj (^local-var 'obj))
              (alist (^local-var 'alist))
              (key (^local-var 'key)))

          (define (convert-array ctx obj type)
            (let ((constructor (univ-array-constructor ctx type)))
              (if (and (not (eq? type 'scmobj))
                       (equal? constructor
                               (univ-array-constructor ctx 'scmobj)))
                  (^)
                  (^if (^instanceof constructor obj)
                       (^return
                        (^vect-box type
                                   (if (eq? type 'scmobj)
                                       (^map (^rts-method-ref 'host2scm) obj)
                                       obj)))))))

          (^
           (if (eq? (target-name (ctx-target ctx)) 'js)
               (^if (^void? obj)
                    (^return (^void-obj)))
               (^))

           (^if (^null? obj)
                (if (and (eq? (univ-void-representation ctx) 'host)
                         ; Javascript has a native "void" in "undefined".
                         (not (eq? (target-name (ctx-target ctx)) 'js)))
                    (^return (^void-obj))
                    (^return (^null-obj))))

           (^if (^bool? obj)
                (^return (^boolean-box obj)))

           (case (target-name (ctx-target ctx))
            ((js)
             (^if (^typeof "number" obj)
                  (^if (^and (^= (^parens (^bitior obj 0)) obj)
                             (^and (^>= obj -536870912)
                                   (^<= obj 536870911)))
                       (^return (^fixnum-box obj))
                       (^return (^flonum-box obj)))))
            (else
             (^ (^if (^and (^int? obj)
                           (^and (^>= obj -536870912)
                                 (^<= obj 536870911)))
                     (^return (^fixnum-box obj)))
                (^if (^float? obj)
                     (^return (^flonum-box obj))))))

           (case (target-name (ctx-target ctx))
            ((php)
             (^ ))
            (else
             (^if (^function? obj)
                  (^return-call-prim
                   (^rts-method-ref 'host_function2scm)
                   obj))))

           (^if (^str? obj)
                (^return (^str->string obj)))

           ; TODO: generalise for python, java, ruby and php
           (case (target-name (ctx-target ctx))
            ((js)
             (^if (^typeof "object" obj)
                  (^ (convert-array ctx obj 'scmobj)
                     (convert-array ctx obj 'u8)
                     (convert-array ctx obj 'u16)
                     (convert-array ctx obj 'u32)
                     (convert-array ctx obj 'u64)
                     (convert-array ctx obj 's8)
                     (convert-array ctx obj 's16)
                     (convert-array ctx obj 's32)
                     (convert-array ctx obj 's64)
                     (convert-array ctx obj 'f32)
                     (convert-array ctx obj 'f64)

                     (^var-declaration '() alist (^null-obj))
                     "for (var " key " in " obj ") {\n"
                     (^assign alist (^cons (^cons (^call-prim
                                                   (^rts-method-ref 'host2scm)
                                                   key)
                                                  (^call-prim
                                                   (^rts-method-ref 'host2scm)
                                                   (^array-index obj key)))
                                           alist))
                     "}\n"
                     (^return alist))))
            ((python)
             ;;TODO: improve!
             (^if (^instanceof "list" obj)
                  (^return obj)))
            (else (^)))


           ;; Scheme object "passthrough".
           ;; Handle scheme objects represented as classes and return
           ;; them without modification.
           ;; ??? TODO: implement passthrough as a compiler option. ???
#;
           (case (univ-void-representation ctx)
            ((host) (^))
            ((class)
             (^if (^void-obj? obj)
                  (^return obj))))

           ;; Needed for languages without void, otherwise conversion on
           ;; null values wouldn't be bijective.
           (case (target-name (ctx-target ctx))
            ((php python ruby java)
             (case (univ-null-representation ctx)
              ((host) (^))
              ((class)
               (^if (^null-obj? obj)
                 (^return obj)))))
            (else (^)))
#;
           (case (univ-boolean-representation ctx)
            ((host) (^))
            ((class)
             (^if (^boolean? obj)
                  (^return obj))))
#;
           (case (univ-string-representation ctx)
            ((host) (^))
            ((class)
             (^if (^string? obj)
                  (^return obj))))
#;
           (case (univ-fixnum-representation ctx)
            ((host) (^))
            ((class)
             (^if (^fixnum? obj)
                  (^return obj))))
#;
           (case (univ-flonum-representation ctx)
            ((host) (^))
            ((class)
             (^if (^flonum? obj)
                  (^return obj))))
#;
           (case (univ-procedure-representation ctx)
            ((host) (^))
            ((class)
             (^if (^procedure? obj)
               (^return obj))))

           (univ-throw ctx "\"host2scm error\""))))))

    ((host2scm_call)
     (rts-method
      'host2scm_call
      '(public)
      'object
      (list (univ-field 'proc 'scmobj)
            (univ-field 'args 'scmobj))
      "\n"
      '()
      (lambda (ctx)
       (let ((args (^local-var 'args))
             (i (^local-var 'i))
             (proc (^local-var 'proc)))
          (^
            (^assign (gvm-state-sp-use ctx 'wr) -1)
            (^push (univ-end-of-cont-marker ctx))
            (^assign (^getnargs) (^array-length args))
            (^assign i 0)
            (^while (^< i (^getnargs))
              (^ (^push
                   (^call-prim (^rts-method-ref 'host2scm)
                               (^array-index args i)))
                 (^inc-by i 1)))
            (univ-pop-args-to-regs ctx 0)
            (^assign (^getreg 0) (^rts-method-use 'underflow))
            (^expr-statement
              (^call-prim (^rts-method-use 'trampoline)
                          proc))
            (^return-call-prim (^rts-method-ref 'scm2host)
                               (^getreg 1)))))))

    ((scm_procedure2host)
     (rts-method
      'scm_procedure2host
      '(public)
      'object
      (list (univ-field 'obj 'scmobj))
      "\n"
      '()
      (lambda (ctx)
       (let ((obj (^local-var 'obj))
             (arguments  (^local-var 'arguments))
             (scm_procedure (^local-var 'scm_procedure)))
         (^
          ;; TODO: since prim-function-declaration is supposed to be removed
          ;; an alternative way to create a host closure should be found.
          (^prim-function-declaration
           'scm_procedure                               ;name
           'object
           (case (target-name (ctx-target ctx))         ;argument
            ((js php) '())
            ((python ruby) (list (univ-field '*arguments '()))))
           "\n"                                         ;header
           (^)                                          ;attribs
           (^ (case (target-name (ctx-target ctx))      ;body
               ((php)
                (^var-declaration '() arguments (^call-prim 'func_get_args)))
               (else (^)))
              (^return
               (^call-prim (^rts-method-ref 'host2scm_call)
                           obj
                           arguments))))
            (^return scm_procedure))))))

    ((scm2host)
     (rts-method
      'scm2host
      '(public)
      'object
      (list (univ-field 'obj 'scmobj))
      "\n"
      '()
      (lambda (ctx)
       (let ((obj (^local-var 'obj)))

         (define (convert-array ctx obj type)
           (let ((constructor (univ-array-constructor ctx type)))
             (if (and (not (eq? type 'scmobj))
                      (equal? constructor
                              (univ-array-constructor ctx 'scmobj)))
                 (^)
                 (^if (^vect? type obj)
                      (if (eq? type 'scmobj)
                          (^return (^map (^rts-method-ref 'scm2host)
                                         (^vect-unbox type obj)))
                          (^return (^vect-unbox type obj)))))))

         (^
          (^if (^void-obj? obj)
            (case (univ-void-representation ctx)
             ((host) (^return obj))
             ((class)
              (^return (case (target-name (ctx-target ctx))
                        ((js) (^void))
                        (else (^null)))))))

          (^if (^null-obj? obj)
               (case (univ-null-representation ctx)
                ((host) (^return obj))
                ((class)
                 (^return (case (target-name (ctx-target ctx))
                           ((js) (^null))
                           (else obj))))))

          (^if (^boolean? obj)
               (^return (^boolean-unbox obj)))

          (if (and (eq? (target-name (ctx-target ctx)) 'js)
                   (eq? (univ-flonum-representation ctx) 'host)
                   (eq? (univ-fixnum-representation ctx) 'host))
              (^if  (^int? obj)
                    (^if (^and (^>= obj -536870912)
                               (^<= obj 536870911))
                         (^return (^fixnum-unbox obj))
                         (^return (^flonum-unbox obj))))
              (^
                (^if (^fixnum? obj)
                     (^return (^fixnum-unbox obj)))
                (^if (^flonum? obj)
                     (^return (^flonum-unbox obj)))))

          (^if (^string? obj)
               (case (univ-string-representation ctx)
                ((class)
                 (^return (^string->str obj)))
                ((host)
                 (^return obj))))

          ; TODO: generalise for python, ruby, php and java
          (case (target-name (ctx-target ctx))
           ((js)
            (^ (convert-array ctx obj 'scmobj)
               (convert-array ctx obj 'u8)
               (convert-array ctx obj 'u16)
               (convert-array ctx obj 'u32)
               (convert-array ctx obj 'u64)
               (convert-array ctx obj 's8)
               (convert-array ctx obj 's16)
               (convert-array ctx obj 's32)
               (convert-array ctx obj 's64)
               (convert-array ctx obj 'f32)
               (convert-array ctx obj 'f64)))
           (else (^)))

          ; TODO: generalise for python, ruby, php and java
          ; Note: pair conversions are not bijective.
          (case (target-name (ctx-target ctx))
           ((js)
            (^if (^pair? obj)
                 (let ((jsobj (^local-var 'jsobj))
                       (i (^local-var 'i))
                       (elem (^local-var 'elem)))

                   (^
                     (^var-declaration '() jsobj "{}")
                     (^var-declaration 'int i (^int 0))
                     (^while (^pair? obj)
                       (^ (^var-declaration '() elem (^getcar obj))
                          (^if (^pair? elem)
                               (^assign
                                 (^array-index
                                  obj
                                  (^call-prim (^rts-method-ref 'scm2host)
                                              (^getcar elem)))
                                 (^call-prim (^rts-method-ref 'scm2host)
                                             (^getcdr elem)))
                               (^assign
                                 (^array-index obj i)
                                 (^call-prim
                                  (^rts-method-ref 'scm2host)
                                  elem)))
                          (^inc-by i 1)
                          (^assign obj (^getcdr obj))))
                     (^return jsobj)))))
           (else (^)))

          (^if (^structure? obj)
               (univ-throw ctx "\"scm2host error (cannot convert Structure)\""))

          (case (target-name (ctx-target ctx))
           ((php) (^))
           (else
            (^if (^procedure? obj)
                 (^return-call-prim
                   (^rts-method-ref 'scm_procedure2host)
                   obj))))

          (univ-throw ctx "\"scm2host error\""))))))

    ((scm2host_call)
     (rts-method
      'scm2host_call
      '(public)
      'jumpable
      (list (univ-field 'fn 'object))
      "\n"
      '()
      (lambda (ctx)
       (let ((args (^local-var 'args))
             (ra (^local-var 'ra))
             (frame (^local-var 'frame))
             (tmp (^local-var 'tmp))
             (fn (^local-var 'fn)))
         (^
          (univ-push-args ctx)
          (^var-declaration '(array scmobj)
                            args
                            (^extensible-subarray
                               (gvm-state-stack-use ctx 'rd)
                               (^- (^+ (gvm-state-sp-use ctx 'rd) 1)
                                       (^getnargs))
                               (^getnargs)))
          (^inc-by (gvm-state-sp-use ctx 'rdwr) (^- (^getnargs)))
          (^var-declaration 'returnpt
                            ra
                            (^call-prim
                             (^rts-method-use 'heapify_cont)
                             (^getreg 0)))
          (^var-declaration 'frame
                            frame
                            (^array-index (gvm-state-stack-use ctx 'rd) 0))
          ;; TODO choose appropriate type for Java
          (^var-declaration '() ;??? '(array ???) <- This one is problematic.
                            tmp
                            (^map (^rts-method-ref 'scm2host)
                                  args))
          (^assign tmp (^call-with-arg-array fn tmp))
          (^assign (^getreg 1)
                   (^call-prim (^rts-method-ref 'host2scm) tmp))
          (^assign (gvm-state-sp-use ctx 'wr) -1)
          (^inc-by (gvm-state-sp-use ctx 'rdwr)
                   1
                   (lambda (x)
                     (^assign (^array-index (gvm-state-stack-use ctx 'wr) x)
                              frame)))
          (^return ra))))))

    ((js2scm)
     (rts-method
      'js2scm
      '(public)
      'scmobj
      (list (univ-field 'obj 'object))
      "\n"
      '()
      (lambda (ctx)
        (let ((obj (^local-var 'obj))
              (alist (^local-var 'alist))
              (key (^local-var 'key)))
          (^
           "  if (" obj " === void 0) {
    return " (^void-obj) ";
  } else if (typeof " obj " === 'boolean') {
    return " (^boolean-box obj) ";
  } else if (" obj " === null) {
    return " (^null-obj) ";
  } else if (typeof " obj " === 'number') {
    if ((" obj "|0) === " obj " && " obj ">=-536870912 && " obj "<=536870911)
      return " (^fixnum-box obj) ";
    else
      return " (^flonum-box obj) ";
  } else if (typeof " obj " === 'function') {
    return function () { return " (^call-prim
                                   (^rts-method-use 'scm2js_call)
                                   obj) "; };
  } else if (typeof " obj " === 'string') {
    return " (^string-box (^str-to-codes obj)) ";
  } else if (typeof " obj " === 'object') {
    if (" obj " instanceof Array) {
      return " obj ".map(" (^rts-method-use 'js2scm) ");
    } else {
      var " alist " = " (^null-obj) ";
      for (var " key " in " obj ") {
        " alist " = " (^cons (^cons (^call-prim
                                     (^rts-method-use 'js2scm)
                                     key)
                                    (^call-prim
                                     (^rts-method-use 'js2scm)
                                     (^array-index obj key)))
                                   alist) ";
      }
      return " alist ";
    }
  } else {
    throw 'js2scm error ' + " obj ";
  }
")))))

    ((scm2js)
     (rts-method
      'scm2js
      '(public)
      'object
      (list (univ-field 'obj 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        #<<EOF
  if (obj === void 0) {
    return obj;
  } else if (typeof obj === 'boolean') {
    return obj;
  } else if (obj === null) {
    return obj;
  } else if (typeof obj === 'number') {
    return obj
  } else if (typeof obj === 'function') {
    return function () { return Gambit.js2scm_call(obj, arguments); };
  } else if (typeof obj === 'object') {
    if (obj instanceof Array) {
      return obj.map(Gambit.scm2js);
    } else if (obj instanceof Gambit.String) {
      return obj.toString();
    } else if (obj instanceof Gambit.Flonum) {
      return obj.val;
    } else if (obj instanceof Gambit.Pair) {
      var jsobj = {};
      var i = 0;
      while (obj instanceof Gambit.Pair) {
        var elem = obj.car;
        if (elem instanceof Gambit.Pair) {
          jsobj[Gambit.scm2js(elem.car)] = Gambit.scm2js(elem.cdr);
        } else {
          jsobj[i] = Gambit.scm2js(elem);
        }
        ++i;
        obj = obj.cdr;
      }
      return jsobj;
    } else if (obj instanceof Gambit.Structure) {
      throw 'Gambit.scm2js error (cannot convert Structure)';
    } else {
      throw 'Gambit.scm2js error ' + obj;
    }
  } else {
    throw 'Gambit.scm2js error ' + obj;
  }
EOF
)))

    ((scm2js_call)
     (rts-method
      'scm2js_call
      '(public)
      'jumpable
      (list (univ-field 'fn 'object))
      "\n"
      '()
      (lambda (ctx)
        #<<EOF

  if (Gambit.nargs > 0) {
    Gambit.stack[++Gambit.sp] = Gambit.r1;
    if (Gambit.nargs > 1) {
      Gambit.stack[++Gambit.sp] = Gambit.r2;
      if (Gambit.nargs > 2) {
        Gambit.stack[++Gambit.sp] = Gambit.r3;
      }
    }
  }

  var args = Gambit.stack.slice(Gambit.sp+1-Gambit.nargs, Gambit.sp+1);

  Gambit.sp -= Gambit.nargs;

  var ra = Gambit.heapify_cont(Gambit.r0);
  var frame = Gambit.stack[0];

  Gambit.r1 = Gambit.js2scm(fn.apply(null, args.map(Gambit.scm2js)));

  Gambit.sp = -1;
  Gambit.stack[++Gambit.sp] = frame;

  return ra;

EOF
)))

    ((js2scm_call)
     (rts-method
      'js2scm_call
      '(public)
      'object
      (list (univ-field 'proc 'scmobj)
            (univ-field 'args 'scmobj))
      "\n"
      '()
      (lambda (ctx)
        #<<EOF

  Gambit.sp = -1;
  Gambit.stack[++Gambit.sp] = Gambit.void_obj; // end of continuation marker

  Gambit.nargs = args.length;

  for (var i=0; i<Gambit.nargs; i++) {
    Gambit.stack[++Gambit.sp] = Gambit.js2scm(args[i]);
  }

  if (Gambit.nargs > 0) {
    if (Gambit.nargs > 1) {
      if (Gambit.nargs > 2) {
        Gambit.r3 = Gambit.stack[Gambit.sp];
        --Gambit.sp;
      }
      Gambit.r2 = Gambit.stack[Gambit.sp];
      --Gambit.sp;
    }
    Gambit.r1 = Gambit.stack[Gambit.sp];
    --Gambit.sp;
  }

  Gambit.r0 = Gambit.underflow;

  Gambit.trampoline(proc);

  return Gambit.scm2js(Gambit.r1);

EOF
)))

     ((ffi)
      (case (target-name (ctx-target ctx))
       ((js)
        (univ-use-rtlib ctx 'host_function2scm)
        (univ-use-rtlib ctx 'host2scm)
        (univ-use-rtlib ctx 'host2scm_call)
        (univ-use-rtlib ctx 'scm2host)
        (univ-use-rtlib ctx 'scm_procedure2host)
        (univ-use-rtlib ctx 'scm2host_call)
        (univ-use-rtlib ctx 'js2scm)
        (univ-use-rtlib ctx 'scm2js)
        (univ-use-rtlib ctx 'js2scm_call)
        (univ-use-rtlib ctx 'scm2js_call))
       ((python ruby php)
        (univ-use-rtlib ctx 'host_function2scm)
        (univ-use-rtlib ctx 'host2scm)
        (univ-use-rtlib ctx 'host2scm_call)
        (univ-use-rtlib ctx 'scm2host)
        (univ-use-rtlib ctx 'scm_procedure2host) ;;TODO FIX
        (univ-use-rtlib ctx 'scm2host_call))
       )
      (univ-make-empty-defs))

    ((globals)
     (case (target-name (ctx-target ctx))

       ((js)
        (rts-field
         'globals
         'object
         (^this)))

       ((php)
        (rts-field
         'globals
         'object
         (^local-var 'GLOBALS)))

       ((python)
        (rts-field
         'globals
         'object
         (^call-prim "locals")))

       ((ruby)
        (rts-field
         'globals
         'object
         "binding"))

       (else
        (compiler-internal-error
         "univ-rtlib-feature globals, unknown target"))))

    ((get_host_global_var)
     (rts-method
      'get_host_global_var
      '(public)
      'object
      (list (univ-field 'name 'object))
      "\n"
      '()
      (lambda (ctx)
        (case (target-name (ctx-target ctx))

          ((js php python)
           (^return (^prop-index (^rts-field-use 'globals)
                                 (^local-var 'name))))

          ((ruby)
           #; ;; this code only works on newer versions of ruby
           (^return (^call-prim (^member (^rts-field-use 'globals)
           'local_variable_get)
           (^ (^local-var 'name) ".to_sym")))

           ;; this code uses eval but works on all versions of ruby
           (^return (^call-prim "eval"
                                (^+ (^str "$") (^local-var 'name))
                                (^rts-field-use 'globals))))

           (else
            (compiler-internal-error
             "univ-rtlib-feature get_host_global_var, unknown target"))))))

    ;; Functions ilogb and ldexp adapted from :
    ;; http://croquetweak.blogspot.ca/2014/08/deconstructing-floats-frexp-and-ldexp.html
    ;;
    ;; TODO : Implement ldexp and ilogb in other target languages where required
    ((ilogb)
     (rts-method
      'ilogb
      '(public)
      'f64
      (list (univ-field 'value 'f64))
      "\n"
      '()
      (lambda (ctx)
        (case (target-name (ctx-target ctx))
          ((js)
           "
            var data = new DataView(new ArrayBuffer(8));
            data.setFloat64(0, value);
            var bits = (data.getUint32(0) >>> 20) & 0x7FF;
            if (bits === 0) { // denormal
                data.setFloat64(0, value * Math.pow(2, 64));
                bits = ((data.getUint32(0) >>> 20) & 0x7FF) - 64;
            }
            var exponent = bits - 1022;
            return exponent - 1;
           ")
          (else
           (compiler-internal-error
            "univ-rtlib-feature ilogb, unknown target"))))))

    ((ldexp)
     (rts-method
      'ldexp
      '(public)
      'f64
      (list (univ-field 'mantissa 'f64)
            (univ-field 'exponent 'f64))
      "\n"
      '()
      (lambda (ctx)
        (case (target-name (ctx-target ctx))
          ((js)
           "
            var steps = Math.min(3, Math.ceil(Math.abs(exponent) / 1023));
            var result = mantissa;
            for (var i = 0; i < steps; i++)
              result *= Math.pow(2, Math.floor((exponent + i) / steps));
            return result;
           ")
          (else
           (compiler-internal-error
            "univ-rtlib-feature ldexp, unknown target"))))))

    (else
     (compiler-internal-error
      "univ-rtlib-feature, unknown runtime system feature" feature))))

(define (univ-get-time ctx)
  (case (target-name (ctx-target ctx))
    ((js)     (^call-prim (^member (^new 'Date) 'getTime)))
    ((php)    (^call-prim 'microtime (^bool #t)))
    ((python) (^call-prim (^member 'time 'time)))
    ((ruby)   (^new 'Time))
    ((java)   (^call-prim (^member 'System 'currentTimeMillis)))))

(define (univ-entry-defs ctx mods-and-flags)
  (case (target-name (ctx-target ctx))

    ((java)
     (univ-main-defs
      ctx
      (lambda (ctx)
        (map (lambda (mod-and-flags)
               (^expr-statement
                (^new (^prefix-class (scheme-id->c-id (car mod-and-flags))))))
             mods-and-flags))))

    (else
     (univ-make-empty-defs))))

(define (univ-main-defs ctx gen-body)
  (case (target-name (ctx-target ctx))

    ((js php python ruby)
     (univ-add-init
      (univ-make-empty-defs)
      gen-body))

    ((java)
     (univ-add-method
      (univ-make-empty-defs)
      (univ-method
       'main
       '(public)
       'noresult
       (list (univ-field 'args '(array str)))
       '()
       (univ-emit-fn-body
        ctx
        "\n"
        gen-body))))

    (else
     (compiler-internal-error
      "univ-main-defs, unknown target"))))

(define (univ-rtlib-init ctx mods-and-flags)

  ;; automatically defined global variables
  (univ-glo-use ctx '##vm-main-module-id 'wr)
  (univ-glo-use ctx '##program-descr 'wr)

  (^expr-statement
   (^call-prim
    (^rts-method-use 'module_registry_init)
    (^array-literal
     'modlinkinfo
     (map-index
      (lambda (x i)
        (let ((name (car x)))
          (univ-glo-use ctx
                        (string->symbol
                         (string-append module-prefix name))
                        'rd)
          (^new (^type 'modlinkinfo) (^str name) (^int i))))
      mods-and-flags)))))

(define (univ-rtlib-defs ctx init)
  (univ-add-init
   (univ-rtlib-gen ctx)
   (lambda (ctx)
     init)))

(define (univ-rtlib-gen ctx)

  (define (topological-sort graph)
    (if (null? graph)
        '()
        (let* ((nodes-to-remove (independent-nodes graph))
               (to-remove (map car nodes-to-remove)))
          (append nodes-to-remove
                  (topological-sort
                   (map (lambda (x)
                          (list (car x)
                                (diff (cadr x) to-remove)
                                (caddr x)))
                        (keep (lambda (x)
                                (not (memq (car x) to-remove)))
                              graph)))))))

  (define (independent-nodes graph)
    (keep (lambda (x) (null? (cadr x))) graph))

  (define (diff lst1 lst2)
    (keep (lambda (x) (not (memq x lst2))) lst1))

  (let ((used (ctx-rtlib-features-used ctx)))
    (let loop ((feature-defs '()))
      (let ((feature (resource-set-pop used)))
        (if feature

            (let ((new-used (make-resource-set)))
              (ctx-rtlib-features-used-set! ctx new-used)
              (let* ((defs
                       (univ-rtlib-feature ctx feature))
                     (used-by-feature
                      (diff
                       (resource-set-stack (ctx-rtlib-features-used ctx))
                       (list feature))))
                (for-each (lambda (f) (resource-set-add! used f))
                          used-by-feature)
                (loop (cons (list feature used-by-feature defs)
                            feature-defs))))

            (univ-defs-combine-list
             (map caddr (topological-sort feature-defs))))))))

(define (univ-source-file-header targ-name)
   (case targ-name

     ((js java)
      "")

     ((php)
      "<?php\n")

     ((python)
      "#! /usr/bin/python\n")

     ((ruby)
      "# encoding: utf-8\n")

     (else
      (compiler-internal-error
       "univ-source-file-header, unknown target"))))

(define (univ-source-file-footer targ-name)
   (case targ-name

     ((js java python ruby)
      "")

     ((php)
      "?>")

     (else
      (compiler-internal-error
       "univ-source-file-footer, unknown target"))))

 (define (univ-link-info-prefix targ-name)
  (string-append
   (univ-source-file-header targ-name)
   (univ-single-line-comment-prefix targ-name)
   " File generated by Gambit "
   (compiler-version-string)
   "\n"
   (univ-single-line-comment-prefix targ-name)
   " Link info: "))

(define (univ-external-libs ctx)
  (case (target-name (ctx-target ctx))

    ((js php ruby)
     (^))

    ((python)
     (^ "from array import array\n"
        "import ctypes\n"
        "import time\n"
        "import math\n"
        "import sys\n"
        "\n"))

    ((java)
     (^ "import java.util.Arrays;\n"
        "import java.util.HashMap;\n"
        "import java.lang.System;\n"
        "\n"))

    (else
     (compiler-internal-error
      "univ-external-libs, unknown target"))))

#|
//JavaScript toString method:
gambit_Pair.prototype.toString = function () {
  return this.car.toString() + this.car.toString();
};

/* PHP toString method: */
  public function __toString() {
    return $this->car . $this->cdr;
  }

# Python toString method:
  def __str__(self):
    return self.car + self.cdr

# Ruby toString method:
  def to_s
    @car.to_s + @cdr.to_s
  end
|#

;;;============================================================================
