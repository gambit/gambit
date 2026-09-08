(include "#.scm")

;; Bind only to loopback and let the OS choose an unused port. No external
;; server or DNS lookup is needed, and all reads have a timeout.
(define server #f)
(define client #f)
(define accepted #f)
(test-assert
 (begin
   (set! server
    (exit0-when-unimplemented-operation-os-exception
     (lambda () (open-tcp-server '(local-address: "127.0.0.1" local-port-number: 0)))))
   (input-port? server)))

(dynamic-wind
 (lambda () #f)
 (lambda ()
   (input-port-timeout-set! server 10)
   (let* ((server-info (tcp-server-socket-info server))
          (number (socket-info-port-number server-info)))
     (test-assert (> number 0))
     (test-eq 'INET (socket-info-family server-info))
     (test-assert
      (begin (set! client (open-tcp-client (list address: "127.0.0.1" port-number: number)))
             (input-port? client)))
     (set! accepted (read server))
     (input-port-timeout-set! client 10)
     (output-port-timeout-set! client 10)
     (input-port-timeout-set! accepted 10)
     (output-port-timeout-set! accepted 10)
     (test-equal (tcp-client-local-socket-info client)
                  (tcp-client-self-socket-info client))
     (test-eqv number (socket-info-port-number (tcp-client-peer-socket-info client)))
     (test-eqv (socket-info-port-number (tcp-client-local-socket-info client))
               (socket-info-port-number (tcp-client-peer-socket-info accepted)))
     (test-eqv number (socket-info-port-number (tcp-client-local-socket-info accepted)))
     (test-equal '(request 42)
      (begin (write '(request 42) client) (newline client) (force-output client)
             (read accepted)))
     (test-equal '(response 43)
      (begin (write '(response 43) accepted) (newline accepted) (force-output accepted)
             (read client)))
     (test-eq #!eof (begin (close-output-port client) (read accepted)))))
 (lambda ()
   (if accepted (close-port accepted))
   (if client (close-port client))
   (if server (close-port server))))

(test-assert
 (let ((infos (address-infos host: "127.0.0.1" service: "80"
                             family: 'INET socket-type: 'STREAM protocol: 'TCP)))
   (and (pair? infos)
        (every
         (lambda (info)
           (and (address-info? info)
                (eq? 'INET (address-info-family info))
                (eq? 'STREAM (address-info-socket-type info))
                (eq? 'TCP (address-info-protocol info))
                (= 80 (socket-info-port-number (address-info-socket-info info)))
                (equal? #u8(127 0 0 1)
                         (socket-info-address (address-info-socket-info info)))))
         infos))))
(test-eq #f (address-info? #f))
(test-error type-exception? (tcp-client-local-socket-info #f))
(test-error type-exception? (tcp-client-peer-socket-info #f))
(test-error type-exception? (tcp-server-socket-info #f))
(test-error type-exception? (address-info-family #f))
