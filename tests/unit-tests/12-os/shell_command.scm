(include "#.scm")

;; Both Unix and Windows shells define " exit " and " echo " commands

(test-equal 0 (shell-command "exit 0"))
(test-equal 256 (shell-command "exit 1"))

(test-equal 0 (shell-command "exit 0" #f))
(test-equal 256 (shell-command "exit 1" #f))

(test-equal '(0 . "") (shell-command "exit 0" #t))
(test-equal '(256 . "") (shell-command "exit 1" #t))

;; make sure setenv has an effect on shell-command

(test-equal #f (getenv "UNKNOWNVAR" #f))

(test-assert
 (eq? #t
      (let ((out (shell-command "echo %UNKNOWNVAR%$UNKNOWNVAR" #t)))
        (or (equal? out '(0 . "%UNKNOWNVAR%\n"))
            ;; Unix
            (equal? out '(0 . "%UNKNOWNVAR%$UNKNOWNVAR\r\n"))
            ;; Windows
            ))))

(setenv "UNKNOWNVAR" "foobar")

(test-equal "foobar" (getenv "UNKNOWNVAR" #f))

(test-assert
 (eq? #t
      (let ((out (shell-command "echo %UNKNOWNVAR%$UNKNOWNVAR" #t)))
        (or (equal? out '(0 . "%UNKNOWNVAR%foobar\n"))
            ;; Unix
            (equal? out '(0 . "foobar$UNKNOWNVAR\r\n"))
            ;; Windows
            ))))

(test-assert
 (eq? #t
      (equal? (assoc "UNKNOWNVAR" (get-environment-variables))
              '("UNKNOWNVAR" . "foobar"))))

;;; Test exceptions

(test-error-tail type-exception? (shell-command #f))
(test-error-tail type-exception? (shell-command #f #f))

(test-error-tail type-exception? (getenv #f))

(test-error-tail type-exception? (setenv #f "foo"))
(test-error-tail type-exception? (setenv "foo" #f))

(test-error-tail type-exception? (get-environment-variable #f))

(test-error-tail wrong-number-of-arguments-exception? (shell-command))
(test-error-tail
 wrong-number-of-arguments-exception?
 (shell-command "exit 0" #f #f))

(test-error-tail wrong-number-of-arguments-exception? (getenv))
(test-error-tail wrong-number-of-arguments-exception? (getenv "HOME" #f #f))

(test-error-tail wrong-number-of-arguments-exception? (setenv))
(test-error-tail
 wrong-number-of-arguments-exception?
 (setenv "HOME" "foo" "bar"))

(test-error-tail
 wrong-number-of-arguments-exception?
 (get-environment-variable))
(test-error-tail
 wrong-number-of-arguments-exception?
 (get-environment-variable "HOME" #f))

(test-error-tail
 wrong-number-of-arguments-exception?
 (get-environment-variables #f))
