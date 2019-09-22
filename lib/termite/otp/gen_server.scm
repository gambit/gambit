;; Erlang/OTP-like behavior for "generic servers"

;;; "Types" for the functions in a SERVER plugin
;;; 
;;; INIT      :: args         -> state
;;; CALL      :: term   state -> reply state
;;; CAST      :: term   state -> state
;;; TERMINATE :: reason state -> void

(define-type server-plugin
  id: 2ca2d07c-5d6a-44a8-98eb-422b2b8e7296
  read-only:
  init
  call
  cast
  terminate)

(define *server-timeout* 1)

(define (make-server plugin)
  (let loop ((state #f))
    (recv
      ((from tag ('init args))
       (let ((state ((server-plugin-init plugin) args)))
         (! from (list tag state))
         (loop state)))
      
      ((from tag ('call term))
       (call-with-values
         (lambda ()
           ((server-plugin-call plugin) term state))
         (lambda (reply state)
           (! from (list tag reply))
           (loop state))))
      
      (('cast term)
       (loop ((server-plugin-cast plugin) term state)))
      
      (('stop reason)
       ((server-plugin-terminate plugin) reason state)))))

(define (internal-server-start spawner plugin args name)
  (let ((server (spawner (lambda () (make-server plugin)) name: name)))
    (!? server (list 'init args) *server-timeout*) 
    server))

(define (server:start plugin args #!key (name 'anonymous-generic-server))
  (internal-server-start spawn plugin args name))

(define (server:start-link plugin args #!key (name 'anonymous-linked-generic-server))
  (internal-server-start spawn-link plugin args))

(define (server:call server term)
  (!? server (list 'call term) *server-timeout*))

(define (server:cast server term)
  (! server (list 'cast term)))

(define (server:stop server reason)
  (! server (list 'stop reason)))


;; build a trivial server, give a single callback to be invoked on
;; calls, should expect two values and return two
(define (make-simple-server-plugin initial-state callback)
  (make-server-plugin
   ;; INIT
   (lambda (args)
     initial-state)
   ;; CALL
   (lambda (term state)
     (callback term state))
   ;; CAST
   (lambda (args state)
     state)
   ;; TERMINATE
   (lambda (reason state)
     (void))))

