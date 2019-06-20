;;;============================================================================

;;; File: "_prim-os-gambit#.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; OS operations in Gambit.

(##namespace ("##"

(address-info-family address-info-family#unimplemented)
(address-info-protocol address-info-protocol#unimplemented)
(address-info-socket-info address-info-socket-info#unimplemented)
(address-info-socket-type address-info-socket-type#unimplemented)
(address-info? address-info?#unimplemented)
(address-infos address-infos#unimplemented)
(configure-command-string configure-command-string#unimplemented)
(cpu-time cpu-time#unimplemented)

current-time

(current-user-interrupt-handler current-user-interrupt-handler#unimplemented)
(defer-user-interrupts defer-user-interrupts#unimplemented)
(err-code->string err-code->string#unimplemented)

getenv

(group-info group-info#unimplemented)
(group-info-gid group-info-gid#unimplemented)
(group-info-members group-info-members#unimplemented)
(group-info-name group-info-name#unimplemented)
(group-info? group-info?#unimplemented)
(host-info host-info#unimplemented)
(host-info-addresses host-info-addresses#unimplemented)
(host-info-aliases host-info-aliases#unimplemented)
(host-info-name host-info-name#unimplemented)
(host-info? host-info?#unimplemented)
(host-name host-name#unimplemented)
(network-info network-info#unimplemented)
(network-info-aliases network-info-aliases#unimplemented)
(network-info-name network-info-name#unimplemented)
(network-info-number network-info-number#unimplemented)
(network-info? network-info?#unimplemented)
(process-times process-times#unimplemented)
(protocol-info protocol-info#unimplemented)
(protocol-info-aliases protocol-info-aliases#unimplemented)
(protocol-info-name protocol-info-name#unimplemented)
(protocol-info-number protocol-info-number#unimplemented)
(protocol-info? protocol-info?#unimplemented)
(real-time real-time#unimplemented)

seconds->time

(service-info service-info#unimplemented)
(service-info-aliases service-info-aliases#unimplemented)
(service-info-name service-info-name#unimplemented)
(service-info-port-number service-info-port-number#unimplemented)
(service-info-protocol service-info-protocol#unimplemented)
(service-info? service-info?#unimplemented)

setenv

(shell-command shell-command#unimplemented)
(socket-info-address socket-info-address#unimplemented)
(socket-info-family socket-info-family#unimplemented)
(socket-info-port-number socket-info-port-number#unimplemented)
(socket-info? socket-info?#unimplemented)
(system-stamp system-stamp#unimplemented)
(system-type system-type#unimplemented)
(system-type-string system-type-string#unimplemented)
(system-version system-version#unimplemented)
(system-version-string system-version-string#unimplemented)

time->seconds
time?

(timeout->time timeout->time#unimplemented)
(user-info user-info#unimplemented)
(user-info-gid user-info-gid#unimplemented)
(user-info-home user-info-home#unimplemented)
(user-info-name user-info-name#unimplemented)
(user-info-shell user-info-shell#unimplemented)
(user-info-uid user-info-uid#unimplemented)
(user-info? user-info?#unimplemented)
(user-name user-name#unimplemented)

))

;;;============================================================================
