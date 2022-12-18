;;;============================================================================

;;; File: "_io.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Implementation of exceptions.

(implement-library-type-datum-parsing-exception)

(define-prim (##raise-datum-parsing-exception kind readenv . parameters)

  (define (raise-exception)
    (##raise-io-exception
     (macro-readenv-port readenv)
     (macro-make-datum-parsing-exception kind readenv parameters)))

  (let ((read-cont (macro-readenv-read-cont readenv)))
    (if read-cont
        (##continuation-graft
         read-cont
         (lambda () (raise-exception)))
        (raise-exception))))

(define-prim (read-error? obj)
  (macro-datum-parsing-exception? obj))

(implement-library-type-unterminated-process-exception)

(define-prim (##raise-unterminated-process-exception port proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   port
   #f
   #f
   (lambda (procedure arguments port dummy2 dummy3)
     (##raise-io-exception
      port
      (macro-make-unterminated-process-exception procedure arguments)))))

(implement-library-type-nonempty-input-port-character-buffer-exception)

(define-prim (##raise-nonempty-input-port-character-buffer-exception port proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   port
   #f
   #f
   (lambda (procedure arguments port dummy2 dummy3)
     (##raise-io-exception
      port
      (macro-make-nonempty-input-port-character-buffer-exception procedure arguments)))))

(define-prim (##raise-os-io-exception port message code proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   message
   code
   port
   (lambda (procedure arguments message code port)
     (##raise-io-exception
      port
      (cond ((##fx= code ##err-code-ENOENT)
             (macro-make-no-such-file-or-directory-exception procedure arguments))
            ((##fx= code ##err-code-EEXIST)
             (macro-make-file-exists-exception procedure arguments))
            ((##fx= code ##err-code-EACCES)
             (macro-make-permission-denied-exception procedure arguments))
            (else
             (macro-make-os-exception procedure arguments message code)))))))

(define-prim (##raise-io-exception port exc)
  (let ((handler (macro-port-io-exception-handler port)))
    (if (##procedure? handler)
        (handler exc)
        (macro-raise exc))))

(define-prim (file-error? obj)
  (or (macro-no-such-file-or-directory-exception? obj)
      (macro-file-exists-exception? obj)
      (macro-permission-denied-exception? obj)))

;;;----------------------------------------------------------------------------

;;; Define type checking procedures.

(define-fail-check-type settings
  'settings)

(define-fail-check-type tls-version
  'tls-version)

(define-fail-check-type tls-options
  'tls-options)

(define-fail-check-type exact-integer-or-string-or-settings
  'exact-integer-or-string-or-settings)

(define-fail-check-type string-or-ip-address
  'string-or-ip-address)

;;;----------------------------------------------------------------------------

;;; Implementation of write environments.

(define-prim (##make-writeenv
              style
              port
              readtable
              marktable
              force?
              width
              shift
              close-parens
              level
              limit
              max-unescaped-char)
  (macro-make-writeenv
   style
   port
   readtable
   marktable
   force?
   width
   shift
   close-parens
   level
   limit
   max-unescaped-char))

;;;----------------------------------------------------------------------------

;;; Implementation of read environments.

(define-prim (##make-readenv
              port
              readtable
              wrapper
              unwrapper
              allow-script?
              case-conversion?
              read-cont)
  (macro-make-readenv
   port
   readtable
   wrapper
   unwrapper
   allow-script?
   (if (##eq? case-conversion? '()) ;; default to readtable?
       (macro-readtable-case-conversion? readtable)
       case-conversion?)
   (##make-table-aux)
   #f
   0
   read-cont))

(define-prim (##readenv-current-filepos re)
  (##readenv-relative-filepos re 0))

(define-prim (##readenv-relative-filepos re offset)
  (let* ((port
          (macro-readenv-port re))
         (line
          (macro-character-port-rlines port))
         (char-count
          (##fx- (##fx+ (macro-character-port-rchars port)
                        (macro-character-port-rlo port))
                 offset))
         (col
          (##fx- char-count
                 (macro-character-port-rcurline port))))
    (##make-filepos line col char-count)))

;;;----------------------------------------------------------------------------

;;; Implementation of port settings.

(define-prim (##make-psettings
              direction
              allowed-settings
              settings
              fail
              succeed)
  (let ((psettings
         (macro-make-psettings
          direction
          (macro-make-psettings-options
           (macro-default-readtable)
           (macro-default-char-encoding)
           (macro-default-char-encoding-errors)
           (macro-default-eol-encoding)
           (macro-default-buffering)
           (macro-default-permanent-close))
          (macro-make-psettings-options
           (macro-default-readtable)
           (macro-default-char-encoding-errors)
           (macro-default-char-encoding)
           (macro-default-eol-encoding)
           (macro-default-buffering)
           (macro-default-permanent-close))
          (macro-default-path)
          (macro-default-init)
          (macro-default-arguments)
          (macro-default-environment)
          (macro-default-directory)
          (macro-default-append)
          (macro-default-create)
          (macro-default-truncate)
          (macro-default-permissions)
          (macro-default-output-width)
          (macro-default-stdin-redir)
          (macro-default-stdout-redir)
          (macro-default-stderr-redir)
          (macro-default-pseudo-term)
          (macro-default-show-console)
          '() ;; address
          '() ;; port-number
          '() ;; local-address
          '() ;; local-port-number
          (macro-default-coalesce)
          (macro-default-keep-alive)
          (macro-default-backlog)
          (macro-default-reuse-address)
          (macro-default-broadcast)
          (macro-default-ignore-hidden)
          (macro-default-tls-context))))
    (##parse-psettings!
     allowed-settings
     settings
     psettings
     fail
     succeed)))

(define-prim (##parse-psettings!
              allowed-settings
              settings
              psettings
              fail
              succeed)

  (define (error name)
    (fail))

  (define (error-improper-list)
    (fail))

  (define (direction value)
    (cond ((##eq? value 'input)
           (macro-direction-in))
          ((##eq? value 'output)
           (macro-direction-out))
          ((##eq? value 'input-output)
           (macro-direction-inout))
          (else
           #f)))

  (define (readtable value)
    (cond ((macro-readtable? value)
           value)
          (else
           #f)))

  (define (char-encoding value)
    (cond ((##eq? value 'ASCII)
           (macro-char-encoding-ASCII))
          ((##eq? value 'ISO-8859-1)
           (macro-char-encoding-ISO-8859-1))
          ((##eq? value 'UTF-8)
           (macro-char-encoding-UTF-8))
          ((##eq? value 'UTF-16)
           (macro-char-encoding-UTF-16))
          ((##eq? value 'UTF-16LE)
           (macro-char-encoding-UTF-16LE))
          ((##eq? value 'UTF-16BE)
           (macro-char-encoding-UTF-16BE))
          ((##eq? value 'UTF)
           (macro-char-encoding-UTF))
          ((##eq? value 'UTF-fallback-ASCII)
           (macro-char-encoding-UTF-fallback-ASCII))
          ((##eq? value 'UTF-fallback-ISO-8859-1)
           (macro-char-encoding-UTF-fallback-ISO-8859-1))
          ((##eq? value 'UTF-fallback-UTF-8)
           (macro-char-encoding-UTF-fallback-UTF-8))
          ((##eq? value 'UTF-fallback-UTF-16)
           (macro-char-encoding-UTF-fallback-UTF-16))
          ((##eq? value 'UTF-fallback-UTF-16LE)
           (macro-char-encoding-UTF-fallback-UTF-16LE))
          ((##eq? value 'UTF-fallback-UTF-16BE)
           (macro-char-encoding-UTF-fallback-UTF-16BE))
          ((##eq? value 'UCS-2)
           (macro-char-encoding-UCS-2))
          ((##eq? value 'UCS-2LE)
           (macro-char-encoding-UCS-2LE))
          ((##eq? value 'UCS-2BE)
           (macro-char-encoding-UCS-2BE))
          ((##eq? value 'UCS-4)
           (macro-char-encoding-UCS-4))
          ((##eq? value 'UCS-4LE)
           (macro-char-encoding-UCS-4LE))
          ((##eq? value 'UCS-4BE)
           (macro-char-encoding-UCS-4BE))
;;;          ((##eq? value 'wchar)
;;;           (macro-char-encoding-wchar))
;;;          ((##eq? value 'native)
;;;           (macro-char-encoding-native))
          (else
           #f)))

  (define (char-encoding-errors value)
    (cond ((##eq? value #t)
           (macro-char-encoding-errors-on))
          ((##eq? value #f)
           (macro-char-encoding-errors-off))
          (else
           #f)))

  (define (eol-encoding value)
    (cond ((##eq? value 'lf)
           (macro-eol-encoding-lf))
          ((##eq? value 'cr)
           (macro-eol-encoding-cr))
          ((##eq? value 'cr-lf)
           (macro-eol-encoding-crlf))
          (else
           #f)))

  (define (buffering value)
    (cond ((##eq? value #t)
           (macro-full-buffering))
          ((##eq? value 'line)
           (macro-line-buffering))
          ((##eq? value #f)
           (macro-no-buffering))
          (else
           #f)))

  (define (permanent-close value)
    (cond ((##eq? value #t)
           (macro-permanent-close))
          ((##eq? value #f)
           (macro-no-permanent-close))
          (else
           #f)))

  (define (path value)
    value)

  (define (init value)
    value)

  (define (arguments value)
    (##copy-string-list value))

  (define (environment value)
    (cond ((##not value)
           value)
          (else
           (##copy-string-list value))))

  (define (directory value)
    value)

  (define (append-flag value)
    (cond ((##eq? (macro-psettings-direction psettings)
                  (macro-direction-in))
           #f)
          (value
           (macro-append))
          (else
           (macro-no-append))))

  (define (create-flag value)
    (cond ((##eq? (macro-psettings-direction psettings)
                  (macro-direction-in))
           #f)
          ((##eq? value #f)
           (macro-no-create))
          ((##eq? value 'maybe)
           (macro-maybe-create))
          ((##eq? value #t)
           (macro-create))
          (else
           #f)))

  (define (truncate-flag value)
    (cond ((##eq? (macro-psettings-direction psettings)
                  (macro-direction-in))
           #f)
          (value
           (macro-truncate))
          (else
           (macro-no-truncate))))

  (define (permissions value)
    (cond ((##eq? (macro-psettings-direction psettings)
                  (macro-direction-in))
           #f)
          ((and (##fixnum? value)
                (##not (##fx< value 0))
                (##fx< value #o1000))
           value)
          (else
           #f)))

  (define (output-width value)
    (cond ((##eq? (macro-psettings-direction psettings)
                  (macro-direction-in))
           #f)
          ((and (##fixnum? value)
                (##fx< 0 value))
           value)
          (else
           #f)))

  (define (stdin-redir value)
    (cond ((##eq? value #t)
           (macro-stdin-from-port))
          ((##eq? value #f)
           (macro-stdin-unchanged))
          (else
           #f)))

  (define (stdout-redir value)
    (cond ((##eq? value #t)
           (macro-stdout-to-port))
          ((##eq? value #f)
           (macro-stdout-unchanged))
          (else
           #f)))

  (define (stderr-redir value)
    (cond ((##eq? value #t)
           (macro-stderr-to-port))
          ((##eq? value #f)
           (macro-stderr-unchanged))
          (else
           #f)))

  (define (pseudo-term value)
    (cond ((##eq? value #t)
           (macro-pseudo-term))
          ((##eq? value #f)
           (macro-no-pseudo-term))
          (else
           #f)))

  (define (show-console value)
    (cond ((##eq? value #t)
           (macro-show-console))
          ((##eq? value #f)
           (macro-no-show-console))
          (else
           #f)))

  (define (port-number value)
    (cond ((and (##fixnum? value)
                (##fx<= 0 value)
                (##fx<= value 65535))
           value)
          (else
           #f)))

  (define (coalesce value)
    (cond ((##eq? value #t)
           (macro-coalesce))
          ((##eq? value #f)
           (macro-no-coalesce))
          (else
           #f)))

  (define (keep-alive value)
    (cond ((##eq? value #t)
           (macro-keep-alive))
          ((##eq? value #f)
           (macro-no-keep-alive))
          (else
           #f)))

  (define (backlog value)
    (if (and (##fixnum? value)
             (##not (##fx< value 0)))
        value
        #f))

  (define (reuse-address value)
    (cond ((##eq? value #t)
           (macro-reuse-address))
          ((##eq? value #f)
           (macro-no-reuse-address))
          (else
           #f)))

  (define (broadcast value)
    (cond ((##eq? value #t)
           (macro-broadcast))
          ((##eq? value #f)
           (macro-no-broadcast))
          (else
           #f)))

  (define (ignore-hidden value)
    (cond ((##eq? (macro-psettings-direction psettings)
                  (macro-direction-out))
           #f)
          ((##eq? value #t)
           (macro-ignore-hidden))
          ((##eq? value #f)
           (macro-ignore-nothing))
          ((##eq? value 'dot-and-dot-dot)
           (macro-ignore-dot-and-dot-dot))
          (else
           #f)))

  (define (tls-context value)
    (if (##foreign? value)
        value
        #f))

  (let loop ((lst settings))
    (macro-force-vars (lst)
      (cond ((##pair? lst)
             (let ((name (##car lst))
                   (rest1 (##cdr lst)))
               (macro-force-vars (name rest1)
                 (if (and (##memq name allowed-settings)
                          (##pair? rest1))

                     (let ((value (##car rest1))
                           (rest2 (##cdr rest1)))
                       (macro-force-vars (value)

                         (cond ((##eq? name 'direction:)
                                (let ((x (direction value)))
                                  (if x
                                      (begin
                                        (macro-psettings-direction-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((and (##eq? name 'input-readtable:)
                                     (##not
                                      (##eq?
                                       (macro-psettings-direction psettings)
                                       (macro-direction-out))))
                                (let ((x (readtable value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-readtable-set!
                                         (macro-psettings-roptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((and (##eq? name 'output-readtable:)
                                     (##not
                                      (##eq?
                                       (macro-psettings-direction psettings)
                                       (macro-direction-in))))
                                (let ((x (readtable value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-readtable-set!
                                         (macro-psettings-woptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'readtable:)
                                (let ((x (readtable value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-readtable-set!
                                         (macro-psettings-roptions psettings)
                                         x)
                                        (macro-psettings-options-readtable-set!
                                         (macro-psettings-woptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((and (##eq? name 'input-char-encoding:)
                                     (##not
                                      (##eq?
                                       (macro-psettings-direction psettings)
                                       (macro-direction-out))))
                                (let ((x (char-encoding value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-char-encoding-set!
                                         (macro-psettings-roptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((and (##eq? name 'output-char-encoding:)
                                     (##not
                                      (##eq?
                                       (macro-psettings-direction psettings)
                                       (macro-direction-in))))
                                (let ((x (char-encoding value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-char-encoding-set!
                                         (macro-psettings-woptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'char-encoding:)
                                (let ((x (char-encoding value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-char-encoding-set!
                                         (macro-psettings-roptions psettings)
                                         x)
                                        (macro-psettings-options-char-encoding-set!
                                         (macro-psettings-woptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((and (##eq? name 'input-char-encoding-errors:)
                                     (##not
                                      (##eq?
                                       (macro-psettings-direction psettings)
                                       (macro-direction-out))))
                                (let ((x (char-encoding-errors value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-char-encoding-errors-set!
                                         (macro-psettings-roptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((and (##eq? name 'output-char-encoding-errors:)
                                     (##not
                                      (##eq?
                                       (macro-psettings-direction psettings)
                                       (macro-direction-in))))
                                (let ((x (char-encoding-errors value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-char-encoding-errors-set!
                                         (macro-psettings-woptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'char-encoding-errors:)
                                (let ((x (char-encoding-errors value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-char-encoding-errors-set!
                                         (macro-psettings-roptions psettings)
                                         x)
                                        (macro-psettings-options-char-encoding-errors-set!
                                         (macro-psettings-woptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((and (##eq? name 'input-eol-encoding:)
                                     (##not
                                      (##eq?
                                       (macro-psettings-direction psettings)
                                       (macro-direction-out))))
                                (let ((x (eol-encoding value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-eol-encoding-set!
                                         (macro-psettings-roptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((and (##eq? name 'output-eol-encoding:)
                                     (##not
                                      (##eq?
                                       (macro-psettings-direction psettings)
                                       (macro-direction-in))))
                                (let ((x (eol-encoding value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-eol-encoding-set!
                                         (macro-psettings-woptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'eol-encoding:)
                                (let ((x (eol-encoding value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-eol-encoding-set!
                                         (macro-psettings-roptions psettings)
                                         x)
                                        (macro-psettings-options-eol-encoding-set!
                                         (macro-psettings-woptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((and (##eq? name 'input-buffering:)
                                     (##not
                                      (##eq?
                                       (macro-psettings-direction psettings)
                                       (macro-direction-out))))
                                (let ((x (buffering value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-buffering-set!
                                         (macro-psettings-roptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((and (##eq? name 'output-buffering:)
                                     (##not
                                      (##eq?
                                       (macro-psettings-direction psettings)
                                       (macro-direction-in))))
                                (let ((x (buffering value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-buffering-set!
                                         (macro-psettings-woptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'buffering:)
                                (let ((x (buffering value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-buffering-set!
                                         (macro-psettings-roptions psettings)
                                         x)
                                        (macro-psettings-options-buffering-set!
                                         (macro-psettings-woptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'permanent-close:)
                                (let ((x (permanent-close value)))
                                  (if x
                                      (begin
                                        (macro-psettings-options-permanent-close-set!
                                         (macro-psettings-roptions psettings)
                                         x)
                                        (macro-psettings-options-permanent-close-set!
                                         (macro-psettings-woptions psettings)
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'path:)
                                (let ((x (path value)))
                                  (if x
                                      (begin
                                        (macro-psettings-path-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'init:)
                                (let ((x (init value)))
                                  (if x
                                      (begin
                                        (macro-psettings-init-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'arguments:)
                                (let ((x (arguments value)))
                                  (if (##fixnum? x)
                                      (error name)
                                      (begin
                                        (macro-psettings-arguments-set!
                                         psettings
                                         x)
                                        (loop rest2)))))

                               ((##eq? name 'environment:)
                                (let ((x (environment value)))
                                  (if (##fixnum? x)
                                      (error name)
                                      (begin
                                        (macro-psettings-environment-set!
                                         psettings
                                         x)
                                        (loop rest2)))))

                               ((##eq? name 'directory:)
                                (let ((x (directory value)))
                                  (if (##fixnum? x)
                                      (error name)
                                      (begin
                                        (macro-psettings-directory-set!
                                         psettings
                                         x)
                                        (loop rest2)))))

                               ((##eq? name 'append:)
                                (let ((x (append-flag value)))
                                  (if x
                                      (begin
                                        (macro-psettings-append-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'create:)
                                (let ((x (create-flag value)))
                                  (if x
                                      (begin
                                        (macro-psettings-create-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'truncate:)
                                (let ((x (truncate-flag value)))
                                  (if x
                                      (begin
                                        (macro-psettings-truncate-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'permissions:)
                                (let ((x (permissions value)))
                                  (if x
                                      (begin
                                        (macro-psettings-permissions-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'output-width:)
                                (let ((x (output-width value)))
                                  (if x
                                      (begin
                                        (macro-psettings-output-width-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'stdin-redirection:)
                                (let ((x (stdin-redir value)))
                                  (if x
                                      (begin
                                        (macro-psettings-stdin-redir-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'stdout-redirection:)
                                (let ((x (stdout-redir value)))
                                  (if x
                                      (begin
                                        (macro-psettings-stdout-redir-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'stderr-redirection:)
                                (let ((x (stderr-redir value)))
                                  (if x
                                      (begin
                                        (macro-psettings-stderr-redir-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'pseudo-terminal:)
                                (let ((x (pseudo-term value)))
                                  (if x
                                      (begin
                                        (macro-psettings-pseudo-term-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'show-console:)
                                (let ((x (show-console value)))
                                  (if x
                                      (begin
                                        (macro-psettings-show-console-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((or (##eq? name 'server-address:) ;; keep for backward compatibility
                                    (##eq? name 'address:)
                                    (##eq? name 'local-address:))
                                (cond ((##string? value)
                                       (let ((address-and-port-number
                                              (##string->address-and-port-number
                                               value)))
                                         (if address-and-port-number
                                             (let ((address
                                                    (##car
                                                     address-and-port-number))
                                                   (port-number
                                                    (##cdr
                                                     address-and-port-number)))
                                               (if (##eq? name 'local-address:)
                                                   (macro-psettings-local-address-set!
                                                    psettings
                                                    address)
                                                   (macro-psettings-address-set!
                                                    psettings
                                                    address))
                                               (if (##not (##null? port-number))
                                                   (if (##eq? name 'local-address:)
                                                       (macro-psettings-local-port-number-set!
                                                        psettings
                                                        port-number)
                                                       (macro-psettings-port-number-set!
                                                        psettings
                                                        port-number)))
                                               (loop rest2))
                                             (error name))))
                                      ((##ip-address? value)
                                       (if (##eq? name 'local-address:)
                                           (macro-psettings-local-address-set!
                                            psettings
                                            value)
                                           (macro-psettings-address-set!
                                            psettings
                                            value))
                                       (loop rest2))
                                      (else
                                       (error name))))

                               ((or (##eq? name 'port-number:)
                                    (##eq? name 'local-port-number:))
                                (let ((x (port-number value)))
                                  (if x
                                      (begin
                                        (if (##eq? name 'local-port-number:)
                                            (macro-psettings-local-port-number-set!
                                             psettings
                                             x)
                                            (macro-psettings-port-number-set!
                                             psettings
                                             x))
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'coalesce:)
                                (let ((x (coalesce value)))
                                  (if x
                                      (begin
                                        (macro-psettings-coalesce-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'keep-alive:)
                                (let ((x (keep-alive value)))
                                  (if x
                                      (begin
                                        (macro-psettings-keep-alive-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'backlog:)
                                (let ((x (backlog value)))
                                  (if x
                                      (begin
                                        (macro-psettings-backlog-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'reuse-address:)
                                (let ((x (reuse-address value)))
                                  (if x
                                      (begin
                                        (macro-psettings-reuse-address-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'broadcast:)
                                (let ((x (broadcast value)))
                                  (if x
                                      (begin
                                        (macro-psettings-broadcast-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))

                               ((##eq? name 'ignore-hidden:)
                                (let ((x (ignore-hidden value)))
                                  (if x
                                      (begin
                                        (macro-psettings-ignore-hidden-set!
                                         psettings
                                         x)
                                        (loop rest2))
                                      (error name))))
                               ((##eq? name 'tls-context:)
                                (macro-psettings-tls-context-set!
                                 psettings
                                 (tls-context value))
                                (loop rest2))

                               (else
                                (error name)))))

                     (error name)))))

            ((##null? lst)
             (succeed psettings))

            (else
             (error-improper-list))))))

(##define-macro (macro-stream-options-output-shift) 15)
(##define-macro (macro-stream-options-input-mask) 32767)

(define-prim (##psettings->roptions psettings default-options)
  (##psettings-options->options
   (macro-psettings-roptions psettings)
   (##fxand
    default-options
    (macro-stream-options-input-mask))))

(define-prim (##psettings->woptions psettings default-options)
  (##psettings-options->options
   (macro-psettings-woptions psettings)
   (##fxwraplogical-shift-right
    default-options
    (macro-stream-options-output-shift))))

(define-prim (##psettings->input-readtable psettings)
  (or (macro-psettings-options-readtable
       (macro-psettings-roptions psettings))
      (##current-readtable)))

(define-prim (##psettings->output-readtable psettings)
  (or (macro-psettings-options-readtable
       (macro-psettings-woptions psettings))
      (##current-readtable)))

(define-prim (##psettings-options->options options default-options)
  (let ((permanent-close
         (macro-psettings-options-permanent-close options))
        (buffering
         (macro-psettings-options-buffering options))
        (eol-encoding
         (macro-psettings-options-eol-encoding options))
        (char-encoding
         (macro-psettings-options-char-encoding options))
        (char-encoding-errors
         (macro-psettings-options-char-encoding-errors options)))
    (##fx+
     (##fx+
      (##fxarithmetic-shift-left
       (if (##fx= char-encoding (macro-default-char-encoding))
           (##fxarithmetic-shift-right
            (##fxand
             default-options
             (macro-char-encoding-mask))
            (macro-char-encoding-shift))
           char-encoding)
       (macro-char-encoding-shift))
      (##fxarithmetic-shift-left
       (if (##fx= char-encoding-errors (macro-default-char-encoding-errors))
           (##fxarithmetic-shift-right
            (##fxand
             default-options
             (macro-char-encoding-errors-mask))
            (macro-char-encoding-errors-shift))
           char-encoding-errors)
       (macro-char-encoding-errors-shift))
      (##fx+
       (##fx+
        (##fxarithmetic-shift-left
         (if (##fx= eol-encoding (macro-default-eol-encoding))
             (##fxarithmetic-shift-right
              (##fxand
               default-options
               (macro-eol-encoding-mask))
              (macro-eol-encoding-shift))
             eol-encoding)
         (macro-eol-encoding-shift))
        (##fx+
         (##fxand
          default-options
          (macro-open-state-mask))
         (##fx+
          (##fxarithmetic-shift-left
           permanent-close
           (macro-permanent-close-shift))
          (##fxarithmetic-shift-left
           (if (##fx= buffering (macro-default-buffering))
               (##fxarithmetic-shift-right
                (##fxand
                 default-options
                 (macro-buffering-mask))
                (macro-buffering-shift))
               buffering)
           (macro-buffering-shift))))))))))

(define-prim (##psettings->device-flags psettings)
  (let ((direction
         (macro-psettings-direction psettings))
        (append
         (macro-psettings-append psettings))
        (create
         (macro-psettings-create psettings))
        (truncate
         (macro-psettings-truncate psettings)))
    (##fx+
     (##fxarithmetic-shift-left
      direction
      (macro-direction-shift))
     (##fx+
      (##fxarithmetic-shift-left
       (if (##not (##fx= append (macro-default-append)))
           append
           (macro-no-append))
       (macro-append-shift))
      (##fx+
       (##fxarithmetic-shift-left
        (cond ((##not (##fx= create (macro-default-create)))
               create)
              ((##fx= direction (macro-direction-out))
               (macro-maybe-create))
              (else
               (macro-no-create)))
        (macro-create-shift))
       (##fxarithmetic-shift-left
        (cond ((##not (##fx= truncate (macro-default-truncate)))
               truncate)
              ((##fx= direction (macro-direction-out))
               (if (##fx= append (macro-append))
                   (macro-no-truncate)
                   (macro-truncate)))
              (else
               (macro-no-truncate)))
        (macro-truncate-shift)))))))

(define-prim (##psettings->permissions psettings default-permissions)
  (let ((permissions (macro-psettings-permissions psettings)))
    (if (##not (##fx= permissions (macro-default-permissions)))
        permissions
        default-permissions)))

(define-prim (##psettings->output-width psettings #!optional (default 80))
  (let ((output-width (macro-psettings-output-width psettings)))
    (if (##fx= output-width (macro-default-output-width))
        default
        output-width)))

;;;----------------------------------------------------------------------------

;;; Implementation of port type checking.

(define-prim (##port? obj)
  (macro-port? obj))

(define-prim (port? obj)
  (macro-force-vars (obj)
    (macro-port? obj)))

(define-prim (##input-port? obj)
  (macro-input-port? obj))

(define-prim (input-port? obj)
  (macro-force-vars (obj)
    (macro-input-port? obj)))

(define-prim (##output-port? obj)
  (macro-output-port? obj))

(define-prim (output-port? obj)
  (macro-force-vars (obj)
    (macro-output-port? obj)))

(define-prim (textual-port? obj)
  (macro-force-vars (obj)
    (macro-character-port? obj)))

(define-prim (binary-port? obj)
  (macro-force-vars (obj)
    (macro-byte-port? obj)))

(implement-check-type-port)
(define-fail-check-type input-port 'input-port)
(define-fail-check-type output-port 'output-port)
(define-fail-check-type object-input-port 'object-input-port)
(define-fail-check-type object-output-port 'object-output-port)
(define-fail-check-type character-input-port 'character-input-port)
(define-fail-check-type character-output-port 'character-output-port)
(define-fail-check-type byte-port 'byte-port)
(define-fail-check-type byte-input-port 'byte-input-port)
(define-fail-check-type byte-output-port 'byte-output-port)
(define-fail-check-type device-input-port 'device-input-port)
(define-fail-check-type device-output-port 'device-output-port)

;;;----------------------------------------------------------------------------

;;; I/O condition variables.

(define-macro (macro-io-condvar-for-reading) 0)
(define-macro (macro-io-condvar-for-writing) 2)
(define-macro (macro-io-condvar-for-event)   4)

(define-prim (##make-io-condvar name kind)
  (let ((cv (##make-condvar name)))
    (macro-btq-owner-set! cv kind)
    cv))

(define-prim (##make-io-condvar-for-reading name)
  (##make-io-condvar name (macro-io-condvar-for-reading)))

(define-prim (##make-io-condvar-for-writing name)
  (##make-io-condvar name (macro-io-condvar-for-writing)))

(define-prim (##make-io-condvar-for-event name)
  (##make-io-condvar name (macro-io-condvar-for-event)))

(define-prim (##io-condvar? cv)
  (##fixnum? (macro-btq-owner cv)))

(define-prim (##io-condvar-port cv)
  (macro-condvar-specific cv))

(define-prim (##io-condvar-port-set! cv port)
  (macro-condvar-specific-set! cv port))

;;;----------------------------------------------------------------------------

;;; Implementation of dummy ports.

(define-prim (##make-dummy-port)
  (let* ((mutex
          #f)
         (rkind
          (macro-object-kind))
         (wkind
          (macro-object-kind))
         (roptions
          0)
         (rtimeout
          #t)
         (rtimeout-thunk
          #f)
         (woptions
          0)
         (wtimeout
          #t)
         (wtimeout-thunk
          #f))

    (define (name port)
      'dummy)

    (define (wait port direction)
      #t)

    (define (read-datum port re)
      #!eof)

    (define (write-datum port obj we)
      (##void))

    (define (newline port)
      (##void))

    (define (force-output port level prim arg1 arg2 arg3 arg4)
      (##void))

    (define (close port prim arg1)
      (##void))

    (define (set-rtimeout port timeout thunk)
      (##void))

    (define (set-wtimeout port timeout thunk)
      (##void))

    (macro-make-object-port
     mutex
     rkind
     wkind
     name
     wait
     close
     roptions
     rtimeout
     rtimeout-thunk
     set-rtimeout
     woptions
     wtimeout
     wtimeout-thunk
     set-wtimeout
     #f ;; io-exception-handler
     read-datum
     write-datum
     newline
     force-output
     )))

(define-prim (##open-dummy)
  (##make-dummy-port))

(define-prim (open-dummy)
  (##make-dummy-port))

;;;----------------------------------------------------------------------------

;; Function to determine appropriate character buffer length.

(define-prim (##port-char-buf-len kind unbuffered?)
  (if unbuffered?
      1
      (if (##fx= kind (macro-u8vector-kind))
          32
          512)))

;;;----------------------------------------------------------------------------

;;; Implementation of device ports.

(define-prim (##make-device-port device-name rdevice wdevice psettings)

  (define byte-buf-len 1024) ;; byte buffer length

  (let* ((mutex
          (macro-make-port-mutex))
         (rkind
          (if rdevice
              (##os-device-kind rdevice)
              (macro-none-kind)))
         (wkind
          (if wdevice
              (##os-device-kind wdevice)
              (macro-none-kind)))
         (roptions
          (if (##fx= rkind (macro-none-kind))
              0
              (##psettings->roptions
               psettings
               (##os-device-stream-default-options rdevice))))
         (rtimeout
          #t)
         (rtimeout-thunk
          #f)
         (woptions
          (if (##fx= wkind (macro-none-kind))
              0
              (##psettings->woptions
               psettings
               (##os-device-stream-default-options wdevice))))
         (wtimeout
          #t)
         (wtimeout-thunk
          #f)
         (char-rbuf
          (and (##not (##fx= rkind (macro-none-kind)))
               (##make-string
                (##port-char-buf-len rkind (macro-unbuffered? roptions)))))
         (char-rlo
          0)
         (char-rhi
          0)
         (char-rchars
          0)
         (char-rlines
          0)
         (char-rcurline
          0)
         (char-rbuf-fill
          ##char-rbuf-fill)
         (char-peek-eof?
          #f)
         (char-wbuf
          (and (##not (##fx= wkind (macro-none-kind)))
               (##make-string
                (##port-char-buf-len wkind (macro-unbuffered? woptions)))))
         (char-wlo
          0)
         (char-whi
          0)
         (char-wchars
          0)
         (char-wlines
          0)
         (char-wcurline
          0)
         (char-wbuf-drain
          ##char-wbuf-drain)
         (input-readtable
          (##psettings->input-readtable psettings))
         (output-readtable
          (##psettings->output-readtable psettings))
         (byte-rbuf
          (and (##not (##fx= rkind (macro-none-kind)))
               (##make-u8vector byte-buf-len)))
         (byte-rlo
          0)
         (byte-rhi
          0)
         (byte-rbuf-fill
          ##byte-rbuf-fill)
         (byte-wbuf
          (and (##not (##fx= wkind (macro-none-kind)))
               (##make-u8vector byte-buf-len)))
         (byte-wlo
          0)
         (byte-whi
          0)
         (byte-wbuf-drain
          ##byte-wbuf-drain)
         (rdevice-condvar
          (and (##not (##fx= rkind (macro-none-kind)))
               (##make-io-condvar-for-reading rdevice)))
         (wdevice-condvar
          (and (##not (##fx= wkind (macro-none-kind)))
               (##make-io-condvar-for-writing wdevice)))
         (event-condvar
          (cond ((##fx= rkind (macro-process-kind))
                 (##make-io-condvar-for-event rdevice))
                ((##fx= wkind (macro-process-kind))
                 (##make-io-condvar-for-event wdevice))
                (else
                 #f))))

    (define (name port)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-device-port-name port))

    (define (wait port direction)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##wait-device port direction))

    (define (read-datum port re)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##read-datum-or-eof re))

    (define (write-datum port obj we)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##wr we obj))

    (define (newline port)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-write-char #\newline port))

    (define (force-output port level prim arg1 arg2 arg3 arg4)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let ((code (force-output-aux port level #t)))
        (macro-port-mutex-unlock! port)
        (if (##fx< code 0)
            (##raise-os-io-exception port #f code prim arg1 arg2 arg3 arg4)
            (##void))))

    (define (force-output-aux port level block?)

      ;; It is assumed that the thread has exclusive access to the port.

      (##declare (not interrupts-enabled))

      (let ((code1 (drain-output port)))
        (if (##fixnum? code1)
            code1
            (let* ((wdevice-condvar (macro-device-port-wdevice-condvar port))
                   (code2 (##os-device-force-output wdevice-condvar level)))
              (cond ((##fx= code2 ##err-code-EINTR)

                     ;; the force was interrupted, so try again

                     (force-output-aux port level block?))

                    ((and block?
                          (##fx= code2 ##err-code-EAGAIN))

                     ;; the force would block, so wait and then try again

                     (macro-port-mutex-unlock! port)
                     (let ((continue?
                            (or (##wait-for-io!
                                 (macro-device-port-wdevice-condvar port)
                                 (macro-port-wtimeout port))
                                ((macro-port-wtimeout-thunk port)))))
                       (macro-port-mutex-lock! port) ;; regain access to port
                       (if continue?
                           (force-output-aux port level block?)
                           code2)))

                    (else
                     code2))))))

    (define (drain-output port)

      ;; It is assumed that the thread has exclusive access to the port.

      (##declare (not interrupts-enabled))

      (let ((code ((macro-character-port-wbuf-drain port) port)))
        (if (##fixnum? code)
            code
            ((macro-byte-port-wbuf-drain port) port))))

    (define (close port prim arg1)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let ((result (close-aux1 port prim)))
        (macro-port-mutex-unlock! port)
        (if (##fixnum? result)
            (##raise-os-io-exception port #f result prim arg1)
            result)))

    (define (close-aux1 port prim)

      ;; It is assumed that the thread has exclusive access to the port.

      (##declare (not interrupts-enabled))

      (if (or (##fx= (macro-port-wkind port) (macro-none-kind))
              (##eq? prim close-input-port))
          (close-aux2 port prim)
          (let ((code (force-output-aux port 0 #f)))
            (if (and (##fx< code 0)
                     (##not (##fx= code ##err-code-EAGAIN)))

                code

                ;; The close operation may have failed to force the output.
                ;; However the close operation is not allowed to block, so
                ;; we just continue and close the device.  The user can make
                ;; sure that the output is forced by calling force-output
                ;; (which can block) before calling close-port.

                (close-aux2 port prim)))))

    (define (close-aux2 port prim)

      ;; It is assumed that the thread has exclusive access to the port.

      (##declare (not interrupts-enabled))

      (##close-device
       port
       (macro-device-port-rdevice-condvar port)
       (macro-device-port-wdevice-condvar port)
       prim))

    (define (set-rtimeout port timeout thunk)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (macro-port-rtimeout-set! port timeout)
      (macro-port-rtimeout-thunk-set! port thunk)
      (##condvar-signal-no-reschedule!
       (macro-device-port-rdevice-condvar port)
       #t)
      (macro-port-mutex-unlock! port)
      (##void))

    (define (set-wtimeout port timeout thunk)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (macro-port-wtimeout-set! port timeout)
      (macro-port-wtimeout-thunk-set! port thunk)
      (##condvar-signal-no-reschedule!
       (macro-device-port-wdevice-condvar port)
       #t)
      (macro-port-mutex-unlock! port)
      (##void))

    (define (output-width port)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let loop ()

        (let* ((wdevice-condvar (macro-device-port-wdevice-condvar port))
               (result (##os-device-stream-width wdevice-condvar)))
          (if (##fx= result ##err-code-EINTR)
              (loop)
              (begin
                (macro-port-mutex-unlock! port)
                (if (##fx< result 0)
                    (##raise-os-io-exception port #f result output-port-width port)
                    result))))))

    (let ((port
           (macro-make-device-port
            mutex
            rkind
            wkind
            name
            wait
            close
            roptions
            rtimeout
            rtimeout-thunk
            set-rtimeout
            woptions
            wtimeout
            wtimeout-thunk
            set-wtimeout
            #f ;; io-exception-handler
            read-datum
            write-datum
            newline
            force-output
            char-rbuf
            char-rlo
            char-rhi
            char-rchars
            char-rlines
            char-rcurline
            char-rbuf-fill
            char-peek-eof?
            char-wbuf
            char-wlo
            char-whi
            char-wchars
            char-wlines
            char-wcurline
            char-wbuf-drain
            input-readtable
            output-readtable
            (let ((width (##psettings->output-width psettings #f)))
              (if width
                  (lambda (port) width)
                  output-width))
            byte-rbuf
            byte-rlo
            byte-rhi
            byte-rbuf-fill
            byte-wbuf
            byte-wlo
            byte-whi
            byte-wbuf-drain
            rdevice-condvar
            wdevice-condvar
            event-condvar ;; only used for process ports
            device-name)))
      (if rdevice-condvar
          (##io-condvar-port-set! rdevice-condvar port))
      (if wdevice-condvar
          (##io-condvar-port-set! wdevice-condvar port))
      (if event-condvar
          (##io-condvar-port-set! event-condvar port))
      port)))

(define-prim (##make-device-port-from-single-device
              device-name
              device
              psettings)
  (let ((direction (macro-psettings-direction psettings)))
    (cond ((##fx= direction (macro-direction-in))
           (##make-device-port device-name
                               device
                               #f
                               psettings))
          ((##fx= direction (macro-direction-out))
           (##make-device-port device-name
                               #f
                               device
                               psettings))
          (else
           (##make-device-port device-name
                               device
                               device
                               psettings)))))

(define-prim (##wait-device port direction)

  ;; It is assumed that the thread **does not** have exclusive
  ;; access to the port.

  (##declare (not interrupts-enabled))

  (if (##fx= direction (macro-direction-in))

      (##wait-for-io!
       (macro-device-port-rdevice-condvar port)
       (macro-port-rtimeout port))

      (##wait-for-io!
       (macro-device-port-wdevice-condvar port)
       (macro-port-wtimeout port))))

(define-prim (##close-device port rdevice-condvar wdevice-condvar prim)

  (##declare (not interrupts-enabled))

  (let ((rdevice
         (if (##fx= (macro-port-rkind port) (macro-none-kind))
             #f
             (macro-condvar-name rdevice-condvar)))
        (wdevice
         (if (##fx= (macro-port-wkind port) (macro-none-kind))
             #f
             (macro-condvar-name wdevice-condvar))))
    (if (and (##eq? rdevice wdevice)
             (##eq? prim close-port))
        (let ((code1
               (##os-device-close rdevice (macro-direction-inout))))
          (if (##fx< code1 0)
              code1
              (##void)))
        (let ((code2
               (if (and rdevice
                        (##not (##eq? prim close-output-port)))
                   (##os-device-close rdevice (macro-direction-in))
                   0)))
          (if (##fx< code2 0)
              code2
              (let ((code3
                     (if (and wdevice
                              (##not (##eq? prim close-input-port)))
                         (##os-device-close wdevice (macro-direction-out))
                         0)))
                (if (##fx< code3 0)
                    code3
                    (##void))))))))

(define-prim (##input-port-byte-position
              port
              #!optional
              (position (macro-absent-obj))
              (whence (macro-absent-obj)))
  (let loop ()
    (let ((result
           (if (##eq? position (macro-absent-obj))
               (##os-device-stream-seek
                (macro-device-port-rdevice-condvar port)
                0
                1)
               (begin
                 (##flush-input-buffering port)
                 (##os-device-stream-seek
                  (macro-device-port-rdevice-condvar port)
                  position
                  (if (##eq? whence (macro-absent-obj)) 0 whence))))))
      (if (and (##fixnum? result)
               (##fx< result 0))
          (if (or (##fx= result ##err-code-EINTR)
                  (##fx= result ##err-code-EAGAIN))
              (loop)
              (##raise-os-io-exception
               port
               #f
               result
               input-port-byte-position
               port
               position
               whence))
          result))))

(define-prim (input-port-byte-position
              port
              #!optional
              (position (macro-absent-obj))
              (whence (macro-absent-obj)))
  (macro-force-vars (port position whence)
    (macro-check-device-input-port
      port
      1
      (input-port-byte-position port position whence)
      (cond ((##eq? position (macro-absent-obj))
             (##input-port-byte-position port))
            ((##not (macro-exact-int? position))
             (##fail-check-exact-integer 2 input-port-byte-position port position whence))
            ((##eq? whence (macro-absent-obj))
             (##input-port-byte-position port position))
            (else
             (macro-check-index-range-incl
               whence
               3
               0
               2
               (input-port-byte-position port position whence)
               (##input-port-byte-position port position whence)))))))

(define-prim (##output-port-byte-position
              port
              #!optional
              (position (macro-absent-obj))
              (whence (macro-absent-obj)))
  (let loop ()
    (let ((result
           (if (##eq? position (macro-absent-obj))
               (##os-device-stream-seek
                (macro-device-port-wdevice-condvar port)
                0
                1)
               (begin
                 (##force-output port)
                 (##os-device-stream-seek
                  (macro-device-port-wdevice-condvar port)
                  position
                  (if (##eq? whence (macro-absent-obj)) 0 whence))))))
      (if (and (##fixnum? result)
               (##fx< result 0))
          (if (or (##fx= result ##err-code-EINTR)
                  (##fx= result ##err-code-EAGAIN))
              (loop)
              (##raise-os-io-exception
               port
               #f
               result
               output-port-byte-position
               port
               position
               whence))
          result))))

(define-prim (output-port-byte-position
              port
              #!optional
              (position (macro-absent-obj))
              (whence (macro-absent-obj)))
  (macro-force-vars (port position whence)
    (macro-check-device-output-port
      port
      1
      (output-port-byte-position port position whence)
      (cond ((##eq? position (macro-absent-obj))
             (##output-port-byte-position port))
            ((##not (macro-exact-int? position))
             (##fail-check-exact-integer 2 output-port-byte-position port position whence))
            ((##eq? whence (macro-absent-obj))
             (##output-port-byte-position port position))
            (else
             (macro-check-index-range-incl
               whence
               3
               0
               2
               (output-port-byte-position port position whence)
               (##output-port-byte-position port position whence)))))))

;;;----------------------------------------------------------------------------

(define-prim (##char-rbuf-fill port want block?)

  ;; port is the character input-port
  ;; want is the number of characters that the caller wants (#f = max)
  ;; block? is a boolean indicating whether it is OK for the thread to block

  ;; This procedure returns one of the following values:
  ;;  - #t if characters were added to the char buffer,
  ;;  - #f if no character could be added to the char buffer (because
  ;;    end-of-file was reached),
  ;;  - fixnum indicating an error code (in particular, only if block?
  ;;    is false or there was a read timeout and the timeout thunk
  ;;    returned #f, ##err-code-EAGAIN is returned to indicate that no
  ;;    character was currently available).

  ;; It is assumed that the thread has exclusive access to the port.

  (##declare (not interrupts-enabled))

  (let loop ()

    ;; keep track of number of characters read

    (macro-character-port-rchars-set!
     port
     (##fx+ (macro-character-port-rchars port)
            (macro-character-port-rhi port)))

    (macro-character-port-rlo-set! port 0)
    (macro-character-port-rhi-set! port 0)

    ;; convert bytes from the byte buffer into characters in the char buffer

    (let* ((want
            (if (macro-unbuffered? (macro-port-roptions port))
                want
                #f))
           (code1
            (##os-port-decode-chars! port want #f)))

      (cond ((##not (##fx= code1 0))

             ;; an error occurred, return the error code to caller

             code1)

            ((##fx< (macro-character-port-rlo port)
                    (macro-character-port-rhi port))

             ;; characters were added to char buffer

             #t)

            (else

             ;; no characters were added to char buffer, so try to get
             ;; some more bytes

             (let ((code2 ((macro-byte-port-rbuf-fill port)
                           port
                           want ;; assumes chars are at least 1 byte long
                           block?)))

               (cond ((##fixnum? code2)

                      ;; an error occurred, return the error code to caller

                      code2)

                     (code2

                      ;; bytes were added to byte buffer, so try again
                      ;; to extract characters from the byte buffer

                      (loop))

                     (else

                      ;; no bytes were added to byte buffer
                      ;; (end-of-file was reached)

                      ;; The following call to ##os-port-decode-chars! will
                      ;; check that the byte buffer is empty.  If the
                      ;; buffer is not empty an error code is returned
                      ;; to indicate that the remaining bytes can't
                      ;; form a character, otherwise #f is returned.

                      (let ((code3 (##os-port-decode-chars! port want #t)))
                        (if (##fx= code3 0)
                            #f
                            code3))))))))))

(define-prim (##byte-rbuf-fill port want block?)

  ;; port is the byte input-port
  ;; want is the number of bytes that the caller wants (#f = max)
  ;; block? is a boolean indicating whether it is OK for the thread to block

  ;; This procedure returns one of the following values:
  ;;  - #t if bytes were added to the byte buffer,
  ;;  - #f if no byte could be added to the byte buffer (because
  ;;    end-of-file was reached),
  ;;  - fixnum indicating an error code (in particular, only if block?
  ;;    is false or there was a read timeout and the timeout thunk
  ;;    returned #f, ##err-code-EAGAIN is returned to indicate that no
  ;;    byte was currently available).

  ;; It is assumed that the thread has exclusive access to the port.

  (##declare (not interrupts-enabled))

  (let loop ()

    ;; shift bytes between rlo and rhi to beginning of buffer

    (let ((byte-rlo (macro-byte-port-rlo port))
          (byte-rhi (macro-byte-port-rhi port)))
      (if (##fx< byte-rlo byte-rhi)
          (let ((byte-rbuf (macro-byte-port-rbuf port)))
            (##subu8vector-move! byte-rbuf byte-rlo byte-rhi byte-rbuf 0)))
      (macro-byte-port-rlo-set! port 0)
      (macro-byte-port-rhi-set! port (##fx- byte-rhi byte-rlo)))

    ;; read into byte buffer at rhi

    (let* ((byte-rbuf
            (macro-byte-port-rbuf port))
           (byte-rhi
            (macro-byte-port-rhi port))
           (n
            (##os-device-stream-read
             (macro-device-port-rdevice-condvar port)
             byte-rbuf
             byte-rhi
             (let ((rbuf-len (##u8vector-length byte-rbuf)))
               (if (and want (macro-unbuffered? (macro-port-roptions port)))
                   (##fxmin (##fx+ byte-rhi want) rbuf-len)
                   rbuf-len)))))

      (if (##fx< n 0)

          ;; the read caused an error

          (cond ((##fx= n ##err-code-EINTR)

                 ;; the read was interrupted, so try again

                 (loop))

                ((and block?
                      (##fx= n ##err-code-EAGAIN))

                 ;; the read would block and it is OK to block so wait
                 ;; and then try again

                 (macro-port-mutex-unlock! port)
                 (let ((continue?
                        (or (##wait-for-io!
                             (macro-device-port-rdevice-condvar port)
                             (macro-port-rtimeout port))
                            ((macro-port-rtimeout-thunk port)))))
                   (macro-port-mutex-lock! port) ;; regain access to port
                   (if continue?
                       (loop)
                       n)))

                (else

                 ;; return the error code to the caller

                 n))

          ;; the read completed successfully

          (if (##fx= n 0) ;; was end-of-file reached?
              #f
              (begin
                (macro-byte-port-rhi-set! port
                                          (##fx+ (macro-byte-port-rhi port) n))
                #t))))))

(define-prim (##char-wbuf-drain-no-reset port)

  ;; This procedure returns #f when the char buffer was successfully
  ;; drained or it returns an error code (fixnum).  In particular,
  ;; only if there was a write timeout and the timeout thunk returned
  ;; #f, ##err-code-EAGAIN is returned to indicate that some chars
  ;; could not be written at this time.

  ;; It is assumed that the thread has exclusive access to the port.

  (##declare (not interrupts-enabled))

  (let loop ()

    ;; convert characters from char buffer into bytes in the byte buffer

    (let ((code1 (##os-port-encode-chars! port)))

      (cond ((##not (##fx= code1 0))

             ;; an error occurred, return the error code to caller

             code1)

            ((##fx< (macro-character-port-wlo port)
                    (macro-character-port-whi port))

             ;; the byte buffer is full, so drain it and continue
             ;; draining char buffer

             (let ((code2 ((macro-byte-port-wbuf-drain port) port)))

               (if (##fixnum? code2)

                   ;; an error occurred, return the error code to caller

                   code2

                   ;; the byte buffer was successfully drained, continue
                   ;; draining char buffer

                   (loop))))

            (else

             ;; the char buffer has been emptied

             #f)))))

(define-prim (##char-wbuf-drain port)

  ;; It is assumed that the thread has exclusive access to the port.

  (##declare (not interrupts-enabled))

  (or (##char-wbuf-drain-no-reset port)
      (begin
        (macro-character-port-wchars-set!
         port
         (##fx+ (macro-character-port-wchars port)
                (macro-character-port-whi port)))
        (macro-character-port-wlo-set! port 0)
        (macro-character-port-whi-set! port 0)
        #f)))

(define-prim (##byte-wbuf-drain-no-reset port)

  ;; This procedure returns #f when the byte buffer was successfully
  ;; drained or it returns an error code (fixnum).  In particular,
  ;; only if there was a write timeout and the timeout thunk returned
  ;; #f, ##err-code-EAGAIN is returned to indicate that no byte could
  ;; be written at this time.

  ;; It is assumed that the thread has exclusive access to the port.

  (##declare (not interrupts-enabled))

  (let loop ()

    (let ((byte-wlo (macro-byte-port-wlo port))
          (byte-whi (macro-byte-port-whi port)))
      (if (##fx< byte-wlo byte-whi)

          ;; the byte buffer is not empty, write content of byte buffer
          ;; from wlo to whi

          (let ((n
                 (##os-device-stream-write
                  (macro-device-port-wdevice-condvar port)
                  (macro-byte-port-wbuf port)
                  byte-wlo
                  byte-whi)))

            (if (##fx< n 0)

                ;; the write caused an error

                (cond ((##fx= n ##err-code-EINTR)

                       ;; the write was interrupted, so try again

                       (loop))

                      ((##fx= n ##err-code-EAGAIN)

                       ;; the write would block, so wait and then try again

                       (macro-port-mutex-unlock! port)
                       (let ((continue?
                              (or (##wait-for-io!
                                   (macro-device-port-wdevice-condvar port)
                                   (macro-port-wtimeout port))
                                  ((macro-port-wtimeout-thunk port)))))
                         (macro-port-mutex-lock! port) ;; regain access to port
                         (if continue?
                             (loop)
                             n)))

                      (else

                       ;; return the error code to the caller

                       n))

                ;; some bytes (possibly zero) were written, advance
                ;; wlo and try to write more

                (begin
                  (macro-byte-port-wlo-set! port
                                            (##fx+ (macro-byte-port-wlo port) n))
                  (loop))))

          ;; the byte buffer is empty

          #f))))

(define-prim (##byte-wbuf-drain port)

  ;; It is assumed that the thread has exclusive access to the port.

  (##declare (not interrupts-enabled))

  (or (##byte-wbuf-drain-no-reset port)
      (begin
        ;; the byte buffer is empty, reset wlo and whi
        (macro-byte-port-wlo-set! port 0)
        (macro-byte-port-whi-set! port 0)
        #f)))

;;;----------------------------------------------------------------------------

;;; Implementation of vector, string and u8vector ports.

(##define-macro (define-prim-vector-port-procedures
                  name
                  empty-vect
                  vect-zap!
                  drain-output
                  allowed-settings)

  ;; Vector ports (either actual vector, string or u8vector port) have a
  ;; representation that supports various functionality:
  ;;
  ;; - input-only port: data is obtained from an initial vector
  ;;
  ;; - output-only port: data is accumulated into a resulting vector
  ;;
  ;; - input-output port: data written to the port can be read
  ;;                      from the port in FIFO fashion
  ;;
  ;; - pipe port: each end of the pipe has a corresponding port and
  ;;              output on one port causes data to be available on
  ;;              the peer port (pipe ports can be unidirectional
  ;;              or bidirectional)
  ;;
  ;; For efficiency, the buffering of data in the port is implemented
  ;; as a list of limited-size chunks of data stored in a FIFO
  ;; structure.  Writing to the port stores data into the chunk at the
  ;; tail of the FIFO and reading from the port fetches data from the
  ;; chunk at the head of the FIFO.  This allows the garbage
  ;; collection of the data that has been read (at the granularity of
  ;; chunks) and it simplifies accumulating data that is written to
  ;; the port.  In the case of a pipe port, the FIFO is shared by the
  ;; port and its peer port (a bidirectional pipe port has 2
  ;; independent FIFOs).
  ;;
  ;; The read buffer of an input port (called rbuf) is the chunk at
  ;; the head of the FIFO.  The counters rlo and rhi delimit the
  ;; section of this chunk that contains data not yet read.  The write
  ;; buffer of an output port (called wbuf) is the last chunk in the
  ;; FIFO.  The counter whi indicates the point in the write buffer
  ;; where new data should be added.
  ;;
  ;; Note that in the case of a pipe port, rbuf, rlo and rhi are part
  ;; of the input port and the FIFO, wbuf and whi are part of the
  ;; peer's output port.  In the case of a non-pipe input-output port,
  ;; the "peer" is actually the port itself.  It is possible for rbuf
  ;; and wbuf to be the same chunk.  This happens when there is little
  ;; data left to read.
  ;;
  ;; As an example, for a string port created from the initial string
  ;; "abcdefghijklmnopqrstuvwxyz" and a chunk size of 10, once the port
  ;; is setup the structure will be:
  ;;
  ;;    __port__    __________________________peer__________________________
  ;;
  ;;                      +---------------------------------------+
  ;;                FIFO  |                                       v
  ;;                    +-|-+---+     +---+---+     +---+---+     +---+---+
  ;;                    |   |  -+---> |   |  -+---> |   |  -+---> |   | ()|
  ;;                    +---+---+     +-|-+---+     +-|-+---+     +-|-+---+
  ;;                                    v             v             v
  ;;    rbuf -------------------------> "abcdefghij"  "klmnopqrst"  "uvwxyz"
  ;;                                     ^         ^                ^      ^
  ;;    rlo -----------------------------+         |                |      |
  ;;    rhi ---------------------------------------+             wbuf    whi
  ;;
  ;; To write data, the wbuf is accessed at the index indicated by
  ;; whi.  If whi reaches the end of the chunk, a freshly allocated
  ;; chunk is added to the tail of the FIFO and this chunk becomes the
  ;; new wbuf and whi is set to 0.  To read data, the rbuf is accessed
  ;; at the index indicated by rlo and rlo is increased.  When more
  ;; data needs to be read than there is between rlo and rhi either
  ;;
  ;; - rbuf and wbuf are the same chunk: rhi is set to whi (this may
  ;;   allow the read to continue)
  ;;
  ;; - rbuf and wbuf are not the same chunk: the chunk at the head of
  ;;   the FIFO is removed, any data in rbuf between rlo and rhi is
  ;;   appended to the beginning of the next chunk and it becomes the
  ;;   new rbuf (if the FIFO is now empty and rlo != rhi then wbuf is
  ;;   also set to this chunk and rhi and whi are adjusted
  ;;   appropriately)

  (define (sym . lst)
    (string->symbol
     (apply string-append
            (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                 lst))))

  (let ((vector/character/byte
         (cond ((eq? name 'u8vector) 'byte)
               ((eq? name 'string)   'character)
               (else                 'vector))))

    (define vect-input-port
      (sym name '-input-port))

    (define vect-output-port
      (sym name '-output-port))

    (define vect-or-settings
      (sym name '-or-settings))

    (define macro-check-vect-output-port
      (sym 'macro-check- name '-output-port))

    (define ##fail-check-vect-or-settings
      (sym '##fail-check- name '-or-settings))

    (define ##fail-check-vect         (sym '##fail-check- name))
    (define ##make-vect               (sym '##make- name))
    (define ##vect?                   (sym "##" name '?))
    (define ##vect-ref                (sym "##" name '-ref))
    (define ##vect-set!               (sym "##" name '-set!))
    (define ##vect-length             (sym "##" name '-length))
    (define ##vect-shrink!            (sym "##" name '-shrink!))
    (define ##vect-append             (sym "##" name '-append))
    (define ##subvect                 (sym '##sub name))
    (define ##subvect-move!           (sym '##sub name '-move!))
    (define ##subvect->fifo           (sym '##sub name '->fifo))
    (define ##fifo->vect              (sym '##fifo-> name))
    (define ##open-vect-generic       (sym '##open- name '-generic))
    (define ##open-vect-pipe-generic  (sym '##open- name '-pipe-generic))
    (define ##open-input-vect         (sym '##open-input- name))
    (define ##open-output-vect        (sym '##open-output- name))
    (define ##open-vect               (sym '##open- name))
    (define ##open-vect-pipe          (sym '##open- name '-pipe))
    (define ##make-vect-port          (sym '##make- name '-port))
    (define ##make-vect-pipe-port     (sym '##make- name '-pipe-port))
    (define ##get-output-vect         (sym '##get-output- name))

    (define open-vect                 (sym 'open- name))
    (define open-vect-pipe            (sym 'open- name '-pipe))
    (define open-input-vect           (sym 'open-input- name))
    (define open-output-vect          (sym 'open-output- name))
    (define get-output-vect           (sym 'get-output- name))

    (define ##call-with-input-vect    (sym '##call-with-input- name))
    (define ##call-with-output-vect   (sym '##call-with-output- name))
    (define ##call-with-output-vect-aux (sym '##call-with-output- name '-aux))
    (define ##with-input-from-vect    (sym '##with-input-from- name))
    (define ##with-output-to-vect     (sym '##with-output-to- name))
    (define ##with-output-to-vect-aux (sym '##with-output-to- name '-aux))

    (define call-with-input-vect      (sym 'call-with-input- name))
    (define call-with-output-vect     (sym 'call-with-output- name))
    (define with-input-from-vect      (sym 'with-input-from- name))
    (define with-output-to-vect       (sym 'with-output-to- name))

    (define define-vect-port-methods
      (sym 'define- name '-port-methods))

    (define macro-vect-port-rbuf
      (sym 'macro- vector/character/byte '-port-rbuf))
    (define macro-vect-port-rbuf-set!
      (sym 'macro- vector/character/byte '-port-rbuf-set!))
    (define macro-vect-port-rlo
      (sym 'macro- vector/character/byte '-port-rlo))
    (define macro-vect-port-rlo-set!
      (sym 'macro- vector/character/byte '-port-rlo-set!))
    (define macro-vect-port-rhi
      (sym 'macro- vector/character/byte '-port-rhi))
    (define macro-vect-port-rhi-set!
      (sym 'macro- vector/character/byte '-port-rhi-set!))
    (define macro-vect-port-rbuf-fill
      (sym 'macro- vector/character/byte '-port-rbuf-fill))
    (define macro-vect-port-rbuf-fill-set!
      (sym 'macro- vector/character/byte '-port-rbuf-fill-set!))
    (define macro-vect-port-wbuf
      (sym 'macro- vector/character/byte '-port-wbuf))
    (define macro-vect-port-wbuf-set!
      (sym 'macro- vector/character/byte '-port-wbuf-set!))
    (define macro-vect-port-wlo
      (sym 'macro- vector/character/byte '-port-wlo))
    (define macro-vect-port-wlo-set!
      (sym 'macro- vector/character/byte '-port-wlo-set!))
    (define macro-vect-port-whi
      (sym 'macro- vector/character/byte '-port-whi))
    (define macro-vect-port-whi-set!
      (sym 'macro- vector/character/byte '-port-whi-set!))
    (define macro-vect-port-wbuf-drain
      (sym 'macro- vector/character/byte '-port-wbuf-drain))
    (define macro-vect-port-wbuf-drain-set!
      (sym 'macro- vector/character/byte '-port-wbuf-drain-set!))

    (define macro-vect-port-peer
      (sym 'macro- name '-port-peer))
    (define macro-vect-port-peer-set!
      (sym 'macro- name '-port-peer-set!))
    (define macro-vect-port-fifo
      (sym 'macro- name '-port-fifo))
    (define macro-vect-port-fifo-set!
      (sym 'macro- name '-port-fifo-set!))
    (define macro-vect-port-rcondvar
      (sym 'macro- name '-port-rcondvar))
    (define macro-vect-port-rcondvar-set!
      (sym 'macro- name '-port-rcondvar-set!))
    (define macro-vect-port-wcondvar
      (sym 'macro- name '-port-wcondvar))
    (define macro-vect-port-wcondvar-set!
      (sym 'macro- name '-port-wcondvar-set!))
    (define macro-vect-port-buffering-limit
      (sym 'macro- name '-port-buffering-limit))
    (define macro-vect-port-buffering-limit-set!
      (sym 'macro- name '-port-buffering-limit-set!))

    (define vect-rbuf-fill
      (sym name '-rbuf-fill))

    (define vect-wbuf-drain
      (sym name '-wbuf-drain))

    `(begin

       (define-fail-check-type ,vect-input-port ',vect-input-port)
       (define-fail-check-type ,vect-output-port ',vect-output-port)
       (define-fail-check-type ,vect-or-settings ',vect-or-settings)

       (##define-macro (,define-vect-port-methods)
         `(begin

            (define (,',vect-rbuf-fill port want block?)

              ;; port is the vector input-port
              ;; want is the number of elements that the caller wants (#f = max)
              ;; block? is a boolean indicating whether it is OK for the
              ;; thread to block

              ;; This procedure returns one of the following values:
              ;;  - #t if something was added to the read buffer,
              ;;  - #f if nothing could be added to the read buffer
              ;;    (because end-of-file was reached),
              ;;  - fixnum indicating an error code (in particular,
              ;;    only if block? is false or there was a read timeout
              ;;    and the timeout thunk returned #f, ##err-code-EAGAIN
              ;;    is returned to indicate that nothing is currently
              ;;    available to be read).

              ;; It is assumed that the thread has exclusive access to the port.

              (##declare (not interrupts-enabled))

              (let loop ()
                (let* ((peer (,',macro-vect-port-peer port))
                       (vect-rbuf (,',macro-vect-port-rbuf port))
                       (vect-wbuf (,',macro-vect-port-wbuf peer)))
                  (if (##not (##eq? vect-rbuf vect-wbuf))

                      ;; there are at least two chunks in the FIFO

                      (let ((vect-rhi (,',macro-vect-port-rhi port))
                            (len (,',##vect-length vect-rbuf)))

                        (cond ((##fx< vect-rhi len)

                               ;; some elements in rbuf can be read
                               ;; beyond rhi so make them available
                               ;; and indicate that something was
                               ;; added to the read buffer

                               (,',macro-vect-port-rhi-set! port len)
                               #t)

                              (else

                               ;; it is necessary to get data from the next
                               ;; chunk in the FIFO

                               ,',(if (eq? name 'string)
                                      `(begin

                                         ;; keep track of number of
                                         ;; characters read

                                         (macro-character-port-rchars-set!
                                          port
                                          (##fx+ (macro-character-port-rchars port)
                                                 (macro-character-port-rhi port))))
                                      #f)

                               (let* ((next-chunk
                                       (macro-fifo-advance!
                                        (,',macro-vect-port-fifo peer)))
                                      (vect-rlo
                                       (,',macro-vect-port-rlo port)))

                                 ;; keep track of amount of data buffered
                                 (,',macro-vect-port-wlo-set!
                                  peer
                                  (##fx- (,',macro-vect-port-wlo peer)
                                         vect-rlo))

                                 (if (##fx= vect-rlo vect-rhi)

                                     ;; no data must be carried over

                                     (let ((new-vect-rbuf next-chunk))

                                       ;; install new read buffer
                                       (,',macro-vect-port-rbuf-set!
                                        port
                                        new-vect-rbuf))

                                     ;; data must be carried over from
                                     ;; current read buffer

                                     (let ((new-vect-rbuf
                                            (,',##vect-append
                                             (,',##subvect vect-rbuf vect-rlo vect-rhi)
                                             next-chunk)))

                                       ;; update chunk in FIFO
                                       (macro-fifo-elem-set!
                                        (macro-fifo-next
                                         (,',macro-vect-port-fifo peer))
                                        new-vect-rbuf)

                                       ;; install new read buffer
                                       (,',macro-vect-port-rbuf-set!
                                        port
                                        new-vect-rbuf)

                                       ;; if needed update write buffer and whi

                                       (if (##eq? next-chunk vect-wbuf)
                                           (let ((new-whi
                                                  (##fx+
                                                   (,',macro-vect-port-whi peer)
                                                   (##fx- vect-rhi vect-rlo))))

                                             (,',macro-vect-port-whi-set!
                                              peer
                                              new-whi)

                                             (,',macro-vect-port-wbuf-set!
                                              peer
                                              new-vect-rbuf)))))

                                 ;; reset rlo and rhi to zero (note that next
                                 ;; iteration of loop will set rhi correctly)
                                 (,',macro-vect-port-rlo-set! port 0)
                                 (,',macro-vect-port-rhi-set! port 0)

                                 ;; signal any thread that may be waiting
                                 ;; to write data on peer's output port
                                 (##condvar-signal-no-reschedule!
                                  (,',macro-vect-port-wcondvar peer)
                                  #t)

                                 ;; try again
                                 (loop)))))

                      ;; the FIFO contains a single chunk which is
                      ;; both the rbuf and wbuf

                      (let* ((vect-rhi (,',macro-vect-port-rhi port))
                             (vect-whi (,',macro-vect-port-whi peer)))

                        (cond ((##fx< vect-rhi vect-whi)

                               ;; some elements in rbuf can be read
                               ;; beyond rhi so make them available
                               ;; and indicate that something was
                               ;; added to the read buffer

                               (,',macro-vect-port-rhi-set! port vect-whi)
                               #t)

                              ((macro-closed? (macro-port-woptions peer))

                               ;; the peer's output port is closed so indicate
                               ;; that no new data can be read (end-of-file),
                               ;; but unclose the peer if the permanent-close
                               ;; option is #f (this way an end-of-file can
                               ;; be generated multiple times)

                               (if (##not (macro-perm-close?
                                           (macro-port-woptions peer)))
                                   (macro-port-woptions-set!
                                    peer
                                    (macro-unclose! (macro-port-woptions peer))))
                               #f)

                              (block?

                               ;; the peer's output port is still open
                               ;; so block the current thread, waiting
                               ;; for new data to be added to the
                               ;; peer's output port

                               (let ((continue?
                                      (or (##mutex-signal-and-condvar-wait!
                                           (macro-port-mutex port)
                                           (,',macro-vect-port-rcondvar port)
                                           (macro-port-rtimeout port))
                                          ((macro-port-rtimeout-thunk port)))))
                                 (macro-port-mutex-lock! port)
                                 (if continue?
                                     (loop)
                                     ##err-code-EAGAIN)))

                              (else

                               ;; it is not OK to block, so indicate
                               ;; that the operation should be tried
                               ;; again

                               ##err-code-EAGAIN)))))))

            (define (,',vect-wbuf-drain port)

              ;; This procedure returns #f when the write buffer was
              ;; successfully drained or it returns an error code
              ;; (fixnum).  In particular, only if there was a write
              ;; timeout and the timeout thunk returned #f,
              ;; ##err-code-EAGAIN is returned to indicate that nothing
              ;; could be written at this time.

              ;; It is assumed that the thread has exclusive access to the port.

              (##declare (not interrupts-enabled))

              (let loop ()
                (let* ((peer
                        (,',macro-vect-port-peer port))
                       (buffering-limit
                        (,',macro-vect-port-buffering-limit port)))
                  (if (and buffering-limit
                           (let ((unread
                                  (##fx- (,',macro-vect-port-wlo port)
                                         (,',macro-vect-port-rlo peer))))
                             (##fx< buffering-limit unread)))

                      ;; buffering limit has been reached, so block
                      ;; the thread until some reads decrease the
                      ;; amount of data buffered

                      (let ((continue?
                             (or (##mutex-signal-and-condvar-wait!
                                  (macro-port-mutex port)
                                  (,',macro-vect-port-wcondvar port)
                                  (macro-port-wtimeout port))
                                 ((macro-port-wtimeout-thunk port)))))
                        (macro-port-mutex-lock! port)
                        (if continue?
                            (loop)
                            ##err-code-EAGAIN))

                      ;; buffering limit is not yet reached, so allocate
                      ;; a new write buffer and add it to the FIFO

                      (let* ((new-vect-wbuf
                              (,',##make-vect chunk-size))
                             (vect-wbuf
                              (,',macro-vect-port-wbuf port))
                             (vect-whi
                              (,',macro-vect-port-whi port)))

                        ;; keep track of amount of data buffered
                        (,',macro-vect-port-wlo-set!
                         port
                         (##fx+ (,',macro-vect-port-wlo port) vect-whi))

                        ,',(if (eq? name 'string)
                               `(begin
                                  ;; keep track of number of
                                  ;; characters written
                                  (macro-character-port-wchars-set!
                                   port
                                   (##fx+
                                    (macro-character-port-wchars port)
                                    vect-whi)))
                               #f)

                        ;; trim write buffer so it only contains
                        ;; written data
                        (,',##vect-shrink! vect-wbuf vect-whi)

                        ;; install the new write buffer
                        (,',macro-vect-port-whi-set! port 0)
                        (,',macro-vect-port-wbuf-set! port new-vect-wbuf)

                        ;; add new chunk to FIFO
                        (macro-fifo-insert-at-tail!
                         (,',macro-vect-port-fifo port)
                         new-vect-wbuf)

                        ;; signal peer side in case it is blocked
                        ;; on a read
                        (##condvar-signal-no-reschedule!
                         (,',macro-vect-port-rcondvar peer)
                         #t)

                        ;; indicate that the write buffer was
                        ;; successfully drained
                        #f)))))

            (define (name port)

              ;; It is assumed that the thread **does not** have exclusive
              ;; access to the port.

              (##declare (not interrupts-enabled))

              '(,',name))

            (define (wait port direction)

              ;; It is assumed that the thread **does not** have exclusive
              ;; access to the port.

              (##declare (not interrupts-enabled))

              #t) ;; TODO: implement with actual wait

            (define (force-output port level prim arg1 arg2 arg3 arg4)

              ;; It is assumed that the thread **does not** have exclusive
              ;; access to the port.

              (##declare (not interrupts-enabled))

              (macro-port-mutex-lock! port) ;; get exclusive access to port

              (let ((peer (,',macro-vect-port-peer port)))

                (##condvar-signal-no-reschedule!
                 (,',macro-vect-port-rcondvar peer)
                 #t)

                ,',(if drain-output
                       `(let ((code (,drain-output port)))
                          (macro-port-mutex-unlock! port)
                          (if (##fixnum? code)
                              (if (##fx= code ##err-code-EAGAIN)
                                  #f;;;;;;;;;;;this doesn't appear to be right!
                                  (##raise-os-io-exception port #f code prim arg1 arg2 arg3 arg4))
                              (##void)))
                       `(begin
                          (macro-port-mutex-unlock! port)
                          (##void)))))

            (define (close port prim arg1)

              ;; It is assumed that the thread **does not** have exclusive
              ;; access to the port.

              (##declare (not interrupts-enabled))

              ((macro-object-port-force-output port)
               port
               0
               prim
               arg1
               (macro-absent-obj)
               (macro-absent-obj)
               (macro-absent-obj))

              (macro-port-mutex-lock! port) ;; get exclusive access to port

              (let ((peer (,',macro-vect-port-peer port)))

                (if (##not (##eq? prim close-output-port))
                    (begin
                      (macro-port-roptions-set!
                       port
                       (macro-close! (macro-port-roptions port)))
                      (##condvar-signal-no-reschedule!
                       (,',macro-vect-port-wcondvar peer)
                       #t)))

                (if (##not (##eq? prim close-input-port))
                    (begin
                      (macro-port-woptions-set!
                       port
                       (macro-close! (macro-port-woptions port)))
                      (##condvar-signal-no-reschedule!
                       (,',macro-vect-port-rcondvar peer)
                       #t)))

                (macro-port-mutex-unlock! port)

                (##void)))

            (define (set-rtimeout port timeout thunk)

              ;; It is assumed that the thread **does not** have exclusive
              ;; access to the port.

              (##declare (not interrupts-enabled))

              (macro-port-mutex-lock! port) ;; get exclusive access to port

              (macro-port-rtimeout-set! port timeout)
              (macro-port-rtimeout-thunk-set! port thunk)
              (##condvar-signal-no-reschedule!
               (,',macro-vect-port-rcondvar port)
               #t)
              (macro-port-mutex-unlock! port)
              (##void))

            (define (set-wtimeout port timeout thunk)

              ;; It is assumed that the thread **does not** have exclusive
              ;; access to the port.

              (##declare (not interrupts-enabled))

              (macro-port-mutex-lock! port) ;; get exclusive access to port

              (macro-port-wtimeout-set! port timeout)
              (macro-port-wtimeout-thunk-set! port thunk)
              (##condvar-signal-no-reschedule!
               (,',macro-vect-port-wcondvar port)
               #t)
              (macro-port-mutex-unlock! port)
              (##void))))

       (define-prim (,##subvect->fifo vect start end chunk-size)
         (let ((fifo (macro-make-fifo)))
           (let loop ((lo start))
             (let ((hi (##fx+ lo chunk-size)))
               (if (##fx< hi end)
                   (begin
                     (macro-fifo-insert-at-tail! fifo (,##subvect vect lo hi))
                     (loop hi))
                   (begin
                     (macro-fifo-insert-at-tail! fifo (,##subvect vect lo end))
                     fifo))))))

       (define-prim (,##fifo->vect fifo start end)
         (let* ((len (##fxmax (##fx- end start) 0))
                (vect (,##make-vect len)))
           (let loop ((elems (macro-fifo-next fifo))
                      (hi end)
                      (lo start)
                      (i 0))
             (if (##fx< lo hi)
                 (let* ((chunk
                         (macro-fifo-elem elems))
                        (chunk-len
                         (,##vect-length chunk))
                        (n
                         (##fxmin (##fx- chunk-len lo)
                                  (##fx- hi lo))))
                   (,##subvect-move! chunk lo (##fx+ lo n) vect i)
                   (loop (macro-fifo-next elems)
                         (##fx- hi chunk-len)
                         (##fx- (##fx+ lo n) chunk-len)
                         (##fx+ i n)))
                 vect))))

       (define-prim (,##open-vect-generic
                     direction
                     cont
                     prim
                     #!optional
                     (init-or-settings (macro-absent-obj))
                     (arg2 (macro-absent-obj)))

         (define (fail)
           (,##fail-check-vect-or-settings 1 prim init-or-settings arg2))

         (##make-psettings
          direction
          ',allowed-settings
          (cond ((##eq? init-or-settings (macro-absent-obj))
                 '())
                ((,##vect? init-or-settings)
                 (##list 'init: init-or-settings))
                (else
                 init-or-settings))
          fail
          (lambda (psettings)
            (let ((init
                   (or (macro-psettings-init psettings)
                       ',empty-vect)))
              (if (##not (,##vect? init))
                  (fail)
                  (cont
                   (,##make-vect-port
                    init
                    0
                    (,##vect-length init)
                    psettings)))))))

       (define-prim (,##open-vect
                     #!optional
                     (init-or-settings (macro-absent-obj)))
         (,##open-vect-generic
          (macro-direction-inout)
          (lambda (port) port)
          ,open-vect
          init-or-settings))

       (define-prim (,open-vect
                     #!optional
                     (init-or-settings (macro-absent-obj)))
         (macro-force-vars (init-or-settings)
           (,##open-vect init-or-settings)))

       (define-prim (,##make-vect-pipe-port
                     psettings1
                     #!optional
                     (psettings2 (macro-absent-obj)))
         (let* ((init1
                 (or (macro-psettings-init psettings1)
                     ',empty-vect))
                (port1
                 (,##make-vect-port
                  init1
                  0
                  (,##vect-length init1)
                  psettings1))
                (port2
                 (if (##eq? psettings2 (macro-absent-obj))
                     (,##make-vect-port
                      ',empty-vect
                      0
                      0
                      (let ((roptions (macro-psettings-roptions psettings1))
                            (woptions (macro-psettings-woptions psettings1)))
                        (macro-psettings-roptions-set! psettings1 woptions)
                        (macro-psettings-woptions-set! psettings1 roptions)
                        (cond ((##fx= (macro-psettings-direction psettings1)
                                      (macro-direction-in))
                               (macro-psettings-direction-set!
                                psettings1
                                (macro-direction-out)))
                              ((##fx= (macro-psettings-direction psettings1)
                                      (macro-direction-out))
                               (macro-psettings-direction-set!
                                psettings1
                                (macro-direction-in))))
                        psettings1))
                     (let ((init2
                            (or (macro-psettings-init psettings2)
                                ',empty-vect)))
                       (,##make-vect-port
                        init2
                        0
                        (,##vect-length init2)
                        psettings2)))))
           (let ((wbuf1 (,macro-vect-port-wbuf port1))
                 (wbuf2 (,macro-vect-port-wbuf port2))
                 (whi1 (,macro-vect-port-whi port1))
                 (whi2 (,macro-vect-port-whi port2)))
             (,macro-vect-port-wbuf-set! port1 wbuf2)
             (,macro-vect-port-wbuf-set! port2 wbuf1)
             (,macro-vect-port-whi-set! port1 whi2)
             (,macro-vect-port-whi-set! port2 whi1)
             (,macro-vect-port-peer-set! port1 port2)
             (,macro-vect-port-peer-set! port2 port1))
           (##values port1 port2)))

       (define-prim (,##open-vect-pipe-generic
                     direction
                     cont
                     prim
                     #!optional
                     (init-or-settings1 (macro-absent-obj))
                     (init-or-settings2 (macro-absent-obj)))

         (define (fail1)
           (,##fail-check-vect-or-settings 1 prim init-or-settings1 init-or-settings2))

         (define (fail2)
           (,##fail-check-vect-or-settings 2 prim init-or-settings1 init-or-settings2))

         (##make-psettings
          direction
          ',allowed-settings
          (cond ((##eq? init-or-settings1 (macro-absent-obj))
                 '())
                ((,##vect? init-or-settings1)
                 (##list 'init: init-or-settings1))
                (else
                 init-or-settings1))
          fail1
          (lambda (psettings1)
            (let ((init1
                   (or (macro-psettings-init psettings1)
                       ',empty-vect)))
              (if (##not (,##vect? init1))
                  (fail1)
                  (if (##eq? init-or-settings2 (macro-absent-obj))
                      (cont (,##make-vect-pipe-port psettings1))
                      (##make-psettings
                       direction
                       ',allowed-settings
                       (cond ((,##vect? init-or-settings2)
                              (##list 'init: init-or-settings2))
                             (else
                              init-or-settings2))
                       fail2
                       (lambda (psettings2)
                         (let ((init2
                                (or (macro-psettings-init psettings2)
                                    ',empty-vect)))
                           (if (##not (,##vect? init2))
                               (fail2)
                               (cont (,##make-vect-pipe-port psettings1 psettings2))))))))))))

       (define-prim (,##open-vect-pipe
                     #!optional
                     (init-or-settings1 (macro-absent-obj))
                     (init-or-settings2 (macro-absent-obj)))
         (,##open-vect-pipe-generic
          (macro-direction-inout)
          (lambda (ports) ports)
          ,open-vect-pipe
          init-or-settings1
          init-or-settings2))

       (define-prim (,open-vect-pipe
                     #!optional
                     (init-or-settings1 (macro-absent-obj))
                     (init-or-settings2 (macro-absent-obj)))
         (macro-force-vars (init-or-settings1 init-or-settings2)
           (,##open-vect-pipe init-or-settings1 init-or-settings2)))

       (define-prim (,##open-input-vect
                     #!optional
                     (init-or-settings (macro-absent-obj)))
         (,##open-vect-generic
          (macro-direction-in)
          (lambda (port) port)
          ,open-input-vect
          init-or-settings))

       (define-prim (,open-input-vect
                     #!optional
                     (init-or-settings (macro-absent-obj)))
         (macro-force-vars (init-or-settings)
           (,##open-input-vect init-or-settings)))

       (define-prim (,##open-output-vect
                     #!optional
                     (init-or-settings (macro-absent-obj)))
         (,##open-vect-generic
          (macro-direction-out)
          (lambda (port) port)
          ,open-output-vect
          init-or-settings))

       (define-prim (,open-output-vect
                     #!optional
                     (init-or-settings (macro-absent-obj)))
         (macro-force-vars (init-or-settings)
           (,##open-output-vect init-or-settings)))

       (define-prim (,##get-output-vect port)

         (##declare (not interrupts-enabled))

         (let ((peer
                (,macro-vect-port-peer port)))

           ((macro-object-port-force-output port)
            port
            0
            ,get-output-vect
            port
            (macro-absent-obj)
            (macro-absent-obj)
            (macro-absent-obj))

           (macro-port-mutex-lock! port) ;; get exclusive access to port

           (let* ((vect-fifo
                   (,macro-vect-port-fifo port))
                  (result
                   (,##fifo->vect
                    vect-fifo
                    (,macro-vect-port-rlo peer)
                    (##fx+ (,macro-vect-port-wlo port)
                           (,macro-vect-port-whi port))))
                  (new-vect-buf
                   (macro-fifo-advance-to-tail! vect-fifo)))

             ;; zap the entries of the buffer to avoid leaks

             ,(if vect-zap!
                  `(let loop ((i
                               (if (##eq?
                                    (,macro-vect-port-rbuf peer)
                                    new-vect-buf)
                                   (,macro-vect-port-rlo peer)
                                   0)))
                     (if (##fx< i (,macro-vect-port-whi port))
                         (begin
                           (,vect-zap! new-vect-buf i)
                           (loop (##fx+ i 1)))))
                  #f)

             ,(if (eq? name 'string)
                  `(macro-character-port-wchars-set!
                    port
                    (##fx+ (macro-character-port-wchars port)
                           (,macro-vect-port-whi port)))
                  #f)

             (,macro-vect-port-rbuf-set! peer new-vect-buf)
             (,macro-vect-port-rlo-set! peer 0)
             (,macro-vect-port-rhi-set! peer 0)

             (,macro-vect-port-wbuf-set! port new-vect-buf)
             (,macro-vect-port-wlo-set! port 0)
             (,macro-vect-port-whi-set! port 0)

             (macro-port-mutex-unlock! port)

             result)))

       (define-prim (,get-output-vect port)
         (macro-force-vars (port)
           (,macro-check-vect-output-port
             port
             1
             (,get-output-vect port)
             (,##get-output-vect port))))

       (define-prim (,##call-with-input-vect init-or-settings proc)
         (,##open-vect-generic
          (macro-direction-in)
          (lambda (port)
            (let ((results ;; may get bound to a multiple-values object
                   (proc port)))
              (##close-input-port port)
              results))
          ,call-with-input-vect
          init-or-settings
          proc))

       (define-prim (,call-with-input-vect init-or-settings proc)
         (macro-force-vars (init-or-settings proc)
           (macro-check-procedure
             proc
             2
             (,call-with-input-vect init-or-settings proc)
             (,##call-with-input-vect init-or-settings proc))))

       (define-prim (,##call-with-output-vect-aux init-or-settings proc)
         (,##open-vect-generic
          (macro-direction-out)
          (lambda (port)
            (let ((results ;; may get bound to a multiple-values object
                   (proc port)))
              (##force-output port)
              (##close-output-port port)
              (,##get-output-vect port)))
          ,call-with-output-vect
          init-or-settings
          proc))

       (define-prim (,##call-with-output-vect
                     arg1
                     #!optional
                     (arg2 (macro-absent-obj)))
         (if (##eq? arg2 (macro-absent-obj))
             (,##call-with-output-vect-aux '() arg1)
             (,##call-with-output-vect-aux arg1 arg2)))

       (define-prim (,call-with-output-vect
                     arg1
                     #!optional
                     (arg2 (macro-absent-obj)))
         (macro-force-vars (arg1 arg2)
           (if (##eq? arg2 (macro-absent-obj))
               (macro-check-procedure
                 arg1
                 1
                 (,call-with-output-vect arg1)
                 (,##call-with-output-vect-aux '() arg1))
               (macro-check-procedure
                 arg2
                 2
                 (,call-with-output-vect arg1 arg2)
                 (,##call-with-output-vect-aux arg1 arg2)))))

       (define-prim (,##with-input-from-vect init-or-settings thunk)
         (,##open-vect-generic
          (macro-direction-in)
          (lambda (port)
            (let ((results ;; may get bound to a multiple-values object
                   (macro-dynamic-bind input-port port thunk)))
              (##close-input-port port)
              results))
          ,with-input-from-vect
          init-or-settings
          thunk))

       (define-prim (,with-input-from-vect init-or-settings thunk)
         (macro-force-vars (init-or-settings thunk)
           (macro-check-procedure
             thunk
             2
             (,with-input-from-vect init-or-settings thunk)
             (,##with-input-from-vect init-or-settings thunk))))

       (define-prim (,##with-output-to-vect-aux init-or-settings thunk)
         (,##open-vect-generic
          (macro-direction-out)
          (lambda (port)
            (let ((results ;; may get bound to a multiple-values object
                   (macro-dynamic-bind output-port port thunk)))
              (##force-output port)
              (##close-output-port port)
              (,##get-output-vect port)))
          ,with-output-to-vect
          init-or-settings
          thunk))

       (define-prim (,##with-output-to-vect
                     arg1
                     #!optional
                     (arg2 (macro-absent-obj)))
         (if (##eq? arg2 (macro-absent-obj))
             (,##with-output-to-vect-aux '() arg1)
             (,##with-output-to-vect-aux arg1 arg2)))

       (define-prim (,with-output-to-vect
                     arg1
                     #!optional
                     (arg2 (macro-absent-obj)))
         (macro-force-vars (arg1 arg2)
           (if (##eq? arg2 (macro-absent-obj))
               (macro-check-procedure
                 arg1
                 1
                 (,with-output-to-vect arg1)
                 (,##with-output-to-vect-aux '() arg1))
               (macro-check-procedure
                 arg2
                 2
                 (,with-output-to-vect arg1 arg2)
                 (,##with-output-to-vect-aux arg1 arg2))))))))

(define-prim (##vect-port-options options kind buffering)
  (##psettings-options->options
   options
   (##fx+
    (##fxarithmetic-shift-left
     (if (##fx= kind (macro-none-kind))
         (macro-open-state-closed)
         (macro-open-state-open))
     (macro-open-state-shift))
    (##fxarithmetic-shift-left
     buffering
     (macro-buffering-shift)))))

;;;----------------------------------------------------------------------------

;;; Implementation of vector ports.

(define-prim-vector-port-procedures
  vector
  #()
  (lambda (vect i) (##vector-set! vect i #f))
  #f
  (init:
   permanent-close:
   direction:
   input-buffering:
   output-buffering:
   buffering:))

(define-prim (##make-vector-port src start end psettings)

  (define chunk-size 16)

  (let* ((direction
          (macro-psettings-direction psettings))
         (len
          (##fxmax (##fx- end start) 0))
         (vector-fifo
          (##subvector->fifo src start end chunk-size))
         (mutex
          (macro-make-port-mutex))
         (rkind
          (if (##fx= direction (macro-direction-out))
              (macro-none-kind)
              (macro-vector-kind)))
         (wkind
          (if (##fx= direction (macro-direction-in))
              (macro-none-kind)
              (macro-vector-kind)))
         (roptions
          (##vect-port-options
           (macro-psettings-roptions psettings)
           rkind
           (macro-full-buffering)))
         (rtimeout
          #t)
         (rtimeout-thunk
          #f)
         (woptions
          (##vect-port-options
           (macro-psettings-woptions psettings)
           wkind
           (macro-full-buffering)))
         (wtimeout
          #t)
         (wtimeout-thunk
          #f)
         (vector-rbuf
          (macro-fifo-elem (macro-fifo-next vector-fifo)))
         (vector-rlo
          0)
         (vector-rhi
          (##vector-length vector-rbuf))
         (vector-wbuf
          (macro-fifo-elem (macro-fifo-tail vector-fifo)))
         (vector-whi
          (##vector-length vector-wbuf))
         (vector-wlo
          (##fx- len vector-whi))
         (vector-rcondvar
          (##make-io-condvar-for-reading #f))
         (vector-wcondvar
          (##make-io-condvar-for-writing #f))
         (vector-buffering-limit
          #f))

    (define (read-datum port re)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let loop ()

        (let ((vector-rlo (macro-vector-port-rlo port))
              (vector-rhi (macro-vector-port-rhi port)))
          (if (##fx< vector-rlo vector-rhi)

              ;; the next object is in the object read buffer

              (let* ((vector-rbuf
                      (macro-vector-port-rbuf port))
                     (obj
                      (##vector-ref vector-rbuf vector-rlo)))

                ;; frequent simple case, just advance rlo and zap vector
                ;; to avoid retaining objects uselessly

                (##vector-set! vector-rbuf vector-rlo #f)
                (macro-vector-port-rlo-set! port (##fx+ vector-rlo 1))
                (macro-port-mutex-unlock! port)
                obj)

              ;; try to get more objects into the object read
              ;; buffer, and try again if successful otherwise
              ;; signal an error or return end-of-file object

              (let ((code ((macro-vector-port-rbuf-fill port)
                           port
                           1
                           #t)))

                (cond ((##fixnum? code)

                       ;; the conversion or read caused an error

                       (macro-port-mutex-unlock! port)
                       (if (##fx= code ##err-code-EAGAIN)
                           #!eof ;; the read timeout thunk returned #f
                           (##raise-os-io-exception port #f code read port)))

                      (code

                       ;; some objects were added to object buffer

                       (loop))

                      (else

                       ;; no objects were added to object buffer

                       (macro-port-mutex-unlock! port)
                       #!eof)))))))

    (define (write-datum port obj we)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let loop ()

        (let ((vector-wbuf (macro-vector-port-wbuf port))
              (vector-whi+1 (##fx+ (macro-vector-port-whi port) 1)))
          (if (##not (##fx< (##vector-length vector-wbuf) vector-whi+1))

              ;; there is enough space in the object write buffer, so add
              ;; object and increment whi

              (let ()

                (##vector-set! vector-wbuf (##fx- vector-whi+1 1) obj)

                ;; advance whi

                (macro-vector-port-whi-set! port vector-whi+1)

                ;; force output if port is set for unbuffered output

                (if (macro-unbuffered? (macro-port-woptions port))
                    (begin
                      (macro-port-mutex-unlock! port)
                      ((macro-object-port-force-output port)
                       port
                       0
                       write
                       obj
                       port
                       (macro-absent-obj)
                       (macro-absent-obj)))
                    (begin
                      (macro-port-mutex-unlock! port)
                      (##void))))

              ;; make some space in the object buffer and try again

              (let ((code ((macro-vector-port-wbuf-drain port) port)))
                (if (##fixnum? code)
                    (begin
                      (macro-port-mutex-unlock! port)
                      (if (##fx= code ##err-code-EAGAIN)
                          #f
                          (##raise-os-io-exception port #f code write obj port)))
                    (loop)))))))

    (define (newline port)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##void))

    (define-vector-port-methods)

    (let ((port
           (macro-make-vector-port
            mutex
            rkind
            wkind
            name
            wait
            close
            roptions
            rtimeout
            rtimeout-thunk
            set-rtimeout
            woptions
            wtimeout
            wtimeout-thunk
            set-wtimeout
            #f ;; io-exception-handler
            read-datum
            write-datum
            newline
            force-output
            vector-rbuf
            vector-rlo
            vector-rhi
            vector-rbuf-fill
            vector-wbuf
            vector-wlo
            vector-whi
            vector-wbuf-drain
            #f
            vector-fifo
            vector-rcondvar
            vector-wcondvar
            vector-buffering-limit)))
      (macro-vector-port-peer-set! port port)
      (##io-condvar-port-set! vector-rcondvar port)
      (##io-condvar-port-set! vector-wcondvar port)
      port)))

;;;----------------------------------------------------------------------------

;;; Implementation of string ports.

(define-prim-vector-port-procedures
  string
  ""
  #f
  #f
  (output-width:
   init:
   permanent-close:
   direction:
   input-buffering:
   output-buffering:
   buffering:
   input-readtable:
   output-readtable:
   readtable:))

(define-prim (##make-string-port src start end psettings)

  (define chunk-size 32)

  (let* ((direction
          (macro-psettings-direction psettings))
         (len
          (##fxmax (##fx- end start) 0))
         (string-fifo
          (##substring->fifo src start end chunk-size))
         (mutex
          (macro-make-port-mutex))
         (rkind
          (if (##fx= direction (macro-direction-out))
              (macro-none-kind)
              (macro-string-kind)))
         (wkind
          (if (##fx= direction (macro-direction-in))
              (macro-none-kind)
              (macro-string-kind)))
         (roptions
          (##vect-port-options
           (macro-psettings-roptions psettings)
           rkind
           (macro-full-buffering)))
         (rtimeout
          #t)
         (rtimeout-thunk
          #f)
         (woptions
          (##vect-port-options
           (macro-psettings-woptions psettings)
           wkind
           (macro-full-buffering)))
         (wtimeout
          #t)
         (wtimeout-thunk
          #f)
         (string-rbuf
          (macro-fifo-elem (macro-fifo-next string-fifo)))
         (string-rlo
          0)
         (string-rhi
          (##string-length string-rbuf))
         (char-rchars
          0)
         (char-rlines
          0)
         (char-rcurline
          0)
         (char-peek-eof?
          #f)
         (string-wbuf
          (macro-fifo-elem (macro-fifo-tail string-fifo)))
         (string-whi
          (##string-length string-wbuf))
         (string-wlo
          (##fx- len string-whi))
         (char-wchars
          0)
         (char-wlines
          0)
         (char-wcurline
          0)
         (input-readtable
          (##psettings->input-readtable psettings))
         (output-readtable
          (##psettings->output-readtable psettings))
         (string-rcondvar
          (##make-io-condvar-for-reading #f))
         (string-wcondvar
          (##make-io-condvar-for-writing #f))
         (string-width
          (##psettings->output-width psettings))
         (string-buffering-limit
          #f))

    (define (read-datum port re)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##read-datum-or-eof re))

    (define (write-datum port obj we)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##wr we obj))

    (define (newline port)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-write-char #\newline port))

    (define (output-width port)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-string-port-width port))

    (define-string-port-methods)

    (let ((port
           (macro-make-string-port
            mutex
            rkind
            wkind
            name
            wait
            close
            roptions
            rtimeout
            rtimeout-thunk
            set-rtimeout
            woptions
            wtimeout
            wtimeout-thunk
            set-wtimeout
            #f ;; io-exception-handler
            read-datum
            write-datum
            newline
            force-output
            string-rbuf
            string-rlo
            string-rhi
            char-rchars
            char-rlines
            char-rcurline
            string-rbuf-fill
            char-peek-eof?
            string-wbuf
            string-wlo
            string-whi
            char-wchars
            char-wlines
            char-wcurline
            string-wbuf-drain
            input-readtable
            output-readtable
            output-width
            #f
            string-fifo
            string-rcondvar
            string-wcondvar
            string-width
            string-buffering-limit)))
      (macro-string-port-peer-set! port port)
      (##io-condvar-port-set! string-rcondvar port)
      (##io-condvar-port-set! string-wcondvar port)
      port)))

;;;----------------------------------------------------------------------------

;;; Implementation of u8vector ports.

(define-prim-vector-port-procedures
  u8vector
  #u8()
  #f
  (lambda (port) ((macro-character-port-wbuf-drain port) port))
  (input-char-encoding:
   output-char-encoding:
   char-encoding:
   input-char-encoding-errors:
   output-char-encoding-errors:
   char-encoding-errors:
   input-eol-encoding:
   output-eol-encoding:
   eol-encoding:
   output-width:
   init:
   permanent-close:
   direction:
   input-buffering:
   output-buffering:
   buffering:
   input-readtable:
   output-readtable:
   readtable:))

(define-prim (##make-u8vector-port src start end psettings)

  (define chunk-size 64)

  (let* ((direction
          (macro-psettings-direction psettings))
         (len
          (##fxmax (##fx- end start) 0))
         (u8vector-fifo
          (##subu8vector->fifo src start end chunk-size))
         (mutex
          (macro-make-port-mutex))
         (rkind
          (if (##fx= direction (macro-direction-out))
              (macro-none-kind)
              (macro-u8vector-kind)))
         (wkind
          (if (##fx= direction (macro-direction-in))
              (macro-none-kind)
              (macro-u8vector-kind)))
         (roptions
          (##vect-port-options
           (macro-psettings-roptions psettings)
           rkind
           (macro-full-buffering)))
         (rtimeout
          #t)
         (rtimeout-thunk
          #f)
         (woptions
          (##vect-port-options
           (macro-psettings-woptions psettings)
           wkind
           (macro-full-buffering)))
         (wtimeout
          #t)
         (wtimeout-thunk
          #f)
         (char-rbuf
          (and (##not (##fx= rkind (macro-none-kind)))
               (##make-string
                (##port-char-buf-len rkind (macro-unbuffered? roptions)))))
         (char-rlo
          0)
         (char-rhi
          0)
         (char-rchars
          0)
         (char-rlines
          0)
         (char-rcurline
          0)
         (char-rbuf-fill
          ##char-rbuf-fill)
         (char-peek-eof?
          #f)
         (char-wbuf
          (and (##not (##fx= wkind (macro-none-kind)))
               (##make-string
                (##port-char-buf-len wkind (macro-unbuffered? woptions)))))
         (char-wlo
          0)
         (char-whi
          0)
         (char-wchars
          0)
         (char-wlines
          0)
         (char-wcurline
          0)
         (char-wbuf-drain
          ##char-wbuf-drain)
         (input-readtable
          (##psettings->input-readtable psettings))
         (output-readtable
          (##psettings->output-readtable psettings))
         (u8vector-rbuf
          (macro-fifo-elem (macro-fifo-next u8vector-fifo)))
         (u8vector-rlo
          0)
         (u8vector-rhi
          (##u8vector-length u8vector-rbuf))
         (u8vector-wbuf
          (macro-fifo-elem (macro-fifo-tail u8vector-fifo)))
         (u8vector-whi
          (##u8vector-length u8vector-wbuf))
         (u8vector-wlo
          (##fx- len u8vector-whi))
         (u8vector-rcondvar
          (##make-io-condvar-for-reading #f))
         (u8vector-wcondvar
          (##make-io-condvar-for-writing #f))
         (u8vector-width
          (##psettings->output-width psettings))
         (u8vector-buffering-limit
          #f))

     (define (read-datum port re)

       ;; It is assumed that the thread **does not** have exclusive
       ;; access to the port.

       (##declare (not interrupts-enabled))

       (##read-datum-or-eof re))

     (define (write-datum port obj we)

       ;; It is assumed that the thread **does not** have exclusive
       ;; access to the port.

       (##declare (not interrupts-enabled))

       (##wr we obj))

     (define (newline port)

       ;; It is assumed that the thread **does not** have exclusive
       ;; access to the port.

       (##declare (not interrupts-enabled))

       (macro-write-char #\newline port))

     (define (output-width port)

       ;; It is assumed that the thread **does not** have exclusive
       ;; access to the port.

       (##declare (not interrupts-enabled))

       (macro-u8vector-port-width port))

     (define-u8vector-port-methods)

     (let ((fill u8vector-rbuf-fill)
           (drain u8vector-wbuf-drain))

       #;
       (define (u8vector-rbuf-fill port want block?)
         (pp (list 'u8vector-rbuf-fill port want block?))
         (##repl)
         (fill port want block?))

       #;
       (define (u8vector-wbuf-drain port)
         (pp (list 'u8vector-wbuf-drain port))
         (##repl)
         (drain port))

     (let ((port
            (macro-make-u8vector-port
             mutex
             rkind
             wkind
             name
             wait
             close
             roptions
             rtimeout
             rtimeout-thunk
             set-rtimeout
             woptions
             wtimeout
             wtimeout-thunk
             set-wtimeout
             #f ;; io-exception-handler
             read-datum
             write-datum
             newline
             force-output
             char-rbuf
             char-rlo
             char-rhi
             char-rchars
             char-rlines
             char-rcurline
             char-rbuf-fill
             char-peek-eof?
             char-wbuf
             char-wlo
             char-whi
             char-wchars
             char-wlines
             char-wcurline
             char-wbuf-drain
             input-readtable
             output-readtable
             output-width
             u8vector-rbuf
             u8vector-rlo
             u8vector-rhi
             u8vector-rbuf-fill
             u8vector-wbuf
             u8vector-wlo
             u8vector-whi
             u8vector-wbuf-drain
             #f
             u8vector-fifo
             u8vector-rcondvar
             u8vector-wcondvar
             u8vector-width
             u8vector-buffering-limit)))
       (macro-u8vector-port-peer-set! port port)
       (##io-condvar-port-set! u8vector-rcondvar port)
       (##io-condvar-port-set! u8vector-wcondvar port)
       port)))
)

;;;----------------------------------------------------------------------------

;; Implementation of marktables based on eq? tables.

;; Marktables are used to detect sharing and cycles during printing.
;; The printer first does a marking phase to determine for every
;; (non-trivial) subobject if it is shared or cyclical.  Then the
;; printer uses this information in the printing phase to print labels
;; when necessary.
;;
;; During the marking phase a state is kept for every subobject visited.
;; The state transitions are:
;;
;;  state
;;
;;   -1    the subobject has not yet been visited
;;
;;   -2    the subobject has been visited once, and not all its children
;;         have been visited recursively (i.e. the subobject could still be
;;         part of a cycle, or be shared)
;;
;;   -3    the subobject has been visited once, and all its children have been
;;         visited recursively (i.e. the subobject is not part of a cycle, but
;;         it may be discovered later that it is shared)
;;
;;   -5    the subobject has been visited a second time but only after all its
;;         children have been visited (i.e. the subobject is shared but it is
;;         not part of a cycle)
;;
;;   -9    the subobject has been visited a second time before all its
;;         children were visited recursively (i.e. the subobject is part
;;         of a cycle)
;;
;; Negative numbers are used to encode the state to differentiate from
;; the (non-negative) labels that are assigned during the printing phase.
;; The bit negation of powers of 2 are used for the last 4 states to
;; simplify creating a set of these states.
;;
;; Here are the state transitions for the events "begin visiting subobject"
;; and "end visiting subobject":
;;
;;  state    begin/end
;;   -1  -->   -2 / -3  (only case that triggers visiting children)
;;   -2  -->   -9 / -3
;;   -3  -->   -5 / -5
;;   -5  -->   -5 / -5
;;   -9  -->   -9 / -9

(##define-macro (macro-not-yet-visited)                      -1)
(##define-macro (macro-children-being-visited)               -2)
(##define-macro (macro-not-part-of-a-cycle-and-maybe-shared) -3)
(##define-macro (macro-not-part-of-a-cycle-and-is-shared)    -5)
(##define-macro (macro-part-of-a-cycle)                      -9)

(##define-macro (macro-cycle-or-shared? state-set)
  `(##not (##fx= -1
                 (##fxior ,state-set
                          (##fxand (macro-not-part-of-a-cycle-and-is-shared)
                                   (macro-part-of-a-cycle))))))

(##define-macro (macro-marktable-count mt)          `(##vector-ref ,mt 0))
(##define-macro (macro-marktable-count-set! mt x)   `(##vector-set! ,mt 0 ,x))
(##define-macro (macro-marktable-table mt)          `(##vector-ref ,mt 1))
(##define-macro (macro-marktable-table-set! mt x)   `(##vector-set! ,mt 1 ,x))
(##define-macro (macro-marktable-shared? mt)        `(##vector-ref ,mt 2))
(##define-macro (macro-marktable-shared?-set! mt x) `(##vector-set! ,mt 2 ,x))
(##define-macro (macro-marktable-seen mt)           `(##vector-ref ,mt 3))
(##define-macro (macro-marktable-seen-set! mt x)    `(##vector-set! ,mt 3 ,x))
(##define-macro (macro-marktable-mask mt)           `(##vector-ref ,mt 3))
(##define-macro (macro-marktable-mask-set! mt x)    `(##vector-set! ,mt 3 ,x))

(##define-macro (macro-marktable-write-table! mt t obj x)
  `(if (macro-marktable-shared? ,mt) ;; shared table?
       (let ((t-copy (##table-copy ,t)))
         (macro-marktable-table-set! ,mt t-copy)
         (macro-marktable-shared?-set! ,mt #f)
         (##table-set! t-copy ,obj ,x))
       (##table-set! ,t ,obj ,x)))

(define-prim (##make-marktable)
  (##declare (not interrupts-enabled))
  (##vector -1   ;; label counter
            #f   ;; lazily allocated table
            #f   ;; shared?
            -1)) ;; set of states seen (inverted bit set), and then mask

(define-prim (##marktable-table-get! mt)
  (##declare (not interrupts-enabled))
  (or (macro-marktable-table mt)
      (let ((t (##make-table-aux 0 #f #f #f ##eq?)))
        (macro-marktable-table-set! mt t)
        t)))

(define-prim (##marktable-mark! mt obj begin?)
  (##declare (not interrupts-enabled))
  (let* ((t (##marktable-table-get! mt))
         (state (##table-ref t obj (macro-not-yet-visited))))
    (if (##fx> state (macro-not-part-of-a-cycle-and-is-shared)) ;; change state?
        ;; equivalent:
        ;; (not (or (##fx= state (macro-not-part-of-a-cycle-and-is-shared))
        ;;          (##fx= state (macro-part-of-a-cycle))))

        (let ((new-state ;; state transition
               (cond ((##fx= state (macro-not-yet-visited))
                      (if begin?
                          (macro-children-being-visited)
                          (macro-not-part-of-a-cycle-and-maybe-shared)))
                     ((##fx= state (macro-children-being-visited))
                      (if begin?
                          (macro-part-of-a-cycle)
                          (macro-not-part-of-a-cycle-and-maybe-shared)))
                     (else
                      (macro-not-part-of-a-cycle-and-is-shared)))))

          (macro-marktable-seen-set!
           mt
           (##fxand (macro-marktable-seen mt) new-state))

          (macro-marktable-write-table! mt t obj new-state)

          (##fx= new-state (macro-children-being-visited)))

        #f)))

(define-prim (##marktable-lookup! mt obj stamp?)
  (##declare (not interrupts-enabled))
  (let* ((t (##marktable-table-get! mt))
         (x (##table-ref t obj (macro-not-yet-visited))))
    (if (##fx< x 0) ;; first time visited during printing phase
        (and stamp? ;; allocate a label if we need to
             (macro-cycle-or-shared? (##fxior x (macro-marktable-mask mt)))
             (let ((label (##fx+ (macro-marktable-count mt) 1)))
               (macro-marktable-count-set! mt label)
               (macro-marktable-write-table! mt t obj label)
               (##cons obj label))) ;; return id
        x))) ;; return the label

(define-prim (##marktable-save mt)
  (##declare (not interrupts-enabled))
  (let ((state
         (##vector (macro-marktable-count mt)
                   (##marktable-table-get! mt)
                   (macro-marktable-shared? mt)
                   (macro-marktable-seen mt))))
    (macro-marktable-shared?-set! mt #t) ;; set "shared table" flag
    state))

(define-prim (##marktable-restore! mt state)
  (##declare (not interrupts-enabled))
  (macro-marktable-count-set!   mt (##vector-ref state 0))
  (macro-marktable-table-set!   mt (##vector-ref state 1))
  (macro-marktable-shared?-set! mt (##vector-ref state 2))
  (macro-marktable-seen-set!    mt (##vector-ref state 3)))

;;;----------------------------------------------------------------------------

;;; Implementation of generic object port procedures.

(define-prim (##port-of-kind? obj kind)
  (##declare (not interrupts-enabled))
  (and (macro-port? obj)
       (##fx= (##fxand (##port-kind obj) kind) kind)))

(define-prim (##port-kind port)
  (##declare (not interrupts-enabled))
  (let ((rkind (macro-port-rkind port)))
    (if (##fx= rkind (macro-none-kind))
        (macro-port-wkind port)
        rkind)))

(define-prim (##port-device port)
  (##declare (not interrupts-enabled))
  (if (##fx= (macro-port-rkind port) (macro-none-kind))
      (let ((wdevice-condvar (macro-device-port-wdevice-condvar port)))
        (macro-condvar-name wdevice-condvar))
      (let ((rdevice-condvar (macro-device-port-rdevice-condvar port)))
        (macro-condvar-name rdevice-condvar))))

(define-prim (##port-name port)
  (##declare (not interrupts-enabled))
  ((macro-port-name port) port))

(define-prim (##port-name-set! port name)
  (##declare (not interrupts-enabled))
  (macro-port-name-set! port (lambda (port) name)))

(define-prim (##read
              #!optional
              (port (macro-current-input-port)))

  (##declare (not interrupts-enabled))

  (if (macro-character-input-port? port)

      (let ()

        (define (read-with-cont port read-cont)
          (let* ((noop
                  (lambda (re x) x)) ;; do not wrap datum
                 (re
                  (##make-readenv
                   port
                   (macro-character-port-input-readtable port)
                   noop
                   noop
                   #f
                   '()
                   read-cont)))
            ((macro-object-port-read-datum port) port re)))

        (let ((handler (macro-port-io-exception-handler port)))
          (if (##procedure? handler) ;; optimization: only capture continuation when using custom exception handler
              (##continuation-capture
               (lambda (read-cont)
                 (read-with-cont port read-cont)))
              (read-with-cont port #f))))

      ((macro-object-port-read-datum port) port #f)))

(define-prim (read
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
      (macro-check-object-input-port p 1 (read p)
        (##read p)))))

(define-prim (##write-generic-to-character-port style port rt force? limit obj)

  (##declare (not interrupts-enabled))

  (let* ((sharing-allowed?
          (macro-readtable-sharing-allowed? rt))
         (mt1
          (and (if (##eq? sharing-allowed? 'default)
                   (or (##eq? style 'write-shared)
                       (##eq? style 'write)
                       (##eq? style 'display)
                       (##eq? style 'pretty-print))
                   sharing-allowed?)
               (##make-marktable))))

    (define (make-we style mt)
      (##make-writeenv
       style
       port
       rt
       mt
       force?
       (##output-port-width port)
       0
       0
       0
       limit
       (or (macro-readtable-max-unescaped-char rt)
           (macro-max-unescaped-char (macro-port-woptions port)))))

    (let* ((mt2
            (and mt1
                 (let ((we1 (make-we 'mark mt1)))
                   ((macro-object-port-write-datum port) port obj we1)
                   (let* ((seen
                           (macro-marktable-seen mt1))
                          (mask
                           ;; only use labels for cycles, unless sharing matters
                           (##fxior
                            seen
                            (if (if (##eq? sharing-allowed? 'default)
                                    (##eq? style 'write-shared)
                                    sharing-allowed?)
                                (##fxand
                                 (macro-not-part-of-a-cycle-and-is-shared)
                                 (macro-part-of-a-cycle))
                                (macro-part-of-a-cycle)))))
                     (if (##fx= -1 mask)
                         #f
                         (begin
                           (macro-marktable-mask-set! mt1 mask)
                           mt1))))))
           (we2
            (make-we style mt2)))
      ((macro-object-port-write-datum port) port obj we2)
      (##fx- limit (macro-writeenv-limit we2)))))

(define-prim (##write-with-style
              obj
              port
              max-length
              force?
              style)
  (if (macro-character-output-port? port)
      (begin
        (##write-generic-to-character-port
         style
         port
         (macro-character-port-output-readtable port)
         force?
         max-length
         obj)
        (##void))
      ((macro-object-port-write-datum port) port obj #f)))

(define-prim (##write
              obj
              #!optional
              (port (macro-current-output-port))
              (max-length ##max-fixnum)
              (force? (macro-if-auto-forcing #t #f)))
  (##write-with-style
   obj
   port
   max-length
   force?
   'write))

(define-prim (write
              obj
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (obj port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-object-output-port p 2 (write obj p)
        (##write obj p)))))

(define-prim (##write-shared
              obj
              #!optional
              (port (macro-current-output-port))
              (max-length ##max-fixnum)
              (force? (macro-if-auto-forcing #t #f)))
  (##write-with-style
   obj
   port
   max-length
   force?
   'write-shared))

(define-prim (write-shared
              obj
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (obj port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-object-output-port p 2 (write-shared obj p)
        (##write-shared obj p)))))

(define-prim (##write-simple
              obj
              #!optional
              (port (macro-current-output-port))
              (max-length ##max-fixnum)
              (force? (macro-if-auto-forcing #t #f)))
  (##write-with-style
   obj
   port
   max-length
   force?
   'write-simple))

(define-prim (write-simple
              obj
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (obj port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-object-output-port p 2 (write-simple obj p)
        (##write-simple obj p)))))

(define-prim (##display
              obj
              #!optional
              (port (macro-current-output-port))
              (max-length ##max-fixnum)
              (force? (macro-if-auto-forcing #t #f)))
  (##write-generic-to-character-port
   'display
   port
   (macro-character-port-output-readtable port)
   force?
   max-length
   obj)
  (##void))

(define-prim (display
              obj
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (obj port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-character-output-port p 2 (display obj p)
        (##display obj p)))))

(define-prim (##pretty-print
              obj
              #!optional
              (port (macro-current-output-port))
              (max-length ##max-fixnum)
              (force? (macro-if-auto-forcing #t #f)))
  (##write-generic-to-character-port
   'pretty-print
   port
   (macro-character-port-output-readtable port)
   force?
   max-length
   obj)
  (##newline port))

(define-prim (pretty-print
              obj
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (obj port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-character-output-port p 2 (pretty-print obj p)
        (##pretty-print obj p)))))

(define-prim (##print-aux
              obj
              #!optional
              (port (macro-current-output-port))
              (max-length ##max-fixnum)
              (force? (macro-if-auto-forcing #t #f)))
  (##write-generic-to-character-port
   'print
   port
   (macro-character-port-output-readtable port)
   force?
   max-length
   obj)
  (##void))

(macro-case-target

 ((C js python)

(define-prim (##print
              #!key (port (macro-current-output-port))
              #!rest body)
  (##print-aux body port))

(define-prim (print
              #!key (port (macro-absent-obj))
              #!rest body)
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-character-output-port p 2 (print port: p . body)
        (##print-aux body p)))))

(define-prim (##println
              #!key (port (macro-current-output-port))
              #!rest body)
  (##print-aux body port)
  (##newline port))

(define-prim (println
              #!key (port (macro-absent-obj))
              #!rest body)
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-character-output-port p 2 (println port: p . body)
        (begin
          (##print-aux body p)
          (##newline p))))))

))

(define-prim (##newline1 port)
  (##declare (not interrupts-enabled))
  ((macro-object-port-newline port) port))

(define-prim (##newline0)
  (##newline1 (macro-current-output-port)))

(define-prim (##newline
              #!optional
              (port (macro-absent-obj)))
  (if (##eq? port (macro-absent-obj))
      (##newline0)
      (##newline1 port)))

(define-prim (newline
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-object-output-port p 1 (newline p)
        (##newline p)))))

(define-prim (##flush-input-buffering port)
  (##declare (not interrupts-enabled))
  (macro-character-port-peek-eof?-set! port #f)
  (macro-character-port-rlo-set! port (macro-character-port-rhi port))
  (if (macro-byte-input-port? port)
      (macro-byte-port-rlo-set! port (macro-byte-port-rhi port)))
  (##void))

(define-prim (##force-output
              #!optional
              (port (macro-current-output-port))
              (level (macro-absent-obj)))
  (##declare (not interrupts-enabled))
  ((macro-object-port-force-output port)
   port
   (if (##eq? level (macro-absent-obj)) 0 level)
   force-output
   port
   level
   (macro-absent-obj)
   (macro-absent-obj)))

(define-prim (##force-output-catching-exceptions port)

  ;; Ignoring exceptions helps avoid infinite loops when forcing the
  ;; output of predefined ports at program exit (for example the
  ;; disk might be full while forcing stdout redirected to a file
  ;; and an attempt to write an error message on stdout for this
  ;; exception would also raise an exception).
  ;; Also avoid installing exception catcher when thread system
  ;; is not yet initialized.

  (if (macro-current-thread)
      (##with-exception-catcher
       (lambda (e) #f)
       (lambda ()
         (##force-output port)))))

(define-prim (force-output
              #!optional
              (port (macro-absent-obj))
              (level (macro-absent-obj)))
  (macro-force-vars (port level)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-object-output-port
        p
        1
        (force-output p level)
        (if (##eq? level (macro-absent-obj))
            (##force-output p)
            (macro-check-index-range-incl
              level
              2
              0
              2
              (force-output p level)
              (##force-output p level)))))))

(define-prim (flush-output-port
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-object-output-port
        p
        1
        (flush-output-port p)
        (##force-output p)))))

(define-prim (##wait-input-port port)

  ;; The thread will wait until there is data available to read on the
  ;; port's device or the port's timeout is reached.  The value #f is
  ;; returned when the timeout is reached.  The value #t is returned
  ;; when there is data available to read on the port's device or the
  ;; thread was interrupted (for example with thread-interrupt!).

  ;; It is assumed that the thread **does not** have exclusive
  ;; access to the port.

  (##declare (not interrupts-enabled))

  ((macro-port-wait port) port (macro-direction-in)))

;;(define-prim (wait-input-port port)
;;  (macro-force-vars (port)
;;    (macro-check-input-port port 1 (wait-input-port port)
;;      (##wait-input-port port))))

(define-prim (##wait-output-port port)

  ;; Complement to ##wait-input-port .

  ;; The thread will wait until the port's device is writeable in the
  ;; sense that more data can be written to it, or the port's timeout
  ;; is reached.  The value #f is returned when the timeout is reached.
  ;; The value #t is returned when the port's device is writeable or
  ;; the thread was interrupted (for example with thread-interrupt!).

  ;; An example of when a port is not writeable is when a TCP client
  ;; port has full OS transmit buffers. For such a port, a
  ;; ##wait-output-port on it will return when space has
  ;; become available in the buffers.
  ;;
  ;; Additionally, waiting for writability on a TCP client port is a way
  ;; to ensure that the connection has been established at all in the
  ;; first place. This may be of relevance to determine in some lowlevel
  ;; use scenarios, as Gambit does TCP connect:s asynchronously in such
  ;; a way that open-tcp-client returns the TCP client port object
  ;; actually prior to the connection having been established.

  (##declare (not interrupts-enabled))

  ((macro-port-wait port) port (macro-direction-out)))

;;(define-prim (wait-output-port port)
;;  (macro-force-vars (port)
;;    (macro-check-output-port port 1 (wait-output-port port)
;;      (##wait-output-port port))))

;;TODO: deprecated interface
(define-prim (##device-port-wait-for-input! port)
  (##declare (not interrupts-enabled))
  (##wait-input-port port))

;;TODO: deprecated interface
(define-prim (##device-port-wait-for-output! port)
  (##declare (not interrupts-enabled))
  (##wait-output-port port))

(define-prim (##close-input-port port)
  (##declare (not interrupts-enabled))
  ((macro-port-close port) port close-input-port port))

(define-prim (close-input-port port)
  (macro-force-vars (port)
    (macro-check-input-port port 1 (close-input-port port)
      (##close-input-port port))))

(define-prim (##close-output-port port)
  (##declare (not interrupts-enabled))
  ((macro-port-close port) port close-output-port port))

(define-prim (close-output-port port)
  (macro-force-vars (port)
    (macro-check-output-port port 1 (close-output-port port)
      (##close-output-port port))))

(define-prim (##close-port port)
  (##declare (not interrupts-enabled))
  ((macro-port-close port) port close-port port))

(define-prim (close-port port)
  (macro-force-vars (port)
    (macro-check-port port 1 (close-port port)
      (##close-port port))))

(define-prim (input-port-open? port)
  (macro-force-vars (port)
    (macro-check-input-port port 1 (input-port-open? port)
      #t))) ;; in general, it is not possible to know if a port is "open"

(define-prim (output-port-open? port)
  (macro-force-vars (port)
    (macro-check-output-port port 1 (output-port-open? port)
      #t))) ;; in general, it is not possible to know if a port is "open"

(define-prim (##input-port-readtable port)
  (macro-character-port-input-readtable port))

(define-prim (input-port-readtable port)
  (macro-force-vars (port)
    (macro-check-character-input-port port 1 (input-port-readtable port)
      (##input-port-readtable port))))

(define-prim (##input-port-readtable-set! port rt)
  (macro-character-port-input-readtable-set! port rt)
  (##void))

(define-prim (input-port-readtable-set! port rt)
  (macro-force-vars (port rt)
    (macro-check-character-input-port port 1 (input-port-readtable-set! port rt)
      (macro-check-readtable rt 2 (input-port-readtable-set! port rt)
        (##input-port-readtable-set! port rt)))))

(define-prim (##output-port-readtable port)
  (macro-character-port-output-readtable port))

(define-prim (output-port-readtable port)
  (macro-force-vars (port)
    (macro-check-character-output-port port 1 (output-port-readtable port)
      (##output-port-readtable port))))

(define-prim (##output-port-readtable-set! port rt)
  (macro-character-port-output-readtable-set! port rt)
  (##void))

(define-prim (output-port-readtable-set! port rt)
  (macro-force-vars (port rt)
    (macro-check-character-output-port port 1 (output-port-readtable-set! port rt)
      (macro-check-readtable rt 2 (output-port-readtable-set! port rt)
        (##output-port-readtable-set! port rt)))))

(define-prim (##input-port-timeout-set!
              port
              absrel-timeout
              #!optional
              (thunk (lambda () #f)))
  (##declare (not interrupts-enabled))
  (let ((timeout (##absrel-timeout->timeout absrel-timeout)))
    ((macro-port-set-rtimeout port) port timeout thunk)))

(define-prim (input-port-timeout-set!
              port
              absrel-timeout
              #!optional
              (t (macro-absent-obj)))
  (macro-force-vars (port absrel-timeout t)
    (macro-check-input-port
      port
      1
      (input-port-timeout-set! port absrel-timeout t)
      (macro-check-absrel-time-or-false
        absrel-timeout
        2
        (input-port-timeout-set! port absrel-timeout t)
        (if (##eq? t (macro-absent-obj))
            (##input-port-timeout-set! port absrel-timeout t)
            (macro-check-procedure
              t
              3
              (input-port-timeout-set! port absrel-timeout t)
              (##input-port-timeout-set! port absrel-timeout t)))))))

(define-prim (##output-port-timeout-set!
              port
              absrel-timeout
              #!optional
              (thunk (lambda () #f)))
  (##declare (not interrupts-enabled))
  (let ((timeout (##absrel-timeout->timeout absrel-timeout)))
    ((macro-port-set-wtimeout port) port timeout thunk)))

(define-prim (output-port-timeout-set!
              port
              absrel-timeout
              #!optional
              (t (macro-absent-obj)))
  (macro-force-vars (port absrel-timeout t)
    (macro-check-output-port
      port
      1
      (output-port-timeout-set! port absrel-timeout t)
      (macro-check-absrel-time-or-false
        absrel-timeout
        2
        (output-port-timeout-set! port absrel-timeout t)
        (if (##eq? t (macro-absent-obj))
            (##output-port-timeout-set! port absrel-timeout)
            (macro-check-procedure
              t
              3
              (output-port-timeout-set! port absrel-timeout t)
              (##output-port-timeout-set! port absrel-timeout t)))))))

(define-prim (##port-io-exception-handler-set! port handler)
  (##declare (not interrupts-enabled))
  (macro-port-io-exception-handler-set! port handler)
  (##void))

(define-prim (port-io-exception-handler-set! port handler)
  (macro-force-vars (port handler)
    (macro-check-port
      port
      1
      (port-io-exception-handler-set! port handler)
      (macro-check-procedure
        handler
        2
        (port-io-exception-handler-set! port handler)
        (##port-io-exception-handler-set! port handler)))))

(define-prim (##input-port-char-position port)
  (##fx+ (macro-character-port-rchars port)
         (macro-character-port-rlo port)))

(define-prim (input-port-char-position port)
  (macro-force-vars (port)
    (macro-check-character-input-port
      port
      1
      (input-port-char-position port)
      (##input-port-char-position port))))

(define-prim (##output-port-char-position port)
  (##fx+ (macro-character-port-wchars port)
         (macro-character-port-whi port)))

(define-prim (output-port-char-position port)
  (macro-force-vars (port)
    (macro-check-character-output-port
      port
      1
      (output-port-char-position port)
      (##output-port-char-position port))))

(define-prim (##input-port-line-set! port line)
  (##declare (not interrupts-enabled))
  (macro-character-port-rlines-set! port (##fx- line 1)))

(define-prim (##input-port-line port)
  (##declare (not interrupts-enabled))
  (##fx+ (macro-character-port-rlines port) 1))

(define-prim (input-port-line port)
  (macro-force-vars (port)
    (macro-check-character-input-port port 1 (input-port-line port)
      (##input-port-line port))))

(define-prim (##input-port-column-set! port col)
  (##declare (not interrupts-enabled))
  (macro-character-port-rcurline-set!
   port
   (##fx+ (##fx- (##fx+ (macro-character-port-rchars port)
                        (macro-character-port-rlo port))
                 col)
          1)))

(define-prim (##input-port-column port)
  (##declare (not interrupts-enabled))
  (##fx+ (##fx- (##fx+ (macro-character-port-rchars port)
                       (macro-character-port-rlo port))
                (macro-character-port-rcurline port))
         1))

(define-prim (input-port-column port)
  (macro-force-vars (port)
    (macro-check-character-input-port port 1 (input-port-column port)
      (##input-port-column port))))

(define-prim (##output-port-line-set! port line)
  (##declare (not interrupts-enabled))
  (macro-character-port-wlines-set! port (##fx- line 1)))

(define-prim (##output-port-line port)
  (##declare (not interrupts-enabled))
  (##fx+ (macro-character-port-wlines port) 1))

(define-prim (output-port-line port)
  (macro-force-vars (port)
    (macro-check-character-output-port port 1 (output-port-line port)
      (##output-port-line port))))

(define-prim (##output-port-column-set! port col)
  (##declare (not interrupts-enabled))
  (macro-character-port-wcurline-set!
   port
   (##fx+ (##fx- (##fx+ (macro-character-port-wchars port)
                        (macro-character-port-whi port))
                 col)
          1)))

(define-prim (##output-port-column port)
  (##declare (not interrupts-enabled))
  (##fx+ (##fx- (##fx+ (macro-character-port-wchars port)
                       (macro-character-port-whi port))
                (macro-character-port-wcurline port))
         1))

(define-prim (output-port-column port)
  (macro-force-vars (port)
    (macro-check-character-output-port port 1 (output-port-column port)
      (##output-port-column port))))

(define-prim (##output-port-width port)
  (##declare (not interrupts-enabled))
  ((macro-character-port-output-width port) port))

(define-prim (output-port-width port)
  (macro-force-vars (port)
    (macro-check-character-output-port port 1 (output-port-width port)
      (##output-port-width port))))

(define-prim (##object->truncated-string
              obj
              max-length
              #!optional
              (char-encoding-limit (macro-absent-obj)))
  (let* ((port
          (##open-output-string))
         (we
          (##make-writeenv
           'write
           port
           (macro-character-port-output-readtable port)
           #f
           (macro-if-auto-forcing #t #f)
           0
           0
           0
           0
           max-length
           (cond ((##char? char-encoding-limit)
                  char-encoding-limit)
                 ((macro-output-port? char-encoding-limit)
                  (macro-max-unescaped-char
                   (macro-port-woptions char-encoding-limit)))
                 ((macro-readtable? char-encoding-limit)
                  (macro-readtable-max-unescaped-char char-encoding-limit))
                 (else
                  (##integer->char ##max-char))))))
    (##wr we obj)
    (##get-output-string port)))

(define-prim (##object->string-with-sn
              obj
              max-length
              #!optional
              (char-encoding-limit (macro-absent-obj))
              (min-length 0)
              (actual-obj obj))
  (let* ((ml
          (##fxmax max-length min-length))
         (str
          (##object->string
           obj
           (##fx+ ml 1)
           char-encoding-limit)))
    (if (##fx<= (##string-length str) ml)
        str
        (let* ((sn
                (##number->string
                 (##object->serial-number actual-obj)))
               (max-length2
                (##fxmax
                 (##fx- max-length
                        (##fx+ 2
                               (##string-length sn)))
                 min-length)))
          (##string-append
           (##force-limited-string! str max-length2)
           " #"
           sn)))))

(define-prim (##object->string
              obj
              #!optional
              (max-length ##max-fixnum)
              (char-encoding-limit (macro-absent-obj)))
  (if (##fx< 0 max-length)
      (let ((str
             (##object->truncated-string
              obj
              (if (##fx< max-length ##max-fixnum)
                  (##fx+ max-length 1)
                  ##max-fixnum)
              char-encoding-limit)))
        (##string->limited-string str max-length))
      (##string)))

(define-prim (object->string
              obj
              #!optional
              (ml (macro-absent-obj)))
  (macro-force-vars (obj ml)
    (if (##eq? ml (macro-absent-obj))
        (##object->string obj)
        (let ()

          (define (type-error)
            (##fail-check-exact-integer 2 object->string obj ml))

          (define (range-error)
            (##raise-range-exception 2 object->string obj ml))

          (if (macro-exact-int? ml)
              (if (or (##not (##fixnum? ml)) (##fxnegative? ml))
                  (range-error)
                  (##object->string obj ml))
              (type-error))))))

(define-prim (##string->limited-string str max-length)
  (if (##fx< max-length (##string-length str))
      (##force-limited-string! (##substring str 0 max-length) max-length)
      str))

(define-prim (##force-limited-string! str max-length)
  (if (##fx< 0 max-length)
      (begin
        (##string-set! str (##fx- max-length 1) #\.)
        (if (##fx< 1 max-length)
            (begin
              (##string-set! str (##fx- max-length 2) #\.)
              (if (##fx< 2 max-length)
                  (##string-set! str (##fx- max-length 3) #\.))))))
  (##string-shrink! str max-length)
  str)

;;;----------------------------------------------------------------------------

;;; Implementation of generic char port procedures.

(define-prim (##input-port-characters-buffered port)

  (##declare (not interrupts-enabled))

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let* ((char-rlo
          (macro-character-port-rlo port))
         (char-rhi
          (macro-character-port-rhi port))
         (characters-buffered
          (if (macro-character-port-peek-eof? port)
              1
              (##fx- char-rhi char-rlo))))
    (macro-port-mutex-unlock! port)
    characters-buffered))

(define-prim (input-port-characters-buffered port)
  (macro-force-vars (port)
    (macro-check-character-input-port
      port
      1
      (input-port-characters-buffered port)
      (##input-port-characters-buffered port))))

(##define-macro (macro-char-input-port-cache-fill port)
  `(macro-case-target
    ((C)
     (##c-code
      "___ps->type_cache[___CHAR_INPUT_PORT_TYPE_CACHE] = ___ARG1;"
      (##structure-type ,port)))
    (else
     #f)))

(##define-macro (macro-char-output-port-cache-fill port)
  `(macro-case-target
    ((C)
     (##c-code
      "___ps->type_cache[___CHAR_OUTPUT_PORT_TYPE_CACHE] = ___ARG1;"
      (##structure-type ,port)))
    (else
     #f)))

(define-prim (##char-input-port?-cached obj)
  (macro-character-input-port? obj))

(define-prim (##char-output-port?-cached obj)
  (macro-character-output-port? obj))

(define-prim (##char-ready?1 port)

  (##declare (not interrupts-enabled))

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (if (macro-character-port-peek-eof? port)

      (begin
        (macro-port-mutex-unlock! port)
        #t)

      (let ((char-rlo (macro-character-port-rlo port))
            (char-rhi (macro-character-port-rhi port)))
        (if (##fx< char-rlo char-rhi)
            (begin
              (macro-port-mutex-unlock! port)
              #t)
            (let ((code ((macro-character-port-rbuf-fill port)
                         port
                         1
                         #f)))
              (if (##fixnum? code)
                  (if (##fx= code ##err-code-EAGAIN)
                      (begin
                        (macro-port-mutex-unlock! port)
                        #f) ;; a call to read-char would block
                      (begin
                        (macro-port-mutex-unlock! port)
                        (##raise-os-io-exception port #f code char-ready? port)))
                  (begin
                    (if (##not code)
                        (macro-character-port-peek-eof?-set! port #t))
                    (macro-port-mutex-unlock! port)
                    #t)))))))

(define-prim (##char-ready?0)
  (##char-ready?1 (macro-current-input-port)))

(define-prim (##char-ready?
              #!optional
              (port (macro-absent-obj)))
  (if (##eq? port (macro-absent-obj))
      (##char-ready?0)
      (##char-ready?1 port)))

(define-prim (char-ready?
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
      (macro-check-character-input-port p 1 (char-ready? p)
        (begin
          (macro-char-input-port-cache-fill p)
          (##char-ready?1 p))))))

(define-prim (##peek-char1 port)

  (##declare (not interrupts-enabled))

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let loop ()

    (let ((char-rlo (macro-character-port-rlo port))
          (char-rhi (macro-character-port-rhi port)))
      (if (##fx< char-rlo char-rhi)

          ;; the next character is in the character read buffer

          (let ((c (##string-ref (macro-character-port-rbuf port) char-rlo)))
            (macro-port-mutex-unlock! port)
            c)

          (if (macro-character-port-peek-eof? port)

              (begin
                (macro-port-mutex-unlock! port)
                #!eof)

              ;; try to get more characters into the character read
              ;; buffer, and try again if successful otherwise
              ;; signal an error or return end-of-file object

              (let ((code ((macro-character-port-rbuf-fill port)
                           port
                           1
                           #t)))

                (cond ((##fixnum? code)

                       ;; the conversion or read caused an error

                       (if (##fx= code ##err-code-EAGAIN)
                           (begin
                             (macro-character-port-peek-eof?-set! port #t)
                             (macro-port-mutex-unlock! port)
                             #!eof) ;; the read timeout thunk returned #f
                           (begin
                             (macro-port-mutex-unlock! port)
                             (##raise-os-io-exception port #f code peek-char port))))

                      (code

                       ;; some characters were added to char buffer

                       (loop))

                      (else

                       ;; no characters were added to char buffer

                       (macro-character-port-peek-eof?-set! port #t)
                       (macro-port-mutex-unlock! port)
                       #!eof))))))))

(define-prim (##peek-char1? port)
  #f)

(define-prim (##peek-char0)
  (##peek-char1 (macro-current-input-port)))

(define-prim (##peek-char0?)
  (##peek-char1? (macro-current-input-port)))

(define-prim (##peek-char
              #!optional
              (port (macro-absent-obj)))
  (if (##eq? port (macro-absent-obj))
      (##peek-char0)
      (##peek-char1 port)))

(define-prim (peek-char
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
      (macro-check-character-input-port p 1 (peek-char p)
        (begin
          (macro-char-input-port-cache-fill p)
          (##peek-char1 p))))))

(define-prim (##read-char1 port)

  (##declare (not interrupts-enabled))

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let loop ()

    (let ((char-rlo (macro-character-port-rlo port))
          (char-rhi (macro-character-port-rhi port)))
      (if (##fx< char-rlo char-rhi)

          ;; the next character is in the character read buffer

          (let ((c (##string-ref (macro-character-port-rbuf port) char-rlo)))
            (if (##not (##char=? c #\newline))

                ;; frequent simple case, just advance rlo

                (begin
                  (macro-character-port-rlo-set! port (##fx+ char-rlo 1))
                  (macro-port-mutex-unlock! port)
                  c)

                ;; end-of-line processing requires updating counters

                (let ((char-rlo+1 (##fx+ char-rlo 1)))

                  ;; advance rlo

                  (macro-character-port-rlo-set! port char-rlo+1)

                  ;; keep track of number of characters read

                  (let ((char-rchars (macro-character-port-rchars port)))
                    (macro-character-port-rcurline-set! port
                                                        (##fx+ char-rchars char-rlo+1)))

                  ;; keep track of number of lines read

                  (let ((char-rlines (macro-character-port-rlines port)))
                    (macro-character-port-rlines-set! port
                                                      (##fx+ char-rlines 1)))

                  (macro-port-mutex-unlock! port)
                  #\newline)))

          (if (macro-character-port-peek-eof? port)

              (begin
                (macro-character-port-peek-eof?-set! port #f)
                (macro-port-mutex-unlock! port)
                #!eof)

              ;; try to get more characters into the character read
              ;; buffer, and try again if successful otherwise
              ;; signal an error or return end-of-file object

              (let ((code ((macro-character-port-rbuf-fill port)
                           port
                           1
                           #t)))

                (cond ((##fixnum? code)

                       ;; the conversion or read caused an error

                       (macro-port-mutex-unlock! port)
                       (if (##fx= code ##err-code-EAGAIN)
                           #!eof ;; the read timeout thunk returned #f
                           (##raise-os-io-exception port #f code read-char port)))

                      (code

                       ;; some characters were added to char buffer

                       (loop))

                      (else

                       ;; no characters were added to char buffer

                       (macro-port-mutex-unlock! port)
                       #!eof))))))))

(define-prim (##read-char1? port)
  #f)

(define-prim (##read-char0)
  (##read-char1 (macro-current-input-port)))

(define-prim (##read-char0?)
  (##read-char1? (macro-current-input-port)))

(define-prim (##read-char
              #!optional
              (port (macro-absent-obj)))
  (if (##eq? port (macro-absent-obj))
      (##read-char0)
      (##read-char1 port)))

(define-prim (read-char
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
      (macro-check-character-input-port p 1 (read-char p)
        (begin
          (macro-char-input-port-cache-fill p)
          (##read-char1 p))))))

(define-prim (##read-substring
              str
              start
              end
              #!optional
              (port (macro-current-input-port))
              (need (macro-absent-obj))
              (raise-os-exception? #t))

  (##declare (not interrupts-enabled))

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let loop ((n 0))
    (let ((remaining (##fx- end (##fx+ start n))))
      (if (##not (##fx< 0 remaining))
          (begin
            (macro-port-mutex-unlock! port)
            n)
          (let* ((char-rlo
                  (macro-character-port-rlo port))
                 (char-rhi
                  (macro-character-port-rhi port))
                 (chars-buffered
                  (##fx- char-rhi char-rlo)))
            (if (##fx< 0 chars-buffered)

                (let* ((to-transfer
                        (##fxmin remaining chars-buffered))
                       (limit
                        (##fx+ char-rlo to-transfer))
                       (char-rbuf
                        (macro-character-port-rbuf port)))
                  (macro-character-port-rlo-set! port limit)
                  (##substring-move!
                   char-rbuf
                   char-rlo
                   limit
                   str
                   (##fx+ start n))
                  (let loop2 ((rlo char-rlo))
                    (if (##fx< rlo limit)
                        (let ((c (##string-ref char-rbuf rlo))
                              (rlo+1 (##fx+ rlo 1)))

                          (if (##char=? c #\newline)
                              (begin

                                ;; keep track of number of characters read

                                (let ((char-rchars
                                       (macro-character-port-rchars port)))
                                  (macro-character-port-rcurline-set! port
                                                                      (##fx+ char-rchars rlo+1)))

                                ;; keep track of number of lines read

                                (let ((char-rlines
                                       (macro-character-port-rlines port)))
                                  (macro-character-port-rlines-set! port
                                                                    (##fx+ char-rlines 1)))))

                          (loop2 rlo+1))))
                  (loop (##fx+ n to-transfer)))

                (let ((code
                       ((macro-character-port-rbuf-fill port)
                        port
                        remaining
                        (or (##not (##fixnum? need))
                            (##fx< n need)))))
                  (cond ((##fixnum? code)

                         ;; an error occurred, signal an error if no
                         ;; chars were previously transferred from char
                         ;; buffer and (in the case of a read timeout)
                         ;; the timeout thunk returned #f

                         (macro-port-mutex-unlock! port)

                         (if (or (##fx< 0 n)
                                 (##fx= code ##err-code-EAGAIN))
                             n
                             (if raise-os-exception?
                                 (##raise-os-io-exception
                                  port
                                  #f
                                  code
                                  read-substring
                                  str
                                  start
                                  end
                                  port
                                  need)
                                 code)))

                        (code

                         ;; chars were added to char buffer, so try again
                         ;; to transfer chars from the char buffer

                         (loop n))

                        (else

                         ;; no chars were added to char buffer
                         ;; (end-of-file was reached)

                         (macro-port-mutex-unlock! port)
                         n)))))))))

(define-prim (read-substring
              str
              start
              end
              #!optional
              (port (macro-absent-obj))
              (need (macro-absent-obj)))
  (macro-force-vars (str start end port need)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
      (macro-check-string
        str
        1
        (read-substring str start end port need)
        (macro-check-mutable
          str
          1
          (read-substring str start end port need)
          (macro-check-index-range-incl
            start
            2
            0
            (##string-length str)
            (read-substring str start end port need)
            (macro-check-index-range-incl
              end
              3
              start
              (##string-length str)
              (read-substring str start end port need)
              (macro-check-character-input-port
                p
                4
                (read-substring str start end port need)
                (if (##eq? need (macro-absent-obj))
                    (##read-substring str start end p)
                    (macro-check-index
                      need
                      5
                      (read-substring str start end port need)
                      (##read-substring str start end p need)))))))))))

(define-prim (read-string
              k
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (k port)
    (macro-check-index
      k
      1
      (read-string k port)
      (let* ((p
              (if (##eq? port (macro-absent-obj))
                  (macro-current-input-port)
                  port))
             (str
              (##make-string k))
             (n
              (##read-substring str 0 k p #f #f)))
        (cond ((##fx> n 0)
               (##string-shrink! str n)
               str)
              ((##fx= n 0)
               #!eof)
              (else
               (##raise-os-io-exception port #f n read-string k port)))))))

(define-prim (##read-line
              #!optional
              (port (macro-current-input-port))
              (separator #\newline)
              (include-separator? #f)
              (max-length ##max-fixnum))

  (define max-chunk-length 512)

  (define (read-chunk i ml)
    (if (##char? separator)
        (let loop ((i i))
          (if (##fx< i ml)
              (let ((c (macro-read-char port)))
                (if (##char? c)
                    (if (##eq? c separator) ;; note: separator is a char or #f
                        (if include-separator?
                            (let ((s (##make-string (##fx+ i 1))))
                              (##string-set! s i c)
                              s)
                            (##make-string i))
                        (let ((s (loop (##fx+ i 1))))
                          (##string-set! s i c)
                          s))
                    (##make-string i)))
              (##make-string i)))
        (let ((s (##make-string ml)))
          (let ((n (##read-substring s i ml port #f)))
            (##string-shrink! s (##fx+ i n))
            s))))

  (if (##fx< 0 max-length)
      (let ((first (macro-read-char port)))

        (define (start)
          (let* ((ml max-length)
                 (m1 (##fxmin ml max-chunk-length))
                 (chunk1 (read-chunk 1 m1)))
            (##string-set! chunk1 0 first)
            (if (or (##fx< (##string-length chunk1) m1)
                    (##eq? (##string-ref chunk1 (##fx- m1 1)) ;; note: separator is a char or #f
                           separator)
                    (##fx= ml m1))
                chunk1
                (let loop ((ml (##fx- ml m1))
                           (chunks (##list chunk1)))
                  (let* ((m2 (##fxmin ml max-chunk-length))
                         (new-chunk (read-chunk 0 m2))
                         (new-chunks (##cons new-chunk chunks)))
                    (if (or (##fx< (##string-length new-chunk) m2)
                            (##eq? (##string-ref new-chunk (##fx- m2 1)) ;; note: separator is a char or #f
                                   separator)
                            (##fx= ml m2))
                        (##string-concatenate (##reverse new-chunks))
                        (loop (##fx- ml m2)
                              new-chunks)))))))

        (if (##char? first)
            (if (##eq? first separator) ;; note: separator is a char or #f
                (if include-separator?
                    (##string first)
                    (##string))
                (start))
            first))
      (##string)))

(define-prim (read-line
              #!optional
              (port (macro-absent-obj))
              (separator (macro-absent-obj))
              (include-separator? (macro-absent-obj))
              (max-length (macro-absent-obj)))
  (macro-force-vars (port separator include-separator? max-length)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port))
          (sep
           (if (##eq? separator (macro-absent-obj))
               #\newline
               separator))
          (inc-sep?
           (if (##eq? include-separator? (macro-absent-obj))
               #f
               include-separator?))
          (ml
           (if (##eq? max-length (macro-absent-obj))
               ##max-fixnum
               max-length)))
      (macro-check-character-input-port
        p
        1
        (read-line port separator include-separator? max-length)
        (macro-check-index
          ml
          4
          (read-line port separator include-separator? max-length)
          (##read-line p sep inc-sep? ml))))))

(define-prim (##read-all
              #!optional
              (port-or-readenv (macro-current-input-port))
              (reader ##read))
  (let ((fifo (macro-make-fifo)))
    (let loop ()
      (let ((obj (reader port-or-readenv)))
        (if (##eof-object? obj)
            (macro-fifo->list fifo)
            (begin
              (macro-fifo-insert-at-tail! fifo obj)
              (loop)))))))

(define-prim (read-all
              #!optional
              (port (macro-absent-obj))
              (reader (macro-absent-obj)))
  (macro-force-vars (port reader)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port))
          (r
           (if (##eq? reader (macro-absent-obj))
               ##read
               reader)))
      (macro-check-object-input-port p 1 (read-all port reader)
        (macro-check-procedure r 2 (read-all port r)
          (##read-all p r))))))

(define-prim (##write-char2 c port)

  (##declare (not interrupts-enabled))

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let loop ()

    (let ((char-wbuf (macro-character-port-wbuf port))
          (char-whi+1 (##fx+ (macro-character-port-whi port) 1)))
      (if (##not (##fx< (##string-length char-wbuf) char-whi+1))

          ;; there is enough space in the character write buffer, so add
          ;; character and increment whi

          (let ()

            (##string-set! char-wbuf (##fx- char-whi+1 1) c)

            ;; advance whi

            (macro-character-port-whi-set! port char-whi+1)

            (if (##not (##char=? c #\newline))

                ;; force output if port is set for unbuffered output

                (if (macro-unbuffered? (macro-port-woptions port))
                    (begin
                      (macro-port-mutex-unlock! port)
                      ((macro-object-port-force-output port)
                       port
                       0
                       write-char
                       c
                       port
                       (macro-absent-obj)
                       (macro-absent-obj)))
                    (begin
                      (macro-port-mutex-unlock! port)
                      (##void)))

                ;; end-of-line processing requires updating counters

                (begin

                  ;; keep track of number of characters written

                  (let ((char-wchars (macro-character-port-wchars port)))
                    (macro-character-port-wcurline-set! port
                                                        (##fx+ char-wchars char-whi+1)))

                  ;; keep track of number of lines written

                  (let ((char-wlines (macro-character-port-wlines port)))
                    (macro-character-port-wlines-set! port
                                                      (##fx+ char-wlines 1)))

                  ;; force output if port is not fully buffered

                  (if (##not (macro-fully-buffered?
                              (macro-port-woptions port)))
                      (begin
                        (macro-port-mutex-unlock! port)
                        ((macro-object-port-force-output port)
                         port
                         0
                         write-char
                         c
                         port
                         (macro-absent-obj)
                         (macro-absent-obj)))
                      (begin
                        (macro-port-mutex-unlock! port)
                        (##void))))))

          ;; make some space in the character buffer and try again

          (let ((code3 ((macro-character-port-wbuf-drain port) port)))
            (if (##fixnum? code3)
                (begin
                  (macro-port-mutex-unlock! port)
                  (if (##fx= code3 ##err-code-EAGAIN)
                      #f
                      (##raise-os-io-exception port #f code3 write-char c port)))
                (loop)))))))

(define-prim (##write-char2? c port)

  (##declare (not interrupts-enabled))

  (if (or (##char=? c #\newline)
          (macro-unbuffered? (macro-port-woptions port)))
      #f
      (let ((char-wbuf (macro-character-port-wbuf port))
            (char-whi+1 (##fx+ (macro-character-port-whi port) 1)))
        (if (##not (##fx< (##string-length char-wbuf) char-whi+1))

            (begin

              ;; there is enough space in the character write buffer, so add
              ;; character and increment whi

              (##string-set! char-wbuf (##fx- char-whi+1 1) c)

              (macro-character-port-whi-set! port char-whi+1)

              #t)

            ;; there is insufficient space in the character write
            ;; buffer so bail out (this normally will call ##write-char)

            #f))))

(define-prim (##write-char1 c)
  (##write-char2 c (macro-current-output-port)))

(define-prim (##write-char1? c)
  (##write-char2? c (macro-current-output-port)))

(define-prim (##write-char
              c
              #!optional
              (port (macro-absent-obj)))
  (if (##eq? port (macro-absent-obj))
      (##write-char1 c)
      (##write-char2 c port)))

(define-prim (write-char
              c
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (c port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-char c 1 (write-char c port)
        (macro-check-character-output-port p 2 (write-char c p)
          (begin
            (macro-char-output-port-cache-fill p)
            (##write-char2 c p)))))))

(define-prim (##write-substring str start end port)

  (##declare (not interrupts-enabled))

  (if (##not (macro-fully-buffered?
              (macro-port-woptions port)))

      (let loop ((i start))
        (if (##fx< i end)
            (begin
              (macro-write-char (##string-ref str i) port)
              (let ()
                (##declare (interrupts-enabled))
                (loop (##fx+ i 1))))
            (##void)))

      (begin

        (macro-port-mutex-lock! port) ;; get exclusive access to port

        (let loop ((i start))
          (if (##fx< i end)
              (let* ((char-wbuf (macro-character-port-wbuf port))
                     (char-whi (macro-character-port-whi port))
                     (n (##fxmin (##fx- end i)
                                 (##fx- (##string-length char-wbuf) char-whi))))
                (if (##fx< 0 n)

                    ;; there is enough space in the character write buffer to
                    ;; write n characters, so do that and increment whi

                    (let ((i+n (##fx+ i n)))

                      (##substring-move!
                       str
                       i
                       i+n
                       char-wbuf
                       char-whi)

                      ;; advance whi

                      (macro-character-port-whi-set! port (##fx+ char-whi n))

                      (loop i+n))

                    ;; make some space in the character buffer and try again

                    (let ((code ((macro-character-port-wbuf-drain port) port)))
                      (if (##fixnum? code)
                          (begin
                            (macro-port-mutex-unlock! port)
                            (if (##fx= code ##err-code-EAGAIN)
                                #f
                                (##raise-os-io-exception port #f code write-substring str start end port)))
                          (loop i)))))

              (begin
                (macro-port-mutex-unlock! port)
                (##void)))))))

(define-prim (write-substring
              str
              start
              end
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (str start end port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-string str 1 (write-substring str start end port)
        (macro-check-index-range-incl
          start
          2
          0
          (##string-length str)
          (write-substring str start end port)
          (macro-check-index-range-incl
            end
            3
            start
            (##string-length str)
            (write-substring str start end port)
            (macro-check-character-output-port
              p
              4
              (write-substring str start end p)
              (##write-substring str start end p))))))))

(define-prim (##write-string str port)
  (##declare (not interrupts-enabled))
  (##write-substring str 0 (##string-length str) port))

(define-prim (write-string
              str
              #!optional
              (port (macro-absent-obj))
              (start (macro-absent-obj))
              (end (macro-absent-obj)))
  (macro-force-vars (str port start end)
    (macro-check-string
      str
      1
      (write-string str port start end)
      (let ((p
             (if (##eq? port (macro-absent-obj))
                 (macro-current-output-port)
                 port)))
        (macro-check-character-output-port
          p
          2
          (write-string str port start end)
          (if (##eq? start (macro-absent-obj))
              (##write-substring str 0 (##string-length str) p)
              (macro-check-index-range-incl
                start
                3
                0
                (##string-length str)
                (write-string str port start end)
                (if (##eq? end (macro-absent-obj))
                    (##write-substring str start (##string-length str) p)
                    (macro-check-index-range-incl
                      end
                      4
                      start
                      (##string-length str)
                      (write-string str port start end)
                      (##write-substring str start end p))))))))))

;;;----------------------------------------------------------------------------

;;; Implementation of generic byte port procedures.

(##define-macro (macro-lock-and-check-input-port-character-buffer-empty
                 port
                 form
                 expr)
  `(begin

     (macro-port-mutex-lock! ,port) ;; get exclusive access to port

     (if (or (##fx< (macro-character-port-rlo ,port)
                    (macro-character-port-rhi ,port))
             (macro-character-port-peek-eof? ,port))

         (begin
           (macro-port-mutex-unlock! ,port)
           (##raise-nonempty-input-port-character-buffer-exception ,port ,@form))

         ,expr)))

(define-prim (##input-port-bytes-buffered port)

  (##declare (not interrupts-enabled))

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let* ((byte-rlo
          (macro-byte-port-rlo port))
         (byte-rhi
          (macro-byte-port-rhi port))
         (bytes-buffered
          (##fx- byte-rhi byte-rlo)))
    (macro-port-mutex-unlock! port)
    bytes-buffered))

(define-prim (input-port-bytes-buffered port)
  (macro-force-vars (port)
    (macro-check-byte-input-port
      port
      1
      (input-port-bytes-buffered port)
      (##input-port-bytes-buffered port))))

(define-prim (##u8-ready?1 port)

  (##declare (not interrupts-enabled))

  (macro-lock-and-check-input-port-character-buffer-empty
   port
   (u8-ready? port)
   (let* ((byte-rlo
           (macro-byte-port-rlo port))
          (byte-rhi
           (macro-byte-port-rhi port)))
     (if (##fx< byte-rlo byte-rhi)
         (begin
           (macro-port-mutex-unlock! port)
           #t)
         (let ((code ((macro-byte-port-rbuf-fill port)
                      port
                      1
                      #f)))
           (if (##fixnum? code)
               (if (##fx= code ##err-code-EAGAIN)
                   (begin
                     (macro-port-mutex-unlock! port)
                     #f) ;; a call to read-u8 would block
                   (begin
                     (macro-port-mutex-unlock! port)
                     (##raise-os-io-exception port #f code u8-ready? port)))
               (begin
                 (macro-port-mutex-unlock! port)
                 #t)))))))

(define-prim (##u8-ready?0)
  (##u8-ready?1 (macro-current-input-port)))

(define-prim (##u8-ready?
              #!optional
              (port (macro-absent-obj)))
  (if (##eq? port (macro-absent-obj))
      (##u8-ready?0)
      (##u8-ready?1 port)))

(define-prim (u8-ready?
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
      (macro-check-byte-input-port p 1 (u8-ready? p)
        (##u8-ready?1 p)))))

(define-prim (##read-u8
              #!optional
              (port (macro-current-input-port)))

  (##declare (not interrupts-enabled))

  (macro-lock-and-check-input-port-character-buffer-empty
   port
   (read-u8 port)
   (let loop ()
     (let* ((byte-rlo
             (macro-byte-port-rlo port))
            (byte-rhi
             (macro-byte-port-rhi port)))
       (if (##fx< byte-rlo byte-rhi)
           (let* ((byte-rbuf
                   (macro-byte-port-rbuf port))
                  (result
                   (##u8vector-ref byte-rbuf byte-rlo)))
             (macro-byte-port-rlo-set! port (##fx+ byte-rlo 1))
             (macro-port-mutex-unlock! port)
             result)
           (let ((code
                  ((macro-byte-port-rbuf-fill port)
                   port
                   1
                   #t)))
             (cond ((##fixnum? code)

                    ;; an error occurred

                    (macro-port-mutex-unlock! port)

                    (if (##fx= code ##err-code-EAGAIN)
                        #!eof ;; the read timeout thunk returned #f
                        (##raise-os-io-exception
                         port
                         #f
                         code
                         read-u8
                         port)))

                   (code

                    ;; bytes were added to byte buffer, so try again
                    ;; to transfer bytes from the byte buffer

                    (loop))

                   (else

                    ;; no bytes were added to byte buffer
                    ;; (end-of-file was reached)

                    (macro-port-mutex-unlock! port)
                    #!eof))))))))

(define-prim (read-u8
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
      (macro-check-byte-input-port
        p
        1
        (read-u8 p)
        (##read-u8 p)))))

(define-prim (##peek-u8
              #!optional
              (port (macro-current-input-port)))

  (##declare (not interrupts-enabled))

  (macro-lock-and-check-input-port-character-buffer-empty
   port
   (peek-u8 port)
   (let loop ()
     (let* ((byte-rlo
             (macro-byte-port-rlo port))
            (byte-rhi
             (macro-byte-port-rhi port)))
       (if (##fx< byte-rlo byte-rhi)
           (let* ((byte-rbuf
                   (macro-byte-port-rbuf port))
                  (result
                   (##u8vector-ref byte-rbuf byte-rlo)))
             ;;don't advance rlo
             ;;(macro-byte-port-rlo-set! port (##fx+ byte-rlo 1))
             (macro-port-mutex-unlock! port)
             result)
           (let ((code
                  ((macro-byte-port-rbuf-fill port)
                   port
                   1
                   #t)))
             (cond ((##fixnum? code)

                    ;; an error occurred

                    (macro-port-mutex-unlock! port)

                    (if (##fx= code ##err-code-EAGAIN)
                        #!eof ;; the read timeout thunk returned #f
                        (##raise-os-io-exception
                         port
                         #f
                         code
                         peek-u8
                         port)))

                   (code

                    ;; bytes were added to byte buffer, so try again
                    ;; to transfer bytes from the byte buffer

                    (loop))

                   (else

                    ;; no bytes were added to byte buffer
                    ;; (end-of-file was reached)

                    (macro-port-mutex-unlock! port)
                    #!eof))))))))

(define-prim (peek-u8
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
      (macro-check-byte-input-port
        p
        1
        (peek-u8 p)
        (##peek-u8 p)))))

(define-prim (##read-subu8vector
              u8vect
              start
              end
              #!optional
              (port (macro-current-input-port))
              (need (macro-absent-obj))
              (raise-os-exception? #t))

  (##declare (not interrupts-enabled))

  (macro-lock-and-check-input-port-character-buffer-empty
   port
   (read-subu8vector u8vect start end port need)
   (let loop ((n 0))
     (let ((remaining (##fx- end (##fx+ start n))))
       (if (##not (##fx< 0 remaining))
           (begin
             (macro-port-mutex-unlock! port)
             n)
           (let* ((byte-rlo
                   (macro-byte-port-rlo port))
                  (byte-rhi
                   (macro-byte-port-rhi port))
                  (bytes-buffered
                   (##fx- byte-rhi byte-rlo)))
             (if (##fx< 0 bytes-buffered)

                 (let* ((to-transfer
                         (##fxmin remaining bytes-buffered))
                        (limit
                         (##fx+ byte-rlo to-transfer))
                        (byte-rbuf
                         (macro-byte-port-rbuf port)))
                   (macro-byte-port-rlo-set! port limit)
                   (##subu8vector-move!
                    byte-rbuf
                    byte-rlo
                    limit
                    u8vect
                    (##fx+ start n))
                   (loop (##fx+ n to-transfer)))

                 (let ((code
                        ((macro-byte-port-rbuf-fill port)
                         port
                         remaining
                         (or (##not (##fixnum? need))
                             (##fx< n need)))))
                   (cond ((##fixnum? code)

                          ;; an error occurred, signal an error if no
                          ;; bytes were previously transferred from byte
                          ;; buffer and (in the case of a read timeout)
                          ;; the timeout thunk returned #f

                          (macro-port-mutex-unlock! port)

                          (if (or (##fx< 0 n)
                                  (##fx= code ##err-code-EAGAIN))
                              n
                              (if raise-os-exception?
                                  (##raise-os-io-exception
                                   port
                                   #f
                                   code
                                   read-subu8vector
                                   u8vect
                                   start
                                   end
                                   port
                                   need)
                                  code)))

                         (code

                          ;; bytes were added to byte buffer, so try again
                          ;; to transfer bytes from the byte buffer

                          (loop n))

                         (else

                          ;; no bytes were added to byte buffer
                          ;; (end-of-file was reached)

                          (macro-port-mutex-unlock! port)
                          n))))))))))

(define-prim (read-subu8vector
              u8vect
              start
              end
              #!optional
              (port (macro-absent-obj))
              (need (macro-absent-obj)))
  (macro-force-vars (u8vect start end port need)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
      (macro-check-u8vector
        u8vect
        1
        (read-subu8vector u8vect start end port need)
        (macro-check-mutable
          u8vect
          1
          (read-subu8vector u8vect start end port need)
          (macro-check-index-range-incl
            start
            2
            0
            (##u8vector-length u8vect)
            (read-subu8vector u8vect start end port need)
            (macro-check-index-range-incl
              end
              3
              start
              (##u8vector-length u8vect)
              (read-subu8vector u8vect start end port need)
              (macro-check-byte-input-port
                p
                4
                (read-subu8vector u8vect start end port need)
                (if (##eq? need (macro-absent-obj))
                    (##read-subu8vector u8vect start end p)
                    (macro-check-index
                      need
                      5
                      (read-subu8vector u8vect start end port need)
                      (##read-subu8vector u8vect start end p need)))))))))))

(define-prim (read-bytevector
              k
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (k port)
    (macro-check-index
      k
      1
      (read-bytevector k port)
      (let ((p
             (if (##eq? port (macro-absent-obj))
                 (macro-current-input-port)
                 port)))
        (macro-check-byte-input-port
          p
          2
          (read-bytevector k port)
          (let* ((u8vect
                  (##make-u8vector k))
                 (n
                  (##read-subu8vector u8vect 0 k p #f #f)))
            (cond ((##fx> n 0)
                   (##u8vector-shrink! u8vect n)
                   u8vect)
                  ((##fx= n 0)
                   #!eof)
                  (else
                   (##raise-os-io-exception port #f n read-bytevector k port)))))))))

(define-prim (##read-bytevector!
              u8vect
              #!optional
              (port (macro-current-input-port))
              (start 0)
              (end (##u8vector-length u8vect)))
  (##declare (not interrupts-enabled))
  (if (##fx< start end)
      (let ((n (##read-subu8vector u8vect start end port #f #f)))
        (cond ((##fx> n 0)
               n)
              ((##fx= n 0)
               #!eof)
              (else
               (##raise-os-io-exception port #f n read-bytevector! u8vect port start end))))
      0))

(define-prim (read-bytevector!
              u8vect
              #!optional
              (port (macro-absent-obj))
              (start (macro-absent-obj))
              (end (macro-absent-obj)))
  (macro-force-vars (u8vect port start end)
    (macro-check-u8vector
      u8vect
      1
      (read-bytevector! u8vect port start end)
      (macro-check-mutable
        u8vect
        1
        (read-bytevector! u8vect port start end)
        (let ((p
               (if (##eq? port (macro-absent-obj))
                   (macro-current-input-port)
                   port)))
          (macro-check-byte-input-port
            p
            2
            (read-bytevector! u8vect port start end)
            (if (##eq? start (macro-absent-obj))
                (##read-bytevector! u8vect p 0 (##u8vector-length u8vect))
                (macro-check-index-range-incl
                  start
                  3
                  0
                  (##u8vector-length u8vect)
                  (read-bytevector! u8vect port start end)
                  (if (##eq? end (macro-absent-obj))
                      (##read-bytevector! u8vect p start (##u8vector-length u8vect))
                      (macro-check-index-range-incl
                        end
                        4
                        start
                        (##u8vector-length u8vect)
                        (read-bytevector! u8vect port start end)
                        (##read-bytevector! u8vect p start end)))))))))))

(define-prim (##write-u8
              b
              #!optional
              (port (macro-current-output-port)))

  (##declare (not interrupts-enabled))

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let ((code
         (and (##fx< (macro-character-port-wlo port)
                     (macro-character-port-whi port))
              ((macro-character-port-wbuf-drain port) port))))
    (if (##fixnum? code)

        (begin
          (macro-port-mutex-unlock! port)
          (##raise-os-io-exception
           port
           #f
           code
           write-u8
           b
           port))

        (let loop ()
          (let* ((byte-whi
                  (macro-byte-port-whi port))
                 (byte-wbuf
                  (macro-byte-port-wbuf port))
                 (bytes-free
                  (##fx- (##u8vector-length byte-wbuf) byte-whi)))
            (if (##fx< 0 bytes-free)
                (begin
                  (macro-byte-port-whi-set! port (##fx+ byte-whi 1))
                  (##u8vector-set! byte-wbuf byte-whi b)

                  ;; force output if port is set for unbuffered output

                  (if (macro-unbuffered? (macro-port-woptions port))
                      (begin
                        (macro-port-mutex-unlock! port)
                        ((macro-object-port-force-output port)
                         port
                         0
                         write-u8
                         b
                         port
                         (macro-absent-obj)
                         (macro-absent-obj)))
                      (begin
                        (macro-port-mutex-unlock! port)
                        (##void))))
                (let ((code ((macro-byte-port-wbuf-drain port) port)))
                  (if (##fixnum? code)
                      (begin

                        ;; an error occurred

                        (macro-port-mutex-unlock! port)

                        (##raise-os-io-exception
                         port
                         #f
                         code
                         write-u8
                         b
                         port))

                      ;; the byte buffer was successfully drained, so try
                      ;; again to transfer bytes to the byte buffer

                      (loop)))))))))

(define-prim (write-u8
              b
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (b port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-exact-unsigned-int8 b 1 (write-u8 b port)
        (macro-check-byte-output-port p 2 (write-u8 b p)
          (##write-u8 b p))))))

(define-prim (##write-subu8vector
              u8vect
              start
              end
              #!optional
              (port (macro-current-output-port)))

  (##declare (not interrupts-enabled))

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let ((code
         (and (##fx< (macro-character-port-wlo port)
                     (macro-character-port-whi port))
              ((macro-character-port-wbuf-drain port) port))))
    (if (##fixnum? code)

        (begin
          (macro-port-mutex-unlock! port)
          (if (##fx= code ##err-code-EAGAIN)
              0
              (##raise-os-io-exception
               port
               #f
               code
               write-subu8vector
               u8vect
               start
               end
               port)))

        (let loop1 ((n 0))
          (let ((remaining (##fx- end (##fx+ start n))))
            (if (##not (##fx< 0 remaining))
                (begin

                  ;; force output if port is set for unbuffered output

                  (if (and (##fx< start end)
                           (macro-unbuffered? (macro-port-woptions port)))
                      (begin
                        (macro-port-mutex-unlock! port)
                        ((macro-object-port-force-output port)
                         port
                         0
                         write-subu8vector
                         u8vect
                         start
                         end
                         port))
                      (macro-port-mutex-unlock! port))

                  n)
                (let* ((byte-whi
                        (macro-byte-port-whi port))
                       (byte-wbuf
                        (macro-byte-port-wbuf port))
                       (bytes-free
                        (##fx- (##u8vector-length byte-wbuf) byte-whi)))
                  (if (##fx< 0 bytes-free)
                      (let* ((to-transfer
                              (##fxmin remaining bytes-free))
                             (limit
                              (##fx+ byte-whi to-transfer)))
                        (macro-byte-port-whi-set! port limit)
                        (let loop2 ((i (##fx+ start n))
                                    (j byte-whi))
                          (if (##fx< j limit)
                              (begin
                                (##u8vector-set! byte-wbuf j (##u8vector-ref u8vect i))
                                (loop2 (##fx+ i 1)
                                       (##fx+ j 1)))))
                        (loop1 (##fx+ n to-transfer)))
                      (let ((code ((macro-byte-port-wbuf-drain port) port)))
                        (if (##fixnum? code)
                            (begin

                              ;; an error occurred, signal an error if no bytes
                              ;; were previously transferred from byte buffer
                              ;; and (in the case of a write timeout) the
                              ;; timeout thunk returned #f

                              (macro-port-mutex-unlock! port)

                              (if (or (##fx< 0 n)
                                      (##fx= code ##err-code-EAGAIN))
                                  n
                                  (##raise-os-io-exception
                                   port
                                   #f
                                   code
                                   write-subu8vector
                                   u8vect
                                   start
                                   end
                                   port)))

                            ;; the byte buffer was successfully drained, so try
                            ;; again to transfer bytes to the byte buffer

                            (loop1 n)))))))))))

(define-prim (write-subu8vector
              u8vect
              start
              end
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (u8vect start end port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-u8vector u8vect 1 (write-subu8vector u8vect start end port)
        (macro-check-index-range-incl
          start
          2
          0
          (##u8vector-length u8vect)
          (write-subu8vector u8vect start end port)
          (macro-check-index-range-incl
            end
            3
            start
            (##u8vector-length u8vect)
            (write-subu8vector u8vect start end port)
            (macro-check-byte-output-port
              p
              4
              (write-subu8vector u8vect start end p)
              (##write-subu8vector u8vect start end p))))))))

(define-prim (##write-bytevector
              u8vect
              #!optional
              (port (macro-current-output-port))
              (start 0)
              (end (##u8vector-length u8vect)))
  (##declare (not interrupts-enabled))
  (##write-subu8vector u8vect start end port)
  (##void))

(define-prim (write-bytevector
              u8vect
              #!optional
              (port (macro-absent-obj))
              (start (macro-absent-obj))
              (end (macro-absent-obj)))
  (macro-force-vars (u8vect port start end)
    (macro-check-u8vector
      u8vect
      1
      (write-bytevector u8vect port start end)
      (let ((p
             (if (##eq? port (macro-absent-obj))
                 (macro-current-output-port)
                 port)))
        (macro-check-byte-output-port
          p
          2
          (write-bytevector u8vect port start end)
          (if (##eq? start (macro-absent-obj))
              (##write-bytevector u8vect p 0 (##u8vector-length u8vect))
              (macro-check-index-range-incl
                start
                3
                0
                (##u8vector-length u8vect)
                (write-bytevector u8vect port start end)
                (if (##eq? end (macro-absent-obj))
                    (##write-bytevector u8vect p start (##u8vector-length u8vect))
                    (macro-check-index-range-incl
                      end
                      4
                      start
                      (##u8vector-length u8vect)
                      (write-bytevector u8vect port start end)
                      (##write-bytevector u8vect p start end))))))))))

(define-prim (open-input-bytevector u8vect)
  (macro-force-vars (u8vect)
    (macro-check-u8vector
      u8vect
      1
      (open-input-bytevector u8vect)
      (##open-u8vector-generic
       (macro-direction-in)
       (lambda (port) port)
       open-input-bytevector
       u8vect))))

(define-prim (open-output-bytevector)
  (##open-u8vector-generic
   (macro-direction-out)
   (lambda (port) port)
   open-output-bytevector
   '()))

(define-prim (get-output-bytevector port)
  (macro-force-vars (port)
    (macro-check-u8vector-output-port
      port
      1
      (get-output-bytevector port)
      (##get-output-u8vector port))))

(define-prim (##options-set! port options)

  (##declare (not interrupts-enabled))

  (let* ((rdevice
          (if (##fx= (macro-port-rkind port) (macro-none-kind))
              #f
              (macro-condvar-name (macro-device-port-rdevice-condvar port))))
         (wdevice
          (if (##fx= (macro-port-wkind port) (macro-none-kind))
              #f
              (macro-condvar-name (macro-device-port-wdevice-condvar port)))))
    (if (##eq? rdevice wdevice)
        (let ((code1
               (##os-device-stream-options-set! rdevice options)))
          (if (##fx< code1 0)
              code1
              (##void)))
        (let ((code2
               (if rdevice
                   (##os-device-stream-options-set! rdevice options)
                   0)))
          (if (##fx< code2 0)
              code2
              (let ((code3
                     (if wdevice
                         (##os-device-stream-options-set! wdevice options)
                         0)))
                (if (##fx< code3 0)
                    code3
                    (##void))))))))

(define-prim (##port-settings-set! port settings)

  (##declare (not interrupts-enabled))

  (define (fail)
    (##fail-check-settings 2 port-settings-set! port settings))

  (macro-lock-and-check-input-port-character-buffer-empty
   port
   (port-settings-set! port settings)
   (##make-psettings
    (macro-direction-inout)
    '(input-char-encoding:
      output-char-encoding:
      char-encoding:
      input-char-encoding-errors:
      output-char-encoding-errors:
      char-encoding-errors:
      input-eol-encoding:
      output-eol-encoding:
      eol-encoding:
      input-buffering:
      output-buffering:
      buffering:
      )
    settings
    fail
    (lambda (psettings)
      (let* ((old-roptions
              (macro-port-roptions port))
             (roptions
              (##psettings->roptions psettings
                                     old-roptions))
             (old-woptions
              (macro-port-woptions port))
             (woptions
              (##psettings->woptions psettings
                                     (##fxarithmetic-shift-left
                                      old-woptions
                                      (macro-stream-options-output-shift)))))
        (let ((code
               (and (macro-output-port? port)
                    (##not (##fx= woptions old-woptions))
                    (##fx< (macro-character-port-wlo port)
                           (macro-character-port-whi port))
                    ((macro-character-port-wbuf-drain port) port))))
          (if (##fixnum? code)

              (begin
                (macro-port-mutex-unlock! port)
                (##raise-os-io-exception
                 port
                 #f
                 code
                 port-settings-set!
                 port
                 settings))

              (let ((result
                     (and (or (macro-device-input-port? port)
                              (macro-device-output-port? port))
                          (##options-set!
                           port
                           (##fx+ roptions
                                  (##fxarithmetic-shift-left
                                   woptions
                                   (macro-stream-options-output-shift)))))))
                (if (##fixnum? result)
                    (begin
                      (macro-port-mutex-unlock! port)
                      (##raise-os-io-exception
                       port
                       #f
                       result
                       port-settings-set!
                       port
                       settings))
                    (begin
                      (macro-port-roptions-set! port roptions)
                      (macro-port-woptions-set! port woptions)

                      ;; change character buffers if needed

                      (let ((rbuf (macro-character-port-rbuf port)))
                        (if rbuf
                            (let ((new-char-buf-len
                                   (##port-char-buf-len
                                    (macro-port-rkind port)
                                    (macro-unbuffered? roptions))))
                              (if (##not (##fx= (##string-length rbuf)
                                                new-char-buf-len))
                                  (let ((new-rbuf
                                         (##make-string new-char-buf-len)))
                                    (macro-character-port-rchars-set!
                                     port
                                     (##fx+ (macro-character-port-rchars port)
                                            (macro-character-port-rlo port)))
                                    (macro-character-port-rlo-set! port 0)
                                    (macro-character-port-rhi-set! port 0)
                                    (macro-character-port-rbuf-set! port new-rbuf))))))

                      (let ((wbuf (macro-character-port-wbuf port)))
                        (if wbuf
                            (let ((new-char-buf-len
                                   (##port-char-buf-len
                                    (macro-port-wkind port)
                                    (macro-unbuffered? woptions))))
                              (if (##not (##fx= (##string-length wbuf)
                                                new-char-buf-len))
                                  (let ((new-wbuf
                                         (##make-string new-char-buf-len)))
                                    (macro-character-port-wchars-set!
                                     port
                                     (##fx+ (macro-character-port-wchars port)
                                            (macro-character-port-whi port)))
                                    (macro-character-port-wlo-set! port 0)
                                    (macro-character-port-whi-set! port 0)
                                    (macro-character-port-wbuf-set! port new-wbuf))))))

                      (macro-port-mutex-unlock! port)
                      result))))))))))

(define-prim (port-settings-set! port settings)
  (macro-force-vars (port settings)
    (macro-check-byte-port
      port
      1
      (port-settings-set! port settings)
      (##port-settings-set! port settings))))

;;;----------------------------------------------------------------------------

;;; Implementation of tty device ports.

(implement-check-type-tty-port)

(define-prim (##tty? port)
  (##declare (not interrupts-enabled))
  (macro-tty-port? port))

(define-prim (tty? port)
  (macro-force-vars (port)
    (##tty? port)))

(define-prim (##tty-type-set! port term-type emacs-bindings)
  (let ((code
         (##os-device-tty-type-set!
          (##port-device port)
          term-type
          emacs-bindings)))
    (if (##fx< code 0)
        (##raise-os-io-exception port #f code tty-type-set! port term-type emacs-bindings)
        (##void))))

(define-prim (tty-type-set! port term-type emacs-bindings)
  (macro-force-vars (port term-type emacs-bindings)
    (macro-check-tty-port
      port
      1
      (tty-type-set! port term-type emacs-bindings)
      (macro-check-string
        term-type
        2
        (tty-type-set! port term-type emacs-bindings)
        (##tty-type-set! port term-type emacs-bindings)))))

(define-prim (##tty-text-attributes-set! port input output)
  (##os-device-tty-text-attributes-set! (##port-device port) input output))

(define-prim (tty-text-attributes-set! port input output)
  (macro-force-vars (port input output)
    (macro-check-tty-port
      port
      1
      (tty-text-attributes-set! port input output)
      (macro-check-fixnum-range
        input
        2
        0
        #x800
        (tty-text-attributes-set! port input output)
        (macro-check-fixnum-range
          output
          3
          0
          #x800
          (tty-text-attributes-set! port input output)
          (##tty-text-attributes-set! port input output))))))

(define-prim (##tty-history port)
  (let ((result (##os-device-tty-history (##port-device port))))
    (if (##fixnum? result)
        (##raise-os-io-exception port #f result tty-history port)
        result)))

(define-prim (tty-history port)
  (macro-force-vars (port)
    (macro-check-tty-port
      port
      1
      (tty-history port)
      (##tty-history port))))

(define-prim (##tty-history-set! port history)
  (let ((code (##os-device-tty-history-set! (##port-device port) history)))
    (if (##fx< code 0)
        (##raise-os-io-exception port #f code tty-history-set! port history)
        (##void))))

(define-prim (tty-history-set! port history)
  (macro-force-vars (port history)
    (macro-check-tty-port
      port
      1
      (tty-history-set! port history)
      (macro-check-string
        history
        2
        (tty-history-set! port history)
        (##tty-history-set! port history)))))

(define-prim (##tty-history-max-length-set! port max-length)
  (##os-device-tty-history-max-length-set! (##port-device port) max-length))

(define-prim (tty-history-max-length-set! port max-length)
  (macro-force-vars (port max-length)
    (macro-check-tty-port
      port
      1
      (tty-history-max-length-set! port max-length)
      (macro-check-index
        max-length
        2
        (tty-history-max-length-set! port max-length)
        (##tty-history-max-length-set! port max-length)))))

(define-prim (##tty-paren-balance-duration-set! port duration)
  (##os-device-tty-paren-balance-duration-set! (##port-device port) duration))

(define-prim (tty-paren-balance-duration-set! port duration)
  (macro-force-vars (port duration)
    (macro-check-tty-port
      port
      1
      (tty-paren-balance-duration-set! port duration)
      (macro-check-real
        duration
        2
        (tty-paren-balance-duration-set! port duration)
        (##tty-paren-balance-duration-set!
         port
         (macro-real->inexact duration))))))

(define-prim (##tty-mode-set!
              port
              input-allow-special
              input-echo
              input-raw
              output-raw
              speed)
  (let ((code
         (##os-device-tty-mode-set!
          (##port-device port)
          input-allow-special
          input-echo
          input-raw
          output-raw
          speed)))
    (if (##fx< code 0)
        (##raise-os-io-exception
         port
         #f
         code
         tty-mode-set!
         port
         input-allow-special
         input-echo
         input-raw
         output-raw
         speed)
        (##void))))

(define-prim (tty-mode-set!
              port
              input-allow-special
              input-echo
              input-raw
              output-raw
              #!optional
              (s (macro-absent-obj)))
  (macro-force-vars (port
                     input-allow-special
                     input-echo
                     input-raw
                     output-raw
                     s)
    (let ((speed
           (if (##eq? s (macro-absent-obj))
               0
               s)))
      (macro-check-tty-port
        port
        1
        (tty-mode-set! port
                       input-allow-special
                       input-echo
                       input-raw
                       output-raw
                       s)
        (##tty-mode-set! port
                         input-allow-special
                         input-echo
                         input-raw
                         output-raw
                         speed)))))

(define-prim (##tty-mode-reset)
  (let ((code
         (##os-device-tty-mode-reset)))
    (if (##fx< code 0)
        (##raise-os-exception #f code ##tty-mode-reset)
        (##void))))

;;;----------------------------------------------------------------------------

;;; Implementation of process device ports.

(implement-check-type-process-port)

(define-prim (##make-process-psettings
              direction
              settings
              fail
              succeed)
  (##make-psettings
   direction
   '(path:
     arguments:
     environment:
     directory:
     stdin-redirection:
     stdout-redirection:
     stderr-redirection:
     pseudo-terminal:
     show-console:
     output-width:
     input-char-encoding:
     output-char-encoding:
     char-encoding:
     input-char-encoding-errors:
     output-char-encoding-errors:
     char-encoding-errors:
     input-eol-encoding:
     output-eol-encoding:
     eol-encoding:
     direction:
     input-buffering:
     output-buffering:
     buffering:
     input-readtable:
     output-readtable:
     readtable:)
   settings
   fail
   succeed))

(define-prim (##open-process-generic
              direction
              raise-os-exception?
              cont
              prim
              path-or-settings
              #!optional
              (arg2 (macro-absent-obj)))

  (define (psettings->options psettings)
    (let ((stdin-redir
           (macro-psettings-stdin-redir psettings))
          (stdout-redir
           (macro-psettings-stdout-redir psettings))
          (stderr-redir
           (macro-psettings-stderr-redir psettings))
          (pseudo-term
           (macro-psettings-pseudo-term psettings))
          (show-console
           (macro-psettings-show-console psettings)))
      (##fx+
       stdin-redir
       (##fx+
        (##fx* 2 stdout-redir)
        (##fx+
         (##fx* 4 stderr-redir)
         (##fx+
          (##fx* 8 pseudo-term)
          (##fx* 16 show-console)))))))

  (define (fail)
    (##fail-check-string-or-settings 1 prim path-or-settings arg2))

  (##make-process-psettings
   direction
   (if (##string? path-or-settings)
       (##list 'path: path-or-settings)
       path-or-settings)
   fail
   (lambda (psettings)
     (let ((path (macro-psettings-path psettings))
           (directory (macro-psettings-directory psettings)))
       (if (or (##not (##string? path))
               (##not (or (##not directory)
                          (##string? directory))))
           (fail)
           (let* ((path-and-arguments
                   ;; Note that the path is not resolved when opening a
                   ;; process port.  This is so that the current PATH
                   ;; environment variable is used to resolve the path
                   ;; of the program.  It is the caller's responsibility
                   ;; to call (path-expand path) if the path must be
                   ;; interpreted relative to the current directory.
                   (##cons path
                           (macro-psettings-arguments psettings)))
                  (environment
                   (macro-psettings-environment psettings))
                  (resolved-directory
                   (if directory
                       (##path-resolve directory)
                       (##current-directory)))
                  (direction
                   (macro-psettings-direction psettings)))

             ;; force creation of a bidirectional port
             (macro-psettings-direction-set!
              psettings
              (macro-direction-inout))

             (let ((device
                    (##os-device-stream-open-process
                     path-and-arguments
                     environment
                     resolved-directory
                     (psettings->options psettings))))
               (cond ((##fixnum? device)
                      (if raise-os-exception?
                          (##raise-os-exception
                           #f
                           (if (##fx= device 1) ;; couldn't set current directory?
                               ##err-code-ENOENT ;; pretend directory does not exist
                               device)
                           prim
                           path-or-settings
                           arg2)
                          (cont device)))
                     (else
                      (let ((port
                             (##make-device-port-from-single-device
                              (##cons 'process path-and-arguments)
                              device
                              psettings)))

                        ;; close unused direction
                        (cond ((##fx= direction (macro-direction-in))
                               (##close-output-port port))
                              ((##fx= direction (macro-direction-out))
                               (##close-input-port port)))

                        (cont port)))))))))))

(define-prim (##open-process path-or-settings)
  (##open-process-generic
   (macro-direction-inout)
   #t
   (lambda (port) port)
   open-process
   path-or-settings))

(define-prim (open-process path-or-settings)
  (macro-force-vars (path-or-settings)
    (##open-process path-or-settings)))

(define-prim (##open-input-process path-or-settings)
  (##open-process-generic
   (macro-direction-in)
   #t
   (lambda (port) port)
   open-input-process
   path-or-settings))

(define-prim (open-input-process path-or-settings)
  (macro-force-vars (path-or-settings)
    (##open-input-process path-or-settings)))

(define-prim (##open-output-process path-or-settings)
  (##open-process-generic
   (macro-direction-out)
   #t
   (lambda (port) port)
   open-output-process
   path-or-settings))

(define-prim (open-output-process path-or-settings)
  (macro-force-vars (path-or-settings)
    (##open-output-process path-or-settings)))

(define-prim (##call-with-input-process path-or-settings proc)
  (##open-process-generic
   (macro-direction-in)
   #t
   (lambda (port)
     (let ((results ;; may get bound to a multiple-values object
            (proc port)))
       (##close-port port)
       (##process-status port) ;; wait for process to terminate
       results))
   call-with-input-process
   path-or-settings
   proc))

(define-prim (call-with-input-process path-or-settings proc)
  (macro-force-vars (path-or-settings proc)
    (macro-check-procedure
      proc
      2
      (call-with-input-process path-or-settings proc)
      (##call-with-input-process path-or-settings proc))))

(define-prim (##call-with-output-process path-or-settings proc)
  (##open-process-generic
   (macro-direction-out)
   #t
   (lambda (port)
     (let ((results ;; may get bound to a multiple-values object
            (proc port)))
       (##force-output port)
       (##close-port port)
       (##process-status port) ;; wait for process to terminate
       results))
   call-with-output-process
   path-or-settings
   proc))

(define-prim (call-with-output-process path-or-settings proc)
  (macro-force-vars (path-or-settings proc)
    (macro-check-procedure
      proc
      2
      (call-with-output-process path-or-settings proc)
      (##call-with-output-process path-or-settings proc))))

(define-prim (##with-input-from-process path-or-settings thunk)
  (##open-process-generic
   (macro-direction-in)
   #t
   (lambda (port)
     (let ((results ;; may get bound to a multiple-values object
            (macro-dynamic-bind input-port port thunk)))
       (##close-port port)
       (##process-status port) ;; wait for process to terminate
       results))
   with-input-from-process
   path-or-settings
   thunk))

(define-prim (with-input-from-process path-or-settings thunk)
  (macro-force-vars (path-or-settings thunk)
    (macro-check-procedure
      thunk
      2
      (with-input-from-process path-or-settings thunk)
      (##with-input-from-process path-or-settings thunk))))

(define-prim (##with-output-to-process path-or-settings thunk)
  (##open-process-generic
   (macro-direction-out)
   #t
   (lambda (port)
     (let ((results ;; may get bound to a multiple-values object
            (macro-dynamic-bind output-port port thunk)))
       (##force-output port)
       (##close-port port)
       (##process-status port) ;; wait for process to terminate
       results))
   with-output-to-process
   path-or-settings
   thunk))

(define-prim (with-output-to-process path-or-settings thunk)
  (macro-force-vars (path-or-settings thunk)
    (macro-check-procedure
      thunk
      2
      (with-output-to-process path-or-settings thunk)
      (##with-output-to-process path-or-settings thunk))))

(define-prim (##process-pid port)
  (##os-device-process-pid (##port-device port)))

(define-prim (process-pid port)
  (macro-force-vars (port)
    (macro-check-process-port
      port
      1
      (process-pid port)
      (##process-pid port))))

(define-prim (##process-status
              port
              #!optional
              (absrel-timeout (macro-absent-obj))
              (timeout-val (macro-absent-obj)))

  (define (err)
    (##raise-unterminated-process-exception
     port
     process-status
     port
     timeout-val))
  (let ((timeout
         (if (##eq? absrel-timeout (macro-absent-obj))
             #t
             (macro-time-point
              (##timeout->time absrel-timeout)))))
    (let loop ()
      (if (##wait-for-io!
           (macro-device-port-event-condvar port)
           timeout)

          ;; ##wait-for-io! returned before timeout
          (let ((result (##os-device-process-status (##port-device port))))
            (cond ((##not result)
                   ;; the process is not yet terminated, so wait some more
                   (loop))
                  ((##fx< result 0)
                   (##raise-os-io-exception port #f result process-status port))
                  (else
                   result)))

          ;; timeout expired
          (if (##eq? timeout-val (macro-absent-obj))
              (err)
              timeout-val)))))

(define-prim (process-status
              port
              #!optional
              (absrel-timeout (macro-absent-obj))
              (timeout-val (macro-absent-obj)))
  (macro-force-vars (port absrel-timeout)
    (macro-check-process-port
      port
      1
      (process-status port absrel-timeout timeout-val)
      (if (or (##eq? absrel-timeout (macro-absent-obj))
              (macro-absrel-time-or-false? absrel-timeout))
          (##process-status port absrel-timeout timeout-val)
          (##fail-check-absrel-time-or-false
           2
           process-status
           port
           absrel-timeout
           timeout-val)))))

;;;----------------------------------------------------------------------------

;;; Implementation of host-info objects.

(implement-library-type-host-info)

(define-prim (##host-info
              host
              #!optional
              (raise-os-exception? #t))
  (let* ((hi (macro-make-host-info #f #f #f))
         (result (##os-host-info hi host)))
    (if (##fixnum? result)
        (if raise-os-exception?
            (##raise-os-exception #f result host-info host)
            result)
        result)))

(define-prim (host-info host)
  (macro-force-vars (host)
    (macro-check-string-or-ip-address host 1 (host-info host)
      (##host-info host))))

(define-prim (##host-name)
  (let ((result (##os-host-name)))
    (if (##fixnum? result)
        (##raise-os-exception #f result host-name)
        result)))

(define-prim (host-name)
  (##host-name))

(define-prim (##string-or-ip-address? obj)
  (or (##string? obj)
      (##ip-address? obj)))

(define-prim (##ip-address? obj)
  (cond ((##u8vector? obj)
         (##fx= (##u8vector-length obj) 4))
        ((macro-if-u16vector (##u16vector? obj) #f)
         (##fx= (##u16vector-length obj) 8))
        (else
         #f)))

;;;----------------------------------------------------------------------------

;;; Implementation of service-info objects.

(implement-library-type-service-info)

(define-prim (##service-info
              service
              #!optional
              (protocol (macro-absent-obj)))
  (let* ((si
          (macro-make-service-info #f #f #f #f))
         (result
          (##os-service-info
           si
           service
           (cond ((##string? protocol)
                  protocol)
                 ((##fixnum? protocol)
                  (let ((p (##protocol-info protocol)))
                    (macro-protocol-info-name p)))
                 ((macro-protocol-info? protocol)
                  (macro-protocol-info-name protocol))
                 (else
                  #f)))))
    (if (##fixnum? result)
        (##raise-os-exception #f result service-info service protocol)
        result)))

(define-prim (service-info
              service
              #!optional
              (protocol (macro-absent-obj)))
  (macro-force-vars (service protocol)
    (macro-check-string-or-nonnegative-fixnum
      service
      1
      (service-info service protocol)
      (if (##eq? protocol (macro-absent-obj))
          (##service-info service)
          (macro-check-string-or-nonnegative-fixnum
            protocol
            2
            (service-info service protocol)
            (##service-info service protocol))))))

;;;----------------------------------------------------------------------------

;;; Implementation of protocol-info objects.

(implement-library-type-protocol-info)

(define-prim (##protocol-info protocol)
  (let* ((pi (macro-make-protocol-info #f #f #f))
         (result (##os-protocol-info pi protocol)))
    (if (##fixnum? result)
        (##raise-os-exception #f result protocol-info protocol)
        result)))

(define-prim (protocol-info protocol)
  (macro-force-vars (protocol)
    (macro-check-string-or-nonnegative-fixnum
      protocol
      1
      (protocol-info protocol)
      (##protocol-info protocol))))

;;;----------------------------------------------------------------------------

;;; Implementation of network-info objects.

(implement-library-type-network-info)

(define-prim (##network-info network)
  (let* ((ni (macro-make-network-info #f #f #f))
         (result (##os-network-info ni network)))
    (if (##fixnum? result)
        (##raise-os-exception #f result network-info network)
        result)))

(define-prim (network-info network)
  (macro-force-vars (network)
    (macro-check-string-or-nonnegative-fixnum
      network
      1
      (network-info network)
      (##network-info network))))

;;;----------------------------------------------------------------------------

;;; Implementation of TLS objects.

(macro-case-target

 ((C)

(define-prim (make-tls-context
              #!key
              (min-version (macro-absent-obj))
              (options (macro-absent-obj))
              (certificate (macro-absent-obj))
              (private-key (macro-absent-obj))
              (diffie-hellman-parameters (macro-absent-obj))
              (elliptic-curve (macro-absent-obj))
              (client-ca (macro-absent-obj)))
  (macro-force-vars (min-version
                     options
                     certificate
                     private-key
                     diffie-hellman-parameters
                     elliptic-curve
                     client-ca)
    (let ()

      (define (version->code version)
        (case version
          ((ssl-v2)   #x0200)
          ((ssl-v3)   #x0300)
          ((tls-v1)   #x0301)
          ((tls-v1.1) #x0302)
          ((tls-v1.2) #x0303)
          (else       #f)))

      (define allowed-options
        '((server-mode                   .   1)
          (use-diffie-hellman            .   2)
          (use-elliptic-curves           .   4)
          (request-client-authentication .   8)
          (insert-empty-fragments        . 256)))

      (define (options->code options)
        (let loop ((lst options) (code 0))
          (macro-force-vars (lst)
            (cond ((##pair? lst)
                   (let ((opt (##car lst)))
                     (macro-force-vars (opt)
                       (let ((x (##assq opt allowed-options)))
                         (and x
                              (loop (##cdr lst)
                                    (##fxior code (##cdr x))))))))
                  ((##null? lst)
                   code)
                  (else
                   #f)))))

      (define (check-min-version
               arg-num)
        (if (##eq? min-version (macro-absent-obj))
            (check-options
             arg-num
             (version->code 'tls-v1))
            (let ((arg-num (##fx+ arg-num 2)))
              (let ((min-version-code (version->code min-version)))
                (if (##not min-version-code)
                    (##fail-check-tls-version
                     arg-num
                     (##list make-tls-context
                             min-version: min-version
                             options: options
                             certificate: certificate
                             private-key: private-key
                             diffie-hellman-parameters: diffie-hellman-parameters
                             elliptic-curve: elliptic-curve
                             client-ca: client-ca))
                    (check-options
                     arg-num
                     min-version-code))))))

      (define (check-options
               arg-num
               min-ver-code)
        (if (##eq? options (macro-absent-obj))
            (check-certificate
             arg-num
             min-ver-code
             (options->code '()))
            (let ((arg-num (##fx+ arg-num 2)))
              (let ((opts-code (options->code options)))
                (if opts-code
                    (check-certificate
                     arg-num
                     min-ver-code
                     opts-code)
                    (##fail-check-tls-options
                     arg-num
                     (##list make-tls-context
                             min-version: min-version
                             options: options
                             certificate: certificate
                             private-key: private-key
                             diffie-hellman-parameters: diffie-hellman-parameters
                             elliptic-curve: elliptic-curve
                             client-ca: client-ca)))))))

      (define (check-certificate
               arg-num
               min-ver-code
               opts-code)
        (if (##eq? certificate (macro-absent-obj))
            (check-private-key
             arg-num
             min-ver-code
             opts-code
             #f)
            (let ((arg-num (##fx+ arg-num 2)))
              (macro-check-string
                certificate
                arg-num
                (make-tls-context
                 min-version: min-version
                 options: options
                 certificate: certificate
                 private-key: private-key
                 diffie-hellman-parameters: diffie-hellman-parameters
                 elliptic-curve: elliptic-curve
                 client-ca: client-ca)
                (check-private-key
                 arg-num
                 min-ver-code
                 opts-code
                 certificate)))))

      (define (check-private-key
               arg-num
               min-ver-code
               opts-code
               cert)
        (if (##eq? private-key (macro-absent-obj))
            (check-diffie-hellman-parameters
             arg-num
             min-ver-code
             opts-code
             cert
             cert)
            (let ((arg-num (##fx+ arg-num 2)))
              (macro-check-string
                private-key
                arg-num
                (make-tls-context
                 min-version: min-version
                 options: options
                 certificate: certificate
                 private-key: private-key
                 diffie-hellman-parameters: diffie-hellman-parameters
                 elliptic-curve: elliptic-curve
                 client-ca: client-ca)
                (check-diffie-hellman-parameters
                 arg-num
                 min-ver-code
                 opts-code
                 cert
                 private-key)))))

      (define (check-diffie-hellman-parameters
               arg-num
               min-ver-code
               opts-code
               cert
               priv-key)
        (if (##eq? diffie-hellman-parameters (macro-absent-obj))
            (check-elliptic-curve
             arg-num
             min-ver-code
             opts-code
             cert
             priv-key
             #f)
            (let ((arg-num (##fx+ arg-num 2)))
              (macro-check-string
                diffie-hellman-parameters
                arg-num
                (make-tls-context
                 min-version: min-version
                 options: options
                 certificate: certificate
                 private-key: private-key
                 diffie-hellman-parameters: diffie-hellman-parameters
                 elliptic-curve: elliptic-curve
                 client-ca: client-ca)
                (check-elliptic-curve
                 arg-num
                 min-ver-code
                 opts-code
                 cert
                 priv-key
                 diffie-hellman-parameters)))))

      (define (check-elliptic-curve
               arg-num
               min-ver-code
               opts-code
               cert
               priv-key
               dh-params)
        (if (##eq? elliptic-curve (macro-absent-obj))
            (check-client-ca
             arg-num
             min-ver-code
             opts-code
             cert
             priv-key
             dh-params
             #f)
            (let ((arg-num (##fx+ arg-num 2)))
              (macro-check-string
                elliptic-curve
                arg-num
                (make-tls-context
                 min-version: min-version
                 options: options
                 certificate: certificate
                 private-key: private-key
                 diffie-hellman-parameters: diffie-hellman-parameters
                 elliptic-curve: elliptic-curve
                 client-ca: client-ca)
                (check-client-ca
                 arg-num
                 min-ver-code
                 opts-code
                 cert
                 priv-key
                 dh-params
                 elliptic-curve)))))

      (define (check-client-ca
               arg-num
               min-ver-code
               opts-code
               cert
               priv-key
               dh-params
               el-curve)
        (if (##eq? client-ca (macro-absent-obj))
            (checks-done
             arg-num
             min-ver-code
             opts-code
             cert
             priv-key
             dh-params
             el-curve
             #f)
            (let ((arg-num (##fx+ arg-num 2)))
              (macro-check-string
                client-ca
                arg-num
                (make-tls-context
                 min-version: min-version
                 options: options
                 certificate: certificate
                 private-key: private-key
                 diffie-hellman-parameters: diffie-hellman-parameters
                 elliptic-curve: elliptic-curve
                 client-ca: client-ca)
                (checks-done
                 arg-num
                 min-ver-code
                 opts-code
                 cert
                 priv-key
                 dh-params
                 el-curve
                 client-ca)))))

      (define (checks-done
               arg-num
               min-ver-code
               opts-code
               cert
               priv-key
               dh-params
               el-curve
               cl-ca)
        (let ((result
               (##os-make-tls-context
                min-ver-code
                opts-code
                cert
                priv-key
                dh-params
                el-curve
                cl-ca)))
          (if (##fixnum? result)
              (##raise-os-exception
               #f
               result
               (##list make-tls-context
                       min-version: min-version
                       options: options
                       certificate: certificate
                       private-key: private-key
                       diffie-hellman-parameters: diffie-hellman-parameters
                       elliptic-curve: elliptic-curve
                       client-ca: client-ca))
              result)))

      (check-min-version 0))))

))

;;;----------------------------------------------------------------------------

;;; Implementation of TCP client device ports.

(macro-case-target

 ((C)

(implement-check-type-tcp-client-port)

(define-prim (##make-tcp-psettings
              client?
              settings
              fail
              succeed)

  (define allowed-client-settings
    '(; broadcast:
      server-address: ;; keep for backward compatibility
      address:
      port-number:
      local-address:
      local-port-number:
      keep-alive:
      coalesce:
      output-width:
      input-char-encoding:
      output-char-encoding:
      char-encoding:
      input-char-encoding-errors:
      output-char-encoding-errors:
      char-encoding-errors:
      input-eol-encoding:
      output-eol-encoding:
      eol-encoding:
      input-buffering:
      output-buffering:
      buffering:
      input-readtable:
      output-readtable:
      readtable:
      tls-context:))

  (define allowed-server-settings
    '(reuse-address:
      backlog:
      server-address: ;; keep for backward compatibility
      port-number:    ;; keep for backward compatibility
      local-address:
      local-port-number:
      keep-alive:
      coalesce:
      output-width:
      input-char-encoding:
      output-char-encoding:
      char-encoding:
      input-char-encoding-errors:
      output-char-encoding-errors:
      char-encoding-errors:
      input-eol-encoding:
      output-eol-encoding:
      eol-encoding:
      input-buffering:
      output-buffering:
      buffering:
      input-readtable:
      output-readtable:
      readtable:
      tls-context:))

  (##make-psettings
   (macro-direction-inout)
   (if client?
       allowed-client-settings
       allowed-server-settings)
   settings
   fail
   succeed))

(define-prim (##make-tcp-client-port name device psettings)
  (##make-device-port-from-single-device
   name
   device
   psettings))

(define-prim (##open-tcp-client
              raise-os-exception?
              cont
              prim
              port-number-or-address-or-settings)

  (define (psettings->options psettings)
    (let ((coalesce
           (macro-psettings-coalesce psettings))
          (keep-alive
           (macro-psettings-keep-alive psettings)))
      (##fx+
       (##fx* 2 coalesce)
       keep-alive)))

  (define (fail)
    (##fail-check-exact-integer-or-string-or-settings 1 prim port-number-or-address-or-settings))

  (##make-tcp-psettings
   #t
   (cond ((##fixnum? port-number-or-address-or-settings)
          (##list 'port-number: port-number-or-address-or-settings))
         ((##string? port-number-or-address-or-settings)
          (##list 'address: port-number-or-address-or-settings))
         (else
          port-number-or-address-or-settings))
   fail
   (lambda (psettings)

     (define (stage1)
       (let ((address-or-host
              (macro-psettings-address psettings)))
         (if (##string? address-or-host)
             (let ((info (##host-info address-or-host #f)))
               (if (##fixnum? info)
                   (if raise-os-exception?
                       (##raise-os-exception #f info prim port-number-or-address-or-settings)
                       (cont info))
                 (stage2 address-or-host
                         (##car (macro-host-info-addresses info)))))
             (stage2 address-or-host
                     address-or-host))))

     (define (stage2 address-or-host address)
       (let ((local-address-or-host
              (macro-psettings-local-address psettings)))
         (if (##string? local-address-or-host)
             (let ((info (##host-info local-address-or-host #f)))
               (if (##fixnum? info)
                   (if raise-os-exception?
                       (##raise-os-exception #f info prim port-number-or-address-or-settings)
                       (cont info))
                 (stage3 address-or-host
                         address
                         (##car (macro-host-info-addresses info)))))
             (stage3 address-or-host
                     address
                     local-address-or-host))))

     (define (stage3 address-or-host address local-address)
       (let ((port-number
              (if (##null? (macro-psettings-port-number psettings))
                  #f
                  (macro-psettings-port-number psettings)))
             (local-port-number
              (if (##null? (macro-psettings-local-port-number psettings))
                  #f
                  (macro-psettings-local-port-number psettings))))
         (if (##not port-number)
             (fail)
             (let ((device
                    (##os-device-tcp-client-open
                     (if (##null? local-address)
                         #f ;; default local-address to any interface
                         local-address)
                     local-port-number
                     (if (##null? address)
                         (macro-localhost) ;; default address to localhost
                         address)
                     port-number
                     (psettings->options psettings)
                     (macro-psettings-tls-context psettings)
                     (and (##string? address-or-host) address-or-host))))
               (if (##fixnum? device)
                   (if raise-os-exception?
                       (##raise-os-exception #f device prim port-number-or-address-or-settings)
                       (cont device))
                   (let ((port
                          (##make-tcp-client-port
                           (##list 'tcp-client
                                   (if (##null? address)
                                       (macro-localhost)
                                       (or address-or-host "*"))
                                   port-number)
                           device
                           psettings)))
;;; wait for connection to be established
;;;                     (##wait-for-io!
;;;                      (macro-device-port-wdevice-condvar port)
;;;                      (macro-port-wtimeout port))
                     (cont port)))))))

     (stage1))))

(define-prim (open-tcp-client port-number-or-address-or-settings)
  (macro-force-vars (port-number-or-address-or-settings)
    (##open-tcp-client
     #t
     (lambda (port) port)
     open-tcp-client
     port-number-or-address-or-settings)))

(implement-library-type-socket-info)

(define-prim (##socket-info-setup! si)
  (##vector-set! si 1 (##net-family-decode (##vector-ref si 1)))
  (##structure-type-set! si (macro-type-socket-info))
  (##subtype-set! si (macro-subtype-structure))
  si)

(define-prim (##tcp-client-socket-info
              port
              prim
              #!optional
              (raise-os-exception? #t))
  (let loop ()
    (let ((result
           (##os-device-tcp-client-socket-info
            (macro-condvar-name
             (or (macro-device-port-wdevice-condvar port)
                 (macro-device-port-rdevice-condvar port)))
            (##eq? prim tcp-client-peer-socket-info))))
      (if (##fixnum? result)

          (if (and (##fx= result ##err-code-EAGAIN)
                   (or (##wait-for-io!
                        (macro-device-port-wdevice-condvar port)
                        (macro-port-wtimeout port))
                       ((macro-port-wtimeout-thunk port))))
              (loop)
              (if raise-os-exception?
                  (##raise-os-io-exception port #f result prim port)
                  result))

          (##socket-info-setup! result)))))

(define-prim (##tcp-client-local-socket-info port)
  (##tcp-client-socket-info port tcp-client-local-socket-info))

(define-prim (tcp-client-local-socket-info port)
  (macro-force-vars (port)
    (macro-check-tcp-client-port port 1 (tcp-client-local-socket-info port)
      (##tcp-client-local-socket-info port))))

(define-prim (tcp-client-self-socket-info port) ;;TODO: deprecated
  (macro-force-vars (port)
    (macro-check-tcp-client-port port 1 (tcp-client-self-socket-info port)
      (##tcp-client-local-socket-info port))))

(define-prim (##tcp-client-peer-socket-info port)
  (##tcp-client-socket-info port tcp-client-peer-socket-info))

(define-prim (tcp-client-peer-socket-info port)
  (macro-force-vars (port)
    (macro-check-tcp-client-port port 1 (tcp-client-peer-socket-info port)
      (##tcp-client-peer-socket-info port))))

(implement-library-type-address-info)

(define-prim (##net-family-encode x)
  (case x
    ((INET)  -1)
    ((INET6) -2)
    (else    x)))

(define-prim (##net-family-decode x)
  (case x
    ((-1) 'INET)
    ((-2) 'INET6)
    (else x)))

(define-prim (##net-socket-type-encode x)
  (case x
    ((STREAM) -1)
    ((DGRAM)  -2)
    ((RAW)    -3)
    (else     x)))

(define-prim (##net-socket-type-decode x)
  (case x
    ((-1) 'STREAM)
    ((-2) 'DGRAM)
    ((-3) 'RAW)
    (else x)))

(define-prim (##net-protocol-encode x)
  (case x
    ((UDP) -1)
    ((TCP) -2)
    (else  x)))

(define-prim (##net-protocol-decode x)
  (case x
    ((-1) 'UDP)
    ((-2) 'TCP)
    (else x)))

(define-prim (##address-info-setup! ai)
  (##vector-set! ai 1 (##net-family-decode      (##vector-ref ai 1)))
  (##vector-set! ai 2 (##net-socket-type-decode (##vector-ref ai 2)))
  (##vector-set! ai 3 (##net-protocol-decode    (##vector-ref ai 3)))
  (let ((si (##vector-ref ai 4)))
    (##socket-info-setup! si))
  (##structure-type-set! ai (macro-type-address-info))
  (##subtype-set! ai (macro-subtype-structure))
  ai)

(define-prim (##address-infos
              #!key
              (host (macro-absent-obj))
              (service (macro-absent-obj))
              ;;(flags (macro-absent-obj))
              (family (macro-absent-obj))
              (socket-type (macro-absent-obj))
              (protocol (macro-absent-obj)))
  (macro-force-vars (host service ;;flags
                     family socket-type protocol)
    (let ((flags (macro-absent-obj)))

      (define (check-host arg-num)
        (if (##eq? host (macro-absent-obj))
            (check-service arg-num "")
            (let ((arg-num (##fx+ arg-num 2)))
              (macro-check-string
                host
                arg-num
                (address-infos host: host
                               service: service
                               flags: flags
                               family: family
                               socket-type: socket-type
                               protocol: protocol)
                (check-service arg-num host)))))

      (define (check-service arg-num h)
        (if (##eq? service (macro-absent-obj))
            (check-flags arg-num h "")
            (let ((arg-num (##fx+ arg-num 2)))
              (macro-check-string
                service
                arg-num
                (address-infos host: host
                               service: service
                               flags: flags
                               family: family
                               socket-type: socket-type
                               protocol: protocol)
                (check-flags arg-num h service)))))

      (define (check-flags arg-num h s)
        (if (##eq? flags (macro-absent-obj))
            (check-family arg-num h s 0)
            (let ((arg-num (##fx+ arg-num 2)))
              (macro-check-fixnum-range-incl
                flags
                arg-num
                0
                65535
                (address-infos host: host
                               service: service
                               flags: flags
                               family: family
                               socket-type: socket-type
                               protocol: protocol)
                (check-family arg-num h s flags)))))

      (define (check-family arg-num h s f)
        (if (##eq? family (macro-absent-obj))
            (check-socket-type arg-num h s f 0)
            (let ((arg-num (##fx+ arg-num 2)))
              (let ((x (##net-family-encode family)))
                (if (##eq? x family)
                    (##raise-type-exception
                     arg-num
                     'network-family
                     (##list address-infos
                             host: host
                             service: service
                             flags: flags
                             family: family
                             socket-type: socket-type
                             protocol: protocol)
                     '())
                    (check-socket-type arg-num h s f x))))))

      (define (check-socket-type arg-num h s f fam)
        (if (##eq? socket-type (macro-absent-obj))
            (check-protocol arg-num h s f fam 0)
            (let ((arg-num (##fx+ arg-num 2)))
              (let ((x (##net-socket-type-encode socket-type)))
                (if (##eq? x socket-type)
                    (##raise-type-exception
                     arg-num
                     'network-socket-type
                     (##list address-infos
                             host: host
                             service: service
                             flags: flags
                             family: family
                             socket-type: socket-type
                             protocol: protocol)
                     '())
                    (check-protocol arg-num h s f fam x))))))

      (define (check-protocol arg-num h s f fam st)
        (if (##eq? protocol (macro-absent-obj))
            (checks-done h s f fam st 0)
            (let ((arg-num (##fx+ arg-num 2)))
              (let ((x (##net-protocol-encode protocol)))
                (if (##eq? x protocol)
                    (##raise-type-exception
                     arg-num
                     'network-protocol
                     (##list address-infos
                             host: host
                             service: service
                             flags: flags
                             family: family
                             socket-type: socket-type
                             protocol: protocol)
                     '())
                    (checks-done h s f fam st x))))))

      (define (checks-done h s f fam st p)
        (let ((result (##os-address-infos h s f fam st p)))
          (if (##fixnum? result)
              (##raise-os-exception
               #f
               result
               (##list address-infos
                       host: host
                       service: service
                       flags: flags
                       family: family
                       socket-type: socket-type
                       protocol: protocol))
              (begin
                (##for-each ##address-info-setup! result)
                result))))

      (check-host 0))))

(define-prim (address-infos
              #!key
              (host (macro-absent-obj))
              (service (macro-absent-obj))
              ;;(flags (macro-absent-obj))
              (family (macro-absent-obj))
              (socket-type (macro-absent-obj))
              (protocol (macro-absent-obj)))
  (##address-infos host: host
                   service: service
                   ;;flags: flags
                   family: family
                   socket-type: socket-type
                   protocol: protocol))

))

;;;----------------------------------------------------------------------------

;; Implementation of TCP server ports.

(macro-case-target

 ((C)

(implement-check-type-tcp-server-port)

(define-prim (##make-tcp-server-port rdevice client-psettings)
  (let ((mutex
         (macro-make-port-mutex))
        (rkind
         (macro-tcp-server-kind))
        (wkind
         (macro-none-kind))
        (roptions
         0)
        (rtimeout
         #t)
        (rtimeout-thunk
         #f)
        (woptions
         0)
        (wtimeout
         #t)
        (wtimeout-thunk
         #f)
        (rdevice-condvar
         (##make-io-condvar-for-reading rdevice)))

    (define (server-name port)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##list 'tcp-server
              (macro-psettings-local-port-number
               (macro-tcp-server-port-client-psettings port))))

    ;; This code gives a more informative name to the tcp-client port but
    ;; if ##os-device-tcp-client-socket-info raises an exception it leads
    ;; to an infinite loop.
    ;;
    ;;        (define (client-name port)
    ;;
    ;;          ;; It is assumed that the thread **does not** have exclusive
    ;;          ;; access to the port.
    ;;
    ;;          (##declare (not interrupts-enabled))
    ;;
    ;;          (let ((info
    ;;                 (##os-device-tcp-client-socket-info
    ;;                  (macro-condvar-name
    ;;                   (macro-device-port-wdevice-condvar port))
    ;;                  #t)))
    ;;            (if (##fixnum? info)
    ;;              (##list 'tcp-client
    ;;                      (macro-psettings-local-port-number
    ;;                       (macro-tcp-server-port-client-psettings port)))
    ;;              (let ((address
    ;;                     (macro-socket-info-address info))
    ;;                    (port-num
    ;;                     (macro-socket-info-port-number info)))
    ;;                (##list 'tcp-client
    ;;                        address
    ;;                        port-num)))))

    (define (wait port direction)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##wait-device port direction))

    (define (read-datum port re)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let loop ()
        (let ((client-device
               (##os-device-tcp-server-read
                (macro-tcp-server-port-rdevice-condvar port))))
          (if (##fixnum? client-device)

              (cond ((##fx= client-device ##err-code-EINTR)

                     ;; the read was interrupted, so try again

                     (loop))

                    ((##fx= client-device ##err-code-EAGAIN)

                     ;; the read would block, so wait and then try again

                     (macro-port-mutex-unlock! port)
                     (let ((continue?
                            (or (##wait-for-io!
                                 (macro-tcp-server-port-rdevice-condvar port)
                                 (macro-port-rtimeout port))
                                ((macro-port-rtimeout-thunk port)))))
                       (if continue?
                           (begin
                             (macro-port-mutex-lock! port) ;; regain access to port
                             (loop))
                           #!eof)))

                    (else

                     ;; signal an error

                     (macro-port-mutex-unlock! port)
                     (##raise-os-io-exception port #f client-device read port)))

              (begin
                (macro-port-mutex-unlock! port)
                (let ((port
                       (##make-tcp-client-port
                        '(tcp-client)
                        client-device
                        (macro-tcp-server-port-client-psettings port))))
;;;                  (macro-port-name-set! port client-name)
                  port))))))

    (define write-datum #f)

    (define newline #f)

    (define force-output #f)

    (define (set-rtimeout port timeout thunk)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (macro-port-rtimeout-set! port timeout)
      (macro-port-rtimeout-thunk-set! port thunk)
      (##condvar-signal-no-reschedule!
       (macro-tcp-server-port-rdevice-condvar port)
       #t)
      (macro-port-mutex-unlock! port)
      (##void))

    (define set-wtimeout #f)

    (define (close port prim arg1)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let ((result
             (##close-device
              port
              (macro-tcp-server-port-rdevice-condvar port)
              #f
              prim)))
        (macro-port-mutex-unlock! port)
        (if (##fixnum? result)
            (##raise-os-io-exception port #f result prim arg1)
            result)))

    (let ((port
           (macro-make-tcp-server-port
            mutex
            rkind
            wkind
            server-name
            wait
            close
            roptions
            rtimeout
            rtimeout-thunk
            set-rtimeout
            woptions
            wtimeout
            wtimeout-thunk
            set-wtimeout
            #f ;; io-exception-handler
            read-datum
            write-datum
            newline
            force-output
            rdevice-condvar
            client-psettings)))
      (##io-condvar-port-set! rdevice-condvar port)
      port)))

(define-prim (##process-tcp-server-psettings
              raise-os-exception?
              cont
              prim
              port-number-or-address-or-settings
              arg2
              arg3
              arg4)

  (define (fail)
    (##fail-check-exact-integer-or-string-or-settings 1 prim port-number-or-address-or-settings arg2 arg3 arg4))

  (##make-tcp-psettings
   #f
   (cond ((##fixnum? port-number-or-address-or-settings)
          (##list 'local-port-number: port-number-or-address-or-settings))
         ((##string? port-number-or-address-or-settings)
          (##list 'local-address: port-number-or-address-or-settings))
         (else
          port-number-or-address-or-settings))
   fail
   (lambda (psettings)

     (define (stage1)
       (let ((local-address-or-host
              (if (##null? (macro-psettings-local-address psettings))
                  (macro-psettings-address psettings) ;; for backward compatibility
                  (macro-psettings-local-address psettings))))
         (if (##string? local-address-or-host)
             (let ((info (##host-info local-address-or-host #f)))
               (if (##fixnum? info)
                   (if raise-os-exception?
                       (##raise-os-exception #f info prim port-number-or-address-or-settings arg2 arg3 arg4)
                       (cont info))
                 (stage2 (##car (macro-host-info-addresses info)))))
             (stage2 local-address-or-host))))

     (define (stage2 local-address)
       (let ((local-port-number
              (if (##null? (macro-psettings-local-port-number psettings))
                  (macro-psettings-port-number psettings) ;; for backward compatibility
                  (macro-psettings-local-port-number psettings))))
         (if (##null? local-port-number)
             (fail)
             (cont (##vector psettings local-address local-port-number)))))

     (stage1))))

(define-prim (##open-tcp-server-aux
              raise-os-exception?
              psettings-and-address-and-port-number
              cont
              prim
              port-number-or-address-or-settings
              arg2
              arg3
              arg4)

  (define (psettings->options psettings)
    (let ((reuse-address
           (macro-psettings-reuse-address psettings))
          (coalesce
           (macro-psettings-coalesce psettings))
          (keep-alive
           (macro-psettings-keep-alive psettings)))
      (##fx+
       (##fx* 2048 reuse-address)
       (##fx+
        (##fx* 2 coalesce)
        keep-alive))))

  (let* ((psettings
          (##vector-ref psettings-and-address-and-port-number 0))
         (local-address
          (##vector-ref psettings-and-address-and-port-number 1))
         (local-port-number
          (##vector-ref psettings-and-address-and-port-number 2))
         (tls-context
          (macro-psettings-tls-context psettings))
         (rdevice
          (##os-device-tcp-server-open
           (if (##null? local-address)
               (macro-localhost) ;; default local-address to localhost
               local-address)
           local-port-number
           (macro-psettings-backlog psettings)
           (psettings->options psettings)
           tls-context)))
    (if (##fixnum? rdevice)
        (if raise-os-exception?
            (##raise-os-exception #f rdevice prim port-number-or-address-or-settings arg2 arg3 arg4)
            (cont rdevice))
        (cont (##make-tcp-server-port rdevice psettings)))))

(define-prim (##open-tcp-server
              raise-os-exception?
              cont
              prim
              port-number-or-address-or-settings
              arg2
              arg3
              arg4)
  (##process-tcp-server-psettings
   raise-os-exception?
   (lambda (psettings-and-address-and-port-number)
     (##open-tcp-server-aux
      raise-os-exception?
      psettings-and-address-and-port-number
      cont
      prim
      port-number-or-address-or-settings
      arg2
      arg3
      arg4))
   prim
   port-number-or-address-or-settings
   arg2
   arg3
   arg4))

(define-prim (open-tcp-server port-number-or-address-or-settings)
  (macro-force-vars (port-number-or-address-or-settings)
    (##open-tcp-server
     #t
     (lambda (port) port)
     open-tcp-server
     port-number-or-address-or-settings
     (macro-absent-obj)
     (macro-absent-obj)
     (macro-absent-obj))))

(define-prim (##tcp-server-socket-info port)
  (let ((result
         (##os-device-tcp-server-socket-info
          (macro-condvar-name
           (macro-tcp-server-port-rdevice-condvar port)))))
    (if (##fixnum? result)

        (##raise-os-io-exception port #f result tcp-server-socket-info port)

        (##socket-info-setup! result))))

(define-prim (tcp-server-socket-info port)
  (macro-force-vars (port)
    (macro-check-tcp-server-port port 1 (tcp-server-socket-info port)
      (##tcp-server-socket-info port))))

(define-prim (##string->address-and-port-number str)

  (define default-address '())
  (define default-port-num '())

  (define (err)
    #f)

  (define (addr str)
    (if (##string=? str "*")
        #f
        str))

  (let ((len (if str (##string-length str) 0)))
    (let loop ((i 0) (colon #f))
      (if (##fx< i len)
          (let ((c (##string-ref str i)))
            (cond ((##not colon)
                   (loop (##fx+ i 1)
                         (if (##char=? c #\:) i colon)))
                  ((and (##char<=? #\0 c) (##char<=? c #\9))
                   (loop (##fx+ i 1)
                         colon))
                  (else
                   (err))))
          (if (##not colon)
              (##cons (if (##fx= len 0)
                          default-address
                          (addr str))
                      default-port-num)
              (let ((port-num
                     (##string->number
                      (##substring str (##fx+ colon 1) len)
                      10)))
                (if (and port-num
                         (##fixnum? port-num)
                         (##fx<= 0 port-num)
                         (##fx<= port-num 65535))
                    (##cons (if (##fx= colon 0)
                                default-address
                                (addr (##substring str 0 colon)))
                            port-num)
                    (err))))))))

))

;;;----------------------------------------------------------------------------

;; Implementation of UDP ports.

(macro-case-target

 ((C)

(implement-check-type-udp-port)
(define-fail-check-type udp-input-port 'udp-input-port)
(define-fail-check-type udp-output-port 'udp-output-port)

(define-prim (##make-udp-psettings
              settings
              fail
              succeed)

  (define allowed-settings
    '(address:
      port-number:
      local-address:
      local-port-number:
      direction:))

  (##make-psettings
   (macro-direction-inout)
   allowed-settings
   settings
   fail
   succeed))

(define-prim (##make-udp-port device id psettings)
  (let* ((direction
          (macro-psettings-direction psettings))
         (mutex
          (macro-make-port-mutex))
         (rkind
          (if (##fx= direction (macro-direction-out))
              (macro-none-kind)
              (macro-udp-kind)))
         (wkind
          (if (##fx= direction (macro-direction-in))
              (macro-none-kind)
              (macro-udp-kind)))
         (roptions
          0)
         (rtimeout
          #t)
         (rtimeout-thunk
          #f)
         (woptions
          0)
         (wtimeout
          #t)
         (wtimeout-thunk
          #f)
         (rdevice-condvar
          (and (##not (##fx= rkind (macro-none-kind)))
               (##make-io-condvar-for-reading device)))
         (wdevice-condvar
          (and (##not (##fx= wkind (macro-none-kind)))
               (##make-io-condvar-for-writing device))))

    (define (name port)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      id)

    (define (wait port direction)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))
      (if (##fx= direction (macro-direction-in))

        (##wait-for-io!
         (macro-udp-port-rdevice-condvar port)
         (macro-port-rtimeout port))

        (##wait-for-io!
         (macro-udp-port-wdevice-condvar port)
         (macro-port-wtimeout port))))

    (define (close port prim arg1)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let ((result
             (##close-device
              port
              (macro-udp-port-rdevice-condvar port)
              (macro-udp-port-wdevice-condvar port)
              prim)))
        (macro-port-mutex-unlock! port)
        (if (##fixnum? result)
            (##raise-os-io-exception port #f result prim arg1)
            result)))

    (define (set-rtimeout port timeout thunk)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (macro-port-rtimeout-set! port timeout)
      (macro-port-rtimeout-thunk-set! port thunk)
      (##condvar-signal-no-reschedule!
       (macro-udp-port-rdevice-condvar port)
       #t)
      (macro-port-mutex-unlock! port)
      (##void))

    (define (set-wtimeout port timeout thunk)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (macro-port-wtimeout-set! port timeout)
      (macro-port-wtimeout-thunk-set! port thunk)
      (##condvar-signal-no-reschedule!
       (macro-udp-port-wdevice-condvar port)
       #t)
      (macro-port-mutex-unlock! port)
      (##void))

    (define (read-datum port re)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##udp-read-subu8vector #f #f #f port read #!eof))

    (define (write-datum port obj we)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-check-u8vector
        obj
        1
        (write obj port)
        (##udp-write-subu8vector obj #f #f port write)))

    (define (newline port)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##void))

    (define (force-output port level prim arg1 arg2 arg3 arg4)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##void))

    (let ((port
           (macro-make-udp-port
            mutex
            rkind
            wkind
            name
            wait
            close
            roptions
            rtimeout
            rtimeout-thunk
            set-rtimeout
            woptions
            wtimeout
            wtimeout-thunk
            set-wtimeout
            #f ;; io-exception-handler
            read-datum
            write-datum
            newline
            force-output
            rdevice-condvar
            wdevice-condvar
            #f ;; latest-source
            )))
      (if rdevice-condvar
        (##io-condvar-port-set! rdevice-condvar port))
      (if wdevice-condvar
        (##io-condvar-port-set! wdevice-condvar port))
      port)))

(define-prim (##open-udp
              raise-os-exception?
              cont
              prim
              port-number-or-address-or-settings)

  (define (psettings->options psettings)
    0)

  (define (fail)
    (##fail-check-exact-integer-or-string-or-settings 1 prim port-number-or-address-or-settings))

  (##make-udp-psettings
   (cond ((##eq? port-number-or-address-or-settings (macro-absent-obj))
          '())
         ((##fixnum? port-number-or-address-or-settings)
          (##list 'local-port-number: port-number-or-address-or-settings))
         ((##string? port-number-or-address-or-settings)
          (##list 'local-address: port-number-or-address-or-settings))
         (else
          port-number-or-address-or-settings))
   fail
   (lambda (psettings)

     (define (stage1)
       (let ((local-address-or-host
              (macro-psettings-local-address psettings)))
         (if (##string? local-address-or-host)
             (let ((info (##host-info local-address-or-host #f)))
               (if (##fixnum? info)
                   (if raise-os-exception?
                       (##raise-os-exception #f info prim port-number-or-address-or-settings)
                       (cont info))
                 (stage2 (##car (macro-host-info-addresses info)))))
             (stage2 local-address-or-host))))

     (define (stage2 local-address)
       (let ((address-or-host
              (macro-psettings-address psettings)))
         (if (##string? address-or-host)
             (let ((info (##host-info address-or-host #f)))
               (if (##fixnum? info)
                   (if raise-os-exception?
                       (##raise-os-exception #f info prim port-number-or-address-or-settings)
                       (cont info))
                 (stage3 local-address
                         (##car (macro-host-info-addresses info)))))
             (stage3 local-address
                     address-or-host))))

     (define (stage3 local-address address)
       (let* ((local-port-number
               (macro-psettings-local-port-number psettings))
              (port-number
               (macro-psettings-port-number psettings))
              (local-a
               (if (##null? local-address)
                   (macro-localhost) ;; default local-address to localhost
                   local-address))
              (local-pn
               (if (##null? local-port-number)
                   #f ;; default to automatically assigned port number
                   local-port-number))
              (device
               (##os-device-udp-open
                local-a
                local-pn
                (psettings->options psettings))))
         (if (##fixnum? device)
             (if raise-os-exception?
                 (##raise-os-exception #f device prim port-number-or-address-or-settings)
                 (cont device))

             (let ((result (##os-device-udp-socket-info device #f)))
               (if (##fixnum? result)

                   (##raise-os-exception #f result prim port-number-or-address-or-settings)

                   (let* ((info
                           (##socket-info-setup! result))
                          (a
                           (macro-socket-info-address info))
                          (pn
                           (macro-socket-info-port-number info))
                          (port
                           (##make-udp-port
                            device
                            (##list 'udp
                                    (or a "*")
                                    pn)
                            psettings)))

                     (let ((wdevice-condvar
                            (macro-udp-port-wdevice-condvar port)))
                       (if wdevice-condvar
                           (##os-device-udp-destination-set!
                            wdevice-condvar
                            (if (##null? address)
                                (or a (macro-localhost))
                                address)
                            (if (##null? port-number)
                                pn
                                port-number))))

                     (cont port)))))))

     (stage1))))

(define-prim (open-udp
              #!optional
              (port-number-or-address-or-settings (macro-absent-obj)))
  (##open-udp
   #t
   (lambda (port) port)
   open-udp
   port-number-or-address-or-settings))

(define-prim (##udp-read-subu8vector u8vect start end port prim eof)

  (##declare (not interrupts-enabled))

  (define (err code)

    ;; signal an error

    (macro-port-mutex-unlock! port)
    (if u8vect
        (##raise-os-io-exception port #f code prim u8vect start end port)
        (##raise-os-io-exception port #f code prim port)))

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let loop ()
    (let ((result
           (##os-device-udp-read-subu8vector
            (macro-udp-port-rdevice-condvar port)
            u8vect
            start
            end)))

      (if (and (##fixnum? result) (##fx< result 0))

          ;; the read caused an error

          (cond ((##fx= result ##err-code-EINTR)

                 ;; the read was interrupted, so try again

                 (loop))

                ((##fx= result ##err-code-EAGAIN)

                 ;; the read would block, so wait and then try again

                 (macro-port-mutex-unlock! port)
                 (let ((continue?
                        (or (##wait-for-io!
                             (macro-udp-port-rdevice-condvar port)
                             (macro-port-rtimeout port))
                            ((macro-port-rtimeout-thunk port)))))
                   (if continue?
                       (begin
                         (macro-port-mutex-lock! port) ;; regain access to port
                         (loop))
                       eof)))

                (else

                 (err result)))

          (begin
            (macro-port-mutex-unlock! port)
            result)))))

(define-prim (udp-read-subu8vector
              u8vect
              start
              end
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (u8vect start end port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
    (macro-check-u8vector
      u8vect
      1
      (udp-read-subu8vector u8vect start end port)
      (macro-check-mutable
        u8vect
        1
        (udp-read-subu8vector u8vect start end port)
        (macro-check-index-range-incl
          start
          2
          0
          (##u8vector-length u8vect)
          (udp-read-subu8vector u8vect start end port)
          (macro-check-index-range-incl
            end
            3
            start
            (##u8vector-length u8vect)
            (udp-read-subu8vector u8vect start end port)
            (macro-check-udp-input-port
              p
              4
              (udp-read-subu8vector u8vect start end port)
              (##udp-read-subu8vector u8vect start end p udp-read-subu8vector #f)))))))))

(define-prim (##udp-read-u8vector port)
  (##udp-read-subu8vector #f #f #f port udp-read-u8vector #f))

(define-prim (udp-read-u8vector
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
      (macro-check-udp-input-port
        p
        1
        (udp-read-u8vector port)
        (##udp-read-u8vector p)))))

(define-prim (##udp-socket-info source port prim)

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let ((result
         (##os-device-udp-socket-info
          (macro-condvar-name
           (or (macro-udp-port-rdevice-condvar port)
               (macro-udp-port-wdevice-condvar port)))
          source)))

    (if (##fixnum? result)

        (begin
          (macro-port-mutex-unlock! port)
          (##raise-os-io-exception port #f result prim port))

        (let ((info
               (cond ((##eq? result #f) ;; no message received yet
                      result)
                     ((##eq? result #t) ;; same address as last time
                      ;; return last socket info
                      (macro-udp-port-latest-source port))
                     (else
                      (let ((info (##socket-info-setup! result)))
                        (if source
                            (begin
                              ;; new address... remember for next time
                              (macro-udp-port-latest-source-set! port info)))
                        info)))))
          (macro-port-mutex-unlock! port)
          info))))

(define-prim (##udp-local-socket-info port)
  (##udp-socket-info #f port udp-local-socket-info))

(define-prim (udp-local-socket-info
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
      (macro-check-udp-port
        p
        1
        (udp-local-socket-info port)
        (##udp-local-socket-info p)))))

(define-prim (##udp-source-socket-info port)
  (##udp-socket-info #t port udp-source-socket-info))

(define-prim (udp-source-socket-info
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-input-port)
               port)))
      (macro-check-udp-input-port
        p
        1
        (udp-source-socket-info port)
        (##udp-source-socket-info p)))))

(define-prim (##udp-socket-receive-buffer-size port)

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let ((result
         (##os-device-udp-socket-receive-buffer-size
          (macro-condvar-name
           (or (macro-udp-port-rdevice-condvar port)
               (macro-udp-port-wdevice-condvar port))))))

    (macro-port-mutex-unlock! port)
    result))

(define-prim (##udp-socket-send-buffer-size port)

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let ((result
         (##os-device-udp-socket-send-buffer-size
          (macro-condvar-name
           (or (macro-udp-port-rdevice-condvar port)
               (macro-udp-port-wdevice-condvar port))))))

    (macro-port-mutex-unlock! port)
    result))

(define-prim (##udp-write-subu8vector u8vect start end port prim)

  (##declare (not interrupts-enabled))

  (define (err code)

    ;; signal an error

    (macro-port-mutex-unlock! port)
    (if start
        (##raise-os-io-exception port #f code prim u8vect start end port)
        (##raise-os-io-exception port #f code prim u8vect port)))

  (macro-port-mutex-lock! port) ;; get exclusive access to port

  (let loop ()
    (let ((result
           (##os-device-udp-write-subu8vector
            (macro-udp-port-wdevice-condvar port)
            u8vect
            start
            end)))

      (if (and (##fixnum? result) (##fx< result 0))

          ;; the write caused an error

          (cond ((##fx= result ##err-code-EINTR)

                 ;; the write was interrupted, so try again

                 (loop))

                ((##fx= result ##err-code-EAGAIN)

                 ;; the write would block, so wait and then try again

                 (macro-port-mutex-unlock! port)
                 (let ((continue?
                        (or (##wait-for-io!
                             (macro-udp-port-wdevice-condvar port)
                             (macro-port-wtimeout port))
                            ((macro-port-wtimeout-thunk port)))))
                   (if continue?
                       (begin
                         (macro-port-mutex-lock! port) ;; regain access to port
                         (loop))
                       #f)))

                (else

                 (err result)))

          (begin
            (macro-port-mutex-unlock! port)
            result)))))

(define-prim (##udp-write-u8vector u8vect port)
  (##udp-write-subu8vector
   u8vect
   0
   (##u8vector-length u8vect)
   port
   udp-write-u8vector))

(define-prim (udp-write-u8vector
              u8vect
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (u8vect port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
    (macro-check-u8vector
      u8vect
      1
      (udp-write-u8vector u8vect port)
      (macro-check-udp-output-port
        p
        2
        (udp-write-u8vector u8vect port)
        (##udp-write-u8vector u8vect p))))))

(define-prim (udp-write-subu8vector
              u8vect
              start
              end
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (u8vect start end port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
    (macro-check-u8vector
      u8vect
      1
      (udp-write-subu8vector u8vect start end port)
      (macro-check-index-range-incl
        start
        2
        0
        (##u8vector-length u8vect)
        (udp-write-subu8vector u8vect start end port)
        (macro-check-index-range-incl
          end
          3
          start
          (##u8vector-length u8vect)
          (udp-write-subu8vector u8vect start end port)
          (macro-check-udp-output-port
            p
            4
            (udp-write-subu8vector u8vect start end port)
            (##udp-write-subu8vector
             u8vect
             start
             end
             port
             udp-write-subu8vector))))))))

(define-prim (udp-destination-set!
              address
              port-number
              #!optional
              (port (macro-absent-obj)))

  (macro-force-vars (address port-number port)
    (let ()

      (define (stage1)
        (if (##string? address)
            (let ((info (##host-info address #f)))
              (if (##fixnum? info)
                  (##raise-os-exception #f info udp-destination-set! address port-number port)
                  (stage2 (##car (macro-host-info-addresses info)))))
            (stage2 address)))

      (define (stage2 address)
        (macro-check-index-range-incl
          port-number
          2
          0
          65535
          (udp-destination-set! address port-number port)
          (let ((p
                 (if (##eq? port (macro-absent-obj))
                     (macro-current-output-port)
                     port)))
            (macro-check-udp-output-port
              p
              3
              (udp-destination-set! address port-number port)
              (let ((code
                     (##os-device-udp-destination-set!
                      (macro-udp-port-wdevice-condvar p)
                      address
                      port-number)))
                (if (##fx< code 0)
                    (##raise-os-exception #f code udp-destination-set! address port-number port)
                    (##void)))))))

      (stage1))))

))

;;;----------------------------------------------------------------------------

;;; Implementation of directory ports.

(implement-check-type-directory-port)

(define-prim (##make-directory-psettings
              direction
              settings
              fail
              succeed)
  (##make-psettings
   direction
   '(path:
     permissions:
     ignore-hidden:)
   settings
   fail
   succeed))

(define-prim (##make-directory-port rdevice path)
  (let ((mutex
         (macro-make-port-mutex))
        (rkind
         (macro-directory-kind))
        (wkind
         (macro-none-kind))
        (roptions
         0)
        (rtimeout
         #t)
        (rtimeout-thunk
         #f)
        (woptions
         0)
        (wtimeout
         #t)
        (wtimeout-thunk
         #f)
        (rdevice-condvar
         (##make-io-condvar-for-reading rdevice)))

    (define (name port)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-directory-port-path port))

    (define (wait port direction)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##wait-device port direction))

    (define (read-datum port re)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let loop ()
        (let ((datum
               (##os-device-directory-read
                (macro-directory-port-rdevice-condvar port))))
          (if (##fixnum? datum)

              (cond ((##fx= datum ##err-code-EINTR)

                     ;; the read was interrupted, so try again

                     (loop))

                    ((##fx= datum ##err-code-EAGAIN)

                     ;; the read would block, so wait and then try again

                     (macro-port-mutex-unlock! port)
                     (let ((continue?
                            (or (##wait-for-io!
                                 (macro-directory-port-rdevice-condvar port)
                                 (macro-port-rtimeout port))
                                ((macro-port-rtimeout-thunk port)))))
                       (if continue?
                           (begin
                             (macro-port-mutex-lock! port) ;; regain access to port
                             (loop))
                           #!eof)))

                    (else

                     ;; signal an error

                     (macro-port-mutex-unlock! port)
                     (##raise-os-io-exception port #f datum read port)))

              (begin
                (macro-port-mutex-unlock! port)
                datum)))))

    (define write-datum #f)

    (define newline #f)

    (define force-output #f)

    (define (set-rtimeout port timeout thunk)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (macro-port-rtimeout-set! port timeout)
      (macro-port-rtimeout-thunk-set! port thunk)
      (##condvar-signal-no-reschedule!
       (macro-directory-port-rdevice-condvar port)
       #t)
      (macro-port-mutex-unlock! port)
      (##void))

    (define set-wtimeout #f)

    (define (close port prim arg1)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let ((result
             (##close-device
              port
              (macro-directory-port-rdevice-condvar port)
              #f
              prim)))
        (macro-port-mutex-unlock! port)
        (if (##fixnum? result)
            (##raise-os-io-exception port #f result prim arg1)
            result)))

    (let ((port
           (macro-make-directory-port
            mutex
            rkind
            wkind
            name
            wait
            close
            roptions
            rtimeout
            rtimeout-thunk
            set-rtimeout
            woptions
            wtimeout
            wtimeout-thunk
            set-wtimeout
            #f ;; io-exception-handler
            read-datum
            write-datum
            newline
            force-output
            rdevice-condvar
            path)))
      (##io-condvar-port-set! rdevice-condvar port)
      port)))

(define-prim (##open-directory-aux
              raise-os-exception?
              cont
              prim
              #!optional
              (path-or-settings (macro-absent-obj)))

  (define (fail)
    (##fail-check-string-or-settings 1 prim path-or-settings))

  (##make-directory-psettings
   (macro-direction-in)
   (cond ((##eq? path-or-settings (macro-absent-obj))
          '())
         ((##string? path-or-settings)
          (##list 'path: path-or-settings))
         (else
          path-or-settings))
   fail
   (lambda (psettings)
     (let ((path
            (or (macro-psettings-path psettings)
                (##current-directory))))
       (if (##not (##string? path))
           (fail)
           (let* ((resolved-path
                   (##path-resolve path))
                  (rdevice
                   (##os-device-directory-open-path
                    resolved-path
                    (macro-psettings-ignore-hidden psettings))))
             (if (##fixnum? rdevice)
                 (if raise-os-exception?
                     (##raise-os-exception #f rdevice prim path)
                     (cont rdevice))
                 (cont (##make-directory-port rdevice path)))))))))

(define-prim (##open-directory
              #!optional
              (path-or-settings (macro-absent-obj)))
  (##open-directory-aux
   #t
   (lambda (port) port)
   open-directory
   path-or-settings))

(define-prim (open-directory
              #!optional
              (path-or-settings (macro-absent-obj)))
  (macro-force-vars (path-or-settings)
    (##open-directory path-or-settings)))

;;;----------------------------------------------------------------------------

;;; Implementation of event-queue ports.

(implement-check-type-event-queue-port)

(define-prim (##make-event-queue-port rdevice selector)
  (let ((mutex
         (macro-make-port-mutex))
        (rkind
         (macro-event-queue-kind))
        (wkind
         (macro-none-kind))
        (roptions
         0)
        (rtimeout
         #t)
        (rtimeout-thunk
         #f)
        (woptions
         0)
        (wtimeout
         #t)
        (wtimeout-thunk
         #f)
        (rdevice-condvar
         (##make-io-condvar-for-reading rdevice)))

    (define (name port)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##list 'event-queue (macro-event-queue-port-selector port)))

    (define (wait port direction)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (##wait-device port direction))

    (define (read-datum port re)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let loop ()
        (let ((result
               (##os-device-event-queue-read
                (macro-event-queue-port-rdevice-condvar port))))
          (if (and (##fixnum? result) (##fx< result 0))

              (cond ((##fx= result ##err-code-EINTR)

                     ;; the read was interrupted, so try again

                     (loop))

                    ((##fx= result ##err-code-EAGAIN)

                     ;; the read would block, so wait and then try again

                     (macro-port-mutex-unlock! port)
                     (let ((continue?
                            (or (##wait-for-io!
                                 (macro-event-queue-port-rdevice-condvar port)
                                 (macro-port-rtimeout port))
                                ((macro-port-rtimeout-thunk port)))))
                       (if continue?
                           (begin
                             (macro-port-mutex-lock! port) ;; regain access to port
                             (loop))
                           #!eof)))

                    (else

                     ;; signal an error

                     (macro-port-mutex-unlock! port)
                     (##raise-os-io-exception port #f result read port)))

              (begin
                (macro-port-mutex-unlock! port)
                result)))))

    (define write-datum #f)

    (define newline #f)

    (define force-output #f)

    (define (set-rtimeout port timeout thunk)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (macro-port-rtimeout-set! port timeout)
      (macro-port-rtimeout-thunk-set! port thunk)
      (##condvar-signal-no-reschedule!
       (macro-event-queue-port-rdevice-condvar port)
       #t)
      (macro-port-mutex-unlock! port)
      (##void))

    (define set-wtimeout #f)

    (define (close port prim arg1)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let ((result
             (##close-device
              port
              (macro-event-queue-port-rdevice-condvar port)
              #f
              prim)))
        (macro-port-mutex-unlock! port)
        (if (##fixnum? result)
            (##raise-os-io-exception port #f result prim arg1)
            result)))

    (let ((port
           (macro-make-event-queue-port
            mutex
            rkind
            wkind
            name
            wait
            close
            roptions
            rtimeout
            rtimeout-thunk
            set-rtimeout
            woptions
            wtimeout
            wtimeout-thunk
            set-wtimeout
            #f ;; io-exception-handler
            read-datum
            write-datum
            newline
            force-output
            rdevice-condvar
            selector)))
      (##io-condvar-port-set! rdevice-condvar port)
      port)))

(define-prim (##open-event-queue
              raise-os-exception?
              cont
              prim
              selector)
  (let ((rdevice
         (##os-device-event-queue-open selector)))
    (if (##fixnum? rdevice)
        (if raise-os-exception?
            (##raise-os-exception #f rdevice prim selector)
            (cont rdevice))
        (cont (##make-event-queue-port rdevice selector)))))

(define-prim (open-event-queue selector)

  (define (fail)
    (##fail-check-fixnum 1 open-event-queue selector))

  (macro-force-vars (selector)
    (if (##not (##fixnum? selector))
        (fail)
        (##open-event-queue
         #t
         (lambda (port) port)
         open-event-queue
         selector))))

;;;----------------------------------------------------------------------------

(define-prim (##make-path-psettings
              direction
              settings
              fail
              succeed)
  (##make-psettings
   direction
   '(path:
     append:
     create:
     truncate:
     permissions:
     output-width:
     input-char-encoding:
     output-char-encoding:
     char-encoding:
     input-char-encoding-errors:
     output-char-encoding-errors:
     char-encoding-errors:
     input-eol-encoding:
     output-eol-encoding:
     eol-encoding:
     direction:
     input-buffering:
     output-buffering:
     buffering:
     input-readtable:
     output-readtable:
     readtable:)
   settings
   fail
   succeed))

(define-prim (##make-input-path-psettings
              settings
              fail
              succeed)
  (##make-psettings
   (macro-direction-in)
   '(path:
     input-char-encoding:
     char-encoding:
     input-char-encoding-errors:
     char-encoding-errors:
     input-eol-encoding:
     eol-encoding:
     input-buffering:
     buffering:
     input-readtable:
     readtable:)
   settings
   fail
   succeed))

(define-prim (##open-file-generic
              direction
              raise-os-exception?
              cont
              prim
              path-or-settings
              #!optional
              (arg2 (macro-absent-obj)))

  (define (fail)
    (##fail-check-string-or-settings '(1 . path-or-settings) prim path-or-settings arg2))

  (##make-path-psettings
   direction
   (if (##string? path-or-settings)
       (##list 'path: path-or-settings)
       path-or-settings)
   fail
   (lambda (psettings)
     (let ((path (macro-psettings-path psettings)))
       (if (##not (##string? path))
           (fail)
           (##open-file-generic-from-psettings
            psettings
            raise-os-exception?
            cont
            prim
            path-or-settings
            arg2))))))

(define-prim (##open-file-generic-from-psettings
              psettings
              raise-os-exception?
              cont
              prim
              path-or-settings
              #!optional
              (arg2 (macro-absent-obj)))
  (let* ((path
          (macro-psettings-path psettings))
         (resolved-path
          (##path-resolve path))
         (device
          (##os-device-stream-open-path
           resolved-path
           (##psettings->device-flags psettings)
           (##psettings->permissions psettings #o666))))
    (if (##fixnum? device)
        (if raise-os-exception?
            (##raise-os-exception #f device prim path-or-settings arg2)
            (cont device resolved-path))
        (cont
         (##make-device-port-from-single-device
          (##path-unresolve resolved-path)
          device
          psettings)
         resolved-path))))

(define-prim (##path-reference path relative-to-path)
  (##path-expand
   path
   (if relative-to-path
       (##path-directory (##path-normalize relative-to-path))
       (##current-directory))))

(define-prim (##open-file path-or-settings)
  (##open-file-generic
   (macro-direction-inout)
   #t
   (lambda (port resolved-path) port)
   open-file
   path-or-settings))

(define-prim (open-file path-or-settings)
  (macro-force-vars (path-or-settings)
    (##open-file path-or-settings)))

(define-prim (##open-input-file path-or-settings)
  (##open-file-generic
   (macro-direction-in)
   #t
   (lambda (port resolved-path) port)
   open-input-file
   path-or-settings))

(define-prim (open-input-file path-or-settings)
  (macro-force-vars (path-or-settings)
    (##open-input-file path-or-settings)))

(define-prim (open-binary-input-file path-or-settings)
  (##open-file-generic
   (macro-direction-in)
   #t
   (lambda (port resolved-path) port)
   open-binary-input-file
   path-or-settings))

(define-prim (##open-output-file path-or-settings)
  (##open-file-generic
   (macro-direction-out)
   #t
   (lambda (port resolved-path) port)
   open-output-file
   path-or-settings))

(define-prim (open-output-file path-or-settings)
  (macro-force-vars (path-or-settings)
    (##open-output-file path-or-settings)))

(define-prim (open-binary-output-file path-or-settings)
  (##open-file-generic
   (macro-direction-out)
   #t
   (lambda (port resolved-path) port)
   open-binary-output-file
   path-or-settings))

(define-prim (##call-with-input-file path-or-settings proc)
  (##open-file-generic
   (macro-direction-in)
   #t
   (lambda (port resolved-path)
     (let ((results ;; may get bound to a multiple-values object
            (proc port)))
       (##close-port port)
       results))
   call-with-input-file
   path-or-settings
   proc))

(define-prim (call-with-input-file path-or-settings proc)
  (macro-force-vars (path-or-settings proc)
    (macro-check-procedure
      proc
      2
      (call-with-input-file path-or-settings proc)
      (##call-with-input-file path-or-settings proc))))

(define-prim (##call-with-output-file path-or-settings proc)
  (##open-file-generic
   (macro-direction-out)
   #t
   (lambda (port resolved-path)
     (let ((results ;; may get bound to a multiple-values object
            (proc port)))
       (##force-output port)
       (##close-port port)
       results))
   call-with-output-file
   path-or-settings
   proc))

(define-prim (call-with-output-file path-or-settings proc)
  (macro-force-vars (path-or-settings proc)
    (macro-check-procedure
      proc
      2
      (call-with-output-file path-or-settings proc)
      (##call-with-output-file path-or-settings proc))))

(define-prim (##with-input-from-file path-or-settings thunk)
  (##open-file-generic
   (macro-direction-in)
   #t
   (lambda (port resolved-path)
     (let ((results ;; may get bound to a multiple-values object
            (macro-dynamic-bind input-port port thunk)))
       (##close-port port)
       results))
   with-input-from-file
   path-or-settings
   thunk))

(define-prim (with-input-from-file path-or-settings thunk)
  (macro-force-vars (path-or-settings thunk)
    (macro-check-procedure
      thunk
      2
      (with-input-from-file path-or-settings thunk)
      (##with-input-from-file path-or-settings thunk))))

(define-prim (##with-output-to-file path-or-settings thunk)
  (##open-file-generic
   (macro-direction-out)
   #t
   (lambda (port resolved-path)
     (let ((results ;; may get bound to a multiple-values object
            (macro-dynamic-bind output-port port thunk)))
       (##force-output port)
       (##close-port port)
       results))
   with-output-to-file
   path-or-settings
   thunk))

(define-prim (with-output-to-file path-or-settings thunk)
  (macro-force-vars (path-or-settings thunk)
    (macro-check-procedure
      thunk
      2
      (with-output-to-file path-or-settings thunk)
      (##with-output-to-file path-or-settings thunk))))

;;;----------------------------------------------------------------------------

(define-prim (##call-with-port port proc)
  (let ((results ;; may get bound to a multiple-values object
         (proc port)))
    (##close-port port)
    results))

(define-prim (call-with-port port proc)
  (macro-force-vars (port proc)
    (macro-check-port port 1 (call-with-port port proc)
      (macro-check-procedure proc 2 (call-with-port port proc)
        (##call-with-port port proc)))))

(define-prim (##with-input-from-port port thunk)
  (macro-dynamic-bind input-port port thunk))

(define-prim (with-input-from-port port thunk)
  (macro-force-vars (port thunk)
    (macro-check-input-port port 1 (with-input-from-port port thunk)
      (macro-check-procedure thunk 2 (with-input-from-port port thunk)
        (##with-input-from-port port thunk)))))

(define-prim (##with-output-to-port port thunk)
  (macro-dynamic-bind output-port port thunk))

(define-prim (with-output-to-port port thunk)
  (macro-force-vars (port thunk)
    (macro-check-output-port port 1 (with-output-to-port port thunk)
      (macro-check-procedure thunk 2 (with-output-to-port port thunk)
        (##with-output-to-port port thunk)))))

;;;----------------------------------------------------------------------------

(define-prim (##make-raw-device-port direction device type id specific)
  (let ((mutex
         (macro-make-port-mutex))
        (rkind
         (if (##fx= direction (macro-direction-out))
             (macro-none-kind)
             (macro-raw-device-kind)))
        (wkind
         (if (##fx= direction (macro-direction-in))
             (macro-none-kind)
             (macro-raw-device-kind)))
        (roptions
         0)
        (rtimeout
         #t)
        (rtimeout-thunk
         #f)
        (woptions
         0)
        (wtimeout
         #t)
        (wtimeout-thunk
         #f)
        (rdevice-condvar
         (and (##not (##fx= direction (macro-direction-out)))
              (##make-io-condvar-for-reading device)))
        (wdevice-condvar
         (and (##not (##fx= direction (macro-direction-in)))
              (##make-io-condvar-for-writing device))))

    (define (name port)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))
      id)

    (define (wait port direction)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))
      (if (##fx= direction (macro-direction-in))

        (##wait-for-io!
         (macro-raw-device-port-rdevice-condvar port)
         (macro-port-rtimeout port))

        (##wait-for-io!
         (macro-raw-device-port-wdevice-condvar port)
         (macro-port-wtimeout port))))

    (define (close port prim arg1)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (let ((result
             (##close-device
              port
              (macro-raw-device-port-rdevice-condvar port)
              (macro-raw-device-port-wdevice-condvar port)
              prim)))
        (macro-port-mutex-unlock! port)
        (if (##fixnum? result)
            (##raise-os-io-exception port #f result prim arg1)
            result)))

    (define (set-rtimeout port timeout thunk)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (macro-port-rtimeout-set! port timeout)
      (macro-port-rtimeout-thunk-set! port thunk)
      (##condvar-signal-no-reschedule!
       (macro-raw-device-port-rdevice-condvar port)
       #t)
      (macro-port-mutex-unlock! port)
      (##void))

    (define (set-wtimeout port timeout thunk)

      ;; It is assumed that the thread **does not** have exclusive
      ;; access to the port.

      (##declare (not interrupts-enabled))

      (macro-port-mutex-lock! port) ;; get exclusive access to port

      (macro-port-wtimeout-set! port timeout)
      (macro-port-wtimeout-thunk-set! port thunk)
      (##condvar-signal-no-reschedule!
       (macro-raw-device-port-wdevice-condvar port)
       #t)
      (macro-port-mutex-unlock! port)
      (##void))

    (let ((port
           (macro-make-raw-device-port
            mutex
            rkind
            wkind
            name
            wait
            close
            roptions
            rtimeout
            rtimeout-thunk
            set-rtimeout
            woptions
            wtimeout
            wtimeout-thunk
            set-wtimeout
            #f ;; io-exception-handler
            rdevice-condvar
            wdevice-condvar
            type
            id
            specific)))
      (if rdevice-condvar
        (##io-condvar-port-set! rdevice-condvar port))
      (if wdevice-condvar
        (##io-condvar-port-set! wdevice-condvar port))
      port)))

;;;----------------------------------------------------------------------------

(define-prim (##open-predefined
              direction
              name
              index
              #!optional
              (settings '()))

  (##make-path-psettings
   direction
   settings
   ##exit-abruptly
   (lambda (psettings)
     (let ((device
            (##os-device-stream-open-predefined
             index
             (##psettings->device-flags psettings))))
       (if (##fixnum? device)
           (##exit-with-err-code device)
           (and device
                (let ((port
                       (##make-device-port-from-single-device
                        name
                        device
                        psettings)))
                  (if (and (##fx< index 0)
                           (##not (##eq? (macro-psettings-direction psettings)
                                         (macro-direction-in))))
                      (##add-exit-job!
                       (lambda ()
                         (##force-output-catching-exceptions port))))
                  port)))))))

(define ##stdin-port   #f)
(define ##stdout-port  #f)
(define ##stderr-port  #f)
(define ##console-port #f)

(define-prim (console-port)
  ##console-port)

(define-prim (##open-all-predefined)
  (let ((settings (##list 'readtable: ##main-readtable)))
    (set! ##stdin-port
      (##open-predefined (macro-direction-in)    '(stdin)   -1 settings))
    (set! ##stdout-port
      (##open-predefined (macro-direction-out)   '(stdout)  -2 settings))
    (set! ##stderr-port
      (##open-predefined (macro-direction-out)   '(stderr)  -3 settings))
    (set! ##console-port
      (##open-predefined (macro-direction-inout) '(console) -4 settings))))

;;;----------------------------------------------------------------------------

(define-prim (##make-filepos line col char-count)
  (if (and (##fx< line (macro-max-lines))
           (##not (##fx< (macro-max-fixnum32-div-max-lines) col)))
      (##fx+ line (##fx* col (macro-max-lines)))
      (##fx- 0 char-count)))

(define-prim (##filepos-line filepos)
  (if (##fx< filepos 0)
      0
      (##fxmodulo filepos (macro-max-lines))))

(define-prim (##filepos-col filepos)
  (if (##fx< filepos 0)
      (##fx- 0 filepos)
      (##fxquotient filepos (macro-max-lines))))

;;;----------------------------------------------------------------------------

;;; Implementation of readtables.

(implement-check-type-readtable)

(define-prim (##readtable? obj)
  (macro-readtable? obj))

(define-prim (readtable? obj)
  (macro-force-vars (obj)
    (macro-readtable? obj)))

(define-prim (##readtable-copy-shallow rt)
  (macro-readtable-copy rt))

(define-prim (##readtable-copy rt)
  (let ((copy (##readtable-copy-shallow rt)))
    (macro-readtable-char-delimiter?-table-set!
     rt
     (##chartable-copy (macro-readtable-char-delimiter?-table rt)))
    (macro-readtable-char-handler-table-set!
     rt
     (##chartable-copy (macro-readtable-char-handler-table rt)))
    (macro-readtable-char-sharp-handler-table-set!
     rt
     (##chartable-copy (macro-readtable-char-sharp-handler-table rt)))
    (let ((foreign-write-handler-table
           (macro-readtable-foreign-write-handler-table rt)))
      (if foreign-write-handler-table
          (macro-readtable-foreign-write-handler-table-set!
           copy
           (##table-copy foreign-write-handler-table))))
    copy))

(define-prim (readtable-case-conversion? rt)
  (macro-force-vars (rt)
    (macro-check-readtable rt 1 (readtable-case-conversion? rt)
      (macro-readtable-case-conversion? rt))))

(define-prim (readtable-case-conversion?-set rt conversion?)
  (macro-force-vars (rt conversion?)
    (macro-check-readtable rt 1 (readtable-case-conversion?-set rt conversion?)
      (let ((new-rt (##readtable-copy-shallow rt)))
        (macro-readtable-case-conversion?-set! new-rt conversion?)
        new-rt))))

(define-prim (readtable-keywords-allowed? rt)
  (macro-force-vars (rt)
    (macro-check-readtable rt 1 (readtable-keywords-allowed? rt)
      (macro-readtable-keywords-allowed? rt))))

(define-prim (readtable-keywords-allowed?-set rt allowed?)
  (macro-force-vars (rt allowed?)
    (macro-check-readtable rt 1 (readtable-keywords-allowed?-set rt allowed?)
      (let ((new-rt (##readtable-copy-shallow rt)))
        (macro-readtable-keywords-allowed?-set! new-rt allowed?)
        new-rt))))

(define-prim (readtable-sharing-allowed? rt)
  (macro-force-vars (rt)
    (macro-check-readtable rt 1 (readtable-sharing-allowed? rt)
      (macro-readtable-sharing-allowed? rt))))

(define-prim (readtable-sharing-allowed?-set rt allowed?)
  (macro-force-vars (rt allowed?)
    (macro-check-readtable rt 1 (readtable-sharing-allowed?-set rt allowed?)
      (let ((new-rt (##readtable-copy-shallow rt)))
        (macro-readtable-sharing-allowed?-set! new-rt allowed?)
        new-rt))))

(define-prim (readtable-eval-allowed? rt)
  (macro-force-vars (rt)
    (macro-check-readtable rt 1 (readtable-eval-allowed? rt)
      (macro-readtable-eval-allowed? rt))))

(define-prim (readtable-eval-allowed?-set rt allowed?)
  (macro-force-vars (rt allowed?)
    (macro-check-readtable rt 1 (readtable-eval-allowed?-set rt allowed?)
      (let ((new-rt (##readtable-copy-shallow rt)))
        (macro-readtable-eval-allowed?-set! new-rt allowed?)
        new-rt))))

(define-prim (readtable-write-extended-read-macros? rt)
  (macro-force-vars (rt)
    (macro-check-readtable rt 1 (readtable-write-extended-read-macros? rt)
      (macro-readtable-write-extended-read-macros? rt))))

(define-prim (readtable-write-extended-read-macros?-set rt allowed?)
  (macro-force-vars (rt allowed?)
    (macro-check-readtable rt 1 (readtable-write-extended-read-macros?-set rt allowed?)
      (let ((new-rt (##readtable-copy-shallow rt)))
        (macro-readtable-write-extended-read-macros?-set! new-rt allowed?)
        new-rt))))

(define-prim (readtable-write-cdr-read-macros? rt)
  (macro-force-vars (rt)
    (macro-check-readtable rt 1 (readtable-write-cdr-read-macros? rt)
      (macro-readtable-write-cdr-read-macros? rt))))

(define-prim (readtable-write-cdr-read-macros?-set rt allowed?)
  (macro-force-vars (rt allowed?)
    (macro-check-readtable rt 1 (readtable-write-cdr-read-macros?-set rt allowed?)
      (let ((new-rt (##readtable-copy-shallow rt)))
        (macro-readtable-write-cdr-read-macros?-set! new-rt allowed?)
        new-rt))))

(define-prim (readtable-max-write-level rt)
  (macro-force-vars (rt)
    (macro-check-readtable rt 1 (readtable-max-write-level rt)
      (macro-readtable-max-write-level rt))))

(define-prim (readtable-max-write-level-set rt level)
  (macro-force-vars (rt level)
    (macro-check-readtable rt 1 (readtable-max-write-level-set rt level)
      (macro-check-index level 2 (readtable-max-write-level-set rt level)
        (let ((new-rt (##readtable-copy-shallow rt)))
          (macro-readtable-max-write-level-set! new-rt level)
          new-rt)))))

(define-prim (readtable-max-write-length rt)
  (macro-force-vars (rt)
    (macro-check-readtable rt 1 (readtable-max-write-length rt)
      (macro-readtable-max-write-length rt))))

(define-prim (readtable-max-write-length-set rt length)
  (macro-force-vars (rt length)
    (macro-check-readtable rt 1 (readtable-max-write-length-set rt length)
      (macro-check-index length 2 (readtable-max-write-length-set rt length)
        (let ((new-rt (##readtable-copy-shallow rt)))
          (macro-readtable-max-write-length-set! new-rt length)
          new-rt)))))

(define-prim (readtable-max-unescaped-char rt)
  (macro-force-vars (rt)
    (macro-check-readtable rt 1 (readtable-max-unescaped-char rt)
      (macro-readtable-max-unescaped-char rt))))

(define-prim (readtable-max-unescaped-char-set rt char)

  (define (max-unescaped-char-set)
    (let ((new-rt (##readtable-copy-shallow rt)))
      (macro-readtable-max-unescaped-char-set! new-rt char)
      new-rt))

  (macro-force-vars (rt char)
    (macro-check-readtable rt 1 (readtable-max-unescaped-char-set rt char)
      (if (##eq? char #f)
          (max-unescaped-char-set)
          (macro-check-char char 2 (readtable-max-unescaped-char-set rt char)
            (max-unescaped-char-set))))))

(define-prim (readtable-comment-handler rt)
  (macro-force-vars (rt)
    (macro-check-readtable rt 1 (readtable-comment-handler rt)
      (macro-readtable-comment-handler rt))))

(define-prim (readtable-comment-handler-set rt conversion?)
  (macro-force-vars (rt conversion?)
    (macro-check-readtable rt 1 (readtable-comment-handler-set rt conversion?)
      (let ((new-rt (##readtable-copy-shallow rt)))
        (macro-readtable-comment-handler-set! new-rt conversion?)
        new-rt))))

(define-prim (readtable-start-syntax rt)
  (macro-force-vars (rt)
    (macro-check-readtable rt 1 (readtable-start-syntax rt)
      (macro-readtable-start-syntax rt))))

(define-prim (readtable-start-syntax-set rt start)
  (macro-force-vars (rt start)
    (macro-check-readtable rt 1 (readtable-start-syntax-set rt start)
      (let ((new-rt (##readtable-copy-shallow rt)))
        (macro-readtable-start-syntax-set! new-rt start)
        new-rt))))

(define ##scheme-file-extensions
  '((".sld" . #f)
    (".scm" . #f)
    (".six" . six)
    ))

(define-prim (##scheme-file-extensions-set! x)
  (set! ##scheme-file-extensions x))

(define ##language-specs
  '(
    ;; name      keywords-allowed?       start-syntax
    ;;  \     case-conversion?  \       /  srfi-22?
    ;;   \                    \  \     /  /
    #("gsi"                   #f #t scm #f)
    #("six"                   #f #t six #f)
    #("gsi-script"            #f #t scm #f)
    #("six-script"            #f #t six #f)
    #("scheme-srfi-0"         #t #f scm #t)
    #("scheme-r5rs"           #t #f scm #t)
    #("scheme-r4rs"           #t #f scm #t)
    #("scheme-ieee-1178-1990" #t #f scm #t)
    ))

(define-prim (##language-specs-set! x)
  (set! ##language-specs x))

(define-prim (##extract-language-and-tail script-line-or-program-path)

  (define (constituent? c)
    (or (##char-alphabetic? c)
        (##char-numeric? c)
        (##char=? c #\-)
        (##char=? c #\_)))

  (and script-line-or-program-path
       (let loop1 ((start 0))
         (let loop2 ((end start))

           (define (next)
             (if (##fx< end
                        (##string-length script-line-or-program-path))
                 (loop1 (##fx+ end 1))
                 #f))

           (if (and (##fx<
                     end
                     (##string-length script-line-or-program-path))
                    (let ((c (##string-ref script-line-or-program-path end)))
                      (constituent? c)))
               (loop2 (##fx+ end 1))
               (if (##fx= start end)
                   (next)
                   (let loop3 ((lst ##language-specs))
                     (if (##pair? lst)
                         (let* ((language (##car lst))
                                (name (macro-language-name language))
                                (len (##string-length name)))
                           (if (##not (##fx= (##fx- end start) len))
                               (loop3 (##cdr lst))
                               (let loop4 ((j start) (k 0))
                                 (if (##fx< j end)
                                     (if (##char=? (##string-ref
                                                    script-line-or-program-path
                                                    j)
                                                   (##string-ref name k))
                                         (loop4 (##fx+ j 1)
                                                (##fx+ k 1))
                                         (loop3 (##cdr lst)))
                                     (let loop5 ((end end))
                                       (if (##fx< (##fx+ end 2)
                                                  (##string-length
                                                   script-line-or-program-path))
                                           (if (and (##char=? (##string-ref
                                                               script-line-or-program-path
                                                               end)
                                                              #\space)
                                                    (##char=? (##string-ref
                                                               script-line-or-program-path
                                                               (##fx+ end 1))
                                                              #\-)
                                                    (##char=? (##string-ref
                                                               script-line-or-program-path
                                                               (##fx+ end 2))
                                                              #\:))
                                               (##cons language
                                                       (##substring
                                                        script-line-or-program-path
                                                        (##fx+ end 1)
                                                        (##string-length
                                                         script-line-or-program-path)))
                                               (loop5 (##fx+ end 1)))
                                           (##cons language
                                                   "")))))))
                         (next)))))))))

(define-prim (##readtable-setup-for-language! rt language)
  (macro-readtable-case-conversion?-set!
   rt
   (macro-language-case-conversion? language))
  (macro-readtable-keywords-allowed?-set!
   rt
   (macro-language-keywords-allowed? language))
  (macro-readtable-start-syntax-set!
   rt
   (macro-language-start-syntax language))
  (##readtable-setup-for-standard-level! rt))

(define-prim (##readtable-setup-for-standard-level! rt)
  (let ((standard-level (##get-standard-level)))

    (cond ((or (##fx= standard-level 4)  ;; R4RS language
               (##fx= standard-level 5)) ;; R5RS language
           (macro-readtable-case-conversion?-set! rt #t)
           (macro-readtable-keywords-allowed?-set! rt #f))

          ((or (##fx= standard-level 6)  ;; R6RS language
               (##fx= standard-level 7)) ;; R7RS language
           (macro-readtable-case-conversion?-set! rt #f)
           (macro-readtable-keywords-allowed?-set! rt #f))

          (else ;; Gambit language
           (macro-readtable-case-conversion?-set! rt #f)
           (macro-readtable-keywords-allowed?-set! rt #t)
           (macro-readtable-bracket-handler-set! rt '|[...]|)
           (macro-readtable-brace-handler-set! rt '|{...}|)))))

(define-prim (##make-readtable-parameter readtable)
  (##make-parameter
   readtable
   (lambda (val)
     (macro-check-readtable val 1 (##make-readtable-parameter val)
       val))))

(##define-macro (macro-ctrl-char? c)
  `(or (##char<? ,c #\space) (##char=? ,c #\delete)))

(##define-macro (macro-gt-max-unescaped-char? we c)
  `(##char<? (macro-writeenv-max-unescaped-char ,we) ,c))

(##define-macro (macro-must-escape-char? we c)
  `(or (macro-ctrl-char? ,c)
       (macro-gt-max-unescaped-char? ,we ,c)))

;;;----------------------------------------------------------------------------

(define-prim (##might-write-differently? old-obj new-obj)
  (cond ((##eq? old-obj new-obj)
         (or (##pair? new-obj)
             (and (##subtyped? new-obj)
                  (##not (or (##complex? new-obj)
                             (##symbol? new-obj)
                             (##keyword? new-obj))))))
        ((##complex? old-obj)
         (##not (and (##complex? new-obj)
                     (##= old-obj new-obj))))
        (else
         #t)))

;;;----------------------------------------------------------------------------

(define-prim (##default-wr we obj)
  (let ((limit (macro-writeenv-limit we)))
    (if (##fx< 0 limit)
        (cond ((##symbol? obj)
               (##wr-symbol we obj))
              ((##keyword? obj)
               (##wr-keyword we obj))
              ((##pair? obj)
               (##wr-pair we obj))
              ((##complex? obj)
               (##wr-complex we obj))
              ((##char? obj)
               (##wr-char we obj))
              ((##string? obj)
               (##wr-string we obj))
              ((##vector? obj)
               (##wr-vector we obj))
              ((##foreign? obj)
               (##wr-foreign we obj))
              ((##procedure? obj)
               (##wr-procedure we obj))
              ((##will? obj)
               (##wr-will we obj))
              ((##promise? obj)
               (##wr-promise we obj))
              ((##u8vector? obj)
               (##wr-u8vector we obj))
              ((macro-if-s8vector (##s8vector? obj) #f)
               (##wr-s8vector we obj))
              ((macro-if-u16vector (##u16vector? obj) #f)
               (##wr-u16vector we obj))
              ((macro-if-s16vector (##s16vector? obj) #f)
               (##wr-s16vector we obj))
              ((macro-if-u32vector (##u32vector? obj) #f)
               (##wr-u32vector we obj))
              ((macro-if-s32vector (##s32vector? obj) #f)
               (##wr-s32vector we obj))
              ((macro-if-u64vector (##u64vector? obj) #f)
               (##wr-u64vector we obj))
              ((macro-if-s64vector (##s64vector? obj) #f)
               (##wr-s64vector we obj))
              ((macro-if-f32vector (##f32vector? obj) #f)
               (##wr-f32vector we obj))
              ((##f64vector? obj)
               (##wr-f64vector we obj))
              ((##structure? obj)
               (##wr-structure we obj))
              ((##gc-hash-table? obj)
               (##wr-gc-hash-table we obj))
              ((##continuation? obj)
               (##wr-continuation we obj))
              ((##frame? obj)
               (##wr-frame we obj))
              ((##return? obj)
               (##wr-return we obj))
              ((##meroon? obj)
               (##wr-meroon we obj))
              ((##jazz? obj)
               (##wr-jazz we obj))
              ((##box? obj)
               (##wr-box we obj))
              (else
               (##wr-other we obj))))))

(define ##wr ##default-wr)

(define-prim (##wr-set! x)
  (set! ##wr x))

(define-prim (##wr-str we s)
  (##wr-substr we s 0 (##string-length s)))

(define-prim (##wr-substr we s i j)
  (let ((limit (macro-writeenv-limit we)))
    (if (##fx< 0 limit)
        (let ((len (##fx- j i))
              (port (macro-writeenv-port we)))
          (if (##fx< limit len)
              (begin
                (##write-substring s i (##fx+ i limit) port)
                (macro-writeenv-limit-set! we 0))
              (begin
                (##write-substring s i j port)
                (macro-writeenv-limit-set! we (##fx- limit len))))))))

(define-prim (##wr-ch we c)
  (let ((limit (macro-writeenv-limit we)))
    (if (##fx< 0 limit)
        (begin
          (macro-write-char c (macro-writeenv-port we))
          (macro-writeenv-limit-set! we (##fx- limit 1))))))

(define-prim (##wr-filler we n str)
  (let ((len (##string-length str)))
    (let loop ((i n))
      (if (##fx< 0 i)
          (let ((x (if (##fx< len i) len i)))
            (##wr-substr we str 0 x)
            (loop (##fx- i x)))))))

(define-prim (##wr-spaces we n)
  (##wr-filler we n "                                        "))

(define ##pretty-print-shifting-allowed? #t)

(define-prim (##pretty-print-shifting-allowed?-set! x)
  (set! ##pretty-print-shifting-allowed? x))

(define-prim (##wr-indent we shifted-col)
  (if (##fx> (##output-port-column (macro-writeenv-port we)) 1)
      (##wr-ch we #\newline))
  (let ((col
         (if ##pretty-print-shifting-allowed?
             (let loop ()
               (define margin-width 15)
               (let* ((shift
                       (macro-writeenv-shift we))
                      (width
                       (macro-writeenv-width we))
                      (width/2
                       (##fxquotient width 2))
                      (lo-lim
                       (##fxmin
                        margin-width
                        (##fxquotient width 5)))
                      (hi-lim
                       (##fxmax
                        (##fx- width margin-width)
                        (##fxquotient (##fx* width 4) 5)))
                      (col
                       (##fx- shifted-col shift)))
                 (cond ((##fx< col lo-lim)
                        (if (##fx= shift 0)
                            col
                            (let ((s (##fxmin shift width/2)))
                              (macro-writeenv-shift-set!
                               we
                               (##fx- shift s))
                              (##wr-str we ";;")
                              (##wr-filler we s ">>>>>>>>")
                              (##wr-ch we #\newline)
                              (loop))))
                       ((##fx> col hi-lim)
                        (let ((s width/2))
                          (macro-writeenv-shift-set!
                           we
                           (##fx+ shift s))
                          (##wr-str we ";;")
                          (##wr-filler we s "<<<<<<<<")
                          (##wr-ch we #\newline)
                          (loop)))
                       (else
                        col))))
             shifted-col)))
    (##wr-spaces we (##fx- col 1))))

(define-prim (##shifted-column we)
  (##fx+ (macro-writeenv-shift we)
         (##output-port-column (macro-writeenv-port we))))

(define-prim (##wr-sn we obj type name)
  (case (macro-writeenv-style we)
    ((mark)
     (if (##wr-mark-begin we obj)
         (begin
           (##wr-no-display we type)
           (if (##not (##eq? name (##void)))
               (##wr-no-display we name))
           (##wr-mark-end we obj))))
    (else
     (if (##wr-stamp we obj)
         (begin
           (##wr-str we "#<")
           (##wr-no-display we type)
           (##wr-str we " #")
           (##wr-str we (##number->string (##object->serial-number obj) 10))
           (if (##not (##eq? name (##void)))
               (begin
                 (##wr-ch we #\space)
                 (##wr-no-display we name)))
           (##wr-ch we #\>))))))

(define-prim (##wr-sn* we obj type proc)
  (case (macro-writeenv-style we)
    ((mark)
     (if (##wr-mark-begin we obj)
         (begin
           (##wr-no-display we type)
           (##wr-mark-end we obj))))
    (else
     (if (##wr-stamp we obj)
         (begin
           (##wr-str we "#<")
           (##wr-no-display we type)
           (##wr-str we " #")
           (##wr-str we (##number->string (##object->serial-number obj) 10))
           (if proc (proc we obj))
           (##wr-ch we #\>))))))

(define-prim (##wr-no-display we obj)
  (let ((style (macro-writeenv-style we)))
    (case style
      ((display print)
       (macro-writeenv-style-set! we 'write)
       (##wr we obj)
       (macro-writeenv-style-set! we style))
      (else
       (##wr we obj)))))

(define-prim (##wr-mark-begin we obj)
  (let ((mt (macro-writeenv-marktable we)))
    (if mt
        (##marktable-mark! mt obj #t)
        #t)))

(define-prim (##wr-mark-end we obj)
  (let ((mt (macro-writeenv-marktable we)))
    (and mt
         (##marktable-mark! mt obj #f))))

(define-prim (##wr-mark we obj)
  (##wr-mark-end we obj))

(define-prim (##wr-stamp we obj)
  (let ((mt (macro-writeenv-marktable we)))
    (if mt
        (let ((id (##marktable-lookup! mt obj #t)))
          (if id
              (begin
                (##wr-ch we #\#)
                (if (##fixnum? id)
                    (begin
                      (##wr-str we (##number->string id 10))
                      (##wr-ch we #\#)
                      #f)
                    (begin
                      (##wr-str we (##number->string (##cdr id) 10))
                      (##wr-ch we #\=)
                      #t)))
              #t))
        #t)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Write methods for each object type

(define-prim (##wr-symbol we obj)
  (let ((uninterned? (##uninterned-symbol? obj)))
    (case (macro-writeenv-style we)
      ((mark)
       (if uninterned?
           (##wr-mark we obj)))
      (else
       (if (or (##not uninterned?)
               (##wr-stamp we obj))
           (let ((str (##symbol->string obj)))
             (case (macro-writeenv-style we)
               ((display print)
                (##wr-str we str))
               (else
                (if uninterned?
                    (##wr-str we "#:"))
                (if (##not (##escape-symbol? we str))
                    (##wr-str we str)
                    (##wr-escaped-string we str #\|))))))))))

(define-prim (##escape-symbol? we str)
  (let ((n (##string-length str)))
    (or (##fx= n 0)
        (and (##fx= n 1)
             (##char=? (##string-ref str 0) #\.))
        (let loop ((i 0))
          (if (and (##fx< i n)
                   (##char=? (##string-ref str i) #\#))
              (loop (##fx+ i 1))
              (or (##fx= i 1)
                  (and (macro-readtable-sharp-seq-keyword
                        (macro-writeenv-readtable we))
                       (##fx= i n)))))
        (##string->number str 10 #t)
        (and (##fx< 1 n)
             (let ((keywords-allowed?
                    (macro-readtable-keywords-allowed?
                     (macro-writeenv-readtable we))))
               (and keywords-allowed?
                    (##char=? (##string-ref
                               str
                               (if (##eq? keywords-allowed? 'prefix)
                                   0
                                   (##fx- n 1)))
                              #\:))))
        (##escape-symkey? we str))))

(define-prim (##escape-symkey? we str);;;;;;;;;;;;;;;;;;;;;;;;;;
  (let ((rt (macro-writeenv-readtable we)))
    (or (##not (##string=?
                (##convert-case
                 (macro-readtable-case-conversion? rt)
                 str)
                str))
        (let ((n (##string-length str)))
          (let loop ((i (##fx- n 1)))
            (if (##fx< i 0)
                #f
                (let ((c (##string-ref str i)))
                  (or (macro-must-escape-char? we c)
                      (##readtable-char-delimiter? rt c)
                      (loop (##fx- i 1))))))))))

(define-prim (##wr-keyword we obj)
  (let ((uninterned? (##uninterned-keyword? obj)))
    (case (macro-writeenv-style we)
      ((mark)
       (if uninterned?
           (##wr-mark we obj)))
      (else
       (if (or (##not uninterned?)
               (##wr-stamp we obj))
           (let* ((str
                   (##keyword->string obj))
                  (keywords-allowed?
                   (macro-readtable-keywords-allowed?
                    (macro-writeenv-readtable we))))
             (case (macro-writeenv-style we)
               ((display print)
                (##wr-str we str))
               (else
                (if uninterned?
                    (##wr-str we "#:"))
                (if (##eq? keywords-allowed? 'prefix)
                    (##wr-ch we #\:))
                (if (##not (##escape-keyword? we str))
                    (##wr-str we str)
                    (##wr-escaped-string we str #\|))
                (if (##not (##eq? keywords-allowed? 'prefix))
                    (##wr-ch we #\:))))))))))

(define-prim (##escape-keyword? we str)
  (let ((n (##string-length str)))
    (or (##fx= n 0)
        (and (##char=? (##string-ref str 0) #\#)
             (or (##fx= n 1)
                 (let ((next (##string-ref str 1)))
                   (and (##not (##char=? next #\#))
                        (##not (##char=? next #\%)))))
             (let ((keywords-allowed?
                    (macro-readtable-keywords-allowed?
                     (macro-writeenv-readtable we))))
               (##not (##eq? keywords-allowed? 'prefix))))
        (##escape-symkey? we str))))

(define-prim (##wr-pair we obj)

  (define (force-if-required we x)
    (if (macro-writeenv-force? we)
        (##force x)
        x))

  (define (read-macro-prefix we head tail)

    (define (check-for-at-sign str1 str2)

      ;; We have to check that the next character written after the
      ;; comma won't be an "@" because the reader would interpret this
      ;; as a ",@" or "#,@" readmacro.  The algorithm is slow but
      ;; correct and modular.

      (let ((limit (macro-writeenv-limit we)))
        (if (##fx< 1 limit) ;; speed up ",,,,,,xxx" case
            (let* ((mt
                    (macro-writeenv-marktable we))
                   (state
                    (and mt (##marktable-save mt)))
                   (port
                    (##open-output-string))
                   (we2
                    (##make-writeenv
                     (macro-writeenv-style we)
                     port
                     (macro-writeenv-readtable we)
                     mt
                     (macro-writeenv-force? we)
                     (macro-writeenv-width we)
                     (macro-writeenv-shift we)
                     (macro-writeenv-close-parens we)
                     (macro-writeenv-level we)
                     1
                     (macro-writeenv-max-unescaped-char we))))
              (##wr we2 (##car tail))
              (if mt (##marktable-restore! mt state))
              (let ((str (##get-output-string port)))
                (if (or (##fx< (##string-length str) 1)
                        (##char=? (##string-ref str 0) #\@))
                    str2 ;; force a space after the comma
                    str1)))
            str1)))

    (and head
         (##pair? tail)
         (##null? (force-if-required we (##cdr tail)))
         (let ((mt (macro-writeenv-marktable we)))
           (##not (and mt
                       (##marktable-lookup! mt tail #f))))
         (cond ((##eq? head
                       (macro-readtable-quote-keyword
                        (macro-writeenv-readtable we)))
                "'")
               ((##eq? head
                       (macro-readtable-quasiquote-keyword
                        (macro-writeenv-readtable we)))
                "`")
               ((##eq? head
                       (macro-readtable-unquote-keyword
                        (macro-writeenv-readtable we)))
                (check-for-at-sign "," ", "))
               ((##eq? head
                       (macro-readtable-unquote-splicing-keyword
                        (macro-writeenv-readtable we)))
                ",@")
               (else
                (and (macro-readtable-write-extended-read-macros?
                      (macro-writeenv-readtable we))
                     (cond ((##eq? head
                                   (macro-readtable-sharp-quote-keyword
                                    (macro-writeenv-readtable we)))
                            "#'")
                           ((##eq? head
                                   (macro-readtable-sharp-quasiquote-keyword
                                    (macro-writeenv-readtable we)))
                            "#`")
                           ((##eq? head
                                   (macro-readtable-sharp-unquote-keyword
                                    (macro-writeenv-readtable we)))
                            (check-for-at-sign "#," "#, "))
                           ((##eq? head
                                   (macro-readtable-sharp-unquote-splicing-keyword
                                    (macro-writeenv-readtable we)))
                            "#,@")
                           (else
                            #f)))))))

  (define (wr-list-according-to-head we obj plain-pretty-print?)
    (let* ((head
            (force-if-required we (##car obj)))
           (tail
            (force-if-required we (##cdr obj))))

      (define (parenthesized-normal)
        (wr-list-using-format
         we
         obj
         (##reader->open-close we ##read-list '("(" . ")"))
         (case (macro-writeenv-style we)
           ((pretty-print)
            (if plain-pretty-print?
                plain-format
                (get-format we head tail)))
           (else
            space-format))))

      (define (parenthesized-read-macro open-close)
        (wr-list-using-format
         we
         tail
         open-close
         (case (macro-writeenv-style we)
           ((pretty-print) plain-format)
           (else           space-format))))

      (cond ((##eq? head (##print-marker))
             (let ((style (macro-writeenv-style we)))
               (macro-writeenv-style-set! we 'print)
               (let ((result (##wr we tail)))
                 (macro-writeenv-style-set! we style)
                 result)))
            ((not (and head
                       (or (##null? tail)
                           (##pair? tail))))
             (parenthesized-normal))
            ((and (##not (##procedure? head))
                  (##head->open-close we head #f))
             =>
             (lambda (open-close)
               (parenthesized-read-macro open-close)))
            (else
             (let ((prefix
                    (read-macro-prefix we head tail)))
               (if prefix
                   (begin
                     (##wr-str we prefix)
                     (##wr we (##car tail)))
                   (parenthesized-normal)))))))

  (define space-format
    '#(0 #f 0 #f -1))

  (define plain-format
    '#(0 #f 1 #f 0))

  (define (get-format we head tail)
    (if (##symbol? head)
        (let ((x
               (##assq head
                       (macro-readtable-pretty-print-formats
                        (macro-writeenv-readtable we)))))
          (cond (x
                 (if (and (##eq? head 'let) ;; check for named let
                          (##pair? tail)
                          (##symbol? (force-if-required we (##car tail))))
                     '#(2 #t 3 #f 1)
                     (##cdr x)))
                ((##fx< (##string-length (##symbol->string head))
                        ##list-max-head)
                 '#(1 #f 0 #f 1))
                (else
                 plain-format)))
        plain-format))

  (define (wr-list-using-format we obj open-close format)

    (##wr-str we (##car open-close))

    (let ((level
           (macro-writeenv-level we)))
      (if (##not (##fx< level
                        (macro-readtable-max-write-level
                         (macro-writeenv-readtable we))))
          (##wr-str we "...")
          (let* ((close-parens
                  (macro-writeenv-close-parens we))
                 (new-close-parens
                  (##fx+ close-parens 1)))
            (macro-writeenv-level-set! we (##fx+ level 1))
            (let ((start-col (##shifted-column we)))
              (let loop ((lst obj)
                         (i 0)
                         (col start-col))

                (define (wr-elem elem)
                  (let ((new-col
                         (cond ((##fx= i 0)
                                col)
                               ((or (##fx< (##vector-ref format 4) 0)
                                    (##fx< i (##vector-ref format 0)))
                                (##wr-ch we #\space)
                                col)
                               ((##fx= i (##vector-ref format 0))
                                (##wr-ch we #\space)
                                (##shifted-column we))
                               ((##fx= i (##vector-ref format 2))
                                (let ((new-col
                                       (##fx+ start-col
                                              (##vector-ref format 4))))
                                  (##wr-indent we new-col)
                                  new-col))
                               (else
                                (##wr-indent we col)
                                col))))
                    (if (##pair? elem)
                        (wr-list
                         we
                         elem
                         (if (##fx< i (##vector-ref format 2))
                             (##vector-ref format 1)
                             (##vector-ref format 3)))
                        (##wr we elem))
                    new-col))

                (define (wr-str str)
                  (let ((style (macro-writeenv-style we)))
                    (macro-writeenv-style-set! we 'print)
                    (wr-elem str)
                    (macro-writeenv-style-set! we style)))

                (if (##fx< 0 (macro-writeenv-limit we))
                    (cond ((##pair? lst)
                           (if (##not (##fx< i
                                             (macro-readtable-max-write-length
                                              (macro-writeenv-readtable we))))
                               (wr-str "...")
                               (let ((mt (macro-writeenv-marktable we)))
                                 (if (and (##fx< 0 i)
                                          mt
                                          (##marktable-lookup! mt lst #f))
                                     (begin
                                       (wr-str ".")
                                       (macro-writeenv-close-parens-set!
                                        we
                                        new-close-parens)
                                       (wr-elem lst))
                                     (let* ((head
                                             (force-if-required we (##car lst)))
                                            (tail
                                             (force-if-required we (##cdr lst)))
                                            (prefix
                                             (and (macro-readtable-write-cdr-read-macros?
                                                   (macro-writeenv-readtable we))
                                                  (read-macro-prefix we head tail))))
                                       (if prefix
                                           (begin
                                             (wr-str ".")
                                             (wr-str prefix)
                                             (macro-writeenv-close-parens-set!
                                              we
                                              new-close-parens)
                                             (##wr we (##car tail)))
                                           (begin
                                             (macro-writeenv-close-parens-set!
                                              we
                                              (if (##null? tail)
                                                  new-close-parens
                                                  0))
                                             (loop tail
                                                   (##fx+ i 1)
                                                   (if (and (##eq? head '|.|)
                                                            (##fx= i 0)
                                                            (macro-readtable-dot-at-head-of-list-allowed?
                                                             (macro-writeenv-readtable we)))
                                                       (wr-str ".")
                                                       (wr-elem head))))))))))
                          ((##not (##null? lst))
                           (wr-str ".")
                           (macro-writeenv-close-parens-set! we new-close-parens)
                           (wr-elem lst))))))
            (macro-writeenv-level-set! we level)
            (macro-writeenv-close-parens-set! we close-parens))))

    (##wr-str we (##cdr open-close)))

  (define (wr-list we obj plain-pretty-print?)
    (if (##wr-stamp we obj)
        (if (case (macro-writeenv-style we)
              ((pretty-print)
               (##not (##wr-one-line-pretty-print
                       we
                       obj
                       (lambda (we obj)
                         (wr-list-according-to-head
                          we
                          obj
                          plain-pretty-print?)))))
              (else
               #t))
            (wr-list-according-to-head
             we
             obj
             plain-pretty-print?))))

  (case (macro-writeenv-style we)
    ((mark)
     (if (##wr-mark-begin we obj)
         (begin;;;;;;;;;;;;;;;;;;;;;;;check level and length?
           (##wr we (##car obj))
           (##wr we (##cdr obj))
           (##wr-mark-end we obj))))
    ((print)
     (##wr we (##car obj))
     (##wr we (##cdr obj)))
    (else
     (wr-list we obj #f))))

(define (##print-marker) '#(print))

(define-prim (##wr-one-line-pretty-print we obj wr-obj)
  (let* ((col
          (##shifted-column we))
         (available-space-for-obj
          (##fx-
           (##fx-
            (##fx+
             (macro-writeenv-shift we)
             (macro-writeenv-width we))
            (macro-writeenv-close-parens we))
           col))
         (str
          (##wr-fits-on-line
           we
           obj
           wr-obj
           available-space-for-obj)))
    (and str
         (begin
           (##wr-str we str)
           #t))))

(define-prim (##wr-fits-on-line we obj wr-obj available-space-for-obj)
  (let* ((mt
          (macro-writeenv-marktable we))
         (state
          (and mt (##marktable-save mt)))
         (port
          (##open-output-string))
         (we2
          (##make-writeenv
           'write
           port
           (macro-writeenv-readtable we)
           mt
           (macro-writeenv-force? we)
           (macro-writeenv-width we)
           (macro-writeenv-shift we)
           (macro-writeenv-close-parens we)
           (macro-writeenv-level we)
           (##fx+ available-space-for-obj 1)
           (macro-writeenv-max-unescaped-char we))))
    (wr-obj we2 obj)
    (let ((str (##get-output-string port)))
      (if (##fx< available-space-for-obj (##string-length str))
          (begin
            (if mt (##marktable-restore! mt state))
            #f)
          str))))

(define-prim (##wr-complex we obj)
  (case (macro-writeenv-style we)
    ((mark)
     (if (##not (##fixnum? obj))
         (##wr-mark we obj)))
    (else
     (##wr-str we (##number->string obj 10)))))

(define-prim (##wr-char we obj)
  (case (macro-writeenv-style we)
    ((mark)
     #f)
    ((display print)
     (##wr-ch we obj))
    (else
     (let ((x (##assq-cdr obj
                          (macro-readtable-named-char-table
                           (macro-writeenv-readtable we)))))
       (##wr-str we "#\\")
       (cond (x
              (##wr-str we (##car x)))
             ((##not (macro-must-escape-char? we obj))
              (##wr-ch we obj))
             (else
              (let ((n (##char->integer obj)))
                (cond ((macro-readtable-r7rs-compatible-write?
                        (macro-writeenv-readtable we))
                       (##wr-ch we #\x)
                       (##wr-hex we n #f))
                      ((##fx< #xffff n)
                       (##wr-ch we #\U)
                       (##wr-hex we n 8))
                      ((##fx< #xff n)
                       (##wr-ch we #\u)
                       (##wr-hex we n 4))
                      (else
                       (##wr-ch we #\x)
                       (##wr-hex we n 2))))))))))

(define-prim (##wr-hex we n nb-digits)
  (if (if nb-digits
          (##fx< 1 nb-digits)
          (##fx< 15 n))
      (##wr-hex we
                (##fxwraplogical-shift-right n 4)
                (and nb-digits (##fx- nb-digits 1))))
  (##wr-ch we
           (##string-ref ##digit-to-char-table (##fxand n 15))))

(define-prim (##wr-oct we n nb-digits)
  (if (if nb-digits
          (##fx< 1 nb-digits)
          (##fx< 7 n))
      (##wr-oct we
                (##fxwraplogical-shift-right n 3)
                (and nb-digits (##fx- nb-digits 1))))
  (##wr-ch we
           (##string-ref ##digit-to-char-table (##fxand n 7))))

(define-prim (##wr-string we obj)
  (case (macro-writeenv-style we)
    ((mark)
     (##wr-mark we obj))
    ((display print)
     (##wr-str we obj))
    (else
     (if (##wr-stamp we obj)
         (##wr-escaped-string we obj #\")))))

(define-prim (##wr-escaped-string we s special-escape)
  (##wr-ch we special-escape)
  (let loop ((i 0) (j 0) (escape-digit-limit #f))
    (if (##fx< j (##string-length s))
        (let* ((c
                (##string-ref s j))
               (n
                (##char->integer c))
               (ctrl-char?
                (macro-ctrl-char? c))
               (x
                (cond ((or (##char=? c #\\)
                           (##char=? c special-escape))
                       c)
                      ((and ctrl-char?
                            (##assq-cdr c
                                        (macro-readtable-escaped-char-table
                                         (macro-writeenv-readtable we))))
                       =>
                       ##car)
                      (else
                       #f)))
               (j+1
                (##fx+ j 1)))
          (if (if ctrl-char?
                  (macro-readtable-escape-ctrl-chars?
                   (macro-writeenv-readtable we))
                  (or x
                      (macro-gt-max-unescaped-char? we c)
                      (and escape-digit-limit
                           (##fx< n 128)
                           (##not (##char=? c #\#)) ;; avoid treating "#" like "0"
                           (##fx< (##u8vector-ref ##char-to-digit-table n)
                                  escape-digit-limit))))
              (begin
                (##wr-substr we s i j)
                (##wr-ch we #\\)
                (cond (x
                       (##wr-ch we x)
                       (loop j+1 j+1 #f))
                      ((macro-readtable-r7rs-compatible-write?
                        (macro-writeenv-readtable we))
                       (##wr-ch we #\x)
                       (##wr-hex we n #f)
                       (##wr-ch we #\;)
                       (loop j+1 j+1 #f))
                      ((##fx< #xffff n)
                       (##wr-ch we #\U)
                       (##wr-hex we n 8)
                       (loop j+1 j+1 #f))
                      ((##fx< #xff n)
                       (##wr-ch we #\u)
                       (##wr-hex we n 4)
                       (loop j+1 j+1 #f))
                      #; ;; disable \x... escapes on output
                      (#t
                       (##wr-ch we #\x)
                       (##wr-hex we n #f)
                       (loop j+1 j+1 16))
                      (else
                       (##wr-oct we n #f)
                       (loop j+1 j+1 (if (##fx< n 32) 8 #f)))))
              (loop i j+1 #f)))
        (begin
          (##wr-substr we s i j)
          (##wr-ch we special-escape)))))

(define-prim (##reader->open-close we reader default)
  (let ((rt (macro-writeenv-readtable we)))
    (cond ((##eq? (##readtable-char-handler rt #\() reader) '("(" . ")"))
          ((##eq? (##readtable-char-handler rt #\[) reader) '("[" . "]"))
          ((##eq? (##readtable-char-handler rt #\{) reader) '("{" . "}"))
          ((##eq? (##readtable-char-handler rt #\<) reader) '("<" . ">"))
          (else                                             default))))

(define-prim (##head->open-close we head default)
  (let ((rt (macro-writeenv-readtable we)))
    (cond ((##eq? head (macro-readtable-paren-handler rt))   '("(" . ")"))
          ((##eq? head (macro-readtable-bracket-handler rt)) '("[" . "]"))
          ((##eq? head (macro-readtable-brace-handler rt))   '("{" . "}"))
          ((##eq? head (macro-readtable-angle-handler rt))   '("<" . ">"))
          (else                                              default))))

(define-prim (##wr-vector we obj)
  (let* ((std-open-close
          '("#(" . ")"))
         (open-close
          (if (macro-readtable-r6rs-compatible-write?
               (macro-writeenv-readtable we))
              std-open-close
              (##reader->open-close we ##read-vector-or-list std-open-close))))
    (##wr-vector-aux1 we obj (##vector-length obj) ##vector-ref open-close)))

(define-prim (##wr-vector-aux1 we obj len vect-ref open-close)
  (case (macro-writeenv-style we)
    ((mark)
     (if (##wr-mark-begin we obj)
         (begin
           (##wr-vector-aux2 we obj len vect-ref)
           (##wr-mark-end we obj))))
    ((print)
     (##wr-vector-aux2 we obj len vect-ref))
    (else
     (if (##wr-stamp we obj)
         (##wr-vector-aux3 we obj len vect-ref open-close)))))

(define-prim (##wr-vector-aux2 we obj len vect-ref)
  (let ((level
         (macro-writeenv-level we)))
    (if (##fx< level
               (macro-readtable-max-write-level
                (macro-writeenv-readtable we)))
        (begin
          (macro-writeenv-level-set! we (##fx+ level 1))
          (let loop ((i 0))
            (if (##fx< i len)
                (if (##fx< i
                           (macro-readtable-max-write-length
                            (macro-writeenv-readtable we)))
                    (begin
                      (##wr we (vect-ref obj i))
                      (loop (##fx+ i 1))))))
          (macro-writeenv-level-set! we level)))))

(define-prim (##wr-vector-aux3 we obj len vect-ref open-close)

  (define (wr-vect we obj len vect-ref open-close)

    (##wr-str we (##car open-close))

    (let ((level
           (macro-writeenv-level we)))
      (if (##not (##fx< level
                        (macro-readtable-max-write-level
                         (macro-writeenv-readtable we))))
          (##wr-str we "...")
          (let* ((close-parens
                  (macro-writeenv-close-parens we))
                 (new-close-parens
                  (##fx+ close-parens 1)))
            (macro-writeenv-level-set! we (##fx+ level 1))
            (let ((start-col
                   (##shifted-column we)))
              (let loop ((i 0))
                (if (##fx< 0 (macro-writeenv-limit we))
                    (if (##fx< i len)
                        (let ()
                          (if (##fx< 0 i)
                              (case (macro-writeenv-style we)
                                ((pretty-print) (##wr-indent we start-col))
                                (else           (##wr-ch we #\space))))
                          (if (##not (##fx< i
                                            (macro-readtable-max-write-length
                                             (macro-writeenv-readtable we))))
                              (##wr-str we "...")
                              (let ((elem
                                     (vect-ref obj i))
                                    (new-i
                                     (##fx+ i 1)))
                                (macro-writeenv-close-parens-set!
                                 we
                                 (if (##fx= new-i len)
                                     new-close-parens
                                     0))
                                (##wr we elem)
                                (loop new-i))))))))
            (macro-writeenv-level-set! we level)
            (macro-writeenv-close-parens-set! we close-parens))))

    (##wr-str we (##cdr open-close)))

  (if (case (macro-writeenv-style we)
        ((pretty-print)
         (##not (##wr-one-line-pretty-print
                 we
                 obj
                 (lambda (we obj)
                   (wr-vect we obj len vect-ref open-close)))))
        (else
         #t))
      (wr-vect we obj len vect-ref open-close)))

(define-prim (##wr-foreign we obj)
  (case (macro-writeenv-style we)
    ((mark)
     (##wr-mark we obj))
    (else
     (let* ((tags
             (##foreign-tags obj))
            (tag
             (if (##pair? tags) (##car tags) #f))
            (foreign-write-handler-table
             (macro-readtable-foreign-write-handler-table
              (macro-writeenv-readtable we)))
            (handler
             (and foreign-write-handler-table
                  (##table-ref foreign-write-handler-table tag))))
       (if handler
           (handler we obj)
           (##wr-sn* we
                     obj
                     (or tag 'foreign)
                     (lambda (we obj)
                       (##wr-str we " ")
                       (let ((addr (##foreign-address obj)))
                         (if (##number? addr)
                             (begin
                               (##wr-str we "0x")
                               (##wr-str we
                                         (##number->string
                                          (##foreign-address obj)
                                          16)))
                             (##wr-no-display we addr))))))))))

(define-prim (##readtable-foreign-write-handler-register! rt tag proc)
  (##declare (not interrupts-enabled))
  (let ((foreign-write-handler-table
         (or (macro-readtable-foreign-write-handler-table rt)
             (let ((t (##make-table-aux 0 #f #f #f ##eq?)))
               (macro-readtable-foreign-write-handler-table-set! rt t)
               (macro-readtable-foreign-write-handler-table rt)))))
    (if proc
        (##table-set! foreign-write-handler-table tag proc)
        (##table-set! foreign-write-handler-table tag))))

(define-prim (##explode-object obj)
  (##vector-copy obj))

(define-prim (##implode-object re fields subtype)
  (let* ((n (##vector-length fields))
         (v (##make-vector n)))
    (##subtype-set! v subtype)
    (let loop ((i (##fx- n 1)))
      (if (##fx< i 0)
          v
          (let ((obj (##vector-ref fields i)))
            (if (##label-marker? obj)
                (##label-marker-fixup-handler-add!
                 re
                 obj
                 (lambda (resolved-obj)
                   (##vector-set! v i resolved-obj)))
                (##vector-set! v i obj))
            (loop (##fx- i 1)))))))

(define-prim (##explode-structure obj)
  (##explode-object obj))

(define-prim (##implode-structure re fields)
  (##implode-object re fields (macro-subtype-structure)))

';old version... more type checks but incomplete type checks so why bother?
(define-prim (##implode-structure re fields)
  (let ((nb-fields (##vector-length fields)))
    (if (##fx< 0 nb-fields)
        (let ((n (##vector-length fields)))
          (let ((s (##make-vector n)))

            (define (set-element! i obj)
              (##vector-set! s i obj)
              (if (##fx= i 0)
                  (let ((n (##vector-length s)))
                    (##subtype-set! s (macro-subtype-structure))
                    (if (##not (and (##type? obj)
                                    (##fx= (##type-field-count obj)
                                           (##fx- n 1))))
                        (##subtype-set! s (macro-subtype-vector))))))

            (let loop ((i (##fx- n 1)))
              (if (##fx< i 0)
                  s
                  (let ((obj (##vector-ref fields i)))
                    (if (##label-marker? obj)
                        (##label-marker-fixup-handler-add!
                         re
                         obj
                         (lambda (resolved-obj)
                           (set-element! i resolved-obj)))
                        (set-element! i obj))
                    (loop (##fx- i 1)))))))
        #f)))

(define-prim (##implode-frame re fields)
  (##implode-object re fields (macro-subtype-frame)))

(define-prim (##implode-continuation re fields)
  (##implode-object re fields (macro-subtype-continuation)))

(define-prim (##explode-procedure proc)
  (cond ((##closure? proc)
         (##explode-closure proc))
        (else
         (##explode-subprocedure proc '()))))

(define-prim (##explode-closure closure)
  (let loop ((i (##fx- (##closure-length closure) 1))
             (lst '()))
    (if (##fx< i 1)
        (##explode-subprocedure (##closure-code closure) lst)
        (loop (##fx- i 1)
              (##cons (##closure-ref closure i) lst)))))

(define-prim (##explode-subprocedure subproc lst)
  (let ((parent-name
         (##subprocedure-parent-name subproc)))
    (if parent-name
        (##list->vector
         (##cons parent-name
                 (let ((id (##subprocedure-id subproc)))
                   (if (and (##fx= id 0) (##null? lst))
                       '()
                       (##cons id lst)))))
        '#())))

(define-prim (##implode-procedure re fields)
  (let ((x (##implode-procedure-or-return re fields)))
    (if (##procedure? x)
        x
        #f)))

(define-prim (##implode-procedure-or-return re fields)
  ;;;;; why bother with all these checks if they are incomplete?
  (let ((nb-fields (##vector-length fields)))
    (if (##fx= nb-fields 0)
        #f
        (let ((proc-identifier (##vector-ref fields 0)))
          (if (##symbol? proc-identifier)
              (let* ((var (##make-global-var proc-identifier))
                     (proc (##global-var-primitive-ref var)))
                (if (and (##procedure? proc)
                         (##not (##subprocedure? proc))
                         (##not (##closure? proc)))
                    (if (##fx= nb-fields 1)
                        proc
                        (let ((subproc-id (##vector-ref fields 1)))
                          (if (and (##fixnum? subproc-id)
                                   (##fx< 0 subproc-id))
                              (let ((subproc (##make-subprocedure proc subproc-id)))
                                (if subproc
                                    (let* ((nb-closed (##subprocedure-nb-closed subproc))
                                           (n (##fx- (##vector-length fields) 1)))
                                      (if (##fx= (##fx+ nb-closed 1) n)
                                          (if (##fx= nb-closed 0)
                                              subproc
                                              (let ((c (##make-vector n subproc)))
                                                (##subtype-set! c (macro-subtype-procedure))
                                                (let loop ((i (##fx- n 1)))
                                                  (if (##fx< i 1)
                                                      c
                                                      (let ((obj
                                                             (##vector-ref fields
                                                                           (##fx+ i 1))))
                                                        (if (##label-marker? obj)
                                                            (##label-marker-fixup-handler-add!
                                                             re
                                                             obj
                                                             (lambda (resolved-obj)
                                                               (##closure-set! c i resolved-obj)))
                                                            (##closure-set! c i obj))
                                                        (loop (##fx- i 1)))))))
                                          #f))
                                    #f))
                              #f)))
                    #f))
              #f)))))

;;;;;;;;;;;;;;;;;; FIX THIS:
;;;;> '#0=#procedure(##make-default-entry-hook 2 #0#)
;;;;#0=#procedure(##make-default-entry-hook 2 #(#(source1) #0# (stdin) 262149))

(define-prim (##explode-return ret)
  (##explode-subprocedure ret '()))

(define-prim (##implode-return re fields)
  (let ((x (##implode-procedure-or-return re fields)))
    (if (##return? x)
        x
        #f)))

(define-prim (##wr-opaque we obj explode open-close type name)
  (if (##eq? (macro-readtable-sharing-allowed?
              (macro-writeenv-readtable we))
             'serialize)
      (##wr-serialize we obj explode open-close)
      (##wr-sn we obj type name)))

(define-prim (##wr-serialize we obj explode open-close)
  (case (macro-writeenv-style we)
    ((mark)
     (if (##wr-mark-begin we obj)
         (let ((vect (explode obj)))
           (##wr-vector-aux2
            we
            vect
            (##vector-length vect)
            ##vector-ref)
           (##wr-mark-end we obj))))
    (else
     (if (##wr-stamp we obj)
         (let ((vect (explode obj)))
           (##wr-vector-aux3
            we
            vect
            (##vector-length vect)
            ##vector-ref
            open-close))))))

(define-prim (##wr-u8vector we obj)
  (##wr-vector-aux1 we obj (##u8vector-length obj) ##u8vector-ref '("#u8(" . ")")))

(macro-if-s8vector
 (define-prim (##wr-s8vector we obj)
   (##wr-vector-aux1 we obj (##s8vector-length obj) ##s8vector-ref '("#s8(" . ")"))))

(macro-if-u16vector
 (define-prim (##wr-u16vector we obj)
   (##wr-vector-aux1 we obj (##u16vector-length obj) ##u16vector-ref '("#u16(" . ")"))))

(macro-if-s16vector
 (define-prim (##wr-s16vector we obj)
   (##wr-vector-aux1 we obj (##s16vector-length obj) ##s16vector-ref '("#s16(" . ")"))))

(macro-if-u32vector
 (define-prim (##wr-u32vector we obj)
   (##wr-vector-aux1 we obj (##u32vector-length obj) ##u32vector-ref '("#u32(" . ")"))))

(macro-if-s32vector
 (define-prim (##wr-s32vector we obj)
   (##wr-vector-aux1 we obj (##s32vector-length obj) ##s32vector-ref '("#s32(" . ")"))))

(macro-if-u64vector
 (define-prim (##wr-u64vector we obj)
   (##wr-vector-aux1 we obj (##u64vector-length obj) ##u64vector-ref '("#u64(" . ")"))))

(macro-if-s64vector
 (define-prim (##wr-s64vector we obj)
   (##wr-vector-aux1 we obj (##s64vector-length obj) ##s64vector-ref '("#s64(" . ")"))))

(macro-if-f32vector
 (define-prim (##wr-f32vector we obj)
   (##wr-vector-aux1 we obj (##f32vector-length obj) ##f32vector-ref '("#f32(" . ")"))))

(define-prim (##wr-f64vector we obj)
  (##wr-vector-aux1 we obj (##f64vector-length obj) ##f64vector-ref '("#f64(" . ")")))

(define-prim (##wr-structure we obj)

  (define (for-each-visible-field proc obj type last?)
    (if (##not type) ;; have we reached root of inheritance chain?
        1
        (let ((fields (##type-fields type)))
          (let loop1 ((i 0)
                      (first #f)
                      (last -1))
            (let ((i*3 (##fx* i 3)))
              (if (##fx< i*3 (##vector-length fields))
                  (let ((field-attributes
                         (##vector-ref fields (##fx+ i*3 1))))
                    (if (##fx=
                         (##fxand field-attributes 1)
                         0)
                        (loop1 (##fx+ i 1)
                               (or first i)
                               i)
                        (loop1 (##fx+ i 1)
                               first
                               last)))
                  (let ((start
                         (for-each-visible-field
                          proc
                          obj
                          (##type-super type)
                          (if first #f last?))))
                    (let loop2 ((i (or first 0)))
                      (if (##not (##fx< last i))
                          (let* ((i*3
                                  (##fx* i 3))
                                 (field-attributes
                                  (##vector-ref fields (##fx+ i*3 1))))
                            (if (##fx=
                                 (##fxand field-attributes 1)
                                 0)
                                (let ((field-name
                                       (##vector-ref fields i*3)))
                                  (proc (##string->keyword
                                         (##symbol->string field-name))
                                        (##unchecked-structure-ref
                                         obj
                                         (##fx+ start i)
                                         type
                                         #f)
                                        (and last?
                                             (##fx= i last)))))
                            (loop2 (##fx+ i 1)))))
                    (##fx+ start
                           (##fxquotient
                            (##vector-length fields)
                            3)))))))))

  (define (wr-structure we obj)
    (##wr-str we "#<")
    (let ((level
           (macro-writeenv-level we)))
      (if (##not (##fx< level
                        (macro-readtable-max-write-level
                         (macro-writeenv-readtable we))))
          (##wr-str we "...")
          (let* ((type-col
                  (##shifted-column we))
                 (type
                  (##structure-type obj))
                 (close-parens
                  (macro-writeenv-close-parens we))
                 (new-close-parens
                  (##fx+ close-parens 1)))
            (macro-writeenv-level-set! we (##fx+ level 1))
            (##wr-no-display we (##type-name type))
            (##wr-str we " ")
            (let* ((col
                    (##shifted-column we))
                   (start-col
                    (if (##fx< ##structure-max-head
                               (##fx- col type-col))
                        (##fx+ type-col ##structure-indent)
                        col)))
              (##wr-str we "#")
              (##wr-str we (##number->string (##object->serial-number obj) 10))
              (for-each-visible-field
               (lambda (field-name value last?)
                 (macro-writeenv-close-parens-set!
                  we
                  (if last?
                      new-close-parens
                      0))
                 (case (macro-writeenv-style we)
                   ((pretty-print)
                    (##wr-indent we start-col)
                    (##wr-no-display we field-name)
                    (let ((col (##shifted-column we)))
                      (if (##fx< (##fx- col start-col)
                                 ##structure-max-field)
                          (begin
                            (##wr-ch we #\space)
                            (##wr-no-display we value))
                          (let* ((available-space-for-obj
                                  (##fx-
                                   (##fx-
                                    (##fx-
                                     (##fx+
                                      (macro-writeenv-shift we)
                                      (macro-writeenv-width we))
                                     (macro-writeenv-close-parens we))
                                    col)
                                   1))
                                 (str
                                  (##wr-fits-on-line
                                   we
                                   value
                                   ##wr-no-display
                                   available-space-for-obj)))
                            (if str
                                (begin
                                  (##wr-ch we #\space)
                                  (##wr-str we str))
                                (begin
                                  (##wr-indent
                                   we
                                   (##fx+ start-col ##structure-indent))
                                  (##wr-no-display we value)))))))
                   (else
                    (##wr-ch we #\space)
                    (##wr-no-display we field-name)
                    (##wr-ch we #\space)
                    (##wr-no-display we value))))
               obj
               type
               #t)
              (macro-writeenv-level-set! we level)))))
    (##wr-ch we #\>))

  (cond ((##eq? (macro-readtable-sharing-allowed?
                 (macro-writeenv-readtable we))
                'serialize)
         (##wr-serialize we obj ##explode-structure '("#structure(" . ")")))
        ((macro-port? obj)
         (##wr-sn
          we
          obj
          (if (##input-port? obj)
              (if (##output-port? obj) 'input-output-port 'input-port)
              'output-port)
          (##port-name obj)))
        ((macro-thread? obj)
         (##wr-sn
          we
          obj
          'thread
          (macro-thread-name obj)))
        ((macro-mutex? obj)
         (##wr-sn
          we
          obj
          'mutex
          (macro-mutex-name obj)))
        ((macro-condvar? obj)
         (##wr-sn
          we
          obj
          'condition-variable
          (macro-condvar-name obj)))
        ((macro-tgroup? obj)
         (##wr-sn
          we
          obj
          'thread-group
          (macro-tgroup-name obj)))
        ((##type? obj);;;;;;;;;;;;;;;
         (##wr-sn
          we
          obj
          'type
          (##type-name obj)))
        (else
         (case (macro-writeenv-style we)
           ((mark)
            (if (##wr-mark-begin we obj)
                (begin
                  (for-each-visible-field
                   (lambda (field-name value last?)
                     (##wr-no-display we field-name)
                     (##wr-no-display we value))
                   obj
                   (##structure-type obj)
                   #t)
                  (##wr-mark-end we obj))))
           (else
            (if (##wr-stamp we obj)
                (if (case (macro-writeenv-style we)
                      ((pretty-print)
                       (##not (##wr-one-line-pretty-print
                               we
                               obj
                               (lambda (we obj)
                                 (wr-structure we obj)))))
                      (else
                       #t))
                    (wr-structure we obj))))))))

(define-prim (##wr-gc-hash-table we obj)
  (if (##eq? (macro-readtable-sharing-allowed?
              (macro-writeenv-readtable we))
             'serialize)
      (##wr-serialize we obj ##explode-gc-hash-table '("#gc-hash-table(" . ")"))
      (##wr-sn
       we
       obj
       'gc-hash-table
       (##void))))

(define-prim (##explode-gc-hash-table gcht)
  (##declare (not interrupts-enabled))
  (let loop ((i (macro-gc-hash-table-key0))
             (key-vals '()))
    (let ((len (##vector-length gcht)))
      (if (##fx< i len)
          (let ((key (##vector-ref gcht i)))
            (if (and (##not (##eq? key (macro-unused-obj)))
                     (##not (##eq? key (macro-deleted-obj))))
                (let ((val (##vector-ref gcht (##fx+ i 1))))
                  (let ((new-key-vals (##cons (##cons key val) key-vals)))
                    (##declare (interrupts-enabled))
                    (loop (##fx+ i 2) new-key-vals)))
                (let ()
                  (##declare (interrupts-enabled))
                  (loop (##fx+ i 2) key-vals))))
          (let ((flags
                 (macro-gc-hash-table-flags gcht))
                (count
                 (macro-gc-hash-table-count gcht))
                (min-count
                 (macro-gc-hash-table-min-count gcht))
                (free
                 (macro-gc-hash-table-free gcht)))
            (##declare (interrupts-enabled))
            (##vector len flags count min-count free key-vals))))))

(define-prim (##implode-gc-hash-table re fields)
  (let ((len (##vector-ref fields 0))
        (flags (##vector-ref fields 1))
        (count (##vector-ref fields 2))
        (min-count (##vector-ref fields 3))
        (free (##vector-ref fields 4))
        (key-vals (##vector-ref fields 5)))
    (let ((gcht (##make-vector len (macro-unused-obj))))
      (macro-gc-hash-table-flags-set!
       gcht
       (##fxior ;; force rehash at next access!
        flags
        (##fx+ (macro-gc-hash-table-flag-key-moved)
               (macro-gc-hash-table-flag-need-rehash))))
      (macro-gc-hash-table-count-set! gcht count)
      (macro-gc-hash-table-min-count-set! gcht min-count)
      (macro-gc-hash-table-free-set! gcht free)
      (let loop ((i (macro-gc-hash-table-key0))
                 (key-vals key-vals))
        (if (##pair? key-vals)
            (if (##fx< i (##vector-length gcht))
                (let ((key-val (##car key-vals)))
                  (let ((key (##car key-val))
                        (val (##cdr key-val)))
                    (##vector-set! gcht i key)
                    (##vector-set! gcht (##fx+ i 1) val)
                    (loop (##fx+ i 2) (##cdr key-vals))))
                #f)
            (begin
              (##subtype-set!
               gcht
               (macro-subtype-weak))
              gcht))))))

(define-prim (##wr-meroon we obj)
  (##wr-sn
   we
   obj
   'meroon
   (##void)))

(define-prim (##wr-meroon-set! x)
  (set! ##wr-meroon x))

(define-prim (##wr-jazz we obj)
  (##wr-sn
   we
   obj
   'jazz
   (##void)))

(define-prim (##wr-jazz-set! x)
  (set! ##wr-jazz x))

(define-prim (##wr-frame we obj)
  (if (##eq? (macro-readtable-sharing-allowed?
              (macro-writeenv-readtable we))
             'serialize)
      (##wr-serialize we obj ##explode-frame '("#frame(" . ")"))
      (##wr-sn
       we
       obj
       'frame
       (##void))))

(define-prim (##wr-continuation we obj)
  (if (##eq? (macro-readtable-sharing-allowed?
              (macro-writeenv-readtable we))
             'serialize)
      (##wr-serialize we obj ##explode-continuation '("#continuation(" . ")"))
      (##wr-sn
       we
       obj
       'continuation
       (##void))))

(define-prim (##wr-promise we obj)
  (if (##eq? (macro-readtable-sharing-allowed?
              (macro-writeenv-readtable we))
             'serialize)
      (##wr-serialize we obj ##explode-promise '("#promise(" . ")"))
      (if (macro-writeenv-force? we)
          (##wr we (##force obj))
          (##wr-sn
           we
           obj
           'promise
           (##void)))))

(define-prim (##explode-promise obj)
  (##explode-object obj))

(define-prim (##implode-promise re fields)
  (##implode-object re fields (macro-subtype-promise)))

(define-prim (##wr-will we obj)
  (##wr-sn
   we
   obj
   'will
   (##void)))

(define-prim (##wr-procedure we obj)
  (if (##eq? (macro-readtable-sharing-allowed?
              (macro-writeenv-readtable we))
             'serialize)
      (##wr-serialize we obj ##explode-procedure '("#procedure(" . ")"))
      (##wr-sn
       we
       obj
       'procedure
       (or (##procedure-name obj) (##void)))))

(define-prim (##wr-return we obj)
  (##wr-opaque
   we
   obj
   ##explode-return
   '("#return(" . ")")
   'return
   (##void)))

(define-prim (##wr-box we obj)
  (case (macro-writeenv-style we)
    ((mark)
     (if (##wr-mark-begin we obj)
         (begin
           (##wr we (##unbox obj))
           (##wr-mark-end we obj))))
    (else
     (if (case (macro-writeenv-style we)
           ((print) #t)
           (else    (##wr-stamp we obj)))
         (begin
           (##wr-str we "#&")
           (##wr we (##unbox obj)))))))

(define-prim (##wr-other we obj)
  (case (macro-writeenv-style we)
    ((mark)
     #f)
    (else
     (cond ((##eq? obj #t)
            (##wr-str we "#t")) ;; TODO: change to "#T" eventually
           ((##eq? obj #f)
            (##wr-str we "#f")) ;; TODO: change to "#F" eventually
           ((##eq? obj '())
            (case (macro-writeenv-style we)
              ((print)
               (##void))
              (else
               (##wr-str we "()"))))
           ((##eq? obj (macro-absent-obj))
            (##wr-str we
                      (if (##eq? (macro-readtable-sharing-allowed?
                                  (macro-writeenv-readtable we))
                                 'serialize)
                          "#absent"
                          "#<absent>")))
           (else
            (let ((x
                   (##assq-cdr obj
                               (macro-readtable-sharp-bang-table
                                (macro-writeenv-readtable we)))))
              (if x
                  (begin
                    (##wr-str we "#!")
                    (##wr-str we (##car x)))
                  (##wr-str we "#<unknown>"))))))))

;;;----------------------------------------------------------------------------

(define-prim (##eof-object? x)
  (##eq? x #!eof))

(define-prim (eof-object? x)
  (macro-force-vars (x)
    (##eof-object? x)))

(define-prim (##eof-object)
  #!eof)

(define-prim (eof-object)
  (##eof-object))

;;;----------------------------------------------------------------------------

;;; R4RS Scheme procedures:

(define-prim (transcript-on path)
  (macro-check-string path 1 (transcript-on path)
    (##void)))

(define-prim (transcript-off)
  (##void))

;;;----------------------------------------------------------------------------

;;; The reader.

(##declare (inlining-limit 300))

(##define-macro (* . args)                `(##fx* ,@args))
(##define-macro (+ . args)                `(##fx+ ,@args))
(##define-macro (- . args)                `(##fx- ,@args))
(##define-macro (< . args)                `(##fx< ,@args))
(##define-macro (= . args)                `(##fx= ,@args))
(##define-macro (assoc . args)            `(##assoc ,@args))
(##define-macro (assq . args)             `(##assq ,@args))
(##define-macro (car . args)              `(##car ,@args))
(##define-macro (cdr . args)              `(##cdr ,@args))
(##define-macro (char-downcase . args)    `(##char-downcase ,@args))
(##define-macro (char-upcase . args)      `(##char-upcase ,@args))
(##define-macro (char<? . args)           `(##char<? ,@args))
(##define-macro (char=? . args)           `(##char=? ,@args))
(##define-macro (char? . args)            `(##char? ,@args))
(##define-macro (cons . args)             `(##cons ,@args))
(##define-macro (eq? . args)              `(##eq? ,@args))
(##define-macro (eqv? . args)             `(##eqv? ,@args))
(##define-macro (complex? . args)         `(##complex? ,@args))
(##define-macro (exact? . args)           `(##exact? ,@args))
(##define-macro (for-each . args)         `(##for-each ,@args))
(##define-macro (integer? . args)         `(##integer? ,@args))
(##define-macro (list . args)             `(##list ,@args))
(##define-macro (make-string . args)      `(##make-string ,@args))
(##define-macro (make-vector . args)      `(##make-vector ,@args))
(##define-macro (map . args)              `(##map ,@args))
(##define-macro (modulo . args)           `(##modulo ,@args))
(##define-macro (not . args)              `(##not ,@args))
(##define-macro (null? . args)            `(##null? ,@args))
(##define-macro (pair? . args)            `(##pair? ,@args))
(##define-macro (quotient . args)         `(##quotient ,@args))
(##define-macro (real? . args)            `(##real? ,@args))
(##define-macro (reverse . args)          `(##reverse ,@args))
(##define-macro (box . args)              `(##box ,@args))
(##define-macro (set-box! . args)         `(##set-box! ,@args))
(##define-macro (set-car! . args)         `(##set-car! ,@args))
(##define-macro (set-cdr! . args)         `(##set-cdr! ,@args))
(##define-macro (string . args)           `(##string ,@args))
(##define-macro (list->string . args)     `(##list->string ,@args))
(##define-macro (string->number . args)   `(##string->number ,@args))
(##define-macro (string->symbol-object . args) `(##string->symbol ,@args))
(##define-macro (string->uninterned-symbol-object . args) `(##string->uninterned-symbol ,@args))
(##define-macro (string? . args)          `(##string? ,@args))
(##define-macro (string-length . args)    `(##string-length ,@args))
(##define-macro (string-append . args)    `(##string-append ,@args))
(##define-macro (string-ref . args)       `(##string-ref ,@args))
(##define-macro (string-set! . args)      `(##string-set! ,@args))
(##define-macro (string=? . args)         `(##string=? ,@args))
(##define-macro (string-ci=? . args)      `(##string-ci=? ,@args))
(##define-macro (substring . args)        `(##substring ,@args))
(##define-macro (symbol? . args)          `(##symbol? ,@args))
(##define-macro (symbol->string . args)   `(##symbol->string ,@args))
(##define-macro (vector . args)           `(##vector ,@args))
(##define-macro (vector-copy . args)      `(##vector-copy ,@args))
(##define-macro (vector-length . args)    `(##vector-length ,@args))
(##define-macro (vector-ref . args)       `(##vector-ref ,@args))
(##define-macro (vector-set! . args)      `(##vector-set! ,@args))
(##define-macro (vector? . args)          `(##vector? ,@args))

(##define-macro (make-u8vect n)           `(##make-u8vector ,n))
(##define-macro (u8vect-set! . args)      `(##u8vector-set! ,@args))
(##define-macro (make-s8vect n)           `(##make-s8vector ,n))
(##define-macro (s8vect-set! . args)      `(##s8vector-set! ,@args))
(##define-macro (make-u16vect n)          `(##make-u16vector ,n))
(##define-macro (u16vect-set! . args)     `(##u16vector-set! ,@args))
(##define-macro (make-s16vect n)          `(##make-s16vector ,n))
(##define-macro (s16vect-set! . args)     `(##s16vector-set! ,@args))
(##define-macro (make-u32vect n)          `(##make-u32vector ,n))
(##define-macro (u32vect-set! . args)     `(##u32vector-set! ,@args))
(##define-macro (make-s32vect n)          `(##make-s32vector ,n))
(##define-macro (s32vect-set! . args)     `(##s32vector-set! ,@args))
(##define-macro (make-u64vect n)          `(##make-u64vector ,n))
(##define-macro (u64vect-set! . args)     `(##u64vector-set! ,@args))
(##define-macro (make-s64vect n)          `(##make-s64vector ,n))
(##define-macro (s64vect-set! . args)     `(##s64vector-set! ,@args))
(##define-macro (make-f32vect n)          `(##make-f32vector ,n))
(##define-macro (f32vect-set! . args)     `(##f32vector-set! ,@args))
(##define-macro (make-f64vect n)          `(##make-f64vector ,n))
(##define-macro (f64vect-set! . args)     `(##f64vector-set! ,@args))

(##define-macro (UCS-4->character . args) `(##integer->char ,@args))
(##define-macro (character->UCS-4 . args) `(##char->integer ,@args))
(##define-macro (in-char-range? n)
  `(and (##not (##< ##max-char ,n))
        (or (##fx< ,n #xd800)
            (##fx< #xdfff ,n))))

(##define-macro (string->keyword-object . args) `(##string->keyword ,@args))
(##define-macro (string->uninterned-keyword-object . args) `(##string->uninterned-keyword ,@args))

(##define-macro (in-integer-range? n lo hi)
  `(and (##not (##< ,n ,lo)) (##not (##< ,hi ,n))))

(##define-macro (false-obj) #f)

;;; Tables for reader and writer.

(define ##standard-pretty-print-formats
  '(
    (lambda         . #(1 #t 2 #f 1))
    (if             . #(1 #f 0 #f 1))
    (set!           . #(1 #f 0 #f 1))
    (cond           . #(1 #t 0 #t 1))
    (case           . #(1 #f 2 #t 1))
    (and            . #(1 #f 0 #f 1))
    (or             . #(1 #f 0 #f 1))
    (when           . #(1 #t 2 #f 1))
    (unless         . #(1 #t 2 #f 1))
    (guard          . #(1 #f 2 #t 1))
    (let            . #(1 #t 2 #f 1)) ;; named let is handled in pretty printer
    (let*           . #(1 #t 2 #f 1))
    (letrec         . #(1 #t 2 #f 1))
    (letrec*        . #(1 #t 2 #f 1))
    (let-values     . #(1 #t 2 #f 1))
    (let*-values    . #(1 #t 2 #f 1))
    (letrec-values  . #(1 #t 2 #f 1))
    (letrec*-values . #(1 #t 2 #f 1))
    (define-values  . #(1 #f 2 #f 1))
    (parameterize   . #(1 #t 2 #f 1))
    (begin          . #(0 #f 1 #f 1))
    (do             . #(1 #t 3 #f 1))
    (define         . #(1 #f 2 #f 1))
    (##define-macro . #(1 #f 2 #f 1))
    (define-macro   . #(1 #f 2 #f 1))
    (##declare      . #(0 #f 1 #f 1))
    (declare        . #(0 #f 1 #f 1))
    ))

(define ##list-max-head 8)

(define-prim (##list-max-head-set! x)
  (set! ##list-max-head x))

(define ##structure-max-head 8)

(define-prim (##structure-max-head-set! x)
  (set! ##structure-max-head x))

(define ##structure-max-field 8)

(define-prim (##structure-max-field-set! x)
  (set! ##structure-max-field x))

(define ##structure-indent 1)

(define-prim (##structure-indent-set! x)
  (set! ##structure-indent x))

(define ##standard-escaped-char-table
  '(
    (#\\     . #\\)
    (#\a     . #\x07)
    (#\b     . #\x08)
    (#\t     . #\x09)
    (#\n     . #\x0A)
    (#\v     . #\x0B)
    (#\f     . #\x0C)
    (#\r     . #\x0D)
    (#\space . #\space)
    (#\|     . #\|)
    (#\"     . #\")
    (#\'     . #\')
    (#\?     . #\?)
    ))

(define ##standard-named-char-table
  '(
    ("null"      . #\x00) ;; for R7RS compatibility (null and escape
    ("escape"    . #\x1B) ;; must be the two first in this list)
    ("newline"   . #\newline) ;; here to take precedence over linefeed
    ("space"     . #\space)
    ("nul"       . #\x00)
    ("alarm"     . #\x07)
    ("backspace" . #\x08)
    ("tab"       . #\x09)
    ("linefeed"  . #\x0A)
    ("vtab"      . #\x0B)
    ("page"      . #\x0C)
    ("return"    . #\x0D)
    ("esc"       . #\x1B)
    ("delete"    . #\x7F)
    ))

(define ##standard-sharp-bang-table
  '(
    ("eof"      . #!eof)
    ("void"     . #!void)
    ("unbound"  . #!unbound)
    ("unbound2" . #!unbound2)
    ("optional" . #!optional)
    ("rest"     . #!rest)
    ("key"      . #!key)
;;;    ("body"     . #!body)
    ))

;;;============================================================================

;; For compatibility between the interpreter and compiler, this section
;; must be the same as the corresponding section in the file
;; "gsc/_source.scm" (except that ## and ** are exchanged).

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; A chartable structure is a vector-like data structure which is
;; indexed using a character.

(define (##make-chartable default)
  (##declare (not interrupts-enabled))
  (let ((ct (make-vector 130 default)))
    (vector-set! ct 129 '())
    ct))

(define (##chartable-copy ct)
  (##declare (not interrupts-enabled))
  (let ((ct-copy (vector-copy ct)))
    (vector-set! ct-copy
                 129
                 (map (lambda (x) (cons (car x) (cdr x))) (vector-ref ct 129)))
    ct-copy))

(##define-macro (macro-chartable-ref ct c)
  `(let ((ct ,ct) (c ,c))
     (let ((i (character->UCS-4 c)))
       (if (< i 128)
           (vector-ref ct i)
           (##chartable-ref ct c)))))

(define (##chartable-ref ct c)
  (##declare (not interrupts-enabled))
  (let ((i (character->UCS-4 c)))
    (if (< i 128)
        (vector-ref ct i)
        (let ((x (assq i (vector-ref ct 129))))
          (if x
              (cdr x)
              (vector-ref ct 128))))))

(define (##chartable-set! ct c val)
  (##declare (not interrupts-enabled))
  (let ((i (character->UCS-4 c)))
    (if (< i 128)
        (vector-set! ct i val)
        (let ((x (assq i (vector-ref ct 129))))
          (if x
              (set-cdr! x val)
              (vector-set! ct 129 (cons (cons i val) (vector-ref ct 129))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;; A readtable structure contains parsing information for the reader.
;; It indicates what action must be taken when a given character is
;; encountered.

(define (##readtable-char-delimiter? rt c)
  (##declare (not interrupts-enabled))
  (macro-chartable-ref (macro-readtable-char-delimiter?-table rt) c))

(define (##readtable-char-delimiter?-set! rt c delimiter?)
  (##declare (not interrupts-enabled))
  (##chartable-set! (macro-readtable-char-delimiter?-table rt) c delimiter?))

(define (##readtable-char-handler rt c)
  (##declare (not interrupts-enabled))
  (macro-chartable-ref (macro-readtable-char-handler-table rt) c))

(define (##readtable-char-handler-set! rt c handler)
  (##declare (not interrupts-enabled))
  (##chartable-set! (macro-readtable-char-handler-table rt) c handler))

(define (##readtable-char-sharp-handler rt c)
  (##declare (not interrupts-enabled))
  (macro-chartable-ref (macro-readtable-char-sharp-handler-table rt) c))

(define (##readtable-char-sharp-handler-set! rt c handler)
  (##declare (not interrupts-enabled))
  (##chartable-set! (macro-readtable-char-sharp-handler-table rt) c handler))

(define (##readtable-char-class-set! rt c delimiter? handler)
  (##declare (not interrupts-enabled))
  (##readtable-char-delimiter?-set! rt c delimiter?)
  (##readtable-char-handler-set! rt c handler))

(define (##convert-case case-conversion? s)
  (##declare (not interrupts-enabled))
  (if case-conversion?
      (if (eq? case-conversion? 'upcase)
          (let loop ((i (- (string-length s) 1)))
            (if (< i 0)
                s
                (begin
                  (string-set! s i (char-upcase (string-ref s i)))
                  (loop (- i 1)))))
          (##string-foldcase s))
      s))

(define (##readtable-parse-keyword rt s intern? create?)
  (##declare (not interrupts-enabled))
  (let ((keywords-allowed? (macro-readtable-keywords-allowed? rt)))
    (and keywords-allowed?
         (let ((len (string-length s)))
           (and (< 1 len)
                (if (eq? keywords-allowed? 'prefix)
                    (and (char=? (string-ref s 0) #\:)
                         (if create?
                             (let ((key-str (substring s 1 len)))
                               (if intern?
                                   (string->keyword-object key-str)
                                   (string->uninterned-keyword-object key-str)))
                             #t))
                    (and (char=? (string-ref s (- len 1)) #\:)
                         (if create?
                             (let ((key-str (substring s 0 (- len 1))))
                               (if intern?
                                   (string->keyword-object key-str)
                                   (string->uninterned-keyword-object key-str)))
                             #t))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Procedures to read datums.

;; (##read-datum-or-eof re) attempts to read a datum in the read
;; environment "re", skipping all whitespace and comments in the
;; process.  The "filepos" field of the read environment indicates the
;; position where the enclosing datum starts (e.g. list or vector).  If
;; a datum is read it is returned (wrapped if the read environment asks
;; for it); if the end-of-file is reached the end-of-file object is
;; returned (never wrapped); otherwise an error is signaled.  The read
;; environment's "pos" field is only modified if a datum was read, in
;; which case it is the position where the datum starts.

(define (##read-datum-or-eof re)
  (##declare (not interrupts-enabled))
  (case (macro-readtable-start-syntax (macro-readenv-readtable re))
    ((six)
     (let ((autosemi? #f)
           (allow-eof? #t))
       (##read-six-datum-or-eof re autosemi? allow-eof?)))
    (else
     (let loop ()
       (let* ((old-pos (macro-readenv-filepos re))
              (obj (##read-datum-or-label-or-none re)))
         (if (eq? obj (##none-marker))
             (let ((c (macro-peek-next-char-or-eof re)))
               (if (char? c)
                   (begin
                     (macro-readenv-filepos-set! re (##readenv-current-filepos re))
                     (macro-read-next-char-or-eof re) ;; make sure reader progresses
                     (##raise-datum-parsing-exception 'datum-or-eof-expected re)
                     (macro-readenv-filepos-set! re old-pos) ;; restore pos
                     (loop)) ;; skip error
                   (begin
                     (macro-read-next-char-or-eof re) ;; make sure reader progresses
                     #!eof))) ;; end-of-file was reached so return end-of-file object
             (begin
               (##read-check-labels! re)
               obj)))))))

;; (##read-datum-or-label re) attempts to read a datum in the read
;; environment "re", skipping all whitespace and comments in the
;; process.  The "filepos" field of the read environment indicates the
;; position where the enclosing datum starts (e.g. list or vector).  If
;; a datum is read it is returned (wrapped if the read environment asks
;; for it); if a label reference is read (i.e. "#n#") a "label-marker"
;; is returned; if the end-of-file is reached or no datum can be read
;; an error is signaled.  The read environment's "filepos" field is
;; only modified if a datum was read, in which case it is the position
;; where the datum starts.

(define (##read-datum-or-label re)
  (##declare (not interrupts-enabled))
  (let* ((old-pos (macro-readenv-filepos re))
         (obj (##read-datum-or-label-or-none re)))
    (if (eq? obj (##none-marker))
        (let ()
          (##declare (interrupts-enabled))
          (macro-readenv-filepos-set! re (##readenv-current-filepos re))
          (let ((c (macro-read-next-char-or-eof re))) ;; force progress
            (##raise-datum-parsing-exception 'datum-expected re)
            (if (not (char? c))
                (macro-readenv-wrap re #f) ;; return something
                (begin
                  (macro-readenv-filepos-set! re old-pos) ;; restore pos
                  (##read-datum-or-label re))))) ;; skip error
        obj)))

;; (##read-datum-or-label-or-none re) attempts to read a datum in the
;; read environment "re", skipping all whitespace and comments in the
;; process.  The "filepos" field of the read environment indicates the
;; position where the enclosing datum starts (e.g. list or vector).  If
;; a datum is read it is returned (wrapped if the read environment asks
;; for it); if a label reference is read (i.e. "#n#") a "label-marker"
;; is returned; if the end-of-file is reached or no datum can be read
;; the "none-marker" is returned.  The read environment's "filepos"
;; field is only modified if a datum was read, in which case it is the
;; position where the datum starts.

(define (##read-datum-or-label-or-none re)
  (##declare (not interrupts-enabled))
  (let* ((old-pos (macro-readenv-filepos re))
         (obj (##read-datum-or-label-or-none-or-dot re)))
    (if (eq? obj (##dot-marker))
        (let ()
          (##declare (interrupts-enabled))
          (macro-readenv-filepos-set! re (##readenv-relative-filepos re 1))
          (##raise-datum-parsing-exception 'improperly-placed-dot re)
          (macro-readenv-filepos-set! re old-pos) ;; restore pos
          (##read-datum-or-label-or-none re)) ;; skip error
        obj)))

;; (##read-datum-or-label-or-none-or-dot re) attempts to read a datum
;; in the read environment "re", skipping all whitespace and comments
;; in the process.  The "filepos" field of the read environment
;; indicates the position where the enclosing datum starts (e.g. list
;; or vector).  If a datum is read it is returned (wrapped if the read
;; environment asks for it); if a label reference is read (i.e. "#n#")
;; a "label-marker" is returned; if a lone dot is read the "dot-marker"
;; is returned; if the end-of-file is reached or no datum can be read
;; the "none-marker" is returned.  The read environment's "filepos"
;; field is only modified if a datum was read, in which case it is the
;; position where the datum starts.

(define (##read-datum-or-label-or-none-or-dot re)
  (let ((next (macro-peek-next-char-or-eof re)))
    (if (char? next)
        ((##readtable-char-handler (macro-readenv-readtable re) next) re next)
        (##none-marker))))

;; Special objects returned by ##read-datum-or-label-or-none-or-dot.

(define (##script-marker) '#(script)) ;; indicates a script
(define (##none-marker) '#(none))     ;; indicates no following datum
(define (##dot-marker) '#(dot))       ;; indicates an isolated dot
(define ##label-marker-tag '#(label)) ;; indicates a label of the form "#n#"

(define (##label-marker? obj)
  (and (vector? obj)
       (< 0 (vector-length obj))
       (eq? (vector-ref obj 0) ##label-marker-tag)))

(define (##label-marker-enter! re n)
  (let ((labels (macro-readenv-labels re)))
    (or (##table-ref labels n #f)
        (let ((lm (vector ##label-marker-tag #f '())))
          (##table-set! labels n lm)
          lm))))

(define (##label-marker-reference re n)
  (let* ((lm (##label-marker-enter! re n))
         (handlers (vector-ref lm 2)))
    (if handlers
        lm
        (macro-readenv-wrap re (vector-ref lm 1)))))

(define (##label-marker-fixup-handler-add! re lm handler)
  (let ((handlers (vector-ref lm 2)))
    (if handlers
        (vector-set!
         lm
         2
         (vector handler
                 (macro-readenv-wrapper re)
                 (macro-readenv-filepos re)
                 handlers))
        (handler (macro-readenv-wrap re (vector-ref lm 1))))))

(define (##label-marker-define re n obj)
  (let* ((lm (##label-marker-enter! re n))
         (handlers (vector-ref lm 2)))
    (if handlers
        (begin
          (vector-set! lm 1 obj)
          (vector-set! lm 2 #f)
          (##label-marker-fixup! re handlers obj))
        (##raise-datum-parsing-exception 'duplicate-label-definition re n))))

(define (##label-marker-fixup! re handlers obj)
  (let loop ((lst handlers))
    (if (vector? lst)
        (let* ((handler (vector-ref lst 0))
               (wrapper (vector-ref lst 1))
               (filepos (vector-ref lst 2))
               (old-wrapper (macro-readenv-wrapper re))
               (old-filepos (macro-readenv-filepos re)))
          (macro-readenv-wrapper-set! re wrapper)
          (macro-readenv-filepos-set! re filepos)
          (handler (macro-readenv-wrap re obj))
          (macro-readenv-wrapper-set! re old-wrapper)
          (macro-readenv-filepos-set! re old-filepos)
          (loop (vector-ref lst 3))))))

(define (##read-check-labels! re)
  (##table-for-each
   (lambda (n lm)
     (let ((handlers (vector-ref lm 2)))
       (if handlers
           (begin
             (##label-marker-fixup! re handlers (##void))
             (##raise-datum-parsing-exception
              'missing-label-definition
              re
              n)))))
   (macro-readenv-labels re)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Procedure to read a list of datums (possibly an improper list).

(define (##build-list re allow-improper? start-pos close)
  (let ((obj
         (if (macro-readtable-dot-at-head-of-list-allowed?
              (macro-readenv-readtable re))
             (##read-datum-or-label-or-none-or-dot re)
             (##read-datum-or-label-or-none re))))
    (if (eq? obj (##none-marker))
        (begin
          (##read-next-char-expecting re close)
          '())
        (begin
          (macro-readenv-filepos-set! re start-pos) ;; restore pos
          (let ((lst
                 (cons (if (eq? obj (##dot-marker))
                           (macro-readenv-wrap re '|.|)
                           obj)
                       '())))
            (if (##label-marker? obj)
                (##label-marker-fixup-handler-add!
                 re
                 obj
                 (lambda (resolved-obj)
                   (set-car! lst resolved-obj))))
            (let loop ((end lst))
              (let ((obj
                     (if allow-improper?
                         (##read-datum-or-label-or-none-or-dot re)
                         (##read-datum-or-label-or-none re))))
                (cond ((eq? obj (##none-marker))
                       (##read-next-char-expecting re close)
                       lst)
                      ((eq? obj (##dot-marker))
                       (let ((obj (##read-datum-or-label re)))
                         (macro-readenv-filepos-set! re start-pos) ;; restore pos
                         (set-cdr! end obj)
                         (if (##label-marker? obj)
                             (##label-marker-fixup-handler-add!
                              re
                              obj
                              (lambda (resolved-obj)
                                (set-cdr! end resolved-obj))))
                         (let ((x (##read-datum-or-label-or-none re))) ;; skip whitespace!
                           (if (eq? x (##none-marker))
                               (##read-next-char-expecting re close)
                               (begin
                                 (macro-readenv-filepos-set! re start-pos) ;; restore pos
                                 (##raise-datum-parsing-exception 'incomplete-form re)))
                           lst)))
                      (else
                       (macro-readenv-filepos-set! re start-pos) ;; restore pos
                       (let ((tail (cons obj '())))
                         (if (##label-marker? obj)
                             (##label-marker-fixup-handler-add!
                              re
                              obj
                              (lambda (resolved-obj)
                                (set-car! tail resolved-obj))))
                         (set-cdr! end tail)
                         (loop tail)))))))))))

(define (##read-next-char-expecting re c) ;; only accepts c as the next char
  (let ((next (macro-peek-next-char-or-eof re)))
    (if (char? next)
        (if (char=? next c)
            (macro-read-next-char-or-eof re)
            (##raise-datum-parsing-exception 'incomplete-form re))
        (##raise-datum-parsing-exception 'incomplete-form-eof-reached re))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Procedure to read a vector or byte vector.

(define (##build-vector re kind start-pos close)

  (define (exact-integer-check n lo hi)
    (and (integer? n)
         (exact? n)
         (in-integer-range? n lo hi)))

  (define (inexact-real-check n)
    (and (real? n)
         (not (exact? n))))

  (let loop ((i 0))
    (macro-readenv-filepos-set! re start-pos) ;; restore pos
    (let ((x (##read-datum-or-label-or-none re)))
      (if (eq? x (##none-marker))
          (begin
            (##read-next-char-expecting re close)
            (cond ((##eq? kind 'u8vector)
                   (make-u8vect i))
                  ((macro-if-s8vector (##eq? kind 's8vector) #f)
                   (make-s8vect i))
                  ((macro-if-u16vector (##eq? kind 'u16vector) #f)
                   (make-u16vect i))
                  ((macro-if-s16vector (##eq? kind 's16vector) #f)
                   (make-s16vect i))
                  ((macro-if-u32vector (##eq? kind 'u32vector) #f)
                   (make-u32vect i))
                  ((macro-if-s32vector (##eq? kind 's32vector) #f)
                   (make-s32vect i))
                  ((macro-if-u64vector (##eq? kind 'u64vector) #f)
                   (make-u64vect i))
                  ((macro-if-s64vector (##eq? kind 's64vector) #f)
                   (make-s64vect i))
                  ((macro-if-f32vector (##eq? kind 'f32vector) #f)
                   (make-f32vect i))
                  ((##eq? kind 'f64vector)
                   (make-f64vect i))
                  (else
                   (make-vector i))))
          (if (or (eq? kind 'deserialize)
                  (eq? kind 'vector))
              (let ((vect (loop (+ i 1))))
                (vector-set! vect i x)
                (if (and (##not (eq? kind 'deserialize))
                         (##label-marker? x))
                    (##label-marker-fixup-handler-add!
                     re;;;;;;;;;;;;;;;;;;;;;;;;
                     x
                     (lambda (resolved-obj)
                       (vector-set! vect i resolved-obj))))
                vect)
              (let ((ux
                     (and (not (##label-marker? x))
                          (macro-readenv-unwrap re x))))
                (cond
                 ((##eq? kind 'u8vector)
                  (if (exact-integer-check ux 0 255)
                      (let ((vect (loop (+ i 1))))
                        (u8vect-set! vect i ux)
                        vect)
                      (begin
                        (##raise-datum-parsing-exception 'u8-expected re)
                        (loop i))))
                 ((macro-if-s8vector (##eq? kind 's8vector) #f)
                  (if (exact-integer-check ux -128 127)
                      (let ((vect (loop (+ i 1))))
                        (s8vect-set! vect i ux)
                        vect)
                      (begin
                        (##raise-datum-parsing-exception 's8-expected re)
                        (loop i))))
                 ((macro-if-u16vector (##eq? kind 'u16vector) #f)
                  (if (exact-integer-check ux 0 65535)
                      (let ((vect (loop (+ i 1))))
                        (u16vect-set! vect i ux)
                        vect)
                      (begin
                        (##raise-datum-parsing-exception 'u16-expected re)
                        (loop i))))
                 ((macro-if-s16vector (##eq? kind 's16vector) #f)
                  (if (exact-integer-check ux -32768 32767)
                      (let ((vect (loop (+ i 1))))
                        (s16vect-set! vect i ux)
                        vect)
                      (begin
                        (##raise-datum-parsing-exception 's16-expected re)
                        (loop i))))
                 ((macro-if-u32vector (##eq? kind 'u32vector) #f)
                  (if (exact-integer-check ux 0 4294967295)
                      (let ((vect (loop (+ i 1))))
                        (u32vect-set! vect i ux)
                        vect)
                      (begin
                        (##raise-datum-parsing-exception 'u32-expected re)
                        (loop i))))
                 ((macro-if-s32vector (##eq? kind 's32vector) #f)
                  (if (exact-integer-check ux -2147483648 2147483647)
                      (let ((vect (loop (+ i 1))))
                        (s32vect-set! vect i ux)
                        vect)
                      (begin
                        (##raise-datum-parsing-exception 's32-expected re)
                        (loop i))))
                 ((macro-if-u64vector (##eq? kind 'u64vector) #f)
                  (if (exact-integer-check ux 0 18446744073709551615)
                      (let ((vect (loop (+ i 1))))
                        (u64vect-set! vect i ux)
                        vect)
                      (begin
                        (##raise-datum-parsing-exception 'u64-expected re)
                        (loop i))))
                 ((macro-if-s64vector (##eq? kind 's64vector) #f)
                  (if (exact-integer-check ux -9223372036854775808 9223372036854775807)
                      (let ((vect (loop (+ i 1))))
                        (s64vect-set! vect i ux)
                        vect)
                      (begin
                        (##raise-datum-parsing-exception 's64-expected re)
                        (loop i))))
                 ((macro-if-f32vector (##eq? kind 'f32vector) #f)
                  (if (inexact-real-check ux)
                      (let ((vect (loop (+ i 1))))
                        (f32vect-set! vect i ux)
                        vect)
                      (begin
                        (##raise-datum-parsing-exception 'inexact-real-expected re)
                        (loop i))))
                 ((##eq? kind 'f64vector)
                  (if (inexact-real-check ux)
                      (let ((vect (loop (+ i 1))))
                        (f64vect-set! vect i ux)
                        vect)
                      (begin
                        (##raise-datum-parsing-exception 'inexact-real-expected re)
                        (loop i)))))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Procedures to read delimited tokens.

(define (##build-delimited-string re c i)
  (let loop ((i i))
    (let ((next (macro-peek-next-char-or-eof re)))
      (if (or (not (char? next))
              (##readtable-char-delimiter? (macro-readenv-readtable re) next))
          (make-string i c)
          (begin
            (macro-read-next-char-or-eof re) ;; skip "next"
            (let ((s (loop (+ i 1))))
              (string-set! s i next)
              s))))))

(define (##build-delimited-number/keyword/symbol re c intern?)

  (define (string->sym str)
    (if intern?
        (string->symbol-object str)
        (string->uninterned-symbol-object str)))

  (define (string->key str)
    (if intern?
        (string->keyword-object str)
        (string->uninterned-keyword-object str)))

  (cond ((char=? c #\|)
         (let* ((str
                 (##build-escaped-string-up-to re #\|))
                (keywords-allowed?
                 (macro-readtable-keywords-allowed?
                  (macro-readenv-readtable re))))
           (if (and keywords-allowed?
                    (not (eq? keywords-allowed? 'prefix))
                    (eqv? (macro-peek-next-char-or-eof re) #\:))
               (begin
                 (macro-read-next-char-or-eof re) ;; skip #\:
                 (string->key str))
               (string->sym str))))
        ((and (char=? c #\:)
              (let ((keywords-allowed?
                     (macro-readtable-keywords-allowed?
                      (macro-readenv-readtable re))))
                (eq? keywords-allowed? 'prefix))
              (eqv? (macro-peek-next-char-or-eof re) #\|))
         (macro-read-next-char-or-eof re) ;; skip #\|
         (let ((str
                (##build-escaped-string-up-to re #\|)))
           (string->key str)))
        (else
         (##string->number/keyword/symbol
          re
          (##build-delimited-string re c 1)
          intern?))))

(define (##string->number/keyword/symbol re str intern?)

  (define (string->sym str)
    (if intern?
        (string->symbol-object str)
        (string->uninterned-symbol-object str)))

  (or (and intern?
           (or (macro-string->number-decimal-fast-path str)
               (##string->number-slow-path str 10)))
      (let ((str2
             (##convert-case
              (macro-readenv-case-conversion? re)
              str)))
        (or (##readtable-parse-keyword
             (macro-readenv-readtable re)
             str2
             intern?
             #t)
            (string->sym str2)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##char-octal? c)
  (if (and (not (char<? c #\0)) (not (char<? #\7 c)))
      (- (character->UCS-4 c) (character->UCS-4 #\0))
      #f))

(define (##char-hexadecimal? c)
  (cond ((and (not (char<? c #\0)) (not (char<? #\9 c)))
         (- (character->UCS-4 c) (character->UCS-4 #\0)))
        ((and (not (char<? c #\a)) (not (char<? #\f c)))
         (- (character->UCS-4 c) (- (character->UCS-4 #\a) 10)))
        ((and (not (char<? c #\A)) (not (char<? #\F c)))
         (- (character->UCS-4 c) (- (character->UCS-4 #\A) 10)))
        (else
         #f)))

(define (##build-escaped-string-up-to re close)

  (define (UCS-4 n)
    (if (in-char-range? n)
        (UCS-4->character n)
        (begin
          (##raise-datum-parsing-exception 'character-out-of-range re)
          #\nul)))

  (define (read-escape-octal first-digit)
    (let loop ((i 1)
               (n first-digit))
      (let ((next (macro-peek-next-char-or-eof re)))
        (cond ((and (or (< i 2)
                        (and (= i 2) (< first-digit 4)))
                    (char? next)
                    (##char-octal? next))
               =>
               (lambda (next-digit)
                 (macro-read-next-char-or-eof re) ;; skip "next"
                 (loop (+ i 1)
                       (+ (* n 8) next-digit))))
              (else
               (UCS-4 n))))))

  (define (read-escape-hexadecimal nb-digits)
    (let loop ((i 0)
               (n 0))
      (if (or (not nb-digits)
              (< i nb-digits))
          (let ((next (macro-peek-next-char-or-eof re)))
            (cond ((and (char? next)
                        (##char-hexadecimal? next))
                   =>
                   (lambda (next-digit)
                     (macro-read-next-char-or-eof re) ;; skip "next"
                     (loop (+ i 1)
                           (if (< n ##max-char)
                               (+ (* n 16) next-digit)
                               n))))
                  (else
                   (if (or (not nb-digits)
                           (and (= nb-digits ##max-fixnum)
                                (let ((next (macro-peek-next-char-or-eof re)))
                                  (and (char? next)
                                       (char=? next #\;)
                                       (begin
                                         (macro-read-next-char-or-eof re) ;; skip "next"
                                         #t)))))
                       (UCS-4 n)
                       (begin
                         (##raise-datum-parsing-exception 'invalid-hex-escape re)
                         #\nul)))))
          (UCS-4 n))))

  (define (read-escape next)
    (cond ((not (char? next))
           ;; read-chunk will report the end-of-file error
           #\nul)
          ((##char-octal? next)
           =>
           read-escape-octal)
          ((char=? next #\x)
           (read-escape-hexadecimal
            (if (macro-readtable-r7rs-compatible-read?
                 (macro-readenv-readtable re))
                ##max-fixnum
                #f)))
          ((char=? next #\u)
           (read-escape-hexadecimal 4))
          ((char=? next #\U)
           (read-escape-hexadecimal 8))
          (else
           (let ((x (assq next
                          (macro-readtable-escaped-char-table
                           (macro-readenv-readtable re)))))
             (if x
                 (cdr x)
                 (begin
                   (##raise-datum-parsing-exception 'invalid-escaped-character re next)
                   #\nul))))))

  (define max-chunk-length 512)

  (define (read-chunk)
    (let loop1 ((i 0))
      (if (< i max-chunk-length)
          (let loop2 ((c (macro-read-next-char-or-eof re)))
            (cond ((not (char? c))
                   (##raise-datum-parsing-exception 'incomplete-form-eof-reached re)
                   (make-string i))
                  ((char=? c close)
                   (make-string i))
                  ((char=? c #\\)
                   (let ((next (macro-read-next-char-or-eof re)))
                     (if (eqv? next #\newline)
                         (let loop3 ()
                           (let ((c (macro-read-next-char-or-eof re)))
                             (if (and (char? c)
                                      (not (char=? c #\newline))
                                      (eq? (##readtable-char-handler
                                            (macro-readenv-readtable re)
                                            c)
                                           ##read-whitespace))
                                 (loop3)
                                 (loop2 c))))
                         (let* ((c (read-escape next))
                                (s (loop1 (+ i 1))))
                           (string-set! s i c)
                           s))))
                  (else
                   (let ((s (loop1 (+ i 1))))
                     (string-set! s i c)
                     s))))
          (make-string i))))

  (let ((chunk1 (read-chunk)))
    (if (< (string-length chunk1) max-chunk-length)
        chunk1
        (let loop ((chunks (list chunk1)))
          (let* ((new-chunk (read-chunk))
                 (new-chunks (cons new-chunk chunks)))
            (if (< (string-length new-chunk) max-chunk-length)
                (##string-concatenate (reverse new-chunks))
                (loop new-chunks)))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##build-decimal-integer re c i)
  (let loop ((i i))
    (let ((next (macro-peek-next-char-or-eof re)))
      (if (or (not (char? next))
              (let ((n (character->UCS-4 next)))
                (not (and (< 47 n) (< n 58)))))
          (make-string i c)
          (begin
            (macro-read-next-char-or-eof re) ;; skip "next"
            (let ((s (loop (+ i 1))))
              (string-set! s i next)
              s))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##build-read-macro re start-pos old-pos kind)
  (if kind
      (let ((obj (##read-datum-or-label re)))
        (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
        (let* ((cell2 (cons obj '()))
               (cell1 (cons (macro-readenv-wrap re kind) cell2)))
          (if (##label-marker? obj)
              (##label-marker-fixup-handler-add!
               re
               obj
               (lambda (resolved-obj)
                 (set-car! cell2 resolved-obj))))
          (macro-readenv-wrap re cell1)))
      (begin
        (##raise-datum-parsing-exception 'invalid-token re)
        (macro-readenv-filepos-set! re old-pos) ;; restore pos
        (##read-datum-or-label-or-none-or-dot re)))) ;; skip error

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Procedures to handle comments.

(define (##skip-extended-comment re open1 open2 close1 close2)

  (define (done lst)
    (##skip-comment-done
     (and lst (list->string (reverse lst)))
     re))

  (let loop1 ((level 0)
              (lst (if (macro-readtable-comment-handler
                        (macro-readenv-readtable re))
                       (list open2 open1)
                       #f)))
    (let ((c (macro-read-next-char-or-eof re)))
      (if (not (char? c))
          (##raise-datum-parsing-exception 'incomplete-form-eof-reached re)
          (let loop2 ((level level) (c c) (lst lst))
            (if (or (char=? c open1) (char=? c close1))
                (let ((x (macro-read-next-char-or-eof re)))
                  (if (not (char? x))
                      (##raise-datum-parsing-exception 'incomplete-form-eof-reached re)
                      (let ((new-lst (and lst (cons x (cons c lst)))))
                        (if (char=? c open1)
                            (if (char=? x open2)
                                (loop1 (+ level 1) new-lst)
                                (loop2 level x new-lst))
                            (if (char=? x close2)
                                (if (< 0 level)
                                    (loop1 (- level 1) new-lst)
                                    (done new-lst))
                                (loop2 level x new-lst))))))
                (loop1 level (and lst (cons c lst)))))))))

(define (##skip-single-line-comment prefix re)

  (define (done lst)
    (##skip-comment-done
     (and lst (string-append prefix (list->string (reverse lst))))
     re))

  (let loop ((lst (if (macro-readtable-comment-handler
                       (macro-readenv-readtable re))
                      '()
                      #f)))
    (let ((next (macro-peek-next-char-or-eof re)))
      (if (not (char? next))
          (done lst)
          (begin
            (macro-read-next-char-or-eof re) ;; skip "next"
            (if (not (char=? next #\newline))
                (loop (and lst (cons next lst)))
                (done lst)))))))

(define (##skip-comment-done comment re)
  (let ((handler
         (macro-readtable-comment-handler
          (macro-readenv-readtable re))))
    (if (##procedure? handler)
        (handler (macro-readenv-wrap re comment)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Procedure to read datums starting with '#'.

(define (##read-sharp re c)
  (let ((start-pos (##readenv-current-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip #\#
    (##read-sharp-aux re start-pos)))

(define (##read-sharp-aux re start-pos)
  (let ((next (macro-peek-next-char-or-eof re)))
    (if (char? next)
        ((##readtable-char-sharp-handler (macro-readenv-readtable re) next)
         re
         next
         start-pos)
        (##read-sharp-other
         re
         next
         start-pos))))

(define (##read-sharp-vector re next start-pos)
  (macro-read-next-char-or-eof re) ;; skip char after #\#
  (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
  (let ((vect (##build-vector re 'vector start-pos #\))))
    (macro-readenv-wrap re vect)))

(define (##read-sharp-char re next start-pos)
  (let ((old-pos (macro-readenv-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip char after #\#
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let ((c (macro-read-next-char-or-eof re)))
      (cond ((not (char? c))
             (##raise-datum-parsing-exception 'incomplete-form-eof-reached re)
             (macro-readenv-filepos-set! re old-pos) ;; restore pos
             (##read-datum-or-label-or-none-or-dot re)) ;; skip error
            ((eq? (##readtable-char-handler (macro-readenv-readtable re) c)
                  ##read-whitespace)
             (macro-readenv-wrap re c))
            (else
             (let ((next (macro-peek-next-char-or-eof re)))
               (if (or (not (char? next))
                       (##readtable-char-delimiter?
                        (macro-readenv-readtable re)
                        next))
                   (macro-readenv-wrap re c)
                   (let ((name (##build-delimited-string re c 1)))

                     (define (read-hex nb-digits)
                       (and (or (not nb-digits)
                                (= (- (string-length name) 1) nb-digits))
                            (let loop ((i 1)
                                       (n 0))
                              (cond ((= i (string-length name))
                                     (UCS-4 n))
                                    ((##char-hexadecimal? (string-ref name i))
                                     =>
                                     (lambda (next-digit)
                                       (loop (+ i 1)
                                             (if (< n ##max-char)
                                                 (+ (* n 16) next-digit)
                                                 n))))
                                    (else
                                     #f)))))

                     (define (UCS-4 n)
                       (if (not (in-char-range? n))
                           (begin
                             (##raise-datum-parsing-exception
                              'character-out-of-range
                              re)
                             (macro-readenv-filepos-set! re old-pos) ;; restore pos
                             (##read-datum-or-label-or-none-or-dot re)) ;; skip error
                           (macro-readenv-wrap re (UCS-4->character n))))

                     (define (invalid-character-name-error)
                       (##raise-datum-parsing-exception
                        'invalid-character-name
                        re
                        name)
                       (macro-readenv-filepos-set! re old-pos) ;; restore pos
                       (##read-datum-or-label-or-none-or-dot re)) ;; skip error

                     (or (cond ((char=? c #\x)
                                (read-hex #f))
                               ((char=? c #\u)
                                (read-hex 4))
                               ((char=? c #\U)
                                (read-hex 8))
                               #; ;; disable old #\#x1234 character syntax
                               ((char=? c #\#)
                                (let ((n (string->number name 10)))
                                  (and n
                                       (integer? n)
                                       (exact? n)
                                       (UCS-4 n))))
                               (else
                                #f))
                         (let* ((rt
                                 (macro-readenv-readtable re))
                                (x
                                (##read-assoc-string=?
                                 re
                                 name
                                 (macro-readtable-named-char-table rt))))
                           (if x
                               (macro-readenv-wrap re (cdr x))
                               (invalid-character-name-error))))))))))))

(define (##read-sharp-comment re next start-pos)
  (let ((old-pos (macro-readenv-filepos re)))
    (macro-readenv-filepos-set! re start-pos) ;; in case error in comment
    (macro-read-next-char-or-eof re) ;; skip char after #\#
    (##skip-extended-comment re #\# next next #\#)
    (macro-readenv-filepos-set! re old-pos) ;; restore pos
    (##read-datum-or-label-or-none-or-dot re))) ;; read what follows comment

(define (##case-conversion-set! re val)
  (macro-readenv-case-conversion?-set! re val))

(define (##read-script-line re prefix)
  (let* ((rest-of-line
          (##read-line (macro-readenv-port re) #\newline #f ##max-fixnum))
         (script-line
          (string-append prefix (if (string? rest-of-line) rest-of-line "")))
         (language-and-tail
          (##extract-language-and-tail script-line)))
    (if language-and-tail
        (let ((language (##car language-and-tail)))
          (##readtable-setup-for-language!
           (macro-readenv-readtable re)
           language)))
    (macro-readenv-script-line-set! re script-line)))

(define (##read-sharp-bang re next start-pos)
  (let ((old-pos (macro-readenv-filepos re)))

    (define (ignore)
      (macro-readenv-filepos-set! re old-pos) ;; restore pos
      (##read-datum-or-label-or-none-or-dot re))

    (macro-read-next-char-or-eof re) ;; skip char after #\#
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let ((name (##build-delimited-string re #\space 0)))
      (cond ((##string=? name "fold-case")
             (##case-conversion-set! re #t)
             (ignore))
            ((##string=? name "no-fold-case")
             (##case-conversion-set! re #f)
             (ignore))
            (else
             (let ((x
                    (##read-assoc-string=?
                     re
                     name
                     (macro-readtable-sharp-bang-table
                      (macro-readenv-readtable re)))))
               (cond (x
                      (macro-readenv-wrap re (cdr x)))
                     ((and (eq? (macro-readenv-script-line re) #t) ;; script allowed?
                           (eqv? start-pos 0)) ;; at start of file
                      (##read-script-line re name)
                      (##script-marker))
                     (else
                      (##raise-datum-parsing-exception 'invalid-sharp-bang-name re name)
                      (ignore))))))))) ;; skip error

(define (##read-sharp-keyword/symbol re next start-pos)
  (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
  (let ((str (##build-delimited-string re #\# 1)))
    (let ((sharp-seq-keyword
           (macro-readtable-sharp-seq-keyword
            (macro-readenv-readtable re))))
      (or (and sharp-seq-keyword
               (let ((n (string-length str)))
                 (let loop ((i 0))
                   (cond ((>= i n)
                          (##wrap-op1* re
                                       start-pos
                                       sharp-seq-keyword
                                       (- n 1)))
                         ((char=? #\# (string-ref str i))
                          (loop (+ i 1)))
                         (else
                          #f)))))
          (let ((obj (##string->number/keyword/symbol re str #t)))
            (macro-readenv-wrap re obj))))))

(define (##read-sharp-colon re next start-pos)
  (let ((old-pos (macro-readenv-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip char after #\#
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let ((next (macro-peek-next-char-or-eof re)))
      (if (or (not (char? next))
              (##readtable-char-delimiter? (macro-readenv-readtable re) next))
          (begin
            (##raise-datum-parsing-exception 'invalid-token re)
            (macro-readenv-filepos-set! re old-pos) ;; restore pos
            (##read-datum-or-label-or-none-or-dot re)) ;; skip error
          (begin
            (macro-read-next-char-or-eof re) ;; skip char after #\:
            (let ((obj (##build-delimited-number/keyword/symbol re next #f)))
              (macro-readenv-wrap re obj)))))))

(define (##read-sharp-semicolon re next start-pos)
  (let ((old-pos (macro-readenv-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip char after #\#
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let ((obj (##read-datum-or-label re)))
      (if (##label-marker? obj)
          (##label-marker-fixup-handler-add!
           re
           obj
           (lambda (resolved-obj)
             #f)))
      (macro-readenv-filepos-set! re old-pos) ;; restore pos
      (##read-datum-or-label-or-none-or-dot re)))) ;; read what follows comment

(define (##read-sharp-quotation re next start-pos)
  (let ((old-pos (macro-readenv-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip #\' or #\` or #\,
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let ((keyword
           (cond ((eqv? next #\,)
                  (let ((after-comma (macro-peek-next-char-or-eof re)))
                    (if (eqv? after-comma #\@)
                        (begin
                          (macro-read-next-char-or-eof re) ;; skip #\@
                          (macro-readtable-sharp-unquote-splicing-keyword
                           (macro-readenv-readtable re)))
                        (macro-readtable-sharp-unquote-keyword
                         (macro-readenv-readtable re)))))
                 ((eqv? next #\`)
                  (macro-readtable-sharp-quasiquote-keyword
                   (macro-readenv-readtable re)))
                 (else
                  (macro-readtable-sharp-quote-keyword
                   (macro-readenv-readtable re))))))
      (##build-read-macro re start-pos old-pos keyword))))

(define (##read-sharp-ampersand re next start-pos)
  (macro-read-next-char-or-eof re) ;; skip char after #\#
  (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
  (let ((obj (##read-datum-or-label re)))
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let ((b (box obj)))
      (if (##label-marker? obj)
          (##label-marker-fixup-handler-add!
           re
           obj
           (lambda (resolved-obj)
             (set-box! b resolved-obj))))
      (macro-readenv-wrap re b))))

(cond-expand
 (enable-sharp-dot

  (define (##read-sharp-dot re next start-pos)
    (if (not (macro-readtable-eval-allowed? (macro-readenv-readtable re)))
        (begin
          (##raise-datum-parsing-exception 'invalid-token re)
          (##read-datum-or-label-or-none-or-dot re)) ;; skip error
        (begin
          (macro-read-next-char-or-eof re) ;; skip char after #\#
          (let* ((expr
                  (##read-expr-from-port
                   (macro-readenv-port re)))
                 (val
                  (##eval expr)))
            (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
            (macro-readenv-wrap re val))))))

 (else))

(define-prim (##read-sharp-less re next start-pos)

  (define (eof)
    (##raise-datum-parsing-exception 'incomplete-form-eof-reached re))

  (define (invalid-token)
    (##raise-datum-parsing-exception 'invalid-token re))

  (macro-read-next-char-or-eof re) ;; skip char after #\#
  (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
  (if (macro-readtable-here-strings-allowed?
       (macro-readenv-readtable re))
      (let ((separator (macro-read-next-char-or-eof re)))
        (cond ((not (char? separator))
               (eof))
              ((char=? separator #\<)
               ;; Multiline SCSH here string of the form
               ;; #<<END
               ;; hello world
               ;; END
               (let ((tag
                      (##read-line (macro-readenv-port re) #\newline #t ##max-fixnum)))
                 (let loop ((lines-rev '()))
                   (let ((line
                          (##read-line (macro-readenv-port re) #\newline #t ##max-fixnum)))
                     (if (string? line)
                         (if (string=? line tag)
                             (let* ((str
                                     (##string-concatenate (##reverse lines-rev)))
                                    (len
                                     (string-length str)))
                               (if (< 0 len)
                                   (##string-shrink! str (- len 1)))
                               (macro-readenv-wrap re str))
                             (loop (cons line lines-rev)))
                         (eof))))))
              ((eq? (macro-readtable-here-strings-allowed?
                     (macro-readenv-readtable re))
                    #t)
               ;; Delimited here string of the form #<|foo|
               (let ((str
                      (##read-line (macro-readenv-port re) separator #t ##max-fixnum)))
                 (if (string? str)
                     (let ((len (string-length str)))
                       (if (and (< 0 len)
                                (char=? (string-ref str (- len 1)) separator))
                           (begin
                             (##string-shrink! str (- len 1))
                             (macro-readenv-wrap re str))
                           (eof)))
                     (eof))))
              ((invalid-token))))
      (invalid-token)))

(define (##read-sharp-digit re next start-pos)
  (let ((old-pos (macro-readenv-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip char after #\#
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let ((s (##build-decimal-integer re next 2)))
      (string-set! s 0 #\0)
      (let* ((n (string->number s 10))
             (c (macro-peek-next-char-or-eof re)))
        (cond ((or (and (not (eqv? c #\#))
                        (not (eqv? c #\=)))
                   (not (macro-readtable-sharing-allowed?
                         (macro-readenv-readtable re))))
               (##wrap-op1* re
                            start-pos
                            (macro-readtable-sharp-num-keyword
                             (macro-readenv-readtable re))
                            n))
              ((eqv? c #\#)
               (macro-read-next-char-or-eof re) ;; skip #\#
               (##label-marker-reference re n))
              (else
               (macro-read-next-char-or-eof re) ;; skip #\=
               (let ((obj (##read-datum-or-label re)))
                 (if (##label-marker? obj)
                     (begin
                       (##raise-datum-parsing-exception
                        'illegal-label-definition
                        re
                        n)
                       (##void))
                     (let ((uobj (macro-readenv-unwrap re obj)))
                       (##label-marker-define re n uobj)
                       obj)))))))))

(define (##wrap re pos datum)
  (let ((old-pos (macro-readenv-filepos re)))
    (macro-readenv-filepos-set! re pos)
    (let ((x (macro-readenv-wrap re datum)))
      (macro-readenv-filepos-set! re old-pos) ;; restore pos
      x)))

(define (##wrap-op re pos op args)
  (let loop ((lst args))
    (if (pair? lst)
        (let ((arg (car lst)))
          (if (##label-marker? arg)
              (##label-marker-fixup-handler-add!
               re
               arg
               (lambda (resolved-obj)
                 (set-car! lst resolved-obj))))
          (loop (cdr lst)))))
  (##wrap re pos (cons (##wrap re pos op) args)))

(define (##wrap-op0 re pos op)
  (##wrap-op re pos op '()))

(define (##wrap-op1 re pos op arg1)
  (##wrap-op re pos op (list arg1)))

(define (##wrap-op1* re pos op arg1)
  (##wrap-op re pos op (list (##wrap re pos arg1))))

(define (##wrap-op2 re pos op arg1 arg2)
  (##wrap-op re pos op (list arg1 arg2)))

(define (##wrap-op3 re pos op arg1 arg2 arg3)
  (##wrap-op re pos op (list arg1 arg2 arg3)))

(define (##wrap-op4 re pos op arg1 arg2 arg3 arg4)
  (##wrap-op re pos op (list arg1 arg2 arg3 arg4)))

(define (##read-sharp-other re next start-pos)
  (let ((old-pos (macro-readenv-filepos re)))
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let* ((s
            (##build-delimited-string re #\# 1))
           (num
            (string->number s 10)))
      (if num

          (macro-readenv-wrap re num)

          (let ()

            (define (build-vect re kind)
              (let ((c (macro-read-next-char-or-eof re)))
                (if (eqv? c #\()
                    (macro-readenv-wrap re (##build-vector re kind start-pos #\)))
                    (begin
                      (##raise-datum-parsing-exception 'open-paren-expected re)
                      (macro-readenv-filepos-set! re old-pos) ;; restore pos
                      (##read-datum-or-label-or-none-or-dot re))))) ;; skip error

            (define (deserialize re implode);;;;;;;;;;;;;;;;;;;;;;;;;;;;
              (let ((c (macro-read-next-char-or-eof re)))
                (if (eqv? c #\()
                    (let* ((old-wrapper (macro-readenv-wrapper re))
                           (old-unwrapper (macro-readenv-unwrapper re)))
                      (macro-readenv-wrapper-set! re (lambda (re x) x))
                      (macro-readenv-unwrapper-set! re (lambda (re x) x))
                      (let* ((fields
                              (##build-vector re 'deserialize start-pos #\)))
                             (obj
                              (implode re fields)))
                        (macro-readenv-wrapper-set! re old-wrapper)
                        (macro-readenv-unwrapper-set! re old-unwrapper)
                        (if obj
                            (macro-readenv-wrap re obj)
                            (begin
                        ;;;;;;;;;;;;error
                              (##raise-datum-parsing-exception 'open-paren-expected re)
                              (macro-readenv-filepos-set! re old-pos) ;; restore pos
                              (##read-datum-or-label-or-none-or-dot re))))) ;; skip error
                    (begin
                      (##raise-datum-parsing-exception 'open-paren-expected re)
                      (macro-readenv-filepos-set! re old-pos) ;; restore pos
                      (##read-datum-or-label-or-none-or-dot re))))) ;; skip error

            (cond ((or ;;(##read-string=? re s "#f")
                    (string-ci=? s "#F")
                    (and (macro-readtable-r7rs-compatible-read?
                          (macro-readenv-readtable re))
                         (string-ci=? s "#FALSE")))
                   (macro-readenv-wrap re (false-obj)))
                  ((or ;;(##read-string=? re s "#t")
                    (string-ci=? s "#T")
                    (and (macro-readtable-r7rs-compatible-read?
                          (macro-readenv-readtable re))
                         (string-ci=? s "#TRUE")))
                   (macro-readenv-wrap re #t))
                  ((##read-string=? re s "#u8")
                   (build-vect re 'u8vector))
                  ((macro-if-s8vector (##read-string=? re s "#s8") #f)
                   (build-vect re 's8vector))
                  ((macro-if-u16vector (##read-string=? re s "#u16") #f)
                   (build-vect re 'u16vector))
                  ((macro-if-s16vector (##read-string=? re s "#s16") #f)
                   (build-vect re 's16vector))
                  ((macro-if-u32vector (##read-string=? re s "#u32") #f)
                   (build-vect re 'u32vector))
                  ((macro-if-s32vector (##read-string=? re s "#s32") #f)
                   (build-vect re 's32vector))
                  ((macro-if-u64vector (##read-string=? re s "#u64") #f)
                   (build-vect re 'u64vector))
                  ((macro-if-s64vector (##read-string=? re s "#s64") #f)
                   (build-vect re 's64vector))
                  ((macro-if-f32vector (##read-string=? re s "#f32") #f)
                   (build-vect re 'f32vector))
                  ((##read-string=? re s "#f64")
                   (build-vect re 'f64vector))
                  ((##read-string=? re s "#structure")
                   (deserialize re ##implode-structure))
                  ((##read-string=? re s "#gc-hash-table")
                   (deserialize re ##implode-gc-hash-table))
                  ((##read-string=? re s "#frame")
                   (deserialize re ##implode-frame))
                  ((##read-string=? re s "#continuation")
                   (deserialize re ##implode-continuation))
                  ((##read-string=? re s "#procedure")
                   (deserialize re ##implode-procedure))
                  ((##read-string=? re s "#return")
                   (deserialize re ##implode-return))
                  ((##read-string=? re s "#promise")
                   (deserialize re ##implode-promise))
                  ((##read-string=? re s "#absent")
                   (##wrap re
                           start-pos
                           (macro-absent-obj)))
                  (else
                   (let ((sharp-seq-keyword
                          (macro-readtable-sharp-seq-keyword
                           (macro-readenv-readtable re))))
                     (if (and sharp-seq-keyword
                              (##read-string=? re s "#"))
                         (##wrap-op1* re
                                      start-pos
                                      sharp-seq-keyword
                                      0)
                         (begin
                           (##raise-datum-parsing-exception 'invalid-token re)
                           (macro-readenv-filepos-set! re old-pos) ;; restore pos
                           (##read-datum-or-label-or-none-or-dot re))))))))))) ;; skip error

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##read-whitespace re c)
  (macro-read-next-char-or-eof re) ;; skip whitespace character
  (##read-datum-or-label-or-none-or-dot re)) ;; read what follows whitespace

(define (##read-single-line-comment re c)
  (##skip-single-line-comment "" re) ;; skip comment
  (##read-datum-or-label-or-none-or-dot re)) ;; read what follows comment

(define (##read-escaped-string re c)
  (let ((start-pos (##readenv-current-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip #\"
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let ((str (##build-escaped-string-up-to re c)))
      (macro-readenv-wrap re str))))

(define (##read-quotation re c)
  (let* ((old-pos (macro-readenv-filepos re))
         (start-pos (##readenv-current-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip #\' or #\` or #\,
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let ((keyword
           (cond ((eqv? c #\,)
                  (let ((after-comma (macro-peek-next-char-or-eof re)))
                    (if (eqv? after-comma #\@)
                        (begin
                          (macro-read-next-char-or-eof re) ;; skip #\@
                          (macro-readtable-unquote-splicing-keyword
                           (macro-readenv-readtable re)))
                        (macro-readtable-unquote-keyword
                         (macro-readenv-readtable re)))))
                 ((eqv? c #\`)
                  (macro-readtable-quasiquote-keyword
                   (macro-readenv-readtable re)))
                 (else
                  (macro-readtable-quote-keyword
                   (macro-readenv-readtable re))))))
      (##build-read-macro re start-pos old-pos keyword))))

(define (##closing-parenthesis-for c)
  (cond ((char=? c #\[) #\])
        ((char=? c #\{) #\})
        ((char=? c #\<) #\>)
        (else           #\))))

(define (##read-vector-or-list re c)
  (if (macro-readtable-r6rs-compatible-read?
       (macro-readenv-readtable re))
      (##read-list re c)
      (##read-vector re c)))

(define (##read-list re c)
  (let ((start-pos (##readenv-current-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip #\( or #\[ or #\{ or #\<
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let* ((close (##closing-parenthesis-for c))
           (lst (##build-list re #t start-pos close)))

      (define (prefix keyword)
        (macro-readenv-wrap
         re
         (if (##procedure? keyword)
             (keyword re lst)
             (cons (macro-readenv-wrap re keyword) lst))))

      (cond ((and (char=? c #\[)
                  (macro-readtable-bracket-handler
                   (macro-readenv-readtable re)))
             =>
             prefix)
            ((and (char=? c #\{)
                  (macro-readtable-brace-handler
                   (macro-readenv-readtable re)))
             =>
             prefix)
            ((and (char=? c #\<)
                  (macro-readtable-angle-handler
                   (macro-readenv-readtable re)))
             =>
             prefix)
            ((macro-readtable-paren-handler
              (macro-readenv-readtable re))
             =>
             prefix)
            (else
             (macro-readenv-wrap re lst))))))

(define (##read-vector re c)
  (let ((start-pos (##readenv-current-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip #\( or #\[ or #\{ or #\<
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let* ((close (##closing-parenthesis-for c))
           (v (##build-vector re 'vector start-pos close)))
      (macro-readenv-wrap re v))))

(define (##read-other re c)
  (##read-list re c))

(define (##read-none re c)
  (##none-marker))

(define (##read-illegal re c)
  (let* ((old-pos (macro-readenv-filepos re))
         (start-pos (##readenv-current-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip illegal character
    (macro-readenv-filepos-set! re start-pos) ;; set pos to illegal char
    (##raise-datum-parsing-exception 'illegal-character re c)
    (macro-readenv-filepos-set! re old-pos) ;; restore pos
    (##read-datum-or-label-or-none-or-dot re))) ;; skip error

(define (##read-dot re c)
  (let ((start-pos (##readenv-current-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip #\.
    (let ((next (macro-peek-next-char-or-eof re)))
      (if (or (not (char? next))
              (##readtable-char-delimiter? (macro-readenv-readtable re) next))
          (##dot-marker)
          (begin
            (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
            (let ((obj (##build-delimited-number/keyword/symbol re c #t)))
              (macro-readenv-wrap re obj)))))))

(define (##read-number/keyword/symbol re c)
  (let ((start-pos (##readenv-current-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip "c"
    (if (and (char=? c #\@)
             (eq? (macro-readenv-script-line re) #t) ;; script allowed?
             (eqv? start-pos 0) ;; at start of file
             (eqv? (macro-peek-next-char-or-eof re) #\;))
        (begin
          (macro-read-next-char-or-eof re) ;; skip #\;
          (##read-script-line re "")
          (##script-marker))
        (begin
          (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
          (let ((obj (##build-delimited-number/keyword/symbol re c #t)))
            (macro-readenv-wrap re obj))))))

(define (##read-assoc-string=? re x lst)
  (let loop ((lst lst))
    (if (pair? lst)
        (let ((couple (car lst)))
          (let ((y (car couple)))
            (if (##read-string=? re x y)
                couple
                (loop (cdr lst)))))
        #f)))

(define (##read-string=? re str1 str2)
  (let ((case-conversion?
         (macro-readenv-case-conversion? re)))
    (if case-conversion?
        (string-ci=? str1 str2)
        (string=? str1 str2))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Scheme infix extension (SIX) parser.

(define (##read-six re c)
  (let ((start-pos (##readenv-current-filepos re)))
    (macro-read-next-char-or-eof re) ;; skip backslash
    (macro-readenv-filepos-set! re start-pos) ;; set pos to start of datum
    (let ((datum
           (let ((autosemi? #t)
                 (allow-eof? #f))
             (##read-six-datum-or-eof re autosemi? allow-eof?))))
      (##wrap-op1 re
                  start-pos
                  'six.infix
                  datum))))

(define (##read-six-datum-or-eof re autosemi? allow-eof?)

  (##define-macro (define-six-token name . params)
    `(define ,name
       '#(,@params)))

  (##define-macro (define-six-op
                    name
                    precedence
                    associativity
                    . scheme-names)
    `(define-six-token ,name
       ,(+ (* precedence 2) (if (eq? associativity 'lr) 0 1))
       ,@scheme-names))

  (define (op? x)
    (and (vector? x)
         (< 1 (vector-length x))))

  (define (precedence op)
    (quotient (vector-ref op 0) 2))

  (define (left-to-right? op)
    (= (modulo (vector-ref op 0) 2) 0))

  (define (binary-or-ternary? op)
    (vector-ref op 1))

  (define (ternary? tok)
    (cond ((eq? tok op.?)
           |op.:|)
          (else
           #f)))

  (define (unary-prefix? op)
    (and (< 2 (vector-length op))
         (vector-ref op 2)))

  (define (unary-postfix? op)
    (and (< 3 (vector-length op))
         (vector-ref op 3)))

  (define-six-token |token.(|    -1)
  (define-six-token |token.)|    -2)
  (define-six-token |token.->|   -3)
  (define-six-token |token..|    -4)
  (define-six-token |token...|   -5)
  (define-six-token |token.;|    -6)
  (define-six-token |token.[|    -7)
  (define-six-token |token.\\|   -8)
  (define-six-token |token.]|    -9)
  (define-six-token |token.{|    -10)
  (define-six-token |token.}|    -11)
  (define-six-token |token.`|    -12)
  (define-six-token |token.#|    -13)
  (define-six-token |token.;-auto| -14)

  (define-six-op op.async  0  rl #f             six.asyncx       )
  (define-six-op op.!      2  rl six.x!y        six.!x           )
  (define-six-op op.**     2  rl six.x**y       six.**x          )
  (define-six-op op.++     2  rl #f             six.++x six.x++  )
  (define-six-op op.--     2  rl #f             six.--x six.x--  )
  (define-six-op op.~      2  rl #f             six.~x           )
  (define-six-op op.await  2  rl #f             six.awaitx       )
  (define-six-op op.typeof 2  rl #f             six.typeofx      )
  (define-six-op op.%      3  lr six.x%y                         )
  (define-six-op op.*      3  lr six.x*y        six.*x           )
  (define-six-op op.@      3  lr six.x@y                         )
  (define-six-op op./      3  lr six.x/y                         )
  (define-six-op op.//     3  lr six.x//y                        )
  (define-six-op op.+      4  lr six.x+y        six.+x           )
  (define-six-op op.-      4  lr six.x-y        six.-x           )
  (define-six-op op.<<     5  lr six.x<<y                        )
  (define-six-op op.>>     5  lr six.x>>y                        )
  (define-six-op op.>>>    5  lr six.x>>>y                       )
  (define-six-op op.<      6  lr six.x<y                         )
  (define-six-op op.<=     6  lr six.x<=y                        )
  (define-six-op op.>      6  lr six.x>y                         )
  (define-six-op op.>=     6  lr six.x>=y                        )
  (define-six-op op.in     6  lr six.xiny                        )
  (define-six-op op.is     6  lr six.xisy                        )
  (define-six-op op.instanceof 6 lr six.xinstanceofy             )
  (define-six-op op.!=     7  lr six.x!=y                        )
  (define-six-op op.==     7  lr six.x==y                        )
  (define-six-op op.!==    7  lr six.x!==y                       )
  (define-six-op op.===    7  lr six.x===y                       )
  (define-six-op op.&      8  lr six.x&y        six.&x           )
  (define-six-op op.^      9  lr six.x^y                         )
  (define-six-op |op.\||   10 lr |six.x\|y|                      )
  (define-six-op op.&&     11 lr six.x&&y                        )
  (define-six-op |op.\|\|| 12 lr |six.x\|\|y|                    )
  (define-six-op op.not    13 rl #f             six.notx         )
  (define-six-op op.and    14 lr six.xandy                       )
  (define-six-op op.or     15 lr six.xory                        )
  (define-six-op op.?      16 rl six.x?y:z                       )
  (define-six-op |op.:|    17 rl six.x:y                         )
  (define-six-op op.%=     18 rl six.x%=y                        )
  (define-six-op op.&=     18 rl six.x&=y                        )
  (define-six-op op.**=    18 rl six.x**=y                       )
  (define-six-op op.*=     18 rl six.x*=y                        )
  (define-six-op op.@=     18 rl six.x@=y                        )
  (define-six-op op.+=     18 rl six.x+=y                        )
  (define-six-op op.-=     18 rl six.x-=y                        )
  (define-six-op op.//=    18 rl six.x//=y                       )
  (define-six-op op./=     18 rl six.x/=y                        )
  (define-six-op op.<<=    18 rl six.x<<=y                       )
  (define-six-op op.=      18 rl six.x=y                         )
  (define-six-op op.>>>=   18 rl six.x>>>=y                      )
  (define-six-op op.>>=    18 rl six.x>>=y                       )
  (define-six-op op.^=     18 rl six.x^=y                        )
  (define-six-op |op.\|=|  18 rl |six.x\|=y|                     )
  (define-six-op op.:=     19 rl six.x:=y                        )
  (define-six-op op.yield  20 rl #f             six.yieldx       )
  (define-six-op |op.,|    21 lr |six.x,y|  );;;;;;;;;;;;;;;;  |six.,x|         )
  (define-six-op op.:-     22 rl six.x:-y                        )

  (define max-precedence 22)

  (define (identifier-op? ident)
    (or (identifier-unary-op? ident)
        (identifier-binary-op? ident)))

  (define (identifier-unary-op? ident)
    (cond ((eq? ident 'not)    op.not)
          ((eq? ident 'async)  op.async)
          ((eq? ident 'await)  op.await)
          ((eq? ident 'yield)  op.yield)
          ((eq? ident 'typeof) op.typeof)
          (else                #f)))

  (define (identifier-binary-op? ident)
    (cond ((eq? ident 'in)         op.in)
          ((eq? ident 'is)         op.is)
          ((eq? ident 'or)         op.or)
          ((eq? ident 'and)        op.and)
          ((eq? ident 'instanceof) op.instanceof)
          (else                    #f)))

  (define (decimal-digit? c)
    (and (not (char<? c #\0)) (not (char<? #\9 c))))

  (define (alphabetic? c)
    (or (and (not (char<? c #\a)) (not (char<? #\z c)))
        (and (not (char<? c #\A)) (not (char<? #\Z c)))))

  (define (identifier-starter? c)
    (or (char=? c #\_)
        (char=? c #\$)
        (alphabetic? c)))

  (define (eat-either re char1 char2)
    (let ((next (macro-peek-next-char-or-eof re)))
      (if (and (char? next)
               (or (char=? next char1)
                   (char=? next char2)))
          (begin
            (macro-read-next-char-or-eof re) ;; skip "next"
            #t)
          #f)))

  (define (parse-number re c1 c2)
    (let ((str
           (let loop ((i 2) (state (if (char=? c1 #\.) 1 0)))
             (let ((next (macro-peek-next-char-or-eof re)))
               (if (or (not (char? next))
                       (not (or (decimal-digit? next)
                                (and (= state 0)
                                     (char=? next #\.))
                                (and (< state 2)
                                     (or (char=? next #\e)
                                         (char=? next #\E)))
                                (and (= state 2)
                                     (or (char=? next #\+)
                                         (char=? next #\-))))))
                   (let ((str (make-string i c2)))
                     ;; handle C number suffixes
                     (let* ((suff-l (eat-either re #\l #\L))
                            (suff-u (and (= state 0)
                                         (eat-either re #\u #\U)))
                            (suff-l2 (and (not suff-l)
                                          suff-u
                                          (eat-either re #\l #\L)))
                            (suff-f (and (> state 0)
                                         (not suff-l)
                                         (not suff-u)
                                         (eat-either re #\f #\F))))
                       str))
                   (begin
                     (macro-read-next-char-or-eof re) ;; skip "next"
                     (let ((s
                            (loop (+ i 1)
                                  (if (or (= state 2)
                                          (not (decimal-digit? next)))
                                      (+ state 1)
                                      state))))
                       (string-set! s i next)
                       s)))))))
      (string-set! str 0 c1)
      (let ((last (string-ref str (- (string-length str) 1))))
        (if (or (char=? last #\.) (decimal-digit? last))
            (string->number str)
            (begin
              (invalid-infix-syntax-number re)
              (macro-inexact-+0))))))

  (define (parse-character re c)
    (let ((str
           (##build-escaped-string-up-to re c)))
      (if (= (string-length str) 1)
          (string-ref str 0)
          (begin
            (invalid-infix-syntax-character re)
            #\nul))))

  (define (parse-identifier re c)
    (let ((str
           (let loop ((i 1))
             (let ((next (macro-peek-next-char-or-eof re)))
               (if (or (not (char? next))
                       (not (or (identifier-starter? next)
                                (decimal-digit? next))))
                   (make-string i c)
                   (begin
                     (macro-read-next-char-or-eof re) ;; skip "next"
                     (let ((s (loop (+ i 1))))
                       (string-set! s i next)
                       s)))))))
      (string->symbol-object str)))

  (define (parse-token re autosemi?)
    (parse-token-starting-with re autosemi? (macro-peek-next-char-or-eof re)))

  (define (parse-token-starting-with re autosemi? c)
    (cond ((not (char? c))
           (if autosemi?
               |token.;-auto|
               (##none-marker)))
          ((eq? (##readtable-char-handler (macro-readenv-readtable re) c)
                ##read-whitespace)
           (if autosemi?
               |token.;-auto|
               (begin
                 (macro-read-next-char-or-eof re) ;; skip whitespace character
                 (parse-token re autosemi?))))
          ((and autosemi?
                (or (char=? c #\})
                    (char=? c #\))
                    (char=? c #\])))
           |token.;-auto|)
          (else
           (let ((start-pos (##readenv-current-filepos re)))

             (macro-readenv-filepos-set! re start-pos) ;; restore pos
             (macro-read-next-char-or-eof re) ;; skip c

             (cond ((or (char=? c #\+)
                        (char=? c #\-)
                        (char=? c #\*)
                        (char=? c #\@)
                        (char=? c #\/)
                        (char=? c #\%)
                        (char=? c #\!)
                        (char=? c #\~)
                        (char=? c #\&)
                        (char=? c #\|)
                        (char=? c #\^)
                        (char=? c #\<)
                        (char=? c #\>)
                        (char=? c #\=)
                        (char=? c #\{)
                        (char=? c #\})
                        (char=? c #\()
                        (char=? c #\))
                        (char=? c #\[)
                        (char=? c #\])
                        (char=? c #\;)
                        (char=? c #\,)
                        (char=? c #\:)
                        (char=? c #\.)
                        (char=? c #\?)
                        (char=? c #\\)
                        (char=? c #\")
                        (char=? c #\')
                        (char=? c #\`)
                        (char=? c #\#)
                        (decimal-digit? c)
                        (identifier-starter? c))

                    (let ((next (macro-peek-next-char-or-eof re)))
                      (let ((x (if (char? next) next #\space)))

                        (define (token tok)
                          tok)

                        (define (token-skip-char tok)
                          (macro-read-next-char-or-eof re) ;; skip last
                          (token tok))

                        (cond ((char=? c #\+)
                               (cond ((char=? x #\+)
                                      (token-skip-char op.++))
                                     ((char=? x #\=)
                                      (token-skip-char op.+=))
                                     (else
                                      (token op.+))))
                              ((char=? c #\-)
                               (cond ((char=? x #\-)
                                      (token-skip-char op.--))
                                     ((char=? x #\=)
                                      (token-skip-char op.-=))
                                     ((char=? x #\>)
                                      (token-skip-char |token.->|))
                                     (else
                                      (token op.-))))
                              ((char=? c #\*)
                               (cond ((char=? x #\*)
                                      (macro-read-next-char-or-eof re);;skip #\*
                                      (if (eqv? (macro-peek-next-char-or-eof re)
                                                #\=)
                                          (token-skip-char op.**=)
                                          (token op.**)))
                                     ((char=? x #\=)
                                      (token-skip-char op.*=))
                                     (else
                                      (token op.*))))
                              ((char=? c #\/)
                               (cond ((char=? x #\*)
                                      (macro-read-next-char-or-eof re);;skip #\*
                                      (##skip-extended-comment re #\/ x x #\/)
                                      (parse-token re autosemi?))
                                     ((char=? x #\/)
                                      (macro-read-next-char-or-eof re);;skip #\/
                                      (if (eqv? (macro-peek-next-char-or-eof re)
                                                #\=)
                                          (token-skip-char op.//=)
                                          (token op.//)))
                                     ((char=? x #\=)
                                      (token-skip-char op./=))
                                     (else
                                      (token op./))))
                              ((char=? c #\%)
                               (cond ((char=? x #\=)
                                      (token-skip-char op.%=))
                                     (else
                                      (token op.%))))
                              ((char=? c #\@)
                               (cond ((char=? x #\=)
                                      (token-skip-char op.@=))
                                     (else
                                      (token op.@))))
                              ((char=? c #\!)
                               (cond ((char=? x #\=)
                                      (macro-read-next-char-or-eof re);;skip #\=
                                      (let ((next2
                                             (macro-peek-next-char-or-eof re)))
                                        (let ((x2 (if (char? next2)
                                                      next2
                                                      #\space)))
                                          (cond ((char=? x2 #\=)
                                                 (token-skip-char op.!==))
                                                (else
                                                 (token op.!=))))))
                                     (else
                                      (token op.!))))
                              ((char=? c #\~)
                               (token op.~))
                              ((char=? c #\&)
                               (cond ((char=? x #\&)
                                      (token-skip-char op.&&))
                                     ((char=? x #\=)
                                      (token-skip-char op.&=))
                                     (else
                                      (token op.&))))
                              ((char=? c #\|)
                               (cond ((char=? x #\|)
                                      (token-skip-char |op.\|\||))
                                     ((char=? x #\=)
                                      (token-skip-char |op.\|=|))
                                     (else
                                      (token |op.\||))))
                              ((char=? c #\^)
                               (cond ((char=? x #\=)
                                      (token-skip-char op.^=))
                                     (else
                                      (token op.^))))
                              ((char=? c #\<)
                               (cond ((char=? x #\<)
                                      (macro-read-next-char-or-eof re);;skip #\<
                                      (let ((next2
                                             (macro-peek-next-char-or-eof re)))
                                        (let ((x2 (if (char? next2)
                                                      next2
                                                      #\space)))
                                          (cond ((char=? x2 #\=)
                                                 (token-skip-char op.<<=))
                                                (else
                                                 (token op.<<))))))
                                     ((char=? x #\=)
                                      (token-skip-char op.<=))
                                     (else
                                      (token op.<))))
                              ((char=? c #\>)
                               (cond ((char=? x #\>)
                                      (macro-read-next-char-or-eof re);;skip #\>
                                      (let ((next2
                                             (macro-peek-next-char-or-eof re)))
                                        (let ((x2 (if (char? next2)
                                                      next2
                                                      #\space)))
                                          (cond ((char=? x2 #\>)
                                                 (macro-read-next-char-or-eof re);;skip #\>
                                                 (let ((next3
                                                        (macro-peek-next-char-or-eof re)))
                                                   (let ((x3 (if (char? next3)
                                                                 next3
                                                                 #\space)))
                                                     (cond ((char=? x3 #\=)
                                                            (token-skip-char op.>>>=))
                                                           (else
                                                            (token op.>>>))))))
                                                ((char=? x2 #\=)
                                                 (token-skip-char op.>>=))
                                                (else
                                                 (token op.>>))))))
                                     ((char=? x #\=)
                                      (token-skip-char op.>=))
                                     (else
                                      (token op.>))))
                              ((char=? c #\=)
                               (cond ((char=? x #\=)
                                      (macro-read-next-char-or-eof re);;skip #\=
                                      (let ((next2
                                             (macro-peek-next-char-or-eof re)))
                                        (let ((x2 (if (char? next2)
                                                      next2
                                                      #\space)))
                                          (cond ((char=? x2 #\=)
                                                 (token-skip-char op.===))
                                                (else
                                                 (token op.==))))))
                                     (else
                                      (token op.=))))
                              ((char=? c #\{)
                               (token |token.{|))
                              ((char=? c #\})
                               (token |token.}|))
                              ((char=? c #\()
                               (token |token.(|))
                              ((char=? c #\))
                               (token |token.)|))
                              ((char=? c #\[)
                               (token |token.[|))
                              ((char=? c #\])
                               (token |token.]|))
                              ((char=? c #\;)
                               (token |token.;|))
                              ((char=? c #\,)
                               (token |op.,|))
                              ((char=? c #\:)
                               (cond ((char=? x #\=)
                                      (token-skip-char op.:=))
                                     ((char=? x #\-)
                                      ;; In the C syntax "1?2:-3" is
                                      ;; parsed as "1 ? 2 : -3".  In
                                      ;; order to support the ":-"
                                      ;; operator cleanly, the source
                                      ;; code must have whitespace
                                      ;; between the ":" and "-",
                                      ;; otherwise it will be parsed as
                                      ;; "1 ? 2 :- 3" (which is a
                                      ;; syntax error).
                                      (token-skip-char op.:-))
                                     (else
                                      (token |op.:|))))
                              ((char=? c #\.)
                               (cond ((decimal-digit? x)
                                      (macro-read-next-char-or-eof re) ;; skip x
                                      (token (parse-number re c x)))
                                     ((char=? x #\.)
                                      (token-skip-char |token...|))
                                     (else
                                      (token |token..|))))
                              ((char=? c #\?)
                               (token op.?))
                              ((char=? c #\\)
                               (token |token.\\|))
                              ((or (char=? c #\") (char=? c #\'))
                               (token (##build-escaped-string-up-to re c)))
;;                              ((char=? c #\')
;;                               (token (parse-character re c)))
                              ((char=? c #\`)
                               (token |token.`|))
                              ((char=? c #\#)
                               (if (and (eq? (macro-readenv-script-line re) #t) ;; script allowed?
                                        (eqv? start-pos 0) ;; at start of file
                                        (char=? x #\!))
                                   (begin
                                     (macro-read-next-char-or-eof re);;skip #\!
                                     (##read-script-line re "")
                                     (##script-marker))
                                   (token |token.#|)))
                              ((decimal-digit? c)
                               (token (parse-number re #\0 c)))
                              (else
                               (token (parse-identifier re c)))))))

                   ((char=? c #\@)
                    (if (and (eq? (macro-readenv-script-line re) #t) ;; script allowed?
                             (eqv? start-pos 0) ;; at start of file
                             (eqv? (macro-peek-next-char-or-eof re) #\;))
                        (begin
                          (macro-read-next-char-or-eof re);;skip #\;
                          (##read-script-line re "")
                          (##script-marker))
                        (##none-marker)))

                   (else
                    (##none-marker)))))))

  (define (get-token re autosemi? maybe-tok)
    (or maybe-tok (parse-token re autosemi?)))

  (define (get-token-no-autosemi re maybe-tok)
    (get-token re #f maybe-tok))

  (define (expect re autosemi? maybe-tok expected)
    (let ((tok (get-token re autosemi? maybe-tok)))
      (if (or (eq? tok expected)
              (and (eq? tok |token.;-auto|)
                   (eq? expected |token.;|)))
          #f
          (begin
            (invalid-infix-syntax re)
            tok))))

  (define (expect-no-autosemi re maybe-tok expected)
    (expect re #f maybe-tok expected))

  (define (expect-and-get-token re autosemi? maybe-tok expected)
    (get-token re
               autosemi?
               (expect re autosemi? maybe-tok expected)))

  (define (read-arguments-tail re autosemi? maybe-tok cont)
    (let* ((autosemi? #f) ;; in (...) explicit semicolons are required
           (tok (get-token-no-autosemi re maybe-tok)))
      (if (eq? tok |token.)|)
          (cont re
                #f
                '())
          (let loop ((re re) (tok tok) (args '()))
            (cond ((expression-starter? re tok)
                   (read-expression
                    re
                    autosemi?
                    tok
                    max-precedence
                    'no-comma
                    (lambda (re maybe-tok expr)
                      (let ((new-args (cons expr args)))
                        (let ((tok (get-token re autosemi? maybe-tok)))
                          (cond ((eq? tok |op.,|)
                                 (loop re
                                       (get-token re autosemi? #f)
                                       new-args))
                                (else
                                 (cont re
                                       (expect re autosemi? tok |token.)|)
                                       (reverse new-args)))))))))
                  (else
                   (invalid-infix-syntax re)
                   (cont re
                         tok
                         (reverse args))))))))

  (define (read-list re autosemi? maybe-tok start-pos cont)
    (let loop ((re re) (maybe-tok maybe-tok) (first? #t) (cont cont))
      (let ((tok (get-token re autosemi? maybe-tok)))
        (cond ((expression-starter? re tok)
               (read-expression
                re
                autosemi?
                tok
                max-precedence
                'no-comma-and-no-bar
                (lambda (re maybe-tok expr1)
                  (let ((tok (get-token re autosemi? maybe-tok)))
                    (cond ((eq? tok |op.,|)
                           (loop re
                                 #f
                                 #f
                                 (lambda (re maybe-tok expr2)
                                   (cont re
                                         maybe-tok
                                         (##wrap-op2 re
                                                     start-pos
                                                     'six.list
                                                     expr1
                                                     expr2)))))
                          ((eq? tok |op.\||)
                           (read-expression
                            re
                            autosemi?
                            #f
                            max-precedence
                            #f
                            (lambda (re maybe-tok expr2)
                              (cont re
                                    (expect re autosemi? maybe-tok |token.]|)
                                    (##wrap-op2 re
                                                start-pos
                                                'six.cons
                                                expr1
                                                expr2)))))
                          (else
                           (cont re
                                 (expect re autosemi? tok |token.]|)
                                 (##wrap-op2 re
                                             start-pos
                                             'six.list
                                             expr1
                                             (##wrap-op0 re
                                                         start-pos
                                                         'six.null)))))))))
              (else
               (cont re
                     (expect re autosemi? tok |token.]|)
                     (##wrap-op0 re
                                 start-pos
                                 'six.null)))))))

  (define (expression-starter? re tok)
    ;; this function must be kept in sync with "read-expression"
    (or (eq? tok op.**)
        (eq? tok op.*)
        (eq? tok op.+)
        (eq? tok op.-)
        (eq? tok op.&)
        (eq? tok op.!)
        (eq? tok op.++)
        (eq? tok op.--)
        (eq? tok op.~)
        (primary-starter? re tok)))

  (define (primary-starter? re tok)
    (or (eq? tok |token.(|)
        (eq? tok |token.[|)
        (eq? tok |token.\\|)
        (eq? tok |token.`|)
        (eq? tok |token.#|)
        (symbol? tok) ;; catches "not", "function", "await", etc tokens
        (string? tok)
        (char? tok)
        (complex? tok)
        (pair? tok)
        (six-type? re tok)))

  (define (read-imports re autosemi? start-pos tok cont)
    (let loop ((re re) (tok tok) (rev-imports '()))
      (read-expression
       re
       #t ;; autosemi? = #t will cause end of expression at space
       tok
       max-precedence
       'no-comma ;; comma is used to separate imports
       (lambda (re maybe-tok expr1)
         (let ((maybe-tok
                (get-token-unless-whitespace-to-eol re maybe-tok)))

           (define (next re maybe-tok rev-imports)
             (if (eq? maybe-tok |op.,|)
                 (loop re
                       #f
                       rev-imports)
                 (cont re
                       maybe-tok
                       (reverse rev-imports))))

           (if (eq? maybe-tok 'as)
               (read-expression
                re
                #t ;; autosemi? = #t will cause end of expression at space
                (get-token re #f #f)
                max-precedence
                'no-comma ;; comma is used to separate imports
                (lambda (re maybe-tok expr2)
                  (let ((maybe-tok
                         (get-token-unless-whitespace-to-eol re maybe-tok)))
                    (next re
                          maybe-tok
                          (cons (##wrap-op2 re
                                            start-pos
                                            'six.xasy
                                            expr1
                                            expr2)
                                rev-imports)))))
               (next re
                     maybe-tok
                     (cons expr1
                           rev-imports))))))))

  (define (read-expression re autosemi? maybe-tok level restriction cont)
    (let* ((tok
            (get-token-no-autosemi re maybe-tok))
           (start-pos
            (macro-readenv-filepos re)))

      (cond ((let ((op (or (and (op? tok) tok)
                           (identifier-unary-op? tok))))
               (and op
                    (= (precedence op) level)
                    (unary-prefix? op)))
             =>
             (lambda (scheme-name)
               (let ((tok2 (get-token-no-autosemi re #f)))
                 (if (and (or (eq? tok |op.!|)
                              (identifier-unary-op? tok))
                          (not (expression-starter? re tok2)))
                     (cont re
                           tok2
                           (if (eq? tok |op.!|)
                               (##wrap-op0 re
                                           start-pos
                                           'six.!)
                               (wrap-identifier re start-pos tok)))
                     (read-expression
                      re
                      autosemi?
                      tok2
                      level
                      restriction
                      (lambda (re maybe-tok expr)
                        (cont re
                              maybe-tok
                              (##wrap-op1 re
                                          start-pos
                                          scheme-name
                                          expr))))))))

            ((< 0 level)
             (read-expression
              re
              autosemi?
              tok
              (- level 1)
              restriction
              (lambda (re maybe-tok expr1)
                (let ((tok (get-token re autosemi? maybe-tok)))
                  (if (= level 1)
                      (let loop ((re re)
                                 (last-tok tok)
                                 (last-expr1 expr1))
                        (cond ((and (op? last-tok)
                                    (unary-postfix? last-tok))
                               =>
                               (lambda (scheme-name)
                                 (loop re
                                       (get-token re autosemi? #f)
                                       (##wrap-op1 re
                                                   start-pos
                                                   scheme-name
                                                   last-expr1))))
                              ((eq? last-tok |token.(|)
                               (read-arguments-tail
                                re
                                autosemi?
                                #f
                                (lambda (re maybe-tok args)
                                  (loop re
                                        (get-token re autosemi? maybe-tok)
                                        (##wrap-op re
                                                   start-pos
                                                   'six.call
                                                   (cons last-expr1
                                                         args))))))
                              ((eq? last-tok |token.[|)
                               (read-expression
                                re
                                (let ((autosemi? #f)) ;; semicolons required
                                  autosemi?)
                                #f
                                max-precedence
                                #f
                                (lambda (re maybe-tok expr2)
                                  (loop re
                                        (expect-and-get-token
                                         re
                                         autosemi?
                                         maybe-tok
                                         |token.]|)
                                        (##wrap-op2 re
                                                    start-pos
                                                    'six.index
                                                    last-expr1
                                                    expr2)))))
                              ((or (eq? last-tok |token.->|)
                                   (eq? last-tok |token..|))
                               (let ((next
                                      (macro-peek-next-char-or-eof re)))
                                 (if (or (not (eq? last-tok |token..|))
                                         (and (char? next)
                                              (or (identifier-starter? next)
                                                  (char=? next #\\))))
                                     (read-identifier-or-backslash
                                      re
                                      #f
                                      #t
                                      (lambda (re maybe-tok identifier)
                                        (loop re
                                              (get-token re autosemi? maybe-tok)
                                              (##wrap-op2 re
                                                          start-pos
                                                          (if (eq? last-tok
                                                                   |token.->|)
                                                              'six.arrow
                                                              'six.dot)
                                                          last-expr1
                                                          identifier))))
                                     (cont re
                                           last-tok
                                           last-expr1))))
                              (else
                               (cont re
                                     last-tok
                                     last-expr1))))
                      (let ((tok2
                             (or (identifier-op? tok)
                                 tok)))
                        (cond ((and (op? tok2)
                                    (= level (precedence tok2))
                                    (not
                                     (cond ((eq? restriction 'no-comma)
                                            (eq? tok2 |op.,|))
                                           ((eq? restriction
                                                 'no-comma-and-no-bar)
                                            (or (eq? tok2 |op.,|)
                                                (eq? tok2 |op.\||)))
                                           ((eq? restriction 'no-colon)
                                            (eq? tok2 |op.:|))
                                           (else
                                            #f)))
                                    (binary-or-ternary? tok2))
                               =>
                               (lambda (scheme-name)
                                 (cond ((ternary? tok2)
                                        =>
                                        (lambda (end-tok)
                                          (read-expression
                                           re
                                           (let ((autosemi? #f)) ;; allow whitespace
                                             autosemi?)
                                           #f
                                           max-precedence
                                           'no-colon ;; assumes that end-tok = |op.:|
                                           (lambda (re maybe-tok expr2)
                                             (read-expression
                                              re
                                              autosemi?
                                              (expect-no-autosemi re maybe-tok end-tok)
                                              level
                                              restriction
                                              (lambda (re maybe-tok expr3)
                                                (cont re
                                                      maybe-tok
                                                      (##wrap-op3 re
                                                                  start-pos
                                                                  scheme-name
                                                                  expr1
                                                                  expr2
                                                                  expr3))))))))
                                       ((left-to-right? tok2)
                                        (let loop ((re re)
                                                   (last-scheme-name scheme-name)
                                                   (last-expr1 expr1))
                                          (read-expression
                                           re
                                           autosemi?
                                           #f
                                           (- level 1)
                                           restriction
                                           (lambda (re maybe-tok expr2)
                                             (let ((expr1
                                                    (##wrap-op2 re
                                                                start-pos
                                                                last-scheme-name
                                                                last-expr1
                                                                expr2)))
                                               (let ((tok (get-token re autosemi? maybe-tok)))
                                                 (cond ((and (op? tok)
                                                             (= level
                                                                (precedence tok))
                                                             (binary-or-ternary?
                                                              tok))
                                                        =>
                                                        (lambda (scheme-name)
                                                          (loop re
                                                                scheme-name
                                                                expr1)))
                                                       (else
                                                        (cont re
                                                              tok
                                                              expr1)))))))))
                                       (else
                                        (read-expression
                                         re
                                         autosemi?
                                         #f
                                         level
                                         restriction
                                         (lambda (re maybe-tok expr2)
                                           (cont re
                                                 maybe-tok
                                                 (##wrap-op2 re
                                                             start-pos
                                                             scheme-name
                                                             expr1
                                                             expr2))))))))
                              (else
                               (cont re
                                     tok
                                     expr1)))))))))

            ((eq? tok 'new)
             (read-identifier-or-backslash
              re
              #f
              #t
              (lambda (re maybe-tok identifier)
                (read-arguments-tail
                 re
                 autosemi?
                 (expect-no-autosemi re #f |token.(|)
                 (lambda (re maybe-tok args)
                   (cont re
                         maybe-tok
                         (##wrap-op re
                                    start-pos
                                    'six.new
                                    (cons identifier
                                          args))))))))

            ((or (eq? tok 'function) (six-type? re tok))
             (read-procedure
              re
              (expect-no-autosemi re #f |token.(|)
              start-pos
              (if (eq? tok 'function)
                  #f
                  tok)
              cont))

            ((pair? tok)
             ;; This special token represents two
             ;; consecutive tokens.  This trick is used
             ;; because the parser needs a lookahead of 2
             ;; tokens to distinguish definitions from
             ;; anonymous procedures, and to distinguish
             ;; label definitions from expressions.
             (if (cdr tok)
                 (let ((expr (car tok)))
                   (cont re
                         (cdr tok)
                         expr))
                 (let ((type (car tok)))
                   (read-procedure
                    re
                    #f
                    start-pos
                    (if (eq? type 'function)
                        #f
                        type)
                    cont))))

            ((or (string? tok)
                 (char? tok)
                 (complex? tok))
             (let ((literal (macro-readenv-wrap re tok)))
               (cont re
                     #f
                     (##wrap-op1 re
                                 start-pos
                                 'six.literal
                                 literal))))

            ((eq? tok |token.(|)
             (let* ((autosemi? #f) ;; in (...) explicit semicolons are required
                    (tok (get-token-no-autosemi re #f)))

               (define (check-closing re maybe-tok x)
                 (cont re
                       (expect re autosemi? maybe-tok |token.)|)
                       x))

               (if (eq? tok |token.{|)
                   (let ((start-pos (macro-readenv-filepos re)))
                     (read-compound-statement
                      re
                      #f
                      start-pos
                      'six.compound
                      check-closing))
                   (read-expression
                    re
                    (let ((autosemi? #f)) ;; allow whitespace
                      autosemi?)
                    tok
                    max-precedence
                    #f
                    check-closing))))

            ((eq? tok |token.[|)
             (read-list
              re
              (let ((autosemi? #f)) ;; in [...] explicit semicolons are required
                autosemi?)
              #f
              start-pos
              cont))

            ((eq? tok |token.`|)
             (read-backquote
              re
              start-pos
              cont))

            ((eq? tok |token.#|);;;;;;;;;;;;;;;;;;;;;
             (read-sharp
              re
              start-pos
              cont))

            (else
             (read-identifier-or-backslash
              re
              tok
              #f
              cont)))))

  (define (read-paren-expression re get-token-after-close-paren? maybe-tok cont)
    (let* ((autosemi? #f) ;; require semicolons from "(" to after ")"
           (tok (expect-and-get-token re autosemi? maybe-tok |token.(|)))

      (define (check-closing re maybe-tok x)
        (cont re
              (if get-token-after-close-paren?
                  (expect-and-get-token re autosemi? maybe-tok |token.)|)
                  (expect re autosemi? maybe-tok |token.)|))
              x))

      (let ((start-pos (macro-readenv-filepos re)))
        (if (or (eq? tok 'function) (six-type? re tok))
            (read-definition-or-expression-or-clause
             re
             autosemi?
             (if (eq? tok 'function)
                 #f
                 tok)
             start-pos
             #f
             #f
             check-closing)
            (read-expression-or-clause
             re
             autosemi?
             tok
             start-pos
             #f
             #f
             check-closing)))))

  (define (read-expression-or-clause
           re
           autosemi?
           maybe-tok
           start-pos
           restriction
           terminated?
           cont)
    (read-expression
     re
     autosemi?
     maybe-tok
     max-precedence
     restriction
     (if terminated?
         (lambda (re maybe-tok expr)
           (let ((tok
                  (get-token re autosemi? maybe-tok)))
             (if (eq? tok |token..|)
                 (cont re
                       #f
                       (##wrap-op1 re
                                   start-pos
                                   'six.clause
                                   expr))
                 (cont re
                       (expect re autosemi? tok |token.;|)
                       expr))))
         cont)))

  (define (read-definition-or-expression-or-clause
           re
           autosemi?
           type
           start-pos
           restriction
           terminated?
           cont)
    (let ((tok (get-token-no-autosemi re #f)))
      (if (eq? tok |token.(|)
          (read-expression-or-clause
           re
           autosemi?
           (cons type #f) ;; special combined token
           start-pos
           restriction
           terminated?
           cont)
          (read-identifier-or-backslash
           re
           tok
           #f
           (lambda (re maybe-tok identifier)
             (read-definition
              re
              autosemi?
              #f
              terminated?
              start-pos
              type
              identifier
              cont))))))

  (define (read-identifier-or-backslash re maybe-tok accept-type? cont)
    (let* ((tok
            (get-token-no-autosemi re maybe-tok))
           (start-pos
            (macro-readenv-filepos re)))
      (cond ((eq? tok |token.\\|)
             (read-backslash
              re
              start-pos
              cont))
            ((or (not (symbol? tok))
                 (and (not accept-type?)
                      (six-type? re tok)))
             (invalid-infix-syntax re)
             (cont re
                   tok
                   (##wrap-op0 re
                               start-pos
                               'error)))
            (else
             (cont re
                   #f
                   (wrap-identifier re start-pos tok))))))

  (define (wrap-identifier re start-pos tok)
    (let ((identifier (macro-readenv-wrap re tok)))
      (##wrap-op1 re
                  start-pos
                  'six.identifier
                  identifier)))

  (define (read-backslash re start-pos cont)
    (cont re
          #f
          (##read-datum-or-label re)))

  (define (read-backquote re start-pos cont)
    (cont re
          #f
          (##build-read-macro
           re
           start-pos
           start-pos
           (macro-readtable-quasiquote-keyword
            (macro-readenv-readtable re)))))

  (define (read-sharp re start-pos cont)
    (cont re
          #f
          (##read-sharp-aux re start-pos)))

  (define (statement-starter? re tok)
    ;; this function must be kept in sync with "read-statement"
    (or (eq? tok |token.{|)
        (eq? tok |token.;|)
        (eq? tok |token.;-auto|)
        (six-type? re tok)
        (expression-starter? re tok)))

  (define (get-token-unless-whitespace-to-eol re maybe-tok)
    (if (and (eq? maybe-tok |token.;-auto|)
             (not (whitespace-to-eol? re)))
        (get-token re #f #f)
        maybe-tok))

  (define (whitespace-to-eol? re)
    (let loop ()
      (let ((c (macro-peek-next-char-or-eof re)))
        (cond ((or (not (char? c)) (char=? c #\newline))
               #t)
              ((eq? (##readtable-char-handler (macro-readenv-readtable re) c)
                    ##read-whitespace)
               (macro-read-next-char-or-eof re) ;; skip whitespace character
               (loop))
              (else
               #f)))))

  (define (read-statement re autosemi? maybe-tok cont)
    (let* ((tok
            (get-token-no-autosemi re maybe-tok))
           (start-pos
            (macro-readenv-filepos re)))
      (cond ((eq? tok |token.{|)
             (read-compound-statement
              re
              #f
              start-pos
              'six.compound
              cont))
            ((eq? tok 'if)
             (read-paren-expression
              re
              #t ;; get token after close paren
              #f
              (lambda (re maybe-tok expr)
                (read-statement
                 re
                 autosemi?
                 maybe-tok
                 (lambda (re maybe-tok stat1)

                   (define (one-armed-if maybe-tok)
                     (cont re
                           maybe-tok
                           (##wrap-op2 re
                                       start-pos
                                       'six.if
                                       expr
                                       stat1)))

                   (if autosemi?
                       (one-armed-if maybe-tok)
                       (let ((tok
                              (get-token re autosemi? maybe-tok)))
                         (if (eq? tok 'else)
                             (read-statement
                              re
                              autosemi?
                              #f
                              (lambda (re maybe-tok stat2)
                                (cont re
                                      maybe-tok
                                      (##wrap-op3 re
                                                  start-pos
                                                  'six.if
                                                  expr
                                                  stat1
                                                  stat2))))
                             (one-armed-if tok)))))))))
            ((eq? tok 'while)
             (read-paren-expression
              re
              #t ;; get token after close paren
              #f
              (lambda (re maybe-tok expr)
                (read-statement
                 re
                 autosemi?
                 maybe-tok
                 (lambda (re maybe-tok stat)
                   (cont re
                         maybe-tok
                         (##wrap-op2 re
                                     start-pos
                                     'six.while
                                     expr
                                     stat)))))))
            ((eq? tok 'do)
             (read-statement
              re
              (let ((autosemi? #f)) ;; semicolons significant in do-while body
                autosemi?)
              (get-token-no-autosemi re #f)
              (lambda (re maybe-tok stat)
                (read-paren-expression
                 re
                 #f ;; don't get token after close paren
                 (expect-no-autosemi re maybe-tok 'while)
                 (lambda (re maybe-tok expr)
                   (cont re
                         (expect re autosemi? maybe-tok |token.;|)
                         (##wrap-op2 re
                                     start-pos
                                     'six.do-while
                                     stat
                                     expr)))))))
            ((eq? tok 'for)
             (let ((autosemi2? #f)) ;; require semicolons from "(" to after ")"

               (define (get-stat1 re autosemi? maybe-tok)
                 (read-statement
                  re
                  autosemi2?
                  (expect re autosemi2? maybe-tok |token.(|)
                  (lambda (re maybe-tok stat1)
                    (get-expr2 re
                               autosemi?
                               maybe-tok
                               stat1))))

               (define (get-expr2 re autosemi? maybe-tok stat1)
                 (let ((tok
                        (get-token re autosemi2? maybe-tok)))
                   (if (expression-starter? re tok)
                       (read-expression
                        re
                        autosemi2?
                        tok
                        max-precedence
                        #f
                        (lambda (re maybe-tok expr2)
                          (get-expr3 re
                                     autosemi?
                                     maybe-tok
                                     stat1
                                     expr2)))
                       (get-expr3 re
                                  autosemi?
                                  tok
                                  stat1
                                  (##wrap re start-pos #f)))))

               (define (get-expr3 re autosemi? maybe-tok stat1 expr2)
                 (let ((tok
                        (expect-and-get-token re autosemi2? maybe-tok |token.;|)))
                   (if (expression-starter? re tok)
                       (read-expression
                        re
                        autosemi2?
                        tok
                        max-precedence
                        #f
                        (lambda (re maybe-tok expr3)
                          (get-body re
                                    autosemi?
                                    maybe-tok
                                    stat1
                                    expr2
                                    expr3)))
                       (get-body re
                                 autosemi?
                                 tok
                                 stat1
                                 expr2
                                 (##wrap re start-pos #f)))))

               (define (get-body re autosemi? maybe-tok stat1 expr2 expr3)
                 (read-statement
                  re
                  autosemi? ;; use initial autosemi?
                  (expect-and-get-token re autosemi2? maybe-tok |token.)|)
                  (lambda (re maybe-tok stat)
                    (cont re
                          maybe-tok
                          (##wrap-op4 re
                                      start-pos
                                      'six.for
                                      stat1
                                      expr2
                                      expr3
                                      stat)))))

               (get-stat1 re
                          autosemi?
                          #f)))
            ((eq? tok 'switch)
             (read-paren-expression
              re
              #t ;; get token after close paren
              #f
              (lambda (re maybe-tok expr)
                (read-statement
                 re
                 autosemi?
                 maybe-tok
                 (lambda (re maybe-tok stat)
                   (cont re
                         maybe-tok
                         (##wrap-op2 re
                                     start-pos
                                     'six.switch
                                     expr
                                     stat)))))))
            ((eq? tok 'break)
             (cont re
                   (expect re autosemi? #f |token.;|)
                   (##wrap-op0 re
                               start-pos
                               'six.break)))
            ((eq? tok 'continue)
             (cont re
                   (expect re autosemi? #f |token.;|)
                   (##wrap-op0 re
                               start-pos
                               'six.continue)))
            ((eq? tok 'return)
             (let ((tok
                    (get-token-no-autosemi re #f)))
               (if (expression-starter? re tok)
                   (read-expression
                    re
                    autosemi?
                    tok
                    max-precedence
                    #f
                    (lambda (re maybe-tok expr)
                      (cont re
                            (expect re autosemi? maybe-tok |token.;|)
                            (##wrap-op1 re
                                        start-pos
                                        'six.return
                                        expr))))
                   (cont re
                         (expect re autosemi? tok |token.;|)
                         (##wrap-op0 re
                                     start-pos
                                     'six.return)))))
            ((eq? tok 'goto)
             (read-expression
              re
              autosemi?
              #f
              max-precedence
              #f
              (lambda (re maybe-tok expr)
                (cont re
                      (expect re autosemi? maybe-tok |token.;|)
                      (##wrap-op1 re
                                  start-pos
                                  'six.goto
                                  expr)))))
            ((eq? tok 'case)
             (read-expression
              re
              (let ((autosemi? #f)) ;; allow whitespace
                autosemi?)
              #f
              max-precedence
              'no-colon
              (lambda (re maybe-tok expr)
                (read-statement
                 re
                 autosemi?
                 (expect-no-autosemi re maybe-tok |op.:|)
                 (lambda (re maybe-tok stat)
                   (cont re
                         maybe-tok
                         (##wrap-op2 re
                                     start-pos
                                     'six.case
                                     expr
                                     stat)))))))
            ((eq? tok 'import)
             (read-imports re
                           autosemi?
                           start-pos
                           #f
                           (lambda (re maybe-tok imports)
                             (cont re
                                   (expect re autosemi? maybe-tok |token.;|)
                                   (##wrap-op re
                                              start-pos
                                              'six.import
                                              imports)))))
            ((eq? tok 'from)
             (read-expression
              re
              #t ;; autosemi? = #t will cause end of expression at space
              #f
              max-precedence
              'no-comma ;; forbid comma for consistency with import statement
              (lambda (re maybe-tok expr1)
                (let* ((maybe-tok
                        (get-token-unless-whitespace-to-eol re maybe-tok))
                       (tok2
                        (expect-and-get-token re #f maybe-tok 'import)))
                  (if (eq? tok2 op.*)
                      (cont re
                            (expect re autosemi? #f |token.;|)
                            (##wrap-op1 re
                                        start-pos
                                        'six.from-import-*
                                        expr1))
                      (read-imports re
                                    autosemi?
                                    start-pos
                                    tok2
                                    (lambda (re maybe-tok imports)
                                      (cont re
                                            (expect re autosemi? maybe-tok |token.;|)
                                            (##wrap-op re
                                                       start-pos
                                                       'six.from-import
                                                       (cons expr1 imports))))))))))
            ((or (eq? tok |token.;|) (eq? tok |token.;-auto|))
             (cont re
                   #f
                   (##wrap-op0 re
                               start-pos
                               'six.compound)))
            ((or (eq? tok 'function) (six-type? re tok))
             (read-definition-or-expression-or-clause
              re
              autosemi?
              (if (eq? tok 'function)
                  #f
                  tok)
              start-pos
              'no-colon
              #t
              cont))
            ((and (symbol? tok)
                  (not (eq? tok 'new)))
             (let* ((identifier
                     (macro-readenv-wrap re tok))
                    (tok
                     (get-token re autosemi? #f)))
               (if (eq? tok |op.:|)
                   (read-statement
                    re
                    autosemi?
                    #f
                    (lambda (re maybe-tok stat)
                      (cont re
                            maybe-tok
                            (##wrap-op2 re
                                        start-pos
                                        'six.label
                                        identifier
                                        stat))))
                   (read-expression-or-clause
                    re
                    autosemi?
                    (cons ;; special combined token
                     (##wrap-op1 re
                                 start-pos
                                 'six.identifier
                                 identifier)
                     tok)
                    start-pos
                    'no-colon
                    #t
                    cont))))
            (else
             (read-expression-or-clause
              re
              autosemi?
              tok
              start-pos
              'no-colon
              #t
              cont)))))

  (define (read-definition re autosemi? maybe-tok terminated? start-pos type identifier cont)

    (define (get-dimensions re autosemi? maybe-tok rev-dims)
      (let ((tok (get-token re autosemi? maybe-tok)))
        (cond ((eq? tok |token.[|)
               (read-expression
                re
                (let ((autosemi? #f)) ;; allow whitespace
                  autosemi?)
                #f
                max-precedence
                #f
                (lambda (re maybe-tok dim)
                  (get-dimensions re
                                  autosemi?
                                  (expect re autosemi? maybe-tok |token.]|)
                                  (cons dim rev-dims)))))
              ((eq? tok op.=)
               (read-expression
                re
                autosemi?
                #f
                max-precedence
                #f
                (lambda (re maybe-tok init)
                  (get-tail re
                            autosemi?
                            maybe-tok
                            rev-dims
                            init))))
              (else
               (get-tail re
                         autosemi?
                         tok
                         rev-dims
                         (##wrap re start-pos #f))))))

    (define (get-tail re autosemi? maybe-tok rev-dims init)
      (cont re
            (if terminated?
                (expect re autosemi? maybe-tok |token.;|)
                maybe-tok)
            (##wrap-op4 re
                        start-pos
                        'six.define-variable
                        identifier
                        type
                        (##wrap re start-pos (reverse rev-dims))
                        init)))

    (let ((tok (get-token re autosemi? maybe-tok)))
      (if (or (eq? tok |token.(|)
              (not type)) ;; type = #f for the syntax "function f(..."
          (read-procedure
           re
           (expect-no-autosemi re tok |token.(|)
           start-pos
           type
           (lambda (re maybe-tok proc)
             (cont re
                   maybe-tok
                   (##wrap-op2 re
                               start-pos
                               'six.define-procedure
                               identifier
                               proc))))
          (get-dimensions re
                          autosemi?
                          tok
                          '()))))

  (define (read-procedure re maybe-tok start-pos type cont)
    (let* ((tok
            (get-token-no-autosemi re maybe-tok))
           (params-start-pos
            (macro-readenv-filepos re)))

      (define (get-body re maybe-tok rev-params)
        (read-compound-statement
         re
         (expect-no-autosemi re maybe-tok |token.{|)
         start-pos
         'six.procedure-body
         (lambda (re maybe-tok stat)
           (cont re
                 maybe-tok
                 (##wrap-op3 re
                             start-pos
                             'six.procedure
                             type
                             (##wrap re params-start-pos (reverse rev-params))
                             stat)))))

      (define (end re tok rev-params)
        (get-body re
                  (expect-no-autosemi re tok |token.)|)
                  rev-params))

      (define (possibly-typed-argument tok rev-params)
        (let* ((type (and (six-type? re tok) tok))
               (tok (if type (get-token-no-autosemi re #f) tok)))
          (read-identifier-or-backslash
           re
           tok
           #f
           (lambda (re maybe-tok identifier)
             (let* ((new-rev-params
                     (cons (macro-readenv-wrap re (list identifier type))
                           rev-params))
                    (tok
                     (get-token-no-autosemi re maybe-tok)))
               (if (eq? tok |op.,|)
                   (possibly-typed-argument (get-token-no-autosemi re #f)
                                            new-rev-params)
                   (end re tok new-rev-params)))))))

      (if (eq? tok |token.)|)
          (end re tok '())
          (possibly-typed-argument tok '()))))

  (define (read-compound-statement re maybe-tok start-pos kind cont)
    (read-statements-tail
     re
     maybe-tok
     start-pos
     '()
     (lambda (re maybe-tok stats)
       (cont re
             maybe-tok
             (##wrap-op re
                        start-pos
                        kind
                        stats)))))

  (define (read-statements-tail re maybe-tok start-pos rev-stats cont)
    (let* ((autosemi? #f) ;; in {...} explicit semicolons are required
           (tok (get-token-no-autosemi re maybe-tok)))
      (if (statement-starter? re tok)
          (read-statement
           re
           autosemi?
           tok
           (lambda (re maybe-tok stat)
             (read-statements-tail
              re
              maybe-tok
              start-pos
              (cons stat rev-stats)
              cont)))
          (cont re
                (expect re autosemi? tok |token.}|)
                (reverse rev-stats)))))

  (define (invalid-infix-syntax re)
    (##raise-datum-parsing-exception
     'invalid-infix-syntax
     re))

  (define (invalid-infix-syntax-character re)
    (##raise-datum-parsing-exception
     'invalid-infix-syntax-character
     re))

  (define (invalid-infix-syntax-number re)
    (##raise-datum-parsing-exception
     'invalid-infix-syntax-number
     re))

  (define (six-type? re tok)
    ((macro-readtable-six-type? (macro-readenv-readtable re)) tok))

  #;
  (define (next-non-whitespace re)
    (let loop ()
      (let ((c (macro-peek-next-char-or-eof re)))
        (if (and (char? c)
                 (eq? (##readtable-char-handler (macro-readenv-readtable re) c)
                      ##read-whitespace))
            (begin
              (macro-read-next-char-or-eof re) ;; skip whitespace character
              (loop))
            c))))

  (let ((tok (get-token-no-autosemi re #f)))
    (cond ((and allow-eof?
                (eq? tok (##none-marker))
                (not (char? (macro-peek-next-char-or-eof re))))
           (macro-read-next-char-or-eof re) ;; make sure reader progresses
           #!eof) ;; end-of-file was reached so return end-of-file object
          ((eq? tok (##script-marker))
           tok)
          (else
           (read-statement
            re
            autosemi?
            tok
            (lambda (re maybe-tok expr)
              expr))))))

(define (##six-type? x)
  (assq x ##six-types))

(define ##six-types
  '((scmobj . #f)))

(define-prim (##six-types-set! x)
  (set! ##six-types x))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Setup the standard readtable.

(define (##make-standard-readtable #!optional (r7rs-syntax? #t))
  (let ((rt
         (macro-make-readtable
          #f ;; preserve case in symbols, character names, etc
          #t ;; keywords ending with ":" are allowed
          ##standard-escaped-char-table
          (if r7rs-syntax?
              ##standard-named-char-table
              (##cddr ##standard-named-char-table))
          ##standard-sharp-bang-table
          (##make-chartable #f) ;; all chars are non-delimiters
          (##make-chartable ##read-number/keyword/symbol)
          (##make-chartable ##read-sharp-other)
          #f                 ;; max-unescaped-char
          #t                 ;; escape-ctrl-chars?
          'default           ;; sharing-allowed?
          #f                 ;; eval-allowed?
          #f                 ;; write-extended-read-macros?
          #f                 ;; write-cdr-read-macros?
          ##max-fixnum       ;; max-write-level
          ##max-fixnum       ;; max-write-length
          ##standard-pretty-print-formats
          'quote             ;; quote-keyword
          'quasiquote        ;; quasiquote-keyword
          'unquote           ;; unquote-keyword
          'unquote-splicing  ;; unquote-splicing-keyword
          'syntax            ;; sharp-quote-keyword
          'quasisyntax       ;; sharp-quasiquote-keyword
          'unsyntax          ;; sharp-unquote-keyword
          'unsyntax-splicing ;; sharp-unquote-splicing-keyword
          'serial-number->object ;; sharp-num-keyword
          'repl-result-history-ref ;; sharp-seq-keyword
          #f                 ;; paren-handler
          #f                 ;; bracket-handler
          #f                 ;; brace-handler
          #f                 ;; angle-handler
          #f                 ;; start-syntax
          ##six-type?        ;; six-type?
          #t                 ;; r6rs-compatible-read?
          #t                 ;; r6rs-compatible-write?
          r7rs-syntax?       ;; r7rs-compatible-read?
          r7rs-syntax?       ;; r7rs-compatible-write?
          'multiline         ;; here-strings-allowed?
          #t                 ;; dot-at-head-of-list-allowed?
          #f                 ;; comment-handler
          #f                 ;; foreign-write-handler-table
          )))

    (##readtable-setup-for-standard-level! rt)

    ;; setup control characters

    (let loop ((i 31))
      (if (not (< i 0))
          (begin
            (##readtable-char-class-set!
             rt
             (UCS-4->character i)
             #t
             ##read-illegal)
            (loop (- i 1)))))

    ;; setup whitespace characters

    (##readtable-char-class-set! rt #\space    #t ##read-whitespace)
    (##readtable-char-class-set! rt #\linefeed #t ##read-whitespace)
    (##readtable-char-class-set! rt #\return   #t ##read-whitespace)
    (##readtable-char-class-set! rt #\tab      #t ##read-whitespace)
    (##readtable-char-class-set! rt #\page     #t ##read-whitespace)

    ;; setup handlers for non-whitespace delimiters

    (##readtable-char-class-set! rt #\; #t ##read-single-line-comment)

    (##readtable-char-class-set! rt #\" #t ##read-escaped-string)
    (##readtable-char-class-set! rt #\| #t ##read-number/keyword/symbol)

    (##readtable-char-class-set! rt #\' #t ##read-quotation)
    (##readtable-char-class-set! rt #\` #t ##read-quotation)
    (##readtable-char-class-set! rt #\, #t ##read-quotation)

    (##readtable-char-class-set! rt #\( #t ##read-list)
    (##readtable-char-class-set! rt #\) #t ##read-none)

    (##readtable-char-class-set! rt #\[ #t ##read-vector-or-list)
    (##readtable-char-class-set! rt #\] #t ##read-none)

    (##readtable-char-class-set! rt #\{ #t ##read-other)
    (##readtable-char-class-set! rt #\} #t ##read-none)

    (##readtable-char-class-set! rt #\\ #t ##read-six)

    ;; setup handlers for "#" and "." (these are NOT delimiters)

    (##readtable-char-class-set! rt #\# #f ##read-sharp)
    (##readtable-char-class-set! rt #\. #f ##read-dot)

    ;; setup handlers for sharp read-macros

    (let loop ((i 57))
      (if (not (< i 48))
          (begin
            (##readtable-char-sharp-handler-set!
             rt
             (UCS-4->character i)
             ##read-sharp-digit)
            (loop (- i 1)))))

    (##readtable-char-sharp-handler-set! rt #\( ##read-sharp-vector)
    (##readtable-char-sharp-handler-set! rt #\\ ##read-sharp-char)
    (##readtable-char-sharp-handler-set! rt #\| ##read-sharp-comment)
    (##readtable-char-sharp-handler-set! rt #\! ##read-sharp-bang)
    (##readtable-char-sharp-handler-set! rt #\# ##read-sharp-keyword/symbol)
    (##readtable-char-sharp-handler-set! rt #\% ##read-sharp-keyword/symbol)
    (##readtable-char-sharp-handler-set! rt #\: ##read-sharp-colon)
    (##readtable-char-sharp-handler-set! rt #\; ##read-sharp-semicolon)
    (##readtable-char-sharp-handler-set! rt #\' ##read-sharp-quotation)
    (##readtable-char-sharp-handler-set! rt #\` ##read-sharp-quotation)
    (##readtable-char-sharp-handler-set! rt #\, ##read-sharp-quotation)
    (##readtable-char-sharp-handler-set! rt #\& ##read-sharp-ampersand)
    (##readtable-char-sharp-handler-set! rt #\< ##read-sharp-less)

    (cond-expand
     (enable-sharp-dot
      (##readtable-char-sharp-handler-set! rt #\. ##read-sharp-dot))
     (else
      #f))

    rt))

;;;----------------------------------------------------------------------------

(define ##main-readtable
  (let ((rt (##make-standard-readtable)))

    (macro-case-target

     ((C)
      ;; Setup readtable according to program's script line.
      (let* ((program-script-line
              (##vector-ref ##program-descr 2))
             (language-and-tail
              (##extract-language-and-tail program-script-line)))
        (if language-and-tail
            (let ((language (##car language-and-tail)))
              (##readtable-setup-for-language! rt language)
              (##main-set! (##start-main language))))))

     (else))

    rt))

(define-prim (##main-readtable-set! x)
  (set! ##main-readtable x))

(define main ;; predefine main procedure so scripts don't have to
  (##first-argument
   (lambda args 0)))

(define-prim (##start-main language)

  (define (call-main args)
    (##apply-with-procedure-check main args))

  (cond ((macro-language-srfi-22? language)
         (lambda ()
           (let ((status (call-main (##list (##command-args)))))
             (if (##fixnum? status)
                 (##exit status)
                 (##exit-abruptly)))))
        (else
         (lambda ()
           (call-main (##command-args))
           (##exit)))))

;;;============================================================================
