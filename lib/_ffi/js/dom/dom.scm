;;;============================================================================

;;; File: "dom.scm"

;;; Copyright (c) 2022 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2022 by Marc-André Bélanger, All Rights Reserved.

;;;============================================================================

(define (select selector)
  \document.querySelector(`selector))

(define (get id)
\document.getElementById(`id))

(define (create-element type)
  \document.createElement(`type))

(define (set-attribute elem attr val)
  \(`elem).setAttribute(`attr, `val))

(define (append-child elem child)
  \(`elem).appendChild(`child))

(define (insert-adjacent-html elem pos html)
  \(`elem).insertAdjacentHTML(`pos, `html))

(define (log msg)
  \console.log(`msg))

(define (alert msg)
  \alert(`msg))

(define (load-js url #!optional (async? #f))
  (let ((script (create-element "script")))
    (set-attribute script "type" "text/javascript")
    (let ((mut (or async?
                   (let ((mut (make-mutex)))
                     (mutex-lock! mut)
                     mut))))
      (or async?
          \(`script).onload=`(lambda args (mutex-unlock! mut)))
      (set-attribute script "src" url)
      (append-child \document.head script)
      (or async?
          (begin
            (mutex-lock! mut)
            (mutex-unlock! mut))))))
