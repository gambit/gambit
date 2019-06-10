;; ***** TARGET CODE EMITTERS

(define-macro (^ . forms)
  (if (null? forms)
      `'()
      `(list ,@forms)))

(define-macro (^var-declaration type name #!optional (init #f))
  `(univ-emit-var-declaration ctx ,type ,name ,init))

(define-macro (^expr-statement expr)
  `(univ-emit-expr-statement ctx ,expr))

(define-macro (^if test true #!optional (false #f))
  `(univ-emit-if ctx ,test ,true ,false))

(define-macro (^if-expr type expr1 expr2 expr3)
  `(univ-emit-if-expr ctx ,type ,expr1 ,expr2 ,expr3))

(define-macro (^if-instanceof class expr true #!optional (false #f))
  `(univ-emit-if-instanceof ctx ,class ,expr ,true ,false))

(define-macro (^while test body)
  `(univ-emit-while ctx ,test ,body))

(define-macro (^eq? expr1 expr2)
  `(univ-emit-eq? ctx ,expr1 ,expr2))

(define-macro (^+ expr1 #!optional (expr2 #f))
  `(univ-emit-+ ctx ,expr1 ,expr2))

(define-macro (^- expr1 #!optional (expr2 #f))
  `(univ-emit-- ctx ,expr1 ,expr2))

(define-macro (^* expr1 expr2)
  `(univ-emit-* ctx ,expr1 ,expr2))

(define-macro (^/ expr1 expr2)
  `(univ-emit-/ ctx ,expr1 ,expr2))

(define-macro (^<< expr1 expr2)
  `(univ-emit-<< ctx ,expr1 ,expr2))

(define-macro (^>> expr1 expr2)
  `(univ-emit->> ctx ,expr1 ,expr2))

(define-macro (^>>> expr1 expr2)
  `(univ-emit->>> ctx ,expr1 ,expr2))

(define-macro (^bitnot expr)
  `(univ-emit-bitnot ctx ,expr))

(define-macro (^bitand expr1 expr2)
  `(univ-emit-bitand ctx ,expr1 ,expr2))

(define-macro (^bitior expr1 expr2)
  `(univ-emit-bitior ctx ,expr1 ,expr2))

(define-macro (^bitxor expr1 expr2)
  `(univ-emit-bitxor ctx ,expr1 ,expr2))

(define-macro (^= expr1 expr2)
  `(univ-emit-= ctx ,expr1 ,expr2))

(define-macro (^!= expr1 expr2)
  `(univ-emit-!= ctx ,expr1 ,expr2))

(define-macro (^< expr1 expr2)
  `(univ-emit-< ctx ,expr1 ,expr2))

(define-macro (^<= expr1 expr2)
  `(univ-emit-<= ctx ,expr1 ,expr2))

(define-macro (^> expr1 expr2)
  `(univ-emit-> ctx ,expr1 ,expr2))

(define-macro (^>= expr1 expr2)
  `(univ-emit->= ctx ,expr1 ,expr2))

(define-macro (^not expr)
  `(univ-emit-not ctx ,expr))

(define-macro (^&& expr1 expr2)
  `(univ-emit-&& ctx ,expr1 ,expr2))

(define-macro (^and expr1 expr2)
  `(univ-emit-and ctx ,expr1 ,expr2))

(define-macro (^or expr1 expr2)
  `(univ-emit-or ctx ,expr1 ,expr2))

(define-macro (^concat expr1 expr2)
  `(univ-emit-concat ctx ,expr1 ,expr2))

(define-macro (^tostr expr)
  `(univ-emit-tostr ctx ,expr))

(define-macro (^conv* type-name expr)
  `(univ-emit-conv* ctx ,type-name ,expr))

(define-macro (^cast type expr)
  `(univ-emit-cast ctx ,type ,expr))

(define-macro (^cast* type-name expr)
  `(univ-emit-cast* ctx ,type-name ,expr))

(define-macro (^cast*-scmobj expr)
  `(univ-emit-cast*-scmobj ctx ,expr))

(define-macro (^cast*-jumpable expr)
  `(univ-emit-cast*-jumpable ctx ,expr))

(define-macro (^upcast* from-type-name to-type-name expr)
  `(univ-emit-upcast* ctx ,from-type-name ,to-type-name ,expr))

(define-macro (^downcast* type-name expr)
  `(univ-emit-downcast* ctx ,type-name ,expr))

(define-macro (^downupcast* down-type-name up-type-name expr)
  `(univ-emit-downupcast* ctx ,down-type-name ,up-type-name ,expr))

(define-macro (^seq expr1 expr2)
  `(univ-emit-seq ctx ,expr1 ,expr2))

(define-macro (^parens expr)
  `(univ-emit-parens ctx ,expr))

(define-macro (^parens-php expr)
  `(univ-emit-parens-php ctx ,expr))

(define-macro (^local-var name)
  `(univ-emit-local-var ctx ,name))

(define-macro (^global-var name)
  `(univ-emit-global-var ctx ,name))

(define-macro (^global-function name)
  `(univ-emit-global-function ctx ,name))

(define-macro (^id-to-jumpable name)
  `(univ-emit-id-to-jumpable ctx ,name))

(define-macro (^rts-field name)      `(univ-emit-rts-field ctx ,name #t))
(define-macro (^rts-field-priv name) `(univ-emit-rts-field ctx ,name #f))
(define-macro (^rts-field-ref name)  `(univ-emit-rts-field-ref ctx ,name #t))
(define-macro (^rts-field-ref-priv name)  `(univ-emit-rts-field-ref ctx ,name #f))
(define-macro (^rts-field-use name)  `(univ-emit-rts-field-use ctx ,name #t))
(define-macro (^rts-field-use-priv name) `(univ-emit-rts-field-use ctx ,name #f))

(define-macro (^rts-method name)     `(univ-emit-rts-method ctx ,name #t))
(define-macro (^rts-method-priv name) `(univ-emit-rts-method ctx ,name #f))
(define-macro (^rts-method-ref name) `(univ-emit-rts-method-ref ctx ,name #t))
(define-macro (^rts-method-ref-priv name) `(univ-emit-rts-method-ref ctx ,name #f))
(define-macro (^rts-method-use name) `(univ-emit-rts-method-use ctx ,name #t))
(define-macro (^rts-method-use-priv name) `(univ-emit-rts-method-use ctx ,name #f))

(define-macro (^rts-class name)      `(univ-emit-rts-class ctx ,name #t))
(define-macro (^rts-class-priv name) `(univ-emit-rts-class ctx ,name #f))
(define-macro (^rts-class-ref name)  `(univ-emit-rts-class-ref ctx ,name #t))
(define-macro (^rts-class-ref-priv name)  `(univ-emit-rts-class-ref ctx ,name #f))
(define-macro (^rts-class-use name)  `(univ-emit-rts-class-use ctx ,name #t))
(define-macro (^rts-class-use-priv name) `(univ-emit-rts-class-use ctx ,name #f))

(define-macro (^rts-jumpable-use name) `(univ-emit-rts-jumpable-use ctx ,name))

(define-macro (^prefix name #!optional (public? #f))
  `(univ-emit-prefix ctx ,name ,public?))

(define-macro (^prefix-class name #!optional (public? #f))
  `(univ-emit-prefix-class ctx ,name ,public?))

(define-macro (^assign-expr loc expr)
  `(univ-emit-assign-expr ctx ,loc ,expr))

(define-macro (^assign loc expr)
  `(univ-emit-assign ctx ,loc ,expr))

(define-macro (^inc-by loc expr #!optional (embed #f))
  `(univ-emit-inc-by ctx ,loc ,expr ,embed))

(define-macro (^alias expr)
  `(univ-emit-alias ctx ,expr))

(define-macro (^unalias expr)
  `(univ-emit-unalias ctx ,expr))

(define-macro (^array? expr)
  `(univ-emit-array? ctx ,expr))

(define-macro (^array-length expr)
  `(univ-emit-array-length ctx ,expr))

(define-macro (^array-shrink! expr1 expr2)
  `(univ-emit-array-shrink! ctx ,expr1 ,expr2))

(define-macro (^array-shrink-possibly-copy! expr1 expr2)
  `(univ-emit-array-shrink-possibly-copy! ctx ,expr1 ,expr2))

(define-macro (^move-array-to-array array1 srcpos array2 destpos len)
  `(univ-emit-move-array-to-array ctx ,array1 ,srcpos ,array2 ,destpos ,len))

(define-macro (^copy-array-to-extensible-array expr len)
  `(univ-emit-copy-array-to-extensible-array ctx ,expr ,len))

(define-macro (^extensible-array-to-array! var len)
  `(univ-emit-extensible-array-to-array! ctx ,var ,len))

(define-macro (^extensible-subarray expr start len)
   `(univ-emit-extensible-subarray ctx ,expr ,start ,len))

(define-macro (^subarray expr1 expr2 expr3)
  `(univ-emit-subarray ctx ,expr1 ,expr2 ,expr3))

(define-macro (^array-index expr1 expr2)
  `(univ-emit-array-index ctx ,expr1 ,expr2))

(define-macro (^prop-index type expr1 expr2 #!optional (expr3 #f))
  `(univ-emit-prop-index ctx ,type ,expr1 ,expr2 ,expr3))

(define-macro (^prop-index-or-null type expr1 expr2)
  `(univ-emit-prop-index-or-null ctx ,type ,expr1 ,expr2))

(define-macro (^prop-index-exists? expr1 expr2)
  `(univ-emit-prop-index-exists? ctx ,expr1 ,expr2))

(define-macro (^get obj name)
  `(univ-emit-get ctx ,obj ,name))

(define-macro (^set obj name val)
  `(univ-emit-set ctx ,obj ,name ,val))

(define-macro (^attribute-exists? obj name)
  `(univ-emit-attribute-exists? ctx ,obj ,name))

(define-macro (^obj obj)
  `(univ-emit-obj ctx ,obj))

(define-macro (^obj-proc-as type obj)
  `(univ-emit-obj-proc-as ctx ,type ,obj))

(define-macro (^array-literal type elems)
  `(univ-emit-array-literal ctx ,type ,elems))

(define-macro (^extensible-array-literal type elems)
  `(univ-emit-extensible-array-literal ctx ,type ,elems))

(define-macro (^new-array type len)
  `(univ-emit-new-array ctx ,type ,len))

(define-macro (^make-array type return len init)
  `(univ-emit-make-array ctx ,type ,return ,len ,init))

(define-macro (^call-prim expr . params)
  `(univ-emit-call-prim ctx ,expr ,@params))

(define-macro (^call-member expr fct . params)
  `(univ-emit-call-member ctx ,expr ,fct ,@params))

(define-macro (^jump expr . params)
  `(univ-emit-jump ctx ,expr ,@params))

(define-macro (^apply expr params)
  `(univ-emit-apply ctx ,expr ,params))

(define-macro (^this)
  `(univ-emit-this ctx))

(define-macro (^new type . params)
  `(univ-emit-new ctx ,type ,@params))

(define-macro (^new* class params)
  `(univ-emit-new* ctx ,class ,params))

(define-macro (^construct class . params)
  `(univ-emit-construct ctx ,class ,@params))

(define-macro (^construct* class params)
  `(univ-emit-construct* ctx ,class ,params))

(define-macro (^typeof type expr)
  `(univ-emit-typeof ctx ,type ,expr))

(define-macro (^instanceof class expr)
  `(univ-emit-instanceof ctx ,class ,expr))

(define-macro (^getopnd opnd)
  `(univ-emit-getopnd ctx ,opnd))

(define-macro (^setloc loc val)
  `(univ-emit-setloc ctx ,loc ,val))

(define-macro (^var-decl var-descr)
  `(univ-emit-var-decl ctx ,var-descr))

(define-macro (^decl type name)
  `(univ-emit-decl ctx ,type ,name))

(define-macro (^type type)
  `(univ-emit-type ctx ,type))

(define-macro (^procedure-declaration
               global?
               proc-type
               root-name
               params
               header
               attribs
               body)
  `(univ-emit-procedure-declaration
    ctx
    ,global?
    ,proc-type
    ,root-name
    ,params
    ,attribs
    (univ-emit-fn-body ctx ,header (lambda (ctx) ,body))))

;;TODO: remove
(define-macro (^prim-function-declaration
               root-name
               result-type
               params
               header
               attribs
               body)
  `(univ-emit-function-declaration
    ctx
    #t
    ,root-name
    ,result-type
    ,params
    ,attribs
    (univ-emit-fn-body ctx ,header (lambda (ctx) ,body))
    #f
    #t))

(define-macro (^tos)
  `(univ-emit-tos ctx))

(define-macro (^pop receiver)
  `(univ-emit-pop ctx ,receiver))

(define-macro (^push val)
  `(univ-emit-push ctx ,val))

(define-macro (^getnargs)
  `(univ-emit-getnargs ctx))

(define-macro (^setnargs nb-args)
  `(univ-emit-setnargs ctx ,nb-args))

(define-macro (^getreg num)
  `(univ-emit-getreg ctx ,num))

(define-macro (^setreg num val)
  `(univ-emit-setreg ctx ,num ,val))

(define-macro (^getstk offset)
  `(univ-emit-getstk ctx ,offset))

(define-macro (^setstk offset val)
  `(univ-emit-setstk ctx ,offset ,val))

(define-macro (^getclo closure index)
  `(univ-emit-getclo ctx ,closure ,index))

(define-macro (^setclo closure index val)
  `(univ-emit-setclo ctx ,closure ,index ,val))

(define-macro (^getpeps name)
  `(univ-emit-getpeps ctx ,name))

(define-macro (^setpeps name val)
  `(univ-emit-setpeps ctx ,name ,val))

(define-macro (^getglo name)
  `(univ-emit-getglo ctx ,name))

(define-macro (^setglo name val)
  `(univ-emit-setglo ctx ,name ,val))

(define-macro (^glo-var-ref sym)
  `(univ-emit-glo-var-ref ctx ,sym))

(define-macro (^glo-var-primitive-ref sym)
  `(univ-emit-glo-var-primitive-ref ctx ,sym))

(define-macro (^glo-var-set! sym val)
  `(univ-emit-glo-var-set! ctx ,sym ,val))

(define-macro (^glo-var-primitive-set! sym val)
  `(univ-emit-glo-var-primitive-set! ctx ,sym ,val))

(define-macro (^return-poll expr poll? call?)
  `(univ-emit-return-poll ctx ,expr ,poll? ,call?))

(define-macro (^return-call-prim expr . params)
  `(univ-emit-return-call-prim ctx ,expr ,@params))

(define-macro (^return-jump expr)
  `(univ-emit-return-jump ctx ,expr))

(define-macro (^return expr)
  `(univ-emit-return ctx ,expr))



(define-macro (^map fn array)
  `(univ-emit-map ctx ,fn ,array))

(define-macro (^call-with-arg-array fn vals)
  `(univ-emit-call-with-arg-array ctx ,fn ,vals))

;;
;; Host vs Scheme type correspondance
;;
;; ==============================
;; | Host       | Scheme        |
;; ==============================
;; | void       | void-obj      |
;; | null       | null-obj      |
;; | bool       | boolean       |
;; | int        | fixnum        |
;; | float      | flonum        |
;; | str        | string        |
;; | array      |               |
;; | object     |               |
;; |            | list          |
;; | function   | procedure     |
;; ==============================
;;

(define-macro (^null)
  `(univ-emit-null ctx))

(define-macro (^null? expr)
  `(univ-emit-null? ctx ,expr))

(define-macro (^null-obj)
  `(univ-emit-null-obj ctx))

(define-macro (^null-obj? expr)
  `(univ-emit-null-obj? ctx ,expr))

(define-macro (^void)
  `(univ-emit-void ctx))

(define-macro (^void? expr)
  `(univ-emit-void? ctx ,expr))

(define-macro (^void-obj)
  `(univ-emit-void-obj ctx))

(define-macro (^str->string expr)
  `(univ-emit-str->string ctx ,expr))

(define-macro (^string->str expr)
  `(univ-emit-string->str ctx ,expr))

(define-macro (^void-obj? expr)
  `(univ-emit-void-obj? ctx ,expr))

(define-macro (^str? expr)
  `(univ-emit-str? ctx ,expr))

(define-macro (^float? expr)
  `(univ-emit-float? ctx ,expr))

(define-macro (^int? expr)
  `(univ-emit-int? ctx ,expr))

(define-macro (^eof)
  `(univ-emit-eof ctx))

(define-macro (^absent)
  `(univ-emit-absent ctx))

(define-macro (^deleted)
  `(univ-emit-deleted ctx))

(define-macro (^unused)
  `(univ-emit-unused ctx))

(define-macro (^unbound1)
  `(univ-emit-unbound1 ctx))

(define-macro (^unbound2)
  `(univ-emit-unbound2 ctx))

(define-macro (^unbound? val)
  `(univ-emit-unbound? ctx ,val))

(define-macro (^optional)
  `(univ-emit-optional ctx))

(define-macro (^key)
  `(univ-emit-key ctx))

(define-macro (^rest)
  `(univ-emit-rest ctx))

(define-macro (^bool val)
  `(univ-emit-bool ctx ,val))

(define-macro (^bool? val)
  `(univ-emit-bool? ctx ,val))

(define-macro (^boolean-obj obj)
  `(univ-emit-boolean-obj ctx ,obj))

(define-macro (^boolean-box val)
  `(univ-emit-boolean-box ctx ,val))

(define-macro (^boolean-unbox boolean)
  `(univ-emit-boolean-unbox ctx ,boolean))

(define-macro (^boolean? val)
  `(univ-emit-boolean? ctx ,val))

(define-macro (^chr val)
  `(univ-emit-chr ctx ,val))

(define-macro (^char-obj obj force-var?)
  `(univ-emit-char-obj ctx ,obj ,force-var?))

(define-macro (^char-box val)
  `(univ-emit-char-box ctx ,val))

(define-macro (^char-box-uninterned val)
  `(univ-emit-char-box-uninterned ctx ,val))

(define-macro (^char-unbox char)
  `(univ-emit-char-unbox ctx ,char))

(define-macro (^chr-fromint val)
  `(univ-emit-chr-fromint ctx ,val))

(define-macro (^chr-toint val)
  `(univ-emit-chr-toint ctx ,val))

(define-macro (^chr-tostr val)
  `(univ-emit-chr-tostr ctx ,val))

(define-macro (^char? val)
  `(univ-emit-char? ctx ,val))

(define-macro (^int val)
  `(univ-emit-int ctx ,val))

(define-macro (^num-of-type type val)
  `(univ-emit-num-of-type ctx ,type ,val))

(define-macro (^fixnum-box val)
  `(univ-emit-fixnum-box ctx ,val))

(define-macro (^fixnum-unbox fixnum)
  `(univ-emit-fixnum-unbox ctx ,fixnum))

(define-macro (^fixnum? val)
  `(univ-emit-fixnum? ctx ,val))

(define-macro (^empty-dict type)
  `(univ-emit-empty-dict ctx ,type))

(define-macro (^dict-key-exists? expr1 expr2)
  `(univ-emit-dict-key-exists? ctx ,expr1 ,expr2))

(define-macro (^dict-get type expr1 expr2 #!optional (expr3 #f))
  `(univ-emit-dict-get ctx ,type ,expr1 ,expr2 ,expr3))

(define-macro (^dict-get-or-null type expr1 expr2)
  `(univ-emit-dict-get-or-null ctx ,type ,expr1 ,expr2))

(define-macro (^dict-set type expr1 expr2 expr3)
  `(univ-emit-dict-set ctx ,type ,expr1 ,expr2 ,expr3))

(define-macro (^dict-delete expr1 expr2)
  `(univ-emit-dict-delete ctx ,expr1 ,expr2))

(define-macro (^dict-length expr)
  `(univ-emit-dict-length ctx ,expr))

(define-macro (^member expr name)
  `(univ-emit-member ctx ,expr ,name))

(define-macro (^public name)
  `(univ-emit-public ctx ,name))

(define-macro (^pair? expr)
  `(univ-emit-pair? ctx ,expr))

(define-macro (^cons expr1 expr2)
  `(univ-emit-cons ctx ,expr1 ,expr2))

(define-macro (^getcar expr)
  `(univ-emit-getcar ctx ,expr))

(define-macro (^getcdr expr)
  `(univ-emit-getcdr ctx ,expr))

(define-macro (^setcar expr1 expr2)
  `(univ-emit-setcar ctx ,expr1 ,expr2))

(define-macro (^setcdr expr1 expr2)
  `(univ-emit-setcdr ctx ,expr1 ,expr2))

(define-macro (^float val)
  `(univ-emit-float ctx ,val))

(define-macro (^float-fromint val)
  `(univ-emit-float-fromint ctx ,val))

(define-macro (^float-toint val)
  `(univ-emit-float-toint ctx ,val))

(define-macro (^float-math fn . params)
  `(univ-emit-float-math ctx ,fn ,@params))

(define-macro (^float-abs val)
  `(univ-emit-float-abs ctx ,val))

(define-macro (^float-floor val)
  `(univ-emit-float-floor ctx ,val))

(define-macro (^float-ceiling val)
  `(univ-emit-float-ceiling ctx ,val))

(define-macro (^float-truncate val)
  `(univ-emit-float-truncate ctx ,val))

(define-macro (^float-round-half-up val)
  `(univ-emit-float-round-half-up ctx ,val))

(define-macro (^float-round-half-towards-0 val)
  `(univ-emit-float-round-half-towards-0 ctx ,val))

(define-macro (^float-round-half-to-even val)
  `(univ-emit-float-round-half-to-even ctx ,val))

(define-macro (^float-mod val1 val2)
  `(univ-emit-float-mod ctx ,val1 ,val2))

(define-macro (^float-exp val)
  `(univ-emit-float-exp ctx ,val))

(define-macro (^float-expm1 val)
  `(univ-emit-float-expm1 ctx ,val))

(define-macro (^float-log val)
  `(univ-emit-float-log ctx ,val))

(define-macro (^float-log1p val)
  `(univ-emit-float-log1p ctx ,val))

(define-macro (^float-sin val)
  `(univ-emit-float-sin ctx ,val))

(define-macro (^float-cos val)
  `(univ-emit-float-cos ctx ,val))

(define-macro (^float-tan val)
  `(univ-emit-float-tan ctx ,val))

(define-macro (^float-asin val)
  `(univ-emit-float-asin ctx ,val))

(define-macro (^float-acos val)
  `(univ-emit-float-acos ctx ,val))

(define-macro (^float-atan val)
  `(univ-emit-float-atan ctx ,val))

(define-macro (^float-atan2 val1 val2)
  `(univ-emit-float-atan2 ctx ,val1 ,val2))

(define-macro (^float-sinh val)
  `(univ-emit-float-sinh ctx ,val))

(define-macro (^float-cosh val)
  `(univ-emit-float-cosh ctx ,val))

(define-macro (^float-tanh val)
  `(univ-emit-float-tanh ctx ,val))

(define-macro (^float-asinh val)
  `(univ-emit-float-asinh ctx ,val))

(define-macro (^float-acosh val)
  `(univ-emit-float-acosh ctx ,val))

(define-macro (^float-atanh val)
  `(univ-emit-float-atanh ctx ,val))

(define-macro (^float-expt val1 val2)
  `(univ-emit-float-expt ctx ,val1 ,val2))

(define-macro (^float-sqrt val)
  `(univ-emit-float-sqrt ctx ,val))

(define-macro (^float-scalbn val1 val2)
  `(univ-emit-float-scalbn ctx ,val1 ,val2))

(define-macro (^float-ilogb val)
  `(univ-emit-float-ilogb ctx ,val))

(define-macro (^float-integer? val)
  `(univ-emit-float-integer? ctx ,val))

(define-macro (^float-finite? val)
  `(univ-emit-float-finite? ctx ,val))

(define-macro (^float-infinite? val)
  `(univ-emit-float-infinite? ctx ,val))

(define-macro (^float-nan? val)
  `(univ-emit-float-nan? ctx ,val))

(define-macro (^float-copysign val1 val2)
  `(univ-emit-float-copysign ctx ,val1 ,val2))

(define-macro (^float-eqv? val1 val2)
  `(univ-emit-float-eqv? ctx ,val1 ,val2))

(define-macro (^flonum-box val)
  `(univ-emit-flonum-box ctx ,val))

(define-macro (^flonum-unbox flonum)
  `(univ-emit-flonum-unbox ctx ,flonum))

(define-macro (^flonum? val)
  `(univ-emit-flonum? ctx ,val))

(define-macro (^cpxnum-make expr1 expr2)
  `(univ-emit-cpxnum-make ctx ,expr1 ,expr2))

(define-macro (^cpxnum? val)
  `(univ-emit-cpxnum? ctx ,val))

(define-macro (^ratnum-make expr1 expr2)
  `(univ-emit-ratnum-make ctx ,expr1 ,expr2))

(define-macro (^ratnum? val)
  `(univ-emit-ratnum? ctx ,val))

(define-macro (^bignum expr1 expr2)
  `(univ-emit-bignum ctx ,expr1 ,expr2))

(define-macro (^bignum? val)
  `(univ-emit-bignum? ctx ,val))

(define-macro (^bignum-digits val)
  `(univ-emit-bignum-digits ctx ,val))

(define-macro (^u32-box val)
  `(univ-emit-u32-box ctx ,val))

(define-macro (^u32-unbox u32)
  `(univ-emit-u32-unbox ctx ,u32))

(define-macro (^s32-box val)
  `(univ-emit-s32-box ctx ,val))

(define-macro (^s32-unbox s32)
  `(univ-emit-s32-unbox ctx ,s32))

(define-macro (^u64-box val)
  `(univ-emit-u64-box ctx ,val))

(define-macro (^u64-unbox u64)
  `(univ-emit-u64-unbox ctx ,u64))

(define-macro (^s64-box val)
  `(univ-emit-s64-box ctx ,val))

(define-macro (^s64-unbox s64)
  `(univ-emit-s64-unbox ctx ,s64))

(define-macro (^box? val)
  `(univ-emit-box? ctx ,val))

(define-macro (^box val)
  `(univ-emit-box ctx ,val))

(define-macro (^unbox val)
  `(univ-emit-unbox ctx ,val))

(define-macro (^setbox val1 val2)
  `(univ-emit-setbox ctx ,val1 ,val2))

(define-macro (^values-box val)
  `(univ-emit-values-box ctx ,val))

(define-macro (^values-unbox values)
  `(univ-emit-values-unbox ctx ,values))

(define-macro (^values? val)
  `(univ-emit-values? ctx ,val))

(define-macro (^values-length val)
  `(univ-emit-values-length ctx ,val))

(define-macro (^values-ref val1 val2)
  `(univ-emit-values-ref ctx ,val1 ,val2))

(define-macro (^values-set! val1 val2 val3)
  `(univ-emit-values-set! ctx ,val1 ,val2 ,val3))

(define-macro (^vect-box type val)
  `(univ-emit-vect-box ctx ,type ,val))

(define-macro (^vect-unbox type vect)
  `(univ-emit-vect-unbox ctx ,type ,vect))

(define-macro (^vect? type val)
  `(univ-emit-vect? ctx ,type ,val))

(define-macro (^vector-box val)
  `(univ-emit-vector-box ctx ,val))

(define-macro (^vector-unbox vector)
  `(univ-emit-vector-unbox ctx ,vector))

(define-macro (^vector? val)
  `(univ-emit-vector? ctx ,val))

(define-macro (^vector-length val)
  `(univ-emit-vector-length ctx ,val))

(define-macro (^vector-shrink! val1 val2)
  `(univ-emit-vector-shrink! ctx ,val1 ,val2))

(define-macro (^vector-ref val1 val2)
  `(univ-emit-vector-ref ctx ,val1 ,val2))

(define-macro (^vector-set! val1 val2 val3)
  `(univ-emit-vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^u8vector-box val)
  `(univ-emit-u8vector-box ctx ,val))

(define-macro (^u8vector-unbox u8vector)
  `(univ-emit-u8vector-unbox ctx ,u8vector))

(define-macro (^u8vector? val)
  `(univ-emit-u8vector? ctx ,val))

(define-macro (^u8vector-length val)
  `(univ-emit-u8vector-length ctx ,val))

(define-macro (^u8vector-shrink! val1 val2)
  `(univ-emit-u8vector-shrink! ctx ,val1 ,val2))

(define-macro (^u8vector-ref val1 val2)
  `(univ-emit-u8vector-ref ctx ,val1 ,val2))

(define-macro (^u8vector-set! val1 val2 val3)
  `(univ-emit-u8vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^u16vector-box val)
  `(univ-emit-u16vector-box ctx ,val))

(define-macro (^u16vector-unbox u16vector)
  `(univ-emit-u16vector-unbox ctx ,u16vector))

(define-macro (^u16vector? val)
  `(univ-emit-u16vector? ctx ,val))

(define-macro (^u16vector-length val)
  `(univ-emit-u16vector-length ctx ,val))

(define-macro (^u16vector-shrink! val1 val2)
  `(univ-emit-u16vector-shrink! ctx ,val1 ,val2))

(define-macro (^u16vector-ref val1 val2)
  `(univ-emit-u16vector-ref ctx ,val1 ,val2))

(define-macro (^u16vector-set! val1 val2 val3)
  `(univ-emit-u16vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^u32vector-box val)
  `(univ-emit-u32vector-box ctx ,val))

(define-macro (^u32vector-unbox u32vector)
  `(univ-emit-u32vector-unbox ctx ,u32vector))

(define-macro (^u32vector? val)
  `(univ-emit-u32vector? ctx ,val))

(define-macro (^u32vector-length val)
  `(univ-emit-u32vector-length ctx ,val))

(define-macro (^u32vector-shrink! val1 val2)
  `(univ-emit-u32vector-shrink! ctx ,val1 ,val2))

(define-macro (^u32vector-ref val1 val2)
  `(univ-emit-u32vector-ref ctx ,val1 ,val2))

(define-macro (^u32vector-set! val1 val2 val3)
  `(univ-emit-u32vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^u64vector-box val)
  `(univ-emit-u64vector-box ctx ,val))

(define-macro (^u64vector-unbox val)
  `(univ-emit-u64vector-unbox ctx ,val))

(define-macro (^u64vector? val)
  `(univ-emit-u64vector? ctx ,val))

(define-macro (^u64vector-length val)
  `(univ-emit-u64vector-length ctx ,val))

(define-macro (^u64vector-shrink! val1 val2)
  `(univ-emit-u64vector-shrink! ctx ,val1 ,val2))

(define-macro (^u64vector-ref val1 val2)
  `(univ-emit-u64vector-ref ctx ,val1 ,val2))

(define-macro (^u64vector-set! val1 val2 val3)
  `(univ-emit-u64vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^s8vector-box val)
  `(univ-emit-s8vector-box ctx ,val))

(define-macro (^s8vector-unbox val)
  `(univ-emit-s8vector-unbox ctx ,val))

(define-macro (^s8vector? val)
  `(univ-emit-s8vector? ctx ,val))

(define-macro (^s8vector-length val)
  `(univ-emit-s8vector-length ctx ,val))

(define-macro (^s8vector-shrink! val1 val2)
  `(univ-emit-s8vector-shrink! ctx ,val1 ,val2))

(define-macro (^s8vector-ref val1 val2)
  `(univ-emit-s8vector-ref ctx ,val1 ,val2))

(define-macro (^s8vector-set! val1 val2 val3)
  `(univ-emit-s8vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^s16vector-box val)
  `(univ-emit-s16vector-box ctx ,val))

(define-macro (^s16vector-unbox val)
  `(univ-emit-s16vector-unbox ctx ,val))

(define-macro (^s16vector? val)
  `(univ-emit-s16vector? ctx ,val))

(define-macro (^s16vector-length val)
  `(univ-emit-s16vector-length ctx ,val))

(define-macro (^s16vector-shrink! val1 val2)
  `(univ-emit-s16vector-shrink! ctx ,val1 ,val2))

(define-macro (^s16vector-ref val1 val2)
  `(univ-emit-s16vector-ref ctx ,val1 ,val2))

(define-macro (^s16vector-set! val1 val2 val3)
  `(univ-emit-s16vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^s32vector-box val)
  `(univ-emit-s32vector-box ctx ,val))

(define-macro (^s32vector-unbox val)
  `(univ-emit-s32vector-unbox ctx ,val))

(define-macro (^s32vector? val)
  `(univ-emit-s32vector? ctx ,val))

(define-macro (^s32vector-length val)
  `(univ-emit-s32vector-length ctx ,val))

(define-macro (^s32vector-shrink! val1 val2)
  `(univ-emit-s32vector-shrink! ctx ,val1 ,val2))

(define-macro (^s32vector-ref val1 val2)
  `(univ-emit-s32vector-ref ctx ,val1 ,val2))

(define-macro (^s32vector-set! val1 val2 val3)
  `(univ-emit-s32vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^s64vector-box val)
  `(univ-emit-s64vector-box ctx ,val))

(define-macro (^s64vector-unbox val)
  `(univ-emit-s64vector-unbox ctx ,val))

(define-macro (^s64vector? val)
  `(univ-emit-s64vector? ctx ,val))

(define-macro (^s64vector-length val)
  `(univ-emit-s64vector-length ctx ,val))

(define-macro (^s64vector-shrink! val1 val2)
  `(univ-emit-s64vector-shrink! ctx ,val1 ,val2))

(define-macro (^s64vector-ref val1 val2)
  `(univ-emit-s64vector-ref ctx ,val1 ,val2))

(define-macro (^s64vector-set! val1 val2 val3)
  `(univ-emit-s64vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^f32vector-box val)
  `(univ-emit-f32vector-box ctx ,val))

(define-macro (^f32vector-unbox val)
  `(univ-emit-f32vector-unbox ctx ,val))

(define-macro (^f32vector? val)
  `(univ-emit-f32vector? ctx ,val))

(define-macro (^f32vector-length val)
  `(univ-emit-f32vector-length ctx ,val))

(define-macro (^f32vector-shrink! val1 val2)
  `(univ-emit-f32vector-shrink! ctx ,val1 ,val2))

(define-macro (^f32vector-ref val1 val2)
  `(univ-emit-f32vector-ref ctx ,val1 ,val2))

(define-macro (^f32vector-set! val1 val2 val3)
  `(univ-emit-f32vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^f64vector-box val)
  `(univ-emit-f64vector-box ctx ,val))

(define-macro (^f64vector-unbox f64vector)
  `(univ-emit-f64vector-unbox ctx ,f64vector))

(define-macro (^f64vector? val)
  `(univ-emit-f64vector? ctx ,val))

(define-macro (^f64vector-length val)
  `(univ-emit-f64vector-length ctx ,val))

(define-macro (^f64vector-shrink! val1 val2)
  `(univ-emit-f64vector-shrink! ctx ,val1 ,val2))

(define-macro (^f64vector-ref val1 val2)
  `(univ-emit-f64vector-ref ctx ,val1 ,val2))

(define-macro (^f64vector-set! val1 val2 val3)
  `(univ-emit-f64vector-set! ctx ,val1 ,val2 ,val3))

(define-macro (^structure-box val)
  `(univ-emit-structure-box ctx ,val))

(define-macro (^structure-unbox structure)
  `(univ-emit-structure-unbox ctx ,structure))

(define-macro (^structure? val)
  `(univ-emit-structure? ctx ,val))

(define-macro (^structure-ref val1 val2)
  `(univ-emit-structure-ref ctx ,val1 ,val2))

(define-macro (^structure-set! val1 val2 val3)
  `(univ-emit-structure-set! ctx ,val1 ,val2 ,val3))

(define-macro (^str val)
  `(univ-emit-str ctx ,val))

(define-macro (^str-to-codes str)
  `(univ-emit-str-to-codes ctx ,str))

(define-macro (^str-length str)
  `(univ-emit-str-length ctx ,str))

(define-macro (^str-index-code str i)
  `(univ-emit-str-index-code ctx ,str ,i))

(define-macro (^string-obj obj force-var?)
  `(univ-emit-string-obj ctx ,obj ,force-var?))

(define-macro (^string-box val)
  `(univ-emit-string-box ctx ,val))

(define-macro (^string-unbox string)
  `(univ-emit-string-unbox ctx ,string))

(define-macro (^string? val)
  `(univ-emit-string? ctx ,val))

(define-macro (^string-length val)
  `(univ-emit-string-length ctx ,val))

(define-macro (^string-shrink! val1 val2)
  `(univ-emit-string-shrink! ctx ,val1 ,val2))

(define-macro (^string-ref val1 val2)
  `(univ-emit-string-ref ctx ,val1 ,val2))

(define-macro (^string-set! val1 val2 val3)
  `(univ-emit-string-set! ctx ,val1 ,val2 ,val3))

(define-macro (^substring val1 val2 val3)
  `(univ-emit-substring ctx ,val1 ,val2 ,val3))

(define-macro (^str-toint val)
  `(univ-emit-str-toint ctx ,val))

(define-macro (^str-tofloat val)
  `(univ-emit-str-toint ctx ,val))

(define-macro (^symbol-obj obj force-var?)
  `(univ-emit-symbol-obj ctx ,obj ,force-var?))

(define-macro (^symbol-box name)
  `(univ-emit-symbol-box ctx ,name))

(define-macro (^symbol-box-uninterned name hash)
  `(univ-emit-symbol-box-uninterned ctx ,name ,hash))

(define-macro (^symbol-unbox symbol)
  `(univ-emit-symbol-unbox ctx ,symbol))

(define-macro (^symbol? val)
  `(univ-emit-symbol? ctx ,val))

(define-macro (^keyword-obj obj force-var?)
  `(univ-emit-keyword-obj ctx ,obj ,force-var?))

(define-macro (^keyword-box name)
  `(univ-emit-keyword-box ctx ,name))

(define-macro (^keyword-box-uninterned name hash)
  `(univ-emit-keyword-box-uninterned ctx ,name ,hash))

(define-macro (^keyword-unbox keyword)
  `(univ-emit-keyword-unbox ctx ,keyword))

(define-macro (^keyword? val)
  `(univ-emit-keyword? ctx ,val))

(define-macro (^frame-box expr)
  `(univ-emit-frame-box ctx ,expr))

(define-macro (^frame-unbox expr)
  `(univ-emit-frame-unbox ctx ,expr))

(define-macro (^frame-slots expr)
  `(univ-emit-frame-slots ctx ,expr))

(define-macro (^frame? val)
  `(univ-emit-frame? ctx ,val))

(define-macro (^new-continuation expr1 expr2)
  `(univ-emit-new-continuation ctx ,expr1 ,expr2))

(define-macro (^continuation? val)
  `(univ-emit-continuation? ctx ,val))

(define-macro (^function? val)
  `(univ-emit-function? ctx ,val))

(define-macro (^procedure? val)
  `(univ-emit-procedure? ctx ,val))

(define-macro (^return? val)
  `(univ-emit-return? ctx ,val))

(define-macro (^closure? val)
  `(univ-emit-closure? ctx ,val))

(define-macro (^closure-length val)
  `(univ-emit-closure-length ctx ,val))

(define-macro (^closure-code val)
  `(univ-emit-closure-code ctx ,val))

(define-macro (^closure-ref val1 val2)
  `(univ-emit-closure-ref ctx ,val1 ,val2))

(define-macro (^closure-set! val1 val2 val3)
  `(univ-emit-closure-set! ctx ,val1 ,val2 ,val3))

(define-macro (^new-delay-promise expr)
  `(univ-emit-new-delay-promise ctx ,expr))

(define-macro (^promise? val)
  `(univ-emit-promise? ctx ,val))

(define-macro (^new-will expr1 expr2)
  `(univ-emit-new-will ctx ,expr1 ,expr2))

(define-macro (^will? val)
  `(univ-emit-will? ctx ,val))

(define-macro (^new-foreign expr1 expr2)
  `(univ-emit-new-foreign ctx ,expr1 ,expr2))

(define-macro (^foreign? val)
  `(univ-emit-foreign? ctx ,val))

(define-macro (^popcount! arg)
  `(univ-emit-popcount! ctx ,arg))

(define-macro (^host-primitive? arg)
  `(univ-emit-host-primitive? ctx ,arg))
