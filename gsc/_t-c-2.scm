;;;============================================================================

;;; File: "_t-c-2.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

'(begin;**************brad
(##include "../gsc/_utilsadt.scm")
(##include "../gsc/_ptree1adt.scm")
(##include "../gsc/_gvmadt.scm")
(##include "../gsc/_hostadt.scm")
)

;;;----------------------------------------------------------------------------
;;
;; Back end for C language (part 2)
;; -----------------------

(define (targ-scan-procedure obj c-decls-queue)
  (let* ((proc (car obj))
         (p (cdr obj)))

    (if targ-info-port
      (begin
        (display "  #<" targ-info-port)
        (if (proc-obj-primitive? proc)
          (display "primitive " targ-info-port)
          (display "procedure " targ-info-port))
        (write (string->canonical-symbol (proc-obj-name proc)) targ-info-port)
        (display ">" targ-info-port)))

    (set! targ-proc-unique-name        (targ-unique-name proc))
    (set! targ-proc-code               (make-stretchable-vector #f))
    (set! targ-proc-code-length        0)
    (set! targ-proc-rd-res             (make-stretchable-vector #f))
    (set! targ-proc-wr-res             (make-stretchable-vector #f))
    (set! targ-proc-lbl-tbl            (queue-empty))
    (set! targ-proc-lbl-tbl-ord        (queue-empty))
    (set! targ-debug-info-state        (make-debug-info-state))

    (if (proc-obj-primitive? proc)
        (targ-use-obj (string->symbol (proc-obj-name proc))))

;;    (targ-repr-begin-proc!)

    (let ((x (proc-obj-code proc)))
      (if (bbs? x)
        (targ-scan-scheme-procedure x c-decls-queue)
        (targ-scan-c-procedure x c-decls-queue)))

;;    (targ-repr-end-proc!)

    (targ-cell-set! (caddr p) (+ targ-lbl-alloc 1))

    ; Assign label numbers sequentially, starting with "value" labels
    ; and then "goto" labels

    (let ((ord-lbls (queue->list targ-proc-lbl-tbl-ord)))
      (let loop2 ((l ord-lbls) (i 0) (val-lbls '()))
        (if (pair? l)
          (let ((x (car l)))
            (if (targ-lbl-val? x)
              (begin
                (targ-cell-set! (targ-lbl-num x) i)
                (loop2 (cdr l) (+ i 1) (cons x val-lbls)))
              (loop2 (cdr l) i val-lbls)))
          (let ((info (debug-info-generate targ-debug-info-state
                                           (lambda (i) i)
                                           targ-sharing-table)))
            (targ-use-obj info)
            (set! targ-lbl-alloc (+ targ-lbl-alloc (+ i 1)))
            (set-car! p
              (vector targ-proc-code
                      (reverse val-lbls)
                      targ-proc-rd-res
                      targ-proc-wr-res
                      info))
            (let loop3 ((l ord-lbls) (i i))
              (if (pair? l)
                (let ((x (car l)))
                  (if (and (targ-lbl-goto? x)
                           (not (targ-lbl-val? x)))
                    (begin
                      (targ-cell-set! (targ-lbl-num x) i)
                      (loop3 (cdr l) (+ i 1)))
                    (loop3 (cdr l) i)))))))))

    (if targ-info-port
      (newline targ-info-port))

    ))

(define (targ-scan-scheme-procedure bbs c-decls-queue)

  (set! targ-proc-entry-lbl   (bbs-entry-lbl-num bbs))
  (set! targ-proc-lbl-counter (make-counter (bbs-next-lbl-num bbs)))

  (let loop ((prev-bb #f)
             (prev-gvm-instr #f)
             (l (bbs->code-list bbs)))
    (if (not (null? l))
      (let ((pres-bb (code-bb (car l)))
            (pres-gvm-instr (code-gvm-instr (car l)))
            (pres-slots-needed (code-slots-needed (car l)))
            (next-gvm-instr (if (null? (cdr l))
                              #f
                              (code-gvm-instr (cadr l)))))

        (targ-gen-gvm-instr prev-gvm-instr
                            pres-gvm-instr
                            next-gvm-instr
                            pres-slots-needed)

        (loop pres-bb pres-gvm-instr (cdr l))))))

(define (targ-scan-c-procedure c-proc c-decls-queue)

  (define (ps-opnd opnd)
    (cond ((reg? opnd)
           (let ((n (reg-num opnd)))
             (cons 'psr n)))
          (else ; must be stack slot
           (list "PSSTK" (- (stk-num opnd) targ-proc-fp)))))

  (let* ((arity (c-proc-arity c-proc))
         (pc (targ-label-info arity #f))
         (pc-map (pcontext-map pc))
         (pc-fs (pcontext-fs pc))
         (ret (cdr (assq 'return pc-map)))
         (fs (+ arity 1))
         (lbl 2))

    (set! targ-proc-entry-lbl 1)

    (targ-start-bb pc-fs)

    (set! targ-proc-entry-frame targ-proc-exit-frame);********** for targ-update-fr but probably not needed since it can't be called from here!
    (targ-begin-fr) ; ************* not needed either

    (targ-emit-label-entry targ-proc-entry-lbl arity #f)
    (targ-ref-lbl-goto targ-proc-entry-lbl)

    (targ-emit (list "IF_NARGS_EQ" arity '("NOTHING")))
    (targ-emit (list "WRONG_NARGS"
                     (targ-ref-lbl-val targ-proc-entry-lbl)
                     arity 0 0))
    (targ-emit (list 'append
                     (list "DEF_GLBL"
                           (targ-make-glbl "" targ-proc-unique-name))
                     #\newline))

;;    (targ-repr-begin-block! 'entry targ-proc-entry-lbl)

    ; move arguments from registers to stack frame

    (let loop1 ((i 1))
      (if (and (<= i arity) (<= i (targ-nb-arg-regs)))
        (begin
          (targ-emit
            (targ-loc (make-stk (+ pc-fs i)) (targ-opnd (make-reg i))))
          (loop1 (+ i 1)))))

    ; store return address at top of stack frame

    (targ-emit
      (targ-loc (make-stk fs) (targ-opnd ret)))

;(targ-emit (targ-loc (make-stk (+ fs 1)) (targ-opnd (make-obj 1234567))));*********************
;(targ-emit (targ-loc (make-stk (+ fs 2)) (targ-opnd (make-obj 1234567))))
;(targ-emit (targ-loc (make-stk (+ fs 3)) (targ-opnd (make-obj 1234567))))
;(targ-emit (targ-loc (make-stk (+ fs 4)) (targ-opnd (make-obj 1234567))))

    ; setup new return address

    (targ-emit
      (targ-loc ret (targ-opnd (make-lbl lbl))))

    (targ-emit
      (targ-adjust-stack (targ-align-frame (+ fs targ-frame-reserve))))

    (let ((code (list 'append (c-proc-body c-proc))))
      (if targ-inline-c-proc? ;; should C code be inlined?

          ;; put C code inline with compiled Scheme code
          (begin
            (targ-emit
             (list 'append
                   "#define " c-id-prefix "CFUN_SELECT(inl,ool)inl"
                   #\newline))
            (targ-emit code)
            (targ-emit
             (list 'append
                   "#undef " c-id-prefix "CFUN_SELECT"
                   #\newline)))

          ;; put C code in its own C function (this avoids issues with
          ;; setjmp interfering with C TCO)
          (let ((c-name (c-proc-c-name c-proc)))
            (queue-put! c-decls-queue
                        (list 'append
                              "#define " c-id-prefix "CFUN_SELECT(inl,ool)ool"
                              #\newline
                              code
                              "#undef " c-id-prefix "CFUN_SELECT"
                              #\newline))
            (targ-emit
             (list "CFUN_OOL" c-name)))))

    (targ-emit
      (list "JUMPRET"
            (targ-opnd return-addr-reg)))

;;    (targ-repr-exit-block! #f)

;;    (targ-repr-end-block!)

    (targ-emit-label-return lbl fs (- fs 1) (targ-build-gc-map-all-live fs) #f)

;;    (targ-repr-begin-block! 'return lbl)

    (targ-emit (targ-adjust-stack 0))

;;    (targ-repr-exit-block! #f)

    (targ-emit
      (list "JUMPRET"
            (targ-opnd (make-stk fs))))

;;    (targ-repr-end-block!)
))

(define targ-inline-c-proc? #f)

;;;----------------------------------------------------------------------------

;; Information attached to a procedure

(define targ-proc-unique-name     #f) ; procedure's unique name
(define targ-proc-code            #f) ; code of the procedure
(define targ-proc-code-length     #f) ; length of code of the procedure
(define targ-proc-entry-lbl       #f) ; entry label
(define targ-proc-lbl-counter     #f) ; label counter
(define targ-proc-rd-res          #f) ; set of resources read from
(define targ-proc-wr-res          #f) ; set of resources written to
(define targ-proc-lbl-tbl         #f) ; table of all labels
(define targ-proc-lbl-tbl-ord     #f) ; table of all labels ordered by def time
(define targ-proc-fp              #f) ; frame pointer
(define targ-proc-heap-reserved   #f) ; heap space reserved
(define targ-proc-ssb-reserved    #f) ; SSB space reserved

(define targ-debug-info-state     #f) ; debug information accumulator

(define targ-proc-instr-node      #f)
(define targ-proc-entry-frame     #f)
(define targ-proc-exit-frame      #f)

;; Emit a piece of code

(define (targ-emit code)
  (stretchable-vector-set! targ-proc-code targ-proc-code-length code)
  (set! targ-proc-code-length (+ targ-proc-code-length 1)))

;; Emit a label

(define (targ-emit-label-simp lbl)
  (targ-emit-label lbl #f #f))

(define (targ-emit-label-entry lbl nb-parms label-descr)
  (targ-emit-label lbl 'proc (vector nb-parms -1)))

(define (targ-emit-label-subproc lbl nb-parms nb-closed label-descr)
  (targ-emit-label lbl 'proc (vector nb-parms nb-closed)))

(define (targ-emit-label-return lbl fs link gc-map label-descr)
  (targ-emit-label lbl 'return (vector 'normal fs link gc-map)))

(define (targ-emit-label-return-task lbl fs link gc-map label-descr)
  (targ-emit-label lbl 'return (vector 'task fs link gc-map)))

(define (targ-emit-label-return-internal lbl fs link gc-map label-descr)
  (targ-emit-label lbl 'return (vector 'internal fs link gc-map)))

;; Add a label to the code stream

(define (targ-emit-label lbl class info)
  (let ((x (targ-get-lbl lbl)))
    (targ-emit (cons 'label x))
    (targ-add-label x class info)))

(define (targ-add-label lbl-struct class info)
  (vector-set! lbl-struct 2 class)
  (vector-set! lbl-struct 3 info)
  (queue-put! targ-proc-lbl-tbl-ord lbl-struct))

;; Add label "n" to label table and return label object

(define (targ-get-lbl n)
  (let ((x (assq n (queue->list targ-proc-lbl-tbl))))
    (if x
      (cdr x)
      (let ((y (vector (targ-make-cell #f) ; eventual label number (set later)
                       #f                  ; used as a "goto" label?
                       #f                  ; class (not #f if "value" label)
                       #f)))               ; extra info if "value" label
        (queue-put! targ-proc-lbl-tbl (cons n y))
        y))))

(define (targ-lbl-num lbl-struct)
  (vector-ref lbl-struct 0))

;; Mark a label as referenced for "value" and return eventual label number

(define (targ-ref-lbl-val n)
  (let ((x (targ-get-lbl n)))
    (targ-lbl-num x)))

(define (targ-lbl-val? lbl-struct)
  (vector-ref lbl-struct 2))

;; Mark a label as target for "goto" and return eventual label number

(define (targ-ref-lbl-goto n)
  (let ((x (targ-get-lbl n)))
    (vector-set! x 1 #t)
    (targ-make-glbl (targ-lbl-num x) targ-proc-unique-name)))

(define (targ-lbl-goto? lbl-struct)
  (vector-ref lbl-struct 1))

(define (targ-make-glbl n name)
  (list 'glbl n name))

;; To generate new, unique labels

(define (targ-new-lbl)
  (targ-proc-lbl-counter))

(define (targ-heap-reserve space)
  (set! targ-proc-heap-reserved (+ targ-proc-heap-reserved space)))

(define (targ-heap-reserve-and-check space sn)
  (targ-heap-reserve space)
  (if (> (+ targ-proc-heap-reserved
            (* (targ-fp-cache-size) targ-flonum-space))
         targ-msection-fudge)
    (targ-update-fr-and-check-heap space sn)))

(define (targ-update-fr-and-check-heap space sn)
  (targ-update-fr targ-proc-entry-frame)
  (targ-check-conditions space #f #f sn))

(define (targ-ssb-reserve space)
  (set! targ-proc-ssb-reserved (+ targ-proc-ssb-reserved space)))

(define (targ-ssb-reserve-and-check space sn)
  (targ-ssb-reserve space)
  (if (> targ-proc-ssb-reserved
         targ-ssb-preallocated)
      (targ-check-conditions #f 0 #f sn)))

(define targ-ssb-preallocated 0) ;; number of SSB entries that are free upon
                                 ;; entry to a basic-block

(define targ-combine-checks? #f) ;;TODO: remove when transition to combined checks

(define (targ-check-conditions heap ssb poll sn)
  (if (or heap ssb poll)
      (let ((lbl (targ-new-lbl)))

        (if heap (targ-need-heap))
        (if ssb (targ-need-ssb))
        (if poll (targ-rd-fp))

        (targ-emit (targ-adjust-stack sn))

;;        (targ-repr-exit-block! lbl)

        (targ-emit
         (append (list (string-append
                        (if targ-combine-checks? ;;TODO: remove when transition to combined checks
                            "CHECK"
                            (if poll "POLL" "CHECK"))
                        (if heap "_HEAP" "")
                        (if ssb "_SSB" "")
                        (if (and poll targ-combine-checks?) "_POLL" "") ;;TODO: change when transition to combined checks
                        )
                       (targ-ref-lbl-val lbl))
                 (if heap (list (+ targ-msection-fudge heap)) '()) ;; TODO: why addition of targ-msection-fudge?
                 (if ssb (list ssb) '())))

;;        (targ-repr-end-block!)

        (targ-gen-label-return* lbl 'return-internal)

        (if heap (set! targ-proc-heap-reserved 0))
        (if ssb (set! targ-proc-ssb-reserved 0)))))

(define (targ-start-bb fs)
  (set! targ-proc-heap-reserved 0)
  (set! targ-proc-ssb-reserved 0)
  (set! targ-proc-fp fs))

(define (targ-begin-fr) ; start of a floating point region
  (targ-fp-cache-init))

(define (targ-update-fr frame)
  (let* ((live
          (frame-live frame))
         (any-closed-live?
          (varset-intersects?
            live
            (list->varset (frame-closed frame)))))

    (define (live? var)
      (or (varset-member? var live)
          (and (eq? var closure-env-var) any-closed-live?)))

    (let loop1 ((i 1) (l (reverse (frame-slots frame))))
      (if (pair? l)
        (begin
          (if (live? (car l))
            (targ-fp-cache-write-if-dirty (make-stk i)))
          (loop1 (+ i 1) (cdr l)))
        (let loop2 ((i 0) (l (frame-regs frame)))
          (if (pair? l)
            (begin
              (if (live? (car l))
                (targ-fp-cache-write-if-dirty (make-reg i)))
              (loop2 (+ i 1) (cdr l)))))))))

;; Management of resources

(define targ-nb-non-reg-res 2)

(define (targ-res-op i op)
  (let ((x (if (< i targ-nb-non-reg-res)
             (cons op (vector-ref '#("HEAP" "FP") i))
             (let ((j (- i targ-nb-non-reg-res)))
               (if (< j (targ-nb-gvm-regs))
                 (cons op (string-append "R" (number->string j)))
                 (if (eq? op 'd-)
                   (let ((k (- j (targ-nb-gvm-regs))))
                     (list "D_F64"
                           (targ-unboxed-index->code k)))
                   #f))))))
    (and x (list 'append " " x))))

(define (targ-unboxed-loc->index loc)
  (cond ((reg? loc)
         (reg-num loc))
        ((stk? loc)
         (+ (- (stk-num loc) 1) (targ-nb-gvm-regs)))
        (else
         (compiler-internal-error
           "targ-unboxed-loc->index, invalid 'loc'" loc))))

(define targ-use-fresh-fp-vars? #f)
(set! targ-use-fresh-fp-vars? #t)

(define (targ-unboxed-index->code i)
  (targ-need-unboxed i)
  (cond (targ-use-fresh-fp-vars?
         (list (string-append
                "F64V"
                (number->string i))))
        ((< i (targ-nb-gvm-regs))
         (list (string-append
                "F64R"
                (number->string i))))
        (else
         (list (string-append
                "F64STK"
                (number->string (+ (- i (targ-nb-gvm-regs)) 1)))))))

(define (targ-unboxed-loc->code loc stamp)
  (targ-unboxed-index->code
    (if targ-use-fresh-fp-vars?
      stamp
      (targ-unboxed-loc->index loc))))

(define (targ-rd-res i)
  (stretchable-vector-set! targ-module-rd-res i #t)
  (stretchable-vector-set! targ-proc-rd-res i #t))

(define (targ-wr-res i)
  (targ-rd-res i)
  (stretchable-vector-set! targ-module-wr-res i #t)
  (stretchable-vector-set! targ-proc-wr-res i #t))

(define (targ-need-heap)
  (targ-wr-res 0))

(define (targ-need-ssb)
  (targ-wr-res 0));;;;;;;;;;;;;;;;;;;;;;;;;;;;TODO: FIX

(define (targ-rd-fp)
  (targ-rd-res 1))

(define (targ-wr-fp)
  (targ-wr-res 1))

(define (targ-rd-reg n)
  (targ-rd-res (+ n targ-nb-non-reg-res)))

(define (targ-wr-reg n)
  (targ-wr-res (+ n targ-nb-non-reg-res)))

(define (targ-need-unboxed n)
  (targ-wr-res
    (+ n (+ targ-nb-non-reg-res (targ-nb-gvm-regs)))))

(define (targ-use-all-res)
  (let loop ((i (- (+ targ-nb-non-reg-res (targ-nb-gvm-regs)) 1)))
    (if (>= i 0)
      (begin
        (targ-wr-res i)
        (loop (- i 1))))))

(define (targ-pop-pcontext pc)
  (for-each
   (lambda (x)
     (let ((opnd (cdr x)))
       (cond ((reg? opnd)
              (let ((n (reg-num opnd)))
                (targ-rd-reg n)))
             ((stk? opnd)
              (targ-rd-fp)
              (targ-wr-fp))
             (else
              (compiler-internal-error
               "targ-pop-pcontext, unknown 'opnd'" opnd)))))
   (pcontext-map pc)))

(define (targ-push-pcontext pc)
  (for-each
   (lambda (x)
     (let ((opnd (cdr x)))
       (cond ((reg? opnd)
              (let ((n (reg-num opnd)))
                (targ-wr-reg n)))
             ((stk? opnd)
              (targ-rd-fp)
              (targ-wr-fp))
             (else
              (compiler-internal-error
               "targ-push-pcontext, unknown 'opnd'" opnd)))))
   (pcontext-map pc)))

;;;----------------------------------------------------------------------------

(define (targ-gen-gvm-instr prev-gvm-instr gvm-instr next-gvm-instr sn)

  (define (next-lbl)
    (if (and next-gvm-instr
             (memq (label-type next-gvm-instr)
                   '(simple task-entry)))
        (label-lbl-num next-gvm-instr)
        #f))

  (set! targ-proc-instr-node
    (comment-get (gvm-instr-comment gvm-instr) 'node))
  (set! targ-proc-exit-frame
    (gvm-instr-frame gvm-instr))
  (set! targ-proc-entry-frame
    (and prev-gvm-instr (gvm-instr-frame prev-gvm-instr)))

;;  (write-gvm-instr gvm-instr (current-output-port))(newline);*************

  (if targ-track-scheme-option?
    (let* ((src (node-source targ-proc-instr-node))
           (x (locat-filename-and-line (and src (source-locat src))))
           (filename (car x))
           (line (cdr x)))
      (if (< 0 (string-length filename))
        (targ-emit
         (list 'line line filename)))))

  (case (gvm-instr-type gvm-instr)

    ((label)
     (set! targ-proc-entry-frame targ-proc-exit-frame)
     (targ-start-bb (frame-size targ-proc-exit-frame))
     (case (label-type gvm-instr)
       ((simple)
        (targ-gen-label-simple (label-lbl-num gvm-instr)
                               sn))
       ((entry)
        (targ-gen-label-entry (label-lbl-num gvm-instr)
                              (label-entry-nb-parms gvm-instr)
                              (label-entry-opts gvm-instr)
                              (label-entry-keys gvm-instr)
                              (label-entry-rest? gvm-instr)
                              (label-entry-closed? gvm-instr)
                              sn))
       ((return)
        (targ-gen-label-return (label-lbl-num gvm-instr)
                               sn))
       ((task-entry)
        (targ-gen-label-task-entry (label-lbl-num gvm-instr)
                                   sn))
       ((task-return)
        (targ-gen-label-task-return (label-lbl-num gvm-instr)
                                    sn))
       (else
        (compiler-internal-error
          "targ-gen-gvm-instr, unknown label type"))))

    ((apply)
     (if (not (targ-apply-ifjump-optimization? gvm-instr next-gvm-instr))
         (targ-gen-apply (apply-prim gvm-instr)
                         (apply-opnds gvm-instr)
                         (apply-loc gvm-instr)
                         sn)))

    ((copy)
     (targ-gen-copy (copy-opnd gvm-instr)
                    (copy-loc gvm-instr)
                    sn))

    ((close)
     (targ-gen-close (close-parms gvm-instr)
                     sn))

    ((ifjump)
     (let ((test (ifjump-test gvm-instr))
           (opnds (ifjump-opnds gvm-instr))
           (true (ifjump-true gvm-instr))
           (false (ifjump-false gvm-instr))
           (poll? (ifjump-poll? gvm-instr)))
       (if (targ-apply-ifjump-optimization? prev-gvm-instr gvm-instr)
           (let ((not? (eq? test **not-proc-obj)))
             (targ-gen-ifjump (apply-prim prev-gvm-instr)
                              (apply-opnds prev-gvm-instr)
                              (apply-loc prev-gvm-instr)
                              not?
                              (if not? false true)
                              (if not? true false)
                              poll?
                              (next-lbl)))
           (targ-gen-ifjump test
                            opnds
                            #f ;; loc
                            #f ;; not?
                            true
                            false
                            poll?
                            (next-lbl)))))

    ((switch)
     (targ-gen-switch (switch-opnd gvm-instr)
                      (switch-cases gvm-instr)
                      (switch-default gvm-instr)
                      (switch-poll? gvm-instr)
                      (next-lbl)))

    ((jump)
     (targ-gen-jump (jump-opnd gvm-instr)
                    (jump-ret gvm-instr)
                    (jump-nb-args gvm-instr)
                    (jump-poll? gvm-instr)
                    (jump-safe? gvm-instr)
                    (next-lbl)))

    (else
     (compiler-internal-error
       "targ-gen-gvm-instr, unknown 'gvm-instr'" gvm-instr))))

(define (targ-apply-ifjump-optimization? gvm-instr1 gvm-instr2)

  ;; check for the pattern:
  ;;
  ;;    loc = (prim ...)         <- gvm-instr1
  ;;    if loc ...               <- gvm-instr2

  (and (eq? (gvm-instr-type gvm-instr1) 'apply)
       (eq? (gvm-instr-type gvm-instr2) 'ifjump)
       (let* ((prim (apply-prim gvm-instr1))
              (x (proc-obj-test prim)))
         (and x
              (vector-ref x 2))) ;; primitive optimizable in apply-ifjump
       (let ((test (ifjump-test gvm-instr2)))
         (or (eq? test **identity-proc-obj)
             (eq? test **not-proc-obj)))
       (let ((opnds (ifjump-opnds gvm-instr2)))
         (and (pair? opnds)
              (null? (cdr opnds))
              (eqv? (apply-loc gvm-instr1)
                    (car opnds))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-label-simple lbl sn)
  (targ-emit-label-simp lbl)
  (targ-begin-fr)
;;  (targ-repr-begin-block! 'simple lbl)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-label-entry lbl nb-parms opts keys rest? closed? sn)

  (let ((label-descr
         (debug-info-add!
          targ-debug-info-state
          targ-proc-instr-node
          '()
          targ-proc-exit-frame)))
    (if (= lbl targ-proc-entry-lbl)
      (begin
        (targ-emit-label-entry lbl nb-parms label-descr)
        (targ-ref-lbl-val lbl)
        (targ-ref-lbl-goto lbl))
      (let ((nb-closed (length (frame-closed targ-proc-exit-frame))));******
        (targ-emit-label-subproc lbl nb-parms (if closed? nb-closed -1) label-descr))))

  (let* ((nb-parms-except-rest
          (- nb-parms (if rest? 1 0)))
         (nb-keys
          (if keys (length keys) 0))
         (nb-req-and-opt
          (- nb-parms-except-rest nb-keys))
         (nb-opts
          (length opts))
         (nb-req
          (- nb-req-and-opt nb-opts))
         (lbl*
          (targ-ref-lbl-val lbl))
         (defaults
          (append opts (map cdr (or keys '())))))

    (define (make-key-descriptor)
      (let loop ((lst1 keys) (lst2 '()))
        (if (null? lst1)
          (list->vect (reverse lst2))
          (let ((key (car lst1)))
            (loop (cdr lst1)
                  (cons (obj-val (cdr key)) (cons (car key) lst2)))))))

    (define (dispatch-on-nb-args nb-args)
      (if (> nb-args nb-req-and-opt)

        (targ-emit
         (if keys
           (list (if rest?
                   (if (eq? rest? 'dsssl)
                       "GET_REST_KEY"
                       "GET_KEY_REST")
                   "GET_KEY")
                 lbl* nb-req nb-opts nb-keys
                 (targ-use-obj (make-key-descriptor)))
           (list (if rest? "GET_REST" "WRONG_NARGS")
                 lbl* nb-req nb-opts nb-keys)))

        (let ((nb-stacked (max 0 (- nb-args (targ-nb-arg-regs))))
              (nb-stacked* (max 0 (- nb-parms (targ-nb-arg-regs)))))

          (define (setup-parameter i)
            (if (<= i nb-parms)
              (let* ((rest (setup-parameter (+ i 1)))
                     (src-reg (- i nb-stacked))
                     (src (cond ((<= i nb-args)
                                 (cons 'r src-reg))
                                ((and rest? (= i nb-parms))
                                 '("NUL"))
                                (else
                                 (targ-use-obj
                                  (obj-val
                                   (list-ref defaults (- i nb-req 1))))))))
                (if (<= i nb-stacked*)
                  (begin
                    (if (<= i nb-args) (targ-rd-reg src-reg))
                    (targ-rd-fp)
                    (targ-wr-fp)
                    (cons (list "PUSH" src) rest))
                  (if (and (<= i nb-args) (= nb-stacked nb-stacked*))
                    rest
                    (let ((dst-reg (- i nb-stacked*)))
                      (if (<= i nb-args) (targ-rd-reg src-reg))
                      (targ-wr-reg dst-reg)
                      (cons (list 'set-r dst-reg src) rest)))))
              '()))

          (let ((x (setup-parameter (+ nb-stacked 1))))
            (targ-emit (list "IF_NARGS_EQ"
                             nb-args
                             (if (null? x) '("NOTHING") (cons 'seq x)))))

          (dispatch-on-nb-args (+ nb-args 1)))))

    (dispatch-on-nb-args nb-req)

    (if (= lbl targ-proc-entry-lbl)
      (targ-emit (list 'append
                       (list "DEF_GLBL"
                             (targ-make-glbl "" targ-proc-unique-name))
                       #\newline)))

    (targ-begin-fr)
;;    (targ-repr-begin-block! 'entry lbl)
))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-label-return lbl sn)
  (targ-gen-label-return* lbl 'return))

(define (targ-gen-label-return* lbl kind)
  (let ((frame targ-proc-entry-frame))

    (define (extend-vars l n)
      (cond ((= n 0) l)
            ((< n 0) (extend-vars (cdr l) (+ n 1)))
            (else    (extend-vars (cons empty-var l) (- n 1)))))

    (define (generate fs vars gc-map)
      (let ((label-descr
             (debug-info-add!
              targ-debug-info-state
              targ-proc-instr-node
              vars
              frame))
            (link
             (pos-in-list ret-var vars)))
        (if link
          (begin
            (case kind
              ((return)
               (targ-emit-label-return lbl fs link gc-map label-descr)
;;               (targ-repr-begin-block! 'return lbl)
)
              ((return-task)
               (targ-emit-label-return-task lbl fs link gc-map label-descr)
;;               (targ-repr-begin-block! 'task-return lbl)
)
              ((return-internal)
               (targ-emit-label-return-internal lbl fs link gc-map label-descr)
;;               (targ-repr-begin-block! 'return-internal lbl)
)
              (else
               (compiler-internal-error
                 "targ-gen-label-return*, unknown label kind")))
            (targ-begin-fr))
          (compiler-internal-error
            "targ-gen-label-return*, no return address in frame"))))

    (if (eq? kind 'return-internal)
      (let* ((cfs
              targ-proc-fp)
             (cfs-after-alignment
              (targ-align-frame cfs))
             (regs
              (frame-regs frame))
             (return-var
              (make-temp-var 'return))
             (vars
              (append (reverse (extend-vars (frame-slots frame)
                                            (- cfs-after-alignment
                                               (frame-size frame))))
                      (reverse (extend-vars (reverse regs)
                                            (- (targ-nb-gvm-regs)
                                               (length regs))))
                      (list return-var)
                      (extend-vars '()
                                   (let ((n (+ (targ-nb-gvm-regs) 1)))
                                     (- (targ-align-frame-without-reserve n)
                                        n)))))
             (gc-map
              (targ-build-gc-map
               vars
               (lambda (i var)
                 (or (frame-live? var frame)
                     (let ((j (- i cfs-after-alignment)))
                       (and (>= j 0) ; all saved GVM regs are live
                            (<= j (targ-nb-gvm-regs)))))))))
        (generate cfs vars gc-map))
      (let* ((fs ; remove frame reserve from actual frame size
              (- targ-proc-fp targ-frame-reserve))
             (vars
              (reverse (extend-vars (frame-slots frame)
                                    (- fs (frame-size frame)))))
             (gc-map
              (targ-build-gc-map
               vars
               (lambda (i var)
                 (frame-live? var frame)))))
        (generate fs vars gc-map)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-label-task-entry lbl sn)

  (targ-emit-label-simp lbl)

  (targ-emit (list "TASK_PUSH" 0))

  (targ-begin-fr)
;;  (targ-repr-begin-block! 'task-entry lbl)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-label-task-return lbl sn)
  (let ((lbl2 (targ-new-lbl))
        (fs (frame-size targ-proc-exit-frame)))

    (targ-start-bb fs)

    (targ-gen-label-return* lbl 'return-task)
    (targ-emit (list "TASK_POP" (targ-ref-lbl-val lbl2)))
;;    (targ-repr-exit-block! lbl2)
;;    (targ-repr-end-block!)
    (targ-gen-label-return* lbl2 'return)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-apply prim opnds loc sn)
  (let ((proc (proc-obj-inline prim)))
    (if proc
      (begin
        (proc opnds loc sn)
        (targ-heap-reserve-and-check 0 sn))
      (compiler-internal-error
        "targ-gen-apply, unknown 'prim'" prim))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-copy opnd loc sn)
  (if opnd
    (targ-emit
     (targ-loc loc (targ-opnd opnd)))
;;    (targ-emit (targ-loc loc (targ-opnd (make-obj 1234567))));***********************
)
  (targ-heap-reserve-and-check 0 sn))

'(;;
  (if targ-repr-enabled?

    (if (and (or (reg? opnd) (stk? opnd))
             (or (reg? loc) (stk? loc)))
      (let* ((loc-descrs
              (targ-block-loc-descrs targ-repr-current-block))
             (i
              (targ-repr-loc->index opnd))
             (descr
              (stretchable-vector-ref loc-descrs i))
             (have
              (targ-repr-have-reprs descr)))
        (if (targ-repr-empty? have)

          (targ-emit
            (targ-loc loc (targ-opnd opnd)))

          (let ((j (targ-repr-loc->index loc)))
            (let loop1 ((repr targ-repr-boxed))
              (if (< repr targ-repr-nb-reprs)
                (begin
                  (if (targ-repr-member? repr have)
                    (targ-emit
                      (if (= repr targ-repr-boxed)
                        (targ-repr-loc-boxed loc (targ-repr-opnd-boxed opnd))
                        (let ((type (vector-ref targ-repr-types (- repr 1))))
                          (list (string-append "SET_" type)
                                (targ-repr-unboxed-loc->code loc repr)
                                (targ-repr-unboxed-loc->code opnd repr))))))
                  (loop1 (+ repr 1)))))
            (stretchable-vector-set! loc-descrs j
              (targ-repr-have-reprs-set
                (stretchable-vector-ref loc-descrs j)
                have)))))

      (targ-emit
        (targ-loc loc (targ-opnd opnd))))

    (targ-emit
      (targ-loc loc (targ-opnd opnd)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-close parms sn)

  (define (close parms* sn*)
    (if (pair? parms*)

      (let* ((parm (car parms*))
             (lbl (closure-parms-lbl parm))
             (loc (closure-parms-loc parm))
             (opnds (closure-parms-opnds parm))
             (sn** (targ-sn-opnds opnds sn*)))
        (close (cdr parms*) (targ-sn-loc loc sn**))
        (let* ((x (targ-opnd loc))
               (elements (map targ-opnd opnds))
               (n (length elements)))
          (targ-emit
            (list "BEGIN_SETUP_CLO" n x (targ-ref-lbl-val lbl)))
          (for-each-index (lambda (elem i)
                            (targ-emit
                              (list "ADD_CLO_ELEM" i elem)))
                          elements)
          (targ-emit
            (list "END_SETUP_CLO" n))))

      (begin

        (targ-heap-reserve-and-check
          (apply +
                 (map (lambda (parm)
                        (targ-closure-space
                          (length (closure-parms-opnds parm))))
                      parms))
          sn*)

        (for-each (lambda (parm)
                    (let ((loc (closure-parms-loc parm))
                          (opnds (closure-parms-opnds parm)))
                      (targ-emit
                        (targ-loc loc (list "ALLOC_CLO" (targ-c-unsigned-long (length opnds)))))))
                  parms))))

  (close (reverse parms) sn)

  (targ-heap-reserve-and-check 0 sn))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-ifjump test opnds loc not? true-lbl false-lbl poll? next-lbl)
  (let ((x (proc-obj-test test)))
    (if x

      (let ((args-flo? (vector-ref x 0))
            (proc (vector-ref x 1)))

        (define (gen-if not? branch-lbl fall-lbl)
          (let ((fs (frame-size targ-proc-exit-frame)))
            (if (or (not args-flo?)
                    (begin
                      (targ-update-fr targ-proc-exit-frame)
                      (targ-end-of-block-checks-needed? poll?)))
              (let ((sn (targ-sn-opnds opnds fs)))
                (targ-update-fr targ-proc-entry-frame)
                (targ-end-of-block-checks poll? sn)))
            (targ-emit
              (targ-adjust-stack fs))
            (targ-emit
              (list "IF" (proc not? opnds loc fs)))
;;            (targ-repr-exit-block! branch-lbl)
            (if (and loc not?)
                (targ-emit
                 (targ-loc loc (targ-opnd (make-obj false-object)))))
            (targ-emit
              (list "GOTO" (targ-ref-lbl-goto branch-lbl)))
            (targ-emit
              '("END_IF"))
            (if (and loc (not not?))
                (targ-emit
                 (targ-loc loc (targ-opnd (make-obj false-object)))))
;;            (targ-repr-exit-block! fall-lbl)
            (if (not (eqv? fall-lbl next-lbl))
              (targ-emit
                (list "GOTO" (targ-ref-lbl-goto fall-lbl))))
;;            (targ-repr-end-block!)
))

        (if (eqv? true-lbl next-lbl)
          (gen-if #t false-lbl true-lbl)
          (gen-if #f true-lbl false-lbl)))

      (compiler-internal-error
        "targ-gen-ifjump, unknown 'test'" test))))

(define (targ-end-of-block-checks-needed? poll?)
  (or poll?
      (> targ-proc-heap-reserved 0)
      (> targ-proc-ssb-reserved 0)))

(define (targ-end-of-block-checks poll? sn)
  (if targ-combine-checks? ;;TODO: remove when transition to combined checks

      (targ-check-conditions
       (and (> targ-proc-heap-reserved 0) 0);;;;;;TODO: 0?
       (and (> targ-proc-ssb-reserved 0) 0);;;;;;TODO: 0?
       poll?
       sn)

      (begin
        (if (> targ-proc-heap-reserved 0)
            (targ-check-conditions 0 #f #f sn))
        (if (> targ-proc-ssb-reserved 0)
            (targ-check-conditions #f 0 #f sn))
        (if poll?
            (targ-check-conditions #f #f #t sn)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-switch opnd cases default poll? next-lbl)

  (targ-update-fr targ-proc-entry-frame)

  (let* ((fs (frame-size targ-proc-exit-frame))
         (sn (targ-sn-opnd opnd fs)))

    (targ-end-of-block-checks poll? sn)

    (targ-emit
     (targ-adjust-stack fs))

    (let loop ((lst cases)
               (rev-cases-fixnum '())
               (rev-cases-char '())
               (rev-cases-symbol '())
               (rev-cases-keyword '())
               (rev-cases-other '()))
      (if (pair? lst)

        (let* ((c (car lst))
               (obj (switch-case-obj c)))
          (cond ((targ-fixnum32? obj)
                 (loop (cdr lst)
                       (cons c rev-cases-fixnum)
                       rev-cases-char
                       rev-cases-symbol
                       rev-cases-keyword
                       rev-cases-other))
                ((char? obj)
                 (loop (cdr lst)
                       rev-cases-fixnum
                       (cons c rev-cases-char)
                       rev-cases-symbol
                       rev-cases-keyword
                       rev-cases-other))
                ((symbol-object? obj)
                 (loop (cdr lst)
                       rev-cases-fixnum
                       rev-cases-char
                       (cons c rev-cases-symbol)
                       rev-cases-keyword
                       rev-cases-other))
                ((keyword-object? obj)
                 (loop (cdr lst)
                       rev-cases-fixnum
                       rev-cases-char
                       rev-cases-symbol
                       (cons c rev-cases-keyword)
                       rev-cases-other))
                (else
                 (loop (cdr lst)
                       rev-cases-fixnum
                       rev-cases-char
                       rev-cases-symbol
                       rev-cases-keyword
                       (cons c rev-cases-other)))))

        (let* ((cases-fixnum (reverse rev-cases-fixnum))
               (cases-char (reverse rev-cases-char))
               (cases-symbol (reverse rev-cases-symbol))
               (cases-keyword (reverse rev-cases-keyword))
               (cases-other (reverse rev-cases-other))
               (cases-symkey (append cases-symbol cases-keyword)))

          (define (gen cases begin-macro case-macro end-macro)
            (if (not (null? cases))
              (begin
                (targ-emit (list begin-macro (targ-opnd opnd)))
                (for-each
                 (lambda (c)
                   (targ-emit
                    (list case-macro
                          (targ-use-obj (switch-case-obj c))
                          (targ-ref-lbl-goto (switch-case-lbl c)))))
                 cases)
                (targ-emit (list end-macro)))))

          (if (<= (length cases-fixnum) 2)
            (begin
              (set! cases-other (append cases-fixnum cases-other))
              (set! cases-fixnum '())))

          (if (<= (length cases-char) 2)
            (begin
              (set! cases-other (append cases-char cases-other))
              (set! cases-char '())))

          (gen cases-other
               "BEGIN_SWITCH"
               "SWITCH_CASE_GOTO"
               "END_SWITCH")

          (gen cases-fixnum
               "BEGIN_SWITCH_FIXNUM"
               "SWITCH_FIXNUM_CASE_GOTO"
               "END_SWITCH_FIXNUM")

          (gen cases-char
               "BEGIN_SWITCH_CHAR"
               "SWITCH_CHAR_CASE_GOTO"
               "END_SWITCH_CHAR")

          (let ((n (length cases-symkey)))
            (cond ((= n 0))
                  ((<= n symkey-switch-as-if-cascade-limit)
                   (let loop ((cases cases-symkey))
                     (if (pair? cases)
                       (let ((c (car cases)))
                         (targ-emit
                          (list "IF_GOTO"
                                (list "EQP"
                                      (targ-opnd opnd)
                                      (targ-use-obj (switch-case-obj c)))
                                (targ-ref-lbl-goto (switch-case-lbl c))))
                         (loop (cdr cases))))))
                  (else
                   (let* ((mod (let loop ((i 1))
                                 (if (> i n)
                                   i
                                   (loop (* i 2)))))
                          (buckets (make-vector mod '())))

                     (for-each
                      (lambda (c)
                        (let* ((obj (switch-case-obj c))
                               (hash (targ-hash
                                      (if (symbol-object? obj)
                                        (symbol->string obj)
                                        (keyword-object->string obj))))
                               (i (modulo hash mod)))
                          (vector-set! buckets
                                       i
                                       (cons c (vector-ref buckets i)))))
                      cases-symkey)

                     (targ-emit
                      (list "BEGIN_SWITCH_SYMKEY"
                            (targ-opnd opnd)
                            mod
                            (list
                             (cond ((null? cases-keyword)
                                    "SYMBOLP")
                                   ((null? cases-symbol)
                                    "KEYWORDP")
                                   (else
                                    "SYMKEYP")))))

                     (let loop ((i 0))
                       (if (< i mod)
                         (begin
                           (targ-emit (list "SWITCH_SYMKEY_CASE" i))
                           (for-each
                            (lambda (c)
                              (targ-emit
                               (list "SWITCH_SYMKEY_CASE_GOTO"
                                     (targ-use-obj (switch-case-obj c))
                                     (targ-ref-lbl-goto (switch-case-lbl c)))))
                            (reverse (vector-ref buckets i)))
                           (targ-emit (list "GOTO" (targ-ref-lbl-goto default)))
                           (loop (+ i 1)))))

                     (targ-emit (list "END_SWITCH_SYMKEY")))))))))

    (if (not (eqv? default next-lbl))
      (targ-emit
       (list "GOTO" (targ-ref-lbl-goto default))))))

(define symkey-switch-as-if-cascade-limit #f)
(set! symkey-switch-as-if-cascade-limit 20)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-jump opnd ret nb-args poll? safe? next-lbl)

  (if ret ;; a return address needs to be passed?
      (begin
        (if (eqv? opnd return-addr-reg) ;; destination in location of ret addr?
            (let ((spare-reg (make-reg (+ (targ-nb-arg-regs) 1))))
              (targ-emit
               (targ-loc spare-reg (targ-opnd opnd)))
              (set! opnd spare-reg)))
        (targ-emit
         (targ-loc return-addr-reg (targ-opnd (make-lbl ret))))))

  (targ-update-fr targ-proc-entry-frame)

  (let ((inlined
         (and (obj? opnd)
              (proc-obj? (obj-val opnd))
              nb-args
              (let* ((proc (obj-val opnd))
                     (jump-inliner (proc-obj-jump-inline proc)))
                (and jump-inliner
                     (jump-inliner nb-args poll? safe?))))))
    (if (not inlined)
      (let* ((fs (frame-size targ-proc-exit-frame))
             (sn (targ-sn-opnd opnd fs))
             (set-nargs (if nb-args (list "SET_NARGS" nb-args) #f)))

        (targ-end-of-block-checks poll? sn)

        (targ-emit
         (targ-adjust-stack fs))

        (cond ((lbl? opnd)
               (let ((n (lbl-num opnd)))
;;                 (targ-repr-exit-block! (if nb-args #f n))
                 (if (and next-lbl (= next-lbl n)) ; fall through?
                   (targ-emit set-nargs)
                   (targ-emit
                     (list 'seq
                           set-nargs
                           (list "GOTO" (targ-ref-lbl-goto n)))))))
              ((and (obj? opnd)
                    (proc-obj? (obj-val opnd))
                    nb-args)
               (let* ((proc (obj-val opnd))
                      (x (targ-use-prc proc #f)))
;;                 (targ-repr-exit-block! #f)
                 (if (not x)
                     (compiler-internal-error
                      "targ-gen-jump, unknown procedure" (proc-obj-name proc))
                     (if (and (not (proc-obj-code proc))
                              (proc-obj-primitive? proc))
                         (targ-emit
                          (list "JUMPPRM"
                                set-nargs
                                x))
                         (let ((name (proc-obj-name proc))
                               (unique-name (targ-unique-name proc)))
                           (if (targ-arg-check-avoidable? proc nb-args)
                               (targ-emit
                                (list "JUMPINT"
                                      set-nargs
                                      x
                                      (targ-make-glbl "" unique-name)))
                               (targ-emit
                                (list 'seq
                                      set-nargs
                                      (list "JUMPINT"
                                            '("NOTHING")
                                            x
                                            (targ-make-glbl 0 unique-name))))))))))
              ((glo? opnd)
;;               (targ-repr-exit-block! #f)
               (let ((name (glo-name opnd)))
                 (targ-wr-reg (+ (targ-nb-arg-regs) 1))
                 (targ-emit
                  (list (if safe? "JUMPGLOSAFE" "JUMPGLONOTSAFE")
                        (if nb-args set-nargs '("NOTHING"))
                        (targ-use-glo name #f)
                        (targ-c-id-glo (symbol->string name))))))
              (else
;;               (targ-repr-exit-block! #f)
               (targ-emit
                (if nb-args
                    (begin
                      (targ-wr-reg (+ (targ-nb-arg-regs) 1))
                      (list (if safe? "JUMPGENSAFE" "JUMPGENNOTSAFE")
                            set-nargs
                            (targ-opnd opnd)))
                    (list "JUMPRET"
                          (targ-opnd opnd))))))

;;        (targ-repr-end-block!)
))))

(define (targ-arg-check-avoidable? proc nb-args)
  (let ((x (proc-obj-call-pat proc)))
    (if (and (pair? x) (null? (cdr x))) ; proc accepts a fixed nb of args?
      (let ((arg-count (car x)))
        (= arg-count nb-args))          ; nb of arguments = nb of parameters?
      #f)))

;;;----------------------------------------------------------------------------

'(;;

(define targ-repr-enabled? #f)
(set! targ-repr-enabled? #t)

(define targ-repr-graph #f)
(define targ-repr-current-block #f)

;; Location representation descriptors.

(define targ-repr-boxed 0) ; must be 0
(define targ-repr-f64   1)

(define targ-repr-nb-reprs 2) ; # of possible representations (including boxed)
(define targ-repr-universal 3) ; (- (expt 2 targ-repr-nb-repr) 1)

(define targ-repr-types ; type name of each unboxed representation
  '#("F64"))

(define targ-repr-have-pos  0) ; bit position of "have" field (must be 0)
(define targ-repr-need-pos  2) ; bit position of "need" field
(define targ-repr-entry-pos 4) ; bit position of "entry" field

(define targ-repr-live1-mask  64) ; live at entry of block
(define targ-repr-live2-mask 128) ; live at exit of block
(define targ-repr-all-mask   255) ; (- (* 2 targ-repr-live2-mask) 1)
(define targ-repr-have-mask  252) ; (- targ-repr-all-mask targ-repr-universal)
(define targ-repr-entry-mask 207) ; (- targ-repr-all-mask
                                  ;    (* (expt 2 targ-repr-entry-pos)
                                  ;       targ-repr-universal))

(define (targ-repr-have-reprs descr)
  (bits-and descr targ-repr-universal))

(define (targ-repr-have-reprs-union descr reprs)
  (bits-or descr reprs))

(define (targ-repr-have-reprs-set descr reprs)
  (bits-or (bits-and descr targ-repr-have-mask) reprs))

(define (targ-repr-need-reprs descr)
  (bits-and (bits-shr descr targ-repr-need-pos) targ-repr-universal))

(define (targ-repr-need-reprs-union descr reprs)
  (bits-or descr (bits-shl reprs targ-repr-need-pos)))

(define (targ-repr-entry-reprs descr)
  (bits-and (bits-shr descr targ-repr-entry-pos) targ-repr-universal))

(define (targ-repr-entry-reprs-set descr reprs)
  (bits-or (bits-and descr targ-repr-entry-mask)
           (bits-shl reprs targ-repr-entry-pos)))

(define (targ-repr-live1-add descr)
  (bits-or descr targ-repr-live1-mask))

(define (targ-repr-live1? descr)
  (not (= (bits-and descr targ-repr-live1-mask) 0)))

(define (targ-repr-live2-add descr)
  (bits-or descr targ-repr-live2-mask))

(define (targ-repr-live2? descr)
  (not (= (bits-and descr targ-repr-live2-mask) 0)))

(define (targ-repr-equal-descr? descr1 descr2)
  (= descr1 descr2))

(define (targ-repr-included-reprs? reprs1 reprs2)
  (= (bits-and reprs1 reprs2) reprs1))

(define (targ-repr-empty)
  0)

(define (targ-repr-empty? reprs)
  (= reprs (targ-repr-empty)))

(define (targ-repr-member? repr reprs)
  (not (= (bits-and reprs (bits-shl 1 repr)) 0)))

(define (targ-repr-singleton repr)
  (bits-shl 1 repr))

(define (targ-repr-intersection reprs1 reprs2)
  (bits-and reprs1 reprs2))

(define (targ-make-block kind lbl entry-cell)
  (vector kind
          lbl
          entry-cell
          '()
          #f
          #f
          (make-stretchable-vector (targ-repr-empty))))

(define (targ-block-kind block)        (vector-ref block 0))
(define (targ-block-lbl block)         (vector-ref block 1))
(define (targ-block-entry-cell block)  (vector-ref block 2))
(define (targ-block-exits block)       (vector-ref block 3))
(define (targ-block-entry-fs block)    (vector-ref block 4))
(define (targ-block-exit-fs block)     (vector-ref block 5))
(define (targ-block-loc-descrs block)  (vector-ref block 6))

(define (targ-block-add-exit! block lbl cell)
  (vector-set! block 3
    (cons (cons lbl cell) (vector-ref block 3))))

(define (targ-block-entry-fs-set! block fs)
  (vector-set! block 4 fs))

(define (targ-block-exit-fs-set! block fs)
  (vector-set! block 5 fs))

(define (targ-repr-begin-proc!)
  (if targ-repr-enabled?
    (set! targ-repr-graph (make-stretchable-vector #f))))

(define (targ-repr-end-proc!)

  (define (compute-reprs-function src)
    (let ((exits (targ-block-exits src)))
      (if (not (null? (cdr exits)))
        (compute-reprs-function-2-known-exits src (caar exits) (caadr exits))
        (if (caar exits)
          (compute-reprs-function-1-known-exit src (caar exits))
          (compute-reprs-function-1-unknown-exit src)))))

  (define (compute-reprs-function-1-unknown-exit src)
    (lambda (src-descr i)
      (targ-repr-singleton targ-repr-boxed)))

  (define (compute-reprs-function-1-known-exit src dst)
    (let* ((dst-loc-descrs (targ-block-loc-descrs dst))
           (src-fs (targ-block-exit-fs src))
           (dst-fs (targ-block-entry-fs dst))
           (offs (- src-fs dst-fs)))
      (lambda (src-descr i)
        (let* ((src-have
                (targ-repr-have-reprs src-descr))
               (src-reprs
                (if (targ-repr-empty? src-have)
                  (targ-repr-need-reprs src-descr)
                  src-have)))
          (if (< i (targ-nb-gvm-regs))
            (let ((dst-descr
                    (stretchable-vector-ref dst-loc-descrs i)))
              (stretchable-vector-set!
                dst-loc-descrs
                i
                (targ-repr-entry-reprs-set
                  dst-descr
                  (targ-repr-intersection
                    (targ-repr-entry-reprs dst-descr)
                    src-reprs)))
              (targ-repr-need-reprs dst-descr))
            (let* ((j
                    (- i offs))
                   (dst-descr
                     (if (>= j (targ-nb-gvm-regs))
                       (stretchable-vector-ref dst-loc-descrs j)
                       0)))
              (if (>= j (targ-nb-gvm-regs))
                (stretchable-vector-set!
                  dst-loc-descrs
                  j
                  (targ-repr-entry-reprs-set
                    dst-descr
                    (targ-repr-intersection
                      (targ-repr-entry-reprs dst-descr)
                      src-reprs))))
              (targ-repr-need-reprs dst-descr)))))))

  (define (compute-reprs-function-2-known-exits src dst1 dst2)
    (let* ((dst1-loc-descrs (targ-block-loc-descrs dst1))
           (dst2-loc-descrs (targ-block-loc-descrs dst2))
           (src-fs (targ-block-exit-fs src))
           (dst1-fs (targ-block-entry-fs dst1))
           (dst2-fs (targ-block-entry-fs dst2))
           (offs1 (- src-fs dst1-fs))
           (offs2 (- src-fs dst2-fs)))
      (lambda (src-descr i)
        (let* ((src-have
                (targ-repr-have-reprs src-descr))
               (src-reprs
                (if (targ-repr-empty? src-have)
                  (targ-repr-need-reprs src-descr)
                  src-have)))
          (if (< i (targ-nb-gvm-regs))
            (let ((dst1-descr
                    (stretchable-vector-ref dst1-loc-descrs i))
                  (dst2-descr
                    (stretchable-vector-ref dst2-loc-descrs i)))
              (stretchable-vector-set!
                dst1-loc-descrs
                i
                (targ-repr-entry-reprs-set
                  dst1-descr
                  (targ-repr-intersection
                    (targ-repr-entry-reprs dst1-descr)
                    src-reprs)))
              (stretchable-vector-set!
                dst2-loc-descrs
                i
                (targ-repr-entry-reprs-set
                  dst2-descr
                  (targ-repr-intersection
                    (targ-repr-entry-reprs dst2-descr)
                    src-reprs)))
              (targ-repr-intersection
                (targ-repr-need-reprs dst1-descr)
                (targ-repr-need-reprs dst2-descr)))
            (let* ((j1
                    (- i offs1))
                   (j2
                    (- i offs2))
                   (dst1-descr
                     (if (>= j1 (targ-nb-gvm-regs))
                       (stretchable-vector-ref dst1-loc-descrs j1)
                       0))
                   (dst2-descr
                     (if (>= j2 (targ-nb-gvm-regs))
                       (stretchable-vector-ref dst2-loc-descrs j2)
                       0)))
              (if (>= j1 (targ-nb-gvm-regs))
                (stretchable-vector-set!
                  dst1-loc-descrs
                  j1
                  (targ-repr-entry-reprs-set
                    dst1-descr
                    (targ-repr-intersection
                      (targ-repr-entry-reprs dst1-descr)
                      src-reprs))))
              (if (>= j2 (targ-nb-gvm-regs))
                (stretchable-vector-set!
                  dst2-loc-descrs
                  j2
                  (targ-repr-entry-reprs-set
                    dst2-descr
                    (targ-repr-intersection
                      (targ-repr-entry-reprs dst2-descr)
                      src-reprs))))
              (targ-repr-intersection
                (targ-repr-need-reprs dst1-descr)
                (targ-repr-need-reprs dst2-descr))))))))

  (define (insert-exit-conversions src dst cell)
    (if dst
      (insert-known-exit-conversions src dst cell)
      (insert-unknown-exit-conversions src cell)))

  (define (insert-unknown-exit-conversions src cell)
    (let ((lst '())
          (src-loc-descrs (targ-block-loc-descrs src))
          (src-fs (targ-block-exit-fs src)))

      (define (conversion i j need-j)
        (let* ((descr-i
                (stretchable-vector-ref src-loc-descrs i))
               (have-i
                (targ-repr-have-reprs descr-i))
               (need-i
                (targ-repr-need-reprs descr-i))
               (reprs-i
                (if (targ-repr-empty? have-i)
                  (if (targ-repr-empty? need-i)
                    (targ-repr-singleton targ-repr-boxed)
                    need-i)
                  have-i))
               (reprs-j
                (if (targ-repr-empty? need-j)
                  (targ-repr-singleton targ-repr-boxed)
                  need-j)))

          (set! targ-proc-fp src-fs)

          (let loop1 ((r (+ targ-repr-boxed 1)))
            (if (< r targ-repr-nb-reprs)
              (begin
                (if (targ-repr-member? r reprs-j) ; needed in this repr?
                  (if (targ-repr-member? r reprs-i) ; already in this repr?
                    (if (not (= i j)) ; copying necessary?
                      (set! lst
                        (cons (targ-repr-unboxed-index-copy i j r)
                              lst)))
                    (set! lst
                      (cons (targ-repr-unboxed-copy
                              (targ-repr-from-boxed
                                (targ-repr-opnd-boxed (targ-repr-index->loc i))
                                r)
                              (targ-repr-unboxed-index->code j r)
                              r)
                            lst))))
                (loop1 (+ r 1)))))

          (if (not (or (targ-repr-included-reprs? reprs-j reprs-i)
                       (targ-repr-member? targ-repr-boxed reprs-i)))
            (let loop2 ((r (+ targ-repr-boxed 1)))
              (if (not (targ-repr-member? r reprs-i))
                (loop2 (+ r 1))
                (set! lst
                  (cons (targ-repr-to-boxed! (targ-repr-index->loc i) r)
                        lst)))))))

      (let loop ((i (- (+ (targ-nb-gvm-regs) src-fs) 1)))
        (if (>= i 0)
          (let ((descr-i (stretchable-vector-ref src-loc-descrs i)))
            (if (targ-repr-live2? descr-i)
              (conversion i i (targ-repr-empty)))
            (loop (- i 1)))))
      (targ-cell-set!
        cell
        (list 'append
              "/* exit representation: "
              (targ-repr-to-string
               src-loc-descrs
               targ-repr-have-reprs
               targ-repr-live2?)
              " */"
              #\newline
              (cons 'seq lst)
              #\newline))))

  (define (insert-known-exit-conversions src dst cell)
    (let* ((lst '())
           (src-loc-descrs (targ-block-loc-descrs src))
           (dst-loc-descrs (targ-block-loc-descrs dst))
           (src-fs (targ-block-exit-fs src))
           (dst-fs (targ-block-entry-fs dst))
           (offs (- src-fs dst-fs)))

      (define (conversion i j need-j)
        (let* ((descr-i
                (stretchable-vector-ref src-loc-descrs i))
               (have-i
                (targ-repr-have-reprs descr-i))
               (need-i
                (targ-repr-need-reprs descr-i))
               (reprs-i
                (if (targ-repr-empty? have-i)
                  (if (targ-repr-empty? need-i)
                    (targ-repr-singleton targ-repr-boxed)
                    need-i)
                  have-i))
               (reprs-j
                (if (targ-repr-empty? need-j)
                  (targ-repr-singleton targ-repr-boxed)
                  need-j)))

          (set! targ-proc-fp src-fs)

          (let loop1 ((r (+ targ-repr-boxed 1)))
            (if (< r targ-repr-nb-reprs)
              (begin
                (if (targ-repr-member? r reprs-j) ; needed in this repr?
                  (if (targ-repr-member? r reprs-i) ; already in this repr?
                    (if (not (= i j)) ; copying necessary?
                      (set! lst
                        (cons (targ-repr-unboxed-index-copy i j r)
                              lst)))
                    (set! lst
                      (cons (targ-repr-unboxed-copy
                              (targ-repr-from-boxed
                                (targ-repr-opnd-boxed (targ-repr-index->loc i))
                                r)
                              (targ-repr-unboxed-index->code j r)
                              r)
                            lst))))
                (loop1 (+ r 1)))))

          (if (not (or (targ-repr-included-reprs? reprs-j reprs-i)
                       (targ-repr-member? targ-repr-boxed reprs-i)))
            (let loop2 ((r (+ targ-repr-boxed 1)))
              (if (not (targ-repr-member? r reprs-i))
                (loop2 (+ r 1))
                (set! lst
                  (cons (targ-repr-to-boxed! (targ-repr-index->loc i) r)
                        lst)))))))

      (let loop ((i (- (+ (targ-nb-gvm-regs) src-fs) 1)))
        (if (>= i 0)
          (let ((j (if (< i (targ-nb-gvm-regs)) i (- i offs))))
            (if (and (>= i (targ-nb-gvm-regs))
                     (< j (targ-nb-gvm-regs)))
              (conversion i i (targ-repr-empty))
              (let ((descr-j (stretchable-vector-ref dst-loc-descrs j)))
                (if (targ-repr-live1? descr-j)
                  (conversion i j (targ-repr-need-reprs descr-j)))))
            (loop (- i 1)))))
      (targ-cell-set!
        cell
        (list 'append
              "/* exit representation: "
              (targ-repr-to-string
               src-loc-descrs
               targ-repr-have-reprs
               targ-repr-live2?)
              " */"
              #\newline
              (cons 'seq lst)
              #\newline))))

  ; preprocess graph to access it faster

  (stretchable-vector-for-each
    (lambda (block lbl)
      (if block
        (for-each ; collapse each label reference to a block
          (lambda (x)
            (if (car x) ; #f indicates an unknown exit block
              (set-car! x
                        (stretchable-vector-ref
                          targ-repr-graph
                          (car x)))))
          (targ-block-exits block))))
    targ-repr-graph)

  (let loop1 ()
    (let ((changed? #f))

      (define (intersect-reprs src)
        (let ((loc-descrs (targ-block-loc-descrs src)))
          (stretchable-vector-for-each
            (lambda (descr i)
              (if (targ-repr-live1? descr)
                (let ((new
                       (targ-repr-need-reprs-union
                         descr
                         (targ-repr-entry-reprs descr))))
                  (stretchable-vector-set!
                    loc-descrs
                    i
                    (if (memq (targ-block-kind src)
                              '(entry return task-entry task-return))
                      new
                      (targ-repr-entry-reprs-set new targ-repr-universal))))))
            loc-descrs)))

      (define (propagate-repr src)
        (let ((compute-reprs (compute-reprs-function src))
              (loc-descrs (targ-block-loc-descrs src)))
          (stretchable-vector-for-each
            (lambda (descr i)
              (if (targ-repr-live2? descr)
                (let ((new
                       (targ-repr-need-reprs-union
                         descr
                         (compute-reprs descr i))))
                  (if (and (targ-repr-empty? (targ-repr-have-reprs descr))
                           (not (targ-repr-equal-descr? new descr)))
                    (begin
                      (set! changed? #t)
                      (stretchable-vector-set! loc-descrs i new))))))
            loc-descrs)))

      (let loop2 ((lbl (- (stretchable-vector-length targ-repr-graph) 1)))
        (if (>= lbl 0)
          (let ((block (stretchable-vector-ref targ-repr-graph lbl)))
            (if block
              (intersect-reprs block))
            (loop2 (- lbl 1)))))

      (let loop3 ((lbl (- (stretchable-vector-length targ-repr-graph) 1)))
        (if (>= lbl 0)
          (let ((block (stretchable-vector-ref targ-repr-graph lbl)))
            (if block
              (propagate-repr block))
            (loop3 (- lbl 1)))))

      (if changed?
        (loop1))))

  (let loop4 ((lbl (- (stretchable-vector-length targ-repr-graph) 1)))
    (if (>= lbl 0)
      (let ((block (stretchable-vector-ref targ-repr-graph lbl)))
        (if block
          (for-each
            (lambda (x)
              (insert-exit-conversions block (car x) (cdr x)))
            (targ-block-exits block)))
        (loop4 (- lbl 1)))))

  (let loop5 ((lbl (- (stretchable-vector-length targ-repr-graph) 1)))
    (if (>= lbl 0)
      (let ((block (stretchable-vector-ref targ-repr-graph lbl)))
        (if block
          (let ((cell (targ-block-entry-cell block)))
            (cond ((memq (targ-block-kind block)
                         '(entry return task-entry task-return))
                   (targ-cell-set!
                     cell
                     (list 'append
                           "/* entry representation: "
                           (targ-repr-to-string
                             (targ-block-loc-descrs block)
                             targ-repr-need-reprs
                             targ-repr-live1?)
                           " */"
                           #\newline
                           (begin
                             (set! targ-proc-fp (targ-block-entry-fs block))
                             (cons 'seq
                                   (targ-repr-setup-need
                                    (targ-block-loc-descrs block))))
                           #\newline)))
                  ((memq (targ-block-kind block)
                         '(return-internal))
                   (targ-cell-set!
                     cell
                     (list 'append
                           "/* entry representation: "
                           (targ-repr-to-string
                             (targ-block-loc-descrs block)
                             targ-repr-need-reprs
                             targ-repr-live1?)
                           " */"
                           #\newline
;;                           (targ-repr-internal-need block)
                           #\newline)))
                  (else
                   (targ-cell-set!
                     cell
                     (list 'append
                           "/* entry representation: "
                           (targ-repr-to-string
                             (targ-block-loc-descrs block)
                             targ-repr-need-reprs
                             targ-repr-live1?)
                           " */"
                           #\newline))))))
        (loop5 (- lbl 1)))))

;;  (targ-emit (list 'append (with-output-to-string (lambda () (pp targ-repr-graph)))))

  (if targ-repr-enabled?
    (set! targ-repr-graph #f))

  #f)


(define (targ-repr-unboxed-copy src dst repr)
  (let ((type (vector-ref targ-repr-types (- repr 1))))
    (list (string-append "SET_" type) dst src)))

(define (targ-repr-unboxed-index-copy src dst repr)
  (targ-repr-unboxed-copy
    (targ-repr-unboxed-index->code src repr)
    (targ-repr-unboxed-index->code dst repr)
    repr))

(define (targ-repr-setup-need loc-descrs)
  (let ((lst '()))
    (stretchable-vector-for-each
      (lambda (descr i)
        (if (targ-repr-live1? descr)
          (let ((need (targ-repr-need-reprs descr)))
            (let ((loc (targ-repr-index->loc i)))
              (let loop ((r (+ targ-repr-boxed 1)))
                (if (< r targ-repr-nb-reprs)
                  (begin
                    (if (targ-repr-member? r need)
                      (set! lst
                        (cons (targ-repr-from-boxed! loc r) lst)))
                    (loop (+ r 1)))))))))
      loc-descrs)
    lst))

(define (targ-repr-internal-need block)
  (set! targ-proc-fp (targ-block-entry-fs block))
  (let ((lst '())
        (loc-descrs (targ-block-loc-descrs block)))
    (set! lst (cons #\newline (cons "END" (cons #\newline lst))))
    (stretchable-vector-for-each
      (lambda (descr i)
        (if (targ-repr-live1? descr)
          (let ((need (targ-repr-need-reprs descr)))
            (let ((loc (targ-repr-index->loc i)))
              (let loop ((r (+ targ-repr-boxed 1)))
                (if (< r targ-repr-nb-reprs)
                  (begin
                    (if (targ-repr-member? r need)
                      (set! lst
                        (cons (targ-repr-from-boxed! loc r) lst)))
                    (loop (+ r 1)))))))))
      loc-descrs)
    (set! lst (cons #\newline (cons "TRAP" (cons #\newline lst))))
    (stretchable-vector-for-each
      (lambda (descr i)
        (if (targ-repr-live1? descr)
          (let ((need (targ-repr-need-reprs descr)))
            (if (not (targ-repr-member? targ-repr-boxed need))
              (let loop2 ((r (+ targ-repr-boxed 1)))
                (if (not (targ-repr-member? r need))
                  (loop2 (+ r 1))
                  (set! lst
                    (cons (targ-repr-to-boxed! (targ-repr-index->loc i) r)
                          lst))))))))
      loc-descrs)
    (set! lst (cons #\newline (cons "BEGIN" (cons #\newline lst))))
    (cons 'seq lst)))

;************
(define (targ-repr-to-string loc-descrs reprs-extract live?)
  (let ((str ""))
    (stretchable-vector-for-each
      (lambda (descr i)
        (if (live? descr)
          (let ((loc (targ-repr-index->loc i))
                (reprs (reprs-extract descr)))
            (set! str
              (string-append
                str
                "  "
                (loc->str loc)
                "="
                (reprs->str reprs))))))
      loc-descrs)
    str))

(define (loc->str loc)
  (if (reg? loc)
    (string-append "R" (number->string (reg-num loc)))
    (string-append "STK" (number->string (stk-num loc)))))

(define (reprs->str reprs)
  (let ((str "{"))
    (let loop ((r targ-repr-boxed) (sep ""))
      (if (< r targ-repr-nb-reprs)
        (if (targ-repr-member? r reprs)
          (begin
            (set! str
              (string-append str
                             sep
                             (if (= r targ-repr-boxed)
                               "boxed"
                               (vector-ref targ-repr-types (- r 1)))))
            (loop (+ r 1) ","))
          (loop (+ r 1) sep))))
    (string-append str "}")))




(define (targ-repr-for-each-live proc frame)
  (let* ((live
          (frame-live frame))
         (any-closed-live?
          (varset-intersects?
            live
            (list->varset (frame-closed frame)))))

    (define (live? var)
      (or (varset-member? var live)
          (and (eq? var closure-env-var) any-closed-live?)))

    (let ((slots (frame-slots frame)))
      (let loop1 ((i (length slots)) (lst slots))
        (if (pair? lst)
          (begin
            (if (live? (car lst))
              (proc (targ-repr-loc->index (make-stk i))))
            (loop1 (- i 1) (cdr lst)))
          (let ((regs (frame-regs frame)))
            (let loop2 ((i 0) (lst regs))
              (if (pair? lst)
                (begin
                  (if (live? (car lst))
                    (proc (targ-repr-loc->index (make-reg i))))
                  (loop2 (+ i 1) (cdr lst)))))))))))

(define (targ-repr-begin-block! kind lbl)
(targ-fp-cache-init);************
  (if targ-repr-enabled?
    (let ((cell (targ-make-cell #f))
          (fs (frame-size targ-proc-exit-frame)))
      (targ-emit cell)
      (set! targ-repr-current-block
        (targ-make-block kind lbl cell))
      (stretchable-vector-set!
        targ-repr-graph
        lbl
        targ-repr-current-block)
      (targ-block-entry-fs-set!
        targ-repr-current-block
        fs)
      (let ((loc-descrs (targ-block-loc-descrs targ-repr-current-block)))
        (if (memq kind
                  '(entry return task-entry task-return))
          (let loop ((i (- (+ (targ-nb-gvm-regs) fs) 1)))
            (if (>= i 0)
              (let ((descr (stretchable-vector-ref loc-descrs i)))
                (stretchable-vector-set!
                  loc-descrs
                  i
                  (targ-repr-need-reprs-union
                    descr
                    (targ-repr-singleton targ-repr-boxed)))
                (loop (- i 1))))))
        (targ-repr-for-each-live
          (lambda (i)
            (stretchable-vector-set!
              loc-descrs
              i
              (targ-repr-live1-add
                (stretchable-vector-ref loc-descrs i))))
          targ-proc-exit-frame)))))

(define (targ-repr-exit-block! lbl)
  (if targ-repr-enabled?
    (let ((cell (targ-make-cell #f)))
      (targ-emit cell)
      (targ-block-add-exit!
        targ-repr-current-block
        lbl
        cell))))

(define (targ-repr-end-block!)
  (if targ-repr-enabled?
    (begin
      (targ-block-exit-fs-set!
        targ-repr-current-block
        (frame-size targ-proc-exit-frame))
      (let ((loc-descrs (targ-block-loc-descrs targ-repr-current-block)))
        (targ-repr-for-each-live
          (lambda (i)
            (stretchable-vector-set!
              loc-descrs
              i
              (targ-repr-live2-add
                (stretchable-vector-ref loc-descrs i))))
          targ-proc-exit-frame))
      (set! targ-repr-current-block #f))))

(define (targ-repr-loc->index loc)
  (cond ((reg? loc)
         (reg-num loc))
        ((stk? loc)
         (+ (- (stk-num loc) 1) (targ-nb-gvm-regs)))
        (else
         (compiler-internal-error
           "targ-repr-loc->index, invalid 'loc'" loc))))

(define (targ-repr-index->loc i)
  (if (< i (targ-nb-gvm-regs))
    (make-reg i)
    (make-stk (+ (- i (targ-nb-gvm-regs)) 1))))

(define (targ-repr-unboxed-index->code i repr)
  (let ((type (vector-ref targ-repr-types (- repr 1))))
    (targ-need-unboxed i repr)
    (if (< i (targ-nb-gvm-regs))
      (list (string-append
              type
              "R"
              (number->string i)))
      (list (string-append
              type
              "STK"
              (number->string (+ (- i (targ-nb-gvm-regs)) 1)))))))

(define (targ-repr-index->code i repr)
  (if (= repr targ-repr-boxed)
    (if (< i (targ-nb-gvm-regs))
      (cons 'r i)
      (list "STK" (- (+ (- i (targ-nb-gvm-regs)) 1) targ-proc-fp)))
    (targ-repr-unboxed-index->code i repr)))

(define (targ-repr-unboxed-loc->code loc repr)
  (targ-repr-unboxed-index->code
    (targ-repr-loc->index loc)
    repr))

(define (targ-repr-to-boxed! loc repr)
  (targ-repr-loc-boxed
    loc
    (targ-repr-to-boxed
      (targ-repr-unboxed-loc->code loc repr)
      repr)))

(define (targ-repr-from-boxed! loc repr)
  (let ((type (vector-ref targ-repr-types (- repr 1))))
    (list (string-append "SET_" type)
          (targ-repr-unboxed-loc->code loc repr)
          (targ-repr-from-boxed
            (targ-repr-opnd-boxed loc)
            repr))))

(define (targ-repr-opnd opnd repr)
  (if targ-repr-enabled?

    (if (or (reg? opnd) (stk? opnd))
      (let* ((loc-descrs
              (targ-block-loc-descrs targ-repr-current-block))
             (i
              (targ-repr-loc->index opnd))
             (descr
              (stretchable-vector-ref loc-descrs i))
             (have
              (targ-repr-have-reprs descr)))
        (cond ((targ-repr-empty? have)
               (stretchable-vector-set! loc-descrs i
                 (targ-repr-need-reprs-union
                   descr
                   (targ-repr-singleton repr))))
              ((not (targ-repr-member? repr have))
               (let loop ((r targ-repr-boxed))
                 (if (not (targ-repr-member? r have))
                   (loop (+ r 1))
                   (if (not (= r targ-repr-boxed))
                     (targ-emit (targ-repr-to-boxed! opnd r)))))
               (if (not (= repr targ-repr-boxed))
                 (targ-emit (targ-repr-from-boxed! opnd repr)))
               (stretchable-vector-set! loc-descrs i
                 (targ-repr-have-reprs-union
                   (targ-repr-have-reprs-union
                     descr
                     (targ-repr-singleton repr))
                   targ-repr-boxed))))
        (targ-repr-index->code i repr))
      (if (and (= repr targ-repr-f64)
               (obj? opnd)
               (eq? (targ-obj-type (obj-val opnd)) 'subtyped)
               (eq? (targ-obj-subtype (obj-val opnd)) 'flonum)
               targ-use-c-fp-constants?
               (not (targ-unusual-float? (obj-val opnd))))
        (obj-val opnd)
        (targ-repr-from-boxed (targ-repr-opnd-boxed opnd) repr)))

    (targ-repr-from-boxed (targ-repr-opnd-boxed opnd) repr)))

(define (targ-repr-from-boxed code repr)
  (if (= repr targ-repr-boxed)
    code
    (list (string-append (vector-ref targ-repr-types (- repr 1)) "UNBOX")
          code)))

(define (targ-repr-to-boxed code repr)
  (if (= repr targ-repr-boxed)
    code
    (begin
      (targ-need-heap)
      (list (string-append (vector-ref targ-repr-types (- repr 1)) "BOX")
            code))))

(define (targ-repr-opnd-boxed opnd)

  (cond ((reg? opnd)
         (let ((n (reg-num opnd)))
           (targ-rd-reg n)
           (cons 'r n)))

        ((stk? opnd)
         (targ-rd-fp)
         (list "STK" (- (stk-num opnd) targ-proc-fp)))

        ((glo? opnd)
         (let ((name (glo-name opnd)))
           (targ-use-glo name #f)
           (targ-c-id-glo2 (symbol->string name))))

        ((clo? opnd)
         (list "CLO"
               (targ-opnd (clo-base opnd))
               (clo-index opnd)))

        ((lbl? opnd)
         (let ((n (lbl-num opnd)))
           (list "LBL" (targ-ref-lbl-val n))))

        ((obj? opnd)
         (targ-use-obj (obj-val opnd)))

        (else
         (compiler-internal-error
           "targ-repr-opnd-boxed, unknown 'opnd'" opnd))))

(define (targ-repr-loc loc val repr)
  (if targ-repr-enabled?

    (if (or (reg? loc) (stk? loc))
      (let* ((loc-descrs
              (targ-block-loc-descrs targ-repr-current-block))
             (i
              (targ-repr-loc->index loc))
             (descr
              (stretchable-vector-ref loc-descrs i))
             (x
              (if (= repr targ-repr-boxed)
                (targ-repr-loc-boxed loc val)
                (let ((type (vector-ref targ-repr-types (- repr 1))))
                  (list (string-append "SET_" type)
                        (targ-repr-unboxed-loc->code loc repr)
                        val)))))
        (stretchable-vector-set! loc-descrs i
          (targ-repr-have-reprs-set
            descr
            (targ-repr-singleton repr)))
        x)
      (targ-repr-loc-boxed loc (targ-repr-to-boxed val repr)))

    (targ-repr-loc-boxed loc (targ-repr-to-boxed val repr))))

(define (targ-repr-loc-boxed loc val)

  (cond ((reg? loc)
         (let ((n (reg-num loc)))
           (targ-wr-reg n)
           (list 'set-r n val)))

        ((stk? loc)
         (targ-rd-fp)
         (list "SET_STK" (- (stk-num loc) targ-proc-fp) val))

        ((glo? loc)
         (let ((name (glo-name loc)))
           (list "SET_GLO"
                 (targ-use-glo name #t)
                 (targ-c-id-glo (symbol->string name))
                 val)))

        ((clo? loc)
         (list "SET_CLO"
               (targ-opnd (clo-base loc))
               (clo-index loc)))

        (else
         (compiler-internal-error
           "targ-repr-loc-boxed, unknown 'loc'" loc))))

(define (targ-opnd opnd) ; fetch a GVM operand in boxed form
  (targ-repr-opnd opnd targ-repr-boxed))

(define (targ-opnd-flo opnd) ; fetch a GVM operand as an unboxed flonum
  (targ-repr-opnd opnd targ-repr-f64))

(define (targ-loc loc val) ; store boxed value in GVM location
  (targ-repr-loc loc val targ-repr-boxed))

(define (targ-loc-flo loc val) ; store unboxed flonum to GVM location
  (targ-repr-loc loc val targ-repr-f64))
)

;;;----------------------------------------------------------------------------

(define (targ-opnd opnd) ; fetch GVM operand

  (if (and targ-fp-cache-enabled? (or (reg? opnd) (stk? opnd)))
    (targ-fp-cache-write-if-dirty opnd))

  (cond ((reg? opnd)
         (let ((n (reg-num opnd)))
           (targ-rd-reg n)
           (cons 'r n)))

        ((stk? opnd)
         (targ-rd-fp)
         (list "STK" (- (stk-num opnd) targ-proc-fp)))

        ((glo? opnd)
         (let ((name (glo-name opnd)))
           (targ-use-glo name #f)
           (targ-c-id-glo2 (symbol->string name))))

        ((clo? opnd)
         (list "CLO"
               (targ-opnd (clo-base opnd))
               (clo-index opnd)))

        ((lbl? opnd)
         (let ((n (lbl-num opnd)))
           (list "LBL" (targ-ref-lbl-val n))))

        ((obj? opnd)
         (targ-use-obj (obj-val opnd)))

        (else
         (compiler-internal-error
           "targ-opnd, unknown 'opnd'" opnd))))

(define (targ-loc-opnd loc)

  (cond ((reg? loc)
         (let ((n (reg-num loc)))
           (targ-wr-reg n)))

        ((stk? loc)
         (targ-rd-fp))

        ((glo? loc)
         (let ((name (glo-name loc)))
           (targ-use-glo name #t))))

  (targ-opnd loc))

(define (targ-loc loc val) ; store GVM location
  (let ((x (targ-loc-no-invalidate loc val)))

    (if (and targ-fp-cache-enabled? (or (reg? loc) (stk? loc)))
      (targ-fp-cache-invalidate loc))

    x))

(define (targ-loc-no-invalidate loc val) ; store GVM location without
                                         ; invalidating flonum cache
  (cond ((reg? loc)
         (let ((n (reg-num loc)))
           (targ-wr-reg n)
           (list 'set-r n val)))

        ((stk? loc)
         (targ-rd-fp)
         (list "SET_STK" (- (stk-num loc) targ-proc-fp) val))

        ((glo? loc)
         (let ((name (glo-name loc)))
           (list "SET_GLO"
                 (targ-use-glo name #t)
                 (targ-c-id-glo (symbol->string name))
                 val)))

        ((clo? loc)
         (list "SET_CLO"
               (targ-opnd (clo-base loc))
               (clo-index loc)))

        (else
         (compiler-internal-error
           "targ-loc, unknown 'loc'" loc))))

(define (targ-opnd-flo opnd) ; fetch unboxed flonum GVM operand
  (cond ((and targ-fp-cache-enabled? (or (reg? opnd) (stk? opnd)))
         (let ((stamp1 (targ-fp-cache-probe opnd)))
           (if stamp1
             (targ-unboxed-loc->code opnd stamp1)
             (let* ((stamp2 (targ-fp-cache-enter opnd #f))
                    (code (targ-unboxed-loc->code opnd stamp2)))
               (targ-emit
                 (list "SET_F64" code (list "F64UNBOX" (targ-opnd opnd))))
               code))))
        ((and (obj? opnd)
              (eq? (targ-obj-type (obj-val opnd)) 'subtyped)
              (eq? (targ-obj-subtype (obj-val opnd)) 'flonum)
              targ-use-c-fp-constants?
              (not (targ-unusual-float? (obj-val opnd))))
         (obj-val opnd))
        (else
         (list "F64UNBOX" (targ-opnd opnd)))))

(define (targ-loc-flo loc val fs) ; store unboxed flonum to GVM location
  (if (and targ-fp-cache-enabled? (or (reg? loc) (stk? loc)))
    (begin
      (targ-fp-cache-invalidate loc)
      (let* ((stamp (targ-fp-cache-enter loc #t))
             (code (targ-unboxed-loc->code loc stamp)))
        (list "SET_F64" code val)))
    (begin
      (targ-heap-reserve-and-check targ-flonum-space fs)
      (targ-loc loc (list "F64BOX" val)))))

;;;----------------------------------------------------------------------------

(define (targ-adjust-stack fs)
  (if (= targ-proc-fp fs)
    #f
    (let ((fp targ-proc-fp))
      (set! targ-proc-fp fs)
      (targ-rd-fp)
      (targ-wr-fp)
      (list "ADJFP" (- fs fp)))))

(define (targ-sn-opnd opnd sn)
  (cond ((stk? opnd)
         (max (stk-num opnd) sn))
        ((clo? opnd)
         (targ-sn-opnd (clo-base opnd) sn))
        (else
         sn)))

(define (targ-sn-opnds opnds sn)
  (if (pair? opnds)
    (targ-sn-opnd (car opnds) (targ-sn-opnds (cdr opnds) sn))
    sn))

(define (targ-sn-loc loc sn)
  (if loc
    (targ-sn-opnd loc sn)
    sn))

;;;----------------------------------------------------------------------------

;; Floating point number cache management.

(define targ-use-c-fp-constants? #f)
(set! targ-use-c-fp-constants? #t)

(define targ-fp-cache-enabled? #f)
(set! targ-fp-cache-enabled? #t)

(define (targ-fp-cache-init)
  (set! targ-fp-cache (vector 0 '#() 0)))

(define (targ-fp-cache-size)
  (vector-ref targ-fp-cache 0))

(define (targ-fp-cache-write loc stamp)
  (targ-heap-reserve targ-flonum-space)
  (targ-emit
    (targ-loc-no-invalidate
      loc
      (list "F64BOX" (targ-unboxed-loc->code loc stamp)))))

(define (targ-fp-cache-write-if-dirty loc)
  (let ((v (vector-ref targ-fp-cache 1)))
    (let ((n (vector-length v)))
      (let loop ((i 0))
        (if (< i n)
          (let ((x (vector-ref v i)))
            (if (and x (vector-ref x 1) (eqv? (vector-ref x 0) loc))
              (begin
                (targ-fp-cache-write loc (vector-ref x 2))
                (vector-set! x 1 #f))
              (loop (+ i 1)))))))))

(define (targ-fp-cache-enter opnd dirty?) ; allocate new entry for opnd
  (let* ((v1
          (vector-ref targ-fp-cache 1))
         (stamp
          (let ((n (+ (vector-ref targ-fp-cache 2) 1)))
            (vector-set! targ-fp-cache 2 n)
            n))
         (entry
          (vector opnd dirty? stamp)))
    (let ((n (vector-length v1)))
      (let loop1 ((i 0))
        (if (< i n)
          (if (vector-ref v1 i)
            (loop1 (+ i 1))
            (vector-set! v1 i entry))
          (let ((v2 (make-vector (+ (* n 2) 1) #f)))
            (let loop2 ((i 0))
              (if (< i n)
                (begin
                  (vector-set! v2 i (vector-ref v1 i))
                  (loop2 (+ i 1)))))
            (vector-set! v2 n entry)
            (vector-set! targ-fp-cache 0 (+ n 1))
            (vector-set! targ-fp-cache 1 v2)))))
    stamp))

(define (targ-fp-cache-probe opnd) ; opnd must be a reg or stack slot
  (let ((v (vector-ref targ-fp-cache 1)))
    (let ((n (vector-length v)))
      (let loop ((i 0))
        (if (< i n)
          (let ((x (vector-ref v i)))
            (if (and x (eqv? (vector-ref x 0) opnd))
              (vector-ref x 2)
              (loop (+ i 1))))
          #f)))))

(define (targ-fp-cache-invalidate opnd) ; opnd must be a reg or stack slot
  (let ((v (vector-ref targ-fp-cache 1)))
    (let ((n (vector-length v)))
      (let loop ((i 0))
        (if (< i n)
          (let ((x (vector-ref v i)))
            (if (and x (eqv? (vector-ref x 0) opnd))
              (vector-set! v i #f))
            (loop (+ i 1))))))))

;;;============================================================================

;; DATABASE OF PRIMITIVES

(define (targ-op name descr)
  (descr (targ-get-prim-info name)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-apply-alloc compute-space proc-safe? side-effects? flo-result? f)
  (targ-setup-inlinable-proc
    proc-safe?
    side-effects?
    flo-result?
    (lambda (opnds sn)
      (targ-heap-reserve-and-check
        (compute-space (length opnds))
        (targ-sn-opnds opnds sn))
      (f opnds sn))))

(define (targ-apply-cons)
  (targ-apply-alloc
    (lambda (n) targ-pair-space)
    #t ;; proc-safe?
    #f ;; side-effects?
    #f ;; flo-result?
    (targ-apply-simp-generator #f #f "CONS")))

(define (targ-apply-list)
  (targ-apply-alloc
    (lambda (n) (* n targ-pair-space))
    #t ;; proc-safe?
    #f ;; side-effects?
    #f ;; flo-result?
    (lambda (opnds sn)
      (cond ((null? opnds)
             '("NUL"))
            ((null? (cdr opnds))
             (list "CONS" (targ-opnd (car opnds)) '("NUL")))
            (else
             (let* ((rev-elements (reverse (map targ-opnd opnds)))
                    (n (length rev-elements)))
               (targ-emit
                 (list "BEGIN_ALLOC_LIST" (targ-c-unsigned-long n) (car rev-elements)))
               (for-each-index (lambda (elem i)
                                 (targ-emit
                                   (list "ADD_LIST_ELEM" (+ i 1) elem)))
                               (cdr rev-elements))
               (targ-emit
                 (list "END_ALLOC_LIST" n))
               (list "GET_LIST" n)))))))

(define (targ-apply-box)
  (targ-apply-alloc
    (lambda (n) targ-box-space)
    #t ;; proc-safe?
    #f ;; side-effects?
    #f ;; flo-result?
    (targ-apply-simp-generator #f #f "BOX")))

(define (targ-apply-make-will)
  (targ-apply-alloc
    (lambda (n) targ-will-space)
    #t ;; proc-safe?
    'expr ;; this is an expression with side-effects
    #f ;; flo-result?
    (lambda (opnds sn)
      (targ-apply-simp-gen opnds #f "MAKEWILL"))))

(define (targ-apply-make-delay-promise)
  (targ-apply-alloc
    (lambda (n) targ-delay-promise-space)
    #t ;; proc-safe?
    #f ;; side-effects?
    #f ;; flo-result?
    (targ-apply-simp-generator #f #f "MAKEDELAYPROMISE")))

(define (targ-apply-make-continuation)
  (targ-apply-alloc
    (lambda (n) targ-continuation-space)
    #t ;; proc-safe?
    #f ;; side-effects?
    #f ;; flo-result?
    (targ-apply-simp-generator #f #f "MAKECONTINUATION")))

(define (targ-apply-ratnum-make)
  (targ-apply-alloc
    (lambda (n) targ-ratnum-space)
    #t ;; proc-safe?
    #f ;; side-effects?
    #f ;; flo-result?
    (targ-apply-simp-generator #f #f "RATNUMMAKE")))

(define (targ-apply-cpxnum-make)
  (targ-apply-alloc
    (lambda (n) targ-cpxnum-space)
    #t ;; proc-safe?
    #f ;; side-effects?
    #f ;; flo-result?
    (targ-apply-simp-generator #f #f "CPXNUMMAKE")))

(define (targ-apply-make-symbol)
  (targ-apply-alloc
    (lambda (n) targ-symbol-space)
    #t ;; proc-safe?
    #f ;; side-effects?
    #f ;; flo-result?
    (targ-apply-simp-generator #f #f "MAKESYMBOL")))

(define (targ-apply-make-keyword)
  (targ-apply-alloc
    (lambda (n) targ-keyword-space)
    #t ;; proc-safe?
    #f ;; side-effects?
    #f ;; flo-result?
    (targ-apply-simp-generator #f #f "MAKEKEYWORD")))

(define (targ-apply-vector-s kind)
  (targ-apply-vector #t kind))

(define (targ-apply-vector-u kind)
  (targ-apply-vector #f kind))

(define (targ-apply-vector proc-safe? kind)
  (targ-setup-inlinable-proc
    proc-safe?
    #f ;; side-effects?
    #f ;; flo-result?
    (lambda (opnds sn)
      (let ((n (length opnds)))
        (if (and (eq? kind 'values) (= n 1))

          (targ-opnd (car opnds))

          (let ()

            (define (compute-space n)
              (case kind
                ((string)    (targ-string-space n))
                ((s8vector)  (targ-s8vector-space n))
                ((u8vector)  (targ-s8vector-space n))
                ((s16vector) (targ-s8vector-space (* n 2)))
                ((u16vector) (targ-s8vector-space (* n 2)))
                ((s32vector) (targ-s8vector-space (* n 4)))
                ((u32vector) (targ-s8vector-space (* n 4)))
                ((s64vector) (targ-s8vector-space (* n 8)))
                ((u64vector) (targ-s8vector-space (* n 8)))
                ((f32vector) (targ-s8vector-space (* n 4)))
                ((f64vector) (targ-s8vector-space (* n 8)))
                ((values)    (targ-vector-space n))
                ((structure) (targ-vector-space n))
                (else        (targ-vector-space n))))

            (define begin-allocator-name
              (case kind
                ((string)    "BEGIN_ALLOC_STRING")
                ((s8vector)  "BEGIN_ALLOC_S8VECTOR")
                ((u8vector)  "BEGIN_ALLOC_U8VECTOR")
                ((s16vector) "BEGIN_ALLOC_S16VECTOR")
                ((u16vector) "BEGIN_ALLOC_U16VECTOR")
                ((s32vector) "BEGIN_ALLOC_S32VECTOR")
                ((u32vector) "BEGIN_ALLOC_U32VECTOR")
                ((s64vector) "BEGIN_ALLOC_S64VECTOR")
                ((u64vector) "BEGIN_ALLOC_U64VECTOR")
                ((f32vector) "BEGIN_ALLOC_F32VECTOR")
                ((f64vector) "BEGIN_ALLOC_F64VECTOR")
                ((values)    "BEGIN_ALLOC_VALUES")
                ((structure) "BEGIN_ALLOC_STRUCTURE")
                (else        "BEGIN_ALLOC_VECTOR")))

            (define end-allocator-name
              (case kind
                ((string)    "END_ALLOC_STRING")
                ((s8vector)  "END_ALLOC_S8VECTOR")
                ((u8vector)  "END_ALLOC_U8VECTOR")
                ((s16vector) "END_ALLOC_S16VECTOR")
                ((u16vector) "END_ALLOC_U16VECTOR")
                ((s32vector) "END_ALLOC_S32VECTOR")
                ((u32vector) "END_ALLOC_U32VECTOR")
                ((s64vector) "END_ALLOC_S64VECTOR")
                ((u64vector) "END_ALLOC_U64VECTOR")
                ((f32vector) "END_ALLOC_F32VECTOR")
                ((f64vector) "END_ALLOC_F64VECTOR")
                ((values)    "END_ALLOC_VALUES")
                ((structure) "END_ALLOC_STRUCTURE")
                (else        "END_ALLOC_VECTOR")))

            (define add-element
              (case kind
                ((string)    "ADD_STRING_ELEM")
                ((s8vector)  "ADD_S8VECTOR_ELEM")
                ((u8vector)  "ADD_U8VECTOR_ELEM")
                ((s16vector) "ADD_S16VECTOR_ELEM")
                ((u16vector) "ADD_U16VECTOR_ELEM")
                ((s32vector) "ADD_S32VECTOR_ELEM")
                ((u32vector) "ADD_U32VECTOR_ELEM")
                ((s64vector) "ADD_S64VECTOR_ELEM")
                ((u64vector) "ADD_U64VECTOR_ELEM")
                ((f32vector) "ADD_F32VECTOR_ELEM")
                ((f64vector) "ADD_F64VECTOR_ELEM")
                ((values)    "ADD_VALUES_ELEM")
                ((structure) "ADD_STRUCTURE_ELEM")
                (else        "ADD_VECTOR_ELEM")))

            (define getter-operation
              (case kind
                ((string)    "GET_STRING")
                ((s8vector)  "GET_S8VECTOR")
                ((u8vector)  "GET_U8VECTOR")
                ((s16vector) "GET_S16VECTOR")
                ((u16vector) "GET_U16VECTOR")
                ((s32vector) "GET_S32VECTOR")
                ((u32vector) "GET_U32VECTOR")
                ((s64vector) "GET_S64VECTOR")
                ((u64vector) "GET_U64VECTOR")
                ((f32vector) "GET_F32VECTOR")
                ((f64vector) "GET_F64VECTOR")
                ((values)    "GET_VALUES")
                ((structure) "GET_STRUCTURE")
                (else        "GET_VECTOR")))

            (targ-heap-reserve-and-check
              (compute-space n)
              (targ-sn-opnds opnds sn))

            (let* ((flo? (or (eq? kind 'f32vector) (eq? kind 'f64vector)))
                   (elements (map (if flo? targ-opnd-flo targ-opnd) opnds)))
              (targ-emit
                (list begin-allocator-name (targ-c-unsigned-long n)))
              (for-each-index (lambda (elem i)
                                (targ-emit
                                  (list add-element i elem)))
                              elements)
              (targ-emit
                (list end-allocator-name n))
              (list getter-operation n))))))))

(define (targ-apply-small-alloc-u vect-kind name)
  (targ-apply-small-alloc #f vect-kind name))

(define (targ-apply-small-alloc proc-safe? vect-kind name)
  (targ-setup-inlinable-proc
   (lambda (env)
     (or proc-safe?
         (not (safe? env))))
    #f ;; side-effects?
    #f ;; flo-result?
    (lambda (opnds sn)
      (targ-heap-reserve-and-check
       (targ-s8vector-space (targ-max-small-allocation 's8vector))
       (targ-sn-opnds opnds sn))
      (targ-emit (cons (string-append name (number->string (length opnds)))
                       (map targ-opnd opnds)))
      '("GET_SMALL_ALLOC"))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-apply-force)
  (lambda (prim)
    (proc-obj-inlinable?-set! prim (lambda (env) #t))
    (proc-obj-inline-set!
      prim
      (lambda (opnds loc sn)
        (let ((lbl (targ-new-lbl))
              (opnd (car opnds))
              (sn* (targ-sn-loc loc sn)))

          (targ-update-fr targ-proc-entry-frame)
          (targ-emit (targ-adjust-stack sn*))
          (targ-emit (list "FORCE1"
                           (targ-ref-lbl-val lbl)
                           (targ-opnd opnd)))
;;          (targ-repr-exit-block! lbl)
;;          (targ-repr-end-block!)
          (targ-gen-label-return* lbl 'return-internal)
          (targ-emit (list "FORCE2"))
          (if loc
            (targ-emit (targ-loc loc (list "FORCE3")))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-apply-first-argument)
  (targ-setup-inlinable-proc*
    #t ;; proc-safe?
    (lambda (opnds sn)
      (targ-opnd (car opnds)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-apply-check-heap-limit)
  (lambda (prim)
    (proc-obj-inlinable?-set! prim (lambda (env) #t))
    (proc-obj-inline-set!
      prim
      (lambda (opnds loc sn)
        (if (> targ-proc-heap-reserved 0)
            (targ-update-fr-and-check-heap 0 sn))
        (if loc
            (targ-emit
             (targ-loc loc (targ-opnd (make-obj false-object)))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-apply-cpu-cycle-count start?)
  (lambda (prim)
    (proc-obj-inlinable?-set! prim (lambda (env) #t))
    (proc-obj-inline-set!
      prim
      (lambda (opnds loc sn)
        (targ-emit (list (if start?
                             "CPUCYCLECOUNTSTART"
                             "CPUCYCLECOUNTEND")))
        (if loc
            (targ-emit
             (targ-loc loc '("GET_CPUCYCLECOUNT"))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-ifjump-simp-s flo? name)
  (targ-ifjump-simp #t flo? name))

(define (targ-ifjump-simp-u flo? name)
  (targ-ifjump-simp #f flo? name))

(define (targ-ifjump-simp proc-safe? flo? name)
  (targ-setup-test-proc*
    proc-safe?
    flo?
    #f ;; not optimizable in apply-ifjump
    (targ-ifjump-simp-generator flo? name)))

(define (targ-ifjump-fold-s flo? name)
  (targ-ifjump-fold #t flo? name))

(define (targ-ifjump-fold-u flo? name)
  (targ-ifjump-fold #f flo? name))

(define (targ-ifjump-fold proc-safe? flo? name)
  (targ-setup-test-proc*
    proc-safe?
    flo?
    #f ;; not optimizable in apply-ifjump
    (targ-ifjump-fold-generator flo? name)))

(define (targ-ifjump-apply-s name)
  (targ-ifjump-apply #t name))

(define (targ-ifjump-apply-u name)
  (targ-ifjump-apply #f name))

(define (targ-ifjump-apply proc-safe? name)
  (targ-setup-inlinable-proc*
    proc-safe?
    (targ-apply-simp-generator #f #f name)))

(define (targ-apply-simp-s flo? side-effects? ssb-space name)
  (targ-apply-simp #t flo? side-effects? ssb-space name))

(define (targ-apply-simp-u flo? side-effects? ssb-space name)
  (targ-apply-simp #f flo? side-effects? ssb-space name))

(define (targ-apply-simp proc-safe? flo? side-effects? ssb-space name); prim. with non-flonum result
  (targ-setup-inlinable-proc
    proc-safe?
    side-effects?
    #f ;; flo-result?
    (targ-apply-simp-generator flo? ssb-space name)))

(define (targ-apply-fold-s flo? name0 name1 name2 . maybe-name2consty)
  (let ((name2consty
         (if (pair? maybe-name2consty) (car maybe-name2consty) name2)))
    (targ-apply-fold #t flo? name0 name1 name2 name2consty)))

(define (targ-apply-fold-u flo? name0 name1 name2 . maybe-name2consty)
  (let ((name2consty
         (if (pair? maybe-name2consty) (car maybe-name2consty) name2)))
    (targ-apply-fold #f flo? name0 name1 name2 name2consty)))

(define (targ-apply-fold proc-safe? flo? name0 name1 name2 name2consty)
  (let ((generator
         (targ-apply-fold-generator flo? name0 name1 name2 name2consty)))
    (if flo?
      (targ-apply-alloc
        (lambda (n) 0) ; targ-apply-alloc accounts for space for flonum result
        proc-safe?
        #f ;; side-effects?
        #t ;; flo-result?
        generator)
      (targ-setup-inlinable-proc
        proc-safe?
        #f ;; side-effects?
        #f ;; flo-result?
        generator))))

(define (targ-apply-ifjump proc-safe? name0 name1 name2 . maybe-name2consty)
  (let* ((name2consty
          (if (pair? maybe-name2consty) (car maybe-name2consty) name2))
         (apply-generator
          (lambda (opnds sn)
            (if (not (pair? opnds))
                (list name0)
                (let ((o1 (car opnds)))
                  (if (not (pair? (cdr opnds)))
                      (list name1 (targ-opnd o1))
                      (let ((o2 (cadr opnds)))
                        (list (if (obj? o2)
                                  name2consty
                                  name2)
                              (targ-opnd o1)
                              (targ-opnd o2))))))))
         (ifjump-generator
          (lambda (opnds loc sn)
            (let ((x (apply-generator opnds sn)))
              (if loc
                  (cons (string-append (car x) "_NOTFALSEP")
                        (cons (targ-loc-opnd loc)
                              (cdr x)))
                  (list "NOTFALSEP" x))))))

    (lambda (prim)
      ((targ-setup-inlinable-proc
        proc-safe?
        #f ;; side-effects?
        #f ;; flo-result?
        apply-generator)
       prim)
      ((targ-setup-test-proc
        proc-safe?
        #f
        #t ;; optimizable in apply-ifjump
        ifjump-generator)
       prim))))

(define (targ-apply-simpflo-s flo? name)
  (targ-apply-simpflo #t flo? name))

(define (targ-apply-simpflo-u flo? name)
  (targ-apply-simpflo #f flo? name))

(define (targ-apply-simpflo proc-safe? flo? name) ; prim. with flonum result
  (targ-apply-alloc
    (lambda (n) 0) ; targ-apply-alloc accounts for space for flonum result
    proc-safe?
    #f ;; side-effects?
    #t ;; flo-result?
    (targ-apply-simp-generator flo? #f name)))

(define (targ-apply-simpflo2-s flo? name1 name2)
  (targ-apply-simpflo2 #t flo? name1 name2))

(define (targ-apply-simpflo2-u flo? name1 name2)
  (targ-apply-simpflo2 #f flo? name1 name2))

(define (targ-apply-simpflo2 proc-safe? flo? name1 name2) ; 1 or 2 arg prim. with flonum result
  (targ-apply-alloc
    (lambda (n) 0) ; targ-apply-alloc accounts for space for flonum result
    proc-safe?
    #f ;; side-effects?
    #t ;; flo-result?
    (lambda (opnds sn)
      (if (= (length opnds) 1)
        (targ-apply-simp-gen opnds flo? name1)
        (targ-apply-simp-gen opnds flo? name2)))))

(define (targ-apply-simpflo3-s name)
  (targ-apply-simpflo3 #t name))

(define (targ-apply-simpflo3-u name)
  (targ-apply-simpflo3 #f name))

(define (targ-apply-simpflo3 proc-safe? name); 3 arg prim. whose last arg is a flonum
  (targ-setup-inlinable-proc
    proc-safe?
    #t ;; side-effects?
    #f ;; flo-result?
    (lambda (opnds sn)
      (let* ((arg1 (targ-opnd (car opnds)))
             (arg2 (targ-opnd (cadr opnds)))
             (arg3 (targ-opnd-flo (caddr opnds))))
        (list name arg1 arg2 arg3)))))

(define (targ-apply-simpbig-s name)
  (targ-apply-simpbig #t name))

(define (targ-apply-simpbig-u name)
  (targ-apply-simpbig #f name))

(define (targ-apply-simpbig proc-safe? name) ; prim. with 32 or 64 bit bignum result
  (targ-apply-alloc
    (lambda (n) (targ-s8vector-space (* (quotient targ-max-adigit-width 8) 3))) ; space for 2^64-1 including 64 bit alignment  ;;;;;;;;;;ugly code!
    proc-safe?
    #f ;; side-effects?
    #f ;; flo-result?
    (lambda (opnds sn)
      (targ-apply-simp-gen opnds #f name))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-setup-test-proc* proc-safe? args-flo? optimizable? generator)
  (lambda (prim)
    ((targ-setup-test-proc
       proc-safe?
       args-flo?
       optimizable?
       generator)
     prim)
    ((targ-setup-inlinable-proc
       proc-safe?
       #f ;; side-effects?
       #f ;; flo-result?
       (lambda (opnds sn)
         (list "BOOLEAN" (generator opnds #f sn))))
     prim)))

(define (targ-setup-test-proc proc-safe? args-flo? optimizable? generator)
  (lambda (prim)
    (proc-obj-testable?-set!
     prim
     (if (procedure? proc-safe?)
         proc-safe?
         (lambda (env)
           (or proc-safe?
               (not (safe? env))))))
    (proc-obj-test-set!
     prim
     (vector
      args-flo?
      (lambda (not? opnds loc fs)
        (let ((test (generator opnds loc fs)))
          (if not?
              (list "NOT" test)
              test)))
      optimizable?))))

(define (targ-ifjump-simp-generator flo? name)
  (lambda (opnds loc fs)
    (targ-ifjump-simp-gen opnds loc flo? name)))

(define (targ-ifjump-simp-gen opnds loc flo? name)
  (let loop ((l opnds) (args '()))
    (if (pair? l)
      (let ((opnd (car l)))
        (loop (cdr l)
              (cons (if flo? (targ-opnd-flo opnd) (targ-opnd opnd))
                    args)))
      (cons name (reverse args)))))

(define (targ-ifjump-fold-generator flo? name)
  (lambda (opnds loc fs)
    (targ-ifjump-fold-gen opnds loc flo? name)))

(define (targ-ifjump-fold-gen opnds loc flo? name)

  (define (multi-opnds opnds)
    (let* ((opnd1 (car opnds))
           (opnd2 (cadr opnds))
           (opnd1* (if flo? (targ-opnd-flo opnd1) (targ-opnd opnd1)))
           (opnd2* (if flo? (targ-opnd-flo opnd2) (targ-opnd opnd2)))
           (r (list name opnd1* opnd2*)))
      (if (pair? (cddr opnds))
        (list "AND" r (multi-opnds (cdr opnds)))
        r)))

  (cond ((or (not (pair? opnds))
             (not (pair? (cdr opnds))))
         1)
        (else
         (multi-opnds opnds))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-setup-inlinable-proc* proc-safe? generator)
  (lambda (prim)
    ((targ-setup-test-proc
       proc-safe?
       #f ;; safe to assume that arguments are not all flonums
       #f ;; not optimizable in apply-ifjump
       (lambda (opnds loc fs)
         (list "NOTFALSEP" (generator opnds fs))))
     prim)
    ((targ-setup-inlinable-proc
      proc-safe?
      #f ;; side-effects?
      #f ;; flo-result?
      generator)
     prim)))

(define (targ-setup-inlinable-proc proc-safe? side-effects? flo-result? generator)
  (lambda (prim)
    (proc-obj-inlinable?-set!
      prim
      (if (procedure? proc-safe?)
          proc-safe?
          (lambda (env)
            (or proc-safe?
                (not (safe? env))))))
    (proc-obj-inline-set!
      prim
      (lambda (opnds loc sn)
        (if loc ; result is needed?
          (if (eq? side-effects? #t) ; generator generates a statement?
            (let ((x (generator opnds sn)))
              (targ-emit
                (if (eqv? (car opnds) loc)
                  x
                  (list 'seq x (targ-loc loc (targ-opnd (car opnds)))))))
            (let ((sn* (targ-sn-loc loc sn)))
              (let ((x (generator opnds sn*)))
                (targ-emit
                  (if flo-result?
                    (targ-loc-flo loc x sn*)
                    (targ-loc loc x))))))
          (if side-effects? ; only generate code for side-effect
            (let ((x (generator opnds sn)))
              (targ-emit
                (if (eq? side-effects? 'expr) (list "EXPR" x) x)))))))))

(define (targ-setup-inlinable-proc-io-fast-path proc-safe? name)
  (lambda (prim)
    (proc-obj-inlinable?-set!
      prim
      (if (procedure? proc-safe?)
          proc-safe?
          (lambda (env)
            (or proc-safe?
                (not (safe? env))))))
    (proc-obj-inline-set!
      prim
      (lambda (opnds loc sn)
        (targ-emit
         (cons name (map (lambda (opnd) (targ-opnd opnd)) opnds)))
        (if loc ; result is needed?
            (targ-emit
             (targ-loc loc '("temp"))))))))

(define (targ-apply-simp-generator flo? ssb-space name)
  (lambda (opnds sn)
    (let ((code (targ-apply-simp-gen opnds flo? name)))
      (if #f ;;;;ssb-space  ;;TODO:should check whether using the SSB is necessary
          (let ((code2 (append code (list targ-proc-ssb-reserved))))
            (targ-ssb-reserve ssb-space)
            code2)
          code))))

(define (targ-apply-simp-gen opnds flo? name)
  (let loop ((l opnds) (args '()))
    (if (pair? l)
      (let ((opnd (car l)))
        (loop (cdr l)
              (cons (if flo? (targ-opnd-flo opnd) (targ-opnd opnd))
                    args)))
      (cons name (reverse args)))))

(define (targ-apply-fold-generator flo? name0 name1 name2 name2consty)
  (lambda (opnds sn)
    (targ-apply-fold-gen opnds flo? name0 name1 name2 name2consty)))

(define (targ-apply-fold-gen opnds flo? name0 name1 name2 name2consty)
  (if (not (pair? opnds))
    (list name0)
    (let* ((o (car opnds))
           (r (if flo? (targ-opnd-flo o) (targ-opnd o))))
      (if (not (pair? (cdr opnds)))
        (list name1 r)
        (let loop ((l (cdr opnds)) (r r))
          (if (pair? l)
            (let ((opnd (car l)))
              (loop (cdr l)
                    (list (if (obj? opnd)
                              name2consty
                              name2)
                          r
                          (if flo? (targ-opnd-flo opnd) (targ-opnd opnd)))))
            r))))))

;;;----------------------------------------------------------------------------

(define (targ-jump-inline name jump-inliner)
  (let ((prim (targ-get-prim-info name)))
    (proc-obj-jump-inlinable?-set! prim (lambda (env) #t))
    (proc-obj-jump-inline-set! prim jump-inliner)))

(define (targ-emit-jump-inline name safe? nb-args)
  (let* ((pc (targ-jump-info nb-args))
         (fs (pcontext-fs pc)))
    (for-each (lambda (x)
                (let ((opnd (cdr x)))
                  (targ-opnd
                   (if (stk? opnd)
                     (make-stk (+ targ-proc-fp (- (stk-num opnd) fs)))
                     opnd))))
              (cdr (pcontext-map pc)))
    (targ-emit
     (list (string-append "JUMP_" name (number->string nb-args))
           (list (if safe? "JUMPSAFE" "JUMPNOTSAFE"))))))

;;;----------------------------------------------------------------------------

;; Table of inlinable operations (for 'apply' and 'ifjump' GVM instructions)

(define targ-use-c-rts-char-operations #f)

(define (targ-setup-inlinable)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##type"             (targ-apply-simp-s #f #f #f "TYPE"))
(targ-op "##type-cast"        (targ-apply-simp-u #f #f #f "TYPECAST"))
(targ-op "##subtype"          (targ-apply-simp-u #f #f #f "SUBTYPE"))
(targ-op "##subtype-set!"     (targ-apply-simp-u #f #t #f "SUBTYPESET"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##not"              (targ-ifjump-simp-s #f "FALSEP"))
(targ-op "##boolean?"         (targ-ifjump-simp-s #f "BOOLEANP"))
(targ-op "##null?"            (targ-ifjump-simp-s #f "NULLP"))
(targ-op "##false-or-null?"   (targ-ifjump-simp-s #f "FALSEORNULLP"))
(targ-op "##false-or-void?"   (targ-ifjump-simp-s #f "FALSEORVOIDP"))
(targ-op "##unbound?"         (targ-ifjump-simp-s #f "UNBOUNDP"))
(targ-op "##eq?"              (targ-ifjump-simp-s #f "EQP"))
(targ-op "##eof-object?"      (targ-ifjump-simp-s #f "EOFP"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##fixnum?"          (targ-ifjump-simp-s #f "FIXNUMP"))
(targ-op "##pair?"            (targ-ifjump-simp-s #f "PAIRP"))
(targ-op "##vector?"          (targ-ifjump-simp-s #f "VECTORP"))
(targ-op "##ratnum?"          (targ-ifjump-simp-s #f "RATNUMP"))
(targ-op "##cpxnum?"          (targ-ifjump-simp-s #f "CPXNUMP"))
(targ-op "##structure?"       (targ-ifjump-simp-s #f "STRUCTUREP"))
(targ-op "##box?"             (targ-ifjump-simp-s #f "BOXP"))
(targ-op "##values?"          (targ-ifjump-simp-s #f "VALUESP"))
(targ-op "##symbol?"          (targ-ifjump-simp-s #f "SYMBOLP"))
(targ-op "##keyword?"         (targ-ifjump-simp-s #f "KEYWORDP"))
(targ-op "##frame?"           (targ-ifjump-simp-s #f "FRAMEP"))
(targ-op "##continuation?"    (targ-ifjump-simp-s #f "CONTINUATIONP"))
(targ-op "##promise?"         (targ-ifjump-simp-s #f "PROMISEP"))
(targ-op "##will?"            (targ-ifjump-simp-s #f "WILLP"))
(targ-op "##procedure?"       (targ-ifjump-simp-s #f "PROCEDUREP"))
(targ-op "##subprocedure?"    (targ-ifjump-simp-s #f "SUBPROCEDUREP"))
(targ-op "##closure?"         (targ-ifjump-simp-s #f "CLOSUREP"))
(targ-op "##return?"          (targ-ifjump-simp-s #f "RETURNP"))
(targ-op "##foreign?"         (targ-ifjump-simp-s #f "FOREIGNP"))
(targ-op "##string?"          (targ-ifjump-simp-s #f "STRINGP"))
(targ-op "##s8vector?"        (targ-ifjump-simp-s #f "S8VECTORP"))
(targ-op "##u8vector?"        (targ-ifjump-simp-s #f "U8VECTORP"))
(targ-op "##s16vector?"       (targ-ifjump-simp-s #f "S16VECTORP"))
(targ-op "##u16vector?"       (targ-ifjump-simp-s #f "U16VECTORP"))
(targ-op "##s32vector?"       (targ-ifjump-simp-s #f "S32VECTORP"))
(targ-op "##u32vector?"       (targ-ifjump-simp-s #f "U32VECTORP"))
(targ-op "##s64vector?"       (targ-ifjump-simp-s #f "S64VECTORP"))
(targ-op "##u64vector?"       (targ-ifjump-simp-s #f "U64VECTORP"))
(targ-op "##f32vector?"       (targ-ifjump-simp-s #f "F32VECTORP"))
(targ-op "##f64vector?"       (targ-ifjump-simp-s #f "F64VECTORP"))
(targ-op "##flonum?"          (targ-ifjump-simp-s #f "FLONUMP"))
(targ-op "##bignum?"          (targ-ifjump-simp-s #f "BIGNUMP"))
(targ-op "##char?"            (targ-ifjump-simp-s #f "CHARP"))
(targ-op "##number?"          (targ-ifjump-simp-s #f "NUMBERP"))
(targ-op "##complex?"         (targ-ifjump-simp-s #f "COMPLEXP"))
(targ-op "##mutable?"         (targ-ifjump-simp-s #f "MUTABLEP"))

;;the following primitives can't be inlined because they have
;;non-trivial definitions which depend on some configuration
;;information provided by lib/_num.scm:
;;(targ-op "##real?"            (targ-ifjump-simp-s #f "REALP"))
;;(targ-op "##rational?"        (targ-ifjump-simp-s #f "RATIONALP"))
;;(targ-op "##integer?"         (targ-ifjump-simp-s #f "INTEGERP"))
;;(targ-op "##exact?"           (targ-ifjump-simp-s #f "EXACTP"))
;;(targ-op "##inexact?"         (targ-ifjump-simp-s #f "INEXACTP"))

(targ-op "##exact-integer?"     (targ-ifjump-simp-s #f "EXACTINTP"))

;; specific to C backend:

(targ-op "##special?"         (targ-ifjump-simp-s #f "SPECIALP"))
(targ-op "##meroon?"          (targ-ifjump-simp-s #f "MEROONP"))
(targ-op "##jazz?"            (targ-ifjump-simp-s #f "JAZZP"))
(targ-op "##gc-hash-table?"   (targ-ifjump-simp-s #f "GCHASHTABLEP"))
(targ-op "##mem-allocated?"   (targ-ifjump-simp-s #f "MEMALLOCATEDP"))
(targ-op "##subtyped?"        (targ-ifjump-simp-s #f "SUBTYPEDP"))
(targ-op "##subtyped.vector?" (targ-ifjump-simp-u #f "SUBTYPEDVECTORP"))
(targ-op "##subtyped.symbol?" (targ-ifjump-simp-u #f "SUBTYPEDSYMBOLP"))
(targ-op "##subtyped.flonum?" (targ-ifjump-simp-u #f "SUBTYPEDFLONUMP"))
(targ-op "##subtyped.bignum?" (targ-ifjump-simp-u #f "SUBTYPEDBIGNUMP"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##fxmax"          (targ-apply-fold-u #f #f       "FIXPOS" "FIXMAX"))
(targ-op "##fxmin"          (targ-apply-fold-u #f #f       "FIXPOS" "FIXMIN"))

(targ-op "##fxwrap+"        (targ-apply-fold-u #f "FIX_0"  "FIXPOS" "FIXWRAPADD"))
(targ-op "##fx+"            (targ-apply-fold-u #f "FIX_0"  "FIXPOS" "FIXADD"))
(targ-op "##fx+?"           (targ-apply-ifjump #f #f #f "FIXADDP"))
(targ-op "##fxwrap*"        (targ-apply-fold-u #f "FIX_1"  "FIXPOS" "FIXWRAPMUL"))
(targ-op "##fx*"            (targ-apply-fold-u #f "FIX_1"  "FIXPOS" "FIXMUL"))
(targ-op "##fx*?"           (targ-apply-ifjump #f #f #f "FIXMULP" "FIXMULPCONSTY"))
(targ-op "##fxwrap-"        (targ-apply-fold-u #f #f       "FIXWRAPNEG" "FIXWRAPSUB"))
(targ-op "##fx-"            (targ-apply-fold-u #f #f       "FIXNEG" "FIXSUB"))
(targ-op "##fx-?"           (targ-apply-ifjump #f #f "FIXNEGP""FIXSUBP"))
(targ-op "##fxwrapquotient" (targ-apply-fold-u #f #f       #f       "FIXWRAPQUO" "FIXWRAPQUOCONSTY"))
(targ-op "##fxquotient"     (targ-apply-fold-u #f #f       #f       "FIXQUO" "FIXQUOCONSTY"))
(targ-op "##fxremainder"    (targ-apply-fold-u #f #f       #f       "FIXREM" "FIXREMCONSTY"))
(targ-op "##fxmodulo"       (targ-apply-fold-u #f #f       #f       "FIXMOD" "FIXMODCONSTY"))
(targ-op "##fxand"          (targ-apply-fold-u #f "FIX_M1" "FIXPOS" "FIXAND"))
(targ-op "##fxandc1"        (targ-apply-simp-u #f #f       #f       "FIXANDC1"))
(targ-op "##fxandc2"        (targ-apply-simp-u #f #f       #f       "FIXANDC2"))
(targ-op "##fxeqv"          (targ-apply-fold-u #f "FIX_M1" "FIXPOS" "FIXEQV"))
(targ-op "##fxior"          (targ-apply-fold-u #f "FIX_0"  "FIXPOS" "FIXIOR"))
(targ-op "##fxnand"         (targ-apply-simp-u #f #f       #f       "FIXNAND"))
(targ-op "##fxnor"          (targ-apply-simp-u #f #f       #f       "FIXNOR"))
(targ-op "##fxnot"          (targ-apply-simp-u #f #f       #f       "FIXNOT"))
(targ-op "##fxorc1"         (targ-apply-simp-u #f #f       #f       "FIXORC1"))
(targ-op "##fxorc2"         (targ-apply-simp-u #f #f       #f       "FIXORC2"))
(targ-op "##fxxor"          (targ-apply-fold-u #f "FIX_0"  "FIXPOS" "FIXXOR"))
(targ-op "##fxif"           (targ-apply-simp-u #f #f #f "FIXIF"))
(targ-op "##fxbit-count"    (targ-apply-simp-u #f #f #f "FIXBITCOUNT"))
(targ-op "##fxlength"       (targ-apply-simp-u #f #f #f "FIXLENGTH"))
(targ-op "##fxfirst-set-bit"(targ-apply-simp-u #f #f #f "FIXFIRSTSETBIT"))
(targ-op "##fxbit-set?"     (targ-ifjump-simp-u #f "FIXBITSETP"))
(targ-op "##fxwraparithmetic-shift"     (targ-apply-simp-u #f #f #f "FIXWRAPASH"))
(targ-op "##fxwraparithmetic-shift?"    (targ-apply-simp-u #f #f #f "FIXWRAPASHP"))
(targ-op "##fxarithmetic-shift"         (targ-apply-simp-u #f #f #f "FIXASH"))
(targ-op "##fxarithmetic-shift?"        (targ-apply-simp-u #f #f #f "FIXASHP"))
(targ-op "##fxwraparithmetic-shift-left"(targ-apply-simp-u #f #f #f "FIXWRAPASHL"))
(targ-op "##fxwraparithmetic-shift-left?"(targ-apply-simp-u #f #f #f "FIXWRAPASHLP"))
(targ-op "##fxarithmetic-shift-left"    (targ-apply-simp-u #f #f #f "FIXASHL"))
(targ-op "##fxarithmetic-shift-left?"   (targ-apply-simp-u #f #f #f "FIXASHLP"))
(targ-op "##fxarithmetic-shift-right"   (targ-apply-simp-u #f #f #f "FIXASHR"))
(targ-op "##fxarithmetic-shift-right?"  (targ-apply-simp-u #f #f #f "FIXASHRP"))
(targ-op "##fxwraplogical-shift-right"  (targ-apply-simp-u #f #f #f "FIXWRAPLSHR"))
(targ-op "##fxwraplogical-shift-right?" (targ-apply-simp-u #f #f #f "FIXWRAPLSHRP"))
(targ-op "##fxwrapabs"      (targ-apply-simp-u #f #f #f "FIXWRAPABS"))
(targ-op "##fxabs"          (targ-apply-simp-u #f #f #f "FIXABS"))
(targ-op "##fxabs?"         (targ-apply-ifjump #f #f "FIXABSP" #f))
(targ-op "##fxwrapsquare"   (targ-apply-simp-u #f #f #f "FIXWRAPSQUARE"))
(targ-op "##fxsquare"       (targ-apply-simp-u #f #f #f "FIXSQUARE"))
(targ-op "##fxsquare?"      (targ-apply-ifjump #f #f "FIXSQUAREP" #f))

(targ-op "##fxzero?"     (targ-ifjump-simp-u #f "FIXZEROP"))
(targ-op "##fxpositive?" (targ-ifjump-simp-u #f "FIXPOSITIVEP"))
(targ-op "##fxnegative?" (targ-ifjump-simp-u #f "FIXNEGATIVEP"))
(targ-op "##fxodd?"      (targ-ifjump-simp-u #f "FIXODDP"))
(targ-op "##fxeven?"     (targ-ifjump-simp-u #f "FIXEVENP"))
(targ-op "##fx="         (targ-ifjump-fold-u #f "FIXEQ"))
(targ-op "##fx<"         (targ-ifjump-fold-u #f "FIXLT"))
(targ-op "##fx>"         (targ-ifjump-fold-u #f "FIXGT"))
(targ-op "##fx<="        (targ-ifjump-fold-u #f "FIXLE"))
(targ-op "##fx>="        (targ-ifjump-fold-u #f "FIXGE"))

(targ-op "##integer->char"  (targ-apply-simp-u #f #f #f "FIXTOCHR"))
(targ-op "##char->integer"  (targ-apply-simp-u #f #f #f "FIXFROMCHR"))
(targ-op "##flonum->fixnum" (targ-apply-simp-u #t #f #f "F64TOFIX"))
(targ-op "##fixnum->flonum" (targ-apply-simpflo-u #f "F64FROMFIX"))
(targ-op "##fixnum->flonum-exact?" (targ-ifjump-simp-u #f "F64FROMFIXEXACTP"))

(targ-op "##flonum->string-host"
  (targ-apply-alloc
    (lambda (n) (targ-string-space 50)) ;; account for result of max length 50
    #t ;; proc-safe?
    #f ;; side-effects?
    #f ;; flo-result?
    (targ-apply-simp-generator #t #f "F64TOSTRING")))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##flmax"       (targ-apply-fold-u #t #f      "F64POS" "F64MAX"))
(targ-op "##flmin"       (targ-apply-fold-u #t #f      "F64POS" "F64MIN"))

(targ-op "##fl+"         (targ-apply-fold-u #t "F64_0" "F64POS" "F64ADD"))
(targ-op "##fl*"         (targ-apply-fold-u #t "F64_1" "F64POS" "F64MUL"))
(targ-op "##fl-"         (targ-apply-fold-u #t #f      "F64NEG" "F64SUB"))
(targ-op "##fl/"         (targ-apply-fold-u #t #f      "F64INV" "F64DIV"))
(targ-op "##flabs"       (targ-apply-simpflo-u #t "F64ABS"))
(targ-op "##flfloor"     (targ-apply-simpflo-u #t "F64FLOOR"))
(targ-op "##flceiling"   (targ-apply-simpflo-u #t "F64CEILING"))
(targ-op "##fltruncate"  (targ-apply-simpflo-u #t "F64TRUNCATE"))
(targ-op "##flround"     (targ-apply-simpflo-u #t "F64ROUND"))

(targ-op "##flscalbn"
         (targ-apply-alloc
          (lambda (n) 0) ; targ-apply-alloc accounts for space for flonum result
          #f ;; proc-safe?
          #f ;; side-effects?
          #t ;; flo-result?
          (lambda (opnds sn)
            (let ((opnd1 (car opnds))
                  (opnd2 (cadr opnds)))
              (list "F64SCALBN" (targ-opnd-flo opnd1) (targ-opnd opnd2))))))

(targ-op "##flilogb"
         (targ-setup-inlinable-proc
          #f ;; proc-safe?
          #f ;; side-effects?
          #f ;; flo-result?
          (lambda (opnds sn)
            (let ((opnd1 (car opnds)))
              (list "F64ILOGB" (targ-opnd-flo opnd1))))))

(targ-op "##flexp"       (targ-apply-simpflo-u #t "F64EXP"))
(targ-op "##flexpm1"     (targ-apply-simpflo-u #t "F64EXPM1"))
(targ-op "##fllog"       (targ-apply-simpflo2-u #t "F64LOG" "F64LOG2"))
(targ-op "##fllog1p"     (targ-apply-simpflo-u #t "F64LOG1P"))
(targ-op "##flsin"       (targ-apply-simpflo-u #t "F64SIN"))
(targ-op "##flcos"       (targ-apply-simpflo-u #t "F64COS"))
(targ-op "##fltan"       (targ-apply-simpflo-u #t "F64TAN"))
(targ-op "##flasin"      (targ-apply-simpflo-u #t "F64ASIN"))
(targ-op "##flacos"      (targ-apply-simpflo-u #t "F64ACOS"))
(targ-op "##flatan"      (targ-apply-simpflo2-u #t "F64ATAN" "F64ATAN2"))
(targ-op "##flsinh"      (targ-apply-simpflo-u #t "F64SINH"))
(targ-op "##flcosh"      (targ-apply-simpflo-u #t "F64COSH"))
(targ-op "##fltanh"      (targ-apply-simpflo-u #t "F64TANH"))
(targ-op "##flasinh"     (targ-apply-simpflo-u #t "F64ASINH"))
(targ-op "##flacosh"     (targ-apply-simpflo-u #t "F64ACOSH"))
(targ-op "##flatanh"     (targ-apply-simpflo-u #t "F64ATANH"))
(targ-op "##flhypot"     (targ-apply-simpflo-u #t "F64HYPOT"))
(targ-op "##flexpt"      (targ-apply-simpflo-u #t "F64EXPT"))
(targ-op "##flsqrt"      (targ-apply-simpflo-u #t "F64SQRT"))
(targ-op "##flsquare"    (targ-apply-simpflo-u #t "F64SQUARE"))
(targ-op "##flcopysign"  (targ-apply-simpflo-u #t "F64COPYSIGN"))

(targ-op "##flinteger?"  (targ-ifjump-simp-u #t "F64INTEGERP"))
(targ-op "##flzero?"     (targ-ifjump-simp-u #t "F64ZEROP"))
(targ-op "##flpositive?" (targ-ifjump-simp-u #t "F64POSITIVEP"))
(targ-op "##flnegative?" (targ-ifjump-simp-u #t "F64NEGATIVEP"))
(targ-op "##flodd?"      (targ-ifjump-simp-u #t "F64ODDP"))
(targ-op "##fleven?"     (targ-ifjump-simp-u #t "F64EVENP"))
(targ-op "##flfinite?"   (targ-ifjump-simp-u #t "F64FINITEP"))
(targ-op "##flinfinite?" (targ-ifjump-simp-u #t "F64INFINITEP"))
(targ-op "##flnan?"      (targ-ifjump-simp-u #t "F64NANP"))
(targ-op "##fl="         (targ-ifjump-fold-u #t "F64EQ"))
(targ-op "##fl<"         (targ-ifjump-fold-u #t "F64LT"))
(targ-op "##fl>"         (targ-ifjump-fold-u #t "F64GT"))
(targ-op "##fl<="        (targ-ifjump-fold-u #t "F64LE"))
(targ-op "##fl>="        (targ-ifjump-fold-u #t "F64GE"))
(targ-op "##fleqv?"      (targ-ifjump-simp-u #t "F64EQV"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##char=?"           (targ-ifjump-fold-u #f "CHAREQP"))
(targ-op "##char<?"           (targ-ifjump-fold-u #f "CHARLTP"))
(targ-op "##char>?"           (targ-ifjump-fold-u #f "CHARGTP"))
(targ-op "##char<=?"          (targ-ifjump-fold-u #f "CHARLEP"))
(targ-op "##char>=?"          (targ-ifjump-fold-u #f "CHARGEP"))

(if targ-use-c-rts-char-operations
    (begin
      (targ-op "##char-alphabetic?" (targ-ifjump-simp-u #f "CHARALPHABETICP"))
      (targ-op "##char-numeric?"    (targ-ifjump-simp-u #f "CHARNUMERICP"))
      (targ-op "##char-whitespace?" (targ-ifjump-simp-u #f "CHARWHITESPACEP"))
      (targ-op "##char-upper-case?" (targ-ifjump-simp-u #f "CHARUPPERCASEP"))
      (targ-op "##char-lower-case?" (targ-ifjump-simp-u #f "CHARLOWERCASEP"))
      (targ-op "##char-upcase"      (targ-apply-simp-u #f #f #f "CHARUPCASE"))
      (targ-op "##char-downcase"    (targ-apply-simp-u #f #f #f "CHARDOWNCASE"))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##cons"             (targ-apply-cons))
(targ-op "##set-car!"         (targ-apply-simp-u #f #t 1 "SETCAR"))
(targ-op "##set-cdr!"         (targ-apply-simp-u #f #t 1 "SETCDR"))
(targ-op "##car"              (targ-ifjump-apply-u "CAR"))
(targ-op "##cdr"              (targ-ifjump-apply-u "CDR"))
(targ-op "##caar"             (targ-ifjump-apply-u "CAAR"))
(targ-op "##cadr"             (targ-ifjump-apply-u "CADR"))
(targ-op "##cdar"             (targ-ifjump-apply-u "CDAR"))
(targ-op "##cddr"             (targ-ifjump-apply-u "CDDR"))
(targ-op "##caaar"            (targ-ifjump-apply-u "CAAAR"))
(targ-op "##caadr"            (targ-ifjump-apply-u "CAADR"))
(targ-op "##cadar"            (targ-ifjump-apply-u "CADAR"))
(targ-op "##caddr"            (targ-ifjump-apply-u "CADDR"))
(targ-op "##cdaar"            (targ-ifjump-apply-u "CDAAR"))
(targ-op "##cdadr"            (targ-ifjump-apply-u "CDADR"))
(targ-op "##cddar"            (targ-ifjump-apply-u "CDDAR"))
(targ-op "##cdddr"            (targ-ifjump-apply-u "CDDDR"))
(targ-op "##caaaar"           (targ-ifjump-apply-u "CAAAAR"))
(targ-op "##caaadr"           (targ-ifjump-apply-u "CAAADR"))
(targ-op "##caadar"           (targ-ifjump-apply-u "CAADAR"))
(targ-op "##caaddr"           (targ-ifjump-apply-u "CAADDR"))
(targ-op "##cadaar"           (targ-ifjump-apply-u "CADAAR"))
(targ-op "##cadadr"           (targ-ifjump-apply-u "CADADR"))
(targ-op "##caddar"           (targ-ifjump-apply-u "CADDAR"))
(targ-op "##cadddr"           (targ-ifjump-apply-u "CADDDR"))
(targ-op "##cdaaar"           (targ-ifjump-apply-u "CDAAAR"))
(targ-op "##cdaadr"           (targ-ifjump-apply-u "CDAADR"))
(targ-op "##cdadar"           (targ-ifjump-apply-u "CDADAR"))
(targ-op "##cdaddr"           (targ-ifjump-apply-u "CDADDR"))
(targ-op "##cddaar"           (targ-ifjump-apply-u "CDDAAR"))
(targ-op "##cddadr"           (targ-ifjump-apply-u "CDDADR"))
(targ-op "##cdddar"           (targ-ifjump-apply-u "CDDDAR"))
(targ-op "##cddddr"           (targ-ifjump-apply-u "CDDDDR"))

(targ-op "##list"             (targ-apply-list))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##quasi-list"       (targ-apply-list))
(targ-op "##quasi-cons"       (targ-apply-cons))
(targ-op "##quasi-vector"     (targ-apply-vector-s 'vector))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##box"              (targ-apply-box))
(targ-op "##unbox"            (targ-ifjump-apply-u "UNBOX"))
(targ-op "##set-box!"         (targ-apply-simp-u #f #t 1 "SETBOX"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##make-will"          (targ-apply-make-will))
(targ-op "##will-testator"      (targ-ifjump-apply-u "WILLTESTATOR"))
(targ-op "##will-testator-set!" (targ-apply-simp-u #f #t 1 "WILLTESTATORSET"))
(targ-op "##will-action"        (targ-ifjump-apply-u "WILLACTION"))
(targ-op "##will-action-set!"   (targ-apply-simp-u #f #t 1 "WILLACTIONSET"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##foreign-tags"       (targ-ifjump-apply-u "FOREIGNTAGS"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##gc-hash-table-ref"     (targ-apply-simp-u #f #f #f "GCHASHTABLEREF"))
(targ-op "##gc-hash-table-set!"    (targ-apply-simp-u #f #f 0 "GCHASHTABLESET")) ;;TODO: what should be ssb-space?
(targ-op "##gc-hash-table-union!"  (targ-apply-simp-u #f #f 0 "GCHASHTABLEUNION")) ;;TODO: what should be ssb-space?
(targ-op "##gc-hash-table-find!"   (targ-apply-simp-u #f #f 0 "GCHASHTABLEFIND")) ;;TODO: what should be ssb-space?
(targ-op "##gc-hash-table-rehash!" (targ-apply-simp-u #f #f 0 "GCHASHTABLEREHASH")) ;;TODO

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##values"           (targ-apply-vector-s 'values))
(targ-op "##values-length"    (targ-apply-simp-u #f #f #f "VALUESLENGTH"))
(targ-op "##values-ref"       (targ-apply-simp-u #f #f #f "VALUESREF"))
(targ-op "##values-set!"      (targ-apply-simp-u #f #t #f "VALUESSET"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##string"           (targ-apply-vector-u 'string))
(targ-op "##make-string-small"      (targ-apply-small-alloc-u 'string "MAKESTRINGSMALL"))
(targ-op "##substring-small"        (targ-apply-small-alloc-u 'string "SUBSTRINGSMALL"))
(targ-op "##string-copy-small"      (targ-apply-small-alloc-u 'string "STRINGCOPYSMALL"))
(targ-op "##string-set-small"       (targ-apply-small-alloc-u 'string "STRINGUPDATESMALL"))
(targ-op "##string-insert-small"    (targ-apply-small-alloc-u 'string "STRINGINSERTSMALL"))
(targ-op "##string-delete-small"    (targ-apply-small-alloc-u 'string "STRINGDELETESMALL"))
(targ-op "##string-length"    (targ-apply-simp-u #f #f #f "STRINGLENGTH"))
(targ-op "##string-ref"       (targ-apply-simp-u #f #f #f "STRINGREF"))
(targ-op "##string-set!"      (targ-apply-simp-u #f #t #f "STRINGSET"))
(targ-op "##string-shrink!"   (targ-apply-simp-u #f #t #f "STRINGSHRINK"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##vector"           (targ-apply-vector-s 'vector))
(targ-op "##make-vector-small"      (targ-apply-small-alloc-u 'vector "MAKEVECTORSMALL"))
(targ-op "##subvector-small"        (targ-apply-small-alloc-u 'vector "SUBVECTORSMALL"))
(targ-op "##vector-copy-small"      (targ-apply-small-alloc-u 'vector "VECTORCOPYSMALL"))
(targ-op "##vector-set-small"       (targ-apply-small-alloc-u 'vector "VECTORUPDATESMALL"))
(targ-op "##vector-insert-small"    (targ-apply-small-alloc-u 'vector "VECTORINSERTSMALL"))
(targ-op "##vector-delete-small"    (targ-apply-small-alloc-u 'vector "VECTORDELETESMALL"))
(targ-op "##vector-length"    (targ-apply-simp-u #f #f #f "VECTORLENGTH"))
(targ-op "##vector-ref"       (targ-ifjump-apply-u "VECTORREF"))
(targ-op "##vector-set!"      (targ-apply-simp-u #f #t 1 "VECTORSET"))
(targ-op "##vector-shrink!"   (targ-apply-simp-u #f #t #f "VECTORSHRINK"))
(targ-op "##vector-cas!"      (targ-apply-simp-u #f 'expr 1 "VECTORCAS"))

(targ-op
 "##vector-inc!"
 (targ-setup-inlinable-proc
  #f ;; proc-safe?
  'expr ;; side-effects?
  #f ;; flo-result?
  (lambda (opnds sn)
    (let* ((arg1 (targ-opnd (car opnds)))
           (arg2 (targ-opnd (cadr opnds)))
           (arg3 (targ-opnd (if (= (length opnds) 3)
                                (caddr opnds)
                                (make-obj 1)))))
      (list "VECTORINC" arg1 arg2 arg3)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##s8vector"         (targ-apply-vector-u 's8vector))
(targ-op "##make-s8vector-small"    (targ-apply-small-alloc-u 's8vector "MAKES8VECTORSMALL"))
(targ-op "##subs8vector-small"      (targ-apply-small-alloc-u 's8vector "SUBS8VECTORSMALL"))
(targ-op "##s8vector-copy-small"    (targ-apply-small-alloc-u 's8vector "S8VECTORCOPYSMALL"))
(targ-op "##s8vector-set-small"     (targ-apply-small-alloc-u 's8vector "S8VECTORUPDATESMALL"))
(targ-op "##s8vector-insert-small"  (targ-apply-small-alloc-u 's8vector "S8VECTORINSERTSMALL"))
(targ-op "##s8vector-delete-small"  (targ-apply-small-alloc-u 's8vector "S8VECTORDELETESMALL"))
(targ-op "##s8vector-length"  (targ-apply-simp-u #f #f #f "S8VECTORLENGTH"))
(targ-op "##s8vector-ref"     (targ-apply-simp-u #f #f #f "S8VECTORREF"))
(targ-op "##s8vector-set!"    (targ-apply-simp-u #f #t #f "S8VECTORSET"))
(targ-op "##s8vector-shrink!" (targ-apply-simp-u #f #t #f "S8VECTORSHRINK"))

(targ-op "##u8vector"         (targ-apply-vector-u 'u8vector))
(targ-op "##make-u8vector-small"    (targ-apply-small-alloc-u 'u8vector "MAKEU8VECTORSMALL"))
(targ-op "##subu8vector-small"      (targ-apply-small-alloc-u 'u8vector "SUBU8VECTORSMALL"))
(targ-op "##u8vector-copy-small"    (targ-apply-small-alloc-u 'u8vector "U8VECTORCOPYSMALL"))
(targ-op "##u8vector-set-small"     (targ-apply-small-alloc-u 'u8vector "U8VECTORUPDATESMALL"))
(targ-op "##u8vector-insert-small"  (targ-apply-small-alloc-u 'u8vector "U8VECTORINSERTSMALL"))
(targ-op "##u8vector-delete-small"  (targ-apply-small-alloc-u 'u8vector "U8VECTORDELETESMALL"))
(targ-op "##u8vector-length"  (targ-apply-simp-u #f #f #f "U8VECTORLENGTH"))
(targ-op "##u8vector-ref"     (targ-apply-simp-u #f #f #f "U8VECTORREF"))
(targ-op "##u8vector-set!"    (targ-apply-simp-u #f #t #f "U8VECTORSET"))
(targ-op "##u8vector-shrink!" (targ-apply-simp-u #f #t #f "U8VECTORSHRINK"))

(targ-op "##s16vector"        (targ-apply-vector-u 's16vector))
(targ-op "##make-s16vector-small"   (targ-apply-small-alloc-u 's16vector "MAKES16VECTORSMALL"))
(targ-op "##subs16vector-small"     (targ-apply-small-alloc-u 's16vector "SUBS16VECTORSMALL"))
(targ-op "##s16vector-copy-small"   (targ-apply-small-alloc-u 's16vector "S16VECTORCOPYSMALL"))
(targ-op "##s16vector-set-small"    (targ-apply-small-alloc-u 's16vector "S16VECTORUPDATESMALL"))
(targ-op "##s16vector-insert-small" (targ-apply-small-alloc-u 's16vector "S16VECTORINSERTSMALL"))
(targ-op "##s16vector-delete-small" (targ-apply-small-alloc-u 's16vector "S16VECTORDELETESMALL"))
(targ-op "##s16vector-length" (targ-apply-simp-u #f #f #f "S16VECTORLENGTH"))
(targ-op "##s16vector-ref"    (targ-apply-simp-u #f #f #f "S16VECTORREF"))
(targ-op "##s16vector-set!"   (targ-apply-simp-u #f #t #f "S16VECTORSET"))
(targ-op "##s16vector-shrink!"(targ-apply-simp-u #f #t #f "S16VECTORSHRINK"))

(targ-op "##u16vector"        (targ-apply-vector-u 'u16vector))
(targ-op "##make-u16vector-small"   (targ-apply-small-alloc-u 'u16vector "MAKEU16VECTORSMALL"))
(targ-op "##subu16vector-small"     (targ-apply-small-alloc-u 'u16vector "SUBU16VECTORSMALL"))
(targ-op "##u16vector-copy-small"   (targ-apply-small-alloc-u 'u16vector "U16VECTORCOPYSMALL"))
(targ-op "##u16vector-set-small"    (targ-apply-small-alloc-u 'u16vector "U16VECTORUPDATESMALL"))
(targ-op "##u16vector-insert-small" (targ-apply-small-alloc-u 'u16vector "U16VECTORINSERTSMALL"))
(targ-op "##u16vector-delete-small" (targ-apply-small-alloc-u 'u16vector "U16VECTORDELETESMALL"))
(targ-op "##u16vector-length" (targ-apply-simp-u #f #f #f "U16VECTORLENGTH"))
(targ-op "##u16vector-ref"    (targ-apply-simp-u #f #f #f "U16VECTORREF"))
(targ-op "##u16vector-set!"   (targ-apply-simp-u #f #t #f "U16VECTORSET"))
(targ-op "##u16vector-shrink!"(targ-apply-simp-u #f #t #f "U16VECTORSHRINK"))

(targ-op "##s32vector"        (targ-apply-vector-u 's32vector))
(targ-op "##make-s32vector-small"   (targ-apply-small-alloc-u 's32vector "MAKES32VECTORSMALL"))
(targ-op "##subs32vector-small"     (targ-apply-small-alloc-u 's32vector "SUBS32VECTORSMALL"))
(targ-op "##s32vector-copy-small"   (targ-apply-small-alloc-u 's32vector "S32VECTORCOPYSMALL"))
(targ-op "##s32vector-set-small"    (targ-apply-small-alloc-u 's32vector "S32VECTORUPDATESMALL"))
(targ-op "##s32vector-insert-small" (targ-apply-small-alloc-u 's32vector "S32VECTORINSERTSMALL"))
(targ-op "##s32vector-delete-small" (targ-apply-small-alloc-u 's32vector "S32VECTORDELETESMALL"))
(targ-op "##s32vector-length" (targ-apply-simp-u #f #f #f "S32VECTORLENGTH"))
(targ-op "##s32vector-ref"    (targ-apply-simpbig-u "S32VECTORREF"))
(targ-op "##s32vector-set!"   (targ-apply-simp-u #f #t #f "S32VECTORSET"))
(targ-op "##s32vector-shrink!"(targ-apply-simp-u #f #t #f "S32VECTORSHRINK"))

(targ-op "##u32vector"        (targ-apply-vector-u 'u32vector))
(targ-op "##make-u32vector-small"   (targ-apply-small-alloc-u 'u32vector "MAKEU32VECTORSMALL"))
(targ-op "##subu32vector-small"     (targ-apply-small-alloc-u 'u32vector "SUBU32VECTORSMALL"))
(targ-op "##u32vector-copy-small"   (targ-apply-small-alloc-u 'u32vector "U32VECTORCOPYSMALL"))
(targ-op "##u32vector-set-small"    (targ-apply-small-alloc-u 'u32vector "U32VECTORUPDATESMALL"))
(targ-op "##u32vector-insert-small" (targ-apply-small-alloc-u 'u32vector "U32VECTORINSERTSMALL"))
(targ-op "##u32vector-delete-small" (targ-apply-small-alloc-u 'u32vector "U32VECTORDELETESMALL"))
(targ-op "##u32vector-length" (targ-apply-simp-u #f #f #f "U32VECTORLENGTH"))
(targ-op "##u32vector-ref"    (targ-apply-simpbig-u "U32VECTORREF"))
(targ-op "##u32vector-set!"   (targ-apply-simp-u #f #t #f "U32VECTORSET"))
(targ-op "##u32vector-shrink!"(targ-apply-simp-u #f #t #f "U32VECTORSHRINK"))

(targ-op "##s64vector"        (targ-apply-vector-u 's64vector))
(targ-op "##make-s64vector-small"   (targ-apply-small-alloc-u 's64vector "MAKES64VECTORSMALL"))
(targ-op "##subs64vector-small"     (targ-apply-small-alloc-u 's64vector "SUBS64VECTORSMALL"))
(targ-op "##s64vector-copy-small"   (targ-apply-small-alloc-u 's64vector "S64VECTORCOPYSMALL"))
(targ-op "##s64vector-set-small"    (targ-apply-small-alloc-u 's64vector "S64VECTORUPDATESMALL"))
(targ-op "##s64vector-insert-small" (targ-apply-small-alloc-u 's64vector "S64VECTORINSERTSMALL"))
(targ-op "##s64vector-delete-small" (targ-apply-small-alloc-u 's64vector "S64VECTORDELETESMALL"))
(targ-op "##s64vector-length" (targ-apply-simp-u #f #f #f "S64VECTORLENGTH"))
(targ-op "##s64vector-ref"    (targ-apply-simpbig-u "S64VECTORREF"))
(targ-op "##s64vector-set!"   (targ-apply-simp-u #f #t #f "S64VECTORSET"))
(targ-op "##s64vector-shrink!"(targ-apply-simp-u #f #t #f "S64VECTORSHRINK"))

(targ-op "##u64vector"        (targ-apply-vector-u 'u64vector))
(targ-op "##make-u64vector-small"   (targ-apply-small-alloc-u 'u64vector "MAKEU64VECTORSMALL"))
(targ-op "##subu64vector-small"     (targ-apply-small-alloc-u 'u64vector "SUBU64VECTORSMALL"))
(targ-op "##u64vector-copy-small"   (targ-apply-small-alloc-u 'u64vector "U64VECTORCOPYSMALL"))
(targ-op "##u64vector-set-small"    (targ-apply-small-alloc-u 'u64vector "U64VECTORUPDATESMALL"))
(targ-op "##u64vector-insert-small" (targ-apply-small-alloc-u 'u64vector "U64VECTORINSERTSMALL"))
(targ-op "##u64vector-delete-small" (targ-apply-small-alloc-u 'u64vector "U64VECTORDELETESMALL"))
(targ-op "##u64vector-length" (targ-apply-simp-u #f #f #f "U64VECTORLENGTH"))
(targ-op "##u64vector-ref"    (targ-apply-simpbig-u "U64VECTORREF"))
(targ-op "##u64vector-set!"   (targ-apply-simp-u #f #t #f "U64VECTORSET"))
(targ-op "##u64vector-shrink!"(targ-apply-simp-u #f #t #f "U64VECTORSHRINK"))

(targ-op "##f32vector"        (targ-apply-vector-u 'f32vector))
(targ-op "##make-f32vector-small"   (targ-apply-small-alloc-u 'f32vector "MAKEF32VECTORSMALL"))
(targ-op "##subf32vector-small"     (targ-apply-small-alloc-u 'f32vector "SUBF32VECTORSMALL"))
(targ-op "##f32vector-copy-small"   (targ-apply-small-alloc-u 'f32vector "F32VECTORCOPYSMALL"))
(targ-op "##f32vector-set-small"    (targ-apply-small-alloc-u 'f32vector "F32VECTORUPDATESMALL"))
(targ-op "##f32vector-insert-small" (targ-apply-small-alloc-u 'f32vector "F32VECTORINSERTSMALL"))
(targ-op "##f32vector-delete-small" (targ-apply-small-alloc-u 'f32vector "F32VECTORDELETESMALL"))
(targ-op "##f32vector-length" (targ-apply-simp-u #f #f #f "F32VECTORLENGTH"))
(targ-op "##f32vector-ref"    (targ-apply-simpflo-u #f "F32VECTORREF"))
(targ-op "##f32vector-set!"   (targ-apply-simpflo3-u "F32VECTORSET"))
(targ-op "##f32vector-shrink!"(targ-apply-simp-u #f #t #f "F32VECTORSHRINK"))

(targ-op "##f64vector"        (targ-apply-vector-u 'f64vector))
(targ-op "##make-f64vector-small"   (targ-apply-small-alloc-u 'f64vector "MAKEF64VECTORSMALL"))
(targ-op "##subf64vector-small"     (targ-apply-small-alloc-u 'f64vector "SUBF64VECTORSMALL"))
(targ-op "##f64vector-copy-small"   (targ-apply-small-alloc-u 'f64vector "F64VECTORCOPYSMALL"))
(targ-op "##f64vector-set-small"    (targ-apply-small-alloc-u 'f64vector "F64VECTORUPDATESMALL"))
(targ-op "##f64vector-insert-small" (targ-apply-small-alloc-u 'f64vector "F64VECTORINSERTSMALL"))
(targ-op "##f64vector-delete-small" (targ-apply-small-alloc-u 'f64vector "F64VECTORDELETESMALL"))
(targ-op "##f64vector-length" (targ-apply-simp-u #f #f #f "F64VECTORLENGTH"))
(targ-op "##f64vector-ref"    (targ-apply-simpflo-u #f "F64VECTORREF"))
(targ-op "##f64vector-set!"   (targ-apply-simpflo3-u "F64VECTORSET"))
(targ-op "##f64vector-shrink!"(targ-apply-simp-u #f #t #f "F64VECTORSHRINK"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##bignum.negative?"        (targ-ifjump-simp-u #f "BIGNEGATIVEP"))
(targ-op "##bignum.adigit-length"    (targ-apply-simp-u #f #f #f "BIGALENGTH"))
(targ-op "##bignum.adigit-inc!"      (targ-apply-simp-u #f 'expr #f "BIGAINC"))
(targ-op "##bignum.adigit-dec!"      (targ-apply-simp-u #f 'expr #f "BIGADEC"))
(targ-op "##bignum.adigit-add!"      (targ-apply-simp-u #f 'expr #f "BIGAADD"))
(targ-op "##bignum.adigit-sub!"      (targ-apply-simp-u #f 'expr #f "BIGASUB"))
(targ-op "##bignum.mdigit-length"    (targ-apply-simp-u #f #f #f "BIGMLENGTH"))
(targ-op "##bignum.mdigit-ref"       (targ-apply-simp-u #f #f #f "BIGMREF"))
(targ-op "##bignum.mdigit-set!"      (targ-apply-simp-u #f #t #f "BIGMSET"))
(targ-op "##bignum.mdigit-mul!"      (targ-apply-simp-u #f 'expr #f "BIGMMUL"))
(targ-op "##bignum.mdigit-div!"      (targ-apply-simp-u #f 'expr #f "BIGMDIV"))
(targ-op "##bignum.mdigit-quotient"  (targ-apply-simp-u #f #f #f "BIGMQUO"))
(targ-op "##bignum.mdigit-remainder" (targ-apply-simp-u #f #f #f "BIGMREM"))
(targ-op "##bignum.mdigit-test?"     (targ-ifjump-simp-u #f "BIGMTESTP"))

(targ-op "##bignum.adigit-ones?"     (targ-ifjump-simp-u #f "BIGAONESP"))
(targ-op "##bignum.adigit-="         (targ-ifjump-simp-u #f "BIGAEQP"))
(targ-op "##bignum.adigit-<"         (targ-ifjump-simp-u #f "BIGALESSP"))
(targ-op "##bignum.adigit-zero?"     (targ-ifjump-simp-u #f "BIGAZEROP"))
(targ-op "##bignum.adigit-negative?" (targ-ifjump-simp-u #f "BIGANEGATIVEP"))
(targ-op "##fixnum->bignum"          (targ-apply-simpbig-u "BIGFROMFIX"))
(targ-op "##bignum.adigit-shrink!"   (targ-apply-simp-u #f #t #f "BIGASHRINK"))
(targ-op "##bignum.adigit-copy!"     (targ-apply-simp-u #f #t #f "BIGACOPY"))
(targ-op "##bignum.adigit-cat!"      (targ-apply-simp-u #f #t #f "BIGACAT"))
(targ-op "##bignum.adigit-bitwise-and!"  (targ-apply-simp-u #f #t #f "BIGAAND"))
(targ-op "##bignum.adigit-bitwise-andc1!"(targ-apply-simp-u #f #t #f "BIGAANDC1"))
(targ-op "##bignum.adigit-bitwise-andc2!"(targ-apply-simp-u #f #t #f "BIGAANDC2"))
(targ-op "##bignum.adigit-bitwise-eqv!"  (targ-apply-simp-u #f #t #f "BIGAEQV"))
(targ-op "##bignum.adigit-bitwise-ior!"  (targ-apply-simp-u #f #t #f "BIGAIOR"))
(targ-op "##bignum.adigit-bitwise-nand!" (targ-apply-simp-u #f #t #f "BIGANAND"))
(targ-op "##bignum.adigit-bitwise-nor!"  (targ-apply-simp-u #f #t #f "BIGANOR"))
(targ-op "##bignum.adigit-bitwise-not!"  (targ-apply-simp-u #f #t #f "BIGANOT"))
(targ-op "##bignum.adigit-bitwise-orc1!" (targ-apply-simp-u #f #t #f "BIGAORC1"))
(targ-op "##bignum.adigit-bitwise-orc2!" (targ-apply-simp-u #f #t #f "BIGAORC2"))
(targ-op "##bignum.adigit-bitwise-xor!"  (targ-apply-simp-u #f #t #f "BIGAXOR"))

(targ-op "##bignum.fdigit-length"    (targ-apply-simp-u #f #f #f "BIGFLENGTH"))
(targ-op "##bignum.fdigit-ref"       (targ-apply-simp-u #f #f #f "BIGFREF"))
(targ-op "##bignum.fdigit-set!"      (targ-apply-simp-u #f #t #f "BIGFSET"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##ratnum-make"        (targ-apply-ratnum-make))
(targ-op "##ratnum-numerator"   (targ-ifjump-apply-u "RATNUMNUMERATOR"))
(targ-op "##ratnum-denominator" (targ-ifjump-apply-u "RATNUMDENOMINATOR"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##cpxnum-make"        (targ-apply-cpxnum-make))
(targ-op "##cpxnum-real"        (targ-ifjump-apply-u "CPXNUMREAL"))
(targ-op "##cpxnum-imag"        (targ-ifjump-apply-u "CPXNUMIMAG"))
(targ-op "##real-part"          (targ-ifjump-apply-u "REALPART"))
(targ-op "##imag-part"          (targ-ifjump-apply-u "IMAGPART"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##make-uninterned-symbol" (targ-apply-make-symbol))
(targ-op "##symbol-name"        (targ-ifjump-apply-u "SYMBOLNAME"))
(targ-op "##symbol-name-set!"   (targ-apply-simp-u #f #t 1 "SYMBOLNAMESET"))
(targ-op "##symbol-hash"        (targ-ifjump-apply-u "SYMBOLHASH"))
(targ-op "##symbol-hash-set!"   (targ-apply-simp-u #f #t 1 "SYMBOLHASHSET"))
(targ-op "##symbol-interned?"   (targ-ifjump-apply-u "SYMBOLINTERNEDP"))
(targ-op "##symbol->string?"    (targ-apply-ifjump #f #f "SYMBOL2STRINGP" #f))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##make-uninterned-keyword" (targ-apply-make-keyword))
(targ-op "##keyword-name"       (targ-ifjump-apply-u "KEYWORDNAME"))
(targ-op "##keyword-name-set!"  (targ-apply-simp-u #f #t 1 "KEYWORDNAMESET"))
(targ-op "##keyword-hash"       (targ-ifjump-apply-u "KEYWORDHASH"))
(targ-op "##keyword-hash-set!"  (targ-apply-simp-u #f #t 1 "KEYWORDHASHSET"))
(targ-op "##keyword-interned?"  (targ-ifjump-apply-u "KEYWORDINTERNEDP"))
(targ-op "##keyword->string?"   (targ-apply-ifjump #f #f "KEYWORD2STRINGP" #f))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##structure-direct-instance-of?"
         (targ-ifjump-simp-s #f "STRUCTUREDIOP"))
(targ-op "##structure-type"
         (targ-ifjump-apply-u "STRUCTURETYPE"))
(targ-op "##structure-type-set!"
         (targ-apply-simp-u #f #t 1 "STRUCTURETYPESET"))
(targ-op "##structure"
         (targ-apply-vector-u 'structure))
(targ-op "##unchecked-structure-ref"
         (targ-ifjump-apply-u "UNCHECKEDSTRUCTUREREF"))
(targ-op "##unchecked-structure-set!"
         (targ-apply-simp-u #f #t 1 "UNCHECKEDSTRUCTURESET"))
(targ-op "##unchecked-structure-cas!"
         (targ-apply-simp-u #f 'expr 1 "UNCHECKEDSTRUCTURECAS"))

(targ-op "##type-id"          (targ-apply-simp-u #f #f #f "TYPEID"))
(targ-op "##type-name"        (targ-apply-simp-u #f #f #f "TYPENAME"))
(targ-op "##type-flags"       (targ-apply-simp-u #f #f #f "TYPEFLAGS"))
(targ-op "##type-super"       (targ-apply-simp-u #f #f #f "TYPESUPER"))
(targ-op "##type-fields"      (targ-apply-simp-u #f #f #f "TYPEFIELDS"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##closure-length"   (targ-apply-simp-u #f #f #f "CLOSURELENGTH"))
(targ-op "##closure-code"     (targ-apply-simp-u #f #f #f "CLOSURECODE"))
(targ-op "##closure-ref"      (targ-apply-simp-u #f #f #f "CLOSUREREF"))
(targ-op "##closure-set!"     (targ-apply-simp-u #f #t 1 "CLOSURESET"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##global-var-ref"
         (targ-apply-simp-u #f #f #f "GLOBALVARREF"))
(targ-op "##global-var-primitive-ref"
         (targ-apply-simp-u #f #f #f "GLOBALVARPRIMREF"))
(targ-op "##global-var-set!"
         (targ-apply-simp-u #f #t #f "GLOBALVARSET")) ;;TODO: should ssb-space be #f?
(targ-op "##global-var-primitive-set!"
         (targ-apply-simp-u #f #t #f "GLOBALVARPRIMSET")) ;;TODO: should ssb-space be #f?

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##make-delay-promise" (targ-apply-make-delay-promise))
(targ-op "##promise-state"      (targ-ifjump-apply-u "PROMISESTATE"))
(targ-op "##promise-state-set!" (targ-apply-simp-u #f #t 1 "PROMISESTATESET"))

(targ-op "##force"            (targ-apply-force))
(targ-op "##void"             (targ-apply-simp-s #f #f #f "VOID"))
(targ-op "##eof-object"       (targ-apply-simp-s #f #f #f "EOF"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##identity"         (targ-apply-first-argument))
(targ-op "##first-argument"   (targ-apply-first-argument))
(targ-op "##check-heap-limit" (targ-apply-check-heap-limit))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##current-thread"   (targ-apply-simp-s #f #f #f "CURRENTTHREAD"))
(targ-op "##current-processor" (targ-apply-simp-s #f #f #f "CURRENTPROCESSOR"))
(targ-op "##current-processor-id" (targ-apply-simp-s #f #f #f "CURRENTPROCESSORID"))
(targ-op "##processor"        (targ-apply-simp-s #f #f #f "PROCESSOR"))
(targ-op "##current-vm"       (targ-apply-simp-s #f #f #f "CURRENTVM"))

(targ-op "##primitive-lock!"    (targ-apply-simp-u #f #t 0 "PRIMITIVELOCK"))
(targ-op "##primitive-trylock!" (targ-ifjump-simp-u #f "PRIMITIVETRYLOCK"))
(targ-op "##primitive-unlock!"  (targ-apply-simp-u #f #t 0 "PRIMITIVEUNLOCK"))

(targ-op "##cpu-cycle-count-start" (targ-apply-cpu-cycle-count #t))
(targ-op "##cpu-cycle-count-end"   (targ-apply-cpu-cycle-count #f))

(targ-op "##object-before?"   (targ-ifjump-simp-s #f "OBJECTBEFOREP"))

(targ-op "##peek-char0?"
         (targ-setup-inlinable-proc-io-fast-path #t "PEEKCHAR0P"))
(targ-op "##peek-char1?"
         (targ-setup-inlinable-proc-io-fast-path #t "PEEKCHAR1P"))

(targ-op "##read-char0?"
         (targ-setup-inlinable-proc-io-fast-path #t "READCHAR0P"))
(targ-op "##read-char1?"
         (targ-setup-inlinable-proc-io-fast-path #t "READCHAR1P"))

(targ-op "##write-char1?"
         (targ-setup-inlinable-proc-io-fast-path #t "WRITECHAR1P"))
(targ-op "##write-char2?"
         (targ-setup-inlinable-proc-io-fast-path #t "WRITECHAR2P"))

(targ-op "##char-input-port?-cached"
         (targ-ifjump-simp-s #f "CHARINPUTPORTPCACHED"))

(targ-op "##char-output-port?-cached"
         (targ-ifjump-simp-s #f "CHAROUTPUTPORTPCACHED"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op
  "##c-code"
  (lambda (prim)
    (proc-obj-inlinable?-set! prim (lambda (env) #t))
    (proc-obj-inline-set!
      prim
      (lambda (opnds loc sn)
        (targ-use-all-res)
        (let ((n (length opnds)))
          (if (= n 0)
            (compiler-error
              "\"##c-code\" needs at least one argument")
            (let ((code (car opnds))
                  (args (map (lambda (opnd) (targ-opnd opnd))
                             (cdr opnds))))
              (if (and (obj? code)
                       (string? (obj-val code)))
                (let loop ((i (- n 1))
                           (rev-args (reverse args))
                           (lst1 (list "{ " c-id-prefix "SCMOBJ "
                                       c-id-prefix "RESULT;"
                                       #\newline
                                       (obj-val code)
                                       #\newline))
                           (lst2 (list #\newline
                                       "}")))
                  (if (null? rev-args)
                    (begin
                      (targ-emit (cons 'append lst1))
                      (if loc
                        (targ-emit (targ-loc loc '("RESULT"))))
                      (targ-emit (cons 'append (reverse lst2))))
                    (let ((arg (car rev-args)))
                      (loop (- i 1)
                            (cdr rev-args)
                            (append
                              (list "#define " c-id-prefix "ARG" i " " arg
                                    #\newline)
                              lst1)
                            (append
                              (list #\newline
                                    i "ARG" c-id-prefix "#undef ")
                              lst2)))))
                (compiler-error
                  "Argument 1 of \"##c-code\" must be a string constant")))))))))

)

(targ-setup-inlinable)

;;;----------------------------------------------------------------------------

;; Table of jump-inlinable operations (for 'jump' GVM instructions)

(define (targ-setup-jump-inlinable)

(targ-jump-inline "##thread-save!"
  (lambda (nb-args poll? safe?)
    (and (< 0 nb-args)
         (< nb-args 5)
         (let ((fs (frame-size targ-proc-exit-frame)))
           (targ-end-of-block-checks poll? fs)
           (targ-emit (targ-adjust-stack fs))
           (targ-emit-jump-inline "THREAD_SAVE" safe? nb-args)
           (targ-rd-fp)
           (targ-wr-fp)
           (targ-rd-reg 0)
           (targ-wr-reg 0)
           (targ-wr-reg (+ (targ-nb-arg-regs) 1))
           #t))))

(targ-jump-inline "##thread-restore!"
  (lambda (nb-args poll? safe?)
    (and (< 1 nb-args)
         (< nb-args 6)
         (let ((fs (frame-size targ-proc-exit-frame)))
           (targ-end-of-block-checks poll? fs)
           (targ-emit (targ-adjust-stack fs))
           (targ-emit-jump-inline "THREAD_RESTORE" safe? nb-args)
           (targ-rd-fp)
           (targ-wr-fp)
           (targ-wr-reg 0)
           (targ-wr-reg (+ (targ-nb-arg-regs) 1))
           #t))))

(targ-op "##make-continuation"
         (targ-apply-make-continuation))
;;(targ-op "##continuation-frame"
;;         (targ-ifjump-apply-u "CONTINUATIONFRAME"))
(targ-op "##continuation-frame-set!"
         (targ-apply-simp-u #f #t 1 "CONTINUATIONFRAMESET"))
(targ-op "##continuation-denv"
         (targ-ifjump-apply-u "CONTINUATIONDENV"))
(targ-op "##continuation-denv-set!"
         (targ-apply-simp-u #f #t 1 "CONTINUATIONDENVSET"))

(targ-jump-inline "##continuation-capture"
  (lambda (nb-args poll? safe?)
    (and (< 0 nb-args)
         (< nb-args 5)
         (let ((fs (frame-size targ-proc-exit-frame)))
           (targ-end-of-block-checks poll? fs)
           (targ-emit (targ-adjust-stack fs))
           (targ-emit-jump-inline "CONTINUATION_CAPTURE" safe? nb-args)
           (targ-rd-fp)
           (targ-wr-fp)
           (targ-pop-pcontext (targ-jump-info nb-args))
           (targ-push-pcontext (targ-label-info nb-args #t))
           #t))))

(targ-jump-inline "##continuation-graft-no-winding"
  (lambda (nb-args poll? safe?)
    (and (< 1 nb-args)
         (< nb-args 6)
         (let ((fs (frame-size targ-proc-exit-frame)))
           (targ-end-of-block-checks poll? fs)
           (targ-emit (targ-adjust-stack fs))
           (targ-emit-jump-inline "CONTINUATION_GRAFT_NO_WINDING" safe? nb-args)
           (targ-rd-fp)
           (targ-wr-fp)
           (targ-pop-pcontext (targ-jump-info nb-args))
           (targ-push-pcontext (targ-label-info (- nb-args 2) #t))
           #t))))

(targ-jump-inline "##continuation-return-no-winding"
  (lambda (nb-args poll? safe?)
    (and (= nb-args 2)
         (let ((fs (frame-size targ-proc-exit-frame)))
           (targ-end-of-block-checks poll? fs)
           (targ-emit (targ-adjust-stack fs))
           (targ-emit-jump-inline "CONTINUATION_RETURN_NO_WINDING" safe? nb-args)
           (targ-rd-fp)
           (targ-wr-fp)
           (targ-pop-pcontext (targ-jump-info nb-args))
           (targ-wr-reg 0)
           (targ-wr-reg 1)
           #t))))

)

(targ-setup-jump-inlinable)

;;;----------------------------------------------------------------------------
