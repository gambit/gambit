;;;============================================================================

;;; File: "repl-server.scm"

;;; Copyright (c) 2011-2012 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("repl-server#"))

(##include "~~lib/gambit#.scm")

(##include "repl-server#.scm")

(declare
 (standard-bindings)
 (extended-bindings)
 (block)
 (fixnum)
 ;;(not safe)
)


;;;============================================================================

;; REPL server which can be contacted via telnet on port 7000.

(define (ide-repl-pump ide-repl-connection in-port out-port tgroup)

  (define m (make-mutex))

  (define (process-input)
    (let loop ((state 'normal))
      (let ((c (read-char ide-repl-connection)))
        (if (not (eof-object? c))
            (case state
              ((normal)
               (if (char=? c #\xff) ;; telnet IAC (interpret as command) code?
                   (loop c)
                   (begin
                     (mutex-lock! m)
                     (if (char=? c #\x04) ;; ctrl-d ?
                         (close-output-port out-port)
                         (begin
                           (write-char c out-port)
                           (force-output out-port)))
                     (mutex-unlock! m)
                     (loop state))))
              ((#\xfb) ;; after WILL command?
               (loop 'normal))
              ((#\xfc) ;; after WONT command?
               (loop 'normal))
              ((#\xfd) ;; after DO command?
               (if (char=? c #\x06) ;; timing-mark option?
                   (begin ;; send back WILL timing-mark
                     (mutex-lock! m)
                     (write-char #\xff ide-repl-connection)
                     (write-char #\xfb ide-repl-connection)
                     (write-char #\x06 ide-repl-connection)
                     (force-output ide-repl-connection)
                     (mutex-unlock! m)))
               (loop 'normal))
              ((#\xfe) ;; after DONT command?
               (loop 'normal))
              ((#\xff) ;; after IAC command?
               (case c
                 ((#\xf4) ;; telnet IP (interrupt process) command?
                  (for-each
                   ##thread-interrupt!
                   (thread-group->thread-list tgroup))
                  (loop 'normal))
                 ((#\xfb #\xfc #\xfd #\xfe) ;; telnet WILL/WONT/DO/DONT command?
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

  (let ((tgroup (make-thread-group 'repl-pump #f)))

    (define (start thunk)
      (thread-start! (make-thread
                      (lambda ()
                        (with-exception-catcher
                         (lambda (e)
                           #f)
                         thunk))
                      #f
                      tgroup)))

    (start process-input)
    (start process-output)))

(define (make-ide-repl-ports ide-repl-connection tgroup)
  (receive (in-rd-port in-wr-port) (open-string-pipe '(direction: input permanent-close: #f))
    (receive (out-wr-port out-rd-port) (open-string-pipe '(direction: output))
      (begin

        ;; Hack... set the names of the ports for usage with gambit.el
        (##vector-set! in-rd-port 4 (lambda (port) '(stdin)))
        (##vector-set! out-wr-port 4 (lambda (port) '(stdout)))

        (ide-repl-pump ide-repl-connection out-rd-port in-wr-port tgroup)
        (values in-rd-port out-wr-port)))))

(define repl-channel-table (make-table test: eq?))

(set! ##thread-make-repl-channel
      (lambda (thread)
        (let ((tgroup (thread-thread-group thread)))
          (or (table-ref repl-channel-table tgroup #f)
              (##default-thread-make-repl-channel thread)))))

(define (setup-ide-repl-channel ide-repl-connection tgroup)
  (receive (in-port out-port) (make-ide-repl-ports ide-repl-connection tgroup)
    (let ((repl-channel (##make-repl-channel-ports in-port out-port)))
      (table-set! repl-channel-table tgroup repl-channel))))

(define repl-server-address #f)
(set! repl-server-address "*:7000")

(define (repl-server password)
  (let ((server
         (open-tcp-server
          (list server-address: repl-server-address
                eol-encoding: 'cr-lf
                reuse-address: #t))))
    (let loop1 ()
      (let* ((ide-repl-connection
              (read server))
             (tgroup
              (make-thread-group 'repl-service #f))
             (thread
              (make-thread
               (lambda ()
                 (setup-ide-repl-channel ide-repl-connection tgroup)
                 (if password
                     (let loop2 ()
                       (display "Password: " ide-repl-connection)
                       (force-output ide-repl-connection)
                       (let ((pw (read-line ide-repl-connection)))
                         (if (not (equal? pw password))
                             (loop2)))))
                 (##repl-debug-main))
               'repl
               tgroup)))
        (thread-start! thread)
        (loop1)))))

(define (repl-server-start password)
  (thread-start! (make-thread (lambda () (repl-server password))))
  (void))


;;;============================================================================
