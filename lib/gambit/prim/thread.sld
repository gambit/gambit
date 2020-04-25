;;;============================================================================

;;; File: "thread.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Thread operations.

(define-library (thread)

  (namespace "##")

  (export

;; gambit

;;UNIMPLEMENTED abandoned-mutex-exception?
;;UNIMPLEMENTED condition-variable-broadcast!
;;UNIMPLEMENTED condition-variable-name
;;UNIMPLEMENTED condition-variable-signal!
;;UNIMPLEMENTED condition-variable-specific
;;UNIMPLEMENTED condition-variable-specific-set!
;;UNIMPLEMENTED condition-variable?
;;UNIMPLEMENTED current-processor
;;UNIMPLEMENTED current-thread
;;UNIMPLEMENTED deadlock-exception?
;;UNIMPLEMENTED inactive-thread-exception-arguments
;;UNIMPLEMENTED inactive-thread-exception-procedure
;;UNIMPLEMENTED inactive-thread-exception?
;;UNIMPLEMENTED initialized-thread-exception-arguments
;;UNIMPLEMENTED initialized-thread-exception-procedure
;;UNIMPLEMENTED initialized-thread-exception?
;;UNIMPLEMENTED join-timeout-exception-arguments
;;UNIMPLEMENTED join-timeout-exception-procedure
;;UNIMPLEMENTED join-timeout-exception?
;;UNIMPLEMENTED mailbox-receive-timeout-exception-arguments
;;UNIMPLEMENTED mailbox-receive-timeout-exception-procedure
;;UNIMPLEMENTED mailbox-receive-timeout-exception?
;;UNIMPLEMENTED make-condition-variable
;;UNIMPLEMENTED make-mutex
;;UNIMPLEMENTED make-root-thread
;;UNIMPLEMENTED make-thread
;;UNIMPLEMENTED make-thread-group
;;UNIMPLEMENTED mutex-lock!
;;UNIMPLEMENTED mutex-name
;;UNIMPLEMENTED mutex-specific
;;UNIMPLEMENTED mutex-specific-set!
;;UNIMPLEMENTED mutex-state
;;UNIMPLEMENTED mutex-unlock!
;;UNIMPLEMENTED mutex?
;;UNIMPLEMENTED processor-id
;;UNIMPLEMENTED processor?
;;UNIMPLEMENTED started-thread-exception-arguments
;;UNIMPLEMENTED started-thread-exception-procedure
;;UNIMPLEMENTED started-thread-exception?
;;UNIMPLEMENTED terminated-thread-exception-arguments
;;UNIMPLEMENTED terminated-thread-exception-procedure
;;UNIMPLEMENTED terminated-thread-exception?
;;UNIMPLEMENTED thread-base-priority
;;UNIMPLEMENTED thread-base-priority-set!
;;UNIMPLEMENTED thread-group->thread-group-list
;;UNIMPLEMENTED thread-group->thread-group-vector
;;UNIMPLEMENTED thread-group->thread-list
;;UNIMPLEMENTED thread-group->thread-vector
;;UNIMPLEMENTED thread-group-name
;;UNIMPLEMENTED thread-group-parent
;;UNIMPLEMENTED thread-group-resume!
;;UNIMPLEMENTED thread-group-specific
;;UNIMPLEMENTED thread-group-specific-set!
;;UNIMPLEMENTED thread-group-suspend!
;;UNIMPLEMENTED thread-group-terminate!
;;UNIMPLEMENTED thread-group?
;;UNIMPLEMENTED thread-init!
;;UNIMPLEMENTED thread-interrupt!
;;UNIMPLEMENTED thread-join!
;;UNIMPLEMENTED thread-mailbox-extract-and-rewind
;;UNIMPLEMENTED thread-mailbox-next
;;UNIMPLEMENTED thread-mailbox-rewind
;;UNIMPLEMENTED thread-name
;;UNIMPLEMENTED thread-priority-boost
;;UNIMPLEMENTED thread-priority-boost-set!
;;UNIMPLEMENTED thread-quantum
;;UNIMPLEMENTED thread-quantum-set!
;;UNIMPLEMENTED thread-receive
;;UNIMPLEMENTED thread-resume!
;;UNIMPLEMENTED thread-send
;;UNIMPLEMENTED thread-sleep!
;;UNIMPLEMENTED thread-specific
;;UNIMPLEMENTED thread-specific-set!
;;UNIMPLEMENTED thread-start!
;;UNIMPLEMENTED thread-state
;;UNIMPLEMENTED thread-state-abnormally-terminated-reason
;;UNIMPLEMENTED thread-state-abnormally-terminated?
;;UNIMPLEMENTED thread-state-initialized?
;;UNIMPLEMENTED thread-state-normally-terminated-result
;;UNIMPLEMENTED thread-state-normally-terminated?
;;UNIMPLEMENTED thread-state-running-processor
;;UNIMPLEMENTED thread-state-running?
;;UNIMPLEMENTED thread-state-uninitialized?
;;UNIMPLEMENTED thread-state-waiting-for
;;UNIMPLEMENTED thread-state-waiting-timeout
;;UNIMPLEMENTED thread-state-waiting?
;;UNIMPLEMENTED thread-suspend!
;;UNIMPLEMENTED thread-terminate!
;;UNIMPLEMENTED thread-thread-group
;;UNIMPLEMENTED thread-yield!
;;UNIMPLEMENTED thread?
;;UNIMPLEMENTED top
;;UNIMPLEMENTED uninitialized-thread-exception-arguments
;;UNIMPLEMENTED uninitialized-thread-exception-procedure
;;UNIMPLEMENTED uninitialized-thread-exception?

))

;;;============================================================================
