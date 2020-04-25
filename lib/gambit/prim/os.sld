;;;============================================================================

;;; File: "os.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; OS operations.

(define-library (os)

  (namespace "##")

  (export

;; r7rs

command-line

;;UNIMPLEMENTED current-jiffy
;;UNIMPLEMENTED current-second
;;UNIMPLEMENTED emergency-exit

exit

;;UNIMPLEMENTED get-environment-variable
;;UNIMPLEMENTED get-environment-variables
;;UNIMPLEMENTED jiffies-per-second

;; gambit

;;UNIMPLEMENTED address-info-family
;;UNIMPLEMENTED address-info-protocol
;;UNIMPLEMENTED address-info-socket-info
;;UNIMPLEMENTED address-info-socket-type
;;UNIMPLEMENTED address-info?
;;UNIMPLEMENTED address-infos
;;UNIMPLEMENTED configure-command-string
;;UNIMPLEMENTED cpu-time

current-time

;;UNIMPLEMENTED current-user-interrupt-handler
;;UNIMPLEMENTED defer-user-interrupts
;;UNIMPLEMENTED err-code->string

getenv

;;UNIMPLEMENTED group-info
;;UNIMPLEMENTED group-info-gid
;;UNIMPLEMENTED group-info-members
;;UNIMPLEMENTED group-info-name
;;UNIMPLEMENTED group-info?
;;UNIMPLEMENTED host-info
;;UNIMPLEMENTED host-info-addresses
;;UNIMPLEMENTED host-info-aliases
;;UNIMPLEMENTED host-info-name
;;UNIMPLEMENTED host-info?
;;UNIMPLEMENTED host-name
;;UNIMPLEMENTED network-info
;;UNIMPLEMENTED network-info-aliases
;;UNIMPLEMENTED network-info-name
;;UNIMPLEMENTED network-info-number
;;UNIMPLEMENTED network-info?
;;UNIMPLEMENTED process-times
;;UNIMPLEMENTED protocol-info
;;UNIMPLEMENTED protocol-info-aliases
;;UNIMPLEMENTED protocol-info-name
;;UNIMPLEMENTED protocol-info-number
;;UNIMPLEMENTED protocol-info?
;;UNIMPLEMENTED real-time

seconds->time

;;UNIMPLEMENTED service-info
;;UNIMPLEMENTED service-info-aliases
;;UNIMPLEMENTED service-info-name
;;UNIMPLEMENTED service-info-port-number
;;UNIMPLEMENTED service-info-protocol
;;UNIMPLEMENTED service-info?

setenv

;;UNIMPLEMENTED shell-command
;;UNIMPLEMENTED socket-info-address
;;UNIMPLEMENTED socket-info-family
;;UNIMPLEMENTED socket-info-port-number
;;UNIMPLEMENTED socket-info?
;;UNIMPLEMENTED system-stamp
;;UNIMPLEMENTED system-type
;;UNIMPLEMENTED system-type-string
;;UNIMPLEMENTED system-version
;;UNIMPLEMENTED system-version-string

time->seconds
time?

;;UNIMPLEMENTED timeout->time
;;UNIMPLEMENTED user-info
;;UNIMPLEMENTED user-info-gid
;;UNIMPLEMENTED user-info-home
;;UNIMPLEMENTED user-info-name
;;UNIMPLEMENTED user-info-shell
;;UNIMPLEMENTED user-info-uid
;;UNIMPLEMENTED user-info?
;;UNIMPLEMENTED user-name

))

;;;============================================================================
