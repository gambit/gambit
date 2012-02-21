#! /usr/bin/env gsi

;;;============================================================================

;;; File: "grd.scm"

;;; Copyright (c) 2011-2012 by Marc Feeley, All Rights Reserved.

;; This program allows remote interaction with the "Gambit REPL dev"
;; app for iOS devices.  The "Gambit REPL dev" app must have started a
;; REPL server with the command:
;;
;;  (repl-server #f)

;;;============================================================================

(##include "digest.scm")
(##include "genport.scm")
(##include "zlib.scm")
(##include "tar.scm")

;;-----------------------------------------------------------------------------

(##namespace (""))

(##include "~~lib/gambit#.scm")

(##include "digest#.scm")
(##include "genport#.scm")
(##include "zlib#.scm")
(##include "tar#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (generic)
  (safe)
)

;;-----------------------------------------------------------------------------

(define REPL-server-port-num 7000)

;;-----------------------------------------------------------------------------

(define usage #<<EOF
This program implements several commands:

 grd scan                        list the Gambit REPL apps on the LAN
 grd pwd                         get current directory
 grd cd <remote_dir>             change current directory
 grd ls [<remote_dir>]           list files in directory
 grd mkdir <remote_dir>          create directory
 grd rm <remote_file>            remove file or dir
 grd mv <rem_file1> <rem_file2>  remove file or dir
 grd eval <expr>                 evaluate expression
 grd load <remote_file>          load file
 grd push <local_file>           copy local file or dir to iOS device
 grd pull <remote_file>          copy remote file or dir locally
 grd add-script <local_file>     add a script to iOS device

A specific "Gambit REPL dev" can be chosen by doing a "scan" or by
using the option "-addr host:port".  For example:

 % ./grd scan
 192.168.0.100:7000 mega.local
 192.168.0.101:7000 My-iPhone
 % ./grd eval "(host-name)"
 "My-iPhone"
 % ./grd -addr 192.168.0.100:7000 eval "(host-name)"
 "mega.local"
 % ./grd eval "(host-name)"
 "mega.local"

EOF
)

;;-----------------------------------------------------------------------------

;; Exception related utilities

(define-macro (without-exception expr)
  `(with-exception-catcher
    (lambda (e) #f)
    (lambda () ,expr)))

(define-macro (try-catch expr catch)
  `(with-exception-catcher
    ,catch
    (lambda () ,expr)))

(define-macro (try-finally expr final)
  (let ((f (gensym)) (r (gensym)))
    `(let* ((,f (lambda () ,final))
            (,r (with-exception-catcher
                 (lambda (e) (,f) (raise e))
                 (lambda () ,expr))))
       (,f)
       ,r)))

;;-----------------------------------------------------------------------------

;; Thread related utilities

(define lock mutex-lock!)
(define unlock mutex-unlock!)
(define signal condition-variable-signal!)

(define-macro (spawn expr)
  `(thread-start!
    (make-root-thread
     (lambda () ,expr))))

(define (halt)
  (thread-terminate! (current-thread)))

(define join thread-join!)
(define sleep thread-sleep!)

(define send thread-send)
(define recv thread-receive)

;;-----------------------------------------------------------------------------

;; General purpose utilities

(define (writeln obj #!optional (port (current-output-port)))
  (write obj port)
  (newline port)
  (force-output port))

(define (for lo hi proc)
  (if (>= lo hi)
      '()
      (let ((x (proc lo)))
        (cons x (for (+ lo 1) hi proc)))))

(define (pfor lo hi proc)
  (if (>= lo hi)
      '()
      (if (= lo (- hi 1))
          (list (proc lo))
          (let* ((mid (quotient (+ lo hi) 2))
                 (a (spawn (pfor lo mid proc)))
                 (b (pfor mid hi proc)))
            (append (join a) b)))))

(define (make-throttle concurrency-limit)
  (let ((m (make-mutex))
        (cv (make-condition-variable))
        (n concurrency-limit))

    (lambda (thunk)
      (let wait ()
        (lock m)
        (if (= n 0)
            (begin
              (unlock m cv) ;; wait on cv
              (wait))
            (begin
              (set! n (- n 1))
              (unlock m)
              (try-finally
               (thunk)
               (begin
                 (lock m)
                 (set! n (+ n 1))
                 (signal cv) ;; wake up next waiting thread
                 (unlock m)))))))))

;;-----------------------------------------------------------------------------

;; Networking related utilities

(define (ip->num ip)

  ;; (ip->num '#u8(127 0 0 1)) => 2130706433

  (do ((i 0 (+ i 1))
       (n 0 (+ (* 256 n) (u8vector-ref ip i))))
      ((= i 4) n)))

(define (num->ip num)

  ;; (num->ip 2130706433) => #u8(127 0 0 1)

  (let ((v (make-u8vector 4)))
    (do ((i 3 (- i 1))
         (n num (quotient n 256)))
        ((< i 0) v)
      (u8vector-set! v i (modulo n 256)))))

(define (self-local-ip)

  ;; (self-local-ip) => #u8(192 168 0 100)

  (let* ((port (open-tcp-client
                (list server-address: '#u8(73 125 226 48) ;; google.com
                      port-number: 443)))
         (_ (thread-sleep! 2))
         (ip (socket-info-address
              (tcp-client-self-socket-info port))))
    (close-port port)
    (or ip
        '#u8(192 168 0 100)))) ;; sometimes ip=#f on Windows

;;-----------------------------------------------------------------------------

(define (REPL-server-connect addr)
  (let ((port
         (without-exception
          (open-tcp-client
           (list server-address: addr
                 eol-encoding: 'cr-lf)))))
    (and port
         (try-catch
          (begin
            (input-port-timeout-set! port 2.0)
            (let ((header (read port)))
              (input-port-timeout-set! port +inf.0)
              (if (equal? header 'Gambit)
                  (list port addr)
                  (begin
                    (close-port port)
                    #f))))
          (lambda (e)
            (without-exception (close-port port))
            #f)))))

(define (REPL-server-disconnect conn)
  (with-exception-catcher
   (lambda (e)
     #f)
   (lambda ()
     (let ((port (car conn)))
       (display ",qt\n" port)
       (force-output port)
       (thread-sleep! 0.5)
       (close-port port)))))

(define (REPL-server-eval conn expr)
  (let ((port (car conn)))

    (write `(let ((result (with-exception-catcher (lambda (e) (vector 'exception-was-raised "\n" (with-output-to-string "" (lambda () (display-exception e))))) (lambda () ,expr)))) (display "\n***RESULT***\n") (write result) (newline)) port)
    (newline port)
    (force-output port)

    (let loop ()
      (let ((x (read-line port)))
        (if (string? x)
            (if (string=? x "***RESULT***")
                (let ((result (read port)))
                  (close-port port)
                  result)
                (loop))
            (vector 'exception-was-raised "\n" "REPL-server-eval failed"))))))

(define (make-addr ip port-num)
  (with-output-to-string
    ""
    (lambda ()
      (print (u8vector-ref ip 0)
             "."
             (u8vector-ref ip 1)
             "."
             (u8vector-ref ip 2)
             "."
             (u8vector-ref ip 3)
             ":"
             (number->string port-num)))))

(define (discover-local-REPL-servers ip port-num found)
  (let* ((nm #xfffffe00)
         (throttle (make-throttle 50)))
    (pfor 0
          (- #xffffffff nm)
          (lambda (i)
            (throttle
             (lambda ()
               (check-for-REPL-server
                (make-addr (num->ip (+ i (bitwise-and nm (ip->num ip))))
                           port-num)
                found)))))))

(define (check-for-REPL-server addr found)
  (let ((conn (REPL-server-connect addr)))
    (if conn
        (found conn))
    (sleep 0.5)))

(define (scan-local-REPL-servers)
  (discover-local-REPL-servers
   (self-local-ip)
   REPL-server-port-num
   (lambda (conn)
     (let* ((id (REPL-server-eval conn '(host-name)))
            (addr (cadr conn)))
       (print addr " " id "\n")
       (save-default-addr addr)
       (REPL-server-disconnect conn)))))

;;-----------------------------------------------------------------------------

(define (remote-eval addr expr)
  (let ((conn (REPL-server-connect addr)))
    (if (not conn)
        (error "remote-eval could not connect to" addr)
        (let ((result (REPL-server-eval conn expr)))
          (REPL-server-disconnect conn)
          result))))

;;-----------------------------------------------------------------------------

(define (grd-pwd #!key (addr (default-addr)))
  (remote-eval addr `(current-directory)))

(define (grd-cd path #!key (addr (default-addr)))
  (remote-eval addr `(current-directory ,path)))

(define (grd-ls path #!key (addr (default-addr)))
  (remote-eval addr `(directory-files ,path)))

(define (grd-mkdir path #!key (addr (default-addr)))
  (remote-eval addr `(tar#create-dir ,path)))

(define (grd-rm path #!key (addr (default-addr)))
  (remote-eval addr `(tar#delete-file-recursive ,path)))

(define (grd-mv path1 path2 #!key (addr (default-addr)))
  (remote-eval addr `(rename-file ,path1 ,path2)))

(define (grd-eval expr #!key (addr (default-addr)))
  (remote-eval addr expr))

(define (grd-load filename #!key (addr (default-addr)))
  (remote-eval addr `(load ,filename)))

(define (grd-push filename #!key (addr (default-addr)))
  (let ((u8vect (tar-pack-u8vector (tar-read filename) #t)))
    (pp `(sending ,(u8vector-length u8vect) bytes))
    (remote-eval addr `(tar#tar-write-unchecked
                        (tar#tar-unpack-u8vector ',u8vect #t)))))

(define (grd-pull filename #!key (addr (default-addr)))
  (let ((u8vect
         (remote-eval addr `(tar#tar-pack-u8vector
                             (tar#tar-read ,filename)
                             #t))))
    (pp `(received ,(u8vector-length u8vect) bytes))
    (tar-write-unchecked
     (tar-unpack-u8vector u8vect #t))))

(define (grd-add-script filename #!key (addr (default-addr)))
  (let ((script
         (call-with-input-file filename (lambda (port) (read-line port #f)))))
    (remote-eval addr `(let ((index (script#get-script-index-by-name ,filename)))
                         (and index (gr#delete-script-event index))
                         (script#add-script ,filename ,script)
                         (gr#set-edit-view)))))

;;-----------------------------------------------------------------------------

(define (default-addr)
  (with-input-from-file "~/.grd.ini" (lambda () (read-line))))

(define (save-default-addr addr)
  (with-output-to-file "~/.grd.ini" (lambda () (println addr))))

(define (main . args)

  (define addr #f)

  (let loop ((args args))
    (if (not (pair? args))
        (begin
          (print usage)
          (exit 1))
        (let ((op (car args)))

          (cond ((equal? op "-addr")
                 (if (not (pair? (cdr args)))
                     (error "address expected"))
                 (set! addr (cadr args))
                 (save-default-addr addr)
                 (loop (cddr args)))

                ((equal? op "-load")
                 (if (not (pair? (cdr args)))
                     (error "filename expected"))
                 (load (cadr args))
                 (loop (cddr args)))

                ((equal? op "scan")
                 (scan-local-REPL-servers))

                ((equal? op "pwd")
                 (println
                  (if addr
                      (grd-pwd addr: addr)
                      (grd-pwd))))

                ((equal? op "cd")
                 (if (not (pair? (cdr args)))
                     (error "path expected"))
                 (let ((path (cadr args)))
                   (println
                    (if addr
                        (grd-cd path addr: addr)
                        (grd-cd path)))))

                ((equal? op "ls")
                 (for-each
                  (lambda (path)
                    (let ((x (if addr
                                 (grd-ls path addr: addr)
                                 (grd-ls path))))
                      (if (list? x)
                          (for-each println x)
                          (println x))))
                  (if (pair? (cdr args)) (cdr args) '("."))))

                ((equal? op "mkdir")
                 (for-each
                  (lambda (path)
                    (println
                     (if addr
                         (grd-mkdir path addr: addr)
                         (grd-mkdir path))))
                  (cdr args)))

                ((equal? op "rm")
                 (for-each
                  (lambda (path)
                    (println
                     (if addr
                         (grd-rm path addr: addr)
                         (grd-rm path))))
                  (cdr args)))

                ((equal? op "mv")
                 (if (or (not (pair? (cdr args)))
                         (not (pair? (cddr args))))
                     (error "paths expected"))
                 (let ((path1 (cadr args))
                       (path2 (caddr args)))
                   (println
                    (if addr
                        (grd-mv path1 path2 addr: addr)
                        (grd-mv path1 path2)))))

                ((equal? op "eval")
                 (for-each
                  (lambda (str)
                    (let ((expr (with-input-from-string str read)))
                      (pretty-print
                       (if addr
                           (grd-eval expr addr: addr)
                           (grd-eval expr)))))
                  (cdr args)))

                ((equal? op "load")
                 (for-each
                  (lambda (filename)
                    (pretty-print
                     (if addr
                         (grd-load filename addr: addr)
                         (grd-load filename))))
                  (cdr args)))

                ((equal? op "push")
                 (for-each
                  (lambda (filename)
                    (if addr
                        (grd-push filename addr: addr)
                        (grd-push filename)))
                  (cdr args)))

                ((equal? op "pull")
                 (for-each
                  (lambda (filename)
                    (if addr
                        (grd-pull filename addr: addr)
                        (grd-pull filename)))
                  (cdr args)))

                ((equal? op "add-script")
                 (for-each
                  (lambda (filename)
                    (if addr
                        (grd-add-script filename addr: addr)
                        (grd-add-script filename)))
                  (cdr args)))

                (else
                 (error "unknown operation" op)))))))

;;;============================================================================
