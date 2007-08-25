; File: "mylib.scm", Time-stamp: <2007-04-04 14:30:40 feeley>

; Copyright (c) 2005-2007 by Marc Feeley, All Rights Reserved.

; A library of Scheme procedures callable from C.  The following
; procedures are callable from C:
;
;  ___SCMOBJ new_counter (void);                allocate a new counter
;  void release_counter (___SCMOBJ counter);    C world no longer needs counter
;  void increment_counter (___SCMOBJ counter);  increment counter's count
;  int get_counter (___SCMOBJ counter);         gets counter's count

;------------------------------------------------------------------------------

(c-declare #<<end-of-c-declare
#include "mylib.h"
end-of-c-declare
)

(define-type counter ; define a record containing a single count field
  count
)

(c-define-type counter scheme-object)

(c-define (new-counter) () scheme-object "new_counter" ""
  (##still-obj-refcount-inc!          ; create a STILL counter object
    (##still-copy (make-counter 0)))) ; with a reference count of 1

(c-define (release-counter c) (counter) void "release_counter" ""
  (##still-obj-refcount-dec! c))

(c-define (increment-counter c) (counter) void "increment_counter" ""
  (let ((n (+ 1 (counter-count c))))
    (counter-count-set! c n)
    (if (= 0 (modulo n 10000))
        (pretty-print (list c (pthread-self))))))

(c-define (get-counter c) (counter) int "get_counter" ""
  (counter-count c))

;------------------------------------------------------------------------------

; we need pthread_self

(c-declare #<<end-of-c-declare
#include <pthread.h>
end-of-c-declare
)

(c-define-type pthread_t (pointer void))

(define pthread-self
  (c-lambda () pthread_t "pthread_self"))

;------------------------------------------------------------------------------
