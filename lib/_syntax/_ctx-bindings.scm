;;;============================================================================

;;; File: "_ctx-bindings.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.

;;;============================================================================

(define-prim (##ctx-binding-variable hint)
  (##vector 'variable hint))

(define-prim (##ctx-binding-variable? obj)
  (and (##vector obj)
       (##fx> (##vector-length obj) 0)
       (##eq? (##vector-ref obj 0)
              'variable)))

; test only
(define-prim (##ctx-binding-variable-hint obj)
  (and (##ctx-binding-variable? obj)
       (##vector-ref obj 1)))

(define-prim (##ctx-binding-macro hint expander)
  (##vector 'macro hint expander))

(define-prim (##ctx-binding-macro? obj)
  (and (##vector obj)
       (##fx> (##vector-length obj) 0)
       (##eq? (##vector-ref obj 0)
              'macro)))

(define-prim (##ctx-binding-macro-expander obj)
  (##vector-ref obj 2))

(define-prim (##ctx-binding-core-macro hint expander)
  (##vector 'core-macro hint expander))

(define-prim (##ctx-binding-core-macro? obj)
  (and (##vector obj)
       (##fx> (##vector-length obj) 0)
       (##eq? (##vector-ref obj 0)
              'core-macro)))

(define-prim (##ctx-binding-core-macro-expander obj)
  (##vector-ref obj 2))

;;;----------------------------------------------------------------------------

(define-prim (##not-found-object id)
  (##vector 'not-found id))

(define-prim (##not-found-object? obj)
  (and (##vector? obj)
       (##fx> (##vector-length obj) 0)
       (##eq? (##vector-ref obj 0) 
              'not-found)))

(define-prim&proc (resolve-binding id cte)
  (let ((binding (##resolve-id id cte))) ;!!!!
    (let ((key (cond
                 ((##binding-top-level? binding)
                  (##binding-top-level-symbol binding))
                 ((##binding-local? binding)
                  (##binding-local-key binding))
                 (else
                  #f))))
      (or (and key
               (##hygiene-environment-ctx-ref cte key #f))
          (##not-found-object id)))))

(define-prim&proc (resolve-binding-top-level id cte)
  (let ((binding (##resolve-id id cte))) ;!!!!
    (let ((key (cond
                 ((##binding-top-level? binding)
                  (##binding-top-level-symbol binding))
                 (else
                  #f))))
      (or (and key
               (##hygiene-environment-ctx-ref cte key))
          (##not-found-object id)))))


(define-prim&proc (resolve-binding-expander id cte)
  (let ((binding (##resolve-id id cte)))
    (let ((key
            (cond
              ((##binding-local? binding)
               (##binding-local-key binding))
              ((##binding-top-level? binding)
               (##binding-top-level-symbol binding))
              (else
               #f))))
      (let ((value (and key (##hygiene-environment-ctx-ref cte key))))
        (cond
          ((and value
                (or (##ctx-binding-core-macro? value)
                    (##ctx-binding-macro? value)))
           value)
          (else
           (##not-found-object id)))))))

;;;============================================================================
