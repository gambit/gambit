;; Erlang/OTP-like behavior for "event handlers"

;;; "Types" for the functions in a EVENT-HANDLER
;;; 
;;; INIT      :: arg           -> state
;;; NOTIFY    :: event  state  -> state
;;; CALL      :: args   state  -> reply state
;;; TERMINATE :: reason state  -> void

(define-type event-handler
  id: 1d3007b8-c5aa-4090-ab55-e352040a4498
  read-only:
  init
  notify
  call
  terminate)

(define *event-manager-timeout* 1)

(define (event-manager)
  (let loop ((handlers '()))
    (recv
      ((from tag ('call handler args))
       (match (assq handler handlers)
                ((handler . state)
                 (call-with-values
                   (lambda () 
                     ((event-handler-call handler) args state))
                   (lambda (reply state)
                     (! from (list tag reply))
                     (loop (cons (cons handler state)
                                 (remove (lambda (x)
                                           (eq? (car x) handler))
                                         handlers))))))
                (#f (error "handler doesn't exists"))))

      ;; should check to avoid duplicates
      (('add-handler handler args)
       (loop (cons (cons handler
                         ((event-handler-init handler) args))
                   handlers)))
      
      (('notify event)
       (loop (map
              (lambda (pair)
                (match pair
                  ((handler . state)
                   (cons handler 
                         ((event-handler-notify handler) event state)))))
              handlers)))

      (('stop) 
       (for-each
        (lambda (pair)
          (match pair
                   ((handler . state)
                    ((event-handler-terminate handler) 'normal state))))
        handlers)
       (void)))))

(define (internal-event-manager-start spawner handlers name)
  (let ((em (spawn event-manager name: name)))
    (for-each
     (lambda (handler)
       (event-manager:add-handler em handler))
     handlers)
    em))

(define (event-manager:start 
          #!key (name 'anonymous-event-manager)
          #!rest handlers )
  (internal-event-manager-start spawn handlers name))

(define (event-manager:start-link 
          #!key (name 'anonymous-linked-event-manager)
          #!rest handlers )
  (internal-event-manager-start spawn-link handlers name))

(define (event-manager:add-handler event-manager handler . args)
  (! event-manager (list 'add-handler handler args)))

(define (event-manager:notify event-manager event)
  (! event-manager (list 'notify event)))

(define (event-manager:call event-manager handler args)
  (!? event-manager (list 'call handler args) *event-manager-timeout*))

(define (event-manager:stop event-manager)
  (! event-manager (list 'stop)))


;; build a trivial event handler with no state, only invoking a
;; callback on any event
(define (make-simple-event-handler callback initial-state)
  (make-event-handler
   ;; INIT
   (lambda (args)
     initial-state)
   ;; NOTIFY
   (lambda (event state)
     (callback event state))
   ;; CALL
   (lambda (args state)
     (values (void) state))
   ;; TERMINATE
   (lambda (reason state)
     (void))))

