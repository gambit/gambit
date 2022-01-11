;;;============================================================================

;;; File: "dom.scm"

;;; Copyright (c) 2022 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2022 by Marc-André Bélanger, All Rights Reserved.

;;;============================================================================

(define (querySelector selector)
  \document.querySelector(`selector))

(define (getElementById id)
  \document.getElementById(`id))

(define (createElement type)
  \document.createElement(`type))

(define (setAttribute elem attr val)
  \(`elem).setAttribute(`attr, `val))

(define (appendChild elem child)
  \(`elem).appendChild(`child))

(define (insertAdjacentHTML elem pos html)
  \(`elem).insertAdjacentHTML(`pos, `html))

(define (console.log msg)
  \console.log(`msg))

(define (alert msg)
  \alert(`msg))

(define (load-js url #!optional (async? #f))
  (let ((script (createElement "script")))
    (setAttribute script "type" "text/javascript")
    (let ((mut (or async?
                   (let ((mut (make-mutex)))
                     (mutex-lock! mut)
                     mut))))
      (or async?
          \(`script).onload=`(lambda args (mutex-unlock! mut)))
      (setAttribute script "src" url)
      (appendChild \document.head script)
      (or async?
          (begin
            (mutex-lock! mut)
            (mutex-unlock! mut))))))
