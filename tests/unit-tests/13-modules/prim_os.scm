(include "#.scm")

(check-same-behavior ("" "##" "~~lib/_prim-os#.scm")

;; R7RS

(command-line)

;;unimplemented;;current-jiffy
;;unimplemented;;current-second
;;unimplemented;;emergency-exit

;;(exit) (exit 0);; can't actually test these

;;unimplemented;;get-environment-variable
;;unimplemented;;get-environment-variables
;;unimplemented;;jiffies-per-second

;; Gambit

;;unimplemented;;address-info-family
;;unimplemented;;address-info-protocol
;;unimplemented;;address-info-socket-info
;;unimplemented;;address-info-socket-type
;;unimplemented;;address-info?
;;unimplemented;;address-infos
;;unimplemented;;configure-command-string
;;unimplemented;;cpu-time

(##time? (current-time))

;;unimplemented;;current-user-interrupt-handler
;;unimplemented;;defer-user-interrupts
;;unimplemented;;err-code->string

(getenv "PATH") (getenv "UNKNOWNVAR" #f)

;;unimplemented;;group-info
;;unimplemented;;group-info-gid
;;unimplemented;;group-info-members
;;unimplemented;;group-info-name
;;unimplemented;;group-info?
;;unimplemented;;host-info
;;unimplemented;;host-info-addresses
;;unimplemented;;host-info-aliases
;;unimplemented;;host-info-name
;;unimplemented;;host-info?
;;unimplemented;;host-name
;;unimplemented;;network-info
;;unimplemented;;network-info-aliases
;;unimplemented;;network-info-name
;;unimplemented;;network-info-number
;;unimplemented;;network-info?
;;unimplemented;;process-times
;;unimplemented;;protocol-info
;;unimplemented;;protocol-info-aliases
;;unimplemented;;protocol-info-name
;;unimplemented;;protocol-info-number
;;unimplemented;;protocol-info?
;;unimplemented;;real-time

(##time? (seconds->time 0.0))

;;unimplemented;;service-info
;;unimplemented;;service-info-aliases
;;unimplemented;;service-info-name
;;unimplemented;;service-info-port-number
;;unimplemented;;service-info-protocol
;;unimplemented;;service-info?

(setenv "UNKNOWNVAR2") (setenv "UNKNOWNVAR2" "123")

;;unimplemented;;shell-command
;;unimplemented;;socket-info-address
;;unimplemented;;socket-info-family
;;unimplemented;;socket-info-port-number
;;unimplemented;;socket-info?
;;unimplemented;;system-stamp
;;unimplemented;;system-type
;;unimplemented;;system-type-string
;;unimplemented;;system-version
;;unimplemented;;system-version-string

(##number? (time->seconds (##current-time)))

(time? (##current-time))

;;unimplemented;;timeout->time
;;unimplemented;;user-info
;;unimplemented;;user-info-gid
;;unimplemented;;user-info-home
;;unimplemented;;user-info-name
;;unimplemented;;user-info-shell
;;unimplemented;;user-info-uid
;;unimplemented;;user-info?
;;unimplemented;;user-name

)
