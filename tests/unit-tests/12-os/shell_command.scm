(include "#.scm")

;; Both Unix and Windows shells define "exit" and "echo" commands

(check-equal? (shell-command "exit 0") 0)
(check-equal? (shell-command "exit 1") 256)

(check-equal? (shell-command "exit 0" #f) 0)
(check-equal? (shell-command "exit 1" #f) 256)

(check-equal? (shell-command "exit 0" #t) '(0 . ""))
(check-equal? (shell-command "exit 1" #t) '(256 . ""))

;; make sure setenv has an effect on shell-command

(check-equal? (getenv "UNKNOWNVAR" #f) #f)

(check-true
 (let ((out (shell-command "echo %UNKNOWNVAR%$UNKNOWNVAR" #t)))
   (or (equal? out '(0 . "%UNKNOWNVAR%\n")) ;; Unix
       (equal? out '(0 . "%UNKNOWNVAR%$UNKNOWNVAR\r\n")) ;; Windows
       )))

(setenv "UNKNOWNVAR" "foobar")

(check-equal? (getenv "UNKNOWNVAR" #f) "foobar")

(check-true
 (let ((out (shell-command "echo %UNKNOWNVAR%$UNKNOWNVAR" #t)))
   (or (equal? out '(0 . "%UNKNOWNVAR%foobar\n")) ;; Unix
       (equal? out '(0 . "foobar$UNKNOWNVAR\r\n")) ;; Windows
       )))

(check-true
 (equal? (assoc "UNKNOWNVAR" (get-environment-variables))
         '("UNKNOWNVAR" . "foobar")))

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (shell-command #f)))
(check-tail-exn type-exception? (lambda () (shell-command #f #f)))

(check-tail-exn type-exception? (lambda () (getenv #f)))

(check-tail-exn type-exception? (lambda () (setenv #f "foo")))
(check-tail-exn type-exception? (lambda () (setenv "foo" #f)))

(check-tail-exn type-exception? (lambda () (get-environment-variable #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (shell-command)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (shell-command "exit 0" #f #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (getenv)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (getenv "HOME" #f #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (setenv)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (setenv "HOME" "foo" "bar")))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (get-environment-variable)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (get-environment-variable "HOME" #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (get-environment-variables #f)))
