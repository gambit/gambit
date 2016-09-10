(define bench "")

(define pop-size 25)

(define goal <)

(define (evaluate options)
  (let ((p (open-process (list path: "./evaluate"
                               arguments: (list bench options)))))
    (let ((x (read p)))
      (close-port p)
      (let ((t (cadr x)))
        (display ";") (pp (list t options))
        t))))

(define options '(
("" " -fno-merge-constants")
("" " -fno-defer-pop")
("" " -fno-thread-jumps")
("" " -fno-guess-branch-probability")
("" " -fno-cprop-registers")
("" " -fno-if-conversion")
("" " -fno-if-conversion2")
("" " -fno-delayed-branch")
("" " -fno-loop-optimize" " -floop-optimize2")
("" " -ftree-ccp")
("" " -ftree-dce")
("" " -ftree-dominator-opts")
("" " -ftree-dse")
("" " -ftree-ter")
("" " -ftree-lrs")
("" " -ftree-sra")
("" " -ftree-copyrename")
("" " -ftree-fre")
("" " -ftree-ch")
("" " -fmerge-constants")

("" " -fcrossjumping")
("" " -foptimize-sibling-calls")
("" " -fcse-follow-jumps")
("" " -fcse-skip-blocks")
("" " -fgcse")
("" " -fexpensive-optimizations")
("" " -fstrength-reduce")
("" " -frerun-cse-after-loop")
("" " -frerun-loop-opt")
("" " -fcaller-saves")
("" " -fforce-mem" " -fforce-addr")
("" " -fpeephole2")
("" " -fschedule-insns")
("" " -fschedule-insns2")
("" " -fregmove")
;;;(" -fno-strict-aliasing" " -fstrict-aliasing")
("" " -fdelete-null-pointer-checks")
("" " -freorder-blocks")
("" " -fthread-jumps")
("" " -fgcse-lm")
("" " -fsched-interblock")
("" " -fsched-spec")
("" " -freorder-blocks")
("" " -freorder-functions")
("" " -funit-at-a-time")
("" " -falign-functions")
("" " -falign-jumps")
("" " -falign-loops")
("" " -falign-labels")
("" " -ftree-pre")

("" " -finline-functions")
("" " -funswitch-loops")
("" " -fgcse-after-reload")
           
;;;("" " -fomit-frame-pointer" " -momit-leaf-frame-pointer")
("" " -ffloat-store")
("" " -fprefetch-loop-arrays")
("" " -fno-inline")
("" " -fpeel-loops")
("" " -ftracer")
("" " -funroll-loops" " -funroll-all-loops")
("" " -fbranch-target-load-optimize" " -fbranch-target-load-optimize2")
("" " -fmodulo-sched")
("" " -fno-function-cse")
("" " -fgcse-sm")
("" " -fgcse-las")
("" " -freschedule-modulo-scheduled-loops")
("" " -ftree-loop-im")
("" " -ftree-loop-ivcanon")
("" " -fivopts")
("" " -ftree-vectorize")
("" " -fvariable-expansion-in-unroller")
))

(define (sort-list l <?)

  (define (mergesort l)

    (define (merge l1 l2)
      (cond ((null? l1) l2)
            ((null? l2) l1)
            (else
             (let ((e1 (car l1)) (e2 (car l2)))
               (if (<? e1 e2)
                 (cons e1 (merge (cdr l1) l2))
                 (cons e2 (merge l1 (cdr l2))))))))

    (define (split l)
      (if (or (null? l) (null? (cdr l)))
        l
        (cons (car l) (split (cddr l)))))

    (if (or (null? l) (null? (cdr l)))
      l
      (let* ((l1 (mergesort (split l)))
             (l2 (mergesort (split (cdr l)))))
        (merge l1 l2))))

  (mergesort l))

(define (iota n)
  (let loop ((i (- n 1)) (lst '()))
    (if (>= i 0)
        (loop (- i 1) (cons i lst))
        lst)))

(define (random-options)
  (map (lambda (x) (list-ref x (random-integer (length x))))
       options))

(define (options->string options)
  (apply string-append options))

(define (cross options1 options2)
  (map (lambda (o1 o2 o)
         (cond ((= 0 (random-integer 35))
                (list-ref o (random-integer (length o))))
               ((= 0 (random-integer 2))
                o1)
               (else
                o2)))
       options1
       options2
       options))

(define (evaluated options)
  (let* ((t (evaluate (options->string options)))
         (x (cons t options)))
    (if (< t (car best))
        (set! best x))
    x))

(define (value evaluated-options)
  (car evaluated-options))

(define (opts evaluated-options)
  (cdr evaluated-options))

(define (order evaluated-options)
  (sort-list evaluated-options
             (lambda (x y) (goal (value x) (value y)))))

(define (select)
  (let* ((n (quotient (* pop-size 2) 3))
         (x (apply + (map (lambda (x) (random-integer 2))
                          (iota (* 2 n)))))
         (i (abs (- x n))))
    i))

(define (new-generation pop)
  (order
   (map (lambda (x) (evaluated x))
        (map (lambda (_)
               (let ((x (select)))
                 (let loop ()
                   (let ((y (select)))
                     (if (= x y)
                         (loop)
                         (cross (opts (list-ref pop x))
                                (opts (list-ref pop y))))))))
             pop))))

(define best '())

(define (optimize)
  (set! best (list 99999999999))
  (let ((initial-pop
         (order
          (map (lambda (i) (evaluated (random-options)))
               (iota pop-size)))))
    (let loop ((i 0) (pop initial-pop))
;      (display ";")(write (list i (map value pop)))(newline)
      (if (< i 10)
          (loop (+ i 1)
                (new-generation pop))
          best))))

(for-each
 (lambda (b)
   (set! bench b)
   (pretty-print (list b (optimize))))
 '("lattice"
   "ray"
   "boyer"
   "diviter"
   "puzzle"
   "takl"
   "fft"
   "conform"
   "graphs"
   "simplex"))
