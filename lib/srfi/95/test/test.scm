(import (srfi 95))
(import (_test))

(define a '(1 2 3 4 5))
(define b '(1 32 3 4 5))
(test-equal (sorted? a <) #t)
(test-equal (sorted? b <) #f)

(test-equal (sort b <) '(1 3 4 5 32))
(test-equal (sorted? (sort! b <) <) #t)
(define b '(1 32 3 4 5))
(test-equal (sort! b <) '(1 3 4 5 32))
(test-equal (sorted? (sort! b <) <) #t)
(define vect #(1 3 2 4 5))
(test-equal (sort vect <) #(1 2 3 4 5))
(test-equal vect #(1 3 2 4 5))
(test-equal (sorted? (sort vect <) <) #t)


(define-macro (test-sort types li sorted-li sorted? less?)
    `(begin ,@(map 
        (lambda (type) 
        (let ((test-list `(,type ,@li))
              (test-expectation `(,type ,@sorted-li)))
            `(begin
               (test-equal (sorted? ,test-list ,less?) ,sorted?) 
               (test-equal (sort ,test-list ,less?) ,test-expectation)
               (test-equal (sorted? (sort ,test-list ,less?) ,less?) #t)
               (test-equal (sort! ,test-list ,less?) ,test-expectation)
               )))
        types)))

(define-syntax test-merge
  (syntax-rules ()
    ((_ l1 l2 result less?) (test-equal (merge l1 l2 less?) result))))

(test-sort (vector u8vector u16vector list u64vector u32vector)  (1 2 3 4 5 6) (1 2 3 4 5 6) #t <)

(test-sort 
  (vector u32vector u64vector list) 
  (9 432949 32 5 44 543 46 46 45 6 876 9 9843796 2) 
  (2 5 6 9 9 32 44 45 46 46 543 876 432949 9843796)
  #f <)

(test-sort
  (vector u8vector u16vector u32vector u64vector list) 
  (9 43 32 5 44 54 46 46 45 6 87 9 98 2)
  (2 5 6 9 9 32 43 44 45 46 46 54 87 98)
  #f <)

(test-sort
  (vector string list) 
  (#\l #\a #\b #\d #\r #\i)
  (#\a #\b #\d #\i #\l #\r)
  #f char<?)

(test-sort
  (vector string list) 
  (#\l #\a #\b #\d #\e #\k #\r #\i)
  (#\a #\b #\d #\e #\i #\k #\l #\r)
  #f char<?)

(test-sort
  (vector u32vector u64vector list) 
  (9 432949 32 5 44 543 46 46 45 6 876 9 9843796 2)
  (2 5 6 9 9 32 44 45 46 46 543 876 432949 9843796)
  #f <)

(test-sort
  (vector u16vector u32vector u64vector list) 
  (9 43 29 49 32 5 44 543 46 46 45 6 876 9 98 43 796 2)
  (2 5 6 9 9 29 32 43 43 44 45 46 46 49 98 543 796 876)
  #f <)

(test-sort
  (vector f32vector f64vector list)
  (20.235 13.124 13.839 12.962 20.047 8.032 18.245 7.322 17.657 17.711 24.971 4.662 17.723 12.759 4.586)
  (4.586 4.662 7.322 8.032 12.759 12.962 13.124 13.839 17.657 17.711 17.723 18.245 20.047 20.235 24.971)
  #f <)

(test-sort
  (vector f32vector f64vector list)
  (3.053 21.795 14.609 11.841 20.317 8.056 7.944 22.253 11.207 21.384 15.591 0.243 4.717 15.33 24.298)
  (0.243 3.053 4.717 7.944 8.056 11.207 11.841 14.609 15.33 15.591 20.317 21.384 21.795 22.253 24.298)
  #f <)

(test-merge '(1 2) '(2 3) '(1 2 2 3) <)

(define-macro (test-errors invalid-sequences)
    `(begin
       ,@(map
           (lambda (seq)
             `(begin
               (test-error #t (sort ,seq <))
               (test-error #t (sort! ,seq <))
               (test-error #t (sorted? ,seq <))))
           invalid-sequences)))

(test-errors (2 3 4 5 6 #t #f #\a #\b #\c 'a 'b 'c 2.3 0.24)) 
