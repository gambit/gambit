;; Copyright (C) 2005-2009 by Guillaume Germain, All Rights Reserved.
;; Copyright (C) 2005-2019 by FrédéricHamel, All Rights Reserved.
;; Copyright (C) 2020 by Marc Feeley, All Rights Reserved.
;; File: ~~lib/termite/termite.scm
(##supply-module termite)

(declare
  (standard-bindings)
  (extended-bindings)
  (not safe)
  (block))

;; this is the main file for the Termite system
(##namespace ("termite#"))

(##include "~~lib/gambit/prim/prim#.scm")
(##include "~~lib/_gambit#.scm")

(##include "termite#.scm")
(##import termite/utils)

;; ----------------------------------------------------------------------------
;; System configuration & global data

(define current-node (lambda () (error "uninitialized node")))

(define *global-mutex* ((let () (##namespace ("")) make-mutex) "global termite mutex"))

;; translation tables for "published" PIDs
(define *foreign->local* (make-table weak-values: #t))
(define *local->foreign* (make-table weak-keys: #t))
;; translation table for "published" tags
(define *uuid->tag* (make-table weak-values: #t))

;; Get the current time in seconds.
(define (now)
  (time->seconds
   (current-time)))

;; TODO Improve this
(define (formatted-current-time)
  (let* ((port ((let () (##namespace ("")) open-process) "date"))
     (time (read-line port)))
  (close-port port)
  time))

;; ----------------------------------------------------------------------------
;; Datatypes

(define (process? obj) ((let () (##namespace ("")) thread?) obj))
(define (process-links pid) ((let () (##namespace ("")) thread-specific) pid))
(define (process-links-set! pid obj) ((let () (##namespace ("")) thread-specific-set!) pid obj))

;; universal pid
(define-type upid
  id: 9e096e09-8c66-4058-bddb-e061f2209838
  tag
  node)

;; nodes
(define (make-node host port)
  (if (and (string? host) (number? port))
      (string-append host ":" (number->string port))
      (error "string and number expected:" host port)))

(define (node-host node)

  (define (err) (error "node expected:" node))

  (if (string? node)
      (let ((i (##string-contains node ":")))
        (if i
            (substring node 0 i)
            node))
      (err)))

(define (node-port node)

  (define (err) (error "node expected:" node))

  (if (string? node)
      (let ((i (##string-contains node ":")))
        (if i
            (or (string->number (substring node (+ i 1) (string-length node)))
                (err))
            0))
      (err)))

;; tags
(define-type tag
  id: efa4f5f8-c74c-465b-af93-720d44a08374
  (uuid init: #f))

;; proxy
(define-type proxy
  id: 1d0a2e32-ab57-4544-8c3f-2cf4af25f289
  upid)

;; proxy-callback
(define-type proxy-callback
  id: 01a2b160-0fe6-4cf0-911f-e76e085b1015
  thunk)

;; * Test whether 'obj' is a pid.
(define (pid? obj)
  (or (process? obj) (upid? obj)))


;; NOTE It might be better to integrate with Gambit's exception mechanism
(define-type termite-exception
  id: 6a3a285f-02c4-49ac-b00a-aa57b1ad02cf
  origin
  reason
  object)


;; ----------------------------------------------------------------------------
;; process manipulation primitives
(##include "process.scm")

;; ----------------------------------------------------------------------------
;; Sending messages

;; * Send a message 'msg' to 'pid'.  This means that the message will
;; be enqueued in the mailbox of the destination process.
;;
;; Delivery of the message is unreliable in theory, but in practice
;; local messages will always be delivered, and remote messages will
;; not be delivered only if the connection is currently broken to the
;; remote node, or if the remote node is down.
;;
;; Note that you will not get an error or an exception if the message
;; doesn't get there: you need to handle errors yourself.
(define (! to msg)
  (cond
  ((process? to)
   ((let () (##namespace ("")) thread-send) to msg))
  ((upid? to)
   ((let () (##namespace ("")) thread-send) dispatcher (list 'relay to msg)))
  (else
    (error "invalid-message-destination" to))))


;; ----------------------------------------------------------------------------
;; Receiving messages
;; ----------------------------------------------------------------------------
(##include "io.scm")

;; Links and exception handling

;; Default callback for received exceptions.
(define (handle-exception-message event)
  (raise event))

;; * Link another process 'pid' /to/ the current one: any exception
;; not being caught by the remote process and making it crash will be
;; propagated to the current process.
(define (inbound-link pid)
  (! linker (list 'link pid (self))))


;; * Link the current process /to/ another process 'pid': any
;; exception not being caught by the current process will be
;; propagated to the remote process.
(define (outbound-link pid)
  (let* ((links (process-links (self))))
  (if (not (memq pid links))
    (process-links-set! (self) (cons pid links)))))


;; * Link bidirectionally the current process with another process
;; 'pid': any exception not being caught in any of the two processes
;; will be propagated to the other one.
(define (full-link pid)
  (inbound-link  pid)
  (outbound-link pid))


;; ----------------------------------------------------------------------------
;; Termite I/O

;; Wraps 'pid's representing Gambit output ports.
(define-type termite-output-port
  id: b0c30401-474c-4e83-94b4-d516e00fe363
  unprintable:
  pid)

;; Wraps 'pid's representing Gambit input ports.
(define-type termite-input-port
  id: ebb22fcb-ca61-4765-9896-49e6716471c3
  unprintable:
  pid)

;; Start a process representing a Gambit output port.
(define (spawn-output-port port #!optional (serialize? #f))
  (output-port-readtable-set!
  port
  ((let () (##namespace ("")) readtable-sharing-allowed?-set)
    (output-port-readtable port)
    serialize?))

  (make-termite-output-port
  (spawn
    (lambda ()
    (let loop ()
      (recv
      (proc
        (where (procedure? proc))
        (proc port))
      (x (warning "unknown message sent to output port: " x)))
      (loop)))
      name: 'termite-output-port)))

;; Start a process representing a Gambit input port.
(define (spawn-input-port port #!optional (serialize? #f))
  (input-port-readtable-set!
  port
  ((let () (##namespace ("")) readtable-sharing-allowed?-set)
    (input-port-readtable port)
    serialize?))

  (make-termite-input-port
  (spawn
    (lambda ()
    (let loop ()
      (recv
      ((from token proc)
       (where (procedure? proc))
       (! from (list token (proc port))))
      (x (warning "unknown message sent to input port: " x)))
      (loop)))
      name: 'termite-input-port)))

;; IO parameterization
;; (define current-termite-input-port (make-parameter #f))
;; (define current-termite-output-port (make-parameter #f))

;; insert IO overrides
;; (include "termiteio.scm")


;; ----------------------------------------------------------------------------
;; Distribution

;; Convert a 'pid'
(define (pid->upid obj)
  ((let () (##namespace ("")) mutex-lock!) *global-mutex*)
  (cond
  ((table-ref *local->foreign* obj #f)
   => (lambda (x)
      ((let () (##namespace ("")) mutex-unlock!) *global-mutex*)
      x))
  (else
    (let ((upid (make-upid (make-uuid) (current-node))))
      (table-set! *local->foreign* obj upid)
      (table-set! *foreign->local* upid obj)
      ((let () (##namespace ("")) mutex-unlock!) *global-mutex*)
      upid))))

(define (tag->utag obj)
  ((let () (##namespace ("")) mutex-lock!) *global-mutex*)
  (cond
  ((tag-uuid obj)
   ((let () (##namespace ("")) mutex-unlock!) *global-mutex*)
   obj)
  (else
    (let ((uuid (make-uuid)))
    (tag-uuid-set! obj uuid)
    (table-set! *uuid->tag* uuid obj)
    ((let () (##namespace ("")) mutex-unlock!) *global-mutex*)
    obj))))

;; Some debuging info
(define proxy-counter 0)
(define proxy-request-counter 0)

;; Reset both counter
(define (proxy-reset-counter)
  (set! proxy-counter 0)
  (set! proxy-request-counter 0))

;; Print debugging info
(define (proxy-print-debugging-info)
  (println "---- PROXY INFO HEADER ----")
  (println "proxy-counter: " proxy-counter)
  (println "proxy-request-counter: " proxy-request-counter)
  (println "---------------------------"))

; Define a simple macro
(define-macro (macro-inc x)
  `(set! ,x (##+ ,x 1)))

;; Create a element proxy-thread
(define (make-element-proxy elem)
  (let ((proxy-thread
          (spawn
            (lambda ()
              (let loop ()
                (recv
                  ((from tag 'get)
                   (macro-inc proxy-request-counter)
                   (! from (list tag elem)))
                  ((from tag 'clean)
                   ;; Should clean
                   #f)
                  (msg
                    (warning "Ignore msg " msg)))
                (loop)))
            name: 'proxy)))
    (macro-inc proxy-counter)
    (pid->upid proxy-thread)))

;;;; NEW VERSION

(define (serialize-hook obj)
  (define (promise-result state)
    (##vector-ref state 0))

  (define (promise-thunk state)
    (##vector-ref state 1))

  (cond
    ;; Unpack promise instead of force
    ((##promise? obj)
     (begin
       (let* ((state (##promise-state obj))
              (result (promise-result state)))
         (if (##eq? state result)
           (make-proxy-callback (promise-thunk state))

           state))))

    ((proxy? obj)
     (let ((pid (proxy-upid obj)))
       (begin
         (proxy-upid-set! obj pid)
         obj)))

    ((process? obj)
     (pid->upid obj))

    ((tag? obj)
     (tag->utag obj))

    ; Identify builtin procedure.
    ;((procedure? obj)
    ; (let ((name (##procedure-name obj)))
    ;   (if (and name
    ;            (not (char=? (string-ref (symbol->string name) 1)
    ;                    #\#)))
    ;     obj
    ;     (if (or
    ;           (> len max-length)
    ;           (> depth max-depth))
    ;       (make-proxy (make-element-proxy obj))
    ;       obj))))

    ;; unserializable objects, so instead of crashing we set them to #f
    ((or (port? obj))
     #f)

    (else obj)))

(define (upid->pid obj)
  (cond
  ((table-ref *foreign->local* obj #f)
   => (lambda (pid) pid))
  ((and (symbol? (upid-tag obj))
      (resolve-service (upid-tag obj)))
   => (lambda (pid)
      pid))
  (else
    (error "don't know how to upid->pid"))))

(define (utag->tag obj)
  (let ((uuid (tag-uuid obj)))
  (cond
    ((table-ref *uuid->tag* uuid #f)
     => (lambda (tag) tag))
    (else obj))))

(define (deserialize-hook obj)
  (cond
    ((and (upid? obj)
          (equal? (upid-node obj)
                  (current-node)))
     (upid->pid obj))

    ((proxy-callback? obj)
     (##make-delay-promise (proxy-callback-thunk obj)))

    ((proxy? obj)
     (let ((p (proxy-upid obj)))
       (macro-if-auto-forcing
       (delay
         ; Timeout: 6min
         (!? p 'get 360 'relay))
       (!? p 'get 360 'relay))))

    ((tag? obj)
     (utag->tag obj))
    (else obj)))


(define (serialize obj port)
  (let* ((serialized-obj
            (object->u8vector obj serialize-hook))
     (len
       (u8vector-length serialized-obj))
     (serialized-len
       (u8vector (bitwise-and len #xff)
           (bitwise-and (arithmetic-shift len -8) #xff)
           (bitwise-and (arithmetic-shift len -16) #xff)
           (bitwise-and (arithmetic-shift len -24) #xff))))

  (begin
    (write-subu8vector serialized-len 0 4 port)
    (write-subu8vector serialized-obj 0 len port))))


(define (deserialize port)
  (let* ((serialized-len
       (u8vector 0 0 0 0))
     (n
       (read-subu8vector serialized-len 0 4 port)))

  (cond ((= 0 n)
       #!eof)
      ((not (= 4 n))
       (error "deserialization error"))
      (else
      (let* ((len
           (+ (u8vector-ref serialized-len 0)
            (arithmetic-shift (u8vector-ref serialized-len 1) 8)
            (arithmetic-shift (u8vector-ref serialized-len 2) 16)
            (arithmetic-shift (u8vector-ref serialized-len 3) 24)))
           (serialized-obj
           (make-u8vector len))
           (n
           (read-subu8vector serialized-obj 0 len port)))

        (if (not (eqv? len n))
          (begin
          (error "deserialization error"
               (list len: len n: n)))
          (let ((obj ((let () (##namespace ("")) u8vector->object) serialized-obj deserialize-hook)))
          (if (vector? obj)
            (vector->list obj)
            obj))))))))

(define (start-serializing-output-port port)
  (spawn-link
  (lambda ()
    (let loop ()
    (recv
      (('write data)
       ;; (debug out: data)
       (serialize data port)
       (force-output port)) ;; io override

      (msg
      (warning "serializing-output-port ignored message: " msg)))
    (loop)))
    name: 'termite-serializing-output-port))


(define (start-serializing-active-input-port port receiver)
  (spawn-link
    (lambda ()
      (let loop ()
        (let ((data (deserialize port)))
          ;; to receive exceptions...
          (? 0 'ok)
          ;; (debug in: data)
          (if (eof-object? data) (shutdown!))
          (! receiver (list (self) data))
          (loop))))
    name: 'termite-serializing-active-input-port))


;; a tcp server listens on a certain port for new tcp connection
;; requests, and call ON-CONNECT to deal with those new connections.
(define (start-tcp-server node on-connect)
  (##namespace ("" open-tcp-server tcp-server-socket-info socket-info-port-number))
  (let ((tcp-server-port
         (open-tcp-server
          (list
           local-address:     (node-host node)
           local-port-number: (node-port node)
           coalesce:          #f))))
    (spawn
     (lambda ()
       (let loop ()
         (on-connect (read tcp-server-port)) ;; io override
         (loop)))
     name: 'termite-tcp-server)

    (make-node (if (equal? "" (node-host node))
                   "localhost"
                   (node-host node))
               (if (= 0 (node-port node))
                   (socket-info-port-number
                    (tcp-server-socket-info tcp-server-port))
                   (node-port node)))))


;; MESSENGERs act as proxies for sockets to other nodes

;; initiate a new bidirectional connection to another node important:
;; caller is responsible for registering it with the dispatcher
(define (initiate-messenger node)
  ;; (print "OUTBOUND connection established\n")
  (spawn
    (lambda ()
      (with-exception-catcher
        (lambda (e)
          (! dispatcher (list 'unregister (self)))
          (shutdown!))

        (lambda ()
          (let ((socket ((let () (##namespace ("")) open-tcp-client)
                          (list address:     (node-host node)
                                port-number: (node-port node)
                                coalesce:    #f))))
            ;; the real interesting part
            (let ((in  (start-serializing-active-input-port socket (self)))
                  (out (start-serializing-output-port socket)))

              (! out (list 'write (current-node)))

              (messenger-loop node in out))))))
    name: 'termite-outbound-messenger))


;; start a MESSENGER for an 'inbound' connection (another node
;; initiated the bidirectional connection, see initiate-messenger)
(define (start-messenger socket)
  ;; (print "INBOUND connection established\n")
  (spawn
  (lambda ()
    (with-exception-catcher
    (lambda (e)
      (! dispatcher (list 'unregister (self)))
      (shutdown!))

    (lambda ()
      (let ((in  (start-serializing-active-input-port socket (self)))
        (out (start-serializing-output-port socket)))
      (recv
        ((,in node)
         ;; registering messenger to local dispatcher
         (! dispatcher (list 'register (self) node))
         (messenger-loop node in out)))))))
    name: 'termite-inbound-messenger))


(define (messenger-loop node in out)
  (recv
  ;; incoming message
  ((,in ('relay id message))
   (let ((to (upid->pid (make-upid id (current-node)))))
     (! to message)))

  ;; outgoing message
  (('relay to message)
   ;; 'to' is a upid
   (let ((id (upid-tag to))
      ;; (node (upid-node to))
      ;; (host (node-host node))
      ;; (port (node-id node))
      )
     (! out (list 'write (list 'relay id message)))))

  ;; unknown message
  (msg
    (warning "messenger-loop ignored message: " msg)))

  (messenger-loop node in out))


;; the DISPATCHER dispatches messages to the right MESSENGER, it keeps
;; track of known remote nodes
(define dispatcher
  (spawn
  (lambda ()
    ;; the KNOWN-NODES of the DISPATCHER LOOP is an a-list of NODE => MESSENGER
    (let loop ((known-nodes '()))
    (recv
      (('register messenger node)
       (loop (cons (cons node messenger) known-nodes)))

      (('unregister messenger)
       (loop (remove (lambda (m) (equal? (cdr m) messenger)) known-nodes)))

      (('relay upid message)
       (let ((node (upid-node upid)))
       (cond
         ;; the message should be sent locally (ideally should not happen
         ;; for performance reasons, but if the programmer wants to do
         ;; that, then OK...)
         ((equal? node (current-node))
          (! (upid->pid upid) message)
          (loop known-nodes))

         ;; the message is destined to a pid on a known node
         ((assoc node known-nodes)
        => (lambda (messenger)
           (! (cdr messenger) (list 'relay upid message))
           (loop known-nodes)))

         ;; unconnected node, must connect
         (else
         (let ((messenger (initiate-messenger node)))
           (! messenger (list 'relay upid message))
           (loop (cons (cons node messenger) known-nodes)))))))

      (msg
        (warning "dispatcher ignored message: " msg) ;; uh...
        (loop known-nodes)))))
    name: 'termite-dispatcher))


;; ----------------------------------------------------------------------------
;; Services

;; LINKER (to establish exception-propagation links between processes)
(define linker
  (spawn
  (lambda ()
    (let loop ()
    (recv
      (('link from to)
       (cond
       ((process? from)
        (process-links-set! from (cons to (process-links from)))) ;;;;;;;;;;
       ((upid? from)
        (! (remote-service 'linker (upid-node from))
         (list 'link from to)))
       (else
         (warning "in linker-loop: unknown object"))))
      (msg
      (warning "linker ignored message: " msg)))
    (loop)))
    name: 'termite-linker))


;; Remote spawning
;; the SPAWNER answers remote-spawn request
(define spawner
  (spawn
  (lambda ()
    (let loop ()
    (recv
      ((from tag ('spawn thunk links name))
       (! from (list tag (spawn thunk links: links name: name))))

      (msg
      (warning "spawner ignored message: " msg)))
    (loop)))
    name: 'termite-spawner))


;; the PUBLISHER is used to implement a mutable global env. for
;; process names
(define publisher
  (spawn
  (lambda ()
    (define dict (make-dict))

    (let loop ()
    (recv
      (('publish name pid)
       (dict-set! dict name pid))

      (('unpublish name pid)
       (dict-set! dict name))

      ((from tag ('resolve name))
       (! from (list tag (dict-ref dict name))))

      (msg
      (warning "puslisher ignored message: " msg)))

    (loop)))
    name: 'termite-publisher))

(define (publish-service name pid)
  (! publisher (list 'publish name pid)))

(define (unpublish-service name pid)
  (! publisher (list 'unpublish name pid)))

;; This should probably only used internally
(define (resolve-service name #!optional host)
  (!? publisher (list 'resolve name)))

;; * Get the pid of a service on a remote node 'node' which has been
;; published with |publish-service| to the name 'service-name'.
(define (remote-service service-name node)
  (make-upid service-name node))


;; ----------------------------------------------------------------------------
;; Erlang/OTP-like behavior for "generic servers" and "event handlers"

(include "otp/gen_server.scm")
(include "otp/gen_event.scm")


;; ----------------------------------------------------------------------------
;; Some datastrutures

(include "data.scm")


;; ----------------------------------------------------------------------------
;; Migration

;; Task moves away, lose identity
(define (migrate-task node)
  ((let () (##namespace ("")) call/cc)
  (lambda (k)
    (remote-spawn node (lambda () (k #t)))
    (halt!))))

;; Task moves away, leave a proxy behind
(define (migrate/proxy node)
  (define (proxy pid)
  (let loop ()
    (! pid (?))
    (loop)))
  ((let () (##namespace ("")) call/cc)
  (lambda (k)
    (proxy
    (remote-spawn-link node (lambda () (k #t)))))))


;; ----------------------------------------------------------------------------
;; A logging facility for Termite

;; (Ideally, this should be included with the services, but the
;; writing style is much different.  Eventually, the other services
;; might use similar style.)

(define (report-event event port)
  (match event
    ((type who messages)
     (with-output-to-port port
       (lambda ()
         (newline)
         (display "[")
         (display type)
         (display "] ")
         (display (formatted-current-time))
         (newline)
         (display who)
         (newline)
         (for-each (lambda (m) (display m) (newline)) messages)
         (force-output))))
    (_ (display "catch-all rule invoked in report-event")))
  port)

(define file-output-log-handler
  (make-event-handler
  ;; init
  (lambda (args)
    (match args
    ((filename)
     (macro-if-auto-forcing
         (delay
           (open-output-file (list path: filename
                                 create: 'maybe
                                 append: #t)))
         (open-output-file (list path: filename
                                 create: 'maybe
                                 append: #t))))))
  ;; event
  report-event
  ;; call
  (lambda (term port)
    (values (void) port))
  ;; shutdown
  (lambda (reason port)
    (close-output-port port))))


;; 'type' is a keyword (error warning info debug)
(define (termite-log type message-list)
  (event-manager:notify logger (list type (self) message-list)))

(define (warning . terms)
  (termite-log 'warning terms))

(define (info . terms)
  (termite-log 'info terms))

(define (debug . terms)
  (termite-log 'debug terms))

(define logger
  (let ((logger (event-manager:start name: 'termite-logger)))
  (event-manager:add-handler logger
                 (make-simple-event-handler
                 report-event
                 (current-error-port)))
  (event-manager:add-handler logger
                 file-output-log-handler
                 "_termite.log")
  logger))


(define ping-server
  (spawn
  (lambda ()
    (let loop ()
    (recv
      ((from tag 'ping)
       (! from (list tag 'pong)))
      (msg (debug "ping-server ignored message" msg)))
    (loop)))
    name: 'termite-ping-server))

(define (ping node #!optional (timeout 1.0))
  (!? (remote-service 'ping-server node) 'ping timeout 'no-reply))

;; ----------------------------------------------------------------------------
;; Enable the unknown-procedure-handler
(##unknown-procedure-handler-set!
  (lambda (name id)
    (let* ((name-str (##symbol->string name))
           (proc/ns (##reverse-string-split-at name-str #\#)))
      (and (##pair? (##cdr proc/ns))
           (let ((mod-name (##last proc/ns)))
             (##load-module (##string->symbol mod-name))
             (let ((proc (##get-subprocedure-from-name-and-id name id)))
               proc))))))

;; ----------------------------------------------------------------------------
;; Initialization

(process-links-set! (self) '())

(define (node-init #!optional (node (make-node "" 0)))
  (let ((actual-node (start-tcp-server node start-messenger)))
    (set! current-node (lambda () actual-node)))
  (publish-external-services)
  'ok)

(define (publish-external-services)
  ;; --------------------
  ;; Services

  ;; publishing the accessible exterior services
  ;; (essentially, opening the node to other nodes)
  (publish-service 'spawner spawner)
  (publish-service 'linker linker)
  (publish-service 'ping-server ping-server))


;; Some convenient definitions
(define node1 (make-node "localhost" 3001))
(define node2 (make-node "localhost" 3002))

