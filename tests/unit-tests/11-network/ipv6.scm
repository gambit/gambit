(include "#.scm")

;;; Regression test for issue #1025 (and #362).
;;;
;;; Passing an IPv6 address (a u16vector) to open-tcp-server,
;;; open-tcp-client, open-udp or udp-destination-set! used to overflow
;;; the 16 byte "struct sockaddr" buffers of the runtime (stack smash,
;;; and a heap overflow inside the UDP device), and an IPv6 TCP client
;;; connected to a truncated address.  Every operation below used to
;;; abort the process on a stack-protector build.

(define ipv6-loopback (u16vector 0 0 0 0 0 0 0 1)) ;; ::1

;; Skip (exit code 0) when the host has no IPv6 loopback, or when
;; networking is not implemented at all.

(define (skip-when-ipv6-unavailable thunk)
  (with-exception-catcher
   (lambda (e)
     (if (os-exception? e)
         (begin
           (println "IPv6 loopback unavailable, skipping: "
                    (exception-description-string e))
           (exit 0))
         (raise e)))
   thunk))

;;; TCP: server bound to ::1, client connecting to ::1

(define server
  (skip-when-ipv6-unavailable
   (lambda ()
     (open-tcp-server
      (list server-address: ipv6-loopback
            port-number: 0 ;; let the OS pick a free port
            reuse-address: #t)))))

(define server-info (tcp-server-socket-info server))
(define server-port (socket-info-port-number server-info))

(test-equal ipv6-loopback (socket-info-address server-info))
(test-eq 'INET6 (socket-info-family server-info))
(test-assert (> server-port 0))

;; no local address given: the client must pick an IPv6 wildcard local
;; address and actually reach the server

(define client
  (open-tcp-client (list address: ipv6-loopback port-number: server-port)))

(define connection (read server)) ;; accept

(test-assert (port? connection))

(display "ping\n" client)
(force-output client)
(test-equal "ping" (read-line connection))

(display "pong\n" connection)
(force-output connection)
(test-equal "pong" (read-line client))

(let ((peer (tcp-client-peer-socket-info client))
      (self (tcp-client-self-socket-info client)))
  (test-equal ipv6-loopback (socket-info-address peer))
  (test-equal server-port (socket-info-port-number peer))
  (test-eq 'INET6 (socket-info-family peer))
  (test-equal ipv6-loopback (socket-info-address self))
  (test-eq 'INET6 (socket-info-family self)))

(let ((peer (tcp-client-peer-socket-info connection))
      (self (tcp-client-self-socket-info connection)))
  (test-equal ipv6-loopback (socket-info-address peer))
  (test-eq 'INET6 (socket-info-family peer))
  (test-equal ipv6-loopback (socket-info-address self))
  (test-equal server-port (socket-info-port-number self)))

;; explicit IPv6 local address and port on the client side

(define client2
  (open-tcp-client (list local-address: ipv6-loopback
                         local-port-number: 0
                         address: ipv6-loopback
                         port-number: server-port)))

(define connection2 (read server))

(display "hello\n" client2)
(force-output client2)
(test-equal "hello" (read-line connection2))
(test-equal ipv6-loopback
            (socket-info-address (tcp-client-self-socket-info client2)))

(close-port client2)
(close-port connection2)
(close-port client)
(close-port connection)
(close-port server)

;;; UDP: sockets bound to ::1, destination set with a u16vector

;; local-address: is the bind address (address: would be the datagram
;; destination); local-port-number: 0 lets the OS pick a free port.

(define u1 (open-udp (list local-address: ipv6-loopback local-port-number: 0)))
(define u2 (open-udp (list local-address: ipv6-loopback local-port-number: 0)))

(define u1-info (udp-local-socket-info u1))
(define u2-info (udp-local-socket-info u2))

(test-equal ipv6-loopback (socket-info-address u1-info))
(test-eq 'INET6 (socket-info-family u1-info))
(test-equal #f (udp-source-socket-info u1))

;; udp-destination-set! stores the address inside the device (heap)

(test-equal (void)
            (udp-destination-set! ipv6-loopback
                                  (socket-info-port-number u1-info)
                                  u2))

(write '#u8(1 2 3) u2)
(test-equal '#u8(1 2 3) (read u1))
(test-equal u2-info (udp-source-socket-info u1)) ;; recvfrom path

(test-equal (void)
            (udp-destination-set! ipv6-loopback
                                  (socket-info-port-number u2-info)
                                  u1))

(write '#u8(4 5) u1)
(test-equal '#u8(4 5) (read u2))
(test-equal u1-info (udp-source-socket-info u2))
(test-equal u1-info (udp-source-socket-info u2)) ;; cached, same source

(write '#u8(6) u1)
(test-equal '#u8(6) (read u2))
(test-equal u1-info (udp-source-socket-info u2))

;; changing the destination again must not corrupt anything

(test-equal (void)
            (udp-destination-set! ipv6-loopback
                                  (socket-info-port-number u1-info)
                                  u1))

(write '#u8(7 8) u1)
(test-equal '#u8(7 8) (read u1))
(test-equal u1-info (udp-source-socket-info u1))

(close-port u1)
(close-port u2)
