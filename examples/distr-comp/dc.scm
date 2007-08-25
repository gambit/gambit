;==============================================================================

; File: "dc.scm", Time-stamp: <2007-04-04 14:25:59 feeley>

; Copyright (c) 2005-2007 by Marc Feeley, All Rights Reserved.

;==============================================================================

(##namespace ("dc#"))

(##include "~~/lib/gambit#.scm")

(##include "dc#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (not safe)
)

;==============================================================================

; Implementation of the basic Termite procedures:
;
;   (self)      returns a reference to the current process
;
;   (pid? obj)  returns #t iff obj is a reference to a process
;
;   (make-tag)  returns a unique object (testable with eq?)
;
;   (! to msg)  sends "msg" to the process referenced by "to"
;
;   (?)         retrieves oldest message from the process' mailbox
;
;   (!? to msg) sends the message #(from tag msg) to the process referenced
;               by "to" (where "from" is a reference to the current process
;               and "tag" is a unique object) and waits for a message of the
;               form #(tag result) and returns "result"

(define self current-thread)

(define pid? thread?)

(define make-tag gensym)

(define ! thread-send)

(define ? thread-receive)

(define (!? to msg)
  (let ((tag (gensym)))
    (thread-send to (vector (current-thread) tag msg))
    (recv (#(,tag result) result))))

;==============================================================================

; Implementation of the distributed computing features of Termite:
;
;   (make-tcp-node ip-address #!optional port-num name)
;     Returns a reference to a node accessible with TCP/IP.
;
;   (goto node)
;     Moves the current process to the given node.

;------------------------------------------------------------------------------

; Types useful for identifying nodes in a distributed system.

(define-type node-locals
  id: 37f40836-0e86-495d-b8c2-c0aeea3f0898

  node                       ; thread representing the node
  node-id                    ; node id
  exported-objects-obj2descr ; table mapping objects to descriptors
  exported-objects-descr2obj ; inverse mapping of previous table
  exported-objects-mutex     ; mutex for accessing the tables
  last-serial-number         ; serial number counter
  initial-continuation       ; initial continuation
)

(define (spawn-thread thunk)
  (let* ((locals (current-node-locals))
         (thread (make-thread thunk)))
    (node-locals-set thread locals) ; all threads know on which node they are
    (thread-start! thread)))

(define (current-node-locals)
  (node-locals-get (current-thread)))

(define (node-locals-get thread)
  (thread-specific thread))

(define (node-locals-set thread locals)
  (thread-specific-set! thread locals))

; A TCP/IP address contains the IP address and the port number.

(define-type tcp-address
  id: b721e7aa-ea98-4e07-aea3-aa073aebe32f

  ip-address ; a 4 or 16 element u8vector, e.g. #u8(192 168 0 100)
  port-num   ; a 16 bit exact integer
)

; A "node id" identifies a node globally.  In a distributed system
; there cannot be two different nodes with the same node id (where
; "same" is determined by equal?). 

(define-type tcp-node-id
  id: 4332e406-4f1f-498f-a7ae-cd8917d8fc67

  tcp-address ; TCP/IP address of the server
  name        ; name of the node on this server (any Scheme object
              ; which can be tested with equal?)
)

;------------------------------------------------------------------------------

; Implementation of make-tcp-node procedure.

(define default-tcp-node-port-number 9000)
(define default-tcp-node-name #f)

(define (make-tcp-node
         ip-address
         #!optional
         (port-num default-tcp-node-port-number)
         (name default-tcp-node-name))
  (let ((ip-adr
         (if (string? ip-address)
             (main-ip-address ip-address)
             ip-address)))
    (node-id->node
     (make-tcp-node-id (make-tcp-address ip-adr port-num) name))))

;------------------------------------------------------------------------------

; Tables to maintain a global address space for objects.

(define (current-node)
  (let ((locals (current-node-locals)))
    (node-locals-node locals)))

(define (current-node-id)
  (let ((locals (current-node-locals)))
    (node-locals-node-id locals)))

(define (current-node-name)
  (let ((locals (current-node-locals)))
    (tcp-node-id-name (node-locals-node-id locals))))

(define (enter-exported-object obj descr)
  (let ((locals (current-node-locals)))
    (table-set! (node-locals-exported-objects-obj2descr locals) obj descr)
    (table-set! (node-locals-exported-objects-descr2obj locals) descr obj)))

(define (object->descr obj create-descr)
  (let ((locals (current-node-locals)))
    (mutex-lock! (node-locals-exported-objects-mutex locals))
    (let ((descr
           (or (table-ref (node-locals-exported-objects-obj2descr locals)
                          obj
                          #f)
               (let ((d (create-descr obj)))
                 (enter-exported-object obj d)
                 d))))
      (mutex-unlock! (node-locals-exported-objects-mutex locals))
      descr)))

(define (descr->object descr create-object)
  (let ((locals (current-node-locals)))
    (mutex-lock! (node-locals-exported-objects-mutex locals))
    (let ((object
           (or (table-ref (node-locals-exported-objects-descr2obj locals)
                          descr
                          #f)
               (let ((obj (create-object descr)))
                 (enter-exported-object obj descr)
                 obj))))
      (mutex-unlock! (node-locals-exported-objects-mutex locals))
      object)))

(define (new-local-serial-number)
  (let* ((locals (current-node-locals))
         (n (+ (node-locals-last-serial-number locals) 1)))
    (node-locals-last-serial-number-set! locals n)
    n))

; Type definition for globalized object descriptors.

(define-type globalized-object
  id: 1eb6750f-f6a5-444c-a05d-701809958f2e
  extender: define-type-of-globalized-object

  ; the creator and serial-num denote the object's identity

  creator    ; the node or node id where this object was created
  serial-num ; the serial-number of this object on that node
)

; Handling of globalized uninterned symbols.

(define-type-of-globalized-object globalized-uninterned-symbol
  id: 857a112b-78f8-4940-936e-bc7021c49569

  equality-skip: ; the following fields are not used by equal? (so that
                 ; equal? tests object identity)

  name
  hash
  global-var?
)

(define (globalize-uninterned-symbol obj)
  (object->descr
   obj
   (lambda (obj)
     (make-globalized-uninterned-symbol
      (current-node-id)
      (new-local-serial-number)
      (symbol->string obj)
      (symbol-hash obj)
      (##global-var? obj)))))

(define (localize-uninterned-symbol descr)
  (let ((sym
         (descr->object
          descr
          (lambda (descr)
            (make-uninterned-symbol
             (string-append "new-" (globalized-uninterned-symbol-name descr))
             (globalized-uninterned-symbol-hash descr))))))
    (if (globalized-uninterned-symbol-global-var? descr)
        (##make-global-var sym))
    sym))

; Handling of globalized threads.

(define-type-of-globalized-object globalized-thread
  id: eaf68ece-be2d-451d-b3be-c6f9106cac40

  equality-skip: ; the following fields are not used by equal? (so that
                 ; equal? tests object identity)

  home  ; the node where this thread was last located
  stamp ; exact integer stamp on location information (so that more recent
        ; location information takes precedence over older information)
)

(define (globalize-thread obj)
  (object->descr
   obj
   (lambda (obj)
     (let ((cnode (current-node)))
       (make-globalized-thread
        (current-node-id)
        (new-local-serial-number)
        cnode
        0)))))

(define (node-id->node node-id)
  (localize-thread (node-id->descr node-id)))

(define (node-id->descr node-id)
  (make-globalized-thread node-id #f #f #f))

(define (localize-thread descr)
  (let ((thread
         (descr->object descr create-thread-proxy-from-descr)))
    (if (globalized-thread-home descr)
        (update-home! (globalize-thread thread) descr))
    thread))

(define (create-thread-proxy-from-descr descr)
  (spawn-thread (lambda () (become-proxy descr))))

(define (become-proxy descr)
  (if (globalized-thread-home descr)
      (become-thread-proxy descr)
      (become-node-proxy descr)))

(define (update-home! descr new-descr)
  (if (> (globalized-thread-stamp new-descr)
         (globalized-thread-stamp descr))
      (let ((locals (current-node-locals)))
        (mutex-lock! (node-locals-exported-objects-mutex locals))
        (globalized-thread-home-set!
         descr
         (globalized-thread-home new-descr))
        (globalized-thread-stamp-set!
         descr
         (globalized-thread-stamp new-descr))
        (mutex-unlock! (node-locals-exported-objects-mutex locals)))))

(define (move-home! descr node)
  (let ((locals (current-node-locals)))
    (mutex-lock! (node-locals-exported-objects-mutex locals))
    (globalized-thread-home-set! descr node)
    (let ((stamp (globalized-thread-stamp descr)))
      (globalized-thread-stamp-set! descr (+ stamp 1)))
    (mutex-unlock! (node-locals-exported-objects-mutex locals))))

; Handling of node messages.

(define-type homecoming-message
  id: f92c9d35-1aff-42d6-8652-3f22611bc99a

  thread  ; thread that is migrating to this node
  cont    ; thread's continuation
)

(define-type forward-message
  id: 8c209f18-baf7-4964-b949-d3e9bbec64e6

  message      ; message that was sent
  destination  ; thread where the message is destined
  path         ; list of nodes that forwarded this message
)

(define-type update-home-message
  id: 452ce3ce-fa2a-4f83-9977-e7ae506f2023

  thread ; thread to update
)

; for debugging:

(##define-macro (debug . lst) #f)

'
(define (debug . lst)
  (for-each display lst)
  (newline))

(define (nod)
  (tcp-node-id-name (current-node-id)))

(define (2str x)
  (object->string x))

(define (become-node node-id thunk)
  ((call-with-current-continuation
    (lambda (cont)
      (let ((locals
             (make-node-locals (current-thread)
                               node-id
                               (make-table test: eq?)
                               (make-table test: equal?)
                               (make-mutex)
                               0
                               cont)))
        (node-locals-set (current-thread) locals))
      (enter-exported-object (current-thread) (node-id->descr node-id))
      (thunk)
      (let loop ()
        (let ((msg (thread-receive)))
          (debug "NODE " (nod) " <--- " (2str msg))
          (cond ((homecoming-message? msg)
                 (let ((thread (homecoming-message-thread msg)))
                   (thread-send thread msg)) ; let thread proxy handle it
                 (loop))
                ((forward-message? msg)
                 (let ((message (forward-message-message msg))
                       (destination (forward-message-destination msg))
                       (path (forward-message-path msg)))
                   (let* ((descr (globalize-thread destination))
                          (home (globalized-thread-home descr))
                          (node (current-node)))
                     (if (eq? home node)
                         (begin
                           (debug "NODE " (nod) " updating " (cdr path))
                           (for-each
                            (lambda (n)
                              (thread-send n
                                           (make-update-home-message
                                            destination)))
                            (cdr path))
                           (thread-send destination message))
                         (thread-send home
                                      (make-forward-message
                                       message
                                       destination
                                       (cons node path))))))
                 (loop))
                ((update-home-message? msg)
                 (loop))
                (else
                 (error "node received unknown message" msg)))))))))

; Handling of node proxy messages.

(define (become-node-proxy descr)
  (debug "NODE " (tcp-node-id-name (globalized-object-creator descr)) " PROXY STARTING " (2str (current-thread)))
  (let loop1 ()
    (let ((msg (thread-receive)))
      (debug "NODE " (tcp-node-id-name (globalized-object-creator descr)) " PROXY opening TCP connection")
      (let* ((node-id
              (globalized-object-creator descr))
             (connection
              (open-tcp-client
               (list server-address:
                     (tcp-address-ip-address
                      (tcp-node-id-tcp-address node-id))
                     port-number:
                     (tcp-address-port-num
                      (tcp-node-id-tcp-address node-id))))))
        (write-object (tcp-node-id-name node-id) connection)
        (let loop2 ((msg msg))
          (debug "NODE " (tcp-node-id-name (globalized-object-creator descr)) " PROXY ===> " (2str msg))
          (write-object msg connection)
          (force-output connection)
          (let ((next-msg (thread-receive 10 connection)))
            (if (eq? next-msg connection)
                (begin
                  (debug "NODE " (tcp-node-id-name (globalized-object-creator descr)) " PROXY closing TCP connection")
                  (close-port connection)
                  (loop1))
                (loop2 next-msg))))))))

; Handling of thread proxy messages.

(define (become-thread-proxy descr)
  (debug "THREAD " (tcp-node-id-name (globalized-object-creator descr)) " sn=" (globalized-object-serial-num descr) " PROXY STARTING " (2str (current-thread)))
  (let loop ()
    (let ((msg (thread-receive)))
      (debug "THREAD " (tcp-node-id-name (globalized-object-creator descr)) " sn=" (globalized-object-serial-num descr) " PROXY <--- " msg)
      (cond ((and (homecoming-message? msg)
                  (eq? (homecoming-message-thread msg)
                       (current-thread)))
             (let ((cont (homecoming-message-cont msg)))
               (cont (void)))) ; return from call/cc in goto
            (else
             (let ((home (globalized-thread-home descr)))
               (thread-send home
                            (make-forward-message
                             msg
                             (current-thread)
                             (list (current-node))))
               (loop)))))))

; Implementation of goto procedure.

(define (goto node)
  (call-with-current-continuation
   (lambda (cont)
     ((node-locals-initial-continuation ; reset current continuation
       (current-node-locals))
      (lambda ()
        (let* ((ct (current-thread))
               (descr (globalize-thread ct)))
          (move-home! descr node) ; set the new home
          (thread-send node (make-homecoming-message ct cont))
          (become-thread-proxy descr)))))))

; Implementation of on procedure.

(define (on node thunk)
  (let ((here (current-node)))
    (goto node)
    (let ((result (thunk)))
      (goto here)
      result)))

; Handling of globalized ports.

(define-type-of-globalized-object globalized-port
  id: 4cef3774-be86-43f1-ab18-f32f3cdedd16

  equality-skip: ; the following fields are not used by equal? (so that
                 ; equal? tests object identity)

  in-thread
  out-thread
  name
)

(define (make-port-to-thread-pump port thread)
  (spawn-thread
   (lambda ()
     (let loop ()
       (let ((x (read-char port)))
         (thread-send thread x)
         (if (not (eof-object? x))
             (loop)
             (close-input-port port)))))))

(define (make-thread-to-port-pump port)
  (spawn-thread
   (lambda ()
     (let loop ()
       (let ((x (thread-receive)))
         (if (not (eof-object? x))
             (begin
               (write-char x port)
               (force-output port)
               (loop))
             (close-output-port port)))))))

(define (make-input-port-server port)
  (spawn-thread
   (lambda ()
     (let loop ()
       (let ((t (thread-receive)))
         (let ((x (read-char port)))
           (thread-send t x)
           (if (not (eof-object? x))
               (loop)
               (close-input-port port))))))))

(define (make-input-port-server-to-port-pump thread oport iport)

  (define (wake-up-reader t)
    (input-port-timeout-set!
     iport
     -inf.0 ; time out immediately if no input available
     (lambda ()
       (input-port-timeout-set! iport +inf.0) ; block on next read
       (thread-send thread t) ; ask for some more input
       #t))) ; thread will block when this procedure returns

  (let ((t
         (make-thread
          (lambda ()
            (let loop ()
              (let ((x (thread-receive)))
                (if (not (eof-object? x))
                    (begin
                      (write-char x oport)
                      (force-output oport)
                      (wake-up-reader (current-thread))
                      (loop))
                    (close-output-port oport))))))))
    (wake-up-reader t)
    (thread-start! t)))

(define (globalize-port obj)
  (object->descr
   obj
   (lambda (obj)
     (make-globalized-port
      (current-node-id)
      (new-local-serial-number)
      (and (input-port? obj)
           (make-input-port-server obj))
      (and (output-port? obj)
           (make-thread-to-port-pump obj))
      (##port-name obj)))))

(define (localize-port descr)
  (descr->object
   descr
   (lambda (descr)
     (let ((in-thread (globalized-port-in-thread descr))
           (out-thread (globalized-port-out-thread descr)))
       (if out-thread
           (if in-thread
               (receive (ioport oiport) (open-string-pipe)
                 (make-port-to-thread-pump oiport out-thread)
                 (make-input-port-server-to-port-pump in-thread oiport ioport)
                 ioport)
               (receive (oport iport) (open-string-pipe '(direction: output))
                 (make-port-to-thread-pump iport out-thread)
                 oport))
           (receive (iport oport) (open-string-pipe '(direction: input))
             (make-input-port-server-to-port-pump in-thread oport iport)
             iport))))))

;------------------------------------------------------------------------------

; Serialization/deserialization of objects.

(define (externalize obj)
  (cond ((uninterned-symbol? obj)
         (globalize-uninterned-symbol obj))
        ((thread? obj)
         (globalize-thread obj))
        ((port? obj)
         (globalize-port obj))
        (else
         obj)))

(define (internalize obj)
  (cond ((globalized-uninterned-symbol? obj)
         (localize-uninterned-symbol obj))
        ((globalized-thread? obj)
         (localize-thread obj))
        ((globalized-port? obj)
         (localize-port obj))
        (else
         obj)))

(define (write-object obj port)
  (let* ((serialized-obj
          (object->u8vector obj externalize))
         (len
          (u8vector-length serialized-obj))
         (serialized-len
          (u8vector (bitwise-and len #xff)
                    (bitwise-and (arithmetic-shift len -8) #xff)
                    (bitwise-and (arithmetic-shift len -16) #xff)
                    (bitwise-and (arithmetic-shift len -24) #xff))))
    (write-subu8vector serialized-len 0 4 port)
    (write-subu8vector serialized-obj 0 len port)))

(define (read-object port)
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
                 (error "deserialization error")
                 (u8vector->object serialized-obj internalize)))))))

;------------------------------------------------------------------------------

(define (become-tcp-node port-num node-name thunk)
  (become-node
   (make-tcp-node-id
    (make-tcp-address (main-ip-address (host-name)) port-num)
    node-name)
   (lambda ()
     (tcp-server-register-node-locals port-num node-name (current-node-locals))
     (start-tcp-server port-num)
     (spawn-thread thunk))))

(define tcp-server-registry (make-table test: equal?))

(define tcp-server-registry-mutex (make-mutex))

(define (tcp-server-lookup-node-locals port-num node-name)
  (let ((key (cons port-num node-name)))
    (mutex-lock! tcp-server-registry-mutex)
    (let ((result (table-ref tcp-server-registry key #f)))
      (mutex-unlock! tcp-server-registry-mutex)
      result)))

(define (tcp-server-register-node-locals port-num node-name locals)
  (let ((key (cons port-num node-name)))
    (mutex-lock! tcp-server-registry-mutex)
    (table-set! tcp-server-registry key locals)
    (mutex-unlock! tcp-server-registry-mutex)))

(define (start-tcp-server port-num)
  (spawn-thread
   (lambda ()
     ; The call to open-tcp-server will raise an exception and
     ; terminate this thread if a tcp-server is currently
     ; running.  This ensures the uniqueness of the server.
     (let ((connection-port
            (with-exception-catcher
             (lambda (e)
               (thread-terminate! (current-thread)))
             (lambda ()
               (open-tcp-server
                (list port-number: port-num
                      backlog: 1024
                      reuse-address: #t))))))
       (let loop ()
         (let ((connection (read connection-port)))
           (tcp-server-connection-request-handle port-num connection))
         (loop))))))

(define (tcp-server-connection-request-handle port-num connection)
  (spawn-thread
   (lambda ()
     (let ((node-name (read-object connection)))
       (debug "RELAY " node-name " STARTING " (2str (current-thread)))
       (if (not (eof-object? node-name))
           (let ((locals
                  (tcp-server-lookup-node-locals port-num node-name)))
             (if locals
                 (begin
                   (node-locals-set (current-thread) locals)
                   (let loop ()
                     (let ((msg (read-object connection)))
                       (if (not (eof-object? msg))
                           (begin
                             (debug "RELAY " node-name " <=== " (2str msg))
                             (thread-send (node-locals-node locals) msg)
                             (loop))))))
                 (error "received connection request for nonexistent node"))))
       (close-port connection)))))

(define (main-ip-address host)
  (car (host-info-addresses (host-info host))))

;==============================================================================
