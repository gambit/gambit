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

;;; Test exceptions

(check-tail-exn type-exception? (lambda () (shell-command #f)))
(check-tail-exn type-exception? (lambda () (shell-command #f #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (shell-command)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (shell-command "exit 0" #f #f)))
