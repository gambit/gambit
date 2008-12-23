#!/usr/bin/env gsi-script

; File: "web-repl.scm", Time-stamp: <2008-12-17 13:41:06 feeley>

; Copyright (c) 2004-2008 by Marc Feeley, All Rights Reserved.

(define primordial-thread (current-thread))

(define (ide-repl-pump ide-repl-connection in-port out-port)

  (define m (make-mutex))

  (define (process-input)
    (let loop ((state 'normal))
      (let ((c (read-char ide-repl-connection)))
        (if (not (eof-object? c))
            (case state
              ((normal)
               (if (char=? c #\xff) ; telnet IAC (interpret as command) code?
                   (loop c)
                   (begin
                     (mutex-lock! m)
                     (write-char c out-port)
                     (force-output out-port)
                     (mutex-unlock! m)
                     (loop state))))
              ((#\xfb) ; after WILL command?
               (loop 'normal))
              ((#\xfc) ; after WONT command?
               (loop 'normal))
              ((#\xfd) ; after DO command?
               (if (char=? c #\x06) ; timing-mark option?
                   (begin ; send back WILL timing-mark
                     (mutex-lock! m)
                     (write-char #\xff out-port)
                     (write-char #\xfb out-port)
                     (write-char #\x06 out-port)
                     (force-output out-port)
                     (mutex-unlock! m)))
               (loop 'normal))
              ((#\xfe) ; after DONT command?
               (loop 'normal))
              ((#\xff) ; after IAC command?
               (case c
                 ((#\xf4) ; telnet IP (interrupt process) command?
                  (##thread-interrupt!
                   primordial-thread
                   (lambda ()
                     ((##current-user-interrupt-handler))
                     (##void)))
                  (loop 'normal))
                 ((#\xfb #\xfc #\xfd #\xfe) ; telnet WILL/WONT/DO/DONT command?
                  (loop c))
                 (else
                  (loop 'normal))))
              (else
               (loop 'normal)))))))

  (define (process-output)
    (let loop ()
      (let ((c (read-char in-port)))
        (if (not (eof-object? c))
            (begin
              (mutex-lock! m)
              (write-char c ide-repl-connection)
              (force-output ide-repl-connection)
              (mutex-unlock! m)
              (loop))))))

  (thread-start! (make-thread process-input))
  (thread-start! (make-thread process-output)))

(define (make-ide-repl-ports ide-repl-connection)
  (receive (in-rd-port in-wr-port) (open-string-pipe '(direction: input))
    (receive (out-wr-port out-rd-port) (open-string-pipe '(direction: output))
      (begin

        ; Hack... set the names of the ports for usage with gambit.el
        (##vector-set! in-rd-port 4 (lambda (port) '(stdin)))
        (##vector-set! out-wr-port 4 (lambda (port) '(stdout)))

        (ide-repl-pump ide-repl-connection out-rd-port in-wr-port)
        (values in-rd-port out-wr-port)))))

(define (setup-ide-repl-channel ide-repl-connection)
  (receive (in-port out-port) (make-ide-repl-ports ide-repl-connection)
    (let ((repl-channel (##make-repl-channel-ports in-port out-port)))
      (set! ##thread-make-repl-channel (lambda (thread) repl-channel)))))

(define (start-ide-repl)
  (##repl-debug-main))

(define (start-ide-repl-in-new-thread)
  (thread-start! (make-thread start-ide-repl)))

(define repl-server-port 7000)

(define (start-repl-server)
  (let ((server
         (open-tcp-server
          (list port-number: repl-server-port
                reuse-address: #t))))
    (let loop ()
      (let ((ide-repl-connection (read server)))
        (setup-ide-repl-channel ide-repl-connection)
        (start-ide-repl)
;        (start-ide-repl-in-new-thread)
        (loop)))))

(start-repl-server)
