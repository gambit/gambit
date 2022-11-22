(include "../#.scm")

(define-macro (check-same-behavior namespaces . calls)
  `(compare-behavior
    ',namespaces
    ',calls
    ,@(map (lambda (namespace)
             `(let ()
                ,(if (string? namespace)
                     (if (##string-prefix? "~~lib/" namespace)
                         `(include ,namespace)
                         `(namespace (,namespace)
                                     ("" list capture-behavior lambda let quote)))
                     `(##import ,namespace))
                (list ,@(map (lambda (call)
                               `(capture-behavior (lambda () ,call)))
                             calls))))
           namespaces)))

(define ##output-string-port (open-string))

(define (call-with-output-port port thunk)
  (include "~~lib/_repl#.scm")
  (implement-type-repl-channel)
  (let* ((repl-channel (##thread-repl-channel-get! (current-thread)))
         (old-output-port (macro-repl-channel-output-port repl-channel)))
    (macro-repl-channel-output-port-set! repl-channel port)
    (parameterize
      ((current-output-port port))
      (let ((result (thunk port)))
        (macro-repl-channel-output-port-set! repl-channel old-output-port)
        result))))


(define (capture-behavior thunk)
  (call-with-output-port
    ##output-string-port
    (lambda (port)
      (with-exception-catcher
        (lambda (e) e)
        (lambda ()
          (let ((result (thunk)))
            (cons result (get-output-string port))))))))

(define (compare-behavior namespaces calls . behaviors)

  (define (compare namespace1 namespace2 behavior1 behavior2)
    (for-each (lambda (call behavior1 behavior2)
                (if (not (equal? behavior1 behavior2))
                    (##failed-check
                     (string-append
                      (object->string call)
                      " in "
                      (object->string
                       (if (string? namespace2)
                           (if (##string-prefix? "~~lib/" namespace2)
                               `(include ,namespace2)
                               `(namespace (,namespace2)))
                           `(##import ,namespace2)))
                      " returned "
                      (object->string behavior2 256)
                      " but expected "
                      (object->string behavior1 256)))))
              calls
              behavior1
              behavior2))

  (let loop ((i (- (length behaviors) 1)))
    (if (> i 0)
        (begin
          (compare (list-ref namespaces 0)
                   (list-ref namespaces i)
                   (list-ref behaviors 0)
                   (list-ref behaviors i))
          (loop (- i 1))))))
