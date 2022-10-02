(import (srfi 231))

;;; Examples from https://srfi.schemers.org/srfi-231/srfi-231.html

(display "
This demo contains a naive implementation of John
Conway's Game of Life:

https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life

Try the other demos:

demo:  Determine whether a string is a palindrome, ignoring case.
demo3: Matrix manipulation routines: multiplication and Gaussian elimination.
demo4: Image processing algorithms.
")

;;; John Conway's Game of Life

(define (array-pad-periodically a N)
  ;; Pad a periodically with N rows and columns top and bottom, left and right.
  ;; Returns a generalized array.
  (let* ((domain     (array-domain a))
         (m          (interval-upper-bound domain 0))
         (n          (interval-upper-bound domain 1))
         (a_         (array-getter a)))
    (make-array (interval-dilate domain (vector (- N) (- N)) (vector N N))
                (lambda (i j)
                  (a_ (modulo i m) (modulo j n))))))

(define (neighbor-count a)
  (let* ((big-a      (array-copy! (array-pad-periodically a 1)
                                  (array-storage-class a)))
         (domain     (array-domain a))
           ;;; Each of the following translates shares the same body
           ;;; as big-a
         (translates (map (lambda (translation)
                            (array-extract (array-translate big-a translation) domain))
                          '(#(1 0) #(0 1) #(-1 0) #(0 -1)
                            #(1 1) #(1 -1) #(-1 1) #(-1 -1)))))
    ;; Returns a generalized array that contains the number
    ;; of 1s in the 8 cells surrounding each cell in the original array.
    (apply array-map + translates)))

(define (game-rules a neighbor-count)
  ;; a is a single cell, neighbor-count is the count of 1s in
  ;; its 8 neighboring cells.
  (if (= a 1)
      (if (or (= neighbor-count 2)
              (= neighbor-count 3))
          1 0)
      ;; (= a 0)
      (if (= neighbor-count 3)
          1 0)))

(define (advance a)
  ;; Advance the board one generation
  (array-copy!
   (array-map game-rules a (neighbor-count a))
   (array-storage-class a)))

(define glider
  (list*->array
   2
   '((0 0 0 0 0 0 0 0 0 0)
     (0 0 1 0 0 0 0 0 0 0)
     (0 0 0 1 0 0 0 0 0 0)
     (0 1 1 1 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0))
   u1-storage-class))

(define (generations a N)
  (do ((i 0 (fx+ i 1))
       (a a  (advance a)))
      ((fx= i N))
    (newline)
    (pretty-print (array->list* a))))

(display "\nMovement of a glider in Conway's Game of Life:\n")
(generations glider 5)
