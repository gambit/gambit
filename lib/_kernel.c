#ifdef ___LINKER_INFO
; File: "_kernel.c", produced by Gambit v4.8.9
(
408009
(C)
"_kernel"
(("_kernel"))
(
"##type-0-0bf9b656-b071-404a-a514-0fb9d05cf518"
"##type-0-73c66686-a08f-4c7c-a0f1-5ad7771f242a"
"##type-0-828142df-e9a5-4ed8-a467-2f4833525b3e"
"##type-0-d69cd396-01e0-4dcb-87dc-31acea8e0e5f"
"##type-0-f512c9f6-3b24-4c5c-8c8b-cabd75b2f951"
"##type-2-2138cd7f-8c42-4164-b56a-a8c7badf3323"
"##type-2-299ccee1-77d2-4a6d-ab24-2ebf14297315"
"##type-2-3f9f8aaa-ea21-4f2b-bc06-f65950e6c408"
"##type-2-3fd6c57f-3c80-4436-a430-57ea4457c11e"
"##type-2-CA9CA020-600A-4516-AA78-CBE91EC8BE14"
"##type-2-f9519b37-d6d4-4748-8eb1-a0c8dc18c5e7"
"##type-33-d05e0aa7-e235-441d-aa41-c1ac02065460"
"##type-4-54dfbc02-718d-4a34-91ab-d1861da7500a"
"##type-4-9f09b552-0fb7-42c5-b0d4-212155841d53"
"##type-4-c1fc166b-d951-4871-853c-2b6c8c12d28d"
"##type-4-cf06eccd-bf2c-4b30-a6ce-394b345a0dee"
"##type-4-f39d07ce-436d-40ca-b81f-cdc65d16b7f2"
"##type-5"
"_kernel"
"arg-num"
"arguments"
"btq-color"
"btq-container"
"btq-deq-next"
"btq-deq-prev"
"btq-left"
"btq-leftmost"
"btq-parent"
"cfun-conversion-exception"
"code"
"cont"
"denv"
"denv-cache1"
"denv-cache2"
"denv-cache3"
"end-condvar"
"exception"
"exception?"
"fields"
"flags"
"floats"
"foreign"
"heap-overflow-exception"
"id"
"interrupts"
"keyword-expected-exception"
"last-processor"
"lock1"
"lock2"
"mailbox"
"message"
"module-not-found-exception"
"multiple-c-return-exception"
"name"
"no-such-file-or-directory-exception"
"nonprocedure-operator-exception"
"not-started"
"number-of-arguments-limit-exception"
"operator"
"os-exception"
"procedure"
"repl-channel"
"result"
"resume-thunk"
"rte"
"sfun-conversion-exception"
"specific"
"stack-overflow-exception"
"super"
"tgroup"
"thread"
"threads-deq-next"
"threads-deq-prev"
"toq-color"
"toq-container"
"toq-left"
"toq-leftmost"
"toq-parent"
"type"
"type-exception"
"type-id"
"unknown-keyword-argument-exception"
"void*"
"wrong-number-of-arguments-exception"
"wrong-processor-c-return-exception"
)
(
)
(
"##add-job!"
"##apply"
"##apply-with-procedure-check"
"##argument-list-fix-rest-param!"
"##argument-list-remove-absent!"
"##argument-list-remove-absent-keys!"
"##c-return-on-other-processor-hook"
"##check-heap"
"##clear-jobs!"
"##command-line"
"##continuation-copy"
"##continuation-frame"
"##continuation-next"
"##continuation-next!"
"##create-module"
"##default-load-required-module"
"##direct-structure-cas!"
"##direct-structure-ref"
"##direct-structure-set!"
"##err-code-ENOENT"
"##execute-and-clear-jobs!"
"##execute-final-wills!"
"##execute-jobs!"
"##exit"
"##exit-abnormally"
"##exit-cleanup"
"##exit-jobs"
"##exit-with-err-code"
"##exit-with-err-code-no-cleanup"
"##extract-procedure-and-arguments"
"##fail-check-cfun-conversion-exception"
"##fail-check-foreign"
"##fail-check-keyword-expected-exception"
"##fail-check-module-not-found-exception"
"##fail-check-no-such-file-or-directory-exception"
"##fail-check-nonprocedure-operator-exception"
"##fail-check-number-of-arguments-limit-exception"
"##fail-check-os-exception"
"##fail-check-sfun-conversion-exception"
"##fail-check-type-exception"
"##fail-check-unknown-keyword-argument-exception"
"##fail-check-wrong-number-of-arguments-exception"
"##final-will-registry"
"##find-interned-symkey"
"##fixnum-width"
"##foreign-address"
"##foreign-release!"
"##foreign-released?"
"##frame-fs"
"##frame-ref"
"##frame-ret"
"##frame-slot-live?"
"##gc"
"##gc-final-will-registry!"
"##gc-finalize!"
"##gc-interrupt-jobs"
"##gc-without-exceptions"
"##global-var->identifier"
"##handle-gc-interrupt!"
"##interrupt-vector"
"##interrupt-vector-set!"
"##load-required-module"
"##load-required-module-structs"
"##load-vm"
"##lookup-module"
"##lookup-registered-module"
"##machine-code-block-fixup"
"##main"
"##main-set!"
"##make-f32vector"
"##make-f64vector"
"##make-global-var"
"##make-interned-symbol"
"##make-interned-symkey"
"##make-jobs"
"##make-machine-code-block"
"##make-s16vector"
"##make-s32vector"
"##make-s64vector"
"##make-s8vector"
"##make-string"
"##make-structure"
"##make-u16vector"
"##make-u32vector"
"##make-u64vector"
"##make-u8vector"
"##make-vector"
"##module-init"
"##object->global-var"
"##os-configure-command-string-saved"
"##os-system-type-saved"
"##os-system-type-string-saved"
"##program-descr"
"##raise-heap-overflow-exception"
"##raise-keyword-expected-exception"
"##raise-module-not-found-exception"
"##raise-nonprocedure-operator-exception"
"##raise-os-exception"
"##raise-type-exception"
"##raise-unknown-keyword-argument-exception"
"##raise-wrong-number-of-arguments-exception"
"##raise-wrong-processor-c-return-exception"
"##register-module-descr!"
"##register-module-descrs!"
"##registered-modules"
"##rest-param-resume-procedure"
"##return-fs"
"##structure-cas!"
"##structure-instance-of?"
"##structure-ref"
"##structure-set!"
"##sync-op-interrupt!"
"##system-stamp"
"##system-stamp-saved"
"##system-version"
"##system-version-string"
"##vm-main-module-id"
"##with-no-result-expected"
"_kernel#"
"_kernel#0"
"_kernel#1"
"_kernel#10"
"_kernel#11"
"_kernel#12"
"_kernel#13"
"_kernel#14"
"_kernel#15"
"_kernel#16"
"_kernel#17"
"_kernel#18"
"_kernel#19"
"_kernel#2"
"_kernel#20"
"_kernel#21"
"_kernel#22"
"_kernel#23"
"_kernel#24"
"_kernel#25"
"_kernel#26"
"_kernel#27"
"_kernel#28"
"_kernel#29"
"_kernel#3"
"_kernel#30"
"_kernel#31"
"_kernel#32"
"_kernel#33"
"_kernel#34"
"_kernel#35"
"_kernel#36"
"_kernel#37"
"_kernel#38"
"_kernel#39"
"_kernel#4"
"_kernel#40"
"_kernel#41"
"_kernel#42"
"_kernel#43"
"_kernel#44"
"_kernel#45"
"_kernel#46"
"_kernel#47"
"_kernel#48"
"_kernel#49"
"_kernel#5"
"_kernel#50"
"_kernel#51"
"_kernel#52"
"_kernel#53"
"_kernel#54"
"_kernel#55"
"_kernel#56"
"_kernel#57"
"_kernel#58"
"_kernel#59"
"_kernel#6"
"_kernel#60"
"_kernel#61"
"_kernel#62"
"_kernel#63"
"_kernel#64"
"_kernel#65"
"_kernel#66"
"_kernel#67"
"_kernel#68"
"_kernel#69"
"_kernel#7"
"_kernel#70"
"_kernel#71"
"_kernel#72"
"_kernel#73"
"_kernel#74"
"_kernel#75"
"_kernel#76"
"_kernel#77"
"_kernel#78"
"_kernel#79"
"_kernel#8"
"_kernel#80"
"_kernel#81"
"_kernel#82"
"_kernel#83"
"_kernel#84"
"_kernel#85"
"_kernel#86"
"_kernel#87"
"_kernel#88"
"_kernel#89"
"_kernel#9"
"_kernel#90"
"_kernel#91"
"_kernel#92"
"foreign-release!"
)
(
"##actlog-dump"
"##actlog-start"
"##actlog-stop"
"##add-exit-job!"
"##add-gc-interrupt-job!"
"##add-job-at-tail!"
"##apply-global-with-procedure-check-nary"
"##apply-with-procedure-check-nary"
"##assq"
"##assq-cdr"
"##bignum.adigit-width"
"##bignum.fdigit-width"
"##bignum.mdigit-width"
"##c-return-on-other-processor"
"##c-return-on-other-processor-hook-set!"
"##check-heap-limit"
"##clear-exit-jobs!"
"##clear-gc-interrupt-jobs!"
"##closure-code"
"##closure-length"
"##closure-ref"
"##closure-set!"
"##closure?"
"##continuation-denv"
"##continuation-denv-set!"
"##continuation-frame-set!"
"##continuation-fs"
"##continuation-last"
"##continuation-link"
"##continuation-ref"
"##continuation-ret"
"##continuation-set!"
"##continuation-slot-live?"
"##core-count"
"##cpu-cache-size"
"##cpu-count"
"##current-vm-processor-count"
"##current-vm-resize"
"##device-select-abort!"
"##disable-interrupts!"
"##dynamic-env-bind"
"##enable-interrupts!"
"##err-code-EAGAIN"
"##err-code-EINTR"
"##err-code-unimplemented"
"##exit-with-exception"
"##explode-continuation"
"##explode-frame"
"##fail-check-heap-overflow-exception"
"##fail-check-multiple-c-return-exception"
"##fail-check-stack-overflow-exception"
"##fail-check-wrong-processor-c-return-exception"
"##find-interned-keyword"
"##find-interned-symbol"
"##first-argument"
"##fixnum-width-neg"
"##force-undetermined"
"##foreign-tags"
"##format-filepos"
"##frame-link"
"##frame-set!"
"##get-bytes-allocated!"
"##get-current-time!"
"##get-heartbeat-interval!"
"##get-live-percent"
"##get-max-heap"
"##get-min-heap"
"##get-monotonic-time!"
"##get-monotonic-time-frequency!"
"##get-parallelism-level"
"##get-standard-level"
"##global-var-primitive-ref"
"##global-var-primitive-set!"
"##global-var-ref"
"##global-var-set!"
"##global-var?"
"##interrupt-handler"
"##kernel-handlers"
"##keyword-table"
"##load-required-module-set!"
"##machine-code-block-exec"
"##machine-code-block-ref"
"##machine-code-block-set!"
"##machine-code-fixup"
"##make-closure"
"##make-continuation"
"##make-final-will"
"##make-frame"
"##make-interned-keyword"
"##make-promise"
"##make-subprocedure"
"##make-values"
"##max-char"
"##max-fixnum"
"##min-fixnum"
"##object->global-var->identifier"
"##os-address-infos"
"##os-bat-extension-string-saved"
"##os-condvar-select!"
"##os-copy-file"
"##os-create-directory"
"##os-create-fifo"
"##os-create-link"
"##os-create-symbolic-link"
"##os-delete-directory"
"##os-delete-file"
"##os-device-close"
"##os-device-directory-open-path"
"##os-device-directory-read"
"##os-device-event-queue-open"
"##os-device-event-queue-read"
"##os-device-force-output"
"##os-device-kind"
"##os-device-open-raw-from-fd"
"##os-device-process-pid"
"##os-device-process-status"
"##os-device-stream-default-options"
"##os-device-stream-open-path"
"##os-device-stream-open-predefined"
"##os-device-stream-open-process"
"##os-device-stream-options-set!"
"##os-device-stream-read"
"##os-device-stream-seek"
"##os-device-stream-width"
"##os-device-stream-write"
"##os-device-tcp-client-open"
"##os-device-tcp-client-socket-info"
"##os-device-tcp-server-open"
"##os-device-tcp-server-read"
"##os-device-tcp-server-socket-info"
"##os-device-tty-history"
"##os-device-tty-history-max-length-set!"
"##os-device-tty-history-set!"
"##os-device-tty-mode-set!"
"##os-device-tty-paren-balance-duration-set!"
"##os-device-tty-text-attributes-set!"
"##os-device-tty-type-set!"
"##os-device-udp-destination-set!"
"##os-device-udp-open"
"##os-device-udp-read-subu8vector"
"##os-device-udp-socket-info"
"##os-device-udp-write-subu8vector"
"##os-environ"
"##os-err-code->string"
"##os-exe-extension-string-saved"
"##os-file-info"
"##os-file-times-set!"
"##os-getenv"
"##os-getpid"
"##os-getppid"
"##os-group-info"
"##os-host-info"
"##os-host-name"
"##os-load-object-file"
"##os-make-tls-context"
"##os-network-info"
"##os-obj-extension-string-saved"
"##os-path-gambitdir"
"##os-path-gambitdir-map-lookup"
"##os-path-homedir"
"##os-path-normalize-directory"
"##os-protocol-info"
"##os-rename-file"
"##os-service-info"
"##os-set-current-directory"
"##os-setenv"
"##os-shell-command"
"##os-user-info"
"##os-user-name"
"##process-statistics"
"##process-times"
"##processed-command-line"
"##processed-command-line-set!"
"##promise-result"
"##promise-result-set!"
"##promise-thunk"
"##promise-thunk-set!"
"##raise-cfun-conversion-exception-nary"
"##raise-high-level-interrupt!"
"##raise-keyword-expected-exception-nary"
"##raise-multiple-c-return-exception"
"##raise-no-such-file-or-directory-exception"
"##raise-number-of-arguments-limit-exception"
"##raise-sfun-conversion-exception"
"##raise-stack-overflow-exception"
"##raise-unknown-keyword-argument-exception-nary"
"##raise-wrong-number-of-arguments-exception-nary"
"##register-module-descrs-and-load!"
"##remote-dbg-addr"
"##rest-param-check-heap"
"##rest-param-heap-overflow"
"##rpc-server-addr"
"##set-debug-settings!"
"##set-gambitdir!"
"##set-heartbeat-interval!"
"##set-live-percent!"
"##set-max-heap!"
"##set-min-heap!"
"##set-parallelism-level!"
"##set-standard-level!"
"##still-copy"
"##still-obj-refcount-dec!"
"##still-obj-refcount-inc!"
"##structure"
"##structure-direct-instance-of?"
"##structure-length"
"##structure-type"
"##structure-type-set!"
"##subprocedure-id"
"##subprocedure-nb-closed"
"##subprocedure-nb-parameters"
"##subprocedure-parent"
"##subprocedure-parent-info"
"##subprocedure-parent-name"
"##subprocedure?"
"##symbol-table"
"##type-fields"
"##type-flags"
"##type-id"
"##type-name"
"##type-super"
"##type-type"
"##type?"
"##unchecked-structure-cas!"
"##unchecked-structure-ref"
"##unchecked-structure-set!"
"##values-length"
"##values-ref"
"##values-set!"
"##with-no-result-expected-toplevel"
"cfun-conversion-exception-arguments"
"cfun-conversion-exception-code"
"cfun-conversion-exception-message"
"cfun-conversion-exception-procedure"
"cfun-conversion-exception?"
"configure-command-string"
"err-code->string"
"foreign-address"
"foreign-released?"
"foreign-tags"
"foreign?"
"heap-overflow-exception?"
"keyword-expected-exception-arguments"
"keyword-expected-exception-procedure"
"keyword-expected-exception?"
"module-not-found-exception-arguments"
"module-not-found-exception-procedure"
"module-not-found-exception?"
"multiple-c-return-exception?"
"no-such-file-or-directory-exception-arguments"
"no-such-file-or-directory-exception-procedure"
"no-such-file-or-directory-exception?"
"nonprocedure-operator-exception-arguments"
"nonprocedure-operator-exception-code"
"nonprocedure-operator-exception-operator"
"nonprocedure-operator-exception-rte"
"nonprocedure-operator-exception?"
"number-of-arguments-limit-exception-arguments"
"number-of-arguments-limit-exception-procedure"
"number-of-arguments-limit-exception?"
"os-exception-arguments"
"os-exception-code"
"os-exception-message"
"os-exception-procedure"
"os-exception?"
"sfun-conversion-exception-arguments"
"sfun-conversion-exception-code"
"sfun-conversion-exception-message"
"sfun-conversion-exception-procedure"
"sfun-conversion-exception?"
"stack-overflow-exception?"
"system-stamp"
"system-type"
"system-type-string"
"system-version"
"system-version-string"
"type-exception-arg-num"
"type-exception-arguments"
"type-exception-procedure"
"type-exception-type-id"
"type-exception?"
"unknown-keyword-argument-exception-arguments"
"unknown-keyword-argument-exception-procedure"
"unknown-keyword-argument-exception?"
"wrong-number-of-arguments-exception-arguments"
"wrong-number-of-arguments-exception-procedure"
"wrong-number-of-arguments-exception?"
"wrong-processor-c-return-exception?"
)
(
)
 ()
)
#else
#define ___VERSION 408009
#define ___MODULE_NAME "_kernel"
#define ___LINKER_ID ___LNK___kernel
#define ___MH_PROC ___H___kernel
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 85
#define ___GLOCOUNT 501
#define ___SUPCOUNT 501
#define ___CNSCOUNT 1
#define ___SUBCOUNT 44
#define ___LBLCOUNT 1230
#define ___OFDCOUNT 11
#define ___MODDESCR ___REF_SUB(43)
#include "gambit.h"

___NEED_SYM(___S__23__23_type_2d_0_2d_0bf9b656_2d_b071_2d_404a_2d_a514_2d_0fb9d05cf518)
___NEED_SYM(___S__23__23_type_2d_0_2d_73c66686_2d_a08f_2d_4c7c_2d_a0f1_2d_5ad7771f242a)
___NEED_SYM(___S__23__23_type_2d_0_2d_828142df_2d_e9a5_2d_4ed8_2d_a467_2d_2f4833525b3e)
___NEED_SYM(___S__23__23_type_2d_0_2d_d69cd396_2d_01e0_2d_4dcb_2d_87dc_2d_31acea8e0e5f)
___NEED_SYM(___S__23__23_type_2d_0_2d_f512c9f6_2d_3b24_2d_4c5c_2d_8c8b_2d_cabd75b2f951)
___NEED_SYM(___S__23__23_type_2d_2_2d_2138cd7f_2d_8c42_2d_4164_2d_b56a_2d_a8c7badf3323)
___NEED_SYM(___S__23__23_type_2d_2_2d_299ccee1_2d_77d2_2d_4a6d_2d_ab24_2d_2ebf14297315)
___NEED_SYM(___S__23__23_type_2d_2_2d_3f9f8aaa_2d_ea21_2d_4f2b_2d_bc06_2d_f65950e6c408)
___NEED_SYM(___S__23__23_type_2d_2_2d_3fd6c57f_2d_3c80_2d_4436_2d_a430_2d_57ea4457c11e)
___NEED_SYM(___S__23__23_type_2d_2_2d_CA9CA020_2d_600A_2d_4516_2d_AA78_2d_CBE91EC8BE14)
___NEED_SYM(___S__23__23_type_2d_2_2d_f9519b37_2d_d6d4_2d_4748_2d_8eb1_2d_a0c8dc18c5e7)
___NEED_SYM(___S__23__23_type_2d_33_2d_d05e0aa7_2d_e235_2d_441d_2d_aa41_2d_c1ac02065460)
___NEED_SYM(___S__23__23_type_2d_4_2d_54dfbc02_2d_718d_2d_4a34_2d_91ab_2d_d1861da7500a)
___NEED_SYM(___S__23__23_type_2d_4_2d_9f09b552_2d_0fb7_2d_42c5_2d_b0d4_2d_212155841d53)
___NEED_SYM(___S__23__23_type_2d_4_2d_c1fc166b_2d_d951_2d_4871_2d_853c_2d_2b6c8c12d28d)
___NEED_SYM(___S__23__23_type_2d_4_2d_cf06eccd_2d_bf2c_2d_4b30_2d_a6ce_2d_394b345a0dee)
___NEED_SYM(___S__23__23_type_2d_4_2d_f39d07ce_2d_436d_2d_40ca_2d_b81f_2d_cdc65d16b7f2)
___NEED_SYM(___S__23__23_type_2d_5)
___NEED_SYM(___S___kernel)
___NEED_SYM(___S_arg_2d_num)
___NEED_SYM(___S_arguments)
___NEED_SYM(___S_btq_2d_color)
___NEED_SYM(___S_btq_2d_container)
___NEED_SYM(___S_btq_2d_deq_2d_next)
___NEED_SYM(___S_btq_2d_deq_2d_prev)
___NEED_SYM(___S_btq_2d_left)
___NEED_SYM(___S_btq_2d_leftmost)
___NEED_SYM(___S_btq_2d_parent)
___NEED_SYM(___S_cfun_2d_conversion_2d_exception)
___NEED_SYM(___S_code)
___NEED_SYM(___S_cont)
___NEED_SYM(___S_denv)
___NEED_SYM(___S_denv_2d_cache1)
___NEED_SYM(___S_denv_2d_cache2)
___NEED_SYM(___S_denv_2d_cache3)
___NEED_SYM(___S_end_2d_condvar)
___NEED_SYM(___S_exception)
___NEED_SYM(___S_exception_3f_)
___NEED_SYM(___S_fields)
___NEED_SYM(___S_flags)
___NEED_SYM(___S_floats)
___NEED_SYM(___S_foreign)
___NEED_SYM(___S_heap_2d_overflow_2d_exception)
___NEED_SYM(___S_id)
___NEED_SYM(___S_interrupts)
___NEED_SYM(___S_keyword_2d_expected_2d_exception)
___NEED_SYM(___S_last_2d_processor)
___NEED_SYM(___S_lock1)
___NEED_SYM(___S_lock2)
___NEED_SYM(___S_mailbox)
___NEED_SYM(___S_message)
___NEED_SYM(___S_module_2d_not_2d_found_2d_exception)
___NEED_SYM(___S_multiple_2d_c_2d_return_2d_exception)
___NEED_SYM(___S_name)
___NEED_SYM(___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___NEED_SYM(___S_nonprocedure_2d_operator_2d_exception)
___NEED_SYM(___S_not_2d_started)
___NEED_SYM(___S_number_2d_of_2d_arguments_2d_limit_2d_exception)
___NEED_SYM(___S_operator)
___NEED_SYM(___S_os_2d_exception)
___NEED_SYM(___S_procedure)
___NEED_SYM(___S_repl_2d_channel)
___NEED_SYM(___S_result)
___NEED_SYM(___S_resume_2d_thunk)
___NEED_SYM(___S_rte)
___NEED_SYM(___S_sfun_2d_conversion_2d_exception)
___NEED_SYM(___S_specific)
___NEED_SYM(___S_stack_2d_overflow_2d_exception)
___NEED_SYM(___S_super)
___NEED_SYM(___S_tgroup)
___NEED_SYM(___S_thread)
___NEED_SYM(___S_threads_2d_deq_2d_next)
___NEED_SYM(___S_threads_2d_deq_2d_prev)
___NEED_SYM(___S_toq_2d_color)
___NEED_SYM(___S_toq_2d_container)
___NEED_SYM(___S_toq_2d_left)
___NEED_SYM(___S_toq_2d_leftmost)
___NEED_SYM(___S_toq_2d_parent)
___NEED_SYM(___S_type)
___NEED_SYM(___S_type_2d_exception)
___NEED_SYM(___S_type_2d_id)
___NEED_SYM(___S_unknown_2d_keyword_2d_argument_2d_exception)
___NEED_SYM(___S_void_2a_)
___NEED_SYM(___S_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___NEED_SYM(___S_wrong_2d_processor_2d_c_2d_return_2d_exception)

___NEED_GLO(___G__23__23_actlog_2d_dump)
___NEED_GLO(___G__23__23_actlog_2d_start)
___NEED_GLO(___G__23__23_actlog_2d_stop)
___NEED_GLO(___G__23__23_add_2d_exit_2d_job_21_)
___NEED_GLO(___G__23__23_add_2d_gc_2d_interrupt_2d_job_21_)
___NEED_GLO(___G__23__23_add_2d_job_21_)
___NEED_GLO(___G__23__23_add_2d_job_2d_at_2d_tail_21_)
___NEED_GLO(___G__23__23_apply)
___NEED_GLO(___G__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary)
___NEED_GLO(___G__23__23_apply_2d_with_2d_procedure_2d_check)
___NEED_GLO(___G__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary)
___NEED_GLO(___G__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
___NEED_GLO(___G__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___NEED_GLO(___G__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___NEED_GLO(___G__23__23_assq)
___NEED_GLO(___G__23__23_assq_2d_cdr)
___NEED_GLO(___G__23__23_bignum_2e_adigit_2d_width)
___NEED_GLO(___G__23__23_bignum_2e_fdigit_2d_width)
___NEED_GLO(___G__23__23_bignum_2e_mdigit_2d_width)
___NEED_GLO(___G__23__23_c_2d_return_2d_on_2d_other_2d_processor)
___NEED_GLO(___G__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook)
___NEED_GLO(___G__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_)
___NEED_GLO(___G__23__23_check_2d_heap)
___NEED_GLO(___G__23__23_check_2d_heap_2d_limit)
___NEED_GLO(___G__23__23_clear_2d_exit_2d_jobs_21_)
___NEED_GLO(___G__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_)
___NEED_GLO(___G__23__23_clear_2d_jobs_21_)
___NEED_GLO(___G__23__23_closure_2d_code)
___NEED_GLO(___G__23__23_closure_2d_length)
___NEED_GLO(___G__23__23_closure_2d_ref)
___NEED_GLO(___G__23__23_closure_2d_set_21_)
___NEED_GLO(___G__23__23_closure_3f_)
___NEED_GLO(___G__23__23_command_2d_line)
___NEED_GLO(___G__23__23_continuation_2d_copy)
___NEED_GLO(___G__23__23_continuation_2d_denv)
___NEED_GLO(___G__23__23_continuation_2d_denv_2d_set_21_)
___NEED_GLO(___G__23__23_continuation_2d_frame)
___NEED_GLO(___G__23__23_continuation_2d_frame_2d_set_21_)
___NEED_GLO(___G__23__23_continuation_2d_fs)
___NEED_GLO(___G__23__23_continuation_2d_last)
___NEED_GLO(___G__23__23_continuation_2d_link)
___NEED_GLO(___G__23__23_continuation_2d_next)
___NEED_GLO(___G__23__23_continuation_2d_next_21_)
___NEED_GLO(___G__23__23_continuation_2d_ref)
___NEED_GLO(___G__23__23_continuation_2d_ret)
___NEED_GLO(___G__23__23_continuation_2d_set_21_)
___NEED_GLO(___G__23__23_continuation_2d_slot_2d_live_3f_)
___NEED_GLO(___G__23__23_core_2d_count)
___NEED_GLO(___G__23__23_cpu_2d_cache_2d_size)
___NEED_GLO(___G__23__23_cpu_2d_count)
___NEED_GLO(___G__23__23_create_2d_module)
___NEED_GLO(___G__23__23_current_2d_vm_2d_processor_2d_count)
___NEED_GLO(___G__23__23_current_2d_vm_2d_resize)
___NEED_GLO(___G__23__23_default_2d_load_2d_required_2d_module)
___NEED_GLO(___G__23__23_device_2d_select_2d_abort_21_)
___NEED_GLO(___G__23__23_direct_2d_structure_2d_cas_21_)
___NEED_GLO(___G__23__23_direct_2d_structure_2d_ref)
___NEED_GLO(___G__23__23_direct_2d_structure_2d_set_21_)
___NEED_GLO(___G__23__23_disable_2d_interrupts_21_)
___NEED_GLO(___G__23__23_dynamic_2d_env_2d_bind)
___NEED_GLO(___G__23__23_enable_2d_interrupts_21_)
___NEED_GLO(___G__23__23_err_2d_code_2d_EAGAIN)
___NEED_GLO(___G__23__23_err_2d_code_2d_EINTR)
___NEED_GLO(___G__23__23_err_2d_code_2d_ENOENT)
___NEED_GLO(___G__23__23_err_2d_code_2d_unimplemented)
___NEED_GLO(___G__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
___NEED_GLO(___G__23__23_execute_2d_final_2d_wills_21_)
___NEED_GLO(___G__23__23_execute_2d_jobs_21_)
___NEED_GLO(___G__23__23_exit)
___NEED_GLO(___G__23__23_exit_2d_abnormally)
___NEED_GLO(___G__23__23_exit_2d_cleanup)
___NEED_GLO(___G__23__23_exit_2d_jobs)
___NEED_GLO(___G__23__23_exit_2d_with_2d_err_2d_code)
___NEED_GLO(___G__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup)
___NEED_GLO(___G__23__23_exit_2d_with_2d_exception)
___NEED_GLO(___G__23__23_explode_2d_continuation)
___NEED_GLO(___G__23__23_explode_2d_frame)
___NEED_GLO(___G__23__23_extract_2d_procedure_2d_and_2d_arguments)
___NEED_GLO(___G__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_foreign)
___NEED_GLO(___G__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_os_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_type_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___NEED_GLO(___G__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
___NEED_GLO(___G__23__23_final_2d_will_2d_registry)
___NEED_GLO(___G__23__23_find_2d_interned_2d_keyword)
___NEED_GLO(___G__23__23_find_2d_interned_2d_symbol)
___NEED_GLO(___G__23__23_find_2d_interned_2d_symkey)
___NEED_GLO(___G__23__23_first_2d_argument)
___NEED_GLO(___G__23__23_fixnum_2d_width)
___NEED_GLO(___G__23__23_fixnum_2d_width_2d_neg)
___NEED_GLO(___G__23__23_force_2d_undetermined)
___NEED_GLO(___G__23__23_foreign_2d_address)
___NEED_GLO(___G__23__23_foreign_2d_release_21_)
___NEED_GLO(___G__23__23_foreign_2d_released_3f_)
___NEED_GLO(___G__23__23_foreign_2d_tags)
___NEED_GLO(___G__23__23_format_2d_filepos)
___NEED_GLO(___G__23__23_frame_2d_fs)
___NEED_GLO(___G__23__23_frame_2d_link)
___NEED_GLO(___G__23__23_frame_2d_ref)
___NEED_GLO(___G__23__23_frame_2d_ret)
___NEED_GLO(___G__23__23_frame_2d_set_21_)
___NEED_GLO(___G__23__23_frame_2d_slot_2d_live_3f_)
___NEED_GLO(___G__23__23_gc)
___NEED_GLO(___G__23__23_gc_2d_final_2d_will_2d_registry_21_)
___NEED_GLO(___G__23__23_gc_2d_finalize_21_)
___NEED_GLO(___G__23__23_gc_2d_interrupt_2d_jobs)
___NEED_GLO(___G__23__23_gc_2d_without_2d_exceptions)
___NEED_GLO(___G__23__23_get_2d_bytes_2d_allocated_21_)
___NEED_GLO(___G__23__23_get_2d_current_2d_time_21_)
___NEED_GLO(___G__23__23_get_2d_heartbeat_2d_interval_21_)
___NEED_GLO(___G__23__23_get_2d_live_2d_percent)
___NEED_GLO(___G__23__23_get_2d_max_2d_heap)
___NEED_GLO(___G__23__23_get_2d_min_2d_heap)
___NEED_GLO(___G__23__23_get_2d_monotonic_2d_time_21_)
___NEED_GLO(___G__23__23_get_2d_monotonic_2d_time_2d_frequency_21_)
___NEED_GLO(___G__23__23_get_2d_parallelism_2d_level)
___NEED_GLO(___G__23__23_get_2d_standard_2d_level)
___NEED_GLO(___G__23__23_global_2d_var_2d__3e_identifier)
___NEED_GLO(___G__23__23_global_2d_var_2d_primitive_2d_ref)
___NEED_GLO(___G__23__23_global_2d_var_2d_primitive_2d_set_21_)
___NEED_GLO(___G__23__23_global_2d_var_2d_ref)
___NEED_GLO(___G__23__23_global_2d_var_2d_set_21_)
___NEED_GLO(___G__23__23_global_2d_var_3f_)
___NEED_GLO(___G__23__23_handle_2d_gc_2d_interrupt_21_)
___NEED_GLO(___G__23__23_interrupt_2d_handler)
___NEED_GLO(___G__23__23_interrupt_2d_vector)
___NEED_GLO(___G__23__23_interrupt_2d_vector_2d_set_21_)
___NEED_GLO(___G__23__23_kernel_2d_handlers)
___NEED_GLO(___G__23__23_keyword_2d_table)
___NEED_GLO(___G__23__23_load_2d_required_2d_module)
___NEED_GLO(___G__23__23_load_2d_required_2d_module_2d_set_21_)
___NEED_GLO(___G__23__23_load_2d_required_2d_module_2d_structs)
___NEED_GLO(___G__23__23_load_2d_vm)
___NEED_GLO(___G__23__23_lookup_2d_module)
___NEED_GLO(___G__23__23_lookup_2d_registered_2d_module)
___NEED_GLO(___G__23__23_machine_2d_code_2d_block_2d_exec)
___NEED_GLO(___G__23__23_machine_2d_code_2d_block_2d_fixup)
___NEED_GLO(___G__23__23_machine_2d_code_2d_block_2d_ref)
___NEED_GLO(___G__23__23_machine_2d_code_2d_block_2d_set_21_)
___NEED_GLO(___G__23__23_machine_2d_code_2d_fixup)
___NEED_GLO(___G__23__23_main)
___NEED_GLO(___G__23__23_main_2d_set_21_)
___NEED_GLO(___G__23__23_make_2d_closure)
___NEED_GLO(___G__23__23_make_2d_continuation)
___NEED_GLO(___G__23__23_make_2d_f32vector)
___NEED_GLO(___G__23__23_make_2d_f64vector)
___NEED_GLO(___G__23__23_make_2d_final_2d_will)
___NEED_GLO(___G__23__23_make_2d_frame)
___NEED_GLO(___G__23__23_make_2d_global_2d_var)
___NEED_GLO(___G__23__23_make_2d_interned_2d_keyword)
___NEED_GLO(___G__23__23_make_2d_interned_2d_symbol)
___NEED_GLO(___G__23__23_make_2d_interned_2d_symkey)
___NEED_GLO(___G__23__23_make_2d_jobs)
___NEED_GLO(___G__23__23_make_2d_machine_2d_code_2d_block)
___NEED_GLO(___G__23__23_make_2d_promise)
___NEED_GLO(___G__23__23_make_2d_s16vector)
___NEED_GLO(___G__23__23_make_2d_s32vector)
___NEED_GLO(___G__23__23_make_2d_s64vector)
___NEED_GLO(___G__23__23_make_2d_s8vector)
___NEED_GLO(___G__23__23_make_2d_string)
___NEED_GLO(___G__23__23_make_2d_structure)
___NEED_GLO(___G__23__23_make_2d_subprocedure)
___NEED_GLO(___G__23__23_make_2d_u16vector)
___NEED_GLO(___G__23__23_make_2d_u32vector)
___NEED_GLO(___G__23__23_make_2d_u64vector)
___NEED_GLO(___G__23__23_make_2d_u8vector)
___NEED_GLO(___G__23__23_make_2d_values)
___NEED_GLO(___G__23__23_make_2d_vector)
___NEED_GLO(___G__23__23_max_2d_char)
___NEED_GLO(___G__23__23_max_2d_fixnum)
___NEED_GLO(___G__23__23_min_2d_fixnum)
___NEED_GLO(___G__23__23_module_2d_init)
___NEED_GLO(___G__23__23_object_2d__3e_global_2d_var)
___NEED_GLO(___G__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
___NEED_GLO(___G__23__23_os_2d_address_2d_infos)
___NEED_GLO(___G__23__23_os_2d_bat_2d_extension_2d_string_2d_saved)
___NEED_GLO(___G__23__23_os_2d_condvar_2d_select_21_)
___NEED_GLO(___G__23__23_os_2d_configure_2d_command_2d_string_2d_saved)
___NEED_GLO(___G__23__23_os_2d_copy_2d_file)
___NEED_GLO(___G__23__23_os_2d_create_2d_directory)
___NEED_GLO(___G__23__23_os_2d_create_2d_fifo)
___NEED_GLO(___G__23__23_os_2d_create_2d_link)
___NEED_GLO(___G__23__23_os_2d_create_2d_symbolic_2d_link)
___NEED_GLO(___G__23__23_os_2d_delete_2d_directory)
___NEED_GLO(___G__23__23_os_2d_delete_2d_file)
___NEED_GLO(___G__23__23_os_2d_device_2d_close)
___NEED_GLO(___G__23__23_os_2d_device_2d_directory_2d_open_2d_path)
___NEED_GLO(___G__23__23_os_2d_device_2d_directory_2d_read)
___NEED_GLO(___G__23__23_os_2d_device_2d_event_2d_queue_2d_open)
___NEED_GLO(___G__23__23_os_2d_device_2d_event_2d_queue_2d_read)
___NEED_GLO(___G__23__23_os_2d_device_2d_force_2d_output)
___NEED_GLO(___G__23__23_os_2d_device_2d_kind)
___NEED_GLO(___G__23__23_os_2d_device_2d_open_2d_raw_2d_from_2d_fd)
___NEED_GLO(___G__23__23_os_2d_device_2d_process_2d_pid)
___NEED_GLO(___G__23__23_os_2d_device_2d_process_2d_status)
___NEED_GLO(___G__23__23_os_2d_device_2d_stream_2d_default_2d_options)
___NEED_GLO(___G__23__23_os_2d_device_2d_stream_2d_open_2d_path)
___NEED_GLO(___G__23__23_os_2d_device_2d_stream_2d_open_2d_predefined)
___NEED_GLO(___G__23__23_os_2d_device_2d_stream_2d_open_2d_process)
___NEED_GLO(___G__23__23_os_2d_device_2d_stream_2d_options_2d_set_21_)
___NEED_GLO(___G__23__23_os_2d_device_2d_stream_2d_read)
___NEED_GLO(___G__23__23_os_2d_device_2d_stream_2d_seek)
___NEED_GLO(___G__23__23_os_2d_device_2d_stream_2d_width)
___NEED_GLO(___G__23__23_os_2d_device_2d_stream_2d_write)
___NEED_GLO(___G__23__23_os_2d_device_2d_tcp_2d_client_2d_open)
___NEED_GLO(___G__23__23_os_2d_device_2d_tcp_2d_client_2d_socket_2d_info)
___NEED_GLO(___G__23__23_os_2d_device_2d_tcp_2d_server_2d_open)
___NEED_GLO(___G__23__23_os_2d_device_2d_tcp_2d_server_2d_read)
___NEED_GLO(___G__23__23_os_2d_device_2d_tcp_2d_server_2d_socket_2d_info)
___NEED_GLO(___G__23__23_os_2d_device_2d_tty_2d_history)
___NEED_GLO(___G__23__23_os_2d_device_2d_tty_2d_history_2d_max_2d_length_2d_set_21_)
___NEED_GLO(___G__23__23_os_2d_device_2d_tty_2d_history_2d_set_21_)
___NEED_GLO(___G__23__23_os_2d_device_2d_tty_2d_mode_2d_set_21_)
___NEED_GLO(___G__23__23_os_2d_device_2d_tty_2d_paren_2d_balance_2d_duration_2d_set_21_)
___NEED_GLO(___G__23__23_os_2d_device_2d_tty_2d_text_2d_attributes_2d_set_21_)
___NEED_GLO(___G__23__23_os_2d_device_2d_tty_2d_type_2d_set_21_)
___NEED_GLO(___G__23__23_os_2d_device_2d_udp_2d_destination_2d_set_21_)
___NEED_GLO(___G__23__23_os_2d_device_2d_udp_2d_open)
___NEED_GLO(___G__23__23_os_2d_device_2d_udp_2d_read_2d_subu8vector)
___NEED_GLO(___G__23__23_os_2d_device_2d_udp_2d_socket_2d_info)
___NEED_GLO(___G__23__23_os_2d_device_2d_udp_2d_write_2d_subu8vector)
___NEED_GLO(___G__23__23_os_2d_environ)
___NEED_GLO(___G__23__23_os_2d_err_2d_code_2d__3e_string)
___NEED_GLO(___G__23__23_os_2d_exe_2d_extension_2d_string_2d_saved)
___NEED_GLO(___G__23__23_os_2d_file_2d_info)
___NEED_GLO(___G__23__23_os_2d_file_2d_times_2d_set_21_)
___NEED_GLO(___G__23__23_os_2d_getenv)
___NEED_GLO(___G__23__23_os_2d_getpid)
___NEED_GLO(___G__23__23_os_2d_getppid)
___NEED_GLO(___G__23__23_os_2d_group_2d_info)
___NEED_GLO(___G__23__23_os_2d_host_2d_info)
___NEED_GLO(___G__23__23_os_2d_host_2d_name)
___NEED_GLO(___G__23__23_os_2d_load_2d_object_2d_file)
___NEED_GLO(___G__23__23_os_2d_make_2d_tls_2d_context)
___NEED_GLO(___G__23__23_os_2d_network_2d_info)
___NEED_GLO(___G__23__23_os_2d_obj_2d_extension_2d_string_2d_saved)
___NEED_GLO(___G__23__23_os_2d_path_2d_gambitdir)
___NEED_GLO(___G__23__23_os_2d_path_2d_gambitdir_2d_map_2d_lookup)
___NEED_GLO(___G__23__23_os_2d_path_2d_homedir)
___NEED_GLO(___G__23__23_os_2d_path_2d_normalize_2d_directory)
___NEED_GLO(___G__23__23_os_2d_protocol_2d_info)
___NEED_GLO(___G__23__23_os_2d_rename_2d_file)
___NEED_GLO(___G__23__23_os_2d_service_2d_info)
___NEED_GLO(___G__23__23_os_2d_set_2d_current_2d_directory)
___NEED_GLO(___G__23__23_os_2d_setenv)
___NEED_GLO(___G__23__23_os_2d_shell_2d_command)
___NEED_GLO(___G__23__23_os_2d_system_2d_type_2d_saved)
___NEED_GLO(___G__23__23_os_2d_system_2d_type_2d_string_2d_saved)
___NEED_GLO(___G__23__23_os_2d_user_2d_info)
___NEED_GLO(___G__23__23_os_2d_user_2d_name)
___NEED_GLO(___G__23__23_process_2d_statistics)
___NEED_GLO(___G__23__23_process_2d_times)
___NEED_GLO(___G__23__23_processed_2d_command_2d_line)
___NEED_GLO(___G__23__23_processed_2d_command_2d_line_2d_set_21_)
___NEED_GLO(___G__23__23_program_2d_descr)
___NEED_GLO(___G__23__23_promise_2d_result)
___NEED_GLO(___G__23__23_promise_2d_result_2d_set_21_)
___NEED_GLO(___G__23__23_promise_2d_thunk)
___NEED_GLO(___G__23__23_promise_2d_thunk_2d_set_21_)
___NEED_GLO(___G__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
___NEED_GLO(___G__23__23_raise_2d_heap_2d_overflow_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_high_2d_level_2d_interrupt_21_)
___NEED_GLO(___G__23__23_raise_2d_keyword_2d_expected_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary)
___NEED_GLO(___G__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_os_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_sfun_2d_conversion_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_stack_2d_overflow_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_type_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary)
___NEED_GLO(___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___NEED_GLO(___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary)
___NEED_GLO(___G__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
___NEED_GLO(___G__23__23_register_2d_module_2d_descr_21_)
___NEED_GLO(___G__23__23_register_2d_module_2d_descrs_21_)
___NEED_GLO(___G__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
___NEED_GLO(___G__23__23_registered_2d_modules)
___NEED_GLO(___G__23__23_remote_2d_dbg_2d_addr)
___NEED_GLO(___G__23__23_rest_2d_param_2d_check_2d_heap)
___NEED_GLO(___G__23__23_rest_2d_param_2d_heap_2d_overflow)
___NEED_GLO(___G__23__23_rest_2d_param_2d_resume_2d_procedure)
___NEED_GLO(___G__23__23_return_2d_fs)
___NEED_GLO(___G__23__23_rpc_2d_server_2d_addr)
___NEED_GLO(___G__23__23_set_2d_debug_2d_settings_21_)
___NEED_GLO(___G__23__23_set_2d_gambitdir_21_)
___NEED_GLO(___G__23__23_set_2d_heartbeat_2d_interval_21_)
___NEED_GLO(___G__23__23_set_2d_live_2d_percent_21_)
___NEED_GLO(___G__23__23_set_2d_max_2d_heap_21_)
___NEED_GLO(___G__23__23_set_2d_min_2d_heap_21_)
___NEED_GLO(___G__23__23_set_2d_parallelism_2d_level_21_)
___NEED_GLO(___G__23__23_set_2d_standard_2d_level_21_)
___NEED_GLO(___G__23__23_still_2d_copy)
___NEED_GLO(___G__23__23_still_2d_obj_2d_refcount_2d_dec_21_)
___NEED_GLO(___G__23__23_still_2d_obj_2d_refcount_2d_inc_21_)
___NEED_GLO(___G__23__23_structure)
___NEED_GLO(___G__23__23_structure_2d_cas_21_)
___NEED_GLO(___G__23__23_structure_2d_direct_2d_instance_2d_of_3f_)
___NEED_GLO(___G__23__23_structure_2d_instance_2d_of_3f_)
___NEED_GLO(___G__23__23_structure_2d_length)
___NEED_GLO(___G__23__23_structure_2d_ref)
___NEED_GLO(___G__23__23_structure_2d_set_21_)
___NEED_GLO(___G__23__23_structure_2d_type)
___NEED_GLO(___G__23__23_structure_2d_type_2d_set_21_)
___NEED_GLO(___G__23__23_subprocedure_2d_id)
___NEED_GLO(___G__23__23_subprocedure_2d_nb_2d_closed)
___NEED_GLO(___G__23__23_subprocedure_2d_nb_2d_parameters)
___NEED_GLO(___G__23__23_subprocedure_2d_parent)
___NEED_GLO(___G__23__23_subprocedure_2d_parent_2d_info)
___NEED_GLO(___G__23__23_subprocedure_2d_parent_2d_name)
___NEED_GLO(___G__23__23_subprocedure_3f_)
___NEED_GLO(___G__23__23_symbol_2d_table)
___NEED_GLO(___G__23__23_sync_2d_op_2d_interrupt_21_)
___NEED_GLO(___G__23__23_system_2d_stamp)
___NEED_GLO(___G__23__23_system_2d_stamp_2d_saved)
___NEED_GLO(___G__23__23_system_2d_version)
___NEED_GLO(___G__23__23_system_2d_version_2d_string)
___NEED_GLO(___G__23__23_type_2d_fields)
___NEED_GLO(___G__23__23_type_2d_flags)
___NEED_GLO(___G__23__23_type_2d_id)
___NEED_GLO(___G__23__23_type_2d_name)
___NEED_GLO(___G__23__23_type_2d_super)
___NEED_GLO(___G__23__23_type_2d_type)
___NEED_GLO(___G__23__23_type_3f_)
___NEED_GLO(___G__23__23_unchecked_2d_structure_2d_cas_21_)
___NEED_GLO(___G__23__23_unchecked_2d_structure_2d_ref)
___NEED_GLO(___G__23__23_unchecked_2d_structure_2d_set_21_)
___NEED_GLO(___G__23__23_values_2d_length)
___NEED_GLO(___G__23__23_values_2d_ref)
___NEED_GLO(___G__23__23_values_2d_set_21_)
___NEED_GLO(___G__23__23_vm_2d_main_2d_module_2d_id)
___NEED_GLO(___G__23__23_with_2d_no_2d_result_2d_expected)
___NEED_GLO(___G__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel)
___NEED_GLO(___G___kernel_23_)
___NEED_GLO(___G___kernel_23_0)
___NEED_GLO(___G___kernel_23_1)
___NEED_GLO(___G___kernel_23_10)
___NEED_GLO(___G___kernel_23_11)
___NEED_GLO(___G___kernel_23_12)
___NEED_GLO(___G___kernel_23_13)
___NEED_GLO(___G___kernel_23_14)
___NEED_GLO(___G___kernel_23_15)
___NEED_GLO(___G___kernel_23_16)
___NEED_GLO(___G___kernel_23_17)
___NEED_GLO(___G___kernel_23_18)
___NEED_GLO(___G___kernel_23_19)
___NEED_GLO(___G___kernel_23_2)
___NEED_GLO(___G___kernel_23_20)
___NEED_GLO(___G___kernel_23_21)
___NEED_GLO(___G___kernel_23_22)
___NEED_GLO(___G___kernel_23_23)
___NEED_GLO(___G___kernel_23_24)
___NEED_GLO(___G___kernel_23_25)
___NEED_GLO(___G___kernel_23_26)
___NEED_GLO(___G___kernel_23_27)
___NEED_GLO(___G___kernel_23_28)
___NEED_GLO(___G___kernel_23_29)
___NEED_GLO(___G___kernel_23_3)
___NEED_GLO(___G___kernel_23_30)
___NEED_GLO(___G___kernel_23_31)
___NEED_GLO(___G___kernel_23_32)
___NEED_GLO(___G___kernel_23_33)
___NEED_GLO(___G___kernel_23_34)
___NEED_GLO(___G___kernel_23_35)
___NEED_GLO(___G___kernel_23_36)
___NEED_GLO(___G___kernel_23_37)
___NEED_GLO(___G___kernel_23_38)
___NEED_GLO(___G___kernel_23_39)
___NEED_GLO(___G___kernel_23_4)
___NEED_GLO(___G___kernel_23_40)
___NEED_GLO(___G___kernel_23_41)
___NEED_GLO(___G___kernel_23_42)
___NEED_GLO(___G___kernel_23_43)
___NEED_GLO(___G___kernel_23_44)
___NEED_GLO(___G___kernel_23_45)
___NEED_GLO(___G___kernel_23_46)
___NEED_GLO(___G___kernel_23_47)
___NEED_GLO(___G___kernel_23_48)
___NEED_GLO(___G___kernel_23_49)
___NEED_GLO(___G___kernel_23_5)
___NEED_GLO(___G___kernel_23_50)
___NEED_GLO(___G___kernel_23_51)
___NEED_GLO(___G___kernel_23_52)
___NEED_GLO(___G___kernel_23_53)
___NEED_GLO(___G___kernel_23_54)
___NEED_GLO(___G___kernel_23_55)
___NEED_GLO(___G___kernel_23_56)
___NEED_GLO(___G___kernel_23_57)
___NEED_GLO(___G___kernel_23_58)
___NEED_GLO(___G___kernel_23_59)
___NEED_GLO(___G___kernel_23_6)
___NEED_GLO(___G___kernel_23_60)
___NEED_GLO(___G___kernel_23_61)
___NEED_GLO(___G___kernel_23_62)
___NEED_GLO(___G___kernel_23_63)
___NEED_GLO(___G___kernel_23_64)
___NEED_GLO(___G___kernel_23_65)
___NEED_GLO(___G___kernel_23_66)
___NEED_GLO(___G___kernel_23_67)
___NEED_GLO(___G___kernel_23_68)
___NEED_GLO(___G___kernel_23_69)
___NEED_GLO(___G___kernel_23_7)
___NEED_GLO(___G___kernel_23_70)
___NEED_GLO(___G___kernel_23_71)
___NEED_GLO(___G___kernel_23_72)
___NEED_GLO(___G___kernel_23_73)
___NEED_GLO(___G___kernel_23_74)
___NEED_GLO(___G___kernel_23_75)
___NEED_GLO(___G___kernel_23_76)
___NEED_GLO(___G___kernel_23_77)
___NEED_GLO(___G___kernel_23_78)
___NEED_GLO(___G___kernel_23_79)
___NEED_GLO(___G___kernel_23_8)
___NEED_GLO(___G___kernel_23_80)
___NEED_GLO(___G___kernel_23_81)
___NEED_GLO(___G___kernel_23_82)
___NEED_GLO(___G___kernel_23_83)
___NEED_GLO(___G___kernel_23_84)
___NEED_GLO(___G___kernel_23_85)
___NEED_GLO(___G___kernel_23_86)
___NEED_GLO(___G___kernel_23_87)
___NEED_GLO(___G___kernel_23_88)
___NEED_GLO(___G___kernel_23_89)
___NEED_GLO(___G___kernel_23_9)
___NEED_GLO(___G___kernel_23_90)
___NEED_GLO(___G___kernel_23_91)
___NEED_GLO(___G___kernel_23_92)
___NEED_GLO(___G_cfun_2d_conversion_2d_exception_2d_arguments)
___NEED_GLO(___G_cfun_2d_conversion_2d_exception_2d_code)
___NEED_GLO(___G_cfun_2d_conversion_2d_exception_2d_message)
___NEED_GLO(___G_cfun_2d_conversion_2d_exception_2d_procedure)
___NEED_GLO(___G_cfun_2d_conversion_2d_exception_3f_)
___NEED_GLO(___G_configure_2d_command_2d_string)
___NEED_GLO(___G_err_2d_code_2d__3e_string)
___NEED_GLO(___G_foreign_2d_address)
___NEED_GLO(___G_foreign_2d_release_21_)
___NEED_GLO(___G_foreign_2d_released_3f_)
___NEED_GLO(___G_foreign_2d_tags)
___NEED_GLO(___G_foreign_3f_)
___NEED_GLO(___G_heap_2d_overflow_2d_exception_3f_)
___NEED_GLO(___G_keyword_2d_expected_2d_exception_2d_arguments)
___NEED_GLO(___G_keyword_2d_expected_2d_exception_2d_procedure)
___NEED_GLO(___G_keyword_2d_expected_2d_exception_3f_)
___NEED_GLO(___G_module_2d_not_2d_found_2d_exception_2d_arguments)
___NEED_GLO(___G_module_2d_not_2d_found_2d_exception_2d_procedure)
___NEED_GLO(___G_module_2d_not_2d_found_2d_exception_3f_)
___NEED_GLO(___G_multiple_2d_c_2d_return_2d_exception_3f_)
___NEED_GLO(___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
___NEED_GLO(___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
___NEED_GLO(___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_)
___NEED_GLO(___G_nonprocedure_2d_operator_2d_exception_2d_arguments)
___NEED_GLO(___G_nonprocedure_2d_operator_2d_exception_2d_code)
___NEED_GLO(___G_nonprocedure_2d_operator_2d_exception_2d_operator)
___NEED_GLO(___G_nonprocedure_2d_operator_2d_exception_2d_rte)
___NEED_GLO(___G_nonprocedure_2d_operator_2d_exception_3f_)
___NEED_GLO(___G_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
___NEED_GLO(___G_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
___NEED_GLO(___G_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_)
___NEED_GLO(___G_os_2d_exception_2d_arguments)
___NEED_GLO(___G_os_2d_exception_2d_code)
___NEED_GLO(___G_os_2d_exception_2d_message)
___NEED_GLO(___G_os_2d_exception_2d_procedure)
___NEED_GLO(___G_os_2d_exception_3f_)
___NEED_GLO(___G_sfun_2d_conversion_2d_exception_2d_arguments)
___NEED_GLO(___G_sfun_2d_conversion_2d_exception_2d_code)
___NEED_GLO(___G_sfun_2d_conversion_2d_exception_2d_message)
___NEED_GLO(___G_sfun_2d_conversion_2d_exception_2d_procedure)
___NEED_GLO(___G_sfun_2d_conversion_2d_exception_3f_)
___NEED_GLO(___G_stack_2d_overflow_2d_exception_3f_)
___NEED_GLO(___G_system_2d_stamp)
___NEED_GLO(___G_system_2d_type)
___NEED_GLO(___G_system_2d_type_2d_string)
___NEED_GLO(___G_system_2d_version)
___NEED_GLO(___G_system_2d_version_2d_string)
___NEED_GLO(___G_type_2d_exception_2d_arg_2d_num)
___NEED_GLO(___G_type_2d_exception_2d_arguments)
___NEED_GLO(___G_type_2d_exception_2d_procedure)
___NEED_GLO(___G_type_2d_exception_2d_type_2d_id)
___NEED_GLO(___G_type_2d_exception_3f_)
___NEED_GLO(___G_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
___NEED_GLO(___G_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
___NEED_GLO(___G_unknown_2d_keyword_2d_argument_2d_exception_3f_)
___NEED_GLO(___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
___NEED_GLO(___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
___NEED_GLO(___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_)
___NEED_GLO(___G_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_)

___BEGIN_SYM
___DEF_SYM(0,___S__23__23_type_2d_0_2d_0bf9b656_2d_b071_2d_404a_2d_a514_2d_0fb9d05cf518,"##type-0-0bf9b656-b071-404a-a514-0fb9d05cf518")

___DEF_SYM(1,___S__23__23_type_2d_0_2d_73c66686_2d_a08f_2d_4c7c_2d_a0f1_2d_5ad7771f242a,"##type-0-73c66686-a08f-4c7c-a0f1-5ad7771f242a")

___DEF_SYM(2,___S__23__23_type_2d_0_2d_828142df_2d_e9a5_2d_4ed8_2d_a467_2d_2f4833525b3e,"##type-0-828142df-e9a5-4ed8-a467-2f4833525b3e")

___DEF_SYM(3,___S__23__23_type_2d_0_2d_d69cd396_2d_01e0_2d_4dcb_2d_87dc_2d_31acea8e0e5f,"##type-0-d69cd396-01e0-4dcb-87dc-31acea8e0e5f")

___DEF_SYM(4,___S__23__23_type_2d_0_2d_f512c9f6_2d_3b24_2d_4c5c_2d_8c8b_2d_cabd75b2f951,"##type-0-f512c9f6-3b24-4c5c-8c8b-cabd75b2f951")

___DEF_SYM(5,___S__23__23_type_2d_2_2d_2138cd7f_2d_8c42_2d_4164_2d_b56a_2d_a8c7badf3323,"##type-2-2138cd7f-8c42-4164-b56a-a8c7badf3323")

___DEF_SYM(6,___S__23__23_type_2d_2_2d_299ccee1_2d_77d2_2d_4a6d_2d_ab24_2d_2ebf14297315,"##type-2-299ccee1-77d2-4a6d-ab24-2ebf14297315")

___DEF_SYM(7,___S__23__23_type_2d_2_2d_3f9f8aaa_2d_ea21_2d_4f2b_2d_bc06_2d_f65950e6c408,"##type-2-3f9f8aaa-ea21-4f2b-bc06-f65950e6c408")

___DEF_SYM(8,___S__23__23_type_2d_2_2d_3fd6c57f_2d_3c80_2d_4436_2d_a430_2d_57ea4457c11e,"##type-2-3fd6c57f-3c80-4436-a430-57ea4457c11e")

___DEF_SYM(9,___S__23__23_type_2d_2_2d_CA9CA020_2d_600A_2d_4516_2d_AA78_2d_CBE91EC8BE14,"##type-2-CA9CA020-600A-4516-AA78-CBE91EC8BE14")

___DEF_SYM(10,___S__23__23_type_2d_2_2d_f9519b37_2d_d6d4_2d_4748_2d_8eb1_2d_a0c8dc18c5e7,"##type-2-f9519b37-d6d4-4748-8eb1-a0c8dc18c5e7")

___DEF_SYM(11,___S__23__23_type_2d_33_2d_d05e0aa7_2d_e235_2d_441d_2d_aa41_2d_c1ac02065460,"##type-33-d05e0aa7-e235-441d-aa41-c1ac02065460")

___DEF_SYM(12,___S__23__23_type_2d_4_2d_54dfbc02_2d_718d_2d_4a34_2d_91ab_2d_d1861da7500a,"##type-4-54dfbc02-718d-4a34-91ab-d1861da7500a")

___DEF_SYM(13,___S__23__23_type_2d_4_2d_9f09b552_2d_0fb7_2d_42c5_2d_b0d4_2d_212155841d53,"##type-4-9f09b552-0fb7-42c5-b0d4-212155841d53")

___DEF_SYM(14,___S__23__23_type_2d_4_2d_c1fc166b_2d_d951_2d_4871_2d_853c_2d_2b6c8c12d28d,"##type-4-c1fc166b-d951-4871-853c-2b6c8c12d28d")

___DEF_SYM(15,___S__23__23_type_2d_4_2d_cf06eccd_2d_bf2c_2d_4b30_2d_a6ce_2d_394b345a0dee,"##type-4-cf06eccd-bf2c-4b30-a6ce-394b345a0dee")

___DEF_SYM(16,___S__23__23_type_2d_4_2d_f39d07ce_2d_436d_2d_40ca_2d_b81f_2d_cdc65d16b7f2,"##type-4-f39d07ce-436d-40ca-b81f-cdc65d16b7f2")

___DEF_SYM(17,___S__23__23_type_2d_5,"##type-5")
___DEF_SYM(18,___S___kernel,"_kernel")
___DEF_SYM(19,___S_arg_2d_num,"arg-num")
___DEF_SYM(20,___S_arguments,"arguments")
___DEF_SYM(21,___S_btq_2d_color,"btq-color")
___DEF_SYM(22,___S_btq_2d_container,"btq-container")
___DEF_SYM(23,___S_btq_2d_deq_2d_next,"btq-deq-next")
___DEF_SYM(24,___S_btq_2d_deq_2d_prev,"btq-deq-prev")
___DEF_SYM(25,___S_btq_2d_left,"btq-left")
___DEF_SYM(26,___S_btq_2d_leftmost,"btq-leftmost")
___DEF_SYM(27,___S_btq_2d_parent,"btq-parent")
___DEF_SYM(28,___S_cfun_2d_conversion_2d_exception,"cfun-conversion-exception")
___DEF_SYM(29,___S_code,"code")
___DEF_SYM(30,___S_cont,"cont")
___DEF_SYM(31,___S_denv,"denv")
___DEF_SYM(32,___S_denv_2d_cache1,"denv-cache1")
___DEF_SYM(33,___S_denv_2d_cache2,"denv-cache2")
___DEF_SYM(34,___S_denv_2d_cache3,"denv-cache3")
___DEF_SYM(35,___S_end_2d_condvar,"end-condvar")
___DEF_SYM(36,___S_exception,"exception")
___DEF_SYM(37,___S_exception_3f_,"exception?")
___DEF_SYM(38,___S_fields,"fields")
___DEF_SYM(39,___S_flags,"flags")
___DEF_SYM(40,___S_floats,"floats")
___DEF_SYM(41,___S_foreign,"foreign")
___DEF_SYM(42,___S_heap_2d_overflow_2d_exception,"heap-overflow-exception")
___DEF_SYM(43,___S_id,"id")
___DEF_SYM(44,___S_interrupts,"interrupts")
___DEF_SYM(45,___S_keyword_2d_expected_2d_exception,"keyword-expected-exception")
___DEF_SYM(46,___S_last_2d_processor,"last-processor")
___DEF_SYM(47,___S_lock1,"lock1")
___DEF_SYM(48,___S_lock2,"lock2")
___DEF_SYM(49,___S_mailbox,"mailbox")
___DEF_SYM(50,___S_message,"message")
___DEF_SYM(51,___S_module_2d_not_2d_found_2d_exception,"module-not-found-exception")
___DEF_SYM(52,___S_multiple_2d_c_2d_return_2d_exception,"multiple-c-return-exception")
___DEF_SYM(53,___S_name,"name")
___DEF_SYM(54,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,"no-such-file-or-directory-exception")

___DEF_SYM(55,___S_nonprocedure_2d_operator_2d_exception,"nonprocedure-operator-exception")

___DEF_SYM(56,___S_not_2d_started,"not-started")
___DEF_SYM(57,___S_number_2d_of_2d_arguments_2d_limit_2d_exception,"number-of-arguments-limit-exception")

___DEF_SYM(58,___S_operator,"operator")
___DEF_SYM(59,___S_os_2d_exception,"os-exception")
___DEF_SYM(60,___S_procedure,"procedure")
___DEF_SYM(61,___S_repl_2d_channel,"repl-channel")
___DEF_SYM(62,___S_result,"result")
___DEF_SYM(63,___S_resume_2d_thunk,"resume-thunk")
___DEF_SYM(64,___S_rte,"rte")
___DEF_SYM(65,___S_sfun_2d_conversion_2d_exception,"sfun-conversion-exception")
___DEF_SYM(66,___S_specific,"specific")
___DEF_SYM(67,___S_stack_2d_overflow_2d_exception,"stack-overflow-exception")
___DEF_SYM(68,___S_super,"super")
___DEF_SYM(69,___S_tgroup,"tgroup")
___DEF_SYM(70,___S_thread,"thread")
___DEF_SYM(71,___S_threads_2d_deq_2d_next,"threads-deq-next")
___DEF_SYM(72,___S_threads_2d_deq_2d_prev,"threads-deq-prev")
___DEF_SYM(73,___S_toq_2d_color,"toq-color")
___DEF_SYM(74,___S_toq_2d_container,"toq-container")
___DEF_SYM(75,___S_toq_2d_left,"toq-left")
___DEF_SYM(76,___S_toq_2d_leftmost,"toq-leftmost")
___DEF_SYM(77,___S_toq_2d_parent,"toq-parent")
___DEF_SYM(78,___S_type,"type")
___DEF_SYM(79,___S_type_2d_exception,"type-exception")
___DEF_SYM(80,___S_type_2d_id,"type-id")
___DEF_SYM(81,___S_unknown_2d_keyword_2d_argument_2d_exception,"unknown-keyword-argument-exception")

___DEF_SYM(82,___S_void_2a_,"void*")
___DEF_SYM(83,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception,"wrong-number-of-arguments-exception")

___DEF_SYM(84,___S_wrong_2d_processor_2d_c_2d_return_2d_exception,"wrong-processor-c-return-exception")

___END_SYM

#define ___SYM__23__23_type_2d_0_2d_0bf9b656_2d_b071_2d_404a_2d_a514_2d_0fb9d05cf518 ___SYM(0,___S__23__23_type_2d_0_2d_0bf9b656_2d_b071_2d_404a_2d_a514_2d_0fb9d05cf518)
#define ___SYM__23__23_type_2d_0_2d_73c66686_2d_a08f_2d_4c7c_2d_a0f1_2d_5ad7771f242a ___SYM(1,___S__23__23_type_2d_0_2d_73c66686_2d_a08f_2d_4c7c_2d_a0f1_2d_5ad7771f242a)
#define ___SYM__23__23_type_2d_0_2d_828142df_2d_e9a5_2d_4ed8_2d_a467_2d_2f4833525b3e ___SYM(2,___S__23__23_type_2d_0_2d_828142df_2d_e9a5_2d_4ed8_2d_a467_2d_2f4833525b3e)
#define ___SYM__23__23_type_2d_0_2d_d69cd396_2d_01e0_2d_4dcb_2d_87dc_2d_31acea8e0e5f ___SYM(3,___S__23__23_type_2d_0_2d_d69cd396_2d_01e0_2d_4dcb_2d_87dc_2d_31acea8e0e5f)
#define ___SYM__23__23_type_2d_0_2d_f512c9f6_2d_3b24_2d_4c5c_2d_8c8b_2d_cabd75b2f951 ___SYM(4,___S__23__23_type_2d_0_2d_f512c9f6_2d_3b24_2d_4c5c_2d_8c8b_2d_cabd75b2f951)
#define ___SYM__23__23_type_2d_2_2d_2138cd7f_2d_8c42_2d_4164_2d_b56a_2d_a8c7badf3323 ___SYM(5,___S__23__23_type_2d_2_2d_2138cd7f_2d_8c42_2d_4164_2d_b56a_2d_a8c7badf3323)
#define ___SYM__23__23_type_2d_2_2d_299ccee1_2d_77d2_2d_4a6d_2d_ab24_2d_2ebf14297315 ___SYM(6,___S__23__23_type_2d_2_2d_299ccee1_2d_77d2_2d_4a6d_2d_ab24_2d_2ebf14297315)
#define ___SYM__23__23_type_2d_2_2d_3f9f8aaa_2d_ea21_2d_4f2b_2d_bc06_2d_f65950e6c408 ___SYM(7,___S__23__23_type_2d_2_2d_3f9f8aaa_2d_ea21_2d_4f2b_2d_bc06_2d_f65950e6c408)
#define ___SYM__23__23_type_2d_2_2d_3fd6c57f_2d_3c80_2d_4436_2d_a430_2d_57ea4457c11e ___SYM(8,___S__23__23_type_2d_2_2d_3fd6c57f_2d_3c80_2d_4436_2d_a430_2d_57ea4457c11e)
#define ___SYM__23__23_type_2d_2_2d_CA9CA020_2d_600A_2d_4516_2d_AA78_2d_CBE91EC8BE14 ___SYM(9,___S__23__23_type_2d_2_2d_CA9CA020_2d_600A_2d_4516_2d_AA78_2d_CBE91EC8BE14)
#define ___SYM__23__23_type_2d_2_2d_f9519b37_2d_d6d4_2d_4748_2d_8eb1_2d_a0c8dc18c5e7 ___SYM(10,___S__23__23_type_2d_2_2d_f9519b37_2d_d6d4_2d_4748_2d_8eb1_2d_a0c8dc18c5e7)
#define ___SYM__23__23_type_2d_33_2d_d05e0aa7_2d_e235_2d_441d_2d_aa41_2d_c1ac02065460 ___SYM(11,___S__23__23_type_2d_33_2d_d05e0aa7_2d_e235_2d_441d_2d_aa41_2d_c1ac02065460)
#define ___SYM__23__23_type_2d_4_2d_54dfbc02_2d_718d_2d_4a34_2d_91ab_2d_d1861da7500a ___SYM(12,___S__23__23_type_2d_4_2d_54dfbc02_2d_718d_2d_4a34_2d_91ab_2d_d1861da7500a)
#define ___SYM__23__23_type_2d_4_2d_9f09b552_2d_0fb7_2d_42c5_2d_b0d4_2d_212155841d53 ___SYM(13,___S__23__23_type_2d_4_2d_9f09b552_2d_0fb7_2d_42c5_2d_b0d4_2d_212155841d53)
#define ___SYM__23__23_type_2d_4_2d_c1fc166b_2d_d951_2d_4871_2d_853c_2d_2b6c8c12d28d ___SYM(14,___S__23__23_type_2d_4_2d_c1fc166b_2d_d951_2d_4871_2d_853c_2d_2b6c8c12d28d)
#define ___SYM__23__23_type_2d_4_2d_cf06eccd_2d_bf2c_2d_4b30_2d_a6ce_2d_394b345a0dee ___SYM(15,___S__23__23_type_2d_4_2d_cf06eccd_2d_bf2c_2d_4b30_2d_a6ce_2d_394b345a0dee)
#define ___SYM__23__23_type_2d_4_2d_f39d07ce_2d_436d_2d_40ca_2d_b81f_2d_cdc65d16b7f2 ___SYM(16,___S__23__23_type_2d_4_2d_f39d07ce_2d_436d_2d_40ca_2d_b81f_2d_cdc65d16b7f2)
#define ___SYM__23__23_type_2d_5 ___SYM(17,___S__23__23_type_2d_5)
#define ___SYM___kernel ___SYM(18,___S___kernel)
#define ___SYM_arg_2d_num ___SYM(19,___S_arg_2d_num)
#define ___SYM_arguments ___SYM(20,___S_arguments)
#define ___SYM_btq_2d_color ___SYM(21,___S_btq_2d_color)
#define ___SYM_btq_2d_container ___SYM(22,___S_btq_2d_container)
#define ___SYM_btq_2d_deq_2d_next ___SYM(23,___S_btq_2d_deq_2d_next)
#define ___SYM_btq_2d_deq_2d_prev ___SYM(24,___S_btq_2d_deq_2d_prev)
#define ___SYM_btq_2d_left ___SYM(25,___S_btq_2d_left)
#define ___SYM_btq_2d_leftmost ___SYM(26,___S_btq_2d_leftmost)
#define ___SYM_btq_2d_parent ___SYM(27,___S_btq_2d_parent)
#define ___SYM_cfun_2d_conversion_2d_exception ___SYM(28,___S_cfun_2d_conversion_2d_exception)
#define ___SYM_code ___SYM(29,___S_code)
#define ___SYM_cont ___SYM(30,___S_cont)
#define ___SYM_denv ___SYM(31,___S_denv)
#define ___SYM_denv_2d_cache1 ___SYM(32,___S_denv_2d_cache1)
#define ___SYM_denv_2d_cache2 ___SYM(33,___S_denv_2d_cache2)
#define ___SYM_denv_2d_cache3 ___SYM(34,___S_denv_2d_cache3)
#define ___SYM_end_2d_condvar ___SYM(35,___S_end_2d_condvar)
#define ___SYM_exception ___SYM(36,___S_exception)
#define ___SYM_exception_3f_ ___SYM(37,___S_exception_3f_)
#define ___SYM_fields ___SYM(38,___S_fields)
#define ___SYM_flags ___SYM(39,___S_flags)
#define ___SYM_floats ___SYM(40,___S_floats)
#define ___SYM_foreign ___SYM(41,___S_foreign)
#define ___SYM_heap_2d_overflow_2d_exception ___SYM(42,___S_heap_2d_overflow_2d_exception)
#define ___SYM_id ___SYM(43,___S_id)
#define ___SYM_interrupts ___SYM(44,___S_interrupts)
#define ___SYM_keyword_2d_expected_2d_exception ___SYM(45,___S_keyword_2d_expected_2d_exception)
#define ___SYM_last_2d_processor ___SYM(46,___S_last_2d_processor)
#define ___SYM_lock1 ___SYM(47,___S_lock1)
#define ___SYM_lock2 ___SYM(48,___S_lock2)
#define ___SYM_mailbox ___SYM(49,___S_mailbox)
#define ___SYM_message ___SYM(50,___S_message)
#define ___SYM_module_2d_not_2d_found_2d_exception ___SYM(51,___S_module_2d_not_2d_found_2d_exception)
#define ___SYM_multiple_2d_c_2d_return_2d_exception ___SYM(52,___S_multiple_2d_c_2d_return_2d_exception)
#define ___SYM_name ___SYM(53,___S_name)
#define ___SYM_no_2d_such_2d_file_2d_or_2d_directory_2d_exception ___SYM(54,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
#define ___SYM_nonprocedure_2d_operator_2d_exception ___SYM(55,___S_nonprocedure_2d_operator_2d_exception)
#define ___SYM_not_2d_started ___SYM(56,___S_not_2d_started)
#define ___SYM_number_2d_of_2d_arguments_2d_limit_2d_exception ___SYM(57,___S_number_2d_of_2d_arguments_2d_limit_2d_exception)
#define ___SYM_operator ___SYM(58,___S_operator)
#define ___SYM_os_2d_exception ___SYM(59,___S_os_2d_exception)
#define ___SYM_procedure ___SYM(60,___S_procedure)
#define ___SYM_repl_2d_channel ___SYM(61,___S_repl_2d_channel)
#define ___SYM_result ___SYM(62,___S_result)
#define ___SYM_resume_2d_thunk ___SYM(63,___S_resume_2d_thunk)
#define ___SYM_rte ___SYM(64,___S_rte)
#define ___SYM_sfun_2d_conversion_2d_exception ___SYM(65,___S_sfun_2d_conversion_2d_exception)
#define ___SYM_specific ___SYM(66,___S_specific)
#define ___SYM_stack_2d_overflow_2d_exception ___SYM(67,___S_stack_2d_overflow_2d_exception)
#define ___SYM_super ___SYM(68,___S_super)
#define ___SYM_tgroup ___SYM(69,___S_tgroup)
#define ___SYM_thread ___SYM(70,___S_thread)
#define ___SYM_threads_2d_deq_2d_next ___SYM(71,___S_threads_2d_deq_2d_next)
#define ___SYM_threads_2d_deq_2d_prev ___SYM(72,___S_threads_2d_deq_2d_prev)
#define ___SYM_toq_2d_color ___SYM(73,___S_toq_2d_color)
#define ___SYM_toq_2d_container ___SYM(74,___S_toq_2d_container)
#define ___SYM_toq_2d_left ___SYM(75,___S_toq_2d_left)
#define ___SYM_toq_2d_leftmost ___SYM(76,___S_toq_2d_leftmost)
#define ___SYM_toq_2d_parent ___SYM(77,___S_toq_2d_parent)
#define ___SYM_type ___SYM(78,___S_type)
#define ___SYM_type_2d_exception ___SYM(79,___S_type_2d_exception)
#define ___SYM_type_2d_id ___SYM(80,___S_type_2d_id)
#define ___SYM_unknown_2d_keyword_2d_argument_2d_exception ___SYM(81,___S_unknown_2d_keyword_2d_argument_2d_exception)
#define ___SYM_void_2a_ ___SYM(82,___S_void_2a_)
#define ___SYM_wrong_2d_number_2d_of_2d_arguments_2d_exception ___SYM(83,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception)
#define ___SYM_wrong_2d_processor_2d_c_2d_return_2d_exception ___SYM(84,___S_wrong_2d_processor_2d_c_2d_return_2d_exception)

___BEGIN_GLO
___DEF_GLO(0,"##actlog-dump")
___DEF_GLO(1,"##actlog-start")
___DEF_GLO(2,"##actlog-stop")
___DEF_GLO(3,"##add-exit-job!")
___DEF_GLO(4,"##add-gc-interrupt-job!")
___DEF_GLO(5,"##add-job!")
___DEF_GLO(6,"##add-job-at-tail!")
___DEF_GLO(7,"##apply")
___DEF_GLO(8,"##apply-global-with-procedure-check-nary")

___DEF_GLO(9,"##apply-with-procedure-check")
___DEF_GLO(10,"##apply-with-procedure-check-nary")

___DEF_GLO(11,"##argument-list-fix-rest-param!")
___DEF_GLO(12,"##argument-list-remove-absent!")
___DEF_GLO(13,"##argument-list-remove-absent-keys!")

___DEF_GLO(14,"##assq")
___DEF_GLO(15,"##assq-cdr")
___DEF_GLO(16,"##bignum.adigit-width")
___DEF_GLO(17,"##bignum.fdigit-width")
___DEF_GLO(18,"##bignum.mdigit-width")
___DEF_GLO(19,"##c-return-on-other-processor")
___DEF_GLO(20,"##c-return-on-other-processor-hook")

___DEF_GLO(21,"##c-return-on-other-processor-hook-set!")

___DEF_GLO(22,"##check-heap")
___DEF_GLO(23,"##check-heap-limit")
___DEF_GLO(24,"##clear-exit-jobs!")
___DEF_GLO(25,"##clear-gc-interrupt-jobs!")
___DEF_GLO(26,"##clear-jobs!")
___DEF_GLO(27,"##closure-code")
___DEF_GLO(28,"##closure-length")
___DEF_GLO(29,"##closure-ref")
___DEF_GLO(30,"##closure-set!")
___DEF_GLO(31,"##closure?")
___DEF_GLO(32,"##command-line")
___DEF_GLO(33,"##continuation-copy")
___DEF_GLO(34,"##continuation-denv")
___DEF_GLO(35,"##continuation-denv-set!")
___DEF_GLO(36,"##continuation-frame")
___DEF_GLO(37,"##continuation-frame-set!")
___DEF_GLO(38,"##continuation-fs")
___DEF_GLO(39,"##continuation-last")
___DEF_GLO(40,"##continuation-link")
___DEF_GLO(41,"##continuation-next")
___DEF_GLO(42,"##continuation-next!")
___DEF_GLO(43,"##continuation-ref")
___DEF_GLO(44,"##continuation-ret")
___DEF_GLO(45,"##continuation-set!")
___DEF_GLO(46,"##continuation-slot-live?")
___DEF_GLO(47,"##core-count")
___DEF_GLO(48,"##cpu-cache-size")
___DEF_GLO(49,"##cpu-count")
___DEF_GLO(50,"##create-module")
___DEF_GLO(51,"##current-vm-processor-count")
___DEF_GLO(52,"##current-vm-resize")
___DEF_GLO(53,"##default-load-required-module")
___DEF_GLO(54,"##device-select-abort!")
___DEF_GLO(55,"##direct-structure-cas!")
___DEF_GLO(56,"##direct-structure-ref")
___DEF_GLO(57,"##direct-structure-set!")
___DEF_GLO(58,"##disable-interrupts!")
___DEF_GLO(59,"##dynamic-env-bind")
___DEF_GLO(60,"##enable-interrupts!")
___DEF_GLO(61,"##err-code-EAGAIN")
___DEF_GLO(62,"##err-code-EINTR")
___DEF_GLO(63,"##err-code-ENOENT")
___DEF_GLO(64,"##err-code-unimplemented")
___DEF_GLO(65,"##execute-and-clear-jobs!")
___DEF_GLO(66,"##execute-final-wills!")
___DEF_GLO(67,"##execute-jobs!")
___DEF_GLO(68,"##exit")
___DEF_GLO(69,"##exit-abnormally")
___DEF_GLO(70,"##exit-cleanup")
___DEF_GLO(71,"##exit-jobs")
___DEF_GLO(72,"##exit-with-err-code")
___DEF_GLO(73,"##exit-with-err-code-no-cleanup")
___DEF_GLO(74,"##exit-with-exception")
___DEF_GLO(75,"##explode-continuation")
___DEF_GLO(76,"##explode-frame")
___DEF_GLO(77,"##extract-procedure-and-arguments")

___DEF_GLO(78,"##fail-check-cfun-conversion-exception")

___DEF_GLO(79,"##fail-check-foreign")
___DEF_GLO(80,"##fail-check-heap-overflow-exception")

___DEF_GLO(81,"##fail-check-keyword-expected-exception")

___DEF_GLO(82,"##fail-check-module-not-found-exception")

___DEF_GLO(83,"##fail-check-multiple-c-return-exception")

___DEF_GLO(84,"##fail-check-no-such-file-or-directory-exception")

___DEF_GLO(85,"##fail-check-nonprocedure-operator-exception")

___DEF_GLO(86,"##fail-check-number-of-arguments-limit-exception")

___DEF_GLO(87,"##fail-check-os-exception")
___DEF_GLO(88,"##fail-check-sfun-conversion-exception")

___DEF_GLO(89,"##fail-check-stack-overflow-exception")

___DEF_GLO(90,"##fail-check-type-exception")
___DEF_GLO(91,"##fail-check-unknown-keyword-argument-exception")

___DEF_GLO(92,"##fail-check-wrong-number-of-arguments-exception")

___DEF_GLO(93,"##fail-check-wrong-processor-c-return-exception")

___DEF_GLO(94,"##final-will-registry")
___DEF_GLO(95,"##find-interned-keyword")
___DEF_GLO(96,"##find-interned-symbol")
___DEF_GLO(97,"##find-interned-symkey")
___DEF_GLO(98,"##first-argument")
___DEF_GLO(99,"##fixnum-width")
___DEF_GLO(100,"##fixnum-width-neg")
___DEF_GLO(101,"##force-undetermined")
___DEF_GLO(102,"##foreign-address")
___DEF_GLO(103,"##foreign-release!")
___DEF_GLO(104,"##foreign-released?")
___DEF_GLO(105,"##foreign-tags")
___DEF_GLO(106,"##format-filepos")
___DEF_GLO(107,"##frame-fs")
___DEF_GLO(108,"##frame-link")
___DEF_GLO(109,"##frame-ref")
___DEF_GLO(110,"##frame-ret")
___DEF_GLO(111,"##frame-set!")
___DEF_GLO(112,"##frame-slot-live?")
___DEF_GLO(113,"##gc")
___DEF_GLO(114,"##gc-final-will-registry!")
___DEF_GLO(115,"##gc-finalize!")
___DEF_GLO(116,"##gc-interrupt-jobs")
___DEF_GLO(117,"##gc-without-exceptions")
___DEF_GLO(118,"##get-bytes-allocated!")
___DEF_GLO(119,"##get-current-time!")
___DEF_GLO(120,"##get-heartbeat-interval!")
___DEF_GLO(121,"##get-live-percent")
___DEF_GLO(122,"##get-max-heap")
___DEF_GLO(123,"##get-min-heap")
___DEF_GLO(124,"##get-monotonic-time!")
___DEF_GLO(125,"##get-monotonic-time-frequency!")
___DEF_GLO(126,"##get-parallelism-level")
___DEF_GLO(127,"##get-standard-level")
___DEF_GLO(128,"##global-var->identifier")
___DEF_GLO(129,"##global-var-primitive-ref")
___DEF_GLO(130,"##global-var-primitive-set!")
___DEF_GLO(131,"##global-var-ref")
___DEF_GLO(132,"##global-var-set!")
___DEF_GLO(133,"##global-var?")
___DEF_GLO(134,"##handle-gc-interrupt!")
___DEF_GLO(135,"##interrupt-handler")
___DEF_GLO(136,"##interrupt-vector")
___DEF_GLO(137,"##interrupt-vector-set!")
___DEF_GLO(138,"##kernel-handlers")
___DEF_GLO(139,"##keyword-table")
___DEF_GLO(140,"##load-required-module")
___DEF_GLO(141,"##load-required-module-set!")
___DEF_GLO(142,"##load-required-module-structs")
___DEF_GLO(143,"##load-vm")
___DEF_GLO(144,"##lookup-module")
___DEF_GLO(145,"##lookup-registered-module")
___DEF_GLO(146,"##machine-code-block-exec")
___DEF_GLO(147,"##machine-code-block-fixup")
___DEF_GLO(148,"##machine-code-block-ref")
___DEF_GLO(149,"##machine-code-block-set!")
___DEF_GLO(150,"##machine-code-fixup")
___DEF_GLO(151,"##main")
___DEF_GLO(152,"##main-set!")
___DEF_GLO(153,"##make-closure")
___DEF_GLO(154,"##make-continuation")
___DEF_GLO(155,"##make-f32vector")
___DEF_GLO(156,"##make-f64vector")
___DEF_GLO(157,"##make-final-will")
___DEF_GLO(158,"##make-frame")
___DEF_GLO(159,"##make-global-var")
___DEF_GLO(160,"##make-interned-keyword")
___DEF_GLO(161,"##make-interned-symbol")
___DEF_GLO(162,"##make-interned-symkey")
___DEF_GLO(163,"##make-jobs")
___DEF_GLO(164,"##make-machine-code-block")
___DEF_GLO(165,"##make-promise")
___DEF_GLO(166,"##make-s16vector")
___DEF_GLO(167,"##make-s32vector")
___DEF_GLO(168,"##make-s64vector")
___DEF_GLO(169,"##make-s8vector")
___DEF_GLO(170,"##make-string")
___DEF_GLO(171,"##make-structure")
___DEF_GLO(172,"##make-subprocedure")
___DEF_GLO(173,"##make-u16vector")
___DEF_GLO(174,"##make-u32vector")
___DEF_GLO(175,"##make-u64vector")
___DEF_GLO(176,"##make-u8vector")
___DEF_GLO(177,"##make-values")
___DEF_GLO(178,"##make-vector")
___DEF_GLO(179,"##max-char")
___DEF_GLO(180,"##max-fixnum")
___DEF_GLO(181,"##min-fixnum")
___DEF_GLO(182,"##module-init")
___DEF_GLO(183,"##object->global-var")
___DEF_GLO(184,"##object->global-var->identifier")
___DEF_GLO(185,"##os-address-infos")
___DEF_GLO(186,"##os-bat-extension-string-saved")
___DEF_GLO(187,"##os-condvar-select!")
___DEF_GLO(188,"##os-configure-command-string-saved")

___DEF_GLO(189,"##os-copy-file")
___DEF_GLO(190,"##os-create-directory")
___DEF_GLO(191,"##os-create-fifo")
___DEF_GLO(192,"##os-create-link")
___DEF_GLO(193,"##os-create-symbolic-link")
___DEF_GLO(194,"##os-delete-directory")
___DEF_GLO(195,"##os-delete-file")
___DEF_GLO(196,"##os-device-close")
___DEF_GLO(197,"##os-device-directory-open-path")
___DEF_GLO(198,"##os-device-directory-read")
___DEF_GLO(199,"##os-device-event-queue-open")
___DEF_GLO(200,"##os-device-event-queue-read")
___DEF_GLO(201,"##os-device-force-output")
___DEF_GLO(202,"##os-device-kind")
___DEF_GLO(203,"##os-device-open-raw-from-fd")
___DEF_GLO(204,"##os-device-process-pid")
___DEF_GLO(205,"##os-device-process-status")
___DEF_GLO(206,"##os-device-stream-default-options")

___DEF_GLO(207,"##os-device-stream-open-path")
___DEF_GLO(208,"##os-device-stream-open-predefined")

___DEF_GLO(209,"##os-device-stream-open-process")
___DEF_GLO(210,"##os-device-stream-options-set!")
___DEF_GLO(211,"##os-device-stream-read")
___DEF_GLO(212,"##os-device-stream-seek")
___DEF_GLO(213,"##os-device-stream-width")
___DEF_GLO(214,"##os-device-stream-write")
___DEF_GLO(215,"##os-device-tcp-client-open")
___DEF_GLO(216,"##os-device-tcp-client-socket-info")

___DEF_GLO(217,"##os-device-tcp-server-open")
___DEF_GLO(218,"##os-device-tcp-server-read")
___DEF_GLO(219,"##os-device-tcp-server-socket-info")

___DEF_GLO(220,"##os-device-tty-history")
___DEF_GLO(221,"##os-device-tty-history-max-length-set!")

___DEF_GLO(222,"##os-device-tty-history-set!")
___DEF_GLO(223,"##os-device-tty-mode-set!")
___DEF_GLO(224,"##os-device-tty-paren-balance-duration-set!")

___DEF_GLO(225,"##os-device-tty-text-attributes-set!")

___DEF_GLO(226,"##os-device-tty-type-set!")
___DEF_GLO(227,"##os-device-udp-destination-set!")
___DEF_GLO(228,"##os-device-udp-open")
___DEF_GLO(229,"##os-device-udp-read-subu8vector")
___DEF_GLO(230,"##os-device-udp-socket-info")
___DEF_GLO(231,"##os-device-udp-write-subu8vector")

___DEF_GLO(232,"##os-environ")
___DEF_GLO(233,"##os-err-code->string")
___DEF_GLO(234,"##os-exe-extension-string-saved")
___DEF_GLO(235,"##os-file-info")
___DEF_GLO(236,"##os-file-times-set!")
___DEF_GLO(237,"##os-getenv")
___DEF_GLO(238,"##os-getpid")
___DEF_GLO(239,"##os-getppid")
___DEF_GLO(240,"##os-group-info")
___DEF_GLO(241,"##os-host-info")
___DEF_GLO(242,"##os-host-name")
___DEF_GLO(243,"##os-load-object-file")
___DEF_GLO(244,"##os-make-tls-context")
___DEF_GLO(245,"##os-network-info")
___DEF_GLO(246,"##os-obj-extension-string-saved")
___DEF_GLO(247,"##os-path-gambitdir")
___DEF_GLO(248,"##os-path-gambitdir-map-lookup")
___DEF_GLO(249,"##os-path-homedir")
___DEF_GLO(250,"##os-path-normalize-directory")
___DEF_GLO(251,"##os-protocol-info")
___DEF_GLO(252,"##os-rename-file")
___DEF_GLO(253,"##os-service-info")
___DEF_GLO(254,"##os-set-current-directory")
___DEF_GLO(255,"##os-setenv")
___DEF_GLO(256,"##os-shell-command")
___DEF_GLO(257,"##os-system-type-saved")
___DEF_GLO(258,"##os-system-type-string-saved")
___DEF_GLO(259,"##os-user-info")
___DEF_GLO(260,"##os-user-name")
___DEF_GLO(261,"##process-statistics")
___DEF_GLO(262,"##process-times")
___DEF_GLO(263,"##processed-command-line")
___DEF_GLO(264,"##processed-command-line-set!")
___DEF_GLO(265,"##program-descr")
___DEF_GLO(266,"##promise-result")
___DEF_GLO(267,"##promise-result-set!")
___DEF_GLO(268,"##promise-thunk")
___DEF_GLO(269,"##promise-thunk-set!")
___DEF_GLO(270,"##raise-cfun-conversion-exception-nary")

___DEF_GLO(271,"##raise-heap-overflow-exception")
___DEF_GLO(272,"##raise-high-level-interrupt!")
___DEF_GLO(273,"##raise-keyword-expected-exception")

___DEF_GLO(274,"##raise-keyword-expected-exception-nary")

___DEF_GLO(275,"##raise-module-not-found-exception")

___DEF_GLO(276,"##raise-multiple-c-return-exception")

___DEF_GLO(277,"##raise-no-such-file-or-directory-exception")

___DEF_GLO(278,"##raise-nonprocedure-operator-exception")

___DEF_GLO(279,"##raise-number-of-arguments-limit-exception")

___DEF_GLO(280,"##raise-os-exception")
___DEF_GLO(281,"##raise-sfun-conversion-exception")

___DEF_GLO(282,"##raise-stack-overflow-exception")
___DEF_GLO(283,"##raise-type-exception")
___DEF_GLO(284,"##raise-unknown-keyword-argument-exception")

___DEF_GLO(285,"##raise-unknown-keyword-argument-exception-nary")

___DEF_GLO(286,"##raise-wrong-number-of-arguments-exception")

___DEF_GLO(287,"##raise-wrong-number-of-arguments-exception-nary")

___DEF_GLO(288,"##raise-wrong-processor-c-return-exception")

___DEF_GLO(289,"##register-module-descr!")
___DEF_GLO(290,"##register-module-descrs!")
___DEF_GLO(291,"##register-module-descrs-and-load!")

___DEF_GLO(292,"##registered-modules")
___DEF_GLO(293,"##remote-dbg-addr")
___DEF_GLO(294,"##rest-param-check-heap")
___DEF_GLO(295,"##rest-param-heap-overflow")
___DEF_GLO(296,"##rest-param-resume-procedure")
___DEF_GLO(297,"##return-fs")
___DEF_GLO(298,"##rpc-server-addr")
___DEF_GLO(299,"##set-debug-settings!")
___DEF_GLO(300,"##set-gambitdir!")
___DEF_GLO(301,"##set-heartbeat-interval!")
___DEF_GLO(302,"##set-live-percent!")
___DEF_GLO(303,"##set-max-heap!")
___DEF_GLO(304,"##set-min-heap!")
___DEF_GLO(305,"##set-parallelism-level!")
___DEF_GLO(306,"##set-standard-level!")
___DEF_GLO(307,"##still-copy")
___DEF_GLO(308,"##still-obj-refcount-dec!")
___DEF_GLO(309,"##still-obj-refcount-inc!")
___DEF_GLO(310,"##structure")
___DEF_GLO(311,"##structure-cas!")
___DEF_GLO(312,"##structure-direct-instance-of?")
___DEF_GLO(313,"##structure-instance-of?")
___DEF_GLO(314,"##structure-length")
___DEF_GLO(315,"##structure-ref")
___DEF_GLO(316,"##structure-set!")
___DEF_GLO(317,"##structure-type")
___DEF_GLO(318,"##structure-type-set!")
___DEF_GLO(319,"##subprocedure-id")
___DEF_GLO(320,"##subprocedure-nb-closed")
___DEF_GLO(321,"##subprocedure-nb-parameters")
___DEF_GLO(322,"##subprocedure-parent")
___DEF_GLO(323,"##subprocedure-parent-info")
___DEF_GLO(324,"##subprocedure-parent-name")
___DEF_GLO(325,"##subprocedure?")
___DEF_GLO(326,"##symbol-table")
___DEF_GLO(327,"##sync-op-interrupt!")
___DEF_GLO(328,"##system-stamp")
___DEF_GLO(329,"##system-stamp-saved")
___DEF_GLO(330,"##system-version")
___DEF_GLO(331,"##system-version-string")
___DEF_GLO(332,"##type-fields")
___DEF_GLO(333,"##type-flags")
___DEF_GLO(334,"##type-id")
___DEF_GLO(335,"##type-name")
___DEF_GLO(336,"##type-super")
___DEF_GLO(337,"##type-type")
___DEF_GLO(338,"##type?")
___DEF_GLO(339,"##unchecked-structure-cas!")
___DEF_GLO(340,"##unchecked-structure-ref")
___DEF_GLO(341,"##unchecked-structure-set!")
___DEF_GLO(342,"##values-length")
___DEF_GLO(343,"##values-ref")
___DEF_GLO(344,"##values-set!")
___DEF_GLO(345,"##vm-main-module-id")
___DEF_GLO(346,"##with-no-result-expected")
___DEF_GLO(347,"##with-no-result-expected-toplevel")

___DEF_GLO(348,"_kernel#")
___DEF_GLO(349,"_kernel#0")
___DEF_GLO(350,"_kernel#1")
___DEF_GLO(351,"_kernel#10")
___DEF_GLO(352,"_kernel#11")
___DEF_GLO(353,"_kernel#12")
___DEF_GLO(354,"_kernel#13")
___DEF_GLO(355,"_kernel#14")
___DEF_GLO(356,"_kernel#15")
___DEF_GLO(357,"_kernel#16")
___DEF_GLO(358,"_kernel#17")
___DEF_GLO(359,"_kernel#18")
___DEF_GLO(360,"_kernel#19")
___DEF_GLO(361,"_kernel#2")
___DEF_GLO(362,"_kernel#20")
___DEF_GLO(363,"_kernel#21")
___DEF_GLO(364,"_kernel#22")
___DEF_GLO(365,"_kernel#23")
___DEF_GLO(366,"_kernel#24")
___DEF_GLO(367,"_kernel#25")
___DEF_GLO(368,"_kernel#26")
___DEF_GLO(369,"_kernel#27")
___DEF_GLO(370,"_kernel#28")
___DEF_GLO(371,"_kernel#29")
___DEF_GLO(372,"_kernel#3")
___DEF_GLO(373,"_kernel#30")
___DEF_GLO(374,"_kernel#31")
___DEF_GLO(375,"_kernel#32")
___DEF_GLO(376,"_kernel#33")
___DEF_GLO(377,"_kernel#34")
___DEF_GLO(378,"_kernel#35")
___DEF_GLO(379,"_kernel#36")
___DEF_GLO(380,"_kernel#37")
___DEF_GLO(381,"_kernel#38")
___DEF_GLO(382,"_kernel#39")
___DEF_GLO(383,"_kernel#4")
___DEF_GLO(384,"_kernel#40")
___DEF_GLO(385,"_kernel#41")
___DEF_GLO(386,"_kernel#42")
___DEF_GLO(387,"_kernel#43")
___DEF_GLO(388,"_kernel#44")
___DEF_GLO(389,"_kernel#45")
___DEF_GLO(390,"_kernel#46")
___DEF_GLO(391,"_kernel#47")
___DEF_GLO(392,"_kernel#48")
___DEF_GLO(393,"_kernel#49")
___DEF_GLO(394,"_kernel#5")
___DEF_GLO(395,"_kernel#50")
___DEF_GLO(396,"_kernel#51")
___DEF_GLO(397,"_kernel#52")
___DEF_GLO(398,"_kernel#53")
___DEF_GLO(399,"_kernel#54")
___DEF_GLO(400,"_kernel#55")
___DEF_GLO(401,"_kernel#56")
___DEF_GLO(402,"_kernel#57")
___DEF_GLO(403,"_kernel#58")
___DEF_GLO(404,"_kernel#59")
___DEF_GLO(405,"_kernel#6")
___DEF_GLO(406,"_kernel#60")
___DEF_GLO(407,"_kernel#61")
___DEF_GLO(408,"_kernel#62")
___DEF_GLO(409,"_kernel#63")
___DEF_GLO(410,"_kernel#64")
___DEF_GLO(411,"_kernel#65")
___DEF_GLO(412,"_kernel#66")
___DEF_GLO(413,"_kernel#67")
___DEF_GLO(414,"_kernel#68")
___DEF_GLO(415,"_kernel#69")
___DEF_GLO(416,"_kernel#7")
___DEF_GLO(417,"_kernel#70")
___DEF_GLO(418,"_kernel#71")
___DEF_GLO(419,"_kernel#72")
___DEF_GLO(420,"_kernel#73")
___DEF_GLO(421,"_kernel#74")
___DEF_GLO(422,"_kernel#75")
___DEF_GLO(423,"_kernel#76")
___DEF_GLO(424,"_kernel#77")
___DEF_GLO(425,"_kernel#78")
___DEF_GLO(426,"_kernel#79")
___DEF_GLO(427,"_kernel#8")
___DEF_GLO(428,"_kernel#80")
___DEF_GLO(429,"_kernel#81")
___DEF_GLO(430,"_kernel#82")
___DEF_GLO(431,"_kernel#83")
___DEF_GLO(432,"_kernel#84")
___DEF_GLO(433,"_kernel#85")
___DEF_GLO(434,"_kernel#86")
___DEF_GLO(435,"_kernel#87")
___DEF_GLO(436,"_kernel#88")
___DEF_GLO(437,"_kernel#89")
___DEF_GLO(438,"_kernel#9")
___DEF_GLO(439,"_kernel#90")
___DEF_GLO(440,"_kernel#91")
___DEF_GLO(441,"_kernel#92")
___DEF_GLO(442,"cfun-conversion-exception-arguments")

___DEF_GLO(443,"cfun-conversion-exception-code")
___DEF_GLO(444,"cfun-conversion-exception-message")

___DEF_GLO(445,"cfun-conversion-exception-procedure")

___DEF_GLO(446,"cfun-conversion-exception?")
___DEF_GLO(447,"configure-command-string")
___DEF_GLO(448,"err-code->string")
___DEF_GLO(449,"foreign-address")
___DEF_GLO(450,"foreign-release!")
___DEF_GLO(451,"foreign-released?")
___DEF_GLO(452,"foreign-tags")
___DEF_GLO(453,"foreign?")
___DEF_GLO(454,"heap-overflow-exception?")
___DEF_GLO(455,"keyword-expected-exception-arguments")

___DEF_GLO(456,"keyword-expected-exception-procedure")

___DEF_GLO(457,"keyword-expected-exception?")
___DEF_GLO(458,"module-not-found-exception-arguments")

___DEF_GLO(459,"module-not-found-exception-procedure")

___DEF_GLO(460,"module-not-found-exception?")
___DEF_GLO(461,"multiple-c-return-exception?")
___DEF_GLO(462,"no-such-file-or-directory-exception-arguments")

___DEF_GLO(463,"no-such-file-or-directory-exception-procedure")

___DEF_GLO(464,"no-such-file-or-directory-exception?")

___DEF_GLO(465,"nonprocedure-operator-exception-arguments")

___DEF_GLO(466,"nonprocedure-operator-exception-code")

___DEF_GLO(467,"nonprocedure-operator-exception-operator")

___DEF_GLO(468,"nonprocedure-operator-exception-rte")

___DEF_GLO(469,"nonprocedure-operator-exception?")
___DEF_GLO(470,"number-of-arguments-limit-exception-arguments")

___DEF_GLO(471,"number-of-arguments-limit-exception-procedure")

___DEF_GLO(472,"number-of-arguments-limit-exception?")

___DEF_GLO(473,"os-exception-arguments")
___DEF_GLO(474,"os-exception-code")
___DEF_GLO(475,"os-exception-message")
___DEF_GLO(476,"os-exception-procedure")
___DEF_GLO(477,"os-exception?")
___DEF_GLO(478,"sfun-conversion-exception-arguments")

___DEF_GLO(479,"sfun-conversion-exception-code")
___DEF_GLO(480,"sfun-conversion-exception-message")

___DEF_GLO(481,"sfun-conversion-exception-procedure")

___DEF_GLO(482,"sfun-conversion-exception?")
___DEF_GLO(483,"stack-overflow-exception?")
___DEF_GLO(484,"system-stamp")
___DEF_GLO(485,"system-type")
___DEF_GLO(486,"system-type-string")
___DEF_GLO(487,"system-version")
___DEF_GLO(488,"system-version-string")
___DEF_GLO(489,"type-exception-arg-num")
___DEF_GLO(490,"type-exception-arguments")
___DEF_GLO(491,"type-exception-procedure")
___DEF_GLO(492,"type-exception-type-id")
___DEF_GLO(493,"type-exception?")
___DEF_GLO(494,"unknown-keyword-argument-exception-arguments")

___DEF_GLO(495,"unknown-keyword-argument-exception-procedure")

___DEF_GLO(496,"unknown-keyword-argument-exception?")

___DEF_GLO(497,"wrong-number-of-arguments-exception-arguments")

___DEF_GLO(498,"wrong-number-of-arguments-exception-procedure")

___DEF_GLO(499,"wrong-number-of-arguments-exception?")

___DEF_GLO(500,"wrong-processor-c-return-exception?")

___END_GLO

#define ___GLO__23__23_actlog_2d_dump ___GLO(0,___G__23__23_actlog_2d_dump)
#define ___PRM__23__23_actlog_2d_dump ___PRM(0,___G__23__23_actlog_2d_dump)
#define ___GLO__23__23_actlog_2d_start ___GLO(1,___G__23__23_actlog_2d_start)
#define ___PRM__23__23_actlog_2d_start ___PRM(1,___G__23__23_actlog_2d_start)
#define ___GLO__23__23_actlog_2d_stop ___GLO(2,___G__23__23_actlog_2d_stop)
#define ___PRM__23__23_actlog_2d_stop ___PRM(2,___G__23__23_actlog_2d_stop)
#define ___GLO__23__23_add_2d_exit_2d_job_21_ ___GLO(3,___G__23__23_add_2d_exit_2d_job_21_)
#define ___PRM__23__23_add_2d_exit_2d_job_21_ ___PRM(3,___G__23__23_add_2d_exit_2d_job_21_)
#define ___GLO__23__23_add_2d_gc_2d_interrupt_2d_job_21_ ___GLO(4,___G__23__23_add_2d_gc_2d_interrupt_2d_job_21_)
#define ___PRM__23__23_add_2d_gc_2d_interrupt_2d_job_21_ ___PRM(4,___G__23__23_add_2d_gc_2d_interrupt_2d_job_21_)
#define ___GLO__23__23_add_2d_job_21_ ___GLO(5,___G__23__23_add_2d_job_21_)
#define ___PRM__23__23_add_2d_job_21_ ___PRM(5,___G__23__23_add_2d_job_21_)
#define ___GLO__23__23_add_2d_job_2d_at_2d_tail_21_ ___GLO(6,___G__23__23_add_2d_job_2d_at_2d_tail_21_)
#define ___PRM__23__23_add_2d_job_2d_at_2d_tail_21_ ___PRM(6,___G__23__23_add_2d_job_2d_at_2d_tail_21_)
#define ___GLO__23__23_apply ___GLO(7,___G__23__23_apply)
#define ___PRM__23__23_apply ___PRM(7,___G__23__23_apply)
#define ___GLO__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary ___GLO(8,___G__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary)
#define ___PRM__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary ___PRM(8,___G__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary)
#define ___GLO__23__23_apply_2d_with_2d_procedure_2d_check ___GLO(9,___G__23__23_apply_2d_with_2d_procedure_2d_check)
#define ___PRM__23__23_apply_2d_with_2d_procedure_2d_check ___PRM(9,___G__23__23_apply_2d_with_2d_procedure_2d_check)
#define ___GLO__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary ___GLO(10,___G__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary)
#define ___PRM__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary ___PRM(10,___G__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary)
#define ___GLO__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_ ___GLO(11,___G__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
#define ___PRM__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_ ___PRM(11,___G__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
#define ___GLO__23__23_argument_2d_list_2d_remove_2d_absent_21_ ___GLO(12,___G__23__23_argument_2d_list_2d_remove_2d_absent_21_)
#define ___PRM__23__23_argument_2d_list_2d_remove_2d_absent_21_ ___PRM(12,___G__23__23_argument_2d_list_2d_remove_2d_absent_21_)
#define ___GLO__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_ ___GLO(13,___G__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
#define ___PRM__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_ ___PRM(13,___G__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
#define ___GLO__23__23_assq ___GLO(14,___G__23__23_assq)
#define ___PRM__23__23_assq ___PRM(14,___G__23__23_assq)
#define ___GLO__23__23_assq_2d_cdr ___GLO(15,___G__23__23_assq_2d_cdr)
#define ___PRM__23__23_assq_2d_cdr ___PRM(15,___G__23__23_assq_2d_cdr)
#define ___GLO__23__23_bignum_2e_adigit_2d_width ___GLO(16,___G__23__23_bignum_2e_adigit_2d_width)
#define ___PRM__23__23_bignum_2e_adigit_2d_width ___PRM(16,___G__23__23_bignum_2e_adigit_2d_width)
#define ___GLO__23__23_bignum_2e_fdigit_2d_width ___GLO(17,___G__23__23_bignum_2e_fdigit_2d_width)
#define ___PRM__23__23_bignum_2e_fdigit_2d_width ___PRM(17,___G__23__23_bignum_2e_fdigit_2d_width)
#define ___GLO__23__23_bignum_2e_mdigit_2d_width ___GLO(18,___G__23__23_bignum_2e_mdigit_2d_width)
#define ___PRM__23__23_bignum_2e_mdigit_2d_width ___PRM(18,___G__23__23_bignum_2e_mdigit_2d_width)
#define ___GLO__23__23_c_2d_return_2d_on_2d_other_2d_processor ___GLO(19,___G__23__23_c_2d_return_2d_on_2d_other_2d_processor)
#define ___PRM__23__23_c_2d_return_2d_on_2d_other_2d_processor ___PRM(19,___G__23__23_c_2d_return_2d_on_2d_other_2d_processor)
#define ___GLO__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook ___GLO(20,___G__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook)
#define ___PRM__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook ___PRM(20,___G__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook)
#define ___GLO__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_ ___GLO(21,___G__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_)
#define ___PRM__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_ ___PRM(21,___G__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_)
#define ___GLO__23__23_check_2d_heap ___GLO(22,___G__23__23_check_2d_heap)
#define ___PRM__23__23_check_2d_heap ___PRM(22,___G__23__23_check_2d_heap)
#define ___GLO__23__23_check_2d_heap_2d_limit ___GLO(23,___G__23__23_check_2d_heap_2d_limit)
#define ___PRM__23__23_check_2d_heap_2d_limit ___PRM(23,___G__23__23_check_2d_heap_2d_limit)
#define ___GLO__23__23_clear_2d_exit_2d_jobs_21_ ___GLO(24,___G__23__23_clear_2d_exit_2d_jobs_21_)
#define ___PRM__23__23_clear_2d_exit_2d_jobs_21_ ___PRM(24,___G__23__23_clear_2d_exit_2d_jobs_21_)
#define ___GLO__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_ ___GLO(25,___G__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_)
#define ___PRM__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_ ___PRM(25,___G__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_)
#define ___GLO__23__23_clear_2d_jobs_21_ ___GLO(26,___G__23__23_clear_2d_jobs_21_)
#define ___PRM__23__23_clear_2d_jobs_21_ ___PRM(26,___G__23__23_clear_2d_jobs_21_)
#define ___GLO__23__23_closure_2d_code ___GLO(27,___G__23__23_closure_2d_code)
#define ___PRM__23__23_closure_2d_code ___PRM(27,___G__23__23_closure_2d_code)
#define ___GLO__23__23_closure_2d_length ___GLO(28,___G__23__23_closure_2d_length)
#define ___PRM__23__23_closure_2d_length ___PRM(28,___G__23__23_closure_2d_length)
#define ___GLO__23__23_closure_2d_ref ___GLO(29,___G__23__23_closure_2d_ref)
#define ___PRM__23__23_closure_2d_ref ___PRM(29,___G__23__23_closure_2d_ref)
#define ___GLO__23__23_closure_2d_set_21_ ___GLO(30,___G__23__23_closure_2d_set_21_)
#define ___PRM__23__23_closure_2d_set_21_ ___PRM(30,___G__23__23_closure_2d_set_21_)
#define ___GLO__23__23_closure_3f_ ___GLO(31,___G__23__23_closure_3f_)
#define ___PRM__23__23_closure_3f_ ___PRM(31,___G__23__23_closure_3f_)
#define ___GLO__23__23_command_2d_line ___GLO(32,___G__23__23_command_2d_line)
#define ___PRM__23__23_command_2d_line ___PRM(32,___G__23__23_command_2d_line)
#define ___GLO__23__23_continuation_2d_copy ___GLO(33,___G__23__23_continuation_2d_copy)
#define ___PRM__23__23_continuation_2d_copy ___PRM(33,___G__23__23_continuation_2d_copy)
#define ___GLO__23__23_continuation_2d_denv ___GLO(34,___G__23__23_continuation_2d_denv)
#define ___PRM__23__23_continuation_2d_denv ___PRM(34,___G__23__23_continuation_2d_denv)
#define ___GLO__23__23_continuation_2d_denv_2d_set_21_ ___GLO(35,___G__23__23_continuation_2d_denv_2d_set_21_)
#define ___PRM__23__23_continuation_2d_denv_2d_set_21_ ___PRM(35,___G__23__23_continuation_2d_denv_2d_set_21_)
#define ___GLO__23__23_continuation_2d_frame ___GLO(36,___G__23__23_continuation_2d_frame)
#define ___PRM__23__23_continuation_2d_frame ___PRM(36,___G__23__23_continuation_2d_frame)
#define ___GLO__23__23_continuation_2d_frame_2d_set_21_ ___GLO(37,___G__23__23_continuation_2d_frame_2d_set_21_)
#define ___PRM__23__23_continuation_2d_frame_2d_set_21_ ___PRM(37,___G__23__23_continuation_2d_frame_2d_set_21_)
#define ___GLO__23__23_continuation_2d_fs ___GLO(38,___G__23__23_continuation_2d_fs)
#define ___PRM__23__23_continuation_2d_fs ___PRM(38,___G__23__23_continuation_2d_fs)
#define ___GLO__23__23_continuation_2d_last ___GLO(39,___G__23__23_continuation_2d_last)
#define ___PRM__23__23_continuation_2d_last ___PRM(39,___G__23__23_continuation_2d_last)
#define ___GLO__23__23_continuation_2d_link ___GLO(40,___G__23__23_continuation_2d_link)
#define ___PRM__23__23_continuation_2d_link ___PRM(40,___G__23__23_continuation_2d_link)
#define ___GLO__23__23_continuation_2d_next ___GLO(41,___G__23__23_continuation_2d_next)
#define ___PRM__23__23_continuation_2d_next ___PRM(41,___G__23__23_continuation_2d_next)
#define ___GLO__23__23_continuation_2d_next_21_ ___GLO(42,___G__23__23_continuation_2d_next_21_)
#define ___PRM__23__23_continuation_2d_next_21_ ___PRM(42,___G__23__23_continuation_2d_next_21_)
#define ___GLO__23__23_continuation_2d_ref ___GLO(43,___G__23__23_continuation_2d_ref)
#define ___PRM__23__23_continuation_2d_ref ___PRM(43,___G__23__23_continuation_2d_ref)
#define ___GLO__23__23_continuation_2d_ret ___GLO(44,___G__23__23_continuation_2d_ret)
#define ___PRM__23__23_continuation_2d_ret ___PRM(44,___G__23__23_continuation_2d_ret)
#define ___GLO__23__23_continuation_2d_set_21_ ___GLO(45,___G__23__23_continuation_2d_set_21_)
#define ___PRM__23__23_continuation_2d_set_21_ ___PRM(45,___G__23__23_continuation_2d_set_21_)
#define ___GLO__23__23_continuation_2d_slot_2d_live_3f_ ___GLO(46,___G__23__23_continuation_2d_slot_2d_live_3f_)
#define ___PRM__23__23_continuation_2d_slot_2d_live_3f_ ___PRM(46,___G__23__23_continuation_2d_slot_2d_live_3f_)
#define ___GLO__23__23_core_2d_count ___GLO(47,___G__23__23_core_2d_count)
#define ___PRM__23__23_core_2d_count ___PRM(47,___G__23__23_core_2d_count)
#define ___GLO__23__23_cpu_2d_cache_2d_size ___GLO(48,___G__23__23_cpu_2d_cache_2d_size)
#define ___PRM__23__23_cpu_2d_cache_2d_size ___PRM(48,___G__23__23_cpu_2d_cache_2d_size)
#define ___GLO__23__23_cpu_2d_count ___GLO(49,___G__23__23_cpu_2d_count)
#define ___PRM__23__23_cpu_2d_count ___PRM(49,___G__23__23_cpu_2d_count)
#define ___GLO__23__23_create_2d_module ___GLO(50,___G__23__23_create_2d_module)
#define ___PRM__23__23_create_2d_module ___PRM(50,___G__23__23_create_2d_module)
#define ___GLO__23__23_current_2d_vm_2d_processor_2d_count ___GLO(51,___G__23__23_current_2d_vm_2d_processor_2d_count)
#define ___PRM__23__23_current_2d_vm_2d_processor_2d_count ___PRM(51,___G__23__23_current_2d_vm_2d_processor_2d_count)
#define ___GLO__23__23_current_2d_vm_2d_resize ___GLO(52,___G__23__23_current_2d_vm_2d_resize)
#define ___PRM__23__23_current_2d_vm_2d_resize ___PRM(52,___G__23__23_current_2d_vm_2d_resize)
#define ___GLO__23__23_default_2d_load_2d_required_2d_module ___GLO(53,___G__23__23_default_2d_load_2d_required_2d_module)
#define ___PRM__23__23_default_2d_load_2d_required_2d_module ___PRM(53,___G__23__23_default_2d_load_2d_required_2d_module)
#define ___GLO__23__23_device_2d_select_2d_abort_21_ ___GLO(54,___G__23__23_device_2d_select_2d_abort_21_)
#define ___PRM__23__23_device_2d_select_2d_abort_21_ ___PRM(54,___G__23__23_device_2d_select_2d_abort_21_)
#define ___GLO__23__23_direct_2d_structure_2d_cas_21_ ___GLO(55,___G__23__23_direct_2d_structure_2d_cas_21_)
#define ___PRM__23__23_direct_2d_structure_2d_cas_21_ ___PRM(55,___G__23__23_direct_2d_structure_2d_cas_21_)
#define ___GLO__23__23_direct_2d_structure_2d_ref ___GLO(56,___G__23__23_direct_2d_structure_2d_ref)
#define ___PRM__23__23_direct_2d_structure_2d_ref ___PRM(56,___G__23__23_direct_2d_structure_2d_ref)
#define ___GLO__23__23_direct_2d_structure_2d_set_21_ ___GLO(57,___G__23__23_direct_2d_structure_2d_set_21_)
#define ___PRM__23__23_direct_2d_structure_2d_set_21_ ___PRM(57,___G__23__23_direct_2d_structure_2d_set_21_)
#define ___GLO__23__23_disable_2d_interrupts_21_ ___GLO(58,___G__23__23_disable_2d_interrupts_21_)
#define ___PRM__23__23_disable_2d_interrupts_21_ ___PRM(58,___G__23__23_disable_2d_interrupts_21_)
#define ___GLO__23__23_dynamic_2d_env_2d_bind ___GLO(59,___G__23__23_dynamic_2d_env_2d_bind)
#define ___PRM__23__23_dynamic_2d_env_2d_bind ___PRM(59,___G__23__23_dynamic_2d_env_2d_bind)
#define ___GLO__23__23_enable_2d_interrupts_21_ ___GLO(60,___G__23__23_enable_2d_interrupts_21_)
#define ___PRM__23__23_enable_2d_interrupts_21_ ___PRM(60,___G__23__23_enable_2d_interrupts_21_)
#define ___GLO__23__23_err_2d_code_2d_EAGAIN ___GLO(61,___G__23__23_err_2d_code_2d_EAGAIN)
#define ___PRM__23__23_err_2d_code_2d_EAGAIN ___PRM(61,___G__23__23_err_2d_code_2d_EAGAIN)
#define ___GLO__23__23_err_2d_code_2d_EINTR ___GLO(62,___G__23__23_err_2d_code_2d_EINTR)
#define ___PRM__23__23_err_2d_code_2d_EINTR ___PRM(62,___G__23__23_err_2d_code_2d_EINTR)
#define ___GLO__23__23_err_2d_code_2d_ENOENT ___GLO(63,___G__23__23_err_2d_code_2d_ENOENT)
#define ___PRM__23__23_err_2d_code_2d_ENOENT ___PRM(63,___G__23__23_err_2d_code_2d_ENOENT)
#define ___GLO__23__23_err_2d_code_2d_unimplemented ___GLO(64,___G__23__23_err_2d_code_2d_unimplemented)
#define ___PRM__23__23_err_2d_code_2d_unimplemented ___PRM(64,___G__23__23_err_2d_code_2d_unimplemented)
#define ___GLO__23__23_execute_2d_and_2d_clear_2d_jobs_21_ ___GLO(65,___G__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
#define ___PRM__23__23_execute_2d_and_2d_clear_2d_jobs_21_ ___PRM(65,___G__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
#define ___GLO__23__23_execute_2d_final_2d_wills_21_ ___GLO(66,___G__23__23_execute_2d_final_2d_wills_21_)
#define ___PRM__23__23_execute_2d_final_2d_wills_21_ ___PRM(66,___G__23__23_execute_2d_final_2d_wills_21_)
#define ___GLO__23__23_execute_2d_jobs_21_ ___GLO(67,___G__23__23_execute_2d_jobs_21_)
#define ___PRM__23__23_execute_2d_jobs_21_ ___PRM(67,___G__23__23_execute_2d_jobs_21_)
#define ___GLO__23__23_exit ___GLO(68,___G__23__23_exit)
#define ___PRM__23__23_exit ___PRM(68,___G__23__23_exit)
#define ___GLO__23__23_exit_2d_abnormally ___GLO(69,___G__23__23_exit_2d_abnormally)
#define ___PRM__23__23_exit_2d_abnormally ___PRM(69,___G__23__23_exit_2d_abnormally)
#define ___GLO__23__23_exit_2d_cleanup ___GLO(70,___G__23__23_exit_2d_cleanup)
#define ___PRM__23__23_exit_2d_cleanup ___PRM(70,___G__23__23_exit_2d_cleanup)
#define ___GLO__23__23_exit_2d_jobs ___GLO(71,___G__23__23_exit_2d_jobs)
#define ___PRM__23__23_exit_2d_jobs ___PRM(71,___G__23__23_exit_2d_jobs)
#define ___GLO__23__23_exit_2d_with_2d_err_2d_code ___GLO(72,___G__23__23_exit_2d_with_2d_err_2d_code)
#define ___PRM__23__23_exit_2d_with_2d_err_2d_code ___PRM(72,___G__23__23_exit_2d_with_2d_err_2d_code)
#define ___GLO__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup ___GLO(73,___G__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup)
#define ___PRM__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup ___PRM(73,___G__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup)
#define ___GLO__23__23_exit_2d_with_2d_exception ___GLO(74,___G__23__23_exit_2d_with_2d_exception)
#define ___PRM__23__23_exit_2d_with_2d_exception ___PRM(74,___G__23__23_exit_2d_with_2d_exception)
#define ___GLO__23__23_explode_2d_continuation ___GLO(75,___G__23__23_explode_2d_continuation)
#define ___PRM__23__23_explode_2d_continuation ___PRM(75,___G__23__23_explode_2d_continuation)
#define ___GLO__23__23_explode_2d_frame ___GLO(76,___G__23__23_explode_2d_frame)
#define ___PRM__23__23_explode_2d_frame ___PRM(76,___G__23__23_explode_2d_frame)
#define ___GLO__23__23_extract_2d_procedure_2d_and_2d_arguments ___GLO(77,___G__23__23_extract_2d_procedure_2d_and_2d_arguments)
#define ___PRM__23__23_extract_2d_procedure_2d_and_2d_arguments ___PRM(77,___G__23__23_extract_2d_procedure_2d_and_2d_arguments)
#define ___GLO__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception ___GLO(78,___G__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception ___PRM(78,___G__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_foreign ___GLO(79,___G__23__23_fail_2d_check_2d_foreign)
#define ___PRM__23__23_fail_2d_check_2d_foreign ___PRM(79,___G__23__23_fail_2d_check_2d_foreign)
#define ___GLO__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception ___GLO(80,___G__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception ___PRM(80,___G__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception ___GLO(81,___G__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception ___PRM(81,___G__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception ___GLO(82,___G__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception ___PRM(82,___G__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception ___GLO(83,___G__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception ___PRM(83,___G__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception ___GLO(84,___G__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception ___PRM(84,___G__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception ___GLO(85,___G__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception ___PRM(85,___G__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception ___GLO(86,___G__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception ___PRM(86,___G__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_os_2d_exception ___GLO(87,___G__23__23_fail_2d_check_2d_os_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_os_2d_exception ___PRM(87,___G__23__23_fail_2d_check_2d_os_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception ___GLO(88,___G__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception ___PRM(88,___G__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception ___GLO(89,___G__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception ___PRM(89,___G__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_type_2d_exception ___GLO(90,___G__23__23_fail_2d_check_2d_type_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_type_2d_exception ___PRM(90,___G__23__23_fail_2d_check_2d_type_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception ___GLO(91,___G__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception ___PRM(91,___G__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception ___GLO(92,___G__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception ___PRM(92,___G__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
#define ___GLO__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception ___GLO(93,___G__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
#define ___PRM__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception ___PRM(93,___G__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
#define ___GLO__23__23_final_2d_will_2d_registry ___GLO(94,___G__23__23_final_2d_will_2d_registry)
#define ___PRM__23__23_final_2d_will_2d_registry ___PRM(94,___G__23__23_final_2d_will_2d_registry)
#define ___GLO__23__23_find_2d_interned_2d_keyword ___GLO(95,___G__23__23_find_2d_interned_2d_keyword)
#define ___PRM__23__23_find_2d_interned_2d_keyword ___PRM(95,___G__23__23_find_2d_interned_2d_keyword)
#define ___GLO__23__23_find_2d_interned_2d_symbol ___GLO(96,___G__23__23_find_2d_interned_2d_symbol)
#define ___PRM__23__23_find_2d_interned_2d_symbol ___PRM(96,___G__23__23_find_2d_interned_2d_symbol)
#define ___GLO__23__23_find_2d_interned_2d_symkey ___GLO(97,___G__23__23_find_2d_interned_2d_symkey)
#define ___PRM__23__23_find_2d_interned_2d_symkey ___PRM(97,___G__23__23_find_2d_interned_2d_symkey)
#define ___GLO__23__23_first_2d_argument ___GLO(98,___G__23__23_first_2d_argument)
#define ___PRM__23__23_first_2d_argument ___PRM(98,___G__23__23_first_2d_argument)
#define ___GLO__23__23_fixnum_2d_width ___GLO(99,___G__23__23_fixnum_2d_width)
#define ___PRM__23__23_fixnum_2d_width ___PRM(99,___G__23__23_fixnum_2d_width)
#define ___GLO__23__23_fixnum_2d_width_2d_neg ___GLO(100,___G__23__23_fixnum_2d_width_2d_neg)
#define ___PRM__23__23_fixnum_2d_width_2d_neg ___PRM(100,___G__23__23_fixnum_2d_width_2d_neg)
#define ___GLO__23__23_force_2d_undetermined ___GLO(101,___G__23__23_force_2d_undetermined)
#define ___PRM__23__23_force_2d_undetermined ___PRM(101,___G__23__23_force_2d_undetermined)
#define ___GLO__23__23_foreign_2d_address ___GLO(102,___G__23__23_foreign_2d_address)
#define ___PRM__23__23_foreign_2d_address ___PRM(102,___G__23__23_foreign_2d_address)
#define ___GLO__23__23_foreign_2d_release_21_ ___GLO(103,___G__23__23_foreign_2d_release_21_)
#define ___PRM__23__23_foreign_2d_release_21_ ___PRM(103,___G__23__23_foreign_2d_release_21_)
#define ___GLO__23__23_foreign_2d_released_3f_ ___GLO(104,___G__23__23_foreign_2d_released_3f_)
#define ___PRM__23__23_foreign_2d_released_3f_ ___PRM(104,___G__23__23_foreign_2d_released_3f_)
#define ___GLO__23__23_foreign_2d_tags ___GLO(105,___G__23__23_foreign_2d_tags)
#define ___PRM__23__23_foreign_2d_tags ___PRM(105,___G__23__23_foreign_2d_tags)
#define ___GLO__23__23_format_2d_filepos ___GLO(106,___G__23__23_format_2d_filepos)
#define ___PRM__23__23_format_2d_filepos ___PRM(106,___G__23__23_format_2d_filepos)
#define ___GLO__23__23_frame_2d_fs ___GLO(107,___G__23__23_frame_2d_fs)
#define ___PRM__23__23_frame_2d_fs ___PRM(107,___G__23__23_frame_2d_fs)
#define ___GLO__23__23_frame_2d_link ___GLO(108,___G__23__23_frame_2d_link)
#define ___PRM__23__23_frame_2d_link ___PRM(108,___G__23__23_frame_2d_link)
#define ___GLO__23__23_frame_2d_ref ___GLO(109,___G__23__23_frame_2d_ref)
#define ___PRM__23__23_frame_2d_ref ___PRM(109,___G__23__23_frame_2d_ref)
#define ___GLO__23__23_frame_2d_ret ___GLO(110,___G__23__23_frame_2d_ret)
#define ___PRM__23__23_frame_2d_ret ___PRM(110,___G__23__23_frame_2d_ret)
#define ___GLO__23__23_frame_2d_set_21_ ___GLO(111,___G__23__23_frame_2d_set_21_)
#define ___PRM__23__23_frame_2d_set_21_ ___PRM(111,___G__23__23_frame_2d_set_21_)
#define ___GLO__23__23_frame_2d_slot_2d_live_3f_ ___GLO(112,___G__23__23_frame_2d_slot_2d_live_3f_)
#define ___PRM__23__23_frame_2d_slot_2d_live_3f_ ___PRM(112,___G__23__23_frame_2d_slot_2d_live_3f_)
#define ___GLO__23__23_gc ___GLO(113,___G__23__23_gc)
#define ___PRM__23__23_gc ___PRM(113,___G__23__23_gc)
#define ___GLO__23__23_gc_2d_final_2d_will_2d_registry_21_ ___GLO(114,___G__23__23_gc_2d_final_2d_will_2d_registry_21_)
#define ___PRM__23__23_gc_2d_final_2d_will_2d_registry_21_ ___PRM(114,___G__23__23_gc_2d_final_2d_will_2d_registry_21_)
#define ___GLO__23__23_gc_2d_finalize_21_ ___GLO(115,___G__23__23_gc_2d_finalize_21_)
#define ___PRM__23__23_gc_2d_finalize_21_ ___PRM(115,___G__23__23_gc_2d_finalize_21_)
#define ___GLO__23__23_gc_2d_interrupt_2d_jobs ___GLO(116,___G__23__23_gc_2d_interrupt_2d_jobs)
#define ___PRM__23__23_gc_2d_interrupt_2d_jobs ___PRM(116,___G__23__23_gc_2d_interrupt_2d_jobs)
#define ___GLO__23__23_gc_2d_without_2d_exceptions ___GLO(117,___G__23__23_gc_2d_without_2d_exceptions)
#define ___PRM__23__23_gc_2d_without_2d_exceptions ___PRM(117,___G__23__23_gc_2d_without_2d_exceptions)
#define ___GLO__23__23_get_2d_bytes_2d_allocated_21_ ___GLO(118,___G__23__23_get_2d_bytes_2d_allocated_21_)
#define ___PRM__23__23_get_2d_bytes_2d_allocated_21_ ___PRM(118,___G__23__23_get_2d_bytes_2d_allocated_21_)
#define ___GLO__23__23_get_2d_current_2d_time_21_ ___GLO(119,___G__23__23_get_2d_current_2d_time_21_)
#define ___PRM__23__23_get_2d_current_2d_time_21_ ___PRM(119,___G__23__23_get_2d_current_2d_time_21_)
#define ___GLO__23__23_get_2d_heartbeat_2d_interval_21_ ___GLO(120,___G__23__23_get_2d_heartbeat_2d_interval_21_)
#define ___PRM__23__23_get_2d_heartbeat_2d_interval_21_ ___PRM(120,___G__23__23_get_2d_heartbeat_2d_interval_21_)
#define ___GLO__23__23_get_2d_live_2d_percent ___GLO(121,___G__23__23_get_2d_live_2d_percent)
#define ___PRM__23__23_get_2d_live_2d_percent ___PRM(121,___G__23__23_get_2d_live_2d_percent)
#define ___GLO__23__23_get_2d_max_2d_heap ___GLO(122,___G__23__23_get_2d_max_2d_heap)
#define ___PRM__23__23_get_2d_max_2d_heap ___PRM(122,___G__23__23_get_2d_max_2d_heap)
#define ___GLO__23__23_get_2d_min_2d_heap ___GLO(123,___G__23__23_get_2d_min_2d_heap)
#define ___PRM__23__23_get_2d_min_2d_heap ___PRM(123,___G__23__23_get_2d_min_2d_heap)
#define ___GLO__23__23_get_2d_monotonic_2d_time_21_ ___GLO(124,___G__23__23_get_2d_monotonic_2d_time_21_)
#define ___PRM__23__23_get_2d_monotonic_2d_time_21_ ___PRM(124,___G__23__23_get_2d_monotonic_2d_time_21_)
#define ___GLO__23__23_get_2d_monotonic_2d_time_2d_frequency_21_ ___GLO(125,___G__23__23_get_2d_monotonic_2d_time_2d_frequency_21_)
#define ___PRM__23__23_get_2d_monotonic_2d_time_2d_frequency_21_ ___PRM(125,___G__23__23_get_2d_monotonic_2d_time_2d_frequency_21_)
#define ___GLO__23__23_get_2d_parallelism_2d_level ___GLO(126,___G__23__23_get_2d_parallelism_2d_level)
#define ___PRM__23__23_get_2d_parallelism_2d_level ___PRM(126,___G__23__23_get_2d_parallelism_2d_level)
#define ___GLO__23__23_get_2d_standard_2d_level ___GLO(127,___G__23__23_get_2d_standard_2d_level)
#define ___PRM__23__23_get_2d_standard_2d_level ___PRM(127,___G__23__23_get_2d_standard_2d_level)
#define ___GLO__23__23_global_2d_var_2d__3e_identifier ___GLO(128,___G__23__23_global_2d_var_2d__3e_identifier)
#define ___PRM__23__23_global_2d_var_2d__3e_identifier ___PRM(128,___G__23__23_global_2d_var_2d__3e_identifier)
#define ___GLO__23__23_global_2d_var_2d_primitive_2d_ref ___GLO(129,___G__23__23_global_2d_var_2d_primitive_2d_ref)
#define ___PRM__23__23_global_2d_var_2d_primitive_2d_ref ___PRM(129,___G__23__23_global_2d_var_2d_primitive_2d_ref)
#define ___GLO__23__23_global_2d_var_2d_primitive_2d_set_21_ ___GLO(130,___G__23__23_global_2d_var_2d_primitive_2d_set_21_)
#define ___PRM__23__23_global_2d_var_2d_primitive_2d_set_21_ ___PRM(130,___G__23__23_global_2d_var_2d_primitive_2d_set_21_)
#define ___GLO__23__23_global_2d_var_2d_ref ___GLO(131,___G__23__23_global_2d_var_2d_ref)
#define ___PRM__23__23_global_2d_var_2d_ref ___PRM(131,___G__23__23_global_2d_var_2d_ref)
#define ___GLO__23__23_global_2d_var_2d_set_21_ ___GLO(132,___G__23__23_global_2d_var_2d_set_21_)
#define ___PRM__23__23_global_2d_var_2d_set_21_ ___PRM(132,___G__23__23_global_2d_var_2d_set_21_)
#define ___GLO__23__23_global_2d_var_3f_ ___GLO(133,___G__23__23_global_2d_var_3f_)
#define ___PRM__23__23_global_2d_var_3f_ ___PRM(133,___G__23__23_global_2d_var_3f_)
#define ___GLO__23__23_handle_2d_gc_2d_interrupt_21_ ___GLO(134,___G__23__23_handle_2d_gc_2d_interrupt_21_)
#define ___PRM__23__23_handle_2d_gc_2d_interrupt_21_ ___PRM(134,___G__23__23_handle_2d_gc_2d_interrupt_21_)
#define ___GLO__23__23_interrupt_2d_handler ___GLO(135,___G__23__23_interrupt_2d_handler)
#define ___PRM__23__23_interrupt_2d_handler ___PRM(135,___G__23__23_interrupt_2d_handler)
#define ___GLO__23__23_interrupt_2d_vector ___GLO(136,___G__23__23_interrupt_2d_vector)
#define ___PRM__23__23_interrupt_2d_vector ___PRM(136,___G__23__23_interrupt_2d_vector)
#define ___GLO__23__23_interrupt_2d_vector_2d_set_21_ ___GLO(137,___G__23__23_interrupt_2d_vector_2d_set_21_)
#define ___PRM__23__23_interrupt_2d_vector_2d_set_21_ ___PRM(137,___G__23__23_interrupt_2d_vector_2d_set_21_)
#define ___GLO__23__23_kernel_2d_handlers ___GLO(138,___G__23__23_kernel_2d_handlers)
#define ___PRM__23__23_kernel_2d_handlers ___PRM(138,___G__23__23_kernel_2d_handlers)
#define ___GLO__23__23_keyword_2d_table ___GLO(139,___G__23__23_keyword_2d_table)
#define ___PRM__23__23_keyword_2d_table ___PRM(139,___G__23__23_keyword_2d_table)
#define ___GLO__23__23_load_2d_required_2d_module ___GLO(140,___G__23__23_load_2d_required_2d_module)
#define ___PRM__23__23_load_2d_required_2d_module ___PRM(140,___G__23__23_load_2d_required_2d_module)
#define ___GLO__23__23_load_2d_required_2d_module_2d_set_21_ ___GLO(141,___G__23__23_load_2d_required_2d_module_2d_set_21_)
#define ___PRM__23__23_load_2d_required_2d_module_2d_set_21_ ___PRM(141,___G__23__23_load_2d_required_2d_module_2d_set_21_)
#define ___GLO__23__23_load_2d_required_2d_module_2d_structs ___GLO(142,___G__23__23_load_2d_required_2d_module_2d_structs)
#define ___PRM__23__23_load_2d_required_2d_module_2d_structs ___PRM(142,___G__23__23_load_2d_required_2d_module_2d_structs)
#define ___GLO__23__23_load_2d_vm ___GLO(143,___G__23__23_load_2d_vm)
#define ___PRM__23__23_load_2d_vm ___PRM(143,___G__23__23_load_2d_vm)
#define ___GLO__23__23_lookup_2d_module ___GLO(144,___G__23__23_lookup_2d_module)
#define ___PRM__23__23_lookup_2d_module ___PRM(144,___G__23__23_lookup_2d_module)
#define ___GLO__23__23_lookup_2d_registered_2d_module ___GLO(145,___G__23__23_lookup_2d_registered_2d_module)
#define ___PRM__23__23_lookup_2d_registered_2d_module ___PRM(145,___G__23__23_lookup_2d_registered_2d_module)
#define ___GLO__23__23_machine_2d_code_2d_block_2d_exec ___GLO(146,___G__23__23_machine_2d_code_2d_block_2d_exec)
#define ___PRM__23__23_machine_2d_code_2d_block_2d_exec ___PRM(146,___G__23__23_machine_2d_code_2d_block_2d_exec)
#define ___GLO__23__23_machine_2d_code_2d_block_2d_fixup ___GLO(147,___G__23__23_machine_2d_code_2d_block_2d_fixup)
#define ___PRM__23__23_machine_2d_code_2d_block_2d_fixup ___PRM(147,___G__23__23_machine_2d_code_2d_block_2d_fixup)
#define ___GLO__23__23_machine_2d_code_2d_block_2d_ref ___GLO(148,___G__23__23_machine_2d_code_2d_block_2d_ref)
#define ___PRM__23__23_machine_2d_code_2d_block_2d_ref ___PRM(148,___G__23__23_machine_2d_code_2d_block_2d_ref)
#define ___GLO__23__23_machine_2d_code_2d_block_2d_set_21_ ___GLO(149,___G__23__23_machine_2d_code_2d_block_2d_set_21_)
#define ___PRM__23__23_machine_2d_code_2d_block_2d_set_21_ ___PRM(149,___G__23__23_machine_2d_code_2d_block_2d_set_21_)
#define ___GLO__23__23_machine_2d_code_2d_fixup ___GLO(150,___G__23__23_machine_2d_code_2d_fixup)
#define ___PRM__23__23_machine_2d_code_2d_fixup ___PRM(150,___G__23__23_machine_2d_code_2d_fixup)
#define ___GLO__23__23_main ___GLO(151,___G__23__23_main)
#define ___PRM__23__23_main ___PRM(151,___G__23__23_main)
#define ___GLO__23__23_main_2d_set_21_ ___GLO(152,___G__23__23_main_2d_set_21_)
#define ___PRM__23__23_main_2d_set_21_ ___PRM(152,___G__23__23_main_2d_set_21_)
#define ___GLO__23__23_make_2d_closure ___GLO(153,___G__23__23_make_2d_closure)
#define ___PRM__23__23_make_2d_closure ___PRM(153,___G__23__23_make_2d_closure)
#define ___GLO__23__23_make_2d_continuation ___GLO(154,___G__23__23_make_2d_continuation)
#define ___PRM__23__23_make_2d_continuation ___PRM(154,___G__23__23_make_2d_continuation)
#define ___GLO__23__23_make_2d_f32vector ___GLO(155,___G__23__23_make_2d_f32vector)
#define ___PRM__23__23_make_2d_f32vector ___PRM(155,___G__23__23_make_2d_f32vector)
#define ___GLO__23__23_make_2d_f64vector ___GLO(156,___G__23__23_make_2d_f64vector)
#define ___PRM__23__23_make_2d_f64vector ___PRM(156,___G__23__23_make_2d_f64vector)
#define ___GLO__23__23_make_2d_final_2d_will ___GLO(157,___G__23__23_make_2d_final_2d_will)
#define ___PRM__23__23_make_2d_final_2d_will ___PRM(157,___G__23__23_make_2d_final_2d_will)
#define ___GLO__23__23_make_2d_frame ___GLO(158,___G__23__23_make_2d_frame)
#define ___PRM__23__23_make_2d_frame ___PRM(158,___G__23__23_make_2d_frame)
#define ___GLO__23__23_make_2d_global_2d_var ___GLO(159,___G__23__23_make_2d_global_2d_var)
#define ___PRM__23__23_make_2d_global_2d_var ___PRM(159,___G__23__23_make_2d_global_2d_var)
#define ___GLO__23__23_make_2d_interned_2d_keyword ___GLO(160,___G__23__23_make_2d_interned_2d_keyword)
#define ___PRM__23__23_make_2d_interned_2d_keyword ___PRM(160,___G__23__23_make_2d_interned_2d_keyword)
#define ___GLO__23__23_make_2d_interned_2d_symbol ___GLO(161,___G__23__23_make_2d_interned_2d_symbol)
#define ___PRM__23__23_make_2d_interned_2d_symbol ___PRM(161,___G__23__23_make_2d_interned_2d_symbol)
#define ___GLO__23__23_make_2d_interned_2d_symkey ___GLO(162,___G__23__23_make_2d_interned_2d_symkey)
#define ___PRM__23__23_make_2d_interned_2d_symkey ___PRM(162,___G__23__23_make_2d_interned_2d_symkey)
#define ___GLO__23__23_make_2d_jobs ___GLO(163,___G__23__23_make_2d_jobs)
#define ___PRM__23__23_make_2d_jobs ___PRM(163,___G__23__23_make_2d_jobs)
#define ___GLO__23__23_make_2d_machine_2d_code_2d_block ___GLO(164,___G__23__23_make_2d_machine_2d_code_2d_block)
#define ___PRM__23__23_make_2d_machine_2d_code_2d_block ___PRM(164,___G__23__23_make_2d_machine_2d_code_2d_block)
#define ___GLO__23__23_make_2d_promise ___GLO(165,___G__23__23_make_2d_promise)
#define ___PRM__23__23_make_2d_promise ___PRM(165,___G__23__23_make_2d_promise)
#define ___GLO__23__23_make_2d_s16vector ___GLO(166,___G__23__23_make_2d_s16vector)
#define ___PRM__23__23_make_2d_s16vector ___PRM(166,___G__23__23_make_2d_s16vector)
#define ___GLO__23__23_make_2d_s32vector ___GLO(167,___G__23__23_make_2d_s32vector)
#define ___PRM__23__23_make_2d_s32vector ___PRM(167,___G__23__23_make_2d_s32vector)
#define ___GLO__23__23_make_2d_s64vector ___GLO(168,___G__23__23_make_2d_s64vector)
#define ___PRM__23__23_make_2d_s64vector ___PRM(168,___G__23__23_make_2d_s64vector)
#define ___GLO__23__23_make_2d_s8vector ___GLO(169,___G__23__23_make_2d_s8vector)
#define ___PRM__23__23_make_2d_s8vector ___PRM(169,___G__23__23_make_2d_s8vector)
#define ___GLO__23__23_make_2d_string ___GLO(170,___G__23__23_make_2d_string)
#define ___PRM__23__23_make_2d_string ___PRM(170,___G__23__23_make_2d_string)
#define ___GLO__23__23_make_2d_structure ___GLO(171,___G__23__23_make_2d_structure)
#define ___PRM__23__23_make_2d_structure ___PRM(171,___G__23__23_make_2d_structure)
#define ___GLO__23__23_make_2d_subprocedure ___GLO(172,___G__23__23_make_2d_subprocedure)
#define ___PRM__23__23_make_2d_subprocedure ___PRM(172,___G__23__23_make_2d_subprocedure)
#define ___GLO__23__23_make_2d_u16vector ___GLO(173,___G__23__23_make_2d_u16vector)
#define ___PRM__23__23_make_2d_u16vector ___PRM(173,___G__23__23_make_2d_u16vector)
#define ___GLO__23__23_make_2d_u32vector ___GLO(174,___G__23__23_make_2d_u32vector)
#define ___PRM__23__23_make_2d_u32vector ___PRM(174,___G__23__23_make_2d_u32vector)
#define ___GLO__23__23_make_2d_u64vector ___GLO(175,___G__23__23_make_2d_u64vector)
#define ___PRM__23__23_make_2d_u64vector ___PRM(175,___G__23__23_make_2d_u64vector)
#define ___GLO__23__23_make_2d_u8vector ___GLO(176,___G__23__23_make_2d_u8vector)
#define ___PRM__23__23_make_2d_u8vector ___PRM(176,___G__23__23_make_2d_u8vector)
#define ___GLO__23__23_make_2d_values ___GLO(177,___G__23__23_make_2d_values)
#define ___PRM__23__23_make_2d_values ___PRM(177,___G__23__23_make_2d_values)
#define ___GLO__23__23_make_2d_vector ___GLO(178,___G__23__23_make_2d_vector)
#define ___PRM__23__23_make_2d_vector ___PRM(178,___G__23__23_make_2d_vector)
#define ___GLO__23__23_max_2d_char ___GLO(179,___G__23__23_max_2d_char)
#define ___PRM__23__23_max_2d_char ___PRM(179,___G__23__23_max_2d_char)
#define ___GLO__23__23_max_2d_fixnum ___GLO(180,___G__23__23_max_2d_fixnum)
#define ___PRM__23__23_max_2d_fixnum ___PRM(180,___G__23__23_max_2d_fixnum)
#define ___GLO__23__23_min_2d_fixnum ___GLO(181,___G__23__23_min_2d_fixnum)
#define ___PRM__23__23_min_2d_fixnum ___PRM(181,___G__23__23_min_2d_fixnum)
#define ___GLO__23__23_module_2d_init ___GLO(182,___G__23__23_module_2d_init)
#define ___PRM__23__23_module_2d_init ___PRM(182,___G__23__23_module_2d_init)
#define ___GLO__23__23_object_2d__3e_global_2d_var ___GLO(183,___G__23__23_object_2d__3e_global_2d_var)
#define ___PRM__23__23_object_2d__3e_global_2d_var ___PRM(183,___G__23__23_object_2d__3e_global_2d_var)
#define ___GLO__23__23_object_2d__3e_global_2d_var_2d__3e_identifier ___GLO(184,___G__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
#define ___PRM__23__23_object_2d__3e_global_2d_var_2d__3e_identifier ___PRM(184,___G__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
#define ___GLO__23__23_os_2d_address_2d_infos ___GLO(185,___G__23__23_os_2d_address_2d_infos)
#define ___PRM__23__23_os_2d_address_2d_infos ___PRM(185,___G__23__23_os_2d_address_2d_infos)
#define ___GLO__23__23_os_2d_bat_2d_extension_2d_string_2d_saved ___GLO(186,___G__23__23_os_2d_bat_2d_extension_2d_string_2d_saved)
#define ___PRM__23__23_os_2d_bat_2d_extension_2d_string_2d_saved ___PRM(186,___G__23__23_os_2d_bat_2d_extension_2d_string_2d_saved)
#define ___GLO__23__23_os_2d_condvar_2d_select_21_ ___GLO(187,___G__23__23_os_2d_condvar_2d_select_21_)
#define ___PRM__23__23_os_2d_condvar_2d_select_21_ ___PRM(187,___G__23__23_os_2d_condvar_2d_select_21_)
#define ___GLO__23__23_os_2d_configure_2d_command_2d_string_2d_saved ___GLO(188,___G__23__23_os_2d_configure_2d_command_2d_string_2d_saved)
#define ___PRM__23__23_os_2d_configure_2d_command_2d_string_2d_saved ___PRM(188,___G__23__23_os_2d_configure_2d_command_2d_string_2d_saved)
#define ___GLO__23__23_os_2d_copy_2d_file ___GLO(189,___G__23__23_os_2d_copy_2d_file)
#define ___PRM__23__23_os_2d_copy_2d_file ___PRM(189,___G__23__23_os_2d_copy_2d_file)
#define ___GLO__23__23_os_2d_create_2d_directory ___GLO(190,___G__23__23_os_2d_create_2d_directory)
#define ___PRM__23__23_os_2d_create_2d_directory ___PRM(190,___G__23__23_os_2d_create_2d_directory)
#define ___GLO__23__23_os_2d_create_2d_fifo ___GLO(191,___G__23__23_os_2d_create_2d_fifo)
#define ___PRM__23__23_os_2d_create_2d_fifo ___PRM(191,___G__23__23_os_2d_create_2d_fifo)
#define ___GLO__23__23_os_2d_create_2d_link ___GLO(192,___G__23__23_os_2d_create_2d_link)
#define ___PRM__23__23_os_2d_create_2d_link ___PRM(192,___G__23__23_os_2d_create_2d_link)
#define ___GLO__23__23_os_2d_create_2d_symbolic_2d_link ___GLO(193,___G__23__23_os_2d_create_2d_symbolic_2d_link)
#define ___PRM__23__23_os_2d_create_2d_symbolic_2d_link ___PRM(193,___G__23__23_os_2d_create_2d_symbolic_2d_link)
#define ___GLO__23__23_os_2d_delete_2d_directory ___GLO(194,___G__23__23_os_2d_delete_2d_directory)
#define ___PRM__23__23_os_2d_delete_2d_directory ___PRM(194,___G__23__23_os_2d_delete_2d_directory)
#define ___GLO__23__23_os_2d_delete_2d_file ___GLO(195,___G__23__23_os_2d_delete_2d_file)
#define ___PRM__23__23_os_2d_delete_2d_file ___PRM(195,___G__23__23_os_2d_delete_2d_file)
#define ___GLO__23__23_os_2d_device_2d_close ___GLO(196,___G__23__23_os_2d_device_2d_close)
#define ___PRM__23__23_os_2d_device_2d_close ___PRM(196,___G__23__23_os_2d_device_2d_close)
#define ___GLO__23__23_os_2d_device_2d_directory_2d_open_2d_path ___GLO(197,___G__23__23_os_2d_device_2d_directory_2d_open_2d_path)
#define ___PRM__23__23_os_2d_device_2d_directory_2d_open_2d_path ___PRM(197,___G__23__23_os_2d_device_2d_directory_2d_open_2d_path)
#define ___GLO__23__23_os_2d_device_2d_directory_2d_read ___GLO(198,___G__23__23_os_2d_device_2d_directory_2d_read)
#define ___PRM__23__23_os_2d_device_2d_directory_2d_read ___PRM(198,___G__23__23_os_2d_device_2d_directory_2d_read)
#define ___GLO__23__23_os_2d_device_2d_event_2d_queue_2d_open ___GLO(199,___G__23__23_os_2d_device_2d_event_2d_queue_2d_open)
#define ___PRM__23__23_os_2d_device_2d_event_2d_queue_2d_open ___PRM(199,___G__23__23_os_2d_device_2d_event_2d_queue_2d_open)
#define ___GLO__23__23_os_2d_device_2d_event_2d_queue_2d_read ___GLO(200,___G__23__23_os_2d_device_2d_event_2d_queue_2d_read)
#define ___PRM__23__23_os_2d_device_2d_event_2d_queue_2d_read ___PRM(200,___G__23__23_os_2d_device_2d_event_2d_queue_2d_read)
#define ___GLO__23__23_os_2d_device_2d_force_2d_output ___GLO(201,___G__23__23_os_2d_device_2d_force_2d_output)
#define ___PRM__23__23_os_2d_device_2d_force_2d_output ___PRM(201,___G__23__23_os_2d_device_2d_force_2d_output)
#define ___GLO__23__23_os_2d_device_2d_kind ___GLO(202,___G__23__23_os_2d_device_2d_kind)
#define ___PRM__23__23_os_2d_device_2d_kind ___PRM(202,___G__23__23_os_2d_device_2d_kind)
#define ___GLO__23__23_os_2d_device_2d_open_2d_raw_2d_from_2d_fd ___GLO(203,___G__23__23_os_2d_device_2d_open_2d_raw_2d_from_2d_fd)
#define ___PRM__23__23_os_2d_device_2d_open_2d_raw_2d_from_2d_fd ___PRM(203,___G__23__23_os_2d_device_2d_open_2d_raw_2d_from_2d_fd)
#define ___GLO__23__23_os_2d_device_2d_process_2d_pid ___GLO(204,___G__23__23_os_2d_device_2d_process_2d_pid)
#define ___PRM__23__23_os_2d_device_2d_process_2d_pid ___PRM(204,___G__23__23_os_2d_device_2d_process_2d_pid)
#define ___GLO__23__23_os_2d_device_2d_process_2d_status ___GLO(205,___G__23__23_os_2d_device_2d_process_2d_status)
#define ___PRM__23__23_os_2d_device_2d_process_2d_status ___PRM(205,___G__23__23_os_2d_device_2d_process_2d_status)
#define ___GLO__23__23_os_2d_device_2d_stream_2d_default_2d_options ___GLO(206,___G__23__23_os_2d_device_2d_stream_2d_default_2d_options)
#define ___PRM__23__23_os_2d_device_2d_stream_2d_default_2d_options ___PRM(206,___G__23__23_os_2d_device_2d_stream_2d_default_2d_options)
#define ___GLO__23__23_os_2d_device_2d_stream_2d_open_2d_path ___GLO(207,___G__23__23_os_2d_device_2d_stream_2d_open_2d_path)
#define ___PRM__23__23_os_2d_device_2d_stream_2d_open_2d_path ___PRM(207,___G__23__23_os_2d_device_2d_stream_2d_open_2d_path)
#define ___GLO__23__23_os_2d_device_2d_stream_2d_open_2d_predefined ___GLO(208,___G__23__23_os_2d_device_2d_stream_2d_open_2d_predefined)
#define ___PRM__23__23_os_2d_device_2d_stream_2d_open_2d_predefined ___PRM(208,___G__23__23_os_2d_device_2d_stream_2d_open_2d_predefined)
#define ___GLO__23__23_os_2d_device_2d_stream_2d_open_2d_process ___GLO(209,___G__23__23_os_2d_device_2d_stream_2d_open_2d_process)
#define ___PRM__23__23_os_2d_device_2d_stream_2d_open_2d_process ___PRM(209,___G__23__23_os_2d_device_2d_stream_2d_open_2d_process)
#define ___GLO__23__23_os_2d_device_2d_stream_2d_options_2d_set_21_ ___GLO(210,___G__23__23_os_2d_device_2d_stream_2d_options_2d_set_21_)
#define ___PRM__23__23_os_2d_device_2d_stream_2d_options_2d_set_21_ ___PRM(210,___G__23__23_os_2d_device_2d_stream_2d_options_2d_set_21_)
#define ___GLO__23__23_os_2d_device_2d_stream_2d_read ___GLO(211,___G__23__23_os_2d_device_2d_stream_2d_read)
#define ___PRM__23__23_os_2d_device_2d_stream_2d_read ___PRM(211,___G__23__23_os_2d_device_2d_stream_2d_read)
#define ___GLO__23__23_os_2d_device_2d_stream_2d_seek ___GLO(212,___G__23__23_os_2d_device_2d_stream_2d_seek)
#define ___PRM__23__23_os_2d_device_2d_stream_2d_seek ___PRM(212,___G__23__23_os_2d_device_2d_stream_2d_seek)
#define ___GLO__23__23_os_2d_device_2d_stream_2d_width ___GLO(213,___G__23__23_os_2d_device_2d_stream_2d_width)
#define ___PRM__23__23_os_2d_device_2d_stream_2d_width ___PRM(213,___G__23__23_os_2d_device_2d_stream_2d_width)
#define ___GLO__23__23_os_2d_device_2d_stream_2d_write ___GLO(214,___G__23__23_os_2d_device_2d_stream_2d_write)
#define ___PRM__23__23_os_2d_device_2d_stream_2d_write ___PRM(214,___G__23__23_os_2d_device_2d_stream_2d_write)
#define ___GLO__23__23_os_2d_device_2d_tcp_2d_client_2d_open ___GLO(215,___G__23__23_os_2d_device_2d_tcp_2d_client_2d_open)
#define ___PRM__23__23_os_2d_device_2d_tcp_2d_client_2d_open ___PRM(215,___G__23__23_os_2d_device_2d_tcp_2d_client_2d_open)
#define ___GLO__23__23_os_2d_device_2d_tcp_2d_client_2d_socket_2d_info ___GLO(216,___G__23__23_os_2d_device_2d_tcp_2d_client_2d_socket_2d_info)
#define ___PRM__23__23_os_2d_device_2d_tcp_2d_client_2d_socket_2d_info ___PRM(216,___G__23__23_os_2d_device_2d_tcp_2d_client_2d_socket_2d_info)
#define ___GLO__23__23_os_2d_device_2d_tcp_2d_server_2d_open ___GLO(217,___G__23__23_os_2d_device_2d_tcp_2d_server_2d_open)
#define ___PRM__23__23_os_2d_device_2d_tcp_2d_server_2d_open ___PRM(217,___G__23__23_os_2d_device_2d_tcp_2d_server_2d_open)
#define ___GLO__23__23_os_2d_device_2d_tcp_2d_server_2d_read ___GLO(218,___G__23__23_os_2d_device_2d_tcp_2d_server_2d_read)
#define ___PRM__23__23_os_2d_device_2d_tcp_2d_server_2d_read ___PRM(218,___G__23__23_os_2d_device_2d_tcp_2d_server_2d_read)
#define ___GLO__23__23_os_2d_device_2d_tcp_2d_server_2d_socket_2d_info ___GLO(219,___G__23__23_os_2d_device_2d_tcp_2d_server_2d_socket_2d_info)
#define ___PRM__23__23_os_2d_device_2d_tcp_2d_server_2d_socket_2d_info ___PRM(219,___G__23__23_os_2d_device_2d_tcp_2d_server_2d_socket_2d_info)
#define ___GLO__23__23_os_2d_device_2d_tty_2d_history ___GLO(220,___G__23__23_os_2d_device_2d_tty_2d_history)
#define ___PRM__23__23_os_2d_device_2d_tty_2d_history ___PRM(220,___G__23__23_os_2d_device_2d_tty_2d_history)
#define ___GLO__23__23_os_2d_device_2d_tty_2d_history_2d_max_2d_length_2d_set_21_ ___GLO(221,___G__23__23_os_2d_device_2d_tty_2d_history_2d_max_2d_length_2d_set_21_)
#define ___PRM__23__23_os_2d_device_2d_tty_2d_history_2d_max_2d_length_2d_set_21_ ___PRM(221,___G__23__23_os_2d_device_2d_tty_2d_history_2d_max_2d_length_2d_set_21_)
#define ___GLO__23__23_os_2d_device_2d_tty_2d_history_2d_set_21_ ___GLO(222,___G__23__23_os_2d_device_2d_tty_2d_history_2d_set_21_)
#define ___PRM__23__23_os_2d_device_2d_tty_2d_history_2d_set_21_ ___PRM(222,___G__23__23_os_2d_device_2d_tty_2d_history_2d_set_21_)
#define ___GLO__23__23_os_2d_device_2d_tty_2d_mode_2d_set_21_ ___GLO(223,___G__23__23_os_2d_device_2d_tty_2d_mode_2d_set_21_)
#define ___PRM__23__23_os_2d_device_2d_tty_2d_mode_2d_set_21_ ___PRM(223,___G__23__23_os_2d_device_2d_tty_2d_mode_2d_set_21_)
#define ___GLO__23__23_os_2d_device_2d_tty_2d_paren_2d_balance_2d_duration_2d_set_21_ ___GLO(224,___G__23__23_os_2d_device_2d_tty_2d_paren_2d_balance_2d_duration_2d_set_21_)
#define ___PRM__23__23_os_2d_device_2d_tty_2d_paren_2d_balance_2d_duration_2d_set_21_ ___PRM(224,___G__23__23_os_2d_device_2d_tty_2d_paren_2d_balance_2d_duration_2d_set_21_)
#define ___GLO__23__23_os_2d_device_2d_tty_2d_text_2d_attributes_2d_set_21_ ___GLO(225,___G__23__23_os_2d_device_2d_tty_2d_text_2d_attributes_2d_set_21_)
#define ___PRM__23__23_os_2d_device_2d_tty_2d_text_2d_attributes_2d_set_21_ ___PRM(225,___G__23__23_os_2d_device_2d_tty_2d_text_2d_attributes_2d_set_21_)
#define ___GLO__23__23_os_2d_device_2d_tty_2d_type_2d_set_21_ ___GLO(226,___G__23__23_os_2d_device_2d_tty_2d_type_2d_set_21_)
#define ___PRM__23__23_os_2d_device_2d_tty_2d_type_2d_set_21_ ___PRM(226,___G__23__23_os_2d_device_2d_tty_2d_type_2d_set_21_)
#define ___GLO__23__23_os_2d_device_2d_udp_2d_destination_2d_set_21_ ___GLO(227,___G__23__23_os_2d_device_2d_udp_2d_destination_2d_set_21_)
#define ___PRM__23__23_os_2d_device_2d_udp_2d_destination_2d_set_21_ ___PRM(227,___G__23__23_os_2d_device_2d_udp_2d_destination_2d_set_21_)
#define ___GLO__23__23_os_2d_device_2d_udp_2d_open ___GLO(228,___G__23__23_os_2d_device_2d_udp_2d_open)
#define ___PRM__23__23_os_2d_device_2d_udp_2d_open ___PRM(228,___G__23__23_os_2d_device_2d_udp_2d_open)
#define ___GLO__23__23_os_2d_device_2d_udp_2d_read_2d_subu8vector ___GLO(229,___G__23__23_os_2d_device_2d_udp_2d_read_2d_subu8vector)
#define ___PRM__23__23_os_2d_device_2d_udp_2d_read_2d_subu8vector ___PRM(229,___G__23__23_os_2d_device_2d_udp_2d_read_2d_subu8vector)
#define ___GLO__23__23_os_2d_device_2d_udp_2d_socket_2d_info ___GLO(230,___G__23__23_os_2d_device_2d_udp_2d_socket_2d_info)
#define ___PRM__23__23_os_2d_device_2d_udp_2d_socket_2d_info ___PRM(230,___G__23__23_os_2d_device_2d_udp_2d_socket_2d_info)
#define ___GLO__23__23_os_2d_device_2d_udp_2d_write_2d_subu8vector ___GLO(231,___G__23__23_os_2d_device_2d_udp_2d_write_2d_subu8vector)
#define ___PRM__23__23_os_2d_device_2d_udp_2d_write_2d_subu8vector ___PRM(231,___G__23__23_os_2d_device_2d_udp_2d_write_2d_subu8vector)
#define ___GLO__23__23_os_2d_environ ___GLO(232,___G__23__23_os_2d_environ)
#define ___PRM__23__23_os_2d_environ ___PRM(232,___G__23__23_os_2d_environ)
#define ___GLO__23__23_os_2d_err_2d_code_2d__3e_string ___GLO(233,___G__23__23_os_2d_err_2d_code_2d__3e_string)
#define ___PRM__23__23_os_2d_err_2d_code_2d__3e_string ___PRM(233,___G__23__23_os_2d_err_2d_code_2d__3e_string)
#define ___GLO__23__23_os_2d_exe_2d_extension_2d_string_2d_saved ___GLO(234,___G__23__23_os_2d_exe_2d_extension_2d_string_2d_saved)
#define ___PRM__23__23_os_2d_exe_2d_extension_2d_string_2d_saved ___PRM(234,___G__23__23_os_2d_exe_2d_extension_2d_string_2d_saved)
#define ___GLO__23__23_os_2d_file_2d_info ___GLO(235,___G__23__23_os_2d_file_2d_info)
#define ___PRM__23__23_os_2d_file_2d_info ___PRM(235,___G__23__23_os_2d_file_2d_info)
#define ___GLO__23__23_os_2d_file_2d_times_2d_set_21_ ___GLO(236,___G__23__23_os_2d_file_2d_times_2d_set_21_)
#define ___PRM__23__23_os_2d_file_2d_times_2d_set_21_ ___PRM(236,___G__23__23_os_2d_file_2d_times_2d_set_21_)
#define ___GLO__23__23_os_2d_getenv ___GLO(237,___G__23__23_os_2d_getenv)
#define ___PRM__23__23_os_2d_getenv ___PRM(237,___G__23__23_os_2d_getenv)
#define ___GLO__23__23_os_2d_getpid ___GLO(238,___G__23__23_os_2d_getpid)
#define ___PRM__23__23_os_2d_getpid ___PRM(238,___G__23__23_os_2d_getpid)
#define ___GLO__23__23_os_2d_getppid ___GLO(239,___G__23__23_os_2d_getppid)
#define ___PRM__23__23_os_2d_getppid ___PRM(239,___G__23__23_os_2d_getppid)
#define ___GLO__23__23_os_2d_group_2d_info ___GLO(240,___G__23__23_os_2d_group_2d_info)
#define ___PRM__23__23_os_2d_group_2d_info ___PRM(240,___G__23__23_os_2d_group_2d_info)
#define ___GLO__23__23_os_2d_host_2d_info ___GLO(241,___G__23__23_os_2d_host_2d_info)
#define ___PRM__23__23_os_2d_host_2d_info ___PRM(241,___G__23__23_os_2d_host_2d_info)
#define ___GLO__23__23_os_2d_host_2d_name ___GLO(242,___G__23__23_os_2d_host_2d_name)
#define ___PRM__23__23_os_2d_host_2d_name ___PRM(242,___G__23__23_os_2d_host_2d_name)
#define ___GLO__23__23_os_2d_load_2d_object_2d_file ___GLO(243,___G__23__23_os_2d_load_2d_object_2d_file)
#define ___PRM__23__23_os_2d_load_2d_object_2d_file ___PRM(243,___G__23__23_os_2d_load_2d_object_2d_file)
#define ___GLO__23__23_os_2d_make_2d_tls_2d_context ___GLO(244,___G__23__23_os_2d_make_2d_tls_2d_context)
#define ___PRM__23__23_os_2d_make_2d_tls_2d_context ___PRM(244,___G__23__23_os_2d_make_2d_tls_2d_context)
#define ___GLO__23__23_os_2d_network_2d_info ___GLO(245,___G__23__23_os_2d_network_2d_info)
#define ___PRM__23__23_os_2d_network_2d_info ___PRM(245,___G__23__23_os_2d_network_2d_info)
#define ___GLO__23__23_os_2d_obj_2d_extension_2d_string_2d_saved ___GLO(246,___G__23__23_os_2d_obj_2d_extension_2d_string_2d_saved)
#define ___PRM__23__23_os_2d_obj_2d_extension_2d_string_2d_saved ___PRM(246,___G__23__23_os_2d_obj_2d_extension_2d_string_2d_saved)
#define ___GLO__23__23_os_2d_path_2d_gambitdir ___GLO(247,___G__23__23_os_2d_path_2d_gambitdir)
#define ___PRM__23__23_os_2d_path_2d_gambitdir ___PRM(247,___G__23__23_os_2d_path_2d_gambitdir)
#define ___GLO__23__23_os_2d_path_2d_gambitdir_2d_map_2d_lookup ___GLO(248,___G__23__23_os_2d_path_2d_gambitdir_2d_map_2d_lookup)
#define ___PRM__23__23_os_2d_path_2d_gambitdir_2d_map_2d_lookup ___PRM(248,___G__23__23_os_2d_path_2d_gambitdir_2d_map_2d_lookup)
#define ___GLO__23__23_os_2d_path_2d_homedir ___GLO(249,___G__23__23_os_2d_path_2d_homedir)
#define ___PRM__23__23_os_2d_path_2d_homedir ___PRM(249,___G__23__23_os_2d_path_2d_homedir)
#define ___GLO__23__23_os_2d_path_2d_normalize_2d_directory ___GLO(250,___G__23__23_os_2d_path_2d_normalize_2d_directory)
#define ___PRM__23__23_os_2d_path_2d_normalize_2d_directory ___PRM(250,___G__23__23_os_2d_path_2d_normalize_2d_directory)
#define ___GLO__23__23_os_2d_protocol_2d_info ___GLO(251,___G__23__23_os_2d_protocol_2d_info)
#define ___PRM__23__23_os_2d_protocol_2d_info ___PRM(251,___G__23__23_os_2d_protocol_2d_info)
#define ___GLO__23__23_os_2d_rename_2d_file ___GLO(252,___G__23__23_os_2d_rename_2d_file)
#define ___PRM__23__23_os_2d_rename_2d_file ___PRM(252,___G__23__23_os_2d_rename_2d_file)
#define ___GLO__23__23_os_2d_service_2d_info ___GLO(253,___G__23__23_os_2d_service_2d_info)
#define ___PRM__23__23_os_2d_service_2d_info ___PRM(253,___G__23__23_os_2d_service_2d_info)
#define ___GLO__23__23_os_2d_set_2d_current_2d_directory ___GLO(254,___G__23__23_os_2d_set_2d_current_2d_directory)
#define ___PRM__23__23_os_2d_set_2d_current_2d_directory ___PRM(254,___G__23__23_os_2d_set_2d_current_2d_directory)
#define ___GLO__23__23_os_2d_setenv ___GLO(255,___G__23__23_os_2d_setenv)
#define ___PRM__23__23_os_2d_setenv ___PRM(255,___G__23__23_os_2d_setenv)
#define ___GLO__23__23_os_2d_shell_2d_command ___GLO(256,___G__23__23_os_2d_shell_2d_command)
#define ___PRM__23__23_os_2d_shell_2d_command ___PRM(256,___G__23__23_os_2d_shell_2d_command)
#define ___GLO__23__23_os_2d_system_2d_type_2d_saved ___GLO(257,___G__23__23_os_2d_system_2d_type_2d_saved)
#define ___PRM__23__23_os_2d_system_2d_type_2d_saved ___PRM(257,___G__23__23_os_2d_system_2d_type_2d_saved)
#define ___GLO__23__23_os_2d_system_2d_type_2d_string_2d_saved ___GLO(258,___G__23__23_os_2d_system_2d_type_2d_string_2d_saved)
#define ___PRM__23__23_os_2d_system_2d_type_2d_string_2d_saved ___PRM(258,___G__23__23_os_2d_system_2d_type_2d_string_2d_saved)
#define ___GLO__23__23_os_2d_user_2d_info ___GLO(259,___G__23__23_os_2d_user_2d_info)
#define ___PRM__23__23_os_2d_user_2d_info ___PRM(259,___G__23__23_os_2d_user_2d_info)
#define ___GLO__23__23_os_2d_user_2d_name ___GLO(260,___G__23__23_os_2d_user_2d_name)
#define ___PRM__23__23_os_2d_user_2d_name ___PRM(260,___G__23__23_os_2d_user_2d_name)
#define ___GLO__23__23_process_2d_statistics ___GLO(261,___G__23__23_process_2d_statistics)
#define ___PRM__23__23_process_2d_statistics ___PRM(261,___G__23__23_process_2d_statistics)
#define ___GLO__23__23_process_2d_times ___GLO(262,___G__23__23_process_2d_times)
#define ___PRM__23__23_process_2d_times ___PRM(262,___G__23__23_process_2d_times)
#define ___GLO__23__23_processed_2d_command_2d_line ___GLO(263,___G__23__23_processed_2d_command_2d_line)
#define ___PRM__23__23_processed_2d_command_2d_line ___PRM(263,___G__23__23_processed_2d_command_2d_line)
#define ___GLO__23__23_processed_2d_command_2d_line_2d_set_21_ ___GLO(264,___G__23__23_processed_2d_command_2d_line_2d_set_21_)
#define ___PRM__23__23_processed_2d_command_2d_line_2d_set_21_ ___PRM(264,___G__23__23_processed_2d_command_2d_line_2d_set_21_)
#define ___GLO__23__23_program_2d_descr ___GLO(265,___G__23__23_program_2d_descr)
#define ___PRM__23__23_program_2d_descr ___PRM(265,___G__23__23_program_2d_descr)
#define ___GLO__23__23_promise_2d_result ___GLO(266,___G__23__23_promise_2d_result)
#define ___PRM__23__23_promise_2d_result ___PRM(266,___G__23__23_promise_2d_result)
#define ___GLO__23__23_promise_2d_result_2d_set_21_ ___GLO(267,___G__23__23_promise_2d_result_2d_set_21_)
#define ___PRM__23__23_promise_2d_result_2d_set_21_ ___PRM(267,___G__23__23_promise_2d_result_2d_set_21_)
#define ___GLO__23__23_promise_2d_thunk ___GLO(268,___G__23__23_promise_2d_thunk)
#define ___PRM__23__23_promise_2d_thunk ___PRM(268,___G__23__23_promise_2d_thunk)
#define ___GLO__23__23_promise_2d_thunk_2d_set_21_ ___GLO(269,___G__23__23_promise_2d_thunk_2d_set_21_)
#define ___PRM__23__23_promise_2d_thunk_2d_set_21_ ___PRM(269,___G__23__23_promise_2d_thunk_2d_set_21_)
#define ___GLO__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary ___GLO(270,___G__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
#define ___PRM__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary ___PRM(270,___G__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
#define ___GLO__23__23_raise_2d_heap_2d_overflow_2d_exception ___GLO(271,___G__23__23_raise_2d_heap_2d_overflow_2d_exception)
#define ___PRM__23__23_raise_2d_heap_2d_overflow_2d_exception ___PRM(271,___G__23__23_raise_2d_heap_2d_overflow_2d_exception)
#define ___GLO__23__23_raise_2d_high_2d_level_2d_interrupt_21_ ___GLO(272,___G__23__23_raise_2d_high_2d_level_2d_interrupt_21_)
#define ___PRM__23__23_raise_2d_high_2d_level_2d_interrupt_21_ ___PRM(272,___G__23__23_raise_2d_high_2d_level_2d_interrupt_21_)
#define ___GLO__23__23_raise_2d_keyword_2d_expected_2d_exception ___GLO(273,___G__23__23_raise_2d_keyword_2d_expected_2d_exception)
#define ___PRM__23__23_raise_2d_keyword_2d_expected_2d_exception ___PRM(273,___G__23__23_raise_2d_keyword_2d_expected_2d_exception)
#define ___GLO__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary ___GLO(274,___G__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary)
#define ___PRM__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary ___PRM(274,___G__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary)
#define ___GLO__23__23_raise_2d_module_2d_not_2d_found_2d_exception ___GLO(275,___G__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
#define ___PRM__23__23_raise_2d_module_2d_not_2d_found_2d_exception ___PRM(275,___G__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
#define ___GLO__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception ___GLO(276,___G__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception)
#define ___PRM__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception ___PRM(276,___G__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception)
#define ___GLO__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception ___GLO(277,___G__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
#define ___PRM__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception ___PRM(277,___G__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
#define ___GLO__23__23_raise_2d_nonprocedure_2d_operator_2d_exception ___GLO(278,___G__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
#define ___PRM__23__23_raise_2d_nonprocedure_2d_operator_2d_exception ___PRM(278,___G__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
#define ___GLO__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception ___GLO(279,___G__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
#define ___PRM__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception ___PRM(279,___G__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
#define ___GLO__23__23_raise_2d_os_2d_exception ___GLO(280,___G__23__23_raise_2d_os_2d_exception)
#define ___PRM__23__23_raise_2d_os_2d_exception ___PRM(280,___G__23__23_raise_2d_os_2d_exception)
#define ___GLO__23__23_raise_2d_sfun_2d_conversion_2d_exception ___GLO(281,___G__23__23_raise_2d_sfun_2d_conversion_2d_exception)
#define ___PRM__23__23_raise_2d_sfun_2d_conversion_2d_exception ___PRM(281,___G__23__23_raise_2d_sfun_2d_conversion_2d_exception)
#define ___GLO__23__23_raise_2d_stack_2d_overflow_2d_exception ___GLO(282,___G__23__23_raise_2d_stack_2d_overflow_2d_exception)
#define ___PRM__23__23_raise_2d_stack_2d_overflow_2d_exception ___PRM(282,___G__23__23_raise_2d_stack_2d_overflow_2d_exception)
#define ___GLO__23__23_raise_2d_type_2d_exception ___GLO(283,___G__23__23_raise_2d_type_2d_exception)
#define ___PRM__23__23_raise_2d_type_2d_exception ___PRM(283,___G__23__23_raise_2d_type_2d_exception)
#define ___GLO__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception ___GLO(284,___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
#define ___PRM__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception ___PRM(284,___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
#define ___GLO__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary ___GLO(285,___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary)
#define ___PRM__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary ___PRM(285,___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary)
#define ___GLO__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception ___GLO(286,___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
#define ___PRM__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception ___PRM(286,___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
#define ___GLO__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary ___GLO(287,___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary)
#define ___PRM__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary ___PRM(287,___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary)
#define ___GLO__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception ___GLO(288,___G__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
#define ___PRM__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception ___PRM(288,___G__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
#define ___GLO__23__23_register_2d_module_2d_descr_21_ ___GLO(289,___G__23__23_register_2d_module_2d_descr_21_)
#define ___PRM__23__23_register_2d_module_2d_descr_21_ ___PRM(289,___G__23__23_register_2d_module_2d_descr_21_)
#define ___GLO__23__23_register_2d_module_2d_descrs_21_ ___GLO(290,___G__23__23_register_2d_module_2d_descrs_21_)
#define ___PRM__23__23_register_2d_module_2d_descrs_21_ ___PRM(290,___G__23__23_register_2d_module_2d_descrs_21_)
#define ___GLO__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_ ___GLO(291,___G__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
#define ___PRM__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_ ___PRM(291,___G__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
#define ___GLO__23__23_registered_2d_modules ___GLO(292,___G__23__23_registered_2d_modules)
#define ___PRM__23__23_registered_2d_modules ___PRM(292,___G__23__23_registered_2d_modules)
#define ___GLO__23__23_remote_2d_dbg_2d_addr ___GLO(293,___G__23__23_remote_2d_dbg_2d_addr)
#define ___PRM__23__23_remote_2d_dbg_2d_addr ___PRM(293,___G__23__23_remote_2d_dbg_2d_addr)
#define ___GLO__23__23_rest_2d_param_2d_check_2d_heap ___GLO(294,___G__23__23_rest_2d_param_2d_check_2d_heap)
#define ___PRM__23__23_rest_2d_param_2d_check_2d_heap ___PRM(294,___G__23__23_rest_2d_param_2d_check_2d_heap)
#define ___GLO__23__23_rest_2d_param_2d_heap_2d_overflow ___GLO(295,___G__23__23_rest_2d_param_2d_heap_2d_overflow)
#define ___PRM__23__23_rest_2d_param_2d_heap_2d_overflow ___PRM(295,___G__23__23_rest_2d_param_2d_heap_2d_overflow)
#define ___GLO__23__23_rest_2d_param_2d_resume_2d_procedure ___GLO(296,___G__23__23_rest_2d_param_2d_resume_2d_procedure)
#define ___PRM__23__23_rest_2d_param_2d_resume_2d_procedure ___PRM(296,___G__23__23_rest_2d_param_2d_resume_2d_procedure)
#define ___GLO__23__23_return_2d_fs ___GLO(297,___G__23__23_return_2d_fs)
#define ___PRM__23__23_return_2d_fs ___PRM(297,___G__23__23_return_2d_fs)
#define ___GLO__23__23_rpc_2d_server_2d_addr ___GLO(298,___G__23__23_rpc_2d_server_2d_addr)
#define ___PRM__23__23_rpc_2d_server_2d_addr ___PRM(298,___G__23__23_rpc_2d_server_2d_addr)
#define ___GLO__23__23_set_2d_debug_2d_settings_21_ ___GLO(299,___G__23__23_set_2d_debug_2d_settings_21_)
#define ___PRM__23__23_set_2d_debug_2d_settings_21_ ___PRM(299,___G__23__23_set_2d_debug_2d_settings_21_)
#define ___GLO__23__23_set_2d_gambitdir_21_ ___GLO(300,___G__23__23_set_2d_gambitdir_21_)
#define ___PRM__23__23_set_2d_gambitdir_21_ ___PRM(300,___G__23__23_set_2d_gambitdir_21_)
#define ___GLO__23__23_set_2d_heartbeat_2d_interval_21_ ___GLO(301,___G__23__23_set_2d_heartbeat_2d_interval_21_)
#define ___PRM__23__23_set_2d_heartbeat_2d_interval_21_ ___PRM(301,___G__23__23_set_2d_heartbeat_2d_interval_21_)
#define ___GLO__23__23_set_2d_live_2d_percent_21_ ___GLO(302,___G__23__23_set_2d_live_2d_percent_21_)
#define ___PRM__23__23_set_2d_live_2d_percent_21_ ___PRM(302,___G__23__23_set_2d_live_2d_percent_21_)
#define ___GLO__23__23_set_2d_max_2d_heap_21_ ___GLO(303,___G__23__23_set_2d_max_2d_heap_21_)
#define ___PRM__23__23_set_2d_max_2d_heap_21_ ___PRM(303,___G__23__23_set_2d_max_2d_heap_21_)
#define ___GLO__23__23_set_2d_min_2d_heap_21_ ___GLO(304,___G__23__23_set_2d_min_2d_heap_21_)
#define ___PRM__23__23_set_2d_min_2d_heap_21_ ___PRM(304,___G__23__23_set_2d_min_2d_heap_21_)
#define ___GLO__23__23_set_2d_parallelism_2d_level_21_ ___GLO(305,___G__23__23_set_2d_parallelism_2d_level_21_)
#define ___PRM__23__23_set_2d_parallelism_2d_level_21_ ___PRM(305,___G__23__23_set_2d_parallelism_2d_level_21_)
#define ___GLO__23__23_set_2d_standard_2d_level_21_ ___GLO(306,___G__23__23_set_2d_standard_2d_level_21_)
#define ___PRM__23__23_set_2d_standard_2d_level_21_ ___PRM(306,___G__23__23_set_2d_standard_2d_level_21_)
#define ___GLO__23__23_still_2d_copy ___GLO(307,___G__23__23_still_2d_copy)
#define ___PRM__23__23_still_2d_copy ___PRM(307,___G__23__23_still_2d_copy)
#define ___GLO__23__23_still_2d_obj_2d_refcount_2d_dec_21_ ___GLO(308,___G__23__23_still_2d_obj_2d_refcount_2d_dec_21_)
#define ___PRM__23__23_still_2d_obj_2d_refcount_2d_dec_21_ ___PRM(308,___G__23__23_still_2d_obj_2d_refcount_2d_dec_21_)
#define ___GLO__23__23_still_2d_obj_2d_refcount_2d_inc_21_ ___GLO(309,___G__23__23_still_2d_obj_2d_refcount_2d_inc_21_)
#define ___PRM__23__23_still_2d_obj_2d_refcount_2d_inc_21_ ___PRM(309,___G__23__23_still_2d_obj_2d_refcount_2d_inc_21_)
#define ___GLO__23__23_structure ___GLO(310,___G__23__23_structure)
#define ___PRM__23__23_structure ___PRM(310,___G__23__23_structure)
#define ___GLO__23__23_structure_2d_cas_21_ ___GLO(311,___G__23__23_structure_2d_cas_21_)
#define ___PRM__23__23_structure_2d_cas_21_ ___PRM(311,___G__23__23_structure_2d_cas_21_)
#define ___GLO__23__23_structure_2d_direct_2d_instance_2d_of_3f_ ___GLO(312,___G__23__23_structure_2d_direct_2d_instance_2d_of_3f_)
#define ___PRM__23__23_structure_2d_direct_2d_instance_2d_of_3f_ ___PRM(312,___G__23__23_structure_2d_direct_2d_instance_2d_of_3f_)
#define ___GLO__23__23_structure_2d_instance_2d_of_3f_ ___GLO(313,___G__23__23_structure_2d_instance_2d_of_3f_)
#define ___PRM__23__23_structure_2d_instance_2d_of_3f_ ___PRM(313,___G__23__23_structure_2d_instance_2d_of_3f_)
#define ___GLO__23__23_structure_2d_length ___GLO(314,___G__23__23_structure_2d_length)
#define ___PRM__23__23_structure_2d_length ___PRM(314,___G__23__23_structure_2d_length)
#define ___GLO__23__23_structure_2d_ref ___GLO(315,___G__23__23_structure_2d_ref)
#define ___PRM__23__23_structure_2d_ref ___PRM(315,___G__23__23_structure_2d_ref)
#define ___GLO__23__23_structure_2d_set_21_ ___GLO(316,___G__23__23_structure_2d_set_21_)
#define ___PRM__23__23_structure_2d_set_21_ ___PRM(316,___G__23__23_structure_2d_set_21_)
#define ___GLO__23__23_structure_2d_type ___GLO(317,___G__23__23_structure_2d_type)
#define ___PRM__23__23_structure_2d_type ___PRM(317,___G__23__23_structure_2d_type)
#define ___GLO__23__23_structure_2d_type_2d_set_21_ ___GLO(318,___G__23__23_structure_2d_type_2d_set_21_)
#define ___PRM__23__23_structure_2d_type_2d_set_21_ ___PRM(318,___G__23__23_structure_2d_type_2d_set_21_)
#define ___GLO__23__23_subprocedure_2d_id ___GLO(319,___G__23__23_subprocedure_2d_id)
#define ___PRM__23__23_subprocedure_2d_id ___PRM(319,___G__23__23_subprocedure_2d_id)
#define ___GLO__23__23_subprocedure_2d_nb_2d_closed ___GLO(320,___G__23__23_subprocedure_2d_nb_2d_closed)
#define ___PRM__23__23_subprocedure_2d_nb_2d_closed ___PRM(320,___G__23__23_subprocedure_2d_nb_2d_closed)
#define ___GLO__23__23_subprocedure_2d_nb_2d_parameters ___GLO(321,___G__23__23_subprocedure_2d_nb_2d_parameters)
#define ___PRM__23__23_subprocedure_2d_nb_2d_parameters ___PRM(321,___G__23__23_subprocedure_2d_nb_2d_parameters)
#define ___GLO__23__23_subprocedure_2d_parent ___GLO(322,___G__23__23_subprocedure_2d_parent)
#define ___PRM__23__23_subprocedure_2d_parent ___PRM(322,___G__23__23_subprocedure_2d_parent)
#define ___GLO__23__23_subprocedure_2d_parent_2d_info ___GLO(323,___G__23__23_subprocedure_2d_parent_2d_info)
#define ___PRM__23__23_subprocedure_2d_parent_2d_info ___PRM(323,___G__23__23_subprocedure_2d_parent_2d_info)
#define ___GLO__23__23_subprocedure_2d_parent_2d_name ___GLO(324,___G__23__23_subprocedure_2d_parent_2d_name)
#define ___PRM__23__23_subprocedure_2d_parent_2d_name ___PRM(324,___G__23__23_subprocedure_2d_parent_2d_name)
#define ___GLO__23__23_subprocedure_3f_ ___GLO(325,___G__23__23_subprocedure_3f_)
#define ___PRM__23__23_subprocedure_3f_ ___PRM(325,___G__23__23_subprocedure_3f_)
#define ___GLO__23__23_symbol_2d_table ___GLO(326,___G__23__23_symbol_2d_table)
#define ___PRM__23__23_symbol_2d_table ___PRM(326,___G__23__23_symbol_2d_table)
#define ___GLO__23__23_sync_2d_op_2d_interrupt_21_ ___GLO(327,___G__23__23_sync_2d_op_2d_interrupt_21_)
#define ___PRM__23__23_sync_2d_op_2d_interrupt_21_ ___PRM(327,___G__23__23_sync_2d_op_2d_interrupt_21_)
#define ___GLO__23__23_system_2d_stamp ___GLO(328,___G__23__23_system_2d_stamp)
#define ___PRM__23__23_system_2d_stamp ___PRM(328,___G__23__23_system_2d_stamp)
#define ___GLO__23__23_system_2d_stamp_2d_saved ___GLO(329,___G__23__23_system_2d_stamp_2d_saved)
#define ___PRM__23__23_system_2d_stamp_2d_saved ___PRM(329,___G__23__23_system_2d_stamp_2d_saved)
#define ___GLO__23__23_system_2d_version ___GLO(330,___G__23__23_system_2d_version)
#define ___PRM__23__23_system_2d_version ___PRM(330,___G__23__23_system_2d_version)
#define ___GLO__23__23_system_2d_version_2d_string ___GLO(331,___G__23__23_system_2d_version_2d_string)
#define ___PRM__23__23_system_2d_version_2d_string ___PRM(331,___G__23__23_system_2d_version_2d_string)
#define ___GLO__23__23_type_2d_fields ___GLO(332,___G__23__23_type_2d_fields)
#define ___PRM__23__23_type_2d_fields ___PRM(332,___G__23__23_type_2d_fields)
#define ___GLO__23__23_type_2d_flags ___GLO(333,___G__23__23_type_2d_flags)
#define ___PRM__23__23_type_2d_flags ___PRM(333,___G__23__23_type_2d_flags)
#define ___GLO__23__23_type_2d_id ___GLO(334,___G__23__23_type_2d_id)
#define ___PRM__23__23_type_2d_id ___PRM(334,___G__23__23_type_2d_id)
#define ___GLO__23__23_type_2d_name ___GLO(335,___G__23__23_type_2d_name)
#define ___PRM__23__23_type_2d_name ___PRM(335,___G__23__23_type_2d_name)
#define ___GLO__23__23_type_2d_super ___GLO(336,___G__23__23_type_2d_super)
#define ___PRM__23__23_type_2d_super ___PRM(336,___G__23__23_type_2d_super)
#define ___GLO__23__23_type_2d_type ___GLO(337,___G__23__23_type_2d_type)
#define ___PRM__23__23_type_2d_type ___PRM(337,___G__23__23_type_2d_type)
#define ___GLO__23__23_type_3f_ ___GLO(338,___G__23__23_type_3f_)
#define ___PRM__23__23_type_3f_ ___PRM(338,___G__23__23_type_3f_)
#define ___GLO__23__23_unchecked_2d_structure_2d_cas_21_ ___GLO(339,___G__23__23_unchecked_2d_structure_2d_cas_21_)
#define ___PRM__23__23_unchecked_2d_structure_2d_cas_21_ ___PRM(339,___G__23__23_unchecked_2d_structure_2d_cas_21_)
#define ___GLO__23__23_unchecked_2d_structure_2d_ref ___GLO(340,___G__23__23_unchecked_2d_structure_2d_ref)
#define ___PRM__23__23_unchecked_2d_structure_2d_ref ___PRM(340,___G__23__23_unchecked_2d_structure_2d_ref)
#define ___GLO__23__23_unchecked_2d_structure_2d_set_21_ ___GLO(341,___G__23__23_unchecked_2d_structure_2d_set_21_)
#define ___PRM__23__23_unchecked_2d_structure_2d_set_21_ ___PRM(341,___G__23__23_unchecked_2d_structure_2d_set_21_)
#define ___GLO__23__23_values_2d_length ___GLO(342,___G__23__23_values_2d_length)
#define ___PRM__23__23_values_2d_length ___PRM(342,___G__23__23_values_2d_length)
#define ___GLO__23__23_values_2d_ref ___GLO(343,___G__23__23_values_2d_ref)
#define ___PRM__23__23_values_2d_ref ___PRM(343,___G__23__23_values_2d_ref)
#define ___GLO__23__23_values_2d_set_21_ ___GLO(344,___G__23__23_values_2d_set_21_)
#define ___PRM__23__23_values_2d_set_21_ ___PRM(344,___G__23__23_values_2d_set_21_)
#define ___GLO__23__23_vm_2d_main_2d_module_2d_id ___GLO(345,___G__23__23_vm_2d_main_2d_module_2d_id)
#define ___PRM__23__23_vm_2d_main_2d_module_2d_id ___PRM(345,___G__23__23_vm_2d_main_2d_module_2d_id)
#define ___GLO__23__23_with_2d_no_2d_result_2d_expected ___GLO(346,___G__23__23_with_2d_no_2d_result_2d_expected)
#define ___PRM__23__23_with_2d_no_2d_result_2d_expected ___PRM(346,___G__23__23_with_2d_no_2d_result_2d_expected)
#define ___GLO__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel ___GLO(347,___G__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel)
#define ___PRM__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel ___PRM(347,___G__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel)
#define ___GLO___kernel_23_ ___GLO(348,___G___kernel_23_)
#define ___PRM___kernel_23_ ___PRM(348,___G___kernel_23_)
#define ___GLO___kernel_23_0 ___GLO(349,___G___kernel_23_0)
#define ___PRM___kernel_23_0 ___PRM(349,___G___kernel_23_0)
#define ___GLO___kernel_23_1 ___GLO(350,___G___kernel_23_1)
#define ___PRM___kernel_23_1 ___PRM(350,___G___kernel_23_1)
#define ___GLO___kernel_23_10 ___GLO(351,___G___kernel_23_10)
#define ___PRM___kernel_23_10 ___PRM(351,___G___kernel_23_10)
#define ___GLO___kernel_23_11 ___GLO(352,___G___kernel_23_11)
#define ___PRM___kernel_23_11 ___PRM(352,___G___kernel_23_11)
#define ___GLO___kernel_23_12 ___GLO(353,___G___kernel_23_12)
#define ___PRM___kernel_23_12 ___PRM(353,___G___kernel_23_12)
#define ___GLO___kernel_23_13 ___GLO(354,___G___kernel_23_13)
#define ___PRM___kernel_23_13 ___PRM(354,___G___kernel_23_13)
#define ___GLO___kernel_23_14 ___GLO(355,___G___kernel_23_14)
#define ___PRM___kernel_23_14 ___PRM(355,___G___kernel_23_14)
#define ___GLO___kernel_23_15 ___GLO(356,___G___kernel_23_15)
#define ___PRM___kernel_23_15 ___PRM(356,___G___kernel_23_15)
#define ___GLO___kernel_23_16 ___GLO(357,___G___kernel_23_16)
#define ___PRM___kernel_23_16 ___PRM(357,___G___kernel_23_16)
#define ___GLO___kernel_23_17 ___GLO(358,___G___kernel_23_17)
#define ___PRM___kernel_23_17 ___PRM(358,___G___kernel_23_17)
#define ___GLO___kernel_23_18 ___GLO(359,___G___kernel_23_18)
#define ___PRM___kernel_23_18 ___PRM(359,___G___kernel_23_18)
#define ___GLO___kernel_23_19 ___GLO(360,___G___kernel_23_19)
#define ___PRM___kernel_23_19 ___PRM(360,___G___kernel_23_19)
#define ___GLO___kernel_23_2 ___GLO(361,___G___kernel_23_2)
#define ___PRM___kernel_23_2 ___PRM(361,___G___kernel_23_2)
#define ___GLO___kernel_23_20 ___GLO(362,___G___kernel_23_20)
#define ___PRM___kernel_23_20 ___PRM(362,___G___kernel_23_20)
#define ___GLO___kernel_23_21 ___GLO(363,___G___kernel_23_21)
#define ___PRM___kernel_23_21 ___PRM(363,___G___kernel_23_21)
#define ___GLO___kernel_23_22 ___GLO(364,___G___kernel_23_22)
#define ___PRM___kernel_23_22 ___PRM(364,___G___kernel_23_22)
#define ___GLO___kernel_23_23 ___GLO(365,___G___kernel_23_23)
#define ___PRM___kernel_23_23 ___PRM(365,___G___kernel_23_23)
#define ___GLO___kernel_23_24 ___GLO(366,___G___kernel_23_24)
#define ___PRM___kernel_23_24 ___PRM(366,___G___kernel_23_24)
#define ___GLO___kernel_23_25 ___GLO(367,___G___kernel_23_25)
#define ___PRM___kernel_23_25 ___PRM(367,___G___kernel_23_25)
#define ___GLO___kernel_23_26 ___GLO(368,___G___kernel_23_26)
#define ___PRM___kernel_23_26 ___PRM(368,___G___kernel_23_26)
#define ___GLO___kernel_23_27 ___GLO(369,___G___kernel_23_27)
#define ___PRM___kernel_23_27 ___PRM(369,___G___kernel_23_27)
#define ___GLO___kernel_23_28 ___GLO(370,___G___kernel_23_28)
#define ___PRM___kernel_23_28 ___PRM(370,___G___kernel_23_28)
#define ___GLO___kernel_23_29 ___GLO(371,___G___kernel_23_29)
#define ___PRM___kernel_23_29 ___PRM(371,___G___kernel_23_29)
#define ___GLO___kernel_23_3 ___GLO(372,___G___kernel_23_3)
#define ___PRM___kernel_23_3 ___PRM(372,___G___kernel_23_3)
#define ___GLO___kernel_23_30 ___GLO(373,___G___kernel_23_30)
#define ___PRM___kernel_23_30 ___PRM(373,___G___kernel_23_30)
#define ___GLO___kernel_23_31 ___GLO(374,___G___kernel_23_31)
#define ___PRM___kernel_23_31 ___PRM(374,___G___kernel_23_31)
#define ___GLO___kernel_23_32 ___GLO(375,___G___kernel_23_32)
#define ___PRM___kernel_23_32 ___PRM(375,___G___kernel_23_32)
#define ___GLO___kernel_23_33 ___GLO(376,___G___kernel_23_33)
#define ___PRM___kernel_23_33 ___PRM(376,___G___kernel_23_33)
#define ___GLO___kernel_23_34 ___GLO(377,___G___kernel_23_34)
#define ___PRM___kernel_23_34 ___PRM(377,___G___kernel_23_34)
#define ___GLO___kernel_23_35 ___GLO(378,___G___kernel_23_35)
#define ___PRM___kernel_23_35 ___PRM(378,___G___kernel_23_35)
#define ___GLO___kernel_23_36 ___GLO(379,___G___kernel_23_36)
#define ___PRM___kernel_23_36 ___PRM(379,___G___kernel_23_36)
#define ___GLO___kernel_23_37 ___GLO(380,___G___kernel_23_37)
#define ___PRM___kernel_23_37 ___PRM(380,___G___kernel_23_37)
#define ___GLO___kernel_23_38 ___GLO(381,___G___kernel_23_38)
#define ___PRM___kernel_23_38 ___PRM(381,___G___kernel_23_38)
#define ___GLO___kernel_23_39 ___GLO(382,___G___kernel_23_39)
#define ___PRM___kernel_23_39 ___PRM(382,___G___kernel_23_39)
#define ___GLO___kernel_23_4 ___GLO(383,___G___kernel_23_4)
#define ___PRM___kernel_23_4 ___PRM(383,___G___kernel_23_4)
#define ___GLO___kernel_23_40 ___GLO(384,___G___kernel_23_40)
#define ___PRM___kernel_23_40 ___PRM(384,___G___kernel_23_40)
#define ___GLO___kernel_23_41 ___GLO(385,___G___kernel_23_41)
#define ___PRM___kernel_23_41 ___PRM(385,___G___kernel_23_41)
#define ___GLO___kernel_23_42 ___GLO(386,___G___kernel_23_42)
#define ___PRM___kernel_23_42 ___PRM(386,___G___kernel_23_42)
#define ___GLO___kernel_23_43 ___GLO(387,___G___kernel_23_43)
#define ___PRM___kernel_23_43 ___PRM(387,___G___kernel_23_43)
#define ___GLO___kernel_23_44 ___GLO(388,___G___kernel_23_44)
#define ___PRM___kernel_23_44 ___PRM(388,___G___kernel_23_44)
#define ___GLO___kernel_23_45 ___GLO(389,___G___kernel_23_45)
#define ___PRM___kernel_23_45 ___PRM(389,___G___kernel_23_45)
#define ___GLO___kernel_23_46 ___GLO(390,___G___kernel_23_46)
#define ___PRM___kernel_23_46 ___PRM(390,___G___kernel_23_46)
#define ___GLO___kernel_23_47 ___GLO(391,___G___kernel_23_47)
#define ___PRM___kernel_23_47 ___PRM(391,___G___kernel_23_47)
#define ___GLO___kernel_23_48 ___GLO(392,___G___kernel_23_48)
#define ___PRM___kernel_23_48 ___PRM(392,___G___kernel_23_48)
#define ___GLO___kernel_23_49 ___GLO(393,___G___kernel_23_49)
#define ___PRM___kernel_23_49 ___PRM(393,___G___kernel_23_49)
#define ___GLO___kernel_23_5 ___GLO(394,___G___kernel_23_5)
#define ___PRM___kernel_23_5 ___PRM(394,___G___kernel_23_5)
#define ___GLO___kernel_23_50 ___GLO(395,___G___kernel_23_50)
#define ___PRM___kernel_23_50 ___PRM(395,___G___kernel_23_50)
#define ___GLO___kernel_23_51 ___GLO(396,___G___kernel_23_51)
#define ___PRM___kernel_23_51 ___PRM(396,___G___kernel_23_51)
#define ___GLO___kernel_23_52 ___GLO(397,___G___kernel_23_52)
#define ___PRM___kernel_23_52 ___PRM(397,___G___kernel_23_52)
#define ___GLO___kernel_23_53 ___GLO(398,___G___kernel_23_53)
#define ___PRM___kernel_23_53 ___PRM(398,___G___kernel_23_53)
#define ___GLO___kernel_23_54 ___GLO(399,___G___kernel_23_54)
#define ___PRM___kernel_23_54 ___PRM(399,___G___kernel_23_54)
#define ___GLO___kernel_23_55 ___GLO(400,___G___kernel_23_55)
#define ___PRM___kernel_23_55 ___PRM(400,___G___kernel_23_55)
#define ___GLO___kernel_23_56 ___GLO(401,___G___kernel_23_56)
#define ___PRM___kernel_23_56 ___PRM(401,___G___kernel_23_56)
#define ___GLO___kernel_23_57 ___GLO(402,___G___kernel_23_57)
#define ___PRM___kernel_23_57 ___PRM(402,___G___kernel_23_57)
#define ___GLO___kernel_23_58 ___GLO(403,___G___kernel_23_58)
#define ___PRM___kernel_23_58 ___PRM(403,___G___kernel_23_58)
#define ___GLO___kernel_23_59 ___GLO(404,___G___kernel_23_59)
#define ___PRM___kernel_23_59 ___PRM(404,___G___kernel_23_59)
#define ___GLO___kernel_23_6 ___GLO(405,___G___kernel_23_6)
#define ___PRM___kernel_23_6 ___PRM(405,___G___kernel_23_6)
#define ___GLO___kernel_23_60 ___GLO(406,___G___kernel_23_60)
#define ___PRM___kernel_23_60 ___PRM(406,___G___kernel_23_60)
#define ___GLO___kernel_23_61 ___GLO(407,___G___kernel_23_61)
#define ___PRM___kernel_23_61 ___PRM(407,___G___kernel_23_61)
#define ___GLO___kernel_23_62 ___GLO(408,___G___kernel_23_62)
#define ___PRM___kernel_23_62 ___PRM(408,___G___kernel_23_62)
#define ___GLO___kernel_23_63 ___GLO(409,___G___kernel_23_63)
#define ___PRM___kernel_23_63 ___PRM(409,___G___kernel_23_63)
#define ___GLO___kernel_23_64 ___GLO(410,___G___kernel_23_64)
#define ___PRM___kernel_23_64 ___PRM(410,___G___kernel_23_64)
#define ___GLO___kernel_23_65 ___GLO(411,___G___kernel_23_65)
#define ___PRM___kernel_23_65 ___PRM(411,___G___kernel_23_65)
#define ___GLO___kernel_23_66 ___GLO(412,___G___kernel_23_66)
#define ___PRM___kernel_23_66 ___PRM(412,___G___kernel_23_66)
#define ___GLO___kernel_23_67 ___GLO(413,___G___kernel_23_67)
#define ___PRM___kernel_23_67 ___PRM(413,___G___kernel_23_67)
#define ___GLO___kernel_23_68 ___GLO(414,___G___kernel_23_68)
#define ___PRM___kernel_23_68 ___PRM(414,___G___kernel_23_68)
#define ___GLO___kernel_23_69 ___GLO(415,___G___kernel_23_69)
#define ___PRM___kernel_23_69 ___PRM(415,___G___kernel_23_69)
#define ___GLO___kernel_23_7 ___GLO(416,___G___kernel_23_7)
#define ___PRM___kernel_23_7 ___PRM(416,___G___kernel_23_7)
#define ___GLO___kernel_23_70 ___GLO(417,___G___kernel_23_70)
#define ___PRM___kernel_23_70 ___PRM(417,___G___kernel_23_70)
#define ___GLO___kernel_23_71 ___GLO(418,___G___kernel_23_71)
#define ___PRM___kernel_23_71 ___PRM(418,___G___kernel_23_71)
#define ___GLO___kernel_23_72 ___GLO(419,___G___kernel_23_72)
#define ___PRM___kernel_23_72 ___PRM(419,___G___kernel_23_72)
#define ___GLO___kernel_23_73 ___GLO(420,___G___kernel_23_73)
#define ___PRM___kernel_23_73 ___PRM(420,___G___kernel_23_73)
#define ___GLO___kernel_23_74 ___GLO(421,___G___kernel_23_74)
#define ___PRM___kernel_23_74 ___PRM(421,___G___kernel_23_74)
#define ___GLO___kernel_23_75 ___GLO(422,___G___kernel_23_75)
#define ___PRM___kernel_23_75 ___PRM(422,___G___kernel_23_75)
#define ___GLO___kernel_23_76 ___GLO(423,___G___kernel_23_76)
#define ___PRM___kernel_23_76 ___PRM(423,___G___kernel_23_76)
#define ___GLO___kernel_23_77 ___GLO(424,___G___kernel_23_77)
#define ___PRM___kernel_23_77 ___PRM(424,___G___kernel_23_77)
#define ___GLO___kernel_23_78 ___GLO(425,___G___kernel_23_78)
#define ___PRM___kernel_23_78 ___PRM(425,___G___kernel_23_78)
#define ___GLO___kernel_23_79 ___GLO(426,___G___kernel_23_79)
#define ___PRM___kernel_23_79 ___PRM(426,___G___kernel_23_79)
#define ___GLO___kernel_23_8 ___GLO(427,___G___kernel_23_8)
#define ___PRM___kernel_23_8 ___PRM(427,___G___kernel_23_8)
#define ___GLO___kernel_23_80 ___GLO(428,___G___kernel_23_80)
#define ___PRM___kernel_23_80 ___PRM(428,___G___kernel_23_80)
#define ___GLO___kernel_23_81 ___GLO(429,___G___kernel_23_81)
#define ___PRM___kernel_23_81 ___PRM(429,___G___kernel_23_81)
#define ___GLO___kernel_23_82 ___GLO(430,___G___kernel_23_82)
#define ___PRM___kernel_23_82 ___PRM(430,___G___kernel_23_82)
#define ___GLO___kernel_23_83 ___GLO(431,___G___kernel_23_83)
#define ___PRM___kernel_23_83 ___PRM(431,___G___kernel_23_83)
#define ___GLO___kernel_23_84 ___GLO(432,___G___kernel_23_84)
#define ___PRM___kernel_23_84 ___PRM(432,___G___kernel_23_84)
#define ___GLO___kernel_23_85 ___GLO(433,___G___kernel_23_85)
#define ___PRM___kernel_23_85 ___PRM(433,___G___kernel_23_85)
#define ___GLO___kernel_23_86 ___GLO(434,___G___kernel_23_86)
#define ___PRM___kernel_23_86 ___PRM(434,___G___kernel_23_86)
#define ___GLO___kernel_23_87 ___GLO(435,___G___kernel_23_87)
#define ___PRM___kernel_23_87 ___PRM(435,___G___kernel_23_87)
#define ___GLO___kernel_23_88 ___GLO(436,___G___kernel_23_88)
#define ___PRM___kernel_23_88 ___PRM(436,___G___kernel_23_88)
#define ___GLO___kernel_23_89 ___GLO(437,___G___kernel_23_89)
#define ___PRM___kernel_23_89 ___PRM(437,___G___kernel_23_89)
#define ___GLO___kernel_23_9 ___GLO(438,___G___kernel_23_9)
#define ___PRM___kernel_23_9 ___PRM(438,___G___kernel_23_9)
#define ___GLO___kernel_23_90 ___GLO(439,___G___kernel_23_90)
#define ___PRM___kernel_23_90 ___PRM(439,___G___kernel_23_90)
#define ___GLO___kernel_23_91 ___GLO(440,___G___kernel_23_91)
#define ___PRM___kernel_23_91 ___PRM(440,___G___kernel_23_91)
#define ___GLO___kernel_23_92 ___GLO(441,___G___kernel_23_92)
#define ___PRM___kernel_23_92 ___PRM(441,___G___kernel_23_92)
#define ___GLO_cfun_2d_conversion_2d_exception_2d_arguments ___GLO(442,___G_cfun_2d_conversion_2d_exception_2d_arguments)
#define ___PRM_cfun_2d_conversion_2d_exception_2d_arguments ___PRM(442,___G_cfun_2d_conversion_2d_exception_2d_arguments)
#define ___GLO_cfun_2d_conversion_2d_exception_2d_code ___GLO(443,___G_cfun_2d_conversion_2d_exception_2d_code)
#define ___PRM_cfun_2d_conversion_2d_exception_2d_code ___PRM(443,___G_cfun_2d_conversion_2d_exception_2d_code)
#define ___GLO_cfun_2d_conversion_2d_exception_2d_message ___GLO(444,___G_cfun_2d_conversion_2d_exception_2d_message)
#define ___PRM_cfun_2d_conversion_2d_exception_2d_message ___PRM(444,___G_cfun_2d_conversion_2d_exception_2d_message)
#define ___GLO_cfun_2d_conversion_2d_exception_2d_procedure ___GLO(445,___G_cfun_2d_conversion_2d_exception_2d_procedure)
#define ___PRM_cfun_2d_conversion_2d_exception_2d_procedure ___PRM(445,___G_cfun_2d_conversion_2d_exception_2d_procedure)
#define ___GLO_cfun_2d_conversion_2d_exception_3f_ ___GLO(446,___G_cfun_2d_conversion_2d_exception_3f_)
#define ___PRM_cfun_2d_conversion_2d_exception_3f_ ___PRM(446,___G_cfun_2d_conversion_2d_exception_3f_)
#define ___GLO_configure_2d_command_2d_string ___GLO(447,___G_configure_2d_command_2d_string)
#define ___PRM_configure_2d_command_2d_string ___PRM(447,___G_configure_2d_command_2d_string)
#define ___GLO_err_2d_code_2d__3e_string ___GLO(448,___G_err_2d_code_2d__3e_string)
#define ___PRM_err_2d_code_2d__3e_string ___PRM(448,___G_err_2d_code_2d__3e_string)
#define ___GLO_foreign_2d_address ___GLO(449,___G_foreign_2d_address)
#define ___PRM_foreign_2d_address ___PRM(449,___G_foreign_2d_address)
#define ___GLO_foreign_2d_release_21_ ___GLO(450,___G_foreign_2d_release_21_)
#define ___PRM_foreign_2d_release_21_ ___PRM(450,___G_foreign_2d_release_21_)
#define ___GLO_foreign_2d_released_3f_ ___GLO(451,___G_foreign_2d_released_3f_)
#define ___PRM_foreign_2d_released_3f_ ___PRM(451,___G_foreign_2d_released_3f_)
#define ___GLO_foreign_2d_tags ___GLO(452,___G_foreign_2d_tags)
#define ___PRM_foreign_2d_tags ___PRM(452,___G_foreign_2d_tags)
#define ___GLO_foreign_3f_ ___GLO(453,___G_foreign_3f_)
#define ___PRM_foreign_3f_ ___PRM(453,___G_foreign_3f_)
#define ___GLO_heap_2d_overflow_2d_exception_3f_ ___GLO(454,___G_heap_2d_overflow_2d_exception_3f_)
#define ___PRM_heap_2d_overflow_2d_exception_3f_ ___PRM(454,___G_heap_2d_overflow_2d_exception_3f_)
#define ___GLO_keyword_2d_expected_2d_exception_2d_arguments ___GLO(455,___G_keyword_2d_expected_2d_exception_2d_arguments)
#define ___PRM_keyword_2d_expected_2d_exception_2d_arguments ___PRM(455,___G_keyword_2d_expected_2d_exception_2d_arguments)
#define ___GLO_keyword_2d_expected_2d_exception_2d_procedure ___GLO(456,___G_keyword_2d_expected_2d_exception_2d_procedure)
#define ___PRM_keyword_2d_expected_2d_exception_2d_procedure ___PRM(456,___G_keyword_2d_expected_2d_exception_2d_procedure)
#define ___GLO_keyword_2d_expected_2d_exception_3f_ ___GLO(457,___G_keyword_2d_expected_2d_exception_3f_)
#define ___PRM_keyword_2d_expected_2d_exception_3f_ ___PRM(457,___G_keyword_2d_expected_2d_exception_3f_)
#define ___GLO_module_2d_not_2d_found_2d_exception_2d_arguments ___GLO(458,___G_module_2d_not_2d_found_2d_exception_2d_arguments)
#define ___PRM_module_2d_not_2d_found_2d_exception_2d_arguments ___PRM(458,___G_module_2d_not_2d_found_2d_exception_2d_arguments)
#define ___GLO_module_2d_not_2d_found_2d_exception_2d_procedure ___GLO(459,___G_module_2d_not_2d_found_2d_exception_2d_procedure)
#define ___PRM_module_2d_not_2d_found_2d_exception_2d_procedure ___PRM(459,___G_module_2d_not_2d_found_2d_exception_2d_procedure)
#define ___GLO_module_2d_not_2d_found_2d_exception_3f_ ___GLO(460,___G_module_2d_not_2d_found_2d_exception_3f_)
#define ___PRM_module_2d_not_2d_found_2d_exception_3f_ ___PRM(460,___G_module_2d_not_2d_found_2d_exception_3f_)
#define ___GLO_multiple_2d_c_2d_return_2d_exception_3f_ ___GLO(461,___G_multiple_2d_c_2d_return_2d_exception_3f_)
#define ___PRM_multiple_2d_c_2d_return_2d_exception_3f_ ___PRM(461,___G_multiple_2d_c_2d_return_2d_exception_3f_)
#define ___GLO_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments ___GLO(462,___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
#define ___PRM_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments ___PRM(462,___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
#define ___GLO_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure ___GLO(463,___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
#define ___PRM_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure ___PRM(463,___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
#define ___GLO_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_ ___GLO(464,___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_)
#define ___PRM_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_ ___PRM(464,___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_)
#define ___GLO_nonprocedure_2d_operator_2d_exception_2d_arguments ___GLO(465,___G_nonprocedure_2d_operator_2d_exception_2d_arguments)
#define ___PRM_nonprocedure_2d_operator_2d_exception_2d_arguments ___PRM(465,___G_nonprocedure_2d_operator_2d_exception_2d_arguments)
#define ___GLO_nonprocedure_2d_operator_2d_exception_2d_code ___GLO(466,___G_nonprocedure_2d_operator_2d_exception_2d_code)
#define ___PRM_nonprocedure_2d_operator_2d_exception_2d_code ___PRM(466,___G_nonprocedure_2d_operator_2d_exception_2d_code)
#define ___GLO_nonprocedure_2d_operator_2d_exception_2d_operator ___GLO(467,___G_nonprocedure_2d_operator_2d_exception_2d_operator)
#define ___PRM_nonprocedure_2d_operator_2d_exception_2d_operator ___PRM(467,___G_nonprocedure_2d_operator_2d_exception_2d_operator)
#define ___GLO_nonprocedure_2d_operator_2d_exception_2d_rte ___GLO(468,___G_nonprocedure_2d_operator_2d_exception_2d_rte)
#define ___PRM_nonprocedure_2d_operator_2d_exception_2d_rte ___PRM(468,___G_nonprocedure_2d_operator_2d_exception_2d_rte)
#define ___GLO_nonprocedure_2d_operator_2d_exception_3f_ ___GLO(469,___G_nonprocedure_2d_operator_2d_exception_3f_)
#define ___PRM_nonprocedure_2d_operator_2d_exception_3f_ ___PRM(469,___G_nonprocedure_2d_operator_2d_exception_3f_)
#define ___GLO_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments ___GLO(470,___G_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
#define ___PRM_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments ___PRM(470,___G_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
#define ___GLO_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure ___GLO(471,___G_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
#define ___PRM_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure ___PRM(471,___G_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
#define ___GLO_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_ ___GLO(472,___G_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_)
#define ___PRM_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_ ___PRM(472,___G_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_)
#define ___GLO_os_2d_exception_2d_arguments ___GLO(473,___G_os_2d_exception_2d_arguments)
#define ___PRM_os_2d_exception_2d_arguments ___PRM(473,___G_os_2d_exception_2d_arguments)
#define ___GLO_os_2d_exception_2d_code ___GLO(474,___G_os_2d_exception_2d_code)
#define ___PRM_os_2d_exception_2d_code ___PRM(474,___G_os_2d_exception_2d_code)
#define ___GLO_os_2d_exception_2d_message ___GLO(475,___G_os_2d_exception_2d_message)
#define ___PRM_os_2d_exception_2d_message ___PRM(475,___G_os_2d_exception_2d_message)
#define ___GLO_os_2d_exception_2d_procedure ___GLO(476,___G_os_2d_exception_2d_procedure)
#define ___PRM_os_2d_exception_2d_procedure ___PRM(476,___G_os_2d_exception_2d_procedure)
#define ___GLO_os_2d_exception_3f_ ___GLO(477,___G_os_2d_exception_3f_)
#define ___PRM_os_2d_exception_3f_ ___PRM(477,___G_os_2d_exception_3f_)
#define ___GLO_sfun_2d_conversion_2d_exception_2d_arguments ___GLO(478,___G_sfun_2d_conversion_2d_exception_2d_arguments)
#define ___PRM_sfun_2d_conversion_2d_exception_2d_arguments ___PRM(478,___G_sfun_2d_conversion_2d_exception_2d_arguments)
#define ___GLO_sfun_2d_conversion_2d_exception_2d_code ___GLO(479,___G_sfun_2d_conversion_2d_exception_2d_code)
#define ___PRM_sfun_2d_conversion_2d_exception_2d_code ___PRM(479,___G_sfun_2d_conversion_2d_exception_2d_code)
#define ___GLO_sfun_2d_conversion_2d_exception_2d_message ___GLO(480,___G_sfun_2d_conversion_2d_exception_2d_message)
#define ___PRM_sfun_2d_conversion_2d_exception_2d_message ___PRM(480,___G_sfun_2d_conversion_2d_exception_2d_message)
#define ___GLO_sfun_2d_conversion_2d_exception_2d_procedure ___GLO(481,___G_sfun_2d_conversion_2d_exception_2d_procedure)
#define ___PRM_sfun_2d_conversion_2d_exception_2d_procedure ___PRM(481,___G_sfun_2d_conversion_2d_exception_2d_procedure)
#define ___GLO_sfun_2d_conversion_2d_exception_3f_ ___GLO(482,___G_sfun_2d_conversion_2d_exception_3f_)
#define ___PRM_sfun_2d_conversion_2d_exception_3f_ ___PRM(482,___G_sfun_2d_conversion_2d_exception_3f_)
#define ___GLO_stack_2d_overflow_2d_exception_3f_ ___GLO(483,___G_stack_2d_overflow_2d_exception_3f_)
#define ___PRM_stack_2d_overflow_2d_exception_3f_ ___PRM(483,___G_stack_2d_overflow_2d_exception_3f_)
#define ___GLO_system_2d_stamp ___GLO(484,___G_system_2d_stamp)
#define ___PRM_system_2d_stamp ___PRM(484,___G_system_2d_stamp)
#define ___GLO_system_2d_type ___GLO(485,___G_system_2d_type)
#define ___PRM_system_2d_type ___PRM(485,___G_system_2d_type)
#define ___GLO_system_2d_type_2d_string ___GLO(486,___G_system_2d_type_2d_string)
#define ___PRM_system_2d_type_2d_string ___PRM(486,___G_system_2d_type_2d_string)
#define ___GLO_system_2d_version ___GLO(487,___G_system_2d_version)
#define ___PRM_system_2d_version ___PRM(487,___G_system_2d_version)
#define ___GLO_system_2d_version_2d_string ___GLO(488,___G_system_2d_version_2d_string)
#define ___PRM_system_2d_version_2d_string ___PRM(488,___G_system_2d_version_2d_string)
#define ___GLO_type_2d_exception_2d_arg_2d_num ___GLO(489,___G_type_2d_exception_2d_arg_2d_num)
#define ___PRM_type_2d_exception_2d_arg_2d_num ___PRM(489,___G_type_2d_exception_2d_arg_2d_num)
#define ___GLO_type_2d_exception_2d_arguments ___GLO(490,___G_type_2d_exception_2d_arguments)
#define ___PRM_type_2d_exception_2d_arguments ___PRM(490,___G_type_2d_exception_2d_arguments)
#define ___GLO_type_2d_exception_2d_procedure ___GLO(491,___G_type_2d_exception_2d_procedure)
#define ___PRM_type_2d_exception_2d_procedure ___PRM(491,___G_type_2d_exception_2d_procedure)
#define ___GLO_type_2d_exception_2d_type_2d_id ___GLO(492,___G_type_2d_exception_2d_type_2d_id)
#define ___PRM_type_2d_exception_2d_type_2d_id ___PRM(492,___G_type_2d_exception_2d_type_2d_id)
#define ___GLO_type_2d_exception_3f_ ___GLO(493,___G_type_2d_exception_3f_)
#define ___PRM_type_2d_exception_3f_ ___PRM(493,___G_type_2d_exception_3f_)
#define ___GLO_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments ___GLO(494,___G_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
#define ___PRM_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments ___PRM(494,___G_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
#define ___GLO_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure ___GLO(495,___G_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
#define ___PRM_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure ___PRM(495,___G_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
#define ___GLO_unknown_2d_keyword_2d_argument_2d_exception_3f_ ___GLO(496,___G_unknown_2d_keyword_2d_argument_2d_exception_3f_)
#define ___PRM_unknown_2d_keyword_2d_argument_2d_exception_3f_ ___PRM(496,___G_unknown_2d_keyword_2d_argument_2d_exception_3f_)
#define ___GLO_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments ___GLO(497,___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
#define ___PRM_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments ___PRM(497,___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
#define ___GLO_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure ___GLO(498,___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
#define ___PRM_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure ___PRM(498,___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
#define ___GLO_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_ ___GLO(499,___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_)
#define ___PRM_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_ ___PRM(499,___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_)
#define ___GLO_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_ ___GLO(500,___G_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_)
#define ___PRM_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_ ___PRM(500,___G_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_)

___BEGIN_CNS
 ___DEF_CNS(___REF_SYM(82,___S_void_2a_),___REF_NUL)
___END_CNS

___DEF_SUB_STRUCTURE(___X0,6UL)
               ___VEC1(___REF_SUB(0))
               ___VEC1(___REF_SYM(17,___S__23__23_type_2d_5))
               ___VEC1(___REF_SYM(78,___S_type))
               ___VEC1(___REF_FIX(8))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(1))
               ___VEC0
___DEF_SUB_VEC(___X1,15UL)
               ___VEC1(___REF_SYM(43,___S_id))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(53,___S_name))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(39,___S_flags))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(68,___S_super))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(38,___S_fields))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X2,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(11,___S__23__23_type_2d_33_2d_d05e0aa7_2d_e235_2d_441d_2d_aa41_2d_c1ac02065460))
               ___VEC1(___REF_SYM(70,___S_thread))
               ___VEC1(___REF_FIX(31))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(5))
               ___VEC0
___DEF_SUB_STRUCTURE(___X3,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(17,___S__23__23_type_2d_5))
               ___VEC1(___REF_SYM(78,___S_type))
               ___VEC1(___REF_FIX(8))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(4))
               ___VEC0
___DEF_SUB_VEC(___X4,15UL)
               ___VEC1(___REF_SYM(43,___S_id))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(53,___S_name))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(39,___S_flags))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(68,___S_super))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(38,___S_fields))
               ___VEC1(___REF_FIX(5))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X5,99UL)
               ___VEC1(___REF_SYM(47,___S_lock1))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FIX(0))
               ___VEC1(___REF_SYM(23,___S_btq_2d_deq_2d_next))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(24,___S_btq_2d_deq_2d_prev))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(21,___S_btq_2d_color))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(27,___S_btq_2d_parent))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(25,___S_btq_2d_left))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(26,___S_btq_2d_leftmost))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(69,___S_tgroup))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(48,___S_lock2))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FIX(0))
               ___VEC1(___REF_SYM(73,___S_toq_2d_color))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(77,___S_toq_2d_parent))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(75,___S_toq_2d_left))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(76,___S_toq_2d_leftmost))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(71,___S_threads_2d_deq_2d_next))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(72,___S_threads_2d_deq_2d_prev))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(40,___S_floats))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(22,___S_btq_2d_container))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(74,___S_toq_2d_container))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(53,___S_name))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(35,___S_end_2d_condvar))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(37,___S_exception_3f_))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_SYM(56,___S_not_2d_started))
               ___VEC1(___REF_SYM(62,___S_result))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(30,___S_cont))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(31,___S_denv))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(32,___S_denv_2d_cache1))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(33,___S_denv_2d_cache2))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(34,___S_denv_2d_cache3))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(61,___S_repl_2d_channel))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(49,___S_mailbox))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(66,___S_specific))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_VOID)
               ___VEC1(___REF_SYM(63,___S_resume_2d_thunk))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(44,___S_interrupts))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_NUL)
               ___VEC1(___REF_SYM(46,___S_last_2d_processor))
               ___VEC1(___REF_FIX(9))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X6,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(15,___S__23__23_type_2d_4_2d_cf06eccd_2d_bf2c_2d_4b30_2d_a6ce_2d_394b345a0dee))
               ___VEC1(___REF_SYM(79,___S_type_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(9))
               ___VEC0
___DEF_SUB_STRUCTURE(___X7,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(0,___S__23__23_type_2d_0_2d_0bf9b656_2d_b071_2d_404a_2d_a514_2d_0fb9d05cf518))
               ___VEC1(___REF_SYM(36,___S_exception))
               ___VEC1(___REF_FIX(31))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SUB(8))
               ___VEC0
___DEF_SUB_VEC(___X8,0UL)
               ___VEC0
___DEF_SUB_VEC(___X9,12UL)
               ___VEC1(___REF_SYM(60,___S_procedure))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(20,___S_arguments))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(19,___S_arg_2d_num))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(80,___S_type_2d_id))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X10,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(3,___S__23__23_type_2d_0_2d_d69cd396_2d_01e0_2d_4dcb_2d_87dc_2d_31acea8e0e5f))
               ___VEC1(___REF_SYM(42,___S_heap_2d_overflow_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(11))
               ___VEC0
___DEF_SUB_VEC(___X11,0UL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X12,1UL)
               ___VEC1(___REF_SUB(10))
               ___VEC0
___DEF_SUB_STRUCTURE(___X13,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(4,___S__23__23_type_2d_0_2d_f512c9f6_2d_3b24_2d_4c5c_2d_8c8b_2d_cabd75b2f951))
               ___VEC1(___REF_SYM(67,___S_stack_2d_overflow_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(14))
               ___VEC0
___DEF_SUB_VEC(___X14,0UL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X15,1UL)
               ___VEC1(___REF_SUB(13))
               ___VEC0
___DEF_SUB_STRUCTURE(___X16,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(16,___S__23__23_type_2d_4_2d_f39d07ce_2d_436d_2d_40ca_2d_b81f_2d_cdc65d16b7f2))
               ___VEC1(___REF_SYM(55,___S_nonprocedure_2d_operator_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(17))
               ___VEC0
___DEF_SUB_VEC(___X17,12UL)
               ___VEC1(___REF_SYM(58,___S_operator))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(20,___S_arguments))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(29,___S_code))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(64,___S_rte))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X18,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(5,___S__23__23_type_2d_2_2d_2138cd7f_2d_8c42_2d_4164_2d_b56a_2d_a8c7badf3323))
               ___VEC1(___REF_SYM(83,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(19))
               ___VEC0
___DEF_SUB_VEC(___X19,6UL)
               ___VEC1(___REF_SYM(60,___S_procedure))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(20,___S_arguments))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X20,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(8,___S__23__23_type_2d_2_2d_3fd6c57f_2d_3c80_2d_4436_2d_a430_2d_57ea4457c11e))
               ___VEC1(___REF_SYM(45,___S_keyword_2d_expected_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(21))
               ___VEC0
___DEF_SUB_VEC(___X21,6UL)
               ___VEC1(___REF_SYM(60,___S_procedure))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(20,___S_arguments))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X22,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(7,___S__23__23_type_2d_2_2d_3f9f8aaa_2d_ea21_2d_4f2b_2d_bc06_2d_f65950e6c408))
               ___VEC1(___REF_SYM(81,___S_unknown_2d_keyword_2d_argument_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(23))
               ___VEC0
___DEF_SUB_VEC(___X23,6UL)
               ___VEC1(___REF_SYM(60,___S_procedure))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(20,___S_arguments))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X24,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(14,___S__23__23_type_2d_4_2d_c1fc166b_2d_d951_2d_4871_2d_853c_2d_2b6c8c12d28d))
               ___VEC1(___REF_SYM(59,___S_os_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(25))
               ___VEC0
___DEF_SUB_VEC(___X25,12UL)
               ___VEC1(___REF_SYM(60,___S_procedure))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(20,___S_arguments))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(50,___S_message))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(29,___S_code))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X26,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(6,___S__23__23_type_2d_2_2d_299ccee1_2d_77d2_2d_4a6d_2d_ab24_2d_2ebf14297315))
               ___VEC1(___REF_SYM(54,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(27))
               ___VEC0
___DEF_SUB_VEC(___X27,6UL)
               ___VEC1(___REF_SYM(60,___S_procedure))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(20,___S_arguments))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X28,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(13,___S__23__23_type_2d_4_2d_9f09b552_2d_0fb7_2d_42c5_2d_b0d4_2d_212155841d53))
               ___VEC1(___REF_SYM(28,___S_cfun_2d_conversion_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(29))
               ___VEC0
___DEF_SUB_VEC(___X29,12UL)
               ___VEC1(___REF_SYM(60,___S_procedure))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(20,___S_arguments))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(29,___S_code))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(50,___S_message))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X30,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(12,___S__23__23_type_2d_4_2d_54dfbc02_2d_718d_2d_4a34_2d_91ab_2d_d1861da7500a))
               ___VEC1(___REF_SYM(65,___S_sfun_2d_conversion_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(31))
               ___VEC0
___DEF_SUB_VEC(___X31,12UL)
               ___VEC1(___REF_SYM(60,___S_procedure))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(20,___S_arguments))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(29,___S_code))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(50,___S_message))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X32,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(1,___S__23__23_type_2d_0_2d_73c66686_2d_a08f_2d_4c7c_2d_a0f1_2d_5ad7771f242a))
               ___VEC1(___REF_SYM(52,___S_multiple_2d_c_2d_return_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(33))
               ___VEC0
___DEF_SUB_VEC(___X33,0UL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X34,1UL)
               ___VEC1(___REF_SUB(32))
               ___VEC0
___DEF_SUB_STRUCTURE(___X35,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(2,___S__23__23_type_2d_0_2d_828142df_2d_e9a5_2d_4ed8_2d_a467_2d_2f4833525b3e))
               ___VEC1(___REF_SYM(84,___S_wrong_2d_processor_2d_c_2d_return_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(36))
               ___VEC0
___DEF_SUB_VEC(___X36,0UL)
               ___VEC0
___DEF_SUB_STRUCTURE(___X37,1UL)
               ___VEC1(___REF_SUB(35))
               ___VEC0
___DEF_SUB_STRUCTURE(___X38,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(10,___S__23__23_type_2d_2_2d_f9519b37_2d_d6d4_2d_4748_2d_8eb1_2d_a0c8dc18c5e7))
               ___VEC1(___REF_SYM(57,___S_number_2d_of_2d_arguments_2d_limit_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(39))
               ___VEC0
___DEF_SUB_VEC(___X39,6UL)
               ___VEC1(___REF_SYM(60,___S_procedure))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(20,___S_arguments))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_STR(___X40,6UL)
               ___STR6(118,52,46,56,46,57)
___DEF_SUB_STRUCTURE(___X41,6UL)
               ___VEC1(___REF_SUB(3))
               ___VEC1(___REF_SYM(9,___S__23__23_type_2d_2_2d_CA9CA020_2d_600A_2d_4516_2d_AA78_2d_CBE91EC8BE14))
               ___VEC1(___REF_SYM(51,___S_module_2d_not_2d_found_2d_exception))
               ___VEC1(___REF_FIX(29))
               ___VEC1(___REF_SUB(7))
               ___VEC1(___REF_SUB(42))
               ___VEC0
___DEF_SUB_VEC(___X42,6UL)
               ___VEC1(___REF_SYM(60,___S_procedure))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC1(___REF_SYM(20,___S_arguments))
               ___VEC1(___REF_FIX(3))
               ___VEC1(___REF_FAL)
               ___VEC0
___DEF_SUB_VEC(___X43,5UL)
               ___VEC1(___REF_SYM(18,___S___kernel))
               ___VEC1(___REF_PRC(1))
               ___VEC1(___REF_FIX(1))
               ___VEC1(___REF_NUL)
               ___VEC1(___REF_FAL)
               ___VEC0

___BEGIN_SUB
 ___DEF_SUB(___X0)
,___DEF_SUB(___X1)
,___DEF_SUB(___X2)
,___DEF_SUB(___X3)
,___DEF_SUB(___X4)
,___DEF_SUB(___X5)
,___DEF_SUB(___X6)
,___DEF_SUB(___X7)
,___DEF_SUB(___X8)
,___DEF_SUB(___X9)
,___DEF_SUB(___X10)
,___DEF_SUB(___X11)
,___DEF_SUB(___X12)
,___DEF_SUB(___X13)
,___DEF_SUB(___X14)
,___DEF_SUB(___X15)
,___DEF_SUB(___X16)
,___DEF_SUB(___X17)
,___DEF_SUB(___X18)
,___DEF_SUB(___X19)
,___DEF_SUB(___X20)
,___DEF_SUB(___X21)
,___DEF_SUB(___X22)
,___DEF_SUB(___X23)
,___DEF_SUB(___X24)
,___DEF_SUB(___X25)
,___DEF_SUB(___X26)
,___DEF_SUB(___X27)
,___DEF_SUB(___X28)
,___DEF_SUB(___X29)
,___DEF_SUB(___X30)
,___DEF_SUB(___X31)
,___DEF_SUB(___X32)
,___DEF_SUB(___X33)
,___DEF_SUB(___X34)
,___DEF_SUB(___X35)
,___DEF_SUB(___X36)
,___DEF_SUB(___X37)
,___DEF_SUB(___X38)
,___DEF_SUB(___X39)
,___DEF_SUB(___X40)
,___DEF_SUB(___X41)
,___DEF_SUB(___X42)
,___DEF_SUB(___X43)
___END_SUB



#define ___C_OBJ_0 ___CNS(0)


#include "os.h"
#include "os_setup.h"
#include "os_base.h"
#include "os_time.h"
#include "os_shell.h"
#include "os_files.h"
#include "os_dyn.h"
#include "os_tty.h"
#include "os_io.h"
#include "setup.h"
#include "mem.h"
#include "c_intf.h"

#include "stamp.h"


#undef ___MD_ALL
#define ___MD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___MR_ALL
#define ___MR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___MW_ALL
#define ___MW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_M_COD
___BEGIN_M_HLBL
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_)
___DEF_M_HLBL(___L1___kernel_23_)
___DEF_M_HLBL(___L2___kernel_23_)
___DEF_M_HLBL(___L3___kernel_23_)
___DEF_M_HLBL(___L4___kernel_23_)
___DEF_M_HLBL(___L5___kernel_23_)
___DEF_M_HLBL(___L6___kernel_23_)
___DEF_M_HLBL(___L7___kernel_23_)
___DEF_M_HLBL(___L8___kernel_23_)
___DEF_M_HLBL(___L9___kernel_23_)
___DEF_M_HLBL(___L10___kernel_23_)
___DEF_M_HLBL(___L11___kernel_23_)
___DEF_M_HLBL(___L12___kernel_23_)
___DEF_M_HLBL(___L13___kernel_23_)
___DEF_M_HLBL(___L14___kernel_23_)
___DEF_M_HLBL(___L15___kernel_23_)
___DEF_M_HLBL(___L16___kernel_23_)
___DEF_M_HLBL(___L17___kernel_23_)
___DEF_M_HLBL(___L18___kernel_23_)
___DEF_M_HLBL(___L19___kernel_23_)
___DEF_M_HLBL(___L20___kernel_23_)
___DEF_M_HLBL(___L21___kernel_23_)
___DEF_M_HLBL(___L22___kernel_23_)
___DEF_M_HLBL(___L23___kernel_23_)
___DEF_M_HLBL(___L24___kernel_23_)
___DEF_M_HLBL(___L25___kernel_23_)
___DEF_M_HLBL(___L26___kernel_23_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L1__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L2__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L3__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L4__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L5__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L6__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L7__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L8__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L9__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L10__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L11__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L12__23__23_kernel_2d_handlers)
___DEF_M_HLBL(___L13__23__23_kernel_2d_handlers)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_dynamic_2d_env_2d_bind)
___DEF_M_HLBL(___L1__23__23_dynamic_2d_env_2d_bind)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_assq_2d_cdr)
___DEF_M_HLBL(___L1__23__23_assq_2d_cdr)
___DEF_M_HLBL(___L2__23__23_assq_2d_cdr)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_assq)
___DEF_M_HLBL(___L1__23__23_assq)
___DEF_M_HLBL(___L2__23__23_assq)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_disable_2d_interrupts_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_enable_2d_interrupts_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_sync_2d_op_2d_interrupt_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_interrupt_2d_handler)
___DEF_M_HLBL(___L1__23__23_interrupt_2d_handler)
___DEF_M_HLBL(___L2__23__23_interrupt_2d_handler)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_interrupt_2d_vector_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_get_2d_heartbeat_2d_interval_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_set_2d_heartbeat_2d_interval_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_high_2d_level_2d_interrupt_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___DEF_M_HLBL(___L1__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___DEF_M_HLBL(___L2__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___DEF_M_HLBL(___L3__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___DEF_M_HLBL(___L1__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___DEF_M_HLBL(___L2__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___DEF_M_HLBL(___L3__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
___DEF_M_HLBL(___L1__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
___DEF_M_HLBL(___L2__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_M_HLBL(___L1__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_M_HLBL(___L2__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_M_HLBL(___L3__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_M_HLBL(___L4__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_M_HLBL(___L5__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_M_HLBL(___L6__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_M_HLBL(___L7__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_M_HLBL(___L8__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_M_HLBL(___L9__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_type_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_type_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_type_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_type_2d_exception_2d_procedure)
___DEF_M_HLBL(___L1_type_2d_exception_2d_procedure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_type_2d_exception_2d_arguments)
___DEF_M_HLBL(___L1_type_2d_exception_2d_arguments)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_type_2d_exception_2d_arg_2d_num)
___DEF_M_HLBL(___L1_type_2d_exception_2d_arg_2d_num)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_type_2d_exception_2d_type_2d_id)
___DEF_M_HLBL(___L1_type_2d_exception_2d_type_2d_id)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_type_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_type_2d_exception)
___DEF_M_HLBL(___L2__23__23_raise_2d_type_2d_exception)
___DEF_M_HLBL(___L3__23__23_raise_2d_type_2d_exception)
___DEF_M_HLBL(___L4__23__23_raise_2d_type_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_heap_2d_overflow_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_M_HLBL(___L2__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_stack_2d_overflow_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_stack_2d_overflow_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_stack_2d_overflow_2d_exception)
___DEF_M_HLBL(___L2__23__23_raise_2d_stack_2d_overflow_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_nonprocedure_2d_operator_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_nonprocedure_2d_operator_2d_exception_2d_operator)
___DEF_M_HLBL(___L1_nonprocedure_2d_operator_2d_exception_2d_operator)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_nonprocedure_2d_operator_2d_exception_2d_arguments)
___DEF_M_HLBL(___L1_nonprocedure_2d_operator_2d_exception_2d_arguments)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_nonprocedure_2d_operator_2d_exception_2d_code)
___DEF_M_HLBL(___L1_nonprocedure_2d_operator_2d_exception_2d_code)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_nonprocedure_2d_operator_2d_exception_2d_rte)
___DEF_M_HLBL(___L1_nonprocedure_2d_operator_2d_exception_2d_rte)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_apply_2d_with_2d_procedure_2d_check)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
___DEF_M_HLBL(___L2__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
___DEF_M_HLBL(___L1_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
___DEF_M_HLBL(___L1_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___DEF_M_HLBL(___L2__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_keyword_2d_expected_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_keyword_2d_expected_2d_exception_2d_procedure)
___DEF_M_HLBL(___L1_keyword_2d_expected_2d_exception_2d_procedure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_keyword_2d_expected_2d_exception_2d_arguments)
___DEF_M_HLBL(___L1_keyword_2d_expected_2d_exception_2d_arguments)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_keyword_2d_expected_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_keyword_2d_expected_2d_exception)
___DEF_M_HLBL(___L2__23__23_raise_2d_keyword_2d_expected_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_unknown_2d_keyword_2d_argument_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
___DEF_M_HLBL(___L1_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
___DEF_M_HLBL(___L1_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
___DEF_M_HLBL(___L2__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_os_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_os_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_os_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_os_2d_exception_2d_procedure)
___DEF_M_HLBL(___L1_os_2d_exception_2d_procedure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_os_2d_exception_2d_arguments)
___DEF_M_HLBL(___L1_os_2d_exception_2d_arguments)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_os_2d_exception_2d_message)
___DEF_M_HLBL(___L1_os_2d_exception_2d_message)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_os_2d_exception_2d_code)
___DEF_M_HLBL(___L1_os_2d_exception_2d_code)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_os_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_os_2d_exception)
___DEF_M_HLBL(___L2__23__23_raise_2d_os_2d_exception)
___DEF_M_HLBL(___L3__23__23_raise_2d_os_2d_exception)
___DEF_M_HLBL(___L4__23__23_raise_2d_os_2d_exception)
___DEF_M_HLBL(___L5__23__23_raise_2d_os_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
___DEF_M_HLBL(___L1_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
___DEF_M_HLBL(___L1_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_M_HLBL(___L2__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_M_HLBL(___L3__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_M_HLBL(___L4__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_cfun_2d_conversion_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_cfun_2d_conversion_2d_exception_2d_procedure)
___DEF_M_HLBL(___L1_cfun_2d_conversion_2d_exception_2d_procedure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_cfun_2d_conversion_2d_exception_2d_arguments)
___DEF_M_HLBL(___L1_cfun_2d_conversion_2d_exception_2d_arguments)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_cfun_2d_conversion_2d_exception_2d_code)
___DEF_M_HLBL(___L1_cfun_2d_conversion_2d_exception_2d_code)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_cfun_2d_conversion_2d_exception_2d_message)
___DEF_M_HLBL(___L1_cfun_2d_conversion_2d_exception_2d_message)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
___DEF_M_HLBL(___L1__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
___DEF_M_HLBL(___L2__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_sfun_2d_conversion_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_sfun_2d_conversion_2d_exception_2d_procedure)
___DEF_M_HLBL(___L1_sfun_2d_conversion_2d_exception_2d_procedure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_sfun_2d_conversion_2d_exception_2d_arguments)
___DEF_M_HLBL(___L1_sfun_2d_conversion_2d_exception_2d_arguments)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_sfun_2d_conversion_2d_exception_2d_code)
___DEF_M_HLBL(___L1_sfun_2d_conversion_2d_exception_2d_code)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_sfun_2d_conversion_2d_exception_2d_message)
___DEF_M_HLBL(___L1_sfun_2d_conversion_2d_exception_2d_message)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_sfun_2d_conversion_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_sfun_2d_conversion_2d_exception)
___DEF_M_HLBL(___L2__23__23_raise_2d_sfun_2d_conversion_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_multiple_2d_c_2d_return_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_c_2d_return_2d_on_2d_other_2d_processor)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
___DEF_M_HLBL(___L1_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
___DEF_M_HLBL(___L1_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___DEF_M_HLBL(___L2__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_promise)
___DEF_M_HLBL(___L1__23__23_make_2d_promise)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_promise_2d_thunk)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_promise_2d_thunk_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_promise_2d_result)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_promise_2d_result_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_force_2d_undetermined)
___DEF_M_HLBL(___L1__23__23_force_2d_undetermined)
___DEF_M_HLBL(___L2__23__23_force_2d_undetermined)
___DEF_M_HLBL(___L3__23__23_force_2d_undetermined)
___DEF_M_HLBL(___L4__23__23_force_2d_undetermined)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_jobs)
___DEF_M_HLBL(___L1__23__23_make_2d_jobs)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_add_2d_job_2d_at_2d_tail_21_)
___DEF_M_HLBL(___L1__23__23_add_2d_job_2d_at_2d_tail_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_add_2d_job_21_)
___DEF_M_HLBL(___L1__23__23_add_2d_job_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_execute_2d_jobs_21_)
___DEF_M_HLBL(___L1__23__23_execute_2d_jobs_21_)
___DEF_M_HLBL(___L2__23__23_execute_2d_jobs_21_)
___DEF_M_HLBL(___L3__23__23_execute_2d_jobs_21_)
___DEF_M_HLBL(___L4__23__23_execute_2d_jobs_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
___DEF_M_HLBL(___L1__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
___DEF_M_HLBL(___L2__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
___DEF_M_HLBL(___L3__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
___DEF_M_HLBL(___L4__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_clear_2d_jobs_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_check_2d_heap_2d_limit)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_check_2d_heap)
___DEF_M_HLBL(___L1__23__23_check_2d_heap)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_rest_2d_param_2d_check_2d_heap)
___DEF_M_HLBL(___L1__23__23_rest_2d_param_2d_check_2d_heap)
___DEF_M_HLBL(___L2__23__23_rest_2d_param_2d_check_2d_heap)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_rest_2d_param_2d_heap_2d_overflow)
___DEF_M_HLBL(___L1__23__23_rest_2d_param_2d_heap_2d_overflow)
___DEF_M_HLBL(___L2__23__23_rest_2d_param_2d_heap_2d_overflow)
___DEF_M_HLBL(___L3__23__23_rest_2d_param_2d_heap_2d_overflow)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_rest_2d_param_2d_resume_2d_procedure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_gc_2d_without_2d_exceptions)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_gc)
___DEF_M_HLBL(___L1__23__23_gc)
___DEF_M_HLBL(___L2__23__23_gc)
___DEF_M_HLBL(___L3__23__23_gc)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_add_2d_gc_2d_interrupt_2d_job_21_)
___DEF_M_HLBL(___L1__23__23_add_2d_gc_2d_interrupt_2d_job_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_)
___DEF_M_HLBL(___L1__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_gc_2d_finalize_21_)
___DEF_M_HLBL(___L1__23__23_gc_2d_finalize_21_)
___DEF_M_HLBL(___L2__23__23_gc_2d_finalize_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_execute_2d_final_2d_wills_21_)
___DEF_M_HLBL(___L1__23__23_execute_2d_final_2d_wills_21_)
___DEF_M_HLBL(___L2__23__23_execute_2d_final_2d_wills_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_gc_2d_final_2d_will_2d_registry_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_final_2d_will)
___DEF_M_HLBL(___L1__23__23_make_2d_final_2d_will)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_handle_2d_gc_2d_interrupt_21_)
___DEF_M_HLBL(___L1__23__23_handle_2d_gc_2d_interrupt_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_get_2d_min_2d_heap)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_set_2d_min_2d_heap_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_get_2d_max_2d_heap)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_set_2d_max_2d_heap_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_get_2d_live_2d_percent)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_set_2d_live_2d_percent_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_get_2d_parallelism_2d_level)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_set_2d_parallelism_2d_level_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_get_2d_standard_2d_level)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_set_2d_standard_2d_level_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_set_2d_gambitdir_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_set_2d_debug_2d_settings_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_cpu_2d_count)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_cpu_2d_cache_2d_size)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_core_2d_count)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_still_2d_copy)
___DEF_M_HLBL(___L1__23__23_still_2d_copy)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_still_2d_obj_2d_refcount_2d_inc_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_still_2d_obj_2d_refcount_2d_dec_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_vector)
___DEF_M_HLBL(___L1__23__23_make_2d_vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_string)
___DEF_M_HLBL(___L1__23__23_make_2d_string)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_s8vector)
___DEF_M_HLBL(___L1__23__23_make_2d_s8vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_u8vector)
___DEF_M_HLBL(___L1__23__23_make_2d_u8vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_s16vector)
___DEF_M_HLBL(___L1__23__23_make_2d_s16vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_u16vector)
___DEF_M_HLBL(___L1__23__23_make_2d_u16vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_s32vector)
___DEF_M_HLBL(___L1__23__23_make_2d_s32vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_u32vector)
___DEF_M_HLBL(___L1__23__23_make_2d_u32vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_s64vector)
___DEF_M_HLBL(___L1__23__23_make_2d_s64vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_u64vector)
___DEF_M_HLBL(___L1__23__23_make_2d_u64vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_f32vector)
___DEF_M_HLBL(___L1__23__23_make_2d_f32vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_f64vector)
___DEF_M_HLBL(___L1__23__23_make_2d_f64vector)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_machine_2d_code_2d_block)
___DEF_M_HLBL(___L1__23__23_make_2d_machine_2d_code_2d_block)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_machine_2d_code_2d_block_2d_ref)
___DEF_M_HLBL(___L1__23__23_machine_2d_code_2d_block_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_machine_2d_code_2d_block_2d_set_21_)
___DEF_M_HLBL(___L1__23__23_machine_2d_code_2d_block_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_machine_2d_code_2d_block_2d_exec)
___DEF_M_HLBL(___L1__23__23_machine_2d_code_2d_block_2d_exec)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_machine_2d_code_2d_block_2d_fixup)
___DEF_M_HLBL(___L1__23__23_machine_2d_code_2d_block_2d_fixup)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_machine_2d_code_2d_fixup)
___DEF_M_HLBL(___L1__23__23_machine_2d_code_2d_fixup)
___DEF_M_HLBL(___L2__23__23_machine_2d_code_2d_fixup)
___DEF_M_HLBL(___L3__23__23_machine_2d_code_2d_fixup)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_apply)
___DEF_M_HLBL(___L1__23__23_apply)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_values)
___DEF_M_HLBL(___L1__23__23_make_2d_values)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_values_2d_length)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_values_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_values_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_closure_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_closure)
___DEF_M_HLBL(___L1__23__23_make_2d_closure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_closure_2d_length)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_closure_2d_code)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_closure_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_closure_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_subprocedure_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_subprocedure_2d_id)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_subprocedure_2d_parent)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_subprocedure_2d_nb_2d_parameters)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_subprocedure_2d_nb_2d_closed)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_subprocedure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_subprocedure_2d_parent_2d_info)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_subprocedure_2d_parent_2d_name)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_explode_2d_continuation)
___DEF_M_HLBL(___L1__23__23_explode_2d_continuation)
___DEF_M_HLBL(___L2__23__23_explode_2d_continuation)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_frame)
___DEF_M_HLBL(___L1__23__23_continuation_2d_frame)
___DEF_M_HLBL(___L2__23__23_continuation_2d_frame)
___DEF_M_HLBL(___L3__23__23_continuation_2d_frame)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_frame_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_denv)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_denv_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_explode_2d_frame)
___DEF_M_HLBL(___L1__23__23_explode_2d_frame)
___DEF_M_HLBL(___L2__23__23_explode_2d_frame)
___DEF_M_HLBL(___L3__23__23_explode_2d_frame)
___DEF_M_HLBL(___L4__23__23_explode_2d_frame)
___DEF_M_HLBL(___L5__23__23_explode_2d_frame)
___DEF_M_HLBL(___L6__23__23_explode_2d_frame)
___DEF_M_HLBL(___L7__23__23_explode_2d_frame)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_frame_2d_ret)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_ret)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_return_2d_fs)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_frame_2d_fs)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_fs)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_frame_2d_link)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_link)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_frame_2d_slot_2d_live_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_slot_2d_live_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_frame_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_frame_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_frame)
___DEF_M_HLBL(___L1__23__23_make_2d_frame)
___DEF_M_HLBL(___L2__23__23_make_2d_frame)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_continuation)
___DEF_M_HLBL(___L1__23__23_make_2d_continuation)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_copy)
___DEF_M_HLBL(___L1__23__23_continuation_2d_copy)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_next_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_next)
___DEF_M_HLBL(___L1__23__23_continuation_2d_next)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_continuation_2d_last)
___DEF_M_HLBL(___L1__23__23_continuation_2d_last)
___DEF_M_HLBL(___L2__23__23_continuation_2d_last)
___DEF_M_HLBL(___L3__23__23_continuation_2d_last)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_symbol_2d_table)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_keyword_2d_table)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_interned_2d_symbol)
___DEF_M_HLBL(___L1__23__23_make_2d_interned_2d_symbol)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_interned_2d_keyword)
___DEF_M_HLBL(___L1__23__23_make_2d_interned_2d_keyword)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_interned_2d_symkey)
___DEF_M_HLBL(___L1__23__23_make_2d_interned_2d_symkey)
___DEF_M_HLBL(___L2__23__23_make_2d_interned_2d_symkey)
___DEF_M_HLBL(___L3__23__23_make_2d_interned_2d_symkey)
___DEF_M_HLBL(___L4__23__23_make_2d_interned_2d_symkey)
___DEF_M_HLBL(___L5__23__23_make_2d_interned_2d_symkey)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_find_2d_interned_2d_symbol)
___DEF_M_HLBL(___L1__23__23_find_2d_interned_2d_symbol)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_find_2d_interned_2d_keyword)
___DEF_M_HLBL(___L1__23__23_find_2d_interned_2d_keyword)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_find_2d_interned_2d_symkey)
___DEF_M_HLBL(___L1__23__23_find_2d_interned_2d_symkey)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_global_2d_var)
___DEF_M_HLBL(___L1__23__23_make_2d_global_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_global_2d_var_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_global_2d_var_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_global_2d_var_2d_primitive_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_global_2d_var_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_global_2d_var_2d_primitive_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
___DEF_M_HLBL(___L1__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
___DEF_M_HLBL(___L2__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
___DEF_M_HLBL(___L3__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_object_2d__3e_global_2d_var)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_global_2d_var_2d__3e_identifier)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_foreign)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_foreign)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_foreign_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_foreign_2d_tags)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_foreign_2d_tags)
___DEF_M_HLBL(___L1_foreign_2d_tags)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_foreign_2d_released_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_foreign_2d_released_3f_)
___DEF_M_HLBL(___L1_foreign_2d_released_3f_)
___DEF_M_HLBL(___L2_foreign_2d_released_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_foreign_2d_release_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_foreign_2d_release_21_)
___DEF_M_HLBL(___L1_foreign_2d_release_21_)
___DEF_M_HLBL(___L2_foreign_2d_release_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_foreign_2d_address)
___DEF_M_HLBL(___L1__23__23_foreign_2d_address)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_foreign_2d_address)
___DEF_M_HLBL(___L1_foreign_2d_address)
___DEF_M_HLBL(___L2_foreign_2d_address)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_process_2d_statistics)
___DEF_M_HLBL(___L1__23__23_process_2d_statistics)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_process_2d_times)
___DEF_M_HLBL(___L1__23__23_process_2d_times)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_get_2d_current_2d_time_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_get_2d_monotonic_2d_time_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_get_2d_monotonic_2d_time_2d_frequency_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_get_2d_bytes_2d_allocated_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_actlog_2d_start)
___DEF_M_HLBL(___L1__23__23_actlog_2d_start)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_actlog_2d_stop)
___DEF_M_HLBL(___L1__23__23_actlog_2d_stop)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_actlog_2d_dump)
___DEF_M_HLBL(___L1__23__23_actlog_2d_dump)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_err_2d_code_2d__3e_string)
___DEF_M_HLBL(___L1_err_2d_code_2d__3e_string)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_command_2d_line)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_processed_2d_command_2d_line_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_os_2d_condvar_2d_select_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_device_2d_select_2d_abort_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_add_2d_exit_2d_job_21_)
___DEF_M_HLBL(___L1__23__23_add_2d_exit_2d_job_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_clear_2d_exit_2d_jobs_21_)
___DEF_M_HLBL(___L1__23__23_clear_2d_exit_2d_jobs_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_exit_2d_cleanup)
___DEF_M_HLBL(___L1__23__23_exit_2d_cleanup)
___DEF_M_HLBL(___L2__23__23_exit_2d_cleanup)
___DEF_M_HLBL(___L3__23__23_exit_2d_cleanup)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_exit_2d_with_2d_err_2d_code)
___DEF_M_HLBL(___L1__23__23_exit_2d_with_2d_err_2d_code)
___DEF_M_HLBL(___L2__23__23_exit_2d_with_2d_err_2d_code)
___DEF_M_HLBL(___L3__23__23_exit_2d_with_2d_err_2d_code)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_exit)
___DEF_M_HLBL(___L1__23__23_exit)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_exit_2d_abnormally)
___DEF_M_HLBL(___L1__23__23_exit_2d_abnormally)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_exit_2d_with_2d_exception)
___DEF_M_HLBL(___L1__23__23_exit_2d_with_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_first_2d_argument)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_with_2d_no_2d_result_2d_expected)
___DEF_M_HLBL(___L1__23__23_with_2d_no_2d_result_2d_expected)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel)
___DEF_M_HLBL(___L1__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_system_2d_version)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_system_2d_version)
___DEF_M_HLBL(___L1_system_2d_version)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_system_2d_version_2d_string)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_system_2d_version_2d_string)
___DEF_M_HLBL(___L1_system_2d_version_2d_string)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_system_2d_type)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_system_2d_type_2d_string)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_configure_2d_command_2d_string)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_system_2d_stamp)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_system_2d_stamp)
___DEF_M_HLBL(___L1_system_2d_stamp)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_type_2d_id)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_type_2d_name)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_type_2d_flags)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_type_2d_super)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_type_2d_fields)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_structure_2d_direct_2d_instance_2d_of_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_structure_2d_instance_2d_of_3f_)
___DEF_M_HLBL(___L1__23__23_structure_2d_instance_2d_of_3f_)
___DEF_M_HLBL(___L2__23__23_structure_2d_instance_2d_of_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_type_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_structure_2d_type)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_structure_2d_type_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_make_2d_structure)
___DEF_M_HLBL(___L1__23__23_make_2d_structure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_structure_2d_length)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_structure)
___DEF_M_HLBL(___L1__23__23_structure)
___DEF_M_HLBL(___L2__23__23_structure)
___DEF_M_HLBL(___L3__23__23_structure)
___DEF_M_HLBL(___L4__23__23_structure)
___DEF_M_HLBL(___L5__23__23_structure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_structure_2d_ref)
___DEF_M_HLBL(___L1__23__23_structure_2d_ref)
___DEF_M_HLBL(___L2__23__23_structure_2d_ref)
___DEF_M_HLBL(___L3__23__23_structure_2d_ref)
___DEF_M_HLBL(___L4__23__23_structure_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_structure_2d_set_21_)
___DEF_M_HLBL(___L1__23__23_structure_2d_set_21_)
___DEF_M_HLBL(___L2__23__23_structure_2d_set_21_)
___DEF_M_HLBL(___L3__23__23_structure_2d_set_21_)
___DEF_M_HLBL(___L4__23__23_structure_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_structure_2d_cas_21_)
___DEF_M_HLBL(___L1__23__23_structure_2d_cas_21_)
___DEF_M_HLBL(___L2__23__23_structure_2d_cas_21_)
___DEF_M_HLBL(___L3__23__23_structure_2d_cas_21_)
___DEF_M_HLBL(___L4__23__23_structure_2d_cas_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_direct_2d_structure_2d_ref)
___DEF_M_HLBL(___L1__23__23_direct_2d_structure_2d_ref)
___DEF_M_HLBL(___L2__23__23_direct_2d_structure_2d_ref)
___DEF_M_HLBL(___L3__23__23_direct_2d_structure_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_direct_2d_structure_2d_set_21_)
___DEF_M_HLBL(___L1__23__23_direct_2d_structure_2d_set_21_)
___DEF_M_HLBL(___L2__23__23_direct_2d_structure_2d_set_21_)
___DEF_M_HLBL(___L3__23__23_direct_2d_structure_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_direct_2d_structure_2d_cas_21_)
___DEF_M_HLBL(___L1__23__23_direct_2d_structure_2d_cas_21_)
___DEF_M_HLBL(___L2__23__23_direct_2d_structure_2d_cas_21_)
___DEF_M_HLBL(___L3__23__23_direct_2d_structure_2d_cas_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_unchecked_2d_structure_2d_ref)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_unchecked_2d_structure_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_unchecked_2d_structure_2d_cas_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_main_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_module_2d_init)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_create_2d_module)
___DEF_M_HLBL(___L1__23__23_create_2d_module)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_register_2d_module_2d_descr_21_)
___DEF_M_HLBL(___L1__23__23_register_2d_module_2d_descr_21_)
___DEF_M_HLBL(___L2__23__23_register_2d_module_2d_descr_21_)
___DEF_M_HLBL(___L3__23__23_register_2d_module_2d_descr_21_)
___DEF_M_HLBL(___L4__23__23_register_2d_module_2d_descr_21_)
___DEF_M_HLBL(___L5__23__23_register_2d_module_2d_descr_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_register_2d_module_2d_descrs_21_)
___DEF_M_HLBL(___L1__23__23_register_2d_module_2d_descrs_21_)
___DEF_M_HLBL(___L2__23__23_register_2d_module_2d_descrs_21_)
___DEF_M_HLBL(___L3__23__23_register_2d_module_2d_descrs_21_)
___DEF_M_HLBL(___L4__23__23_register_2d_module_2d_descrs_21_)
___DEF_M_HLBL(___L5__23__23_register_2d_module_2d_descrs_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_lookup_2d_registered_2d_module)
___DEF_M_HLBL(___L1__23__23_lookup_2d_registered_2d_module)
___DEF_M_HLBL(___L2__23__23_lookup_2d_registered_2d_module)
___DEF_M_HLBL(___L3__23__23_lookup_2d_registered_2d_module)
___DEF_M_HLBL(___L4__23__23_lookup_2d_registered_2d_module)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_lookup_2d_module)
___DEF_M_HLBL(___L1__23__23_lookup_2d_module)
___DEF_M_HLBL(___L2__23__23_lookup_2d_module)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L1__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L2__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L3__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L4__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L5__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L6__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L7__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L8__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L9__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L10__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L11__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L12__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL(___L13__23__23_load_2d_required_2d_module_2d_structs)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_default_2d_load_2d_required_2d_module)
___DEF_M_HLBL(___L1__23__23_default_2d_load_2d_required_2d_module)
___DEF_M_HLBL(___L2__23__23_default_2d_load_2d_required_2d_module)
___DEF_M_HLBL(___L3__23__23_default_2d_load_2d_required_2d_module)
___DEF_M_HLBL(___L4__23__23_default_2d_load_2d_required_2d_module)
___DEF_M_HLBL(___L5__23__23_default_2d_load_2d_required_2d_module)
___DEF_M_HLBL(___L6__23__23_default_2d_load_2d_required_2d_module)
___DEF_M_HLBL(___L7__23__23_default_2d_load_2d_required_2d_module)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_load_2d_required_2d_module_2d_set_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception)
___DEF_M_HLBL(___L1__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_module_2d_not_2d_found_2d_exception_3f_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_module_2d_not_2d_found_2d_exception_2d_procedure)
___DEF_M_HLBL(___L1_module_2d_not_2d_found_2d_exception_2d_procedure)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_module_2d_not_2d_found_2d_exception_2d_arguments)
___DEF_M_HLBL(___L1_module_2d_not_2d_found_2d_exception_2d_arguments)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
___DEF_M_HLBL(___L1__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
___DEF_M_HLBL(___L2__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
___DEF_M_HLBL(___L3__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
___DEF_M_HLBL(___L4__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
___DEF_M_HLBL(___L1__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
___DEF_M_HLBL(___L2__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
___DEF_M_HLBL(___L3__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_load_2d_vm)
___DEF_M_HLBL(___L1__23__23_load_2d_vm)
___DEF_M_HLBL(___L2__23__23_load_2d_vm)
___DEF_M_HLBL(___L3__23__23_load_2d_vm)
___DEF_M_HLBL(___L4__23__23_load_2d_vm)
___DEF_M_HLBL(___L5__23__23_load_2d_vm)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_0)
___DEF_M_HLBL(___L1___kernel_23_0)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_1)
___DEF_M_HLBL(___L1___kernel_23_1)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_2)
___DEF_M_HLBL(___L1___kernel_23_2)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_3)
___DEF_M_HLBL(___L1___kernel_23_3)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_4)
___DEF_M_HLBL(___L1___kernel_23_4)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_5)
___DEF_M_HLBL(___L1___kernel_23_5)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_6)
___DEF_M_HLBL(___L1___kernel_23_6)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_7)
___DEF_M_HLBL(___L1___kernel_23_7)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_8)
___DEF_M_HLBL(___L1___kernel_23_8)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_9)
___DEF_M_HLBL(___L1___kernel_23_9)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_10)
___DEF_M_HLBL(___L1___kernel_23_10)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_11)
___DEF_M_HLBL(___L1___kernel_23_11)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_12)
___DEF_M_HLBL(___L1___kernel_23_12)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_13)
___DEF_M_HLBL(___L1___kernel_23_13)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_14)
___DEF_M_HLBL(___L1___kernel_23_14)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_15)
___DEF_M_HLBL(___L1___kernel_23_15)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_16)
___DEF_M_HLBL(___L1___kernel_23_16)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_17)
___DEF_M_HLBL(___L1___kernel_23_17)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_18)
___DEF_M_HLBL(___L1___kernel_23_18)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_19)
___DEF_M_HLBL(___L1___kernel_23_19)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_20)
___DEF_M_HLBL(___L1___kernel_23_20)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_21)
___DEF_M_HLBL(___L1___kernel_23_21)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_22)
___DEF_M_HLBL(___L1___kernel_23_22)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_23)
___DEF_M_HLBL(___L1___kernel_23_23)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_24)
___DEF_M_HLBL(___L1___kernel_23_24)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_25)
___DEF_M_HLBL(___L1___kernel_23_25)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_26)
___DEF_M_HLBL(___L1___kernel_23_26)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_27)
___DEF_M_HLBL(___L1___kernel_23_27)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_28)
___DEF_M_HLBL(___L1___kernel_23_28)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_29)
___DEF_M_HLBL(___L1___kernel_23_29)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_30)
___DEF_M_HLBL(___L1___kernel_23_30)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_31)
___DEF_M_HLBL(___L1___kernel_23_31)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_32)
___DEF_M_HLBL(___L1___kernel_23_32)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_33)
___DEF_M_HLBL(___L1___kernel_23_33)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_34)
___DEF_M_HLBL(___L1___kernel_23_34)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_35)
___DEF_M_HLBL(___L1___kernel_23_35)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_36)
___DEF_M_HLBL(___L1___kernel_23_36)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_37)
___DEF_M_HLBL(___L1___kernel_23_37)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_38)
___DEF_M_HLBL(___L1___kernel_23_38)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_39)
___DEF_M_HLBL(___L1___kernel_23_39)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_40)
___DEF_M_HLBL(___L1___kernel_23_40)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_41)
___DEF_M_HLBL(___L1___kernel_23_41)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_42)
___DEF_M_HLBL(___L1___kernel_23_42)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_43)
___DEF_M_HLBL(___L1___kernel_23_43)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_44)
___DEF_M_HLBL(___L1___kernel_23_44)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_45)
___DEF_M_HLBL(___L1___kernel_23_45)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_46)
___DEF_M_HLBL(___L1___kernel_23_46)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_47)
___DEF_M_HLBL(___L1___kernel_23_47)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_48)
___DEF_M_HLBL(___L1___kernel_23_48)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_49)
___DEF_M_HLBL(___L1___kernel_23_49)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_50)
___DEF_M_HLBL(___L1___kernel_23_50)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_51)
___DEF_M_HLBL(___L1___kernel_23_51)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_52)
___DEF_M_HLBL(___L1___kernel_23_52)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_53)
___DEF_M_HLBL(___L1___kernel_23_53)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_54)
___DEF_M_HLBL(___L1___kernel_23_54)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_55)
___DEF_M_HLBL(___L1___kernel_23_55)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_56)
___DEF_M_HLBL(___L1___kernel_23_56)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_57)
___DEF_M_HLBL(___L1___kernel_23_57)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_58)
___DEF_M_HLBL(___L1___kernel_23_58)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_59)
___DEF_M_HLBL(___L1___kernel_23_59)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_60)
___DEF_M_HLBL(___L1___kernel_23_60)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_61)
___DEF_M_HLBL(___L1___kernel_23_61)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_62)
___DEF_M_HLBL(___L1___kernel_23_62)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_63)
___DEF_M_HLBL(___L1___kernel_23_63)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_64)
___DEF_M_HLBL(___L1___kernel_23_64)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_65)
___DEF_M_HLBL(___L1___kernel_23_65)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_66)
___DEF_M_HLBL(___L1___kernel_23_66)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_67)
___DEF_M_HLBL(___L1___kernel_23_67)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_68)
___DEF_M_HLBL(___L1___kernel_23_68)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_69)
___DEF_M_HLBL(___L1___kernel_23_69)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_70)
___DEF_M_HLBL(___L1___kernel_23_70)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_71)
___DEF_M_HLBL(___L1___kernel_23_71)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_72)
___DEF_M_HLBL(___L1___kernel_23_72)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_73)
___DEF_M_HLBL(___L1___kernel_23_73)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_74)
___DEF_M_HLBL(___L1___kernel_23_74)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_75)
___DEF_M_HLBL(___L1___kernel_23_75)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_76)
___DEF_M_HLBL(___L1___kernel_23_76)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_77)
___DEF_M_HLBL(___L1___kernel_23_77)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_78)
___DEF_M_HLBL(___L1___kernel_23_78)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_79)
___DEF_M_HLBL(___L1___kernel_23_79)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_80)
___DEF_M_HLBL(___L1___kernel_23_80)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_81)
___DEF_M_HLBL(___L1___kernel_23_81)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_82)
___DEF_M_HLBL(___L1___kernel_23_82)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_83)
___DEF_M_HLBL(___L1___kernel_23_83)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_84)
___DEF_M_HLBL(___L1___kernel_23_84)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_85)
___DEF_M_HLBL(___L1___kernel_23_85)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_86)
___DEF_M_HLBL(___L1___kernel_23_86)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_87)
___DEF_M_HLBL(___L1___kernel_23_87)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_88)
___DEF_M_HLBL(___L1___kernel_23_88)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_89)
___DEF_M_HLBL(___L1___kernel_23_89)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_90)
___DEF_M_HLBL(___L1___kernel_23_90)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_91)
___DEF_M_HLBL(___L1___kernel_23_91)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0___kernel_23_92)
___DEF_M_HLBL(___L1___kernel_23_92)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__23__23_main)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_
#undef ___PH_LBL0
#define ___PH_LBL0 1
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_)
___DEF_P_HLBL(___L1___kernel_23_)
___DEF_P_HLBL(___L2___kernel_23_)
___DEF_P_HLBL(___L3___kernel_23_)
___DEF_P_HLBL(___L4___kernel_23_)
___DEF_P_HLBL(___L5___kernel_23_)
___DEF_P_HLBL(___L6___kernel_23_)
___DEF_P_HLBL(___L7___kernel_23_)
___DEF_P_HLBL(___L8___kernel_23_)
___DEF_P_HLBL(___L9___kernel_23_)
___DEF_P_HLBL(___L10___kernel_23_)
___DEF_P_HLBL(___L11___kernel_23_)
___DEF_P_HLBL(___L12___kernel_23_)
___DEF_P_HLBL(___L13___kernel_23_)
___DEF_P_HLBL(___L14___kernel_23_)
___DEF_P_HLBL(___L15___kernel_23_)
___DEF_P_HLBL(___L16___kernel_23_)
___DEF_P_HLBL(___L17___kernel_23_)
___DEF_P_HLBL(___L18___kernel_23_)
___DEF_P_HLBL(___L19___kernel_23_)
___DEF_P_HLBL(___L20___kernel_23_)
___DEF_P_HLBL(___L21___kernel_23_)
___DEF_P_HLBL(___L22___kernel_23_)
___DEF_P_HLBL(___L23___kernel_23_)
___DEF_P_HLBL(___L24___kernel_23_)
___DEF_P_HLBL(___L25___kernel_23_)
___DEF_P_HLBL(___L26___kernel_23_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_)
   ___BEGIN_ALLOC_VECTOR(8UL)
   ___ADD_VECTOR_ELEM(0,___PRC(59))
   ___ADD_VECTOR_ELEM(1,___FAL)
   ___ADD_VECTOR_ELEM(2,___FAL)
   ___ADD_VECTOR_ELEM(3,___FAL)
   ___ADD_VECTOR_ELEM(4,___FAL)
   ___ADD_VECTOR_ELEM(5,___FAL)
   ___ADD_VECTOR_ELEM(6,___FAL)
   ___ADD_VECTOR_ELEM(7,___FAL)
   ___END_ALLOC_VECTOR(8)
   ___SET_R1(___GET_VECTOR(8))
   ___SET_GLO(136,___G__23__23_interrupt_2d_vector,___R1)
   ___SET_GLO(20,___G__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook,___FAL)
   ___SET_STK(1,___R0)
   ___ADJFP(4)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1___kernel_23_)
   ___POLL(2)
___DEF_SLBL(2,___L2___kernel_23_)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(0),___PRC(352),___L__23__23_make_2d_jobs)
___DEF_SLBL(3,___L3___kernel_23_)
   ___SET_GLO(116,___G__23__23_gc_2d_interrupt_2d_jobs,___R1)
   ___SET_R1(___CONS(___NUL,___NUL))
   ___SETCAR(___R1,___R1)
   ___SET_GLO(94,___G__23__23_final_2d_will_2d_registry,___R1)
   ___SET_R2(___PRC(417))
   ___SET_R1(___FIX(4L))
   ___SET_R0(___LBL(5))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4___kernel_23_)
   ___JUMPINT(___SET_NARGS(2),___PRC(65),___L__23__23_interrupt_2d_vector_2d_set_21_)
___DEF_SLBL(5,___L5___kernel_23_)
   ___SET_GLO(52,___G__23__23_current_2d_vm_2d_resize,___PRC(953))
   ___SET_GLO(51,___G__23__23_current_2d_vm_2d_processor_2d_count,___PRC(956))
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(0),___PRC(983),___L___kernel_23_11)
___DEF_SLBL(6,___L6___kernel_23_)
   ___SET_GLO(246,___G__23__23_os_2d_obj_2d_extension_2d_string_2d_saved,___R1)
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(0),___PRC(986),___L___kernel_23_12)
___DEF_SLBL(7,___L7___kernel_23_)
   ___SET_GLO(234,___G__23__23_os_2d_exe_2d_extension_2d_string_2d_saved,___R1)
   ___SET_R0(___LBL(8))
   ___JUMPINT(___SET_NARGS(0),___PRC(989),___L___kernel_23_13)
___DEF_SLBL(8,___L8___kernel_23_)
   ___SET_GLO(186,___G__23__23_os_2d_bat_2d_extension_2d_string_2d_saved,___R1)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___ERRNO_ERR(EAGAIN));
   ___SET_R1(___RESULT)
}
   ___SET_GLO(61,___G__23__23_err_2d_code_2d_EAGAIN,___R1)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___ERRNO_ERR(ENOENT));
   ___SET_R1(___RESULT)
}
   ___SET_GLO(63,___G__23__23_err_2d_code_2d_ENOENT,___R1)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___ERRNO_ERR(EINTR));
   ___SET_R1(___RESULT)
}
   ___SET_GLO(62,___G__23__23_err_2d_code_2d_EINTR,___R1)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___UNIMPL_ERR);
   ___SET_R1(___RESULT)
}
   ___SET_GLO(64,___G__23__23_err_2d_code_2d_unimplemented,___R1)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___MAX_CHR);
   ___SET_R1(___RESULT)
}
   ___SET_GLO(179,___G__23__23_max_2d_char,___R1)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___MIN_FIX);
   ___SET_R1(___RESULT)
}
   ___SET_GLO(181,___G__23__23_min_2d_fixnum,___R1)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___MAX_FIX);
   ___SET_R1(___RESULT)
}
   ___SET_GLO(180,___G__23__23_max_2d_fixnum,___R1)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___FIX_WIDTH);
   ___SET_R1(___RESULT)
}
   ___SET_GLO(99,___G__23__23_fixnum_2d_width,___R1)
   ___SET_R1(___FIXNEG(___GLO__23__23_fixnum_2d_width))
   ___SET_GLO(100,___G__23__23_fixnum_2d_width_2d_neg,___R1)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___BIG_ABASE_WIDTH);
   ___SET_R1(___RESULT)
}
   ___SET_GLO(16,___G__23__23_bignum_2e_adigit_2d_width,___R1)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___BIG_MBASE_WIDTH);
   ___SET_R1(___RESULT)
}
   ___SET_GLO(18,___G__23__23_bignum_2e_mdigit_2d_width,___R1)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___BIG_FBASE_WIDTH);
   ___SET_R1(___RESULT)
}
   ___SET_GLO(17,___G__23__23_bignum_2e_fdigit_2d_width,___R1)
   ___SET_GLO(106,___G__23__23_format_2d_filepos,___PRC(1001))
   ___SET_GLO(233,___G__23__23_os_2d_err_2d_code_2d__3e_string,___PRC(1004))
   ___SET_GLO(249,___G__23__23_os_2d_path_2d_homedir,___PRC(1007))
   ___SET_GLO(247,___G__23__23_os_2d_path_2d_gambitdir,___PRC(1010))
   ___SET_GLO(248,___G__23__23_os_2d_path_2d_gambitdir_2d_map_2d_lookup,___PRC(1013))
   ___SET_GLO(250,___G__23__23_os_2d_path_2d_normalize_2d_directory,___PRC(1016))
   ___SET_GLO(293,___G__23__23_remote_2d_dbg_2d_addr,___PRC(1019))
   ___SET_GLO(298,___G__23__23_rpc_2d_server_2d_addr,___PRC(1022))
   ___SET_R0(___LBL(9))
   ___JUMPINT(___SET_NARGS(0),___PRC(727),___L__23__23_command_2d_line)
___DEF_SLBL(9,___L9___kernel_23_)
   ___SET_GLO(263,___G__23__23_processed_2d_command_2d_line,___R1)
   ___SET_GLO(237,___G__23__23_os_2d_getenv,___PRC(1025))
   ___SET_GLO(255,___G__23__23_os_2d_setenv,___PRC(1028))
   ___SET_GLO(232,___G__23__23_os_2d_environ,___PRC(1031))
   ___SET_GLO(256,___G__23__23_os_2d_shell_2d_command,___PRC(1034))
   ___SET_GLO(202,___G__23__23_os_2d_device_2d_kind,___PRC(1037))
   ___SET_GLO(201,___G__23__23_os_2d_device_2d_force_2d_output,___PRC(1040))
   ___SET_GLO(196,___G__23__23_os_2d_device_2d_close,___PRC(1043))
   ___SET_GLO(212,___G__23__23_os_2d_device_2d_stream_2d_seek,___PRC(1046))
   ___SET_GLO(211,___G__23__23_os_2d_device_2d_stream_2d_read,___PRC(1049))
   ___SET_GLO(214,___G__23__23_os_2d_device_2d_stream_2d_write,___PRC(1052))
   ___SET_GLO(213,___G__23__23_os_2d_device_2d_stream_2d_width,___PRC(1055))
   ___SET_GLO(206,___G__23__23_os_2d_device_2d_stream_2d_default_2d_options,___PRC(1058))
   ___SET_GLO(210,___G__23__23_os_2d_device_2d_stream_2d_options_2d_set_21_,___PRC(1061))
   ___SET_GLO(208,___G__23__23_os_2d_device_2d_stream_2d_open_2d_predefined,___PRC(1064))
   ___SET_GLO(207,___G__23__23_os_2d_device_2d_stream_2d_open_2d_path,___PRC(1067))
   ___SET_GLO(209,___G__23__23_os_2d_device_2d_stream_2d_open_2d_process,___PRC(1070))
   ___SET_GLO(203,___G__23__23_os_2d_device_2d_open_2d_raw_2d_from_2d_fd,___PRC(1073))
   ___SET_GLO(204,___G__23__23_os_2d_device_2d_process_2d_pid,___PRC(1076))
   ___SET_GLO(205,___G__23__23_os_2d_device_2d_process_2d_status,___PRC(1079))
   ___SET_GLO(244,___G__23__23_os_2d_make_2d_tls_2d_context,___PRC(1082))
   ___SET_GLO(215,___G__23__23_os_2d_device_2d_tcp_2d_client_2d_open,___PRC(1085))
   ___SET_GLO(216,___G__23__23_os_2d_device_2d_tcp_2d_client_2d_socket_2d_info,___PRC(1088))
   ___SET_GLO(217,___G__23__23_os_2d_device_2d_tcp_2d_server_2d_open,___PRC(1091))
   ___SET_GLO(218,___G__23__23_os_2d_device_2d_tcp_2d_server_2d_read,___PRC(1094))
   ___SET_GLO(219,___G__23__23_os_2d_device_2d_tcp_2d_server_2d_socket_2d_info,___PRC(1097))
   ___SET_GLO(228,___G__23__23_os_2d_device_2d_udp_2d_open,___PRC(1100))
   ___SET_GLO(229,___G__23__23_os_2d_device_2d_udp_2d_read_2d_subu8vector,___PRC(1103))
   ___SET_GLO(231,___G__23__23_os_2d_device_2d_udp_2d_write_2d_subu8vector,___PRC(1106))
   ___SET_GLO(227,___G__23__23_os_2d_device_2d_udp_2d_destination_2d_set_21_,___PRC(1109))
   ___SET_GLO(230,___G__23__23_os_2d_device_2d_udp_2d_socket_2d_info,___PRC(1112))
   ___SET_GLO(197,___G__23__23_os_2d_device_2d_directory_2d_open_2d_path,___PRC(1115))
   ___SET_GLO(198,___G__23__23_os_2d_device_2d_directory_2d_read,___PRC(1118))
   ___SET_GLO(199,___G__23__23_os_2d_device_2d_event_2d_queue_2d_open,___PRC(1121))
   ___SET_GLO(200,___G__23__23_os_2d_device_2d_event_2d_queue_2d_read,___PRC(1124))
   ___SET_GLO(226,___G__23__23_os_2d_device_2d_tty_2d_type_2d_set_21_,___PRC(1127))
   ___SET_GLO(225,___G__23__23_os_2d_device_2d_tty_2d_text_2d_attributes_2d_set_21_,___PRC(1130))
   ___SET_GLO(220,___G__23__23_os_2d_device_2d_tty_2d_history,___PRC(1133))
   ___SET_GLO(222,___G__23__23_os_2d_device_2d_tty_2d_history_2d_set_21_,___PRC(1136))
   ___SET_GLO(221,___G__23__23_os_2d_device_2d_tty_2d_history_2d_max_2d_length_2d_set_21_,___PRC(1139))
   ___SET_GLO(224,___G__23__23_os_2d_device_2d_tty_2d_paren_2d_balance_2d_duration_2d_set_21_,___PRC(1142))
   ___SET_GLO(223,___G__23__23_os_2d_device_2d_tty_2d_mode_2d_set_21_,___PRC(1145))
   ___SET_GLO(236,___G__23__23_os_2d_file_2d_times_2d_set_21_,___PRC(1148))
   ___SET_GLO(235,___G__23__23_os_2d_file_2d_info,___PRC(1151))
   ___SET_GLO(259,___G__23__23_os_2d_user_2d_info,___PRC(1154))
   ___SET_GLO(260,___G__23__23_os_2d_user_2d_name,___PRC(1157))
   ___SET_GLO(240,___G__23__23_os_2d_group_2d_info,___PRC(1160))
   ___SET_GLO(185,___G__23__23_os_2d_address_2d_infos,___PRC(1163))
   ___SET_GLO(241,___G__23__23_os_2d_host_2d_info,___PRC(1166))
   ___SET_GLO(242,___G__23__23_os_2d_host_2d_name,___PRC(1169))
   ___SET_GLO(253,___G__23__23_os_2d_service_2d_info,___PRC(1172))
   ___SET_GLO(251,___G__23__23_os_2d_protocol_2d_info,___PRC(1175))
   ___SET_GLO(245,___G__23__23_os_2d_network_2d_info,___PRC(1178))
   ___SET_GLO(238,___G__23__23_os_2d_getpid,___PRC(1181))
   ___SET_GLO(239,___G__23__23_os_2d_getppid,___PRC(1184))
   ___SET_GLO(190,___G__23__23_os_2d_create_2d_directory,___PRC(1187))
   ___SET_GLO(191,___G__23__23_os_2d_create_2d_fifo,___PRC(1190))
   ___SET_GLO(192,___G__23__23_os_2d_create_2d_link,___PRC(1193))
   ___SET_GLO(193,___G__23__23_os_2d_create_2d_symbolic_2d_link,___PRC(1196))
   ___SET_GLO(194,___G__23__23_os_2d_delete_2d_directory,___PRC(1199))
   ___SET_GLO(254,___G__23__23_os_2d_set_2d_current_2d_directory,___PRC(1202))
   ___SET_GLO(252,___G__23__23_os_2d_rename_2d_file,___PRC(1205))
   ___SET_GLO(189,___G__23__23_os_2d_copy_2d_file,___PRC(1208))
   ___SET_GLO(195,___G__23__23_os_2d_delete_2d_file,___PRC(1211))
   ___SET_GLO(243,___G__23__23_os_2d_load_2d_object_2d_file,___PRC(1214))
   ___SET_R0(___LBL(10))
   ___JUMPINT(___SET_NARGS(0),___PRC(352),___L__23__23_make_2d_jobs)
___DEF_SLBL(10,___L10___kernel_23_)
   ___SET_GLO(71,___G__23__23_exit_2d_jobs,___R1)
   ___SET_R2(___LBL(26))
   ___SET_R1(___FIX(1L))
   ___SET_R0(___LBL(11))
   ___JUMPINT(___SET_NARGS(2),___PRC(65),___L__23__23_interrupt_2d_vector_2d_set_21_)
___DEF_SLBL(11,___L11___kernel_23_)
   ___SET_R0(___LBL(12))
   ___JUMPINT(___SET_NARGS(0),___PRC(1217),___L___kernel_23_89)
___DEF_SLBL(12,___L12___kernel_23_)
   ___SET_R0(___LBL(18))
   ___IF(___NULLP(___R1))
   ___GOTO(___L28___kernel_23_)
   ___END_IF
   ___GOTO(___L27___kernel_23_)
___DEF_SLBL(13,___L13___kernel_23_)
   ___SET_STK(-5,___R1)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___LBL(15))
   ___IF(___NULLP(___R1))
   ___GOTO(___L28___kernel_23_)
   ___END_IF
___DEF_GLBL(___L27___kernel_23_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___ADJFP(8)
   ___POLL(14)
___DEF_SLBL(14,___L14___kernel_23_)
   ___SET_R0(___LBL(13))
   ___JUMPINT(___SET_NARGS(1),___PRC(628),___L__23__23_make_2d_interned_2d_symbol)
___DEF_SLBL(15,___L15___kernel_23_)
   ___SET_R1(___CONS(___STK(-5),___R1))
   ___CHECK_HEAP(16,4096)
___DEF_SLBL(16,___L16___kernel_23_)
   ___POLL(17)
___DEF_SLBL(17,___L17___kernel_23_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L28___kernel_23_)
   ___SET_R1(___NUL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(18,___L18___kernel_23_)
   ___SET_GLO(257,___G__23__23_os_2d_system_2d_type_2d_saved,___R1)
   ___SET_R0(___LBL(19))
   ___JUMPINT(___SET_NARGS(0),___PRC(1220),___L___kernel_23_90)
___DEF_SLBL(19,___L19___kernel_23_)
   ___SET_GLO(258,___G__23__23_os_2d_system_2d_type_2d_string_2d_saved,___R1)
   ___SET_R0(___LBL(20))
   ___JUMPINT(___SET_NARGS(0),___PRC(1223),___L___kernel_23_91)
___DEF_SLBL(20,___L20___kernel_23_)
   ___SET_GLO(188,___G__23__23_os_2d_configure_2d_command_2d_string_2d_saved,___R1)
   ___SET_R0(___LBL(21))
   ___JUMPINT(___SET_NARGS(0),___PRC(1226),___L___kernel_23_92)
___DEF_SLBL(21,___L21___kernel_23_)
   ___SET_GLO(329,___G__23__23_system_2d_stamp_2d_saved,___R1)
   ___SET_GLO(337,___G__23__23_type_2d_type,___SUB(0))
   ___SET_GLO(151,___G__23__23_main,___PRC(1229))
{ ___SCMOBJ ___RESULT;
___RESULT = ___GSTATE->program_descr;
   ___SET_R1(___RESULT)
}
   ___SET_GLO(265,___G__23__23_program_2d_descr,___R1)
{ ___SCMOBJ ___RESULT;
___RESULT = ___VMSTATE_FROM_PSTATE(___ps)->main_module_id;
   ___SET_R1(___RESULT)
}
   ___SET_GLO(345,___G__23__23_vm_2d_main_2d_module_2d_id,___R1)
   ___SET_R1(___LBL(24))
   ___SET_R0(___LBL(22))
   ___JUMPINT(___SET_NARGS(1),___PRC(864),___L__23__23_main_2d_set_21_)
___DEF_SLBL(22,___L22___kernel_23_)
   ___SET_GLO(292,___G__23__23_registered_2d_modules,___NUL)
   ___SET_GLO(140,___G__23__23_load_2d_required_2d_module,___PRC(910))
   ___SET_R0(___STK(-3))
   ___POLL(23)
___DEF_SLBL(23,___L23___kernel_23_)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(0),___PRC(943),___L__23__23_load_2d_vm)
___DEF_SLBL(24,___L24___kernel_23_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(24,0,0,0)
   ___POLL(25)
___DEF_SLBL(25,___L25___kernel_23_)
   ___JUMPINT(___SET_NARGS(0),___PRC(743),___L__23__23_exit_2d_cleanup)
___DEF_SLBL(26,___L26___kernel_23_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(26,0,0,0)
   ___JUMPINT(___SET_NARGS(0),___PRC(756),___L__23__23_exit_2d_abnormally)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_kernel_2d_handlers
#undef ___PH_LBL0
#define ___PH_LBL0 29
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L1__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L2__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L3__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L4__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L5__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L6__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L7__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L8__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L9__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L10__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L11__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L12__23__23_kernel_2d_handlers)
___DEF_P_HLBL(___L13__23__23_kernel_2d_handlers)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_kernel_2d_handlers)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_kernel_2d_handlers)
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(0)
    *
    * This is the 'Scheme function' conversion error handler.  It is
    * invoked when a data representation conversion error is detected
    * by the C-interface when C is calling a Scheme function.
    */

   ___PUSH_ARGS3(___ps->temp1, /* arg 1 = error code, integer */
                 ___ps->temp2, /* arg 2 = error message, string or #f */
                 ___FIELD(___ps->temp3,0)) /* arg 3 = procedure */

   ___COVER_SFUN_CONVERSION_ERROR_HANDLER;

   ___JUMPPRM(___SET_NARGS(3),
              ___PRMCELL(___G__23__23_raise_2d_sfun_2d_conversion_2d_exception.prm))

}
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(1,___L1__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(1)
    *
    * This is the 'C function' conversion error handler.  It is invoked
    * when a data representation conversion error is detected by the
    * C-interface when Scheme is calling a C function.
    */

   int na;
   int i;

   na = ___ps->na;

   /* make space for 3 new arguments (one will replace return address) */

   ___ADJFP((na+1)+2-___FRAME_SPACE(na+1))

   ___SET_R0(___STK(-2)) /* get return address */

   for (i=0; i<na; i++)
     ___SET_STK(-i,___STK(-(i+3))) /* shift arguments up by three */

   ___SET_STK(-(na+2),___ps->temp1) /* arg 1 = error code, integer */
   ___SET_STK(-(na+1),___ps->temp2) /* arg 2 = error message, string or #f */
   ___SET_STK(-na,___ps->temp3) /* arg 3 = procedure */

   ___POP_ARGS_IN_REGS(na+3) /* load register arguments */

   ___COVER_CFUN_CONVERSION_ERROR_HANDLER;

   ___JUMPPRM(___SET_NARGS(na+3),
              ___PRMCELL(___G__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary.prm))

}
#undef ___ARG1
   ___SET_R0(___LBL(2))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(2,___L2__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(2)
    *
    * This is the stack-limit handler.  It is invoked by the ___POLL(n)
    * macro when the stack limit is reached and when an interrupt is received.
    *
    * This handler checks for which reason it was invoked and dispatches
    * to one of the following procedures:
    *
    *  ##interrupt-handler
    *  ##raise-stack-overflow-exception
    */

   int fs;
   ___SCMOBJ ra;

#ifdef ___HEARTBEAT_USING_POLL_COUNTDOWN

  if (___ps->heartbeat_countdown <= 0)
  {
    ___ps->heartbeat_countdown = ___ps->heartbeat_interval;
    ___raise_interrupt (___INTR_HEARTBEAT);
  }

#endif

   /* setup internal return continuation frame */

   ra = ___ps->temp1;

   ___RETI_GET_CFS(ra,fs)

   ___ADJFP(___ROUND_TO_MULT(fs,___FRAME_ALIGN)-fs)

   ___PUSH_REGS /* push all GVM registers (live or not) */
   ___PUSH(ra)  /* push return address */

   ___ADJFP(-___RETI_RA)

   ___SET_R0(___GSTATE->internal_return)

   /* check why the handler was called */

   if (___FP_AFTER(___fp,___ps->stack_limit)
#ifdef ___CALL_GC_FREQUENTLY
       || --___ps->mem.gc_calls_to_punt_ < 0
#endif
      )
     {
       ___BOOL overflow;

       ___COVER_STACK_LIMIT_HANDLER_STACK_LIMIT;

       ___FRAME_STORE_RA(___R0)
       ___W_ALL
       overflow = ___stack_limit (___PSPNC) && ___garbage_collect (___PSP 0);
       ___R_ALL
       ___SET_R0(___FRAME_FETCH_RA)

       if (overflow)
         {
           ___COVER_STACK_LIMIT_HANDLER_HEAP_OVERFLOW;
           ___JUMPPRM(___SET_NARGS(0),
                      ___PRMCELL(___G__23__23_raise_2d_stack_2d_overflow_2d_exception.prm))
         }
     }

   /* handle interrupts */

   ___JUMPPRM(___SET_NARGS(0),
              ___PRMCELL(___G__23__23_interrupt_2d_handler.prm))

}
#undef ___ARG1
   ___SET_R0(___LBL(3))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(3,___L3__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(3)
    *
    * This is the heap-limit handler.  It is invoked by the ___CHECK_HEAP(n,m)
    * macro when the heap pointer reaches the end of the current msection.
    *
    * This handler simply calls ##check-heap.
    */

   int fs;
   ___SCMOBJ ra;

   /* setup internal return continuation frame */

   ra = ___ps->temp1;

   ___RETI_GET_CFS(ra,fs)

   ___ADJFP(___ROUND_TO_MULT(fs,___FRAME_ALIGN)-fs)

   ___PUSH_REGS /* push all GVM registers (live or not) */
   ___PUSH(ra)  /* push return address */

   ___ADJFP(-___RETI_RA)

   ___SET_R0(___GSTATE->internal_return)

   /* tail call to ##check-heap */

   ___COVER_HEAP_LIMIT_HANDLER_END;

   ___JUMPPRM(___SET_NARGS(0),
              ___PRMCELL(___G__23__23_check_2d_heap.prm))

}
#undef ___ARG1
   ___SET_R0(___LBL(4))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(4,___L4__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(4)
    *
    * This is the call to nonprocedure handler.  It is invoked when
    * there is an attempt to call an object that is not a procedure.
    *
    * This handler simply tail calls ##apply-with-procedure-check-nary
    * (i.e. the continuation will be the same as that of the faulty call).
    * The arguments are the object that was in operator position followed
    * by the arguments of the faulty call.
    */

   int na;
   int i;

   na = ___ps->na;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */
   ___PUSH(___FIX(0))       /* make space for operator */

   for (i=0; i<na; i++)
     ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

   ___SET_STK(-na,___ps->temp1) /* set operator argument */

   ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

   ___COVER_NONPROC_HANDLER_END;

   ___JUMPPRM(___SET_NARGS(na+1),
              ___PRMCELL(___G__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary.prm))

}
#undef ___ARG1
   ___SET_R0(___LBL(5))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(5,___L5__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(5)
    *
    * This is the call to global nonprocedure handler.  It is invoked
    * when there is an attempt to call an object that is not a procedure
    * that is bound to a global variable.
    *
    * This handler simply tail calls ##apply-global-with-procedure-check-nary
    * or ##apply-with-procedure-check-nary (i.e. the continuation will
    * be the same as that of the faulty call).
    * ##apply-global-with-procedure-check-nary is called when the global
    * variable's name is known (in this case the arguments are the variable's
    * name followed by the arguments of the faulty call).  Otherwise,
    * ##apply-with-procedure-check-nary is called and the arguments are the
    * object that was in operator position followed by the arguments of the
    * faulty call.
    */

   int na;
   int i;
   ___SCMOBJ result;
   ___SCMOBJ handler;

   na = ___ps->na;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */
   ___PUSH(___FIX(0))       /* make space for operator */

   for (i=0; i<na; i++)
     ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

   result = ___GLOCELL(___CAST(___glo_struct*,___ps->temp4)->val);
   handler = ___PRMCELL(___G__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary.prm);

#if 0

   i = ___INT(___VECTORLENGTH(___symbol_table)) - 1;

   while (i > 0)
     {
       ___SCMOBJ probe = ___FIELD(___symbol_table,i);

       while (probe != ___NUL)
         {
           if (___CAST(___glo_struct*,___ps->temp4) == ___GLOBALVARSTRUCT(probe))
             {
               ___COVER_GLOBAL_NONPROC_HANDLER_FOUND;
               result = probe;
               handler = ___PRMCELL(___G__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary.prm);
               break;
             }
           ___COVER_GLOBAL_NONPROC_HANDLER_NEXT;
           probe = ___FIELD(probe,___SYMKEY_NEXT);
         }
       i--;
     }

#endif

   ___SET_STK(-na,result) /* set operator argument */

   ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

   ___COVER_GLOBAL_NONPROC_HANDLER_END;

   ___JUMPPRM(___SET_NARGS(na+1),handler)

}
#undef ___ARG1
   ___SET_R0(___LBL(6))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(6,___L6__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(6)
    *
    * This is the wrong number of arguments handler.  It is invoked when
    * a procedure is called with a number of arguments that it does not
    * accept.
    *
    * This handler simply tail calls
    * ##raise-wrong-number-of-arguments-exception (i.e. the continuation
    * will be the same as that of the faulty call).  The arguments are the
    * object that was in operator position followed by the arguments of
    * the faulty call.
    */

   int na;
   int i;

   na = ___ps->na;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */
   ___PUSH(___FIX(0))       /* make space for operator */

   for (i=0; i<na; i++)
     ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

   /* ___ps->temp1 points to the entry point of the procedure */

   if (___HD_TYP(___SUBTYPED_HEADER(___ps->temp1)) == ___PERM)
     {
       ___COVER_WRONG_NARGS_HANDLER_NONCLOSURE;
       ___SET_STK(-na,___ps->temp1) /*set operator argument when nonclosure*/
     }
   else
     {
       ___COVER_WRONG_NARGS_HANDLER_CLOSURE;
       ___SET_STK(-na,___SELF) /* set operator argument when closure */
     }

   ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

   ___JUMPPRM(___SET_NARGS(na+1),
              ___PRMCELL(___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary.prm))

}
#undef ___ARG1
   ___SET_R0(___LBL(7))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(7,___L7__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(7)
    *
    * This is the rest parameter handler.  It is invoked when a nonnull
    * rest parameter must be constructed.
    */

   int np;
   int na;
   int i;
   ___SCMOBJ rest_param_list;

   np = ___PRD_NBPARMS(___SUBTYPED_HEADER(___ps->temp1));
   na = ___ps->na;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */

   if (na < np)
     {
       ___COVER_REST_PARAM_HANDLER_WRONG_NARGS;

       ___PUSH(___FIX(0)) /* make space for operator */

       for (i=0; i<na; i++)
         ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

       ___SET_STK(-na,___ps->temp1) /* set operator argument */

       ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

       ___JUMPPRM(___SET_NARGS(na+1),
                  ___PRMCELL(___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary.prm))
     }

   rest_param_list = ___NUL;

   i = na - np + 1;

   while (i > 0)
     {
       rest_param_list = ___CONS(___POP,rest_param_list);
       i--;

       if (___hp > ___ps->heap_limit)
         {
            ___BOOL need_to_gc;

            ___COVER_REST_PARAM_HANDLER_HEAP_LIMIT;

            ___W_ALL
            need_to_gc = ___heap_limit (___PSPNC);
            ___R_ALL

            if (need_to_gc)
              {
                /*
                 * We need to garbage collect, but before we do we have
                 * to remove all arguments from the stack so that the GC
                 * only sees complete continuation frames on the stack.
                 * The arguments are stored in a heap allocated vector.
                 */

                ___COVER_REST_PARAM_HANDLER_NEED_TO_GC;

                while (i > 0)
                  {
                    rest_param_list = ___CONS(___POP,rest_param_list);
                    i--;
                  }

                ___BEGIN_ALLOC_VECTOR(np)
                i = np - 1;
                ___ADD_VECTOR_ELEM(i,rest_param_list)
                while (i > 0)
                  {
                    i--;
                    ___ADD_VECTOR_ELEM(i,___POP)
                  }
                ___END_ALLOC_VECTOR(np)

                ___PUSH_ARGS2(___ps->temp1,___GET_VECTOR(np))

                ___JUMPPRM(___SET_NARGS(2),
                           ___PRMCELL(___G__23__23_rest_2d_param_2d_check_2d_heap.prm))
              }
          }
     }

   ___COVER_REST_PARAM_HANDLER_NO_NEED_TO_GC;

   ___PUSH(rest_param_list) /* rest parameter is last */

   ___POP_ARGS_IN_REGS(np) /* load register arguments */

   ___JUMPEXTPRM(___SET_NARGS(-1),___ps->temp1)

}
#undef ___ARG1
   ___SET_R0(___LBL(8))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(8,___L8__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(8)
    *
    * This is the keyword parameter handler.  It is invoked when keyword
    * parameters must be processed.
    */

   int np;
   int na;
   int nb_req_opt;
   int nb_key;
   int i;
   int j;
   int k;
   int fnk;
   ___SCMOBJ key_descr;
   ___SCMOBJ key_vals[___MAX_NB_PARMS];

   np = ___PRD_NBPARMS(___SUBTYPED_HEADER(___ps->temp1));
   na = ___ps->na;
   key_descr = ___ps->temp3;
   nb_req_opt = ___ps->temp2;
   nb_key = np - nb_req_opt;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */

   k = na - nb_req_opt; /* k = number of arguments that are */
                        /* non-required and non-optional */

   if (k < 0) /* not all required and optional arguments supplied? */
     {
       ___COVER_KEYWORD_PARAM_HANDLER_WRONG_NARGS1;

       wrong_nb_args1:

       ___PUSH(___FIX(0)) /* make space for operator */

       for (i=0; i<na; i++)
         ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

       ___SET_STK(-na,___ps->temp1) /* set operator argument */

       ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

       ___JUMPPRM(___SET_NARGS(na+1),
                  ___PRMCELL(___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary.prm))
     }

   /* find first non-keyword pair in remaining arguments */

   for (fnk=k-1; fnk>0; fnk-=2)
     if (!___KEYWORDP(___STK(-fnk)))
       break;

   fnk++;

   /* assign values to keyword parameters from last to first */

   for (j=nb_key-1; j>=0; j--)
     key_vals[j] = ___FIELD(key_descr,j*2+1);

   for (i=fnk+1; i<=k; i+=2)
     {
       ___SCMOBJ key = ___STK(-i);

       for (j=nb_key-1; j>=0; j--)
         if (key == ___FIELD(key_descr,j*2))
           {
             ___COVER_KEYWORD_PARAM_HANDLER_FOUND;
             key_vals[j] = ___STK(-i+1);
             goto continue1;
           }

       /* the keyword was not found in the keyword parameter descriptor */

       ___COVER_KEYWORD_PARAM_HANDLER_NOT_FOUND;

       ___PUSH(___FIX(0)) /* make space for operator */

       for (i=0; i<na; i++)
         ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

       ___SET_STK(-na,___ps->temp1) /* set operator argument */

       ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

       ___JUMPPRM(___SET_NARGS(na+1),
                  ___PRMCELL(___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary.prm))

       continue1:;
     }

   if (k & 1) /* keyword arguments must come in pairs */
     {
       ___COVER_KEYWORD_PARAM_HANDLER_WRONG_NARGS2;

       goto wrong_nb_args1;
     }

   if (fnk != 0)
     {
       ___COVER_KEYWORD_PARAM_HANDLER_KEYWORD_EXPECTED;

       ___PUSH(___FIX(0)) /* make space for operator */

       for (i=0; i<na; i++)
         ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

       ___SET_STK(-na,___ps->temp1) /* set operator argument */

       ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

       ___JUMPPRM(___SET_NARGS(na+1),
                  ___PRMCELL(___G__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary.prm))
     }

   ___ADJFP(-k) /* remove keyword arguments */

   for (i=0; i<nb_key; i++) /* push value of all keyword params */
     ___PUSH(key_vals[i])

   ___POP_ARGS_IN_REGS(np) /* load register arguments */

   ___COVER_KEYWORD_PARAM_HANDLER_END;

   ___JUMPEXTPRM(___SET_NARGS(-1),___ps->temp1)

}
#undef ___ARG1
   ___SET_R0(___LBL(9))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(9,___L9__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(9)
    *
    * This is the keyword and rest parameter handler.  It is invoked when
    * keyword parameters must be processed and a rest parameter must be
    * constructed.
    *
    * After ___PUSH_ARGS_IN_REGS(na) is executed the stack contains
    * all the arguments of the procedure call:
    *
    *              STACK
    *          |            |
    *          +------------+
    *  ___fp ->|   arg_na   |
    *          |    ...     |
    *          |   arg_3    |
    *          |   arg_2    |
    *          |   arg_1    |
    *          +------------+
    *          |    ...     |
    *
    * These arguments will be kept in this location during argument
    * processing.  If the argument processing does not encounter an
    * exceptional situation, the arguments will be overwritten with
    * the formal parameters and the body of the procedure will be
    * jumped to.  If a heap overflow is detected during the
    * construction of the rest parameter, then the construction of the
    * rest parameter is completed and all the parameters including the
    * keyword parameters are copied to a vector and the procedure
    * ##rest-param-check-heap will be called to trigger a garbage
    * collection.  Then the procedure will be returned to with the
    * processed arguments.
    */

   int np;          /* number of formal parameters */
   int na;          /* number of arguments of the call */
   int nb_req_opt;  /* number of required or optional parameters */
   int nb_key;      /* number of keyword parameters */
   int i;
   int j;
   int k;
   int fnk;
   ___SCMOBJ key_descr;
   ___SCMOBJ key_vals[___MAX_NB_PARMS];
   ___SCMOBJ rest_param_list;

   np = ___PRD_NBPARMS(___SUBTYPED_HEADER(___ps->temp1));
   na = ___ps->na;
   key_descr = ___ps->temp3;
   nb_req_opt = ___ps->temp2;
   nb_key = (np-1) - nb_req_opt;

   ___PUSH_ARGS_IN_REGS(na) /* save all arguments that are in registers */

   k = na - nb_req_opt; /* k = number of arguments that are */
                        /* non-required and non-optional */

   if (k < 0) /* not all required and optional arguments supplied? */
     {
       ___COVER_KEYWORD_REST_PARAM_HANDLER_WRONG_NARGS1;

       wrong_nb_args2:

       ___PUSH(___FIX(0)) /* make space for operator */

       for (i=0; i<na; i++)
         ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

       ___SET_STK(-na,___ps->temp1) /* set operator argument */

       ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

       ___JUMPPRM(___SET_NARGS(na+1),
                  ___PRMCELL(___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary.prm))
     }

   /* find first non-keyword pair in remaining arguments */

   for (fnk=k-1; fnk>0; fnk-=2)
     if (!___KEYWORDP(___STK(-fnk)))
       break;

   fnk++;

   /* assign values to keyword parameters from last to first */

   for (j=nb_key-1; j>=0; j--)
     key_vals[j] = ___FIELD(key_descr,j*2+1);

   for (i=fnk+1; i<=k; i+=2)
     {
       ___SCMOBJ key = ___STK(-i);

       for (j=nb_key-1; j>=0; j--)
         if (key == ___FIELD(key_descr,j*2))
           {
             ___COVER_KEYWORD_REST_PARAM_HANDLER_FOUND;
             key_vals[j] = ___STK(-i+1);
             goto continue2;
           }

       /* the keyword was not found in the keyword parameter descriptor */

       if (!___ps->temp4) /* not DSSSL style rest parameter? */
         {
           ___COVER_KEYWORD_REST_PARAM_HANDLER_NOT_FOUND;

           ___PUSH(___FIX(0)) /* make space for operator */

           for (i=0; i<na; i++)
             ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

           ___SET_STK(-na,___ps->temp1) /* set operator argument */

           ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

           ___JUMPPRM(___SET_NARGS(na+1),
                      ___PRMCELL(___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary.prm))
         }

       continue2:;
     }

   if (!___ps->temp4) /* not DSSSL style rest parameter? */
     i = fnk;
   else
     {
#ifdef ___REJECT_ILLEGAL_DSSSL_PARAMETER_LIST

       if (k & 1) /* keyword arguments must come in pairs */
         {
           ___COVER_KEYWORD_REST_PARAM_HANDLER_WRONG_NARGS2;

           goto wrong_nb_args2;
         }

       if (fnk != 0)
         {
           ___COVER_KEYWORD_REST_PARAM_HANDLER_KEYWORD_EXPECTED;

           ___PUSH(___FIX(0)) /* make space for operator */

           for (i=0; i<na; i++)
             ___SET_STK(-i,___STK(-(i+1))) /* shift arguments up by one */

           ___SET_STK(-na,___ps->temp1) /* set operator argument */

           ___POP_ARGS_IN_REGS(na+1) /* load register arguments */

           ___JUMPPRM(___SET_NARGS(na+1),
                      ___PRMCELL(___G__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary.prm))
         }

#endif

       i = k;
     }

   j = k - i;

   /*
    * here,
    *  i = number of arguments to move to the rest parameter
    *  j = number of non-required and non-optional arguments
    *      that are left after the rest parameter is created.
    */

   rest_param_list = ___NUL;

   while (i > 0)
     {
       rest_param_list = ___CONS(___POP,rest_param_list);
       i--;

       if (___hp > ___ps->heap_limit)
         {
            ___BOOL need_to_gc;

            ___COVER_KEYWORD_REST_PARAM_HANDLER_HEAP_LIMIT;

            ___W_ALL
            need_to_gc = ___heap_limit (___PSPNC);
            ___R_ALL

            if (need_to_gc)
              {
                /*
                 * We need to garbage collect, but before we do we have
                 * to remove all arguments from the stack so that the GC
                 * only sees complete continuation frames on the stack.
                 * The arguments are stored in a heap allocated vector.
                 */

                ___COVER_KEYWORD_REST_PARAM_HANDLER_NEED_TO_GC;

                /* Finish creating the rest parameter. */

                while (i > 0)
                  {
                    rest_param_list = ___CONS(___POP,rest_param_list);
                    i--;
                  }

                ___ADJFP(-j)

                for (i=0; i<nb_key; i++) /*push value of all keyword params*/
                  ___PUSH(key_vals[i])

                ___BEGIN_ALLOC_VECTOR(np)
                i = np - 1;
                ___ADD_VECTOR_ELEM(i,rest_param_list)
                while (i > 0)
                  {
                    i--;
                    ___ADD_VECTOR_ELEM(i,___POP)
                  }
                ___END_ALLOC_VECTOR(np)

                ___PUSH_ARGS2(___ps->temp1,___GET_VECTOR(np))

                ___JUMPPRM(___SET_NARGS(2),
                           ___PRMCELL(___G__23__23_rest_2d_param_2d_check_2d_heap.prm))
              }
          }
     }

   ___ADJFP(-j)

   ___COVER_KEYWORD_REST_PARAM_HANDLER_NO_NEED_TO_GC;

   for (i=0; i<nb_key; i++) /* push value of all keyword params */
     ___PUSH(key_vals[i])

   ___PUSH(rest_param_list) /* rest parameter is last */

   ___POP_ARGS_IN_REGS(np) /* load register arguments */

   ___JUMPEXTPRM(___SET_NARGS(-1),___ps->temp1)

}
#undef ___ARG1
   ___SET_R0(___LBL(10))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(10,___L10__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(10)
    *
    * This is the force handler.  It is invoked when a promise is forced.
    */

   ___SCMOBJ ra;
   ___SCMOBJ promise;
   ___SCMOBJ result;

   ra = ___ps->temp1;
   promise = ___ps->temp2;
   result = ___FIELD(promise,___PROMISE_RESULT);

   if (promise != result)
     {
       /* promise is determined, return cached result */

       ___COVER_FORCE_HANDLER_DETERMINED;

       ___ps->temp2 = result;
       ___JUMPEXTPRM(___NOTHING,ra)
     }
   else
     {
       /* promise is not determined */

       /* setup internal return continuation frame */

       int fs;

       ___RETI_GET_CFS(ra,fs)

       ___ADJFP(___ROUND_TO_MULT(fs,___FRAME_ALIGN)-fs)

       ___PUSH_REGS /* push all GVM registers (live or not) */
       ___PUSH(ra)  /* push return address */

       ___ADJFP(-___RETI_RA)

       ___SET_R0(___GSTATE->internal_return)

       /* tail call to ##force-undetermined */

       ___PUSH_ARGS2(promise,___FIELD(promise,___PROMISE_THUNK))

       ___COVER_FORCE_HANDLER_NOT_DETERMINED;

       ___JUMPPRM(___SET_NARGS(2),
                  ___PRMCELL(___G__23__23_force_2d_undetermined.prm))
     }

}
#undef ___ARG1
   ___SET_R1(___FIX(0L))
   ___SET_STK(-2,___R1)
   ___SET_R0(___LBL(11))
   ___ADJFP(4)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(11,___L11__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

     /*
      * ___LBL(11)
      *
      * This is the return to C handler.  It is invoked when control
      * must return to C (i.e. back from the call to ___call).
      *
      * Note that the continuation frame is not removed from the stack (it
      * contains the stack marker which is needed by ___call).
      */

     ___SCMOBJ unwind_destination = ___STK(2-___FRAME_SPACE(2));

#ifndef ___SINGLE_THREADED_VMS

     if (!___FIXEQ(___FIELD(unwind_destination,1),
                   ___FIX(___PROCESSOR_ID(___ps,___VMSTATE_FROM_PSTATE(___ps)))))
       {
         /* not the same processor that created frame */
         ___COVER_RETURN_TO_C_HANDLER_WRONG_PROCESSOR;
         ___SET_R0(___GSTATE->handler_return_to_c)
         ___SET_R1(___FIELD(unwind_destination,1))
         ___JUMPPRM(___SET_NARGS(1),
                    ___PRMCELL(___G__23__23_c_2d_return_2d_on_2d_other_2d_processor.prm))
       }
     else

#endif

     if (___FALSEP(___FIELD(unwind_destination,0)))
       {
         /* not first return */
         ___COVER_RETURN_TO_C_HANDLER_MULTIPLE_RETURN;
         ___SET_R0(___GSTATE->handler_return_to_c)
         ___JUMPPRM(___SET_NARGS(0),
                    ___PRMCELL(___G__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception.prm))
       }
     else
       {
         ___COVER_RETURN_TO_C_HANDLER_FIRST_RETURN;
         ___FRAME_STORE_RA(___GSTATE->handler_return_to_c)
         ___W_ALL
         ___throw_error (___PSP ___FIX(___UNWIND_C_STACK));  /* jump back inside ___call */
       }

}
#undef ___ARG1
   ___SET_R0(___LBL(12))
   ___ADJFP(-4)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(12,___L12__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(12)
    *
    * This is the break handler.  It is invoked when a procedure
    * attempts to return to its caller and the caller's stack frame
    * is not on top of the stack because it has been captured or
    * the frame was created following a stack section overflow.
    *
    * At this point the callee will have cleaned up the stack so that the
    * frame pointer (___fp) points to the break frame.  The break frame
    * contains a pointer to the caller's continuation frame, which
    * contains the address in the caller where control will return (the
    * return address ret_adr1).  The caller's continuation frame can either
    * be in the stack or in the heap.  The two situations are depicted below:
    *
    *              STACK                      STACK              HEAP
    *          |            |             |            |               caller's
    *          +------------+             +------------+    +------------+frame
    *  ___fp ->| call frame ---+  ___fp ->| call frame ---->|    HEAD    |
    *          |<ALIGN PAD> |  |          |<ALIGN PAD> |    |  ret_adr1  |
    *          +------------+  |          +------------+    |  slot fs   |
    *          |     .      |  |          |     .      |    |    ...     |
    *          |     .      |  |          |     .      |    | slot link ----+
    *          |     .      |  |          |     .      |    |    ...     |  |
    *          |     .      |  |          |     .      |    |  slot 1    |  |
    *          +------------+  |          |            |    +------------+  |
    *          |  ret_adr1  |<-+          |            |                    |
    *          |  RESERVED  |             |            |                    |
    * caller's |  slot fs   |             |            |                    |
    * frame    |    ...     |             |            |                    |
    *          |  ret_adr2  |             |            |                    |
    *          |    ...     |             |            |                    |
    *          |  slot 1    |             |     .      |    +------------+  |
    *          +------------+             |     .      |    |    HEAD    |<-+
    *          |  RESERVED  |             |     .      |    |  ret_adr2  |
    *          |    ...     |             |     .      |    |    ...    ----+
    *          +------------+             +------------+    +------------+  V
    *                                                                      ...
    *
    * These cases are distinguished by the tag on the pointer to the
    * caller's frame (i.e. 'call frame').
    *
    * If the break frame was created following a stack section overflow
    * it will be the first of a new stack section.  In this case the break
    * handler simply sets the stack pointer to the caller's frame and
    * resumes execution at the return address in the caller's frame.
    *
    * Otherwise, the break handler puts a copy of the caller's frame on
    * the top of the stack except that the slot 'link' is set to the
    * address of the break handler.  The frame pointer in the break frame
    * is modified so that it points to the frame of the caller's caller.
    * Finally a jump to the return address in the caller's frame (ret_adr1)
    * is performed.  At that point the stack will be in the following state
    * respectively:
    *
    *              STACK                      STACK              HEAP
    *          |            |             |            |
    *          +------------+             +------------+
    *  ___fp ->|  RESERVED  |     ___fp ->|  RESERVED  | ^
    *          |  slot fs   |             |  slot fs   | |
    *          |    ...     |             |    ...     | | ADDED BY BREAK
    *          | break hdlr |             | break hdlr | | HANDLER
    *          |    ...     |             |    ...     | |
    *          |  slot 1    |             |  slot 1    | v
    *          +------------+             +------------+
    *          |new call fr.---+          |new call fr.--+  +------------+
    *          |<ALIGN PAD> |  |          |<ALIGN PAD> | |  |    HEAD    |
    *          +------------+  |          +------------+ |  |  ret_adr1  |
    *          |     .      |  |          |     .      | |  |  slot fs   |
    *          |     .      |  |          |     .      | |  |    ...     |
    *          |     .      |  |          |     .      | |  | slot link ----+
    *          |     .      |  |          |     .      | |  |    ...     |  |
    *          +------------+  |          |            | |  |  slot 1    |  |
    *          |  ret_adr1  |  |          |            | |  +------------+  |
    *          |  RESERVED  |  |          |            | |                  |
    *          |  slot fs   |  |          |            | |                  |
    *          |    ...     |  |          |            | |                  |
    *          |  ret_adr2  |  |          |            | |                  |
    *          |    ...     |  |          |            | |                  |
    *          |  slot 1    |  |          |     .      | |  +------------+  |
    *          +------------+  |          |     .      | +->|    HEAD    |<-+
    *          |  ret_adr2  |<-+          |     .      |    |  ret_adr2  |
    *          |    ...     | (see note)  |     .      |    |    ...    ----+
    *          +------------+             +------------+    +------------+  V
    *                                                                      ...
    *
    * Note that in the first case, the pointer to the caller's frame is
    * normally advanced to the frame following the caller's frame and the
    * return address ret_adr2 is saved in it.  However, if the frame
    * following the caller's frame is a break frame, then the content of
    * that break frame is copied to the topmost break frame.  This
    * ensures that break frames never contain pointers to other break
    * frames which is needed to properly implement tail-calls.
    */

   int fs;
   int link;
   int i;
   ___SCMOBJ *fp;
   ___SCMOBJ ra1;
   ___SCMOBJ ra2;
   ___SCMOBJ cf;

   cf = ___STK(-___BREAK_FRAME_NEXT); /* pointer to caller's frame */

   if (___TYP(cf) != ___tSUBTYPED)
     {
       /* caller's frame is in the stack */

       /* cf can't be equal to the end of continuation marker */

       fp = ___CAST(___SCMOBJ*,cf);

       ___W_FP
       ra1 = ___stack_overflow_undo_if_possible (___PSPNC);
       ___R_FP

       if (ra1 == ___FAL)
         {
           /*
            * The caller's frame must be copied to the top of stack.
            */

           ra1 = ___FP_STK(fp,-___FRAME_STACK_RA);

           if (ra1 == ___GSTATE->internal_return)
             {
               ___SCMOBJ actual_ra = ___FP_STK(fp,___RETI_RA);
               ___RETI_GET_FS_LINK(actual_ra,fs,link)
               ___COVER_BREAK_HANDLER_STACK_RETI;
             }
           else
             {
               ___RETN_GET_FS_LINK(ra1,fs,link)
               ___COVER_BREAK_HANDLER_STACK_RETN;
             }

           ___FP_ADJFP(fp,-___FRAME_SPACE(fs)); /* get base of frame */

           for (i=fs; i>0; i--)
             ___SET_STK(i,___FP_STK(fp,i))

           ra2 = ___STK(link+1);

           if (ra2 == ___GSTATE->handler_break)
             {
               /* first frame of that section */

               ___COVER_BREAK_HANDLER_STACK_FIRST_FRAME;
               ___SET_STK(-___BREAK_FRAME_NEXT,
                          ___FP_STK(fp,-___BREAK_FRAME_NEXT))
             }
           else
             {
               /* not the first frame of that section */

               ___COVER_BREAK_HANDLER_STACK_NOT_FIRST_FRAME;

               ___FP_SET_STK(fp,-___FRAME_STACK_RA,ra2)
               ___SET_STK(-___BREAK_FRAME_NEXT,___CAST(___SCMOBJ,fp))
               ___SET_STK(link+1,___GSTATE->handler_break)
             }

           ___ADJFP(___FRAME_SPACE(fs))
         }
     }
   else
     {
       /* caller's frame is in the heap */

       fp = ___BODY_AS(cf,___tSUBTYPED); /* get pointer to frame's body */

       ra1 = fp[___FRAME_RA];

       if (ra1 == ___GSTATE->internal_return)
         {
           ___SCMOBJ actual_ra = fp[___FRAME_RETI_RA];
           ___RETI_GET_FS_LINK(actual_ra,fs,link)
           ___COVER_BREAK_HANDLER_HEAP_RETI;
         }
       else
         {
           ___RETN_GET_FS_LINK(ra1,fs,link)
           ___COVER_BREAK_HANDLER_HEAP_RETN;
         }

       fp += fs+1; /* get base of frame */

       for (i=fs; i>0; i--)
         ___SET_STK(i,___FP_STK(fp,i))

       ___SET_STK(-___BREAK_FRAME_NEXT,___STK(link+1))
       ___SET_STK(link+1,___GSTATE->handler_break)

       ___ADJFP(___FRAME_SPACE(fs))
     }

   ___JUMPEXTPRM(___NOTHING,ra1)

}
#undef ___ARG1
   ___SET_R0(___LBL(13))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___FIX(0L))
___DEF_SLBL(13,___L13__23__23_kernel_2d_handlers)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   /*
    * ___LBL(13)
    *
    * This is the internal return handler.  It is invoked when an
    * internal return point is returned to.
    *
    * Internal return points are used by the compiler when some routine
    * (e.g.  garbage collector) has to be called but it would be space
    * inefficient to generate the code to construct a normal continuation
    * frame (all the live GVM registers would have to be pushed on the
    * stack).  With internal return points it is not necessary for the
    * caller to save the live GVM registers before the routine is called,
    * and restore the GVM registers when the routine returns.  Instead it
    * is the called routine which saves and restores all the registers.
    *
    * The continuation frame for an internal return point has this layout:
    *
    *              STACK
    *          |            |
    *          +------------+
    *  ___fp ->|  RESERVED  | ^ <-- added to make stack and heap length equal
    *          |<ALIGN PAD> | | <-- words added for alignment of frame
    *          |  ret_adr   | | <-- internal return address (back to caller)
    *          | GVM reg N  | | ADDED BY ROUTINE
    *          |    ...     | |
    *          | GVM reg 0  | |
    *          |<ALIGN PAD> | v <-- to force known offset from ___fp to ret_adr
    *          |  slot fs   | ^
    *          |    ...     | | PUT ON STACK BY CALLER OF ROUTINE
    *          |  slot 1    | v
    *          +------------+
    *          |    ...     |
    */

   int fs;
   ___SCMOBJ ira;

   /* save result in case we are returning from ##force-undetermined */

   ___ps->temp2 = ___R1;

   /* make ___fp point to internal return address */

   ___ADJFP(___RETI_RA)

   /* pop return address and all GVM registers */

   ira = ___POP;
   ___POP_REGS

   /* get number of slots put on stack by caller */

   ___RETI_GET_CFS(ira,fs)

   /* adjust ___fp so that slot fs is on top of stack */

   ___ADJFP(fs-___ROUND_TO_MULT(fs,___FRAME_ALIGN))

   /* jump to internal return point */

   ___COVER_INTERNAL_RETURN_HANDLER_END;

   ___JUMPEXTPRM(___NOTHING,ira)

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_dynamic_2d_env_2d_bind
#undef ___PH_LBL0
#define ___PH_LBL0 44
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_dynamic_2d_env_2d_bind)
___DEF_P_HLBL(___L1__23__23_dynamic_2d_env_2d_bind)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_dynamic_2d_env_2d_bind)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_dynamic_2d_env_2d_bind)
   ___SET_R3(___CURRENTTHREAD)
   ___SET_R4(___UNCHECKEDSTRUCTUREREF(___R3,___FIX(24L),___SUB(2),___FAL))
   ___UNCHECKEDSTRUCTURESET(___R3,___R1,___FIX(24L),___SUB(2),___FAL)
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R1(___VECTORREF(___R1,___FIX(0L)))
   ___UNCHECKEDSTRUCTURESET(___R3,___R1,___FIX(25L),___SUB(2),___FAL)
   ___UNCHECKEDSTRUCTURESET(___R3,___R1,___FIX(26L),___SUB(2),___FAL)
   ___UNCHECKEDSTRUCTURESET(___R3,___R1,___FIX(27L),___SUB(2),___FAL)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R4)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R2)
___DEF_SLBL(1,___L1__23__23_dynamic_2d_env_2d_bind)
   ___SET_R2(___CURRENTTHREAD)
   ___UNCHECKEDSTRUCTURESET(___R2,___STK(-6),___FIX(24L),___SUB(2),___FAL)
   ___SET_R3(___VECTORREF(___STK(-6),___FIX(0L)))
   ___SET_R3(___VECTORREF(___R3,___FIX(0L)))
   ___UNCHECKEDSTRUCTURESET(___R2,___R3,___FIX(25L),___SUB(2),___FAL)
   ___UNCHECKEDSTRUCTURESET(___R2,___R3,___FIX(26L),___SUB(2),___FAL)
   ___UNCHECKEDSTRUCTURESET(___R2,___R3,___FIX(27L),___SUB(2),___FAL)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_assq_2d_cdr
#undef ___PH_LBL0
#define ___PH_LBL0 47
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_assq_2d_cdr)
___DEF_P_HLBL(___L1__23__23_assq_2d_cdr)
___DEF_P_HLBL(___L2__23__23_assq_2d_cdr)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_assq_2d_cdr)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_assq_2d_cdr)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_assq_2d_cdr)
   ___GOTO(___L4__23__23_assq_2d_cdr)
___DEF_GLBL(___L3__23__23_assq_2d_cdr)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CDR(___R3))
   ___IF(___EQP(___R1,___R4))
   ___GOTO(___L5__23__23_assq_2d_cdr)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_assq_2d_cdr)
___DEF_GLBL(___L4__23__23_assq_2d_cdr)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L3__23__23_assq_2d_cdr)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L5__23__23_assq_2d_cdr)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_assq
#undef ___PH_LBL0
#define ___PH_LBL0 51
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_assq)
___DEF_P_HLBL(___L1__23__23_assq)
___DEF_P_HLBL(___L2__23__23_assq)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_assq)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_assq)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_assq)
   ___GOTO(___L4__23__23_assq)
___DEF_GLBL(___L3__23__23_assq)
   ___SET_R3(___CAR(___R2))
   ___SET_R4(___CAR(___R3))
   ___IF(___EQP(___R1,___R4))
   ___GOTO(___L5__23__23_assq)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_assq)
___DEF_GLBL(___L4__23__23_assq)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L3__23__23_assq)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L5__23__23_assq)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_disable_2d_interrupts_21_
#undef ___PH_LBL0
#define ___PH_LBL0 55
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_disable_2d_interrupts_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_disable_2d_interrupts_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_disable_2d_interrupts_21_)
{ ___SCMOBJ ___RESULT;
___EXT(___disable_interrupts_pstate) (___ps); ___RESULT = ___VOID;
   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_enable_2d_interrupts_21_
#undef ___PH_LBL0
#define ___PH_LBL0 57
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_enable_2d_interrupts_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_enable_2d_interrupts_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_enable_2d_interrupts_21_)
{ ___SCMOBJ ___RESULT;
___EXT(___enable_interrupts_pstate) (___ps); ___RESULT = ___VOID;
   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_sync_2d_op_2d_interrupt_21_
#undef ___PH_LBL0
#define ___PH_LBL0 59
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_sync_2d_op_2d_interrupt_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_sync_2d_op_2d_interrupt_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_sync_2d_op_2d_interrupt_21_)
{ ___SCMOBJ ___RESULT;

   ___FRAME_STORE_RA(___R0)
   ___W_ALL

   service_sync_op (___PSPNC);

   ___R_ALL
   ___SET_R0(___FRAME_FETCH_RA)

   ___RESULT = ___VOID;

   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_interrupt_2d_handler
#undef ___PH_LBL0
#define ___PH_LBL0 61
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_interrupt_2d_handler)
___DEF_P_HLBL(___L1__23__23_interrupt_2d_handler)
___DEF_P_HLBL(___L2__23__23_interrupt_2d_handler)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_interrupt_2d_handler)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_interrupt_2d_handler)
   ___GOTO(___L3__23__23_interrupt_2d_handler)
___DEF_SLBL(1,___L1__23__23_interrupt_2d_handler)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
___DEF_GLBL(___L3__23__23_interrupt_2d_handler)
{ ___SCMOBJ ___RESULT;

            ___RESULT = ___FAL;

            ___EXT(___begin_interrupt_service_pstate) (___ps);

            if (___ps->intr_enabled != ___FIX(0))
              {
                int i;

                for (i=0; i<___NB_INTRS; i++)
                  if (___EXT(___check_interrupt_pstate) (___ps, i))
                    break;

                ___EXT(___end_interrupt_service_pstate) (___ps, i+1);

                if (i < ___NB_INTRS)
                  ___RESULT = ___FIX(i);
              }
            else
              ___EXT(___end_interrupt_service_pstate) (___ps, 0);

   ___SET_R1(___RESULT)
}
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L7__23__23_interrupt_2d_handler)
   ___END_IF
   ___SET_R1(___VECTORREF(___GLO__23__23_interrupt_2d_vector,___R1))
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L6__23__23_interrupt_2d_handler)
   ___END_IF
___DEF_GLBL(___L4__23__23_interrupt_2d_handler)
{ ___SCMOBJ ___RESULT;
___RESULT = ___BOOLEAN(___STACK_TRIPPED);
   ___SET_R2(___RESULT)
}
   ___IF(___NOT(___NOTFALSEP(___R2)))
   ___GOTO(___L5__23__23_interrupt_2d_handler)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___DEF_GLBL(___L5__23__23_interrupt_2d_handler)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___DEF_GLBL(___L6__23__23_interrupt_2d_handler)
   ___SET_R1(___LBL(2))
   ___GOTO(___L4__23__23_interrupt_2d_handler)
___DEF_SLBL(2,___L2__23__23_interrupt_2d_handler)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(2,0,0,0)
___DEF_GLBL(___L7__23__23_interrupt_2d_handler)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_interrupt_2d_vector_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 65
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_interrupt_2d_vector_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_interrupt_2d_vector_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_interrupt_2d_vector_2d_set_21_)
   ___VECTORSET(___GLO__23__23_interrupt_2d_vector,___R1,___R2) ___SET_R1(___GLO__23__23_interrupt_2d_vector)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_get_2d_heartbeat_2d_interval_21_
#undef ___PH_LBL0
#define ___PH_LBL0 67
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_get_2d_heartbeat_2d_interval_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_get_2d_heartbeat_2d_interval_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_get_2d_heartbeat_2d_interval_21_)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

   ___F64VECTORSET(___ARG1,
                   ___ARG2,
                   ___get_heartbeat_interval ());

   ___RESULT = ___VOID;

   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_set_2d_heartbeat_2d_interval_21_
#undef ___PH_LBL0
#define ___PH_LBL0 69
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_set_2d_heartbeat_2d_interval_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_set_2d_heartbeat_2d_interval_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_set_2d_heartbeat_2d_interval_21_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   ___set_heartbeat_interval (___FLONUM_VAL(___ARG1));

   ___RESULT = ___VOID;

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_high_2d_level_2d_interrupt_21_
#undef ___PH_LBL0
#define ___PH_LBL0 71
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_high_2d_level_2d_interrupt_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_high_2d_level_2d_interrupt_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_raise_2d_high_2d_level_2d_interrupt_21_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   {
     ___processor_state ps =
       ___PSTATE_FROM_PROCESSOR_ID(___INT(___ARG1),
                                   ___VMSTATE_FROM_PSTATE(___ps));

     ___raise_interrupt_pstate (ps, ___INTR_HIGH_LEVEL);

     ___RESULT = ___VOID;
   }

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_argument_2d_list_2d_remove_2d_absent_21_
#undef ___PH_LBL0
#define ___PH_LBL0 73
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___DEF_P_HLBL(___L1__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___DEF_P_HLBL(___L2__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___DEF_P_HLBL(___L3__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___SET_STK(1,___R2)
   ___SET_R3(___R1)
   ___SET_R1(___R2)
   ___SET_R2(___FAL)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___GOTO(___L6__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___DEF_GLBL(___L4__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___SET_R4(___CAR(___R3))
   ___IF(___EQP(___R4,___ABSENT))
   ___GOTO(___L8__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___END_IF
   ___IF(___NOTFALSEP(___R2))
   ___GOTO(___L9__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___END_IF
   ___SET_R1(___R3)
___DEF_GLBL(___L5__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___SET_R2(___CDR(___R3))
   ___SET_STK(1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___STK(1))
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___DEF_GLBL(___L6__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L4__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___END_IF
   ___IF(___NOT(___NOTFALSEP(___R2)))
   ___GOTO(___L7__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___END_IF
   ___SETCDR(___R2,___STK(0))
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L7__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L8__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___SET_R3(___CDR(___R3))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___GOTO(___L6__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___DEF_GLBL(___L9__23__23_argument_2d_list_2d_remove_2d_absent_21_)
   ___SETCDR(___R2,___R3)
   ___GOTO(___L5__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_
#undef ___PH_LBL0
#define ___PH_LBL0 78
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___DEF_P_HLBL(___L1__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___DEF_P_HLBL(___L2__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___DEF_P_HLBL(___L3__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___GOTO(___L6__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___DEF_GLBL(___L4__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___SET_R4(___CAR(___R3))
   ___IF(___NOT(___KEYWORDP(___R4)))
   ___GOTO(___L7__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___END_IF
   ___SET_R4(___CADR(___R3))
   ___IF(___EQP(___R4,___ABSENT))
   ___GOTO(___L11__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___END_IF
   ___IF(___NOTFALSEP(___R2))
   ___GOTO(___L12__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___END_IF
   ___SET_R1(___R3)
___DEF_GLBL(___L5__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___SET_R2(___CDDR(___R3))
   ___SET_STK(1,___R3)
   ___SET_R3(___R2)
   ___SET_R2(___CDR(___STK(1)))
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___DEF_GLBL(___L6__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___IF(___PAIRP(___R3))
   ___GOTO(___L4__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___END_IF
___DEF_GLBL(___L7__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L9__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___END_IF
   ___SET_R3(___CAR(___R3))
   ___IF(___NOT(___NOTFALSEP(___R2)))
   ___GOTO(___L10__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___END_IF
___DEF_GLBL(___L8__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___SETCDR(___R2,___R3)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L9__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___SET_R3(___NUL)
   ___IF(___NOTFALSEP(___R2))
   ___GOTO(___L8__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___END_IF
___DEF_GLBL(___L10__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L11__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___SET_R3(___CDDR(___R3))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___GOTO(___L6__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___DEF_GLBL(___L12__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
   ___SETCDR(___R2,___R3)
   ___GOTO(___L5__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_
#undef ___PH_LBL0
#define ___PH_LBL0 83
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
___DEF_P_HLBL(___L1__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
___DEF_P_HLBL(___L2__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
   ___SET_R3(___R1)
   ___SET_R2(___FAL)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
   ___GOTO(___L4__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
___DEF_GLBL(___L3__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
   ___SET_STK(1,___R3)
   ___SET_R3(___R4)
   ___SET_R2(___STK(1))
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
___DEF_GLBL(___L4__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
   ___SET_R4(___CDR(___R3))
   ___IF(___PAIRP(___R4))
   ___GOTO(___L3__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
   ___END_IF
   ___IF(___NOT(___NOTFALSEP(___R2)))
   ___GOTO(___L5__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
   ___END_IF
   ___SET_R3(___CAR(___R3))
   ___SETCDR(___R2,___R3)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L5__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
   ___SET_R1(___CAR(___R3))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_extract_2d_procedure_2d_and_2d_arguments
#undef ___PH_LBL0
#define ___PH_LBL0 87
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_P_HLBL(___L1__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_P_HLBL(___L2__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_P_HLBL(___L3__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_P_HLBL(___L4__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_P_HLBL(___L5__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_P_HLBL(___L6__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_P_HLBL(___L7__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_P_HLBL(___L8__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_P_HLBL(___L9__23__23_extract_2d_procedure_2d_and_2d_arguments)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___IF(___NOT(___NULLP(___STK(-2))))
   ___GOTO(___L10__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___END_IF
   ___SET_STK(-2,___CAR(___STK(-1)))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___CDR(___STK(-1)))
   ___ADJFP(9)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(83),___L__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_)
___DEF_SLBL(2,___L2__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___SET_R2(___NUL)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(73),___L__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___DEF_SLBL(3,___L3__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___SET_STK(-10,___R1)
   ___SET_R3(___STK(-6))
   ___SET_R2(___STK(-7))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-8))
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___ADJFP(-10)
   ___JUMPGENNOTSAFE(___SET_NARGS(5),___STK(5))
___DEF_GLBL(___L10__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___IF(___NOT(___PAIRP(___STK(-2))))
   ___GOTO(___L11__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___END_IF
   ___SET_R4(___CAR(___STK(-2)))
   ___SET_STK(1,___STK(-2))
   ___SET_STK(-2,___R4)
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R1(___CDR(___STK(1)))
   ___ADJFP(9)
   ___POLL(5)
___DEF_SLBL(5,___L5__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___SET_R0(___LBL(6))
   ___JUMPINT(___SET_NARGS(1),___PRC(78),___L__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_)
___DEF_SLBL(6,___L6__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-10))
   ___SET_R0(___LBL(7))
   ___JUMPINT(___SET_NARGS(2),___PRC(73),___L__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___DEF_SLBL(7,___L7__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___SET_STK(-10,___R1)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R1(___STK(-9))
   ___SET_R0(___STK(-7))
   ___POLL(8)
___DEF_SLBL(8,___L8__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___ADJFP(-10)
   ___JUMPGENNOTSAFE(___SET_NARGS(5),___STK(6))
___DEF_GLBL(___L11__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R1(___STK(-1))
   ___SET_R2(___NUL)
   ___ADJFP(9)
   ___POLL(9)
___DEF_SLBL(9,___L9__23__23_extract_2d_procedure_2d_and_2d_arguments)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(73),___L__23__23_argument_2d_list_2d_remove_2d_absent_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_type_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 98
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_type_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_type_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_type_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_type_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(6))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_type_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_type_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 101
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_type_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_type_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_type_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_cf06eccd_2d_bf2c_2d_4b30_2d_a6ce_2d_394b345a0dee)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_type_2d_exception_2d_procedure
#undef ___PH_LBL0
#define ___PH_LBL0 103
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_type_2d_exception_2d_procedure)
___DEF_P_HLBL(___L1_type_2d_exception_2d_procedure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_type_2d_exception_2d_procedure)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_type_2d_exception_2d_procedure)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_cf06eccd_2d_bf2c_2d_4b30_2d_a6ce_2d_394b345a0dee))
   ___GOTO(___L2_type_2d_exception_2d_procedure)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_type_2d_exception_2d_procedure)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(98),___L0__23__23_fail_2d_check_2d_type_2d_exception)
___DEF_GLBL(___L2_type_2d_exception_2d_procedure)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(6),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_type_2d_exception_2d_arguments
#undef ___PH_LBL0
#define ___PH_LBL0 106
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_type_2d_exception_2d_arguments)
___DEF_P_HLBL(___L1_type_2d_exception_2d_arguments)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_type_2d_exception_2d_arguments)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_type_2d_exception_2d_arguments)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_cf06eccd_2d_bf2c_2d_4b30_2d_a6ce_2d_394b345a0dee))
   ___GOTO(___L2_type_2d_exception_2d_arguments)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_type_2d_exception_2d_arguments)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(98),___L0__23__23_fail_2d_check_2d_type_2d_exception)
___DEF_GLBL(___L2_type_2d_exception_2d_arguments)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(2L),___SUB(6),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_type_2d_exception_2d_arg_2d_num
#undef ___PH_LBL0
#define ___PH_LBL0 109
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_type_2d_exception_2d_arg_2d_num)
___DEF_P_HLBL(___L1_type_2d_exception_2d_arg_2d_num)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_type_2d_exception_2d_arg_2d_num)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_type_2d_exception_2d_arg_2d_num)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_cf06eccd_2d_bf2c_2d_4b30_2d_a6ce_2d_394b345a0dee))
   ___GOTO(___L2_type_2d_exception_2d_arg_2d_num)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_type_2d_exception_2d_arg_2d_num)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(98),___L0__23__23_fail_2d_check_2d_type_2d_exception)
___DEF_GLBL(___L2_type_2d_exception_2d_arg_2d_num)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(3L),___SUB(6),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_type_2d_exception_2d_type_2d_id
#undef ___PH_LBL0
#define ___PH_LBL0 112
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_type_2d_exception_2d_type_2d_id)
___DEF_P_HLBL(___L1_type_2d_exception_2d_type_2d_id)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_type_2d_exception_2d_type_2d_id)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_type_2d_exception_2d_type_2d_id)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_cf06eccd_2d_bf2c_2d_4b30_2d_a6ce_2d_394b345a0dee))
   ___GOTO(___L2_type_2d_exception_2d_type_2d_id)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_type_2d_exception_2d_type_2d_id)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(98),___L0__23__23_fail_2d_check_2d_type_2d_exception)
___DEF_GLBL(___L2_type_2d_exception_2d_type_2d_id)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(4L),___SUB(6),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_type_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 115
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_type_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_type_2d_exception)
___DEF_P_HLBL(___L2__23__23_raise_2d_type_2d_exception)
___DEF_P_HLBL(___L3__23__23_raise_2d_type_2d_exception)
___DEF_P_HLBL(___L4__23__23_raise_2d_type_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_type_2d_exception)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L__23__23_raise_2d_type_2d_exception)
   ___SET_STK(1,___STK(0))
   ___SET_STK(0,___R2)
   ___SET_STK(2,___STK(1))
   ___SET_STK(1,___R3)
   ___SET_R3(___LBL(2))
   ___SET_R2(___FAL)
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_raise_2d_type_2d_exception)
   ___JUMPINT(___SET_NARGS(6),___PRC(87),___L__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_SLBL(2,___L2__23__23_raise_2d_type_2d_exception)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(2,5,0,0)
   ___BEGIN_ALLOC_STRUCTURE(5UL)
   ___ADD_STRUCTURE_ELEM(0,___SUB(6))
   ___ADD_STRUCTURE_ELEM(1,___STK(-1))
   ___ADD_STRUCTURE_ELEM(2,___STK(0))
   ___ADD_STRUCTURE_ELEM(3,___R1)
   ___ADD_STRUCTURE_ELEM(4,___R2)
   ___END_ALLOC_STRUCTURE(5)
   ___SET_R1(___GET_STRUCTURE(5))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3__23__23_raise_2d_type_2d_exception)
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_raise_2d_type_2d_exception)
   ___ADJFP(-2)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 121
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(10))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_heap_2d_overflow_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 124
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_heap_2d_overflow_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_heap_2d_overflow_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_heap_2d_overflow_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_0_2d_d69cd396_2d_01e0_2d_4dcb_2d_87dc_2d_31acea8e0e5f)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_heap_2d_overflow_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 126
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_P_HLBL(___L2__23__23_raise_2d_heap_2d_overflow_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_heap_2d_overflow_2d_exception)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
   ___SET_R1(___LBL(1))
   ___JUMPINT(___SET_NARGS(1),___PRC(764),___L__23__23_with_2d_no_2d_result_2d_expected)
___DEF_SLBL(1,___L1__23__23_raise_2d_heap_2d_overflow_2d_exception)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(1,0,0,0)
   ___SET_R1(___SUB(12))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_raise_2d_heap_2d_overflow_2d_exception)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 130
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(13))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_stack_2d_overflow_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 133
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_stack_2d_overflow_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_stack_2d_overflow_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_stack_2d_overflow_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_0_2d_f512c9f6_2d_3b24_2d_4c5c_2d_8c8b_2d_cabd75b2f951)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_stack_2d_overflow_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 135
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_stack_2d_overflow_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_stack_2d_overflow_2d_exception)
___DEF_P_HLBL(___L2__23__23_raise_2d_stack_2d_overflow_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_stack_2d_overflow_2d_exception)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_raise_2d_stack_2d_overflow_2d_exception)
   ___SET_R1(___LBL(1))
   ___JUMPINT(___SET_NARGS(1),___PRC(764),___L__23__23_with_2d_no_2d_result_2d_expected)
___DEF_SLBL(1,___L1__23__23_raise_2d_stack_2d_overflow_2d_exception)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(1,0,0,0)
   ___SET_R1(___SUB(15))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_raise_2d_stack_2d_overflow_2d_exception)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 139
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(16))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_nonprocedure_2d_operator_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 142
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_nonprocedure_2d_operator_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_nonprocedure_2d_operator_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_nonprocedure_2d_operator_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_f39d07ce_2d_436d_2d_40ca_2d_b81f_2d_cdc65d16b7f2)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_nonprocedure_2d_operator_2d_exception_2d_operator
#undef ___PH_LBL0
#define ___PH_LBL0 144
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_nonprocedure_2d_operator_2d_exception_2d_operator)
___DEF_P_HLBL(___L1_nonprocedure_2d_operator_2d_exception_2d_operator)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_nonprocedure_2d_operator_2d_exception_2d_operator)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_nonprocedure_2d_operator_2d_exception_2d_operator)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_f39d07ce_2d_436d_2d_40ca_2d_b81f_2d_cdc65d16b7f2))
   ___GOTO(___L2_nonprocedure_2d_operator_2d_exception_2d_operator)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_nonprocedure_2d_operator_2d_exception_2d_operator)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(139),___L0__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
___DEF_GLBL(___L2_nonprocedure_2d_operator_2d_exception_2d_operator)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(16),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_nonprocedure_2d_operator_2d_exception_2d_arguments
#undef ___PH_LBL0
#define ___PH_LBL0 147
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_nonprocedure_2d_operator_2d_exception_2d_arguments)
___DEF_P_HLBL(___L1_nonprocedure_2d_operator_2d_exception_2d_arguments)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_nonprocedure_2d_operator_2d_exception_2d_arguments)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_nonprocedure_2d_operator_2d_exception_2d_arguments)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_f39d07ce_2d_436d_2d_40ca_2d_b81f_2d_cdc65d16b7f2))
   ___GOTO(___L2_nonprocedure_2d_operator_2d_exception_2d_arguments)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_nonprocedure_2d_operator_2d_exception_2d_arguments)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(139),___L0__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
___DEF_GLBL(___L2_nonprocedure_2d_operator_2d_exception_2d_arguments)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(2L),___SUB(16),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_nonprocedure_2d_operator_2d_exception_2d_code
#undef ___PH_LBL0
#define ___PH_LBL0 150
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_nonprocedure_2d_operator_2d_exception_2d_code)
___DEF_P_HLBL(___L1_nonprocedure_2d_operator_2d_exception_2d_code)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_nonprocedure_2d_operator_2d_exception_2d_code)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_nonprocedure_2d_operator_2d_exception_2d_code)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_f39d07ce_2d_436d_2d_40ca_2d_b81f_2d_cdc65d16b7f2))
   ___GOTO(___L2_nonprocedure_2d_operator_2d_exception_2d_code)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_nonprocedure_2d_operator_2d_exception_2d_code)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(139),___L0__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
___DEF_GLBL(___L2_nonprocedure_2d_operator_2d_exception_2d_code)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(3L),___SUB(16),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_nonprocedure_2d_operator_2d_exception_2d_rte
#undef ___PH_LBL0
#define ___PH_LBL0 153
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_nonprocedure_2d_operator_2d_exception_2d_rte)
___DEF_P_HLBL(___L1_nonprocedure_2d_operator_2d_exception_2d_rte)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_nonprocedure_2d_operator_2d_exception_2d_rte)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_nonprocedure_2d_operator_2d_exception_2d_rte)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_f39d07ce_2d_436d_2d_40ca_2d_b81f_2d_cdc65d16b7f2))
   ___GOTO(___L2_nonprocedure_2d_operator_2d_exception_2d_rte)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_nonprocedure_2d_operator_2d_exception_2d_rte)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(139),___L0__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception)
___DEF_GLBL(___L2_nonprocedure_2d_operator_2d_exception_2d_rte)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(4L),___SUB(16),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary
#undef ___PH_LBL0
#define ___PH_LBL0 156
#undef ___PD_ALL
#define ___PD_ALL ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary)
   ___SET_R1(___GLOBALVARREF(___R1))
   ___JUMPINT(___SET_NARGS(2),___PRC(160),___L__23__23_apply_2d_with_2d_procedure_2d_check)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary
#undef ___PH_LBL0
#define ___PH_LBL0 158
#undef ___PD_ALL
#define ___PD_ALL ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary)
   ___JUMPINT(___SET_NARGS(2),___PRC(160),___L__23__23_apply_2d_with_2d_procedure_2d_check)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_apply_2d_with_2d_procedure_2d_check
#undef ___PH_LBL0
#define ___PH_LBL0 160
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_apply_2d_with_2d_procedure_2d_check)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_apply_2d_with_2d_procedure_2d_check)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_apply_2d_with_2d_procedure_2d_check)
   ___IF(___PROCEDUREP(___R1))
   ___GOTO(___L1__23__23_apply_2d_with_2d_procedure_2d_check)
   ___END_IF
   ___SET_STK(1,___R1)
   ___SET_R1(___R2)
   ___SET_R3(___FAL)
   ___SET_R2(___FAL)
   ___ADJFP(1)
   ___JUMPINT(___SET_NARGS(4),___PRC(162),___L__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
___DEF_GLBL(___L1__23__23_apply_2d_with_2d_procedure_2d_check)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_apply)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_nonprocedure_2d_operator_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 162
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
___DEF_P_HLBL(___L2__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
   ___BEGIN_ALLOC_STRUCTURE(5UL)
   ___ADD_STRUCTURE_ELEM(0,___SUB(16))
   ___ADD_STRUCTURE_ELEM(1,___STK(0))
   ___ADD_STRUCTURE_ELEM(2,___R1)
   ___ADD_STRUCTURE_ELEM(3,___R2)
   ___ADD_STRUCTURE_ELEM(4,___R3)
   ___END_ALLOC_STRUCTURE(5)
   ___SET_R1(___GET_STRUCTURE(5))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_raise_2d_nonprocedure_2d_operator_2d_exception)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 166
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(18))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 169
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_2138cd7f_2d_8c42_2d_4164_2d_b56a_2d_a8c7badf3323)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure
#undef ___PH_LBL0
#define ___PH_LBL0 171
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
___DEF_P_HLBL(___L1_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_2138cd7f_2d_8c42_2d_4164_2d_b56a_2d_a8c7badf3323))
   ___GOTO(___L2_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(166),___L0__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___DEF_GLBL(___L2_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(18),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments
#undef ___PH_LBL0
#define ___PH_LBL0 174
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
___DEF_P_HLBL(___L1_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_2138cd7f_2d_8c42_2d_4164_2d_b56a_2d_a8c7badf3323))
   ___GOTO(___L2_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(166),___L0__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___DEF_GLBL(___L2_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(2L),___SUB(18),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary
#undef ___PH_LBL0
#define ___PH_LBL0 177
#undef ___PD_ALL
#define ___PD_ALL ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary)
   ___JUMPINT(___SET_NARGS(2),___PRC(179),___L__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 179
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___DEF_P_HLBL(___L2__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
   ___BEGIN_ALLOC_STRUCTURE(3UL)
   ___ADD_STRUCTURE_ELEM(0,___SUB(18))
   ___ADD_STRUCTURE_ELEM(1,___R1)
   ___ADD_STRUCTURE_ELEM(2,___R2)
   ___END_ALLOC_STRUCTURE(3)
   ___SET_R1(___GET_STRUCTURE(3))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 183
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(20))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_keyword_2d_expected_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 186
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_keyword_2d_expected_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_keyword_2d_expected_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_keyword_2d_expected_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_3fd6c57f_2d_3c80_2d_4436_2d_a430_2d_57ea4457c11e)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_keyword_2d_expected_2d_exception_2d_procedure
#undef ___PH_LBL0
#define ___PH_LBL0 188
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_keyword_2d_expected_2d_exception_2d_procedure)
___DEF_P_HLBL(___L1_keyword_2d_expected_2d_exception_2d_procedure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_keyword_2d_expected_2d_exception_2d_procedure)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_keyword_2d_expected_2d_exception_2d_procedure)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_3fd6c57f_2d_3c80_2d_4436_2d_a430_2d_57ea4457c11e))
   ___GOTO(___L2_keyword_2d_expected_2d_exception_2d_procedure)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_keyword_2d_expected_2d_exception_2d_procedure)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(183),___L0__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception)
___DEF_GLBL(___L2_keyword_2d_expected_2d_exception_2d_procedure)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(20),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_keyword_2d_expected_2d_exception_2d_arguments
#undef ___PH_LBL0
#define ___PH_LBL0 191
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_keyword_2d_expected_2d_exception_2d_arguments)
___DEF_P_HLBL(___L1_keyword_2d_expected_2d_exception_2d_arguments)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_keyword_2d_expected_2d_exception_2d_arguments)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_keyword_2d_expected_2d_exception_2d_arguments)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_3fd6c57f_2d_3c80_2d_4436_2d_a430_2d_57ea4457c11e))
   ___GOTO(___L2_keyword_2d_expected_2d_exception_2d_arguments)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_keyword_2d_expected_2d_exception_2d_arguments)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(183),___L0__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception)
___DEF_GLBL(___L2_keyword_2d_expected_2d_exception_2d_arguments)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(2L),___SUB(20),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary
#undef ___PH_LBL0
#define ___PH_LBL0 194
#undef ___PD_ALL
#define ___PD_ALL ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary)
   ___JUMPINT(___SET_NARGS(2),___PRC(196),___L__23__23_raise_2d_keyword_2d_expected_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_keyword_2d_expected_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 196
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_keyword_2d_expected_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_keyword_2d_expected_2d_exception)
___DEF_P_HLBL(___L2__23__23_raise_2d_keyword_2d_expected_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_keyword_2d_expected_2d_exception)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_raise_2d_keyword_2d_expected_2d_exception)
   ___BEGIN_ALLOC_STRUCTURE(3UL)
   ___ADD_STRUCTURE_ELEM(0,___SUB(20))
   ___ADD_STRUCTURE_ELEM(1,___R1)
   ___ADD_STRUCTURE_ELEM(2,___R2)
   ___END_ALLOC_STRUCTURE(3)
   ___SET_R1(___GET_STRUCTURE(3))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_raise_2d_keyword_2d_expected_2d_exception)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_raise_2d_keyword_2d_expected_2d_exception)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 200
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(22))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_unknown_2d_keyword_2d_argument_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 203
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_unknown_2d_keyword_2d_argument_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_unknown_2d_keyword_2d_argument_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_unknown_2d_keyword_2d_argument_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_3f9f8aaa_2d_ea21_2d_4f2b_2d_bc06_2d_f65950e6c408)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure
#undef ___PH_LBL0
#define ___PH_LBL0 205
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
___DEF_P_HLBL(___L1_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_3f9f8aaa_2d_ea21_2d_4f2b_2d_bc06_2d_f65950e6c408))
   ___GOTO(___L2_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(200),___L0__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception)
___DEF_GLBL(___L2_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(22),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments
#undef ___PH_LBL0
#define ___PH_LBL0 208
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
___DEF_P_HLBL(___L1_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_3f9f8aaa_2d_ea21_2d_4f2b_2d_bc06_2d_f65950e6c408))
   ___GOTO(___L2_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(200),___L0__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception)
___DEF_GLBL(___L2_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(2L),___SUB(22),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary
#undef ___PH_LBL0
#define ___PH_LBL0 211
#undef ___PD_ALL
#define ___PD_ALL ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary)
   ___JUMPINT(___SET_NARGS(2),___PRC(213),___L__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 213
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
___DEF_P_HLBL(___L2__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
   ___BEGIN_ALLOC_STRUCTURE(3UL)
   ___ADD_STRUCTURE_ELEM(0,___SUB(22))
   ___ADD_STRUCTURE_ELEM(1,___R1)
   ___ADD_STRUCTURE_ELEM(2,___R2)
   ___END_ALLOC_STRUCTURE(3)
   ___SET_R1(___GET_STRUCTURE(3))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_os_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 217
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_os_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_os_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_os_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_os_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(24))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_os_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_os_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 220
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_os_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_os_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_os_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_c1fc166b_2d_d951_2d_4871_2d_853c_2d_2b6c8c12d28d)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_os_2d_exception_2d_procedure
#undef ___PH_LBL0
#define ___PH_LBL0 222
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_os_2d_exception_2d_procedure)
___DEF_P_HLBL(___L1_os_2d_exception_2d_procedure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_os_2d_exception_2d_procedure)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_os_2d_exception_2d_procedure)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_c1fc166b_2d_d951_2d_4871_2d_853c_2d_2b6c8c12d28d))
   ___GOTO(___L2_os_2d_exception_2d_procedure)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_os_2d_exception_2d_procedure)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(217),___L0__23__23_fail_2d_check_2d_os_2d_exception)
___DEF_GLBL(___L2_os_2d_exception_2d_procedure)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(24),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_os_2d_exception_2d_arguments
#undef ___PH_LBL0
#define ___PH_LBL0 225
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_os_2d_exception_2d_arguments)
___DEF_P_HLBL(___L1_os_2d_exception_2d_arguments)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_os_2d_exception_2d_arguments)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_os_2d_exception_2d_arguments)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_c1fc166b_2d_d951_2d_4871_2d_853c_2d_2b6c8c12d28d))
   ___GOTO(___L2_os_2d_exception_2d_arguments)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_os_2d_exception_2d_arguments)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(217),___L0__23__23_fail_2d_check_2d_os_2d_exception)
___DEF_GLBL(___L2_os_2d_exception_2d_arguments)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(2L),___SUB(24),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_os_2d_exception_2d_message
#undef ___PH_LBL0
#define ___PH_LBL0 228
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_os_2d_exception_2d_message)
___DEF_P_HLBL(___L1_os_2d_exception_2d_message)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_os_2d_exception_2d_message)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_os_2d_exception_2d_message)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_c1fc166b_2d_d951_2d_4871_2d_853c_2d_2b6c8c12d28d))
   ___GOTO(___L2_os_2d_exception_2d_message)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_os_2d_exception_2d_message)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(217),___L0__23__23_fail_2d_check_2d_os_2d_exception)
___DEF_GLBL(___L2_os_2d_exception_2d_message)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(3L),___SUB(24),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_os_2d_exception_2d_code
#undef ___PH_LBL0
#define ___PH_LBL0 231
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_os_2d_exception_2d_code)
___DEF_P_HLBL(___L1_os_2d_exception_2d_code)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_os_2d_exception_2d_code)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_os_2d_exception_2d_code)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_c1fc166b_2d_d951_2d_4871_2d_853c_2d_2b6c8c12d28d))
   ___GOTO(___L2_os_2d_exception_2d_code)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_os_2d_exception_2d_code)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(217),___L0__23__23_fail_2d_check_2d_os_2d_exception)
___DEF_GLBL(___L2_os_2d_exception_2d_code)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(4L),___SUB(24),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_os_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 234
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_os_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_os_2d_exception)
___DEF_P_HLBL(___L2__23__23_raise_2d_os_2d_exception)
___DEF_P_HLBL(___L3__23__23_raise_2d_os_2d_exception)
___DEF_P_HLBL(___L4__23__23_raise_2d_os_2d_exception)
___DEF_P_HLBL(___L5__23__23_raise_2d_os_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_os_2d_exception)
   ___IF_NARGS_EQ(3,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___R3) ___SET_R3(___NUL))
   ___GET_REST(0,3,0,0)
___DEF_GLBL(___L__23__23_raise_2d_os_2d_exception)
   ___SET_STK(1,___STK(0))
   ___SET_STK(0,___R2)
   ___SET_STK(2,___STK(1))
   ___SET_STK(1,___R3)
   ___SET_R3(___LBL(2))
   ___SET_R2(___FAL)
   ___ADJFP(2)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_raise_2d_os_2d_exception)
   ___JUMPINT(___SET_NARGS(6),___PRC(87),___L__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_SLBL(2,___L2__23__23_raise_2d_os_2d_exception)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(2,5,0,0)
   ___IF(___NOT(___FIXEQ(___R2,___GLO__23__23_err_2d_code_2d_ENOENT)))
   ___GOTO(___L6__23__23_raise_2d_os_2d_exception)
   ___END_IF
   ___BEGIN_ALLOC_STRUCTURE(3UL)
   ___ADD_STRUCTURE_ELEM(0,___SUB(26))
   ___ADD_STRUCTURE_ELEM(1,___STK(-1))
   ___ADD_STRUCTURE_ELEM(2,___STK(0))
   ___END_ALLOC_STRUCTURE(3)
   ___SET_R1(___GET_STRUCTURE(3))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3__23__23_raise_2d_os_2d_exception)
   ___GOTO(___L7__23__23_raise_2d_os_2d_exception)
___DEF_GLBL(___L6__23__23_raise_2d_os_2d_exception)
   ___BEGIN_ALLOC_STRUCTURE(5UL)
   ___ADD_STRUCTURE_ELEM(0,___SUB(24))
   ___ADD_STRUCTURE_ELEM(1,___STK(-1))
   ___ADD_STRUCTURE_ELEM(2,___STK(0))
   ___ADD_STRUCTURE_ELEM(3,___R1)
   ___ADD_STRUCTURE_ELEM(4,___R2)
   ___END_ALLOC_STRUCTURE(5)
   ___SET_R1(___GET_STRUCTURE(5))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4__23__23_raise_2d_os_2d_exception)
___DEF_GLBL(___L7__23__23_raise_2d_os_2d_exception)
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___POLL(5)
___DEF_SLBL(5,___L5__23__23_raise_2d_os_2d_exception)
   ___ADJFP(-2)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 241
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(26))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 244
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_299ccee1_2d_77d2_2d_4a6d_2d_ab24_2d_2ebf14297315)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure
#undef ___PH_LBL0
#define ___PH_LBL0 246
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
___DEF_P_HLBL(___L1_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_299ccee1_2d_77d2_2d_4a6d_2d_ab24_2d_2ebf14297315))
   ___GOTO(___L2_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(241),___L0__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_GLBL(___L2_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(26),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments
#undef ___PH_LBL0
#define ___PH_LBL0 249
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
___DEF_P_HLBL(___L1_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_299ccee1_2d_77d2_2d_4a6d_2d_ab24_2d_2ebf14297315))
   ___GOTO(___L2_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(241),___L0__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_GLBL(___L2_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(2L),___SUB(26),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 252
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_P_HLBL(___L2__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_P_HLBL(___L3__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___DEF_P_HLBL(___L4__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___FAL)
   ___SET_R3(___LBL(2))
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___ADJFP(3)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
   ___JUMPINT(___SET_NARGS(6),___PRC(87),___L__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_SLBL(2,___L2__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(2,5,0,0)
   ___BEGIN_ALLOC_STRUCTURE(3UL)
   ___ADD_STRUCTURE_ELEM(0,___SUB(26))
   ___ADD_STRUCTURE_ELEM(1,___STK(-1))
   ___ADD_STRUCTURE_ELEM(2,___STK(0))
   ___END_ALLOC_STRUCTURE(3)
   ___SET_R1(___GET_STRUCTURE(3))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception)
   ___ADJFP(-2)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 258
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(28))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_cfun_2d_conversion_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 261
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_cfun_2d_conversion_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_cfun_2d_conversion_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_cfun_2d_conversion_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_9f09b552_2d_0fb7_2d_42c5_2d_b0d4_2d_212155841d53)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_cfun_2d_conversion_2d_exception_2d_procedure
#undef ___PH_LBL0
#define ___PH_LBL0 263
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_cfun_2d_conversion_2d_exception_2d_procedure)
___DEF_P_HLBL(___L1_cfun_2d_conversion_2d_exception_2d_procedure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_cfun_2d_conversion_2d_exception_2d_procedure)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_cfun_2d_conversion_2d_exception_2d_procedure)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_9f09b552_2d_0fb7_2d_42c5_2d_b0d4_2d_212155841d53))
   ___GOTO(___L2_cfun_2d_conversion_2d_exception_2d_procedure)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_cfun_2d_conversion_2d_exception_2d_procedure)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(258),___L0__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
___DEF_GLBL(___L2_cfun_2d_conversion_2d_exception_2d_procedure)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(28),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_cfun_2d_conversion_2d_exception_2d_arguments
#undef ___PH_LBL0
#define ___PH_LBL0 266
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_cfun_2d_conversion_2d_exception_2d_arguments)
___DEF_P_HLBL(___L1_cfun_2d_conversion_2d_exception_2d_arguments)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_cfun_2d_conversion_2d_exception_2d_arguments)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_cfun_2d_conversion_2d_exception_2d_arguments)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_9f09b552_2d_0fb7_2d_42c5_2d_b0d4_2d_212155841d53))
   ___GOTO(___L2_cfun_2d_conversion_2d_exception_2d_arguments)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_cfun_2d_conversion_2d_exception_2d_arguments)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(258),___L0__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
___DEF_GLBL(___L2_cfun_2d_conversion_2d_exception_2d_arguments)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(2L),___SUB(28),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_cfun_2d_conversion_2d_exception_2d_code
#undef ___PH_LBL0
#define ___PH_LBL0 269
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_cfun_2d_conversion_2d_exception_2d_code)
___DEF_P_HLBL(___L1_cfun_2d_conversion_2d_exception_2d_code)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_cfun_2d_conversion_2d_exception_2d_code)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_cfun_2d_conversion_2d_exception_2d_code)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_9f09b552_2d_0fb7_2d_42c5_2d_b0d4_2d_212155841d53))
   ___GOTO(___L2_cfun_2d_conversion_2d_exception_2d_code)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_cfun_2d_conversion_2d_exception_2d_code)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(258),___L0__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
___DEF_GLBL(___L2_cfun_2d_conversion_2d_exception_2d_code)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(3L),___SUB(28),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_cfun_2d_conversion_2d_exception_2d_message
#undef ___PH_LBL0
#define ___PH_LBL0 272
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_cfun_2d_conversion_2d_exception_2d_message)
___DEF_P_HLBL(___L1_cfun_2d_conversion_2d_exception_2d_message)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_cfun_2d_conversion_2d_exception_2d_message)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_cfun_2d_conversion_2d_exception_2d_message)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_9f09b552_2d_0fb7_2d_42c5_2d_b0d4_2d_212155841d53))
   ___GOTO(___L2_cfun_2d_conversion_2d_exception_2d_message)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_cfun_2d_conversion_2d_exception_2d_message)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(258),___L0__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception)
___DEF_GLBL(___L2_cfun_2d_conversion_2d_exception_2d_message)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(4L),___SUB(28),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary
#undef ___PH_LBL0
#define ___PH_LBL0 275
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
___DEF_P_HLBL(___L1__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
___DEF_P_HLBL(___L2__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
   ___IF_NARGS_EQ(3,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___R3) ___SET_R3(___NUL))
   ___GET_REST(0,3,0,0)
___DEF_GLBL(___L__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
   ___BEGIN_ALLOC_STRUCTURE(5UL)
   ___ADD_STRUCTURE_ELEM(0,___SUB(28))
   ___ADD_STRUCTURE_ELEM(1,___R2)
   ___ADD_STRUCTURE_ELEM(2,___R3)
   ___ADD_STRUCTURE_ELEM(3,___STK(0))
   ___ADD_STRUCTURE_ELEM(4,___R1)
   ___END_ALLOC_STRUCTURE(5)
   ___SET_R1(___GET_STRUCTURE(5))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary)
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 279
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(30))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_sfun_2d_conversion_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 282
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_sfun_2d_conversion_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_sfun_2d_conversion_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_sfun_2d_conversion_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_54dfbc02_2d_718d_2d_4a34_2d_91ab_2d_d1861da7500a)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_sfun_2d_conversion_2d_exception_2d_procedure
#undef ___PH_LBL0
#define ___PH_LBL0 284
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_sfun_2d_conversion_2d_exception_2d_procedure)
___DEF_P_HLBL(___L1_sfun_2d_conversion_2d_exception_2d_procedure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_sfun_2d_conversion_2d_exception_2d_procedure)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_sfun_2d_conversion_2d_exception_2d_procedure)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_54dfbc02_2d_718d_2d_4a34_2d_91ab_2d_d1861da7500a))
   ___GOTO(___L2_sfun_2d_conversion_2d_exception_2d_procedure)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_sfun_2d_conversion_2d_exception_2d_procedure)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(279),___L0__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
___DEF_GLBL(___L2_sfun_2d_conversion_2d_exception_2d_procedure)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(30),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_sfun_2d_conversion_2d_exception_2d_arguments
#undef ___PH_LBL0
#define ___PH_LBL0 287
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_sfun_2d_conversion_2d_exception_2d_arguments)
___DEF_P_HLBL(___L1_sfun_2d_conversion_2d_exception_2d_arguments)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_sfun_2d_conversion_2d_exception_2d_arguments)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_sfun_2d_conversion_2d_exception_2d_arguments)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_54dfbc02_2d_718d_2d_4a34_2d_91ab_2d_d1861da7500a))
   ___GOTO(___L2_sfun_2d_conversion_2d_exception_2d_arguments)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_sfun_2d_conversion_2d_exception_2d_arguments)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(279),___L0__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
___DEF_GLBL(___L2_sfun_2d_conversion_2d_exception_2d_arguments)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(2L),___SUB(30),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_sfun_2d_conversion_2d_exception_2d_code
#undef ___PH_LBL0
#define ___PH_LBL0 290
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_sfun_2d_conversion_2d_exception_2d_code)
___DEF_P_HLBL(___L1_sfun_2d_conversion_2d_exception_2d_code)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_sfun_2d_conversion_2d_exception_2d_code)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_sfun_2d_conversion_2d_exception_2d_code)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_54dfbc02_2d_718d_2d_4a34_2d_91ab_2d_d1861da7500a))
   ___GOTO(___L2_sfun_2d_conversion_2d_exception_2d_code)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_sfun_2d_conversion_2d_exception_2d_code)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(279),___L0__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
___DEF_GLBL(___L2_sfun_2d_conversion_2d_exception_2d_code)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(3L),___SUB(30),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_sfun_2d_conversion_2d_exception_2d_message
#undef ___PH_LBL0
#define ___PH_LBL0 293
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_sfun_2d_conversion_2d_exception_2d_message)
___DEF_P_HLBL(___L1_sfun_2d_conversion_2d_exception_2d_message)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_sfun_2d_conversion_2d_exception_2d_message)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_sfun_2d_conversion_2d_exception_2d_message)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_4_2d_54dfbc02_2d_718d_2d_4a34_2d_91ab_2d_d1861da7500a))
   ___GOTO(___L2_sfun_2d_conversion_2d_exception_2d_message)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_sfun_2d_conversion_2d_exception_2d_message)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(279),___L0__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception)
___DEF_GLBL(___L2_sfun_2d_conversion_2d_exception_2d_message)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(4L),___SUB(30),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_sfun_2d_conversion_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 296
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_sfun_2d_conversion_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_sfun_2d_conversion_2d_exception)
___DEF_P_HLBL(___L2__23__23_raise_2d_sfun_2d_conversion_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_sfun_2d_conversion_2d_exception)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L__23__23_raise_2d_sfun_2d_conversion_2d_exception)
   ___BEGIN_ALLOC_STRUCTURE(5UL)
   ___ADD_STRUCTURE_ELEM(0,___SUB(30))
   ___ADD_STRUCTURE_ELEM(1,___R3)
   ___ADD_STRUCTURE_ELEM(2,___NUL)
   ___ADD_STRUCTURE_ELEM(3,___R1)
   ___ADD_STRUCTURE_ELEM(4,___R2)
   ___END_ALLOC_STRUCTURE(5)
   ___SET_R1(___GET_STRUCTURE(5))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_raise_2d_sfun_2d_conversion_2d_exception)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_raise_2d_sfun_2d_conversion_2d_exception)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 300
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(32))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_multiple_2d_c_2d_return_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 303
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_multiple_2d_c_2d_return_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_multiple_2d_c_2d_return_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_multiple_2d_c_2d_return_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_0_2d_73c66686_2d_a08f_2d_4c7c_2d_a0f1_2d_5ad7771f242a)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 305
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception)
   ___SET_R1(___SUB(34))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 308
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(35))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 311
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_0_2d_828142df_2d_e9a5_2d_4ed8_2d_a467_2d_2f4833525b3e)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 313
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
   ___SET_R1(___SUB(37))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 316
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_)
   ___SET_GLO(20,___G__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook,___R1)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_c_2d_return_2d_on_2d_other_2d_processor
#undef ___PH_LBL0
#define ___PH_LBL0 318
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_c_2d_return_2d_on_2d_other_2d_processor)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_c_2d_return_2d_on_2d_other_2d_processor)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_c_2d_return_2d_on_2d_other_2d_processor)
   ___SET_STK(1,___GLO__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook)
   ___ADJFP(1)
   ___IF(___NOT(___PROCEDUREP(___STK(0))))
   ___GOTO(___L1__23__23_c_2d_return_2d_on_2d_other_2d_processor)
   ___END_IF
   ___ADJFP(-1)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___STK(1))
___DEF_GLBL(___L1__23__23_c_2d_return_2d_on_2d_other_2d_processor)
   ___ADJFP(-1)
   ___JUMPINT(___SET_NARGS(0),___PRC(313),___L__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 320
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(38))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 323
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_f9519b37_2d_d6d4_2d_4748_2d_8eb1_2d_a0c8dc18c5e7)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure
#undef ___PH_LBL0
#define ___PH_LBL0 325
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
___DEF_P_HLBL(___L1_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_f9519b37_2d_d6d4_2d_4748_2d_8eb1_2d_a0c8dc18c5e7))
   ___GOTO(___L2_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(320),___L0__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___DEF_GLBL(___L2_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(38),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments
#undef ___PH_LBL0
#define ___PH_LBL0 328
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
___DEF_P_HLBL(___L1_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_f9519b37_2d_d6d4_2d_4748_2d_8eb1_2d_a0c8dc18c5e7))
   ___GOTO(___L2_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(320),___L0__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___DEF_GLBL(___L2_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(2L),___SUB(38),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 331
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___DEF_P_HLBL(___L2__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
   ___BEGIN_ALLOC_STRUCTURE(3UL)
   ___ADD_STRUCTURE_ELEM(0,___SUB(38))
   ___ADD_STRUCTURE_ELEM(1,___R1)
   ___ADD_STRUCTURE_ELEM(2,___R2)
   ___END_ALLOC_STRUCTURE(3)
   ___SET_R1(___GET_STRUCTURE(3))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_promise
#undef ___PH_LBL0
#define ___PH_LBL0 335
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_promise)
___DEF_P_HLBL(___L1__23__23_make_2d_promise)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_promise)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_make_2d_promise)
   ___SET_R1(___MAKEPROMISE(___R1))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_make_2d_promise)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_promise_2d_thunk
#undef ___PH_LBL0
#define ___PH_LBL0 338
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_promise_2d_thunk)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_promise_2d_thunk)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_promise_2d_thunk)
   ___SET_R1(___PROMISETHUNK(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_promise_2d_thunk_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 340
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_promise_2d_thunk_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_promise_2d_thunk_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_promise_2d_thunk_2d_set_21_)
   ___PROMISETHUNKSET(___R1,___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_promise_2d_result
#undef ___PH_LBL0
#define ___PH_LBL0 342
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_promise_2d_result)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_promise_2d_result)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_promise_2d_result)
   ___SET_R1(___PROMISERESULT(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_promise_2d_result_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 344
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_promise_2d_result_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_promise_2d_result_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_promise_2d_result_2d_set_21_)
   ___PROMISERESULTSET(___R1,___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_force_2d_undetermined
#undef ___PH_LBL0
#define ___PH_LBL0 346
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_force_2d_undetermined)
___DEF_P_HLBL(___L1__23__23_force_2d_undetermined)
___DEF_P_HLBL(___L2__23__23_force_2d_undetermined)
___DEF_P_HLBL(___L3__23__23_force_2d_undetermined)
___DEF_P_HLBL(___L4__23__23_force_2d_undetermined)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_force_2d_undetermined)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_force_2d_undetermined)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_force_2d_undetermined)
   ___SET_R0(___LBL(2))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R2)
___DEF_SLBL(2,___L2__23__23_force_2d_undetermined)
   ___FORCE1(3,___R1)
___DEF_SLBL(3,___L3__23__23_force_2d_undetermined)
   ___FORCE2
   ___SET_R1(___FORCE3)
#define ___ARG1 ___STK(-6)
#define ___ARG2 ___R1
{ ___SCMOBJ ___RESULT;

     if (___PROMISERESULT(___ARG1) == ___ARG1)
       {
         ___PROMISERESULTSET(___ARG1,___ARG2)
         ___PROMISETHUNKSET(___ARG1,___FAL)
       }
     ___RESULT = ___PROMISERESULT(___ARG1);

   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_force_2d_undetermined)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_jobs
#undef ___PH_LBL0
#define ___PH_LBL0 352
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_jobs)
___DEF_P_HLBL(___L1__23__23_make_2d_jobs)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_jobs)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_make_2d_jobs)
   ___SET_R1(___CONS(___NUL,___NUL))
   ___SETCAR(___R1,___R1)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_make_2d_jobs)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_add_2d_job_2d_at_2d_tail_21_
#undef ___PH_LBL0
#define ___PH_LBL0 355
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_add_2d_job_2d_at_2d_tail_21_)
___DEF_P_HLBL(___L1__23__23_add_2d_job_2d_at_2d_tail_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_add_2d_job_2d_at_2d_tail_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_add_2d_job_2d_at_2d_tail_21_)
   ___SET_R2(___CONS(___R2,___NUL))
   ___SET_R3(___CAR(___R1))
   ___SETCDR(___R3,___R2)
   ___SETCAR(___R1,___R2)
   ___SET_R1(___VOID)
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_add_2d_job_2d_at_2d_tail_21_)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_add_2d_job_21_
#undef ___PH_LBL0
#define ___PH_LBL0 358
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_add_2d_job_21_)
___DEF_P_HLBL(___L1__23__23_add_2d_job_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_add_2d_job_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_add_2d_job_21_)
   ___SET_R2(___CONS(___R2,___NUL))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_add_2d_job_21_)
   ___SET_R3(___CDR(___R1))
   ___IF(___NOT(___NULLP(___R3)))
   ___GOTO(___L2__23__23_add_2d_job_21_)
   ___END_IF
   ___SETCAR(___R1,___R2)
___DEF_GLBL(___L2__23__23_add_2d_job_21_)
   ___SETCDR(___R1,___R2)
   ___SETCDR(___R2,___R3)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_execute_2d_jobs_21_
#undef ___PH_LBL0
#define ___PH_LBL0 361
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_execute_2d_jobs_21_)
___DEF_P_HLBL(___L1__23__23_execute_2d_jobs_21_)
___DEF_P_HLBL(___L2__23__23_execute_2d_jobs_21_)
___DEF_P_HLBL(___L3__23__23_execute_2d_jobs_21_)
___DEF_P_HLBL(___L4__23__23_execute_2d_jobs_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_execute_2d_jobs_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_execute_2d_jobs_21_)
   ___SET_R1(___CDR(___R1))
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_execute_2d_jobs_21_)
   ___GOTO(___L5__23__23_execute_2d_jobs_21_)
___DEF_SLBL(2,___L2__23__23_execute_2d_jobs_21_)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_execute_2d_jobs_21_)
___DEF_GLBL(___L5__23__23_execute_2d_jobs_21_)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L6__23__23_execute_2d_jobs_21_)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_execute_2d_jobs_21_)
   ___SET_R0(___LBL(2))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___DEF_GLBL(___L6__23__23_execute_2d_jobs_21_)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_execute_2d_and_2d_clear_2d_jobs_21_
#undef ___PH_LBL0
#define ___PH_LBL0 367
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
___DEF_P_HLBL(___L1__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
___DEF_P_HLBL(___L2__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
___DEF_P_HLBL(___L3__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
___DEF_P_HLBL(___L4__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
   ___SET_R2(___CDR(___R1))
   ___SETCAR(___R1,___R1)
   ___SETCDR(___R1,___NUL)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L5__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_R1(___CAR(___R2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
   ___SET_R0(___LBL(2))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___DEF_SLBL(2,___L2__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
   ___SET_R1(___CDR(___STK(-6)))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
   ___IF(___NOT(___PAIRP(___R1)))
   ___GOTO(___L5__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___CAR(___R1))
   ___ADJFP(8)
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
   ___SET_R0(___LBL(2))
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___DEF_GLBL(___L5__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_clear_2d_jobs_21_
#undef ___PH_LBL0
#define ___PH_LBL0 373
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_clear_2d_jobs_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_clear_2d_jobs_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_clear_2d_jobs_21_)
   ___SETCAR(___R1,___R1)
   ___SETCDR(___R1,___NUL)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_check_2d_heap_2d_limit
#undef ___PH_LBL0
#define ___PH_LBL0 375
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_check_2d_heap_2d_limit)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_check_2d_heap_2d_limit)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_check_2d_heap_2d_limit)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_check_2d_heap
#undef ___PH_LBL0
#define ___PH_LBL0 377
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_check_2d_heap)
___DEF_P_HLBL(___L1__23__23_check_2d_heap)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_check_2d_heap)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_check_2d_heap)
   ___GOTO(___L2__23__23_check_2d_heap)
___DEF_SLBL(1,___L1__23__23_check_2d_heap)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
___DEF_GLBL(___L2__23__23_check_2d_heap)
{ ___SCMOBJ ___RESULT;

          if (___hp > ___ps->heap_limit)
            {
              ___BOOL overflow;
              ___FRAME_STORE_RA(___R0)
              ___W_ALL
              overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
              ___R_ALL
              ___SET_R0(___FRAME_FETCH_RA)
              if (overflow)
                ___RESULT = ___TRU;
              else
                ___RESULT = ___FAL;
            }
          else
            ___RESULT = ___FAL;

   ___SET_R1(___RESULT)
}
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L3__23__23_check_2d_heap)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_GLBL(___L3__23__23_check_2d_heap)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_rest_2d_param_2d_check_2d_heap
#undef ___PH_LBL0
#define ___PH_LBL0 380
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_rest_2d_param_2d_check_2d_heap)
___DEF_P_HLBL(___L1__23__23_rest_2d_param_2d_check_2d_heap)
___DEF_P_HLBL(___L2__23__23_rest_2d_param_2d_check_2d_heap)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_rest_2d_param_2d_check_2d_heap)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_rest_2d_param_2d_check_2d_heap)
   ___GOTO(___L3__23__23_rest_2d_param_2d_check_2d_heap)
___DEF_SLBL(1,___L1__23__23_rest_2d_param_2d_check_2d_heap)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
___DEF_GLBL(___L3__23__23_rest_2d_param_2d_check_2d_heap)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(391),___L__23__23_gc_2d_without_2d_exceptions)
___DEF_SLBL(2,___L2__23__23_rest_2d_param_2d_check_2d_heap)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L4__23__23_rest_2d_param_2d_check_2d_heap)
   ___END_IF
   ___SET_R0(___LBL(1))
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_GLBL(___L4__23__23_rest_2d_param_2d_check_2d_heap)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(389),___L__23__23_rest_2d_param_2d_resume_2d_procedure)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_rest_2d_param_2d_heap_2d_overflow
#undef ___PH_LBL0
#define ___PH_LBL0 384
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_rest_2d_param_2d_heap_2d_overflow)
___DEF_P_HLBL(___L1__23__23_rest_2d_param_2d_heap_2d_overflow)
___DEF_P_HLBL(___L2__23__23_rest_2d_param_2d_heap_2d_overflow)
___DEF_P_HLBL(___L3__23__23_rest_2d_param_2d_heap_2d_overflow)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_rest_2d_param_2d_heap_2d_overflow)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_rest_2d_param_2d_heap_2d_overflow)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_rest_2d_param_2d_heap_2d_overflow)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(2,___L2__23__23_rest_2d_param_2d_heap_2d_overflow)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_rest_2d_param_2d_heap_2d_overflow)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_apply)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_rest_2d_param_2d_resume_2d_procedure
#undef ___PH_LBL0
#define ___PH_LBL0 389
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_rest_2d_param_2d_resume_2d_procedure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_rest_2d_param_2d_resume_2d_procedure)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_rest_2d_param_2d_resume_2d_procedure)
{ ___SCMOBJ ___RESULT;

   ___SCMOBJ proc;
   ___SCMOBJ args;
   int np;
   int i;

   ___POP_ARGS2(proc,args)

   np = ___INT(___VECTORLENGTH(args));

   for (i=0; i<np; i++)
     ___PUSH(___FIELD(args,i))

   ___POP_ARGS_IN_REGS(np) /* load register arguments */

   ___COVER_REST_PARAM_RESUME_PROCEDURE;

   ___JUMPEXTPRM(___SET_NARGS(-1),proc)

   ___RESULT = ___FAL; /* avoid a warning that ___RESULT is not set */

   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_gc_2d_without_2d_exceptions
#undef ___PH_LBL0
#define ___PH_LBL0 391
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_gc_2d_without_2d_exceptions)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_gc_2d_without_2d_exceptions)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_gc_2d_without_2d_exceptions)
{ ___SCMOBJ ___RESULT;

   ___BOOL overflow;

   ___FRAME_STORE_RA(___R0)
   ___W_ALL
   overflow = ___garbage_collect (___PSP 0);
   ___R_ALL
   ___SET_R0(___FRAME_FETCH_RA)

   ___RESULT = ___BOOLEAN(overflow);

   ___COVER_GC_WITHOUT_EXCEPTIONS;

   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_gc
#undef ___PH_LBL0
#define ___PH_LBL0 393
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_gc)
___DEF_P_HLBL(___L1__23__23_gc)
___DEF_P_HLBL(___L2__23__23_gc)
___DEF_P_HLBL(___L3__23__23_gc)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_gc)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_gc)
   ___GOTO(___L4__23__23_gc)
___DEF_SLBL(1,___L1__23__23_gc)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_gc)
___DEF_GLBL(___L4__23__23_gc)
{ ___SCMOBJ ___RESULT;

          ___BOOL overflow;
          ___FRAME_STORE_RA(___R0)
          ___W_ALL
          overflow = ___garbage_collect (___PSP 0);
          ___R_ALL
          ___SET_R0(___FRAME_FETCH_RA)
          ___RESULT = ___BOOLEAN(overflow);

   ___SET_R1(___RESULT)
}
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L5__23__23_gc)
   ___END_IF
   ___SET_STK(1,___R0)
   ___ADJFP(4)
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_gc)
   ___SET_R0(___LBL(1))
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_GLBL(___L5__23__23_gc)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_add_2d_gc_2d_interrupt_2d_job_21_
#undef ___PH_LBL0
#define ___PH_LBL0 398
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_add_2d_gc_2d_interrupt_2d_job_21_)
___DEF_P_HLBL(___L1__23__23_add_2d_gc_2d_interrupt_2d_job_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_add_2d_gc_2d_interrupt_2d_job_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_add_2d_gc_2d_interrupt_2d_job_21_)
   ___SET_R2(___R1)
   ___SET_R1(___GLO__23__23_gc_2d_interrupt_2d_jobs)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_add_2d_gc_2d_interrupt_2d_job_21_)
   ___JUMPINT(___SET_NARGS(2),___PRC(358),___L__23__23_add_2d_job_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_
#undef ___PH_LBL0
#define ___PH_LBL0 401
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_)
___DEF_P_HLBL(___L1__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_)
   ___SET_R1(___GLO__23__23_gc_2d_interrupt_2d_jobs)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_)
   ___JUMPINT(___SET_NARGS(1),___PRC(373),___L__23__23_clear_2d_jobs_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_gc_2d_finalize_21_
#undef ___PH_LBL0
#define ___PH_LBL0 404
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_gc_2d_finalize_21_)
___DEF_P_HLBL(___L1__23__23_gc_2d_finalize_21_)
___DEF_P_HLBL(___L2__23__23_gc_2d_finalize_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_gc_2d_finalize_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_gc_2d_finalize_21_)
   ___GOTO(___L3__23__23_gc_2d_finalize_21_)
___DEF_SLBL(1,___L1__23__23_gc_2d_finalize_21_)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
___DEF_GLBL(___L3__23__23_gc_2d_finalize_21_)
{ ___SCMOBJ ___RESULT;

          ___WORD exec_wills = ___ps->mem.executable_wills_;

          if (___UNTAG(exec_wills) == 0) /* end of list? */
            ___RESULT = ___FAL;
          else
            {
              ___WORD will = ___SUBTYPED_FROM_START(___UNTAG(exec_wills));
              ___ps->mem.executable_wills_ = ___FIELD(will,___WILL_NEXT);
              ___RESULT = will;
            }

   ___SET_R1(___RESULT)
}
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L4__23__23_gc_2d_finalize_21_)
   ___END_IF
   ___SET_R2(___VECTORREF(___R1,___FIX(1L)))
   ___SET_R3(___VECTORREF(___R1,___FIX(2L)))
   ___VECTORSET(___R1,___FIX(1L),___FAL)
   ___VECTORSET(___R1,___FIX(2L),___FAL)
   ___IF(___NOT(___NOTFALSEP(___R3)))
   ___GOTO(___L3__23__23_gc_2d_finalize_21_)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_R1(___R2)
   ___ADJFP(4)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_gc_2d_finalize_21_)
   ___SET_R0(___LBL(1))
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R3)
___DEF_GLBL(___L4__23__23_gc_2d_finalize_21_)
   ___JUMPINT(___SET_NARGS(0),___PRC(412),___L__23__23_gc_2d_final_2d_will_2d_registry_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_execute_2d_final_2d_wills_21_
#undef ___PH_LBL0
#define ___PH_LBL0 408
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_execute_2d_final_2d_wills_21_)
___DEF_P_HLBL(___L1__23__23_execute_2d_final_2d_wills_21_)
___DEF_P_HLBL(___L2__23__23_execute_2d_final_2d_wills_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_execute_2d_final_2d_wills_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_execute_2d_final_2d_wills_21_)
   ___SET_R1(___CDR(___GLO__23__23_final_2d_will_2d_registry))
   ___SETCAR(___GLO__23__23_final_2d_will_2d_registry,___GLO__23__23_final_2d_will_2d_registry)
   ___SETCDR(___GLO__23__23_final_2d_will_2d_registry,___NUL)
   ___IF(___NULLP(___R1))
   ___GOTO(___L5__23__23_execute_2d_final_2d_wills_21_)
   ___END_IF
   ___GOTO(___L4__23__23_execute_2d_final_2d_wills_21_)
___DEF_SLBL(1,___L1__23__23_execute_2d_final_2d_wills_21_)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
___DEF_GLBL(___L3__23__23_execute_2d_final_2d_wills_21_)
   ___SET_R1(___CDR(___R1))
   ___IF(___NULLP(___R1))
   ___GOTO(___L5__23__23_execute_2d_final_2d_wills_21_)
   ___END_IF
___DEF_GLBL(___L4__23__23_execute_2d_final_2d_wills_21_)
   ___SET_R2(___CAR(___R1))
   ___SET_R3(___VECTORREF(___R2,___FIX(1L)))
   ___SET_R4(___VECTORREF(___R2,___FIX(2L)))
   ___VECTORSET(___R2,___FIX(1L),___FAL)
   ___VECTORSET(___R2,___FIX(2L),___FAL)
   ___IF(___NOT(___NOTFALSEP(___R4)))
   ___GOTO(___L3__23__23_execute_2d_final_2d_wills_21_)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R3)
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_execute_2d_final_2d_wills_21_)
   ___SET_R0(___LBL(1))
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R4)
___DEF_GLBL(___L5__23__23_execute_2d_final_2d_wills_21_)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_gc_2d_final_2d_will_2d_registry_21_
#undef ___PH_LBL0
#define ___PH_LBL0 412
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_gc_2d_final_2d_will_2d_registry_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_gc_2d_final_2d_will_2d_registry_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_gc_2d_final_2d_will_2d_registry_21_)
   ___SET_R2(___CDR(___GLO__23__23_final_2d_will_2d_registry))
   ___SET_R1(___GLO__23__23_final_2d_will_2d_registry)
   ___IF(___NULLP(___R2))
   ___GOTO(___L3__23__23_gc_2d_final_2d_will_2d_registry_21_)
   ___END_IF
   ___GOTO(___L2__23__23_gc_2d_final_2d_will_2d_registry_21_)
___DEF_GLBL(___L1__23__23_gc_2d_final_2d_will_2d_registry_21_)
   ___SET_R2(___CDR(___R2))
   ___IF(___NULLP(___R2))
   ___GOTO(___L3__23__23_gc_2d_final_2d_will_2d_registry_21_)
   ___END_IF
___DEF_GLBL(___L2__23__23_gc_2d_final_2d_will_2d_registry_21_)
   ___SET_R3(___CAR(___R2))
   ___SET_R3(___VECTORREF(___R3,___FIX(2L)))
   ___IF(___NOT(___NOTFALSEP(___R3)))
   ___GOTO(___L1__23__23_gc_2d_final_2d_will_2d_registry_21_)
   ___END_IF
   ___SETCDR(___R1,___R2)
   ___SET_R1(___CDR(___R2))
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___IF(___NOT(___NULLP(___R2)))
   ___GOTO(___L2__23__23_gc_2d_final_2d_will_2d_registry_21_)
   ___END_IF
___DEF_GLBL(___L3__23__23_gc_2d_final_2d_will_2d_registry_21_)
   ___SETCAR(___GLO__23__23_final_2d_will_2d_registry,___R1) ___SET_R1(___GLO__23__23_final_2d_will_2d_registry)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_final_2d_will
#undef ___PH_LBL0
#define ___PH_LBL0 414
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_final_2d_will)
___DEF_P_HLBL(___L1__23__23_make_2d_final_2d_will)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_final_2d_will)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_make_2d_final_2d_will)
   ___SET_R1(___MAKEWILL(___R1,___R2))
   ___SET_R2(___CONS(___R1,___NUL))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_make_2d_final_2d_will)
   ___SET_R3(___CDR(___GLO__23__23_final_2d_will_2d_registry))
   ___IF(___NOT(___NULLP(___R3)))
   ___GOTO(___L2__23__23_make_2d_final_2d_will)
   ___END_IF
   ___SETCAR(___GLO__23__23_final_2d_will_2d_registry,___R2)
___DEF_GLBL(___L2__23__23_make_2d_final_2d_will)
   ___SETCDR(___GLO__23__23_final_2d_will_2d_registry,___R2)
   ___SETCDR(___R2,___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_handle_2d_gc_2d_interrupt_21_
#undef ___PH_LBL0
#define ___PH_LBL0 417
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_handle_2d_gc_2d_interrupt_21_)
___DEF_P_HLBL(___L1__23__23_handle_2d_gc_2d_interrupt_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_handle_2d_gc_2d_interrupt_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_handle_2d_gc_2d_interrupt_21_)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(0),___PRC(404),___L__23__23_gc_2d_finalize_21_)
___DEF_SLBL(1,___L1__23__23_handle_2d_gc_2d_interrupt_21_)
   ___SET_R1(___GLO__23__23_gc_2d_interrupt_2d_jobs)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(361),___L__23__23_execute_2d_jobs_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_get_2d_min_2d_heap
#undef ___PH_LBL0
#define ___PH_LBL0 420
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_get_2d_min_2d_heap)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_get_2d_min_2d_heap)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_get_2d_min_2d_heap)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___get_min_heap ());
   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_set_2d_min_2d_heap_21_
#undef ___PH_LBL0
#define ___PH_LBL0 422
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_set_2d_min_2d_heap_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_set_2d_min_2d_heap_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_set_2d_min_2d_heap_21_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;
___set_min_heap (___INT(___ARG1)); ___RESULT = ___VOID;
   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_get_2d_max_2d_heap
#undef ___PH_LBL0
#define ___PH_LBL0 424
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_get_2d_max_2d_heap)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_get_2d_max_2d_heap)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_get_2d_max_2d_heap)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___get_max_heap ());
   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_set_2d_max_2d_heap_21_
#undef ___PH_LBL0
#define ___PH_LBL0 426
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_set_2d_max_2d_heap_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_set_2d_max_2d_heap_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_set_2d_max_2d_heap_21_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;
___set_max_heap (___INT(___ARG1)); ___RESULT = ___VOID;
   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_get_2d_live_2d_percent
#undef ___PH_LBL0
#define ___PH_LBL0 428
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_get_2d_live_2d_percent)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_get_2d_live_2d_percent)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_get_2d_live_2d_percent)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___get_live_percent ());
   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_set_2d_live_2d_percent_21_
#undef ___PH_LBL0
#define ___PH_LBL0 430
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_set_2d_live_2d_percent_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_set_2d_live_2d_percent_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_set_2d_live_2d_percent_21_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;
___set_live_percent (___INT(___ARG1)); ___RESULT = ___VOID;
   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_get_2d_parallelism_2d_level
#undef ___PH_LBL0
#define ___PH_LBL0 432
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_get_2d_parallelism_2d_level)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_get_2d_parallelism_2d_level)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_get_2d_parallelism_2d_level)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___get_parallelism_level ());
   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_set_2d_parallelism_2d_level_21_
#undef ___PH_LBL0
#define ___PH_LBL0 434
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_set_2d_parallelism_2d_level_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_set_2d_parallelism_2d_level_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_set_2d_parallelism_2d_level_21_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;
___set_parallelism_level (___INT(___ARG1)); ___RESULT = ___VOID;
   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_get_2d_standard_2d_level
#undef ___PH_LBL0
#define ___PH_LBL0 436
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_get_2d_standard_2d_level)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_get_2d_standard_2d_level)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_get_2d_standard_2d_level)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___get_standard_level ());
   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_set_2d_standard_2d_level_21_
#undef ___PH_LBL0
#define ___PH_LBL0 438
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_set_2d_standard_2d_level_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_set_2d_standard_2d_level_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_set_2d_standard_2d_level_21_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;
___set_standard_level (___INT(___ARG1)); ___RESULT = ___VOID;
   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_set_2d_gambitdir_21_
#undef ___PH_LBL0
#define ___PH_LBL0 440
#undef ___PD_ALL
#define ___PD_ALL
#undef ___PR_ALL
#define ___PR_ALL
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_set_2d_gambitdir_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_set_2d_gambitdir_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_set_2d_gambitdir_21_)
   ___JUMPINT(___SET_NARGS(1),___PRC(950),___L___kernel_23_0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_set_2d_debug_2d_settings_21_
#undef ___PH_LBL0
#define ___PH_LBL0 442
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_set_2d_debug_2d_settings_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_set_2d_debug_2d_settings_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_set_2d_debug_2d_settings_21_)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;
___RESULT =
      ___FIX(___set_debug_settings (___INT(___ARG1), ___INT(___ARG2)));
   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_cpu_2d_count
#undef ___PH_LBL0
#define ___PH_LBL0 444
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_cpu_2d_count)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_cpu_2d_count)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_cpu_2d_count)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___cpu_count ());
   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_cpu_2d_cache_2d_size
#undef ___PH_LBL0
#define ___PH_LBL0 446
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_cpu_2d_cache_2d_size)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_cpu_2d_cache_2d_size)
   ___IF_NARGS_EQ(0,___SET_R1(___FAL) ___SET_R2(___FIX(0L)))
   ___IF_NARGS_EQ(1,___SET_R2(___FIX(0L)))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,0,2,0)
___DEF_GLBL(___L__23__23_cpu_2d_cache_2d_size)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;
___RESULT =
       ___FIX(___cpu_cache_size (!___FALSEP(___ARG1), ___INT(___ARG2)));
   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_core_2d_count
#undef ___PH_LBL0
#define ___PH_LBL0 448
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_core_2d_count)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_core_2d_count)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_core_2d_count)
{ ___SCMOBJ ___RESULT;
___RESULT = ___FIX(___core_count ());
   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_still_2d_copy
#undef ___PH_LBL0
#define ___PH_LBL0 450
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_still_2d_copy)
___DEF_P_HLBL(___L1__23__23_still_2d_copy)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_still_2d_copy)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_still_2d_copy)
   ___GOTO(___L2__23__23_still_2d_copy)
___DEF_SLBL(1,___L1__23__23_still_2d_copy)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
___DEF_GLBL(___L2__23__23_still_2d_copy)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

___SCMOBJ result;
___WORD head = ___HEADER(___ARG1);
___FRAME_STORE_RA(___R0)
___W_ALL
result = ___EXT(___alloc_scmobj) (___ps, ___HD_SUBTYPE(head), ___HD_BYTES(head));
___R_ALL
___SET_R0(___FRAME_FETCH_RA)
if (!___FIXNUMP(result))
  {
    ___SIZE_TS words = ___HD_WORDS(head);
    ___WORD *body1 = ___BODY(___ARG1);
    ___WORD *body2 = ___BODY(result);
    while (words > 0)
      {
        *body2++ = *body1++;
        words--;
      }
    ___still_obj_refcount_dec (result);
  }
___RESULT = result;

   ___SET_R2(___RESULT)
}
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R2)))
   ___GOTO(___L3__23__23_still_2d_copy)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_GLBL(___L3__23__23_still_2d_copy)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_still_2d_obj_2d_refcount_2d_inc_21_
#undef ___PH_LBL0
#define ___PH_LBL0 453
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_still_2d_obj_2d_refcount_2d_inc_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_still_2d_obj_2d_refcount_2d_inc_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_still_2d_obj_2d_refcount_2d_inc_21_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;
___still_obj_refcount_inc (___ARG1); ___RESULT = ___ARG1;
   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_still_2d_obj_2d_refcount_2d_dec_21_
#undef ___PH_LBL0
#define ___PH_LBL0 455
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_still_2d_obj_2d_refcount_2d_dec_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_still_2d_obj_2d_refcount_2d_dec_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_still_2d_obj_2d_refcount_2d_dec_21_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;
___still_obj_refcount_dec (___ARG1); ___RESULT = ___ARG1;
   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_vector
#undef ___PH_LBL0
#define ___PH_LBL0 457
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_vector)
___DEF_P_HLBL(___L1__23__23_make_2d_vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_vector)
   ___IF_NARGS_EQ(1,___SET_R2(___ABSENT))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_vector)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+___LWS)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = n + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sVECTOR, n<<___LWS);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_WORDS(n, ___sVECTOR));
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result))
  {
    ___SCMOBJ fill = ___ARG2;
    if (fill == ___ABSENT)
      fill = ___FIX(0);
    for (i=0; i<n; i++)
      ___VECTORSET(result,___FIX(i),fill)
  }
___RESULT = result;

   ___SET_R3(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L2__23__23_make_2d_vector)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_vector)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_vector)
___DEF_GLBL(___L2__23__23_make_2d_vector)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_string
#undef ___PH_LBL0
#define ___PH_LBL0 460
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_string)
___DEF_P_HLBL(___L1__23__23_make_2d_string)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_string)
   ___IF_NARGS_EQ(1,___SET_R2(___ABSENT))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_string)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+___LCS)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<___LCS)) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sSTRING, n<<___LCS);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<___LCS), ___sSTRING));
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___STRINGSET(result,___FIX(i),___ARG2);
  }
___RESULT = result;

   ___SET_R3(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L2__23__23_make_2d_string)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_string)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_string)
___DEF_GLBL(___L2__23__23_make_2d_string)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_s8vector
#undef ___PH_LBL0
#define ___PH_LBL0 463
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_s8vector)
___DEF_P_HLBL(___L1__23__23_make_2d_s8vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_s8vector)
   ___IF_NARGS_EQ(1,___SET_R2(___ABSENT))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_s8vector)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>___LF))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS(n) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sS8VECTOR, n);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES(n, ___sS8VECTOR));
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___S8VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

   ___SET_R3(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L2__23__23_make_2d_s8vector)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_s8vector)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_s8vector)
___DEF_GLBL(___L2__23__23_make_2d_s8vector)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_u8vector
#undef ___PH_LBL0
#define ___PH_LBL0 466
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_u8vector)
___DEF_P_HLBL(___L1__23__23_make_2d_u8vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_u8vector)
   ___IF_NARGS_EQ(1,___SET_R2(___ABSENT))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_u8vector)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>___LF))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS(n) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sU8VECTOR, n);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES(n, ___sU8VECTOR));
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___U8VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

   ___SET_R3(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L2__23__23_make_2d_u8vector)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_u8vector)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_u8vector)
___DEF_GLBL(___L2__23__23_make_2d_u8vector)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_s16vector
#undef ___PH_LBL0
#define ___PH_LBL0 469
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_s16vector)
___DEF_P_HLBL(___L1__23__23_make_2d_s16vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_s16vector)
   ___IF_NARGS_EQ(1,___SET_R2(___ABSENT))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_s16vector)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+1)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<1)) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sS16VECTOR, n<<1);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<1), ___sS16VECTOR));
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___S16VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

   ___SET_R3(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L2__23__23_make_2d_s16vector)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_s16vector)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_s16vector)
___DEF_GLBL(___L2__23__23_make_2d_s16vector)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_u16vector
#undef ___PH_LBL0
#define ___PH_LBL0 472
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_u16vector)
___DEF_P_HLBL(___L1__23__23_make_2d_u16vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_u16vector)
   ___IF_NARGS_EQ(1,___SET_R2(___ABSENT))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_u16vector)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+1)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<1)) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sU16VECTOR, n<<1);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<1), ___sU16VECTOR));
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___U16VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

   ___SET_R3(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L2__23__23_make_2d_u16vector)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_u16vector)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_u16vector)
___DEF_GLBL(___L2__23__23_make_2d_u16vector)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_s32vector
#undef ___PH_LBL0
#define ___PH_LBL0 475
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_s32vector)
___DEF_P_HLBL(___L1__23__23_make_2d_s32vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_s32vector)
   ___IF_NARGS_EQ(1,___SET_R2(___ABSENT))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_s32vector)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+2)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<2)) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sS32VECTOR, n<<2);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<2), ___sS32VECTOR));
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___S32VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

   ___SET_R3(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L2__23__23_make_2d_s32vector)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_s32vector)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_s32vector)
___DEF_GLBL(___L2__23__23_make_2d_s32vector)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_u32vector
#undef ___PH_LBL0
#define ___PH_LBL0 478
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_u32vector)
___DEF_P_HLBL(___L1__23__23_make_2d_u32vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_u32vector)
   ___IF_NARGS_EQ(1,___SET_R2(___ABSENT))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_u32vector)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+2)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<2)) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sU32VECTOR, n<<2);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<2), ___sU32VECTOR));
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___U32VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

   ___SET_R3(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L2__23__23_make_2d_u32vector)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_u32vector)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_u32vector)
___DEF_GLBL(___L2__23__23_make_2d_u32vector)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_s64vector
#undef ___PH_LBL0
#define ___PH_LBL0 481
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_s64vector)
___DEF_P_HLBL(___L1__23__23_make_2d_s64vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_s64vector)
   ___IF_NARGS_EQ(1,___SET_R2(___ABSENT))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_s64vector)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+3)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<3)) + ___SUBTYPED_BODY;

#if ___WS == 4
    words++;
#endif

    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sS64VECTOR, n<<3);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
#if ___WS == 4
            result = ___SUBTYPED_FROM_BODY(___CAST(___WORD,___hp+___SUBTYPED_BODY+1)&~7);
#else
            result = ___SUBTYPED_FROM_START(___hp);
#endif
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<3), ___sS64VECTOR));
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___S64VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

   ___SET_R3(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L2__23__23_make_2d_s64vector)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_s64vector)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_s64vector)
___DEF_GLBL(___L2__23__23_make_2d_s64vector)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_u64vector
#undef ___PH_LBL0
#define ___PH_LBL0 484
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_u64vector)
___DEF_P_HLBL(___L1__23__23_make_2d_u64vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_u64vector)
   ___IF_NARGS_EQ(1,___SET_R2(___ABSENT))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_u64vector)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+3)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<3)) + ___SUBTYPED_BODY;

#if ___WS == 4
    words++;
#endif

    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sU64VECTOR, n<<3);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
#if ___WS == 4
            result = ___SUBTYPED_FROM_BODY(___CAST(___WORD,___hp+___SUBTYPED_BODY+1)&~7);
#else
            result = ___SUBTYPED_FROM_START(___hp);
#endif
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<3), ___sU64VECTOR));
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    for (i=0; i<n; i++)
      ___U64VECTORSET(result,___FIX(i),___ARG2)
  }
___RESULT = result;

   ___SET_R3(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L2__23__23_make_2d_u64vector)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_u64vector)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_u64vector)
___DEF_GLBL(___L2__23__23_make_2d_u64vector)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_f32vector
#undef ___PH_LBL0
#define ___PH_LBL0 487
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_f32vector)
___DEF_P_HLBL(___L1__23__23_make_2d_f32vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_f32vector)
   ___IF_NARGS_EQ(1,___SET_R2(___ABSENT))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_f32vector)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+2)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<2)) + 1;
    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sF32VECTOR, n<<2);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
            result = ___SUBTYPED_FROM_START(___hp);
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<2), ___sF32VECTOR));
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    ___F64 fill = ___F64UNBOX(___ARG2);
    for (i=0; i<n; i++)
      ___F32VECTORSET(result,___FIX(i),fill)
  }
___RESULT = result;

   ___SET_R3(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L2__23__23_make_2d_f32vector)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_f32vector)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_f32vector)
___DEF_GLBL(___L2__23__23_make_2d_f32vector)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_f64vector
#undef ___PH_LBL0
#define ___PH_LBL0 490
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_f64vector)
___DEF_P_HLBL(___L1__23__23_make_2d_f64vector)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_f64vector)
   ___IF_NARGS_EQ(1,___SET_R2(___ABSENT))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_f64vector)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

___SIZE_TS i;
___SIZE_TS n = ___INT(___ARG1);
___SCMOBJ result;
if (n > ___CAST(___WORD, ___LMASK>>(___LF+3)))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n<<3)) + ___SUBTYPED_BODY;

#if ___WS == 4
    words++;
#endif

    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
        result = ___EXT(___alloc_scmobj) (___ps, ___sF64VECTOR, n<<3);
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
#if ___WS == 4
            result = ___SUBTYPED_FROM_BODY(___CAST(___WORD,___hp+___SUBTYPED_BODY+1)&~7);
#else
            result = ___SUBTYPED_FROM_START(___hp);
#endif
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<3), ___sF64VECTOR));
            ___hp += words;
          }
      }
  }
if (!___FIXNUMP(result) && ___ARG2 != ___ABSENT)
  {
    ___F64 fill = ___F64UNBOX(___ARG2);
    for (i=0; i<n; i++)
      ___F64VECTORSET(result,___FIX(i),fill)
  }
___RESULT = result;

   ___SET_R3(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R3)))
   ___GOTO(___L2__23__23_make_2d_f64vector)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_f64vector)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_f64vector)
___DEF_GLBL(___L2__23__23_make_2d_f64vector)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_machine_2d_code_2d_block
#undef ___PH_LBL0
#define ___PH_LBL0 493
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_machine_2d_code_2d_block)
___DEF_P_HLBL(___L1__23__23_make_2d_machine_2d_code_2d_block)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_machine_2d_code_2d_block)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_make_2d_machine_2d_code_2d_block)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_make_2d_machine_2d_code_2d_block)
   ___JUMPINT(___SET_NARGS(1),___PRC(959),___L___kernel_23_3)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_machine_2d_code_2d_block_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 496
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_machine_2d_code_2d_block_2d_ref)
___DEF_P_HLBL(___L1__23__23_machine_2d_code_2d_block_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_machine_2d_code_2d_block_2d_ref)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_machine_2d_code_2d_block_2d_ref)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_machine_2d_code_2d_block_2d_ref)
   ___JUMPINT(___SET_NARGS(2),___PRC(962),___L___kernel_23_4)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_machine_2d_code_2d_block_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 499
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_machine_2d_code_2d_block_2d_set_21_)
___DEF_P_HLBL(___L1__23__23_machine_2d_code_2d_block_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_machine_2d_code_2d_block_2d_set_21_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L__23__23_machine_2d_code_2d_block_2d_set_21_)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_machine_2d_code_2d_block_2d_set_21_)
   ___JUMPINT(___SET_NARGS(3),___PRC(965),___L___kernel_23_5)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_machine_2d_code_2d_block_2d_exec
#undef ___PH_LBL0
#define ___PH_LBL0 502
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_machine_2d_code_2d_block_2d_exec)
___DEF_P_HLBL(___L1__23__23_machine_2d_code_2d_block_2d_exec)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_machine_2d_code_2d_block_2d_exec)
   ___IF_NARGS_EQ(1,___PUSH(___R1) ___SET_R1(___FIX(0L)) ___SET_R2(___FIX(0L)) ___SET_R3(
___FIX(0L)))
   ___IF_NARGS_EQ(2,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___FIX(0L)) ___SET_R3(___FIX(
0L)))
   ___IF_NARGS_EQ(3,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___R3) ___SET_R3(___FIX(0L)
))
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,1,3,0)
___DEF_GLBL(___L__23__23_machine_2d_code_2d_block_2d_exec)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_machine_2d_code_2d_block_2d_exec)
   ___JUMPINT(___SET_NARGS(4),___PRC(968),___L___kernel_23_6)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_machine_2d_code_2d_block_2d_fixup
#undef ___PH_LBL0
#define ___PH_LBL0 505
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_machine_2d_code_2d_block_2d_fixup)
___DEF_P_HLBL(___L1__23__23_machine_2d_code_2d_block_2d_fixup)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_machine_2d_code_2d_block_2d_fixup)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L__23__23_machine_2d_code_2d_block_2d_fixup)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_machine_2d_code_2d_block_2d_fixup)
   ___JUMPINT(___SET_NARGS(3),___PRC(971),___L___kernel_23_7)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_machine_2d_code_2d_fixup
#undef ___PH_LBL0
#define ___PH_LBL0 508
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_machine_2d_code_2d_fixup)
___DEF_P_HLBL(___L1__23__23_machine_2d_code_2d_fixup)
___DEF_P_HLBL(___L2__23__23_machine_2d_code_2d_fixup)
___DEF_P_HLBL(___L3__23__23_machine_2d_code_2d_fixup)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_machine_2d_code_2d_fixup)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L__23__23_machine_2d_code_2d_fixup)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_machine_2d_code_2d_fixup)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(493),___L__23__23_make_2d_machine_2d_code_2d_block)
___DEF_SLBL(2,___L2__23__23_machine_2d_code_2d_fixup)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_machine_2d_code_2d_fixup)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(3),___PRC(505),___L__23__23_machine_2d_code_2d_block_2d_fixup)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_apply
#undef ___PH_LBL0
#define ___PH_LBL0 513
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_apply)
___DEF_P_HLBL(___L1__23__23_apply)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_apply)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_apply)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_apply)
{ ___SCMOBJ ___RESULT;

     ___SCMOBJ proc;
     ___SCMOBJ args;
     ___SCMOBJ lst;
     int na;

     ___POP_ARGS2(proc,args)

     lst = args;
     na = 0;

     while (___PAIRP(lst))
       {
         ___PUSH(___CAR(lst))
         lst = ___CDR(lst);
         na++;

         if (na > ___MAX_NB_ARGS)
           {
             ___ADJFP(-na); /* remove pushed arguments */

             ___PUSH_ARGS2(proc,args)

             ___COVER_APPLY_ARGUMENT_LIMIT;

             ___JUMPPRM(___SET_NARGS(2),
                        ___PRMCELL(___G__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception.prm))
           }
       }

     ___POP_ARGS_IN_REGS(na) /* load register arguments */

     ___COVER_APPLY_ARGUMENT_LIMIT_END;

     ___JUMPEXTNOTSAFE(___SET_NARGS(na),proc)

     ___RESULT = ___FAL; /* avoid a warning that ___RESULT is not set */

   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_values
#undef ___PH_LBL0
#define ___PH_LBL0 516
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_values)
___DEF_P_HLBL(___L1__23__23_make_2d_values)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_values)
   ___IF_NARGS_EQ(1,___SET_R2(___FIX(0L)))
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,1,1,0)
___DEF_GLBL(___L__23__23_make_2d_values)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_vector)
___DEF_SLBL(1,___L1__23__23_make_2d_values)
   ___SUBTYPESET(___R1,___FIX(5L))
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_values_2d_length
#undef ___PH_LBL0
#define ___PH_LBL0 519
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_values_2d_length)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_values_2d_length)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_values_2d_length)
   ___SET_R1(___VECTORLENGTH(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_values_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 521
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_values_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_values_2d_ref)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_values_2d_ref)
   ___SET_R1(___VECTORREF(___R1,___R2))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_values_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 523
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_values_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_values_2d_set_21_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L__23__23_values_2d_set_21_)
   ___VECTORSET(___R1,___R2,___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_closure_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 525
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_closure_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_closure_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_closure_3f_)
   ___SET_R1(___BOOLEAN(___CLOSUREP(___R1)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_closure
#undef ___PH_LBL0
#define ___PH_LBL0 527
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_closure)
___DEF_P_HLBL(___L1__23__23_make_2d_closure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_closure)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_make_2d_closure)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___FIXADD(___R2,___FIX(1L)))
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_make_2d_vector)
___DEF_SLBL(1,___L1__23__23_make_2d_closure)
   ___VECTORSET(___R1,___FIX(0L),___STK(-6))
   ___SUBTYPESET(___R1,___FIX(14L))
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_closure_2d_length
#undef ___PH_LBL0
#define ___PH_LBL0 530
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_closure_2d_length)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_closure_2d_length)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_closure_2d_length)
   ___SET_R1(___CLOSURELENGTH(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_closure_2d_code
#undef ___PH_LBL0
#define ___PH_LBL0 532
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_closure_2d_code)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_closure_2d_code)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_closure_2d_code)
   ___SET_R1(___CLOSURECODE(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_closure_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 534
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_closure_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_closure_2d_ref)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_closure_2d_ref)
   ___SET_R1(___CLOSUREREF(___R1,___R2))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_closure_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 536
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_closure_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_closure_2d_set_21_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L__23__23_closure_2d_set_21_)
   ___CLOSURESET(___R1,___R2,___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_subprocedure_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 538
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_subprocedure_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_subprocedure_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_subprocedure_3f_)
   ___SET_R1(___BOOLEAN(___SUBPROCEDUREP(___R1)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_subprocedure_2d_id
#undef ___PH_LBL0
#define ___PH_LBL0 540
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_subprocedure_2d_id)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_subprocedure_2d_id)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_subprocedure_2d_id)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   if (___TYP(___ARG1) == ___tSUBTYPED)
     {
       ___SCMOBJ *start = ___CAST(___SCMOBJ*,&___SUBTYPED_HEADER(___ARG1));
       ___SCMOBJ *ptr = start;
       while (!___TESTHEADERTAG(*ptr,___sVECTOR))
         ptr -= ___LABEL_SIZE;
       ptr += ___LABEL_SIZE;
       ___RESULT = ___FIX( (start-ptr)/___LABEL_SIZE );
     }
   else
     ___RESULT = ___FIX(0);

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_subprocedure_2d_parent
#undef ___PH_LBL0
#define ___PH_LBL0 542
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_subprocedure_2d_parent)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_subprocedure_2d_parent)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_subprocedure_2d_parent)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   if (___TYP(___ARG1) == ___tSUBTYPED)
     {
       ___SCMOBJ *start = ___CAST(___SCMOBJ*,&___SUBTYPED_HEADER(___ARG1));
       ___SCMOBJ *ptr = start;
       while (!___TESTHEADERTAG(*ptr,___sVECTOR))
         ptr -= ___LABEL_SIZE;
       ptr += ___LABEL_SIZE;
      ___RESULT = ___SUBTYPED_FROM_START(ptr);
     }
   else
     ___RESULT = ___FAL;

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_subprocedure_2d_nb_2d_parameters
#undef ___PH_LBL0
#define ___PH_LBL0 544
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_subprocedure_2d_nb_2d_parameters)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_subprocedure_2d_nb_2d_parameters)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_subprocedure_2d_nb_2d_parameters)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   ___RESULT = ___FIX(___PRD_NBPARMS(___SUBTYPED_HEADER(___ARG1)));

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_subprocedure_2d_nb_2d_closed
#undef ___PH_LBL0
#define ___PH_LBL0 546
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_subprocedure_2d_nb_2d_closed)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_subprocedure_2d_nb_2d_closed)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_subprocedure_2d_nb_2d_closed)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   ___RESULT = ___FIX(___PRD_NBCLOSED(___SUBTYPED_HEADER(___ARG1)));

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_subprocedure
#undef ___PH_LBL0
#define ___PH_LBL0 548
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_subprocedure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_subprocedure)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_make_2d_subprocedure)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

   {
     ___SCMOBJ *start = ___CAST(___SCMOBJ*,&___SUBTYPED_HEADER(___ARG1));
     ___SCMOBJ head = start[-___LABEL_SIZE];
     int i = ___INT(___ARG2);
     if (___TESTHEADERTAG(head,___sVECTOR) &&
         i >= 0 &&
         i < ___CAST(int,___HD_FIELDS(head)))
       ___RESULT = ___SUBTYPED_FROM_START(start+___LABEL_SIZE*i);
     else
       ___RESULT = ___FAL;
   }

   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_subprocedure_2d_parent_2d_info
#undef ___PH_LBL0
#define ___PH_LBL0 550
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_subprocedure_2d_parent_2d_info)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_subprocedure_2d_parent_2d_info)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_subprocedure_2d_parent_2d_info)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   if (___TYP(___ARG1) == ___tSUBTYPED)
     {
       ___SCMOBJ *start = ___CAST(___SCMOBJ*,&___SUBTYPED_HEADER(___ARG1));
       ___SCMOBJ *ptr = start;
       while (!___TESTHEADERTAG(*ptr,___sVECTOR))
         ptr -= ___LABEL_SIZE;
       ___RESULT = (ptr+1)[___LABEL_ENTRY_OR_DESCR];
     }
   else
     ___RESULT = ___FAL;

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_subprocedure_2d_parent_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 552
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_subprocedure_2d_parent_2d_name)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_subprocedure_2d_parent_2d_name)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_subprocedure_2d_parent_2d_name)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   if (___TYP(___ARG1) == ___tSUBTYPED)
     {
       ___SCMOBJ *start = ___CAST(___SCMOBJ*,&___SUBTYPED_HEADER(___ARG1));
       ___SCMOBJ *ptr = start;
       while (!___TESTHEADERTAG(*ptr,___sVECTOR))
         ptr -= ___LABEL_SIZE;
       ___RESULT = (ptr+1)[___LABEL_HOST_LABEL];
     }
   else
     ___RESULT = ___FAL;

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_explode_2d_continuation
#undef ___PH_LBL0
#define ___PH_LBL0 554
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_explode_2d_continuation)
___DEF_P_HLBL(___L1__23__23_explode_2d_continuation)
___DEF_P_HLBL(___L2__23__23_explode_2d_continuation)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_explode_2d_continuation)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_explode_2d_continuation)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_continuation_2d_frame)
___DEF_SLBL(1,___L1__23__23_explode_2d_continuation)
   ___SET_R2(___CONTINUATIONDENV(___STK(-6)))
   ___BEGIN_ALLOC_VECTOR(2UL)
   ___ADD_VECTOR_ELEM(0,___R1)
   ___ADD_VECTOR_ELEM(1,___R2)
   ___END_ALLOC_VECTOR(2)
   ___SET_R1(___GET_VECTOR(2))
   ___ADJFP(-7)
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2__23__23_explode_2d_continuation)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_frame
#undef ___PH_LBL0
#define ___PH_LBL0 558
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_frame)
___DEF_P_HLBL(___L1__23__23_continuation_2d_frame)
___DEF_P_HLBL(___L2__23__23_continuation_2d_frame)
___DEF_P_HLBL(___L3__23__23_continuation_2d_frame)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_frame)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_frame)
   ___SET_R2(___VECTORREF(___R1,___FIX(0L)))
   ___IF(___EQP(___R2,___VOID))
   ___GOTO(___L4__23__23_continuation_2d_frame)
   ___END_IF
   ___IF(___FRAMEP(___R2))
   ___GOTO(___L4__23__23_continuation_2d_frame)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_continuation_2d_frame)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(0),___PRC(393),___L__23__23_gc)
___DEF_SLBL(2,___L2__23__23_continuation_2d_frame)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_continuation_2d_frame)
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_continuation_2d_frame)
___DEF_GLBL(___L4__23__23_continuation_2d_frame)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_frame_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 563
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_frame_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_frame_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_frame_2d_set_21_)
   ___CONTINUATIONFRAMESET(___R1,___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_denv
#undef ___PH_LBL0
#define ___PH_LBL0 565
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_denv)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_denv)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_denv)
   ___SET_R1(___CONTINUATIONDENV(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_denv_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 567
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_denv_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_denv_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_denv_2d_set_21_)
   ___CONTINUATIONDENVSET(___R1,___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_explode_2d_frame
#undef ___PH_LBL0
#define ___PH_LBL0 569
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_explode_2d_frame)
___DEF_P_HLBL(___L1__23__23_explode_2d_frame)
___DEF_P_HLBL(___L2__23__23_explode_2d_frame)
___DEF_P_HLBL(___L3__23__23_explode_2d_frame)
___DEF_P_HLBL(___L4__23__23_explode_2d_frame)
___DEF_P_HLBL(___L5__23__23_explode_2d_frame)
___DEF_P_HLBL(___L6__23__23_explode_2d_frame)
___DEF_P_HLBL(___L7__23__23_explode_2d_frame)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_explode_2d_frame)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_explode_2d_frame)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_frame_2d_fs)
___DEF_SLBL(1,___L1__23__23_explode_2d_frame)
   ___SET_STK(-5,___R1)
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___SET_R0(___LBL(2))
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_make_2d_vector)
___DEF_SLBL(2,___L2__23__23_explode_2d_frame)
   ___SET_STK(-4,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(3))
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_frame_2d_ret)
___DEF_SLBL(3,___L3__23__23_explode_2d_frame)
   ___VECTORSET(___STK(-4),___FIX(0L),___R1)
   ___SET_R3(___STK(-5))
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_explode_2d_frame)
   ___GOTO(___L9__23__23_explode_2d_frame)
___DEF_SLBL(5,___L5__23__23_explode_2d_frame)
   ___VECTORSET(___STK(-5),___STK(-4),___R1)
___DEF_GLBL(___L8__23__23_explode_2d_frame)
   ___SET_R3(___FIXSUB(___STK(-4),___FIX(1L)))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(6)
___DEF_SLBL(6,___L6__23__23_explode_2d_frame)
___DEF_GLBL(___L9__23__23_explode_2d_frame)
   ___IF(___NOT(___FIXLT(___FIX(0L),___R3)))
   ___GOTO(___L10__23__23_explode_2d_frame)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___R3)
   ___SET_R0(___LBL(7))
   ___ADJFP(8)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_frame_2d_slot_2d_live_3f_)
___DEF_SLBL(7,___L7__23__23_explode_2d_frame)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L8__23__23_explode_2d_frame)
   ___END_IF
   ___SET_R2(___STK(-4))
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(5))
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_frame_2d_ref)
___DEF_GLBL(___L10__23__23_explode_2d_frame)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_frame_2d_ret
#undef ___PH_LBL0
#define ___PH_LBL0 578
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_frame_2d_ret)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_frame_2d_ret)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_frame_2d_ret)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   ___SCMOBJ ra = ___FIELD(___ARG1,0);

   if (ra == ___GSTATE->internal_return)
     ra = ___FIELD(___ARG1,___FRAME_RETI_RA);

   ___RESULT = ra;

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_ret
#undef ___PH_LBL0
#define ___PH_LBL0 580
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_ret)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_ret)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_ret)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   ___SCMOBJ frame = ___FIELD(___ARG1,___CONTINUATION_FRAME);
   ___SCMOBJ ra;

   if (___TYP(frame) == ___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       if (ra == ___GSTATE->internal_return)
         ra = ___FIELD(frame,___FRAME_RETI_RA);
     }
   else
     {
       /* continuation frame is in the stack */

       ___SCMOBJ *fp = ___CAST(___SCMOBJ*,frame);

       ra = fp[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ra = fp[-___RETI_RA];
     }

   ___RESULT = ra;

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_return_2d_fs
#undef ___PH_LBL0
#define ___PH_LBL0 582
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_return_2d_fs)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_return_2d_fs)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_return_2d_fs)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   ___SCMOBJ ra = ___ARG1;
   int fs;

   ___RETN_GET_FS(ra,fs)

   ___RESULT = ___FIX(fs);

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_frame_2d_fs
#undef ___PH_LBL0
#define ___PH_LBL0 584
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_frame_2d_fs)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_frame_2d_fs)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_frame_2d_fs)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   ___SCMOBJ ra = ___FIELD(___ARG1,0);
   int fs;

   if (ra == ___GSTATE->internal_return)
     ___RETI_GET_FS(___FIELD(___ARG1,___FRAME_RETI_RA),fs)
   else
     ___RETN_GET_FS(ra,fs)

   ___RESULT = ___FIX(fs);

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_fs
#undef ___PH_LBL0
#define ___PH_LBL0 586
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_fs)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_fs)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_fs)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   ___SCMOBJ frame = ___FIELD(___ARG1,___CONTINUATION_FRAME);
   ___SCMOBJ ra;
   int fs;

   if (___TYP(frame) == ___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS(___FIELD(frame,___FRAME_RETI_RA),fs)
       else
         ___RETN_GET_FS(ra,fs)
     }
   else
     {
       /* continuation frame is in the stack */

       ___SCMOBJ *fp = ___CAST(___SCMOBJ*,frame);

       ra = fp[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS(fp[-___RETI_RA],fs)
       else
         ___RETN_GET_FS(ra,fs)
     }

   ___RESULT = ___FIX(fs);

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_frame_2d_link
#undef ___PH_LBL0
#define ___PH_LBL0 588
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_frame_2d_link)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_frame_2d_link)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_frame_2d_link)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   ___SCMOBJ ra = ___FIELD(___ARG1,0);
   int fs;
   int link;

   if (ra == ___GSTATE->internal_return)
     ___RETI_GET_FS_LINK(___BODY_AS(___ARG1,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
   else
     ___RETN_GET_FS_LINK(ra,fs,link)

   ___RESULT = ___FIX(link+1);

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_link
#undef ___PH_LBL0
#define ___PH_LBL0 590
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_link)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_link)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_link)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   ___SCMOBJ frame = ___FIELD(___ARG1,___CONTINUATION_FRAME);
   ___SCMOBJ ra;
   int fs;
   int link;

   if (___TYP(frame) == ___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___BODY_AS(frame,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)
     }
   else
     {
       /* continuation frame is in the stack */

       ra = ___CAST(___SCMOBJ*,frame)[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___CAST(___SCMOBJ*,frame)[-___RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)
     }

   ___RESULT = ___FIX(link+1);

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_frame_2d_slot_2d_live_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 592
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_frame_2d_slot_2d_live_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_frame_2d_slot_2d_live_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_frame_2d_slot_2d_live_3f_)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

   int i = ___INT(___ARG2);
   ___SCMOBJ ra = ___FIELD(___ARG1,0);
   int fs;
   int link;
   ___WORD gcmap;
   ___WORD *nextgcmap = 0;

   if (ra == ___GSTATE->internal_return)
     ___RETI_GET_FS_LINK_GCMAP(___BODY_AS(___ARG1,___tSUBTYPED)[___FRAME_RETI_RA],fs,link,gcmap,nextgcmap)
   else
     ___RETN_GET_FS_LINK_GCMAP(ra,fs,link,gcmap,nextgcmap)

   if (i > ___WORD_WIDTH)
     gcmap = nextgcmap[(i-1) >> ___LOG_WORD_WIDTH];

   ___RESULT = ___BOOLEAN(gcmap & (1 << ((i-1) & (___WORD_WIDTH-1))));

   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_slot_2d_live_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 594
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_slot_2d_live_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_slot_2d_live_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_slot_2d_live_3f_)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

   ___SCMOBJ frame = ___FIELD(___ARG1,___CONTINUATION_FRAME);
   int i = ___INT(___ARG2);
   ___SCMOBJ ra;
   int fs;
   int link;
   ___WORD gcmap;
   ___WORD *nextgcmap = 0;

   if (___TYP(frame) == ___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK_GCMAP(___FIELD(frame,___FRAME_RETI_RA),fs,link,gcmap,nextgcmap)
       else
         ___RETN_GET_FS_LINK_GCMAP(ra,fs,link,gcmap,nextgcmap)
     }
   else
     {
       /* continuation frame is in the stack */

       ___SCMOBJ *fp = ___CAST(___SCMOBJ*,frame);

       ra = fp[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK_GCMAP(fp[-___RETI_RA],fs,link,gcmap,nextgcmap)
       else
         ___RETN_GET_FS_LINK_GCMAP(ra,fs,link,gcmap,nextgcmap)
     }

   if (i > ___WORD_WIDTH)
     gcmap = nextgcmap[(i-1) >> ___LOG_WORD_WIDTH];

   ___RESULT = ___BOOLEAN(gcmap & (1 << ((i-1) & (___WORD_WIDTH-1))));

   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_frame_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 596
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_frame_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_frame_2d_ref)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_frame_2d_ref)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

   int i = ___INT(___ARG2);
   ___SCMOBJ ra = ___FIELD(___ARG1,0);
   int fs;
   int link;

   if (ra == ___GSTATE->internal_return)
     ___RETI_GET_FS_LINK(___BODY_AS(___ARG1,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
   else
     ___RETN_GET_FS_LINK(ra,fs,link)

   ___RESULT = ___BODY_AS(___ARG1,___tSUBTYPED)[fs-i+1];  /* what if i==link and frame is first in section???? */
#if 0
   if (i == link) ___RESULT = ___FIX(999999);/***********/
#endif

   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_frame_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 598
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_frame_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_frame_2d_set_21_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L__23__23_frame_2d_set_21_)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
#define ___ARG3 ___R3
{ ___SCMOBJ ___RESULT;

   int i = ___INT(___ARG2);
   ___SCMOBJ ra = ___FIELD(___ARG1,0);
   int fs;
   int link;

   if (ra == ___GSTATE->internal_return)
     ___RETI_GET_FS_LINK(___BODY_AS(___ARG1,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
   else
     ___RETN_GET_FS_LINK(ra,fs,link)

   ___BODY_AS(___ARG1,___tSUBTYPED)[fs-i+1] = ___ARG3;  /* what if i==link and frame is first in section???? */

   ___RESULT = ___VOID;

   ___SET_R1(___RESULT)
}
#undef ___ARG3
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 600
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_ref)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_ref)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

   ___SCMOBJ cont = ___ARG1;
   int i = ___INT(___ARG2);
   ___SCMOBJ frame = ___FIELD(cont,___CONTINUATION_FRAME);
   ___SCMOBJ ra;
   int fs;
   int link;

   if (___TYP(frame) == ___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___BODY_AS(frame,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       ___RESULT = ___BODY_AS(frame,___tSUBTYPED)[fs-i+1];  /* what if i==link and frame is first in section???? */
#if 0
      if (i == link) ___RESULT = ___FIX(999999);/***********/
#endif
     }
   else
     {
       /* continuation frame is in the stack */

       ra = ___CAST(___SCMOBJ*,frame)[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___CAST(___SCMOBJ*,frame)[-___RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       ___RESULT = ___CAST(___SCMOBJ*,frame)[___FRAME_SPACE(fs)-i];  /* what if i==link and frame is first in section???? */
#if 0
      if (i == link) ___RESULT = ___FIX(999999);/***********/
#endif
     }

   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 602
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_set_21_)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_set_21_)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
#define ___ARG3 ___R3
{ ___SCMOBJ ___RESULT;

   ___SCMOBJ cont = ___ARG1;
   int i = ___INT(___ARG2);
   ___SCMOBJ val = ___ARG3;
   ___SCMOBJ frame = ___FIELD(cont,___CONTINUATION_FRAME);
   ___SCMOBJ ra;
   int fs;
   int link;

   if (___TYP(frame) == ___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___BODY_AS(frame,___tSUBTYPED)[___FRAME_RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       ___BODY_AS(frame,___tSUBTYPED)[fs-i+1] = val;  /* what if i==link and frame is first in section???? */
     }
   else
     {
       /* continuation frame is in the stack */

       ra = ___CAST(___SCMOBJ*,frame)[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___CAST(___SCMOBJ*,frame)[-___RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       ___CAST(___SCMOBJ*,frame)[___FRAME_SPACE(fs)-i] = val;  /* what if i==link and frame is first in section???? */
#if 0
      if (i == link) ___RESULT = ___FIX(999999);/***********/
#endif
     }

   ___RESULT = cont;

   ___SET_R1(___RESULT)
}
#undef ___ARG3
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_frame
#undef ___PH_LBL0
#define ___PH_LBL0 604
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_frame)
___DEF_P_HLBL(___L1__23__23_make_2d_frame)
___DEF_P_HLBL(___L2__23__23_make_2d_frame)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_frame)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_make_2d_frame)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_return_2d_fs)
___DEF_SLBL(1,___L1__23__23_make_2d_frame)
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___SET_R2(___FIX(0L))
   ___SET_R0(___LBL(2))
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_vector)
___DEF_SLBL(2,___L2__23__23_make_2d_frame)
   ___VECTORSET(___R1,___FIX(0L),___STK(-6))
   ___SUBTYPESET(___R1,___FIX(10L))
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_continuation
#undef ___PH_LBL0
#define ___PH_LBL0 608
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_continuation)
___DEF_P_HLBL(___L1__23__23_make_2d_continuation)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_continuation)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_make_2d_continuation)
   ___SET_R1(___MAKECONTINUATION(___R1,___R2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_make_2d_continuation)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_copy
#undef ___PH_LBL0
#define ___PH_LBL0 611
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_copy)
___DEF_P_HLBL(___L1__23__23_continuation_2d_copy)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_copy)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_copy)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

          ___SCMOBJ cont = ___ARG1;
          ___SCMOBJ frame = ___FIELD(cont,___CONTINUATION_FRAME);
          ___SCMOBJ denv  = ___FIELD(cont,___CONTINUATION_DENV);

          ___hp[0]=___MAKE_HD_WORDS(___CONTINUATION_SIZE,___sCONTINUATION);
          ___ADD_VECTOR_ELEM(0,frame);
          ___ADD_VECTOR_ELEM(1,denv);
          ___hp+=___CONTINUATION_SIZE+1;
          ___RESULT = ___GET_VECTOR(___CONTINUATION_SIZE);

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(377),___L__23__23_check_2d_heap)
___DEF_SLBL(1,___L1__23__23_continuation_2d_copy)
   ___SET_R1(___STK(-6))
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_next_21_
#undef ___PH_LBL0
#define ___PH_LBL0 614
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_next_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_next_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_next_21_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

#define DYNAMIC_ENV_BIND_DENV 2

   ___SCMOBJ cont = ___ARG1;
   ___SCMOBJ frame = ___FIELD(cont,___CONTINUATION_FRAME);
   ___SCMOBJ denv  = ___FIELD(cont,___CONTINUATION_DENV);
   ___SCMOBJ ra;
   ___SCMOBJ *fp, frame_ra, next_frame;
   int fs;
   int link;

   if (___TYP(frame)==___tSUBTYPED)
     {
       /* continuation frame is in the heap */

       ra = ___FIELD(frame,0);

       fp = ___BODY_AS(frame,___tSUBTYPED);

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(fp[___FRAME_RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       fp += fs+1;

       if (ra == ___GSTATE->dynamic_env_bind_return)
         denv = fp[-DYNAMIC_ENV_BIND_DENV];

       next_frame = fp[-link-1];

       if (next_frame == ___END_OF_CONT_MARKER)
         ___RESULT = ___FAL;
       else
         {
           ___FIELD(cont,___CONTINUATION_FRAME) = next_frame;
           ___FIELD(cont,___CONTINUATION_DENV) = denv;
           ___RESULT = cont;
         }
     }
   else
     {
       /* continuation frame is in the stack */

       ra = ___CAST(___SCMOBJ*,frame)[___FRAME_STACK_RA];

       if (ra == ___GSTATE->internal_return)
         ___RETI_GET_FS_LINK(___CAST(___SCMOBJ*,frame)[-___RETI_RA],fs,link)
       else
         ___RETN_GET_FS_LINK(ra,fs,link)

       fp = ___CAST(___SCMOBJ*,frame)+___FRAME_SPACE(fs);
       frame_ra = fp[-link-1];

       if (ra == ___GSTATE->dynamic_env_bind_return)
         denv = fp[-DYNAMIC_ENV_BIND_DENV];

       if (frame_ra == ___GSTATE->handler_break)
         {
           /* first frame of that section */

           next_frame = fp[___BREAK_FRAME_NEXT];
         }
       else
         {
           /* not the first frame of that section */

           *fp = frame_ra;
           next_frame = ___CAST(___SCMOBJ,fp);
         }

       if (next_frame == ___END_OF_CONT_MARKER)
         ___RESULT = ___FAL;
       else
         {
           ___FIELD(cont,___CONTINUATION_FRAME) = next_frame;
           ___FIELD(cont,___CONTINUATION_DENV) = denv;
           ___RESULT = cont;
         }
     }

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_next
#undef ___PH_LBL0
#define ___PH_LBL0 616
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_next)
___DEF_P_HLBL(___L1__23__23_continuation_2d_next)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_next)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_next)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(1),___PRC(611),___L__23__23_continuation_2d_copy)
___DEF_SLBL(1,___L1__23__23_continuation_2d_next)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(614),___L__23__23_continuation_2d_next_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_continuation_2d_last
#undef ___PH_LBL0
#define ___PH_LBL0 619
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_continuation_2d_last)
___DEF_P_HLBL(___L1__23__23_continuation_2d_last)
___DEF_P_HLBL(___L2__23__23_continuation_2d_last)
___DEF_P_HLBL(___L3__23__23_continuation_2d_last)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_continuation_2d_last)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_continuation_2d_last)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_continuation_2d_last)
   ___GOTO(___L4__23__23_continuation_2d_last)
___DEF_SLBL(2,___L2__23__23_continuation_2d_last)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L5__23__23_continuation_2d_last)
   ___END_IF
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_continuation_2d_last)
___DEF_GLBL(___L4__23__23_continuation_2d_last)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_continuation_2d_next)
___DEF_GLBL(___L5__23__23_continuation_2d_last)
   ___SET_R1(___STK(-6))
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_symbol_2d_table
#undef ___PH_LBL0
#define ___PH_LBL0 624
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_symbol_2d_table)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_symbol_2d_table)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_symbol_2d_table)
{ ___SCMOBJ ___RESULT;
___RESULT = ___GSTATE->symbol_table;
   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_keyword_2d_table
#undef ___PH_LBL0
#define ___PH_LBL0 626
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_keyword_2d_table)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_keyword_2d_table)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_keyword_2d_table)
{ ___SCMOBJ ___RESULT;
___RESULT = ___GSTATE->keyword_table;
   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_interned_2d_symbol
#undef ___PH_LBL0
#define ___PH_LBL0 628
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_interned_2d_symbol)
___DEF_P_HLBL(___L1__23__23_make_2d_interned_2d_symbol)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_interned_2d_symbol)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_make_2d_interned_2d_symbol)
   ___SET_R2(___TRU)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_make_2d_interned_2d_symbol)
   ___JUMPINT(___SET_NARGS(2),___PRC(634),___L__23__23_make_2d_interned_2d_symkey)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_interned_2d_keyword
#undef ___PH_LBL0
#define ___PH_LBL0 631
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_interned_2d_keyword)
___DEF_P_HLBL(___L1__23__23_make_2d_interned_2d_keyword)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_interned_2d_keyword)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_make_2d_interned_2d_keyword)
   ___SET_R2(___FAL)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_make_2d_interned_2d_keyword)
   ___JUMPINT(___SET_NARGS(2),___PRC(634),___L__23__23_make_2d_interned_2d_symkey)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_interned_2d_symkey
#undef ___PH_LBL0
#define ___PH_LBL0 634
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_interned_2d_symkey)
___DEF_P_HLBL(___L1__23__23_make_2d_interned_2d_symkey)
___DEF_P_HLBL(___L2__23__23_make_2d_interned_2d_symkey)
___DEF_P_HLBL(___L3__23__23_make_2d_interned_2d_symkey)
___DEF_P_HLBL(___L4__23__23_make_2d_interned_2d_symkey)
___DEF_P_HLBL(___L5__23__23_make_2d_interned_2d_symkey)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_interned_2d_symkey)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_make_2d_interned_2d_symkey)
   ___GOTO(___L6__23__23_make_2d_interned_2d_symkey)
___DEF_SLBL(1,___L1__23__23_make_2d_interned_2d_symkey)
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_make_2d_interned_2d_symkey)
___DEF_GLBL(___L6__23__23_make_2d_interned_2d_symkey)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_make_2d_interned_2d_symkey)
   ___SET_R0(___LBL(4))
   ___JUMPINT(___SET_NARGS(2),___PRC(974),___L___kernel_23_8)
___DEF_SLBL(4,___L4__23__23_make_2d_interned_2d_symkey)
   ___IF(___FIXNUMP(___R1))
   ___GOTO(___L7__23__23_make_2d_interned_2d_symkey)
   ___END_IF
   ___POLL(5)
___DEF_SLBL(5,___L5__23__23_make_2d_interned_2d_symkey)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___DEF_GLBL(___L7__23__23_make_2d_interned_2d_symkey)
   ___SET_R0(___LBL(1))
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_find_2d_interned_2d_symbol
#undef ___PH_LBL0
#define ___PH_LBL0 641
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_find_2d_interned_2d_symbol)
___DEF_P_HLBL(___L1__23__23_find_2d_interned_2d_symbol)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_find_2d_interned_2d_symbol)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_find_2d_interned_2d_symbol)
   ___SET_R2(___TRU)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_find_2d_interned_2d_symbol)
   ___JUMPINT(___SET_NARGS(2),___PRC(647),___L__23__23_find_2d_interned_2d_symkey)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_find_2d_interned_2d_keyword
#undef ___PH_LBL0
#define ___PH_LBL0 644
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_find_2d_interned_2d_keyword)
___DEF_P_HLBL(___L1__23__23_find_2d_interned_2d_keyword)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_find_2d_interned_2d_keyword)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_find_2d_interned_2d_keyword)
   ___SET_R2(___FAL)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_find_2d_interned_2d_keyword)
   ___JUMPINT(___SET_NARGS(2),___PRC(647),___L__23__23_find_2d_interned_2d_symkey)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_find_2d_interned_2d_symkey
#undef ___PH_LBL0
#define ___PH_LBL0 647
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_find_2d_interned_2d_symkey)
___DEF_P_HLBL(___L1__23__23_find_2d_interned_2d_symkey)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_find_2d_interned_2d_symkey)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_find_2d_interned_2d_symkey)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_find_2d_interned_2d_symkey)
   ___JUMPINT(___SET_NARGS(2),___PRC(977),___L___kernel_23_9)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_global_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 650
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_global_2d_var)
___DEF_P_HLBL(___L1__23__23_make_2d_global_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_global_2d_var)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_make_2d_global_2d_var)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;
___RESULT = ___make_global_var (___ARG1);
   ___SET_R2(___RESULT)
}
#undef ___ARG1
   ___IF(___NOT(___FIXNUMP(___R2)))
   ___GOTO(___L2__23__23_make_2d_global_2d_var)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_SLBL(1,___L1__23__23_make_2d_global_2d_var)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_make_2d_global_2d_var)
___DEF_GLBL(___L2__23__23_make_2d_global_2d_var)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_global_2d_var_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 653
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_global_2d_var_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_global_2d_var_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_global_2d_var_3f_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;
___RESULT = ___BOOLEAN(___GLOBALVARSTRUCT(___ARG1) != 0);
   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_global_2d_var_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 655
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_global_2d_var_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_global_2d_var_2d_ref)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_global_2d_var_2d_ref)
   ___SET_R1(___GLOBALVARREF(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_global_2d_var_2d_primitive_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 657
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_global_2d_var_2d_primitive_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_global_2d_var_2d_primitive_2d_ref)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_global_2d_var_2d_primitive_2d_ref)
   ___SET_R1(___GLOBALVARPRIMREF(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_global_2d_var_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 659
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_global_2d_var_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_global_2d_var_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_global_2d_var_2d_set_21_)
   ___GLOBALVARSET(___R1,___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_global_2d_var_2d_primitive_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 661
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_global_2d_var_2d_primitive_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_global_2d_var_2d_primitive_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_global_2d_var_2d_primitive_2d_set_21_)
   ___GLOBALVARPRIMSET(___R1,___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_object_2d__3e_global_2d_var_2d__3e_identifier
#undef ___PH_LBL0
#define ___PH_LBL0 663
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
___DEF_P_HLBL(___L1__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
___DEF_P_HLBL(___L2__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
___DEF_P_HLBL(___L3__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
   ___SET_STK(1,___R0)
   ___SET_R2(___FAL)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(2),___PRC(668),___L__23__23_object_2d__3e_global_2d_var)
___DEF_SLBL(2,___L2__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_object_2d__3e_global_2d_var_2d__3e_identifier)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(1),___PRC(670),___L__23__23_global_2d_var_2d__3e_identifier)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_object_2d__3e_global_2d_var
#undef ___PH_LBL0
#define ___PH_LBL0 668
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_object_2d__3e_global_2d_var)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_object_2d__3e_global_2d_var)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_object_2d__3e_global_2d_var)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;
___RESULT = ___obj_to_global_var (___ARG1, !___FALSEP(___ARG2));
   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_global_2d_var_2d__3e_identifier
#undef ___PH_LBL0
#define ___PH_LBL0 670
#undef ___PD_ALL
#define ___PD_ALL ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_R0
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_global_2d_var_2d__3e_identifier)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_global_2d_var_2d__3e_identifier)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_global_2d_var_2d__3e_identifier)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_foreign
#undef ___PH_LBL0
#define ___PH_LBL0 672
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_foreign)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_foreign)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_foreign)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_foreign)
   ___SET_STK(1,___R1)
   ___SET_R1(___SYM_foreign)
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_foreign)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_foreign_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 675
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_foreign_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_foreign_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_foreign_3f_)
   ___SET_R1(___BOOLEAN(___FOREIGNP(___R1)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_foreign_2d_tags
#undef ___PH_LBL0
#define ___PH_LBL0 677
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_foreign_2d_tags)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_foreign_2d_tags)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_foreign_2d_tags)
   ___SET_R1(___FOREIGNTAGS(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_foreign_2d_tags
#undef ___PH_LBL0
#define ___PH_LBL0 679
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_foreign_2d_tags)
___DEF_P_HLBL(___L1_foreign_2d_tags)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_foreign_2d_tags)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_foreign_2d_tags)
   ___IF(___FOREIGNP(___R1))
   ___GOTO(___L2_foreign_2d_tags)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_foreign_2d_tags)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(672),___L0__23__23_fail_2d_check_2d_foreign)
___DEF_GLBL(___L2_foreign_2d_tags)
   ___SET_R1(___FOREIGNTAGS(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_foreign_2d_released_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 682
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_foreign_2d_released_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_foreign_2d_released_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_foreign_2d_released_3f_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   ___RESULT = ___BOOLEAN(___CAST(void*,___FIELD(___ARG1,___FOREIGN_PTR)) == 0);

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_foreign_2d_released_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 684
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_foreign_2d_released_3f_)
___DEF_P_HLBL(___L1_foreign_2d_released_3f_)
___DEF_P_HLBL(___L2_foreign_2d_released_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_foreign_2d_released_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_foreign_2d_released_3f_)
   ___IF(___NOT(___FOREIGNP(___R1)))
   ___GOTO(___L3_foreign_2d_released_3f_)
   ___END_IF
   ___POLL(1)
___DEF_SLBL(1,___L1_foreign_2d_released_3f_)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_foreign_2d_released_3f_)
___DEF_GLBL(___L3_foreign_2d_released_3f_)
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(2)
___DEF_SLBL(2,___L2_foreign_2d_released_3f_)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(672),___L0__23__23_fail_2d_check_2d_foreign)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_foreign_2d_release_21_
#undef ___PH_LBL0
#define ___PH_LBL0 688
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_foreign_2d_release_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_foreign_2d_release_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_foreign_2d_release_21_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;
___RESULT = ___release_foreign (___ARG1);
   ___SET_R2(___RESULT)
}
#undef ___ARG1
   ___IF(___EQP(___R2,___FIX(0L)))
   ___GOTO(___L1__23__23_foreign_2d_release_21_)
   ___END_IF
   ___SET_STK(1,___FAL)
   ___SET_R3(___R1)
   ___SET_R1(___R2)
   ___SET_R2(___PRC(690))
   ___ADJFP(1)
   ___SET_NARGS(4) ___JUMPINT(___NOTHING,___PRC(234),___L0__23__23_raise_2d_os_2d_exception)
___DEF_GLBL(___L1__23__23_foreign_2d_release_21_)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_foreign_2d_release_21_
#undef ___PH_LBL0
#define ___PH_LBL0 690
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_foreign_2d_release_21_)
___DEF_P_HLBL(___L1_foreign_2d_release_21_)
___DEF_P_HLBL(___L2_foreign_2d_release_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_foreign_2d_release_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_foreign_2d_release_21_)
   ___IF(___NOT(___FOREIGNP(___R1)))
   ___GOTO(___L3_foreign_2d_release_21_)
   ___END_IF
   ___POLL(1)
___DEF_SLBL(1,___L1_foreign_2d_release_21_)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_foreign_2d_release_21_)
___DEF_GLBL(___L3_foreign_2d_release_21_)
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(2)
___DEF_SLBL(2,___L2_foreign_2d_release_21_)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(672),___L0__23__23_fail_2d_check_2d_foreign)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_foreign_2d_address
#undef ___PH_LBL0
#define ___PH_LBL0 694
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_foreign_2d_address)
___DEF_P_HLBL(___L1__23__23_foreign_2d_address)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_foreign_2d_address)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_foreign_2d_address)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_foreign_2d_address)
   ___JUMPINT(___SET_NARGS(1),___PRC(980),___L___kernel_23_10)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_foreign_2d_address
#undef ___PH_LBL0
#define ___PH_LBL0 697
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_foreign_2d_address)
___DEF_P_HLBL(___L1_foreign_2d_address)
___DEF_P_HLBL(___L2_foreign_2d_address)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_foreign_2d_address)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_foreign_2d_address)
   ___IF(___NOT(___FOREIGNP(___R1)))
   ___GOTO(___L3_foreign_2d_address)
   ___END_IF
   ___POLL(1)
___DEF_SLBL(1,___L1_foreign_2d_address)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_foreign_2d_address)
___DEF_GLBL(___L3_foreign_2d_address)
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(2)
___DEF_SLBL(2,___L2_foreign_2d_address)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(672),___L0__23__23_fail_2d_check_2d_foreign)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_process_2d_statistics
#undef ___PH_LBL0
#define ___PH_LBL0 701
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_process_2d_statistics)
___DEF_P_HLBL(___L1__23__23_process_2d_statistics)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_process_2d_statistics)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_process_2d_statistics)
   ___GOTO(___L2__23__23_process_2d_statistics)
___DEF_SLBL(1,___L1__23__23_process_2d_statistics)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
___DEF_GLBL(___L2__23__23_process_2d_statistics)
{ ___SCMOBJ ___RESULT;

   ___virtual_machine_state ___vms = ___VMSTATE_FROM_PSTATE(___ps);
   ___F64 user, sys, real;
   ___SIZE_TS minflt, majflt;
   ___F64 n = ___bytes_allocated (___PSPNC);
   ___SCMOBJ result;

   ___FRAME_STORE_RA(___R0)
   ___W_ALL
   result = ___EXT(___alloc_scmobj) (___ps, ___sF64VECTOR, 20<<3);
   ___R_ALL
   ___SET_R0(___FRAME_FETCH_RA)

    if (!___FIXNUMP(result))
    {
      n = ___bytes_allocated (___PSPNC) - n;

      ___process_times (&user, &sys, &real);
      ___vm_stats (&minflt, &majflt);

      ___F64VECTORSET(result,___FIX(0),user)
      ___F64VECTORSET(result,___FIX(1),sys)
      ___F64VECTORSET(result,___FIX(2),real)
      ___F64VECTORSET(result,___FIX(3),___vms->mem.gc_user_time_)
      ___F64VECTORSET(result,___FIX(4),___vms->mem.gc_sys_time_)
      ___F64VECTORSET(result,___FIX(5),___vms->mem.gc_real_time_)
      ___F64VECTORSET(result,___FIX(6),___vms->mem.nb_gcs_)
      ___F64VECTORSET(result,___FIX(7),___bytes_allocated (___PSPNC))
      ___F64VECTORSET(result,___FIX(8),(2*(1+2)<<___LWS))
      ___F64VECTORSET(result,___FIX(9),n)
      ___F64VECTORSET(result,___FIX(10),minflt)
      ___F64VECTORSET(result,___FIX(11),majflt)
      ___F64VECTORSET(result,___FIX(12),___vms->mem.latest_gc_user_time_)
      ___F64VECTORSET(result,___FIX(13),___vms->mem.latest_gc_sys_time_)
      ___F64VECTORSET(result,___FIX(14),___vms->mem.latest_gc_real_time_)
      ___F64VECTORSET(result,___FIX(15),___vms->mem.latest_gc_heap_size_)
      ___F64VECTORSET(result,___FIX(16),___vms->mem.latest_gc_alloc_)
      ___F64VECTORSET(result,___FIX(17),___vms->mem.latest_gc_live_)
      ___F64VECTORSET(result,___FIX(18),___vms->mem.latest_gc_movable_)
      ___F64VECTORSET(result,___FIX(19),___vms->mem.latest_gc_still_)

      ___still_obj_refcount_dec (result);
   }

   ___RESULT = result;

   ___SET_R1(___RESULT)
}
   ___IF(___NOT(___FIXNUMP(___R1)))
   ___GOTO(___L3__23__23_process_2d_statistics)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
   ___JUMPINT(___SET_NARGS(0),___PRC(126),___L__23__23_raise_2d_heap_2d_overflow_2d_exception)
___DEF_GLBL(___L3__23__23_process_2d_statistics)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_process_2d_times
#undef ___PH_LBL0
#define ___PH_LBL0 704
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_process_2d_times)
___DEF_P_HLBL(___L1__23__23_process_2d_times)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_process_2d_times)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_process_2d_times)
   ___BEGIN_ALLOC_F64VECTOR(3UL)
   ___ADD_F64VECTOR_ELEM(0,0.)
   ___ADD_F64VECTOR_ELEM(1,0.)
   ___ADD_F64VECTOR_ELEM(2,0.)
   ___END_ALLOC_F64VECTOR(3)
   ___SET_R1(___GET_F64VECTOR(3))
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

     ___SCMOBJ result = ___ARG1;
     ___F64 user, sys, real;
     ___process_times (&user, &sys, &real);
     ___F64VECTORSET(result,___FIX(0),user)
     ___F64VECTORSET(result,___FIX(1),sys)
     ___F64VECTORSET(result,___FIX(2),real)
     ___RESULT = result;

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_process_2d_times)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_get_2d_current_2d_time_21_
#undef ___PH_LBL0
#define ___PH_LBL0 707
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_get_2d_current_2d_time_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_get_2d_current_2d_time_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_get_2d_current_2d_time_21_)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

   ___time t;

   ___time_get_current_time (&t);

   ___F64VECTORSET(___ARG1,___ARG2,___time_to_seconds (t))

   ___RESULT = ___VOID;

   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_get_2d_monotonic_2d_time_21_
#undef ___PH_LBL0
#define ___PH_LBL0 709
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_get_2d_monotonic_2d_time_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_get_2d_monotonic_2d_time_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_get_2d_monotonic_2d_time_21_)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

   ___STORE_U64(___BODY_AS(___ARG1,___tSUBTYPED),
                ___INT(___ARG2),
                ___time_get_monotonic_time ());

   ___RESULT = ___VOID;

   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_get_2d_monotonic_2d_time_2d_frequency_21_
#undef ___PH_LBL0
#define ___PH_LBL0 711
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_get_2d_monotonic_2d_time_2d_frequency_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_get_2d_monotonic_2d_time_2d_frequency_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_get_2d_monotonic_2d_time_2d_frequency_21_)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

   ___STORE_U64(___BODY_AS(___ARG1,___tSUBTYPED),
                ___INT(___ARG2),
                ___time_get_monotonic_time_frequency ());

   ___RESULT = ___VOID;

   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_get_2d_bytes_2d_allocated_21_
#undef ___PH_LBL0
#define ___PH_LBL0 713
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_get_2d_bytes_2d_allocated_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_get_2d_bytes_2d_allocated_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_get_2d_bytes_2d_allocated_21_)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;

   ___F64VECTORSET(___ARG1,___ARG2,___bytes_allocated (___PSPNC));

   ___RESULT = ___VOID;

   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_actlog_2d_start
#undef ___PH_LBL0
#define ___PH_LBL0 715
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_actlog_2d_start)
___DEF_P_HLBL(___L1__23__23_actlog_2d_start)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_actlog_2d_start)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_actlog_2d_start)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_actlog_2d_start)
   ___JUMPINT(___SET_NARGS(0),___PRC(992),___L___kernel_23_14)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_actlog_2d_stop
#undef ___PH_LBL0
#define ___PH_LBL0 718
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_actlog_2d_stop)
___DEF_P_HLBL(___L1__23__23_actlog_2d_stop)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_actlog_2d_stop)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_actlog_2d_stop)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_actlog_2d_stop)
   ___JUMPINT(___SET_NARGS(0),___PRC(995),___L___kernel_23_15)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_actlog_2d_dump
#undef ___PH_LBL0
#define ___PH_LBL0 721
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_actlog_2d_dump)
___DEF_P_HLBL(___L1__23__23_actlog_2d_dump)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_actlog_2d_dump)
   ___IF_NARGS_EQ(0,___SET_R1(___FAL))
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,0,1,0)
___DEF_GLBL(___L__23__23_actlog_2d_dump)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_actlog_2d_dump)
   ___JUMPINT(___SET_NARGS(1),___PRC(998),___L___kernel_23_16)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_err_2d_code_2d__3e_string
#undef ___PH_LBL0
#define ___PH_LBL0 724
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_err_2d_code_2d__3e_string)
___DEF_P_HLBL(___L1_err_2d_code_2d__3e_string)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_err_2d_code_2d__3e_string)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_err_2d_code_2d__3e_string)
   ___POLL(1)
___DEF_SLBL(1,___L1_err_2d_code_2d__3e_string)
   ___JUMPINT(___SET_NARGS(1),___PRC(1004),___L___kernel_23_18)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_command_2d_line
#undef ___PH_LBL0
#define ___PH_LBL0 727
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_command_2d_line)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_command_2d_line)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_command_2d_line)
{ ___SCMOBJ ___RESULT;
___RESULT = ___GSTATE->command_line;
   ___SET_R1(___RESULT)
}
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_processed_2d_command_2d_line_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 729
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_processed_2d_command_2d_line_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_processed_2d_command_2d_line_2d_set_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_processed_2d_command_2d_line_2d_set_21_)
   ___SET_GLO(263,___G__23__23_processed_2d_command_2d_line,___R1)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_os_2d_condvar_2d_select_21_
#undef ___PH_LBL0
#define ___PH_LBL0 731
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_os_2d_condvar_2d_select_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_os_2d_condvar_2d_select_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_os_2d_condvar_2d_select_21_)
#define ___ARG1 ___R1
#define ___ARG2 ___R2
{ ___SCMOBJ ___RESULT;
___RESULT = ___os_condvar_select (___ARG1, ___ARG2);
   ___SET_R1(___RESULT)
}
#undef ___ARG2
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_device_2d_select_2d_abort_21_
#undef ___PH_LBL0
#define ___PH_LBL0 733
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_device_2d_select_2d_abort_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_device_2d_select_2d_abort_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_device_2d_select_2d_abort_21_)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;
___device_select_abort (___PSTATE_FROM_PROCESSOR_ID(___INT(___ARG1),___VMSTATE_FROM_PSTATE(___ps)));
   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_add_2d_exit_2d_job_21_
#undef ___PH_LBL0
#define ___PH_LBL0 735
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_add_2d_exit_2d_job_21_)
___DEF_P_HLBL(___L1__23__23_add_2d_exit_2d_job_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_add_2d_exit_2d_job_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_add_2d_exit_2d_job_21_)
   ___SET_R2(___R1)
   ___SET_R1(___GLO__23__23_exit_2d_jobs)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_add_2d_exit_2d_job_21_)
   ___JUMPINT(___SET_NARGS(2),___PRC(358),___L__23__23_add_2d_job_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_clear_2d_exit_2d_jobs_21_
#undef ___PH_LBL0
#define ___PH_LBL0 738
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_clear_2d_exit_2d_jobs_21_)
___DEF_P_HLBL(___L1__23__23_clear_2d_exit_2d_jobs_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_clear_2d_exit_2d_jobs_21_)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_clear_2d_exit_2d_jobs_21_)
   ___SET_R1(___GLO__23__23_exit_2d_jobs)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_clear_2d_exit_2d_jobs_21_)
   ___JUMPINT(___SET_NARGS(1),___PRC(373),___L__23__23_clear_2d_jobs_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup
#undef ___PH_LBL0
#define ___PH_LBL0 741
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup)
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;

   ___propagate_error (___PSP ___ARG1);
   ___RESULT = ___VOID; /* never reached */

   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_exit_2d_cleanup
#undef ___PH_LBL0
#define ___PH_LBL0 743
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_exit_2d_cleanup)
___DEF_P_HLBL(___L1__23__23_exit_2d_cleanup)
___DEF_P_HLBL(___L2__23__23_exit_2d_cleanup)
___DEF_P_HLBL(___L3__23__23_exit_2d_cleanup)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_exit_2d_cleanup)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_exit_2d_cleanup)
   ___SET_STK(1,___R0)
   ___SET_R1(___GLO__23__23_exit_2d_jobs)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_exit_2d_cleanup)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(367),___L__23__23_execute_2d_and_2d_clear_2d_jobs_21_)
___DEF_SLBL(2,___L2__23__23_exit_2d_cleanup)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_exit_2d_cleanup)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(0),___PRC(408),___L__23__23_execute_2d_final_2d_wills_21_)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_exit_2d_with_2d_err_2d_code
#undef ___PH_LBL0
#define ___PH_LBL0 748
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_exit_2d_with_2d_err_2d_code)
___DEF_P_HLBL(___L1__23__23_exit_2d_with_2d_err_2d_code)
___DEF_P_HLBL(___L2__23__23_exit_2d_with_2d_err_2d_code)
___DEF_P_HLBL(___L3__23__23_exit_2d_with_2d_err_2d_code)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_exit_2d_with_2d_err_2d_code)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_exit_2d_with_2d_err_2d_code)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_exit_2d_with_2d_err_2d_code)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(0),___PRC(743),___L__23__23_exit_2d_cleanup)
___DEF_SLBL(2,___L2__23__23_exit_2d_with_2d_err_2d_code)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_exit_2d_with_2d_err_2d_code)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(1),___PRC(741),___L__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_exit
#undef ___PH_LBL0
#define ___PH_LBL0 753
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_exit)
___DEF_P_HLBL(___L1__23__23_exit)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_exit)
   ___IF_NARGS_EQ(0,___SET_R1(___FIX(0L)))
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,0,1,0)
___DEF_GLBL(___L__23__23_exit)
   ___SET_R1(___FIXADD(___R1,___FIX(1L)))
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_exit)
   ___JUMPINT(___SET_NARGS(1),___PRC(748),___L__23__23_exit_2d_with_2d_err_2d_code)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_exit_2d_abnormally
#undef ___PH_LBL0
#define ___PH_LBL0 756
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_exit_2d_abnormally)
___DEF_P_HLBL(___L1__23__23_exit_2d_abnormally)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_exit_2d_abnormally)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_exit_2d_abnormally)
   ___SET_R1(___FIX(70L))
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_exit_2d_abnormally)
   ___SET_NARGS(1) ___JUMPINT(___NOTHING,___PRC(753),___L0__23__23_exit)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_exit_2d_with_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 759
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_exit_2d_with_2d_exception)
___DEF_P_HLBL(___L1__23__23_exit_2d_with_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_exit_2d_with_2d_exception)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_exit_2d_with_2d_exception)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_exit_2d_with_2d_exception)
   ___JUMPINT(___SET_NARGS(0),___PRC(756),___L__23__23_exit_2d_abnormally)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_first_2d_argument
#undef ___PH_LBL0
#define ___PH_LBL0 762
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_first_2d_argument)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_first_2d_argument)
   ___IF_NARGS_EQ(1,___PUSH(___R1) ___SET_R1(___FAL) ___SET_R2(___FAL) ___SET_R3(___NUL))
   ___IF_NARGS_EQ(2,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___FAL) ___SET_R3(___NUL))
   ___IF_NARGS_EQ(3,___PUSH(___R1) ___SET_R1(___R2) ___SET_R2(___R3) ___SET_R3(___NUL))
   ___GET_REST(0,1,2,0)
___DEF_GLBL(___L__23__23_first_2d_argument)
   ___SET_R1(___STK(0))
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_with_2d_no_2d_result_2d_expected
#undef ___PH_LBL0
#define ___PH_LBL0 764
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_with_2d_no_2d_result_2d_expected)
___DEF_P_HLBL(___L1__23__23_with_2d_no_2d_result_2d_expected)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_with_2d_no_2d_result_2d_expected)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_with_2d_no_2d_result_2d_expected)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___DEF_SLBL(1,___L1__23__23_with_2d_no_2d_result_2d_expected)
   ___SET_R1(___R1)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel
#undef ___PH_LBL0
#define ___PH_LBL0 767
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel)
___DEF_P_HLBL(___L1__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___DEF_SLBL(1,___L1__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel)
   ___SET_R1(___R1)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_system_2d_version
#undef ___PH_LBL0
#define ___PH_LBL0 770
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_system_2d_version)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_system_2d_version)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_system_2d_version)
   ___SET_R1(___FIX(408009L))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_system_2d_version
#undef ___PH_LBL0
#define ___PH_LBL0 772
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_system_2d_version)
___DEF_P_HLBL(___L1_system_2d_version)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_system_2d_version)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_system_2d_version)
   ___POLL(1)
___DEF_SLBL(1,___L1_system_2d_version)
   ___JUMPINT(___SET_NARGS(0),___PRC(770),___L__23__23_system_2d_version)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_system_2d_version_2d_string
#undef ___PH_LBL0
#define ___PH_LBL0 775
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_system_2d_version_2d_string)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_system_2d_version_2d_string)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_system_2d_version_2d_string)
   ___SET_R1(___SUB(40))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_system_2d_version_2d_string
#undef ___PH_LBL0
#define ___PH_LBL0 777
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_system_2d_version_2d_string)
___DEF_P_HLBL(___L1_system_2d_version_2d_string)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_system_2d_version_2d_string)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_system_2d_version_2d_string)
   ___POLL(1)
___DEF_SLBL(1,___L1_system_2d_version_2d_string)
   ___JUMPINT(___SET_NARGS(0),___PRC(775),___L__23__23_system_2d_version_2d_string)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_system_2d_type
#undef ___PH_LBL0
#define ___PH_LBL0 780
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_system_2d_type)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_system_2d_type)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_system_2d_type)
   ___SET_R1(___GLO__23__23_os_2d_system_2d_type_2d_saved)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_system_2d_type_2d_string
#undef ___PH_LBL0
#define ___PH_LBL0 782
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_system_2d_type_2d_string)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_system_2d_type_2d_string)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_system_2d_type_2d_string)
   ___SET_R1(___GLO__23__23_os_2d_system_2d_type_2d_string_2d_saved)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_configure_2d_command_2d_string
#undef ___PH_LBL0
#define ___PH_LBL0 784
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_configure_2d_command_2d_string)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_configure_2d_command_2d_string)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_configure_2d_command_2d_string)
   ___SET_R1(___GLO__23__23_os_2d_configure_2d_command_2d_string_2d_saved)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_system_2d_stamp
#undef ___PH_LBL0
#define ___PH_LBL0 786
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_system_2d_stamp)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_system_2d_stamp)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_system_2d_stamp)
   ___SET_R1(___GLO__23__23_system_2d_stamp_2d_saved)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_system_2d_stamp
#undef ___PH_LBL0
#define ___PH_LBL0 788
#undef ___PD_ALL
#define ___PD_ALL ___D_FP
#undef ___PR_ALL
#define ___PR_ALL ___R_FP
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_system_2d_stamp)
___DEF_P_HLBL(___L1_system_2d_stamp)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_system_2d_stamp)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L_system_2d_stamp)
   ___POLL(1)
___DEF_SLBL(1,___L1_system_2d_stamp)
   ___JUMPINT(___SET_NARGS(0),___PRC(786),___L__23__23_system_2d_stamp)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_type_2d_id
#undef ___PH_LBL0
#define ___PH_LBL0 791
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_type_2d_id)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_type_2d_id)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_type_2d_id)
   ___SET_R1(___TYPEID(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_type_2d_name
#undef ___PH_LBL0
#define ___PH_LBL0 793
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_type_2d_name)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_type_2d_name)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_type_2d_name)
   ___SET_R1(___TYPENAME(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_type_2d_flags
#undef ___PH_LBL0
#define ___PH_LBL0 795
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_type_2d_flags)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_type_2d_flags)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_type_2d_flags)
   ___SET_R1(___TYPEFLAGS(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_type_2d_super
#undef ___PH_LBL0
#define ___PH_LBL0 797
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_type_2d_super)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_type_2d_super)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_type_2d_super)
   ___SET_R1(___TYPESUPER(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_type_2d_fields
#undef ___PH_LBL0
#define ___PH_LBL0 799
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_type_2d_fields)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_type_2d_fields)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_type_2d_fields)
   ___SET_R1(___TYPEFIELDS(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_structure_2d_direct_2d_instance_2d_of_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 801
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_structure_2d_direct_2d_instance_2d_of_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_structure_2d_direct_2d_instance_2d_of_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_structure_2d_direct_2d_instance_2d_of_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___R2)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_structure_2d_instance_2d_of_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 803
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_structure_2d_instance_2d_of_3f_)
___DEF_P_HLBL(___L1__23__23_structure_2d_instance_2d_of_3f_)
___DEF_P_HLBL(___L2__23__23_structure_2d_instance_2d_of_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_structure_2d_instance_2d_of_3f_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_structure_2d_instance_2d_of_3f_)
   ___IF(___NOT(___STRUCTUREP(___R1)))
   ___GOTO(___L6__23__23_structure_2d_instance_2d_of_3f_)
   ___END_IF
   ___SET_R1(___STRUCTURETYPE(___R1))
   ___SET_STK(1,___R2)
   ___SET_R2(___R1)
   ___SET_R1(___STK(1))
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_structure_2d_instance_2d_of_3f_)
   ___GOTO(___L4__23__23_structure_2d_instance_2d_of_3f_)
___DEF_GLBL(___L3__23__23_structure_2d_instance_2d_of_3f_)
   ___SET_R2(___TYPESUPER(___R2))
   ___SET_STK(1,___R1)
   ___SET_R1(___R2)
   ___ADJFP(1)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L5__23__23_structure_2d_instance_2d_of_3f_)
   ___END_IF
   ___SET_R1(___STK(0))
   ___ADJFP(-1)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_structure_2d_instance_2d_of_3f_)
___DEF_GLBL(___L4__23__23_structure_2d_instance_2d_of_3f_)
   ___SET_R3(___TYPEID(___R2))
   ___IF(___NOT(___EQP(___R3,___R1)))
   ___GOTO(___L3__23__23_structure_2d_instance_2d_of_3f_)
   ___END_IF
   ___SET_R1(___TRU)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L5__23__23_structure_2d_instance_2d_of_3f_)
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L6__23__23_structure_2d_instance_2d_of_3f_)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_type_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 807
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_type_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_type_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_type_3f_)
   ___SET_R2(___TYPEID(___SUB(0)))
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___R2)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_structure_2d_type
#undef ___PH_LBL0
#define ___PH_LBL0 809
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_structure_2d_type)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_structure_2d_type)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_structure_2d_type)
   ___SET_R1(___STRUCTURETYPE(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_structure_2d_type_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 811
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_structure_2d_type_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_structure_2d_type_2d_set_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_structure_2d_type_2d_set_21_)
   ___STRUCTURETYPESET(___R1,___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_make_2d_structure
#undef ___PH_LBL0
#define ___PH_LBL0 813
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_make_2d_structure)
___DEF_P_HLBL(___L1__23__23_make_2d_structure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_make_2d_structure)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_make_2d_structure)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R1(___R2)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
   ___JUMPPRM(___SET_NARGS(1),___PRM__23__23_make_2d_vector)
___DEF_SLBL(1,___L1__23__23_make_2d_structure)
   ___SUBTYPESET(___R1,___FIX(4L))
   ___VECTORSET(___R1,___FIX(0L),___STK(-6))
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_structure_2d_length
#undef ___PH_LBL0
#define ___PH_LBL0 816
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_structure_2d_length)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_structure_2d_length)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_structure_2d_length)
   ___SET_R1(___VECTORLENGTH(___R1))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_structure
#undef ___PH_LBL0
#define ___PH_LBL0 818
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_structure)
___DEF_P_HLBL(___L1__23__23_structure)
___DEF_P_HLBL(___L2__23__23_structure)
___DEF_P_HLBL(___L3__23__23_structure)
___DEF_P_HLBL(___L4__23__23_structure)
___DEF_P_HLBL(___L5__23__23_structure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_structure)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L__23__23_structure)
   ___SET_R3(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_structure)
   ___GOTO(___L7__23__23_structure)
___DEF_GLBL(___L6__23__23_structure)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R3(___FIXADD(___R3,___FIX(1L)))
   ___SET_R2(___CDR(___R2))
   ___SET_R0(___LBL(4))
   ___ADJFP(8)
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_structure)
___DEF_GLBL(___L7__23__23_structure)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L6__23__23_structure)
   ___END_IF
   ___SET_R2(___R3)
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_structure)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_make_2d_structure)
___DEF_SLBL(4,___L4__23__23_structure)
   ___SET_R2(___CAR(___STK(-5)))
   ___UNCHECKEDSTRUCTURESET(___R1,___R2,___STK(-4),___STK(-6),___FAL)
   ___POLL(5)
___DEF_SLBL(5,___L5__23__23_structure)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_structure_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 825
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_structure_2d_ref)
___DEF_P_HLBL(___L1__23__23_structure_2d_ref)
___DEF_P_HLBL(___L2__23__23_structure_2d_ref)
___DEF_P_HLBL(___L3__23__23_structure_2d_ref)
___DEF_P_HLBL(___L4__23__23_structure_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_structure_2d_ref)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L__23__23_structure_2d_ref)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___TYPEID(___R2))
   ___SET_R1(___STK(0))
   ___SET_R0(___LBL(1))
   ___ADJFP(7)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_structure_2d_instance_2d_of_3f_)
___DEF_SLBL(1,___L1__23__23_structure_2d_ref)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L9__23__23_structure_2d_ref)
   ___END_IF
   ___SET_STK(-2,___STK(-7))
   ___SET_STK(-7,___FIX(1L))
   ___IF(___NOT(___NOTFALSEP(___STK(-3))))
   ___GOTO(___L5__23__23_structure_2d_ref)
   ___END_IF
   ___SET_R2(___STK(-3))
   ___GOTO(___L6__23__23_structure_2d_ref)
___DEF_GLBL(___L5__23__23_structure_2d_ref)
   ___SET_R2(___PRM__23__23_structure_2d_ref)
___DEF_GLBL(___L6__23__23_structure_2d_ref)
   ___SET_STK(-1,___R2)
   ___IF(___NOT(___NOTFALSEP(___STK(-3))))
   ___GOTO(___L8__23__23_structure_2d_ref)
   ___END_IF
   ___SET_R1(___CONS(___STK(-2),___NUL))
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2__23__23_structure_2d_ref)
___DEF_GLBL(___L7__23__23_structure_2d_ref)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-4))
   ___SET_R0(___STK(-6))
   ___SET_R2(___STK(-1))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_structure_2d_ref)
   ___ADJFP(-7)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___DEF_GLBL(___L8__23__23_structure_2d_ref)
   ___BEGIN_ALLOC_LIST(4UL,___STK(-3))
   ___ADD_LIST_ELEM(1,___STK(-4))
   ___ADD_LIST_ELEM(2,___STK(-5))
   ___ADD_LIST_ELEM(3,___STK(-2))
   ___END_ALLOC_LIST(4)
   ___SET_R1(___GET_LIST(4))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4__23__23_structure_2d_ref)
   ___GOTO(___L7__23__23_structure_2d_ref)
___DEF_GLBL(___L9__23__23_structure_2d_ref)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(-7),___STK(-5),___STK(-4),___STK(-3)))
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_structure_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 831
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_structure_2d_set_21_)
___DEF_P_HLBL(___L1__23__23_structure_2d_set_21_)
___DEF_P_HLBL(___L2__23__23_structure_2d_set_21_)
___DEF_P_HLBL(___L3__23__23_structure_2d_set_21_)
___DEF_P_HLBL(___L4__23__23_structure_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_structure_2d_set_21_)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(0,5,0,0)
___DEF_GLBL(___L__23__23_structure_2d_set_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___TYPEID(___R2))
   ___SET_R1(___STK(-1))
   ___SET_R0(___LBL(1))
   ___ADJFP(10)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_structure_2d_instance_2d_of_3f_)
___DEF_SLBL(1,___L1__23__23_structure_2d_set_21_)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L9__23__23_structure_2d_set_21_)
   ___END_IF
   ___SET_STK(-5,___STK(-11))
   ___SET_STK(-11,___FIX(1L))
   ___IF(___NOT(___NOTFALSEP(___STK(-6))))
   ___GOTO(___L5__23__23_structure_2d_set_21_)
   ___END_IF
   ___SET_R2(___STK(-6))
   ___GOTO(___L6__23__23_structure_2d_set_21_)
___DEF_GLBL(___L5__23__23_structure_2d_set_21_)
   ___SET_R2(___PRM__23__23_structure_2d_set_21_)
___DEF_GLBL(___L6__23__23_structure_2d_set_21_)
   ___SET_STK(-4,___R2)
   ___IF(___NOT(___NOTFALSEP(___STK(-6))))
   ___GOTO(___L8__23__23_structure_2d_set_21_)
   ___END_IF
   ___BEGIN_ALLOC_LIST(2UL,___STK(-10))
   ___ADD_LIST_ELEM(1,___STK(-5))
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2__23__23_structure_2d_set_21_)
___DEF_GLBL(___L7__23__23_structure_2d_set_21_)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-7))
   ___SET_R0(___STK(-9))
   ___SET_R2(___STK(-4))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_structure_2d_set_21_)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___DEF_GLBL(___L8__23__23_structure_2d_set_21_)
   ___BEGIN_ALLOC_LIST(5UL,___STK(-6))
   ___ADD_LIST_ELEM(1,___STK(-7))
   ___ADD_LIST_ELEM(2,___STK(-8))
   ___ADD_LIST_ELEM(3,___STK(-10))
   ___ADD_LIST_ELEM(4,___STK(-5))
   ___END_ALLOC_LIST(5)
   ___SET_R1(___GET_LIST(5))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4__23__23_structure_2d_set_21_)
   ___GOTO(___L7__23__23_structure_2d_set_21_)
___DEF_GLBL(___L9__23__23_structure_2d_set_21_)
   ___UNCHECKEDSTRUCTURESET(___STK(-11),___STK(-10),___STK(-8),___STK(-7),___STK(-6))
   ___SET_R1(___VOID)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_structure_2d_cas_21_
#undef ___PH_LBL0
#define ___PH_LBL0 837
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_structure_2d_cas_21_)
___DEF_P_HLBL(___L1__23__23_structure_2d_cas_21_)
___DEF_P_HLBL(___L2__23__23_structure_2d_cas_21_)
___DEF_P_HLBL(___L3__23__23_structure_2d_cas_21_)
___DEF_P_HLBL(___L4__23__23_structure_2d_cas_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_structure_2d_cas_21_)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L__23__23_structure_2d_cas_21_)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_STK(4,___R3)
   ___SET_R2(___TYPEID(___R2))
   ___SET_R1(___STK(-2))
   ___SET_R0(___LBL(1))
   ___ADJFP(9)
   ___JUMPPRM(___SET_NARGS(2),___PRM__23__23_structure_2d_instance_2d_of_3f_)
___DEF_SLBL(1,___L1__23__23_structure_2d_cas_21_)
   ___IF(___NOTFALSEP(___R1))
   ___GOTO(___L9__23__23_structure_2d_cas_21_)
   ___END_IF
   ___SET_STK(-4,___STK(-11))
   ___SET_STK(-11,___FIX(1L))
   ___IF(___NOT(___NOTFALSEP(___STK(-5))))
   ___GOTO(___L5__23__23_structure_2d_cas_21_)
   ___END_IF
   ___SET_R2(___STK(-5))
   ___GOTO(___L6__23__23_structure_2d_cas_21_)
___DEF_GLBL(___L5__23__23_structure_2d_cas_21_)
   ___SET_R2(___PRM__23__23_structure_2d_cas_21_)
___DEF_GLBL(___L6__23__23_structure_2d_cas_21_)
   ___SET_STK(-3,___R2)
   ___IF(___NOT(___NOTFALSEP(___STK(-5))))
   ___GOTO(___L8__23__23_structure_2d_cas_21_)
   ___END_IF
   ___BEGIN_ALLOC_LIST(3UL,___STK(-9))
   ___ADD_LIST_ELEM(1,___STK(-10))
   ___ADD_LIST_ELEM(2,___STK(-4))
   ___END_ALLOC_LIST(3)
   ___SET_R1(___GET_LIST(3))
   ___CHECK_HEAP(2,4096)
___DEF_SLBL(2,___L2__23__23_structure_2d_cas_21_)
___DEF_GLBL(___L7__23__23_structure_2d_cas_21_)
   ___SET_R3(___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-8))
   ___SET_R2(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_structure_2d_cas_21_)
   ___ADJFP(-11)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___DEF_GLBL(___L8__23__23_structure_2d_cas_21_)
   ___BEGIN_ALLOC_LIST(6UL,___STK(-5))
   ___ADD_LIST_ELEM(1,___STK(-6))
   ___ADD_LIST_ELEM(2,___STK(-7))
   ___ADD_LIST_ELEM(3,___STK(-9))
   ___ADD_LIST_ELEM(4,___STK(-10))
   ___ADD_LIST_ELEM(5,___STK(-4))
   ___END_ALLOC_LIST(6)
   ___SET_R1(___GET_LIST(6))
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4__23__23_structure_2d_cas_21_)
   ___GOTO(___L7__23__23_structure_2d_cas_21_)
___DEF_GLBL(___L9__23__23_structure_2d_cas_21_)
   ___EXPR(___UNCHECKEDSTRUCTURECAS(___STK(-11),___STK(-10),___STK(-9),___STK(-7),___STK(-6),___STK(-5)
))
   ___SET_R1(___VOID)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_direct_2d_structure_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 843
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_direct_2d_structure_2d_ref)
___DEF_P_HLBL(___L1__23__23_direct_2d_structure_2d_ref)
___DEF_P_HLBL(___L2__23__23_direct_2d_structure_2d_ref)
___DEF_P_HLBL(___L3__23__23_direct_2d_structure_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_direct_2d_structure_2d_ref)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L__23__23_direct_2d_structure_2d_ref)
   ___SET_R4(___TYPEID(___R2))
   ___IF(___STRUCTUREDIOP(___STK(0),___R4))
   ___GOTO(___L8__23__23_direct_2d_structure_2d_ref)
   ___END_IF
   ___SET_STK(1,___STK(0))
   ___SET_STK(0,___FIX(1L))
   ___ADJFP(1)
   ___IF(___NOT(___NOTFALSEP(___R3)))
   ___GOTO(___L4__23__23_direct_2d_structure_2d_ref)
   ___END_IF
   ___SET_STK(1,___R3)
   ___ADJFP(1)
   ___GOTO(___L5__23__23_direct_2d_structure_2d_ref)
___DEF_GLBL(___L4__23__23_direct_2d_structure_2d_ref)
   ___SET_STK(1,___R3)
   ___SET_R3(___PRM__23__23_direct_2d_structure_2d_ref)
   ___ADJFP(1)
___DEF_GLBL(___L5__23__23_direct_2d_structure_2d_ref)
   ___SET_STK(1,___R3)
   ___ADJFP(1)
   ___IF(___NOT(___NOTFALSEP(___STK(-1))))
   ___GOTO(___L7__23__23_direct_2d_structure_2d_ref)
   ___END_IF
   ___SET_R1(___CONS(___STK(-2),___NUL))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_direct_2d_structure_2d_ref)
___DEF_GLBL(___L6__23__23_direct_2d_structure_2d_ref)
   ___SET_R3(___R1)
   ___SET_R1(___R2)
   ___SET_R2(___STK(0))
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_direct_2d_structure_2d_ref)
   ___ADJFP(-3)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___DEF_GLBL(___L7__23__23_direct_2d_structure_2d_ref)
   ___BEGIN_ALLOC_LIST(4UL,___STK(-1))
   ___ADD_LIST_ELEM(1,___R2)
   ___ADD_LIST_ELEM(2,___R1)
   ___ADD_LIST_ELEM(3,___STK(-2))
   ___END_ALLOC_LIST(4)
   ___SET_R1(___GET_LIST(4))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3__23__23_direct_2d_structure_2d_ref)
   ___GOTO(___L6__23__23_direct_2d_structure_2d_ref)
___DEF_GLBL(___L8__23__23_direct_2d_structure_2d_ref)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(0),___R1,___R2,___R3))
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_direct_2d_structure_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 848
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_direct_2d_structure_2d_set_21_)
___DEF_P_HLBL(___L1__23__23_direct_2d_structure_2d_set_21_)
___DEF_P_HLBL(___L2__23__23_direct_2d_structure_2d_set_21_)
___DEF_P_HLBL(___L3__23__23_direct_2d_structure_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_direct_2d_structure_2d_set_21_)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(0,5,0,0)
___DEF_GLBL(___L__23__23_direct_2d_structure_2d_set_21_)
   ___SET_R4(___TYPEID(___R2))
   ___IF(___STRUCTUREDIOP(___STK(-1),___R4))
   ___GOTO(___L8__23__23_direct_2d_structure_2d_set_21_)
   ___END_IF
   ___SET_STK(1,___STK(-1))
   ___SET_STK(-1,___FIX(1L))
   ___ADJFP(1)
   ___IF(___NOT(___NOTFALSEP(___R3)))
   ___GOTO(___L4__23__23_direct_2d_structure_2d_set_21_)
   ___END_IF
   ___SET_STK(1,___R3)
   ___ADJFP(1)
   ___GOTO(___L5__23__23_direct_2d_structure_2d_set_21_)
___DEF_GLBL(___L4__23__23_direct_2d_structure_2d_set_21_)
   ___SET_STK(1,___R3)
   ___SET_R3(___PRM__23__23_direct_2d_structure_2d_set_21_)
   ___ADJFP(1)
___DEF_GLBL(___L5__23__23_direct_2d_structure_2d_set_21_)
   ___SET_STK(1,___R3)
   ___ADJFP(1)
   ___IF(___NOT(___NOTFALSEP(___STK(-1))))
   ___GOTO(___L7__23__23_direct_2d_structure_2d_set_21_)
   ___END_IF
   ___BEGIN_ALLOC_LIST(2UL,___STK(-3))
   ___ADD_LIST_ELEM(1,___STK(-2))
   ___END_ALLOC_LIST(2)
   ___SET_R1(___GET_LIST(2))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_direct_2d_structure_2d_set_21_)
___DEF_GLBL(___L6__23__23_direct_2d_structure_2d_set_21_)
   ___SET_R3(___R1)
   ___SET_R1(___R2)
   ___SET_R2(___STK(0))
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_direct_2d_structure_2d_set_21_)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___DEF_GLBL(___L7__23__23_direct_2d_structure_2d_set_21_)
   ___BEGIN_ALLOC_LIST(5UL,___STK(-1))
   ___ADD_LIST_ELEM(1,___R2)
   ___ADD_LIST_ELEM(2,___R1)
   ___ADD_LIST_ELEM(3,___STK(-3))
   ___ADD_LIST_ELEM(4,___STK(-2))
   ___END_ALLOC_LIST(5)
   ___SET_R1(___GET_LIST(5))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3__23__23_direct_2d_structure_2d_set_21_)
   ___GOTO(___L6__23__23_direct_2d_structure_2d_set_21_)
___DEF_GLBL(___L8__23__23_direct_2d_structure_2d_set_21_)
   ___UNCHECKEDSTRUCTURESET(___STK(-1),___STK(0),___R1,___R2,___R3)
   ___SET_R1(___VOID)
   ___ADJFP(-2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_direct_2d_structure_2d_cas_21_
#undef ___PH_LBL0
#define ___PH_LBL0 853
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_direct_2d_structure_2d_cas_21_)
___DEF_P_HLBL(___L1__23__23_direct_2d_structure_2d_cas_21_)
___DEF_P_HLBL(___L2__23__23_direct_2d_structure_2d_cas_21_)
___DEF_P_HLBL(___L3__23__23_direct_2d_structure_2d_cas_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_direct_2d_structure_2d_cas_21_)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L__23__23_direct_2d_structure_2d_cas_21_)
   ___SET_R4(___TYPEID(___R2))
   ___IF(___STRUCTUREDIOP(___STK(-2),___R4))
   ___GOTO(___L8__23__23_direct_2d_structure_2d_cas_21_)
   ___END_IF
   ___SET_STK(1,___STK(-2))
   ___SET_STK(-2,___FIX(1L))
   ___ADJFP(1)
   ___IF(___NOT(___NOTFALSEP(___R3)))
   ___GOTO(___L4__23__23_direct_2d_structure_2d_cas_21_)
   ___END_IF
   ___SET_STK(1,___R3)
   ___ADJFP(1)
   ___GOTO(___L5__23__23_direct_2d_structure_2d_cas_21_)
___DEF_GLBL(___L4__23__23_direct_2d_structure_2d_cas_21_)
   ___SET_STK(1,___R3)
   ___SET_R3(___PRM__23__23_direct_2d_structure_2d_cas_21_)
   ___ADJFP(1)
___DEF_GLBL(___L5__23__23_direct_2d_structure_2d_cas_21_)
   ___SET_STK(1,___R3)
   ___ADJFP(1)
   ___IF(___NOT(___NOTFALSEP(___STK(-1))))
   ___GOTO(___L7__23__23_direct_2d_structure_2d_cas_21_)
   ___END_IF
   ___BEGIN_ALLOC_LIST(3UL,___STK(-3))
   ___ADD_LIST_ELEM(1,___STK(-4))
   ___ADD_LIST_ELEM(2,___STK(-2))
   ___END_ALLOC_LIST(3)
   ___SET_R1(___GET_LIST(3))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_direct_2d_structure_2d_cas_21_)
___DEF_GLBL(___L6__23__23_direct_2d_structure_2d_cas_21_)
   ___SET_R3(___R1)
   ___SET_R1(___R2)
   ___SET_R2(___STK(0))
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_direct_2d_structure_2d_cas_21_)
   ___ADJFP(-5)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___DEF_GLBL(___L7__23__23_direct_2d_structure_2d_cas_21_)
   ___BEGIN_ALLOC_LIST(6UL,___STK(-1))
   ___ADD_LIST_ELEM(1,___R2)
   ___ADD_LIST_ELEM(2,___R1)
   ___ADD_LIST_ELEM(3,___STK(-3))
   ___ADD_LIST_ELEM(4,___STK(-4))
   ___ADD_LIST_ELEM(5,___STK(-2))
   ___END_ALLOC_LIST(6)
   ___SET_R1(___GET_LIST(6))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3__23__23_direct_2d_structure_2d_cas_21_)
   ___GOTO(___L6__23__23_direct_2d_structure_2d_cas_21_)
___DEF_GLBL(___L8__23__23_direct_2d_structure_2d_cas_21_)
   ___EXPR(___UNCHECKEDSTRUCTURECAS(___STK(-2),___STK(-1),___STK(0),___R1,___R2,___R3))
   ___SET_R1(___VOID)
   ___ADJFP(-3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_unchecked_2d_structure_2d_ref
#undef ___PH_LBL0
#define ___PH_LBL0 858
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_unchecked_2d_structure_2d_ref)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_unchecked_2d_structure_2d_ref)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L__23__23_unchecked_2d_structure_2d_ref)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___STK(0),___R1,___R2,___R3))
   ___ADJFP(-1)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_unchecked_2d_structure_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 860
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_unchecked_2d_structure_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_unchecked_2d_structure_2d_set_21_)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(0,5,0,0)
___DEF_GLBL(___L__23__23_unchecked_2d_structure_2d_set_21_)
   ___UNCHECKEDSTRUCTURESET(___STK(-1),___STK(0),___R1,___R2,___R3) ___SET_R1(___STK(-1))
   ___ADJFP(-2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_unchecked_2d_structure_2d_cas_21_
#undef ___PH_LBL0
#define ___PH_LBL0 862
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_unchecked_2d_structure_2d_cas_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_unchecked_2d_structure_2d_cas_21_)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L__23__23_unchecked_2d_structure_2d_cas_21_)
   ___SET_R1(___UNCHECKEDSTRUCTURECAS(___STK(-2),___STK(-1),___STK(0),___R1,___R2,___R3))
   ___ADJFP(-3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_main_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 864
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_main_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_main_2d_set_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_main_2d_set_21_)
   ___SET_GLO(151,___G__23__23_main,___R1)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_module_2d_init
#undef ___PH_LBL0
#define ___PH_LBL0 866
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_module_2d_init)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_module_2d_init)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_module_2d_init)
   ___SET_R1(___VECTORREF(___R1,___FIX(4L)))
#define ___ARG1 ___R1
{ ___SCMOBJ ___RESULT;
___RESULT = ___CAST(___module_struct*,___FIELD(___ARG1,___FOREIGN_PTR))->init_mod (___PSPNC);
   ___SET_R1(___RESULT)
}
#undef ___ARG1
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_create_2d_module
#undef ___PH_LBL0
#define ___PH_LBL0 868
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_create_2d_module)
___DEF_P_HLBL(___L1__23__23_create_2d_module)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_create_2d_module)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_create_2d_module)
   ___BEGIN_ALLOC_VECTOR(4UL)
   ___ADD_VECTOR_ELEM(0,___FAL)
   ___ADD_VECTOR_ELEM(1,___R1)
   ___ADD_VECTOR_ELEM(2,___FIX(0L))
   ___ADD_VECTOR_ELEM(3,___R2)
   ___END_ALLOC_VECTOR(4)
   ___SET_R1(___GET_VECTOR(4))
   ___CHECK_HEAP(1,4096)
___DEF_SLBL(1,___L1__23__23_create_2d_module)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_register_2d_module_2d_descr_21_
#undef ___PH_LBL0
#define ___PH_LBL0 871
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_register_2d_module_2d_descr_21_)
___DEF_P_HLBL(___L1__23__23_register_2d_module_2d_descr_21_)
___DEF_P_HLBL(___L2__23__23_register_2d_module_2d_descr_21_)
___DEF_P_HLBL(___L3__23__23_register_2d_module_2d_descr_21_)
___DEF_P_HLBL(___L4__23__23_register_2d_module_2d_descr_21_)
___DEF_P_HLBL(___L5__23__23_register_2d_module_2d_descr_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_register_2d_module_2d_descr_21_)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_register_2d_module_2d_descr_21_)
   ___SET_R1(___VECTORREF(___R2,___FIX(0L)))
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_register_2d_module_2d_descr_21_)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(2),___PRC(868),___L__23__23_create_2d_module)
___DEF_SLBL(2,___L2__23__23_register_2d_module_2d_descr_21_)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R2(___GLO__23__23_registered_2d_modules)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(891),___L__23__23_lookup_2d_module)
___DEF_SLBL(3,___L3__23__23_register_2d_module_2d_descr_21_)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L6__23__23_register_2d_module_2d_descr_21_)
   ___END_IF
   ___SETCAR(___R1,___STK(-5))
   ___GOTO(___L7__23__23_register_2d_module_2d_descr_21_)
___DEF_GLBL(___L6__23__23_register_2d_module_2d_descr_21_)
   ___SET_R1(___CONS(___STK(-5),___GLO__23__23_registered_2d_modules))
   ___SET_GLO(292,___G__23__23_registered_2d_modules,___R1)
   ___CHECK_HEAP(4,4096)
___DEF_SLBL(4,___L4__23__23_register_2d_module_2d_descr_21_)
___DEF_GLBL(___L7__23__23_register_2d_module_2d_descr_21_)
   ___SET_R1(___STK(-5))
   ___POLL(5)
___DEF_SLBL(5,___L5__23__23_register_2d_module_2d_descr_21_)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_register_2d_module_2d_descrs_21_
#undef ___PH_LBL0
#define ___PH_LBL0 878
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_register_2d_module_2d_descrs_21_)
___DEF_P_HLBL(___L1__23__23_register_2d_module_2d_descrs_21_)
___DEF_P_HLBL(___L2__23__23_register_2d_module_2d_descrs_21_)
___DEF_P_HLBL(___L3__23__23_register_2d_module_2d_descrs_21_)
___DEF_P_HLBL(___L4__23__23_register_2d_module_2d_descrs_21_)
___DEF_P_HLBL(___L5__23__23_register_2d_module_2d_descrs_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_register_2d_module_2d_descrs_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_register_2d_module_2d_descrs_21_)
   ___SET_R2(___VECTORLENGTH(___R1))
   ___SET_R2(___FIXSUB(___R2,___FIX(1L)))
   ___SET_R3(___NUL)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_register_2d_module_2d_descrs_21_)
   ___GOTO(___L6__23__23_register_2d_module_2d_descrs_21_)
___DEF_SLBL(2,___L2__23__23_register_2d_module_2d_descrs_21_)
   ___SET_R3(___CONS(___R1,___STK(-3)))
   ___SET_R2(___FIXSUB(___STK(-4),___FIX(1L)))
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-6))
   ___ADJFP(-8)
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3__23__23_register_2d_module_2d_descrs_21_)
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_register_2d_module_2d_descrs_21_)
___DEF_GLBL(___L6__23__23_register_2d_module_2d_descrs_21_)
   ___IF(___NOT(___FIXGE(___R2,___FIX(0L))))
   ___GOTO(___L7__23__23_register_2d_module_2d_descrs_21_)
   ___END_IF
   ___SET_R4(___VECTORREF(___R1,___R2))
   ___SET_STK(1,___VECTORREF(___R4,___FIX(0L)))
   ___SET_STK(2,___R0)
   ___SET_STK(3,___R1)
   ___SET_STK(4,___R2)
   ___SET_STK(5,___R3)
   ___SET_R2(___R4)
   ___SET_R1(___STK(1))
   ___ADJFP(8)
   ___POLL(5)
___DEF_SLBL(5,___L5__23__23_register_2d_module_2d_descrs_21_)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(2),___PRC(871),___L__23__23_register_2d_module_2d_descr_21_)
___DEF_GLBL(___L7__23__23_register_2d_module_2d_descrs_21_)
   ___SET_R1(___R3)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_lookup_2d_registered_2d_module
#undef ___PH_LBL0
#define ___PH_LBL0 885
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_lookup_2d_registered_2d_module)
___DEF_P_HLBL(___L1__23__23_lookup_2d_registered_2d_module)
___DEF_P_HLBL(___L2__23__23_lookup_2d_registered_2d_module)
___DEF_P_HLBL(___L3__23__23_lookup_2d_registered_2d_module)
___DEF_P_HLBL(___L4__23__23_lookup_2d_registered_2d_module)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_lookup_2d_registered_2d_module)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_lookup_2d_registered_2d_module)
   ___SET_STK(1,___R0)
   ___SET_R2(___GLO__23__23_registered_2d_modules)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_lookup_2d_registered_2d_module)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(2),___PRC(891),___L__23__23_lookup_2d_module)
___DEF_SLBL(2,___L2__23__23_lookup_2d_registered_2d_module)
   ___SET_STK(-2,___R1)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L5__23__23_lookup_2d_registered_2d_module)
   ___END_IF
   ___SET_R1(___CAR(___STK(-2)))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_lookup_2d_registered_2d_module)
   ___GOTO(___L6__23__23_lookup_2d_registered_2d_module)
___DEF_GLBL(___L5__23__23_lookup_2d_registered_2d_module)
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_lookup_2d_registered_2d_module)
___DEF_GLBL(___L6__23__23_lookup_2d_registered_2d_module)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_lookup_2d_module
#undef ___PH_LBL0
#define ___PH_LBL0 891
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_lookup_2d_module)
___DEF_P_HLBL(___L1__23__23_lookup_2d_module)
___DEF_P_HLBL(___L2__23__23_lookup_2d_module)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_lookup_2d_module)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_lookup_2d_module)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_lookup_2d_module)
   ___GOTO(___L4__23__23_lookup_2d_module)
___DEF_GLBL(___L3__23__23_lookup_2d_module)
   ___SET_R3(___CAR(___R2))
   ___SET_R3(___VECTORREF(___R3,___FIX(1L)))
   ___IF(___EQP(___R1,___R3))
   ___GOTO(___L5__23__23_lookup_2d_module)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(2)
___DEF_SLBL(2,___L2__23__23_lookup_2d_module)
___DEF_GLBL(___L4__23__23_lookup_2d_module)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L3__23__23_lookup_2d_module)
   ___END_IF
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L5__23__23_lookup_2d_module)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_load_2d_required_2d_module_2d_structs
#undef ___PH_LBL0
#define ___PH_LBL0 895
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L1__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L2__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L3__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L4__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L5__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L6__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L7__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L8__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L9__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L10__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L11__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L12__23__23_load_2d_required_2d_module_2d_structs)
___DEF_P_HLBL(___L13__23__23_load_2d_required_2d_module_2d_structs)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_load_2d_required_2d_module_2d_structs)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L__23__23_load_2d_required_2d_module_2d_structs)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_STK(3,___R2)
   ___SET_R3(___LBL(12))
   ___SET_R0(___LBL(2))
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_load_2d_required_2d_module_2d_structs)
   ___GOTO(___L14__23__23_load_2d_required_2d_module_2d_structs)
___DEF_SLBL(2,___L2__23__23_load_2d_required_2d_module_2d_structs)
   ___SET_R3(___LBL(10))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_load_2d_required_2d_module_2d_structs)
___DEF_GLBL(___L14__23__23_load_2d_required_2d_module_2d_structs)
   ___SET_STK(1,___R3)
   ___SET_R3(___R1)
   ___SET_STK(2,___R2)
   ___SET_R2(___STK(1))
   ___SET_R1(___STK(2))
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_load_2d_required_2d_module_2d_structs)
___DEF_GLBL(___L15__23__23_load_2d_required_2d_module_2d_structs)
   ___IF(___NOT(___PAIRP(___R3)))
   ___GOTO(___L20__23__23_load_2d_required_2d_module_2d_structs)
   ___END_IF
   ___SET_R4(___CAR(___R3))
   ___SET_STK(1,___VECTORREF(___R4,___FIX(3L)))
   ___SET_R3(___CDR(___R3))
   ___SET_STK(2,___BOOLEAN(___PAIRP(___R3)))
   ___SET_STK(2,___BOOLEAN(___FALSEP(___STK(2))))
   ___SET_STK(1,___VECTORREF(___STK(1),___FIX(2L)))
   ___SET_STK(1,___FIXAND(___FIX(1L),___STK(1)))
   ___ADJFP(2)
   ___IF(___NOT(___FIXEQ(___STK(-1),___FIX(1L))))
   ___GOTO(___L18__23__23_load_2d_required_2d_module_2d_structs)
   ___END_IF
___DEF_GLBL(___L16__23__23_load_2d_required_2d_module_2d_structs)
   ___IF(___NOT(___NOTFALSEP(___STK(0))))
   ___GOTO(___L17__23__23_load_2d_required_2d_module_2d_structs)
   ___END_IF
   ___SET_R1(___R4)
   ___POLL(5)
___DEF_SLBL(5,___L5__23__23_load_2d_required_2d_module_2d_structs)
   ___ADJFP(-2)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___DEF_GLBL(___L17__23__23_load_2d_required_2d_module_2d_structs)
   ___SET_STK(-1,___R0)
   ___SET_STK(0,___R1)
   ___SET_STK(1,___R2)
   ___SET_STK(2,___R3)
   ___SET_R1(___R4)
   ___ADJFP(6)
   ___POLL(6)
___DEF_SLBL(6,___L6__23__23_load_2d_required_2d_module_2d_structs)
   ___SET_R0(___LBL(7))
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___DEF_SLBL(7,___L7__23__23_load_2d_required_2d_module_2d_structs)
   ___SET_R3(___STK(-4))
   ___SET_R2(___STK(-5))
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(8)
___DEF_SLBL(8,___L8__23__23_load_2d_required_2d_module_2d_structs)
   ___GOTO(___L15__23__23_load_2d_required_2d_module_2d_structs)
___DEF_GLBL(___L18__23__23_load_2d_required_2d_module_2d_structs)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L19__23__23_load_2d_required_2d_module_2d_structs)
   ___END_IF
   ___IF(___NOTFALSEP(___STK(0)))
   ___GOTO(___L16__23__23_load_2d_required_2d_module_2d_structs)
   ___END_IF
___DEF_GLBL(___L19__23__23_load_2d_required_2d_module_2d_structs)
   ___ADJFP(-2)
   ___POLL(9)
___DEF_SLBL(9,___L9__23__23_load_2d_required_2d_module_2d_structs)
   ___GOTO(___L15__23__23_load_2d_required_2d_module_2d_structs)
___DEF_SLBL(10,___L10__23__23_load_2d_required_2d_module_2d_structs)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(10,1,0,0)
   ___SET_R2(___VECTORREF(___R1,___FIX(2L)))
   ___SET_R2(___FIXAND(___R2,___FIX(2L)))
   ___IF(___NOT(___FIXEQ(___R2,___FIX(0L))))
   ___GOTO(___L20__23__23_load_2d_required_2d_module_2d_structs)
   ___END_IF
   ___SET_R2(___VECTORREF(___R1,___FIX(2L)))
   ___SET_R2(___FIXIOR(___R2,___FIX(2L)))
   ___VECTORSET(___R1,___FIX(2L),___R2)
   ___SET_R1(___VECTORREF(___R1,___FIX(3L)))
   ___IF(___VECTORP(___R1))
   ___GOTO(___L21__23__23_load_2d_required_2d_module_2d_structs)
   ___END_IF
___DEF_GLBL(___L20__23__23_load_2d_required_2d_module_2d_structs)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L21__23__23_load_2d_required_2d_module_2d_structs)
   ___SET_R1(___VECTORREF(___R1,___FIX(1L)))
   ___POLL(11)
___DEF_SLBL(11,___L11__23__23_load_2d_required_2d_module_2d_structs)
   ___JUMPGENNOTSAFE(___SET_NARGS(0),___R1)
___DEF_SLBL(12,___L12__23__23_load_2d_required_2d_module_2d_structs)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(12,1,0,0)
   ___SET_R2(___VECTORREF(___R1,___FIX(2L)))
   ___SET_R2(___FIXAND(___R2,___FIX(1L)))
   ___IF(___NOT(___FIXEQ(___R2,___FIX(0L))))
   ___GOTO(___L20__23__23_load_2d_required_2d_module_2d_structs)
   ___END_IF
   ___SET_R2(___VECTORREF(___R1,___FIX(2L)))
   ___SET_R2(___FIXIOR(___R2,___FIX(1L)))
   ___VECTORSET(___R1,___FIX(2L),___R2)
   ___SET_R1(___VECTORREF(___R1,___FIX(3L)))
   ___IF(___NOT(___VECTORP(___R1)))
   ___GOTO(___L20__23__23_load_2d_required_2d_module_2d_structs)
   ___END_IF
   ___POLL(13)
___DEF_SLBL(13,___L13__23__23_load_2d_required_2d_module_2d_structs)
   ___JUMPINT(___SET_NARGS(1),___PRC(866),___L__23__23_module_2d_init)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_default_2d_load_2d_required_2d_module
#undef ___PH_LBL0
#define ___PH_LBL0 910
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_default_2d_load_2d_required_2d_module)
___DEF_P_HLBL(___L1__23__23_default_2d_load_2d_required_2d_module)
___DEF_P_HLBL(___L2__23__23_default_2d_load_2d_required_2d_module)
___DEF_P_HLBL(___L3__23__23_default_2d_load_2d_required_2d_module)
___DEF_P_HLBL(___L4__23__23_default_2d_load_2d_required_2d_module)
___DEF_P_HLBL(___L5__23__23_default_2d_load_2d_required_2d_module)
___DEF_P_HLBL(___L6__23__23_default_2d_load_2d_required_2d_module)
___DEF_P_HLBL(___L7__23__23_default_2d_load_2d_required_2d_module)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_default_2d_load_2d_required_2d_module)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_default_2d_load_2d_required_2d_module)
   ___IF(___NOT(___SYMBOLP(___R1)))
   ___GOTO(___L9__23__23_default_2d_load_2d_required_2d_module)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___ADJFP(8)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_default_2d_load_2d_required_2d_module)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(885),___L__23__23_lookup_2d_registered_2d_module)
___DEF_SLBL(2,___L2__23__23_default_2d_load_2d_required_2d_module)
   ___IF(___NOT(___NOTFALSEP(___R1)))
   ___GOTO(___L8__23__23_default_2d_load_2d_required_2d_module)
   ___END_IF
   ___SET_R1(___CONS(___R1,___NUL))
   ___SET_R2(___TRU)
   ___SET_R0(___STK(-7))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3__23__23_default_2d_load_2d_required_2d_module)
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_default_2d_load_2d_required_2d_module)
   ___ADJFP(-8)
   ___JUMPINT(___SET_NARGS(2),___PRC(895),___L__23__23_load_2d_required_2d_module_2d_structs)
___DEF_GLBL(___L8__23__23_default_2d_load_2d_required_2d_module)
   ___SET_R1(___STK(-6))
   ___SET_R0(___STK(-7))
   ___ADJFP(-8)
   ___POLL(5)
___DEF_SLBL(5,___L5__23__23_default_2d_load_2d_required_2d_module)
   ___GOTO(___L10__23__23_default_2d_load_2d_required_2d_module)
___DEF_GLBL(___L9__23__23_default_2d_load_2d_required_2d_module)
   ___POLL(6)
___DEF_SLBL(6,___L6__23__23_default_2d_load_2d_required_2d_module)
___DEF_GLBL(___L10__23__23_default_2d_load_2d_required_2d_module)
   ___SET_R2(___R1)
   ___SET_R1(___LBL(0))
   ___POLL(7)
___DEF_SLBL(7,___L7__23__23_default_2d_load_2d_required_2d_module)
   ___SET_NARGS(2) ___JUMPINT(___NOTHING,___PRC(932),___L0__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_load_2d_required_2d_module_2d_set_21_
#undef ___PH_LBL0
#define ___PH_LBL0 919
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_load_2d_required_2d_module_2d_set_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_load_2d_required_2d_module_2d_set_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_load_2d_required_2d_module_2d_set_21_)
   ___SET_GLO(140,___G__23__23_load_2d_required_2d_module,___R1)
   ___SET_R1(___VOID)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 921
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R1 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R1 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R1 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception)
___DEF_P_HLBL(___L1__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception)
   ___IF_NARGS_EQ(2,___SET_R3(___NUL))
   ___GET_REST(0,2,0,0)
___DEF_GLBL(___L__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_R1(___SUB(41))
   ___ADJFP(1)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception)
   ___JUMPINT(___SET_NARGS(4),___PRC(115),___L__23__23_raise_2d_type_2d_exception)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_module_2d_not_2d_found_2d_exception_3f_
#undef ___PH_LBL0
#define ___PH_LBL0 924
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_module_2d_not_2d_found_2d_exception_3f_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_module_2d_not_2d_found_2d_exception_3f_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_module_2d_not_2d_found_2d_exception_3f_)
   ___SET_R1(___BOOLEAN(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_CA9CA020_2d_600A_2d_4516_2d_AA78_2d_CBE91EC8BE14)))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_module_2d_not_2d_found_2d_exception_2d_procedure
#undef ___PH_LBL0
#define ___PH_LBL0 926
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_module_2d_not_2d_found_2d_exception_2d_procedure)
___DEF_P_HLBL(___L1_module_2d_not_2d_found_2d_exception_2d_procedure)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_module_2d_not_2d_found_2d_exception_2d_procedure)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_module_2d_not_2d_found_2d_exception_2d_procedure)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_CA9CA020_2d_600A_2d_4516_2d_AA78_2d_CBE91EC8BE14))
   ___GOTO(___L2_module_2d_not_2d_found_2d_exception_2d_procedure)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_module_2d_not_2d_found_2d_exception_2d_procedure)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(921),___L0__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception)
___DEF_GLBL(___L2_module_2d_not_2d_found_2d_exception_2d_procedure)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(1L),___SUB(41),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_module_2d_not_2d_found_2d_exception_2d_arguments
#undef ___PH_LBL0
#define ___PH_LBL0 929
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_R1 ___W_R2 ___W_R3
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_module_2d_not_2d_found_2d_exception_2d_arguments)
___DEF_P_HLBL(___L1_module_2d_not_2d_found_2d_exception_2d_arguments)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_module_2d_not_2d_found_2d_exception_2d_arguments)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_module_2d_not_2d_found_2d_exception_2d_arguments)
   ___IF(___STRUCTUREDIOP(___R1,___SYM__23__23_type_2d_2_2d_CA9CA020_2d_600A_2d_4516_2d_AA78_2d_CBE91EC8BE14))
   ___GOTO(___L2_module_2d_not_2d_found_2d_exception_2d_arguments)
   ___END_IF
   ___SET_R3(___R1)
   ___SET_R2(___LBL(0))
   ___SET_R1(___FIX(1L))
   ___POLL(1)
___DEF_SLBL(1,___L1_module_2d_not_2d_found_2d_exception_2d_arguments)
   ___SET_NARGS(3) ___JUMPINT(___NOTHING,___PRC(921),___L0__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception)
___DEF_GLBL(___L2_module_2d_not_2d_found_2d_exception_2d_arguments)
   ___SET_R1(___UNCHECKEDSTRUCTUREREF(___R1,___FIX(2L),___SUB(41),___FAL))
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_raise_2d_module_2d_not_2d_found_2d_exception
#undef ___PH_LBL0
#define ___PH_LBL0 932
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
___DEF_P_HLBL(___L1__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
___DEF_P_HLBL(___L2__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
___DEF_P_HLBL(___L3__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
___DEF_P_HLBL(___L4__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
   ___IF_NARGS_EQ(1,___SET_R2(___NUL))
   ___GET_REST(0,1,0,0)
___DEF_GLBL(___L__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___FAL)
   ___SET_R3(___LBL(2))
   ___SET_R2(___FAL)
   ___SET_R1(___FAL)
   ___ADJFP(3)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
   ___JUMPINT(___SET_NARGS(6),___PRC(87),___L__23__23_extract_2d_procedure_2d_and_2d_arguments)
___DEF_SLBL(2,___L2__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(2,5,0,0)
   ___BEGIN_ALLOC_STRUCTURE(3UL)
   ___ADD_STRUCTURE_ELEM(0,___SUB(41))
   ___ADD_STRUCTURE_ELEM(1,___STK(-1))
   ___ADD_STRUCTURE_ELEM(2,___STK(0))
   ___END_ALLOC_STRUCTURE(3)
   ___SET_R1(___GET_STRUCTURE(3))
   ___SET_R2(___CURRENTTHREAD)
   ___SET_R2(___UNCHECKEDSTRUCTUREREF(___R2,___FIX(24L),___SUB(2),___FAL))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
   ___SET_R2(___CDR(___R2))
   ___CHECK_HEAP(3,4096)
___DEF_SLBL(3,___L3__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
   ___POLL(4)
___DEF_SLBL(4,___L4__23__23_raise_2d_module_2d_not_2d_found_2d_exception)
   ___ADJFP(-2)
   ___JUMPGENNOTSAFE(___SET_NARGS(1),___R2)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_
#undef ___PH_LBL0
#define ___PH_LBL0 938
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R2
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
___DEF_P_HLBL(___L1__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
___DEF_P_HLBL(___L2__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
___DEF_P_HLBL(___L3__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
   ___SET_STK(1,___R0)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(878),___L__23__23_register_2d_module_2d_descrs_21_)
___DEF_SLBL(2,___L2__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
   ___SET_R2(___FAL)
   ___SET_R0(___STK(-3))
   ___POLL(3)
___DEF_SLBL(3,___L3__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_)
   ___ADJFP(-4)
   ___JUMPINT(___SET_NARGS(2),___PRC(895),___L__23__23_load_2d_required_2d_module_2d_structs)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_load_2d_vm
#undef ___PH_LBL0
#define ___PH_LBL0 943
#undef ___PD_ALL
#define ___PD_ALL ___D_HEAP ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_HEAP ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_HEAP ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_load_2d_vm)
___DEF_P_HLBL(___L1__23__23_load_2d_vm)
___DEF_P_HLBL(___L2__23__23_load_2d_vm)
___DEF_P_HLBL(___L3__23__23_load_2d_vm)
___DEF_P_HLBL(___L4__23__23_load_2d_vm)
___DEF_P_HLBL(___L5__23__23_load_2d_vm)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_load_2d_vm)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_load_2d_vm)
   ___SET_R1(___VECTORREF(___GLO__23__23_program_2d_descr,___FIX(0L)))
   ___SET_R2(___VECTORREF(___R1,___FIX(0L)))
   ___SET_R2(___VECTORREF(___R2,___FIX(4L)))
#define ___ARG1 ___R2
{ ___SCMOBJ ___RESULT;
___RESULT = ___CAST(___module_struct*,___FIELD(___ARG1,___FOREIGN_PTR))->init_mod (___PSPNC);
}
#undef ___ARG1
   ___SET_STK(1,___R0)
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1__23__23_load_2d_vm)
   ___SET_R0(___LBL(2))
   ___JUMPINT(___SET_NARGS(1),___PRC(878),___L__23__23_register_2d_module_2d_descrs_21_)
___DEF_SLBL(2,___L2__23__23_load_2d_vm)
   ___SET_R2(___CAR(___R1))
   ___SET_R1(___CDR(___R1))
   ___VECTORSET(___R2,___FIX(2L),___FIX(3L))
   ___SET_R2(___FAL)
   ___SET_R0(___LBL(3))
   ___JUMPINT(___SET_NARGS(2),___PRC(895),___L__23__23_load_2d_required_2d_module_2d_structs)
___DEF_SLBL(3,___L3__23__23_load_2d_vm)
   ___SET_R1(___GLO__23__23_vm_2d_main_2d_module_2d_id)
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),140,___G__23__23_load_2d_required_2d_module)
___DEF_SLBL(4,___L4__23__23_load_2d_vm)
   ___SET_R0(___STK(-3))
   ___POLL(5)
___DEF_SLBL(5,___L5__23__23_load_2d_vm)
   ___ADJFP(-4)
   ___JUMPGLONOTSAFE(___SET_NARGS(0),151,___G__23__23_main)
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_0
#undef ___PH_LBL0
#define ___PH_LBL0 950
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_0)
___DEF_P_HLBL(___L1___kernel_23_0)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_0)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_0)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_VOID
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,___UCS_2STRING ___arg1)
___BEGIN_CFUN_SCMOBJ_TO_UCS_2STRING(___ARG1,___arg1,1)
___BEGIN_CFUN_BODY_CLEANUP
#undef ___AT_END
#define ___return goto ___return___kernel_23_0
___addref_string (___arg1); ___set_gambitdir (___arg1);
___return___kernel_23_0:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY_CLEANUP
___END_CFUN_SCMOBJ_TO_UCS_2STRING(___ARG1,___arg1,1)
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_CLEANUP_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_0)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_1
#undef ___PH_LBL0
#define ___PH_LBL0 953
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_1)
___DEF_P_HLBL(___L1___kernel_23_1)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_1)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_1)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,int ___arg2)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return(___val) do { ___CFUN_ASSIGN(___result,___val) goto ___return___kernel_23_1; } while (0)

     ___return(___EXT(___current_vm_resize) (___PSP ___arg1, ___arg2));

___return___kernel_23_1:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
___END_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_1)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_2
#undef ___PH_LBL0
#define ___PH_LBL0 956
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_2)
___DEF_P_HLBL(___L1___kernel_23_2)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_2)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_2)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN_SCMOBJ
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return(___val) do { ___CFUN_ASSIGN(___result,___val) goto ___return___kernel_23_2; } while (0)

     ___return(___FIX(___VMSTATE_FROM_PSTATE(___ps)->processor_count));

___return___kernel_23_2:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_2)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_3
#undef ___PH_LBL0
#define ___PH_LBL0 959
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_3)
___DEF_P_HLBL(___L1___kernel_23_3)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_3)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_3)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
#define ___result ___CFUN_CAST_AND_DEREF(void**,&___result_voidstar)
___BEGIN_CFUN(void* ___result_voidstar)
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return(___val) do { ___CFUN_ASSIGN_POINTER(___result_voidstar,___val) goto ___return___kernel_23_3; } while (0)

     if (___FIXNUMP(___arg1))
       {
         ___return(___alloc_mem_code (___INT(___arg1)));
       }
     else
       {
         int len = ___INT(___U8VECTORLENGTH(___arg1));
         void *mcb = ___alloc_mem_code (len);
         if (mcb != 0)
           memmove (mcb, ___BODY_AS(___arg1,___tSUBTYPED), len);
         ___return(mcb);
       }

___return___kernel_23_3:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_POINTER_TO_SCMOBJ(___result_voidstar,___C_OBJ_0,___RELEASE_POINTER,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_POINTER_TO_SCMOBJ(___result_voidstar,___C_OBJ_0,___RELEASE_POINTER,___CFUN_RESULT)
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR
___END_CFUN
#undef ___result
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_3)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_4
#undef ___PH_LBL0
#define ___PH_LBL0 962
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_4)
___DEF_P_HLBL(___L1___kernel_23_4)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_4)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_4)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN(___U8 ___result)
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(void*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_NONNULLPOINTER(___ARG1,___arg1_voidstar,___C_OBJ_0,1)
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,int ___arg2)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return(___val) do { ___CFUN_ASSIGN(___result,___val) goto ___return___kernel_23_4; } while (0)

     ___return(___CAST(___U8*,___arg1)[___arg2]);

___return___kernel_23_4:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_U8_TO_SCMOBJ(___result,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_U8_TO_SCMOBJ(___result,___CFUN_RESULT)
___END_CFUN_BODY
___END_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
___END_CFUN_SCMOBJ_TO_NONNULLPOINTER(___ARG1,___arg1_voidstar,___C_OBJ_0,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR
___END_CFUN
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_4)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_5
#undef ___PH_LBL0
#define ___PH_LBL0 965
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_5)
___DEF_P_HLBL(___L1___kernel_23_5)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_5)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___kernel_23_5)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 3
___BEGIN_CFUN_VOID
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(void*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_NONNULLPOINTER(___ARG1,___arg1_voidstar,___C_OBJ_0,1)
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,int ___arg2)
___BEGIN_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG(3,___U8 ___arg3)
___BEGIN_CFUN_SCMOBJ_TO_U8(___ARG3,___arg3,3)
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return goto ___return___kernel_23_5

     ___CAST(___U8*,___arg1)[___arg2] = ___arg3;

___return___kernel_23_5:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY
___END_CFUN_SCMOBJ_TO_U8(___ARG3,___arg3,3)
___END_CFUN_ARG(3)
#undef ___ARG3
___END_CFUN_SCMOBJ_TO_INT(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
___END_CFUN_SCMOBJ_TO_NONNULLPOINTER(___ARG1,___arg1_voidstar,___C_OBJ_0,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_5)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_6
#undef ___PH_LBL0
#define ___PH_LBL0 968
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_6)
___DEF_P_HLBL(___L1___kernel_23_6)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_6)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___kernel_23_6)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(7)
#define ___NARGS 4
___BEGIN_CFUN_SCMOBJ
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG_SCMOBJ(4)
#define ___arg4 ___ARG4
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(void*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_NONNULLPOINTER(___ARG1,___arg1_voidstar,___C_OBJ_0,1)
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return(___val) do { ___CFUN_ASSIGN(___result,___val) goto ___return___kernel_23_6; } while (0)

     ___return(___CAST(___SCMOBJ (*)(___SCMOBJ, ___SCMOBJ, ___SCMOBJ),___arg1)(___arg2, ___arg3, ___arg4));

___return___kernel_23_6:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
___END_CFUN_SCMOBJ_TO_NONNULLPOINTER(___ARG1,___arg1_voidstar,___C_OBJ_0,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
#undef ___arg4
___END_CFUN_ARG_SCMOBJ(4)
#undef ___ARG4
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_6)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_7
#undef ___PH_LBL0
#define ___PH_LBL0 971
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_7)
___DEF_P_HLBL(___L1___kernel_23_7)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_7)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___kernel_23_7)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 3
___BEGIN_CFUN_SCMOBJ
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,void* ___arg1_voidstar)
#define ___arg1 ___CFUN_CAST(void*,___arg1_voidstar)
___BEGIN_CFUN_SCMOBJ_TO_NONNULLPOINTER(___ARG1,___arg1_voidstar,___C_OBJ_0,1)
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return(___val) do { ___CFUN_ASSIGN(___result,___val) goto ___return___kernel_23_7; } while (0)

     ___return(___machine_code_block_fixup (___ps, ___arg1, ___arg2, ___arg3));

___return___kernel_23_7:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
___END_CFUN_SCMOBJ_TO_NONNULLPOINTER(___ARG1,___arg1_voidstar,___C_OBJ_0,1)
#undef ___arg1
___END_CFUN_ARG(1)
#undef ___ARG1
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_7)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_8
#undef ___PH_LBL0
#define ___PH_LBL0 974
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_8)
___DEF_P_HLBL(___L1___kernel_23_8)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_8)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_8)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return(___val) do { ___CFUN_ASSIGN(___result,___val) goto ___return___kernel_23_8; } while (0)

           unsigned int subtype = ___FALSEP(___arg2) ? ___sKEYWORD : ___sSYMBOL;
           ___return(___make_symkey_from_scheme_string (___arg1, subtype));

___return___kernel_23_8:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_8)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_9
#undef ___PH_LBL0
#define ___PH_LBL0 977
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_9)
___DEF_P_HLBL(___L1___kernel_23_9)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_9)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_9)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return(___val) do { ___CFUN_ASSIGN(___result,___val) goto ___return___kernel_23_9; } while (0)

     unsigned int subtype = ___FALSEP(___arg2) ? ___sKEYWORD : ___sSYMBOL;
     ___return(___find_symkey_from_scheme_string (___arg1, subtype));

___return___kernel_23_9:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_9)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_10
#undef ___PH_LBL0
#define ___PH_LBL0 980
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_10)
___DEF_P_HLBL(___L1___kernel_23_10)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_10)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_10)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN(___SIZE_T ___result)
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return(___val) do { ___CFUN_ASSIGN(___result,___val) goto ___return___kernel_23_10; } while (0)

    ___return(___CAST(___SIZE_T,
                      ___CAST(void*,___FIELD(___arg1,___FOREIGN_PTR))));
    
___return___kernel_23_10:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_SIZE_T_TO_SCMOBJ(___result,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_SIZE_T_TO_SCMOBJ(___result,___CFUN_RESULT)
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR
___END_CFUN
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_10)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_11
#undef ___PH_LBL0
#define ___PH_LBL0 983
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_11)
___DEF_P_HLBL(___L1___kernel_23_11)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_11)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_11)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN(char* ___result)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_obj_extension_string())
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_NONNULLCHARSTRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_NONNULLCHARSTRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___END_CFUN_BODY
___CFUN_ERROR
___END_CFUN
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_11)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_12
#undef ___PH_LBL0
#define ___PH_LBL0 986
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_12)
___DEF_P_HLBL(___L1___kernel_23_12)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_12)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_12)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN(char* ___result)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_exe_extension_string())
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_NONNULLCHARSTRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_NONNULLCHARSTRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___END_CFUN_BODY
___CFUN_ERROR
___END_CFUN
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_12)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_13
#undef ___PH_LBL0
#define ___PH_LBL0 989
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_13)
___DEF_P_HLBL(___L1___kernel_23_13)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_13)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_13)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN(char* ___result)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_bat_extension_string())
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_NONNULLCHARSTRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_NONNULLCHARSTRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___END_CFUN_BODY
___CFUN_ERROR
___END_CFUN
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_13)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_14
#undef ___PH_LBL0
#define ___PH_LBL0 992
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_14)
___DEF_P_HLBL(___L1___kernel_23_14)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_14)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_14)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN_VOID
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return goto ___return___kernel_23_14
#ifdef ___ACTIVITY_LOG
___actlog_start (___ps);
#endif
___return___kernel_23_14:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY
___CFUN_ERROR_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_14)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_15
#undef ___PH_LBL0
#define ___PH_LBL0 995
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_15)
___DEF_P_HLBL(___L1___kernel_23_15)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_15)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_15)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN_VOID
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return goto ___return___kernel_23_15
#ifdef ___ACTIVITY_LOG
___actlog_stop (___ps);
#endif
___return___kernel_23_15:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY
___CFUN_ERROR_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_15)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_16
#undef ___PH_LBL0
#define ___PH_LBL0 998
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_16)
___DEF_P_HLBL(___L1___kernel_23_16)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_16)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_16)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_VOID
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,char* ___arg1)
___BEGIN_CFUN_SCMOBJ_TO_CHARSTRING(___ARG1,___arg1,1)
___BEGIN_CFUN_BODY_CLEANUP
#undef ___AT_END
#define ___return goto ___return___kernel_23_16
#ifdef ___ACTIVITY_LOG
___actlog_dump (___VMSTATE_FROM_PSTATE(___ps), ___arg1);
#endif
___return___kernel_23_16:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_VOID
___END_CFUN_BODY_CLEANUP
___END_CFUN_SCMOBJ_TO_CHARSTRING(___ARG1,___arg1,1)
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_CLEANUP_VOID
___END_CFUN_VOID
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_16)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_17
#undef ___PH_LBL0
#define ___PH_LBL0 1001
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_17)
___DEF_P_HLBL(___L1___kernel_23_17)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_17)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___kernel_23_17)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 3
___BEGIN_CFUN(char* ___result)
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG(1,char* ___arg1)
___BEGIN_CFUN_SCMOBJ_TO_CHARSTRING(___ARG1,___arg1,1)
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG(2,___SIZE_T ___arg2)
___BEGIN_CFUN_SCMOBJ_TO_SIZE_T(___ARG2,___arg2,2)
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG(3,___BOOL ___arg3)
___BEGIN_CFUN_SCMOBJ_TO_BOOL(___ARG3,___arg3,3)
___BEGIN_CFUN_BODY_CLEANUP
#undef ___AT_END
___CFUN_ASSIGN(___result,___format_filepos(___arg1,___arg2,___arg3))
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_CHARSTRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_CHARSTRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___END_CFUN_BODY_CLEANUP
___END_CFUN_SCMOBJ_TO_BOOL(___ARG3,___arg3,3)
___END_CFUN_ARG(3)
#undef ___ARG3
___END_CFUN_SCMOBJ_TO_SIZE_T(___ARG2,___arg2,2)
___END_CFUN_ARG(2)
#undef ___ARG2
___END_CFUN_SCMOBJ_TO_CHARSTRING(___ARG1,___arg1,1)
___END_CFUN_ARG(1)
#undef ___ARG1
___CFUN_ERROR_CLEANUP
___END_CFUN
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_17)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_18
#undef ___PH_LBL0
#define ___PH_LBL0 1004
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_18)
___DEF_P_HLBL(___L1___kernel_23_18)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_18)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_18)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_err_code_to_string(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_18)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_19
#undef ___PH_LBL0
#define ___PH_LBL0 1007
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_19)
___DEF_P_HLBL(___L1___kernel_23_19)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_19)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_19)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN_SCMOBJ
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_path_homedir())
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_19)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_20
#undef ___PH_LBL0
#define ___PH_LBL0 1010
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_20)
___DEF_P_HLBL(___L1___kernel_23_20)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_20)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_20)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN_SCMOBJ
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_path_gambitdir())
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_20)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_21
#undef ___PH_LBL0
#define ___PH_LBL0 1013
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_21)
___DEF_P_HLBL(___L1___kernel_23_21)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_21)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_21)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_path_gambitdir_map_lookup(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_21)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_22
#undef ___PH_LBL0
#define ___PH_LBL0 1016
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_22)
___DEF_P_HLBL(___L1___kernel_23_22)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_22)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_22)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_path_normalize_directory(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_22)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_23
#undef ___PH_LBL0
#define ___PH_LBL0 1019
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_23)
___DEF_P_HLBL(___L1___kernel_23_23)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_23)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_23)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN(___UCS_2STRING ___result)
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return(___val) do { ___CFUN_ASSIGN(___result,___val) goto ___return___kernel_23_23; } while (0)
___return(___GSTATE->setup_params.remote_dbg_addr);
___return___kernel_23_23:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_UCS_2STRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_UCS_2STRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___END_CFUN_BODY
___CFUN_ERROR
___END_CFUN
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_23)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_24
#undef ___PH_LBL0
#define ___PH_LBL0 1022
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_24)
___DEF_P_HLBL(___L1___kernel_23_24)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_24)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_24)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN(___UCS_2STRING ___result)
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return(___val) do { ___CFUN_ASSIGN(___result,___val) goto ___return___kernel_23_24; } while (0)
___return(___GSTATE->setup_params.rpc_server_addr);
___return___kernel_23_24:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_UCS_2STRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_UCS_2STRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___END_CFUN_BODY
___CFUN_ERROR
___END_CFUN
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_24)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_25
#undef ___PH_LBL0
#define ___PH_LBL0 1025
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_25)
___DEF_P_HLBL(___L1___kernel_23_25)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_25)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_25)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_getenv(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_25)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_26
#undef ___PH_LBL0
#define ___PH_LBL0 1028
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_26)
___DEF_P_HLBL(___L1___kernel_23_26)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_26)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_26)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_setenv(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_26)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_27
#undef ___PH_LBL0
#define ___PH_LBL0 1031
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_27)
___DEF_P_HLBL(___L1___kernel_23_27)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_27)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_27)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN_SCMOBJ
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_environ())
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_27)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_28
#undef ___PH_LBL0
#define ___PH_LBL0 1034
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_28)
___DEF_P_HLBL(___L1___kernel_23_28)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_28)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_28)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_shell_command(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_28)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_29
#undef ___PH_LBL0
#define ___PH_LBL0 1037
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_29)
___DEF_P_HLBL(___L1___kernel_23_29)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_29)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_29)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_kind(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_29)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_30
#undef ___PH_LBL0
#define ___PH_LBL0 1040
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_30)
___DEF_P_HLBL(___L1___kernel_23_30)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_30)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_30)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_force_output(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_30)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_31
#undef ___PH_LBL0
#define ___PH_LBL0 1043
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_31)
___DEF_P_HLBL(___L1___kernel_23_31)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_31)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_31)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_close(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_31)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_32
#undef ___PH_LBL0
#define ___PH_LBL0 1046
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_32)
___DEF_P_HLBL(___L1___kernel_23_32)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_32)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___kernel_23_32)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 3
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_stream_seek(___arg1,___arg2,___arg3))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_32)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_33
#undef ___PH_LBL0
#define ___PH_LBL0 1049
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_33)
___DEF_P_HLBL(___L1___kernel_23_33)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_33)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___kernel_23_33)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(7)
#define ___NARGS 4
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG_SCMOBJ(4)
#define ___arg4 ___ARG4
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_stream_read(___arg1,___arg2,___arg3,___arg4))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg4
___END_CFUN_ARG_SCMOBJ(4)
#undef ___ARG4
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_33)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_34
#undef ___PH_LBL0
#define ___PH_LBL0 1052
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_34)
___DEF_P_HLBL(___L1___kernel_23_34)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_34)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___kernel_23_34)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(7)
#define ___NARGS 4
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG_SCMOBJ(4)
#define ___arg4 ___ARG4
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_stream_write(___arg1,___arg2,___arg3,___arg4))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg4
___END_CFUN_ARG_SCMOBJ(4)
#undef ___ARG4
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_34)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_35
#undef ___PH_LBL0
#define ___PH_LBL0 1055
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_35)
___DEF_P_HLBL(___L1___kernel_23_35)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_35)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_35)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_stream_width(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_35)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_36
#undef ___PH_LBL0
#define ___PH_LBL0 1058
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_36)
___DEF_P_HLBL(___L1___kernel_23_36)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_36)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_36)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_stream_default_options(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_36)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_37
#undef ___PH_LBL0
#define ___PH_LBL0 1061
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_37)
___DEF_P_HLBL(___L1___kernel_23_37)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_37)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_37)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_stream_options_set(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_37)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_38
#undef ___PH_LBL0
#define ___PH_LBL0 1064
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_38)
___DEF_P_HLBL(___L1___kernel_23_38)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_38)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_38)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_stream_open_predefined(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_38)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_39
#undef ___PH_LBL0
#define ___PH_LBL0 1067
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_39)
___DEF_P_HLBL(___L1___kernel_23_39)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_39)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___kernel_23_39)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 3
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_stream_open_path(___arg1,___arg2,___arg3))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_39)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_40
#undef ___PH_LBL0
#define ___PH_LBL0 1070
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_40)
___DEF_P_HLBL(___L1___kernel_23_40)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_40)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___kernel_23_40)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(7)
#define ___NARGS 4
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG_SCMOBJ(4)
#define ___arg4 ___ARG4
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_stream_open_process(___arg1,___arg2,___arg3,___arg4))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg4
___END_CFUN_ARG_SCMOBJ(4)
#undef ___ARG4
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_40)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_41
#undef ___PH_LBL0
#define ___PH_LBL0 1073
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_41)
___DEF_P_HLBL(___L1___kernel_23_41)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_41)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_41)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_raw_open_from_fd(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_41)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_42
#undef ___PH_LBL0
#define ___PH_LBL0 1076
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_42)
___DEF_P_HLBL(___L1___kernel_23_42)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_42)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_42)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_process_pid(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_42)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_43
#undef ___PH_LBL0
#define ___PH_LBL0 1079
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_43)
___DEF_P_HLBL(___L1___kernel_23_43)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_43)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_43)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_process_status(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_43)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_44
#undef ___PH_LBL0
#define ___PH_LBL0 1082
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_44)
___DEF_P_HLBL(___L1___kernel_23_44)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_44)
   ___IF_NARGS_EQ(7,___NOTHING)
   ___WRONG_NARGS(0,7,0,0)
___DEF_GLBL(___L___kernel_23_44)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 7
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG_SCMOBJ(4)
#define ___arg4 ___ARG4
#define ___ARG5 ___CFUN_ARG(5)
___BEGIN_CFUN_ARG_SCMOBJ(5)
#define ___arg5 ___ARG5
#define ___ARG6 ___CFUN_ARG(6)
___BEGIN_CFUN_ARG_SCMOBJ(6)
#define ___arg6 ___ARG6
#define ___ARG7 ___CFUN_ARG(7)
___BEGIN_CFUN_ARG_SCMOBJ(7)
#define ___arg7 ___ARG7
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_make_tls_context(___arg1,___arg2,___arg3,___arg4,___arg5,___arg6,___arg7))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg7
___END_CFUN_ARG_SCMOBJ(7)
#undef ___ARG7
#undef ___arg6
___END_CFUN_ARG_SCMOBJ(6)
#undef ___ARG6
#undef ___arg5
___END_CFUN_ARG_SCMOBJ(5)
#undef ___ARG5
#undef ___arg4
___END_CFUN_ARG_SCMOBJ(4)
#undef ___ARG4
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_44)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(8))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_45
#undef ___PH_LBL0
#define ___PH_LBL0 1085
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_45)
___DEF_P_HLBL(___L1___kernel_23_45)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_45)
   ___IF_NARGS_EQ(7,___NOTHING)
   ___WRONG_NARGS(0,7,0,0)
___DEF_GLBL(___L___kernel_23_45)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 7
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG_SCMOBJ(4)
#define ___arg4 ___ARG4
#define ___ARG5 ___CFUN_ARG(5)
___BEGIN_CFUN_ARG_SCMOBJ(5)
#define ___arg5 ___ARG5
#define ___ARG6 ___CFUN_ARG(6)
___BEGIN_CFUN_ARG_SCMOBJ(6)
#define ___arg6 ___ARG6
#define ___ARG7 ___CFUN_ARG(7)
___BEGIN_CFUN_ARG_SCMOBJ(7)
#define ___arg7 ___ARG7
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_tcp_client_open(___arg1,___arg2,___arg3,___arg4,___arg5,___arg6,___arg7))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg7
___END_CFUN_ARG_SCMOBJ(7)
#undef ___ARG7
#undef ___arg6
___END_CFUN_ARG_SCMOBJ(6)
#undef ___ARG6
#undef ___arg5
___END_CFUN_ARG_SCMOBJ(5)
#undef ___ARG5
#undef ___arg4
___END_CFUN_ARG_SCMOBJ(4)
#undef ___ARG4
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_45)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(8))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_46
#undef ___PH_LBL0
#define ___PH_LBL0 1088
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_46)
___DEF_P_HLBL(___L1___kernel_23_46)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_46)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_46)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_tcp_client_socket_info(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_46)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_47
#undef ___PH_LBL0
#define ___PH_LBL0 1091
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_47)
___DEF_P_HLBL(___L1___kernel_23_47)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_47)
   ___IF_NARGS_EQ(5,___NOTHING)
   ___WRONG_NARGS(0,5,0,0)
___DEF_GLBL(___L___kernel_23_47)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(10)
#define ___NARGS 5
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG_SCMOBJ(4)
#define ___arg4 ___ARG4
#define ___ARG5 ___CFUN_ARG(5)
___BEGIN_CFUN_ARG_SCMOBJ(5)
#define ___arg5 ___ARG5
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_tcp_server_open(___arg1,___arg2,___arg3,___arg4,___arg5))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg5
___END_CFUN_ARG_SCMOBJ(5)
#undef ___ARG5
#undef ___arg4
___END_CFUN_ARG_SCMOBJ(4)
#undef ___ARG4
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_47)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(6))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_48
#undef ___PH_LBL0
#define ___PH_LBL0 1094
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_48)
___DEF_P_HLBL(___L1___kernel_23_48)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_48)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_48)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_tcp_server_read(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_48)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_49
#undef ___PH_LBL0
#define ___PH_LBL0 1097
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_49)
___DEF_P_HLBL(___L1___kernel_23_49)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_49)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_49)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_tcp_server_socket_info(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_49)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_50
#undef ___PH_LBL0
#define ___PH_LBL0 1100
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_50)
___DEF_P_HLBL(___L1___kernel_23_50)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_50)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___kernel_23_50)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 3
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_udp_open(___arg1,___arg2,___arg3))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_50)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_51
#undef ___PH_LBL0
#define ___PH_LBL0 1103
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_51)
___DEF_P_HLBL(___L1___kernel_23_51)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_51)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___kernel_23_51)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(7)
#define ___NARGS 4
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG_SCMOBJ(4)
#define ___arg4 ___ARG4
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_udp_read_subu8vector(___arg1,___arg2,___arg3,___arg4))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg4
___END_CFUN_ARG_SCMOBJ(4)
#undef ___ARG4
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_51)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_52
#undef ___PH_LBL0
#define ___PH_LBL0 1106
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_52)
___DEF_P_HLBL(___L1___kernel_23_52)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_52)
   ___IF_NARGS_EQ(4,___NOTHING)
   ___WRONG_NARGS(0,4,0,0)
___DEF_GLBL(___L___kernel_23_52)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(7)
#define ___NARGS 4
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG_SCMOBJ(4)
#define ___arg4 ___ARG4
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_udp_write_subu8vector(___arg1,___arg2,___arg3,___arg4))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg4
___END_CFUN_ARG_SCMOBJ(4)
#undef ___ARG4
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_52)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(5))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_53
#undef ___PH_LBL0
#define ___PH_LBL0 1109
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_53)
___DEF_P_HLBL(___L1___kernel_23_53)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_53)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___kernel_23_53)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 3
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_udp_destination_set(___arg1,___arg2,___arg3))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_53)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_54
#undef ___PH_LBL0
#define ___PH_LBL0 1112
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_54)
___DEF_P_HLBL(___L1___kernel_23_54)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_54)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_54)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_udp_socket_info(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_54)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_55
#undef ___PH_LBL0
#define ___PH_LBL0 1115
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_55)
___DEF_P_HLBL(___L1___kernel_23_55)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_55)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_55)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_directory_open_path(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_55)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_56
#undef ___PH_LBL0
#define ___PH_LBL0 1118
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_56)
___DEF_P_HLBL(___L1___kernel_23_56)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_56)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_56)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_directory_read(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_56)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_57
#undef ___PH_LBL0
#define ___PH_LBL0 1121
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_57)
___DEF_P_HLBL(___L1___kernel_23_57)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_57)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_57)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_event_queue_open(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_57)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_58
#undef ___PH_LBL0
#define ___PH_LBL0 1124
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_58)
___DEF_P_HLBL(___L1___kernel_23_58)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_58)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_58)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_event_queue_read(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_58)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_59
#undef ___PH_LBL0
#define ___PH_LBL0 1127
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_59)
___DEF_P_HLBL(___L1___kernel_23_59)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_59)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___kernel_23_59)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 3
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_tty_type_set(___arg1,___arg2,___arg3))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_59)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_60
#undef ___PH_LBL0
#define ___PH_LBL0 1130
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_60)
___DEF_P_HLBL(___L1___kernel_23_60)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_60)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___kernel_23_60)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 3
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_tty_text_attributes_set(___arg1,___arg2,___arg3))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_60)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_61
#undef ___PH_LBL0
#define ___PH_LBL0 1133
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_61)
___DEF_P_HLBL(___L1___kernel_23_61)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_61)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_61)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_tty_history(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_61)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_62
#undef ___PH_LBL0
#define ___PH_LBL0 1136
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_62)
___DEF_P_HLBL(___L1___kernel_23_62)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_62)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_62)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_tty_history_set(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_62)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_63
#undef ___PH_LBL0
#define ___PH_LBL0 1139
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_63)
___DEF_P_HLBL(___L1___kernel_23_63)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_63)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_63)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_tty_history_max_length_set(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_63)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_64
#undef ___PH_LBL0
#define ___PH_LBL0 1142
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_64)
___DEF_P_HLBL(___L1___kernel_23_64)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_64)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_64)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_tty_paren_balance_duration_set(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_64)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_65
#undef ___PH_LBL0
#define ___PH_LBL0 1145
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_65)
___DEF_P_HLBL(___L1___kernel_23_65)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_65)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L___kernel_23_65)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(9)
#define ___NARGS 6
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG_SCMOBJ(4)
#define ___arg4 ___ARG4
#define ___ARG5 ___CFUN_ARG(5)
___BEGIN_CFUN_ARG_SCMOBJ(5)
#define ___arg5 ___ARG5
#define ___ARG6 ___CFUN_ARG(6)
___BEGIN_CFUN_ARG_SCMOBJ(6)
#define ___arg6 ___ARG6
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_device_tty_mode_set(___arg1,___arg2,___arg3,___arg4,___arg5,___arg6))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg6
___END_CFUN_ARG_SCMOBJ(6)
#undef ___ARG6
#undef ___arg5
___END_CFUN_ARG_SCMOBJ(5)
#undef ___ARG5
#undef ___arg4
___END_CFUN_ARG_SCMOBJ(4)
#undef ___ARG4
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_65)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(7))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_66
#undef ___PH_LBL0
#define ___PH_LBL0 1148
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_66)
___DEF_P_HLBL(___L1___kernel_23_66)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_66)
   ___IF_NARGS_EQ(3,___NOTHING)
   ___WRONG_NARGS(0,3,0,0)
___DEF_GLBL(___L___kernel_23_66)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 3
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_file_times_set(___arg1,___arg2,___arg3))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_66)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(4))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_67
#undef ___PH_LBL0
#define ___PH_LBL0 1151
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_67)
___DEF_P_HLBL(___L1___kernel_23_67)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_67)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_67)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_file_info(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_67)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_68
#undef ___PH_LBL0
#define ___PH_LBL0 1154
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_68)
___DEF_P_HLBL(___L1___kernel_23_68)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_68)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_68)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_user_info(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_68)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_69
#undef ___PH_LBL0
#define ___PH_LBL0 1157
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_69)
___DEF_P_HLBL(___L1___kernel_23_69)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_69)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_69)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN_SCMOBJ
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_user_name())
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_69)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_70
#undef ___PH_LBL0
#define ___PH_LBL0 1160
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_70)
___DEF_P_HLBL(___L1___kernel_23_70)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_70)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_70)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_group_info(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_70)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_71
#undef ___PH_LBL0
#define ___PH_LBL0 1163
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_71)
___DEF_P_HLBL(___L1___kernel_23_71)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_71)
   ___IF_NARGS_EQ(6,___NOTHING)
   ___WRONG_NARGS(0,6,0,0)
___DEF_GLBL(___L___kernel_23_71)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R3)
   ___SET_STK(4,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(9)
#define ___NARGS 6
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
#define ___ARG3 ___CFUN_ARG(3)
___BEGIN_CFUN_ARG_SCMOBJ(3)
#define ___arg3 ___ARG3
#define ___ARG4 ___CFUN_ARG(4)
___BEGIN_CFUN_ARG_SCMOBJ(4)
#define ___arg4 ___ARG4
#define ___ARG5 ___CFUN_ARG(5)
___BEGIN_CFUN_ARG_SCMOBJ(5)
#define ___arg5 ___ARG5
#define ___ARG6 ___CFUN_ARG(6)
___BEGIN_CFUN_ARG_SCMOBJ(6)
#define ___arg6 ___ARG6
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_address_infos(___arg1,___arg2,___arg3,___arg4,___arg5,___arg6))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg6
___END_CFUN_ARG_SCMOBJ(6)
#undef ___ARG6
#undef ___arg5
___END_CFUN_ARG_SCMOBJ(5)
#undef ___ARG5
#undef ___arg4
___END_CFUN_ARG_SCMOBJ(4)
#undef ___ARG4
#undef ___arg3
___END_CFUN_ARG_SCMOBJ(3)
#undef ___ARG3
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_71)
   ___ADJFP(-12)
   ___JUMPPRM(___NOTHING,___STK(7))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_72
#undef ___PH_LBL0
#define ___PH_LBL0 1166
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_72)
___DEF_P_HLBL(___L1___kernel_23_72)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_72)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_72)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_host_info(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_72)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_73
#undef ___PH_LBL0
#define ___PH_LBL0 1169
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_73)
___DEF_P_HLBL(___L1___kernel_23_73)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_73)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_73)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN_SCMOBJ
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_host_name())
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_73)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_74
#undef ___PH_LBL0
#define ___PH_LBL0 1172
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_74)
___DEF_P_HLBL(___L1___kernel_23_74)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_74)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_74)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_service_info(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_74)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_75
#undef ___PH_LBL0
#define ___PH_LBL0 1175
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_75)
___DEF_P_HLBL(___L1___kernel_23_75)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_75)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_75)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_protocol_info(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_75)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_76
#undef ___PH_LBL0
#define ___PH_LBL0 1178
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_76)
___DEF_P_HLBL(___L1___kernel_23_76)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_76)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_76)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_network_info(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_76)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_77
#undef ___PH_LBL0
#define ___PH_LBL0 1181
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_77)
___DEF_P_HLBL(___L1___kernel_23_77)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_77)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_77)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN_SCMOBJ
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_getpid())
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_77)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_78
#undef ___PH_LBL0
#define ___PH_LBL0 1184
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_78)
___DEF_P_HLBL(___L1___kernel_23_78)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_78)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_78)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN_SCMOBJ
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_getppid())
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_78)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_79
#undef ___PH_LBL0
#define ___PH_LBL0 1187
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_79)
___DEF_P_HLBL(___L1___kernel_23_79)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_79)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_79)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_create_directory(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_79)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_80
#undef ___PH_LBL0
#define ___PH_LBL0 1190
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_80)
___DEF_P_HLBL(___L1___kernel_23_80)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_80)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_80)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_create_fifo(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_80)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_81
#undef ___PH_LBL0
#define ___PH_LBL0 1193
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_81)
___DEF_P_HLBL(___L1___kernel_23_81)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_81)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_81)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_create_link(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_81)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_82
#undef ___PH_LBL0
#define ___PH_LBL0 1196
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_82)
___DEF_P_HLBL(___L1___kernel_23_82)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_82)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_82)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_create_symbolic_link(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_82)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_83
#undef ___PH_LBL0
#define ___PH_LBL0 1199
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_83)
___DEF_P_HLBL(___L1___kernel_23_83)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_83)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_83)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_delete_directory(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_83)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_84
#undef ___PH_LBL0
#define ___PH_LBL0 1202
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_84)
___DEF_P_HLBL(___L1___kernel_23_84)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_84)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_84)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_set_current_directory(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_84)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_85
#undef ___PH_LBL0
#define ___PH_LBL0 1205
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_85)
___DEF_P_HLBL(___L1___kernel_23_85)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_85)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_85)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_rename_file(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_85)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_86
#undef ___PH_LBL0
#define ___PH_LBL0 1208
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_86)
___DEF_P_HLBL(___L1___kernel_23_86)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_86)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_86)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_copy_file(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_86)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_87
#undef ___PH_LBL0
#define ___PH_LBL0 1211
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_87)
___DEF_P_HLBL(___L1___kernel_23_87)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_87)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L___kernel_23_87)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 1
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_delete_file(___arg1))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_87)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(2))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_88
#undef ___PH_LBL0
#define ___PH_LBL0 1214
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_88)
___DEF_P_HLBL(___L1___kernel_23_88)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_88)
   ___IF_NARGS_EQ(2,___NOTHING)
   ___WRONG_NARGS(0,2,0,0)
___DEF_GLBL(___L___kernel_23_88)
   ___SET_STK(1,___R1)
   ___SET_STK(2,___R2)
   ___SET_STK(3,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(8)
#define ___NARGS 2
___BEGIN_CFUN_SCMOBJ
#define ___ARG1 ___CFUN_ARG(1)
___BEGIN_CFUN_ARG_SCMOBJ(1)
#define ___arg1 ___ARG1
#define ___ARG2 ___CFUN_ARG(2)
___BEGIN_CFUN_ARG_SCMOBJ(2)
#define ___arg2 ___ARG2
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_load_object_file(___arg1,___arg2))
#ifndef ___AT_END
#define ___AT_END
#endif
___CFUN_SET_RESULT_SCMOBJ
___END_CFUN_BODY
#undef ___arg2
___END_CFUN_ARG_SCMOBJ(2)
#undef ___ARG2
#undef ___arg1
___END_CFUN_ARG_SCMOBJ(1)
#undef ___ARG1
___CFUN_ERROR_SCMOBJ
___END_CFUN_SCMOBJ
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_88)
   ___ADJFP(-8)
   ___JUMPPRM(___NOTHING,___STK(3))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_89
#undef ___PH_LBL0
#define ___PH_LBL0 1217
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_89)
___DEF_P_HLBL(___L1___kernel_23_89)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_89)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_89)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN(char** ___result)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_system_type())
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_NONNULLCHARSTRINGLIST_TO_SCMOBJ(___result,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_NONNULLCHARSTRINGLIST_TO_SCMOBJ(___result,___CFUN_RESULT)
___END_CFUN_BODY
___CFUN_ERROR
___END_CFUN
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_89)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_90
#undef ___PH_LBL0
#define ___PH_LBL0 1220
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_90)
___DEF_P_HLBL(___L1___kernel_23_90)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_90)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_90)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN(char* ___result)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_system_type_string())
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_NONNULLCHARSTRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_NONNULLCHARSTRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___END_CFUN_BODY
___CFUN_ERROR
___END_CFUN
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_90)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_91
#undef ___PH_LBL0
#define ___PH_LBL0 1223
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_91)
___DEF_P_HLBL(___L1___kernel_23_91)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_91)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_91)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN(char* ___result)
___BEGIN_CFUN_BODY
#undef ___AT_END
___CFUN_ASSIGN(___result,___os_configure_command_string())
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_NONNULLCHARSTRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_NONNULLCHARSTRING_TO_SCMOBJ(___result,___CFUN_RESULT)
___END_CFUN_BODY
___CFUN_ERROR
___END_CFUN
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_91)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H___kernel_23_92
#undef ___PH_LBL0
#define ___PH_LBL0 1226
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0___kernel_23_92)
___DEF_P_HLBL(___L1___kernel_23_92)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0___kernel_23_92)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L___kernel_23_92)
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(1))
   ___ADJFP(4)
#define ___NARGS 0
___BEGIN_CFUN(___U64 ___result)
___BEGIN_CFUN_BODY
#undef ___AT_END
#define ___return(___val) do { ___CFUN_ASSIGN(___result,___val) goto ___return___kernel_23_92; } while (0)
___return(___U64_add_U64_U64
                 (___U64_mul_UM32_UM32 (___STAMP_YMD, 1000000),
                  ___U64_from_UM32 (___STAMP_HMS)));
___return___kernel_23_92:;
#undef ___return
#ifndef ___AT_END
#define ___AT_END
#endif
___BEGIN_CFUN_U64_TO_SCMOBJ(___result,___CFUN_RESULT)
___CFUN_SET_RESULT
___END_CFUN_U64_TO_SCMOBJ(___result,___CFUN_RESULT)
___END_CFUN_BODY
___CFUN_ERROR
___END_CFUN
#undef ___NARGS
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(1,___L1___kernel_23_92)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H__23__23_main
#undef ___PH_LBL0
#define ___PH_LBL0 1229
#undef ___PD_ALL
#define ___PD_ALL ___D_R0 ___D_R1
#undef ___PR_ALL
#define ___PR_ALL ___R_R0 ___R_R1
#undef ___PW_ALL
#define ___PW_ALL ___W_R1
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__23__23_main)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__23__23_main)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__23__23_main)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H___kernel_23_,"_kernel#",___REF_FAL,27,0)
,___DEF_LBL_PROC(___H___kernel_23_,0,-1)
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_PROC(___H___kernel_23_,0,-1)
,___DEF_LBL_RET(___H___kernel_23_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H___kernel_23_,0,-1)
,___DEF_LBL_INTRO(___H__23__23_kernel_2d_handlers,"##kernel-handlers",___REF_FAL,14,0)
,___DEF_LBL_PROC(___H__23__23_kernel_2d_handlers,0,-1)
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_kernel_2d_handlers,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H__23__23_dynamic_2d_env_2d_bind,"##dynamic-env-bind",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_dynamic_2d_env_2d_bind,2,-1)
,___DEF_LBL_RET(___H__23__23_dynamic_2d_env_2d_bind,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H__23__23_assq_2d_cdr,"##assq-cdr",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_assq_2d_cdr,2,-1)
,___DEF_LBL_RET(___H__23__23_assq_2d_cdr,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_assq_2d_cdr,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_assq,"##assq",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_assq,2,-1)
,___DEF_LBL_RET(___H__23__23_assq,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_assq,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_disable_2d_interrupts_21_,"##disable-interrupts!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_disable_2d_interrupts_21_,0,-1)
,___DEF_LBL_INTRO(___H__23__23_enable_2d_interrupts_21_,"##enable-interrupts!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_enable_2d_interrupts_21_,0,-1)
,___DEF_LBL_INTRO(___H__23__23_sync_2d_op_2d_interrupt_21_,"##sync-op-interrupt!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_sync_2d_op_2d_interrupt_21_,0,-1)
,___DEF_LBL_INTRO(___H__23__23_interrupt_2d_handler,"##interrupt-handler",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_interrupt_2d_handler,0,-1)
,___DEF_LBL_RET(___H__23__23_interrupt_2d_handler,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_PROC(___H__23__23_interrupt_2d_handler,0,-1)
,___DEF_LBL_INTRO(___H__23__23_interrupt_2d_vector_2d_set_21_,"##interrupt-vector-set!",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H__23__23_interrupt_2d_vector_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_get_2d_heartbeat_2d_interval_21_,"##get-heartbeat-interval!",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_get_2d_heartbeat_2d_interval_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_set_2d_heartbeat_2d_interval_21_,"##set-heartbeat-interval!",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_set_2d_heartbeat_2d_interval_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_raise_2d_high_2d_level_2d_interrupt_21_,"##raise-high-level-interrupt!",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_high_2d_level_2d_interrupt_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_argument_2d_list_2d_remove_2d_absent_21_,"##argument-list-remove-absent!",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__23__23_argument_2d_list_2d_remove_2d_absent_21_,2,-1)
,___DEF_LBL_RET(___H__23__23_argument_2d_list_2d_remove_2d_absent_21_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H__23__23_argument_2d_list_2d_remove_2d_absent_21_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_RET(___H__23__23_argument_2d_list_2d_remove_2d_absent_21_,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_,"##argument-list-remove-absent-keys!",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_,1,-1)
,___DEF_LBL_RET(___H__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_,"##argument-list-fix-rest-param!",
___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_,1,-1)
,___DEF_LBL_RET(___H__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_extract_2d_procedure_2d_and_2d_arguments,"##extract-procedure-and-arguments",
___REF_FAL,10,0)
,___DEF_LBL_PROC(___H__23__23_extract_2d_procedure_2d_and_2d_arguments,6,-1)
,___DEF_LBL_RET(___H__23__23_extract_2d_procedure_2d_and_2d_arguments,___OFD(___RETI,12,3,0x3f07dL))
,___DEF_LBL_RET(___H__23__23_extract_2d_procedure_2d_and_2d_arguments,___IFD(___RETN,9,3,0x7dL))
,___DEF_LBL_RET(___H__23__23_extract_2d_procedure_2d_and_2d_arguments,___IFD(___RETN,9,3,0x7dL))
,___DEF_LBL_RET(___H__23__23_extract_2d_procedure_2d_and_2d_arguments,___OFD(___RETI,12,12,0x3f043L))
,___DEF_LBL_RET(___H__23__23_extract_2d_procedure_2d_and_2d_arguments,___OFD(___RETI,12,4,0x3f0f7L))
,___DEF_LBL_RET(___H__23__23_extract_2d_procedure_2d_and_2d_arguments,___IFD(___RETN,9,4,0xf7L))
,___DEF_LBL_RET(___H__23__23_extract_2d_procedure_2d_and_2d_arguments,___IFD(___RETN,9,4,0xf5L))
,___DEF_LBL_RET(___H__23__23_extract_2d_procedure_2d_and_2d_arguments,___OFD(___RETI,12,12,0x3f083L))
,___DEF_LBL_RET(___H__23__23_extract_2d_procedure_2d_and_2d_arguments,___OFD(___RETI,12,3,0x3f07dL))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_type_2d_exception,"##fail-check-type-exception",___REF_FAL,
2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_type_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_type_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_type_2d_exception_3f_,"type-exception?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_type_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H_type_2d_exception_2d_procedure,"type-exception-procedure",___REF_FAL,2,0)

,___DEF_LBL_PROC(___H_type_2d_exception_2d_procedure,1,-1)
,___DEF_LBL_RET(___H_type_2d_exception_2d_procedure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_type_2d_exception_2d_arguments,"type-exception-arguments",___REF_FAL,2,0)

,___DEF_LBL_PROC(___H_type_2d_exception_2d_arguments,1,-1)
,___DEF_LBL_RET(___H_type_2d_exception_2d_arguments,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_type_2d_exception_2d_arg_2d_num,"type-exception-arg-num",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_type_2d_exception_2d_arg_2d_num,1,-1)
,___DEF_LBL_RET(___H_type_2d_exception_2d_arg_2d_num,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_type_2d_exception_2d_type_2d_id,"type-exception-type-id",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_type_2d_exception_2d_type_2d_id,1,-1)
,___DEF_LBL_RET(___H_type_2d_exception_2d_type_2d_id,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_raise_2d_type_2d_exception,"##raise-type-exception",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_type_2d_exception,4,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_type_2d_exception,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_PROC(___H__23__23_raise_2d_type_2d_exception,5,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_type_2d_exception,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_RET(___H__23__23_raise_2d_type_2d_exception,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception,"##fail-check-heap-overflow-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_heap_2d_overflow_2d_exception_3f_,"heap-overflow-exception?",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H_heap_2d_overflow_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_raise_2d_heap_2d_overflow_2d_exception,"##raise-heap-overflow-exception",
___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_heap_2d_overflow_2d_exception,0,-1)
,___DEF_LBL_PROC(___H__23__23_raise_2d_heap_2d_overflow_2d_exception,0,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_heap_2d_overflow_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception,"##fail-check-stack-overflow-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_stack_2d_overflow_2d_exception_3f_,"stack-overflow-exception?",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H_stack_2d_overflow_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_raise_2d_stack_2d_overflow_2d_exception,"##raise-stack-overflow-exception",
___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_stack_2d_overflow_2d_exception,0,-1)
,___DEF_LBL_PROC(___H__23__23_raise_2d_stack_2d_overflow_2d_exception,0,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_stack_2d_overflow_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception,"##fail-check-nonprocedure-operator-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_nonprocedure_2d_operator_2d_exception_3f_,"nonprocedure-operator-exception?",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_nonprocedure_2d_operator_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H_nonprocedure_2d_operator_2d_exception_2d_operator,"nonprocedure-operator-exception-operator",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_nonprocedure_2d_operator_2d_exception_2d_operator,1,-1)
,___DEF_LBL_RET(___H_nonprocedure_2d_operator_2d_exception_2d_operator,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_nonprocedure_2d_operator_2d_exception_2d_arguments,"nonprocedure-operator-exception-arguments",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_nonprocedure_2d_operator_2d_exception_2d_arguments,1,-1)
,___DEF_LBL_RET(___H_nonprocedure_2d_operator_2d_exception_2d_arguments,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_nonprocedure_2d_operator_2d_exception_2d_code,"nonprocedure-operator-exception-code",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_nonprocedure_2d_operator_2d_exception_2d_code,1,-1)
,___DEF_LBL_RET(___H_nonprocedure_2d_operator_2d_exception_2d_code,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_nonprocedure_2d_operator_2d_exception_2d_rte,"nonprocedure-operator-exception-rte",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_nonprocedure_2d_operator_2d_exception_2d_rte,1,-1)
,___DEF_LBL_RET(___H_nonprocedure_2d_operator_2d_exception_2d_rte,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary,"##apply-global-with-procedure-check-nary",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary,2,-1)
,___DEF_LBL_INTRO(___H__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary,"##apply-with-procedure-check-nary",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary,2,-1)
,___DEF_LBL_INTRO(___H__23__23_apply_2d_with_2d_procedure_2d_check,"##apply-with-procedure-check",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H__23__23_apply_2d_with_2d_procedure_2d_check,2,-1)
,___DEF_LBL_INTRO(___H__23__23_raise_2d_nonprocedure_2d_operator_2d_exception,"##raise-nonprocedure-operator-exception",
___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_nonprocedure_2d_operator_2d_exception,4,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_nonprocedure_2d_operator_2d_exception,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H__23__23_raise_2d_nonprocedure_2d_operator_2d_exception,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception,"##fail-check-wrong-number-of-arguments-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_,"wrong-number-of-arguments-exception?",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure,"wrong-number-of-arguments-exception-procedure",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure,1,-1)
,___DEF_LBL_RET(___H_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments,"wrong-number-of-arguments-exception-arguments",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments,1,-1)
,___DEF_LBL_RET(___H_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary,"##raise-wrong-number-of-arguments-exception-nary",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary,2,-1)
,___DEF_LBL_INTRO(___H__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception,"##raise-wrong-number-of-arguments-exception",
___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception,2,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception,"##fail-check-keyword-expected-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_keyword_2d_expected_2d_exception_3f_,"keyword-expected-exception?",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H_keyword_2d_expected_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H_keyword_2d_expected_2d_exception_2d_procedure,"keyword-expected-exception-procedure",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_keyword_2d_expected_2d_exception_2d_procedure,1,-1)
,___DEF_LBL_RET(___H_keyword_2d_expected_2d_exception_2d_procedure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_keyword_2d_expected_2d_exception_2d_arguments,"keyword-expected-exception-arguments",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_keyword_2d_expected_2d_exception_2d_arguments,1,-1)
,___DEF_LBL_RET(___H_keyword_2d_expected_2d_exception_2d_arguments,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary,"##raise-keyword-expected-exception-nary",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary,2,-1)
,___DEF_LBL_INTRO(___H__23__23_raise_2d_keyword_2d_expected_2d_exception,"##raise-keyword-expected-exception",
___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_keyword_2d_expected_2d_exception,2,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_keyword_2d_expected_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_raise_2d_keyword_2d_expected_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception,"##fail-check-unknown-keyword-argument-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_unknown_2d_keyword_2d_argument_2d_exception_3f_,"unknown-keyword-argument-exception?",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_unknown_2d_keyword_2d_argument_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure,"unknown-keyword-argument-exception-procedure",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure,1,-1)
,___DEF_LBL_RET(___H_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments,"unknown-keyword-argument-exception-arguments",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments,1,-1)
,___DEF_LBL_RET(___H_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary,"##raise-unknown-keyword-argument-exception-nary",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary,2,-1)
,___DEF_LBL_INTRO(___H__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception,"##raise-unknown-keyword-argument-exception",
___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception,2,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_os_2d_exception,"##fail-check-os-exception",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_os_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_os_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_os_2d_exception_3f_,"os-exception?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_os_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H_os_2d_exception_2d_procedure,"os-exception-procedure",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_os_2d_exception_2d_procedure,1,-1)
,___DEF_LBL_RET(___H_os_2d_exception_2d_procedure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_os_2d_exception_2d_arguments,"os-exception-arguments",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_os_2d_exception_2d_arguments,1,-1)
,___DEF_LBL_RET(___H_os_2d_exception_2d_arguments,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_os_2d_exception_2d_message,"os-exception-message",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_os_2d_exception_2d_message,1,-1)
,___DEF_LBL_RET(___H_os_2d_exception_2d_message,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_os_2d_exception_2d_code,"os-exception-code",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_os_2d_exception_2d_code,1,-1)
,___DEF_LBL_RET(___H_os_2d_exception_2d_code,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_raise_2d_os_2d_exception,"##raise-os-exception",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_os_2d_exception,4,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_os_2d_exception,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_PROC(___H__23__23_raise_2d_os_2d_exception,5,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_os_2d_exception,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_RET(___H__23__23_raise_2d_os_2d_exception,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_RET(___H__23__23_raise_2d_os_2d_exception,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,"##fail-check-no-such-file-or-directory-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_,"no-such-file-or-directory-exception?",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure,"no-such-file-or-directory-exception-procedure",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure,1,-1)
,___DEF_LBL_RET(___H_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments,"no-such-file-or-directory-exception-arguments",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments,1,-1)
,___DEF_LBL_RET(___H_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,"##raise-no-such-file-or-directory-exception",
___REF_FAL,5,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,2,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_PROC(___H__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,5,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_RET(___H__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception,"##fail-check-cfun-conversion-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_cfun_2d_conversion_2d_exception_3f_,"cfun-conversion-exception?",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H_cfun_2d_conversion_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H_cfun_2d_conversion_2d_exception_2d_procedure,"cfun-conversion-exception-procedure",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_cfun_2d_conversion_2d_exception_2d_procedure,1,-1)
,___DEF_LBL_RET(___H_cfun_2d_conversion_2d_exception_2d_procedure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_cfun_2d_conversion_2d_exception_2d_arguments,"cfun-conversion-exception-arguments",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_cfun_2d_conversion_2d_exception_2d_arguments,1,-1)
,___DEF_LBL_RET(___H_cfun_2d_conversion_2d_exception_2d_arguments,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_cfun_2d_conversion_2d_exception_2d_code,"cfun-conversion-exception-code",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_cfun_2d_conversion_2d_exception_2d_code,1,-1)
,___DEF_LBL_RET(___H_cfun_2d_conversion_2d_exception_2d_code,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_cfun_2d_conversion_2d_exception_2d_message,"cfun-conversion-exception-message",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_cfun_2d_conversion_2d_exception_2d_message,1,-1)
,___DEF_LBL_RET(___H_cfun_2d_conversion_2d_exception_2d_message,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary,"##raise-cfun-conversion-exception-nary",
___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary,4,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_RET(___H__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary,___IFD(___RETI,1,4,0x3f0L))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception,"##fail-check-sfun-conversion-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_sfun_2d_conversion_2d_exception_3f_,"sfun-conversion-exception?",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H_sfun_2d_conversion_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H_sfun_2d_conversion_2d_exception_2d_procedure,"sfun-conversion-exception-procedure",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_sfun_2d_conversion_2d_exception_2d_procedure,1,-1)
,___DEF_LBL_RET(___H_sfun_2d_conversion_2d_exception_2d_procedure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_sfun_2d_conversion_2d_exception_2d_arguments,"sfun-conversion-exception-arguments",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_sfun_2d_conversion_2d_exception_2d_arguments,1,-1)
,___DEF_LBL_RET(___H_sfun_2d_conversion_2d_exception_2d_arguments,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_sfun_2d_conversion_2d_exception_2d_code,"sfun-conversion-exception-code",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_sfun_2d_conversion_2d_exception_2d_code,1,-1)
,___DEF_LBL_RET(___H_sfun_2d_conversion_2d_exception_2d_code,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_sfun_2d_conversion_2d_exception_2d_message,"sfun-conversion-exception-message",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_sfun_2d_conversion_2d_exception_2d_message,1,-1)
,___DEF_LBL_RET(___H_sfun_2d_conversion_2d_exception_2d_message,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_raise_2d_sfun_2d_conversion_2d_exception,"##raise-sfun-conversion-exception",
___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_sfun_2d_conversion_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_sfun_2d_conversion_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_raise_2d_sfun_2d_conversion_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception,"##fail-check-multiple-c-return-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_multiple_2d_c_2d_return_2d_exception_3f_,"multiple-c-return-exception?",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H_multiple_2d_c_2d_return_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception,"##raise-multiple-c-return-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception,0,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception,"##fail-check-wrong-processor-c-return-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_,"wrong-processor-c-return-exception?",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception,"##raise-wrong-processor-c-return-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception,0,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_,"##c-return-on-other-processor-hook-set!",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_c_2d_return_2d_on_2d_other_2d_processor,"##c-return-on-other-processor",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H__23__23_c_2d_return_2d_on_2d_other_2d_processor,1,-1)
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception,"##fail-check-number-of-arguments-limit-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_,"number-of-arguments-limit-exception?",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure,"number-of-arguments-limit-exception-procedure",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure,1,-1)
,___DEF_LBL_RET(___H_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments,"number-of-arguments-limit-exception-arguments",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments,1,-1)
,___DEF_LBL_RET(___H_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception,"##raise-number-of-arguments-limit-exception",
___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception,2,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_make_2d_promise,"##make-promise",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_promise,1,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_promise,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_promise_2d_thunk,"##promise-thunk",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_promise_2d_thunk,1,-1)
,___DEF_LBL_INTRO(___H__23__23_promise_2d_thunk_2d_set_21_,"##promise-thunk-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_promise_2d_thunk_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_promise_2d_result,"##promise-result",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_promise_2d_result,1,-1)
,___DEF_LBL_INTRO(___H__23__23_promise_2d_result_2d_set_21_,"##promise-result-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_promise_2d_result_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_force_2d_undetermined,"##force-undetermined",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H__23__23_force_2d_undetermined,2,-1)
,___DEF_LBL_RET(___H__23__23_force_2d_undetermined,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H__23__23_force_2d_undetermined,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_force_2d_undetermined,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H__23__23_force_2d_undetermined,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_jobs,"##make-jobs",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_jobs,0,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_jobs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_add_2d_job_2d_at_2d_tail_21_,"##add-job-at-tail!",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_add_2d_job_2d_at_2d_tail_21_,2,-1)
,___DEF_LBL_RET(___H__23__23_add_2d_job_2d_at_2d_tail_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_add_2d_job_21_,"##add-job!",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_add_2d_job_21_,2,-1)
,___DEF_LBL_RET(___H__23__23_add_2d_job_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_execute_2d_jobs_21_,"##execute-jobs!",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H__23__23_execute_2d_jobs_21_,1,-1)
,___DEF_LBL_RET(___H__23__23_execute_2d_jobs_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_execute_2d_jobs_21_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_execute_2d_jobs_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_execute_2d_jobs_21_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_INTRO(___H__23__23_execute_2d_and_2d_clear_2d_jobs_21_,"##execute-and-clear-jobs!",___REF_FAL,5,
0)
,___DEF_LBL_PROC(___H__23__23_execute_2d_and_2d_clear_2d_jobs_21_,1,-1)
,___DEF_LBL_RET(___H__23__23_execute_2d_and_2d_clear_2d_jobs_21_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H__23__23_execute_2d_and_2d_clear_2d_jobs_21_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_execute_2d_and_2d_clear_2d_jobs_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_execute_2d_and_2d_clear_2d_jobs_21_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_INTRO(___H__23__23_clear_2d_jobs_21_,"##clear-jobs!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_clear_2d_jobs_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_check_2d_heap_2d_limit,"##check-heap-limit",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_check_2d_heap_2d_limit,0,-1)
,___DEF_LBL_INTRO(___H__23__23_check_2d_heap,"##check-heap",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_check_2d_heap,0,-1)
,___DEF_LBL_RET(___H__23__23_check_2d_heap,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H__23__23_rest_2d_param_2d_check_2d_heap,"##rest-param-check-heap",___REF_FAL,3,0)

,___DEF_LBL_PROC(___H__23__23_rest_2d_param_2d_check_2d_heap,2,-1)
,___DEF_LBL_RET(___H__23__23_rest_2d_param_2d_check_2d_heap,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H__23__23_rest_2d_param_2d_check_2d_heap,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_rest_2d_param_2d_heap_2d_overflow,"##rest-param-heap-overflow",___REF_FAL,4,
0)
,___DEF_LBL_PROC(___H__23__23_rest_2d_param_2d_heap_2d_overflow,2,-1)
,___DEF_LBL_RET(___H__23__23_rest_2d_param_2d_heap_2d_overflow,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H__23__23_rest_2d_param_2d_heap_2d_overflow,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H__23__23_rest_2d_param_2d_heap_2d_overflow,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H__23__23_rest_2d_param_2d_resume_2d_procedure,"##rest-param-resume-procedure",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H__23__23_rest_2d_param_2d_resume_2d_procedure,2,-1)
,___DEF_LBL_INTRO(___H__23__23_gc_2d_without_2d_exceptions,"##gc-without-exceptions",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H__23__23_gc_2d_without_2d_exceptions,0,-1)
,___DEF_LBL_INTRO(___H__23__23_gc,"##gc",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__23__23_gc,0,-1)
,___DEF_LBL_RET(___H__23__23_gc,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_gc,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_gc,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H__23__23_add_2d_gc_2d_interrupt_2d_job_21_,"##add-gc-interrupt-job!",___REF_FAL,2,0)

,___DEF_LBL_PROC(___H__23__23_add_2d_gc_2d_interrupt_2d_job_21_,1,-1)
,___DEF_LBL_RET(___H__23__23_add_2d_gc_2d_interrupt_2d_job_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_,"##clear-gc-interrupt-jobs!",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_,0,-1)
,___DEF_LBL_RET(___H__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_gc_2d_finalize_21_,"##gc-finalize!",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_gc_2d_finalize_21_,0,-1)
,___DEF_LBL_RET(___H__23__23_gc_2d_finalize_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_gc_2d_finalize_21_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H__23__23_execute_2d_final_2d_wills_21_,"##execute-final-wills!",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_execute_2d_final_2d_wills_21_,0,-1)
,___DEF_LBL_RET(___H__23__23_execute_2d_final_2d_wills_21_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_execute_2d_final_2d_wills_21_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_INTRO(___H__23__23_gc_2d_final_2d_will_2d_registry_21_,"##gc-final-will-registry!",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_gc_2d_final_2d_will_2d_registry_21_,0,-1)
,___DEF_LBL_INTRO(___H__23__23_make_2d_final_2d_will,"##make-final-will",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_final_2d_will,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_final_2d_will,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_handle_2d_gc_2d_interrupt_21_,"##handle-gc-interrupt!",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_handle_2d_gc_2d_interrupt_21_,0,-1)
,___DEF_LBL_RET(___H__23__23_handle_2d_gc_2d_interrupt_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H__23__23_get_2d_min_2d_heap,"##get-min-heap",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_get_2d_min_2d_heap,0,-1)
,___DEF_LBL_INTRO(___H__23__23_set_2d_min_2d_heap_21_,"##set-min-heap!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_set_2d_min_2d_heap_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_get_2d_max_2d_heap,"##get-max-heap",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_get_2d_max_2d_heap,0,-1)
,___DEF_LBL_INTRO(___H__23__23_set_2d_max_2d_heap_21_,"##set-max-heap!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_set_2d_max_2d_heap_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_get_2d_live_2d_percent,"##get-live-percent",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_get_2d_live_2d_percent,0,-1)
,___DEF_LBL_INTRO(___H__23__23_set_2d_live_2d_percent_21_,"##set-live-percent!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_set_2d_live_2d_percent_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_get_2d_parallelism_2d_level,"##get-parallelism-level",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H__23__23_get_2d_parallelism_2d_level,0,-1)
,___DEF_LBL_INTRO(___H__23__23_set_2d_parallelism_2d_level_21_,"##set-parallelism-level!",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H__23__23_set_2d_parallelism_2d_level_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_get_2d_standard_2d_level,"##get-standard-level",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_get_2d_standard_2d_level,0,-1)
,___DEF_LBL_INTRO(___H__23__23_set_2d_standard_2d_level_21_,"##set-standard-level!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_set_2d_standard_2d_level_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_set_2d_gambitdir_21_,"##set-gambitdir!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_set_2d_gambitdir_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_set_2d_debug_2d_settings_21_,"##set-debug-settings!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_set_2d_debug_2d_settings_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_cpu_2d_count,"##cpu-count",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_cpu_2d_count,0,-1)
,___DEF_LBL_INTRO(___H__23__23_cpu_2d_cache_2d_size,"##cpu-cache-size",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_cpu_2d_cache_2d_size,2,-1)
,___DEF_LBL_INTRO(___H__23__23_core_2d_count,"##core-count",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_core_2d_count,0,-1)
,___DEF_LBL_INTRO(___H__23__23_still_2d_copy,"##still-copy",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_still_2d_copy,1,-1)
,___DEF_LBL_RET(___H__23__23_still_2d_copy,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H__23__23_still_2d_obj_2d_refcount_2d_inc_21_,"##still-obj-refcount-inc!",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_still_2d_obj_2d_refcount_2d_inc_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_still_2d_obj_2d_refcount_2d_dec_21_,"##still-obj-refcount-dec!",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_still_2d_obj_2d_refcount_2d_dec_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_make_2d_vector,"##make-vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_vector,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_vector,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_string,"##make-string",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_string,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_string,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_s8vector,"##make-s8vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_s8vector,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_s8vector,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_u8vector,"##make-u8vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_u8vector,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_u8vector,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_s16vector,"##make-s16vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_s16vector,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_s16vector,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_u16vector,"##make-u16vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_u16vector,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_u16vector,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_s32vector,"##make-s32vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_s32vector,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_s32vector,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_u32vector,"##make-u32vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_u32vector,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_u32vector,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_s64vector,"##make-s64vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_s64vector,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_s64vector,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_u64vector,"##make-u64vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_u64vector,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_u64vector,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_f32vector,"##make-f32vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_f32vector,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_f32vector,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_f64vector,"##make-f64vector",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_f64vector,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_f64vector,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_machine_2d_code_2d_block,"##make-machine-code-block",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H__23__23_make_2d_machine_2d_code_2d_block,1,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_machine_2d_code_2d_block,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_machine_2d_code_2d_block_2d_ref,"##machine-code-block-ref",___REF_FAL,2,0)

,___DEF_LBL_PROC(___H__23__23_machine_2d_code_2d_block_2d_ref,2,-1)
,___DEF_LBL_RET(___H__23__23_machine_2d_code_2d_block_2d_ref,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_machine_2d_code_2d_block_2d_set_21_,"##machine-code-block-set!",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H__23__23_machine_2d_code_2d_block_2d_set_21_,3,-1)
,___DEF_LBL_RET(___H__23__23_machine_2d_code_2d_block_2d_set_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_machine_2d_code_2d_block_2d_exec,"##machine-code-block-exec",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H__23__23_machine_2d_code_2d_block_2d_exec,4,-1)
,___DEF_LBL_RET(___H__23__23_machine_2d_code_2d_block_2d_exec,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H__23__23_machine_2d_code_2d_block_2d_fixup,"##machine-code-block-fixup",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H__23__23_machine_2d_code_2d_block_2d_fixup,3,-1)
,___DEF_LBL_RET(___H__23__23_machine_2d_code_2d_block_2d_fixup,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_machine_2d_code_2d_fixup,"##machine-code-fixup",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__23__23_machine_2d_code_2d_fixup,3,-1)
,___DEF_LBL_RET(___H__23__23_machine_2d_code_2d_fixup,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H__23__23_machine_2d_code_2d_fixup,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H__23__23_machine_2d_code_2d_fixup,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H__23__23_apply,"##apply",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_apply,2,-1)
,___DEF_LBL_RET(___H__23__23_apply,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_make_2d_values,"##make-values",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_values,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_values,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H__23__23_values_2d_length,"##values-length",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_values_2d_length,1,-1)
,___DEF_LBL_INTRO(___H__23__23_values_2d_ref,"##values-ref",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_values_2d_ref,2,-1)
,___DEF_LBL_INTRO(___H__23__23_values_2d_set_21_,"##values-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_values_2d_set_21_,3,-1)
,___DEF_LBL_INTRO(___H__23__23_closure_3f_,"##closure?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_closure_3f_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_make_2d_closure,"##make-closure",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_closure,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_closure,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H__23__23_closure_2d_length,"##closure-length",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_closure_2d_length,1,-1)
,___DEF_LBL_INTRO(___H__23__23_closure_2d_code,"##closure-code",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_closure_2d_code,1,-1)
,___DEF_LBL_INTRO(___H__23__23_closure_2d_ref,"##closure-ref",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_closure_2d_ref,2,-1)
,___DEF_LBL_INTRO(___H__23__23_closure_2d_set_21_,"##closure-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_closure_2d_set_21_,3,-1)
,___DEF_LBL_INTRO(___H__23__23_subprocedure_3f_,"##subprocedure?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_subprocedure_3f_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_subprocedure_2d_id,"##subprocedure-id",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_subprocedure_2d_id,1,-1)
,___DEF_LBL_INTRO(___H__23__23_subprocedure_2d_parent,"##subprocedure-parent",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_subprocedure_2d_parent,1,-1)
,___DEF_LBL_INTRO(___H__23__23_subprocedure_2d_nb_2d_parameters,"##subprocedure-nb-parameters",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H__23__23_subprocedure_2d_nb_2d_parameters,1,-1)
,___DEF_LBL_INTRO(___H__23__23_subprocedure_2d_nb_2d_closed,"##subprocedure-nb-closed",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H__23__23_subprocedure_2d_nb_2d_closed,1,-1)
,___DEF_LBL_INTRO(___H__23__23_make_2d_subprocedure,"##make-subprocedure",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_subprocedure,2,-1)
,___DEF_LBL_INTRO(___H__23__23_subprocedure_2d_parent_2d_info,"##subprocedure-parent-info",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_subprocedure_2d_parent_2d_info,1,-1)
,___DEF_LBL_INTRO(___H__23__23_subprocedure_2d_parent_2d_name,"##subprocedure-parent-name",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_subprocedure_2d_parent_2d_name,1,-1)
,___DEF_LBL_INTRO(___H__23__23_explode_2d_continuation,"##explode-continuation",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_explode_2d_continuation,1,-1)
,___DEF_LBL_RET(___H__23__23_explode_2d_continuation,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_explode_2d_continuation,___IFD(___RETI,1,0,0x3f1L))
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_frame,"##continuation-frame",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_frame,1,-1)
,___DEF_LBL_RET(___H__23__23_continuation_2d_frame,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H__23__23_continuation_2d_frame,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_continuation_2d_frame,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_frame_2d_set_21_,"##continuation-frame-set!",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_frame_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_denv,"##continuation-denv",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_denv,1,-1)
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_denv_2d_set_21_,"##continuation-denv-set!",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H__23__23_continuation_2d_denv_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_explode_2d_frame,"##explode-frame",___REF_FAL,8,0)
,___DEF_LBL_PROC(___H__23__23_explode_2d_frame,1,-1)
,___DEF_LBL_RET(___H__23__23_explode_2d_frame,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_explode_2d_frame,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H__23__23_explode_2d_frame,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H__23__23_explode_2d_frame,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_explode_2d_frame,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H__23__23_explode_2d_frame,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_explode_2d_frame,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_INTRO(___H__23__23_frame_2d_ret,"##frame-ret",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_frame_2d_ret,1,-1)
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_ret,"##continuation-ret",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_ret,1,-1)
,___DEF_LBL_INTRO(___H__23__23_return_2d_fs,"##return-fs",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_return_2d_fs,1,-1)
,___DEF_LBL_INTRO(___H__23__23_frame_2d_fs,"##frame-fs",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_frame_2d_fs,1,-1)
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_fs,"##continuation-fs",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_fs,1,-1)
,___DEF_LBL_INTRO(___H__23__23_frame_2d_link,"##frame-link",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_frame_2d_link,1,-1)
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_link,"##continuation-link",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_link,1,-1)
,___DEF_LBL_INTRO(___H__23__23_frame_2d_slot_2d_live_3f_,"##frame-slot-live?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_frame_2d_slot_2d_live_3f_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_slot_2d_live_3f_,"##continuation-slot-live?",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_slot_2d_live_3f_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_frame_2d_ref,"##frame-ref",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_frame_2d_ref,2,-1)
,___DEF_LBL_INTRO(___H__23__23_frame_2d_set_21_,"##frame-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_frame_2d_set_21_,3,-1)
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_ref,"##continuation-ref",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_ref,2,-1)
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_set_21_,"##continuation-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_set_21_,3,-1)
,___DEF_LBL_INTRO(___H__23__23_make_2d_frame,"##make-frame",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_frame,1,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_frame,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_make_2d_frame,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H__23__23_make_2d_continuation,"##make-continuation",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_continuation,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_continuation,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_copy,"##continuation-copy",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_copy,1,-1)
,___DEF_LBL_RET(___H__23__23_continuation_2d_copy,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_next_21_,"##continuation-next!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_next_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_next,"##continuation-next",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_next,1,-1)
,___DEF_LBL_RET(___H__23__23_continuation_2d_next,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H__23__23_continuation_2d_last,"##continuation-last",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__23__23_continuation_2d_last,1,-1)
,___DEF_LBL_RET(___H__23__23_continuation_2d_last,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_continuation_2d_last,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_continuation_2d_last,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_symbol_2d_table,"##symbol-table",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_symbol_2d_table,0,-1)
,___DEF_LBL_INTRO(___H__23__23_keyword_2d_table,"##keyword-table",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_keyword_2d_table,0,-1)
,___DEF_LBL_INTRO(___H__23__23_make_2d_interned_2d_symbol,"##make-interned-symbol",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_interned_2d_symbol,1,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_interned_2d_symbol,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_make_2d_interned_2d_keyword,"##make-interned-keyword",___REF_FAL,2,0)

,___DEF_LBL_PROC(___H__23__23_make_2d_interned_2d_keyword,1,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_interned_2d_keyword,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_make_2d_interned_2d_symkey,"##make-interned-symkey",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_interned_2d_symkey,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_interned_2d_symkey,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H__23__23_make_2d_interned_2d_symkey,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_make_2d_interned_2d_symkey,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H__23__23_make_2d_interned_2d_symkey,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H__23__23_make_2d_interned_2d_symkey,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H__23__23_find_2d_interned_2d_symbol,"##find-interned-symbol",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_find_2d_interned_2d_symbol,1,-1)
,___DEF_LBL_RET(___H__23__23_find_2d_interned_2d_symbol,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_find_2d_interned_2d_keyword,"##find-interned-keyword",___REF_FAL,2,0)

,___DEF_LBL_PROC(___H__23__23_find_2d_interned_2d_keyword,1,-1)
,___DEF_LBL_RET(___H__23__23_find_2d_interned_2d_keyword,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_find_2d_interned_2d_symkey,"##find-interned-symkey",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_find_2d_interned_2d_symkey,2,-1)
,___DEF_LBL_RET(___H__23__23_find_2d_interned_2d_symkey,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_make_2d_global_2d_var,"##make-global-var",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_global_2d_var,1,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_global_2d_var,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H__23__23_global_2d_var_3f_,"##global-var?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_global_2d_var_3f_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_global_2d_var_2d_ref,"##global-var-ref",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_global_2d_var_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H__23__23_global_2d_var_2d_primitive_2d_ref,"##global-var-primitive-ref",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_global_2d_var_2d_primitive_2d_ref,1,-1)
,___DEF_LBL_INTRO(___H__23__23_global_2d_var_2d_set_21_,"##global-var-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_global_2d_var_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_global_2d_var_2d_primitive_2d_set_21_,"##global-var-primitive-set!",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H__23__23_global_2d_var_2d_primitive_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_object_2d__3e_global_2d_var_2d__3e_identifier,"##object->global-var->identifier",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__23__23_object_2d__3e_global_2d_var_2d__3e_identifier,1,-1)
,___DEF_LBL_RET(___H__23__23_object_2d__3e_global_2d_var_2d__3e_identifier,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__23__23_object_2d__3e_global_2d_var_2d__3e_identifier,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_object_2d__3e_global_2d_var_2d__3e_identifier,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H__23__23_object_2d__3e_global_2d_var,"##object->global-var",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_object_2d__3e_global_2d_var,2,-1)
,___DEF_LBL_INTRO(___H__23__23_global_2d_var_2d__3e_identifier,"##global-var->identifier",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H__23__23_global_2d_var_2d__3e_identifier,1,-1)
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_foreign,"##fail-check-foreign",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_foreign,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_foreign,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_foreign_3f_,"foreign?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_foreign_3f_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_foreign_2d_tags,"##foreign-tags",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_foreign_2d_tags,1,-1)
,___DEF_LBL_INTRO(___H_foreign_2d_tags,"foreign-tags",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_foreign_2d_tags,1,-1)
,___DEF_LBL_RET(___H_foreign_2d_tags,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_foreign_2d_released_3f_,"##foreign-released?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_foreign_2d_released_3f_,1,-1)
,___DEF_LBL_INTRO(___H_foreign_2d_released_3f_,"foreign-released?",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_foreign_2d_released_3f_,1,-1)
,___DEF_LBL_RET(___H_foreign_2d_released_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_foreign_2d_released_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_foreign_2d_release_21_,"##foreign-release!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_foreign_2d_release_21_,1,-1)
,___DEF_LBL_INTRO(___H_foreign_2d_release_21_,"foreign-release!",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_foreign_2d_release_21_,1,-1)
,___DEF_LBL_RET(___H_foreign_2d_release_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_foreign_2d_release_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_foreign_2d_address,"##foreign-address",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_foreign_2d_address,1,-1)
,___DEF_LBL_RET(___H__23__23_foreign_2d_address,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_foreign_2d_address,"foreign-address",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H_foreign_2d_address,1,-1)
,___DEF_LBL_RET(___H_foreign_2d_address,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_foreign_2d_address,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_process_2d_statistics,"##process-statistics",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_process_2d_statistics,0,-1)
,___DEF_LBL_RET(___H__23__23_process_2d_statistics,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H__23__23_process_2d_times,"##process-times",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_process_2d_times,0,-1)
,___DEF_LBL_RET(___H__23__23_process_2d_times,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_get_2d_current_2d_time_21_,"##get-current-time!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_get_2d_current_2d_time_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_get_2d_monotonic_2d_time_21_,"##get-monotonic-time!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_get_2d_monotonic_2d_time_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_get_2d_monotonic_2d_time_2d_frequency_21_,"##get-monotonic-time-frequency!",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_get_2d_monotonic_2d_time_2d_frequency_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_get_2d_bytes_2d_allocated_21_,"##get-bytes-allocated!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_get_2d_bytes_2d_allocated_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_actlog_2d_start,"##actlog-start",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_actlog_2d_start,0,-1)
,___DEF_LBL_RET(___H__23__23_actlog_2d_start,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_actlog_2d_stop,"##actlog-stop",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_actlog_2d_stop,0,-1)
,___DEF_LBL_RET(___H__23__23_actlog_2d_stop,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_actlog_2d_dump,"##actlog-dump",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_actlog_2d_dump,1,-1)
,___DEF_LBL_RET(___H__23__23_actlog_2d_dump,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_err_2d_code_2d__3e_string,"err-code->string",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_err_2d_code_2d__3e_string,1,-1)
,___DEF_LBL_RET(___H_err_2d_code_2d__3e_string,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_command_2d_line,"##command-line",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_command_2d_line,0,-1)
,___DEF_LBL_INTRO(___H__23__23_processed_2d_command_2d_line_2d_set_21_,"##processed-command-line-set!",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H__23__23_processed_2d_command_2d_line_2d_set_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_os_2d_condvar_2d_select_21_,"##os-condvar-select!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_os_2d_condvar_2d_select_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_device_2d_select_2d_abort_21_,"##device-select-abort!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_device_2d_select_2d_abort_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_add_2d_exit_2d_job_21_,"##add-exit-job!",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_add_2d_exit_2d_job_21_,1,-1)
,___DEF_LBL_RET(___H__23__23_add_2d_exit_2d_job_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_clear_2d_exit_2d_jobs_21_,"##clear-exit-jobs!",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_clear_2d_exit_2d_jobs_21_,0,-1)
,___DEF_LBL_RET(___H__23__23_clear_2d_exit_2d_jobs_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup,"##exit-with-err-code-no-cleanup",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup,1,-1)
,___DEF_LBL_INTRO(___H__23__23_exit_2d_cleanup,"##exit-cleanup",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__23__23_exit_2d_cleanup,0,-1)
,___DEF_LBL_RET(___H__23__23_exit_2d_cleanup,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__23__23_exit_2d_cleanup,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_exit_2d_cleanup,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H__23__23_exit_2d_with_2d_err_2d_code,"##exit-with-err-code",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__23__23_exit_2d_with_2d_err_2d_code,1,-1)
,___DEF_LBL_RET(___H__23__23_exit_2d_with_2d_err_2d_code,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H__23__23_exit_2d_with_2d_err_2d_code,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_exit_2d_with_2d_err_2d_code,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_INTRO(___H__23__23_exit,"##exit",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_exit,1,-1)
,___DEF_LBL_RET(___H__23__23_exit,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_exit_2d_abnormally,"##exit-abnormally",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_exit_2d_abnormally,0,-1)
,___DEF_LBL_RET(___H__23__23_exit_2d_abnormally,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_exit_2d_with_2d_exception,"##exit-with-exception",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_exit_2d_with_2d_exception,1,-1)
,___DEF_LBL_RET(___H__23__23_exit_2d_with_2d_exception,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_first_2d_argument,"##first-argument",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_first_2d_argument,4,-1)
,___DEF_LBL_INTRO(___H__23__23_with_2d_no_2d_result_2d_expected,"##with-no-result-expected",___REF_FAL,2,
0)
,___DEF_LBL_PROC(___H__23__23_with_2d_no_2d_result_2d_expected,1,-1)
,___DEF_LBL_RET(___H__23__23_with_2d_no_2d_result_2d_expected,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel,"##with-no-result-expected-toplevel",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel,1,-1)
,___DEF_LBL_RET(___H__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H__23__23_system_2d_version,"##system-version",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_system_2d_version,0,-1)
,___DEF_LBL_INTRO(___H_system_2d_version,"system-version",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_system_2d_version,0,-1)
,___DEF_LBL_RET(___H_system_2d_version,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_system_2d_version_2d_string,"##system-version-string",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H__23__23_system_2d_version_2d_string,0,-1)
,___DEF_LBL_INTRO(___H_system_2d_version_2d_string,"system-version-string",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_system_2d_version_2d_string,0,-1)
,___DEF_LBL_RET(___H_system_2d_version_2d_string,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_system_2d_type,"system-type",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_system_2d_type,0,-1)
,___DEF_LBL_INTRO(___H_system_2d_type_2d_string,"system-type-string",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H_system_2d_type_2d_string,0,-1)
,___DEF_LBL_INTRO(___H_configure_2d_command_2d_string,"configure-command-string",___REF_FAL,1,0)

,___DEF_LBL_PROC(___H_configure_2d_command_2d_string,0,-1)
,___DEF_LBL_INTRO(___H__23__23_system_2d_stamp,"##system-stamp",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_system_2d_stamp,0,-1)
,___DEF_LBL_INTRO(___H_system_2d_stamp,"system-stamp",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_system_2d_stamp,0,-1)
,___DEF_LBL_RET(___H_system_2d_stamp,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_type_2d_id,"##type-id",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_type_2d_id,1,-1)
,___DEF_LBL_INTRO(___H__23__23_type_2d_name,"##type-name",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_type_2d_name,1,-1)
,___DEF_LBL_INTRO(___H__23__23_type_2d_flags,"##type-flags",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_type_2d_flags,1,-1)
,___DEF_LBL_INTRO(___H__23__23_type_2d_super,"##type-super",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_type_2d_super,1,-1)
,___DEF_LBL_INTRO(___H__23__23_type_2d_fields,"##type-fields",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_type_2d_fields,1,-1)
,___DEF_LBL_INTRO(___H__23__23_structure_2d_direct_2d_instance_2d_of_3f_,"##structure-direct-instance-of?",
___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_structure_2d_direct_2d_instance_2d_of_3f_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_structure_2d_instance_2d_of_3f_,"##structure-instance-of?",___REF_FAL,3,0)

,___DEF_LBL_PROC(___H__23__23_structure_2d_instance_2d_of_3f_,2,-1)
,___DEF_LBL_RET(___H__23__23_structure_2d_instance_2d_of_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_structure_2d_instance_2d_of_3f_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_type_3f_,"##type?",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_type_3f_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_structure_2d_type,"##structure-type",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_structure_2d_type,1,-1)
,___DEF_LBL_INTRO(___H__23__23_structure_2d_type_2d_set_21_,"##structure-type-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_structure_2d_type_2d_set_21_,2,-1)
,___DEF_LBL_INTRO(___H__23__23_make_2d_structure,"##make-structure",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_make_2d_structure,2,-1)
,___DEF_LBL_RET(___H__23__23_make_2d_structure,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_INTRO(___H__23__23_structure_2d_length,"##structure-length",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_structure_2d_length,1,-1)
,___DEF_LBL_INTRO(___H__23__23_structure,"##structure",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H__23__23_structure,2,-1)
,___DEF_LBL_RET(___H__23__23_structure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_structure,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H__23__23_structure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_structure,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H__23__23_structure,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H__23__23_structure_2d_ref,"##structure-ref",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H__23__23_structure_2d_ref,4,-1)
,___DEF_LBL_RET(___H__23__23_structure_2d_ref,___IFD(___RETN,5,1,0x1fL))
,___DEF_LBL_RET(___H__23__23_structure_2d_ref,___IFD(___RETI,8,1,0x3f4bL))
,___DEF_LBL_RET(___H__23__23_structure_2d_ref,___IFD(___RETI,8,8,0x3f41L))
,___DEF_LBL_RET(___H__23__23_structure_2d_ref,___IFD(___RETI,8,1,0x3f4bL))
,___DEF_LBL_INTRO(___H__23__23_structure_2d_set_21_,"##structure-set!",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H__23__23_structure_2d_set_21_,5,-1)
,___DEF_LBL_RET(___H__23__23_structure_2d_set_21_,___IFD(___RETN,9,2,0x3fL))
,___DEF_LBL_RET(___H__23__23_structure_2d_set_21_,___OFD(___RETI,12,2,0x3f095L))
,___DEF_LBL_RET(___H__23__23_structure_2d_set_21_,___OFD(___RETI,12,12,0x3f081L))
,___DEF_LBL_RET(___H__23__23_structure_2d_set_21_,___OFD(___RETI,12,2,0x3f095L))
,___DEF_LBL_INTRO(___H__23__23_structure_2d_cas_21_,"##structure-cas!",___REF_FAL,5,0)
,___DEF_LBL_PROC(___H__23__23_structure_2d_cas_21_,6,-1)
,___DEF_LBL_RET(___H__23__23_structure_2d_cas_21_,___IFD(___RETN,9,3,0x7fL))
,___DEF_LBL_RET(___H__23__23_structure_2d_cas_21_,___OFD(___RETI,12,3,0x3f129L))
,___DEF_LBL_RET(___H__23__23_structure_2d_cas_21_,___OFD(___RETI,12,12,0x3f101L))
,___DEF_LBL_RET(___H__23__23_structure_2d_cas_21_,___OFD(___RETI,12,3,0x3f129L))
,___DEF_LBL_INTRO(___H__23__23_direct_2d_structure_2d_ref,"##direct-structure-ref",___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__23__23_direct_2d_structure_2d_ref,4,-1)
,___DEF_LBL_RET(___H__23__23_direct_2d_structure_2d_ref,___IFD(___RETI,4,4,0x3f9L))
,___DEF_LBL_RET(___H__23__23_direct_2d_structure_2d_ref,___IFD(___RETI,4,4,0x3f9L))
,___DEF_LBL_RET(___H__23__23_direct_2d_structure_2d_ref,___IFD(___RETI,4,4,0x3f9L))
,___DEF_LBL_INTRO(___H__23__23_direct_2d_structure_2d_set_21_,"##direct-structure-set!",___REF_FAL,4,0)

,___DEF_LBL_PROC(___H__23__23_direct_2d_structure_2d_set_21_,5,-1)
,___DEF_LBL_RET(___H__23__23_direct_2d_structure_2d_set_21_,___IFD(___RETI,5,8,0x3f11L))
,___DEF_LBL_RET(___H__23__23_direct_2d_structure_2d_set_21_,___IFD(___RETI,5,8,0x3f11L))
,___DEF_LBL_RET(___H__23__23_direct_2d_structure_2d_set_21_,___IFD(___RETI,5,8,0x3f11L))
,___DEF_LBL_INTRO(___H__23__23_direct_2d_structure_2d_cas_21_,"##direct-structure-cas!",___REF_FAL,4,0)

,___DEF_LBL_PROC(___H__23__23_direct_2d_structure_2d_cas_21_,6,-1)
,___DEF_LBL_RET(___H__23__23_direct_2d_structure_2d_cas_21_,___IFD(___RETI,6,8,0x3f21L))
,___DEF_LBL_RET(___H__23__23_direct_2d_structure_2d_cas_21_,___IFD(___RETI,6,8,0x3f21L))
,___DEF_LBL_RET(___H__23__23_direct_2d_structure_2d_cas_21_,___IFD(___RETI,6,8,0x3f21L))
,___DEF_LBL_INTRO(___H__23__23_unchecked_2d_structure_2d_ref,"##unchecked-structure-ref",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_unchecked_2d_structure_2d_ref,4,-1)
,___DEF_LBL_INTRO(___H__23__23_unchecked_2d_structure_2d_set_21_,"##unchecked-structure-set!",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_unchecked_2d_structure_2d_set_21_,5,-1)
,___DEF_LBL_INTRO(___H__23__23_unchecked_2d_structure_2d_cas_21_,"##unchecked-structure-cas!",___REF_FAL,1,
0)
,___DEF_LBL_PROC(___H__23__23_unchecked_2d_structure_2d_cas_21_,6,-1)
,___DEF_LBL_INTRO(___H__23__23_main_2d_set_21_,"##main-set!",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_main_2d_set_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_module_2d_init,"##module-init",___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_module_2d_init,1,-1)
,___DEF_LBL_INTRO(___H__23__23_create_2d_module,"##create-module",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_create_2d_module,2,-1)
,___DEF_LBL_RET(___H__23__23_create_2d_module,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_register_2d_module_2d_descr_21_,"##register-module-descr!",___REF_FAL,6,0)

,___DEF_LBL_PROC(___H__23__23_register_2d_module_2d_descr_21_,2,-1)
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descr_21_,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descr_21_,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descr_21_,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descr_21_,___IFD(___RETI,8,0,0x3f05L))
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descr_21_,___IFD(___RETI,8,0,0x3f01L))
,___DEF_LBL_INTRO(___H__23__23_register_2d_module_2d_descrs_21_,"##register-module-descrs!",___REF_FAL,6,
0)
,___DEF_LBL_PROC(___H__23__23_register_2d_module_2d_descrs_21_,1,-1)
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descrs_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descrs_21_,___IFD(___RETN,5,1,0x1eL))
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descrs_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descrs_21_,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descrs_21_,___IFD(___RETI,8,1,0x3f1eL))
,___DEF_LBL_INTRO(___H__23__23_lookup_2d_registered_2d_module,"##lookup-registered-module",___REF_FAL,5,
0)
,___DEF_LBL_PROC(___H__23__23_lookup_2d_registered_2d_module,1,-1)
,___DEF_LBL_RET(___H__23__23_lookup_2d_registered_2d_module,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__23__23_lookup_2d_registered_2d_module,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_lookup_2d_registered_2d_module,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__23__23_lookup_2d_registered_2d_module,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H__23__23_lookup_2d_module,"##lookup-module",___REF_FAL,3,0)
,___DEF_LBL_PROC(___H__23__23_lookup_2d_module,2,-1)
,___DEF_LBL_RET(___H__23__23_lookup_2d_module,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_lookup_2d_module,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_load_2d_required_2d_module_2d_structs,"##load-required-module-structs",
___REF_FAL,14,0)
,___DEF_LBL_PROC(___H__23__23_load_2d_required_2d_module_2d_structs,2,-1)
,___DEF_LBL_RET(___H__23__23_load_2d_required_2d_module_2d_structs,___IFD(___RETI,8,0,0x3f07L))
,___DEF_LBL_RET(___H__23__23_load_2d_required_2d_module_2d_structs,___IFD(___RETN,5,0,0x7L))
,___DEF_LBL_RET(___H__23__23_load_2d_required_2d_module_2d_structs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_load_2d_required_2d_module_2d_structs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_load_2d_required_2d_module_2d_structs,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_RET(___H__23__23_load_2d_required_2d_module_2d_structs,___IFD(___RETI,8,0,0x3f0fL))
,___DEF_LBL_RET(___H__23__23_load_2d_required_2d_module_2d_structs,___IFD(___RETN,5,0,0xfL))
,___DEF_LBL_RET(___H__23__23_load_2d_required_2d_module_2d_structs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_load_2d_required_2d_module_2d_structs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H__23__23_load_2d_required_2d_module_2d_structs,1,-1)
,___DEF_LBL_RET(___H__23__23_load_2d_required_2d_module_2d_structs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_PROC(___H__23__23_load_2d_required_2d_module_2d_structs,1,-1)
,___DEF_LBL_RET(___H__23__23_load_2d_required_2d_module_2d_structs,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_default_2d_load_2d_required_2d_module,"##default-load-required-module",
___REF_FAL,8,0)
,___DEF_LBL_PROC(___H__23__23_default_2d_load_2d_required_2d_module,1,-1)
,___DEF_LBL_RET(___H__23__23_default_2d_load_2d_required_2d_module,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H__23__23_default_2d_load_2d_required_2d_module,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H__23__23_default_2d_load_2d_required_2d_module,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H__23__23_default_2d_load_2d_required_2d_module,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H__23__23_default_2d_load_2d_required_2d_module,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_default_2d_load_2d_required_2d_module,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H__23__23_default_2d_load_2d_required_2d_module,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_load_2d_required_2d_module_2d_set_21_,"##load-required-module-set!",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H__23__23_load_2d_required_2d_module_2d_set_21_,1,-1)
,___DEF_LBL_INTRO(___H__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception,"##fail-check-module-not-found-exception",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception,3,-1)
,___DEF_LBL_RET(___H__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception,___IFD(___RETI,1,4,0x3f1L))
,___DEF_LBL_INTRO(___H_module_2d_not_2d_found_2d_exception_3f_,"module-not-found-exception?",___REF_FAL,
1,0)
,___DEF_LBL_PROC(___H_module_2d_not_2d_found_2d_exception_3f_,1,-1)
,___DEF_LBL_INTRO(___H_module_2d_not_2d_found_2d_exception_2d_procedure,"module-not-found-exception-procedure",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_module_2d_not_2d_found_2d_exception_2d_procedure,1,-1)
,___DEF_LBL_RET(___H_module_2d_not_2d_found_2d_exception_2d_procedure,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H_module_2d_not_2d_found_2d_exception_2d_arguments,"module-not-found-exception-arguments",
___REF_FAL,2,0)
,___DEF_LBL_PROC(___H_module_2d_not_2d_found_2d_exception_2d_arguments,1,-1)
,___DEF_LBL_RET(___H_module_2d_not_2d_found_2d_exception_2d_arguments,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_INTRO(___H__23__23_raise_2d_module_2d_not_2d_found_2d_exception,"##raise-module-not-found-exception",
___REF_FAL,5,0)
,___DEF_LBL_PROC(___H__23__23_raise_2d_module_2d_not_2d_found_2d_exception,2,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_module_2d_not_2d_found_2d_exception,___IFD(___RETI,3,4,0x3f7L))
,___DEF_LBL_PROC(___H__23__23_raise_2d_module_2d_not_2d_found_2d_exception,5,-1)
,___DEF_LBL_RET(___H__23__23_raise_2d_module_2d_not_2d_found_2d_exception,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_RET(___H__23__23_raise_2d_module_2d_not_2d_found_2d_exception,___IFD(___RETI,2,4,0x3f0L))
,___DEF_LBL_INTRO(___H__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_,"##register-module-descrs-and-load!",
___REF_FAL,4,0)
,___DEF_LBL_PROC(___H__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_,1,-1)
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H__23__23_load_2d_vm,"##load-vm",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H__23__23_load_2d_vm,0,-1)
,___DEF_LBL_RET(___H__23__23_load_2d_vm,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__23__23_load_2d_vm,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_load_2d_vm,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_load_2d_vm,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__23__23_load_2d_vm,___IFD(___RETI,4,4,0x3f0L))
,___DEF_LBL_INTRO(___H___kernel_23_0,"_kernel#0",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_0,1,-1)
,___DEF_LBL_RET(___H___kernel_23_0,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_1,"_kernel#1",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_1,2,-1)
,___DEF_LBL_RET(___H___kernel_23_1,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_2,"_kernel#2",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_2,0,-1)
,___DEF_LBL_RET(___H___kernel_23_2,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_3,"_kernel#3",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_3,1,-1)
,___DEF_LBL_RET(___H___kernel_23_3,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_4,"_kernel#4",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_4,2,-1)
,___DEF_LBL_RET(___H___kernel_23_4,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_5,"_kernel#5",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_5,3,-1)
,___DEF_LBL_RET(___H___kernel_23_5,___IFD(___RETN,4,3,0xfL))
,___DEF_LBL_INTRO(___H___kernel_23_6,"_kernel#6",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_6,4,-1)
,___DEF_LBL_RET(___H___kernel_23_6,___IFD(___RETN,5,4,0x1fL))
,___DEF_LBL_INTRO(___H___kernel_23_7,"_kernel#7",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_7,3,-1)
,___DEF_LBL_RET(___H___kernel_23_7,___IFD(___RETN,4,3,0xfL))
,___DEF_LBL_INTRO(___H___kernel_23_8,"_kernel#8",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_8,2,-1)
,___DEF_LBL_RET(___H___kernel_23_8,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_9,"_kernel#9",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_9,2,-1)
,___DEF_LBL_RET(___H___kernel_23_9,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_10,"_kernel#10",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_10,1,-1)
,___DEF_LBL_RET(___H___kernel_23_10,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_11,"_kernel#11",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_11,0,-1)
,___DEF_LBL_RET(___H___kernel_23_11,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_12,"_kernel#12",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_12,0,-1)
,___DEF_LBL_RET(___H___kernel_23_12,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_13,"_kernel#13",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_13,0,-1)
,___DEF_LBL_RET(___H___kernel_23_13,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_14,"_kernel#14",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_14,0,-1)
,___DEF_LBL_RET(___H___kernel_23_14,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_15,"_kernel#15",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_15,0,-1)
,___DEF_LBL_RET(___H___kernel_23_15,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_16,"_kernel#16",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_16,1,-1)
,___DEF_LBL_RET(___H___kernel_23_16,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_17,"_kernel#17",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_17,3,-1)
,___DEF_LBL_RET(___H___kernel_23_17,___IFD(___RETN,4,3,0xfL))
,___DEF_LBL_INTRO(___H___kernel_23_18,"_kernel#18",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_18,1,-1)
,___DEF_LBL_RET(___H___kernel_23_18,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_19,"_kernel#19",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_19,0,-1)
,___DEF_LBL_RET(___H___kernel_23_19,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_20,"_kernel#20",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_20,0,-1)
,___DEF_LBL_RET(___H___kernel_23_20,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_21,"_kernel#21",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_21,1,-1)
,___DEF_LBL_RET(___H___kernel_23_21,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_22,"_kernel#22",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_22,1,-1)
,___DEF_LBL_RET(___H___kernel_23_22,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_23,"_kernel#23",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_23,0,-1)
,___DEF_LBL_RET(___H___kernel_23_23,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_24,"_kernel#24",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_24,0,-1)
,___DEF_LBL_RET(___H___kernel_23_24,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_25,"_kernel#25",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_25,1,-1)
,___DEF_LBL_RET(___H___kernel_23_25,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_26,"_kernel#26",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_26,2,-1)
,___DEF_LBL_RET(___H___kernel_23_26,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_27,"_kernel#27",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_27,0,-1)
,___DEF_LBL_RET(___H___kernel_23_27,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_28,"_kernel#28",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_28,1,-1)
,___DEF_LBL_RET(___H___kernel_23_28,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_29,"_kernel#29",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_29,1,-1)
,___DEF_LBL_RET(___H___kernel_23_29,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_30,"_kernel#30",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_30,2,-1)
,___DEF_LBL_RET(___H___kernel_23_30,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_31,"_kernel#31",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_31,2,-1)
,___DEF_LBL_RET(___H___kernel_23_31,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_32,"_kernel#32",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_32,3,-1)
,___DEF_LBL_RET(___H___kernel_23_32,___IFD(___RETN,4,3,0xfL))
,___DEF_LBL_INTRO(___H___kernel_23_33,"_kernel#33",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_33,4,-1)
,___DEF_LBL_RET(___H___kernel_23_33,___IFD(___RETN,5,4,0x1fL))
,___DEF_LBL_INTRO(___H___kernel_23_34,"_kernel#34",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_34,4,-1)
,___DEF_LBL_RET(___H___kernel_23_34,___IFD(___RETN,5,4,0x1fL))
,___DEF_LBL_INTRO(___H___kernel_23_35,"_kernel#35",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_35,1,-1)
,___DEF_LBL_RET(___H___kernel_23_35,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_36,"_kernel#36",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_36,1,-1)
,___DEF_LBL_RET(___H___kernel_23_36,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_37,"_kernel#37",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_37,2,-1)
,___DEF_LBL_RET(___H___kernel_23_37,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_38,"_kernel#38",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_38,2,-1)
,___DEF_LBL_RET(___H___kernel_23_38,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_39,"_kernel#39",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_39,3,-1)
,___DEF_LBL_RET(___H___kernel_23_39,___IFD(___RETN,4,3,0xfL))
,___DEF_LBL_INTRO(___H___kernel_23_40,"_kernel#40",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_40,4,-1)
,___DEF_LBL_RET(___H___kernel_23_40,___IFD(___RETN,5,4,0x1fL))
,___DEF_LBL_INTRO(___H___kernel_23_41,"_kernel#41",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_41,2,-1)
,___DEF_LBL_RET(___H___kernel_23_41,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_42,"_kernel#42",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_42,1,-1)
,___DEF_LBL_RET(___H___kernel_23_42,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_43,"_kernel#43",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_43,1,-1)
,___DEF_LBL_RET(___H___kernel_23_43,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_44,"_kernel#44",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_44,7,-1)
,___DEF_LBL_RET(___H___kernel_23_44,___IFD(___RETN,8,7,0xffL))
,___DEF_LBL_INTRO(___H___kernel_23_45,"_kernel#45",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_45,7,-1)
,___DEF_LBL_RET(___H___kernel_23_45,___IFD(___RETN,8,7,0xffL))
,___DEF_LBL_INTRO(___H___kernel_23_46,"_kernel#46",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_46,2,-1)
,___DEF_LBL_RET(___H___kernel_23_46,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_47,"_kernel#47",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_47,5,-1)
,___DEF_LBL_RET(___H___kernel_23_47,___IFD(___RETN,6,5,0x3fL))
,___DEF_LBL_INTRO(___H___kernel_23_48,"_kernel#48",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_48,1,-1)
,___DEF_LBL_RET(___H___kernel_23_48,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_49,"_kernel#49",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_49,1,-1)
,___DEF_LBL_RET(___H___kernel_23_49,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_50,"_kernel#50",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_50,3,-1)
,___DEF_LBL_RET(___H___kernel_23_50,___IFD(___RETN,4,3,0xfL))
,___DEF_LBL_INTRO(___H___kernel_23_51,"_kernel#51",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_51,4,-1)
,___DEF_LBL_RET(___H___kernel_23_51,___IFD(___RETN,5,4,0x1fL))
,___DEF_LBL_INTRO(___H___kernel_23_52,"_kernel#52",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_52,4,-1)
,___DEF_LBL_RET(___H___kernel_23_52,___IFD(___RETN,5,4,0x1fL))
,___DEF_LBL_INTRO(___H___kernel_23_53,"_kernel#53",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_53,3,-1)
,___DEF_LBL_RET(___H___kernel_23_53,___IFD(___RETN,4,3,0xfL))
,___DEF_LBL_INTRO(___H___kernel_23_54,"_kernel#54",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_54,2,-1)
,___DEF_LBL_RET(___H___kernel_23_54,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_55,"_kernel#55",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_55,2,-1)
,___DEF_LBL_RET(___H___kernel_23_55,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_56,"_kernel#56",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_56,1,-1)
,___DEF_LBL_RET(___H___kernel_23_56,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_57,"_kernel#57",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_57,1,-1)
,___DEF_LBL_RET(___H___kernel_23_57,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_58,"_kernel#58",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_58,1,-1)
,___DEF_LBL_RET(___H___kernel_23_58,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_59,"_kernel#59",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_59,3,-1)
,___DEF_LBL_RET(___H___kernel_23_59,___IFD(___RETN,4,3,0xfL))
,___DEF_LBL_INTRO(___H___kernel_23_60,"_kernel#60",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_60,3,-1)
,___DEF_LBL_RET(___H___kernel_23_60,___IFD(___RETN,4,3,0xfL))
,___DEF_LBL_INTRO(___H___kernel_23_61,"_kernel#61",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_61,1,-1)
,___DEF_LBL_RET(___H___kernel_23_61,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_62,"_kernel#62",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_62,2,-1)
,___DEF_LBL_RET(___H___kernel_23_62,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_63,"_kernel#63",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_63,2,-1)
,___DEF_LBL_RET(___H___kernel_23_63,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_64,"_kernel#64",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_64,2,-1)
,___DEF_LBL_RET(___H___kernel_23_64,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_65,"_kernel#65",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_65,6,-1)
,___DEF_LBL_RET(___H___kernel_23_65,___IFD(___RETN,7,6,0x7fL))
,___DEF_LBL_INTRO(___H___kernel_23_66,"_kernel#66",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_66,3,-1)
,___DEF_LBL_RET(___H___kernel_23_66,___IFD(___RETN,4,3,0xfL))
,___DEF_LBL_INTRO(___H___kernel_23_67,"_kernel#67",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_67,2,-1)
,___DEF_LBL_RET(___H___kernel_23_67,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_68,"_kernel#68",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_68,1,-1)
,___DEF_LBL_RET(___H___kernel_23_68,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_69,"_kernel#69",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_69,0,-1)
,___DEF_LBL_RET(___H___kernel_23_69,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_70,"_kernel#70",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_70,1,-1)
,___DEF_LBL_RET(___H___kernel_23_70,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_71,"_kernel#71",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_71,6,-1)
,___DEF_LBL_RET(___H___kernel_23_71,___IFD(___RETN,7,6,0x7fL))
,___DEF_LBL_INTRO(___H___kernel_23_72,"_kernel#72",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_72,1,-1)
,___DEF_LBL_RET(___H___kernel_23_72,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_73,"_kernel#73",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_73,0,-1)
,___DEF_LBL_RET(___H___kernel_23_73,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_74,"_kernel#74",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_74,2,-1)
,___DEF_LBL_RET(___H___kernel_23_74,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_75,"_kernel#75",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_75,1,-1)
,___DEF_LBL_RET(___H___kernel_23_75,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_76,"_kernel#76",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_76,1,-1)
,___DEF_LBL_RET(___H___kernel_23_76,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_77,"_kernel#77",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_77,0,-1)
,___DEF_LBL_RET(___H___kernel_23_77,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_78,"_kernel#78",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_78,0,-1)
,___DEF_LBL_RET(___H___kernel_23_78,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_79,"_kernel#79",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_79,2,-1)
,___DEF_LBL_RET(___H___kernel_23_79,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_80,"_kernel#80",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_80,2,-1)
,___DEF_LBL_RET(___H___kernel_23_80,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_81,"_kernel#81",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_81,2,-1)
,___DEF_LBL_RET(___H___kernel_23_81,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_82,"_kernel#82",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_82,2,-1)
,___DEF_LBL_RET(___H___kernel_23_82,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_83,"_kernel#83",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_83,1,-1)
,___DEF_LBL_RET(___H___kernel_23_83,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_84,"_kernel#84",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_84,1,-1)
,___DEF_LBL_RET(___H___kernel_23_84,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_85,"_kernel#85",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_85,2,-1)
,___DEF_LBL_RET(___H___kernel_23_85,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_86,"_kernel#86",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_86,2,-1)
,___DEF_LBL_RET(___H___kernel_23_86,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_87,"_kernel#87",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_87,1,-1)
,___DEF_LBL_RET(___H___kernel_23_87,___IFD(___RETN,2,1,0x3L))
,___DEF_LBL_INTRO(___H___kernel_23_88,"_kernel#88",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_88,2,-1)
,___DEF_LBL_RET(___H___kernel_23_88,___IFD(___RETN,3,2,0x7L))
,___DEF_LBL_INTRO(___H___kernel_23_89,"_kernel#89",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_89,0,-1)
,___DEF_LBL_RET(___H___kernel_23_89,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_90,"_kernel#90",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_90,0,-1)
,___DEF_LBL_RET(___H___kernel_23_90,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_91,"_kernel#91",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_91,0,-1)
,___DEF_LBL_RET(___H___kernel_23_91,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H___kernel_23_92,"_kernel#92",___REF_FAL,2,0)
,___DEF_LBL_PROC(___H___kernel_23_92,0,-1)
,___DEF_LBL_RET(___H___kernel_23_92,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_INTRO(___H__23__23_main,0,___REF_FAL,1,0)
,___DEF_LBL_PROC(___H__23__23_main,0,-1)
___END_LBL

___BEGIN_OFD
 ___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07dL)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f043L)
,___DEF_OFD(___RETI,12,4)
               ___GCMAP1(0x3f0f7L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f083L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f07dL)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f095L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f081L)
,___DEF_OFD(___RETI,12,2)
               ___GCMAP1(0x3f095L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f129L)
,___DEF_OFD(___RETI,12,12)
               ___GCMAP1(0x3f101L)
,___DEF_OFD(___RETI,12,3)
               ___GCMAP1(0x3f129L)
___END_OFD

___BEGIN_MOD_PRM
___DEF_MOD_PRM(348,___G___kernel_23_,1)
___DEF_MOD_PRM(138,___G__23__23_kernel_2d_handlers,29)
___DEF_MOD_PRM(59,___G__23__23_dynamic_2d_env_2d_bind,44)
___DEF_MOD_PRM(15,___G__23__23_assq_2d_cdr,47)
___DEF_MOD_PRM(14,___G__23__23_assq,51)
___DEF_MOD_PRM(58,___G__23__23_disable_2d_interrupts_21_,55)
___DEF_MOD_PRM(60,___G__23__23_enable_2d_interrupts_21_,57)
___DEF_MOD_PRM(327,___G__23__23_sync_2d_op_2d_interrupt_21_,59)
___DEF_MOD_PRM(135,___G__23__23_interrupt_2d_handler,61)
___DEF_MOD_PRM(137,___G__23__23_interrupt_2d_vector_2d_set_21_,65)
___DEF_MOD_PRM(120,___G__23__23_get_2d_heartbeat_2d_interval_21_,67)
___DEF_MOD_PRM(301,___G__23__23_set_2d_heartbeat_2d_interval_21_,69)
___DEF_MOD_PRM(272,___G__23__23_raise_2d_high_2d_level_2d_interrupt_21_,71)
___DEF_MOD_PRM(12,___G__23__23_argument_2d_list_2d_remove_2d_absent_21_,73)
___DEF_MOD_PRM(13,___G__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_,78)
___DEF_MOD_PRM(11,___G__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_,83)
___DEF_MOD_PRM(77,___G__23__23_extract_2d_procedure_2d_and_2d_arguments,87)
___DEF_MOD_PRM(90,___G__23__23_fail_2d_check_2d_type_2d_exception,98)
___DEF_MOD_PRM(493,___G_type_2d_exception_3f_,101)
___DEF_MOD_PRM(491,___G_type_2d_exception_2d_procedure,103)
___DEF_MOD_PRM(490,___G_type_2d_exception_2d_arguments,106)
___DEF_MOD_PRM(489,___G_type_2d_exception_2d_arg_2d_num,109)
___DEF_MOD_PRM(492,___G_type_2d_exception_2d_type_2d_id,112)
___DEF_MOD_PRM(283,___G__23__23_raise_2d_type_2d_exception,115)
___DEF_MOD_PRM(80,___G__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception,121)
___DEF_MOD_PRM(454,___G_heap_2d_overflow_2d_exception_3f_,124)
___DEF_MOD_PRM(271,___G__23__23_raise_2d_heap_2d_overflow_2d_exception,126)
___DEF_MOD_PRM(89,___G__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception,130)
___DEF_MOD_PRM(483,___G_stack_2d_overflow_2d_exception_3f_,133)
___DEF_MOD_PRM(282,___G__23__23_raise_2d_stack_2d_overflow_2d_exception,135)
___DEF_MOD_PRM(85,___G__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception,139)
___DEF_MOD_PRM(469,___G_nonprocedure_2d_operator_2d_exception_3f_,142)
___DEF_MOD_PRM(467,___G_nonprocedure_2d_operator_2d_exception_2d_operator,144)
___DEF_MOD_PRM(465,___G_nonprocedure_2d_operator_2d_exception_2d_arguments,147)
___DEF_MOD_PRM(466,___G_nonprocedure_2d_operator_2d_exception_2d_code,150)
___DEF_MOD_PRM(468,___G_nonprocedure_2d_operator_2d_exception_2d_rte,153)
___DEF_MOD_PRM(8,___G__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary,156)
___DEF_MOD_PRM(10,___G__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary,158)
___DEF_MOD_PRM(9,___G__23__23_apply_2d_with_2d_procedure_2d_check,160)
___DEF_MOD_PRM(278,___G__23__23_raise_2d_nonprocedure_2d_operator_2d_exception,162)
___DEF_MOD_PRM(92,___G__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception,166)
___DEF_MOD_PRM(499,___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_,169)
___DEF_MOD_PRM(498,___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure,171)
___DEF_MOD_PRM(497,___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments,174)
___DEF_MOD_PRM(287,___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary,177)
___DEF_MOD_PRM(286,___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception,179)
___DEF_MOD_PRM(81,___G__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception,183)
___DEF_MOD_PRM(457,___G_keyword_2d_expected_2d_exception_3f_,186)
___DEF_MOD_PRM(456,___G_keyword_2d_expected_2d_exception_2d_procedure,188)
___DEF_MOD_PRM(455,___G_keyword_2d_expected_2d_exception_2d_arguments,191)
___DEF_MOD_PRM(274,___G__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary,194)
___DEF_MOD_PRM(273,___G__23__23_raise_2d_keyword_2d_expected_2d_exception,196)
___DEF_MOD_PRM(91,___G__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception,200)
___DEF_MOD_PRM(496,___G_unknown_2d_keyword_2d_argument_2d_exception_3f_,203)
___DEF_MOD_PRM(495,___G_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure,205)
___DEF_MOD_PRM(494,___G_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments,208)
___DEF_MOD_PRM(285,___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary,211)
___DEF_MOD_PRM(284,___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception,213)
___DEF_MOD_PRM(87,___G__23__23_fail_2d_check_2d_os_2d_exception,217)
___DEF_MOD_PRM(477,___G_os_2d_exception_3f_,220)
___DEF_MOD_PRM(476,___G_os_2d_exception_2d_procedure,222)
___DEF_MOD_PRM(473,___G_os_2d_exception_2d_arguments,225)
___DEF_MOD_PRM(475,___G_os_2d_exception_2d_message,228)
___DEF_MOD_PRM(474,___G_os_2d_exception_2d_code,231)
___DEF_MOD_PRM(280,___G__23__23_raise_2d_os_2d_exception,234)
___DEF_MOD_PRM(84,___G__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,241)
___DEF_MOD_PRM(464,___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_,244)
___DEF_MOD_PRM(463,___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure,246)
___DEF_MOD_PRM(462,___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments,249)
___DEF_MOD_PRM(277,___G__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,252)
___DEF_MOD_PRM(78,___G__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception,258)
___DEF_MOD_PRM(446,___G_cfun_2d_conversion_2d_exception_3f_,261)
___DEF_MOD_PRM(445,___G_cfun_2d_conversion_2d_exception_2d_procedure,263)
___DEF_MOD_PRM(442,___G_cfun_2d_conversion_2d_exception_2d_arguments,266)
___DEF_MOD_PRM(443,___G_cfun_2d_conversion_2d_exception_2d_code,269)
___DEF_MOD_PRM(444,___G_cfun_2d_conversion_2d_exception_2d_message,272)
___DEF_MOD_PRM(270,___G__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary,275)
___DEF_MOD_PRM(88,___G__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception,279)
___DEF_MOD_PRM(482,___G_sfun_2d_conversion_2d_exception_3f_,282)
___DEF_MOD_PRM(481,___G_sfun_2d_conversion_2d_exception_2d_procedure,284)
___DEF_MOD_PRM(478,___G_sfun_2d_conversion_2d_exception_2d_arguments,287)
___DEF_MOD_PRM(479,___G_sfun_2d_conversion_2d_exception_2d_code,290)
___DEF_MOD_PRM(480,___G_sfun_2d_conversion_2d_exception_2d_message,293)
___DEF_MOD_PRM(281,___G__23__23_raise_2d_sfun_2d_conversion_2d_exception,296)
___DEF_MOD_PRM(83,___G__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception,300)
___DEF_MOD_PRM(461,___G_multiple_2d_c_2d_return_2d_exception_3f_,303)
___DEF_MOD_PRM(276,___G__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception,305)
___DEF_MOD_PRM(93,___G__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception,308)
___DEF_MOD_PRM(500,___G_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_,311)
___DEF_MOD_PRM(288,___G__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception,313)
___DEF_MOD_PRM(21,___G__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_,316)
___DEF_MOD_PRM(19,___G__23__23_c_2d_return_2d_on_2d_other_2d_processor,318)
___DEF_MOD_PRM(86,___G__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception,320)
___DEF_MOD_PRM(472,___G_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_,323)
___DEF_MOD_PRM(471,___G_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure,325)
___DEF_MOD_PRM(470,___G_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments,328)
___DEF_MOD_PRM(279,___G__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception,331)
___DEF_MOD_PRM(165,___G__23__23_make_2d_promise,335)
___DEF_MOD_PRM(268,___G__23__23_promise_2d_thunk,338)
___DEF_MOD_PRM(269,___G__23__23_promise_2d_thunk_2d_set_21_,340)
___DEF_MOD_PRM(266,___G__23__23_promise_2d_result,342)
___DEF_MOD_PRM(267,___G__23__23_promise_2d_result_2d_set_21_,344)
___DEF_MOD_PRM(101,___G__23__23_force_2d_undetermined,346)
___DEF_MOD_PRM(163,___G__23__23_make_2d_jobs,352)
___DEF_MOD_PRM(6,___G__23__23_add_2d_job_2d_at_2d_tail_21_,355)
___DEF_MOD_PRM(5,___G__23__23_add_2d_job_21_,358)
___DEF_MOD_PRM(67,___G__23__23_execute_2d_jobs_21_,361)
___DEF_MOD_PRM(65,___G__23__23_execute_2d_and_2d_clear_2d_jobs_21_,367)
___DEF_MOD_PRM(26,___G__23__23_clear_2d_jobs_21_,373)
___DEF_MOD_PRM(23,___G__23__23_check_2d_heap_2d_limit,375)
___DEF_MOD_PRM(22,___G__23__23_check_2d_heap,377)
___DEF_MOD_PRM(294,___G__23__23_rest_2d_param_2d_check_2d_heap,380)
___DEF_MOD_PRM(295,___G__23__23_rest_2d_param_2d_heap_2d_overflow,384)
___DEF_MOD_PRM(296,___G__23__23_rest_2d_param_2d_resume_2d_procedure,389)
___DEF_MOD_PRM(117,___G__23__23_gc_2d_without_2d_exceptions,391)
___DEF_MOD_PRM(113,___G__23__23_gc,393)
___DEF_MOD_PRM(4,___G__23__23_add_2d_gc_2d_interrupt_2d_job_21_,398)
___DEF_MOD_PRM(25,___G__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_,401)
___DEF_MOD_PRM(115,___G__23__23_gc_2d_finalize_21_,404)
___DEF_MOD_PRM(66,___G__23__23_execute_2d_final_2d_wills_21_,408)
___DEF_MOD_PRM(114,___G__23__23_gc_2d_final_2d_will_2d_registry_21_,412)
___DEF_MOD_PRM(157,___G__23__23_make_2d_final_2d_will,414)
___DEF_MOD_PRM(134,___G__23__23_handle_2d_gc_2d_interrupt_21_,417)
___DEF_MOD_PRM(123,___G__23__23_get_2d_min_2d_heap,420)
___DEF_MOD_PRM(304,___G__23__23_set_2d_min_2d_heap_21_,422)
___DEF_MOD_PRM(122,___G__23__23_get_2d_max_2d_heap,424)
___DEF_MOD_PRM(303,___G__23__23_set_2d_max_2d_heap_21_,426)
___DEF_MOD_PRM(121,___G__23__23_get_2d_live_2d_percent,428)
___DEF_MOD_PRM(302,___G__23__23_set_2d_live_2d_percent_21_,430)
___DEF_MOD_PRM(126,___G__23__23_get_2d_parallelism_2d_level,432)
___DEF_MOD_PRM(305,___G__23__23_set_2d_parallelism_2d_level_21_,434)
___DEF_MOD_PRM(127,___G__23__23_get_2d_standard_2d_level,436)
___DEF_MOD_PRM(306,___G__23__23_set_2d_standard_2d_level_21_,438)
___DEF_MOD_PRM(300,___G__23__23_set_2d_gambitdir_21_,440)
___DEF_MOD_PRM(299,___G__23__23_set_2d_debug_2d_settings_21_,442)
___DEF_MOD_PRM(49,___G__23__23_cpu_2d_count,444)
___DEF_MOD_PRM(48,___G__23__23_cpu_2d_cache_2d_size,446)
___DEF_MOD_PRM(47,___G__23__23_core_2d_count,448)
___DEF_MOD_PRM(307,___G__23__23_still_2d_copy,450)
___DEF_MOD_PRM(309,___G__23__23_still_2d_obj_2d_refcount_2d_inc_21_,453)
___DEF_MOD_PRM(308,___G__23__23_still_2d_obj_2d_refcount_2d_dec_21_,455)
___DEF_MOD_PRM(178,___G__23__23_make_2d_vector,457)
___DEF_MOD_PRM(170,___G__23__23_make_2d_string,460)
___DEF_MOD_PRM(169,___G__23__23_make_2d_s8vector,463)
___DEF_MOD_PRM(176,___G__23__23_make_2d_u8vector,466)
___DEF_MOD_PRM(166,___G__23__23_make_2d_s16vector,469)
___DEF_MOD_PRM(173,___G__23__23_make_2d_u16vector,472)
___DEF_MOD_PRM(167,___G__23__23_make_2d_s32vector,475)
___DEF_MOD_PRM(174,___G__23__23_make_2d_u32vector,478)
___DEF_MOD_PRM(168,___G__23__23_make_2d_s64vector,481)
___DEF_MOD_PRM(175,___G__23__23_make_2d_u64vector,484)
___DEF_MOD_PRM(155,___G__23__23_make_2d_f32vector,487)
___DEF_MOD_PRM(156,___G__23__23_make_2d_f64vector,490)
___DEF_MOD_PRM(164,___G__23__23_make_2d_machine_2d_code_2d_block,493)
___DEF_MOD_PRM(148,___G__23__23_machine_2d_code_2d_block_2d_ref,496)
___DEF_MOD_PRM(149,___G__23__23_machine_2d_code_2d_block_2d_set_21_,499)
___DEF_MOD_PRM(146,___G__23__23_machine_2d_code_2d_block_2d_exec,502)
___DEF_MOD_PRM(147,___G__23__23_machine_2d_code_2d_block_2d_fixup,505)
___DEF_MOD_PRM(150,___G__23__23_machine_2d_code_2d_fixup,508)
___DEF_MOD_PRM(7,___G__23__23_apply,513)
___DEF_MOD_PRM(177,___G__23__23_make_2d_values,516)
___DEF_MOD_PRM(342,___G__23__23_values_2d_length,519)
___DEF_MOD_PRM(343,___G__23__23_values_2d_ref,521)
___DEF_MOD_PRM(344,___G__23__23_values_2d_set_21_,523)
___DEF_MOD_PRM(31,___G__23__23_closure_3f_,525)
___DEF_MOD_PRM(153,___G__23__23_make_2d_closure,527)
___DEF_MOD_PRM(28,___G__23__23_closure_2d_length,530)
___DEF_MOD_PRM(27,___G__23__23_closure_2d_code,532)
___DEF_MOD_PRM(29,___G__23__23_closure_2d_ref,534)
___DEF_MOD_PRM(30,___G__23__23_closure_2d_set_21_,536)
___DEF_MOD_PRM(325,___G__23__23_subprocedure_3f_,538)
___DEF_MOD_PRM(319,___G__23__23_subprocedure_2d_id,540)
___DEF_MOD_PRM(322,___G__23__23_subprocedure_2d_parent,542)
___DEF_MOD_PRM(321,___G__23__23_subprocedure_2d_nb_2d_parameters,544)
___DEF_MOD_PRM(320,___G__23__23_subprocedure_2d_nb_2d_closed,546)
___DEF_MOD_PRM(172,___G__23__23_make_2d_subprocedure,548)
___DEF_MOD_PRM(323,___G__23__23_subprocedure_2d_parent_2d_info,550)
___DEF_MOD_PRM(324,___G__23__23_subprocedure_2d_parent_2d_name,552)
___DEF_MOD_PRM(75,___G__23__23_explode_2d_continuation,554)
___DEF_MOD_PRM(36,___G__23__23_continuation_2d_frame,558)
___DEF_MOD_PRM(37,___G__23__23_continuation_2d_frame_2d_set_21_,563)
___DEF_MOD_PRM(34,___G__23__23_continuation_2d_denv,565)
___DEF_MOD_PRM(35,___G__23__23_continuation_2d_denv_2d_set_21_,567)
___DEF_MOD_PRM(76,___G__23__23_explode_2d_frame,569)
___DEF_MOD_PRM(110,___G__23__23_frame_2d_ret,578)
___DEF_MOD_PRM(44,___G__23__23_continuation_2d_ret,580)
___DEF_MOD_PRM(297,___G__23__23_return_2d_fs,582)
___DEF_MOD_PRM(107,___G__23__23_frame_2d_fs,584)
___DEF_MOD_PRM(38,___G__23__23_continuation_2d_fs,586)
___DEF_MOD_PRM(108,___G__23__23_frame_2d_link,588)
___DEF_MOD_PRM(40,___G__23__23_continuation_2d_link,590)
___DEF_MOD_PRM(112,___G__23__23_frame_2d_slot_2d_live_3f_,592)
___DEF_MOD_PRM(46,___G__23__23_continuation_2d_slot_2d_live_3f_,594)
___DEF_MOD_PRM(109,___G__23__23_frame_2d_ref,596)
___DEF_MOD_PRM(111,___G__23__23_frame_2d_set_21_,598)
___DEF_MOD_PRM(43,___G__23__23_continuation_2d_ref,600)
___DEF_MOD_PRM(45,___G__23__23_continuation_2d_set_21_,602)
___DEF_MOD_PRM(158,___G__23__23_make_2d_frame,604)
___DEF_MOD_PRM(154,___G__23__23_make_2d_continuation,608)
___DEF_MOD_PRM(33,___G__23__23_continuation_2d_copy,611)
___DEF_MOD_PRM(42,___G__23__23_continuation_2d_next_21_,614)
___DEF_MOD_PRM(41,___G__23__23_continuation_2d_next,616)
___DEF_MOD_PRM(39,___G__23__23_continuation_2d_last,619)
___DEF_MOD_PRM(326,___G__23__23_symbol_2d_table,624)
___DEF_MOD_PRM(139,___G__23__23_keyword_2d_table,626)
___DEF_MOD_PRM(161,___G__23__23_make_2d_interned_2d_symbol,628)
___DEF_MOD_PRM(160,___G__23__23_make_2d_interned_2d_keyword,631)
___DEF_MOD_PRM(162,___G__23__23_make_2d_interned_2d_symkey,634)
___DEF_MOD_PRM(96,___G__23__23_find_2d_interned_2d_symbol,641)
___DEF_MOD_PRM(95,___G__23__23_find_2d_interned_2d_keyword,644)
___DEF_MOD_PRM(97,___G__23__23_find_2d_interned_2d_symkey,647)
___DEF_MOD_PRM(159,___G__23__23_make_2d_global_2d_var,650)
___DEF_MOD_PRM(133,___G__23__23_global_2d_var_3f_,653)
___DEF_MOD_PRM(131,___G__23__23_global_2d_var_2d_ref,655)
___DEF_MOD_PRM(129,___G__23__23_global_2d_var_2d_primitive_2d_ref,657)
___DEF_MOD_PRM(132,___G__23__23_global_2d_var_2d_set_21_,659)
___DEF_MOD_PRM(130,___G__23__23_global_2d_var_2d_primitive_2d_set_21_,661)
___DEF_MOD_PRM(184,___G__23__23_object_2d__3e_global_2d_var_2d__3e_identifier,663)
___DEF_MOD_PRM(183,___G__23__23_object_2d__3e_global_2d_var,668)
___DEF_MOD_PRM(128,___G__23__23_global_2d_var_2d__3e_identifier,670)
___DEF_MOD_PRM(79,___G__23__23_fail_2d_check_2d_foreign,672)
___DEF_MOD_PRM(453,___G_foreign_3f_,675)
___DEF_MOD_PRM(105,___G__23__23_foreign_2d_tags,677)
___DEF_MOD_PRM(452,___G_foreign_2d_tags,679)
___DEF_MOD_PRM(104,___G__23__23_foreign_2d_released_3f_,682)
___DEF_MOD_PRM(451,___G_foreign_2d_released_3f_,684)
___DEF_MOD_PRM(103,___G__23__23_foreign_2d_release_21_,688)
___DEF_MOD_PRM(450,___G_foreign_2d_release_21_,690)
___DEF_MOD_PRM(102,___G__23__23_foreign_2d_address,694)
___DEF_MOD_PRM(449,___G_foreign_2d_address,697)
___DEF_MOD_PRM(261,___G__23__23_process_2d_statistics,701)
___DEF_MOD_PRM(262,___G__23__23_process_2d_times,704)
___DEF_MOD_PRM(119,___G__23__23_get_2d_current_2d_time_21_,707)
___DEF_MOD_PRM(124,___G__23__23_get_2d_monotonic_2d_time_21_,709)
___DEF_MOD_PRM(125,___G__23__23_get_2d_monotonic_2d_time_2d_frequency_21_,711)
___DEF_MOD_PRM(118,___G__23__23_get_2d_bytes_2d_allocated_21_,713)
___DEF_MOD_PRM(1,___G__23__23_actlog_2d_start,715)
___DEF_MOD_PRM(2,___G__23__23_actlog_2d_stop,718)
___DEF_MOD_PRM(0,___G__23__23_actlog_2d_dump,721)
___DEF_MOD_PRM(448,___G_err_2d_code_2d__3e_string,724)
___DEF_MOD_PRM(32,___G__23__23_command_2d_line,727)
___DEF_MOD_PRM(264,___G__23__23_processed_2d_command_2d_line_2d_set_21_,729)
___DEF_MOD_PRM(187,___G__23__23_os_2d_condvar_2d_select_21_,731)
___DEF_MOD_PRM(54,___G__23__23_device_2d_select_2d_abort_21_,733)
___DEF_MOD_PRM(3,___G__23__23_add_2d_exit_2d_job_21_,735)
___DEF_MOD_PRM(24,___G__23__23_clear_2d_exit_2d_jobs_21_,738)
___DEF_MOD_PRM(73,___G__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup,741)
___DEF_MOD_PRM(70,___G__23__23_exit_2d_cleanup,743)
___DEF_MOD_PRM(72,___G__23__23_exit_2d_with_2d_err_2d_code,748)
___DEF_MOD_PRM(68,___G__23__23_exit,753)
___DEF_MOD_PRM(69,___G__23__23_exit_2d_abnormally,756)
___DEF_MOD_PRM(74,___G__23__23_exit_2d_with_2d_exception,759)
___DEF_MOD_PRM(98,___G__23__23_first_2d_argument,762)
___DEF_MOD_PRM(346,___G__23__23_with_2d_no_2d_result_2d_expected,764)
___DEF_MOD_PRM(347,___G__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel,767)
___DEF_MOD_PRM(330,___G__23__23_system_2d_version,770)
___DEF_MOD_PRM(487,___G_system_2d_version,772)
___DEF_MOD_PRM(331,___G__23__23_system_2d_version_2d_string,775)
___DEF_MOD_PRM(488,___G_system_2d_version_2d_string,777)
___DEF_MOD_PRM(485,___G_system_2d_type,780)
___DEF_MOD_PRM(486,___G_system_2d_type_2d_string,782)
___DEF_MOD_PRM(447,___G_configure_2d_command_2d_string,784)
___DEF_MOD_PRM(328,___G__23__23_system_2d_stamp,786)
___DEF_MOD_PRM(484,___G_system_2d_stamp,788)
___DEF_MOD_PRM(334,___G__23__23_type_2d_id,791)
___DEF_MOD_PRM(335,___G__23__23_type_2d_name,793)
___DEF_MOD_PRM(333,___G__23__23_type_2d_flags,795)
___DEF_MOD_PRM(336,___G__23__23_type_2d_super,797)
___DEF_MOD_PRM(332,___G__23__23_type_2d_fields,799)
___DEF_MOD_PRM(312,___G__23__23_structure_2d_direct_2d_instance_2d_of_3f_,801)
___DEF_MOD_PRM(313,___G__23__23_structure_2d_instance_2d_of_3f_,803)
___DEF_MOD_PRM(338,___G__23__23_type_3f_,807)
___DEF_MOD_PRM(317,___G__23__23_structure_2d_type,809)
___DEF_MOD_PRM(318,___G__23__23_structure_2d_type_2d_set_21_,811)
___DEF_MOD_PRM(171,___G__23__23_make_2d_structure,813)
___DEF_MOD_PRM(314,___G__23__23_structure_2d_length,816)
___DEF_MOD_PRM(310,___G__23__23_structure,818)
___DEF_MOD_PRM(315,___G__23__23_structure_2d_ref,825)
___DEF_MOD_PRM(316,___G__23__23_structure_2d_set_21_,831)
___DEF_MOD_PRM(311,___G__23__23_structure_2d_cas_21_,837)
___DEF_MOD_PRM(56,___G__23__23_direct_2d_structure_2d_ref,843)
___DEF_MOD_PRM(57,___G__23__23_direct_2d_structure_2d_set_21_,848)
___DEF_MOD_PRM(55,___G__23__23_direct_2d_structure_2d_cas_21_,853)
___DEF_MOD_PRM(340,___G__23__23_unchecked_2d_structure_2d_ref,858)
___DEF_MOD_PRM(341,___G__23__23_unchecked_2d_structure_2d_set_21_,860)
___DEF_MOD_PRM(339,___G__23__23_unchecked_2d_structure_2d_cas_21_,862)
___DEF_MOD_PRM(152,___G__23__23_main_2d_set_21_,864)
___DEF_MOD_PRM(182,___G__23__23_module_2d_init,866)
___DEF_MOD_PRM(50,___G__23__23_create_2d_module,868)
___DEF_MOD_PRM(289,___G__23__23_register_2d_module_2d_descr_21_,871)
___DEF_MOD_PRM(290,___G__23__23_register_2d_module_2d_descrs_21_,878)
___DEF_MOD_PRM(145,___G__23__23_lookup_2d_registered_2d_module,885)
___DEF_MOD_PRM(144,___G__23__23_lookup_2d_module,891)
___DEF_MOD_PRM(142,___G__23__23_load_2d_required_2d_module_2d_structs,895)
___DEF_MOD_PRM(53,___G__23__23_default_2d_load_2d_required_2d_module,910)
___DEF_MOD_PRM(141,___G__23__23_load_2d_required_2d_module_2d_set_21_,919)
___DEF_MOD_PRM(82,___G__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception,921)
___DEF_MOD_PRM(460,___G_module_2d_not_2d_found_2d_exception_3f_,924)
___DEF_MOD_PRM(459,___G_module_2d_not_2d_found_2d_exception_2d_procedure,926)
___DEF_MOD_PRM(458,___G_module_2d_not_2d_found_2d_exception_2d_arguments,929)
___DEF_MOD_PRM(275,___G__23__23_raise_2d_module_2d_not_2d_found_2d_exception,932)
___DEF_MOD_PRM(291,___G__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_,938)
___DEF_MOD_PRM(143,___G__23__23_load_2d_vm,943)
___DEF_MOD_PRM(349,___G___kernel_23_0,950)
___DEF_MOD_PRM(350,___G___kernel_23_1,953)
___DEF_MOD_PRM(361,___G___kernel_23_2,956)
___DEF_MOD_PRM(372,___G___kernel_23_3,959)
___DEF_MOD_PRM(383,___G___kernel_23_4,962)
___DEF_MOD_PRM(394,___G___kernel_23_5,965)
___DEF_MOD_PRM(405,___G___kernel_23_6,968)
___DEF_MOD_PRM(416,___G___kernel_23_7,971)
___DEF_MOD_PRM(427,___G___kernel_23_8,974)
___DEF_MOD_PRM(438,___G___kernel_23_9,977)
___DEF_MOD_PRM(351,___G___kernel_23_10,980)
___DEF_MOD_PRM(352,___G___kernel_23_11,983)
___DEF_MOD_PRM(353,___G___kernel_23_12,986)
___DEF_MOD_PRM(354,___G___kernel_23_13,989)
___DEF_MOD_PRM(355,___G___kernel_23_14,992)
___DEF_MOD_PRM(356,___G___kernel_23_15,995)
___DEF_MOD_PRM(357,___G___kernel_23_16,998)
___DEF_MOD_PRM(358,___G___kernel_23_17,1001)
___DEF_MOD_PRM(359,___G___kernel_23_18,1004)
___DEF_MOD_PRM(360,___G___kernel_23_19,1007)
___DEF_MOD_PRM(362,___G___kernel_23_20,1010)
___DEF_MOD_PRM(363,___G___kernel_23_21,1013)
___DEF_MOD_PRM(364,___G___kernel_23_22,1016)
___DEF_MOD_PRM(365,___G___kernel_23_23,1019)
___DEF_MOD_PRM(366,___G___kernel_23_24,1022)
___DEF_MOD_PRM(367,___G___kernel_23_25,1025)
___DEF_MOD_PRM(368,___G___kernel_23_26,1028)
___DEF_MOD_PRM(369,___G___kernel_23_27,1031)
___DEF_MOD_PRM(370,___G___kernel_23_28,1034)
___DEF_MOD_PRM(371,___G___kernel_23_29,1037)
___DEF_MOD_PRM(373,___G___kernel_23_30,1040)
___DEF_MOD_PRM(374,___G___kernel_23_31,1043)
___DEF_MOD_PRM(375,___G___kernel_23_32,1046)
___DEF_MOD_PRM(376,___G___kernel_23_33,1049)
___DEF_MOD_PRM(377,___G___kernel_23_34,1052)
___DEF_MOD_PRM(378,___G___kernel_23_35,1055)
___DEF_MOD_PRM(379,___G___kernel_23_36,1058)
___DEF_MOD_PRM(380,___G___kernel_23_37,1061)
___DEF_MOD_PRM(381,___G___kernel_23_38,1064)
___DEF_MOD_PRM(382,___G___kernel_23_39,1067)
___DEF_MOD_PRM(384,___G___kernel_23_40,1070)
___DEF_MOD_PRM(385,___G___kernel_23_41,1073)
___DEF_MOD_PRM(386,___G___kernel_23_42,1076)
___DEF_MOD_PRM(387,___G___kernel_23_43,1079)
___DEF_MOD_PRM(388,___G___kernel_23_44,1082)
___DEF_MOD_PRM(389,___G___kernel_23_45,1085)
___DEF_MOD_PRM(390,___G___kernel_23_46,1088)
___DEF_MOD_PRM(391,___G___kernel_23_47,1091)
___DEF_MOD_PRM(392,___G___kernel_23_48,1094)
___DEF_MOD_PRM(393,___G___kernel_23_49,1097)
___DEF_MOD_PRM(395,___G___kernel_23_50,1100)
___DEF_MOD_PRM(396,___G___kernel_23_51,1103)
___DEF_MOD_PRM(397,___G___kernel_23_52,1106)
___DEF_MOD_PRM(398,___G___kernel_23_53,1109)
___DEF_MOD_PRM(399,___G___kernel_23_54,1112)
___DEF_MOD_PRM(400,___G___kernel_23_55,1115)
___DEF_MOD_PRM(401,___G___kernel_23_56,1118)
___DEF_MOD_PRM(402,___G___kernel_23_57,1121)
___DEF_MOD_PRM(403,___G___kernel_23_58,1124)
___DEF_MOD_PRM(404,___G___kernel_23_59,1127)
___DEF_MOD_PRM(406,___G___kernel_23_60,1130)
___DEF_MOD_PRM(407,___G___kernel_23_61,1133)
___DEF_MOD_PRM(408,___G___kernel_23_62,1136)
___DEF_MOD_PRM(409,___G___kernel_23_63,1139)
___DEF_MOD_PRM(410,___G___kernel_23_64,1142)
___DEF_MOD_PRM(411,___G___kernel_23_65,1145)
___DEF_MOD_PRM(412,___G___kernel_23_66,1148)
___DEF_MOD_PRM(413,___G___kernel_23_67,1151)
___DEF_MOD_PRM(414,___G___kernel_23_68,1154)
___DEF_MOD_PRM(415,___G___kernel_23_69,1157)
___DEF_MOD_PRM(417,___G___kernel_23_70,1160)
___DEF_MOD_PRM(418,___G___kernel_23_71,1163)
___DEF_MOD_PRM(419,___G___kernel_23_72,1166)
___DEF_MOD_PRM(420,___G___kernel_23_73,1169)
___DEF_MOD_PRM(421,___G___kernel_23_74,1172)
___DEF_MOD_PRM(422,___G___kernel_23_75,1175)
___DEF_MOD_PRM(423,___G___kernel_23_76,1178)
___DEF_MOD_PRM(424,___G___kernel_23_77,1181)
___DEF_MOD_PRM(425,___G___kernel_23_78,1184)
___DEF_MOD_PRM(426,___G___kernel_23_79,1187)
___DEF_MOD_PRM(428,___G___kernel_23_80,1190)
___DEF_MOD_PRM(429,___G___kernel_23_81,1193)
___DEF_MOD_PRM(430,___G___kernel_23_82,1196)
___DEF_MOD_PRM(431,___G___kernel_23_83,1199)
___DEF_MOD_PRM(432,___G___kernel_23_84,1202)
___DEF_MOD_PRM(433,___G___kernel_23_85,1205)
___DEF_MOD_PRM(434,___G___kernel_23_86,1208)
___DEF_MOD_PRM(435,___G___kernel_23_87,1211)
___DEF_MOD_PRM(436,___G___kernel_23_88,1214)
___DEF_MOD_PRM(437,___G___kernel_23_89,1217)
___DEF_MOD_PRM(439,___G___kernel_23_90,1220)
___DEF_MOD_PRM(440,___G___kernel_23_91,1223)
___DEF_MOD_PRM(441,___G___kernel_23_92,1226)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(348,___G___kernel_23_,1)
___DEF_MOD_GLO(138,___G__23__23_kernel_2d_handlers,29)
___DEF_MOD_GLO(59,___G__23__23_dynamic_2d_env_2d_bind,44)
___DEF_MOD_GLO(15,___G__23__23_assq_2d_cdr,47)
___DEF_MOD_GLO(14,___G__23__23_assq,51)
___DEF_MOD_GLO(58,___G__23__23_disable_2d_interrupts_21_,55)
___DEF_MOD_GLO(60,___G__23__23_enable_2d_interrupts_21_,57)
___DEF_MOD_GLO(327,___G__23__23_sync_2d_op_2d_interrupt_21_,59)
___DEF_MOD_GLO(135,___G__23__23_interrupt_2d_handler,61)
___DEF_MOD_GLO(137,___G__23__23_interrupt_2d_vector_2d_set_21_,65)
___DEF_MOD_GLO(120,___G__23__23_get_2d_heartbeat_2d_interval_21_,67)
___DEF_MOD_GLO(301,___G__23__23_set_2d_heartbeat_2d_interval_21_,69)
___DEF_MOD_GLO(272,___G__23__23_raise_2d_high_2d_level_2d_interrupt_21_,71)
___DEF_MOD_GLO(12,___G__23__23_argument_2d_list_2d_remove_2d_absent_21_,73)
___DEF_MOD_GLO(13,___G__23__23_argument_2d_list_2d_remove_2d_absent_2d_keys_21_,78)
___DEF_MOD_GLO(11,___G__23__23_argument_2d_list_2d_fix_2d_rest_2d_param_21_,83)
___DEF_MOD_GLO(77,___G__23__23_extract_2d_procedure_2d_and_2d_arguments,87)
___DEF_MOD_GLO(90,___G__23__23_fail_2d_check_2d_type_2d_exception,98)
___DEF_MOD_GLO(493,___G_type_2d_exception_3f_,101)
___DEF_MOD_GLO(491,___G_type_2d_exception_2d_procedure,103)
___DEF_MOD_GLO(490,___G_type_2d_exception_2d_arguments,106)
___DEF_MOD_GLO(489,___G_type_2d_exception_2d_arg_2d_num,109)
___DEF_MOD_GLO(492,___G_type_2d_exception_2d_type_2d_id,112)
___DEF_MOD_GLO(283,___G__23__23_raise_2d_type_2d_exception,115)
___DEF_MOD_GLO(80,___G__23__23_fail_2d_check_2d_heap_2d_overflow_2d_exception,121)
___DEF_MOD_GLO(454,___G_heap_2d_overflow_2d_exception_3f_,124)
___DEF_MOD_GLO(271,___G__23__23_raise_2d_heap_2d_overflow_2d_exception,126)
___DEF_MOD_GLO(89,___G__23__23_fail_2d_check_2d_stack_2d_overflow_2d_exception,130)
___DEF_MOD_GLO(483,___G_stack_2d_overflow_2d_exception_3f_,133)
___DEF_MOD_GLO(282,___G__23__23_raise_2d_stack_2d_overflow_2d_exception,135)
___DEF_MOD_GLO(85,___G__23__23_fail_2d_check_2d_nonprocedure_2d_operator_2d_exception,139)
___DEF_MOD_GLO(469,___G_nonprocedure_2d_operator_2d_exception_3f_,142)
___DEF_MOD_GLO(467,___G_nonprocedure_2d_operator_2d_exception_2d_operator,144)
___DEF_MOD_GLO(465,___G_nonprocedure_2d_operator_2d_exception_2d_arguments,147)
___DEF_MOD_GLO(466,___G_nonprocedure_2d_operator_2d_exception_2d_code,150)
___DEF_MOD_GLO(468,___G_nonprocedure_2d_operator_2d_exception_2d_rte,153)
___DEF_MOD_GLO(8,___G__23__23_apply_2d_global_2d_with_2d_procedure_2d_check_2d_nary,156)
___DEF_MOD_GLO(10,___G__23__23_apply_2d_with_2d_procedure_2d_check_2d_nary,158)
___DEF_MOD_GLO(9,___G__23__23_apply_2d_with_2d_procedure_2d_check,160)
___DEF_MOD_GLO(278,___G__23__23_raise_2d_nonprocedure_2d_operator_2d_exception,162)
___DEF_MOD_GLO(92,___G__23__23_fail_2d_check_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception,166)
___DEF_MOD_GLO(499,___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_,169)
___DEF_MOD_GLO(498,___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure,171)
___DEF_MOD_GLO(497,___G_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments,174)
___DEF_MOD_GLO(287,___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_nary,177)
___DEF_MOD_GLO(286,___G__23__23_raise_2d_wrong_2d_number_2d_of_2d_arguments_2d_exception,179)
___DEF_MOD_GLO(81,___G__23__23_fail_2d_check_2d_keyword_2d_expected_2d_exception,183)
___DEF_MOD_GLO(457,___G_keyword_2d_expected_2d_exception_3f_,186)
___DEF_MOD_GLO(456,___G_keyword_2d_expected_2d_exception_2d_procedure,188)
___DEF_MOD_GLO(455,___G_keyword_2d_expected_2d_exception_2d_arguments,191)
___DEF_MOD_GLO(274,___G__23__23_raise_2d_keyword_2d_expected_2d_exception_2d_nary,194)
___DEF_MOD_GLO(273,___G__23__23_raise_2d_keyword_2d_expected_2d_exception,196)
___DEF_MOD_GLO(91,___G__23__23_fail_2d_check_2d_unknown_2d_keyword_2d_argument_2d_exception,200)
___DEF_MOD_GLO(496,___G_unknown_2d_keyword_2d_argument_2d_exception_3f_,203)
___DEF_MOD_GLO(495,___G_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure,205)
___DEF_MOD_GLO(494,___G_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments,208)
___DEF_MOD_GLO(285,___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception_2d_nary,211)
___DEF_MOD_GLO(284,___G__23__23_raise_2d_unknown_2d_keyword_2d_argument_2d_exception,213)
___DEF_MOD_GLO(87,___G__23__23_fail_2d_check_2d_os_2d_exception,217)
___DEF_MOD_GLO(477,___G_os_2d_exception_3f_,220)
___DEF_MOD_GLO(476,___G_os_2d_exception_2d_procedure,222)
___DEF_MOD_GLO(473,___G_os_2d_exception_2d_arguments,225)
___DEF_MOD_GLO(475,___G_os_2d_exception_2d_message,228)
___DEF_MOD_GLO(474,___G_os_2d_exception_2d_code,231)
___DEF_MOD_GLO(280,___G__23__23_raise_2d_os_2d_exception,234)
___DEF_MOD_GLO(84,___G__23__23_fail_2d_check_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,241)
___DEF_MOD_GLO(464,___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_,244)
___DEF_MOD_GLO(463,___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure,246)
___DEF_MOD_GLO(462,___G_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments,249)
___DEF_MOD_GLO(277,___G__23__23_raise_2d_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,252)
___DEF_MOD_GLO(78,___G__23__23_fail_2d_check_2d_cfun_2d_conversion_2d_exception,258)
___DEF_MOD_GLO(446,___G_cfun_2d_conversion_2d_exception_3f_,261)
___DEF_MOD_GLO(445,___G_cfun_2d_conversion_2d_exception_2d_procedure,263)
___DEF_MOD_GLO(442,___G_cfun_2d_conversion_2d_exception_2d_arguments,266)
___DEF_MOD_GLO(443,___G_cfun_2d_conversion_2d_exception_2d_code,269)
___DEF_MOD_GLO(444,___G_cfun_2d_conversion_2d_exception_2d_message,272)
___DEF_MOD_GLO(270,___G__23__23_raise_2d_cfun_2d_conversion_2d_exception_2d_nary,275)
___DEF_MOD_GLO(88,___G__23__23_fail_2d_check_2d_sfun_2d_conversion_2d_exception,279)
___DEF_MOD_GLO(482,___G_sfun_2d_conversion_2d_exception_3f_,282)
___DEF_MOD_GLO(481,___G_sfun_2d_conversion_2d_exception_2d_procedure,284)
___DEF_MOD_GLO(478,___G_sfun_2d_conversion_2d_exception_2d_arguments,287)
___DEF_MOD_GLO(479,___G_sfun_2d_conversion_2d_exception_2d_code,290)
___DEF_MOD_GLO(480,___G_sfun_2d_conversion_2d_exception_2d_message,293)
___DEF_MOD_GLO(281,___G__23__23_raise_2d_sfun_2d_conversion_2d_exception,296)
___DEF_MOD_GLO(83,___G__23__23_fail_2d_check_2d_multiple_2d_c_2d_return_2d_exception,300)
___DEF_MOD_GLO(461,___G_multiple_2d_c_2d_return_2d_exception_3f_,303)
___DEF_MOD_GLO(276,___G__23__23_raise_2d_multiple_2d_c_2d_return_2d_exception,305)
___DEF_MOD_GLO(93,___G__23__23_fail_2d_check_2d_wrong_2d_processor_2d_c_2d_return_2d_exception,308)
___DEF_MOD_GLO(500,___G_wrong_2d_processor_2d_c_2d_return_2d_exception_3f_,311)
___DEF_MOD_GLO(288,___G__23__23_raise_2d_wrong_2d_processor_2d_c_2d_return_2d_exception,313)
___DEF_MOD_GLO(21,___G__23__23_c_2d_return_2d_on_2d_other_2d_processor_2d_hook_2d_set_21_,316)
___DEF_MOD_GLO(19,___G__23__23_c_2d_return_2d_on_2d_other_2d_processor,318)
___DEF_MOD_GLO(86,___G__23__23_fail_2d_check_2d_number_2d_of_2d_arguments_2d_limit_2d_exception,320)
___DEF_MOD_GLO(472,___G_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_,323)
___DEF_MOD_GLO(471,___G_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure,325)
___DEF_MOD_GLO(470,___G_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments,328)
___DEF_MOD_GLO(279,___G__23__23_raise_2d_number_2d_of_2d_arguments_2d_limit_2d_exception,331)
___DEF_MOD_GLO(165,___G__23__23_make_2d_promise,335)
___DEF_MOD_GLO(268,___G__23__23_promise_2d_thunk,338)
___DEF_MOD_GLO(269,___G__23__23_promise_2d_thunk_2d_set_21_,340)
___DEF_MOD_GLO(266,___G__23__23_promise_2d_result,342)
___DEF_MOD_GLO(267,___G__23__23_promise_2d_result_2d_set_21_,344)
___DEF_MOD_GLO(101,___G__23__23_force_2d_undetermined,346)
___DEF_MOD_GLO(163,___G__23__23_make_2d_jobs,352)
___DEF_MOD_GLO(6,___G__23__23_add_2d_job_2d_at_2d_tail_21_,355)
___DEF_MOD_GLO(5,___G__23__23_add_2d_job_21_,358)
___DEF_MOD_GLO(67,___G__23__23_execute_2d_jobs_21_,361)
___DEF_MOD_GLO(65,___G__23__23_execute_2d_and_2d_clear_2d_jobs_21_,367)
___DEF_MOD_GLO(26,___G__23__23_clear_2d_jobs_21_,373)
___DEF_MOD_GLO(23,___G__23__23_check_2d_heap_2d_limit,375)
___DEF_MOD_GLO(22,___G__23__23_check_2d_heap,377)
___DEF_MOD_GLO(294,___G__23__23_rest_2d_param_2d_check_2d_heap,380)
___DEF_MOD_GLO(295,___G__23__23_rest_2d_param_2d_heap_2d_overflow,384)
___DEF_MOD_GLO(296,___G__23__23_rest_2d_param_2d_resume_2d_procedure,389)
___DEF_MOD_GLO(117,___G__23__23_gc_2d_without_2d_exceptions,391)
___DEF_MOD_GLO(113,___G__23__23_gc,393)
___DEF_MOD_GLO(4,___G__23__23_add_2d_gc_2d_interrupt_2d_job_21_,398)
___DEF_MOD_GLO(25,___G__23__23_clear_2d_gc_2d_interrupt_2d_jobs_21_,401)
___DEF_MOD_GLO(115,___G__23__23_gc_2d_finalize_21_,404)
___DEF_MOD_GLO(66,___G__23__23_execute_2d_final_2d_wills_21_,408)
___DEF_MOD_GLO(114,___G__23__23_gc_2d_final_2d_will_2d_registry_21_,412)
___DEF_MOD_GLO(157,___G__23__23_make_2d_final_2d_will,414)
___DEF_MOD_GLO(134,___G__23__23_handle_2d_gc_2d_interrupt_21_,417)
___DEF_MOD_GLO(123,___G__23__23_get_2d_min_2d_heap,420)
___DEF_MOD_GLO(304,___G__23__23_set_2d_min_2d_heap_21_,422)
___DEF_MOD_GLO(122,___G__23__23_get_2d_max_2d_heap,424)
___DEF_MOD_GLO(303,___G__23__23_set_2d_max_2d_heap_21_,426)
___DEF_MOD_GLO(121,___G__23__23_get_2d_live_2d_percent,428)
___DEF_MOD_GLO(302,___G__23__23_set_2d_live_2d_percent_21_,430)
___DEF_MOD_GLO(126,___G__23__23_get_2d_parallelism_2d_level,432)
___DEF_MOD_GLO(305,___G__23__23_set_2d_parallelism_2d_level_21_,434)
___DEF_MOD_GLO(127,___G__23__23_get_2d_standard_2d_level,436)
___DEF_MOD_GLO(306,___G__23__23_set_2d_standard_2d_level_21_,438)
___DEF_MOD_GLO(300,___G__23__23_set_2d_gambitdir_21_,440)
___DEF_MOD_GLO(299,___G__23__23_set_2d_debug_2d_settings_21_,442)
___DEF_MOD_GLO(49,___G__23__23_cpu_2d_count,444)
___DEF_MOD_GLO(48,___G__23__23_cpu_2d_cache_2d_size,446)
___DEF_MOD_GLO(47,___G__23__23_core_2d_count,448)
___DEF_MOD_GLO(307,___G__23__23_still_2d_copy,450)
___DEF_MOD_GLO(309,___G__23__23_still_2d_obj_2d_refcount_2d_inc_21_,453)
___DEF_MOD_GLO(308,___G__23__23_still_2d_obj_2d_refcount_2d_dec_21_,455)
___DEF_MOD_GLO(178,___G__23__23_make_2d_vector,457)
___DEF_MOD_GLO(170,___G__23__23_make_2d_string,460)
___DEF_MOD_GLO(169,___G__23__23_make_2d_s8vector,463)
___DEF_MOD_GLO(176,___G__23__23_make_2d_u8vector,466)
___DEF_MOD_GLO(166,___G__23__23_make_2d_s16vector,469)
___DEF_MOD_GLO(173,___G__23__23_make_2d_u16vector,472)
___DEF_MOD_GLO(167,___G__23__23_make_2d_s32vector,475)
___DEF_MOD_GLO(174,___G__23__23_make_2d_u32vector,478)
___DEF_MOD_GLO(168,___G__23__23_make_2d_s64vector,481)
___DEF_MOD_GLO(175,___G__23__23_make_2d_u64vector,484)
___DEF_MOD_GLO(155,___G__23__23_make_2d_f32vector,487)
___DEF_MOD_GLO(156,___G__23__23_make_2d_f64vector,490)
___DEF_MOD_GLO(164,___G__23__23_make_2d_machine_2d_code_2d_block,493)
___DEF_MOD_GLO(148,___G__23__23_machine_2d_code_2d_block_2d_ref,496)
___DEF_MOD_GLO(149,___G__23__23_machine_2d_code_2d_block_2d_set_21_,499)
___DEF_MOD_GLO(146,___G__23__23_machine_2d_code_2d_block_2d_exec,502)
___DEF_MOD_GLO(147,___G__23__23_machine_2d_code_2d_block_2d_fixup,505)
___DEF_MOD_GLO(150,___G__23__23_machine_2d_code_2d_fixup,508)
___DEF_MOD_GLO(7,___G__23__23_apply,513)
___DEF_MOD_GLO(177,___G__23__23_make_2d_values,516)
___DEF_MOD_GLO(342,___G__23__23_values_2d_length,519)
___DEF_MOD_GLO(343,___G__23__23_values_2d_ref,521)
___DEF_MOD_GLO(344,___G__23__23_values_2d_set_21_,523)
___DEF_MOD_GLO(31,___G__23__23_closure_3f_,525)
___DEF_MOD_GLO(153,___G__23__23_make_2d_closure,527)
___DEF_MOD_GLO(28,___G__23__23_closure_2d_length,530)
___DEF_MOD_GLO(27,___G__23__23_closure_2d_code,532)
___DEF_MOD_GLO(29,___G__23__23_closure_2d_ref,534)
___DEF_MOD_GLO(30,___G__23__23_closure_2d_set_21_,536)
___DEF_MOD_GLO(325,___G__23__23_subprocedure_3f_,538)
___DEF_MOD_GLO(319,___G__23__23_subprocedure_2d_id,540)
___DEF_MOD_GLO(322,___G__23__23_subprocedure_2d_parent,542)
___DEF_MOD_GLO(321,___G__23__23_subprocedure_2d_nb_2d_parameters,544)
___DEF_MOD_GLO(320,___G__23__23_subprocedure_2d_nb_2d_closed,546)
___DEF_MOD_GLO(172,___G__23__23_make_2d_subprocedure,548)
___DEF_MOD_GLO(323,___G__23__23_subprocedure_2d_parent_2d_info,550)
___DEF_MOD_GLO(324,___G__23__23_subprocedure_2d_parent_2d_name,552)
___DEF_MOD_GLO(75,___G__23__23_explode_2d_continuation,554)
___DEF_MOD_GLO(36,___G__23__23_continuation_2d_frame,558)
___DEF_MOD_GLO(37,___G__23__23_continuation_2d_frame_2d_set_21_,563)
___DEF_MOD_GLO(34,___G__23__23_continuation_2d_denv,565)
___DEF_MOD_GLO(35,___G__23__23_continuation_2d_denv_2d_set_21_,567)
___DEF_MOD_GLO(76,___G__23__23_explode_2d_frame,569)
___DEF_MOD_GLO(110,___G__23__23_frame_2d_ret,578)
___DEF_MOD_GLO(44,___G__23__23_continuation_2d_ret,580)
___DEF_MOD_GLO(297,___G__23__23_return_2d_fs,582)
___DEF_MOD_GLO(107,___G__23__23_frame_2d_fs,584)
___DEF_MOD_GLO(38,___G__23__23_continuation_2d_fs,586)
___DEF_MOD_GLO(108,___G__23__23_frame_2d_link,588)
___DEF_MOD_GLO(40,___G__23__23_continuation_2d_link,590)
___DEF_MOD_GLO(112,___G__23__23_frame_2d_slot_2d_live_3f_,592)
___DEF_MOD_GLO(46,___G__23__23_continuation_2d_slot_2d_live_3f_,594)
___DEF_MOD_GLO(109,___G__23__23_frame_2d_ref,596)
___DEF_MOD_GLO(111,___G__23__23_frame_2d_set_21_,598)
___DEF_MOD_GLO(43,___G__23__23_continuation_2d_ref,600)
___DEF_MOD_GLO(45,___G__23__23_continuation_2d_set_21_,602)
___DEF_MOD_GLO(158,___G__23__23_make_2d_frame,604)
___DEF_MOD_GLO(154,___G__23__23_make_2d_continuation,608)
___DEF_MOD_GLO(33,___G__23__23_continuation_2d_copy,611)
___DEF_MOD_GLO(42,___G__23__23_continuation_2d_next_21_,614)
___DEF_MOD_GLO(41,___G__23__23_continuation_2d_next,616)
___DEF_MOD_GLO(39,___G__23__23_continuation_2d_last,619)
___DEF_MOD_GLO(326,___G__23__23_symbol_2d_table,624)
___DEF_MOD_GLO(139,___G__23__23_keyword_2d_table,626)
___DEF_MOD_GLO(161,___G__23__23_make_2d_interned_2d_symbol,628)
___DEF_MOD_GLO(160,___G__23__23_make_2d_interned_2d_keyword,631)
___DEF_MOD_GLO(162,___G__23__23_make_2d_interned_2d_symkey,634)
___DEF_MOD_GLO(96,___G__23__23_find_2d_interned_2d_symbol,641)
___DEF_MOD_GLO(95,___G__23__23_find_2d_interned_2d_keyword,644)
___DEF_MOD_GLO(97,___G__23__23_find_2d_interned_2d_symkey,647)
___DEF_MOD_GLO(159,___G__23__23_make_2d_global_2d_var,650)
___DEF_MOD_GLO(133,___G__23__23_global_2d_var_3f_,653)
___DEF_MOD_GLO(131,___G__23__23_global_2d_var_2d_ref,655)
___DEF_MOD_GLO(129,___G__23__23_global_2d_var_2d_primitive_2d_ref,657)
___DEF_MOD_GLO(132,___G__23__23_global_2d_var_2d_set_21_,659)
___DEF_MOD_GLO(130,___G__23__23_global_2d_var_2d_primitive_2d_set_21_,661)
___DEF_MOD_GLO(184,___G__23__23_object_2d__3e_global_2d_var_2d__3e_identifier,663)
___DEF_MOD_GLO(183,___G__23__23_object_2d__3e_global_2d_var,668)
___DEF_MOD_GLO(128,___G__23__23_global_2d_var_2d__3e_identifier,670)
___DEF_MOD_GLO(79,___G__23__23_fail_2d_check_2d_foreign,672)
___DEF_MOD_GLO(453,___G_foreign_3f_,675)
___DEF_MOD_GLO(105,___G__23__23_foreign_2d_tags,677)
___DEF_MOD_GLO(452,___G_foreign_2d_tags,679)
___DEF_MOD_GLO(104,___G__23__23_foreign_2d_released_3f_,682)
___DEF_MOD_GLO(451,___G_foreign_2d_released_3f_,684)
___DEF_MOD_GLO(103,___G__23__23_foreign_2d_release_21_,688)
___DEF_MOD_GLO(450,___G_foreign_2d_release_21_,690)
___DEF_MOD_GLO(102,___G__23__23_foreign_2d_address,694)
___DEF_MOD_GLO(449,___G_foreign_2d_address,697)
___DEF_MOD_GLO(261,___G__23__23_process_2d_statistics,701)
___DEF_MOD_GLO(262,___G__23__23_process_2d_times,704)
___DEF_MOD_GLO(119,___G__23__23_get_2d_current_2d_time_21_,707)
___DEF_MOD_GLO(124,___G__23__23_get_2d_monotonic_2d_time_21_,709)
___DEF_MOD_GLO(125,___G__23__23_get_2d_monotonic_2d_time_2d_frequency_21_,711)
___DEF_MOD_GLO(118,___G__23__23_get_2d_bytes_2d_allocated_21_,713)
___DEF_MOD_GLO(1,___G__23__23_actlog_2d_start,715)
___DEF_MOD_GLO(2,___G__23__23_actlog_2d_stop,718)
___DEF_MOD_GLO(0,___G__23__23_actlog_2d_dump,721)
___DEF_MOD_GLO(448,___G_err_2d_code_2d__3e_string,724)
___DEF_MOD_GLO(32,___G__23__23_command_2d_line,727)
___DEF_MOD_GLO(264,___G__23__23_processed_2d_command_2d_line_2d_set_21_,729)
___DEF_MOD_GLO(187,___G__23__23_os_2d_condvar_2d_select_21_,731)
___DEF_MOD_GLO(54,___G__23__23_device_2d_select_2d_abort_21_,733)
___DEF_MOD_GLO(3,___G__23__23_add_2d_exit_2d_job_21_,735)
___DEF_MOD_GLO(24,___G__23__23_clear_2d_exit_2d_jobs_21_,738)
___DEF_MOD_GLO(73,___G__23__23_exit_2d_with_2d_err_2d_code_2d_no_2d_cleanup,741)
___DEF_MOD_GLO(70,___G__23__23_exit_2d_cleanup,743)
___DEF_MOD_GLO(72,___G__23__23_exit_2d_with_2d_err_2d_code,748)
___DEF_MOD_GLO(68,___G__23__23_exit,753)
___DEF_MOD_GLO(69,___G__23__23_exit_2d_abnormally,756)
___DEF_MOD_GLO(74,___G__23__23_exit_2d_with_2d_exception,759)
___DEF_MOD_GLO(98,___G__23__23_first_2d_argument,762)
___DEF_MOD_GLO(346,___G__23__23_with_2d_no_2d_result_2d_expected,764)
___DEF_MOD_GLO(347,___G__23__23_with_2d_no_2d_result_2d_expected_2d_toplevel,767)
___DEF_MOD_GLO(330,___G__23__23_system_2d_version,770)
___DEF_MOD_GLO(487,___G_system_2d_version,772)
___DEF_MOD_GLO(331,___G__23__23_system_2d_version_2d_string,775)
___DEF_MOD_GLO(488,___G_system_2d_version_2d_string,777)
___DEF_MOD_GLO(485,___G_system_2d_type,780)
___DEF_MOD_GLO(486,___G_system_2d_type_2d_string,782)
___DEF_MOD_GLO(447,___G_configure_2d_command_2d_string,784)
___DEF_MOD_GLO(328,___G__23__23_system_2d_stamp,786)
___DEF_MOD_GLO(484,___G_system_2d_stamp,788)
___DEF_MOD_GLO(334,___G__23__23_type_2d_id,791)
___DEF_MOD_GLO(335,___G__23__23_type_2d_name,793)
___DEF_MOD_GLO(333,___G__23__23_type_2d_flags,795)
___DEF_MOD_GLO(336,___G__23__23_type_2d_super,797)
___DEF_MOD_GLO(332,___G__23__23_type_2d_fields,799)
___DEF_MOD_GLO(312,___G__23__23_structure_2d_direct_2d_instance_2d_of_3f_,801)
___DEF_MOD_GLO(313,___G__23__23_structure_2d_instance_2d_of_3f_,803)
___DEF_MOD_GLO(338,___G__23__23_type_3f_,807)
___DEF_MOD_GLO(317,___G__23__23_structure_2d_type,809)
___DEF_MOD_GLO(318,___G__23__23_structure_2d_type_2d_set_21_,811)
___DEF_MOD_GLO(171,___G__23__23_make_2d_structure,813)
___DEF_MOD_GLO(314,___G__23__23_structure_2d_length,816)
___DEF_MOD_GLO(310,___G__23__23_structure,818)
___DEF_MOD_GLO(315,___G__23__23_structure_2d_ref,825)
___DEF_MOD_GLO(316,___G__23__23_structure_2d_set_21_,831)
___DEF_MOD_GLO(311,___G__23__23_structure_2d_cas_21_,837)
___DEF_MOD_GLO(56,___G__23__23_direct_2d_structure_2d_ref,843)
___DEF_MOD_GLO(57,___G__23__23_direct_2d_structure_2d_set_21_,848)
___DEF_MOD_GLO(55,___G__23__23_direct_2d_structure_2d_cas_21_,853)
___DEF_MOD_GLO(340,___G__23__23_unchecked_2d_structure_2d_ref,858)
___DEF_MOD_GLO(341,___G__23__23_unchecked_2d_structure_2d_set_21_,860)
___DEF_MOD_GLO(339,___G__23__23_unchecked_2d_structure_2d_cas_21_,862)
___DEF_MOD_GLO(152,___G__23__23_main_2d_set_21_,864)
___DEF_MOD_GLO(182,___G__23__23_module_2d_init,866)
___DEF_MOD_GLO(50,___G__23__23_create_2d_module,868)
___DEF_MOD_GLO(289,___G__23__23_register_2d_module_2d_descr_21_,871)
___DEF_MOD_GLO(290,___G__23__23_register_2d_module_2d_descrs_21_,878)
___DEF_MOD_GLO(145,___G__23__23_lookup_2d_registered_2d_module,885)
___DEF_MOD_GLO(144,___G__23__23_lookup_2d_module,891)
___DEF_MOD_GLO(142,___G__23__23_load_2d_required_2d_module_2d_structs,895)
___DEF_MOD_GLO(53,___G__23__23_default_2d_load_2d_required_2d_module,910)
___DEF_MOD_GLO(141,___G__23__23_load_2d_required_2d_module_2d_set_21_,919)
___DEF_MOD_GLO(82,___G__23__23_fail_2d_check_2d_module_2d_not_2d_found_2d_exception,921)
___DEF_MOD_GLO(460,___G_module_2d_not_2d_found_2d_exception_3f_,924)
___DEF_MOD_GLO(459,___G_module_2d_not_2d_found_2d_exception_2d_procedure,926)
___DEF_MOD_GLO(458,___G_module_2d_not_2d_found_2d_exception_2d_arguments,929)
___DEF_MOD_GLO(275,___G__23__23_raise_2d_module_2d_not_2d_found_2d_exception,932)
___DEF_MOD_GLO(291,___G__23__23_register_2d_module_2d_descrs_2d_and_2d_load_21_,938)
___DEF_MOD_GLO(143,___G__23__23_load_2d_vm,943)
___DEF_MOD_GLO(349,___G___kernel_23_0,950)
___DEF_MOD_GLO(350,___G___kernel_23_1,953)
___DEF_MOD_GLO(361,___G___kernel_23_2,956)
___DEF_MOD_GLO(372,___G___kernel_23_3,959)
___DEF_MOD_GLO(383,___G___kernel_23_4,962)
___DEF_MOD_GLO(394,___G___kernel_23_5,965)
___DEF_MOD_GLO(405,___G___kernel_23_6,968)
___DEF_MOD_GLO(416,___G___kernel_23_7,971)
___DEF_MOD_GLO(427,___G___kernel_23_8,974)
___DEF_MOD_GLO(438,___G___kernel_23_9,977)
___DEF_MOD_GLO(351,___G___kernel_23_10,980)
___DEF_MOD_GLO(352,___G___kernel_23_11,983)
___DEF_MOD_GLO(353,___G___kernel_23_12,986)
___DEF_MOD_GLO(354,___G___kernel_23_13,989)
___DEF_MOD_GLO(355,___G___kernel_23_14,992)
___DEF_MOD_GLO(356,___G___kernel_23_15,995)
___DEF_MOD_GLO(357,___G___kernel_23_16,998)
___DEF_MOD_GLO(358,___G___kernel_23_17,1001)
___DEF_MOD_GLO(359,___G___kernel_23_18,1004)
___DEF_MOD_GLO(360,___G___kernel_23_19,1007)
___DEF_MOD_GLO(362,___G___kernel_23_20,1010)
___DEF_MOD_GLO(363,___G___kernel_23_21,1013)
___DEF_MOD_GLO(364,___G___kernel_23_22,1016)
___DEF_MOD_GLO(365,___G___kernel_23_23,1019)
___DEF_MOD_GLO(366,___G___kernel_23_24,1022)
___DEF_MOD_GLO(367,___G___kernel_23_25,1025)
___DEF_MOD_GLO(368,___G___kernel_23_26,1028)
___DEF_MOD_GLO(369,___G___kernel_23_27,1031)
___DEF_MOD_GLO(370,___G___kernel_23_28,1034)
___DEF_MOD_GLO(371,___G___kernel_23_29,1037)
___DEF_MOD_GLO(373,___G___kernel_23_30,1040)
___DEF_MOD_GLO(374,___G___kernel_23_31,1043)
___DEF_MOD_GLO(375,___G___kernel_23_32,1046)
___DEF_MOD_GLO(376,___G___kernel_23_33,1049)
___DEF_MOD_GLO(377,___G___kernel_23_34,1052)
___DEF_MOD_GLO(378,___G___kernel_23_35,1055)
___DEF_MOD_GLO(379,___G___kernel_23_36,1058)
___DEF_MOD_GLO(380,___G___kernel_23_37,1061)
___DEF_MOD_GLO(381,___G___kernel_23_38,1064)
___DEF_MOD_GLO(382,___G___kernel_23_39,1067)
___DEF_MOD_GLO(384,___G___kernel_23_40,1070)
___DEF_MOD_GLO(385,___G___kernel_23_41,1073)
___DEF_MOD_GLO(386,___G___kernel_23_42,1076)
___DEF_MOD_GLO(387,___G___kernel_23_43,1079)
___DEF_MOD_GLO(388,___G___kernel_23_44,1082)
___DEF_MOD_GLO(389,___G___kernel_23_45,1085)
___DEF_MOD_GLO(390,___G___kernel_23_46,1088)
___DEF_MOD_GLO(391,___G___kernel_23_47,1091)
___DEF_MOD_GLO(392,___G___kernel_23_48,1094)
___DEF_MOD_GLO(393,___G___kernel_23_49,1097)
___DEF_MOD_GLO(395,___G___kernel_23_50,1100)
___DEF_MOD_GLO(396,___G___kernel_23_51,1103)
___DEF_MOD_GLO(397,___G___kernel_23_52,1106)
___DEF_MOD_GLO(398,___G___kernel_23_53,1109)
___DEF_MOD_GLO(399,___G___kernel_23_54,1112)
___DEF_MOD_GLO(400,___G___kernel_23_55,1115)
___DEF_MOD_GLO(401,___G___kernel_23_56,1118)
___DEF_MOD_GLO(402,___G___kernel_23_57,1121)
___DEF_MOD_GLO(403,___G___kernel_23_58,1124)
___DEF_MOD_GLO(404,___G___kernel_23_59,1127)
___DEF_MOD_GLO(406,___G___kernel_23_60,1130)
___DEF_MOD_GLO(407,___G___kernel_23_61,1133)
___DEF_MOD_GLO(408,___G___kernel_23_62,1136)
___DEF_MOD_GLO(409,___G___kernel_23_63,1139)
___DEF_MOD_GLO(410,___G___kernel_23_64,1142)
___DEF_MOD_GLO(411,___G___kernel_23_65,1145)
___DEF_MOD_GLO(412,___G___kernel_23_66,1148)
___DEF_MOD_GLO(413,___G___kernel_23_67,1151)
___DEF_MOD_GLO(414,___G___kernel_23_68,1154)
___DEF_MOD_GLO(415,___G___kernel_23_69,1157)
___DEF_MOD_GLO(417,___G___kernel_23_70,1160)
___DEF_MOD_GLO(418,___G___kernel_23_71,1163)
___DEF_MOD_GLO(419,___G___kernel_23_72,1166)
___DEF_MOD_GLO(420,___G___kernel_23_73,1169)
___DEF_MOD_GLO(421,___G___kernel_23_74,1172)
___DEF_MOD_GLO(422,___G___kernel_23_75,1175)
___DEF_MOD_GLO(423,___G___kernel_23_76,1178)
___DEF_MOD_GLO(424,___G___kernel_23_77,1181)
___DEF_MOD_GLO(425,___G___kernel_23_78,1184)
___DEF_MOD_GLO(426,___G___kernel_23_79,1187)
___DEF_MOD_GLO(428,___G___kernel_23_80,1190)
___DEF_MOD_GLO(429,___G___kernel_23_81,1193)
___DEF_MOD_GLO(430,___G___kernel_23_82,1196)
___DEF_MOD_GLO(431,___G___kernel_23_83,1199)
___DEF_MOD_GLO(432,___G___kernel_23_84,1202)
___DEF_MOD_GLO(433,___G___kernel_23_85,1205)
___DEF_MOD_GLO(434,___G___kernel_23_86,1208)
___DEF_MOD_GLO(435,___G___kernel_23_87,1211)
___DEF_MOD_GLO(436,___G___kernel_23_88,1214)
___DEF_MOD_GLO(437,___G___kernel_23_89,1217)
___DEF_MOD_GLO(439,___G___kernel_23_90,1220)
___DEF_MOD_GLO(440,___G___kernel_23_91,1223)
___DEF_MOD_GLO(441,___G___kernel_23_92,1226)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S__23__23_type_2d_0_2d_0bf9b656_2d_b071_2d_404a_2d_a514_2d_0fb9d05cf518,"##type-0-0bf9b656-b071-404a-a514-0fb9d05cf518")

___DEF_MOD_SYM(1,___S__23__23_type_2d_0_2d_73c66686_2d_a08f_2d_4c7c_2d_a0f1_2d_5ad7771f242a,"##type-0-73c66686-a08f-4c7c-a0f1-5ad7771f242a")

___DEF_MOD_SYM(2,___S__23__23_type_2d_0_2d_828142df_2d_e9a5_2d_4ed8_2d_a467_2d_2f4833525b3e,"##type-0-828142df-e9a5-4ed8-a467-2f4833525b3e")

___DEF_MOD_SYM(3,___S__23__23_type_2d_0_2d_d69cd396_2d_01e0_2d_4dcb_2d_87dc_2d_31acea8e0e5f,"##type-0-d69cd396-01e0-4dcb-87dc-31acea8e0e5f")

___DEF_MOD_SYM(4,___S__23__23_type_2d_0_2d_f512c9f6_2d_3b24_2d_4c5c_2d_8c8b_2d_cabd75b2f951,"##type-0-f512c9f6-3b24-4c5c-8c8b-cabd75b2f951")

___DEF_MOD_SYM(5,___S__23__23_type_2d_2_2d_2138cd7f_2d_8c42_2d_4164_2d_b56a_2d_a8c7badf3323,"##type-2-2138cd7f-8c42-4164-b56a-a8c7badf3323")

___DEF_MOD_SYM(6,___S__23__23_type_2d_2_2d_299ccee1_2d_77d2_2d_4a6d_2d_ab24_2d_2ebf14297315,"##type-2-299ccee1-77d2-4a6d-ab24-2ebf14297315")

___DEF_MOD_SYM(7,___S__23__23_type_2d_2_2d_3f9f8aaa_2d_ea21_2d_4f2b_2d_bc06_2d_f65950e6c408,"##type-2-3f9f8aaa-ea21-4f2b-bc06-f65950e6c408")

___DEF_MOD_SYM(8,___S__23__23_type_2d_2_2d_3fd6c57f_2d_3c80_2d_4436_2d_a430_2d_57ea4457c11e,"##type-2-3fd6c57f-3c80-4436-a430-57ea4457c11e")

___DEF_MOD_SYM(9,___S__23__23_type_2d_2_2d_CA9CA020_2d_600A_2d_4516_2d_AA78_2d_CBE91EC8BE14,"##type-2-CA9CA020-600A-4516-AA78-CBE91EC8BE14")

___DEF_MOD_SYM(10,___S__23__23_type_2d_2_2d_f9519b37_2d_d6d4_2d_4748_2d_8eb1_2d_a0c8dc18c5e7,"##type-2-f9519b37-d6d4-4748-8eb1-a0c8dc18c5e7")

___DEF_MOD_SYM(11,___S__23__23_type_2d_33_2d_d05e0aa7_2d_e235_2d_441d_2d_aa41_2d_c1ac02065460,"##type-33-d05e0aa7-e235-441d-aa41-c1ac02065460")

___DEF_MOD_SYM(12,___S__23__23_type_2d_4_2d_54dfbc02_2d_718d_2d_4a34_2d_91ab_2d_d1861da7500a,"##type-4-54dfbc02-718d-4a34-91ab-d1861da7500a")

___DEF_MOD_SYM(13,___S__23__23_type_2d_4_2d_9f09b552_2d_0fb7_2d_42c5_2d_b0d4_2d_212155841d53,"##type-4-9f09b552-0fb7-42c5-b0d4-212155841d53")

___DEF_MOD_SYM(14,___S__23__23_type_2d_4_2d_c1fc166b_2d_d951_2d_4871_2d_853c_2d_2b6c8c12d28d,"##type-4-c1fc166b-d951-4871-853c-2b6c8c12d28d")

___DEF_MOD_SYM(15,___S__23__23_type_2d_4_2d_cf06eccd_2d_bf2c_2d_4b30_2d_a6ce_2d_394b345a0dee,"##type-4-cf06eccd-bf2c-4b30-a6ce-394b345a0dee")

___DEF_MOD_SYM(16,___S__23__23_type_2d_4_2d_f39d07ce_2d_436d_2d_40ca_2d_b81f_2d_cdc65d16b7f2,"##type-4-f39d07ce-436d-40ca-b81f-cdc65d16b7f2")

___DEF_MOD_SYM(17,___S__23__23_type_2d_5,"##type-5")
___DEF_MOD_SYM(18,___S___kernel,"_kernel")
___DEF_MOD_SYM(19,___S_arg_2d_num,"arg-num")
___DEF_MOD_SYM(20,___S_arguments,"arguments")
___DEF_MOD_SYM(21,___S_btq_2d_color,"btq-color")
___DEF_MOD_SYM(22,___S_btq_2d_container,"btq-container")
___DEF_MOD_SYM(23,___S_btq_2d_deq_2d_next,"btq-deq-next")
___DEF_MOD_SYM(24,___S_btq_2d_deq_2d_prev,"btq-deq-prev")
___DEF_MOD_SYM(25,___S_btq_2d_left,"btq-left")
___DEF_MOD_SYM(26,___S_btq_2d_leftmost,"btq-leftmost")
___DEF_MOD_SYM(27,___S_btq_2d_parent,"btq-parent")
___DEF_MOD_SYM(28,___S_cfun_2d_conversion_2d_exception,"cfun-conversion-exception")
___DEF_MOD_SYM(29,___S_code,"code")
___DEF_MOD_SYM(30,___S_cont,"cont")
___DEF_MOD_SYM(31,___S_denv,"denv")
___DEF_MOD_SYM(32,___S_denv_2d_cache1,"denv-cache1")
___DEF_MOD_SYM(33,___S_denv_2d_cache2,"denv-cache2")
___DEF_MOD_SYM(34,___S_denv_2d_cache3,"denv-cache3")
___DEF_MOD_SYM(35,___S_end_2d_condvar,"end-condvar")
___DEF_MOD_SYM(36,___S_exception,"exception")
___DEF_MOD_SYM(37,___S_exception_3f_,"exception?")
___DEF_MOD_SYM(38,___S_fields,"fields")
___DEF_MOD_SYM(39,___S_flags,"flags")
___DEF_MOD_SYM(40,___S_floats,"floats")
___DEF_MOD_SYM(41,___S_foreign,"foreign")
___DEF_MOD_SYM(42,___S_heap_2d_overflow_2d_exception,"heap-overflow-exception")
___DEF_MOD_SYM(43,___S_id,"id")
___DEF_MOD_SYM(44,___S_interrupts,"interrupts")
___DEF_MOD_SYM(45,___S_keyword_2d_expected_2d_exception,"keyword-expected-exception")
___DEF_MOD_SYM(46,___S_last_2d_processor,"last-processor")
___DEF_MOD_SYM(47,___S_lock1,"lock1")
___DEF_MOD_SYM(48,___S_lock2,"lock2")
___DEF_MOD_SYM(49,___S_mailbox,"mailbox")
___DEF_MOD_SYM(50,___S_message,"message")
___DEF_MOD_SYM(51,___S_module_2d_not_2d_found_2d_exception,"module-not-found-exception")
___DEF_MOD_SYM(52,___S_multiple_2d_c_2d_return_2d_exception,"multiple-c-return-exception")
___DEF_MOD_SYM(53,___S_name,"name")
___DEF_MOD_SYM(54,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception,"no-such-file-or-directory-exception")

___DEF_MOD_SYM(55,___S_nonprocedure_2d_operator_2d_exception,"nonprocedure-operator-exception")

___DEF_MOD_SYM(56,___S_not_2d_started,"not-started")
___DEF_MOD_SYM(57,___S_number_2d_of_2d_arguments_2d_limit_2d_exception,"number-of-arguments-limit-exception")

___DEF_MOD_SYM(58,___S_operator,"operator")
___DEF_MOD_SYM(59,___S_os_2d_exception,"os-exception")
___DEF_MOD_SYM(60,___S_procedure,"procedure")
___DEF_MOD_SYM(61,___S_repl_2d_channel,"repl-channel")
___DEF_MOD_SYM(62,___S_result,"result")
___DEF_MOD_SYM(63,___S_resume_2d_thunk,"resume-thunk")
___DEF_MOD_SYM(64,___S_rte,"rte")
___DEF_MOD_SYM(65,___S_sfun_2d_conversion_2d_exception,"sfun-conversion-exception")
___DEF_MOD_SYM(66,___S_specific,"specific")
___DEF_MOD_SYM(67,___S_stack_2d_overflow_2d_exception,"stack-overflow-exception")
___DEF_MOD_SYM(68,___S_super,"super")
___DEF_MOD_SYM(69,___S_tgroup,"tgroup")
___DEF_MOD_SYM(70,___S_thread,"thread")
___DEF_MOD_SYM(71,___S_threads_2d_deq_2d_next,"threads-deq-next")
___DEF_MOD_SYM(72,___S_threads_2d_deq_2d_prev,"threads-deq-prev")
___DEF_MOD_SYM(73,___S_toq_2d_color,"toq-color")
___DEF_MOD_SYM(74,___S_toq_2d_container,"toq-container")
___DEF_MOD_SYM(75,___S_toq_2d_left,"toq-left")
___DEF_MOD_SYM(76,___S_toq_2d_leftmost,"toq-leftmost")
___DEF_MOD_SYM(77,___S_toq_2d_parent,"toq-parent")
___DEF_MOD_SYM(78,___S_type,"type")
___DEF_MOD_SYM(79,___S_type_2d_exception,"type-exception")
___DEF_MOD_SYM(80,___S_type_2d_id,"type-id")
___DEF_MOD_SYM(81,___S_unknown_2d_keyword_2d_argument_2d_exception,"unknown-keyword-argument-exception")

___DEF_MOD_SYM(82,___S_void_2a_,"void*")
___DEF_MOD_SYM(83,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception,"wrong-number-of-arguments-exception")

___DEF_MOD_SYM(84,___S_wrong_2d_processor_2d_c_2d_return_2d_exception,"wrong-processor-c-return-exception")

___END_MOD_SYM_KEY

#endif
