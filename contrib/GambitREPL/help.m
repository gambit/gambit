#ifdef ___LINKER_INFO
; File: "help.m", produced by Gambit-C v4.7.3
(
407003
" help"
((" help"))
(
"*"
"+"
"-"
"/"
"<"
"<="
"="
">"
">="
"abandoned-mutex-exception?"
"abort"
"abs"
"acos"
"address-info-family"
"address-info-protocol"
"address-info-socket-info"
"address-info-socket-type"
"address-info?"
"address-infos"
"all-bits-set?"
"and"
"angle"
"any-bits-set?"
"append"
"append-f32vectors"
"append-f64vectors"
"append-s16vectors"
"append-s32vectors"
"append-s64vectors"
"append-s8vectors"
"append-strings"
"append-u16vectors"
"append-u32vectors"
"append-u64vectors"
"append-u8vectors"
"append-vectors"
"apply"
"arithmetic-shift"
"asin"
"assoc"
"assq"
"assv"
"atan"
"begin"
"bit-count"
"bit-set?"
"bitwise-and"
"bitwise-ior"
"bitwise-merge"
"bitwise-not"
"bitwise-xor"
"boolean?"
"box"
"box?"
"break"
"c-declare"
"c-define"
"c-define-type"
"c-initialize"
"c-lambda"
"caar"
"cadr"
"call-with-current-continuation"
"call-with-input-file"
"call-with-input-process"
"call-with-input-string"
"call-with-input-u8vector"
"call-with-input-vector"
"call-with-output-file"
"call-with-output-process"
"call-with-output-string"
"call-with-output-u8vector"
"call-with-output-vector"
"call-with-values"
"call/cc"
"car"
"case"
"cdddar"
"cddddr"
"cdr"
"ceiling"
"cfun-conversion-exception-arguments"
"cfun-conversion-exception-code"
"cfun-conversion-exception-message"
"cfun-conversion-exception-procedure"
"cfun-conversion-exception?"
"char->integer"
"char-alphabetic?"
"char-ci<=?"
"char-ci<?"
"char-ci=?"
"char-ci>=?"
"char-ci>?"
"char-downcase"
"char-lower-case?"
"char-numeric?"
"char-ready?"
"char-upcase"
"char-upper-case?"
"char-whitespace?"
"char<=?"
"char<?"
"char=?"
"char>=?"
"char>?"
"char?"
"clear-bit-field"
"close-input-port"
"close-output-port"
"close-port"
"command-line"
"compile-file"
"compile-file-to-c"
"complex?"
"cond"
"cond-expand"
"condition-variable-broadcast!"
"condition-variable-name"
"condition-variable-signal!"
"condition-variable-specific"
"condition-variable-specific-set!"
"condition-variable?"
"configure-command-string"
"cons"
"console-port"
"continuation-capture"
"continuation-graft"
"continuation-return"
"continuation?"
"copy-bit-field"
"copy-file"
"cos"
"cpu-time"
"create-directory"
"create-fifo"
"create-link"
"create-symbolic-link"
"current-directory"
"current-error-port"
"current-exception-handler"
"current-input-port"
"current-output-port"
"current-readtable"
"current-thread"
"current-time"
"current-user-interrupt-handler"
"datum-parsing-exception-kind"
"datum-parsing-exception-parameters"
"datum-parsing-exception-readenv"
"datum-parsing-exception?"
"deadlock-exception?"
"declare"
"default-random-source"
"defer-user-interrupts"
"define"
"define-cond-expand-feature"
"define-macro"
"define-record-type"
"define-structure"
"define-syntax"
"define-type"
"define-type-of-thread"
"delay"
"delete-directory"
"delete-file"
"denominator"
"directory-files"
"display"
"display-continuation-backtrace"
"display-continuation-dynamic-environment"
"display-continuation-environment"
"display-dynamic-environment?"
"display-environment-set!"
"display-exception"
"display-exception-in-context"
"display-procedure-environment"
"divide-by-zero-exception-arguments"
"divide-by-zero-exception-procedure"
"divide-by-zero-exception?"
"do"
"dynamic-wind"
"eof-object?"
"eq?"
"eq?-hash"
"equal?"
"equal?-hash"
"eqv?"
"eqv?-hash"
"err-code->string"
"error"
"error-exception-message"
"error-exception-parameters"
"error-exception?"
"eval"
"even?"
"exact->inexact"
"exact?"
"exit"
"exp"
"expression-parsing-exception-kind"
"expression-parsing-exception-parameters"
"expression-parsing-exception-source"
"expression-parsing-exception?"
"expt"
"extract-bit-field"
"f32vector"
"f32vector->list"
"f32vector-append"
"f32vector-copy"
"f32vector-fill!"
"f32vector-length"
"f32vector-ref"
"f32vector-set!"
"f32vector-shrink!"
"f32vector?"
"f64vector"
"f64vector->list"
"f64vector-append"
"f64vector-copy"
"f64vector-fill!"
"f64vector-length"
"f64vector-ref"
"f64vector-set!"
"f64vector-shrink!"
"f64vector?"
"file-attributes"
"file-creation-time"
"file-device"
"file-exists?"
"file-group"
"file-info"
"file-info-attributes"
"file-info-creation-time"
"file-info-device"
"file-info-group"
"file-info-inode"
"file-info-last-access-time"
"file-info-last-change-time"
"file-info-last-modification-time"
"file-info-mode"
"file-info-number-of-links"
"file-info-owner"
"file-info-size"
"file-info-type"
"file-info?"
"file-inode"
"file-last-access-time"
"file-last-change-time"
"file-last-modification-time"
"file-mode"
"file-number-of-links"
"file-owner"
"file-size"
"file-type"
"finite?"
"first-bit-set"
"fixnum->flonum"
"fixnum-overflow-exception-arguments"
"fixnum-overflow-exception-procedure"
"fixnum-overflow-exception?"
"fixnum?"
"fl*"
"fl+"
"fl-"
"fl/"
"fl<"
"fl<="
"fl="
"fl>"
"fl>="
"flabs"
"flacos"
"flasin"
"flatan"
"flceiling"
"flcos"
"fldenominator"
"fleven?"
"flexp"
"flexpt"
"flfinite?"
"flfloor"
"flinfinite?"
"flinteger?"
"fllog"
"flmax"
"flmin"
"flnan?"
"flnegative?"
"flnumerator"
"flodd?"
"flonum?"
"floor"
"flpositive?"
"flround"
"flsin"
"flsqrt"
"fltan"
"fltruncate"
"flzero?"
"for-each"
"force"
"force-output"
"foreign-address"
"foreign-release!"
"foreign-released?"
"foreign-tags"
"foreign?"
"future"
"fx*"
"fx+"
"fx-"
"fx<"
"fx<="
"fx="
"fx>"
"fx>="
"fxabs"
"fxand"
"fxarithmetic-shift"
"fxarithmetic-shift-left"
"fxarithmetic-shift-right"
"fxbit-count"
"fxbit-set?"
"fxeven?"
"fxfirst-bit-set"
"fxif"
"fxior"
"fxlength"
"fxmax"
"fxmin"
"fxmodulo"
"fxnegative?"
"fxnot"
"fxodd?"
"fxpositive?"
"fxquotient"
"fxremainder"
"fxwrap*"
"fxwrap+"
"fxwrap-"
"fxwrapabs"
"fxwraparithmetic-shift"
"fxwraparithmetic-shift-left"
"fxwraplogical-shift-right"
"fxwrapquotient"
"fxxor"
"fxzero?"
"gc-report-set!"
"gcd"
"generate-proper-tail-calls"
"gensym"
"get-output-string"
"get-output-u8vector"
"get-output-vector"
"getenv"
"group-info"
"group-info-gid"
"group-info-members"
"group-info-name"
"group-info?"
"heap-overflow-exception?"
"help"
"help-browser"
"host-info"
"host-info-addresses"
"host-info-aliases"
"host-info-name"
"host-info?"
"host-name"
"if"
"imag-part"
"improper-length-list-exception-arg-num"
"improper-length-list-exception-arguments"
"improper-length-list-exception-procedure"
"improper-length-list-exception?"
"inactive-thread-exception-arguments"
"inactive-thread-exception-procedure"
"inactive-thread-exception?"
"include"
"inexact->exact"
"inexact?"
"infinite?"
"initialized-thread-exception-arguments"
"initialized-thread-exception-procedure"
"initialized-thread-exception?"
"input-port-byte-position"
"input-port-bytes-buffered"
"input-port-char-position"
"input-port-characters-buffered"
"input-port-column"
"input-port-line"
"input-port-readtable"
"input-port-readtable-set!"
"input-port-timeout-set!"
"input-port?"
"integer->char"
"integer-length"
"integer-nth-root"
"integer-sqrt"
"integer?"
"interaction-environment"
"invalid-hash-number-exception-arguments"
"invalid-hash-number-exception-procedure"
"invalid-hash-number-exception?"
"join-timeout-exception-arguments"
"join-timeout-exception-procedure"
"join-timeout-exception?"
"keyword->string"
"keyword-expected-exception-arguments"
"keyword-expected-exception-procedure"
"keyword-expected-exception?"
"keyword-hash"
"keyword?"
"lambda"
"lcm"
"length"
"let"
"let*"
"let-syntax"
"letrec"
"letrec-syntax"
"link-flat"
"link-incremental"
"list"
"list->f32vector"
"list->f64vector"
"list->s16vector"
"list->s32vector"
"list->s64vector"
"list->s8vector"
"list->string"
"list->table"
"list->u16vector"
"list->u32vector"
"list->u64vector"
"list->u8vector"
"list->vector"
"list-ref"
"list-tail"
"list?"
"load"
"log"
"magnitude"
"mailbox-receive-timeout-exception-arguments"
"mailbox-receive-timeout-exception-procedure"
"mailbox-receive-timeout-exception?"
"main"
"make-condition-variable"
"make-f32vector"
"make-f64vector"
"make-mutex"
"make-parameter"
"make-polar"
"make-random-source"
"make-rectangular"
"make-root-thread"
"make-s16vector"
"make-s32vector"
"make-s64vector"
"make-s8vector"
"make-string"
"make-table"
"make-thread"
"make-thread-group"
"make-u16vector"
"make-u32vector"
"make-u64vector"
"make-u8vector"
"make-uninterned-keyword"
"make-uninterned-symbol"
"make-vector"
"make-will"
"map"
"max"
"member"
"memq"
"memv"
"min"
"modulo"
"multiple-c-return-exception?"
"mutex-lock!"
"mutex-name"
"mutex-specific"
"mutex-specific-set!"
"mutex-state"
"mutex-unlock!"
"mutex?"
"namespace"
"nan?"
"negative?"
"network-info"
"network-info-aliases"
"network-info-name"
"network-info-number"
"network-info?"
"newline"
"no-such-file-or-directory-exception-arguments"
"no-such-file-or-directory-exception-procedure"
"no-such-file-or-directory-exception?"
"noncontinuable-exception-reason"
"noncontinuable-exception?"
"nonempty-input-port-character-buffer-exception-arguments"
"nonempty-input-port-character-buffer-exception-procedure"
"nonempty-input-port-character-buffer-exception?"
"nonprocedure-operator-exception-arguments"
"nonprocedure-operator-exception-code"
"nonprocedure-operator-exception-operator"
"nonprocedure-operator-exception-rte"
"nonprocedure-operator-exception?"
"not"
"null-environment"
"null?"
"number->string"
"number-of-arguments-limit-exception-arguments"
"number-of-arguments-limit-exception-procedure"
"number-of-arguments-limit-exception?"
"number?"
"numerator"
"object->serial-number"
"object->string"
"object->u8vector"
"odd?"
"open-directory"
"open-dummy"
"open-event-queue"
"open-file"
"open-input-file"
"open-input-process"
"open-input-string"
"open-input-u8vector"
"open-input-vector"
"open-output-file"
"open-output-process"
"open-output-string"
"open-output-u8vector"
"open-output-vector"
"open-process"
"open-string"
"open-string-pipe"
"open-tcp-client"
"open-tcp-server"
"open-u8vector"
"open-u8vector-pipe"
"open-vector"
"open-vector-pipe"
"or"
"os-exception-arguments"
"os-exception-code"
"os-exception-message"
"os-exception-procedure"
"os-exception?"
"output-port-byte-position"
"output-port-char-position"
"output-port-column"
"output-port-line"
"output-port-readtable"
"output-port-readtable-set!"
"output-port-timeout-set!"
"output-port-width"
"output-port?"
"pair?"
"parameterize"
"path-directory"
"path-expand"
"path-extension"
"path-normalize"
"path-strip-directory"
"path-strip-extension"
"path-strip-trailing-directory-separator"
"path-strip-volume"
"path-volume"
"peek-char"
"port-settings-set!"
"port?"
"positive?"
"pp"
"pretty-print"
"primordial-exception-handler"
"print"
"println"
"procedure?"
"process-pid"
"process-status"
"process-times"
"protocol-info"
"protocol-info-aliases"
"protocol-info-name"
"protocol-info-number"
"protocol-info?"
"quasiquote"
"quote"
"quotient"
"raise"
"random-f64vector"
"random-integer"
"random-real"
"random-source-make-f64vectors"
"random-source-make-integers"
"random-source-make-reals"
"random-source-make-u8vectors"
"random-source-pseudo-randomize!"
"random-source-randomize!"
"random-source-state-ref"
"random-source-state-set!"
"random-source?"
"random-u8vector"
"range-exception-arg-num"
"range-exception-arguments"
"range-exception-procedure"
"range-exception?"
"rational?"
"rationalize"
"read"
"read-all"
"read-char"
"read-line"
"read-substring"
"read-subu8vector"
"read-u8"
"readtable-case-conversion?"
"readtable-case-conversion?-set"
"readtable-eval-allowed?"
"readtable-eval-allowed?-set"
"readtable-keywords-allowed?"
"readtable-keywords-allowed?-set"
"readtable-max-unescaped-char"
"readtable-max-unescaped-char-set"
"readtable-max-write-length"
"readtable-max-write-length-set"
"readtable-max-write-level"
"readtable-max-write-level-set"
"readtable-sharing-allowed?"
"readtable-sharing-allowed?-set"
"readtable-start-syntax"
"readtable-start-syntax-set"
"readtable-write-cdr-read-macros?"
"readtable-write-cdr-read-macros?-set"
"readtable-write-extended-read-macros?"
"readtable-write-extended-read-macros?-set"
"readtable?"
"real-part"
"real-time"
"real?"
"receive"
"remainder"
"rename-file"
"repl-display-environment?"
"repl-input-port"
"repl-output-port"
"repl-result-history-max-length-set!"
"repl-result-history-ref"
"replace-bit-field"
"reverse"
"round"
"rpc-remote-error-exception-arguments"
"rpc-remote-error-exception-message"
"rpc-remote-error-exception-procedure"
"rpc-remote-error-exception?"
"s16vector"
"s16vector->list"
"s16vector-append"
"s16vector-copy"
"s16vector-fill!"
"s16vector-length"
"s16vector-ref"
"s16vector-set!"
"s16vector-shrink!"
"s16vector?"
"s32vector"
"s32vector->list"
"s32vector-append"
"s32vector-copy"
"s32vector-fill!"
"s32vector-length"
"s32vector-ref"
"s32vector-set!"
"s32vector-shrink!"
"s32vector?"
"s64vector"
"s64vector->list"
"s64vector-append"
"s64vector-copy"
"s64vector-fill!"
"s64vector-length"
"s64vector-ref"
"s64vector-set!"
"s64vector-shrink!"
"s64vector?"
"s8vector"
"s8vector->list"
"s8vector-append"
"s8vector-copy"
"s8vector-fill!"
"s8vector-length"
"s8vector-ref"
"s8vector-set!"
"s8vector-shrink!"
"s8vector?"
"scheduler-exception-reason"
"scheduler-exception?"
"scheme-report-environment"
"seconds->time"
"serial-number->object"
"service-info"
"service-info-aliases"
"service-info-name"
"service-info-port-number"
"service-info-protocol"
"service-info?"
"set!"
"set-box!"
"set-car!"
"set-cdr!"
"setenv"
"sfun-conversion-exception-arguments"
"sfun-conversion-exception-code"
"sfun-conversion-exception-message"
"sfun-conversion-exception-procedure"
"sfun-conversion-exception?"
"shell-command"
"sin"
"six.!"
"six.!x"
"six.&x"
"six.*x"
"six.++x"
"six.+x"
"six.--x"
"six.-x"
"six.arrow"
"six.break"
"six.call"
"six.case"
"six.clause"
"six.compound"
"six.cons"
"six.continue"
"six.define-procedure"
"six.define-variable"
"six.do-while"
"six.dot"
"six.for"
"six.goto"
"six.identifier"
"six.if"
"six.index"
"six.label"
"six.list"
"six.literal"
"six.make-array"
"six.new"
"six.null"
"six.prefix"
"six.procedure"
"six.procedure-body"
"six.return"
"six.switch"
"six.while"
"six.x!=y"
"six.x%=y"
"six.x%y"
"six.x&&y"
"six.x&=y"
"six.x&y"
"six.x*=y"
"six.x*y"
"six.x++"
"six.x+=y"
"six.x+y"
"six.x,y"
"six.x--"
"six.x-=y"
"six.x-y"
"six.x/=y"
"six.x/y"
"six.x:-y"
"six.x:=y"
"six.x:y"
"six.x<<=y"
"six.x<<y"
"six.x<=y"
"six.x<y"
"six.x==y"
"six.x=y"
"six.x>=y"
"six.x>>=y"
"six.x>>y"
"six.x>y"
"six.x?y:z"
"six.x^=y"
"six.x^y"
"six.x|=y"
"six.x|y"
"six.x||y"
"six.~x"
"socket-info-address"
"socket-info-family"
"socket-info-port-number"
"socket-info?"
"sqrt"
"stack-overflow-exception?"
"started-thread-exception-arguments"
"started-thread-exception-procedure"
"started-thread-exception?"
"step"
"step-level-set!"
"string"
"string->keyword"
"string->list"
"string->number"
"string->symbol"
"string-append"
"string-ci<=?"
"string-ci<?"
"string-ci=?"
"string-ci=?-hash"
"string-ci>=?"
"string-ci>?"
"string-copy"
"string-fill!"
"string-length"
"string-ref"
"string-set!"
"string-shrink!"
"string<=?"
"string<?"
"string=?"
"string=?-hash"
"string>=?"
"string>?"
"string?"
"subf32vector"
"subf32vector-fill!"
"subf32vector-move!"
"subf64vector"
"subf64vector-fill!"
"subf64vector-move!"
"subs16vector"
"subs16vector-fill!"
"subs16vector-move!"
"subs32vector"
"subs32vector-fill!"
"subs32vector-move!"
"subs64vector"
"subs64vector-fill!"
"subs64vector-move!"
"subs8vector"
"subs8vector-fill!"
"subs8vector-move!"
"substring"
"substring-fill!"
"substring-move!"
"subu16vector"
"subu16vector-fill!"
"subu16vector-move!"
"subu32vector"
"subu32vector-fill!"
"subu32vector-move!"
"subu64vector"
"subu64vector-fill!"
"subu64vector-move!"
"subu8vector"
"subu8vector-fill!"
"subu8vector-move!"
"subvector"
"subvector-fill!"
"subvector-move!"
"symbol->string"
"symbol-hash"
"symbol?"
"syntax-rules"
"system-stamp"
"system-type"
"system-type-string"
"system-version"
"system-version-string"
"table->list"
"table-copy"
"table-for-each"
"table-length"
"table-merge"
"table-merge!"
"table-ref"
"table-search"
"table-set!"
"table?"
"tan"
"tcp-client-peer-socket-info"
"tcp-client-self-socket-info"
"tcp-server-socket-info"
"tcp-service-register!"
"tcp-service-unregister!"
"terminated-thread-exception-arguments"
"terminated-thread-exception-procedure"
"terminated-thread-exception?"
"test-bit-field?"
"this-source-file"
"thread-base-priority"
"thread-base-priority-set!"
"thread-group->thread-group-list"
"thread-group->thread-group-vector"
"thread-group->thread-list"
"thread-group->thread-vector"
"thread-group-name"
"thread-group-parent"
"thread-group-resume!"
"thread-group-suspend!"
"thread-group-terminate!"
"thread-group?"
"thread-init!"
"thread-interrupt!"
"thread-join!"
"thread-mailbox-extract-and-rewind"
"thread-mailbox-next"
"thread-mailbox-rewind"
"thread-name"
"thread-priority-boost"
"thread-priority-boost-set!"
"thread-quantum"
"thread-quantum-set!"
"thread-receive"
"thread-resume!"
"thread-send"
"thread-sleep!"
"thread-specific"
"thread-specific-set!"
"thread-start!"
"thread-state"
"thread-state-abnormally-terminated-reason"
"thread-state-abnormally-terminated?"
"thread-state-active-timeout"
"thread-state-active-waiting-for"
"thread-state-active?"
"thread-state-initialized?"
"thread-state-normally-terminated-result"
"thread-state-normally-terminated?"
"thread-state-uninitialized?"
"thread-suspend!"
"thread-terminate!"
"thread-thread-group"
"thread-yield!"
"thread?"
"time"
"time->seconds"
"time?"
"timeout->time"
"top"
"touch"
"trace"
"transcript-off"
"transcript-on"
"truncate"
"tty-history"
"tty-history-max-length-set!"
"tty-history-set!"
"tty-mode-set!"
"tty-paren-balance-duration-set!"
"tty-text-attributes-set!"
"tty-type-set!"
"tty?"
"type-exception-arg-num"
"type-exception-arguments"
"type-exception-procedure"
"type-exception-type-id"
"type-exception?"
"u16vector"
"u16vector->list"
"u16vector-append"
"u16vector-copy"
"u16vector-fill!"
"u16vector-length"
"u16vector-ref"
"u16vector-set!"
"u16vector-shrink!"
"u16vector?"
"u32vector"
"u32vector->list"
"u32vector-append"
"u32vector-copy"
"u32vector-fill!"
"u32vector-length"
"u32vector-ref"
"u32vector-set!"
"u32vector-shrink!"
"u32vector?"
"u64vector"
"u64vector->list"
"u64vector-append"
"u64vector-copy"
"u64vector-fill!"
"u64vector-length"
"u64vector-ref"
"u64vector-set!"
"u64vector-shrink!"
"u64vector?"
"u8vector"
"u8vector->list"
"u8vector->object"
"u8vector-append"
"u8vector-copy"
"u8vector-fill!"
"u8vector-length"
"u8vector-ref"
"u8vector-set!"
"u8vector-shrink!"
"u8vector?"
"unbound-global-exception-code"
"unbound-global-exception-rte"
"unbound-global-exception-variable"
"unbound-global-exception?"
"unbound-os-environment-variable-exception-arguments"
"unbound-os-environment-variable-exception-procedure"
"unbound-os-environment-variable-exception?"
"unbound-serial-number-exception-arguments"
"unbound-serial-number-exception-procedure"
"unbound-serial-number-exception?"
"unbound-table-key-exception-arguments"
"unbound-table-key-exception-procedure"
"unbound-table-key-exception?"
"unbox"
"unbreak"
"uncaught-exception-arguments"
"uncaught-exception-procedure"
"uncaught-exception-reason"
"uncaught-exception?"
"uninitialized-thread-exception-arguments"
"uninitialized-thread-exception-procedure"
"uninitialized-thread-exception?"
"uninterned-keyword?"
"uninterned-symbol?"
"unknown-keyword-argument-exception-arguments"
"unknown-keyword-argument-exception-procedure"
"unknown-keyword-argument-exception?"
"unterminated-process-exception-arguments"
"unterminated-process-exception-procedure"
"unterminated-process-exception?"
"untrace"
"user-info"
"user-info-gid"
"user-info-home"
"user-info-name"
"user-info-shell"
"user-info-uid"
"user-info?"
"user-name"
"values"
"vector"
"vector->list"
"vector-append"
"vector-copy"
"vector-fill!"
"vector-length"
"vector-ref"
"vector-set!"
"vector-shrink!"
"vector?"
"void"
"will-execute!"
"will-testator"
"will?"
"with-exception-catcher"
"with-exception-handler"
"with-input-from-file"
"with-input-from-port"
"with-input-from-process"
"with-input-from-string"
"with-input-from-u8vector"
"with-input-from-vector"
"with-output-to-file"
"with-output-to-port"
"with-output-to-process"
"with-output-to-string"
"with-output-to-u8vector"
"with-output-to-vector"
"write"
"write-char"
"write-substring"
"write-subu8vector"
"write-u8"
"wrong-number-of-arguments-exception-arguments"
"wrong-number-of-arguments-exception-procedure"
"wrong-number-of-arguments-exception?"
"zero?"
)
(
)
(
" help"
"help#gambit-c-help-document"
"help#gambit-repl-help"
"help#r5rs-help-document"
)
(
"##help-hook"
"help#help-names-gambit-c"
"help#help-names-r5rs"
"help#main-help-document"
)
(
"##escape-link"
"##object->string"
"##procedure-name"
"error"
"gr#show-help-document"
"path-expand"
"string-append"
)
 ()
)
#else
#define ___VERSION 407003
#define ___MODULE_NAME " help"
#define ___LINKER_ID ____20_help
#define ___MH_PROC ___H__20_help
#define ___SCRIPT_LINE 0
#define ___SYMCOUNT 1084
#define ___GLOCOUNT 15
#define ___SUPCOUNT 8
#define ___CNSCOUNT 1134
#define ___SUBCOUNT 6
#define ___LBLCOUNT 21
#define ___MODDESCR ___REF_SUB(5)
#include "gambit.h"

___NEED_SYM(___S__2a_)
___NEED_SYM(___S__2b_)
___NEED_SYM(___S__2d_)
___NEED_SYM(___S__2f_)
___NEED_SYM(___S__3c_)
___NEED_SYM(___S__3c__3d_)
___NEED_SYM(___S__3d_)
___NEED_SYM(___S__3e_)
___NEED_SYM(___S__3e__3d_)
___NEED_SYM(___S_abandoned_2d_mutex_2d_exception_3f_)
___NEED_SYM(___S_abort)
___NEED_SYM(___S_abs)
___NEED_SYM(___S_acos)
___NEED_SYM(___S_address_2d_info_2d_family)
___NEED_SYM(___S_address_2d_info_2d_protocol)
___NEED_SYM(___S_address_2d_info_2d_socket_2d_info)
___NEED_SYM(___S_address_2d_info_2d_socket_2d_type)
___NEED_SYM(___S_address_2d_info_3f_)
___NEED_SYM(___S_address_2d_infos)
___NEED_SYM(___S_all_2d_bits_2d_set_3f_)
___NEED_SYM(___S_and)
___NEED_SYM(___S_angle)
___NEED_SYM(___S_any_2d_bits_2d_set_3f_)
___NEED_SYM(___S_append)
___NEED_SYM(___S_append_2d_f32vectors)
___NEED_SYM(___S_append_2d_f64vectors)
___NEED_SYM(___S_append_2d_s16vectors)
___NEED_SYM(___S_append_2d_s32vectors)
___NEED_SYM(___S_append_2d_s64vectors)
___NEED_SYM(___S_append_2d_s8vectors)
___NEED_SYM(___S_append_2d_strings)
___NEED_SYM(___S_append_2d_u16vectors)
___NEED_SYM(___S_append_2d_u32vectors)
___NEED_SYM(___S_append_2d_u64vectors)
___NEED_SYM(___S_append_2d_u8vectors)
___NEED_SYM(___S_append_2d_vectors)
___NEED_SYM(___S_apply)
___NEED_SYM(___S_arithmetic_2d_shift)
___NEED_SYM(___S_asin)
___NEED_SYM(___S_assoc)
___NEED_SYM(___S_assq)
___NEED_SYM(___S_assv)
___NEED_SYM(___S_atan)
___NEED_SYM(___S_begin)
___NEED_SYM(___S_bit_2d_count)
___NEED_SYM(___S_bit_2d_set_3f_)
___NEED_SYM(___S_bitwise_2d_and)
___NEED_SYM(___S_bitwise_2d_ior)
___NEED_SYM(___S_bitwise_2d_merge)
___NEED_SYM(___S_bitwise_2d_not)
___NEED_SYM(___S_bitwise_2d_xor)
___NEED_SYM(___S_boolean_3f_)
___NEED_SYM(___S_box)
___NEED_SYM(___S_box_3f_)
___NEED_SYM(___S_break)
___NEED_SYM(___S_c_2d_declare)
___NEED_SYM(___S_c_2d_define)
___NEED_SYM(___S_c_2d_define_2d_type)
___NEED_SYM(___S_c_2d_initialize)
___NEED_SYM(___S_c_2d_lambda)
___NEED_SYM(___S_caar)
___NEED_SYM(___S_cadr)
___NEED_SYM(___S_call_2d_with_2d_current_2d_continuation)
___NEED_SYM(___S_call_2d_with_2d_input_2d_file)
___NEED_SYM(___S_call_2d_with_2d_input_2d_process)
___NEED_SYM(___S_call_2d_with_2d_input_2d_string)
___NEED_SYM(___S_call_2d_with_2d_input_2d_u8vector)
___NEED_SYM(___S_call_2d_with_2d_input_2d_vector)
___NEED_SYM(___S_call_2d_with_2d_output_2d_file)
___NEED_SYM(___S_call_2d_with_2d_output_2d_process)
___NEED_SYM(___S_call_2d_with_2d_output_2d_string)
___NEED_SYM(___S_call_2d_with_2d_output_2d_u8vector)
___NEED_SYM(___S_call_2d_with_2d_output_2d_vector)
___NEED_SYM(___S_call_2d_with_2d_values)
___NEED_SYM(___S_call_2f_cc)
___NEED_SYM(___S_car)
___NEED_SYM(___S_case)
___NEED_SYM(___S_cdddar)
___NEED_SYM(___S_cddddr)
___NEED_SYM(___S_cdr)
___NEED_SYM(___S_ceiling)
___NEED_SYM(___S_cfun_2d_conversion_2d_exception_2d_arguments)
___NEED_SYM(___S_cfun_2d_conversion_2d_exception_2d_code)
___NEED_SYM(___S_cfun_2d_conversion_2d_exception_2d_message)
___NEED_SYM(___S_cfun_2d_conversion_2d_exception_2d_procedure)
___NEED_SYM(___S_cfun_2d_conversion_2d_exception_3f_)
___NEED_SYM(___S_char_2d__3e_integer)
___NEED_SYM(___S_char_2d_alphabetic_3f_)
___NEED_SYM(___S_char_2d_ci_3c__3d__3f_)
___NEED_SYM(___S_char_2d_ci_3c__3f_)
___NEED_SYM(___S_char_2d_ci_3d__3f_)
___NEED_SYM(___S_char_2d_ci_3e__3d__3f_)
___NEED_SYM(___S_char_2d_ci_3e__3f_)
___NEED_SYM(___S_char_2d_downcase)
___NEED_SYM(___S_char_2d_lower_2d_case_3f_)
___NEED_SYM(___S_char_2d_numeric_3f_)
___NEED_SYM(___S_char_2d_ready_3f_)
___NEED_SYM(___S_char_2d_upcase)
___NEED_SYM(___S_char_2d_upper_2d_case_3f_)
___NEED_SYM(___S_char_2d_whitespace_3f_)
___NEED_SYM(___S_char_3c__3d__3f_)
___NEED_SYM(___S_char_3c__3f_)
___NEED_SYM(___S_char_3d__3f_)
___NEED_SYM(___S_char_3e__3d__3f_)
___NEED_SYM(___S_char_3e__3f_)
___NEED_SYM(___S_char_3f_)
___NEED_SYM(___S_clear_2d_bit_2d_field)
___NEED_SYM(___S_close_2d_input_2d_port)
___NEED_SYM(___S_close_2d_output_2d_port)
___NEED_SYM(___S_close_2d_port)
___NEED_SYM(___S_command_2d_line)
___NEED_SYM(___S_compile_2d_file)
___NEED_SYM(___S_compile_2d_file_2d_to_2d_c)
___NEED_SYM(___S_complex_3f_)
___NEED_SYM(___S_cond)
___NEED_SYM(___S_cond_2d_expand)
___NEED_SYM(___S_condition_2d_variable_2d_broadcast_21_)
___NEED_SYM(___S_condition_2d_variable_2d_name)
___NEED_SYM(___S_condition_2d_variable_2d_signal_21_)
___NEED_SYM(___S_condition_2d_variable_2d_specific)
___NEED_SYM(___S_condition_2d_variable_2d_specific_2d_set_21_)
___NEED_SYM(___S_condition_2d_variable_3f_)
___NEED_SYM(___S_configure_2d_command_2d_string)
___NEED_SYM(___S_cons)
___NEED_SYM(___S_console_2d_port)
___NEED_SYM(___S_continuation_2d_capture)
___NEED_SYM(___S_continuation_2d_graft)
___NEED_SYM(___S_continuation_2d_return)
___NEED_SYM(___S_continuation_3f_)
___NEED_SYM(___S_copy_2d_bit_2d_field)
___NEED_SYM(___S_copy_2d_file)
___NEED_SYM(___S_cos)
___NEED_SYM(___S_cpu_2d_time)
___NEED_SYM(___S_create_2d_directory)
___NEED_SYM(___S_create_2d_fifo)
___NEED_SYM(___S_create_2d_link)
___NEED_SYM(___S_create_2d_symbolic_2d_link)
___NEED_SYM(___S_current_2d_directory)
___NEED_SYM(___S_current_2d_error_2d_port)
___NEED_SYM(___S_current_2d_exception_2d_handler)
___NEED_SYM(___S_current_2d_input_2d_port)
___NEED_SYM(___S_current_2d_output_2d_port)
___NEED_SYM(___S_current_2d_readtable)
___NEED_SYM(___S_current_2d_thread)
___NEED_SYM(___S_current_2d_time)
___NEED_SYM(___S_current_2d_user_2d_interrupt_2d_handler)
___NEED_SYM(___S_datum_2d_parsing_2d_exception_2d_kind)
___NEED_SYM(___S_datum_2d_parsing_2d_exception_2d_parameters)
___NEED_SYM(___S_datum_2d_parsing_2d_exception_2d_readenv)
___NEED_SYM(___S_datum_2d_parsing_2d_exception_3f_)
___NEED_SYM(___S_deadlock_2d_exception_3f_)
___NEED_SYM(___S_declare)
___NEED_SYM(___S_default_2d_random_2d_source)
___NEED_SYM(___S_defer_2d_user_2d_interrupts)
___NEED_SYM(___S_define)
___NEED_SYM(___S_define_2d_cond_2d_expand_2d_feature)
___NEED_SYM(___S_define_2d_macro)
___NEED_SYM(___S_define_2d_record_2d_type)
___NEED_SYM(___S_define_2d_structure)
___NEED_SYM(___S_define_2d_syntax)
___NEED_SYM(___S_define_2d_type)
___NEED_SYM(___S_define_2d_type_2d_of_2d_thread)
___NEED_SYM(___S_delay)
___NEED_SYM(___S_delete_2d_directory)
___NEED_SYM(___S_delete_2d_file)
___NEED_SYM(___S_denominator)
___NEED_SYM(___S_directory_2d_files)
___NEED_SYM(___S_display)
___NEED_SYM(___S_display_2d_continuation_2d_backtrace)
___NEED_SYM(___S_display_2d_continuation_2d_dynamic_2d_environment)
___NEED_SYM(___S_display_2d_continuation_2d_environment)
___NEED_SYM(___S_display_2d_dynamic_2d_environment_3f_)
___NEED_SYM(___S_display_2d_environment_2d_set_21_)
___NEED_SYM(___S_display_2d_exception)
___NEED_SYM(___S_display_2d_exception_2d_in_2d_context)
___NEED_SYM(___S_display_2d_procedure_2d_environment)
___NEED_SYM(___S_divide_2d_by_2d_zero_2d_exception_2d_arguments)
___NEED_SYM(___S_divide_2d_by_2d_zero_2d_exception_2d_procedure)
___NEED_SYM(___S_divide_2d_by_2d_zero_2d_exception_3f_)
___NEED_SYM(___S_do)
___NEED_SYM(___S_dynamic_2d_wind)
___NEED_SYM(___S_eof_2d_object_3f_)
___NEED_SYM(___S_eq_3f_)
___NEED_SYM(___S_eq_3f__2d_hash)
___NEED_SYM(___S_equal_3f_)
___NEED_SYM(___S_equal_3f__2d_hash)
___NEED_SYM(___S_eqv_3f_)
___NEED_SYM(___S_eqv_3f__2d_hash)
___NEED_SYM(___S_err_2d_code_2d__3e_string)
___NEED_SYM(___S_error)
___NEED_SYM(___S_error_2d_exception_2d_message)
___NEED_SYM(___S_error_2d_exception_2d_parameters)
___NEED_SYM(___S_error_2d_exception_3f_)
___NEED_SYM(___S_eval)
___NEED_SYM(___S_even_3f_)
___NEED_SYM(___S_exact_2d__3e_inexact)
___NEED_SYM(___S_exact_3f_)
___NEED_SYM(___S_exit)
___NEED_SYM(___S_exp)
___NEED_SYM(___S_expression_2d_parsing_2d_exception_2d_kind)
___NEED_SYM(___S_expression_2d_parsing_2d_exception_2d_parameters)
___NEED_SYM(___S_expression_2d_parsing_2d_exception_2d_source)
___NEED_SYM(___S_expression_2d_parsing_2d_exception_3f_)
___NEED_SYM(___S_expt)
___NEED_SYM(___S_extract_2d_bit_2d_field)
___NEED_SYM(___S_f32vector)
___NEED_SYM(___S_f32vector_2d__3e_list)
___NEED_SYM(___S_f32vector_2d_append)
___NEED_SYM(___S_f32vector_2d_copy)
___NEED_SYM(___S_f32vector_2d_fill_21_)
___NEED_SYM(___S_f32vector_2d_length)
___NEED_SYM(___S_f32vector_2d_ref)
___NEED_SYM(___S_f32vector_2d_set_21_)
___NEED_SYM(___S_f32vector_2d_shrink_21_)
___NEED_SYM(___S_f32vector_3f_)
___NEED_SYM(___S_f64vector)
___NEED_SYM(___S_f64vector_2d__3e_list)
___NEED_SYM(___S_f64vector_2d_append)
___NEED_SYM(___S_f64vector_2d_copy)
___NEED_SYM(___S_f64vector_2d_fill_21_)
___NEED_SYM(___S_f64vector_2d_length)
___NEED_SYM(___S_f64vector_2d_ref)
___NEED_SYM(___S_f64vector_2d_set_21_)
___NEED_SYM(___S_f64vector_2d_shrink_21_)
___NEED_SYM(___S_f64vector_3f_)
___NEED_SYM(___S_file_2d_attributes)
___NEED_SYM(___S_file_2d_creation_2d_time)
___NEED_SYM(___S_file_2d_device)
___NEED_SYM(___S_file_2d_exists_3f_)
___NEED_SYM(___S_file_2d_group)
___NEED_SYM(___S_file_2d_info)
___NEED_SYM(___S_file_2d_info_2d_attributes)
___NEED_SYM(___S_file_2d_info_2d_creation_2d_time)
___NEED_SYM(___S_file_2d_info_2d_device)
___NEED_SYM(___S_file_2d_info_2d_group)
___NEED_SYM(___S_file_2d_info_2d_inode)
___NEED_SYM(___S_file_2d_info_2d_last_2d_access_2d_time)
___NEED_SYM(___S_file_2d_info_2d_last_2d_change_2d_time)
___NEED_SYM(___S_file_2d_info_2d_last_2d_modification_2d_time)
___NEED_SYM(___S_file_2d_info_2d_mode)
___NEED_SYM(___S_file_2d_info_2d_number_2d_of_2d_links)
___NEED_SYM(___S_file_2d_info_2d_owner)
___NEED_SYM(___S_file_2d_info_2d_size)
___NEED_SYM(___S_file_2d_info_2d_type)
___NEED_SYM(___S_file_2d_info_3f_)
___NEED_SYM(___S_file_2d_inode)
___NEED_SYM(___S_file_2d_last_2d_access_2d_time)
___NEED_SYM(___S_file_2d_last_2d_change_2d_time)
___NEED_SYM(___S_file_2d_last_2d_modification_2d_time)
___NEED_SYM(___S_file_2d_mode)
___NEED_SYM(___S_file_2d_number_2d_of_2d_links)
___NEED_SYM(___S_file_2d_owner)
___NEED_SYM(___S_file_2d_size)
___NEED_SYM(___S_file_2d_type)
___NEED_SYM(___S_finite_3f_)
___NEED_SYM(___S_first_2d_bit_2d_set)
___NEED_SYM(___S_fixnum_2d__3e_flonum)
___NEED_SYM(___S_fixnum_2d_overflow_2d_exception_2d_arguments)
___NEED_SYM(___S_fixnum_2d_overflow_2d_exception_2d_procedure)
___NEED_SYM(___S_fixnum_2d_overflow_2d_exception_3f_)
___NEED_SYM(___S_fixnum_3f_)
___NEED_SYM(___S_fl_2a_)
___NEED_SYM(___S_fl_2b_)
___NEED_SYM(___S_fl_2d_)
___NEED_SYM(___S_fl_2f_)
___NEED_SYM(___S_fl_3c_)
___NEED_SYM(___S_fl_3c__3d_)
___NEED_SYM(___S_fl_3d_)
___NEED_SYM(___S_fl_3e_)
___NEED_SYM(___S_fl_3e__3d_)
___NEED_SYM(___S_flabs)
___NEED_SYM(___S_flacos)
___NEED_SYM(___S_flasin)
___NEED_SYM(___S_flatan)
___NEED_SYM(___S_flceiling)
___NEED_SYM(___S_flcos)
___NEED_SYM(___S_fldenominator)
___NEED_SYM(___S_fleven_3f_)
___NEED_SYM(___S_flexp)
___NEED_SYM(___S_flexpt)
___NEED_SYM(___S_flfinite_3f_)
___NEED_SYM(___S_flfloor)
___NEED_SYM(___S_flinfinite_3f_)
___NEED_SYM(___S_flinteger_3f_)
___NEED_SYM(___S_fllog)
___NEED_SYM(___S_flmax)
___NEED_SYM(___S_flmin)
___NEED_SYM(___S_flnan_3f_)
___NEED_SYM(___S_flnegative_3f_)
___NEED_SYM(___S_flnumerator)
___NEED_SYM(___S_flodd_3f_)
___NEED_SYM(___S_flonum_3f_)
___NEED_SYM(___S_floor)
___NEED_SYM(___S_flpositive_3f_)
___NEED_SYM(___S_flround)
___NEED_SYM(___S_flsin)
___NEED_SYM(___S_flsqrt)
___NEED_SYM(___S_fltan)
___NEED_SYM(___S_fltruncate)
___NEED_SYM(___S_flzero_3f_)
___NEED_SYM(___S_for_2d_each)
___NEED_SYM(___S_force)
___NEED_SYM(___S_force_2d_output)
___NEED_SYM(___S_foreign_2d_address)
___NEED_SYM(___S_foreign_2d_release_21_)
___NEED_SYM(___S_foreign_2d_released_3f_)
___NEED_SYM(___S_foreign_2d_tags)
___NEED_SYM(___S_foreign_3f_)
___NEED_SYM(___S_future)
___NEED_SYM(___S_fx_2a_)
___NEED_SYM(___S_fx_2b_)
___NEED_SYM(___S_fx_2d_)
___NEED_SYM(___S_fx_3c_)
___NEED_SYM(___S_fx_3c__3d_)
___NEED_SYM(___S_fx_3d_)
___NEED_SYM(___S_fx_3e_)
___NEED_SYM(___S_fx_3e__3d_)
___NEED_SYM(___S_fxabs)
___NEED_SYM(___S_fxand)
___NEED_SYM(___S_fxarithmetic_2d_shift)
___NEED_SYM(___S_fxarithmetic_2d_shift_2d_left)
___NEED_SYM(___S_fxarithmetic_2d_shift_2d_right)
___NEED_SYM(___S_fxbit_2d_count)
___NEED_SYM(___S_fxbit_2d_set_3f_)
___NEED_SYM(___S_fxeven_3f_)
___NEED_SYM(___S_fxfirst_2d_bit_2d_set)
___NEED_SYM(___S_fxif)
___NEED_SYM(___S_fxior)
___NEED_SYM(___S_fxlength)
___NEED_SYM(___S_fxmax)
___NEED_SYM(___S_fxmin)
___NEED_SYM(___S_fxmodulo)
___NEED_SYM(___S_fxnegative_3f_)
___NEED_SYM(___S_fxnot)
___NEED_SYM(___S_fxodd_3f_)
___NEED_SYM(___S_fxpositive_3f_)
___NEED_SYM(___S_fxquotient)
___NEED_SYM(___S_fxremainder)
___NEED_SYM(___S_fxwrap_2a_)
___NEED_SYM(___S_fxwrap_2b_)
___NEED_SYM(___S_fxwrap_2d_)
___NEED_SYM(___S_fxwrapabs)
___NEED_SYM(___S_fxwraparithmetic_2d_shift)
___NEED_SYM(___S_fxwraparithmetic_2d_shift_2d_left)
___NEED_SYM(___S_fxwraplogical_2d_shift_2d_right)
___NEED_SYM(___S_fxwrapquotient)
___NEED_SYM(___S_fxxor)
___NEED_SYM(___S_fxzero_3f_)
___NEED_SYM(___S_gc_2d_report_2d_set_21_)
___NEED_SYM(___S_gcd)
___NEED_SYM(___S_generate_2d_proper_2d_tail_2d_calls)
___NEED_SYM(___S_gensym)
___NEED_SYM(___S_get_2d_output_2d_string)
___NEED_SYM(___S_get_2d_output_2d_u8vector)
___NEED_SYM(___S_get_2d_output_2d_vector)
___NEED_SYM(___S_getenv)
___NEED_SYM(___S_group_2d_info)
___NEED_SYM(___S_group_2d_info_2d_gid)
___NEED_SYM(___S_group_2d_info_2d_members)
___NEED_SYM(___S_group_2d_info_2d_name)
___NEED_SYM(___S_group_2d_info_3f_)
___NEED_SYM(___S_heap_2d_overflow_2d_exception_3f_)
___NEED_SYM(___S_help)
___NEED_SYM(___S_help_2d_browser)
___NEED_SYM(___S_host_2d_info)
___NEED_SYM(___S_host_2d_info_2d_addresses)
___NEED_SYM(___S_host_2d_info_2d_aliases)
___NEED_SYM(___S_host_2d_info_2d_name)
___NEED_SYM(___S_host_2d_info_3f_)
___NEED_SYM(___S_host_2d_name)
___NEED_SYM(___S_if)
___NEED_SYM(___S_imag_2d_part)
___NEED_SYM(___S_improper_2d_length_2d_list_2d_exception_2d_arg_2d_num)
___NEED_SYM(___S_improper_2d_length_2d_list_2d_exception_2d_arguments)
___NEED_SYM(___S_improper_2d_length_2d_list_2d_exception_2d_procedure)
___NEED_SYM(___S_improper_2d_length_2d_list_2d_exception_3f_)
___NEED_SYM(___S_inactive_2d_thread_2d_exception_2d_arguments)
___NEED_SYM(___S_inactive_2d_thread_2d_exception_2d_procedure)
___NEED_SYM(___S_inactive_2d_thread_2d_exception_3f_)
___NEED_SYM(___S_include)
___NEED_SYM(___S_inexact_2d__3e_exact)
___NEED_SYM(___S_inexact_3f_)
___NEED_SYM(___S_infinite_3f_)
___NEED_SYM(___S_initialized_2d_thread_2d_exception_2d_arguments)
___NEED_SYM(___S_initialized_2d_thread_2d_exception_2d_procedure)
___NEED_SYM(___S_initialized_2d_thread_2d_exception_3f_)
___NEED_SYM(___S_input_2d_port_2d_byte_2d_position)
___NEED_SYM(___S_input_2d_port_2d_bytes_2d_buffered)
___NEED_SYM(___S_input_2d_port_2d_char_2d_position)
___NEED_SYM(___S_input_2d_port_2d_characters_2d_buffered)
___NEED_SYM(___S_input_2d_port_2d_column)
___NEED_SYM(___S_input_2d_port_2d_line)
___NEED_SYM(___S_input_2d_port_2d_readtable)
___NEED_SYM(___S_input_2d_port_2d_readtable_2d_set_21_)
___NEED_SYM(___S_input_2d_port_2d_timeout_2d_set_21_)
___NEED_SYM(___S_input_2d_port_3f_)
___NEED_SYM(___S_integer_2d__3e_char)
___NEED_SYM(___S_integer_2d_length)
___NEED_SYM(___S_integer_2d_nth_2d_root)
___NEED_SYM(___S_integer_2d_sqrt)
___NEED_SYM(___S_integer_3f_)
___NEED_SYM(___S_interaction_2d_environment)
___NEED_SYM(___S_invalid_2d_hash_2d_number_2d_exception_2d_arguments)
___NEED_SYM(___S_invalid_2d_hash_2d_number_2d_exception_2d_procedure)
___NEED_SYM(___S_invalid_2d_hash_2d_number_2d_exception_3f_)
___NEED_SYM(___S_join_2d_timeout_2d_exception_2d_arguments)
___NEED_SYM(___S_join_2d_timeout_2d_exception_2d_procedure)
___NEED_SYM(___S_join_2d_timeout_2d_exception_3f_)
___NEED_SYM(___S_keyword_2d__3e_string)
___NEED_SYM(___S_keyword_2d_expected_2d_exception_2d_arguments)
___NEED_SYM(___S_keyword_2d_expected_2d_exception_2d_procedure)
___NEED_SYM(___S_keyword_2d_expected_2d_exception_3f_)
___NEED_SYM(___S_keyword_2d_hash)
___NEED_SYM(___S_keyword_3f_)
___NEED_SYM(___S_lambda)
___NEED_SYM(___S_lcm)
___NEED_SYM(___S_length)
___NEED_SYM(___S_let)
___NEED_SYM(___S_let_2a_)
___NEED_SYM(___S_let_2d_syntax)
___NEED_SYM(___S_letrec)
___NEED_SYM(___S_letrec_2d_syntax)
___NEED_SYM(___S_link_2d_flat)
___NEED_SYM(___S_link_2d_incremental)
___NEED_SYM(___S_list)
___NEED_SYM(___S_list_2d__3e_f32vector)
___NEED_SYM(___S_list_2d__3e_f64vector)
___NEED_SYM(___S_list_2d__3e_s16vector)
___NEED_SYM(___S_list_2d__3e_s32vector)
___NEED_SYM(___S_list_2d__3e_s64vector)
___NEED_SYM(___S_list_2d__3e_s8vector)
___NEED_SYM(___S_list_2d__3e_string)
___NEED_SYM(___S_list_2d__3e_table)
___NEED_SYM(___S_list_2d__3e_u16vector)
___NEED_SYM(___S_list_2d__3e_u32vector)
___NEED_SYM(___S_list_2d__3e_u64vector)
___NEED_SYM(___S_list_2d__3e_u8vector)
___NEED_SYM(___S_list_2d__3e_vector)
___NEED_SYM(___S_list_2d_ref)
___NEED_SYM(___S_list_2d_tail)
___NEED_SYM(___S_list_3f_)
___NEED_SYM(___S_load)
___NEED_SYM(___S_log)
___NEED_SYM(___S_magnitude)
___NEED_SYM(___S_mailbox_2d_receive_2d_timeout_2d_exception_2d_arguments)
___NEED_SYM(___S_mailbox_2d_receive_2d_timeout_2d_exception_2d_procedure)
___NEED_SYM(___S_mailbox_2d_receive_2d_timeout_2d_exception_3f_)
___NEED_SYM(___S_main)
___NEED_SYM(___S_make_2d_condition_2d_variable)
___NEED_SYM(___S_make_2d_f32vector)
___NEED_SYM(___S_make_2d_f64vector)
___NEED_SYM(___S_make_2d_mutex)
___NEED_SYM(___S_make_2d_parameter)
___NEED_SYM(___S_make_2d_polar)
___NEED_SYM(___S_make_2d_random_2d_source)
___NEED_SYM(___S_make_2d_rectangular)
___NEED_SYM(___S_make_2d_root_2d_thread)
___NEED_SYM(___S_make_2d_s16vector)
___NEED_SYM(___S_make_2d_s32vector)
___NEED_SYM(___S_make_2d_s64vector)
___NEED_SYM(___S_make_2d_s8vector)
___NEED_SYM(___S_make_2d_string)
___NEED_SYM(___S_make_2d_table)
___NEED_SYM(___S_make_2d_thread)
___NEED_SYM(___S_make_2d_thread_2d_group)
___NEED_SYM(___S_make_2d_u16vector)
___NEED_SYM(___S_make_2d_u32vector)
___NEED_SYM(___S_make_2d_u64vector)
___NEED_SYM(___S_make_2d_u8vector)
___NEED_SYM(___S_make_2d_uninterned_2d_keyword)
___NEED_SYM(___S_make_2d_uninterned_2d_symbol)
___NEED_SYM(___S_make_2d_vector)
___NEED_SYM(___S_make_2d_will)
___NEED_SYM(___S_map)
___NEED_SYM(___S_max)
___NEED_SYM(___S_member)
___NEED_SYM(___S_memq)
___NEED_SYM(___S_memv)
___NEED_SYM(___S_min)
___NEED_SYM(___S_modulo)
___NEED_SYM(___S_multiple_2d_c_2d_return_2d_exception_3f_)
___NEED_SYM(___S_mutex_2d_lock_21_)
___NEED_SYM(___S_mutex_2d_name)
___NEED_SYM(___S_mutex_2d_specific)
___NEED_SYM(___S_mutex_2d_specific_2d_set_21_)
___NEED_SYM(___S_mutex_2d_state)
___NEED_SYM(___S_mutex_2d_unlock_21_)
___NEED_SYM(___S_mutex_3f_)
___NEED_SYM(___S_namespace)
___NEED_SYM(___S_nan_3f_)
___NEED_SYM(___S_negative_3f_)
___NEED_SYM(___S_network_2d_info)
___NEED_SYM(___S_network_2d_info_2d_aliases)
___NEED_SYM(___S_network_2d_info_2d_name)
___NEED_SYM(___S_network_2d_info_2d_number)
___NEED_SYM(___S_network_2d_info_3f_)
___NEED_SYM(___S_newline)
___NEED_SYM(___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
___NEED_SYM(___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
___NEED_SYM(___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_)
___NEED_SYM(___S_noncontinuable_2d_exception_2d_reason)
___NEED_SYM(___S_noncontinuable_2d_exception_3f_)
___NEED_SYM(___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_2d_arguments)
___NEED_SYM(___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_2d_procedure)
___NEED_SYM(___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_3f_)
___NEED_SYM(___S_nonprocedure_2d_operator_2d_exception_2d_arguments)
___NEED_SYM(___S_nonprocedure_2d_operator_2d_exception_2d_code)
___NEED_SYM(___S_nonprocedure_2d_operator_2d_exception_2d_operator)
___NEED_SYM(___S_nonprocedure_2d_operator_2d_exception_2d_rte)
___NEED_SYM(___S_nonprocedure_2d_operator_2d_exception_3f_)
___NEED_SYM(___S_not)
___NEED_SYM(___S_null_2d_environment)
___NEED_SYM(___S_null_3f_)
___NEED_SYM(___S_number_2d__3e_string)
___NEED_SYM(___S_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
___NEED_SYM(___S_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
___NEED_SYM(___S_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_)
___NEED_SYM(___S_number_3f_)
___NEED_SYM(___S_numerator)
___NEED_SYM(___S_object_2d__3e_serial_2d_number)
___NEED_SYM(___S_object_2d__3e_string)
___NEED_SYM(___S_object_2d__3e_u8vector)
___NEED_SYM(___S_odd_3f_)
___NEED_SYM(___S_open_2d_directory)
___NEED_SYM(___S_open_2d_dummy)
___NEED_SYM(___S_open_2d_event_2d_queue)
___NEED_SYM(___S_open_2d_file)
___NEED_SYM(___S_open_2d_input_2d_file)
___NEED_SYM(___S_open_2d_input_2d_process)
___NEED_SYM(___S_open_2d_input_2d_string)
___NEED_SYM(___S_open_2d_input_2d_u8vector)
___NEED_SYM(___S_open_2d_input_2d_vector)
___NEED_SYM(___S_open_2d_output_2d_file)
___NEED_SYM(___S_open_2d_output_2d_process)
___NEED_SYM(___S_open_2d_output_2d_string)
___NEED_SYM(___S_open_2d_output_2d_u8vector)
___NEED_SYM(___S_open_2d_output_2d_vector)
___NEED_SYM(___S_open_2d_process)
___NEED_SYM(___S_open_2d_string)
___NEED_SYM(___S_open_2d_string_2d_pipe)
___NEED_SYM(___S_open_2d_tcp_2d_client)
___NEED_SYM(___S_open_2d_tcp_2d_server)
___NEED_SYM(___S_open_2d_u8vector)
___NEED_SYM(___S_open_2d_u8vector_2d_pipe)
___NEED_SYM(___S_open_2d_vector)
___NEED_SYM(___S_open_2d_vector_2d_pipe)
___NEED_SYM(___S_or)
___NEED_SYM(___S_os_2d_exception_2d_arguments)
___NEED_SYM(___S_os_2d_exception_2d_code)
___NEED_SYM(___S_os_2d_exception_2d_message)
___NEED_SYM(___S_os_2d_exception_2d_procedure)
___NEED_SYM(___S_os_2d_exception_3f_)
___NEED_SYM(___S_output_2d_port_2d_byte_2d_position)
___NEED_SYM(___S_output_2d_port_2d_char_2d_position)
___NEED_SYM(___S_output_2d_port_2d_column)
___NEED_SYM(___S_output_2d_port_2d_line)
___NEED_SYM(___S_output_2d_port_2d_readtable)
___NEED_SYM(___S_output_2d_port_2d_readtable_2d_set_21_)
___NEED_SYM(___S_output_2d_port_2d_timeout_2d_set_21_)
___NEED_SYM(___S_output_2d_port_2d_width)
___NEED_SYM(___S_output_2d_port_3f_)
___NEED_SYM(___S_pair_3f_)
___NEED_SYM(___S_parameterize)
___NEED_SYM(___S_path_2d_directory)
___NEED_SYM(___S_path_2d_expand)
___NEED_SYM(___S_path_2d_extension)
___NEED_SYM(___S_path_2d_normalize)
___NEED_SYM(___S_path_2d_strip_2d_directory)
___NEED_SYM(___S_path_2d_strip_2d_extension)
___NEED_SYM(___S_path_2d_strip_2d_trailing_2d_directory_2d_separator)
___NEED_SYM(___S_path_2d_strip_2d_volume)
___NEED_SYM(___S_path_2d_volume)
___NEED_SYM(___S_peek_2d_char)
___NEED_SYM(___S_port_2d_settings_2d_set_21_)
___NEED_SYM(___S_port_3f_)
___NEED_SYM(___S_positive_3f_)
___NEED_SYM(___S_pp)
___NEED_SYM(___S_pretty_2d_print)
___NEED_SYM(___S_primordial_2d_exception_2d_handler)
___NEED_SYM(___S_print)
___NEED_SYM(___S_println)
___NEED_SYM(___S_procedure_3f_)
___NEED_SYM(___S_process_2d_pid)
___NEED_SYM(___S_process_2d_status)
___NEED_SYM(___S_process_2d_times)
___NEED_SYM(___S_protocol_2d_info)
___NEED_SYM(___S_protocol_2d_info_2d_aliases)
___NEED_SYM(___S_protocol_2d_info_2d_name)
___NEED_SYM(___S_protocol_2d_info_2d_number)
___NEED_SYM(___S_protocol_2d_info_3f_)
___NEED_SYM(___S_quasiquote)
___NEED_SYM(___S_quote)
___NEED_SYM(___S_quotient)
___NEED_SYM(___S_raise)
___NEED_SYM(___S_random_2d_f64vector)
___NEED_SYM(___S_random_2d_integer)
___NEED_SYM(___S_random_2d_real)
___NEED_SYM(___S_random_2d_source_2d_make_2d_f64vectors)
___NEED_SYM(___S_random_2d_source_2d_make_2d_integers)
___NEED_SYM(___S_random_2d_source_2d_make_2d_reals)
___NEED_SYM(___S_random_2d_source_2d_make_2d_u8vectors)
___NEED_SYM(___S_random_2d_source_2d_pseudo_2d_randomize_21_)
___NEED_SYM(___S_random_2d_source_2d_randomize_21_)
___NEED_SYM(___S_random_2d_source_2d_state_2d_ref)
___NEED_SYM(___S_random_2d_source_2d_state_2d_set_21_)
___NEED_SYM(___S_random_2d_source_3f_)
___NEED_SYM(___S_random_2d_u8vector)
___NEED_SYM(___S_range_2d_exception_2d_arg_2d_num)
___NEED_SYM(___S_range_2d_exception_2d_arguments)
___NEED_SYM(___S_range_2d_exception_2d_procedure)
___NEED_SYM(___S_range_2d_exception_3f_)
___NEED_SYM(___S_rational_3f_)
___NEED_SYM(___S_rationalize)
___NEED_SYM(___S_read)
___NEED_SYM(___S_read_2d_all)
___NEED_SYM(___S_read_2d_char)
___NEED_SYM(___S_read_2d_line)
___NEED_SYM(___S_read_2d_substring)
___NEED_SYM(___S_read_2d_subu8vector)
___NEED_SYM(___S_read_2d_u8)
___NEED_SYM(___S_readtable_2d_case_2d_conversion_3f_)
___NEED_SYM(___S_readtable_2d_case_2d_conversion_3f__2d_set)
___NEED_SYM(___S_readtable_2d_eval_2d_allowed_3f_)
___NEED_SYM(___S_readtable_2d_eval_2d_allowed_3f__2d_set)
___NEED_SYM(___S_readtable_2d_keywords_2d_allowed_3f_)
___NEED_SYM(___S_readtable_2d_keywords_2d_allowed_3f__2d_set)
___NEED_SYM(___S_readtable_2d_max_2d_unescaped_2d_char)
___NEED_SYM(___S_readtable_2d_max_2d_unescaped_2d_char_2d_set)
___NEED_SYM(___S_readtable_2d_max_2d_write_2d_length)
___NEED_SYM(___S_readtable_2d_max_2d_write_2d_length_2d_set)
___NEED_SYM(___S_readtable_2d_max_2d_write_2d_level)
___NEED_SYM(___S_readtable_2d_max_2d_write_2d_level_2d_set)
___NEED_SYM(___S_readtable_2d_sharing_2d_allowed_3f_)
___NEED_SYM(___S_readtable_2d_sharing_2d_allowed_3f__2d_set)
___NEED_SYM(___S_readtable_2d_start_2d_syntax)
___NEED_SYM(___S_readtable_2d_start_2d_syntax_2d_set)
___NEED_SYM(___S_readtable_2d_write_2d_cdr_2d_read_2d_macros_3f_)
___NEED_SYM(___S_readtable_2d_write_2d_cdr_2d_read_2d_macros_3f__2d_set)
___NEED_SYM(___S_readtable_2d_write_2d_extended_2d_read_2d_macros_3f_)
___NEED_SYM(___S_readtable_2d_write_2d_extended_2d_read_2d_macros_3f__2d_set)
___NEED_SYM(___S_readtable_3f_)
___NEED_SYM(___S_real_2d_part)
___NEED_SYM(___S_real_2d_time)
___NEED_SYM(___S_real_3f_)
___NEED_SYM(___S_receive)
___NEED_SYM(___S_remainder)
___NEED_SYM(___S_rename_2d_file)
___NEED_SYM(___S_repl_2d_display_2d_environment_3f_)
___NEED_SYM(___S_repl_2d_input_2d_port)
___NEED_SYM(___S_repl_2d_output_2d_port)
___NEED_SYM(___S_repl_2d_result_2d_history_2d_max_2d_length_2d_set_21_)
___NEED_SYM(___S_repl_2d_result_2d_history_2d_ref)
___NEED_SYM(___S_replace_2d_bit_2d_field)
___NEED_SYM(___S_reverse)
___NEED_SYM(___S_round)
___NEED_SYM(___S_rpc_2d_remote_2d_error_2d_exception_2d_arguments)
___NEED_SYM(___S_rpc_2d_remote_2d_error_2d_exception_2d_message)
___NEED_SYM(___S_rpc_2d_remote_2d_error_2d_exception_2d_procedure)
___NEED_SYM(___S_rpc_2d_remote_2d_error_2d_exception_3f_)
___NEED_SYM(___S_s16vector)
___NEED_SYM(___S_s16vector_2d__3e_list)
___NEED_SYM(___S_s16vector_2d_append)
___NEED_SYM(___S_s16vector_2d_copy)
___NEED_SYM(___S_s16vector_2d_fill_21_)
___NEED_SYM(___S_s16vector_2d_length)
___NEED_SYM(___S_s16vector_2d_ref)
___NEED_SYM(___S_s16vector_2d_set_21_)
___NEED_SYM(___S_s16vector_2d_shrink_21_)
___NEED_SYM(___S_s16vector_3f_)
___NEED_SYM(___S_s32vector)
___NEED_SYM(___S_s32vector_2d__3e_list)
___NEED_SYM(___S_s32vector_2d_append)
___NEED_SYM(___S_s32vector_2d_copy)
___NEED_SYM(___S_s32vector_2d_fill_21_)
___NEED_SYM(___S_s32vector_2d_length)
___NEED_SYM(___S_s32vector_2d_ref)
___NEED_SYM(___S_s32vector_2d_set_21_)
___NEED_SYM(___S_s32vector_2d_shrink_21_)
___NEED_SYM(___S_s32vector_3f_)
___NEED_SYM(___S_s64vector)
___NEED_SYM(___S_s64vector_2d__3e_list)
___NEED_SYM(___S_s64vector_2d_append)
___NEED_SYM(___S_s64vector_2d_copy)
___NEED_SYM(___S_s64vector_2d_fill_21_)
___NEED_SYM(___S_s64vector_2d_length)
___NEED_SYM(___S_s64vector_2d_ref)
___NEED_SYM(___S_s64vector_2d_set_21_)
___NEED_SYM(___S_s64vector_2d_shrink_21_)
___NEED_SYM(___S_s64vector_3f_)
___NEED_SYM(___S_s8vector)
___NEED_SYM(___S_s8vector_2d__3e_list)
___NEED_SYM(___S_s8vector_2d_append)
___NEED_SYM(___S_s8vector_2d_copy)
___NEED_SYM(___S_s8vector_2d_fill_21_)
___NEED_SYM(___S_s8vector_2d_length)
___NEED_SYM(___S_s8vector_2d_ref)
___NEED_SYM(___S_s8vector_2d_set_21_)
___NEED_SYM(___S_s8vector_2d_shrink_21_)
___NEED_SYM(___S_s8vector_3f_)
___NEED_SYM(___S_scheduler_2d_exception_2d_reason)
___NEED_SYM(___S_scheduler_2d_exception_3f_)
___NEED_SYM(___S_scheme_2d_report_2d_environment)
___NEED_SYM(___S_seconds_2d__3e_time)
___NEED_SYM(___S_serial_2d_number_2d__3e_object)
___NEED_SYM(___S_service_2d_info)
___NEED_SYM(___S_service_2d_info_2d_aliases)
___NEED_SYM(___S_service_2d_info_2d_name)
___NEED_SYM(___S_service_2d_info_2d_port_2d_number)
___NEED_SYM(___S_service_2d_info_2d_protocol)
___NEED_SYM(___S_service_2d_info_3f_)
___NEED_SYM(___S_set_21_)
___NEED_SYM(___S_set_2d_box_21_)
___NEED_SYM(___S_set_2d_car_21_)
___NEED_SYM(___S_set_2d_cdr_21_)
___NEED_SYM(___S_setenv)
___NEED_SYM(___S_sfun_2d_conversion_2d_exception_2d_arguments)
___NEED_SYM(___S_sfun_2d_conversion_2d_exception_2d_code)
___NEED_SYM(___S_sfun_2d_conversion_2d_exception_2d_message)
___NEED_SYM(___S_sfun_2d_conversion_2d_exception_2d_procedure)
___NEED_SYM(___S_sfun_2d_conversion_2d_exception_3f_)
___NEED_SYM(___S_shell_2d_command)
___NEED_SYM(___S_sin)
___NEED_SYM(___S_six_2e__21_)
___NEED_SYM(___S_six_2e__21_x)
___NEED_SYM(___S_six_2e__26_x)
___NEED_SYM(___S_six_2e__2a_x)
___NEED_SYM(___S_six_2e__2b__2b_x)
___NEED_SYM(___S_six_2e__2b_x)
___NEED_SYM(___S_six_2e__2d__2d_x)
___NEED_SYM(___S_six_2e__2d_x)
___NEED_SYM(___S_six_2e_arrow)
___NEED_SYM(___S_six_2e_break)
___NEED_SYM(___S_six_2e_call)
___NEED_SYM(___S_six_2e_case)
___NEED_SYM(___S_six_2e_clause)
___NEED_SYM(___S_six_2e_compound)
___NEED_SYM(___S_six_2e_cons)
___NEED_SYM(___S_six_2e_continue)
___NEED_SYM(___S_six_2e_define_2d_procedure)
___NEED_SYM(___S_six_2e_define_2d_variable)
___NEED_SYM(___S_six_2e_do_2d_while)
___NEED_SYM(___S_six_2e_dot)
___NEED_SYM(___S_six_2e_for)
___NEED_SYM(___S_six_2e_goto)
___NEED_SYM(___S_six_2e_identifier)
___NEED_SYM(___S_six_2e_if)
___NEED_SYM(___S_six_2e_index)
___NEED_SYM(___S_six_2e_label)
___NEED_SYM(___S_six_2e_list)
___NEED_SYM(___S_six_2e_literal)
___NEED_SYM(___S_six_2e_make_2d_array)
___NEED_SYM(___S_six_2e_new)
___NEED_SYM(___S_six_2e_null)
___NEED_SYM(___S_six_2e_prefix)
___NEED_SYM(___S_six_2e_procedure)
___NEED_SYM(___S_six_2e_procedure_2d_body)
___NEED_SYM(___S_six_2e_return)
___NEED_SYM(___S_six_2e_switch)
___NEED_SYM(___S_six_2e_while)
___NEED_SYM(___S_six_2e_x_21__3d_y)
___NEED_SYM(___S_six_2e_x_25__3d_y)
___NEED_SYM(___S_six_2e_x_25_y)
___NEED_SYM(___S_six_2e_x_26__26_y)
___NEED_SYM(___S_six_2e_x_26__3d_y)
___NEED_SYM(___S_six_2e_x_26_y)
___NEED_SYM(___S_six_2e_x_2a__3d_y)
___NEED_SYM(___S_six_2e_x_2a_y)
___NEED_SYM(___S_six_2e_x_2b__2b_)
___NEED_SYM(___S_six_2e_x_2b__3d_y)
___NEED_SYM(___S_six_2e_x_2b_y)
___NEED_SYM(___S_six_2e_x_2c_y)
___NEED_SYM(___S_six_2e_x_2d__2d_)
___NEED_SYM(___S_six_2e_x_2d__3d_y)
___NEED_SYM(___S_six_2e_x_2d_y)
___NEED_SYM(___S_six_2e_x_2f__3d_y)
___NEED_SYM(___S_six_2e_x_2f_y)
___NEED_SYM(___S_six_2e_x_3a__2d_y)
___NEED_SYM(___S_six_2e_x_3a__3d_y)
___NEED_SYM(___S_six_2e_x_3a_y)
___NEED_SYM(___S_six_2e_x_3c__3c__3d_y)
___NEED_SYM(___S_six_2e_x_3c__3c_y)
___NEED_SYM(___S_six_2e_x_3c__3d_y)
___NEED_SYM(___S_six_2e_x_3c_y)
___NEED_SYM(___S_six_2e_x_3d__3d_y)
___NEED_SYM(___S_six_2e_x_3d_y)
___NEED_SYM(___S_six_2e_x_3e__3d_y)
___NEED_SYM(___S_six_2e_x_3e__3e__3d_y)
___NEED_SYM(___S_six_2e_x_3e__3e_y)
___NEED_SYM(___S_six_2e_x_3e_y)
___NEED_SYM(___S_six_2e_x_3f_y_3a_z)
___NEED_SYM(___S_six_2e_x_5e__3d_y)
___NEED_SYM(___S_six_2e_x_5e_y)
___NEED_SYM(___S_six_2e_x_7c__3d_y)
___NEED_SYM(___S_six_2e_x_7c_y)
___NEED_SYM(___S_six_2e_x_7c__7c_y)
___NEED_SYM(___S_six_2e__7e_x)
___NEED_SYM(___S_socket_2d_info_2d_address)
___NEED_SYM(___S_socket_2d_info_2d_family)
___NEED_SYM(___S_socket_2d_info_2d_port_2d_number)
___NEED_SYM(___S_socket_2d_info_3f_)
___NEED_SYM(___S_sqrt)
___NEED_SYM(___S_stack_2d_overflow_2d_exception_3f_)
___NEED_SYM(___S_started_2d_thread_2d_exception_2d_arguments)
___NEED_SYM(___S_started_2d_thread_2d_exception_2d_procedure)
___NEED_SYM(___S_started_2d_thread_2d_exception_3f_)
___NEED_SYM(___S_step)
___NEED_SYM(___S_step_2d_level_2d_set_21_)
___NEED_SYM(___S_string)
___NEED_SYM(___S_string_2d__3e_keyword)
___NEED_SYM(___S_string_2d__3e_list)
___NEED_SYM(___S_string_2d__3e_number)
___NEED_SYM(___S_string_2d__3e_symbol)
___NEED_SYM(___S_string_2d_append)
___NEED_SYM(___S_string_2d_ci_3c__3d__3f_)
___NEED_SYM(___S_string_2d_ci_3c__3f_)
___NEED_SYM(___S_string_2d_ci_3d__3f_)
___NEED_SYM(___S_string_2d_ci_3d__3f__2d_hash)
___NEED_SYM(___S_string_2d_ci_3e__3d__3f_)
___NEED_SYM(___S_string_2d_ci_3e__3f_)
___NEED_SYM(___S_string_2d_copy)
___NEED_SYM(___S_string_2d_fill_21_)
___NEED_SYM(___S_string_2d_length)
___NEED_SYM(___S_string_2d_ref)
___NEED_SYM(___S_string_2d_set_21_)
___NEED_SYM(___S_string_2d_shrink_21_)
___NEED_SYM(___S_string_3c__3d__3f_)
___NEED_SYM(___S_string_3c__3f_)
___NEED_SYM(___S_string_3d__3f_)
___NEED_SYM(___S_string_3d__3f__2d_hash)
___NEED_SYM(___S_string_3e__3d__3f_)
___NEED_SYM(___S_string_3e__3f_)
___NEED_SYM(___S_string_3f_)
___NEED_SYM(___S_subf32vector)
___NEED_SYM(___S_subf32vector_2d_fill_21_)
___NEED_SYM(___S_subf32vector_2d_move_21_)
___NEED_SYM(___S_subf64vector)
___NEED_SYM(___S_subf64vector_2d_fill_21_)
___NEED_SYM(___S_subf64vector_2d_move_21_)
___NEED_SYM(___S_subs16vector)
___NEED_SYM(___S_subs16vector_2d_fill_21_)
___NEED_SYM(___S_subs16vector_2d_move_21_)
___NEED_SYM(___S_subs32vector)
___NEED_SYM(___S_subs32vector_2d_fill_21_)
___NEED_SYM(___S_subs32vector_2d_move_21_)
___NEED_SYM(___S_subs64vector)
___NEED_SYM(___S_subs64vector_2d_fill_21_)
___NEED_SYM(___S_subs64vector_2d_move_21_)
___NEED_SYM(___S_subs8vector)
___NEED_SYM(___S_subs8vector_2d_fill_21_)
___NEED_SYM(___S_subs8vector_2d_move_21_)
___NEED_SYM(___S_substring)
___NEED_SYM(___S_substring_2d_fill_21_)
___NEED_SYM(___S_substring_2d_move_21_)
___NEED_SYM(___S_subu16vector)
___NEED_SYM(___S_subu16vector_2d_fill_21_)
___NEED_SYM(___S_subu16vector_2d_move_21_)
___NEED_SYM(___S_subu32vector)
___NEED_SYM(___S_subu32vector_2d_fill_21_)
___NEED_SYM(___S_subu32vector_2d_move_21_)
___NEED_SYM(___S_subu64vector)
___NEED_SYM(___S_subu64vector_2d_fill_21_)
___NEED_SYM(___S_subu64vector_2d_move_21_)
___NEED_SYM(___S_subu8vector)
___NEED_SYM(___S_subu8vector_2d_fill_21_)
___NEED_SYM(___S_subu8vector_2d_move_21_)
___NEED_SYM(___S_subvector)
___NEED_SYM(___S_subvector_2d_fill_21_)
___NEED_SYM(___S_subvector_2d_move_21_)
___NEED_SYM(___S_symbol_2d__3e_string)
___NEED_SYM(___S_symbol_2d_hash)
___NEED_SYM(___S_symbol_3f_)
___NEED_SYM(___S_syntax_2d_rules)
___NEED_SYM(___S_system_2d_stamp)
___NEED_SYM(___S_system_2d_type)
___NEED_SYM(___S_system_2d_type_2d_string)
___NEED_SYM(___S_system_2d_version)
___NEED_SYM(___S_system_2d_version_2d_string)
___NEED_SYM(___S_table_2d__3e_list)
___NEED_SYM(___S_table_2d_copy)
___NEED_SYM(___S_table_2d_for_2d_each)
___NEED_SYM(___S_table_2d_length)
___NEED_SYM(___S_table_2d_merge)
___NEED_SYM(___S_table_2d_merge_21_)
___NEED_SYM(___S_table_2d_ref)
___NEED_SYM(___S_table_2d_search)
___NEED_SYM(___S_table_2d_set_21_)
___NEED_SYM(___S_table_3f_)
___NEED_SYM(___S_tan)
___NEED_SYM(___S_tcp_2d_client_2d_peer_2d_socket_2d_info)
___NEED_SYM(___S_tcp_2d_client_2d_self_2d_socket_2d_info)
___NEED_SYM(___S_tcp_2d_server_2d_socket_2d_info)
___NEED_SYM(___S_tcp_2d_service_2d_register_21_)
___NEED_SYM(___S_tcp_2d_service_2d_unregister_21_)
___NEED_SYM(___S_terminated_2d_thread_2d_exception_2d_arguments)
___NEED_SYM(___S_terminated_2d_thread_2d_exception_2d_procedure)
___NEED_SYM(___S_terminated_2d_thread_2d_exception_3f_)
___NEED_SYM(___S_test_2d_bit_2d_field_3f_)
___NEED_SYM(___S_this_2d_source_2d_file)
___NEED_SYM(___S_thread_2d_base_2d_priority)
___NEED_SYM(___S_thread_2d_base_2d_priority_2d_set_21_)
___NEED_SYM(___S_thread_2d_group_2d__3e_thread_2d_group_2d_list)
___NEED_SYM(___S_thread_2d_group_2d__3e_thread_2d_group_2d_vector)
___NEED_SYM(___S_thread_2d_group_2d__3e_thread_2d_list)
___NEED_SYM(___S_thread_2d_group_2d__3e_thread_2d_vector)
___NEED_SYM(___S_thread_2d_group_2d_name)
___NEED_SYM(___S_thread_2d_group_2d_parent)
___NEED_SYM(___S_thread_2d_group_2d_resume_21_)
___NEED_SYM(___S_thread_2d_group_2d_suspend_21_)
___NEED_SYM(___S_thread_2d_group_2d_terminate_21_)
___NEED_SYM(___S_thread_2d_group_3f_)
___NEED_SYM(___S_thread_2d_init_21_)
___NEED_SYM(___S_thread_2d_interrupt_21_)
___NEED_SYM(___S_thread_2d_join_21_)
___NEED_SYM(___S_thread_2d_mailbox_2d_extract_2d_and_2d_rewind)
___NEED_SYM(___S_thread_2d_mailbox_2d_next)
___NEED_SYM(___S_thread_2d_mailbox_2d_rewind)
___NEED_SYM(___S_thread_2d_name)
___NEED_SYM(___S_thread_2d_priority_2d_boost)
___NEED_SYM(___S_thread_2d_priority_2d_boost_2d_set_21_)
___NEED_SYM(___S_thread_2d_quantum)
___NEED_SYM(___S_thread_2d_quantum_2d_set_21_)
___NEED_SYM(___S_thread_2d_receive)
___NEED_SYM(___S_thread_2d_resume_21_)
___NEED_SYM(___S_thread_2d_send)
___NEED_SYM(___S_thread_2d_sleep_21_)
___NEED_SYM(___S_thread_2d_specific)
___NEED_SYM(___S_thread_2d_specific_2d_set_21_)
___NEED_SYM(___S_thread_2d_start_21_)
___NEED_SYM(___S_thread_2d_state)
___NEED_SYM(___S_thread_2d_state_2d_abnormally_2d_terminated_2d_reason)
___NEED_SYM(___S_thread_2d_state_2d_abnormally_2d_terminated_3f_)
___NEED_SYM(___S_thread_2d_state_2d_active_2d_timeout)
___NEED_SYM(___S_thread_2d_state_2d_active_2d_waiting_2d_for)
___NEED_SYM(___S_thread_2d_state_2d_active_3f_)
___NEED_SYM(___S_thread_2d_state_2d_initialized_3f_)
___NEED_SYM(___S_thread_2d_state_2d_normally_2d_terminated_2d_result)
___NEED_SYM(___S_thread_2d_state_2d_normally_2d_terminated_3f_)
___NEED_SYM(___S_thread_2d_state_2d_uninitialized_3f_)
___NEED_SYM(___S_thread_2d_suspend_21_)
___NEED_SYM(___S_thread_2d_terminate_21_)
___NEED_SYM(___S_thread_2d_thread_2d_group)
___NEED_SYM(___S_thread_2d_yield_21_)
___NEED_SYM(___S_thread_3f_)
___NEED_SYM(___S_time)
___NEED_SYM(___S_time_2d__3e_seconds)
___NEED_SYM(___S_time_3f_)
___NEED_SYM(___S_timeout_2d__3e_time)
___NEED_SYM(___S_top)
___NEED_SYM(___S_touch)
___NEED_SYM(___S_trace)
___NEED_SYM(___S_transcript_2d_off)
___NEED_SYM(___S_transcript_2d_on)
___NEED_SYM(___S_truncate)
___NEED_SYM(___S_tty_2d_history)
___NEED_SYM(___S_tty_2d_history_2d_max_2d_length_2d_set_21_)
___NEED_SYM(___S_tty_2d_history_2d_set_21_)
___NEED_SYM(___S_tty_2d_mode_2d_set_21_)
___NEED_SYM(___S_tty_2d_paren_2d_balance_2d_duration_2d_set_21_)
___NEED_SYM(___S_tty_2d_text_2d_attributes_2d_set_21_)
___NEED_SYM(___S_tty_2d_type_2d_set_21_)
___NEED_SYM(___S_tty_3f_)
___NEED_SYM(___S_type_2d_exception_2d_arg_2d_num)
___NEED_SYM(___S_type_2d_exception_2d_arguments)
___NEED_SYM(___S_type_2d_exception_2d_procedure)
___NEED_SYM(___S_type_2d_exception_2d_type_2d_id)
___NEED_SYM(___S_type_2d_exception_3f_)
___NEED_SYM(___S_u16vector)
___NEED_SYM(___S_u16vector_2d__3e_list)
___NEED_SYM(___S_u16vector_2d_append)
___NEED_SYM(___S_u16vector_2d_copy)
___NEED_SYM(___S_u16vector_2d_fill_21_)
___NEED_SYM(___S_u16vector_2d_length)
___NEED_SYM(___S_u16vector_2d_ref)
___NEED_SYM(___S_u16vector_2d_set_21_)
___NEED_SYM(___S_u16vector_2d_shrink_21_)
___NEED_SYM(___S_u16vector_3f_)
___NEED_SYM(___S_u32vector)
___NEED_SYM(___S_u32vector_2d__3e_list)
___NEED_SYM(___S_u32vector_2d_append)
___NEED_SYM(___S_u32vector_2d_copy)
___NEED_SYM(___S_u32vector_2d_fill_21_)
___NEED_SYM(___S_u32vector_2d_length)
___NEED_SYM(___S_u32vector_2d_ref)
___NEED_SYM(___S_u32vector_2d_set_21_)
___NEED_SYM(___S_u32vector_2d_shrink_21_)
___NEED_SYM(___S_u32vector_3f_)
___NEED_SYM(___S_u64vector)
___NEED_SYM(___S_u64vector_2d__3e_list)
___NEED_SYM(___S_u64vector_2d_append)
___NEED_SYM(___S_u64vector_2d_copy)
___NEED_SYM(___S_u64vector_2d_fill_21_)
___NEED_SYM(___S_u64vector_2d_length)
___NEED_SYM(___S_u64vector_2d_ref)
___NEED_SYM(___S_u64vector_2d_set_21_)
___NEED_SYM(___S_u64vector_2d_shrink_21_)
___NEED_SYM(___S_u64vector_3f_)
___NEED_SYM(___S_u8vector)
___NEED_SYM(___S_u8vector_2d__3e_list)
___NEED_SYM(___S_u8vector_2d__3e_object)
___NEED_SYM(___S_u8vector_2d_append)
___NEED_SYM(___S_u8vector_2d_copy)
___NEED_SYM(___S_u8vector_2d_fill_21_)
___NEED_SYM(___S_u8vector_2d_length)
___NEED_SYM(___S_u8vector_2d_ref)
___NEED_SYM(___S_u8vector_2d_set_21_)
___NEED_SYM(___S_u8vector_2d_shrink_21_)
___NEED_SYM(___S_u8vector_3f_)
___NEED_SYM(___S_unbound_2d_global_2d_exception_2d_code)
___NEED_SYM(___S_unbound_2d_global_2d_exception_2d_rte)
___NEED_SYM(___S_unbound_2d_global_2d_exception_2d_variable)
___NEED_SYM(___S_unbound_2d_global_2d_exception_3f_)
___NEED_SYM(___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_2d_arguments)
___NEED_SYM(___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_2d_procedure)
___NEED_SYM(___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_3f_)
___NEED_SYM(___S_unbound_2d_serial_2d_number_2d_exception_2d_arguments)
___NEED_SYM(___S_unbound_2d_serial_2d_number_2d_exception_2d_procedure)
___NEED_SYM(___S_unbound_2d_serial_2d_number_2d_exception_3f_)
___NEED_SYM(___S_unbound_2d_table_2d_key_2d_exception_2d_arguments)
___NEED_SYM(___S_unbound_2d_table_2d_key_2d_exception_2d_procedure)
___NEED_SYM(___S_unbound_2d_table_2d_key_2d_exception_3f_)
___NEED_SYM(___S_unbox)
___NEED_SYM(___S_unbreak)
___NEED_SYM(___S_uncaught_2d_exception_2d_arguments)
___NEED_SYM(___S_uncaught_2d_exception_2d_procedure)
___NEED_SYM(___S_uncaught_2d_exception_2d_reason)
___NEED_SYM(___S_uncaught_2d_exception_3f_)
___NEED_SYM(___S_uninitialized_2d_thread_2d_exception_2d_arguments)
___NEED_SYM(___S_uninitialized_2d_thread_2d_exception_2d_procedure)
___NEED_SYM(___S_uninitialized_2d_thread_2d_exception_3f_)
___NEED_SYM(___S_uninterned_2d_keyword_3f_)
___NEED_SYM(___S_uninterned_2d_symbol_3f_)
___NEED_SYM(___S_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
___NEED_SYM(___S_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
___NEED_SYM(___S_unknown_2d_keyword_2d_argument_2d_exception_3f_)
___NEED_SYM(___S_unterminated_2d_process_2d_exception_2d_arguments)
___NEED_SYM(___S_unterminated_2d_process_2d_exception_2d_procedure)
___NEED_SYM(___S_unterminated_2d_process_2d_exception_3f_)
___NEED_SYM(___S_untrace)
___NEED_SYM(___S_user_2d_info)
___NEED_SYM(___S_user_2d_info_2d_gid)
___NEED_SYM(___S_user_2d_info_2d_home)
___NEED_SYM(___S_user_2d_info_2d_name)
___NEED_SYM(___S_user_2d_info_2d_shell)
___NEED_SYM(___S_user_2d_info_2d_uid)
___NEED_SYM(___S_user_2d_info_3f_)
___NEED_SYM(___S_user_2d_name)
___NEED_SYM(___S_values)
___NEED_SYM(___S_vector)
___NEED_SYM(___S_vector_2d__3e_list)
___NEED_SYM(___S_vector_2d_append)
___NEED_SYM(___S_vector_2d_copy)
___NEED_SYM(___S_vector_2d_fill_21_)
___NEED_SYM(___S_vector_2d_length)
___NEED_SYM(___S_vector_2d_ref)
___NEED_SYM(___S_vector_2d_set_21_)
___NEED_SYM(___S_vector_2d_shrink_21_)
___NEED_SYM(___S_vector_3f_)
___NEED_SYM(___S_void)
___NEED_SYM(___S_will_2d_execute_21_)
___NEED_SYM(___S_will_2d_testator)
___NEED_SYM(___S_will_3f_)
___NEED_SYM(___S_with_2d_exception_2d_catcher)
___NEED_SYM(___S_with_2d_exception_2d_handler)
___NEED_SYM(___S_with_2d_input_2d_from_2d_file)
___NEED_SYM(___S_with_2d_input_2d_from_2d_port)
___NEED_SYM(___S_with_2d_input_2d_from_2d_process)
___NEED_SYM(___S_with_2d_input_2d_from_2d_string)
___NEED_SYM(___S_with_2d_input_2d_from_2d_u8vector)
___NEED_SYM(___S_with_2d_input_2d_from_2d_vector)
___NEED_SYM(___S_with_2d_output_2d_to_2d_file)
___NEED_SYM(___S_with_2d_output_2d_to_2d_port)
___NEED_SYM(___S_with_2d_output_2d_to_2d_process)
___NEED_SYM(___S_with_2d_output_2d_to_2d_string)
___NEED_SYM(___S_with_2d_output_2d_to_2d_u8vector)
___NEED_SYM(___S_with_2d_output_2d_to_2d_vector)
___NEED_SYM(___S_write)
___NEED_SYM(___S_write_2d_char)
___NEED_SYM(___S_write_2d_substring)
___NEED_SYM(___S_write_2d_subu8vector)
___NEED_SYM(___S_write_2d_u8)
___NEED_SYM(___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
___NEED_SYM(___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
___NEED_SYM(___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_)
___NEED_SYM(___S_zero_3f_)

___NEED_GLO(___G__20_help)
___NEED_GLO(___G__23__23_escape_2d_link)
___NEED_GLO(___G__23__23_help_2d_hook)
___NEED_GLO(___G__23__23_object_2d__3e_string)
___NEED_GLO(___G__23__23_procedure_2d_name)
___NEED_GLO(___G_error)
___NEED_GLO(___G_gr_23_show_2d_help_2d_document)
___NEED_GLO(___G_help_23_gambit_2d_c_2d_help_2d_document)
___NEED_GLO(___G_help_23_gambit_2d_repl_2d_help)
___NEED_GLO(___G_help_23_help_2d_names_2d_gambit_2d_c)
___NEED_GLO(___G_help_23_help_2d_names_2d_r5rs)
___NEED_GLO(___G_help_23_main_2d_help_2d_document)
___NEED_GLO(___G_help_23_r5rs_2d_help_2d_document)
___NEED_GLO(___G_path_2d_expand)
___NEED_GLO(___G_string_2d_append)

___BEGIN_SYM
___DEF_SYM(0,___S__2a_,"*")
___DEF_SYM(1,___S__2b_,"+")
___DEF_SYM(2,___S__2d_,"-")
___DEF_SYM(3,___S__2f_,"/")
___DEF_SYM(4,___S__3c_,"<")
___DEF_SYM(5,___S__3c__3d_,"<=")
___DEF_SYM(6,___S__3d_,"=")
___DEF_SYM(7,___S__3e_,">")
___DEF_SYM(8,___S__3e__3d_,">=")
___DEF_SYM(9,___S_abandoned_2d_mutex_2d_exception_3f_,"abandoned-mutex-exception?")
___DEF_SYM(10,___S_abort,"abort")
___DEF_SYM(11,___S_abs,"abs")
___DEF_SYM(12,___S_acos,"acos")
___DEF_SYM(13,___S_address_2d_info_2d_family,"address-info-family")
___DEF_SYM(14,___S_address_2d_info_2d_protocol,"address-info-protocol")
___DEF_SYM(15,___S_address_2d_info_2d_socket_2d_info,"address-info-socket-info")
___DEF_SYM(16,___S_address_2d_info_2d_socket_2d_type,"address-info-socket-type")
___DEF_SYM(17,___S_address_2d_info_3f_,"address-info?")
___DEF_SYM(18,___S_address_2d_infos,"address-infos")
___DEF_SYM(19,___S_all_2d_bits_2d_set_3f_,"all-bits-set?")
___DEF_SYM(20,___S_and,"and")
___DEF_SYM(21,___S_angle,"angle")
___DEF_SYM(22,___S_any_2d_bits_2d_set_3f_,"any-bits-set?")
___DEF_SYM(23,___S_append,"append")
___DEF_SYM(24,___S_append_2d_f32vectors,"append-f32vectors")
___DEF_SYM(25,___S_append_2d_f64vectors,"append-f64vectors")
___DEF_SYM(26,___S_append_2d_s16vectors,"append-s16vectors")
___DEF_SYM(27,___S_append_2d_s32vectors,"append-s32vectors")
___DEF_SYM(28,___S_append_2d_s64vectors,"append-s64vectors")
___DEF_SYM(29,___S_append_2d_s8vectors,"append-s8vectors")
___DEF_SYM(30,___S_append_2d_strings,"append-strings")
___DEF_SYM(31,___S_append_2d_u16vectors,"append-u16vectors")
___DEF_SYM(32,___S_append_2d_u32vectors,"append-u32vectors")
___DEF_SYM(33,___S_append_2d_u64vectors,"append-u64vectors")
___DEF_SYM(34,___S_append_2d_u8vectors,"append-u8vectors")
___DEF_SYM(35,___S_append_2d_vectors,"append-vectors")
___DEF_SYM(36,___S_apply,"apply")
___DEF_SYM(37,___S_arithmetic_2d_shift,"arithmetic-shift")
___DEF_SYM(38,___S_asin,"asin")
___DEF_SYM(39,___S_assoc,"assoc")
___DEF_SYM(40,___S_assq,"assq")
___DEF_SYM(41,___S_assv,"assv")
___DEF_SYM(42,___S_atan,"atan")
___DEF_SYM(43,___S_begin,"begin")
___DEF_SYM(44,___S_bit_2d_count,"bit-count")
___DEF_SYM(45,___S_bit_2d_set_3f_,"bit-set?")
___DEF_SYM(46,___S_bitwise_2d_and,"bitwise-and")
___DEF_SYM(47,___S_bitwise_2d_ior,"bitwise-ior")
___DEF_SYM(48,___S_bitwise_2d_merge,"bitwise-merge")
___DEF_SYM(49,___S_bitwise_2d_not,"bitwise-not")
___DEF_SYM(50,___S_bitwise_2d_xor,"bitwise-xor")
___DEF_SYM(51,___S_boolean_3f_,"boolean?")
___DEF_SYM(52,___S_box,"box")
___DEF_SYM(53,___S_box_3f_,"box?")
___DEF_SYM(54,___S_break,"break")
___DEF_SYM(55,___S_c_2d_declare,"c-declare")
___DEF_SYM(56,___S_c_2d_define,"c-define")
___DEF_SYM(57,___S_c_2d_define_2d_type,"c-define-type")
___DEF_SYM(58,___S_c_2d_initialize,"c-initialize")
___DEF_SYM(59,___S_c_2d_lambda,"c-lambda")
___DEF_SYM(60,___S_caar,"caar")
___DEF_SYM(61,___S_cadr,"cadr")
___DEF_SYM(62,___S_call_2d_with_2d_current_2d_continuation,"call-with-current-continuation")

___DEF_SYM(63,___S_call_2d_with_2d_input_2d_file,"call-with-input-file")
___DEF_SYM(64,___S_call_2d_with_2d_input_2d_process,"call-with-input-process")
___DEF_SYM(65,___S_call_2d_with_2d_input_2d_string,"call-with-input-string")
___DEF_SYM(66,___S_call_2d_with_2d_input_2d_u8vector,"call-with-input-u8vector")
___DEF_SYM(67,___S_call_2d_with_2d_input_2d_vector,"call-with-input-vector")
___DEF_SYM(68,___S_call_2d_with_2d_output_2d_file,"call-with-output-file")
___DEF_SYM(69,___S_call_2d_with_2d_output_2d_process,"call-with-output-process")
___DEF_SYM(70,___S_call_2d_with_2d_output_2d_string,"call-with-output-string")
___DEF_SYM(71,___S_call_2d_with_2d_output_2d_u8vector,"call-with-output-u8vector")
___DEF_SYM(72,___S_call_2d_with_2d_output_2d_vector,"call-with-output-vector")
___DEF_SYM(73,___S_call_2d_with_2d_values,"call-with-values")
___DEF_SYM(74,___S_call_2f_cc,"call/cc")
___DEF_SYM(75,___S_car,"car")
___DEF_SYM(76,___S_case,"case")
___DEF_SYM(77,___S_cdddar,"cdddar")
___DEF_SYM(78,___S_cddddr,"cddddr")
___DEF_SYM(79,___S_cdr,"cdr")
___DEF_SYM(80,___S_ceiling,"ceiling")
___DEF_SYM(81,___S_cfun_2d_conversion_2d_exception_2d_arguments,"cfun-conversion-exception-arguments")

___DEF_SYM(82,___S_cfun_2d_conversion_2d_exception_2d_code,"cfun-conversion-exception-code")

___DEF_SYM(83,___S_cfun_2d_conversion_2d_exception_2d_message,"cfun-conversion-exception-message")

___DEF_SYM(84,___S_cfun_2d_conversion_2d_exception_2d_procedure,"cfun-conversion-exception-procedure")

___DEF_SYM(85,___S_cfun_2d_conversion_2d_exception_3f_,"cfun-conversion-exception?")
___DEF_SYM(86,___S_char_2d__3e_integer,"char->integer")
___DEF_SYM(87,___S_char_2d_alphabetic_3f_,"char-alphabetic?")
___DEF_SYM(88,___S_char_2d_ci_3c__3d__3f_,"char-ci<=?")
___DEF_SYM(89,___S_char_2d_ci_3c__3f_,"char-ci<?")
___DEF_SYM(90,___S_char_2d_ci_3d__3f_,"char-ci=?")
___DEF_SYM(91,___S_char_2d_ci_3e__3d__3f_,"char-ci>=?")
___DEF_SYM(92,___S_char_2d_ci_3e__3f_,"char-ci>?")
___DEF_SYM(93,___S_char_2d_downcase,"char-downcase")
___DEF_SYM(94,___S_char_2d_lower_2d_case_3f_,"char-lower-case?")
___DEF_SYM(95,___S_char_2d_numeric_3f_,"char-numeric?")
___DEF_SYM(96,___S_char_2d_ready_3f_,"char-ready?")
___DEF_SYM(97,___S_char_2d_upcase,"char-upcase")
___DEF_SYM(98,___S_char_2d_upper_2d_case_3f_,"char-upper-case?")
___DEF_SYM(99,___S_char_2d_whitespace_3f_,"char-whitespace?")
___DEF_SYM(100,___S_char_3c__3d__3f_,"char<=?")
___DEF_SYM(101,___S_char_3c__3f_,"char<?")
___DEF_SYM(102,___S_char_3d__3f_,"char=?")
___DEF_SYM(103,___S_char_3e__3d__3f_,"char>=?")
___DEF_SYM(104,___S_char_3e__3f_,"char>?")
___DEF_SYM(105,___S_char_3f_,"char?")
___DEF_SYM(106,___S_clear_2d_bit_2d_field,"clear-bit-field")
___DEF_SYM(107,___S_close_2d_input_2d_port,"close-input-port")
___DEF_SYM(108,___S_close_2d_output_2d_port,"close-output-port")
___DEF_SYM(109,___S_close_2d_port,"close-port")
___DEF_SYM(110,___S_command_2d_line,"command-line")
___DEF_SYM(111,___S_compile_2d_file,"compile-file")
___DEF_SYM(112,___S_compile_2d_file_2d_to_2d_c,"compile-file-to-c")
___DEF_SYM(113,___S_complex_3f_,"complex?")
___DEF_SYM(114,___S_cond,"cond")
___DEF_SYM(115,___S_cond_2d_expand,"cond-expand")
___DEF_SYM(116,___S_condition_2d_variable_2d_broadcast_21_,"condition-variable-broadcast!")

___DEF_SYM(117,___S_condition_2d_variable_2d_name,"condition-variable-name")
___DEF_SYM(118,___S_condition_2d_variable_2d_signal_21_,"condition-variable-signal!")
___DEF_SYM(119,___S_condition_2d_variable_2d_specific,"condition-variable-specific")
___DEF_SYM(120,___S_condition_2d_variable_2d_specific_2d_set_21_,"condition-variable-specific-set!")

___DEF_SYM(121,___S_condition_2d_variable_3f_,"condition-variable?")
___DEF_SYM(122,___S_configure_2d_command_2d_string,"configure-command-string")
___DEF_SYM(123,___S_cons,"cons")
___DEF_SYM(124,___S_console_2d_port,"console-port")
___DEF_SYM(125,___S_continuation_2d_capture,"continuation-capture")
___DEF_SYM(126,___S_continuation_2d_graft,"continuation-graft")
___DEF_SYM(127,___S_continuation_2d_return,"continuation-return")
___DEF_SYM(128,___S_continuation_3f_,"continuation?")
___DEF_SYM(129,___S_copy_2d_bit_2d_field,"copy-bit-field")
___DEF_SYM(130,___S_copy_2d_file,"copy-file")
___DEF_SYM(131,___S_cos,"cos")
___DEF_SYM(132,___S_cpu_2d_time,"cpu-time")
___DEF_SYM(133,___S_create_2d_directory,"create-directory")
___DEF_SYM(134,___S_create_2d_fifo,"create-fifo")
___DEF_SYM(135,___S_create_2d_link,"create-link")
___DEF_SYM(136,___S_create_2d_symbolic_2d_link,"create-symbolic-link")
___DEF_SYM(137,___S_current_2d_directory,"current-directory")
___DEF_SYM(138,___S_current_2d_error_2d_port,"current-error-port")
___DEF_SYM(139,___S_current_2d_exception_2d_handler,"current-exception-handler")
___DEF_SYM(140,___S_current_2d_input_2d_port,"current-input-port")
___DEF_SYM(141,___S_current_2d_output_2d_port,"current-output-port")
___DEF_SYM(142,___S_current_2d_readtable,"current-readtable")
___DEF_SYM(143,___S_current_2d_thread,"current-thread")
___DEF_SYM(144,___S_current_2d_time,"current-time")
___DEF_SYM(145,___S_current_2d_user_2d_interrupt_2d_handler,"current-user-interrupt-handler")

___DEF_SYM(146,___S_datum_2d_parsing_2d_exception_2d_kind,"datum-parsing-exception-kind")
___DEF_SYM(147,___S_datum_2d_parsing_2d_exception_2d_parameters,"datum-parsing-exception-parameters")

___DEF_SYM(148,___S_datum_2d_parsing_2d_exception_2d_readenv,"datum-parsing-exception-readenv")

___DEF_SYM(149,___S_datum_2d_parsing_2d_exception_3f_,"datum-parsing-exception?")
___DEF_SYM(150,___S_deadlock_2d_exception_3f_,"deadlock-exception?")
___DEF_SYM(151,___S_declare,"declare")
___DEF_SYM(152,___S_default_2d_random_2d_source,"default-random-source")
___DEF_SYM(153,___S_defer_2d_user_2d_interrupts,"defer-user-interrupts")
___DEF_SYM(154,___S_define,"define")
___DEF_SYM(155,___S_define_2d_cond_2d_expand_2d_feature,"define-cond-expand-feature")
___DEF_SYM(156,___S_define_2d_macro,"define-macro")
___DEF_SYM(157,___S_define_2d_record_2d_type,"define-record-type")
___DEF_SYM(158,___S_define_2d_structure,"define-structure")
___DEF_SYM(159,___S_define_2d_syntax,"define-syntax")
___DEF_SYM(160,___S_define_2d_type,"define-type")
___DEF_SYM(161,___S_define_2d_type_2d_of_2d_thread,"define-type-of-thread")
___DEF_SYM(162,___S_delay,"delay")
___DEF_SYM(163,___S_delete_2d_directory,"delete-directory")
___DEF_SYM(164,___S_delete_2d_file,"delete-file")
___DEF_SYM(165,___S_denominator,"denominator")
___DEF_SYM(166,___S_directory_2d_files,"directory-files")
___DEF_SYM(167,___S_display,"display")
___DEF_SYM(168,___S_display_2d_continuation_2d_backtrace,"display-continuation-backtrace")

___DEF_SYM(169,___S_display_2d_continuation_2d_dynamic_2d_environment,"display-continuation-dynamic-environment")

___DEF_SYM(170,___S_display_2d_continuation_2d_environment,"display-continuation-environment")

___DEF_SYM(171,___S_display_2d_dynamic_2d_environment_3f_,"display-dynamic-environment?")
___DEF_SYM(172,___S_display_2d_environment_2d_set_21_,"display-environment-set!")
___DEF_SYM(173,___S_display_2d_exception,"display-exception")
___DEF_SYM(174,___S_display_2d_exception_2d_in_2d_context,"display-exception-in-context")
___DEF_SYM(175,___S_display_2d_procedure_2d_environment,"display-procedure-environment")

___DEF_SYM(176,___S_divide_2d_by_2d_zero_2d_exception_2d_arguments,"divide-by-zero-exception-arguments")

___DEF_SYM(177,___S_divide_2d_by_2d_zero_2d_exception_2d_procedure,"divide-by-zero-exception-procedure")

___DEF_SYM(178,___S_divide_2d_by_2d_zero_2d_exception_3f_,"divide-by-zero-exception?")
___DEF_SYM(179,___S_do,"do")
___DEF_SYM(180,___S_dynamic_2d_wind,"dynamic-wind")
___DEF_SYM(181,___S_eof_2d_object_3f_,"eof-object?")
___DEF_SYM(182,___S_eq_3f_,"eq?")
___DEF_SYM(183,___S_eq_3f__2d_hash,"eq?-hash")
___DEF_SYM(184,___S_equal_3f_,"equal?")
___DEF_SYM(185,___S_equal_3f__2d_hash,"equal?-hash")
___DEF_SYM(186,___S_eqv_3f_,"eqv?")
___DEF_SYM(187,___S_eqv_3f__2d_hash,"eqv?-hash")
___DEF_SYM(188,___S_err_2d_code_2d__3e_string,"err-code->string")
___DEF_SYM(189,___S_error,"error")
___DEF_SYM(190,___S_error_2d_exception_2d_message,"error-exception-message")
___DEF_SYM(191,___S_error_2d_exception_2d_parameters,"error-exception-parameters")
___DEF_SYM(192,___S_error_2d_exception_3f_,"error-exception?")
___DEF_SYM(193,___S_eval,"eval")
___DEF_SYM(194,___S_even_3f_,"even?")
___DEF_SYM(195,___S_exact_2d__3e_inexact,"exact->inexact")
___DEF_SYM(196,___S_exact_3f_,"exact?")
___DEF_SYM(197,___S_exit,"exit")
___DEF_SYM(198,___S_exp,"exp")
___DEF_SYM(199,___S_expression_2d_parsing_2d_exception_2d_kind,"expression-parsing-exception-kind")

___DEF_SYM(200,___S_expression_2d_parsing_2d_exception_2d_parameters,"expression-parsing-exception-parameters")

___DEF_SYM(201,___S_expression_2d_parsing_2d_exception_2d_source,"expression-parsing-exception-source")

___DEF_SYM(202,___S_expression_2d_parsing_2d_exception_3f_,"expression-parsing-exception?")

___DEF_SYM(203,___S_expt,"expt")
___DEF_SYM(204,___S_extract_2d_bit_2d_field,"extract-bit-field")
___DEF_SYM(205,___S_f32vector,"f32vector")
___DEF_SYM(206,___S_f32vector_2d__3e_list,"f32vector->list")
___DEF_SYM(207,___S_f32vector_2d_append,"f32vector-append")
___DEF_SYM(208,___S_f32vector_2d_copy,"f32vector-copy")
___DEF_SYM(209,___S_f32vector_2d_fill_21_,"f32vector-fill!")
___DEF_SYM(210,___S_f32vector_2d_length,"f32vector-length")
___DEF_SYM(211,___S_f32vector_2d_ref,"f32vector-ref")
___DEF_SYM(212,___S_f32vector_2d_set_21_,"f32vector-set!")
___DEF_SYM(213,___S_f32vector_2d_shrink_21_,"f32vector-shrink!")
___DEF_SYM(214,___S_f32vector_3f_,"f32vector?")
___DEF_SYM(215,___S_f64vector,"f64vector")
___DEF_SYM(216,___S_f64vector_2d__3e_list,"f64vector->list")
___DEF_SYM(217,___S_f64vector_2d_append,"f64vector-append")
___DEF_SYM(218,___S_f64vector_2d_copy,"f64vector-copy")
___DEF_SYM(219,___S_f64vector_2d_fill_21_,"f64vector-fill!")
___DEF_SYM(220,___S_f64vector_2d_length,"f64vector-length")
___DEF_SYM(221,___S_f64vector_2d_ref,"f64vector-ref")
___DEF_SYM(222,___S_f64vector_2d_set_21_,"f64vector-set!")
___DEF_SYM(223,___S_f64vector_2d_shrink_21_,"f64vector-shrink!")
___DEF_SYM(224,___S_f64vector_3f_,"f64vector?")
___DEF_SYM(225,___S_file_2d_attributes,"file-attributes")
___DEF_SYM(226,___S_file_2d_creation_2d_time,"file-creation-time")
___DEF_SYM(227,___S_file_2d_device,"file-device")
___DEF_SYM(228,___S_file_2d_exists_3f_,"file-exists?")
___DEF_SYM(229,___S_file_2d_group,"file-group")
___DEF_SYM(230,___S_file_2d_info,"file-info")
___DEF_SYM(231,___S_file_2d_info_2d_attributes,"file-info-attributes")
___DEF_SYM(232,___S_file_2d_info_2d_creation_2d_time,"file-info-creation-time")
___DEF_SYM(233,___S_file_2d_info_2d_device,"file-info-device")
___DEF_SYM(234,___S_file_2d_info_2d_group,"file-info-group")
___DEF_SYM(235,___S_file_2d_info_2d_inode,"file-info-inode")
___DEF_SYM(236,___S_file_2d_info_2d_last_2d_access_2d_time,"file-info-last-access-time")
___DEF_SYM(237,___S_file_2d_info_2d_last_2d_change_2d_time,"file-info-last-change-time")
___DEF_SYM(238,___S_file_2d_info_2d_last_2d_modification_2d_time,"file-info-last-modification-time")

___DEF_SYM(239,___S_file_2d_info_2d_mode,"file-info-mode")
___DEF_SYM(240,___S_file_2d_info_2d_number_2d_of_2d_links,"file-info-number-of-links")
___DEF_SYM(241,___S_file_2d_info_2d_owner,"file-info-owner")
___DEF_SYM(242,___S_file_2d_info_2d_size,"file-info-size")
___DEF_SYM(243,___S_file_2d_info_2d_type,"file-info-type")
___DEF_SYM(244,___S_file_2d_info_3f_,"file-info?")
___DEF_SYM(245,___S_file_2d_inode,"file-inode")
___DEF_SYM(246,___S_file_2d_last_2d_access_2d_time,"file-last-access-time")
___DEF_SYM(247,___S_file_2d_last_2d_change_2d_time,"file-last-change-time")
___DEF_SYM(248,___S_file_2d_last_2d_modification_2d_time,"file-last-modification-time")
___DEF_SYM(249,___S_file_2d_mode,"file-mode")
___DEF_SYM(250,___S_file_2d_number_2d_of_2d_links,"file-number-of-links")
___DEF_SYM(251,___S_file_2d_owner,"file-owner")
___DEF_SYM(252,___S_file_2d_size,"file-size")
___DEF_SYM(253,___S_file_2d_type,"file-type")
___DEF_SYM(254,___S_finite_3f_,"finite?")
___DEF_SYM(255,___S_first_2d_bit_2d_set,"first-bit-set")
___DEF_SYM(256,___S_fixnum_2d__3e_flonum,"fixnum->flonum")
___DEF_SYM(257,___S_fixnum_2d_overflow_2d_exception_2d_arguments,"fixnum-overflow-exception-arguments")

___DEF_SYM(258,___S_fixnum_2d_overflow_2d_exception_2d_procedure,"fixnum-overflow-exception-procedure")

___DEF_SYM(259,___S_fixnum_2d_overflow_2d_exception_3f_,"fixnum-overflow-exception?")
___DEF_SYM(260,___S_fixnum_3f_,"fixnum?")
___DEF_SYM(261,___S_fl_2a_,"fl*")
___DEF_SYM(262,___S_fl_2b_,"fl+")
___DEF_SYM(263,___S_fl_2d_,"fl-")
___DEF_SYM(264,___S_fl_2f_,"fl/")
___DEF_SYM(265,___S_fl_3c_,"fl<")
___DEF_SYM(266,___S_fl_3c__3d_,"fl<=")
___DEF_SYM(267,___S_fl_3d_,"fl=")
___DEF_SYM(268,___S_fl_3e_,"fl>")
___DEF_SYM(269,___S_fl_3e__3d_,"fl>=")
___DEF_SYM(270,___S_flabs,"flabs")
___DEF_SYM(271,___S_flacos,"flacos")
___DEF_SYM(272,___S_flasin,"flasin")
___DEF_SYM(273,___S_flatan,"flatan")
___DEF_SYM(274,___S_flceiling,"flceiling")
___DEF_SYM(275,___S_flcos,"flcos")
___DEF_SYM(276,___S_fldenominator,"fldenominator")
___DEF_SYM(277,___S_fleven_3f_,"fleven?")
___DEF_SYM(278,___S_flexp,"flexp")
___DEF_SYM(279,___S_flexpt,"flexpt")
___DEF_SYM(280,___S_flfinite_3f_,"flfinite?")
___DEF_SYM(281,___S_flfloor,"flfloor")
___DEF_SYM(282,___S_flinfinite_3f_,"flinfinite?")
___DEF_SYM(283,___S_flinteger_3f_,"flinteger?")
___DEF_SYM(284,___S_fllog,"fllog")
___DEF_SYM(285,___S_flmax,"flmax")
___DEF_SYM(286,___S_flmin,"flmin")
___DEF_SYM(287,___S_flnan_3f_,"flnan?")
___DEF_SYM(288,___S_flnegative_3f_,"flnegative?")
___DEF_SYM(289,___S_flnumerator,"flnumerator")
___DEF_SYM(290,___S_flodd_3f_,"flodd?")
___DEF_SYM(291,___S_flonum_3f_,"flonum?")
___DEF_SYM(292,___S_floor,"floor")
___DEF_SYM(293,___S_flpositive_3f_,"flpositive?")
___DEF_SYM(294,___S_flround,"flround")
___DEF_SYM(295,___S_flsin,"flsin")
___DEF_SYM(296,___S_flsqrt,"flsqrt")
___DEF_SYM(297,___S_fltan,"fltan")
___DEF_SYM(298,___S_fltruncate,"fltruncate")
___DEF_SYM(299,___S_flzero_3f_,"flzero?")
___DEF_SYM(300,___S_for_2d_each,"for-each")
___DEF_SYM(301,___S_force,"force")
___DEF_SYM(302,___S_force_2d_output,"force-output")
___DEF_SYM(303,___S_foreign_2d_address,"foreign-address")
___DEF_SYM(304,___S_foreign_2d_release_21_,"foreign-release!")
___DEF_SYM(305,___S_foreign_2d_released_3f_,"foreign-released?")
___DEF_SYM(306,___S_foreign_2d_tags,"foreign-tags")
___DEF_SYM(307,___S_foreign_3f_,"foreign?")
___DEF_SYM(308,___S_future,"future")
___DEF_SYM(309,___S_fx_2a_,"fx*")
___DEF_SYM(310,___S_fx_2b_,"fx+")
___DEF_SYM(311,___S_fx_2d_,"fx-")
___DEF_SYM(312,___S_fx_3c_,"fx<")
___DEF_SYM(313,___S_fx_3c__3d_,"fx<=")
___DEF_SYM(314,___S_fx_3d_,"fx=")
___DEF_SYM(315,___S_fx_3e_,"fx>")
___DEF_SYM(316,___S_fx_3e__3d_,"fx>=")
___DEF_SYM(317,___S_fxabs,"fxabs")
___DEF_SYM(318,___S_fxand,"fxand")
___DEF_SYM(319,___S_fxarithmetic_2d_shift,"fxarithmetic-shift")
___DEF_SYM(320,___S_fxarithmetic_2d_shift_2d_left,"fxarithmetic-shift-left")
___DEF_SYM(321,___S_fxarithmetic_2d_shift_2d_right,"fxarithmetic-shift-right")
___DEF_SYM(322,___S_fxbit_2d_count,"fxbit-count")
___DEF_SYM(323,___S_fxbit_2d_set_3f_,"fxbit-set?")
___DEF_SYM(324,___S_fxeven_3f_,"fxeven?")
___DEF_SYM(325,___S_fxfirst_2d_bit_2d_set,"fxfirst-bit-set")
___DEF_SYM(326,___S_fxif,"fxif")
___DEF_SYM(327,___S_fxior,"fxior")
___DEF_SYM(328,___S_fxlength,"fxlength")
___DEF_SYM(329,___S_fxmax,"fxmax")
___DEF_SYM(330,___S_fxmin,"fxmin")
___DEF_SYM(331,___S_fxmodulo,"fxmodulo")
___DEF_SYM(332,___S_fxnegative_3f_,"fxnegative?")
___DEF_SYM(333,___S_fxnot,"fxnot")
___DEF_SYM(334,___S_fxodd_3f_,"fxodd?")
___DEF_SYM(335,___S_fxpositive_3f_,"fxpositive?")
___DEF_SYM(336,___S_fxquotient,"fxquotient")
___DEF_SYM(337,___S_fxremainder,"fxremainder")
___DEF_SYM(338,___S_fxwrap_2a_,"fxwrap*")
___DEF_SYM(339,___S_fxwrap_2b_,"fxwrap+")
___DEF_SYM(340,___S_fxwrap_2d_,"fxwrap-")
___DEF_SYM(341,___S_fxwrapabs,"fxwrapabs")
___DEF_SYM(342,___S_fxwraparithmetic_2d_shift,"fxwraparithmetic-shift")
___DEF_SYM(343,___S_fxwraparithmetic_2d_shift_2d_left,"fxwraparithmetic-shift-left")
___DEF_SYM(344,___S_fxwraplogical_2d_shift_2d_right,"fxwraplogical-shift-right")
___DEF_SYM(345,___S_fxwrapquotient,"fxwrapquotient")
___DEF_SYM(346,___S_fxxor,"fxxor")
___DEF_SYM(347,___S_fxzero_3f_,"fxzero?")
___DEF_SYM(348,___S_gc_2d_report_2d_set_21_,"gc-report-set!")
___DEF_SYM(349,___S_gcd,"gcd")
___DEF_SYM(350,___S_generate_2d_proper_2d_tail_2d_calls,"generate-proper-tail-calls")
___DEF_SYM(351,___S_gensym,"gensym")
___DEF_SYM(352,___S_get_2d_output_2d_string,"get-output-string")
___DEF_SYM(353,___S_get_2d_output_2d_u8vector,"get-output-u8vector")
___DEF_SYM(354,___S_get_2d_output_2d_vector,"get-output-vector")
___DEF_SYM(355,___S_getenv,"getenv")
___DEF_SYM(356,___S_group_2d_info,"group-info")
___DEF_SYM(357,___S_group_2d_info_2d_gid,"group-info-gid")
___DEF_SYM(358,___S_group_2d_info_2d_members,"group-info-members")
___DEF_SYM(359,___S_group_2d_info_2d_name,"group-info-name")
___DEF_SYM(360,___S_group_2d_info_3f_,"group-info?")
___DEF_SYM(361,___S_heap_2d_overflow_2d_exception_3f_,"heap-overflow-exception?")
___DEF_SYM(362,___S_help,"help")
___DEF_SYM(363,___S_help_2d_browser,"help-browser")
___DEF_SYM(364,___S_host_2d_info,"host-info")
___DEF_SYM(365,___S_host_2d_info_2d_addresses,"host-info-addresses")
___DEF_SYM(366,___S_host_2d_info_2d_aliases,"host-info-aliases")
___DEF_SYM(367,___S_host_2d_info_2d_name,"host-info-name")
___DEF_SYM(368,___S_host_2d_info_3f_,"host-info?")
___DEF_SYM(369,___S_host_2d_name,"host-name")
___DEF_SYM(370,___S_if,"if")
___DEF_SYM(371,___S_imag_2d_part,"imag-part")
___DEF_SYM(372,___S_improper_2d_length_2d_list_2d_exception_2d_arg_2d_num,"improper-length-list-exception-arg-num")

___DEF_SYM(373,___S_improper_2d_length_2d_list_2d_exception_2d_arguments,"improper-length-list-exception-arguments")

___DEF_SYM(374,___S_improper_2d_length_2d_list_2d_exception_2d_procedure,"improper-length-list-exception-procedure")

___DEF_SYM(375,___S_improper_2d_length_2d_list_2d_exception_3f_,"improper-length-list-exception?")

___DEF_SYM(376,___S_inactive_2d_thread_2d_exception_2d_arguments,"inactive-thread-exception-arguments")

___DEF_SYM(377,___S_inactive_2d_thread_2d_exception_2d_procedure,"inactive-thread-exception-procedure")

___DEF_SYM(378,___S_inactive_2d_thread_2d_exception_3f_,"inactive-thread-exception?")
___DEF_SYM(379,___S_include,"include")
___DEF_SYM(380,___S_inexact_2d__3e_exact,"inexact->exact")
___DEF_SYM(381,___S_inexact_3f_,"inexact?")
___DEF_SYM(382,___S_infinite_3f_,"infinite?")
___DEF_SYM(383,___S_initialized_2d_thread_2d_exception_2d_arguments,"initialized-thread-exception-arguments")

___DEF_SYM(384,___S_initialized_2d_thread_2d_exception_2d_procedure,"initialized-thread-exception-procedure")

___DEF_SYM(385,___S_initialized_2d_thread_2d_exception_3f_,"initialized-thread-exception?")

___DEF_SYM(386,___S_input_2d_port_2d_byte_2d_position,"input-port-byte-position")
___DEF_SYM(387,___S_input_2d_port_2d_bytes_2d_buffered,"input-port-bytes-buffered")
___DEF_SYM(388,___S_input_2d_port_2d_char_2d_position,"input-port-char-position")
___DEF_SYM(389,___S_input_2d_port_2d_characters_2d_buffered,"input-port-characters-buffered")

___DEF_SYM(390,___S_input_2d_port_2d_column,"input-port-column")
___DEF_SYM(391,___S_input_2d_port_2d_line,"input-port-line")
___DEF_SYM(392,___S_input_2d_port_2d_readtable,"input-port-readtable")
___DEF_SYM(393,___S_input_2d_port_2d_readtable_2d_set_21_,"input-port-readtable-set!")
___DEF_SYM(394,___S_input_2d_port_2d_timeout_2d_set_21_,"input-port-timeout-set!")
___DEF_SYM(395,___S_input_2d_port_3f_,"input-port?")
___DEF_SYM(396,___S_integer_2d__3e_char,"integer->char")
___DEF_SYM(397,___S_integer_2d_length,"integer-length")
___DEF_SYM(398,___S_integer_2d_nth_2d_root,"integer-nth-root")
___DEF_SYM(399,___S_integer_2d_sqrt,"integer-sqrt")
___DEF_SYM(400,___S_integer_3f_,"integer?")
___DEF_SYM(401,___S_interaction_2d_environment,"interaction-environment")
___DEF_SYM(402,___S_invalid_2d_hash_2d_number_2d_exception_2d_arguments,"invalid-hash-number-exception-arguments")

___DEF_SYM(403,___S_invalid_2d_hash_2d_number_2d_exception_2d_procedure,"invalid-hash-number-exception-procedure")

___DEF_SYM(404,___S_invalid_2d_hash_2d_number_2d_exception_3f_,"invalid-hash-number-exception?")

___DEF_SYM(405,___S_join_2d_timeout_2d_exception_2d_arguments,"join-timeout-exception-arguments")

___DEF_SYM(406,___S_join_2d_timeout_2d_exception_2d_procedure,"join-timeout-exception-procedure")

___DEF_SYM(407,___S_join_2d_timeout_2d_exception_3f_,"join-timeout-exception?")
___DEF_SYM(408,___S_keyword_2d__3e_string,"keyword->string")
___DEF_SYM(409,___S_keyword_2d_expected_2d_exception_2d_arguments,"keyword-expected-exception-arguments")

___DEF_SYM(410,___S_keyword_2d_expected_2d_exception_2d_procedure,"keyword-expected-exception-procedure")

___DEF_SYM(411,___S_keyword_2d_expected_2d_exception_3f_,"keyword-expected-exception?")
___DEF_SYM(412,___S_keyword_2d_hash,"keyword-hash")
___DEF_SYM(413,___S_keyword_3f_,"keyword?")
___DEF_SYM(414,___S_lambda,"lambda")
___DEF_SYM(415,___S_lcm,"lcm")
___DEF_SYM(416,___S_length,"length")
___DEF_SYM(417,___S_let,"let")
___DEF_SYM(418,___S_let_2a_,"let*")
___DEF_SYM(419,___S_let_2d_syntax,"let-syntax")
___DEF_SYM(420,___S_letrec,"letrec")
___DEF_SYM(421,___S_letrec_2d_syntax,"letrec-syntax")
___DEF_SYM(422,___S_link_2d_flat,"link-flat")
___DEF_SYM(423,___S_link_2d_incremental,"link-incremental")
___DEF_SYM(424,___S_list,"list")
___DEF_SYM(425,___S_list_2d__3e_f32vector,"list->f32vector")
___DEF_SYM(426,___S_list_2d__3e_f64vector,"list->f64vector")
___DEF_SYM(427,___S_list_2d__3e_s16vector,"list->s16vector")
___DEF_SYM(428,___S_list_2d__3e_s32vector,"list->s32vector")
___DEF_SYM(429,___S_list_2d__3e_s64vector,"list->s64vector")
___DEF_SYM(430,___S_list_2d__3e_s8vector,"list->s8vector")
___DEF_SYM(431,___S_list_2d__3e_string,"list->string")
___DEF_SYM(432,___S_list_2d__3e_table,"list->table")
___DEF_SYM(433,___S_list_2d__3e_u16vector,"list->u16vector")
___DEF_SYM(434,___S_list_2d__3e_u32vector,"list->u32vector")
___DEF_SYM(435,___S_list_2d__3e_u64vector,"list->u64vector")
___DEF_SYM(436,___S_list_2d__3e_u8vector,"list->u8vector")
___DEF_SYM(437,___S_list_2d__3e_vector,"list->vector")
___DEF_SYM(438,___S_list_2d_ref,"list-ref")
___DEF_SYM(439,___S_list_2d_tail,"list-tail")
___DEF_SYM(440,___S_list_3f_,"list?")
___DEF_SYM(441,___S_load,"load")
___DEF_SYM(442,___S_log,"log")
___DEF_SYM(443,___S_magnitude,"magnitude")
___DEF_SYM(444,___S_mailbox_2d_receive_2d_timeout_2d_exception_2d_arguments,"mailbox-receive-timeout-exception-arguments")

___DEF_SYM(445,___S_mailbox_2d_receive_2d_timeout_2d_exception_2d_procedure,"mailbox-receive-timeout-exception-procedure")

___DEF_SYM(446,___S_mailbox_2d_receive_2d_timeout_2d_exception_3f_,"mailbox-receive-timeout-exception?")

___DEF_SYM(447,___S_main,"main")
___DEF_SYM(448,___S_make_2d_condition_2d_variable,"make-condition-variable")
___DEF_SYM(449,___S_make_2d_f32vector,"make-f32vector")
___DEF_SYM(450,___S_make_2d_f64vector,"make-f64vector")
___DEF_SYM(451,___S_make_2d_mutex,"make-mutex")
___DEF_SYM(452,___S_make_2d_parameter,"make-parameter")
___DEF_SYM(453,___S_make_2d_polar,"make-polar")
___DEF_SYM(454,___S_make_2d_random_2d_source,"make-random-source")
___DEF_SYM(455,___S_make_2d_rectangular,"make-rectangular")
___DEF_SYM(456,___S_make_2d_root_2d_thread,"make-root-thread")
___DEF_SYM(457,___S_make_2d_s16vector,"make-s16vector")
___DEF_SYM(458,___S_make_2d_s32vector,"make-s32vector")
___DEF_SYM(459,___S_make_2d_s64vector,"make-s64vector")
___DEF_SYM(460,___S_make_2d_s8vector,"make-s8vector")
___DEF_SYM(461,___S_make_2d_string,"make-string")
___DEF_SYM(462,___S_make_2d_table,"make-table")
___DEF_SYM(463,___S_make_2d_thread,"make-thread")
___DEF_SYM(464,___S_make_2d_thread_2d_group,"make-thread-group")
___DEF_SYM(465,___S_make_2d_u16vector,"make-u16vector")
___DEF_SYM(466,___S_make_2d_u32vector,"make-u32vector")
___DEF_SYM(467,___S_make_2d_u64vector,"make-u64vector")
___DEF_SYM(468,___S_make_2d_u8vector,"make-u8vector")
___DEF_SYM(469,___S_make_2d_uninterned_2d_keyword,"make-uninterned-keyword")
___DEF_SYM(470,___S_make_2d_uninterned_2d_symbol,"make-uninterned-symbol")
___DEF_SYM(471,___S_make_2d_vector,"make-vector")
___DEF_SYM(472,___S_make_2d_will,"make-will")
___DEF_SYM(473,___S_map,"map")
___DEF_SYM(474,___S_max,"max")
___DEF_SYM(475,___S_member,"member")
___DEF_SYM(476,___S_memq,"memq")
___DEF_SYM(477,___S_memv,"memv")
___DEF_SYM(478,___S_min,"min")
___DEF_SYM(479,___S_modulo,"modulo")
___DEF_SYM(480,___S_multiple_2d_c_2d_return_2d_exception_3f_,"multiple-c-return-exception?")
___DEF_SYM(481,___S_mutex_2d_lock_21_,"mutex-lock!")
___DEF_SYM(482,___S_mutex_2d_name,"mutex-name")
___DEF_SYM(483,___S_mutex_2d_specific,"mutex-specific")
___DEF_SYM(484,___S_mutex_2d_specific_2d_set_21_,"mutex-specific-set!")
___DEF_SYM(485,___S_mutex_2d_state,"mutex-state")
___DEF_SYM(486,___S_mutex_2d_unlock_21_,"mutex-unlock!")
___DEF_SYM(487,___S_mutex_3f_,"mutex?")
___DEF_SYM(488,___S_namespace,"namespace")
___DEF_SYM(489,___S_nan_3f_,"nan?")
___DEF_SYM(490,___S_negative_3f_,"negative?")
___DEF_SYM(491,___S_network_2d_info,"network-info")
___DEF_SYM(492,___S_network_2d_info_2d_aliases,"network-info-aliases")
___DEF_SYM(493,___S_network_2d_info_2d_name,"network-info-name")
___DEF_SYM(494,___S_network_2d_info_2d_number,"network-info-number")
___DEF_SYM(495,___S_network_2d_info_3f_,"network-info?")
___DEF_SYM(496,___S_newline,"newline")
___DEF_SYM(497,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments,"no-such-file-or-directory-exception-arguments")

___DEF_SYM(498,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure,"no-such-file-or-directory-exception-procedure")

___DEF_SYM(499,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_,"no-such-file-or-directory-exception?")

___DEF_SYM(500,___S_noncontinuable_2d_exception_2d_reason,"noncontinuable-exception-reason")

___DEF_SYM(501,___S_noncontinuable_2d_exception_3f_,"noncontinuable-exception?")
___DEF_SYM(502,___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_2d_arguments,"nonempty-input-port-character-buffer-exception-arguments")

___DEF_SYM(503,___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_2d_procedure,"nonempty-input-port-character-buffer-exception-procedure")

___DEF_SYM(504,___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_3f_,"nonempty-input-port-character-buffer-exception?")

___DEF_SYM(505,___S_nonprocedure_2d_operator_2d_exception_2d_arguments,"nonprocedure-operator-exception-arguments")

___DEF_SYM(506,___S_nonprocedure_2d_operator_2d_exception_2d_code,"nonprocedure-operator-exception-code")

___DEF_SYM(507,___S_nonprocedure_2d_operator_2d_exception_2d_operator,"nonprocedure-operator-exception-operator")

___DEF_SYM(508,___S_nonprocedure_2d_operator_2d_exception_2d_rte,"nonprocedure-operator-exception-rte")

___DEF_SYM(509,___S_nonprocedure_2d_operator_2d_exception_3f_,"nonprocedure-operator-exception?")

___DEF_SYM(510,___S_not,"not")
___DEF_SYM(511,___S_null_2d_environment,"null-environment")
___DEF_SYM(512,___S_null_3f_,"null?")
___DEF_SYM(513,___S_number_2d__3e_string,"number->string")
___DEF_SYM(514,___S_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments,"number-of-arguments-limit-exception-arguments")

___DEF_SYM(515,___S_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure,"number-of-arguments-limit-exception-procedure")

___DEF_SYM(516,___S_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_,"number-of-arguments-limit-exception?")

___DEF_SYM(517,___S_number_3f_,"number?")
___DEF_SYM(518,___S_numerator,"numerator")
___DEF_SYM(519,___S_object_2d__3e_serial_2d_number,"object->serial-number")
___DEF_SYM(520,___S_object_2d__3e_string,"object->string")
___DEF_SYM(521,___S_object_2d__3e_u8vector,"object->u8vector")
___DEF_SYM(522,___S_odd_3f_,"odd?")
___DEF_SYM(523,___S_open_2d_directory,"open-directory")
___DEF_SYM(524,___S_open_2d_dummy,"open-dummy")
___DEF_SYM(525,___S_open_2d_event_2d_queue,"open-event-queue")
___DEF_SYM(526,___S_open_2d_file,"open-file")
___DEF_SYM(527,___S_open_2d_input_2d_file,"open-input-file")
___DEF_SYM(528,___S_open_2d_input_2d_process,"open-input-process")
___DEF_SYM(529,___S_open_2d_input_2d_string,"open-input-string")
___DEF_SYM(530,___S_open_2d_input_2d_u8vector,"open-input-u8vector")
___DEF_SYM(531,___S_open_2d_input_2d_vector,"open-input-vector")
___DEF_SYM(532,___S_open_2d_output_2d_file,"open-output-file")
___DEF_SYM(533,___S_open_2d_output_2d_process,"open-output-process")
___DEF_SYM(534,___S_open_2d_output_2d_string,"open-output-string")
___DEF_SYM(535,___S_open_2d_output_2d_u8vector,"open-output-u8vector")
___DEF_SYM(536,___S_open_2d_output_2d_vector,"open-output-vector")
___DEF_SYM(537,___S_open_2d_process,"open-process")
___DEF_SYM(538,___S_open_2d_string,"open-string")
___DEF_SYM(539,___S_open_2d_string_2d_pipe,"open-string-pipe")
___DEF_SYM(540,___S_open_2d_tcp_2d_client,"open-tcp-client")
___DEF_SYM(541,___S_open_2d_tcp_2d_server,"open-tcp-server")
___DEF_SYM(542,___S_open_2d_u8vector,"open-u8vector")
___DEF_SYM(543,___S_open_2d_u8vector_2d_pipe,"open-u8vector-pipe")
___DEF_SYM(544,___S_open_2d_vector,"open-vector")
___DEF_SYM(545,___S_open_2d_vector_2d_pipe,"open-vector-pipe")
___DEF_SYM(546,___S_or,"or")
___DEF_SYM(547,___S_os_2d_exception_2d_arguments,"os-exception-arguments")
___DEF_SYM(548,___S_os_2d_exception_2d_code,"os-exception-code")
___DEF_SYM(549,___S_os_2d_exception_2d_message,"os-exception-message")
___DEF_SYM(550,___S_os_2d_exception_2d_procedure,"os-exception-procedure")
___DEF_SYM(551,___S_os_2d_exception_3f_,"os-exception?")
___DEF_SYM(552,___S_output_2d_port_2d_byte_2d_position,"output-port-byte-position")
___DEF_SYM(553,___S_output_2d_port_2d_char_2d_position,"output-port-char-position")
___DEF_SYM(554,___S_output_2d_port_2d_column,"output-port-column")
___DEF_SYM(555,___S_output_2d_port_2d_line,"output-port-line")
___DEF_SYM(556,___S_output_2d_port_2d_readtable,"output-port-readtable")
___DEF_SYM(557,___S_output_2d_port_2d_readtable_2d_set_21_,"output-port-readtable-set!")
___DEF_SYM(558,___S_output_2d_port_2d_timeout_2d_set_21_,"output-port-timeout-set!")
___DEF_SYM(559,___S_output_2d_port_2d_width,"output-port-width")
___DEF_SYM(560,___S_output_2d_port_3f_,"output-port?")
___DEF_SYM(561,___S_pair_3f_,"pair?")
___DEF_SYM(562,___S_parameterize,"parameterize")
___DEF_SYM(563,___S_path_2d_directory,"path-directory")
___DEF_SYM(564,___S_path_2d_expand,"path-expand")
___DEF_SYM(565,___S_path_2d_extension,"path-extension")
___DEF_SYM(566,___S_path_2d_normalize,"path-normalize")
___DEF_SYM(567,___S_path_2d_strip_2d_directory,"path-strip-directory")
___DEF_SYM(568,___S_path_2d_strip_2d_extension,"path-strip-extension")
___DEF_SYM(569,___S_path_2d_strip_2d_trailing_2d_directory_2d_separator,"path-strip-trailing-directory-separator")

___DEF_SYM(570,___S_path_2d_strip_2d_volume,"path-strip-volume")
___DEF_SYM(571,___S_path_2d_volume,"path-volume")
___DEF_SYM(572,___S_peek_2d_char,"peek-char")
___DEF_SYM(573,___S_port_2d_settings_2d_set_21_,"port-settings-set!")
___DEF_SYM(574,___S_port_3f_,"port?")
___DEF_SYM(575,___S_positive_3f_,"positive?")
___DEF_SYM(576,___S_pp,"pp")
___DEF_SYM(577,___S_pretty_2d_print,"pretty-print")
___DEF_SYM(578,___S_primordial_2d_exception_2d_handler,"primordial-exception-handler")
___DEF_SYM(579,___S_print,"print")
___DEF_SYM(580,___S_println,"println")
___DEF_SYM(581,___S_procedure_3f_,"procedure?")
___DEF_SYM(582,___S_process_2d_pid,"process-pid")
___DEF_SYM(583,___S_process_2d_status,"process-status")
___DEF_SYM(584,___S_process_2d_times,"process-times")
___DEF_SYM(585,___S_protocol_2d_info,"protocol-info")
___DEF_SYM(586,___S_protocol_2d_info_2d_aliases,"protocol-info-aliases")
___DEF_SYM(587,___S_protocol_2d_info_2d_name,"protocol-info-name")
___DEF_SYM(588,___S_protocol_2d_info_2d_number,"protocol-info-number")
___DEF_SYM(589,___S_protocol_2d_info_3f_,"protocol-info?")
___DEF_SYM(590,___S_quasiquote,"quasiquote")
___DEF_SYM(591,___S_quote,"quote")
___DEF_SYM(592,___S_quotient,"quotient")
___DEF_SYM(593,___S_raise,"raise")
___DEF_SYM(594,___S_random_2d_f64vector,"random-f64vector")
___DEF_SYM(595,___S_random_2d_integer,"random-integer")
___DEF_SYM(596,___S_random_2d_real,"random-real")
___DEF_SYM(597,___S_random_2d_source_2d_make_2d_f64vectors,"random-source-make-f64vectors")

___DEF_SYM(598,___S_random_2d_source_2d_make_2d_integers,"random-source-make-integers")
___DEF_SYM(599,___S_random_2d_source_2d_make_2d_reals,"random-source-make-reals")
___DEF_SYM(600,___S_random_2d_source_2d_make_2d_u8vectors,"random-source-make-u8vectors")
___DEF_SYM(601,___S_random_2d_source_2d_pseudo_2d_randomize_21_,"random-source-pseudo-randomize!")

___DEF_SYM(602,___S_random_2d_source_2d_randomize_21_,"random-source-randomize!")
___DEF_SYM(603,___S_random_2d_source_2d_state_2d_ref,"random-source-state-ref")
___DEF_SYM(604,___S_random_2d_source_2d_state_2d_set_21_,"random-source-state-set!")
___DEF_SYM(605,___S_random_2d_source_3f_,"random-source?")
___DEF_SYM(606,___S_random_2d_u8vector,"random-u8vector")
___DEF_SYM(607,___S_range_2d_exception_2d_arg_2d_num,"range-exception-arg-num")
___DEF_SYM(608,___S_range_2d_exception_2d_arguments,"range-exception-arguments")
___DEF_SYM(609,___S_range_2d_exception_2d_procedure,"range-exception-procedure")
___DEF_SYM(610,___S_range_2d_exception_3f_,"range-exception?")
___DEF_SYM(611,___S_rational_3f_,"rational?")
___DEF_SYM(612,___S_rationalize,"rationalize")
___DEF_SYM(613,___S_read,"read")
___DEF_SYM(614,___S_read_2d_all,"read-all")
___DEF_SYM(615,___S_read_2d_char,"read-char")
___DEF_SYM(616,___S_read_2d_line,"read-line")
___DEF_SYM(617,___S_read_2d_substring,"read-substring")
___DEF_SYM(618,___S_read_2d_subu8vector,"read-subu8vector")
___DEF_SYM(619,___S_read_2d_u8,"read-u8")
___DEF_SYM(620,___S_readtable_2d_case_2d_conversion_3f_,"readtable-case-conversion?")
___DEF_SYM(621,___S_readtable_2d_case_2d_conversion_3f__2d_set,"readtable-case-conversion?-set")

___DEF_SYM(622,___S_readtable_2d_eval_2d_allowed_3f_,"readtable-eval-allowed?")
___DEF_SYM(623,___S_readtable_2d_eval_2d_allowed_3f__2d_set,"readtable-eval-allowed?-set")
___DEF_SYM(624,___S_readtable_2d_keywords_2d_allowed_3f_,"readtable-keywords-allowed?")
___DEF_SYM(625,___S_readtable_2d_keywords_2d_allowed_3f__2d_set,"readtable-keywords-allowed?-set")

___DEF_SYM(626,___S_readtable_2d_max_2d_unescaped_2d_char,"readtable-max-unescaped-char")
___DEF_SYM(627,___S_readtable_2d_max_2d_unescaped_2d_char_2d_set,"readtable-max-unescaped-char-set")

___DEF_SYM(628,___S_readtable_2d_max_2d_write_2d_length,"readtable-max-write-length")
___DEF_SYM(629,___S_readtable_2d_max_2d_write_2d_length_2d_set,"readtable-max-write-length-set")

___DEF_SYM(630,___S_readtable_2d_max_2d_write_2d_level,"readtable-max-write-level")
___DEF_SYM(631,___S_readtable_2d_max_2d_write_2d_level_2d_set,"readtable-max-write-level-set")

___DEF_SYM(632,___S_readtable_2d_sharing_2d_allowed_3f_,"readtable-sharing-allowed?")
___DEF_SYM(633,___S_readtable_2d_sharing_2d_allowed_3f__2d_set,"readtable-sharing-allowed?-set")

___DEF_SYM(634,___S_readtable_2d_start_2d_syntax,"readtable-start-syntax")
___DEF_SYM(635,___S_readtable_2d_start_2d_syntax_2d_set,"readtable-start-syntax-set")
___DEF_SYM(636,___S_readtable_2d_write_2d_cdr_2d_read_2d_macros_3f_,"readtable-write-cdr-read-macros?")

___DEF_SYM(637,___S_readtable_2d_write_2d_cdr_2d_read_2d_macros_3f__2d_set,"readtable-write-cdr-read-macros?-set")

___DEF_SYM(638,___S_readtable_2d_write_2d_extended_2d_read_2d_macros_3f_,"readtable-write-extended-read-macros?")

___DEF_SYM(639,___S_readtable_2d_write_2d_extended_2d_read_2d_macros_3f__2d_set,"readtable-write-extended-read-macros?-set")

___DEF_SYM(640,___S_readtable_3f_,"readtable?")
___DEF_SYM(641,___S_real_2d_part,"real-part")
___DEF_SYM(642,___S_real_2d_time,"real-time")
___DEF_SYM(643,___S_real_3f_,"real?")
___DEF_SYM(644,___S_receive,"receive")
___DEF_SYM(645,___S_remainder,"remainder")
___DEF_SYM(646,___S_rename_2d_file,"rename-file")
___DEF_SYM(647,___S_repl_2d_display_2d_environment_3f_,"repl-display-environment?")
___DEF_SYM(648,___S_repl_2d_input_2d_port,"repl-input-port")
___DEF_SYM(649,___S_repl_2d_output_2d_port,"repl-output-port")
___DEF_SYM(650,___S_repl_2d_result_2d_history_2d_max_2d_length_2d_set_21_,"repl-result-history-max-length-set!")

___DEF_SYM(651,___S_repl_2d_result_2d_history_2d_ref,"repl-result-history-ref")
___DEF_SYM(652,___S_replace_2d_bit_2d_field,"replace-bit-field")
___DEF_SYM(653,___S_reverse,"reverse")
___DEF_SYM(654,___S_round,"round")
___DEF_SYM(655,___S_rpc_2d_remote_2d_error_2d_exception_2d_arguments,"rpc-remote-error-exception-arguments")

___DEF_SYM(656,___S_rpc_2d_remote_2d_error_2d_exception_2d_message,"rpc-remote-error-exception-message")

___DEF_SYM(657,___S_rpc_2d_remote_2d_error_2d_exception_2d_procedure,"rpc-remote-error-exception-procedure")

___DEF_SYM(658,___S_rpc_2d_remote_2d_error_2d_exception_3f_,"rpc-remote-error-exception?")
___DEF_SYM(659,___S_s16vector,"s16vector")
___DEF_SYM(660,___S_s16vector_2d__3e_list,"s16vector->list")
___DEF_SYM(661,___S_s16vector_2d_append,"s16vector-append")
___DEF_SYM(662,___S_s16vector_2d_copy,"s16vector-copy")
___DEF_SYM(663,___S_s16vector_2d_fill_21_,"s16vector-fill!")
___DEF_SYM(664,___S_s16vector_2d_length,"s16vector-length")
___DEF_SYM(665,___S_s16vector_2d_ref,"s16vector-ref")
___DEF_SYM(666,___S_s16vector_2d_set_21_,"s16vector-set!")
___DEF_SYM(667,___S_s16vector_2d_shrink_21_,"s16vector-shrink!")
___DEF_SYM(668,___S_s16vector_3f_,"s16vector?")
___DEF_SYM(669,___S_s32vector,"s32vector")
___DEF_SYM(670,___S_s32vector_2d__3e_list,"s32vector->list")
___DEF_SYM(671,___S_s32vector_2d_append,"s32vector-append")
___DEF_SYM(672,___S_s32vector_2d_copy,"s32vector-copy")
___DEF_SYM(673,___S_s32vector_2d_fill_21_,"s32vector-fill!")
___DEF_SYM(674,___S_s32vector_2d_length,"s32vector-length")
___DEF_SYM(675,___S_s32vector_2d_ref,"s32vector-ref")
___DEF_SYM(676,___S_s32vector_2d_set_21_,"s32vector-set!")
___DEF_SYM(677,___S_s32vector_2d_shrink_21_,"s32vector-shrink!")
___DEF_SYM(678,___S_s32vector_3f_,"s32vector?")
___DEF_SYM(679,___S_s64vector,"s64vector")
___DEF_SYM(680,___S_s64vector_2d__3e_list,"s64vector->list")
___DEF_SYM(681,___S_s64vector_2d_append,"s64vector-append")
___DEF_SYM(682,___S_s64vector_2d_copy,"s64vector-copy")
___DEF_SYM(683,___S_s64vector_2d_fill_21_,"s64vector-fill!")
___DEF_SYM(684,___S_s64vector_2d_length,"s64vector-length")
___DEF_SYM(685,___S_s64vector_2d_ref,"s64vector-ref")
___DEF_SYM(686,___S_s64vector_2d_set_21_,"s64vector-set!")
___DEF_SYM(687,___S_s64vector_2d_shrink_21_,"s64vector-shrink!")
___DEF_SYM(688,___S_s64vector_3f_,"s64vector?")
___DEF_SYM(689,___S_s8vector,"s8vector")
___DEF_SYM(690,___S_s8vector_2d__3e_list,"s8vector->list")
___DEF_SYM(691,___S_s8vector_2d_append,"s8vector-append")
___DEF_SYM(692,___S_s8vector_2d_copy,"s8vector-copy")
___DEF_SYM(693,___S_s8vector_2d_fill_21_,"s8vector-fill!")
___DEF_SYM(694,___S_s8vector_2d_length,"s8vector-length")
___DEF_SYM(695,___S_s8vector_2d_ref,"s8vector-ref")
___DEF_SYM(696,___S_s8vector_2d_set_21_,"s8vector-set!")
___DEF_SYM(697,___S_s8vector_2d_shrink_21_,"s8vector-shrink!")
___DEF_SYM(698,___S_s8vector_3f_,"s8vector?")
___DEF_SYM(699,___S_scheduler_2d_exception_2d_reason,"scheduler-exception-reason")
___DEF_SYM(700,___S_scheduler_2d_exception_3f_,"scheduler-exception?")
___DEF_SYM(701,___S_scheme_2d_report_2d_environment,"scheme-report-environment")
___DEF_SYM(702,___S_seconds_2d__3e_time,"seconds->time")
___DEF_SYM(703,___S_serial_2d_number_2d__3e_object,"serial-number->object")
___DEF_SYM(704,___S_service_2d_info,"service-info")
___DEF_SYM(705,___S_service_2d_info_2d_aliases,"service-info-aliases")
___DEF_SYM(706,___S_service_2d_info_2d_name,"service-info-name")
___DEF_SYM(707,___S_service_2d_info_2d_port_2d_number,"service-info-port-number")
___DEF_SYM(708,___S_service_2d_info_2d_protocol,"service-info-protocol")
___DEF_SYM(709,___S_service_2d_info_3f_,"service-info?")
___DEF_SYM(710,___S_set_21_,"set!")
___DEF_SYM(711,___S_set_2d_box_21_,"set-box!")
___DEF_SYM(712,___S_set_2d_car_21_,"set-car!")
___DEF_SYM(713,___S_set_2d_cdr_21_,"set-cdr!")
___DEF_SYM(714,___S_setenv,"setenv")
___DEF_SYM(715,___S_sfun_2d_conversion_2d_exception_2d_arguments,"sfun-conversion-exception-arguments")

___DEF_SYM(716,___S_sfun_2d_conversion_2d_exception_2d_code,"sfun-conversion-exception-code")

___DEF_SYM(717,___S_sfun_2d_conversion_2d_exception_2d_message,"sfun-conversion-exception-message")

___DEF_SYM(718,___S_sfun_2d_conversion_2d_exception_2d_procedure,"sfun-conversion-exception-procedure")

___DEF_SYM(719,___S_sfun_2d_conversion_2d_exception_3f_,"sfun-conversion-exception?")
___DEF_SYM(720,___S_shell_2d_command,"shell-command")
___DEF_SYM(721,___S_sin,"sin")
___DEF_SYM(722,___S_six_2e__21_,"six.!")
___DEF_SYM(723,___S_six_2e__21_x,"six.!x")
___DEF_SYM(724,___S_six_2e__26_x,"six.&x")
___DEF_SYM(725,___S_six_2e__2a_x,"six.*x")
___DEF_SYM(726,___S_six_2e__2b__2b_x,"six.++x")
___DEF_SYM(727,___S_six_2e__2b_x,"six.+x")
___DEF_SYM(728,___S_six_2e__2d__2d_x,"six.--x")
___DEF_SYM(729,___S_six_2e__2d_x,"six.-x")
___DEF_SYM(730,___S_six_2e_arrow,"six.arrow")
___DEF_SYM(731,___S_six_2e_break,"six.break")
___DEF_SYM(732,___S_six_2e_call,"six.call")
___DEF_SYM(733,___S_six_2e_case,"six.case")
___DEF_SYM(734,___S_six_2e_clause,"six.clause")
___DEF_SYM(735,___S_six_2e_compound,"six.compound")
___DEF_SYM(736,___S_six_2e_cons,"six.cons")
___DEF_SYM(737,___S_six_2e_continue,"six.continue")
___DEF_SYM(738,___S_six_2e_define_2d_procedure,"six.define-procedure")
___DEF_SYM(739,___S_six_2e_define_2d_variable,"six.define-variable")
___DEF_SYM(740,___S_six_2e_do_2d_while,"six.do-while")
___DEF_SYM(741,___S_six_2e_dot,"six.dot")
___DEF_SYM(742,___S_six_2e_for,"six.for")
___DEF_SYM(743,___S_six_2e_goto,"six.goto")
___DEF_SYM(744,___S_six_2e_identifier,"six.identifier")
___DEF_SYM(745,___S_six_2e_if,"six.if")
___DEF_SYM(746,___S_six_2e_index,"six.index")
___DEF_SYM(747,___S_six_2e_label,"six.label")
___DEF_SYM(748,___S_six_2e_list,"six.list")
___DEF_SYM(749,___S_six_2e_literal,"six.literal")
___DEF_SYM(750,___S_six_2e_make_2d_array,"six.make-array")
___DEF_SYM(751,___S_six_2e_new,"six.new")
___DEF_SYM(752,___S_six_2e_null,"six.null")
___DEF_SYM(753,___S_six_2e_prefix,"six.prefix")
___DEF_SYM(754,___S_six_2e_procedure,"six.procedure")
___DEF_SYM(755,___S_six_2e_procedure_2d_body,"six.procedure-body")
___DEF_SYM(756,___S_six_2e_return,"six.return")
___DEF_SYM(757,___S_six_2e_switch,"six.switch")
___DEF_SYM(758,___S_six_2e_while,"six.while")
___DEF_SYM(759,___S_six_2e_x_21__3d_y,"six.x!=y")
___DEF_SYM(760,___S_six_2e_x_25__3d_y,"six.x%=y")
___DEF_SYM(761,___S_six_2e_x_25_y,"six.x%y")
___DEF_SYM(762,___S_six_2e_x_26__26_y,"six.x&&y")
___DEF_SYM(763,___S_six_2e_x_26__3d_y,"six.x&=y")
___DEF_SYM(764,___S_six_2e_x_26_y,"six.x&y")
___DEF_SYM(765,___S_six_2e_x_2a__3d_y,"six.x*=y")
___DEF_SYM(766,___S_six_2e_x_2a_y,"six.x*y")
___DEF_SYM(767,___S_six_2e_x_2b__2b_,"six.x++")
___DEF_SYM(768,___S_six_2e_x_2b__3d_y,"six.x+=y")
___DEF_SYM(769,___S_six_2e_x_2b_y,"six.x+y")
___DEF_SYM(770,___S_six_2e_x_2c_y,"six.x,y")
___DEF_SYM(771,___S_six_2e_x_2d__2d_,"six.x--")
___DEF_SYM(772,___S_six_2e_x_2d__3d_y,"six.x-=y")
___DEF_SYM(773,___S_six_2e_x_2d_y,"six.x-y")
___DEF_SYM(774,___S_six_2e_x_2f__3d_y,"six.x/=y")
___DEF_SYM(775,___S_six_2e_x_2f_y,"six.x/y")
___DEF_SYM(776,___S_six_2e_x_3a__2d_y,"six.x:-y")
___DEF_SYM(777,___S_six_2e_x_3a__3d_y,"six.x:=y")
___DEF_SYM(778,___S_six_2e_x_3a_y,"six.x:y")
___DEF_SYM(779,___S_six_2e_x_3c__3c__3d_y,"six.x<<=y")
___DEF_SYM(780,___S_six_2e_x_3c__3c_y,"six.x<<y")
___DEF_SYM(781,___S_six_2e_x_3c__3d_y,"six.x<=y")
___DEF_SYM(782,___S_six_2e_x_3c_y,"six.x<y")
___DEF_SYM(783,___S_six_2e_x_3d__3d_y,"six.x==y")
___DEF_SYM(784,___S_six_2e_x_3d_y,"six.x=y")
___DEF_SYM(785,___S_six_2e_x_3e__3d_y,"six.x>=y")
___DEF_SYM(786,___S_six_2e_x_3e__3e__3d_y,"six.x>>=y")
___DEF_SYM(787,___S_six_2e_x_3e__3e_y,"six.x>>y")
___DEF_SYM(788,___S_six_2e_x_3e_y,"six.x>y")
___DEF_SYM(789,___S_six_2e_x_3f_y_3a_z,"six.x?y:z")
___DEF_SYM(790,___S_six_2e_x_5e__3d_y,"six.x^=y")
___DEF_SYM(791,___S_six_2e_x_5e_y,"six.x^y")
___DEF_SYM(792,___S_six_2e_x_7c__3d_y,"six.x|=y")
___DEF_SYM(793,___S_six_2e_x_7c_y,"six.x|y")
___DEF_SYM(794,___S_six_2e_x_7c__7c_y,"six.x||y")
___DEF_SYM(795,___S_six_2e__7e_x,"six.~x")
___DEF_SYM(796,___S_socket_2d_info_2d_address,"socket-info-address")
___DEF_SYM(797,___S_socket_2d_info_2d_family,"socket-info-family")
___DEF_SYM(798,___S_socket_2d_info_2d_port_2d_number,"socket-info-port-number")
___DEF_SYM(799,___S_socket_2d_info_3f_,"socket-info?")
___DEF_SYM(800,___S_sqrt,"sqrt")
___DEF_SYM(801,___S_stack_2d_overflow_2d_exception_3f_,"stack-overflow-exception?")
___DEF_SYM(802,___S_started_2d_thread_2d_exception_2d_arguments,"started-thread-exception-arguments")

___DEF_SYM(803,___S_started_2d_thread_2d_exception_2d_procedure,"started-thread-exception-procedure")

___DEF_SYM(804,___S_started_2d_thread_2d_exception_3f_,"started-thread-exception?")
___DEF_SYM(805,___S_step,"step")
___DEF_SYM(806,___S_step_2d_level_2d_set_21_,"step-level-set!")
___DEF_SYM(807,___S_string,"string")
___DEF_SYM(808,___S_string_2d__3e_keyword,"string->keyword")
___DEF_SYM(809,___S_string_2d__3e_list,"string->list")
___DEF_SYM(810,___S_string_2d__3e_number,"string->number")
___DEF_SYM(811,___S_string_2d__3e_symbol,"string->symbol")
___DEF_SYM(812,___S_string_2d_append,"string-append")
___DEF_SYM(813,___S_string_2d_ci_3c__3d__3f_,"string-ci<=?")
___DEF_SYM(814,___S_string_2d_ci_3c__3f_,"string-ci<?")
___DEF_SYM(815,___S_string_2d_ci_3d__3f_,"string-ci=?")
___DEF_SYM(816,___S_string_2d_ci_3d__3f__2d_hash,"string-ci=?-hash")
___DEF_SYM(817,___S_string_2d_ci_3e__3d__3f_,"string-ci>=?")
___DEF_SYM(818,___S_string_2d_ci_3e__3f_,"string-ci>?")
___DEF_SYM(819,___S_string_2d_copy,"string-copy")
___DEF_SYM(820,___S_string_2d_fill_21_,"string-fill!")
___DEF_SYM(821,___S_string_2d_length,"string-length")
___DEF_SYM(822,___S_string_2d_ref,"string-ref")
___DEF_SYM(823,___S_string_2d_set_21_,"string-set!")
___DEF_SYM(824,___S_string_2d_shrink_21_,"string-shrink!")
___DEF_SYM(825,___S_string_3c__3d__3f_,"string<=?")
___DEF_SYM(826,___S_string_3c__3f_,"string<?")
___DEF_SYM(827,___S_string_3d__3f_,"string=?")
___DEF_SYM(828,___S_string_3d__3f__2d_hash,"string=?-hash")
___DEF_SYM(829,___S_string_3e__3d__3f_,"string>=?")
___DEF_SYM(830,___S_string_3e__3f_,"string>?")
___DEF_SYM(831,___S_string_3f_,"string?")
___DEF_SYM(832,___S_subf32vector,"subf32vector")
___DEF_SYM(833,___S_subf32vector_2d_fill_21_,"subf32vector-fill!")
___DEF_SYM(834,___S_subf32vector_2d_move_21_,"subf32vector-move!")
___DEF_SYM(835,___S_subf64vector,"subf64vector")
___DEF_SYM(836,___S_subf64vector_2d_fill_21_,"subf64vector-fill!")
___DEF_SYM(837,___S_subf64vector_2d_move_21_,"subf64vector-move!")
___DEF_SYM(838,___S_subs16vector,"subs16vector")
___DEF_SYM(839,___S_subs16vector_2d_fill_21_,"subs16vector-fill!")
___DEF_SYM(840,___S_subs16vector_2d_move_21_,"subs16vector-move!")
___DEF_SYM(841,___S_subs32vector,"subs32vector")
___DEF_SYM(842,___S_subs32vector_2d_fill_21_,"subs32vector-fill!")
___DEF_SYM(843,___S_subs32vector_2d_move_21_,"subs32vector-move!")
___DEF_SYM(844,___S_subs64vector,"subs64vector")
___DEF_SYM(845,___S_subs64vector_2d_fill_21_,"subs64vector-fill!")
___DEF_SYM(846,___S_subs64vector_2d_move_21_,"subs64vector-move!")
___DEF_SYM(847,___S_subs8vector,"subs8vector")
___DEF_SYM(848,___S_subs8vector_2d_fill_21_,"subs8vector-fill!")
___DEF_SYM(849,___S_subs8vector_2d_move_21_,"subs8vector-move!")
___DEF_SYM(850,___S_substring,"substring")
___DEF_SYM(851,___S_substring_2d_fill_21_,"substring-fill!")
___DEF_SYM(852,___S_substring_2d_move_21_,"substring-move!")
___DEF_SYM(853,___S_subu16vector,"subu16vector")
___DEF_SYM(854,___S_subu16vector_2d_fill_21_,"subu16vector-fill!")
___DEF_SYM(855,___S_subu16vector_2d_move_21_,"subu16vector-move!")
___DEF_SYM(856,___S_subu32vector,"subu32vector")
___DEF_SYM(857,___S_subu32vector_2d_fill_21_,"subu32vector-fill!")
___DEF_SYM(858,___S_subu32vector_2d_move_21_,"subu32vector-move!")
___DEF_SYM(859,___S_subu64vector,"subu64vector")
___DEF_SYM(860,___S_subu64vector_2d_fill_21_,"subu64vector-fill!")
___DEF_SYM(861,___S_subu64vector_2d_move_21_,"subu64vector-move!")
___DEF_SYM(862,___S_subu8vector,"subu8vector")
___DEF_SYM(863,___S_subu8vector_2d_fill_21_,"subu8vector-fill!")
___DEF_SYM(864,___S_subu8vector_2d_move_21_,"subu8vector-move!")
___DEF_SYM(865,___S_subvector,"subvector")
___DEF_SYM(866,___S_subvector_2d_fill_21_,"subvector-fill!")
___DEF_SYM(867,___S_subvector_2d_move_21_,"subvector-move!")
___DEF_SYM(868,___S_symbol_2d__3e_string,"symbol->string")
___DEF_SYM(869,___S_symbol_2d_hash,"symbol-hash")
___DEF_SYM(870,___S_symbol_3f_,"symbol?")
___DEF_SYM(871,___S_syntax_2d_rules,"syntax-rules")
___DEF_SYM(872,___S_system_2d_stamp,"system-stamp")
___DEF_SYM(873,___S_system_2d_type,"system-type")
___DEF_SYM(874,___S_system_2d_type_2d_string,"system-type-string")
___DEF_SYM(875,___S_system_2d_version,"system-version")
___DEF_SYM(876,___S_system_2d_version_2d_string,"system-version-string")
___DEF_SYM(877,___S_table_2d__3e_list,"table->list")
___DEF_SYM(878,___S_table_2d_copy,"table-copy")
___DEF_SYM(879,___S_table_2d_for_2d_each,"table-for-each")
___DEF_SYM(880,___S_table_2d_length,"table-length")
___DEF_SYM(881,___S_table_2d_merge,"table-merge")
___DEF_SYM(882,___S_table_2d_merge_21_,"table-merge!")
___DEF_SYM(883,___S_table_2d_ref,"table-ref")
___DEF_SYM(884,___S_table_2d_search,"table-search")
___DEF_SYM(885,___S_table_2d_set_21_,"table-set!")
___DEF_SYM(886,___S_table_3f_,"table?")
___DEF_SYM(887,___S_tan,"tan")
___DEF_SYM(888,___S_tcp_2d_client_2d_peer_2d_socket_2d_info,"tcp-client-peer-socket-info")
___DEF_SYM(889,___S_tcp_2d_client_2d_self_2d_socket_2d_info,"tcp-client-self-socket-info")
___DEF_SYM(890,___S_tcp_2d_server_2d_socket_2d_info,"tcp-server-socket-info")
___DEF_SYM(891,___S_tcp_2d_service_2d_register_21_,"tcp-service-register!")
___DEF_SYM(892,___S_tcp_2d_service_2d_unregister_21_,"tcp-service-unregister!")
___DEF_SYM(893,___S_terminated_2d_thread_2d_exception_2d_arguments,"terminated-thread-exception-arguments")

___DEF_SYM(894,___S_terminated_2d_thread_2d_exception_2d_procedure,"terminated-thread-exception-procedure")

___DEF_SYM(895,___S_terminated_2d_thread_2d_exception_3f_,"terminated-thread-exception?")
___DEF_SYM(896,___S_test_2d_bit_2d_field_3f_,"test-bit-field?")
___DEF_SYM(897,___S_this_2d_source_2d_file,"this-source-file")
___DEF_SYM(898,___S_thread_2d_base_2d_priority,"thread-base-priority")
___DEF_SYM(899,___S_thread_2d_base_2d_priority_2d_set_21_,"thread-base-priority-set!")
___DEF_SYM(900,___S_thread_2d_group_2d__3e_thread_2d_group_2d_list,"thread-group->thread-group-list")

___DEF_SYM(901,___S_thread_2d_group_2d__3e_thread_2d_group_2d_vector,"thread-group->thread-group-vector")

___DEF_SYM(902,___S_thread_2d_group_2d__3e_thread_2d_list,"thread-group->thread-list")
___DEF_SYM(903,___S_thread_2d_group_2d__3e_thread_2d_vector,"thread-group->thread-vector")
___DEF_SYM(904,___S_thread_2d_group_2d_name,"thread-group-name")
___DEF_SYM(905,___S_thread_2d_group_2d_parent,"thread-group-parent")
___DEF_SYM(906,___S_thread_2d_group_2d_resume_21_,"thread-group-resume!")
___DEF_SYM(907,___S_thread_2d_group_2d_suspend_21_,"thread-group-suspend!")
___DEF_SYM(908,___S_thread_2d_group_2d_terminate_21_,"thread-group-terminate!")
___DEF_SYM(909,___S_thread_2d_group_3f_,"thread-group?")
___DEF_SYM(910,___S_thread_2d_init_21_,"thread-init!")
___DEF_SYM(911,___S_thread_2d_interrupt_21_,"thread-interrupt!")
___DEF_SYM(912,___S_thread_2d_join_21_,"thread-join!")
___DEF_SYM(913,___S_thread_2d_mailbox_2d_extract_2d_and_2d_rewind,"thread-mailbox-extract-and-rewind")

___DEF_SYM(914,___S_thread_2d_mailbox_2d_next,"thread-mailbox-next")
___DEF_SYM(915,___S_thread_2d_mailbox_2d_rewind,"thread-mailbox-rewind")
___DEF_SYM(916,___S_thread_2d_name,"thread-name")
___DEF_SYM(917,___S_thread_2d_priority_2d_boost,"thread-priority-boost")
___DEF_SYM(918,___S_thread_2d_priority_2d_boost_2d_set_21_,"thread-priority-boost-set!")
___DEF_SYM(919,___S_thread_2d_quantum,"thread-quantum")
___DEF_SYM(920,___S_thread_2d_quantum_2d_set_21_,"thread-quantum-set!")
___DEF_SYM(921,___S_thread_2d_receive,"thread-receive")
___DEF_SYM(922,___S_thread_2d_resume_21_,"thread-resume!")
___DEF_SYM(923,___S_thread_2d_send,"thread-send")
___DEF_SYM(924,___S_thread_2d_sleep_21_,"thread-sleep!")
___DEF_SYM(925,___S_thread_2d_specific,"thread-specific")
___DEF_SYM(926,___S_thread_2d_specific_2d_set_21_,"thread-specific-set!")
___DEF_SYM(927,___S_thread_2d_start_21_,"thread-start!")
___DEF_SYM(928,___S_thread_2d_state,"thread-state")
___DEF_SYM(929,___S_thread_2d_state_2d_abnormally_2d_terminated_2d_reason,"thread-state-abnormally-terminated-reason")

___DEF_SYM(930,___S_thread_2d_state_2d_abnormally_2d_terminated_3f_,"thread-state-abnormally-terminated?")

___DEF_SYM(931,___S_thread_2d_state_2d_active_2d_timeout,"thread-state-active-timeout")
___DEF_SYM(932,___S_thread_2d_state_2d_active_2d_waiting_2d_for,"thread-state-active-waiting-for")

___DEF_SYM(933,___S_thread_2d_state_2d_active_3f_,"thread-state-active?")
___DEF_SYM(934,___S_thread_2d_state_2d_initialized_3f_,"thread-state-initialized?")
___DEF_SYM(935,___S_thread_2d_state_2d_normally_2d_terminated_2d_result,"thread-state-normally-terminated-result")

___DEF_SYM(936,___S_thread_2d_state_2d_normally_2d_terminated_3f_,"thread-state-normally-terminated?")

___DEF_SYM(937,___S_thread_2d_state_2d_uninitialized_3f_,"thread-state-uninitialized?")
___DEF_SYM(938,___S_thread_2d_suspend_21_,"thread-suspend!")
___DEF_SYM(939,___S_thread_2d_terminate_21_,"thread-terminate!")
___DEF_SYM(940,___S_thread_2d_thread_2d_group,"thread-thread-group")
___DEF_SYM(941,___S_thread_2d_yield_21_,"thread-yield!")
___DEF_SYM(942,___S_thread_3f_,"thread?")
___DEF_SYM(943,___S_time,"time")
___DEF_SYM(944,___S_time_2d__3e_seconds,"time->seconds")
___DEF_SYM(945,___S_time_3f_,"time?")
___DEF_SYM(946,___S_timeout_2d__3e_time,"timeout->time")
___DEF_SYM(947,___S_top,"top")
___DEF_SYM(948,___S_touch,"touch")
___DEF_SYM(949,___S_trace,"trace")
___DEF_SYM(950,___S_transcript_2d_off,"transcript-off")
___DEF_SYM(951,___S_transcript_2d_on,"transcript-on")
___DEF_SYM(952,___S_truncate,"truncate")
___DEF_SYM(953,___S_tty_2d_history,"tty-history")
___DEF_SYM(954,___S_tty_2d_history_2d_max_2d_length_2d_set_21_,"tty-history-max-length-set!")
___DEF_SYM(955,___S_tty_2d_history_2d_set_21_,"tty-history-set!")
___DEF_SYM(956,___S_tty_2d_mode_2d_set_21_,"tty-mode-set!")
___DEF_SYM(957,___S_tty_2d_paren_2d_balance_2d_duration_2d_set_21_,"tty-paren-balance-duration-set!")

___DEF_SYM(958,___S_tty_2d_text_2d_attributes_2d_set_21_,"tty-text-attributes-set!")
___DEF_SYM(959,___S_tty_2d_type_2d_set_21_,"tty-type-set!")
___DEF_SYM(960,___S_tty_3f_,"tty?")
___DEF_SYM(961,___S_type_2d_exception_2d_arg_2d_num,"type-exception-arg-num")
___DEF_SYM(962,___S_type_2d_exception_2d_arguments,"type-exception-arguments")
___DEF_SYM(963,___S_type_2d_exception_2d_procedure,"type-exception-procedure")
___DEF_SYM(964,___S_type_2d_exception_2d_type_2d_id,"type-exception-type-id")
___DEF_SYM(965,___S_type_2d_exception_3f_,"type-exception?")
___DEF_SYM(966,___S_u16vector,"u16vector")
___DEF_SYM(967,___S_u16vector_2d__3e_list,"u16vector->list")
___DEF_SYM(968,___S_u16vector_2d_append,"u16vector-append")
___DEF_SYM(969,___S_u16vector_2d_copy,"u16vector-copy")
___DEF_SYM(970,___S_u16vector_2d_fill_21_,"u16vector-fill!")
___DEF_SYM(971,___S_u16vector_2d_length,"u16vector-length")
___DEF_SYM(972,___S_u16vector_2d_ref,"u16vector-ref")
___DEF_SYM(973,___S_u16vector_2d_set_21_,"u16vector-set!")
___DEF_SYM(974,___S_u16vector_2d_shrink_21_,"u16vector-shrink!")
___DEF_SYM(975,___S_u16vector_3f_,"u16vector?")
___DEF_SYM(976,___S_u32vector,"u32vector")
___DEF_SYM(977,___S_u32vector_2d__3e_list,"u32vector->list")
___DEF_SYM(978,___S_u32vector_2d_append,"u32vector-append")
___DEF_SYM(979,___S_u32vector_2d_copy,"u32vector-copy")
___DEF_SYM(980,___S_u32vector_2d_fill_21_,"u32vector-fill!")
___DEF_SYM(981,___S_u32vector_2d_length,"u32vector-length")
___DEF_SYM(982,___S_u32vector_2d_ref,"u32vector-ref")
___DEF_SYM(983,___S_u32vector_2d_set_21_,"u32vector-set!")
___DEF_SYM(984,___S_u32vector_2d_shrink_21_,"u32vector-shrink!")
___DEF_SYM(985,___S_u32vector_3f_,"u32vector?")
___DEF_SYM(986,___S_u64vector,"u64vector")
___DEF_SYM(987,___S_u64vector_2d__3e_list,"u64vector->list")
___DEF_SYM(988,___S_u64vector_2d_append,"u64vector-append")
___DEF_SYM(989,___S_u64vector_2d_copy,"u64vector-copy")
___DEF_SYM(990,___S_u64vector_2d_fill_21_,"u64vector-fill!")
___DEF_SYM(991,___S_u64vector_2d_length,"u64vector-length")
___DEF_SYM(992,___S_u64vector_2d_ref,"u64vector-ref")
___DEF_SYM(993,___S_u64vector_2d_set_21_,"u64vector-set!")
___DEF_SYM(994,___S_u64vector_2d_shrink_21_,"u64vector-shrink!")
___DEF_SYM(995,___S_u64vector_3f_,"u64vector?")
___DEF_SYM(996,___S_u8vector,"u8vector")
___DEF_SYM(997,___S_u8vector_2d__3e_list,"u8vector->list")
___DEF_SYM(998,___S_u8vector_2d__3e_object,"u8vector->object")
___DEF_SYM(999,___S_u8vector_2d_append,"u8vector-append")
___DEF_SYM(1000,___S_u8vector_2d_copy,"u8vector-copy")
___DEF_SYM(1001,___S_u8vector_2d_fill_21_,"u8vector-fill!")
___DEF_SYM(1002,___S_u8vector_2d_length,"u8vector-length")
___DEF_SYM(1003,___S_u8vector_2d_ref,"u8vector-ref")
___DEF_SYM(1004,___S_u8vector_2d_set_21_,"u8vector-set!")
___DEF_SYM(1005,___S_u8vector_2d_shrink_21_,"u8vector-shrink!")
___DEF_SYM(1006,___S_u8vector_3f_,"u8vector?")
___DEF_SYM(1007,___S_unbound_2d_global_2d_exception_2d_code,"unbound-global-exception-code")

___DEF_SYM(1008,___S_unbound_2d_global_2d_exception_2d_rte,"unbound-global-exception-rte")
___DEF_SYM(1009,___S_unbound_2d_global_2d_exception_2d_variable,"unbound-global-exception-variable")

___DEF_SYM(1010,___S_unbound_2d_global_2d_exception_3f_,"unbound-global-exception?")
___DEF_SYM(1011,___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_2d_arguments,"unbound-os-environment-variable-exception-arguments")

___DEF_SYM(1012,___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_2d_procedure,"unbound-os-environment-variable-exception-procedure")

___DEF_SYM(1013,___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_3f_,"unbound-os-environment-variable-exception?")

___DEF_SYM(1014,___S_unbound_2d_serial_2d_number_2d_exception_2d_arguments,"unbound-serial-number-exception-arguments")

___DEF_SYM(1015,___S_unbound_2d_serial_2d_number_2d_exception_2d_procedure,"unbound-serial-number-exception-procedure")

___DEF_SYM(1016,___S_unbound_2d_serial_2d_number_2d_exception_3f_,"unbound-serial-number-exception?")

___DEF_SYM(1017,___S_unbound_2d_table_2d_key_2d_exception_2d_arguments,"unbound-table-key-exception-arguments")

___DEF_SYM(1018,___S_unbound_2d_table_2d_key_2d_exception_2d_procedure,"unbound-table-key-exception-procedure")

___DEF_SYM(1019,___S_unbound_2d_table_2d_key_2d_exception_3f_,"unbound-table-key-exception?")
___DEF_SYM(1020,___S_unbox,"unbox")
___DEF_SYM(1021,___S_unbreak,"unbreak")
___DEF_SYM(1022,___S_uncaught_2d_exception_2d_arguments,"uncaught-exception-arguments")
___DEF_SYM(1023,___S_uncaught_2d_exception_2d_procedure,"uncaught-exception-procedure")
___DEF_SYM(1024,___S_uncaught_2d_exception_2d_reason,"uncaught-exception-reason")
___DEF_SYM(1025,___S_uncaught_2d_exception_3f_,"uncaught-exception?")
___DEF_SYM(1026,___S_uninitialized_2d_thread_2d_exception_2d_arguments,"uninitialized-thread-exception-arguments")

___DEF_SYM(1027,___S_uninitialized_2d_thread_2d_exception_2d_procedure,"uninitialized-thread-exception-procedure")

___DEF_SYM(1028,___S_uninitialized_2d_thread_2d_exception_3f_,"uninitialized-thread-exception?")

___DEF_SYM(1029,___S_uninterned_2d_keyword_3f_,"uninterned-keyword?")
___DEF_SYM(1030,___S_uninterned_2d_symbol_3f_,"uninterned-symbol?")
___DEF_SYM(1031,___S_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments,"unknown-keyword-argument-exception-arguments")

___DEF_SYM(1032,___S_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure,"unknown-keyword-argument-exception-procedure")

___DEF_SYM(1033,___S_unknown_2d_keyword_2d_argument_2d_exception_3f_,"unknown-keyword-argument-exception?")

___DEF_SYM(1034,___S_unterminated_2d_process_2d_exception_2d_arguments,"unterminated-process-exception-arguments")

___DEF_SYM(1035,___S_unterminated_2d_process_2d_exception_2d_procedure,"unterminated-process-exception-procedure")

___DEF_SYM(1036,___S_unterminated_2d_process_2d_exception_3f_,"unterminated-process-exception?")

___DEF_SYM(1037,___S_untrace,"untrace")
___DEF_SYM(1038,___S_user_2d_info,"user-info")
___DEF_SYM(1039,___S_user_2d_info_2d_gid,"user-info-gid")
___DEF_SYM(1040,___S_user_2d_info_2d_home,"user-info-home")
___DEF_SYM(1041,___S_user_2d_info_2d_name,"user-info-name")
___DEF_SYM(1042,___S_user_2d_info_2d_shell,"user-info-shell")
___DEF_SYM(1043,___S_user_2d_info_2d_uid,"user-info-uid")
___DEF_SYM(1044,___S_user_2d_info_3f_,"user-info?")
___DEF_SYM(1045,___S_user_2d_name,"user-name")
___DEF_SYM(1046,___S_values,"values")
___DEF_SYM(1047,___S_vector,"vector")
___DEF_SYM(1048,___S_vector_2d__3e_list,"vector->list")
___DEF_SYM(1049,___S_vector_2d_append,"vector-append")
___DEF_SYM(1050,___S_vector_2d_copy,"vector-copy")
___DEF_SYM(1051,___S_vector_2d_fill_21_,"vector-fill!")
___DEF_SYM(1052,___S_vector_2d_length,"vector-length")
___DEF_SYM(1053,___S_vector_2d_ref,"vector-ref")
___DEF_SYM(1054,___S_vector_2d_set_21_,"vector-set!")
___DEF_SYM(1055,___S_vector_2d_shrink_21_,"vector-shrink!")
___DEF_SYM(1056,___S_vector_3f_,"vector?")
___DEF_SYM(1057,___S_void,"void")
___DEF_SYM(1058,___S_will_2d_execute_21_,"will-execute!")
___DEF_SYM(1059,___S_will_2d_testator,"will-testator")
___DEF_SYM(1060,___S_will_3f_,"will?")
___DEF_SYM(1061,___S_with_2d_exception_2d_catcher,"with-exception-catcher")
___DEF_SYM(1062,___S_with_2d_exception_2d_handler,"with-exception-handler")
___DEF_SYM(1063,___S_with_2d_input_2d_from_2d_file,"with-input-from-file")
___DEF_SYM(1064,___S_with_2d_input_2d_from_2d_port,"with-input-from-port")
___DEF_SYM(1065,___S_with_2d_input_2d_from_2d_process,"with-input-from-process")
___DEF_SYM(1066,___S_with_2d_input_2d_from_2d_string,"with-input-from-string")
___DEF_SYM(1067,___S_with_2d_input_2d_from_2d_u8vector,"with-input-from-u8vector")
___DEF_SYM(1068,___S_with_2d_input_2d_from_2d_vector,"with-input-from-vector")
___DEF_SYM(1069,___S_with_2d_output_2d_to_2d_file,"with-output-to-file")
___DEF_SYM(1070,___S_with_2d_output_2d_to_2d_port,"with-output-to-port")
___DEF_SYM(1071,___S_with_2d_output_2d_to_2d_process,"with-output-to-process")
___DEF_SYM(1072,___S_with_2d_output_2d_to_2d_string,"with-output-to-string")
___DEF_SYM(1073,___S_with_2d_output_2d_to_2d_u8vector,"with-output-to-u8vector")
___DEF_SYM(1074,___S_with_2d_output_2d_to_2d_vector,"with-output-to-vector")
___DEF_SYM(1075,___S_write,"write")
___DEF_SYM(1076,___S_write_2d_char,"write-char")
___DEF_SYM(1077,___S_write_2d_substring,"write-substring")
___DEF_SYM(1078,___S_write_2d_subu8vector,"write-subu8vector")
___DEF_SYM(1079,___S_write_2d_u8,"write-u8")
___DEF_SYM(1080,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments,"wrong-number-of-arguments-exception-arguments")

___DEF_SYM(1081,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure,"wrong-number-of-arguments-exception-procedure")

___DEF_SYM(1082,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_,"wrong-number-of-arguments-exception?")

___DEF_SYM(1083,___S_zero_3f_,"zero?")
___END_SYM

#define ___SYM__2a_ ___SYM(0,___S__2a_)
#define ___SYM__2b_ ___SYM(1,___S__2b_)
#define ___SYM__2d_ ___SYM(2,___S__2d_)
#define ___SYM__2f_ ___SYM(3,___S__2f_)
#define ___SYM__3c_ ___SYM(4,___S__3c_)
#define ___SYM__3c__3d_ ___SYM(5,___S__3c__3d_)
#define ___SYM__3d_ ___SYM(6,___S__3d_)
#define ___SYM__3e_ ___SYM(7,___S__3e_)
#define ___SYM__3e__3d_ ___SYM(8,___S__3e__3d_)
#define ___SYM_abandoned_2d_mutex_2d_exception_3f_ ___SYM(9,___S_abandoned_2d_mutex_2d_exception_3f_)
#define ___SYM_abort ___SYM(10,___S_abort)
#define ___SYM_abs ___SYM(11,___S_abs)
#define ___SYM_acos ___SYM(12,___S_acos)
#define ___SYM_address_2d_info_2d_family ___SYM(13,___S_address_2d_info_2d_family)
#define ___SYM_address_2d_info_2d_protocol ___SYM(14,___S_address_2d_info_2d_protocol)
#define ___SYM_address_2d_info_2d_socket_2d_info ___SYM(15,___S_address_2d_info_2d_socket_2d_info)
#define ___SYM_address_2d_info_2d_socket_2d_type ___SYM(16,___S_address_2d_info_2d_socket_2d_type)
#define ___SYM_address_2d_info_3f_ ___SYM(17,___S_address_2d_info_3f_)
#define ___SYM_address_2d_infos ___SYM(18,___S_address_2d_infos)
#define ___SYM_all_2d_bits_2d_set_3f_ ___SYM(19,___S_all_2d_bits_2d_set_3f_)
#define ___SYM_and ___SYM(20,___S_and)
#define ___SYM_angle ___SYM(21,___S_angle)
#define ___SYM_any_2d_bits_2d_set_3f_ ___SYM(22,___S_any_2d_bits_2d_set_3f_)
#define ___SYM_append ___SYM(23,___S_append)
#define ___SYM_append_2d_f32vectors ___SYM(24,___S_append_2d_f32vectors)
#define ___SYM_append_2d_f64vectors ___SYM(25,___S_append_2d_f64vectors)
#define ___SYM_append_2d_s16vectors ___SYM(26,___S_append_2d_s16vectors)
#define ___SYM_append_2d_s32vectors ___SYM(27,___S_append_2d_s32vectors)
#define ___SYM_append_2d_s64vectors ___SYM(28,___S_append_2d_s64vectors)
#define ___SYM_append_2d_s8vectors ___SYM(29,___S_append_2d_s8vectors)
#define ___SYM_append_2d_strings ___SYM(30,___S_append_2d_strings)
#define ___SYM_append_2d_u16vectors ___SYM(31,___S_append_2d_u16vectors)
#define ___SYM_append_2d_u32vectors ___SYM(32,___S_append_2d_u32vectors)
#define ___SYM_append_2d_u64vectors ___SYM(33,___S_append_2d_u64vectors)
#define ___SYM_append_2d_u8vectors ___SYM(34,___S_append_2d_u8vectors)
#define ___SYM_append_2d_vectors ___SYM(35,___S_append_2d_vectors)
#define ___SYM_apply ___SYM(36,___S_apply)
#define ___SYM_arithmetic_2d_shift ___SYM(37,___S_arithmetic_2d_shift)
#define ___SYM_asin ___SYM(38,___S_asin)
#define ___SYM_assoc ___SYM(39,___S_assoc)
#define ___SYM_assq ___SYM(40,___S_assq)
#define ___SYM_assv ___SYM(41,___S_assv)
#define ___SYM_atan ___SYM(42,___S_atan)
#define ___SYM_begin ___SYM(43,___S_begin)
#define ___SYM_bit_2d_count ___SYM(44,___S_bit_2d_count)
#define ___SYM_bit_2d_set_3f_ ___SYM(45,___S_bit_2d_set_3f_)
#define ___SYM_bitwise_2d_and ___SYM(46,___S_bitwise_2d_and)
#define ___SYM_bitwise_2d_ior ___SYM(47,___S_bitwise_2d_ior)
#define ___SYM_bitwise_2d_merge ___SYM(48,___S_bitwise_2d_merge)
#define ___SYM_bitwise_2d_not ___SYM(49,___S_bitwise_2d_not)
#define ___SYM_bitwise_2d_xor ___SYM(50,___S_bitwise_2d_xor)
#define ___SYM_boolean_3f_ ___SYM(51,___S_boolean_3f_)
#define ___SYM_box ___SYM(52,___S_box)
#define ___SYM_box_3f_ ___SYM(53,___S_box_3f_)
#define ___SYM_break ___SYM(54,___S_break)
#define ___SYM_c_2d_declare ___SYM(55,___S_c_2d_declare)
#define ___SYM_c_2d_define ___SYM(56,___S_c_2d_define)
#define ___SYM_c_2d_define_2d_type ___SYM(57,___S_c_2d_define_2d_type)
#define ___SYM_c_2d_initialize ___SYM(58,___S_c_2d_initialize)
#define ___SYM_c_2d_lambda ___SYM(59,___S_c_2d_lambda)
#define ___SYM_caar ___SYM(60,___S_caar)
#define ___SYM_cadr ___SYM(61,___S_cadr)
#define ___SYM_call_2d_with_2d_current_2d_continuation ___SYM(62,___S_call_2d_with_2d_current_2d_continuation)
#define ___SYM_call_2d_with_2d_input_2d_file ___SYM(63,___S_call_2d_with_2d_input_2d_file)
#define ___SYM_call_2d_with_2d_input_2d_process ___SYM(64,___S_call_2d_with_2d_input_2d_process)
#define ___SYM_call_2d_with_2d_input_2d_string ___SYM(65,___S_call_2d_with_2d_input_2d_string)
#define ___SYM_call_2d_with_2d_input_2d_u8vector ___SYM(66,___S_call_2d_with_2d_input_2d_u8vector)
#define ___SYM_call_2d_with_2d_input_2d_vector ___SYM(67,___S_call_2d_with_2d_input_2d_vector)
#define ___SYM_call_2d_with_2d_output_2d_file ___SYM(68,___S_call_2d_with_2d_output_2d_file)
#define ___SYM_call_2d_with_2d_output_2d_process ___SYM(69,___S_call_2d_with_2d_output_2d_process)
#define ___SYM_call_2d_with_2d_output_2d_string ___SYM(70,___S_call_2d_with_2d_output_2d_string)
#define ___SYM_call_2d_with_2d_output_2d_u8vector ___SYM(71,___S_call_2d_with_2d_output_2d_u8vector)
#define ___SYM_call_2d_with_2d_output_2d_vector ___SYM(72,___S_call_2d_with_2d_output_2d_vector)
#define ___SYM_call_2d_with_2d_values ___SYM(73,___S_call_2d_with_2d_values)
#define ___SYM_call_2f_cc ___SYM(74,___S_call_2f_cc)
#define ___SYM_car ___SYM(75,___S_car)
#define ___SYM_case ___SYM(76,___S_case)
#define ___SYM_cdddar ___SYM(77,___S_cdddar)
#define ___SYM_cddddr ___SYM(78,___S_cddddr)
#define ___SYM_cdr ___SYM(79,___S_cdr)
#define ___SYM_ceiling ___SYM(80,___S_ceiling)
#define ___SYM_cfun_2d_conversion_2d_exception_2d_arguments ___SYM(81,___S_cfun_2d_conversion_2d_exception_2d_arguments)
#define ___SYM_cfun_2d_conversion_2d_exception_2d_code ___SYM(82,___S_cfun_2d_conversion_2d_exception_2d_code)
#define ___SYM_cfun_2d_conversion_2d_exception_2d_message ___SYM(83,___S_cfun_2d_conversion_2d_exception_2d_message)
#define ___SYM_cfun_2d_conversion_2d_exception_2d_procedure ___SYM(84,___S_cfun_2d_conversion_2d_exception_2d_procedure)
#define ___SYM_cfun_2d_conversion_2d_exception_3f_ ___SYM(85,___S_cfun_2d_conversion_2d_exception_3f_)
#define ___SYM_char_2d__3e_integer ___SYM(86,___S_char_2d__3e_integer)
#define ___SYM_char_2d_alphabetic_3f_ ___SYM(87,___S_char_2d_alphabetic_3f_)
#define ___SYM_char_2d_ci_3c__3d__3f_ ___SYM(88,___S_char_2d_ci_3c__3d__3f_)
#define ___SYM_char_2d_ci_3c__3f_ ___SYM(89,___S_char_2d_ci_3c__3f_)
#define ___SYM_char_2d_ci_3d__3f_ ___SYM(90,___S_char_2d_ci_3d__3f_)
#define ___SYM_char_2d_ci_3e__3d__3f_ ___SYM(91,___S_char_2d_ci_3e__3d__3f_)
#define ___SYM_char_2d_ci_3e__3f_ ___SYM(92,___S_char_2d_ci_3e__3f_)
#define ___SYM_char_2d_downcase ___SYM(93,___S_char_2d_downcase)
#define ___SYM_char_2d_lower_2d_case_3f_ ___SYM(94,___S_char_2d_lower_2d_case_3f_)
#define ___SYM_char_2d_numeric_3f_ ___SYM(95,___S_char_2d_numeric_3f_)
#define ___SYM_char_2d_ready_3f_ ___SYM(96,___S_char_2d_ready_3f_)
#define ___SYM_char_2d_upcase ___SYM(97,___S_char_2d_upcase)
#define ___SYM_char_2d_upper_2d_case_3f_ ___SYM(98,___S_char_2d_upper_2d_case_3f_)
#define ___SYM_char_2d_whitespace_3f_ ___SYM(99,___S_char_2d_whitespace_3f_)
#define ___SYM_char_3c__3d__3f_ ___SYM(100,___S_char_3c__3d__3f_)
#define ___SYM_char_3c__3f_ ___SYM(101,___S_char_3c__3f_)
#define ___SYM_char_3d__3f_ ___SYM(102,___S_char_3d__3f_)
#define ___SYM_char_3e__3d__3f_ ___SYM(103,___S_char_3e__3d__3f_)
#define ___SYM_char_3e__3f_ ___SYM(104,___S_char_3e__3f_)
#define ___SYM_char_3f_ ___SYM(105,___S_char_3f_)
#define ___SYM_clear_2d_bit_2d_field ___SYM(106,___S_clear_2d_bit_2d_field)
#define ___SYM_close_2d_input_2d_port ___SYM(107,___S_close_2d_input_2d_port)
#define ___SYM_close_2d_output_2d_port ___SYM(108,___S_close_2d_output_2d_port)
#define ___SYM_close_2d_port ___SYM(109,___S_close_2d_port)
#define ___SYM_command_2d_line ___SYM(110,___S_command_2d_line)
#define ___SYM_compile_2d_file ___SYM(111,___S_compile_2d_file)
#define ___SYM_compile_2d_file_2d_to_2d_c ___SYM(112,___S_compile_2d_file_2d_to_2d_c)
#define ___SYM_complex_3f_ ___SYM(113,___S_complex_3f_)
#define ___SYM_cond ___SYM(114,___S_cond)
#define ___SYM_cond_2d_expand ___SYM(115,___S_cond_2d_expand)
#define ___SYM_condition_2d_variable_2d_broadcast_21_ ___SYM(116,___S_condition_2d_variable_2d_broadcast_21_)
#define ___SYM_condition_2d_variable_2d_name ___SYM(117,___S_condition_2d_variable_2d_name)
#define ___SYM_condition_2d_variable_2d_signal_21_ ___SYM(118,___S_condition_2d_variable_2d_signal_21_)
#define ___SYM_condition_2d_variable_2d_specific ___SYM(119,___S_condition_2d_variable_2d_specific)
#define ___SYM_condition_2d_variable_2d_specific_2d_set_21_ ___SYM(120,___S_condition_2d_variable_2d_specific_2d_set_21_)
#define ___SYM_condition_2d_variable_3f_ ___SYM(121,___S_condition_2d_variable_3f_)
#define ___SYM_configure_2d_command_2d_string ___SYM(122,___S_configure_2d_command_2d_string)
#define ___SYM_cons ___SYM(123,___S_cons)
#define ___SYM_console_2d_port ___SYM(124,___S_console_2d_port)
#define ___SYM_continuation_2d_capture ___SYM(125,___S_continuation_2d_capture)
#define ___SYM_continuation_2d_graft ___SYM(126,___S_continuation_2d_graft)
#define ___SYM_continuation_2d_return ___SYM(127,___S_continuation_2d_return)
#define ___SYM_continuation_3f_ ___SYM(128,___S_continuation_3f_)
#define ___SYM_copy_2d_bit_2d_field ___SYM(129,___S_copy_2d_bit_2d_field)
#define ___SYM_copy_2d_file ___SYM(130,___S_copy_2d_file)
#define ___SYM_cos ___SYM(131,___S_cos)
#define ___SYM_cpu_2d_time ___SYM(132,___S_cpu_2d_time)
#define ___SYM_create_2d_directory ___SYM(133,___S_create_2d_directory)
#define ___SYM_create_2d_fifo ___SYM(134,___S_create_2d_fifo)
#define ___SYM_create_2d_link ___SYM(135,___S_create_2d_link)
#define ___SYM_create_2d_symbolic_2d_link ___SYM(136,___S_create_2d_symbolic_2d_link)
#define ___SYM_current_2d_directory ___SYM(137,___S_current_2d_directory)
#define ___SYM_current_2d_error_2d_port ___SYM(138,___S_current_2d_error_2d_port)
#define ___SYM_current_2d_exception_2d_handler ___SYM(139,___S_current_2d_exception_2d_handler)
#define ___SYM_current_2d_input_2d_port ___SYM(140,___S_current_2d_input_2d_port)
#define ___SYM_current_2d_output_2d_port ___SYM(141,___S_current_2d_output_2d_port)
#define ___SYM_current_2d_readtable ___SYM(142,___S_current_2d_readtable)
#define ___SYM_current_2d_thread ___SYM(143,___S_current_2d_thread)
#define ___SYM_current_2d_time ___SYM(144,___S_current_2d_time)
#define ___SYM_current_2d_user_2d_interrupt_2d_handler ___SYM(145,___S_current_2d_user_2d_interrupt_2d_handler)
#define ___SYM_datum_2d_parsing_2d_exception_2d_kind ___SYM(146,___S_datum_2d_parsing_2d_exception_2d_kind)
#define ___SYM_datum_2d_parsing_2d_exception_2d_parameters ___SYM(147,___S_datum_2d_parsing_2d_exception_2d_parameters)
#define ___SYM_datum_2d_parsing_2d_exception_2d_readenv ___SYM(148,___S_datum_2d_parsing_2d_exception_2d_readenv)
#define ___SYM_datum_2d_parsing_2d_exception_3f_ ___SYM(149,___S_datum_2d_parsing_2d_exception_3f_)
#define ___SYM_deadlock_2d_exception_3f_ ___SYM(150,___S_deadlock_2d_exception_3f_)
#define ___SYM_declare ___SYM(151,___S_declare)
#define ___SYM_default_2d_random_2d_source ___SYM(152,___S_default_2d_random_2d_source)
#define ___SYM_defer_2d_user_2d_interrupts ___SYM(153,___S_defer_2d_user_2d_interrupts)
#define ___SYM_define ___SYM(154,___S_define)
#define ___SYM_define_2d_cond_2d_expand_2d_feature ___SYM(155,___S_define_2d_cond_2d_expand_2d_feature)
#define ___SYM_define_2d_macro ___SYM(156,___S_define_2d_macro)
#define ___SYM_define_2d_record_2d_type ___SYM(157,___S_define_2d_record_2d_type)
#define ___SYM_define_2d_structure ___SYM(158,___S_define_2d_structure)
#define ___SYM_define_2d_syntax ___SYM(159,___S_define_2d_syntax)
#define ___SYM_define_2d_type ___SYM(160,___S_define_2d_type)
#define ___SYM_define_2d_type_2d_of_2d_thread ___SYM(161,___S_define_2d_type_2d_of_2d_thread)
#define ___SYM_delay ___SYM(162,___S_delay)
#define ___SYM_delete_2d_directory ___SYM(163,___S_delete_2d_directory)
#define ___SYM_delete_2d_file ___SYM(164,___S_delete_2d_file)
#define ___SYM_denominator ___SYM(165,___S_denominator)
#define ___SYM_directory_2d_files ___SYM(166,___S_directory_2d_files)
#define ___SYM_display ___SYM(167,___S_display)
#define ___SYM_display_2d_continuation_2d_backtrace ___SYM(168,___S_display_2d_continuation_2d_backtrace)
#define ___SYM_display_2d_continuation_2d_dynamic_2d_environment ___SYM(169,___S_display_2d_continuation_2d_dynamic_2d_environment)
#define ___SYM_display_2d_continuation_2d_environment ___SYM(170,___S_display_2d_continuation_2d_environment)
#define ___SYM_display_2d_dynamic_2d_environment_3f_ ___SYM(171,___S_display_2d_dynamic_2d_environment_3f_)
#define ___SYM_display_2d_environment_2d_set_21_ ___SYM(172,___S_display_2d_environment_2d_set_21_)
#define ___SYM_display_2d_exception ___SYM(173,___S_display_2d_exception)
#define ___SYM_display_2d_exception_2d_in_2d_context ___SYM(174,___S_display_2d_exception_2d_in_2d_context)
#define ___SYM_display_2d_procedure_2d_environment ___SYM(175,___S_display_2d_procedure_2d_environment)
#define ___SYM_divide_2d_by_2d_zero_2d_exception_2d_arguments ___SYM(176,___S_divide_2d_by_2d_zero_2d_exception_2d_arguments)
#define ___SYM_divide_2d_by_2d_zero_2d_exception_2d_procedure ___SYM(177,___S_divide_2d_by_2d_zero_2d_exception_2d_procedure)
#define ___SYM_divide_2d_by_2d_zero_2d_exception_3f_ ___SYM(178,___S_divide_2d_by_2d_zero_2d_exception_3f_)
#define ___SYM_do ___SYM(179,___S_do)
#define ___SYM_dynamic_2d_wind ___SYM(180,___S_dynamic_2d_wind)
#define ___SYM_eof_2d_object_3f_ ___SYM(181,___S_eof_2d_object_3f_)
#define ___SYM_eq_3f_ ___SYM(182,___S_eq_3f_)
#define ___SYM_eq_3f__2d_hash ___SYM(183,___S_eq_3f__2d_hash)
#define ___SYM_equal_3f_ ___SYM(184,___S_equal_3f_)
#define ___SYM_equal_3f__2d_hash ___SYM(185,___S_equal_3f__2d_hash)
#define ___SYM_eqv_3f_ ___SYM(186,___S_eqv_3f_)
#define ___SYM_eqv_3f__2d_hash ___SYM(187,___S_eqv_3f__2d_hash)
#define ___SYM_err_2d_code_2d__3e_string ___SYM(188,___S_err_2d_code_2d__3e_string)
#define ___SYM_error ___SYM(189,___S_error)
#define ___SYM_error_2d_exception_2d_message ___SYM(190,___S_error_2d_exception_2d_message)
#define ___SYM_error_2d_exception_2d_parameters ___SYM(191,___S_error_2d_exception_2d_parameters)
#define ___SYM_error_2d_exception_3f_ ___SYM(192,___S_error_2d_exception_3f_)
#define ___SYM_eval ___SYM(193,___S_eval)
#define ___SYM_even_3f_ ___SYM(194,___S_even_3f_)
#define ___SYM_exact_2d__3e_inexact ___SYM(195,___S_exact_2d__3e_inexact)
#define ___SYM_exact_3f_ ___SYM(196,___S_exact_3f_)
#define ___SYM_exit ___SYM(197,___S_exit)
#define ___SYM_exp ___SYM(198,___S_exp)
#define ___SYM_expression_2d_parsing_2d_exception_2d_kind ___SYM(199,___S_expression_2d_parsing_2d_exception_2d_kind)
#define ___SYM_expression_2d_parsing_2d_exception_2d_parameters ___SYM(200,___S_expression_2d_parsing_2d_exception_2d_parameters)
#define ___SYM_expression_2d_parsing_2d_exception_2d_source ___SYM(201,___S_expression_2d_parsing_2d_exception_2d_source)
#define ___SYM_expression_2d_parsing_2d_exception_3f_ ___SYM(202,___S_expression_2d_parsing_2d_exception_3f_)
#define ___SYM_expt ___SYM(203,___S_expt)
#define ___SYM_extract_2d_bit_2d_field ___SYM(204,___S_extract_2d_bit_2d_field)
#define ___SYM_f32vector ___SYM(205,___S_f32vector)
#define ___SYM_f32vector_2d__3e_list ___SYM(206,___S_f32vector_2d__3e_list)
#define ___SYM_f32vector_2d_append ___SYM(207,___S_f32vector_2d_append)
#define ___SYM_f32vector_2d_copy ___SYM(208,___S_f32vector_2d_copy)
#define ___SYM_f32vector_2d_fill_21_ ___SYM(209,___S_f32vector_2d_fill_21_)
#define ___SYM_f32vector_2d_length ___SYM(210,___S_f32vector_2d_length)
#define ___SYM_f32vector_2d_ref ___SYM(211,___S_f32vector_2d_ref)
#define ___SYM_f32vector_2d_set_21_ ___SYM(212,___S_f32vector_2d_set_21_)
#define ___SYM_f32vector_2d_shrink_21_ ___SYM(213,___S_f32vector_2d_shrink_21_)
#define ___SYM_f32vector_3f_ ___SYM(214,___S_f32vector_3f_)
#define ___SYM_f64vector ___SYM(215,___S_f64vector)
#define ___SYM_f64vector_2d__3e_list ___SYM(216,___S_f64vector_2d__3e_list)
#define ___SYM_f64vector_2d_append ___SYM(217,___S_f64vector_2d_append)
#define ___SYM_f64vector_2d_copy ___SYM(218,___S_f64vector_2d_copy)
#define ___SYM_f64vector_2d_fill_21_ ___SYM(219,___S_f64vector_2d_fill_21_)
#define ___SYM_f64vector_2d_length ___SYM(220,___S_f64vector_2d_length)
#define ___SYM_f64vector_2d_ref ___SYM(221,___S_f64vector_2d_ref)
#define ___SYM_f64vector_2d_set_21_ ___SYM(222,___S_f64vector_2d_set_21_)
#define ___SYM_f64vector_2d_shrink_21_ ___SYM(223,___S_f64vector_2d_shrink_21_)
#define ___SYM_f64vector_3f_ ___SYM(224,___S_f64vector_3f_)
#define ___SYM_file_2d_attributes ___SYM(225,___S_file_2d_attributes)
#define ___SYM_file_2d_creation_2d_time ___SYM(226,___S_file_2d_creation_2d_time)
#define ___SYM_file_2d_device ___SYM(227,___S_file_2d_device)
#define ___SYM_file_2d_exists_3f_ ___SYM(228,___S_file_2d_exists_3f_)
#define ___SYM_file_2d_group ___SYM(229,___S_file_2d_group)
#define ___SYM_file_2d_info ___SYM(230,___S_file_2d_info)
#define ___SYM_file_2d_info_2d_attributes ___SYM(231,___S_file_2d_info_2d_attributes)
#define ___SYM_file_2d_info_2d_creation_2d_time ___SYM(232,___S_file_2d_info_2d_creation_2d_time)
#define ___SYM_file_2d_info_2d_device ___SYM(233,___S_file_2d_info_2d_device)
#define ___SYM_file_2d_info_2d_group ___SYM(234,___S_file_2d_info_2d_group)
#define ___SYM_file_2d_info_2d_inode ___SYM(235,___S_file_2d_info_2d_inode)
#define ___SYM_file_2d_info_2d_last_2d_access_2d_time ___SYM(236,___S_file_2d_info_2d_last_2d_access_2d_time)
#define ___SYM_file_2d_info_2d_last_2d_change_2d_time ___SYM(237,___S_file_2d_info_2d_last_2d_change_2d_time)
#define ___SYM_file_2d_info_2d_last_2d_modification_2d_time ___SYM(238,___S_file_2d_info_2d_last_2d_modification_2d_time)
#define ___SYM_file_2d_info_2d_mode ___SYM(239,___S_file_2d_info_2d_mode)
#define ___SYM_file_2d_info_2d_number_2d_of_2d_links ___SYM(240,___S_file_2d_info_2d_number_2d_of_2d_links)
#define ___SYM_file_2d_info_2d_owner ___SYM(241,___S_file_2d_info_2d_owner)
#define ___SYM_file_2d_info_2d_size ___SYM(242,___S_file_2d_info_2d_size)
#define ___SYM_file_2d_info_2d_type ___SYM(243,___S_file_2d_info_2d_type)
#define ___SYM_file_2d_info_3f_ ___SYM(244,___S_file_2d_info_3f_)
#define ___SYM_file_2d_inode ___SYM(245,___S_file_2d_inode)
#define ___SYM_file_2d_last_2d_access_2d_time ___SYM(246,___S_file_2d_last_2d_access_2d_time)
#define ___SYM_file_2d_last_2d_change_2d_time ___SYM(247,___S_file_2d_last_2d_change_2d_time)
#define ___SYM_file_2d_last_2d_modification_2d_time ___SYM(248,___S_file_2d_last_2d_modification_2d_time)
#define ___SYM_file_2d_mode ___SYM(249,___S_file_2d_mode)
#define ___SYM_file_2d_number_2d_of_2d_links ___SYM(250,___S_file_2d_number_2d_of_2d_links)
#define ___SYM_file_2d_owner ___SYM(251,___S_file_2d_owner)
#define ___SYM_file_2d_size ___SYM(252,___S_file_2d_size)
#define ___SYM_file_2d_type ___SYM(253,___S_file_2d_type)
#define ___SYM_finite_3f_ ___SYM(254,___S_finite_3f_)
#define ___SYM_first_2d_bit_2d_set ___SYM(255,___S_first_2d_bit_2d_set)
#define ___SYM_fixnum_2d__3e_flonum ___SYM(256,___S_fixnum_2d__3e_flonum)
#define ___SYM_fixnum_2d_overflow_2d_exception_2d_arguments ___SYM(257,___S_fixnum_2d_overflow_2d_exception_2d_arguments)
#define ___SYM_fixnum_2d_overflow_2d_exception_2d_procedure ___SYM(258,___S_fixnum_2d_overflow_2d_exception_2d_procedure)
#define ___SYM_fixnum_2d_overflow_2d_exception_3f_ ___SYM(259,___S_fixnum_2d_overflow_2d_exception_3f_)
#define ___SYM_fixnum_3f_ ___SYM(260,___S_fixnum_3f_)
#define ___SYM_fl_2a_ ___SYM(261,___S_fl_2a_)
#define ___SYM_fl_2b_ ___SYM(262,___S_fl_2b_)
#define ___SYM_fl_2d_ ___SYM(263,___S_fl_2d_)
#define ___SYM_fl_2f_ ___SYM(264,___S_fl_2f_)
#define ___SYM_fl_3c_ ___SYM(265,___S_fl_3c_)
#define ___SYM_fl_3c__3d_ ___SYM(266,___S_fl_3c__3d_)
#define ___SYM_fl_3d_ ___SYM(267,___S_fl_3d_)
#define ___SYM_fl_3e_ ___SYM(268,___S_fl_3e_)
#define ___SYM_fl_3e__3d_ ___SYM(269,___S_fl_3e__3d_)
#define ___SYM_flabs ___SYM(270,___S_flabs)
#define ___SYM_flacos ___SYM(271,___S_flacos)
#define ___SYM_flasin ___SYM(272,___S_flasin)
#define ___SYM_flatan ___SYM(273,___S_flatan)
#define ___SYM_flceiling ___SYM(274,___S_flceiling)
#define ___SYM_flcos ___SYM(275,___S_flcos)
#define ___SYM_fldenominator ___SYM(276,___S_fldenominator)
#define ___SYM_fleven_3f_ ___SYM(277,___S_fleven_3f_)
#define ___SYM_flexp ___SYM(278,___S_flexp)
#define ___SYM_flexpt ___SYM(279,___S_flexpt)
#define ___SYM_flfinite_3f_ ___SYM(280,___S_flfinite_3f_)
#define ___SYM_flfloor ___SYM(281,___S_flfloor)
#define ___SYM_flinfinite_3f_ ___SYM(282,___S_flinfinite_3f_)
#define ___SYM_flinteger_3f_ ___SYM(283,___S_flinteger_3f_)
#define ___SYM_fllog ___SYM(284,___S_fllog)
#define ___SYM_flmax ___SYM(285,___S_flmax)
#define ___SYM_flmin ___SYM(286,___S_flmin)
#define ___SYM_flnan_3f_ ___SYM(287,___S_flnan_3f_)
#define ___SYM_flnegative_3f_ ___SYM(288,___S_flnegative_3f_)
#define ___SYM_flnumerator ___SYM(289,___S_flnumerator)
#define ___SYM_flodd_3f_ ___SYM(290,___S_flodd_3f_)
#define ___SYM_flonum_3f_ ___SYM(291,___S_flonum_3f_)
#define ___SYM_floor ___SYM(292,___S_floor)
#define ___SYM_flpositive_3f_ ___SYM(293,___S_flpositive_3f_)
#define ___SYM_flround ___SYM(294,___S_flround)
#define ___SYM_flsin ___SYM(295,___S_flsin)
#define ___SYM_flsqrt ___SYM(296,___S_flsqrt)
#define ___SYM_fltan ___SYM(297,___S_fltan)
#define ___SYM_fltruncate ___SYM(298,___S_fltruncate)
#define ___SYM_flzero_3f_ ___SYM(299,___S_flzero_3f_)
#define ___SYM_for_2d_each ___SYM(300,___S_for_2d_each)
#define ___SYM_force ___SYM(301,___S_force)
#define ___SYM_force_2d_output ___SYM(302,___S_force_2d_output)
#define ___SYM_foreign_2d_address ___SYM(303,___S_foreign_2d_address)
#define ___SYM_foreign_2d_release_21_ ___SYM(304,___S_foreign_2d_release_21_)
#define ___SYM_foreign_2d_released_3f_ ___SYM(305,___S_foreign_2d_released_3f_)
#define ___SYM_foreign_2d_tags ___SYM(306,___S_foreign_2d_tags)
#define ___SYM_foreign_3f_ ___SYM(307,___S_foreign_3f_)
#define ___SYM_future ___SYM(308,___S_future)
#define ___SYM_fx_2a_ ___SYM(309,___S_fx_2a_)
#define ___SYM_fx_2b_ ___SYM(310,___S_fx_2b_)
#define ___SYM_fx_2d_ ___SYM(311,___S_fx_2d_)
#define ___SYM_fx_3c_ ___SYM(312,___S_fx_3c_)
#define ___SYM_fx_3c__3d_ ___SYM(313,___S_fx_3c__3d_)
#define ___SYM_fx_3d_ ___SYM(314,___S_fx_3d_)
#define ___SYM_fx_3e_ ___SYM(315,___S_fx_3e_)
#define ___SYM_fx_3e__3d_ ___SYM(316,___S_fx_3e__3d_)
#define ___SYM_fxabs ___SYM(317,___S_fxabs)
#define ___SYM_fxand ___SYM(318,___S_fxand)
#define ___SYM_fxarithmetic_2d_shift ___SYM(319,___S_fxarithmetic_2d_shift)
#define ___SYM_fxarithmetic_2d_shift_2d_left ___SYM(320,___S_fxarithmetic_2d_shift_2d_left)
#define ___SYM_fxarithmetic_2d_shift_2d_right ___SYM(321,___S_fxarithmetic_2d_shift_2d_right)
#define ___SYM_fxbit_2d_count ___SYM(322,___S_fxbit_2d_count)
#define ___SYM_fxbit_2d_set_3f_ ___SYM(323,___S_fxbit_2d_set_3f_)
#define ___SYM_fxeven_3f_ ___SYM(324,___S_fxeven_3f_)
#define ___SYM_fxfirst_2d_bit_2d_set ___SYM(325,___S_fxfirst_2d_bit_2d_set)
#define ___SYM_fxif ___SYM(326,___S_fxif)
#define ___SYM_fxior ___SYM(327,___S_fxior)
#define ___SYM_fxlength ___SYM(328,___S_fxlength)
#define ___SYM_fxmax ___SYM(329,___S_fxmax)
#define ___SYM_fxmin ___SYM(330,___S_fxmin)
#define ___SYM_fxmodulo ___SYM(331,___S_fxmodulo)
#define ___SYM_fxnegative_3f_ ___SYM(332,___S_fxnegative_3f_)
#define ___SYM_fxnot ___SYM(333,___S_fxnot)
#define ___SYM_fxodd_3f_ ___SYM(334,___S_fxodd_3f_)
#define ___SYM_fxpositive_3f_ ___SYM(335,___S_fxpositive_3f_)
#define ___SYM_fxquotient ___SYM(336,___S_fxquotient)
#define ___SYM_fxremainder ___SYM(337,___S_fxremainder)
#define ___SYM_fxwrap_2a_ ___SYM(338,___S_fxwrap_2a_)
#define ___SYM_fxwrap_2b_ ___SYM(339,___S_fxwrap_2b_)
#define ___SYM_fxwrap_2d_ ___SYM(340,___S_fxwrap_2d_)
#define ___SYM_fxwrapabs ___SYM(341,___S_fxwrapabs)
#define ___SYM_fxwraparithmetic_2d_shift ___SYM(342,___S_fxwraparithmetic_2d_shift)
#define ___SYM_fxwraparithmetic_2d_shift_2d_left ___SYM(343,___S_fxwraparithmetic_2d_shift_2d_left)
#define ___SYM_fxwraplogical_2d_shift_2d_right ___SYM(344,___S_fxwraplogical_2d_shift_2d_right)
#define ___SYM_fxwrapquotient ___SYM(345,___S_fxwrapquotient)
#define ___SYM_fxxor ___SYM(346,___S_fxxor)
#define ___SYM_fxzero_3f_ ___SYM(347,___S_fxzero_3f_)
#define ___SYM_gc_2d_report_2d_set_21_ ___SYM(348,___S_gc_2d_report_2d_set_21_)
#define ___SYM_gcd ___SYM(349,___S_gcd)
#define ___SYM_generate_2d_proper_2d_tail_2d_calls ___SYM(350,___S_generate_2d_proper_2d_tail_2d_calls)
#define ___SYM_gensym ___SYM(351,___S_gensym)
#define ___SYM_get_2d_output_2d_string ___SYM(352,___S_get_2d_output_2d_string)
#define ___SYM_get_2d_output_2d_u8vector ___SYM(353,___S_get_2d_output_2d_u8vector)
#define ___SYM_get_2d_output_2d_vector ___SYM(354,___S_get_2d_output_2d_vector)
#define ___SYM_getenv ___SYM(355,___S_getenv)
#define ___SYM_group_2d_info ___SYM(356,___S_group_2d_info)
#define ___SYM_group_2d_info_2d_gid ___SYM(357,___S_group_2d_info_2d_gid)
#define ___SYM_group_2d_info_2d_members ___SYM(358,___S_group_2d_info_2d_members)
#define ___SYM_group_2d_info_2d_name ___SYM(359,___S_group_2d_info_2d_name)
#define ___SYM_group_2d_info_3f_ ___SYM(360,___S_group_2d_info_3f_)
#define ___SYM_heap_2d_overflow_2d_exception_3f_ ___SYM(361,___S_heap_2d_overflow_2d_exception_3f_)
#define ___SYM_help ___SYM(362,___S_help)
#define ___SYM_help_2d_browser ___SYM(363,___S_help_2d_browser)
#define ___SYM_host_2d_info ___SYM(364,___S_host_2d_info)
#define ___SYM_host_2d_info_2d_addresses ___SYM(365,___S_host_2d_info_2d_addresses)
#define ___SYM_host_2d_info_2d_aliases ___SYM(366,___S_host_2d_info_2d_aliases)
#define ___SYM_host_2d_info_2d_name ___SYM(367,___S_host_2d_info_2d_name)
#define ___SYM_host_2d_info_3f_ ___SYM(368,___S_host_2d_info_3f_)
#define ___SYM_host_2d_name ___SYM(369,___S_host_2d_name)
#define ___SYM_if ___SYM(370,___S_if)
#define ___SYM_imag_2d_part ___SYM(371,___S_imag_2d_part)
#define ___SYM_improper_2d_length_2d_list_2d_exception_2d_arg_2d_num ___SYM(372,___S_improper_2d_length_2d_list_2d_exception_2d_arg_2d_num)
#define ___SYM_improper_2d_length_2d_list_2d_exception_2d_arguments ___SYM(373,___S_improper_2d_length_2d_list_2d_exception_2d_arguments)
#define ___SYM_improper_2d_length_2d_list_2d_exception_2d_procedure ___SYM(374,___S_improper_2d_length_2d_list_2d_exception_2d_procedure)
#define ___SYM_improper_2d_length_2d_list_2d_exception_3f_ ___SYM(375,___S_improper_2d_length_2d_list_2d_exception_3f_)
#define ___SYM_inactive_2d_thread_2d_exception_2d_arguments ___SYM(376,___S_inactive_2d_thread_2d_exception_2d_arguments)
#define ___SYM_inactive_2d_thread_2d_exception_2d_procedure ___SYM(377,___S_inactive_2d_thread_2d_exception_2d_procedure)
#define ___SYM_inactive_2d_thread_2d_exception_3f_ ___SYM(378,___S_inactive_2d_thread_2d_exception_3f_)
#define ___SYM_include ___SYM(379,___S_include)
#define ___SYM_inexact_2d__3e_exact ___SYM(380,___S_inexact_2d__3e_exact)
#define ___SYM_inexact_3f_ ___SYM(381,___S_inexact_3f_)
#define ___SYM_infinite_3f_ ___SYM(382,___S_infinite_3f_)
#define ___SYM_initialized_2d_thread_2d_exception_2d_arguments ___SYM(383,___S_initialized_2d_thread_2d_exception_2d_arguments)
#define ___SYM_initialized_2d_thread_2d_exception_2d_procedure ___SYM(384,___S_initialized_2d_thread_2d_exception_2d_procedure)
#define ___SYM_initialized_2d_thread_2d_exception_3f_ ___SYM(385,___S_initialized_2d_thread_2d_exception_3f_)
#define ___SYM_input_2d_port_2d_byte_2d_position ___SYM(386,___S_input_2d_port_2d_byte_2d_position)
#define ___SYM_input_2d_port_2d_bytes_2d_buffered ___SYM(387,___S_input_2d_port_2d_bytes_2d_buffered)
#define ___SYM_input_2d_port_2d_char_2d_position ___SYM(388,___S_input_2d_port_2d_char_2d_position)
#define ___SYM_input_2d_port_2d_characters_2d_buffered ___SYM(389,___S_input_2d_port_2d_characters_2d_buffered)
#define ___SYM_input_2d_port_2d_column ___SYM(390,___S_input_2d_port_2d_column)
#define ___SYM_input_2d_port_2d_line ___SYM(391,___S_input_2d_port_2d_line)
#define ___SYM_input_2d_port_2d_readtable ___SYM(392,___S_input_2d_port_2d_readtable)
#define ___SYM_input_2d_port_2d_readtable_2d_set_21_ ___SYM(393,___S_input_2d_port_2d_readtable_2d_set_21_)
#define ___SYM_input_2d_port_2d_timeout_2d_set_21_ ___SYM(394,___S_input_2d_port_2d_timeout_2d_set_21_)
#define ___SYM_input_2d_port_3f_ ___SYM(395,___S_input_2d_port_3f_)
#define ___SYM_integer_2d__3e_char ___SYM(396,___S_integer_2d__3e_char)
#define ___SYM_integer_2d_length ___SYM(397,___S_integer_2d_length)
#define ___SYM_integer_2d_nth_2d_root ___SYM(398,___S_integer_2d_nth_2d_root)
#define ___SYM_integer_2d_sqrt ___SYM(399,___S_integer_2d_sqrt)
#define ___SYM_integer_3f_ ___SYM(400,___S_integer_3f_)
#define ___SYM_interaction_2d_environment ___SYM(401,___S_interaction_2d_environment)
#define ___SYM_invalid_2d_hash_2d_number_2d_exception_2d_arguments ___SYM(402,___S_invalid_2d_hash_2d_number_2d_exception_2d_arguments)
#define ___SYM_invalid_2d_hash_2d_number_2d_exception_2d_procedure ___SYM(403,___S_invalid_2d_hash_2d_number_2d_exception_2d_procedure)
#define ___SYM_invalid_2d_hash_2d_number_2d_exception_3f_ ___SYM(404,___S_invalid_2d_hash_2d_number_2d_exception_3f_)
#define ___SYM_join_2d_timeout_2d_exception_2d_arguments ___SYM(405,___S_join_2d_timeout_2d_exception_2d_arguments)
#define ___SYM_join_2d_timeout_2d_exception_2d_procedure ___SYM(406,___S_join_2d_timeout_2d_exception_2d_procedure)
#define ___SYM_join_2d_timeout_2d_exception_3f_ ___SYM(407,___S_join_2d_timeout_2d_exception_3f_)
#define ___SYM_keyword_2d__3e_string ___SYM(408,___S_keyword_2d__3e_string)
#define ___SYM_keyword_2d_expected_2d_exception_2d_arguments ___SYM(409,___S_keyword_2d_expected_2d_exception_2d_arguments)
#define ___SYM_keyword_2d_expected_2d_exception_2d_procedure ___SYM(410,___S_keyword_2d_expected_2d_exception_2d_procedure)
#define ___SYM_keyword_2d_expected_2d_exception_3f_ ___SYM(411,___S_keyword_2d_expected_2d_exception_3f_)
#define ___SYM_keyword_2d_hash ___SYM(412,___S_keyword_2d_hash)
#define ___SYM_keyword_3f_ ___SYM(413,___S_keyword_3f_)
#define ___SYM_lambda ___SYM(414,___S_lambda)
#define ___SYM_lcm ___SYM(415,___S_lcm)
#define ___SYM_length ___SYM(416,___S_length)
#define ___SYM_let ___SYM(417,___S_let)
#define ___SYM_let_2a_ ___SYM(418,___S_let_2a_)
#define ___SYM_let_2d_syntax ___SYM(419,___S_let_2d_syntax)
#define ___SYM_letrec ___SYM(420,___S_letrec)
#define ___SYM_letrec_2d_syntax ___SYM(421,___S_letrec_2d_syntax)
#define ___SYM_link_2d_flat ___SYM(422,___S_link_2d_flat)
#define ___SYM_link_2d_incremental ___SYM(423,___S_link_2d_incremental)
#define ___SYM_list ___SYM(424,___S_list)
#define ___SYM_list_2d__3e_f32vector ___SYM(425,___S_list_2d__3e_f32vector)
#define ___SYM_list_2d__3e_f64vector ___SYM(426,___S_list_2d__3e_f64vector)
#define ___SYM_list_2d__3e_s16vector ___SYM(427,___S_list_2d__3e_s16vector)
#define ___SYM_list_2d__3e_s32vector ___SYM(428,___S_list_2d__3e_s32vector)
#define ___SYM_list_2d__3e_s64vector ___SYM(429,___S_list_2d__3e_s64vector)
#define ___SYM_list_2d__3e_s8vector ___SYM(430,___S_list_2d__3e_s8vector)
#define ___SYM_list_2d__3e_string ___SYM(431,___S_list_2d__3e_string)
#define ___SYM_list_2d__3e_table ___SYM(432,___S_list_2d__3e_table)
#define ___SYM_list_2d__3e_u16vector ___SYM(433,___S_list_2d__3e_u16vector)
#define ___SYM_list_2d__3e_u32vector ___SYM(434,___S_list_2d__3e_u32vector)
#define ___SYM_list_2d__3e_u64vector ___SYM(435,___S_list_2d__3e_u64vector)
#define ___SYM_list_2d__3e_u8vector ___SYM(436,___S_list_2d__3e_u8vector)
#define ___SYM_list_2d__3e_vector ___SYM(437,___S_list_2d__3e_vector)
#define ___SYM_list_2d_ref ___SYM(438,___S_list_2d_ref)
#define ___SYM_list_2d_tail ___SYM(439,___S_list_2d_tail)
#define ___SYM_list_3f_ ___SYM(440,___S_list_3f_)
#define ___SYM_load ___SYM(441,___S_load)
#define ___SYM_log ___SYM(442,___S_log)
#define ___SYM_magnitude ___SYM(443,___S_magnitude)
#define ___SYM_mailbox_2d_receive_2d_timeout_2d_exception_2d_arguments ___SYM(444,___S_mailbox_2d_receive_2d_timeout_2d_exception_2d_arguments)
#define ___SYM_mailbox_2d_receive_2d_timeout_2d_exception_2d_procedure ___SYM(445,___S_mailbox_2d_receive_2d_timeout_2d_exception_2d_procedure)
#define ___SYM_mailbox_2d_receive_2d_timeout_2d_exception_3f_ ___SYM(446,___S_mailbox_2d_receive_2d_timeout_2d_exception_3f_)
#define ___SYM_main ___SYM(447,___S_main)
#define ___SYM_make_2d_condition_2d_variable ___SYM(448,___S_make_2d_condition_2d_variable)
#define ___SYM_make_2d_f32vector ___SYM(449,___S_make_2d_f32vector)
#define ___SYM_make_2d_f64vector ___SYM(450,___S_make_2d_f64vector)
#define ___SYM_make_2d_mutex ___SYM(451,___S_make_2d_mutex)
#define ___SYM_make_2d_parameter ___SYM(452,___S_make_2d_parameter)
#define ___SYM_make_2d_polar ___SYM(453,___S_make_2d_polar)
#define ___SYM_make_2d_random_2d_source ___SYM(454,___S_make_2d_random_2d_source)
#define ___SYM_make_2d_rectangular ___SYM(455,___S_make_2d_rectangular)
#define ___SYM_make_2d_root_2d_thread ___SYM(456,___S_make_2d_root_2d_thread)
#define ___SYM_make_2d_s16vector ___SYM(457,___S_make_2d_s16vector)
#define ___SYM_make_2d_s32vector ___SYM(458,___S_make_2d_s32vector)
#define ___SYM_make_2d_s64vector ___SYM(459,___S_make_2d_s64vector)
#define ___SYM_make_2d_s8vector ___SYM(460,___S_make_2d_s8vector)
#define ___SYM_make_2d_string ___SYM(461,___S_make_2d_string)
#define ___SYM_make_2d_table ___SYM(462,___S_make_2d_table)
#define ___SYM_make_2d_thread ___SYM(463,___S_make_2d_thread)
#define ___SYM_make_2d_thread_2d_group ___SYM(464,___S_make_2d_thread_2d_group)
#define ___SYM_make_2d_u16vector ___SYM(465,___S_make_2d_u16vector)
#define ___SYM_make_2d_u32vector ___SYM(466,___S_make_2d_u32vector)
#define ___SYM_make_2d_u64vector ___SYM(467,___S_make_2d_u64vector)
#define ___SYM_make_2d_u8vector ___SYM(468,___S_make_2d_u8vector)
#define ___SYM_make_2d_uninterned_2d_keyword ___SYM(469,___S_make_2d_uninterned_2d_keyword)
#define ___SYM_make_2d_uninterned_2d_symbol ___SYM(470,___S_make_2d_uninterned_2d_symbol)
#define ___SYM_make_2d_vector ___SYM(471,___S_make_2d_vector)
#define ___SYM_make_2d_will ___SYM(472,___S_make_2d_will)
#define ___SYM_map ___SYM(473,___S_map)
#define ___SYM_max ___SYM(474,___S_max)
#define ___SYM_member ___SYM(475,___S_member)
#define ___SYM_memq ___SYM(476,___S_memq)
#define ___SYM_memv ___SYM(477,___S_memv)
#define ___SYM_min ___SYM(478,___S_min)
#define ___SYM_modulo ___SYM(479,___S_modulo)
#define ___SYM_multiple_2d_c_2d_return_2d_exception_3f_ ___SYM(480,___S_multiple_2d_c_2d_return_2d_exception_3f_)
#define ___SYM_mutex_2d_lock_21_ ___SYM(481,___S_mutex_2d_lock_21_)
#define ___SYM_mutex_2d_name ___SYM(482,___S_mutex_2d_name)
#define ___SYM_mutex_2d_specific ___SYM(483,___S_mutex_2d_specific)
#define ___SYM_mutex_2d_specific_2d_set_21_ ___SYM(484,___S_mutex_2d_specific_2d_set_21_)
#define ___SYM_mutex_2d_state ___SYM(485,___S_mutex_2d_state)
#define ___SYM_mutex_2d_unlock_21_ ___SYM(486,___S_mutex_2d_unlock_21_)
#define ___SYM_mutex_3f_ ___SYM(487,___S_mutex_3f_)
#define ___SYM_namespace ___SYM(488,___S_namespace)
#define ___SYM_nan_3f_ ___SYM(489,___S_nan_3f_)
#define ___SYM_negative_3f_ ___SYM(490,___S_negative_3f_)
#define ___SYM_network_2d_info ___SYM(491,___S_network_2d_info)
#define ___SYM_network_2d_info_2d_aliases ___SYM(492,___S_network_2d_info_2d_aliases)
#define ___SYM_network_2d_info_2d_name ___SYM(493,___S_network_2d_info_2d_name)
#define ___SYM_network_2d_info_2d_number ___SYM(494,___S_network_2d_info_2d_number)
#define ___SYM_network_2d_info_3f_ ___SYM(495,___S_network_2d_info_3f_)
#define ___SYM_newline ___SYM(496,___S_newline)
#define ___SYM_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments ___SYM(497,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments)
#define ___SYM_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure ___SYM(498,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure)
#define ___SYM_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_ ___SYM(499,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_)
#define ___SYM_noncontinuable_2d_exception_2d_reason ___SYM(500,___S_noncontinuable_2d_exception_2d_reason)
#define ___SYM_noncontinuable_2d_exception_3f_ ___SYM(501,___S_noncontinuable_2d_exception_3f_)
#define ___SYM_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_2d_arguments ___SYM(502,___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_2d_arguments)
#define ___SYM_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_2d_procedure ___SYM(503,___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_2d_procedure)
#define ___SYM_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_3f_ ___SYM(504,___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_3f_)
#define ___SYM_nonprocedure_2d_operator_2d_exception_2d_arguments ___SYM(505,___S_nonprocedure_2d_operator_2d_exception_2d_arguments)
#define ___SYM_nonprocedure_2d_operator_2d_exception_2d_code ___SYM(506,___S_nonprocedure_2d_operator_2d_exception_2d_code)
#define ___SYM_nonprocedure_2d_operator_2d_exception_2d_operator ___SYM(507,___S_nonprocedure_2d_operator_2d_exception_2d_operator)
#define ___SYM_nonprocedure_2d_operator_2d_exception_2d_rte ___SYM(508,___S_nonprocedure_2d_operator_2d_exception_2d_rte)
#define ___SYM_nonprocedure_2d_operator_2d_exception_3f_ ___SYM(509,___S_nonprocedure_2d_operator_2d_exception_3f_)
#define ___SYM_not ___SYM(510,___S_not)
#define ___SYM_null_2d_environment ___SYM(511,___S_null_2d_environment)
#define ___SYM_null_3f_ ___SYM(512,___S_null_3f_)
#define ___SYM_number_2d__3e_string ___SYM(513,___S_number_2d__3e_string)
#define ___SYM_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments ___SYM(514,___S_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments)
#define ___SYM_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure ___SYM(515,___S_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure)
#define ___SYM_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_ ___SYM(516,___S_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_)
#define ___SYM_number_3f_ ___SYM(517,___S_number_3f_)
#define ___SYM_numerator ___SYM(518,___S_numerator)
#define ___SYM_object_2d__3e_serial_2d_number ___SYM(519,___S_object_2d__3e_serial_2d_number)
#define ___SYM_object_2d__3e_string ___SYM(520,___S_object_2d__3e_string)
#define ___SYM_object_2d__3e_u8vector ___SYM(521,___S_object_2d__3e_u8vector)
#define ___SYM_odd_3f_ ___SYM(522,___S_odd_3f_)
#define ___SYM_open_2d_directory ___SYM(523,___S_open_2d_directory)
#define ___SYM_open_2d_dummy ___SYM(524,___S_open_2d_dummy)
#define ___SYM_open_2d_event_2d_queue ___SYM(525,___S_open_2d_event_2d_queue)
#define ___SYM_open_2d_file ___SYM(526,___S_open_2d_file)
#define ___SYM_open_2d_input_2d_file ___SYM(527,___S_open_2d_input_2d_file)
#define ___SYM_open_2d_input_2d_process ___SYM(528,___S_open_2d_input_2d_process)
#define ___SYM_open_2d_input_2d_string ___SYM(529,___S_open_2d_input_2d_string)
#define ___SYM_open_2d_input_2d_u8vector ___SYM(530,___S_open_2d_input_2d_u8vector)
#define ___SYM_open_2d_input_2d_vector ___SYM(531,___S_open_2d_input_2d_vector)
#define ___SYM_open_2d_output_2d_file ___SYM(532,___S_open_2d_output_2d_file)
#define ___SYM_open_2d_output_2d_process ___SYM(533,___S_open_2d_output_2d_process)
#define ___SYM_open_2d_output_2d_string ___SYM(534,___S_open_2d_output_2d_string)
#define ___SYM_open_2d_output_2d_u8vector ___SYM(535,___S_open_2d_output_2d_u8vector)
#define ___SYM_open_2d_output_2d_vector ___SYM(536,___S_open_2d_output_2d_vector)
#define ___SYM_open_2d_process ___SYM(537,___S_open_2d_process)
#define ___SYM_open_2d_string ___SYM(538,___S_open_2d_string)
#define ___SYM_open_2d_string_2d_pipe ___SYM(539,___S_open_2d_string_2d_pipe)
#define ___SYM_open_2d_tcp_2d_client ___SYM(540,___S_open_2d_tcp_2d_client)
#define ___SYM_open_2d_tcp_2d_server ___SYM(541,___S_open_2d_tcp_2d_server)
#define ___SYM_open_2d_u8vector ___SYM(542,___S_open_2d_u8vector)
#define ___SYM_open_2d_u8vector_2d_pipe ___SYM(543,___S_open_2d_u8vector_2d_pipe)
#define ___SYM_open_2d_vector ___SYM(544,___S_open_2d_vector)
#define ___SYM_open_2d_vector_2d_pipe ___SYM(545,___S_open_2d_vector_2d_pipe)
#define ___SYM_or ___SYM(546,___S_or)
#define ___SYM_os_2d_exception_2d_arguments ___SYM(547,___S_os_2d_exception_2d_arguments)
#define ___SYM_os_2d_exception_2d_code ___SYM(548,___S_os_2d_exception_2d_code)
#define ___SYM_os_2d_exception_2d_message ___SYM(549,___S_os_2d_exception_2d_message)
#define ___SYM_os_2d_exception_2d_procedure ___SYM(550,___S_os_2d_exception_2d_procedure)
#define ___SYM_os_2d_exception_3f_ ___SYM(551,___S_os_2d_exception_3f_)
#define ___SYM_output_2d_port_2d_byte_2d_position ___SYM(552,___S_output_2d_port_2d_byte_2d_position)
#define ___SYM_output_2d_port_2d_char_2d_position ___SYM(553,___S_output_2d_port_2d_char_2d_position)
#define ___SYM_output_2d_port_2d_column ___SYM(554,___S_output_2d_port_2d_column)
#define ___SYM_output_2d_port_2d_line ___SYM(555,___S_output_2d_port_2d_line)
#define ___SYM_output_2d_port_2d_readtable ___SYM(556,___S_output_2d_port_2d_readtable)
#define ___SYM_output_2d_port_2d_readtable_2d_set_21_ ___SYM(557,___S_output_2d_port_2d_readtable_2d_set_21_)
#define ___SYM_output_2d_port_2d_timeout_2d_set_21_ ___SYM(558,___S_output_2d_port_2d_timeout_2d_set_21_)
#define ___SYM_output_2d_port_2d_width ___SYM(559,___S_output_2d_port_2d_width)
#define ___SYM_output_2d_port_3f_ ___SYM(560,___S_output_2d_port_3f_)
#define ___SYM_pair_3f_ ___SYM(561,___S_pair_3f_)
#define ___SYM_parameterize ___SYM(562,___S_parameterize)
#define ___SYM_path_2d_directory ___SYM(563,___S_path_2d_directory)
#define ___SYM_path_2d_expand ___SYM(564,___S_path_2d_expand)
#define ___SYM_path_2d_extension ___SYM(565,___S_path_2d_extension)
#define ___SYM_path_2d_normalize ___SYM(566,___S_path_2d_normalize)
#define ___SYM_path_2d_strip_2d_directory ___SYM(567,___S_path_2d_strip_2d_directory)
#define ___SYM_path_2d_strip_2d_extension ___SYM(568,___S_path_2d_strip_2d_extension)
#define ___SYM_path_2d_strip_2d_trailing_2d_directory_2d_separator ___SYM(569,___S_path_2d_strip_2d_trailing_2d_directory_2d_separator)
#define ___SYM_path_2d_strip_2d_volume ___SYM(570,___S_path_2d_strip_2d_volume)
#define ___SYM_path_2d_volume ___SYM(571,___S_path_2d_volume)
#define ___SYM_peek_2d_char ___SYM(572,___S_peek_2d_char)
#define ___SYM_port_2d_settings_2d_set_21_ ___SYM(573,___S_port_2d_settings_2d_set_21_)
#define ___SYM_port_3f_ ___SYM(574,___S_port_3f_)
#define ___SYM_positive_3f_ ___SYM(575,___S_positive_3f_)
#define ___SYM_pp ___SYM(576,___S_pp)
#define ___SYM_pretty_2d_print ___SYM(577,___S_pretty_2d_print)
#define ___SYM_primordial_2d_exception_2d_handler ___SYM(578,___S_primordial_2d_exception_2d_handler)
#define ___SYM_print ___SYM(579,___S_print)
#define ___SYM_println ___SYM(580,___S_println)
#define ___SYM_procedure_3f_ ___SYM(581,___S_procedure_3f_)
#define ___SYM_process_2d_pid ___SYM(582,___S_process_2d_pid)
#define ___SYM_process_2d_status ___SYM(583,___S_process_2d_status)
#define ___SYM_process_2d_times ___SYM(584,___S_process_2d_times)
#define ___SYM_protocol_2d_info ___SYM(585,___S_protocol_2d_info)
#define ___SYM_protocol_2d_info_2d_aliases ___SYM(586,___S_protocol_2d_info_2d_aliases)
#define ___SYM_protocol_2d_info_2d_name ___SYM(587,___S_protocol_2d_info_2d_name)
#define ___SYM_protocol_2d_info_2d_number ___SYM(588,___S_protocol_2d_info_2d_number)
#define ___SYM_protocol_2d_info_3f_ ___SYM(589,___S_protocol_2d_info_3f_)
#define ___SYM_quasiquote ___SYM(590,___S_quasiquote)
#define ___SYM_quote ___SYM(591,___S_quote)
#define ___SYM_quotient ___SYM(592,___S_quotient)
#define ___SYM_raise ___SYM(593,___S_raise)
#define ___SYM_random_2d_f64vector ___SYM(594,___S_random_2d_f64vector)
#define ___SYM_random_2d_integer ___SYM(595,___S_random_2d_integer)
#define ___SYM_random_2d_real ___SYM(596,___S_random_2d_real)
#define ___SYM_random_2d_source_2d_make_2d_f64vectors ___SYM(597,___S_random_2d_source_2d_make_2d_f64vectors)
#define ___SYM_random_2d_source_2d_make_2d_integers ___SYM(598,___S_random_2d_source_2d_make_2d_integers)
#define ___SYM_random_2d_source_2d_make_2d_reals ___SYM(599,___S_random_2d_source_2d_make_2d_reals)
#define ___SYM_random_2d_source_2d_make_2d_u8vectors ___SYM(600,___S_random_2d_source_2d_make_2d_u8vectors)
#define ___SYM_random_2d_source_2d_pseudo_2d_randomize_21_ ___SYM(601,___S_random_2d_source_2d_pseudo_2d_randomize_21_)
#define ___SYM_random_2d_source_2d_randomize_21_ ___SYM(602,___S_random_2d_source_2d_randomize_21_)
#define ___SYM_random_2d_source_2d_state_2d_ref ___SYM(603,___S_random_2d_source_2d_state_2d_ref)
#define ___SYM_random_2d_source_2d_state_2d_set_21_ ___SYM(604,___S_random_2d_source_2d_state_2d_set_21_)
#define ___SYM_random_2d_source_3f_ ___SYM(605,___S_random_2d_source_3f_)
#define ___SYM_random_2d_u8vector ___SYM(606,___S_random_2d_u8vector)
#define ___SYM_range_2d_exception_2d_arg_2d_num ___SYM(607,___S_range_2d_exception_2d_arg_2d_num)
#define ___SYM_range_2d_exception_2d_arguments ___SYM(608,___S_range_2d_exception_2d_arguments)
#define ___SYM_range_2d_exception_2d_procedure ___SYM(609,___S_range_2d_exception_2d_procedure)
#define ___SYM_range_2d_exception_3f_ ___SYM(610,___S_range_2d_exception_3f_)
#define ___SYM_rational_3f_ ___SYM(611,___S_rational_3f_)
#define ___SYM_rationalize ___SYM(612,___S_rationalize)
#define ___SYM_read ___SYM(613,___S_read)
#define ___SYM_read_2d_all ___SYM(614,___S_read_2d_all)
#define ___SYM_read_2d_char ___SYM(615,___S_read_2d_char)
#define ___SYM_read_2d_line ___SYM(616,___S_read_2d_line)
#define ___SYM_read_2d_substring ___SYM(617,___S_read_2d_substring)
#define ___SYM_read_2d_subu8vector ___SYM(618,___S_read_2d_subu8vector)
#define ___SYM_read_2d_u8 ___SYM(619,___S_read_2d_u8)
#define ___SYM_readtable_2d_case_2d_conversion_3f_ ___SYM(620,___S_readtable_2d_case_2d_conversion_3f_)
#define ___SYM_readtable_2d_case_2d_conversion_3f__2d_set ___SYM(621,___S_readtable_2d_case_2d_conversion_3f__2d_set)
#define ___SYM_readtable_2d_eval_2d_allowed_3f_ ___SYM(622,___S_readtable_2d_eval_2d_allowed_3f_)
#define ___SYM_readtable_2d_eval_2d_allowed_3f__2d_set ___SYM(623,___S_readtable_2d_eval_2d_allowed_3f__2d_set)
#define ___SYM_readtable_2d_keywords_2d_allowed_3f_ ___SYM(624,___S_readtable_2d_keywords_2d_allowed_3f_)
#define ___SYM_readtable_2d_keywords_2d_allowed_3f__2d_set ___SYM(625,___S_readtable_2d_keywords_2d_allowed_3f__2d_set)
#define ___SYM_readtable_2d_max_2d_unescaped_2d_char ___SYM(626,___S_readtable_2d_max_2d_unescaped_2d_char)
#define ___SYM_readtable_2d_max_2d_unescaped_2d_char_2d_set ___SYM(627,___S_readtable_2d_max_2d_unescaped_2d_char_2d_set)
#define ___SYM_readtable_2d_max_2d_write_2d_length ___SYM(628,___S_readtable_2d_max_2d_write_2d_length)
#define ___SYM_readtable_2d_max_2d_write_2d_length_2d_set ___SYM(629,___S_readtable_2d_max_2d_write_2d_length_2d_set)
#define ___SYM_readtable_2d_max_2d_write_2d_level ___SYM(630,___S_readtable_2d_max_2d_write_2d_level)
#define ___SYM_readtable_2d_max_2d_write_2d_level_2d_set ___SYM(631,___S_readtable_2d_max_2d_write_2d_level_2d_set)
#define ___SYM_readtable_2d_sharing_2d_allowed_3f_ ___SYM(632,___S_readtable_2d_sharing_2d_allowed_3f_)
#define ___SYM_readtable_2d_sharing_2d_allowed_3f__2d_set ___SYM(633,___S_readtable_2d_sharing_2d_allowed_3f__2d_set)
#define ___SYM_readtable_2d_start_2d_syntax ___SYM(634,___S_readtable_2d_start_2d_syntax)
#define ___SYM_readtable_2d_start_2d_syntax_2d_set ___SYM(635,___S_readtable_2d_start_2d_syntax_2d_set)
#define ___SYM_readtable_2d_write_2d_cdr_2d_read_2d_macros_3f_ ___SYM(636,___S_readtable_2d_write_2d_cdr_2d_read_2d_macros_3f_)
#define ___SYM_readtable_2d_write_2d_cdr_2d_read_2d_macros_3f__2d_set ___SYM(637,___S_readtable_2d_write_2d_cdr_2d_read_2d_macros_3f__2d_set)
#define ___SYM_readtable_2d_write_2d_extended_2d_read_2d_macros_3f_ ___SYM(638,___S_readtable_2d_write_2d_extended_2d_read_2d_macros_3f_)
#define ___SYM_readtable_2d_write_2d_extended_2d_read_2d_macros_3f__2d_set ___SYM(639,___S_readtable_2d_write_2d_extended_2d_read_2d_macros_3f__2d_set)
#define ___SYM_readtable_3f_ ___SYM(640,___S_readtable_3f_)
#define ___SYM_real_2d_part ___SYM(641,___S_real_2d_part)
#define ___SYM_real_2d_time ___SYM(642,___S_real_2d_time)
#define ___SYM_real_3f_ ___SYM(643,___S_real_3f_)
#define ___SYM_receive ___SYM(644,___S_receive)
#define ___SYM_remainder ___SYM(645,___S_remainder)
#define ___SYM_rename_2d_file ___SYM(646,___S_rename_2d_file)
#define ___SYM_repl_2d_display_2d_environment_3f_ ___SYM(647,___S_repl_2d_display_2d_environment_3f_)
#define ___SYM_repl_2d_input_2d_port ___SYM(648,___S_repl_2d_input_2d_port)
#define ___SYM_repl_2d_output_2d_port ___SYM(649,___S_repl_2d_output_2d_port)
#define ___SYM_repl_2d_result_2d_history_2d_max_2d_length_2d_set_21_ ___SYM(650,___S_repl_2d_result_2d_history_2d_max_2d_length_2d_set_21_)
#define ___SYM_repl_2d_result_2d_history_2d_ref ___SYM(651,___S_repl_2d_result_2d_history_2d_ref)
#define ___SYM_replace_2d_bit_2d_field ___SYM(652,___S_replace_2d_bit_2d_field)
#define ___SYM_reverse ___SYM(653,___S_reverse)
#define ___SYM_round ___SYM(654,___S_round)
#define ___SYM_rpc_2d_remote_2d_error_2d_exception_2d_arguments ___SYM(655,___S_rpc_2d_remote_2d_error_2d_exception_2d_arguments)
#define ___SYM_rpc_2d_remote_2d_error_2d_exception_2d_message ___SYM(656,___S_rpc_2d_remote_2d_error_2d_exception_2d_message)
#define ___SYM_rpc_2d_remote_2d_error_2d_exception_2d_procedure ___SYM(657,___S_rpc_2d_remote_2d_error_2d_exception_2d_procedure)
#define ___SYM_rpc_2d_remote_2d_error_2d_exception_3f_ ___SYM(658,___S_rpc_2d_remote_2d_error_2d_exception_3f_)
#define ___SYM_s16vector ___SYM(659,___S_s16vector)
#define ___SYM_s16vector_2d__3e_list ___SYM(660,___S_s16vector_2d__3e_list)
#define ___SYM_s16vector_2d_append ___SYM(661,___S_s16vector_2d_append)
#define ___SYM_s16vector_2d_copy ___SYM(662,___S_s16vector_2d_copy)
#define ___SYM_s16vector_2d_fill_21_ ___SYM(663,___S_s16vector_2d_fill_21_)
#define ___SYM_s16vector_2d_length ___SYM(664,___S_s16vector_2d_length)
#define ___SYM_s16vector_2d_ref ___SYM(665,___S_s16vector_2d_ref)
#define ___SYM_s16vector_2d_set_21_ ___SYM(666,___S_s16vector_2d_set_21_)
#define ___SYM_s16vector_2d_shrink_21_ ___SYM(667,___S_s16vector_2d_shrink_21_)
#define ___SYM_s16vector_3f_ ___SYM(668,___S_s16vector_3f_)
#define ___SYM_s32vector ___SYM(669,___S_s32vector)
#define ___SYM_s32vector_2d__3e_list ___SYM(670,___S_s32vector_2d__3e_list)
#define ___SYM_s32vector_2d_append ___SYM(671,___S_s32vector_2d_append)
#define ___SYM_s32vector_2d_copy ___SYM(672,___S_s32vector_2d_copy)
#define ___SYM_s32vector_2d_fill_21_ ___SYM(673,___S_s32vector_2d_fill_21_)
#define ___SYM_s32vector_2d_length ___SYM(674,___S_s32vector_2d_length)
#define ___SYM_s32vector_2d_ref ___SYM(675,___S_s32vector_2d_ref)
#define ___SYM_s32vector_2d_set_21_ ___SYM(676,___S_s32vector_2d_set_21_)
#define ___SYM_s32vector_2d_shrink_21_ ___SYM(677,___S_s32vector_2d_shrink_21_)
#define ___SYM_s32vector_3f_ ___SYM(678,___S_s32vector_3f_)
#define ___SYM_s64vector ___SYM(679,___S_s64vector)
#define ___SYM_s64vector_2d__3e_list ___SYM(680,___S_s64vector_2d__3e_list)
#define ___SYM_s64vector_2d_append ___SYM(681,___S_s64vector_2d_append)
#define ___SYM_s64vector_2d_copy ___SYM(682,___S_s64vector_2d_copy)
#define ___SYM_s64vector_2d_fill_21_ ___SYM(683,___S_s64vector_2d_fill_21_)
#define ___SYM_s64vector_2d_length ___SYM(684,___S_s64vector_2d_length)
#define ___SYM_s64vector_2d_ref ___SYM(685,___S_s64vector_2d_ref)
#define ___SYM_s64vector_2d_set_21_ ___SYM(686,___S_s64vector_2d_set_21_)
#define ___SYM_s64vector_2d_shrink_21_ ___SYM(687,___S_s64vector_2d_shrink_21_)
#define ___SYM_s64vector_3f_ ___SYM(688,___S_s64vector_3f_)
#define ___SYM_s8vector ___SYM(689,___S_s8vector)
#define ___SYM_s8vector_2d__3e_list ___SYM(690,___S_s8vector_2d__3e_list)
#define ___SYM_s8vector_2d_append ___SYM(691,___S_s8vector_2d_append)
#define ___SYM_s8vector_2d_copy ___SYM(692,___S_s8vector_2d_copy)
#define ___SYM_s8vector_2d_fill_21_ ___SYM(693,___S_s8vector_2d_fill_21_)
#define ___SYM_s8vector_2d_length ___SYM(694,___S_s8vector_2d_length)
#define ___SYM_s8vector_2d_ref ___SYM(695,___S_s8vector_2d_ref)
#define ___SYM_s8vector_2d_set_21_ ___SYM(696,___S_s8vector_2d_set_21_)
#define ___SYM_s8vector_2d_shrink_21_ ___SYM(697,___S_s8vector_2d_shrink_21_)
#define ___SYM_s8vector_3f_ ___SYM(698,___S_s8vector_3f_)
#define ___SYM_scheduler_2d_exception_2d_reason ___SYM(699,___S_scheduler_2d_exception_2d_reason)
#define ___SYM_scheduler_2d_exception_3f_ ___SYM(700,___S_scheduler_2d_exception_3f_)
#define ___SYM_scheme_2d_report_2d_environment ___SYM(701,___S_scheme_2d_report_2d_environment)
#define ___SYM_seconds_2d__3e_time ___SYM(702,___S_seconds_2d__3e_time)
#define ___SYM_serial_2d_number_2d__3e_object ___SYM(703,___S_serial_2d_number_2d__3e_object)
#define ___SYM_service_2d_info ___SYM(704,___S_service_2d_info)
#define ___SYM_service_2d_info_2d_aliases ___SYM(705,___S_service_2d_info_2d_aliases)
#define ___SYM_service_2d_info_2d_name ___SYM(706,___S_service_2d_info_2d_name)
#define ___SYM_service_2d_info_2d_port_2d_number ___SYM(707,___S_service_2d_info_2d_port_2d_number)
#define ___SYM_service_2d_info_2d_protocol ___SYM(708,___S_service_2d_info_2d_protocol)
#define ___SYM_service_2d_info_3f_ ___SYM(709,___S_service_2d_info_3f_)
#define ___SYM_set_21_ ___SYM(710,___S_set_21_)
#define ___SYM_set_2d_box_21_ ___SYM(711,___S_set_2d_box_21_)
#define ___SYM_set_2d_car_21_ ___SYM(712,___S_set_2d_car_21_)
#define ___SYM_set_2d_cdr_21_ ___SYM(713,___S_set_2d_cdr_21_)
#define ___SYM_setenv ___SYM(714,___S_setenv)
#define ___SYM_sfun_2d_conversion_2d_exception_2d_arguments ___SYM(715,___S_sfun_2d_conversion_2d_exception_2d_arguments)
#define ___SYM_sfun_2d_conversion_2d_exception_2d_code ___SYM(716,___S_sfun_2d_conversion_2d_exception_2d_code)
#define ___SYM_sfun_2d_conversion_2d_exception_2d_message ___SYM(717,___S_sfun_2d_conversion_2d_exception_2d_message)
#define ___SYM_sfun_2d_conversion_2d_exception_2d_procedure ___SYM(718,___S_sfun_2d_conversion_2d_exception_2d_procedure)
#define ___SYM_sfun_2d_conversion_2d_exception_3f_ ___SYM(719,___S_sfun_2d_conversion_2d_exception_3f_)
#define ___SYM_shell_2d_command ___SYM(720,___S_shell_2d_command)
#define ___SYM_sin ___SYM(721,___S_sin)
#define ___SYM_six_2e__21_ ___SYM(722,___S_six_2e__21_)
#define ___SYM_six_2e__21_x ___SYM(723,___S_six_2e__21_x)
#define ___SYM_six_2e__26_x ___SYM(724,___S_six_2e__26_x)
#define ___SYM_six_2e__2a_x ___SYM(725,___S_six_2e__2a_x)
#define ___SYM_six_2e__2b__2b_x ___SYM(726,___S_six_2e__2b__2b_x)
#define ___SYM_six_2e__2b_x ___SYM(727,___S_six_2e__2b_x)
#define ___SYM_six_2e__2d__2d_x ___SYM(728,___S_six_2e__2d__2d_x)
#define ___SYM_six_2e__2d_x ___SYM(729,___S_six_2e__2d_x)
#define ___SYM_six_2e_arrow ___SYM(730,___S_six_2e_arrow)
#define ___SYM_six_2e_break ___SYM(731,___S_six_2e_break)
#define ___SYM_six_2e_call ___SYM(732,___S_six_2e_call)
#define ___SYM_six_2e_case ___SYM(733,___S_six_2e_case)
#define ___SYM_six_2e_clause ___SYM(734,___S_six_2e_clause)
#define ___SYM_six_2e_compound ___SYM(735,___S_six_2e_compound)
#define ___SYM_six_2e_cons ___SYM(736,___S_six_2e_cons)
#define ___SYM_six_2e_continue ___SYM(737,___S_six_2e_continue)
#define ___SYM_six_2e_define_2d_procedure ___SYM(738,___S_six_2e_define_2d_procedure)
#define ___SYM_six_2e_define_2d_variable ___SYM(739,___S_six_2e_define_2d_variable)
#define ___SYM_six_2e_do_2d_while ___SYM(740,___S_six_2e_do_2d_while)
#define ___SYM_six_2e_dot ___SYM(741,___S_six_2e_dot)
#define ___SYM_six_2e_for ___SYM(742,___S_six_2e_for)
#define ___SYM_six_2e_goto ___SYM(743,___S_six_2e_goto)
#define ___SYM_six_2e_identifier ___SYM(744,___S_six_2e_identifier)
#define ___SYM_six_2e_if ___SYM(745,___S_six_2e_if)
#define ___SYM_six_2e_index ___SYM(746,___S_six_2e_index)
#define ___SYM_six_2e_label ___SYM(747,___S_six_2e_label)
#define ___SYM_six_2e_list ___SYM(748,___S_six_2e_list)
#define ___SYM_six_2e_literal ___SYM(749,___S_six_2e_literal)
#define ___SYM_six_2e_make_2d_array ___SYM(750,___S_six_2e_make_2d_array)
#define ___SYM_six_2e_new ___SYM(751,___S_six_2e_new)
#define ___SYM_six_2e_null ___SYM(752,___S_six_2e_null)
#define ___SYM_six_2e_prefix ___SYM(753,___S_six_2e_prefix)
#define ___SYM_six_2e_procedure ___SYM(754,___S_six_2e_procedure)
#define ___SYM_six_2e_procedure_2d_body ___SYM(755,___S_six_2e_procedure_2d_body)
#define ___SYM_six_2e_return ___SYM(756,___S_six_2e_return)
#define ___SYM_six_2e_switch ___SYM(757,___S_six_2e_switch)
#define ___SYM_six_2e_while ___SYM(758,___S_six_2e_while)
#define ___SYM_six_2e_x_21__3d_y ___SYM(759,___S_six_2e_x_21__3d_y)
#define ___SYM_six_2e_x_25__3d_y ___SYM(760,___S_six_2e_x_25__3d_y)
#define ___SYM_six_2e_x_25_y ___SYM(761,___S_six_2e_x_25_y)
#define ___SYM_six_2e_x_26__26_y ___SYM(762,___S_six_2e_x_26__26_y)
#define ___SYM_six_2e_x_26__3d_y ___SYM(763,___S_six_2e_x_26__3d_y)
#define ___SYM_six_2e_x_26_y ___SYM(764,___S_six_2e_x_26_y)
#define ___SYM_six_2e_x_2a__3d_y ___SYM(765,___S_six_2e_x_2a__3d_y)
#define ___SYM_six_2e_x_2a_y ___SYM(766,___S_six_2e_x_2a_y)
#define ___SYM_six_2e_x_2b__2b_ ___SYM(767,___S_six_2e_x_2b__2b_)
#define ___SYM_six_2e_x_2b__3d_y ___SYM(768,___S_six_2e_x_2b__3d_y)
#define ___SYM_six_2e_x_2b_y ___SYM(769,___S_six_2e_x_2b_y)
#define ___SYM_six_2e_x_2c_y ___SYM(770,___S_six_2e_x_2c_y)
#define ___SYM_six_2e_x_2d__2d_ ___SYM(771,___S_six_2e_x_2d__2d_)
#define ___SYM_six_2e_x_2d__3d_y ___SYM(772,___S_six_2e_x_2d__3d_y)
#define ___SYM_six_2e_x_2d_y ___SYM(773,___S_six_2e_x_2d_y)
#define ___SYM_six_2e_x_2f__3d_y ___SYM(774,___S_six_2e_x_2f__3d_y)
#define ___SYM_six_2e_x_2f_y ___SYM(775,___S_six_2e_x_2f_y)
#define ___SYM_six_2e_x_3a__2d_y ___SYM(776,___S_six_2e_x_3a__2d_y)
#define ___SYM_six_2e_x_3a__3d_y ___SYM(777,___S_six_2e_x_3a__3d_y)
#define ___SYM_six_2e_x_3a_y ___SYM(778,___S_six_2e_x_3a_y)
#define ___SYM_six_2e_x_3c__3c__3d_y ___SYM(779,___S_six_2e_x_3c__3c__3d_y)
#define ___SYM_six_2e_x_3c__3c_y ___SYM(780,___S_six_2e_x_3c__3c_y)
#define ___SYM_six_2e_x_3c__3d_y ___SYM(781,___S_six_2e_x_3c__3d_y)
#define ___SYM_six_2e_x_3c_y ___SYM(782,___S_six_2e_x_3c_y)
#define ___SYM_six_2e_x_3d__3d_y ___SYM(783,___S_six_2e_x_3d__3d_y)
#define ___SYM_six_2e_x_3d_y ___SYM(784,___S_six_2e_x_3d_y)
#define ___SYM_six_2e_x_3e__3d_y ___SYM(785,___S_six_2e_x_3e__3d_y)
#define ___SYM_six_2e_x_3e__3e__3d_y ___SYM(786,___S_six_2e_x_3e__3e__3d_y)
#define ___SYM_six_2e_x_3e__3e_y ___SYM(787,___S_six_2e_x_3e__3e_y)
#define ___SYM_six_2e_x_3e_y ___SYM(788,___S_six_2e_x_3e_y)
#define ___SYM_six_2e_x_3f_y_3a_z ___SYM(789,___S_six_2e_x_3f_y_3a_z)
#define ___SYM_six_2e_x_5e__3d_y ___SYM(790,___S_six_2e_x_5e__3d_y)
#define ___SYM_six_2e_x_5e_y ___SYM(791,___S_six_2e_x_5e_y)
#define ___SYM_six_2e_x_7c__3d_y ___SYM(792,___S_six_2e_x_7c__3d_y)
#define ___SYM_six_2e_x_7c_y ___SYM(793,___S_six_2e_x_7c_y)
#define ___SYM_six_2e_x_7c__7c_y ___SYM(794,___S_six_2e_x_7c__7c_y)
#define ___SYM_six_2e__7e_x ___SYM(795,___S_six_2e__7e_x)
#define ___SYM_socket_2d_info_2d_address ___SYM(796,___S_socket_2d_info_2d_address)
#define ___SYM_socket_2d_info_2d_family ___SYM(797,___S_socket_2d_info_2d_family)
#define ___SYM_socket_2d_info_2d_port_2d_number ___SYM(798,___S_socket_2d_info_2d_port_2d_number)
#define ___SYM_socket_2d_info_3f_ ___SYM(799,___S_socket_2d_info_3f_)
#define ___SYM_sqrt ___SYM(800,___S_sqrt)
#define ___SYM_stack_2d_overflow_2d_exception_3f_ ___SYM(801,___S_stack_2d_overflow_2d_exception_3f_)
#define ___SYM_started_2d_thread_2d_exception_2d_arguments ___SYM(802,___S_started_2d_thread_2d_exception_2d_arguments)
#define ___SYM_started_2d_thread_2d_exception_2d_procedure ___SYM(803,___S_started_2d_thread_2d_exception_2d_procedure)
#define ___SYM_started_2d_thread_2d_exception_3f_ ___SYM(804,___S_started_2d_thread_2d_exception_3f_)
#define ___SYM_step ___SYM(805,___S_step)
#define ___SYM_step_2d_level_2d_set_21_ ___SYM(806,___S_step_2d_level_2d_set_21_)
#define ___SYM_string ___SYM(807,___S_string)
#define ___SYM_string_2d__3e_keyword ___SYM(808,___S_string_2d__3e_keyword)
#define ___SYM_string_2d__3e_list ___SYM(809,___S_string_2d__3e_list)
#define ___SYM_string_2d__3e_number ___SYM(810,___S_string_2d__3e_number)
#define ___SYM_string_2d__3e_symbol ___SYM(811,___S_string_2d__3e_symbol)
#define ___SYM_string_2d_append ___SYM(812,___S_string_2d_append)
#define ___SYM_string_2d_ci_3c__3d__3f_ ___SYM(813,___S_string_2d_ci_3c__3d__3f_)
#define ___SYM_string_2d_ci_3c__3f_ ___SYM(814,___S_string_2d_ci_3c__3f_)
#define ___SYM_string_2d_ci_3d__3f_ ___SYM(815,___S_string_2d_ci_3d__3f_)
#define ___SYM_string_2d_ci_3d__3f__2d_hash ___SYM(816,___S_string_2d_ci_3d__3f__2d_hash)
#define ___SYM_string_2d_ci_3e__3d__3f_ ___SYM(817,___S_string_2d_ci_3e__3d__3f_)
#define ___SYM_string_2d_ci_3e__3f_ ___SYM(818,___S_string_2d_ci_3e__3f_)
#define ___SYM_string_2d_copy ___SYM(819,___S_string_2d_copy)
#define ___SYM_string_2d_fill_21_ ___SYM(820,___S_string_2d_fill_21_)
#define ___SYM_string_2d_length ___SYM(821,___S_string_2d_length)
#define ___SYM_string_2d_ref ___SYM(822,___S_string_2d_ref)
#define ___SYM_string_2d_set_21_ ___SYM(823,___S_string_2d_set_21_)
#define ___SYM_string_2d_shrink_21_ ___SYM(824,___S_string_2d_shrink_21_)
#define ___SYM_string_3c__3d__3f_ ___SYM(825,___S_string_3c__3d__3f_)
#define ___SYM_string_3c__3f_ ___SYM(826,___S_string_3c__3f_)
#define ___SYM_string_3d__3f_ ___SYM(827,___S_string_3d__3f_)
#define ___SYM_string_3d__3f__2d_hash ___SYM(828,___S_string_3d__3f__2d_hash)
#define ___SYM_string_3e__3d__3f_ ___SYM(829,___S_string_3e__3d__3f_)
#define ___SYM_string_3e__3f_ ___SYM(830,___S_string_3e__3f_)
#define ___SYM_string_3f_ ___SYM(831,___S_string_3f_)
#define ___SYM_subf32vector ___SYM(832,___S_subf32vector)
#define ___SYM_subf32vector_2d_fill_21_ ___SYM(833,___S_subf32vector_2d_fill_21_)
#define ___SYM_subf32vector_2d_move_21_ ___SYM(834,___S_subf32vector_2d_move_21_)
#define ___SYM_subf64vector ___SYM(835,___S_subf64vector)
#define ___SYM_subf64vector_2d_fill_21_ ___SYM(836,___S_subf64vector_2d_fill_21_)
#define ___SYM_subf64vector_2d_move_21_ ___SYM(837,___S_subf64vector_2d_move_21_)
#define ___SYM_subs16vector ___SYM(838,___S_subs16vector)
#define ___SYM_subs16vector_2d_fill_21_ ___SYM(839,___S_subs16vector_2d_fill_21_)
#define ___SYM_subs16vector_2d_move_21_ ___SYM(840,___S_subs16vector_2d_move_21_)
#define ___SYM_subs32vector ___SYM(841,___S_subs32vector)
#define ___SYM_subs32vector_2d_fill_21_ ___SYM(842,___S_subs32vector_2d_fill_21_)
#define ___SYM_subs32vector_2d_move_21_ ___SYM(843,___S_subs32vector_2d_move_21_)
#define ___SYM_subs64vector ___SYM(844,___S_subs64vector)
#define ___SYM_subs64vector_2d_fill_21_ ___SYM(845,___S_subs64vector_2d_fill_21_)
#define ___SYM_subs64vector_2d_move_21_ ___SYM(846,___S_subs64vector_2d_move_21_)
#define ___SYM_subs8vector ___SYM(847,___S_subs8vector)
#define ___SYM_subs8vector_2d_fill_21_ ___SYM(848,___S_subs8vector_2d_fill_21_)
#define ___SYM_subs8vector_2d_move_21_ ___SYM(849,___S_subs8vector_2d_move_21_)
#define ___SYM_substring ___SYM(850,___S_substring)
#define ___SYM_substring_2d_fill_21_ ___SYM(851,___S_substring_2d_fill_21_)
#define ___SYM_substring_2d_move_21_ ___SYM(852,___S_substring_2d_move_21_)
#define ___SYM_subu16vector ___SYM(853,___S_subu16vector)
#define ___SYM_subu16vector_2d_fill_21_ ___SYM(854,___S_subu16vector_2d_fill_21_)
#define ___SYM_subu16vector_2d_move_21_ ___SYM(855,___S_subu16vector_2d_move_21_)
#define ___SYM_subu32vector ___SYM(856,___S_subu32vector)
#define ___SYM_subu32vector_2d_fill_21_ ___SYM(857,___S_subu32vector_2d_fill_21_)
#define ___SYM_subu32vector_2d_move_21_ ___SYM(858,___S_subu32vector_2d_move_21_)
#define ___SYM_subu64vector ___SYM(859,___S_subu64vector)
#define ___SYM_subu64vector_2d_fill_21_ ___SYM(860,___S_subu64vector_2d_fill_21_)
#define ___SYM_subu64vector_2d_move_21_ ___SYM(861,___S_subu64vector_2d_move_21_)
#define ___SYM_subu8vector ___SYM(862,___S_subu8vector)
#define ___SYM_subu8vector_2d_fill_21_ ___SYM(863,___S_subu8vector_2d_fill_21_)
#define ___SYM_subu8vector_2d_move_21_ ___SYM(864,___S_subu8vector_2d_move_21_)
#define ___SYM_subvector ___SYM(865,___S_subvector)
#define ___SYM_subvector_2d_fill_21_ ___SYM(866,___S_subvector_2d_fill_21_)
#define ___SYM_subvector_2d_move_21_ ___SYM(867,___S_subvector_2d_move_21_)
#define ___SYM_symbol_2d__3e_string ___SYM(868,___S_symbol_2d__3e_string)
#define ___SYM_symbol_2d_hash ___SYM(869,___S_symbol_2d_hash)
#define ___SYM_symbol_3f_ ___SYM(870,___S_symbol_3f_)
#define ___SYM_syntax_2d_rules ___SYM(871,___S_syntax_2d_rules)
#define ___SYM_system_2d_stamp ___SYM(872,___S_system_2d_stamp)
#define ___SYM_system_2d_type ___SYM(873,___S_system_2d_type)
#define ___SYM_system_2d_type_2d_string ___SYM(874,___S_system_2d_type_2d_string)
#define ___SYM_system_2d_version ___SYM(875,___S_system_2d_version)
#define ___SYM_system_2d_version_2d_string ___SYM(876,___S_system_2d_version_2d_string)
#define ___SYM_table_2d__3e_list ___SYM(877,___S_table_2d__3e_list)
#define ___SYM_table_2d_copy ___SYM(878,___S_table_2d_copy)
#define ___SYM_table_2d_for_2d_each ___SYM(879,___S_table_2d_for_2d_each)
#define ___SYM_table_2d_length ___SYM(880,___S_table_2d_length)
#define ___SYM_table_2d_merge ___SYM(881,___S_table_2d_merge)
#define ___SYM_table_2d_merge_21_ ___SYM(882,___S_table_2d_merge_21_)
#define ___SYM_table_2d_ref ___SYM(883,___S_table_2d_ref)
#define ___SYM_table_2d_search ___SYM(884,___S_table_2d_search)
#define ___SYM_table_2d_set_21_ ___SYM(885,___S_table_2d_set_21_)
#define ___SYM_table_3f_ ___SYM(886,___S_table_3f_)
#define ___SYM_tan ___SYM(887,___S_tan)
#define ___SYM_tcp_2d_client_2d_peer_2d_socket_2d_info ___SYM(888,___S_tcp_2d_client_2d_peer_2d_socket_2d_info)
#define ___SYM_tcp_2d_client_2d_self_2d_socket_2d_info ___SYM(889,___S_tcp_2d_client_2d_self_2d_socket_2d_info)
#define ___SYM_tcp_2d_server_2d_socket_2d_info ___SYM(890,___S_tcp_2d_server_2d_socket_2d_info)
#define ___SYM_tcp_2d_service_2d_register_21_ ___SYM(891,___S_tcp_2d_service_2d_register_21_)
#define ___SYM_tcp_2d_service_2d_unregister_21_ ___SYM(892,___S_tcp_2d_service_2d_unregister_21_)
#define ___SYM_terminated_2d_thread_2d_exception_2d_arguments ___SYM(893,___S_terminated_2d_thread_2d_exception_2d_arguments)
#define ___SYM_terminated_2d_thread_2d_exception_2d_procedure ___SYM(894,___S_terminated_2d_thread_2d_exception_2d_procedure)
#define ___SYM_terminated_2d_thread_2d_exception_3f_ ___SYM(895,___S_terminated_2d_thread_2d_exception_3f_)
#define ___SYM_test_2d_bit_2d_field_3f_ ___SYM(896,___S_test_2d_bit_2d_field_3f_)
#define ___SYM_this_2d_source_2d_file ___SYM(897,___S_this_2d_source_2d_file)
#define ___SYM_thread_2d_base_2d_priority ___SYM(898,___S_thread_2d_base_2d_priority)
#define ___SYM_thread_2d_base_2d_priority_2d_set_21_ ___SYM(899,___S_thread_2d_base_2d_priority_2d_set_21_)
#define ___SYM_thread_2d_group_2d__3e_thread_2d_group_2d_list ___SYM(900,___S_thread_2d_group_2d__3e_thread_2d_group_2d_list)
#define ___SYM_thread_2d_group_2d__3e_thread_2d_group_2d_vector ___SYM(901,___S_thread_2d_group_2d__3e_thread_2d_group_2d_vector)
#define ___SYM_thread_2d_group_2d__3e_thread_2d_list ___SYM(902,___S_thread_2d_group_2d__3e_thread_2d_list)
#define ___SYM_thread_2d_group_2d__3e_thread_2d_vector ___SYM(903,___S_thread_2d_group_2d__3e_thread_2d_vector)
#define ___SYM_thread_2d_group_2d_name ___SYM(904,___S_thread_2d_group_2d_name)
#define ___SYM_thread_2d_group_2d_parent ___SYM(905,___S_thread_2d_group_2d_parent)
#define ___SYM_thread_2d_group_2d_resume_21_ ___SYM(906,___S_thread_2d_group_2d_resume_21_)
#define ___SYM_thread_2d_group_2d_suspend_21_ ___SYM(907,___S_thread_2d_group_2d_suspend_21_)
#define ___SYM_thread_2d_group_2d_terminate_21_ ___SYM(908,___S_thread_2d_group_2d_terminate_21_)
#define ___SYM_thread_2d_group_3f_ ___SYM(909,___S_thread_2d_group_3f_)
#define ___SYM_thread_2d_init_21_ ___SYM(910,___S_thread_2d_init_21_)
#define ___SYM_thread_2d_interrupt_21_ ___SYM(911,___S_thread_2d_interrupt_21_)
#define ___SYM_thread_2d_join_21_ ___SYM(912,___S_thread_2d_join_21_)
#define ___SYM_thread_2d_mailbox_2d_extract_2d_and_2d_rewind ___SYM(913,___S_thread_2d_mailbox_2d_extract_2d_and_2d_rewind)
#define ___SYM_thread_2d_mailbox_2d_next ___SYM(914,___S_thread_2d_mailbox_2d_next)
#define ___SYM_thread_2d_mailbox_2d_rewind ___SYM(915,___S_thread_2d_mailbox_2d_rewind)
#define ___SYM_thread_2d_name ___SYM(916,___S_thread_2d_name)
#define ___SYM_thread_2d_priority_2d_boost ___SYM(917,___S_thread_2d_priority_2d_boost)
#define ___SYM_thread_2d_priority_2d_boost_2d_set_21_ ___SYM(918,___S_thread_2d_priority_2d_boost_2d_set_21_)
#define ___SYM_thread_2d_quantum ___SYM(919,___S_thread_2d_quantum)
#define ___SYM_thread_2d_quantum_2d_set_21_ ___SYM(920,___S_thread_2d_quantum_2d_set_21_)
#define ___SYM_thread_2d_receive ___SYM(921,___S_thread_2d_receive)
#define ___SYM_thread_2d_resume_21_ ___SYM(922,___S_thread_2d_resume_21_)
#define ___SYM_thread_2d_send ___SYM(923,___S_thread_2d_send)
#define ___SYM_thread_2d_sleep_21_ ___SYM(924,___S_thread_2d_sleep_21_)
#define ___SYM_thread_2d_specific ___SYM(925,___S_thread_2d_specific)
#define ___SYM_thread_2d_specific_2d_set_21_ ___SYM(926,___S_thread_2d_specific_2d_set_21_)
#define ___SYM_thread_2d_start_21_ ___SYM(927,___S_thread_2d_start_21_)
#define ___SYM_thread_2d_state ___SYM(928,___S_thread_2d_state)
#define ___SYM_thread_2d_state_2d_abnormally_2d_terminated_2d_reason ___SYM(929,___S_thread_2d_state_2d_abnormally_2d_terminated_2d_reason)
#define ___SYM_thread_2d_state_2d_abnormally_2d_terminated_3f_ ___SYM(930,___S_thread_2d_state_2d_abnormally_2d_terminated_3f_)
#define ___SYM_thread_2d_state_2d_active_2d_timeout ___SYM(931,___S_thread_2d_state_2d_active_2d_timeout)
#define ___SYM_thread_2d_state_2d_active_2d_waiting_2d_for ___SYM(932,___S_thread_2d_state_2d_active_2d_waiting_2d_for)
#define ___SYM_thread_2d_state_2d_active_3f_ ___SYM(933,___S_thread_2d_state_2d_active_3f_)
#define ___SYM_thread_2d_state_2d_initialized_3f_ ___SYM(934,___S_thread_2d_state_2d_initialized_3f_)
#define ___SYM_thread_2d_state_2d_normally_2d_terminated_2d_result ___SYM(935,___S_thread_2d_state_2d_normally_2d_terminated_2d_result)
#define ___SYM_thread_2d_state_2d_normally_2d_terminated_3f_ ___SYM(936,___S_thread_2d_state_2d_normally_2d_terminated_3f_)
#define ___SYM_thread_2d_state_2d_uninitialized_3f_ ___SYM(937,___S_thread_2d_state_2d_uninitialized_3f_)
#define ___SYM_thread_2d_suspend_21_ ___SYM(938,___S_thread_2d_suspend_21_)
#define ___SYM_thread_2d_terminate_21_ ___SYM(939,___S_thread_2d_terminate_21_)
#define ___SYM_thread_2d_thread_2d_group ___SYM(940,___S_thread_2d_thread_2d_group)
#define ___SYM_thread_2d_yield_21_ ___SYM(941,___S_thread_2d_yield_21_)
#define ___SYM_thread_3f_ ___SYM(942,___S_thread_3f_)
#define ___SYM_time ___SYM(943,___S_time)
#define ___SYM_time_2d__3e_seconds ___SYM(944,___S_time_2d__3e_seconds)
#define ___SYM_time_3f_ ___SYM(945,___S_time_3f_)
#define ___SYM_timeout_2d__3e_time ___SYM(946,___S_timeout_2d__3e_time)
#define ___SYM_top ___SYM(947,___S_top)
#define ___SYM_touch ___SYM(948,___S_touch)
#define ___SYM_trace ___SYM(949,___S_trace)
#define ___SYM_transcript_2d_off ___SYM(950,___S_transcript_2d_off)
#define ___SYM_transcript_2d_on ___SYM(951,___S_transcript_2d_on)
#define ___SYM_truncate ___SYM(952,___S_truncate)
#define ___SYM_tty_2d_history ___SYM(953,___S_tty_2d_history)
#define ___SYM_tty_2d_history_2d_max_2d_length_2d_set_21_ ___SYM(954,___S_tty_2d_history_2d_max_2d_length_2d_set_21_)
#define ___SYM_tty_2d_history_2d_set_21_ ___SYM(955,___S_tty_2d_history_2d_set_21_)
#define ___SYM_tty_2d_mode_2d_set_21_ ___SYM(956,___S_tty_2d_mode_2d_set_21_)
#define ___SYM_tty_2d_paren_2d_balance_2d_duration_2d_set_21_ ___SYM(957,___S_tty_2d_paren_2d_balance_2d_duration_2d_set_21_)
#define ___SYM_tty_2d_text_2d_attributes_2d_set_21_ ___SYM(958,___S_tty_2d_text_2d_attributes_2d_set_21_)
#define ___SYM_tty_2d_type_2d_set_21_ ___SYM(959,___S_tty_2d_type_2d_set_21_)
#define ___SYM_tty_3f_ ___SYM(960,___S_tty_3f_)
#define ___SYM_type_2d_exception_2d_arg_2d_num ___SYM(961,___S_type_2d_exception_2d_arg_2d_num)
#define ___SYM_type_2d_exception_2d_arguments ___SYM(962,___S_type_2d_exception_2d_arguments)
#define ___SYM_type_2d_exception_2d_procedure ___SYM(963,___S_type_2d_exception_2d_procedure)
#define ___SYM_type_2d_exception_2d_type_2d_id ___SYM(964,___S_type_2d_exception_2d_type_2d_id)
#define ___SYM_type_2d_exception_3f_ ___SYM(965,___S_type_2d_exception_3f_)
#define ___SYM_u16vector ___SYM(966,___S_u16vector)
#define ___SYM_u16vector_2d__3e_list ___SYM(967,___S_u16vector_2d__3e_list)
#define ___SYM_u16vector_2d_append ___SYM(968,___S_u16vector_2d_append)
#define ___SYM_u16vector_2d_copy ___SYM(969,___S_u16vector_2d_copy)
#define ___SYM_u16vector_2d_fill_21_ ___SYM(970,___S_u16vector_2d_fill_21_)
#define ___SYM_u16vector_2d_length ___SYM(971,___S_u16vector_2d_length)
#define ___SYM_u16vector_2d_ref ___SYM(972,___S_u16vector_2d_ref)
#define ___SYM_u16vector_2d_set_21_ ___SYM(973,___S_u16vector_2d_set_21_)
#define ___SYM_u16vector_2d_shrink_21_ ___SYM(974,___S_u16vector_2d_shrink_21_)
#define ___SYM_u16vector_3f_ ___SYM(975,___S_u16vector_3f_)
#define ___SYM_u32vector ___SYM(976,___S_u32vector)
#define ___SYM_u32vector_2d__3e_list ___SYM(977,___S_u32vector_2d__3e_list)
#define ___SYM_u32vector_2d_append ___SYM(978,___S_u32vector_2d_append)
#define ___SYM_u32vector_2d_copy ___SYM(979,___S_u32vector_2d_copy)
#define ___SYM_u32vector_2d_fill_21_ ___SYM(980,___S_u32vector_2d_fill_21_)
#define ___SYM_u32vector_2d_length ___SYM(981,___S_u32vector_2d_length)
#define ___SYM_u32vector_2d_ref ___SYM(982,___S_u32vector_2d_ref)
#define ___SYM_u32vector_2d_set_21_ ___SYM(983,___S_u32vector_2d_set_21_)
#define ___SYM_u32vector_2d_shrink_21_ ___SYM(984,___S_u32vector_2d_shrink_21_)
#define ___SYM_u32vector_3f_ ___SYM(985,___S_u32vector_3f_)
#define ___SYM_u64vector ___SYM(986,___S_u64vector)
#define ___SYM_u64vector_2d__3e_list ___SYM(987,___S_u64vector_2d__3e_list)
#define ___SYM_u64vector_2d_append ___SYM(988,___S_u64vector_2d_append)
#define ___SYM_u64vector_2d_copy ___SYM(989,___S_u64vector_2d_copy)
#define ___SYM_u64vector_2d_fill_21_ ___SYM(990,___S_u64vector_2d_fill_21_)
#define ___SYM_u64vector_2d_length ___SYM(991,___S_u64vector_2d_length)
#define ___SYM_u64vector_2d_ref ___SYM(992,___S_u64vector_2d_ref)
#define ___SYM_u64vector_2d_set_21_ ___SYM(993,___S_u64vector_2d_set_21_)
#define ___SYM_u64vector_2d_shrink_21_ ___SYM(994,___S_u64vector_2d_shrink_21_)
#define ___SYM_u64vector_3f_ ___SYM(995,___S_u64vector_3f_)
#define ___SYM_u8vector ___SYM(996,___S_u8vector)
#define ___SYM_u8vector_2d__3e_list ___SYM(997,___S_u8vector_2d__3e_list)
#define ___SYM_u8vector_2d__3e_object ___SYM(998,___S_u8vector_2d__3e_object)
#define ___SYM_u8vector_2d_append ___SYM(999,___S_u8vector_2d_append)
#define ___SYM_u8vector_2d_copy ___SYM(1000,___S_u8vector_2d_copy)
#define ___SYM_u8vector_2d_fill_21_ ___SYM(1001,___S_u8vector_2d_fill_21_)
#define ___SYM_u8vector_2d_length ___SYM(1002,___S_u8vector_2d_length)
#define ___SYM_u8vector_2d_ref ___SYM(1003,___S_u8vector_2d_ref)
#define ___SYM_u8vector_2d_set_21_ ___SYM(1004,___S_u8vector_2d_set_21_)
#define ___SYM_u8vector_2d_shrink_21_ ___SYM(1005,___S_u8vector_2d_shrink_21_)
#define ___SYM_u8vector_3f_ ___SYM(1006,___S_u8vector_3f_)
#define ___SYM_unbound_2d_global_2d_exception_2d_code ___SYM(1007,___S_unbound_2d_global_2d_exception_2d_code)
#define ___SYM_unbound_2d_global_2d_exception_2d_rte ___SYM(1008,___S_unbound_2d_global_2d_exception_2d_rte)
#define ___SYM_unbound_2d_global_2d_exception_2d_variable ___SYM(1009,___S_unbound_2d_global_2d_exception_2d_variable)
#define ___SYM_unbound_2d_global_2d_exception_3f_ ___SYM(1010,___S_unbound_2d_global_2d_exception_3f_)
#define ___SYM_unbound_2d_os_2d_environment_2d_variable_2d_exception_2d_arguments ___SYM(1011,___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_2d_arguments)
#define ___SYM_unbound_2d_os_2d_environment_2d_variable_2d_exception_2d_procedure ___SYM(1012,___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_2d_procedure)
#define ___SYM_unbound_2d_os_2d_environment_2d_variable_2d_exception_3f_ ___SYM(1013,___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_3f_)
#define ___SYM_unbound_2d_serial_2d_number_2d_exception_2d_arguments ___SYM(1014,___S_unbound_2d_serial_2d_number_2d_exception_2d_arguments)
#define ___SYM_unbound_2d_serial_2d_number_2d_exception_2d_procedure ___SYM(1015,___S_unbound_2d_serial_2d_number_2d_exception_2d_procedure)
#define ___SYM_unbound_2d_serial_2d_number_2d_exception_3f_ ___SYM(1016,___S_unbound_2d_serial_2d_number_2d_exception_3f_)
#define ___SYM_unbound_2d_table_2d_key_2d_exception_2d_arguments ___SYM(1017,___S_unbound_2d_table_2d_key_2d_exception_2d_arguments)
#define ___SYM_unbound_2d_table_2d_key_2d_exception_2d_procedure ___SYM(1018,___S_unbound_2d_table_2d_key_2d_exception_2d_procedure)
#define ___SYM_unbound_2d_table_2d_key_2d_exception_3f_ ___SYM(1019,___S_unbound_2d_table_2d_key_2d_exception_3f_)
#define ___SYM_unbox ___SYM(1020,___S_unbox)
#define ___SYM_unbreak ___SYM(1021,___S_unbreak)
#define ___SYM_uncaught_2d_exception_2d_arguments ___SYM(1022,___S_uncaught_2d_exception_2d_arguments)
#define ___SYM_uncaught_2d_exception_2d_procedure ___SYM(1023,___S_uncaught_2d_exception_2d_procedure)
#define ___SYM_uncaught_2d_exception_2d_reason ___SYM(1024,___S_uncaught_2d_exception_2d_reason)
#define ___SYM_uncaught_2d_exception_3f_ ___SYM(1025,___S_uncaught_2d_exception_3f_)
#define ___SYM_uninitialized_2d_thread_2d_exception_2d_arguments ___SYM(1026,___S_uninitialized_2d_thread_2d_exception_2d_arguments)
#define ___SYM_uninitialized_2d_thread_2d_exception_2d_procedure ___SYM(1027,___S_uninitialized_2d_thread_2d_exception_2d_procedure)
#define ___SYM_uninitialized_2d_thread_2d_exception_3f_ ___SYM(1028,___S_uninitialized_2d_thread_2d_exception_3f_)
#define ___SYM_uninterned_2d_keyword_3f_ ___SYM(1029,___S_uninterned_2d_keyword_3f_)
#define ___SYM_uninterned_2d_symbol_3f_ ___SYM(1030,___S_uninterned_2d_symbol_3f_)
#define ___SYM_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments ___SYM(1031,___S_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments)
#define ___SYM_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure ___SYM(1032,___S_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure)
#define ___SYM_unknown_2d_keyword_2d_argument_2d_exception_3f_ ___SYM(1033,___S_unknown_2d_keyword_2d_argument_2d_exception_3f_)
#define ___SYM_unterminated_2d_process_2d_exception_2d_arguments ___SYM(1034,___S_unterminated_2d_process_2d_exception_2d_arguments)
#define ___SYM_unterminated_2d_process_2d_exception_2d_procedure ___SYM(1035,___S_unterminated_2d_process_2d_exception_2d_procedure)
#define ___SYM_unterminated_2d_process_2d_exception_3f_ ___SYM(1036,___S_unterminated_2d_process_2d_exception_3f_)
#define ___SYM_untrace ___SYM(1037,___S_untrace)
#define ___SYM_user_2d_info ___SYM(1038,___S_user_2d_info)
#define ___SYM_user_2d_info_2d_gid ___SYM(1039,___S_user_2d_info_2d_gid)
#define ___SYM_user_2d_info_2d_home ___SYM(1040,___S_user_2d_info_2d_home)
#define ___SYM_user_2d_info_2d_name ___SYM(1041,___S_user_2d_info_2d_name)
#define ___SYM_user_2d_info_2d_shell ___SYM(1042,___S_user_2d_info_2d_shell)
#define ___SYM_user_2d_info_2d_uid ___SYM(1043,___S_user_2d_info_2d_uid)
#define ___SYM_user_2d_info_3f_ ___SYM(1044,___S_user_2d_info_3f_)
#define ___SYM_user_2d_name ___SYM(1045,___S_user_2d_name)
#define ___SYM_values ___SYM(1046,___S_values)
#define ___SYM_vector ___SYM(1047,___S_vector)
#define ___SYM_vector_2d__3e_list ___SYM(1048,___S_vector_2d__3e_list)
#define ___SYM_vector_2d_append ___SYM(1049,___S_vector_2d_append)
#define ___SYM_vector_2d_copy ___SYM(1050,___S_vector_2d_copy)
#define ___SYM_vector_2d_fill_21_ ___SYM(1051,___S_vector_2d_fill_21_)
#define ___SYM_vector_2d_length ___SYM(1052,___S_vector_2d_length)
#define ___SYM_vector_2d_ref ___SYM(1053,___S_vector_2d_ref)
#define ___SYM_vector_2d_set_21_ ___SYM(1054,___S_vector_2d_set_21_)
#define ___SYM_vector_2d_shrink_21_ ___SYM(1055,___S_vector_2d_shrink_21_)
#define ___SYM_vector_3f_ ___SYM(1056,___S_vector_3f_)
#define ___SYM_void ___SYM(1057,___S_void)
#define ___SYM_will_2d_execute_21_ ___SYM(1058,___S_will_2d_execute_21_)
#define ___SYM_will_2d_testator ___SYM(1059,___S_will_2d_testator)
#define ___SYM_will_3f_ ___SYM(1060,___S_will_3f_)
#define ___SYM_with_2d_exception_2d_catcher ___SYM(1061,___S_with_2d_exception_2d_catcher)
#define ___SYM_with_2d_exception_2d_handler ___SYM(1062,___S_with_2d_exception_2d_handler)
#define ___SYM_with_2d_input_2d_from_2d_file ___SYM(1063,___S_with_2d_input_2d_from_2d_file)
#define ___SYM_with_2d_input_2d_from_2d_port ___SYM(1064,___S_with_2d_input_2d_from_2d_port)
#define ___SYM_with_2d_input_2d_from_2d_process ___SYM(1065,___S_with_2d_input_2d_from_2d_process)
#define ___SYM_with_2d_input_2d_from_2d_string ___SYM(1066,___S_with_2d_input_2d_from_2d_string)
#define ___SYM_with_2d_input_2d_from_2d_u8vector ___SYM(1067,___S_with_2d_input_2d_from_2d_u8vector)
#define ___SYM_with_2d_input_2d_from_2d_vector ___SYM(1068,___S_with_2d_input_2d_from_2d_vector)
#define ___SYM_with_2d_output_2d_to_2d_file ___SYM(1069,___S_with_2d_output_2d_to_2d_file)
#define ___SYM_with_2d_output_2d_to_2d_port ___SYM(1070,___S_with_2d_output_2d_to_2d_port)
#define ___SYM_with_2d_output_2d_to_2d_process ___SYM(1071,___S_with_2d_output_2d_to_2d_process)
#define ___SYM_with_2d_output_2d_to_2d_string ___SYM(1072,___S_with_2d_output_2d_to_2d_string)
#define ___SYM_with_2d_output_2d_to_2d_u8vector ___SYM(1073,___S_with_2d_output_2d_to_2d_u8vector)
#define ___SYM_with_2d_output_2d_to_2d_vector ___SYM(1074,___S_with_2d_output_2d_to_2d_vector)
#define ___SYM_write ___SYM(1075,___S_write)
#define ___SYM_write_2d_char ___SYM(1076,___S_write_2d_char)
#define ___SYM_write_2d_substring ___SYM(1077,___S_write_2d_substring)
#define ___SYM_write_2d_subu8vector ___SYM(1078,___S_write_2d_subu8vector)
#define ___SYM_write_2d_u8 ___SYM(1079,___S_write_2d_u8)
#define ___SYM_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments ___SYM(1080,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments)
#define ___SYM_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure ___SYM(1081,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure)
#define ___SYM_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_ ___SYM(1082,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_)
#define ___SYM_zero_3f_ ___SYM(1083,___S_zero_3f_)

___BEGIN_GLO
___DEF_GLO(0," help")
___DEF_GLO(1,"##help-hook")
___DEF_GLO(2,"help#gambit-c-help-document")
___DEF_GLO(3,"help#gambit-repl-help")
___DEF_GLO(4,"help#help-names-gambit-c")
___DEF_GLO(5,"help#help-names-r5rs")
___DEF_GLO(6,"help#main-help-document")
___DEF_GLO(7,"help#r5rs-help-document")
___DEF_GLO(8,"##escape-link")
___DEF_GLO(9,"##object->string")
___DEF_GLO(10,"##procedure-name")
___DEF_GLO(11,"error")
___DEF_GLO(12,"gr#show-help-document")
___DEF_GLO(13,"path-expand")
___DEF_GLO(14,"string-append")
___END_GLO

#define ___GLO__20_help ___GLO(0,___G__20_help)
#define ___PRM__20_help ___PRM(0,___G__20_help)
#define ___GLO__23__23_help_2d_hook ___GLO(1,___G__23__23_help_2d_hook)
#define ___PRM__23__23_help_2d_hook ___PRM(1,___G__23__23_help_2d_hook)
#define ___GLO_help_23_gambit_2d_c_2d_help_2d_document ___GLO(2,___G_help_23_gambit_2d_c_2d_help_2d_document)
#define ___PRM_help_23_gambit_2d_c_2d_help_2d_document ___PRM(2,___G_help_23_gambit_2d_c_2d_help_2d_document)
#define ___GLO_help_23_gambit_2d_repl_2d_help ___GLO(3,___G_help_23_gambit_2d_repl_2d_help)
#define ___PRM_help_23_gambit_2d_repl_2d_help ___PRM(3,___G_help_23_gambit_2d_repl_2d_help)
#define ___GLO_help_23_help_2d_names_2d_gambit_2d_c ___GLO(4,___G_help_23_help_2d_names_2d_gambit_2d_c)
#define ___PRM_help_23_help_2d_names_2d_gambit_2d_c ___PRM(4,___G_help_23_help_2d_names_2d_gambit_2d_c)
#define ___GLO_help_23_help_2d_names_2d_r5rs ___GLO(5,___G_help_23_help_2d_names_2d_r5rs)
#define ___PRM_help_23_help_2d_names_2d_r5rs ___PRM(5,___G_help_23_help_2d_names_2d_r5rs)
#define ___GLO_help_23_main_2d_help_2d_document ___GLO(6,___G_help_23_main_2d_help_2d_document)
#define ___PRM_help_23_main_2d_help_2d_document ___PRM(6,___G_help_23_main_2d_help_2d_document)
#define ___GLO_help_23_r5rs_2d_help_2d_document ___GLO(7,___G_help_23_r5rs_2d_help_2d_document)
#define ___PRM_help_23_r5rs_2d_help_2d_document ___PRM(7,___G_help_23_r5rs_2d_help_2d_document)
#define ___GLO__23__23_escape_2d_link ___GLO(8,___G__23__23_escape_2d_link)
#define ___PRM__23__23_escape_2d_link ___PRM(8,___G__23__23_escape_2d_link)
#define ___GLO__23__23_object_2d__3e_string ___GLO(9,___G__23__23_object_2d__3e_string)
#define ___PRM__23__23_object_2d__3e_string ___PRM(9,___G__23__23_object_2d__3e_string)
#define ___GLO__23__23_procedure_2d_name ___GLO(10,___G__23__23_procedure_2d_name)
#define ___PRM__23__23_procedure_2d_name ___PRM(10,___G__23__23_procedure_2d_name)
#define ___GLO_error ___GLO(11,___G_error)
#define ___PRM_error ___PRM(11,___G_error)
#define ___GLO_gr_23_show_2d_help_2d_document ___GLO(12,___G_gr_23_show_2d_help_2d_document)
#define ___PRM_gr_23_show_2d_help_2d_document ___PRM(12,___G_gr_23_show_2d_help_2d_document)
#define ___GLO_path_2d_expand ___GLO(13,___G_path_2d_expand)
#define ___PRM_path_2d_expand ___PRM(13,___G_path_2d_expand)
#define ___GLO_string_2d_append ___GLO(14,___G_string_2d_append)
#define ___PRM_string_2d_append ___PRM(14,___G_string_2d_append)

___BEGIN_CNS
 ___DEF_CNS(___REF_SYM(0,___S__2a_),___REF_CNS(1))
,___DEF_CNS(___REF_SYM(1,___S__2b_),___REF_CNS(2))
,___DEF_CNS(___REF_SYM(2,___S__2d_),___REF_CNS(3))
,___DEF_CNS(___REF_SYM(3,___S__2f_),___REF_CNS(4))
,___DEF_CNS(___REF_SYM(4,___S__3c_),___REF_CNS(5))
,___DEF_CNS(___REF_SYM(5,___S__3c__3d_),___REF_CNS(6))
,___DEF_CNS(___REF_SYM(6,___S__3d_),___REF_CNS(7))
,___DEF_CNS(___REF_SYM(7,___S__3e_),___REF_CNS(8))
,___DEF_CNS(___REF_SYM(8,___S__3e__3d_),___REF_CNS(9))
,___DEF_CNS(___REF_SYM(11,___S_abs),___REF_CNS(10))
,___DEF_CNS(___REF_SYM(12,___S_acos),___REF_CNS(11))
,___DEF_CNS(___REF_SYM(20,___S_and),___REF_CNS(12))
,___DEF_CNS(___REF_SYM(21,___S_angle),___REF_CNS(13))
,___DEF_CNS(___REF_SYM(23,___S_append),___REF_CNS(14))
,___DEF_CNS(___REF_SYM(36,___S_apply),___REF_CNS(15))
,___DEF_CNS(___REF_SYM(38,___S_asin),___REF_CNS(16))
,___DEF_CNS(___REF_SYM(39,___S_assoc),___REF_CNS(17))
,___DEF_CNS(___REF_SYM(40,___S_assq),___REF_CNS(18))
,___DEF_CNS(___REF_SYM(41,___S_assv),___REF_CNS(19))
,___DEF_CNS(___REF_SYM(42,___S_atan),___REF_CNS(20))
,___DEF_CNS(___REF_SYM(43,___S_begin),___REF_CNS(21))
,___DEF_CNS(___REF_SYM(51,___S_boolean_3f_),___REF_CNS(22))
,___DEF_CNS(___REF_SYM(60,___S_caar),___REF_CNS(23))
,___DEF_CNS(___REF_SYM(61,___S_cadr),___REF_CNS(24))
,___DEF_CNS(___REF_SYM(62,___S_call_2d_with_2d_current_2d_continuation),___REF_CNS(25))
,___DEF_CNS(___REF_SYM(63,___S_call_2d_with_2d_input_2d_file),___REF_CNS(26))
,___DEF_CNS(___REF_SYM(68,___S_call_2d_with_2d_output_2d_file),___REF_CNS(27))
,___DEF_CNS(___REF_SYM(73,___S_call_2d_with_2d_values),___REF_CNS(28))
,___DEF_CNS(___REF_SYM(75,___S_car),___REF_CNS(29))
,___DEF_CNS(___REF_SYM(76,___S_case),___REF_CNS(30))
,___DEF_CNS(___REF_SYM(77,___S_cdddar),___REF_CNS(31))
,___DEF_CNS(___REF_SYM(78,___S_cddddr),___REF_CNS(32))
,___DEF_CNS(___REF_SYM(79,___S_cdr),___REF_CNS(33))
,___DEF_CNS(___REF_SYM(80,___S_ceiling),___REF_CNS(34))
,___DEF_CNS(___REF_SYM(86,___S_char_2d__3e_integer),___REF_CNS(35))
,___DEF_CNS(___REF_SYM(87,___S_char_2d_alphabetic_3f_),___REF_CNS(36))
,___DEF_CNS(___REF_SYM(88,___S_char_2d_ci_3c__3d__3f_),___REF_CNS(37))
,___DEF_CNS(___REF_SYM(89,___S_char_2d_ci_3c__3f_),___REF_CNS(38))
,___DEF_CNS(___REF_SYM(90,___S_char_2d_ci_3d__3f_),___REF_CNS(39))
,___DEF_CNS(___REF_SYM(91,___S_char_2d_ci_3e__3d__3f_),___REF_CNS(40))
,___DEF_CNS(___REF_SYM(92,___S_char_2d_ci_3e__3f_),___REF_CNS(41))
,___DEF_CNS(___REF_SYM(93,___S_char_2d_downcase),___REF_CNS(42))
,___DEF_CNS(___REF_SYM(94,___S_char_2d_lower_2d_case_3f_),___REF_CNS(43))
,___DEF_CNS(___REF_SYM(95,___S_char_2d_numeric_3f_),___REF_CNS(44))
,___DEF_CNS(___REF_SYM(96,___S_char_2d_ready_3f_),___REF_CNS(45))
,___DEF_CNS(___REF_SYM(97,___S_char_2d_upcase),___REF_CNS(46))
,___DEF_CNS(___REF_SYM(98,___S_char_2d_upper_2d_case_3f_),___REF_CNS(47))
,___DEF_CNS(___REF_SYM(99,___S_char_2d_whitespace_3f_),___REF_CNS(48))
,___DEF_CNS(___REF_SYM(100,___S_char_3c__3d__3f_),___REF_CNS(49))
,___DEF_CNS(___REF_SYM(101,___S_char_3c__3f_),___REF_CNS(50))
,___DEF_CNS(___REF_SYM(102,___S_char_3d__3f_),___REF_CNS(51))
,___DEF_CNS(___REF_SYM(103,___S_char_3e__3d__3f_),___REF_CNS(52))
,___DEF_CNS(___REF_SYM(104,___S_char_3e__3f_),___REF_CNS(53))
,___DEF_CNS(___REF_SYM(105,___S_char_3f_),___REF_CNS(54))
,___DEF_CNS(___REF_SYM(107,___S_close_2d_input_2d_port),___REF_CNS(55))
,___DEF_CNS(___REF_SYM(108,___S_close_2d_output_2d_port),___REF_CNS(56))
,___DEF_CNS(___REF_SYM(113,___S_complex_3f_),___REF_CNS(57))
,___DEF_CNS(___REF_SYM(114,___S_cond),___REF_CNS(58))
,___DEF_CNS(___REF_SYM(123,___S_cons),___REF_CNS(59))
,___DEF_CNS(___REF_SYM(131,___S_cos),___REF_CNS(60))
,___DEF_CNS(___REF_SYM(140,___S_current_2d_input_2d_port),___REF_CNS(61))
,___DEF_CNS(___REF_SYM(141,___S_current_2d_output_2d_port),___REF_CNS(62))
,___DEF_CNS(___REF_SYM(162,___S_delay),___REF_CNS(63))
,___DEF_CNS(___REF_SYM(165,___S_denominator),___REF_CNS(64))
,___DEF_CNS(___REF_SYM(167,___S_display),___REF_CNS(65))
,___DEF_CNS(___REF_SYM(179,___S_do),___REF_CNS(66))
,___DEF_CNS(___REF_SYM(180,___S_dynamic_2d_wind),___REF_CNS(67))
,___DEF_CNS(___REF_SYM(181,___S_eof_2d_object_3f_),___REF_CNS(68))
,___DEF_CNS(___REF_SYM(182,___S_eq_3f_),___REF_CNS(69))
,___DEF_CNS(___REF_SYM(184,___S_equal_3f_),___REF_CNS(70))
,___DEF_CNS(___REF_SYM(186,___S_eqv_3f_),___REF_CNS(71))
,___DEF_CNS(___REF_SYM(193,___S_eval),___REF_CNS(72))
,___DEF_CNS(___REF_SYM(194,___S_even_3f_),___REF_CNS(73))
,___DEF_CNS(___REF_SYM(195,___S_exact_2d__3e_inexact),___REF_CNS(74))
,___DEF_CNS(___REF_SYM(196,___S_exact_3f_),___REF_CNS(75))
,___DEF_CNS(___REF_SYM(198,___S_exp),___REF_CNS(76))
,___DEF_CNS(___REF_SYM(203,___S_expt),___REF_CNS(77))
,___DEF_CNS(___REF_SYM(292,___S_floor),___REF_CNS(78))
,___DEF_CNS(___REF_SYM(300,___S_for_2d_each),___REF_CNS(79))
,___DEF_CNS(___REF_SYM(301,___S_force),___REF_CNS(80))
,___DEF_CNS(___REF_SYM(349,___S_gcd),___REF_CNS(81))
,___DEF_CNS(___REF_SYM(370,___S_if),___REF_CNS(82))
,___DEF_CNS(___REF_SYM(371,___S_imag_2d_part),___REF_CNS(83))
,___DEF_CNS(___REF_SYM(380,___S_inexact_2d__3e_exact),___REF_CNS(84))
,___DEF_CNS(___REF_SYM(381,___S_inexact_3f_),___REF_CNS(85))
,___DEF_CNS(___REF_SYM(395,___S_input_2d_port_3f_),___REF_CNS(86))
,___DEF_CNS(___REF_SYM(396,___S_integer_2d__3e_char),___REF_CNS(87))
,___DEF_CNS(___REF_SYM(400,___S_integer_3f_),___REF_CNS(88))
,___DEF_CNS(___REF_SYM(401,___S_interaction_2d_environment),___REF_CNS(89))
,___DEF_CNS(___REF_SYM(414,___S_lambda),___REF_CNS(90))
,___DEF_CNS(___REF_SYM(415,___S_lcm),___REF_CNS(91))
,___DEF_CNS(___REF_SYM(416,___S_length),___REF_CNS(92))
,___DEF_CNS(___REF_SYM(417,___S_let),___REF_CNS(93))
,___DEF_CNS(___REF_SYM(418,___S_let_2a_),___REF_CNS(94))
,___DEF_CNS(___REF_SYM(419,___S_let_2d_syntax),___REF_CNS(95))
,___DEF_CNS(___REF_SYM(420,___S_letrec),___REF_CNS(96))
,___DEF_CNS(___REF_SYM(421,___S_letrec_2d_syntax),___REF_CNS(97))
,___DEF_CNS(___REF_SYM(424,___S_list),___REF_CNS(98))
,___DEF_CNS(___REF_SYM(431,___S_list_2d__3e_string),___REF_CNS(99))
,___DEF_CNS(___REF_SYM(437,___S_list_2d__3e_vector),___REF_CNS(100))
,___DEF_CNS(___REF_SYM(438,___S_list_2d_ref),___REF_CNS(101))
,___DEF_CNS(___REF_SYM(439,___S_list_2d_tail),___REF_CNS(102))
,___DEF_CNS(___REF_SYM(440,___S_list_3f_),___REF_CNS(103))
,___DEF_CNS(___REF_SYM(441,___S_load),___REF_CNS(104))
,___DEF_CNS(___REF_SYM(442,___S_log),___REF_CNS(105))
,___DEF_CNS(___REF_SYM(443,___S_magnitude),___REF_CNS(106))
,___DEF_CNS(___REF_SYM(453,___S_make_2d_polar),___REF_CNS(107))
,___DEF_CNS(___REF_SYM(455,___S_make_2d_rectangular),___REF_CNS(108))
,___DEF_CNS(___REF_SYM(461,___S_make_2d_string),___REF_CNS(109))
,___DEF_CNS(___REF_SYM(471,___S_make_2d_vector),___REF_CNS(110))
,___DEF_CNS(___REF_SYM(473,___S_map),___REF_CNS(111))
,___DEF_CNS(___REF_SYM(474,___S_max),___REF_CNS(112))
,___DEF_CNS(___REF_SYM(475,___S_member),___REF_CNS(113))
,___DEF_CNS(___REF_SYM(476,___S_memq),___REF_CNS(114))
,___DEF_CNS(___REF_SYM(477,___S_memv),___REF_CNS(115))
,___DEF_CNS(___REF_SYM(478,___S_min),___REF_CNS(116))
,___DEF_CNS(___REF_SYM(479,___S_modulo),___REF_CNS(117))
,___DEF_CNS(___REF_SYM(490,___S_negative_3f_),___REF_CNS(118))
,___DEF_CNS(___REF_SYM(496,___S_newline),___REF_CNS(119))
,___DEF_CNS(___REF_SYM(510,___S_not),___REF_CNS(120))
,___DEF_CNS(___REF_SYM(511,___S_null_2d_environment),___REF_CNS(121))
,___DEF_CNS(___REF_SYM(512,___S_null_3f_),___REF_CNS(122))
,___DEF_CNS(___REF_SYM(513,___S_number_2d__3e_string),___REF_CNS(123))
,___DEF_CNS(___REF_SYM(517,___S_number_3f_),___REF_CNS(124))
,___DEF_CNS(___REF_SYM(518,___S_numerator),___REF_CNS(125))
,___DEF_CNS(___REF_SYM(522,___S_odd_3f_),___REF_CNS(126))
,___DEF_CNS(___REF_SYM(527,___S_open_2d_input_2d_file),___REF_CNS(127))
,___DEF_CNS(___REF_SYM(532,___S_open_2d_output_2d_file),___REF_CNS(128))
,___DEF_CNS(___REF_SYM(546,___S_or),___REF_CNS(129))
,___DEF_CNS(___REF_SYM(560,___S_output_2d_port_3f_),___REF_CNS(130))
,___DEF_CNS(___REF_SYM(561,___S_pair_3f_),___REF_CNS(131))
,___DEF_CNS(___REF_SYM(572,___S_peek_2d_char),___REF_CNS(132))
,___DEF_CNS(___REF_SYM(575,___S_positive_3f_),___REF_CNS(133))
,___DEF_CNS(___REF_SYM(581,___S_procedure_3f_),___REF_CNS(134))
,___DEF_CNS(___REF_SYM(590,___S_quasiquote),___REF_CNS(135))
,___DEF_CNS(___REF_SYM(591,___S_quote),___REF_CNS(136))
,___DEF_CNS(___REF_SYM(592,___S_quotient),___REF_CNS(137))
,___DEF_CNS(___REF_SYM(611,___S_rational_3f_),___REF_CNS(138))
,___DEF_CNS(___REF_SYM(612,___S_rationalize),___REF_CNS(139))
,___DEF_CNS(___REF_SYM(613,___S_read),___REF_CNS(140))
,___DEF_CNS(___REF_SYM(615,___S_read_2d_char),___REF_CNS(141))
,___DEF_CNS(___REF_SYM(641,___S_real_2d_part),___REF_CNS(142))
,___DEF_CNS(___REF_SYM(643,___S_real_3f_),___REF_CNS(143))
,___DEF_CNS(___REF_SYM(645,___S_remainder),___REF_CNS(144))
,___DEF_CNS(___REF_SYM(653,___S_reverse),___REF_CNS(145))
,___DEF_CNS(___REF_SYM(654,___S_round),___REF_CNS(146))
,___DEF_CNS(___REF_SYM(701,___S_scheme_2d_report_2d_environment),___REF_CNS(147))
,___DEF_CNS(___REF_SYM(710,___S_set_21_),___REF_CNS(148))
,___DEF_CNS(___REF_SYM(712,___S_set_2d_car_21_),___REF_CNS(149))
,___DEF_CNS(___REF_SYM(713,___S_set_2d_cdr_21_),___REF_CNS(150))
,___DEF_CNS(___REF_SYM(721,___S_sin),___REF_CNS(151))
,___DEF_CNS(___REF_SYM(800,___S_sqrt),___REF_CNS(152))
,___DEF_CNS(___REF_SYM(807,___S_string),___REF_CNS(153))
,___DEF_CNS(___REF_SYM(809,___S_string_2d__3e_list),___REF_CNS(154))
,___DEF_CNS(___REF_SYM(810,___S_string_2d__3e_number),___REF_CNS(155))
,___DEF_CNS(___REF_SYM(811,___S_string_2d__3e_symbol),___REF_CNS(156))
,___DEF_CNS(___REF_SYM(812,___S_string_2d_append),___REF_CNS(157))
,___DEF_CNS(___REF_SYM(813,___S_string_2d_ci_3c__3d__3f_),___REF_CNS(158))
,___DEF_CNS(___REF_SYM(814,___S_string_2d_ci_3c__3f_),___REF_CNS(159))
,___DEF_CNS(___REF_SYM(815,___S_string_2d_ci_3d__3f_),___REF_CNS(160))
,___DEF_CNS(___REF_SYM(817,___S_string_2d_ci_3e__3d__3f_),___REF_CNS(161))
,___DEF_CNS(___REF_SYM(818,___S_string_2d_ci_3e__3f_),___REF_CNS(162))
,___DEF_CNS(___REF_SYM(819,___S_string_2d_copy),___REF_CNS(163))
,___DEF_CNS(___REF_SYM(820,___S_string_2d_fill_21_),___REF_CNS(164))
,___DEF_CNS(___REF_SYM(821,___S_string_2d_length),___REF_CNS(165))
,___DEF_CNS(___REF_SYM(822,___S_string_2d_ref),___REF_CNS(166))
,___DEF_CNS(___REF_SYM(823,___S_string_2d_set_21_),___REF_CNS(167))
,___DEF_CNS(___REF_SYM(825,___S_string_3c__3d__3f_),___REF_CNS(168))
,___DEF_CNS(___REF_SYM(826,___S_string_3c__3f_),___REF_CNS(169))
,___DEF_CNS(___REF_SYM(827,___S_string_3d__3f_),___REF_CNS(170))
,___DEF_CNS(___REF_SYM(829,___S_string_3e__3d__3f_),___REF_CNS(171))
,___DEF_CNS(___REF_SYM(830,___S_string_3e__3f_),___REF_CNS(172))
,___DEF_CNS(___REF_SYM(831,___S_string_3f_),___REF_CNS(173))
,___DEF_CNS(___REF_SYM(850,___S_substring),___REF_CNS(174))
,___DEF_CNS(___REF_SYM(868,___S_symbol_2d__3e_string),___REF_CNS(175))
,___DEF_CNS(___REF_SYM(870,___S_symbol_3f_),___REF_CNS(176))
,___DEF_CNS(___REF_SYM(871,___S_syntax_2d_rules),___REF_CNS(177))
,___DEF_CNS(___REF_SYM(887,___S_tan),___REF_CNS(178))
,___DEF_CNS(___REF_SYM(950,___S_transcript_2d_off),___REF_CNS(179))
,___DEF_CNS(___REF_SYM(951,___S_transcript_2d_on),___REF_CNS(180))
,___DEF_CNS(___REF_SYM(952,___S_truncate),___REF_CNS(181))
,___DEF_CNS(___REF_SYM(1046,___S_values),___REF_CNS(182))
,___DEF_CNS(___REF_SYM(1047,___S_vector),___REF_CNS(183))
,___DEF_CNS(___REF_SYM(1048,___S_vector_2d__3e_list),___REF_CNS(184))
,___DEF_CNS(___REF_SYM(1051,___S_vector_2d_fill_21_),___REF_CNS(185))
,___DEF_CNS(___REF_SYM(1052,___S_vector_2d_length),___REF_CNS(186))
,___DEF_CNS(___REF_SYM(1053,___S_vector_2d_ref),___REF_CNS(187))
,___DEF_CNS(___REF_SYM(1054,___S_vector_2d_set_21_),___REF_CNS(188))
,___DEF_CNS(___REF_SYM(1056,___S_vector_3f_),___REF_CNS(189))
,___DEF_CNS(___REF_SYM(1063,___S_with_2d_input_2d_from_2d_file),___REF_CNS(190))
,___DEF_CNS(___REF_SYM(1069,___S_with_2d_output_2d_to_2d_file),___REF_CNS(191))
,___DEF_CNS(___REF_SYM(1075,___S_write),___REF_CNS(192))
,___DEF_CNS(___REF_SYM(1076,___S_write_2d_char),___REF_CNS(193))
,___DEF_CNS(___REF_SYM(1083,___S_zero_3f_),___REF_NUL)
,___DEF_CNS(___REF_SYM(4,___S__3c_),___REF_CNS(195))
,___DEF_CNS(___REF_SYM(5,___S__3c__3d_),___REF_CNS(196))
,___DEF_CNS(___REF_SYM(6,___S__3d_),___REF_CNS(197))
,___DEF_CNS(___REF_SYM(7,___S__3e_),___REF_CNS(198))
,___DEF_CNS(___REF_SYM(8,___S__3e__3d_),___REF_CNS(199))
,___DEF_CNS(___REF_SYM(9,___S_abandoned_2d_mutex_2d_exception_3f_),___REF_CNS(200))
,___DEF_CNS(___REF_SYM(10,___S_abort),___REF_CNS(201))
,___DEF_CNS(___REF_SYM(13,___S_address_2d_info_2d_family),___REF_CNS(202))
,___DEF_CNS(___REF_SYM(14,___S_address_2d_info_2d_protocol),___REF_CNS(203))
,___DEF_CNS(___REF_SYM(15,___S_address_2d_info_2d_socket_2d_info),___REF_CNS(204))
,___DEF_CNS(___REF_SYM(16,___S_address_2d_info_2d_socket_2d_type),___REF_CNS(205))
,___DEF_CNS(___REF_SYM(17,___S_address_2d_info_3f_),___REF_CNS(206))
,___DEF_CNS(___REF_SYM(18,___S_address_2d_infos),___REF_CNS(207))
,___DEF_CNS(___REF_SYM(19,___S_all_2d_bits_2d_set_3f_),___REF_CNS(208))
,___DEF_CNS(___REF_SYM(22,___S_any_2d_bits_2d_set_3f_),___REF_CNS(209))
,___DEF_CNS(___REF_SYM(24,___S_append_2d_f32vectors),___REF_CNS(210))
,___DEF_CNS(___REF_SYM(25,___S_append_2d_f64vectors),___REF_CNS(211))
,___DEF_CNS(___REF_SYM(26,___S_append_2d_s16vectors),___REF_CNS(212))
,___DEF_CNS(___REF_SYM(27,___S_append_2d_s32vectors),___REF_CNS(213))
,___DEF_CNS(___REF_SYM(28,___S_append_2d_s64vectors),___REF_CNS(214))
,___DEF_CNS(___REF_SYM(29,___S_append_2d_s8vectors),___REF_CNS(215))
,___DEF_CNS(___REF_SYM(30,___S_append_2d_strings),___REF_CNS(216))
,___DEF_CNS(___REF_SYM(31,___S_append_2d_u16vectors),___REF_CNS(217))
,___DEF_CNS(___REF_SYM(32,___S_append_2d_u32vectors),___REF_CNS(218))
,___DEF_CNS(___REF_SYM(33,___S_append_2d_u64vectors),___REF_CNS(219))
,___DEF_CNS(___REF_SYM(34,___S_append_2d_u8vectors),___REF_CNS(220))
,___DEF_CNS(___REF_SYM(35,___S_append_2d_vectors),___REF_CNS(221))
,___DEF_CNS(___REF_SYM(37,___S_arithmetic_2d_shift),___REF_CNS(222))
,___DEF_CNS(___REF_SYM(44,___S_bit_2d_count),___REF_CNS(223))
,___DEF_CNS(___REF_SYM(45,___S_bit_2d_set_3f_),___REF_CNS(224))
,___DEF_CNS(___REF_SYM(46,___S_bitwise_2d_and),___REF_CNS(225))
,___DEF_CNS(___REF_SYM(47,___S_bitwise_2d_ior),___REF_CNS(226))
,___DEF_CNS(___REF_SYM(48,___S_bitwise_2d_merge),___REF_CNS(227))
,___DEF_CNS(___REF_SYM(49,___S_bitwise_2d_not),___REF_CNS(228))
,___DEF_CNS(___REF_SYM(50,___S_bitwise_2d_xor),___REF_CNS(229))
,___DEF_CNS(___REF_SYM(52,___S_box),___REF_CNS(230))
,___DEF_CNS(___REF_SYM(53,___S_box_3f_),___REF_CNS(231))
,___DEF_CNS(___REF_SYM(54,___S_break),___REF_CNS(232))
,___DEF_CNS(___REF_SYM(55,___S_c_2d_declare),___REF_CNS(233))
,___DEF_CNS(___REF_SYM(56,___S_c_2d_define),___REF_CNS(234))
,___DEF_CNS(___REF_SYM(57,___S_c_2d_define_2d_type),___REF_CNS(235))
,___DEF_CNS(___REF_SYM(58,___S_c_2d_initialize),___REF_CNS(236))
,___DEF_CNS(___REF_SYM(59,___S_c_2d_lambda),___REF_CNS(237))
,___DEF_CNS(___REF_SYM(62,___S_call_2d_with_2d_current_2d_continuation),___REF_CNS(238))
,___DEF_CNS(___REF_SYM(63,___S_call_2d_with_2d_input_2d_file),___REF_CNS(239))
,___DEF_CNS(___REF_SYM(64,___S_call_2d_with_2d_input_2d_process),___REF_CNS(240))
,___DEF_CNS(___REF_SYM(65,___S_call_2d_with_2d_input_2d_string),___REF_CNS(241))
,___DEF_CNS(___REF_SYM(66,___S_call_2d_with_2d_input_2d_u8vector),___REF_CNS(242))
,___DEF_CNS(___REF_SYM(67,___S_call_2d_with_2d_input_2d_vector),___REF_CNS(243))
,___DEF_CNS(___REF_SYM(68,___S_call_2d_with_2d_output_2d_file),___REF_CNS(244))
,___DEF_CNS(___REF_SYM(69,___S_call_2d_with_2d_output_2d_process),___REF_CNS(245))
,___DEF_CNS(___REF_SYM(70,___S_call_2d_with_2d_output_2d_string),___REF_CNS(246))
,___DEF_CNS(___REF_SYM(71,___S_call_2d_with_2d_output_2d_u8vector),___REF_CNS(247))
,___DEF_CNS(___REF_SYM(72,___S_call_2d_with_2d_output_2d_vector),___REF_CNS(248))
,___DEF_CNS(___REF_SYM(74,___S_call_2f_cc),___REF_CNS(249))
,___DEF_CNS(___REF_SYM(81,___S_cfun_2d_conversion_2d_exception_2d_arguments),___REF_CNS(250))
,___DEF_CNS(___REF_SYM(82,___S_cfun_2d_conversion_2d_exception_2d_code),___REF_CNS(251))
,___DEF_CNS(___REF_SYM(83,___S_cfun_2d_conversion_2d_exception_2d_message),___REF_CNS(252))
,___DEF_CNS(___REF_SYM(84,___S_cfun_2d_conversion_2d_exception_2d_procedure),___REF_CNS(253))
,___DEF_CNS(___REF_SYM(85,___S_cfun_2d_conversion_2d_exception_3f_),___REF_CNS(254))
,___DEF_CNS(___REF_SYM(86,___S_char_2d__3e_integer),___REF_CNS(255))
,___DEF_CNS(___REF_SYM(88,___S_char_2d_ci_3c__3d__3f_),___REF_CNS(256))
,___DEF_CNS(___REF_SYM(89,___S_char_2d_ci_3c__3f_),___REF_CNS(257))
,___DEF_CNS(___REF_SYM(90,___S_char_2d_ci_3d__3f_),___REF_CNS(258))
,___DEF_CNS(___REF_SYM(91,___S_char_2d_ci_3e__3d__3f_),___REF_CNS(259))
,___DEF_CNS(___REF_SYM(92,___S_char_2d_ci_3e__3f_),___REF_CNS(260))
,___DEF_CNS(___REF_SYM(100,___S_char_3c__3d__3f_),___REF_CNS(261))
,___DEF_CNS(___REF_SYM(101,___S_char_3c__3f_),___REF_CNS(262))
,___DEF_CNS(___REF_SYM(102,___S_char_3d__3f_),___REF_CNS(263))
,___DEF_CNS(___REF_SYM(103,___S_char_3e__3d__3f_),___REF_CNS(264))
,___DEF_CNS(___REF_SYM(104,___S_char_3e__3f_),___REF_CNS(265))
,___DEF_CNS(___REF_SYM(106,___S_clear_2d_bit_2d_field),___REF_CNS(266))
,___DEF_CNS(___REF_SYM(107,___S_close_2d_input_2d_port),___REF_CNS(267))
,___DEF_CNS(___REF_SYM(108,___S_close_2d_output_2d_port),___REF_CNS(268))
,___DEF_CNS(___REF_SYM(109,___S_close_2d_port),___REF_CNS(269))
,___DEF_CNS(___REF_SYM(110,___S_command_2d_line),___REF_CNS(270))
,___DEF_CNS(___REF_SYM(111,___S_compile_2d_file),___REF_CNS(271))
,___DEF_CNS(___REF_SYM(112,___S_compile_2d_file_2d_to_2d_c),___REF_CNS(272))
,___DEF_CNS(___REF_SYM(115,___S_cond_2d_expand),___REF_CNS(273))
,___DEF_CNS(___REF_SYM(116,___S_condition_2d_variable_2d_broadcast_21_),___REF_CNS(274))
,___DEF_CNS(___REF_SYM(117,___S_condition_2d_variable_2d_name),___REF_CNS(275))
,___DEF_CNS(___REF_SYM(118,___S_condition_2d_variable_2d_signal_21_),___REF_CNS(276))
,___DEF_CNS(___REF_SYM(119,___S_condition_2d_variable_2d_specific),___REF_CNS(277))
,___DEF_CNS(___REF_SYM(120,___S_condition_2d_variable_2d_specific_2d_set_21_),___REF_CNS(278))
,___DEF_CNS(___REF_SYM(121,___S_condition_2d_variable_3f_),___REF_CNS(279))
,___DEF_CNS(___REF_SYM(122,___S_configure_2d_command_2d_string),___REF_CNS(280))
,___DEF_CNS(___REF_SYM(124,___S_console_2d_port),___REF_CNS(281))
,___DEF_CNS(___REF_SYM(125,___S_continuation_2d_capture),___REF_CNS(282))
,___DEF_CNS(___REF_SYM(126,___S_continuation_2d_graft),___REF_CNS(283))
,___DEF_CNS(___REF_SYM(127,___S_continuation_2d_return),___REF_CNS(284))
,___DEF_CNS(___REF_SYM(128,___S_continuation_3f_),___REF_CNS(285))
,___DEF_CNS(___REF_SYM(129,___S_copy_2d_bit_2d_field),___REF_CNS(286))
,___DEF_CNS(___REF_SYM(130,___S_copy_2d_file),___REF_CNS(287))
,___DEF_CNS(___REF_SYM(132,___S_cpu_2d_time),___REF_CNS(288))
,___DEF_CNS(___REF_SYM(133,___S_create_2d_directory),___REF_CNS(289))
,___DEF_CNS(___REF_SYM(134,___S_create_2d_fifo),___REF_CNS(290))
,___DEF_CNS(___REF_SYM(135,___S_create_2d_link),___REF_CNS(291))
,___DEF_CNS(___REF_SYM(136,___S_create_2d_symbolic_2d_link),___REF_CNS(292))
,___DEF_CNS(___REF_SYM(137,___S_current_2d_directory),___REF_CNS(293))
,___DEF_CNS(___REF_SYM(138,___S_current_2d_error_2d_port),___REF_CNS(294))
,___DEF_CNS(___REF_SYM(139,___S_current_2d_exception_2d_handler),___REF_CNS(295))
,___DEF_CNS(___REF_SYM(140,___S_current_2d_input_2d_port),___REF_CNS(296))
,___DEF_CNS(___REF_SYM(141,___S_current_2d_output_2d_port),___REF_CNS(297))
,___DEF_CNS(___REF_SYM(142,___S_current_2d_readtable),___REF_CNS(298))
,___DEF_CNS(___REF_SYM(143,___S_current_2d_thread),___REF_CNS(299))
,___DEF_CNS(___REF_SYM(144,___S_current_2d_time),___REF_CNS(300))
,___DEF_CNS(___REF_SYM(145,___S_current_2d_user_2d_interrupt_2d_handler),___REF_CNS(301))
,___DEF_CNS(___REF_SYM(146,___S_datum_2d_parsing_2d_exception_2d_kind),___REF_CNS(302))
,___DEF_CNS(___REF_SYM(147,___S_datum_2d_parsing_2d_exception_2d_parameters),___REF_CNS(303))
,___DEF_CNS(___REF_SYM(148,___S_datum_2d_parsing_2d_exception_2d_readenv),___REF_CNS(304))
,___DEF_CNS(___REF_SYM(149,___S_datum_2d_parsing_2d_exception_3f_),___REF_CNS(305))
,___DEF_CNS(___REF_SYM(150,___S_deadlock_2d_exception_3f_),___REF_CNS(306))
,___DEF_CNS(___REF_SYM(151,___S_declare),___REF_CNS(307))
,___DEF_CNS(___REF_SYM(152,___S_default_2d_random_2d_source),___REF_CNS(308))
,___DEF_CNS(___REF_SYM(153,___S_defer_2d_user_2d_interrupts),___REF_CNS(309))
,___DEF_CNS(___REF_SYM(154,___S_define),___REF_CNS(310))
,___DEF_CNS(___REF_SYM(155,___S_define_2d_cond_2d_expand_2d_feature),___REF_CNS(311))
,___DEF_CNS(___REF_SYM(156,___S_define_2d_macro),___REF_CNS(312))
,___DEF_CNS(___REF_SYM(157,___S_define_2d_record_2d_type),___REF_CNS(313))
,___DEF_CNS(___REF_SYM(158,___S_define_2d_structure),___REF_CNS(314))
,___DEF_CNS(___REF_SYM(159,___S_define_2d_syntax),___REF_CNS(315))
,___DEF_CNS(___REF_SYM(160,___S_define_2d_type),___REF_CNS(316))
,___DEF_CNS(___REF_SYM(161,___S_define_2d_type_2d_of_2d_thread),___REF_CNS(317))
,___DEF_CNS(___REF_SYM(163,___S_delete_2d_directory),___REF_CNS(318))
,___DEF_CNS(___REF_SYM(164,___S_delete_2d_file),___REF_CNS(319))
,___DEF_CNS(___REF_SYM(166,___S_directory_2d_files),___REF_CNS(320))
,___DEF_CNS(___REF_SYM(168,___S_display_2d_continuation_2d_backtrace),___REF_CNS(321))
,___DEF_CNS(___REF_SYM(169,___S_display_2d_continuation_2d_dynamic_2d_environment),___REF_CNS(322))
,___DEF_CNS(___REF_SYM(170,___S_display_2d_continuation_2d_environment),___REF_CNS(323))
,___DEF_CNS(___REF_SYM(171,___S_display_2d_dynamic_2d_environment_3f_),___REF_CNS(324))
,___DEF_CNS(___REF_SYM(172,___S_display_2d_environment_2d_set_21_),___REF_CNS(325))
,___DEF_CNS(___REF_SYM(173,___S_display_2d_exception),___REF_CNS(326))
,___DEF_CNS(___REF_SYM(174,___S_display_2d_exception_2d_in_2d_context),___REF_CNS(327))
,___DEF_CNS(___REF_SYM(175,___S_display_2d_procedure_2d_environment),___REF_CNS(328))
,___DEF_CNS(___REF_SYM(176,___S_divide_2d_by_2d_zero_2d_exception_2d_arguments),___REF_CNS(329))
,___DEF_CNS(___REF_SYM(177,___S_divide_2d_by_2d_zero_2d_exception_2d_procedure),___REF_CNS(330))
,___DEF_CNS(___REF_SYM(178,___S_divide_2d_by_2d_zero_2d_exception_3f_),___REF_CNS(331))
,___DEF_CNS(___REF_SYM(183,___S_eq_3f__2d_hash),___REF_CNS(332))
,___DEF_CNS(___REF_SYM(185,___S_equal_3f__2d_hash),___REF_CNS(333))
,___DEF_CNS(___REF_SYM(187,___S_eqv_3f__2d_hash),___REF_CNS(334))
,___DEF_CNS(___REF_SYM(188,___S_err_2d_code_2d__3e_string),___REF_CNS(335))
,___DEF_CNS(___REF_SYM(189,___S_error),___REF_CNS(336))
,___DEF_CNS(___REF_SYM(190,___S_error_2d_exception_2d_message),___REF_CNS(337))
,___DEF_CNS(___REF_SYM(191,___S_error_2d_exception_2d_parameters),___REF_CNS(338))
,___DEF_CNS(___REF_SYM(192,___S_error_2d_exception_3f_),___REF_CNS(339))
,___DEF_CNS(___REF_SYM(193,___S_eval),___REF_CNS(340))
,___DEF_CNS(___REF_SYM(197,___S_exit),___REF_CNS(341))
,___DEF_CNS(___REF_SYM(199,___S_expression_2d_parsing_2d_exception_2d_kind),___REF_CNS(342))
,___DEF_CNS(___REF_SYM(200,___S_expression_2d_parsing_2d_exception_2d_parameters),___REF_CNS(343))
,___DEF_CNS(___REF_SYM(201,___S_expression_2d_parsing_2d_exception_2d_source),___REF_CNS(344))
,___DEF_CNS(___REF_SYM(202,___S_expression_2d_parsing_2d_exception_3f_),___REF_CNS(345))
,___DEF_CNS(___REF_SYM(204,___S_extract_2d_bit_2d_field),___REF_CNS(346))
,___DEF_CNS(___REF_SYM(205,___S_f32vector),___REF_CNS(347))
,___DEF_CNS(___REF_SYM(206,___S_f32vector_2d__3e_list),___REF_CNS(348))
,___DEF_CNS(___REF_SYM(207,___S_f32vector_2d_append),___REF_CNS(349))
,___DEF_CNS(___REF_SYM(208,___S_f32vector_2d_copy),___REF_CNS(350))
,___DEF_CNS(___REF_SYM(209,___S_f32vector_2d_fill_21_),___REF_CNS(351))
,___DEF_CNS(___REF_SYM(210,___S_f32vector_2d_length),___REF_CNS(352))
,___DEF_CNS(___REF_SYM(211,___S_f32vector_2d_ref),___REF_CNS(353))
,___DEF_CNS(___REF_SYM(212,___S_f32vector_2d_set_21_),___REF_CNS(354))
,___DEF_CNS(___REF_SYM(213,___S_f32vector_2d_shrink_21_),___REF_CNS(355))
,___DEF_CNS(___REF_SYM(214,___S_f32vector_3f_),___REF_CNS(356))
,___DEF_CNS(___REF_SYM(215,___S_f64vector),___REF_CNS(357))
,___DEF_CNS(___REF_SYM(216,___S_f64vector_2d__3e_list),___REF_CNS(358))
,___DEF_CNS(___REF_SYM(217,___S_f64vector_2d_append),___REF_CNS(359))
,___DEF_CNS(___REF_SYM(218,___S_f64vector_2d_copy),___REF_CNS(360))
,___DEF_CNS(___REF_SYM(219,___S_f64vector_2d_fill_21_),___REF_CNS(361))
,___DEF_CNS(___REF_SYM(220,___S_f64vector_2d_length),___REF_CNS(362))
,___DEF_CNS(___REF_SYM(221,___S_f64vector_2d_ref),___REF_CNS(363))
,___DEF_CNS(___REF_SYM(222,___S_f64vector_2d_set_21_),___REF_CNS(364))
,___DEF_CNS(___REF_SYM(223,___S_f64vector_2d_shrink_21_),___REF_CNS(365))
,___DEF_CNS(___REF_SYM(224,___S_f64vector_3f_),___REF_CNS(366))
,___DEF_CNS(___REF_SYM(225,___S_file_2d_attributes),___REF_CNS(367))
,___DEF_CNS(___REF_SYM(226,___S_file_2d_creation_2d_time),___REF_CNS(368))
,___DEF_CNS(___REF_SYM(227,___S_file_2d_device),___REF_CNS(369))
,___DEF_CNS(___REF_SYM(228,___S_file_2d_exists_3f_),___REF_CNS(370))
,___DEF_CNS(___REF_SYM(229,___S_file_2d_group),___REF_CNS(371))
,___DEF_CNS(___REF_SYM(230,___S_file_2d_info),___REF_CNS(372))
,___DEF_CNS(___REF_SYM(231,___S_file_2d_info_2d_attributes),___REF_CNS(373))
,___DEF_CNS(___REF_SYM(232,___S_file_2d_info_2d_creation_2d_time),___REF_CNS(374))
,___DEF_CNS(___REF_SYM(233,___S_file_2d_info_2d_device),___REF_CNS(375))
,___DEF_CNS(___REF_SYM(234,___S_file_2d_info_2d_group),___REF_CNS(376))
,___DEF_CNS(___REF_SYM(235,___S_file_2d_info_2d_inode),___REF_CNS(377))
,___DEF_CNS(___REF_SYM(236,___S_file_2d_info_2d_last_2d_access_2d_time),___REF_CNS(378))
,___DEF_CNS(___REF_SYM(237,___S_file_2d_info_2d_last_2d_change_2d_time),___REF_CNS(379))
,___DEF_CNS(___REF_SYM(238,___S_file_2d_info_2d_last_2d_modification_2d_time),___REF_CNS(380))
,___DEF_CNS(___REF_SYM(239,___S_file_2d_info_2d_mode),___REF_CNS(381))
,___DEF_CNS(___REF_SYM(240,___S_file_2d_info_2d_number_2d_of_2d_links),___REF_CNS(382))
,___DEF_CNS(___REF_SYM(241,___S_file_2d_info_2d_owner),___REF_CNS(383))
,___DEF_CNS(___REF_SYM(242,___S_file_2d_info_2d_size),___REF_CNS(384))
,___DEF_CNS(___REF_SYM(243,___S_file_2d_info_2d_type),___REF_CNS(385))
,___DEF_CNS(___REF_SYM(244,___S_file_2d_info_3f_),___REF_CNS(386))
,___DEF_CNS(___REF_SYM(245,___S_file_2d_inode),___REF_CNS(387))
,___DEF_CNS(___REF_SYM(246,___S_file_2d_last_2d_access_2d_time),___REF_CNS(388))
,___DEF_CNS(___REF_SYM(247,___S_file_2d_last_2d_change_2d_time),___REF_CNS(389))
,___DEF_CNS(___REF_SYM(248,___S_file_2d_last_2d_modification_2d_time),___REF_CNS(390))
,___DEF_CNS(___REF_SYM(249,___S_file_2d_mode),___REF_CNS(391))
,___DEF_CNS(___REF_SYM(250,___S_file_2d_number_2d_of_2d_links),___REF_CNS(392))
,___DEF_CNS(___REF_SYM(251,___S_file_2d_owner),___REF_CNS(393))
,___DEF_CNS(___REF_SYM(252,___S_file_2d_size),___REF_CNS(394))
,___DEF_CNS(___REF_SYM(253,___S_file_2d_type),___REF_CNS(395))
,___DEF_CNS(___REF_SYM(254,___S_finite_3f_),___REF_CNS(396))
,___DEF_CNS(___REF_SYM(255,___S_first_2d_bit_2d_set),___REF_CNS(397))
,___DEF_CNS(___REF_SYM(256,___S_fixnum_2d__3e_flonum),___REF_CNS(398))
,___DEF_CNS(___REF_SYM(257,___S_fixnum_2d_overflow_2d_exception_2d_arguments),___REF_CNS(399))
,___DEF_CNS(___REF_SYM(258,___S_fixnum_2d_overflow_2d_exception_2d_procedure),___REF_CNS(400))
,___DEF_CNS(___REF_SYM(259,___S_fixnum_2d_overflow_2d_exception_3f_),___REF_CNS(401))
,___DEF_CNS(___REF_SYM(260,___S_fixnum_3f_),___REF_CNS(402))
,___DEF_CNS(___REF_SYM(261,___S_fl_2a_),___REF_CNS(403))
,___DEF_CNS(___REF_SYM(262,___S_fl_2b_),___REF_CNS(404))
,___DEF_CNS(___REF_SYM(263,___S_fl_2d_),___REF_CNS(405))
,___DEF_CNS(___REF_SYM(264,___S_fl_2f_),___REF_CNS(406))
,___DEF_CNS(___REF_SYM(265,___S_fl_3c_),___REF_CNS(407))
,___DEF_CNS(___REF_SYM(266,___S_fl_3c__3d_),___REF_CNS(408))
,___DEF_CNS(___REF_SYM(267,___S_fl_3d_),___REF_CNS(409))
,___DEF_CNS(___REF_SYM(268,___S_fl_3e_),___REF_CNS(410))
,___DEF_CNS(___REF_SYM(269,___S_fl_3e__3d_),___REF_CNS(411))
,___DEF_CNS(___REF_SYM(270,___S_flabs),___REF_CNS(412))
,___DEF_CNS(___REF_SYM(271,___S_flacos),___REF_CNS(413))
,___DEF_CNS(___REF_SYM(272,___S_flasin),___REF_CNS(414))
,___DEF_CNS(___REF_SYM(273,___S_flatan),___REF_CNS(415))
,___DEF_CNS(___REF_SYM(274,___S_flceiling),___REF_CNS(416))
,___DEF_CNS(___REF_SYM(275,___S_flcos),___REF_CNS(417))
,___DEF_CNS(___REF_SYM(276,___S_fldenominator),___REF_CNS(418))
,___DEF_CNS(___REF_SYM(277,___S_fleven_3f_),___REF_CNS(419))
,___DEF_CNS(___REF_SYM(278,___S_flexp),___REF_CNS(420))
,___DEF_CNS(___REF_SYM(279,___S_flexpt),___REF_CNS(421))
,___DEF_CNS(___REF_SYM(280,___S_flfinite_3f_),___REF_CNS(422))
,___DEF_CNS(___REF_SYM(281,___S_flfloor),___REF_CNS(423))
,___DEF_CNS(___REF_SYM(282,___S_flinfinite_3f_),___REF_CNS(424))
,___DEF_CNS(___REF_SYM(283,___S_flinteger_3f_),___REF_CNS(425))
,___DEF_CNS(___REF_SYM(284,___S_fllog),___REF_CNS(426))
,___DEF_CNS(___REF_SYM(285,___S_flmax),___REF_CNS(427))
,___DEF_CNS(___REF_SYM(286,___S_flmin),___REF_CNS(428))
,___DEF_CNS(___REF_SYM(287,___S_flnan_3f_),___REF_CNS(429))
,___DEF_CNS(___REF_SYM(288,___S_flnegative_3f_),___REF_CNS(430))
,___DEF_CNS(___REF_SYM(289,___S_flnumerator),___REF_CNS(431))
,___DEF_CNS(___REF_SYM(290,___S_flodd_3f_),___REF_CNS(432))
,___DEF_CNS(___REF_SYM(291,___S_flonum_3f_),___REF_CNS(433))
,___DEF_CNS(___REF_SYM(293,___S_flpositive_3f_),___REF_CNS(434))
,___DEF_CNS(___REF_SYM(294,___S_flround),___REF_CNS(435))
,___DEF_CNS(___REF_SYM(295,___S_flsin),___REF_CNS(436))
,___DEF_CNS(___REF_SYM(296,___S_flsqrt),___REF_CNS(437))
,___DEF_CNS(___REF_SYM(297,___S_fltan),___REF_CNS(438))
,___DEF_CNS(___REF_SYM(298,___S_fltruncate),___REF_CNS(439))
,___DEF_CNS(___REF_SYM(299,___S_flzero_3f_),___REF_CNS(440))
,___DEF_CNS(___REF_SYM(302,___S_force_2d_output),___REF_CNS(441))
,___DEF_CNS(___REF_SYM(303,___S_foreign_2d_address),___REF_CNS(442))
,___DEF_CNS(___REF_SYM(304,___S_foreign_2d_release_21_),___REF_CNS(443))
,___DEF_CNS(___REF_SYM(305,___S_foreign_2d_released_3f_),___REF_CNS(444))
,___DEF_CNS(___REF_SYM(306,___S_foreign_2d_tags),___REF_CNS(445))
,___DEF_CNS(___REF_SYM(307,___S_foreign_3f_),___REF_CNS(446))
,___DEF_CNS(___REF_SYM(308,___S_future),___REF_CNS(447))
,___DEF_CNS(___REF_SYM(309,___S_fx_2a_),___REF_CNS(448))
,___DEF_CNS(___REF_SYM(310,___S_fx_2b_),___REF_CNS(449))
,___DEF_CNS(___REF_SYM(311,___S_fx_2d_),___REF_CNS(450))
,___DEF_CNS(___REF_SYM(312,___S_fx_3c_),___REF_CNS(451))
,___DEF_CNS(___REF_SYM(313,___S_fx_3c__3d_),___REF_CNS(452))
,___DEF_CNS(___REF_SYM(314,___S_fx_3d_),___REF_CNS(453))
,___DEF_CNS(___REF_SYM(315,___S_fx_3e_),___REF_CNS(454))
,___DEF_CNS(___REF_SYM(316,___S_fx_3e__3d_),___REF_CNS(455))
,___DEF_CNS(___REF_SYM(317,___S_fxabs),___REF_CNS(456))
,___DEF_CNS(___REF_SYM(318,___S_fxand),___REF_CNS(457))
,___DEF_CNS(___REF_SYM(319,___S_fxarithmetic_2d_shift),___REF_CNS(458))
,___DEF_CNS(___REF_SYM(320,___S_fxarithmetic_2d_shift_2d_left),___REF_CNS(459))
,___DEF_CNS(___REF_SYM(321,___S_fxarithmetic_2d_shift_2d_right),___REF_CNS(460))
,___DEF_CNS(___REF_SYM(322,___S_fxbit_2d_count),___REF_CNS(461))
,___DEF_CNS(___REF_SYM(323,___S_fxbit_2d_set_3f_),___REF_CNS(462))
,___DEF_CNS(___REF_SYM(324,___S_fxeven_3f_),___REF_CNS(463))
,___DEF_CNS(___REF_SYM(325,___S_fxfirst_2d_bit_2d_set),___REF_CNS(464))
,___DEF_CNS(___REF_SYM(326,___S_fxif),___REF_CNS(465))
,___DEF_CNS(___REF_SYM(327,___S_fxior),___REF_CNS(466))
,___DEF_CNS(___REF_SYM(328,___S_fxlength),___REF_CNS(467))
,___DEF_CNS(___REF_SYM(329,___S_fxmax),___REF_CNS(468))
,___DEF_CNS(___REF_SYM(330,___S_fxmin),___REF_CNS(469))
,___DEF_CNS(___REF_SYM(331,___S_fxmodulo),___REF_CNS(470))
,___DEF_CNS(___REF_SYM(332,___S_fxnegative_3f_),___REF_CNS(471))
,___DEF_CNS(___REF_SYM(333,___S_fxnot),___REF_CNS(472))
,___DEF_CNS(___REF_SYM(334,___S_fxodd_3f_),___REF_CNS(473))
,___DEF_CNS(___REF_SYM(335,___S_fxpositive_3f_),___REF_CNS(474))
,___DEF_CNS(___REF_SYM(336,___S_fxquotient),___REF_CNS(475))
,___DEF_CNS(___REF_SYM(337,___S_fxremainder),___REF_CNS(476))
,___DEF_CNS(___REF_SYM(338,___S_fxwrap_2a_),___REF_CNS(477))
,___DEF_CNS(___REF_SYM(339,___S_fxwrap_2b_),___REF_CNS(478))
,___DEF_CNS(___REF_SYM(340,___S_fxwrap_2d_),___REF_CNS(479))
,___DEF_CNS(___REF_SYM(341,___S_fxwrapabs),___REF_CNS(480))
,___DEF_CNS(___REF_SYM(342,___S_fxwraparithmetic_2d_shift),___REF_CNS(481))
,___DEF_CNS(___REF_SYM(343,___S_fxwraparithmetic_2d_shift_2d_left),___REF_CNS(482))
,___DEF_CNS(___REF_SYM(344,___S_fxwraplogical_2d_shift_2d_right),___REF_CNS(483))
,___DEF_CNS(___REF_SYM(345,___S_fxwrapquotient),___REF_CNS(484))
,___DEF_CNS(___REF_SYM(346,___S_fxxor),___REF_CNS(485))
,___DEF_CNS(___REF_SYM(347,___S_fxzero_3f_),___REF_CNS(486))
,___DEF_CNS(___REF_SYM(348,___S_gc_2d_report_2d_set_21_),___REF_CNS(487))
,___DEF_CNS(___REF_SYM(350,___S_generate_2d_proper_2d_tail_2d_calls),___REF_CNS(488))
,___DEF_CNS(___REF_SYM(351,___S_gensym),___REF_CNS(489))
,___DEF_CNS(___REF_SYM(352,___S_get_2d_output_2d_string),___REF_CNS(490))
,___DEF_CNS(___REF_SYM(353,___S_get_2d_output_2d_u8vector),___REF_CNS(491))
,___DEF_CNS(___REF_SYM(354,___S_get_2d_output_2d_vector),___REF_CNS(492))
,___DEF_CNS(___REF_SYM(355,___S_getenv),___REF_CNS(493))
,___DEF_CNS(___REF_SYM(356,___S_group_2d_info),___REF_CNS(494))
,___DEF_CNS(___REF_SYM(357,___S_group_2d_info_2d_gid),___REF_CNS(495))
,___DEF_CNS(___REF_SYM(358,___S_group_2d_info_2d_members),___REF_CNS(496))
,___DEF_CNS(___REF_SYM(359,___S_group_2d_info_2d_name),___REF_CNS(497))
,___DEF_CNS(___REF_SYM(360,___S_group_2d_info_3f_),___REF_CNS(498))
,___DEF_CNS(___REF_SYM(361,___S_heap_2d_overflow_2d_exception_3f_),___REF_CNS(499))
,___DEF_CNS(___REF_SYM(362,___S_help),___REF_CNS(500))
,___DEF_CNS(___REF_SYM(363,___S_help_2d_browser),___REF_CNS(501))
,___DEF_CNS(___REF_SYM(364,___S_host_2d_info),___REF_CNS(502))
,___DEF_CNS(___REF_SYM(365,___S_host_2d_info_2d_addresses),___REF_CNS(503))
,___DEF_CNS(___REF_SYM(366,___S_host_2d_info_2d_aliases),___REF_CNS(504))
,___DEF_CNS(___REF_SYM(367,___S_host_2d_info_2d_name),___REF_CNS(505))
,___DEF_CNS(___REF_SYM(368,___S_host_2d_info_3f_),___REF_CNS(506))
,___DEF_CNS(___REF_SYM(369,___S_host_2d_name),___REF_CNS(507))
,___DEF_CNS(___REF_SYM(372,___S_improper_2d_length_2d_list_2d_exception_2d_arg_2d_num),___REF_CNS(508))
,___DEF_CNS(___REF_SYM(373,___S_improper_2d_length_2d_list_2d_exception_2d_arguments),___REF_CNS(509))
,___DEF_CNS(___REF_SYM(374,___S_improper_2d_length_2d_list_2d_exception_2d_procedure),___REF_CNS(510))
,___DEF_CNS(___REF_SYM(375,___S_improper_2d_length_2d_list_2d_exception_3f_),___REF_CNS(511))
,___DEF_CNS(___REF_SYM(376,___S_inactive_2d_thread_2d_exception_2d_arguments),___REF_CNS(512))
,___DEF_CNS(___REF_SYM(377,___S_inactive_2d_thread_2d_exception_2d_procedure),___REF_CNS(513))
,___DEF_CNS(___REF_SYM(378,___S_inactive_2d_thread_2d_exception_3f_),___REF_CNS(514))
,___DEF_CNS(___REF_SYM(379,___S_include),___REF_CNS(515))
,___DEF_CNS(___REF_SYM(382,___S_infinite_3f_),___REF_CNS(516))
,___DEF_CNS(___REF_SYM(383,___S_initialized_2d_thread_2d_exception_2d_arguments),___REF_CNS(517))
,___DEF_CNS(___REF_SYM(384,___S_initialized_2d_thread_2d_exception_2d_procedure),___REF_CNS(518))
,___DEF_CNS(___REF_SYM(385,___S_initialized_2d_thread_2d_exception_3f_),___REF_CNS(519))
,___DEF_CNS(___REF_SYM(386,___S_input_2d_port_2d_byte_2d_position),___REF_CNS(520))
,___DEF_CNS(___REF_SYM(387,___S_input_2d_port_2d_bytes_2d_buffered),___REF_CNS(521))
,___DEF_CNS(___REF_SYM(388,___S_input_2d_port_2d_char_2d_position),___REF_CNS(522))
,___DEF_CNS(___REF_SYM(389,___S_input_2d_port_2d_characters_2d_buffered),___REF_CNS(523))
,___DEF_CNS(___REF_SYM(390,___S_input_2d_port_2d_column),___REF_CNS(524))
,___DEF_CNS(___REF_SYM(391,___S_input_2d_port_2d_line),___REF_CNS(525))
,___DEF_CNS(___REF_SYM(392,___S_input_2d_port_2d_readtable),___REF_CNS(526))
,___DEF_CNS(___REF_SYM(393,___S_input_2d_port_2d_readtable_2d_set_21_),___REF_CNS(527))
,___DEF_CNS(___REF_SYM(394,___S_input_2d_port_2d_timeout_2d_set_21_),___REF_CNS(528))
,___DEF_CNS(___REF_SYM(395,___S_input_2d_port_3f_),___REF_CNS(529))
,___DEF_CNS(___REF_SYM(396,___S_integer_2d__3e_char),___REF_CNS(530))
,___DEF_CNS(___REF_SYM(397,___S_integer_2d_length),___REF_CNS(531))
,___DEF_CNS(___REF_SYM(398,___S_integer_2d_nth_2d_root),___REF_CNS(532))
,___DEF_CNS(___REF_SYM(399,___S_integer_2d_sqrt),___REF_CNS(533))
,___DEF_CNS(___REF_SYM(402,___S_invalid_2d_hash_2d_number_2d_exception_2d_arguments),___REF_CNS(534))
,___DEF_CNS(___REF_SYM(403,___S_invalid_2d_hash_2d_number_2d_exception_2d_procedure),___REF_CNS(535))
,___DEF_CNS(___REF_SYM(404,___S_invalid_2d_hash_2d_number_2d_exception_3f_),___REF_CNS(536))
,___DEF_CNS(___REF_SYM(405,___S_join_2d_timeout_2d_exception_2d_arguments),___REF_CNS(537))
,___DEF_CNS(___REF_SYM(406,___S_join_2d_timeout_2d_exception_2d_procedure),___REF_CNS(538))
,___DEF_CNS(___REF_SYM(407,___S_join_2d_timeout_2d_exception_3f_),___REF_CNS(539))
,___DEF_CNS(___REF_SYM(408,___S_keyword_2d__3e_string),___REF_CNS(540))
,___DEF_CNS(___REF_SYM(409,___S_keyword_2d_expected_2d_exception_2d_arguments),___REF_CNS(541))
,___DEF_CNS(___REF_SYM(410,___S_keyword_2d_expected_2d_exception_2d_procedure),___REF_CNS(542))
,___DEF_CNS(___REF_SYM(411,___S_keyword_2d_expected_2d_exception_3f_),___REF_CNS(543))
,___DEF_CNS(___REF_SYM(412,___S_keyword_2d_hash),___REF_CNS(544))
,___DEF_CNS(___REF_SYM(413,___S_keyword_3f_),___REF_CNS(545))
,___DEF_CNS(___REF_SYM(414,___S_lambda),___REF_CNS(546))
,___DEF_CNS(___REF_SYM(422,___S_link_2d_flat),___REF_CNS(547))
,___DEF_CNS(___REF_SYM(423,___S_link_2d_incremental),___REF_CNS(548))
,___DEF_CNS(___REF_SYM(425,___S_list_2d__3e_f32vector),___REF_CNS(549))
,___DEF_CNS(___REF_SYM(426,___S_list_2d__3e_f64vector),___REF_CNS(550))
,___DEF_CNS(___REF_SYM(427,___S_list_2d__3e_s16vector),___REF_CNS(551))
,___DEF_CNS(___REF_SYM(428,___S_list_2d__3e_s32vector),___REF_CNS(552))
,___DEF_CNS(___REF_SYM(429,___S_list_2d__3e_s64vector),___REF_CNS(553))
,___DEF_CNS(___REF_SYM(430,___S_list_2d__3e_s8vector),___REF_CNS(554))
,___DEF_CNS(___REF_SYM(432,___S_list_2d__3e_table),___REF_CNS(555))
,___DEF_CNS(___REF_SYM(433,___S_list_2d__3e_u16vector),___REF_CNS(556))
,___DEF_CNS(___REF_SYM(434,___S_list_2d__3e_u32vector),___REF_CNS(557))
,___DEF_CNS(___REF_SYM(435,___S_list_2d__3e_u64vector),___REF_CNS(558))
,___DEF_CNS(___REF_SYM(436,___S_list_2d__3e_u8vector),___REF_CNS(559))
,___DEF_CNS(___REF_SYM(444,___S_mailbox_2d_receive_2d_timeout_2d_exception_2d_arguments),___REF_CNS(560))
,___DEF_CNS(___REF_SYM(445,___S_mailbox_2d_receive_2d_timeout_2d_exception_2d_procedure),___REF_CNS(561))
,___DEF_CNS(___REF_SYM(446,___S_mailbox_2d_receive_2d_timeout_2d_exception_3f_),___REF_CNS(562))
,___DEF_CNS(___REF_SYM(447,___S_main),___REF_CNS(563))
,___DEF_CNS(___REF_SYM(448,___S_make_2d_condition_2d_variable),___REF_CNS(564))
,___DEF_CNS(___REF_SYM(449,___S_make_2d_f32vector),___REF_CNS(565))
,___DEF_CNS(___REF_SYM(450,___S_make_2d_f64vector),___REF_CNS(566))
,___DEF_CNS(___REF_SYM(451,___S_make_2d_mutex),___REF_CNS(567))
,___DEF_CNS(___REF_SYM(452,___S_make_2d_parameter),___REF_CNS(568))
,___DEF_CNS(___REF_SYM(454,___S_make_2d_random_2d_source),___REF_CNS(569))
,___DEF_CNS(___REF_SYM(456,___S_make_2d_root_2d_thread),___REF_CNS(570))
,___DEF_CNS(___REF_SYM(457,___S_make_2d_s16vector),___REF_CNS(571))
,___DEF_CNS(___REF_SYM(458,___S_make_2d_s32vector),___REF_CNS(572))
,___DEF_CNS(___REF_SYM(459,___S_make_2d_s64vector),___REF_CNS(573))
,___DEF_CNS(___REF_SYM(460,___S_make_2d_s8vector),___REF_CNS(574))
,___DEF_CNS(___REF_SYM(462,___S_make_2d_table),___REF_CNS(575))
,___DEF_CNS(___REF_SYM(463,___S_make_2d_thread),___REF_CNS(576))
,___DEF_CNS(___REF_SYM(464,___S_make_2d_thread_2d_group),___REF_CNS(577))
,___DEF_CNS(___REF_SYM(465,___S_make_2d_u16vector),___REF_CNS(578))
,___DEF_CNS(___REF_SYM(466,___S_make_2d_u32vector),___REF_CNS(579))
,___DEF_CNS(___REF_SYM(467,___S_make_2d_u64vector),___REF_CNS(580))
,___DEF_CNS(___REF_SYM(468,___S_make_2d_u8vector),___REF_CNS(581))
,___DEF_CNS(___REF_SYM(469,___S_make_2d_uninterned_2d_keyword),___REF_CNS(582))
,___DEF_CNS(___REF_SYM(470,___S_make_2d_uninterned_2d_symbol),___REF_CNS(583))
,___DEF_CNS(___REF_SYM(472,___S_make_2d_will),___REF_CNS(584))
,___DEF_CNS(___REF_SYM(480,___S_multiple_2d_c_2d_return_2d_exception_3f_),___REF_CNS(585))
,___DEF_CNS(___REF_SYM(481,___S_mutex_2d_lock_21_),___REF_CNS(586))
,___DEF_CNS(___REF_SYM(482,___S_mutex_2d_name),___REF_CNS(587))
,___DEF_CNS(___REF_SYM(483,___S_mutex_2d_specific),___REF_CNS(588))
,___DEF_CNS(___REF_SYM(484,___S_mutex_2d_specific_2d_set_21_),___REF_CNS(589))
,___DEF_CNS(___REF_SYM(485,___S_mutex_2d_state),___REF_CNS(590))
,___DEF_CNS(___REF_SYM(486,___S_mutex_2d_unlock_21_),___REF_CNS(591))
,___DEF_CNS(___REF_SYM(487,___S_mutex_3f_),___REF_CNS(592))
,___DEF_CNS(___REF_SYM(488,___S_namespace),___REF_CNS(593))
,___DEF_CNS(___REF_SYM(489,___S_nan_3f_),___REF_CNS(594))
,___DEF_CNS(___REF_SYM(491,___S_network_2d_info),___REF_CNS(595))
,___DEF_CNS(___REF_SYM(492,___S_network_2d_info_2d_aliases),___REF_CNS(596))
,___DEF_CNS(___REF_SYM(493,___S_network_2d_info_2d_name),___REF_CNS(597))
,___DEF_CNS(___REF_SYM(494,___S_network_2d_info_2d_number),___REF_CNS(598))
,___DEF_CNS(___REF_SYM(495,___S_network_2d_info_3f_),___REF_CNS(599))
,___DEF_CNS(___REF_SYM(496,___S_newline),___REF_CNS(600))
,___DEF_CNS(___REF_SYM(497,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments),___REF_CNS(601))
,___DEF_CNS(___REF_SYM(498,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure),___REF_CNS(602))
,___DEF_CNS(___REF_SYM(499,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_),___REF_CNS(603))
,___DEF_CNS(___REF_SYM(500,___S_noncontinuable_2d_exception_2d_reason),___REF_CNS(604))
,___DEF_CNS(___REF_SYM(501,___S_noncontinuable_2d_exception_3f_),___REF_CNS(605))
,___DEF_CNS(___REF_SYM(502,___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_2d_arguments),___REF_CNS(606))
,___DEF_CNS(___REF_SYM(503,___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_2d_procedure),___REF_CNS(607))
,___DEF_CNS(___REF_SYM(504,___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_3f_),___REF_CNS(608))
,___DEF_CNS(___REF_SYM(505,___S_nonprocedure_2d_operator_2d_exception_2d_arguments),___REF_CNS(609))
,___DEF_CNS(___REF_SYM(506,___S_nonprocedure_2d_operator_2d_exception_2d_code),___REF_CNS(610))
,___DEF_CNS(___REF_SYM(507,___S_nonprocedure_2d_operator_2d_exception_2d_operator),___REF_CNS(611))
,___DEF_CNS(___REF_SYM(508,___S_nonprocedure_2d_operator_2d_exception_2d_rte),___REF_CNS(612))
,___DEF_CNS(___REF_SYM(509,___S_nonprocedure_2d_operator_2d_exception_3f_),___REF_CNS(613))
,___DEF_CNS(___REF_SYM(514,___S_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments),___REF_CNS(614))
,___DEF_CNS(___REF_SYM(515,___S_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure),___REF_CNS(615))
,___DEF_CNS(___REF_SYM(516,___S_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_),___REF_CNS(616))
,___DEF_CNS(___REF_SYM(519,___S_object_2d__3e_serial_2d_number),___REF_CNS(617))
,___DEF_CNS(___REF_SYM(520,___S_object_2d__3e_string),___REF_CNS(618))
,___DEF_CNS(___REF_SYM(521,___S_object_2d__3e_u8vector),___REF_CNS(619))
,___DEF_CNS(___REF_SYM(523,___S_open_2d_directory),___REF_CNS(620))
,___DEF_CNS(___REF_SYM(524,___S_open_2d_dummy),___REF_CNS(621))
,___DEF_CNS(___REF_SYM(525,___S_open_2d_event_2d_queue),___REF_CNS(622))
,___DEF_CNS(___REF_SYM(526,___S_open_2d_file),___REF_CNS(623))
,___DEF_CNS(___REF_SYM(527,___S_open_2d_input_2d_file),___REF_CNS(624))
,___DEF_CNS(___REF_SYM(528,___S_open_2d_input_2d_process),___REF_CNS(625))
,___DEF_CNS(___REF_SYM(529,___S_open_2d_input_2d_string),___REF_CNS(626))
,___DEF_CNS(___REF_SYM(530,___S_open_2d_input_2d_u8vector),___REF_CNS(627))
,___DEF_CNS(___REF_SYM(531,___S_open_2d_input_2d_vector),___REF_CNS(628))
,___DEF_CNS(___REF_SYM(532,___S_open_2d_output_2d_file),___REF_CNS(629))
,___DEF_CNS(___REF_SYM(533,___S_open_2d_output_2d_process),___REF_CNS(630))
,___DEF_CNS(___REF_SYM(534,___S_open_2d_output_2d_string),___REF_CNS(631))
,___DEF_CNS(___REF_SYM(535,___S_open_2d_output_2d_u8vector),___REF_CNS(632))
,___DEF_CNS(___REF_SYM(536,___S_open_2d_output_2d_vector),___REF_CNS(633))
,___DEF_CNS(___REF_SYM(537,___S_open_2d_process),___REF_CNS(634))
,___DEF_CNS(___REF_SYM(538,___S_open_2d_string),___REF_CNS(635))
,___DEF_CNS(___REF_SYM(539,___S_open_2d_string_2d_pipe),___REF_CNS(636))
,___DEF_CNS(___REF_SYM(540,___S_open_2d_tcp_2d_client),___REF_CNS(637))
,___DEF_CNS(___REF_SYM(541,___S_open_2d_tcp_2d_server),___REF_CNS(638))
,___DEF_CNS(___REF_SYM(542,___S_open_2d_u8vector),___REF_CNS(639))
,___DEF_CNS(___REF_SYM(543,___S_open_2d_u8vector_2d_pipe),___REF_CNS(640))
,___DEF_CNS(___REF_SYM(544,___S_open_2d_vector),___REF_CNS(641))
,___DEF_CNS(___REF_SYM(545,___S_open_2d_vector_2d_pipe),___REF_CNS(642))
,___DEF_CNS(___REF_SYM(547,___S_os_2d_exception_2d_arguments),___REF_CNS(643))
,___DEF_CNS(___REF_SYM(548,___S_os_2d_exception_2d_code),___REF_CNS(644))
,___DEF_CNS(___REF_SYM(549,___S_os_2d_exception_2d_message),___REF_CNS(645))
,___DEF_CNS(___REF_SYM(550,___S_os_2d_exception_2d_procedure),___REF_CNS(646))
,___DEF_CNS(___REF_SYM(551,___S_os_2d_exception_3f_),___REF_CNS(647))
,___DEF_CNS(___REF_SYM(552,___S_output_2d_port_2d_byte_2d_position),___REF_CNS(648))
,___DEF_CNS(___REF_SYM(553,___S_output_2d_port_2d_char_2d_position),___REF_CNS(649))
,___DEF_CNS(___REF_SYM(554,___S_output_2d_port_2d_column),___REF_CNS(650))
,___DEF_CNS(___REF_SYM(555,___S_output_2d_port_2d_line),___REF_CNS(651))
,___DEF_CNS(___REF_SYM(556,___S_output_2d_port_2d_readtable),___REF_CNS(652))
,___DEF_CNS(___REF_SYM(557,___S_output_2d_port_2d_readtable_2d_set_21_),___REF_CNS(653))
,___DEF_CNS(___REF_SYM(558,___S_output_2d_port_2d_timeout_2d_set_21_),___REF_CNS(654))
,___DEF_CNS(___REF_SYM(559,___S_output_2d_port_2d_width),___REF_CNS(655))
,___DEF_CNS(___REF_SYM(560,___S_output_2d_port_3f_),___REF_CNS(656))
,___DEF_CNS(___REF_SYM(562,___S_parameterize),___REF_CNS(657))
,___DEF_CNS(___REF_SYM(563,___S_path_2d_directory),___REF_CNS(658))
,___DEF_CNS(___REF_SYM(564,___S_path_2d_expand),___REF_CNS(659))
,___DEF_CNS(___REF_SYM(565,___S_path_2d_extension),___REF_CNS(660))
,___DEF_CNS(___REF_SYM(566,___S_path_2d_normalize),___REF_CNS(661))
,___DEF_CNS(___REF_SYM(567,___S_path_2d_strip_2d_directory),___REF_CNS(662))
,___DEF_CNS(___REF_SYM(568,___S_path_2d_strip_2d_extension),___REF_CNS(663))
,___DEF_CNS(___REF_SYM(569,___S_path_2d_strip_2d_trailing_2d_directory_2d_separator),___REF_CNS(664))
,___DEF_CNS(___REF_SYM(570,___S_path_2d_strip_2d_volume),___REF_CNS(665))
,___DEF_CNS(___REF_SYM(571,___S_path_2d_volume),___REF_CNS(666))
,___DEF_CNS(___REF_SYM(572,___S_peek_2d_char),___REF_CNS(667))
,___DEF_CNS(___REF_SYM(573,___S_port_2d_settings_2d_set_21_),___REF_CNS(668))
,___DEF_CNS(___REF_SYM(574,___S_port_3f_),___REF_CNS(669))
,___DEF_CNS(___REF_SYM(576,___S_pp),___REF_CNS(670))
,___DEF_CNS(___REF_SYM(577,___S_pretty_2d_print),___REF_CNS(671))
,___DEF_CNS(___REF_SYM(578,___S_primordial_2d_exception_2d_handler),___REF_CNS(672))
,___DEF_CNS(___REF_SYM(579,___S_print),___REF_CNS(673))
,___DEF_CNS(___REF_SYM(580,___S_println),___REF_CNS(674))
,___DEF_CNS(___REF_SYM(582,___S_process_2d_pid),___REF_CNS(675))
,___DEF_CNS(___REF_SYM(583,___S_process_2d_status),___REF_CNS(676))
,___DEF_CNS(___REF_SYM(584,___S_process_2d_times),___REF_CNS(677))
,___DEF_CNS(___REF_SYM(585,___S_protocol_2d_info),___REF_CNS(678))
,___DEF_CNS(___REF_SYM(586,___S_protocol_2d_info_2d_aliases),___REF_CNS(679))
,___DEF_CNS(___REF_SYM(587,___S_protocol_2d_info_2d_name),___REF_CNS(680))
,___DEF_CNS(___REF_SYM(588,___S_protocol_2d_info_2d_number),___REF_CNS(681))
,___DEF_CNS(___REF_SYM(589,___S_protocol_2d_info_3f_),___REF_CNS(682))
,___DEF_CNS(___REF_SYM(593,___S_raise),___REF_CNS(683))
,___DEF_CNS(___REF_SYM(594,___S_random_2d_f64vector),___REF_CNS(684))
,___DEF_CNS(___REF_SYM(595,___S_random_2d_integer),___REF_CNS(685))
,___DEF_CNS(___REF_SYM(596,___S_random_2d_real),___REF_CNS(686))
,___DEF_CNS(___REF_SYM(597,___S_random_2d_source_2d_make_2d_f64vectors),___REF_CNS(687))
,___DEF_CNS(___REF_SYM(598,___S_random_2d_source_2d_make_2d_integers),___REF_CNS(688))
,___DEF_CNS(___REF_SYM(599,___S_random_2d_source_2d_make_2d_reals),___REF_CNS(689))
,___DEF_CNS(___REF_SYM(600,___S_random_2d_source_2d_make_2d_u8vectors),___REF_CNS(690))
,___DEF_CNS(___REF_SYM(601,___S_random_2d_source_2d_pseudo_2d_randomize_21_),___REF_CNS(691))
,___DEF_CNS(___REF_SYM(602,___S_random_2d_source_2d_randomize_21_),___REF_CNS(692))
,___DEF_CNS(___REF_SYM(603,___S_random_2d_source_2d_state_2d_ref),___REF_CNS(693))
,___DEF_CNS(___REF_SYM(604,___S_random_2d_source_2d_state_2d_set_21_),___REF_CNS(694))
,___DEF_CNS(___REF_SYM(605,___S_random_2d_source_3f_),___REF_CNS(695))
,___DEF_CNS(___REF_SYM(606,___S_random_2d_u8vector),___REF_CNS(696))
,___DEF_CNS(___REF_SYM(607,___S_range_2d_exception_2d_arg_2d_num),___REF_CNS(697))
,___DEF_CNS(___REF_SYM(608,___S_range_2d_exception_2d_arguments),___REF_CNS(698))
,___DEF_CNS(___REF_SYM(609,___S_range_2d_exception_2d_procedure),___REF_CNS(699))
,___DEF_CNS(___REF_SYM(610,___S_range_2d_exception_3f_),___REF_CNS(700))
,___DEF_CNS(___REF_SYM(613,___S_read),___REF_CNS(701))
,___DEF_CNS(___REF_SYM(614,___S_read_2d_all),___REF_CNS(702))
,___DEF_CNS(___REF_SYM(615,___S_read_2d_char),___REF_CNS(703))
,___DEF_CNS(___REF_SYM(616,___S_read_2d_line),___REF_CNS(704))
,___DEF_CNS(___REF_SYM(617,___S_read_2d_substring),___REF_CNS(705))
,___DEF_CNS(___REF_SYM(618,___S_read_2d_subu8vector),___REF_CNS(706))
,___DEF_CNS(___REF_SYM(619,___S_read_2d_u8),___REF_CNS(707))
,___DEF_CNS(___REF_SYM(620,___S_readtable_2d_case_2d_conversion_3f_),___REF_CNS(708))
,___DEF_CNS(___REF_SYM(621,___S_readtable_2d_case_2d_conversion_3f__2d_set),___REF_CNS(709))
,___DEF_CNS(___REF_SYM(622,___S_readtable_2d_eval_2d_allowed_3f_),___REF_CNS(710))
,___DEF_CNS(___REF_SYM(623,___S_readtable_2d_eval_2d_allowed_3f__2d_set),___REF_CNS(711))
,___DEF_CNS(___REF_SYM(624,___S_readtable_2d_keywords_2d_allowed_3f_),___REF_CNS(712))
,___DEF_CNS(___REF_SYM(625,___S_readtable_2d_keywords_2d_allowed_3f__2d_set),___REF_CNS(713))
,___DEF_CNS(___REF_SYM(626,___S_readtable_2d_max_2d_unescaped_2d_char),___REF_CNS(714))
,___DEF_CNS(___REF_SYM(627,___S_readtable_2d_max_2d_unescaped_2d_char_2d_set),___REF_CNS(715))
,___DEF_CNS(___REF_SYM(628,___S_readtable_2d_max_2d_write_2d_length),___REF_CNS(716))
,___DEF_CNS(___REF_SYM(629,___S_readtable_2d_max_2d_write_2d_length_2d_set),___REF_CNS(717))
,___DEF_CNS(___REF_SYM(630,___S_readtable_2d_max_2d_write_2d_level),___REF_CNS(718))
,___DEF_CNS(___REF_SYM(631,___S_readtable_2d_max_2d_write_2d_level_2d_set),___REF_CNS(719))
,___DEF_CNS(___REF_SYM(632,___S_readtable_2d_sharing_2d_allowed_3f_),___REF_CNS(720))
,___DEF_CNS(___REF_SYM(633,___S_readtable_2d_sharing_2d_allowed_3f__2d_set),___REF_CNS(721))
,___DEF_CNS(___REF_SYM(634,___S_readtable_2d_start_2d_syntax),___REF_CNS(722))
,___DEF_CNS(___REF_SYM(635,___S_readtable_2d_start_2d_syntax_2d_set),___REF_CNS(723))
,___DEF_CNS(___REF_SYM(636,___S_readtable_2d_write_2d_cdr_2d_read_2d_macros_3f_),___REF_CNS(724))
,___DEF_CNS(___REF_SYM(637,___S_readtable_2d_write_2d_cdr_2d_read_2d_macros_3f__2d_set),___REF_CNS(725))
,___DEF_CNS(___REF_SYM(638,___S_readtable_2d_write_2d_extended_2d_read_2d_macros_3f_),___REF_CNS(726))
,___DEF_CNS(___REF_SYM(639,___S_readtable_2d_write_2d_extended_2d_read_2d_macros_3f__2d_set),___REF_CNS(727))
,___DEF_CNS(___REF_SYM(640,___S_readtable_3f_),___REF_CNS(728))
,___DEF_CNS(___REF_SYM(642,___S_real_2d_time),___REF_CNS(729))
,___DEF_CNS(___REF_SYM(644,___S_receive),___REF_CNS(730))
,___DEF_CNS(___REF_SYM(646,___S_rename_2d_file),___REF_CNS(731))
,___DEF_CNS(___REF_SYM(647,___S_repl_2d_display_2d_environment_3f_),___REF_CNS(732))
,___DEF_CNS(___REF_SYM(648,___S_repl_2d_input_2d_port),___REF_CNS(733))
,___DEF_CNS(___REF_SYM(649,___S_repl_2d_output_2d_port),___REF_CNS(734))
,___DEF_CNS(___REF_SYM(650,___S_repl_2d_result_2d_history_2d_max_2d_length_2d_set_21_),___REF_CNS(735))
,___DEF_CNS(___REF_SYM(651,___S_repl_2d_result_2d_history_2d_ref),___REF_CNS(736))
,___DEF_CNS(___REF_SYM(652,___S_replace_2d_bit_2d_field),___REF_CNS(737))
,___DEF_CNS(___REF_SYM(655,___S_rpc_2d_remote_2d_error_2d_exception_2d_arguments),___REF_CNS(738))
,___DEF_CNS(___REF_SYM(656,___S_rpc_2d_remote_2d_error_2d_exception_2d_message),___REF_CNS(739))
,___DEF_CNS(___REF_SYM(657,___S_rpc_2d_remote_2d_error_2d_exception_2d_procedure),___REF_CNS(740))
,___DEF_CNS(___REF_SYM(658,___S_rpc_2d_remote_2d_error_2d_exception_3f_),___REF_CNS(741))
,___DEF_CNS(___REF_SYM(659,___S_s16vector),___REF_CNS(742))
,___DEF_CNS(___REF_SYM(660,___S_s16vector_2d__3e_list),___REF_CNS(743))
,___DEF_CNS(___REF_SYM(661,___S_s16vector_2d_append),___REF_CNS(744))
,___DEF_CNS(___REF_SYM(662,___S_s16vector_2d_copy),___REF_CNS(745))
,___DEF_CNS(___REF_SYM(663,___S_s16vector_2d_fill_21_),___REF_CNS(746))
,___DEF_CNS(___REF_SYM(664,___S_s16vector_2d_length),___REF_CNS(747))
,___DEF_CNS(___REF_SYM(665,___S_s16vector_2d_ref),___REF_CNS(748))
,___DEF_CNS(___REF_SYM(666,___S_s16vector_2d_set_21_),___REF_CNS(749))
,___DEF_CNS(___REF_SYM(667,___S_s16vector_2d_shrink_21_),___REF_CNS(750))
,___DEF_CNS(___REF_SYM(668,___S_s16vector_3f_),___REF_CNS(751))
,___DEF_CNS(___REF_SYM(669,___S_s32vector),___REF_CNS(752))
,___DEF_CNS(___REF_SYM(670,___S_s32vector_2d__3e_list),___REF_CNS(753))
,___DEF_CNS(___REF_SYM(671,___S_s32vector_2d_append),___REF_CNS(754))
,___DEF_CNS(___REF_SYM(672,___S_s32vector_2d_copy),___REF_CNS(755))
,___DEF_CNS(___REF_SYM(673,___S_s32vector_2d_fill_21_),___REF_CNS(756))
,___DEF_CNS(___REF_SYM(674,___S_s32vector_2d_length),___REF_CNS(757))
,___DEF_CNS(___REF_SYM(675,___S_s32vector_2d_ref),___REF_CNS(758))
,___DEF_CNS(___REF_SYM(676,___S_s32vector_2d_set_21_),___REF_CNS(759))
,___DEF_CNS(___REF_SYM(677,___S_s32vector_2d_shrink_21_),___REF_CNS(760))
,___DEF_CNS(___REF_SYM(678,___S_s32vector_3f_),___REF_CNS(761))
,___DEF_CNS(___REF_SYM(679,___S_s64vector),___REF_CNS(762))
,___DEF_CNS(___REF_SYM(680,___S_s64vector_2d__3e_list),___REF_CNS(763))
,___DEF_CNS(___REF_SYM(681,___S_s64vector_2d_append),___REF_CNS(764))
,___DEF_CNS(___REF_SYM(682,___S_s64vector_2d_copy),___REF_CNS(765))
,___DEF_CNS(___REF_SYM(683,___S_s64vector_2d_fill_21_),___REF_CNS(766))
,___DEF_CNS(___REF_SYM(684,___S_s64vector_2d_length),___REF_CNS(767))
,___DEF_CNS(___REF_SYM(685,___S_s64vector_2d_ref),___REF_CNS(768))
,___DEF_CNS(___REF_SYM(686,___S_s64vector_2d_set_21_),___REF_CNS(769))
,___DEF_CNS(___REF_SYM(687,___S_s64vector_2d_shrink_21_),___REF_CNS(770))
,___DEF_CNS(___REF_SYM(688,___S_s64vector_3f_),___REF_CNS(771))
,___DEF_CNS(___REF_SYM(689,___S_s8vector),___REF_CNS(772))
,___DEF_CNS(___REF_SYM(690,___S_s8vector_2d__3e_list),___REF_CNS(773))
,___DEF_CNS(___REF_SYM(691,___S_s8vector_2d_append),___REF_CNS(774))
,___DEF_CNS(___REF_SYM(692,___S_s8vector_2d_copy),___REF_CNS(775))
,___DEF_CNS(___REF_SYM(693,___S_s8vector_2d_fill_21_),___REF_CNS(776))
,___DEF_CNS(___REF_SYM(694,___S_s8vector_2d_length),___REF_CNS(777))
,___DEF_CNS(___REF_SYM(695,___S_s8vector_2d_ref),___REF_CNS(778))
,___DEF_CNS(___REF_SYM(696,___S_s8vector_2d_set_21_),___REF_CNS(779))
,___DEF_CNS(___REF_SYM(697,___S_s8vector_2d_shrink_21_),___REF_CNS(780))
,___DEF_CNS(___REF_SYM(698,___S_s8vector_3f_),___REF_CNS(781))
,___DEF_CNS(___REF_SYM(699,___S_scheduler_2d_exception_2d_reason),___REF_CNS(782))
,___DEF_CNS(___REF_SYM(700,___S_scheduler_2d_exception_3f_),___REF_CNS(783))
,___DEF_CNS(___REF_SYM(702,___S_seconds_2d__3e_time),___REF_CNS(784))
,___DEF_CNS(___REF_SYM(703,___S_serial_2d_number_2d__3e_object),___REF_CNS(785))
,___DEF_CNS(___REF_SYM(704,___S_service_2d_info),___REF_CNS(786))
,___DEF_CNS(___REF_SYM(705,___S_service_2d_info_2d_aliases),___REF_CNS(787))
,___DEF_CNS(___REF_SYM(706,___S_service_2d_info_2d_name),___REF_CNS(788))
,___DEF_CNS(___REF_SYM(707,___S_service_2d_info_2d_port_2d_number),___REF_CNS(789))
,___DEF_CNS(___REF_SYM(708,___S_service_2d_info_2d_protocol),___REF_CNS(790))
,___DEF_CNS(___REF_SYM(709,___S_service_2d_info_3f_),___REF_CNS(791))
,___DEF_CNS(___REF_SYM(711,___S_set_2d_box_21_),___REF_CNS(792))
,___DEF_CNS(___REF_SYM(714,___S_setenv),___REF_CNS(793))
,___DEF_CNS(___REF_SYM(715,___S_sfun_2d_conversion_2d_exception_2d_arguments),___REF_CNS(794))
,___DEF_CNS(___REF_SYM(716,___S_sfun_2d_conversion_2d_exception_2d_code),___REF_CNS(795))
,___DEF_CNS(___REF_SYM(717,___S_sfun_2d_conversion_2d_exception_2d_message),___REF_CNS(796))
,___DEF_CNS(___REF_SYM(718,___S_sfun_2d_conversion_2d_exception_2d_procedure),___REF_CNS(797))
,___DEF_CNS(___REF_SYM(719,___S_sfun_2d_conversion_2d_exception_3f_),___REF_CNS(798))
,___DEF_CNS(___REF_SYM(720,___S_shell_2d_command),___REF_CNS(799))
,___DEF_CNS(___REF_SYM(722,___S_six_2e__21_),___REF_CNS(800))
,___DEF_CNS(___REF_SYM(723,___S_six_2e__21_x),___REF_CNS(801))
,___DEF_CNS(___REF_SYM(724,___S_six_2e__26_x),___REF_CNS(802))
,___DEF_CNS(___REF_SYM(725,___S_six_2e__2a_x),___REF_CNS(803))
,___DEF_CNS(___REF_SYM(726,___S_six_2e__2b__2b_x),___REF_CNS(804))
,___DEF_CNS(___REF_SYM(727,___S_six_2e__2b_x),___REF_CNS(805))
,___DEF_CNS(___REF_SYM(728,___S_six_2e__2d__2d_x),___REF_CNS(806))
,___DEF_CNS(___REF_SYM(729,___S_six_2e__2d_x),___REF_CNS(807))
,___DEF_CNS(___REF_SYM(730,___S_six_2e_arrow),___REF_CNS(808))
,___DEF_CNS(___REF_SYM(731,___S_six_2e_break),___REF_CNS(809))
,___DEF_CNS(___REF_SYM(732,___S_six_2e_call),___REF_CNS(810))
,___DEF_CNS(___REF_SYM(733,___S_six_2e_case),___REF_CNS(811))
,___DEF_CNS(___REF_SYM(734,___S_six_2e_clause),___REF_CNS(812))
,___DEF_CNS(___REF_SYM(735,___S_six_2e_compound),___REF_CNS(813))
,___DEF_CNS(___REF_SYM(736,___S_six_2e_cons),___REF_CNS(814))
,___DEF_CNS(___REF_SYM(737,___S_six_2e_continue),___REF_CNS(815))
,___DEF_CNS(___REF_SYM(738,___S_six_2e_define_2d_procedure),___REF_CNS(816))
,___DEF_CNS(___REF_SYM(739,___S_six_2e_define_2d_variable),___REF_CNS(817))
,___DEF_CNS(___REF_SYM(740,___S_six_2e_do_2d_while),___REF_CNS(818))
,___DEF_CNS(___REF_SYM(741,___S_six_2e_dot),___REF_CNS(819))
,___DEF_CNS(___REF_SYM(742,___S_six_2e_for),___REF_CNS(820))
,___DEF_CNS(___REF_SYM(743,___S_six_2e_goto),___REF_CNS(821))
,___DEF_CNS(___REF_SYM(744,___S_six_2e_identifier),___REF_CNS(822))
,___DEF_CNS(___REF_SYM(745,___S_six_2e_if),___REF_CNS(823))
,___DEF_CNS(___REF_SYM(746,___S_six_2e_index),___REF_CNS(824))
,___DEF_CNS(___REF_SYM(747,___S_six_2e_label),___REF_CNS(825))
,___DEF_CNS(___REF_SYM(748,___S_six_2e_list),___REF_CNS(826))
,___DEF_CNS(___REF_SYM(749,___S_six_2e_literal),___REF_CNS(827))
,___DEF_CNS(___REF_SYM(750,___S_six_2e_make_2d_array),___REF_CNS(828))
,___DEF_CNS(___REF_SYM(751,___S_six_2e_new),___REF_CNS(829))
,___DEF_CNS(___REF_SYM(752,___S_six_2e_null),___REF_CNS(830))
,___DEF_CNS(___REF_SYM(753,___S_six_2e_prefix),___REF_CNS(831))
,___DEF_CNS(___REF_SYM(754,___S_six_2e_procedure),___REF_CNS(832))
,___DEF_CNS(___REF_SYM(755,___S_six_2e_procedure_2d_body),___REF_CNS(833))
,___DEF_CNS(___REF_SYM(756,___S_six_2e_return),___REF_CNS(834))
,___DEF_CNS(___REF_SYM(757,___S_six_2e_switch),___REF_CNS(835))
,___DEF_CNS(___REF_SYM(758,___S_six_2e_while),___REF_CNS(836))
,___DEF_CNS(___REF_SYM(759,___S_six_2e_x_21__3d_y),___REF_CNS(837))
,___DEF_CNS(___REF_SYM(760,___S_six_2e_x_25__3d_y),___REF_CNS(838))
,___DEF_CNS(___REF_SYM(761,___S_six_2e_x_25_y),___REF_CNS(839))
,___DEF_CNS(___REF_SYM(762,___S_six_2e_x_26__26_y),___REF_CNS(840))
,___DEF_CNS(___REF_SYM(763,___S_six_2e_x_26__3d_y),___REF_CNS(841))
,___DEF_CNS(___REF_SYM(764,___S_six_2e_x_26_y),___REF_CNS(842))
,___DEF_CNS(___REF_SYM(765,___S_six_2e_x_2a__3d_y),___REF_CNS(843))
,___DEF_CNS(___REF_SYM(766,___S_six_2e_x_2a_y),___REF_CNS(844))
,___DEF_CNS(___REF_SYM(767,___S_six_2e_x_2b__2b_),___REF_CNS(845))
,___DEF_CNS(___REF_SYM(768,___S_six_2e_x_2b__3d_y),___REF_CNS(846))
,___DEF_CNS(___REF_SYM(769,___S_six_2e_x_2b_y),___REF_CNS(847))
,___DEF_CNS(___REF_SYM(771,___S_six_2e_x_2d__2d_),___REF_CNS(848))
,___DEF_CNS(___REF_SYM(772,___S_six_2e_x_2d__3d_y),___REF_CNS(849))
,___DEF_CNS(___REF_SYM(773,___S_six_2e_x_2d_y),___REF_CNS(850))
,___DEF_CNS(___REF_SYM(774,___S_six_2e_x_2f__3d_y),___REF_CNS(851))
,___DEF_CNS(___REF_SYM(775,___S_six_2e_x_2f_y),___REF_CNS(852))
,___DEF_CNS(___REF_SYM(776,___S_six_2e_x_3a__2d_y),___REF_CNS(853))
,___DEF_CNS(___REF_SYM(777,___S_six_2e_x_3a__3d_y),___REF_CNS(854))
,___DEF_CNS(___REF_SYM(778,___S_six_2e_x_3a_y),___REF_CNS(855))
,___DEF_CNS(___REF_SYM(779,___S_six_2e_x_3c__3c__3d_y),___REF_CNS(856))
,___DEF_CNS(___REF_SYM(780,___S_six_2e_x_3c__3c_y),___REF_CNS(857))
,___DEF_CNS(___REF_SYM(781,___S_six_2e_x_3c__3d_y),___REF_CNS(858))
,___DEF_CNS(___REF_SYM(782,___S_six_2e_x_3c_y),___REF_CNS(859))
,___DEF_CNS(___REF_SYM(783,___S_six_2e_x_3d__3d_y),___REF_CNS(860))
,___DEF_CNS(___REF_SYM(784,___S_six_2e_x_3d_y),___REF_CNS(861))
,___DEF_CNS(___REF_SYM(785,___S_six_2e_x_3e__3d_y),___REF_CNS(862))
,___DEF_CNS(___REF_SYM(786,___S_six_2e_x_3e__3e__3d_y),___REF_CNS(863))
,___DEF_CNS(___REF_SYM(787,___S_six_2e_x_3e__3e_y),___REF_CNS(864))
,___DEF_CNS(___REF_SYM(788,___S_six_2e_x_3e_y),___REF_CNS(865))
,___DEF_CNS(___REF_SYM(789,___S_six_2e_x_3f_y_3a_z),___REF_CNS(866))
,___DEF_CNS(___REF_SYM(790,___S_six_2e_x_5e__3d_y),___REF_CNS(867))
,___DEF_CNS(___REF_SYM(791,___S_six_2e_x_5e_y),___REF_CNS(868))
,___DEF_CNS(___REF_SYM(795,___S_six_2e__7e_x),___REF_CNS(869))
,___DEF_CNS(___REF_SYM(796,___S_socket_2d_info_2d_address),___REF_CNS(870))
,___DEF_CNS(___REF_SYM(797,___S_socket_2d_info_2d_family),___REF_CNS(871))
,___DEF_CNS(___REF_SYM(798,___S_socket_2d_info_2d_port_2d_number),___REF_CNS(872))
,___DEF_CNS(___REF_SYM(799,___S_socket_2d_info_3f_),___REF_CNS(873))
,___DEF_CNS(___REF_SYM(801,___S_stack_2d_overflow_2d_exception_3f_),___REF_CNS(874))
,___DEF_CNS(___REF_SYM(802,___S_started_2d_thread_2d_exception_2d_arguments),___REF_CNS(875))
,___DEF_CNS(___REF_SYM(803,___S_started_2d_thread_2d_exception_2d_procedure),___REF_CNS(876))
,___DEF_CNS(___REF_SYM(804,___S_started_2d_thread_2d_exception_3f_),___REF_CNS(877))
,___DEF_CNS(___REF_SYM(805,___S_step),___REF_CNS(878))
,___DEF_CNS(___REF_SYM(806,___S_step_2d_level_2d_set_21_),___REF_CNS(879))
,___DEF_CNS(___REF_SYM(808,___S_string_2d__3e_keyword),___REF_CNS(880))
,___DEF_CNS(___REF_SYM(813,___S_string_2d_ci_3c__3d__3f_),___REF_CNS(881))
,___DEF_CNS(___REF_SYM(814,___S_string_2d_ci_3c__3f_),___REF_CNS(882))
,___DEF_CNS(___REF_SYM(815,___S_string_2d_ci_3d__3f_),___REF_CNS(883))
,___DEF_CNS(___REF_SYM(816,___S_string_2d_ci_3d__3f__2d_hash),___REF_CNS(884))
,___DEF_CNS(___REF_SYM(817,___S_string_2d_ci_3e__3d__3f_),___REF_CNS(885))
,___DEF_CNS(___REF_SYM(818,___S_string_2d_ci_3e__3f_),___REF_CNS(886))
,___DEF_CNS(___REF_SYM(824,___S_string_2d_shrink_21_),___REF_CNS(887))
,___DEF_CNS(___REF_SYM(825,___S_string_3c__3d__3f_),___REF_CNS(888))
,___DEF_CNS(___REF_SYM(826,___S_string_3c__3f_),___REF_CNS(889))
,___DEF_CNS(___REF_SYM(827,___S_string_3d__3f_),___REF_CNS(890))
,___DEF_CNS(___REF_SYM(828,___S_string_3d__3f__2d_hash),___REF_CNS(891))
,___DEF_CNS(___REF_SYM(829,___S_string_3e__3d__3f_),___REF_CNS(892))
,___DEF_CNS(___REF_SYM(830,___S_string_3e__3f_),___REF_CNS(893))
,___DEF_CNS(___REF_SYM(832,___S_subf32vector),___REF_CNS(894))
,___DEF_CNS(___REF_SYM(833,___S_subf32vector_2d_fill_21_),___REF_CNS(895))
,___DEF_CNS(___REF_SYM(834,___S_subf32vector_2d_move_21_),___REF_CNS(896))
,___DEF_CNS(___REF_SYM(835,___S_subf64vector),___REF_CNS(897))
,___DEF_CNS(___REF_SYM(836,___S_subf64vector_2d_fill_21_),___REF_CNS(898))
,___DEF_CNS(___REF_SYM(837,___S_subf64vector_2d_move_21_),___REF_CNS(899))
,___DEF_CNS(___REF_SYM(838,___S_subs16vector),___REF_CNS(900))
,___DEF_CNS(___REF_SYM(839,___S_subs16vector_2d_fill_21_),___REF_CNS(901))
,___DEF_CNS(___REF_SYM(840,___S_subs16vector_2d_move_21_),___REF_CNS(902))
,___DEF_CNS(___REF_SYM(841,___S_subs32vector),___REF_CNS(903))
,___DEF_CNS(___REF_SYM(842,___S_subs32vector_2d_fill_21_),___REF_CNS(904))
,___DEF_CNS(___REF_SYM(843,___S_subs32vector_2d_move_21_),___REF_CNS(905))
,___DEF_CNS(___REF_SYM(844,___S_subs64vector),___REF_CNS(906))
,___DEF_CNS(___REF_SYM(845,___S_subs64vector_2d_fill_21_),___REF_CNS(907))
,___DEF_CNS(___REF_SYM(846,___S_subs64vector_2d_move_21_),___REF_CNS(908))
,___DEF_CNS(___REF_SYM(847,___S_subs8vector),___REF_CNS(909))
,___DEF_CNS(___REF_SYM(848,___S_subs8vector_2d_fill_21_),___REF_CNS(910))
,___DEF_CNS(___REF_SYM(849,___S_subs8vector_2d_move_21_),___REF_CNS(911))
,___DEF_CNS(___REF_SYM(851,___S_substring_2d_fill_21_),___REF_CNS(912))
,___DEF_CNS(___REF_SYM(852,___S_substring_2d_move_21_),___REF_CNS(913))
,___DEF_CNS(___REF_SYM(853,___S_subu16vector),___REF_CNS(914))
,___DEF_CNS(___REF_SYM(854,___S_subu16vector_2d_fill_21_),___REF_CNS(915))
,___DEF_CNS(___REF_SYM(855,___S_subu16vector_2d_move_21_),___REF_CNS(916))
,___DEF_CNS(___REF_SYM(856,___S_subu32vector),___REF_CNS(917))
,___DEF_CNS(___REF_SYM(857,___S_subu32vector_2d_fill_21_),___REF_CNS(918))
,___DEF_CNS(___REF_SYM(858,___S_subu32vector_2d_move_21_),___REF_CNS(919))
,___DEF_CNS(___REF_SYM(859,___S_subu64vector),___REF_CNS(920))
,___DEF_CNS(___REF_SYM(860,___S_subu64vector_2d_fill_21_),___REF_CNS(921))
,___DEF_CNS(___REF_SYM(861,___S_subu64vector_2d_move_21_),___REF_CNS(922))
,___DEF_CNS(___REF_SYM(862,___S_subu8vector),___REF_CNS(923))
,___DEF_CNS(___REF_SYM(863,___S_subu8vector_2d_fill_21_),___REF_CNS(924))
,___DEF_CNS(___REF_SYM(864,___S_subu8vector_2d_move_21_),___REF_CNS(925))
,___DEF_CNS(___REF_SYM(865,___S_subvector),___REF_CNS(926))
,___DEF_CNS(___REF_SYM(866,___S_subvector_2d_fill_21_),___REF_CNS(927))
,___DEF_CNS(___REF_SYM(867,___S_subvector_2d_move_21_),___REF_CNS(928))
,___DEF_CNS(___REF_SYM(869,___S_symbol_2d_hash),___REF_CNS(929))
,___DEF_CNS(___REF_SYM(872,___S_system_2d_stamp),___REF_CNS(930))
,___DEF_CNS(___REF_SYM(873,___S_system_2d_type),___REF_CNS(931))
,___DEF_CNS(___REF_SYM(874,___S_system_2d_type_2d_string),___REF_CNS(932))
,___DEF_CNS(___REF_SYM(875,___S_system_2d_version),___REF_CNS(933))
,___DEF_CNS(___REF_SYM(876,___S_system_2d_version_2d_string),___REF_CNS(934))
,___DEF_CNS(___REF_SYM(877,___S_table_2d__3e_list),___REF_CNS(935))
,___DEF_CNS(___REF_SYM(878,___S_table_2d_copy),___REF_CNS(936))
,___DEF_CNS(___REF_SYM(879,___S_table_2d_for_2d_each),___REF_CNS(937))
,___DEF_CNS(___REF_SYM(880,___S_table_2d_length),___REF_CNS(938))
,___DEF_CNS(___REF_SYM(881,___S_table_2d_merge),___REF_CNS(939))
,___DEF_CNS(___REF_SYM(882,___S_table_2d_merge_21_),___REF_CNS(940))
,___DEF_CNS(___REF_SYM(883,___S_table_2d_ref),___REF_CNS(941))
,___DEF_CNS(___REF_SYM(884,___S_table_2d_search),___REF_CNS(942))
,___DEF_CNS(___REF_SYM(885,___S_table_2d_set_21_),___REF_CNS(943))
,___DEF_CNS(___REF_SYM(886,___S_table_3f_),___REF_CNS(944))
,___DEF_CNS(___REF_SYM(888,___S_tcp_2d_client_2d_peer_2d_socket_2d_info),___REF_CNS(945))
,___DEF_CNS(___REF_SYM(889,___S_tcp_2d_client_2d_self_2d_socket_2d_info),___REF_CNS(946))
,___DEF_CNS(___REF_SYM(890,___S_tcp_2d_server_2d_socket_2d_info),___REF_CNS(947))
,___DEF_CNS(___REF_SYM(891,___S_tcp_2d_service_2d_register_21_),___REF_CNS(948))
,___DEF_CNS(___REF_SYM(892,___S_tcp_2d_service_2d_unregister_21_),___REF_CNS(949))
,___DEF_CNS(___REF_SYM(893,___S_terminated_2d_thread_2d_exception_2d_arguments),___REF_CNS(950))
,___DEF_CNS(___REF_SYM(894,___S_terminated_2d_thread_2d_exception_2d_procedure),___REF_CNS(951))
,___DEF_CNS(___REF_SYM(895,___S_terminated_2d_thread_2d_exception_3f_),___REF_CNS(952))
,___DEF_CNS(___REF_SYM(896,___S_test_2d_bit_2d_field_3f_),___REF_CNS(953))
,___DEF_CNS(___REF_SYM(897,___S_this_2d_source_2d_file),___REF_CNS(954))
,___DEF_CNS(___REF_SYM(898,___S_thread_2d_base_2d_priority),___REF_CNS(955))
,___DEF_CNS(___REF_SYM(899,___S_thread_2d_base_2d_priority_2d_set_21_),___REF_CNS(956))
,___DEF_CNS(___REF_SYM(900,___S_thread_2d_group_2d__3e_thread_2d_group_2d_list),___REF_CNS(957))
,___DEF_CNS(___REF_SYM(901,___S_thread_2d_group_2d__3e_thread_2d_group_2d_vector),___REF_CNS(958))
,___DEF_CNS(___REF_SYM(902,___S_thread_2d_group_2d__3e_thread_2d_list),___REF_CNS(959))
,___DEF_CNS(___REF_SYM(903,___S_thread_2d_group_2d__3e_thread_2d_vector),___REF_CNS(960))
,___DEF_CNS(___REF_SYM(904,___S_thread_2d_group_2d_name),___REF_CNS(961))
,___DEF_CNS(___REF_SYM(905,___S_thread_2d_group_2d_parent),___REF_CNS(962))
,___DEF_CNS(___REF_SYM(906,___S_thread_2d_group_2d_resume_21_),___REF_CNS(963))
,___DEF_CNS(___REF_SYM(907,___S_thread_2d_group_2d_suspend_21_),___REF_CNS(964))
,___DEF_CNS(___REF_SYM(908,___S_thread_2d_group_2d_terminate_21_),___REF_CNS(965))
,___DEF_CNS(___REF_SYM(909,___S_thread_2d_group_3f_),___REF_CNS(966))
,___DEF_CNS(___REF_SYM(910,___S_thread_2d_init_21_),___REF_CNS(967))
,___DEF_CNS(___REF_SYM(911,___S_thread_2d_interrupt_21_),___REF_CNS(968))
,___DEF_CNS(___REF_SYM(912,___S_thread_2d_join_21_),___REF_CNS(969))
,___DEF_CNS(___REF_SYM(913,___S_thread_2d_mailbox_2d_extract_2d_and_2d_rewind),___REF_CNS(970))
,___DEF_CNS(___REF_SYM(914,___S_thread_2d_mailbox_2d_next),___REF_CNS(971))
,___DEF_CNS(___REF_SYM(915,___S_thread_2d_mailbox_2d_rewind),___REF_CNS(972))
,___DEF_CNS(___REF_SYM(916,___S_thread_2d_name),___REF_CNS(973))
,___DEF_CNS(___REF_SYM(917,___S_thread_2d_priority_2d_boost),___REF_CNS(974))
,___DEF_CNS(___REF_SYM(918,___S_thread_2d_priority_2d_boost_2d_set_21_),___REF_CNS(975))
,___DEF_CNS(___REF_SYM(919,___S_thread_2d_quantum),___REF_CNS(976))
,___DEF_CNS(___REF_SYM(920,___S_thread_2d_quantum_2d_set_21_),___REF_CNS(977))
,___DEF_CNS(___REF_SYM(921,___S_thread_2d_receive),___REF_CNS(978))
,___DEF_CNS(___REF_SYM(922,___S_thread_2d_resume_21_),___REF_CNS(979))
,___DEF_CNS(___REF_SYM(923,___S_thread_2d_send),___REF_CNS(980))
,___DEF_CNS(___REF_SYM(924,___S_thread_2d_sleep_21_),___REF_CNS(981))
,___DEF_CNS(___REF_SYM(925,___S_thread_2d_specific),___REF_CNS(982))
,___DEF_CNS(___REF_SYM(926,___S_thread_2d_specific_2d_set_21_),___REF_CNS(983))
,___DEF_CNS(___REF_SYM(927,___S_thread_2d_start_21_),___REF_CNS(984))
,___DEF_CNS(___REF_SYM(928,___S_thread_2d_state),___REF_CNS(985))
,___DEF_CNS(___REF_SYM(929,___S_thread_2d_state_2d_abnormally_2d_terminated_2d_reason),___REF_CNS(986))
,___DEF_CNS(___REF_SYM(930,___S_thread_2d_state_2d_abnormally_2d_terminated_3f_),___REF_CNS(987))
,___DEF_CNS(___REF_SYM(931,___S_thread_2d_state_2d_active_2d_timeout),___REF_CNS(988))
,___DEF_CNS(___REF_SYM(932,___S_thread_2d_state_2d_active_2d_waiting_2d_for),___REF_CNS(989))
,___DEF_CNS(___REF_SYM(933,___S_thread_2d_state_2d_active_3f_),___REF_CNS(990))
,___DEF_CNS(___REF_SYM(934,___S_thread_2d_state_2d_initialized_3f_),___REF_CNS(991))
,___DEF_CNS(___REF_SYM(935,___S_thread_2d_state_2d_normally_2d_terminated_2d_result),___REF_CNS(992))
,___DEF_CNS(___REF_SYM(936,___S_thread_2d_state_2d_normally_2d_terminated_3f_),___REF_CNS(993))
,___DEF_CNS(___REF_SYM(937,___S_thread_2d_state_2d_uninitialized_3f_),___REF_CNS(994))
,___DEF_CNS(___REF_SYM(938,___S_thread_2d_suspend_21_),___REF_CNS(995))
,___DEF_CNS(___REF_SYM(939,___S_thread_2d_terminate_21_),___REF_CNS(996))
,___DEF_CNS(___REF_SYM(940,___S_thread_2d_thread_2d_group),___REF_CNS(997))
,___DEF_CNS(___REF_SYM(941,___S_thread_2d_yield_21_),___REF_CNS(998))
,___DEF_CNS(___REF_SYM(942,___S_thread_3f_),___REF_CNS(999))
,___DEF_CNS(___REF_SYM(943,___S_time),___REF_CNS(1000))
,___DEF_CNS(___REF_SYM(944,___S_time_2d__3e_seconds),___REF_CNS(1001))
,___DEF_CNS(___REF_SYM(945,___S_time_3f_),___REF_CNS(1002))
,___DEF_CNS(___REF_SYM(946,___S_timeout_2d__3e_time),___REF_CNS(1003))
,___DEF_CNS(___REF_SYM(947,___S_top),___REF_CNS(1004))
,___DEF_CNS(___REF_SYM(948,___S_touch),___REF_CNS(1005))
,___DEF_CNS(___REF_SYM(949,___S_trace),___REF_CNS(1006))
,___DEF_CNS(___REF_SYM(950,___S_transcript_2d_off),___REF_CNS(1007))
,___DEF_CNS(___REF_SYM(951,___S_transcript_2d_on),___REF_CNS(1008))
,___DEF_CNS(___REF_SYM(953,___S_tty_2d_history),___REF_CNS(1009))
,___DEF_CNS(___REF_SYM(954,___S_tty_2d_history_2d_max_2d_length_2d_set_21_),___REF_CNS(1010))
,___DEF_CNS(___REF_SYM(955,___S_tty_2d_history_2d_set_21_),___REF_CNS(1011))
,___DEF_CNS(___REF_SYM(956,___S_tty_2d_mode_2d_set_21_),___REF_CNS(1012))
,___DEF_CNS(___REF_SYM(957,___S_tty_2d_paren_2d_balance_2d_duration_2d_set_21_),___REF_CNS(1013))
,___DEF_CNS(___REF_SYM(958,___S_tty_2d_text_2d_attributes_2d_set_21_),___REF_CNS(1014))
,___DEF_CNS(___REF_SYM(959,___S_tty_2d_type_2d_set_21_),___REF_CNS(1015))
,___DEF_CNS(___REF_SYM(960,___S_tty_3f_),___REF_CNS(1016))
,___DEF_CNS(___REF_SYM(961,___S_type_2d_exception_2d_arg_2d_num),___REF_CNS(1017))
,___DEF_CNS(___REF_SYM(962,___S_type_2d_exception_2d_arguments),___REF_CNS(1018))
,___DEF_CNS(___REF_SYM(963,___S_type_2d_exception_2d_procedure),___REF_CNS(1019))
,___DEF_CNS(___REF_SYM(964,___S_type_2d_exception_2d_type_2d_id),___REF_CNS(1020))
,___DEF_CNS(___REF_SYM(965,___S_type_2d_exception_3f_),___REF_CNS(1021))
,___DEF_CNS(___REF_SYM(966,___S_u16vector),___REF_CNS(1022))
,___DEF_CNS(___REF_SYM(967,___S_u16vector_2d__3e_list),___REF_CNS(1023))
,___DEF_CNS(___REF_SYM(968,___S_u16vector_2d_append),___REF_CNS(1024))
,___DEF_CNS(___REF_SYM(969,___S_u16vector_2d_copy),___REF_CNS(1025))
,___DEF_CNS(___REF_SYM(970,___S_u16vector_2d_fill_21_),___REF_CNS(1026))
,___DEF_CNS(___REF_SYM(971,___S_u16vector_2d_length),___REF_CNS(1027))
,___DEF_CNS(___REF_SYM(972,___S_u16vector_2d_ref),___REF_CNS(1028))
,___DEF_CNS(___REF_SYM(973,___S_u16vector_2d_set_21_),___REF_CNS(1029))
,___DEF_CNS(___REF_SYM(974,___S_u16vector_2d_shrink_21_),___REF_CNS(1030))
,___DEF_CNS(___REF_SYM(975,___S_u16vector_3f_),___REF_CNS(1031))
,___DEF_CNS(___REF_SYM(976,___S_u32vector),___REF_CNS(1032))
,___DEF_CNS(___REF_SYM(977,___S_u32vector_2d__3e_list),___REF_CNS(1033))
,___DEF_CNS(___REF_SYM(978,___S_u32vector_2d_append),___REF_CNS(1034))
,___DEF_CNS(___REF_SYM(979,___S_u32vector_2d_copy),___REF_CNS(1035))
,___DEF_CNS(___REF_SYM(980,___S_u32vector_2d_fill_21_),___REF_CNS(1036))
,___DEF_CNS(___REF_SYM(981,___S_u32vector_2d_length),___REF_CNS(1037))
,___DEF_CNS(___REF_SYM(982,___S_u32vector_2d_ref),___REF_CNS(1038))
,___DEF_CNS(___REF_SYM(983,___S_u32vector_2d_set_21_),___REF_CNS(1039))
,___DEF_CNS(___REF_SYM(984,___S_u32vector_2d_shrink_21_),___REF_CNS(1040))
,___DEF_CNS(___REF_SYM(985,___S_u32vector_3f_),___REF_CNS(1041))
,___DEF_CNS(___REF_SYM(986,___S_u64vector),___REF_CNS(1042))
,___DEF_CNS(___REF_SYM(987,___S_u64vector_2d__3e_list),___REF_CNS(1043))
,___DEF_CNS(___REF_SYM(988,___S_u64vector_2d_append),___REF_CNS(1044))
,___DEF_CNS(___REF_SYM(989,___S_u64vector_2d_copy),___REF_CNS(1045))
,___DEF_CNS(___REF_SYM(990,___S_u64vector_2d_fill_21_),___REF_CNS(1046))
,___DEF_CNS(___REF_SYM(991,___S_u64vector_2d_length),___REF_CNS(1047))
,___DEF_CNS(___REF_SYM(992,___S_u64vector_2d_ref),___REF_CNS(1048))
,___DEF_CNS(___REF_SYM(993,___S_u64vector_2d_set_21_),___REF_CNS(1049))
,___DEF_CNS(___REF_SYM(994,___S_u64vector_2d_shrink_21_),___REF_CNS(1050))
,___DEF_CNS(___REF_SYM(995,___S_u64vector_3f_),___REF_CNS(1051))
,___DEF_CNS(___REF_SYM(996,___S_u8vector),___REF_CNS(1052))
,___DEF_CNS(___REF_SYM(997,___S_u8vector_2d__3e_list),___REF_CNS(1053))
,___DEF_CNS(___REF_SYM(998,___S_u8vector_2d__3e_object),___REF_CNS(1054))
,___DEF_CNS(___REF_SYM(999,___S_u8vector_2d_append),___REF_CNS(1055))
,___DEF_CNS(___REF_SYM(1000,___S_u8vector_2d_copy),___REF_CNS(1056))
,___DEF_CNS(___REF_SYM(1001,___S_u8vector_2d_fill_21_),___REF_CNS(1057))
,___DEF_CNS(___REF_SYM(1002,___S_u8vector_2d_length),___REF_CNS(1058))
,___DEF_CNS(___REF_SYM(1003,___S_u8vector_2d_ref),___REF_CNS(1059))
,___DEF_CNS(___REF_SYM(1004,___S_u8vector_2d_set_21_),___REF_CNS(1060))
,___DEF_CNS(___REF_SYM(1005,___S_u8vector_2d_shrink_21_),___REF_CNS(1061))
,___DEF_CNS(___REF_SYM(1006,___S_u8vector_3f_),___REF_CNS(1062))
,___DEF_CNS(___REF_SYM(1007,___S_unbound_2d_global_2d_exception_2d_code),___REF_CNS(1063))
,___DEF_CNS(___REF_SYM(1008,___S_unbound_2d_global_2d_exception_2d_rte),___REF_CNS(1064))
,___DEF_CNS(___REF_SYM(1009,___S_unbound_2d_global_2d_exception_2d_variable),___REF_CNS(1065))
,___DEF_CNS(___REF_SYM(1010,___S_unbound_2d_global_2d_exception_3f_),___REF_CNS(1066))
,___DEF_CNS(___REF_SYM(1011,___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_2d_arguments),___REF_CNS(1067))
,___DEF_CNS(___REF_SYM(1012,___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_2d_procedure),___REF_CNS(1068))
,___DEF_CNS(___REF_SYM(1013,___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_3f_),___REF_CNS(1069))
,___DEF_CNS(___REF_SYM(1014,___S_unbound_2d_serial_2d_number_2d_exception_2d_arguments),___REF_CNS(1070))
,___DEF_CNS(___REF_SYM(1015,___S_unbound_2d_serial_2d_number_2d_exception_2d_procedure),___REF_CNS(1071))
,___DEF_CNS(___REF_SYM(1016,___S_unbound_2d_serial_2d_number_2d_exception_3f_),___REF_CNS(1072))
,___DEF_CNS(___REF_SYM(1017,___S_unbound_2d_table_2d_key_2d_exception_2d_arguments),___REF_CNS(1073))
,___DEF_CNS(___REF_SYM(1018,___S_unbound_2d_table_2d_key_2d_exception_2d_procedure),___REF_CNS(1074))
,___DEF_CNS(___REF_SYM(1019,___S_unbound_2d_table_2d_key_2d_exception_3f_),___REF_CNS(1075))
,___DEF_CNS(___REF_SYM(1020,___S_unbox),___REF_CNS(1076))
,___DEF_CNS(___REF_SYM(1021,___S_unbreak),___REF_CNS(1077))
,___DEF_CNS(___REF_SYM(1022,___S_uncaught_2d_exception_2d_arguments),___REF_CNS(1078))
,___DEF_CNS(___REF_SYM(1023,___S_uncaught_2d_exception_2d_procedure),___REF_CNS(1079))
,___DEF_CNS(___REF_SYM(1024,___S_uncaught_2d_exception_2d_reason),___REF_CNS(1080))
,___DEF_CNS(___REF_SYM(1025,___S_uncaught_2d_exception_3f_),___REF_CNS(1081))
,___DEF_CNS(___REF_SYM(1026,___S_uninitialized_2d_thread_2d_exception_2d_arguments),___REF_CNS(1082))
,___DEF_CNS(___REF_SYM(1027,___S_uninitialized_2d_thread_2d_exception_2d_procedure),___REF_CNS(1083))
,___DEF_CNS(___REF_SYM(1028,___S_uninitialized_2d_thread_2d_exception_3f_),___REF_CNS(1084))
,___DEF_CNS(___REF_SYM(1029,___S_uninterned_2d_keyword_3f_),___REF_CNS(1085))
,___DEF_CNS(___REF_SYM(1030,___S_uninterned_2d_symbol_3f_),___REF_CNS(1086))
,___DEF_CNS(___REF_SYM(1031,___S_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments),___REF_CNS(1087))
,___DEF_CNS(___REF_SYM(1032,___S_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure),___REF_CNS(1088))
,___DEF_CNS(___REF_SYM(1033,___S_unknown_2d_keyword_2d_argument_2d_exception_3f_),___REF_CNS(1089))
,___DEF_CNS(___REF_SYM(1034,___S_unterminated_2d_process_2d_exception_2d_arguments),___REF_CNS(1090))
,___DEF_CNS(___REF_SYM(1035,___S_unterminated_2d_process_2d_exception_2d_procedure),___REF_CNS(1091))
,___DEF_CNS(___REF_SYM(1036,___S_unterminated_2d_process_2d_exception_3f_),___REF_CNS(1092))
,___DEF_CNS(___REF_SYM(1037,___S_untrace),___REF_CNS(1093))
,___DEF_CNS(___REF_SYM(1038,___S_user_2d_info),___REF_CNS(1094))
,___DEF_CNS(___REF_SYM(1039,___S_user_2d_info_2d_gid),___REF_CNS(1095))
,___DEF_CNS(___REF_SYM(1040,___S_user_2d_info_2d_home),___REF_CNS(1096))
,___DEF_CNS(___REF_SYM(1041,___S_user_2d_info_2d_name),___REF_CNS(1097))
,___DEF_CNS(___REF_SYM(1042,___S_user_2d_info_2d_shell),___REF_CNS(1098))
,___DEF_CNS(___REF_SYM(1043,___S_user_2d_info_2d_uid),___REF_CNS(1099))
,___DEF_CNS(___REF_SYM(1044,___S_user_2d_info_3f_),___REF_CNS(1100))
,___DEF_CNS(___REF_SYM(1045,___S_user_2d_name),___REF_CNS(1101))
,___DEF_CNS(___REF_SYM(1049,___S_vector_2d_append),___REF_CNS(1102))
,___DEF_CNS(___REF_SYM(1050,___S_vector_2d_copy),___REF_CNS(1103))
,___DEF_CNS(___REF_SYM(1055,___S_vector_2d_shrink_21_),___REF_CNS(1104))
,___DEF_CNS(___REF_SYM(1057,___S_void),___REF_CNS(1105))
,___DEF_CNS(___REF_SYM(1058,___S_will_2d_execute_21_),___REF_CNS(1106))
,___DEF_CNS(___REF_SYM(1059,___S_will_2d_testator),___REF_CNS(1107))
,___DEF_CNS(___REF_SYM(1060,___S_will_3f_),___REF_CNS(1108))
,___DEF_CNS(___REF_SYM(1061,___S_with_2d_exception_2d_catcher),___REF_CNS(1109))
,___DEF_CNS(___REF_SYM(1062,___S_with_2d_exception_2d_handler),___REF_CNS(1110))
,___DEF_CNS(___REF_SYM(1063,___S_with_2d_input_2d_from_2d_file),___REF_CNS(1111))
,___DEF_CNS(___REF_SYM(1064,___S_with_2d_input_2d_from_2d_port),___REF_CNS(1112))
,___DEF_CNS(___REF_SYM(1065,___S_with_2d_input_2d_from_2d_process),___REF_CNS(1113))
,___DEF_CNS(___REF_SYM(1066,___S_with_2d_input_2d_from_2d_string),___REF_CNS(1114))
,___DEF_CNS(___REF_SYM(1067,___S_with_2d_input_2d_from_2d_u8vector),___REF_CNS(1115))
,___DEF_CNS(___REF_SYM(1068,___S_with_2d_input_2d_from_2d_vector),___REF_CNS(1116))
,___DEF_CNS(___REF_SYM(1069,___S_with_2d_output_2d_to_2d_file),___REF_CNS(1117))
,___DEF_CNS(___REF_SYM(1070,___S_with_2d_output_2d_to_2d_port),___REF_CNS(1118))
,___DEF_CNS(___REF_SYM(1071,___S_with_2d_output_2d_to_2d_process),___REF_CNS(1119))
,___DEF_CNS(___REF_SYM(1072,___S_with_2d_output_2d_to_2d_string),___REF_CNS(1120))
,___DEF_CNS(___REF_SYM(1073,___S_with_2d_output_2d_to_2d_u8vector),___REF_CNS(1121))
,___DEF_CNS(___REF_SYM(1074,___S_with_2d_output_2d_to_2d_vector),___REF_CNS(1122))
,___DEF_CNS(___REF_SYM(1075,___S_write),___REF_CNS(1123))
,___DEF_CNS(___REF_SYM(1076,___S_write_2d_char),___REF_CNS(1124))
,___DEF_CNS(___REF_SYM(1077,___S_write_2d_substring),___REF_CNS(1125))
,___DEF_CNS(___REF_SYM(1078,___S_write_2d_subu8vector),___REF_CNS(1126))
,___DEF_CNS(___REF_SYM(1079,___S_write_2d_u8),___REF_CNS(1127))
,___DEF_CNS(___REF_SYM(1080,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments),___REF_CNS(1128))
,___DEF_CNS(___REF_SYM(1081,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure),___REF_CNS(1129))
,___DEF_CNS(___REF_SYM(1082,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_),___REF_CNS(1130))
,___DEF_CNS(___REF_SYM(770,___S_six_2e_x_2c_y),___REF_CNS(1131))
,___DEF_CNS(___REF_SYM(792,___S_six_2e_x_7c__3d_y),___REF_CNS(1132))
,___DEF_CNS(___REF_SYM(794,___S_six_2e_x_7c__7c_y),___REF_CNS(1133))
,___DEF_CNS(___REF_SYM(793,___S_six_2e_x_7c_y),___REF_NUL)
___END_CNS

___DEF_SUB_STR(___X0,12)
               ___STR8(126,126,47,104,101,108,112,46)
               ___STR4(104,116,109,108)
___DEF_SUB_STR(___X1,12)
               ___STR8(126,126,47,114,53,114,115,46)
               ___STR4(104,116,109,108)
___DEF_SUB_STR(___X2,16)
               ___STR8(126,126,47,103,97,109,98,105)
               ___STR8(116,45,99,46,104,116,109,108)
               ___STR0
___DEF_SUB_STR(___X3,20)
               ___STR8(78,111,32,100,111,99,117,109)
               ___STR8(101,110,116,97,116,105,111,110)
               ___STR4(32,102,111,114)
___DEF_SUB_STR(___X4,14)
               ___STR8(68,101,102,105,110,105,116,105)
               ___STR6(111,110,32,111,102,32)
___DEF_SUB_VEC(___X5,5)
               ___VEC1(___REF_SYM(362,___S_help))
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
___END_SUB



#undef ___MD_ALL
#define ___MD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___MR_ALL
#define ___MR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___MW_ALL
#define ___MW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_M_COD
___BEGIN_M_HLBL
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0__20_help)
___DEF_M_HLBL(___L1__20_help)
___DEF_M_HLBL(___L2__20_help)
___DEF_M_HLBL(___L3__20_help)
___DEF_M_HLBL(___L4__20_help)
___DEF_M_HLBL(___L5__20_help)
___DEF_M_HLBL_INTRO
___DEF_M_HLBL(___L0_help_23_gambit_2d_repl_2d_help)
___DEF_M_HLBL(___L1_help_23_gambit_2d_repl_2d_help)
___DEF_M_HLBL(___L2_help_23_gambit_2d_repl_2d_help)
___DEF_M_HLBL(___L3_help_23_gambit_2d_repl_2d_help)
___DEF_M_HLBL(___L4_help_23_gambit_2d_repl_2d_help)
___DEF_M_HLBL(___L5_help_23_gambit_2d_repl_2d_help)
___DEF_M_HLBL(___L6_help_23_gambit_2d_repl_2d_help)
___DEF_M_HLBL(___L7_help_23_gambit_2d_repl_2d_help)
___DEF_M_HLBL(___L8_help_23_gambit_2d_repl_2d_help)
___DEF_M_HLBL(___L9_help_23_gambit_2d_repl_2d_help)
___DEF_M_HLBL(___L10_help_23_gambit_2d_repl_2d_help)
___DEF_M_HLBL(___L11_help_23_gambit_2d_repl_2d_help)
___DEF_M_HLBL(___L12_help_23_gambit_2d_repl_2d_help)
___END_M_HLBL

___BEGIN_M_SW

#undef ___PH_PROC
#define ___PH_PROC ___H__20_help
#undef ___PH_LBL0
#define ___PH_LBL0 1
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0__20_help)
___DEF_P_HLBL(___L1__20_help)
___DEF_P_HLBL(___L2__20_help)
___DEF_P_HLBL(___L3__20_help)
___DEF_P_HLBL(___L4__20_help)
___DEF_P_HLBL(___L5__20_help)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0__20_help)
   ___IF_NARGS_EQ(0,___NOTHING)
   ___WRONG_NARGS(0,0,0,0)
___DEF_GLBL(___L__20_help)
   ___SET_STK(1,___R0)
   ___SET_R1(___SUB(0))
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1__20_help)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),13,___G_path_2d_expand)
___DEF_SLBL(2,___L2__20_help)
   ___SET_GLO(6,___G_help_23_main_2d_help_2d_document,___R1)
   ___SET_R1(___SUB(1))
   ___SET_R0(___LBL(3))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),13,___G_path_2d_expand)
___DEF_SLBL(3,___L3__20_help)
   ___SET_GLO(7,___G_help_23_r5rs_2d_help_2d_document,___R1)
   ___SET_R1(___SUB(2))
   ___SET_R0(___LBL(4))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),13,___G_path_2d_expand)
___DEF_SLBL(4,___L4__20_help)
   ___SET_GLO(2,___G_help_23_gambit_2d_c_2d_help_2d_document,___R1)
   ___SET_GLO(5,___G_help_23_help_2d_names_2d_r5rs,___CNS(0))
   ___SET_GLO(4,___G_help_23_help_2d_names_2d_gambit_2d_c,___CNS(194))
   ___SET_GLO(1,___G__23__23_help_2d_hook,___PRC(8))
   ___SET_R1(___VOID)
   ___POLL(5)
___DEF_SLBL(5,___L5__20_help)
   ___ADJFP(-4)
   ___JUMPPRM(___NOTHING,___STK(1))
___END_P_SW
___END_P_COD

#undef ___PH_PROC
#define ___PH_PROC ___H_help_23_gambit_2d_repl_2d_help
#undef ___PH_LBL0
#define ___PH_LBL0 8
#undef ___PD_ALL
#define ___PD_ALL ___D_FP ___D_R0 ___D_R1 ___D_R2 ___D_R3 ___D_R4
#undef ___PR_ALL
#define ___PR_ALL ___R_FP ___R_R0 ___R_R1 ___R_R2 ___R_R3 ___R_R4
#undef ___PW_ALL
#define ___PW_ALL ___W_FP ___W_R0 ___W_R1 ___W_R2 ___W_R3 ___W_R4
___BEGIN_P_COD
___BEGIN_P_HLBL
___DEF_P_HLBL_INTRO
___DEF_P_HLBL(___L0_help_23_gambit_2d_repl_2d_help)
___DEF_P_HLBL(___L1_help_23_gambit_2d_repl_2d_help)
___DEF_P_HLBL(___L2_help_23_gambit_2d_repl_2d_help)
___DEF_P_HLBL(___L3_help_23_gambit_2d_repl_2d_help)
___DEF_P_HLBL(___L4_help_23_gambit_2d_repl_2d_help)
___DEF_P_HLBL(___L5_help_23_gambit_2d_repl_2d_help)
___DEF_P_HLBL(___L6_help_23_gambit_2d_repl_2d_help)
___DEF_P_HLBL(___L7_help_23_gambit_2d_repl_2d_help)
___DEF_P_HLBL(___L8_help_23_gambit_2d_repl_2d_help)
___DEF_P_HLBL(___L9_help_23_gambit_2d_repl_2d_help)
___DEF_P_HLBL(___L10_help_23_gambit_2d_repl_2d_help)
___DEF_P_HLBL(___L11_help_23_gambit_2d_repl_2d_help)
___DEF_P_HLBL(___L12_help_23_gambit_2d_repl_2d_help)
___END_P_HLBL
___BEGIN_P_SW
___DEF_SLBL(0,___L0_help_23_gambit_2d_repl_2d_help)
   ___IF_NARGS_EQ(1,___NOTHING)
   ___WRONG_NARGS(0,1,0,0)
___DEF_GLBL(___L_help_23_gambit_2d_repl_2d_help)
   ___IF(___NOT(___PROCEDUREP(___R1)))
   ___GOTO(___L13_help_23_gambit_2d_repl_2d_help)
   ___END_IF
   ___SET_STK(1,___R0)
   ___SET_R0(___LBL(2))
   ___ADJFP(4)
   ___POLL(1)
___DEF_SLBL(1,___L1_help_23_gambit_2d_repl_2d_help)
   ___JUMPGLONOTSAFE(___SET_NARGS(1),10,___G__23__23_procedure_2d_name)
___DEF_SLBL(2,___L2_help_23_gambit_2d_repl_2d_help)
   ___SET_R0(___STK(-3))
   ___ADJFP(-4)
___DEF_GLBL(___L13_help_23_gambit_2d_repl_2d_help)
   ___SET_STK(1,___R0)
   ___SET_STK(2,___R1)
   ___SET_R2(___CNS(194))
   ___SET_R0(___LBL(6))
   ___ADJFP(8)
   ___POLL(3)
___DEF_SLBL(3,___L3_help_23_gambit_2d_repl_2d_help)
   ___GOTO(___L15_help_23_gambit_2d_repl_2d_help)
___DEF_GLBL(___L14_help_23_gambit_2d_repl_2d_help)
   ___SET_R3(___CAR(___R2))
   ___IF(___EQP(___R1,___R3))
   ___GOTO(___L19_help_23_gambit_2d_repl_2d_help)
   ___END_IF
   ___SET_R2(___CDR(___R2))
   ___POLL(4)
___DEF_SLBL(4,___L4_help_23_gambit_2d_repl_2d_help)
___DEF_GLBL(___L15_help_23_gambit_2d_repl_2d_help)
   ___IF(___PAIRP(___R2))
   ___GOTO(___L14_help_23_gambit_2d_repl_2d_help)
   ___END_IF
___DEF_GLBL(___L16_help_23_gambit_2d_repl_2d_help)
   ___SET_R1(___FAL)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_GLBL(___L17_help_23_gambit_2d_repl_2d_help)
   ___SET_R2(___CDR(___R2))
   ___POLL(5)
___DEF_SLBL(5,___L5_help_23_gambit_2d_repl_2d_help)
   ___IF(___NOT(___PAIRP(___R2)))
   ___GOTO(___L16_help_23_gambit_2d_repl_2d_help)
   ___END_IF
___DEF_GLBL(___L18_help_23_gambit_2d_repl_2d_help)
   ___SET_R3(___CAR(___R2))
   ___IF(___NOT(___EQP(___R1,___R3)))
   ___GOTO(___L17_help_23_gambit_2d_repl_2d_help)
   ___END_IF
___DEF_GLBL(___L19_help_23_gambit_2d_repl_2d_help)
   ___SET_R1(___R2)
   ___JUMPPRM(___NOTHING,___R0)
___DEF_SLBL(6,___L6_help_23_gambit_2d_repl_2d_help)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L22_help_23_gambit_2d_repl_2d_help)
   ___END_IF
   ___SET_R1(___STK(-6))
   ___SET_R2(___CNS(0))
   ___SET_R0(___LBL(7))
   ___IF(___PAIRP(___R2))
   ___GOTO(___L18_help_23_gambit_2d_repl_2d_help)
   ___END_IF
   ___GOTO(___L16_help_23_gambit_2d_repl_2d_help)
___DEF_SLBL(7,___L7_help_23_gambit_2d_repl_2d_help)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L20_help_23_gambit_2d_repl_2d_help)
   ___END_IF
   ___SET_R1(___FAL)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L21_help_23_gambit_2d_repl_2d_help)
   ___END_IF
   ___GOTO(___L23_help_23_gambit_2d_repl_2d_help)
___DEF_GLBL(___L20_help_23_gambit_2d_repl_2d_help)
   ___SET_R1(___GLO_help_23_r5rs_2d_help_2d_document)
   ___IF(___NOT(___FALSEP(___R1)))
   ___GOTO(___L23_help_23_gambit_2d_repl_2d_help)
   ___END_IF
___DEF_GLBL(___L21_help_23_gambit_2d_repl_2d_help)
   ___SET_R2(___STK(-6))
   ___SET_R1(___SUB(3))
   ___SET_R0(___STK(-7))
   ___POLL(8)
___DEF_SLBL(8,___L8_help_23_gambit_2d_repl_2d_help)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),11,___G_error)
___DEF_GLBL(___L22_help_23_gambit_2d_repl_2d_help)
   ___SET_R1(___GLO_help_23_gambit_2d_c_2d_help_2d_document)
   ___IF(___FALSEP(___R1))
   ___GOTO(___L21_help_23_gambit_2d_repl_2d_help)
   ___END_IF
___DEF_GLBL(___L23_help_23_gambit_2d_repl_2d_help)
   ___SET_STK(-5,___R1)
   ___SET_R1(___STK(-6))
   ___SET_R0(___LBL(9))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),9,___G__23__23_object_2d__3e_string)
___DEF_SLBL(9,___L9_help_23_gambit_2d_repl_2d_help)
   ___SET_R2(___R1)
   ___SET_R1(___SUB(4))
   ___SET_R0(___LBL(10))
   ___JUMPPRM(___SET_NARGS(2),___PRM_string_2d_append)
___DEF_SLBL(10,___L10_help_23_gambit_2d_repl_2d_help)
   ___SET_R0(___LBL(11))
   ___JUMPGLONOTSAFE(___SET_NARGS(1),8,___G__23__23_escape_2d_link)
___DEF_SLBL(11,___L11_help_23_gambit_2d_repl_2d_help)
   ___SET_R2(___R1)
   ___SET_R1(___STK(-5))
   ___SET_R0(___STK(-7))
   ___POLL(12)
___DEF_SLBL(12,___L12_help_23_gambit_2d_repl_2d_help)
   ___ADJFP(-8)
   ___JUMPGLONOTSAFE(___SET_NARGS(2),12,___G_gr_23_show_2d_help_2d_document)
___END_P_SW
___END_P_COD

___END_M_SW
___END_M_COD

___BEGIN_LBL
 ___DEF_LBL_INTRO(___H__20_help," help",___REF_FAL,6,0)
,___DEF_LBL_PROC(___H__20_help,0,-1)
,___DEF_LBL_RET(___H__20_help,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H__20_help,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20_help,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20_help,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H__20_help,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_INTRO(___H_help_23_gambit_2d_repl_2d_help,"help#gambit-repl-help",___REF_FAL,13,0)
,___DEF_LBL_PROC(___H_help_23_gambit_2d_repl_2d_help,1,-1)
,___DEF_LBL_RET(___H_help_23_gambit_2d_repl_2d_help,___IFD(___RETI,4,0,0x3f1L))
,___DEF_LBL_RET(___H_help_23_gambit_2d_repl_2d_help,___IFD(___RETN,1,0,0x1L))
,___DEF_LBL_RET(___H_help_23_gambit_2d_repl_2d_help,___IFD(___RETI,8,0,0x3f03L))
,___DEF_LBL_RET(___H_help_23_gambit_2d_repl_2d_help,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_help_23_gambit_2d_repl_2d_help,___IFD(___RETI,0,0,0x3fL))
,___DEF_LBL_RET(___H_help_23_gambit_2d_repl_2d_help,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_help_23_gambit_2d_repl_2d_help,___IFD(___RETN,5,0,0x3L))
,___DEF_LBL_RET(___H_help_23_gambit_2d_repl_2d_help,___IFD(___RETI,8,8,0x3f00L))
,___DEF_LBL_RET(___H_help_23_gambit_2d_repl_2d_help,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_help_23_gambit_2d_repl_2d_help,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_help_23_gambit_2d_repl_2d_help,___IFD(___RETN,5,0,0x5L))
,___DEF_LBL_RET(___H_help_23_gambit_2d_repl_2d_help,___IFD(___RETI,8,8,0x3f00L))
___END_LBL

___BEGIN_MOD_PRM
___DEF_MOD_PRM(0,___G__20_help,1)
___DEF_MOD_PRM(3,___G_help_23_gambit_2d_repl_2d_help,8)
___END_MOD_PRM

___BEGIN_MOD_C_INIT
___END_MOD_C_INIT

___BEGIN_MOD_GLO
___DEF_MOD_GLO(0,___G__20_help,1)
___DEF_MOD_GLO(3,___G_help_23_gambit_2d_repl_2d_help,8)
___END_MOD_GLO

___BEGIN_MOD_SYM_KEY
___DEF_MOD_SYM(0,___S__2a_,"*")
___DEF_MOD_SYM(1,___S__2b_,"+")
___DEF_MOD_SYM(2,___S__2d_,"-")
___DEF_MOD_SYM(3,___S__2f_,"/")
___DEF_MOD_SYM(4,___S__3c_,"<")
___DEF_MOD_SYM(5,___S__3c__3d_,"<=")
___DEF_MOD_SYM(6,___S__3d_,"=")
___DEF_MOD_SYM(7,___S__3e_,">")
___DEF_MOD_SYM(8,___S__3e__3d_,">=")
___DEF_MOD_SYM(9,___S_abandoned_2d_mutex_2d_exception_3f_,"abandoned-mutex-exception?")
___DEF_MOD_SYM(10,___S_abort,"abort")
___DEF_MOD_SYM(11,___S_abs,"abs")
___DEF_MOD_SYM(12,___S_acos,"acos")
___DEF_MOD_SYM(13,___S_address_2d_info_2d_family,"address-info-family")
___DEF_MOD_SYM(14,___S_address_2d_info_2d_protocol,"address-info-protocol")
___DEF_MOD_SYM(15,___S_address_2d_info_2d_socket_2d_info,"address-info-socket-info")
___DEF_MOD_SYM(16,___S_address_2d_info_2d_socket_2d_type,"address-info-socket-type")
___DEF_MOD_SYM(17,___S_address_2d_info_3f_,"address-info?")
___DEF_MOD_SYM(18,___S_address_2d_infos,"address-infos")
___DEF_MOD_SYM(19,___S_all_2d_bits_2d_set_3f_,"all-bits-set?")
___DEF_MOD_SYM(20,___S_and,"and")
___DEF_MOD_SYM(21,___S_angle,"angle")
___DEF_MOD_SYM(22,___S_any_2d_bits_2d_set_3f_,"any-bits-set?")
___DEF_MOD_SYM(23,___S_append,"append")
___DEF_MOD_SYM(24,___S_append_2d_f32vectors,"append-f32vectors")
___DEF_MOD_SYM(25,___S_append_2d_f64vectors,"append-f64vectors")
___DEF_MOD_SYM(26,___S_append_2d_s16vectors,"append-s16vectors")
___DEF_MOD_SYM(27,___S_append_2d_s32vectors,"append-s32vectors")
___DEF_MOD_SYM(28,___S_append_2d_s64vectors,"append-s64vectors")
___DEF_MOD_SYM(29,___S_append_2d_s8vectors,"append-s8vectors")
___DEF_MOD_SYM(30,___S_append_2d_strings,"append-strings")
___DEF_MOD_SYM(31,___S_append_2d_u16vectors,"append-u16vectors")
___DEF_MOD_SYM(32,___S_append_2d_u32vectors,"append-u32vectors")
___DEF_MOD_SYM(33,___S_append_2d_u64vectors,"append-u64vectors")
___DEF_MOD_SYM(34,___S_append_2d_u8vectors,"append-u8vectors")
___DEF_MOD_SYM(35,___S_append_2d_vectors,"append-vectors")
___DEF_MOD_SYM(36,___S_apply,"apply")
___DEF_MOD_SYM(37,___S_arithmetic_2d_shift,"arithmetic-shift")
___DEF_MOD_SYM(38,___S_asin,"asin")
___DEF_MOD_SYM(39,___S_assoc,"assoc")
___DEF_MOD_SYM(40,___S_assq,"assq")
___DEF_MOD_SYM(41,___S_assv,"assv")
___DEF_MOD_SYM(42,___S_atan,"atan")
___DEF_MOD_SYM(43,___S_begin,"begin")
___DEF_MOD_SYM(44,___S_bit_2d_count,"bit-count")
___DEF_MOD_SYM(45,___S_bit_2d_set_3f_,"bit-set?")
___DEF_MOD_SYM(46,___S_bitwise_2d_and,"bitwise-and")
___DEF_MOD_SYM(47,___S_bitwise_2d_ior,"bitwise-ior")
___DEF_MOD_SYM(48,___S_bitwise_2d_merge,"bitwise-merge")
___DEF_MOD_SYM(49,___S_bitwise_2d_not,"bitwise-not")
___DEF_MOD_SYM(50,___S_bitwise_2d_xor,"bitwise-xor")
___DEF_MOD_SYM(51,___S_boolean_3f_,"boolean?")
___DEF_MOD_SYM(52,___S_box,"box")
___DEF_MOD_SYM(53,___S_box_3f_,"box?")
___DEF_MOD_SYM(54,___S_break,"break")
___DEF_MOD_SYM(55,___S_c_2d_declare,"c-declare")
___DEF_MOD_SYM(56,___S_c_2d_define,"c-define")
___DEF_MOD_SYM(57,___S_c_2d_define_2d_type,"c-define-type")
___DEF_MOD_SYM(58,___S_c_2d_initialize,"c-initialize")
___DEF_MOD_SYM(59,___S_c_2d_lambda,"c-lambda")
___DEF_MOD_SYM(60,___S_caar,"caar")
___DEF_MOD_SYM(61,___S_cadr,"cadr")
___DEF_MOD_SYM(62,___S_call_2d_with_2d_current_2d_continuation,"call-with-current-continuation")

___DEF_MOD_SYM(63,___S_call_2d_with_2d_input_2d_file,"call-with-input-file")
___DEF_MOD_SYM(64,___S_call_2d_with_2d_input_2d_process,"call-with-input-process")
___DEF_MOD_SYM(65,___S_call_2d_with_2d_input_2d_string,"call-with-input-string")
___DEF_MOD_SYM(66,___S_call_2d_with_2d_input_2d_u8vector,"call-with-input-u8vector")
___DEF_MOD_SYM(67,___S_call_2d_with_2d_input_2d_vector,"call-with-input-vector")
___DEF_MOD_SYM(68,___S_call_2d_with_2d_output_2d_file,"call-with-output-file")
___DEF_MOD_SYM(69,___S_call_2d_with_2d_output_2d_process,"call-with-output-process")
___DEF_MOD_SYM(70,___S_call_2d_with_2d_output_2d_string,"call-with-output-string")
___DEF_MOD_SYM(71,___S_call_2d_with_2d_output_2d_u8vector,"call-with-output-u8vector")
___DEF_MOD_SYM(72,___S_call_2d_with_2d_output_2d_vector,"call-with-output-vector")
___DEF_MOD_SYM(73,___S_call_2d_with_2d_values,"call-with-values")
___DEF_MOD_SYM(74,___S_call_2f_cc,"call/cc")
___DEF_MOD_SYM(75,___S_car,"car")
___DEF_MOD_SYM(76,___S_case,"case")
___DEF_MOD_SYM(77,___S_cdddar,"cdddar")
___DEF_MOD_SYM(78,___S_cddddr,"cddddr")
___DEF_MOD_SYM(79,___S_cdr,"cdr")
___DEF_MOD_SYM(80,___S_ceiling,"ceiling")
___DEF_MOD_SYM(81,___S_cfun_2d_conversion_2d_exception_2d_arguments,"cfun-conversion-exception-arguments")

___DEF_MOD_SYM(82,___S_cfun_2d_conversion_2d_exception_2d_code,"cfun-conversion-exception-code")

___DEF_MOD_SYM(83,___S_cfun_2d_conversion_2d_exception_2d_message,"cfun-conversion-exception-message")

___DEF_MOD_SYM(84,___S_cfun_2d_conversion_2d_exception_2d_procedure,"cfun-conversion-exception-procedure")

___DEF_MOD_SYM(85,___S_cfun_2d_conversion_2d_exception_3f_,"cfun-conversion-exception?")
___DEF_MOD_SYM(86,___S_char_2d__3e_integer,"char->integer")
___DEF_MOD_SYM(87,___S_char_2d_alphabetic_3f_,"char-alphabetic?")
___DEF_MOD_SYM(88,___S_char_2d_ci_3c__3d__3f_,"char-ci<=?")
___DEF_MOD_SYM(89,___S_char_2d_ci_3c__3f_,"char-ci<?")
___DEF_MOD_SYM(90,___S_char_2d_ci_3d__3f_,"char-ci=?")
___DEF_MOD_SYM(91,___S_char_2d_ci_3e__3d__3f_,"char-ci>=?")
___DEF_MOD_SYM(92,___S_char_2d_ci_3e__3f_,"char-ci>?")
___DEF_MOD_SYM(93,___S_char_2d_downcase,"char-downcase")
___DEF_MOD_SYM(94,___S_char_2d_lower_2d_case_3f_,"char-lower-case?")
___DEF_MOD_SYM(95,___S_char_2d_numeric_3f_,"char-numeric?")
___DEF_MOD_SYM(96,___S_char_2d_ready_3f_,"char-ready?")
___DEF_MOD_SYM(97,___S_char_2d_upcase,"char-upcase")
___DEF_MOD_SYM(98,___S_char_2d_upper_2d_case_3f_,"char-upper-case?")
___DEF_MOD_SYM(99,___S_char_2d_whitespace_3f_,"char-whitespace?")
___DEF_MOD_SYM(100,___S_char_3c__3d__3f_,"char<=?")
___DEF_MOD_SYM(101,___S_char_3c__3f_,"char<?")
___DEF_MOD_SYM(102,___S_char_3d__3f_,"char=?")
___DEF_MOD_SYM(103,___S_char_3e__3d__3f_,"char>=?")
___DEF_MOD_SYM(104,___S_char_3e__3f_,"char>?")
___DEF_MOD_SYM(105,___S_char_3f_,"char?")
___DEF_MOD_SYM(106,___S_clear_2d_bit_2d_field,"clear-bit-field")
___DEF_MOD_SYM(107,___S_close_2d_input_2d_port,"close-input-port")
___DEF_MOD_SYM(108,___S_close_2d_output_2d_port,"close-output-port")
___DEF_MOD_SYM(109,___S_close_2d_port,"close-port")
___DEF_MOD_SYM(110,___S_command_2d_line,"command-line")
___DEF_MOD_SYM(111,___S_compile_2d_file,"compile-file")
___DEF_MOD_SYM(112,___S_compile_2d_file_2d_to_2d_c,"compile-file-to-c")
___DEF_MOD_SYM(113,___S_complex_3f_,"complex?")
___DEF_MOD_SYM(114,___S_cond,"cond")
___DEF_MOD_SYM(115,___S_cond_2d_expand,"cond-expand")
___DEF_MOD_SYM(116,___S_condition_2d_variable_2d_broadcast_21_,"condition-variable-broadcast!")

___DEF_MOD_SYM(117,___S_condition_2d_variable_2d_name,"condition-variable-name")
___DEF_MOD_SYM(118,___S_condition_2d_variable_2d_signal_21_,"condition-variable-signal!")
___DEF_MOD_SYM(119,___S_condition_2d_variable_2d_specific,"condition-variable-specific")
___DEF_MOD_SYM(120,___S_condition_2d_variable_2d_specific_2d_set_21_,"condition-variable-specific-set!")

___DEF_MOD_SYM(121,___S_condition_2d_variable_3f_,"condition-variable?")
___DEF_MOD_SYM(122,___S_configure_2d_command_2d_string,"configure-command-string")
___DEF_MOD_SYM(123,___S_cons,"cons")
___DEF_MOD_SYM(124,___S_console_2d_port,"console-port")
___DEF_MOD_SYM(125,___S_continuation_2d_capture,"continuation-capture")
___DEF_MOD_SYM(126,___S_continuation_2d_graft,"continuation-graft")
___DEF_MOD_SYM(127,___S_continuation_2d_return,"continuation-return")
___DEF_MOD_SYM(128,___S_continuation_3f_,"continuation?")
___DEF_MOD_SYM(129,___S_copy_2d_bit_2d_field,"copy-bit-field")
___DEF_MOD_SYM(130,___S_copy_2d_file,"copy-file")
___DEF_MOD_SYM(131,___S_cos,"cos")
___DEF_MOD_SYM(132,___S_cpu_2d_time,"cpu-time")
___DEF_MOD_SYM(133,___S_create_2d_directory,"create-directory")
___DEF_MOD_SYM(134,___S_create_2d_fifo,"create-fifo")
___DEF_MOD_SYM(135,___S_create_2d_link,"create-link")
___DEF_MOD_SYM(136,___S_create_2d_symbolic_2d_link,"create-symbolic-link")
___DEF_MOD_SYM(137,___S_current_2d_directory,"current-directory")
___DEF_MOD_SYM(138,___S_current_2d_error_2d_port,"current-error-port")
___DEF_MOD_SYM(139,___S_current_2d_exception_2d_handler,"current-exception-handler")
___DEF_MOD_SYM(140,___S_current_2d_input_2d_port,"current-input-port")
___DEF_MOD_SYM(141,___S_current_2d_output_2d_port,"current-output-port")
___DEF_MOD_SYM(142,___S_current_2d_readtable,"current-readtable")
___DEF_MOD_SYM(143,___S_current_2d_thread,"current-thread")
___DEF_MOD_SYM(144,___S_current_2d_time,"current-time")
___DEF_MOD_SYM(145,___S_current_2d_user_2d_interrupt_2d_handler,"current-user-interrupt-handler")

___DEF_MOD_SYM(146,___S_datum_2d_parsing_2d_exception_2d_kind,"datum-parsing-exception-kind")
___DEF_MOD_SYM(147,___S_datum_2d_parsing_2d_exception_2d_parameters,"datum-parsing-exception-parameters")

___DEF_MOD_SYM(148,___S_datum_2d_parsing_2d_exception_2d_readenv,"datum-parsing-exception-readenv")

___DEF_MOD_SYM(149,___S_datum_2d_parsing_2d_exception_3f_,"datum-parsing-exception?")
___DEF_MOD_SYM(150,___S_deadlock_2d_exception_3f_,"deadlock-exception?")
___DEF_MOD_SYM(151,___S_declare,"declare")
___DEF_MOD_SYM(152,___S_default_2d_random_2d_source,"default-random-source")
___DEF_MOD_SYM(153,___S_defer_2d_user_2d_interrupts,"defer-user-interrupts")
___DEF_MOD_SYM(154,___S_define,"define")
___DEF_MOD_SYM(155,___S_define_2d_cond_2d_expand_2d_feature,"define-cond-expand-feature")
___DEF_MOD_SYM(156,___S_define_2d_macro,"define-macro")
___DEF_MOD_SYM(157,___S_define_2d_record_2d_type,"define-record-type")
___DEF_MOD_SYM(158,___S_define_2d_structure,"define-structure")
___DEF_MOD_SYM(159,___S_define_2d_syntax,"define-syntax")
___DEF_MOD_SYM(160,___S_define_2d_type,"define-type")
___DEF_MOD_SYM(161,___S_define_2d_type_2d_of_2d_thread,"define-type-of-thread")
___DEF_MOD_SYM(162,___S_delay,"delay")
___DEF_MOD_SYM(163,___S_delete_2d_directory,"delete-directory")
___DEF_MOD_SYM(164,___S_delete_2d_file,"delete-file")
___DEF_MOD_SYM(165,___S_denominator,"denominator")
___DEF_MOD_SYM(166,___S_directory_2d_files,"directory-files")
___DEF_MOD_SYM(167,___S_display,"display")
___DEF_MOD_SYM(168,___S_display_2d_continuation_2d_backtrace,"display-continuation-backtrace")

___DEF_MOD_SYM(169,___S_display_2d_continuation_2d_dynamic_2d_environment,"display-continuation-dynamic-environment")

___DEF_MOD_SYM(170,___S_display_2d_continuation_2d_environment,"display-continuation-environment")

___DEF_MOD_SYM(171,___S_display_2d_dynamic_2d_environment_3f_,"display-dynamic-environment?")
___DEF_MOD_SYM(172,___S_display_2d_environment_2d_set_21_,"display-environment-set!")
___DEF_MOD_SYM(173,___S_display_2d_exception,"display-exception")
___DEF_MOD_SYM(174,___S_display_2d_exception_2d_in_2d_context,"display-exception-in-context")
___DEF_MOD_SYM(175,___S_display_2d_procedure_2d_environment,"display-procedure-environment")

___DEF_MOD_SYM(176,___S_divide_2d_by_2d_zero_2d_exception_2d_arguments,"divide-by-zero-exception-arguments")

___DEF_MOD_SYM(177,___S_divide_2d_by_2d_zero_2d_exception_2d_procedure,"divide-by-zero-exception-procedure")

___DEF_MOD_SYM(178,___S_divide_2d_by_2d_zero_2d_exception_3f_,"divide-by-zero-exception?")
___DEF_MOD_SYM(179,___S_do,"do")
___DEF_MOD_SYM(180,___S_dynamic_2d_wind,"dynamic-wind")
___DEF_MOD_SYM(181,___S_eof_2d_object_3f_,"eof-object?")
___DEF_MOD_SYM(182,___S_eq_3f_,"eq?")
___DEF_MOD_SYM(183,___S_eq_3f__2d_hash,"eq?-hash")
___DEF_MOD_SYM(184,___S_equal_3f_,"equal?")
___DEF_MOD_SYM(185,___S_equal_3f__2d_hash,"equal?-hash")
___DEF_MOD_SYM(186,___S_eqv_3f_,"eqv?")
___DEF_MOD_SYM(187,___S_eqv_3f__2d_hash,"eqv?-hash")
___DEF_MOD_SYM(188,___S_err_2d_code_2d__3e_string,"err-code->string")
___DEF_MOD_SYM(189,___S_error,"error")
___DEF_MOD_SYM(190,___S_error_2d_exception_2d_message,"error-exception-message")
___DEF_MOD_SYM(191,___S_error_2d_exception_2d_parameters,"error-exception-parameters")
___DEF_MOD_SYM(192,___S_error_2d_exception_3f_,"error-exception?")
___DEF_MOD_SYM(193,___S_eval,"eval")
___DEF_MOD_SYM(194,___S_even_3f_,"even?")
___DEF_MOD_SYM(195,___S_exact_2d__3e_inexact,"exact->inexact")
___DEF_MOD_SYM(196,___S_exact_3f_,"exact?")
___DEF_MOD_SYM(197,___S_exit,"exit")
___DEF_MOD_SYM(198,___S_exp,"exp")
___DEF_MOD_SYM(199,___S_expression_2d_parsing_2d_exception_2d_kind,"expression-parsing-exception-kind")

___DEF_MOD_SYM(200,___S_expression_2d_parsing_2d_exception_2d_parameters,"expression-parsing-exception-parameters")

___DEF_MOD_SYM(201,___S_expression_2d_parsing_2d_exception_2d_source,"expression-parsing-exception-source")

___DEF_MOD_SYM(202,___S_expression_2d_parsing_2d_exception_3f_,"expression-parsing-exception?")

___DEF_MOD_SYM(203,___S_expt,"expt")
___DEF_MOD_SYM(204,___S_extract_2d_bit_2d_field,"extract-bit-field")
___DEF_MOD_SYM(205,___S_f32vector,"f32vector")
___DEF_MOD_SYM(206,___S_f32vector_2d__3e_list,"f32vector->list")
___DEF_MOD_SYM(207,___S_f32vector_2d_append,"f32vector-append")
___DEF_MOD_SYM(208,___S_f32vector_2d_copy,"f32vector-copy")
___DEF_MOD_SYM(209,___S_f32vector_2d_fill_21_,"f32vector-fill!")
___DEF_MOD_SYM(210,___S_f32vector_2d_length,"f32vector-length")
___DEF_MOD_SYM(211,___S_f32vector_2d_ref,"f32vector-ref")
___DEF_MOD_SYM(212,___S_f32vector_2d_set_21_,"f32vector-set!")
___DEF_MOD_SYM(213,___S_f32vector_2d_shrink_21_,"f32vector-shrink!")
___DEF_MOD_SYM(214,___S_f32vector_3f_,"f32vector?")
___DEF_MOD_SYM(215,___S_f64vector,"f64vector")
___DEF_MOD_SYM(216,___S_f64vector_2d__3e_list,"f64vector->list")
___DEF_MOD_SYM(217,___S_f64vector_2d_append,"f64vector-append")
___DEF_MOD_SYM(218,___S_f64vector_2d_copy,"f64vector-copy")
___DEF_MOD_SYM(219,___S_f64vector_2d_fill_21_,"f64vector-fill!")
___DEF_MOD_SYM(220,___S_f64vector_2d_length,"f64vector-length")
___DEF_MOD_SYM(221,___S_f64vector_2d_ref,"f64vector-ref")
___DEF_MOD_SYM(222,___S_f64vector_2d_set_21_,"f64vector-set!")
___DEF_MOD_SYM(223,___S_f64vector_2d_shrink_21_,"f64vector-shrink!")
___DEF_MOD_SYM(224,___S_f64vector_3f_,"f64vector?")
___DEF_MOD_SYM(225,___S_file_2d_attributes,"file-attributes")
___DEF_MOD_SYM(226,___S_file_2d_creation_2d_time,"file-creation-time")
___DEF_MOD_SYM(227,___S_file_2d_device,"file-device")
___DEF_MOD_SYM(228,___S_file_2d_exists_3f_,"file-exists?")
___DEF_MOD_SYM(229,___S_file_2d_group,"file-group")
___DEF_MOD_SYM(230,___S_file_2d_info,"file-info")
___DEF_MOD_SYM(231,___S_file_2d_info_2d_attributes,"file-info-attributes")
___DEF_MOD_SYM(232,___S_file_2d_info_2d_creation_2d_time,"file-info-creation-time")
___DEF_MOD_SYM(233,___S_file_2d_info_2d_device,"file-info-device")
___DEF_MOD_SYM(234,___S_file_2d_info_2d_group,"file-info-group")
___DEF_MOD_SYM(235,___S_file_2d_info_2d_inode,"file-info-inode")
___DEF_MOD_SYM(236,___S_file_2d_info_2d_last_2d_access_2d_time,"file-info-last-access-time")
___DEF_MOD_SYM(237,___S_file_2d_info_2d_last_2d_change_2d_time,"file-info-last-change-time")
___DEF_MOD_SYM(238,___S_file_2d_info_2d_last_2d_modification_2d_time,"file-info-last-modification-time")

___DEF_MOD_SYM(239,___S_file_2d_info_2d_mode,"file-info-mode")
___DEF_MOD_SYM(240,___S_file_2d_info_2d_number_2d_of_2d_links,"file-info-number-of-links")
___DEF_MOD_SYM(241,___S_file_2d_info_2d_owner,"file-info-owner")
___DEF_MOD_SYM(242,___S_file_2d_info_2d_size,"file-info-size")
___DEF_MOD_SYM(243,___S_file_2d_info_2d_type,"file-info-type")
___DEF_MOD_SYM(244,___S_file_2d_info_3f_,"file-info?")
___DEF_MOD_SYM(245,___S_file_2d_inode,"file-inode")
___DEF_MOD_SYM(246,___S_file_2d_last_2d_access_2d_time,"file-last-access-time")
___DEF_MOD_SYM(247,___S_file_2d_last_2d_change_2d_time,"file-last-change-time")
___DEF_MOD_SYM(248,___S_file_2d_last_2d_modification_2d_time,"file-last-modification-time")
___DEF_MOD_SYM(249,___S_file_2d_mode,"file-mode")
___DEF_MOD_SYM(250,___S_file_2d_number_2d_of_2d_links,"file-number-of-links")
___DEF_MOD_SYM(251,___S_file_2d_owner,"file-owner")
___DEF_MOD_SYM(252,___S_file_2d_size,"file-size")
___DEF_MOD_SYM(253,___S_file_2d_type,"file-type")
___DEF_MOD_SYM(254,___S_finite_3f_,"finite?")
___DEF_MOD_SYM(255,___S_first_2d_bit_2d_set,"first-bit-set")
___DEF_MOD_SYM(256,___S_fixnum_2d__3e_flonum,"fixnum->flonum")
___DEF_MOD_SYM(257,___S_fixnum_2d_overflow_2d_exception_2d_arguments,"fixnum-overflow-exception-arguments")

___DEF_MOD_SYM(258,___S_fixnum_2d_overflow_2d_exception_2d_procedure,"fixnum-overflow-exception-procedure")

___DEF_MOD_SYM(259,___S_fixnum_2d_overflow_2d_exception_3f_,"fixnum-overflow-exception?")
___DEF_MOD_SYM(260,___S_fixnum_3f_,"fixnum?")
___DEF_MOD_SYM(261,___S_fl_2a_,"fl*")
___DEF_MOD_SYM(262,___S_fl_2b_,"fl+")
___DEF_MOD_SYM(263,___S_fl_2d_,"fl-")
___DEF_MOD_SYM(264,___S_fl_2f_,"fl/")
___DEF_MOD_SYM(265,___S_fl_3c_,"fl<")
___DEF_MOD_SYM(266,___S_fl_3c__3d_,"fl<=")
___DEF_MOD_SYM(267,___S_fl_3d_,"fl=")
___DEF_MOD_SYM(268,___S_fl_3e_,"fl>")
___DEF_MOD_SYM(269,___S_fl_3e__3d_,"fl>=")
___DEF_MOD_SYM(270,___S_flabs,"flabs")
___DEF_MOD_SYM(271,___S_flacos,"flacos")
___DEF_MOD_SYM(272,___S_flasin,"flasin")
___DEF_MOD_SYM(273,___S_flatan,"flatan")
___DEF_MOD_SYM(274,___S_flceiling,"flceiling")
___DEF_MOD_SYM(275,___S_flcos,"flcos")
___DEF_MOD_SYM(276,___S_fldenominator,"fldenominator")
___DEF_MOD_SYM(277,___S_fleven_3f_,"fleven?")
___DEF_MOD_SYM(278,___S_flexp,"flexp")
___DEF_MOD_SYM(279,___S_flexpt,"flexpt")
___DEF_MOD_SYM(280,___S_flfinite_3f_,"flfinite?")
___DEF_MOD_SYM(281,___S_flfloor,"flfloor")
___DEF_MOD_SYM(282,___S_flinfinite_3f_,"flinfinite?")
___DEF_MOD_SYM(283,___S_flinteger_3f_,"flinteger?")
___DEF_MOD_SYM(284,___S_fllog,"fllog")
___DEF_MOD_SYM(285,___S_flmax,"flmax")
___DEF_MOD_SYM(286,___S_flmin,"flmin")
___DEF_MOD_SYM(287,___S_flnan_3f_,"flnan?")
___DEF_MOD_SYM(288,___S_flnegative_3f_,"flnegative?")
___DEF_MOD_SYM(289,___S_flnumerator,"flnumerator")
___DEF_MOD_SYM(290,___S_flodd_3f_,"flodd?")
___DEF_MOD_SYM(291,___S_flonum_3f_,"flonum?")
___DEF_MOD_SYM(292,___S_floor,"floor")
___DEF_MOD_SYM(293,___S_flpositive_3f_,"flpositive?")
___DEF_MOD_SYM(294,___S_flround,"flround")
___DEF_MOD_SYM(295,___S_flsin,"flsin")
___DEF_MOD_SYM(296,___S_flsqrt,"flsqrt")
___DEF_MOD_SYM(297,___S_fltan,"fltan")
___DEF_MOD_SYM(298,___S_fltruncate,"fltruncate")
___DEF_MOD_SYM(299,___S_flzero_3f_,"flzero?")
___DEF_MOD_SYM(300,___S_for_2d_each,"for-each")
___DEF_MOD_SYM(301,___S_force,"force")
___DEF_MOD_SYM(302,___S_force_2d_output,"force-output")
___DEF_MOD_SYM(303,___S_foreign_2d_address,"foreign-address")
___DEF_MOD_SYM(304,___S_foreign_2d_release_21_,"foreign-release!")
___DEF_MOD_SYM(305,___S_foreign_2d_released_3f_,"foreign-released?")
___DEF_MOD_SYM(306,___S_foreign_2d_tags,"foreign-tags")
___DEF_MOD_SYM(307,___S_foreign_3f_,"foreign?")
___DEF_MOD_SYM(308,___S_future,"future")
___DEF_MOD_SYM(309,___S_fx_2a_,"fx*")
___DEF_MOD_SYM(310,___S_fx_2b_,"fx+")
___DEF_MOD_SYM(311,___S_fx_2d_,"fx-")
___DEF_MOD_SYM(312,___S_fx_3c_,"fx<")
___DEF_MOD_SYM(313,___S_fx_3c__3d_,"fx<=")
___DEF_MOD_SYM(314,___S_fx_3d_,"fx=")
___DEF_MOD_SYM(315,___S_fx_3e_,"fx>")
___DEF_MOD_SYM(316,___S_fx_3e__3d_,"fx>=")
___DEF_MOD_SYM(317,___S_fxabs,"fxabs")
___DEF_MOD_SYM(318,___S_fxand,"fxand")
___DEF_MOD_SYM(319,___S_fxarithmetic_2d_shift,"fxarithmetic-shift")
___DEF_MOD_SYM(320,___S_fxarithmetic_2d_shift_2d_left,"fxarithmetic-shift-left")
___DEF_MOD_SYM(321,___S_fxarithmetic_2d_shift_2d_right,"fxarithmetic-shift-right")
___DEF_MOD_SYM(322,___S_fxbit_2d_count,"fxbit-count")
___DEF_MOD_SYM(323,___S_fxbit_2d_set_3f_,"fxbit-set?")
___DEF_MOD_SYM(324,___S_fxeven_3f_,"fxeven?")
___DEF_MOD_SYM(325,___S_fxfirst_2d_bit_2d_set,"fxfirst-bit-set")
___DEF_MOD_SYM(326,___S_fxif,"fxif")
___DEF_MOD_SYM(327,___S_fxior,"fxior")
___DEF_MOD_SYM(328,___S_fxlength,"fxlength")
___DEF_MOD_SYM(329,___S_fxmax,"fxmax")
___DEF_MOD_SYM(330,___S_fxmin,"fxmin")
___DEF_MOD_SYM(331,___S_fxmodulo,"fxmodulo")
___DEF_MOD_SYM(332,___S_fxnegative_3f_,"fxnegative?")
___DEF_MOD_SYM(333,___S_fxnot,"fxnot")
___DEF_MOD_SYM(334,___S_fxodd_3f_,"fxodd?")
___DEF_MOD_SYM(335,___S_fxpositive_3f_,"fxpositive?")
___DEF_MOD_SYM(336,___S_fxquotient,"fxquotient")
___DEF_MOD_SYM(337,___S_fxremainder,"fxremainder")
___DEF_MOD_SYM(338,___S_fxwrap_2a_,"fxwrap*")
___DEF_MOD_SYM(339,___S_fxwrap_2b_,"fxwrap+")
___DEF_MOD_SYM(340,___S_fxwrap_2d_,"fxwrap-")
___DEF_MOD_SYM(341,___S_fxwrapabs,"fxwrapabs")
___DEF_MOD_SYM(342,___S_fxwraparithmetic_2d_shift,"fxwraparithmetic-shift")
___DEF_MOD_SYM(343,___S_fxwraparithmetic_2d_shift_2d_left,"fxwraparithmetic-shift-left")
___DEF_MOD_SYM(344,___S_fxwraplogical_2d_shift_2d_right,"fxwraplogical-shift-right")
___DEF_MOD_SYM(345,___S_fxwrapquotient,"fxwrapquotient")
___DEF_MOD_SYM(346,___S_fxxor,"fxxor")
___DEF_MOD_SYM(347,___S_fxzero_3f_,"fxzero?")
___DEF_MOD_SYM(348,___S_gc_2d_report_2d_set_21_,"gc-report-set!")
___DEF_MOD_SYM(349,___S_gcd,"gcd")
___DEF_MOD_SYM(350,___S_generate_2d_proper_2d_tail_2d_calls,"generate-proper-tail-calls")
___DEF_MOD_SYM(351,___S_gensym,"gensym")
___DEF_MOD_SYM(352,___S_get_2d_output_2d_string,"get-output-string")
___DEF_MOD_SYM(353,___S_get_2d_output_2d_u8vector,"get-output-u8vector")
___DEF_MOD_SYM(354,___S_get_2d_output_2d_vector,"get-output-vector")
___DEF_MOD_SYM(355,___S_getenv,"getenv")
___DEF_MOD_SYM(356,___S_group_2d_info,"group-info")
___DEF_MOD_SYM(357,___S_group_2d_info_2d_gid,"group-info-gid")
___DEF_MOD_SYM(358,___S_group_2d_info_2d_members,"group-info-members")
___DEF_MOD_SYM(359,___S_group_2d_info_2d_name,"group-info-name")
___DEF_MOD_SYM(360,___S_group_2d_info_3f_,"group-info?")
___DEF_MOD_SYM(361,___S_heap_2d_overflow_2d_exception_3f_,"heap-overflow-exception?")
___DEF_MOD_SYM(362,___S_help,"help")
___DEF_MOD_SYM(363,___S_help_2d_browser,"help-browser")
___DEF_MOD_SYM(364,___S_host_2d_info,"host-info")
___DEF_MOD_SYM(365,___S_host_2d_info_2d_addresses,"host-info-addresses")
___DEF_MOD_SYM(366,___S_host_2d_info_2d_aliases,"host-info-aliases")
___DEF_MOD_SYM(367,___S_host_2d_info_2d_name,"host-info-name")
___DEF_MOD_SYM(368,___S_host_2d_info_3f_,"host-info?")
___DEF_MOD_SYM(369,___S_host_2d_name,"host-name")
___DEF_MOD_SYM(370,___S_if,"if")
___DEF_MOD_SYM(371,___S_imag_2d_part,"imag-part")
___DEF_MOD_SYM(372,___S_improper_2d_length_2d_list_2d_exception_2d_arg_2d_num,"improper-length-list-exception-arg-num")

___DEF_MOD_SYM(373,___S_improper_2d_length_2d_list_2d_exception_2d_arguments,"improper-length-list-exception-arguments")

___DEF_MOD_SYM(374,___S_improper_2d_length_2d_list_2d_exception_2d_procedure,"improper-length-list-exception-procedure")

___DEF_MOD_SYM(375,___S_improper_2d_length_2d_list_2d_exception_3f_,"improper-length-list-exception?")

___DEF_MOD_SYM(376,___S_inactive_2d_thread_2d_exception_2d_arguments,"inactive-thread-exception-arguments")

___DEF_MOD_SYM(377,___S_inactive_2d_thread_2d_exception_2d_procedure,"inactive-thread-exception-procedure")

___DEF_MOD_SYM(378,___S_inactive_2d_thread_2d_exception_3f_,"inactive-thread-exception?")
___DEF_MOD_SYM(379,___S_include,"include")
___DEF_MOD_SYM(380,___S_inexact_2d__3e_exact,"inexact->exact")
___DEF_MOD_SYM(381,___S_inexact_3f_,"inexact?")
___DEF_MOD_SYM(382,___S_infinite_3f_,"infinite?")
___DEF_MOD_SYM(383,___S_initialized_2d_thread_2d_exception_2d_arguments,"initialized-thread-exception-arguments")

___DEF_MOD_SYM(384,___S_initialized_2d_thread_2d_exception_2d_procedure,"initialized-thread-exception-procedure")

___DEF_MOD_SYM(385,___S_initialized_2d_thread_2d_exception_3f_,"initialized-thread-exception?")

___DEF_MOD_SYM(386,___S_input_2d_port_2d_byte_2d_position,"input-port-byte-position")
___DEF_MOD_SYM(387,___S_input_2d_port_2d_bytes_2d_buffered,"input-port-bytes-buffered")
___DEF_MOD_SYM(388,___S_input_2d_port_2d_char_2d_position,"input-port-char-position")
___DEF_MOD_SYM(389,___S_input_2d_port_2d_characters_2d_buffered,"input-port-characters-buffered")

___DEF_MOD_SYM(390,___S_input_2d_port_2d_column,"input-port-column")
___DEF_MOD_SYM(391,___S_input_2d_port_2d_line,"input-port-line")
___DEF_MOD_SYM(392,___S_input_2d_port_2d_readtable,"input-port-readtable")
___DEF_MOD_SYM(393,___S_input_2d_port_2d_readtable_2d_set_21_,"input-port-readtable-set!")
___DEF_MOD_SYM(394,___S_input_2d_port_2d_timeout_2d_set_21_,"input-port-timeout-set!")
___DEF_MOD_SYM(395,___S_input_2d_port_3f_,"input-port?")
___DEF_MOD_SYM(396,___S_integer_2d__3e_char,"integer->char")
___DEF_MOD_SYM(397,___S_integer_2d_length,"integer-length")
___DEF_MOD_SYM(398,___S_integer_2d_nth_2d_root,"integer-nth-root")
___DEF_MOD_SYM(399,___S_integer_2d_sqrt,"integer-sqrt")
___DEF_MOD_SYM(400,___S_integer_3f_,"integer?")
___DEF_MOD_SYM(401,___S_interaction_2d_environment,"interaction-environment")
___DEF_MOD_SYM(402,___S_invalid_2d_hash_2d_number_2d_exception_2d_arguments,"invalid-hash-number-exception-arguments")

___DEF_MOD_SYM(403,___S_invalid_2d_hash_2d_number_2d_exception_2d_procedure,"invalid-hash-number-exception-procedure")

___DEF_MOD_SYM(404,___S_invalid_2d_hash_2d_number_2d_exception_3f_,"invalid-hash-number-exception?")

___DEF_MOD_SYM(405,___S_join_2d_timeout_2d_exception_2d_arguments,"join-timeout-exception-arguments")

___DEF_MOD_SYM(406,___S_join_2d_timeout_2d_exception_2d_procedure,"join-timeout-exception-procedure")

___DEF_MOD_SYM(407,___S_join_2d_timeout_2d_exception_3f_,"join-timeout-exception?")
___DEF_MOD_SYM(408,___S_keyword_2d__3e_string,"keyword->string")
___DEF_MOD_SYM(409,___S_keyword_2d_expected_2d_exception_2d_arguments,"keyword-expected-exception-arguments")

___DEF_MOD_SYM(410,___S_keyword_2d_expected_2d_exception_2d_procedure,"keyword-expected-exception-procedure")

___DEF_MOD_SYM(411,___S_keyword_2d_expected_2d_exception_3f_,"keyword-expected-exception?")
___DEF_MOD_SYM(412,___S_keyword_2d_hash,"keyword-hash")
___DEF_MOD_SYM(413,___S_keyword_3f_,"keyword?")
___DEF_MOD_SYM(414,___S_lambda,"lambda")
___DEF_MOD_SYM(415,___S_lcm,"lcm")
___DEF_MOD_SYM(416,___S_length,"length")
___DEF_MOD_SYM(417,___S_let,"let")
___DEF_MOD_SYM(418,___S_let_2a_,"let*")
___DEF_MOD_SYM(419,___S_let_2d_syntax,"let-syntax")
___DEF_MOD_SYM(420,___S_letrec,"letrec")
___DEF_MOD_SYM(421,___S_letrec_2d_syntax,"letrec-syntax")
___DEF_MOD_SYM(422,___S_link_2d_flat,"link-flat")
___DEF_MOD_SYM(423,___S_link_2d_incremental,"link-incremental")
___DEF_MOD_SYM(424,___S_list,"list")
___DEF_MOD_SYM(425,___S_list_2d__3e_f32vector,"list->f32vector")
___DEF_MOD_SYM(426,___S_list_2d__3e_f64vector,"list->f64vector")
___DEF_MOD_SYM(427,___S_list_2d__3e_s16vector,"list->s16vector")
___DEF_MOD_SYM(428,___S_list_2d__3e_s32vector,"list->s32vector")
___DEF_MOD_SYM(429,___S_list_2d__3e_s64vector,"list->s64vector")
___DEF_MOD_SYM(430,___S_list_2d__3e_s8vector,"list->s8vector")
___DEF_MOD_SYM(431,___S_list_2d__3e_string,"list->string")
___DEF_MOD_SYM(432,___S_list_2d__3e_table,"list->table")
___DEF_MOD_SYM(433,___S_list_2d__3e_u16vector,"list->u16vector")
___DEF_MOD_SYM(434,___S_list_2d__3e_u32vector,"list->u32vector")
___DEF_MOD_SYM(435,___S_list_2d__3e_u64vector,"list->u64vector")
___DEF_MOD_SYM(436,___S_list_2d__3e_u8vector,"list->u8vector")
___DEF_MOD_SYM(437,___S_list_2d__3e_vector,"list->vector")
___DEF_MOD_SYM(438,___S_list_2d_ref,"list-ref")
___DEF_MOD_SYM(439,___S_list_2d_tail,"list-tail")
___DEF_MOD_SYM(440,___S_list_3f_,"list?")
___DEF_MOD_SYM(441,___S_load,"load")
___DEF_MOD_SYM(442,___S_log,"log")
___DEF_MOD_SYM(443,___S_magnitude,"magnitude")
___DEF_MOD_SYM(444,___S_mailbox_2d_receive_2d_timeout_2d_exception_2d_arguments,"mailbox-receive-timeout-exception-arguments")

___DEF_MOD_SYM(445,___S_mailbox_2d_receive_2d_timeout_2d_exception_2d_procedure,"mailbox-receive-timeout-exception-procedure")

___DEF_MOD_SYM(446,___S_mailbox_2d_receive_2d_timeout_2d_exception_3f_,"mailbox-receive-timeout-exception?")

___DEF_MOD_SYM(447,___S_main,"main")
___DEF_MOD_SYM(448,___S_make_2d_condition_2d_variable,"make-condition-variable")
___DEF_MOD_SYM(449,___S_make_2d_f32vector,"make-f32vector")
___DEF_MOD_SYM(450,___S_make_2d_f64vector,"make-f64vector")
___DEF_MOD_SYM(451,___S_make_2d_mutex,"make-mutex")
___DEF_MOD_SYM(452,___S_make_2d_parameter,"make-parameter")
___DEF_MOD_SYM(453,___S_make_2d_polar,"make-polar")
___DEF_MOD_SYM(454,___S_make_2d_random_2d_source,"make-random-source")
___DEF_MOD_SYM(455,___S_make_2d_rectangular,"make-rectangular")
___DEF_MOD_SYM(456,___S_make_2d_root_2d_thread,"make-root-thread")
___DEF_MOD_SYM(457,___S_make_2d_s16vector,"make-s16vector")
___DEF_MOD_SYM(458,___S_make_2d_s32vector,"make-s32vector")
___DEF_MOD_SYM(459,___S_make_2d_s64vector,"make-s64vector")
___DEF_MOD_SYM(460,___S_make_2d_s8vector,"make-s8vector")
___DEF_MOD_SYM(461,___S_make_2d_string,"make-string")
___DEF_MOD_SYM(462,___S_make_2d_table,"make-table")
___DEF_MOD_SYM(463,___S_make_2d_thread,"make-thread")
___DEF_MOD_SYM(464,___S_make_2d_thread_2d_group,"make-thread-group")
___DEF_MOD_SYM(465,___S_make_2d_u16vector,"make-u16vector")
___DEF_MOD_SYM(466,___S_make_2d_u32vector,"make-u32vector")
___DEF_MOD_SYM(467,___S_make_2d_u64vector,"make-u64vector")
___DEF_MOD_SYM(468,___S_make_2d_u8vector,"make-u8vector")
___DEF_MOD_SYM(469,___S_make_2d_uninterned_2d_keyword,"make-uninterned-keyword")
___DEF_MOD_SYM(470,___S_make_2d_uninterned_2d_symbol,"make-uninterned-symbol")
___DEF_MOD_SYM(471,___S_make_2d_vector,"make-vector")
___DEF_MOD_SYM(472,___S_make_2d_will,"make-will")
___DEF_MOD_SYM(473,___S_map,"map")
___DEF_MOD_SYM(474,___S_max,"max")
___DEF_MOD_SYM(475,___S_member,"member")
___DEF_MOD_SYM(476,___S_memq,"memq")
___DEF_MOD_SYM(477,___S_memv,"memv")
___DEF_MOD_SYM(478,___S_min,"min")
___DEF_MOD_SYM(479,___S_modulo,"modulo")
___DEF_MOD_SYM(480,___S_multiple_2d_c_2d_return_2d_exception_3f_,"multiple-c-return-exception?")
___DEF_MOD_SYM(481,___S_mutex_2d_lock_21_,"mutex-lock!")
___DEF_MOD_SYM(482,___S_mutex_2d_name,"mutex-name")
___DEF_MOD_SYM(483,___S_mutex_2d_specific,"mutex-specific")
___DEF_MOD_SYM(484,___S_mutex_2d_specific_2d_set_21_,"mutex-specific-set!")
___DEF_MOD_SYM(485,___S_mutex_2d_state,"mutex-state")
___DEF_MOD_SYM(486,___S_mutex_2d_unlock_21_,"mutex-unlock!")
___DEF_MOD_SYM(487,___S_mutex_3f_,"mutex?")
___DEF_MOD_SYM(488,___S_namespace,"namespace")
___DEF_MOD_SYM(489,___S_nan_3f_,"nan?")
___DEF_MOD_SYM(490,___S_negative_3f_,"negative?")
___DEF_MOD_SYM(491,___S_network_2d_info,"network-info")
___DEF_MOD_SYM(492,___S_network_2d_info_2d_aliases,"network-info-aliases")
___DEF_MOD_SYM(493,___S_network_2d_info_2d_name,"network-info-name")
___DEF_MOD_SYM(494,___S_network_2d_info_2d_number,"network-info-number")
___DEF_MOD_SYM(495,___S_network_2d_info_3f_,"network-info?")
___DEF_MOD_SYM(496,___S_newline,"newline")
___DEF_MOD_SYM(497,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_arguments,"no-such-file-or-directory-exception-arguments")

___DEF_MOD_SYM(498,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_2d_procedure,"no-such-file-or-directory-exception-procedure")

___DEF_MOD_SYM(499,___S_no_2d_such_2d_file_2d_or_2d_directory_2d_exception_3f_,"no-such-file-or-directory-exception?")

___DEF_MOD_SYM(500,___S_noncontinuable_2d_exception_2d_reason,"noncontinuable-exception-reason")

___DEF_MOD_SYM(501,___S_noncontinuable_2d_exception_3f_,"noncontinuable-exception?")
___DEF_MOD_SYM(502,___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_2d_arguments,"nonempty-input-port-character-buffer-exception-arguments")

___DEF_MOD_SYM(503,___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_2d_procedure,"nonempty-input-port-character-buffer-exception-procedure")

___DEF_MOD_SYM(504,___S_nonempty_2d_input_2d_port_2d_character_2d_buffer_2d_exception_3f_,"nonempty-input-port-character-buffer-exception?")

___DEF_MOD_SYM(505,___S_nonprocedure_2d_operator_2d_exception_2d_arguments,"nonprocedure-operator-exception-arguments")

___DEF_MOD_SYM(506,___S_nonprocedure_2d_operator_2d_exception_2d_code,"nonprocedure-operator-exception-code")

___DEF_MOD_SYM(507,___S_nonprocedure_2d_operator_2d_exception_2d_operator,"nonprocedure-operator-exception-operator")

___DEF_MOD_SYM(508,___S_nonprocedure_2d_operator_2d_exception_2d_rte,"nonprocedure-operator-exception-rte")

___DEF_MOD_SYM(509,___S_nonprocedure_2d_operator_2d_exception_3f_,"nonprocedure-operator-exception?")

___DEF_MOD_SYM(510,___S_not,"not")
___DEF_MOD_SYM(511,___S_null_2d_environment,"null-environment")
___DEF_MOD_SYM(512,___S_null_3f_,"null?")
___DEF_MOD_SYM(513,___S_number_2d__3e_string,"number->string")
___DEF_MOD_SYM(514,___S_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_arguments,"number-of-arguments-limit-exception-arguments")

___DEF_MOD_SYM(515,___S_number_2d_of_2d_arguments_2d_limit_2d_exception_2d_procedure,"number-of-arguments-limit-exception-procedure")

___DEF_MOD_SYM(516,___S_number_2d_of_2d_arguments_2d_limit_2d_exception_3f_,"number-of-arguments-limit-exception?")

___DEF_MOD_SYM(517,___S_number_3f_,"number?")
___DEF_MOD_SYM(518,___S_numerator,"numerator")
___DEF_MOD_SYM(519,___S_object_2d__3e_serial_2d_number,"object->serial-number")
___DEF_MOD_SYM(520,___S_object_2d__3e_string,"object->string")
___DEF_MOD_SYM(521,___S_object_2d__3e_u8vector,"object->u8vector")
___DEF_MOD_SYM(522,___S_odd_3f_,"odd?")
___DEF_MOD_SYM(523,___S_open_2d_directory,"open-directory")
___DEF_MOD_SYM(524,___S_open_2d_dummy,"open-dummy")
___DEF_MOD_SYM(525,___S_open_2d_event_2d_queue,"open-event-queue")
___DEF_MOD_SYM(526,___S_open_2d_file,"open-file")
___DEF_MOD_SYM(527,___S_open_2d_input_2d_file,"open-input-file")
___DEF_MOD_SYM(528,___S_open_2d_input_2d_process,"open-input-process")
___DEF_MOD_SYM(529,___S_open_2d_input_2d_string,"open-input-string")
___DEF_MOD_SYM(530,___S_open_2d_input_2d_u8vector,"open-input-u8vector")
___DEF_MOD_SYM(531,___S_open_2d_input_2d_vector,"open-input-vector")
___DEF_MOD_SYM(532,___S_open_2d_output_2d_file,"open-output-file")
___DEF_MOD_SYM(533,___S_open_2d_output_2d_process,"open-output-process")
___DEF_MOD_SYM(534,___S_open_2d_output_2d_string,"open-output-string")
___DEF_MOD_SYM(535,___S_open_2d_output_2d_u8vector,"open-output-u8vector")
___DEF_MOD_SYM(536,___S_open_2d_output_2d_vector,"open-output-vector")
___DEF_MOD_SYM(537,___S_open_2d_process,"open-process")
___DEF_MOD_SYM(538,___S_open_2d_string,"open-string")
___DEF_MOD_SYM(539,___S_open_2d_string_2d_pipe,"open-string-pipe")
___DEF_MOD_SYM(540,___S_open_2d_tcp_2d_client,"open-tcp-client")
___DEF_MOD_SYM(541,___S_open_2d_tcp_2d_server,"open-tcp-server")
___DEF_MOD_SYM(542,___S_open_2d_u8vector,"open-u8vector")
___DEF_MOD_SYM(543,___S_open_2d_u8vector_2d_pipe,"open-u8vector-pipe")
___DEF_MOD_SYM(544,___S_open_2d_vector,"open-vector")
___DEF_MOD_SYM(545,___S_open_2d_vector_2d_pipe,"open-vector-pipe")
___DEF_MOD_SYM(546,___S_or,"or")
___DEF_MOD_SYM(547,___S_os_2d_exception_2d_arguments,"os-exception-arguments")
___DEF_MOD_SYM(548,___S_os_2d_exception_2d_code,"os-exception-code")
___DEF_MOD_SYM(549,___S_os_2d_exception_2d_message,"os-exception-message")
___DEF_MOD_SYM(550,___S_os_2d_exception_2d_procedure,"os-exception-procedure")
___DEF_MOD_SYM(551,___S_os_2d_exception_3f_,"os-exception?")
___DEF_MOD_SYM(552,___S_output_2d_port_2d_byte_2d_position,"output-port-byte-position")
___DEF_MOD_SYM(553,___S_output_2d_port_2d_char_2d_position,"output-port-char-position")
___DEF_MOD_SYM(554,___S_output_2d_port_2d_column,"output-port-column")
___DEF_MOD_SYM(555,___S_output_2d_port_2d_line,"output-port-line")
___DEF_MOD_SYM(556,___S_output_2d_port_2d_readtable,"output-port-readtable")
___DEF_MOD_SYM(557,___S_output_2d_port_2d_readtable_2d_set_21_,"output-port-readtable-set!")
___DEF_MOD_SYM(558,___S_output_2d_port_2d_timeout_2d_set_21_,"output-port-timeout-set!")
___DEF_MOD_SYM(559,___S_output_2d_port_2d_width,"output-port-width")
___DEF_MOD_SYM(560,___S_output_2d_port_3f_,"output-port?")
___DEF_MOD_SYM(561,___S_pair_3f_,"pair?")
___DEF_MOD_SYM(562,___S_parameterize,"parameterize")
___DEF_MOD_SYM(563,___S_path_2d_directory,"path-directory")
___DEF_MOD_SYM(564,___S_path_2d_expand,"path-expand")
___DEF_MOD_SYM(565,___S_path_2d_extension,"path-extension")
___DEF_MOD_SYM(566,___S_path_2d_normalize,"path-normalize")
___DEF_MOD_SYM(567,___S_path_2d_strip_2d_directory,"path-strip-directory")
___DEF_MOD_SYM(568,___S_path_2d_strip_2d_extension,"path-strip-extension")
___DEF_MOD_SYM(569,___S_path_2d_strip_2d_trailing_2d_directory_2d_separator,"path-strip-trailing-directory-separator")

___DEF_MOD_SYM(570,___S_path_2d_strip_2d_volume,"path-strip-volume")
___DEF_MOD_SYM(571,___S_path_2d_volume,"path-volume")
___DEF_MOD_SYM(572,___S_peek_2d_char,"peek-char")
___DEF_MOD_SYM(573,___S_port_2d_settings_2d_set_21_,"port-settings-set!")
___DEF_MOD_SYM(574,___S_port_3f_,"port?")
___DEF_MOD_SYM(575,___S_positive_3f_,"positive?")
___DEF_MOD_SYM(576,___S_pp,"pp")
___DEF_MOD_SYM(577,___S_pretty_2d_print,"pretty-print")
___DEF_MOD_SYM(578,___S_primordial_2d_exception_2d_handler,"primordial-exception-handler")
___DEF_MOD_SYM(579,___S_print,"print")
___DEF_MOD_SYM(580,___S_println,"println")
___DEF_MOD_SYM(581,___S_procedure_3f_,"procedure?")
___DEF_MOD_SYM(582,___S_process_2d_pid,"process-pid")
___DEF_MOD_SYM(583,___S_process_2d_status,"process-status")
___DEF_MOD_SYM(584,___S_process_2d_times,"process-times")
___DEF_MOD_SYM(585,___S_protocol_2d_info,"protocol-info")
___DEF_MOD_SYM(586,___S_protocol_2d_info_2d_aliases,"protocol-info-aliases")
___DEF_MOD_SYM(587,___S_protocol_2d_info_2d_name,"protocol-info-name")
___DEF_MOD_SYM(588,___S_protocol_2d_info_2d_number,"protocol-info-number")
___DEF_MOD_SYM(589,___S_protocol_2d_info_3f_,"protocol-info?")
___DEF_MOD_SYM(590,___S_quasiquote,"quasiquote")
___DEF_MOD_SYM(591,___S_quote,"quote")
___DEF_MOD_SYM(592,___S_quotient,"quotient")
___DEF_MOD_SYM(593,___S_raise,"raise")
___DEF_MOD_SYM(594,___S_random_2d_f64vector,"random-f64vector")
___DEF_MOD_SYM(595,___S_random_2d_integer,"random-integer")
___DEF_MOD_SYM(596,___S_random_2d_real,"random-real")
___DEF_MOD_SYM(597,___S_random_2d_source_2d_make_2d_f64vectors,"random-source-make-f64vectors")

___DEF_MOD_SYM(598,___S_random_2d_source_2d_make_2d_integers,"random-source-make-integers")
___DEF_MOD_SYM(599,___S_random_2d_source_2d_make_2d_reals,"random-source-make-reals")
___DEF_MOD_SYM(600,___S_random_2d_source_2d_make_2d_u8vectors,"random-source-make-u8vectors")
___DEF_MOD_SYM(601,___S_random_2d_source_2d_pseudo_2d_randomize_21_,"random-source-pseudo-randomize!")

___DEF_MOD_SYM(602,___S_random_2d_source_2d_randomize_21_,"random-source-randomize!")
___DEF_MOD_SYM(603,___S_random_2d_source_2d_state_2d_ref,"random-source-state-ref")
___DEF_MOD_SYM(604,___S_random_2d_source_2d_state_2d_set_21_,"random-source-state-set!")
___DEF_MOD_SYM(605,___S_random_2d_source_3f_,"random-source?")
___DEF_MOD_SYM(606,___S_random_2d_u8vector,"random-u8vector")
___DEF_MOD_SYM(607,___S_range_2d_exception_2d_arg_2d_num,"range-exception-arg-num")
___DEF_MOD_SYM(608,___S_range_2d_exception_2d_arguments,"range-exception-arguments")
___DEF_MOD_SYM(609,___S_range_2d_exception_2d_procedure,"range-exception-procedure")
___DEF_MOD_SYM(610,___S_range_2d_exception_3f_,"range-exception?")
___DEF_MOD_SYM(611,___S_rational_3f_,"rational?")
___DEF_MOD_SYM(612,___S_rationalize,"rationalize")
___DEF_MOD_SYM(613,___S_read,"read")
___DEF_MOD_SYM(614,___S_read_2d_all,"read-all")
___DEF_MOD_SYM(615,___S_read_2d_char,"read-char")
___DEF_MOD_SYM(616,___S_read_2d_line,"read-line")
___DEF_MOD_SYM(617,___S_read_2d_substring,"read-substring")
___DEF_MOD_SYM(618,___S_read_2d_subu8vector,"read-subu8vector")
___DEF_MOD_SYM(619,___S_read_2d_u8,"read-u8")
___DEF_MOD_SYM(620,___S_readtable_2d_case_2d_conversion_3f_,"readtable-case-conversion?")
___DEF_MOD_SYM(621,___S_readtable_2d_case_2d_conversion_3f__2d_set,"readtable-case-conversion?-set")

___DEF_MOD_SYM(622,___S_readtable_2d_eval_2d_allowed_3f_,"readtable-eval-allowed?")
___DEF_MOD_SYM(623,___S_readtable_2d_eval_2d_allowed_3f__2d_set,"readtable-eval-allowed?-set")
___DEF_MOD_SYM(624,___S_readtable_2d_keywords_2d_allowed_3f_,"readtable-keywords-allowed?")
___DEF_MOD_SYM(625,___S_readtable_2d_keywords_2d_allowed_3f__2d_set,"readtable-keywords-allowed?-set")

___DEF_MOD_SYM(626,___S_readtable_2d_max_2d_unescaped_2d_char,"readtable-max-unescaped-char")
___DEF_MOD_SYM(627,___S_readtable_2d_max_2d_unescaped_2d_char_2d_set,"readtable-max-unescaped-char-set")

___DEF_MOD_SYM(628,___S_readtable_2d_max_2d_write_2d_length,"readtable-max-write-length")
___DEF_MOD_SYM(629,___S_readtable_2d_max_2d_write_2d_length_2d_set,"readtable-max-write-length-set")

___DEF_MOD_SYM(630,___S_readtable_2d_max_2d_write_2d_level,"readtable-max-write-level")
___DEF_MOD_SYM(631,___S_readtable_2d_max_2d_write_2d_level_2d_set,"readtable-max-write-level-set")

___DEF_MOD_SYM(632,___S_readtable_2d_sharing_2d_allowed_3f_,"readtable-sharing-allowed?")
___DEF_MOD_SYM(633,___S_readtable_2d_sharing_2d_allowed_3f__2d_set,"readtable-sharing-allowed?-set")

___DEF_MOD_SYM(634,___S_readtable_2d_start_2d_syntax,"readtable-start-syntax")
___DEF_MOD_SYM(635,___S_readtable_2d_start_2d_syntax_2d_set,"readtable-start-syntax-set")
___DEF_MOD_SYM(636,___S_readtable_2d_write_2d_cdr_2d_read_2d_macros_3f_,"readtable-write-cdr-read-macros?")

___DEF_MOD_SYM(637,___S_readtable_2d_write_2d_cdr_2d_read_2d_macros_3f__2d_set,"readtable-write-cdr-read-macros?-set")

___DEF_MOD_SYM(638,___S_readtable_2d_write_2d_extended_2d_read_2d_macros_3f_,"readtable-write-extended-read-macros?")

___DEF_MOD_SYM(639,___S_readtable_2d_write_2d_extended_2d_read_2d_macros_3f__2d_set,"readtable-write-extended-read-macros?-set")

___DEF_MOD_SYM(640,___S_readtable_3f_,"readtable?")
___DEF_MOD_SYM(641,___S_real_2d_part,"real-part")
___DEF_MOD_SYM(642,___S_real_2d_time,"real-time")
___DEF_MOD_SYM(643,___S_real_3f_,"real?")
___DEF_MOD_SYM(644,___S_receive,"receive")
___DEF_MOD_SYM(645,___S_remainder,"remainder")
___DEF_MOD_SYM(646,___S_rename_2d_file,"rename-file")
___DEF_MOD_SYM(647,___S_repl_2d_display_2d_environment_3f_,"repl-display-environment?")
___DEF_MOD_SYM(648,___S_repl_2d_input_2d_port,"repl-input-port")
___DEF_MOD_SYM(649,___S_repl_2d_output_2d_port,"repl-output-port")
___DEF_MOD_SYM(650,___S_repl_2d_result_2d_history_2d_max_2d_length_2d_set_21_,"repl-result-history-max-length-set!")

___DEF_MOD_SYM(651,___S_repl_2d_result_2d_history_2d_ref,"repl-result-history-ref")
___DEF_MOD_SYM(652,___S_replace_2d_bit_2d_field,"replace-bit-field")
___DEF_MOD_SYM(653,___S_reverse,"reverse")
___DEF_MOD_SYM(654,___S_round,"round")
___DEF_MOD_SYM(655,___S_rpc_2d_remote_2d_error_2d_exception_2d_arguments,"rpc-remote-error-exception-arguments")

___DEF_MOD_SYM(656,___S_rpc_2d_remote_2d_error_2d_exception_2d_message,"rpc-remote-error-exception-message")

___DEF_MOD_SYM(657,___S_rpc_2d_remote_2d_error_2d_exception_2d_procedure,"rpc-remote-error-exception-procedure")

___DEF_MOD_SYM(658,___S_rpc_2d_remote_2d_error_2d_exception_3f_,"rpc-remote-error-exception?")
___DEF_MOD_SYM(659,___S_s16vector,"s16vector")
___DEF_MOD_SYM(660,___S_s16vector_2d__3e_list,"s16vector->list")
___DEF_MOD_SYM(661,___S_s16vector_2d_append,"s16vector-append")
___DEF_MOD_SYM(662,___S_s16vector_2d_copy,"s16vector-copy")
___DEF_MOD_SYM(663,___S_s16vector_2d_fill_21_,"s16vector-fill!")
___DEF_MOD_SYM(664,___S_s16vector_2d_length,"s16vector-length")
___DEF_MOD_SYM(665,___S_s16vector_2d_ref,"s16vector-ref")
___DEF_MOD_SYM(666,___S_s16vector_2d_set_21_,"s16vector-set!")
___DEF_MOD_SYM(667,___S_s16vector_2d_shrink_21_,"s16vector-shrink!")
___DEF_MOD_SYM(668,___S_s16vector_3f_,"s16vector?")
___DEF_MOD_SYM(669,___S_s32vector,"s32vector")
___DEF_MOD_SYM(670,___S_s32vector_2d__3e_list,"s32vector->list")
___DEF_MOD_SYM(671,___S_s32vector_2d_append,"s32vector-append")
___DEF_MOD_SYM(672,___S_s32vector_2d_copy,"s32vector-copy")
___DEF_MOD_SYM(673,___S_s32vector_2d_fill_21_,"s32vector-fill!")
___DEF_MOD_SYM(674,___S_s32vector_2d_length,"s32vector-length")
___DEF_MOD_SYM(675,___S_s32vector_2d_ref,"s32vector-ref")
___DEF_MOD_SYM(676,___S_s32vector_2d_set_21_,"s32vector-set!")
___DEF_MOD_SYM(677,___S_s32vector_2d_shrink_21_,"s32vector-shrink!")
___DEF_MOD_SYM(678,___S_s32vector_3f_,"s32vector?")
___DEF_MOD_SYM(679,___S_s64vector,"s64vector")
___DEF_MOD_SYM(680,___S_s64vector_2d__3e_list,"s64vector->list")
___DEF_MOD_SYM(681,___S_s64vector_2d_append,"s64vector-append")
___DEF_MOD_SYM(682,___S_s64vector_2d_copy,"s64vector-copy")
___DEF_MOD_SYM(683,___S_s64vector_2d_fill_21_,"s64vector-fill!")
___DEF_MOD_SYM(684,___S_s64vector_2d_length,"s64vector-length")
___DEF_MOD_SYM(685,___S_s64vector_2d_ref,"s64vector-ref")
___DEF_MOD_SYM(686,___S_s64vector_2d_set_21_,"s64vector-set!")
___DEF_MOD_SYM(687,___S_s64vector_2d_shrink_21_,"s64vector-shrink!")
___DEF_MOD_SYM(688,___S_s64vector_3f_,"s64vector?")
___DEF_MOD_SYM(689,___S_s8vector,"s8vector")
___DEF_MOD_SYM(690,___S_s8vector_2d__3e_list,"s8vector->list")
___DEF_MOD_SYM(691,___S_s8vector_2d_append,"s8vector-append")
___DEF_MOD_SYM(692,___S_s8vector_2d_copy,"s8vector-copy")
___DEF_MOD_SYM(693,___S_s8vector_2d_fill_21_,"s8vector-fill!")
___DEF_MOD_SYM(694,___S_s8vector_2d_length,"s8vector-length")
___DEF_MOD_SYM(695,___S_s8vector_2d_ref,"s8vector-ref")
___DEF_MOD_SYM(696,___S_s8vector_2d_set_21_,"s8vector-set!")
___DEF_MOD_SYM(697,___S_s8vector_2d_shrink_21_,"s8vector-shrink!")
___DEF_MOD_SYM(698,___S_s8vector_3f_,"s8vector?")
___DEF_MOD_SYM(699,___S_scheduler_2d_exception_2d_reason,"scheduler-exception-reason")
___DEF_MOD_SYM(700,___S_scheduler_2d_exception_3f_,"scheduler-exception?")
___DEF_MOD_SYM(701,___S_scheme_2d_report_2d_environment,"scheme-report-environment")
___DEF_MOD_SYM(702,___S_seconds_2d__3e_time,"seconds->time")
___DEF_MOD_SYM(703,___S_serial_2d_number_2d__3e_object,"serial-number->object")
___DEF_MOD_SYM(704,___S_service_2d_info,"service-info")
___DEF_MOD_SYM(705,___S_service_2d_info_2d_aliases,"service-info-aliases")
___DEF_MOD_SYM(706,___S_service_2d_info_2d_name,"service-info-name")
___DEF_MOD_SYM(707,___S_service_2d_info_2d_port_2d_number,"service-info-port-number")
___DEF_MOD_SYM(708,___S_service_2d_info_2d_protocol,"service-info-protocol")
___DEF_MOD_SYM(709,___S_service_2d_info_3f_,"service-info?")
___DEF_MOD_SYM(710,___S_set_21_,"set!")
___DEF_MOD_SYM(711,___S_set_2d_box_21_,"set-box!")
___DEF_MOD_SYM(712,___S_set_2d_car_21_,"set-car!")
___DEF_MOD_SYM(713,___S_set_2d_cdr_21_,"set-cdr!")
___DEF_MOD_SYM(714,___S_setenv,"setenv")
___DEF_MOD_SYM(715,___S_sfun_2d_conversion_2d_exception_2d_arguments,"sfun-conversion-exception-arguments")

___DEF_MOD_SYM(716,___S_sfun_2d_conversion_2d_exception_2d_code,"sfun-conversion-exception-code")

___DEF_MOD_SYM(717,___S_sfun_2d_conversion_2d_exception_2d_message,"sfun-conversion-exception-message")

___DEF_MOD_SYM(718,___S_sfun_2d_conversion_2d_exception_2d_procedure,"sfun-conversion-exception-procedure")

___DEF_MOD_SYM(719,___S_sfun_2d_conversion_2d_exception_3f_,"sfun-conversion-exception?")
___DEF_MOD_SYM(720,___S_shell_2d_command,"shell-command")
___DEF_MOD_SYM(721,___S_sin,"sin")
___DEF_MOD_SYM(722,___S_six_2e__21_,"six.!")
___DEF_MOD_SYM(723,___S_six_2e__21_x,"six.!x")
___DEF_MOD_SYM(724,___S_six_2e__26_x,"six.&x")
___DEF_MOD_SYM(725,___S_six_2e__2a_x,"six.*x")
___DEF_MOD_SYM(726,___S_six_2e__2b__2b_x,"six.++x")
___DEF_MOD_SYM(727,___S_six_2e__2b_x,"six.+x")
___DEF_MOD_SYM(728,___S_six_2e__2d__2d_x,"six.--x")
___DEF_MOD_SYM(729,___S_six_2e__2d_x,"six.-x")
___DEF_MOD_SYM(730,___S_six_2e_arrow,"six.arrow")
___DEF_MOD_SYM(731,___S_six_2e_break,"six.break")
___DEF_MOD_SYM(732,___S_six_2e_call,"six.call")
___DEF_MOD_SYM(733,___S_six_2e_case,"six.case")
___DEF_MOD_SYM(734,___S_six_2e_clause,"six.clause")
___DEF_MOD_SYM(735,___S_six_2e_compound,"six.compound")
___DEF_MOD_SYM(736,___S_six_2e_cons,"six.cons")
___DEF_MOD_SYM(737,___S_six_2e_continue,"six.continue")
___DEF_MOD_SYM(738,___S_six_2e_define_2d_procedure,"six.define-procedure")
___DEF_MOD_SYM(739,___S_six_2e_define_2d_variable,"six.define-variable")
___DEF_MOD_SYM(740,___S_six_2e_do_2d_while,"six.do-while")
___DEF_MOD_SYM(741,___S_six_2e_dot,"six.dot")
___DEF_MOD_SYM(742,___S_six_2e_for,"six.for")
___DEF_MOD_SYM(743,___S_six_2e_goto,"six.goto")
___DEF_MOD_SYM(744,___S_six_2e_identifier,"six.identifier")
___DEF_MOD_SYM(745,___S_six_2e_if,"six.if")
___DEF_MOD_SYM(746,___S_six_2e_index,"six.index")
___DEF_MOD_SYM(747,___S_six_2e_label,"six.label")
___DEF_MOD_SYM(748,___S_six_2e_list,"six.list")
___DEF_MOD_SYM(749,___S_six_2e_literal,"six.literal")
___DEF_MOD_SYM(750,___S_six_2e_make_2d_array,"six.make-array")
___DEF_MOD_SYM(751,___S_six_2e_new,"six.new")
___DEF_MOD_SYM(752,___S_six_2e_null,"six.null")
___DEF_MOD_SYM(753,___S_six_2e_prefix,"six.prefix")
___DEF_MOD_SYM(754,___S_six_2e_procedure,"six.procedure")
___DEF_MOD_SYM(755,___S_six_2e_procedure_2d_body,"six.procedure-body")
___DEF_MOD_SYM(756,___S_six_2e_return,"six.return")
___DEF_MOD_SYM(757,___S_six_2e_switch,"six.switch")
___DEF_MOD_SYM(758,___S_six_2e_while,"six.while")
___DEF_MOD_SYM(759,___S_six_2e_x_21__3d_y,"six.x!=y")
___DEF_MOD_SYM(760,___S_six_2e_x_25__3d_y,"six.x%=y")
___DEF_MOD_SYM(761,___S_six_2e_x_25_y,"six.x%y")
___DEF_MOD_SYM(762,___S_six_2e_x_26__26_y,"six.x&&y")
___DEF_MOD_SYM(763,___S_six_2e_x_26__3d_y,"six.x&=y")
___DEF_MOD_SYM(764,___S_six_2e_x_26_y,"six.x&y")
___DEF_MOD_SYM(765,___S_six_2e_x_2a__3d_y,"six.x*=y")
___DEF_MOD_SYM(766,___S_six_2e_x_2a_y,"six.x*y")
___DEF_MOD_SYM(767,___S_six_2e_x_2b__2b_,"six.x++")
___DEF_MOD_SYM(768,___S_six_2e_x_2b__3d_y,"six.x+=y")
___DEF_MOD_SYM(769,___S_six_2e_x_2b_y,"six.x+y")
___DEF_MOD_SYM(770,___S_six_2e_x_2c_y,"six.x,y")
___DEF_MOD_SYM(771,___S_six_2e_x_2d__2d_,"six.x--")
___DEF_MOD_SYM(772,___S_six_2e_x_2d__3d_y,"six.x-=y")
___DEF_MOD_SYM(773,___S_six_2e_x_2d_y,"six.x-y")
___DEF_MOD_SYM(774,___S_six_2e_x_2f__3d_y,"six.x/=y")
___DEF_MOD_SYM(775,___S_six_2e_x_2f_y,"six.x/y")
___DEF_MOD_SYM(776,___S_six_2e_x_3a__2d_y,"six.x:-y")
___DEF_MOD_SYM(777,___S_six_2e_x_3a__3d_y,"six.x:=y")
___DEF_MOD_SYM(778,___S_six_2e_x_3a_y,"six.x:y")
___DEF_MOD_SYM(779,___S_six_2e_x_3c__3c__3d_y,"six.x<<=y")
___DEF_MOD_SYM(780,___S_six_2e_x_3c__3c_y,"six.x<<y")
___DEF_MOD_SYM(781,___S_six_2e_x_3c__3d_y,"six.x<=y")
___DEF_MOD_SYM(782,___S_six_2e_x_3c_y,"six.x<y")
___DEF_MOD_SYM(783,___S_six_2e_x_3d__3d_y,"six.x==y")
___DEF_MOD_SYM(784,___S_six_2e_x_3d_y,"six.x=y")
___DEF_MOD_SYM(785,___S_six_2e_x_3e__3d_y,"six.x>=y")
___DEF_MOD_SYM(786,___S_six_2e_x_3e__3e__3d_y,"six.x>>=y")
___DEF_MOD_SYM(787,___S_six_2e_x_3e__3e_y,"six.x>>y")
___DEF_MOD_SYM(788,___S_six_2e_x_3e_y,"six.x>y")
___DEF_MOD_SYM(789,___S_six_2e_x_3f_y_3a_z,"six.x?y:z")
___DEF_MOD_SYM(790,___S_six_2e_x_5e__3d_y,"six.x^=y")
___DEF_MOD_SYM(791,___S_six_2e_x_5e_y,"six.x^y")
___DEF_MOD_SYM(792,___S_six_2e_x_7c__3d_y,"six.x|=y")
___DEF_MOD_SYM(793,___S_six_2e_x_7c_y,"six.x|y")
___DEF_MOD_SYM(794,___S_six_2e_x_7c__7c_y,"six.x||y")
___DEF_MOD_SYM(795,___S_six_2e__7e_x,"six.~x")
___DEF_MOD_SYM(796,___S_socket_2d_info_2d_address,"socket-info-address")
___DEF_MOD_SYM(797,___S_socket_2d_info_2d_family,"socket-info-family")
___DEF_MOD_SYM(798,___S_socket_2d_info_2d_port_2d_number,"socket-info-port-number")
___DEF_MOD_SYM(799,___S_socket_2d_info_3f_,"socket-info?")
___DEF_MOD_SYM(800,___S_sqrt,"sqrt")
___DEF_MOD_SYM(801,___S_stack_2d_overflow_2d_exception_3f_,"stack-overflow-exception?")
___DEF_MOD_SYM(802,___S_started_2d_thread_2d_exception_2d_arguments,"started-thread-exception-arguments")

___DEF_MOD_SYM(803,___S_started_2d_thread_2d_exception_2d_procedure,"started-thread-exception-procedure")

___DEF_MOD_SYM(804,___S_started_2d_thread_2d_exception_3f_,"started-thread-exception?")
___DEF_MOD_SYM(805,___S_step,"step")
___DEF_MOD_SYM(806,___S_step_2d_level_2d_set_21_,"step-level-set!")
___DEF_MOD_SYM(807,___S_string,"string")
___DEF_MOD_SYM(808,___S_string_2d__3e_keyword,"string->keyword")
___DEF_MOD_SYM(809,___S_string_2d__3e_list,"string->list")
___DEF_MOD_SYM(810,___S_string_2d__3e_number,"string->number")
___DEF_MOD_SYM(811,___S_string_2d__3e_symbol,"string->symbol")
___DEF_MOD_SYM(812,___S_string_2d_append,"string-append")
___DEF_MOD_SYM(813,___S_string_2d_ci_3c__3d__3f_,"string-ci<=?")
___DEF_MOD_SYM(814,___S_string_2d_ci_3c__3f_,"string-ci<?")
___DEF_MOD_SYM(815,___S_string_2d_ci_3d__3f_,"string-ci=?")
___DEF_MOD_SYM(816,___S_string_2d_ci_3d__3f__2d_hash,"string-ci=?-hash")
___DEF_MOD_SYM(817,___S_string_2d_ci_3e__3d__3f_,"string-ci>=?")
___DEF_MOD_SYM(818,___S_string_2d_ci_3e__3f_,"string-ci>?")
___DEF_MOD_SYM(819,___S_string_2d_copy,"string-copy")
___DEF_MOD_SYM(820,___S_string_2d_fill_21_,"string-fill!")
___DEF_MOD_SYM(821,___S_string_2d_length,"string-length")
___DEF_MOD_SYM(822,___S_string_2d_ref,"string-ref")
___DEF_MOD_SYM(823,___S_string_2d_set_21_,"string-set!")
___DEF_MOD_SYM(824,___S_string_2d_shrink_21_,"string-shrink!")
___DEF_MOD_SYM(825,___S_string_3c__3d__3f_,"string<=?")
___DEF_MOD_SYM(826,___S_string_3c__3f_,"string<?")
___DEF_MOD_SYM(827,___S_string_3d__3f_,"string=?")
___DEF_MOD_SYM(828,___S_string_3d__3f__2d_hash,"string=?-hash")
___DEF_MOD_SYM(829,___S_string_3e__3d__3f_,"string>=?")
___DEF_MOD_SYM(830,___S_string_3e__3f_,"string>?")
___DEF_MOD_SYM(831,___S_string_3f_,"string?")
___DEF_MOD_SYM(832,___S_subf32vector,"subf32vector")
___DEF_MOD_SYM(833,___S_subf32vector_2d_fill_21_,"subf32vector-fill!")
___DEF_MOD_SYM(834,___S_subf32vector_2d_move_21_,"subf32vector-move!")
___DEF_MOD_SYM(835,___S_subf64vector,"subf64vector")
___DEF_MOD_SYM(836,___S_subf64vector_2d_fill_21_,"subf64vector-fill!")
___DEF_MOD_SYM(837,___S_subf64vector_2d_move_21_,"subf64vector-move!")
___DEF_MOD_SYM(838,___S_subs16vector,"subs16vector")
___DEF_MOD_SYM(839,___S_subs16vector_2d_fill_21_,"subs16vector-fill!")
___DEF_MOD_SYM(840,___S_subs16vector_2d_move_21_,"subs16vector-move!")
___DEF_MOD_SYM(841,___S_subs32vector,"subs32vector")
___DEF_MOD_SYM(842,___S_subs32vector_2d_fill_21_,"subs32vector-fill!")
___DEF_MOD_SYM(843,___S_subs32vector_2d_move_21_,"subs32vector-move!")
___DEF_MOD_SYM(844,___S_subs64vector,"subs64vector")
___DEF_MOD_SYM(845,___S_subs64vector_2d_fill_21_,"subs64vector-fill!")
___DEF_MOD_SYM(846,___S_subs64vector_2d_move_21_,"subs64vector-move!")
___DEF_MOD_SYM(847,___S_subs8vector,"subs8vector")
___DEF_MOD_SYM(848,___S_subs8vector_2d_fill_21_,"subs8vector-fill!")
___DEF_MOD_SYM(849,___S_subs8vector_2d_move_21_,"subs8vector-move!")
___DEF_MOD_SYM(850,___S_substring,"substring")
___DEF_MOD_SYM(851,___S_substring_2d_fill_21_,"substring-fill!")
___DEF_MOD_SYM(852,___S_substring_2d_move_21_,"substring-move!")
___DEF_MOD_SYM(853,___S_subu16vector,"subu16vector")
___DEF_MOD_SYM(854,___S_subu16vector_2d_fill_21_,"subu16vector-fill!")
___DEF_MOD_SYM(855,___S_subu16vector_2d_move_21_,"subu16vector-move!")
___DEF_MOD_SYM(856,___S_subu32vector,"subu32vector")
___DEF_MOD_SYM(857,___S_subu32vector_2d_fill_21_,"subu32vector-fill!")
___DEF_MOD_SYM(858,___S_subu32vector_2d_move_21_,"subu32vector-move!")
___DEF_MOD_SYM(859,___S_subu64vector,"subu64vector")
___DEF_MOD_SYM(860,___S_subu64vector_2d_fill_21_,"subu64vector-fill!")
___DEF_MOD_SYM(861,___S_subu64vector_2d_move_21_,"subu64vector-move!")
___DEF_MOD_SYM(862,___S_subu8vector,"subu8vector")
___DEF_MOD_SYM(863,___S_subu8vector_2d_fill_21_,"subu8vector-fill!")
___DEF_MOD_SYM(864,___S_subu8vector_2d_move_21_,"subu8vector-move!")
___DEF_MOD_SYM(865,___S_subvector,"subvector")
___DEF_MOD_SYM(866,___S_subvector_2d_fill_21_,"subvector-fill!")
___DEF_MOD_SYM(867,___S_subvector_2d_move_21_,"subvector-move!")
___DEF_MOD_SYM(868,___S_symbol_2d__3e_string,"symbol->string")
___DEF_MOD_SYM(869,___S_symbol_2d_hash,"symbol-hash")
___DEF_MOD_SYM(870,___S_symbol_3f_,"symbol?")
___DEF_MOD_SYM(871,___S_syntax_2d_rules,"syntax-rules")
___DEF_MOD_SYM(872,___S_system_2d_stamp,"system-stamp")
___DEF_MOD_SYM(873,___S_system_2d_type,"system-type")
___DEF_MOD_SYM(874,___S_system_2d_type_2d_string,"system-type-string")
___DEF_MOD_SYM(875,___S_system_2d_version,"system-version")
___DEF_MOD_SYM(876,___S_system_2d_version_2d_string,"system-version-string")
___DEF_MOD_SYM(877,___S_table_2d__3e_list,"table->list")
___DEF_MOD_SYM(878,___S_table_2d_copy,"table-copy")
___DEF_MOD_SYM(879,___S_table_2d_for_2d_each,"table-for-each")
___DEF_MOD_SYM(880,___S_table_2d_length,"table-length")
___DEF_MOD_SYM(881,___S_table_2d_merge,"table-merge")
___DEF_MOD_SYM(882,___S_table_2d_merge_21_,"table-merge!")
___DEF_MOD_SYM(883,___S_table_2d_ref,"table-ref")
___DEF_MOD_SYM(884,___S_table_2d_search,"table-search")
___DEF_MOD_SYM(885,___S_table_2d_set_21_,"table-set!")
___DEF_MOD_SYM(886,___S_table_3f_,"table?")
___DEF_MOD_SYM(887,___S_tan,"tan")
___DEF_MOD_SYM(888,___S_tcp_2d_client_2d_peer_2d_socket_2d_info,"tcp-client-peer-socket-info")
___DEF_MOD_SYM(889,___S_tcp_2d_client_2d_self_2d_socket_2d_info,"tcp-client-self-socket-info")
___DEF_MOD_SYM(890,___S_tcp_2d_server_2d_socket_2d_info,"tcp-server-socket-info")
___DEF_MOD_SYM(891,___S_tcp_2d_service_2d_register_21_,"tcp-service-register!")
___DEF_MOD_SYM(892,___S_tcp_2d_service_2d_unregister_21_,"tcp-service-unregister!")
___DEF_MOD_SYM(893,___S_terminated_2d_thread_2d_exception_2d_arguments,"terminated-thread-exception-arguments")

___DEF_MOD_SYM(894,___S_terminated_2d_thread_2d_exception_2d_procedure,"terminated-thread-exception-procedure")

___DEF_MOD_SYM(895,___S_terminated_2d_thread_2d_exception_3f_,"terminated-thread-exception?")
___DEF_MOD_SYM(896,___S_test_2d_bit_2d_field_3f_,"test-bit-field?")
___DEF_MOD_SYM(897,___S_this_2d_source_2d_file,"this-source-file")
___DEF_MOD_SYM(898,___S_thread_2d_base_2d_priority,"thread-base-priority")
___DEF_MOD_SYM(899,___S_thread_2d_base_2d_priority_2d_set_21_,"thread-base-priority-set!")
___DEF_MOD_SYM(900,___S_thread_2d_group_2d__3e_thread_2d_group_2d_list,"thread-group->thread-group-list")

___DEF_MOD_SYM(901,___S_thread_2d_group_2d__3e_thread_2d_group_2d_vector,"thread-group->thread-group-vector")

___DEF_MOD_SYM(902,___S_thread_2d_group_2d__3e_thread_2d_list,"thread-group->thread-list")
___DEF_MOD_SYM(903,___S_thread_2d_group_2d__3e_thread_2d_vector,"thread-group->thread-vector")
___DEF_MOD_SYM(904,___S_thread_2d_group_2d_name,"thread-group-name")
___DEF_MOD_SYM(905,___S_thread_2d_group_2d_parent,"thread-group-parent")
___DEF_MOD_SYM(906,___S_thread_2d_group_2d_resume_21_,"thread-group-resume!")
___DEF_MOD_SYM(907,___S_thread_2d_group_2d_suspend_21_,"thread-group-suspend!")
___DEF_MOD_SYM(908,___S_thread_2d_group_2d_terminate_21_,"thread-group-terminate!")
___DEF_MOD_SYM(909,___S_thread_2d_group_3f_,"thread-group?")
___DEF_MOD_SYM(910,___S_thread_2d_init_21_,"thread-init!")
___DEF_MOD_SYM(911,___S_thread_2d_interrupt_21_,"thread-interrupt!")
___DEF_MOD_SYM(912,___S_thread_2d_join_21_,"thread-join!")
___DEF_MOD_SYM(913,___S_thread_2d_mailbox_2d_extract_2d_and_2d_rewind,"thread-mailbox-extract-and-rewind")

___DEF_MOD_SYM(914,___S_thread_2d_mailbox_2d_next,"thread-mailbox-next")
___DEF_MOD_SYM(915,___S_thread_2d_mailbox_2d_rewind,"thread-mailbox-rewind")
___DEF_MOD_SYM(916,___S_thread_2d_name,"thread-name")
___DEF_MOD_SYM(917,___S_thread_2d_priority_2d_boost,"thread-priority-boost")
___DEF_MOD_SYM(918,___S_thread_2d_priority_2d_boost_2d_set_21_,"thread-priority-boost-set!")
___DEF_MOD_SYM(919,___S_thread_2d_quantum,"thread-quantum")
___DEF_MOD_SYM(920,___S_thread_2d_quantum_2d_set_21_,"thread-quantum-set!")
___DEF_MOD_SYM(921,___S_thread_2d_receive,"thread-receive")
___DEF_MOD_SYM(922,___S_thread_2d_resume_21_,"thread-resume!")
___DEF_MOD_SYM(923,___S_thread_2d_send,"thread-send")
___DEF_MOD_SYM(924,___S_thread_2d_sleep_21_,"thread-sleep!")
___DEF_MOD_SYM(925,___S_thread_2d_specific,"thread-specific")
___DEF_MOD_SYM(926,___S_thread_2d_specific_2d_set_21_,"thread-specific-set!")
___DEF_MOD_SYM(927,___S_thread_2d_start_21_,"thread-start!")
___DEF_MOD_SYM(928,___S_thread_2d_state,"thread-state")
___DEF_MOD_SYM(929,___S_thread_2d_state_2d_abnormally_2d_terminated_2d_reason,"thread-state-abnormally-terminated-reason")

___DEF_MOD_SYM(930,___S_thread_2d_state_2d_abnormally_2d_terminated_3f_,"thread-state-abnormally-terminated?")

___DEF_MOD_SYM(931,___S_thread_2d_state_2d_active_2d_timeout,"thread-state-active-timeout")
___DEF_MOD_SYM(932,___S_thread_2d_state_2d_active_2d_waiting_2d_for,"thread-state-active-waiting-for")

___DEF_MOD_SYM(933,___S_thread_2d_state_2d_active_3f_,"thread-state-active?")
___DEF_MOD_SYM(934,___S_thread_2d_state_2d_initialized_3f_,"thread-state-initialized?")
___DEF_MOD_SYM(935,___S_thread_2d_state_2d_normally_2d_terminated_2d_result,"thread-state-normally-terminated-result")

___DEF_MOD_SYM(936,___S_thread_2d_state_2d_normally_2d_terminated_3f_,"thread-state-normally-terminated?")

___DEF_MOD_SYM(937,___S_thread_2d_state_2d_uninitialized_3f_,"thread-state-uninitialized?")
___DEF_MOD_SYM(938,___S_thread_2d_suspend_21_,"thread-suspend!")
___DEF_MOD_SYM(939,___S_thread_2d_terminate_21_,"thread-terminate!")
___DEF_MOD_SYM(940,___S_thread_2d_thread_2d_group,"thread-thread-group")
___DEF_MOD_SYM(941,___S_thread_2d_yield_21_,"thread-yield!")
___DEF_MOD_SYM(942,___S_thread_3f_,"thread?")
___DEF_MOD_SYM(943,___S_time,"time")
___DEF_MOD_SYM(944,___S_time_2d__3e_seconds,"time->seconds")
___DEF_MOD_SYM(945,___S_time_3f_,"time?")
___DEF_MOD_SYM(946,___S_timeout_2d__3e_time,"timeout->time")
___DEF_MOD_SYM(947,___S_top,"top")
___DEF_MOD_SYM(948,___S_touch,"touch")
___DEF_MOD_SYM(949,___S_trace,"trace")
___DEF_MOD_SYM(950,___S_transcript_2d_off,"transcript-off")
___DEF_MOD_SYM(951,___S_transcript_2d_on,"transcript-on")
___DEF_MOD_SYM(952,___S_truncate,"truncate")
___DEF_MOD_SYM(953,___S_tty_2d_history,"tty-history")
___DEF_MOD_SYM(954,___S_tty_2d_history_2d_max_2d_length_2d_set_21_,"tty-history-max-length-set!")
___DEF_MOD_SYM(955,___S_tty_2d_history_2d_set_21_,"tty-history-set!")
___DEF_MOD_SYM(956,___S_tty_2d_mode_2d_set_21_,"tty-mode-set!")
___DEF_MOD_SYM(957,___S_tty_2d_paren_2d_balance_2d_duration_2d_set_21_,"tty-paren-balance-duration-set!")

___DEF_MOD_SYM(958,___S_tty_2d_text_2d_attributes_2d_set_21_,"tty-text-attributes-set!")
___DEF_MOD_SYM(959,___S_tty_2d_type_2d_set_21_,"tty-type-set!")
___DEF_MOD_SYM(960,___S_tty_3f_,"tty?")
___DEF_MOD_SYM(961,___S_type_2d_exception_2d_arg_2d_num,"type-exception-arg-num")
___DEF_MOD_SYM(962,___S_type_2d_exception_2d_arguments,"type-exception-arguments")
___DEF_MOD_SYM(963,___S_type_2d_exception_2d_procedure,"type-exception-procedure")
___DEF_MOD_SYM(964,___S_type_2d_exception_2d_type_2d_id,"type-exception-type-id")
___DEF_MOD_SYM(965,___S_type_2d_exception_3f_,"type-exception?")
___DEF_MOD_SYM(966,___S_u16vector,"u16vector")
___DEF_MOD_SYM(967,___S_u16vector_2d__3e_list,"u16vector->list")
___DEF_MOD_SYM(968,___S_u16vector_2d_append,"u16vector-append")
___DEF_MOD_SYM(969,___S_u16vector_2d_copy,"u16vector-copy")
___DEF_MOD_SYM(970,___S_u16vector_2d_fill_21_,"u16vector-fill!")
___DEF_MOD_SYM(971,___S_u16vector_2d_length,"u16vector-length")
___DEF_MOD_SYM(972,___S_u16vector_2d_ref,"u16vector-ref")
___DEF_MOD_SYM(973,___S_u16vector_2d_set_21_,"u16vector-set!")
___DEF_MOD_SYM(974,___S_u16vector_2d_shrink_21_,"u16vector-shrink!")
___DEF_MOD_SYM(975,___S_u16vector_3f_,"u16vector?")
___DEF_MOD_SYM(976,___S_u32vector,"u32vector")
___DEF_MOD_SYM(977,___S_u32vector_2d__3e_list,"u32vector->list")
___DEF_MOD_SYM(978,___S_u32vector_2d_append,"u32vector-append")
___DEF_MOD_SYM(979,___S_u32vector_2d_copy,"u32vector-copy")
___DEF_MOD_SYM(980,___S_u32vector_2d_fill_21_,"u32vector-fill!")
___DEF_MOD_SYM(981,___S_u32vector_2d_length,"u32vector-length")
___DEF_MOD_SYM(982,___S_u32vector_2d_ref,"u32vector-ref")
___DEF_MOD_SYM(983,___S_u32vector_2d_set_21_,"u32vector-set!")
___DEF_MOD_SYM(984,___S_u32vector_2d_shrink_21_,"u32vector-shrink!")
___DEF_MOD_SYM(985,___S_u32vector_3f_,"u32vector?")
___DEF_MOD_SYM(986,___S_u64vector,"u64vector")
___DEF_MOD_SYM(987,___S_u64vector_2d__3e_list,"u64vector->list")
___DEF_MOD_SYM(988,___S_u64vector_2d_append,"u64vector-append")
___DEF_MOD_SYM(989,___S_u64vector_2d_copy,"u64vector-copy")
___DEF_MOD_SYM(990,___S_u64vector_2d_fill_21_,"u64vector-fill!")
___DEF_MOD_SYM(991,___S_u64vector_2d_length,"u64vector-length")
___DEF_MOD_SYM(992,___S_u64vector_2d_ref,"u64vector-ref")
___DEF_MOD_SYM(993,___S_u64vector_2d_set_21_,"u64vector-set!")
___DEF_MOD_SYM(994,___S_u64vector_2d_shrink_21_,"u64vector-shrink!")
___DEF_MOD_SYM(995,___S_u64vector_3f_,"u64vector?")
___DEF_MOD_SYM(996,___S_u8vector,"u8vector")
___DEF_MOD_SYM(997,___S_u8vector_2d__3e_list,"u8vector->list")
___DEF_MOD_SYM(998,___S_u8vector_2d__3e_object,"u8vector->object")
___DEF_MOD_SYM(999,___S_u8vector_2d_append,"u8vector-append")
___DEF_MOD_SYM(1000,___S_u8vector_2d_copy,"u8vector-copy")
___DEF_MOD_SYM(1001,___S_u8vector_2d_fill_21_,"u8vector-fill!")
___DEF_MOD_SYM(1002,___S_u8vector_2d_length,"u8vector-length")
___DEF_MOD_SYM(1003,___S_u8vector_2d_ref,"u8vector-ref")
___DEF_MOD_SYM(1004,___S_u8vector_2d_set_21_,"u8vector-set!")
___DEF_MOD_SYM(1005,___S_u8vector_2d_shrink_21_,"u8vector-shrink!")
___DEF_MOD_SYM(1006,___S_u8vector_3f_,"u8vector?")
___DEF_MOD_SYM(1007,___S_unbound_2d_global_2d_exception_2d_code,"unbound-global-exception-code")

___DEF_MOD_SYM(1008,___S_unbound_2d_global_2d_exception_2d_rte,"unbound-global-exception-rte")
___DEF_MOD_SYM(1009,___S_unbound_2d_global_2d_exception_2d_variable,"unbound-global-exception-variable")

___DEF_MOD_SYM(1010,___S_unbound_2d_global_2d_exception_3f_,"unbound-global-exception?")
___DEF_MOD_SYM(1011,___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_2d_arguments,"unbound-os-environment-variable-exception-arguments")

___DEF_MOD_SYM(1012,___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_2d_procedure,"unbound-os-environment-variable-exception-procedure")

___DEF_MOD_SYM(1013,___S_unbound_2d_os_2d_environment_2d_variable_2d_exception_3f_,"unbound-os-environment-variable-exception?")

___DEF_MOD_SYM(1014,___S_unbound_2d_serial_2d_number_2d_exception_2d_arguments,"unbound-serial-number-exception-arguments")

___DEF_MOD_SYM(1015,___S_unbound_2d_serial_2d_number_2d_exception_2d_procedure,"unbound-serial-number-exception-procedure")

___DEF_MOD_SYM(1016,___S_unbound_2d_serial_2d_number_2d_exception_3f_,"unbound-serial-number-exception?")

___DEF_MOD_SYM(1017,___S_unbound_2d_table_2d_key_2d_exception_2d_arguments,"unbound-table-key-exception-arguments")

___DEF_MOD_SYM(1018,___S_unbound_2d_table_2d_key_2d_exception_2d_procedure,"unbound-table-key-exception-procedure")

___DEF_MOD_SYM(1019,___S_unbound_2d_table_2d_key_2d_exception_3f_,"unbound-table-key-exception?")
___DEF_MOD_SYM(1020,___S_unbox,"unbox")
___DEF_MOD_SYM(1021,___S_unbreak,"unbreak")
___DEF_MOD_SYM(1022,___S_uncaught_2d_exception_2d_arguments,"uncaught-exception-arguments")
___DEF_MOD_SYM(1023,___S_uncaught_2d_exception_2d_procedure,"uncaught-exception-procedure")
___DEF_MOD_SYM(1024,___S_uncaught_2d_exception_2d_reason,"uncaught-exception-reason")
___DEF_MOD_SYM(1025,___S_uncaught_2d_exception_3f_,"uncaught-exception?")
___DEF_MOD_SYM(1026,___S_uninitialized_2d_thread_2d_exception_2d_arguments,"uninitialized-thread-exception-arguments")

___DEF_MOD_SYM(1027,___S_uninitialized_2d_thread_2d_exception_2d_procedure,"uninitialized-thread-exception-procedure")

___DEF_MOD_SYM(1028,___S_uninitialized_2d_thread_2d_exception_3f_,"uninitialized-thread-exception?")

___DEF_MOD_SYM(1029,___S_uninterned_2d_keyword_3f_,"uninterned-keyword?")
___DEF_MOD_SYM(1030,___S_uninterned_2d_symbol_3f_,"uninterned-symbol?")
___DEF_MOD_SYM(1031,___S_unknown_2d_keyword_2d_argument_2d_exception_2d_arguments,"unknown-keyword-argument-exception-arguments")

___DEF_MOD_SYM(1032,___S_unknown_2d_keyword_2d_argument_2d_exception_2d_procedure,"unknown-keyword-argument-exception-procedure")

___DEF_MOD_SYM(1033,___S_unknown_2d_keyword_2d_argument_2d_exception_3f_,"unknown-keyword-argument-exception?")

___DEF_MOD_SYM(1034,___S_unterminated_2d_process_2d_exception_2d_arguments,"unterminated-process-exception-arguments")

___DEF_MOD_SYM(1035,___S_unterminated_2d_process_2d_exception_2d_procedure,"unterminated-process-exception-procedure")

___DEF_MOD_SYM(1036,___S_unterminated_2d_process_2d_exception_3f_,"unterminated-process-exception?")

___DEF_MOD_SYM(1037,___S_untrace,"untrace")
___DEF_MOD_SYM(1038,___S_user_2d_info,"user-info")
___DEF_MOD_SYM(1039,___S_user_2d_info_2d_gid,"user-info-gid")
___DEF_MOD_SYM(1040,___S_user_2d_info_2d_home,"user-info-home")
___DEF_MOD_SYM(1041,___S_user_2d_info_2d_name,"user-info-name")
___DEF_MOD_SYM(1042,___S_user_2d_info_2d_shell,"user-info-shell")
___DEF_MOD_SYM(1043,___S_user_2d_info_2d_uid,"user-info-uid")
___DEF_MOD_SYM(1044,___S_user_2d_info_3f_,"user-info?")
___DEF_MOD_SYM(1045,___S_user_2d_name,"user-name")
___DEF_MOD_SYM(1046,___S_values,"values")
___DEF_MOD_SYM(1047,___S_vector,"vector")
___DEF_MOD_SYM(1048,___S_vector_2d__3e_list,"vector->list")
___DEF_MOD_SYM(1049,___S_vector_2d_append,"vector-append")
___DEF_MOD_SYM(1050,___S_vector_2d_copy,"vector-copy")
___DEF_MOD_SYM(1051,___S_vector_2d_fill_21_,"vector-fill!")
___DEF_MOD_SYM(1052,___S_vector_2d_length,"vector-length")
___DEF_MOD_SYM(1053,___S_vector_2d_ref,"vector-ref")
___DEF_MOD_SYM(1054,___S_vector_2d_set_21_,"vector-set!")
___DEF_MOD_SYM(1055,___S_vector_2d_shrink_21_,"vector-shrink!")
___DEF_MOD_SYM(1056,___S_vector_3f_,"vector?")
___DEF_MOD_SYM(1057,___S_void,"void")
___DEF_MOD_SYM(1058,___S_will_2d_execute_21_,"will-execute!")
___DEF_MOD_SYM(1059,___S_will_2d_testator,"will-testator")
___DEF_MOD_SYM(1060,___S_will_3f_,"will?")
___DEF_MOD_SYM(1061,___S_with_2d_exception_2d_catcher,"with-exception-catcher")
___DEF_MOD_SYM(1062,___S_with_2d_exception_2d_handler,"with-exception-handler")
___DEF_MOD_SYM(1063,___S_with_2d_input_2d_from_2d_file,"with-input-from-file")
___DEF_MOD_SYM(1064,___S_with_2d_input_2d_from_2d_port,"with-input-from-port")
___DEF_MOD_SYM(1065,___S_with_2d_input_2d_from_2d_process,"with-input-from-process")
___DEF_MOD_SYM(1066,___S_with_2d_input_2d_from_2d_string,"with-input-from-string")
___DEF_MOD_SYM(1067,___S_with_2d_input_2d_from_2d_u8vector,"with-input-from-u8vector")
___DEF_MOD_SYM(1068,___S_with_2d_input_2d_from_2d_vector,"with-input-from-vector")
___DEF_MOD_SYM(1069,___S_with_2d_output_2d_to_2d_file,"with-output-to-file")
___DEF_MOD_SYM(1070,___S_with_2d_output_2d_to_2d_port,"with-output-to-port")
___DEF_MOD_SYM(1071,___S_with_2d_output_2d_to_2d_process,"with-output-to-process")
___DEF_MOD_SYM(1072,___S_with_2d_output_2d_to_2d_string,"with-output-to-string")
___DEF_MOD_SYM(1073,___S_with_2d_output_2d_to_2d_u8vector,"with-output-to-u8vector")
___DEF_MOD_SYM(1074,___S_with_2d_output_2d_to_2d_vector,"with-output-to-vector")
___DEF_MOD_SYM(1075,___S_write,"write")
___DEF_MOD_SYM(1076,___S_write_2d_char,"write-char")
___DEF_MOD_SYM(1077,___S_write_2d_substring,"write-substring")
___DEF_MOD_SYM(1078,___S_write_2d_subu8vector,"write-subu8vector")
___DEF_MOD_SYM(1079,___S_write_2d_u8,"write-u8")
___DEF_MOD_SYM(1080,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_arguments,"wrong-number-of-arguments-exception-arguments")

___DEF_MOD_SYM(1081,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_2d_procedure,"wrong-number-of-arguments-exception-procedure")

___DEF_MOD_SYM(1082,___S_wrong_2d_number_2d_of_2d_arguments_2d_exception_3f_,"wrong-number-of-arguments-exception?")

___DEF_MOD_SYM(1083,___S_zero_3f_,"zero?")
___END_MOD_SYM_KEY

#endif
