;;;============================================================================

;;; File: "_t-c-2.scm", Time-stamp: <2009-06-05 17:37:02 feeley>

;;; Copyright (c) 1994-2009 by Marc Feeley, All Rights Reserved.

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

(define (targ-scan-procedure obj)
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

    (set! targ-proc-name               (proc-obj-name proc))
    (set! targ-proc-code               (make-stretchable-vector #f))
    (set! targ-proc-code-length        0)
    (set! targ-proc-rd-res             (make-stretchable-vector #f))
    (set! targ-proc-wr-res             (make-stretchable-vector #f))
    (set! targ-proc-lbl-tbl            (queue-empty))
    (set! targ-proc-lbl-tbl-ord        (queue-empty))
    (set! targ-debug-info?             #f)
    (set! targ-var-descr-queue         (queue-empty))
    (set! targ-first-class-label-queue (queue-empty))

;;    (targ-repr-begin-proc!)

    (let ((x (proc-obj-code proc)))
      (if (bbs? x)
        (targ-scan-scheme-procedure x)
        (targ-scan-c-procedure x)))

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
          (let ((info (targ-debug-info)))
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

(define (targ-debug-info)

  (define (number i lst)
    (if (null? lst)
      '()
      (cons (list->vect (cons i (car lst)))
            (number (+ i 1) (cdr lst)))))

  (if targ-debug-info?
    (vector (list->vect (number 0 (queue->list targ-first-class-label-queue)))
            (list->vect (queue->list targ-var-descr-queue)))
    #f))

(define (targ-scan-scheme-procedure bbs)

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

(define (targ-scan-c-procedure c-proc)

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
                     (list "DEF_GLBL" (targ-make-glbl "" targ-proc-name))
                     #\newline))

;;    (targ-repr-begin-block! 'entry targ-proc-entry-lbl)

    ; move arguments from registers to stack frame

    (let loop1 ((i 1))
      (if (and (<= i arity) (<= i targ-nb-arg-regs))
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

    (targ-emit
      (list 'append (c-proc-body c-proc)))

    (targ-emit
      (list "JUMPPRM"
            '("NOTHING")
            (targ-opnd (make-reg 0))))

;;    (targ-repr-exit-block! #f)

;;    (targ-repr-end-block!)

    (targ-emit-label-return lbl fs (- fs 1) (targ-build-gc-map-all-live fs) #f)

;;    (targ-repr-begin-block! 'return lbl)

    (targ-emit (targ-adjust-stack 0))

;;    (targ-repr-exit-block! #f)

    (targ-emit
      (list "JUMPPRM"
            '("NOTHING")
            (targ-opnd (make-stk fs))))

;;    (targ-repr-end-block!)
))

;;;----------------------------------------------------------------------------

;; Information attached to a procedure

(define targ-proc-name            #f) ; procedure's name
(define targ-proc-code            #f) ; code of the procedure
(define targ-proc-code-length     #f) ; length of code of the procedure
(define targ-proc-entry-lbl       #f) ; entry label
(define targ-proc-lbl-counter     #f) ; label counter
(define targ-proc-rd-res          #f) ; set of resources read from
(define targ-proc-wr-res          #f) ; set of resources written to
(define targ-proc-lbl-tbl         #f) ; table of all labels
(define targ-proc-lbl-tbl-ord     #f) ; table of all labels ordered by def time
(define targ-proc-fp              #f) ; frame pointer
(define targ-proc-hp              #f) ; heap pointer

(define targ-debug-info?             #f) ; generate debug information?
(define targ-var-descr-queue         #f)
(define targ-first-class-label-queue #f)

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
  (targ-emit-label lbl 'proc (vector nb-parms 0)))

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
    (targ-make-glbl (targ-lbl-num x) targ-proc-name)))

(define (targ-lbl-goto? lbl-struct)
  (vector-ref lbl-struct 1))

(define (targ-make-glbl n name)
  (list 'glbl n name))

;; To generate new, unique labels

(define (targ-new-lbl)
  (targ-proc-lbl-counter))

(define (targ-heap-reserve space)
  (set! targ-proc-hp (+ targ-proc-hp space)))

(define (targ-heap-reserve-and-check space sn)
  (targ-heap-reserve space)
  (if (> (+ targ-proc-hp
            (* (targ-fp-cache-size) targ-flonum-space))
         targ-msection-biggest)
    (targ-update-fr-and-check-heap space sn)))

(define (targ-update-fr-and-check-heap space sn)
  (targ-update-fr targ-proc-entry-frame)
  (targ-check-heap space sn))

(define (targ-check-heap space sn)
  (let ((lbl (targ-new-lbl)))
    (targ-need-heap)
    (targ-emit (targ-adjust-stack sn))
;;    (targ-repr-exit-block! lbl)
    (targ-emit
      (list "CHECK_HEAP"
            (targ-ref-lbl-val lbl)
            (+ targ-msection-biggest space)))
;;    (targ-repr-end-block!)
    (targ-gen-label-return* lbl 'return-internal)
    (set! targ-proc-hp 0)))

(define (targ-poll sn)
  (let ((lbl (targ-new-lbl)))
    (targ-rd-fp)
    (targ-emit (targ-adjust-stack sn))
;;    (targ-repr-exit-block! lbl)
    (targ-emit
      (list "POLL" (targ-ref-lbl-val lbl)))
;;    (targ-repr-end-block!)
    (targ-gen-label-return* lbl 'return-internal)))

(define (targ-start-bb fs)
  (set! targ-proc-hp 0)
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
               (if (< j targ-nb-gvm-regs)
                 (cons op (string-append "R" (number->string j)))
                 (if (eq? op 'd-)
                   (let ((k (- j targ-nb-gvm-regs)))
                     (list "D_F64"
                           (targ-unboxed-index->code k)))
                   #f))))))
    (and x (list 'append " " x))))

(define (targ-unboxed-loc->index loc)
  (cond ((reg? loc)
         (reg-num loc))
        ((stk? loc)
         (+ (- (stk-num loc) 1) targ-nb-gvm-regs))
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
        ((< i targ-nb-gvm-regs)
         (list (string-append
                "F64R"
                (number->string i))))
        (else
         (list (string-append
                "F64STK"
                (number->string (+ (- i targ-nb-gvm-regs) 1)))))))

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
    (+ n (+ targ-nb-non-reg-res targ-nb-gvm-regs))))

(define (targ-use-all-res)
  (let loop ((i (- (+ targ-nb-non-reg-res targ-nb-gvm-regs) 1)))
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

(define (targ-add-var-descr! descr)

  (define (index x l)
    (let loop ((l l) (i 0))
      (cond ((not (pair? l))    #f)
            ((equal? (car l) x) i)
            (else               (loop (cdr l) (+ i 1))))))

  (let ((n (index descr (queue->list targ-var-descr-queue))))
    (if n
      n
      (let ((m (length (queue->list targ-var-descr-queue))))
        (queue-put! targ-var-descr-queue descr)
        m))))

(define (targ-add-first-class-label! node slots frame)

  (define (encode slot)
    (let ((v (car slot))
          (i (cdr slot)))
      (+ (* i 32768)
         (if (pair? v)
           (* (targ-add-var-descr! (map encode v)) 2)
           (+ (* (targ-add-var-descr! (var-name v)) 2)
              (if (var-boxed? v) 1 0))))))

  (define (closure-env-slot closure-vars stack-slots)
    (let loop ((i 1) (lst1 closure-vars) (lst2 '()))
      (if (null? lst1)
        lst2
        (let ((x (car lst1)))
          (if (not (frame-live? x frame))
            (loop (+ i 1)
                  (cdr lst1)
                  lst2)
            (let ((y (assq (var-name x) stack-slots)))
              (if (and y (not (eq? x (cadr y))))
                (begin
                  (if (< (var-lexical-level (cadr y))
                         (var-lexical-level x))
                      (let ()
                        (##namespace ("" pp));****************
                        (pp (list
                             'closure-vars: (map var-name closure-vars)
                             'stack-slots: (map car stack-slots)
                             'source: (source->expression (node-source node))
                             ))
                        (compiler-internal-error
                         "targ-add-first-class-label!, variable conflict")))
                  (loop (+ i 1)
                        (cdr lst1)
                        lst2))
                (loop (+ i 1)
                      (cdr lst1)
                      (cons (cons x i) lst2)))))))))

  (define (accessible-slots)
    (let loop1 ((i 1)
                (lst1 slots)
                (lst2 '())
                (closure-env #f)
                (closure-env-index #f))
      (if (pair? lst1)
        (let* ((var (car lst1))
               (x (frame-live? var frame)))
          (cond ((pair? x) ; closure environment?
                 (if (or (not closure-env) (eq? var closure-env))
                   (loop1 (+ i 1)
                          (cdr lst1)
                          lst2
                          var
                          i)
                   (compiler-internal-error
                    "targ-add-first-class-label!, multiple closure environments")))
                ((or (not x) (temp-var? x)) ; not live or temporary var
                 (loop1 (+ i 1)
                        (cdr lst1)
                        lst2
                        closure-env
                        closure-env-index))
                (else
                 (let* ((name (var-name x))
                        (y (assq name lst2)))
                   (if (and y (not (eq? x (cadr y))))
                     (let ((level-x (var-lexical-level x))
                           (level-y (var-lexical-level (cadr y))))
                       (cond ((< level-x level-y)
                              (loop1 (+ i 1)
                                     (cdr lst1)
                                     lst2
                                     closure-env
                                     closure-env-index))
                             ((< level-y level-x)
                              (loop1 (+ i 1)
                                     (cdr lst1)
                                     (cons (cons name (cons x i)) (remq y lst2))
                                     closure-env
                                     closure-env-index))
                             (else
                              ; Two different live variables have the same
                              ; name and lexical level, both variables will
                              ; be kept in the debugging information
                              ; descriptor even though in the actual program
                              ; only one of the two variables is in scope.
                              ; "flatten" causes this condition to happen.
                              ; TODO: take variable scopes into account.
                              (loop1 (+ i 1)
                                     (cdr lst1)
                                     (cons (cons name (cons x i)) lst2)
                                     closure-env
                                     closure-env-index))))
                     (loop1 (+ i 1)
                            (cdr lst1)
                            (cons (cons name (cons x i)) lst2)
                            closure-env
                            closure-env-index))))))
        (let* ((x
                (if closure-env
                  (closure-env-slot (frame-live? closure-env frame) lst2)
                  '()))
               (accessible-stack-slots
                (map cdr lst2)))
          (if (null? x)
            accessible-stack-slots
            (cons (cons x closure-env-index)
                  accessible-stack-slots))))))

  (let ((label-descr
         (cons (if (and node
                        (or targ-debug-location-option?
                            targ-debug-source-option?))
                   (let ((src (node-source node)))
                     (set! targ-debug-info? #t)
                     (if targ-debug-location-option?
                         (if targ-debug-source-option?
                             src
                             (source-locat src))
                         (source->expression src)))
                   #f)
               (if (and node
                        (or targ-debug-environments-option?
                            (environment-map? (node-env node))))
                 (begin
                   (set! targ-debug-info? #t)
                   (map encode (accessible-slots)))
                 '()))))
    (queue-put! targ-first-class-label-queue label-descr)
    label-descr))

;;;----------------------------------------------------------------------------

(define (targ-gen-gvm-instr prev-gvm-instr gvm-instr next-gvm-instr sn)

  (set! targ-proc-instr-node
    (comment-get (gvm-instr-comment gvm-instr) 'node))
  (set! targ-proc-exit-frame
    (gvm-instr-frame gvm-instr))
  (set! targ-proc-entry-frame
    (and prev-gvm-instr (gvm-instr-frame prev-gvm-instr)))

;;  (write-gvm-instr gvm-instr ##stdout)(newline);*************

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
     (targ-gen-apply (apply-prim gvm-instr)
                     (apply-opnds gvm-instr)
                     (apply-loc gvm-instr)
                     sn))

    ((copy)
     (targ-gen-copy (copy-opnd gvm-instr)
                    (copy-loc gvm-instr)
                    sn))

    ((close)
     (targ-gen-close (close-parms gvm-instr)
                     sn))

    ((ifjump)
     (targ-gen-ifjump (ifjump-test gvm-instr)
                      (ifjump-opnds gvm-instr)
                      (ifjump-true gvm-instr)
                      (ifjump-false gvm-instr)
                      (ifjump-poll? gvm-instr)
                      (if (and next-gvm-instr
                               (memq (label-type next-gvm-instr)
                                     '(simple task-entry)))
                        (label-lbl-num next-gvm-instr)
                        #f)))

    ((switch)
     (targ-gen-switch (switch-opnd gvm-instr)
                      (switch-cases gvm-instr)
                      (switch-default gvm-instr)
                      (switch-poll? gvm-instr)
                      (if (and next-gvm-instr
                               (memq (label-type next-gvm-instr)
                                     '(simple task-entry)))
                        (label-lbl-num next-gvm-instr)
                        #f)))

    ((jump)
     (targ-gen-jump (jump-opnd gvm-instr)
                    (jump-nb-args gvm-instr)
                    (jump-poll? gvm-instr)
                    (jump-safe? gvm-instr)
                    (if (and next-gvm-instr
                             (memq (label-type next-gvm-instr)
                                   '(simple task-entry)))
                      (label-lbl-num next-gvm-instr)
                      #f)))

    (else
     (compiler-internal-error
       "targ-gen-gvm-instr, unknown 'gvm-instr'" gvm-instr))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-label-simple lbl sn)
  (targ-emit-label-simp lbl)
  (targ-begin-fr)
;;  (targ-repr-begin-block! 'simple lbl)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-label-entry lbl nb-parms opts keys rest? closed? sn)

  (let ((label-descr (targ-add-first-class-label!
                       targ-proc-instr-node
                       '()
                       targ-proc-exit-frame)))
    (if (= lbl targ-proc-entry-lbl)
      (begin
        (targ-emit-label-entry lbl nb-parms label-descr)
        (targ-ref-lbl-val lbl)
        (targ-ref-lbl-goto lbl))
      (let ((nb-closed (length (frame-closed targ-proc-exit-frame))));******
        (targ-emit-label-subproc lbl nb-parms nb-closed label-descr))))

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

        (let ((nb-stacked (max 0 (- nb-args targ-nb-arg-regs)))
              (nb-stacked* (max 0 (- nb-parms targ-nb-arg-regs))))

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
                       (list "DEF_GLBL" (targ-make-glbl "" targ-proc-name))
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
             (targ-add-first-class-label!
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
                                            (- targ-nb-gvm-regs
                                               (length regs))))
                      (list return-var)
                      (extend-vars '()
                                   (- (- (targ-align-frame
                                          (+ (+ targ-nb-gvm-regs 1)
                                             targ-frame-reserve))
                                         targ-frame-reserve)
                                      (+ targ-nb-gvm-regs 1)))))
             (gc-map
              (targ-build-gc-map
               vars
               (lambda (i var)
                 (or (frame-live? var frame)
                     (let ((j (- i cfs-after-alignment)))
                       (and (>= j 0) ; all saved GVM regs are live
                            (<= j targ-nb-gvm-regs))))))))
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
                        (targ-loc loc (list "ALLOC_CLO" (length opnds))))))
                  parms))))

  (close (reverse parms) sn)

  (targ-heap-reserve-and-check 0 sn))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-ifjump test opnds true-lbl false-lbl poll? next-lbl)
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
              (list "IF" (proc not? opnds fs)))
;;            (targ-repr-exit-block! branch-lbl)
            (targ-emit
              (list "GOTO" (targ-ref-lbl-goto branch-lbl)))
            (targ-emit
              '("END_IF"))
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
      (> targ-proc-hp 0)))

(define (targ-end-of-block-checks poll? sn)
  (if (> targ-proc-hp 0)
    (targ-check-heap 0 sn))
  (if poll?
    (targ-poll sn)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-gen-switch opnd cases default poll? next-lbl)

  (targ-update-fr targ-proc-entry-frame)

  (let* ((fs (frame-size targ-proc-exit-frame))
         (sn (targ-sn-opnd opnd fs)))

    (targ-end-of-block-checks poll? sn)

    (targ-emit
     (targ-adjust-stack fs))

    (let loop ((lst cases)
               (rev-cases-fixnum32 '())
               (rev-cases-char '())
               (rev-cases-symbol '())
               (rev-cases-keyword '())
               (rev-cases-other '()))
      (if (pair? lst)

        (let* ((c (car lst))
               (obj (switch-case-obj c)))
          (cond ((targ-fixnum32? obj)
                 (loop (cdr lst)
                       (cons c rev-cases-fixnum32)
                       rev-cases-char
                       rev-cases-symbol
                       rev-cases-keyword
                       rev-cases-other))
                ((char? obj)
                 (loop (cdr lst)
                       rev-cases-fixnum32
                       (cons c rev-cases-char)
                       rev-cases-symbol
                       rev-cases-keyword
                       rev-cases-other))
                ((symbol-object? obj)
                 (loop (cdr lst)
                       rev-cases-fixnum32
                       rev-cases-char
                       (cons c rev-cases-symbol)
                       rev-cases-keyword
                       rev-cases-other))
                ((keyword-object? obj)
                 (loop (cdr lst)
                       rev-cases-fixnum32
                       rev-cases-char
                       rev-cases-symbol
                       (cons c rev-cases-keyword)
                       rev-cases-other))
                (else
                 (loop (cdr lst)
                       rev-cases-fixnum32
                       rev-cases-char
                       rev-cases-symbol
                       rev-cases-keyword
                       (cons c rev-cases-other)))))

        (let* ((cases-fixnum32 (reverse rev-cases-fixnum32))
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

          (if (<= (length cases-fixnum32) 2)
            (begin
              (set! cases-other (append cases-fixnum32 cases-other))
              (set! cases-fixnum32 '())))

          (if (<= (length cases-char) 2)
            (begin
              (set! cases-other (append cases-char cases-other))
              (set! cases-char '())))
          
          (gen cases-other
               "BEGIN_SWITCH"
               "SWITCH_CASE_GOTO"
               "END_SWITCH")

          (gen cases-fixnum32
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

(define (targ-gen-jump opnd nb-args poll? safe? next-lbl)

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
                 (if (eq? (car x) 'prm)
                   (targ-emit
                     (list "JUMPPRM"
                           set-nargs
                           x))
                   (let ((name (proc-obj-name proc)))
                     (if (targ-arg-check-avoidable? proc nb-args)
                       (targ-emit
                         (list "JUMPINT"
                               set-nargs
                               x
                               (targ-make-glbl "" name)))
                       (targ-emit
                         (list 'seq
                               set-nargs
                               (list "JUMPINT"
                                     '("NOTHING")
                                     x
                                     (targ-make-glbl 0 name)))))))))
              ((glo? opnd)
;;               (targ-repr-exit-block! #f)
               (targ-emit
                 (cons (begin
                         (targ-wr-reg (+ targ-nb-arg-regs 1))
                         (if safe? "JUMPGLOSAFE" "JUMPGLONOTSAFE"))
                       (cons (if nb-args set-nargs '("NOTHING"))
                             (cdr (targ-opnd opnd))))))
              (else
;;               (targ-repr-exit-block! #f)
               (targ-emit
                 (list (if nb-args
                         (begin
                           (targ-wr-reg (+ targ-nb-arg-regs 1))
                           (if safe? "JUMPGENSAFE" "JUMPGENNOTSAFE"))
                         "JUMPPRM")
                       (if nb-args set-nargs '("NOTHING"))
                       (targ-opnd opnd)))))

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
          (if (< i targ-nb-gvm-regs)
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
                     (if (>= j targ-nb-gvm-regs)
                       (stretchable-vector-ref dst-loc-descrs j)
                       0)))
              (if (>= j targ-nb-gvm-regs)
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
          (if (< i targ-nb-gvm-regs)
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
                     (if (>= j1 targ-nb-gvm-regs)
                       (stretchable-vector-ref dst1-loc-descrs j1)
                       0))
                   (dst2-descr
                     (if (>= j2 targ-nb-gvm-regs)
                       (stretchable-vector-ref dst2-loc-descrs j2)
                       0)))
              (if (>= j1 targ-nb-gvm-regs)
                (stretchable-vector-set!
                  dst1-loc-descrs
                  j1
                  (targ-repr-entry-reprs-set
                    dst1-descr
                    (targ-repr-intersection
                      (targ-repr-entry-reprs dst1-descr)
                      src-reprs))))
              (if (>= j2 targ-nb-gvm-regs)
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

      (let loop ((i (- (+ targ-nb-gvm-regs src-fs) 1)))
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

      (let loop ((i (- (+ targ-nb-gvm-regs src-fs) 1)))
        (if (>= i 0)
          (let ((j (if (< i targ-nb-gvm-regs) i (- i offs))))
            (if (and (>= i targ-nb-gvm-regs)
                     (< j targ-nb-gvm-regs))
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
          (let loop ((i (- (+ targ-nb-gvm-regs fs) 1)))
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
         (+ (- (stk-num loc) 1) targ-nb-gvm-regs))
        (else
         (compiler-internal-error
           "targ-repr-loc->index, invalid 'loc'" loc))))

(define (targ-repr-index->loc i)
  (if (< i targ-nb-gvm-regs)
    (make-reg i)
    (make-stk (+ (- i targ-nb-gvm-regs) 1))))

(define (targ-repr-unboxed-index->code i repr)
  (let ((type (vector-ref targ-repr-types (- repr 1))))
    (targ-need-unboxed i repr)
    (if (< i targ-nb-gvm-regs)
      (list (string-append
              type
              "R"
              (number->string i)))
      (list (string-append
              type
              "STK"
              (number->string (+ (- i targ-nb-gvm-regs) 1)))))))

(define (targ-repr-index->code i repr)
  (if (= repr targ-repr-boxed)
    (if (< i targ-nb-gvm-regs)
      (cons 'r i)
      (list "STK" (- (+ (- i targ-nb-gvm-regs) 1) targ-proc-fp)))
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
           (list "GLO"
                 (targ-use-glo name #f)
                 (targ-c-id-glo (symbol->string name)))))

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
           (list "GLO"
                 (targ-use-glo name #f)
                 (targ-c-id-glo (symbol->string name)))))

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

(for-each targ-prim-proc-add!
          '(
            ("##c-code"  0            #t 0        0 (#f)   extended)
           ))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Procedure specialization

(define (targ-spec name specializer-maker)
  (let ((proc-name (string->canonical-symbol name)))
    (let ((proc (targ-get-prim-info name)))
      (proc-obj-specialize-set! proc (specializer-maker proc proc-name)))))

;; Safe specialization

(define (targ-s name)
  (lambda (proc proc-name)
    (let ((spec (targ-get-prim-info name)))
      (lambda (env args) spec))))

;; Unsafe specialization

(define (targ-u name)
  (lambda (proc proc-name)
    (let ((spec (targ-get-prim-info name)))
      (lambda (env args) (if (not (safe? env)) spec proc)))))

;; Arithmetic specialization

(define (targ-arith fix-name flo-name)
  (lambda (proc proc-name)
    (let ((fix-spec (if fix-name (targ-get-prim-info fix-name) proc))
          (flo-spec (if flo-name (targ-get-prim-info flo-name) proc)))
      (lambda (env args)
        (let ((arith (arith-implementation proc-name env)))
          (cond ((eq? arith fixnum-sym)
                 fix-spec)
                ((eq? arith flonum-sym)
                 flo-spec)
                (else
                 proc)))))))

;; Safe specialization for eqv? and ##eqv?

(define (targ-s-eqv?)
  (lambda (proc proc-name)
    (let ((spec (targ-get-prim-info "##eq?")))
      (lambda (env args)
        (if (and (= (length args) 2)
                 (or (eq? (arith-implementation proc-name env) fixnum-sym)
                     (targ-eq-testable-object? (car args))
                     (targ-eq-testable-object? (cadr args))))
          spec
          proc)))))

;; Safe specialization for equal? and ##equal?

(define (targ-s-equal?)
  (lambda (proc proc-name)
    (let ((spec (targ-get-prim-info "##eq?")))
      (lambda (env args)
        (if (and (= (length args) 2)
                 (or (targ-eq-testable-object? (car args))
                     (targ-eq-testable-object? (cadr args))))
          spec
          proc)))))

(define (targ-eq-testable-object? obj)
  (and (not (void-object? obj)) ; the void-object denotes a non-constant
       (targ-testable-with-eq? obj)))

(define (targ-testable-with-eq? obj)
  (or (symbol-object? obj)
      (keyword-object? obj)
      (memq (targ-obj-type obj)
            '(boolean null absent unused deleted void eof optional
              key rest
              fixnum32 char))))

;;;----------------------------------------------------------------------------

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
    #t
    #f
    #f
    (targ-apply-simp-generator #f "CONS")))

(define (targ-apply-list)
  (targ-apply-alloc
    (lambda (n) (* n targ-pair-space))
    #t
    #f
    #f
    (lambda (opnds sn)
      (cond ((null? opnds)
             '("NUL"))
            ((null? (cdr opnds))
             (list "CONS" (targ-opnd (car opnds)) '("NUL")))
            (else
             (let* ((rev-elements (reverse (map targ-opnd opnds)))
                    (n (length rev-elements)))
               (targ-emit
                 (list "BEGIN_ALLOC_LIST" n (car rev-elements)))
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
    #t
    #f
    #f
    (targ-apply-simp-generator #f "BOX")))

(define (targ-apply-make-will)
  (targ-apply-alloc
    (lambda (n) targ-will-space)
    #t
    'expr ; this is an expression with side-effects
    #f
    (lambda (opnds sn)
      (targ-apply-simp-gen opnds #f "MAKEWILL"))))

(define (targ-apply-make-promise)
  (targ-apply-alloc
    (lambda (n) targ-promise-space)
    #t
    #f
    #f
    (targ-apply-simp-generator #f "MAKEPROMISE")))

(define (targ-apply-vector-s kind)
  (targ-apply-vector #t kind))

(define (targ-apply-vector-u kind)
  (targ-apply-vector #f kind))

(define (targ-apply-vector proc-safe? kind)
  (targ-setup-inlinable-proc
    proc-safe?
    #f
    #f
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
                (list begin-allocator-name n))
              (for-each-index (lambda (elem i)
                                (targ-emit
                                  (list add-element i elem)))
                              elements)
              (targ-emit
                (list end-allocator-name n))
              (list getter-operation n))))))))

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
    #t
    (lambda (opnds sn)
      (targ-opnd (car opnds)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-apply-check-heap-limit)
  (lambda (prim)
    (proc-obj-inlinable?-set! prim (lambda (env) #t))
    (proc-obj-inline-set!
      prim
      (lambda (opnds loc sn)
        (if (> targ-proc-hp 0)
          (targ-update-fr-and-check-heap 0 sn))
        (if loc
          (targ-emit
            (targ-loc loc (targ-opnd (make-obj false-object)))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-ifjump-simp-s flo? name)
  (targ-ifjump-simp #t flo? name))

(define (targ-ifjump-simp-u flo? name)
  (targ-ifjump-simp #f flo? name))

(define (targ-ifjump-simp proc-safe? flo? name)
  (targ-setup-test-proc*
    proc-safe?
    flo?
    (targ-ifjump-simp-generator flo? name)))

(define (targ-ifjump-fold-s flo? name)
  (targ-ifjump-fold #t flo? name))

(define (targ-ifjump-fold-u flo? name)
  (targ-ifjump-fold #f flo? name))

(define (targ-ifjump-fold proc-safe? flo? name)
  (targ-setup-test-proc*
    proc-safe?
    flo?
    (targ-ifjump-fold-generator flo? name)))

(define (targ-ifjump-apply-s name)
  (targ-ifjump-apply #t name))

(define (targ-ifjump-apply-u name)
  (targ-ifjump-apply #f name))

(define (targ-ifjump-apply proc-safe? name)
  (targ-setup-inlinable-proc*
    proc-safe?
    (targ-apply-simp-generator #f name)))

(define (targ-apply-simp-s flo? side-effects? name)
  (targ-apply-simp #t flo? side-effects? name))

(define (targ-apply-simp-u flo? side-effects? name)
  (targ-apply-simp #f flo? side-effects? name))

(define (targ-apply-simp proc-safe? flo? side-effects? name); prim. with non-flonum result
  (targ-setup-inlinable-proc
    proc-safe?
    side-effects?
    #f
    (targ-apply-simp-generator flo? name)))

(define (targ-apply-fold-s flo? name0 name1 name2)
  (targ-apply-fold #t flo? name0 name1 name2))

(define (targ-apply-fold-u flo? name0 name1 name2)
  (targ-apply-fold #f flo? name0 name1 name2))

(define (targ-apply-fold proc-safe? flo? name0 name1 name2)
  (let ((generator (targ-apply-fold-generator flo? name0 name1 name2)))
    (if flo?
      (targ-apply-alloc
        (lambda (n) 0) ; targ-apply-alloc accounts for space for flonum result
        proc-safe?
        #f
        #t
        generator)
      (targ-setup-inlinable-proc
        proc-safe?
        #f
        #f
        generator))))

(define (targ-apply-simpflo-s flo? name)
  (targ-apply-simpflo #t flo? name))

(define (targ-apply-simpflo-u flo? name)
  (targ-apply-simpflo #f flo? name))

(define (targ-apply-simpflo proc-safe? flo? name) ; prim. with flonum result
  (targ-apply-alloc
    (lambda (n) 0) ; targ-apply-alloc accounts for space for flonum result
    proc-safe?
    #f
    #t
    (targ-apply-simp-generator flo? name)))

(define (targ-apply-simpflo2-s flo? name1 name2)
  (targ-apply-simpflo2 #t flo? name1 name2))

(define (targ-apply-simpflo2-u flo? name1 name2)
  (targ-apply-simpflo2 #f flo? name1 name2))

(define (targ-apply-simpflo2 proc-safe? flo? name1 name2) ; 1 or 2 arg prim. with flonum result
  (targ-apply-alloc
    (lambda (n) 0) ; targ-apply-alloc accounts for space for flonum result
    proc-safe?
    #f
    #t
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
    #t
    #f
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
    #f
    #f
    (lambda (opnds sn)
      (targ-apply-simp-gen opnds #f name))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (targ-setup-test-proc* proc-safe? args-flo? generator)
  (lambda (prim)
    ((targ-setup-test-proc proc-safe? args-flo? generator)
     prim)
    ((targ-setup-inlinable-proc
       proc-safe?
       #f
       #f
       (lambda (opnds sn)
         (list "BOOLEAN" (generator opnds sn))))
     prim)))

(define (targ-setup-test-proc proc-safe? args-flo? generator)
  (lambda (prim)
    (proc-obj-testable?-set!
      prim
      (lambda (env)
        (or proc-safe?
            (not (safe? env)))))
    (proc-obj-test-set!
      prim
      (vector
        args-flo?
        (lambda (not? opnds fs)
          (let ((test (generator opnds fs)))
            (if not?
              (list "NOT" test)
              test)))))))

(define (targ-ifjump-simp-generator flo? name)
  (lambda (opnds fs)
    (targ-ifjump-simp-gen opnds flo? name)))

(define (targ-ifjump-simp-gen opnds flo? name)
  (let loop ((l opnds) (args '()))
    (if (pair? l)
      (let ((opnd (car l)))
        (loop (cdr l)
              (cons (if flo? (targ-opnd-flo opnd) (targ-opnd opnd))
                    args)))
      (cons name (reverse args)))))

(define (targ-ifjump-fold-generator flo? name)
  (lambda (opnds fs)
    (targ-ifjump-fold-gen opnds flo? name)))

(define (targ-ifjump-fold-gen opnds flo? name)

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
       #f ; safe to assume that arguments are not all flonums
       (lambda (opnds fs)
         (list "NOT" (list "FALSEP" (generator opnds fs)))))
     prim)
    ((targ-setup-inlinable-proc proc-safe? #f #f generator)
     prim)))

(define (targ-setup-inlinable-proc proc-safe? side-effects? flo-result? generator)
  (lambda (prim)
    (proc-obj-inlinable?-set!
      prim
      (lambda (env)
        (or proc-safe?
            (not (safe? env)))))
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

(define (targ-apply-simp-generator flo? name)
  (lambda (opnds sn)
    (targ-apply-simp-gen opnds flo? name)))

(define (targ-apply-simp-gen opnds flo? name)
  (let loop ((l opnds) (args '()))
    (if (pair? l)
      (let ((opnd (car l)))
        (loop (cdr l)
              (cons (if flo? (targ-opnd-flo opnd) (targ-opnd opnd))
                    args)))
      (cons name (reverse args)))))

(define (targ-apply-fold-generator flo? name0 name1 name2)
  (lambda (opnds sn)
    (targ-apply-fold-gen opnds flo? name0 name1 name2)))

(define (targ-apply-fold-gen opnds flo? name0 name1 name2)
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
                    (list name2
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

(define (targ-setup-inlinable)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##type"             (targ-apply-simp-s #f #f "TYPE"))
(targ-op "##type-cast"        (targ-apply-simp-u #f #f "TYPECAST"))
(targ-op "##subtype"          (targ-apply-simp-u #f #f "SUBTYPE"))
(targ-op "##subtype-set!"     (targ-apply-simp-u #f #t "SUBTYPESET"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##not"              (targ-ifjump-simp-s #f "FALSEP"))
(targ-op "##boolean?"         (targ-ifjump-simp-s #f "BOOLEANP"))
(targ-op "##null?"            (targ-ifjump-simp-s #f "NULLP"))
(targ-op "##unbound?"         (targ-ifjump-simp-s #f "UNBOUNDP"))
(targ-op "##eq?"              (targ-ifjump-simp-s #f "EQP"))
(targ-op "##eof-object?"      (targ-ifjump-simp-s #f "EOFP"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##fixnum?"          (targ-ifjump-simp-s #f "FIXNUMP"))
(targ-op "##special?"         (targ-ifjump-simp-s #f "SPECIALP"))
(targ-op "##pair?"            (targ-ifjump-simp-s #f "PAIRP"))
(targ-op "##pair-mutable?"    (targ-ifjump-simp-s #f "PAIRMUTABLEP"))
(targ-op "##subtyped?"        (targ-ifjump-simp-s #f "SUBTYPEDP"))
(targ-op "##subtyped-mutable?"(targ-ifjump-simp-s #f "SUBTYPEDMUTABLEP"))
(targ-op "##subtyped.vector?" (targ-ifjump-simp-u #f "SUBTYPEDVECTORP"))
(targ-op "##subtyped.symbol?" (targ-ifjump-simp-u #f "SUBTYPEDSYMBOLP"))
(targ-op "##subtyped.flonum?" (targ-ifjump-simp-u #f "SUBTYPEDFLONUMP"))
(targ-op "##subtyped.bignum?" (targ-ifjump-simp-u #f "SUBTYPEDBIGNUMP"))
(targ-op "##vector?"          (targ-ifjump-simp-s #f "VECTORP"))
(targ-op "##ratnum?"          (targ-ifjump-simp-s #f "RATNUMP"))
(targ-op "##cpxnum?"          (targ-ifjump-simp-s #f "CPXNUMP"))
(targ-op "##structure?"       (targ-ifjump-simp-s #f "STRUCTUREP"))
(targ-op "##box?"             (targ-ifjump-simp-s #f "BOXP"))
(targ-op "##values?"          (targ-ifjump-simp-s #f "VALUESP"))
(targ-op "##meroon?"          (targ-ifjump-simp-s #f "MEROONP"))
(targ-op "##jazz?"            (targ-ifjump-simp-s #f "JAZZP"))
(targ-op "##symbol?"          (targ-ifjump-simp-s #f "SYMBOLP"))
(targ-op "##keyword?"         (targ-ifjump-simp-s #f "KEYWORDP"))
(targ-op "##frame?"           (targ-ifjump-simp-s #f "FRAMEP"))
(targ-op "##continuation?"    (targ-ifjump-simp-s #f "CONTINUATIONP"))
(targ-op "##promise?"         (targ-ifjump-simp-s #f "PROMISEP"))
(targ-op "##will?"            (targ-ifjump-simp-s #f "WILLP"))
(targ-op "##gc-hash-table?"   (targ-ifjump-simp-s #f "GCHASHTABLEP"))
(targ-op "##mem-allocated?"   (targ-ifjump-simp-s #f "MEMALLOCATEDP"))
(targ-op "##procedure?"       (targ-ifjump-simp-s #f "PROCEDUREP"))
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

;;the following primitives can't be inlined because they have
;;non-trivial definitions which depend on some configuration
;;information provided by lib/_num.scm:
;;(targ-op "##real?"            (targ-ifjump-simp-s #f "REALP"))
;;(targ-op "##rational?"        (targ-ifjump-simp-s #f "RATIONALP"))
;;(targ-op "##integer?"         (targ-ifjump-simp-s #f "INTEGERP"))
;;(targ-op "##exact?"           (targ-ifjump-simp-s #f "EXACTP"))
;;(targ-op "##inexact?"         (targ-ifjump-simp-s #f "INEXACTP"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##fixnum.max"       (targ-apply-fold-u #f #f       "FIXPOS" "FIXMAX"))
(targ-op "##fixnum.min"       (targ-apply-fold-u #f #f       "FIXPOS" "FIXMIN"))

(targ-op "##fixnum.wrap+"     (targ-apply-fold-u #f "FIX_0"  "FIXPOS" "FIXADD"))
(targ-op "##fixnum.+"         (targ-apply-fold-u #f "FIX_0"  "FIXPOS" "FIXADD"))
(targ-op "##fixnum.+?"        (targ-apply-fold-u #f "FIX_0"  #f       "FIXADDP"))
(targ-op "##fixnum.wrap*"     (targ-apply-fold-u #f "FIX_1"  "FIXPOS" "FIXMUL"))
(targ-op "##fixnum.*"         (targ-apply-fold-u #f "FIX_1"  "FIXPOS" "FIXMUL"))
(targ-op "##fixnum.*?"        (targ-apply-fold-u #f "FIX_1"  #f       "FIXMULP"))
(targ-op "##fixnum.wrap-"     (targ-apply-fold-u #f #f       "FIXNEG" "FIXSUB"))
(targ-op "##fixnum.-"         (targ-apply-fold-u #f #f       "FIXNEG" "FIXSUB"))
(targ-op "##fixnum.-?"        (targ-apply-fold-u #f #f       "FIXNEGP""FIXSUBP"))
(targ-op "##fixnum.wrapquotient"(targ-apply-fold-u #f #f       #f       "FIXQUO"))
(targ-op "##fixnum.quotient"  (targ-apply-fold-u #f #f       #f       "FIXQUO"))
(targ-op "##fixnum.remainder" (targ-apply-fold-u #f #f       #f       "FIXREM"))
(targ-op "##fixnum.modulo"    (targ-apply-fold-u #f #f       #f       "FIXMOD"))
(targ-op "##fixnum.bitwise-ior"(targ-apply-fold-u #f "FIX_0"  "FIXPOS" "FIXIOR"))
(targ-op "##fixnum.bitwise-xor"(targ-apply-fold-u #f "FIX_0"  "FIXPOS" "FIXXOR"))
(targ-op "##fixnum.bitwise-and"(targ-apply-fold-u #f "FIX_M1" "FIXPOS" "FIXAND"))
(targ-op "##fixnum.bitwise-not"(targ-apply-simp-u #f #f "FIXNOT"))
(targ-op "##fixnum.wraparithmetic-shift"     (targ-apply-simp-u #f #f "FIXASH"))
(targ-op "##fixnum.arithmetic-shift"         (targ-apply-simp-u #f #f "FIXASH"))
(targ-op "##fixnum.arithmetic-shift?"        (targ-apply-simp-u #f #f "FIXASHP"))
(targ-op "##fixnum.wraparithmetic-shift-left"(targ-apply-simp-u #f #f "FIXASHL"))
(targ-op "##fixnum.arithmetic-shift-left"    (targ-apply-simp-u #f #f "FIXASHL"))
(targ-op "##fixnum.arithmetic-shift-left?"   (targ-apply-simp-u #f #f "FIXASHLP"))
(targ-op "##fixnum.arithmetic-shift-right"   (targ-apply-simp-u #f #f "FIXASHR"))
(targ-op "##fixnum.arithmetic-shift-right?"  (targ-apply-simp-u #f #f "FIXASHRP"))
(targ-op "##fixnum.wraplogical-shift-right"  (targ-apply-simp-u #f #f "FIXLSHR"))
(targ-op "##fixnum.wraplogical-shift-right?" (targ-apply-simp-u #f #f "FIXLSHRP"))
(targ-op "##fixnum.wrapabs"    (targ-apply-simp-u #f #f "FIXABS"))
(targ-op "##fixnum.abs"        (targ-apply-simp-u #f #f "FIXABS"))
(targ-op "##fixnum.abs?"       (targ-apply-simp-u #f #f "FIXABSP"))

(targ-op "##fixnum.zero?"     (targ-ifjump-simp-u #f "FIXZEROP"))
(targ-op "##fixnum.positive?" (targ-ifjump-simp-u #f "FIXPOSITIVEP"))
(targ-op "##fixnum.negative?" (targ-ifjump-simp-u #f "FIXNEGATIVEP"))
(targ-op "##fixnum.odd?"      (targ-ifjump-simp-u #f "FIXODDP"))
(targ-op "##fixnum.even?"     (targ-ifjump-simp-u #f "FIXEVENP"))
(targ-op "##fixnum.="         (targ-ifjump-fold-u #f "FIXEQ"))
(targ-op "##fixnum.<"         (targ-ifjump-fold-u #f "FIXLT"))
(targ-op "##fixnum.>"         (targ-ifjump-fold-u #f "FIXGT"))
(targ-op "##fixnum.<="        (targ-ifjump-fold-u #f "FIXLE"))
(targ-op "##fixnum.>="        (targ-ifjump-fold-u #f "FIXGE"))

(targ-op "##fixnum.->char"    (targ-apply-simp-u #f #f "FIXTOCHR"))
(targ-op "##fixnum.<-char"    (targ-apply-simp-u #f #f "FIXFROMCHR"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##flonum.->fixnum"  (targ-apply-simp-u #t #f "F64TOFIX"))
(targ-op "##flonum.<-fixnum"  (targ-apply-simpflo-u #f "F64FROMFIX"))

(targ-op "##flonum.max"       (targ-apply-fold-u #t #f      "F64POS" "F64MAX"))
(targ-op "##flonum.min"       (targ-apply-fold-u #t #f      "F64POS" "F64MIN"))

(targ-op "##flonum.+"         (targ-apply-fold-u #t "F64_0" "F64POS" "F64ADD"))
(targ-op "##flonum.*"         (targ-apply-fold-u #t "F64_1" "F64POS" "F64MUL"))
(targ-op "##flonum.-"         (targ-apply-fold-u #t #f      "F64NEG" "F64SUB"))
(targ-op "##flonum./"         (targ-apply-fold-u #t #f      "F64INV" "F64DIV"))
(targ-op "##flonum.abs"       (targ-apply-simpflo-u #t "F64ABS"))
(targ-op "##flonum.floor"     (targ-apply-simpflo-u #t "F64FLOOR"))
(targ-op "##flonum.ceiling"   (targ-apply-simpflo-u #t "F64CEILING"))
(targ-op "##flonum.truncate"  (targ-apply-simpflo-u #t "F64TRUNCATE"))
(targ-op "##flonum.round"     (targ-apply-simpflo-u #t "F64ROUND"))
(targ-op "##flonum.exp"       (targ-apply-simpflo-u #t "F64EXP"))
(targ-op "##flonum.log"       (targ-apply-simpflo-u #t "F64LOG"))
(targ-op "##flonum.sin"       (targ-apply-simpflo-u #t "F64SIN"))
(targ-op "##flonum.cos"       (targ-apply-simpflo-u #t "F64COS"))
(targ-op "##flonum.tan"       (targ-apply-simpflo-u #t "F64TAN"))
(targ-op "##flonum.asin"      (targ-apply-simpflo-u #t "F64ASIN"))
(targ-op "##flonum.acos"      (targ-apply-simpflo-u #t "F64ACOS"))
(targ-op "##flonum.atan"      (targ-apply-simpflo2-u #t "F64ATAN" "F64ATAN2"))
(targ-op "##flonum.expt"      (targ-apply-simpflo-u #t "F64EXPT"))
(targ-op "##flonum.sqrt"      (targ-apply-simpflo-u #t "F64SQRT"))
(targ-op "##flonum.copysign"  (targ-apply-simpflo-u #t "F64COPYSIGN"))

(targ-op "##flonum.integer?"  (targ-ifjump-simp-u #t "F64INTEGERP"))
(targ-op "##flonum.zero?"     (targ-ifjump-simp-u #t "F64ZEROP"))
(targ-op "##flonum.positive?" (targ-ifjump-simp-u #t "F64POSITIVEP"))
(targ-op "##flonum.negative?" (targ-ifjump-simp-u #t "F64NEGATIVEP"))
(targ-op "##flonum.odd?"      (targ-ifjump-simp-u #t "F64ODDP"))
(targ-op "##flonum.even?"     (targ-ifjump-simp-u #t "F64EVENP"))
(targ-op "##flonum.finite?"   (targ-ifjump-simp-u #t "F64FINITEP"))
(targ-op "##flonum.infinite?" (targ-ifjump-simp-u #t "F64INFINITEP"))
(targ-op "##flonum.nan?"      (targ-ifjump-simp-u #t "F64NANP"))
(targ-op "##flonum.<-fixnum-exact?" (targ-ifjump-simp-u #f "F64FROMFIXEXACTP"))
(targ-op "##flonum.="         (targ-ifjump-fold-u #t "F64EQ"))
(targ-op "##flonum.<"         (targ-ifjump-fold-u #t "F64LT"))
(targ-op "##flonum.>"         (targ-ifjump-fold-u #t "F64GT"))
(targ-op "##flonum.<="        (targ-ifjump-fold-u #t "F64LE"))
(targ-op "##flonum.>="        (targ-ifjump-fold-u #t "F64GE"))

;; new fixnum primitives

(targ-op "##fxmax"          (targ-apply-fold-u #f #f       "FIXPOS" "FIXMAX"))
(targ-op "##fxmin"          (targ-apply-fold-u #f #f       "FIXPOS" "FIXMIN"))

(targ-op "##fxwrap+"        (targ-apply-fold-u #f "FIX_0"  "FIXPOS" "FIXADD"))
(targ-op "##fx+"            (targ-apply-fold-u #f "FIX_0"  "FIXPOS" "FIXADD"))
(targ-op "##fx+?"           (targ-apply-fold-u #f "FIX_0"  #f       "FIXADDP"))
(targ-op "##fxwrap*"        (targ-apply-fold-u #f "FIX_1"  "FIXPOS" "FIXMUL"))
(targ-op "##fx*"            (targ-apply-fold-u #f "FIX_1"  "FIXPOS" "FIXMUL"))
(targ-op "##fx*?"           (targ-apply-fold-u #f "FIX_1"  #f       "FIXMULP"))
(targ-op "##fxwrap-"        (targ-apply-fold-u #f #f       "FIXNEG" "FIXSUB"))
(targ-op "##fx-"            (targ-apply-fold-u #f #f       "FIXNEG" "FIXSUB"))
(targ-op "##fx-?"           (targ-apply-fold-u #f #f       "FIXNEGP""FIXSUBP"))
(targ-op "##fxwrapquotient" (targ-apply-fold-u #f #f       #f       "FIXQUO"))
(targ-op "##fxquotient"     (targ-apply-fold-u #f #f       #f       "FIXQUO"))
(targ-op "##fxremainder"    (targ-apply-fold-u #f #f       #f       "FIXREM"))
(targ-op "##fxmodulo"       (targ-apply-fold-u #f #f       #f       "FIXMOD"))
(targ-op "##fxnot"          (targ-apply-simp-u #f #f "FIXNOT"))
(targ-op "##fxand"          (targ-apply-fold-u #f "FIX_M1" "FIXPOS" "FIXAND"))
(targ-op "##fxior"          (targ-apply-fold-u #f "FIX_0"  "FIXPOS" "FIXIOR"))
(targ-op "##fxxor"          (targ-apply-fold-u #f "FIX_0"  "FIXPOS" "FIXXOR"))
(targ-op "##fxif"           (targ-apply-simp-u #f #f "FIXIF"))
(targ-op "##fxbit-count"    (targ-apply-simp-u #f #f "FIXBITCOUNT"))
(targ-op "##fxlength"       (targ-apply-simp-u #f #f "FIXLENGTH"))
(targ-op "##fxfirst-bit-set"(targ-apply-simp-u #f #f "FIXFIRSTBITSET"))
(targ-op "##fxbit-set?"     (targ-ifjump-simp-u #f "FIXBITSETP"))
(targ-op "##fxwraparithmetic-shift"     (targ-apply-simp-u #f #f "FIXASH"))
(targ-op "##fxarithmetic-shift"         (targ-apply-simp-u #f #f "FIXASH"))
(targ-op "##fxarithmetic-shift?"        (targ-apply-simp-u #f #f "FIXASHP"))
(targ-op "##fxwraparithmetic-shift-left"(targ-apply-simp-u #f #f "FIXASHL"))
(targ-op "##fxarithmetic-shift-left"    (targ-apply-simp-u #f #f "FIXASHL"))
(targ-op "##fxarithmetic-shift-left?"   (targ-apply-simp-u #f #f "FIXASHLP"))
(targ-op "##fxarithmetic-shift-right"   (targ-apply-simp-u #f #f "FIXASHR"))
(targ-op "##fxarithmetic-shift-right?"  (targ-apply-simp-u #f #f "FIXASHRP"))
(targ-op "##fxwraplogical-shift-right"  (targ-apply-simp-u #f #f "FIXLSHR"))
(targ-op "##fxwraplogical-shift-right?" (targ-apply-simp-u #f #f "FIXLSHRP"))
(targ-op "##fxwrapabs"      (targ-apply-simp-u #f #f "FIXABS"))
(targ-op "##fxabs"          (targ-apply-simp-u #f #f "FIXABS"))
(targ-op "##fxabs?"         (targ-apply-simp-u #f #f "FIXABSP"))

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

(targ-op "##fx->char"    (targ-apply-simp-u #f #f "FIXTOCHR"))
(targ-op "##fx<-char"    (targ-apply-simp-u #f #f "FIXFROMCHR"))

(targ-op "##fixnum->char"   (targ-apply-simp-u #f #f "FIXTOCHR"))
(targ-op "##char->fixnum"   (targ-apply-simp-u #f #f "FIXFROMCHR"))
(targ-op "##flonum->fixnum" (targ-apply-simp-u #t #f "F64TOFIX"))
(targ-op "##fixnum->flonum" (targ-apply-simpflo-u #f "F64FROMFIX"))
(targ-op "##fixnum->flonum-exact?" (targ-ifjump-simp-u #f "F64FROMFIXEXACTP"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; new flonum primitives

(targ-op "##fl->fx"  (targ-apply-simp-u #t #f "F64TOFIX"))
(targ-op "##fl<-fx"  (targ-apply-simpflo-u #f "F64FROMFIX"))

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
(targ-op "##flexp"       (targ-apply-simpflo-u #t "F64EXP"))
(targ-op "##fllog"       (targ-apply-simpflo-u #t "F64LOG"))
(targ-op "##flsin"       (targ-apply-simpflo-u #t "F64SIN"))
(targ-op "##flcos"       (targ-apply-simpflo-u #t "F64COS"))
(targ-op "##fltan"       (targ-apply-simpflo-u #t "F64TAN"))
(targ-op "##flasin"      (targ-apply-simpflo-u #t "F64ASIN"))
(targ-op "##flacos"      (targ-apply-simpflo-u #t "F64ACOS"))
(targ-op "##flatan"      (targ-apply-simpflo2-u #t "F64ATAN" "F64ATAN2"))
(targ-op "##flexpt"      (targ-apply-simpflo-u #t "F64EXPT"))
(targ-op "##flsqrt"      (targ-apply-simpflo-u #t "F64SQRT"))
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
(targ-op "##fl<-fx-exact?" (targ-ifjump-simp-u #f "F64FROMFIXEXACTP"))
(targ-op "##fl="         (targ-ifjump-fold-u #t "F64EQ"))
(targ-op "##fl<"         (targ-ifjump-fold-u #t "F64LT"))
(targ-op "##fl>"         (targ-ifjump-fold-u #t "F64GT"))
(targ-op "##fl<="        (targ-ifjump-fold-u #t "F64LE"))
(targ-op "##fl>="        (targ-ifjump-fold-u #t "F64GE"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##char=?"           (targ-ifjump-fold-u #f "CHAREQP"))
(targ-op "##char<?"           (targ-ifjump-fold-u #f "CHARLTP"))
(targ-op "##char>?"           (targ-ifjump-fold-u #f "CHARGTP"))
(targ-op "##char<=?"          (targ-ifjump-fold-u #f "CHARLEP"))
(targ-op "##char>=?"          (targ-ifjump-fold-u #f "CHARGEP"))

(targ-op "##char-alphabetic?" (targ-ifjump-simp-u #f "CHARALPHABETICP"))
(targ-op "##char-numeric?"    (targ-ifjump-simp-u #f "CHARNUMERICP"))
(targ-op "##char-whitespace?" (targ-ifjump-simp-u #f "CHARWHITESPACEP"))
(targ-op "##char-upper-case?" (targ-ifjump-simp-u #f "CHARUPPERCASEP"))
(targ-op "##char-lower-case?" (targ-ifjump-simp-u #f "CHARLOWERCASEP"))
(targ-op "##char-upcase"      (targ-apply-simp-u #f #f "CHARUPCASE"))
(targ-op "##char-downcase"    (targ-apply-simp-u #f #f "CHARDOWNCASE"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##cons"             (targ-apply-cons))
(targ-op "##set-car!"         (targ-apply-simp-u #f #t "SETCAR"))
(targ-op "##set-cdr!"         (targ-apply-simp-u #f #t "SETCDR"))
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
(targ-op "##set-box!"         (targ-apply-simp-u #f #t "SETBOX"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##make-will"        (targ-apply-make-will))
(targ-op "##will-testator"    (targ-ifjump-apply-u "WILLTESTATOR"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##gc-hash-table-ref"     (targ-apply-simp-u #f #f "GCHASHTABLEREF"))
(targ-op "##gc-hash-table-set!"    (targ-apply-simp-u #f #f "GCHASHTABLESET"))
(targ-op "##gc-hash-table-rehash!" (targ-apply-simp-u #f #f "GCHASHTABLEREHASH"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##values"           (targ-apply-vector-s 'values))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##string"           (targ-apply-vector-u 'string))
(targ-op "##string-length"    (targ-apply-simp-u #f #f "STRINGLENGTH"))
(targ-op "##string-ref"       (targ-apply-simp-u #f #f "STRINGREF"))
(targ-op "##string-set!"      (targ-apply-simp-u #f #t "STRINGSET"))
(targ-op "##string-shrink!"   (targ-apply-simp-u #f #t "STRINGSHRINK"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##vector"           (targ-apply-vector-s 'vector))
(targ-op "##vector-length"    (targ-apply-simp-u #f #f "VECTORLENGTH"))
(targ-op "##vector-ref"       (targ-ifjump-apply-u "VECTORREF"))
(targ-op "##vector-set!"      (targ-apply-simp-u #f #t "VECTORSET"))
(targ-op "##vector-shrink!"   (targ-apply-simp-u #f #t "VECTORSHRINK"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##s8vector"         (targ-apply-vector-u 's8vector))
(targ-op "##s8vector-length"  (targ-apply-simp-u #f #f "S8VECTORLENGTH"))
(targ-op "##s8vector-ref"     (targ-apply-simp-u #f #f "S8VECTORREF"))
(targ-op "##s8vector-set!"    (targ-apply-simp-u #f #t "S8VECTORSET"))
(targ-op "##s8vector-shrink!" (targ-apply-simp-u #f #t "S8VECTORSHRINK"))

(targ-op "##u8vector"         (targ-apply-vector-u 'u8vector))
(targ-op "##u8vector-length"  (targ-apply-simp-u #f #f "U8VECTORLENGTH"))
(targ-op "##u8vector-ref"     (targ-apply-simp-u #f #f "U8VECTORREF"))
(targ-op "##u8vector-set!"    (targ-apply-simp-u #f #t "U8VECTORSET"))
(targ-op "##u8vector-shrink!" (targ-apply-simp-u #f #t "U8VECTORSHRINK"))

(targ-op "##s16vector"        (targ-apply-vector-u 's16vector))
(targ-op "##s16vector-length" (targ-apply-simp-u #f #f "S16VECTORLENGTH"))
(targ-op "##s16vector-ref"    (targ-apply-simp-u #f #f "S16VECTORREF"))
(targ-op "##s16vector-set!"   (targ-apply-simp-u #f #t "S16VECTORSET"))
(targ-op "##s16vector-shrink!"(targ-apply-simp-u #f #t "S16VECTORSHRINK"))

(targ-op "##u16vector"        (targ-apply-vector-u 'u16vector))
(targ-op "##u16vector-length" (targ-apply-simp-u #f #f "U16VECTORLENGTH"))
(targ-op "##u16vector-ref"    (targ-apply-simp-u #f #f "U16VECTORREF"))
(targ-op "##u16vector-set!"   (targ-apply-simp-u #f #t "U16VECTORSET"))
(targ-op "##u16vector-shrink!"(targ-apply-simp-u #f #t "U16VECTORSHRINK"))

(targ-op "##s32vector"        (targ-apply-vector-u 's32vector))
(targ-op "##s32vector-length" (targ-apply-simp-u #f #f "S32VECTORLENGTH"))
(targ-op "##s32vector-ref"    (targ-apply-simpbig-u "S32VECTORREF"))
(targ-op "##s32vector-set!"   (targ-apply-simp-u #f #t "S32VECTORSET"))
(targ-op "##s32vector-shrink!"(targ-apply-simp-u #f #t "S32VECTORSHRINK"))

(targ-op "##u32vector"        (targ-apply-vector-u 'u32vector))
(targ-op "##u32vector-length" (targ-apply-simp-u #f #f "U32VECTORLENGTH"))
(targ-op "##u32vector-ref"    (targ-apply-simpbig-u "U32VECTORREF"))
(targ-op "##u32vector-set!"   (targ-apply-simp-u #f #t "U32VECTORSET"))
(targ-op "##u32vector-shrink!"(targ-apply-simp-u #f #t "U32VECTORSHRINK"))

(targ-op "##s64vector"        (targ-apply-vector-u 's64vector))
(targ-op "##s64vector-length" (targ-apply-simp-u #f #f "S64VECTORLENGTH"))
(targ-op "##s64vector-ref"    (targ-apply-simpbig-u "S64VECTORREF"))
(targ-op "##s64vector-set!"   (targ-apply-simp-u #f #t "S64VECTORSET"))
(targ-op "##s64vector-shrink!"(targ-apply-simp-u #f #t "S64VECTORSHRINK"))

(targ-op "##u64vector"        (targ-apply-vector-u 'u64vector))
(targ-op "##u64vector-length" (targ-apply-simp-u #f #f "U64VECTORLENGTH"))
(targ-op "##u64vector-ref"    (targ-apply-simpbig-u "U64VECTORREF"))
(targ-op "##u64vector-set!"   (targ-apply-simp-u #f #t "U64VECTORSET"))
(targ-op "##u64vector-shrink!"(targ-apply-simp-u #f #t "U64VECTORSHRINK"))

(targ-op "##f32vector"        (targ-apply-vector-u 'f32vector))
(targ-op "##f32vector-length" (targ-apply-simp-u #f #f "F32VECTORLENGTH"))
(targ-op "##f32vector-ref"    (targ-apply-simpflo-u #f "F32VECTORREF"))
(targ-op "##f32vector-set!"   (targ-apply-simpflo3-u "F32VECTORSET"))
(targ-op "##f32vector-shrink!"(targ-apply-simp-u #f #t "F32VECTORSHRINK"))

(targ-op "##f64vector"        (targ-apply-vector-u 'f64vector))
(targ-op "##f64vector-length" (targ-apply-simp-u #f #f "F64VECTORLENGTH"))
(targ-op "##f64vector-ref"    (targ-apply-simpflo-u #f "F64VECTORREF"))
(targ-op "##f64vector-set!"   (targ-apply-simpflo3-u "F64VECTORSET"))
(targ-op "##f64vector-shrink!"(targ-apply-simp-u #f #t "F64VECTORSHRINK"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##bignum.negative?"        (targ-ifjump-simp-u #f "BIGNEGATIVEP"))
(targ-op "##bignum.adigit-length"    (targ-apply-simp-u #f #f "BIGALENGTH"))
(targ-op "##bignum.adigit-inc!"      (targ-apply-simp-u #f 'expr "BIGAINC"))
(targ-op "##bignum.adigit-dec!"      (targ-apply-simp-u #f 'expr "BIGADEC"))
(targ-op "##bignum.adigit-add!"      (targ-apply-simp-u #f 'expr "BIGAADD"))
(targ-op "##bignum.adigit-sub!"      (targ-apply-simp-u #f 'expr "BIGASUB"))
(targ-op "##bignum.mdigit-length"    (targ-apply-simp-u #f #f "BIGMLENGTH"))
(targ-op "##bignum.mdigit-ref"       (targ-apply-simp-u #f #f "BIGMREF"))
(targ-op "##bignum.mdigit-set!"      (targ-apply-simp-u #f #t "BIGMSET"))
(targ-op "##bignum.mdigit-mul!"      (targ-apply-simp-u #f 'expr "BIGMMUL"))
(targ-op "##bignum.mdigit-div!"      (targ-apply-simp-u #f 'expr "BIGMDIV"))
(targ-op "##bignum.mdigit-quotient"  (targ-apply-simp-u #f #f "BIGMQUO"))
(targ-op "##bignum.mdigit-remainder" (targ-apply-simp-u #f #f "BIGMREM"))
(targ-op "##bignum.mdigit-test?"     (targ-ifjump-simp-u #f "BIGMTESTP"))

(targ-op "##bignum.adigit-ones?"     (targ-ifjump-simp-u #f "BIGAONESP"))
(targ-op "##bignum.adigit-="         (targ-ifjump-simp-u #f "BIGAEQP"))
(targ-op "##bignum.adigit-<"         (targ-ifjump-simp-u #f "BIGALESSP"))
(targ-op "##bignum.adigit-zero?"     (targ-ifjump-simp-u #f "BIGAZEROP"))
(targ-op "##bignum.adigit-negative?" (targ-ifjump-simp-u #f "BIGANEGATIVEP"))
(targ-op "##bignum.->fixnum"         (targ-apply-simp-u #f #f "BIGTOFIX"))
(targ-op "##bignum.<-fixnum"         (targ-apply-simpbig-u "BIGFROMFIX"))
(targ-op "##bignum.adigit-shrink!"   (targ-apply-simp-u #f #t "BIGASHRINK"))
(targ-op "##bignum.adigit-copy!"     (targ-apply-simp-u #f #t "BIGACOPY"))
(targ-op "##bignum.adigit-cat!"      (targ-apply-simp-u #f #t "BIGACAT"))
(targ-op "##bignum.adigit-bitwise-and!"(targ-apply-simp-u #f #t "BIGAAND"))
(targ-op "##bignum.adigit-bitwise-ior!"(targ-apply-simp-u #f #t "BIGAIOR"))
(targ-op "##bignum.adigit-bitwise-xor!"(targ-apply-simp-u #f #t "BIGAXOR"))
(targ-op "##bignum.adigit-bitwise-not!"(targ-apply-simp-u #f #t "BIGANOT"))

(targ-op "##bignum.fdigit-length"    (targ-apply-simp-u #f #f "BIGFLENGTH"))
(targ-op "##bignum.fdigit-ref"       (targ-apply-simp-u #f #f "BIGFREF"))
(targ-op "##bignum.fdigit-set!"      (targ-apply-simp-u #f #t "BIGFSET"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##structure-direct-instance-of?"
         (targ-ifjump-simp-s #f "STRUCTUREDIOP"))
(targ-op "##structure-type"
         (targ-ifjump-apply-u "STRUCTURETYPE"))
(targ-op "##structure-type-set!"
         (targ-apply-simp-u #f #t "STRUCTURETYPESET"))
(targ-op "##structure"
         (targ-apply-vector-u 'structure))
(targ-op "##unchecked-structure-ref"
         (targ-ifjump-apply-u "UNCHECKEDSTRUCTUREREF"))
(targ-op "##unchecked-structure-set!"
         (targ-apply-simp-u #f #t "UNCHECKEDSTRUCTURESET"))

(targ-op "##type-id"          (targ-apply-simp-u #f #f "TYPEID"))
(targ-op "##type-name"        (targ-apply-simp-u #f #f "TYPENAME"))
(targ-op "##type-flags"       (targ-apply-simp-u #f #f "TYPEFLAGS"))
(targ-op "##type-super"       (targ-apply-simp-u #f #f "TYPESUPER"))
(targ-op "##type-fields"      (targ-apply-simp-u #f #f "TYPEFIELDS"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##closure-length"   (targ-apply-simp-u #f #f "CLOSURELENGTH"))
(targ-op "##closure-code"     (targ-apply-simp-u #f #f "CLOSURECODE"))
(targ-op "##closure-ref"      (targ-apply-simp-u #f #f "CLOSUREREF"))
(targ-op "##closure-set!"     (targ-apply-simp-u #f #t "CLOSURESET"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##global-var-ref"
         (targ-apply-simp-u #f #f "GLOBALVARREF"))
(targ-op "##global-var-primitive-ref"
         (targ-apply-simp-u #f #f "GLOBALVARPRIMREF"))
(targ-op "##global-var-set!"
         (targ-apply-simp-u #f #t "GLOBALVARSET"))
(targ-op "##global-var-primitive-set!"
         (targ-apply-simp-u #f #t "GLOBALVARPRIMSET"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##make-promise"     (targ-apply-make-promise))
(targ-op "##force"            (targ-apply-force))
(targ-op "##void"             (targ-apply-simp-s #f #f "VOID"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##first-argument"   (targ-apply-first-argument))
(targ-op "##check-heap-limit" (targ-apply-check-heap-limit))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-op "##current-thread"   (targ-apply-simp-s #f #f "CURRENTTHREAD"))
(targ-op "##run-queue"        (targ-apply-simp-s #f #f "RUNQUEUE"))

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
           (targ-end-of-block-checks #t fs) ; force a poll
           (targ-emit (targ-adjust-stack fs))
           (targ-emit-jump-inline "THREAD_SAVE" safe? nb-args)
           (targ-rd-fp)
           (targ-wr-fp)
           (targ-rd-reg 0)
           (targ-wr-reg 0)
           (targ-wr-reg (+ targ-nb-arg-regs 1))
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
           (targ-wr-reg (+ targ-nb-arg-regs 1))
           #t))))

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

;; Table of procedure specializations

(define (targ-setup-specializations)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-spec "not"         (targ-s "##not"))
(targ-spec "boolean?"    (targ-s "##boolean?"))
(targ-spec "null?"       (targ-s "##null?"))
(targ-spec "eq?"         (targ-s "##eq?"))
(targ-spec "eof-object?" (targ-s "##eof-object?"))

(targ-spec "pair?"       (targ-s "##pair?"))
(targ-spec "procedure?"  (targ-s "##procedure?"))
(targ-spec "vector?"     (targ-s "##vector?"))
(targ-spec "symbol?"     (targ-s "##symbol?"))
(targ-spec "keyword?"    (targ-s "##keyword?"))
(targ-spec "string?"     (targ-s "##string?"))
(targ-spec "char?"       (targ-s "##char?"))

(targ-spec "fixnum?"     (targ-s "##fixnum?"))
(targ-spec "flonum?"     (targ-s "##flonum?"))

(targ-spec "number?"     (targ-s "##number?"))
(targ-spec "complex?"    (targ-s "##complex?"))
(targ-spec "real?"       (targ-s "##real?"))
(targ-spec "rational?"   (targ-s "##rational?"))
(targ-spec "integer?"    (targ-s "##integer?"))

;;the following primitives must check that their parameter is a number:
;;(targ-spec "exact?"      (targ-s "##exact?"))
;;(targ-spec "inexact?"    (targ-s "##inexact?"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-spec "fx=" (targ-u "##fx="))
(targ-spec "fl=" (targ-u "##fl="))
(targ-spec "="   (targ-arith "fx=" "fl="))

(targ-spec "fx<" (targ-u "##fx<"))
(targ-spec "fl<" (targ-u "##fl<"))
(targ-spec "<"   (targ-arith "fx<" "fl<"))

(targ-spec "fx>" (targ-u "##fx>"))
(targ-spec "fl>" (targ-u "##fl>"))
(targ-spec ">"   (targ-arith "fx>" "fl>"))

(targ-spec "fx<=" (targ-u "##fx<="))
(targ-spec "fl<=" (targ-u "##fl<="))
(targ-spec "<="   (targ-arith "fx<=" "fl<="))

(targ-spec "fx>=" (targ-u "##fx>="))
(targ-spec "fl>=" (targ-u "##fl>="))
(targ-spec ">="   (targ-arith "fx>=" "fl>="))

(targ-spec "flinteger?" (targ-u "##flinteger?"))

(targ-spec "fxzero?" (targ-u "##fxzero?"))
(targ-spec "flzero?" (targ-u "##flzero?"))
(targ-spec "zero?"   (targ-arith "fxzero?" "flzero?"))

(targ-spec "fxpositive?" (targ-u "##fxpositive?"))
(targ-spec "flpositive?" (targ-u "##flpositive?"))
(targ-spec "positive?"   (targ-arith "fxpositive?" "flpositive?"))

(targ-spec "fxnegative?" (targ-u "##fxnegative?"))
(targ-spec "flnegative?" (targ-u "##flnegative?"))
(targ-spec "negative?"   (targ-arith "fxnegative?" "flnegative?"))

(targ-spec "fxodd?" (targ-u "##fxodd?"))
(targ-spec "flodd?" (targ-u "##flodd?"))
(targ-spec "odd?"   (targ-arith "fxodd?" "flodd?"))

(targ-spec "fxeven?" (targ-u "##fxeven?"))
(targ-spec "fleven?" (targ-u "##fleven?"))
(targ-spec "even?"   (targ-arith "fxeven?" "fleven?"))

(targ-spec "flfinite?" (targ-u "##flfinite?"))
(targ-spec "finite?"   (targ-arith #f "flfinite?"))

(targ-spec "flinfinite?" (targ-u "##flinfinite?"))
(targ-spec "infinite?"   (targ-arith #f "flinfinite?"))

(targ-spec "flnan?" (targ-u "##flnan?"))
(targ-spec "nan?"   (targ-arith #f "flnan?"))

(targ-spec "fxmax" (targ-u "##fxmax"))
(targ-spec "flmax" (targ-u "##flmax"))
(targ-spec "max"   (targ-arith "fxmax" "flmax"))

(targ-spec "fxmin" (targ-u "##fxmin"))
(targ-spec "flmin" (targ-u "##flmin"))
(targ-spec "min"   (targ-arith "fxmin" "flmin"))

(targ-spec "fxwrap+" (targ-u "##fxwrap+"))
(targ-spec "fx+"     (targ-u "##fx+"))
(targ-spec "fl+"     (targ-u "##fl+"))
(targ-spec "+"       (targ-arith "fx+" "fl+"))

(targ-spec "fxwrap*" (targ-u "##fxwrap*"))
(targ-spec "fx*"     (targ-u "##fx*"))
(targ-spec "fl*"     (targ-u "##fl*"))
(targ-spec "*"       (targ-arith "fx*" "fl*"))

(targ-spec "fxwrap-" (targ-u "##fxwrap-"))
(targ-spec "fx-"     (targ-u "##fx-"))
(targ-spec "fl-"     (targ-u "##fl-"))
(targ-spec "-"       (targ-arith "fx-" "fl-"))

(targ-spec "fl/"     (targ-u "##fl/"))
(targ-spec "/"       (targ-arith #f "fl/"))

(targ-spec "fxwrapquotient" (targ-u "##fxwrapquotient"))
(targ-spec "fxquotient"     (targ-u "##fxquotient"))
(targ-spec "quotient"       (targ-arith "fxquotient" #f))

(targ-spec "fxremainder" (targ-u "##fxremainder"))
(targ-spec "remainder"   (targ-arith "fxremainder" #f))

(targ-spec "fxmodulo" (targ-u "##fxmodulo"))
(targ-spec "modulo"   (targ-arith "fxmodulo" #f))

(targ-spec "fxnot" (targ-u "##fxnot"))

(targ-spec "fxand" (targ-u "##fxand"))

(targ-spec "fxior" (targ-u "##fxior"))

(targ-spec "fxxor" (targ-u "##fxxor"))

(targ-spec "fxif" (targ-u "##fxif"))

(targ-spec "fxbit-count" (targ-u "##fxbit-count"))

(targ-spec "fxlength" (targ-u "##fxlength"))

(targ-spec "fxfirst-bit-set" (targ-u "##fxfirst-bit-set"))

(targ-spec "fxbit-set?" (targ-u "##fxbit-set?"))

(targ-spec "fxwraparithmetic-shift" (targ-u "##fxwraparithmetic-shift"))
(targ-spec "fxarithmetic-shift"     (targ-u "##fxarithmetic-shift"))
(targ-spec "arithmetic-shift"       (targ-arith "fxarithmetic-shift" #f))

(targ-spec "fxwraparithmetic-shift-left" (targ-u "##fxwraparithmetic-shift-left"))
(targ-spec "fxarithmetic-shift-left"   (targ-u "##fxarithmetic-shift-left"))
(targ-spec "fxarithmetic-shift-right"  (targ-u "##fxarithmetic-shift-right"))
(targ-spec "fxwraplogical-shift-right" (targ-u "##fxwraplogical-shift-right"))

(targ-spec "fxwrapabs" (targ-u "##fxwrapabs"))
(targ-spec "fxabs"     (targ-u "##fxabs"))
(targ-spec "flabs"     (targ-u "##flabs"))
(targ-spec "abs"       (targ-arith "fxabs" "flabs"))

(targ-spec "flfloor" (targ-u "##flfloor"))
(targ-spec "floor"   (targ-arith #f "flfloor"))

(targ-spec "flceiling" (targ-u "##flceiling"))
(targ-spec "ceiling"   (targ-arith #f "flceiling"))

(targ-spec "fltruncate" (targ-u "##fltruncate"))
(targ-spec "truncate"   (targ-arith #f "fltruncate"))

(targ-spec "flround" (targ-u "##flround"))
(targ-spec "round"   (targ-arith #f "flround"))

(targ-spec "flexp" (targ-u "##flexp"))
(targ-spec "exp"   (targ-arith #f "flexp"))

(targ-spec "fllog" (targ-u "##fllog"))
(targ-spec "log"   (targ-arith #f "fllog"))

(targ-spec "flsin" (targ-u "##flsin"))
(targ-spec "sin"   (targ-arith #f "flsin"))

(targ-spec "flcos" (targ-u "##flcos"))
(targ-spec "cos"   (targ-arith #f "flcos"))

(targ-spec "fltan" (targ-u "##fltan"))
(targ-spec "tan"   (targ-arith #f "fltan"))

(targ-spec "flasin" (targ-u "##flasin"))
(targ-spec "asin"   (targ-arith #f "flasin"))

(targ-spec "flacos" (targ-u "##flacos"))
(targ-spec "acos"   (targ-arith #f "flacos"))

(targ-spec "flatan" (targ-u "##flatan"))
(targ-spec "atan"   (targ-arith #f "flatan"))

(targ-spec "flexpt" (targ-u "##flexpt"))
(targ-spec "expt"   (targ-arith #f "flexpt"))

(targ-spec "flsqrt" (targ-u "##flsqrt"))
(targ-spec "sqrt"   (targ-arith #f "flsqrt"))

(targ-spec "fixnum->flonum" (targ-u "##fixnum->flonum"))

;(targ-spec "exact->inexact" (targ-arith "##fixnum->flonum" #f))
;(targ-spec "inexact->exact" (targ-arith "##flonum->fixnum" #f))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-spec "char=?"     (targ-u "##char=?"))
(targ-spec "char<?"     (targ-u "##char<?"))
(targ-spec "char>?"     (targ-u "##char>?"))
(targ-spec "char<=?"    (targ-u "##char<=?"))
(targ-spec "char>=?"    (targ-u "##char>=?"))

(targ-spec "char-alphabetic?" (targ-u "##char-alphabetic?"))
(targ-spec "char-numeric?"    (targ-u "##char-numeric?"))
(targ-spec "char-whitespace?" (targ-u "##char-whitespace?"))
(targ-spec "char-upper-case?" (targ-u "##char-upper-case?"))
(targ-spec "char-lower-case?" (targ-u "##char-lower-case?"))
(targ-spec "char->integer"    (targ-u "##char->fixnum"))
(targ-spec "integer->char"    (targ-u "##fixnum->char"))
(targ-spec "char-upcase"      (targ-u "##char-upcase"))
(targ-spec "char-downcase"    (targ-u "##char-downcase"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-spec "cons"       (targ-s "##cons"))
(targ-spec "set-car!"   (targ-u "##set-car!"))
(targ-spec "set-cdr!"   (targ-u "##set-cdr!"))
(targ-spec "car"        (targ-u "##car"))
(targ-spec "cdr"        (targ-u "##cdr"))
(targ-spec "caar"       (targ-u "##caar"))
(targ-spec "cadr"       (targ-u "##cadr"))
(targ-spec "cdar"       (targ-u "##cdar"))
(targ-spec "cddr"       (targ-u "##cddr"))
(targ-spec "caaar"      (targ-u "##caaar"))
(targ-spec "caadr"      (targ-u "##caadr"))
(targ-spec "cadar"      (targ-u "##cadar"))
(targ-spec "caddr"      (targ-u "##caddr"))
(targ-spec "cdaar"      (targ-u "##cdaar"))
(targ-spec "cdadr"      (targ-u "##cdadr"))
(targ-spec "cddar"      (targ-u "##cddar"))
(targ-spec "cdddr"      (targ-u "##cdddr"))
(targ-spec "caaaar"     (targ-u "##caaaar"))
(targ-spec "caaadr"     (targ-u "##caaadr"))
(targ-spec "caadar"     (targ-u "##caadar"))
(targ-spec "caaddr"     (targ-u "##caaddr"))
(targ-spec "cadaar"     (targ-u "##cadaar"))
(targ-spec "cadadr"     (targ-u "##cadadr"))
(targ-spec "caddar"     (targ-u "##caddar"))
(targ-spec "cadddr"     (targ-u "##cadddr"))
(targ-spec "cdaaar"     (targ-u "##cdaaar"))
(targ-spec "cdaadr"     (targ-u "##cdaadr"))
(targ-spec "cdadar"     (targ-u "##cdadar"))
(targ-spec "cdaddr"     (targ-u "##cdaddr"))
(targ-spec "cddaar"     (targ-u "##cddaar"))
(targ-spec "cddadr"     (targ-u "##cddadr"))
(targ-spec "cdddar"     (targ-u "##cdddar"))
(targ-spec "cddddr"     (targ-u "##cddddr"))

(targ-spec "list"       (targ-s "##list"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-spec "will?"          (targ-s "##will?"))
(targ-spec "make-will"      (targ-s "##make-will"))
(targ-spec "will-testator"  (targ-u "##will-testator"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-spec "box?"           (targ-s "##box?"))
(targ-spec "box"            (targ-s "##box"))
(targ-spec "unbox"          (targ-u "##unbox"))
(targ-spec "set-box!"       (targ-u "##set-box!"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-spec "values"         (targ-s "##values"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-spec "string"         (targ-u "##string"))
(targ-spec "string-length"  (targ-u "##string-length"))
(targ-spec "string-ref"     (targ-u "##string-ref"))
(targ-spec "string-set!"    (targ-u "##string-set!"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-spec "vector"         (targ-s "##vector"))
(targ-spec "vector-length"  (targ-u "##vector-length"))
(targ-spec "vector-ref"     (targ-u "##vector-ref"))
(targ-spec "vector-set!"    (targ-u "##vector-set!"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-spec "s8vector?"        (targ-s "##s8vector?"))
(targ-spec "s8vector"         (targ-u "##s8vector"))
(targ-spec "s8vector-length"  (targ-u "##s8vector-length"))
(targ-spec "s8vector-ref"     (targ-u "##s8vector-ref"))
(targ-spec "s8vector-set!"    (targ-u "##s8vector-set!"))

(targ-spec "u8vector?"        (targ-s "##u8vector?"))
(targ-spec "u8vector"         (targ-u "##u8vector"))
(targ-spec "u8vector-length"  (targ-u "##u8vector-length"))
(targ-spec "u8vector-ref"     (targ-u "##u8vector-ref"))
(targ-spec "u8vector-set!"    (targ-u "##u8vector-set!"))

(targ-spec "s16vector?"       (targ-s "##s16vector?"))
(targ-spec "s16vector"        (targ-u "##s16vector"))
(targ-spec "s16vector-length" (targ-u "##s16vector-length"))
(targ-spec "s16vector-ref"    (targ-u "##s16vector-ref"))
(targ-spec "s16vector-set!"   (targ-u "##s16vector-set!"))

(targ-spec "u16vector?"       (targ-s "##u16vector?"))
(targ-spec "u16vector"        (targ-u "##u16vector"))
(targ-spec "u16vector-length" (targ-u "##u16vector-length"))
(targ-spec "u16vector-ref"    (targ-u "##u16vector-ref"))
(targ-spec "u16vector-set!"   (targ-u "##u16vector-set!"))

(targ-spec "s32vector?"       (targ-s "##s32vector?"))
(targ-spec "s32vector"        (targ-u "##s32vector"))
(targ-spec "s32vector-length" (targ-u "##s32vector-length"))
(targ-spec "s32vector-ref"    (targ-u "##s32vector-ref"))
(targ-spec "s32vector-set!"   (targ-u "##s32vector-set!"))

(targ-spec "u32vector?"       (targ-s "##u32vector?"))
(targ-spec "u32vector"        (targ-u "##u32vector"))
(targ-spec "u32vector-length" (targ-u "##u32vector-length"))
(targ-spec "u32vector-ref"    (targ-u "##u32vector-ref"))
(targ-spec "u32vector-set!"   (targ-u "##u32vector-set!"))

(targ-spec "s64vector?"       (targ-s "##s64vector?"))
(targ-spec "s64vector"        (targ-u "##s64vector"))
(targ-spec "s64vector-length" (targ-u "##s64vector-length"))
(targ-spec "s64vector-ref"    (targ-u "##s64vector-ref"))
(targ-spec "s64vector-set!"   (targ-u "##s64vector-set!"))

(targ-spec "u64vector?"       (targ-s "##u64vector?"))
(targ-spec "u64vector"        (targ-u "##u64vector"))
(targ-spec "u64vector-length" (targ-u "##u64vector-length"))
(targ-spec "u64vector-ref"    (targ-u "##u64vector-ref"))
(targ-spec "u64vector-set!"   (targ-u "##u64vector-set!"))

(targ-spec "f32vector?"       (targ-s "##f32vector?"))
(targ-spec "f32vector"        (targ-u "##f32vector"))
(targ-spec "f32vector-length" (targ-u "##f32vector-length"))
(targ-spec "f32vector-ref"    (targ-u "##f32vector-ref"))
(targ-spec "f32vector-set!"   (targ-u "##f32vector-set!"))

(targ-spec "f64vector?"       (targ-s "##f64vector?"))
(targ-spec "f64vector"        (targ-u "##f64vector"))
(targ-spec "f64vector-length" (targ-u "##f64vector-length"))
(targ-spec "f64vector-ref"    (targ-u "##f64vector-ref"))
(targ-spec "f64vector-set!"   (targ-u "##f64vector-set!"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-spec "##structure-ref"  (targ-u "##unchecked-structure-ref"))
(targ-spec "##structure-set!" (targ-u "##unchecked-structure-set!"))

(targ-spec "##direct-structure-ref"  (targ-u "##unchecked-structure-ref"))
(targ-spec "##direct-structure-set!" (targ-u "##unchecked-structure-set!"))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-spec "touch"            (targ-s "##force"))
(targ-spec "force"            (targ-s "##force"))
(targ-spec "void"             (targ-s "##void"))

(targ-spec "eqv?"             (targ-s-eqv?))
(targ-spec "##eqv?"           (targ-s-eqv?))
(targ-spec "equal?"           (targ-s-equal?))
(targ-spec "##equal?"         (targ-s-equal?))

(targ-spec "call/cc"          (targ-s "##call-with-current-continuation"))
(targ-spec "call-with-current-continuation"
                              (targ-s "##call-with-current-continuation"))

(targ-spec "continuation?"        (targ-s "##continuation?"))
(targ-spec "continuation-capture" (targ-s "##continuation-capture"))
(targ-spec "continuation-graft"   (targ-s "##continuation-graft"))
(targ-spec "continuation-return"  (targ-s "##continuation-return"))

(targ-spec "current-thread"   (targ-s "##current-thread"))
)

(targ-setup-specializations)

;;;----------------------------------------------------------------------------

;; Table of procedure call simplifiers

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; Procedure call simplification

(define (targ-simp name . folders)
  (let ((proc (targ-get-prim-info name)))
    (proc-obj-simplify-set!
     proc
     (lambda (ptree args)
       (let loop ((lst folders))
         (if (pair? lst)
           (let ((folder (car lst)))
             (or (folder ptree args)
                 (loop (cdr lst))))
           #f))))))

(define (targ-constant-folder op . type-patterns)
  (targ-constant-folder-with-ptree-maker
   (lambda (ptree arg-vals)
     (let ((result (apply op arg-vals)))
       (new-cst (node-source ptree) (node-env ptree)
         result)))
   type-patterns))

(define targ-constant-folder-gen targ-constant-folder)

(define (targ-constant-folder-fix op . type-patterns)
  (targ-constant-folder-with-ptree-maker
   (lambda (ptree arg-vals)
     (let ((result (apply op arg-vals)))
       (and (or (not (number? result))
                (targ-fixnum32? result))
            (new-cst (node-source ptree) (node-env ptree)
              result))))
   type-patterns))

(define (targ-constant-folder-flo op . type-patterns)
  (targ-constant-folder-with-ptree-maker
   (lambda (ptree arg-vals)
     (let ((result (apply op arg-vals)))
       (and (or (not (number? result))
                (targ-flonum? result))
            (new-cst (node-source ptree) (node-env ptree)
              result))))
   type-patterns))

(define (targ-constant-folder-with-ptree-maker ptree-maker type-patterns)
  (let ((type-patterns
         (if (null? type-patterns)
           (list (lambda (obj) #t))
           type-patterns)))
    (lambda (ptree args)

      (define (match? args type-pattern)
        (if (pair? args)
          (cond ((pair? type-pattern)
                 (and ((car type-pattern) (car args))
                      (match? (cdr args) (cdr type-pattern))))
                ((null? type-pattern)
                 #f)
                (else
                 (and (type-pattern (car args))
                      (match? (cdr args) type-pattern))))
          (not (pair? type-pattern))))

      (and (every? cst? args) ; are all arguments constants?
           (let ((arg-vals (map cst-val args)))
             (let loop ((type-pats type-patterns))
               (if (pair? type-pats)
                 (if (match? arg-vals (car type-pats))
                   (ptree-maker ptree arg-vals)
                   (loop (cdr type-pats)))
                 #f)))))))

(define (targ-constant-folder-ref op get-length type?)
  (lambda (ptree args)
    (and (every? cst? args) ; are all arguments constants?
         (let* ((arg-vals (map cst-val args))
                (vect (car arg-vals))
                (index (cadr arg-vals)))
           (and (type? vect)
                (integer? index)
                (exact? index)
                (not (< index 0))
                (< index (get-length vect))
                (let ((result (op vect index)))
                  (new-cst (node-source ptree) (node-env ptree)
                    result)))))))

(define (targ-setup-simplifiers)

(define (num? obj) (targ-number? obj))
(define (nz-num? obj) (targ-nonzero-number? obj))

(define (int? obj) (targ-integer? obj))
(define (nz-int? obj) (targ-nonzero-integer? obj))

(define (flo? obj) (targ-flonum? obj))
(define (nz-flo? obj) (targ-nonzero-flonum? obj))

(define (fix32? obj) (targ-fixnum32? obj))
(define (nz-fix32? obj) (targ-nonzero-fixnum32? obj))

(define (not-bigfix? obj)
  (not (and (targ-fixnum64? obj) (not (targ-fixnum32? obj)))))

(define (mem-alloc? obj)
  (let ((type (targ-obj-type obj)))
    (or (eq? type 'pair)
        (and (eq? type 'subtyped)
             (not-bigfix? obj)))))

(define (any obj) #t)

(define (alist? obj) (and (list? obj) (every? pair? obj)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(targ-simp "##not"            (targ-constant-folder false-object?  ))
(targ-simp "boolean?"         (targ-constant-folder (lambda (obj)
                                                      (or (false-object? obj)
                                                          (eq? obj #t)))))
(targ-simp "##eqv?"           (targ-constant-folder eqv?           ))
(targ-simp "##eq?"            (targ-constant-folder eq?            ))
(targ-simp "equal?"           (targ-constant-folder equal?         ))
(targ-simp "##mem-allocated?" (targ-constant-folder (lambda (obj)
                                                      (case (targ-obj-type obj)
                                                        ((subtyped pair) #t)
                                                        (else            #f)))
                                                    not-bigfix?))
(targ-simp "##subtyped?"      (targ-constant-folder (lambda (obj)
                                                      (case (targ-obj-type obj)
                                                        ((subtyped) #t)
                                                        (else       #f)))
                                                    not-bigfix?))
(targ-simp "##subtype"        (targ-constant-folder targ-obj-subtype-integer
                                                    mem-alloc?))
(targ-simp "##pair?"          (targ-constant-folder pair?          ))
;(targ-simp "##cons"           (targ-constant-folder cons           ))
(targ-simp "car"              (targ-constant-folder car            pair?))
(targ-simp "##car"            (targ-constant-folder car            pair?))
(targ-simp "cdr"              (targ-constant-folder cdr            pair?))
(targ-simp "##cdr"            (targ-constant-folder cdr            pair?))
;(targ-simp "caar"             (targ-constant-folder caar           ))
;(targ-simp "cadr"             (targ-constant-folder cadr           ))
;(targ-simp "cdar"             (targ-constant-folder cdar           ))
;(targ-simp "cddr"             (targ-constant-folder cddr           ))
;(targ-simp "caaar"            (targ-constant-folder caaar          ))
;(targ-simp "caadr"            (targ-constant-folder caadr          ))
;(targ-simp "cadar"            (targ-constant-folder cadar          ))
;(targ-simp "caddr"            (targ-constant-folder caddr          ))
;(targ-simp "cdaar"            (targ-constant-folder cdaar          ))
;(targ-simp "cdadr"            (targ-constant-folder cdadr          ))
;(targ-simp "cddar"            (targ-constant-folder cddar          ))
;(targ-simp "cdddr"            (targ-constant-folder cdddr          ))
;(targ-simp "caaaar"           (targ-constant-folder caaaar         ))
;(targ-simp "caaadr"           (targ-constant-folder caaadr         ))
;(targ-simp "caadar"           (targ-constant-folder caadar         ))
;(targ-simp "caaddr"           (targ-constant-folder caaddr         ))
;(targ-simp "cadaar"           (targ-constant-folder cadaar         ))
;(targ-simp "cadadr"           (targ-constant-folder cadadr         ))
;(targ-simp "caddar"           (targ-constant-folder caddar         ))
;(targ-simp "cadddr"           (targ-constant-folder cadddr         ))
;(targ-simp "cdaaar"           (targ-constant-folder cdaaar         ))
;(targ-simp "cdaadr"           (targ-constant-folder cdaadr         ))
;(targ-simp "cdadar"           (targ-constant-folder cdadar         ))
;(targ-simp "cdaddr"           (targ-constant-folder cdaddr         ))
;(targ-simp "cddaar"           (targ-constant-folder cddaar         ))
;(targ-simp "cddadr"           (targ-constant-folder cddadr         ))
;(targ-simp "cdddar"           (targ-constant-folder cdddar         ))
;(targ-simp "cddddr"           (targ-constant-folder cddddr         ))
(targ-simp "##null?"          (targ-constant-folder null?          ))
(targ-simp "list?"            (targ-constant-folder list?          ))
;(targ-simp "list"             (targ-constant-folder list           ))
(targ-simp "length"           (targ-constant-folder length         list?))
;(targ-simp "append"           (targ-constant-folder append         list?))
;(targ-simp "reverse"          (targ-constant-folder reverse        list?))
(targ-simp "list-ref"         (targ-constant-folder-ref
                               list-ref
                               length
                               list?))
(targ-simp "memq"             (targ-constant-folder memq
                                                    (list any list?)))
(targ-simp "memv"             (targ-constant-folder memv
                                                    (list any list?)))
(targ-simp "member"           (targ-constant-folder member
                                                    (list any list?)))
(targ-simp "assq"             (targ-constant-folder assq
                                                    (list any alist?)))
(targ-simp "assv"             (targ-constant-folder assv
                                                    (list any alist?)))
(targ-simp "assoc"            (targ-constant-folder assoc
                                                    (list any alist?)))
(targ-simp "##symbol?"        (targ-constant-folder symbol-object? ))
;(targ-simp "symbol->string"   (targ-constant-folder symbol->string
;;                                                    symbol-object?))
(targ-simp "string->symbol"   (targ-constant-folder string->symbol ))
(targ-simp "number?"          (targ-constant-folder number?        ))
(targ-simp "complex?"         (targ-constant-folder complex?       ))
(targ-simp "real?"            (targ-constant-folder real?          ))
(targ-simp "rational?"        (targ-constant-folder rational?      ))
(targ-simp "integer?"         (targ-constant-folder integer?       ))
(targ-simp "exact?"           (targ-constant-folder exact?         num?))
(targ-simp "inexact?"         (targ-constant-folder inexact?       num?))
(targ-simp "="                (targ-constant-folder =              num?))
(targ-simp "##fx="       (targ-constant-folder =              fix32?))
(targ-simp "##fixnum.="       (targ-constant-folder =              fix32?))
(targ-simp "##fl="       (targ-constant-folder =              flo?))
(targ-simp "##flonum.="       (targ-constant-folder =              flo?))
(targ-simp "<"                (targ-constant-folder <              real?))
(targ-simp "##fx<"       (targ-constant-folder <              fix32?))
(targ-simp "##fixnum.<"       (targ-constant-folder <              fix32?))
(targ-simp "##fl<"       (targ-constant-folder <              flo?))
(targ-simp "##flonum.<"       (targ-constant-folder <              flo?))
(targ-simp ">"                (targ-constant-folder >              real?))
(targ-simp "##fx>"       (targ-constant-folder >              fix32?))
(targ-simp "##fixnum.>"       (targ-constant-folder >              fix32?))
(targ-simp "##fl>"       (targ-constant-folder >              flo?))
(targ-simp "##flonum.>"       (targ-constant-folder >              flo?))
(targ-simp "<="               (targ-constant-folder <=             real?))
(targ-simp "##fx<="      (targ-constant-folder <=             fix32?))
(targ-simp "##fixnum.<="      (targ-constant-folder <=             fix32?))
(targ-simp "##fl<="      (targ-constant-folder <=             flo?))
(targ-simp "##flonum.<="      (targ-constant-folder <=             flo?))
(targ-simp ">="               (targ-constant-folder >=             real?))
(targ-simp "##fx>="      (targ-constant-folder >=             fix32?))
(targ-simp "##fixnum.>="      (targ-constant-folder >=             fix32?))
(targ-simp "##fl>="      (targ-constant-folder >=             flo?))
(targ-simp "##flonum.>="      (targ-constant-folder >=             flo?))
(targ-simp "zero?"            (targ-constant-folder zero?          num?))
(targ-simp "##fxzero?"   (targ-constant-folder zero?          fix32?))
(targ-simp "##fixnum.zero?"   (targ-constant-folder zero?          fix32?))
(targ-simp "##flzero?"   (targ-constant-folder zero?          flo?))
(targ-simp "##flonum.zero?"   (targ-constant-folder zero?          flo?))
(targ-simp "positive?"         (targ-constant-folder positive?     real?))
(targ-simp "##fxpositive?"(targ-constant-folder positive?     fix32?))
(targ-simp "##fixnum.positive?"(targ-constant-folder positive?     fix32?))
(targ-simp "##flpositive?"(targ-constant-folder positive?     flo?))
(targ-simp "##flonum.positive?"(targ-constant-folder positive?     flo?))
(targ-simp "negative?"         (targ-constant-folder negative?     real?))
(targ-simp "##fxnegative?"(targ-constant-folder negative?     fix32?))
(targ-simp "##fixnum.negative?"(targ-constant-folder negative?     fix32?))
(targ-simp "##flnegative?"(targ-constant-folder negative?     flo?))
(targ-simp "##flonum.negative?"(targ-constant-folder negative?     flo?))
(targ-simp "odd?"             (targ-constant-folder odd?           int?))
(targ-simp "##fxodd?"    (targ-constant-folder odd?           fix32?))
(targ-simp "##fixnum.odd?"    (targ-constant-folder odd?           fix32?))
(targ-simp "##flodd?"    (targ-constant-folder odd?           flo?))
(targ-simp "##flonum.odd?"    (targ-constant-folder odd?           flo?))
(targ-simp "even?"            (targ-constant-folder even?          int?))
(targ-simp "##fxeven?"   (targ-constant-folder even?          fix32?))
(targ-simp "##fixnum.even?"   (targ-constant-folder even?          fix32?))
(targ-simp "##fleven?"   (targ-constant-folder even?          flo?))
(targ-simp "##flonum.even?"   (targ-constant-folder even?          flo?))
(targ-simp "max"              (targ-constant-folder-gen max        real?))
(targ-simp "##fxmax"     (targ-constant-folder-fix max        fix32?))
(targ-simp "##fixnum.max"     (targ-constant-folder-fix max        fix32?))
(targ-simp "##flmax"     (targ-constant-folder-flo max        flo?))
(targ-simp "##flonum.max"     (targ-constant-folder-flo max        flo?))
(targ-simp "min"              (targ-constant-folder-gen min        real?))
(targ-simp "##fxmin"     (targ-constant-folder-fix min        fix32?))
(targ-simp "##fixnum.min"     (targ-constant-folder-fix min        fix32?))
(targ-simp "##flmin"     (targ-constant-folder-flo min        flo?))
(targ-simp "##flonum.min"     (targ-constant-folder-flo min        flo?))
(targ-simp "+"                (targ-constant-folder-gen +          num?))
(targ-simp "##fxwrap+"   (targ-constant-folder-fix +          fix32?))
(targ-simp "##fixnum.wrap+"   (targ-constant-folder-fix +          fix32?))
(targ-simp "##fx+"       (targ-constant-folder-fix +          fix32?))
(targ-simp "##fixnum.+"       (targ-constant-folder-fix +          fix32?))
(targ-simp "##fx+?"      (targ-constant-folder-fix +          fix32?))
(targ-simp "##fixnum.+?"      (targ-constant-folder-fix +          fix32?))
(targ-simp "##fl+"       (targ-constant-folder-flo +          flo?));;;;;;;;;;must return 0.0 when 0 args
(targ-simp "##flonum.+"       (targ-constant-folder-flo +          flo?));;;;;;;;;;must return 0.0 when 0 args
(targ-simp "*"                (targ-constant-folder-gen *          num?))
(targ-simp "##fxwrap*"   (targ-constant-folder-fix *          fix32?))
(targ-simp "##fixnum.wrap*"   (targ-constant-folder-fix *          fix32?))
(targ-simp "##fx*"       (targ-constant-folder-fix *          fix32?))
(targ-simp "##fixnum.*"       (targ-constant-folder-fix *          fix32?))
(targ-simp "##fx*?"      (targ-constant-folder-fix *          fix32?))
(targ-simp "##fixnum.*?"      (targ-constant-folder-fix *          fix32?))
(targ-simp "##fl*"       (targ-constant-folder-flo *          flo?));;;;;;;;;;must return 1.0 when 0 args
(targ-simp "##flonum.*"       (targ-constant-folder-flo *          flo?));;;;;;;;;;must return 1.0 when 0 args
(targ-simp "-"                (targ-constant-folder-gen -          num?))
(targ-simp "##fxwrap-"   (targ-constant-folder-fix -          fix32?))
(targ-simp "##fixnum.wrap-"   (targ-constant-folder-fix -          fix32?))
(targ-simp "##fx-"       (targ-constant-folder-fix -          fix32?))
(targ-simp "##fixnum.-"       (targ-constant-folder-fix -          fix32?))
(targ-simp "##fx-?"      (targ-constant-folder-fix -          fix32?))
(targ-simp "##fixnum.-?"      (targ-constant-folder-fix -          fix32?))
(targ-simp "##fl-"       (targ-constant-folder-flo -          flo?))
(targ-simp "##flonum.-"       (targ-constant-folder-flo -          flo?))
(targ-simp "/"                (targ-constant-folder-gen /
                                                        (list nz-num?)
                                                        (cons num?
                                                              (cons nz-num?
                                                                    nz-num?))))
(targ-simp "##fl/"       (targ-constant-folder-flo /
                                                        (list nz-flo?)
                                                        (cons flo?
                                                              (cons nz-flo?
                                                                    nz-flo?))))
(targ-simp "##flonum./"       (targ-constant-folder-flo /
                                                        (list nz-flo?)
                                                        (cons flo?
                                                              (cons nz-flo?
                                                                    nz-flo?))))
(targ-simp "abs"              (targ-constant-folder-gen abs        real?))
(targ-simp "##flabs"     (targ-constant-folder-flo abs        flo?))
(targ-simp "##flonum.abs"     (targ-constant-folder-flo abs        flo?))
(targ-simp "quotient"         (targ-constant-folder-gen quotient
                                                        (list int? nz-int?)))
(targ-simp "##fxwrapquotient"(targ-constant-folder-fix quotient
                                                            (list fix32? nz-fix32?)))
(targ-simp "##fixnum.wrapquotient"(targ-constant-folder-fix quotient
                                                            (list fix32? nz-fix32?)))
(targ-simp "##fxquotient"(targ-constant-folder-fix quotient
                                                        (list fix32? nz-fix32?)))
(targ-simp "##fixnum.quotient"(targ-constant-folder-fix quotient
                                                        (list fix32? nz-fix32?)))
(targ-simp "remainder"        (targ-constant-folder-gen remainder
                                                        (list int? nz-int?)))
(targ-simp "##fxremainder"(targ-constant-folder-fix remainder
                                                        (list fix32? nz-fix32?)))
(targ-simp "##fixnum.remainder"(targ-constant-folder-fix remainder
                                                        (list fix32? nz-fix32?)))
(targ-simp "modulo"           (targ-constant-folder-gen modulo
                                                        (list int? nz-int?)))
(targ-simp "##fxmodulo"  (targ-constant-folder-fix modulo
                                                        (list fix32? nz-fix32?)))
(targ-simp "##fixnum.modulo"  (targ-constant-folder-fix modulo
                                                        (list fix32? nz-fix32?)))
(targ-simp "gcd"              (targ-constant-folder-gen gcd        int?))
(targ-simp "lcm"              (targ-constant-folder-gen lcm        int?))
(targ-simp "numerator"        (targ-constant-folder-gen numerator  rational?))
(targ-simp "denominator"      (targ-constant-folder-gen denominator rational?))
(targ-simp "floor"            (targ-constant-folder-gen floor      real?))
(targ-simp "##flfloor"   (targ-constant-folder-flo floor      flo?))
(targ-simp "##flonum.floor"   (targ-constant-folder-flo floor      flo?))
(targ-simp "ceiling"          (targ-constant-folder-gen ceiling    real?))
(targ-simp "##flceiling" (targ-constant-folder-flo ceiling    flo?))
(targ-simp "##flonum.ceiling" (targ-constant-folder-flo ceiling    flo?))
(targ-simp "truncate"         (targ-constant-folder-gen truncate   real?))
(targ-simp "##fltruncate"(targ-constant-folder-flo truncate   flo?))
(targ-simp "##flonum.truncate"(targ-constant-folder-flo truncate   flo?))
(targ-simp "round"            (targ-constant-folder-gen round      real?))
(targ-simp "##flround"   (targ-constant-folder-flo round      flo?))
(targ-simp "##flonum.round"   (targ-constant-folder-flo round      flo?))
(targ-simp "rationalize"      (targ-constant-folder-gen rationalize real?))
(targ-simp "exp"              (targ-constant-folder-gen exp        num?))
(targ-simp "##flexp"     (targ-constant-folder-flo exp        flo?))
(targ-simp "##flonum.exp"     (targ-constant-folder-flo exp        flo?))
(targ-simp "log"              (targ-constant-folder-gen log        nz-num?))
(targ-simp "##fllog"     (targ-constant-folder-flo log        nz-flo?))
(targ-simp "##flonum.log"     (targ-constant-folder-flo log        nz-flo?))
(targ-simp "sin"              (targ-constant-folder-gen sin        num?))
(targ-simp "##flsin"     (targ-constant-folder-flo sin        flo?))
(targ-simp "##flonum.sin"     (targ-constant-folder-flo sin        flo?))
(targ-simp "cos"              (targ-constant-folder-gen cos        num?))
(targ-simp "##flcos"     (targ-constant-folder-flo cos        flo?))
(targ-simp "##flonum.cos"     (targ-constant-folder-flo cos        flo?))
(targ-simp "tan"              (targ-constant-folder-gen tan        num?))
(targ-simp "##fltan"     (targ-constant-folder-flo tan        flo?))
(targ-simp "##flonum.tan"     (targ-constant-folder-flo tan        flo?))
(targ-simp "asin"             (targ-constant-folder-gen asin       num?))
(targ-simp "##flasin"    (targ-constant-folder-flo asin       flo?))
(targ-simp "##flonum.asin"    (targ-constant-folder-flo asin       flo?))
(targ-simp "acos"             (targ-constant-folder-gen acos       num?))
(targ-simp "##flacos"    (targ-constant-folder-flo acos       flo?))
(targ-simp "##flonum.acos"    (targ-constant-folder-flo acos       flo?))
(targ-simp "atan"             (targ-constant-folder-gen atan       num?))
(targ-simp "##flatan"    (targ-constant-folder-flo atan       flo?))
(targ-simp "##flonum.atan"    (targ-constant-folder-flo atan       flo?))
(targ-simp "expt"             (targ-constant-folder-gen expt       num?))
(targ-simp "##flexpt"    (targ-constant-folder-flo expt       flo?))
(targ-simp "##flonum.expt"    (targ-constant-folder-flo expt       flo?))
(targ-simp "sqrt"             (targ-constant-folder-gen sqrt       num?))
(targ-simp "##flsqrt"    (targ-constant-folder-flo sqrt       flo?))
(targ-simp "##flonum.sqrt"    (targ-constant-folder-flo sqrt       flo?))
(targ-simp "expt"             (targ-constant-folder-gen expt       num?))
(targ-simp "##flonum->fixnum"(targ-constant-folder-flo exact->inexact fix32?))
(targ-simp "##flonum.<-fixnum"(targ-constant-folder-flo exact->inexact fix32?))

(targ-simp "make-rectangular" (targ-constant-folder-gen make-rectangular real?))
(targ-simp "make-polar"       (targ-constant-folder-gen make-polar     real?))
(targ-simp "real-part"        (targ-constant-folder-gen real-part      num?))
(targ-simp "imag-part"        (targ-constant-folder-gen imag-part      num?))
(targ-simp "magnitude"        (targ-constant-folder-gen magnitude      num?))
(targ-simp "angle"            (targ-constant-folder-gen angle          num?))
(targ-simp "exact->inexact"   (targ-constant-folder-gen exact->inexact num?))
(targ-simp "inexact->exact"   (targ-constant-folder-gen inexact->exact num?))
;(targ-simp "number->string"   (targ-constant-folder number->string num?))
(targ-simp "string->number"   (targ-constant-folder string->number string?))

(targ-simp "##char?"          (targ-constant-folder char?          ))
(targ-simp "char=?"           (targ-constant-folder char=?         char?))
(targ-simp "char<?"           (targ-constant-folder char<?         char?))
(targ-simp "char>?"           (targ-constant-folder char>?         char?))
(targ-simp "char<=?"          (targ-constant-folder char<=?        char?))
(targ-simp "char>=?"          (targ-constant-folder char>=?        char?))
(targ-simp "char-ci=?"        (targ-constant-folder char-ci=?      char?))
(targ-simp "char-ci<?"        (targ-constant-folder char-ci<?      char?))
(targ-simp "char-ci>?"        (targ-constant-folder char-ci>?      char?))
(targ-simp "char-ci<=?"       (targ-constant-folder char-ci<=?     char?))
(targ-simp "char-ci>=?"       (targ-constant-folder char-ci>=?     char?))
(targ-simp "char-alphabetic?" (targ-constant-folder char-alphabetic? char?))
(targ-simp "char-numeric?"    (targ-constant-folder char-numeric?  char?))
(targ-simp "char-whitespace?" (targ-constant-folder char-whitespace? char?))
(targ-simp "char-upper-case?" (targ-constant-folder char-upper-case? char?))
(targ-simp "char-lower-case?" (targ-constant-folder char-lower-case? char?))
(targ-simp "char->integer"    (targ-constant-folder char->integer  char?))
;(targ-simp "integer->char"    (targ-constant-folder integer->char  ))
(targ-simp "char-upcase"      (targ-constant-folder char-upcase    char?))
(targ-simp "char-downcase"    (targ-constant-folder char-downcase  char?))

(targ-simp "##string?"        (targ-constant-folder string?        ))
;(targ-simp "make-string"      (targ-constant-folder make-string    ))
;(targ-simp "string"           (targ-constant-folder string         char?))
(targ-simp "string-length"    (targ-constant-folder string-length  string?))
(targ-simp "string-ref"       (targ-constant-folder-ref
                               string-ref
                               string-length
                               string?))
(targ-simp "string=?"         (targ-constant-folder string=?       string?))
(targ-simp "string<?"         (targ-constant-folder string<?       string?))
(targ-simp "string>?"         (targ-constant-folder string>?       string?))
(targ-simp "string<=?"        (targ-constant-folder string<=?      string?))
(targ-simp "string>=?"        (targ-constant-folder string>=?      string?))
(targ-simp "string-ci=?"      (targ-constant-folder string-ci=?    string?))
(targ-simp "string-ci<?"      (targ-constant-folder string-ci<?    string?))
(targ-simp "string-ci>?"      (targ-constant-folder string-ci>?    string?))
(targ-simp "string-ci<=?"     (targ-constant-folder string-ci<=?   string?))
(targ-simp "string-ci>=?"     (targ-constant-folder string-ci>=?   string?))
;(targ-simp "substring"        (targ-constant-folder substring      ))
;(targ-simp "string-append"    (targ-constant-folder string-append  string?))

(targ-simp "##vector?"          (targ-constant-folder vector-object? ))
(targ-simp "##vector-length"    (targ-constant-folder vector-length
                                                    vector-object?))
(targ-simp "##vector-ref"       (targ-constant-folder-ref
                                 vector-ref
                                 vector-length
                                 vector-object?))
;(targ-simp "make-vector"        (targ-constant-folder make-vector    ))
;(targ-simp "vector"             (targ-constant-folder vector         ))
(targ-simp "vector-length"      (targ-constant-folder vector-length
                                                      vector-object?))
(targ-simp "vector-ref"         (targ-constant-folder-ref
                                 vector-ref
                                 vector-length
                                 vector-object?))

(targ-simp "##s8vector?"        (targ-constant-folder s8vect? ))
(targ-simp "##s8vector-length"  (targ-constant-folder s8vect-length
                                                    s8vect?))
(targ-simp "##s8vector-ref"     (targ-constant-folder-ref
                                 s8vect-ref
                                 s8vect-length
                                 s8vect?))
;(targ-simp "make-s8vector"      (targ-constant-folder make-s8vect    ))
;(targ-simp "s8vector"           (targ-constant-folder s8vect         ))
(targ-simp "s8vector-length"    (targ-constant-folder s8vect-length
                                                      s8vect?))
(targ-simp "s8vector-ref"       (targ-constant-folder-ref
                                 s8vect-ref
                                 s8vect-length
                                 s8vect?))

(targ-simp "##u8vector?"        (targ-constant-folder u8vect? ))
(targ-simp "##u8vector-length"  (targ-constant-folder u8vect-length
                                                      u8vect?))
(targ-simp "##u8vector-ref"     (targ-constant-folder-ref
                                 u8vect-ref
                                 u8vect-length
                                 u8vect?))
;(targ-simp "make-u8vector"      (targ-constant-folder make-u8vect    ))
;(targ-simp "u8vector"           (targ-constant-folder u8vect         ))
(targ-simp "u8vector-length"    (targ-constant-folder u8vect-length
                                                      u8vect?))
(targ-simp "u8vector-ref"       (targ-constant-folder-ref
                                 u8vect-ref
                                 u8vect-length
                                 u8vect?))

(targ-simp "##s16vector?"       (targ-constant-folder s16vect? ))
(targ-simp "##s16vector-length" (targ-constant-folder s16vect-length
                                                      s16vect?))
(targ-simp "##s16vector-ref"    (targ-constant-folder-ref
                                 s16vect-ref
                                 s16vect-length
                                 s16vect?))
;(targ-simp "make-s16vector"     (targ-constant-folder make-s16vect    ))
;(targ-simp "s16vector"          (targ-constant-folder s16vect         ))
(targ-simp "s16vector-length"   (targ-constant-folder s16vect-length
                                                      s16vect?))
(targ-simp "s16vector-ref"      (targ-constant-folder-ref
                                 s16vect-ref
                                 s16vect-length
                                 s16vect?))

(targ-simp "##u16vector?"       (targ-constant-folder u16vect? ))
(targ-simp "##u16vector-length" (targ-constant-folder u16vect-length
                                                      u16vect?))
(targ-simp "##u16vector-ref"    (targ-constant-folder-ref
                                 u16vect-ref
                                 u16vect-length
                                 u16vect?))
;(targ-simp "make-u16vector"     (targ-constant-folder make-u16vect    ))
;(targ-simp "u16vector"          (targ-constant-folder u16vect         ))
(targ-simp "u16vector-length"   (targ-constant-folder u16vect-length
                                                      u16vect?))
(targ-simp "u16vector-ref"      (targ-constant-folder-ref
                                 u16vect-ref
                                 u16vect-length
                                 u16vect?))

(targ-simp "##s32vector?"       (targ-constant-folder s32vect? ))
(targ-simp "##s32vector-length" (targ-constant-folder s32vect-length
                                                      s32vect?))
(targ-simp "##s32vector-ref"    (targ-constant-folder-ref
                                 s32vect-ref
                                 s32vect-length
                                 s32vect?))
;(targ-simp "make-s32vector"     (targ-constant-folder make-s32vect    ))
;(targ-simp "s32vector"          (targ-constant-folder s32vect         ))
(targ-simp "s32vector-length"   (targ-constant-folder s32vect-length
                                                      s32vect?))
(targ-simp "s32vector-ref"      (targ-constant-folder-ref
                                 s32vect-ref
                                 s32vect-length
                                 s32vect?))

(targ-simp "##u32vector?"       (targ-constant-folder u32vect? ))
(targ-simp "##u32vector-length" (targ-constant-folder u32vect-length
                                                      u32vect?))
(targ-simp "##u32vector-ref"    (targ-constant-folder-ref
                                 u32vect-ref
                                 u32vect-length
                                 u32vect?))
;(targ-simp "make-u32vector"     (targ-constant-folder make-u32vect    ))
;(targ-simp "u32vector"          (targ-constant-folder u32vect         ))
(targ-simp "u32vector-length"   (targ-constant-folder u32vect-length
                                                      u32vect?))
(targ-simp "u32vector-ref"      (targ-constant-folder-ref
                                 u32vect-ref
                                 u32vect-length
                                 u32vect?))

(targ-simp "##s64vector?"       (targ-constant-folder s64vect? ))
(targ-simp "##s64vector-length" (targ-constant-folder s64vect-length
                                                      s64vect?))
(targ-simp "##s64vector-ref"    (targ-constant-folder-ref
                                 s64vect-ref
                                 s64vect-length
                                 s64vect?))
;(targ-simp "make-s64vector"     (targ-constant-folder make-s64vect    ))
;(targ-simp "s64vector"          (targ-constant-folder s64vect         ))
(targ-simp "s64vector-length"   (targ-constant-folder s64vect-length
                                                      s64vect?))
(targ-simp "s64vector-ref"      (targ-constant-folder-ref
                                 s64vect-ref
                                 s64vect-length
                                 s64vect?))

(targ-simp "##u64vector?"       (targ-constant-folder u64vect? ))
(targ-simp "##u64vector-length" (targ-constant-folder u64vect-length
                                                      u64vect?))
(targ-simp "##u64vector-ref"    (targ-constant-folder-ref
                                 u64vect-ref
                                 u64vect-length
                                 u64vect?))
;(targ-simp "make-u64vector"     (targ-constant-folder make-u64vect    ))
;(targ-simp "u64vector"          (targ-constant-folder u64vect         ))
(targ-simp "u64vector-length"   (targ-constant-folder u64vect-length
                                                      u64vect?))
(targ-simp "u64vector-ref"      (targ-constant-folder-ref
                                 u64vect-ref
                                 u64vect-length
                                 u64vect?))

(targ-simp "##f32vector?"       (targ-constant-folder f32vect? ))
(targ-simp "##f32vector-length" (targ-constant-folder f32vect-length
                                                      f32vect?))
(targ-simp "##f32vector-ref"    (targ-constant-folder-ref
                                 f32vect-ref
                                 f32vect-length
                                 f32vect?))
;(targ-simp "make-f32vector"     (targ-constant-folder make-f32vect    ))
;(targ-simp "f32vector"          (targ-constant-folder f32vect         ))
(targ-simp "f32vector-length"   (targ-constant-folder f32vect-length
                                                      f32vect?))
(targ-simp "f32vector-ref"      (targ-constant-folder-ref
                                 f32vect-ref
                                 f32vect-length
                                 f32vect?))

(targ-simp "##f64vector?"       (targ-constant-folder f64vect? ))
(targ-simp "##f64vector-length" (targ-constant-folder f64vect-length
                                                      f64vect?))
(targ-simp "##f64vector-ref"    (targ-constant-folder-ref
                                 f64vect-ref
                                 f64vect-length
                                 f64vect?))
;(targ-simp "make-f64vector"     (targ-constant-folder make-f64vect    ))
;(targ-simp "f64vector"          (targ-constant-folder f64vect         ))
(targ-simp "f64vector-length"   (targ-constant-folder f64vect-length
                                                      f64vect?))
(targ-simp "f64vector-ref"      (targ-constant-folder-ref
                                 f64vect-ref
                                 f64vect-length
                                 f64vect?))

(targ-simp "##procedure?"     (targ-constant-folder proc-obj?      ))
;(targ-simp "apply"            (targ-constant-folder apply          ))
(targ-simp "input-port?"      (targ-constant-folder input-port?    ))
(targ-simp "output-port?"     (targ-constant-folder output-port?   ))
(targ-simp "##eof-object?"    (targ-constant-folder end-of-file-object?))
;(targ-simp "list-tail"        (targ-constant-folder list-tail      ))
;(targ-simp "string->list"     (targ-constant-folder string->list   string?))
;(targ-simp "list->string"     (targ-constant-folder list->string   ))
;(targ-simp "string-copy"      (targ-constant-folder string-copy    string?))
;(targ-simp "vector->list"     (targ-constant-folder vector->list
;;                                                    vector-object?))
;(targ-simp "list->vector"     (targ-constant-folder list->vector   list?))
(targ-simp "##keyword?"       (targ-constant-folder keyword-object?))
;(targ-simp "keyword->string"  (targ-constant-folder keyword-object->string))
(targ-simp "string->keyword"  (targ-constant-folder string->keyword-object))
(targ-simp "##void"           (targ-constant-folder (lambda () void-object)))

(targ-simp "##fixnum?"        (targ-constant-folder fix32?         not-bigfix?))
(targ-simp "##flonum?"        (targ-constant-folder flo?           ))
)

(targ-setup-simplifiers)

(define (targ-setup-expanders)

(define (targ-exp name expander)
  (let ((proc (targ-get-prim-info name)))
    (proc-obj-expandable?-set! proc (lambda (env) #t))
    (proc-obj-expand-set! proc expander)))

(define (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         succeed
         fail)
  (if check-run-time-binding
      (new-tst source env
        (check-run-time-binding)
        (succeed)
        (fail))
      (succeed)))

(define (gen-type-checks
         source
         env
         vars
         check-run-time-binding
         check-prim
         tail
         succeed
         fail)
  (let ((type-checks
         (gen-uniform-type-checks source env
           vars
           (lambda (var)
             (gen-call-prim-vars source env check-prim (list var)))
           tail)))
    (if (or type-checks
            check-run-time-binding)
      (new-tst source env
        (if type-checks
          (if check-run-time-binding
            (new-conj source env
              (check-run-time-binding)
              type-checks)
            type-checks)
          (check-run-time-binding))
        (succeed)
        (fail))
      (succeed))))

(define (gen-simple-case check-prim prim)
  (lambda (source
           env
           vars
           check-run-time-binding
           invalid
           fail)
    (gen-type-checks
     source
     env
     vars
     check-run-time-binding
     check-prim
     #f
     (lambda ()
       (gen-call-prim-vars source env prim vars))
     fail)))

(define (gen-validating-case check-prim gen)
  (lambda (source
           env
           vars
           check-run-time-binding
           invalid
           fail)
    (gen-type-checks
     source
     env
     vars
     check-run-time-binding
     check-prim
     #f
     (lambda ()
       (gen source env vars invalid))
     fail)))

(define (setup-list-primitives)

  (define **null?-sym (string->canonical-symbol "##null?"))
  (define **pair?-sym (string->canonical-symbol "##pair?"))
  (define **pair-mutable?-sym (string->canonical-symbol "##pair-mutable?"))
  (define **cons-sym (string->canonical-symbol "##cons"))
  (define **car-sym (string->canonical-symbol "##car"))
  (define **cdr-sym (string->canonical-symbol "##cdr"))
  (define **set-car!-sym (string->canonical-symbol "##set-car!"))
  (define **set-cdr!-sym (string->canonical-symbol "##set-cdr!"))
  (define **procedure?-sym (string->canonical-symbol "##procedure?"))

  (define (setup-c...r-primitive pattern)

    (define (gen-name pattern)

      (define (ads pattern)
        (if (= pattern 1)
          ""
          (string-append (if (odd? pattern) "d" "a")
                         (ads (quotient pattern 2)))))

      (string-append "c" (ads pattern) "r"))

    (define (c...r pattern x)
      (if (= pattern 1)
          x
          (let ((y (c...r (quotient pattern 2) x)))
            (if (pair? y)
              (if (odd? pattern) (cdr y) (car y))
              #f))))

    (define (expander ptree oper args generate-call check-run-time-binding)
      (let ((source (node-source ptree))
            (env (node-env ptree)))

        (define (op-prim pattern)
          (if (odd? pattern) **cdr-sym **car-sym))

        (define (gen-tst-pair pattern var body check)
          (new-tst source env
            (let ((x (and check (check)))
                  (y (gen-call-prim-vars source env **pair?-sym (list var))))
              (if x
                (new-conj source env x y)
                y))
            (gen-call-prim-vars source env (op-prim pattern) (list var))
            body))

        (define (gen-c...r pattern var)
          (if (< pattern 4)
            (gen-tst-pair
             pattern
             var
             (new-cst source env
               #f)
             check-run-time-binding)
            (let ((vars (gen-temp-vars source '(#f))))
              (new-call source env
                (gen-prc source env
                  vars
                  (gen-tst-pair
                   pattern
                   (car vars)
                   (new-cst source env
                     #f)
                   #f))
                (list (gen-c...r (quotient pattern 2) var))))))

        (let* ((vars1
                (gen-temp-vars source '(#f)))
               (call
                (generate-call vars1)))
          (gen-prc source env
            vars1
            (if (< pattern 4)
              (gen-tst-pair pattern (car vars1) call check-run-time-binding)
              (new-call source env
                (let ((vars2 (gen-temp-vars source '(#f))))
                  (gen-prc source env
                    vars2
                    (gen-tst-pair pattern (car vars2) call #f)))
                (list (gen-c...r (quotient pattern 2) (car vars1)))))))))

    (let ((name (gen-name pattern)))
      (targ-exp name expander)))

  (define (setup-c...r-primitives)
    (let loop ((pattern 2))
      (if (< pattern 32)
          (begin
            (setup-c...r-primitive pattern)
            (loop (+ pattern 1))))))

  (define (setup-set-c...r!-primitive pattern)

    (define (gen-name pattern)
      (if (= pattern 0) "set-car!" "set-cdr!"))

    (define (expander ptree oper args generate-call check-run-time-binding)
      (let ((source (node-source ptree))
            (env (node-env ptree)))

        (define (op-prim pattern)
          (if (odd? pattern) **set-cdr!-sym **set-car!-sym))

        (let ((vars
               (gen-temp-vars source args)))
          (gen-prc source env
            vars
            (let ((type-check
                   (gen-call-prim-vars source env
                     **pair?-sym
                     (list (car vars)))))
              (new-tst source env
                (new-conj source env
                  (if check-run-time-binding
                    (new-conj source env
                      (check-run-time-binding)
                      type-check)
                    type-check)
                  (gen-call-prim-vars source env
                    **pair-mutable?-sym
                    (list (car vars))))
                (gen-call-prim-vars source env
                  (op-prim pattern)
                  vars)
                (generate-call vars)))))))

    (let ((name (gen-name pattern)))
      (targ-exp name expander)))

  (define (setup-set-c...r!-primitives)
    (setup-set-c...r!-primitive 0)  ; set-car!
    (setup-set-c...r!-primitive 1)) ; set-cdr!

  (define (make-assq-memq-expander prim)
    (lambda (ptree oper args generate-call check-run-time-binding)
      (let* ((source
              (node-source ptree))
             (env
              (node-env ptree))
             (vars
              (gen-temp-vars source args))
             (obj-var
              (car vars))
             (lst-var
              (cadr vars))
             (loop-var
              (new-temp-variable source 'loop))
             (lst1-var
              (new-temp-variable source 'lst1))
             (x-var
              (new-temp-variable source 'x)))

        (define (gen-main-loop)
          (new-call source env
            (new-prc source env
              #f
              #f
              (list loop-var)
              '()
              #f
              #f
              (new-call source env
                (new-ref source env
                  loop-var)
                (list (new-ref source env
                        lst-var))))
            (list (new-prc source env
                    #f
                    #f
                    (list lst1-var)
                    '()
                    #f
                    #f
                    (new-tst source env
                      (gen-call-prim-vars source env **pair?-sym (list lst1-var))
                      (new-call source env
                        (new-prc source env
                          #f
                          #f
                          (list x-var)
                          '()
                          #f
                          #f
                          (if (memq prim '(assq assv))
                            (let ()

                              (define (gen-test)
                                (new-tst source env
                                  (gen-call-prim source env
                                    (if (eq? prim 'assq)
                                        **eq?-sym
                                        **eqv?-sym)
                                    (list (new-ref source env
                                            obj-var)
                                          (gen-call-prim-vars source env
                                            **car-sym
                                            (list x-var))))
                                  (new-ref source env
                                    x-var)
                                  (new-call source env
                                    (new-ref source env
                                      loop-var)
                                    (list (gen-call-prim-vars source env
                                            **cdr-sym
                                            (list lst1-var))))))

                              (if (safe? env)
                                (new-tst source env
                                  (gen-call-prim-vars source env
                                    **pair?-sym
                                    (list x-var))
                                  (gen-test)
                                  (generate-call vars))
                                (gen-test)))
                            (new-tst source env
                              (gen-call-prim source env
                                (if (eq? prim 'memq)
                                    **eq?-sym
                                    **eqv?-sym)
                                (list (new-ref source env
                                        obj-var)
                                      (new-ref source env
                                        x-var)))
                              (new-ref source env
                                lst1-var)
                              (new-call source env
                                (new-ref source env
                                  loop-var)
                                (list (gen-call-prim-vars source env
                                        **cdr-sym
                                        (list lst1-var)))))))
                        (list (gen-call-prim-vars source env
                                **car-sym
                                (list lst1-var))))
                      (if (safe? env)
                        (new-tst source env
                          (gen-call-prim-vars source env **null?-sym (list lst1-var))
                          (new-cst source env
                            false-object)
                          (generate-call vars))
                        (new-cst source env
                          false-object)))))))

        (gen-prc source env
          vars
          (if check-run-time-binding
            (new-tst source env
              (check-run-time-binding)
              (gen-main-loop)
              (generate-call vars))
            (gen-main-loop))))))

  (define (make-map-for-each-expander prim)
    (lambda (ptree oper args generate-call check-run-time-binding)
      (let* ((source
              (node-source ptree))
             (env
              (node-env ptree))
             (vars
              (gen-temp-vars source args))
             (f-var
              (car vars))
             (lst-vars
              (cdr vars)))

        (define (gen-conj-call-prim-vars source env prim vars)
          (if (pair? vars)
              (let ((code
                     (gen-call-prim-vars source env
                       prim
                       (list (car vars)))))
                (if (null? (cdr vars))
                    code
                    (new-conj source env
                      code
                      (gen-conj-call-prim-vars source env prim (cdr vars)))))
              (new-cst source env
                #t)))

        (define (gen-main-loop)
          (let* ((loop2-var
                  (new-temp-variable source 'loop2))
                 (lst2-vars
                  (gen-temp-vars source lst-vars))
                 (x-var
                  (new-temp-variable source 'x)))
            (new-call source env
              (new-prc source env
                #f
                #f
                (list loop2-var)
                '()
                #f
                #f
                (new-call source env
                  (new-ref source env
                    loop2-var)
                  (map (lambda (var)
                         (new-ref source env
                           var))
                       lst-vars)))
              (list (new-prc source env
                      #f
                      #f
                      lst2-vars
                      '()
                      #f
                      #f
                      (new-tst source env
                        (gen-conj-call-prim-vars source env
                          **pair?-sym
                          (if (safe? env) ;; in case lists are truncated by other threads
                              lst2-vars
                              (list (car lst2-vars))))
                        (new-call source env
                          (new-prc source env
                            #f
                            #f
                            (list x-var)
                            '()
                            #f
                            #f
                            (let ((rec-call
                                   (new-call source env
                                     (new-ref source env
                                       loop2-var)
                                     (map (lambda (var)
                                            (gen-call-prim-vars source env
                                              **cdr-sym
                                              (list var)))
                                          lst2-vars))))
                              (if (eq? prim 'map)
                                (gen-call-prim source env
                                  **cons-sym
                                  (list (new-ref source env
                                          x-var)
                                        rec-call))
                                rec-call)))
                          (list (new-call source env
                                  (new-ref source env
                                    f-var)
                                  (map (lambda (var)
                                            (gen-call-prim-vars source env
                                              **car-sym
                                              (list var)))
                                          lst2-vars))))
                        (new-cst source env
                          (if (eq? prim 'map)
                            '()
                            void-object))))))))

        (define (gen-check)
          (let* ((loop1-var
                  (new-temp-variable source 'loop1))
                 (lst1-vars
                  (gen-temp-vars source lst-vars)))
            (new-call source env
              (new-prc source env
                #f
                #f
                (list loop1-var)
                '()
                #f
                #f
                (new-call source env
                  (new-ref source env
                    loop1-var)
                  (map (lambda (var)
                         (new-ref source env
                           var))
                       lst-vars)))
              (list (new-prc source env
                      #f
                      #f
                      lst1-vars
                      '()
                      #f
                      #f
                      (new-tst source env
                        (gen-conj-call-prim-vars source env
                          **pair?-sym
                          lst1-vars)
                        (new-call source env
                          (new-ref source env
                            loop1-var)
                          (map (lambda (var)
                                 (gen-call-prim-vars source env
                                   **cdr-sym
                                   (list var)))
                               lst1-vars))
                        (new-tst source env
                          (gen-conj-call-prim-vars source env
                            **null?-sym
                            lst1-vars)
                          (gen-main-loop)
                          (generate-call vars))))))))

        (gen-prc source env
          vars
          (let ((check-proc
                 (and (safe? env)
                      (let ((f-arg (car args)))
                        (and (not (or (prc? f-arg)
                                      (and (cst? f-arg)
                                           (proc-obj? (cst-val f-arg)))))
                             (gen-call-prim-vars source env
                               **procedure?-sym
                               (list f-var)))))))
            (if (or check-run-time-binding
                    check-proc)
              (new-tst source env
                (cond ((and check-run-time-binding
                            check-proc)
                       (new-conj source env
                         (check-run-time-binding)
                         check-proc))
                      (check-run-time-binding
                       (check-run-time-binding))
                      (else
                       check-proc))
                (if (safe? env)
                  (gen-check)
                  (gen-main-loop))
                (generate-call vars))
              (gen-main-loop)))))))

  (setup-c...r-primitives)
  (setup-set-c...r!-primitives)

  (targ-exp "assq" (make-assq-memq-expander 'assq))
  (targ-exp "assv" (make-assq-memq-expander 'assv))
  (targ-exp "memq" (make-assq-memq-expander 'memq))
  (targ-exp "memv" (make-assq-memq-expander 'memv))
  (targ-exp "map" (make-map-for-each-expander 'map))
  (targ-exp "for-each" (make-map-for-each-expander 'for-each)))

(define (setup-numeric-primitives)

  (define **real?-sym     (string->canonical-symbol "##real?"))
  (define **rational?-sym (string->canonical-symbol "##rational?"))
  (define **integer?-sym  (string->canonical-symbol "##integer?"))
  (define **exact?-sym    (string->canonical-symbol "##exact?"))
  (define **inexact?-sym  (string->canonical-symbol "##inexact?"))
  (define exact?-sym      (string->canonical-symbol "exact?"))
  (define inexact?-sym    (string->canonical-symbol "inexact?"))

  (define **fixnum?-sym (string->canonical-symbol "##fixnum?"))

  (define **fx=-sym (string->canonical-symbol "##fx="))
  (define **fx<-sym (string->canonical-symbol "##fx<"))
  (define **fx>-sym (string->canonical-symbol "##fx>"))
  (define **fx<=-sym (string->canonical-symbol "##fx<="))
  (define **fx>=-sym (string->canonical-symbol "##fx>="))

  (define **fxzero?-sym (string->canonical-symbol "##fxzero?"))
  (define **fxpositive?-sym (string->canonical-symbol "##fxpositive?"))
  (define **fxnegative?-sym (string->canonical-symbol "##fxnegative?"))

  (define **fxodd?-sym (string->canonical-symbol "##fxodd?"))
  (define **fxeven?-sym (string->canonical-symbol "##fxeven?"))

  (define **fxmax-sym (string->canonical-symbol "##fxmax"))
  (define **fxmin-sym (string->canonical-symbol "##fxmin"))

  (define **fxwrap+-sym (string->canonical-symbol "##fxwrap+"))
  (define **fx+-sym (string->canonical-symbol "##fx+"))
  (define **fx+?-sym (string->canonical-symbol "##fx+?"))
  (define **fxwrap*-sym (string->canonical-symbol "##fxwrap*"))
  (define **fx*-sym (string->canonical-symbol "##fx*"))
  (define **fx*?-sym (string->canonical-symbol "##fx*?"))
  (define **fxwrap--sym (string->canonical-symbol "##fxwrap-"))
  (define **fx--sym (string->canonical-symbol "##fx-"))
  (define **fx-?-sym (string->canonical-symbol "##fx-?"))
  (define **fxwrapquotient-sym (string->canonical-symbol "##fxwrapquotient"))
  (define **fxquotient-sym (string->canonical-symbol "##fxquotient"))
  (define **fxremainder-sym (string->canonical-symbol "##fxremainder"))
  (define **fxmodulo-sym (string->canonical-symbol "##fxmodulo"))

  (define **fxwrapabs-sym (string->canonical-symbol "##fxwrapabs"))
  (define **fxabs-sym (string->canonical-symbol "##fxabs"))
  (define **fxabs?-sym (string->canonical-symbol "##fxabs?"))

  (define **fxnot-sym (string->canonical-symbol "##fxnot"))
  (define **fxand-sym (string->canonical-symbol "##fxand"))
  (define **fxior-sym (string->canonical-symbol "##fxior"))
  (define **fxxor-sym (string->canonical-symbol "##fxxor"))

  (define **flonum?-sym (string->canonical-symbol "##flonum?"))

  (define **fl=-sym (string->canonical-symbol "##fl="))
  (define **fl<-sym (string->canonical-symbol "##fl<"))
  (define **fl>-sym (string->canonical-symbol "##fl>"))
  (define **fl<=-sym (string->canonical-symbol "##fl<="))
  (define **fl>=-sym (string->canonical-symbol "##fl>="))

  (define **flinteger?-sym (string->canonical-symbol "##flinteger?"))
  (define **flzero?-sym (string->canonical-symbol "##flzero?"))
  (define **flpositive?-sym (string->canonical-symbol "##flpositive?"))
  (define **flnegative?-sym (string->canonical-symbol "##flnegative?"))
  (define **flodd?-sym (string->canonical-symbol "##flodd?"))
  (define **fleven?-sym (string->canonical-symbol "##fleven?"))
  (define **flfinite?-sym (string->canonical-symbol "##flfinite?"))
  (define **flinfinite?-sym (string->canonical-symbol "##flinfinite?"))
  (define **flnan?-sym (string->canonical-symbol "##flnan?"))

  (define **flmax-sym (string->canonical-symbol "##flmax"))
  (define **flmin-sym (string->canonical-symbol "##flmin"))

  (define **fl+-sym (string->canonical-symbol "##fl+"))
  (define **fl*-sym (string->canonical-symbol "##fl*"))
  (define **fl--sym (string->canonical-symbol "##fl-"))
  (define **fl/-sym (string->canonical-symbol "##fl/"))

  (define **flabs-sym (string->canonical-symbol "##flabs"))
  (define **flfloor-sym (string->canonical-symbol "##flfloor"))
  (define **flceiling-sym (string->canonical-symbol "##flceiling"))
  (define **fltruncate-sym (string->canonical-symbol "##fltruncate"))
  (define **flround-sym (string->canonical-symbol "##flround"))
  (define **flexp-sym (string->canonical-symbol "##flexp"))
  (define **fllog-sym (string->canonical-symbol "##fllog"))
  (define **flsin-sym (string->canonical-symbol "##flsin"))
  (define **flcos-sym (string->canonical-symbol "##flcos"))
  (define **fltan-sym (string->canonical-symbol "##fltan"))
  (define **flasin-sym (string->canonical-symbol "##flasin"))
  (define **flacos-sym (string->canonical-symbol "##flacos"))
  (define **flatan-sym (string->canonical-symbol "##flatan"))
  (define **flexpt-sym (string->canonical-symbol "##flexpt"))
  (define **flsqrt-sym (string->canonical-symbol "##flsqrt"))
  (define **flcopysign-sym (string->canonical-symbol "##flcopysign"))

  (define **fl<-fx-sym (string->canonical-symbol "##fl<-fx"))

  (define **char?-sym (string->canonical-symbol "##char?"))

  (define **char=?-sym (string->canonical-symbol "##char=?"))
  (define **char<?-sym (string->canonical-symbol "##char<?"))
  (define **char>?-sym (string->canonical-symbol "##char>?"))
  (define **char<=?-sym (string->canonical-symbol "##char<=?"))
  (define **char>=?-sym (string->canonical-symbol "##char>=?"))

  (define **char-ci=?-sym (string->canonical-symbol "##char-ci=?"))
  (define **char-ci<?-sym (string->canonical-symbol "##char-ci<?"))
  (define **char-ci>?-sym (string->canonical-symbol "##char-ci>?"))
  (define **char-ci<=?-sym (string->canonical-symbol "##char-ci<=?"))
  (define **char-ci>=?-sym (string->canonical-symbol "##char-ci>=?"))

  (define **mem-allocated?-sym (string->canonical-symbol "##mem-allocated?"))
  (define **subtyped?-sym (string->canonical-symbol "##subtyped?"))
  (define **subtype-sym (string->canonical-symbol "##subtype"))

  (define (gen-fixnum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **fixnum?-sym
       #f
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (gen-fixnum-division-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **fixnum?-sym
       (gen-call-prim source env
         **not-sym
         (list (gen-call-prim source env
                 **eqv?-sym
                 (list (new-ref source env
                         (cadr vars))
                       (new-cst source env
                         0)))))
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (gen-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **flonum?-sym
       #f
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (gen-log-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **flonum?-sym
       (new-disj source env
         (gen-call-prim-vars source env
           **flnan?-sym
           vars)
         (gen-call-prim source env
           **not-sym
           (list (gen-call-prim source env
                   **flnegative?-sym
                   (list (gen-call-prim source env
                           **flcopysign-sym
                           (list (new-cst source env
                                   (macro-inexact-+1))
                                 (new-ref source env
                                   (car vars)))))))))
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (gen-expt-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **flonum?-sym
       (new-disj source env
         (gen-call-prim source env
           **not-sym
           (list (gen-call-prim-vars source env
                   **flnegative?-sym
                   (list (car vars)))))
         (gen-call-prim-vars source env
           **flinteger?-sym
           (list (cadr vars))))
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (gen-sqrt-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **flonum?-sym
       (gen-call-prim source env
         **not-sym
         (list (gen-call-prim-vars source env
                 **flnegative?-sym
                 vars)))
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (gen-finite-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **flonum?-sym
       (gen-call-prim-vars source env
         **flfinite?-sym
         vars)
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (gen-asin-acos-atan-flonum-case gen)
    (lambda (source
             env
             vars
             check-run-time-binding
             invalid
             fail)
      (gen-type-checks
       source
       env
       vars
       check-run-time-binding
       **flonum?-sym
       (and (= (length vars) 1)
            (new-conj source env
              (gen-call-prim source env
                **not-sym
                (list (gen-call-prim source env
                        **fl<-sym
                        (list (new-cst source env
                                (macro-inexact-+1))
                              (new-ref source env
                                (car vars))))))
              (gen-call-prim source env
                **not-sym
                (list (gen-call-prim source env
                        **fl<-sym
                        (list (new-ref source env
                                (car vars))
                              (new-cst source env
                                (macro-inexact--1))))))))
       (lambda ()
         (gen source env vars invalid))
       fail)))

  (define (no-case source
                   env
                   vars
                   check-run-time-binding
                   invalid
                   fail)
    (fail))

  (define (make-fixflo-expander fixnum-case flonum-case)
    (lambda (ptree oper args generate-call check-run-time-binding)
      (let* ((source
              (node-source ptree))
             (env
              (node-env ptree))
             (mostly-arith
              (mostly-arith-implementation (var-name (ref-var oper)) env))
             (cases
              (cond ((eq? mostly-arith mostly-fixnum-sym)
                     (cons fixnum-case no-case))
                    ((eq? mostly-arith mostly-flonum-sym)
                     (cons flonum-case no-case))
                    ((eq? mostly-arith mostly-fixnum-flonum-sym)
                     (cons fixnum-case flonum-case))
                    ((eq? mostly-arith mostly-flonum-fixnum-sym)
                     (cons flonum-case fixnum-case))
                    (else
                     (cons no-case no-case)))))
        (if (and (eq? (car cases) no-case)
                 (eq? (cdr cases) no-case))
          #f
          (let ((vars (gen-temp-vars source args)))
            (gen-prc source env
              vars
              (let* ((generic-call
                      (lambda ()
                        (generate-call vars)))
                     (cases-expansion
                      ((car cases) source env
                       vars
                       (and (eq? (cdr cases) no-case)
                            check-run-time-binding)
                       generic-call
                       (lambda ()
                         ((cdr cases) source env
                          vars
                          (and (eq? (car cases) no-case)
                               check-run-time-binding)
                          generic-call
                          generic-call)))))
                (if (and check-run-time-binding
                         (not (eq? (car cases) no-case))
                         (not (eq? (cdr cases) no-case)))
                  (new-tst source env
                    (check-run-time-binding)
                    cases-expansion
                    (generic-call))
                  cases-expansion))))))))

  (define (make-simple-expander gen-case)
    (lambda (ptree oper args generate-call check-run-time-binding)
      (let* ((source
              (node-source ptree))
             (env
              (node-env ptree))
             (vars
              (gen-temp-vars source args)))
        (gen-prc source env
          vars
          (let ((generic-call
                 (lambda ()
                   (generate-call vars))))
            (gen-case source env
              vars
              check-run-time-binding
              generic-call
              generic-call))))))

  (define (make-fixnum-division-expander gen-case)
    (lambda (ptree oper args generate-call check-run-time-binding)
      (let* ((source
              (node-source ptree))
             (env
              (node-env ptree))
             (mostly-arith
              (mostly-arith-implementation (var-name (ref-var oper)) env)))
        (and (or (eq? mostly-arith mostly-fixnum-sym)
                 (eq? mostly-arith mostly-fixnum-flonum-sym)
                 (eq? mostly-arith mostly-flonum-fixnum-sym))
             (let ((vars
                    (gen-temp-vars source args)))
               (gen-prc source env
                 vars
                 (let ((generic-call
                        (lambda ()
                          (generate-call vars))))
                   (gen-case source env
                     vars
                     check-run-time-binding
                     generic-call
                     generic-call))))))))

  (define (make-prim-generator prim)
    (lambda (source env vars invalid)
      (gen-call-prim-vars source env prim vars)))

  (define gen-fixnum-0
    (lambda (source env vars invalid)
      (new-cst source env
        0)))

  (define gen-fixnum-1
    (lambda (source env vars invalid)
      (new-cst source env
        1)))

  (define gen-flonum-0
    (lambda (source env vars invalid)
      (new-cst source env
        targ-inexact-+0)))

  (define gen-flonum-1
    (lambda (source env vars invalid)
      (new-cst source env
        targ-inexact-+1)))

  (define gen-first-arg
    (lambda (source env vars invalid)
      (new-ref source env
        (car vars))))

  (define (make-nary-generator zero one two-or-more)
    (lambda (source env vars invalid)
      (cond ((null? vars)
             (zero source env vars invalid))
            ((null? (cdr vars))
             (one source env vars invalid))
            (else
             (two-or-more source env vars invalid)))))

  (define (gen-fold source env vars invalid op-sym)

    (define (fold result vars)
      (if (null? vars)
        result
        (fold (gen-call-prim source env
                op-sym
                (list result
                      (new-ref source env
                        (car vars))))
              (cdr vars))))

    (fold (new-ref source env
            (car vars))
          (cdr vars)))

  (define (make-fold-generator op-sym)
    (lambda (source env vars invalid)
      (gen-fold source env
        vars
        invalid
        op-sym)))

  (define (gen-conditional-fold source env vars invalid gen-op)

    (define (conditional-fold result-var vars intermediate-result-vars)
      (if (null? vars)
        (new-ref source env
          result-var)
        (let ((var (car intermediate-result-vars)))
          (new-call source env
            (gen-prc source env
              (list var)
              (new-tst source env
                (new-ref source env
                  var)
                (conditional-fold var
                                  (cdr vars)
                                  (cdr intermediate-result-vars))
                (invalid)))
            (list (gen-op source env result-var (car vars)))))))

    (conditional-fold (car vars)
                      (cdr vars)
                      (gen-temp-vars source (cdr vars))))

  (define (make-conditional-fold-generator conditional-op-sym)
    (lambda (source env vars invalid)
      (gen-conditional-fold source env
        vars
        invalid
        (lambda (source env var1 var2)
          (gen-call-prim-vars source env
            conditional-op-sym
            (list var1 var2))))))

  (define case-fx=
    (gen-simple-case **fixnum?-sym **fx=-sym))

  (define case-fx<
    (gen-simple-case **fixnum?-sym **fx<-sym))

  (define case-fx>
    (gen-simple-case **fixnum?-sym **fx>-sym))

  (define case-fx<=
    (gen-simple-case **fixnum?-sym **fx<=-sym))

  (define case-fx>=
    (gen-simple-case **fixnum?-sym **fx>=-sym))

  (define case-fxzero?
    (gen-simple-case **fixnum?-sym **fxzero?-sym))

  (define case-fxpositive?
    (gen-simple-case **fixnum?-sym **fxpositive?-sym))

  (define case-fxnegative?
    (gen-simple-case **fixnum?-sym **fxnegative?-sym))

  (define case-fxodd?
    (gen-simple-case **fixnum?-sym **fxodd?-sym))

  (define case-fxeven?
    (gen-simple-case **fixnum?-sym **fxeven?-sym))

  (let ()

    (define case-fxmax
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-0 ; ignored
        gen-first-arg
        (make-fold-generator **fxmax-sym))))

    (define case-fxmin
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-0 ; ignored
        gen-first-arg
        (make-fold-generator **fxmin-sym))))

    (define case-fxwrap+
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-0
        gen-first-arg
        (make-fold-generator **fxwrap+-sym))))

    (define case-fx+
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-0
        gen-first-arg
        (make-conditional-fold-generator **fx+?-sym))))

    (define case-fxwrap*
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-1
        gen-first-arg
        (make-fold-generator **fxwrap*-sym))))

    (define case-fx*
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-1
        gen-first-arg
        (lambda (source env vars invalid)
          (new-tst source env
            (gen-disj-multi source env
              (map (lambda (var)
                     (gen-call-prim source env
                       **eqv?-sym
                       (list (new-ref source env
                               var)
                             (new-cst source env
                               0))))
                   (reverse (cdr vars))))
            (new-cst source env
              0)
            (gen-conditional-fold source env
              vars
              invalid
              (lambda (source env var1 var2)
                (new-tst source env
                  (gen-call-prim source env
                    **eqv?-sym
                    (list (new-ref source env
                            var2)
                          (new-cst source env
                            -1)))
                  (gen-call-prim-vars source env
                    **fx-?-sym
                    (list var1))
                  (gen-call-prim-vars source env
                    **fx*?-sym
                    (list var1 var2))))))))))

    (define case-fxwrap-
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-0 ; ignored
        (make-prim-generator **fxwrap--sym)
        (make-fold-generator **fxwrap--sym))))

    (define case-fx-
      (gen-validating-case
       **fixnum?-sym
       (make-nary-generator
        gen-fixnum-0 ; ignored
        (lambda (source env vars invalid)
          (let ((var (car (gen-temp-vars source '(#f)))))
            (new-call source env
              (gen-prc source env
                (list var)
                (new-tst source env
                  (new-ref source env
                    var)
                  (new-ref source env
                    var)
                  (invalid)))
              (list (gen-call-prim-vars source env
                      **fx-?-sym
                      vars)))))
        (lambda (source env vars invalid)
          (gen-conditional-fold source env
            vars
            invalid
            (lambda (source env var1 var2)
              (gen-call-prim-vars source env
                **fx-?-sym
                (list var1 var2))))))))

    (define case-fxwrapquotient
      (gen-simple-case **fixnum?-sym **fxwrapquotient-sym))

    (define case-fxquotient
      (gen-fixnum-division-case
       (lambda (source env vars invalid)
         (new-tst source env
           (gen-call-prim source env
             **eqv?-sym
             (list (new-ref source env
                     (cadr vars))
                   (new-cst source env
                     -1)))
           (new-disj source env
             (gen-call-prim-vars source env
               **fx-?-sym
               (list (car vars)))
             (invalid))
           (gen-call-prim-vars source env
             **fxquotient-sym
             vars)))))

    (define case-fxremainder
      (gen-fixnum-division-case
       (make-prim-generator **fxremainder-sym)))

    (define case-fxmodulo
      (gen-fixnum-division-case
       (make-prim-generator **fxmodulo-sym)))

    (define case-fxwrapabs
      (gen-simple-case **fixnum?-sym **fxwrapabs-sym))

    (define case-fxabs
      (gen-fixnum-case
       (lambda (source env vars invalid)
         (let ((var (car (gen-temp-vars source '(#f)))))
           (new-call source env
             (gen-prc source env
               (list var)
               (new-tst source env
                 (new-ref source env
                   var)
                 (new-ref source env
                   var)
                 (invalid)))
             (list (gen-call-prim-vars source env
                    **fxabs?-sym
                    vars)))))))

    (define case-fxnot
      (gen-simple-case **fixnum?-sym **fxnot-sym))

    (define case-fxand
      (gen-simple-case **fixnum?-sym **fxand-sym))

    (define case-fxior
      (gen-simple-case **fixnum?-sym **fxior-sym))

    (define case-fxxor
      (gen-simple-case **fixnum?-sym **fxxor-sym))

    ; fxwraparithmetic-shift
    ; fxarithmetic-shift
    ; fxwraparithmetic-shift-left
    ; fxarithmetic-shift-left
    ; fxarithmetic-shift-right
    ; fxwraplogical-shift-right

    (define case-fixnum->flonum
      (gen-fixnum-case
       (make-prim-generator **fl<-fx-sym)))

    (define case-fixnum-exact->inexact
      (gen-fixnum-case
       (make-prim-generator **fl<-fx-sym)))

    (define case-fixnum-inexact->exact
      (gen-fixnum-case
       gen-first-arg))

    (define case-fl=
      (gen-simple-case **flonum?-sym **fl=-sym))

    (define case-fl<
      (gen-simple-case **flonum?-sym **fl<-sym))

    (define case-fl>
      (gen-simple-case **flonum?-sym **fl>-sym))

    (define case-fl<=
      (gen-simple-case **flonum?-sym **fl<=-sym))

    (define case-fl>=
      (gen-simple-case **flonum?-sym **fl>=-sym))

    (define case-flinteger?
      (gen-simple-case **flonum?-sym **flinteger?-sym))

    (define case-flzero?
      (gen-simple-case **flonum?-sym **flzero?-sym))

    (define case-flpositive?
      (gen-simple-case **flonum?-sym **flpositive?-sym))

    (define case-flnegative?
      (gen-simple-case **flonum?-sym **flnegative?-sym))

    (define case-flodd?
      (gen-simple-case **flonum?-sym **flodd?-sym))

    (define case-fleven?
      (gen-simple-case **flonum?-sym **fleven?-sym))

    (define case-flfinite?
      (gen-simple-case **flonum?-sym **flfinite?-sym))

    (define case-flinfinite?
      (gen-simple-case **flonum?-sym **flinfinite?-sym))

    (define case-flnan?
      (gen-simple-case **flonum?-sym **flnan?-sym))

    (define case-flmax
      (gen-validating-case
       **flonum?-sym
       (make-nary-generator
        gen-flonum-0 ; ignored
        gen-first-arg
        (make-fold-generator **flmax-sym))))

    (define case-flmin
      (gen-validating-case
       **flonum?-sym
       (make-nary-generator
        gen-flonum-0 ; ignored
        gen-first-arg
        (make-fold-generator **flmin-sym))))

    (define case-fl+
      (gen-validating-case
       **flonum?-sym
       (make-nary-generator
        gen-flonum-0
        gen-first-arg
        (make-fold-generator **fl+-sym))))

    (define case-fl*
      (gen-validating-case
       **flonum?-sym
       (make-nary-generator
        gen-flonum-1
        gen-first-arg
        (make-fold-generator **fl*-sym))))

    (define case-fl-
      (gen-validating-case
       **flonum?-sym
       (make-nary-generator
        gen-flonum-0 ; ignored
        (make-prim-generator **fl--sym)
        (make-fold-generator **fl--sym))))

    (define case-fl/
      (gen-validating-case
       **flonum?-sym
       (make-nary-generator
        gen-flonum-0 ; ignored
        (make-prim-generator **fl/-sym)
        (make-fold-generator **fl/-sym))))

    (define case-flabs
      (gen-simple-case **flonum?-sym **flabs-sym))

    (define case-flfloor
      (gen-finite-flonum-case
       (make-prim-generator **flfloor-sym)))

    (define case-flceiling
      (gen-finite-flonum-case
       (make-prim-generator **flceiling-sym)))

    (define case-fltruncate
      (gen-finite-flonum-case
       (make-prim-generator **fltruncate-sym)))

    (define case-flround
      (gen-finite-flonum-case
       (make-prim-generator **flround-sym)))

    (define case-flexp
      (gen-simple-case **flonum?-sym **flexp-sym))

    (define case-fllog
      (gen-log-flonum-case
       (make-prim-generator **fllog-sym)))

    (define case-flsin
      (gen-simple-case **flonum?-sym **flsin-sym))

    (define case-flcos
      (gen-simple-case **flonum?-sym **flcos-sym))

    (define case-fltan
      (gen-simple-case **flonum?-sym **fltan-sym))

    (define case-flasin
      (gen-asin-acos-atan-flonum-case
       (make-prim-generator **flasin-sym)))

    (define case-flacos
      (gen-asin-acos-atan-flonum-case
       (make-prim-generator **flacos-sym)))

    (define case-flatan
      (gen-asin-acos-atan-flonum-case
       (make-prim-generator **flatan-sym)))

    (define case-flexpt
      (gen-expt-flonum-case
       (make-prim-generator **flexpt-sym)))

    (define case-flsqrt
      (gen-sqrt-flonum-case
       (make-prim-generator **flsqrt-sym)))

    (define case-flonum-exact->inexact
      (gen-flonum-case
       gen-first-arg))

    (define case-flonum-inexact->exact
      no-case)

    (define case-char=?
      (gen-simple-case **char?-sym **char=?-sym))

    (define case-char<?
      (gen-simple-case **char?-sym **char<?-sym))

    (define case-char>?
      (gen-simple-case **char?-sym **char>?-sym))

    (define case-char<=?
      (gen-simple-case **char?-sym **char<=?-sym))

    (define case-char>=?
      (gen-simple-case **char?-sym **char>=?-sym))

    (define (case-eqv?-or-equal? prim)
      (lambda (source
               env
               vars
               check-run-time-binding
               invalid
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (let ((var1 (car vars))
                 (var2 (cadr vars)))
             (new-disj source env
               (gen-call-prim source env
                 **eq?-sym
                 (list (new-ref source env
                         var1)
                       (new-ref source env
                         var2)))
               (new-conj source env
                 (gen-call-prim source env
                   prim
                   (list (new-ref source env
                           var1)))
                 (new-conj source env
                   (gen-call-prim source env
                     prim
                     (list (new-ref source env
                             var2)))
                   (new-conj source env
                     (gen-call-prim source env
                       **fx=-sym
                       (list (gen-call-prim source env
                               **subtype-sym
                               (list (new-ref source env
                                       var1)))
                             (gen-call-prim source env
                               **subtype-sym
                               (list (new-ref source env
                                       var2)))))
                     (invalid)))))))
         fail)))

    (define case-real?
      (lambda (source
               env
               vars
               check-run-time-binding
               invalid
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-disj source env
             (gen-call-prim-vars source env **fixnum?-sym vars)
             (new-disj source env
               (gen-call-prim-vars source env **flonum?-sym vars)
               (gen-call-prim-vars source env **real?-sym vars))))
         fail)))

    (define case-rational?
      (lambda (source
               env
               vars
               check-run-time-binding
               invalid
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-disj source env
             (gen-call-prim-vars source env **fixnum?-sym vars)
             (new-tst source env
               (gen-call-prim-vars source env **flonum?-sym vars)
               (gen-call-prim-vars source env **flfinite?-sym vars)
               (gen-call-prim-vars source env **rational?-sym vars))))
         fail)))

    (define case-integer?
      (lambda (source
               env
               vars
               check-run-time-binding
               invalid
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-disj source env
             (gen-call-prim-vars source env **fixnum?-sym vars)
             (gen-call-prim-vars source env **integer?-sym vars)))
         fail)))

    (define (case-exact? fallback)
      (lambda (source
               env
               vars
               check-run-time-binding
               invalid
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-disj source env
             (gen-call-prim-vars source env **fixnum?-sym vars)
             (new-conj source env
               (gen-call-prim source env
                 **not-sym
                 (list (gen-call-prim-vars source env **flonum?-sym vars)))
               (gen-call-prim-vars source env fallback vars))))
         fail)))

    (define (case-inexact? fallback)
      (lambda (source
               env
               vars
               check-run-time-binding
               invalid
               fail)
        (gen-check-run-time-binding
         check-run-time-binding
         source
         env
         (lambda ()
           (new-conj source env
             (gen-call-prim source env
               **not-sym
               (list (gen-call-prim-vars source env **fixnum?-sym vars)))
             (new-disj source env
               (gen-call-prim-vars source env **flonum?-sym vars)
               (gen-call-prim-vars source env fallback vars))))
         fail)))

    (targ-exp "##real?"     (make-simple-expander case-real?))
    (targ-exp "##rational?" (make-simple-expander case-rational?))
    (targ-exp "##integer?"  (make-simple-expander case-integer?))
    (targ-exp "##exact?"    (make-simple-expander (case-exact? **exact?-sym)))
    (targ-exp "##inexact?"  (make-simple-expander (case-inexact? **inexact?-sym)))
    (targ-exp "exact?"      (make-simple-expander (case-exact? exact?-sym)))
    (targ-exp "inexact?"    (make-simple-expander (case-inexact? inexact?-sym)))

    (targ-exp "fx=" (make-simple-expander case-fx=))
    (targ-exp "fl=" (make-simple-expander case-fl=))
    (targ-exp "="   (make-fixflo-expander case-fx= case-fl=))

    (targ-exp "fx<" (make-simple-expander case-fx<))
    (targ-exp "fl<" (make-simple-expander case-fl<))
    (targ-exp "<"   (make-fixflo-expander case-fx< case-fl<))

    (targ-exp "fx>" (make-simple-expander case-fx>))
    (targ-exp "fl>" (make-simple-expander case-fl>))
    (targ-exp ">"   (make-fixflo-expander case-fx> case-fl>))

    (targ-exp "fx<=" (make-simple-expander case-fx<=))
    (targ-exp "fl<=" (make-simple-expander case-fl<=))
    (targ-exp "<="   (make-fixflo-expander case-fx<= case-fl<=))

    (targ-exp "fx>=" (make-simple-expander case-fx>=))
    (targ-exp "fl>=" (make-simple-expander case-fl>=))
    (targ-exp ">="   (make-fixflo-expander case-fx>= case-fl>=))

    (targ-exp "flinteger?" (make-simple-expander case-flinteger?))

    (targ-exp "fxzero?" (make-simple-expander case-fxzero?))
    (targ-exp "flzero?" (make-simple-expander case-flzero?))
    (targ-exp "zero?"   (make-fixflo-expander case-fxzero? case-flzero?))

    (targ-exp "fxpositive?" (make-simple-expander case-fxpositive?))
    (targ-exp "flpositive?" (make-simple-expander case-flpositive?))
    (targ-exp "positive?"   (make-fixflo-expander case-fxpositive? case-flpositive?))

    (targ-exp "fxnegative?" (make-simple-expander case-fxnegative?))
    (targ-exp "flnegative?" (make-simple-expander case-flnegative?))
    (targ-exp "negative?"   (make-fixflo-expander case-fxnegative? case-flnegative?))

    (targ-exp "fxodd?" (make-simple-expander case-fxodd?))
    (targ-exp "flodd?" (make-simple-expander case-flodd?))
    (targ-exp "odd?"   (make-fixflo-expander case-fxodd? case-flodd?))

    (targ-exp "fxeven?" (make-simple-expander case-fxeven?))
    (targ-exp "fleven?" (make-simple-expander case-fleven?))
    (targ-exp "even?"   (make-fixflo-expander case-fxeven? case-fleven?))

    (targ-exp "flfinite?" (make-simple-expander case-flfinite?))
    (targ-exp "finite?"   (make-fixflo-expander no-case case-flfinite?))

    (targ-exp "flinfinite?" (make-simple-expander case-flinfinite?))
    (targ-exp "infinite?"   (make-fixflo-expander no-case case-flinfinite?))

    (targ-exp "flnan?" (make-simple-expander case-flnan?))
    (targ-exp "nan?"   (make-fixflo-expander no-case case-flnan?))

    (targ-exp "fxmax" (make-simple-expander case-fxmax))
    (targ-exp "flmax" (make-simple-expander case-flmax))
    (targ-exp "max"   (make-fixflo-expander case-fxmax case-flmax))

    (targ-exp "fxmin" (make-simple-expander case-fxmin))
    (targ-exp "flmin" (make-simple-expander case-flmin))
    (targ-exp "min"   (make-fixflo-expander case-fxmin case-flmin))

    (targ-exp "fxwrap+" (make-simple-expander case-fxwrap+))
    (targ-exp "fx+"     (make-simple-expander case-fx+))
    (targ-exp "fl+"     (make-simple-expander case-fl+))
    (targ-exp "+"       (make-fixflo-expander
                         case-fx+
                         (gen-validating-case
                          **flonum?-sym
                          (make-nary-generator
                           gen-fixnum-0
                           gen-first-arg
                           (make-fold-generator **fl+-sym)))))

    (targ-exp "fxwrap*" (make-simple-expander case-fxwrap*))
    (targ-exp "fx*"     (make-simple-expander case-fx*))
    (targ-exp "fl*"     (make-simple-expander case-fl*))
    (targ-exp "*"       (make-fixflo-expander
                         case-fx*
                         (gen-validating-case
                          **flonum?-sym
                          (make-nary-generator
                           gen-fixnum-1
                           gen-first-arg
                           (make-fold-generator **fl*-sym)))))

    (targ-exp "fxwrap-" (make-simple-expander case-fxwrap-))
    (targ-exp "fx-"     (make-simple-expander case-fx-))
    (targ-exp "fl-"     (make-simple-expander case-fl-))
    (targ-exp "-"       (make-fixflo-expander case-fx- case-fl-))

    (targ-exp "fl/"     (make-simple-expander case-fl/))
    (targ-exp "/"       (make-fixflo-expander no-case case-fl/))

    (targ-exp "fxwrapquotient" (make-simple-expander case-fxwrapquotient))
    (targ-exp "fxquotient"     (make-simple-expander case-fxquotient))
    (targ-exp "quotient"       (make-fixnum-division-expander case-fxquotient))

    (targ-exp "fxremainder" (make-simple-expander case-fxremainder))
    (targ-exp "remainder"   (make-fixnum-division-expander case-fxremainder))

    (targ-exp "fxmodulo" (make-simple-expander case-fxmodulo))
    (targ-exp "modulo"   (make-fixnum-division-expander case-fxmodulo))

    (targ-exp "fxnot" (make-simple-expander case-fxnot))

    (targ-exp "fxand" (make-simple-expander case-fxand))

    (targ-exp "fxior" (make-simple-expander case-fxior))

    (targ-exp "fxxor" (make-simple-expander case-fxxor))

;;  (targ-exp "fxwraparithmetic-shift" (make-simple-expander case-fxwraparithmetic-shift))
;;  (targ-exp "fxarithmetic-shift" (make-simple-expander case-fxarithmetic-shift))

;;  (targ-exp "fxwraparithmetic-shift-left" (make-simple-expander case-fxwraparithmetic-shift-left))
;;  (targ-exp "fxarithmetic-shift-left" (make-simple-expander case-fxarithmetic-shift-left))

;;  (targ-exp "fxarithmetic-shift-right" (make-simple-expander case-fxarithmetic-shift-right))
;;  (targ-exp "fxwraplogical-shift-right" (make-simple-expander case-fxwraplogical-shift-right))

    (targ-exp "fxwrapabs" (make-simple-expander case-fxwrapabs))
    (targ-exp "fxabs" (make-simple-expander case-fxabs))
    (targ-exp "flabs" (make-simple-expander case-flabs))
    (targ-exp "abs"   (make-fixflo-expander case-fxabs case-flabs))

    (targ-exp "flfloor" (make-simple-expander case-flfloor))
    (targ-exp "floor"   (make-fixflo-expander no-case case-flfloor))

    (targ-exp "flceiling" (make-simple-expander case-flceiling))
    (targ-exp "ceiling"   (make-fixflo-expander no-case case-flceiling))

    (targ-exp "fltruncate" (make-simple-expander case-fltruncate))
    (targ-exp "truncate"   (make-fixflo-expander no-case case-fltruncate))

    (targ-exp "flround" (make-simple-expander case-flround))
    (targ-exp "round"   (make-fixflo-expander no-case case-flround))

    (targ-exp "flexp" (make-simple-expander case-flexp))
    (targ-exp "exp"   (make-fixflo-expander no-case case-flexp))

    (targ-exp "fllog" (make-simple-expander case-fllog))
    (targ-exp "log"   (make-fixflo-expander no-case case-fllog))

    (targ-exp "flsin" (make-simple-expander case-flsin))
    (targ-exp "sin"   (make-fixflo-expander no-case case-flsin))

    (targ-exp "flcos" (make-simple-expander case-flcos))
    (targ-exp "cos"   (make-fixflo-expander no-case case-flcos))

    (targ-exp "fltan" (make-simple-expander case-fltan))
    (targ-exp "tan"   (make-fixflo-expander no-case case-fltan))

    (targ-exp "flasin" (make-simple-expander case-flasin))
    (targ-exp "asin"   (make-fixflo-expander no-case case-flasin))

    (targ-exp "flacos" (make-simple-expander case-flacos))
    (targ-exp "acos"   (make-fixflo-expander no-case case-flacos))

    (targ-exp "flatan" (make-simple-expander case-flatan))
    (targ-exp "atan"   (make-fixflo-expander no-case case-flatan))

    (targ-exp "flexpt" (make-simple-expander case-flexpt))
    (targ-exp "expt"   (make-fixflo-expander no-case case-flexpt))

    (targ-exp "flsqrt" (make-simple-expander case-flsqrt))
    (targ-exp "sqrt"   (make-fixflo-expander no-case case-flsqrt))

    (targ-exp "fixnum->flonum" (make-simple-expander case-fixnum->flonum))

    (targ-exp
     "exact->inexact"
     (make-fixflo-expander
      case-fixnum-exact->inexact
      case-flonum-exact->inexact))

    (targ-exp
     "inexact->exact"
     (make-fixflo-expander
      case-fixnum-inexact->exact
      case-flonum-inexact->exact))

    (targ-exp "char=?" (make-simple-expander case-char=?))
    (targ-exp "char<?" (make-simple-expander case-char<?))
    (targ-exp "char>?" (make-simple-expander case-char>?))
    (targ-exp "char<=?" (make-simple-expander case-char<=?))
    (targ-exp "char>=?" (make-simple-expander case-char>=?))

    (targ-exp
     "eqv?"
     (make-simple-expander (case-eqv?-or-equal? **subtyped?-sym)))

    (targ-exp
     "equal?"
     (make-simple-expander (case-eqv?-or-equal? **mem-allocated?-sym)))
))

(define (setup-vector-primitives)

  (define **fixnum?-sym (string->canonical-symbol "##fixnum?"))
  (define **flonum?-sym (string->canonical-symbol "##flonum?"))
  (define **char?-sym   (string->canonical-symbol "##char?"))
  (define **fx<-sym     (string->canonical-symbol "##fx<"))
  (define **fx<=-sym    (string->canonical-symbol "##fx<="))
  (define **subtyped-mutable?-sym (string->canonical-symbol "##subtyped-mutable?"))

  (define **string?-sym          (string->canonical-symbol "##string?"))
  (define **string-length-sym    (string->canonical-symbol "##string-length"))
  (define **string-ref-sym       (string->canonical-symbol "##string-ref"))
  (define **string-set!-sym      (string->canonical-symbol "##string-set!"))

  (define **vector?-sym          (string->canonical-symbol "##vector?"))
  (define **vector-length-sym    (string->canonical-symbol "##vector-length"))
  (define **vector-ref-sym       (string->canonical-symbol "##vector-ref"))
  (define **vector-set!-sym      (string->canonical-symbol "##vector-set!"))

  (define **s8vector?-sym        (string->canonical-symbol "##s8vector?"))
  (define **s8vector-length-sym  (string->canonical-symbol "##s8vector-length"))
  (define **s8vector-ref-sym     (string->canonical-symbol "##s8vector-ref"))
  (define **s8vector-set!-sym    (string->canonical-symbol "##s8vector-set!"))

  (define **u8vector?-sym        (string->canonical-symbol "##u8vector?"))
  (define **u8vector-length-sym  (string->canonical-symbol "##u8vector-length"))
  (define **u8vector-ref-sym     (string->canonical-symbol "##u8vector-ref"))
  (define **u8vector-set!-sym    (string->canonical-symbol "##u8vector-set!"))

  (define **s16vector?-sym       (string->canonical-symbol "##s16vector?"))
  (define **s16vector-length-sym (string->canonical-symbol "##s16vector-length"))
  (define **s16vector-ref-sym    (string->canonical-symbol "##s16vector-ref"))
  (define **s16vector-set!-sym   (string->canonical-symbol "##s16vector-set!"))

  (define **u16vector?-sym       (string->canonical-symbol "##u16vector?"))
  (define **u16vector-length-sym (string->canonical-symbol "##u16vector-length"))
  (define **u16vector-ref-sym    (string->canonical-symbol "##u16vector-ref"))
  (define **u16vector-set!-sym   (string->canonical-symbol "##u16vector-set!"))

  (define **s32vector?-sym       (string->canonical-symbol "##s32vector?"))
  (define **s32vector-length-sym (string->canonical-symbol "##s32vector-length"))
  (define **s32vector-ref-sym    (string->canonical-symbol "##s32vector-ref"))
  (define **s32vector-set!-sym   (string->canonical-symbol "##s32vector-set!"))

  (define **u32vector?-sym       (string->canonical-symbol "##u32vector?"))
  (define **u32vector-length-sym (string->canonical-symbol "##u32vector-length"))
  (define **u32vector-ref-sym    (string->canonical-symbol "##u32vector-ref"))
  (define **u32vector-set!-sym   (string->canonical-symbol "##u32vector-set!"))

  (define **s64vector?-sym       (string->canonical-symbol "##s64vector?"))
  (define **s64vector-length-sym (string->canonical-symbol "##s64vector-length"))
  (define **s64vector-ref-sym    (string->canonical-symbol "##s64vector-ref"))
  (define **s64vector-set!-sym   (string->canonical-symbol "##s64vector-set!"))

  (define **u64vector?-sym       (string->canonical-symbol "##u64vector?"))
  (define **u64vector-length-sym (string->canonical-symbol "##u64vector-length"))
  (define **u64vector-ref-sym    (string->canonical-symbol "##u64vector-ref"))
  (define **u64vector-set!-sym   (string->canonical-symbol "##u64vector-set!"))

  (define **f32vector?-sym       (string->canonical-symbol "##f32vector?"))
  (define **f32vector-length-sym (string->canonical-symbol "##f32vector-length"))
  (define **f32vector-ref-sym    (string->canonical-symbol "##f32vector-ref"))
  (define **f32vector-set!-sym   (string->canonical-symbol "##f32vector-set!"))

  (define **f64vector?-sym       (string->canonical-symbol "##f64vector?"))
  (define **f64vector-length-sym (string->canonical-symbol "##f64vector-length"))
  (define **f64vector-ref-sym    (string->canonical-symbol "##f64vector-ref"))
  (define **f64vector-set!-sym   (string->canonical-symbol "##f64vector-set!"))

  (define (make-fixnum-interval-checker lo hi)
    ; assumes (integer-length hi) >= (integer-length lo)
    (lambda (source env var)
      (if (targ-fixnum64? hi)
        (let ((interval-check
               (gen-fixnum-interval-check source env
                 var
                 (new-cst source env
                   lo)
                 (new-cst source env
                   hi)
                 #t)))
          (if (targ-fixnum32? hi)
            interval-check
            (new-conj source env
              (gen-call-prim source env
                **fixnum?-sym
                (list (new-cst source env
                        hi)))
              interval-check)))
        (gen-call-prim-vars source env
          **fixnum?-sym
          (list var)))))

  (define (make-flonum-checker)
    (lambda (source env var)
      (gen-call-prim-vars source env
        **flonum?-sym
        (list var))))

  (define (gen-fixnum-interval-check source env var lo hi incl?)
    (let* ((fixnum-check
            (gen-call-prim-vars source env
              **fixnum?-sym
              (list var)))
           (interval-check
            (new-conj source env
              fixnum-check
              (new-conj source env
                (gen-call-prim source env
                  **fx<=-sym
                  (list lo
                        (new-ref source env
                          var)))
                (gen-call-prim source env
                  (if incl? **fx<=-sym **fx<-sym)
                  (list (new-ref source env
                          var)
                        hi))))))
      interval-check))

  (define (make-vector-expanders
           vect?-str
           vect-length-str
           vect-ref-str
           vect-set!-str
           **vect?-str
           **vect-length-str
           **vect-ref-str
           **vect-set!-str
           value-checker)
    (let ((vect?-sym (string->canonical-symbol vect?-str))
          (vect-length-sym (string->canonical-symbol vect-length-str))
          (vect-ref-sym (string->canonical-symbol vect-ref-str))
          (vect-set!-sym (string->canonical-symbol vect-set!-str))
          (**vect?-sym (string->canonical-symbol **vect?-str))
          (**vect-length-sym (string->canonical-symbol **vect-length-str))
          (**vect-ref-sym (string->canonical-symbol **vect-ref-str))
          (**vect-set!-sym (string->canonical-symbol **vect-set!-str)))

      (define (gen-type-check source env vect-arg)
        (gen-call-prim-vars source env
          **vect?-sym
          (list vect-arg)))

      (define (gen-mutability-check source env vect-arg)
        (gen-call-prim-vars source env
          **subtyped-mutable?-sym
          (list vect-arg)))

      (define (gen-index-check source env vect-arg index-arg)
        (gen-fixnum-interval-check source env
          index-arg
          (new-cst source env
            0)
          (gen-call-prim-vars source env
            **vect-length-sym
            (list vect-arg))
          #f))

      (define (make-length-expander type-check?)
        (lambda (ptree oper args generate-call check-run-time-binding)
          (let* ((source
                  (node-source ptree))
                 (env
                  (node-env ptree))
                 (vars
                  (gen-temp-vars source args))
                 (arg1
                  (car vars))
                 (type-check
                  (and type-check?
                       (gen-type-check source env arg1)))
                 (checks
                  (if check-run-time-binding
                    (let ((rtb-check (check-run-time-binding)))
                      (if type-check
                        (new-conj source env
                          rtb-check
                          type-check)
                        rtb-check))
                    type-check))
                 (call-prim
                  (gen-call-prim-vars source env
                    **vect-length-sym
                    vars)))
            (gen-prc source env
              vars
              (if checks
                (new-tst source env
                  checks
                  call-prim
                  (generate-call vars))
                call-prim)))))

      (define (make-ref-set!-expander type-check? set!?)
        (lambda (ptree oper args generate-call check-run-time-binding)
          (let* ((source
                  (node-source ptree))
                 (env
                  (node-env ptree))
                 (vars
                  (gen-temp-vars source args))
                 (arg1
                  (car vars))
                 (arg2
                  (cadr vars))
                 (type-check
                  (and type-check?
                       (let ((check
                              (gen-type-check source env arg1)))
                         (if set!?
                           (new-conj source env
                             check
                             (gen-mutability-check source env arg1))
                           check))))
                 (index-check
                  (gen-index-check source env arg1 arg2))
                 (index-value-check
                  (if (and value-checker set!?)
                    (let ((val-check (value-checker source env (caddr vars))))
                      (new-conj source env
                        index-check
                        val-check))
                    index-check))
                 (type-index-value-check
                  (if type-check
                    (new-conj source env
                      type-check
                      index-value-check)
                    index-value-check))
                 (checks
                  (if check-run-time-binding
                    (let ((rtb-check (check-run-time-binding)))
                      (if type-index-value-check
                        (new-conj source env
                          rtb-check
                          type-index-value-check)
                        rtb-check))
                    type-index-value-check))
                 (call-prim
                  (gen-call-prim-vars source env
                    (if set!? **vect-set!-sym **vect-ref-sym)
                    vars)))
            (gen-prc source env
              vars
              (if checks
                (new-tst source env
                  checks
                  call-prim
                  (generate-call vars))
                call-prim)))))

      (targ-exp
       vect-length-str
       (make-length-expander #t))

      (targ-exp
       **vect-length-str
       (make-length-expander #f))

      (targ-exp
       vect-ref-str
       (make-ref-set!-expander #t #f))

      (targ-exp
       **vect-ref-str
       (make-ref-set!-expander #f #f))

      (targ-exp
       vect-set!-str
       (make-ref-set!-expander #t #t))
          
      (targ-exp
       **vect-set!-str
       (make-ref-set!-expander #f #t))))
          
  (make-vector-expanders
   "vector?"
   "vector-length"
   "vector-ref"
   "vector-set!"
   "##vector?"
   "##vector-length"
   "##vector-ref"
   "##vector-set!"
   #f)

  (make-vector-expanders
   "string?"
   "string-length"
   "string-ref"
   "string-set!"
   "##string?"
   "##string-length"
   "##string-ref"
   "##string-set!"
   (lambda (source env var)
     (gen-call-prim-vars source env
       **char?-sym
       (list var))))

  (make-vector-expanders
   "s8vector?"
   "s8vector-length"
   "s8vector-ref"
   "s8vector-set!"
   "##s8vector?"
   "##s8vector-length"
   "##s8vector-ref"
   "##s8vector-set!"
   (make-fixnum-interval-checker -128 127))

  (make-vector-expanders
   "u8vector?"
   "u8vector-length"
   "u8vector-ref"
   "u8vector-set!"
   "##u8vector?"
   "##u8vector-length"
   "##u8vector-ref"
   "##u8vector-set!"
   (make-fixnum-interval-checker 0 255))

  (make-vector-expanders
   "s16vector?"
   "s16vector-length"
   "s16vector-ref"
   "s16vector-set!"
   "##s16vector?"
   "##s16vector-length"
   "##s16vector-ref"
   "##s16vector-set!"
   (make-fixnum-interval-checker -32768 32767))

  (make-vector-expanders
   "u16vector?"
   "u16vector-length"
   "u16vector-ref"
   "u16vector-set!"
   "##u16vector?"
   "##u16vector-length"
   "##u16vector-ref"
   "##u16vector-set!"
   (make-fixnum-interval-checker 0 65535))

#;
  (make-vector-expanders
   "s32vector?"
   "s32vector-length"
   "s32vector-ref"
   "s32vector-set!"
   "##s32vector?"
   "##s32vector-length"
   "##s32vector-ref"
   "##s32vector-set!"
   (make-fixnum-interval-checker -2147483648 2147483647))

#;
  (make-vector-expanders
   "u32vector?"
   "u32vector-length"
   "u32vector-ref"
   "u32vector-set!"
   "##u32vector?"
   "##u32vector-length"
   "##u32vector-ref"
   "##u32vector-set!"
   (make-fixnum-interval-checker 0 4294967295))

#;
  (make-vector-expanders
   "s64vector?"
   "s64vector-length"
   "s64vector-ref"
   "s64vector-set!"
   "##s64vector?"
   "##s64vector-length"
   "##s64vector-ref"
   "##s64vector-set!"
   (make-fixnum-interval-checker -9223372036854775808 9223372036854775807))

#;
  (make-vector-expanders
   "u64vector?"
   "u64vector-length"
   "u64vector-ref"
   "u64vector-set!"
   "##u64vector?"
   "##u64vector-length"
   "##u64vector-ref"
   "##u64vector-set!"
   (make-fixnum-interval-checker 0 18446744073709551615))

  (make-vector-expanders
   "f32vector?"
   "f32vector-length"
   "f32vector-ref"
   "f32vector-set!"
   "##f32vector?"
   "##f32vector-length"
   "##f32vector-ref"
   "##f32vector-set!"
   (make-flonum-checker))

  (make-vector-expanders
   "f64vector?"
   "f64vector-length"
   "f64vector-ref"
   "f64vector-set!"
   "##f64vector?"
   "##f64vector-length"
   "##f64vector-ref"
   "##f64vector-set!"
   (make-flonum-checker))
)

(define (setup-structure-primitives)

  (define **structure-direct-instance-of?-sym
    (string->canonical-symbol "##structure-direct-instance-of?"))

  (define **type-id-sym
    (string->canonical-symbol "##type-id"))

  (define **unchecked-structure-ref-sym
    (string->canonical-symbol "##unchecked-structure-ref"))

  (define **unchecked-structure-set!-sym
    (string->canonical-symbol "##unchecked-structure-set!"))

  (define (gen-type-check source env obj-arg type-arg)
    (gen-call-prim source env
      **structure-direct-instance-of?-sym
      (list (new-ref source env
              obj-arg)
            (gen-call-prim-vars source env
              **type-id-sym
              (list type-arg)))))

  (define (make-ref-set!-expander set!?)
    (lambda (ptree oper args generate-call check-run-time-binding)
      (let* ((source
              (node-source ptree))
             (env
              (node-env ptree))
             (vars
              (gen-temp-vars source args))
             (obj-var
              (list-ref vars 0))
             (type-var
              (list-ref vars (if set!? 3 2)))
             (type-check
              (gen-type-check source env obj-var type-var))
             (call-prim
              (gen-call-prim-vars source env
                (if set!?
                  **unchecked-structure-set!-sym
                  **unchecked-structure-ref-sym)
                vars)))
        (gen-prc source env
          vars
          (new-tst source env
            type-check
            call-prim
            (generate-call vars))))))

  (targ-exp
   "##direct-structure-ref"
   (make-ref-set!-expander #f))

  (targ-exp
   "##direct-structure-set!"
   (make-ref-set!-expander #t))
)

(setup-list-primitives)
(setup-numeric-primitives)
(setup-vector-primitives)
(setup-structure-primitives)

)

(targ-setup-expanders)

;;;----------------------------------------------------------------------------
